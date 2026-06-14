import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/fingerprint_provider.dart';
import '../../../core/models/fingerprint_settings_model.dart';

class FingerprintSettingsDialog extends ConsumerStatefulWidget {
  const FingerprintSettingsDialog({super.key});

  @override
  ConsumerState<FingerprintSettingsDialog> createState() => _FingerprintSettingsDialogState();
}

class _FingerprintSettingsDialogState extends ConsumerState<FingerprintSettingsDialog> {
  late String _countMode;
  late int _holdInterval;
  late String _hapticProfile;
  late int _customHapticMs;
  late String _audioProfile;
  late bool _blindMode;
  late bool _focusMode;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(fingerprintProvider).settings;
    _countMode = settings.countMode;
    _holdInterval = settings.holdIntervalSeconds;
    _hapticProfile = settings.hapticProfile;
    _customHapticMs = settings.customHapticVibrationMs;
    _audioProfile = settings.audioProfile;
    _blindMode = settings.blindMode;
    _focusMode = settings.focusMode;
  }

  String _tr(String key, String fallback) {
    final locale = Localizations.localeOf(context).languageCode;
    return FingerprintL10n.translate(key, locale, fallback);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(Icons.fingerprint, color: primaryColor, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _tr('title', 'ڕێکخستنی مۆدی پەنجەمۆر'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Settings Items
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Counting Mode
                    Text(
                      _tr('count_mode', 'شێوازی ژماردن'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _countMode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).dividerColor.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'single_touch',
                          child: Text(_tr('single_touch', 'یەک لێدان (+١)')),
                        ),
                        DropdownMenuItem(
                          value: 'hold_to_count',
                          child: Text(_tr('hold_to_count', 'دەست پێوەگرتن (خۆکار)')),
                        ),
                        DropdownMenuItem(
                          value: 'continuous',
                          child: Text(_tr('continuous', 'مۆدی بەردەوام')),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _countMode = val;
                          });
                        }
                      },
                    ),

                    if (_countMode == 'hold_to_count') ...[
                      const SizedBox(height: 16),
                      Text(
                        _tr('hold_interval', 'ماوەی خۆکار (چرکە)'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        value: _holdInterval,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).dividerColor.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('1 chirkە (1s)')),
                          DropdownMenuItem(value: 2, child: Text('2 chirkە (2s)')),
                          DropdownMenuItem(value: 3, child: Text('3 chirkە (3s)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _holdInterval = val;
                            });
                          }
                        },
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Haptic profile
                    Text(
                      _tr('haptic_profile', 'پڕۆفایلی لەرینەوە (Haptic)'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _hapticProfile,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).dividerColor.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      items: [
                        DropdownMenuItem(value: 'light', child: Text(_tr('light', 'سووک'))),
                        DropdownMenuItem(value: 'normal', child: Text(_tr('normal', 'ئاسایی'))),
                        DropdownMenuItem(value: 'strong', child: Text(_tr('strong', 'بەهێز'))),
                        DropdownMenuItem(value: 'custom', child: Text(_tr('custom', 'تایبەت'))),
                        DropdownMenuItem(value: 'disabled', child: Text(_tr('disabled', 'ناچالاک'))),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _hapticProfile = val;
                          });
                        }
                      },
                    ),

                    if (_hapticProfile == 'custom') ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_tr('vibration_duration', 'ماوەی لەرینەوە')),
                          Text('${_customHapticMs}ms', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: _customHapticMs.toDouble(),
                        min: 10,
                        max: 200,
                        divisions: 19,
                        activeColor: primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _customHapticMs = val.toInt();
                          });
                        },
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Audio profile
                    Text(
                      _tr('audio_profile', 'کارتێکەری دەنگی'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _audioProfile,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).dividerColor.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      items: [
                        DropdownMenuItem(value: 'soft_click', child: Text(_tr('soft_click', 'کلیکی نەرم'))),
                        DropdownMenuItem(value: 'tasbih_bead', child: Text(_tr('tasbih_bead', 'مورووی تەسبیح'))),
                        DropdownMenuItem(value: 'water_drop', child: Text(_tr('water_drop', 'دڵۆپە ئاو'))),
                        DropdownMenuItem(value: 'silent', child: Text(_tr('silent', 'بێدەنگ'))),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _audioProfile = val;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Blind mode toggle
                    SwitchListTile(
                      value: _blindMode,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _tr('blind_mode', 'تەسبیحی کوێر (بێ شاشە)'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        _tr('blind_mode_desc', 'شاردنەوەی ژمارەکان بۆ زیادکردنی خشوع.'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _blindMode = val;
                        });
                      },
                    ),

                    // Focus mode toggle
                    SwitchListTile(
                      value: _focusMode,
                      activeColor: primaryColor,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _tr('focus_mode', 'مۆدی سەرنجدان (Fullscreen)'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        _tr('focus_mode_desc', 'شاشەی تەواو بێ دوگمەی زیادە.'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _focusMode = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    final newSettings = FingerprintSettingsModel(
                      id: ref.read(fingerprintProvider).settings.id,
                      countMode: _countMode,
                      holdIntervalSeconds: _holdInterval,
                      hapticProfile: _hapticProfile,
                      customHapticVibrationMs: _customHapticMs,
                      audioProfile: _audioProfile,
                      blindMode: _blindMode,
                      focusMode: _focusMode,
                    );
                    ref.read(fingerprintProvider.notifier).updateSettings(newSettings);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    _tr('save', 'پاشکەوتکردن'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FingerprintL10n {
  static String translate(String key, String locale, String fallback) {
    final Map<String, Map<String, String>> dict = {
      'title': {
        'ku': 'ڕێکخستنی مۆدی پەنجەمۆر',
        'ar': 'إعدادات وضع البصمة',
        'en': 'Fingerprint Mode Settings',
      },
      'count_mode': {
        'ku': 'شێوازی ژماردن',
        'ar': 'طريقة العد',
        'en': 'Counting Mode',
      },
      'single_touch': {
        'ku': 'یەک لێدان (+١)',
        'ar': 'نقرة واحدة (+١)',
        'en': 'Single Touch (+1)',
      },
      'hold_to_count': {
        'ku': 'دەست پێوەگرتن (خۆکار)',
        'ar': 'الضغط المستمر (تلقائي)',
        'en': 'Hold to Count (Auto)',
      },
      'continuous': {
        'ku': 'مۆدی بەردەوام',
        'ar': 'الوضع المستمر',
        'en': 'Continuous Mode',
      },
      'hold_interval': {
        'ku': 'ماوەی خۆکار (چرکە)',
        'ar': 'الفاصل التلقائي (ثواني)',
        'en': 'Auto Interval (seconds)',
      },
      'haptic_profile': {
        'ku': 'پڕۆفایلی لەرینەوە (Haptic)',
        'ar': 'نمط الاهتزاز',
        'en': 'Haptic Profile',
      },
      'light': {
        'ku': 'سووک',
        'ar': 'خفيف',
        'en': 'Light',
      },
      'normal': {
        'ku': 'ئاسایی',
        'ar': 'عادي',
        'en': 'Normal',
      },
      'strong': {
        'ku': 'بەهێز',
        'ar': 'قوي',
        'en': 'Strong',
      },
      'custom': {
        'ku': 'تایبەت',
        'ar': 'مخصص',
        'en': 'Custom',
      },
      'disabled': {
        'ku': 'ناچالاک',
        'ar': 'معطل',
        'en': 'Disabled',
      },
      'audio_profile': {
        'ku': 'کارتێکەری دەنگی',
        'ar': 'المؤثرات الصوتية',
        'en': 'Audio Feedback',
      },
      'soft_click': {
        'ku': 'کلیکی نەرم',
        'ar': 'نقرة ناعمة',
        'en': 'Soft Click',
      },
      'tasbih_bead': {
        'ku': 'مورووی تەسبیح',
        'ar': 'خرز التسبيح',
        'en': 'Tasbih Bead',
      },
      'water_drop': {
        'ku': 'دڵۆپە ئاو',
        'ar': 'قطرة ماء',
        'en': 'Water Drop',
      },
      'silent': {
        'ku': 'بێدەنگ',
        'ar': 'صامت',
        'en': 'Silent',
      },
      'blind_mode': {
        'ku': 'تەسبیحی کوێر (بێ شاشە)',
        'ar': 'التسبيح المغلق (الأعمى)',
        'en': 'Blind Tasbih Mode',
      },
      'blind_mode_desc': {
        'ku': 'شاردنەوەی سەرجەم زانیارییەکان بۆ زیادکردنی خشوع.',
        'ar': 'إخفاء كافة الأرقام والإحصائيات لزيادة الخشوع والتركيز.',
        'en': 'Hides numbers and progress indicators to maximize focus.',
      },
      'focus_mode': {
        'ku': 'مۆدی سەرنجدان (Fullscreen)',
        'ar': 'وضع التركيز (شاشة كاملة)',
        'en': 'Focus Mode (Fullscreen)',
      },
      'focus_mode_desc': {
        'ku': 'شاشەی تەواو بێ هێڵ و دوگمەی زیادە.',
        'ar': 'شاشة كاملة خالية من الأزرار والقوائم المشتتة للانتباه.',
        'en': 'Fullscreen layout without menus or analytics overlays.',
      },
      'save': {
        'ku': 'پاشکەوتکردن',
        'ar': 'حفظ التغييرات',
        'en': 'Save Settings',
      },
      'vibration_duration': {
        'ku': 'ماوەی لەرینەوە (میلی چرکە)',
        'ar': 'مدة الاهتزاز (ملي ثانية)',
        'en': 'Vibration Duration (ms)',
      }
    };
 
    final lang = ['ku', 'ar', 'en'].contains(locale) ? locale : 'ku';
    return dict[key]?[lang] ?? fallback;
  }
}
