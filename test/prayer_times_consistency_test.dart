import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/services/daily_prayer_times.dart';
import 'package:quran_mobile/core/services/prayer_calculation.dart';
import 'package:quran_mobile/core/services/prayer_timetable.dart';

/// Erbil, from assets/data/prayer_times.csv:
///   Erbil,1-Jan,6:02,7:21,12:16,14:45,17:06,18:21
const _erbilLat = 36.1901;
const _erbilLng = 44.0091;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // rootBundle needs the real asset, which the test binding can load.
    await PrayerTimetable.instance.ensureLoaded();
  });

  group('PrayerTimetable', () {
    test('loads the bundled official timetable', () {
      expect(PrayerTimetable.instance.isLoaded, isTrue);
    });

    test('returns the official Erbil times for 1 January', () {
      final times = PrayerTimetable.instance.lookup(
        cityNameEn: 'Erbil',
        date: DateTime(2026, 1, 1),
      );

      expect(times, isNotNull);
      expect(times!.source, PrayerTimesSource.officialTimetable);
      expect('${times.fajr.hour}:${times.fajr.minute}', '6:2');
      expect('${times.sunrise.hour}:${times.sunrise.minute}', '7:21');
      expect('${times.dhuhr.hour}:${times.dhuhr.minute}', '12:16');
      expect('${times.asr.hour}:${times.asr.minute}', '14:45');
      expect('${times.maghrib.hour}:${times.maghrib.minute}', '17:6');
      expect('${times.isha.hour}:${times.isha.minute}', '18:21');
    });

    test('city lookup is case-insensitive', () {
      final lower = PrayerTimetable.instance
          .lookup(cityNameEn: 'erbil', date: DateTime(2026, 1, 1));
      expect(lower, isNotNull);
    });

    test('unknown cities fall through rather than throwing', () {
      final times = PrayerTimetable.instance
          .lookup(cityNameEn: 'Reykjavik', date: DateTime(2026, 1, 1));
      expect(times, isNull);
    });

    test('29 February reuses 28 February instead of dropping to calculation',
        () {
      // The timetable is perpetual and has no leap day.
      final feb28 = PrayerTimetable.instance
          .lookup(cityNameEn: 'Erbil', date: DateTime(2028, 2, 28));
      final feb29 = PrayerTimetable.instance
          .lookup(cityNameEn: 'Erbil', date: DateTime(2028, 2, 29));

      expect(feb28, isNotNull);
      expect(feb29, isNotNull, reason: 'leap day must stay on the timetable');
      expect(feb29!.source, PrayerTimesSource.officialTimetable);
      expect(feb29.fajr.hour, feb28!.fajr.hour);
      expect(feb29.fajr.minute, feb28.fajr.minute);
      expect(feb29.fajr.day, 29, reason: 'must be dated to the requested day');
    });

    test('the same times apply every year (perpetual timetable)', () {
      final y2026 = PrayerTimetable.instance
          .lookup(cityNameEn: 'Erbil', date: DateTime(2026, 3, 10))!;
      final y2030 = PrayerTimetable.instance
          .lookup(cityNameEn: 'Erbil', date: DateTime(2030, 3, 10))!;

      expect(y2030.fajr.hour, y2026.fajr.hour);
      expect(y2030.fajr.minute, y2026.fajr.minute);
      expect(y2026.fajr.year, 2026);
      expect(y2030.fajr.year, 2030);
    });
  });

  group('PrayerCalculation.resolve', () {
    test('prefers the official timetable over calculation', () {
      final resolved = PrayerCalculation.resolve(
        cityNameEn: 'Erbil',
        latitude: _erbilLat,
        longitude: _erbilLng,
        date: DateTime(2026, 1, 1),
        methodKey: 'kurdistan',
      );

      expect(resolved.source, PrayerTimesSource.officialTimetable);
      expect(resolved.fajr.hour, 6);
      expect(resolved.fajr.minute, 2);
    });

    test('the chosen method does not override the official timetable', () {
      // Regression: the azan scheduler used to calculate independently, so a
      // non-default method moved the azan away from the official times.
      for (final method in ['kurdistan', 'egyptian', 'umm_al_qura', 'turkey']) {
        final resolved = PrayerCalculation.resolve(
          cityNameEn: 'Erbil',
          latitude: _erbilLat,
          longitude: _erbilLng,
          date: DateTime(2026, 1, 1),
          methodKey: method,
        );

        expect(resolved.source, PrayerTimesSource.officialTimetable,
            reason: 'method $method should still use the official timetable');
        expect(resolved.fajr.minute, 2, reason: 'method $method');
      }
    });

    test('falls back to calculation for cities off the timetable', () {
      final resolved = PrayerCalculation.resolve(
        cityNameEn: 'Reykjavik',
        latitude: 64.1466,
        longitude: -21.9426,
        date: DateTime(2026, 1, 1),
        methodKey: 'kurdistan',
      );

      expect(resolved.source, PrayerTimesSource.calculated);
    });

    test('the fallback honours the chosen method', () {
      // Uses Erbil's latitude directly through the calculation path. A high
      // latitude would not work here: above ~60 degrees the sun never reaches
      // 18 degrees below the horizon in summer, so every method collapses onto
      // the same high-latitude rule and the angles stop mattering.
      DailyPrayerTimes calcWith(String method) => PrayerCalculation.forDate(
            latitude: _erbilLat,
            longitude: _erbilLng,
            date: DateTime(2026, 6, 1),
            methodKey: method,
          );

      // Egyptian uses a 19.5 degree Fajr angle against MWL's 18.0.
      expect(calcWith('egyptian').source, PrayerTimesSource.calculated);
      expect(
        calcWith('egyptian').fajr,
        isNot(equals(calcWith('kurdistan').fajr)),
      );
    });

    test('an unrecognised method falls back instead of throwing', () {
      final resolved = PrayerCalculation.resolve(
        cityNameEn: 'Reykjavik',
        latitude: 64.1466,
        longitude: -21.9426,
        date: DateTime(2026, 6, 1),
        methodKey: 'a-method-that-no-longer-exists',
      );

      expect(resolved.source, PrayerTimesSource.calculated);
    });
  });

  group('every city the app offers is on the official timetable', () {
    test('all 21 cities resolve to the timetable, not calculation', () async {
      final csv = await rootBundle.loadString('assets/data/prayer_times.csv');
      final cities = csv
          .split('\n')
          .skip(1)
          .map((l) => l.split(',').first.trim())
          .where((c) => c.isNotEmpty)
          .toSet();

      expect(cities.length, 21);

      for (final city in cities) {
        final times = PrayerTimetable.instance
            .lookup(cityNameEn: city, date: DateTime(2026, 7, 4));
        expect(times, isNotNull, reason: '$city missing from the index');
      }
    });
  });
}
