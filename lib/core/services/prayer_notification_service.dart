import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';
import '../providers/prayer_times_provider.dart';
import 'notification_coordinator.dart';
import 'prayer_calculation.dart';
import 'prayer_timetable.dart';


class PrayerNotificationService {
  static final PrayerNotificationService _instance = PrayerNotificationService._internal();
  factory PrayerNotificationService() => _instance;
  PrayerNotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = NotificationChannels.prayerCh;
  static const _channelName = 'ئاگادارکردنەوەی بانگدان';
  static const _channelDesc = 'لێدانی دەنگی بانگ لە کاتی نوێژەکاندا';

  /// Register the dynamic sound channel for a given adhan sound.
  /// Android channels are immutable — sound can only be set at channel creation.
  /// We pre-register channels for every sound variant so the correct azan plays.
  Future<void> _ensureSoundChannel(String channelId, String channelName, String channelDesc, bool playSound, String adhanSound) async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    final AndroidNotificationSound? sound = playSound && adhanSound.isNotEmpty
        ? RawResourceAndroidNotificationSound(adhanSound)
        : null;

    final channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDesc,
      importance: Importance.max,
      playSound: playSound,
      sound: sound,
      // Route the azan through the ALARM stream, not the notification stream:
      // it follows the alarm volume (which people keep audible) and survives
      // silent/DND profiles that still allow alarms. Like sound, this is fixed
      // at channel creation time — Android channels are immutable.
      audioAttributesUsage: AudioAttributesUsage.alarm,
      enableVibration: true,
      enableLights: true,
      ledColor: const Color(0xFFCD9D27),
    );

    await androidPlugin.createNotificationChannel(channel);
  }

  /// Whether Android currently lets the app schedule exact alarms (a special
  /// app access on Android 12+). Checks only — asking here would throw the user
  /// into a system settings screen mid-startup, so the prompt lives in the
  /// prayer settings UI via [requestExactAlarmPermission] instead.
  Future<bool> canScheduleExactAlarms() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return true;

    try {
      return await androidPlugin.canScheduleExactNotifications() ?? true;
    } catch (e) {
      debugPrint('Exact alarm permission check failed: $e');
      return false;
    }
  }

  /// Opens the system screen where the user grants the exact-alarm access.
  Future<bool> requestExactAlarmPermission() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return true;

    try {
      return await androidPlugin.requestExactAlarmsPermission() ?? false;
    } catch (e) {
      debugPrint('Exact alarm permission request failed: $e');
      return false;
    }
  }

  /// Removes the pre-`_v2` channels so the app doesn't leave a duplicate
  /// "ئاگادارکردنەوەی بانگدان" entry behind in the system notification settings.
  Future<void> _deleteLegacyChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    const legacyVariants = ['azan', 'azan_makkah', 'azan_medina', 'azan_egypt', 'silent'];
    for (final variant in legacyVariants) {
      try {
        await androidPlugin.deleteNotificationChannel('${_channelId}_$variant');
      } catch (e) {
        debugPrint('Could not delete legacy channel ${_channelId}_$variant: $e');
      }
    }
  }

  Future<void> schedulePrayerNotifications({
    required KurdishCity city,
    required Map<String, bool> toggles,
    required bool isAzanEnabled,
    required String adhanSound, // New parameter for selected adhan sound
    /// The user's chosen calculation method, so the azan fires at the same
    /// times the app displays. Required rather than defaulted: silently
    /// falling back to a default here is what caused the two to diverge.
    required String calculationMethod,
  }) async {
    if (kIsWeb || Platform.environment.containsKey('FLUTTER_TEST')) {
      debugPrint('Skipping prayer notifications scheduling in web/test environment.');
      return;
    }

    // Cancel previous scheduled prayer notifications (range 10000 to 10100)
    for (int id = 10000; id < 10100; id++) {
      await _plugin.cancel(id);
    }

    if (!isAzanEnabled) {
      debugPrint('Azan notifications are globally disabled.');
      return;
    }

    // Scheduling must not silently fall back to calculated times just because
    // the timetable hasn't finished loading — that is a ~19 minute error.
    await PrayerTimetable.instance.ensureLoaded();

    // Pre-register the dynamic sound channel before scheduling.
    // Android channels are immutable: sound must be set at channel creation.
    final bool willPlaySound = adhanSound != 'none';
    final String variant = willPlaySound ? adhanSound : 'silent';
    // The `_v2` marker forces a fresh channel for users upgrading from a build
    // whose channels were created on the notification audio stream. Without a
    // new id, Android keeps the old (quieter) channel and the fix is a no-op.
    final String channelId = '${_channelId}_v2_$variant';
    await _deleteLegacyChannels();
    await _ensureSoundChannel(channelId, _channelName, _channelDesc, willPlaySound, adhanSound);

    // Prayer times must fire *on time*. Inexact alarms get batched into Doze
    // maintenance windows and can drift by many minutes — which is exactly when
    // the phone is idle, i.e. most prayer times. Use exact alarms when the user
    // has granted the access, and fall back to inexact otherwise so the azan
    // still arrives (late) rather than failing to schedule at all.
    final bool canUseExact = await canScheduleExactAlarms();
    final AndroidScheduleMode scheduleMode = canUseExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    if (!canUseExact) {
      debugPrint(
        'Exact alarms not permitted — azan notifications may be delayed by the system.',
      );
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

    for (int day = 0; day < 7; day++) {
      final targetDate = now.add(Duration(days: day));

      // Exactly what the prayer times screen shows — see [PrayerCalculation].
      // This used to hardcode Muslim World League and ignore both the official
      // timetable and the user's chosen method, so the azan could fire ~19
      // minutes before the time displayed in the app.
      final prayerTimes = PrayerCalculation.resolve(
        cityNameEn: city.nameEn,
        latitude: city.latitude,
        longitude: city.longitude,
        date: targetDate,
        methodKey: calculationMethod,
      );

      final Map<String, DateTime> times = {
        'Fajr': prayerTimes.fajr,
        'Dhuhr': prayerTimes.dhuhr,
        'Asr': prayerTimes.asr,
        'Maghrib': prayerTimes.maghrib,
        'Isha': prayerTimes.isha,
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

        final bool playSound = willPlaySound;
        final androidSound = playSound && adhanSound.isNotEmpty
            ? RawResourceAndroidNotificationSound(adhanSound)
            : null;
        final iOSSound = playSound && adhanSound.isNotEmpty
            ? '$adhanSound.mp3'
            : null;

        // Use the pre-registered channel (already created above).
        final String dynamicChannelId = channelId;

        try {
          final notificationDetails = NotificationDetails(
            android: AndroidNotificationDetails(
              dynamicChannelId,
              _channelName,
              channelDescription: _channelDesc,
              importance: Importance.max,
              priority: Priority.high,
              playSound: playSound,
              sound: androidSound,
              audioAttributesUsage: AudioAttributesUsage.alarm,
              category: AndroidNotificationCategory.alarm,
              icon: '@mipmap/ic_launcher',
              largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
              color: const Color(0xFFCD9D27),
              enableVibration: true,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: playSound,
              sound: iOSSound,
            ),
          );

          await _plugin.zonedSchedule(
            notificationId,
            'کاتی نوێژی $kuName 🕋',
            'کاتی نوێژ بۆ شاری ${city.nameKu} هاتووە. (حی علی الصلاة)',
            scheduledTime,
            notificationDetails,
            androidScheduleMode: scheduleMode,
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
