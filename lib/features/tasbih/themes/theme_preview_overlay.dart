import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/tasbih_theme_model.dart';
import '../../../core/providers/tasbih_theme_provider.dart';

class ThemePreviewOverlay extends ConsumerStatefulWidget {
  final TasbihThemeModel theme;

  const ThemePreviewOverlay({super.key, required this.theme});

  @override
  ConsumerState<ThemePreviewOverlay> createState() => _ThemePreviewOverlayState();
}

class _ThemePreviewOverlayState extends ConsumerState<ThemePreviewOverlay>
    with SingleTickerProviderStateMixin {
  int _tapCount = 0;
  late AnimationController _pulseController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _tapCount++;
    });

    _pulseController.forward(from: 0.0);

    // Play click sound if configured
    _playThemeSound();

    // Trigger haptic feedback
    _triggerHaptics();
  }

  void _playThemeSound() {
    final sound = widget.theme.themeMetadata['sound'];
    if (sound != null && sound['type'] != 'silent') {
      // Typically we load the asset path, for preview we trigger system click if asset isn't resolved
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _triggerHaptics() {
    final haptic = widget.theme.themeMetadata['haptic'];
    if (haptic != null) {
      final profile = haptic['profile'] ?? 'medium';
      switch (profile) {
        case 'soft':
          HapticFeedback.lightImpact();
          break;
        case 'medium':
          HapticFeedback.mediumImpact();
          break;
        case 'strong':
          HapticFeedback.vibrate();
          break;
        case 'disabled':
        default:
          break;
      }
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.theme.themeMetadata;
    final bgConfig = metadata['background'] ?? {};
    final ringConfig = metadata['ring'] ?? {};
    final counterConfig = metadata['counter'] ?? {};
    final typeConfig = metadata['typography'] ?? {};

    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: Stack(
          children: [
            // Dynamic Background
            _buildBackground(bgConfig),

            // Main simulator body
            SafeArea(
              child: Column(
                children: [
                  // Top navigation / close header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Theme Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Mock active interactive counter
                  GestureDetector(
                    onTap: _handleTap,
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
                          CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Progress Ring
                            _buildProgressRing(ringConfig),

                            // Counter Value
                            _buildCounterDisplay(counterConfig, typeConfig),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'TAP INSIDE THE RING TO TEST EFFECTS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12.0,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  // Bottom Action Drawer (Apply / Cancel)
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: const BoxDecoration(
                      color: Color(0xDD1E1E1E),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.theme.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.theme.description,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white24),
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final success = await ref
                                      .read(tasbihThemeProvider.notifier)
                                      .applyTheme(widget.theme);
                                  if (success && mounted) {
                                    Navigator.of(context).pop(); // pop preview
                                    Navigator.of(context).pop(); // pop selector
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFffd700),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                child: const Text(
                                  'Apply Theme',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildBackground(Map<String, dynamic> config) {
    final type = config['type'] ?? 'gradient';
    final value = config['value'] ?? '';

    if (type == 'image') {
      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1c1c1e),
        ),
        child: Opacity(
          opacity: 0.25,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
        ),
      );
    }

    // Default gradient parsing
    Color startColor = const Color(0xFF121212);
    Color endColor = const Color(0xFF000000);

    if (value.toString().contains('#')) {
      // extract HEX colors if any
      final hexes = RegExp(r'#[0-9a-fA-F]{6}').allMatches(value.toString());
      if (hexes.length >= 2) {
        startColor = Color(int.parse(hexes.elementAt(0).group(0)!.replaceAll('#', '0xFF')));
        endColor = Color(int.parse(hexes.elementAt(1).group(0)!.replaceAll('#', '0xFF')));
      } else if (hexes.length == 1) {
        startColor = Color(int.parse(hexes.elementAt(0).group(0)!.replaceAll('#', '0xFF')));
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [startColor, endColor],
        ),
      ),
    );
  }

  Widget _buildProgressRing(Map<String, dynamic> config) {
    final colorStr = config['color'] ?? '#ffd700';
    final width = (config['width'] as num?)?.toDouble() ?? 8.0;
    final ringColor = Color(int.parse(colorStr.replaceAll('#', '0xFF')));

    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ringColor.withOpacity(0.15),
          width: width,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 240 - width,
          height: 240 - width,
          child: CircularProgressIndicator(
            value: (_tapCount % 33) / 33.0,
            strokeWidth: width,
            valueColor: AlwaysStoppedAnimation<Color>(ringColor),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterDisplay(Map<String, dynamic> counter, Map<String, dynamic> typography) {
    final design = counter['design'] ?? 'circular';
    final textColorStr = counter['text_color'] ?? '#ffffff';
    final textColor = Color(int.parse(textColorStr.replaceAll('#', '0xFF')));
    final font = typography['font_family'] ?? 'cairo';

    Widget child = Text(
      '$_tapCount',
      style: TextStyle(
        color: textColor,
        fontSize: 48,
        fontWeight: FontWeight.bold,
        fontFamily: font == 'cairo' ? 'Patua One' : 'Courier',
      ),
    );

    if (design == 'card') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      );
    }

    if (design == 'glassmorphism') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24, width: 1.0),
        ),
        child: child,
      );
    }

    return child;
  }
}
