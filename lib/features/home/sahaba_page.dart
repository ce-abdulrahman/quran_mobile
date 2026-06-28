import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:isar/isar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/providers/favorites_provider.dart';

final sahabaProvider = FutureProvider<List<SahabaCollection>>((ref) async {
  final isar = IsarService.instance.isar;
  return isar.sahabaCollections.where().sortBySahabaId().findAll();
});

class SahabaPage extends ConsumerWidget {
  const SahabaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final sahabaAsync = ref.watch(sahabaProvider);
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
          l.sahabaTitle,
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
                  '﴿ مِّنَ الْمُؤْمِنِينَ رِجَالٌ صَدَقُوا مَا عَاهَدُوا اللَّهَ عَلَيْهِ ﴾',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.sahabaSub,
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
            child: sahabaAsync.when(
              data: (companions) {
                if (companions.isEmpty) {
                  return Center(
                    child: Text(
                      l.sahabaNoSahabaFound,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: companions.length,
                  itemBuilder: (context, index) {
                    final companion = companions[index];
                    final isFav = ref.read(favoritesProvider.notifier).isFavorited('sahaba', companion.sahabaId);
                    return _buildCompanionCard(context, ref, companion, isFav, cs);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text(
                  '${context.l10n.namesOfAllahError} $err',
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanionCard(
    BuildContext context,
    WidgetRef ref,
    SahabaCollection companion,
    bool isFav,
    AppColorScheme cs,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageCode = Localizations.localeOf(context).languageCode;
    final isRtl = languageCode == 'ku' || languageCode == 'ar';

    final favBtn = IconButton(
      icon: Icon(
        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFav ? Colors.red : cs.textSecondary.withValues(alpha: 0.3),
      ),
      onPressed: () async {
        await ref.read(favoritesProvider.notifier).toggleGeneric(
          favoritableType: 'sahaba',
          favoritableId: companion.sahabaId,
          previewText: companion.nameKu,
        );
      },
    );

    final textInfo = Expanded(
      child: Column(
        crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            companion.nameKu,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cs.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            companion.epithetKu,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            companion.summaryKu,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: cs.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );

    final badge = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${companion.sahabaId}',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: cs.primary,
          fontSize: 14,
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? cs.card : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openCompanionReader(context, ref, companion, cs),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: isRtl
                    ? [
                        favBtn,
                        const SizedBox(width: 8),
                        textInfo,
                        const SizedBox(width: 16),
                        badge,
                      ]
                    : [
                        badge,
                        const SizedBox(width: 16),
                        textInfo,
                        const SizedBox(width: 8),
                        favBtn,
                      ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms, delay: Duration(milliseconds: 30 * companion.sahabaId));
  }

  void _openCompanionReader(
    BuildContext context,
    WidgetRef ref,
    SahabaCollection companion,
    AppColorScheme cs,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CompanionReaderPage(companion: companion, cs: cs),
      ),
    );
  }
}

class _CompanionReaderPage extends ConsumerStatefulWidget {
  final SahabaCollection companion;
  final AppColorScheme cs;

  const _CompanionReaderPage({required this.companion, required this.cs});

  @override
  ConsumerState<_CompanionReaderPage> createState() => _CompanionReaderPageState();
}

class _CompanionReaderPageState extends ConsumerState<_CompanionReaderPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = ref.watch(favoritesProvider.notifier).isFavorited('sahaba', widget.companion.sahabaId);
    final languageCode = Localizations.localeOf(context).languageCode;
    final isRtl = languageCode == 'ku' || languageCode == 'ar';
    final textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;

    return Scaffold(
      backgroundColor: widget.cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(widget.cs.primary, 0.35) : widget.cs.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.companion.nameKu,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              await ref.read(favoritesProvider.notifier).toggleGeneric(
                favoritableType: 'sahaba',
                favoritableId: widget.companion.sahabaId,
                previewText: widget.companion.nameKu,
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: textDirection,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Epithet and arabic name card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? widget.cs.card : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.cs.primary.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.companion.nameAr,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.companion.epithetKu,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Biography Render
              MarkdownBody(
                data: widget.companion.biographyMd,
                styleSheet: MarkdownStyleSheet(
                  h1: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.cs.primary,
                    height: 1.6,
                  ),
                  h2: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: widget.cs.primaryDeep,
                    height: 1.5,
                  ),
                  h3: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: widget.cs.textPrimary,
                    height: 1.4,
                  ),
                  p: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    height: 1.7,
                    color: widget.cs.textPrimary,
                  ),
                  listBullet: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: widget.cs.primary,
                  ),
                ),
              ),
  
              // Virtues Section
              if (widget.companion.virtuesKu.isNotEmpty) ...[
                const Divider(height: 32),
                Text(
                  context.l10n.sahabaVirtuesTitle,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: widget.cs.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6A23C).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE6A23C).withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    widget.companion.virtuesKu,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
