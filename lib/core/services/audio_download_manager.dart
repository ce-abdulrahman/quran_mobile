import 'dart:async';

enum DownloadStatus { queued, downloading, complete, error }

class DownloadProgress {
  final int reciterId;
  final int surahId;
  final double progress; // 0.0 to 1.0
  final int bytesDownloaded;
  final int totalBytes;
  final DownloadStatus status;

  DownloadProgress({
    required this.reciterId,
    required this.surahId,
    required this.progress,
    required this.bytesDownloaded,
    required this.totalBytes,
    required this.status,
  });
}

class CachedReciter {
  final int id;
  final String name;
  final int sizeBytes;

  CachedReciter({required this.id, required this.name, required this.sizeBytes});
}

class AudioDownloadManager {
  static final AudioDownloadManager _instance = AudioDownloadManager._internal();
  factory AudioDownloadManager() => _instance;
  AudioDownloadManager._internal();

  final _progressController = StreamController<DownloadProgress>.broadcast();

  Stream<DownloadProgress> watchProgress(int reciterId, int surahId) => _progressController.stream;

  bool isDownloaded(int reciterId, int surahId) => false;
  String? getLocalPath(int reciterId, int surahId) => null;

  Future<String> downloadSurah(int reciterId, int surahId) async {
    return '';
  }

  Future<void> cancelDownload(int reciterId, int surahId) async {}

  Future<int> getTotalStorageBytes() async => 0;
  Future<int> getReciterStorageBytes(int reciterId) async => 0;
  Future<List<CachedReciter>> getDownloadedReciters() async => [];
  Future<void> deleteReciter(int reciterId) async {}
  Future<void> deleteSurah(int reciterId, int surahId) async {}

  Future<void> runCleanupPolicy() async {}
  Future<void> enforceSizeLimit(int maxBytes) async {}
}
