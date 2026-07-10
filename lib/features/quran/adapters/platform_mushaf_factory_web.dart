// Web stub — provides no-op implementations.
// The kIsWeb check in vector_mushaf_provider.dart ensures these are never actually called on web.
import '../interfaces/coordinate_provider.dart';
import '../interfaces/page_geometry_provider.dart';
import '../interfaces/mushaf_asset_provider.dart';
import '../services/mushaf_cache_manager.dart';
import 'mushaf_web_adapters.dart';

CoordinateProvider createCoordinateProvider(MushafCacheManager cacheManager) {
  return const WebCoordinateAdapter();
}

MushafAssetProvider createAssetProvider({
  required PageGeometryProvider geometry,
  required MushafCacheManager cacheManager,
}) {
  return WebAssetProvider(geometryProvider: geometry);
}
