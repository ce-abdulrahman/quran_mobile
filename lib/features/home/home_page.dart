import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:home_widget/home_widget.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/banner_model.dart';
import '../../core/utils/responsive.dart';
import '../search/search_page.dart';
import '../quran/quran_page.dart';
import '../quran/quran_reader_page.dart';
import '../bookmarks/bookmarks_page.dart';
import '../favorites/favorites_page.dart';
import '../settings/settings_page.dart';
import '../tracker/reading_tracker_page.dart';
import '../quran/quran_providers.dart';
import '../khatm/khatm_tracker_page.dart';
import '../adhkar/adhkar_page.dart';
import '../tasbih/tasbih_page.dart';
import '../memorization/memorization_quiz_page.dart';
import '../../core/providers/prayer_times_provider.dart';
import '../prayer/prayer_times_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Ad Slide Data
// ─────────────────────────────────────────────────────────────────────────────

class _AdSlide {
  final String titleArabic;
  final String verse;
  final String source;
  final AyahModel? ayah;
  const _AdSlide(this.titleArabic, this.verse, this.source, {this.ayah});
}

const _slides = [
  _AdSlide(
    'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ',
    'ئەم قورئانە ڕێنمایی دەکات بۆ ئەوەی ڕاستترینەوە',
    '— ئیسرا ١٧:٩',
  ),
  _AdSlide(
    'وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ',
    'ئێمە قورئانەکەمان ئاسان کرد بۆ یادەوەری',
    '— القمر ٥٤:١٧',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Category Data
// ─────────────────────────────────────────────────────────────────────────────

class _CatData {
  final IconData icon;
  final Color iconColor;
  final String Function(AppLocalizations) label;
  final VoidCallback Function(WidgetRef, BuildContext) onTap;

  const _CatData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
}

List<_CatData> _buildCats(BuildContext context) => [
      _CatData(
        icon: Icons.menu_book_rounded,
        iconColor: AppColorScheme.of(context).primary,
        label: (l) => l.quranTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const QuranPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.psychology_rounded,
        iconColor: const Color(0xFFCD9D27),
        label: (l) => l.memorizationQuizTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const MemorizationQuizPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.assignment_turned_in_rounded,
        iconColor: const Color(0xFF0F8F4C),
        label: (l) => l.khatmTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const KhatmTrackerPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.wb_sunny_rounded,
        iconColor: const Color(0xFFFF9800),
        label: (l) => l.adhkarTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const AdhkarPage()),
            ),
      ),
      _CatData(
        icon: Icons.fingerprint_rounded,
        iconColor: const Color(0xFF009688),
        label: (l) => l.tasbihTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const TasbihPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.bookmark_rounded,
        iconColor: const Color(0xFF1A3A5C),
        label: (l) => l.navBookmarks,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const BookmarksPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.star_rounded,
        iconColor: const Color(0xFFE6A23C),
        label: (l) => l.navFavorites,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const FavoritesPage(showBackButton: true)),
            ),
      ),
      _CatData(
        icon: Icons.search_rounded,
        iconColor: const Color(0xFF5B1A8A),
        label: (l) => l.searchTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
      ),
      _CatData(
        icon: Icons.settings_rounded,
        iconColor: const Color(0xFF546E7A),
        label: (l) => l.navSettings,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SettingsPage(showBackButton: true)),
            ),
      ),
    ];

