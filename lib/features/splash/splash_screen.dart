import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../shell/main_shell.dart';
import '../quran/quran_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Start database pre-population while splash displays
    final dbInitFuture = ref.read(localSurahsProvider.future);
    
    // Ensure the splash screen shows for at least 2.5 seconds for branding animation
    await Future.wait([
      dbInitFuture,
      Future.delayed(const Duration(milliseconds: 2500)),
    ]);
    
    _navigate();
  }

  void _navigate() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainShell(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Logo ────────────────────────────────────────────
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryGreen, Color(0xFF2A7A5A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withValues(alpha: 0.35),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative inner ring
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  const Text('☪', style: TextStyle(fontSize: 48, color: Colors.white)),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 700.ms, delay: 200.ms)
                .scale(
                  begin: const Offset(0.6, 0.6),
                  duration: 800.ms,
                  delay: 200.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 36),

            // ── App Name ─────────────────────────────────────────
            Text(
              l.appName,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                height: 1.2,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 700.ms)
                .slideY(begin: 0.25, duration: 600.ms, delay: 700.ms, curve: Curves.easeOut),

            const SizedBox(height: 8),

            // ── Subtitle ─────────────────────────────────────────
            Text(
              l.appSubtitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 1000.ms),

            const SizedBox(height: 80),

            // ── Loading dots ──────────────────────────────────────
            _LoadingDots(
              color: isDark ? AppColors.primaryGreen : AppColors.primaryGreenDeep,
            ).animate().fadeIn(duration: 400.ms, delay: 1400.ms),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots({required this.color});
  final Color color;

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final delay = i / 3;
          final t = (_ctrl.value - delay).clamp(0.0, 1.0);
          final opacity = (0.3 + 0.7 * (t < 0.5 ? t * 2 : 2 - t * 2)).clamp(0.3, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Opacity(
              opacity: opacity,
              child: CircleAvatar(radius: 4, backgroundColor: widget.color),
            ),
          );
        }),
      ),
    );
  }
}
