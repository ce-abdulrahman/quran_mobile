import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/utils/responsive.dart';
import '../search/search_page.dart';
import '../auth/auth_provider.dart';
import 'home_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Ad Slide Data
// ─────────────────────────────────────────────────────────────────────────────

class _AdSlide {
  final String titleArabic;
  final String verse;
  final String source;
  const _AdSlide(this.titleArabic, this.verse, this.source);
}

final _slides = const [
  _AdSlide(
    'إِنَّ هَٰذَا الْقُرْآنَ يَهْدِي لِلَّتِي هِيَ أَقْوَمُ',
    'ئەم قورئانە ڕێنمایی دەکات بۆ ئەوەی ڕاستترینەوە',
    '— ئیسرا ١٧:٩',
  ),
  _AdSlide(
    'وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ',
    'ئێمە قورئانەکەمان ئاسان کرد بۆ یادەوەری',
    '— القمر ٥٤:١٧',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Category Data
// ─────────────────────────────────────────────────────────────────────────────

class _CatData {
  final IconData icon;
  final Color iconColor;
  final String Function(AppLocalizations) label;
  final VoidCallback Function(WidgetRef, BuildContext) onTap;

  const _CatData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
}

List<_CatData> _buildCats(BuildContext context) => [
      _CatData(
        icon: Icons.menu_book_outlined,
        iconColor: AppColors.primaryGreen,
        label: (l) => l.quranTitle,
        onTap: (ref, _) =>
            () => ref.read(shellIndexProvider.notifier).state = 1,
      ),
      _CatData(
        icon: Icons.radio_button_checked_outlined,
        iconColor: const Color(0xFF7B4F00),
        label: (l) => l.navTasbih,
        onTap: (ref, _) =>
            () => ref.read(shellIndexProvider.notifier).state = 2,
      ),
      _CatData(
        icon: Icons.bookmark_border_rounded,
        iconColor: const Color(0xFF1A3A5C),
        label: (l) => l.navBookmarks,
        onTap: (ref, _) =>
            () => ref.read(shellIndexProvider.notifier).state = 3,
      ),
      _CatData(
        icon: Icons.search_outlined,
        iconColor: const Color(0xFF5B1A8A),
        label: (l) => l.searchTitle,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
      ),
      _CatData(
        icon: Icons.people_outlined,
        iconColor: const Color(0xFF00838F),
        label: (l) => l.navCommunity,
        onTap: (ref, _) =>
            () => ref.read(shellIndexProvider.notifier).state = 4,
      ),
      _CatData(
        icon: Icons.settings_outlined,
        iconColor: const Color(0xFF546E7A),
        label: (l) => l.navSettings,
        onTap: (ref, _) =>
            () => ref.read(shellIndexProvider.notifier).state = 5,
      ),
      _CatData(
        icon: Icons.star_border_rounded,
        iconColor: AppColors.accentGoldDeep,
        label: (l) => l.navBookmarks,
        onTap: (ref, _) =>
            () => ref.read(shellIndexProvider.notifier).state = 3,
      ),
      _CatData(
        icon: Icons.language_outlined,
        iconColor: const Color(0xFF2E7D32),
        label: (l) => l.homeVerseSearch,
        onTap: (ref, ctx) => () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
      ),
    ];

// ─────────────────────────────────────────────────────────────────────────────
// HomePage
// ─────────────────────────────────────────────────────────────────────────────

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = Responsive.pagePadding(context);

    return Scaffold(
      backgroundColor: AppColorScheme.of(context).bg,
      body: Column(
        children: [
          // ── Green header zone ────────────────────────────────────
          _GreenZone(padding: p),

          // ── Daily Goals (authenticated) ──────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(p, 20, p, 0),
            child: _StreakBanner(),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

          // ── Section: تایبەتمەندییەکان ────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(p, 24, p, 12),
            child: _SectionDivider(
              title: context.l10n.homeFeatures,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

          // ── Categories grid (scrollable) ─────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(p, 0, p, 20),
              child: _CategoriesGrid(),
            ),
          ),
          // ── Daily Goals card ─────────────────────────────────────
          // Padding(
          //   padding: EdgeInsets.fromLTRB(p, 0, p, 32),
          //   child: _DailyGoalsCard(),
          // ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Green Zone  (appbar + verse banner card + dots)
// ─────────────────────────────────────────────────────────────────────────────

class _GreenZone extends StatefulWidget {
  const _GreenZone({required this.padding});
  final double padding;

  @override
  State<_GreenZone> createState() => _GreenZoneState();
}

class _GreenZoneState extends State<_GreenZone> {
  final _ctrl = PageController();
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final next = (_page + 1) % _slides.length;
      _ctrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.padding;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF061810),
                  const Color(0xFF0A2218),
                  const Color(0xFF0D2E1F)
                ]
              : [
                  AppColors.primaryGreenDeep,
                  AppColors.primaryGreen,
                  const Color(0xFF1A7A50)
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App bar ────────────────────────────────────────────
            _AppBarRow(padding: p),

            const SizedBox(height: 16),

            // ── Verse banner card ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: p),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColorScheme.of(context).card,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => _VerseSlide(slide: _slides[i]),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Dot indicators ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // ── Rounded white overlap at bottom ────────────────────
            Container(
              height: 26,
              decoration: BoxDecoration(
                color: AppColorScheme.of(context).bg,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Bar Row
// ─────────────────────────────────────────────────────────────────────────────

class _AppBarRow extends ConsumerWidget {
  const _AppBarRow({required this.padding});
  final double padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 10, padding, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Theme toggle — left ──
          GestureDetector(
            onTap: () => ref.read(themeModeProvider.notifier).toggle(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
              child: Icon(
                ref.watch(themeModeProvider) == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: Colors.white.withValues(alpha: 0.9),
                size: 18,
              ),
            ),
          ),

          // ── App name — center ──
          Text(
            l.appName,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),

          // ── Logo badge — right ──
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Verse Slide  (inside white card)
// ─────────────────────────────────────────────────────────────────────────────

class _VerseSlide extends StatelessWidget {
  const _VerseSlide({required this.slide});
  final _AdSlide slide;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: cs.card,
      child: Row(
        children: [
          // ── Left: green gradient + verse text ──
          Expanded(
            flex: 55,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF061810), const Color(0xFF0A2218)]
                      : [AppColors.primaryGreenDeep, AppColors.primaryGreen],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ئایەتی ڕۆژ pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('✨', style: TextStyle(fontSize: 9)),
                        const SizedBox(width: 3),
                        Text(
                          context.l10n.homeDailyVerse,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.verse,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.source,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 9,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Right: white + Arabic quran text ──
          Expanded(
            flex: 45,
            child: Container(
              color: cs.card,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle accent
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryGreen.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Arabic Quranic text
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      slide.titleArabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 15,
                        height: 1.8,
                        color: cs.textPrimary,
                      ),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Divider  ─ ─ ─  Title  ─ ─ ─
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return Row(
      children: [
        Expanded(child: _DashedLine(color: cs.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: cs.textPrimary,
            ),
          ),
        ),
        Expanded(child: _DashedLine(color: cs.divider)),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      const dashW = 5.0;
      const gap = 3.0;
      final count = (constraints.maxWidth / (dashW + gap)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Container(
            width: dashW,
            height: 1.5,
            margin: const EdgeInsets.only(right: gap),
            color: color,
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Categories Grid  (4 cols phone / 5 cols tablet)
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesGrid extends ConsumerWidget {
  const _CategoriesGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = Responsive.isTablet(context);
    final cols = isTablet ? 5 : 3;
    final cats = _buildCats(context);

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: cats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isTablet ? 0.88 : 0.82,
      ),
      itemBuilder: (context, i) {
        final cat = cats[i];
        return _CatTile(
          icon: cat.icon,
          iconColor: cat.iconColor,
          label: cat.label(context.l10n),
          onTap: cat.onTap(ref, context),
        ).animate().fadeIn(
              duration: 280.ms,
              delay: Duration(milliseconds: 40 * i),
            );
      },
    );
  }
}

class _CatTile extends StatelessWidget {
  const _CatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: iconColor),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: cs.textPrimary,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak Banner  (authenticated only)
// ─────────────────────────────────────────────────────────────────────────────

class _StreakBanner extends ConsumerWidget {
  const _StreakBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) return const SizedBox.shrink();

    final streaksAsync = ref.watch(readingStreaksProvider);
    final l = context.l10n;

    return streaksAsync.when(
      data: (data) {
        if (data == null) return const SizedBox.shrink();
        final currentStreak = data['current_streak'] as int? ?? 0;
        final longestStreak = data['longest_streak'] as int? ?? 0;
        final todayRead = data['today_read'] as bool? ?? false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8F00), Color(0xFFFF5722)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.30),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 30)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.homeReadingStreak,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentStreak > 0
                            ? l.homeStreakDaysCount(currentStreak)
                            : l.homeStreakNoActive,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        todayRead
                            ? l.homeStreakTodayDone
                            : l.homeStreakTodayPending,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$longestStreak',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        l.homeStreakLongest,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 8,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Daily Goals Card
// ─────────────────────────────────────────────────────────────────────────────

class _DailyGoalsCard extends StatefulWidget {
  const _DailyGoalsCard();

  @override
  State<_DailyGoalsCard> createState() => _DailyGoalsCardState();
}

class _DailyGoalsCardState extends State<_DailyGoalsCard> {
  final List<Map<String, dynamic>> _goals = [
    {'key': 'goal1', 'done': true},
    {'key': 'goal2', 'done': true},
    {'key': 'goal3', 'done': false},
    {'key': 'goal4', 'done': false},
  ];

  String _label(AppLocalizations l, String key) {
    switch (key) {
      case 'goal1':
        return l.homeGoal1;
      case 'goal2':
        return l.homeGoal2;
      case 'goal3':
        return l.homeGoal3;
      case 'goal4':
        return l.homeGoal4;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final doneCount = _goals.where((g) => g['done'] == true).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🎯', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    l.homeDailyGoals,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$doneCount/${_goals.length}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: doneCount / _goals.length,
              minHeight: 5,
              backgroundColor: cs.cardBorder,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),

          const SizedBox(height: 14),

          // Goal items
          ..._goals.map((goal) {
            return GestureDetector(
              onTap: () => setState(() => goal['done'] = !goal['done']),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: goal['done'] ? cs.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: goal['done'] ? cs.primary : cs.cardBorder,
                          width: 1.5,
                        ),
                      ),
                      child: goal['done']
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _label(l, goal['key'] as String),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color:
                              goal['done'] ? cs.textSecondary : cs.textPrimary,
                          decoration:
                              goal['done'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
} 
