import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/prayer_times_provider.dart';
import '../../core/services/battery_optimization_service.dart';
import '../../core/services/prayer_notification_service.dart';

class PrayerMethodSettingsPage extends ConsumerWidget {
  const PrayerMethodSettingsPage({super.key});

  String _getTranslation(String key, BuildContext context) {
    final isKurdish = Localizations.localeOf(context).languageCode == 'ku';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    switch (key) {
      case 'prayer.method.muslim_world_league.name':
        return isKurdish ? 'ڕابیتەی جیهانی ئیسلامی' : isArabic ? 'رابطة العالم الإسلامي' : 'Muslim World League';
      case 'prayer.method.muslim_world_league.desc':
        return isKurdish
            ? 'زاویەی بەیانی: ١٨، زاویەی عیشا: ١٧. گونجاوە بۆ ئەوروپا، ڕۆژهەڵاتی دوور و ئەمریکا.'
            : isArabic
                ? 'فجر 18°، عشاء 17°. الطريقة القياسية في أوروبا وآسيا وأجزاء من الأمريكتين.'
                : 'Fajr 18.0°, Isha 17.0°. Standard method in Europe, Far East, and parts of Americas.';
      case 'prayer.method.egyptian.name':
        return isKurdish ? 'دەستەی گشتی ڕووپێوی میسر' : isArabic ? 'الهيئة المصرية العامة للمساحة' : 'Egyptian General Authority';
      case 'prayer.method.egyptian.desc':
        return isKurdish
            ? 'زاویەی بەیانی: ١٩.٥، زاویەی عیشا: ١٧.٥. میسر و باکووری ئەفریقا.'
            : isArabic
                ? 'فجر 19.5°، عشاء 17.5°. مستخدمة في مصر وأجزاء من أفريقيا.'
                : 'Fajr 19.5°, Isha 17.5°. Widely used in Egypt and parts of Africa.';
      case 'prayer.method.umm_al_qura.name':
        return isKurdish ? 'زانکۆی ئوم ئەلقورا، مەککە' : isArabic ? 'جامعة أم القرى، مكة' : 'Umm al-Qura University, Makkah';
      case 'prayer.method.umm_al_qura.desc':
        return isKurdish
            ? 'زاویەی بەیانی: ١٨.٥، عیشا: ٩٠ خولەک دوای مەغریب. عەرەبستانی سعوودی.'
            : isArabic
                ? 'فجر 18.5°، عشاء: 90 دقيقة بعد المغرب. المملكة العربية السعودية.'
                : 'Fajr 18.5°, Isha: 90 min after Maghrib (120 in Ramadan). Saudi Arabia.';
      case 'prayer.method.isna.name':
        return isKurdish ? 'کۆمەڵەی ئیسلامی ئەمریکای باکوور' : isArabic ? 'المجمع الإسلامي لأمريكا الشمالية' : 'ISNA';
      case 'prayer.method.isna.desc':
        return isKurdish
            ? 'زاویەی بەیانی: ١٥، زاویەی عیشا: ١٥. ئەمریکای باکوور.'
            : isArabic
                ? 'فجر 15°، عشاء 15°. أمريكا الشمالية.'
                : 'Fajr 15.0°, Isha 15.0°. Standard method in North America.';
      case 'prayer.method.turkey.name':
        return isKurdish ? 'تورکیا (دیانەت)' : isArabic ? 'تركيا (الشؤون الدينية)' : 'Turkey (Diyanet)';
      case 'prayer.method.turkey.desc':
        return isKurdish
            ? 'زاویەی بەیانی: ١٨، زاویەی عیشا: ١٧ لەگەڵ دەستکاری خۆجێی تورکیا.'
            : isArabic
                ? 'فجر 18°، عشاء 17°. الطريقة المستخدمة في تركيا.'
                : 'Fajr 18.0°, Isha 17.0°. Standard method used in Turkey.';
      case 'prayer.method.kurdistan.name':
        return isKurdish ? 'هەرێمی کوردستان (وەزارەتی ئەوقاف)' : isArabic ? 'إقليم كردستان (وزارة الأوقاف)' : 'Kurdistan Region Ministry';
      case 'prayer.method.kurdistan.desc':
        return isKurdish
            ? 'ڕێساکان و دەستکاری ناوخۆیی بۆ شارەکانی کوردستان و عێراق (پێشنیارکراو).'
            : isArabic
                ? 'قواعد محلية وتعديلات للعراق وكردستان (موصى به).'
                : 'Iraq/Kurdistan local calculation rules and offsets (Recommended).';
      case 'prayer.method.title':
        return isKurdish ? 'دەنگی بانگدان' : isArabic ? 'صوت الأذان' : 'Adhan Sound';
      case 'prayer.method.subtitle':
        return isKurdish
            ? 'هەڵبژاردنی دەنگی ئاگادارکردنەوە بۆ کاتەکانی بانگ'
            : isArabic
                ? 'اختر صوت الأذان للتنبيه بمواقيت الصلاة'
                : 'Choose adhan sound for prayer notifications';
      default:
        return key.split('.').last.replaceAll('_', ' ').toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getTranslation('prayer.method.title', context),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header Banner Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColorScheme.darken(cs.primary, 0.35), AppColorScheme.darken(cs.primary, 0.42)]
                    : [cs.primary, cs.primaryDeep],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Text(
              _getTranslation('prayer.method.subtitle', context),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),

          // Scrollable list
          const Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _BatteryOptimizationNotice(),
                  _AdhanSoundSelector(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Prompts for the battery-optimization exemption, without which OEM battery
/// managers silently delay or drop the scheduled azan. Hides itself entirely
/// once granted (and on platforms where it doesn't apply).
class _BatteryOptimizationNotice extends ConsumerStatefulWidget {
  const _BatteryOptimizationNotice();

  @override
  ConsumerState<_BatteryOptimizationNotice> createState() =>
      _BatteryOptimizationNoticeState();
}

class _BatteryOptimizationNoticeState
    extends ConsumerState<_BatteryOptimizationNotice>
    with WidgetsBindingObserver {
  bool _isExempt = true; // Assume fine until proven otherwise — never flash.
  bool _canScheduleExact = true;
  bool _isChecking = true;

  bool get _allGood => _isExempt && _canScheduleExact;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Both prompts hand off to a system settings screen, so re-check on return.
    if (state == AppLifecycleState.resumed) {
      _refreshStatus();
    }
  }

  Future<void> _refreshStatus() async {
    final exempt = await BatteryOptimizationService().isExempt();
    final canExact = await PrayerNotificationService().canScheduleExactAlarms();
    if (!mounted) return;
    setState(() {
      _isExempt = exempt;
      _canScheduleExact = canExact;
      _isChecking = false;
    });
  }

  Future<void> _request() async {
    if (!_canScheduleExact) {
      await PrayerNotificationService().requestExactAlarmPermission();
    }
    if (!_isExempt) {
      await BatteryOptimizationService().requestExemption();
    }
    await _refreshStatus();
    // Re-arm the schedule so it upgrades to exact alarms straight away.
    if (mounted && _canScheduleExact) {
      await ref.read(prayerTimesSettingsProvider.notifier).reschedule();
    }
  }

  String _title(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'ku':
        return 'دڵنیابە بانگ لە کاتی خۆیدا دێت';
      case 'ar':
        return 'تأكد من وصول الأذان في وقته';
      default:
        return 'Make sure the azan arrives on time';
    }
  }

  String _body(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'ku':
        return 'ئەم مۆبایلە ڕێگا نادات بانگ بە وردی لە کاتی خۆیدا بێت — '
            'لەوانەیە چەند خولەکێک دوابکەوێت یان هیچ نەیەت. '
            'کرتە بکە بۆ دانی مۆڵەتی پێویست.';
      case 'ar':
        return 'إعدادات هذا الهاتف تمنع وصول الأذان في وقته بدقة — '
            'قد يتأخر دقائق أو لا يصل. اضغط لمنح الأذونات المطلوبة.';
      default:
        return 'This phone is blocking the azan from arriving exactly on time — '
            'it may be minutes late, or not arrive at all. '
            'Tap to grant the required permissions.';
    }
  }

