import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../models/statistics_model.dart';

/// Hive box name for statistics cache — avoids SharedPreferences for large payloads.
const _kStatsBox = 'statistics_cache';

class StatisticsRepository {
  final ApiClient _api;

  StatisticsRepository(this._api);

  // ── Hive helpers ──────────────────────────────────────────────────────────

  Future<Box> _box() async {
    if (!Hive.isBoxOpen(_kStatsBox)) {
      return await Hive.openBox(_kStatsBox);
    }
    return Hive.box(_kStatsBox);
  }

  Future<void> _cacheJson(String key, Map<String, dynamic> data) async {
    final box = await _box();
    await box.put(key, jsonEncode(data));
    await box.put('${key}_ts', DateTime.now().toIso8601String());
  }

  Map<String, dynamic>? _readJson(String key, Box box) {
    final raw = box.get(key) as String?;
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  bool _isFresh(String key, Box box, {Duration ttl = const Duration(hours: 6)}) {
    final ts = box.get('${key}_ts') as String?;
    if (ts == null) return false;
    return DateTime.now().difference(DateTime.parse(ts)) < ttl;
  }

  // ── Dashboard ─────────────────────────────────────────────────────────────

  Future<StatisticsDashboard> getDashboard({bool forceRefresh = false}) async {
    const cacheKey = 'dashboard';
    final box = await _box();

    if (!forceRefresh && _isFresh(cacheKey, box)) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return StatisticsDashboard.fromJson(cached);
    }

    try {
      final resp = await _api.get(ApiConstants.statsDashboard);
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      await _cacheJson(cacheKey, data);
      return StatisticsDashboard.fromJson(data);
    } catch (_) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return StatisticsDashboard.fromJson(cached);
      return StatisticsDashboard.empty();
    }
  }

  // ── Dhikr Analytics ───────────────────────────────────────────────────────

  Future<DhikrAnalytics> getDhikrAnalytics(String period) async {
    final cacheKey = 'dhikr_$period';
    final box = await _box();

    if (_isFresh(cacheKey, box, ttl: const Duration(hours: 1))) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return DhikrAnalytics.fromJson(cached);
    }

    try {
      final resp = await _api.get(ApiConstants.statsDhikr, queryParameters: {'period': period});
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      await _cacheJson(cacheKey, data);
      return DhikrAnalytics.fromJson(data);
    } catch (_) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return DhikrAnalytics.fromJson(cached);
      return DhikrAnalytics.empty();
    }
  }

  // ── Session Analytics ─────────────────────────────────────────────────────

  Future<SessionAnalytics> getSessionAnalytics(String period) async {
    final cacheKey = 'sessions_$period';
    final box = await _box();

    if (_isFresh(cacheKey, box, ttl: const Duration(hours: 2))) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return SessionAnalytics.fromJson(cached);
    }

    try {
      final resp = await _api.get(ApiConstants.statsSessions, queryParameters: {'period': period});
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      await _cacheJson(cacheKey, data);
      return SessionAnalytics.fromJson(data);
    } catch (_) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return SessionAnalytics.fromJson(cached);
      return SessionAnalytics.empty();
    }
  }

  // ── Streak Analytics ──────────────────────────────────────────────────────

  Future<StreakAnalytics> getStreakAnalytics(String period) async {
    final cacheKey = 'streaks_$period';
    final box = await _box();

    if (_isFresh(cacheKey, box, ttl: const Duration(hours: 2))) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return StreakAnalytics.fromJson(cached);
    }

    try {
      final resp = await _api.get(ApiConstants.statsStreaks, queryParameters: {'period': period});
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      await _cacheJson(cacheKey, data);
      return StreakAnalytics.fromJson(data);
    } catch (_) {
      final cached = _readJson(cacheKey, box);
      if (cached != null) return StreakAnalytics.fromJson(cached);
      return StreakAnalytics.empty();
    }
  }

  // ── Insights ──────────────────────────────────────────────────────────────

  Future<List<InsightModel>> getInsights() async {
    const cacheKey = 'insights';
    final box = await _box();

    if (_isFresh(cacheKey, box, ttl: const Duration(hours: 6))) {
      final cached = box.get(cacheKey) as String?;
      if (cached != null) {
        final list = jsonDecode(cached) as List;
        return list.map((e) => InsightModel.fromJson(e)).toList();
      }
    }

    try {
      final resp = await _api.get(ApiConstants.statsInsights);
      final list = (resp.data as Map<String, dynamic>)['data'] as List;
      await box.put(cacheKey, jsonEncode(list));
      await box.put('${cacheKey}_ts', DateTime.now().toIso8601String());
      return list.map((e) => InsightModel.fromJson(e)).toList();
    } catch (_) {
      final cached = box.get(cacheKey) as String?;
      if (cached != null) {
        final list = jsonDecode(cached) as List;
        return list.map((e) => InsightModel.fromJson(e)).toList();
      }
      return [];
    }
  }

  // ── Milestones ────────────────────────────────────────────────────────────

  Future<List<MilestoneModel>> getMilestones() async {
    const cacheKey = 'milestones';
    final box = await _box();

    if (_isFresh(cacheKey, box, ttl: const Duration(hours: 4))) {
      final cached = box.get(cacheKey) as String?;
      if (cached != null) {
        final list = jsonDecode(cached) as List;
        return list.map((e) => MilestoneModel.fromJson(e)).toList();
      }
    }

    try {
      final resp = await _api.get(ApiConstants.statsMilestones);
      final list = (resp.data as Map<String, dynamic>)['data'] as List;
      await box.put(cacheKey, jsonEncode(list));
      await box.put('${cacheKey}_ts', DateTime.now().toIso8601String());
      return list.map((e) => MilestoneModel.fromJson(e)).toList();
    } catch (_) {
      final cached = box.get(cacheKey) as String?;
      if (cached != null) {
        final list = jsonDecode(cached) as List;
        return list.map((e) => MilestoneModel.fromJson(e)).toList();
      }
      return [];
    }
  }

  // ── Force refresh ─────────────────────────────────────────────────────────

  Future<void> forceRefresh() async {
    try {
      await _api.post(ApiConstants.statsRefresh);
    } catch (_) {}
  }

  /// Clear all cached statistics from Hive.
  Future<void> clearCache() async {
    final box = await _box();
    await box.clear();
  }
}
