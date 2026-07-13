import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fingerprint_settings_model.dart';
import '../models/fingerprint_statistics_model.dart';
import '../repositories/fingerprint_repository.dart';

import 'achievement_provider.dart';
import 'app_providers.dart';


class FingerprintState {
  final FingerprintSettingsModel settings;
  final FingerprintStatisticsModel statistics;
  final bool isLoading;
  final bool isSyncing;
  final String? errorMessage;

  FingerprintState({
    required this.settings,
    required this.statistics,
    this.isLoading = false,
    this.isSyncing = false,
    this.errorMessage,
  });

  FingerprintState copyWith({
    FingerprintSettingsModel? settings,
    FingerprintStatisticsModel? statistics,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
  }) {
    return FingerprintState(
      settings: settings ?? this.settings,
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final fingerprintRepositoryProvider = Provider<FingerprintRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FingerprintRepository(apiClient);
});

final fingerprintProvider = StateNotifierProvider<FingerprintNotifier, FingerprintState>((ref) {
  final repo = ref.watch(fingerprintRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return FingerprintNotifier(repo, prefs, ref);
});

class FingerprintNotifier extends StateNotifier<FingerprintState> {
  final FingerprintRepository _repository;
  final SharedPreferences _prefs;
  final Ref _ref;

  FingerprintNotifier(this._repository, this._prefs, this._ref)
      : super(FingerprintState(
          settings: FingerprintSettingsModel.defaultSettings(),
          statistics: FingerprintStatisticsModel.zero(),
        )) {
    _loadLocalData();
    fetchRemoteData();
  }

  static const _settingsKey = 'fingerprint_local_settings';
  static const _statsKey = 'fingerprint_local_stats';
  static const _queueKey = 'fingerprint_session_sync_queue';

  /// Load cached data from SharedPreferences
  void _loadLocalData() {
    final settingsJson = _prefs.getString(_settingsKey);
    final statsJson = _prefs.getString(_statsKey);

    FingerprintSettingsModel loadedSettings = FingerprintSettingsModel.defaultSettings();
    FingerprintStatisticsModel loadedStats = FingerprintStatisticsModel.zero();

    if (settingsJson != null) {
      try {
        loadedSettings = FingerprintSettingsModel.fromJson(jsonDecode(settingsJson) as Map<String, dynamic>);
      } catch (_) {}
    }

    if (statsJson != null) {
      try {
        loadedStats = FingerprintStatisticsModel.fromJson(jsonDecode(statsJson) as Map<String, dynamic>);
      } catch (_) {}
    }

    state = state.copyWith(
      settings: loadedSettings,
      statistics: loadedStats,
    );
  }

  /// Sync all remote data (Settings & Stats)
  Future<void> fetchRemoteData() async {
    state = state.copyWith(isLoading: true);
    
    // Fetch Settings
    final settingsRes = await _repository.getSettings();
    // Fetch Statistics
    final statsRes = await _repository.getStatistics();

    FingerprintSettingsModel? remoteSettings;
    FingerprintStatisticsModel? remoteStats;

    settingsRes.when(
      success: (data) {
        remoteSettings = data;
        _prefs.setString(_settingsKey, jsonEncode(data.toJson()));
      },
      error: (_, __, ___) {},
    );

    statsRes.when(
      success: (data) {
        remoteStats = data;
        _prefs.setString(_statsKey, jsonEncode(data.toJson()));
      },
      error: (_, __, ___) {},
    );

    state = state.copyWith(
      isLoading: false,
      settings: remoteSettings ?? state.settings,
      statistics: remoteStats ?? state.statistics,
    );

    // Sync any queued sessions if we got online
    if (remoteSettings != null || remoteStats != null) {
      syncQueuedSessions();
    }
  }

  /// Update settings locally and remotely
  Future<void> updateSettings(FingerprintSettingsModel newSettings) async {
    // 1. Update locally first (offline first)
    state = state.copyWith(settings: newSettings);
    await _prefs.setString(_settingsKey, jsonEncode(newSettings.toJson()));

    // 2. Push to remote
    final res = await _repository.saveSettings(newSettings);
    res.when(
      success: (data) {
        state = state.copyWith(settings: data);
        _prefs.setString(_settingsKey, jsonEncode(data.toJson()));
      },
      error: (message, _, __) {
        // Just log, local settings remain updated
      },
    );
  }

  /// Save completed fingerprint session (offline first strategy)
  Future<List<dynamic>> saveSession({
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
    // 1. Update local cached statistics immediately for visual response
    final localStats = state.statistics.copyWith(
      totalCounts: state.statistics.totalCounts + totalCount,
      totalSessions: state.statistics.totalSessions + 1,
      totalBlindSessions: state.statistics.totalBlindSessions + (isBlind ? 1 : 0),
      totalFocusSessions: state.statistics.totalFocusSessions + (isFocus ? 1 : 0),
      lastUsedAt: DateTime.now(),
      avgTouchRate: durationSeconds > 0 
          ? ((state.statistics.totalCounts + totalCount) / (((state.statistics.totalSessions + 1) * 2) / 60)) 
          : state.statistics.avgTouchRate,
    );

    state = state.copyWith(statistics: localStats);
    await _prefs.setString(_statsKey, jsonEncode(localStats.toJson()));

    // 2. Format queue entry
    final sessionData = {
      'dhikr_id': dhikrId,
      'custom_dhikr_name': customDhikrName,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'duration_seconds': durationSeconds,
      'total_count': totalCount,
      'is_blind': isBlind,
      'is_focus': isFocus,
      'count_mode': countMode,
    };

    // 3. Try to sync immediately
    state = state.copyWith(isSyncing: true);
    final res = await _repository.syncSession(
      dhikrId: dhikrId,
      customDhikrName: customDhikrName,
      startTime: startTime,
      endTime: endTime,
      durationSeconds: durationSeconds,
      totalCount: totalCount,
      isBlind: isBlind,
      isFocus: isFocus,
      countMode: countMode,
    );

    List<dynamic> newlyUnlocked = [];

    await res.when(
      success: (data) async {
        newlyUnlocked = data['newly_unlocked'] as List<dynamic>? ?? [];
        
        // Update statistics with precise server stats if sync succeeded
        await fetchRemoteData();
        
        // Refresh standard user details and achievements

        _ref.read(achievementProvider.notifier).loadAchievements();
      },
      error: (message, _, __) async {
        // Add to queue for later if it failed due to connection error
        final queue = _getQueue();
        queue.add(sessionData);
        await _prefs.setString(_queueKey, jsonEncode(queue));
      },
    );

    state = state.copyWith(isSyncing: false);
    return newlyUnlocked;
  }

  /// Sync queued sessions when online
  Future<void> syncQueuedSessions() async {
    final queue = _getQueue();
    if (queue.isEmpty) return;

    state = state.copyWith(isSyncing: true);
    final List<Map<String, dynamic>> failedItems = [];

    for (final session in queue) {
      final res = await _repository.syncSession(
        dhikrId: session['dhikr_id'] as int?,
        customDhikrName: session['custom_dhikr_name'] as String?,
        startTime: DateTime.parse(session['start_time'] as String),
        endTime: DateTime.parse(session['end_time'] as String),
        durationSeconds: session['duration_seconds'] as int,
        totalCount: session['total_count'] as int,
        isBlind: session['is_blind'] as bool,
        isFocus: session['is_focus'] as bool,
        countMode: session['count_mode'] as String,
      );

      res.when(
        success: (_) {},
        error: (_, __, ___) {
          failedItems.add(session);
        },
      );
    }

    // Save remainder in queue
    await _prefs.setString(_queueKey, jsonEncode(failedItems));
    state = state.copyWith(isSyncing: false);

    if (queue.length > failedItems.length) {
      // Something was synced
      await fetchRemoteData();

      _ref.read(achievementProvider.notifier).loadAchievements();
    }
  }

  List<Map<String, dynamic>> _getQueue() {
    final raw = _prefs.getString(_queueKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }
}
