import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import 'auth_page.dart';
import 'auth_provider.dart';

class AuthGuard extends ConsumerWidget {
  const AuthGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final cs = AppColorScheme.of(context);
    final lang = ref.watch(localeProvider).languageCode;
    final isRtl = lang != 'en';

    if (authState.isAuthenticated) {
      return child;
    }

    // Localized strings
    final title = lang == 'en'
        ? 'Join the Quran Community'
        : lang == 'ar'
            ? 'انضم إلى مجتمع قورئانەکەم'
            : 'ببەرە بەشێک لە کۆمەڵگەی قورئانەکەم';

    final subtitle = lang == 'en'
        ? 'Track your reading streaks, compete on the global leaderboard, and earn points together.'
        : lang == 'ar'
            ? 'تابع تقدم قراءتك، نافس في جدول الصدارة العالمي، واجمع النقاط معاً.'
            : 'چاودێری ستریکی خوێندنەوەت بکە، پێشبڕکێ بکە لە خشتەی پێشەنگەکانی جیهانی، و پێکەوە خاڵ کۆبکەنەوە.';

    final feature1 = lang == 'en' ? 'Track Reading Streaks' : lang == 'ar' ? 'متابعة سلاسل القراءة (Streaks)' : 'چاودێری ستریکی خوێندنەوە';
    final feature2 = lang == 'en' ? 'Global Rank & Leaderboard' : lang == 'ar' ? 'جدول الصدارة العالمي' : 'پێشەنگی و ڕیزبەندی جیهانی';
    final feature3 = lang == 'en' ? 'Earn Achievement Points' : lang == 'ar' ? 'كسب نقاط الإنجازات' : 'کۆکردنەوەی خاڵەکانی دەستکەوت';

    final btnText = lang == 'en' ? 'Sign In / Register' : lang == 'ar' ? 'تسجيل الدخول / إنشاء حساب' : 'چوونەژوورەوە / خۆتۆمارکردن';

    return Scaffold(
      backgroundColor: cs.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Trophy / Community illustration in premium style
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 64,
                    color: cs.accent,
                  ),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 32),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: cs.textPrimary,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: cs.textSecondary,
                  height: 1.5,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

              const SizedBox(height: 36),

              // Features List
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem(context, Icons.local_fire_department_rounded, feature1, isRtl, cs),
                    const Divider(height: 24),
                    _buildFeatureItem(context, Icons.leaderboard_rounded, feature2, isRtl, cs),
                    const Divider(height: 24),
                    _buildFeatureItem(context, Icons.stars_rounded, feature3, isRtl, cs),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideY(begin: 0.1),

              const Spacer(),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AuthPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        btnText,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 400.ms),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text, bool isRtl, AppColorScheme cs) {
    return Row(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: cs.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: cs.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
