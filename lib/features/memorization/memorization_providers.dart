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

  Future<bool> saveReview({
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
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('Error saving memorization review: $e');
      return false;
    }
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
