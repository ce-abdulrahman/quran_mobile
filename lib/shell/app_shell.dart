import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/home_page.dart';
import '../core/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// App Shell — Bottom Navigation Container
//
// Architecture: Guest-Mode First
// All users (authenticated, guest, or new) land directly on HomePage.
// Authentication is requested contextually when cloud-sync features are
// accessed (memorization, leaderboard, statistics) via AuthGateCard.
// ─────────────────────────────────────────────────────────────────────────────

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Show a brief loading indicator only during the initial auth token check.
    // This typically resolves in < 500ms on first boot.
    if (authState.status == AuthStatus.initial ||
        authState.status == AuthStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // All states (authenticated, guest, unauthenticated) proceed to HomePage.
    // Feature-specific auth gating is handled contextually inside each page
    // via AuthGateCard — never at the shell level.
    return const HomePage();
  }
}
