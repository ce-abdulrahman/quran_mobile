import 'dart:convert';
import 'package:hive/hive.dart';

class CacheManager {
  static const String _timestampSuffix = '_timestamp';
  static const String _ttlSuffix = '_ttl';

  final Box _box;

  const CacheManager(this._box);

  /// Retrieves cached JSON data (Map or List) if present and valid.
  dynamic get(String key) {
    final jsonStr = _box.get(key) as String?;
    if (jsonStr == null) return null;

    final timestampMs = _box.get('$key$_timestampSuffix') as int?;
    final ttlMs = _box.get('$key$_ttlSuffix') as int?;

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

      await _box.put(key, jsonStr);
      await _box.put('$key$_timestampSuffix', timestampMs);
      await _box.put('$key$_ttlSuffix', ttlMs);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Invalidates/removes the cached data.
  Future<void> invalidate(String key) async {
    await _box.delete(key);
    await _box.delete('$key$_timestampSuffix');
    await _box.delete('$key$_ttlSuffix');
  }
}
