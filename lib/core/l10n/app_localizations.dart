import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations();

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations();
  }

  // ── App ──────────────────────────────────────────────────────────
  String get appName => 'قورئانەکەم';
  String get appTagline => 'ئاراممان دەکات، ڕێنماییمان دەدات';

  // ── Navigation ───────────────────────────────────────────────────
  String get navHome => 'سەرەکی';
  String get navQuran => 'قورئان';
  String get navTasbih => 'تەسبیح';
  String get navBookmarks => 'پاراستەکان';
  String get navSettings => 'ڕێکخستن';
  String get navCommunity => 'کۆمەڵگا';

  // ── Titles ───────────────────────────────────────────────────────
  String get quranTitle => 'قورئان';
  String get tasbihTitle => 'تەسبیح';
  String get bookmarksTitle => 'پاراستەکان';
  String get settingsTitle => 'ڕێکخستن';
  String get searchTitle => 'گەڕان';

  // ── Home ─────────────────────────────────────────────────────────
  String get homeVerseSearch => 'گەڕانی ئایەت';
  String get homeFeatures => 'تایبەتمەندییەکان';
  String get homeDailyVerse => 'ئایەتی ڕۆژ';
  String get homeReadingStreak => 'بەردەوامی خوێندن';
  String homeStreakDaysCount(int days) => '$days ڕۆژ';
  String get homeStreakNoActive => 'هیچ بەردەوامییەک نییە';
  String get homeStreakTodayDone => 'ئەمڕۆ تەواو بووە ✓';
  String get homeStreakTodayPending => 'ئەمڕۆ چاوەڕوانە';
  String get homeStreakLongest => 'درێژترین';
  String get homeDailyGoals => 'ئامانجەکانی ڕۆژ';
  String get homeGoal1 => 'یەک لاپەڕە بخوێنەوە';
  String get homeGoal2 => 'بەشێک تەواو بکە';
  String get homeGoal3 => 'لەبەرکردن پێداچوونەوە';
  String get homeGoal4 => 'ئایەتێک بڵاوبکەرەوە';

  // ── Quran ────────────────────────────────────────────────────────
  String get quranAllSurahs => 'هەموو';
  String get quranMeccan => 'مەککەی';
  String get quranMedinan => 'مەدینەی';
  String get quranBookmarked => 'نیشانەکراو';
  String get quranAyahs => 'ئایەت';
  String get quranSearchHint => 'گەڕان بەدوای سورەتدا...';
  String get quranTapToRead => 'لە داهاتوودا بەردەست دەبێت';

  // ── Tasbih ───────────────────────────────────────────────────────
  String get tasbihTapAnywhere => 'لە هەر شوێنێک بپەیت';
  String get tasbihReset => 'ڕیست بکەرەوە';
  String get tasbihResetConfirm => 'ئایا دڵنیایت؟';
  String get tasbihResetYes => 'بەڵێ';
  String get tasbihResetNo => 'نەخێر';
  String get tasbihSaved => 'پاراستوو';
  String get tasbihSubhanAllah => 'سوبحانالله';
  String get tasbihAlhamdulillah => 'ئەلحەمدولله';
  String get tasbihAllahuAkbar => 'ئەللاهو ئەکبەر';
  String get tasbihGoal => 'ئامانج: ٣٣';
  String get tasbihCounter => 'تەسبیحکار';
  String get tasbihStats => 'گرافیکی ئامار';
  String get tasbihToday => 'ئەمڕۆ';
  String get tasbihWeek => 'ئەم هەفتەیە';
  String get tasbihMonth => 'ئەم مانگە';
  String get tasbihTotal => 'کۆی گشتی';
  String get tasbihDhikrBreakdown => 'جیاکردنەوەی ذکرەکان';
  String get tasbihHistoryLogs => 'تۆمارەکان';

  // ── Search ───────────────────────────────────────────────────────
  String get searchHint => 'گەڕان بەدوای ئایەت، سورەتدا...';
  String get searchRecent => 'گەڕانە نوێیەکان';
  String get searchNoResults => 'هیچ ئەنجامێک نەدۆزرایەوە';
  String get searchEmpty => 'دەستپێکە بگەڕێیت';

  // ── Bookmarks ────────────────────────────────────────────────────
  String get bookmarksEmpty => 'هیچ پارێزراوێک نییە';
  String get bookmarksEmptySub => 'ئایەتێک پارێز بکە تا ئێرە دەرکەوێت';

  // ── Settings ─────────────────────────────────────────────────────
  String get settingsTheme => 'ڕووکار';
  String get settingsLight => 'ڕووناک';
  String get settingsDark => 'تاریک';
  String get settingsSystem => 'سیستەم';
  String get settingsLanguage => 'زمان';
  String get settingsFontSize => 'قەبارەی فۆنت';
  String get settingsAbout => 'دەربارە';
  String get settingsVersion => 'وەشان ٢.١.٣';
  String get settingsAppearance => 'دیمەن';
  String get settingsGeneral => 'گشتی';

  // ── Favorites ────────────────────────────────────────────────────
  String get navFavorites => 'دڵخوازەکان';
  String get favoritesTitle => 'ئایەتە دڵخوازەکان';
  String get favoritesEmpty => 'هیچ ئایەتێکی دڵخواز نییە';
  String get favoritesEmptySub => 'لەسەر ئەستێرەی هەر ئایەتێک دابگرە بۆ ئەوەی لێرە دەرکەوێت';

  // ── Khatm ────────────────────────────────────────────────────────
  String get khatmTitle => 'خوێندنی ختم';
  String get khatmCreate => 'دەستپێکردنی ختمێکی نوێ';
  String get khatmTitleInput => 'ناوی ختمەکە (بۆ نموونە: ختمی ڕەمەزان)';
  String get khatmDaysInput => 'ماوەی تەواوکردن (ڕۆژ)';
  String get khatmStart => 'دەست پێ بکە';
  String get khatmProgress => 'ڕێژەی پێشکەوتن';
  String get khatmActive => 'ختمی چالاک';
  String get khatmDailyTarget => 'ئامانجی ڕۆژانە';
  String get khatmRemainingToday => 'ئایەتەکانی ئەمڕۆ';
  String get khatmCompleted => 'پیرۆزە! ختمەکە بە سەرکەوتوویی تەواو بوو 🎉';
  String get khatmStatusOnTrack => 'لە کات و ساتی خۆیدایە ✓';
  String get khatmStatusBehind => 'دواکەوتووە ⚠';
  String get khatmStatusAhead => 'پێش کەوتووە ✨';

  // ── Adhkar ───────────────────────────────────────────────────────
  String get adhkarTitle => 'ئەزکارەکان';
  String get adhkarMorning => 'ئەزکاری بەیانیان';
  String get adhkarEvening => 'ئەزکاری ئێواران';
  String get adhkarAfterPrayer => 'ئەزکاری دوای نوێژ';
  String get adhkarBeforeSleep => 'ئەزکاری پێش خەوتن';
  String get adhkarBenefit => 'فەزڵەکەی';
  String get adhkarTarget => 'ئامانج';
  String get adhkarTodayCompleted => 'ئەمڕۆ تەواو بووە ✓';
  String get adhkarTodayPending => 'ئەمڕۆ تەواو نەکراوە';
  String get adhkarStartSession => 'دەستپێکردنی زیکرەکان';
  String get adhkarResetProgress => 'دەستپێکردنەوەی پێشکەوتن';
  String get settingsDistractionFree => 'مۆدی بێ خەوش';
  String get settingsDistractionFreeSub => 'شاردنەوەی سەرپەڕ و دوگمەکان لە کاتی خوێندنەوەدا';

  // ── Daily Notification ────────────────────────────────────────────
  String get settingsDailyNotification => 'ئاگادارکردنەوەی ڕۆژانە';
  String get settingsDailyNotificationSub => 'وەرگرتنی ئاگادارکردنەوە لەگەڵ ئایەتێکی کاریگەر ڕۆژانە';
  String get settingsNotificationTime => 'کاتی ئاگادارکردنەوە';
  String get notificationTitle => 'ئایەتی ڕۆژانە ✨';
  String get notificationChannelName => 'ئاگادارکردنەوەی ئایەت';

  // ── Share Card ──────────────────────────────────────────────────
  String get shareCardTitle => 'بەشکردنی ئایەت';
  String get shareAsImage => 'بەشکردن وەک وێنە';
  String get copyTextOnly => 'کۆپیکردنی دەق';
  String get shareSelectBg => 'پاشبنەمای کارتەکە';
  String get shareTranslateKu => 'نیشاندانی کوردی';
  String get shareTranslateEn => 'نیشاندانی ئینگلیزی';
  String get shareCopiedText => 'دەقی ئایەتەکە کۆپی کرا';
  String get shareGeneratingImage => 'وێنەکە دروست دەکرێت...';

  // ── Memorization Quiz ───────────────────────────────────────────
  String get memorizationQuizTitle => 'تاقیکردنەوەی حیفز';
  String get memorizationQuizSelectSurah => 'سورەتێک هەڵبژێرە';
  String get memorizationQuizSelectQuestions => 'ژمارەی پرسیارەکان';
  String get memorizationQuizStart => 'دەستپێکردنی تاقیکردنەوە';
  String get memorizationQuizNext => 'دواتر';
  String get memorizationQuizFinish => 'کۆتایی تاقیکردنەوە';
  String get memorizationQuizScore => 'نمرەکەت';
  String get memorizationQuizWrongAnswers => 'پێداچوونەوەی هەڵەکان';
  String get memorizationQuizRetry => 'دووبارە تاقیکردنەوە';
  String get memorizationQuizGoHome => 'گەڕانەوە بۆ سەرەکی';
  String get memorizationQuizPlanTab => 'پلانی ڕۆژانە';
  String get memorizationQuizSurahTab => 'تاقیکردنەوەی سورەت';
  String get memorizationQuizNoPlan => 'هیچ پلانێکی چالاک نییە';
  String get memorizationQuizConnectError => 'پێویستە بچیتە ژوورەوە بۆ دۆزینەوەی پلانەکان';

  // ── Prayer Times & Azan ──────────────────────────────────────────
  String get prayerTimesTitle => 'کاتی نوێژەکان';
  String get prayerFajr => 'بەیانی';
  String get prayerSunrise => 'ڕۆژهەڵات';
  String get prayerDhuhr => 'نیوەڕۆ';
  String get prayerAsr => 'عەسڕ';
  String get prayerMaghrib => 'مەغریب';
  String get prayerIsha => 'عیشا';
  String get prayerSelectCity => 'شارەکەت هەڵبژێرە';
  String get prayerNextPrayer => 'نوێژی داهاتوو';
  String get prayerTimeRemaining => 'ماوە بۆ نوێژ';
  String get prayerAzanNotification => 'ئاگادارکردنەوەی نوێژەکان';
  String get prayerAzanNotificationSub => 'لێدانی دەنگی ئازان لە کاتی هاتنی نوێژەکاندا';
  String get prayerTimesNotificationEnabled => 'چالاککردنی دەنگی ئازان';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(const AppLocalizations());
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
