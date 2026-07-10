import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/tasbih_theme_model.dart';
import '../../../core/providers/tasbih_theme_provider.dart';
import 'theme_preview_overlay.dart';

class ThemeSelectorPage extends ConsumerWidget {
  const ThemeSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(tasbihThemeProvider);
    final themeNotifier = ref.read(tasbihThemeProvider.notifier);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          languageCode == 'ku' ? 'ڕووکارەکانی تەسبیح' : (languageCode == 'ar' ? 'ثيمات التسبيح' : 'Tasbih Themes'),
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          if (themeState.isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: themeState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFffd700)),
              ),
            )
          : DefaultTabController(
              length: themeState.categories.length,
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    indicatorColor: const Color(0xFFffd700),
                    labelColor: const Color(0xFFffd700),
                    unselectedLabelColor: Colors.white60,
                    tabs: themeState.categories.map((cat) {
                      return Tab(
                        child: Row(
                          children: [
                            Icon(_getCategoryIcon(cat.icon), size: 16),
                            const SizedBox(width: 8),
                            Text(_t(cat.name, languageCode), style: const TextStyle(fontFamily: 'Cairo')),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: themeState.categories.map((cat) {
                        return _buildThemeGrid(context, cat.themes, themeNotifier, themeState, languageCode);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  IconData _getCategoryIcon(String iconClass) {
    switch (iconClass) {
      case 'bi bi-moon-stars-fill':
        return Icons.brightness_3;
      case 'bi bi-tree-fill':
        return Icons.park;
      case 'bi bi-circle-half':
        return Icons.tonality;
      case 'bi bi-star-fill':
        return Icons.grade;
      case 'bi bi-cloud-sun-fill':
        return Icons.filter_drama;
      default:
        return Icons.palette;
    }
  }

  Widget _buildThemeGrid(
    BuildContext context,
    List<TasbihThemeModel> themes,
    TasbihThemeNotifier themeNotifier,
    TasbihThemeState themeState,
    String languageCode,
  ) {
    if (themes.isEmpty) {
      return Center(
        child: Text(
          languageCode == 'ku'
              ? 'هیچ ڕووکارێک لەم پۆلەدا بەردەست نییە'
              : (languageCode == 'ar' ? 'لا توجد ثيمات متوفرة في هذا القسم' : 'No themes available in this category'),
          style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.72,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        return _buildThemeCard(context, theme, themeNotifier, themeState, languageCode);
      },
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    TasbihThemeModel theme,
    TasbihThemeNotifier themeNotifier,
    TasbihThemeState themeState,
    String languageCode,
  ) {
    final isActive = themeState.activeTheme?.themeKey == theme.themeKey;

    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: isActive ? const Color(0xFFffd700) : Colors.transparent,
          width: 2.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview / Thumbnail Block
              Expanded(
                child: Container(
                  color: Colors.black26,
                  child: theme.thumbnail != null
                      ? Image.network(
                          theme.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildMockThumbnail(theme),
                        )
                      : _buildMockThumbnail(theme),
                ),
              ),
              // Name & Category metadata
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(theme.name, languageCode),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _t(theme.description, languageCode),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11.0,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Actions (Apply / Preview)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (!theme.isUnlocked) {
                                _showUnlockPrompt(context, theme, languageCode);
                              } else {
                                themeNotifier.applyTheme(theme);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isActive
                                  ? const Color(0xFFffd700)
                                  : (theme.isUnlocked
                                      ? Colors.white24
                                      : Colors.amber.shade900),
                              foregroundColor: isActive ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            child: Text(
                              isActive
                                  ? (languageCode == 'ku' ? 'جێبەجێکراوە' : (languageCode == 'ar' ? 'مطبق' : 'Applied'))
                                  : (theme.isUnlocked
                                      ? (languageCode == 'ku' ? 'جێبەجێ بکە' : (languageCode == 'ar' ? 'تطبيق' : 'Apply'))
                                      : (languageCode == 'ku' ? 'بیکەرەوە' : (languageCode == 'ar' ? 'فتح القفل' : 'Unlock'))),
                              style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined, size: 20),
                          color: Colors.white70,
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (context, _, __) =>
                                    ThemePreviewOverlay(theme: theme),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Badges / Favorites
          Positioned(
            top: 8,
            left: 8,
            child: _buildBadge(theme, languageCode),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(
                theme.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: theme.isFavorite ? Colors.red : Colors.white70,
              ),
              onPressed: () => themeNotifier.toggleFavorite(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockThumbnail(TasbihThemeModel theme) {
    // Elegant fallback based on theme key configurations
    final color = _getThemeColor(theme.themeKey);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.8), color.withOpacity(0.3)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.palette_outlined, color: Colors.white70, size: 36),
            const SizedBox(height: 8),
            Text(
              theme.themeKey.toUpperCase().replaceAll('_', ' '),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThemeColor(String key) {
    if (key.contains('kaaba')) return const Color(0xFFffd700);
    if (key.contains('madinah')) return const Color(0xFF2e7d32);
    if (key.contains('minimal')) return const Color(0xFF333333);
    if (key.contains('forest')) return const Color(0xFF1b3d2f);
    if (key.contains('ramadan')) return const Color(0xFFffb300);
    return Colors.blueGrey;
  }

  Widget _buildBadge(TasbihThemeModel theme, String languageCode) {
    if (theme.isFeatured) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.shade800,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          languageCode == 'ku' ? 'دیار' : (languageCode == 'ar' ? 'مميز' : 'FEATURED'),
          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
      );
    }
    if (theme.unlockType == 'premium') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.purple.shade700,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          languageCode == 'ku' ? 'نایاب' : (languageCode == 'ar' ? 'بريميوم' : 'PREMIUM'),
          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _showUnlockPrompt(BuildContext context, TasbihThemeModel theme, String languageCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            languageCode == 'ku'
                ? 'کردنەوەی ${_t(theme.name, languageCode)}'
                : (languageCode == 'ar' ? 'فتح قفل ${_t(theme.name, languageCode)}' : 'Unlock ${theme.name}'),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
          content: Text(
            theme.unlockType == 'points'
                ? (languageCode == 'ku'
                    ? 'ئەم ڕووکارە پێویستی بە ${theme.unlockValue} خاڵ هەیە بۆ کردنەوە.'
                    : (languageCode == 'ar' ? 'هذا الثيم يتطلب ${theme.unlockValue} نقطة لفتحه.' : 'This theme requires ${theme.unlockValue} points to unlock.'))
                : (theme.unlockType == 'streak'
                    ? (languageCode == 'ku'
                        ? 'بگە بە بەردەوامیی ${theme.unlockValue} ڕۆژ لە تەسبیح بۆ کردنەوەی ئەم ڕووکارە.'
                        : (languageCode == 'ar' ? 'تطلب تحقيق سلسلة تسبيح لمدة ${theme.unlockValue} أيام لفتح هذا الثيم.' : 'Reach a ${theme.unlockValue}-day Tasbih streak to unlock this theme.'))
                    : (languageCode == 'ku'
                        ? 'پێویستی بە پێشکەوتنی چالاکییەکان هەیە بۆ کردنەوە.'
                        : (languageCode == 'ar' ? 'يتطلب إحراز تقدم في الفعاليات لفتحه.' : 'Requires event/achievement progress to unlock.'))),
            style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo', fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                languageCode == 'ku' ? 'پاشگەزبوونەوە' : (languageCode == 'ar' ? 'إلغاء' : 'Cancel'),
                style: const TextStyle(color: Colors.white54, fontFamily: 'Cairo'),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFffd700)),
              child: Text(
                languageCode == 'ku' ? 'باشە' : (languageCode == 'ar' ? 'موافق' : 'Okay'),
                style: const TextStyle(color: Colors.black, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  String _t(String text, String lang) {
    if (lang == 'en') return text;

    final translations = {
      // Categories
      'Islamic Themes': {
        'ku': 'ڕووکارە ئیسلامییەکان',
        'ar': 'الثيمات الإسلامية',
      },
      'Minimal Themes': {
        'ku': 'ڕووکارە سادەکان',
        'ar': 'الثيمات البسيطة',
      },
      'Nature Themes': {
        'ku': 'ڕووکارەکانی سروشت',
        'ar': 'ثيمات الطبيعة',
      },
      'Special Themes': {
        'ku': 'ڕووکارە تایبەتەکان',
        'ar': 'الثيمات الخاصة',
      },
      'Vibrant Themes': {
        'ku': 'ڕووکارە ڕەنگاوڕەنگەکان',
        'ar': 'الثيمات الحيوية',
      },
      'Islamic': {
        'ku': 'ئیسلامی',
        'ar': 'إسلامي',
      },
      'Minimal': {
        'ku': 'سادە',
        'ar': 'بسيط',
      },
      'Nature': {
        'ku': 'سروشت',
        'ar': 'طبيعة',
      },
      'Special': {
        'ku': 'تایبەت',
        'ar': 'خاص',
      },
      'Vibrant': {
        'ku': 'حيوي',
        'ar': 'حيوي',
      },

      // Theme Names
      'Kaaba Holy Sanctuary': {
        'ku': 'حەرەمی پیرۆزی کەعبە',
        'ar': 'حرم الكعبة المشرفة',
      },
      'Al-Masjid an-Nabawi': {
        'ku': 'مەسجدی نەبەوی',
        'ar': 'المسجد النبوي الشريف',
      },
      'Carbon Minimal': {
        'ku': 'کاربۆنی سادە',
        'ar': 'الكربون البسيط',
      },
      'Forest Gold': {
        'ku': 'ئاڵتوونی دارستان',
        'ar': 'ذهبي الغابة',
      },
      'Desert Rose': {
        'ku': 'گوڵی بیابان',
        'ar': 'وردة الصحراء',
      },
      'Ramadan Lantern': {
        'ku': 'فانۆسی ڕەمەزان',
        'ar': 'فانوس رمضان',
      },
      'Ocean Mist': {
        'ku': 'تەمومژی دەریا',
        'ar': 'ضباب المحيط',
      },
      'Sunset Glow': {
        'ku': 'شەبەقی خۆرئاوا',
        'ar': 'توهج الغروب',
      },
      'Aurora Sky': {
        'ku': 'ئاسمانی ئاورۆرا',
        'ar': 'سماء الشفق القطبي',
      },
      'Royal Velvet': {
        'ku': 'مەخمەلی شاهانە',
        'ar': 'المخمل الملكي',
      },

      // Theme Descriptions
      'Depicting the Holy Kaaba with gold and black accents.': {
        'ku': 'نیشاندانی کەعبەی پیرۆز بە ڕەنگەکانی ڕەش و ئاڵتوونی.',
        'ar': 'تصوير الكعبة المشرفة باللونين الأسود والذهبي.',
      },
      'Reflecting the peace and light of Madinah.': {
        'ku': 'ڕەنگدانەوەی ئارامی و ڕووناکی شاری مەدینە.',
        'ar': 'يعكس الطمأنينة والنور لمدينة المدينة المنورة.',
      },
      'Pure distraction-free dark theme.': {
        'ku': 'ڕووکارێکی تاریک و سادە بەبێ تێکدانی سەرنج.',
        'ar': 'ثيم داكن بسيط وخالٍ من المشتتات.',
      },
      'Calming green and gold elements.': {
        'ku': 'عەناسیری ئارامکەرەوە بە ڕەنگەکانی سەوز و ئاڵتوونی.',
        'ar': 'عناصر مهدئة باللونين الأخضر والذهبي.',
      },
      'Soft tones of the desert.': {
        'ku': 'ڕەنگە نەرمەکانی بیابان.',
        'ar': 'ألوان هادئة مستوحاة من الصحراء.',
      },
      'Traditional ramadan lamp glow.': {
        'ku': 'ڕووناکی فانۆسی ڕەمەزانی ڕەسەن.',
        'ar': 'توهج فانوس رمضان التقليدي.',
      },
      'Serene ocean blue tones.': {
        'ku': 'ڕەنگە ئارامەکانی شینی دەریا.',
        'ar': 'ألوان زرقاء هادئة مثل المحيط.',
      },
      'Warm orange sunset gradients.': {
        'ku': 'تێکەڵەی ڕەنگە گەرمەکانی خۆرئاوابوون.',
        'ar': 'تدرجات ألوان الغروب البرتقالية الدافئة.',
      },
      'Enchanting green auroral lights.': {
        'ku': 'ڕووناکی ئەفسوناوی سەوزی ئاورۆرا.',
        'ar': 'أضواء الشفق القطبي الخضراء الساحرة.',
      },
      'Deep violet velvet colors.': {
        'ku': 'ڕەنگە تێرەکانی مەخمەلی شاهانە.',
        'ar': 'ألوان المخمل البنفسجية العميقة.',
      },
    };

    // Try exact match
    final translationsForText = translations[text];
    if (translationsForText != null) {
      final localizedText = translationsForText[lang];
      if (localizedText != null) return localizedText;
    }

    // Try substring matching
    for (final key in translations.keys) {
      if (text.toLowerCase().contains(key.toLowerCase())) {
        final localizedText = translations[key]?[lang];
        if (localizedText != null) return localizedText;
      }
    }

    return text;
  }
}
