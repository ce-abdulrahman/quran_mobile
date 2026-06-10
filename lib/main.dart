import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/l10n/app_localizations.dart';
import 'core/providers/app_providers.dart';
import 'core/services/notification_service.dart';
import 'features/splash/splash_page.dart';
import 'shell/app_shell.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance(); 

  // Initialize local notifications
  await NotificationService.initialize(); 

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
      ],
      child: const QuranApp(),
    ),
  );
}

class QuranApp extends ConsumerWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);

    return MaterialApp(
      title: 'قورئانەکەم',
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.light,
        ),
        fontFamily: 'Cairo',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Cairo',
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar'), Locale('ku')],
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
        '/shell': (_) => const AppShell(),
      },
    );
  }
}
