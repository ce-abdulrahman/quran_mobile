import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/prayer_widget_model.dart';
import '../providers/prayer_times_provider.dart';
import '../../../core/providers/prayer_times_provider.dart';

class OfflinePrayerWidgetService {
  static Future<PrayerWidgetModel> getWidgetData(Ref ref) async {
    final settings = ref.read(prayerTimesSettingsProvider);
    final city = settings.selectedCity;
    
    // Find the matching city in settings.cities to get the API ID
    final matchedCity = settings.cities.firstWhere(
      (c) => c.nameEn.toLowerCase() == city.nameEn.toLowerCase(),
      orElse: () => city,
    );
    final int cityId = matchedCity.id ?? 1;

    final today = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(today);

    final repo = ref.read(prayerTimesRepositoryProvider);
    final entry = await repo.getForDate(cityId: cityId, date: todayStr);

    final Map<String, String> prayerTimesMap = {};

    if (entry != null) {
      prayerTimesMap['Fajr'] = entry.fajr;
      prayerTimesMap['Sunrise'] = entry.sunrise;
      prayerTimesMap['Dhuhr'] = entry.dhuhr;
      prayerTimesMap['Asr'] = entry.asr;
      prayerTimesMap['Maghrib'] = entry.maghrib;
      prayerTimesMap['Isha'] = entry.isha;
    } else {
      // Fallback to adhan calculation engine
      final adhanTimes = ref.read(prayerTimesForDateProvider(today));
      String formatAdhanTime(DateTime dt) {
        return DateFormat('HH:mm').format(dt.toLocal());
      }
      prayerTimesMap['Fajr'] = formatAdhanTime(adhanTimes.fajr);
      prayerTimesMap['Sunrise'] = formatAdhanTime(adhanTimes.sunrise);
      prayerTimesMap['Dhuhr'] = formatAdhanTime(adhanTimes.dhuhr);
      prayerTimesMap['Asr'] = formatAdhanTime(adhanTimes.asr);
      prayerTimesMap['Maghrib'] = formatAdhanTime(adhanTimes.maghrib);
      prayerTimesMap['Isha'] = formatAdhanTime(adhanTimes.isha);
    }

    // Determine Next Prayer and Next Prayer Time
    DateTime parseHHMM(String hhmm, DateTime date) {
      final parts = hhmm.split(':');
      if (parts.length < 2) return date;
      return DateTime(
        date.year,
        date.month,
        date.day,
        int.tryParse(parts[0]) ?? 0,
        int.tryParse(parts[1]) ?? 0,
      );
    }

    final orderedPrayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    String nextPrayer = 'fajr';
    String nextPrayerTime = '';
    DateTime? nextPrayerDateTime;

    for (final pName in orderedPrayers) {
      final key = pName[0].toUpperCase() + pName.substring(1);
      final timeStr = prayerTimesMap[key] ?? '';
      if (timeStr.isNotEmpty) {
        final pTime = parseHHMM(timeStr, today);
        if (pTime.isAfter(today)) {
          nextPrayer = pName;
          nextPrayerTime = timeStr;
          nextPrayerDateTime = pTime;
          break;
        }
      }
    }

    // If no prayer is after now today, the next prayer is Fajr of tomorrow
    if (nextPrayerTime.isEmpty) {
      nextPrayer = 'fajr';
      final tomorrow = today.add(const Duration(days: 1));
      final tomorrowStr = DateFormat('yyyy-MM-dd').format(tomorrow);
      final tomorrowEntry = await repo.getForDate(cityId: cityId, date: tomorrowStr);

      if (tomorrowEntry != null) {
        nextPrayerTime = tomorrowEntry.fajr;
        nextPrayerDateTime = parseHHMM(nextPrayerTime, tomorrow);
      } else {
        final tomorrowAdhan = ref.read(prayerTimesForDateProvider(tomorrow));
        nextPrayerTime = DateFormat('HH:mm').format(tomorrowAdhan.fajr.toLocal());
        nextPrayerDateTime = parseHHMM(nextPrayerTime, tomorrow);
      }
    }

    // Format remaining time
    String remainingStr = '00:00:00';
    if (nextPrayerDateTime != null) {
      final diff = nextPrayerDateTime.difference(today);
      if (!diff.isNegative) {
        final hours = diff.inHours.toString().padLeft(2, '0');
        final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
        remainingStr = '$hours:$minutes:$seconds';
      }
    }

    String convertTo12Hour(String hhmm) {
      try {
        final parts = hhmm.split(':');
        if (parts.length < 2) return hhmm;
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour % 12 == 0 ? 12 : hour % 12;
        final displayMinute = minute.toString().padLeft(2, '0');
        return '$displayHour:$displayMinute $period';
      } catch (e) {
        return hhmm;
      }
    }

    if (settings.calculationMethod == 'kurdistan') {
      for (final key in prayerTimesMap.keys) {
        final val = prayerTimesMap[key];
        if (val != null) {
          prayerTimesMap[key] = convertTo12Hour(val);
        }
      }
      if (nextPrayerTime.isNotEmpty) {
        nextPrayerTime = convertTo12Hour(nextPrayerTime);
      }
    }

    // Build Hijri date locally
    final hijriDate = _getHijriDateString(today);
    final gregorianDate = DateFormat('d MMMM yyyy').format(today);

    return PrayerWidgetModel(
      nextPrayer: nextPrayer,
      nextPrayerTime: nextPrayerTime,
      nextPrayerRemaining: remainingStr,
      currentCity: city.nameKu,
      hijriDate: hijriDate,
      gregorianDate: gregorianDate,
      activePrayerMethod: settings.calculationMethod,
      prayerTimes: prayerTimesMap,
      timezone: 'Asia/Baghdad',
      utcOffset: 3.0,
      dstActive: false,
      versionHash: settings.versionHash,
    );
  }

  static String _getHijriDateString(DateTime date) {
    // Accurate Gregorian → Hijri conversion via Julian Day Number (JDN)
    // Reference: Dershowitz & Reingold "Calendrical Calculations"
    int gYear = date.year;
    int gMonth = date.month;
    int gDay = date.day;

    // Compute Julian Day Number from Gregorian date
    int a = ((14 - gMonth) / 12).floor();
    int y = gYear + 4800 - a;
    int m = gMonth + 12 * a - 3;

    int jdn = gDay +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;

    // Convert JDN to Hijri
    int l = jdn - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j =
        ((10985 - l) / 5316).floor() * ((50 * l) / 17719).floor() +
        (l / 5670).floor() * ((43 * l) / 15238).floor();
    l = l -
        ((30 - j) / 15).floor() * ((17719 * j) / 10985).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    int hYear = 30 * n + j - 30;
    int hMonth = (l / 28.5001).floor();
    if (hMonth > 12) hMonth = 12;
    int hDay = l - ((hMonth - 1) * 29.5001).floor();

    // Safety clamp
    if (hMonth < 1 || hMonth > 12) hMonth = 1;
    if (hDay < 1 || hDay > 30) hDay = 1;

    final hijriMonths = [
      'المحرّم',
      'صفر',
      'ربيع الأوّل',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوّال',
      'ذو القعدة',
      'ذو الحجة',
    ];

    String toArabicDigits(int number) {
      const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      return number.toString().split('').map((char) {
        final val = int.tryParse(char);
        return val != null ? digits[val] : char;
      }).join('');
    }

    return '${toArabicDigits(hDay)} ${hijriMonths[hMonth - 1]} ${toArabicDigits(hYear)}';
  }
}
