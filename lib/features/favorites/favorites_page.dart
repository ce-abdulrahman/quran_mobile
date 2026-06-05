import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../quran/quran_reader_page.dart';
import '../quran/quran_providers.dart';
import '../quran/widgets/share_card_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Favorites Page
// ─────────────────────────────────────────────────────────────────────────────

class FavoritesPage extends ConsumerWidget {
  final bool showBackButton;
  const FavoritesPage({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Sort so that the newest favorites (last added) appear at the top
    final favorites = ref.watch(favoritesProvider).reversed.toList();
    final readerSettings = ref.watch(readerSettingsProvider);

    return Scaffold(
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
          l.favoritesTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Header Banner ──
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFE6A23C), size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${favorites.length} ${favorites.length == 1 ? 'دڵخواز' : 'دڵخوازەکان'}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Content ──
          Expanded(
            child: favorites.isEmpty
                ? _EmptyFavorites(cs: cs, l: l)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    physics: const BouncingScrollPhysics(),
                    itemCount: favorites.length,
                    itemBuilder: (_, i) => _FavoriteCard(
                      favorite: favorites[i],
                      readerSettings: readerSettings,
                      cs: cs,
                    ).animate().fadeIn(
                          duration: 250.ms,
                          delay: Duration(milliseconds: 40 * i),
                        ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State Widget
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites({required this.cs, required this.l});
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
              color: const Color(0xFFE6A23C).withValues(alpha: 0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFE6A23C).withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.star_border_rounded,
              size: 52,
              color: Color(0xFFE6A23C),
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
            l.favoritesEmpty,
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
              l.favoritesEmptySub,
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
            '﴾ فَٱذْكُرُونِي أَذْكُرْكُمْ ﴿',
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
// Favorite Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _FavoriteCard extends ConsumerWidget {
  const _FavoriteCard({
    required this.favorite,
    required this.readerSettings,
    required this.cs,
  });

  final LocalFavorite favorite;
  final ReaderSettings readerSettings;
  final AppColorScheme cs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final surahListAsync = ref.read(surahListProvider);
        surahListAsync.whenData((surahs) {
          try {
            final matchedSurah =
                surahs.firstWhere((s) => s.id == favorite.surahId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuranReaderPage(
                  surah: matchedSurah,
                  initialAyahNumber: favorite.ayahNumber,
                ),
              ),
            );
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'ناتوانرێت سورەتەکە بدۆزرێتەوە لە لیستەکەدا',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Surah Info + Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6A23C).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE6A23C).withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFE6A23C),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${favorite.surahName} - ئایەتی ${favorite.ayahNumber}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: cs.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFE6A23C),
                        size: 18,
                      ),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggle(favorite);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'ئایەتەکە لە دڵخوازەکان لادرا',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: Icon(Icons.content_copy_rounded, size: 16, color: cs.textSecondary),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: favorite.textUthmani));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'ئایەتەکە لەبەرگیرا',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: Icon(Icons.share_rounded, size: 16, color: cs.textSecondary),
                      onPressed: () {
                        showShareCardSheet(
                          context,
                          ShareAyahData.fromLocalFavorite(favorite),
                        );
                      },
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Arabic Text
            Text(
              favorite.textUthmani,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: readerSettings.fontSize + 2,
                height: 1.8,
                color: cs.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            // Kurdish translation
            if (readerSettings.showKurdish == true && favorite.textKu != null && favorite.textKu!.isNotEmpty) ...[
              Text(
                favorite.textKu!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: readerSettings.fontSize - 2,
                  height: 1.5,
                  color: cs.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
            ],

            // English translation
            if (readerSettings.showEnglish == true && favorite.textEn != null && favorite.textEn!.isNotEmpty) ...[
              Text(
                favorite.textEn!,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: readerSettings.fontSize - 3,
                  height: 1.4,
                  color: cs.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
