import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AudioQuality { auto, high, medium, low, offlineOnly }

class AudioQualityManager {
  static final AudioQualityManager _instance = AudioQualityManager._internal();
  factory AudioQualityManager() => _instance;
  AudioQualityManager._internal();

  late final SharedPreferences _prefs;
  static const _key = 'audio_quality_user_preference';

  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
  }

  AudioQuality getUserPreference() {
    final val = _prefs.getString(_key) ?? 'auto';
    return AudioQuality.values.firstWhere(
      (e) => e.name == val,
      orElse: () => AudioQuality.auto,
    );
  }

  Future<void> setUserPreference(AudioQuality quality) async {
    await _prefs.setString(_key, quality.name);
  }

  Future<String> getSelectedQuality() async {
    final pref = getUserPreference();
    if (pref != AudioQuality.auto) {
      if (pref == AudioQuality.offlineOnly) {
        return 'offline_only';
      }
      return pref.name;
    }

    // Auto Mode: Detect network type
    if (kIsWeb) {
      return 'high'; // Default high quality on Web
    }

    final networkType = await _detectNetworkType();
    if (networkType == 'none') {
      return 'offline_only';
    } else if (networkType == 'wifi') {
      return 'high';
    } else {
      return 'medium';
    }
  }

  Future<String> _detectNetworkType() async {
    try {
      final interfaces = await NetworkInterface.list();
      if (interfaces.isEmpty) {
        return 'none';
      }
      for (final interface in interfaces) {
        final name = interface.name.toLowerCase();
        if (name.contains('wlan') || name.contains('wifi') || name.contains('eth')) {
          return 'wifi';
        }
        if (name.contains('rmnet') ||
            name.contains('pdp') ||
            name.contains('ccmni') ||
            name.contains('cellular') ||
            name.contains('mobile') ||
            name.contains('wwan')) {
          return 'mobile';
        }
      }
      try {
        final lookup = await InternetAddress.lookup('example.com').timeout(const Duration(seconds: 1));
        if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
          return 'mobile';
        }
      } catch (_) {}
      return 'none';
    } catch (_) {
      return 'wifi'; // Safe fallback
    }
  }
}
