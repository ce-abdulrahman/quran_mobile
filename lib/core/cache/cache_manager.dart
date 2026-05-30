import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _timestampSuffix = '_timestamp';
  static const String _ttlSuffix = '_ttl';

  final SharedPreferences _prefs;

  const CacheManager(this._prefs);

  /// Retrieves cached JSON data (Map or List) if present and valid.
  dynamic get(String key) {
    final jsonStr = _prefs.getString(key);
    if (jsonStr == null) return null;

    final timestampMs = _prefs.getInt('$key$_timestampSuffix');
    final ttlMs = _prefs.getInt('$key$_ttlSuffix');

    if (timestampMs == null || ttlMs == null) {
      return null;
    }

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final expiryTime = cachedTime.add(Duration(milliseconds: ttlMs));

    if (DateTime.now().isAfter(expiryTime)) {
      invalidate(key);
      return null;
    }

    try {
      return jsonDecode(jsonStr);
    } catch (_) {
      return null;
    }
  }

  /// Caches any JSON encodable value with a specific TTL.
  Future<bool> set(String key, dynamic value, Duration ttl) async {
    try {
      final jsonStr = jsonEncode(value);
      final timestampMs = DateTime.now().millisecondsSinceEpoch;
      final ttlMs = ttl.inMilliseconds;

      await _prefs.setString(key, jsonStr);
      await _prefs.setInt('$key$_timestampSuffix', timestampMs);
      await _prefs.setInt('$key$_ttlSuffix', ttlMs);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Invalidates/removes the cached data.
  Future<void> invalidate(String key) async {
    await _prefs.remove(key);
    await _prefs.remove('$key$_timestampSuffix');
    await _prefs.remove('$key$_ttlSuffix');
  }
}
