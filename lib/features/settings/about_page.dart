import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';

// ─────────────────────────────────────────────────────────────────────────────
// About Page
// ─────────────────────────────────────────────────────────────────────────────

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

    final languageCode = Localizations.localeOf(context).languageCode;
    final isRtl = languageCode == 'ku' || languageCode == 'ar';
    final textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;

    final devTitle = languageCode == 'ku'
        ? 'دروستکراوە لەلایەن:'
        : (languageCode == 'ar' ? 'تم التطوير بواسطة:' : 'Developed by:');
    final devName = languageCode == 'ku'
        ? 'ئەندازیار عبدالرحمن إسماعیل'
        : (languageCode == 'ar' ? 'المهندس عبدالرحمن إسماعيل' : 'Eng. Abdulrahman Ismail');

    return Scaffold(
      backgroundColor: cs.bg,
      body: Directionality(
        textDirection: textDirection,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Hero Header ──────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: isDark
                  ? AppColorScheme.darken(cs.primary, 0.35)
                  : cs.primary,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                l.aboutTitle,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColorScheme.darken(cs.primary, 0.40),
                              AppColorScheme.darken(cs.primary, 0.22),
                            ]
                          : [cs.primaryDeep, cs.primary],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 48),
                        // Logo
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(14),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.auto_stories_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                        ).animate().scale(
                              duration: 400.ms,
                              curve: Curves.easeOutBack,
                            ),

                        const SizedBox(height: 12),

                        Text(
                          l.appName,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(duration: 350.ms, delay: 150.ms),

                        const SizedBox(height: 5),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                            ),
                          ),
                          child: Text(
                            l.aboutVersion(l.localeCode == 'en' ? '1.0.0' : '١.٠.٠'),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ).animate().fadeIn(duration: 350.ms, delay: 200.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ─────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 1. Description Card
                  _AboutCard(
                    cs: cs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                            cs: cs,
                            label: l.aboutAppTitle,
                            icon: Icons.auto_stories_rounded),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Text(
                          l.aboutDescription,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            height: 1.9,
                            color: cs.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 80.ms),

                  const SizedBox(height: 14),

                  // 2. Tips (Feedback note banner)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: cs.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.lightbulb_rounded,
                              color: cs.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l.aboutFeedbackNote,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              height: 1.7,
                              color: cs.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 130.ms),

                  const SizedBox(height: 14),

                  // 3. Features Card (Moved up below Tips!)
                  _AboutCard(
                    cs: cs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                            cs: cs,
                            label: l.aboutFeatures,
                            icon: Icons.stars_rounded),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        ...[
                          (Icons.menu_book_rounded, l.aboutFeatQuran),
                          (Icons.headphones_rounded, l.aboutFeatAudio),
                          (Icons.school_rounded, l.aboutFeatTajweed),
                          (Icons.bookmark_rounded, l.aboutFeatBookmark),
                          (Icons.bar_chart_rounded, l.aboutFeatStats),
                          (Icons.notifications_rounded, l.aboutFeatNotif),
                          (Icons.mosque_rounded, l.aboutFeatPrayer),
                        ].map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: cs.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child:
                                      Icon(item.$1, size: 16, color: cs.primary),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.$2,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
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
                  ).animate().fadeIn(duration: 300.ms, delay: 180.ms),

                  const SizedBox(height: 14),

                  // 4. Developer Info Card (Inside a border/box)
                  _AboutCard(
                    cs: cs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                          cs: cs,
                          label: devTitle,
                          icon: Icons.badge_rounded,
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.person_rounded, color: cs.primary, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    devName,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: cs.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(const ClipboardData(text: '07504342452'));
                                      _showCopied(
                                        context,
                                        cs,
                                        languageCode == 'ku'
                                            ? 'ژمارە کۆپی کرا'
                                            : (languageCode == 'ar'
                                                ? 'تم نسخ الرقم'
                                                : 'Phone number copied'),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '07504342452',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 12,
                                            color: cs.textSecondary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(Icons.copy_rounded, size: 12, color: cs.textSecondary),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 220.ms),

                  const SizedBox(height: 14),

                  // 5. Contact Us Card (Moved above the verse card at the end)
                  _AboutCard(
                    cs: cs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardTitle(
                            cs: cs,
                            label: l.aboutContactUs,
                            icon: Icons.connect_without_contact_rounded),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        _SocialRow(
                          cs: cs,
                          icon: Icons.email_rounded,
                          label: l.aboutEmail,
                          value: 'aghaas7421@gmail.com',
                          color: const Color(0xFFEA4335),
                          onTap: () {
                            Clipboard.setData(const ClipboardData(
                                text: 'aghaas7421@gmail.com'));
                            _showCopied(context, cs, l.aboutEmailCopied);
                          },
                        ),
                        const Divider(height: 20),
                        _SocialRow(
                          cs: cs,
                          icon: Icons.send_rounded,
                          label: l.aboutTelegram,
                          value: '@Agha_ACE',
                          color: const Color(0xFF0088CC),
                          onTap: () {
                            Clipboard.setData(
                                const ClipboardData(text: '@Agha_ACE'));
                            _showCopied(context, cs, l.aboutTelegramCopied);
                          },
                        ),
                        const Divider(height: 20),
                        _SocialRow(
                          cs: cs,
                          icon: Icons.phone_rounded,
                          label: l.aboutWhatsapp,
                          value: '07504342452',
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF24292E),
                          onTap: () {
                            Clipboard.setData(const ClipboardData(
                                text: '07504342452'));
                            _showCopied(context, cs, l.aboutWhatsappCopied);
                          },
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 260.ms),

                  const SizedBox(height: 24),

                  // 6. Quran verse banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                AppColorScheme.darken(cs.primary, 0.38),
                                AppColorScheme.darken(cs.primary, 0.25),
                              ]
                            : [cs.primaryDeep, cs.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.3),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا',
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'UthmanicHafs',
                            fontSize: 22,
                            color: Colors.white,
                            height: 2.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.aboutVerseRef,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCopied(
      BuildContext context, AppColorScheme cs, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: cs.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.cs, required this.child});
  final AppColorScheme cs;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(
      {required this.cs, required this.label, required this.icon});
  final AppColorScheme cs;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: cs.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
        ),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({
    required this.cs,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final AppColorScheme cs;
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy_rounded, size: 13, color: cs.textSecondary),
              const SizedBox(width: 4),
              Text(
                l.aboutCopy,
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
    );
  }
}
