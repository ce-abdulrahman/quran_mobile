import 'package:flutter/widgets.dart';

/// The direction of page turn animation relative to standard RTL flow.
enum TransitionDirection {
  /// Navigating forward in the reading order (Page 1 -> Page 2)
  forward,

  /// Navigating backward in the reading order (Page 2 -> Page 1)
  backward,
}

/// Abstract contract managing page turns, drag offsets, and swiping animations.
/// Decouples visual transition implementations (Standard Slide, Page Curl, etc.) from the page model.
abstract class PageTurnController {
  /// Transitions the reading view to target page index with animation.
  void transitionToPage(int pageIndex, {required TransitionDirection direction});

  /// Captures gesture drag update offsets.
  void handleDragUpdate(double dragOffset);

  /// Captures drag velocity termination points to resolve final scroll snap.
  void handleDragEnd(double dragVelocity);

  /// Progress indicator of the active page transition (0.0 to 1.0).
  ValueNotifier<double> get transitionProgress;
}
