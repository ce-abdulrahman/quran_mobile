import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tasbih_model.dart';
import 'app_providers.dart';
import 'achievement_provider.dart';

// State representing the merged list of active tasbihs + custom user tasbihs, and their counts.
class TasbihState {
  final List<TasbihModel> dhikrs;
  final Map<String, int> counts;
  final bool isLoading;
  final String? errorMessage;
  final int currentStreak;
  final int longestStreak;
  final String? lastActivityDate;
  final bool isWarningState;
  final int dailyGoalValue;
  final int dailyGoalProgress;
  final bool dailyGoalCompleted;
  final String? dailyGoalDate;
  final int unsyncedDailyProgress;

  const TasbihState({
    required this.dhikrs,
    required this.counts,
    this.isLoading = false,
    this.errorMessage,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
    this.isWarningState = false,
    this.dailyGoalValue = 100,
    this.dailyGoalProgress = 0,
    this.dailyGoalCompleted = false,
    this.dailyGoalDate,
    this.unsyncedDailyProgress = 0,
  });

  TasbihState copyWith({
    List<TasbihModel>? dhikrs,
    Map<String, int>? counts,
    bool? isLoading,
    String? errorMessage,
    int? currentStreak,
    int? longestStreak,
    String? lastActivityDate,
    bool? isWarningState,
    int? dailyGoalValue,
    int? dailyGoalProgress,
    bool? dailyGoalCompleted,
    String? dailyGoalDate,
    int? unsyncedDailyProgress,
  }) {
    return TasbihState(
      dhikrs: dhikrs ?? this.dhikrs,
      counts: counts ?? this.counts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      isWarningState: isWarningState ?? this.isWarningState,
      dailyGoalValue: dailyGoalValue ?? this.dailyGoalValue,
      dailyGoalProgress: dailyGoalProgress ?? this.dailyGoalProgress,
      dailyGoalCompleted: dailyGoalCompleted ?? this.dailyGoalCompleted,
      dailyGoalDate: dailyGoalDate ?? this.dailyGoalDate,
      unsyncedDailyProgress: unsyncedDailyProgress ?? this.unsyncedDailyProgress,
    );
  }
}

class TasbihNotifier extends StateNotifier<TasbihState> {
  final SharedPreferences _prefs;
  final Ref _ref;

  static const _customKey = 'tasbih_custom_list';
  static const _countsKey = 'tasbih_session_counts';

