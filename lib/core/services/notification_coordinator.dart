import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NotificationChannels — IDs & channel constants for all 9 notification types
// ─────────────────────────────────────────────────────────────────────────────

class NotificationChannels {
  const NotificationChannels._();

  // Channel IDs (base IDs — prayer uses +offset per prayer type)
  static const int dailyAyah    = 1001; // existing, managed by NotificationService
  static const int prayerBase   = 2000; // +0..4 per prayer (Fajr, Dhuhr, Asr, Maghrib, Isha)
  static const int memorization = 3001;
  static const int reviewBase   = 3100; // review reminder
  static const int wird         = 4001;
  static const int tasbih       = 5001;

  // Channel string IDs (Android)
  static const String prayerCh      = 'quran_prayer_reminder';
  static const String memorizationCh = 'quran_memorization_reminder';
  static const String reviewCh       = 'quran_memorization_reviews';
  static const String wirdCh         = 'quran_daily_wird';
  static const String tasbihCh       = 'quran_tasbih_reminder';

  // SharedPreferences keys
  static const String prayerEnabledKey      = 'notif_prayer_enabled';
  static const String memorizationEnabledKey = 'notif_memo_enabled';
  static const String reviewEnabledKey       = 'notif_review_enabled';
  static const String wirdEnabledKey         = 'notif_wird_enabled';
  static const String tasbihEnabledKey       = 'notif_tasbih_enabled';
  static const String tasbihHourKey          = 'notif_tasbih_hour';
  static const String tasbihMinuteKey        = 'notif_tasbih_minute';
  static const String reviewHourKey          = 'notif_review_hour';
  static const String reviewMinuteKey        = 'notif_review_minute';
  static const String wirdHourKey            = 'notif_wird_hour';
  static const String wirdMinuteKey          = 'notif_wird_minute';
  static const String memorizationHourKey    = 'notif_memo_hour';
  static const String memorizationMinuteKey  = 'notif_memo_minute';
}

// ─────────────────────────────────────────────────────────────────────────────
// NotificationCoordinator
//
// Central coordinator for all NEW notification channels introduced in V2.
// The existing daily-verse channel stays managed by NotificationService.
// This coordinator adds:
//   1. Prayer time reminders (offline — no API required)
//   2. Memorization session reminders
//   3. Review/SRS reminders
//   4. Daily Wird reminders
//   5. Tasbih session reminders
// ─────────────────────────────────────────────────────────────────────────────

class NotificationCoordinator {
  static final NotificationCoordinator _instance =
      NotificationCoordinator._internal();
  factory NotificationCoordinator() => _instance;
  NotificationCoordinator._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ─── Android Channel Definitions ─────────────────────────────────────────

  static const _prayerChannel = AndroidNotificationChannel(
    NotificationChannels.prayerCh,
    'تکایەی نوێژ',
    description: 'کاتی نوێژ چوونی ئاگادارکردنەوە',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
    ledColor: Color(0xFF1AB66D),
  );

  static const _memorizeChannel = AndroidNotificationChannel(
    NotificationChannels.memorizationCh,
    'یادکردنەوەی حفز',
    description: 'یادکردنەوەی کاتی حفز',
    importance: Importance.high,
    playSound: true,
  );

  static const _reviewChannel = AndroidNotificationChannel(
    NotificationChannels.reviewCh,
    'یادکردنەوەی پێداچوونەوە',
    description: 'کاتی پێداچوونەوە لەسەر ئایەتەکانی حفزکراو',
    importance: Importance.high,
    playSound: true,
  );

  static const _wirdChannel = AndroidNotificationChannel(
    NotificationChannels.wirdCh,
    'وردی ڕۆژانە',
    description: 'یادکردنەوەی وردی ڕۆژانە',
    importance: Importance.defaultImportance,
    playSound: true,
  );

  static const _tasbihChannel = AndroidNotificationChannel(
    NotificationChannels.tasbihCh,
    'یادکردنەوەی تەسبیح',
    description: 'یادکردنەوەی کاتی تەسبیح',
    importance: Importance.defaultImportance,
    playSound: false,
  );

  // ─── Initialize all new channels ─────────────────────────────────────────

  Future<void> initChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    for (final channel in [
      _prayerChannel,
      _memorizeChannel,
      _reviewChannel,
      _wirdChannel,
      _tasbihChannel,
    ]) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  // ─── Prayer Time Reminder ─────────────────────────────────────────────────

