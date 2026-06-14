import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/tasbih_session_model.dart';
import 'tasbih_page.dart';

class SessionSummaryPage extends StatefulWidget {
  final TasbihSessionModel session;

  const SessionSummaryPage({super.key, required this.session});

  @override
  State<SessionSummaryPage> createState() => _SessionSummaryPageState();
}

class _SessionSummaryPageState extends State<SessionSummaryPage> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    // Start confetti burst after screen loads
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    if (mins == 0) {
      return '$secs ثانیە';
    }
    return '$mins خولەک و $secs ثانیە';
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final String dhikrName = widget.session.customDhikrName ??
        widget.session.dhikr?.name ??
        (locale == 'ku' ? 'تەسبیحی گشتی' : (locale == 'ar' ? 'تسبيح عام' : 'General Dhikr'));

    return Scaffold(
      backgroundColor: cs.bg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Celebration Icon / Checkmark
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.primary.withValues(alpha: 0.2), width: 3),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          color: cs.primary,
                          size: 56,
                        ),
                      ),
                    )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.elasticOut)
                        .shimmer(delay: 500.ms, duration: 1000.ms),
                  ),
                  const SizedBox(height: 24),

                  // Celebration Text
                  Text(
                    locale == 'ku' ? 'قبوڵ بێت إن شاء الله' : (locale == 'ar' ? 'تقبل الله منكم' : 'May Allah Accept from You'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.2, end: 0.0),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    locale == 'ku'
                        ? 'بە سەرکەوتوویی خولی زیکرت تەواو کرد'
                        : (locale == 'ar' ? 'لقد أكملت جلسة الذكر بنجاح' : 'You have successfully completed your dhikr session'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: cs.textSecondary,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.2, end: 0.0),

                  const SizedBox(height: 32),

                  // Main Summary Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cs.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: cs.cardBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Selected Dhikr Name
                        Text(
                          locale == 'ku' ? 'زیکرەکە' : (locale == 'ar' ? 'الذكر' : 'Dhikr'),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: cs.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dhikrName,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'UthmanicHafs',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // Stats Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryItem(
                                label: locale == 'ku' ? 'ژمارەی زیکر' : (locale == 'ar' ? 'العدد الكلي' : 'Total Count'),
                                value: '${widget.session.totalCount}',
                                icon: Icons.exposure_plus_1_rounded,
                                iconColor: Colors.blue,
                                cs: cs,
                              ),
                            ),
                            Container(width: 1.5, height: 45, color: cs.divider.withValues(alpha: 0.5)),
                            Expanded(
                              child: _buildSummaryItem(
                                label: locale == 'ku' ? 'تێکڕای خێرایی' : (locale == 'ar' ? 'معدل السرعة' : 'Avg Speed'),
                                value: '${widget.session.avgPerMinute.toStringAsFixed(1)} / خولەک',
                                icon: Icons.speed_rounded,
                                iconColor: Colors.orange,
                                cs: cs,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // Duration Item
                        _buildSummaryRowItem(
                          label: locale == 'ku' ? 'ماوەی خول' : (locale == 'ar' ? 'مدة الجلسة' : 'Duration'),
                          value: _formatDuration(widget.session.durationSeconds),
                          icon: Icons.timer_outlined,
                          cs: cs,
                        ),

                        const SizedBox(height: 12),

                        // Date Item
                        _buildSummaryRowItem(
                          label: locale == 'ku' ? 'ڕێکەوت' : (locale == 'ar' ? 'التاريخ' : 'Date'),
                          value: widget.session.sessionDate,
                          icon: Icons.calendar_today_rounded,
                          cs: cs,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 450.ms, duration: 500.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), curve: Curves.easeOut),

                  const SizedBox(height: 40),

                  // Back Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to TasbihPage, removing intermediate routes
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const TasbihPage(showBackButton: true)),
                        (route) => route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      shadowColor: cs.primary.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      locale == 'ku' ? 'گەڕانەوە بۆ تەسبیح' : (locale == 'ar' ? 'العودة للتسبيح' : 'Back to Tasbih'),
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                ],
              ),
            ),
          ),

          // Confetti generator Overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.amber,
                Colors.blue,
                Colors.red,
                Colors.purple,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required AppColorScheme cs,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: cs.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRowItem({
    required String label,
    required String value,
    required IconData icon,
    required AppColorScheme cs,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: cs.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: cs.textPrimary,
          ),
        ),
      ],
    );
  }
}
