import 'package:flutter/widgets.dart';

/// Abstract contract managing zoom scaling and spatial panning within the Mushaf viewport.
/// Swappable and decoupled from specific UI framework scaling classes.
abstract class ZoomEngine {
  /// Zoom viewport to target scale, optionally centered at a focal point coordinate.
  void zoomTo(double scale, {Offset? focalPoint});

  /// Reset the scale and translation matrices to default identity.
  void resetZoom();

  /// Pan or translate the current view window relative to the scaled canvas coordinates.
  void updatePosition(Offset delta);

  /// Notifier reflecting the current scale factor (1.0 = fit size).
  ValueNotifier<double> get scaleNotifier;

  /// Notifier reflecting the translation offset coordinates of the viewport window.
  ValueNotifier<Offset> get translationNotifier;
}
