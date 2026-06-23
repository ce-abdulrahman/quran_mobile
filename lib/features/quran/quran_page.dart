import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../../core/models/surah_model.dart';
import 'quran_providers.dart';
import 'quran_reader_page.dart';
import 'mushaf_reader_page.dart';
import 'quran_statistics_page.dart';
import '../../core/providers/app_providers.dart';
import '../settings/settings_page.dart';

import '../../core/models/juz_model.dart';
import '../../core/models/hizb_model.dart';
import '../../core/models/rub_el_hizb_data.dart';
import '../../core/models/manzil_model.dart';
import '../../core/models/sajdah_model.dart';
import 'widgets/quran_jump_dialog.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Filter Enum & Tab Enum
// ─────────────────────────────────────────────────────────────────────────────

enum _QuranFilter { all, meccan, medinan, bookmarked }
enum QuranDirectoryTab { surahs, juzs, hizbs, rubs, manzils, sajdahs }

// ─────────────────────────────────────────────────────────────────────────────
// Quran Page
// ─────────────────────────────────────────────────────────────────────────────

class QuranPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const QuranPage({super.key, this.showBackButton = false});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage> {
  _QuranFilter _filter = _QuranFilter.all;
  QuranDirectoryTab _activeTab = QuranDirectoryTab.surahs;
  String _query = '';
  final _ctrl = TextEditingController();
  bool _showSearch = false;

