import 'package:flutter/widgets.dart';

enum MushafAssetType { raster, vector }

/// Represents a loaded page asset from the provider.
class MushafPageAsset {
  final int pageNumber;
  final ImageProvider imageProvider;
  final Size dimensions;
  final MushafAssetType type;
  final dynamic localFile;

  const MushafPageAsset({
    required this.pageNumber,
    required this.imageProvider,
    required this.dimensions,
    required this.type,
    required this.localFile,
  });
}

/// Abstract contract for retrieving page image assets of the Mushaf.
/// Decoupled from specific asset formats (WebP, SVG, PNG, Network).
abstract class MushafAssetProvider {
  /// Fetches the MushafPageAsset for the given page number (1-604).
  Future<MushafPageAsset> getPageAsset(int pageNumber);

  /// Pre-fetches and warm-caches pages to prevent layout lag on transition.
  void prefetchPages(List<int> pageNumbers);
}
