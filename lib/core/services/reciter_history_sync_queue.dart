import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';

class ReciterHistorySyncQueue {
  final SharedPreferences prefs;
  final ApiClient apiClient;
  bool _isSyncing = false;

  ReciterHistorySyncQueue({
    required this.prefs,
    required this.apiClient,
  });

  static const String _localCacheKey = 'reciter_selection_cache_queue';
  static const String _historyListKey = 'reciter_recent_history_list';

  /// Log a local selection event
  Future<void> logSelection(int reciterId) async {
    final timestamp = DateTime.now().toIso8601String();
    
    // 1. Save to chronological list (for UI display immediately)
    await _addToRecentHistory(reciterId);

    // 2. Queue for background sync
    final queue = _getQueue();
    // Deduplicate by reciterId
    queue.removeWhere((item) => item['reciterId'] == reciterId);
    queue.add({
      'reciterId': reciterId,
      'timestamp': timestamp,
    });
    await _saveQueue(queue);

    // 3. Trigger sync in background
    triggerSync();
  }

  List<Map<String, dynamic>> _getQueue() {
    final raw = prefs.getString(_localCacheKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveQueue(List<Map<String, dynamic>> queue) async {
    await prefs.setString(_localCacheKey, jsonEncode(queue));
  }

  /// Local chronological selection storage (for select avatars)
  List<int> getRecentReciterIds() {
    final raw = prefs.getString(_historyListKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.map((e) => e as int).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _addToRecentHistory(int reciterId) async {
    final list = getRecentReciterIds();
    list.remove(reciterId);
    list.insert(0, reciterId);
    // Keep max 10 reciters
    if (list.length > 10) {
      list.removeLast();
    }
    await prefs.setString(_historyListKey, jsonEncode(list));
  }

  /// Sync the local offline queue to the remote API
  Future<void> triggerSync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final queue = _getQueue();
      if (queue.isEmpty) {
        _isSyncing = false;
        return;
      }

      final failed = <Map<String, dynamic>>[];
      for (final item in queue) {
        final reciterId = item['reciterId'] as int;
        try {
          // POST /api/v1/reciters/{id}/select
          final response = await apiClient.post('/v1/reciters/$reciterId/select');
          if (response.statusCode != 200) {
            failed.add(item);
          }
        } catch (e) {
          debugPrint('Failed to sync reciter $reciterId: $e');
          failed.add(item);
        }
      }

      await _saveQueue(failed);
    } finally {
      _isSyncing = false;
    }
  }
}
