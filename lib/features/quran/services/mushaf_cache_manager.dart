import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../interfaces/coordinate_provider.dart';

class MushafCacheManager {
  // RAM Memory cache for parsed PageCoordinates
  static final Map<int, PageCoordinates> _memoryCache = {};

  const MushafCacheManager();

  /// Writes parsed PageCoordinates into the memory cache.
  void cacheCoordinatesInMemory(int pageNumber, PageCoordinates coords) {
    _memoryCache[pageNumber] = coords;
  }

  /// Retrieves cached coordinates from memory. Returns null if missing.
  PageCoordinates? getCoordinatesFromMemory(int pageNumber) {
    return _memoryCache[pageNumber];
  }

  /// Clears RAM memory cache (for memory pressure recovery).
  void clearMemoryCache() {
    _memoryCache.clear();
  }

  /// Retrieves the caching subdirectory on local disk.
  Future<Directory> getDiskDirectory(String folderName) async {
    final docDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${docDir.path}/mushaf/$folderName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Resolves the absolute path to a cached file.
  Future<File> getDiskFile(String folderName, String filename) async {
    final dir = await getDiskDirectory(folderName);
    return File('${dir.path}/$filename');
  }

  /// Evicts all cached assets on disk (for reset/cache invalidation).
  Future<void> clearDiskCache() async {
    final docDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${docDir.path}/mushaf');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
