import 'dart:convert';
import 'package:flutter/services.dart';
import '../cache/cache_manager.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';
import '../providers/adhkar_provider.dart';

class AdhkarRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  AdhkarRepository(this._apiClient, this._cacheManager);

  /// Fetch all active Adhkars grouped by Category. Uses Cache-First strategy.
  Future<ApiResult<List<AdhkarCategory>>> getAdhkars({bool forceRefresh = false}) async {
    const cacheKey = 'cache_adhkars';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        try {
          final cachedList = cachedJson.map((e) => AdhkarCategory.fromJson(e as Map<String, dynamic>)).toList();
          return ApiSuccess(cachedList);
        } catch (_) {
          // If JSON format changed, proceed to fetch from network
        }
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.adhkars);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final categories = rawList.map((e) => AdhkarCategory.fromJson(e as Map<String, dynamic>)).toList();

        // Cache it
        await _cacheManager.set(cacheKey, rawList, const Duration(hours: 12));
        return ApiSuccess(categories);
      } else {
        return _fallbackToLocalAssets(cacheKey, 'هەڵەیەک لە داڕشتەی ئەزکارەکاندا هەیە');
      }
    } catch (e) {
      return _fallbackToLocalAssets(cacheKey, e.toString());
    }
  }

  Future<ApiResult<List<AdhkarCategory>>> _fallbackToLocalAssets(String cacheKey, String errorMsg) async {
    // 1. Try local CacheManager cache first
    final cachedJson = _cacheManager.get(cacheKey);
    if (cachedJson != null && cachedJson is List) {
      try {
        final cachedList = cachedJson.map((e) => AdhkarCategory.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(cachedList);
      } catch (_) {}
    }

    // 2. Fallback to hardcoded assets/data/adhkars.json
    try {
      final jsonString = await rootBundle.loadString('assets/data/adhkars.json');
      final rawList = jsonDecode(jsonString) as List;
      final categories = rawList.map((e) => AdhkarCategory.fromJson(e as Map<String, dynamic>)).toList();
      return ApiSuccess(categories);
    } catch (e) {
      return ApiError('$errorMsg | فایلی ناوخۆیی بار نەکرا: $e');
    }
  }
}

