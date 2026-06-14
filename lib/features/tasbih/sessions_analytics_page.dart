import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/tasbih_session_provider.dart';

class SessionsAnalyticsPage extends ConsumerStatefulWidget {
  const SessionsAnalyticsPage({super.key});

  @override
  ConsumerState<SessionsAnalyticsPage> createState() => _SessionsAnalyticsPageState();
}

class _SessionsAnalyticsPageState extends ConsumerState<SessionsAnalyticsPage> {
  @override
  void initState() {
    super.initState();
    // Load analytics on enter
    Future.microtask(() {
      ref.read(tasbihSessionProvider.notifier).fetchAnalytics();
    });
  }

  String _formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '0';
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    if (mins == 0) return '$secs ثانیە';
    return '$mins خولەک';
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(tasbihSessionProvider);
    final cs = AppColorScheme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final analytics = sessionState.analytics;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          locale == 'ku' ? 'ئامارەکانی زیکر' : (locale == 'ar' ? 'إحصائيات الذكر' : 'Dhikr Analytics'),
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: sessionState.isLoading && analytics == null
          ? Center(child: CircularProgressIndicator(color: cs.primary))
          : RefreshIndicator(
              color: cs.primary,
              onRefresh: () async {
                await ref.read(tasbihSessionProvider.notifier).fetchAnalytics();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (analytics == null) ...[
                      const SizedBox(height: 100),
                      Center(
                        child: Text(
                          locale == 'ku'
                              ? 'هیچ ئامارێک بەردەست نییە. سەرەتا زیکرێک ئەنجام بدە!'
                              : (locale == 'ar'
                                  ? 'لا توجد إحصائيات. ابدأ جلسة ذكر أولاً!'
                                  : 'No analytics available. Start a dhikr session first!'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                        ),
                      ),
                    ] else ...[
                      // 1. KPI Overview Grid
                      _buildOverviewGrid(analytics.overview, cs, locale),
                      const SizedBox(height: 20),

                      // 2. Pace Distribution
                      _buildPaceCard(analytics.ratesDistribution, cs, locale),
                      const SizedBox(height: 20),

                      // 3. Hourly peaks contribution grid
                      _buildHourlyHeatmapCard(analytics.hourlyPeaks, cs, locale),
                      const SizedBox(height: 20),

                      // 4. Daily Trends Bar Chart
                      _buildDailyTrendsCard(analytics.dailyTrends, cs, locale),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewGrid(Map<String, dynamic> overview, AppColorScheme cs, String locale) {
    final totalSessions = overview['total_sessions'] as int? ?? 0;
    final totalDhikr = overview['total_dhikr_count'] as int? ?? 0;
    final avgDuration = overview['avg_duration_seconds'] as int? ?? 0;
    final fastestRate = double.tryParse((overview['fastest_rate_per_min'] ?? 0.0).toString()) ?? 0.0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildKpiCard(
          title: locale == 'ku' ? 'کۆی خولەکان' : (locale == 'ar' ? 'إجمالي الجلسات' : 'Total Sessions'),
          value: '$totalSessions',
          icon: Icons.repeat_rounded,
          color: Colors.teal,
          cs: cs,
        ),
        _buildKpiCard(
          title: locale == 'ku' ? 'کۆی زیکرەکان' : (locale == 'ar' ? 'إجمالي الأذكار' : 'Total Dhikrs'),
          value: '$totalDhikr',
          icon: Icons.fingerprint_rounded,
          color: cs.primary,
          cs: cs,
        ),
        _buildKpiCard(
          title: locale == 'ku' ? 'تێکڕای ماوە' : (locale == 'ar' ? 'متوسط المدة' : 'Avg Duration'),
          value: _formatDuration(avgDuration),
          icon: Icons.timer_outlined,
          color: Colors.orange,
          cs: cs,
        ),
        _buildKpiCard(
          title: locale == 'ku' ? 'خێراترین تێکڕا' : (locale == 'ar' ? 'أسرع معدل' : 'Peak Tap Pace'),
          value: '${fastestRate.toStringAsFixed(0)} bpm',
          icon: Icons.speed_rounded,
          color: Colors.redAccent,
          cs: cs,
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required AppColorScheme cs,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary, fontWeight: FontWeight.bold),
              ),
              Icon(icon, size: 18, color: color),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: cs.textPrimary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0));
  }

  Widget _buildPaceCard(Map<String, int> distribution, AppColorScheme cs, String locale) {
    final slow = distribution['slow'] ?? 0;
    final medium = distribution['medium'] ?? 0;
    final fast = distribution['fast'] ?? 0;
    final total = slow + medium + fast;

    final slowPercent = total > 0 ? slow / total : 0.0;
    final mediumPercent = total > 0 ? medium / total : 0.0;
    final fastPercent = total > 0 ? fast / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locale == 'ku' ? 'دابەشبوونی خێرایی زیکرەکان' : (locale == 'ar' ? 'توزيع سرعة التسبيح' : 'Dhikr Pace Distribution'),
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: cs.textPrimary),
          ),
          const SizedBox(height: 16),
          // Segmented bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 20,
              child: Row(
                children: [
                  if (slow > 0)
                    Expanded(
                      flex: (slowPercent * 100).round(),
                      child: Container(
                        color: Colors.blue.shade400,
                        alignment: Alignment.center,
                        child: Text(
                          '${(slowPercent * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  if (medium > 0)
                    Expanded(
                      flex: (mediumPercent * 100).round(),
                      child: Container(
                        color: Colors.orange.shade400,
                        alignment: Alignment.center,
                        child: Text(
                          '${(mediumPercent * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  if (fast > 0)
                    Expanded(
                      flex: (fastPercent * 100).round(),
                      child: Container(
                        color: Colors.green.shade500,
                        alignment: Alignment.center,
                        child: Text(
                          '${(fastPercent * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Legend row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                label: locale == 'ku' ? 'هێواش (<٢٠)' : (locale == 'ar' ? 'بطيء (<٢٠)' : 'Slow (<20)'),
                color: Colors.blue.shade400,
                count: slow,
                cs: cs,
              ),
              _buildLegendItem(
                label: locale == 'ku' ? 'ناوەند (٢٠-٥٠)' : (locale == 'ar' ? 'متوسط (٢٠-٥٠)' : 'Medium (20-50)'),
                color: Colors.orange.shade400,
                count: medium,
                cs: cs,
              ),
              _buildLegendItem(
                label: locale == 'ku' ? 'خێرا (>٥٠)' : (locale == 'ar' ? 'سريع (>٥٠)' : 'Fast (>50)'),
                color: Colors.green.shade500,
                count: fast,
                cs: cs,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required String label,
    required Color color,
    required int count,
    required AppColorScheme cs,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary)),
            Text('$count خول', style: TextStyle(fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.bold, color: cs.textPrimary)),
          ],
        ),
      ],
    );
  }

  Widget _buildHourlyHeatmapCard(Map<int, int> hourlyPeaks, AppColorScheme cs, String locale) {
    // Find the max value to calculate opacities
    int maxTaps = 1;
    hourlyPeaks.forEach((_, taps) {
      if (taps > maxTaps) maxTaps = taps;
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locale == 'ku' ? 'چالاکی بەپێی کاتژمێرەکانی ڕۆژ' : (locale == 'ar' ? 'النشاط حسب ساعات اليوم' : 'Hourly Peak Activity Heatmap'),
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: cs.textPrimary),
          ),
          const SizedBox(height: 16),
          // 24 grid squares representing 24 hours of the day
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: 24,
            itemBuilder: (context, index) {
              final taps = hourlyPeaks[index] ?? 0;
              final opacity = maxTaps > 0 ? (taps / maxTaps).clamp(0.05, 1.0) : 0.05;
              final Color squareColor = taps == 0
                  ? cs.divider.withValues(alpha: 0.15)
                  : cs.primary.withValues(alpha: opacity);

              final hourStr = index.toString().padLeft(2, '0');

              return Tooltip(
                message: '$hourStr:00 - $taps taps',
                preferBelow: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: squareColor,
                    borderRadius: BorderRadius.circular(6),
                    border: taps > 0 ? Border.all(color: cs.primary.withValues(alpha: 0.2), width: 1) : null,
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 9,
                        fontWeight: taps > 0 ? FontWeight.bold : FontWeight.normal,
                        color: taps > 0
                            ? (opacity > 0.6 ? Colors.white : cs.textPrimary)
                            : cs.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // Heatmap legend explanation
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                locale == 'ku' ? 'کەمتر' : (locale == 'ar' ? 'أقل' : 'Less'),
                style: TextStyle(fontFamily: 'Cairo', fontSize: 9, color: cs.textSecondary),
              ),
              const SizedBox(width: 4),
              ...List.generate(5, (idx) {
                final opacity = 0.1 + (idx * 0.2);
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: opacity),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
              const SizedBox(width: 4),
              Text(
                locale == 'ku' ? 'زیاتر' : (locale == 'ar' ? 'أكثر' : 'More'),
                style: TextStyle(fontFamily: 'Cairo', fontSize: 9, color: cs.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTrendsCard(List<Map<String, dynamic>> dailyTrends, AppColorScheme cs, String locale) {
    if (dailyTrends.isEmpty) return const SizedBox.shrink();

    // Find the max count value for scaling bars
    int maxCount = 1;
    for (final t in dailyTrends) {
      final c = t['dhikr_count'] as int? ?? 0;
      if (c > maxCount) maxCount = c;
    }

    // Filter to last 7 days of logs to avoid screen cluttering
    final listToShow = dailyTrends.length > 7
        ? dailyTrends.sublist(dailyTrends.length - 7)
        : dailyTrends;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locale == 'ku' ? 'ڕەوتی چالاکی ڕۆژانە' : (locale == 'ar' ? 'اتجاه النشاط اليومي' : 'Daily Activity Trends'),
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: cs.textPrimary),
          ),
          const SizedBox(height: 24),
          // Custom vertical bar chart representation
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: listToShow.map((trend) {
                final date = trend['date'] as String? ?? '';
                final count = trend['dhikr_count'] as int? ?? 0;
                final sessions = trend['sessions_count'] as int? ?? 0;
                
                // Extract last part of date MM/DD or just DD for clean label
                String cleanLabel = '';
                if (date.length >= 10) {
                  cleanLabel = date.substring(8, 10);
                } else {
                  cleanLabel = date;
                }

                final percent = maxCount > 0 ? count / maxCount : 0.0;
                final barHeight = (percent * 120).clamp(6.0, 120.0);

                return Tooltip(
                  message: '$date\n$count taps\n$sessions sessions',
                  preferBelow: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Text showing count on top of bar
                      if (count > 0)
                        Text(
                          '$count',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 8, fontWeight: FontWeight.bold, color: cs.textPrimary),
                        ),
                      const SizedBox(height: 4),
                      // Bar Column
                      Container(
                        width: 18,
                        height: barHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              cs.primary,
                              cs.primary.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ).animate().scaleY(
                            begin: 0,
                            end: 1,
                            duration: 500.ms,
                            curve: Curves.easeOutBack,
                          ),
                      const SizedBox(height: 8),
                      // Day/Date Label
                      Text(
                        cleanLabel,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
