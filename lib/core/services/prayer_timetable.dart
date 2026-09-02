import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'daily_prayer_times.dart';

/// The official Kurdistan Region (Ministry of Awqaf) prayer timetable bundled
/// as `assets/data/prayer_times.csv`.
///
/// This is the authority for the 21 cities it covers. Astronomical calculation
/// is only a fallback for anything it does not answer: for Erbil the two differ
/// by roughly 19 minutes at Fajr, so a user following the app would otherwise
/// pray noticeably before the local mosque.
///
/// The file is a perpetual timetable — dates are day-month (`1-Jan`) with no
/// year, so the same times apply every year.
class PrayerTimetable {
  PrayerTimetable._();

  static final PrayerTimetable instance = PrayerTimetable._();

  static const String _assetPath = 'assets/data/prayer_times.csv';
  static const List<String> _monthAbbreviations = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// city (lower-cased) -> "d-MMM" -> times for that day.
  Map<String, Map<String, _TimetableRow>>? _index;
  Future<void>? _loading;

  /// True once the timetable is available for synchronous lookups.
  bool get isLoaded => _index != null;

  /// Parses and indexes the timetable. Safe to call repeatedly and from several
  /// places at once; the work happens once.
  Future<void> ensureLoaded() {
    if (_index != null) return Future.value();
    return _loading ??= _load();
  }

  Future<void> _load() async {
    try {
      final raw = await rootBundle.loadString(_assetPath);
      final index = <String, Map<String, _TimetableRow>>{};

      for (final line in const LineSplitter().convert(raw)) {
        final parts = line.split(',');
        if (parts.length < 8) continue;

        final city = parts[0].trim();
        if (city.isEmpty || city.toLowerCase() == 'city') continue; // header

        final row = _TimetableRow(
          fajr: parts[2].trim(),
          sunrise: parts[3].trim(),
          dhuhr: parts[4].trim(),
          asr: parts[5].trim(),
          maghrib: parts[6].trim(),
          isha: parts[7].trim(),
        );
        if (!row.isComplete) continue;

        index
            .putIfAbsent(city.toLowerCase(), () => <String, _TimetableRow>{})[
            parts[1].trim().toLowerCase()] = row;
      }

      _index = index;
    } catch (e) {
      // A missing or malformed asset must not break prayer times entirely —
      // callers fall back to calculation when lookup returns null.
      debugPrint('Could not load the prayer timetable: $e');
      _index = <String, Map<String, _TimetableRow>>{};
    } finally {
      _loading = null;
    }
  }

  /// Official times for [cityNameEn] on [date], or null when the timetable has
  /// no entry (unknown city, or not loaded yet).
  DailyPrayerTimes? lookup({required String cityNameEn, required DateTime date}) {
    final index = _index;
    if (index == null) return null;

    final cityRows = index[cityNameEn.toLowerCase()];
    if (cityRows == null) return null;

    var row = cityRows[_keyFor(date.month, date.day)];

    // The timetable is perpetual and has no 29 February. Reusing 28 February
    // keeps the leap day on the official timetable instead of dropping it to
    // calculation, which would shift Fajr by ~19 minutes for that one day.
    if (row == null && date.month == 2 && date.day == 29) {
      row = cityRows[_keyFor(2, 28)];
    }
    if (row == null) return null;

    DateTime? at(String hhmm) => _resolveTime(hhmm, date);

    final fajr = at(row.fajr);
    final sunrise = at(row.sunrise);
    final dhuhr = at(row.dhuhr);
    final asr = at(row.asr);
    final maghrib = at(row.maghrib);
    final isha = at(row.isha);

    // Partial rows are unusable: a half-filled day would silently mix official
    // and calculated times within the same day.
    if (fajr == null ||
        sunrise == null ||
        dhuhr == null ||
        asr == null ||
        maghrib == null ||
        isha == null) {
      return null;
    }

    return DailyPrayerTimes(
      fajr: fajr,
      sunrise: sunrise,
      dhuhr: dhuhr,
      asr: asr,
      maghrib: maghrib,
      isha: isha,
      source: PrayerTimesSource.officialTimetable,
    );
  }

  static String _keyFor(int month, int day) =>
      '$day-${_monthAbbreviations[month - 1]}'.toLowerCase();

  /// Parses "H:mm" / "HH:mm" into a local DateTime on [date].
  /// Returns null rather than throwing: one malformed cell should not abort
  /// scheduling for every remaining day.
  static DateTime? _resolveTime(String hhmm, DateTime date) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0].trim());
    final minute = int.tryParse(parts[1].trim());
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}

class _TimetableRow {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const _TimetableRow({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  bool get isComplete =>
      fajr.isNotEmpty &&
      sunrise.isNotEmpty &&
      dhuhr.isNotEmpty &&
      asr.isNotEmpty &&
      maghrib.isNotEmpty &&
      isha.isNotEmpty;
}