  /// Schedule a prayer time reminder.
  /// [prayerIndex]: 0=Fajr, 1=Sunrise, 2=Dhuhr, 3=Asr, 4=Maghrib, 5=Isha
  Future<void> schedulePrayerReminder({
    required int prayerIndex,
    required String prayerName,
    required DateTime prayerTime,
    int minutesBefore = 0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(NotificationChannels.prayerEnabledKey) ?? true)) return;

    final notifTime = prayerTime.subtract(Duration(minutes: minutesBefore));
    if (notifTime.isBefore(DateTime.now())) return; // Skip past times

    final tzTime = tz.TZDateTime.from(notifTime, tz.local);
    final notifId = NotificationChannels.prayerBase + prayerIndex;

    await _plugin.zonedSchedule(
      notifId,
      '🕌 $prayerName',
      minutesBefore > 0
          ? 'کاتی $prayerName نزیکایە — $minutesBefore خولەک دواتر'
          : 'کاتی $prayerName هاتوێت',
      tzTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.prayerCh,
          'تکایەی نوێژ',
          channelDescription: 'کاتی نوێژ چوونی ئاگادارکردنەوە',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF1AB66D),
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ─── Memorization Session Reminder ───────────────────────────────────────

  Future<void> scheduleMemorizationReminder({
    required int hour,
    required int minute,
  }) async {
    await cancelMemorizationReminder();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      NotificationChannels.memorization,
      '📖 کاتی حفز',
      'ئەمڕۆیشت حفزەکەت بکە — بەردەوام بە!',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.memorizationCh,
          'یادکردنەوەی حفز',
          channelDescription: 'یادکردنەوەی کاتی حفز',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF1AB66D),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ─── Review Reminder ──────────────────────────────────────────────────────

  Future<void> scheduleReviewReminder({
    required int hour,
    required int minute,
  }) async {
    await cancelReviewReminder();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      NotificationChannels.reviewBase,
      '🧠 پێداچوونەوەی حفز',
      'ئایەتی حفزکراوی ئەمڕۆت چاوەڕێدەکات — تەختکردنیان بکە!',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.reviewCh,
          'یادکردنەوەی پێداچوونەوە',
          channelDescription: 'کاتی پێداچوونەوە لەسەر ئایەتەکانی حفزکراو',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF1AB66D),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ─── Daily Wird Reminder ──────────────────────────────────────────────────

  Future<void> scheduleWirdReminder({
    required int hour,
    required int minute,
  }) async {
    await cancelWirdReminder();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      NotificationChannels.wird,
      '📿 وردی ڕۆژانە',
      'وردی ئەمڕۆی خوێندنەوەیت چاوەڕێدەکات',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.wirdCh,
          'وردی ڕۆژانە',
          channelDescription: 'یادکردنەوەی وردی ڕۆژانە',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF1AB66D),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ─── Tasbih Session Reminder ──────────────────────────────────────────────