// ─────────────────────────────────────────────────────────────────────────────
// HomePage
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  /// Send fallback today's verse to the Android home screen widget
  static Future<void> _updateWidgetDefault() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'widget_arabic_text',
        'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_kurdish_text',
        'ئەم قورئانە ڕێنمایی دەکات بۆ ئەوەی ڕاستترینەوە',
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_surah_name',
        '— ئیسرا ١٧:٩',
      );
      await HomeWidget.updateWidget(
        androidName: 'QuranWidgetProvider',
      );
    } catch (_) {}
  }

  /// Send today's verse to the Android home screen widget
  static Future<void> _updateWidgetWithData(
    String arabicText,
    String kurdishText,
    String surahName,
  ) async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'widget_arabic_text',
        arabicText,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_kurdish_text',
        kurdishText,
      );
      await HomeWidget.saveWidgetData<String>(
        'widget_surah_name',
        surahName,
      );
      await HomeWidget.updateWidget(
        androidName: 'QuranWidgetProvider',
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Responsive.pagePadding(context);

    // Listen to the provider to push updates to the widget dynamically when resolved
    ref.listen<AsyncValue<AyahModel>>(dailyVerseProvider, (previous, next) {
      next.whenData((ayah) {
        _updateWidgetWithData(
          ayah.textUthmani,
          ayah.textKu ?? ayah.textEn ?? '',
          '— ${ayah.surah?.nameEn ?? ""} ${ayah.surah?.number ?? ""}:${ayah.ayahNumber}',
        );
      });
    });

    // Check if daily verse is already loaded and update the widget on build
    final dailyVerse = ref.watch(dailyVerseProvider).value;
    if (dailyVerse != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateWidgetWithData(
          dailyVerse.textUthmani,
          dailyVerse.textKu ?? dailyVerse.textEn ?? '',
          '— ${dailyVerse.surah?.nameEn ?? ""} ${dailyVerse.surah?.number ?? ""}:${dailyVerse.ayahNumber}',
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateWidgetDefault());
    }

    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColorScheme.of(context).bg,
      body: Stack(
        children: [
          // ── Scrollable content area (placed first so it sits behind the header) ──────
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: topPadding + 262,
                bottom: 24,
              ),
              child: Column(
                children: [
                  // ── Daily Goals (authenticated) ──────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 20, p, 0),
                    child: const _StreakBanner(),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  // ── Continue Reading Widget ──────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: const _ContinueReadingCard(),
                  ).animate().fadeIn(duration: 400.ms, delay: 120.ms),

                  // ── Khatm Progress Widget ────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: const _KhatmProgressCard(),
                  ).animate().fadeIn(duration: 400.ms, delay: 140.ms),

                  // ── Prayer Times Countdown Widget ────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 10, p, 0),
                    child: const _PrayerCountdownBanner(),
                  ).animate().fadeIn(duration: 400.ms, delay: 145.ms),

                  // ── Section: تایبەتمەندییەکان ────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 24, p, 12),
                    child: _SectionDivider(
                      title: context.l10n.homeFeatures,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                  // ── Categories grid (scrollable with single scroll) ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 0, p, 0),
                    child: const _CategoriesGrid(),
                  ),
                ],
              ),
            ),
          ),

          // ── Sticky/Fixed top header zone (placed last so it sits on top) ──────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _GreenZone(padding: p),
          ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Green Zone  (appbar + verse banner card + dots)
// ─────────────────────────────────────────────────────────────────────────────

class _GreenZone extends ConsumerStatefulWidget {
  const _GreenZone({required this.padding});
  final double padding;

  @override
  ConsumerState<_GreenZone> createState() => _GreenZoneState();
}

class _GreenZoneState extends ConsumerState<_GreenZone> {
  final _ctrl = PageController();
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final dailyVerseLen = ref.read(dailyVerseProvider).when(
            data: (_) => 1,
            error: (_, __) => 0,
            loading: () => 0,
          );
      final bannersLen = ref.read(bannersProvider).when(
            data: (banners) => banners.isNotEmpty ? banners.length : _slides.length,
            error: (_, __) => _slides.length,
            loading: () => _slides.length,
          );
      final len = dailyVerseLen + bannersLen;
      if (len == 0) return;
      final next = (_page + 1) % len;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.padding;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = AppColorScheme.of(context);

    final AsyncValue<AyahModel> dailyVerseAsync = ref.watch(dailyVerseProvider);
    final AsyncValue<List<BannerModel>> bannersAsync = ref.watch(bannersProvider);

