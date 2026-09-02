/// Where a day's prayer times came from.
enum PrayerTimesSource {
  /// The bundled Kurdistan Region (Ministry of Awqaf) timetable.
  officialTimetable,

  /// Astronomical calculation, using the user's chosen method.
  calculated,
}

/// One day of prayer times, in local time.
///
/// Deliberately mirrors the field names of adhan's `PrayerTimes` so the two are
/// interchangeable at call sites. Unlike adhan's type, these are already local,
/// so a `.toLocal()` on them is a harmless no-op.
class DailyPrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final PrayerTimesSource source;

  const DailyPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.source,
  });
}
