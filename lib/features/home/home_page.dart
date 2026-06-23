import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/statistics_provider.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/banner_model.dart';
import '../../core/utils/responsive.dart';
import '../search/search_page.dart';
import '../quran/quran_page.dart';
import '../quran/quran_reader_page.dart';
import '../bookmarks/bookmarks_page.dart';
import '../favorites/favorites_page.dart';
import '../settings/settings_page.dart';
import '../tracker/reading_tracker_page.dart';
import '../khatm/khatm_tracker_page.dart';
import '../adhkar/adhkar_page.dart';
import '../tasbih/tasbih_page.dart';
import '../memorization/memorization_dashboard_page.dart';
import '../../core/providers/prayer_times_provider.dart';
import '../prayer/prayer_times_page.dart';
import '../prayer/widgets/prayer_widget_card.dart';
import '../hadith/hadith_page.dart';
import '../tajweed/tajweed_page.dart';
import '../auth/welcome_page.dart';
import '../auth/profile_page.dart';
import '../auth/login_page.dart';
import '../auth/register_page.dart';
import '../../core/providers/auth_provider.dart';
import '../tasbih/themes/theme_selector_page.dart';
import '../../core/providers/tasbih_session_provider.dart';
import '../tasbih/active_session_page.dart';
import '../achievements/achievements_page.dart';
import '../tasbih/fingerprint/fingerprint_counter_page.dart';
import '../leaderboard/leaderboard_page.dart';
import '../statistics/statistics_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Ad Slide Data
// ─────────────────────────────────────────────────────────────────────────────

class _AdSlide {
  final String titleArabic;
  final String verse;
  final String source;
  final AyahModel? ayah;
  const _AdSlide(this.titleArabic, this.verse, this.source, {this.ayah});
}

const _slides = [
  _AdSlide(
    'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ',
    'ئەم قورئانە ڕێنمایی دەکات بۆ ئەوەی ڕاستترینەوە',
    '— ئیسرا ١٧:٩',
  ),
  _AdSlide(
    'وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ',
    'ئێمە قورئانەکەمان ئاسان کرد بۆ یادەوەری',
    '— القمر ٥٤:١٧',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Category Data
// ─────────────────────────────────────────────────────────────────────────────

class _CatData {
  final IconData icon;
  final Color iconColor;
  final String Function(AppLocalizations) label;
  final VoidCallback Function(WidgetRef, BuildContext) onTap;

  const _CatData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
}

List<_CatData> _buildCats(BuildContext context) => [
      _CatData(
        icon: Icons.menu_book_rounded,
        iconColor: AppColorScheme.of(context).primary,
        label: (l) => l.quranTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const QuranPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.psychology_rounded,
        iconColor: const Color(0xFFCD9D27),
        label: (l) => l.memorizationQuizTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const MemorizationDashboardPage()),
            ),
      ),
      _CatData(
        icon: Icons.assignment_turned_in_rounded,
        iconColor: const Color(0xFF0F8F4C),
        label: (l) => l.khatmTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const KhatmTrackerPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.wb_sunny_rounded,
        iconColor: const Color(0xFFFF9800),
        label: (l) => l.adhkarTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const AdhkarPage()),
            ),
      ),
      _CatData(
        icon: Icons.auto_stories_rounded,
        iconColor: const Color(0xFFE53935),
        label: (l) => 'فەرموودە',
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const HadithPage()),
            ),
      ),
      _CatData(
        icon: Icons.school_rounded,
        iconColor: const Color(0xFF9C27B0),
        label: (l) => 'فێربوونی تەجوید',
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const TajweedPage()),
            ),
      ),
      _CatData(
        icon: Icons.fingerprint_rounded,
        iconColor: const Color(0xFF009688),
        label: (l) => l.tasbihTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const TasbihPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.mosque_rounded,
        iconColor: const Color(0xFF0F8F4C),
        label: (l) => l.prayerTimesTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const PrayerTimesPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.bar_chart_rounded,
        iconColor: const Color(0xFFFF5722),
        label: (l) => 'ئاماری خوێندن',
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const ReadingTrackerPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.insights_rounded,
        iconColor: const Color(0xFF6F42C1),
        label: (l) => l.statsAndInsightsTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const StatisticsPage()),
            ),
      ),
      _CatData(
        icon: Icons.bookmark_rounded,
        iconColor: const Color(0xFF1A3A5C),
        label: (l) => l.navBookmarks,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const BookmarksPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.star_rounded,
        iconColor: const Color(0xFFE6A23C),
        label: (l) => l.navFavorites,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const FavoritesPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.search_rounded,
        iconColor: const Color(0xFF5B1A8A),
        label: (l) => l.searchTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
      ),
      _CatData(
        icon: Icons.settings_rounded,
        iconColor: const Color(0xFF546E7A),
        label: (l) => l.navSettings,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SettingsPage(showBackButton: true)),
            ),
      ),
    ];