    final List<_AdSlide> activeSlides = [];

    // 1. Add Daily Verse if loaded successfully
    dailyVerseAsync.whenData((ayah) {
      activeSlides.add(_AdSlide(
        ayah.textUthmani,
        ayah.textKu ?? ayah.textEn ?? '',
        '— ${ayah.surah?.nameEn ?? ""} ${ayah.surah?.number ?? ""}:${ayah.ayahNumber}',
        ayah: ayah,
      ));
    });

    // 2. Add dynamic banners or fallback to static ones if empty/loading/error
    bannersAsync.when(
      data: (banners) {
        if (banners.isNotEmpty) {
          for (final b in banners) {
            // Check if this banner has a linked surah/ayah, if so create an AyahModel
            AyahModel? ayahLink;
            if (b.surah != null && b.ayahNumber != null) {
              ayahLink = AyahModel(
                id: 0,
                ayahNumber: b.ayahNumber!,
                textUthmani: b.titleArabic ?? '',
                textKu: b.verse,
                textEn: null,
                surah: b.surah,
              );
            }
            activeSlides.add(_AdSlide(
              b.titleArabic ?? '',
              b.verse,
              b.source ?? '',
              ayah: ayahLink,
            ));
          }
        } else {
          activeSlides.addAll(_slides);
        }
      },
      error: (_, __) {
        activeSlides.addAll(_slides);
      },
      loading: () {
        activeSlides.addAll(_slides);
      },
    );

    // If still empty (e.g. dailyVerse is loading and banners are loading), add default slides as fallback
    if (activeSlides.isEmpty) {
      activeSlides.addAll(_slides);
    }

