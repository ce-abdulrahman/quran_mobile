import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:adhan/adhan.dart' as adhan;
import '../../../core/network/api_client.dart';
import '../../../core/local_db/isar_service.dart';
import '../../../core/local_db/isar_collections.dart';
import '../../../core/providers/prayer_times_provider.dart';
import '../models/prayer_times_model.dart';

/// Repository for the Prayer Times Calendar system.
///
/// Priority chain:
///   1. Isar location-hashed coordinate cache (offline-first, per locationHash+date key)
///   2. Local CSV timetable lookup (accurate calendar schedules for 21 cities)
///   3. adhan calculation engine (fallback calculation for future dates or other coordinates)
class PrayerTimesRepository {
  final Isar _isar = IsarService.instance.isar;

  PrayerTimesRepository(ApiClient api);

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
    // 1. Get coordinates and name for city from 21 registered cities list
    final city = kurdishCities.firstWhere(
      (c) => c.id == cityId,
      orElse: () => kurdishCities.first,
    );
    final cityName = city.nameEn;
    final lat = city.latitude;
    final lng = city.longitude;

    final key = _cacheKey(lat, lng, date);

    // 2. Check Isar cache
    final cached = await _isar.prayerTimesCollections.filter().cacheKeyEqualTo(key).findFirst();
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached.prayerTimesJson) as Map<String, dynamic>;
        return PrayerTimeEntry.fromJson(decoded);
      } catch (_) {}
    }

    // 3. Try parsing from local CSV timetable asset
    try {
      final parsedDate = DateTime.parse(date);
      final day = parsedDate.day;
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final month = months[parsedDate.month - 1];
      final csvDateStr = '$day-$month';

      final csvData = await rootBundle.loadString('assets/data/prayer_times.csv');
      final lines = const LineSplitter().convert(csvData);

      for (final line in lines) {
        final parts = line.split(',');
        if (parts.length >= 8) {
          final cName = parts[0].trim();
          final cDate = parts[1].trim();
          if (cName.toLowerCase() == cityName.toLowerCase() && cDate.toLowerCase() == csvDateStr.toLowerCase()) {
            final entry = PrayerTimeEntry(
              date: date,
              fajr: parts[2].trim(),
              sunrise: parts[3].trim(),
              dhuhr: parts[4].trim(),
              asr: parts[5].trim(),
              maghrib: parts[6].trim(),
              isha: parts[7].trim(),
              source: 'csv',
            );

            // Cache in Isar
            await _isar.writeTxn(() async {
              await _isar.prayerTimesCollections.put(PrayerTimesCollection(
                cacheKey: key,
                latitude: lat,
                longitude: lng,
                locationHash: _generateLocationHash(lat, lng),
                date: date,
                prayerTimesJson: jsonEncode(entry.toJson()),
              ));
            });

            return entry;
          }
        }
      }
    } catch (_) {}

    // 4. Fallback: Dynamic Adhan calculation (Kurdistan Region / Ministry of Awqaf)
    try {
      final parsedDate = DateTime.parse(date);
      final coordinates = adhan.Coordinates(lat, lng);
      final params = adhan.CalculationMethod.muslim_world_league.getParameters();
      params.fajrAngle = 18.0;
      params.ishaAngle = 17.0;
      params.madhab = adhan.Madhab.shafi;

      final prayerTimes = adhan.PrayerTimes(
        coordinates,
        adhan.DateComponents(parsedDate.year, parsedDate.month, parsedDate.day),
        params,
      );

      String formatTime(DateTime? dt) {
        if (dt == null) return '--:--';
        final local = dt.toLocal();
        final hour = local.hour.toString().padLeft(2, '0');
        final minute = local.minute.toString().padLeft(2, '0');
        return '$hour:$minute';
      }

      final entry = PrayerTimeEntry(
        date: date,
        fajr: formatTime(prayerTimes.fajr),
        sunrise: formatTime(prayerTimes.sunrise),
        dhuhr: formatTime(prayerTimes.dhuhr),
        asr: formatTime(prayerTimes.asr),
        maghrib: formatTime(prayerTimes.maghrib),
        isha: formatTime(prayerTimes.isha),
        source: 'calculated',
      );

      // Cache in Isar
      await _isar.writeTxn(() async {
        await _isar.prayerTimesCollections.put(PrayerTimesCollection(
          cacheKey: key,
          latitude: lat,
          longitude: lng,
          locationHash: _generateLocationHash(lat, lng),
          date: date,
          prayerTimesJson: jsonEncode(entry.toJson()),
        ));
      });

      return entry;
    } catch (_) {}

    return null;
  }

  /// Fetch prayer times for [cityId] and [year] from the local CSV (fallback structure).
  Future<PrayerTimesResponse?> fetchYear({
    required int cityId,
    required int year,
    bool forceRefresh = false,
  }) async {
    // Return mock response based on CSV parsing if a year is requested
    try {
      final city = kurdishCities.firstWhere(
        (c) => c.id == cityId,
        orElse: () => kurdishCities.first,
      );
      final List<PrayerTimeEntry> yearEntries = [];
      
      // Let's populate the yearEntries for this city by calling getForDate for each day
      final startDate = DateTime(year, 1, 1);
      final daysInYear = DateTime(year, 12, 31).difference(startDate).inDays + 1;
      
      for (int i = 0; i < daysInYear; i++) {
        final current = startDate.add(Duration(days: i));
        final dateStr = "${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}";
        final entry = await getForDate(cityId: cityId, date: dateStr);
        if (entry != null) {
          yearEntries.add(entry);
        }
      }

      if (yearEntries.isNotEmpty) {
        return PrayerTimesResponse(
          city: city.nameEn,
          cityId: cityId,
          timezone: 'Asia/Baghdad',
          year: year,
          total: yearEntries.length,
          data: yearEntries,
          versionHash: 'local_v1',
        );
      }
    } catch (_) {}

    return null;
  }

  /// Return all available cities locally.
  Future<List<PrayerTimeCity>> fetchCities({bool forceRefresh = false}) async {
    return kurdishCities.map((c) => PrayerTimeCity(
      id: c.id ?? 0,
      name: c.nameEn,
      lat: c.latitude,
      lng: c.longitude,
      timezone: 'Asia/Baghdad',
      availableYears: [DateTime.now().year],
      totalEntries: 365,
    )).toList();
  }

  /// Clear all prayer times cache in Isar.
  Future<void> clearCache() async {
    await _isar.writeTxn(() async {
      await _isar.prayerTimesCollections.clear();
    });
  }
}
