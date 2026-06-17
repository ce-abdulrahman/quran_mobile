import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../models/prayer_widget_model.dart';

class PrayerWidgetRepository {
  final ApiClient _api;
  static const String _kBoxName = 'prayer_widget_box';
  static const String _kKey = 'widget_data';

  PrayerWidgetRepository(this._api);

  Future<Box> _box() async {
    if (!Hive.isBoxOpen(_kBoxName)) {
      return await Hive.openBox(_kBoxName);
    }
    return Hive.box(_kBoxName);
  }

  /// Fetch widget payload from API, check for version change (ETag/304), or fall back to Hive cache.
  Future<PrayerWidgetModel?> getWidgetData({bool forceRefresh = false}) async {
    final box = await _box();
    final cachedJson = box.get(_kKey) as String?;
    String storedHash = '';
    
    if (cachedJson != null) {
      try {
        final decoded = jsonDecode(cachedJson) as Map<String, dynamic>;
        storedHash = decoded['version_hash'] as String? ?? '';
        if (!forceRefresh) {
          return PrayerWidgetModel.fromJson(decoded);
        }
      } catch (_) {}
    }

    try {
      final response = await _api.get(
        ApiConstants.prayerWidget,
        queryParameters: {'version_hash': storedHash},
      );

      if (response.statusCode == 304 && cachedJson != null) {
        final decoded = jsonDecode(cachedJson) as Map<String, dynamic>;
        return PrayerWidgetModel.fromJson(decoded);
      }

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data as Map<String, dynamic>;
        final data = resData['data'] as Map<String, dynamic>;
        
        // Cache to Hive box
        await box.put(_kKey, jsonEncode(data));
        return PrayerWidgetModel.fromJson(data);
      }
    } catch (_) {
      // Offline fallback: load cached data if network request fails
      if (cachedJson != null) {
        try {
          return PrayerWidgetModel.fromJson(jsonDecode(cachedJson) as Map<String, dynamic>);
        } catch (_) {}
      }
    }
    return null;
  }
}
