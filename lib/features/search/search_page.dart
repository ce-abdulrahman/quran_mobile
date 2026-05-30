import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/network/api_constants.dart';
import '../quran/quran_reader_page.dart';
import '../../core/models/surah_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Search Result Model
// ─────────────────────────────────────────────────────────────────────────────

class _SearchResult {
  final String type; // 'ayah' | 'translation'
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
      final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ));

      final params = <String, dynamic>{
        'q': query,
        'type': _filterType,
        'per_page': 30,
      };
      if (_filterLang != 'all') params['language_code'] = _filterLang;

      final response = await dio.get('/search', queryParameters: params);
      final data = response.data as Map<String, dynamic>;
      final innerData = data['data'] as Map<String, dynamic>? ?? {};

      final results = <_SearchResult>[];

      // Parse ayah results
      final ayahs = innerData['ayahs'] as List? ?? [];
      for (final a in ayahs) {
        results.add(_SearchResult(
          type: 'ayah',
          ayahNumber: a['ayah_number'] as int? ?? 0,
          surahName: a['surah_name'] as String? ?? '',
          surahNameAr: a['surah_name_ar'] as String? ?? '',
          surahId: a['surah_id'] as int? ?? 0,
          text: a['text'] as String? ?? '',
          pageNumber: a['page_number'] as int?,
          juzNumber: a['juz_number'] as int?,
        ));
      }

      // Parse translation results
      final translations = innerData['translations'] as List? ?? [];
      for (final t in translations) {
        results.add(_SearchResult(
          type: 'translation',
          ayahNumber: t['ayah_number'] as int? ?? 0,
          surahName: t['surah_name'] as String? ?? '',
          surahNameAr: (t['surah_name_ar'] as String?) ?? '',
          surahId: t['surah_id'] as int? ?? 0,
          text: t['original_text'] as String? ?? '',
          translationText: t['text'] as String? ?? '',
          languageCode: t['language_code'] as String?,
        ));
      }

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMsg = 'کێشەیەک ڕوویدا. تکایە پەیوەندی ئینتەرنێتت بپشکنە.';
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
                          : cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isTranslation
                              ? Icons.translate_rounded
                              : Icons.menu_book_rounded,
                          size: 11,
                          color:
                              isTranslation ? Colors.blue : cs.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isTranslation ? 'وەرگێڕان' : 'ئایەت',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color:
                                isTranslation ? Colors.blue : cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Surah name
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
              ),
            ),

            // ── Content ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic text (always shown)
                  Text(
                    result.text,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 16,
                      height: 1.9,
                      color: cs.textPrimary,
                    ),
                  ),

                  // Translation text (only for translation results)
                  if (isTranslation && result.translationText != null) ...[
                    const SizedBox(height: 8),
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
                      final copyText = isTranslation && result.translationText != null
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
                  // Open in reader
                  GestureDetector(
                    onTap: () => _openReader(context),
                    child: Row(
                      children: [
                        Text('خوێندنەوە',
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
