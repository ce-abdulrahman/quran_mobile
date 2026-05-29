import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'core/l10n/app_localizations_delegate.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load Google Fonts (Cairo) early so splash doesn't flash default font
  await GoogleFonts.pendingFonts([
    GoogleFonts.cairo(),
  ]);

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Allow portrait + landscape (tablet supports landscape, phone portrait only)
  // The app itself handles the layout difference via ScreenUtil
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
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
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'قورئانەکەم',
      debugShowCheckedModeBanner: false,

      // Theme
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // App localization
      locale: locale,
      supportedLocales: const [
        Locale('ku'),
        Locale('ar'),
        Locale('en'),
      ],

      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        KurdishMaterialLocalizationsDelegate(),
        KurdishCupertinoLocalizationsDelegate(),
        KurdishWidgetsLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (loc, supportedLocales) {
        for (final supported in supportedLocales) {
          if (supported.languageCode == loc?.languageCode) {
            return supported;
          }
        }
        return const Locale('ku');
      },

      home: const SplashScreen(),

      builder: (context, child) {
        return Directionality(
          textDirection: locale.languageCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}
