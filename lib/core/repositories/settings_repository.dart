import '../cache/cache_manager.dart';
import '../models/app_settings_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class SettingsRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  SettingsRepository(this._apiClient, this._cacheManager);

  /// Fetch App Settings. Uses Cache-First strategy.
  Future<ApiResult<AppSettingsModel>> getSettings({bool forceRefresh = false}) async {
    const cacheKey = 'cache_settings';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is Map<String, dynamic>) {
        return ApiSuccess(AppSettingsModel.fromJson(cachedJson));
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.settings);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawMap = responseData['data'] as Map<String, dynamic>;
        final settings = AppSettingsModel.fromJson(rawMap);
        
        // Cache it
        await _cacheManager.set(cacheKey, rawMap, ApiConstants.settingsTtl);
        return ApiSuccess(settings);
      } else {
        return const ApiError('هەڵەیەک لە داڕشتەی ڕێکخستنەکاندا هەیە');
      }
    } on ApiException catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      AppSettingsModel? cachedSettings;
      if (cachedJson != null && cachedJson is Map<String, dynamic>) {
        cachedSettings = AppSettingsModel.fromJson(cachedJson);
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedSettings);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      AppSettingsModel? cachedSettings;
      if (cachedJson != null && cachedJson is Map<String, dynamic>) {
        cachedSettings = AppSettingsModel.fromJson(cachedJson);
      }
      return ApiError(e.toString(), cachedData: cachedSettings);
    }
  }
}