  String _action(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'ku':
        return 'چاککردن';
      case 'ar':
        return 'إصلاح';
      default:
        return 'Fix';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking || _allGood) return const SizedBox.shrink();

    final cs = AppColorScheme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFCD9D27).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCD9D27).withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.battery_alert_rounded, color: Color(0xFFCD9D27), size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(context),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _body(context),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    height: 1.5,
                    color: cs.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ElevatedButton(
                    onPressed: _request,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCD9D27),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _action(context),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _AdhanSoundSelector extends StatefulWidget {
  const _AdhanSoundSelector();

  @override
  State<_AdhanSoundSelector> createState() => _AdhanSoundSelectorState();
}

class _AdhanSoundSelectorState extends State<_AdhanSoundSelector> {
  // Available adhan sounds (filename without extension)
  static const List<AdhanSoundOption> soundOptions = [
    AdhanSoundOption(
      id: 'azan',
      titleKu: 'بانگیستانی بنەڕەتی',
      titleAr: 'الأذان الأساسي',
      titleEn: 'Default Adhan',
      assetName: 'azan', // azan.mp3 in android/raw
    ),
    AdhanSoundOption(
      id: 'azan_makkah',
      titleKu: 'بانگی مەككە',
      titleAr: 'أذان مكة',
      titleEn: 'Mecca Adhan',
      assetName: 'azan_makkah',
    ),
    AdhanSoundOption(
      id: 'azan_medina',
      titleKu: 'بانگی مەدینە',
      titleAr: 'أذان المدينة',
      titleEn: 'Medina Adhan',
      assetName: 'azan_medina',
    ),
    AdhanSoundOption(
      id: 'azan_egypt',
      titleKu: 'بانگی میسر',
      titleAr: 'أذان مصر',
      titleEn: 'Egypt Adhan',
      assetName: 'azan_egypt',
    ),
    AdhanSoundOption(
      id: 'none',
      titleKu: 'بێ دەنگ (تنها نۆتیفیکەیشن)',
      titleAr: 'بدون صوت (إشعار فقط)',
      titleEn: 'No Sound (Notification Only)',
      assetName: '', // Empty = no sound
    ),
  ];

