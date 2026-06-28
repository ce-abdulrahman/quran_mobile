import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
import 'auth_provider.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accentColor = ref.watch(accentColorProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColorScheme.darken(accentColor, 0.45),
                    AppColorScheme.darken(accentColor, 0.35),
                  ]
                : [
                    AppColorScheme.darken(accentColor, 0.1),
                    accentColor,
                    AppColorScheme.darken(accentColor, -0.08),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Logo or Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ).animate().scale(
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                ),
                
                const SizedBox(height: 24),
                
                // Welcome Title
                Text(
                  l.authWelcomeTitle,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                
                const SizedBox(height: 12),
                
                // Subtitle
                Text(
                  l.authWelcomeSub,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontFamily: 'Cairo',
                    height: 1.6,
                  ),
                ).animate().fadeIn(delay: 350.ms, duration: 450.ms),
                
                const Spacer(),
                
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: accentColor,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    l.authLoginButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ).animate().slideY(begin: 0.4, end: 0, delay: 500.ms, duration: 400.ms),
                
                const SizedBox(height: 16),
                
                // Register Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l.authRegisterButton,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ).animate().slideY(begin: 0.5, end: 0, delay: 600.ms, duration: 400.ms),
                
                const SizedBox(height: 24),
                
                // Guest Button
                TextButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).continueAsGuest();
                  },
                  child: Text(
                    l.authGuestButton,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ).animate().fadeIn(delay: 750.ms, duration: 400.ms),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
