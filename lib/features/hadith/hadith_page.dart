import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import 'hadith_category_page.dart';

class HadithPage extends ConsumerStatefulWidget {
  const HadithPage({super.key});

  @override
  ConsumerState<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends ConsumerState<HadithPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'favorite_rounded':
        return Icons.favorite_rounded;
      case 'mosque_rounded':
        return Icons.mosque_rounded;
      case 'shield_rounded':
        return Icons.shield_rounded;
      case 'library_books_rounded':
        return Icons.library_books_rounded;
      case 'menu_book_rounded':
        return Icons.menu_book_rounded;
      case 'star_rounded':
        return Icons.star_rounded;
      default:
        return Icons.auto_stories_rounded;
    }
  }

  Color _getIconColor(String? iconName) {
    switch (iconName) {
      case 'favorite_rounded':
        return const Color(0xFFE53935);
      case 'mosque_rounded':
        return const Color(0xFF4CAF50);
      case 'shield_rounded':
        return const Color(0xFF1E88E5);
      case 'library_books_rounded':
        return const Color(0xFFFFB300);
      default:
        return const Color(0xFF1AB66D);
    }
  }

  List<Color> _getBgGradient(String? iconName) {
    switch (iconName) {
      case 'favorite_rounded':
        return const [Color(0xFFEF5350), Color(0xFFC62828)];
      case 'mosque_rounded':
        return const [Color(0xFF81C784), Color(0xFF2E7D32)];
      case 'shield_rounded':
        return const [Color(0xFF64B5F6), Color(0xFF1565C0)];
      case 'library_books_rounded':
        return const [Color(0xFFFFD54F), Color(0xFFFF8F00)];
      default:
        return const [Color(0xFF66BB6A), Color(0xFF2E7D32)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categoriesAsync = ref.watch(hadithCategoriesFutureProvider);

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
        title: _isSearching
            ? TextField(
                controller: _searchCtrl,
                textDirection: TextDirection.rtl,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontFamily: 'Cairo', fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'بگەڕێ لە فەرموودەکان...',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                  hintTextDirection: TextDirection.rtl,
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    _query = val.trim();
                  });
                },
              )
            : const Text(
                'فەرموودەکانی پێغەمبەر',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchCtrl.clear();
                  _query = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: () => ref.refresh(hadithCategoriesFutureProvider),
              tooltip: 'تازەکردنەوە',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(hadithCategoriesFutureProvider);
          await ref.read(hadithCategoriesFutureProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Header Banner (only show when not actively searching)
              if (!_isSearching)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
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
                        width: 72,
                        height: 72,
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
                            '📖',
                            style: TextStyle(fontSize: 36),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'مَنْ يُطِعِ الرَّسُولَ فَقَدْ أَطَاعَ اللَّهَ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'UthmanicHafs',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'فەرموودە ڕاستەکانی پێغەمبەری خودا (د.خ)',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Categories or Search Results
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
                            'سەرکەوتوو نەبوو لە بارکردنی فەرموودەکان',
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
                            onPressed: () => ref.refresh(hadithCategoriesFutureProvider),
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

                    // Active Search Results View
                    if (_query.isNotEmpty) {
                      final lowercaseQuery = _query.toLowerCase();
                      final results = categories.expand((cat) => cat.hadiths).where((h) {
                        final inArText = h.arabicText.toLowerCase().contains(lowercaseQuery);
                        final inKuTrans = h.translationKu.toLowerCase().contains(lowercaseQuery);
                        final inEnTrans = h.translationEn?.toLowerCase().contains(lowercaseQuery) ?? false;
                        final inKuExpl = h.explanationKu?.toLowerCase().contains(lowercaseQuery) ?? false;
                        final inEnExpl = h.explanationEn?.toLowerCase().contains(lowercaseQuery) ?? false;
                        final inSource = h.source?.toLowerCase().contains(lowercaseQuery) ?? false;
                        return inArText || inKuTrans || inEnTrans || inKuExpl || inEnExpl || inSource;
                      }).toList();

                      if (results.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 80),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off_rounded, size: 48, color: Colors.redAccent),
                                const SizedBox(height: 16),
                                Text(
                                  'هیچ ئەنجامێک نەدۆزرایەوە بۆ "$_query"',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    color: cs.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final hadith = results[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: HadithCard(hadith: hadith, cs: cs),
                          );
                        },
                      );
                    }

                    // Default Category Tiles List View
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: cs.card,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: cs.cardBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HadithCategoryPage(category: cat),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Icon Box
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: _getBgGradient(cat.icon),
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getIconColor(cat.icon).withValues(alpha: 0.25),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        _getIconData(cat.icon),
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Names
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cat.nameKu,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: cs.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            cat.nameAr,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: cs.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Count Badge & Arrow
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: cs.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${cat.hadiths.length} فەرموودە',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: cs.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: cs.textSecondary.withValues(alpha: 0.5),
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).animate(delay: (index * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
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
