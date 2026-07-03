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
  String get quranMedinan => _translate(ku: 'مەدینە', ar: 'مدنية', en: 'Medinan');
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
  String get tasbihAddNewDhikr => _translate(ku: 'زیادکردنی زیکری نوێ', ar: 'إضافة ذكر جديد', en: 'Add New Dhikr');
  String get tasbihDhikrName => _translate(ku: 'ناوی زیکر', ar: 'اسم الذكر', en: 'Dhikr Name');
  String get tasbihEnterDhikrName => _translate(ku: 'تکایە ناوی زیکر بنووسە', ar: 'يرجى كتابة اسم الذكر', en: 'Please enter dhikr name');
  String get tasbihGoalLabel => _translate(ku: 'ئامانج (ژمارەی دووبارەکردنەوە)', ar: 'الهدف (عدد التكرارات)', en: 'Goal (Number of repetitions)');
  String get tasbihEnterValidGoal => _translate(ku: 'تکایە ژمارەیەکی دروست بنووسە', ar: 'يرجى كتابة رقم صحيح', en: 'Please enter a valid number');
  String tasbihDhikrAdded(String name) => _translate(ku: 'زیکری "$name" بە سەرکەوتوویی زیادکرا', ar: 'تم إضافة الذكر "$name" بنجاح', en: 'Dhikr "$name" added successfully');
  String get tasbihAddButton => _translate(ku: 'زیادکردن', ar: 'إضافة', en: 'Add');
  String get tasbihDeleteDhikr => _translate(ku: 'سڕینەوەی زیکر', ar: 'حذف الذكر', en: 'Delete Dhikr');
  String tasbihDeleteConfirm(String name) => _translate(ku: 'دڵنیایت لە سڕینەوەی زیکری "$name"؟', ar: 'هل أنت متأكد من حذف الذكر "$name"؟', en: 'Are you sure you want to delete the dhikr "$name"?');
  String get tasbihDeleteYes => _translate(ku: 'بەڵێ، بسڕەوە', ar: 'نعم، احذف', en: 'Yes, delete');
  String tasbihDhikrDeleted(String name) => _translate(ku: 'زیکری "$name" سڕایەوە', ar: 'تم حذف الذكر "$name"', en: 'Dhikr "$name" deleted');
  String get tasbihNoDhikrAvailable => _translate(ku: 'هیچ زیکرێک بەردەست نییە', ar: 'لا توجد أذكار متاحة', en: 'No dhikr available');
  String get tasbihAddDhikrButton => _translate(ku: 'زیادکردنی زیکر', ar: 'إضافة ذكر', en: 'Add Dhikr');
  String get tasbihSettingsTooltip => _translate(ku: 'ڕێکخستنەکان', ar: 'الإعدادات', en: 'Settings');
  String get tasbihStreakUpdated => _translate(ku: 'بەردەوامییەکەت نوێکرایەوە!', ar: 'تم تحديث سلسلتك!', en: 'Your streak has been updated!');
  String tasbihStreakCongrats(int streak) => _translate(ku: 'پیرۆزە! گەیشتیتە $streak ڕۆژ بەردەوامی', ar: 'تهانينا! لقد وصلت إلى سلسلة $streak أيام', en: 'Congratulations! You reached a streak of $streak days');
  String get tasbihGoalAchieved => _translate(ku: 'ئامانجی ڕۆژانە بەدەستھات!', ar: 'تم تحقيق الهدف اليومي!', en: 'Daily goal achieved!');
  String get tasbihSettingsTitle => _translate(ku: 'ڕێکخستنی ژمارەکەر', ar: 'إعدادات المسبحة', en: 'Counter Settings');
  String get tasbihSound => _translate(ku: 'دەنگ', ar: 'الصوت', en: 'Sound');
  String get tasbihSoundDesc => _translate(ku: 'چالاککردنی دەنگ لە کاتی زیکرکردندا', ar: 'تفعيل الصوت أثناء الذكر', en: 'Enable sound while reciting dhikr');
  String get tasbihHaptics => _translate(ku: 'لەرینەوە (Haptics)', ar: 'الاهتزاز (Haptics)', en: 'Vibration (Haptics)');
  String get tasbihHapticsDesc => _translate(ku: 'چالاککردنی لەرینەوە لەگەڵ هەر کلیکێک', ar: 'تفعيل الاهتزاز مع كل نقرة', en: 'Enable vibration with each click');
  String get tasbihClose => _translate(ku: 'داخستن', ar: 'إغلاق', en: 'Close');
  String get tasbihOrCustomName => _translate(ku: 'یاخود ناوێکی تایبەت بنووسە:', ar: 'أو اكتب اسماً مخصصاً:', en: 'Or enter a custom name:');
  String get tasbihExampleSalawat => _translate(ku: 'نموونە: صلوات', ar: 'مثال: الصلاة على النبي', en: 'e.g. Salawat');
  String get tasbihExampleGoal => _translate(ku: 'نموونە: 250', ar: 'مثال: 250', en: 'Example: 250');
  String get tasbihSelectOrEnterName => _translate(ku: 'تکایە زیکرێک هەڵبژێرە یان ناوێک بنووسە', ar: 'يرجى اختيار ذكر أو كتابة اسم', en: 'Please select a dhikr or enter a name');

  // ── Statistics ───────────────────────────────────────────────────
  String get statsAndInsightsTitle => _translate(ku: 'ئامار و زانیارییەکان', ar: 'الإحصائيات والتحليلات', en: 'Statistics & Insights');
  String get statsQuickActionInsights => _translate(ku: 'ئامارەکان', ar: 'الإحصائيات', en: 'Insights');

  // ── Category / Feature Titles ─────────────────────────────────────
  String get hadithTitle => _translate(ku: 'فەرموودە', ar: 'الأحاديث', en: 'Hadiths');
  String get tajweedTitle => _translate(ku: 'فێربوونی تەجوید', ar: 'تعلم التجويد', en: 'Learn Tajweed');
  String get readingStatsTitle => _translate(ku: 'ئاماری خوێندن', ar: 'إحصائيات القراءة', en: 'Reading Stats');
  String get notesTitle => _translate(ku: 'تێبینی و ڕامان', ar: 'الملاحظات والأفكار', en: 'Notes & Thoughts');
  String get namesOfAllahTitle => _translate(ku: 'ناوەکانی خودا', ar: 'أسماء الله الحسنى', en: 'Names of Allah');
  String get namesOfAllahSub => _translate(ku: 'خوێندنەوە، ماناکان و فەزڵەکانی ٩٩ ناوی پیرۆزی خوای گەورە', ar: 'القراءة، المعاني والفضائل لـ ٩٩ اسماً لله عز وجل', en: 'Reading, meanings and virtues of the 99 names of Allah');
  String get namesOfAllahNoNamesFound => _translate(ku: 'هیچ ناوێک نەدۆزرایەوە', ar: 'لم يتم العثور على أسماء', en: 'No names found');
  String get namesOfAllahError => _translate(ku: 'هەڵەیەک ڕوویدا:', ar: 'حدث خطأ:', en: 'An error occurred:');
  String get namesOfAllahVerseAr => _translate(ku: 'ئایەتی پەیوەندیدار (عەرەبی)', ar: 'الآية المرتبطة (العربية)', en: 'Related Verse (Arabic)');
  String get namesOfAllahVerseKu => _translate(ku: 'مانای ئایەتەکە بە کوردی', ar: 'معنى الآية بالكردية', en: 'Meaning of the verse in Kurdish');
  String get namesOfAllahMeaningKu => _translate(ku: 'مانای ناوەکە بە کوردی', ar: 'معنى الاسم بالكردية', en: 'Meaning of the name in Kurdish');
  String get namesOfAllahMeaningEn => _translate(ku: 'Meaning in English', ar: 'المعنى بالإنجليزية', en: 'Meaning in English');
  String get namesOfAllahVirtueKu => _translate(ku: 'فەزڵ و سوودی خوێندنەوەی', ar: 'فضل وفائدة القراءة', en: 'Virtue and benefit of reciting');
  String get seerahTitle => _translate(ku: 'ژیاننامەی پێغەمبەر ﷺ', ar: 'السيرة النبوية ﷺ', en: 'Prophet\'s Biography ﷺ');
  String get seerahSub => _translate(ku: 'مێژووی ژیان و دەستپێکی بانگەوازی سەروەرمان محەممەد ﷺ لە ٩ قۆناغدا', ar: 'تاريخ حياة ونبوة نبينا محمد ﷺ في ٩ مراحل', en: 'The life and prophethood of our Prophet Muhammad ﷺ in 9 stages');
  String get seerahNoChaptersFound => _translate(ku: 'هیچ بەشێک نەدۆزرایەوە', ar: 'لم يتم العثور على فصول', en: 'No chapters found');
  String get sahabaTitle => _translate(ku: 'ژیاننامەی هاوەڵان', ar: 'السيرة الصحابية', en: 'Companions\' Biographies');
  String get sahabaSub => _translate(ku: 'ژیاننامە، نازناو و فەزڵەکانی مەزنترین هاوەڵانی پێغەمبەر ﷺ', ar: 'السيرة، الألقاب والفضائل لأعظم أصحاب النبي ﷺ', en: 'Biography, epithet and virtues of the greatest companions of the Prophet ﷺ');
  String get sahabaNoSahabaFound => _translate(ku: 'هیچ هاوەڵێک نەدۆزرایەوە', ar: 'لم يتم العثور على أي صحابي', en: 'No companions found');
  String get sahabaVirtuesTitle => _translate(ku: 'فەزڵ و گەورەیی:', ar: 'الفضل والمنزلة:', en: 'Virtues & Status:');

  // ── Home Dynamic Strings ──────────────────────────────────────────
  String get homeTodaysDhikr => _translate(ku: 'زیکری ئەمڕۆ', ar: 'ذكر اليوم', en: 'Today\'s Dhikr');
  String get homeCancel => _translate(ku: 'پاشگەزبوونەوە', ar: 'إلغاء', en: 'Cancel');
  String get homeApply => _translate(ku: 'سەپاندن', ar: 'تطبيق', en: 'Apply');
  String get homeToday => _translate(ku: 'ئەمڕۆ', ar: 'اليوم', en: 'Today');
  String get homeNoSessions => _translate(ku: 'هیچ خولێکی زیکر نییە', ar: 'لا توجد جلسات ذكر', en: 'No Dhikr sessions');
  String get homeTotalDhikrs => _translate(ku: 'کۆی تەواوی زیکرەکان', ar: 'إجمالي الأذكار', en: 'Total Dhikrs');
  String get homeRareAchievements => _translate(ku: 'دەستکەوتە دەگمەنەکان', ar: 'الإنجازات النادرة', en: 'Rare Achievements');
  String get homePrayerUpcoming => _translate(ku: 'کاتی نوێژی داهاتوو', ar: 'وقت الصلاة القادم', en: 'Upcoming Prayer');
  String get homeReciter => _translate(ku: 'خوێنەری قورئان', ar: 'قارئ القرآن', en: 'Quran Reciter');
  String get homeOfflineMode => _translate(ku: 'مۆدی ئۆفلاین', ar: 'الوضع دون اتصال', en: 'Offline Mode');
  String get homeStartDhikr => _translate(ku: 'دەستپێکردنی زیکر', ar: 'بدء الذكر', en: 'Start Dhikr');
  String get homeTimeRemaining => _translate(ku: 'کاتی ماوە', ar: 'الوقت المتبقي', en: 'Time Remaining');
  String get homeExampleGoal => _translate(ku: 'نموونە: 1500', ar: 'مثال: 1500', en: 'Example: 1500');
  String get homeMostActiveAfterMaghrib => _translate(ku: 'زۆرترین چالاکیت لە دوای نوێژی مەغریبە.', ar: 'معظم نشاطك بعد صلاة المغرب.', en: 'You\'re most active after Maghrib prayer.');
  String homeDailyGoalChanged(String val) => _translate(ku: 'ئامانجی ڕۆژانە گۆڕدرا بۆ $val زیکر', ar: 'تم تغيير الهدف اليومي إلى $val ذكر', en: 'Daily goal changed to $val dhikr');
  String homeTrendMore(String pct) => _translate(ku: '+$pct% زیاتر لە دوێنێ', ar: '+$pct% أكثر من أمس', en: '+$pct% more than yesterday');
  String homeTrendLess(String pct) => _translate(ku: '-$pct% کەمتر لە دوێنێ', ar: '-$pct% أقل من أمس', en: '-$pct% less than yesterday');
  String get homeTrendSame => _translate(ku: 'ئەمڕۆ جێگیرە بە بەراورد لەگەڵ دوێنێ', ar: 'ثابت اليوم مقارنةً بالأمس', en: 'Steady today compared to yesterday');
  String homeStreakCurrentDays(int days) => _translate(ku: '$days ڕۆژ', ar: '$days يوم', en: '$days days');
  String homeStreakBestDays(int days) => _translate(ku: '$days ڕۆژ', ar: '$days يوم', en: '$days days');
  String homePrayerBang(String time) => _translate(ku: 'بانگ: $time', ar: 'الأذان: $time', en: 'Adhan: $time');
  String get homeStreakLabel => _translate(ku: 'بەردەوامی', ar: 'السلسلة', en: 'Streak');
  String get homeGoalCompletion => _translate(ku: 'تەواوکردنی ئامانج', ar: 'إكمال الهدف', en: 'Goal Completion');
  String get homeBadges => _translate(ku: 'دەستکەوت', ar: 'الأوسمة', en: 'Badges');
  String get homeThemes => _translate(ku: 'ڕووکار', ar: 'السمات', en: 'Themes');
  String get homeStartDhikrSession => _translate(ku: 'دەستپێکردنی خولی زیکر', ar: 'بدء جلسة ذكر', en: 'Start Dhikr Session');
  String get homeSelectDhikrToBegin => _translate(ku: 'زیکرێک هەڵبژێرە بۆ دەستپێکردن:', ar: 'اختر ذكراً للبدء:', en: 'Select a dhikr to begin:');
  String get homeOrTypeCustomDhikr => _translate(ku: 'یان زیکرێکی تایبەت بنووسە:', ar: 'أو اكتب ذكراً مخصصاً:', en: 'Or type custom dhikr:');
  String get homeStartButton => _translate(ku: 'دەستپێکردن', ar: 'بدء', en: 'Start');

  // ── Search ───────────────────────────────────────────────────────
  String get searchHint => _translate(ku: 'گەڕان بەدوای ئایەت، سورەتدا...', ar: 'البحث عن آية، سورة...', en: 'Search for Ayah, Surah...');
  String get searchRecent => _translate(ku: 'گەڕانە نوێیەکان', ar: 'عمليات البحث الأخيرة', en: 'Recent Searches');
  String get searchNoResults => _translate(ku: 'هیچ ئەنجامێک نەدۆزرایەوە', ar: 'لم يتم العثور على نتائج', en: 'No results found');
  String get searchEmpty => _translate(ku: 'دەستپێکە بگەڕێیت', ar: 'ابدأ البحث', en: 'Start searching');

  // ── Bookmarks ────────────────────────────────────────────────────
  String get bookmarksEmpty => _translate(ku: 'هیچ پارێزراوێک نییە', ar: 'لا توجد محفوظات', en: 'No bookmarks');
  String get bookmarksEmptySub => _translate(ku: 'ئایەتێک پارێز بکە تا ئێرە دەرکەوێت', ar: 'احفظ آية لتظهر هنا', en: 'Bookmark a verse to see it here');
  String bookmarkCount(int count) => _translate(ku: '$count نیشانەکراو', ar: '$count محفوظ', en: '$count bookmarks');
  String get bookmarkSurahNotFoundError => _translate(ku: 'ناتوانرێت سورەتەکە بدۆزرێتەوە لە لیستەکەدا', ar: 'تعذر العثور على السورة في القائمة', en: 'Cannot find surah in the list');

  // ── Settings ─────────────────────────────────────────────────────
  String get settingsTheme => _translate(ku: 'ڕووکار', ar: 'المظهر', en: 'Theme');
  String get settingsLight => _translate(ku: 'ڕووناک', ar: 'فاتح', en: 'Light');
  String get settingsDark => _translate(ku: 'تاریک', ar: 'داكن', en: 'Dark');
  String get settingsSystem => _translate(ku: 'سیستەم', ar: 'النظام', en: 'System');
  String get settingsLanguage => _translate(ku: 'زمان', ar: 'اللغة', en: 'Language');
  String get settingsFontSize => _translate(ku: 'قەبارەی فۆنت', ar: 'حجم الخط', en: 'Font Size');
  String get settingsAbout => _translate(ku: 'دەربارە', ar: 'حول التطبيق', en: 'About');
  String get settingsVersion => _translate(ku: 'وەشان ١.٠.١', ar: 'الإصدار ١.٠.١', en: 'Version 1.0.1');
  String get settingsAppearance => _translate(ku: 'دیمەن', ar: 'المظهر الخارجي', en: 'Appearance');
  String get settingsGeneral => _translate(ku: 'گشتی', ar: 'عام', en: 'General');

  // ── About Page ───────────────────────────────────────────────────
  String get aboutTitle => _translate(ku: 'دەربارەی ئێمە', ar: 'حولنا', en: 'About Us');
  String aboutVersion(String version) => _translate(ku: 'وەشانی $version', ar: 'الإصدار $version', en: 'Version $version');
  String get aboutAppTitle => _translate(ku: 'دەربارەی ئەپ', ar: 'حول التطبيق', en: 'About App');
  String get aboutDescription => _translate(ku: 'قورئانەکەم ئەپێکی قورئانیە کە بە ئامانجی ئاسانکردنی خوێندنەوەی قورئانی پیرۆز دروستکراوە. لێرەدا دەتوانیت قورئان بخوێنیتەوە، گوێت لێ بگریت، تەجویدت فێر ببی، و خوێندنەوەت بشووێنێت.', ar: 'قرآني هو تطبيق قرآني تم إنشاؤه لتسهيل قراءة القرآن الكريم. هنا يمكنك قراءة القرآن، والاستماع إليه، وتعلم التجويد، ومتابعة قراءتك.', en: 'My Quran is a Quranic app created to facilitate reading the Holy Quran. Here you can read the Quran, listen to it, learn Tajweed, and track your reading.');
  String get aboutFeedbackNote => _translate(ku: 'بۆ هەر ڕەخنە، پێشنیار، یان بیڕۆکەیەک دەتوانیت بە هەر ئەم ڕێگایانەوە پەیوەندیمان پێوەبکەیت. پێشنیارەکانت گرینگترین بەشی باشتربوونی ئەپەکەن.', ar: 'لأي شكاوى أو اقتراحات أو أفكار، يمكنك التواصل معنا عبر هذه القنوات. اقتراحاتك هي الجزء الأهم لتطوير التطبيق.', en: 'For any feedback, suggestions, or ideas, you can contact us through these channels. Your feedback is the most important part of improving the app.');
  String get aboutContactUs => _translate(ku: 'پەیوەندیمان پێوەبکە', ar: 'تواصل معنا', en: 'Contact Us');
  String get aboutEmail => _translate(ku: 'ئیمەیل', ar: 'البريد الإلكتروني', en: 'Email');
  String get aboutEmailCopied => _translate(ku: 'ئیمەیل کۆپی کرا', ar: 'تم نسخ البريد الإلكتروني', en: 'Email copied');
  String get aboutTelegram => _translate(ku: 'تێلیگرام', ar: 'تيليجرام', en: 'Telegram');
  String get aboutTelegramCopied => _translate(ku: 'تێلیگرام کۆپی کرا', ar: 'تم نسخ معرف تيليجرام', en: 'Telegram copied');
  String get aboutWhatsapp => _translate(ku: 'وەتسئاپ', ar: 'واتسئاپ', en: 'Whatsapp');
  String get aboutWhatsappCopied => _translate(ku: 'وەتسئاپ کۆپی کرا', ar: 'تم نسخ رابط واتسئاپ', en: 'Whatsapp link copied');
  String get aboutFeatures => _translate(ku: 'تایبەتمەندییەکان', ar: 'الميزات', en: 'Features');
  String get aboutFeatQuran => _translate(ku: 'خوێندنەوەی قورئان بە فۆنتی ئوسمانی', ar: 'قراءة القرآن بالرسم العثماني', en: 'Read Quran in Uthmanic font');
  String get aboutFeatAudio => _translate(ku: 'گوێگرتن لە قورئانخوێن بە دەنگی بەرز', ar: 'الاستماع للقراء بصوت واضح', en: 'Listen to clear audio of reciters');
  String get aboutFeatTajweed => _translate(ku: 'فێربوونی تەجوید لەگەڵ ڕووناکردنەوە', ar: 'تعلم التجويد مع الشروحات', en: 'Learn Tajweed with explanations');
  String get aboutFeatBookmark => _translate(ku: 'بووکمارک و یادداشت بۆ هەر ئایەتێک', ar: 'علامات مرجعية وملاحظات لكل آية', en: 'Bookmarks and notes for each verse');
  String get aboutFeatStats => _translate(ku: 'ئامارگری خوێندنەوە و پێشکەوتن', ar: 'إحصائيات القراءة والتقدم', en: 'Reading statistics and progress');
  String get aboutFeatNotif => _translate(ku: 'ئاگادارکردنەوەی ڕۆژانە', ar: 'الإشعارات اليومية', en: 'Daily notification');
  String get aboutFeatPrayer => _translate(ku: 'کاتەکانی نوێژ بە زانستی ئیسلامی', ar: 'مواقيت الصلاة وفق الشريعة الإسلامية', en: 'Prayer times with Islamic sciences');
  String get aboutVerseRef => _translate(ku: '﴿ سورەتی المزمل: ٤ ﴾', ar: '﴿ سورة المزمل: ٤ ﴾', en: '﴿ Surah Al-Muzzammil: 4 ﴾');
  String get aboutCopy => _translate(ku: 'کۆپی بکە', ar: 'نسخ', en: 'Copy');

  // ── Settings Page Additions ──────────────────────────────────────
  String get settingsHelpText => _translate(ku: 'کاتی ئاگادارکردنەوە هەڵبژێرە', ar: 'اختر وقت الإشعار', en: 'Select notification time');
  String get settingsExportData => _translate(ku: 'هەناردەکردنی داتا', ar: 'تصدير البيانات', en: 'Export Data');
  String get settingsExportNote => _translate(ku: 'تکایە تێپەڕەوشەیەک بنووسە ئەگەر دەتەوێت فایلەکە تەشفیر (سڕ) بکەیت بۆ پاراستنی زیاتر. دەتوانیت بە بەتاڵی جێی بهێڵیت.', ar: 'يرجى إدخال كلمة مرور إذا كنت ترغب في تشفير الملف لحماية إضافية. يمكنك تركه فارغاً.', en: 'Please enter a password if you want to encrypt the file for extra protection. You can leave it blank.');
  String get settingsPasswordOptional => _translate(ku: 'تێپەڕەوشە (ئارەزوومەندانە)', ar: 'كلمة المرور (اختياري)', en: 'Password (Optional)');
  String get settingsImportData => _translate(ku: 'هێنانە ناوەوەی داتا', ar: 'استيراد البيانات', en: 'Import Data');
  String get settingsImportNote => _translate(ku: 'ئەگەر فایلەکە بە تێپەڕەوشە پارێزراوە، تکایە تێپەڕەوشەکەی بنووسە. ئەگەر نا، بە بەتاڵی جێی بهێڵە.', ar: 'إذا كان الملف محمياً بكلمة مرور، فيرجى إدخالها. وإلا، اتركه فارغاً.', en: 'If the file is password-protected, please enter it. Otherwise, leave it blank.');
  String get settingsPassword => _translate(ku: 'تێپەڕەوشە', ar: 'كلمة المرور', en: 'Password');
  String get settingsImportSuccess => _translate(ku: 'داتاکان بە سەرکەوتوویی هێنرانە ناوەوە', ar: 'تم استيراد البيانات بنجاح', en: 'Data imported successfully');
  String get settingsDownloadBackground => _translate(ku: 'دەستکرا بە داگرتنی ناوەڕۆکەکان لە پاشبنەما...', ar: 'بدأ تحميل المحتوى في الخلفية...', en: 'Started downloading contents in the background...');
  String get settingsFontSettings => _translate(ku: 'ڕێکخستنی جۆر', ar: 'إعدادات الخط', en: 'Font Settings');
  String get settingsCustomColor => _translate(ku: 'ڕەنگی تایبەت', ar: 'لون مخصص', en: 'Custom Color');
  String get settingsFontFamily => _translate(ku: 'جۆری فۆنت', ar: 'نوع الخط', en: 'Font Family');
  String get settingsFontUi => _translate(ku: 'فۆنت بۆ ڕووکار (UI)', ar: 'خط الواجهة (UI)', en: 'UI Font');
  String get settingsFontUiSub => _translate(ku: 'فۆنتی ناوەکانی مەنیو و تێکستەکان', ar: 'خط أسماء القوائم والنصوص', en: 'Font for menus and UI texts');
  String get settingsFontQuran => _translate(ku: 'فۆنتی قورئانی', ar: 'خط المصحف', en: 'Quran Font');
  String get settingsFontQuranSub => _translate(ku: 'فۆنتی تێکستی عەرەبیی قورئان', ar: 'خط النص العربي للقرآن الكريم', en: 'Font for Arabic Quran text');
  String get settingsFontTarget => _translate(ku: 'جێبەجێکردنی فۆنت', ar: 'تطبيق الخط', en: 'Apply Font to');
  String get settingsFontTargetSub => _translate(ku: 'ئەم فۆنتە بۆ کوێ جێبەجێ بکرێت', ar: 'أين يتم تطبيق هذا الخط', en: 'Where to apply this font');
  String get settingsFontTargetReader => _translate(ku: 'خوێنەر', ar: 'القارئ', en: 'Reader');
  String get settingsFontTargetBoth => _translate(ku: 'هەردوو', ar: 'الكل', en: 'Both');
  String get settingsFontUiSample => _translate(ku: 'قورئانی پیرۆز - نموونەی فۆنتی ڕووکار', ar: 'القرآن الكريم - عينة خط الواجهة', en: 'Holy Quran - UI Font Sample');
  String get settingsTranslations => _translate(ku: 'وەرگێڕانەکان', ar: 'التراجم', en: 'Translations');
  String get settingsShowKurdish => _translate(ku: 'پیشاندانی وەرگێڕانی کوردی', ar: 'إظهار الترجمة الكردية', en: 'Show Kurdish Translation');
  String get settingsShowEnglish => _translate(ku: 'پیشاندانی وەرگێڕانی ئینگلیزی', ar: 'إظهار الترجمة الإنكليزية', en: 'Show English Translation');
  String get settingsSmartReminder => _translate(ku: 'ئاگادارکردنەوەی زیرەک', ar: 'التذكير الذكي', en: 'Smart Reminder');
  String get settingsSmartReminderSub => _translate(ku: 'کات و دووبارەبوونەوەی ئاگادارکردنەوەکان ڕێکبخە', ar: 'تعديل وقت وتكرار التذكيرات', en: 'Configure time and frequency of reminders');
  String get settingsCalculationMethod => _translate(ku: 'ڕێگای کاتی نوێژ', ar: 'طريقة الحساب', en: 'Calculation Method');
  String get settingsCalculationMethodSub => _translate(ku: 'هەڵبژاردنی ڕێگای هەژمارکردنی کاتەکانی بانگ', ar: 'تحديد طريقة حساب مواقيت الصلاة', en: 'Choose calculation method for prayer times');
  String get settingsDataManagement => _translate(ku: 'بەڕێوەبردنی داتاکان', ar: 'إدارة البيانات', en: 'Data Management');
  String get settingsExportDataSub => _translate(ku: 'هەناردەکردنی زانیارییەکانت بۆ ناو فایلێک بۆ پاشەکەوت', ar: 'تصدير بياناتك إلى ملف للنسخ الاحتياطي', en: 'Export your data to a backup file');
  String get settingsImportDataSub => _translate(ku: 'گەڕاندنەوەی زانیارییەکان لە فایلی کۆپی پاشەکەوتەوە', ar: 'استعادة بياناتك من ملف النسخ الاحتياطي', en: 'Restore your data from a backup file');
  String get settingsDownloadAll => _translate(ku: 'داگرتنی هەموو ناوەڕۆکەکان', ar: 'تحميل جميع المحتويات', en: 'Download All Contents');
  String get settingsDownloadAllSub => _translate(ku: 'داگرتنی داتای قورئان و تەجوید و ئەزکار بۆ بەکارهێنانی ئۆفلاین', ar: 'تحميل بيانات القرآن والتجويد والأذكار للاستخدام دون اتصال', en: 'Download Quran, Tajweed, and Adhkar data for offline use');
  String get settingsDownloadManager => _translate(ku: 'بەڕێوەبەری داگرتنەکان', ar: 'إدارة التنزيلات', en: 'Download Manager');
  String get settingsDownloadManagerSub => _translate(ku: 'بەڕێوەبردن و پاککردنەوەی سەرچاوە و دەنگە داگیراوەکان', ar: 'إدارة وتنظيف الملفات الصوتية والمحتويات المحملة', en: 'Manage and clean downloaded audio and resources');

  // ── Auth Page Additions ──────────────────────────────────────────
  String get authLinkSentTitle => _translate(ku: 'پەیوەندی ناردرا', ar: 'تم إرسال الرابط', en: 'Link Sent');
  String get authLinkSent => _translate(ku: 'بەستەری نوێکردنەوەی شیکارە ناردرا بۆ ئیمەیڵەکەت. تکایە سندوقی نامەکانت بپشکنە.', ar: 'تم إرسال رابط استعادة الحساب إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد.', en: 'Reset link has been sent to your email. Please check your inbox.');
  String get authResetPassword => _translate(ku: 'نوێکردنەوەی شیکارە', ar: 'استعادة الحساب', en: 'Reset Password');
  String get authForgotPasswordQ => _translate(ku: 'شیکارەکەت بیرچووە؟', ar: 'هل نسيت كلمة المرور؟', en: 'Forgot Password?');
  String get authForgotPasswordSub => _translate(ku: 'ئیمەیڵەکەت بنووسە و ئێمە بەستەری گۆڕینی شیکارەت بۆ دەنێرین', ar: 'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لتغيير كلمة المرور', en: 'Enter your email and we will send you a link to reset your password');
  String get authEmailWithLabel => _translate(ku: 'ئیمەیڵ (Email)', ar: 'البريد الإلكتروني', en: 'Email');
  String get authEmailRequired => _translate(ku: 'تکایە ئیمەیڵەکەت بنووسە', ar: 'يرجى إدخال البريد الإلكتروني', en: 'Please enter your email');
  String get authEmailInvalid => _translate(ku: 'تکایە ئیمەیڵێکی دروست بنووسە', ar: 'يرجى إدخال بريد إلكتروني صحيح', en: 'Please enter a valid email');
  String get authSendResetLink => _translate(ku: 'ناردنی بەستەری گۆڕین', ar: 'إرسال رابط الاستعادة', en: 'Send Reset Link');
  String get authLoginError => _translate(ku: 'هەڵەیەک لە چوونەژوورەوەدا ڕوویدا', ar: 'حدث خطأ أثناء تسجيل الدخول', en: 'An error occurred during login');
  String get authLogin => _translate(ku: 'چوونەژوورەوە', ar: 'تسجيل الدخول', en: 'Login');
  String get authWelcomeBack => _translate(ku: 'بەخێربێیەوە', ar: 'مرحباً بعودتك', en: 'Welcome Back');
  String get authLoginSub => _translate(ku: 'زانیارییەکانت بنووسە بۆ چوونەژوورەوە بۆ ئەکاونتەکەت', ar: 'أدخل بياناتك لتسجيل الدخول إلى حسابك', en: 'Enter your details to login to your account');
  String get authUsernameOrEmail => _translate(ku: 'ناو یان ئیمەیڵ', ar: 'الاسم أو البريد الإلكتروني', en: 'Username or Email');
  String get authUsernameOrEmailRequired => _translate(ku: 'تکایە ناو یان ئیمەیڵەکەت بنووسە', ar: 'يرجى إدخال الاسم أو البريد الإلكتروني', en: 'Please enter username or email');
  String get authPassword => _translate(ku: 'وشەیی نهێنی', ar: 'كلمة المرور', en: 'Password');
  String get authPasswordRequired => _translate(ku: 'تکایە وشەیی نهێنيت بنووسە', ar: 'يرجى إدخال كلمة المرور', en: 'Please enter password');
  String get authForgotPassword => _translate(ku: 'وشەی نهێنی لە بیرچووە؟', ar: 'هل نسيت كلمة المرور؟', en: 'Forgot Password?');
  String get authCreateAccount => _translate(ku: 'ئەکاونت دروستبکە', ar: 'إنشاء حساب', en: 'Create Account');
  String get authNoAccount => _translate(ku: 'ئەگەر ئەکاونتت نییە؟', ar: 'ليس لديك حساب؟', en: 'Don\'t have an account?');
  String get authProfileUpdated => _translate(ku: 'پرۆفایلەکەت بە سەرکەوتوویی نوێکرایەوە', ar: 'تم تحديث ملفك الشخصي بنجاح', en: 'Your profile has been updated successfully');
  String get authProfileUpdateFailed => _translate(ku: 'نوێکردنەوەی پرۆفایل سەرکەوتوو نەبوو', ar: 'فشل تحديث الملف الشخصي', en: 'Profile update failed');
  String get authPleaseLoginFirst => _translate(ku: 'تکایە سەرەتا بچۆ ژوورەوە', ar: 'يرجى تسجيل الدخول أولاً', en: 'Please login first');
  String get authMyProfile => _translate(ku: 'پرۆفایلی من', ar: 'ملفي الشخصي', en: 'My Profile');
  String get authProfileCompletion => _translate(ku: 'ڕێژەی تەواوبوونی پرۆفایل', ar: 'نسبة اكتمال الملف الشخصي', en: 'Profile Completion Rate');
  String get authMyStats => _translate(ku: 'ئامارەکانی من', ar: 'إحصائياتي', en: 'My Statistics');
  String get authDhikrs => _translate(ku: 'زیکرەکان', ar: 'الأذكار', en: 'Adhkars');
  String get authGoalsRate => _translate(ku: 'ڕێژەی ئامانجەکان', ar: 'نسبة الأهداف', en: 'Goals Rate');
  String get authSessions => _translate(ku: 'خولەکان', ar: 'الجلسات', en: 'Sessions');
  String get authAchievements => _translate(ku: 'دەستکەوتەکان', ar: 'الإنجازات', en: 'Achievements');
  String get authPersonalDetails => _translate(ku: 'زانیارییە کەسییەکان', ar: 'البيانات الشخصية', en: 'Personal Details');
  String get authName => _translate(ku: 'ناو', ar: 'الاسم', en: 'Name');
  String get authNameRequired => _translate(ku: 'تکایە ناو بنووسە', ar: 'يرجى إدخال الاسم', en: 'Please enter name');
  String get authUsername => _translate(ku: 'ناوی بەکارهێنەر', ar: 'اسم المستخدم', en: 'Username');
  String get authUsernameRequired => _translate(ku: 'تکایە ناوی بەکارهێنەر بنووسە', ar: 'يرجى إدخال اسم المستخدم', en: 'Please enter username');
  String get authBio => _translate(ku: 'دەربارە (Bio)', ar: 'نبذة شخصية (Bio)', en: 'Bio');
  String get authNickname => _translate(ku: 'نازناو (Nickname)', ar: 'اللقب (Nickname)', en: 'Nickname');
  String get authPublicTitle => _translate(ku: 'ناونیشانی گشتی', ar: 'العنوان العام', en: 'Public Title');
  String get authProfileQuote => _translate(ku: 'وتەی پرۆفایل', ar: 'اقتباس الملف الشخصي', en: 'Profile Quote');
  String get authDeleteAccount => _translate(ku: 'سڕینەوەی ئەکاونت', ar: 'حذف الحساب', en: 'Delete Account');
  String get authDeleteAccountConfirm => _translate(ku: 'ئایا دڵنیایت لە سڕینەوەی ئەکاونتەکەت؟ ئەکاونتەکەت دەچێتە ماوەی ٣٠ ڕۆژ چاکبوونەوە. دوای ٣٠ ڕۆژ سەرجەم داتا و کۆپییە یەدەگەکانت بە یەکجاری دەسڕێنەوە.', ar: 'هل أنت متأكد من حذف حسابك؟ سيدخل حسابك في فترة استرداد مدتها 30 يوماً. بعد 30 يوماً، سيتم حذف جميع بياناتك ونسخك الاحتياطية نهائياً.', en: 'Are you sure you want to delete your account? Your account will enter a 30-day recovery period. After 30 days, all your data and backups will be permanently deleted.');
  String get authAccountSettings => _translate(ku: 'ڕێکخستنەکانی ئەکاونت', ar: 'إعدادات الحساب', en: 'Account Settings');
  String get authGeneralSettings => _translate(ku: 'ڕێکخستنە گشتییەکان', ar: 'الإعدادات العامة', en: 'General Settings');
  String get authChangePassword => _translate(ku: 'گۆڕینی وشەی نهێنی', ar: 'تغيير كلمة المرور', en: 'Change Password');
  String get authCurrentPassword => _translate(ku: 'وشەی نهێنی ئێستا', ar: 'كلمة المرور الحالية', en: 'Current Password');
  String get authCurrentPasswordRequired => _translate(ku: 'تکایە وشەی نهێنی ئێستات بنووسە', ar: 'يرجى إدخال كلمة المرور الحالية', en: 'Please enter current password');
  String get authNewPassword => _translate(ku: 'وشەی نهێنی نوێ', ar: 'كلمة المرور الجديدة', en: 'New Password');
  String get authNewPasswordRequired => _translate(ku: 'تکایە وشەی نهێنی نوێیەکە دیاری بکە', ar: 'يرجى تحديد كلمة المرور الجديدة', en: 'Please select new password');
  String get authPasswordMinLength => _translate(ku: 'وشەی نهێنی دەبێت لانی کەم ٨ پیت یان ژمارە بێت', ar: 'يجب أن تكون كلمة المرور 8 أحرف أو أرقام على الأقل', en: 'Password must be at least 8 characters or digits');
  String get authRepeatNewPassword => _translate(ku: 'دووبارەکردنەوەی وشەی نوێ', ar: 'تأكيد كلمة المرور الجديدة', en: 'Repeat New Password');
  String get authRepeatNewPasswordRequired => _translate(ku: 'تکایە وشەی نهێنی نوێیەکە دووبارە بکەرەوە', ar: 'يرجى تأكيد كلمة المرور الجديدة', en: 'Please repeat the new password');
  String get authPasswordsDontMatch => _translate(ku: 'وشەکان وەک یەک نین', ar: 'كلمات المرور غير متطابقة', en: 'Passwords do not match');
  String get authDangerZone => _translate(ku: 'ناوچەی مەترسی', ar: 'منطقة الخطر', en: 'Danger Zone');
  String get authRegistrationError => _translate(ku: 'هەڵەیەک لە دروستکردنی ئەکاونتدا ڕوویدا', ar: 'حدث خطأ أثناء إنشاء الحساب', en: 'An error occurred during account creation');
  String get authRegister => _translate(ku: 'خۆتۆمارکردن', ar: 'التسجيل', en: 'Register');
  String get authRegisterSub => _translate(ku: 'زانیارییەکانت بنووسە بۆ تۆمارکردنی ئەکاونتێکی نوێ', ar: 'أدخل بياناتك لتسجيل حساب جديد', en: 'Enter your details to register a new account');
  String get authFullName => _translate(ku: 'ناوی تەواوت', ar: 'الاسم الكامل', en: 'Full Name');
  String get authFullNameRequired => _translate(ku: 'تکایە ناوەکەت بنووسە', ar: 'يرجى إدخال اسمك', en: 'Please enter your name');
  String get authEmail => _translate(ku: 'ئیمەیڵ', ar: 'البريد الإلكتروني', en: 'Email');
  String get authPasswordLabel => _translate(ku: 'وشەی نهێنی بنووسە', ar: 'أدخل كلمة المرور', en: 'Enter Password');
  String get authRepeatPassword => _translate(ku: 'دووبارەکردنەوەی وشەی نهێنی', ar: 'تأكيد كلمة المرور', en: 'Repeat Password');
  String get authRepeatPasswordRequired => _translate(ku: 'تکایە وشەی نهێنی دووبارە بنووسەوە', ar: 'يرجى إعادة إدخال كلمة المرور للتأكيد', en: 'Please repeat the password');
  String get authExtraInfo => _translate(ku: 'زانیارییە زیاتر (ئارەزوومەندانە)', ar: 'معلومات إضافية (اختياري)', en: 'Extra Information (Optional)');
  String get authGender => _translate(ku: 'ڕەگەز (Gender)', ar: 'الجنس (Gender)', en: 'Gender');
  String get authMale => _translate(ku: 'نێر', ar: 'ذكر', en: 'Male');
  String get authFemale => _translate(ku: 'مێ', ar: 'أنثى', en: 'Female');
  String get authBirthYear => _translate(ku: 'ساڵی لەدایکبوون', ar: 'سنة الولادة', en: 'Birth Year');
  String get authCountry => _translate(ku: 'وڵات', ar: 'البلد', en: 'Country');
  String get authCityProvince => _translate(ku: 'شار/پارێزگا', ar: 'المدينة/المحافظة', en: 'City/Province');
  String get authAlreadyHaveAccount => _translate(ku: 'پێشتر ئەکاونتت دروستکردووە؟', ar: 'هل لديك حساب بالفعل؟', en: 'Already have an account?');
  String get authGoToLogin => _translate(ku: 'بچۆ ژوورەوە', ar: 'تسجيل الدخول', en: 'Go Login');
  String get authRegisterTitle => _translate(ku: 'دروستکردنی ئەکاونت', ar: 'إنشاء الحساب', en: 'Create Account');
  String get authWelcomeTitle => _translate(ku: 'بەخێربێیت بۆ قورئانەکەم', ar: 'مرحباً بك في قرآني', en: 'Welcome to My Quran');
  String get authWelcomeSub => _translate(ku: 'ئەپلیکەیشنی تایبەت بە خوێندنەوەی قورئان و ژماردنی تەسبیحەکانت بە شێوازێکی هاوچەرخ', ar: 'تطبيق مخصص لقراءة القرآن الكريم ومسبحة أذكارك بطريقة حديثة', en: 'An application dedicated to reading the Holy Quran and tracking your Tasbih in a modern way');
  String get authLoginButton => _translate(ku: 'چوونەژوورەوە (Login)', ar: 'تسجيل الدخول (Login)', en: 'Login');
  String get authRegisterButton => _translate(ku: 'خۆتۆمارکردن (Register)', ar: 'إنشاء حساب (Register)', en: 'Register');
  String get authGuestButton => _translate(ku: 'بەردەوامبوون وەک مێوان (Continue as Guest) ➔', ar: 'المتابعة كضيف (Continue as Guest) ➔', en: 'Continue as Guest ➔');
  String get authDeleteAccountFailed => _translate(ku: 'سڕینەوەی ئەکاونت سەرکەوتوو نەبوو', ar: 'فشل حذف الحساب', en: 'Account deletion failed');

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

  // ── General Actions ──────────────────────────────────────────────
  String get actionCancel => _translate(ku: 'پاشگەزبوونەوە', ar: 'إلغاء', en: 'Cancel');
  String get actionOk => _translate(ku: 'باشە', ar: 'حسناً', en: 'OK');
  String get actionConfirm => _translate(ku: 'پەسەندکردن', ar: 'تأكيد', en: 'Confirm');
  String get actionSend => _translate(ku: 'ناردن', ar: 'إرسال', en: 'Send');
  String get actionRetry => _translate(ku: 'دووبارە هەوڵ بدەرەوە', ar: 'المحاولة مرة أخرى', en: 'Try again');
  String get actionDelete => _translate(ku: 'سڕینەوە', ar: 'حذف', en: 'Delete');
  String get actionSave => _translate(ku: 'پاشەکەوت', ar: 'حفظ', en: 'Save');
  String get actionEdit => _translate(ku: 'دەستکاریکردن', ar: 'تعديل', en: 'Edit');
  String get actionApply => _translate(ku: 'سەپاندن', ar: 'تطبيق', en: 'Apply');
  String get actionClose => _translate(ku: 'داخستن', ar: 'إغلاق', en: 'Close');
  String get actionStart => _translate(ku: 'دەستپێکردن', ar: 'بدء', en: 'Start');
  String get actionYes => _translate(ku: 'بەڵێ', ar: 'نعم', en: 'Yes');
  String get actionNo => _translate(ku: 'نەخێر', ar: 'لا', en: 'No');
  String get actionDownload => _translate(ku: 'داگرتن', ar: 'تحميل', en: 'Download');
  String get actionCopy => _translate(ku: 'کۆپی', ar: 'نسخ', en: 'Copy');
  String get actionCopied => _translate(ku: 'لەبەرگیراوە', ar: 'تم النسخ', en: 'Copied');
  String get actionAdd => _translate(ku: 'زیادکردن', ar: 'إضافة', en: 'Add');

  // ── General Messages ─────────────────────────────────────────────
  String get msgTextCopied => _translate(ku: 'دەقەکە کۆپی کرا', ar: 'تم نسخ النص', en: 'Text copied');
  String get msgErrorGeneric => _translate(ku: 'کێشەیەک ڕوویدا', ar: 'حدث خطأ', en: 'An error occurred');
  String get msgNoDataFound => _translate(ku: 'هیچ زانیارییەک نەدۆزرایەوە', ar: 'لم يتم العثور على بيانات', en: 'No data found');
  String get msgSelectAtLeastOneDay => _translate(ku: 'تکایە لانی کەم یەک ڕۆژ دیاری بکە.', ar: 'يرجى تحديد يوم واحد على الأقل.', en: 'Please select at least one day.');
  String get msgConfirmDeleteNote => _translate(ku: 'دڵنیای لە سڕینەوەی ئەم تێبینییە؟', ar: 'هل أنت متأكد من حذف هذه الملاحظة؟', en: 'Are you sure you want to delete this note?');
  String get msgPasswordChanged => _translate(ku: 'وشەی نهێنی بە سەرکەوتوویی نوێکرایەوە', ar: 'تم تغيير كلمة المرور بنجاح', en: 'Password changed successfully');
  String get msgLinkSent => _translate(ku: 'پەیوەندی ناردرا', ar: 'تم إرسال الرابط', en: 'Link sent');
  String get msgAccountDeleteFailed => _translate(ku: 'سڕینەوەی ئەکاونت سەرکەوتوو نەبوو', ar: 'فشل حذف الحساب', en: 'Account deletion failed');
  String get msgDeleteNoteTitle => _translate(ku: 'سڕینەوەی تێبینی', ar: 'حذف الملاحظة', en: 'Delete Note');
  String get msgOk => _translate(ku: 'باشە', ar: 'حسناً', en: 'OK');

  // ── Quran Settings Sheet Tabs ────────────────────────────────────
  String get tabReading => _translate(ku: 'خوێندنەوە', ar: 'القراءة', en: 'Reading');
  String get tabColor => _translate(ku: 'ڕەنگ', ar: 'اللون', en: 'Color');
  String get tabAudio => _translate(ku: 'دەنگ', ar: 'الصوت', en: 'Audio');
  String get tabNavigation => _translate(ku: 'بڕین', ar: 'التنقل', en: 'Navigate');

  // ── Quran Reader ─────────────────────────────────────────────────
  String get quranNoSurahFound => _translate(ku: 'هیچ سورەتێک نەدۆزرایەوە', ar: 'لم يُعثر على سورة', en: 'No surah found');
  String get quranErrorLoadingSurahs => _translate(ku: 'هەڵە لە بارکردنی سورەتەکان', ar: 'خطأ في تحميل السور', en: 'Error loading surahs');
  String get quranImageError => _translate(ku: 'کێشەیەک ڕوویدا لە دروستکردنی وێنەکە', ar: 'خطأ في إنشاء الصورة', en: 'Error generating image');

  // ── Audio Settings ───────────────────────────────────────────────
  String get audioReciterLoadError => _translate(ku: 'کێشەیەک ڕوویدا لە هێنانی ناوی قورئان خوێنەکان', ar: 'خطأ في تحميل أسماء القراء', en: 'Error loading reciters');
  String get audioQualityTitle => _translate(ku: 'کوالێتی دەنگ', ar: 'جودة الصوت', en: 'Audio Quality');
  String get audioQualityAuto => _translate(ku: 'ئۆتۆماتیکی', ar: 'تلقائي', en: 'Auto');
  String get audioQualityHigh => _translate(ku: 'بەرز (192kbps)', ar: 'عالية (192kbps)', en: 'High (192kbps)');
  String get audioQualityMedium => _translate(ku: 'ناوەند (128kbps)', ar: 'متوسطة (128kbps)', en: 'Medium (128kbps)');
  String get audioQualityLow => _translate(ku: 'نزم (64kbps)', ar: 'منخفضة (64kbps)', en: 'Low (64kbps)');
  String get audioQualityOfflineOnly => _translate(ku: 'تەنها دەرەوەی هێڵ', ar: 'دون اتصال فقط', en: 'Offline Only');
  String get audioMemorizationMode => _translate(ku: 'مۆدی لەبەرکردن و حیفز', ar: 'وضع الحفظ', en: 'Memorization Mode');
  String get audioMemorizationOff => _translate(ku: 'ناچالاک', ar: 'إيقاف', en: 'Off');
  String get audioMemorizationBeginner => _translate(ku: 'سەرەتایی', ar: 'مبتدئ', en: 'Beginner');
  String get audioMemorizationIntermediate => _translate(ku: 'ناوەند', ar: 'متوسط', en: 'Intermediate');
  String get audioMemorizationAdvanced => _translate(ku: 'پێشکەوتوو', ar: 'متقدم', en: 'Advanced');
  String get audioRepeatMode => _translate(ku: 'شێوازی دووبارەکردنەوە', ar: 'وضع التكرار', en: 'Repeat Mode');
  String get audioRepeatNone => _translate(ku: 'هیچ', ar: 'بدون', en: 'None');
  String get audioRepeatAyah => _translate(ku: 'ئایەت', ar: 'آية', en: 'Ayah');
  String get audioRepeatRange => _translate(ku: 'مەودا (A-B)', ar: 'نطاق (A-B)', en: 'Range (A-B)');
  String get audioRepeatSurah => _translate(ku: 'سوورەت', ar: 'سورة', en: 'Surah');
  String get audioRangeTitle => _translate(ku: 'دیاریکردنی مەودای ئایەتەکان (A-B)', ar: 'تحديد نطاق الآيات (A-B)', en: 'Select Ayah Range (A-B)');
  String get audioRangeStart => _translate(ku: 'ئایەتی دەستپێک (A)', ar: 'آية البداية (A)', en: 'Start Ayah (A)');
  String get audioRangeEnd => _translate(ku: 'ئایەتی کۆتایی (B)', ar: 'آية النهاية (B)', en: 'End Ayah (B)');
  String audioAyahNumber(int n) => _translate(ku: 'ئایەتی $n', ar: 'آية $n', en: 'Ayah $n');
  String get audioRepeatCount => _translate(ku: 'ژمارەی دووبارەکردنەوە', ar: 'عدد التكرارات', en: 'Repeat Count');
  String get audioRepeatInfinite => _translate(ku: '∞ بێسنوور', ar: '∞ لانهائي', en: '∞ Infinite');
  String audioRepeatTimes(int n) => _translate(ku: '$n جار', ar: '$n مرة', en: '$n times');
  String get audioGapMode => _translate(ku: 'شێوازی ماوەی بێدەنگی', ar: 'وضع الفجوة', en: 'Gap Mode');
  String get audioGapNone => _translate(ku: 'بێ بێدەنگی', ar: 'بدون فجوة', en: 'No Gap');
  String get audioGapBetweenAyahs => _translate(ku: 'نێوان ئایەتەکان', ar: 'بين الآيات', en: 'Between Ayahs');
  String get audioGapBetweenRepeats => _translate(ku: 'نێوان دووبارەبوونەوەکان', ar: 'بين التكرارات', en: 'Between Repeats');
  String get audioGapDuration => _translate(ku: 'ماوەی چاوەڕوانی بێدەنگی', ar: 'مدة الفجوة', en: 'Gap Duration');
  String audioGapSeconds(int s) => _translate(ku: '$s چرکە', ar: '$s ثانية', en: '$s sec');
  String get audioGeneralOptions => _translate(ku: 'بژاردە گشتییەکان', ar: 'خيارات عامة', en: 'General Options');
  String get audioAutoNext => _translate(ku: 'پەڕینەوەی ئۆتۆماتیکی بۆ بەشی دواتر', ar: 'التشغيل التلقائي للتالي', en: 'Auto advance to next');
  String get audioSleepTimer => _translate(ku: 'کاتی خەوتن', ar: 'مؤقت النوم', en: 'Sleep Timer');
  String get audioSleepTimerUntilSurahEnd => _translate(ku: 'تا کۆتایی سوورەت', ar: 'حتى نهاية السورة', en: 'Until end of surah');
  String get audioSleepTimerRemaining => _translate(ku: 'کاتی ماوە بۆ خەوتن', ar: 'الوقت المتبقي للنوم', en: 'Time remaining to sleep');
  String get audioSleepTimerCancel => _translate(ku: 'پاشگەزبوونەوە لە کاتەکە', ar: 'إلغاء المؤقت', en: 'Cancel timer');
  String get audioSleepTimerPrompt => _translate(ku: 'دیاریکردنی کات بۆ کوژانەوەی دەنگ لەکاتی خەوتندا:', ar: 'حدد وقتاً لإيقاف الصوت عند النوم:', en: 'Set a time to stop audio when sleeping:');
  String get audioSurahEnd => _translate(ku: 'کۆتایی سوورەت', ar: 'نهاية السورة', en: 'Surah End');
  String get audioSleepMin15 => _translate(ku: '١٥ خولەک', ar: '١٥ دقيقة', en: '15 min');
  String get audioSleepMin30 => _translate(ku: '٣٠ خولەک', ar: '٣٠ دقيقة', en: '30 min');
  String get audioSleepMin45 => _translate(ku: '٤٥ خولەک', ar: '٤٥ دقيقة', en: '45 min');
  String get audioSleepMin60 => _translate(ku: '٦٠ خولەک', ar: '٦٠ دقيقة', en: '60 min');
  String get audioOfflineTitle => _translate(ku: 'داگرتنی فایل بۆ بەکارهێنانی دەرەوەی هێڵ', ar: 'تحميل الملفات للاستخدام دون اتصال', en: 'Download for Offline Use');
  String get audioOfflineShowDashboard => _translate(ku: 'پیشاندانی داشبۆرد', ar: 'عرض لوحة التحكم', en: 'Show Dashboard');
  String get audioOfflineDownloaded => _translate(ku: 'فایلی دەنگی داگیراوە (کاردەکات بەبێ ئینتەرنێت)', ar: 'الملف الصوتي محمّل (يعمل دون إنترنت)', en: 'Audio file downloaded (works offline)');
  String get audioOfflineDownloading => _translate(ku: 'داگرتنی فایلی دەنگی سوورەت...', ar: 'جاري تحميل الملف الصوتي للسورة...', en: 'Downloading surah audio...');
  String audioOfflineProgress(String pct, String downloaded, String total) => _translate(
        ku: 'داگیراوە: $pct% ($downloaded / ${total}MB)',
        ar: 'تم التحميل: $pct% ($downloaded / ${total}MB)',
        en: 'Downloaded: $pct% ($downloaded / ${total}MB)',
      );
  String get audioOfflinePrompt => _translate(ku: 'خوێندنەوەی ئەم سوورەتە داگیرابێت بۆ کارکردنی دەرەوەی هێڵ.', ar: 'حمّل هذه السورة للاستماع دون اتصال.', en: 'Download this surah to listen offline.');
  String get audioQueueStatus => _translate(ku: 'ڕیزی داگرتن', ar: 'قائمة التحميل', en: 'Download Queue');
  String audioQueuePending(int n) => _translate(ku: '$n فایل لە چاوەڕوانیدایە', ar: '$n ملفات في الانتظار', en: '$n files pending');
  String get audioQueueBackground => _translate(ku: 'خەریکی داگرتنی فایلەکانی ترە لە پاشبنەما...', ar: 'جاري تحميل الملفات الأخرى في الخلفية...', en: 'Downloading other files in background...');

  // ── Download Manager ─────────────────────────────────────────────
  String get downloadDeletePackageTitle => _translate(ku: 'سڕینەوەی بەستە', ar: 'حذف الحزمة', en: 'Delete Package');
  String downloadDeletePackageConfirm(String name) => _translate(ku: 'ئایا دڵنیایت لە سڕینەوەی پاکێجی $name؟', ar: 'هل أنت متأكد من حذف حزمة $name؟', en: 'Are you sure you want to delete $name?');
  String get downloadDeleteReciterTitle => _translate(ku: 'سڕینەوەی دەنگەکان', ar: 'حذف التسجيلات الصوتية', en: 'Delete Audio');
  String downloadDeleteReciterConfirm(String name) => _translate(ku: 'ئایا دڵنیایت لە سڕینەوەی هەموو سوورەتە داگیراوەکانی $name؟', ar: 'هل أنت متأكد من حذف جميع سور $name المحملة؟', en: 'Are you sure you want to delete all downloaded surahs of $name?');

  // ── Settings ─────────────────────────────────────────────────────
  String get settingsBackupExportTitle => _translate(ku: 'پاشەکەوتکردن', ar: 'النسخ الاحتياطي', en: 'Backup');
  String get settingsBackupSend => _translate(ku: 'ناردن', ar: 'إرسال', en: 'Send');
  String get settingsBackupCancel => _translate(ku: 'پاشگەزبوونەوە', ar: 'إلغاء', en: 'Cancel');
  String get settingsReminderMinDaysError => _translate(ku: 'تکایە لانی کەم یەک ڕۆژ دیاری بکە.', ar: 'يرجى تحديد يوم واحد على الأقل.', en: 'Please select at least one day.');
  String get settingsReminderSave => _translate(ku: 'پەسەندکردن', ar: 'تأكيد', en: 'Confirm');

  // ── Memorization ─────────────────────────────────────────────────
  String get memorizationErrorLoadingAyahs => _translate(ku: 'کێشەیەک ڕوویدا لە بارکردنی ئایەتەکان', ar: 'خطأ في تحميل الآيات', en: 'Error loading ayahs');
  String get memorizationNoStats => _translate(ku: 'هیچ ئامارێک بەردەست نییە.', ar: 'لا تتوفر إحصائيات.', en: 'No statistics available.');
  String get memorizationNoHistory => _translate(ku: 'تا ئێستا هیچ پێداچوونەوەیەک تۆمار نەکراوە.', ar: 'لم يتم تسجيل أي مراجعة حتى الآن.', en: 'No reviews recorded yet.');
  String get memorizationNoAnalytics => _translate(ku: 'هیچ ئامارێک نەدۆزرایەوە.', ar: 'لم يتم العثور على إحصائيات.', en: 'No analytics found.');
  String get memorizationNoDashboardStats => _translate(ku: 'هیچ زانیارییەکی ئامار نەدۆزرایەوە.', ar: 'لم يتم العثور على بيانات إحصائية.', en: 'No statistics data found.');
  String get memorizationErrorLoadingProgress => _translate(ku: 'کێشە لە بارکردنی ئاماری پێشکەوتن', ar: 'خطأ في تحميل إحصائيات التقدم', en: 'Error loading progress stats');
  String get memorizationErrorLoadingHistory => _translate(ku: 'کێشە لە بارکردنی مێژوو', ar: 'خطأ في تحميل السجل', en: 'Error loading history');
  String get memorizationSelectSurah => _translate(ku: 'سورەت هەڵبژێرە', ar: 'اختر السورة', en: 'Select Surah');
  String get memorizationSelectJuz => _translate(ku: 'جزء هەڵبژێرە', ar: 'اختر الجزء', en: 'Select Juz');
  String memorizationJuz(int n) => _translate(ku: 'جزء $n', ar: 'الجزء $n', en: 'Juz $n');
  String get memorizationQuitTitle => _translate(ku: 'داگیرکردنی تاقیکردنەوە', ar: 'إنهاء الاختبار', en: 'Quit Quiz');
  String get memorizationQuitNo => _translate(ku: 'نەخێر', ar: 'لا', en: 'No');
  String get memorizationQuitYes => _translate(ku: 'بەڵێ', ar: 'نعم', en: 'Yes');
  String get memorizationErrorMsg => _translate(ku: 'کێشە', ar: 'خطأ', en: 'Error');

  // ── Tasbih Page ─────────────────────────────────────────────────
  String get tasbihAddDhikr => _translate(ku: 'زیادکردنی زیکر', ar: 'إضافة ذكر', en: 'Add Dhikr');
  String get tasbihAddCount => _translate(ku: 'زیادکردن', ar: 'إضافة', en: 'Add');
  String get tasbihDeleteConfirmYes => _translate(ku: 'بەڵێ، بسڕەوە', ar: 'نعم، احذف', en: 'Yes, Delete');

  // ── Search Page ──────────────────────────────────────────────────
  String get searchRetry => _translate(ku: 'دووبارە هەوڵبدەرەوە', ar: 'المحاولة مرة أخرى', en: 'Retry');

  // ── Notes ────────────────────────────────────────────────────────
  String get notesDeleteTitle => _translate(ku: 'سڕینەوەی تێبینی', ar: 'حذف الملاحظة', en: 'Delete Note');
  String get notesDeleteConfirm => _translate(ku: 'دڵنیای لە سڕینەوەی ئەم تێبینییە؟', ar: 'هل أنت متأكد من حذف هذه الملاحظة؟', en: 'Are you sure you want to delete this note?');

  // ── Auth (additional) ────────────────────────────────────────────
  String get authGenderMale => _translate(ku: 'نێر', ar: 'ذكر', en: 'Male');
  String get authGenderFemale => _translate(ku: 'مێ', ar: 'أنثى', en: 'Female');
  String get authLogoutThisDevice => _translate(ku: 'چوونەدەرەوە لەم ئامێرە', ar: 'تسجيل الخروج من هذا الجهاز', en: 'Log out from this device');
  String get authLogoutAllDevices => _translate(ku: 'چوونەدەرەوە لە سەرجەم ئامێرەکان', ar: 'تسجيل الخروج من جميع الأجهزة', en: 'Log out from all devices');
  String get authPrimaryColor => _translate(ku: 'ڕەنگی سەرەکی ئەپ', ar: 'اللون الرئيسي للتطبيق', en: 'App Primary Color');

  // ── Leaderboard ──────────────────────────────────────────────────
  String get leaderboardPublicProfile => _translate(ku: 'پڕۆفایلی گشتی', ar: 'الملف الشخصي العام', en: 'Public Profile');
  String get leaderboardPublicProfileSub => _translate(ku: 'ناوی ڕاستەقینەت لە ڕیزبەندی نیشان بدرێت', ar: 'اعرض اسمك الحقيقي في لوحة المتصدرين', en: 'Show your real name in the leaderboard');
  String get leaderboardAnonymous => _translate(ku: 'مۆدی نادیار (Anonymous)', ar: 'وضع مجهول الهوية', en: 'Anonymous Mode');
  String get leaderboardAnonymousSub => _translate(ku: 'ناوی پڕۆفایلەکەت وەک بەکارهێنەرێکی نەناسراو نیشان بدرێت', ar: 'اعرض اسمك كمستخدم مجهول', en: 'Show your name as an anonymous user');
  String get leaderboardHidden => _translate(ku: 'شاردراوە لە ڕیزبەندی', ar: 'مخفي في لوحة المتصدرين', en: 'Hidden from Leaderboard');
  String get leaderboardHiddenSub => _translate(ku: 'خاڵەکانت تۆمار بکرێن بەڵام لە ڕیزبەندی نیشان نەدرێیت', ar: 'تسجيل نقاطك لكن عدم ظهورها في اللوحة', en: 'Record your points but not shown in leaderboard');

  // ── Statistics ───────────────────────────────────────────────────
  String get statsSpiritualProductivity => _translate(ku: 'نمرەی بەرهەمداری ڕۆحی', ar: 'درجة الإنتاجية الروحية', en: 'Spiritual Productivity Score');
  String statsGoalAndStreak(String goalRate, String streak) => _translate(
        ku: 'ئامانج: $goalRate%  •  بەردەوامی: $streak ڕۆژ',
        ar: 'الهدف: $goalRate%  •  السلسلة: $streak يوم',
        en: 'Goal: $goalRate%  •  Streak: $streak days',
      );

  // ── Prayer Widget ────────────────────────────────────────────────
  String get prayerRetry => _translate(ku: 'دووبارە هەوڵ بدەرەوە', ar: 'المحاولة مرة أخرى', en: 'Try again');

  // ── Achievements ─────────────────────────────────────────────────
  String get achievementsEmpty => _translate(ku: 'هیچ دەستکەوتەیەک نییە', ar: 'لا توجد إنجازات', en: 'No achievements');
  String get achievementsRetry => _translate(ku: 'دووبارە هەوڵ بدەرەوە', ar: 'المحاولة مرة أخرى', en: 'Try again');

  // ── Reminders ────────────────────────────────────────────────────
  String get remindersRetry => _translate(ku: 'دووبارە هەوڵ بکەرەوە', ar: 'المحاولة مرة أخرى', en: 'Try Again');

  // ── Statistics Page ──────────────────────────────────────────────
  String get statsTitle => _translate(ku: 'ئامار و زانیارییەکان', ar: 'الإحصائيات والتحليلات', en: 'Statistics & Insights');
  String get statsTotalDhikr => _translate(ku: 'کۆی زیکرەکان', ar: 'إجمالي الأذكار', en: 'Total Dhikr');
  String get statsCurrentStreak => _translate(ku: 'بەردەوامی ئێستا', ar: 'السلسلة الحالية', en: 'Current Streak');
  String get statsBestStreak => _translate(ku: 'باشترین بەردەوامی', ar: 'أفضل سلسلة', en: 'Best Streak');
  String get statsGoalsCompleted => _translate(ku: 'ئامانجی تەواوبوو', ar: 'الأهداف المكتملة', en: 'Goals Completed');
  String get statsAchievements => _translate(ku: 'دەستکەوتەکان', ar: 'الإنجازات', en: 'Achievements');
  String get statsSessions => _translate(ku: 'خولەکان', ar: 'الجلسات', en: 'Sessions');
  String get statsDhikrActivityChart => _translate(ku: 'چالاکی ڕۆژانەی زیکر', ar: 'نشاط الذكر اليومي', en: 'Daily Dhikr Activity');
  String get statsDhikrTrendVsPrev => _translate(ku: 'بەراوردی زیکر بە پێشوو', ar: 'مقارنة الذكر بالسابق', en: 'Dhikr vs Previous');
  String get statsSessionsTrendVsPrev => _translate(ku: 'بەراوردی خول بە پێشوو', ar: 'مقارنة الجلسات بالسابق', en: 'Sessions vs Previous');
  String get statsStreakHeatmap => _translate(ku: '🔥 نەخشەی بەردەوامی', ar: '🔥 خريطة الاستمرارية', en: '🔥 Streak Heatmap');
  String statsStreakSummary(String current, String best, String rate) => _translate(
    ku: 'ئێستا: ${current}ڕ  •  باشترین: ${best}ڕ  •  ڕێژەی سەرکەوتن: $rate%',
    ar: 'الحالي: $current أيام  •  الأفضل: $best أيام  •  معدل النجاح: $rate%',
    en: 'Current: $current days  •  Best: $best days  •  Success rate: $rate%',
  );
  String get statsMostUsedDhikr => _translate(ku: 'زۆرترین زیکری بەکارهاتوو', ar: 'أكثر الأذكار استخداماً', en: 'Most Used Dhikr');
  String get statsSessionAnalysis => _translate(ku: 'شیکاریی خولەکان', ar: 'تحليل الجلسات', en: 'Session Analysis');
  String get statsTotalSessions => _translate(ku: 'کۆی خولەکان', ar: 'إجمالي الجلسات', en: 'Total Sessions');
  String get statsAvgDuration => _translate(ku: 'تێکڕای ماوە', ar: 'متوسط المدة', en: 'Avg Duration');
  String get statsLongestSession => _translate(ku: 'درێژترین خول', ar: 'أطول جلسة', en: 'Longest Session');
  String get statsAvgDhikrPerMin => _translate(ku: 'تێکڕای زیکر/خولەک', ar: 'متوسط ذكر/دقيقة', en: 'Avg Dhikr/Min');
  String get statsPeakHour => _translate(ku: 'کاتژمێری لوتکە', ar: 'ساعة الذروة', en: 'Peak Hour');
  String get statsPeakDay => _translate(ku: 'ڕۆژی لوتکە', ar: 'يوم الذروة', en: 'Peak Day');
  String get statsUpcomingGoals => _translate(ku: '🎯 ئامانجەکانی داهاتوو', ar: '🎯 الأهداف القادمة', en: '🎯 Upcoming Goals');
  String get statsInsights => _translate(ku: '💡 تێڕوانینەکان', ar: '💡 التحليلات', en: '💡 Insights');
  String statsTrendVsPrev(String pct) => _translate(ku: '${pct}% بە بەراورد بە پێشوو', ar: '$pct% مقارنةً بالسابق', en: '$pct% vs previous');
  String statsCompletedPct(String pct) => _translate(ku: '$pct% تەواو بووە', ar: '$pct% مكتمل', en: '$pct% completed');
  String statsStreakDays(String n) => _translate(ku: '${n}ڕ', ar: '$n أيام', en: '$n days');
  String get statsLabelMaster => _translate(ku: 'مامۆستا', ar: 'خبير', en: 'Master');
  String get statsLabelAdvanced => _translate(ku: 'پێشکەوتوو', ar: 'متقدم', en: 'Advanced');
  String get statsLabelDedicated => _translate(ku: 'پابەندبوو', ar: 'مخلص', en: 'Dedicated');
  String get statsLabelActive => _translate(ku: 'چالاک', ar: 'نشيط', en: 'Active');
  String get statsLabelBeginner => _translate(ku: 'سەرەتا', ar: 'مبتدئ', en: 'Beginner');
  String get statsFajr => _translate(ku: 'بەیانی', ar: 'الفجر', en: 'Fajr');
  String get statsDhuhr => _translate(ku: 'نیوەڕۆ', ar: 'الظهر', en: 'Dhuhr');
  String get statsAsr => _translate(ku: 'عەسڕ', ar: 'العصر', en: 'Asr');
  String get statsMaghrib => _translate(ku: 'مەغریب', ar: 'المغرب', en: 'Maghrib');
  String get statsIsha => _translate(ku: 'عیشا', ar: 'العشاء', en: 'Isha');
  String statsPrayerHour(String name, int h) => _translate(ku: '$name ($hک)', ar: '$name ($h)', en: '$name ($h h)');
  String statsHourLabel(int h) => _translate(ku: 'کاتژمێر $h:00', ar: 'الساعة $h:00', en: 'Hour $h:00');
  String statsDurationSecs(int s) => _translate(ku: '$s چرکە', ar: '$s ثانية', en: '$s secs');
  String statsDurationMinsAndSecs(int mins, int secs) => _translate(ku: '$mins خولەک و $secs چرکە', ar: '$mins دقيقة و $secs ثانية', en: '$mins mins $secs secs');
  String get statsDayMonday => _translate(ku: 'دووشەممە', ar: 'الاثنين', en: 'Monday');
  String get statsDayTuesday => _translate(ku: 'سێشەممە', ar: 'الثلاثاء', en: 'Tuesday');
  String get statsDayWednesday => _translate(ku: 'چوارشەممە', ar: 'الأربعاء', en: 'Wednesday');
  String get statsDayThursday => _translate(ku: 'پێنجشەممە', ar: 'الخميس', en: 'Thursday');
  String get statsDayFriday => _translate(ku: 'هەینی', ar: 'الجمعة', en: 'Friday');
  String get statsDaySaturday => _translate(ku: 'شەممە', ar: 'السبت', en: 'Saturday');
  String get statsDaySunday => _translate(ku: 'یەکشەممە', ar: 'الأحد', en: 'Sunday');

  // ── Achievements Page ────────────────────────────────────────────
  String get achievementsTitle => _translate(ku: '🏆 دەستکەوتەکان', ar: '🏆 الإنجازات', en: '🏆 Achievements');
  String get achievementsAll => _translate(ku: 'هەمووی', ar: 'الكل', en: 'All');

  // ── Favorites Page ───────────────────────────────────────────────
  String get favTabAyahs => _translate(ku: 'ئایەتەکان', ar: 'الآيات', en: 'Ayahs');
  String get favTabHadiths => _translate(ku: 'فەرموودەکان', ar: 'الأحاديث', en: 'Hadiths');
  String get favTabNames => _translate(ku: 'ناوەکان', ar: 'الأسماء', en: 'Names');
  String get favTabBiographies => _translate(ku: 'ژیاننامەکان', ar: 'السير', en: 'Biographies');
  String get favNoAyahs => _translate(ku: 'هیچ ئایەتێکی دڵخواز نییە', ar: 'لا توجد آيات مفضلة', en: 'No favorite ayahs');
  String get favNoHadiths => _translate(ku: 'هیچ فەرموودەیەکی دڵخواز نییە', ar: 'لا توجد أحاديث مفضلة', en: 'No favorite hadiths');
  String get favNoNames => _translate(ku: 'هیچ ناوێکی دڵخواز نییە', ar: 'لا توجد أسماء مفضلة', en: 'No favorite names');
  String get favNoBiographies => _translate(ku: 'هیچ ژیاننامەیەکی دڵخواز نییە', ar: 'لا توجد سير مفضلة', en: 'No favorite biographies');
  String favAyahRef(int surah, int ayah) => _translate(ku: 'سوورەتی $surah:$ayah', ar: 'سورة $surah: آية $ayah', en: 'Surah $surah:$ayah');

  // ── Hadith Page ──────────────────────────────────────────────────
  String get hadithSearchHint => _translate(ku: 'بگەڕێ لە فەرموودەکان...', ar: 'ابحث في الأحاديث...', en: 'Search hadiths...');
  String get hadithPageTitle => _translate(ku: 'فەرموودەکانی پێغەمبەر', ar: 'أحاديث النبي ﷺ', en: 'Prophet\'s Hadiths');
  String get hadithRefresh => _translate(ku: 'تازەکردنەوە', ar: 'تحديث', en: 'Refresh');
  String get hadithHeaderQuote => _translate(ku: 'مَنْ يُطِعِ الرَّسُولَ فَقَدْ أَطَاعَ اللَّهَ', ar: 'مَنْ يُطِعِ الرَّسُولَ فَقَدْ أَطَاعَ اللَّهَ', en: 'Whoever obeys the Messenger has obeyed Allah');
  String get hadithHeaderSub => _translate(ku: 'فەرموودە ڕاستەکانی پێغەمبەری خودا (د.خ)', ar: 'الأحاديث الصحيحة للنبي ﷺ', en: 'Authentic Hadiths of the Prophet ﷺ');
  String get hadithLoadError => _translate(ku: 'سەرکەوتوو نەبوو لە بارکردنی فەرموودەکان', ar: 'فشل تحميل الأحاديث', en: 'Failed to load hadiths');
  String get hadithNetworkError => _translate(ku: 'دڵنیابەوە لە هێڵی ئینتەرنێتەکەت یان سێرڤەر', ar: 'تحقق من اتصالك بالإنترنت أو الخادم', en: 'Check your internet connection or server');
  String get hadithRetry => _translate(ku: 'دووبارە هەوڵبدەرەوە', ar: 'المحاولة مرة أخرى', en: 'Retry');
  String get hadithNoCategoryFound => _translate(ku: 'هیچ هاوپۆلێک نەدۆزرایەوە', ar: 'لم يتم العثور على تصنيف', en: 'No category found');
  String get hadithNoResults => _translate(ku: 'هیچ ئەنجامێک نەدۆزرایەوە بۆ', ar: 'لم يتم العثور على نتائج لـ', en: 'No results found for');
  String hadithCount(int count) => _translate(ku: '$count فەرموودە', ar: '$count حديث', en: '$count hadiths');
  String get hadithNoHadithsInCategory => _translate(ku: 'هیچ فەرموودەیەک لەم هاوپۆلەدا نییە', ar: 'لا توجد أحاديث في هذا التصنيف', en: 'No hadiths in this category');
  String get hadithCopiedSuccess => _translate(ku: 'فەرموودەکە بە سەرکەوتوویی کۆپیکرا', ar: 'تم نسخ الحديث بنجاح', en: 'Hadith copied successfully');
  String get hadithExplanation => _translate(ku: 'شیکردنەوە', ar: 'الشرح', en: 'Explanation');
  String get hadithExplanationAndLessons => _translate(ku: 'شیکردنەوە و وانەکان', ar: 'الشرح والدروس', en: 'Explanation & Lessons');
  String get hadithCopyTooltip => _translate(ku: 'کۆپیکردن', ar: 'نسخ', en: 'Copy');
  String get hadithShareTooltip => _translate(ku: 'بڵاوکردنەوە', ar: 'مشاركة', en: 'Share');
  String get hadithBookmarkTooltip => _translate(ku: 'نیشانەکردن', ar: 'إضافة للمحفوظات', en: 'Bookmark');
  String get hadithTranslationHeader => _translate(ku: 'وەرگێڕان:', ar: 'الترجمة:', en: 'Translation:');
  String get hadithSourceHeader => _translate(ku: 'سەرچاوە:', ar: 'المصدر:', en: 'Source:');

  // ── Notes Page ───────────────────────────────────────────────────
  String get notesPageTitle => _translate(ku: 'تێبینی و ڕامانەکان', ar: 'الملاحظات والتأملات', en: 'Notes & Reflections');
  String notesSurahNum(int num) => _translate(ku: 'سوورەت $num', ar: 'سورة $num', en: 'Surah $num');
  String get notesNewTitle => _translate(ku: 'تێبینی و ڕامانی نوێ', ar: 'ملاحظة جديدة', en: 'New Note');
  String get notesEditTitle => _translate(ku: 'دەستکاری تێبینی', ar: 'تعديل الملاحظة', en: 'Edit Note');
  String get notesHintText => _translate(ku: 'لێرەدا بیرۆکە و ڕامانەکانت بنووسە...', ar: 'اكتب أفكارك هنا...', en: 'Write your thoughts here...');
  String get notesCancel => _translate(ku: 'پاشگەزبوونەوە', ar: 'إلغاء', en: 'Cancel');
  String get notesSave => _translate(ku: 'پاشەکەوتکردن', ar: 'حفظ', en: 'Save');
  String get notesSearchHint => _translate(ku: 'بگەڕێ لە تێبینیەکان...', ar: 'ابحث في الملاحظات...', en: 'Search notes...');
  String get notesEmptySearch => _translate(ku: 'هیچ تێبینیەک نەدۆزرایەوە بۆ گەڕانەکەت', ar: 'لم يتم العثور على ملاحظات لبحثك', en: 'No notes found for your search');
  String get notesEmptyList => _translate(ku: 'هیچ تێبینیەک نییە لە ئێستادا', ar: 'لا توجد ملاحظات الآن', en: 'No notes yet');
  String get notesEmptyHint => _translate(ku: 'تێبینی نوێ بنووسە بۆ تۆمارکردنی وانە و ڕامانەکانت', ar: 'اكتب ملاحظة جديدة لتسجيل دروسك وأفكارك', en: 'Write a new note to record your lessons and thoughts');
  String get notesUpdatedAt => _translate(ku: 'نوێکراوەتەوە:', ar: 'تم التحديث:', en: 'Updated:');
  String get notesGeneralNote => _translate(ku: 'تێبینی گشتی / ڕامان', ar: 'ملاحظة عامة / فكرة', en: 'General Note / Thought');
  String get notesDeleteNo => _translate(ku: 'نەخێر', ar: 'لا', en: 'No');
  String get notesDeleteYes => _translate(ku: 'بەڵێ', ar: 'نعم', en: 'Yes');

  // ── Tajweed Page ─────────────────────────────────────────────────
  String get tajweedPageTitle => _translate(ku: 'فێربوونی یاساکانی تەجوید', ar: 'تعلم قواعد التجويد', en: 'Learn Tajweed Rules');
  String get tajweedRulesFallback => _translate(ku: 'یاساکان', ar: 'القواعد', en: 'Rules');
  String get tajweedNetworkError => _translate(ku: 'هێڵی ئینتەرنێت نییە یان سێرڤەر کار ناکات', ar: 'لا يوجد اتصال بالإنترنت أو الخادم لا يعمل', en: 'No internet connection or server is offline');
  String get tajweedNoCategories => _translate(ku: 'هیچ هاوپۆلێک بەردەست نییە', ar: 'لا توجد تصنيفات متاحة', en: 'No categories available');
  String get tajweedSelectTopic => _translate(ku: 'هەڵبژاردنی بابەت', ar: 'اختر الموضوع', en: 'Select Topic');
  String get tajweedAllActive => _translate(ku: 'هەموو چالاکن', ar: 'الكل نشط', en: 'All active');
  String tajweedRulesCount(int count) => _translate(ku: '$count یاسا', ar: '$count قواعد', en: '$count rules');
  String tajweedActiveRulesCount(int active, int total) => _translate(ku: '$active لە $total یاسا چالاکە', ar: '$active من أصل $total قواعد نشطة', en: '$active of $total rules active');
  String get tajweedRuleDisabled => _translate(ku: 'ئەم یاسایە ناچالاک کراوە', ar: 'هذه القاعدة غير مفعلة', en: 'This rule is disabled');
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
