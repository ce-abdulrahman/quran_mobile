import '../models/leaderboard_model.dart';
import '../models/leaderboard_settings_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class LeaderboardRepository {
  final ApiClient _apiClient;

  LeaderboardRepository(this._apiClient);

  /// Fetch rankings for a specific type and filters.
  Future<ApiResult<Map<String, dynamic>>> getLeaderboard({
    required String type,
    int page = 1,
    String? country,
    String? province,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'type': type,
        'page': page,
      };
      if (country != null) queryParams['country'] = country;
      if (province != null) queryParams['province'] = province;

      final response = await _apiClient.get(
        ApiConstants.leaderboard,
        queryParameters: queryParams,
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        final rawList = (data['data']['rankings'] as List?) ?? [];
        final rankings = rawList
            .map((e) => LeaderboardModel.fromJson(e as Map<String, dynamic>))
            .toList();

        final rawMe = data['data']['current_user_rank'];
        final meDetails = rawMe != null ? Map<String, dynamic>.from(rawMe as Map) : null;

        final pagination = data['data']['pagination'] as Map<String, dynamic>? ?? {};

        return ApiSuccess({
          'rankings': rankings,
          'current_user_rank': meDetails,
          'pagination': pagination,
        });
      }
      return const ApiError('هەڵەیەک ڕوویدا لە بارکردنی ڕیزبەندییەکان');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get authenticated user's rank details.
  Future<ApiResult<Map<String, dynamic>>> getMeDetails(String type) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.leaderboardMe,
        queryParameters: {'type': type},
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(data['data'] as Map<String, dynamic>);
      }
      return const ApiError('هەڵەیەک ڕوویدا لە بارکردنی زانیارییەکانی تۆ');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get top 3 users.
  Future<ApiResult<List<LeaderboardModel>>> getTop(String type) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.leaderboardTop,
        queryParameters: {'type': type},
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        final rawList = (data['data'] as List?) ?? [];
        final top = rawList
            .map((e) => LeaderboardModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiSuccess(top);
      }
      return const ApiSuccess([]);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Update privacy settings.
  Future<ApiResult<LeaderboardSettingsModel>> updatePrivacy(
    LeaderboardSettingsModel settings,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.leaderboardPrivacy,
        data: settings.toJson(),
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(
          LeaderboardSettingsModel.fromJson(data['data'] as Map<String, dynamic>),
        );
      }
      return const ApiError('هەڵەیەک ڕوویدا لە نوێکردنەوەی ڕێکخستنەکان');
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
