import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/home/home_page.dart';
import '../features/auth/welcome_page.dart';
import '../features/auth/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// App Shell — Bottom Navigation Container
// ─────────────────────────────────────────────────────────────────────────────

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (authState.status == AuthStatus.unauthenticated || authState.status == AuthStatus.error) {
      return const WelcomePage();
    }

    return const HomePage();
  }
}
