import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/statistics_model.dart';
import '../repositories/statistics_repository.dart';
import 'app_providers.dart';

// ── Repository Provider ───────────────────────────────────────────────────────

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return StatisticsRepository(api);
});

// ── UI-only period setting stored in SharedPreferences (small) ────────────────
final selectedStatsPeriodProvider = StateNotifierProvider<SelectedPeriodNotifier, StatsPeriod>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SelectedPeriodNotifier(prefs);
});

class SelectedPeriodNotifier extends StateNotifier<StatsPeriod> {
  final SharedPreferences _prefs;
  static const _key = 'stats_selected_period';

  SelectedPeriodNotifier(this._prefs) : super(_load(_prefs));

  static StatsPeriod _load(SharedPreferences prefs) {
    final saved = prefs.getString(_key);
    return StatsPeriod.values.firstWhere((p) => p.value == saved, orElse: () => StatsPeriod.thirtyDays);
  }

  Future<void> setPeriod(StatsPeriod period) async {
    state = period;
    await _prefs.setString(_key, period.value);
  }
}

// ── Statistics State ──────────────────────────────────────────────────────────

class StatisticsState {
  final StatisticsDashboard dashboard;
  final DhikrAnalytics dhikr;
  final SessionAnalytics sessions;
  final StreakAnalytics streaks;
  final List<InsightModel> insights;
  final List<MilestoneModel> milestones;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const StatisticsState({
    required this.dashboard,
    required this.dhikr,
    required this.sessions,
    required this.streaks,
    required this.insights,
    required this.milestones,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  factory StatisticsState.initial() => StatisticsState(
    dashboard:  StatisticsDashboard.empty(),
    dhikr:      DhikrAnalytics.empty(),
    sessions:   SessionAnalytics.empty(),
    streaks:    StreakAnalytics.empty(),
    insights:   const [],
    milestones: const [],
    isLoading:  true,
  );

  StatisticsState copyWith({
    StatisticsDashboard? dashboard,
    DhikrAnalytics? dhikr,
    SessionAnalytics? sessions,
    StreakAnalytics? streaks,
    List<InsightModel>? insights,
    List<MilestoneModel>? milestones,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
  }) => StatisticsState(
    dashboard:    dashboard    ?? this.dashboard,
    dhikr:        dhikr        ?? this.dhikr,
    sessions:     sessions     ?? this.sessions,
    streaks:      streaks      ?? this.streaks,
    insights:     insights     ?? this.insights,
    milestones:   milestones   ?? this.milestones,
    isLoading:    isLoading    ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    errorMessage: errorMessage,
  );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

final statisticsProvider = StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  final repo = ref.watch(statisticsRepositoryProvider);
  return StatisticsNotifier(repo);
});

class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final StatisticsRepository _repo;

  StatisticsNotifier(this._repo) : super(StatisticsState.initial());

  /// Load all statistics for the given period.
  Future<void> load(String period, {bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Dashboard and insights load independently of period
      final dashboardFuture  = _repo.getDashboard(forceRefresh: forceRefresh);
      final insightsFuture   = _repo.getInsights();
      final milestonesFuture = _repo.getMilestones();

      // Period-specific analytics
      final dhikrFuture    = _repo.getDhikrAnalytics(period);
      final sessionsFuture = _repo.getSessionAnalytics(period);
      final streaksFuture  = _repo.getStreakAnalytics(period);

      final results = await Future.wait([
        dashboardFuture, insightsFuture, milestonesFuture,
        dhikrFuture, sessionsFuture, streaksFuture,
      ]);

      state = state.copyWith(
        dashboard:  results[0] as StatisticsDashboard,
        insights:   results[1] as List<InsightModel>,
        milestones: results[2] as List<MilestoneModel>,
        dhikr:      results[3] as DhikrAnalytics,
        sessions:   results[4] as SessionAnalytics,
        streaks:    results[5] as StreakAnalytics,
        isLoading:  false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Change period — reload period-dependent analytics only.
  Future<void> changePeriod(String period) async {
    state = state.copyWith(isRefreshing: true);
    try {
      final results = await Future.wait([
        _repo.getDhikrAnalytics(period),
        _repo.getSessionAnalytics(period),
        _repo.getStreakAnalytics(period),
      ]);
      state = state.copyWith(
        dhikr:      results[0] as DhikrAnalytics,
        sessions:   results[1] as SessionAnalytics,
        streaks:    results[2] as StreakAnalytics,
        isRefreshing: false,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, errorMessage: e.toString());
    }
  }

  /// Force server recalculation + reload.
  Future<void> forceRefresh(String period) async {
    await _repo.forceRefresh();
    await load(period, forceRefresh: true);
  }
}
