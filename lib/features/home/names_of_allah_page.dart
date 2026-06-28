import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:isar/isar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/providers/favorites_provider.dart';

final namesOfAllahProvider = FutureProvider<List<NamesOfAllahCollection>>((ref) async {
  final isar = IsarService.instance.isar;
  return isar.namesOfAllahCollections.where().sortByNameId().findAll();
});

class NamesOfAllahPage extends ConsumerWidget {
  const NamesOfAllahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final namesAsync = ref.watch(namesOfAllahProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;

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
          l.namesOfAllahTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Banner header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
            child: Column(
              children: [
                const Text(
                  '﴿ وَلِلَّهِ الْأَسْمَاءُ الْحُسْنَىٰ فَادْعُوهُ بِهَا ﴾',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.namesOfAllahSub,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: namesAsync.when(
              data: (names) {
                if (names.isEmpty) {
                  return Center(
                    child: Text(
                      l.namesOfAllahNoNamesFound,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    final name = names[index];
                    final isFav = ref.read(favoritesProvider.notifier).isFavorited('name_of_allah', name.nameId);
                    return _buildNameCard(context, ref, name, isFav, cs);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text(
                  '${l.namesOfAllahError} $err',
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameCard(
    BuildContext context,
    WidgetRef ref,
    NamesOfAllahCollection name,
    bool isFav,
    AppColorScheme cs,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _showDetailsSheet(context, ref, name, cs),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? cs.card : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cs.primary.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            // Top Right Circle Badge with Number
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${name.nameId}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
            ),
            // Heart toggle indicator
            Positioned(
              top: 6,
              left: 6,
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.red : cs.textSecondary.withValues(alpha: 0.3),
                size: 18,
              ),
            ),
            
            // Name texts
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    name.nameAr,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name.nameKu,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cs.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(delay: Duration(milliseconds: 15 * name.nameId), duration: 200.ms);
  }

  void _showDetailsSheet(
    BuildContext context,
    WidgetRef ref,
    NamesOfAllahCollection name,
    AppColorScheme cs,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isFav = ref.watch(favoritesProvider.notifier).isFavorited('name_of_allah', name.nameId);
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle line
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: cs.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Card header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Favorite button
                        IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFav ? Colors.red : cs.textSecondary,
                            size: 28,
                          ),
                          onPressed: () async {
                            await ref.read(favoritesProvider.notifier).toggleGeneric(
                              favoritableType: 'name_of_allah',
                              favoritableId: name.nameId,
                              previewText: '${name.nameAr} - ${name.nameKu}',
                            );
                            setModalState(() {});
                          },
                        ),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                name.nameAr,
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                name.nameKu,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const Divider(height: 32),
                    
                    // Arabic verse
                    _buildDetailSection(
                      context,
                      cs,
                      title: context.l10n.namesOfAllahVerseAr,
                      content: name.verseAr,
                      fontFamily: 'AmiriQuran',
                      fontSize: 18,
                      alignment: TextAlign.right,
                    ),
                    const SizedBox(height: 16),

                    // Kurdish verse
                    _buildDetailSection(
                      context,
                      cs,
                      title: context.l10n.namesOfAllahVerseKu,
                      content: name.verseKu,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      alignment: TextAlign.right,
                    ),
                    const SizedBox(height: 16),

                    // Meaning details
                    _buildDetailSection(
                      context,
                      cs,
                      title: context.l10n.namesOfAllahMeaningKu,
                      content: name.meaningKu,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      alignment: TextAlign.right,
                    ),
                    const SizedBox(height: 16),

                    _buildDetailSection(
                      context,
                      cs,
                      title: context.l10n.namesOfAllahMeaningEn,
                      content: name.meaningEn,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      alignment: TextAlign.left,
                    ),
                    const SizedBox(height: 16),

                    // Virtue
                    _buildDetailSection(
                      context,
                      cs,
                      title: context.l10n.namesOfAllahVirtueKu,
                      content: name.virtueKu,
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      alignment: TextAlign.right,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    AppColorScheme cs, {
    required String title,
    required String content,
    required String fontFamily,
    required double fontSize,
    required TextAlign alignment,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.textSecondary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.textSecondary.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: alignment == TextAlign.right
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: alignment,
            textDirection: alignment == TextAlign.right
                ? TextDirection.rtl
                : TextDirection.ltr,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
