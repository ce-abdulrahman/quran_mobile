import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../core/providers/app_providers.dart';
import '../../core/models/surah_model.dart';
import '../../core/models/ayah_model.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/providers/auth_provider.dart';

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
  final Ref _ref;
  final ApiClient _client;
  MemorizationRepository(this._ref, this._client);

  Isar get _isar => IsarService.instance.isar;
  bool get _isAuthenticated => _ref.read(authProvider).isAuthenticated;

  Future<List<MemorizationItemModel>> getTodayPlans() async {
    if (_isAuthenticated) {
      try {
        final response = await _client.get(ApiConstants.memorizationPlansToday);
        final responseData = response.data;
        if (responseData is Map && responseData['status'] == 'success') {
          final rawList = responseData['data'] as List?;
          if (rawList != null) {
            final plans = rawList.map((e) => MemorizationItemModel.fromJson(e as Map<String, dynamic>)).toList();
            await _cachePlans(plans);
            return plans;
          }
        }
      } catch (e) {
        debugPrint('Error fetching today memorization plans from API: $e');
      }
    }

    final localPlans = await _isar.memorizationPlanCollections.where().findAll();
    final items = <MemorizationItemModel>[];
    for (final plan in localPlans) {
      final surah = await _isar.surahCollections.filter().numberEqualTo(plan.surahId).findFirst();
      final fromAyah = await _isar.ayahCollections.filter()
          .surahNumberEqualTo(plan.surahId)
          .ayahNumberEqualTo(plan.fromAyah)
          .findFirst();
      final toAyah = await _isar.ayahCollections.filter()
          .surahNumberEqualTo(plan.surahId)
          .ayahNumberEqualTo(plan.toAyah)
          .findFirst();

      items.add(MemorizationItemModel(
        id: plan.id,
        memorizationPlanId: plan.id,
        surahId: plan.surahId,
        fromAyahId: plan.fromAyah,
        toAyahId: plan.toAyah,
        dayNumber: 1,
        status: plan.status,
        surah: surah != null ? SurahModel(
          id: surah.number,
          number: surah.number,
          nameAr: surah.nameAr,
          nameEn: surah.nameEn,
          nameKu: surah.nameKu,
          totalAyahs: surah.totalAyahs,
          revelationType: surah.revelationType,
        ) : null,
        fromAyah: fromAyah != null ? AyahModel(
          id: fromAyah.ayahId,
          ayahNumber: fromAyah.ayahNumber,
          textUthmani: fromAyah.textUthmani,
          textKu: fromAyah.textKu,
          textEn: fromAyah.textEn,
        ) : null,
        toAyah: toAyah != null ? AyahModel(
          id: toAyah.ayahId,
          ayahNumber: toAyah.ayahNumber,
          textUthmani: toAyah.textUthmani,
          textKu: toAyah.textKu,
          textEn: toAyah.textEn,
        ) : null,
      ));
    }
    return items;
  }

  Future<void> _cachePlans(List<MemorizationItemModel> plans) async {
    await _isar.writeTxn(() async {
      for (final plan in plans) {
        final existing = await _isar.memorizationPlanCollections.filter()
            .planIdEqualTo(plan.memorizationPlanId.toString())
            .findFirst();
        final item = MemorizationPlanCollection(
          planId: plan.memorizationPlanId.toString(),
          surahId: plan.surahId,
          fromAyah: plan.fromAyahId,
          toAyah: plan.toAyahId,
          status: plan.status,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: true,
        );
        if (existing != null) {
          item.id = existing.id;
        }
        await _isar.memorizationPlanCollections.put(item);
      }
    });
  }

  Future<UserAyahProgressModel?> saveReview({
    required int ayahId,
    required String reviewLevel,
    required String result,
    String? notes,
  }) async {
    if (_isAuthenticated) {
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
        debugPrint('Error saving review to API: $e');
      }
    }

    final reviewId = DateTime.now().millisecondsSinceEpoch.toString();
    final review = MemorizationReviewCollection(
      reviewId: reviewId,
      planId: 'local',
      reviewedAt: DateTime.now(),
      performance: result,
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await _isar.writeTxn(() async {
      await _isar.memorizationReviewCollections.put(review);
    });

    final ayah = await _isar.ayahCollections.filter().ayahIdEqualTo(ayahId).findFirst();

    return UserAyahProgressModel(
      id: review.id,
      userId: 0,
      ayahId: ayahId,
      memorizeStatus: 'memorized',
      lastReviewedAt: DateTime.now().toIso8601String(),
      reviewCount: 1,
      currentIntervalDays: 1,
      masteryLevel: reviewLevel,
      strengthScore: 100,
      mistakesCount: 0,
      ayah: ayah != null ? AyahModel(
        id: ayah.ayahId,
        ayahNumber: ayah.ayahNumber,
        textUthmani: ayah.textUthmani,
        textKu: ayah.textKu,
        textEn: ayah.textEn,
      ) : null,
    );
  }

  Future<bool> updateItemStatus(int planId, int itemId, String status) async {
    if (_isAuthenticated) {
      try {
        final response = await _client.put(
          '/memorization-plans/$planId/items/$itemId/status',
          data: {'status': status},
        );
        if (response.statusCode == 200) {
          return true;
        }
      } catch (e) {
        debugPrint('Error updating item status to API: $e');
      }
    }

    final plan = await _isar.memorizationPlanCollections.filter().idEqualTo(planId).findFirst();
    if (plan != null) {
      plan.status = status;
      plan.updatedAt = DateTime.now();
      plan.isSynced = false;
      await _isar.writeTxn(() async {
        await _isar.memorizationPlanCollections.put(plan);
      });
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getDashboard() async {
    if (_isAuthenticated) {
      try {
        final response = await _client.get(ApiConstants.dashboardStats);
        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData is Map && responseData['status'] == 'success') {
            return responseData['data'] as Map<String, dynamic>?;
          }
        }
      } catch (e) {
        debugPrint('Error getting memorization dashboard from API: $e');
      }
    }

    final plans = await _isar.memorizationPlanCollections.where().findAll();
    int memorizedCount = 0;
    int learningCount = 0;
    for (final p in plans) {
      final rangeCount = p.toAyah - p.fromAyah + 1;
      if (p.status == 'memorized') {
        memorizedCount += rangeCount;
      } else if (p.status == 'learning') {
        learningCount += rangeCount;
      }
    }

    final reviews = await _isar.memorizationReviewCollections.where().findAll();
    final weakCount = reviews.where((r) => r.performance == 'hard' || r.performance == 'weak').length;
    final dueCount = reviews.where((r) => r.reviewedAt.day != DateTime.now().day).length;

    return {
      'total_memorized': memorizedCount,
      'total_learning': learningCount,
      'streak_days': 0,
      'due_reviews_count': dueCount,
      'weak_ayahs_count': weakCount,
      'remaining_days': (6236 - memorizedCount) ~/ 5 + 1,
      'estimated_completion_date': DateTime.now().add(Duration(days: (6236 - memorizedCount) ~/ 5 + 1)).toIso8601String().substring(0, 10),
    };
  }

  Future<List<UserAyahProgressModel>> getDueReviews() async {
    if (_isAuthenticated) {
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
        debugPrint('Error getting due reviews from API: $e');
      }
    }

    final plans = await _isar.memorizationPlanCollections.filter().statusEqualTo('learning').findAll();
    final list = <UserAyahProgressModel>[];
    for (final plan in plans) {
      final ayahs = await _isar.ayahCollections.filter()
          .surahNumberEqualTo(plan.surahId)
          .ayahNumberGreaterThan(plan.fromAyah - 1)
          .and()
          .ayahNumberLessThan(plan.toAyah + 1)
          .findAll();

      for (final ayah in ayahs) {
        list.add(UserAyahProgressModel(
          id: ayah.id,
          userId: 0,
          ayahId: ayah.ayahId,
          memorizeStatus: 'learning',
          reviewCount: 0,
          currentIntervalDays: 1,
          masteryLevel: 'medium',
          strengthScore: 70,
          mistakesCount: 0,
          ayah: AyahModel(
            id: ayah.ayahId,
            ayahNumber: ayah.ayahNumber,
            textUthmani: ayah.textUthmani,
            textKu: ayah.textKu,
            textEn: ayah.textEn,
          ),
        ));
      }
    }
    return list;
  }

  Future<List<UserAyahProgressModel>> getWeakAyahs() async {
    if (_isAuthenticated) {
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
        debugPrint('Error getting weak ayahs from API: $e');
      }
    }

    final weakReviews = await _isar.memorizationReviewCollections.filter().performanceEqualTo('hard').findAll();
    final list = <UserAyahProgressModel>[];
    for (final review in weakReviews) {
      list.add(UserAyahProgressModel(
        id: review.id,
        userId: 0,
        ayahId: 1,
        memorizeStatus: 'learning',
        reviewCount: 1,
        currentIntervalDays: 1,
        masteryLevel: 'weak',
        strengthScore: 40,
        mistakesCount: 2,
      ));
    }
    return list;
  }

  Future<List<UserAyahProgressModel>> getLearningAyahs() async {
    if (_isAuthenticated) {
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
        debugPrint('Error getting learning ayahs from API: $e');
      }
    }

    return getDueReviews();
  }

  Future<Map<String, dynamic>?> getFullStatistics() async {
    if (_isAuthenticated) {
      try {
        final response = await _client.get(ApiConstants.statsFull);
        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData is Map && responseData['status'] == 'success') {
            return responseData['data'] as Map<String, dynamic>?;
          }
        }
      } catch (e) {
        debugPrint('Error getting full stats from API: $e');
      }
    }
    return getDashboard();
  }

  Future<Map<String, dynamic>?> getDetailedProgress() async {
    if (_isAuthenticated) {
      try {
        final response = await _client.get(ApiConstants.progressDetailed);
        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData is Map && responseData['status'] == 'success') {
            return responseData['data'] as Map<String, dynamic>?;
          }
        }
      } catch (e) {
        debugPrint('Error getting detailed progress from API: $e');
      }
    }
    return getDashboard();
  }

  Future<Map<String, dynamic>?> getForecast() async {
    if (_isAuthenticated) {
      try {
        final response = await _client.get(ApiConstants.forecastDetailed);
        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData is Map && responseData['status'] == 'success') {
            return responseData['data'] as Map<String, dynamic>?;
          }
        }
      } catch (e) {
        debugPrint('Error getting forecast from API: $e');
      }
    }
    return getDashboard();
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
    if (_isAuthenticated) {
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
        debugPrint('Error logging session to API: $e');
      }
    }
    return true;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final memorizationRepositoryProvider = Provider<MemorizationRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return MemorizationRepository(ref, client);
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
