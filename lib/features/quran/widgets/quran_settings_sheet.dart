import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/surah_model.dart';
import '../../../core/models/juz_model.dart';
import '../../../core/providers/app_providers.dart';
import '../quran_providers.dart';
import '../../tajweed/tajweed_page.dart';
import '../quran_reader_page.dart';
import '../mushaf_reader_page.dart';

class QuranSettingsSheet extends ConsumerStatefulWidget {
  final int surahId;
  final int? currentPage;
  final bool isMushaf;
  final int initialIndex;
  final ValueChanged<int>? onJumpToPage;
  final ValueChanged<int>? onJumpToAyah;
  final ValueChanged<SurahModel>? onJumpToSurah;

  const QuranSettingsSheet({
    super.key,
    required this.surahId,
    this.currentPage,
    required this.isMushaf,
    this.initialIndex = 0,
    this.onJumpToPage,
    this.onJumpToAyah,
    this.onJumpToSurah,
  });

  static void show(
    BuildContext context, {
    required int surahId,
    int? currentPage,
    required bool isMushaf,
    int initialIndex = 0,
    ValueChanged<int>? onJumpToPage,
    ValueChanged<int>? onJumpToAyah,
    ValueChanged<SurahModel>? onJumpToSurah,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.45,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppThemeTokens.r28),
            topRight: Radius.circular(AppThemeTokens.r28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: QuranSettingsSheet(
              surahId: surahId,
              currentPage: currentPage,
              isMushaf: isMushaf,
              initialIndex: initialIndex,
              onJumpToPage: onJumpToPage,
              onJumpToAyah: onJumpToAyah,
              onJumpToSurah: onJumpToSurah,
            ),
          ),
        ),
      ),
    );
  }

  @override
  ConsumerState<QuranSettingsSheet> createState() => _QuranSettingsSheetState();
}

