import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

/// Flutter localization delegate that wires [AppLocalizations] into the
/// widget tree. Register this in [MaterialApp.localizationsDelegates].
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ku', 'ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale.languageCode);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

/// Fallback Material localizations delegate for Kurdish 'ku' locale, delegating to Arabic 'ar' (RTL).
class KurdishMaterialLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const KurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(const Locale('ar'));

  @override
  bool shouldReload(KurdishMaterialLocalizationsDelegate old) => false;
}

/// Fallback Cupertino localizations delegate for Kurdish 'ku' locale, delegating to Arabic 'ar' (RTL).
class KurdishCupertinoLocalizationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const KurdishCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(const Locale('ar'));

  @override
  bool shouldReload(KurdishCupertinoLocalizationsDelegate old) => false;
}

/// Fallback Widgets localizations delegate for Kurdish 'ku' locale, delegating to Arabic 'ar' (RTL).
class KurdishWidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  const KurdishWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(const Locale('ar'));

  @override
  bool shouldReload(KurdishWidgetsLocalizationsDelegate old) => false;
}
