import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import 'adhkar_category_page.dart';

class AdhkarPage extends ConsumerWidget {
  const AdhkarPage({super.key});

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'wb_sunny_rounded':
        return Icons.wb_sunny_rounded;
      case 'dark_mode_outlined':
        return Icons.nights_stay_rounded; // Better dark/evening representation
      case 'mosque_rounded':
        return Icons.mosque_rounded;
      case 'bed_rounded':
        return Icons.bed_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  Color _getIconColor(String? iconName) {
    switch (iconName) {
      case 'wb_sunny_rounded':
        return const Color(0xFFFF9800);
      case 'dark_mode_outlined':
        return const Color(0xFFE65100);
      case 'mosque_rounded':
        return const Color(0xFF4CAF50);
      case 'bed_rounded':
        return const Color(0xFF673AB7);
      default:
        return const Color(0xFF1AB66D);
    }
  }

  List<Color> _getBgGradient(String? iconName) {
    switch (iconName) {
      case 'wb_sunny_rounded':
        return const [Color(0xFFFFB74D), Color(0xFFF57C00)];
      case 'dark_mode_outlined':
        return const [Color(0xFFFF8A65), Color(0xFFD84315)];
      case 'mosque_rounded':
        return const [Color(0xFF81C784), Color(0xFF2E7D32)];
      case 'bed_rounded':
        return const [Color(0xFF9575CD), Color(0xFF4527A0)];
      default:
        return const [Color(0xFF66BB6A), Color(0xFF2E7D32)];
    }
  }

  String _getSubtitle(int categoryId, String nameKu) {
    switch (categoryId) {
      case 1:
        return 'شایستەیە دوای نوێژی بەیانی تا هەڵاتنی خۆر بخوێندرێت';
      case 2:
        return 'شایستەیە دوای نوێژی عەسڕ تا ئاوابوونی خۆر بخوێندرێت';
      case 3:
        return 'تەسبیحات و دوعاکانی دوای تەواوبوونی نوێژە فەرزەکان';
      case 4:
        return 'بۆ پاراستنی موسڵمان لە شەودا پێش نوستن دەخوێندرێن';
      default:
        return 'پاڕانەوە و یادکردنەوەکانی خودای گەورە';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // We watch the adhkarProvider to automatically redraw when any category is completed
    ref.watch(adhkarProvider);
    final notifier = ref.read(adhkarProvider.notifier);
    final categoriesAsync = ref.watch(adhkarCategoriesFutureProvider);

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
        title: Text(
          l.adhkarTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => ref.refresh(adhkarCategoriesFutureProvider),
            tooltip: 'نوێکردنەوە',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adhkarCategoriesFutureProvider);
          await ref.read(adhkarCategoriesFutureProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColorScheme.darken(cs.primary, 0.35),
                            AppColorScheme.darken(cs.primary, 0.45)
                          ]
                        : [cs.primary, cs.primaryDeep],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
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
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '🌅',
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                      style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'بەرنامەی زیکر و وەردەکانت بۆ هێورکردنەوەی دڵت',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Checklist List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: categoriesAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Color(0xFFE53935), size: 48),
                          const SizedBox(height: 16),
                          const Text(
                            'سەرکەوتوو نەبوو لە بارکردنی ئەزکارەکان',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'دڵنیابەوە لە هێڵی ئینتەرنێتەکەت یان سێرڤەر',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              color: cs.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => ref.refresh(adhkarCategoriesFutureProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text(
                              'دووبارە هەوڵبدەرەوە',
                              style: TextStyle(fontFamily: 'Cairo', fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (categories) {
                    if (categories.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Text(
                            'هیچ هاوپۆلێک نەدۆزرایەوە',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: cs.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, i) {
                        final cat = categories[i];
                        final catKey = cat.id.toString();
                        final done = notifier.isCompletedToday(catKey);

                        final icon = _getIconData(cat.icon);
                        final iconColor = _getIconColor(cat.icon);
                        final bgGradient = _getBgGradient(cat.icon);
                        final subtitle = _getSubtitle(cat.id, cat.nameKu);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdhkarCategoryPage(
                                  categoryKey: catKey,
                                  title: cat.nameKu,
                                  items: cat.adhkars,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cs.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: done
                                    ? const Color(0xFF0F8F4C).withValues(alpha: 0.3)
                                    : cs.cardBorder,
                                width: done ? 1.5 : 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Category Decorated Icon
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: bgGradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: iconColor.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(icon, color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 14),

                                // Text Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cat.nameKu,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: cs.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 10,
                                          color: cs.textSecondary,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Status Badge
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: done
                                            ? const Color(0xFF0F8F4C).withValues(alpha: 0.12)
                                            : const Color(0xFFE6A23C).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        done ? l.adhkarTodayCompleted : l.adhkarTodayPending,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: done ? const Color(0xFF0F8F4C) : const Color(0xFFE6A23C),
                                        ),
                                      ),
                                    ),
                                    if (done) ...[
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              notifier.resetCategory(catKey);
                                            },
                                            child: Text(
                                              l.adhkarResetProgress,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 9,
                                                color: cs.primary,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(
                              duration: 350.ms,
                              delay: Duration(milliseconds: 60 * i),
                            );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
