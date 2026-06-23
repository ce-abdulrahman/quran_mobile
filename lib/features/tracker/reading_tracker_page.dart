import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../quran/quran_reader_page.dart';
import '../quran/quran_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Reading Tracker Page
// ─────────────────────────────────────────────────────────────────────────────

class ReadingTrackerPage extends ConsumerWidget {
  final bool showBackButton;
  const ReadingTrackerPage({super.key, this.showBackButton = false});

  String _formatKurdishDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final check = DateTime(dt.year, dt.month, dt.day);

    final timeStr =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    if (check == today) {
      return 'ئەمڕۆ کاتژمێر $timeStr';
    } else if (check == yesterday) {
      return 'دوێنێ کاتژمێر $timeStr';
    } else {
      return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} کاتژمێر $timeStr';
    }
  }

  String _formatTimeSpent(int totalSeconds) {
    if (totalSeconds == 0) return '٠ چرکە';
    if (totalSeconds < 60) return '$totalSeconds چرکە';
    final minutes = totalSeconds ~/ 60;
    if (minutes < 60) {
      return '$minutes خولەک';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours کاتژمێر';
    }
    return '$hours کاتژمێر و $remainingMinutes خولەک';
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref, AppColorScheme cs) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'سڕینەوەی مێژوو',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'ئایا دڵنیایت لە سڕینەوەی تەواوی مێژوو و چالاکییەکانی خوێندنەوەت؟ ئەم کارە ناگەڕێتەوە.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'نەخێر',
              style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(readingTrackerProvider.notifier).clearHistory();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'تەواوی مێژووی خوێندنەوە سڕایەوە',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'بەڵێ، بسڕەوە',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final trackerState = ref.watch(readingTrackerProvider);
    final tracker = ref.watch(readingTrackerProvider.notifier);
    
    final currentStreak = trackerState.cachedStats.currentStreak;
    final longestStreak = trackerState.cachedStats.longestStreak;

    final totalAyahsRead = tracker.getTotalUniqueAyahsRead();
    final totalTimeSpent = tracker.getTotalTimeSpentSeconds();

    // Group history items by Surah to find unique Surahs in progress
    final inProgressSurahIds = trackerState.history.map((h) => h.surahId).toSet().toList();

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
          l.homeReadingStreak,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (trackerState.history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
              onPressed: () => _showClearHistoryDialog(context, ref, cs),
              tooltip: 'سڕینەوەی مێژوو',
            ),
        ],
      ),
      body: trackerState.history.isEmpty
          ? _EmptyTracker(cs: cs)
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Premium Gradient Banner ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppColorScheme.darken(cs.primary, 0.35),
                                AppColorScheme.darken(cs.primary, 0.45)
                              ]
                            : [cs.primary, cs.primaryDeep],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Large Streak Fire Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '🔥',
                              style: TextStyle(fontSize: 42),
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(
                              begin: const Offset(0.94, 0.94),
                              end: const Offset(1.06, 1.06),
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            ),
                        const SizedBox(height: 16),
                        // Current Streak Text
                        Text(
                          currentStreak > 0
                              ? '$currentStreak ڕۆژ خوێندنەوەی بەردەوام'
                              : 'بەردەوامی نییە',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'درێژترین بەردەوامی: $longestStreak ڕۆژ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick Stats Section ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'ئایەتی خوێندراوەتەوە',
                            value: '$totalAyahsRead',
                            icon: Icons.menu_book_rounded,
                            iconColor: const Color(0xFF2196F3),
                            cs: cs,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'کاتی خوێندنەوە',
                            value: _formatTimeSpent(totalTimeSpent),
                            icon: Icons.timer_rounded,
                            iconColor: const Color(0xFF4CAF50),
                            cs: cs,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  const SizedBox(height: 24),

                  // ── Surahs in Progress ──
                  if (inProgressSurahIds.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'سوورەتەکان لە پڕۆسەدان',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: cs.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SurahsInProgressList(
                      surahIds: inProgressSurahIds,
                      tracker: tracker,
                      cs: cs,
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
                    const SizedBox(height: 24),
                  ],

                  // ── Recent Reading History ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'مێژووی خوێندنەوەی دوایی',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: cs.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: trackerState.history.length.clamp(0, 15), // Show top 15 recents
                    itemBuilder: (_, index) {
                      final item = trackerState.history[index];
                      return _HistoryTile(
                        item: item,
                        dateStr: _formatKurdishDate(item.timestamp),
                        cs: cs,
                      ).animate().fadeIn(
                            duration: 250.ms,
                            delay: Duration(milliseconds: 30 * index),
                          );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Card Component
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final AppColorScheme cs;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
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
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: cs.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Surahs In Progress Component
// ─────────────────────────────────────────────────────────────────────────────

class _SurahsInProgressList extends ConsumerWidget {
  final List<int> surahIds;
  final ReadingTrackerNotifier tracker;
  final AppColorScheme cs;

  const _SurahsInProgressList({
    required this.surahIds,
    required this.tracker,
    required this.cs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahListAsync = ref.watch(surahListProvider);

    return surahListAsync.when(
      data: (surahs) {
        // Find surah models and build cards
        final inProgressModels = surahs.where((s) => surahIds.contains(s.id)).toList();

        if (inProgressModels.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: inProgressModels.length.clamp(0, 5), // show up to 5 surahs in progress
            itemBuilder: (_, index) {
              final surah = inProgressModels[index];
              final progress = tracker.getSurahProgress(surah.id, surah.totalAyahs);
              final progressPct = (progress * 100).round();
              final readCount = tracker.getSurahReadCount(surah.id);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuranReaderPage(surah: surah),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12, bottom: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              surah.nameEn,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: cs.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '$progressPct%',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$readCount لە ${surah.totalAyahs} ئایەت',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: cs.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: cs.cardBorder,
                          valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reading History Tile Component
// ─────────────────────────────────────────────────────────────────────────────

class _HistoryTile extends StatelessWidget {
  final LocalReadingHistory item;
  final String dateStr;
  final AppColorScheme cs;

  const _HistoryTile({
    required this.item,
    required this.dateStr,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.done_rounded,
              color: cs.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'خوێندنەوەی سوورەتی ${item.surahName}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'ئایەتی ${item.ayahNumber} • $dateStr',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    color: cs.textSecondary,
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

// ─────────────────────────────────────────────────────────────────────────────
// Empty Tracker Component
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyTracker extends StatelessWidget {
  final AppColorScheme cs;
  const _EmptyTracker({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 44,
              color: cs.primary,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 1800.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 24),
          const Text(
            'هیچ ئامارێک نییە',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'خوێندنەوەی قورئان دەست پێ بکە تا پێشکەوتنەکانت لێرەدا تۆمار بکرێن.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: cs.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
