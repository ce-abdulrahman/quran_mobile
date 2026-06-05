import '../cache/cache_manager.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';
import '../models/tajweed_rule_model.dart';

class TajweedRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  TajweedRepository(this._apiClient, this._cacheManager);

  /// Fetch all active Tajweed rules. Uses Cache-First strategy.
  Future<ApiResult<List<TajweedRuleModel>>> getTajweedRules({bool forceRefresh = false}) async {
    const cacheKey = 'cache_tajweed_rules';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        try {
          final cachedList = cachedJson.map((e) => TajweedRuleModel.fromJson(e as Map<String, dynamic>)).toList();
          return ApiSuccess(cachedList);
        } catch (_) {
          // If JSON format changed, fallback to network
        }
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.tajweedRules);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final rules = rawList.map((e) => TajweedRuleModel.fromJson(e as Map<String, dynamic>)).toList();

        // Cache it for 12 hours
        await _cacheManager.set(cacheKey, rawList, const Duration(hours: 12));
        return ApiSuccess(rules);
      } else {
        return const ApiError('هەڵەیەک لە داڕشتەی ئەحکامەکانی تەجویددا هەیە');
      }
    } on ApiException catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<TajweedRuleModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        try {
          cachedList = cachedJson.map((e) => TajweedRuleModel.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedList);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<TajweedRuleModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        try {
          cachedList = cachedJson.map((e) => TajweedRuleModel.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
      return ApiError(e.toString(), cachedData: cachedList);
    }
  }
}
