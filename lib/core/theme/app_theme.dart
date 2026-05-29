import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _buildTextTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    // Cairo for all UI text
    return GoogleFonts.cairoTextTheme(base);
  }

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryGreenDeep,
          secondary: AppColors.accentGoldDeep,
          surface: AppColors.lightSurface,
        ),
        scaffoldBackgroundColor: AppColors.lightBg,
        textTheme: _buildTextTheme(Brightness.light),
        splashColor: AppColors.primaryGreenDeep.withValues(alpha: 0.08),
        highlightColor: Colors.transparent,
        extensions: const [_lightScheme],
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryGreen,
          secondary: AppColors.accentGold,
          surface: AppColors.darkSurface,
        ),
        scaffoldBackgroundColor: AppColors.darkBg,
        textTheme: _buildTextTheme(Brightness.dark),
        splashColor: AppColors.primaryGreen.withValues(alpha: 0.08),
        highlightColor: Colors.transparent,
        extensions: const [_darkScheme],
      );

  static const _lightScheme = AppColorScheme(
    bg: AppColors.lightBg,
    surface: AppColors.lightSurface,
    card: AppColors.lightCard,
    cardBorder: AppColors.lightCardBorder,
    navBar: AppColors.lightNavBar,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    divider: AppColors.lightDivider,
    primary: AppColors.primaryGreenDeep,
    accent: AppColors.accentGoldDeep,
  );

  static const _darkScheme = AppColorScheme(
    bg: AppColors.darkBg,
    surface: AppColors.darkSurface,
    card: AppColors.darkCard,
    cardBorder: AppColors.darkCardBorder,
    navBar: AppColors.darkNavBar,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    divider: AppColors.darkDivider,
    primary: AppColors.primaryGreen,
    accent: AppColors.accentGold,
  );
}
