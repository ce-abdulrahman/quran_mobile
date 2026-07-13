import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/reminder_model.dart';
import '../repositories/reminder_repository.dart';
import '../services/notification_coordinator.dart';
import 'app_providers.dart';

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
  ReminderNotifier() : super(const ReminderState());

  /// Load all reminder configurations
  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final isGuest = true;

    if (isGuest) {
      final local = await NotificationCoordinator.loadReminderSettings();
      String formatTime(int h, int m) => '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
      final list = [
        ReminderModel(
          type: 'PRAYER',
          key: 'prayer_notif',
          icon: '🕌',
          title: 'ئاگادارکردنەوەی کاتی نوێژەکان',
          body: 'کاتی نوێژەکان و بانگدان بۆ شارەکەت',
          priority: 5,
          sortOrder: 1,
          version: 1,
          enabled: local['prayer_enabled'] as bool? ?? true,
          scheduledTime: '00:00',
          frequency: 'daily',
          customDays: [],
          timezone: tz.local.name,
        ),
        ReminderModel(
          type: 'MEMORIZATION',
          key: 'memo_notif',
          icon: '📖',
          title: 'کاتی لەبەرکردن',
          body: 'بیرخستنەوەی ڕۆژانە بۆ لەبەرکردنی ئایەتەکان',
          priority: 5,
          sortOrder: 2,
          version: 1,
          enabled: local['memorization_enabled'] as bool? ?? false,
          scheduledTime: formatTime(local['memorization_hour'] as int? ?? 8, local['memorization_minute'] as int? ?? 0),
          frequency: 'daily',
          customDays: [],
          timezone: tz.local.name,
        ),
        ReminderModel(
          type: 'REVIEW',
          key: 'review_notif',
          icon: '🧠',
          title: 'پێداچوونەوەی لەبەرکراوەکان',
          body: 'ئایەتی لەبەرکراوی ئەمڕۆت پێداچوونەوە بکە',
          priority: 5,
          sortOrder: 3,
          version: 1,
          enabled: local['review_enabled'] as bool? ?? false,
          scheduledTime: formatTime(local['review_hour'] as int? ?? 18, local['review_minute'] as int? ?? 0),
          frequency: 'daily',
          customDays: [],
          timezone: tz.local.name,
        ),
        ReminderModel(
          type: 'WIRD',
          key: 'wird_notif',
          icon: '📿',
          title: 'وردی ڕۆژانە',
          body: 'خوێندنەوەی ئەزکار و وردی ڕۆژانەی بەیانی یان ئێوارە',
          priority: 5,
          sortOrder: 4,
          version: 1,
          enabled: local['wird_enabled'] as bool? ?? false,
          scheduledTime: formatTime(local['wird_hour'] as int? ?? 6, local['wird_minute'] as int? ?? 30),
          frequency: 'daily',
          customDays: [],
          timezone: tz.local.name,
        ),
        ReminderModel(
          type: 'TASBIH',
          key: 'tasbih_notif',
          icon: '🤲',
          title: 'بیرخستنەوەی تەسبیح',
          body: 'کاتی تەسبیحات و یادی خوای گەورە',
          priority: 5,
          sortOrder: 5,
          version: 1,
          enabled: local['tasbih_enabled'] as bool? ?? false,
          scheduledTime: formatTime(local['tasbih_hour'] as int? ?? 20, local['tasbih_minute'] as int? ?? 0),
          frequency: 'daily',
          customDays: [],
          timezone: tz.local.name,
        ),
      ];
      state = state.copyWith(reminders: list, isLoading: false);
      return;
    }
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

  /// Save preferences in bulk and trigger local reschedule.
  Future<bool> savePreferences() async {
    state = state.copyWith(isSaving: true, clearError: true);

    ReminderModel? getReminder(String type) {
      for (final r in state.reminders) {
        if (r.type == type) return r;
      }
      return null;
    }

    int? getHour(String type) {
      final r = getReminder(type);
      if (r == null) return null;
      final parts = r.scheduledTime.split(':');
      return parts.isNotEmpty ? int.tryParse(parts[0]) : null;
    }

    int? getMinute(String type) {
      final r = getReminder(type);
      if (r == null) return null;
      final parts = r.scheduledTime.split(':');
      return parts.length > 1 ? int.tryParse(parts[1]) : null;
    }

    bool? getEnabled(String type) {
      final r = getReminder(type);
      return r?.enabled;
    }

    // Save locally
    await NotificationCoordinator.saveReminderSettings(
      prayerEnabled: getEnabled('PRAYER'),
      memorizationEnabled: getEnabled('MEMORIZATION'),
      reviewEnabled: getEnabled('REVIEW'),
      wirdEnabled: getEnabled('WIRD'),
      tasbihEnabled: getEnabled('TASBIH'),
      tasbihHour: getHour('TASBIH'),
      tasbihMinute: getMinute('TASBIH'),
      reviewHour: getHour('REVIEW'),
      reviewMinute: getMinute('REVIEW'),
      wirdHour: getHour('WIRD'),
      wirdMinute: getMinute('WIRD'),
      memorizationHour: getHour('MEMORIZATION'),
      memorizationMinute: getMinute('MEMORIZATION'),
    );

    // Local rescheduling
    final coordinator = NotificationCoordinator();
    
    if (getEnabled('MEMORIZATION') == true) {
      await coordinator.scheduleMemorizationReminder(
        hour: getHour('MEMORIZATION') ?? 8,
        minute: getMinute('MEMORIZATION') ?? 0,
      );
    } else {
      await coordinator.cancelMemorizationReminder();
    }

    if (getEnabled('REVIEW') == true) {
      await coordinator.scheduleReviewReminder(
        hour: getHour('REVIEW') ?? 18,
        minute: getMinute('REVIEW') ?? 0,
      );
    } else {
      await coordinator.cancelReviewReminder();
    }

    if (getEnabled('WIRD') == true) {
      await coordinator.scheduleWirdReminder(
        hour: getHour('WIRD') ?? 6,
        minute: getMinute('WIRD') ?? 30,
      );
    } else {
      await coordinator.cancelWirdReminder();
    }

    if (getEnabled('TASBIH') == true) {
      await coordinator.scheduleTasbihReminder(
        hour: getHour('TASBIH') ?? 20,
        minute: getMinute('TASBIH') ?? 0,
      );
    } else {
      await coordinator.cancelTasbihReminder();
    }

    state = state.copyWith(isSaving: false);
    return true;
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
  return ReminderNotifier();
});
