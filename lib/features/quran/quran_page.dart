import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/database/app_database.dart';
import '../../core/l10n/app_localizations.dart';
import 'quran_providers.dart';
import 'reader/reader_page.dart';

class QuranPage extends ConsumerStatefulWidget {
  const QuranPage({super.key});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: ref.read(quranSearchQueryProvider));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final surahsAsync = ref.watch(localSurahsProvider);
    final activeTab = ref.watch(quranTabFilterProvider);
    final query = ref.watch(quranSearchQueryProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Text(
                    context.l10n.quranTitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.cardBorder),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => ref.read(quranSearchQueryProvider.notifier).state = v,
                  style: TextStyle(fontFamily: 'Cairo', color: cs.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: context.l10n.quranSearchHint,
                    hintStyle: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary, fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: cs.textSecondary, size: 20),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              ref.read(quranSearchQueryProvider.notifier).state = '';
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 12),

            // Filter tabs
            SizedBox(
              height: 38,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterTab(
                    label: context.l10n.quranAll,
                    isActive: activeTab == 0,
                    onTap: () => ref.read(quranTabFilterProvider.notifier).state = 0,
                    cs: cs,
                  ),
                  _FilterTab(
                    label: context.l10n.quranMeccan,
                    isActive: activeTab == 1,
                    onTap: () => ref.read(quranTabFilterProvider.notifier).state = 1,
                    cs: cs,
                  ),
                  _FilterTab(
                    label: context.l10n.quranMedinan,
                    isActive: activeTab == 2,
                    onTap: () => ref.read(quranTabFilterProvider.notifier).state = 2,
                    cs: cs,
                  ),
                  _FilterTab(
                    label: context.l10n.quranBookmarked,
                    isActive: activeTab == 3,
                    onTap: () => ref.read(quranTabFilterProvider.notifier).state = 3,
                    cs: cs,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

            const SizedBox(height: 8),

            // Surahs List
            Expanded(
              child: surahsAsync.when(
                data: (allSurahs) {
                  // Filter the list reactively in UI
                  var filtered = allSurahs.where((surah) {
                    // Type filter
                    if (activeTab == 1 && surah.revelationType != 'Meccan') return false;
                    if (activeTab == 2 && surah.revelationType != 'Medinan') return false;
                    if (activeTab == 3) {
                      // Check if surah is bookmarked
                      final isBookmarked = ref.read(isSurahBookmarkedProvider(surah.id));
                      if (!isBookmarked) return false;
                    }
                    
                    // Search filter
                    if (query.isNotEmpty) {
                      final q = query.toLowerCase();
                      final matchAr = surah.nameAr.contains(q);
                      final matchEn = surah.nameEn.toLowerCase().contains(q);
                      final matchKu = surah.nameKu?.contains(q) ?? false;
                      final matchNo = surah.number.toString() == q;
                      return matchAr || matchEn || matchKu || matchNo;
                    }
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return _EmptyState(cs: cs);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final surah = filtered[i];
                      return _SurahCard(
                        surah: surah,
                        cs: cs,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ReaderPage(surah: surah)),
                          );
                        },
                      ).animate().fadeIn(duration: 300.ms, delay: (i * 15).ms);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    context.l10n.commonErrorLoading,
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

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.cs,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? cs.primary : cs.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: isActive ? cs.primary : cs.cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive ? Colors.white : cs.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SurahCard extends ConsumerStatefulWidget {
  const _SurahCard({
    required this.surah,
    required this.cs,
    required this.onTap,
  });

  final Surah surah;
  final AppColorScheme cs;
  final VoidCallback onTap;

  @override
  ConsumerState<_SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends ConsumerState<_SurahCard> {
  bool _isPressed = false;

  static const cardColors = [
    Color(0xFF059669), // Green
    Color(0xFF0891B2), // Cyan
    Color(0xFF7C3AED), // Purple
    Color(0xFFDB2777), // Pink
    Color(0xFFEA580C), // Orange
    Color(0xFF65A30D), // Lime
    Color(0xFF0284C7), // Blue
    Color(0xFF9333EA), // Purple-violet
  ];

  @override
  Widget build(BuildContext context) {
    final surah = widget.surah;
    final cs = widget.cs;
    final isMeccan = surah.revelationType == 'Meccan';
    final isBookmarked = ref.watch(isSurahBookmarkedProvider(surah.id));
    final accentColor = cardColors[(surah.number - 1) % cardColors.length];
    final pct = (surah.totalAyahs / 286.0).clamp(0.05, 1.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isPressed ? accentColor.withValues(alpha: 0.5) : cs.cardBorder,
              width: _isPressed ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isPressed 
                    ? accentColor.withValues(alpha: 0.08) 
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: _isPressed ? 12 : 8,
                offset: _isPressed ? const Offset(0, 4) : const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              // Number badge with circular progress ring
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 3.0,
                        color: cs.cardBorder,
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        value: pct,
                        strokeWidth: 3.0,
                        strokeCap: StrokeCap.round,
                        color: accentColor,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    // Number text
                    Text(
                      '${surah.number}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Name Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.nameAr,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: cs.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${surah.nameEn} · ${surah.nameKu ?? ""}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: cs.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Type badge + Bookmark Action
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: isBookmarked ? AppColors.accentGold : cs.textSecondary,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ref.read(quranBookmarkNotifierProvider).toggleSurahBookmark(surah.id);
                        },
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isMeccan ? context.l10n.quranMeccan : context.l10n.quranMedinan,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${surah.totalAyahs} ${context.l10n.quranAyahs}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: cs.textSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.searchNoResults,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cs.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
