import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/sajdah_model.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/bookmarks_provider.dart';
import '../../core/providers/notes_provider.dart';
import '../../core/utils/quran_utils.dart';
import 'quran_providers.dart';
import 'providers/audio_player_provider.dart';
import 'widgets/share_card_sheet.dart';
import 'widgets/quran_settings_sheet.dart';
import '../../core/widgets/feature_not_available_dialog.dart';

import 'adapters/viewport_zoom_engine.dart';
import 'adapters/slide_page_turn_controller.dart';
import 'adapters/shared_preferences_mushaf_repository.dart';
import 'services/adaptive_cache_manager.dart';
import 'services/user_interaction_lock.dart';
import 'interfaces/mushaf_asset_provider.dart';
import 'providers/vector_mushaf_provider.dart';
import 'widgets/vector_mushaf_painter.dart';
import 'widgets/mushaf_svg_renderer.dart';

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

class _MushafReaderPageState extends ConsumerState<MushafReaderPage> with WidgetsBindingObserver {
  late PageController _pageController;
  int _currentPage = 1;
  bool _isInitialized = false;
  bool _isToolbarVisible = true;
  AyahModel? _selectedAyah;

  late ViewportZoomEngine _zoomEngine;
  late SlidePageTurnController _pageTurnController;
  late SharedPreferencesMushafRepository _settingsRepository;
  late MushafAssetProvider _assetProvider;
  final UserInteractionLock _interactionLock = UserInteractionLock();
  final AdaptiveCacheManager _cacheManager = AdaptiveCacheManager.detect();

