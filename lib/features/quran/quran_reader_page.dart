import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/surah_model.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/bookmarks_provider.dart';
import '../../core/utils/responsive.dart';
import 'quran_providers.dart';
import 'widgets/audio_player_panel.dart';
import 'providers/audio_player_provider.dart';
import 'widgets/share_card_sheet.dart';

class QuranReaderPage extends ConsumerStatefulWidget {
  final SurahModel surah;
  final int? initialAyahNumber;

  const QuranReaderPage({
    super.key,
    required this.surah,
    this.initialAyahNumber,
  });

  @override
  ConsumerState<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends ConsumerState<QuranReaderPage> {
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _ayahKeys = {};
  bool _scrolled = false;
  Timer? _debounceTimer;
  Timer? _scrollTrackTimer;
  double _lastOffset = 0.0;
  bool _isHeaderVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(readingTrackerProvider.notifier).trackRead(
              widget.surah.id,
              widget.surah.nameEn,
              widget.initialAyahNumber ?? 1,
              secondsSpent: 1,
            );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _scrollTrackTimer?.cancel();
    ref.read(audioPlayerProvider.notifier).pause();
    super.dispose();
  }

  void _onScroll() {
    _scrollTrackTimer?.cancel();
    _scrollTrackTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _trackVisibleAyah();
    });

    final readerSettings = ref.read(readerSettingsProvider);
    if (!readerSettings.distractionFree) return;

    final currentOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final minScroll = _scrollController.position.minScrollExtent;

    if (currentOffset <= minScroll + 50) {
      if (!_isHeaderVisible) {
        setState(() {
          _isHeaderVisible = true;
        });
      }
      _lastOffset = currentOffset;
      return;
    }

    if (currentOffset >= maxScroll - 50) {
      if (!_isHeaderVisible) {
        setState(() {
          _isHeaderVisible = true;
        });
      }
      _lastOffset = currentOffset;
      return;
    }

    final delta = currentOffset - _lastOffset;
    if (delta.abs() > 10) {
      if (delta > 0 && _isHeaderVisible) {
        setState(() {
          _isHeaderVisible = false;
        });
      } else if (delta < 0 && !_isHeaderVisible) {
        setState(() {
          _isHeaderVisible = true;
        });
      }
      _lastOffset = currentOffset;
    }
  }

  void _trackVisibleAyah() {
    try {
      final middleY = MediaQuery.of(context).size.height / 2;
      int? visibleAyah;
      for (final entry in _ayahKeys.entries) {
        final keyContext = entry.value.currentContext;
        if (keyContext != null) {
          final box = keyContext.findRenderObject() as RenderBox?;
          if (box != null) {
            final position = box.localToGlobal(Offset.zero);
            final height = box.size.height;
            if (position.dy <= middleY && position.dy + height >= middleY) {
              visibleAyah = entry.key;
              break;
            }
          }
        }
      }

      if (visibleAyah != null) {
        ref.read(readingTrackerProvider.notifier).trackRead(
              widget.surah.id,
              widget.surah.nameEn,
              visibleAyah,
              secondsSpent: 2,
            );
      }
    } catch (_) {}
  }

  void _scrollToMatch(String query, List<AyahModel> ayahs) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return;

    final matchedIndex = ayahs.indexWhere((ayah) {
      return ayah.ayahNumber.toString() == q;
    });

    if (matchedIndex != -1) {
      final showBismillah = widget.surah.number != 1 && widget.surah.number != 9;
      final listIndex = matchedIndex + (showBismillah ? 1 : 0);

      // Estimate offset (approx. 200.0 px per Ayah card)
      final estimatedOffset = listIndex * 200.0;

      // Scroll to approximate location first
      _scrollController.animateTo(
        estimatedOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      ).then((_) {
        // Precise scroll to ensure the widget is centered in context
        Future.delayed(const Duration(milliseconds: 80), () {
          final matchedAyah = ayahs[matchedIndex];
          final targetKey = _ayahKeys[matchedAyah.ayahNumber];
          if (targetKey != null && targetKey.currentContext != null) {
            Scrollable.ensureVisible(
              targetKey.currentContext!,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      });
    }
  }

  void _scrollToAyah(int ayahNumber, List<AyahModel> ayahs) {
    final matchedIndex = ayahs.indexWhere((ayah) => ayah.ayahNumber == ayahNumber);
    if (matchedIndex != -1) {
      final targetKey = _ayahKeys[ayahNumber];
      if (targetKey != null && targetKey.currentContext != null) {
        Scrollable.ensureVisible(
          targetKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _showSettingsBottomSheet(BuildContext context) {
    final cs = AppColorScheme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final readerSettings = ref.watch(readerSettingsProvider);
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
                      'ڕێکخستنی خوێندنەوە',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: cs.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'قەبارەی فۆنت',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: cs.textPrimary,
                          ),
                        ),
                        Text(
                          '${readerSettings.fontSize.round()}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: readerSettings.fontSize,
                      min: 12,
                      max: 28,
                      divisions: 8,
                      activeColor: cs.primary,
                      inactiveColor: cs.primary.withValues(alpha: 0.15),
                      onChanged: (v) {
                        ref.read(readerSettingsProvider.notifier).setFontSize(v);
                      },
                    ),
                    const SizedBox(height: 12),
                    Divider(color: cs.cardBorder),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.translate_rounded,
                                size: 20, color: cs.primary),
                            const SizedBox(width: 12),
                            Text(
                              'وەرگێڕانی کوردی',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: cs.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: readerSettings.showKurdish,
                          activeThumbColor: cs.primary,
                          onChanged: (v) {
                            ref.read(readerSettingsProvider.notifier).toggleKurdish(v);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language_rounded,
                                size: 20, color: cs.primary),
                            const SizedBox(width: 12),
                            Text(
                              'وەرگێڕانی ئینگلیزی',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: cs.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: readerSettings.showEnglish,
                          activeThumbColor: cs.primary,
                          onChanged: (v) {
                            ref.read(readerSettingsProvider.notifier).toggleEnglish(v);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: cs.cardBorder),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.visibility_off_rounded,
                                  size: 20, color: cs.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.l10n.settingsDistractionFree,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: cs.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      context.l10n.settingsDistractionFreeSub,
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
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: readerSettings.distractionFree,
                          activeThumbColor: cs.primary,
                          onChanged: (v) {
                            ref.read(readerSettingsProvider.notifier).toggleDistractionFree(v);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final p = Responsive.pagePadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final ayahsAsync = ref.watch(ayahsProvider(widget.surah.id));
    final bookmarks = ref.watch(bookmarksProvider);
    final favorites = ref.watch(favoritesProvider);
    final readerSettings = ref.watch(readerSettingsProvider);
    final playerState = ref.watch(audioPlayerProvider);

    ref.listen(audioPlayerProvider, (previous, next) {
      if (next.currentAyahNumber != null &&
          next.currentAyahNumber != previous?.currentAyahNumber) {
        if (next.isAutoScrollEnabled) {
          ayahsAsync.whenData((list) {
            _scrollToAyah(next.currentAyahNumber!, list);
          });
        }
        ref.read(readingTrackerProvider.notifier).trackRead(
              widget.surah.id,
              widget.surah.nameEn,
              next.currentAyahNumber!,
              secondsSpent: 3,
            );
      }
    });

    final showBismillah = widget.surah.number != 1 && widget.surah.number != 9;

    return Scaffold(
      backgroundColor: cs.bg,
      body: Column(
        children: [
          // Collapsible Top Header (AppBar + Surah Info Banner)
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isHeaderVisible
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Custom AppBar
                        Container(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                          color: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
                          height: kToolbarHeight + MediaQuery.of(context).padding.top,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(
                                widget.surah.nameEn,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.tune_rounded, color: Colors.white),
                                onPressed: () => _showSettingsBottomSheet(context),
                              ),
                            ],
                          ),
                        ),
                        // ── Surah Info Banner ─────────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(p, 16, p, 24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [AppColorScheme.darken(cs.primary, 0.35), AppColorScheme.darken(cs.primary, 0.42)]
                                  : [cs.primary, cs.primaryDeep],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: [
                              Hero(
                                tag: 'surah-ar-${widget.surah.number}',
                                child: Text(
                                  widget.surah.nameAr,
                                  style: const TextStyle(
                                    fontFamily: 'UthmanicHafs',
                                    fontSize: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag: 'surah-num-${widget.surah.number}',
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${widget.surah.number}',
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${widget.surah.totalAyahs} ${l.quranAyahs}',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Colors.white54,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    widget.surah.isMeccan ? l.quranMeccan : l.quranMedinan,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                              if (widget.surah.totalAyahs > 30) ...[
                                const SizedBox(height: 16),
                                Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (v) {
                                      setState(() {
                                        _searchQuery = v;
                                      });
                                      // Debounce search scroll action by 500ms
                                      _debounceTimer?.cancel();
                                      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                                        ayahsAsync.whenData((list) => _scrollToMatch(v, list));
                                      });
                                    },
                                    onSubmitted: (v) {
                                      _debounceTimer?.cancel();
                                      ayahsAsync.whenData((list) => _scrollToMatch(v, list));
                                    },
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'گەڕان بەپێی دەق یان ژمارەی ئایەت...',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: Colors.white.withValues(alpha: 0.7),
                                        size: 18,
                                      ),
                                      suffixIcon: _searchQuery.isNotEmpty
                                          ? GestureDetector(
                                              onTap: () {
                                                _searchController.clear();
                                                setState(() {
                                                  _searchQuery = '';
                                                });
                                              },
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: Colors.white.withValues(alpha: 0.7),
                                                size: 16,
                                              ),
                                            )
                                          : null,
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // ── Ayahs list ────────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _isHeaderVisible = !_isHeaderVisible;
                });
              },
              child: ayahsAsync.when(
              data: (ayahs) {
                // Scroll to index on load if from bookmarks
                if (widget.initialAyahNumber != null && !_scrolled) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final targetKey = _ayahKeys[widget.initialAyahNumber];
                    if (targetKey != null && targetKey.currentContext != null) {
                      Scrollable.ensureVisible(
                        targetKey.currentContext!,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                      setState(() {
                        _scrolled = true;
                      });
                    }
                  });
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(p, 16, p, 40),
                  physics: const BouncingScrollPhysics(),
                  itemCount: ayahs.length + (showBismillah ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (showBismillah && index == 0) {
                      return const _BismillahBanner()
                          .animate()
                          .fadeIn(duration: 400.ms);
                    }

                    final ayahIndex = showBismillah ? index - 1 : index;
                    final ayah = ayahs[ayahIndex];

                    final isBookmarked = bookmarks.any((b) =>
                        b.surahId == widget.surah.id &&
                        b.ayahNumber == ayah.ayahNumber);

                    final isFavorited = favorites.any((f) =>
                        f.surahId == widget.surah.id &&
                        f.ayahNumber == ayah.ayahNumber);

                    // Check if this ayah matches the search query to highlight it
                    final isHighlighted = _searchQuery.trim().isNotEmpty &&
                      ayah.ayahNumber.toString() == _searchQuery.trim();

                    final key = _ayahKeys.putIfAbsent(ayah.ayahNumber, () => GlobalKey());

                    return _AyahRow(
                      key: key,
                      ayah: ayah,
                      surah: widget.surah,
                      fontSize: readerSettings.fontSize,
                      showKurdish: readerSettings.showKurdish,
                      showEnglish: readerSettings.showEnglish,
                      isBookmarked: isBookmarked,
                      isFavorited: isFavorited,
                      isHighlighted: isHighlighted || (playerState.currentAyahNumber == ayah.ayahNumber),
                      cs: cs,
                      onBookmark: () {
                        ref.read(bookmarksProvider.notifier).toggle(
                              LocalBookmark(
                                surahId: widget.surah.id,
                                surahName: widget.surah.nameEn,
                                ayahNumber: ayah.ayahNumber,
                                preview: ayah.textUthmani,
                              ),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isBookmarked
                                  ? 'ئایەتەکە لە لیستەکە لادرا'
                                  : 'ئایەتەکە پارێزرا لە لیستەکەتدا',
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      onFavorite: () {
                        ref.read(favoritesProvider.notifier).toggle(
                              LocalFavorite(
                                surahId: widget.surah.id,
                                surahName: widget.surah.nameEn,
                                ayahNumber: ayah.ayahNumber,
                                textUthmani: ayah.textUthmani,
                                textKu: ayah.textKu,
                                textEn: ayah.textEn,
                              ),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorited
                                  ? 'ئایەتەکە لە دڵخوازەکان لادرا'
                                  : 'ئایەتەکە بە دڵخواز کرا',
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      onShare: () {
                        showShareCardSheet(
                          context,
                          ShareAyahData.fromAyahModel(ayah, widget.surah.nameEn),
                        );
                      },
                    ).animate().fadeIn(
                          duration: 250.ms,
                          delay: Duration(milliseconds: 30 * (index % 10)),
                        );
                  },
                );
              },
              loading: () => _AyahsSkeleton(padding: p, cs: cs),
              error: (err, _) => _AyahsErrorState(
                message: err.toString().replaceAll('Exception: ', ''),
                cs: cs,
                onRetry: () => ref.refresh(ayahsProvider(widget.surah.id)),
              ),
            ),
          ),
        ),
      ],
    ),
      bottomNavigationBar: ClipRect(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isHeaderVisible
              ? AudioPlayerPanel(surahId: widget.surah.id)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _BismillahBanner extends StatelessWidget {
  const _BismillahBanner();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = AppColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 8),
      alignment: Alignment.center,
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: 24,
          color: isDark ? cs.primary : cs.primaryDeep,
        ),
      ),
    );
  }
}

