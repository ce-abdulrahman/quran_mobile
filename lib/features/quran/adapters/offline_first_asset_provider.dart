import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../interfaces/mushaf_asset_provider.dart';
import '../interfaces/page_geometry_provider.dart';
import '../services/mushaf_cache_manager.dart';

class OfflineFirstAssetProvider implements MushafAssetProvider {
  final PageGeometryProvider geometryProvider;
  final MushafCacheManager cacheManager;

  const OfflineFirstAssetProvider({
    required this.geometryProvider,
    required this.cacheManager,
  });

  String _formatPageNum(int pageNumber) {
    return pageNumber.toString().padLeft(3, '0');
  }

  @override
  Future<MushafPageAsset> getPageAsset(int pageNumber) async {
    final pageStr = _formatPageNum(pageNumber);
    
    // Resolve cache file paths
    final svgFile = await cacheManager.getDiskFile('svg', '$pageStr.svg');
    final jsonFile = await cacheManager.getDiskFile('json', '$pageStr.json');

    // Extract SVG from assets to filesystem cache if missing
    if (!await svgFile.exists()) {
      final data = await rootBundle.loadString('assets/quran/svg/$pageStr.svg');
      await svgFile.writeAsString(data);
    }

    // Extract JSON from assets to filesystem cache if missing
    if (!await jsonFile.exists()) {
      final data = await rootBundle.loadString('assets/quran/json/$pageStr.json');
      await jsonFile.writeAsString(data);
    }

    final dimensions = geometryProvider.getBaseDimensions(pageNumber);

    return MushafPageAsset(
      pageNumber: pageNumber,
      imageProvider: const NetworkImage(''),
      dimensions: dimensions,
      type: MushafAssetType.vector,
      localFile: svgFile,
    );
  }

  @override
  void prefetchPages(List<int> pageNumbers) {
    for (final page in pageNumbers) {
      getPageAsset(page).catchError((_) => MushafPageAsset(
        pageNumber: 0,
        imageProvider: const NetworkImage(''),
        dimensions: Size.zero,
        type: MushafAssetType.vector,
        localFile: File(''),
      ));
    }
  }
}
