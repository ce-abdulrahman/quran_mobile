import 'package:adhan/adhan.dart';

import 'daily_prayer_times.dart';
import 'prayer_timetable.dart';

/// The single source of truth for how prayer times are calculated.
///
/// Both the times shown in the UI and the times the azan is scheduled for go
/// through here. They used to compute independently — the UI honoured the
/// user's chosen method while the notification scheduler hardcoded Muslim World
/// League — so the displayed time and the azan could disagree by up to ~20
/// minutes (Umm al-Qura, for instance, derives Isha from a 90 minute interval
/// rather than an angle).
class PrayerCalculation {
  PrayerCalculation._();

  /// Method used when the stored preference is missing or unrecognised.
  static const String defaultMethodKey = 'kurdistan';

  /// Asr is currently fixed to Shafi for every user; Hanafi puts Asr roughly
  /// 45-60 minutes later. Kept in one place so exposing it as a setting later
  /// is a single change rather than a hunt through the codebase.
  static const Madhab defaultMadhab = Madhab.shafi;

  /// Maps a stored `calculationMethod` preference onto adhan parameters.
  ///
  /// Unknown keys fall back to Muslim World League rather than throwing: the
  /// value comes from persisted preferences and may predate a rename.
  static CalculationParameters parametersFor(
    String? methodKey, {
    Madhab madhab = defaultMadhab,
  }) {
    final CalculationParameters params;
    switch (methodKey) {
      case 'egyptian':
        params = CalculationMethod.egyptian.getParameters();
      case 'karachi':
        params = CalculationMethod.karachi.getParameters();
      case 'umm_al_qura':
        params = CalculationMethod.umm_al_qura.getParameters();
      case 'gulf':
        params = CalculationMethod.dubai.getParameters();
      case 'moonsighting_committee':
        params = CalculationMethod.moon_sighting_committee.getParameters();
      case 'isna':
      case 'north_america':
        params = CalculationMethod.north_america.getParameters();
      case 'turkey':
        params = CalculationMethod.turkey.getParameters();
      case 'singapore':
        params = CalculationMethod.singapore.getParameters();
      case 'tehran':
        params = CalculationMethod.tehran.getParameters();
      case 'shia':
        params = CalculationMethod.other.getParameters();
      // 'kurdistan' (the default) follows the Kurdistan Region Ministry of
      // Awqaf, which matches Muslim World League: Fajr 18.0, Isha 17.0.
      case 'kurdistan':
      case 'muslim_world_league':
      default:
        params = CalculationMethod.muslim_world_league.getParameters();
    }

    params.madhab = madhab;
    return params;
  }

  /// Astronomically calculated prayer times for [date].
  static DailyPrayerTimes forDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    required String? methodKey,
    Madhab madhab = defaultMadhab,
  }) {
    final times = PrayerTimes(
      Coordinates(latitude, longitude),
      DateComponents(date.year, date.month, date.day),
      parametersFor(methodKey, madhab: madhab),
    );

    return DailyPrayerTimes(
      fajr: times.fajr.toLocal(),
      sunrise: times.sunrise.toLocal(),
      dhuhr: times.dhuhr.toLocal(),
      asr: times.asr.toLocal(),
      maghrib: times.maghrib.toLocal(),
      isha: times.isha.toLocal(),
      source: PrayerTimesSource.calculated,
    );
  }

  /// Prayer times for [date], preferring the official timetable.
  ///
  /// This is what every surface should call — the prayer times screen, the azan
  /// scheduler and the home-screen widget — so they cannot disagree. Falls back
  /// to [forDate] when the timetable has no entry (a city it doesn't cover, or
  /// it hasn't finished loading).
  static DailyPrayerTimes resolve({
    required String cityNameEn,
    required double latitude,
    required double longitude,
    required DateTime date,
    required String? methodKey,
    Madhab madhab = defaultMadhab,
  }) {
    final official = PrayerTimetable.instance.lookup(
      cityNameEn: cityNameEn,
      date: date,
    );
    if (official != null) return official;

    return forDate(
      latitude: latitude,
      longitude: longitude,
      date: date,
      methodKey: methodKey,
      madhab: madhab,
    );
  }
}
