import 'dart:async';

sealed class AudioEvent {}

class PlayStartedEvent extends AudioEvent {
  final int reciterId;
  final int surahId;
  final int ayahId;

  PlayStartedEvent({
    required this.reciterId,
    required this.surahId,
    required this.ayahId,
  });
}

class PlayPausedEvent extends AudioEvent {
  final int reciterId;
  final int surahId;
  final int ayahId;

  PlayPausedEvent({
    required this.reciterId,
    required this.surahId,
    required this.ayahId,
  });
}

class AyahChangedEvent extends AudioEvent {
  final int reciterId;
  final int surahId;
  final int ayahId;

  AyahChangedEvent({
    required this.reciterId,
    required this.surahId,
    required this.ayahId,
  });
}

class DownloadProgressEvent extends AudioEvent {
  final int reciterId;
  final int surahId;
  final double progress; // 0.0 to 100.0
  final String status; // 'downloading', 'completed', 'failed'

  DownloadProgressEvent({
    required this.reciterId,
    required this.surahId,
    required this.progress,
    required this.status,
  });
}

class FavoriteToggledEvent extends AudioEvent {
  final String type; // 'reciter' or 'surah'
  final int id;
  final bool isFavorite;

  FavoriteToggledEvent({
    required this.type,
    required this.id,
    required this.isFavorite,
  });
}

class AudioEventBus {
  static final AudioEventBus _instance = AudioEventBus._internal();
  factory AudioEventBus() => _instance;
  AudioEventBus._internal();

  final _streamController = StreamController<AudioEvent>.broadcast();

  Stream<AudioEvent> get stream => _streamController.stream;

  Stream<T> on<T extends AudioEvent>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void fire(AudioEvent event) {
    _streamController.add(event);
  }
}
