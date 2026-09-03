/// Shared timing rules for the tasbih counters.
///
/// These used to be duplicated per screen and had drifted apart: the main
/// counter dropped taps closer together than 300ms, the session counter had no
/// limit at all, and a third button used 50ms. Same gesture, three behaviours.
library;

/// Minimum gap between two counted taps.
///
/// Fast dhikr runs at roughly 4-6 taps per second, so this has to stay well
/// under 200ms or real taps get discarded. It exists only to swallow
/// double-fires and accidental repeats.
const Duration dhikrTapCooldown = Duration(milliseconds: 50);

/// The day a tap belongs to, in the user's own timezone.
///
/// This was previously pinned to Baghdad (UTC+3). For anyone outside Iraq the
/// day then rolled over at the wrong local hour — 22:00 in Germany, 16:00 in
/// the US — so evening dhikr counted towards the next day and streaks broke
/// while the user was still awake.
String dhikrDayKey([DateTime? at]) {
  final date = at ?? DateTime.now();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

/// The day key for the day before [at].
String dhikrPreviousDayKey([DateTime? at]) =>
    dhikrDayKey((at ?? DateTime.now()).subtract(const Duration(days: 1)));
