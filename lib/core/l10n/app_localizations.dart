import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  AppLocalizations
//  Single source-of-truth for all translatable UI strings (En / Ku / Ar).
//  Mirrors the Laravel /resources/lang/{ku|ar|en}/*.php structure.
//
//  Usage:
//    final l = AppLocalizations.of(context);
//    Text(l.navHome)
//  Or via the BuildContext extension:
//    Text(context.l10n.navHome)
// ─────────────────────────────────────────────────────────────────────────────

class AppLocalizations {
  // ignore: prefer_const_constructor_declarations
  AppLocalizations(this._lang);

  final String _lang;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations('ku');
  }

  // ── Internal helper ────────────────────────────────────────────────────────
  String _t(Map<String, String> translations) =>
      translations[_lang] ?? translations['ku'] ?? '';

  // ═══════════════════════════════════════════════════════════════════════════
  //  APP
  // ═══════════════════════════════════════════════════════════════════════════

  String get appName => _t({
        'ku': 'قورئانەکەم',
        'ar': 'قرآني',
        'en': 'My Quran',
      });

  String get appSubtitle => _t({
        'ku': 'ئەپڵیکەیشنی قورئان',
        'ar': 'تطبيق القرآن الكريم',
        'en': 'Quran Application',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  String get navHome => _t({
        'ku': 'سەرەکی',
        'ar': 'الرئيسية',
        'en': 'Home',
      });

  String get navQuran => _t({
        'ku': 'قورئان',
        'ar': 'القرآن',
        'en': 'Quran',
      });

  String get navTasbih => _t({
        'ku': 'تەسبیح',
        'ar': 'التسبيح',
        'en': 'Tasbih',
      });

  String get navBookmarks => _t({
        'ku': 'بوکمارک',
        'ar': 'الإشارات',
        'en': 'Bookmarks',
      });

  String get navSettings => _t({
        'ku': 'ڕێکخستن',
        'ar': 'الإعدادات',
        'en': 'Settings',
      });

  String get navCommunity => _t({
        'ku': 'کۆمەڵگا',
        'ar': 'المجتمع',
        'en': 'Community',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  HOME PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  String get homeGreeting => _t({
        'ku': 'بەخێربێیت',
        'ar': 'أهلاً وسهلاً',
        'en': 'Welcome',
      });

  String get homeDailyVerse => _t({
        'ku': 'ئایەتی ڕۆژ',
        'ar': 'آية اليوم',
        'en': 'Verse of the Day',
      });

  String get homeContinueReading => _t({
        'ku': 'بەردەوامکردنی خوێندنەوە',
        'ar': 'متابعة القراءة',
        'en': 'Continue Reading',
      });

  String get homeStartReading => _t({
        'ku': 'دەستپێکردنی قورئانی پیرۆز',
        'ar': 'ابدأ قراءة القرآن',
        'en': 'Start Reading Quran',
      });

  String get homeFeatures => _t({
        'ku': 'تایبەتمەندییەکان',
        'ar': 'الميزات',
        'en': 'Features',
      });

  String get homeQuranSub => _t({
        'ku': '١١٤ سورە · ٦٢٣٦ ئایەت',
        'ar': '١١٤ سورة · ٦٢٣٦ آية',
        'en': '114 Surahs · 6236 Verses',
      });

  String get homeStatSurahs => _t({
        'ku': 'سورە',
        'ar': 'سورة',
        'en': 'Surahs',
      });

  String get homeStatBookmarks => _t({
        'ku': 'بوکمارک',
        'ar': 'إشارة',
        'en': 'Bookmarks',
      });

  String get homeStatTasbih => _t({
        'ku': 'تەسبیح',
        'ar': 'تسبيح',
        'en': 'Tasbih',
      });

  String get homeDailyGoals => _t({
        'ku': 'ئامانجەکانی ئەمڕۆ',
        'ar': 'أهداف اليوم',
        'en': 'Daily Goals',
      });

  String get homeDigitalDhikr => _t({
        'ku': 'ذکری دیجیتاڵ',
        'ar': 'ذكر رقمي',
        'en': 'Digital Dhikr',
      });

  String get homeSavedVerses => _t({
        'ku': 'پاشەکەوتەکان',
        'ar': 'المحفوظة',
        'en': 'Saved Verses',
      });

  String get homeVerseSearch => _t({
        'ku': 'گەڕانی ئایەت',
        'ar': 'بحث الآيات',
        'en': 'Verse Search',
      });

  String get homeReadingStreak => _t({
        'ku': 'زنجیرەی خوێندنەوە',
        'ar': 'سلسلة القراءة',
        'en': 'Reading Streak',
      });

  String get homeStreakDays => _t({
        'ku': 'ڕۆژ لەسەر یەک',
        'ar': 'أيام متتالية',
        'en': 'Days in a row',
      });

  String homeStreakDaysCount(int count) => _t({
        'ku': '$count ڕۆژ لەسەر یەک',
        'ar': '$count ${count >= 3 && count <= 10 ? 'أيام متتالية' : 'يوم متتالي'}',
        'en': '$count ${count == 1 ? 'day' : 'days'} in a row',
      });

  String get homeStreakLongest => _t({
        'ku': 'درێژترین',
        'ar': 'الأطول',
        'en': 'Longest',
      });

  String get homeStreakTodayDone => _t({
        'ku': '🎉 ئامانجی ئەمڕۆت بەجێهێنا! سبەینێش بەردەوام بە.',
        'ar': '🎉 أتممت هدف اليوم! واصل غداً.',
        'en': '🎉 Today\'s goal done! Keep it up tomorrow.',
      });

  String get homeStreakTodayPending => _t({
        'ku': '📖 ئەمڕۆ قورئانت نەخوێندووە، بخوێنە بۆ هێشتنەوەی زنجیرەکەت.',
        'ar': '📖 لم تقرأ اليوم، اقرأ للحفاظ على سلسلتك.',
        'en': '📖 No reading today yet. Read to keep your streak!',
      });

  String get homeStreakNoActive => _t({
        'ku': 'هیچ زنجیرەیەک چالاک نییە',
        'ar': 'لا توجد سلسلة قراءة نشطة',
        'en': 'No active streak',
      });

  // Home goal items
  String get homeGoal1 => _t({
        'ku': 'خوێندنەوەی ١ پەڕەی قورئان',
        'ar': 'قراءة صفحة من القرآن',
        'en': 'Read 1 page of Quran',
      });

  String get homeGoal2 => _t({
        'ku': 'ئەنجامدانی ٣٣ تەسبیح',
        'ar': 'أداء ٣٣ تسبيحة',
        'en': 'Complete 33 tasbih',
      });

  String get homeGoal3 => _t({
        'ku': 'بیستنی ڕیکردی دەنگ',
        'ar': 'استماع تلاوة صوتية',
        'en': 'Listen to audio recitation',
      });

  String get homeGoal4 => _t({
        'ku': 'بوکمارک کردنی ئایەتێک',
        'ar': 'حفظ آية كإشارة مرجعية',
        'en': 'Bookmark a verse',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  QURAN PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  String get quranTitle => _t({
        'ku': 'قورئانی پیرۆز',
        'ar': 'القرآن الكريم',
        'en': 'Holy Quran',
      });

  String get quranAll => _t({
        'ku': 'هەموو',
        'ar': 'الكل',
        'en': 'All',
      });

  String get quranMeccan => _t({
        'ku': 'مەکی',
        'ar': 'مكية',
        'en': 'Meccan',
      });

  String get quranMedinan => _t({
        'ku': 'مەدەنی',
        'ar': 'مدنية',
        'en': 'Medinan',
      });

  String get quranBookmarked => _t({
        'ku': 'بوکمارک',
        'ar': 'المحفوظة',
        'en': 'Bookmarked',
      });

  String get quranAyahs => _t({
        'ku': 'ئایەت',
        'ar': 'آية',
        'en': 'Ayahs',
      });

  String get quranSurahNumber => _t({
        'ku': 'سورە',
        'ar': 'سورة',
        'en': 'Surah',
      });

  String get quranSearchHint => _t({
        'ku': 'گەڕانی سورە، ناوی ئینگلیزی یان ژمارە...',
        'ar': 'ابحث عن سورة بالاسم أو الرقم...',
        'en': 'Search surah by name or number...',
      });

  String get quranJuz => _t({
        'ku': 'جوز',
        'ar': 'جزء',
        'en': 'Juz',
      });

  String get quranPage => _t({
        'ku': 'پەڕە',
        'ar': 'صفحة',
        'en': 'Page',
      });

  String get quranBismillah => _t({
        'ku': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'ar': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'en': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  READER PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  String get readerGoToAyah => _t({
        'ku': 'چووون بۆ ئایەتێک',
        'ar': 'الانتقال إلى آية',
        'en': 'Go to Ayah',
      });

  String get readerAyahNumber => _t({
        'ku': 'ژمارەی ئایەت',
        'ar': 'رقم الآية',
        'en': 'Ayah Number',
      });

  String get readerGoBtn => _t({
        'ku': 'بڕۆ',
        'ar': 'اذهب',
        'en': 'Go',
      });

  String get readerInvalidAyah => _t({
        'ku': 'ژمارەی ئایەتەکە دروست نییە',
        'ar': 'رقم الآية غير صحيح',
        'en': 'Invalid ayah number',
      });

  String get readerBookmark => _t({
        'ku': 'بوکمارک',
        'ar': 'إشارة مرجعية',
        'en': 'Bookmark',
      });

  String get readerCopy => _t({
        'ku': 'کۆپیکردن',
        'ar': 'نسخ',
        'en': 'Copy',
      });

  String get readerShare => _t({
        'ku': 'هاوبەشکردن',
        'ar': 'مشاركة',
        'en': 'Share',
      });

  String get readerCopied => _t({
        'ku': 'کۆپیکرا!',
        'ar': 'تم النسخ!',
        'en': 'Copied!',
      });

  String get readerBookmarked => _t({
        'ku': 'بوکمارک کرا',
        'ar': 'تمت الإشارة',
        'en': 'Bookmarked',
      });

  String get readerBookmarkRemoved => _t({
        'ku': 'بوکمارک سڕایەوە',
        'ar': 'تمت إزالة الإشارة',
        'en': 'Bookmark removed',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  TASBIH PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  String get tasbihTitle => _t({
        'ku': 'تەسبیح',
        'ar': 'التسبيح',
        'en': 'Tasbih',
      });

  String get tasbihTapToCount => _t({
        'ku': 'تەپی بکە بۆ ژمارەکردن',
        'ar': 'انقر للعد',
        'en': 'Tap to count',
      });

  String get tasbihReset => _t({
        'ku': 'سڕینەوە',
        'ar': 'إعادة تعيين',
        'en': 'Reset',
      });

  String get tasbihResetAll => _t({
        'ku': 'سڕینەوەی هەموو',
        'ar': 'إعادة تعيين الكل',
        'en': 'Reset All',
      });

  String get tasbihTotal => _t({
        'ku': 'کۆی گشتی',
        'ar': 'المجموع الكلي',
        'en': 'Total Count',
      });

  String get tasbihSubhanAllah => _t({
        'ku': 'سُبْحَانَ اللَّه',
        'ar': 'سُبْحَانَ اللَّه',
        'en': 'SubhanAllah',
      });

  String get tasbihAlhamdulillah => _t({
        'ku': 'الْحَمْدُ لِلَّه',
        'ar': 'الْحَمْدُ لِلَّه',
        'en': 'Alhamdulillah',
      });

  String get tasbihAllahuAkbar => _t({
        'ku': 'اللَّهُ أَكْبَر',
        'ar': 'اللَّهُ أَكْبَر',
        'en': 'Allahu Akbar',
      });

  String get tasbihAddDhikr => _t({
        'ku': 'زیادکردنی ذکر',
        'ar': 'إضافة ذكر',
        'en': 'Add Dhikr',
      });

  String get tasbihDhikrName => _t({
        'ku': 'ناوی ذکر',
        'ar': 'اسم الذكر',
        'en': 'Dhikr Name',
      });

  String get tasbihDhikrArabic => _t({
        'ku': 'دەقی عەرەبی (ئارەزوومەندانە)',
        'ar': 'النص العربي (اختياري)',
        'en': 'Arabic text (optional)',
      });

  String get tasbihTarget => _t({
        'ku': 'ئامانج',
        'ar': 'الهدف',
        'en': 'Target',
      });

  String get tasbihAdd => _t({
        'ku': 'زیادکردن',
        'ar': 'إضافة',
        'en': 'Add',
      });

  String get tasbihCycleComplete => _t({
        'ku': 'قَبِلَ اللهُ مِنْكُم',
        'ar': 'قَبِلَ اللهُ مِنْكُم',
        'en': 'May Allah accept from you',
      });

  String get tasbihLongestStreak => _t({
        'ku': 'درێژترین زنجیرە',
        'ar': 'أطول سلسلة',
        'en': 'Longest Streak',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  SEARCH PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  String get searchTitle => _t({
        'ku': 'گەڕان',
        'ar': 'البحث',
        'en': 'Search',
      });

  String get searchHint => _t({
        'ku': 'گەڕانی سورە یان ئایەت...',
        'ar': 'ابحث في سورة أو آية...',
        'en': 'Search surah or verse...',
      });

  String get searchRecent => _t({
        'ku': 'گەڕانەکانی پێشوو',
        'ar': 'عمليات البحث الأخيرة',
        'en': 'Recent searches',
      });

  String get searchNoResults => _t({
        'ku': 'ئەنجامێک نەدۆزرایەوە',
        'ar': 'لم يتم العثور على نتائج',
        'en': 'No results found',
      });

  String get searchClearAll => _t({
        'ku': 'پاککردنەوەی هەموو',
        'ar': 'مسح الكل',
        'en': 'Clear all',
      });

  String get searchError => _t({
        'ku': 'هەڵەیەک ڕوویدا لە کاتی گەڕاندا',
        'ar': 'حدث خطأ أثناء البحث',
        'en': 'An error occurred during search',
      });

  String get searchNoRecent => _t({
        'ku': 'گەڕانی پێشوو نییە',
        'ar': 'لا توجد عمليات بحث سابقة',
        'en': 'No recent searches',
      });

  String get searchNoRecentDesc => _t({
        'ku': 'ناوی سورە یان ژمارە بنووسە',
        'ar': 'اكتب اسم السورة أو رقمها',
        'en': 'Type surah name or number',
      });

  String searchResultsFound(int count) => _t({
        'ku': '$count ئەنجام دۆزرایەوە',
        'ar': 'تم العثور على $count من النتائج',
        'en': '$count results found',
      });

  String searchNotFound(String query) => _t({
        'ku': '"$query" نەدۆزرایەوە',
        'ar': 'لم يتم العثور على "$query"',
        'en': '"$query" not found',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  BOOKMARKS PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  String get bookmarksTitle => _t({
        'ku': 'بوکمارکەکان',
        'ar': 'الإشارات المرجعية',
        'en': 'Bookmarks',
      });

  String get bookmarksEmpty => _t({
        'ku': 'بوکمارکێک نییە',
        'ar': 'لا توجد إشارات مرجعية',
        'en': 'No bookmarks yet',
      });

  String get bookmarksEmptyDesc => _t({
        'ku': 'کاتێک ئایەتێک بوکمارک دەکەیت ئینجا دەردەکەویت',
        'ar': 'عند حفظ آية كإشارة مرجعية ستظهر هنا',
        'en': 'When you bookmark a verse it will appear here',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  SETTINGS PAGE
  // ═══════════════════════════════════════════════════════════════════════════

  String get settingsTitle => _t({
        'ku': 'ڕێکخستنەکان',
        'ar': 'الإعدادات',
        'en': 'Settings',
      });

  String get settingsAppearance => _t({
        'ku': 'ڕووکار',
        'ar': 'المظهر',
        'en': 'Appearance',
      });

  String get settingsDarkMode => _t({
        'ku': 'دارک مۆد',
        'ar': 'الوضع الداكن',
        'en': 'Dark Mode',
      });

  String get settingsLightMode => _t({
        'ku': 'لایت مۆد',
        'ar': 'الوضع الفاتح',
        'en': 'Light Mode',
      });

  String get settingsSystemTheme => _t({
        'ku': 'تیمی سیستەم',
        'ar': 'مظهر النظام',
        'en': 'System Theme',
      });

  String get settingsFontSize => _t({
        'ku': 'قەبارەی فۆنت',
        'ar': 'حجم الخط',
        'en': 'Font Size',
      });

  String get settingsFontSmall => _t({
        'ku': 'بچووک',
        'ar': 'صغير',
        'en': 'Small',
      });

  String get settingsFontMedium => _t({
        'ku': 'مامناوەند',
        'ar': 'متوسط',
        'en': 'Medium',
      });

  String get settingsFontLarge => _t({
        'ku': 'گەورە',
        'ar': 'كبير',
        'en': 'Large',
      });

  String get settingsLanguage => _t({
        'ku': 'زمان',
        'ar': 'اللغة',
        'en': 'Language',
      });

  String get settingsKurdish => _t({
        'ku': 'کوردی',
        'ar': 'الكردية',
        'en': 'Kurdish',
      });

  String get settingsArabic => _t({
        'ku': 'عەرەبی',
        'ar': 'العربية',
        'en': 'Arabic',
      });

  String get settingsEnglish => _t({
        'ku': 'ئینگلیزی',
        'ar': 'الإنجليزية',
        'en': 'English',
      });

  String get settingsTranslations => _t({
        'ku': 'وەرگێڕان',
        'ar': 'الترجمات',
        'en': 'Translations',
      });

  String get settingsKuTranslation => _t({
        'ku': 'وەرگێڕانی کوردی',
        'ar': 'الترجمة الكردية',
        'en': 'Kurdish Translation',
      });

  String get settingsKuTranslationSub => _t({
        'ku': 'بورهان محمد ئەمین (ڕێبەر)',
        'ar': 'برهان محمد أمين (ريبر)',
        'en': 'Burhan Muhammad Amin (Rêber)',
      });

  String get settingsEnTranslation => _t({
        'ku': 'وەرگێڕانی ئینگلیزی',
        'ar': 'الترجمة الإنجليزية',
        'en': 'English Translation',
      });

  String get settingsEnTranslationSub => _t({
        'ku': 'Saheeh International',
        'ar': 'صحيح إنترناشيونال',
        'en': 'Saheeh International',
      });

  String get settingsAbout => _t({
        'ku': 'دەربارە',
        'ar': 'حول التطبيق',
        'en': 'About',
      });

  String get settingsVersion => _t({
        'ku': 'وەشان',
        'ar': 'الإصدار',
        'en': 'Version',
      });

  String get settingsForKurdistan => _t({
        'ku': '♥  بۆ کوردستان',
        'ar': '♥  لكردستان',
        'en': '♥  For Kurdistan',
      });

  String get settingsAppVersionDisplay => _t({
        'ku': 'قورئانەکەم · وەشان ١.٠.٠',
        'ar': 'قرآني · الإصدار ١.٠.٠',
        'en': 'My Quran · Version 1.0.0',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  COMMUNITY / AUTH
  // ═══════════════════════════════════════════════════════════════════════════

  String get communityTitle => _t({
        'ku': 'کۆمەڵگا',
        'ar': 'المجتمع',
        'en': 'Community',
      });

  String get communityLeaderboard => _t({
        'ku': 'ڕیزبەندی',
        'ar': 'لوحة المتصدرين',
        'en': 'Leaderboard',
      });

  String get communityDaily => _t({
        'ku': 'ڕۆژانە',
        'ar': 'يومي',
        'en': 'Daily',
      });

  String get communityWeekly => _t({
        'ku': 'هەفتانە',
        'ar': 'أسبوعي',
        'en': 'Weekly',
      });

  String get communityMonthly => _t({
        'ku': 'مانگانە',
        'ar': 'شهري',
        'en': 'Monthly',
      });

  String get communityAllTime => _t({
        'ku': 'هەموو کات',
        'ar': 'الكل',
        'en': 'All Time',
      });

  String get communityNoUsers => _t({
        'ku': 'هیچ بەکارهێنەرێک نەدۆزرایەوە',
        'ar': 'لا يوجد قراء بعد',
        'en': 'No users found',
      });

  String get communityPoints => _t({
        'ku': 'خاڵ',
        'ar': 'نقاط',
        'en': 'pts',
      });

  String get communityStreak => _t({
        'ku': 'ڕۆژ',
        'ar': 'يوم',
        'en': 'days',
      });

  String get communityRank => _t({
        'ku': 'پلە',
        'ar': 'الترتيب',
        'en': 'Rank',
      });

  String get communityYou => _t({
        'ku': 'تۆ',
        'ar': 'أنت',
        'en': 'You',
      });

  String get authLogin => _t({
        'ku': 'چوونەژوورەوە',
        'ar': 'تسجيل الدخول',
        'en': 'Log In',
      });

  String get authRegister => _t({
        'ku': 'تۆمارکردن',
        'ar': 'التسجيل',
        'en': 'Register',
      });

  String get authLogout => _t({
        'ku': 'چوونەدەرەوە',
        'ar': 'تسجيل الخروج',
        'en': 'Log Out',
      });

  String get authName => _t({
        'ku': 'ناو',
        'ar': 'الاسم',
        'en': 'Name',
      });

  String get authNameHint => _t({
        'ku': 'ناو بنووسە',
        'ar': 'أدخل اسمك',
        'en': 'Enter your name',
      });

  String get authEmail => _t({
        'ku': 'ئیمەیڵ',
        'ar': 'البريد الإلكتروني',
        'en': 'Email',
      });

  String get authPassword => _t({
        'ku': 'وشەی نهێنی',
        'ar': 'كلمة المرور',
        'en': 'Password',
      });

  String get authWelcomeBack => _t({
        'ku': 'بەخێربێیتەوە',
        'ar': 'مرحباً بعودتك',
        'en': 'Welcome back',
      });

  String get authNeedLogin => _t({
        'ku': 'دەبێت بچیتە ژوورەوە بۆ بینینی ئەم بەشە',
        'ar': 'يجب تسجيل الدخول لرؤية هذا القسم',
        'en': 'Please log in to view this section',
      });

  String get authWelcomeSub => _t({
        'ku': 'بچۆ ژوورەوە بۆ بەشداریکردن لە کۆمەڵگە و پێشبڕکێ',
        'ar': 'سجل دخولك للمشاركة في المجتمع وجدول الصدارة',
        'en': 'Sign in to join the community and leaderboard',
      });

  String get authRegisterTitle => _t({
        'ku': 'دروستکردنی ئەکاونت',
        'ar': 'إنشاء حساب جديد',
        'en': 'Create Account',
      });

  String get authRegisterSub => _t({
        'ku': 'خۆت تۆمار بکە بۆ بینینی خاڵەکانت لە خشتەی پێشەنگەکان',
        'ar': 'سجل معنا لمتابعة تقدمك ومنافسة القراء',
        'en': 'Register to track your streaks and rank',
      });

  String get authEmailInvalid => _t({
        'ku': 'تکایە ئیمەیڵێکی دروست بنووسە',
        'ar': 'يرجى إدخال بريد إلكتروني صحيح',
        'en': 'Please enter a valid email',
      });

  String get authPasswordShort => _t({
        'ku': 'نهێنوشە دەبێت لە ٨ پیت کەمتر نەبێت',
        'ar': 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
        'en': 'Password must be at least 8 characters',
      });

  String get authNameEmpty => _t({
        'ku': 'تکایە ناوت بنووسە',
        'ar': 'يرجى إدخال اسمك',
        'en': 'Please enter your name',
      });

  String get authNoAccount => _t({
        'ku': 'ئەکاونتت نییە؟ تۆمار بە',
        'ar': 'ليس لديك حساب؟ سجل الآن',
        'en': "Don't have an account? Sign Up",
      });

  String get authHasAccount => _t({
        'ku': 'ئەکاونتت هەیە؟ بچۆ ژوورەوە',
        'ar': 'لديك حساب بالفعل؟ سجل دخولك',
        'en': 'Already have an account? Login',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  COMMON
  // ═══════════════════════════════════════════════════════════════════════════

  String get commonSave => _t({
        'ku': 'پاشەکەوت',
        'ar': 'حفظ',
        'en': 'Save',
      });

  String get commonCancel => _t({
        'ku': 'ڕەتکردنەوە',
        'ar': 'إلغاء',
        'en': 'Cancel',
      });

  String get commonDelete => _t({
        'ku': 'سڕینەوە',
        'ar': 'حذف',
        'en': 'Delete',
      });

  String get commonConfirm => _t({
        'ku': 'پشتڕاستکردنەوە',
        'ar': 'تأكيد',
        'en': 'Confirm',
      });

  String get commonLoading => _t({
        'ku': 'بارکردن...',
        'ar': 'جار التحميل...',
        'en': 'Loading...',
      });

  String get commonNoData => _t({
        'ku': 'زانیاری نییە',
        'ar': 'لا توجد بيانات',
        'en': 'No data',
      });

  String get commonBack => _t({
        'ku': 'گەڕانەوە',
        'ar': 'رجوع',
        'en': 'Back',
      });

  String get commonSearch => _t({
        'ku': 'گەڕان',
        'ar': 'بحث',
        'en': 'Search',
      });

  String get commonShare => _t({
        'ku': 'هاوبەشکردن',
        'ar': 'مشاركة',
        'en': 'Share',
      });

  String get commonAdd => _t({
        'ku': 'زیادکردن',
        'ar': 'إضافة',
        'en': 'Add',
      });

  String get commonClose => _t({
        'ku': 'داخستن',
        'ar': 'إغلاق',
        'en': 'Close',
      });

  String get commonAreYouSure => _t({
        'ku': 'ئایا دڵنیایت؟',
        'ar': 'هل أنت متأكد؟',
        'en': 'Are you sure?',
      });

  String get commonErrorLoading => _t({
        'ku': 'هەڵەیەک ڕوویدا لە بارکردنی داتا',
        'ar': 'حدث خطأ أثناء تحميل البيانات',
        'en': 'An error occurred while loading data',
      });

  String get commonAyah => _t({
        'ku': 'ئایەت',
        'ar': 'الآية',
        'en': 'Ayah',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  BANNER (home hero)
  // ═══════════════════════════════════════════════════════════════════════════

  String get bannerAyahArabic =>
      'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ';

  String get bannerAyahTranslation => _t({
        'ku': 'ئەم قورئانە ڕێنمایی دەکات بۆ ئەوەی ڕاستترینەوە',
        'ar': 'إن هذا القرآن يهدي للتي هي أقوم',
        'en': 'This Quran guides to that which is most right',
      });

  String get bannerAyahSource => _t({
        'ku': '— سورەی ئیسرا ١٧:٩',
        'ar': '— سورة الإسراء ١٧:٩',
        'en': '— Surah Al-Isra 17:9',
      });

  // ═══════════════════════════════════════════════════════════════════════════
  //  NEW READER & TASBIH DIALOG STRINGS
  // ═══════════════════════════════════════════════════════════════════════════

  String readerSearchAyahHint(int totalAyahs) => _t({
        'ku': 'گەڕان بەپێی ژمارەی ئایەت (١ - $totalAyahs)...',
        'ar': 'البحث برقم الآية (١ - $totalAyahs)...',
        'en': 'Search by ayah number (1 - $totalAyahs)...',
      });

  String readerSearchAyahRangeError(int totalAyahs) => _t({
        'ku': 'تکایە ژمارەیەک بنووسە لەنێوان ١ بۆ $totalAyahs',
        'ar': 'يرجى كتابة رقم بين ١ و $totalAyahs',
        'en': 'Please enter a number between 1 and $totalAyahs',
      });

  String get readerLoadingAyahsFromServer => _t({
        'ku': 'خەریکە داتا دەهێنرێت لە سێرڤەرەوە...',
        'ar': 'جاري تحميل البيانات من الخادم...',
        'en': 'Loading data from server...',
      });

  String get readerOfflineError => _t({
        'ku': 'پەیوەندی لەگەڵ سێرڤەر جێگیر نەبوو\nتکایە هێڵەکەت بپشکنە و دووبارە تاقیبکەرەوە',
        'ar': 'الاتصال بالخادم غير مستقر\nيرجى التحقق من الاتصال والمحاولة مرة أخرى',
        'en': 'Connection to server is unstable\nPlease check your internet and try again',
      });

  String get readerRetry => _t({
        'ku': 'دووبارە هەوڵبدەرەوە',
        'ar': 'إعادة المحاولة',
        'en': 'Retry',
      });

  String get readerTextSize => _t({
        'ku': 'قەبارەی دەق',
        'ar': 'حجم النص',
        'en': 'Text Size',
      });

  String get readerKuTranslation => _t({
        'ku': 'وەرگێڕانی کوردی (ڕێبەر)',
        'ar': 'الترجمة الكردية (ريبر)',
        'en': 'Kurdish Translation (Rêber)',
      });

  String get readerEnTranslation => _t({
        'ku': 'وەرگێڕانی ئینگلیزی (Saheeh International)',
        'ar': 'الترجمة الإنجليزية (صحيح إنترناشيونال)',
        'en': 'English Translation (Saheeh International)',
      });

  String get tasbihResetThis => _t({
        'ku': 'سفرکردنەوەی ئەم زکرە',
        'ar': 'إعادة تعيين هذا الذكر',
        'en': 'Reset this dhikr',
      });

  String get tasbihDeleteThis => _t({
        'ku': 'سڕینەوەی ئەم زکرە',
        'ar': 'حذف هذا الذكر',
        'en': 'Delete this dhikr',
      });

  String get tasbihResetAllTitle => _t({
        'ku': 'سفرکردنەوەی هەموو زکرەکان',
        'ar': 'إعادة تعيين جميع الأذكار',
        'en': 'Reset all dhikrs',
      });

  String get tasbihActions => _t({
        'ku': 'کردارەکان',
        'ar': 'الإجراءات',
        'en': 'Actions',
      });

  String get tasbihDhikrAdded => _t({
        'ku': 'زکرەکە بە سەرکەوتوویی زیادکرا',
        'ar': 'تمت إضافة الذكر بنجاح',
        'en': 'Dhikr added successfully',
      });

  String get tasbihDhikrNameRequired => _t({
        'ku': 'تکایە ناوی زکر بنووسە',
        'ar': 'يرجى إدخال اسم الذكر',
        'en': 'Please enter dhikr name',
      });

  String get tasbihTargetRequired => _t({
        'ku': 'تکایە ژمارەی ئامانج بنووسە',
        'ar': 'يرجى إدخال العدد المستهدف',
        'en': 'Please enter target count',
      });

  String get tasbihTargetInvalid => _t({
        'ku': 'دەبێت ژمارەیەکی دروست بێت لە ١ گەورەتر',
        'ar': 'يجب أن يكون رقماً صالحاً أكبر من 0',
        'en': 'Must be a valid number greater than 0',
      });

  String get tasbihDhikrNameLabel => _t({
        'ku': 'ناوی زکر (تەلەفوز/کوردی)',
        'ar': 'اسم الذكر (باللفظ/الكردي)',
        'en': 'Dhikr Name (Transliteration/Kurdish)',
      });

  String get tasbihDhikrArabicLabel => _t({
        'ku': 'دەقی عەرەبی (ئارەزوومەندانە)',
        'ar': 'النص العربي (اختياري)',
        'en': 'Arabic text (optional)',
      });

  String get tasbihTargetLabel => _t({
        'ku': 'ژمارەی ئامانج (Target)',
        'ar': 'العدد المستهدف',
        'en': 'Target count',
      });

  String get tasbihAddDhikrTitle => _t({
        'ku': 'زیادکردنی زکری نوێ',
        'ar': 'إضافة ذكر جديد',
        'en': 'Add new Dhikr',
      });

  String get readerComingSoon => _t({
        'ku': 'بەم زووانە بەردەست دەبێت',
        'ar': 'قريباً جداً',
        'en': 'Coming soon',
      });

  String get readerDesc => _t({
        'ku': 'بەشی خوێندنەوەی سورەتەکان بەم زووانە زیاد دەکرێت بۆ ئەپەکە.',
        'ar': 'سيتم إضافة قسم قراءة السور قريباً إلى التطبيق.',
        'en': 'Surah reader page will be added to the app soon.',
      });
}

// ─────────────────────────────────────────────────────────────────────────────
//  BuildContext extension — context.l10n shorthand
// ─────────────────────────────────────────────────────────────────────────────
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
