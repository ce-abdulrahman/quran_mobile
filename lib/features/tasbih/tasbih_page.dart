import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/models/tasbih_model.dart';
import '../../core/providers/tasbih_session_provider.dart';
import 'active_session_page.dart';
import '../../core/providers/tasbih_theme_provider.dart';
import '../../core/models/tasbih_theme_model.dart';
import '../../core/models/user_theme_preference_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'feature_menu_registry.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tasbih Page
// ─────────────────────────────────────────────────────────────────────────────

class TasbihPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const TasbihPage({super.key, this.showBackButton = false});

  @override
  ConsumerState<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends ConsumerState<TasbihPage>
    with TickerProviderStateMixin {
  int _selectedDhikrIndex = 0;
  List<Map<String, dynamic>> _history = [];
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

  DateTime? _lastTap;
  static const _cooldownMs = 300;

  bool _showCelebration = false;
  int _celebratedStreak = 0;

  void _triggerStreakCelebration() {
    final streakState = ref.read(tasbihProvider);
    setState(() {
      _showCelebration = true;
      _celebratedStreak = streakState.currentStreak;
    });
    
    HapticFeedback.heavyImpact();

    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _showCelebration = false;
        });
      }
    });
  }

  bool _showGoalCelebration = false;

  void _triggerGoalCelebration() {
    setState(() {
      _showGoalCelebration = true;
    });

    HapticFeedback.heavyImpact().then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        HapticFeedback.vibrate();
      });
    });

    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          _showGoalCelebration = false;
        });
      }
    });
  }

  // Ripple position
  Offset? _ripplePos;
  bool _rippleVisible = false;
  Timer? _rippleTimer;

  // Ring animation
  late final AnimationController _ringCtrl;
  late final Animation<double> _ringAnim;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.linear);

    _loadHistory();
    _checkFirstLaunchHint();
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _rippleTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    List<Map<String, dynamic>> loadedHistory = [];
    final historyJson = prefs.getString('tasbih_history');
    if (historyJson != null) {
      try {
        final decoded = jsonDecode(historyJson);
        if (decoded is List) {
          loadedHistory = decoded.map((e) {
            final entry = Map<String, dynamic>.from(e as Map);
            // Migrate legacy dhikrIndex to dhikrId & name
            if (entry.containsKey('dhikrIndex') && !entry.containsKey('dhikrId')) {
              final idx = ((entry['dhikrIndex'] as num?)?.toInt() ?? 0);
              entry['dhikrId'] = (idx + 1).toString(); // "1", "2", "3"
              if (idx == 0) entry['name'] = 'سُبْحَانَ اللهِ';
              if (idx == 1) entry['name'] = 'الْحَمْدُ للهِ';
              if (idx == 2) entry['name'] = 'اللهُ أَكْبَرُ';
            }
            return entry;
          }).toList();
        }
      } catch (e) {
        debugPrint('Error decoding tasbih history: $e');
      }
    }

    setState(() {
      _history = loadedHistory;
    });
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasbih_history', jsonEncode(_history));
  }

  void _onTap(TapDownDetails details, TasbihModel activeDhikr) {
    final now = DateTime.now();
    if (_lastTap != null &&
        now.difference(_lastTap!).inMilliseconds < _cooldownMs) {
      return; // anti-abuse cooldown
    }
    _lastTap = now;

    final themeState = ref.read(tasbihThemeProvider);
    _playThemeSound(themeState.activeTheme, themeState.activePreferences);
    _triggerThemeHaptics(themeState.activeTheme, themeState.activePreferences);

    final tasbihStateBefore = ref.read(tasbihProvider);
    final oldCompleted = tasbihStateBefore.dailyGoalCompleted;
    final goalValue = tasbihStateBefore.dailyGoalValue;

    ref.read(tasbihProvider.notifier).incrementCount(activeDhikr.id).then((streakIncreased) {
      if (!mounted) return;
      if (streakIncreased) {
        _triggerStreakCelebration();
      }

      final tasbihStateAfter = ref.read(tasbihProvider);
      final newProgress = tasbihStateAfter.dailyGoalProgress;
      final newCompleted = tasbihStateAfter.dailyGoalCompleted;

      final milestone25 = (goalValue * 0.25).round();
      final milestone50 = (goalValue * 0.50).round();

      if (themeState.activePreferences.hapticEnabled) {
        if (newCompleted && !oldCompleted) {
          _triggerGoalCelebration();
        } else if (newProgress == milestone50) {
          HapticFeedback.mediumImpact();
        } else if (newProgress == milestone25) {
          HapticFeedback.lightImpact();
        }
      }
    });

    final currentCount = (tasbihStateBefore.counts[activeDhikr.id] ?? 0) + 1;

    setState(() {
      _ripplePos = details.localPosition;
      _rippleVisible = true;

      // Update history
      _updateHistoryEntry(now, activeDhikr.id, activeDhikr.name, currentCount);
    });

    _saveHistory();

    _rippleTimer?.cancel();
    _rippleTimer = Timer(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _rippleVisible = false);
    });
  }

  void _updateHistoryEntry(DateTime dateTime, String dhikrId, String name, int currentCount) {
    final dateStr = dateTime.toIso8601String().substring(0, 10);
    final index = _history.indexWhere(
      (entry) => entry['date'] == dateStr && entry['dhikrId'] == dhikrId,
    );
    if (index != -1) {
      _history[index]['count'] = currentCount;
    } else {
      _history.add({
        'date': dateStr,
        'dhikrId': dhikrId,
        'name': name,
        'count': currentCount,
      });
    }
  }

  void _reset(TasbihModel activeDhikr) async {
    final l = context.l10n;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l.tasbihResetConfirm,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.tasbihResetNo,
                style: const TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.tasbihResetYes,
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColorScheme.of(context).primary)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      ref.read(tasbihProvider.notifier).resetCount(activeDhikr.id);
      setState(() {
        _updateHistoryEntry(DateTime.now(), activeDhikr.id, activeDhikr.name, 0);
      });
      _saveHistory();
    }
  }

  void _showAddDhikrDialog() {
    final l = context.l10n;
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '33');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        final cs = AppColorScheme.of(context);
        final maxHeight = MediaQuery.of(context).size.height * 0.7;
        return Dialog(
          backgroundColor: cs.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l.tasbihAddNewDhikr,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameCtrl,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: l.tasbihDhikrName,
                        alignLabelWithHint: true,
                        hintText: l.tasbihSubhanAllah,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return l.tasbihEnterDhikrName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: targetCtrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        labelText: l.tasbihGoalLabel,
                        alignLabelWithHint: true,
                        hintText: '33',
                      ),
                      validator: (val) {
                        if (val == null || int.tryParse(val) == null || int.parse(val) <= 0) {
                          return l.tasbihEnterValidGoal;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(l.homeCancel, style: const TextStyle(fontFamily: 'Cairo')),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                final name = nameCtrl.text.trim();
                                final target = int.parse(targetCtrl.text.trim());
                                ref.read(tasbihProvider.notifier).addCustomDhikr(name, target);
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l.tasbihDhikrAdded(name),
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(fontFamily: 'Cairo'),
                                    ),
                                    backgroundColor: const Color(0xFF0F8F4C),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(l.tasbihAddButton, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        );
      },
    );
  }

  void _onDeleteDhikr(String dhikrId, String name) async {
    final l = context.l10n;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l.tasbihDeleteDhikr,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: Text(
          l.tasbihDeleteConfirm(name),
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.homeCancel, style: const TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.tasbihDeleteYes, style: const TextStyle(fontFamily: 'Cairo', color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      ref.read(tasbihProvider.notifier).deleteCustomDhikr(dhikrId);
      setState(() {
        if (_selectedDhikrIndex > 0) {
          _selectedDhikrIndex--;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.tasbihDhikrDeleted(name),
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showChangeGoalDialog() {
    final tasbihState = ref.read(tasbihProvider);
    final customCtrl = TextEditingController();
    int? selectedPredefined = [100, 500, 1000].contains(tasbihState.dailyGoalValue)
        ? tasbihState.dailyGoalValue
        : null;

    if (selectedPredefined == null) {
      customCtrl.text = tasbihState.dailyGoalValue.toString();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        final cs = AppColorScheme.of(context);
        final l = context.l10n;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: cs.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                l.tasbihGoalSelect,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l.tasbihPredefinedGoals,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [100, 500, 1000].map((val) {
                      final isSel = selectedPredefined == val;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedPredefined = val;
                              customCtrl.clear();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSel ? cs.primary : cs.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSel ? cs.primary : cs.cardBorder,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$val',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSel ? Colors.white : cs.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.tasbihCustomGoal,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: customCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: l.tasbihExampleGoal,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: cs.primary),
                      ),
                    ),
                    onChanged: (val) {
                      if (val.trim().isNotEmpty) {
                        setDialogState(() {
                          selectedPredefined = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l.homeCancel, style: const TextStyle(fontFamily: 'Cairo')),
                ),
                ElevatedButton(
                  onPressed: () {
                    int? finalVal;
                    if (selectedPredefined != null) {
                      finalVal = selectedPredefined;
                    } else {
                      final valInt = int.tryParse(customCtrl.text.trim());
                      if (valInt != null && valInt >= 1) {
                        finalVal = valInt;
                      }
                    }

                    if (finalVal != null) {
                      ref.read(tasbihProvider.notifier).setDailyGoal(finalVal);
                      Navigator.pop(ctx);
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l.homeDailyGoalChanged(finalVal.toString()),
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: const Color(0xFF0F8F4C),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l.tasbihGoalMinError,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(l.homeApply, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ── Counter UI & Dialogs ──────────────────────────────────────────────

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
        startColor = Color(int.parse(hexes.elementAt(0).group(0)!.replaceAll('#', '0xFF'))).withValues(alpha: isDark ? 0.1 : 0.2);
        endColor = Color(int.parse(hexes.elementAt(1).group(0)!.replaceAll('#', '0xFF'))).withValues(alpha: isDark ? 0.15 : 0.3);
      } else if (hexes.length == 1) {
        startColor = Color(int.parse(hexes.elementAt(0).group(0)!.replaceAll('#', '0xFF'))).withValues(alpha: isDark ? 0.1 : 0.2);
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

  bool _hintShown = true;

  void _checkFirstLaunchHint() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('tasbih_first_launch_hint_shown') ?? false;
    setState(() {
      _hintShown = shown;
    });
  }

  void _dismissHint() async {
    if (!_hintShown) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tasbih_first_launch_hint_shown', true);
      setState(() {
        _hintShown = true;
      });
    }
  }

  Widget _buildFloatingHintOverlay(AppColorScheme cs, AppLocalizations l) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cs.primary.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.firstTimeHintTap,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.firstTimeHintSettings,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.5,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
              onPressed: _dismissHint,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0.0),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    _dismissHint();
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final activeDhikr = ref.read(tasbihProvider).dhikrs.isNotEmpty && _selectedDhikrIndex < ref.read(tasbihProvider).dhikrs.length
        ? ref.read(tasbihProvider).dhikrs[_selectedDhikrIndex]
        : null;

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (consumerContext, ref, _) {
            final categorized = FeatureMenuRegistry.getCategorizedItems(
              context,
              ref,
              onDailyGoalsTap: () {
                _showChangeGoalDialog();
              },
              onSessionsTap: () {
                final tasbihState = ref.read(tasbihProvider);
                _showStartSessionDialog(context, cs, tasbihState);
              },
              onCounterSettingsTap: () {
                _showCounterSettingsDialog();
              },
              activeDhikr: activeDhikr,
            );

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: cs.divider,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: FeatureMenuGroup.values.map((group) {
                            final items = categorized[group] ?? [];
                            if (items.isEmpty) return const SizedBox.shrink();

                            String groupTitle = '';
                            switch (group) {
                              case FeatureMenuGroup.personalization:
                                groupTitle = l.personalizationGroup;
                                break;
                              case FeatureMenuGroup.progress:
                                groupTitle = l.progressGroup;
                                break;
                              case FeatureMenuGroup.productivity:
                                groupTitle = l.productivityGroup;
                                break;
                              case FeatureMenuGroup.data:
                                groupTitle = l.dataGroup;
                                break;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  child: Text(
                                    groupTitle,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: cs.primary,
                                    ),
                                  ),
                                ),
                                ...items.where((i) => i.isVisible(ref)).map((item) {
                                  return ListTile(
                                    leading: Icon(item.icon, color: cs.textPrimary),
                                    title: Text(
                                      item.title(l),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: cs.textPrimary,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(ctx);
                                      item.onTap(context, ref);
                                    },
                                  );
                                }),
                                const Divider(height: 16),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCounterSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final cs = AppColorScheme.of(context);
        return Consumer(
          builder: (context, ref, _) {
            final themeState = ref.watch(tasbihThemeProvider);
            final prefs = themeState.activePreferences;

            return AlertDialog(
              backgroundColor: cs.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                context.l10n.tasbihSettingsTitle,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text(
                      context.l10n.tasbihSound,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      context.l10n.tasbihSoundDesc,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
                    ),
                    value: prefs.soundEnabled,
                    activeThumbColor: cs.primary,
                    onChanged: (val) {
                      ref.read(tasbihThemeProvider.notifier).savePreferences(
                        prefs.copyWith(soundEnabled: val),
                      );
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: Text(
                      context.l10n.tasbihHaptics,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      context.l10n.tasbihHapticsDesc,
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
                    ),
                    value: prefs.hapticEnabled,
                    activeThumbColor: cs.primary,
                    onChanged: (val) {
                      ref.read(tasbihThemeProvider.notifier).savePreferences(
                        prefs.copyWith(hapticEnabled: val),
                      );
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.l10n.settingsFontSize,
                              style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${(prefs.customFontScale * 100).toStringAsFixed(0)}%',
                              style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold, color: cs.primary),
                            ),
                          ],
                        ),
                        Slider(
                          min: 0.8,
                          max: 1.5,
                          divisions: 7,
                          value: prefs.customFontScale,
                          activeColor: cs.primary,
                          inactiveColor: cs.divider,
                          onChanged: (val) {
                            ref.read(tasbihThemeProvider.notifier).savePreferences(
                              prefs.copyWith(customFontScale: val),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(context.l10n.tasbihClose, style: const TextStyle(fontFamily: 'Cairo')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tasbihState = ref.watch(tasbihProvider);

    if (tasbihState.isLoading) {
      return Scaffold(
        backgroundColor: cs.bg,
        appBar: AppBar(
          backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
          elevation: 0,
          title: Text(l.tasbihTitle, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (tasbihState.dhikrs.isEmpty) {
      return Scaffold(
        backgroundColor: cs.bg,
        appBar: AppBar(
          backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
          elevation: 0,
          title: Text(l.tasbihTitle, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l.tasbihNoDhikrAvailable,
                style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _showAddDhikrDialog,
                style: ElevatedButton.styleFrom(backgroundColor: cs.primary),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(l.tasbihAddDhikrButton, style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (_selectedDhikrIndex >= tasbihState.dhikrs.length) {
      _selectedDhikrIndex = 0;
    }

    final activeDhikr = tasbihState.dhikrs[_selectedDhikrIndex];
    final count = tasbihState.counts[activeDhikr.id] ?? 0;

    final themeState = ref.watch(tasbihThemeProvider);
    final activeTheme = themeState.activeTheme;
    final activePreferences = themeState.activePreferences;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          l.tasbihTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            tooltip: l.tasbihSettingsTooltip,
            onPressed: () => _showSettingsBottomSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          if (activeTheme != null)
            _buildThemeBackground(context, activeTheme, isDark),
          GestureDetector(
            onTapDown: (details) => _onTap(details, activeDhikr),
            behavior: HitTestBehavior.opaque,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // 1. Current Dhikr Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: Text(
                        activeDhikr.name,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: cs.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 2 & 3. Counter Number (largest) & Progress Indicator
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _AnimatedRing(
                          animation: _ringAnim,
                          isDark: isDark,
                          color: cs.primary,
                          theme: activeTheme,
                          preferences: activePreferences,
                        ),
                        _CounterDisplay(
                          count: count,
                          cs: cs,
                          target: activeDhikr.target,
                          theme: activeTheme,
                          preferences: activePreferences,
                        ).animate(key: ValueKey('count-${activeDhikr.id}-$count'))
                         .scale(
                           begin: const Offset(1.1, 1.1),
                           end: const Offset(1.0, 1.0),
                           duration: 200.ms,
                           curve: Curves.easeOut,
                         ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // 5. Dhikr Selector Chips (positioned at the bottom)
                  _DhikrChips(
                    cs: cs,
                    dhikrs: tasbihState.dhikrs,
                    selectedIndex: _selectedDhikrIndex,
                    onSelected: (i) {
                      setState(() {
                        _selectedDhikrIndex = i;
                      });
                    },
                    onAddPressed: _showAddDhikrDialog,
                    onDeletePressed: (id) {
                      final name = tasbihState.dhikrs.firstWhere((d) => d.id == id).name;
                      _onDeleteDhikr(id, name);
                    },
                  ),
                  const SizedBox(height: 16),
                  // 6. Reset Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
                    child: _ResetButton(onReset: () => _reset(activeDhikr), l: l),
                  ),
                ],
              ),
            ),
          ),
          if (!_hintShown)
            _buildFloatingHintOverlay(cs, l),
          if (_rippleVisible && _ripplePos != null)
            Positioned(
              left: _ripplePos!.dx - 40,
              top: _ripplePos!.dy - 40,
              child: _RippleEffect(),
            ),
          if (_showCelebration)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: cs.card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: cs.cardBorder, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🔥',
                          style: TextStyle(fontSize: 72),
                        ).animate()
                         .scale(begin: const Offset(0.3, 0.3), end: const Offset(1.3, 1.3), duration: 600.ms, curve: Curves.elasticOut)
                         .shake(hz: 3, duration: 800.ms),
                        const SizedBox(height: 16),
                        Text(
                          l.tasbihStreakUpdated,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F8F4C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.tasbihStreakCongrats(_celebratedStreak),
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: cs.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
          if (_showGoalCelebration)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: cs.card,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.8), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🏆',
                          style: TextStyle(fontSize: 80),
                        ).animate()
                         .scale(begin: const Offset(0.3, 0.3), end: const Offset(1.2, 1.2), duration: 800.ms, curve: Curves.elasticOut)
                         .rotate(begin: -0.2, end: 0.2, duration: 1200.ms, curve: Curves.easeInOut)
                         .then(delay: 200.ms)
                         .shake(hz: 4, duration: 600.ms),
                        const SizedBox(height: 16),
                        Text(
                          l.tasbihGoalAchieved,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFCD9D27),
                          ),
                        ).animate()
                         .fadeIn(duration: 400.ms)
                         .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), duration: 400.ms),
                        const SizedBox(height: 8),
                        Text(
                          l.tasbihGoalCompleted,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: cs.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('⭐', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 8),
                            Text('✨', style: TextStyle(fontSize: 28)),
                            SizedBox(width: 8),
                            Text('⭐', style: TextStyle(fontSize: 24)),
                          ],
                        ).animate(onPlay: (c) => c.repeat(reverse: true))
                         .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),
        ],
      ),
    );
  }

  void _showStartSessionDialog(BuildContext context, AppColorScheme cs, TasbihState tasbihState) {
    final l = context.l10n;
    final nameCtrl = TextEditingController();
    int? selectedPredefinedIndex;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: cs.card,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                l.homeStartDhikrSession,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      l.homeSelectDhikrToBegin,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: cs.cardBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        itemCount: tasbihState.dhikrs.length,
                        itemBuilder: (c, idx) {
                          final dhikr = tasbihState.dhikrs[idx];
                          final isSel = selectedPredefinedIndex == idx;
                          return ListTile(
                            dense: true,
                            selected: isSel,
                            selectedTileColor: cs.primary.withValues(alpha: 0.1),
                            title: Text(
                              dhikr.name,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'UthmanicHafs',
                                fontSize: 16,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                color: isSel ? cs.primary : cs.textPrimary,
                              ),
                            ),
                            trailing: isSel ? Icon(Icons.check, color: cs.primary, size: 18) : null,
                            onTap: () {
                              setDialogState(() {
                                selectedPredefinedIndex = idx;
                                nameCtrl.clear();
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l.tasbihOrCustomName,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameCtrl,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: l.tasbihExampleSalawat,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (val) {
                        if (val.trim().isNotEmpty) {
                          setDialogState(() {
                            selectedPredefinedIndex = null;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l.homeCancel, style: const TextStyle(fontFamily: 'Cairo')),
                ),
                ElevatedButton(
                  onPressed: () async {
                    int? dhikrId;
                    String? customName;

                    if (selectedPredefinedIndex != null) {
                      final selectedDhikr = tasbihState.dhikrs[selectedPredefinedIndex!];
                      if (selectedDhikr.isCustom) {
                        customName = selectedDhikr.name;
                      } else {
                        dhikrId = int.tryParse(selectedDhikr.id);
                        if (dhikrId == null) {
                          customName = selectedDhikr.name;
                        }
                      }
                    } else {
                      customName = nameCtrl.text.trim();
                    }

                    if (dhikrId == null && (customName == null || customName.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l.tasbihSelectOrEnterName,
                            style: const TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(ctx);

                    BuildContext? loaderCtx;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (c) {
                        loaderCtx = c;
                        return Center(child: CircularProgressIndicator(color: cs.primary));
                      },
                    );

                    final success = await ref.read(tasbihSessionProvider.notifier).startSession(
                          dhikrId: dhikrId,
                          customDhikrName: customName,
                        );

                    if (loaderCtx != null && loaderCtx!.mounted) {
                      Navigator.pop(loaderCtx!);
                    }

                    if (success && mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ActiveSessionPage()),
                      );
                    } else if (mounted) {
                      final errorMsg = ref.read(tasbihSessionProvider).errorMessage ?? 'Error starting session';
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(errorMsg, style: const TextStyle(fontFamily: 'Cairo')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    l.homeStartButton,
                    style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Dhikr Chips
// ─────────────────────────────────────────────────────────────────────────────

} // end _TasbihPageState

class _DhikrChips extends ConsumerWidget {
  const _DhikrChips({
    required this.cs,
    required this.selectedIndex,
    required this.onSelected,
    required this.dhikrs,
    required this.onAddPressed,
    required this.onDeletePressed,
  });
  final AppColorScheme cs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<TasbihModel> dhikrs;
  final VoidCallback onAddPressed;
  final ValueChanged<String> onDeletePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 48,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true, // Symmetrical right-to-left layout
        itemCount: dhikrs.length + 1, // +1 for the "+" button
        itemBuilder: (_, i) {
          // Render the "+" button as the last item (which will show up on the left side of ListView due to reverse: true)
          if (i == dhikrs.length) {
            return GestureDetector(
              onTap: onAddPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: cs.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: cs.primary, size: 18),
                      const SizedBox(width: 4),
                      const Text(
                        'زیادکردن',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F8F4C), // Custom Green matching premium brand
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final dhikr = dhikrs[i];
          final active = i == selectedIndex;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: active ? cs.primary : cs.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: active ? cs.primary : cs.cardBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      dhikr.name,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active ? Colors.white : cs.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              if (dhikr.isCustom)
                Positioned(
                  top: -4,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => onDeletePressed(dhikr.id),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated Ring
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedRing extends StatelessWidget {
  const _AnimatedRing({
    required this.animation,
    required this.isDark,
    required this.color,
    this.theme,
    required this.preferences,
  });
  final Animation<double> animation;
  final bool isDark;
  final Color color;
  final TasbihThemeModel? theme;
  final UserThemePreferenceModel preferences;

  @override
  Widget build(BuildContext context) {
    Color ringColor = color;
    double ringWidth = 8.0;
    bool glow = true;
    String animationType = 'ripple';

    if (theme != null) {
      final metadata = theme!.themeMetadata;
      final ringConfig = metadata['ring'] ?? {};
      final colorStr = ringConfig['color'] ?? '#ffd700';
      ringColor = Color(int.parse(colorStr.replaceAll('#', '0xFF')));
      ringWidth = (ringConfig['width'] as num?)?.toDouble() ?? 8.0;
      glow = ringConfig['glow'] ?? true;
      animationType = ringConfig['animation'] ?? 'ripple';
    }

    if (preferences.customRingColor != null) {
      ringColor = Color(int.parse(preferences.customRingColor!.replaceAll('#', '0xFF')));
    }

    if (!preferences.animationEnabled) {
      animationType = 'none';
      glow = false;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(280, 280),
          painter: _RingPainter(
            progress: animationType == 'none' ? 0.0 : animation.value,
            isDark: isDark,
            color: ringColor,
            width: ringWidth,
            glow: glow,
            animationType: animationType,
          ),
        );
      },
    );
  }
}

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
    if (glow) {
      canvas.drawCircle(
        center,
        radius - 20,
        Paint()
          ..color = color.withValues(alpha: isDark ? 0.05 : 0.07)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Rotating or pulsing arc
    final double sweepAngle = animationType == 'pulse' 
        ? (3.14 * 1.5 + (0.5 * 3.14 * (1.0 + (progress > 0 ? (progress * 2 - 1.0).abs() : 0.0))))
        : 3.14 * 1.5;

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

// ─────────────────────────────────────────────────────────────────────────────
// Counter Display
// ─────────────────────────────────────────────────────────────────────────────

class _CounterDisplay extends StatelessWidget {
  const _CounterDisplay({
    required this.count,
    required this.cs,
    required this.target,
    this.theme,
    required this.preferences,
  });
  final int count;
  final AppColorScheme cs;
  final int target;
  final TasbihThemeModel? theme;
  final UserThemePreferenceModel preferences;

  @override
  Widget build(BuildContext context) {
    Color textColor = cs.primary;
    String fontFamily = 'Cairo';

    if (theme != null) {
      final metadata = theme!.themeMetadata;
      final counterConfig = metadata['counter'] ?? {};
      final textColorStr = counterConfig['text_color'] ?? '#ffffff';
      textColor = Color(int.parse(textColorStr.replaceAll('#', '0xFF')));

      final typoConfig = metadata['typography'] ?? {};
      final font = typoConfig['font_family'] ?? 'cairo';
      fontFamily = font == 'cairo' ? 'Cairo' : 'Courier';
    }

    final double fontScale = preferences.customFontScale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 76 * fontScale,
            fontWeight: FontWeight.w900,
            color: textColor,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: textColor.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            '/ $target',
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 15 * fontScale,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ripple Effect
// ─────────────────────────────────────────────────────────────────────────────

class _RippleEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cs.primary.withValues(alpha: 0.2),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1.5, 1.5),
          duration: 500.ms,
          curve: Curves.easeOut,
        )
        .fadeOut(duration: 500.ms);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reset Button
// ─────────────────────────────────────────────────────────────────────────────

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onReset, required this.l});
  final VoidCallback onReset;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    return GestureDetector(
      onTap: onReset,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(
            color: cs.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded, color: cs.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              l.tasbihReset,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