  late final AudioPlayer _audioPlayer;
  String? _currentlyPlayingId;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        if (mounted) {
          setState(() {
            _currentlyPlayingId = null;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPreview(AdhanSoundOption option) async {
    if (option.id == 'none') return;
    
    if (_currentlyPlayingId == option.id) {
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingId = null;
      });
      return;
    }

    try {
      await _audioPlayer.stop();
      // On Android, raw resource is played. In assets/sounds we have the mp3 fallbacks.
      await _audioPlayer.play(AssetSource('sounds/${option.assetName}.mp3'));
      setState(() {
        _currentlyPlayingId = option.id;
      });
    } catch (_) {}
  }

  String _getAdhanSoundTitle(BuildContext context) {
    final isKurdish = Localizations.localeOf(context).languageCode == 'ku';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isKurdish) return 'دەنگی بانگدان';
    if (isArabic) return 'صوت الأذان';
    return 'Adhan Sound';
  }

  String _getSoundTitle(AdhanSoundOption option, BuildContext context) {
    final isKurdish = Localizations.localeOf(context).languageCode == 'ku';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isKurdish) return option.titleKu;
    if (isArabic) return option.titleAr;
    return option.titleEn;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final cs = AppColorScheme.of(context);
        final settingsState = ref.watch(prayerTimesSettingsProvider);
        final currentSound = settingsState.adhanSound;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                _getAdhanSoundTitle(context),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textSecondary,
                ),
              ),
            ),
            Column(
              children: soundOptions.map((option) {
                final isSelected = currentSound == option.id;
                final isPlaying = _currentlyPlayingId == option.id;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? cs.primary.withValues(alpha: 0.08) : cs.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? cs.primary : cs.cardBorder,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    onTap: () {
                      ref.read(prayerTimesSettingsProvider.notifier).changeAdhanSound(option.id);
                    },
                    leading: option.id != 'none'
                        ? IconButton(
                            icon: Icon(
                              isPlaying ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded,
                              color: cs.primary,
                              size: 28,
                            ),
                            onPressed: () => _playPreview(option),
                          )
                        : null,
                    title: Text(
                      _getSoundTitle(option, context),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? cs.primary : cs.textPrimary,
                      ),
                    ),
                    subtitle: option.id == 'none'
                        ? Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              _getNoSoundSubtitle(context),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                height: 1.4,
                                color: cs.textSecondary,
                              ),
                            ),
                          )
                        : null,
                    trailing: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? cs.primary : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? cs.primary : cs.textSecondary.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                ).animate().fadeIn(
                      duration: 300.ms,
                      delay: (soundOptions.indexOf(option) * 50).ms,
                    );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  String _getNoSoundSubtitle(BuildContext context) {
    final isKurdish = Localizations.localeOf(context).languageCode == 'ku';
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isKurdish) return 'تنها نۆتیفیکەیشن پیشان دەدرێت، دەنگ بەردەست نەکات';
    if (isArabic) return 'سيظهر الإشعار فقط بدون صوت';
    return 'Shows notification only, no sound played';
  }
}

class AdhanSoundOption {
  final String id;
  final String titleKu;
  final String titleAr;
  final String titleEn;
  final String assetName; // filename without extension

  const AdhanSoundOption({
    required this.id,
    required this.titleKu,
    required this.titleAr,
    required this.titleEn,
    required this.assetName,
  });
}