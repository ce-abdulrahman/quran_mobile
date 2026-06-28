import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../core/models/statistics_model.dart';
import '../../core/providers/statistics_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage>
    with TickerProviderStateMixin {
  late TabController _periodTabController;

  static const _periods = StatsPeriod.values;

  @override
  void initState() {
    super.initState();
    _periodTabController = TabController(length: _periods.length, vsync: this);

    final saved = ref.read(selectedStatsPeriodProvider);
    final savedIndex = _periods.indexOf(saved);
    if (savedIndex >= 0) _periodTabController.index = savedIndex;

    _periodTabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final period = ref.read(selectedStatsPeriodProvider);
      ref.read(statisticsProvider.notifier).load(period.value);
    });
  }

  void _onTabChanged() {
    if (_periodTabController.indexIsChanging) return;
    final period = _periods[_periodTabController.index];
    ref.read(selectedStatsPeriodProvider.notifier).setPeriod(period);
    ref.read(statisticsProvider.notifier).changePeriod(period.value);
  }

  @override
  void dispose() {
    _periodTabController.removeListener(_onTabChanged);
    _periodTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats   = ref.watch(statisticsProvider);
    final cs      = AppColorScheme.of(context);

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: cs.card,
        elevation: 0,
        title: Text(
          context.l10n.statsTitle,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: cs.textPrimary),
        ),
        actions: [
          if (stats.isRefreshing)
            const Padding(padding: EdgeInsets.all(16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
          else
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: cs.primary),
              onPressed: () {
                final period = ref.read(selectedStatsPeriodProvider);
                ref.read(statisticsProvider.notifier).forceRefresh(period.value);
              },
            ),
        ],
      ),
      body: stats.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                final period = ref.read(selectedStatsPeriodProvider);
                await ref.read(statisticsProvider.notifier).forceRefresh(period.value);
              },
              child: CustomScrollView(
                slivers: [
                  // Period Tab Bar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _PeriodTabDelegate(
                      tabController: _periodTabController,
                      periods: _periods,
                      cs: cs,
                    ),
                  ),

                  // Content
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),

                      // ── Summary Cards ───────────────────────────────────────
                      _buildSummaryCards(stats.dashboard, cs),
                      const SizedBox(height: 20),

                      // ── Productivity Score ──────────────────────────────────
                      _buildProductivityScore(stats.dashboard, cs),
                      const SizedBox(height: 20),

                      // ── Dhikr Activity Chart ────────────────────────────────
                      _buildDhikrChart(stats.dhikr, cs),
                      const SizedBox(height: 20),

                      // ── Trend Comparison ────────────────────────────────────
                      _buildTrendComparison(stats.dhikr, stats.sessions, cs),
                      const SizedBox(height: 20),

                      // ── Streak Heatmap ──────────────────────────────────────
                      _buildStreakHeatmap(stats.streaks, cs),
                      const SizedBox(height: 20),

                      // ── Dhikr Breakdown ─────────────────────────────────────
                      _buildDhikrBreakdown(stats.dhikr, cs),
                      const SizedBox(height: 20),

                      // ── Session Analytics ───────────────────────────────────
                      _buildSessionCards(stats.sessions, cs),
                      const SizedBox(height: 20),

                      // ── Milestones ──────────────────────────────────────────
                      _buildMilestones(stats.milestones, cs),
                      const SizedBox(height: 20),

                      // ── Insights ────────────────────────────────────────────
                      _buildInsights(stats.insights, cs),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ],
              ),
            ),
    );
  }

  // ── Summary Cards ────────────────────────────────────────────────────────────

  Widget _buildSummaryCards(StatisticsDashboard d, AppColorScheme cs) {
    final l = context.l10n;
    final cards = [
      _SummaryCard(icon: '📿', label: l.statsTotalDhikr,    value: _fmt(d.totalDhikr),    color: const Color(0xFF6366F1)),
      _SummaryCard(icon: '🔥', label: l.statsCurrentStreak, value: l.homeStreakCurrentDays(d.currentStreak), color: const Color(0xFFEF4444)),
      _SummaryCard(icon: '🏆', label: l.statsBestStreak,    value: l.homeStreakCurrentDays(d.longestStreak), color: const Color(0xFFF59E0B)),
      _SummaryCard(icon: '🎯', label: l.statsGoalsCompleted,     value: _fmt(d.totalGoalsCompleted), color: const Color(0xFF10B981)),
      _SummaryCard(icon: '⭐', label: l.statsAchievements,   value: '${d.totalAchievements}', color: const Color(0xFF8B5CF6)),
      _SummaryCard(icon: '📊', label: l.statsSessions,       value: _fmt(d.totalSessions),  color: const Color(0xFF3B82F6)),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _summaryCardWidget(cards[i], cs),
      ),
    );
  }

  Widget _summaryCardWidget(_SummaryCard card, AppColorScheme cs) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [card.color.withValues(alpha: 0.15), card.color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: card.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.icon, style: const TextStyle(fontSize: 22)),
          const Spacer(),
          Text(card.value, style: TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.bold, color: cs.textPrimary)),
          Text(card.label, style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // ── Productivity Score ───────────────────────────────────────────────────────

  Widget _buildProductivityScore(StatisticsDashboard d, AppColorScheme cs) {
    final labelColors = {
      'master': const Color(0xFF6F42C1),
      'advanced': const Color(0xFF0D6EFD),
      'dedicated': const Color(0xFF198754),
      'active': const Color(0xFFFFC107),
      'beginner': const Color(0xFF6C757D),
    };
    final color = labelColors[d.productivityLabel] ?? cs.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: d.productivityScore / 100,
                    backgroundColor: color.withValues(alpha: 0.15),
                    color: color,
                    strokeWidth: 7,
                  ),
                  Text('${d.productivityScore}', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18, color: color)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.statsSpiritualProductivity, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      d.productivityLabel == 'master' ? context.l10n.statsLabelMaster :
                      d.productivityLabel == 'advanced' ? context.l10n.statsLabelAdvanced :
                      d.productivityLabel == 'dedicated' ? context.l10n.statsLabelDedicated :
                      d.productivityLabel == 'active' ? context.l10n.statsLabelActive : context.l10n.statsLabelBeginner,
                      style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(context.l10n.statsGoalAndStreak(d.goalCompletionRate.toStringAsFixed(1), '${d.currentStreak}'), style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dhikr Activity Chart ──────────────────────────────────────────────────────

  Widget _buildDhikrChart(DhikrAnalytics dhikr, AppColorScheme cs) {
    if (dhikr.chartData.isEmpty) return const SizedBox.shrink();

    final spots = dhikr.chartData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.count.toDouble())).toList();
    final maxY   = spots.map((s) => s.y).fold(0.0, (a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _Card(
        title: context.l10n.statsDhikrActivityChart,
        child: SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: cs.cardBorder, strokeWidth: 0.5)),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: (dhikr.chartData.length / 5).roundToDouble().clamp(1, 999),
                  getTitlesWidget: (val, _) {
                    final idx = val.toInt();
                    if (idx >= dhikr.chartData.length) return const SizedBox();
                    final date = dhikr.chartData[idx].date;
                    return Padding(padding: const EdgeInsets.only(top: 4), child: Text(date.substring(5), style: TextStyle(fontSize: 9, color: cs.textSecondary)));
                  },
                )),
              ),
              borderData: FlBorderData(show: false),
              minX: 0, maxX: (spots.length - 1).toDouble(),
              minY: 0, maxY: maxY * 1.2,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: cs.primary,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [cs.primary.withValues(alpha: 0.3), cs.primary.withValues(alpha: 0.0)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Trend Comparison ─────────────────────────────────────────────────────────

  Widget _buildTrendComparison(DhikrAnalytics dhikr, SessionAnalytics sessions, AppColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _TrendTile(
            label: context.l10n.statsDhikrTrendVsPrev,
            current: dhikr.totalCurrent,
            previous: dhikr.totalPrevious,
            trendPct: dhikr.trendPct,
            cs: cs,
          )),
          const SizedBox(width: 10),
          Expanded(child: _TrendTile(
            label: context.l10n.statsSessionsTrendVsPrev,
            current: sessions.totalSessions,
            previous: sessions.totalSessions,
            trendPct: sessions.sessionsTrendPct,
            cs: cs,
          )),
        ],
      ),
    );
  }

  // ── Streak Heatmap ───────────────────────────────────────────────────────────

  Widget _buildStreakHeatmap(StreakAnalytics streaks, AppColorScheme cs) {
    if (streaks.heatmap.isEmpty) return const SizedBox.shrink();

    final maxCount = streaks.heatmap.values.fold(0, (a, b) => a > b ? a : b).toDouble().clamp(1.0, double.infinity);

    // Build last 12 weeks (84 days) grid
    final today = DateTime.now();
    final cells = <_HeatmapCell>[];
    for (int i = 83; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      final count = streaks.heatmap[key] ?? 0;
      cells.add(_HeatmapCell(date: day, count: count, intensity: count / maxCount));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _Card(
        title: context.l10n.statsStreakHeatmap,
        subtitle: context.l10n.statsStreakSummary(
          '${streaks.currentStreak}',
          '${streaks.longestStreak}',
          streaks.successRate.toStringAsFixed(0),
        ),
        child: SizedBox(
          height: 90,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 12, mainAxisSpacing: 3, crossAxisSpacing: 3),
            itemCount: cells.length,
            itemBuilder: (_, i) {
              final c = cells[i];
              return Tooltip(
                message: '${DateFormat('MMM d').format(c.date)}: ${c.count}',
                child: Container(
                  decoration: BoxDecoration(
                    color: c.count == 0
                        ? cs.cardBorder
                        : cs.primary.withValues(alpha: 0.2 + c.intensity * 0.8),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Dhikr Breakdown ──────────────────────────────────────────────────────────

  Widget _buildDhikrBreakdown(DhikrAnalytics dhikr, AppColorScheme cs) {
    if (dhikr.breakdown.isEmpty) return const SizedBox.shrink();

    final colors = [const Color(0xFF6366F1), const Color(0xFF3B82F6), const Color(0xFF10B981), const Color(0xFFF59E0B), const Color(0xFFEF4444)];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _Card(
        title: context.l10n.statsMostUsedDhikr,
        child: Column(
          children: dhikr.breakdown.asMap().entries.map((e) {
            final item = e.value;
            final color = colors[e.key % colors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(item.name, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textPrimary, fontWeight: FontWeight.w600))),
                      Text('${_fmt(item.total)}  (${item.percentage.toStringAsFixed(1)}%)', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: item.percentage / 100,
                      backgroundColor: color.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 7,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Session Cards ────────────────────────────────────────────────────────────

  Widget _buildSessionCards(SessionAnalytics s, AppColorScheme cs) {
    final l = context.l10n;
    String hourLabel(int? h) {
      if (h == null) return '—';
      if (h >= 4 && h < 8)   return l.statsPrayerHour(l.statsFajr, h);
      if (h >= 12 && h < 14) return l.statsPrayerHour(l.statsDhuhr, h);
      if (h >= 15 && h < 17) return l.statsPrayerHour(l.statsAsr, h);
      if (h >= 18 && h < 20) return l.statsPrayerHour(l.statsMaghrib, h);
      if (h >= 20 && h < 23) return l.statsPrayerHour(l.statsIsha, h);
      return l.statsHourLabel(h);
    }

    String durLabel(int secs) {
      if (secs < 60) return l.statsDurationSecs(secs);
      return l.statsDurationMinsAndSecs(secs ~/ 60, secs % 60);
    }

    String dayLabel(String? d) {
      if (d == null) return '—';
      switch (d.toLowerCase()) {
        case 'monday': return l.statsDayMonday;
        case 'tuesday': return l.statsDayTuesday;
        case 'wednesday': return l.statsDayWednesday;
        case 'thursday': return l.statsDayThursday;
        case 'friday': return l.statsDayFriday;
        case 'saturday': return l.statsDaySaturday;
        case 'sunday': return l.statsDaySunday;
        default: return d;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _Card(
        title: l.statsSessionAnalysis,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _StatTile(l.statsTotalSessions,     '${s.totalSessions}',                cs),
            _StatTile(l.statsAvgDuration,        durLabel(s.avgDurationSeconds),      cs),
            _StatTile(l.statsLongestSession,     durLabel(s.longestSessionSecs),      cs),
            _StatTile(l.statsAvgDhikrPerMin,       '${s.avgDhikrPerMinute.toStringAsFixed(1)}', cs),
            _StatTile(l.statsPeakHour,           hourLabel(s.mostProductiveHour),     cs),
            _StatTile(l.statsPeakDay,            dayLabel(s.mostProductiveDay),          cs),
          ],
        ),
      ),
    );
  }

  // ── Milestones ───────────────────────────────────────────────────────────────

  Widget _buildMilestones(List<MilestoneModel> milestones, AppColorScheme cs) {
    final pending = milestones.where((m) => !m.completed).take(5).toList();
    if (pending.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _Card(
        title: context.l10n.statsUpcomingGoals,
        child: Column(
          children: pending.map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(m.label, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.w600, color: cs.textPrimary))),
                    Text('${_fmt(m.current)} / ${_fmt(m.target)}', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: m.progressPct / 100,
                    backgroundColor: cs.primary.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(cs.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(context.l10n.statsCompletedPct(m.progressPct.toStringAsFixed(1)), style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary)),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  // ── Insights ─────────────────────────────────────────────────────────────────

  Widget _buildInsights(List<InsightModel> insights, AppColorScheme cs) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _Card(
        title: context.l10n.statsInsights,
        child: Column(
          children: insights.map((i) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.cardBorder),
            ),
            child: Row(
              children: [
                Text(i.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(child: Text(i.fallback, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textPrimary))),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  String _fmt(int n) => NumberFormat.compact().format(n);
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _Card({required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 14, color: cs.textPrimary)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary)),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TrendTile extends StatelessWidget {
  final String label;
  final int current;
  final int previous;
  final double trendPct;
  final AppColorScheme cs;

  const _TrendTile({required this.label, required this.current, required this.previous, required this.trendPct, required this.cs});

  @override
  Widget build(BuildContext context) {
    final isUp  = trendPct >= 0;
    final color = isUp ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary)),
          const SizedBox(height: 4),
          Text(NumberFormat.compact().format(current), style: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold, color: cs.textPrimary)),
          Row(
            children: [
              Icon(isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, size: 14, color: color),
              Text('${trendPct.abs().toStringAsFixed(1)}% بە بەراورد بە پێشوو', style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final AppColorScheme cs;

  const _StatTile(this.label, this.value, this.cs);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15, color: cs.textPrimary)),
          Text(label,  style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary)),
        ],
      ),
    );
  }
}

class _SummaryCard {
  final String icon;
  final String label;
  final String value;
  final Color color;
  const _SummaryCard({required this.icon, required this.label, required this.value, required this.color});
}

class _HeatmapCell {
  final DateTime date;
  final int count;
  final double intensity;
  const _HeatmapCell({required this.date, required this.count, required this.intensity});
}

// ── Period Tab Persistent Header ─────────────────────────────────────────────

class _PeriodTabDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<StatsPeriod> periods;
  final AppColorScheme cs;

  const _PeriodTabDelegate({required this.tabController, required this.periods, required this.cs});

  @override double get minExtent => 48;
  @override double get maxExtent => 48;
  @override bool shouldRebuild(covariant _PeriodTabDelegate oldDelegate) => true;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 48,
      child: Container(
        color: cs.bg,
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: cs.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          labelColor: cs.primary,
          unselectedLabelColor: cs.textSecondary,
          tabs: periods.map((p) => Tab(text: p.label)).toList(),
        ),
      ),
    );
  }
}
