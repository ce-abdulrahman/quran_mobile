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

  DateTime? _lastTap;
  static const _cooldownMs = 300;

  // Ripple position
  Offset? _ripplePos;
  bool _rippleVisible = false;
  Timer? _rippleTimer;

  // Ring animation
  late final AnimationController _ringCtrl;
  late final Animation<double> _ringAnim;

  // Tab controller
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _ringAnim = CurvedAnimation(parent: _ringCtrl, curve: Curves.linear);

    _tabController = TabController(length: 2, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _tabController.dispose();
    _rippleTimer?.cancel();
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

    ref.read(tasbihProvider.notifier).incrementCount(activeDhikr.id);

    final tasbihState = ref.read(tasbihProvider);
    final currentCount = (tasbihState.counts[activeDhikr.id] ?? 0) + 1;

    setState(() {
      _ripplePos = details.localPosition;
      _rippleVisible = true;

      // Update history
      _updateHistoryEntry(now, activeDhikr.id, activeDhikr.name, currentCount);
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
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
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '33');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        final cs = AppColorScheme.of(context);
        return AlertDialog(
          backgroundColor: cs.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'زیادکردنی زیکری نوێ',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    labelText: 'ناوی زیکر',
                    alignLabelWithHint: true,
                    hintText: 'سُبْحَانَ اللهِ',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'تکایە ناوی زیکر بنووسە';
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
                  decoration: const InputDecoration(
                    labelText: 'ئامانج (ژمارەی دووبارەکردنەوە)',
                    alignLabelWithHint: true,
                    hintText: '33',
                  ),
                  validator: (val) {
                    if (val == null || int.tryParse(val) == null || int.parse(val) <= 0) {
                      return 'تکایە ژمارەیەکی دروست بنووسە';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('پاشگەزبوونەوە', style: TextStyle(fontFamily: 'Cairo')),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final name = nameCtrl.text.trim();
                  final target = int.parse(targetCtrl.text.trim());
                  ref.read(tasbihProvider.notifier).addCustomDhikr(name, target);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'زیکری "$name" بە سەرکەوتوویی زیادکرا',
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
              ),
              child: const Text('زیادکردن', style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _onDeleteDhikr(String dhikrId, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'سڕینەوەی زیکر',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'دڵنیایت لە سڕینەوەی زیکری "$name"؟',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('پاشگەزبوونەوە', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('بەڵێ، بسڕەوە', style: TextStyle(fontFamily: 'Cairo', color: Colors.red)),
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
            'زیکری "$name" سڕایەوە',
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

  // ── Statistics Calculators ──────────────────────────────────────────

  int get _todayTotal {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    return _history
        .where((entry) => entry['date'] == todayStr)
        .fold(0, (sum, entry) => sum + ((entry['count'] as num?)?.toInt() ?? 0));
  }

  int get _weekTotal {
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) {
      return now.subtract(Duration(days: i)).toIso8601String().substring(0, 10);
    });
    return _history
        .where((entry) => last7Days.contains(entry['date']))
        .fold(0, (sum, entry) => sum + ((entry['count'] as num?)?.toInt() ?? 0));
  }

  int get _monthTotal {
    final now = DateTime.now();
    final last30Days = List.generate(30, (i) {
      return now.subtract(Duration(days: i)).toIso8601String().substring(0, 10);
    });
    return _history
        .where((entry) => last30Days.contains(entry['date']))
        .fold(0, (sum, entry) => sum + ((entry['count'] as num?)?.toInt() ?? 0));
  }

  int get _allTimeTotal {
    return _history.fold(0, (sum, entry) => sum + ((entry['count'] as num?)?.toInt() ?? 0));
  }


  List<String> get _activeHistoryDates {
    final dates = _history
        .where((e) => ((e['count'] as num?)?.toInt() ?? 0) > 0)
        .map((e) => e['date'] as String)
        .toSet()
        .toList();
    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }

  String _formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return '${parsed.year}/${parsed.month.toString().padLeft(2, '0')}/${parsed.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  // ── Tab Widgets ─────────────────────────────────────────────────────

  Widget _buildCounterTab(AppColorScheme cs, AppLocalizations l, bool isDark, TasbihState tasbihState) {
    if (tasbihState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (tasbihState.dhikrs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'هیچ زیکرێک بەردەست نییە',
              style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _showAddDhikrDialog,
              style: ElevatedButton.styleFrom(backgroundColor: cs.primary),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('زیادکردنی یەکەم زیکر', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
            ),
          ],
        ),
      );
    }

    // Safety bounds check
    if (_selectedDhikrIndex >= tasbihState.dhikrs.length) {
      _selectedDhikrIndex = 0;
    }

    final activeDhikr = tasbihState.dhikrs[_selectedDhikrIndex];
    final count = tasbihState.counts[activeDhikr.id] ?? 0;

    return Column(
      children: [
        // ── Header Banner ────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColorScheme.darken(cs.primary, 0.35), AppColorScheme.darken(cs.primary, 0.42)]
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.radio_button_checked_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'تەسبیحی داینامیکی',
                      style: TextStyle(
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

        // ── Dhikr selector scroll row ──────────────────────────────
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

        Expanded(
          child: GestureDetector(
            onTapDown: (details) => _onTap(details, activeDhikr),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated ring
                  _AnimatedRing(animation: _ringAnim, isDark: isDark, color: cs.primary),

                  // Counter
                  _CounterDisplay(count: count, cs: cs, target: activeDhikr.target)
                    .animate(key: ValueKey('count-${activeDhikr.id}-$count'))
                    .scale(
                      begin: const Offset(1.1, 1.1),
                      end: const Offset(1.0, 1.0),
                      duration: 200.ms,
                      curve: Curves.easeOut,
                    ),

                // Ripple
                if (_rippleVisible && _ripplePos != null)
                  Positioned(
                    left: _ripplePos!.dx - 40,
                    top: _ripplePos!.dy - 40,
                    child: _RippleEffect(),
                  ),

                // Tap hint at bottom
                Positioned(
                  bottom: 20,
                  child: Text(
                    l.tasbihTapAnywhere,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: cs.textSecondary,
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(duration: 1200.ms)
                      .then()
                      .fadeOut(duration: 1200.ms),
                ),
              ],
            ),
          ),
        ),
      ),

        // ── Reset button ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: _ResetButton(onReset: () => _reset(activeDhikr), l: l),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, AppColorScheme cs) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cs.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(AppColorScheme cs, AppLocalizations l) {
    final now = DateTime.now();
    final List<DateTime> dates = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    final List<int> dailyTotals = dates.map((date) {
      final dateStr = date.toIso8601String().substring(0, 10);
      return _history
          .where((entry) => entry['date'] == dateStr)
          .fold(0, (sum, entry) => sum + ((entry['count'] as num?)?.toInt() ?? 0));
    }).toList();

    final maxVal = dailyTotals.fold(0, (m, val) => val > m ? val : m);
    const double maxBarHeight = 100.0;

    String getWeekdayKurdish(int weekday) {
      switch (weekday) {
        case DateTime.monday: return 'د';
        case DateTime.tuesday: return 'س';
        case DateTime.wednesday: return 'چ';
        case DateTime.thursday: return 'پ';
        case DateTime.friday: return 'هـ';
        case DateTime.saturday: return 'ش';
        case DateTime.sunday: return 'ی';
        default: return '';
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.tasbihWeek,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
              Text(
                '${l.tasbihTotal}: $_weekTotal',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cs.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final total = dailyTotals[i];
              final date = dates[i];
              final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
              final double heightFraction = maxVal > 0 ? (total / maxVal) : 0.0;
              final double barHeight = heightFraction * maxBarHeight;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    total > 0 ? '$total' : '',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isToday ? cs.primary : cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 16,
                    height: barHeight > 0 ? barHeight : 6.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: total > 0
                            ? (isToday
                                ? [cs.primary, AppColorScheme.darken(cs.primary, 0.15)]
                                : [cs.textSecondary.withValues(alpha: 0.6), cs.textSecondary.withValues(alpha: 0.4)])
                            : [cs.divider, cs.divider],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    getWeekdayKurdish(date.weekday),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? cs.primary : cs.textSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrBreakdown(AppColorScheme cs, AppLocalizations l, List<TasbihModel> activeDhikrs) {
    final Map<String, String> dhikrNames = {};
    final Map<String, int> totals = {};
    
    // Seed with active ones
    for (final d in activeDhikrs) {
      dhikrNames[d.id] = d.name;
    }
    
    for (final entry in _history) {
      final id = (entry['dhikrId'] ?? '').toString();
      if (id.isEmpty) continue;
      final count = ((entry['count'] as num?)?.toInt() ?? 0);
      if (count <= 0) continue;
      
      final name = entry['name'] as String? ?? dhikrNames[id] ?? id;
      dhikrNames[id] = name;
      totals[id] = (totals[id] ?? 0) + count;
    }
    
    final grandTotal = _allTimeTotal;
    
    // Sort by count descending
    final sortedIds = totals.keys.toList()..sort((a, b) => (totals[b] ?? 0).compareTo(totals[a] ?? 0));
    
    final colors = [
      const Color(0xFF009688), // Teal
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFFC107), // Gold/Amber
      const Color(0xFF2196F3), // Blue
      const Color(0xFF7B1FA2), // Purple
      const Color(0xFFE53935), // Red
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.tasbihDhikrBreakdown,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (sortedIds.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'هیچ داتایەک بەردەست نییە',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textSecondary),
                ),
              ),
            )
          else
            ...List.generate(sortedIds.length, (i) {
              final id = sortedIds[i];
              final count = totals[id] ?? 0;
              final name = dhikrNames[id] ?? id;
              final double percent = grandTotal > 0 ? (count / grandTotal) : 0.0;
              final color = colors[i % colors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: cs.textPrimary,
                          ),
                        ),
                        Text(
                          '$count (${(percent * 100).toStringAsFixed(0)}%)',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: cs.divider.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: percent > 0 ? percent : 0.001,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withValues(alpha: 0.7)],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String dateStr, AppColorScheme cs, AppLocalizations l, List<TasbihModel> activeDhikrs) {
    final entries = _history.where((e) => e['date'] == dateStr && ((e['count'] as num?)?.toInt() ?? 0) > 0).toList();
    final total = entries.fold(0, (sum, e) => sum + ((e['count'] as num?)?.toInt() ?? 0));

    final Map<String, String> dhikrNames = {};
    for (final d in activeDhikrs) {
      dhikrNames[d.id] = d.name;
    }

    final colors = [
      const Color(0xFF009688),
      const Color(0xFF4CAF50),
      const Color(0xFFFFC107),
      const Color(0xFF2196F3),
      const Color(0xFF7B1FA2),
      const Color(0xFFE53935),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(dateStr),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${l.tasbihTotal}: $total',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: List.generate(entries.length, (index) {
              final e = entries[index];
              final id = (e['dhikrId'] ?? '').toString();
              final name = e['name'] as String? ?? dhikrNames[id] ?? id;
              final count = ((e['count'] as num?)?.toInt() ?? 0);
              
              int colorIndex = 0;
              try {
                final parsedId = int.tryParse(id);
                if (parsedId != null) {
                  colorIndex = (parsedId - 1) % colors.length;
                } else {
                  colorIndex = id.hashCode % colors.length;
                }
              } catch (_) {}
              final color = colors[colorIndex.abs() % colors.length];

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      name,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab(AppColorScheme cs, AppLocalizations l, bool isDark, TasbihState tasbihState) {
    final activeDates = _activeHistoryDates;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            _buildMetricCard(l.tasbihMonth, '$_monthTotal', cs.primaryDeep, cs),
            const SizedBox(width: 12),
            _buildMetricCard(l.tasbihWeek, '$_weekTotal', cs.primary, cs),
            const SizedBox(width: 12),
            _buildMetricCard(l.tasbihToday, '$_todayTotal', const Color(0xFF009688), cs),
          ],
        ),
        const SizedBox(height: 16),
        _buildWeeklyChart(cs, l),
        const SizedBox(height: 16),
        _buildDhikrBreakdown(cs, l, tasbihState.dhikrs),
        const SizedBox(height: 24),
        if (activeDates.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l.tasbihHistoryLogs,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
              ),
            ),
          ),
          ...activeDates.map((dateStr) => _buildHistoryItem(dateStr, cs, l, tasbihState.dhikrs)),
        ] else
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_rounded, size: 48, color: cs.textSecondary.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text(
                    'هیچ تۆمارێک نییە',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tasbihState = ref.watch(tasbihProvider);

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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600, fontSize: 14),
          tabs: [
            Tab(text: l.tasbihCounter),
            Tab(text: l.tasbihStats),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCounterTab(cs, l, isDark, tasbihState),
          _buildStatsTab(cs, l, isDark, tasbihState),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dhikr Chips
// ─────────────────────────────────────────────────────────────────────────────

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
  const _AnimatedRing({required this.animation, required this.isDark, required this.color});
  final Animation<double> animation;
  final bool isDark;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return CustomPaint(
          size: const Size(280, 280),
          painter: _RingPainter(
            progress: animation.value,
            isDark: isDark,
            color: color,
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
      radius - 20,
      Paint()
        ..color = color.withValues(alpha: isDark ? 0.05 : 0.07)
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

// ─────────────────────────────────────────────────────────────────────────────
// Counter Display
// ─────────────────────────────────────────────────────────────────────────────

class _CounterDisplay extends StatelessWidget {
  const _CounterDisplay({required this.count, required this.cs, required this.target});
  final int count;
  final AppColorScheme cs;
  final int target;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 76,
            fontWeight: FontWeight.w900,
            color: cs.primary,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            '/ $target',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: cs.textSecondary,
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
