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

final seerahProvider = FutureProvider<List<SeerahCollection>>((ref) async {
  final isar = IsarService.instance.isar;
  return isar.seerahCollections.where().sortBySeerahId().findAll();
});

class SeerahPage extends ConsumerWidget {
  const SeerahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final seerahAsync = ref.watch(seerahProvider);
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
          l.seerahTitle,
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
                  '﴿ لَقَدْ كَانَ لَكُمْ فِي رَسُولِ اللَّهِ أُسْوَةٌ حَسَنَةٌ ﴾',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l.seerahSub,
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
            child: seerahAsync.when(
              data: (chapters) {
                if (chapters.isEmpty) {
                  return Center(
                    child: Text(
                      l.seerahNoChaptersFound,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  physics: const BouncingScrollPhysics(),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    final isFav = ref.read(favoritesProvider.notifier).isFavorited('seerah', chapter.seerahId);
                    final isLast = index == chapters.length - 1;
                    return _buildTimelineItem(context, ref, chapter, index, isFav, isLast, cs);
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

  Widget _buildTimelineItem(
    BuildContext context,
    WidgetRef ref,
    SeerahCollection chapter,
    int index,
    bool isFav,
    bool isLast,
    AppColorScheme cs,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageCode = Localizations.localeOf(context).languageCode;
    final isRtl = languageCode == 'ku' || languageCode == 'ar';

    final content = Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: GestureDetector(
          onTap: () => _openReader(context, ref, chapter, cs),
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: isRtl
                      ? [
                          Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFav ? Colors.red : cs.textSecondary.withValues(alpha: 0.2),
                            size: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              chapter.period,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          ),
                        ]
                      : [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              chapter.period,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          ),
                          Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFav ? Colors.red : cs.textSecondary.withValues(alpha: 0.2),
                            size: 16,
                          ),
                        ],
                ),
                const SizedBox(height: 8),
                Text(
                  chapter.titleKu,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chapter.titleAr,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 13,
                    color: cs.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final timeline = Column(
      children: [
        // Dot
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: cs.bg,
            shape: BoxShape.circle,
            border: Border.all(color: cs.primary, width: 3),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Line
        if (!isLast)
          Expanded(
            child: Container(
              width: 3,
              color: cs.primary.withValues(alpha: 0.25),
            ),
          ),
      ],
    );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: isRtl
            ? [content, const SizedBox(width: 16), timeline]
            : [timeline, const SizedBox(width: 16), content],
      ),
    ).animate().slideY(begin: 0.2, end: 0, duration: 250.ms, curve: Curves.easeOut);
  }

  void _openReader(
    BuildContext context,
    WidgetRef ref,
    SeerahCollection chapter,
    AppColorScheme cs,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _SeerahReaderPage(chapter: chapter, cs: cs),
      ),
    );
  }
}

class _SeerahReaderPage extends ConsumerStatefulWidget {
  final SeerahCollection chapter;
  final AppColorScheme cs;

  const _SeerahReaderPage({required this.chapter, required this.cs});

  @override
  ConsumerState<_SeerahReaderPage> createState() => _SeerahReaderPageState();
}

class _SeerahReaderPageState extends ConsumerState<_SeerahReaderPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = ref.watch(favoritesProvider.notifier).isFavorited('seerah', widget.chapter.seerahId);
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
          widget.chapter.titleKu,
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
                favoritableType: 'seerah',
                favoritableId: widget.chapter.seerahId,
                previewText: widget.chapter.titleKu,
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: textDirection,
        child: Markdown(
          data: widget.chapter.contentMd,
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: widget.cs.primary,
              height: 1.6,
            ),
            h2: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.cs.primaryDeep,
              height: 1.5,
            ),
            h3: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
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
            blockquote: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: widget.cs.textSecondary,
            ),
            blockquoteDecoration: BoxDecoration(
              color: widget.cs.textSecondary.withValues(alpha: 0.05),
              border: Border(
                left: isRtl ? BorderSide.none : BorderSide(color: widget.cs.primary, width: 4),
                right: isRtl ? BorderSide(color: widget.cs.primary, width: 4) : BorderSide.none,
              ),
            ),
            code: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              backgroundColor: Colors.transparent,
            ),
          codeblockPadding: const EdgeInsets.all(12),
          codeblockDecoration: BoxDecoration(
            color: widget.cs.textSecondary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: widget.cs.textSecondary.withValues(alpha: 0.1)),
          ),
        ),
      ),
    ),
  );
}
}
