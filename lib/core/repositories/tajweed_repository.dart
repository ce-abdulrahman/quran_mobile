import 'dart:convert';
import 'package:flutter/services.dart';
import '../cache/cache_manager.dart';
import '../network/api_client.dart';
import '../network/api_result.dart';
import '../network/api_constants.dart';
import '../models/tajweed_rule_model.dart';
import '../models/tajweed_category_model.dart';

class TajweedRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  TajweedRepository(this._apiClient, this._cacheManager);

  /// Fetch all active Tajweed rules.
  Future<ApiResult<List<TajweedRuleModel>>> getTajweedRules({bool forceRefresh = false}) async {
    final catResult = await getTajweedCategories(forceRefresh: forceRefresh);
    return catResult.when(
      success: (categories) {
        final rules = categories.expand((cat) => cat.rules).toList();
        return ApiSuccess(rules);
      },
      error: (msg, code, cached) {
        if (cached != null) {
          final rules = cached.expand((cat) => cat.rules).toList();
          return ApiError(msg, statusCode: code, cachedData: rules);
        }
        return ApiError(msg, statusCode: code);
      },
    );
  }

  /// Fetch all active Tajweed categories (with nested rules). Loads from Laravel API with offline fallback.
  Future<ApiResult<List<TajweedCategoryModel>>> getTajweedCategories({bool forceRefresh = false}) async {
    const cacheKey = 'cache_tajweed_categories';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        try {
          final categories = cachedJson.map((e) => TajweedCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
          return ApiSuccess(categories);
        } catch (_) {}
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.tajweedCategories);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final categories = rawList.map((e) => TajweedCategoryModel.fromJson(e as Map<String, dynamic>)).toList();

        // Cache it for future offline usage (7 days)
        await _cacheManager.set(cacheKey, rawList, const Duration(days: 7));
        return ApiSuccess(categories);
      } else {
        return _fallbackToLocalAssets(cacheKey, 'سەرکەوتوو نەبوو لە وەرگرتنی داتا لە ڕاژەکار');
      }
    } catch (e) {
      return _fallbackToLocalAssets(cacheKey, e.toString());
    }
  }

  Future<ApiResult<List<TajweedCategoryModel>>> _fallbackToLocalAssets(String cacheKey, String errorMsg) async {
    // 1. Try local CacheManager cache first
    final cachedJson = _cacheManager.get(cacheKey);
    if (cachedJson != null && cachedJson is List) {
      try {
        final categories = cachedJson.map((e) => TajweedCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(categories);
      } catch (_) {}
    }

    // 2. Fallback to hardcoded assets/data/tajweed_rules.json
    try {
      final jsonString = await rootBundle.loadString('assets/data/tajweed_rules.json');
      final rawList = jsonDecode(jsonString) as List;
      final categories = rawList.map((e) => TajweedCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      return ApiSuccess(categories);
    } catch (e) {
      return ApiError('$errorMsg | فایلی ناوخۆیی بار نەکرا: $e');
    }
  }
}
