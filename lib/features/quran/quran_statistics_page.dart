import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/reading_tracker_provider.dart';
import '../../core/models/manzil_model.dart';
import '../../core/models/rub_el_hizb_data.dart';

class QuranStatisticsPage extends ConsumerWidget {
  final bool showBackButton;
  const QuranStatisticsPage({super.key, this.showBackButton = true});

  String _formatTimeSpent(int totalSeconds, AppLocalizations l) {
    if (totalSeconds == 0) return l.localeCode == 'en' ? '0 sec' : '٠ چرکە';
    if (totalSeconds < 60) return l.localeCode == 'en' ? '$totalSeconds sec' : '$totalSeconds چرکە';
    final minutes = totalSeconds ~/ 60;
    if (minutes < 60) {
      return l.localeCode == 'en' ? '$minutes min' : '$minutes خولەک';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return l.localeCode == 'en' ? '$hours hrs' : '$hours کاتژمێر';
    }
    return l.localeCode == 'en'
        ? '$hours hrs $remainingMinutes min'
        : '$hours کاتژمێر و $remainingMinutes خولەک';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final state = ref.watch(readingTrackerProvider);
    final notifier = ref.read(readingTrackerProvider.notifier);

    // Calculate dynamic stats
    final ayahsReadToday = notifier.getAyahsReadToday();
    final dailyGoal = state.dailyGoalAyahs;
    final progressVal = dailyGoal > 0 ? (ayahsReadToday / dailyGoal).clamp(0.0, 1.0) : 0.0;

    final totalAyahsRead = notifier.getTotalUniqueAyahsRead();
    final totalTimeSeconds = notifier.getTotalTimeSpentSeconds();
    final totalSessions = notifier.getTotalSessions();

    final completedSurahs = state.cachedStats.completedSurahs;
    final completedJuz = state.cachedStats.completedJuz;
    final completedHizb = state.cachedStats.completedHizb;
    final currentStreak = state.cachedStats.currentStreak;
    final longestStreak = state.cachedStats.longestStreak;

    // Calculate completed Rub Al-Hizb and Manzil
    final readAyahsSet = state.history.map((h) => '${h.surahId}-${h.ayahNumber}').toSet();
    
    int completedRubs = 0;
    for (final rub in RubElHizbData.list) {
      final startSurah = rub['start_surah']!;
      final startAyah = rub['start_ayah']!;
      if (readAyahsSet.contains('$startSurah-$startAyah')) {
        completedRubs++;
      }
    }

    int completedManzils = 0;
    for (final manzil in ManzilModel.list) {
      final startSurah = manzil.startSurah;
      final startAyah = manzil.startAyah;
      if (readAyahsSet.contains('$startSurah-$startAyah')) {
        completedManzils++;
      }
    }

    final isRtl = l.localeCode != 'en';

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          l.localeCode == 'en' ? 'Quran Statistics' : 'ئاماری خوێندنەوەی قورئان',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── HEADER DAILY GOAL WHEEL ──
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColorScheme.darken(cs.primary, 0.35), AppColorScheme.darken(cs.primary, 0.45)]
                      : [cs.primary, cs.primaryDeep],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  Text(
                    l.dailyGoalProgress,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Progress Wheel
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: progressVal,
                            strokeWidth: 10,
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$ayahsReadToday / $dailyGoal',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                l.quranAyahs,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  // Selector
                  Text(
                    l.localeCode == 'en' ? 'Set Daily Goal (Ayahs)' : 'ئامانجی ڕۆژانە (ئایەت)',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [5, 10, 20, 50].map((goalVal) {
                      final isSelected = dailyGoal == goalVal;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () => notifier.setDailyGoal(goalVal),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white12,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.white24,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              '$goalVal',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? cs.primary : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── STREAK & GENERAL STATS ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l.readingStreak,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: cs.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l.homeStreakDaysCount(currentStreak),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cs.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l.homeStreakLongest}: $longestStreak',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.timer_outlined, color: cs.primary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l.localeCode == 'en' ? 'Time Spent' : 'کاتی خوێندنەوە',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: cs.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _formatTimeSpent(totalTimeSeconds, l),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: cs.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l.readingSessions}: $totalSessions',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.playlist_add_check_rounded, color: cs.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.uniqueAyahsRead,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: cs.textSecondary,
                            ),
                          ),
                          Text(
                            '$totalAyahsRead / 6236',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: cs.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircularProgressIndicator(
                      value: totalAyahsRead / 6236.0,
                      backgroundColor: cs.primary.withValues(alpha: 0.1),
                      color: cs.primary,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── DIVISION COMPLETIONS ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l.localeCode == 'en' ? 'Quranic Completions' : 'ڕێژەی تەواوکردنی بەشەکان',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: cs.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: Column(
                  children: [
                    _buildCompletionProgressBar(
                      title: l.localeCode == 'en' ? 'Completed Surahs' : 'سورەتە تەواوبووەکان',
                      current: completedSurahs,
                      total: 114,
                      cs: cs,
                      isRtl: isRtl,
                    ),
                    const Divider(height: 24),
                    _buildCompletionProgressBar(
                      title: l.localeCode == 'en' ? 'Completed Juzs' : 'جزءە تەواوبووەکان',
                      current: completedJuz,
                      total: 30,
                      cs: cs,
                      isRtl: isRtl,
                    ),
                    const Divider(height: 24),
                    _buildCompletionProgressBar(
                      title: l.localeCode == 'en' ? 'Completed Hizbs' : 'حزبە تەواوبووەکان',
                      current: completedHizb,
                      total: 60,
                      cs: cs,
                      isRtl: isRtl,
                    ),
                    const Divider(height: 24),
                    _buildCompletionProgressBar(
                      title: l.localeCode == 'en' ? 'Completed Rub Al-Hizbs' : 'ڕوبعە تەواوبووەکان',
                      current: completedRubs,
                      total: 240,
                      cs: cs,
                      isRtl: isRtl,
                    ),
                    const Divider(height: 24),
                    _buildCompletionProgressBar(
                      title: l.localeCode == 'en' ? 'Completed Manzils' : 'مەنزلە تەواوبووەکان',
                      current: completedManzils,
                      total: 7,
                      cs: cs,
                      isRtl: isRtl,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionProgressBar({
    required String title,
    required int current,
    required int total,
    required AppColorScheme cs,
    required bool isRtl,
  }) {
    final pct = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;
    final pctText = '${(pct * 100).toStringAsFixed(1)}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$current / $total ($pctText)',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: cs.primary.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),
        ),
      ],
    );
  }
}
