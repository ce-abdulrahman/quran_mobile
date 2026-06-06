import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../quran_providers.dart';
import '../../../core/repositories/audio_repository.dart';

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

  AudioPlayerNotifier(this.ref) : super(const AudioPlayerState(selectedReciterId: 1)) {
    _audioPlayer = AudioPlayer();
    _init();
  }

  void _init() {
    _posSub = _audioPlayer.onPositionChanged.listen((pos) {
      if (!mounted) return;
      state = state.copyWith(position: pos);
      _updateCurrentAyah(pos);
    });

    _durSub = _audioPlayer.onDurationChanged.listen((dur) {
      if (!mounted) return;
      state = state.copyWith(duration: dur);
    });

    _stateSub = _audioPlayer.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      state = state.copyWith(
        isPlaying: s == PlayerState.playing,
        isLoading: false,
      );
    });
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

    if (activeAyah != null && activeAyah != state.currentAyahNumber) {
      state = state.copyWith(currentAyahNumber: activeAyah);
    }
  }

  Future<void> loadSurah(int surahId, {bool force = false}) async {
    if (_loadedSurahId == surahId && !force && state.streamUrl != null) return;
    if (!mounted) return;

    state = state.copyWith(isLoading: true, errorMessage: null, currentAyahNumber: null);
    try {
      final audioData = await ref.read(surahAudioProvider(SurahAudioFamilyParam(
        surahId: surahId,
        reciterId: state.selectedReciterId,
      )).future);

      if (!mounted) return;
      _timings = audioData.timings;
      _loadedSurahId = surahId;
      state = state.copyWith(
        streamUrl: audioData.streamUrl,
        isLoading: false,
        duration: Duration.zero,
        position: Duration.zero,
      );

      await _audioPlayer.setSourceUrl(audioData.streamUrl);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: 'فایلی دەنگی بەردەست نییە');
    }
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
      if (!mounted) return;
      state = state.copyWith(currentAyahNumber: ayahNumber, isLoading: false);
      await play();
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> play() async {
    if (state.streamUrl == null) return;
    await _audioPlayer.resume();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> seek(Duration pos) async {
    await _audioPlayer.seek(pos);
  }

  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
    await _audioPlayer.setPlaybackRate(speed);
  }

  void toggleAutoScroll() {
    state = state.copyWith(isAutoScrollEnabled: !state.isAutoScrollEnabled);
  }

  Future<void> changeReciter(int reciterId, int surahId) async {
    state = state.copyWith(selectedReciterId: reciterId);
    await _audioPlayer.stop();
    await loadSurah(surahId, force: true);
    await play();
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier(ref);
});
