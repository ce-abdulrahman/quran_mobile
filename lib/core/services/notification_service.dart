import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Daily Verse Notification Service
// ─────────────────────────────────────────────────────────────────────────────

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const _notifEnabledKey = 'notif_daily_enabled';
  static const _notifHourKey = 'notif_daily_hour';
  static const _notifMinuteKey = 'notif_daily_minute';
  static const int _channelId = 1001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ── Curated Quranic Verses ─────────────────────────────────────────────────
  // Each entry: {'ar': Arabic text, 'ku': Kurdish translation, 'ref': Surah:Ayah}
  static const List<Map<String, String>> _verses = [
    {
      'ar': 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ',
      'ku': 'کاتێک بەندەکانم دەربارەی منت لێ دەپرسن، من نزیکمە. دوعای دوعاکەر وەڵام دەدەمەوە کاتێک بانگم دەکات.',
      'ref': 'البقرة ١٨٦',
    },
    {
      'ar': 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا ۝ إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      'ku': 'بەڕاستی لەگەڵ سەختییەکدا ئاسانیش هەیە. بەڕاستی لەگەڵ ئەو سەختییەدا ئاسانیش هەیە.',
      'ref': 'الشرح ٥-٦',
    },
    {
      'ar': 'وَلَا تَيْأَسُوا مِن رَّوْحِ اللَّهِ ۖ إِنَّهُ لَا يَيْأَسُ مِن رَّوْحِ اللَّهِ إِلَّا الْقَوْمُ الْكَافِرُونَ',
      'ku': 'لە ڕەحمەتی خودا ناوومێید. نەک ئەوانەی کافرن ناوومێیدن لە ڕەحمەتی خودا.',
      'ref': 'يوسف ٨٧',
    },
    {
      'ar': 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      'ku': 'خودا ما پێ دەگات و ئەو باشترین وەکیلە.',
      'ref': 'آل عمران ١٧٣',
    },
    {
      'ar': 'وَبَشِّرِ الصَّابِرِينَ',
      'ku': 'مستڵقەکان بشارەت پێ بدە.',
      'ref': 'البقرة ١٥٥',
    },
    {
      'ar': 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
      'ku': 'بەڕاستی خودا لەگەڵ مستڵقەکانەدایە.',
      'ref': 'البقرة ١٥٣',
    },
    {
      'ar': 'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
      'ku': 'هەر کەسێک پشتیانی لە خودا بکات، ئەوا ئەو پێی دەگات.',
      'ref': 'الطلاق ٣',
    },
    {
      'ar': 'وَمَا تَوْفِيقِي إِلَّا بِاللَّهِ ۚ عَلَيْهِ تَوَكَّلْتُ وَإِلَيْهِ أُنِيبُ',
      'ku': 'سەرکەوتنم تەنیا لە خوداست. پشتیانیم لە کردووە و بەرەو ئەو دەگەڕێمەوە.',
      'ref': 'هود ٨٨',
    },
    {
      'ar': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      'ku': 'پەروەردگارا، لە دنیادا باشی پێمان بدە و لە ئاخرەتیشدا باشی، و لە شکنجەی ئاگری دوور بمانخستەوە.',
      'ref': 'البقرة ٢٠١',
    },
    {
      'ar': 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
      'ku': 'بڵێ: پەروەردگارم، زانیاریم زیاد بکە.',
      'ref': 'طه ١١٤',
    },
    {
      'ar': 'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ وَإِنَّهَا لَكَبِيرَةٌ إِلَّا عَلَى الْخَاشِعِينَ',
      'ku': 'بە سەبر و نوێژ یارمەتی داواکەن. ئەمەش گران نییە مەگەر بۆ فڕۆتنەکان.',
      'ref': 'البقرة ٤٥',
    },
    {
      'ar': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
      'ku': 'کارەکان بە نیەتەکانیانەوەیە.',
      'ref': 'حدیث شریف',
    },
    {
      'ar': 'يَا أَيُّهَا الَّذِينَ آمَنُوا اذْكُرُوا اللَّهَ ذِكْرًا كَثِيرًا',
      'ku': 'ئەی باوەڕداران، زۆر یادی خودا بکەن.',
      'ref': 'الأحزاب ٤١',
    },
    {
      'ar': 'وَمَن يَخْشَ اللَّهَ يَجْعَل لَّهُ مَخْرَجًا',
      'ku': 'هەر کەسێک لە خودا بترسێت، بیر دەکاتەوە.',
      'ref': 'الطلاق ٢',
    },
  ];

  // ── Initialization ──────────────────────────────────────────────────────────
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await NotificationService()._plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (_) {},
    );
  }

  // ── Request permissions (Android 13+) ──────────────────────────────────────
  Future<bool> requestPermissions() async {
    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? false;
    }
    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  // ── Schedule 14 daily notifications (2 weeks ahead) ────────────────────────
  Future<void> scheduleDailyNotifications({
    required int hour,
    required int minute,
  }) async {
    await cancelAllNotifications();

    final now = tz.TZDateTime.now(tz.local);

    for (int i = 0; i < 14; i++) {
      final verse = _verses[i % _verses.length];
      final scheduledDate = _nextInstanceOfTime(hour, minute, daysAhead: i, now: now);

      await _plugin.zonedSchedule(
        _channelId + i,
        'قورئانەکەم — ${verse['ref']}',
        '${verse['ar']}\n\n${verse['ku']}',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'quran_daily_verse',
            'ئاگادارکردنەوەی ئایەت',
            channelDescription: 'ئایەتێکی کاریگەر ڕۆژانە',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(
              '${verse['ar']}\n\n${verse['ku']}',
              contentTitle: 'قورئانەکەم ✨ — ${verse['ref']}',
              summaryText: verse['ref'],
            ),
            icon: '@mipmap/ic_launcher',
            largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            color: const Color(0xFF1AB66D),
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(
    int hour,
    int minute, {
    required int daysAhead,
    required tz.TZDateTime now,
  }) {
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    ).add(Duration(days: daysAhead));

    // If today's time already passed and daysAhead == 0, push to tomorrow
    if (daysAhead == 0 && scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  // ── Cancel all scheduled notifications ─────────────────────────────────────
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  // ── Persist settings ────────────────────────────────────────────────────────
  static Future<void> saveSettings({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notifEnabledKey, enabled);
    await prefs.setInt(_notifHourKey, hour);
    await prefs.setInt(_notifMinuteKey, minute);
  }

  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'enabled': prefs.getBool(_notifEnabledKey) ?? false,
      'hour': prefs.getInt(_notifHourKey) ?? 8,
      'minute': prefs.getInt(_notifMinuteKey) ?? 0,
    };
  }
}
