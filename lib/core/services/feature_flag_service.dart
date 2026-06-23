import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Feature Flag Keys — compile-time constants for all known flags
// ─────────────────────────────────────────────────────────────────────────────

class FeatureFlags {
  const FeatureFlags._();

  static const String memorization      = 'memorization_module';
  static const String tasbihLeaderboard = 'tasbih_leaderboard';
  static const String audioDownload     = 'audio_download';
  static const String tajweed           = 'tajweed_module';
  static const String hadith            = 'hadith_module';
  static const String statistics        = 'statistics_module';
  static const String khatmTracker      = 'khatm_tracker';
  static const String fingerprintCounter = 'fingerprint_counter';
  static const String offlinePackages   = 'offline_packages';
  static const String achievements      = 'achievements_module';
}

// ─────────────────────────────────────────────────────────────────────────────
// FeatureFlagService
// ─────────────────────────────────────────────────────────────────────────────

/// Remote feature flag service.
///
/// On boot, syncs flags from the backend using ETag caching.
/// Falls back to locally cached flags when offline.
/// All unknown flags default to [true] for graceful degradation.
class FeatureFlagService {
  final SharedPreferences _prefs;
  final ApiClient _apiClient;

  static const String _flagsCacheKey = 'feature_flags_json';
  static const String _etagKey       = 'feature_flags_etag';

  /// Default flag values — used when no cache and no network
  static const Map<String, bool> _defaults = {
    FeatureFlags.memorization:       true,
    FeatureFlags.tasbihLeaderboard:  true,
    FeatureFlags.audioDownload:      true,
    FeatureFlags.tajweed:            true,
    FeatureFlags.hadith:             true,
    FeatureFlags.statistics:         true,
    FeatureFlags.khatmTracker:       true,
    FeatureFlags.fingerprintCounter: true,
    FeatureFlags.offlinePackages:    true,
    FeatureFlags.achievements:       true,
  };

  Map<String, bool> _flags = Map.from(_defaults);

  FeatureFlagService(this._prefs, this._apiClient) {
    _loadFromCache();
  }

  /// Load cached flags from SharedPreferences (instant, synchronous).
  void _loadFromCache() {
    final raw = _prefs.getString(_flagsCacheKey);
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _flags = decoded.map((k, v) => MapEntry(k, v as bool));
      } catch (_) {}
    }
  }

  /// Sync flags from the remote backend.
  /// Uses ETag to avoid re-downloading unchanged flags.
  /// Safe to call on every app boot — returns quickly on 304.
  Future<void> sync() async {
    try {
      final storedEtag = _prefs.getString(_etagKey) ?? '';
      final options = storedEtag.isNotEmpty
          ? Options(headers: {'If-None-Match': storedEtag})
          : null;

      final response = await _apiClient.get(
        '/feature-flags',
        options: options,
      );

      if (response.statusCode == 304) {
        // No change — cached flags are still valid
        return;
      }

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final rawFlags = data['flags'] as Map<String, dynamic>? ?? {};
        final newEtag  = data['etag'] as String? ?? '';

        final updated = rawFlags.map((k, v) => MapEntry(k, v as bool));

        // Merge with defaults — new flags from server win
        _flags = {..._defaults, ...updated};

        await _prefs.setString(_flagsCacheKey, jsonEncode(_flags));
        if (newEtag.isNotEmpty) {
          await _prefs.setString(_etagKey, newEtag);
        }
      }
    } catch (e) {
      // Offline or API error — continue with cached/default flags
      debugPrint('[FeatureFlagService] sync failed: $e');
    }
  }

  /// Check if a feature flag is enabled.
  /// Defaults to [true] if the flag is not found (graceful degradation).
  bool isEnabled(String flagKey, {bool defaultValue = true}) {
    return _flags[flagKey] ?? defaultValue;
  }

  /// All current flag values (read-only snapshot).
  Map<String, bool> get allFlags => Map.unmodifiable(_flags);
}
