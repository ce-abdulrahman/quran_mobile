import '../models/tasbih_session_model.dart';
import '../models/tasbih_session_log_model.dart';
import '../models/tasbih_session_analytics_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class TasbihSessionRepository {
  final ApiClient _apiClient;

  TasbihSessionRepository(this._apiClient);

  /// Start a new session.
  Future<ApiResult<TasbihSessionModel>> startSession({
    int? dhikrId,
    String? customDhikrName,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.sessionsStart,
        data: {
          if (dhikrId != null) 'dhikr_id': dhikrId,
          if (customDhikrName != null) 'custom_dhikr_name': customDhikrName,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(
          TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>),
        );
      }
      return const ApiError('Failed to start session on server');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Sync a batch of increments.
  Future<ApiResult<Map<String, dynamic>>> syncIncrements({
    required int sessionId,
    required List<TasbihSessionLogModel> increments,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.sessionsIncrement,
        data: {
          'session_id': sessionId,
          'increments': increments.map((e) => e.toJson()).toList(),
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(Map<String, dynamic>.from(data['data'] as Map));
      }
      return const ApiError('Failed to sync increments');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Pause session.
  Future<ApiResult<TasbihSessionModel>> pauseSession({
    required int sessionId,
    required String eventUuid,
    required String timestamp,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.sessionsPause,
        data: {
          'session_id': sessionId,
          'event_uuid': eventUuid,
          'timestamp': timestamp,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(
          TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>),
        );
      }
      return const ApiError('Failed to pause session');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Resume session.
  Future<ApiResult<TasbihSessionModel>> resumeSession({
    required int sessionId,
    required String eventUuid,
    required String timestamp,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.sessionsResume,
        data: {
          'session_id': sessionId,
          'event_uuid': eventUuid,
          'timestamp': timestamp,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(
          TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>),
        );
      }
      return const ApiError('Failed to resume session');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// End session.
  Future<ApiResult<TasbihSessionModel>> endSession({
    required int sessionId,
    required String eventUuid,
    int? finalCount,
    required String timestamp,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.sessionsEnd,
        data: {
          'session_id': sessionId,
          'event_uuid': eventUuid,
          if (finalCount != null) 'final_count': finalCount,
          'timestamp': timestamp,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(
          TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>),
        );
      }
      return const ApiError('Failed to end session');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get active session.
  Future<ApiResult<TasbihSessionModel?>> getActiveSession() async {
    try {
      final response = await _apiClient.get(ApiConstants.sessionsActive);
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        if (data['data'] == null) {
          return const ApiSuccess(null);
        }
        return ApiSuccess(
          TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>),
        );
      }
      return const ApiError('Failed to check active session');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get session history.
  Future<ApiResult<List<TasbihSessionModel>>> getHistory({int page = 1}) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.sessionsHistory,
        queryParameters: {'page': page},
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        final rawList = (data['data']['data'] as List?) ?? [];
        final history = rawList
            .map((e) => TasbihSessionModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiSuccess(history);
      }
      return const ApiError('Failed to load history');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get session analytics dashboard data.
  Future<ApiResult<TasbihSessionAnalyticsModel>> getAnalytics() async {
    try {
      final response = await _apiClient.get(ApiConstants.sessionsAnalytics);
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(
          TasbihSessionAnalyticsModel.fromJson(data['data'] as Map<String, dynamic>),
        );
      }
      return const ApiError('Failed to load session analytics');
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
