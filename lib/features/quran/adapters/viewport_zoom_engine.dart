import 'package:flutter/widgets.dart';
import '../interfaces/zoom_engine.dart';

/// Concrete ZoomEngine mapping gestures to standard Matrix4 transformations
/// through Flutter's TransformationController.
class ViewportZoomEngine implements ZoomEngine {
  /// Internal controller holding the active transformation matrix.
  final TransformationController controller = TransformationController();

  @override
  final ValueNotifier<double> scaleNotifier = ValueNotifier<double>(1.0);

  @override
  final ValueNotifier<Offset> translationNotifier = ValueNotifier<Offset>(Offset.zero);

  ViewportZoomEngine() {
    controller.addListener(_handleControllerUpdate);
  }

  void _handleControllerUpdate() {
    final matrix = controller.value;
    final double scale = matrix.getMaxScaleOnAxis();
    final double tx = matrix.entry(0, 3);
    final double ty = matrix.entry(1, 3);

    scaleNotifier.value = scale;
    translationNotifier.value = Offset(tx, ty);
  }

  @override
  void zoomTo(double scale, {Offset? focalPoint}) {
    final double targetScale = scale.clamp(1.0, 3.0);
    final matrix = Matrix4.identity();

    if (focalPoint != null && targetScale > 1.0) {
      matrix.translate(focalPoint.dx, focalPoint.dy);
      matrix.scale(targetScale);
      matrix.translate(-focalPoint.dx, -focalPoint.dy);
    } else {
      matrix.scale(targetScale);
    }

    controller.value = matrix;
  }

  @override
  void resetZoom() {
    controller.value = Matrix4.identity();
  }

  @override
  void updatePosition(Offset delta) {
    final matrix = controller.value.clone();
    matrix.translate(delta.dx, delta.dy);
    controller.value = matrix;
  }

  /// Disposes listeners and controllers to prevent memory leaks.
  void dispose() {
    controller.removeListener(_handleControllerUpdate);
    controller.dispose();
    scaleNotifier.dispose();
    translationNotifier.dispose();
  }
}
