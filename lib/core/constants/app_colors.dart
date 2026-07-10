import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primaryGreen = Color(0xFF075E45);
  static const primaryGreenDeep = Color(0xFF023224);
  static const accentGoldDeep = Color(0xFFCD9D27);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF17211B);
  static const textDark = Color(0xFF111827);
  static const textLight = Color(0xFFF7F7F7);

  /// ڕەنگە هەڵبژاردەکانی تایبەت - flat
  static const accentColorOptions = [
    (Color(0xFF075E45), 'سەوزی قورئانەکەم'), // Logo green (default)
    (Color(0xFF4CAF50), 'سەوزی کاڵ'),       // light green (boy)
    (Color(0xFF2196F3), 'شینی کاڵ'),       // light blue (boy)
    (Color(0xFFE91E63), 'پەمەیی ناسک'),    // pink (girl)
    (Color(0xFFF44336), 'سووری کاڵ'),      // light red (girl)
  ];

  /// گرادیەنتی تایبەت - (startColor, endColor, primaryColor, label)
  static const accentGradientOptions = [
    // Logo Green (سەوزی قورئانەکەم)
    (Color(0xFF075E45), Color(0xFF023224), Color(0xFF075E45), 'سەوزی قورئانەکەم'),
    // Light Green (سەوزی کاڵ)
    (Color(0xFF81C784), Color(0xFF388E3C), Color(0xFF4CAF50), 'سەوزی کاڵ'),
    // Light Blue (شینی کاڵ)
    (Color(0xFF64B5F6), Color(0xFF1976D2), Color(0xFF2196F3), 'شینی کاڵ'),
    // Soft Pink (پەمەیی ناسک)
    (Color(0xFFF48FB1), Color(0xFFC2185B), Color(0xFFE91E63), 'پەمەیی ناسک'),
    // Light Red (سووری کاڵ)
    (Color(0xFFEF9A9A), Color(0xFFD32F2F), Color(0xFFF44336), 'سووری کاڵ'),
  ];
}

class AppThemeTokens {
  AppThemeTokens._();

  // Spacing
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s32 = 32.0;

  // Radius
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r28 = 28.0;
  static const double r32 = 32.0;

  // Durations
  static const Duration d150 = Duration(milliseconds: 150);
  static const Duration d250 = Duration(milliseconds: 250);
  static const Duration d350 = Duration(milliseconds: 350);
  static const Duration d500 = Duration(milliseconds: 500);

  // Islamic Accent Colors
  static const Color emerald = Color(0xFF1AB66D);
  static const Color gold = Color(0xFFCD9D27);
  static const Color sepia = Color(0xFF7A726F);
}

class AppColorScheme {
  final Color bg;
  final Color card;
  final Color cardBorder;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color primary;
  final Color primaryDeep;

  const AppColorScheme({
    required this.bg,
    required this.card,
    required this.cardBorder,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.primary,
    required this.primaryDeep,
  });

  static Color darken(Color color, [double amount = .12]) {
    assert(amount >= -1 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static AppColorScheme of(BuildContext context, [String? bgMode]) {
    final brightness = Theme.of(context).brightness;
    final primary = Theme.of(context).colorScheme.primary;
    final primaryDeep = darken(primary, 0.12);

    final mode = bgMode ?? (brightness == Brightness.dark ? 'dark' : 'light');

    if (mode == 'cream') {
      return AppColorScheme(
        bg: const Color(0xFFF5EFEB),
        card: const Color(0xFFFDFBF7),
        cardBorder: const Color(0xFFEDE5DF),
        divider: const Color(0xFFEDE5DF),
        textPrimary: const Color(0xFF2E2B2A),
        textSecondary: const Color(0xFF7A726F),
        primary: primary,
        primaryDeep: primaryDeep,
      );
    } else if (mode == 'khaki') {
      return AppColorScheme(
        bg: const Color(0xFFEDEADF),
        card: const Color(0xFFF6F3EB),
        cardBorder: const Color(0xFFDFDACB),
        divider: const Color(0xFFDFDACB),
        textPrimary: const Color(0xFF2C2A24),
        textSecondary: const Color(0xFF787265),
        primary: primary,
        primaryDeep: primaryDeep,
      );
    } else if (mode == 'dark') {
      return AppColorScheme(
        bg: const Color(0xFF09120D),
        card: const Color(0xFF0F1F18),
        cardBorder: const Color(0xFF183126),
        divider: const Color(0xFF1E3A2F),
        textPrimary: const Color(0xFFE6F3E8),
        textSecondary: const Color(0xFFB8D8C0),
        primary: primary,
        primaryDeep: primaryDeep,
      );
    } else { // light / default
      return AppColorScheme(
        bg: const Color(0xFFF5F7F5),
        card: const Color(0xFFFFFFFF),
        cardBorder: const Color(0xFFE2E8E1),
        divider: const Color(0xFFCBD5C4),
        textPrimary: const Color(0xFF1F2937),
        textSecondary: const Color(0xFF6B7280),
        primary: primary,
        primaryDeep: primaryDeep,
      );
    }
  }
}
