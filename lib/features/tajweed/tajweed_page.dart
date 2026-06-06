import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/models/tajweed_rule_model.dart';

class TajweedPage extends ConsumerStatefulWidget {
  const TajweedPage({super.key});

  @override
  ConsumerState<TajweedPage> createState() => _TajweedPageState();
}

class _TajweedPageState extends ConsumerState<TajweedPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _getCategoryName(String? category) {
    switch (category) {
      case 'noon_sakinah':
        return 'أحکامی نوونی ساکن و تەنوین';
      case 'meem_sakinah':
        return 'أحکامی میمی ساکن';
      case 'madd':
        return 'درێژکردنەوەکان (المدود)';
      case 'qalqalah':
        return 'قەلقەلە (لەرزاندن)';
      case 'heavy_letters':
        return 'حروف التفخيم (پیتە قەڵەوەکان)';
      case 'light_letters':
        return 'حروف الترقيق (پیتە باریکەکان)';
      case 'merging':
        return 'الإدغام (تێکەڵکردن)';
      case 'clear':
        return 'الإظهار (دەرخستن)';
      case 'change':
        return 'الإقلاب (گۆڕین)';
      case 'hide':
        return 'الإخفاء (شاردنەوە)';
      case 'pause':
        return 'یاساکانی وەستان';
      case 'prostration':
        return 'سوجدەی تلاوەت';
      default:
        return 'ئەحکامەکانی تر';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rulesAsync = ref.watch(tajweedRulesFutureProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'فێربوونی ئەحکامەکانی تەجوید',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Search & Filter Section ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: isDark ? AppColorScheme.darken(cs.primary, 0.4) : cs.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 14),
                    onChanged: (val) => setState(() => _query = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'بگەڕێ بۆ حوکمێک یان شیکردنەوەیەک...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                      hintTextDirection: TextDirection.rtl,
                      prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, color: Colors.white70),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Category Pills List
                rulesAsync.when(
                  data: (rules) {
                    final categories = {'all', ...rules.map((r) => r.category ?? 'other')};
                    return SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        children: categories.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ChoiceChip(
                              label: Text(
                                cat == 'all' ? 'هەموو بابەتەکان' : _getCategoryName(cat),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: isDark ? cs.primary : const Color(0xFFCD9D27),
                              backgroundColor: Colors.white.withValues(alpha: isDark ? 0.05 : 0.15),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedCategory = cat);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              showCheckmark: false,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          
          // ── Rules List ─────────────────────────────────────────────────────
          Expanded(
            child: rulesAsync.when(
              data: (rules) {
                // Filter rules
                final filtered = rules.where((rule) {
                  final matchesCat = _selectedCategory == 'all' || rule.category == _selectedCategory;
                  final matchesQuery = _query.isEmpty ||
                      rule.nameKu.toLowerCase().contains(_query.toLowerCase()) ||
                      (rule.nameAr != null && rule.nameAr!.contains(_query)) ||
                      rule.name.toLowerCase().contains(_query.toLowerCase()) ||
                      rule.descriptionKu.toLowerCase().contains(_query.toLowerCase()) ||
                      rule.description.toLowerCase().contains(_query.toLowerCase());
                  return matchesCat && matchesQuery;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.palette_outlined, size: 64, color: cs.textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'هیچ حوکمێکی تەجوید نەدۆزرایەوە',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: cs.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final rule = filtered[index];
                    final parsedColor = _parseColor(rule.colorCode);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.cardBorder, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TajweedRuleDetailPage(rule: rule),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left side Color Indicator block
                                  Container(
                                    width: 14,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: parsedColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Middle text information
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                rule.nameKu,
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: cs.textPrimary,
                                                ),
                                              ),
                                            ),
                                            if (rule.nameAr != null)
                                              Text(
                                                rule.nameAr!,
                                                style: const TextStyle(
                                                  fontFamily: 'UthmanicHafs',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1B7340),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _getCategoryName(rule.category),
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 11,
                                            color: cs.primary.withValues(alpha: 0.8),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          rule.descriptionKu,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 12,
                                            height: 1.5,
                                            color: cs.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {}, // Prevent navigating to detail page on switch tap
                                    child: Consumer(
                                      builder: (context, ref, child) {
                                        final inactiveRules = ref.watch(inactiveTajweedRulesProvider);
                                        final isActive = !inactiveRules.contains(rule.slug);
                                        return Switch(
                                          value: isActive,
                                          activeTrackColor: parsedColor.withValues(alpha: 0.4),
                                          activeThumbColor: parsedColor,
                                          onChanged: (val) {
                                            ref.read(inactiveTajweedRulesProvider.notifier).toggleRule(rule.slug, val);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                          duration: 350.ms,
                          delay: (index * 40).ms,
                        );
                  },
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: cs.primary),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'شێوازی بارکردنی ئەحکامەکان سەرکەوتوو نەبوو',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref.refresh(tajweedRulesFutureProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('هەوڵدانەوە', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF1B7340);
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFF1B7340);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TajweedRuleDetailPage
// ─────────────────────────────────────────────────────────────────────────────

class TajweedRuleDetailPage extends StatelessWidget {
  final TajweedRuleModel rule;
  const TajweedRuleDetailPage({super.key, required this.rule});

  Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF1B7340);
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFF1B7340);
    }
  }

  String _getCategoryName(String? category) {
    switch (category) {
      case 'noon_sakinah':
        return 'أحکامی نوونی ساکن و تەنوین';
      case 'meem_sakinah':
        return 'أحکامی میمی ساکن';
      case 'madd':
        return 'درێژکردنەوەکان (المدود)';
      case 'qalqalah':
        return 'قەلقەلە (لەرزاندن)';
      default:
        return 'ئەحکامەکانی تر';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ruleColor = _parseColor(rule.colorCode);

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: ruleColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          rule.nameKu,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Top Highlight Header ─────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: ruleColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  if (rule.nameAr != null) ...[
                    Text(
                      rule.nameAr!,
                      style: const TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    rule.name,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getCategoryName(rule.category),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Kurdish Explanation Card ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: cs.cardBorder, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.description_rounded, color: ruleColor, size: 22),
                            const Text(
                              'ڕوونکردنەوە و شیکردنەوەی حوکمەکە',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B7340),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          rule.descriptionKu,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            height: 1.6,
                            color: cs.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  const SizedBox(height: 16),

                  // ── Example Box Card ──────────────────────────────────────
                  if (rule.exampleText != null && rule.exampleText!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cs.card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: cs.cardBorder, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.star_purple500_rounded, color: ruleColor, size: 22),
                              const Text(
                                'نموونە لەسەر ئەم حوکمە',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B7340),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            decoration: BoxDecoration(
                              color: ruleColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ruleColor.withValues(alpha: 0.15), width: 1),
                            ),
                            child: Text(
                              rule.exampleText!,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontFamily: 'UthmanicHafs',
                                fontSize: 24,
                                height: 1.6,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),

                  const SizedBox(height: 16),

                  // ── English Explanation Card ──────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: cs.cardBorder, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.translate_rounded, color: Colors.grey, size: 20),
                            Text(
                              'English Explanation',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(
                          rule.description,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: cs.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
