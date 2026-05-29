import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final showKurdish = ref.watch(showKurdishTranslationProvider);
    final showEnglish = ref.watch(showEnglishTranslationProvider);

    double sliderVal = 1.0;
    if (fontSize <= 20.0) {
      sliderVal = 0.0;
    } else if (fontSize >= 32.0) {
      sliderVal = 2.0;
    }

    return Scaffold(
      backgroundColor: cs.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            // Title
            Text(
              context.l10n.settingsTitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: cs.textPrimary,
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // ── Appearance ─────────────────────────────────────────
            _SectionLabel(label: context.l10n.settingsAppearance, cs: cs),
            const SizedBox(height: 10),
            _ThemeSelector(
              current: themeMode,
              cs: cs,
              onChanged: (mode) => ref.read(themeModeProvider.notifier).setMode(mode),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 24),

            // ── Font Size ───────────────────────────────────────────
            _SectionLabel(label: context.l10n.settingsFontSize, cs: cs),
            const SizedBox(height: 10),
            _SettingsCard(
              cs: cs,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.text_fields_rounded, size: 20, color: cs.primary),
                          const SizedBox(width: 10),
                          Text(
                            context.l10n.settingsFontSize,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: cs.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        sliderVal == 0.0
                            ? context.l10n.settingsFontSmall
                            : (sliderVal == 1.0
                                ? context.l10n.settingsFontMedium
                                : context.l10n.settingsFontLarge),
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: cs.primary,
                      inactiveTrackColor: cs.primary.withValues(alpha: 0.15),
                      thumbColor: cs.primary,
                      overlayColor: cs.primary.withValues(alpha: 0.1),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: sliderVal,
                      min: 0,
                      max: 2,
                      divisions: 2,
                      onChanged: (val) {
                        double sizeValue = 26.0;
                        if (val == 0.0) { sizeValue = 20.0; }
                        else if (val == 2.0) { sizeValue = 32.0; }
                        ref.read(fontSizeProvider.notifier).setSize(sizeValue);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <String>[
                      context.l10n.settingsFontSmall,
                      context.l10n.settingsFontMedium,
                      context.l10n.settingsFontLarge,
                    ]
                        .map((l) => Text(
                              l,
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  color: cs.textSecondary,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

            const SizedBox(height: 24),

            // ── Translations ────────────────────────────────────────
            _SectionLabel(label: context.l10n.settingsTranslations, cs: cs),
            const SizedBox(height: 10),
            _SettingsCard(
              cs: cs,
              child: Column(
                children: [
                  _ToggleRow(
                    icon: '🇮🇶',
                    label: context.l10n.settingsKuTranslation,
                    sub: context.l10n.settingsKuTranslationSub,
                    value: showKurdish,
                    cs: cs,
                    onChanged: (v) => ref.read(showKurdishTranslationProvider.notifier).setToggle(v),
                  ),
                  Divider(color: cs.divider, height: 20),
                  _ToggleRow(
                    icon: '🇬🇧',
                    label: context.l10n.settingsEnTranslation,
                    sub: context.l10n.settingsEnTranslationSub,
                    value: showEnglish,
                    cs: cs,
                    onChanged: (v) => ref.read(showEnglishTranslationProvider.notifier).setToggle(v),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 24),

            // ── Language ────────────────────────────────────────────
            _SectionLabel(label: context.l10n.settingsLanguage, cs: cs),
            const SizedBox(height: 10),
            const _LanguageSelector().animate().fadeIn(duration: 400.ms, delay: 250.ms),

            const SizedBox(height: 24),

            // ── About ───────────────────────────────────────────────
            _SectionLabel(label: context.l10n.settingsAbout, cs: cs),
            const SizedBox(height: 10),
            _AboutCard(cs: cs).animate().fadeIn(duration: 400.ms, delay: 300.ms),

            const SizedBox(height: 16),

            // App Footer
            Center(
              child: Column(
                children: [
                  Text(
                    context.l10n.settingsForKurdistan,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.settingsAppVersionDisplay,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Toggle Row ─────────────────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.sub,
    required this.value,
    required this.cs,
    required this.onChanged,
  });
  final String icon;
  final String label;
  final String sub;
  final bool value;
  final AppColorScheme cs;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: cs.textPrimary,
                ),
              ),
              Text(
                sub,
                style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Switch.adaptive(
          value: value,
          activeTrackColor: cs.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ── Theme selector ─────────────────────────────────────────────────────────────
class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.current, required this.cs, required this.onChanged});
  final ThemeMode current;
  final AppColorScheme cs;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ThemeOption(label: context.l10n.settingsSystemTheme, icon: Icons.settings_brightness_rounded, mode: ThemeMode.system, current: current, cs: cs, onChanged: onChanged),
        const SizedBox(width: 10),
        _ThemeOption(label: context.l10n.settingsLightMode, icon: Icons.light_mode_rounded, mode: ThemeMode.light, current: current, cs: cs, onChanged: onChanged),
        const SizedBox(width: 10),
        _ThemeOption(label: context.l10n.settingsDarkMode, icon: Icons.dark_mode_rounded, mode: ThemeMode.dark, current: current, cs: cs, onChanged: onChanged),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.mode,
    required this.current,
    required this.cs,
    required this.onChanged,
  });
  final String label;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode current;
  final AppColorScheme cs;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final isActive = current == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? cs.primary.withValues(alpha: 0.12) : cs.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isActive ? cs.primary : cs.cardBorder, width: isActive ? 1.5 : 1),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: isActive ? cs.primary : cs.textSecondary),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isActive ? cs.primary : cs.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Language selector ──────────────────────────────────────────────────────────
class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final activeLocale = ref.watch(localeProvider);

    final langs = [
      {'code': 'ku', 'label': context.l10n.settingsKurdish, 'flag': '🇮🇶'},
      {'code': 'ar', 'label': context.l10n.settingsArabic, 'flag': '🇸🇦'},
      {'code': 'en', 'label': context.l10n.settingsEnglish, 'flag': '🇬🇧'},
    ];

    return _SettingsCard(
      cs: cs,
      child: Column(
        children: langs.map((l) {
          final isActive = activeLocale.languageCode == l['code'];
          return GestureDetector(
            onTap: () => ref.read(localeProvider.notifier).setLocale(Locale(l['code']!)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? cs.primary.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isActive ? cs.primary : Colors.transparent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(l['flag']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Text(
                        l['label']!,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                          color: isActive ? cs.primary : cs.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (isActive) Icon(Icons.check_circle_rounded, size: 18, color: cs.primary),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── About card ─────────────────────────────────────────────────────────────────
class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.cs});
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      cs: cs,
      child: Column(
        children: [
          _AboutRow(icon: Icons.info_outline_rounded, label: context.l10n.appName, value: context.l10n.appSubtitle, cs: cs),
          Divider(color: cs.divider, height: 20),
          _AboutRow(icon: Icons.new_releases_outlined, label: context.l10n.settingsVersion, value: '1.0.0', cs: cs),
          Divider(color: cs.divider, height: 20),
          _AboutRow(icon: Icons.favorite_outline_rounded, label: context.l10n.settingsForKurdistan, value: '♥', cs: cs),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.icon, required this.label, required this.value, required this.cs});
  final IconData icon;
  final String label;
  final String value;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: cs.primary),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 14, color: cs.textPrimary)),
          ],
        ),
        Text(value, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textSecondary)),
      ],
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.cs});
  final String label;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: cs.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.cs, required this.child});
  final AppColorScheme cs;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }
}