  List<SurahModel> _applyFilters(List<SurahModel> list) {
    return list.where((s) {
      if (_filter == _QuranFilter.meccan && !s.isMeccan) return false;
      if (_filter == _QuranFilter.medinan && s.isMeccan) return false;
      if (_filter == _QuranFilter.bookmarked) return false; // v2 compatibility
      if (_query.isNotEmpty) {
        final q = _query.trim().toLowerCase();
        return s.nameEn.toLowerCase().contains(q) ||
            s.nameAr.contains(q) ||
            s.nameKu.contains(q) ||
            s.number.toString() == q;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final cs = AppColorScheme.of(context, settings.bgMode);
    final l = context.l10n;
    final p = Responsive.pagePadding(context);
    final isDark = settings.bgMode == 'dark' || (settings.bgMode == 'default' && Theme.of(context).brightness == Brightness.dark);

    final surahListAsync = ref.watch(surahListProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────
          _QuranHeader(
            padding: p,
            isDark: isDark,
            cs: cs,
            l: l,
            query: _query,
            ctrl: _ctrl,
            showBackButton: widget.showBackButton,
            showSearchField: _showSearch,
            onSearchToggle: (val) => setState(() {
              _showSearch = val;
              if (!val) {
                _query = '';
                _ctrl.clear();
              }
            }),
            onSearch: (v) => setState(() => _query = v),
          ),

          // ── Scrollable Body with Cards and Tabs ───────────────────
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: _ContinueReadingSection(cs: cs, l: l, p: p),
                ),
                SliverToBoxAdapter(
                  child: const SizedBox(height: 16),
                ),
                SliverToBoxAdapter(
                  child: _DirectoryTabs(
                    activeTab: _activeTab,
                    padding: p,
                    l: l,
                    cs: cs,
                    onChanged: (tab) => setState(() {
                      _activeTab = tab;
                      _query = '';
                      _ctrl.clear();
                    }),
                  ),
                ),
              ],
              body: Column(
                children: [
                  if (_activeTab == QuranDirectoryTab.surahs) ...[
                    const SizedBox(height: 8),
                    _FilterTabs(
                      current: _filter,
                      padding: p,
                      l: l,
                      cs: cs,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Expanded(
                    child: _buildTabBody(cs, l, p, surahListAsync),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(AppColorScheme cs, AppLocalizations l, double p, AsyncValue<List<SurahModel>> surahListAsync) {
    switch (_activeTab) {
      case QuranDirectoryTab.surahs:
        return surahListAsync.when(
          data: (surahs) {
            final filtered = _applyFilters(surahs);
            if (filtered.isEmpty) {
              return _EmptyState(cs: cs);
            }
            final isTablet = Responsive.isTablet(context);
            final width = MediaQuery.of(context).size.width;
            final crossAxisCount = width >= 900 ? 3 : (isTablet ? 2 : 1);

            final Widget listWidget = crossAxisCount == 1
                ? ListView.builder(
                    padding: EdgeInsets.fromLTRB(p, 4, p, 100),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _SurahCard(
                      surah: filtered[i],
                      cs: cs,
                      l: l,
                    ).animate().fadeIn(
                          duration: 260.ms,
                          delay: Duration(milliseconds: 30 * i),
                        ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.fromLTRB(p, 4, p, 100),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 112,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _SurahCard(
                      surah: filtered[i],
                      cs: cs,
                      l: l,
                    ).animate().fadeIn(
                          duration: 260.ms,
                          delay: Duration(milliseconds: 30 * i),
                        ),
                  );

            return RefreshIndicator(
              color: cs.primary,
              backgroundColor: cs.card,
              onRefresh: () => ref.read(surahListProvider.notifier).refresh(),
              child: listWidget,
            );
          },
          loading: () => _QuranSkeleton(padding: p, cs: cs),
          error: (error, _) => _QuranErrorState(
            message: error.toString().replaceAll('Exception: ', ''),
            cs: cs,
            onRetry: () => ref.read(surahListProvider.notifier).refresh(),
          ),
        );
      case QuranDirectoryTab.juzs:
        return _JuzList(cs: cs, l: l, p: p);
      case QuranDirectoryTab.hizbs:
        return _HizbList(cs: cs, l: l, p: p);
      case QuranDirectoryTab.rubs:
        return _RubList(cs: cs, l: l, p: p);
      case QuranDirectoryTab.manzils:
        return _ManzilList(cs: cs, l: l, p: p);
      case QuranDirectoryTab.sajdahs:
        return _SajdahList(cs: cs, l: l, p: p);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _QuranHeader extends ConsumerWidget {
  const _QuranHeader({
    required this.padding,
    required this.isDark,
    required this.cs,
    required this.l,
    required this.query,
    required this.ctrl,
    required this.showBackButton,
    required this.showSearchField,
    required this.onSearchToggle,
    required this.onSearch,
  });

  final double padding;
  final bool isDark;
  final AppColorScheme cs;
  final AppLocalizations l;
  final String query;
  final TextEditingController ctrl;
  final bool showBackButton;
  final bool showSearchField;
  final ValueChanged<bool> onSearchToggle;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColorScheme.darken(cs.primary, 0.35),
                  AppColorScheme.darken(cs.primary, 0.42),
                ]
              : [cs.primaryDeep, cs.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(padding, 12, padding, 20),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showSearchField
                ? Container(
                    key: const ValueKey('search-active'),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => onSearchToggle(false),
                        ),
                        Expanded(
                          child: TextField(
                            controller: ctrl,
                            onChanged: onSearch,
                            autofocus: true,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: l.quranSearchHint,
                              hintStyle: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (query.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Colors.white),
                            onPressed: () {
                              ctrl.clear();
                              onSearch('');
                            },
                          ),
                      ],
                    ),
                  )
                : Row(
                    key: const ValueKey('search-inactive'),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showBackButton)
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.settings_rounded, color: Colors.white, size: 22),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsPage(showBackButton: true),
                                  ),
                                );
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 22),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => const QuranJumpDialog(),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () {
                              if (isDark) {
                                ref.read(readerSettingsProvider.notifier).setBgMode('light');
                                ref.read(themeModeProvider.notifier).setMode(ThemeMode.light);
                              } else {
                                ref.read(readerSettingsProvider.notifier).setBgMode('dark');
                                ref.read(themeModeProvider.notifier).setMode(ThemeMode.dark);
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l.quranTitle,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'القرآن الكريم',
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
                            onPressed: () => onSearchToggle(true),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 22),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QuranStatisticsPage(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 22),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MushafReaderPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Continue Reading & Recent Reads Section
// ─────────────────────────────────────────────────────────────────────────────

class _ContinueReadingSection extends ConsumerWidget {
  final AppColorScheme cs;
  final AppLocalizations l;
  final double p;

  const _ContinueReadingSection({
    required this.cs,
    required this.l,
    required this.p,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(readingTrackerProvider);
    final lastRead = state.lastRead;
    final tracker = ref.read(readingTrackerProvider.notifier);

    // Calculate Khatmah progress
    final uniqueRead = tracker.getTotalUniqueAyahsRead();
    final progressPercent = (uniqueRead / 6236.0) * 100.0;
    


    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: p),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (lastRead != null) ...[
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? cs.primary.withValues(alpha: 0.2) : cs.primary.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.menu_book_rounded, color: cs.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.continueReading.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: cs.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${lastRead.surahName} (ئایەتی ${lastRead.ayahNumber} — ل: ${lastRead.mushafPageNumber})',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: cs.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuranStatisticsPage(),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${progressPercent.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                            Text(
                              l.khatmahProgress,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                color: cs.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressPercent / 100.0,
                      minHeight: 6,
                      backgroundColor: cs.bg,
                      valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getRelativeTime(lastRead.timestamp, l),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: cs.textSecondary,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => _openLastRead(context, ref, lastRead, forceMode: 'list'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'کارت',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: cs.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () => _openLastRead(context, ref, lastRead, forceMode: 'mushaf'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'مۆدی لاپەڕە',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: cs.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _openLastRead(context, ref, lastRead),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  l.continueReading.split(' ').first,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_rounded, size: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (state.recentReads.isNotEmpty) ...[
            const SizedBox(height: 18),
            Text(
              l.recentReads,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: state.recentReads.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final recent = state.recentReads[i];
                  return ActionChip(
                    onPressed: () => _openRecentRead(context, ref, recent),
                    backgroundColor: cs.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: cs.cardBorder),
                    ),
                    label: Text(
                      '${recent.surahName} ${recent.ayahNumber}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: cs.textPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }


  String _getRelativeTime(DateTime ts, AppLocalizations l) {
    final diff = DateTime.now().difference(ts);
    if (diff.inMinutes < 1) return l.readTimeJustNow;
    if (diff.inHours < 1) return l.readTimeFormat(diff.inMinutes);
    if (diff.inDays < 1) return 'پێش ${diff.inHours} کاژێر';
    return 'پێش ${diff.inDays} ڕۆژ';
  }

  void _openLastRead(BuildContext context, WidgetRef ref, LocalLastRead lr, {String? forceMode}) {
    final mode = forceMode ?? lr.readingMode;
    if (mode == 'mushaf') {
      Navigator.push( 
        context,
        MaterialPageRoute(
          builder: (_) => MushafReaderPage(initialPage: lr.mushafPageNumber),
        ),
      );
    } else {
      ref.read(surahListProvider).whenData((list) {
        final surah = list.firstWhere((s) => s.id == lr.surahId, orElse: () => list.first);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuranReaderPage(
              surah: surah,
              initialAyahNumber: lr.ayahNumber,
            ),
          ),
        );
      });
    }
  }

  void _openRecentRead(BuildContext context, WidgetRef ref, LocalRecentRead recent) {
    if (recent.readingMode == 'mushaf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MushafReaderPage(initialPage: recent.pageNumber),
        ),
      );
    } else {
      ref.read(surahListProvider).whenData((list) {
        final surah = list.firstWhere((s) => s.id == recent.surahId, orElse: () => list.first);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuranReaderPage(
              surah: surah,
              initialAyahNumber: recent.ayahNumber,
            ),
          ),
        );
      });
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Directory Tabs
// ─────────────────────────────────────────────────────────────────────────────

class _DirectoryTabs extends StatelessWidget {
  final QuranDirectoryTab activeTab;
  final double padding;
  final AppLocalizations l;
  final AppColorScheme cs;
  final ValueChanged<QuranDirectoryTab> onChanged;

  const _DirectoryTabs({
    required this.activeTab,
    required this.padding,
    required this.l,
    required this.cs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (QuranDirectoryTab.surahs, l.quranAllSurahs),
      (QuranDirectoryTab.juzs, l.juz),
      (QuranDirectoryTab.hizbs, l.hizb),
      (QuranDirectoryTab.sajdahs, l.sajdah),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1F18) : const Color(0xFFE8ECE7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder, width: 1),
      ),
      child: Row(
        children: tabs.map((item) {
          final tab = item.$1;
          final label = item.$2;
          final active = tab == activeTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: active 
                      ? (isDark ? cs.primary : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: active && !isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: active ? FontWeight.bold : FontWeight.w600,
                      color: active 
                          ? (isDark ? Colors.white : cs.primaryDeep) 
                          : cs.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Directory Lists
// ─────────────────────────────────────────────────────────────────────────────

Widget _buildResponsiveGrid<T>({
  required BuildContext context,
  required List<T> items,
  required double padding,
  required Widget Function(BuildContext, T) itemBuilder,
  double mainAxisExtent = 92.0,
}) {
  final isTablet = Responsive.isTablet(context);
  final width = MediaQuery.of(context).size.width;
  final crossAxisCount = width >= 900 ? 3 : (isTablet ? 2 : 1);

  if (crossAxisCount == 1) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(padding, 8, padding, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  } else {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(padding, 8, padding, 100),
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 10,
        mainAxisExtent: mainAxisExtent,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}

class IslamicStarBadge extends StatelessWidget {
  final int number;
  final Color color;
  final double size;
  final Color? textColor;

  const IslamicStarBadge({
    super.key,
    required this.number,
    required this.color,
    this.size = 36,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tColor = textColor ?? (isDark ? Colors.white : color);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 0,
            child: Container(
              width: size * 0.74,
              height: size * 0.74,
              decoration: BoxDecoration(
                border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
          Transform.rotate(
            angle: 3.1415926535897932 / 4,
            child: Container(
              width: size * 0.74,
              height: size * 0.74,
              decoration: BoxDecoration(
                border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
                borderRadius: BorderRadius.circular(size * 0.08),
              ),
            ),
          ),
          Container(
            width: size * 0.56,
            height: size * 0.56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
          ),
          Text(
            '$number',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: size * 0.32,
              fontWeight: FontWeight.bold,
              color: tColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _JuzList extends ConsumerWidget {
  final AppColorScheme cs;
  final AppLocalizations l;
  final double p;
  const _JuzList({required this.cs, required this.l, required this.p});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final juzs = JuzModel.list;
    final trackerState = ref.watch(readingTrackerProvider);
    final history = trackerState.history;

    return _buildResponsiveGrid<JuzModel>(
      context: context,
      items: juzs,
      padding: p,
      mainAxisExtent: 96.0,
      itemBuilder: (context, juz) {
        final name = l.localeCode == 'ar' 
            ? juz.arabicName 
            : (l.localeCode == 'en' ? juz.englishName : juz.kurdishName);
        
        final uniqueReadInJuz = history
            .where((h) => h.juzNumber == juz.juzNumber)
            .map((h) => '${h.surahId}-${h.ayahNumber}')
            .toSet()
            .length;
        final totalAyahsInJuz = ReadingTrackerNotifier.juzTotalAyahs[juz.juzNumber - 1];
        final progress = totalAyahsInJuz > 0 ? (uniqueReadInJuz / totalAyahsInJuz).clamp(0.0, 1.0) : 0.0;

        return Card(
          color: cs.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.cardBorder),
          ),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                leading: IslamicStarBadge(
                  number: juz.juzNumber,
                  color: cs.primary,
                  textColor: cs.textPrimary,
                  size: 34,
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                    fontSize: 13.5,
                  ),
                ),
                subtitle: Text(
                  'لاپەڕەی ${juz.startPage}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: cs.textSecondary,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (progress > 0) ...[
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: progress >= 1.0 ? cs.primary : Colors.amber[700],
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: cs.primary),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MushafReaderPage(initialPage: juz.startPage),
                    ),
                  );
                },
              ),
              if (progress > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3,
                      backgroundColor: cs.bg,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0 ? cs.primary : Colors.amber[700]!,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HizbList extends ConsumerWidget {
  final AppColorScheme cs;
  final AppLocalizations l;
  final double p;
  const _HizbList({required this.cs, required this.l, required this.p});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hizbs = HizbModel.list;
    final trackerState = ref.watch(readingTrackerProvider);
    final history = trackerState.history;

    return _buildResponsiveGrid<HizbModel>(
      context: context,
      items: hizbs,
      padding: p,
      mainAxisExtent: 96.0,
      itemBuilder: (context, hiz) {
        final uniqueReadInHizb = history
            .where((h) => h.hizbNumber == hiz.hizbNumber)
            .map((h) => '${h.surahId}-${h.ayahNumber}')
            .toSet()
            .length;
        final totalAyahsInHizb = ReadingTrackerNotifier.hizbTotalAyahs[hiz.hizbNumber - 1];
        final progress = totalAyahsInHizb > 0 ? (uniqueReadInHizb / totalAyahsInHizb).clamp(0.0, 1.0) : 0.0;

        return Card(
          color: cs.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.cardBorder),
          ),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                leading: IslamicStarBadge(
                  number: hiz.hizbNumber,
                  color: cs.primary,
                  textColor: cs.textPrimary,
                  size: 34,
                ),
                title: Text(
                  'حزبی ${hiz.hizbNumber}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                    fontSize: 13.5,
                  ),
                ),
                subtitle: Text(
                  'لاپەڕەی ${hiz.startPage}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: cs.textSecondary,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (progress > 0) ...[
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: progress >= 1.0 ? cs.primary : Colors.amber[700],
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: cs.primary),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MushafReaderPage(initialPage: hiz.startPage),
                    ),
                  );
                },
              ),
              if (progress > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3,
                      backgroundColor: cs.bg,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress >= 1.0 ? cs.primary : Colors.amber[700]!,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RubList extends StatelessWidget {
  final AppColorScheme cs;
  final AppLocalizations l;
  final double p;
  const _RubList({required this.cs, required this.l, required this.p});

  @override
  Widget build(BuildContext context) {
    final rubs = RubElHizbData.list;
    return _buildResponsiveGrid<Map<String, dynamic>>(
      context: context,
      items: rubs,
      padding: p,
      itemBuilder: (context, rub) {
        final number = rub['rub_number'] as int? ?? 1;
        return Card(
          color: cs.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.cardBorder),
          ),
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            leading: IslamicStarBadge(
              number: number,
              color: cs.primary,
              textColor: cs.textPrimary,
              size: 34,
            ),
            title: Text(
              'ڕوبعی $number',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
                fontSize: 13.5,
              ),
            ),
            subtitle: Text(
              'لاپەڕەی ${rub['start_page']}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: cs.textSecondary,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: cs.primary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MushafReaderPage(initialPage: rub['start_page'] ?? 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ManzilList extends StatelessWidget {
  final AppColorScheme cs;
  final AppLocalizations l;
  final double p;
  const _ManzilList({required this.cs, required this.l, required this.p});

  @override
  Widget build(BuildContext context) {
    final manzils = ManzilModel.list;
    return _buildResponsiveGrid<ManzilModel>(
      context: context,
      items: manzils,
      padding: p,
      itemBuilder: (context, manzil) {
        return Card(
          color: cs.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.cardBorder),
          ),
          margin: EdgeInsets.zero,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            leading: IslamicStarBadge(
              number: manzil.manzilNumber,
              color: cs.primary,
              textColor: cs.textPrimary,
              size: 34,
            ),
            title: Text(
              'مەنزڵی ${manzil.manzilNumber}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
                fontSize: 13.5,
              ),
            ),
            subtitle: Text(
              'لاپەڕەی ${manzil.startPage} تا ${manzil.endPage}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: cs.textSecondary,
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: cs.primary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MushafReaderPage(initialPage: manzil.startPage),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SajdahList extends ConsumerWidget {
  final AppColorScheme cs;
  final AppLocalizations l;
  final double p;
  const _SajdahList({required this.cs, required this.l, required this.p});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sajdahs = SajdahModel.list;
    final trackerState = ref.watch(readingTrackerProvider);
    final history = trackerState.history;

    return _buildResponsiveGrid<SajdahModel>(
      context: context,
      items: sajdahs,
      padding: p,
      itemBuilder: (context, sajdah) {
        final name = l.localeCode == 'ar'
            ? sajdah.surahNameAr
            : (l.localeCode == 'en' ? sajdah.surahNameEn : sajdah.surahNameKu);
        final typeLabel = sajdah.isObligatory ? l.sajdahTypeObligatory : l.sajdahTypeRecommended;
        final hasRead = history.any((h) => h.surahId == sajdah.surahId && h.ayahNumber == sajdah.ayahNumber);

        return Card(
          color: cs.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: sajdah.isObligatory 
                  ? Colors.red.withValues(alpha: 0.4) 
                  : (hasRead ? cs.primary.withValues(alpha: 0.4) : cs.cardBorder),
              width: sajdah.isObligatory ? 1.5 : 1.0,
            ),
          ),
          margin: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: sajdah.isObligatory 
                  ? Colors.red.withValues(alpha: 0.04) 
                  : (hasRead ? cs.primary.withValues(alpha: 0.03) : null),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              leading: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: sajdah.isObligatory 
                      ? Colors.red.withValues(alpha: 0.1) 
                      : (hasRead ? cs.primary.withValues(alpha: 0.1) : cs.bg),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    hasRead ? Icons.check_circle_rounded : Icons.accessibility_new_rounded,
                    color: sajdah.isObligatory 
                        ? Colors.red 
                        : (hasRead ? cs.primary : cs.textSecondary),
                    size: 16,
                  ),
                ),
              ),
              title: Text(
                '$name (${sajdah.ayahNumber})',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                  fontSize: 13.5,
                ),
              ),
              subtitle: Text(
                'لاپەڕەی ${sajdah.pageNumber} — $typeLabel',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: sajdah.isObligatory ? Colors.red : cs.textSecondary,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: cs.primary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MushafReaderPage(initialPage: sajdah.pageNumber),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Tabs
// ─────────────────────────────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.current,
    required this.padding,
    required this.l,
    required this.cs,
    required this.onChanged,
  });

  final _QuranFilter current;
  final double padding;
  final AppLocalizations l;
  final AppColorScheme cs;
  final ValueChanged<_QuranFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_QuranFilter.all, l.quranAllSurahs),
      (_QuranFilter.meccan, l.quranMeccan),
      (_QuranFilter.medinan, l.quranMedinan),
      (_QuranFilter.bookmarked, l.quranBookmarked),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final filter = tabs[i].$1;
          final label = tabs[i].$2;
          final active = filter == current;
          return GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: active
                    ? LinearGradient(
                        colors: isDark
                            ? [
                                AppColorScheme.darken(cs.primary, 0.3),
                                AppColorScheme.darken(cs.primary, 0.38),
                              ]
                            : [cs.primary, AppColorScheme.darken(cs.primary, 0.15)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: active ? null : cs.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? (isDark ? AppColorScheme.darken(cs.primary, 0.12) : cs.primary)
                      : cs.cardBorder,
                  width: active ? 1.5 : 1.0,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: isDark ? 0.15 : 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active
                        ? Colors.white
                        : (isDark ? const Color(0xFF8BAE95) : cs.textSecondary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Surah Card
// ─────────────────────────────────────────────────────────────────────────────

class _SurahCard extends ConsumerWidget {
  const _SurahCard({required this.surah, required this.cs, required this.l});

  final SurahModel surah;
  final AppColorScheme cs;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(readingTrackerProvider.notifier);
    final progress = tracker.getSurahProgress(surah.id, surah.totalAyahs);
    final readCount = tracker.getSurahReadCount(surah.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => QuranReaderPage(surah: surah),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 380),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IslamicStarBadge(
                  number: surah.number,
                  color: cs.primary,
                  textColor: cs.textPrimary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.nameEn,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            '${surah.totalAyahs} ${l.quranAyahs}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: cs.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TypeBadge(
                            label: surah.isMeccan ? l.quranMeccan : l.quranMedinan,
                            isMeccan: surah.isMeccan,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Hero(
                  tag: 'surah-ar-${surah.number}',
                  child: Text(
                    surah.nameAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: cs.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (readCount > 0) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: cs.bg,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$readCount/${surah.totalAyahs} خوێندراوەتەوە',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.isMeccan});
  final String label;
  final bool isMeccan;

  @override
  Widget build(BuildContext context) {
    final color =
        isMeccan ? const Color(0xFF1A5E3A) : const Color(0xFF1A3A5C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64, color: cs.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'هیچ سورەتێک نەدۆزرایەوە',
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 16, color: cs.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton & Error Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _QuranSkeleton extends StatelessWidget {
  const _QuranSkeleton({required this.padding, required this.cs});
  final double padding;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(padding, 4, padding, 100),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.card.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cs.textSecondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: cs.textSecondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 10,
                    decoration: BoxDecoration(
                      color: cs.textSecondary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 18,
              decoration: BoxDecoration(
                color: cs.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 1200.ms,
            color: cs.cardBorder.withValues(alpha: 0.2),
          ),
    );
  }
}

class _QuranErrorState extends StatelessWidget {
  const _QuranErrorState({
    required this.message,
    required this.cs,
    required this.onRetry,
  });

  final String message;
  final AppColorScheme cs;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 54,
              color: Colors.redAccent.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'دووبارە هەوڵبدەرەوە',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
