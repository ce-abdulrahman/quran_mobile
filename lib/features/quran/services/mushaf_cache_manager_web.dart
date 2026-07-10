import '../interfaces/coordinate_provider.dart';

/// Web stub for MushafCacheManager — only in-memory caching, no disk access.
class MushafCacheManager {
  static final Map<int, PageCoordinates> _memoryCache = {};

  const MushafCacheManager();

  void cacheCoordinatesInMemory(int pageNumber, PageCoordinates coords) {
    _memoryCache[pageNumber] = coords;
  }

  PageCoordinates? getCoordinatesFromMemory(int pageNumber) {
    return _memoryCache[pageNumber];
  }

  void clearMemoryCache() {
    _memoryCache.clear();
  }

  /// Not supported on web — throws UnsupportedError.
  Future<dynamic> getDiskDirectory(String folderName) {
    throw UnsupportedError('Disk access not supported on web');
  }

  Future<dynamic> getDiskFile(String folderName, String filename) {
    throw UnsupportedError('Disk access not supported on web');
  }

  Future<void> clearDiskCache() async {
    // No-op on web
  }
}
