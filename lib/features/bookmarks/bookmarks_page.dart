import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/bookmarks_provider.dart';
import '../quran/quran_reader_page.dart';
import '../quran/mushaf_reader_page.dart';
import '../quran/quran_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Bookmarks Page
// ─────────────────────────────────────────────────────────────────────────────

class BookmarksPage extends ConsumerWidget {
  final bool showBackButton;
  const BookmarksPage({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isKu = Localizations.localeOf(context).languageCode == 'ku';
    
    final bookmarks = ref.watch(bookmarksProvider).reversed.toList();
    final pageBookmarks = ref.watch(pageBookmarksProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.bg,
        appBar: AppBar(
          backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
          elevation: 0,
          centerTitle: true,
          leading: showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          title: Text(
            l.bookmarksTitle,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.accentGoldDeep,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
            labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: isKu ? 'ئایەتەکان' : 'Ayahs'),
              Tab(text: isKu ? 'لاپەڕەکان' : 'Pages'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ── Tab 1: Ayah Bookmarks ──────────────────────────────
            bookmarks.isEmpty
                ? _EmptyBookmarks(cs: cs, l: l)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    physics: const BouncingScrollPhysics(),
                    itemCount: bookmarks.length,
                    itemBuilder: (_, i) => _BookmarkCard(
                      bookmark: bookmarks[i],
                      cs: cs,
                    ).animate().fadeIn(
                          duration: 250.ms,
                          delay: Duration(milliseconds: 40 * i),
                        ),
                  ),

            // ── Tab 2: Page Bookmarks ──────────────────────────────
            pageBookmarks.isEmpty
                ? _EmptyBookmarks(cs: cs, l: l)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    physics: const BouncingScrollPhysics(),
                    itemCount: pageBookmarks.length,
                    itemBuilder: (_, i) {
                      final pageNum = pageBookmarks[i];
                      return _PageBookmarkCard(
                        pageNumber: pageNum,
                        cs: cs,
                        isKu: isKu,
                      ).animate().fadeIn(
                            duration: 250.ms,
                            delay: Duration(milliseconds: 40 * i),
                          );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks({required this.cs, required this.l});
  final AppColorScheme cs;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: cs.primary.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.bookmark_border_rounded,
              size: 52,
              color: cs.primary,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 2000.ms,
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: 28),

          Text(
            l.bookmarksEmpty,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: cs.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              l.bookmarksEmptySub,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: cs.textSecondary,
                height: 1.6,
              ),
            ),
          ),

          const SizedBox(height: 32),

          Text(
            '﴾ ٱقۡرَأۡ بِٱسۡمِ رَبِّكَ ﴿',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'UthmanicHafs',
              fontSize: 18,
              color: cs.primary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bookmark Card
// ─────────────────────────────────────────────────────────────────────────────

class _BookmarkCard extends ConsumerWidget {
  const _BookmarkCard({required this.bookmark, required this.cs});
  final LocalBookmark bookmark;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final surahListAsync = ref.read(surahListProvider);
        surahListAsync.whenData((surahs) {
          try {
            final matchedSurah =
                surahs.firstWhere((s) => s.id == bookmark.surahId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuranReaderPage(
                  surah: matchedSurah,
                  initialAyahNumber: bookmark.ayahNumber,
                ),
              ),
            );
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.l10n.bookmarkSurahNotFoundError,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGoldDeep.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bookmark_rounded,
                color: AppColors.accentGoldDeep,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bookmark.surahName,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: cs.textPrimary,
                        ),
                      ),
                      Text(
                        context.l10n.audioAyahNumber(bookmark.ayahNumber),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bookmark.preview,
                    textDirection: TextDirection.rtl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 16,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.withValues(alpha: 0.8),
                size: 20,
              ),
              onPressed: () {
                ref.read(bookmarksProvider.notifier).toggle(bookmark);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PageBookmarkCard extends ConsumerWidget {
  const _PageBookmarkCard({
    required this.pageNumber,
    required this.cs,
    required this.isKu,
  });

  final int pageNumber;
  final AppColorScheme cs;
  final bool isKu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MushafReaderPage(initialPage: pageNumber),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: cs.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isKu ? 'لاپەڕەی $pageNumber' : 'Page $pageNumber',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isKu ? 'خوێندنەوەی لاپەڕە لە موسحەف' : 'Read page in Mushaf',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red.withValues(alpha: 0.8),
                size: 20,
              ),
              onPressed: () {
                ref.read(pageBookmarksProvider.notifier).toggle(pageNumber);
              },
            ),
          ],
        ),
      ),
    );
  }
}
