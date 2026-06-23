import 'dart:async';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/sajdah_model.dart';
import '../../core/models/surah_model.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/bookmarks_provider.dart';
import '../../core/providers/notes_provider.dart';
import '../../core/utils/quran_utils.dart';
import 'quran_providers.dart';
import 'providers/audio_player_provider.dart';
import 'widgets/share_card_sheet.dart';
import 'widgets/quran_settings_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Mushaf Reader Page
// ─────────────────────────────────────────────────────────────────────────────

class MushafReaderPage extends ConsumerStatefulWidget {
  /// Optional page to open at (1-604). If null, resumes from last saved page.
  final int? initialPage;
  const MushafReaderPage({super.key, this.initialPage});

  @override
  ConsumerState<MushafReaderPage> createState() => _MushafReaderPageState();
}

class _MushafReaderPageState extends ConsumerState<MushafReaderPage> {
  static const _lastPageKey = 'mushaf_last_read_page';
  
  late PageController _pageController;
  int _currentPage = 1; // 1-indexed (1 to 604)
  bool _isInitialized = false;
  bool _isToolbarVisible = true;

  // Selected ayah state for interactive bottom sheet
  AyahModel? _selectedAyah;
  


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
    // If initialPage is provided, go there (don't override last saved page)
    final saved = widget.initialPage ?? prefs.getInt(_lastPageKey) ?? 1;
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
                readingMode: 'mushaf',
                mushafPageNumber: _currentPage,
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



  void _showBookmarkCategoryPicker(BuildContext context, AyahModel ayah) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final bookmarks = ref.watch(bookmarksProvider);
            
            final categories = [
              (id: 'reading', label: l.readingBookmark, icon: Icons.menu_book_rounded, color: cs.primary),
              (id: 'memorization', label: l.memorizationBookmark, icon: Icons.memory_rounded, color: Colors.blue),
              (id: 'reflection', label: l.reflectionBookmark, icon: Icons.psychology_rounded, color: Colors.purple),
              (id: 'favorite', label: l.favoriteBookmark, icon: Icons.favorite_rounded, color: Colors.red),
            ];

