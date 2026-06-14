import '../models/fingerprint_settings_model.dart';
import '../models/fingerprint_statistics_model.dart';
import '../network/api_client.dart';
import '../network/api_result.dart';

class FingerprintRepository {
  final ApiClient _apiClient;

  FingerprintRepository(this._apiClient);

  Future<ApiResult<FingerprintSettingsModel>> getSettings() async {
    try {
      final response = await _apiClient.get('v1/fingerprint/settings');
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(FingerprintSettingsModel.fromJson(data['data'] as Map<String, dynamic>));
      }
      return const ApiError('Failed to load settings');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  Future<ApiResult<FingerprintSettingsModel>> saveSettings(FingerprintSettingsModel settings) async {
    try {
      final response = await _apiClient.post(
        'v1/fingerprint/settings',
        data: settings.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(FingerprintSettingsModel.fromJson(data['data'] as Map<String, dynamic>));
      }
      return const ApiError('Failed to save settings');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  Future<ApiResult<FingerprintStatisticsModel>> getStatistics() async {
    try {
      final response = await _apiClient.get('v1/fingerprint/statistics');
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(FingerprintStatisticsModel.fromJson(data['data'] as Map<String, dynamic>));
      }
      return const ApiError('Failed to load statistics');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  Future<ApiResult<Map<String, dynamic>>> syncSession({
    required int? dhikrId,
    required String? customDhikrName,
    required DateTime startTime,
    required DateTime endTime,
    required int durationSeconds,
    required int totalCount,
    required bool isBlind,
    required bool isFocus,
    required String countMode,
  }) async {
    try {
      final response = await _apiClient.post(
        'v1/fingerprint/session',
        data: {
          'dhikr_id': dhikrId,
          'custom_dhikr_name': customDhikrName,
          'start_time': startTime.toUtc().toIso8601String(),
          'end_time': endTime.toUtc().toIso8601String(),
          'duration_seconds': durationSeconds,
          'total_count': totalCount,
          'is_blind': isBlind,
          'is_focus': isFocus,
          'count_mode': countMode,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(Map<String, dynamic>.from(data));
      }
      return const ApiError('Failed to sync fingerprint session');
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
