import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/providers/dhikr_time.dart';

class AdhkarSessionPage extends ConsumerStatefulWidget {
  final String categoryKey;
  final String title;
  final List<AdhkarItem> items;

  const AdhkarSessionPage({
    super.key,
    required this.categoryKey,
    required this.title,
    required this.items,
  });

  @override
  ConsumerState<AdhkarSessionPage> createState() => _AdhkarSessionPageState();
}

class _AdhkarSessionPageState extends ConsumerState<AdhkarSessionPage>
    with SingleTickerProviderStateMixin {
  int _activeIndex = 0;
  int _count = 0;
  DateTime? _lastTap;

  // Ring animation
  late final AnimationController _ringCtrl;
  late final Animation<double> _ringAnim;

  // Ripple position
  Offset? _ripplePos;
  bool _rippleVisible = false;
  Timer? _rippleTimer;

  @override
  void initState() {
    super.initState();
    _restoreProgress();
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
    super.dispose();
  }

  void _onTap(TapDownDetails details, AdhkarItem activeItem) {
    if (_count >= activeItem.targetCount) return;

    final now = DateTime.now();
    if (_lastTap != null && now.difference(_lastTap!) < dhikrTapCooldown) {
      return;
    }
    _lastTap = now;

    setState(() {
      _count++;
      _ripplePos = details.localPosition;
      _rippleVisible = true;
    });
    _saveProgress();

    HapticFeedback.lightImpact();

    // Trigger ripple dismiss timer
    _rippleTimer?.cancel();
    _rippleTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _rippleVisible = false);
    });

    // Check if target reached
    if (_count == activeItem.targetCount) {
      // Completed double vibration
      Future.delayed(const Duration(milliseconds: 100), () {
        HapticFeedback.mediumImpact();
      });
    }
  }

  void _next(AppColorScheme cs) {
    if (_activeIndex < widget.items.length - 1) {
      setState(() {
        _activeIndex++;
        _count = 0;
        _rippleVisible = false;
      });
      _saveProgress();
    } else {
      // Completed the whole session!
      ref.read(adhkarProvider.notifier).completeCategory(widget.categoryKey);
      _showCompletionDialog(cs);
    }
  }

  void _prev() {
    if (_activeIndex > 0) {
      setState(() {
        _activeIndex--;
        _count = 0;
        _rippleVisible = false;
      });
      _saveProgress();
    }
  }

  /// Picks up where the user left off, as long as it was today. Guards the
  /// index against a shorter list: the bundled adhkar can change between app
  /// versions, and a stale index would otherwise throw on the first build.
  void _restoreProgress() {
    final saved =
        ref.read(adhkarProvider.notifier).progressFor(widget.categoryKey);
    if (saved.isEmpty) return;

    final index = saved.itemIndex.clamp(0, widget.items.length - 1);
    final target = widget.items[index].targetCount;

    _activeIndex = index;
    _count = saved.count.clamp(0, target);
  }

  void _saveProgress() {
    ref.read(adhkarProvider.notifier).saveProgress(
          widget.categoryKey,
          itemIndex: _activeIndex,
          count: _count,
        );
  }

  void _showCompletionDialog(AppColorScheme cs) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'قبوڵ بێت إن شاء الله',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF0F8F4C).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF0F8F4C),
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'تەواوی زیکرەکانی ${widget.title} بە سەرکەوتوویی تەواو بوون.',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: cs.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to category page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'باشە',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeItem = widget.items[_activeIndex];
    final isCompleted = _count >= activeItem.targetCount;
    final progress = (_activeIndex + 1) / widget.items.length;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Linear Progress Bar at top
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: cs.divider,
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'زیکری ${_activeIndex + 1} لە ${widget.items.length}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: cs.textSecondary,
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F8F4C).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'تەواو بوو ✓',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F8F4C),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Central Supplication Card
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      activeItem.text,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 18,
                        height: 1.8,
                        color: cs.textPrimary,
                      ),
                    ).animate(key: ValueKey('text-$_activeIndex')).fadeIn(duration: 400.ms),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Text(
                      activeItem.getTranslation(Localizations.localeOf(context).languageCode),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: cs.textSecondary,
                        height: 1.5,
                      ),
                    ).animate(key: ValueKey('trans-$_activeIndex')).fadeIn(duration: 400.ms),
                  ],
                ),
              ),
            ),
          ),

          // Immersive counting area
          Container(
            height: 220,
            color: cs.card,
            padding: const EdgeInsets.only(bottom: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Tap detector Area
                GestureDetector(
                  onTapDown: (details) => _onTap(details, activeItem),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated Rotating Arc Ring
                      AnimatedBuilder(
                        animation: _ringAnim,
                        builder: (_, __) {
                          return CustomPaint(
                            size: const Size(180, 180),
                            painter: _RingPainter(
                              progress: _ringAnim.value,
                              isDark: isDark,
                              color: cs.primary,
                            ),
                          );
                        },
                      ),

                      // Center count display
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_count',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: cs.primary,
                              height: 1.0,
                            ),
                          ).animate(key: ValueKey('cnt-$_count')).scale(
                                begin: const Offset(1.15, 1.15),
                                end: const Offset(1.0, 1.0),
                                duration: 150.ms,
                              ),
                          Text(
                            '/ ${activeItem.targetCount}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      // Touch ripple
                      if (_rippleVisible && _ripplePos != null)
                        Positioned(
                          left: _ripplePos!.dx - 30,
                          top: _ripplePos!.dy - 30,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.primary.withValues(alpha: 0.15),
                            ),
                          )
                              .animate()
                              .scale(
                                begin: const Offset(0.3, 0.3),
                                end: const Offset(1.5, 1.5),
                                duration: 400.ms,
                                curve: Curves.easeOut,
                              )
                              .fadeOut(duration: 400.ms),
                        ),
                    ],
                  ),
                ),

                // Controls row
                Positioned(
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Prev Button
                      IconButton(
                        onPressed: _activeIndex > 0 ? _prev : null,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: _activeIndex > 0 ? cs.textPrimary : cs.textSecondary.withValues(alpha: 0.3),
                          size: 22,
                        ),
                        tooltip: 'پێشوو',
                      ),

                      const SizedBox(width: 140), // Spacer for center circle

                      // Next / Complete Button
                      isCompleted
                          ? Container(
                              decoration: BoxDecoration(
                                color: cs.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () => _next(cs),
                                icon: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                tooltip: 'دواتر',
                              ),
                            ).animate().scale(duration: 200.ms, curve: Curves.easeOut)
                          : IconButton(
                              onPressed: _activeIndex < widget.items.length - 1 ? () => _next(cs) : null,
                              icon: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: _activeIndex < widget.items.length - 1 ? cs.textPrimary : cs.textSecondary.withValues(alpha: 0.3),
                                size: 22,
                              ),
                              tooltip: 'دواتر',
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final Color color;

  const _RingPainter({required this.progress, required this.isDark, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Outer faint circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: isDark ? 0.08 : 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Inner glow ring
    canvas.drawCircle(
      center,
      radius - 15,
      Paint()
        ..color = color.withValues(alpha: isDark ? 0.04 : 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Rotating arc
    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.6),
        ],
        startAngle: 0,
        endAngle: 3.14 * 2,
        transform: GradientRotation(progress * 3.14 * 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      progress * 3.14 * 2,
      3.14 * 1.5,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.isDark != isDark;
}