class _AyahRow extends StatelessWidget {
  final AyahModel ayah;
  final SurahModel surah;
  final double fontSize;
  final bool showKurdish;
  final bool showEnglish;
  final bool isBookmarked;
  final bool isFavorited;
  final bool isHighlighted;
  final AppColorScheme cs;
  final VoidCallback onBookmark;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const _AyahRow({
    super.key,
    required this.ayah,
    required this.surah,
    required this.fontSize,
    required this.showKurdish,
    required this.showEnglish,
    required this.isBookmarked,
    required this.isFavorited,
    required this.isHighlighted,
    required this.cs,
    required this.onBookmark,
    required this.onFavorite,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isHighlighted
            ? (isDark ? cs.primary.withValues(alpha: 0.15) : cs.primary.withValues(alpha: 0.1))
            : null,
        borderRadius: isHighlighted ? BorderRadius.circular(16) : null,
        border: Border(
          bottom: BorderSide(
            color: isHighlighted
                ? cs.primary
                : cs.cardBorder.withValues(alpha: 0.4),
            width: isHighlighted ? 1.5 : 0.8,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${ayah.ayahNumber}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorited
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 20,
                      color: isFavorited ? const Color(0xFFE6A23C) : cs.textSecondary,
                    ),
                    onPressed: onFavorite,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 18,
                      color: isBookmarked ? AppColors.accentGoldDeep : cs.textSecondary,
                    ),
                    onPressed: onBookmark,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(Icons.share_rounded, size: 18, color: cs.textSecondary),
                    onPressed: onShare,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ayah.textUthmani,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: fontSize + 4,
              height: 2.0,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          if (showKurdish && ayah.textKu != null && ayah.textKu!.isNotEmpty) ...[
            Text(
              ayah.textKu!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize - 2,
                height: 1.6,
                color: cs.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (showEnglish && ayah.textEn != null && ayah.textEn!.isNotEmpty) ...[
            Text(
              ayah.textEn!,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize - 3,
                height: 1.5,
                color: cs.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AyahsSkeleton extends StatelessWidget {
  final double padding;
  final AppColorScheme cs;

  const _AyahsSkeleton({required this.padding, required this.cs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: cs.textSecondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 24,
              decoration: BoxDecoration(
                color: cs.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 20,
              width: 150,
              decoration: BoxDecoration(
                color: cs.textSecondary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 1200.ms,
            color: cs.cardBorder.withValues(alpha: 0.15),
          ),
    );
  }
}

class _AyahsErrorState extends StatelessWidget {
  final String message;
  final AppColorScheme cs;
  final VoidCallback onRetry;

  const _AyahsErrorState({
    required this.message,
    required this.cs,
    required this.onRetry,
  });

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

