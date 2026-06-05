import '../cache/cache_manager.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';
import '../providers/hadith_provider.dart';

class HadithRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  HadithRepository(this._apiClient, this._cacheManager);

  /// Fetch all active Hadith categories eager-loaded with items. Uses Cache-First strategy.
  Future<ApiResult<List<HadithCategory>>> getHadiths({bool forceRefresh = false}) async {
    const cacheKey = 'cache_hadiths';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        try {
          final cachedList = cachedJson.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>)).toList();
          return ApiSuccess(cachedList);
        } catch (_) {
          // If JSON format changed, fallback to network
        }
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.hadiths);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final categories = rawList.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>)).toList();

        // Cache it for 12 hours
        await _cacheManager.set(cacheKey, rawList, const Duration(hours: 12));
        return ApiSuccess(categories);
      } else {
        return const ApiError('هەڵەیەک لە داڕشتەی فەرموودەکاندا هەیە');
      }
    } on ApiException catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<HadithCategory>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        try {
          cachedList = cachedJson.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedList);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<HadithCategory>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        try {
          cachedList = cachedJson.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
      return ApiError(e.toString(), cachedData: cachedList);
    }
  }
}
