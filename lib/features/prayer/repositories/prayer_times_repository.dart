import 'dart:convert';
import 'package:isar/isar.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/local_db/isar_service.dart';
import '../../../core/local_db/isar_collections.dart';
import '../models/prayer_times_model.dart';

/// Repository for the Prayer Times Calendar system.
///
/// Priority chain:
///   1. Isar location-hashed coordinate cache (offline-first, per locationHash+date key)
///   2. API fetch with ETag/304 (only loads if data changed)
///   3. adhan calculation engine (offline-first calculations)
class PrayerTimesRepository {
  final ApiClient _api;
  final Isar _isar = IsarService.instance.isar;

  PrayerTimesRepository(this._api);

  String _generateLocationHash(double lat, double lng) {
    return '${lat.toStringAsFixed(2)}_${lng.toStringAsFixed(2)}';
  }

  String _cacheKey(double lat, double lng, String date) {
    final hash = _generateLocationHash(lat, lng);
    return 'loc_${hash}_$date';
  }

  // ─── Public API ──────────────────────────────────────────────────────────

  /// Get prayer times for a specific [date] (formatted "YYYY-MM-DD").
  /// Coordinates are derived from the cityId.
  /// Looks up coordinates + locationHash + date cache in Isar.
  Future<PrayerTimeEntry?> getForDate({
    required int cityId,
    required String date, // "YYYY-MM-DD"
  }) async {
    // 1. Get coordinates for city
    final double lat;
    final double lng;
    if (cityId == 2) {
      lat = 35.5619; lng = 45.4375; // Sulaymaniyah
    } else if (cityId == 3) {
      lat = 36.8601; lng = 42.9961; // Duhok
    } else if (cityId == 4) {
      lat = 35.4681; lng = 44.3922; // Kirkuk
    } else if (cityId == 5) {
      lat = 35.1778; lng = 45.9861; // Halabja
    } else {
      lat = 36.1912; lng = 44.0091; // Erbil (Default)
    }

    final key = _cacheKey(lat, lng, date);

    // 2. Check Isar cache
    final cached = await _isar.prayerTimesCollections.filter().cacheKeyEqualTo(key).findFirst();
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached.prayerTimesJson) as Map<String, dynamic>;
        return PrayerTimeEntry.fromJson(decoded);
      } catch (_) {}
    }

    // 3. Fallback to API year fetch and populate Isar for the date
    final year = int.tryParse(date.split('-').first) ?? DateTime.now().year;
    final yearResponse = await fetchYear(cityId: cityId, year: year);

    if (yearResponse != null) {
      try {
        final matched = yearResponse.data.firstWhere((e) => e.date == date);
        // Cache this date specifically in Isar
        await _isar.writeTxn(() async {
          await _isar.prayerTimesCollections.put(PrayerTimesCollection(
            cacheKey: key,
            latitude: lat,
            longitude: lng,
            locationHash: _generateLocationHash(lat, lng),
            date: date,
            prayerTimesJson: jsonEncode(matched.toJson()),
          ));
        });
        return matched;
      } catch (_) {}
    }

    return null; // Caller handles offline engine fallback
  }

  /// Fetch prayer times for [cityId] and [year] from the Laravel API.
  Future<PrayerTimesResponse?> fetchYear({
    required int cityId,
    required int year,
    bool forceRefresh = false,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.prayerTimes,
        queryParameters: {
          'city_id': cityId,
          'year': year,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data as Map<String, dynamic>;
        return PrayerTimesResponse.fromJson(resData);
      }
    } catch (_) {}

    return null;
  }

  /// Fetch available cities that have prayer time data.
  Future<List<PrayerTimeCity>> fetchCities({bool forceRefresh = false}) async {
    try {
      final response = await _api.get(ApiConstants.prayerTimesCities);
      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data as Map<String, dynamic>;
        final rawList = resData['data'] as List<dynamic>? ?? [];
        return rawList
            .map((e) => PrayerTimeCity.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}

    return [];
  }

  /// Clear all prayer times cache in Isar.
  Future<void> clearCache() async {
    await _isar.writeTxn(() async {
      await _isar.prayerTimesCollections.clear();
    });
  }
}
