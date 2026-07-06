import 'package:flutter/widgets.dart';

/// Represents a visual highlight region painted on the Mushaf canvas.
class HighlightRegion {
  /// The simple bounding box of the highlighted text area.
  final Rect boundingBox;

  /// Optional polygonal path points normalized to the page size (0.0 to 1.0)
  /// for custom shapes (e.g. multi-line highlight wraps).
  final List<Offset>? polygonPoints;

  const HighlightRegion({
    required this.boundingBox,
    this.polygonPoints,
  });
}

/// Abstract contract for retrieving highlight regions of specific Ayahs on the page.
/// Swappable for polygon points, simple coordinates, or OCR mappings.
abstract class HighlightProvider {
  /// Retrieves a list of highlight regions for the specified Surah and Ayah,
  /// mapped to the target rendered canvas size.
  Future<List<HighlightRegion>> getHighlightRegions({
    required int surahId,
    required int ayahNumber,
    required Size pageSize,
  });
}
