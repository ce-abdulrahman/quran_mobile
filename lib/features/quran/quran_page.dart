import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/utils/responsive.dart';
import '../../core/models/surah_model.dart';
import 'quran_providers.dart';
import 'quran_reader_page.dart';
import 'mushaf_reader_page.dart';
import '../../core/providers/app_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Filter Enum
// ─────────────────────────────────────────────────────────────────────────────

enum _QuranFilter { all, meccan, medinan, bookmarked }

// ─────────────────────────────────────────────────────────────────────────────
// Quran Page
// ─────────────────────────────────────────────────────────────────────────────

class QuranPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const QuranPage({super.key, this.showBackButton = false});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage> {
  _QuranFilter _filter = _QuranFilter.all;
  String _query = '';
  final _ctrl = TextEditingController();

  List<SurahModel> _applyFilters(List<SurahModel> list) {
    return list.where((s) {
      if (_filter == _QuranFilter.meccan && !s.isMeccan) return false;
      if (_filter == _QuranFilter.medinan && s.isMeccan) return false;
      if (_filter == _QuranFilter.bookmarked) return false; // v2
      if (_query.isNotEmpty) {
        final q = _query.trim().toLowerCase();
        return s.nameEn.toLowerCase().contains(q) ||
            s.nameAr.contains(q) ||
            s.nameKu.contains(q) ||
            s.number.toString() == q;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final p = Responsive.pagePadding(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surahListAsync = ref.watch(surahListProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────
          _QuranHeader(
            padding: p,
            isDark: isDark,
            cs: cs,
            l: l,
            query: _query,
            ctrl: _ctrl,
            showBackButton: widget.showBackButton,
            onSearch: (v) => setState(() => _query = v),
          ),

          // ── Filter tabs ───────────────────────────────────────────
          _FilterTabs(
            current: _filter,
            padding: p,
            l: l,
            cs: cs,
            onChanged: (f) => setState(() => _filter = f),
          ),

          const SizedBox(height: 8),

          // ── Surah list ────────────────────────────────────────────
          Expanded(
            child: surahListAsync.when(
              data: (surahs) {
                final filtered = _applyFilters(surahs);
                if (filtered.isEmpty) {
                  return _EmptyState(cs: cs);
                }
                return RefreshIndicator(
                  color: cs.primary,
                  backgroundColor: cs.card,
                  onRefresh: () => ref.read(surahListProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(p, 4, p, 100),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _SurahCard(
                      surah: filtered[i],
                      cs: cs,
                      l: l,
                    )
                        .animate()
                        .fadeIn(
                          duration: 260.ms,
                          delay: Duration(milliseconds: 30 * i),
                        ),
                  ),
                );
              },
              loading: () => _QuranSkeleton(padding: p, cs: cs),
              error: (error, _) => _QuranErrorState(
                message: error.toString().replaceAll('Exception: ', ''),
                cs: cs,
                onRetry: () => ref.read(surahListProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _QuranHeader extends StatelessWidget {
  const _QuranHeader({
    required this.padding,
    required this.isDark,
    required this.cs,
    required this.l,
    required this.query,
    required this.ctrl,
    required this.showBackButton,
    required this.onSearch,
  });

  final double padding;
  final bool isDark;
  final AppColorScheme cs;
  final AppLocalizations l;
  final String query;
  final TextEditingController ctrl;
  final bool showBackButton;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColorScheme.darken(cs.primary, 0.35),
                  AppColorScheme.darken(cs.primary, 0.42),
                ]
              : [cs.primaryDeep, cs.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(padding, 12, padding, 24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (showBackButton)
                    Positioned(
                      left: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    l.quranTitle,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MushafReaderPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'مۆدی پەیج',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: ctrl,
                  onChanged: onSearch,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: l.quranSearchHint,
                    hintStyle: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    suffixIcon: query.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              ctrl.clear();
                              onSearch('');
                            },
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 18,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Tabs
// ─────────────────────────────────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({
    required this.current,
    required this.padding,
    required this.l,
    required this.cs,
    required this.onChanged,
  });

  final _QuranFilter current;
  final double padding;
  final AppLocalizations l;
  final AppColorScheme cs;
  final ValueChanged<_QuranFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_QuranFilter.all, l.quranAllSurahs),
      (_QuranFilter.meccan, l.quranMeccan),
      (_QuranFilter.medinan, l.quranMedinan),
      (_QuranFilter.bookmarked, l.quranBookmarked),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final filter = tabs[i].$1;
          final label = tabs[i].$2;
          final active = filter == current;
          return GestureDetector(
            onTap: () => onChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: active
                    ? LinearGradient(
                        colors: isDark
                            ? [
                                AppColorScheme.darken(cs.primary, 0.3),
                                AppColorScheme.darken(cs.primary, 0.38),
                              ]
                            : [cs.primary, AppColorScheme.darken(cs.primary, 0.15)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: active ? null : cs.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? (isDark ? AppColorScheme.darken(cs.primary, 0.12) : cs.primary)
                      : cs.cardBorder,
                  width: active ? 1.5 : 1.0,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: isDark ? 0.15 : 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                    color: active
                        ? Colors.white
                        : (isDark ? const Color(0xFF8BAE95) : cs.textSecondary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Surah Card
// ─────────────────────────────────────────────────────────────────────────────

class _SurahCard extends ConsumerWidget {
  const _SurahCard({required this.surah, required this.cs, required this.l});

  final SurahModel surah;
  final AppColorScheme cs;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(readingTrackerProvider.notifier);
    final progress = tracker.getSurahProgress(surah.id, surah.totalAyahs);
    final readCount = tracker.getSurahReadCount(surah.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => QuranReaderPage(surah: surah),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 380),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder, width: 1),
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
            Row(
              children: [
                // Number circle
                Hero(
                  tag: 'surah-num-${surah.number}',
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cs.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${surah.number}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Middle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.nameEn,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            '${surah.totalAyahs} ${l.quranAyahs}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: cs.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TypeBadge(
                            label: surah.isMeccan ? l.quranMeccan : l.quranMedinan,
                            isMeccan: surah.isMeccan,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arabic name
                Hero(
                  tag: 'surah-ar-${surah.number}',
                  child: Text(
                    surah.nameAr,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 20,
                      color: cs.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            if (readCount > 0) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: cs.cardBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$readCount/${surah.totalAyahs} خوێندراوەتەوە',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.isMeccan});
  final String label;
  final bool isMeccan;

  @override
  Widget build(BuildContext context) {
    final color =
        isMeccan ? const Color(0xFF1A5E3A) : const Color(0xFF1A3A5C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 64, color: cs.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          Text(
            'هیچ سورەتێک نەدۆزرایەوە',
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 16, color: cs.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton & Error Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _QuranSkeleton extends StatelessWidget {
  const _QuranSkeleton({required this.padding, required this.cs});
  final double padding;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(padding, 4, padding, 100),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: cs.card.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: cs.textSecondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 14,
                    decoration: BoxDecoration(
                      color: cs.textSecondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 60,
                    height: 10,
                    decoration: BoxDecoration(
                      color: cs.textSecondary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 18,
              decoration: BoxDecoration(
                color: cs.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ).animate(onPlay: (controller) => controller.repeat()).shimmer(
            duration: 1200.ms,
            color: cs.cardBorder.withValues(alpha: 0.2),
          ),
    );
  }
}

class _QuranErrorState extends StatelessWidget {
  const _QuranErrorState({
    required this.message,
    required this.cs,
    required this.onRetry,
  });

  final String message;
  final AppColorScheme cs;
  final VoidCallback onRetry;

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
