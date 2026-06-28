import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import '../models/recitation_models.dart';

class QuranAudioHandler extends BaseAudioHandler {
  final _playController = StreamController<void>.broadcast();
  final _pauseController = StreamController<void>.broadcast();
  final _seekController = StreamController<Duration>.broadcast();
  final _nextController = StreamController<void>.broadcast();
  final _prevController = StreamController<void>.broadcast();

  Stream<void> get playRequests => _playController.stream;
  Stream<void> get pauseRequests => _pauseController.stream;
  Stream<Duration> get seekRequests => _seekController.stream;
  Stream<void> get skipToNextRequests => _nextController.stream;
  Stream<void> get skipToPreviousRequests => _prevController.stream;

  @override
  Future<void> play() async => _playController.add(null);

  @override
  Future<void> pause() async => _pauseController.add(null);

  @override
  Future<void> seek(Duration position) async => _seekController.add(position);

  @override
  Future<void> skipToNext() async => _nextController.add(null);

  @override
  Future<void> skipToPrevious() async => _prevController.add(null);

  void updateState(PlaybackState state) => playbackState.add(state);
  void updateItem(MediaItem item) => mediaItem.add(item);
}

class PlaybackStateBridge {
  QuranAudioHandler? _handler;
  StreamSubscription? _playSub;
  StreamSubscription? _pauseSub;
  StreamSubscription? _seekSub;
  StreamSubscription? _nextSub;
  StreamSubscription? _prevSub;

  final VoidCallback onPlay;
  final VoidCallback onPause;
  final Function(Duration) onSeek;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  PlaybackStateBridge({
    required this.onPlay,
    required this.onPause,
    required this.onSeek,
    required this.onNext,
    required this.onPrevious,
  });

  Future<void> initialize() async {
    if (kIsWeb) return;

    try {
      _handler = await AudioService.init<QuranAudioHandler>(
        builder: () => QuranAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.myquran.app.channel.audio',
          androidNotificationChannelName: 'Quran Recitation',
          androidNotificationOngoing: true,
          androidShowNotificationBadge: true,
        ),
      );

      _playSub = _handler?.playRequests.listen((_) => onPlay());
      _pauseSub = _handler?.pauseRequests.listen((_) => onPause());
      _seekSub = _handler?.seekRequests.listen((pos) => onSeek(pos));
      _nextSub = _handler?.skipToNextRequests.listen((_) => onNext());
      _prevSub = _handler?.skipToPreviousRequests.listen((_) => onPrevious());
    } catch (e) {
      debugPrint('Error initializing PlaybackStateBridge: $e');
    }
  }

  void updateMetadata(MediaPlaybackMetadata metadata) {
    if (kIsWeb || _handler == null) return;

    final mediaItem = MediaItem(
      id: 'quran_recitation_session',
      album: 'Surah ${metadata.surahName}',
      title: 'Ayah ${metadata.ayahNumber}',
      artist: metadata.reciterName,
      duration: metadata.duration,
      extras: {
        'ayahNumber': metadata.ayahNumber,
        'reciterName': metadata.reciterName,
      },
    );

    _handler!.updateItem(mediaItem);

    final playingState = metadata.isPlaying;
    final state = PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        playingState ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0, 1, 2],
      playing: playingState,
      processingState: playingState ? AudioProcessingState.ready : AudioProcessingState.idle,
      updatePosition: metadata.position,
      speed: metadata.playbackSpeed,
      queueIndex: 0,
    );

    _handler!.updateState(state);
  }

  void dispose() {
    _playSub?.cancel();
    _pauseSub?.cancel();
    _seekSub?.cancel();
    _nextSub?.cancel();
    _prevSub?.cancel();
  }
}
