import 'dart:convert';
import 'package:flutter/services.dart';
import '../cache/cache_manager.dart';
import '../models/tasbih_model.dart';
import '../models/daily_goal_model.dart';
import '../models/goal_progress_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class TasbihRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  TasbihRepository(this._apiClient, this._cacheManager);

  /// Fetch all active Tasbihs. Uses Cache-First strategy.
  Future<ApiResult<List<TasbihModel>>> getTasbihs({bool forceRefresh = false}) async {
    const cacheKey = 'cache_tasbihs';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        try {
          final cachedList = cachedJson.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
          return ApiSuccess(cachedList);
        } catch (_) {
          // Fall through to API fetch if JSON deserialization fails
        }
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.tasbihs);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final tasbihs = rawList.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();

        // Cache it
        await _cacheManager.set(cacheKey, rawList, const Duration(hours: 12));
        return ApiSuccess(tasbihs);
      } else {
        return _fallbackToLocalAssets(cacheKey, 'هەڵەیەک لە داڕشتەی تەسبیحەکاندا هەیە');
      }
    } catch (e) {
      return _fallbackToLocalAssets(cacheKey, e.toString());
    }
  }

  Future<ApiResult<List<TasbihModel>>> _fallbackToLocalAssets(String cacheKey, String errorMsg) async {
    // 1. Try local cache first
    final cachedJson = _cacheManager.get(cacheKey);
    if (cachedJson != null && cachedJson is List) {
      try {
        final cachedList = cachedJson.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(cachedList);
      } catch (_) {}
    }

    // 2. Fallback to hardcoded assets/data/tasbihs.json
    try {
      final jsonString = await rootBundle.loadString('assets/data/tasbihs.json');
      final rawList = jsonDecode(jsonString) as List;
      final tasbihs = rawList.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
      return ApiSuccess(tasbihs);
    } catch (e) {
      return ApiError('$errorMsg | فایلی ناوخۆیی بار نەکرا: $e');
    }
  }

  /// Sync Tasbih streak to the server.
  Future<ApiResult<Map<String, dynamic>>> syncStreak({
    required int currentStreak,
    required int longestStreak,
    required String? lastActivityDate,
  }) async {
    try {
      final response = await _apiClient.post(
        '/streak/update',
        data: {
          'current_streak': currentStreak,
          'longest_streak': longestStreak,
          'last_activity_date': lastActivityDate,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return ApiSuccess(responseData['data'] as Map<String, dynamic>);
      }
      return const ApiError('هەڵەیەک ڕوویدا لە نوێکردنەوەی زنجیرە');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch today's daily goal status.
  Future<ApiResult<DailyGoalModel>> getTodayGoal({int? localGoal, int? localProgress}) async {
    try {
      final response = await _apiClient.get(
        '/daily-goal/today',
        queryParameters: {
          if (localGoal != null) 'goal_value': localGoal,
          if (localProgress != null) 'today_progress': localProgress,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final model = DailyGoalModel.fromJson(responseData['data'] as Map<String, dynamic>);
        return ApiSuccess(model);
      }
      return const ApiError('هەڵەیەک لە داڕشتەی ئامانجی ڕۆژانەدا هەیە');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Update today's daily goal progress.
  Future<ApiResult<DailyGoalModel>> updateGoalProgress({
    required int incrementValue,
    int? localProgress,
    int? localGoal,
  }) async {
    try {
      final response = await _apiClient.post(
        '/daily-goal/update',
        data: {
          'increment_value': incrementValue,
          if (localGoal != null) 'goal_value': localGoal,
          if (localProgress != null) 'today_progress': localProgress,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final model = DailyGoalModel.fromJson(responseData['data'] as Map<String, dynamic>);
        return ApiSuccess(model);
      }
      return const ApiError('هەڵەیەک ڕوویدا لە نوێکردنەوەی پێشکەوتنی ئامانج');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Set a new daily goal target.
  Future<ApiResult<DailyGoalModel>> setDailyGoal({
    required int goalValue,
    int? localProgress,
  }) async {
    try {
      final response = await _apiClient.post(
        '/daily-goal/set',
        data: {
          'goal_value': goalValue,
          if (localProgress != null) 'today_progress': localProgress,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final model = DailyGoalModel.fromJson(responseData['data'] as Map<String, dynamic>);
        return ApiSuccess(model);
      }
      return const ApiError('هەڵەیەک ڕوویدا لە ڕێکخستنی ئامانجی ڕۆژانە');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get progress details for a specific template goal.
  Future<ApiResult<GoalProgressModel>> getTemplateGoalProgress(int goalId, {int? userId}) async {
    try {
      final response = await _apiClient.get(
        '/goals/progress/$goalId',
        queryParameters: {
          if (userId != null) 'user_id': userId,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final model = GoalProgressModel.fromJson(responseData['data'] as Map<String, dynamic>);
        return ApiSuccess(model);
      }
      return const ApiError('هەڵەیەک لە داڕشتەی پێشکەوتنی ئامانجدا هەیە');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Update template goal progress with idempotency.
  Future<ApiResult<GoalProgressModel>> updateTemplateGoalProgress({
    required int goalId,
    required int incrementValue,
    required String eventId,
    int? userId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/goals/progress/update',
        data: {
          'goal_id': goalId,
          'increment_value': incrementValue,
          'event_id': eventId,
          if (userId != null) 'user_id': userId,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final model = GoalProgressModel.fromJson(responseData['data'] as Map<String, dynamic>);
        return ApiSuccess(model);
      }
      return const ApiError('هەڵەیەک ڕوویدا لە نوێکردنەوەی پێشکەوتنی ئامانج');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Reset template goal progress.
  Future<ApiResult<Map<String, dynamic>>> resetTemplateGoalProgress({
    String period = 'daily',
    int? userId,
  }) async {
    try {
      final response = await _apiClient.post(
        '/goals/progress/reset',
        data: {
          'period': period,
          if (userId != null) 'user_id': userId,
        },
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        return ApiSuccess(responseData);
      }
      return const ApiError('هەڵەیەک ڕوویدا لە سفرکردنەوەی پێشکەوتن');
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