class _QuranSettingsSheetState extends ConsumerState<QuranSettingsSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeNavSubTab = 0; // 0: Juz, 1: Surah, 2: Page
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final cs = AppColorScheme.of(context, settings.bgMode);
    final isDark = settings.bgMode == 'dark' ||
        (settings.bgMode == 'default' && Theme.of(context).brightness == Brightness.dark);

    return Container(
      decoration: BoxDecoration(
        color: cs.card.withValues(alpha: isDark ? 0.88 : 0.94),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppThemeTokens.r28),
          topRight: Radius.circular(AppThemeTokens.r28),
        ),
        border: Border.all(color: cs.cardBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: cs.textSecondary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(AppThemeTokens.r12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header Title
          Text(
            'ڕێکخستنەکانی قورئان',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Custom TabBar Segment Control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppThemeTokens.s16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F1F18) : const Color(0xFFE8ECE7),
                borderRadius: BorderRadius.circular(AppThemeTokens.r16),
                border: Border.all(color: cs.cardBorder, width: 1),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: isDark ? Colors.white : cs.primaryDeep,
                unselectedLabelColor: cs.textSecondary,
                indicator: BoxDecoration(
                  color: isDark ? cs.primary : Colors.white,
                  borderRadius: BorderRadius.circular(AppThemeTokens.r12),
                  boxShadow: !isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                tabs: [
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.menu_book_rounded, size: 16),
                          const SizedBox(width: 4),
                          Text(context.l10n.tabReading, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.palette_rounded, size: 16),
                          const SizedBox(width: 4),
                          Text(context.l10n.tabColor, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_up_rounded, size: 16),
                          const SizedBox(width: 4),
                          Text(context.l10n.tabAudio, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.explore_rounded, size: 16),
                          const SizedBox(width: 4),
                          Text(context.l10n.tabNavigation, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // TabBar View content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReadingTab(context, settings, cs),
                _buildAppearanceTab(context, settings, cs, isDark),
                _buildAudioTab(context, cs, isDark),
                _buildNavigationTab(context, cs, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab 1: Reading Settings ──────────────────────────────────────────────
  Widget _buildReadingTab(BuildContext context, ReaderSettings settings, AppColorScheme cs) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppThemeTokens.s20, vertical: AppThemeTokens.s8),
      physics: const BouncingScrollPhysics(),
      children: [
        // Font Size or Page Zoom Slider
        if (widget.isMushaf) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'گەورەکردنی لاپەڕە',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
              Text(
                '${ref.watch(mushafZoomProvider).toStringAsFixed(1)}x',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: ref.watch(mushafZoomProvider),
            min: 1.0,
            max: 3.0,
            divisions: 20,
            activeColor: cs.primary,
            inactiveColor: cs.primary.withValues(alpha: 0.15),
            onChanged: (v) => ref.read(mushafZoomProvider.notifier).setZoom(v),
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'قەبارەی فۆنت',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
              Text(
                '${settings.fontSize.round()}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: settings.fontSize,
            min: 12,
            max: 40,
            divisions: 28,
            activeColor: cs.primary,
            inactiveColor: cs.primary.withValues(alpha: 0.15),
            onChanged: (v) => ref.read(readerSettingsProvider.notifier).setFontSize(v),
          ),
        ],
        const SizedBox(height: 8),

        // Line Spacing (Line Height)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'دووری نێوان دێڕەکان',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
              ),
            ),
            Text(
              '${settings.lineHeight.toStringAsFixed(1)}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ],
        ),
        Slider(
          value: settings.lineHeight,
          min: 1.5,
          max: 3.5,
          divisions: 20,
          activeColor: cs.primary,
          inactiveColor: cs.primary.withValues(alpha: 0.15),
          onChanged: (v) => ref.read(readerSettingsProvider.notifier).setLineHeight(v),
        ),
        const SizedBox(height: 8),

        Divider(color: cs.divider),

        // Kurdish Translation Switch
        _buildSwitchRow(
          icon: Icons.translate_rounded,
          title: 'وەرگێڕانی کوردی',
          value: settings.showKurdish,
          cs: cs,
          onChanged: (v) => ref.read(readerSettingsProvider.notifier).toggleKurdish(v),
        ),

        // English Translation Switch
        _buildSwitchRow(
          icon: Icons.language_rounded,
          title: 'وەرگێڕانی ئینگلیزی',
          value: settings.showEnglish,
          cs: cs,
          onChanged: (v) => ref.read(readerSettingsProvider.notifier).toggleEnglish(v),
        ),

        // Tajweed Switch — with active badge when ON
        _buildTajweedSwitchRow(
          value: settings.showTajweed,
          cs: cs,
          onChanged: (v) {
            ref.read(readerSettingsProvider.notifier).toggleTajweed(v);
          },
        ),

        // Font lock notice — shown when Tajweed is active (non-Mushaf only)
        if (!widget.isMushaf && settings.showTajweed)
          Container(
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_rounded, color: Colors.amber, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'فۆنتی قورئان قفڵکراوە. دەبێت تەجوید ناچالاک بکەیت بۆ گۆڕینی فۆنت.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: Colors.amber[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Tajweed Rules Manager Button
        AnimatedSize(
          duration: AppThemeTokens.d250,
          curve: Curves.easeInOut,
          child: settings.showTajweed
              ? Padding(
                  padding: const EdgeInsets.only(top: AppThemeTokens.s8, bottom: AppThemeTokens.s12),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final inactiveRules = ref.watch(inactiveTajweedRulesProvider);
                      final activeCount = inactiveRules.isEmpty ? null : inactiveRules.length;
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context); // Close bottom sheet
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TajweedPage()),
                          );
                        },
                        borderRadius: BorderRadius.circular(AppThemeTokens.r12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppThemeTokens.s16, vertical: AppThemeTokens.s12),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(AppThemeTokens.r12),
                            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.tune_rounded, color: cs.primary, size: 20),
                              const SizedBox(width: AppThemeTokens.s12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'بەڕێوەبردنی یاساکانی تەجوید',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: cs.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      activeCount == null ? 'هەموو یاساکان چالاکن' : '$activeCount یاسا ناچالاکە',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 10,
                                        color: activeCount == null ? cs.textSecondary : Colors.amber[800],
                                        fontWeight: activeCount == null ? FontWeight.normal : FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded, color: cs.primary.withValues(alpha: 0.7), size: 14),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),

        // Distraction Free Switch
        _buildSwitchRow(
          icon: Icons.visibility_off_rounded,
          title: 'مۆدی بێ سەرنجپەرتبوون',
          value: settings.distractionFree,
          cs: cs,
          onChanged: (v) => ref.read(readerSettingsProvider.notifier).toggleDistractionFree(v),
        ),
      ],
    );
  }

  // ── Tab 2: Appearance Themes ─────────────────────────────────────────────
  Widget _buildAppearanceTab(BuildContext context, ReaderSettings settings, AppColorScheme cs, bool isDark) {
    final themes = [
      (mode: 'default', label: 'سروشتی ئەپ', desc: 'بەگوێرەی سیستەم', bg: const Color(0xFFF5F7F5), border: const Color(0xFFE2E8E1), text: const Color(0xFF1F2937)),
      (mode: 'cream', label: 'کرێم (خوێندنەوە)', desc: 'کارتە ڕوونەکان', bg: const Color(0xFFF5EFEB), border: const Color(0xFFEDE5DF), text: const Color(0xFF2E2B2A)),
      (mode: 'khaki', label: 'کاکی (تایبەت)', desc: 'تۆنی لاپەڕە', bg: const Color(0xFFEDEADF), border: const Color(0xFFDFDACB), text: const Color(0xFF2C2A24)),
      (mode: 'dark', label: 'تاریک', desc: 'بۆ شەو و تاریکی', bg: const Color(0xFF09120D), border: const Color(0xFF183126), text: const Color(0xFFE6F3E8)),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(AppThemeTokens.s20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final t = themes[index];
        final active = settings.bgMode == t.mode;
        return InkWell(
          onTap: () => ref.read(readerSettingsProvider.notifier).setBgMode(t.mode),
          borderRadius: BorderRadius.circular(AppThemeTokens.r16),
          child: AnimatedContainer(
            duration: AppThemeTokens.d250,
            decoration: BoxDecoration(
              color: t.bg,
              borderRadius: BorderRadius.circular(AppThemeTokens.r16),
              border: Border.all(
                color: active ? cs.primary : t.border,
                width: active ? 2.2 : 1.2,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppThemeTokens.s12, vertical: AppThemeTokens.s14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.label,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: t.text,
                      ),
                    ),
                    if (active)
                      Icon(Icons.check_circle_rounded, color: cs.primary, size: 18)
                    else
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: t.text.withValues(alpha: 0.3), width: 1.5),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  t.desc,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    color: t.text.withValues(alpha: 0.6),
                  ),
                ),
                const Spacer(),
                // Micro page preview inside container
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 5,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 14,
                      height: 5,
                      decoration: BoxDecoration(
                        color: t.text.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Tab 3: Audio Settings ────────────────────────────────────────────────
  Widget _buildAudioTab(BuildContext context, AppColorScheme cs, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_off_rounded,
              size: 54,
              color: cs.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'ئەم تایبەتمەندییە کارا نییە',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'بەشی دەنگ و خوێندنەوە لە ئێستادا بەردەست نییە بۆ ئەم چاپە.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: cs.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 4: Navigation / Jump Settings ──────────────────────────────────────
  Widget _buildNavigationTab(BuildContext context, AppColorScheme cs, bool isDark) {
    return Column(
      children: [
        // Selector Buttons: Juz / Surah / Page
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppThemeTokens.s20, vertical: AppThemeTokens.s8),
          child: Row(
            children: [
              _navPill(0, 'جزء', cs),
              const SizedBox(width: 8),
              _navPill(1, 'سورەت', cs),
              const SizedBox(width: 8),
              _navPill(2, 'لاپەڕە', cs),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Tab Content
        Expanded(
          child: Container(
            color: cs.bg.withValues(alpha: 0.4),
            child: _buildActiveNavContent(cs, isDark),
          ),
        ),
      ],
    );
  }

  Widget _navPill(int index, String label, AppColorScheme cs) {
    final active = _activeNavSubTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeNavSubTab = index),
        borderRadius: BorderRadius.circular(AppThemeTokens.r10),
        child: AnimatedContainer(
          duration: AppThemeTokens.d150,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.card,
            borderRadius: BorderRadius.circular(AppThemeTokens.r10),
            border: Border.all(color: active ? cs.primary : cs.cardBorder),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : cs.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveNavContent(AppColorScheme cs, bool isDark) {
    if (_activeNavSubTab == 0) {
      // Juz Grid 1-30
      final juzs = JuzModel.list;
      return GridView.builder(
        padding: const EdgeInsets.all(AppThemeTokens.s16),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: juzs.length,
        itemBuilder: (context, idx) {
          final juz = juzs[idx];
          return InkWell(
            onTap: () {
              Navigator.pop(context);
              if (widget.onJumpToPage != null) {
                widget.onJumpToPage!(juz.startPage);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MushafReaderPage(initialPage: juz.startPage)),
                );
              }
            },
            borderRadius: BorderRadius.circular(AppThemeTokens.r12),
            child: Container(
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(AppThemeTokens.r12),
                border: Border.all(color: cs.cardBorder),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${juz.juzNumber}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                    Text(
                      'ل: ${juz.startPage}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 9,
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (_activeNavSubTab == 1) {
      // Surah List (with Search)
      final surahsAsync = ref.watch(surahListProvider);

      return Column(
        children: [
          // Inline Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(AppThemeTokens.r10),
                border: Border.all(color: cs.cardBorder),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                textDirection: TextDirection.rtl,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textPrimary),
                decoration: InputDecoration(
                  hintText: 'ناوی سورەت بنووسە...',
                  hintStyle: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary),
                  prefixIcon: Icon(Icons.search_rounded, color: cs.primary, size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),

          // Scrollable list
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                final query = _searchQuery.trim().toLowerCase();
                final filtered = surahs.where((s) {
                  return s.nameEn.toLowerCase().contains(query) ||
                      s.nameAr.contains(query) ||
                      s.nameKu.contains(query) ||
                      s.number.toString() == query;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(context.l10n.quranNoSurahFound, style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary)),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(color: cs.cardBorder, height: 1),
                  itemBuilder: (context, idx) {
                    final surah = filtered[idx];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      dense: true,
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${surah.number}',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold, color: cs.primary),
                          ),
                        ),
                      ),
                      title: Text(
                        surah.nameEn,
                        style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: cs.textPrimary),
                      ),
                      subtitle: Text(
                        'لاپەڕەی ${surah.pageStart} — ${surah.totalAyahs} ئایەت',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary),
                      ),
                      trailing: Text(
                        surah.nameAr,
                        style: TextStyle(fontFamily: 'UthmanicHafs', fontSize: 18, color: cs.textPrimary),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (widget.onJumpToSurah != null) {
                          widget.onJumpToSurah!(surah);
                        } else {
                          if (widget.isMushaf) {
                            if (widget.onJumpToPage != null) {
                              widget.onJumpToPage!(surah.pageStart ?? 1);
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => QuranReaderPage(surah: surah)),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(context.l10n.quranErrorLoadingSurahs, style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary))),
            ),
          ),
        ],
      );
    } else {
      // Numeric Page Input
      final textController = TextEditingController(text: '${widget.currentPage ?? 1}');
      int currentVal = widget.currentPage ?? 1;
      return StatefulBuilder(
        builder: (context, setPageState) {
          return Padding(
            padding: const EdgeInsets.all(AppThemeTokens.s20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'لاپەڕە هەڵبژێرە (١ تا ٦٠٤)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: cs.bg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppThemeTokens.r12),
                    border: Border.all(color: cs.cardBorder),
                  ),
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ژمارەی لاپەڕە',
                    ),
                    onChanged: (v) {
                      final val = int.tryParse(v);
                      if (val != null && val >= 1 && val <= 604) {
                        currentVal = val;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final textVal = int.tryParse(textController.text);
                    if (textVal != null && textVal >= 1 && textVal <= 604) {
                      currentVal = textVal;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'تکایە ژمارەیەک لە نێوان ١ تا ٦٠٤ بنووسە',
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    if (widget.onJumpToPage != null) {
                      widget.onJumpToPage!(currentVal);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MushafReaderPage(initialPage: currentVal)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemeTokens.r12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'بڕۆ بۆ لاپەڕە',
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }



  // ── Helper Row Switch builder ───────────────────────────────────────────
  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required bool value,
    required AppColorScheme cs,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: cs.primary, size: 18),
              ),
              const SizedBox(width: AppThemeTokens.s12),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            activeThumbColor: cs.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // Special Tajweed switch row with a colored active badge
  Widget _buildTajweedSwitchRow({
    required bool value,
    required AppColorScheme cs,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: value
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                      : cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.color_lens_rounded,
                  color: value ? const Color(0xFF2E7D32) : cs.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppThemeTokens.s12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ڕەنگەکانی تەجوید',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  if (value)
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Text(
                        '● چالاکە',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF2E7D32),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

