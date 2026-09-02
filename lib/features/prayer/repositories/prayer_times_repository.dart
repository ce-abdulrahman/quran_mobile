import 'dart:convert';
import 'package:isar/isar.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/prayer_calculation.dart';
import '../../../core/services/prayer_timetable.dart';
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

  /// The method is part of the key: entries produced by calculation depend on
  /// it, so without this a user switching method would keep being served times
  /// computed with the old one.
  String _cacheKey(double lat, double lng, String date, String? methodKey) {
    final hash = _generateLocationHash(lat, lng);
    return 'loc_${hash}_${date}_${methodKey ?? PrayerCalculation.defaultMethodKey}';
  }

  static String _formatTime(DateTime? dt) {
    if (dt == null) return '--:--';
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _cache({
    required String key,
    required double lat,
    required double lng,
    required String date,
    required PrayerTimeEntry entry,
  }) async {
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
  }

  // ─── Public API ──────────────────────────────────────────────────────────

  /// Get prayer times for a specific [date] (formatted "YYYY-MM-DD").
  /// Coordinates are derived from the cityId.
  /// Looks up coordinates + locationHash + date cache in Isar.
  ///
  /// [methodKey] is only consulted when the official timetable has no entry.
  Future<PrayerTimeEntry?> getForDate({
    required int cityId,
    required String date, // "YYYY-MM-DD"
    String? methodKey,
  }) async {
    // 1. Get coordinates and name for city from 21 registered cities list
    final city = kurdishCities.firstWhere(
      (c) => c.id == cityId,
      orElse: () => kurdishCities.first,
    );
    final cityName = city.nameEn;
    final lat = city.latitude;
    final lng = city.longitude;

    final key = _cacheKey(lat, lng, date, methodKey);

    // 2. Check Isar cache
    final cached = await _isar.prayerTimesCollections.filter().cacheKeyEqualTo(key).findFirst();
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached.prayerTimesJson) as Map<String, dynamic>;
        return PrayerTimeEntry.fromJson(decoded);
      } catch (_) {}
    }

    // 3. Official timetable, via the shared parsed index. This used to reload
    // and linearly scan the whole 381KB CSV on every miss — and fetchYear calls
    // this 365 times, so a single year warm-up reparsed the file 365 times.
    try {
      final parsedDate = DateTime.parse(date);
      await PrayerTimetable.instance.ensureLoaded();
      final official = PrayerTimetable.instance.lookup(
        cityNameEn: cityName,
        date: parsedDate,
      );

      if (official != null) {
        final entry = PrayerTimeEntry(
          date: date,
          fajr: _formatTime(official.fajr),
          sunrise: _formatTime(official.sunrise),
          dhuhr: _formatTime(official.dhuhr),
          asr: _formatTime(official.asr),
          maghrib: _formatTime(official.maghrib),
          isha: _formatTime(official.isha),
          source: 'csv',
        );

        await _cache(key: key, lat: lat, lng: lng, date: date, entry: entry);
        return entry;
      }
    } catch (_) {}

    // 4. Fallback: calculation, through the same shared path the rest of the
    // app uses so the widget cannot show different times to the prayer screen.
    // This previously hardcoded Muslim World League and ignored the user's
    // chosen method.
    try {
      final parsedDate = DateTime.parse(date);
      final prayerTimes = PrayerCalculation.forDate(
        latitude: lat,
        longitude: lng,
        date: parsedDate,
        methodKey: methodKey,
      );

      final entry = PrayerTimeEntry(
        date: date,
        fajr: _formatTime(prayerTimes.fajr),
        sunrise: _formatTime(prayerTimes.sunrise),
        dhuhr: _formatTime(prayerTimes.dhuhr),
        asr: _formatTime(prayerTimes.asr),
        maghrib: _formatTime(prayerTimes.maghrib),
        isha: _formatTime(prayerTimes.isha),
        source: 'calculated',
      );

      await _cache(key: key, lat: lat, lng: lng, date: date, entry: entry);
      return entry;
    } catch (_) {}

    return null;
  }

  /// Fetch prayer times for [cityId] and [year] from the local CSV (fallback structure).
  Future<PrayerTimesResponse?> fetchYear({
    required int cityId,
    required int year,
    bool forceRefresh = false,
    String? methodKey,
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
        final entry = await getForDate(cityId: cityId, date: dateStr, methodKey: methodKey);
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
