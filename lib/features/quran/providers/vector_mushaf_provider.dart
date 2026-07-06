import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../interfaces/coordinate_provider.dart';
import '../interfaces/page_geometry_provider.dart';
import '../interfaces/mushaf_asset_provider.dart';
import '../services/mushaf_cache_manager.dart';
import '../adapters/kfqc_geometry_provider.dart';
import '../adapters/quranpedia_coordinate_adapter.dart';
import '../adapters/offline_first_asset_provider.dart';

// Geometry Provider DI
final pageGeometryProvider = Provider<PageGeometryProvider>((ref) {
  return const KFQCGeometryProvider();
});

// Cache Manager DI
final mushafCacheManagerProvider = Provider<MushafCacheManager>((ref) {
  return const MushafCacheManager();
});

// Coordinate Provider DI
final coordinateProvider = Provider<CoordinateProvider>((ref) {
  final cacheManager = ref.watch(mushafCacheManagerProvider);
  return QuranpediaCoordinateAdapter(cacheManager: cacheManager);
});

// Mushaf Asset Provider DI
final mushafAssetProvider = Provider<MushafAssetProvider>((ref) {
  final geometry = ref.watch(pageGeometryProvider);
  final cacheManager = ref.watch(mushafCacheManagerProvider);
  return OfflineFirstAssetProvider(
    geometryProvider: geometry,
    cacheManager: cacheManager,
  );
});

// Riverpod provider for loading and caching coordinates of a page in memory dynamically
final pageCoordinatesProvider = FutureProvider.family<PageCoordinates, int>((ref, pageNumber) async {
  final coordProv = ref.watch(coordinateProvider);
  final cacheManager = ref.watch(mushafCacheManagerProvider);

  // Check RAM Memory Cache first
  final memoryCached = cacheManager.getCoordinatesFromMemory(pageNumber);
  if (memoryCached != null) {
    return memoryCached;
  }

  // Load from disk and adapter
  final coords = await coordProv.getCoordinates(pageNumber);
  
  // Cache in RAM memory for subsequent reads
  cacheManager.cacheCoordinatesInMemory(pageNumber, coords);
  
  return coords;
});
