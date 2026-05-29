import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../quran_providers.dart';
import '../../auth/auth_provider.dart';
import '../../community/community_provider.dart';
import '../../home/home_providers.dart';

class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({super.key, required this.surah, this.initialAyahNumber});
  final Surah surah;
  final int? initialAyahNumber;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  bool _showSettings = false;
  late DateTime _startTime;
  int _maxAyahIndexRead = 0;
  bool _hasScrolled = false;
  final Map<int, GlobalKey> _ayahKeys = {};
  late final ScrollController _scrollController;
  int? _highlightedAyah;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _saveProgress();
    _scrollController.dispose();
    super.dispose();
  }

  void _saveProgress() {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) return;

    final secondsSpent = DateTime.now().difference(_startTime).inSeconds;
    if (secondsSpent < 2) return; // Skip quick visits

    final ayahsAsync = ref.read(ayahsForSurahProvider(widget.surah.id));
    ayahsAsync.whenData((ayahs) {
      if (ayahs.isEmpty) return;
      final index = _maxAyahIndexRead.clamp(0, ayahs.length - 1);
      final ayah = ayahs[index];

      ref.read(quranApiClientProvider).saveLastRead(ayah.id, secondsSpent).then((_) {
        ref.invalidate(myStatsProvider);
        ref.invalidate(lastReadProvider);
        ref.invalidate(readingStreaksProvider);
      }).catchError((e) {
        debugPrint('Error saving last read progress: $e');
      });
    });
  }

  void _scrollToAyah(int targetNumber, List<Ayah> ayahs, double fontSize, bool showKurdish, bool showEnglish) {
    if (targetNumber < 1 || targetNumber > ayahs.length) return;

    setState(() {
      _highlightedAyah = targetNumber;
    });

    // Remove highlight after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _highlightedAyah == targetNumber) {
        setState(() {
          _highlightedAyah = null;
        });
      }
    });

    // 1. Calculate estimated scroll offset
    double estimatedOffset = 0.0;
    
    // Add Bismillah header height estimate
    if (widget.surah.id != 9) {
      estimatedOffset += 80.0; // height of Bismillah text + padding
    }

    final double kurdishFontSize = (fontSize - 6).clamp(12.0, 36.0);
    final double englishFontSize = (fontSize - 7).clamp(11.0, 34.0);

    for (int i = 0; i < targetNumber - 1; i++) {
      final ayah = ayahs[i];
      double cardHeight = 16.0; // card margin bottom

      // Card internal padding top/bottom (32) + border (2) + header/action row (approx 36)
      double contentHeight = 70.0; 

      // Arabic text estimation
      final arTextLen = ayah.textUthmani.length;
      const double arLineCharLimit = 35.0; 
      final double arLines = (arTextLen / arLineCharLimit).ceilToDouble();
      contentHeight += arLines * fontSize * 1.8;

      // Kurdish text estimation
      if (showKurdish && ayah.textKu != null && ayah.textKu!.isNotEmpty) {
        contentHeight += 13.0; // divider and padding
        final kuTextLen = ayah.textKu!.length;
        final double kuLines = (kuTextLen / 45.0).ceilToDouble();
        contentHeight += kuLines * kurdishFontSize * 1.6;
      }

      // English text estimation
      if (showEnglish && ayah.textEn != null && ayah.textEn!.isNotEmpty) {
        contentHeight += 13.0; // divider and padding
        final enTextLen = ayah.textEn!.length;
        final double enLines = (enTextLen / 55.0).ceilToDouble();
        contentHeight += enLines * englishFontSize * 1.5;
      }

      cardHeight += contentHeight;
      estimatedOffset += cardHeight;
    }

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetOffset = estimatedOffset.clamp(0.0, maxScroll);

    // 2. Animate to the estimated offset
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ).then((_) {
      // 3. Precise positioning using Scrollable.ensureVisible after layout frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _ayahKeys[targetNumber];
        if (key != null && key.currentContext != null && mounted) {
          Scrollable.ensureVisible(
            key.currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  Widget _buildSearchPanel(BuildContext context, AppColorScheme cs, List<Ayah> ayahs, double fontSize, bool showKurdish, bool showEnglish) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(color: cs.cardBorder),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: cs.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.cardBorder),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: cs.textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: cs.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: context.l10n.readerSearchAyahHint(widget.surah.totalAyahs),
                        hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: cs.textSecondary.withValues(alpha: 0.7),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (value) {
                        final val = int.tryParse(value.trim());
                        if (val != null && val >= 1 && val <= widget.surah.totalAyahs) {
                          _scrollToAyah(val, ayahs, fontSize, showKurdish, showEnglish);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.l10n.readerSearchAyahRangeError(widget.surah.totalAyahs),
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final fontSize = ref.watch(fontSizeProvider);
    final ayahsAsync = ref.watch(ayahsForSurahProvider(widget.surah.id));
    final showKurdish = ref.watch(showKurdishTranslationProvider);
    final showEnglish = ref.watch(showEnglishTranslationProvider);

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
          widget.surah.nameAr,
          style: TextStyle(
            fontFamily: 'UthmanicHafs',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: cs.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showSettings ? Icons.settings_rounded : Icons.settings_outlined,
              color: _showSettings ? AppColors.primaryGreen : cs.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showSettings) _buildSettingsPanel(context, cs, fontSize, showKurdish, showEnglish),
          Expanded(
            child: ayahsAsync.when(
              data: (ayahs) {
                final showSearch = widget.surah.totalAyahs > 30;
                return Column(
                  children: [
                    if (showSearch)
                      _buildSearchPanel(context, cs, ayahs, fontSize, showKurdish, showEnglish),
                    Expanded(
                      child: _buildAyahsList(context, cs, ayahs, fontSize, showKurdish, showEnglish),
                    ),
                  ],
                );
              },
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primaryGreen),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.readerLoadingAyahsFromServer,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.readerOfflineError,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: cs.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(context.l10n.readerRetry, style: const TextStyle(fontFamily: 'Cairo')),
                        onPressed: () {
                          ref.invalidate(ayahsForSurahProvider(widget.surah.id));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel(BuildContext context, AppColorScheme cs, double currentSize, bool showKurdish, bool showEnglish) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          bottom: BorderSide(color: cs.cardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.readerTextSize,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
              Text(
                '${currentSize.toInt()} px',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: currentSize,
            min: 18.0,
            max: 42.0,
            activeColor: AppColors.primaryGreen,
            inactiveColor: cs.cardBorder,
            onChanged: (val) {
              ref.read(fontSizeProvider.notifier).setSize(val);
            },
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            activeTrackColor: AppColors.primaryGreen,
            contentPadding: EdgeInsets.zero,
            title: Text(
              context.l10n.readerKuTranslation,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: showKurdish,
            onChanged: (val) {
              ref.read(showKurdishTranslationProvider.notifier).setToggle(val);
            },
          ),
          SwitchListTile.adaptive(
            activeTrackColor: AppColors.primaryGreen,
            contentPadding: EdgeInsets.zero,
            title: Text(
              context.l10n.readerEnTranslation,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: showEnglish,
            onChanged: (val) {
              ref.read(showEnglishTranslationProvider.notifier).setToggle(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAyahsList(BuildContext context, AppColorScheme cs, List<Ayah> ayahs, double fontSize, bool showKurdish, bool showEnglish) {
    if (widget.initialAyahNumber != null && !_hasScrolled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToAyah(widget.initialAyahNumber!, ayahs, fontSize, showKurdish, showEnglish);
        _hasScrolled = true;
      });
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: ayahs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSurahHeader(cs);
        }
        final ayahIndex = index - 1;
        if (ayahIndex > _maxAyahIndexRead) {
          _maxAyahIndexRead = ayahIndex;
        }
        final ayah = ayahs[ayahIndex];
        final key = _ayahKeys.putIfAbsent(ayah.ayahNumber, () => GlobalKey());
        final isHighlighted = _highlightedAyah == ayah.ayahNumber;

        return AyahCard(
          key: key,
          ayah: ayah,
          fontSize: fontSize,
          showKurdish: showKurdish,
          showEnglish: showEnglish,
          isHighlighted: isHighlighted,
        );
      },
    );
  }

  Widget _buildSurahHeader(AppColorScheme cs) {
    if (widget.surah.id == 9) {
      return const SizedBox(height: 16);
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        style: TextStyle(
          fontFamily: 'UthmanicHafs',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: cs.textPrimary,
        ),
      ),
    );
  }
}

class AyahCard extends ConsumerWidget {
  const AyahCard({
    super.key,
    required this.ayah,
    required this.fontSize,
    required this.showKurdish,
    required this.showEnglish,
    required this.isHighlighted,
  });

  final Ayah ayah;
  final double fontSize;
  final bool showKurdish;
  final bool showEnglish;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final isAyahBookmarked = ref.watch(isAyahBookmarkedProvider(ayah.id));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? AppColors.accentGold : cs.cardBorder,
          width: isHighlighted ? 2.0 : 1.0,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppColors.accentGold.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 3,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${ayah.ayahNumber}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isAyahBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isAyahBookmarked ? AppColors.accentGold : cs.textSecondary,
                  size: 20,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(quranBookmarkNotifierProvider).toggleBookmark(ayah.id);
                },
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
              fontSize: fontSize,
              height: 1.8,
              color: cs.textPrimary,
            ),
          ),
          if (showKurdish && ayah.textKu != null && ayah.textKu!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              ayah.textKu!,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: (fontSize - 6).clamp(12.0, 36.0),
                height: 1.6,
                color: cs.textPrimary.withValues(alpha: 0.95),
              ),
            ),
          ],
          if (showEnglish && ayah.textEn != null && ayah.textEn!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Text(
              ayah.textEn!,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: (fontSize - 7).clamp(11.0, 34.0),
                height: 1.5,
                color: cs.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}


