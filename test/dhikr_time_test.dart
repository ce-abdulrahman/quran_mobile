import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/providers/dhikr_time.dart';

void main() {
  group('dhikrDayKey', () {
    test('formats as zero-padded YYYY-MM-DD', () {
      expect(dhikrDayKey(DateTime(2026, 1, 5)), '2026-01-05');
      expect(dhikrDayKey(DateTime(2026, 12, 31)), '2026-12-31');
    });

    test('uses the local day, not a fixed Baghdad offset', () {
      // Regression: the day key was DateTime.now().toUtc() + 3h, so for anyone
      // outside UTC+3 the day rolled over at the wrong local hour — 22:00 in
      // Germany, 16:00 in the US — and late-evening dhikr counted towards
      // tomorrow while the streak broke overnight.
      final lateEvening = DateTime(2026, 3, 10, 23, 30);
      expect(dhikrDayKey(lateEvening), '2026-03-10');

      final justAfterMidnight = DateTime(2026, 3, 11, 0, 15);
      expect(dhikrDayKey(justAfterMidnight), '2026-03-11');
    });

    test('the whole local day maps to one key', () {
      const day = 14;
      final keys = <String>{};
      for (var hour = 0; hour < 24; hour++) {
        keys.add(dhikrDayKey(DateTime(2026, 8, day, hour, 30)));
      }
      expect(keys, {'2026-08-14'});
    });
  });

  group('dhikrPreviousDayKey', () {
    test('returns the day before', () {
      expect(dhikrPreviousDayKey(DateTime(2026, 3, 11)), '2026-03-10');
    });

    test('crosses month boundaries', () {
      expect(dhikrPreviousDayKey(DateTime(2026, 3, 1)), '2026-02-28');
    });

    test('crosses year boundaries', () {
      expect(dhikrPreviousDayKey(DateTime(2026, 1, 1)), '2025-12-31');
    });

    test('handles a leap day', () {
      expect(dhikrPreviousDayKey(DateTime(2028, 3, 1)), '2028-02-29');
    });
  });

  group('dhikrTapCooldown', () {
    test('allows fast dhikr rather than dropping real taps', () {
      // The main counter used to sit at 300ms, capping the user at ~3 taps per
      // second and silently discarding the rest.
      expect(dhikrTapCooldown.inMilliseconds, lessThanOrEqualTo(50));

      const tapsPerSecond = 6; // a realistic fast pace
      const gap = Duration(milliseconds: 1000 ~/ tapsPerSecond);
      expect(gap > dhikrTapCooldown, isTrue,
          reason: 'six taps a second must all be counted');
    });

    test('is still long enough to swallow a double-fire', () {
      expect(dhikrTapCooldown.inMilliseconds, greaterThan(0));
    });
  });
}