  TasbihNotifier(this._prefs, this._ref)
      : super(const TasbihState(dhikrs: [], counts: {}, isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    // 1. Load custom local dhikrs
    final customRaw = _prefs.getString(_customKey);
    List<TasbihModel> customDhikrs = [];
    if (customRaw != null) {
      try {
        final decoded = jsonDecode(customRaw) as List;
        customDhikrs = decoded.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    // 2. Load dynamic counts
    final countsRaw = _prefs.getString(_countsKey);
    Map<String, int> counts = {};
    if (countsRaw != null) {
      try {
        final decoded = jsonDecode(countsRaw) as Map<String, dynamic>;
        counts = decoded.map((k, v) => MapEntry(k, v as int));
      } catch (_) {}
    } else {
      // Migrate legacy counts: tasbih_count, tasbih_count_1, tasbih_count_2
      final count0 = _prefs.getInt('tasbih_count') ?? 0;
      final count1 = _prefs.getInt('tasbih_count_1') ?? 0;
      final count2 = _prefs.getInt('tasbih_count_2') ?? 0;
      if (count0 > 0 || count1 > 0 || count2 > 0) {
        counts['1'] = count0;
        counts['2'] = count1;
        counts['3'] = count2;
        await _prefs.setString(_countsKey, jsonEncode(counts));
      }
    }

    // Load streak stats
    int currentStreak = _prefs.getInt('tasbih_current_streak') ?? 0;
    int longestStreak = _prefs.getInt('tasbih_longest_streak') ?? 0;
    String? lastActivityDate = _prefs.getString('tasbih_last_activity_date');

    // Load daily goal stats
    int dailyGoalValue = _prefs.getInt('tasbih_daily_goal_value') ?? 100;
    int dailyGoalProgress = _prefs.getInt('tasbih_daily_progress') ?? 0;
    bool dailyGoalCompleted = _prefs.getBool('tasbih_daily_completed') ?? false;
    String? dailyGoalDate = _prefs.getString('tasbih_daily_goal_date');
    int unsyncedDailyProgress = _prefs.getInt('tasbih_unsynced_progress') ?? 0;

    // Daily check system (when app opens)
    final todayBaghdad = DateTime.now().toUtc().add(const Duration(hours: 3));
    final todayStr = "${todayBaghdad.year}-${todayBaghdad.month.toString().padLeft(2, '0')}-${todayBaghdad.day.toString().padLeft(2, '0')}";
    final yesterdayBaghdad = todayBaghdad.subtract(const Duration(days: 1));
    final yesterdayStr = "${yesterdayBaghdad.year}-${yesterdayBaghdad.month.toString().padLeft(2, '0')}-${yesterdayBaghdad.day.toString().padLeft(2, '0')}";

    bool isWarning = false;
    if (lastActivityDate != null) {
      if (lastActivityDate != todayStr && lastActivityDate != yesterdayStr) {
        // Gap > 1 day -> streak broken!
        currentStreak = 0;
        await _prefs.setInt('tasbih_current_streak', 0);
      } else if (lastActivityDate == yesterdayStr) {
        // Did yesterday, but not today yet -> warning state!
        isWarning = true;
      }
    }

    // Daily goal date check
    if (dailyGoalDate != todayStr) {
      dailyGoalProgress = 0;
      dailyGoalCompleted = false;
      dailyGoalDate = todayStr;
      unsyncedDailyProgress = 0;
      counts.clear();
      
      await _prefs.setInt('tasbih_daily_progress', 0);
      await _prefs.setBool('tasbih_daily_completed', false);
      await _prefs.setString('tasbih_daily_goal_date', todayStr);
      await _prefs.setInt('tasbih_unsynced_progress', 0);
      await _prefs.setString(_countsKey, jsonEncode(counts));
    }

    state = state.copyWith(
      counts: counts,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastActivityDate: lastActivityDate,
      isWarningState: isWarning,
      dailyGoalValue: dailyGoalValue,
      dailyGoalProgress: dailyGoalProgress,
      dailyGoalCompleted: dailyGoalCompleted,
      dailyGoalDate: dailyGoalDate,
      unsyncedDailyProgress: unsyncedDailyProgress,
    );

    // Fetch remote daily goal asynchronously (with offline sync catchup)
    if (unsyncedDailyProgress > 0) {
      _syncProgressIncrement(unsyncedDailyProgress, dailyGoalProgress, dailyGoalValue);
    } else {
      _syncDailyGoalOnLoad(dailyGoalValue, dailyGoalProgress);
    }

    // 3. Fetch remote dhikrs and merge
    await fetchRemoteDhikrs(customDhikrs);
  }

  Future<void> fetchRemoteDhikrs(List<TasbihModel> customDhikrs) async {
    try {
      final repo = _ref.read(tasbihRepositoryProvider);
      final result = await repo.getTasbihs();

      result.when(
        success: (remoteList) {
          final merged = [...remoteList, ...customDhikrs];
          state = state.copyWith(
            dhikrs: merged,
            isLoading: false,
            errorMessage: null,
          );
        },
        error: (msg, code, cached) {
          final List<TasbihModel> merged = [...(cached ?? <TasbihModel>[]), ...customDhikrs];
          state = state.copyWith(
            dhikrs: merged,
            isLoading: false,
            errorMessage: msg,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addCustomDhikr(String name, int target) async {
    final newDhikr = TasbihModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      target: target,
      isCustom: true,
    );

    final updatedDhikrs = [...state.dhikrs, newDhikr];
    
    // Save to SharedPreferences custom list
    final customList = updatedDhikrs.where((e) => e.isCustom).toList();
    await _prefs.setString(_customKey, jsonEncode(customList.map((e) => e.toJson()).toList()));

    state = state.copyWith(dhikrs: updatedDhikrs);
  }

  Timer? _syncTimer;

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  int _getGoalId(int value) {
    if (value == 100) return 1;
    if (value == 500) return 2;
    if (value == 1000) return 3;
    return 1; // Fallback to template 1
  }

  String _generateEventId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final rand1 = random.nextInt(1000000);
    final rand2 = random.nextInt(1000000);
    return 'evt_${timestamp}_${rand1}_$rand2';
  }

  Future<bool> incrementCount(String dhikrId) async {
    final current = state.counts[dhikrId] ?? 0;
    final updatedCounts = {...state.counts, dhikrId: current + 1};
    
    // Check/Update streak
    final todayBaghdad = DateTime.now().toUtc().add(const Duration(hours: 3));
    final todayStr = "${todayBaghdad.year}-${todayBaghdad.month.toString().padLeft(2, '0')}-${todayBaghdad.day.toString().padLeft(2, '0')}";
    final yesterdayBaghdad = todayBaghdad.subtract(const Duration(days: 1));
    final yesterdayStr = "${yesterdayBaghdad.year}-${yesterdayBaghdad.month.toString().padLeft(2, '0')}-${yesterdayBaghdad.day.toString().padLeft(2, '0')}";

    int currentStreak = state.currentStreak;
    int longestStreak = state.longestStreak;
    String? lastActivity = state.lastActivityDate;
    bool streakIncreased = false;

    if (lastActivity == null || lastActivity.isEmpty) {
      // First ever activity
      currentStreak = 1;
      longestStreak = 1;
      lastActivity = todayStr;
      streakIncreased = true;
    } else if (lastActivity == todayStr) {
      // Already active today, idempotent
    } else if (lastActivity == yesterdayStr) {
      // Continuation of streak
      currentStreak += 1;
      if (currentStreak > longestStreak) {
        longestStreak = currentStreak;
      }
      lastActivity = todayStr;
      streakIncreased = true;
    } else {
      // Streak was broken and resets to 1 on new activity
      currentStreak = 1;
      lastActivity = todayStr;
      streakIncreased = true;
    }

    if (streakIncreased) {
      await _prefs.setInt('tasbih_current_streak', currentStreak);
      await _prefs.setInt('tasbih_longest_streak', longestStreak);
      await _prefs.setString('tasbih_last_activity_date', lastActivity);
      
      // Attempt to sync online asynchronously
      _syncStreakOnline(currentStreak, longestStreak, lastActivity);
    }

    // Daily goal tracking logic
    int dailyGoalProgress = state.dailyGoalProgress;
    int dailyGoalValue = state.dailyGoalValue;
    bool dailyGoalCompleted = state.dailyGoalCompleted;
    String? dailyGoalDate = state.dailyGoalDate;
    int unsyncedDailyProgress = state.unsyncedDailyProgress;

    // Reset check in case day changed while session is active
    if (dailyGoalDate != todayStr) {
      dailyGoalProgress = 0;
      dailyGoalCompleted = false;
      dailyGoalDate = todayStr;
      unsyncedDailyProgress = 0;
      
      updatedCounts.clear();
      updatedCounts[dhikrId] = 1;
      
      await _prefs.setInt('tasbih_daily_progress', 0);
      await _prefs.setBool('tasbih_daily_completed', false);
      await _prefs.setString('tasbih_daily_goal_date', todayStr);
      await _prefs.setInt('tasbih_unsynced_progress', 0);
    }

    dailyGoalProgress += 1;
    unsyncedDailyProgress += 1;

    if (dailyGoalProgress >= dailyGoalValue && !dailyGoalCompleted) {
      dailyGoalCompleted = true;
      await _prefs.setBool('tasbih_daily_completed', true);
    }

    await _prefs.setInt('tasbih_daily_progress', dailyGoalProgress);
    await _prefs.setInt('tasbih_unsynced_progress', unsyncedDailyProgress);

    state = state.copyWith(
      counts: updatedCounts,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastActivityDate: lastActivity,
      isWarningState: false, // cleared warning state since we did tasbih today
      dailyGoalProgress: dailyGoalProgress,
      dailyGoalCompleted: dailyGoalCompleted,
      dailyGoalDate: dailyGoalDate,
      unsyncedDailyProgress: unsyncedDailyProgress,
    );

    await _prefs.setString(_countsKey, jsonEncode(updatedCounts));

    // Debounced sync call
    _debounceProgressSync();

    return streakIncreased;
  }

  /// Synchronize the streak with the backend database
  Future<void> _syncStreakOnline(int current, int longest, String lastActivity) async {
    try {
      final repo = _ref.read(tasbihRepositoryProvider);
      await repo.syncStreak(
        currentStreak: current,
        longestStreak: longest,
        lastActivityDate: lastActivity,
      );
    } catch (_) {
      // Fail silently, safe for offline usage
    }
  }

  /// Debounce local daily progress syncing to the server
  void _debounceProgressSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(seconds: 2), () async {
      final unsynced = state.unsyncedDailyProgress;
      if (unsynced <= 0) return;

      // Clear unsynced progress in state and preferences before calling API
      state = state.copyWith(unsyncedDailyProgress: 0);
      await _prefs.setInt('tasbih_unsynced_progress', 0);

      _syncProgressIncrement(unsynced, state.dailyGoalProgress, state.dailyGoalValue);

      // Sync achievements after progress update
      _syncAchievements();
    });
  }

  /// Sync achievement progress to the backend (fire-and-forget).
  Future<void> _syncAchievements() async {
    try {
      // Calculate total dhikr count across all dhikrs
      final totalInSession = state.counts.values.fold<int>(0, (sum, c) => sum + c);
      final totalAllTime = (_prefs.getInt('tasbih_all_time_count') ?? 0) + totalInSession;

      final achievementNotifier = _ref.read(achievementProvider.notifier);
      await achievementNotifier.syncProgress(
        totalDhikrCount: totalAllTime,
        currentStreak: state.currentStreak,
        sessionDhikrCount: totalInSession,
      );
    } catch (_) {
      // Fire-and-forget — never crash the main tasbih flow
    }
  }

  /// Sync daily progress difference to the server and merge results
  Future<void> _syncProgressIncrement(int increment, int currentProgress, int currentGoal) async {
    try {
      final repo = _ref.read(tasbihRepositoryProvider);
      final goalId = _getGoalId(currentGoal);
      final eventId = _generateEventId();
      
      final result = await repo.updateTemplateGoalProgress(
        goalId: goalId,
        incrementValue: increment,
        eventId: eventId,
      );

      result.when(
        success: (remoteGoal) {
          final newGoal = remoteGoal.goalValue;
          final newProgress = remoteGoal.currentProgress > state.dailyGoalProgress 
              ? remoteGoal.currentProgress 
              : state.dailyGoalProgress;
          final newCompleted = remoteGoal.isCompleted || (newProgress >= newGoal);

          state = state.copyWith(
            dailyGoalValue: newGoal,
            dailyGoalProgress: newProgress,
            dailyGoalCompleted: newCompleted,
          );

          _prefs.setInt('tasbih_daily_goal_value', newGoal);
          _prefs.setInt('tasbih_daily_progress', newProgress);
          _prefs.setBool('tasbih_daily_completed', newCompleted);
        },
        error: (_, __, ___) async {
          // Sync failed, restore unsynced progress
          final restoredUnsynced = state.unsyncedDailyProgress + increment;
          state = state.copyWith(
            unsyncedDailyProgress: restoredUnsynced,
          );
          await _prefs.setInt('tasbih_unsynced_progress', restoredUnsynced);
        },
      );
    } catch (_) {
      final restoredUnsynced = state.unsyncedDailyProgress + increment;
      state = state.copyWith(
        unsyncedDailyProgress: restoredUnsynced,
      );
      await _prefs.setInt('tasbih_unsynced_progress', restoredUnsynced);
    }
  }

  /// Sync today's goal state from database on app load
  Future<void> _syncDailyGoalOnLoad(int localGoal, int localProgress) async {
    try {
      final repo = _ref.read(tasbihRepositoryProvider);
      final goalId = _getGoalId(localGoal);
      final result = await repo.getTemplateGoalProgress(goalId);

      result.when(
        success: (remoteGoal) {
          final newGoal = remoteGoal.goalValue;
          final newProgress = remoteGoal.currentProgress > localProgress ? remoteGoal.currentProgress : localProgress;
          final newCompleted = remoteGoal.isCompleted || (newProgress >= newGoal);

          state = state.copyWith(
            dailyGoalValue: newGoal,
            dailyGoalProgress: newProgress,
            dailyGoalCompleted: newCompleted,
          );

          _prefs.setInt('tasbih_daily_goal_value', newGoal);
          _prefs.setInt('tasbih_daily_progress', newProgress);
          _prefs.setBool('tasbih_daily_completed', newCompleted);

          // If local progress was higher, sync the difference to the server
          if (localProgress > remoteGoal.currentProgress) {
            final diff = localProgress - remoteGoal.currentProgress;
            _syncProgressIncrement(diff, newProgress, newGoal);
          }
        },
        error: (_, __, ___) {
          // Silent fail
        },
      );
    } catch (_) {}
  }

  /// Set a new daily goal value
  Future<void> setDailyGoal(int newValue) async {
    final todayBaghdad = DateTime.now().toUtc().add(const Duration(hours: 3));
    final todayStr = "${todayBaghdad.year}-${todayBaghdad.month.toString().padLeft(2, '0')}-${todayBaghdad.day.toString().padLeft(2, '0')}";

    int dailyGoalProgress = state.dailyGoalProgress;
    if (state.dailyGoalDate != todayStr) {
      dailyGoalProgress = 0;
      await _prefs.setInt('tasbih_daily_progress', 0);
      await _prefs.setString('tasbih_daily_goal_date', todayStr);
    }

    final isCompleted = dailyGoalProgress >= newValue;

    state = state.copyWith(
      dailyGoalValue: newValue,
      dailyGoalProgress: dailyGoalProgress,
      dailyGoalCompleted: isCompleted,
      dailyGoalDate: todayStr,
    );

    await _prefs.setInt('tasbih_daily_goal_value', newValue);
    await _prefs.setBool('tasbih_daily_completed', isCompleted);

    try {
      final repo = _ref.read(tasbihRepositoryProvider);
      final goalId = _getGoalId(newValue);
      
      final result = await repo.getTemplateGoalProgress(goalId);
      result.when(
        success: (remoteGoal) {
          final newProgress = remoteGoal.currentProgress > dailyGoalProgress ? remoteGoal.currentProgress : dailyGoalProgress;
          final newCompleted = remoteGoal.isCompleted || (newProgress >= newValue);

          state = state.copyWith(
            dailyGoalProgress: newProgress,
            dailyGoalCompleted: newCompleted,
          );

          _prefs.setInt('tasbih_daily_progress', newProgress);
          _prefs.setBool('tasbih_daily_completed', newCompleted);

          // If local progress was higher, sync the difference to the server
          if (dailyGoalProgress > remoteGoal.currentProgress) {
            final diff = dailyGoalProgress - remoteGoal.currentProgress;
            _syncProgressIncrement(diff, newProgress, newValue);
          }
        },
        error: (_, __, ___) {
          // Fallback to legacy endpoint if template sync fails
          repo.setDailyGoal(
            goalValue: newValue,
            localProgress: dailyGoalProgress,
          );
        },
      );
    } catch (_) {}
  }

  Future<void> resetCount(String dhikrId) async {
    final updatedCounts = {...state.counts, dhikrId: 0};
    state = state.copyWith(counts: updatedCounts);
    await _prefs.setString(_countsKey, jsonEncode(updatedCounts));
  }

  Future<void> deleteCustomDhikr(String dhikrId) async {
    final updatedDhikrs = state.dhikrs.where((e) => e.id != dhikrId).toList();
    final customList = updatedDhikrs.where((e) => e.isCustom).toList();
    await _prefs.setString(_customKey, jsonEncode(customList.map((e) => e.toJson()).toList()));

    final updatedCounts = {...state.counts};
    updatedCounts.remove(dhikrId);
    await _prefs.setString(_countsKey, jsonEncode(updatedCounts));

    state = state.copyWith(dhikrs: updatedDhikrs, counts: updatedCounts);
  }
}
