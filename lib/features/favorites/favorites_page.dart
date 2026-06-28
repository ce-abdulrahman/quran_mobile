import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/providers/app_providers.dart';
import '../../core/local_db/isar_service.dart';
import '../../core/local_db/isar_collections.dart';
import '../../core/providers/favorites_provider.dart';
import '../quran/quran_reader_page.dart';
import '../quran/quran_providers.dart';
import '../home/names_of_allah_page.dart';
import '../home/seerah_page.dart';
import '../home/sahaba_page.dart';

class FavoritesPage extends ConsumerWidget {
  final bool showBackButton;
  const FavoritesPage({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final allFavorites = ref.watch(favoritesProvider);

    final ayahs = allFavorites.where((f) => f.favoritableType == 'ayah').toList();
    final hadiths = allFavorites.where((f) => f.favoritableType == 'hadith').toList();
    final names = allFavorites.where((f) => f.favoritableType == 'name_of_allah').toList();
    final biographies = allFavorites.where((f) => f.favoritableType == 'seerah' || f.favoritableType == 'sahaba').toList();

    return DefaultTabController(
      length: 4,
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
            l.favoritesTitle,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 12),
            tabs: [
              Tab(text: l.favTabAyahs),
              Tab(text: l.favTabHadiths),
              Tab(text: l.favTabNames),
              Tab(text: l.favTabBiographies),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAyahsTab(context, ref, ayahs, cs, l),
            _buildHadithsTab(context, ref, hadiths, cs, l),
            _buildNamesTab(context, ref, names, cs, l),
            _buildBiographiesTab(context, ref, biographies, cs, l),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppColorScheme cs, AppLocalizations l, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFE6A23C).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star_border_rounded,
              size: 44,
              color: Color(0xFFE6A23C),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: cs.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAyahsTab(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteCollection> items,
    AppColorScheme cs,
    AppLocalizations l,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState(context, cs, l, l.favNoAyahs);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final fav = items[index];
        return Card(
          color: isDark ? cs.card : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              final surahListAsync = ref.read(surahListProvider);
              surahListAsync.whenData((surahs) {
                try {
                  final matchedSurah = surahs.firstWhere((s) => s.id == fav.surahNumber);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuranReaderPage(
                        surah: matchedSurah,
                        initialAyahNumber: fav.ayahNumber ?? 1,
                      ),
                    ),
                  );
                } catch (_) {}
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleGeneric(
                            favoritableType: 'ayah',
                            favoritableId: fav.favoritableId,
                            surahNumber: fav.surahNumber,
                            ayahNumber: fav.ayahNumber,
                          );
                        },
                      ),
                      Text(
                        l.favAyahRef(fav.surahNumber ?? 1, fav.ayahNumber ?? 1),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    fav.previewText ?? '',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'UthmanicHafs',
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHadithsTab(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteCollection> items,
    AppColorScheme cs,
    AppLocalizations l,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState(context, cs, l, l.favNoHadiths);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isar = IsarService.instance.isar;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final fav = items[index];
        final hadith = isar.hadithCollections.filter().hadithIdEqualTo(fav.favoritableId).findFirstSync();
        if (hadith == null) return const SizedBox.shrink();

        return Card(
          color: isDark ? cs.card : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggleGeneric(
                          favoritableType: 'hadith',
                          favoritableId: fav.favoritableId,
                        );
                      },
                    ),
                    Text(
                      hadith.categoryNameKu,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  hadith.arabicText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hadith.translationKu,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: cs.textPrimary,
                    height: 1.5,
                  ),
                ),
                if (hadith.source != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    hadith.source!,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: cs.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNamesTab(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteCollection> items,
    AppColorScheme cs,
    AppLocalizations l,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState(context, cs, l, l.favNoNames);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isar = IsarService.instance.isar;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final fav = items[index];
        final name = isar.namesOfAllahCollections.filter().nameIdEqualTo(fav.favoritableId).findFirstSync();
        if (name == null) return const SizedBox.shrink();

        return Card(
          color: isDark ? cs.card : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NamesOfAllahPage()),
              );
            },
            title: Text(
              name.nameKu,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              name.meaningKu,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary, fontSize: 12),
            ),
            trailing: Text(
              name.nameAr,
              style: const TextStyle(fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleGeneric(
                  favoritableType: 'name_of_allah',
                  favoritableId: fav.favoritableId,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBiographiesTab(
    BuildContext context,
    WidgetRef ref,
    List<FavoriteCollection> items,
    AppColorScheme cs,
    AppLocalizations l,
  ) {
    if (items.isEmpty) {
      return _buildEmptyState(context, cs, l, l.favNoBiographies);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isar = IsarService.instance.isar;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final fav = items[index];
        final isSeerah = fav.favoritableType == 'seerah';

        dynamic details;
        String titleKu = '';
        String subTitle = '';

        if (isSeerah) {
          details = isar.seerahCollections.filter().seerahIdEqualTo(fav.favoritableId).findFirstSync();
          if (details != null) {
            titleKu = details.titleKu;
            subTitle = details.period;
          }
        } else {
          details = isar.sahabaCollections.filter().sahabaIdEqualTo(fav.favoritableId).findFirstSync();
          if (details != null) {
            titleKu = details.nameKu;
            subTitle = details.epithetKu;
          }
        }

        if (details == null) return const SizedBox.shrink();

        return Card(
          color: isDark ? cs.card : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            onTap: () {
              if (isSeerah) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SeerahPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SahabaPage()),
                );
              }
            },
            title: Text(
              titleKu,
              textAlign: TextAlign.right,
              style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subTitle,
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo', color: cs.primary, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            trailing: CircleAvatar(
              backgroundColor: cs.primary.withValues(alpha: 0.1),
              child: Icon(
                isSeerah ? Icons.history_edu_rounded : Icons.person_outline_rounded,
                color: cs.primary,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () {
                ref.read(favoritesProvider.notifier).toggleGeneric(
                  favoritableType: fav.favoritableType,
                  favoritableId: fav.favoritableId,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
