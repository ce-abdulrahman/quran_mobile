import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/providers/hadith_provider.dart';
import '../hadith/hadith_category_page.dart';

import '../quran/quran_reader_page.dart';
import '../../core/models/surah_model.dart';
import '../home/names_of_allah_page.dart';
import '../home/seerah_page.dart';
import '../home/sahaba_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Search Result Model
// ─────────────────────────────────────────────────────────────────────────────

class _SearchResult {
  final String type; // 'ayah' | 'translation' | 'hadith' | 'note'
  final int ayahNumber;
  final String surahName;
  final String surahNameAr;
  final int surahId;
  final String text;
  final String? translationText;
  final String? languageCode;
  final int? pageNumber;
  final int? juzNumber;

  const _SearchResult({
    required this.type,
    required this.ayahNumber,
    required this.surahName,
    required this.surahNameAr,
    required this.surahId,
    required this.text,
    this.translationText,
    this.languageCode,
    this.pageNumber,
    this.juzNumber,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Search Page
// ─────────────────────────────────────────────────────────────────────────────

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  late final TabController _tabCtrl;

  String _query = '';
  bool _isLoading = false;
  String? _errorMsg;
  List<_SearchResult> _results = [];

  // Filter state
  String _filterType = 'all'; // 'all' | 'ayah' | 'translation'
  String _filterLang = 'all'; // 'all' | 'ku' | 'en'

  static const _recentSearches = [
    'الرحمن',
    'صبر',
    'ئارام',
    'رحمت',
    'Al-Fatiha',
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _tabCtrl.addListener(() {
      if (!_tabCtrl.indexIsChanging) {
        final types = ['all', 'ayah', 'translation'];
        setState(() => _filterType = types[_tabCtrl.index]);
        if (_query.trim().length >= 2) _doSearch(_query);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _doSearch(String q) async {
    final query = q.trim();
    if (query.length < 2) return;

    setState(() {
      _isLoading = true;
      _errorMsg = null;
      _results = [];
    });

    try {
      final isar = IsarService.instance.isar;
      final results = <_SearchResult>[];
      final isKu = Localizations.localeOf(context).languageCode == 'ku';

      // Load all surahs for mapping
      final surahList = await isar.surahCollections.where().findAll();
      final surahMap = {for (final s in surahList) s.number: s};

      // Query the unified SearchIndexCollection
      dynamic queryBuilder = isar.searchIndexCollections.filter()
          .contentContains(query, caseSensitive: false);

      // Apply type filtering
      if (_filterType == 'ayah') {
        queryBuilder = queryBuilder.typeEqualTo('ayah');
      } else if (_filterType == 'translation') {
        queryBuilder = queryBuilder.typeEqualTo('ayah').not();
      }

      // Apply language filtering
      if (_filterLang == 'ku') {
        queryBuilder = queryBuilder.group((q) => q.languageEqualTo('ku').or().languageEqualTo('all'));
      } else if (_filterLang == 'en') {
        queryBuilder = queryBuilder.group((q) => q.languageEqualTo('en').or().languageEqualTo('all'));
      }

      final matchedIndexes = await queryBuilder
          .sortByWeightDesc()
          .findAll();

      for (final idx in matchedIndexes) {
        if (idx.type == 'ayah') {
          final a = await isar.ayahCollections.filter()
              .surahNumberEqualTo(idx.surahNumber!)
              .and()
              .ayahNumberEqualTo(idx.ayahNumber!)
              .findFirst();
          if (a != null) {
            final surah = surahMap[a.surahNumber];
            final surahName = isKu 
                ? (surah?.nameKu ?? surah?.nameEn ?? 'Surah ${a.surahNumber}')
                : (surah?.nameEn ?? surah?.nameKu ?? 'Surah ${a.surahNumber}');
            
            results.add(_SearchResult(
              type: _filterType == 'translation' ? 'translation' : 'ayah',
              ayahNumber: a.ayahNumber,
              surahName: surahName,
              surahNameAr: surah?.nameAr ?? '',
              surahId: a.surahNumber,
              text: a.textUthmani,
              translationText: _filterType == 'translation' 
                  ? (_filterLang == 'en' ? a.textEn : a.textKu) 
                  : (a.textKu ?? a.textEn),
              languageCode: _filterLang == 'en' ? 'en' : 'ku',
              pageNumber: a.pageNumber,
              juzNumber: a.juzNumber,
            ));
          }
        } else if (idx.type == 'hadith') {
          final hadithId = int.tryParse(idx.key.split('_').last) ?? 0;
          final h = await isar.hadithCollections.filter().hadithIdEqualTo(hadithId).findFirst();
          if (h != null) {
            results.add(_SearchResult(
              type: 'hadith',
              ayahNumber: h.hadithId,
              surahName: h.categoryNameKu,
              surahNameAr: 'فەرموودە',
              surahId: h.categoryId,
              text: h.arabicText,
              translationText: h.translationKu,
              languageCode: 'ku',
            ));
          }
        } else if (idx.type == 'note') {
          final noteId = idx.key.split('_').last;
          final n = await isar.noteCollections.filter().noteIdEqualTo(noteId).findFirst();
          if (n != null) {
            String sName = 'تێبینی گشتی';
            String sNameAr = 'تێبینی';
            if (n.surahNumber > 0) {
              final surah = surahMap[n.surahNumber];
              sName = surah?.nameKu ?? 'سورەتی ${n.surahNumber}';
              sNameAr = surah?.nameAr ?? '';
            }
            results.add(_SearchResult(
              type: 'note',
              ayahNumber: n.ayahNumber,
              surahName: sName,
              surahNameAr: sNameAr,
              surahId: n.surahNumber,
              text: '',
              translationText: n.content,
              languageCode: 'ku',
            ));
          }
        } else if (idx.type == 'allah_name') {
          final nameId = int.tryParse(idx.key.split('_').last) ?? 0;
          final n = await isar.namesOfAllahCollections.filter().nameIdEqualTo(nameId).findFirst();
          if (n != null) {
            results.add(_SearchResult(
              type: 'name_of_allah',
              ayahNumber: n.nameId,
              surahName: n.nameKu,
              surahNameAr: 'ناوەکانی خودا',
              surahId: n.nameId,
              text: n.nameAr,
              translationText: n.meaningKu,
              languageCode: 'ku',
            ));
          }
        } else if (idx.type == 'seerah') {
          final seerahId = int.tryParse(idx.key.split('_').last) ?? 0;
          final s = await isar.seerahCollections.filter().seerahIdEqualTo(seerahId).findFirst();
          if (s != null) {
            results.add(_SearchResult(
              type: 'seerah',
              ayahNumber: s.seerahId,
              surahName: s.titleKu,
              surahNameAr: 'ژیاننامەی پێغەمبەر',
              surahId: s.seerahId,
              text: s.titleAr,
              translationText: s.contentMd.length > 150 ? '${s.contentMd.substring(0, 150)}...' : s.contentMd,
              languageCode: 'ku',
            ));
          }
        } else if (idx.type == 'sahaba') {
          final sahabaId = int.tryParse(idx.key.split('_').last) ?? 0;
          final s = await isar.sahabaCollections.filter().sahabaIdEqualTo(sahabaId).findFirst();
          if (s != null) {
            results.add(_SearchResult(
              type: 'sahaba',
              ayahNumber: s.sahabaId,
              surahName: s.nameKu,
              surahNameAr: 'هاوەڵان',
              surahId: s.sahabaId,
              text: s.nameAr,
              translationText: s.summaryKu,
              languageCode: 'ku',
            ));
          }
        }
      }

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMsg = 'کێشەیەک ڕوویدا لە کاتی گەڕانی ناوخۆیی.';
      });
    }
  }

  void _onQueryChanged(String v) {
    setState(() => _query = v);
    if (v.trim().length >= 2) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_query == v && mounted) _doSearch(v);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.bg,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────
          _buildHeader(cs, l, isDark),

          // ── Filter tabs ───────────────────────────────────────────
          if (_query.trim().length >= 2) _buildFilterTabs(cs),

          // ── Body ──────────────────────────────────────────────────
          Expanded(
            child: _query.trim().length < 2
                ? _buildIdle(cs, l)
                : _buildResults(cs, l),
          ),
        ],
      ),
    );
  }

