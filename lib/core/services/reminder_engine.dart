import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../repositories/reminder_repository.dart';

class ReminderEngine {
  static final ReminderEngine _instance = ReminderEngine._internal();
  factory ReminderEngine() => _instance;
  ReminderEngine._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  
  // Channel details for smart reminders
  static const String _channelId = 'smart_reminders_channel';
  static const String _channelName = 'Smart Reminders';
  static const String _channelDesc = 'Context-aware notifications for daily tasbih goals and streaks';

  /// Maps reminder type to a unique integer base ID.
  int _getTypeCode(String type) {
    switch (type.toUpperCase()) {
      case 'MORNING': return 100;
      case 'AFTERNOON': return 200;
      case 'EVENING': return 300;
      case 'BEFORE_SLEEP': return 400;
      case 'DAILY_GOAL': return 500;
      case 'STREAK': return 600;
      case 'ACHIEVEMENT': return 700;
      case 'INACTIVITY': return 800;
      case 'CUSTOM': return 900;
      default: return 1000;
    }
  }

  /// Cancels all notifications scheduled by this engine.
  Future<void> cancelAll() async {
    // Cancel IDs in our expected range (100 to 1100)
    for (int base = 100; base <= 1000; base += 100) {
      await _plugin.cancel(base); // Daily repeating
      for (int weekday = 1; weekday <= 7; weekday++) {
        await _plugin.cancel(base + weekday); // Weekly repeating on specific days
      }
    }
  }

  /// Schedules local notifications based on synced schedules from the server.
  Future<void> scheduleReminders(List<Map<String, dynamic>> schedule) async {
    // 1. Cancel existing reminders to avoid duplicates
    await cancelAll();

    // 2. Schedule each reminder from the server payload
    for (final item in schedule) {
      final type = item['type'] as String? ?? 'CUSTOM';
      final icon = item['icon'] as String? ?? '🔔';
      final title = item['title'] as String? ?? '';
      final body = item['body'] as String? ?? '';
      final scheduledTime = item['scheduled_time'] as String?; // Format: "HH:MM"
      final frequency = item['frequency'] as String? ?? 'daily';
      final customDays = (item['custom_days'] as List<dynamic>?)?.cast<int>() ?? [];
      final timezone = item['timezone'] as String? ?? 'Asia/Baghdad';
      final metadata = item['metadata'] as Map<String, dynamic>?;

      if (scheduledTime == null || scheduledTime.isEmpty) {
        continue;
      }

      final timeParts = scheduledTime.split(':');
      if (timeParts.length < 2) continue;
      final hour = int.tryParse(timeParts[0]) ?? 8;
      final minute = int.tryParse(timeParts[1]) ?? 0;

      // Safe timezone loading
      tz.Location location;
      try {
        location = tz.getLocation(timezone);
      } catch (e) {
        location = tz.local;
      }

      final baseId = _getTypeCode(type);
      final colorCode = metadata != null && metadata['color'] != null
          ? int.tryParse((metadata['color'] as String).replaceFirst('#', '0xFF'))
          : null;

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: colorCode != null ? Color(colorCode) : const Color(0xFF1AB66D),
        playSound: true,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(
          body,
          contentTitle: '$icon $title',
        ),
      );

      final notifDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      // Handle recurrence
      if (frequency == 'daily') {
        final scheduledDate = _nextInstanceOfTime(hour, minute, location);
        await _plugin.zonedSchedule(
          baseId,
          title,
          body,
          scheduledDate,
          notifDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // repeat daily
          payload: '$type|${item['notification_id'] ?? ''}',
        );
      } else {
        // Weekdays, weekends or custom days
        List<int> targetDays = [];
        if (frequency == 'weekdays') {
          targetDays = [1, 2, 3, 4, 5]; // Mon to Fri
        } else if (frequency == 'weekends') {
          targetDays = [6, 7]; // Sat and Sun
        } else if (frequency == 'custom') {
          targetDays = customDays;
        }

        for (final day in targetDays) {
          final scheduledDate = _nextInstanceOfWeekdayTime(day, hour, minute, location);
          await _plugin.zonedSchedule(
            baseId + day,
            title,
            body,
            scheduledDate,
            notifDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // repeat weekly on this day
            payload: '$type|${item['notification_id'] ?? ''}',
          );
        }
      }
    }
  }

  /// Calculates the next instance of a daily time in the target timezone.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute, tz.Location location) {
    final now = tz.TZDateTime.now(location);
    var scheduledDate = tz.TZDateTime(location, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Calculates the next instance of a specific weekday and time in the target timezone.
  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, int hour, int minute, tz.Location location) {
    final now = tz.TZDateTime.now(location);
    var scheduledDate = tz.TZDateTime(location, now.year, now.month, now.day, hour, minute);
    
    // Find next day matching the target ISO weekday (1 = Monday, 7 = Sunday)
    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Configure notification click callbacks to send analytics logs back to the server.
  static Future<void> setupNotificationResponseHandler(ReminderRepository repository) async {
    final plugin = FlutterLocalNotificationsPlugin();
    
    // Check if app was opened from a notification click
    final details = await plugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      final payload = details.notificationResponse?.payload;
      if (payload != null) {
        _handlePayload(payload, repository);
      }
    }

    // Listen to background or foreground clicks
    plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          _handlePayload(payload, repository);
        }
      },
    );
  }

  static void _handlePayload(String payload, ReminderRepository repository) {
    final parts = payload.split('|');
    if (parts.length >= 2) {
      final type = parts[0];
      final notificationId = parts[1];
      if (notificationId.isNotEmpty) {
        repository.markOpened(
          notificationId: notificationId,
          notificationType: type,
          timezone: tz.local.name,
        );
      }
    }
  }
}
