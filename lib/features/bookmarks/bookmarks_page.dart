import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
import '../quran/quran_providers.dart';
import '../quran/reader/reader_page.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final bookmarkedAyahsAsync = ref.watch(bookmarkedAyahsStreamProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Text(
                    l.bookmarksTitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            Expanded(
              child: bookmarkedAyahsAsync.when(
                data: (bookmarkedList) {
                  if (bookmarkedList.isEmpty) {
                    return _EmptyBookmarks(cs: cs);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: bookmarkedList.length,
                    itemBuilder: (context, i) {
                      final item = bookmarkedList[i];
                      return _BookmarkedAyahCard(
                        item: item,
                        cs: cs,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReaderPage(
                                surah: item.surah,
                                initialAyahNumber: item.ayah.ayahNumber,
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          HapticFeedback.mediumImpact();
                          ref.read(quranBookmarkNotifierProvider).deleteBookmark(item.bookmark.id);
                        },
                      ).animate().fadeIn(duration: 300.ms, delay: (i * 40).ms);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text(
                    l.commonErrorLoading,
                    style: TextStyle(fontFamily: 'Cairo', color: cs.textPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkedAyahCard extends ConsumerWidget {
  const _BookmarkedAyahCard({
    required this.item,
    required this.cs,
    required this.onTap,
    required this.onDelete,
  });

  final BookmarkedAyah item;
  final AppColorScheme cs;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showKurdish = ref.watch(showKurdishTranslationProvider);
    final showEnglish = ref.watch(showEnglishTranslationProvider);
    final baseFontSize = ref.watch(fontSizeProvider);
    final l = context.l10n;
    final lang = ref.watch(localeProvider).languageCode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Surah Name + Ayah Number and Delete Button
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    lang == 'en'
                        ? '${item.surah.nameEn} - ${l.commonAyah} ${item.ayah.ayahNumber}'
                        : lang == 'ku'
                            ? '${item.surah.nameKu ?? item.surah.nameAr} - ${l.commonAyah} ${item.ayah.ayahNumber}'
                            : '${item.surah.nameAr} - ${l.commonAyah} ${item.ayah.ayahNumber}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  lang == 'en' ? item.surah.nameAr : item.surah.nameEn,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: cs.textSecondary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Arabic Text
            Text(
              item.ayah.textUthmani,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: (baseFontSize * 0.75).clamp(16.0, 28.0),
                height: 1.6,
                color: cs.textPrimary,
              ),
            ),
            // Kurdish translation
            if (showKurdish && item.ayah.textKu != null && item.ayah.textKu!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                item.ayah.textKu!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: (baseFontSize * 0.55).clamp(11.0, 22.0),
                  height: 1.5,
                  color: cs.textPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
            // English translation
            if (showEnglish && item.ayah.textEn != null && item.ayah.textEn!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                item.ayah.textEn!,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: (baseFontSize * 0.50).clamp(10.0, 20.0),
                  height: 1.4,
                  color: cs.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks({required this.cs});
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: cs.card,
              shape: BoxShape.circle,
              border: Border.all(color: cs.cardBorder, width: 2),
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 48,
              color: AppColors.accentGold.withValues(alpha: 0.7),
            ),
          ).animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.7, 0.7), duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            l.bookmarksEmpty,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: cs.textPrimary,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l.bookmarksEmptyDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: cs.textSecondary,
                height: 1.6,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
        ],
      ),
    );
  }
}