  Future<void> scheduleTasbihReminder({
    required int hour,
    required int minute,
  }) async {
    await cancelTasbihReminder();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      NotificationChannels.tasbih,
      '🤲 تەسبیحی ڕۆژانە',
      'کاتی تەسبیحتەوە هاتوێت — بەیاری لەگەڵ ئاڵفووێنەکان!',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationChannels.tasbihCh,
          'یادکردنەوەی تەسبیح',
          channelDescription: 'یادکردنەوەی کاتی تەسبیح',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF1AB66D),
        ),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // ─── Cancellation Helpers ─────────────────────────────────────────────────

  Future<void> cancelPrayerReminder(int prayerIndex) async {
    await _plugin.cancel(NotificationChannels.prayerBase + prayerIndex);
  }

  Future<void> cancelAllPrayerReminders() async {
    for (int i = 0; i < 6; i++) {
      await _plugin.cancel(NotificationChannels.prayerBase + i);
    }
  }

  Future<void> cancelMemorizationReminder() async {
    await _plugin.cancel(NotificationChannels.memorization);
  }

  Future<void> cancelReviewReminder() async {
    await _plugin.cancel(NotificationChannels.reviewBase);
  }

  Future<void> cancelWirdReminder() async {
    await _plugin.cancel(NotificationChannels.wird);
  }

  Future<void> cancelTasbihReminder() async {
    await _plugin.cancel(NotificationChannels.tasbih);
  }

  /// Cancel all coordinator-managed notifications.
  Future<void> cancelAll() async {
    for (int i = 0; i < 6; i++) {
      await _plugin.cancel(NotificationChannels.prayerBase + i);
    }
    await _plugin.cancel(NotificationChannels.memorization);
    await _plugin.cancel(NotificationChannels.reviewBase);
    await _plugin.cancel(NotificationChannels.wird);
    await _plugin.cancel(NotificationChannels.tasbih);
  }

  // ─── Persistence Helpers ──────────────────────────────────────────────────

  static Future<void> saveReminderSettings({
    bool? prayerEnabled,
    bool? memorizationEnabled,
    bool? reviewEnabled,
    bool? wirdEnabled,
    bool? tasbihEnabled,
    int? tasbihHour,
    int? tasbihMinute,
    int? reviewHour,
    int? reviewMinute,
    int? wirdHour,
    int? wirdMinute,
    int? memorizationHour,
    int? memorizationMinute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (prayerEnabled != null) {
      await prefs.setBool(NotificationChannels.prayerEnabledKey, prayerEnabled);
    }
    if (memorizationEnabled != null) {
      await prefs.setBool(NotificationChannels.memorizationEnabledKey, memorizationEnabled);
    }
    if (reviewEnabled != null) {
      await prefs.setBool(NotificationChannels.reviewEnabledKey, reviewEnabled);
    }
    if (wirdEnabled != null) {
      await prefs.setBool(NotificationChannels.wirdEnabledKey, wirdEnabled);
    }
    if (tasbihEnabled != null) {
      await prefs.setBool(NotificationChannels.tasbihEnabledKey, tasbihEnabled);
    }
    if (tasbihHour != null) {
      await prefs.setInt(NotificationChannels.tasbihHourKey, tasbihHour);
    }
    if (tasbihMinute != null) {
      await prefs.setInt(NotificationChannels.tasbihMinuteKey, tasbihMinute);
    }
    if (reviewHour != null) {
      await prefs.setInt(NotificationChannels.reviewHourKey, reviewHour);
    }
    if (reviewMinute != null) {
      await prefs.setInt(NotificationChannels.reviewMinuteKey, reviewMinute);
    }
    if (wirdHour != null) {
      await prefs.setInt(NotificationChannels.wirdHourKey, wirdHour);
    }
    if (wirdMinute != null) {
      await prefs.setInt(NotificationChannels.wirdMinuteKey, wirdMinute);
    }
    if (memorizationHour != null) {
      await prefs.setInt(NotificationChannels.memorizationHourKey, memorizationHour);
    }
    if (memorizationMinute != null) {
      await prefs.setInt(NotificationChannels.memorizationMinuteKey, memorizationMinute);
    }
  }

  static Future<Map<String, dynamic>> loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'prayer_enabled':      prefs.getBool(NotificationChannels.prayerEnabledKey) ?? true,
      'memorization_enabled': prefs.getBool(NotificationChannels.memorizationEnabledKey) ?? false,
      'review_enabled':      prefs.getBool(NotificationChannels.reviewEnabledKey) ?? false,
      'wird_enabled':        prefs.getBool(NotificationChannels.wirdEnabledKey) ?? false,
      'tasbih_enabled':      prefs.getBool(NotificationChannels.tasbihEnabledKey) ?? false,
      'tasbih_hour':         prefs.getInt(NotificationChannels.tasbihHourKey) ?? 20,
      'tasbih_minute':       prefs.getInt(NotificationChannels.tasbihMinuteKey) ?? 0,
      'review_hour':         prefs.getInt(NotificationChannels.reviewHourKey) ?? 18,
      'review_minute':       prefs.getInt(NotificationChannels.reviewMinuteKey) ?? 0,
      'wird_hour':           prefs.getInt(NotificationChannels.wirdHourKey) ?? 6,
      'wird_minute':         prefs.getInt(NotificationChannels.wirdMinuteKey) ?? 30,
      'memorization_hour':   prefs.getInt(NotificationChannels.memorizationHourKey) ?? 8,
      'memorization_minute': prefs.getInt(NotificationChannels.memorizationMinuteKey) ?? 0,
    };
  }
}
