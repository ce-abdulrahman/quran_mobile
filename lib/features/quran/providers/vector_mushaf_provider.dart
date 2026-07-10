import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../interfaces/coordinate_provider.dart';
import '../interfaces/page_geometry_provider.dart';
import '../interfaces/mushaf_asset_provider.dart';
import '../services/mushaf_cache_manager.dart';
import '../adapters/kfqc_geometry_provider.dart';
// Web adapters are always imported (web-safe, no dart:io)
import '../adapters/mushaf_web_adapters.dart';
// IO adapters only included on non-web. The dart:io using code is guarded by kIsWeb at runtime.
// We use a conditional export pattern via createCoordinateProvider / createAssetProvider factories.
import '../adapters/platform_mushaf_factory.dart';

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
  if (kIsWeb) {
    return const WebCoordinateAdapter();
  }
  final cacheManager = ref.watch(mushafCacheManagerProvider);
  return createCoordinateProvider(cacheManager);
});

// Mushaf Asset Provider DI
final mushafAssetProvider = Provider<MushafAssetProvider>((ref) {
  final geometry = ref.watch(pageGeometryProvider);
  if (kIsWeb) {
    return WebAssetProvider(geometryProvider: geometry);
  }
  final cacheManager = ref.watch(mushafCacheManagerProvider);
  return createAssetProvider(geometry: geometry, cacheManager: cacheManager);
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
