import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/sajdah_model.dart';
import '../../core/models/surah_model.dart';
import '../../core/services/tajweed_engine.dart';
import '../../core/models/tajweed_segment_model.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/local_db/isar_service.dart';
import 'package:flutter/rendering.dart';
import 'package:isar/isar.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/bookmarks_provider.dart';

import '../../core/utils/responsive.dart';
import '../../core/utils/quran_utils.dart';
import 'quran_providers.dart';
import 'widgets/audio_player_panel.dart';
import 'providers/audio_player_provider.dart';
import 'widgets/share_card_sheet.dart';
import 'widgets/tafsir_sheet.dart';
import 'mushaf_reader_page.dart';
import 'widgets/quran_settings_sheet.dart';
import '../../core/widgets/feature_not_available_dialog.dart';

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
      // reading tracker removed in v1.0.4
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _scrollTrackTimer?.cancel();
    try {
      ref.read(audioPlayerProvider.notifier).pause();
    } catch (_) {}
    super.dispose();
  }

  void _onScroll() {
    _scrollTrackTimer?.cancel();
    _scrollTrackTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _trackVisibleAyah();
    });

    final readerSettings = ref.read(readerSettingsProvider);
    if (readerSettings.distractionFree != true) return;

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
        // reading tracker removed in v1.0.4
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

  void _showSettingsBottomSheet(BuildContext context, AsyncValue<List<AyahModel>> ayahsAsync) {
    QuranSettingsSheet.show(
      context,
      surahId: widget.surah.id,
      isMushaf: false,
      onJumpToPage: (page) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MushafReaderPage(initialPage: page)),
        );
      },
      onJumpToSurah: (surah) {
        if (surah.id != widget.surah.id) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => QuranReaderPage(surah: surah)),
          );
        }
      },
      onJumpToAyah: (ayahNum) {
        ayahsAsync.whenData((list) => _scrollToAyah(ayahNum, list));
      },
    );
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
                          b.surahId == widget.surah.id &&
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
                                surahId: widget.surah.id,
                                surahName: widget.surah.nameEn,
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

  void _showAyahActionSheet(BuildContext context, AyahModel ayah, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final bookmarks = ref.read(bookmarksProvider);
    final favorites = ref.read(favoritesProvider);
    final isBookmarked = bookmarks.any((b) => b.surahId == widget.surah.id && b.ayahNumber == ayah.ayahNumber);
    final isFavorited = favorites.any((f) => f.favoriteId == 'ayah_${widget.surah.id}_${ayah.ayahNumber}');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
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
                  'ئایەتی ${ayah.ayahNumber}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Icons.play_arrow_rounded,
                      label: 'خوێندنەوە',
                      color: cs.primary,
                      onTap: () {
                        Navigator.pop(ctx);
                        showFeatureUnderDevelopmentDialog(
                          context,
                          messageKu: 'ئەم تایبەتمەندییە (خوێندنەوەی دەنگی قورئانخوێنەکان) لە ئێستادا کاری لەسەر دەکرێت بۆیە بەردەست نییە. سوپاس بۆ ئارامگریت.',
                          messageAr: 'هذه الميزة (أصوات القراء) قيد التطوير حالياً وليست متوفرة. شكراً لصبركم.',
                          messageEn: 'This feature (reciters audio) is currently under development and is not available. Thank you for your patience.',
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      label: 'نیشانە',
                      color: isBookmarked ? AppColors.accentGoldDeep : cs.textSecondary,
                      onTap: () {
                        Navigator.pop(ctx);
                        _showBookmarkCategoryPicker(context, ayah);
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
                      label: 'دڵخواز',
                      color: isFavorited ? const Color(0xFFE6A23C) : cs.textSecondary,
                      onTap: () {
                        Navigator.pop(ctx);
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
                              isFavorited ? 'ئایەتەکە لە دڵخوازەکان لادرا' : 'ئایەتەکە بە دڵخواز کرا',
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
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.share_rounded,
                      label: 'بڵاوکردنەوە',
                      color: cs.textSecondary,
                      onTap: () {
                        Navigator.pop(ctx);
                        showShareCardSheet(
                          context,
                          ShareAyahData.fromAyahModel(ayah, widget.surah.nameEn),
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.menu_book_rounded,
                      label: 'تەفسیر',
                      color: cs.primary,
                      onTap: () {
                        Navigator.pop(ctx);
                        TafsirSheet.show(
                          context,
                          surahNumber: widget.surah.number,
                          ayahNumber: ayah.ayahNumber,
                          surahName: widget.surah.nameKu,
                          arabicText: ayah.textUthmani,
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.copy_rounded,
                      label: 'کۆپی دەق',
                      color: cs.textSecondary,
                      onTap: () {
                        Navigator.pop(ctx);
                        final messenger = ScaffoldMessenger.of(context);
                        Clipboard.setData(ClipboardData(text: '${ayah.textUthmani}\n\n${ayah.textKu ?? ''}')).then((_) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: const Text(
                                'دەقی ئایەتەکە کۆپی کرا',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontFamily: 'Cairo'),
                              ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        });
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
  }



  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final cs = AppColorScheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cs.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHeader(
    BuildContext context,
    AppColorScheme cs,
    bool isDark,
    double p,
    AsyncValue<List<AyahModel>> ayahsAsync,
    double height,
  ) {
    final surahs = ref.watch(surahListProvider).valueOrNull ?? [];
    final prevSurah = widget.surah.number > 1
        ? surahs.firstWhere((s) => s.number == widget.surah.number - 1, orElse: () => widget.surah)
        : null;
    final nextSurah = widget.surah.number < 114
        ? surahs.firstWhere((s) => s.number == widget.surah.number + 1, orElse: () => widget.surah)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: cs.bg.withValues(alpha: isDark ? 0.82 : 0.88),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Custom AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.textPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                      
                      // Surah title with Prev/Next buttons
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (prevSurah != null)
                              IconButton(
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                                icon: Icon(Icons.chevron_left_rounded, color: cs.textPrimary),
                                tooltip: 'سورەتی پێشوو',
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuranReaderPage(surah: prevSurah),
                                    ),
                                  );
                                },
                              )
                            else
                              const SizedBox(width: 32),
                            Flexible(
                              child: Text(
                                Localizations.localeOf(context).languageCode == 'ku' ? widget.surah.nameKu : widget.surah.nameEn,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: cs.textPrimary,
                                ),
                              ),
                            ),
                            if (nextSurah != null)
                              IconButton(
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                                icon: Icon(Icons.chevron_right_rounded, color: cs.textPrimary),
                                tooltip: 'سورەتی داهاتوو',
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuranReaderPage(surah: nextSurah),
                                    ),
                                  );
                                },
                              )
                            else
                              const SizedBox(width: 32),
                          ],
                        ),
                      ),
  
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tooltip(
                            message: 'قورئانخوێنەکان',
                            child: IconButton(
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.mic_rounded, color: cs.textPrimary),
                              onPressed: () {
                                showFeatureUnderDevelopmentDialog(
                                  context,
                                  messageKu: 'ئەم تایبەتمەندییە (خوێندنەوەی دەنگی قورئانخوێنەکان) لە ئێستادا کاری لەسەر دەکرێت بۆیە بەردەست نییە. سوپاس بۆ ئارامگریت.',
                                  messageAr: 'هذه الميزة (أصوات القراء) قيد التطوير حالياً وليست متوفرة. شكراً لصبركم.',
                                  messageEn: 'This feature (reciters audio) is currently under development and is not available. Thank you for your patience.',
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          Tooltip(
                            message: 'مۆدی موسحەف',
                            child: IconButton(
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              icon: Icon(Icons.menu_book_rounded, color: cs.textPrimary),
                              onPressed: () {
                                final int? surahStartPage = ayahsAsync.valueOrNull
                                    ?.firstOrNull
                                    ?.pageNumber ?? widget.surah.pageStart;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MushafReaderPage(
                                      initialPage: surahStartPage,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.tune_rounded, color: cs.textPrimary),
                            onPressed: () => _showSettingsBottomSheet(context, ayahsAsync),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ── Surah Info Banner (Search) ──
                if (widget.surah.totalAyahs > 30)
                  Padding(
                    padding: EdgeInsets.fromLTRB(p, 4, p, 16),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: cs.bg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: cs.cardBorder,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) {
                          setState(() {
                            _searchQuery = v;
                          });
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
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: cs.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'گەڕان بەپێی دەق یان ژمارەی ئایەت...',
                          hintStyle: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: cs.textSecondary.withValues(alpha: 0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: cs.textSecondary.withValues(alpha: 0.7),
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
                                    color: cs.textSecondary,
                                    size: 16,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
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
        // reading tracker removed in v1.0.4
      }
    });

    final showBismillah = widget.surah.number != 1 && widget.surah.number != 9;
    final topPadding = MediaQuery.of(context).padding.top;
    final topOffset = topPadding + 140.0 + (widget.surah.totalAyahs > 30 ? 58.0 : 0.0);
    final bottomOffset = MediaQuery.of(context).padding.bottom + 96.0;

    final bool isHeaderCurrentlyVisible = (readerSettings.distractionFree != true) || _isHeaderVisible;

    return Scaffold(
      backgroundColor: cs.bg,
      body: Stack(
        children: [
          // ── Ayahs list ──
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (readerSettings.distractionFree == true) {
                  setState(() {
                    _isHeaderVisible = !_isHeaderVisible;
                  });
                }
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
                    padding: EdgeInsets.fromLTRB(p, topOffset, p, bottomOffset),
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
                          f.favoriteId == 'ayah_${widget.surah.id}_${ayah.ayahNumber}');

                      final isHighlighted = _searchQuery.trim().isNotEmpty &&
                        ayah.ayahNumber.toString() == _searchQuery.trim();

                      final key = _ayahKeys.putIfAbsent(ayah.ayahNumber, () => GlobalKey());

                      return _AyahRow(
                        key: key,
                        ayah: ayah,
                        surah: widget.surah,
                        fontSize: readerSettings.fontSize,
                        showKurdish: readerSettings.showKurdish == true,
                        showEnglish: readerSettings.showEnglish == true,
                        showTajweed: readerSettings.showTajweed == true,
                        isBookmarked: isBookmarked,
                        isFavorited: isFavorited,
                        isHighlighted: isHighlighted || (playerState.currentAyahNumber == ayah.ayahNumber),
                        cs: cs,
                        onTap: () => _showAyahActionSheet(context, ayah, ref),
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

          // ── Floating Top AppBar ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: isHeaderCurrentlyVisible ? 0 : -topOffset - 20,
            left: 0,
            right: 0,
            child: _buildFloatingHeader(context, cs, isDark, p, ayahsAsync, topOffset),
          ),

          // ── Floating Bottom Audio Panel ──
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: (playerState.currentAyahNumber != null || playerState.isPlaying || playerState.isLoading) && isHeaderCurrentlyVisible ? 0 : -140,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AudioPlayerPanel(surahId: widget.surah.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BismillahBanner extends ConsumerWidget {
  const _BismillahBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = AppColorScheme.of(context);
    // Use AmiriQuran for Quran text (Arabic), loaded lazily
    const quranFont = 'AmiriQuran';

    return Container(
      margin: const EdgeInsets.only(bottom: 24, top: 8),
      alignment: Alignment.center,
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        style: TextStyle(
          fontFamily: quranFont,
          fontSize: 24,
          color: isDark ? cs.primary : cs.primaryDeep,
        ),
      ),
    );
  }
}

// _AyahRow watches inactiveTajweedRulesProvider directly so any rule
// toggle from TajweedPage immediately re-renders every visible ayah,
// bypassing ListView.builder's element cache.
class _AyahRow extends ConsumerWidget {
  final AyahModel ayah;
  final SurahModel surah;
  final double fontSize;
  final bool showKurdish;
  final bool showEnglish;
  final bool showTajweed;
  final bool isBookmarked;
  final bool isFavorited;
  final bool isHighlighted;
  final AppColorScheme cs;
  final VoidCallback onTap;

  const _AyahRow({
    super.key,
    required this.ayah,
    required this.surah,
    required this.fontSize,
    required this.showKurdish,
    required this.showEnglish,
    required this.showTajweed,
    required this.isBookmarked,
    required this.isFavorited,
    required this.isHighlighted,
    required this.cs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readerSettings = ref.watch(readerSettingsProvider);
    // Use AmiriQuran for Quran text (Arabic), loaded lazily
    const quranFont = 'AmiriQuran';
    final inactiveRules = ref.watch(inactiveTajweedRulesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sajdah = SajdahModel.list.cast<SajdahModel?>().firstWhere(
      (s) => s?.surahId == surah.id && s?.ayahNumber == ayah.ayahNumber,
      orElse: () => null,
    );



    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isHighlighted
              ? (isDark ? cs.primary.withValues(alpha: 0.12) : cs.primary.withValues(alpha: 0.08))
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(
              color: isHighlighted
                  ? cs.primary
                  : cs.cardBorder.withValues(alpha: 0.3),
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
                Row(
                  mainAxisSize: MainAxisSize.min,
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
                    if (sajdah != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: sajdah.isObligatory ? Colors.red.withValues(alpha: 0.1) : cs.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: sajdah.isObligatory ? Colors.red.withValues(alpha: 0.3) : cs.primary.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '${context.l10n.sajdah} (${sajdah.isObligatory ? context.l10n.sajdahTypeObligatory : context.l10n.sajdahTypeRecommended})',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: sajdah.isObligatory ? Colors.red : cs.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isFavorited)
                      const Icon(Icons.star_rounded, size: 16, color: Color(0xFFE6A23C)),
                    if (isBookmarked) ...[
                      if (isFavorited) const SizedBox(width: 4),
                      const Icon(Icons.bookmark_rounded, size: 16, color: AppColors.accentGoldDeep),
                    ],

                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            showTajweed == true && ayah.tajweedSegments.isNotEmpty
                ? _TajweedText(
                    ayahId: ayah.id,
                    text: ayah.textUthmani,
                    segments: ayah.tajweedSegments,
                    defaultColor: cs.textPrimary,
                    inactiveRules: inactiveRules,
                    fontSize: fontSize + 4,
                    lineHeight: readerSettings.lineHeight,
                  )
                : Text(
                    ayah.textUthmani,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: quranFont,
                      fontSize: fontSize + 4,
                      height: readerSettings.lineHeight,
                      color: cs.textPrimary,
                    ),
                  ),
            if (showKurdish == true && ayah.textKu != null && ayah.textKu!.isNotEmpty) ...[
              const SizedBox(height: 12),
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
            ],
            if (showEnglish == true && ayah.textEn != null && ayah.textEn!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                stripHtmlTags(ayah.textEn!),
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

// ─────────────────────────────────────────────────────────────────────────────
// _TajweedText — coloured Quran text with tap-to-identify rule popup
// ─────────────────────────────────────────────────────────────────────────────

class _TajweedText extends ConsumerStatefulWidget {
  final int ayahId;
  final String text;
  final List<TajweedSegmentModel> segments;
  final Color defaultColor;
  final Set<dynamic> inactiveRules;
  final double fontSize;
  final double lineHeight;

  const _TajweedText({
    required this.ayahId,
    required this.text,
    required this.segments,
    required this.defaultColor,
    required this.inactiveRules,
    required this.fontSize,
    required this.lineHeight,
  });

  @override
  ConsumerState<_TajweedText> createState() => _TajweedTextState();
}

class _TajweedTextState extends ConsumerState<_TajweedText> {
  final _key = GlobalKey();

  Map<int, Color> _buildRuleColorsMap() {
    final rules = ref.watch(tajweedRuleMapProvider);
    final map = <int, Color>{};
    for (final rule in rules.values) {
      if (rule.colorCode != null && rule.colorCode!.isNotEmpty) {
        final match = RegExp(r'#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})').firstMatch(rule.colorCode!);
        if (match != null) {
          final hex = match.group(1)!.toLowerCase();
          if (hex == '000000' || hex == 'ffffff') continue;
          try {
            if (hex.length == 6) {
              map[rule.id] = Color(int.parse('ff$hex', radix: 16));
            } else if (hex.length == 8) {
              map[rule.id] = Color(int.parse(hex, radix: 16));
            }
          } catch (_) {}
        }
      }
    }
    debugPrint('Tajweed Rule Colors Loaded: ${map.length} rules');
    for (final entry in map.entries) {
      debugPrint('Rule ${entry.key} -> ${entry.value}');
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapUp: _onTapUp,
      child: Text.rich(
        key: _key,
        TextSpan(
          children: TajweedSpanCache.getOrBuild(
            ayahId: widget.ayahId,
            text: widget.text,
            segments: widget.segments,
            defaultColor: widget.defaultColor,
            inactiveRules: widget.inactiveRules,
            ruleColors: _buildRuleColorsMap(),
            fontFamily: 'QPCV4Tajweed',
            fontSize: widget.fontSize,
          ),
        ),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'QPCV4Tajweed',
          fontSize: widget.fontSize,
          height: widget.lineHeight,
        ),
      ),
    );
  }

  void _onTapUp(TapUpDetails details) {
    final para = _key.currentContext?.findRenderObject() as RenderParagraph?;
    if (para == null) return;
    final charOffset = para.getPositionForOffset(details.localPosition).offset;
    TajweedSegmentModel? hit;
    for (final seg in widget.segments) {
      final s = seg.startIndex;
      final e = seg.endIndex;
      if (s != null && e != null && charOffset >= s && charOffset < e) {
        hit = seg;
        break;
      }
    }
    if (hit == null || hit.ruleId == null) return;
    _lookupAndShowRule(hit.ruleId!);
  }

  Future<void> _lookupAndShowRule(int ruleId) async {
    final isar = IsarService.instance.isar;
    final rule = await isar.tajweedRuleCollections
        .filter()
        .ruleIdEqualTo(ruleId)
        .findFirst();
    if (rule == null || !mounted) return;
    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => _TajweedRuleSheet(rule: rule),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TajweedRuleSheet — rule info popup shown on tap
// ─────────────────────────────────────────────────────────────────────────────

class _TajweedRuleSheet extends StatelessWidget {
  final TajweedRuleCollection rule;
  const _TajweedRuleSheet({required this.rule});

  Color get _accent {
    try {
      return Color(int.parse('ff${rule.colorCode.replaceFirst('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xFF1B7340);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accent;

    return Container(
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.cardBorder.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: accent, width: 2.5),
                ),
                child: Center(
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rule.nameKu,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: cs.textPrimary,
                      ),
                    ),
                    if (rule.nameAr.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        rule.nameAr,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: accent, fontWeight: FontWeight.w600),
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      rule.nameEn,
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isDark ? cs.primary.withValues(alpha: 0.12) : cs.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.primary.withValues(alpha: 0.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category_rounded, size: 14, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    rule.categoryNameKu,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.w600, color: cs.primary),
                  ),
                ],
              ),
            ),
          ),
          if (rule.description != null && rule.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: accent.withValues(alpha: 0.18)),
              ),
              child: Text(
                rule.description!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.6, color: cs.textSecondary),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
