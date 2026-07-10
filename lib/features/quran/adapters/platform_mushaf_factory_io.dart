// IO implementation — only compiled on native platforms (Android, iOS, Desktop).
import '../interfaces/coordinate_provider.dart';
import '../interfaces/page_geometry_provider.dart';
import '../interfaces/mushaf_asset_provider.dart';
import '../services/mushaf_cache_manager.dart';
import 'quranpedia_coordinate_adapter.dart';
import 'offline_first_asset_provider.dart';

CoordinateProvider createCoordinateProvider(MushafCacheManager cacheManager) {
  return QuranpediaCoordinateAdapter(cacheManager: cacheManager);
}

MushafAssetProvider createAssetProvider({
  required PageGeometryProvider geometry,
  required MushafCacheManager cacheManager,
}) {
  return OfflineFirstAssetProvider(
    geometryProvider: geometry,
    cacheManager: cacheManager,
  );
}
