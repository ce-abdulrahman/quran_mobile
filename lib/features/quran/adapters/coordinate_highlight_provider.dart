import 'package:flutter/widgets.dart';
import '../interfaces/highlight_provider.dart';

/// Concrete implementation of HighlightProvider preparing for pixel coordinate or polygonal mapping.
/// Fallback is empty list since the current implementation styles highlights via RichText text-span backgrounds.
class CoordinateHighlightProvider implements HighlightProvider {
  const CoordinateHighlightProvider();

  @override
  Future<List<HighlightRegion>> getHighlightRegions({
    required int surahId,
    required int ayahNumber,
    required Size pageSize,
  }) async {
    // Return empty list; active highlighting is handled directly by dynamic
    // TextSpan styling within the page builder loop. This class is prepared
    // to map database coordinates if high-res custom painted highlights are introduced.
    return const [];
  }
}
