import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/feature_flag_provider.dart';
import '../../core/providers/prayer_times_provider.dart';
import '../prayer/providers/prayer_times_provider.dart';
import '../prayer/providers/prayer_widget_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  void _syncPrayerTimesOnBoot() {
    try {
      final settings = ref.read(prayerTimesSettingsProvider);
      final city = settings.selectedCity;
      final matched = settings.cities.firstWhere(
        (c) => c.nameEn.toLowerCase() == city.nameEn.toLowerCase(),
        orElse: () => city,
      );
      final cityId = matched.id ?? 1;
      final year = DateTime.now().year;

      ref.read(prayerTimesRepositoryProvider).fetchYear(
        cityId: cityId,
        year: year,
      ).then((_) {
        ref.read(prayerTimesSettingsProvider.notifier).reschedule();
        ref.read(prayerWidgetProvider.notifier).refreshWidgetData().catchError((_) {});
      }).catchError((_) {});
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    // Kick off auth check + feature flag sync in parallel during splash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Auth check (non-blocking; app_shell handles all states gracefully)
      ref.read(authProvider.notifier).checkAuthState();
      // Feature flags background sync (uses cached flags if offline)
      ref.read(featureFlagServiceProvider).sync();
      // Prayer times background sync on boot
      _syncPrayerTimesOnBoot();
    });
    Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/shell');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentGradient = ref.watch(accentColorProvider);
    final accentColor = accentGradient.primary;
    final accentColorDeep = AppColorScheme.darken(accentColor, 0.12);
    final accentColorLight = AppColorScheme.darken(accentColor, -0.06);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    AppColorScheme.darken(accentColor, 0.42),
                    AppColorScheme.darken(accentColor, 0.35),
                    AppColorScheme.darken(accentColor, 0.28),
                  ]
                : [
                    accentColorDeep,
                    accentColor,
                    accentColorLight,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ── Decorative background circles ────────────────────────
              Positioned(
                top: -80,
                right: -60,
                child: _GlowCircle(
                  size: 280,
                  color: Colors.white.withValues(alpha: isDark ? 0.03 : 0.08),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -80,
                child: _GlowCircle(
                  size: 320,
                  color: Colors.white.withValues(alpha: isDark ? 0.03 : 0.06),
                ),
              ),
              Positioned(
                top: 160,
                left: -40,
                child: _GlowCircle(
                  size: 140,
                  color: Colors.white.withValues(alpha: isDark ? 0.02 : 0.05),
                ),
              ),

              // ── Center content ───────────────────────────────────────
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo circle
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: ClipOval(
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.auto_stories_rounded,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                          begin: const Offset(0.6, 0.6),
                          end: const Offset(1.0, 1.0),
                          duration: 700.ms,
                          curve: Curves.easeOutBack,
                        ),

                    const SizedBox(height: 28),

                    // App title
                    const Text(
                      'قورئانەکەم',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 600.ms,
                          delay: 300.ms,
                          curve: Curves.easeOut,
                        ),

                    const SizedBox(height: 10),

                    // Tagline
                    Text(
                      'ئاراممان دەکات • ڕێنماییمان دەدات',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.75),
                        letterSpacing: 0.3,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 550.ms),

                    const SizedBox(height: 60),

                    // Loading dots
                    _LoadingDots()
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 900.ms),
                  ],
                ),
              ),

              // ── Bottom bismillah ─────────────────────────────────────
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'UthmanicHafs',
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.55),
                    height: 2,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glow Circle
// ─────────────────────────────────────────────────────────────────────────────

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading Dots
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final t = (_ctrl.value + i * 0.2) % 1.0;
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.2, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: opacity),
              ),
            );
          },
        );
      }),
    );
  }
}
