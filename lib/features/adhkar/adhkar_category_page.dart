import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import 'adhkar_session_page.dart';

class AdhkarCategoryPage extends ConsumerStatefulWidget {
  final String categoryKey;
  final String title;
  final List<AdhkarItem> items;

  const AdhkarCategoryPage({
    super.key,
    required this.categoryKey,
    required this.title,
    required this.items,
  });

  @override
  ConsumerState<AdhkarCategoryPage> createState() => _AdhkarCategoryPageState();
}

class _AdhkarCategoryPageState extends ConsumerState<AdhkarCategoryPage> {
  late List<int> _counts;

  @override
  void initState() {
    super.initState();
    _counts = List.filled(widget.items.length, 0);
  }

  void _checkCompletion() {
    bool allDone = true;
    for (int i = 0; i < widget.items.length; i++) {
      if (_counts[i] < widget.items[i].targetCount) {
        allDone = false;
        break;
      }
    }

    if (allDone) {
      ref.read(adhkarProvider.notifier).completeCategory(widget.categoryKey);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'یارەبی خودا قبوڵی فەرموو بێت! ${widget.title} تەواو بوو 🎉',
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0F8F4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                _counts = List.filled(widget.items.length, 0);
              });
            },
            tooltip: 'دەستپێکردنەوە',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final currentCount = _counts[index];
                final isCompleted = currentCount >= item.targetCount;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCompleted
                          ? const Color(0xFF0F8F4C).withValues(alpha: 0.3)
                          : cs.cardBorder,
                      width: isCompleted ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Arabic supplication text
                      Text(
                        item.text,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'UthmanicHafs',
                          fontSize: 16,
                          height: 1.8,
                          color: cs.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // Kurdish/English translation
                      Text(
                        item.getTranslation(Localizations.localeOf(context).languageCode),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: cs.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      if (item.benefit.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        // Benefit container
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: cs.primary.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded, size: 14, color: cs.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${l.adhkarBenefit}: ${item.benefit}',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 10,
                                    color: cs.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Counter Pill / Tap Area
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${l.adhkarTarget}: ${item.targetCount}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: cs.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (currentCount < item.targetCount) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  _counts[index]++;
                                });
                                _checkCompletion();
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? const Color(0xFF0F8F4C)
                                    : cs.primary.withValues(alpha: currentCount > 0 ? 0.2 : 0.08),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isCompleted
                                      ? const Color(0xFF0F8F4C)
                                      : cs.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCompleted ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                                    color: isCompleted ? Colors.white : cs.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isCompleted
                                        ? 'تەواو بوو ✓'
                                        : (currentCount > 0 ? '$currentCount / ${item.targetCount}' : 'بژمێرە'),
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted ? Colors.white : cs.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                      duration: 350.ms,
                      delay: Duration(milliseconds: 50 * index),
                    );
              },
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.card,
          border: Border(top: BorderSide(color: cs.cardBorder)),
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdhkarSessionPage(
                  categoryKey: widget.categoryKey,
                  title: widget.title,
                  items: widget.items,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            shadowColor: cs.primary.withValues(alpha: 0.3),
          ),
          icon: const Icon(Icons.flash_on_rounded, size: 20),
          label: Text(
            l.adhkarStartSession,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
