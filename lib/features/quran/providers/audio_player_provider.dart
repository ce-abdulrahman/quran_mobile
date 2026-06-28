import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quran_providers.dart';
import '../../../core/repositories/audio_repository.dart';
import '../../../core/models/recitation_models.dart';
import '../../../core/services/audio_download_manager.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/services/audio_session_handler.dart';
import '../../../core/services/playback_state_bridge.dart';
import '../../../core/services/sleep_timer_service.dart';
import '../../../core/services/audio_quality_manager.dart';
import '../../../core/services/audio_event_bus.dart';

class AudioPlayerState {
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final int? currentAyahNumber;
  final int selectedReciterId;
  final double speed;
  final bool isAutoScrollEnabled;
  final String? errorMessage;
  final String? streamUrl;
  final RecitationEngineState engineState;
  final RecitationSettings settings;
  final RecitationSession session;
  final int gapRemainingSeconds;
  final SessionRecoveryState sessionRecoveryState;
  final SleepTimerState sleepTimerState;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.currentAyahNumber,
    required this.selectedReciterId,
    this.speed = 1.0,
    this.isAutoScrollEnabled = true,
    this.errorMessage,
    this.streamUrl,
    this.engineState = RecitationEngineState.idle,
    this.settings = const RecitationSettings(),
    this.session = const RecitationSession(),
    this.gapRemainingSeconds = 0,
    this.sessionRecoveryState = SessionRecoveryState.none,
    this.sleepTimerState = const SleepTimerState(),
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    int? currentAyahNumber,
    int? selectedReciterId,
    double? speed,
    bool? isAutoScrollEnabled,
    String? errorMessage,
    String? streamUrl,
    RecitationEngineState? engineState,
    RecitationSettings? settings,
    RecitationSession? session,
    int? gapRemainingSeconds,
    SessionRecoveryState? sessionRecoveryState,
    SleepTimerState? sleepTimerState,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      currentAyahNumber: currentAyahNumber ?? this.currentAyahNumber,
      selectedReciterId: selectedReciterId ?? this.selectedReciterId,
      speed: speed ?? this.speed,
      isAutoScrollEnabled: isAutoScrollEnabled ?? this.isAutoScrollEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
      streamUrl: streamUrl ?? this.streamUrl,
      engineState: engineState ?? this.engineState,
      settings: settings ?? this.settings,
      session: session ?? this.session,
      gapRemainingSeconds: gapRemainingSeconds ?? this.gapRemainingSeconds,
      sessionRecoveryState: sessionRecoveryState ?? this.sessionRecoveryState,
      sleepTimerState: sleepTimerState ?? this.sleepTimerState,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final Ref ref;
  late final AudioPlayer _audioPlayer;
  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _stateSub;
  Map<int, AyahTimingModel> _timings = {};
  int? _loadedSurahId;

  Timer? _gapTimer;
  DateTime? _gapEndTime;

  late final AudioSessionHandler _audioSessionHandler;
  late final PlaybackStateBridge _playbackStateBridge;
  late final SleepTimerService _sleepTimerService;

  AudioPlayerNotifier(this.ref)
      : super(AudioPlayerState(
          selectedReciterId: 1,
          engineState: RecitationEngineState.idle,
          settings: _loadSettings(ref.read(sharedPreferencesProvider)),
          session: _loadSession(ref.read(sharedPreferencesProvider)),
        )) {
    _audioPlayer = AudioPlayer();

    _audioSessionHandler = AudioSessionHandler(
      onPause: () => pause(),
      onResume: () => play(),
    );

    _playbackStateBridge = PlaybackStateBridge(
      onPlay: () => play(),
      onPause: () => pause(),
      onSeek: (pos) => seek(pos),
      onNext: () => _playNextSection(),
      onPrevious: () => _playPreviousSection(),
    );

    _sleepTimerService = SleepTimerService(
      onTimerExpired: () {
        pause();
        _updateStateAsync(state.copyWith(
          engineState: RecitationEngineState.completed,
        ));
      },
    );

    _init();
    
    _checkSavedSessionOnStartup();
  }