  double _zoomScale = 1.0;
  bool? _lastWasDualPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _zoomEngine = ViewportZoomEngine();
    _zoomEngine.scaleNotifier.addListener(() {
      final double scale = _zoomEngine.scaleNotifier.value;
      if (scale != _zoomScale) {
        setState(() {
          _zoomScale = scale;
        });
        ref.read(mushafZoomProvider.notifier).setZoom(scale);
      }
    });
    _loadLastPage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _zoomEngine.dispose();
    _pageTurnController.dispose();
    _interactionLock.dispose();
    super.dispose();
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    _cacheManager.onMemoryPressure();
  }

  void _handleDoubleTapZoom() {
    _interactionLock.acquireLock();
    final target = _zoomScale > 1.0 ? 1.0 : 2.0;
    _zoomEngine.zoomTo(target);
    _interactionLock.releaseLock();
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    _settingsRepository = SharedPreferencesMushafRepository(prefs: prefs);
    _assetProvider = ref.read(mushafAssetProvider);

    int saved = 1;
    if (widget.initialPage != null) {
      saved = widget.initialPage!;
    } else {
      saved = await _settingsRepository.getLastReadPage();
    }

    if (mounted) {
      setState(() {
        _currentPage = saved.clamp(1, 604);
        final bool isDual = MediaQuery.of(context).size.width > 600;
        _lastWasDualPage = isDual;
        final int initialPageIdx = isDual ? (_currentPage ~/ 2) : (_currentPage - 1);
        _pageController = PageController(initialPage: initialPageIdx);
        _pageTurnController = SlidePageTurnController(pageController: _pageController);
        _isInitialized = true;
      });
    }
  }

  void _onPageChanged(int idx) {
    final bool isDual = MediaQuery.of(context).size.width > 600;
    setState(() {
      if (isDual) {
        _currentPage = (idx * 2 + 1).clamp(1, 604);
      } else {
        _currentPage = idx + 1;
      }
      _selectedAyah = null;
      _zoomScale = 1.0;
      _zoomEngine.resetZoom();
    });
    ref.read(mushafZoomProvider.notifier).setZoom(1.0);
    _settingsRepository.saveLastReadPage(_currentPage);
  }

  void _jumpToPage(int pageNumber) {
    final target = pageNumber.clamp(1, 604);
    setState(() {
      _currentPage = target;
      _selectedAyah = null;
    });
    _settingsRepository.saveLastReadPage(_currentPage);

    if (_pageController.hasClients) {
      final bool isDual = MediaQuery.of(context).size.width > 600;
      final int targetIndex = isDual ? (target ~/ 2) : (target - 1);
      _pageController.jumpToPage(targetIndex);
    }
  }

  Future<void> _scrollToPlayingAyah(int surahId, int ayahNumber) async {
    final isar = IsarService.instance.isar;
    final ayah = await isar.ayahCollections.filter()
        .surahNumberEqualTo(surahId)
        .ayahNumberEqualTo(ayahNumber)
        .findFirst();
    if (ayah != null && ayah.pageNumber != null) {
      final targetPage = ayah.pageNumber!;
      if (targetPage != _currentPage) {
        _jumpToPage(targetPage);
      }
    }
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

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDualPage = screenWidth > 600;

    // Dynamically rebuild the controller if layout orientation rotates.
    if (_lastWasDualPage != isDualPage) {
      _lastWasDualPage = isDualPage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            final int initialPageIdx = isDualPage ? (_currentPage ~/ 2) : (_currentPage - 1);
            _pageController.dispose();
            _pageTurnController.dispose();
            _pageController = PageController(initialPage: initialPageIdx);
            _pageTurnController = SlidePageTurnController(pageController: _pageController);
          });
        }
      });
    }

    // Dynamic Safe Auto-Paging listener.
    ref.listen(audioPlayerProvider, (previous, next) {
      if (next.currentAyahNumber != null &&
          next.currentAyahNumber != previous?.currentAyahNumber) {
        if (next.isAutoScrollEnabled) {
          _interactionLock.executeSafe(() {
            _scrollToPlayingAyah(next.session.currentSurahId, next.currentAyahNumber!);
          });
        }
      }
    });

    final zoom = ref.watch(mushafZoomProvider);
    if (zoom != _zoomScale) {
      _zoomScale = zoom;
      _zoomEngine.zoomTo(_zoomScale);
    }

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
                _interactionLock.acquireLock();
                setState(() {
                  _isToolbarVisible = !_isToolbarVisible;
                });
                _interactionLock.releaseLock();
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: isDualPage ? 303 : 604,
                reverse: true, // Right-to-Left page turns
                onPageChanged: _onPageChanged,
                physics: _zoomScale > 1.0 ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (isDualPage) {
                    final int leftPageNum = index * 2;
                    final int rightPageNum = index * 2 + 1;

                    return GestureDetector(
                      onDoubleTap: _handleDoubleTapZoom,
                      child: InteractiveViewer(
                        transformationController: _zoomEngine.controller,
                        minScale: 1.0,
                        maxScale: 3.0,
                        clipBehavior: Clip.none,
                        onInteractionStart: (_) {
                          _interactionLock.acquireLock();
                        },
                        onInteractionEnd: (_) {
                          _interactionLock.releaseLock();
                        },
                        onInteractionUpdate: (details) {
                          _zoomEngine.updatePosition(Offset.zero);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: leftPageNum > 0
                                  ? MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                        textScaler: TextScaler.noScaling,
                                      ),
                                      child: _buildMushafPage(leftPageNum, cs, pageCard, pageText, pageTextSecondary, pageBorder, settings),
                                    )
                                  : Container(color: pageBg),
                            ),
                            VerticalDivider(width: 1, color: pageBorder.withValues(alpha: 0.3)),
                            Expanded(
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(
                                  textScaler: TextScaler.noScaling,
                                ),
                                child: _buildMushafPage(rightPageNum, cs, pageCard, pageText, pageTextSecondary, pageBorder, settings),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final pageNum = index + 1;
                    return GestureDetector(
                      onDoubleTap: _handleDoubleTapZoom,
                      child: InteractiveViewer(
                        transformationController: _zoomEngine.controller,
                        minScale: 1.0,
                        maxScale: 3.0,
                        clipBehavior: Clip.none,
                        onInteractionStart: (_) {
                          _interactionLock.acquireLock();
                        },
                        onInteractionEnd: (_) {
                          _interactionLock.releaseLock();
                        },
                        onInteractionUpdate: (details) {
                          _zoomEngine.updatePosition(Offset.zero);
                        },
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            textScaler: TextScaler.noScaling,
                          ),
                          child: _buildMushafPage(pageNum, cs, pageCard, pageText, pageTextSecondary, pageBorder, settings),
                        ),
                      ),
                    );
                  }
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
              child: AnimatedOpacity(
                opacity: _isToolbarVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
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
          ),

          // ── Elegant Printed Mushaf Labels (Footer) ──
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _isToolbarVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
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
        color: cs.card,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: cs.cardBorder.withValues(alpha: 0.8), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
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
    );
  }

  Widget _buildHeaderBar(AppColorScheme cs, Color bg, Color text) {
    final asyncVal = ref.watch(pageAyahsProvider(_currentPage));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    String headerMeta = 'باری لاپەڕە...';
    asyncVal.whenData((list) {
      if (list.isNotEmpty) {
        final first = list.first;
        final isKu = Localizations.localeOf(context).languageCode == 'ku';
        final uniqueSurahs = list.map((a) => (isKu ? a.surah?.nameKu : a.surah?.nameEn) ?? '').toSet().join(' / ');
        headerMeta = 'جزء ${first.juzNumber ?? 1} — سورەتی $uniqueSurahs';
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: cs.card,
        border: Border(
          bottom: BorderSide(color: cs.cardBorder.withValues(alpha: 0.8), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                icon: Icon(
                  ref.watch(pageBookmarksProvider).contains(_currentPage)
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: ref.watch(pageBookmarksProvider).contains(_currentPage)
                      ? const Color(0xFFCD9D27)
                      : text,
                  size: 22,
                ),
                onPressed: () {
                  ref.read(pageBookmarksProvider.notifier).toggle(_currentPage);
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
    );
  }

  Widget _buildMushafPage(int pageNum, AppColorScheme cs, Color cardBg, Color textPrimary, Color textSecondary, Color cardBorder, ReaderSettings settings) {
    return FutureBuilder<MushafPageAsset>(
      future: _assetProvider.getPageAsset(pageNum),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerSkeleton(cardBg, cardBorder, textSecondary);
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                const SizedBox(height: 12),
                Text(
                  snapshot.error.toString().replaceAll('Exception: ', ''),
                  style: TextStyle(fontFamily: 'Cairo', color: textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  style: ElevatedButton.styleFrom(backgroundColor: cs.primary),
                  child: const Text('دووبارە هەوڵبدەرەوە', style: TextStyle(fontFamily: 'Cairo')),
                ),
              ],
            ),
          );
        }

        final asset = snapshot.data!;
        return Consumer(
          builder: (context, ref, _) {
            final coordinatesAsync = ref.watch(pageCoordinatesProvider(pageNum));
            final pageAyahsAsync = ref.watch(pageAyahsProvider(pageNum));
            final geometry = ref.watch(pageGeometryProvider);

            return coordinatesAsync.when(
              data: (coordinates) {
                final pageAyahs = pageAyahsAsync.valueOrNull ?? [];
                final playerState = ref.watch(audioPlayerProvider);
                final baseDimensions = geometry.getBaseDimensions(pageNum);
                final aspectRatio = geometry.getAspectRatio(pageNum);

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    8,
                    MediaQuery.of(context).padding.top + kToolbarHeight + 4,
                    8,
                    72,
                  ),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: GestureDetector(
                        onTapUp: (details) {
                          final RenderBox? box = context.findRenderObject() as RenderBox?;
                          if (box == null) return;
                          
                          final tappedAyah = VectorMushafPainter.findAyahByOffset(
                            details.localPosition,
                            box.size,
                            baseDimensions,
                            coordinates,
                          );

                          if (tappedAyah != null) {
                            final match = pageAyahs.firstWhere(
                              (a) => a.surah?.number == tappedAyah.surahNumber && a.ayahNumber == tappedAyah.ayahNumber,
                              orElse: () => pageAyahs.firstWhere((a) => a.ayahNumber == tappedAyah.ayahNumber, orElse: () => pageAyahs.first),
                            );
                            setState(() {
                              if (_selectedAyah?.id == match.id) {
                                _selectedAyah = null;
                              } else {
                                _selectedAyah = match;
                              }
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: buildMushafSvg(
                                asset.localFile,
                                pageNum.toString().padLeft(3, '0'),
                                BoxFit.fill,
                              ),
                            ),
                            Positioned.fill(
                              child: CustomPaint(
                                painter: VectorMushafPainter(
                                  coordinates: coordinates,
                                  selectedAyahNumber: _selectedAyah?.ayahNumber,
                                  selectedSurahNumber: _selectedAyah?.surah?.number,
                                  playingAyahNumber: playerState.isPlaying ? playerState.currentAyahNumber : null,
                                  playingSurahNumber: playerState.isPlaying ? playerState.session.currentSurahId : null,
                                  highlightColor: cs.primary.withValues(alpha: 0.18),
                                  playingHighlightColor: cs.primary.withValues(alpha: 0.1),
                                  baseDimensions: baseDimensions,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => _buildShimmerSkeleton(cardBg, cardBorder, textSecondary),
              error: (err, _) => Center(
                child: Text(
                  'کێشەی بارکردنی پۆوتانەکان: ${err.toString()}',
                  style: TextStyle(fontFamily: 'Cairo', color: textSecondary),
                ),
              ),
            );
          },
        );
      },
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
    final isFavorited = favorites.any((f) => f.favoriteId == 'ayah_${ayah.surah?.id ?? 1}_${ayah.ayahNumber}');
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
                  '${(Localizations.localeOf(context).languageCode == 'ku' ? ayah.surah?.nameKu : ayah.surah?.nameEn) ?? ""} : ${ayah.ayahNumber}',
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
                stripHtmlTags(ayah.textEn!),
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
                    showFeatureUnderDevelopmentDialog(
                      context,
                      messageKu: 'ئەم تایبەتمەندییە (خوێندنەوەی دەنگی قورئانخوێنەکان) لە ئێستادا کاری لەسەر دەکرێت بۆیە بەردەست نییە. سوپاس بۆ ئارامگریت.',
                      messageAr: 'هذه الميزة (أصوات القراء) قيد التطوير حالياً وليست متوفرة. شكراً لصبركم.',
                      messageEn: 'This feature (reciters audio) is currently under development and is not available. Thank you for your patience.',
                    );
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
                'ئایەتی ${ayah.ayahNumber} لە سورەتی ${(Localizations.localeOf(context).languageCode == 'ku' ? ayah.surah?.nameKu : ayah.surah?.nameEn) ?? ""}',
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
