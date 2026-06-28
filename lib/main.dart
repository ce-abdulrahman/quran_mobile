import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_localizations.dart';
import 'core/providers/app_providers.dart';
import 'core/providers/feature_flag_provider.dart';
import 'core/services/notification_service.dart';
import 'core/services/notification_coordinator.dart';
import 'core/services/reminder_engine.dart';
import 'core/repositories/reminder_repository.dart';
import 'core/network/api_client.dart';
import 'features/splash/splash_page.dart';
import 'shell/app_shell.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/local_db/isar_service.dart';
import 'core/services/audio_quality_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.init();
  final sharedPrefs = await SharedPreferences.getInstance();
  await AudioQualityManager().init(sharedPrefs); 

  // Initialize Hive for high-performance, low-memory caching
  await Hive.initFlutter();
  final cacheBox = await Hive.openBox('app_cache_box');
  final prayerTimesBox = await Hive.openBox('prayer_times_box');

  // Initialize local notifications
  await NotificationService.initialize();

  // Initialize new notification channels (Phase 3 — 9-channel architecture)
  await NotificationCoordinator().initChannels();

  // Setup smart reminder click response handlers for tracking analytics
  final reminderRepo = ReminderRepository(ApiClient());
  await ReminderEngine.setupNotificationResponseHandler(reminderRepo);

  // Reschedule daily notifications if they were previously enabled
  final notifSettings = await NotificationService.loadSettings();
  if (notifSettings['enabled'] == true) {
    await NotificationService().scheduleDailyNotifications(
      hour: notifSettings['hour'] as int,
      minute: notifSettings['minute'] as int,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        hiveCacheBoxProvider.overrideWithValue(cacheBox),
        prayerTimesHiveBoxProvider.overrideWithValue(prayerTimesBox),
      ],
      child: const QuranApp(),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature Flag Boot Sync
// Called from SplashPage after ProviderScope is ready.
// ─────────────────────────────────────────────────────────────────────────────

Future<void> syncFeatureFlagsOnBoot(WidgetRef ref) async {
  // Non-blocking: syncs in background, uses cached flags immediately
  ref.read(featureFlagServiceProvider).sync();
}

class QuranApp extends ConsumerWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);
    final appLocale = ref.watch(appLocaleProvider);
    final readerSettings = ref.watch(readerSettingsProvider);

    final uiFont = (readerSettings.fontTarget == 'ui' || readerSettings.fontTarget == 'both')
        ? readerSettings.uiFontFamily
        : 'Cairo';

    return MaterialApp(
      title: 'قورئانەکەم',
      themeMode: themeMode,
      locale: appLocale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor.primary,
          brightness: Brightness.light,
        ),
        fontFamily: uiFont,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor.primary,
          brightness: Brightness.dark,
        ),
        fontFamily: uiFont,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        RtlKurdishWidgetsLocalizationsDelegate(),
        RtlKurdishMaterialLocalizationsDelegate(),
        RtlKurdishCupertinoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ku'), Locale('ar'), Locale('en')],
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/shell': (_) => const AppShell(),
      },
      builder: (context, child) {
        final isRtl = appLocale.languageCode == 'ar' || appLocale.languageCode == 'ku';
        return Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
