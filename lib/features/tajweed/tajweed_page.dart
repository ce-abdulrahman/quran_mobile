import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/models/tajweed_rule_model.dart';
import '../../core/models/tajweed_category_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Tajweed Page — Category-first drill-down, driven by API data
// ─────────────────────────────────────────────────────────────────────────────

class TajweedPage extends ConsumerStatefulWidget {
  const TajweedPage({super.key});

  @override
  ConsumerState<TajweedPage> createState() => _TajweedPageState();
}

class _TajweedPageState extends ConsumerState<TajweedPage> {
  // null = category grid, non-null = rules for that category index
  int? _selectedCategoryIndex;

  // Static gradient palette (cycles for unknown categories)
  static const List<List<Color>> _gradients = [
    [Color(0xFF1A8C4E), Color(0xFF0D5C33)],
    [Color(0xFF2563EB), Color(0xFF1E40AF)],
    [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    [Color(0xFFD97706), Color(0xFF92400E)],
    [Color(0xFFDC2626), Color(0xFF991B1B)],
    [Color(0xFF0891B2), Color(0xFF155E75)],
    [Color(0xFF059669), Color(0xFF064E3B)],
    [Color(0xFF6366F1), Color(0xFF4338CA)],
    [Color(0xFFEC4899), Color(0xFF9D174D)],
    [Color(0xFF64748B), Color(0xFF334155)],
    [Color(0xFF0E7490), Color(0xFF164E63)],
    [Color(0xFF854D0E), Color(0xFF431407)],
  ];

  static const List<IconData> _icons = [
    Icons.circle_outlined,
    Icons.radio_button_checked_rounded,
    Icons.linear_scale_rounded,
    Icons.waves_rounded,
    Icons.format_bold_rounded,
    Icons.format_italic_rounded,
    Icons.merge_rounded,
    Icons.visibility_rounded,
    Icons.swap_horiz_rounded,
    Icons.visibility_off_rounded,
    Icons.pause_circle_rounded,
    Icons.arrow_downward_rounded,
  ];

  List<Color> _gradient(int i) => _gradients[i % _gradients.length];
  IconData _icon(int i) => _icons[i % _icons.length];

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catsAsync = ref.watch(tajweedCategoriesProvider);
    final inactiveRules = ref.watch(inactiveTajweedRulesProvider);

    // Resolve selected category name for app bar
    String? selectedName;
    if (_selectedCategoryIndex != null) {
      catsAsync.whenData((cats) {
        if (_selectedCategoryIndex! < cats.length) {
          selectedName = cats[_selectedCategoryIndex!].nameKu;
        }
      });
    }

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: _selectedCategoryIndex != null
              ? () => setState(() => _selectedCategoryIndex = null)
              : () => Navigator.pop(context),
        ),
        title: AnimatedSwitcher(
          duration: 250.ms,
          child: _selectedCategoryIndex == null
              ? const Text(
                  'فێربوونی یاساکانی تەجوید',
                  key: ValueKey('main'),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                )
              : Text(
                  selectedName ?? 'یاساکان',
                  key: ValueKey('cat_$_selectedCategoryIndex'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
      body: catsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildError(e.toString(), cs),
        data: (categories) {
          if (categories.isEmpty) {
            return _buildEmpty(cs);
          }
          return AnimatedSwitcher(
            duration: 280.ms,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: _selectedCategoryIndex == null
                      ? const Offset(-0.04, 0)
                      : const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: _selectedCategoryIndex == null
                ? _CategoryGrid(
                    key: const ValueKey('grid'),
                    categories: categories,
                    inactiveRules: inactiveRules,
                    gradientFn: _gradient,
                    iconFn: _icon,
                    onSelect: (i) =>
                        setState(() => _selectedCategoryIndex = i),
                    cs: cs,
                  )
                : _RulesList(
                    key: ValueKey('rules_$_selectedCategoryIndex'),
                    category: categories[_selectedCategoryIndex!],
                    inactiveRules: inactiveRules,
                    gradient: _gradient(_selectedCategoryIndex!),
                    icon: _icon(_selectedCategoryIndex!),
                    cs: cs,
                    isDark: isDark,
                    onToggle: (slug, currentlyActive) {
                      ref
                          .read(inactiveTajweedRulesProvider.notifier)
                          .toggleRule(slug, currentlyActive);
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget _buildError(String msg, AppColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'هێڵی ئینتەرنێت نییە یان سێرڤەر کار ناکات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(tajweedCategoriesProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('دووبارە هەوڵبدەرەوە', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(AppColorScheme cs) {
    return Center(
      child: Text(
        'هیچ جۆرێک بەردەست نییە',
        style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Grid
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryGrid extends StatelessWidget {
  final List<TajweedCategoryModel> categories;
  final Set<String> inactiveRules;
  final List<Color> Function(int) gradientFn;
  final IconData Function(int) iconFn;
  final void Function(int) onSelect;
  final AppColorScheme cs;

  const _CategoryGrid({
    super.key,
    required this.categories,
    required this.inactiveRules,
    required this.gradientFn,
    required this.iconFn,
    required this.onSelect,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              'هەڵبژاردنی باب',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cs.textSecondary,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final cat = categories[i];
                final grad = gradientFn(i);
                final icon = iconFn(i);
                final totalRules = cat.rules.length;
                final activeCount = cat.rules
                    .where((r) => !inactiveRules.contains(r.slug))
                    .length;

                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: grad,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: grad.first.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: Colors.white, size: 22),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: activeCount == totalRules
                                    ? Colors.white.withValues(alpha: 0.22)
                                    : Colors.orange.withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                activeCount == totalRules
                                    ? 'هەموو چالاکن'
                                    : '$activeCount/$totalRules',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          cat.nameKu,
                          textDirection: TextDirection.rtl,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        if (cat.nameAr != null && cat.nameAr!.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            cat.nameAr!,
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$totalRules یاسا',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white54,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(delay: (i * 40).ms)
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
              },
              childCount: categories.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.05,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rules List for a single category
// ─────────────────────────────────────────────────────────────────────────────

class _RulesList extends StatefulWidget {
  final TajweedCategoryModel category;
  final Set<String> inactiveRules;
  final List<Color> gradient;
  final IconData icon;
  final AppColorScheme cs;
  final bool isDark;
  final void Function(String slug, bool currentlyActive) onToggle;

  const _RulesList({
    super.key,
    required this.category,
    required this.inactiveRules,
    required this.gradient,
    required this.icon,
    required this.cs,
    required this.isDark,
    required this.onToggle,
  });

  @override
  State<_RulesList> createState() => _RulesListState();
}

class _RulesListState extends State<_RulesList> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final rules = List<TajweedRuleModel>.from(widget.category.rules)
      ..sort((a, b) => a.priority.compareTo(b.priority));

    return Column(
      children: [
        // ── Category banner ─────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.category.nameAr != null)
                      Text(
                        widget.category.nameAr!,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    Text(
                      '${rules.length} یاسا لەم بابەتەدا',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.68),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Rules list ───────────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            physics: const BouncingScrollPhysics(),
            itemCount: rules.length,
            itemBuilder: (context, i) {
              final rule = rules[i];
              final isActive = !widget.inactiveRules.contains(rule.slug);
              final isExpanded = _expandedIndex == i;
              final accent = _parseColor(rule.colorCode) ?? widget.gradient.first;

              return _RuleCard(
                rule: rule,
                isActive: isActive,
                isExpanded: isExpanded,
                accentColor: accent,
                onTap: () =>
                    setState(() => _expandedIndex = isExpanded ? null : i),
                onToggle: () => widget.onToggle(rule.slug, isActive),
                cs: widget.cs,
              )
                  .animate(delay: (i * 35).ms)
                  .fadeIn(duration: 250.ms)
                  .slideX(begin: 0.04, end: 0, duration: 250.ms);
            },
          ),
        ),
      ],
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final buf = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buf.write('ff');
      buf.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buf.toString(), radix: 16));
    } catch (_) {
      return null;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single Rule Card (expandable)
// ─────────────────────────────────────────────────────────────────────────────

class _RuleCard extends StatelessWidget {
  final TajweedRuleModel rule;
  final bool isActive;
  final bool isExpanded;
  final Color accentColor;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final AppColorScheme cs;

  const _RuleCard({
    required this.rule,
    required this.isActive,
    required this.isExpanded,
    required this.accentColor,
    required this.onTap,
    required this.onToggle,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isExpanded
                ? accentColor.withValues(alpha: 0.5)
                : cs.cardBorder,
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: isExpanded
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.1),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        // Color dot
                        Container(
                          width: 13,
                          height: 13,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: isActive
                                ? accentColor
                                : accentColor.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: accentColor.withValues(alpha: 0.4),
                                      blurRadius: 5,
                                    )
                                  ]
                                : [],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                rule.nameKu,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isActive
                                      ? cs.textPrimary
                                      : cs.textSecondary,
                                ),
                              ),
                              if (rule.nameAr != null &&
                                  rule.nameAr!.isNotEmpty)
                                Text(
                                  rule.nameAr!,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    color: cs.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: isActive,
                    activeThumbColor: accentColor,
                    activeTrackColor: accentColor.withValues(alpha: 0.25),
                    inactiveThumbColor: cs.textSecondary.withValues(alpha: 0.4),
                    inactiveTrackColor: cs.cardBorder,
                    onChanged: (_) => onToggle(),
                  ),
                ],
              ),
            ),

            // Expanded detail
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Divider(color: cs.cardBorder),
                    const SizedBox(height: 4),
                    if (rule.descriptionKu.isNotEmpty)
                      Text(
                        rule.descriptionKu,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          height: 1.7,
                          color: cs.textSecondary,
                        ),
                      ),
                    if (rule.exampleText != null &&
                        rule.exampleText!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: accentColor.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'نموونە',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              rule.exampleText!,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'UthmanicHafs',
                                fontSize: 20,
                                height: 2.0,
                                color: isActive ? accentColor : cs.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (!isActive) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          textDirection: TextDirection.rtl,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 14, color: Colors.orange),
                            SizedBox(width: 6),
                            Text(
                              'ئەم یاسایە لە خوێندنەوەی تەجوید ناچالاکە',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: 200.ms,
            ),
          ],
        ),
      ),
    );
  }
}
