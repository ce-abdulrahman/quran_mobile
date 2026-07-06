import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/auth_provider.dart';
import 'themes/theme_selector_page.dart';
import '../achievements/achievements_page.dart';
import '../settings/reminders_page.dart';
import '../settings/settings_page.dart';

enum FeatureMenuGroup {
  personalization,
  progress,
  productivity,
  data,
}

class FeatureMenuItem {
  final String id;
  final IconData icon;
  final String Function(AppLocalizations) title;
  final void Function(BuildContext context, WidgetRef ref) onTap;
  final bool Function(WidgetRef ref) isVisible;

  const FeatureMenuItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isVisible,
  });
}

class FeatureMenuRegistry {
  static Map<FeatureMenuGroup, List<FeatureMenuItem>> getCategorizedItems(
    BuildContext context,
    WidgetRef ref, {
    required VoidCallback onDailyGoalsTap,
    required VoidCallback onSessionsTap,
    required VoidCallback onCounterSettingsTap,
    required dynamic activeDhikr,
  }) {
    final Map<FeatureMenuGroup, List<FeatureMenuItem>> menu = {
      FeatureMenuGroup.personalization: [
        FeatureMenuItem(
          id: 'themes',
          icon: Icons.palette_rounded,
          title: (l) => l.menuThemes,
          onTap: (ctx, _) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const ThemeSelectorPage())),
          isVisible: (_) => true,
        ),
        FeatureMenuItem(
          id: 'counter_settings',
          icon: Icons.tune_rounded,
          title: (l) => l.menuCounterSettings,
          onTap: (_, __) => onCounterSettingsTap(),
          isVisible: (_) => true,
        ),
      ],
      FeatureMenuGroup.progress: [
        FeatureMenuItem(
          id: 'daily_goals',
          icon: Icons.track_changes_rounded,
          title: (l) => l.menuDailyGoals,
          onTap: (_, __) => onDailyGoalsTap(),
          isVisible: (_) => true,
        ),
        FeatureMenuItem(
          id: 'achievements',
          icon: Icons.emoji_events_rounded,
          title: (l) => l.menuAchievements,
          onTap: (ctx, _) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AchievementsPage())),
          isVisible: (_) => true,
        ),
      ],
      FeatureMenuGroup.productivity: [
        FeatureMenuItem(
          id: 'sessions',
          icon: Icons.timer_outlined,
          title: (l) => l.menuSessions,
          onTap: (_, __) => onSessionsTap(),
          isVisible: (_) => true,
        ),
        FeatureMenuItem(
          id: 'reminders',
          icon: Icons.notifications_active_rounded,
          title: (l) => l.menuSmartReminders,
          onTap: (ctx, _) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const RemindersPage())),
          isVisible: (ref) => ref.watch(authProvider).status == AuthStatus.authenticated,
        ),
      ],
      FeatureMenuGroup.data: [
        FeatureMenuItem(
          id: 'backup_restore',
          icon: Icons.backup_rounded,
          title: (l) => l.menuBackupRestore,
          onTap: (ctx, _) => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const SettingsPage(showBackButton: true))),
          isVisible: (_) => true,
        ),
      ],
    };

    return menu;
  }
}
