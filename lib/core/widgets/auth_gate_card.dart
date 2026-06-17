import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../providers/app_providers.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/auth/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AuthGateCard
//
// A contextual, non-blocking auth prompt shown when a guest user attempts
// to access a feature that requires cloud synchronization (e.g. Memorization,
// Leaderboard, Statistics). Replaces the old full-screen WelcomePage redirect.
//
// Usage:
//   if (!ref.watch(authProvider).isAuthenticated) {
//     return const AuthGateCard();
//   }
// ─────────────────────────────────────────────────────────────────────────────

class AuthGateCard extends ConsumerWidget {
  /// Optional: pass false to hide the "Continue as Guest" button.
  final bool showContinueAsGuest;

  /// Optional: feature-specific context shown below the description.
  final String? featureContext;

  const AuthGateCard({
    super.key,
    this.showContinueAsGuest = false,
    this.featureContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final accentColor = ref.watch(accentColorProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: cs.card,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: isDark ? 0.12 : 0.08),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lock icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.15),
                      accentColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: accentColor,
                  size: 30,
                ),
              ).animate().scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 20),

              // Title
              Text(
                'پێشکەوتنەکانت بپارێزە',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: cs.textPrimary,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

              const SizedBox(height: 10),

              // Description
              Text(
                'هەژمارێک دروست بکە یان بچۆ ژوورەوە بۆ پاشەکەوتکردنی '
                'پلانەکانی لەبەرکردن، پێداچوونەوەکان، ئامارەکان، و پێشکەوتنت '
                'بە شێوەیەکی پارێزراو لەسەر هەموو ئامێرەکانت.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13.5,
                  color: cs.textSecondary,
                  height: 1.55,
                ),
              ).animate().fadeIn(delay: 180.ms, duration: 350.ms),

              // Optional feature-specific context
              if (featureContext != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    featureContext!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(delay: 250.ms, duration: 300.ms),
              ],

              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'چوونە ژوورەوە',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().slideY(begin: 0.3, end: 0, delay: 300.ms, duration: 350.ms),

              const SizedBox(height: 10),

              // Register button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: BorderSide(color: accentColor.withValues(alpha: 0.5)),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'خۆتۆمارکردن',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().slideY(begin: 0.4, end: 0, delay: 370.ms, duration: 350.ms),

              // Continue as Guest (optional)
              if (showContinueAsGuest) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).continueAsGuest();
                  },
                  child: Text(
                    'بەردەوامبوون وەک میوان',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: cs.textSecondary,
                    ),
                  ),
                ).animate().fadeIn(delay: 450.ms, duration: 300.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