            return Container(
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border.all(color: cs.cardBorder),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: cs.textSecondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l.bookmarkCategory,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: cs.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...categories.map((cat) {
                      final hasThisBook = bookmarks.any((b) =>
                          b.surahId == (ayah.surah?.id ?? 1) &&
                          b.ayahNumber == ayah.ayahNumber &&
                          b.category == cat.id);
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cat.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(cat.icon, color: cat.color, size: 20),
                        ),
                        title: Text(
                          cat.label,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                            color: cs.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Checkbox(
                          value: hasThisBook,
                          activeColor: cs.primary,
                          onChanged: (val) {
                            ref.read(bookmarksProvider.notifier).toggle(
                              LocalBookmark(
                                surahId: ayah.surah?.id ?? 1,
                                surahName: ayah.surah?.nameEn ?? '',
                                ayahNumber: ayah.ayahNumber,
                                preview: ayah.textUthmani,
                                category: cat.id,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getJuzLabel() {
    final asyncVal = ref.watch(pageAyahsProvider(_currentPage));
    return asyncVal.maybeWhen(
      data: (list) {
        if (list.isNotEmpty) {
          final first = list.first;
          return 'جزء ${first.juzNumber ?? 1}';
        }
        return '';
      },
      orElse: () => '',
    );
  }

  String _getSurahLabel() {
    final asyncVal = ref.watch(pageAyahsProvider(_currentPage));
    return asyncVal.maybeWhen(
      data: (list) {
        if (list.isNotEmpty) {
          final first = list.first;
          return first.surah?.nameAr ?? '';
        }
        return '';
      },
      orElse: () => '',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final settings = ref.watch(readerSettingsProvider);
    final cs = AppColorScheme.of(context, settings.bgMode);

    Color pageBg = cs.bg;
    Color pageCard = cs.card;
    Color pageText = cs.textPrimary;
    Color pageTextSecondary = cs.textSecondary;
    Color pageBorder = cs.cardBorder;

    return Scaffold(
      backgroundColor: pageBg,
      body: Stack(
        children: [
          // ── Page Content Slider (RTL) ──
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _isToolbarVisible = !_isToolbarVisible;
                });
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: 604,
                reverse: true, // Right-to-Left page turns
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final pageNum = index + 1;
                  return _buildMushafPage(pageNum, cs, pageCard, pageText, pageTextSecondary, pageBorder, settings);
                },
              ),
            ),
          ),

          // ── Elegant Printed Mushaf Labels (Header) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getJuzLabel(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: pageTextSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        _getSurahLabel(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: pageTextSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Elegant Printed Mushaf Labels (Footer) ──
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SafeArea(
                top: false,
                child: Center(
                  child: Text(
                    '$_currentPage',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: pageTextSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Floating Top Header Bar ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _isToolbarVisible ? 0 : -100 - MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _buildHeaderBar(cs, pageBg, pageText),
          ),

          // ── Floating Bottom Slider Toolbar ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isToolbarVisible ? 0 : -120 - MediaQuery.of(context).padding.bottom,
            left: 0,
            right: 0,
            child: _buildFloatingBottomToolbar(cs, pageCard, pageText, pageTextSecondary, pageBorder),
          ),

          // ── Bottom Panel (Visible if an Ayah is selected) ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomActionPanel(cs, pageCard, pageText, pageTextSecondary, pageBorder),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomToolbar(
    AppColorScheme cs,
    Color cardBg,
    Color textPrimary,
    Color textSecondary,
    Color border,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: isDark ? 0.82 : 0.88),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: border.withValues(alpha: 0.5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded, color: textPrimary),
                    onPressed: _currentPage < 604 ? () => _jumpToPage(_currentPage + 1) : null,
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentPage.toDouble(),
                      min: 1,
                      max: 604,
                      divisions: 603,
                      activeColor: cs.primary,
                      inactiveColor: cs.primary.withValues(alpha: 0.15),
                      onChanged: (v) => _jumpToPage(v.round()),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded, color: textPrimary),
                    onPressed: _currentPage > 1 ? () => _jumpToPage(_currentPage - 1) : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBar(AppColorScheme cs, Color bg, Color text) {
    final asyncVal = ref.watch(pageAyahsProvider(_currentPage));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    String headerMeta = 'باری لاپەڕە...';
    asyncVal.whenData((list) {
      if (list.isNotEmpty) {
        final first = list.first;
        final uniqueSurahs = list.map((a) => a.surah?.nameEn ?? '').toSet().join(' / ');
        headerMeta = 'جزء ${first.juzNumber ?? 1} — سورەتی $uniqueSurahs';
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: bg.withValues(alpha: isDark ? 0.85 : 0.90),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(color: cs.cardBorder.withValues(alpha: 0.5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SafeArea(
            bottom: false,
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
                    onPressed: () {
                      QuranSettingsSheet.show(
                        context,
                        surahId: _selectedAyah?.surah?.id ?? 1,
                        currentPage: _currentPage,
                        isMushaf: true,
                        initialIndex: 3,
                        onJumpToPage: (page) => _jumpToPage(page),
                        onJumpToSurah: (surah) => _jumpToPage(surah.pageStart ?? 1),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.tune_rounded, color: text, size: 22),
                    onPressed: () {
                      QuranSettingsSheet.show(
                        context,
                        surahId: _selectedAyah?.surah?.id ?? 1,
                        currentPage: _currentPage,
                        isMushaf: true,
                        initialIndex: 0,
                        onJumpToPage: (page) => _jumpToPage(page),
                        onJumpToSurah: (surah) => _jumpToPage(surah.pageStart ?? 1),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMushafPage(int pageNum, AppColorScheme cs, Color cardBg, Color textPrimary, Color textSecondary, Color cardBorder, ReaderSettings settings) {
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

        final spans = <InlineSpan>[];
        for (int i = 0; i < ayahs.length; i++) {
          final ayah = ayahs[i];
          final isSelected = _selectedAyah?.id == ayah.id;
          final playerState = ref.watch(audioPlayerProvider);
          final isPlayingAyah = playerState.isPlaying && 
              playerState.currentAyahNumber == ayah.ayahNumber && 
              ayah.surah?.id == playerState.selectedReciterId;

          if (ayah.ayahNumber == 1) {
            spans.add(
              WidgetSpan(
                child: _buildSurahBanner(context, ayah.surah!, textPrimary),
                alignment: PlaceholderAlignment.middle,
              ),
            );
            spans.add(const TextSpan(text: '\n'));

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
                          fontSize: settings.fontSize + 2,
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

          spans.add(
            TextSpan(
              text: ayah.textUthmani,
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: settings.fontSize,
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
                      _selectedAyah = null;
                    } else {
                      _selectedAyah = ayah;
                    }
                  });
                },
            ),
          );

          spans.add(
            TextSpan(
              text: ' ﴿${ayah.ayahNumber}﴾ ',
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: settings.fontSize - 2,
                fontWeight: FontWeight.bold,
                color: cs.primary.withValues(alpha: 0.8),
              ),
            ),
          );
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            margin: const EdgeInsets.fromLTRB(16, 48, 16, 72),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cardBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
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

  Widget _buildSurahBanner(BuildContext context, SurahModel surah, Color textPrimary) {
    final width = MediaQuery.of(context).size.width;
    final responsiveFontSize = (width * 0.26).clamp(70.0, 140.0);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18, bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Text(
          getSurahHeaderCharacter(surah.number),
          style: TextStyle(
            fontFamily: 'SurahHeader',
            fontFamilyFallback: const ['UthmanicHafs', 'Amiri', 'Cairo'],
            fontSize: responsiveFontSize,
            color: textPrimary,
          ),
        ),
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
    final sajdah = SajdahModel.list.cast<SajdahModel?>().firstWhere(
      (s) => s?.surahId == (ayah.surah?.id ?? 1) && s?.ayahNumber == ayah.ayahNumber,
      orElse: () => null,
    );
    final bookmarks = ref.watch(bookmarksProvider);
    final favorites = ref.watch(favoritesProvider);
    final notes = ref.watch(notesProvider);

    final isBookmarked = bookmarks.any((b) =>
        b.surahId == (ayah.surah?.id ?? 1) && b.ayahNumber == ayah.ayahNumber);
    final isFavorited = favorites.any((f) =>
        f.surahId == (ayah.surah?.id ?? 1) && f.ayahNumber == ayah.ayahNumber);
    final note = notes.cast<LocalNote?>().firstWhere(
      (n) => n?.surahNumber == (ayah.surah?.id ?? 1) && n?.ayahNumber == ayah.ayahNumber,
      orElse: () => null,
    );
    final hasNote = note != null && note.content.isNotEmpty;

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
            if (sajdah != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: sajdah.isObligatory ? Colors.red.withValues(alpha: 0.08) : cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: sajdah.isObligatory ? Colors.red.withValues(alpha: 0.2) : cs.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: sajdah.isObligatory ? Colors.red : cs.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.sajdahInfo.replaceAll('%s', sajdah.isObligatory ? context.l10n.sajdahTypeObligatory : context.l10n.sajdahTypeRecommended),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: sajdah.isObligatory ? Colors.red : cs.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Translation block
            if (ref.read(readerSettingsProvider).showKurdish && ayah.textKu != null && ayah.textKu!.isNotEmpty) ...[
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
            if (ref.read(readerSettingsProvider).showEnglish && ayah.textEn != null && ayah.textEn!.isNotEmpty) ...[
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
            if (hasNote) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.withValues(alpha: 0.15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.edit_note_rounded, color: Colors.purple, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'تێبینی/ڕامانی تۆ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      note.content,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        height: 1.5,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
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
                  onTap: () => _showBookmarkCategoryPicker(context, ayah),
                ),
                // Note / Reflection edit
                _panelAction(
                  icon: hasNote ? Icons.edit_note_rounded : Icons.note_add_rounded,
                  label: 'ڕامان',
                  color: hasNote ? Colors.purple : textSecondary,
                  cs: cs,
                  onTap: () => _showNoteDialog(context, ayah, ref),
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

  void _showNoteDialog(BuildContext context, AyahModel ayah, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final surahId = ayah.surah?.id ?? 1;
    final existingNote = ref.read(notesProvider.notifier).getNote(surahId, ayah.ayahNumber);
    final textController = TextEditingController(text: existingNote?.content ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: cs.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'نووسینی تێبینی/ڕامان',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ئایەتی ${ayah.ayahNumber} لە سورەتی ${ayah.surah?.nameEn ?? ""}',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: cs.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                maxLines: 4,
                textDirection: TextDirection.rtl,
                autofocus: true,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: cs.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'تێبینی یان تێڕامانی خۆت لێرە بنووسە...',
                  hintStyle: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: cs.textSecondary.withValues(alpha: 0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: cs.primary),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'پاشگەزبوونەوە',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: cs.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (existingNote != null)
              TextButton(
                onPressed: () {
                  ref.read(notesProvider.notifier).deleteNote(surahId, ayah.ayahNumber);
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'سڕینەوە',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                final content = textController.text.trim();
                if (content.isNotEmpty) {
                  ref.read(notesProvider.notifier).saveNote(
                        surahNumber: surahId,
                        ayahNumber: ayah.ayahNumber,
                        content: content,
                      );
                } else if (existingNote != null) {
                  ref.read(notesProvider.notifier).deleteNote(surahId, ayah.ayahNumber);
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'پاشەکەوت',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
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
