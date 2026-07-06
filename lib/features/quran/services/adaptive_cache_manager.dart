import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The active caching profile based on hardware capacities.
enum CacheProfile {
  /// Low memory device profile (minimal caching).
  low,

  /// Standard configuration profile.
  standard,

  /// High performance device profile (aggressive pre-fetching).
  high,
}

/// Adaptive cache manager to configure pre-decoding page limits dynamically,
/// preventing out-of-memory crashes on low-end hardware.
class AdaptiveCacheManager {
  final CacheProfile profile;

  const AdaptiveCacheManager({this.profile = CacheProfile.standard});

  /// Factory constructor to auto-detect device capabilities using CPU cores or web detection.
  factory AdaptiveCacheManager.detect() {
    if (kIsWeb) {
      return const AdaptiveCacheManager(profile: CacheProfile.low);
    }
    try {
      final cores = Platform.numberOfProcessors;
      if (cores <= 4) {
        return const AdaptiveCacheManager(profile: CacheProfile.low);
      } else if (cores >= 8) {
        return const AdaptiveCacheManager(profile: CacheProfile.high);
      }
    } catch (_) {
      // Fallback to standard if OS detection fails.
    }
    return const AdaptiveCacheManager(profile: CacheProfile.standard);
  }

  /// Resolves the count of page indices to pre-render and warm-cache ahead/behind.
  int getPreloadPageCount() {
    switch (profile) {
      case CacheProfile.low:
        return 0;
      case CacheProfile.standard:
        return 1;
      case CacheProfile.high:
        return 3;
    }
  }

  /// Clears system image caches when a memory warning is dispatched from the OS dispatcher.
  void onMemoryPressure() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
