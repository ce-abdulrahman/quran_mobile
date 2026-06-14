import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/providers/fingerprint_provider.dart';
import 'fingerprint_settings_dialog.dart';
import '../../../core/models/tasbih_model.dart';


class FingerprintCounterPage extends ConsumerStatefulWidget {
  final TasbihModel? selectedDhikr;
  const FingerprintCounterPage({super.key, this.selectedDhikr});

  @override
  ConsumerState<FingerprintCounterPage> createState() => _FingerprintCounterPageState();
}

class _FingerprintCounterPageState extends ConsumerState<FingerprintCounterPage>
    with TickerProviderStateMixin {
  int _sessionCount = 0;
  late DateTime _startTime;
  bool _isPressed = false;
  Timer? _countTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _particlesController;
  
  // Custom painter telemetry
  final List<_RippleEffect> _ripples = [];
  final List<_Particle> _particles = [];
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(() {
        _updateParticles();
      });

    // Warm up the audio player
    _audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    _particlesController.dispose();
    _countTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updateParticles() {
    if (!mounted) return;
    setState(() {
      _particles.removeWhere((p) => p.isDead);
      for (final p in _particles) {
        p.update();
      }
    });
  }

  void _triggerFeedback() {
    final settings = ref.read(fingerprintProvider).settings;

    // Haptics
    switch (settings.hapticProfile) {
      case 'light':
        HapticFeedback.lightImpact();
        break;
      case 'normal':
        HapticFeedback.mediumImpact();
        break;
      case 'strong':
        HapticFeedback.heavyImpact();
        break;
      case 'custom':
        if (settings.customHapticVibrationMs > 100) {
          HapticFeedback.vibrate();
        } else {
          HapticFeedback.selectionClick();
        }
        break;
      case 'disabled':
      default:
        break;
    }

    // Audio clicks
    if (settings.audioProfile != 'silent') {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _increment() {
    setState(() {
      _sessionCount++;
      _glowController.forward(from: 0.0);
      
      // Spawn particles
      final angleStep = (2 * pi) / 10;
      for (int i = 0; i < 10; i++) {
        final angle = angleStep * i + _random.nextDouble() * 0.2;
        _particles.add(
          _Particle(
            x: 0,
            y: 0,
            vx: cos(angle) * (2 + _random.nextDouble() * 3),
            vy: sin(angle) * (2 + _random.nextDouble() * 3),
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            size: 2 + _random.nextDouble() * 3,
            maxLife: 20 + _random.nextInt(20),
          ),
        );
      }
      if (!_particlesController.isAnimating) {
        _particlesController.repeat();
      }
    });

    _triggerFeedback();
  }

  void _startCounting(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });

    // Add ripple at touch position
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final center = Offset(renderBox.size.width / 2, renderBox.size.height / 2);
    final rippleOffset = localPosition - center;

    setState(() {
      _ripples.add(_RippleEffect(
        offset: rippleOffset,
        radius: 10.0,
        opacity: 0.8,
      ));
    });

    final settings = ref.read(fingerprintProvider).settings;

    if (settings.countMode == 'single_touch') {
      _increment();
    } else if (settings.countMode == 'hold_to_count') {
      _increment();
      _countTimer = Timer.periodic(
        Duration(seconds: settings.holdIntervalSeconds),
        (timer) => _increment(),
      );
    } else if (settings.countMode == 'continuous') {
      _increment();
      // Continuous counting tick every 150ms (rate-limited safety limits)
      _countTimer = Timer.periodic(
        const Duration(milliseconds: 150),
        (timer) => _increment(),
      );
    }
  }

  void _stopCounting() {
    setState(() {
      _isPressed = false;
    });
    _countTimer?.cancel();
  }

  Future<void> _endSessionAndSync() async {
    _stopCounting();
    final count = _sessionCount;
    if (count == 0) {
      Navigator.of(context).pop();
      return;
    }

    // Show loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final duration = DateTime.now().difference(_startTime).inSeconds;
    final settings = ref.read(fingerprintProvider).settings;

    // Sync to backend
    final newlyUnlocked = await ref.read(fingerprintProvider.notifier).saveSession(
      dhikrId: widget.selectedDhikr != null ? int.tryParse(widget.selectedDhikr!.id) : null,
      customDhikrName: widget.selectedDhikr == null ? 'Tasbih General' : null,
      startTime: _startTime,
      endTime: DateTime.now(),
      durationSeconds: duration,
      totalCount: count,
      isBlind: settings.blindMode,
      isFocus: settings.focusMode,
      countMode: settings.countMode,
    );

    // Close loading dialog
    if (mounted) {
      Navigator.of(context).pop(); // Close loader
      Navigator.of(context).pop(); // Close Fingerprint page
    }

    // Show completion summary & achievement unlock notifications if any
    if (mounted && count > 0) {
      _showSessionSummaryDialog(count, duration, newlyUnlocked);
    }
  }

  void _showSessionSummaryDialog(int count, int duration, List<dynamic> achievements) {
    showDialog(
      context: context,
      builder: (context) {
        final locale = Localizations.localeOf(context).languageCode;
        final primaryColor = Theme.of(context).primaryColor;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            locale == 'ku' ? 'تەواوبوونی سێشن' : (locale == 'ar' ? 'اكتملت الجلسة' : 'Session Completed'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$count',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 10),
              Text(
                locale == 'ku'
                    ? 'ماوە: ${duration} چرکە'
                    : (locale == 'ar' ? 'المدة: ${duration} ثانية' : 'Duration: ${duration}s'),
                style: const TextStyle(color: Colors.grey),
              ),
              if (achievements.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      locale == 'ku'
                          ? 'دەستکەوتی نوێ کرایەوە! 🏆'
                          : (locale == 'ar' ? 'تم فتح إنجاز جديد! 🏆' : 'New Achievement Unlocked! 🏆'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...achievements.map((a) {
                  final name = a['name'] ?? 'Achievement';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Chip(
                      avatar: Text(a['icon'] ?? '🏆'),
                      label: Text(name),
                      backgroundColor: Colors.amber.withOpacity(0.1),
                    ),
                  );
                }),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(fingerprintProvider).settings;
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final targetDhikrName = widget.selectedDhikr?.name ?? 
        (Localizations.localeOf(context).languageCode == 'ku' ? 'تەسبیحکار' : 'Tasbih');

    return Scaffold(
      backgroundColor: settings.focusMode 
          ? (isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF5F5FA))
          : null,
      appBar: settings.focusMode
          ? null
          : AppBar(
              title: Text(targetDhikrName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const FingerprintSettingsDialog(),
                    );
                  },
                ),
              ],
            ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background interactive particle painter
            Positioned.fill(
              child: GestureDetector(
                onTapDown: _startCounting,
                onTapUp: (_) => _stopCounting(),
                onTapCancel: _stopCounting,
                child: CustomPaint(
                  painter: _FingerprintEffectsPainter(
                    ripples: _ripples,
                    particles: _particles,
                    pulseValue: _pulseController.value,
                    glowValue: _glowController.value,
                    isPressed: _isPressed,
                    primaryColor: primaryColor,
                    isDark: isDark,
                  ),
                ),
              ),
            ),

            // Top Control buttons in Focus Mode
            if (settings.focusMode)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 28),
                      onPressed: _endSessionAndSync,
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_rounded, size: 28),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const FingerprintSettingsDialog(),
                        );
                      },
                    ),
                  ],
                ),
              ),

            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Immersive Blind Mode toggle indicator
                  if (!settings.blindMode) ...[
                    Text(
                      '$_sessionCount',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: isDark ? Colors.white : Colors.black87,
                        shadows: [
                          Shadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ku' ? 'لێدان' : 'Counts',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.visibility_off, color: Colors.grey, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ku'
                          ? 'مۆدی کوێر چالاکە'
                          : 'Blind Mode Active',
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],

                  const SizedBox(height: 80),

                  // Giant interactive fingerprint area
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular ring progress (Target counts 33 beads)
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: (_sessionCount % 33) / 33.0,
                          strokeWidth: 4,
                          backgroundColor: primaryColor.withOpacity(0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor.withOpacity(0.6)),
                        ),
                      ),
                      
                      // Fingerprint icon base
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isPressed 
                              ? primaryColor.withOpacity(0.15) 
                              : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02)),
                          boxShadow: _isPressed 
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.2),
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  )
                                ] 
                              : [],
                        ),
                        child: Icon(
                          Icons.fingerprint,
                          size: 72,
                          color: _isPressed 
                              ? primaryColor 
                              : primaryColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // End Session button at bottom (if not focus mode)
            if (!settings.focusMode)
              Positioned(
                bottom: 40,
                left: 40,
                right: 40,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(
                    Localizations.localeOf(context).languageCode == 'ku' ? 'تەواوکردنی سێشن' : 'Complete Session',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _endSessionAndSync,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Visual Scrubber details

class _RippleEffect {
  final Offset offset;
  double radius;
  double opacity;

  _RippleEffect({
    required this.offset,
    required this.radius,
    required this.opacity,
  });

  void update() {
    radius += 4.0;
    opacity -= 0.05;
  }

  bool get isDead => opacity <= 0.0;
}

class _Particle {
  double x;
  double y;
  final double vx;
  final double vy;
  final Color color;
  double size;
  int maxLife;
  int life = 0;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.maxLife,
  });

  void update() {
    x += vx;
    y += vy;
    life++;
  }

  bool get isDead => life >= maxLife;
}

class _FingerprintEffectsPainter extends CustomPainter {
  final List<_RippleEffect> ripples;
  final List<_Particle> particles;
  final double pulseValue;
  final double glowValue;
  final bool isPressed;
  final Color primaryColor;
  final bool isDark;

  _FingerprintEffectsPainter({
    required this.ripples,
    required this.particles,
    required this.pulseValue,
    required this.glowValue,
    required this.isPressed,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Draw pulse rings
    final pulsePaint = Paint()
      ..color = primaryColor.withOpacity(0.08 * (1.0 - pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawCircle(center, 90 + pulseValue * 40, pulsePaint);
    canvas.drawCircle(center, 90 + pulseValue * 70, pulsePaint);

    // 2. Draw active ripples
    for (final ripple in ripples) {
      ripple.update();
      final ripplePaint = Paint()
        ..color = primaryColor.withOpacity(ripple.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(center + ripple.offset, ripple.radius, ripplePaint);
    }
    ripples.removeWhere((r) => r.isDead);

    // 3. Draw particles
    for (final particle in particles) {
      final lifePct = 1.0 - (particle.life / particle.maxLife);
      final pPaint = Paint()
        ..color = particle.color.withOpacity(lifePct)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center + Offset(particle.x, particle.y), particle.size * lifePct, pPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
