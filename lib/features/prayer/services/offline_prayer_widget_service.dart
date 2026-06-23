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
    int year = date.year;
    int month = date.month;
    int day = date.day;

    if (month < 3) {
      year -= 1;
      month += 12;
    }

    int a = (year / 100).floor();
    int b = (a / 4).floor();
    int c = 2 - a + b;
    int e = (365.25 * (year + 4716)).floor();
    int f = (30.6001 * (month + 1)).floor();
    double jd = c + day + e + f - 1524.5;

    double l = jd - 1948440 + 10632;
    int n = ((l - 1) / 10631).floor();
    l = l - 10631 * n + 354;
    int j = (((10985 - l) / 5316).floor() * ((50 - l) / 4).floor()) +
        (((l - 70) / 4).floor() * ((10985 - l) / 5316).floor());
    l = l - ((30 - j) / 15).floor() * ((17719 - j) / 328).floor() -
        ((j / 16).floor() * ((j - 7) / 2).floor());
    int y = 30 * n + j - 30;
    int m = ((l / 29.5001).floor() + 1).floor();
    int d = (l - (29.5001 * (m - 1)).floor() + 1).floor();

    final hijriMonths = [
      'المحرّم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوّال',
      'ذو القعدة',
      'ذو الحجة'
    ];

    if (m < 1 || m > 12) m = 1;

    String toArabicDigits(int number) {
      final digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      return number.toString().split('').map((char) {
        final val = int.tryParse(char);
        return val != null ? digits[val] : char;
      }).join('');
    }

    return '${toArabicDigits(d)} ${hijriMonths[m - 1]} ${toArabicDigits(y)}';
  }
}
