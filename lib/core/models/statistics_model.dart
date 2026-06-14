// Statistics Data Models

class StatisticsDashboard {
  final int totalDhikr;
  final int totalSessions;
  final int currentStreak;
  final int longestStreak;
  final int totalStreakDays;
  final int totalGoalsCompleted;
  final int totalGoalsMissed;
  final double goalCompletionRate;
  final int totalAchievements;
  final int rareAchievements;
  final int fingerprintTotalCounts;
  final int fingerprintTotalSessions;
  final int? currentRank;
  final int? highestRank;
  final int remindersSent;
  final int remindersOpened;
  final int productivityScore;
  final String productivityLabel;
  final String? lastCalculatedAt;

  const StatisticsDashboard({
    required this.totalDhikr,
    required this.totalSessions,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalStreakDays,
    required this.totalGoalsCompleted,
    required this.totalGoalsMissed,
    required this.goalCompletionRate,
    required this.totalAchievements,
    required this.rareAchievements,
    required this.fingerprintTotalCounts,
    required this.fingerprintTotalSessions,
    this.currentRank,
    this.highestRank,
    required this.remindersSent,
    required this.remindersOpened,
    required this.productivityScore,
    required this.productivityLabel,
    this.lastCalculatedAt,
  });

  factory StatisticsDashboard.fromJson(Map<String, dynamic> json) {
    return StatisticsDashboard(
      totalDhikr:              (json['total_dhikr'] ?? 0) as int,
      totalSessions:           (json['total_sessions'] ?? 0) as int,
      currentStreak:           (json['current_streak'] ?? 0) as int,
      longestStreak:           (json['longest_streak'] ?? 0) as int,
      totalStreakDays:         (json['total_streak_days'] ?? 0) as int,
      totalGoalsCompleted:     (json['total_goals_completed'] ?? 0) as int,
      totalGoalsMissed:        (json['total_goals_missed'] ?? 0) as int,
      goalCompletionRate:      ((json['goal_completion_rate'] ?? 0) as num).toDouble(),
      totalAchievements:       (json['total_achievements'] ?? 0) as int,
      rareAchievements:        (json['rare_achievements'] ?? 0) as int,
      fingerprintTotalCounts:  (json['fingerprint_total_counts'] ?? 0) as int,
      fingerprintTotalSessions:(json['fingerprint_total_sessions'] ?? 0) as int,
      currentRank:             json['current_rank'] as int?,
      highestRank:             json['highest_rank'] as int?,
      remindersSent:           (json['reminders_sent'] ?? 0) as int,
      remindersOpened:         (json['reminders_opened'] ?? 0) as int,
      productivityScore:       (json['productivity_score'] ?? 0) as int,
      productivityLabel:       json['productivity_label'] ?? 'beginner',
      lastCalculatedAt:        json['last_calculated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'total_dhikr': totalDhikr,
    'total_sessions': totalSessions,
    'current_streak': currentStreak,
    'longest_streak': longestStreak,
    'total_streak_days': totalStreakDays,
    'total_goals_completed': totalGoalsCompleted,
    'total_goals_missed': totalGoalsMissed,
    'goal_completion_rate': goalCompletionRate,
    'total_achievements': totalAchievements,
    'rare_achievements': rareAchievements,
    'fingerprint_total_counts': fingerprintTotalCounts,
    'fingerprint_total_sessions': fingerprintTotalSessions,
    'current_rank': currentRank,
    'highest_rank': highestRank,
    'reminders_sent': remindersSent,
    'reminders_opened': remindersOpened,
    'productivity_score': productivityScore,
    'productivity_label': productivityLabel,
    'last_calculated_at': lastCalculatedAt,
  };

  static StatisticsDashboard empty() => const StatisticsDashboard(
    totalDhikr: 0, totalSessions: 0, currentStreak: 0, longestStreak: 0,
    totalStreakDays: 0, totalGoalsCompleted: 0, totalGoalsMissed: 0,
    goalCompletionRate: 0, totalAchievements: 0, rareAchievements: 0,
    fingerprintTotalCounts: 0, fingerprintTotalSessions: 0,
    remindersSent: 0, remindersOpened: 0,
    productivityScore: 0, productivityLabel: 'beginner',
  );
}

// ── Chart Data ────────────────────────────────────────────────────────────────

class DhikrChartPoint {
  final String date;
  final int count;
  const DhikrChartPoint({required this.date, required this.count});
  factory DhikrChartPoint.fromJson(Map<String, dynamic> j) =>
      DhikrChartPoint(date: j['date'] ?? '', count: (j['count'] ?? 0) as int);
}

class DhikrBreakdownItem {
  final String name;
  final int total;
  final double percentage;
  const DhikrBreakdownItem({required this.name, required this.total, required this.percentage});
  factory DhikrBreakdownItem.fromJson(Map<String, dynamic> j) =>
      DhikrBreakdownItem(name: j['name'] ?? '', total: (j['total'] ?? 0) as int, percentage: ((j['percentage'] ?? 0) as num).toDouble());
}

class DhikrAnalytics {
  final List<DhikrChartPoint> chartData;
  final int totalCurrent;
  final int totalPrevious;
  final double trendPct;
  final String trendDirection;
  final List<DhikrBreakdownItem> breakdown;

  const DhikrAnalytics({
    required this.chartData, required this.totalCurrent, required this.totalPrevious,
    required this.trendPct, required this.trendDirection, required this.breakdown,
  });

  factory DhikrAnalytics.fromJson(Map<String, dynamic> j) => DhikrAnalytics(
    chartData:      (j['chart_data'] as List? ?? []).map((e) => DhikrChartPoint.fromJson(e)).toList(),
    totalCurrent:   (j['total_current'] ?? 0) as int,
    totalPrevious:  (j['total_previous'] ?? 0) as int,
    trendPct:       ((j['trend_pct'] ?? 0) as num).toDouble(),
    trendDirection: j['trend_direction'] ?? 'up',
    breakdown:      (j['breakdown'] as List? ?? []).map((e) => DhikrBreakdownItem.fromJson(e)).toList(),
  );

  static DhikrAnalytics empty() => const DhikrAnalytics(chartData: [], totalCurrent: 0, totalPrevious: 0, trendPct: 0, trendDirection: 'up', breakdown: []);
}

// ── Session Analytics ─────────────────────────────────────────────────────────

class SessionAnalytics {
  final int totalSessions;
  final int avgDurationSeconds;
  final int longestSessionSecs;
  final double avgDhikrPerMinute;
  final int? mostProductiveHour;
  final String? mostProductiveDay;
  final double sessionsTrendPct;

  const SessionAnalytics({
    required this.totalSessions, required this.avgDurationSeconds,
    required this.longestSessionSecs, required this.avgDhikrPerMinute,
    this.mostProductiveHour, this.mostProductiveDay, required this.sessionsTrendPct,
  });

  factory SessionAnalytics.fromJson(Map<String, dynamic> j) => SessionAnalytics(
    totalSessions:        (j['total_sessions'] ?? 0) as int,
    avgDurationSeconds:   (j['avg_duration_seconds'] ?? 0) as int,
    longestSessionSecs:   (j['longest_session_secs'] ?? 0) as int,
    avgDhikrPerMinute:    ((j['avg_dhikr_per_minute'] ?? 0) as num).toDouble(),
    mostProductiveHour:   j['most_productive_hour'] as int?,
    mostProductiveDay:    j['most_productive_day'] as String?,
    sessionsTrendPct:     ((j['sessions_trend_pct'] ?? 0) as num).toDouble(),
  );

  static SessionAnalytics empty() => const SessionAnalytics(totalSessions: 0, avgDurationSeconds: 0, longestSessionSecs: 0, avgDhikrPerMinute: 0, sessionsTrendPct: 0);
}

// ── Streak Analytics ──────────────────────────────────────────────────────────

class StreakAnalytics {
  final int currentStreak;
  final int longestStreak;
  final int totalStreakDays;
  final double successRate;
  final Map<String, int> heatmap; // date → count

  const StreakAnalytics({
    required this.currentStreak, required this.longestStreak,
    required this.totalStreakDays, required this.successRate, required this.heatmap,
  });

  factory StreakAnalytics.fromJson(Map<String, dynamic> j) => StreakAnalytics(
    currentStreak:   (j['current_streak'] ?? 0) as int,
    longestStreak:   (j['longest_streak'] ?? 0) as int,
    totalStreakDays: (j['total_streak_days'] ?? 0) as int,
    successRate:     ((j['success_rate'] ?? 0) as num).toDouble(),
    heatmap:         (j['heatmap'] as Map<String, dynamic>? ?? {}).map((k, v) => MapEntry(k, (v as num).toInt())),
  );

  static StreakAnalytics empty() => const StreakAnalytics(currentStreak: 0, longestStreak: 0, totalStreakDays: 0, successRate: 0, heatmap: {});
}

// ── Insight ───────────────────────────────────────────────────────────────────

class InsightModel {
  final String type;
  final String fallback;
  final String icon;
  final String generatedAt;

  const InsightModel({required this.type, required this.fallback, required this.icon, required this.generatedAt});

  factory InsightModel.fromJson(Map<String, dynamic> j) => InsightModel(
    type:        j['type'] ?? '',
    fallback:    (j['data'] as Map<String, dynamic>?)?['fallback'] ?? '',
    icon:        j['icon'] ?? '💡',
    generatedAt: j['generated_at'] ?? '',
  );
}

// ── Milestone ─────────────────────────────────────────────────────────────────

class MilestoneModel {
  final String key;
  final String label;
  final int target;
  final int current;
  final double progressPct;
  final bool completed;

  const MilestoneModel({
    required this.key, required this.label, required this.target,
    required this.current, required this.progressPct, required this.completed,
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> j) => MilestoneModel(
    key:         j['key'] ?? '',
    label:       j['label'] ?? '',
    target:      (j['target'] ?? 0) as int,
    current:     (j['current'] ?? 0) as int,
    progressPct: ((j['progress_pct'] ?? 0) as num).toDouble(),
    completed:   (j['completed'] ?? false) as bool,
  );
}

// ── Statistics Period ─────────────────────────────────────────────────────────

enum StatsPeriod {
  today('today', 'Today'),
  sevenDays('7d', '7 Days'),
  thirtyDays('30d', '30 Days'),
  ninetyDays('90d', '90 Days'),
  twelveMonths('12m', '12 Months'),
  allTime('all', 'All Time');

  final String value;
  final String label;
  const StatsPeriod(this.value, this.label);
}
