import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/feature_flag_service.dart';
import 'app_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Feature Flag Providers
// ─────────────────────────────────────────────────────────────────────────────

/// Core service provider — singleton for the lifetime of the app.
final featureFlagServiceProvider = Provider<FeatureFlagService>((ref) {
  final prefs     = ref.watch(sharedPreferencesProvider);
  final apiClient = ref.watch(apiClientProvider);
  return FeatureFlagService(prefs, apiClient);
});

/// All flags as a map — useful for debugging or admin panels.
final allFeatureFlagsProvider = Provider<Map<String, bool>>((ref) {
  return ref.watch(featureFlagServiceProvider).allFlags;
});

// ── Per-feature convenience providers ────────────────────────────────────────
// Each returns true if feature is enabled, true by default for safe degradation.

final isMemorizationEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.memorization);
});

final isTasbihLeaderboardEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.tasbihLeaderboard);
});

final isAudioDownloadEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.audioDownload);
});

final isTajweedEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.tajweed);
});

final isHadithEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.hadith);
});

final isStatisticsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.statistics);
});

final isKhatmTrackerEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.khatmTracker);
});

final isFingerprintCounterEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.fingerprintCounter);
});

final isOfflinePackagesEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.offlinePackages);
});

final isAchievementsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(featureFlagServiceProvider).isEnabled(FeatureFlags.achievements);
});