// ─────────────────────────────────────────────────────────────────────────────
// HomePage
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  /// Send fallback today's verse to the Android home screen widget
  static Future<void> _updateWidgetDefault() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'widget_arabic_text',
        'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_kurdish_text',
        'ئەم قورئانە ڕێنمایی دەکات بۆ ئەوەی ڕاستترینەوە',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_surah_name',
        '— ئیسرا ١٧:٩',
      );
      await HomeWidget.updateWidget(
        androidName: 'QuranWidgetProvider',
      );
    } catch (_) {}
  }

  /// Send today's verse to the Android home screen widget
  static Future<void> _updateWidgetWithData(
    String arabicText,
    String kurdishText,
    String surahName,
  ) async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'widget_arabic_text',
        arabicText,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_kurdish_text',
        kurdishText,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_surah_name',
        surahName,
      );
      await HomeWidget.updateWidget(
        androidName: 'QuranWidgetProvider',
      );
    } catch (_) {}
  }

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final Map<int, bool> _expandedCards = {
    5: false, // Next Achievement
    6: false, // Last Session
    7: false, // Quick Statistics
    8: false, // Smart Insight
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.status == AuthStatus.authenticated && authState.user != null) {
        ref.read(statisticsProvider.notifier).load('30d');
        ref.read(tasbihSessionProvider.notifier).fetchHistory();
      }
    });
  }

  void _showChangeGoalDialog() {
    final tasbihState = ref.read(tasbihProvider);
    final customCtrl = TextEditingController();
    int? selectedPredefined = [100, 500, 1000].contains(tasbihState.dailyGoalValue)
        ? tasbihState.dailyGoalValue
        : null;

    if (selectedPredefined == null) {
      customCtrl.text = tasbihState.dailyGoalValue.toString();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        final cs = AppColorScheme.of(context);
        final l = context.l10n;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: cs.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                l.tasbihGoalSelect,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.tasbihPredefinedGoals,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [100, 500, 1000].map((val) {
                      final isSelected = selectedPredefined == val;
                      return ChoiceChip(
                        label: Text('$val', style: const TextStyle(fontFamily: 'Cairo')),
                        selected: isSelected,
                        selectedColor: cs.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : cs.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setDialogState(() {
                              selectedPredefined = val;
                              customCtrl.clear();
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.tasbihCustomGoal,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: customCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo', color: cs.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'نموونە: 1500',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (val) {
                      if (val.trim().isNotEmpty) {
                        setDialogState(() {
                          selectedPredefined = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'پاشگەزبوونەوە',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int? finalVal;
                    if (selectedPredefined != null) {
                      finalVal = selectedPredefined;
                    } else {
                      finalVal = int.tryParse(customCtrl.text.trim());
                    }

                    if (finalVal != null && finalVal > 0) {
                      ref.read(tasbihProvider.notifier).setDailyGoal(finalVal);
                      Navigator.pop(ctx);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'ئامانجی ڕۆژانە گۆڕدرا بۆ $finalVal زیکر',
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: const Color(0xFF0F8F4C),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l.tasbihGoalMinError,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'سەپاندن',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGuestProfileCard(BuildContext context, Color accentColor, AppColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_outline_rounded, color: accentColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.l10n.welcome,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.guestProfileSub,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: cs.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    context.l10n.login,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(
                    context.l10n.register,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayDhikrCard(
    BuildContext context,
    AppColorScheme cs,
    Color accentColor,
    StatisticsState statisticsState,
    TasbihState tasbihState,
    String locale,
  ) {
    final todayCount = tasbihState.dailyGoalProgress;
    final trendPct = statisticsState.dhikr.trendPct;
    final trendDirection = statisticsState.dhikr.trendDirection;

    String trendText = '';
    if (trendPct > 0) {
      if (locale == 'ku') {
        trendText = trendDirection == 'up'
            ? '+$trendPct% زیاتر لە دوێنێ'
            : '-$trendPct% کەمتر لە دوێنێ';
      } else if (locale == 'ar') {
        trendText = trendDirection == 'up'
            ? '+$trendPct% أكثر من أمس'
            : '-$trendPct% أقل من أمس';
      } else {
        trendText = trendDirection == 'up'
            ? '+$trendPct% than yesterday'
            : '-$trendPct% than yesterday';
      }
    } else {
      trendText = locale == 'ku' ? 'ئەمڕۆ جێگیرە بە بەراورد لەگەڵ دوێنێ' : 'Steady comparison to yesterday';
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.circle_outlined, color: accentColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale == 'ku' ? 'زیکری ئەمڕۆ' : 'Today\'s Dhikr',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  NumberFormat.decimalPattern().format(todayCount),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  trendText,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: trendDirection == 'up' ? const Color(0xFF0F8F4C) : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalProgressCard(
    BuildContext context,
    AppColorScheme cs,
    Color accentColor,
    TasbihState tasbihState,
  ) {
    final progress = tasbihState.dailyGoalProgress;
    final goal = tasbihState.dailyGoalValue;
    final pct = goal > 0 ? (progress / goal).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: _showChangeGoalDialog,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.track_changes_rounded, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.tasbihDailyGoal,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cs.textSecondary,
                        ),
                      ),
                      Text(
                        '$progress / $goal',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 8,
                      backgroundColor: cs.divider.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.edit_rounded, size: 10, color: cs.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        context.l10n.tasbihChangeGoal,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStreakCard(
    BuildContext context,
    AppColorScheme cs,
    Color accentColor,
    TasbihState tasbihState,
  ) {
    final current = tasbihState.currentStreak;
    final best = tasbihState.longestStreak;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3CD),
              shape: BoxShape.circle,
            ),
            child: const Text('🔥', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.menuStreakSystem,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cs.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$current ڕۆژ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: cs.textPrimary,
                          ),
                        ),
                        const Text(
                          'ئەمڕۆ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$best ڕۆژ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: cs.textPrimary,
                          ),
                        ),
                        Text(
                          context.l10n.bestStreakLabel,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            color: cs.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAchievementCard(
    BuildContext context,
    AppColorScheme cs,
    Color accentColor,
    StatisticsState statisticsState,
  ) {
    if (statisticsState.isLoading) {
      return _buildCardSkeleton(cs);
    }

    final nextMilestone = statisticsState.milestones.isEmpty
        ? null
        : statisticsState.milestones.firstWhere((m) => !m.completed, orElse: () => statisticsState.milestones.last);

    if (nextMilestone == null) {
      return const SizedBox.shrink();
    }

    final pct = nextMilestone.target > 0
        ? (nextMilestone.current / nextMilestone.target).clamp(0.0, 1.0)
        : 0.0;

    return _HomeCollapsibleCard(
      title: context.l10n.cardNextAchievement,
      emoji: '🏆',
      isInitiallyExpanded: _expandedCards[5] ?? false,
      onToggle: (exp) {
        setState(() {
          _expandedCards[5] = exp;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  nextMilestone.label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
              ),
              Text(
                '${nextMilestone.current} / ${nextMilestone.target}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: cs.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: cs.divider.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastSessionCard(
    BuildContext context,
    AppColorScheme cs,
    Color accentColor,
    TasbihSessionState sessionState,
  ) {
    if (sessionState.isLoading) {
      return _buildCardSkeleton(cs);
    }

    final lastSession = sessionState.history.isNotEmpty ? sessionState.history.first : null;

    if (lastSession == null) {
      return _HomeCollapsibleCard(
        title: context.l10n.cardLastSession,
        emoji: '📖',
        isInitiallyExpanded: _expandedCards[6] ?? false,
        onToggle: (exp) {
          setState(() {
            _expandedCards[6] = exp;
          });
        },
        child: Center(
          child: Text(
            'هیچ خولێکی زیکر نییە',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: cs.textSecondary,
            ),
          ),
        ),
      );
    }

    final minutes = lastSession.durationSeconds ~/ 60;
    final formattedTime = DateFormat('yyyy/MM/dd hh:mm a').format(lastSession.startTime);
    final dhikrName = lastSession.customDhikrName ?? lastSession.dhikr?.name ?? context.l10n.dhikrWord;

    return _HomeCollapsibleCard(
      title: context.l10n.cardLastSession,
      emoji: '📖',
      isInitiallyExpanded: _expandedCards[6] ?? false,
      onToggle: (exp) {
        setState(() {
          _expandedCards[6] = exp;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dhikrName,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${lastSession.totalCount} ${context.l10n.dhikrWord}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.textPrimary,
                ),
              ),
              Text(
                '$minutes ${context.l10n.minutesWord}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formattedTime,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: cs.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(
    BuildContext context,
    AppColorScheme cs,
    Color accentColor,
    StatisticsState statisticsState,
  ) {
    if (statisticsState.isLoading) {
      return _buildCardSkeleton(cs);
    }

    final totalDhikr = statisticsState.dashboard.totalDhikr;
    final totalSessions = statisticsState.dashboard.totalSessions;
    final rareAchievements = statisticsState.dashboard.rareAchievements;

    return _HomeCollapsibleCard(
      title: context.l10n.statsQuickActionInsights,
      emoji: '📊',
      isInitiallyExpanded: _expandedCards[7] ?? false,
      onToggle: (exp) {
        setState(() {
          _expandedCards[7] = exp;
        });
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'کۆی تەواوی زیکرەکان',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                NumberFormat.decimalPattern().format(totalDhikr),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.totalSessionsLabel,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: cs.textSecondary,
                ),
              ),
              Text(
                '$totalSessions',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'دەستکەوتە دەگمەنەکان',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                '$rareAchievements',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartInsightCard(
    BuildContext context,
    AppColorScheme cs,
    Color accentColor,
    StatisticsState statisticsState,
  ) {
    if (statisticsState.isLoading) {
      return _buildCardSkeleton(cs);
    }

    final insight = statisticsState.insights.isNotEmpty ? statisticsState.insights.first : null;
    final insightText = insight?.fallback ?? 'زۆرترین چالاکیت لە دوای نوێژی مەغریبە.';
    final insightEmoji = insight?.icon ?? '💡';

    return _HomeCollapsibleCard(
      title: context.l10n.cardInsight,
      emoji: insightEmoji,
      isInitiallyExpanded: _expandedCards[8] ?? false,
      onToggle: (exp) {
        setState(() {
          _expandedCards[8] = exp;
        });
      },
      child: Text(
        insightText,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          color: cs.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildCardSkeleton(AppColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 80,
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: cs.divider.withValues(alpha: 0.1),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 12,
                    width: 150,
                    decoration: BoxDecoration(
                      color: cs.divider.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                      color: cs.divider.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.seconds, color: cs.primary.withValues(alpha: 0.05));
  }

  @override
  Widget build(BuildContext context) {
    final p = Responsive.pagePadding(context);

    // Listen to the provider to push updates to the widget dynamically when resolved
    ref.listen<AsyncValue<AyahModel>>(dailyVerseProvider, (previous, next) {
      next.whenData((ayah) {
        HomePage._updateWidgetWithData(
          ayah.textUthmani,
          ayah.textKu ?? ayah.textEn ?? '',
          '— ${ayah.surah?.nameEn ?? ""} ${ayah.surah?.number ?? ""}:${ayah.ayahNumber}',
        );
      });
    });

    // Check if daily verse is already loaded and update the widget on build
    final dailyVerse = ref.watch(dailyVerseProvider).valueOrNull;
    if (dailyVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomePage._updateWidgetWithData(
          dailyVerse.textUthmani,
          dailyVerse.textKu ?? dailyVerse.textEn ?? '',
          '— ${dailyVerse.surah?.nameEn ?? ""} ${dailyVerse.surah?.number ?? ""}:${dailyVerse.ayahNumber}',
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => HomePage._updateWidgetDefault());
    }

    final topPadding = MediaQuery.of(context).padding.top;
    final cs = AppColorScheme.of(context);
    final accentColor = ref.watch(accentColorProvider);
    final authState = ref.watch(authProvider);
    final statisticsState = ref.watch(statisticsProvider);
    final tasbihSessionState = ref.watch(tasbihSessionProvider);
    final tasbihState = ref.watch(tasbihProvider);
    final locale = Localizations.localeOf(context).languageCode;

    final isAuthenticated = authState.status == AuthStatus.authenticated && authState.user != null;

    return Scaffold(
      backgroundColor: cs.bg,
      body: Stack(
        children: [
          // ── Scrollable content area ──────
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: topPadding + 262,
                bottom: 24,
              ),
              child: Column(
                children: [
                  // 1. Prayer Times Countdown Widget
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 35, p, 0),
                    child: const PrayerWidgetCard(),
                  ).animate().fadeIn(duration: 400.ms, delay: 155.ms),

                  // ── Section: تایبەتمەندییەکان ────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 20, p, 12),
                    child: _SectionDivider(
                      title: context.l10n.homeFeaturesOne,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  // ── Categories grid ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 0, p, 16),
                    child: const _CategoriesGrid(),
                  ),

                  // ── Section: ئامار و بەردەوامی ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 20, p, 12),
                    child: _SectionDivider(
                      title: context.l10n.statsQuickActionInsights,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  // ── 8 Motivation/Analytics Cards ──
                  
                  // Card 1: Profile Card (Guest or Authenticated)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: isAuthenticated
                        ? const _HomeProfileCard()
                        : _buildGuestProfileCard(context, accentColor, cs),
                  ).animate().fadeIn(duration: 400.ms, delay: 120.ms),

                  // Card 2: Today's Dhikr Card (Always Expanded)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: _buildTodayDhikrCard(context, cs, accentColor, statisticsState, tasbihState, locale),
                  ).animate().fadeIn(duration: 400.ms, delay: 130.ms),

                  // Card 3: Daily Goal Progress Card (Always Expanded, Tapping opens dialog)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: _buildDailyGoalProgressCard(context, cs, accentColor, tasbihState),
                  ).animate().fadeIn(duration: 400.ms, delay: 140.ms),

                  // Card 4: Current Streak Card (Always Expanded)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: _buildCurrentStreakCard(context, cs, accentColor, tasbihState),
                  ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                  // Card 5: Next Achievement Card (Collapsible)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: _buildNextAchievementCard(context, cs, accentColor, statisticsState),
                  ).animate().fadeIn(duration: 400.ms, delay: 160.ms),

                  // Card 6: Last Session Summary Card (Collapsible)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: _buildLastSessionCard(context, cs, accentColor, tasbihSessionState),
                  ).animate().fadeIn(duration: 400.ms, delay: 170.ms),

                  // Card 7: Quick Statistics Card (Collapsible)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: _buildQuickStatsCard(context, cs, accentColor, statisticsState),
                  ).animate().fadeIn(duration: 400.ms, delay: 180.ms),

                  // Card 8: Smart Insight Card (Collapsible)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: _buildSmartInsightCard(context, cs, accentColor, statisticsState),
                  ).animate().fadeIn(duration: 400.ms, delay: 190.ms),
                ],
              ),
            ),
          ),

          // ── Sticky/Fixed top header zone ──────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _GreenZone(padding: p),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home Collapsible Card Wrapper
// ─────────────────────────────────────────────────────────────────────────────

class _HomeCollapsibleCard extends StatelessWidget {
  final String title;
  final String emoji;
  final bool isInitiallyExpanded;
  final ValueChanged<bool> onToggle;
  final Widget child;

  const _HomeCollapsibleCard({
    required this.title,
    required this.emoji,
    this.isInitiallyExpanded = false,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => onToggle(!isInitiallyExpanded),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isInitiallyExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: cs.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: child,
            ),
            crossFadeState: isInitiallyExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Green Zone  (appbar + verse banner card + dots)
// ─────────────────────────────────────────────────────────────────────────────

class _GreenZone extends ConsumerStatefulWidget {
  const _GreenZone({required this.padding});
  final double padding;

  @override
  ConsumerState<_GreenZone> createState() => _GreenZoneState();
}

class _GreenZoneState extends ConsumerState<_GreenZone> {
  final _ctrl = PageController();
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final dailyVerseLen = ref.read(dailyVerseProvider).when(
            data: (_) => 1,
            error: (_, __) => 0,
            loading: () => 0,
          );
      final bannersLen = ref.read(bannersProvider).when(
            data: (banners) => banners.isNotEmpty ? banners.length : _slides.length,
            error: (_, __) => _slides.length,
            loading: () => _slides.length,
          );
      final len = dailyVerseLen + bannersLen;
      if (len == 0) return;
      final next = (_page + 1) % len;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.padding;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = AppColorScheme.of(context);

    final AsyncValue<AyahModel> dailyVerseAsync = ref.watch(dailyVerseProvider);
    final AsyncValue<List<BannerModel>> bannersAsync = ref.watch(bannersProvider);

    final List<_AdSlide> activeSlides = [];

    // 1. Add Daily Verse if loaded successfully
    dailyVerseAsync.whenData((ayah) {
      activeSlides.add(_AdSlide(
        ayah.textUthmani,
        ayah.textKu ?? ayah.textEn ?? '',
        '— ${ayah.surah?.nameEn ?? ""} ${ayah.surah?.number ?? ""}:${ayah.ayahNumber}',
        ayah: ayah,
      ));
    });

    // 2. Add dynamic banners or fallback to static ones if empty/loading/error
    bannersAsync.when(
      data: (banners) {
        if (banners.isNotEmpty) {
          for (final b in banners) {
            // Check if this banner has a linked surah/ayah, if so create an AyahModel
            AyahModel? ayahLink;
            if (b.surah != null && b.ayahNumber != null) {
              ayahLink = AyahModel(
                id: 0,
                ayahNumber: b.ayahNumber!,
                textUthmani: b.titleArabic ?? '',
                textKu: b.verse,
                textEn: null,
                surah: b.surah,
              );
            }
            activeSlides.add(_AdSlide(
              b.titleArabic ?? '',
              b.verse,
              b.source ?? '',
              ayah: ayahLink,
            ));
          }
        } else {
          activeSlides.addAll(_slides);
        }
      },
      error: (_, __) {
        activeSlides.addAll(_slides);
      },
      loading: () {
        activeSlides.addAll(_slides);
      },
    );

    // If still empty (e.g. dailyVerse is loading and banners are loading), add default slides as fallback
    if (activeSlides.isEmpty) {
      activeSlides.addAll(_slides);
    }

    // Safeguard page indexing in case activeSlides length changes dynamically
    if (_page >= activeSlides.length) {
      _page = 0;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColorScheme.darken(cs.primary, 0.42),
                  AppColorScheme.darken(cs.primary, 0.35),
                  AppColorScheme.darken(cs.primary, 0.28),
                ]
              : [
                  cs.primaryDeep,
                  cs.primary,
                  AppColorScheme.darken(cs.primary, -0.06),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App bar ────────────────────────────────────────────
            _AppBarRow(padding: p),

            const SizedBox(height: 16),

            // ── Verse banner card ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: p),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColorScheme.of(context).card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: activeSlides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => _VerseSlide(slide: activeSlides[i]),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Dot indicators ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(activeSlides.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // ── Rounded white overlap at bottom ────────────────────
            Container(
              height: 26,
              decoration: BoxDecoration(
                color: AppColorScheme.of(context).bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Bar Row
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarRow extends ConsumerWidget {
  const _AppBarRow({required this.padding});
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 10, padding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Theme toggle — left ──
          GestureDetector(
            onTap: () => ref.read(themeModeProvider.notifier).toggle(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
              child: Icon(
                ref.watch(themeModeProvider) == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: Colors.white.withValues(alpha: 0.9),
                size: 18,
              ),
            ),
          ),

          // ── App name — center ──
          Text(
            l.appName,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),

          // ── Logo badge — right ──
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Verse Slide  (inside white card)
// ─────────────────────────────────────────────────────────────────────────────

class _VerseSlide extends StatelessWidget {
  const _VerseSlide({required this.slide});
  final _AdSlide slide;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        if (slide.ayah != null && slide.ayah!.surah != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuranReaderPage(
                surah: slide.ayah!.surah!,
                initialAyahNumber: slide.ayah!.ayahNumber,
              ),
            ),
          );
        }
      },
      child: Container(
        color: cs.card,
        child: Row(
        children: [
          // ── Left: green gradient + verse text ──
          Expanded(
            flex: 55,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColorScheme.darken(cs.primary, 0.42),
                          AppColorScheme.darken(cs.primary, 0.35),
                        ]
                      : [cs.primaryDeep, cs.primary],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ئایەتی ڕۆژ pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('✨', style: TextStyle(fontSize: 9)),
                        const SizedBox(width: 3),
                        Text(
                          context.l10n.homeDailyVerse,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.verse,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.source,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 9,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Right: white + Arabic quran text ──
          Expanded(
            flex: 45,
            child: Container(
              color: cs.card,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle accent
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Arabic Quranic text
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      slide.titleArabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 15,
                        height: 1.8,
                        color: cs.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Divider  ─ ─ ─  Title  ─ ─ ─
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return Row(
      children: [
        Expanded(child: _DashedLine(color: cs.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: cs.textPrimary,
            ),
          ),
        ),
        Expanded(child: _DashedLine(color: cs.divider)),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      const dashW = 5.0;
      const gap = 3.0;
      final count = (constraints.maxWidth / (dashW + gap)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Container(
            width: dashW,
            height: 1.5,
            margin: const EdgeInsets.only(right: gap),
            color: color,
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Prayer Times Countdown Banner
// ─────────────────────────────────────────────────────────────────────────────

class _CountdownTimerText extends StatefulWidget {
  final DateTime targetTime;
  final TextStyle style;
  final VoidCallback? onFinished;

  const _CountdownTimerText({
    required this.targetTime,
    required this.style,
    this.onFinished,
  });

  @override
  State<_CountdownTimerText> createState() => _CountdownTimerTextState();
}

class _CountdownTimerTextState extends State<_CountdownTimerText> {
  late Timer _timer;
  late ValueNotifier<Duration> _remainingNotifier;

  @override
  void initState() {
    super.initState();
    final initialRemaining = widget.targetTime.difference(DateTime.now());
    _remainingNotifier = ValueNotifier(initialRemaining);
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant _CountdownTimerText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetTime != widget.targetTime) {
      _timer.cancel();
      _remainingNotifier.value = widget.targetTime.difference(DateTime.now());
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final diff = widget.targetTime.difference(DateTime.now());
      if (diff.isNegative || diff.inSeconds <= 0) {
        _remainingNotifier.value = Duration.zero;
        _timer.cancel();
        if (widget.onFinished != null) {
          widget.onFinished!();
        }
      } else {
        _remainingNotifier.value = diff;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _remainingNotifier.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: _remainingNotifier,
      builder: (context, remaining, child) {
        return Text(
          _formatDuration(remaining),
          style: widget.style,
        );
      },
    );
  }
}

class _PrayerCountdownBanner extends ConsumerStatefulWidget {
  const _PrayerCountdownBanner();

  @override
  ConsumerState<_PrayerCountdownBanner> createState() => _PrayerCountdownBannerState();
}

class _PrayerCountdownBannerState extends ConsumerState<_PrayerCountdownBanner> {
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final nextInfo = ref.watch(nextPrayerProvider);
    final settings = ref.watch(prayerTimesSettingsProvider);
    
    if (nextInfo == null) return const SizedBox.shrink();

    List<Color> gradientColors;
    switch (nextInfo.prayerType) {
      case PrayerType.fajr:
        gradientColors = [
          const Color(0xFF2B5876),
          const Color(0xFF4E4376),
        ];
        break;
      case PrayerType.dhuhr:
        gradientColors = [
          const Color(0xFFF7971E),
          const Color(0xFFFFD200),
        ];
        break;
      case PrayerType.asr:
        gradientColors = [
          const Color(0xFFF12711),
          const Color(0xFFF5AF19),
        ];
        break;
      case PrayerType.maghrib:
        gradientColors = [
          const Color(0xFF833AB4),
          const Color(0xFFFD1D1D),
        ];
        break;
      case PrayerType.isha:
        gradientColors = [
          const Color(0xFF0D1B2A),
          const Color(0xFF1B263B),
        ];
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrayerTimesPage(showBackButton: true)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        settings.selectedCity.nameKu,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'کاتی نوێژی داهاتوو',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nextInfo.kurdishName,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'بانگ: ${_formatTime(nextInfo.time)}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mosque_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'کاتی ماوە',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                _CountdownTimerText(
                  targetTime: nextInfo.time,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                  onFinished: () {
                    ref.read(prayerTimesSettingsProvider.notifier).reschedule();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
       .shimmer(duration: 4.seconds, color: Colors.white.withValues(alpha: 0.08)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Categories Grid  (4 cols phone / 5 cols tablet)
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesGrid extends ConsumerWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = Responsive.isTablet(context);
    final cols = isTablet ? 6 : 4;
    final cats = _buildCats(context);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isTablet ? 0.90 : 0.82,
      ),
      itemBuilder: (context, i) {
        final cat = cats[i];
        return _CatTile(
          icon: cat.icon,
          iconColor: cat.iconColor,
          label: cat.label(context.l10n),
          onTap: cat.onTap(ref, context),
        ).animate().fadeIn(
              duration: 280.ms,
              delay: Duration(milliseconds: 40 * i),
            );
      },
    );
  }
}

class _CatTile extends StatelessWidget {
  const _CatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: cs.textPrimary,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home Profile Card (Authenticated / Guest State)

class _HomeProfileCard extends ConsumerWidget {
  const _HomeProfileCard();

  Widget _buildStatItem(BuildContext context, String emoji, String value, String label) {
    final cs = AppColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.divider.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9,
                    color: cs.textSecondary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    final cs = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: cs.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final cs = AppColorScheme.of(context);
    final accentColor = ref.watch(accentColorProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isAuthenticated = authState.status == AuthStatus.authenticated && authState.user != null;

    if (isAuthenticated) {
      final user = authState.user!;
      final stats = authState.stats ?? {};
      final statsState = ref.watch(statisticsProvider);
      final dashboard = statsState.dashboard;

      final streak = dashboard.currentStreak > 0 ? dashboard.currentStreak : (stats['current_streak'] ?? 0);
      final achievements = dashboard.totalAchievements > 0 ? dashboard.totalAchievements : (stats['achievements_count'] ?? 0);
      final goalProgress = dashboard.goalCompletionRate > 0 ? dashboard.goalCompletionRate.round() : (stats['goal_completion_rate'] ?? 0);
      final productivity = dashboard.productivityScore;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info row
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentColor.withValues(alpha: 0.1),
                  child: Text(
                    user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : 'U',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: cs.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_circle_outline_rounded, color: accentColor, size: 22),
                  onPressed: () {
                    final tasbihState = ref.read(tasbihProvider);
                    _showStartSessionDialogFromHome(context, ref, tasbihState);
                  },
                  tooltip: locale == 'ku' ? 'دەستپێکردنی زیکر' : 'Start Dhikr',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats items row 1
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    '🔥',
                    locale == 'ku' ? '$streak ڕۆژ' : (locale == 'ar' ? '$streak يوم' : '$streak Days'),
                    locale == 'ku' ? 'بەردەوامی' : 'Streak',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    '🏆',
                    '$achievements',
                    locale == 'ku' ? 'دەستکەوتەکان' : 'Achievements',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Stats items row 2
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    '🎯',
                    '$goalProgress%',
                    locale == 'ku' ? 'تەواوکردنی ئامانج' : 'Goal Completion',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    '📊',
                    '$productivity',
                    context.l10n.productivityScoreLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: cs.cardBorder, height: 1),
            const SizedBox(height: 14),

            // Quick Actions row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildQuickAction(
                    context,
                    Icons.person_outline_rounded,
                    locale == 'ku' ? 'پرۆفایل' : 'Profile',
                    accentColor,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                  ),
                  const SizedBox(width: 16),
                  _buildQuickAction(
                    context,
                    Icons.insights_rounded,
                    locale == 'ku' ? 'ئامارەکان' : 'Insights',
                    accentColor,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatisticsPage())),
                  ),
                  const SizedBox(width: 16),
                  _buildQuickAction(
                    context,
                    Icons.emoji_events_outlined,
                    locale == 'ku' ? 'دەستکەوت' : 'Badges',
                    accentColor,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsPage())),
                  ),
                  const SizedBox(width: 16),
                  _buildQuickAction(
                    context,
                    Icons.palette_outlined,
                    locale == 'ku' ? 'ڕووکار' : 'Themes',
                    accentColor,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemeSelectorPage())),
                  ),
                  const SizedBox(width: 16),
                  _buildQuickAction(
                    context,
                    Icons.leaderboard_outlined,
                    locale == 'ku' ? 'ڕیزبەندی' : 'Ranks',
                    accentColor,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage())),
                  ),
                  const SizedBox(width: 16),
                  _buildQuickAction(
                    context,
                    Icons.fingerprint_rounded,
                    locale == 'ku' ? 'پەنجەمۆر' : 'Fingerprint',
                    accentColor,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FingerprintCounterPage())),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Guest state profile card
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WelcomePage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.grey.shade900,
                      Colors.grey.shade800,
                    ]
                  : [
                      Colors.grey.shade100,
                      Colors.white,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.grey.shade300,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_add_alt_1_outlined,
                  color: accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale == 'ku'
                          ? 'بە شێوازی مێوان بەردەوامی'
                          : (locale == 'ar' ? 'أنت تتصفح كضيف' : 'Browsing as Guest'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      locale == 'ku'
                          ? 'تۆماربکە بۆ پاراستنی سەرجەم داتاکانت'
                          : (locale == 'ar' ? 'سجل لحفظ جميع بياناتك ومزامنتها' : 'Sign up to save & sync your progress'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: cs.textSecondary,
              ),
            ],
          ),
        ),
      );
    }
  }
}

void _showStartSessionDialogFromHome(BuildContext context, WidgetRef ref, TasbihState tasbihState) {
  final cs = AppColorScheme.of(context);
  final nameCtrl = TextEditingController();
  int? selectedPredefinedIndex;
  final locale = Localizations.localeOf(context).languageCode;

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: cs.card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              locale == 'ku' ? 'دەستپێکردنی خولی زیکر' : (locale == 'ar' ? 'بدء جلسة ذكر' : 'Start Dhikr Session'),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    locale == 'ku'
                        ? 'زیکرێک هەڵبژێرە بۆ دەستپێکردن:'
                        : (locale == 'ar' ? 'اختر ذكراً للبدء:' : 'Select a dhikr to begin:'),
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.cardBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      itemCount: tasbihState.dhikrs.length,
                      itemBuilder: (c, idx) {
                        final dhikr = tasbihState.dhikrs[idx];
                        final isSel = selectedPredefinedIndex == idx;
                        return ListTile(
                          dense: true,
                          selected: isSel,
                          selectedTileColor: cs.primary.withValues(alpha: 0.1),
                          title: Text(
                            dhikr.name,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              color: isSel ? cs.primary : cs.textPrimary,
                            ),
                          ),
                          onTap: () {
                            setDialogState(() {
                              selectedPredefinedIndex = idx;
                              nameCtrl.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    locale == 'ku'
                        ? 'یان زیکرێکی تایبەت بنووسە:'
                        : (locale == 'ar' ? 'أو اكتب ذكراً مخصصاً:' : 'Or type custom dhikr:'),
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: cs.textPrimary),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.primary),
                      ),
                    ),
                    onChanged: (val) {
                      if (val.trim().isNotEmpty && selectedPredefinedIndex != null) {
                        setDialogState(() {
                          selectedPredefinedIndex = null;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  locale == 'ku' ? 'پاشگەزبوونەوە' : (locale == 'ar' ? 'إلغاء' : 'Cancel'),
                  style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  int? dhikrId;
                  String? customName;
                  if (selectedPredefinedIndex != null) {
                    final dhikr = tasbihState.dhikrs[selectedPredefinedIndex!];
                    if (dhikr.isCustom) {
                      customName = dhikr.name;
                    } else {
                      dhikrId = int.tryParse(dhikr.id);
                    }
                  } else {
                    customName = nameCtrl.text.trim();
                    if (customName.isEmpty) return;
                  }

                  Navigator.pop(ctx); // Close dialog

                  // Show loader
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(child: CircularProgressIndicator()),
                  );

                  final success = await ref.read(tasbihSessionProvider.notifier).startSession(
                        dhikrId: dhikrId,
                        customDhikrName: customName,
                      );

                  if (context.mounted) {
                    Navigator.pop(context); // Close loader
                  }

                  if (success && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ActiveSessionPage()),
                    );
                  } else if (context.mounted) {
                    final errorMsg = ref.read(tasbihSessionProvider).errorMessage ?? 'Error starting session';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMsg, style: const TextStyle(fontFamily: 'Cairo')),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  locale == 'ku' ? 'دەستپێکردن' : (locale == 'ar' ? 'بدء' : 'Start'),
                  style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    },
  );
} 
