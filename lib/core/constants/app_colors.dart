import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primaryGreen = Color(0xFF1AB66D);
  static const primaryGreenDeep = Color(0xFF0F8F4C);
  static const accentGoldDeep = Color(0xFFCD9D27);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF17211B);
  static const textDark = Color(0xFF111827);
  static const textLight = Color(0xFFF7F7F7);

  /// ڕەنگە هەڵبژاردەکانی تایبەت
  static const accentColorOptions = [
    (Color(0xFF1AB66D), 'سەوز'),       // default green
    (Color(0xFF2196F3), 'شین'),        // blue
    (Color(0xFF7B1FA2), 'ئەرغووانی'), // purple
    (Color(0xFFF57F17), 'زەرد'),       // amber
    (Color(0xFFE53935), 'سووری'),      // red
    (Color(0xFF00695C), 'تیاوی'),      // teal
  ];
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

  static AppColorScheme of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final primary = Theme.of(context).colorScheme.primary;
    final primaryDeep = darken(primary, 0.12);
    if (brightness == Brightness.dark) {
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
    }
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
