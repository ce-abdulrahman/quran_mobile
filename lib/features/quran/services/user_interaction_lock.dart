import 'dart:async';
import 'package:flutter/foundation.dart';

/// Manage lock states coordinating active user gestures (panning, zooming)
/// with automated background page modifications (like audio autoplay turns).
class UserInteractionLock {
  /// True if the user is actively interacting with the viewport canvas.
  final ValueNotifier<bool> isLocked = ValueNotifier<bool>(false);
  Timer? _lockReleaseTimer;

  /// Call this when the user initiates a gesture (pinch, drag, tap).
  void acquireLock() {
    _lockReleaseTimer?.cancel();
    isLocked.value = true;
  }

  /// Call this when the user releases their gesture. Releases the active lock
  /// state after a default cooldown timer (1500ms of user inactivity).
  void releaseLock({Duration cooldown = const Duration(milliseconds: 1500)}) {
    _lockReleaseTimer?.cancel();
    _lockReleaseTimer = Timer(cooldown, () {
      isLocked.value = false;
    });
  }

  /// Executes the given [action] only if the interaction lock is currently inactive.
  /// Returns true if executed, false if suppressed to prevent user interruption.
  bool executeSafe(VoidCallback action) {
    if (isLocked.value) {
      return false;
    }
    action();
    return true;
  }

  /// Cancels active timers to prevent memory leaks.
  void dispose() {
    _lockReleaseTimer?.cancel();
    isLocked.dispose();
  }
}
