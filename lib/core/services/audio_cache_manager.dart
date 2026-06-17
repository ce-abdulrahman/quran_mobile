import 'dart:async';

class CleanupReport {
  final int filesRemoved;
  final int bytesFreed;

  CleanupReport({required this.filesRemoved, required this.bytesFreed});
}

class AudioCacheManager {
  static final AudioCacheManager _instance = AudioCacheManager._internal();
  factory AudioCacheManager() => _instance;
  AudioCacheManager._internal();

  static const int defaultMaxStorageBytes = 500 * 1024 * 1024; // 500MB cap

  Future<Map<String, dynamic>> loadIndex() async => {};
  Future<void> updateIndex(int reciterId, int surahId, String path) async {}
  Future<void> removeFromIndex(int reciterId, int surahId) async {}
  Future<void> validateIndex() async {}

  Future<CleanupReport> runLRUCleanup({required int targetBytes}) async {
    return CleanupReport(filesRemoved: 0, bytesFreed: 0);
  }

  Future<CleanupReport> removeUnusedFiles({required Duration unusedFor}) async {
    return CleanupReport(filesRemoved: 0, bytesFreed: 0);
  }

  Future<CleanupReport> enforceStorageCap() async {
    return CleanupReport(filesRemoved: 0, bytesFreed: 0);
  }

  Future<void> recordAccess(int reciterId, int surahId) async {}
  Future<DateTime?> getLastAccess(int reciterId, int surahId) async => null;
}