  void _checkSavedSessionOnStartup() {
    final session = state.session;
    if (session.playbackPositionMs > 0 && !session.endedCleanly) {
      _updateState(state.copyWith(
        sessionRecoveryState: SessionRecoveryState.available,
      ));
    } else {
      Future.microtask(() => loadSurah(session.currentSurahId));
    }
  }

  static RecitationSettings _loadSettings(SharedPreferences prefs) {
    final raw = prefs.getString('recitation_settings');
    if (raw == null) return const RecitationSettings();
    try {
      return RecitationSettings.fromJson(jsonDecode(raw));
    } catch (_) {
      return const RecitationSettings();
    }
  }

  static RecitationSession _loadSession(SharedPreferences prefs) {
    final raw = prefs.getString('recitation_session');
    if (raw == null) return const RecitationSession();
    try {
      return RecitationSession.fromJson(jsonDecode(raw));
    } catch (_) {
      return const RecitationSession();
    }
  }

  void _updateState(AudioPlayerState newState) {
    if (!mounted) return;
    state = newState;
  }

  void _updateStateAsync(AudioPlayerState newState) {
    if (!mounted) return;
    Future.microtask(() {
      if (mounted) {
        state = newState;
      }
    });
  }

  void _saveSettings() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString('recitation_settings', jsonEncode(state.settings.toJson()));
  }

  void _saveSession() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString('recitation_session', jsonEncode(state.session.toJson()));
  }

  void _init() {
    _audioSessionHandler.initialize();
    _playbackStateBridge.initialize();

    _sleepTimerService.stateStream.listen((timerState) {
      if (!mounted) return;
      Future.microtask(() {
        if (mounted) {
          state = state.copyWith(sleepTimerState: timerState);
        }
      });
    });

    _posSub = _audioPlayer.onPositionChanged.listen((pos) {
      if (!mounted) return;
      Future.microtask(() {
        if (!mounted) return;
        final updatedSession = state.session.copyWith(
          playbackPositionMs: pos.inMilliseconds,
          lastSavedPositionMs: pos.inMilliseconds,
          endedCleanly: false,
          interruptedState: state.engineState.name,
        );
        state = state.copyWith(
          position: pos,
          session: updatedSession,
        );
        _saveSession();

        _updateCurrentAyah(pos);
        _checkRangeLimit(pos);
        _updateLockScreenMetadata();
      });
    });

    _durSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (!mounted) return;
      Future.microtask(() {
        if (!mounted) return;
        state = state.copyWith(duration: dur);
        _updateLockScreenMetadata();
      });
    });

    _stateSub = _audioPlayer.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      Future.microtask(() async {
        if (!mounted) return;
        
        final isPlaying = s == PlayerState.playing;
        
        state = state.copyWith(
          isPlaying: isPlaying,
          isLoading: false,
          engineState: isPlaying 
              ? RecitationEngineState.playing 
              : (state.engineState == RecitationEngineState.waitingGap 
                  ? RecitationEngineState.waitingGap 
                  : state.engineState == RecitationEngineState.completed
                      ? RecitationEngineState.completed
                      : RecitationEngineState.idle),
        );

        _updateLockScreenMetadata();

        if (isPlaying) {
          AudioEventBus().fire(PlayStartedEvent(
            reciterId: state.selectedReciterId,
            surahId: state.session.currentSurahId,
            ayahId: state.currentAyahNumber ?? state.session.currentAyahNumber,
          ));
        } else if (s == PlayerState.paused || s == PlayerState.stopped) {
          AudioEventBus().fire(PlayPausedEvent(
            reciterId: state.selectedReciterId,
            surahId: state.session.currentSurahId,
            ayahId: state.currentAyahNumber ?? state.session.currentAyahNumber,
          ));
        }

        if (s == PlayerState.completed) {
          final updatedSession = state.session.copyWith(
            endedCleanly: true,
            interruptedState: null,
          );
          state = state.copyWith(session: updatedSession);
          _saveSession();

          _sleepTimerService.handleSurahCompleted();

          if (state.settings.repeatMode == RepeatMode.none) {
            await _handleSurahCompleted();
          }
        }
      });
    });
  }

  void _updateLockScreenMetadata() {
    final recitersAsync = ref.read(recitersProvider);
    final surahsAsync = ref.read(surahListProvider);

    String reciterName = 'Reciter ${state.selectedReciterId}';
    String surahName = 'Surah ${state.session.currentSurahId}';

    recitersAsync.whenData((reciters) {
      final reciter = reciters.where((r) => r.id == state.selectedReciterId).firstOrNull;
      if (reciter != null) {
        reciterName = reciter.name;
      }
    });

    surahsAsync.whenData((surahs) {
      final surah = surahs.where((s) => s.id == state.session.currentSurahId).firstOrNull;
      if (surah != null) {
        surahName = surah.nameEn;
      }
    });

    final metadata = MediaPlaybackMetadata(
      reciterName: reciterName,
      surahName: surahName,
      ayahNumber: state.session.currentAyahNumber,
      playbackSpeed: state.speed,
      isPlaying: state.isPlaying,
      duration: state.duration,
      position: state.position,
    );

    _playbackStateBridge.updateMetadata(metadata);
  }

  void _updateCurrentAyah(Duration pos) {
    if (_timings.isEmpty) return;

    final seconds = pos.inMilliseconds / 1000.0;
    int? activeAyah;

    for (final entry in _timings.entries) {
      if (seconds >= entry.value.startTime && seconds < entry.value.endTime) {
        activeAyah = entry.key;
        break;
      }
    }

    if (activeAyah != null && activeAyah != state.session.currentAyahNumber) {
      final updatedSession = state.session.copyWith(currentAyahNumber: activeAyah);
      state = state.copyWith(
        currentAyahNumber: activeAyah,
        session: updatedSession,
      );
      _saveSession();

      AudioEventBus().fire(AyahChangedEvent(
        reciterId: state.selectedReciterId,
        surahId: state.session.currentSurahId,
        ayahId: activeAyah,
      ));
    }
  }

  double getRangeEndTime() {
    if (_timings.isEmpty) return 0.0;
    if (state.settings.repeatMode == RepeatMode.ayah) {
      final ayahNum = state.session.currentAyahNumber;
      return _timings[ayahNum]?.endTime ?? 0.0;
    } else if (state.settings.repeatMode == RepeatMode.range) {
      final endAyah = state.session.rangeEndAyah;
      return _timings[endAyah]?.endTime ?? 0.0;
    } else if (state.settings.repeatMode == RepeatMode.surah) {
      final lastAyahNum = _timings.keys.fold(0, (max, key) => key > max ? key : max);
      return _timings[lastAyahNum]?.endTime ?? 0.0;
    }
    return 0.0;
  }

  double getRangeStartTime() {
    if (_timings.isEmpty) return 0.0;
    if (state.settings.repeatMode == RepeatMode.ayah) {
      final ayahNum = state.session.currentAyahNumber;
      return _timings[ayahNum]?.startTime ?? 0.0;
    } else if (state.settings.repeatMode == RepeatMode.range) {
      final startAyah = state.session.rangeStartAyah;
      return _timings[startAyah]?.startTime ?? 0.0;
    } else if (state.settings.repeatMode == RepeatMode.surah) {
      return 0.0;
    }
    return 0.0;
  }

  void _checkRangeLimit(Duration pos) async {
    if (_timings.isEmpty) return;
    if (state.engineState == RecitationEngineState.waitingGap ||
        state.engineState == RecitationEngineState.repeating) {
      return;
    }

    final seconds = pos.inMilliseconds / 1000.0;
    final isRepeatEnabled = state.settings.repeatMode != RepeatMode.none;

    if (isRepeatEnabled) {
      final rangeEndTime = getRangeEndTime();
      if (rangeEndTime > 0 && seconds >= rangeEndTime) {
        final repeatCount = state.settings.repeatCount;
        final currentRepeatIndex = state.session.repeatIndex;

        if (repeatCount == -1 || currentRepeatIndex < repeatCount) {
          await _handleRepeatTrigger(currentRepeatIndex + 1);
        } else {
          await _handleRepeatFinished();
        }
      }
    } else {
      final lastAyahNum = _timings.keys.fold(0, (max, key) => key > max ? key : max);
      final surahEndTime = _timings[lastAyahNum]?.endTime ?? 0.0;
      if (surahEndTime > 0 && seconds >= surahEndTime) {
        await _handleSurahCompleted();
      }
    }
  }

  Future<void> _handleRepeatTrigger(int nextRepeatIndex) async {
    await pause();

    final updatedSession = state.session.copyWith(repeatIndex: nextRepeatIndex);
    state = state.copyWith(
      engineState: RecitationEngineState.repeating,
      session: updatedSession,
    );
    _saveSession();

    final hasGap = state.settings.gapMode != GapMode.none && state.settings.gapSeconds > 0;
    if (hasGap) {
      _startGapTimeout(() async {
        await _seekToRangeStartAndPlay();
      });
    } else {
      await _seekToRangeStartAndPlay();
    }
  }

  Future<void> _seekToRangeStartAndPlay() async {
    final startTimeSec = getRangeStartTime();
    await _audioPlayer.seek(Duration(milliseconds: (startTimeSec * 1000).toInt()));
    state = state.copyWith(engineState: RecitationEngineState.playing);
    await play();
  }

  void _startGapTimeout(VoidCallback onComplete) {
    _gapTimer?.cancel();

    final gapSeconds = state.settings.gapSeconds;
    _gapEndTime = DateTime.now().add(Duration(seconds: gapSeconds));

    state = state.copyWith(
      engineState: RecitationEngineState.waitingGap,
      gapRemainingSeconds: gapSeconds,
    );

    _gapTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_gapEndTime == null || !mounted) {
        timer.cancel();
        return;
      }

      final diff = _gapEndTime!.difference(DateTime.now());
      if (diff.isNegative) {
        timer.cancel();
        _gapTimer = null;
        _gapEndTime = null;
        Future.microtask(() {
          if (mounted) {
            state = state.copyWith(gapRemainingSeconds: 0);
            onComplete();
          }
        });
      } else {
        final remaining = diff.inSeconds + (diff.inMilliseconds % 1000 > 0 ? 1 : 0);
        if (state.gapRemainingSeconds != remaining) {
          Future.microtask(() {
            if (mounted) {
              state = state.copyWith(gapRemainingSeconds: remaining);
            }
          });
        }
      }
    });
  }

  Future<void> _handleRepeatFinished() async {
    final updatedSession = state.session.copyWith(repeatIndex: 1);
    state = state.copyWith(session: updatedSession);
    _saveSession();

    if (state.settings.autoNext) {
      await _playNextSection();
    } else {
      await pause();
      state = state.copyWith(engineState: RecitationEngineState.completed);
    }
  }

  Future<void> _playNextSection() async {
    if (state.settings.repeatMode == RepeatMode.ayah) {
      final nextAyah = state.session.currentAyahNumber + 1;
      if (_timings.containsKey(nextAyah)) {
        final updatedSession = state.session.copyWith(
          currentAyahNumber: nextAyah,
          repeatIndex: 1,
        );
        state = state.copyWith(session: updatedSession, currentAyahNumber: nextAyah);
        _saveSession();

        final hasGap = state.settings.gapMode == GapMode.betweenAyahs && state.settings.gapSeconds > 0;
        if (hasGap) {
          await pause();
          _startGapTimeout(() async {
            await _seekToRangeStartAndPlay();
          });
        } else {
          await _seekToRangeStartAndPlay();
        }
      } else {
        await _handleSurahCompleted();
      }
    } else if (state.settings.repeatMode == RepeatMode.range) {
      final rangeSize = state.session.rangeEndAyah - state.session.rangeStartAyah;
      final nextStart = state.session.rangeEndAyah + 1;
      final nextEnd = nextStart + rangeSize;

      if (_timings.containsKey(nextStart)) {
        final lastAyahNum = _timings.keys.fold(0, (max, key) => key > max ? key : max);
        final finalNextEnd = nextEnd > lastAyahNum ? lastAyahNum : nextEnd;

        final updatedSession = state.session.copyWith(
          rangeStartAyah: nextStart,
          rangeEndAyah: finalNextEnd,
          currentAyahNumber: nextStart,
          repeatIndex: 1,
        );
        state = state.copyWith(session: updatedSession, currentAyahNumber: nextStart);
        _saveSession();

        await _seekToRangeStartAndPlay();
      } else {
        await _handleSurahCompleted();
      }
    } else if (state.settings.repeatMode == RepeatMode.surah) {
      final nextSurahId = state.session.currentSurahId + 1;
      if (nextSurahId <= 114) {
        await playNextSurah(nextSurahId);
      } else {
        await pause();
        state = state.copyWith(engineState: RecitationEngineState.completed);
      }
    }
  }

  Future<void> _handleSurahCompleted() async {
    if (state.settings.autoNext) {
      final nextSurahId = state.session.currentSurahId + 1;
      if (nextSurahId <= 114) {
        await playNextSurah(nextSurahId);
      } else {
        await pause();
        state = state.copyWith(engineState: RecitationEngineState.completed);
      }
    } else {
      await pause();
      state = state.copyWith(engineState: RecitationEngineState.completed);
    }
  }

  Future<void> loadSurah(int surahId, {bool force = false}) async {
    if (_loadedSurahId == surahId && !force && state.streamUrl != null) return;
    if (!mounted) return;

    state = state.copyWith(isLoading: true, errorMessage: null, currentAyahNumber: null);

    try {
      String audioUrl = '';
      Map<int, AyahTimingModel> timings = {};
      final isOffline = AudioDownloadManager().isDownloaded(state.selectedReciterId, surahId);

      if (isOffline) {
        final localPath = AudioDownloadManager().getLocalPath(state.selectedReciterId, surahId);
        if (localPath != null) {
          audioUrl = localPath;
        }
      }

      try {
        final quality = await AudioQualityManager().getSelectedQuality();
        final audioData = await ref.read(surahAudioProvider(SurahAudioFamilyParam(
          surahId: surahId,
          reciterId: state.selectedReciterId,
          quality: quality == 'offline_only' ? null : quality,
        )).future);

        timings = audioData.timings;
        if (audioUrl.isEmpty) {
          if (quality == 'offline_only') {
            throw Exception('ئەم سوورەتە دانەگیراوە بۆ کارکردن بەبێ هێڵ');
          }
          audioUrl = audioData.streamUrl;
        }
      } catch (e) {
        if (audioUrl.isNotEmpty) {
          // Keep offline path, timings will be estimated
        } else {
          rethrow;
        }
      }

      if (!mounted) return;

      _timings = timings;
      _loadedSurahId = surahId;

      state = state.copyWith(
        streamUrl: audioUrl,
        isLoading: false,
        duration: Duration.zero,
        position: Duration.zero,
      );

      final isUrl = audioUrl.startsWith('http://') || audioUrl.startsWith('https://');
      if (isUrl) {
        await _audioPlayer.setSourceUrl(audioUrl);
      } else {
        await _audioPlayer.setSourceDeviceFile(audioUrl);
      }

      if (_timings.isEmpty) {
        int ayahCount = 7;
        final surahListAsync = ref.read(surahListProvider);
        surahListAsync.whenData((list) {
          final sur = list.where((s) => s.id == surahId).firstOrNull;
          if (sur != null) {
            ayahCount = sur.totalAyahs;
          }
        });
        _estimateTimingsWhenDurationAvailable(surahId, ayahCount);
      }
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'فایلی دەنگی یان کاتەکان بەردەست نییە',
      );
    }
  }

  void _estimateTimingsWhenDurationAvailable(int surahId, int ayahCount) {
    StreamSubscription? tempSub;
    tempSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (dur.inSeconds > 0) {
        tempSub?.cancel();
        if (_timings.isEmpty && _loadedSurahId == surahId) {
          final totalSeconds = dur.inMilliseconds / 1000.0;
          final segmentDuration = totalSeconds / ayahCount;
          final Map<int, AyahTimingModel> estimated = {};
          for (int i = 1; i <= ayahCount; i++) {
            estimated[i] = AyahTimingModel(
              ayahNumber: i,
              startTime: (i - 1) * segmentDuration,
              endTime: i * segmentDuration,
            );
          }
          _timings = estimated;
          _updateCurrentAyah(state.position);
        }
      }
    });
  }

  Future<void> playAyah(int surahId, int ayahNumber) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true);
    try {
      await loadSurah(surahId);
      if (!mounted) return;

      final timing = _timings[ayahNumber];
      if (timing != null) {
        await _audioPlayer.seek(Duration(milliseconds: (timing.startTime * 1000).toInt()));
      }

      final updatedSession = state.session.copyWith(
        currentSurahId: surahId,
        currentAyahNumber: ayahNumber,
        repeatIndex: 1,
        playbackPositionMs: timing != null ? (timing.startTime * 1000).toInt() : 0,
      );

      state = state.copyWith(
        currentAyahNumber: ayahNumber,
        session: updatedSession,
        engineState: RecitationEngineState.playing,
        isLoading: false,
      );
      _saveSession();
      await play();
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> play() async {
    if (state.streamUrl == null) return;
    final focusGranted = await _audioSessionHandler.requestFocus();
    if (!focusGranted) return;

    await _audioPlayer.resume();
    state = state.copyWith(engineState: RecitationEngineState.playing);
    _updateLockScreenMetadata();
  }

  Future<void> pause() async {
    _gapTimer?.cancel();
    _gapTimer = null;
    _gapEndTime = null;
    await _audioPlayer.pause();
    state = state.copyWith(engineState: RecitationEngineState.idle);

    final updatedSession = state.session.copyWith(
      endedCleanly: false,
      interruptedState: state.engineState.name,
    );
    state = state.copyWith(session: updatedSession);
    _saveSession();
    _updateLockScreenMetadata();
  }

  Future<void> seek(Duration pos) async {
    await _audioPlayer.seek(pos);
    _updateLockScreenMetadata();
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _audioPlayer.setPlaybackRate(speed);
    _updateLockScreenMetadata();
  }

  void toggleAutoScroll() {
    state = state.copyWith(isAutoScrollEnabled: !state.isAutoScrollEnabled);
  }

  Future<void> changeReciter(int reciterId, int surahId) async {
    state = state.copyWith(selectedReciterId: reciterId);
    ref.read(reciterHistorySyncQueueProvider).logSelection(reciterId);

    await _audioPlayer.stop();
    await loadSurah(surahId, force: true);
    await play();
  }

  Future<void> playNextSurah(int surahId) async {
    final updatedSession = state.session.copyWith(
      currentSurahId: surahId,
      currentAyahNumber: 1,
      repeatIndex: 1,
      rangeStartAyah: 1,
      rangeEndAyah: 1,
      playbackPositionMs: 0,
    );
    state = state.copyWith(
      session: updatedSession,
      currentAyahNumber: 1,
    );
    _saveSession();

    await loadSurah(surahId, force: true);
    await play();
  }

  Future<void> _playPreviousSection() async {
    final prevAyah = state.session.currentAyahNumber - 1;
    if (_timings.containsKey(prevAyah)) {
      await playAyah(state.session.currentSurahId, prevAyah);
    } else {
      final prevSurah = state.session.currentSurahId - 1;
      if (prevSurah >= 1) {
        await playNextSurah(prevSurah);
      }
    }
  }

  void cancelRecovery() {
    state = state.copyWith(
      sessionRecoveryState: SessionRecoveryState.none,
    );
    loadSurah(state.session.currentSurahId);
  }

  Future<void> restoreSession() async {
    state = state.copyWith(sessionRecoveryState: SessionRecoveryState.restoring);
    final session = state.session;

    await loadSurah(session.currentSurahId);

    ResumeStrategy strategy = ResumeStrategy.exactPosition;

    if (session.interruptedState == RecitationEngineState.waitingGap.name) {
      strategy = ResumeStrategy.lastKnownState;
    } else {
      final currentAyahTiming = _timings[session.currentAyahNumber];
      if (currentAyahTiming != null) {
        final posSeconds = session.playbackPositionMs / 1000.0;
        final secondsRemaining = currentAyahTiming.endTime - posSeconds;

        if (secondsRemaining < 0.5 || posSeconds >= currentAyahTiming.endTime) {
          strategy = ResumeStrategy.ayahBoundary;
        } else {
          strategy = ResumeStrategy.exactPosition;
        }
      }
    }

    switch (strategy) {
      case ResumeStrategy.exactPosition:
        await _audioPlayer.seek(Duration(milliseconds: session.playbackPositionMs));
        state = state.copyWith(
          currentAyahNumber: session.currentAyahNumber,
          engineState: RecitationEngineState.playing,
        );
        await play();
        break;

      case ResumeStrategy.ayahBoundary:
        final nextAyah = session.currentAyahNumber + 1;
        if (_timings.containsKey(nextAyah)) {
          final nextTiming = _timings[nextAyah]!;
          await _audioPlayer.seek(Duration(milliseconds: (nextTiming.startTime * 1000).toInt()));
          final updatedSession = session.copyWith(
            currentAyahNumber: nextAyah,
            playbackPositionMs: (nextTiming.startTime * 1000).toInt(),
          );
          state = state.copyWith(
            currentAyahNumber: nextAyah,
            session: updatedSession,
            engineState: RecitationEngineState.playing,
          );
          _saveSession();
        } else {
          await playNextSurah(session.currentSurahId + 1 <= 114 ? session.currentSurahId + 1 : session.currentSurahId);
        }
        await play();
        break;

      case ResumeStrategy.surahStart:
        await _audioPlayer.seek(Duration.zero);
        state = state.copyWith(
          currentAyahNumber: 1,
          engineState: RecitationEngineState.playing,
        );
        await play();
        break;

      case ResumeStrategy.lastKnownState:
        if (session.interruptedState == RecitationEngineState.waitingGap.name) {
          state = state.copyWith(
            engineState: RecitationEngineState.waitingGap,
            currentAyahNumber: session.currentAyahNumber,
          );
          _startGapTimeout(() async {
            await _seekToRangeStartAndPlay();
          });
        } else {
          await _audioPlayer.seek(Duration(milliseconds: session.playbackPositionMs));
          state = state.copyWith(
            currentAyahNumber: session.currentAyahNumber,
            engineState: RecitationEngineState.playing,
          );
          await play();
        }
        break;
    }

    state = state.copyWith(sessionRecoveryState: SessionRecoveryState.restored);
  }

  void updateSettings(RecitationSettings settings) {
    state = state.copyWith(settings: settings);
    _saveSettings();
  }

  void updateSession(RecitationSession session) {
    state = state.copyWith(session: session);
    _saveSession();
  }

  void setRepeatMode(RepeatMode mode) {
    final newSettings = state.settings.copyWith(repeatMode: mode, memorizationMode: false);
    state = state.copyWith(settings: newSettings);
    _saveSettings();
  }

  void setRepeatCount(int count) {
    final newSettings = state.settings.copyWith(repeatCount: count, memorizationMode: false);
    state = state.copyWith(settings: newSettings);
    _saveSettings();
  }

  void setGapMode(GapMode mode) {
    final newSettings = state.settings.copyWith(gapMode: mode, memorizationMode: false);
    state = state.copyWith(settings: newSettings);
    _saveSettings();
  }

  void setGapSeconds(int seconds) {
    final newSettings = state.settings.copyWith(gapSeconds: seconds, memorizationMode: false);
    state = state.copyWith(settings: newSettings);
    _saveSettings();
  }

  void setAutoNext(bool autoNext) {
    final newSettings = state.settings.copyWith(autoNext: autoNext);
    state = state.copyWith(settings: newSettings);
    _saveSettings();
  }

  void setRange(int startAyah, int endAyah) {
    final actualStart = startAyah <= endAyah ? startAyah : endAyah;
    final actualEnd = startAyah <= endAyah ? endAyah : startAyah;

    final updatedSession = state.session.copyWith(
      rangeStartAyah: actualStart,
      rangeEndAyah: actualEnd,
    );
    state = state.copyWith(session: updatedSession);
    _saveSession();
  }

  void setMemorizationPreset(MemorizationPreset preset) {
    final newSettings = state.settings.copyWith(
      repeatMode: RepeatMode.range,
      repeatCount: preset.repeatCount,
      gapMode: GapMode.betweenRepeats,
      gapSeconds: preset.gapSeconds,
      memorizationMode: true,
    );
    state = state.copyWith(settings: newSettings);
    _saveSettings();
  }

  void startSleepTimer(int minutes) {
    _sleepTimerService.startDurationTimer(minutes);
  }

  void startSurahEndSleepTimer() {
    _sleepTimerService.startSurahEndTimer();
  }

  void cancelSleepTimer() {
    _sleepTimerService.cancel();
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _gapTimer?.cancel();
    _audioSessionHandler.dispose();
    _playbackStateBridge.dispose();
    _sleepTimerService.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier(ref);
});
