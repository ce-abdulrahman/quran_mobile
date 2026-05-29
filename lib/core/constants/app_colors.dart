import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────
  static const Color primaryGreen      = Color(0xFF0F5A3F); // Premium Emerald Green
  static const Color primaryGreenDeep  = Color(0xFF093E2B); // Deep Forest Green
  static const Color accentGold        = Color(0xFFD4AF37); // Soft Champagne Gold
  static const Color accentGoldDeep    = Color(0xFFB8860B);

  // ── Dark Theme ───────────────────────────────────
  static const Color darkBg            = Color(0xFF0D131E); // Warm Dark Slate
  static const Color darkSurface       = Color(0xFF121926); // Warm Dark Surface
  static const Color darkCard          = Color(0xFF1A2232); // Soft Dark Card
  static const Color darkCardBorder    = Color(0xFF242E42); // Soft Dark Border
  static const Color darkNavBar        = Color(0xFF111827);
  static const Color darkTextPrimary   = Color(0xFFE8EDF5);
  static const Color darkTextSecondary = Color(0xFF7A8FA6);
  static const Color darkDivider       = Color(0xFF1E2D44);

  // ── Light Theme ──────────────────────────────────
  static const Color lightBg            = Color(0xFFF9F8F6); // Warm Sand / Cream Background
  static const Color lightSurface       = Color(0xFFFFFFFF);
  static const Color lightCard          = Color(0xFFFFFFFF);
  static const Color lightCardBorder    = Color(0xFFEAE7E2); // Warm Card Border
  static const Color lightNavBar        = Color(0xFFFFFFFF);
  static const Color lightTextPrimary   = Color(0xFF1A2332);
  static const Color lightTextSecondary = Color(0xFF6B7A8D);
  static const Color lightDivider       = Color(0xFFEEF0EC);

  // ── Badges ───────────────────────────────────────
  static const Color meccanBadge  = Color(0xFF4DB88A);
  static const Color medinanBadge = Color(0xFF5B8FD4);

  // ── Status ───────────────────────────────────────
  static const Color error   = Color(0xFFE57373);
  static const Color success = Color(0xFF66BB6A);
}

// ── Theme Extension ──────────────────────────────────────────────────────────

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.bg,
    required this.surface,
    required this.card,
    required this.cardBorder,
    required this.navBar,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.primary,
    required this.accent,
  });

  final Color bg;
  final Color surface;
  final Color card;
  final Color cardBorder;
  final Color navBar;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color primary;
  final Color accent;

  factory AppColorScheme.dark() => const AppColorScheme(
    bg:            AppColors.darkBg,
    surface:       AppColors.darkSurface,
    card:          AppColors.darkCard,
    cardBorder:    AppColors.darkCardBorder,
    navBar:        AppColors.darkNavBar,
    textPrimary:   AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    divider:       AppColors.darkDivider,
    primary:       AppColors.primaryGreen,
    accent:        AppColors.accentGold,
  );

  factory AppColorScheme.light() => const AppColorScheme(
    bg:            AppColors.lightBg,
    surface:       AppColors.lightSurface,
    card:          AppColors.lightCard,
    cardBorder:    AppColors.lightCardBorder,
    navBar:        AppColors.lightNavBar,
    textPrimary:   AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    divider:       AppColors.lightDivider,
    primary:       AppColors.primaryGreenDeep,
    accent:        AppColors.accentGoldDeep,
  );

  static AppColorScheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorScheme>()!;

  @override
  AppColorScheme copyWith({
    Color? bg, Color? surface, Color? card, Color? cardBorder,
    Color? navBar, Color? textPrimary, Color? textSecondary,
    Color? divider, Color? primary, Color? accent,
  }) => AppColorScheme(
    bg:            bg            ?? this.bg,
    surface:       surface       ?? this.surface,
    card:          card          ?? this.card,
    cardBorder:    cardBorder    ?? this.cardBorder,
    navBar:        navBar        ?? this.navBar,
    textPrimary:   textPrimary   ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    divider:       divider       ?? this.divider,
    primary:       primary       ?? this.primary,
    accent:        accent        ?? this.accent,
  );

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      bg:            Color.lerp(bg, other.bg, t)!,
      surface:       Color.lerp(surface, other.surface, t)!,
      card:          Color.lerp(card, other.card, t)!,
      cardBorder:    Color.lerp(cardBorder, other.cardBorder, t)!,
      navBar:        Color.lerp(navBar, other.navBar, t)!,
      textPrimary:   Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider:       Color.lerp(divider, other.divider, t)!,
      primary:       Color.lerp(primary, other.primary, t)!,
      accent:        Color.lerp(accent, other.accent, t)!,
    );
  }
}
