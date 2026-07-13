import 'package:flutter/foundation.dart';

import 'package:isar/isar.dart';
import '../models/tasbih_session_model.dart';
import '../models/tasbih_session_log_model.dart';
import '../models/tasbih_session_analytics_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';


class TasbihSessionRepository {
  final ApiClient _apiClient;

  TasbihSessionRepository(this._apiClient);

  Isar get _isar => IsarService.instance.isar;
  bool get _isAuthenticated => false;

  /// Start a new session.
  Future<ApiResult<TasbihSessionModel>> startSession({
    int? dhikrId,
    String? customDhikrName,
  }) async {
    if (_isAuthenticated) {
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
          final session = TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>);
          await _cacheSession(session);
          return ApiSuccess(session);
        }
      } catch (e) {
        debugPrint('Error starting session on API: $e');
      }
    }

    // Offline / Guest fallback
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final newSession = TasbihSessionCollection(
      sessionId: sessionId,
      startTime: DateTime.now(),
      durationSeconds: 0,
      totalCount: 0,
      avgPerMinute: 0.0,
      sessionDate: DateTime.now().toIso8601String().substring(0, 10),
      status: 'active',
      customDhikrName: customDhikrName ?? (dhikrId != null ? 'Dhikr $dhikrId' : 'General'),
      updatedAt: DateTime.now(),
      isSynced: false,
    );
    await _isar.writeTxn(() async {
      await _isar.tasbihSessionCollections.put(newSession);
    });
    return ApiSuccess(TasbihSessionModel(
      id: newSession.id,
      userId: 0,
      startTime: newSession.startTime,
      durationSeconds: 0,
      totalCount: 0,
      avgPerMinute: 0.0,
      sessionDate: newSession.sessionDate,
      status: 'active',
      customDhikrName: newSession.customDhikrName,
    ));
  }

  Future<void> _cacheSession(TasbihSessionModel session) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.tasbihSessionCollections.filter()
          .sessionIdEqualTo(session.id.toString())
          .findFirst();
      final item = TasbihSessionCollection(
        sessionId: session.id.toString(),
        startTime: session.startTime,
        endTime: session.endTime,
        durationSeconds: session.durationSeconds,
        totalCount: session.totalCount,
        avgPerMinute: session.avgPerMinute,
        sessionDate: session.sessionDate,
        status: session.status,
        customDhikrName: session.customDhikrName,
        updatedAt: DateTime.now(),
        isSynced: true,
      );
      if (existing != null) {
        item.id = existing.id;
      }
      await _isar.tasbihSessionCollections.put(item);
    });
  }

  /// Sync a batch of increments.
  Future<ApiResult<Map<String, dynamic>>> syncIncrements({
    required int sessionId,
    required List<TasbihSessionLogModel> increments,
  }) async {
    if (_isAuthenticated) {
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
      } catch (e) {
        debugPrint('Error syncing increments to API: $e');
      }
    }

    // Offline / Guest fallback
    final session = await _isar.tasbihSessionCollections.get(sessionId);
    if (session != null) {
      final totalAdded = increments.fold<int>(0, (sum, item) => sum + item.value);
      session.totalCount += totalAdded;
      session.updatedAt = DateTime.now();
      session.isSynced = false;
      await _isar.writeTxn(() async {
        await _isar.tasbihSessionCollections.put(session);
      });
      return ApiSuccess({});
    }
    return const ApiError('Session not found locally');
  }

  /// Pause session.
  Future<ApiResult<TasbihSessionModel>> pauseSession({
    required int sessionId,
    required String eventUuid,
    required String timestamp,
  }) async {
    if (_isAuthenticated) {
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
          final session = TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>);
          await _cacheSession(session);
          return ApiSuccess(session);
        }
      } catch (e) {
        debugPrint('Error pausing session on API: $e');
      }
    }

    final session = await _isar.tasbihSessionCollections.get(sessionId);
    if (session != null) {
      session.status = 'paused';
      session.updatedAt = DateTime.now();
      session.isSynced = false;
      await _isar.writeTxn(() async {
        await _isar.tasbihSessionCollections.put(session);
      });
      return ApiSuccess(TasbihSessionModel(
        id: session.id,
        userId: 0,
        startTime: session.startTime,
        endTime: session.endTime,
        durationSeconds: session.durationSeconds,
        totalCount: session.totalCount,
        avgPerMinute: session.avgPerMinute,
        sessionDate: session.sessionDate,
        status: session.status,
        customDhikrName: session.customDhikrName,
      ));
    }
    return const ApiError('Failed to pause session');
  }

  /// Resume session.
  Future<ApiResult<TasbihSessionModel>> resumeSession({
    required int sessionId,
    required String eventUuid,
    required String timestamp,
  }) async {
    if (_isAuthenticated) {
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
          final session = TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>);
          await _cacheSession(session);
          return ApiSuccess(session);
        }
      } catch (e) {
        debugPrint('Error resuming session on API: $e');
      }
    }

    final session = await _isar.tasbihSessionCollections.get(sessionId);
    if (session != null) {
      session.status = 'active';
      session.updatedAt = DateTime.now();
      session.isSynced = false;
      await _isar.writeTxn(() async {
        await _isar.tasbihSessionCollections.put(session);
      });
      return ApiSuccess(TasbihSessionModel(
        id: session.id,
        userId: 0,
        startTime: session.startTime,
        endTime: session.endTime,
        durationSeconds: session.durationSeconds,
        totalCount: session.totalCount,
        avgPerMinute: session.avgPerMinute,
        sessionDate: session.sessionDate,
        status: session.status,
        customDhikrName: session.customDhikrName,
      ));
    }
    return const ApiError('Failed to resume session');
  }

  /// End session.
  Future<ApiResult<TasbihSessionModel>> endSession({
    required int sessionId,
    required String eventUuid,
    int? finalCount,
    required String timestamp,
  }) async {
    if (_isAuthenticated) {
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
          final session = TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>);
          await _cacheSession(session);
          return ApiSuccess(session);
        }
      } catch (e) {
        debugPrint('Error ending session on API: $e');
      }
    }

    final session = await _isar.tasbihSessionCollections.get(sessionId);
    if (session != null) {
      session.status = 'completed';
      session.endTime = DateTime.now();
      if (finalCount != null) {
        session.totalCount = finalCount;
      }
      final duration = session.endTime!.difference(session.startTime).inSeconds;
      session.durationSeconds = duration > 0 ? duration : 0;
      session.avgPerMinute = session.durationSeconds > 0 
          ? (session.totalCount / (session.durationSeconds / 60.0))
          : session.totalCount.toDouble();
      session.updatedAt = DateTime.now();
      session.isSynced = false;
      await _isar.writeTxn(() async {
        await _isar.tasbihSessionCollections.put(session);
      });
      return ApiSuccess(TasbihSessionModel(
        id: session.id,
        userId: 0,
        startTime: session.startTime,
        endTime: session.endTime,
        durationSeconds: session.durationSeconds,
        totalCount: session.totalCount,
        avgPerMinute: session.avgPerMinute,
        sessionDate: session.sessionDate,
        status: session.status,
        customDhikrName: session.customDhikrName,
      ));
    }
    return const ApiError('Failed to end session');
  }

  /// Get active session.
  Future<ApiResult<TasbihSessionModel?>> getActiveSession() async {
    if (_isAuthenticated) {
      try {
        final response = await _apiClient.get(ApiConstants.sessionsActive);
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          if (data['data'] == null) {
            return const ApiSuccess(null);
          }
          final session = TasbihSessionModel.fromJson(data['data'] as Map<String, dynamic>);
          await _cacheSession(session);
          return ApiSuccess(session);
        }
      } catch (e) {
        debugPrint('Error checking active session on API: $e');
      }
    }

    final session = await _isar.tasbihSessionCollections.filter()
        .statusEqualTo('active')
        .or()
        .statusEqualTo('paused')
        .findFirst();
    if (session == null) {
      return const ApiSuccess(null);
    }
    return ApiSuccess(TasbihSessionModel(
      id: session.id,
      userId: 0,
      startTime: session.startTime,
      endTime: session.endTime,
      durationSeconds: session.durationSeconds,
      totalCount: session.totalCount,
      avgPerMinute: session.avgPerMinute,
      sessionDate: session.sessionDate,
      status: session.status,
      customDhikrName: session.customDhikrName,
    ));
  }

  /// Get session history.
  Future<ApiResult<List<TasbihSessionModel>>> getHistory({int page = 1}) async {
    if (_isAuthenticated) {
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
          for (final s in history) {
            await _cacheSession(s);
          }
          return ApiSuccess(history);
        }
      } catch (e) {
        debugPrint('Error loading history from API: $e');
      }
    }

    final list = await _isar.tasbihSessionCollections.filter()
        .statusEqualTo('completed')
        .sortByStartTimeDesc()
        .findAll();
    final models = list.map((session) => TasbihSessionModel(
      id: session.id,
      userId: 0,
      startTime: session.startTime,
      endTime: session.endTime,
      durationSeconds: session.durationSeconds,
      totalCount: session.totalCount,
      avgPerMinute: session.avgPerMinute,
      sessionDate: session.sessionDate,
      status: session.status,
      customDhikrName: session.customDhikrName,
    )).toList();
    return ApiSuccess(models);
  }

  /// Get session analytics dashboard data.
  Future<ApiResult<TasbihSessionAnalyticsModel>> getAnalytics() async {
    if (_isAuthenticated) {
      try {
        final response = await _apiClient.get(ApiConstants.sessionsAnalytics);
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == 'success') {
          return ApiSuccess(
            TasbihSessionAnalyticsModel.fromJson(data['data'] as Map<String, dynamic>),
          );
        }
      } catch (e) {
        debugPrint('Error loading session analytics from API: $e');
      }
    }

    final list = await _isar.tasbihSessionCollections.filter()
        .statusEqualTo('completed')
        .findAll();
    final totalCount = list.fold<int>(0, (sum, s) => sum + s.totalCount);
    final totalDuration = list.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final sessionsCount = list.length;
    final avgDuration = sessionsCount > 0 ? totalDuration ~/ sessionsCount : 0;
    
    return ApiSuccess(TasbihSessionAnalyticsModel(
      overview: {
        'total_sessions': sessionsCount,
        'total_count': totalCount,
        'total_duration': totalDuration,
        'average_session_duration': avgDuration,
      },
      dailyTrends: [],
      hourlyPeaks: {for (var i = 0; i < 24; i++) i: 0},
      ratesDistribution: {'slow': 0, 'medium': 0, 'fast': 0},
    ));
  }
}
