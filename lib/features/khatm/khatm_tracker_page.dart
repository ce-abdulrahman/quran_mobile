import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../quran/quran_page.dart';
import '../quran/quran_reader_page.dart';
import '../quran/quran_providers.dart';

class KhatmTrackerPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const KhatmTrackerPage({super.key, this.showBackButton = false});

  @override
  ConsumerState<KhatmTrackerPage> createState() => _KhatmTrackerPageState();
}

class _KhatmTrackerPageState extends ConsumerState<KhatmTrackerPage> {
  final _titleController = TextEditingController();
  final _customDaysController = TextEditingController();
  int _selectedDays = 30;
  bool _isCustomDays = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController.text = 'ختمی ڕەمەزان';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customDaysController.dispose();
    super.dispose();
  }

  void _showDeleteKhatmDialog(BuildContext context, AppColorScheme cs) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'سڕینەوەی پلان',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'ئایا دڵنیایت لە سڕینەوەی ئەم پلانەی ختم؟ پێشکەوتنەکانت لێرە دەسڕێتەوە.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'نەخێر',
              style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(khatmProvider.notifier).deleteKhatm();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text(
              'بەڵێ، بسڕەوە',
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
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeKhatm = ref.watch(khatmProvider);

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
          l.khatmTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (activeKhatm != null)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
              onPressed: () => _showDeleteKhatmDialog(context, cs),
              tooltip: 'سڕینەوەی ختم',
            ),
        ],
      ),
      body: activeKhatm == null ? _buildSetupWizard(cs, l, isDark) : _buildDashboard(activeKhatm, cs, l, isDark),
    );
  }

  Widget _buildSetupWizard(AppColorScheme cs, AppLocalizations l, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Premium Wizard Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          AppColorScheme.darken(cs.primary, 0.35),
                          AppColorScheme.darken(cs.primary, 0.45)
                        ]
                      : [cs.primary, cs.primaryDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.khatmCreate,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ئەم تایبەتمەندییە یارمەتیدەرت دەبێت بۆ ختمکردنی قورئان لە ماوەیەکی دیاریکراودا بە پێشکەشکردنی ئامار و ئامانجەکانی خوێندنەوەی ڕۆژانە.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).scale(begin: const Offset(0.95, 0.95)),

            const SizedBox(height: 24),

            // Input Fields Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Input
                  Text(
                    l.khatmTitleInput,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: cs.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ناوی ختمەکە لێرە بنووسە',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: cs.primary, width: 1.5),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'تكایە ناوی ختمەکە بنووسە';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Target Days
                  Text(
                    l.khatmDaysInput,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Preset Days Pills
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [30, 45, 60, 90].map((days) {
                      final selected = _selectedDays == days && !_isCustomDays;
                      return ChoiceChip(
                        label: Text(
                          '$days ڕۆژ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : cs.textPrimary,
                          ),
                        ),
                        selected: selected,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedDays = days;
                              _isCustomDays = false;
                            });
                          }
                        },
                        selectedColor: cs.primary,
                        backgroundColor: isDark ? Colors.black.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    }).toList()
                      ..add(
                        ChoiceChip(
                          label: Text(
                            'ماوەی تر',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _isCustomDays ? Colors.white : cs.textPrimary,
                            ),
                          ),
                          selected: _isCustomDays,
                          onSelected: (val) {
                            if (val) {
                              setState(() {
                                _isCustomDays = true;
                              });
                            }
                          },
                          selectedColor: cs.primary,
                          backgroundColor: isDark ? Colors.black.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.08),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                  ),

                  if (_isCustomDays) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _customDaysController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: cs.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ماوەکە بە ڕۆژ بنووسە',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: cs.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: cs.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: cs.primary, width: 1.5),
                        ),
                      ),
                      validator: (v) {
                        if (_isCustomDays) {
                          if (v == null || v.isEmpty) {
                            return 'تكایە ماوەکە بنووسە';
                          }
                          final parsed = int.tryParse(v);
                          if (parsed == null || parsed <= 0) {
                            return 'تكایە ژمارەیەکی گونجاو بنووسە';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 32),

            // Start Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final targetDays = _isCustomDays
                      ? int.parse(_customDaysController.text)
                      : _selectedDays;
                  ref.read(khatmProvider.notifier).startKhatm(
                        _titleController.text,
                        targetDays,
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                shadowColor: cs.primary.withValues(alpha: 0.4),
              ),
              child: Text(
                l.khatmStart,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(LocalKhatmPlan activeKhatm, AppColorScheme cs, AppLocalizations l, bool isDark) {
    final trackerState = ref.watch(readingTrackerProvider);
    
    // Calculate total read Ayahs after start date of active Khatm
    final readAyahsCount = trackerState.history
        .where((h) => h.timestamp.isAfter(activeKhatm.startDate))
        .map((h) => '${h.surahId}-${h.ayahNumber}')
        .toSet()
        .length;

    // Trigger completion if finished and not updated yet
    if (!activeKhatm.isCompleted && readAyahsCount >= 6236) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(khatmProvider.notifier).checkCompletion(readAyahsCount);
      });
    }

    const totalAyahs = 6236;
    final progress = (readAyahsCount / totalAyahs).clamp(0.0, 1.0);
    final progressPct = (progress * 100).round();

    // Days calculations
    final now = DateTime.now();
    final startMidnight = DateTime(activeKhatm.startDate.year, activeKhatm.startDate.month, activeKhatm.startDate.day);
    final todayMidnight = DateTime(now.year, now.month, now.day);
    
    final elapsedDays = todayMidnight.difference(startMidnight).inDays + 1;
    final activeElapsedDays = elapsedDays.clamp(1, activeKhatm.targetDays);
    final remainingDays = (activeKhatm.targetDays - todayMidnight.difference(startMidnight).inDays).clamp(0, activeKhatm.targetDays);

    // Target stats
    final dailyTarget = (totalAyahs / activeKhatm.targetDays).ceil();
    final expectedRead = dailyTarget * activeElapsedDays;

    // Status Calculations
    String statusText;
    Color statusColor;
    IconData statusIcon;
    if (activeKhatm.isCompleted || readAyahsCount >= totalAyahs) {
      statusText = 'پیرۆزە! تەواو بوو 🎉';
      statusColor = const Color(0xFF0F8F4C);
      statusIcon = Icons.stars_rounded;
    } else if (readAyahsCount >= expectedRead + dailyTarget) {
      statusText = l.khatmStatusAhead;
      statusColor = const Color(0xFFE6A23C);
      statusIcon = Icons.trending_up_rounded;
    } else if (readAyahsCount >= expectedRead) {
      statusText = l.khatmStatusOnTrack;
      statusColor = const Color(0xFF0F8F4C);
      statusIcon = Icons.check_circle_outline_rounded;
    } else {
      statusText = l.khatmStatusBehind;
      statusColor = const Color(0xFFD9534F);
      statusIcon = Icons.trending_down_rounded;
    }

    // Today's reading progress
    final readTodayCount = trackerState.history
        .where((h) => h.timestamp.isAfter(activeKhatm.startDate))
        .where((h) {
          final hDate = DateTime(h.timestamp.year, h.timestamp.month, h.timestamp.day);
          return hDate.isAtSameMomentAs(todayMidnight);
        })
        .map((h) => '${h.surahId}-${h.ayahNumber}')
        .toSet()
        .length;

    final remainingToday = (dailyTarget - readTodayCount).clamp(0, dailyTarget);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Gauge Progress Card ──
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: cs.card,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: cs.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  activeKhatm.title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                // Circular Progress Gauge
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 14,
                        backgroundColor: cs.cardBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$progressPct%',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$readAyahsCount لە $totalAyahs',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: cs.textSecondary,
                          ),
                        ),
                        Text(
                          'ئایەتی خوێندراو',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 9,
                            color: cs.textSecondary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Tiny description below gauge
                Text(
                  activeKhatm.isCompleted
                      ? 'بەسەرکەوتوویی ختمەکەت کۆتایی پێ هێنا. خوای گەورە لە هەردولا قبوڵ بفەرموێت.'
                      : 'خوێندنەوەی ڕۆژانەت دەبێتە هۆی پاراستنی ڕێژەی پێشکەوتنت.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: cs.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 20),

          // ── Stats Grid ──
          Row(
            children: [
              Expanded(
                child: _DashboardStatCard(
                  title: 'بارودۆخی ئێستا',
                  value: statusText,
                  valueColor: statusColor,
                  icon: statusIcon,
                  iconColor: statusColor,
                  cs: cs,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DashboardStatCard(
                  title: l.khatmDailyTarget,
                  value: '$dailyTarget ئایەت',
                  icon: Icons.flag_circle_rounded,
                  iconColor: const Color(0xFF2196F3),
                  cs: cs,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _DashboardStatCard(
                  title: l.khatmRemainingToday,
                  value: remainingToday == 0 ? 'تەواو بووە ✓' : '$remainingToday ئایەت ماوە',
                  valueColor: remainingToday == 0 ? const Color(0xFF0F8F4C) : cs.textPrimary,
                  icon: Icons.hourglass_bottom_rounded,
                  iconColor: remainingToday == 0 ? const Color(0xFF0F8F4C) : const Color(0xFFE6A23C),
                  cs: cs,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DashboardStatCard(
                  title: 'ماوەی پلانەکە',
                  value: remainingDays == 0 ? 'تەواو بووە' : '$remainingDays ڕۆژ ماوە',
                  icon: Icons.calendar_month_rounded,
                  iconColor: const Color(0xFF9C27B0),
                  cs: cs,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

          const SizedBox(height: 24),

          // ── Today's progress bar ──
          if (!activeKhatm.isCompleted) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cs.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'پێشکەوتنی ئەمڕۆ',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: cs.textPrimary,
                        ),
                      ),
                      Text(
                        '$readTodayCount / $dailyTarget ئایەت',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (readTodayCount / dailyTarget).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: cs.cardBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 24),
          ],

          // ── Action: Continue Reading ──
          ElevatedButton.icon(
            onPressed: () {
              final lastRead = trackerState.lastRead;
              if (lastRead != null) {
                final surahListAsync = ref.read(surahListProvider);
                surahListAsync.whenData((surahs) {
                  try {
                    final matchedSurah = surahs.firstWhere((s) => s.id == lastRead.surahId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuranReaderPage(
                          surah: matchedSurah,
                          initialAyahNumber: lastRead.ayahNumber,
                        ),
                      ),
                    );
                  } catch (_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuranPage(showBackButton: true)),
                    );
                  }
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuranPage(showBackButton: true)),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 20),
            label: Text(
              trackerState.lastRead != null ? 'بەردەوامبە لە خوێندنەوە' : 'دەستپێکردنی خوێندنەوە',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final IconData icon;
  final Color iconColor;
  final AppColorScheme cs;

  const _DashboardStatCard({
    required this.title,
    required this.value,
    this.valueColor,
    required this.icon,
    required this.iconColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: cs.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? cs.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
