import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/surah_model.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/bookmarks_provider.dart';
import 'quran_providers.dart';
import 'providers/audio_player_provider.dart';
import 'widgets/share_card_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mushaf Reader Page
// ─────────────────────────────────────────────────────────────────────────────

class MushafReaderPage extends ConsumerStatefulWidget {
  const MushafReaderPage({super.key});

  @override
  ConsumerState<MushafReaderPage> createState() => _MushafReaderPageState();
}

class _MushafReaderPageState extends ConsumerState<MushafReaderPage> {
  static const _lastPageKey = 'mushaf_last_read_page';
  
  late PageController _pageController;
  int _currentPage = 1; // 1-indexed (1 to 604)
  bool _isInitialized = false;

  // Selected ayah state for interactive bottom sheet
  AyahModel? _selectedAyah;
  
  // Custom font size and translation options inside reader
  double _fontSize = 20.0;
  bool _showTranslations = true;
  String _bgMode = 'cream'; // 'cream' | 'default' | 'dark'

  @override
  void initState() {
    super.initState();
    _loadLastPage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_lastPageKey) ?? 1;
    if (mounted) {
      setState(() {
        _currentPage = saved.clamp(1, 604);
        _pageController = PageController(initialPage: _currentPage - 1);
        _isInitialized = true;
      });
      _trackReadingProgress();
    }
  }

  Future<void> _saveLastPage(int p) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPageKey, p);
  }

  void _onPageChanged(int idx) {
    setState(() {
      _currentPage = idx + 1;
      _selectedAyah = null; // Clear selection on page turn
    });
    _saveLastPage(_currentPage);
    _trackReadingProgress();
  }

  void _trackReadingProgress() {
    // Log reading tracking for the first verse of the current page
    Future.microtask(() async {
      try {
        final ayahs = await ref.read(pageAyahsProvider(_currentPage).future);
        if (ayahs.isNotEmpty && mounted) {
          final first = ayahs.first;
          ref.read(readingTrackerProvider.notifier).trackRead(
                first.surah?.id ?? 1,
                first.surah?.nameEn ?? '',
                first.ayahNumber,
                secondsSpent: 1,
              );
        }
      } catch (_) {}
    });
  }

  void _jumpToPage(int pageNumber) {
    final target = pageNumber.clamp(1, 604);
    _pageController.jumpToPage(target - 1);
    setState(() {
      _currentPage = target;
      _selectedAyah = null;
    });
    _saveLastPage(_currentPage);
  }

  // ── Show Page Navigation Slider sheet ──────────────────────────────────────
  void _showJumpPageSheet(BuildContext context, AppColorScheme cs) {
    int tempPage = _currentPage;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: cs.cardBorder),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: cs.textSecondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'بڕۆ بۆ لاپەڕە',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'لاپەڕە $tempPage لە ٦٠٤',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: tempPage.toDouble(),
                    min: 1,
                    max: 604,
                    divisions: 603,
                    activeColor: cs.primary,
                    inactiveColor: cs.primary.withValues(alpha: 0.15),
                    onChanged: (v) {
                      setSheetState(() => tempPage = v.round());
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: cs.cardBorder),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'پاشگەزبوونەوە',
                            style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _jumpToPage(tempPage);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'بڕۆ',
                            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Show Font Settings sheet ────────────────────────────────────────────────
  void _showSettingsSheet(BuildContext context, AppColorScheme cs) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: cs.cardBorder),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: cs.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ڕێکخستنی خوێندنەوەی پەیج',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Font Size
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('قەبارەی دەق', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                      Text('${_fontSize.round()}', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: cs.primary)),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 14,
                    max: 30,
                    divisions: 8,
                    activeColor: cs.primary,
                    inactiveColor: cs.primary.withValues(alpha: 0.15),
                    onChanged: (v) {
                      setState(() => _fontSize = v);
                      setSheetState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // Toggle Translations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'پیشاندانی وەرگێڕانی ئایەتی دیاریکراو',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: _showTranslations,
                        activeThumbColor: cs.primary,
                        onChanged: (v) {
                          setState(() => _showTranslations = v);
                          setSheetState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Background Theme
                  const Text('ڕەنگی لاپەڕە', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _themeButton('cream', 'کاهی / مایل بە زەرد', const Color(0xFFFDF6E3), Colors.black, cs),
                      _themeButton('default', 'سروشتی ئەپ', cs.bg, cs.textPrimary, cs),
                      _themeButton('dark', 'تاریک', const Color(0xFF0C130F), Colors.white, cs),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _themeButton(String mode, String label, Color background, Color text, AppColorScheme cs) {
    final active = _bgMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() => _bgMode = mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? cs.primary : cs.cardBorder,
            width: active ? 2 : 1,
          ),
        ),
        child: Text(
          label.split(' ').first,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: text,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final cs = AppColorScheme.of(context);

    // Resolve active colors based on reading background selection
    Color pageBg = cs.bg;
    Color pageCard = cs.card;
    Color pageText = cs.textPrimary;
    Color pageTextSecondary = cs.textSecondary;
    Color pageBorder = cs.cardBorder;

    if (_bgMode == 'cream') {
      pageBg = const Color(0xFFF5EFEB);
      pageCard = const Color(0xFFFDFBF7);
      pageText = const Color(0xFF2E2B2A);
      pageTextSecondary = const Color(0xFF7A726F);
      pageBorder = const Color(0xFFEDE5DF);
    } else if (_bgMode == 'dark') {
      pageBg = const Color(0xFF070B09);
      pageCard = const Color(0xFF0F1512);
      pageText = const Color(0xFFE3EAE5);
      pageTextSecondary = const Color(0xFF8B9A92);
      pageBorder = const Color(0xFF1D2622);
    }

    return Scaffold(
      backgroundColor: pageBg,
      body: Column(
        children: [
          // ── Header Bar ──────────────────────────────────────────────────────
          _buildHeaderBar(cs, pageBg, pageText),

          // ── Page Content Slider (RTL) ──────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 604,
              reverse: true, // Right-to-Left page turns
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final pageNum = index + 1;
                return _buildMushafPage(pageNum, cs, pageCard, pageText, pageTextSecondary, pageBorder);
              },
            ),
          ),

          // ── Bottom Panel (Visible if an Ayah is selected) ──────────────────
          _buildBottomActionPanel(cs, pageCard, pageText, pageTextSecondary, pageBorder),
        ],
      ),
    );
  }

  // ── Header Bar Builder ─────────────────────────────────────────────────────
  Widget _buildHeaderBar(AppColorScheme cs, Color bg, Color text) {
    final asyncVal = ref.watch(pageAyahsProvider(_currentPage));
    
    // Resolve Juz and Surah details dynamically from current page's ayahs
    String headerMeta = 'باری لاپەڕە...';
    asyncVal.whenData((list) {
      if (list.isNotEmpty) {
        final first = list.first;
        final uniqueSurahs = list.map((a) => a.surah?.nameEn ?? '').toSet().join(' / ');
        headerMeta = 'جزء ${first.juzNumber ?? 1} — سورەتی $uniqueSurahs';
      }
    });

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 8),
      color: bg,
      child: Container(
        height: kToolbarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: text, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'لاپەڕە $_currentPage',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: text,
                    ),
                  ),
                  Text(
                    headerMeta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: text.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.travel_explore_rounded, color: text, size: 22),
              onPressed: () => _showJumpPageSheet(context, cs),
            ),
            IconButton(
              icon: Icon(Icons.tune_rounded, color: text, size: 22),
              onPressed: () => _showSettingsSheet(context, cs),
            ),
          ],
        ),
      ),
    );
  }

  // ── Mushaf Page Layout Builder ─────────────────────────────────────────────
  Widget _buildMushafPage(int pageNum, AppColorScheme cs, Color cardBg, Color textPrimary, Color textSecondary, Color cardBorder) {
    final pageAyahs = ref.watch(pageAyahsProvider(pageNum));

    return pageAyahs.when(
      data: (ayahs) {
        if (ayahs.isEmpty) {
          return Center(
            child: Text(
              'هیچ ئایەتێک لەم لاپەڕەیەدا نییە',
              style: TextStyle(fontFamily: 'Cairo', color: textSecondary),
            ),
          );
        }

        // Build list of text spans
        final spans = <InlineSpan>[];
        for (int i = 0; i < ayahs.length; i++) {
          final ayah = ayahs[i];
          final isSelected = _selectedAyah?.id == ayah.id;
          final playerState = ref.watch(audioPlayerProvider);
          final isPlayingAyah = playerState.isPlaying && 
              playerState.currentAyahNumber == ayah.ayahNumber && 
              ayah.surah?.id == playerState.selectedReciterId; // Wait, currentAyahNumber match

          // Render Surah Banner if it's the start of a Surah
          if (ayah.ayahNumber == 1) {
            spans.add(
              WidgetSpan(
                child: _buildSurahBanner(ayah.surah!, textPrimary, textSecondary, cardBorder),
                alignment: PlaceholderAlignment.middle,
              ),
            );
            spans.add(const TextSpan(text: '\n'));

            // Render Bismillah if required (all except Surah 1 and 9)
            if (ayah.surah!.number != 1 && ayah.surah!.number != 9) {
              spans.add(
                WidgetSpan(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: TextStyle(
                          fontFamily: 'UthmanicHafs',
                          fontSize: _fontSize + 2,
                          color: textPrimary.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
              );
              spans.add(const TextSpan(text: '\n'));
            }
          }

          // Render the Ayah text Span
          spans.add(
            TextSpan(
              text: ayah.textUthmani,
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: _fontSize,
                height: 2.2,
                color: isSelected 
                    ? cs.primary 
                    : (isPlayingAyah ? cs.primary : textPrimary),
                backgroundColor: isSelected 
                    ? cs.primary.withValues(alpha: 0.14) 
                    : (isPlayingAyah ? cs.primary.withValues(alpha: 0.08) : null),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    if (_selectedAyah?.id == ayah.id) {
                      _selectedAyah = null; // Toggle off
                    } else {
                      _selectedAyah = ayah;
                    }
                  });
                },
            ),
          );

          // Render the Ayah Number brackets
          spans.add(
            TextSpan(
              text: ' ﴿${ayah.ayahNumber}﴾ ',
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: _fontSize - 2,
                fontWeight: FontWeight.bold,
                color: cs.primary.withValues(alpha: 0.8),
              ),
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(children: spans),
              ),
            ),
          ),
        );
      },
      loading: () => _buildShimmerSkeleton(cardBg, cardBorder, textSecondary),
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              err.toString().replaceAll('Exception: ', ''),
              style: TextStyle(fontFamily: 'Cairo', color: textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(pageAyahsProvider(pageNum)),
              style: ElevatedButton.styleFrom(backgroundColor: cs.primary),
              child: const Text('دووبارە هەوڵبدەرەوە', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  // ── Surah Banner Widget Builder ────────────────────────────────────────────
  Widget _buildSurahBanner(SurahModel surah, Color textPrimary, Color textSecondary, Color border) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: textPrimary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Text(
            'سُورَةُ ${surah.nameAr}',
            style: TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${surah.revelationType == 'meccan' ? 'مەککی' : 'مەدەنی'} — ${surah.totalAyahs} ئایەت',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Shimmer Skeleton Builder ───────────────────────────────────────────────
  Widget _buildShimmerSkeleton(Color cardBg, Color border, Color textSecondary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          12,
          (i) => Container(
            height: 20,
            margin: EdgeInsets.only(
              bottom: 14,
              left: i % 3 == 0 ? 60 : 0,
              right: i % 4 == 0 ? 40 : 0,
            ),
            decoration: BoxDecoration(
              color: textSecondary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms, color: border.withValues(alpha: 0.1));
  }

  // ── Bottom Selection / Translation Actions Panel ───────────────────────────
  Widget _buildBottomActionPanel(AppColorScheme cs, Color cardBg, Color textPrimary, Color textSecondary, Color border) {
    if (_selectedAyah == null) return const SizedBox.shrink();

    final ayah = _selectedAyah!;
    final bookmarks = ref.watch(bookmarksProvider);
    final favorites = ref.watch(favoritesProvider);

    final isBookmarked = bookmarks.any((b) =>
        b.surahId == ayah.surah?.id && b.ayahNumber == ayah.ayahNumber);
    final isFavorited = favorites.any((f) =>
        f.surahId == ayah.surah?.id && f.ayahNumber == ayah.ayahNumber);

    final playerState = ref.watch(audioPlayerProvider);
    final isPlayingThis = playerState.isPlaying && playerState.currentAyahNumber == ayah.ayahNumber;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Panel Header (Reference + Close button)
            Row(
              children: [
                Text(
                  '${ayah.surah?.nameEn ?? ""} : ${ayah.ayahNumber}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _selectedAyah = null),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: textSecondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 16, color: textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Translation block
            if (_showTranslations) ...[
              if (ayah.textKu != null && ayah.textKu!.isNotEmpty) ...[
                Text(
                  ayah.textKu!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    height: 1.6,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (ayah.textEn != null && ayah.textEn!.isNotEmpty) ...[
                Text(
                  ayah.textEn!,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    height: 1.5,
                    color: textSecondary,
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ],

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Audio recitation
                _panelAction(
                  icon: isPlayingThis 
                      ? Icons.pause_rounded 
                      : (playerState.isLoading ? Icons.hourglass_empty_rounded : Icons.play_arrow_rounded),
                  label: isPlayingThis ? 'ڕاگرتن' : 'خوێندنەوە',
                  color: isPlayingThis ? Colors.amber : cs.primary,
                  cs: cs,
                  onTap: () {
                    if (isPlayingThis) {
                      ref.read(audioPlayerProvider.notifier).pause();
                    } else {
                      ref.read(audioPlayerProvider.notifier).playAyah(
                            ayah.surah?.id ?? 1,
                            ayah.ayahNumber,
                          );
                    }
                  },
                ),
                // Favorite Star
                _panelAction(
                  icon: isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
                  label: 'دڵخواز',
                  color: isFavorited ? const Color(0xFFE6A23C) : textSecondary,
                  cs: cs,
                  onTap: () {
                    ref.read(favoritesProvider.notifier).toggle(
                          LocalFavorite(
                            surahId: ayah.surah?.id ?? 1,
                            surahName: ayah.surah?.nameEn ?? '',
                            ayahNumber: ayah.ayahNumber,
                            textUthmani: ayah.textUthmani,
                            textKu: ayah.textKu,
                            textEn: ayah.textEn,
                          ),
                        );
                  },
                ),
                // Bookmark Toggle
                _panelAction(
                  icon: isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  label: 'پاراستن',
                  color: isBookmarked ? const Color(0xFFCD9D27) : textSecondary,
                  cs: cs,
                  onTap: () {
                    ref.read(bookmarksProvider.notifier).toggle(
                          LocalBookmark(
                            surahId: ayah.surah?.id ?? 1,
                            surahName: ayah.surah?.nameEn ?? '',
                            ayahNumber: ayah.ayahNumber,
                            preview: ayah.textUthmani,
                          ),
                        );
                  },
                ),
                // Copy Clipboard
                _panelAction(
                  icon: Icons.copy_rounded,
                  label: 'کۆپی',
                  color: textSecondary,
                  cs: cs,
                  onTap: () {
                    final copyStr = [
                      ayah.textUthmani,
                      if (ayah.textKu != null) ayah.textKu,
                      if (ayah.textEn != null) ayah.textEn,
                      '(${ayah.surah?.nameEn} : ${ayah.ayahNumber})'
                    ].join('\n\n');
                    Clipboard.setData(ClipboardData(text: copyStr));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('دەقەکە کۆپی کرا', style: TextStyle(fontFamily: 'Cairo')),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                // Share Image
                _panelAction(
                  icon: Icons.share_rounded,
                  label: 'بەشکردن',
                  color: textSecondary,
                  cs: cs,
                  onTap: () {
                    Navigator.pop(context); // close the quick actions bottom sheet first
                    showShareCardSheet(
                      context,
                      ShareAyahData.fromAyahModel(ayah, ayah.surah?.nameEn ?? ''),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _panelAction({
    required IconData icon,
    required String label,
    required Color color,
    required AppColorScheme cs,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
