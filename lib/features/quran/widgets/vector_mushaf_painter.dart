import 'package:flutter/material.dart';
import '../interfaces/coordinate_provider.dart';

class VectorMushafPainter extends CustomPainter {
  final PageCoordinates coordinates;
  final int? selectedAyahNumber;
  final int? selectedSurahNumber;
  final int? playingAyahNumber;
  final int? playingSurahNumber;
  final Color highlightColor;
  final Color playingHighlightColor;
  final Size baseDimensions;

  VectorMushafPainter({
    required this.coordinates,
    this.selectedAyahNumber,
    this.selectedSurahNumber,
    this.playingAyahNumber,
    this.playingSurahNumber,
    required this.highlightColor,
    required this.playingHighlightColor,
    required this.baseDimensions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (coordinates.ayahs.isEmpty) return;

    final double scaleX = size.width / baseDimensions.width;
    final double scaleY = size.height / baseDimensions.height;

    canvas.save();
    canvas.scale(scaleX, scaleY);

    for (final ayah in coordinates.ayahs) {
      final isSelected = selectedAyahNumber == ayah.ayahNumber && selectedSurahNumber == ayah.surahNumber;
      final isPlaying = playingAyahNumber == ayah.ayahNumber && playingSurahNumber == ayah.surahNumber;

      if (isSelected || isPlaying) {
        final fillPaint = Paint()
          ..color = isSelected ? highlightColor : playingHighlightColor
          ..style = PaintingStyle.fill;
        
        canvas.drawPath(ayah.path, fillPaint);

        // Draw subtle outline
        final strokePaint = Paint()
          ..color = (isSelected ? highlightColor : playingHighlightColor).withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0 / scaleX; // Preserve pixel size when scaled
        
        canvas.drawPath(ayah.path, strokePaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant VectorMushafPainter oldDelegate) {
    return oldDelegate.coordinates != coordinates ||
        oldDelegate.selectedAyahNumber != selectedAyahNumber ||
        oldDelegate.selectedSurahNumber != selectedSurahNumber ||
        oldDelegate.playingAyahNumber != playingAyahNumber ||
        oldDelegate.playingSurahNumber != playingSurahNumber ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.playingHighlightColor != playingHighlightColor ||
        oldDelegate.baseDimensions != baseDimensions;
  }

  /// Evaluates which ayah coordinate contains the local touch offset.
  /// Returns null if no match.
  static AyahCoordinate? findAyahByOffset(
    Offset localOffset,
    Size widgetSize,
    Size baseDimensions,
    PageCoordinates coordinates,
  ) {
    final double scaleX = widgetSize.width / baseDimensions.width;
    final double scaleY = widgetSize.height / baseDimensions.height;

    final double designX = localOffset.dx / scaleX;
    final double designY = localOffset.dy / scaleY;

    final targetOffset = Offset(designX, designY);

    for (final ayah in coordinates.ayahs) {
      if (ayah.path.contains(targetOffset)) {
        return ayah;
      }
    }
    return null;
  }
}
