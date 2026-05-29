import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/database/app_database.dart';
import '../quran/quran_providers.dart';
import '../quran/reader/reader_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final _ctrl = TextEditingController();
  late final TabController _tabCtrl;

  String _query = '';
  final List<String> _recent = ['الفاتحة', 'Al-Baqarah', 'يس', 'الملك'];

  // 0 = all, 1 = meccan, 2 = medinan
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        setState(() => _filterIndex = _tabCtrl.index);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _runSearch(String val) => setState(() => _query = val.trim());
  void _removeRecent(String term) => setState(() => _recent.remove(term));
  void _clearRecent() => setState(() => _recent.clear());

  List<Surah> _applyFilter(List<Surah> all) {
    List<Surah> base = all;

    // Apply tab filter
    if (_filterIndex == 1) {
      base = base.where((s) => s.revelationType.toLowerCase() == 'meccan').toList();
    } else if (_filterIndex == 2) {
      base = base.where((s) => s.revelationType.toLowerCase() == 'medinan').toList();
    }

    // Apply search query
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      base = base.where((s) {
        return s.nameAr.contains(q) ||
            s.nameEn.toLowerCase().contains(q) ||
            (s.nameKu?.contains(q) ?? false) ||
            s.number.toString() == q;
      }).toList();
    }

    return base;
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final surahsAsync = ref.watch(localSurahsProvider);
    final l = context.l10n;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.searchTitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: cs.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),

            // ── Search Bar ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: TextField(
                  controller: _ctrl,
                  autofocus: true,
                  onChanged: _runSearch,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 15, color: cs.textPrimary),
                  decoration: InputDecoration(
                    hintText: l.quranSearchHint,
                    hintStyle: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
                    prefixIcon: Icon(Icons.search_rounded, color: cs.primary, size: 22),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear_rounded, color: cs.textSecondary, size: 20),
                            onPressed: () {
                              _ctrl.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 50.ms),
            ),

            const SizedBox(height: 12),

            // ── Filter Tabs ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: cs.primary.withValues(alpha: 0.4)),
                  ),
                  labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                  labelColor: cs.primary,
                  unselectedLabelColor: cs.textSecondary,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: l.quranAll),
                    Tab(text: '🕋 ${l.quranMeccan}'),
                    Tab(text: '🕌 ${l.quranMedinan}'),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            ),

            const SizedBox(height: 16),

            // ── Content ───────────────────────────────────────────
            Expanded(
              child: surahsAsync.when(
                data: (allSurahs) {
                  if (_query.isEmpty && _filterIndex == 0) {
                    return _RecentSearches(
                      recent: _recent,
                      cs: cs,
                      onTap: (term) {
                        _ctrl.text = term;
                        _runSearch(term);
                      },
                      onRemove: _removeRecent,
                      onClear: _clearRecent,
                    );
                  }

                  final filtered = _applyFilter(allSurahs);

                  if (filtered.isEmpty) {
                    return _EmptyResults(cs: cs, query: _query);
                  }

                  return _ResultsList(results: filtered, cs: cs, query: _query);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                ),
                error: (_, __) => Center(
                  child: Text(
                    l.searchError,
                    style: TextStyle(fontFamily: 'Cairo', color: cs.textPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recent Searches ────────────────────────────────────────────────────────────
class _RecentSearches extends StatelessWidget {
  const _RecentSearches({
    required this.recent,
    required this.cs,
    required this.onTap,
    required this.onRemove,
    required this.onClear,
  });
  final List<String> recent;
  final AppColorScheme cs;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (recent.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded, size: 56, color: cs.textSecondary.withValues(alpha: 0.25)),
            const SizedBox(height: 14),
            Text(
              l.searchNoRecent,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 15, color: cs.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              l.searchNoRecentDesc,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary.withValues(alpha: 0.6)),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l.searchRecent,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: cs.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: onClear,
              child: Text(
                l.searchClearAll,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recent.asMap().entries.map((e) => _RecentItem(
              term: e.value,
              cs: cs,
              onTap: onTap,
              onRemove: onRemove,
            ).animate().fadeIn(duration: 300.ms, delay: (e.key * 60).ms)),
      ],
    );
  }
}

class _RecentItem extends StatelessWidget {
  const _RecentItem({required this.term, required this.cs, required this.onTap, required this.onRemove});
  final String term;
  final AppColorScheme cs;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(term),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, size: 18, color: cs.textSecondary),
                const SizedBox(width: 10),
                Text(term,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: cs.textPrimary)),
              ],
            ),
            GestureDetector(
              onTap: () => onRemove(term),
              child: Icon(Icons.close_rounded, size: 16, color: cs.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Results List ───────────────────────────────────────────────────────────────
class _ResultsList extends ConsumerWidget {
  const _ResultsList({required this.results, required this.cs, required this.query});
  final List<Surah> results;
  final AppColorScheme cs;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l.searchResultsFound(results.length),
            style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: results.length,
            itemBuilder: (_, i) {
              final s = results[i];
              final isMeccan = s.revelationType.toLowerCase() == 'meccan';
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReaderPage(surah: s)),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Number badge
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isMeccan
                                ? [AppColors.primaryGreen, AppColors.primaryGreenDeep]
                                : [const Color(0xFF5B8FD4), const Color(0xFF3A6BB0)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${s.number}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang == 'en' ? s.nameEn : (lang == 'ku' ? (s.nameKu ?? s.nameAr) : s.nameAr),
                              style: TextStyle(
                                fontFamily: lang == 'en' || lang == 'ku' ? 'Cairo' : 'UthmanicHafs',
                                fontSize: lang == 'en' || lang == 'ku' ? 16 : 18,
                                fontWeight: FontWeight.w700,
                                color: cs.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lang == 'en'
                                  ? s.nameAr
                                  : lang == 'ku'
                                      ? '${s.nameEn}  ·  ${s.nameAr}'
                                      : s.nameEn,
                              style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (isMeccan ? AppColors.primaryGreen : const Color(0xFF5B8FD4))
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isMeccan ? l.quranMeccan : l.quranMedinan,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isMeccan ? AppColors.primaryGreen : const Color(0xFF5B8FD4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${s.totalAyahs} ${l.quranAyahs}',
                                  style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.arrow_back_ios_rounded, size: 14, color: cs.textSecondary),
                    ],
                  ),
                ).animate().fadeIn(duration: 280.ms, delay: (i * 25).ms),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Empty Results ──────────────────────────────────────────────────────────────
class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.cs, required this.query});
  final AppColorScheme cs;
  final String query;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 60, color: cs.textSecondary.withValues(alpha: 0.25)),
          const SizedBox(height: 16),
          Text(
            l.searchNoResults,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.searchNotFound(query),
            style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
