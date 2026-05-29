import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';

// ── Nav Items Configuration ──────────────────────────────────────────────────
// Layout: [Settings(5), Quran(1)] | [Home(0) CENTER FAB] | [Tasbih(2), Community(4)]
// Bookmarks (index 3) accessible from Quran/Home context — not in primary nav

class _NavItemData {
  const _NavItemData({
    required this.pageIndex,
    required this.icon,
    required this.activeIcon,
  });
  final int pageIndex;
  final IconData icon;
  final IconData activeIcon;

  String label(AppLocalizations l) {
    switch (pageIndex) {
      case 0:
        return l.navHome;
      case 1:
        return l.navQuran;
      case 2:
        return l.navTasbih;
      case 3:
        return l.navBookmarks;
      case 4:
        return l.navCommunity;
      case 5:
        return l.navSettings;
      default:
        return '';
    }
  }
}

// Visual left side items (Tasbih & Community)
const _leftItems = [
  _NavItemData(
    pageIndex: 2,
    icon: Icons.radio_button_checked_outlined,
    activeIcon: Icons.radio_button_checked,
  ),
  _NavItemData(
    pageIndex: 4,
    icon: Icons.people_outline_rounded,
    activeIcon: Icons.people_rounded,
  ),
];

// Visual right side items (Quran & Settings)
const _rightItems = [
  _NavItemData(
    pageIndex: 1,
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book_rounded,
  ),
  _NavItemData(
    pageIndex: 5,
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
  ),
];

class AppBottomNavBar extends ConsumerWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: cs.navBar,
        border: Border(top: BorderSide(color: cs.cardBorder, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Row of side nav items ──────────────────────────────────
              Row(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left visual side
                  Expanded(
                    child: Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _leftItems.map((item) => _NavTab(
                        icon: item.icon,
                        activeIcon: item.activeIcon,
                        label: item.label(l),
                        isActive: currentIndex == item.pageIndex,
                        primary: cs.primary,
                        textSecondary: cs.textSecondary,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTap(item.pageIndex);
                        },
                      )).toList(),
                    ),
                  ),

                  // Center HOME FAB placeholder space
                  const SizedBox(width: 72),

                  // Right visual side
                  Expanded(
                    child: Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _rightItems.map((item) => _NavTab(
                        icon: item.icon,
                        activeIcon: item.activeIcon,
                        label: item.label(l),
                        isActive: currentIndex == item.pageIndex,
                        primary: cs.primary,
                        textSecondary: cs.textSecondary,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          onTap(item.pageIndex);
                        },
                      )).toList(),
                    ),
                  ),
                ],
              ),

              // ── Center HOME FAB ────────────────────────────────────────
              Positioned(
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onTap(0);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutBack,
                        width: currentIndex == 0 ? 60 : 54,
                        height: currentIndex == 0 ? 60 : 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryGreen, AppColors.primaryGreenDeep],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withValues(
                                alpha: currentIndex == 0 ? 0.45 : 0.25,
                              ),
                              blurRadius: currentIndex == 0 ? 20 : 12,
                              spreadRadius: currentIndex == 0 ? 2 : 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
                          color: Colors.white,
                          size: currentIndex == 0 ? 28 : 24,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l.navHome,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 9,
                          fontWeight: currentIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                          color: currentIndex == 0 ? AppColors.primaryGreen : const Color(0xFF8899AA),
                        ),
                      ),
                    ],
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

// ── Individual Nav Tab ────────────────────────────────────────────────────────
class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.primary,
    required this.textSecondary,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color primary;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? primary.withValues(alpha: 0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? primary : textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? primary : textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
