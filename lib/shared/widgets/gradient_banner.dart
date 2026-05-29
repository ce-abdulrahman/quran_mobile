import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/l10n/app_localizations.dart';

/// Gradient Islamic quote banner shown on the Home page.
class GradientBanner extends StatelessWidget {
  const GradientBanner({
    super.key,
    required this.arabicText,
    required this.translationText,
    required this.source,
  });

  final String arabicText;
  final String translationText;
  final String source;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF163D2B), const Color(0xFF1A4535)]
              : [const Color(0xFF1B6B47), const Color(0xFF2E8B5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreenDeep.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Label
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.accentGold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l.homeDailyVerse,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Arabic verse
                Text(
                  arabicText,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    height: 1.8,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Divider
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),

                const SizedBox(height: AppSpacing.md),

                // Translation
                Text(
                  translationText,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Source
                Text(
                  source,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: AppColors.accentGold.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