  // ── Header with search bar ──────────────────────────────────────────────────
  Widget _buildHeader(AppColorScheme cs, AppLocalizations l, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColorScheme.darken(cs.primary, 0.42), AppColorScheme.darken(cs.primary, 0.35)]
              : [cs.primaryDeep, cs.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title row
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.travel_explore_rounded,
                      color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'گەڕانی پێشکەوتوو',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'گەڕان بە عەرەبی، کوردی، یان ئینگلیزی',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 14),

              // Search bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                ),
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focusNode,
                  onChanged: _onQueryChanged,
                  onSubmitted: _doSearch,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                      fontFamily: 'Cairo', fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'گەڕان بە عەرەبی، کوردی، یان ئینگلیزی...',
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    prefixIcon: _isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          )
                        : Icon(Icons.search_rounded,
                            color: Colors.white.withValues(alpha: 0.8), size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _ctrl.clear();
                              setState(() {
                                _query = '';
                                _results = [];
                                _errorMsg = null;
                              });
                            },
                            child: Icon(Icons.close_rounded,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 18),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Language filter pills
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _langPill('هەموو', 'all', cs),
                  const SizedBox(width: 8),
                  _langPill('کوردی', 'ku', cs),
                  const SizedBox(width: 8),
                  _langPill('English', 'en', cs),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _langPill(String label, String lang, AppColorScheme cs) {
    final active = _filterLang == lang;
    return GestureDetector(
      onTap: () {
        setState(() => _filterLang = lang);
        if (_query.trim().length >= 2) _doSearch(_query);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? cs.primary : Colors.white,
          ),
        ),
      ),
    );
  }

  // ── Tab filters ─────────────────────────────────────────────────────────────
  Widget _buildFilterTabs(AppColorScheme cs) {
    return Container(
      color: cs.card,
      child: TabBar(
        controller: _tabCtrl,
        labelColor: cs.primary,
        unselectedLabelColor: cs.textSecondary,
        indicatorColor: cs.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        tabs: const [
          Tab(text: 'هەموو'),
          Tab(text: 'ئایەت'),
          Tab(text: 'وەرگێڕان'),
        ],
      ),
    );
  }

  // ── Idle state ──────────────────────────────────────────────────────────────
  Widget _buildIdle(AppColorScheme cs, AppLocalizations l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Tip box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates_rounded,
                    color: cs.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'دەتوانیت بە عەرەبی وەک "الرحمن"، بە کوردی وەک "ئارام"، یان بەژمارەی ئایەت بگەڕێیت.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 24),

          Text(
            l.searchRecent,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: cs.textPrimary,
            ),
          ).animate().fadeIn(duration: 300.ms, delay: 50.ms),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: _recentSearches
                .asMap()
                .entries
                .map((e) => GestureDetector(
                      onTap: () {
                        _ctrl.text = e.value;
                        _onQueryChanged(e.value);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: cs.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cs.cardBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history_rounded,
                                size: 14, color: cs.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              e.value,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: cs.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                            duration: 250.ms,
                            delay: Duration(milliseconds: 60 * e.key)))
                .toList(),
          ),

          const SizedBox(height: 48),

          Center(
            child: Column(
              children: [
                Icon(Icons.travel_explore_rounded,
                    size: 80, color: cs.primary.withValues(alpha: 0.12))
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(begin: 0.95, end: 1.05, duration: 2000.ms),
                const SizedBox(height: 16),
                Text(
                  'گەڕان بە ناوەڕۆکی هەموو قورئانەوە',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: cs.textSecondary,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
        ],
      ),
    );
  }

  // ── Results ──────────────────────────────────────────────────────────────────
  Widget _buildResults(AppColorScheme cs, AppLocalizations l) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: cs.primary),
            const SizedBox(height: 16),
            Text(
              'گەڕان دەکات...',
              style: TextStyle(
                  fontFamily: 'Cairo', fontSize: 14, color: cs.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_errorMsg != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded,
                  size: 60, color: cs.textSecondary.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                _errorMsg!,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _doSearch(_query),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('دووبارە هەوڵبدەرەوە',
                    style: TextStyle(fontFamily: 'Cairo')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms);
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: cs.textSecondary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              '"$_query"',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.searchNoResults,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontFamily: 'Cairo', fontSize: 14, color: cs.textSecondary),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms);
    }

    return Column(
      children: [
        // Results count bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: cs.card,
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_results.length} ئەنجام',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '"$_query"',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: cs.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
            physics: const BouncingScrollPhysics(),
            itemCount: _results.length,
            itemBuilder: (context, index) {
              return _ResultCard(
                result: _results[index],
                query: _query,
                cs: cs,
                index: index,
              ).animate().fadeIn(
                    duration: 250.ms,
                    delay: Duration(milliseconds: 30 * (index % 15)),
                  );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Result Card
// ─────────────────────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.query,
    required this.cs,
    required this.index,
  });

  final _SearchResult result;
  final String query;
  final AppColorScheme cs;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isTranslation = result.type == 'translation';
    final isHadith = result.type == 'hadith';
    final isNote = result.type == 'note';
    final isNameOfAllah = result.type == 'name_of_allah';
    final isSeerah = result.type == 'seerah';
    final isSahaba = result.type == 'sahaba';

    return GestureDetector(
      onTap: () => _openReader(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Surah / Meta header ─────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.06),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  // Type badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isTranslation
                          ? Colors.blue.withValues(alpha: 0.12)
                          : isHadith
                              ? Colors.purple.withValues(alpha: 0.12)
                              : isNote
                                  ? Colors.orange.withValues(alpha: 0.12)
                                  : isNameOfAllah
                                      ? Colors.teal.withValues(alpha: 0.12)
                                      : isSeerah
                                          ? Colors.brown.withValues(alpha: 0.12)
                                          : isSahaba
                                              ? Colors.indigo.withValues(alpha: 0.12)
                                              : cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isTranslation
                              ? Icons.translate_rounded
                              : isHadith
                                  ? Icons.star_rounded
                                  : isNote
                                      ? Icons.note_alt_rounded
                                      : isNameOfAllah
                                          ? Icons.brightness_high_rounded
                                          : isSeerah
                                              ? Icons.history_edu_rounded
                                              : isSahaba
                                                  ? Icons.people_outline_rounded
                                                  : Icons.menu_book_rounded,
                          size: 11,
                          color: isTranslation
                              ? Colors.blue
                              : isHadith
                                  ? Colors.purple
                                  : isNote
                                      ? Colors.orange
                                      : isNameOfAllah
                                          ? Colors.teal
                                          : isSeerah
                                              ? Colors.brown
                                              : isSahaba
                                                  ? Colors.indigo
                                                  : cs.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isTranslation
                              ? 'وەرگێڕان'
                              : isHadith
                                  ? 'فەرموودە'
                                  : isNote
                                      ? 'تێبینی'
                                      : isNameOfAllah
                                          ? 'ناوی خودا'
                                          : isSeerah
                                              ? 'ژیاننامەی پێغەمبەر'
                                              : isSahaba
                                                  ? 'هاوەڵان'
                                                  : 'ئایەت',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isTranslation
                                ? Colors.blue
                                : isHadith
                                    ? Colors.purple
                                    : isNote
                                        ? Colors.orange
                                        : isNameOfAllah
                                            ? Colors.teal
                                            : isSeerah
                                                ? Colors.brown
                                                : isSahaba
                                                    ? Colors.indigo
                                                    : cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Surah/Category name
                  Text(
                    result.surahName,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                  if (result.ayahNumber > 0 && (result.type == 'ayah' || result.type == 'translation')) ...[
                    const SizedBox(width: 6),
                    // Ayah number badge
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${result.ayahNumber}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Content ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic text (always shown unless personal note and empty)
                  if (result.text.isNotEmpty)
                    Text(
                      result.text,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: isHadith ? 'Cairo' : 'UthmanicHafs',
                        fontSize: 16,
                        height: 1.9,
                        color: cs.textPrimary,
                      ),
                    ),

                  // Translation text / Hadith / Note text
                  if ((isTranslation || isHadith || isNote) && result.translationText != null) ...[
                    if (result.text.isNotEmpty) const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.bg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: cs.cardBorder.withValues(alpha: 0.5)),
                      ),
                      child: _HighlightedText(
                        text: result.translationText!,
                        query: query,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          height: 1.6,
                          color: cs.textSecondary,
                        ),
                        highlightColor: cs.primary.withValues(alpha: 0.25),
                        cs: cs,
                      ),
                    ),
                  ],

                  // Meta info row
                  if (result.pageNumber != null || result.juzNumber != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (result.juzNumber != null)
                          _MetaBadge(
                            icon: Icons.bookmark_border_rounded,
                            label: 'جزء ${result.juzNumber}',
                            cs: cs,
                          ),
                        if (result.pageNumber != null) ...[
                          const SizedBox(width: 8),
                          _MetaBadge(
                            icon: Icons.description_outlined,
                            label: 'لاپەڕە ${result.pageNumber}',
                            cs: cs,
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // ── Action row ──────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: cs.bg.withValues(alpha: 0.5),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Copy button
                  GestureDetector(
                    onTap: () {
                      final copyText = (isTranslation || isHadith || isNote) && result.translationText != null
                          ? '${result.text}\n\n${result.translationText}'
                          : result.text;
                      Clipboard.setData(ClipboardData(text: copyText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('لەبەرگیراوە',
                              style: TextStyle(fontFamily: 'Cairo')),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.copy_rounded,
                            size: 14, color: cs.textSecondary),
                        const SizedBox(width: 4),
                        Text('کۆپی',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: cs.textSecondary)),
                      ],
                    ),
                  ),
                  // Open in reader / category / notes page
                  GestureDetector(
                    onTap: () => _openReader(context),
                    child: Row(
                      children: [
                        Text(
                            isHadith
                                ? 'پیشاندان'
                                : isNote
                                    ? 'تێبینییەکان'
                                    : 'خوێندنەوە',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: cs.primary,
                            )),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 11, color: cs.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openReader(BuildContext context) {
    if (result.type == 'hadith') {
      final categoryId = result.surahId;
      final isar = IsarService.instance.isar;
      final hadiths = isar.hadithCollections.filter().categoryIdEqualTo(categoryId).findAllSync();
      final hCategory = HadithCategory(
        id: categoryId,
        nameKu: result.surahName,
        nameAr: 'الحديث',
        order: 1,
        isActive: true,
        hadiths: hadiths.map((h) => HadithItem(
          id: h.hadithId,
          categoryId: h.categoryId,
          arabicText: h.arabicText,
          translationKu: h.translationKu,
          translationEn: h.translationEn,
          narrator: h.narrator,
          source: h.source,
          explanationKu: h.explanationKu,
          explanationEn: h.explanationEn,
          order: h.order,
          isActive: h.isActive,
        )).toList(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HadithCategoryPage(category: hCategory),
        ),
      );

    } else if (result.type == 'name_of_allah') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NamesOfAllahPage(),
        ),
      );
    } else if (result.type == 'seerah') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SeerahPage(),
        ),
      );
    } else if (result.type == 'sahaba') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SahabaPage(),
        ),
      );
    } else {
      final surah = SurahModel(
        id: result.surahId,
        number: result.surahId,
        nameAr: result.surahNameAr.isNotEmpty ? result.surahNameAr : result.surahName,
        nameEn: result.surahName,
        nameKu: result.surahName,
        totalAyahs: 286,
        revelationType: 'Meccan',
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuranReaderPage(
            surah: surah,
            initialAyahNumber: result.ayahNumber,
          ),
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Highlighted Text Widget
// ─────────────────────────────────────────────────────────────────────────────

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
    required this.cs,
  });

  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lowerText.indexOf(lowerQuery, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx), style: style));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: style.copyWith(
          backgroundColor: highlightColor,
          color: cs.primary,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = idx + query.length;
    }

    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(children: spans),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Meta Badge
// ─────────────────────────────────────────────────────────────────────────────

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.icon, required this.label, required this.cs});
  final IconData icon;
  final String label;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: cs.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              color: cs.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
