import 'package:flutter/widgets.dart';
import '../interfaces/page_turn_controller.dart';

/// Concrete PageTurnController implementing a smooth horizontal slide transition
/// wrapping standard PageController.
class SlidePageTurnController implements PageTurnController {
  final PageController pageController;

  @override
  final ValueNotifier<double> transitionProgress = ValueNotifier<double>(0.0);

  SlidePageTurnController({required this.pageController}) {
    pageController.addListener(_handleScrollProgress);
  }

  void _handleScrollProgress() {
    if (pageController.hasClients) {
      final double progress = pageController.page ?? 0.0;
      // Normalizes scroll offset to a 0.0 - 1.0 decimal range.
      transitionProgress.value = progress - progress.floorToDouble();
    }
  }

  @override
  void transitionToPage(int pageIndex, {required TransitionDirection direction}) {
    if (!pageController.hasClients) return;
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void handleDragUpdate(double dragOffset) {
    // PageView handles touch dragging physics internally.
  }

  @override
  void handleDragEnd(double dragVelocity) {
    // PageView snaps to target page internally.
  }

  /// Disposes controllers and listeners.
  void dispose() {
    pageController.removeListener(_handleScrollProgress);
    transitionProgress.dispose();
  }
}
