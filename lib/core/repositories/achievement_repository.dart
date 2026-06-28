import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement_model.dart';
import '../network/api_client.dart';
import '../network/api_result.dart';

class AchievementRepository {
  final SharedPreferences _prefs;

  AchievementRepository(ApiClient apiClient, this._prefs);

  String _getLang() {
    return _prefs.getString('app_language_code') ?? 'ku';
  }

  /// Helper to load and build localized achievements with local progress.
  Future<List<Map<String, dynamic>>> _loadLocalAchievementsList() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/achievements.json');
      final categoriesList = jsonDecode(jsonString) as List;
      final lang = _getLang();

      final List<Map<String, dynamic>> flatAchievements = [];

      for (final catJson in categoriesList) {
        final catMap = catJson as Map<String, dynamic>;
        final catId = catMap['id'] as int;
        final catIcon = catMap['icon'] as String? ?? '🏆';
        final catTranslations = catMap['translations'] as Map<String, dynamic>? ?? {};
        final catName = catTranslations[lang] as String? ?? catTranslations['en'] as String? ?? 'Other';

        final achievementsList = catMap['achievements'] as List? ?? [];
        for (final achJson in achievementsList) {
          final achMap = achJson as Map<String, dynamic>;
          final key = achMap['key'] as String;
          final achId = achMap['id'] as int;
          final conditionType = achMap['condition_type'] as String;
          final conditionValue = achMap['condition_value'] as int;

          // Retrieve local progress and completion status
          final isCompleted = _prefs.getBool('achievement_completed_$key') ?? false;
          final progressValue = _prefs.getInt('achievement_progress_$key') ?? 0;
          final completedAtStr = _prefs.getString('achievement_completed_at_$key');

          final achTranslations = achMap['translations'] as Map<String, dynamic>? ?? {};
          final transObj = achTranslations[lang] as Map<String, dynamic>? ?? achTranslations['en'] as Map<String, dynamic>? ?? {};
          final name = transObj['name'] as String? ?? '';
          final description = transObj['description'] as String? ?? '';

          flatAchievements.add({
            'id': achId,
            'key': key,
            'name': name,
            'description': description,
            'icon': achMap['icon'] as String? ?? '🏆',
            'badge_image': achMap['badge_image'],
            'condition_type': conditionType,
            'condition_value': conditionValue,
            'reward_type': achMap['reward_type'] ?? 'POINTS',
            'reward_points': achMap['reward_points'] ?? 0,
            'reward_value': achMap['reward_value'],
            'version': achMap['version'] ?? 1,
            'is_hidden': achMap['is_hidden'] ?? false,
            'is_completed': isCompleted,
            'progress_value': progressValue,
            'completed_at': completedAtStr,
            'unlocked_version': achMap['unlocked_version'] ?? 1,
            'category': {
              'id': catId,
              'name': catName,
              'icon': catIcon,
            }
          });
        }
      }

      return flatAchievements;
    } catch (e) {
      return [];
    }
  }

  /// Fetch all achievements with user progress.
  Future<ApiResult<Map<String, dynamic>>> getAchievements() async {
    try {
      final achievements = await _loadLocalAchievementsList();
      final totalAvailable = achievements.length;
      final totalEarned = achievements.where((a) => a['is_completed'] == true).length;
      final completionPct = totalAvailable > 0 ? (totalEarned / totalAvailable) * 100.0 : 0.0;
      final rareEarned = achievements.where((a) => a['is_completed'] == true && (a['reward_points'] as int) >= 200).length;

      final summary = {
        'total_available': totalAvailable,
        'total_earned': totalEarned,
        'completion_pct': completionPct,
        'rare_earned': rareEarned,
      };

      return ApiSuccess({
        'achievements': achievements,
        'summary': summary,
      });
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch a single achievement detail.
  Future<ApiResult<AchievementModel>> getAchievement(int id) async {
    try {
      final achievements = await _loadLocalAchievementsList();
      final item = achievements.firstWhere((a) => a['id'] == id, orElse: () => throw Exception('Achievement not found'));
      return ApiSuccess(AchievementModel.fromJson(item));
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
      final achievements = await _loadLocalAchievementsList();
      final List<AchievementModel> newlyUnlocked = [];

      for (final a in achievements) {
        final key = a['key'] as String;
        final conditionType = a['condition_type'] as String;
        final conditionValue = a['condition_value'] as int;
        final wasCompleted = a['is_completed'] as bool;

        int currentVal = a['progress_value'] as int? ?? 0;

        if (conditionType == 'TOTAL_DHIKR' && totalDhikrCount != null) {
          currentVal = totalDhikrCount;
        } else if ((conditionType == 'CURRENT_STREAK' || conditionType == 'CONSECUTIVE_DAYS') && currentStreak != null) {
          currentVal = currentStreak;
        } else if (conditionType == 'GOALS_COMPLETED' && goalsCompleted != null) {
          currentVal = goalsCompleted;
        } else if (conditionType == 'SESSION_DHIKR_COUNT' && sessionDhikrCount != null) {
          currentVal = sessionDhikrCount;
        }

        // Only update progress if new value is greater
        if (currentVal > (a['progress_value'] as int)) {
          await _prefs.setInt('achievement_progress_$key', currentVal);
          a['progress_value'] = currentVal;
        }

        if (currentVal >= conditionValue && !wasCompleted) {
          await _prefs.setBool('achievement_completed_$key', true);
          final completedAtStr = DateTime.now().toIso8601String();
          await _prefs.setString('achievement_completed_at_$key', completedAtStr);

          a['is_completed'] = true;
          a['completed_at'] = completedAtStr;

          newlyUnlocked.add(AchievementModel.fromJson(a));
        }
      }

      return ApiSuccess(newlyUnlocked);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Get recently unlocked achievements (since a timestamp).
  Future<ApiResult<List<AchievementModel>>> getUnlocked({String? since}) async {
    try {
      final achievements = await _loadLocalAchievementsList();
      final unlocked = achievements.where((a) {
        if (a['is_completed'] != true) return false;
        if (since != null) {
          final completedAt = DateTime.tryParse(a['completed_at'] as String? ?? '');
          final sinceDate = DateTime.tryParse(since);
          if (completedAt != null && sinceDate != null) {
            return completedAt.isAfter(sinceDate);
          }
        }
        return true;
      }).map((item) => AchievementModel.fromJson(item)).toList();

      return ApiSuccess(unlocked);
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
