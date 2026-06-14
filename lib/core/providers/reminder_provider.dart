import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/reminder_model.dart';
import '../repositories/reminder_repository.dart';
import '../services/reminder_engine.dart';
import 'app_providers.dart';
import 'achievement_provider.dart';

// ── Repository Provider ──────────────────────────────────────────────────────
final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReminderRepository(apiClient);
});

// ── State Class ──────────────────────────────────────────────────────────────
class ReminderState {
  final List<ReminderModel> reminders;
  final bool isLoading;
  final String? errorMessage;
  final bool isSaving;

  const ReminderState({
    this.reminders = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isSaving = false,
  });

  ReminderState copyWith({
    List<ReminderModel>? reminders,
    bool? isLoading,
    String? errorMessage,
    bool? isSaving,
    bool clearError = false,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSaving: isSaving ?? this.isSaving,
    );
  }

  /// Helper to check if master notification is enabled
  bool get isMasterEnabled => reminders.any((r) => r.enabled);
}

// ── State Notifier ────────────────────────────────────────────────────────────
class ReminderNotifier extends StateNotifier<ReminderState> {
  final ReminderRepository _repository;
  final Ref _ref;

  ReminderNotifier(this._repository, this._ref) : super(const ReminderState());

  /// Load all reminder configurations from the server
  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getReminders();
    result.when(
      success: (reminders) {
        state = state.copyWith(reminders: reminders, isLoading: false);
      },
      error: (msg, _, __) {
        state = state.copyWith(isLoading: false, errorMessage: msg);
      },
    );
  }

  /// Toggle enabled state of a single reminder type locally.
  void toggleReminderLocally(String type, bool enabled) {
    state = state.copyWith(
      reminders: state.reminders.map((r) {
        if (r.type == type) {
          return r.copyWith(enabled: enabled);
        }
        return r;
      }).toList(),
    );
  }

  /// Update scheduled time of a single reminder type locally.
  void updateTimeLocally(String type, String time) {
    state = state.copyWith(
      reminders: state.reminders.map((r) {
        if (r.type == type) {
          return r.copyWith(scheduledTime: time);
        }
        return r;
      }).toList(),
    );
  }

  /// Update recurrence frequency of a single reminder type locally.
  void updateFrequencyLocally(String type, String frequency, List<int> customDays) {
    state = state.copyWith(
      reminders: state.reminders.map((r) {
        if (r.type == type) {
          return r.copyWith(frequency: frequency, customDays: customDays);
        }
        return r;
      }).toList(),
    );
  }

  /// Save all current reminder preferences in bulk to the server and trigger local reschedule.
  Future<bool> savePreferences() async {
    state = state.copyWith(isSaving: true, clearError: true);

    // Ensure user's device timezone is set for all reminders being saved
    final localTimezone = tz.local.name;
    final updatedList = state.reminders.map((r) {
      return r.copyWith(timezone: localTimezone);
    }).toList();

    final result = await _repository.saveReminders(updatedList);
    return result.when(
      success: (_) async {
        state = state.copyWith(reminders: updatedList, isSaving: false);
        // Refresh local schedules by syncing with backend
        await syncAndReschedule();
        return true;
      },
      error: (msg, _, __) {
        state = state.copyWith(isSaving: false, errorMessage: msg);
        return false;
      },
    );
  }

  /// Sync schedules from backend (using live user metrics) and reschedule local alarms.
  Future<void> syncAndReschedule() async {
    final tasbihState = _ref.read(tasbihProvider);
    
    // Check if achievementProvider has loaded, to get nearAchievement status
    bool nearAchievement = false;
    try {
      final achsState = _ref.read(achievementProvider);
      nearAchievement = achsState.achievements.any((ach) => !ach.isCompleted && ach.progressFraction >= 0.8);
    } catch (_) {}

    final result = await _repository.syncReminders(
      todayProgress: tasbihState.dailyGoalProgress,
      dailyGoal: tasbihState.dailyGoalValue,
      streak: tasbihState.currentStreak,
      nearAchievement: nearAchievement,
    );

    result.when(
      success: (schedule) async {
        await ReminderEngine().scheduleReminders(schedule);
      },
      error: (msg, _, __) {
        state = state.copyWith(errorMessage: 'Local reschedule failed: $msg');
      },
    );
  }

  /// Enable or disable all reminders at once (Master Toggle)
  Future<void> setMasterEnabled(bool enabled) async {
    state = state.copyWith(
      reminders: state.reminders.map((r) => r.copyWith(enabled: enabled)).toList(),
    );
    await savePreferences();
  }
}

// ── Riverpod Provider ─────────────────────────────────────────────────────────
final reminderProvider = StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  final repo = ref.watch(reminderRepositoryProvider);
  return ReminderNotifier(repo, ref);
});
