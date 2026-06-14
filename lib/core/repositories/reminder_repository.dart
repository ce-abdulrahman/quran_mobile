import '../models/reminder_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class ReminderRepository {
  final ApiClient _apiClient;

  ReminderRepository(this._apiClient);

  /// Fetch all active reminder templates with user progress.
  Future<ApiResult<List<ReminderModel>>> getReminders() async {
    try {
      final response = await _apiClient.get(ApiConstants.reminders);
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final rawList = (data['reminders'] as List?) ?? [];
        final reminders = rawList
            .map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiSuccess(reminders);
      }
      return const ApiError('Failed to load reminders settings');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Bulk-save all reminder settings.
  Future<ApiResult<bool>> saveReminders(List<ReminderModel> reminders) async {
    try {
      final payload = {
        'reminders': reminders.map((r) => r.toJson()).toList(),
      };
      final response = await _apiClient.post(ApiConstants.remindersSave, data: payload);
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return const ApiSuccess(true);
      }
      return const ApiError('Failed to save reminders');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Enable a single reminder type.
  Future<ApiResult<ReminderModel>> enableReminder(
    String type, {
    String? scheduledTime,
    String? timezone,
  }) async {
    try {
      final payload = {
        'type': type,
        if (scheduledTime != null) 'scheduled_time': scheduledTime,
        if (timezone != null) 'timezone': timezone,
      };
      final response = await _apiClient.post(ApiConstants.remindersEnable, data: payload);
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final reminder = ReminderModel.fromJson(data['reminder'] as Map<String, dynamic>);
        return ApiSuccess(reminder);
      }
      return const ApiError('Failed to enable reminder');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Disable a single reminder type.
  Future<ApiResult<bool>> disableReminder(String type) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.remindersDisable,
        data: {'type': type},
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return const ApiSuccess(true);
      }
      return const ApiError('Failed to disable reminder');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Synchronize reminder schedules and get context-aware notification content.
  Future<ApiResult<List<Map<String, dynamic>>>> syncReminders({
    int todayProgress = 0,
    int dailyGoal = 100,
    int streak = 0,
    bool nearAchievement = false,
  }) async {
    try {
      final payload = {
        'today_progress': todayProgress,
        'daily_goal': dailyGoal,
        'streak': streak,
        'near_achievement': nearAchievement,
      };
      final response = await _apiClient.post(ApiConstants.remindersSync, data: payload);
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final rawList = (data['schedule'] as List?) ?? [];
        final schedule = rawList.map((e) => e as Map<String, dynamic>).toList();
        return ApiSuccess(schedule);
      }
      return const ApiError('Failed to sync reminders schedule');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Log when a user opens a notification.
  Future<ApiResult<bool>> markOpened({
    required String notificationId,
    required String notificationType,
    String? timezone,
  }) async {
    try {
      final payload = {
        'notification_id': notificationId,
        'notification_type': notificationType,
        if (timezone != null) 'timezone': timezone,
      };
      final response = await _apiClient.post(ApiConstants.remindersOpened, data: payload);
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        return const ApiSuccess(true);
      }
      return const ApiError('Failed to log notification open status');
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
