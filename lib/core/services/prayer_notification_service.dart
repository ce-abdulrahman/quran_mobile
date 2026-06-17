import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:adhan/adhan.dart';
import '../providers/prayer_times_provider.dart';
import 'notification_coordinator.dart';

class PrayerNotificationService {
  static final PrayerNotificationService _instance = PrayerNotificationService._internal();
  factory PrayerNotificationService() => _instance;
  PrayerNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = NotificationChannels.prayerCh;
  static const _channelName = 'ئاگادارکردنەوەی بانگدان';
  static const _channelDesc = 'لێدانی دەنگی بانگ لە کاتی نوێژەکاندا';

  Future<void> schedulePrayerNotifications({
    required KurdishCity city,
    required Map<String, bool> toggles,
    required bool isAzanEnabled,
  }) async {
    // Cancel previous scheduled prayer notifications (range 10000 to 10100)
    for (int id = 10000; id < 10100; id++) {
      await _plugin.cancel(id);
    }

    if (!isAzanEnabled) {
      debugPrint('Azan notifications are globally disabled.');
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    final List<String> prayerKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final Map<String, String> prayerNamesKu = {
      'Fajr': 'بەیانی',
      'Dhuhr': 'نیوەڕۆ',
      'Asr': 'عەسڕ',
      'Maghrib': 'مەغریب',
      'Isha': 'عیشا',
    };

    int notificationId = 10000;

    // Use adhan library calculation params
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final coordinates = Coordinates(city.latitude, city.longitude);

    for (int day = 0; day < 7; day++) {
      final targetDate = now.add(Duration(days: day));
      final dateComponents = DateComponents(targetDate.year, targetDate.month, targetDate.day);
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

      final Map<String, DateTime> times = {
        'Fajr': prayerTimes.fajr.toLocal(),
        'Dhuhr': prayerTimes.dhuhr.toLocal(),
        'Asr': prayerTimes.asr.toLocal(),
        'Maghrib': prayerTimes.maghrib.toLocal(),
        'Isha': prayerTimes.isha.toLocal(),
      };

      for (int i = 0; i < prayerKeys.length; i++) {
        final key = prayerKeys[i];
        final isEnabled = toggles[key] ?? true;
        if (!isEnabled) continue;

        final prayerTime = times[key]!;
        final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

        // Schedule only if the prayer time is in the future
        if (scheduledTime.isBefore(now)) {
          continue;
        }

        final kuName = prayerNamesKu[key] ?? key;

        try {
          await _plugin.zonedSchedule(
            notificationId,
            'کاتی نوێژی $kuName 🕋',
            'کاتی نوێژ بۆ شاری ${city.nameKu} هاتووە. (حی علی الصلاة)',
            scheduledTime,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                _channelId,
                _channelName,
                channelDescription: _channelDesc,
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
                sound: RawResourceAndroidNotificationSound('azan'),
                icon: '@mipmap/ic_launcher',
                largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                color: Color(0xFFCD9D27),
                enableVibration: true,
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                sound: 'azan.wav',
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (e) {
          debugPrint('Error scheduling prayer notification $notificationId: $e');
        }

        notificationId++;
      }
    }
    debugPrint('Scheduled prayer notifications up to ID: ${notificationId - 1}');
  }
}
