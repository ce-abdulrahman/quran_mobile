import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/models/surah_model.dart';
import '../../core/models/ayah_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Memorization Plan Item Model
// ─────────────────────────────────────────────────────────────────────────────

class MemorizationItemModel {
  final int id;
  final int memorizationPlanId;
  final int surahId;
  final int fromAyahId;
  final int toAyahId;
  final int dayNumber;
  final String? targetDate;
  final String status;
  final SurahModel? surah;
  final AyahModel? fromAyah;
  final AyahModel? toAyah;

  MemorizationItemModel({
    required this.id,
    required this.memorizationPlanId,
    required this.surahId,
    required this.fromAyahId,
    required this.toAyahId,
    required this.dayNumber,
    this.targetDate,
    required this.status,
    this.surah,
    this.fromAyah,
    this.toAyah,
  });

  factory MemorizationItemModel.fromJson(Map<String, dynamic> json) {
    return MemorizationItemModel(
      id: json['id'] as int? ?? 0,
      memorizationPlanId: json['memorization_plan_id'] as int? ?? 0,
      surahId: json['surah_id'] as int? ?? 0,
      fromAyahId: json['from_ayah_id'] as int? ?? 0,
      toAyahId: json['to_ayah_id'] as int? ?? 0,
      dayNumber: json['day_number'] as int? ?? 0,
      targetDate: json['target_date'] as String?,
      status: json['status'] as String? ?? 'pending',
      surah: json['surah'] != null ? SurahModel.fromJson(json['surah'] as Map<String, dynamic>) : null,
      fromAyah: json['from_ayah'] != null ? AyahModel.fromJson(json['from_ayah'] as Map<String, dynamic>) : null,
      toAyah: json['to_ayah'] != null ? AyahModel.fromJson(json['to_ayah'] as Map<String, dynamic>) : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User Ayah Progress Model
// ─────────────────────────────────────────────────────────────────────────────

class UserAyahProgressModel {
  final int id;
  final int userId;
  final int ayahId;
  final String memorizeStatus;
  final String? lastMemorizedAt;
  final String? lastReviewedAt;
  final String? nextReviewDate;
  final int reviewCount;
  final int currentIntervalDays;
  final String masteryLevel;
  final String? lastReviewResult;
  final int strengthScore;
  final int mistakesCount;
  final String? notes;
  final AyahModel? ayah;

  UserAyahProgressModel({
    required this.id,
    required this.userId,
    required this.ayahId,
    required this.memorizeStatus,
    this.lastMemorizedAt,
    this.lastReviewedAt,
    this.nextReviewDate,
    required this.reviewCount,
    required this.currentIntervalDays,
    required this.masteryLevel,
    this.lastReviewResult,
    required this.strengthScore,
    required this.mistakesCount,
    this.notes,
    this.ayah,
  });

  factory UserAyahProgressModel.fromJson(Map<String, dynamic> json) {
    return UserAyahProgressModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      ayahId: json['ayah_id'] as int? ?? 0,
      memorizeStatus: json['memorize_status'] as String? ?? 'not_started',
      lastMemorizedAt: json['last_memorized_at'] as String?,
      lastReviewedAt: json['last_reviewed_at'] as String?,
      nextReviewDate: json['next_review_date'] as String?,
      reviewCount: json['review_count'] as int? ?? 0,
      currentIntervalDays: json['current_interval_days'] as int? ?? 0,
      masteryLevel: json['mastery_level'] as String? ?? 'not_started',
      lastReviewResult: json['last_review_result'] as String?,
      strengthScore: json['strength_score'] as int? ?? 0,
      mistakesCount: json['mistakes_count'] as int? ?? 0,
      notes: json['notes'] as String?,
      ayah: json['ayah'] != null ? AyahModel.fromJson(json['ayah'] as Map<String, dynamic>) : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Memorization Repository
// ─────────────────────────────────────────────────────────────────────────────

class MemorizationRepository {
  final ApiClient _client;
  MemorizationRepository(this._client);

  Future<List<MemorizationItemModel>> getTodayPlans() async {
    try {
      final response = await _client.get(ApiConstants.memorizationPlansToday);
      final responseData = response.data;
      if (responseData is Map && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List?;
        if (rawList != null) {
          return rawList.map((e) => MemorizationItemModel.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
    } catch (e) {
      debugPrint('Error fetching today memorization plans: $e');
    }
    return [];
  }

  Future<UserAyahProgressModel?> saveReview({
    required int ayahId,
    required String reviewLevel,
    required String result,
    String? notes,
  }) async {
    try {
      final response = await _client.post(
        ApiConstants.memorizationReviews,
        data: {
          'ayah_id': ayahId,
          'review_date': DateTime.now().toIso8601String().substring(0, 10),
          'review_level': reviewLevel,
          'result': result,
          'notes': notes,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final progressData = responseData['data']['progress'];
          if (progressData != null) {
            return UserAyahProgressModel.fromJson(progressData as Map<String, dynamic>);
          }
        }
      }
    } catch (e) {
      debugPrint('Error saving memorization review: $e');
    }
    return null;
  }

  Future<bool> updateItemStatus(int planId, int itemId, String status) async {
    try {
      final response = await _client.put(
        '/memorization-plans/$planId/items/$itemId/status',
        data: {'status': status},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating item status: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDashboard() async {
    try {
      final response = await _client.get(ApiConstants.dashboardStats);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          return responseData['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('Error getting memorization dashboard: $e');
    }
    return null;
  }

  Future<List<UserAyahProgressModel>> getDueReviews() async {
    try {
      final response = await _client.get(ApiConstants.dueReviews);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final rawList = responseData['data']['data'] as List?;
          if (rawList != null) {
            return rawList.map((e) => UserAyahProgressModel.fromJson(e as Map<String, dynamic>)).toList();
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting due reviews: $e');
    }
    return [];
  }

  Future<List<UserAyahProgressModel>> getWeakAyahs() async {
    try {
      final response = await _client.get(ApiConstants.weakReviews);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final rawList = responseData['data']['data'] as List?;
          if (rawList != null) {
            return rawList.map((e) => UserAyahProgressModel.fromJson(e as Map<String, dynamic>)).toList();
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting weak ayahs: $e');
    }
    return [];
  }

  Future<List<UserAyahProgressModel>> getLearningAyahs() async {
    try {
      final response = await _client.get(ApiConstants.learningReviews);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final rawList = responseData['data']['data'] as List?;
          if (rawList != null) {
            return rawList.map((e) => UserAyahProgressModel.fromJson(e as Map<String, dynamic>)).toList();
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting learning ayahs: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>?> getFullStatistics() async {
    try {
      final response = await _client.get(ApiConstants.statsFull);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          return responseData['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('Error getting full stats: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDetailedProgress() async {
    try {
      final response = await _client.get(ApiConstants.progressDetailed);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          return responseData['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('Error getting detailed progress: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getForecast() async {
    try {
      final response = await _client.get(ApiConstants.forecastDetailed);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          return responseData['data'] as Map<String, dynamic>?;
        }
      }
    } catch (e) {
      debugPrint('Error getting forecast: $e');
    }
    return null;
  }

  Future<bool> logSession({
    required String sessionType,
    required String status,
    required DateTime startedAt,
    DateTime? endedAt,
    DateTime? completedAt,
    required int durationSeconds,
    required int ayahsReviewed,
    required int ayahsMemorized,
    required int score,
  }) async {
    try {
      final response = await _client.post(
        ApiConstants.sessionLog,
        data: {
          'session_type': sessionType,
          'status': status,
          'started_at': startedAt.toIso8601String(),
          'ended_at': endedAt?.toIso8601String(),
          'completed_at': completedAt?.toIso8601String(),
          'duration_seconds': durationSeconds,
          'ayahs_reviewed': ayahsReviewed,
          'ayahs_memorized': ayahsMemorized,
          'score': score,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error logging session: $e');
      return false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final memorizationRepositoryProvider = Provider<MemorizationRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return MemorizationRepository(client);
});

final memorizationTodayProvider = FutureProvider<List<MemorizationItemModel>>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getTodayPlans();
});

final memorizationDashboardProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getDashboard();
});

final dueReviewsProvider = FutureProvider.autoDispose<List<UserAyahProgressModel>>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getDueReviews();
});

final weakAyahsProvider = FutureProvider.autoDispose<List<UserAyahProgressModel>>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getWeakAyahs();
});

final learningAyahsProvider = FutureProvider.autoDispose<List<UserAyahProgressModel>>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getLearningAyahs();
});

final memorizationStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getFullStatistics();
});

final memorizationForecastProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getForecast();
});

final detailedProgressProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final repo = ref.watch(memorizationRepositoryProvider);
  return repo.getDetailedProgress();
});
