import 'dart:io';
import 'package:flutter/widgets.dart';
import '../interfaces/mushaf_asset_provider.dart';

/// Concrete implementation of MushafAssetProvider for loading page WebP/PNG assets
/// from local application resources.
class RasterAssetProvider implements MushafAssetProvider {
  final String assetPrefix;

  const RasterAssetProvider({
    this.assetPrefix = 'assets/images/quran',
  });

  @override
  Future<MushafPageAsset> getPageAsset(int pageNumber) async {
    final assetPath = '$assetPrefix/page_${pageNumber.toString().padLeft(3, '0')}.webp';
    final imageProvider = AssetImage(assetPath);

    // Default target dimensions matching Medina Mushaf page scaling ratio.
    const defaultDimensions = Size(450, 720);

    return MushafPageAsset(
      pageNumber: pageNumber,
      imageProvider: imageProvider,
      dimensions: defaultDimensions,
      type: MushafAssetType.raster,
      localFile: File(assetPath),
    );
  }

  @override
  void prefetchPages(List<int> pageNumbers) {
    // Standard asset prefetching warmup triggers.
    for (final page in pageNumbers) {
      final assetPath = '$assetPrefix/page_${page.toString().padLeft(3, '0')}.webp';
      final imageProvider = AssetImage(assetPath);
      imageProvider.evict(); // Evicts if expired, warmup triggers cache entry
    }
  }
}
