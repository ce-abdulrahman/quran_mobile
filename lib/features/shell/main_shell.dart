import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/home_page.dart';
import '../quran/quran_page.dart';
import '../tasbih/tasbih_page.dart';
import '../bookmarks/bookmarks_page.dart';
import '../community/community_page.dart';
import '../auth/auth_guard.dart';
import '../settings/settings_page.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../core/providers/app_providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/l10n/app_localizations.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _pages = [
    HomePage(),
    QuranPage(),
    TasbihPage(),
    BookmarksPage(),
    AuthGuard(child: CommunityPage()),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(shellIndexProvider);
    final isTablet = Responsive.isTablet(context);

    // ── Tablet: Side NavigationRail ─────────────────────────────
    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            _SideRail(
              currentIndex: index,
              onTap: (i) => ref.read(shellIndexProvider.notifier).state = i,
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: IndexedStack(index: index, children: _pages),
            ),
          ],
        ),
      );
    }

    // ── Phone: Bottom Navigation Bar ────────────────────────────
    return Scaffold(
      body: IndexedStack(index: index, children: _pages),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: index,
        onTap: (i) => ref.read(shellIndexProvider.notifier).state = i,
      ),
    );
  }
}

// ── Tablet Side Navigation Rail ───────────────────────────────────────────────

class _SideRail extends ConsumerWidget {
  const _SideRail({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;

    final items = [
      (icon: Icons.home_rounded, label: l.navHome),
      (icon: Icons.menu_book_rounded, label: l.navQuran),
      (icon: Icons.radio_button_checked_rounded, label: l.navTasbih),
      (icon: Icons.bookmark_rounded, label: l.navBookmarks),
      (icon: Icons.people_rounded, label: l.navCommunity),
      (icon: Icons.settings_rounded, label: l.navSettings),
    ];

    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: cs.surface,
      indicatorColor: AppColors.primaryGreen.withValues(alpha: 0.15),
      selectedIconTheme: const IconThemeData(color: AppColors.primaryGreen, size: 26),
      unselectedIconTheme: const IconThemeData(color: AppColors.primaryGreen, size: 24),
      selectedLabelTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryGreen,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 11,
        color: cs.textSecondary,
      ),
      labelType: NavigationRailLabelType.all,
      destinations: items
          .map((item) => NavigationRailDestination(
                icon: Icon(item.icon),
                label: Text(item.label),
              ))
          .toList(),
    );
  }
}
