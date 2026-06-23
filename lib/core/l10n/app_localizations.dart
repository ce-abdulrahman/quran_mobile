import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final String localeCode;
  const AppLocalizations([this.localeCode = 'ku']);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations('ku');
  }

  String _translate({required String ku, required String ar, required String en}) {
    if (localeCode == 'ar') return ar;
    if (localeCode == 'en') return en;
    return ku;
  }

  // ── App ──────────────────────────────────────────────────────────
  String get appName => _translate(ku: 'قورئانەکەم', ar: 'قرآني', en: 'My Quran');
  String get appTagline => _translate(ku: 'ئاراممان دەکات، ڕێنماییمان دەدات', ar: 'يطمئن قلوبنا، ويهدينا', en: 'Soothes our hearts, guides us');

  // ── Navigation ───────────────────────────────────────────────────
  String get navHome => _translate(ku: 'سەرەکی', ar: 'الرئيسية', en: 'Home');
  String get navQuran => _translate(ku: 'قورئان', ar: 'القرآن', en: 'Quran');
  String get navTasbih => _translate(ku: 'تەسبیح', ar: 'التسبيح', en: 'Tasbih');
  String get navBookmarks => _translate(ku: 'پاراستەکان', ar: 'المحفوظات', en: 'Bookmarks');
  String get navSettings => _translate(ku: 'ڕێکخستن', ar: 'الإعدادات', en: 'Settings');
  String get navCommunity => _translate(ku: 'کۆمەڵگا', ar: 'المجتمع', en: 'Community');

  // ── Titles ───────────────────────────────────────────────────────
  String get quranTitle => _translate(ku: 'قورئان', ar: 'القرآن الكريم', en: 'Quran');
  String get tasbihTitle => _translate(ku: 'تەسبیح', ar: 'التسبيح', en: 'Tasbih');
  String get bookmarksTitle => _translate(ku: 'پاراستەکان', ar: 'المحفوظات', en: 'Bookmarks');
  String get settingsTitle => _translate(ku: 'ڕێکخستن', ar: 'الإعدادات', en: 'Settings');
  String get searchTitle => _translate(ku: 'گەڕان', ar: 'البحث', en: 'Search');

  // ── Home ─────────────────────────────────────────────────────────
  String get homeVerseSearch => _translate(ku: 'گەڕانی ئایەت', ar: 'بحث الآيات', en: 'Verse Search');
  String get homeFeaturesOne => _translate(ku: 'تایبەتمەندییەکان', ar: 'الميزات', en: 'Features');
  String get homeFeaturesTwo => _translate(ku: 'ئامانجی ڕۆژانە', ar: 'الهدف اليومي', en: 'Daily Goal');
  String get homeDailyVerse => _translate(ku: 'ئایەتی ڕۆژ', ar: 'آية اليوم', en: 'Daily Verse');
  String get homeReadingStreak => _translate(ku: 'بەردەوامی خوێندن', ar: 'سلسلة القراءة', en: 'Reading Streak');
  String homeStreakDaysCount(int days) => _translate(ku: '$days ڕۆژ', ar: '$days يوم', en: '$days Days');
  String get homeStreakNoActive => _translate(ku: 'هیچ بەردەوامییەک نییە', ar: 'لا يوجد سلسلة نشطة', en: 'No active streak');
  String get homeStreakTodayDone => _translate(ku: 'ئەمڕۆ تەواو بووە ✓', ar: 'اكتمل اليوم ✓', en: 'Completed today ✓');
  String get homeStreakTodayPending => _translate(ku: 'ئەمڕۆ چاوەڕوانە', ar: 'معلق اليوم', en: 'Pending today');
  String get homeStreakLongest => _translate(ku: 'درێژترین', ar: 'الأطول', en: 'Longest');
  String get homeDailyGoals => _translate(ku: 'ئامانجەکانی ڕۆژ', ar: 'الأهداف اليومية', en: 'Daily Goals');
  String get homeGoal1 => _translate(ku: 'یەک لاپەڕە بخوێنەوە', ar: 'اقرأ صفحة واحدة', en: 'Read one page');
  String get homeGoal2 => _translate(ku: 'بەشێک تەواو بکە', ar: 'أكمل جزءاً', en: 'Complete a Juz');
  String get homeGoal3 => _translate(ku: 'لەبەرکردن پێداچوونەوە', ar: 'مراجعة الحفظ', en: 'Review memorization');
  String get homeGoal4 => _translate(ku: 'ئایەتێک بڵاوبکەرەوە', ar: 'انشر آية', en: 'Share a verse');

  // ── Quran ────────────────────────────────────────────────────────
  String get quranAllSurahs => _translate(ku: 'هەموو', ar: 'الكل', en: 'All');
  String get quranMeccan => _translate(ku: 'مەککەی', ar: 'مكية', en: 'Meccan');
  String get quranMedinan => _translate(ku: 'مەدینەی', ar: 'مدنية', en: 'Medinan');
  String get quranBookmarked => _translate(ku: 'نیشانەکراو', ar: 'المحفوظة', en: 'Bookmarked');
  String get quranAyahs => _translate(ku: 'ئایەت', ar: 'آية', en: 'Ayahs');
  String get quranSearchHint => _translate(ku: 'گەڕان بەدوای سورەتدا...', ar: 'البحث عن سورة...', en: 'Search Surah...');
  String get quranTapToRead => _translate(ku: 'لە داهاتوودا بەردەست دەبێت', ar: 'سيتوفر قريباً', en: 'Available soon');

  // ── Tasbih ───────────────────────────────────────────────────────
  String get tasbihTapAnywhere => _translate(ku: 'لە هەر شوێنێک بپەیت', ar: 'انقر في أي مكان للعد', en: 'Tap anywhere to count');
  String get tasbihReset => _translate(ku: 'ڕیست بکەرەوە', ar: 'إعادة تعيين', en: 'Reset');
  String get tasbihResetConfirm => _translate(ku: 'ئایا دڵنیایت؟', ar: 'هل أنت متأكد؟', en: 'Are you sure?');
  String get tasbihResetYes => _translate(ku: 'بەڵێ', ar: 'نعم', en: 'Yes');
  String get tasbihResetNo => _translate(ku: 'نەخێر', ar: 'لا', en: 'No');
  String get tasbihSaved => _translate(ku: 'پاراستوو', ar: 'تم الحفظ', en: 'Saved');
  String get tasbihSubhanAllah => _translate(ku: 'سوبحانالله', ar: 'سبحان الله', en: 'Subhan Allah');
  String get tasbihAlhamdulillah => _translate(ku: 'ئەلحەمدولله', ar: 'الحمد لله', en: 'Alhamdulillah');
  String get tasbihAllahuAkbar => _translate(ku: 'ئەللاهو ئەکبەر', ar: 'الله أكبر', en: 'Allahu Akbar');
  String get tasbihGoal => _translate(ku: 'ئامانج: ٣٣', ar: 'الهدف: ٣٣', en: 'Goal: 33');
  String get tasbihCounter => _translate(ku: 'تەسبیحکار', ar: 'المسبحة', en: 'Tasbih Counter');
  String get tasbihStats => _translate(ku: 'گرافیکی ئامار', ar: 'الإحصائيات', en: 'Statistics');
  String get tasbihToday => _translate(ku: 'ئەمڕۆ', ar: 'اليوم', en: 'Today');
  String get tasbihWeek => _translate(ku: 'ئەم هەفتەیە', ar: 'هذا الأسبوع', en: 'This Week');
  String get tasbihMonth => _translate(ku: 'ئەم مانگە', ar: 'هذا الشهر', en: 'This Month');
  String get tasbihTotal => _translate(ku: 'کۆی گشتی', ar: 'المجموع', en: 'Total');
  String get tasbihDhikrBreakdown => _translate(ku: 'جیاکردنەوەی ذکرەکان', ar: 'تفاصيل الأذكار', en: 'Dhikr Breakdown');
  String get tasbihHistoryLogs => _translate(ku: 'تۆمارەکان', ar: 'سجل المحفوظات', en: 'History Logs');
  String get tasbihDailyGoal => _translate(ku: 'ئامانجی ڕۆژانە', ar: 'الهدف اليومي', en: 'Daily Goal');
  String get tasbihChangeGoal => _translate(ku: 'گۆڕینی ئامانج', ar: 'تغيير الهدف', en: 'Change Goal');
  String get tasbihPredefinedGoals => _translate(ku: 'ئامانجە دیاریکراوەکان', ar: 'الأهداف المحددة', en: 'Predefined Goals');
  String get tasbihCustomGoal => _translate(ku: 'ئامانجی تایبەت', ar: 'هدف مخصص', en: 'Custom Goal');
  String get tasbihGoalCompleted => _translate(ku: 'پیرۆزە! ئامانجی ڕۆژانەت تەواو کرد 🎉', ar: 'تهانينا! أكملت هدفك اليومي 🎉', en: 'Congratulations! Completed your daily goal 🎉');
  String get tasbihGoalSelect => _translate(ku: 'دیاریکردنی ئامانج', ar: 'تحديد الهدف', en: 'Select Goal');
  String get tasbihGoalMinError => _translate(ku: 'تکایە ژمارەیەک بنووسە لە ١ یان زیاتر بێت', ar: 'يرجى إدخال رقم 1 أو أكثر', en: 'Please enter a number 1 or greater');

  // ── Statistics ───────────────────────────────────────────────────
  String get statsAndInsightsTitle => _translate(ku: 'ئامار و زانیارییەکان', ar: 'الإحصائيات والتحليلات', en: 'Statistics & Insights');
  String get statsQuickActionInsights => _translate(ku: 'ئامارەکان', ar: 'الإحصائيات', en: 'Insights');

  // ── Search ───────────────────────────────────────────────────────
  String get searchHint => _translate(ku: 'گەڕان بەدوای ئایەت، سورەتدا...', ar: 'البحث عن آية، سورة...', en: 'Search for Ayah, Surah...');
  String get searchRecent => _translate(ku: 'گەڕانە نوێیەکان', ar: 'عمليات البحث الأخيرة', en: 'Recent Searches');
  String get searchNoResults => _translate(ku: 'هیچ ئەنجامێک نەدۆزرایەوە', ar: 'لم يتم العثور على نتائج', en: 'No results found');
  String get searchEmpty => _translate(ku: 'دەستپێکە بگەڕێیت', ar: 'ابدأ البحث', en: 'Start searching');

  // ── Bookmarks ────────────────────────────────────────────────────
  String get bookmarksEmpty => _translate(ku: 'هیچ پارێزراوێک نییە', ar: 'لا توجد محفوظات', en: 'No bookmarks');
  String get bookmarksEmptySub => _translate(ku: 'ئایەتێک پارێز بکە تا ئێرە دەرکەوێت', ar: 'احفظ آية لتظهر هنا', en: 'Bookmark a verse to see it here');

  // ── Settings ─────────────────────────────────────────────────────
  String get settingsTheme => _translate(ku: 'ڕووکار', ar: 'المظهر', en: 'Theme');
  String get settingsLight => _translate(ku: 'ڕووناک', ar: 'فاتح', en: 'Light');
  String get settingsDark => _translate(ku: 'تاریک', ar: 'داكن', en: 'Dark');
  String get settingsSystem => _translate(ku: 'سیستەم', ar: 'النظام', en: 'System');
  String get settingsLanguage => _translate(ku: 'زمان', ar: 'اللغة', en: 'Language');
  String get settingsFontSize => _translate(ku: 'قەبارەی فۆنت', ar: 'حجم الخط', en: 'Font Size');
  String get settingsAbout => _translate(ku: 'دەربارە', ar: 'حول التطبيق', en: 'About');
  String get settingsVersion => _translate(ku: 'وەشان ٢.١.٣', ar: 'الإصدار ٢.١.٣', en: 'Version 2.1.3');
  String get settingsAppearance => _translate(ku: 'دیمەن', ar: 'المظهر الخارجي', en: 'Appearance');
  String get settingsGeneral => _translate(ku: 'گشتی', ar: 'عام', en: 'General');

  // ── Favorites ────────────────────────────────────────────────────
  String get navFavorites => _translate(ku: 'دڵخوازەکان', ar: 'المفضلة', en: 'Favorites');
  String get favoritesTitle => _translate(ku: 'ئایەتە دڵخوازەکان', ar: 'الآيات المفضلة', en: 'Favorite Ayahs');
  String get favoritesEmpty => _translate(ku: 'هیچ ئایەتێکی دڵخواز نییە', ar: 'لا توجد آيات مفضلة', en: 'No favorite verses');
  String get favoritesEmptySub => _translate(ku: 'لەسەر ئەستێرەی هەر ئایەتێک دابگرە بۆ ئەوەی لێرە دەرکەوێت', ar: 'اضغط على نجمة الآية لتظهر هنا', en: 'Tap the star on any verse to see it here');

  // ── Khatm ────────────────────────────────────────────────────────
  String get khatmTitle => _translate(ku: 'خوێندنی ختم', ar: 'ختم القرآن', en: 'Khatmah');
  String get khatmCreate => _translate(ku: 'دەستپێکردنی ختمێکی نوێ', ar: 'بدء ختمة جديدة', en: 'Start New Khatmah');
  String get khatmTitleInput => _translate(ku: 'ناوی ختمەکە (بۆ نموونە: ختمی ڕەمەزان)', ar: 'اسم الختمة (مثال: ختمة رمضان)', en: 'Khatmah Name (e.g. Ramadan Khatmah)');
  String get khatmDaysInput => _translate(ku: 'ماوەی تەواوکردن (ڕۆژ)', ar: 'مدة الختم (بالأيام)', en: 'Duration (Days)');
  String get khatmStart => _translate(ku: 'دەست پێ بکە', ar: 'ابدأ', en: 'Start');
  String get khatmProgress => _translate(ku: 'ڕێژەی پێشکەوتن', ar: 'نسبة التقدم', en: 'Progress');
  String get khatmActive => _translate(ku: 'ختمی چالاک', ar: 'الختمة النشطة', en: 'Active Khatmah');
  String get khatmDailyTarget => _translate(ku: 'ئامانجی ڕۆژانە', ar: 'الهدف اليومي', en: 'Daily Target');
  String get khatmRemainingToday => _translate(ku: 'ئایەتەکانی ئەمڕۆ', ar: 'آيات اليوم المتبقية', en: 'Remaining Ayahs Today');
  String get khatmCompleted => _translate(ku: 'پیرۆزە! ختمەکە بە سەرکەوتوویی تەواو بوو 🎉', ar: 'تهانينا! اكتملت الختمة بنجاح 🎉', en: 'Congratulations! Khatmah completed successfully 🎉');
  String get khatmStatusOnTrack => _translate(ku: 'لە کات و ساتی خۆیدایە ✓', ar: 'في الوقت المحدد ✓', en: 'On track ✓');
  String get khatmStatusBehind => _translate(ku: 'دواکەوتووە ⚠', ar: 'متأخر ⚠', en: 'Behind schedule ⚠');
  String get khatmStatusAhead => _translate(ku: 'پێش کەوتووە ✨', ar: 'متقدم ✨', en: 'Ahead of schedule ✨');

  // ── Adhkar ───────────────────────────────────────────────────────
  String get adhkarTitle => _translate(ku: 'ئەزکارەکان', ar: 'الأذكار', en: 'Adhkar');
  String get adhkarMorning => _translate(ku: 'ئەزکاری بەیانیان', ar: 'أذكار الصباح', en: 'Morning Adhkar');
  String get adhkarEvening => _translate(ku: 'ئەزکاری ئێواران', ar: 'أذكار المساء', en: 'Evening Adhkar');
  String get adhkarAfterPrayer => _translate(ku: 'ئەزکاری دوای نوێژ', ar: 'أذكار بعد الصلاة', en: 'After Prayer Adhkar');
  String get adhkarBeforeSleep => _translate(ku: 'ئەزکاری پێش خەوتن', ar: 'أذكار قبل النوم', en: 'Before Sleep Adhkar');
  String get adhkarBenefit => _translate(ku: 'فەزڵەکەی', ar: 'فضلها', en: 'Benefit');
  String get adhkarTarget => _translate(ku: 'ئامانج', ar: 'الهدف', en: 'Target');
  String get adhkarTodayCompleted => _translate(ku: 'ئەمڕۆ تەواو بووە ✓', ar: 'اكتمل اليوم ✓', en: 'Completed today ✓');
  String get adhkarTodayPending => _translate(ku: 'ئەمڕۆ تەواو نەکراوە', ar: 'معلق اليوم', en: 'Pending today');
  String get adhkarStartSession => _translate(ku: 'دەستپێکردنی زیکرەکان', ar: 'بدء الأذكار', en: 'Start Adhkar');
  String get adhkarResetProgress => _translate(ku: 'دەستپێکردنەوەی پێشکەوتن', ar: 'إعادة تعيين التقدم', en: 'Reset Progress');
  String get settingsDistractionFree => _translate(ku: 'مۆدی بێ خەوش', ar: 'وضع القراءة الخالص', en: 'Distraction-free Mode');
  String get settingsDistractionFreeSub => _translate(ku: 'شاردنەوەی سەرپەڕ و دوگمەکان لە کاتی خوێندنەوەدا', ar: 'إخفاء شريط العنوان والأزرار أثناء القراءة', en: 'Hide headers and buttons while reading');

  // ── Daily Notification ────────────────────────────────────────────
  String get settingsDailyNotification => _translate(ku: 'ئاگادارکردنەوەی ڕۆژانە', ar: 'الإشعارات اليومية', en: 'Daily Notification');
  String get settingsDailyNotificationSub => _translate(ku: 'وەرگرتنی ئاگادارکردنەوە لەگەڵ ئایەتێکی کاریگەر ڕۆژانە', ar: 'تلقي إشعارات يومية مع آية قرآنية مؤثرة', en: 'Get daily notifications with an inspiring verse');
  String get settingsNotificationTime => _translate(ku: 'کاتی ئاگادارکردنەوە', ar: 'وقت الإشعار', en: 'Notification Time');
  String get notificationTitle => _translate(ku: 'ئایەتی ڕۆژانە ✨', ar: 'آية اليوم ✨', en: 'Daily Verse ✨');
  String get notificationChannelName => _translate(ku: 'ئاگادارکردنەوەی ئایەت', ar: 'إشعارات الآيات', en: 'Verse Notifications');

  // ── Share Card ──────────────────────────────────────────────────
  String get shareCardTitle => _translate(ku: 'بەشکردنی ئایەت', ar: 'مشاركة الآية', en: 'Share Verse');
  String get shareAsImage => _translate(ku: 'بەشکردن وەک وێنە', ar: 'مشاركة كصورة', en: 'Share as Image');
  String get copyTextOnly => _translate(ku: 'کۆپیکردنی دەق', ar: 'نسخ النص فقط', en: 'Copy Text Only');
  String get shareSelectBg => _translate(ku: 'پاشبنەمای کارتەکە', ar: 'خلفية البطاقة', en: 'Card Background');
  String get shareTranslateKu => _translate(ku: 'نیشاندانی کوردی', ar: 'إظهار الكردية', en: 'Show Kurdish');
  String get shareTranslateEn => _translate(ku: 'نیشاندانی ئینگلیزی', ar: 'إظهار الإنكليزية', en: 'Show English');
  String get shareCopiedText => _translate(ku: 'دەقی ئایەتەکە کۆپی کرا', ar: 'تم نسخ نص الآية', en: 'Verse text copied');
  String get shareGeneratingImage => _translate(ku: 'وێنەکە دروست دەکرێت...', ar: 'جاري إنشاء الصورة...', en: 'Generating image...');

  // ── Memorization Quiz ───────────────────────────────────────────
  String get memorizationQuizTitle => _translate(ku: 'تاقیکردنەوەی حیفز', ar: 'اختبار الحفظ', en: 'Memorization Quiz');
  String get memorizationQuizSelectSurah => _translate(ku: 'سورەتێک هەڵبژێرە', ar: 'اختر السورة', en: 'Select Surah');
  String get memorizationQuizSelectQuestions => _translate(ku: 'ژمارەی پرسیارەکان', ar: 'عدد الأسئلة', en: 'Number of Questions');
  String get memorizationQuizStart => _translate(ku: 'دەستپێکردنی تاقیکردنەوە', ar: 'بدء الاختبار', en: 'Start Quiz');
  String get memorizationQuizNext => _translate(ku: 'دواتر', ar: 'التالي', en: 'Next');
  String get memorizationQuizFinish => _translate(ku: 'کۆتایی تاقیکردنەوە', ar: 'إنهاء الاختبار', en: 'Finish Quiz');
  String get memorizationQuizScore => _translate(ku: 'نمرەکەت', ar: 'درجتك', en: 'Your Score');
  String get memorizationQuizWrongAnswers => _translate(ku: 'پێداچوونەوەی هەڵەکان', ar: 'مراجعة الأخطاء', en: 'Review Mistakes');
  String get memorizationQuizRetry => _translate(ku: 'دووبارە تاقیکردنەوە', ar: 'إعادة المحاولة', en: 'Retry');
  String get memorizationQuizGoHome => _translate(ku: 'گەڕانەوە بۆ سەرەکی', ar: 'العودة للرئيسية', en: 'Go Home');
  String get memorizationQuizPlanTab => _translate(ku: 'پلانی ڕۆژانە', ar: 'الخطة اليومية', en: 'Daily Plan');
  String get memorizationQuizSurahTab => _translate(ku: 'تاقیکردنەوەی سورەت', ar: 'اختبار السورة', en: 'Surah Quiz');
  String get memorizationQuizNoPlan => _translate(ku: 'هیچ پلانێکی چالاک نییە', ar: 'لا توجد خطة نشطة', en: 'No active plan');
  String get memorizationQuizConnectError => _translate(ku: 'پێویستە بچیتە ژوورەوە بۆ دۆزینەوەی پلانەکان', ar: 'يجب تسجيل الدخول لعرض الخطط', en: 'Must login to view plans');

  // ── Prayer Times & Azan ──────────────────────────────────────────
  String get prayerTimesTitle => _translate(ku: 'کاتی نوێژەکان', ar: 'مواقيت الصلاة', en: 'Prayer Times');
  String get prayerFajr => _translate(ku: 'بەیانی', ar: 'الفجر', en: 'Fajr');
  String get prayerSunrise => _translate(ku: 'ڕۆژهەڵات', ar: 'الشروق', en: 'Sunrise');
  String get prayerDhuhr => _translate(ku: 'نیوەڕۆ', ar: 'الظهر', en: 'Dhuhr');
  String get prayerAsr => _translate(ku: 'عەسڕ', ar: 'العصر', en: 'Asr');
  String get prayerMaghrib => _translate(ku: 'مەغریب', ar: 'المغرب', en: 'Maghrib');
  String get prayerIsha => _translate(ku: 'عیشا', ar: 'العشاء', en: 'Isha');
  String get prayerSelectCity => _translate(ku: 'شارەکەت هەڵبژێرە', ar: 'اختر مدينتك', en: 'Select City');
  String get prayerNextPrayer => _translate(ku: 'نوێژی داهاتوو', ar: 'الصلاة القادمة', en: 'Next Prayer');
  String get prayerTimeRemaining => _translate(ku: 'ماوە بۆ نوێژ', ar: 'المتبقي للصلاة', en: 'Time Remaining');
  String get prayerAzanNotification => _translate(ku: 'ئاگادارکردنەوەی نوێژەکان', ar: 'تنبيه الأذان', en: 'Azan Notification');
  String get prayerAzanNotificationSub => _translate(ku: 'لێدانی دەنگی ئازان لە کاتی هاتنی نوێژەکاندا', ar: 'تشغيل صوت الأذان عند دخول وقت الصلاة', en: 'Play Azan sound when prayer time starts');
  String get prayerTimesNotificationEnabled => _translate(ku: 'چالاککردنی دەنگی ئازان', ar: 'تفعيل صوت الأذان', en: 'Enable Azan sound');

  // ── Redesign Additions ─────────────────────────────────────────────
  String get welcome => _translate(ku: 'بەخێربێیت', ar: 'مرحباً بك', en: 'Welcome');
  String get guestProfileSub => _translate(ku: 'تۆمارێکی نوێ بکە بۆ هاوکاتکردنی دەستکەوتەکان، بەردەوامی، پشتیوانی و ئامارەکان.', ar: 'سجل الدخول لمزامنة إنجازاتك وسلسلتك وإحصائياتك.', en: 'Login to sync your achievements, streak, and statistics.');
  String get login => _translate(ku: 'چوونە ژوورەوە', ar: 'تسجيل الدخول', en: 'Login');
  String get register => _translate(ku: 'تۆمارکردن', ar: 'إنشاء حساب', en: 'Register');
  String get personalizationGroup => _translate(ku: 'تایبەتمەندکردن', ar: 'التخصيص', en: 'Personalization');
  String get progressGroup => _translate(ku: 'پێشکەوتن', ar: 'التقدم', en: 'Progress');
  String get productivityGroup => _translate(ku: 'بەرهەمداری', ar: 'الإنتاجية', en: 'Productivity');
  String get dataGroup => _translate(ku: 'داتا', ar: 'البيانات', en: 'Data');
  String get menuThemes => _translate(ku: 'ڕووکارەکان', ar: 'السمات', en: 'Themes');
  String get menuCounterSettings => _translate(ku: 'ڕێکخستنی ژمارەکەر', ar: 'إعدادات العداد', en: 'Counter Settings');
  String get menuFingerprintMode => _translate(ku: 'مۆدی پەنجەمۆر', ar: 'وضع البصمة', en: 'Fingerprint Mode');
  String get menuStatistics => _translate(ku: 'ئامارەکان', ar: 'الإحصائيات', en: 'Statistics');
  String get menuDailyGoals => _translate(ku: 'ئامانجە ڕۆژانەکان', ar: 'الأهداف اليومية', en: 'Daily Goals');
  String get menuAchievements => _translate(ku: 'دەستکەوتەکان', ar: 'الإنجازات', en: 'Achievements');
  String get menuStreakSystem => _translate(ku: 'سیستەمی بەردەوامی', ar: 'نظام السلسلة', en: 'Streak System');
  String get menuSessions => _translate(ku: 'خولەکانی زیکر', ar: 'جلسات الذكر', en: 'Dhikr Sessions');
  String get menuSmartReminders => _translate(ku: 'ئاگادارکەرەوە زیرەکەکان', ar: 'التذكيرات الذكية', en: 'Smart Reminders');
  String get menuBackupRestore => _translate(ku: 'پاشەکەوت و گەڕاندنەوە', ar: 'النسخ الاحتياطي والاستعادة', en: 'Backup & Restore');
  String get cardNextAchievement => _translate(ku: 'دەستکەوتی داهاتوو', ar: 'الإنجاز التالي', en: 'Next Achievement');
  String get cardLastSession => _translate(ku: 'کۆتا خول', ar: 'الجلسة الأخيرة', en: 'Last Session');
  String get cardInsight => _translate(ku: 'تێڕوانین', ar: 'التحليلات', en: 'Insight');
  String get productivityScoreLabel => _translate(ku: 'نمرەی بەرهەمداری', ar: 'درجة الإنتاجية', en: 'Productivity Score');
  String get bestStreakLabel => _translate(ku: 'باشترین بەردەوامی', ar: 'أفضل سلسلة', en: 'Best Streak');
  String get totalSessionsLabel => _translate(ku: 'کۆی خولەکان', ar: 'إجمالي الجلسات', en: 'Total Sessions');
  String get dhikrWord => _translate(ku: 'زیکر', ar: 'ذكر', en: 'Dhikr');
  String get minutesWord => _translate(ku: 'خولەک', ar: 'دقيقة', en: 'Minutes');
  String get firstTimeHintTap => _translate(ku: 'لە هەر شوێنێک دابگرە بۆ ژماردن.', ar: 'انقر في أي مكان للعد.', en: 'Tap anywhere to count.');
  String get firstTimeHintSettings => _translate(ku: '⚙️ بکەرەوە بۆ تایبەتمەندییە پێشکەوتووەکان.', ar: 'افتح ⚙️ للإعدادات المتقدمة.', en: 'Open ⚙️ for advanced settings.');

  // ── Quran Reader Enhancements ──────────────────────────────────────
  String get continueReading => _translate(ku: 'بەردەوامبە لە خوێندنەوە', ar: 'متابعة القراءة', en: 'Continue Reading');
  String get recentReads => _translate(ku: 'خوێندنەوەکانی ئەم دواییە', ar: 'القراءات الأخيرة', en: 'Recent Reads');
  String get juz => _translate(ku: 'جزء', ar: 'الجزء', en: 'Juz');
  String get hizb => _translate(ku: 'حزب', ar: 'الحزب', en: 'Hizb');
  String get rubHizb => _translate(ku: 'ڕوبع', ar: 'ربع الحزب', en: 'Rub Al-Hizb');
  String get manzil => _translate(ku: 'مەنزل', ar: 'المنزل', en: 'Manzil');
  String get sajdah => _translate(ku: 'سەجدە', ar: 'السجدة', en: 'Sajdah');
  String get dailyGoal => _translate(ku: 'ئامانجی ڕۆژانە', ar: 'الهدف اليومي', en: 'Daily Goal');
  String get dailyGoalProgress => _translate(ku: 'پێشکەوتن لە ئامانجی ڕۆژانە', ar: 'تقدم الهدف اليومي', en: 'Daily Goal Progress');
  String get khatmahProgress => _translate(ku: 'پێشکەوتنی خەتمە', ar: 'تقدم الختمة', en: 'Khatmah Progress');
  String get estimatedCompletion => _translate(ku: 'تەواوبوونی خەمڵێنراو', ar: 'التاريخ المتوقع للإتمام', en: 'Estimated Completion');
  String get pagesRemaining => _translate(ku: 'لاپەڕە ماوە', ar: 'صفحة متبقية', en: 'Pages Remaining');
  String get juzRemaining => _translate(ku: 'جوزء ماوە', ar: 'جزء متبقي', en: 'Juz Remaining');
  String get readingStreak => _translate(ku: 'بەردەوامی خوێندن', ar: 'سلسلة القراءة', en: 'Reading Streak');
  String get readingSessions => _translate(ku: 'خولەکانی خوێندن', ar: 'جلسات القراءة', en: 'Reading Sessions');
  String get uniqueAyahsRead => _translate(ku: 'ئایەتە جیاوازەکان', ar: 'الآيات الفريدة المقروءة', en: 'Unique Ayahs Read');
  String get completions => _translate(ku: 'تەواوکردنەکان', ar: 'الختمات المكتملة', en: 'Completions');
  String get bookmarkCategory => _translate(ku: 'پۆلی نیشانەکان', ar: 'فئة العلامة المرجعية', en: 'Bookmark Category');
  String get readingBookmark => _translate(ku: 'نیشانەی خوێندنەوە', ar: 'علامة القراءة', en: 'Reading Bookmark');
  String get memorizationBookmark => _translate(ku: 'نیشانەی لەبەرکردن', ar: 'علامة الحفظ', en: 'Memorization Bookmark');
  String get reflectionBookmark => _translate(ku: 'نیشانەی تێڕامان', ar: 'علامة التدبر', en: 'Reflection Bookmark');
  String get favoriteBookmark => _translate(ku: 'نیشانەی دڵخواز', ar: 'علامة المفضلة', en: 'Favorite Bookmark');
  String get sajdahTypeObligatory => _translate(ku: 'واجب', ar: 'واجبة', en: 'Obligatory');
  String get sajdahTypeRecommended => _translate(ku: 'سوننەت', ar: 'مستحبة', en: 'Recommended');
  String get sajdahInfo => _translate(ku: 'ئەم ئایەتە سەجدەی تێدایە (%s)', ar: 'هذه الآية تحتوي على سجدة (%s)', en: 'This verse contains a sajdah (%s)');
  String get quickJump => _translate(ku: 'بازدانی خێرا', ar: 'الانتقال السريع', en: 'Quick Jump');
  String get jumpHint => _translate(ku: 'ژمارەی لاپەڕە یان سورەت بنووسە...', ar: 'أدخل رقم الصفحة أو السورة...', en: 'Enter page or surah number...');
  String get readTimeJustNow => _translate(ku: 'ئێستا', ar: 'الآن', en: 'Just now');

  String readTimeFormat(int mins) {
    return _translate(
      ku: 'پێش $mins خولەک',
      ar: 'قبل $mins دقيقة',
      en: '$mins mins ago',
    );
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ku', 'ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale.languageCode));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class RtlKurdishWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const RtlKurdishWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    // Load 'ar' (which is RTL and supported) to avoid unsupported locale assertions for 'ku'
    final defaultLocalizations =
        await GlobalWidgetsLocalizations.delegate.load(const Locale('ar'));
    return _RtlKurdishWidgetsLocalizations(defaultLocalizations);
  }

  @override
  bool shouldReload(RtlKurdishWidgetsLocalizationsDelegate old) => false;
}

class RtlKurdishMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const RtlKurdishMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Fallback to 'ar' material localizations for Kurdish to keep RTL and standard layout behavior
    return GlobalMaterialLocalizations.delegate.load(const Locale('ar'));
  }

  @override
  bool shouldReload(RtlKurdishMaterialLocalizationsDelegate old) => false;
}

class RtlKurdishCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const RtlKurdishCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ku';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    // Fallback to 'ar' cupertino localizations for Kurdish
    return GlobalCupertinoLocalizations.delegate.load(const Locale('ar'));
  }

  @override
  bool shouldReload(RtlKurdishCupertinoLocalizationsDelegate old) => false;
}

class _RtlKurdishWidgetsLocalizations implements WidgetsLocalizations {
  final WidgetsLocalizations delegate;
  _RtlKurdishWidgetsLocalizations(this.delegate);

  @override
  TextDirection get textDirection => TextDirection.rtl;

  @override
  String get copyButtonLabel => delegate.copyButtonLabel;

  @override
  String get cutButtonLabel => delegate.cutButtonLabel;

  @override
  String get pasteButtonLabel => delegate.pasteButtonLabel;

  @override
  String get selectAllButtonLabel => delegate.selectAllButtonLabel;

  @override
  String get lookUpButtonLabel => delegate.lookUpButtonLabel;

  @override
  String get searchWebButtonLabel => delegate.searchWebButtonLabel;

  @override
  String get shareButtonLabel => delegate.shareButtonLabel;

  @override
  String get noResultsFound => delegate.noResultsFound;

  @override
  String get reorderItemUp => delegate.reorderItemUp;

  @override
  String get reorderItemDown => delegate.reorderItemDown;

  @override
  String get reorderItemLeft => delegate.reorderItemLeft;

  @override
  String get reorderItemRight => delegate.reorderItemRight;

  @override
  String get reorderItemToEnd => delegate.reorderItemToEnd;

  @override
  String get reorderItemToStart => delegate.reorderItemToStart;

  @override
  String get radioButtonUnselectedLabel => delegate.radioButtonUnselectedLabel;

  @override
  String get searchResultsFound => delegate.searchResultsFound;
}
