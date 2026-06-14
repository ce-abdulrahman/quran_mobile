import '../models/achievement_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class AchievementRepository {
  final ApiClient _apiClient;

  AchievementRepository(this._apiClient);

  /// Fetch all achievements with user progress.
  Future<ApiResult<Map<String, dynamic>>> getAchievements() async {
    try {
      final response = await _apiClient.get(ApiConstants.achievements);
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(data['data'] as Map<String, dynamic>);
      }
      return const ApiError('هەڵەیەک ڕوویدا لە بارکردنی دەستکەوتەکان');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch a single achievement detail.
  Future<ApiResult<AchievementModel>> getAchievement(int id) async {
    try {
      final response = await _apiClient.get(ApiConstants.achievement(id));
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        return ApiSuccess(AchievementModel.fromJson(data['data'] as Map<String, dynamic>));
      }
      return const ApiError('دەستکەوتە نەدۆزرایەوە');
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Sync achievement progress with unified payload.
  /// Returns list of newly unlocked achievements.
  Future<ApiResult<List<AchievementModel>>> sync({
    int? totalDhikrCount,
    int? currentStreak,
    int? goalsCompleted,
    int? sessionDhikrCount,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (totalDhikrCount != null) payload['total_dhikr_count'] = totalDhikrCount;
      if (currentStreak != null) payload['current_streak'] = currentStreak;
      if (goalsCompleted != null) payload['goals_completed'] = goalsCompleted;
      if (sessionDhikrCount != null) payload['session_dhikr_count'] = sessionDhikrCount;

      final response = await _apiClient.post(ApiConstants.achievementsSync, data: payload);
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        final rawList = (data['newly_unlocked'] as List?) ?? [];
        final achievements = rawList
            .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiSuccess(achievements);
      }
      return const ApiSuccess([]);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get recently unlocked achievements (since a timestamp).
  Future<ApiResult<List<AchievementModel>>> getUnlocked({String? since}) async {
    try {
      final queryParams = since != null ? {'since': since} : <String, dynamic>{};
      final response = await _apiClient.get(
        ApiConstants.achievementsUnlocked,
        queryParameters: queryParams,
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['status'] == 'success') {
        final rawList = (data['data'] as List?) ?? [];
        final achievements = rawList
            .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiSuccess(achievements);
      }
      return const ApiSuccess([]);
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