    // Safeguard page indexing in case activeSlides length changes dynamically
    if (_page >= activeSlides.length) {
      _page = 0;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColorScheme.darken(cs.primary, 0.42),
                  AppColorScheme.darken(cs.primary, 0.35),
                  AppColorScheme.darken(cs.primary, 0.28),
                ]
              : [
                  cs.primaryDeep,
                  cs.primary,
                  AppColorScheme.darken(cs.primary, -0.06),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App bar ────────────────────────────────────────────
            _AppBarRow(padding: p),

            const SizedBox(height: 16),

            // ── Verse banner card ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: p),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColorScheme.of(context).card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: activeSlides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => _VerseSlide(slide: activeSlides[i]),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Dot indicators ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(activeSlides.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // ── Rounded white overlap at bottom ────────────────────
            Container(
              height: 26,
              decoration: BoxDecoration(
                color: AppColorScheme.of(context).bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Bar Row
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarRow extends ConsumerWidget {
  const _AppBarRow({required this.padding});
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 10, padding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Theme toggle — left ──
          GestureDetector(
            onTap: () => ref.read(themeModeProvider.notifier).toggle(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
              child: Icon(
                ref.watch(themeModeProvider) == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: Colors.white.withValues(alpha: 0.9),
                size: 18,
              ),
            ),
          ),

          // ── App name — center ──
          Text(
            l.appName,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),

          // ── Logo badge — right ──
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Verse Slide  (inside white card)
// ─────────────────────────────────────────────────────────────────────────────

class _VerseSlide extends StatelessWidget {
  const _VerseSlide({required this.slide});
  final _AdSlide slide;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        if (slide.ayah != null && slide.ayah!.surah != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => QuranReaderPage(
                surah: slide.ayah!.surah!,
                initialAyahNumber: slide.ayah!.ayahNumber,
              ),
            ),
          );
        }
      },
      child: Container(
        color: cs.card,
        child: Row(
        children: [
          // ── Left: green gradient + verse text ──
          Expanded(
            flex: 55,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColorScheme.darken(cs.primary, 0.42),
                          AppColorScheme.darken(cs.primary, 0.35),
                        ]
                      : [cs.primaryDeep, cs.primary],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ئایەتی ڕۆژ pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('✨', style: TextStyle(fontSize: 9)),
                        const SizedBox(width: 3),
                        Text(
                          context.l10n.homeDailyVerse,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.verse,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.source,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 9,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Right: white + Arabic quran text ──
          Expanded(
            flex: 45,
            child: Container(
              color: cs.card,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle accent
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Arabic Quranic text
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      slide.titleArabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 15,
                        height: 1.8,
                        color: cs.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Divider  ─ ─ ─  Title  ─ ─ ─
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return Row(
      children: [
        Expanded(child: _DashedLine(color: cs.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: cs.textPrimary,
            ),
          ),
        ),
        Expanded(child: _DashedLine(color: cs.divider)),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      const dashW = 5.0;
      const gap = 3.0;
      final count = (constraints.maxWidth / (dashW + gap)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Container(
            width: dashW,
            height: 1.5,
            margin: const EdgeInsets.only(right: gap),
            color: color,
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Prayer Times Countdown Banner
// ─────────────────────────────────────────────────────────────────────────────

class _PrayerCountdownBanner extends ConsumerStatefulWidget {
  const _PrayerCountdownBanner();

  @override
  ConsumerState<_PrayerCountdownBanner> createState() => _PrayerCountdownBannerState();
}

class _PrayerCountdownBannerState extends ConsumerState<_PrayerCountdownBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Refresh countdown every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatRemaining(Duration remaining) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    if (hours > 0) {
      return '$hours کاتژمێر و $minutes خولەک';
    } else {
      return '$minutes خولەک';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    
    final nextInfo = ref.watch(nextPrayerProvider);
    final settings = ref.watch(prayerTimesSettingsProvider);
    
    if (nextInfo == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrayerTimesPage(showBackButton: true)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Next prayer info & remaining time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'نوێژی داهاتوو: ${nextInfo.kurdishName}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatRemaining(nextInfo.remaining)} ماوە بۆ نوێژ',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Mosque/Clock Icon & Location
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      settings.selectedCity.nameKu,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.prayerTimesTitle,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mosque_rounded,
                    size: 20,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Categories Grid  (4 cols phone / 5 cols tablet)
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesGrid extends ConsumerWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = Responsive.isTablet(context);
    final cols = isTablet ? 5 : 3;
    final cats = _buildCats(context);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isTablet ? 0.88 : 0.85,
      ),
      itemBuilder: (context, i) {
        final cat = cats[i];
        return _CatTile(
          icon: cat.icon,
          iconColor: cat.iconColor,
          label: cat.label(context.l10n),
          onTap: cat.onTap(ref, context),
        ).animate().fadeIn(
              duration: 280.ms,
              delay: Duration(milliseconds: 40 * i),
            );
      },
    );
  }
}

class _CatTile extends StatelessWidget {
  const _CatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: iconColor),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: cs.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak Banner  (authenticated only)
// ─────────────────────────────────────────────────────────────────────────────

class _StreakBanner extends ConsumerWidget {
  const _StreakBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(readingTrackerProvider.notifier);
    final streakData = tracker.calculateStreak();
    final currentStreak = streakData['current_streak'] as int? ?? 0;
    final longestStreak = streakData['longest_streak'] as int? ?? 0;
    final todayRead = streakData['today_read'] as bool? ?? false;
    final l = context.l10n;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ReadingTrackerPage(showBackButton: true),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8F00), Color(0xFFFF5722)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.30),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 30)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.homeReadingStreak,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentStreak > 0
                          ? l.homeStreakDaysCount(currentStreak)
                          : l.homeStreakNoActive,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      todayRead
                          ? l.homeStreakTodayDone
                          : l.homeStreakTodayPending,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$longestStreak',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      l.homeStreakLongest,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 8,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Continue Reading Card
// ─────────────────────────────────────────────────────────────────────────────

class _ContinueReadingCard extends ConsumerWidget {
  const _ContinueReadingCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final trackerState = ref.watch(readingTrackerProvider);
    final lastRead = trackerState.lastRead;

    if (lastRead == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: cs.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بەردەوامبە لە خوێندنەوە',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: cs.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'سوورەتی ${lastRead.surahName} - ئایەتی ${lastRead.ayahNumber}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_rounded, color: cs.primary),
            onPressed: () {
              final surahListAsync = ref.read(surahListProvider);
              surahListAsync.whenData((surahs) {
                try {
                  final matchedSurah =
                      surahs.firstWhere((s) => s.id == lastRead.surahId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuranReaderPage(
                        surah: matchedSurah,
                        initialAyahNumber: lastRead.ayahNumber,
                      ),
                    ),
                  );
                } catch (_) {}
              });
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Daily Goals Card
// ─────────────────────────────────────────────────────────────────────────────

class _DailyGoalsCard extends StatefulWidget {
  const _DailyGoalsCard();

  @override
  State<_DailyGoalsCard> createState() => _DailyGoalsCardState();
}

class _DailyGoalsCardState extends State<_DailyGoalsCard> {
  final List<Map<String, dynamic>> _goals = [
    {'key': 'goal1', 'done': true},
    {'key': 'goal2', 'done': true},
    {'key': 'goal3', 'done': false},
    {'key': 'goal4', 'done': false},
  ];

  String _label(AppLocalizations l, String key) {
    switch (key) {
      case 'goal1':
        return l.homeGoal1;
      case 'goal2':
        return l.homeGoal2;
      case 'goal3':
        return l.homeGoal3;
      case 'goal4':
        return l.homeGoal4;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final doneCount = _goals.where((g) => g['done'] == true).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    l.homeDailyGoals,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$doneCount/${_goals.length}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: doneCount / _goals.length,
              minHeight: 5,
              backgroundColor: cs.cardBorder,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),

          const SizedBox(height: 14),

          // Goal items
          ..._goals.map((goal) {
            return GestureDetector(
              onTap: () => setState(() => goal['done'] = !goal['done']),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: goal['done'] ? cs.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: goal['done'] ? cs.primary : cs.cardBorder,
                          width: 1.5,
                        ),
                      ),
                      child: goal['done']
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _label(l, goal['key'] as String),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color:
                              goal['done'] ? cs.textSecondary : cs.textPrimary,
                          decoration:
                              goal['done'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Khatm Progress Card
// ─────────────────────────────────────────────────────────────────────────────

class _KhatmProgressCard extends ConsumerWidget {
  const _KhatmProgressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final activeKhatm = ref.watch(khatmProvider);

    if (activeKhatm == null) {
      return const SizedBox.shrink();
    }

    final trackerState = ref.watch(readingTrackerProvider);
    
    // Unique Ayahs read after the Khatm plan's startDate
    final readAyahsCount = trackerState.history
        .where((h) => h.timestamp.isAfter(activeKhatm.startDate))
        .map((h) => '${h.surahId}-${h.ayahNumber}')
        .toSet()
        .length;

    // Check completion status and update provider if done
    if (!activeKhatm.isCompleted && readAyahsCount >= 6236) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(khatmProvider.notifier).checkCompletion(readAyahsCount);
      });
    }

    final progress = (readAyahsCount / 6236).clamp(0.0, 1.0);
    final progressPct = (progress * 100).round();
    
    final elapsedDays = DateTime.now().difference(activeKhatm.startDate).inDays + 1;
    final remainingDays = (activeKhatm.targetDays - elapsedDays).clamp(0, activeKhatm.targetDays);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const KhatmTrackerPage(showBackButton: true),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6A23C).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.star_rounded,
                      color: Color(0xFFE6A23C),
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeKhatm.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeKhatm.isCompleted
                            ? 'پیرۆزە! بەسەرکەوتوویی تەواو بوو 🎉'
                            : '$remainingDays ڕۆژ ماوە لە ${activeKhatm.targetDays}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$progressPct%',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: cs.cardBorder,
                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
