import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';

class TasbihPage extends ConsumerStatefulWidget {
  const TasbihPage({super.key});

  @override
  ConsumerState<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends ConsumerState<TasbihPage> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onTap(Dhikr dhikr) async {
    final result = await ref.read(dhikrControllerProvider).increment(
      dhikr.id,
      dhikr.count,
      dhikr.target,
    );

    if (result == null) {
      // Spam tap - rate limited
      return;
    }

    if (result == true) {
      // Completed cycle
      HapticFeedback.heavyImpact();
      _showSuccessFlash();
    } else {
      // Normal valid tap
      HapticFeedback.lightImpact();
    }

    _pulseCtrl.forward(from: 0).then((_) => _pulseCtrl.reverse());
  }

  void _showSuccessFlash() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.tasbihCycleComplete,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAddDhikrDialog() {
    final cs = AppColorScheme.of(context);
    final nameController = TextEditingController();
    final arabicController = TextEditingController();
    final targetController = TextEditingController(text: '33');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.cardBorder),
          ),
          title: Text(
            context.l10n.tasbihAddDhikrTitle,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cs.textPrimary,
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.tasbihDhikrNameLabel,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(color: cs.textPrimary, fontFamily: 'Cairo'),
                    decoration: InputDecoration(
                      hintText: 'SubhanAllah',
                      hintStyle: TextStyle(color: cs.textSecondary.withValues(alpha: 0.5), fontSize: 13),
                      filled: true,
                      fillColor: cs.card,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.primary),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return context.l10n.tasbihDhikrNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.tasbihDhikrArabicLabel,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: arabicController,
                    style: TextStyle(color: cs.textPrimary, fontFamily: 'UthmanicHafs', fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'سُبْحَانَ ٱللَّهِ',
                      hintStyle: TextStyle(color: cs.textSecondary.withValues(alpha: 0.5), fontSize: 14),
                      filled: true,
                      fillColor: cs.card,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.tasbihTargetLabel,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: cs.textPrimary, fontFamily: 'Cairo'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cs.card,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: cs.primary),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return context.l10n.tasbihTargetRequired;
                      }
                      final n = int.tryParse(val);
                      if (n == null || n <= 0) {
                        return context.l10n.tasbihTargetInvalid;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.l10n.commonCancel,
                style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final name = nameController.text.trim();
                  final arabic = arabicController.text.trim().isEmpty ? null : arabicController.text.trim();
                  final target = int.parse(targetController.text.trim());

                  await ref.read(dhikrControllerProvider).addDhikr(name, arabic, target);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.l10n.tasbihDhikrAdded,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                        ),
                        backgroundColor: cs.primary,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              },
              child: Text(
                context.l10n.commonSave,
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final globalTasbihState = ref.watch(tasbihCountProvider);
    final dhikrsAsync = ref.watch(dhikrsStreamProvider);
    final activeDhikrAsync = ref.watch(activeDhikrProvider);
    final selectedDhikrId = ref.watch(selectedDhikrIdProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.tasbihTitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                  PopupMenuButton<int>(
                    icon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(color: cs.cardBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.more_vert_rounded, size: 16, color: cs.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            context.l10n.tasbihActions,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    color: cs.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: cs.cardBorder),
                    ),
                    itemBuilder: (context) {
                      final List<PopupMenuEntry<int>> items = [
                        PopupMenuItem(
                          value: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(context.l10n.tasbihResetThis, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textPrimary)),
                              Icon(Icons.refresh_rounded, size: 18, color: cs.textSecondary),
                            ],
                          ),
                        ),
                      ];

                      final currentDhikr = activeDhikrAsync.value;
                      if (currentDhikr != null && !currentDhikr.isSystem) {
                        items.add(
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.l10n.tasbihDeleteThis, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, color: Colors.redAccent)),
                                const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                              ],
                            ),
                          ),
                        );
                      }

                      items.add(
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(context.l10n.tasbihResetAllTitle, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.textPrimary)),
                              Icon(Icons.restore_rounded, size: 18, color: cs.textSecondary),
                            ],
                          ),
                        ),
                      );

                      return items;
                    },
                    onSelected: (value) async {
                      final currentDhikr = activeDhikrAsync.value;
                      if (currentDhikr == null) return;

                      if (value == 0) {
                        HapticFeedback.mediumImpact();
                        await ref.read(dhikrControllerProvider).reset(currentDhikr.id);
                      } else if (value == 1) {
                        HapticFeedback.mediumImpact();
                        // Reset selection to 1 (SubhanAllah) before deleting
                        ref.read(selectedDhikrIdProvider.notifier).state = 1;
                        await ref.read(dhikrControllerProvider).deleteDhikr(currentDhikr.id);
                      } else if (value == 2) {
                        HapticFeedback.mediumImpact();
                        await ref.read(dhikrControllerProvider).resetAll();
                      }
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            // Dhikr selector
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: dhikrsAsync.when(
                data: (dhikrs) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    reverse: Directionality.of(context) == TextDirection.rtl,
                    // plus 1 for the Add button
                    itemCount: dhikrs.length + 1,
                    itemBuilder: (_, i) {
                      if (i == dhikrs.length) {
                        // Plus/Add Button
                        return GestureDetector(
                          onTap: _showAddDhikrDialog,
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(end: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: cs.card,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                              border: Border.all(color: cs.primary.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_rounded, size: 16, color: cs.primary),
                                const SizedBox(width: 4),
                                Text(
                                  context.l10n.tasbihAdd,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: cs.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final dhikr = dhikrs[i];
                      final isSelected = selectedDhikrId == dhikr.id;

                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          ref.read(selectedDhikrIdProvider.notifier).state = dhikr.id;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsetsDirectional.only(end: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? cs.primary : cs.card,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                            border: Border.all(color: isSelected ? cs.primary : cs.cardBorder),
                          ),
                          child: Text(
                            '${i + 1}. ${dhikr.name} (${dhikr.count})',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              color: isSelected ? Colors.white : cs.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            // Main tap area
            Expanded(
              child: activeDhikrAsync.when(
                data: (dhikr) {
                  final progress = (dhikr.count / dhikr.target).clamp(0.0, 1.0);
                  final dhikrs = dhikrsAsync.value ?? [];
                  final idx = dhikrs.indexWhere((d) => d.id == dhikr.id);
                  final numberPrefix = idx != -1 ? '${idx + 1}. ' : '';

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTap(dhikr),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ring + counter
                          ScaleTransition(
                            scale: _pulseAnim,
                            child: SizedBox(
                              width: 230,
                              height: 230,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Background ring glow
                                  Container(
                                    width: 220,
                                    height: 220,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: cs.primary.withValues(alpha: 0.03),
                                    ),
                                  ),
                                  // Background ring
                                  SizedBox.expand(
                                    child: CircularProgressIndicator(
                                      value: 1,
                                      strokeWidth: 6,
                                      color: cs.primary.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  // Progress ring
                                  SizedBox.expand(
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 6,
                                      strokeCap: StrokeCap.round,
                                      color: cs.primary,
                                    ),
                                  ),
                                  // Inner clickable circle
                                  Container(
                                    width: 190,
                                    height: 190,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: cs.card,
                                      border: Border.all(color: cs.cardBorder, width: 1),
                                      boxShadow: [
                                        BoxShadow(
                                          color: cs.primary.withValues(alpha: 0.08),
                                          blurRadius: 30,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${dhikr.count}',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 68,
                                            fontWeight: FontWeight.w800,
                                            color: cs.textPrimary,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '/ ${dhikr.target}',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 14,
                                            color: cs.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Current dhikr name
                          Text(
                            '$numberPrefix${dhikr.arabic ?? dhikr.name} (${dhikr.count})',
                            textDirection: dhikr.arabic != null ? TextDirection.rtl : null,
                            style: TextStyle(
                              fontFamily: dhikr.arabic != null ? 'UthmanicHafs' : 'Cairo',
                              fontSize: 28,
                              color: cs.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                              .animate(key: ValueKey(dhikr.id))
                              .fadeIn(duration: 300.ms)
                              .scale(begin: const Offset(0.9, 0.9), duration: 250.ms),

                          if (dhikr.arabic != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              dhikr.name,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: cs.textSecondary,
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),

                          Text(
                            context.l10n.tasbihTapToCount,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: cs.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),

            // Total count footer
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${context.l10n.tasbihTotal}: ',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: cs.textSecondary,
                    ),
                  ),
                  Text(
                    '${globalTasbihState.totalCount}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          ],
        ),
      ),
    );
  }
}

