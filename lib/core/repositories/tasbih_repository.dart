import '../cache/cache_manager.dart';
import '../models/tasbih_model.dart';
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
        return const ApiError('هەڵەیەک لە داڕشتەی تەسبیحەکاندا هەیە');
      }
    } on ApiException catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<TasbihModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        try {
          cachedList = cachedJson.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedList);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<TasbihModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        try {
          cachedList = cachedJson.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
      return ApiError(e.toString(), cachedData: cachedList);
    }
  }
}
