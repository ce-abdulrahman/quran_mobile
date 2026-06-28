import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/notification_service.dart';
import 'reminders_page.dart';
import 'prayer_method_settings_page.dart';
import '../../core/providers/backup_provider.dart';
import '../../core/local_db/content_package.dart';
import '../../core/providers/package_manager_provider.dart';
import '../../core/services/audio_download_manager.dart';
import 'download_manager_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Settings Page
// ─────────────────────────────────────────────────────────────────────────────

class SettingsPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const SettingsPage({super.key, this.showBackButton = false});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // ── Daily Notification state ─────────────────────────────────────
  bool _notifEnabled = false;
  int _notifHour = 8;
  int _notifMinute = 0;

  int _audioStorageBytes = 0;

  @override
  void initState() {
    super.initState();
    _loadAudioStorage();
    // Load notification settings from storage
    NotificationService.loadSettings().then((s) {
      if (mounted) {
        setState(() {
          _notifEnabled = (s['enabled'] as bool?) ?? false;
          _notifHour = (s['hour'] as int?) ?? 8;
          _notifMinute = (s['minute'] as int?) ?? 0;
        });
      }
    });
  }

  Future<void> _toggleNotifications(bool enabled) async {
    if (enabled) {
      final granted = await NotificationService().requestPermissions();
      if (!granted) return;
      await NotificationService().scheduleDailyNotifications(
        hour: _notifHour,
        minute: _notifMinute,
      );
    } else {
      await NotificationService().cancelAllNotifications();
    }
    await NotificationService.saveSettings(
      enabled: enabled,
      hour: _notifHour,
      minute: _notifMinute,
    );
    if (mounted) setState(() => _notifEnabled = enabled);
  }

  Future<void> _pickNotificationTime() async {
    final l = context.l10n;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _notifHour, minute: _notifMinute),
      helpText: l.settingsHelpText,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
    );
    if (picked == null) return;
    setState(() {
      _notifHour = picked.hour;
      _notifMinute = picked.minute;
    });
    await NotificationService.saveSettings(
      enabled: _notifEnabled,
      hour: _notifHour,
      minute: _notifMinute,
    );
    if (_notifEnabled) {
      await NotificationService().scheduleDailyNotifications(
        hour: _notifHour,
        minute: _notifMinute,
      );
    }
  }

  Future<void> _loadAudioStorage() async {
    final bytes = await AudioDownloadManager().getTotalStorageBytes();
    if (mounted) {
      setState(() {
        _audioStorageBytes = bytes;
      });
    }
  }

  void _showExportPasswordDialog(BuildContext context) {
    final l = context.l10n;
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l.settingsExportData,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.settingsExportNote,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l.settingsPasswordOptional,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l.actionCancel,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final pw = passwordController.text;
              await ref
                  .read(backupStateProvider.notifier)
                  .exportLocalBackup(pw.isNotEmpty ? pw : null);
            },
            child: Text(l.actionSend, style: const TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndImportData(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      if (!context.mounted) return;
      _showImportPasswordDialog(context, file);
    }
  }

  void _showImportPasswordDialog(BuildContext context, File file) {
    final l = context.l10n;
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l.settingsImportData,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.settingsImportNote,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l.settingsPassword,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l.actionCancel,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final pw = passwordController.text;
              final success = await ref
                  .read(backupStateProvider.notifier)
                  .importLocalBackup(file, password: pw.isNotEmpty ? pw : null);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l.settingsImportSuccess,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(
              l.settingsImportData,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineContentDownloader(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final downloadState = ref.watch(packageDownloadProgressProvider);

    return downloadState.when(
      data: (event) {
        if (!event.isCompleted) {
          return SizedBox(
            width: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: event.progress,
                  color: cs.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(event.progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
        return IconButton(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 20,
          ),
          onPressed: () => _downloadAllOfflineContent(context),
        );
      },
      error: (e, s) => IconButton(
        icon: const Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
          size: 20,
        ),
        onPressed: () => _downloadAllOfflineContent(context),
      ),
      loading: () => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Future<void> _downloadAllOfflineContent(BuildContext context) async {
    final l = context.l10n;
    final manager = ref.read(packageManagerProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l.settingsDownloadBackground,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
      ),
    );
    try {
      await manager.downloadPackage(ContentPackage.quran);
      await manager.downloadPackage(ContentPackage.tajweed);
      await manager.downloadPackage(ContentPackage.adhkar);
      await manager.downloadPackage(ContentPackage.hadith);
      await manager.downloadPackage(ContentPackage.tafsir);
      await manager.downloadPackage(ContentPackage.translations);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BackupState>(backupStateProvider, (previous, next) {
      if (next.successMessage != null &&
          next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.successMessage!,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage!,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final readerSettings = ref.watch(readerSettingsProvider);
    const p = 16.0;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColorScheme.darken(cs.primary, 0.35)
            : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          l.settingsTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Header Banner ─────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppColorScheme.darken(cs.primary, 0.35),
                        AppColorScheme.darken(cs.primary, 0.42),
                      ]
                    : [cs.primary, cs.primaryDeep],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        l.settingsTitle,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable content ─────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(p, 20, p, 40),
              physics: const BouncingScrollPhysics(),
              children: [
                // ── Appearance section ────────────────────────────
                _SectionLabel(label: l.settingsAppearance, cs: cs),
                const SizedBox(height: 10),

                // Theme card
                _SettingsCard(
                  cs: cs,
                  children: [
                    _SettingRow(
                      icon: Icons.palette_outlined,
                      label: l.settingsTheme,
                      cs: cs,
                      trailing: _ThemeSelector(
                        current: themeMode,
                        l: l,
                        onChanged: (m) =>
                            ref.read(themeModeProvider.notifier).setMode(m),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 50.ms),

                const SizedBox(height: 12),

                // Color Picker card
                _SettingsCard(
                  cs: cs,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.color_lens_rounded,
                                  size: 18,
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l.settingsCustomColor,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: cs.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _ColorPickerSection(
                            currentGradient: ref.watch(accentColorProvider),
                            onGradientSelected: (start, end, primary) => ref
                                .read(accentColorProvider.notifier)
                                .setGradient(start, end, primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 75.ms),

                const SizedBox(height: 16),

                // Font size card
                _SettingsCard(
                  cs: cs,
                  children: [
                    _SettingRow(
                      icon: Icons.text_fields_rounded,
                      label: l.settingsFontSize,
                      cs: cs,
                      trailing: Text(
                        '${readerSettings.fontSize.round()}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    Slider(
                      value: readerSettings.fontSize,
                      min: 12,
                      max: 40,
                      divisions: 28,
                      activeColor: cs.primary,
                      inactiveColor: cs.primary.withValues(alpha: 0.2),
                      onChanged: (v) => ref
                          .read(readerSettingsProvider.notifier)
                          .setFontSize(v),
                    ),

                    // Preview
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'UthmanicHafs',
                          fontSize: readerSettings.fontSize,
                          color: cs.textPrimary,
                          height: 2,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

                const SizedBox(height: 16),

                // ── Font Family card ──────────────────────────────
                _SectionLabel(label: l.settingsFontFamily, cs: cs),
                const SizedBox(height: 10),
                _SettingsCard(
                  cs: cs,
                  children: [
                    // UI Font Family
                    _SettingRow(
                      icon: Icons.font_download_rounded,
                      label: l.settingsFontUi,
                      subLabel: l.settingsFontUiSub,
                      cs: cs,
                      trailing: _FontDropdown(
                        cs: cs,
                        current: readerSettings.uiFontFamily,
                        options: const [
                          ('Cairo', 'Cairo'),
                          ('NotoNaskhArabic', 'Noto Naskh'),
                          ('Scheherazade', 'Scheherazade'),
                        ],
                        onChanged: (f) => ref
                            .read(readerSettingsProvider.notifier)
                            .setUiFontFamily(f),
                      ),
                    ),
                    const Divider(height: 1),
                    // Quran Font Family
                    _SettingRow(
                      icon: Icons.menu_book_rounded,
                      label: l.settingsFontQuran,
                      subLabel: l.settingsFontQuranSub,
                      cs: cs,
                      trailing: _FontDropdown(
                        cs: cs,
                        current: readerSettings.quranFontFamily,
                        options: const [
                          ('UthmanicHafs', 'Uthmanic Hafs'),
                          ('Amiri', 'Amiri'),
                          ('ScheherazadeNew', 'Scheherazade New'),
                        ],
                        onChanged: (f) => ref
                            .read(readerSettingsProvider.notifier)
                            .setQuranFontFamily(f),
                      ),
                    ),
                    const Divider(height: 1),
                    // Font Target
                    _SettingRow(
                      icon: Icons.tune_rounded,
                      label: l.settingsFontTarget,
                      subLabel: l.settingsFontTargetSub,
                      cs: cs,
                      trailing: _FontTargetSelector(
                        cs: cs,
                        current: readerSettings.fontTarget,
                        onChanged: (t) => ref
                            .read(readerSettingsProvider.notifier)
                            .setFontTarget(t),
                      ),
                    ),
                    // Live preview
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.bg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: readerSettings.quranFontFamily,
                              fontSize: readerSettings.fontSize,
                              color: cs.textPrimary,
                              height: 1.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l.settingsFontUiSample,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: readerSettings.uiFontFamily,
                              fontSize: 13,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 110.ms),

                const SizedBox(height: 16),

                // Translations card
                _SectionLabel(label: l.settingsTranslations, cs: cs),
                const SizedBox(height: 10),
                _SettingsCard(
                  cs: cs,
                  children: [
                    _SettingRow(
                      icon: Icons.translate_rounded,
                      label: l.settingsShowKurdish,
                      cs: cs,
                      trailing: Switch(
                        value: readerSettings.showKurdish == true,
                        activeThumbColor: cs.primary,
                        onChanged: (v) => ref
                            .read(readerSettingsProvider.notifier)
                            .toggleKurdish(v),
                      ),
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: Icons.language_rounded,
                      label: l.settingsShowEnglish,
                      cs: cs,
                      trailing: Switch(
                        value: readerSettings.showEnglish == true,
                        activeThumbColor: cs.primary,
                        onChanged: (v) => ref
                            .read(readerSettingsProvider.notifier)
                            .toggleEnglish(v),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 120.ms),

                const SizedBox(height: 16),

                // ── General section ───────────────────────────────
                _SectionLabel(label: l.settingsGeneral, cs: cs),
                const SizedBox(height: 10),

                _SettingsCard(
                  cs: cs,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Consumer(
                            builder: (context, ref, _) {
                              final currentLocale = ref.watch(
                                appLocaleProvider,
                              );
                              final localL10n = context.l10n;
                              return AlertDialog(
                                title: Text(
                                  localL10n.settingsLanguage,
                                  style: const TextStyle(fontFamily: 'Cairo'),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _LanguageOption(
                                      label: 'کوردی',
                                      code: 'ku',
                                      active:
                                          currentLocale.languageCode == 'ku',
                                      onTap: () {
                                        ref
                                            .read(appLocaleProvider.notifier)
                                            .setLocale('ku');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    _LanguageOption(
                                      label: 'العربية',
                                      code: 'ar',
                                      active:
                                          currentLocale.languageCode == 'ar',
                                      onTap: () {
                                        ref
                                            .read(appLocaleProvider.notifier)
                                            .setLocale('ar');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    _LanguageOption(
                                      label: 'English',
                                      code: 'en',
                                      active:
                                          currentLocale.languageCode == 'en',
                                      onTap: () {
                                        ref
                                            .read(appLocaleProvider.notifier)
                                            .setLocale('en');
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      child: _SettingRow(
                        icon: Icons.language_outlined,
                        label: l.settingsLanguage,
                        cs: cs,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ref.watch(appLocaleProvider).languageCode == 'ku'
                                ? 'کوردی'
                                : (ref.watch(appLocaleProvider).languageCode ==
                                          'ar'
                                      ? 'العربية'
                                      : 'English'),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 150.ms),

                const SizedBox(height: 16),

                // ── Notifications section ─────────────────────────
                _SectionLabel(label: l.settingsDailyNotification, cs: cs),
                const SizedBox(height: 10),
                _SettingsCard(
                  cs: cs,
                  children: [
                    // Toggle
                    _SettingRow(
                      icon: Icons.notifications_active_rounded,
                      label: l.settingsDailyNotification,
                      subLabel: l.settingsDailyNotificationSub,
                      cs: cs,
                      trailing: Switch(
                        value: _notifEnabled,
                        activeThumbColor: cs.primary,
                        onChanged: _toggleNotifications,
                      ),
                    ),
                    // Time picker row (only visible when enabled)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _notifEnabled
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(height: 1),
                          _SettingRow(
                            icon: Icons.schedule_rounded,
                            label: l.settingsNotificationTime,
                            cs: cs,
                            trailing: GestureDetector(
                              onTap: _pickNotificationTime,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: cs.primary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 14,
                                      color: cs.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_notifHour.toString().padLeft(2, '0')}:${_notifMinute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: cs.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      secondChild: const SizedBox.shrink(),
                    ),
                    const Divider(height: 1),
                    _SettingRow(
                      icon: Icons.alarm_on_rounded,
                      label: l.settingsSmartReminder,
                      subLabel: l.settingsSmartReminderSub,
                      cs: cs,
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: cs.primary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RemindersPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 175.ms),

                const SizedBox(height: 16),

                // ── Calculation Method card ────────────────────────
                _SectionLabel(label: l.settingsCalculationMethod, cs: cs),
                const SizedBox(height: 10),
                _SettingsCard(
                  cs: cs,
                  children: [
                    _SettingRow(
                      icon: Icons.settings_suggest_rounded,
                      label: l.settingsCalculationMethod,
                      subLabel: l.settingsCalculationMethodSub,
                      cs: cs,
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: cs.primary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PrayerMethodSettingsPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 180.ms),

                const SizedBox(height: 16),

                // ── Data Management section ─────────────────────────
                _SectionLabel(
                  label: l.settingsDataManagement,
                  cs: cs,
                ),
                const SizedBox(height: 10),
                _SettingsCard(
                  cs: cs,
                  children: [
                    // Export local data
                    _SettingRow(
                      icon: Icons.upload_file_rounded,
                      label: l.settingsExportData,
                      subLabel: l.settingsExportDataSub,
                      cs: cs,
                      trailing: IconButton(
                        icon: Icon(Icons.share_rounded, color: cs.primary),
                        onPressed: () => _showExportPasswordDialog(context),
                      ),
                    ),
                    const Divider(height: 1),
                    // Import local data
                    _SettingRow(
                      icon: Icons.file_download_rounded,
                      label: l.settingsImportData,
                      subLabel: l.settingsImportDataSub,
                      cs: cs,
                      trailing: IconButton(
                        icon: Icon(Icons.file_open_rounded, color: cs.primary),
                        onPressed: () => _pickAndImportData(context),
                      ),
                    ),
                    const Divider(height: 1),
                    // Download offline content
                    _SettingRow(
                      icon: Icons.download_for_offline_rounded,
                      label: l.settingsDownloadAll,
                      subLabel: l.settingsDownloadAllSub,
                      cs: cs,
                      trailing: _buildOfflineContentDownloader(context),
                    ),
                    const Divider(height: 1),
                    // Audio & Package Downloads Unified Manager
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DownloadManagerPage(),
                          ),
                        ).then((_) => _loadAudioStorage());
                      },
                      child: _SettingRow(
                        icon: Icons.download_for_offline_rounded,
                        label: l.settingsDownloadManager,
                        subLabel: l.settingsDownloadManagerSub,
                        cs: cs,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(_audioStorageBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: cs.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: cs.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms, delay: 190.ms),

                const SizedBox(height: 32),

                // ── App branding ──────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.auto_stories_rounded,
                              color: cs.primary,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l.appName,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.settingsVersion,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Theme Selector
// ─────────────────────────────────────────────────────────────────────────────

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({
    required this.current,
    required this.l,
    required this.onChanged,
  });

  final ThemeMode current;
  final AppLocalizations l;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final modes = [
      (ThemeMode.light, Icons.light_mode_rounded, l.settingsLight),
      (ThemeMode.dark, Icons.dark_mode_rounded, l.settingsDark),
    ];

    final cs = AppColorScheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: modes.map((m) {
        final mode = m.$1;
        final icon = m.$2;
        final label = m.$3;
        final active = mode == current;
        return GestureDetector(
          onTap: () => onChanged(mode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: active ? cs.primary : cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: active ? Colors.white : cs.primary),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : cs.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.cs});
  final String label;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        label,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: cs.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.cs, required this.children});
  final AppColorScheme cs;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(children: children),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.cs,
    required this.trailing,
    this.subLabel,
  });

  final IconData icon;
  final String label;
  final String? subLabel;
  final AppColorScheme cs;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Leading icon
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: cs.primary),
          ),

          const SizedBox(width: 12),

          // Label (RTL)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.textPrimary,
                  ),
                ),
                if (subLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subLabel!,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Trailing
          trailing,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Color Picker Section (Gradient Swatches)
// ─────────────────────────────────────────────────────────────────────────────

class _ColorPickerSection extends StatelessWidget {
  const _ColorPickerSection({
    required this.currentGradient,
    required this.onGradientSelected,
  });
  final AccentGradient currentGradient;
  final void Function(Color start, Color end, Color primary) onGradientSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 10,
      runSpacing: 10,
      children: AppColors.accentGradientOptions.map((entry) {
        final startColor = entry.$1;
        final endColor = entry.$2;
        final primaryColor = entry.$3;
        final label = entry.$4;
        final isSelected =
            currentGradient.start.toARGB32() == startColor.toARGB32();

        return Tooltip(
          message: label,
          child: GestureDetector(
            onTap: () => onGradientSelected(startColor, endColor, primaryColor),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              width: isSelected ? 46 : 40,
              height: isSelected ? 46 : 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [startColor, endColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.9)
                      : Colors.transparent,
                  width: isSelected ? 2.5 : 0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.55),
                          blurRadius: 14,
                          spreadRadius: 2,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
        )
            .animate(
                key: ValueKey(
                    '${startColor.toARGB32()}_$isSelected'))
            .scale(
              begin: const Offset(0.85, 0.85),
              end: const Offset(1.0, 1.0),
              duration: 200.ms,
              curve: Curves.easeOutBack,
            );
      }).toList(),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String code;
  final bool active;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.code,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          color: active ? cs.primary : cs.textPrimary,
        ),
      ),
      trailing: active
          ? Icon(Icons.check_circle_rounded, color: cs.primary)
          : null,
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Font Dropdown
// ─────────────────────────────────────────────────────────────────────────────

class _FontDropdown extends StatelessWidget {
  const _FontDropdown({
    required this.cs,
    required this.current,
    required this.options,
    required this.onChanged,
  });

  final AppColorScheme cs;
  final String current;
  final List<(String, String)> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (ctx) {
            return Container(
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...options.map(
                    (opt) => ListTile(
                      title: Text(
                        opt.$2,
                        style: TextStyle(
                          fontFamily: opt.$1,
                          fontSize: 15,
                          color: cs.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        opt.$1,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: cs.textSecondary,
                        ),
                      ),
                      trailing: current == opt.$1
                          ? Icon(Icons.check_circle_rounded,
                              color: cs.primary)
                          : null,
                      onTap: () {
                        onChanged(opt.$1);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              options.firstWhere((o) => o.$1 == current,
                      orElse: () => options.first)
                  .$2,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more_rounded, size: 14, color: cs.primary),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Font Target Selector
// ─────────────────────────────────────────────────────────────────────────────

class _FontTargetSelector extends StatelessWidget {
  const _FontTargetSelector({
    required this.cs,
    required this.current,
    required this.onChanged,
  });

  final AppColorScheme cs;
  final String current;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final targets = [
      ('ui', 'UI'),
      ('reader', l.settingsFontTargetReader),
      ('both', l.settingsFontTargetBoth),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: targets.map((t) {
        final active = t.$1 == current;
        return GestureDetector(
          onTap: () => onChanged(t.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(left: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: active ? cs.primary : cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              t.$2,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : cs.primary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
