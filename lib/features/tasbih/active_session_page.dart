import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/tasbih_session_provider.dart';
import 'session_summary_page.dart';
import '../../core/providers/tasbih_theme_provider.dart';
import '../../core/models/tasbih_theme_model.dart';
import '../../core/models/user_theme_preference_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class ActiveSessionPage extends ConsumerStatefulWidget {
  const ActiveSessionPage({super.key});

  @override
  ConsumerState<ActiveSessionPage> createState() => _ActiveSessionPageState();
}

class _ActiveSessionPageState extends ConsumerState<ActiveSessionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringCtrl;
  late final Animation<double> _ringAnim;
  
  Offset? _ripplePos;
  bool _rippleVisible = false;
  Timer? _rippleTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playThemeSound(TasbihThemeModel? theme, UserThemePreferenceModel prefs) {
    if (!prefs.soundEnabled) return;
    
    // Default fallback if no theme or metadata is set
    if (theme == null || theme.themeMetadata['sound'] == null) {
      _audioPlayer.play(AssetSource('sounds/click.wav'));
      return;
    }
    
    final sound = theme.themeMetadata['sound'];
    if (sound['type'] == 'silent') {
      // Theme explicitly uses no sound — respect the choice
      return;
    }

    final localPath = ref.read(tasbihThemeProvider.notifier).getLocalAssetPath(theme, 'sound');
    if (localPath != null && File(localPath).existsSync()) {
      _audioPlayer.play(DeviceFileSource(localPath));
    } else {
      // CDN asset not downloaded yet — use the local click sound as fallback
      _audioPlayer.play(AssetSource('sounds/click.wav'));
    }
  }

  void _triggerThemeHaptics(TasbihThemeModel? theme, UserThemePreferenceModel prefs) {
    if (!prefs.hapticEnabled) return;
    
    // Default fallback if no theme or metadata is set
    if (theme == null || theme.themeMetadata['haptic'] == null) {
      HapticFeedback.mediumImpact();
      return;
    }
    
    final haptic = theme.themeMetadata['haptic'];
    final profile = haptic['profile'] ?? 'medium';
    switch (profile) {
      case 'soft':
          HapticFeedback.lightImpact();
          break;
        case 'medium':
          HapticFeedback.mediumImpact();
          break;
        case 'strong':
          HapticFeedback.heavyImpact();
          break;
        case 'disabled':
          // Theme says no haptic — but user enabled haptics, so light touch
          HapticFeedback.selectionClick();
          break;
      default:
          HapticFeedback.mediumImpact();
      }
  }

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.linear);
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _rippleTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTap(TapDownDetails details) {
    final sessionState = ref.read(tasbihSessionProvider);
    if (sessionState.isPaused) return;

    final themeState = ref.read(tasbihThemeProvider);
    _playThemeSound(themeState.activeTheme, themeState.activePreferences);
    _triggerThemeHaptics(themeState.activeTheme, themeState.activePreferences);

    ref.read(tasbihSessionProvider.notifier).increment();

    setState(() {
      _ripplePos = details.localPosition;
      _rippleVisible = true;
    });

    _rippleTimer?.cancel();
    _rippleTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _rippleVisible = false);
    });
  }

  String _formatDuration(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _calculateCurrentRate(int count, int seconds) {
    if (seconds <= 0) return 0.0;
    return (count / seconds) * 60.0;
  }

  void _handleEndSession() async {
    final locale = Localizations.localeOf(context).languageCode;
    final title = locale == 'ku' ? 'کۆتایی هێنان بە خول' : (locale == 'ar' ? 'إنهاء الجلسة' : 'End Session');
    final desc = locale == 'ku'
        ? 'دڵنیایت لە کۆتایی هێنان بەم خولەی تەسبیح خوێندنە؟'
        : (locale == 'ar' ? 'هل أنت متأكد من إنهاء جلسة التسبيح الحالية؟' : 'Are you sure you want to end this Tasbih session?');
    final cancelText = locale == 'ku' ? 'پاشگەزبوونەوە' : (locale == 'ar' ? 'إلغاء' : 'Cancel');
    final confirmText = locale == 'ku' ? 'کۆتایی پێ بهێنە' : (locale == 'ar' ? 'إنهاء' : 'End Session');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColorScheme.of(context).card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: Text(
          desc,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelText, style: const TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmText,
              style: const TextStyle(fontFamily: 'Cairo', color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // Hide floating overlay if exists
      TasbihSessionOverlay.hide();
      
      final completedSession = await ref.read(tasbihSessionProvider.notifier).end();
      if (completedSession != null && mounted) {
        // Navigate to summary page replacing this screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SessionSummaryPage(session: completedSession),
          ),
        );
      } else if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _enterMinimalMode() {
    ref.read(tasbihSessionProvider.notifier).setMode('minimal');
    TasbihSessionOverlay.show(context);
    Navigator.pop(context);
  }

  Widget _buildThemeBackground(BuildContext context, TasbihThemeModel theme, bool isDark) {
    final metadata = theme.themeMetadata;
    final bgConfig = metadata['background'] ?? {};
    final type = bgConfig['type'] ?? 'gradient';
    final value = bgConfig['value'] ?? '';

    if (type == 'image') {
      if (value.startsWith('assets/')) {
        return Positioned.fill(
          child: Opacity(
            opacity: isDark ? 0.15 : 0.25,
            child: Image.asset(
              value,
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        final localPath = ref.read(tasbihThemeProvider.notifier).getLocalAssetPath(theme, 'background');
        if (localPath != null && File(localPath).existsSync()) {
          return Positioned.fill(
            child: Opacity(
              opacity: isDark ? 0.15 : 0.25,
              child: Image.file(
                File(localPath),
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      }
    }

    // Gradient Parsing
    Color startColor = Colors.transparent;
    Color endColor = Colors.transparent;

    if (value.toString().contains('#')) {
      final hexes = RegExp(r'#[0-9a-fA-F]{6}').allMatches(value.toString());
      if (hexes.length >= 2) {
        startColor = Color(int.parse(hexes.elementAt(0).group(0)!.replaceAll('#', '0xFF'))).withOpacity(isDark ? 0.1 : 0.2);
        endColor = Color(int.parse(hexes.elementAt(1).group(0)!.replaceAll('#', '0xFF'))).withOpacity(isDark ? 0.15 : 0.3);
      } else if (hexes.length == 1) {
        startColor = Color(int.parse(hexes.elementAt(0).group(0)!.replaceAll('#', '0xFF'))).withOpacity(isDark ? 0.1 : 0.2);
      }
    }

    if (startColor != Colors.transparent) {
      return Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [startColor, endColor == Colors.transparent ? startColor : endColor],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(tasbihSessionProvider);
    final cs = AppColorScheme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    if (sessionState.isLoading) {
      return Scaffold(
        backgroundColor: cs.bg,
        body: Center(
          child: CircularProgressIndicator(color: cs.primary),
        ),
      );
    }

    final activeSession = sessionState.activeSession;
    if (activeSession == null) {
      return Scaffold(
        backgroundColor: cs.bg,
        body: Center(
          child: Text(
            locale == 'ku' ? 'هیچ خولێکی چالاک نییە' : (locale == 'ar' ? 'لا توجد جلسة نشطة' : 'No active session'),
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
          ),
        ),
      );
    }

    final String dhikrName = activeSession.customDhikrName ??
        activeSession.dhikr?.name ??
        (locale == 'ku' ? 'تەسبیحی گشتی' : (locale == 'ar' ? 'تسبيح عام' : 'General Dhikr'));

    final currentRate = _calculateCurrentRate(sessionState.currentCount, sessionState.activeDurationSeconds);

    // Render Normal vs Focus Modes
    if (sessionState.mode == 'focus') {
      return _buildFocusMode(context, sessionState, dhikrName, currentRate, cs);
    }

    return _buildNormalMode(context, sessionState, dhikrName, currentRate, cs, locale);
  }

  Widget _buildNormalMode(
    BuildContext context,
    TasbihSessionState state,
    String dhikrName,
    double currentRate,
    AppColorScheme cs,
    String locale,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeState = ref.watch(tasbihThemeProvider);
    final activeTheme = themeState.activeTheme;

    // Resolve ring configurations
    Color ringColor = cs.primary;
    double ringWidth = 8.0;
    bool glow = true;
    String animationType = 'ripple';

    if (activeTheme != null) {
      final ringConfig = activeTheme.themeMetadata['ring'] ?? {};
      final colorStr = ringConfig['color'] ?? '#ffd700';
      ringColor = Color(int.parse(colorStr.replaceAll('#', '0xFF')));
      ringWidth = (ringConfig['width'] as num?)?.toDouble() ?? 8.0;
      glow = ringConfig['glow'] ?? true;
      animationType = ringConfig['animation'] ?? 'ripple';
    }

    if (themeState.activePreferences.customRingColor != null) {
      ringColor = Color(int.parse(themeState.activePreferences.customRingColor!.replaceAll('#', '0xFF')));
    }

    if (!themeState.activePreferences.animationEnabled) {
      animationType = 'none';
      glow = false;
    }

    // Resolve typography configurations
    Color textColor = state.isPaused ? cs.textSecondary : cs.primary;
    String fontFamily = 'Cairo';

    if (activeTheme != null) {
      final counterConfig = activeTheme.themeMetadata['counter'] ?? {};
      final textColorStr = counterConfig['text_color'] ?? '#ffffff';
      textColor = state.isPaused
          ? cs.textSecondary
          : Color(int.parse(textColorStr.replaceAll('#', '0xFF')));

      final typoConfig = activeTheme.themeMetadata['typography'] ?? {};
      final font = typoConfig['font_family'] ?? 'cairo';
      fontFamily = font == 'cairo' ? 'Cairo' : 'Courier';
    }

    final double fontScale = themeState.activePreferences.customFontScale;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          locale == 'ku' ? 'خولی زیکری چالاک' : (locale == 'ar' ? 'جلسة ذكر نشطة' : 'Active Dhikr Session'),
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_in_picture_alt_rounded, color: Colors.white),
            tooltip: locale == 'ku' ? 'مۆدی بچووککراو' : (locale == 'ar' ? 'الوضع المصغر' : 'Minimal Mode'),
            onPressed: _enterMinimalMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (activeTheme != null)
            _buildThemeBackground(context, activeTheme, isDark),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Active Dhikr Name Display
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.cardBorder, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      locale == 'ku' ? 'زیکری هەڵبژێردراو' : (locale == 'ar' ? 'الذكر الحالي' : 'Active Dhikr'),
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dhikrName,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Core Stats Cards row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatWidget(
                        title: locale == 'ku' ? 'ماوەی خول' : (locale == 'ar' ? 'المدة' : 'Duration'),
                        value: _formatDuration(state.activeDurationSeconds),
                        icon: Icons.timer_outlined,
                        cs: cs,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatWidget(
                        title: locale == 'ku' ? 'تێکڕای خێرایی' : (locale == 'ar' ? 'معدل السرعة' : 'Avg Speed'),
                        value: '${currentRate.toStringAsFixed(1)} / خولەک',
                        icon: Icons.speed_rounded,
                        cs: cs,
                      ),
                    ),
                  ],
                ),
              ),

              // Central Counting Tap Area
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTapDown: _onTap,
                      behavior: HitTestBehavior.opaque,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Rotating Arc Ring
                          if (!state.isPaused)
                            AnimatedBuilder(
                              animation: _ringAnim,
                              builder: (_, __) {
                                return CustomPaint(
                                  size: const Size(260, 260),
                                  painter: _RingPainter(
                                    progress: animationType == 'none' ? 0.0 : _ringAnim.value,
                                    isDark: isDark,
                                    color: ringColor,
                                    width: ringWidth,
                                    glow: glow,
                                    animationType: animationType,
                                  ),
                                );
                              },
                            )
                          else
                            Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: ringColor.withOpacity(0.3), width: 3),
                              ),
                            ),

                          // Central Count Circle
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.card,
                              boxShadow: [
                                BoxShadow(
                                  color: ringColor.withOpacity(isDark ? 0.05 : 0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              border: Border.all(color: cs.cardBorder, width: 2),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${state.currentCount}',
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: 64 * fontScale,
                                      fontWeight: FontWeight.w900,
                                      color: textColor,
                                      height: 1.0,
                                    ),
                                  ).animate(key: ValueKey('cnt-${state.currentCount}')).scale(
                                        begin: const Offset(1.18, 1.18),
                                        end: const Offset(1.0, 1.0),
                                        duration: 120.ms,
                                      ),
                                  const SizedBox(height: 4),
                                  Text(
                                    locale == 'ku' ? 'تەسبیح کراوە' : (locale == 'ar' ? 'تسبيحة' : 'taps'),
                                    style: TextStyle(
                                      fontFamily: fontFamily,
                                      fontSize: 12,
                                      color: textColor.withOpacity(0.7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Ripple Touch Effect
                          if (_rippleVisible && _ripplePos != null)
                            Positioned(
                              left: _ripplePos!.dx - 35,
                              top: _ripplePos!.dy - 35,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ringColor.withOpacity(0.18),
                                ),
                              )
                                  .animate()
                                  .scale(begin: const Offset(0.3, 0.3), end: const Offset(1.6, 1.6), duration: 350.ms, curve: Curves.easeOut)
                                  .fadeOut(duration: 350.ms),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Control Panel
              Container(
                color: cs.card,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sync / Online state indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: state.isSyncing
                                ? Colors.amber
                                : (state.unsyncedIncrements.isEmpty ? Colors.green : Colors.amber),
                          ),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fade(begin: 0.4, end: 1.0, duration: 800.ms),
                        const SizedBox(width: 8),
                        Text(
                          state.isSyncing
                              ? (locale == 'ku' ? 'خەریکی هاوکاتکردن...' : (locale == 'ar' ? 'جاري المزامنة...' : 'Syncing...'))
                              : (state.unsyncedIncrements.isEmpty
                                  ? (locale == 'ku' ? 'هاوکاتکراوە لەگەڵ سێرڤەر' : (locale == 'ar' ? 'تمت المزامنة' : 'Synced with server'))
                                  : (locale == 'ku' ? 'کارەکان لە بیرگەی ناوخۆدا پارێزراون' : (locale == 'ar' ? 'محفوظ محلياً' : 'Saved locally'))),
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Pause/Resume Button
                        ElevatedButton.icon(
                          onPressed: () {
                            if (state.isPaused) {
                              ref.read(tasbihSessionProvider.notifier).resume();
                            } else {
                              ref.read(tasbihSessionProvider.notifier).pause();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isPaused ? cs.primary : cs.divider.withValues(alpha: 0.5),
                            foregroundColor: state.isPaused ? Colors.white : cs.textPrimary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: Icon(state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
                          label: Text(
                            state.isPaused
                                ? (locale == 'ku' ? 'بەردەوامبە' : (locale == 'ar' ? 'استئناف' : 'Resume'))
                                : (locale == 'ku' ? 'ڕاگرتن' : (locale == 'ar' ? 'إيقاف مؤقت' : 'Pause')),
                            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Focus Mode Button
                        ElevatedButton.icon(
                          onPressed: () {
                            ref.read(tasbihSessionProvider.notifier).setMode('focus');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.cardBorder,
                            foregroundColor: cs.textPrimary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.fullscreen_rounded),
                          label: Text(
                            locale == 'ku' ? 'مۆدی سەرنج' : (locale == 'ar' ? 'وضع التركيز' : 'Focus'),
                            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                          ),
                        ),

                        // End Session Button
                        ElevatedButton.icon(
                          onPressed: _handleEndSession,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.stop_rounded),
                          label: Text(
                            locale == 'ku' ? 'کۆتایی' : (locale == 'ar' ? 'إنهاء' : 'End'),
                            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatWidget({
    required String title,
    required String value,
    required IconData icon,
    required AppColorScheme cs,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: cs.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 10, color: cs.textSecondary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusMode(
    BuildContext context,
    TasbihSessionState state,
    String dhikrName,
    double currentRate,
    AppColorScheme cs,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeState = ref.watch(tasbihThemeProvider);
    final activeTheme = themeState.activeTheme;

    // Resolve typography configurations
    Color textColor = state.isPaused ? Colors.white24 : AppColors.primaryGreen;
    String fontFamily = 'Cairo';

    if (activeTheme != null) {
      final counterConfig = activeTheme.themeMetadata['counter'] ?? {};
      final textColorStr = counterConfig['text_color'] ?? '#ffffff';
      textColor = state.isPaused
          ? Colors.white24
          : Color(int.parse(textColorStr.replaceAll('#', '0xFF')));

      final typoConfig = activeTheme.themeMetadata['typography'] ?? {};
      final font = typoConfig['font_family'] ?? 'cairo';
      fontFamily = font == 'cairo' ? 'Cairo' : 'Courier';
    }

    final double fontScale = themeState.activePreferences.customFontScale;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTapDown: _onTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (activeTheme != null)
                _buildThemeBackground(context, activeTheme, isDark),
              // Large Screen Wide Tap Area
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stay-Awake Visual Indicator / Hint
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_red_eye_rounded, color: Colors.green, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          locale == 'ku' ? 'مۆدی سەرنج (ڕووناک دەمێنێتەوە)' : (locale == 'ar' ? 'وضع التركيز (الشاشة نشطة)' : 'Focus Mode (Screen Awake)'),
                          style: const TextStyle(fontFamily: 'Cairo', color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Dhikr Name
                  Text(
                    dhikrName,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 24 * fontScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Huge Screen-Centered Counter
                  Text(
                    '${state.currentCount}',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 100 * fontScale,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      height: 1.0,
                    ),
                  ).animate(key: ValueKey('focus-cnt-${state.currentCount}')).scale(
                        begin: const Offset(1.15, 1.15),
                        end: const Offset(1.0, 1.0),
                        duration: 120.ms,
                      ),
                  const SizedBox(height: 16),
                  // Current Live Stats
                  Text(
                    '${_formatDuration(state.activeDurationSeconds)}  •  ${currentRate.toStringAsFixed(0)} / min',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Colors.white38,
                    ),
                  ),
                ],
              ),

              // Ripple touch effect
              if (_rippleVisible && _ripplePos != null)
                Positioned(
                  left: _ripplePos!.dx - 40,
                  top: _ripplePos!.dy - 40,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                    ),
                  )
                      .animate()
                      .scale(begin: const Offset(0.3, 0.3), end: const Offset(1.8, 1.8), duration: 300.ms, curve: Curves.easeOut)
                      .fadeOut(duration: 300.ms),
                ),

              // Bottom Control Buttons overlay
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back to Normal Mode
                    IconButton(
                      icon: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white70, size: 28),
                      tooltip: locale == 'ku' ? 'دەرچوون لە مۆدی سەرنج' : (locale == 'ar' ? 'خروج من وضع التركيز' : 'Exit Focus Mode'),
                      onPressed: () {
                        ref.read(tasbihSessionProvider.notifier).setMode('normal');
                      },
                    ),

                    // Pause/Resume
                    IconButton(
                      icon: Icon(
                        state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        color: Colors.white70,
                        size: 28,
                      ),
                      onPressed: () {
                        if (state.isPaused) {
                          ref.read(tasbihSessionProvider.notifier).resume();
                        } else {
                          ref.read(tasbihSessionProvider.notifier).pause();
                        }
                      },
                    ),

                    // End Session
                    IconButton(
                      icon: const Icon(Icons.stop_rounded, color: Colors.redAccent, size: 28),
                      tooltip: locale == 'ku' ? 'کۆتایی خول' : (locale == 'ar' ? 'إنهاء الجلسة' : 'End Session'),
                      onPressed: _handleEndSession,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Floating Draggable Overlay Pill ──────────────────────────────────────────
class TasbihSessionOverlay {
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (context) {
        return const _FloatingPillWidget();
      },
    );
    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _FloatingPillWidget extends ConsumerStatefulWidget {
  const _FloatingPillWidget();

  @override
  ConsumerState<_FloatingPillWidget> createState() => _FloatingPillWidgetState();
}

class _FloatingPillWidgetState extends ConsumerState<_FloatingPillWidget> {
  double _x = 20.0;
  double _y = 100.0;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(tasbihSessionProvider);
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sessionState.activeSession == null) {
      // Auto-dismiss overlay if session ends from elsewhere
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TasbihSessionOverlay.hide();
      });
      return const SizedBox.shrink();
    }

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _x += details.delta.dx;
            _y += details.delta.dy;
          });
        },
        onTap: () {
          final now = DateTime.now();
          if (now.difference(_lastTap).inMilliseconds < 50) return;
          _lastTap = now;
          
          if (!sessionState.isPaused) {
            ref.read(tasbihSessionProvider.notifier).increment();
            HapticFeedback.lightImpact();
          }
        },
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F1F18) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: cs.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expand Icon
                GestureDetector(
                  onTap: () {
                    // Hide overlay
                    TasbihSessionOverlay.hide();
                    // Set mode to normal
                    ref.read(tasbihSessionProvider.notifier).setMode('normal');
                    // Push active page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ActiveSessionPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary.withValues(alpha: 0.1),
                    ),
                    child: Icon(Icons.launch_rounded, color: cs.primary, size: 14),
                  ),
                ),
                const SizedBox(width: 8),
                // Counter Display
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sessionState.currentCount}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      sessionState.isPaused ? 'Paused' : 'Dhikr',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 8,
                        color: cs.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                // Compact increment button
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary,
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ).animate().scale(duration: 200.ms, curve: Curves.easeOut),
      ),
    );
  }
}

// ── Ring Painter ─────────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final Color color;
  final double width;
  final bool glow;
  final String animationType;

  const _RingPainter({
    required this.progress,
    required this.isDark,
    required this.color,
    required this.width,
    required this.glow,
    required this.animationType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Faint outer tracker
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withOpacity(isDark ? 0.08 : 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Inner glow ring
    if (glow) {
      canvas.drawCircle(
        center,
        radius - 20,
        Paint()
          ..color = color.withOpacity(isDark ? 0.05 : 0.07)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Rotating or pulsing arc
    final double sweepAngle = animationType == 'pulse' 
        ? (3.14 * 1.5 + (0.5 * 3.14 * (1.0 + (progress > 0 ? (progress * 2 - 1.0).abs() : 0.0))))
        : 3.14 * 1.5;

    // Dynamic Sweeping Arc
    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.7),
        ],
        startAngle: 0,
        endAngle: 3.14 * 2,
        transform: GradientRotation(progress * 3.14 * 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      progress * 3.14 * 2,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.isDark != isDark ||
      old.color != color ||
      old.width != width ||
      old.glow != glow ||
      old.animationType != animationType;
}
