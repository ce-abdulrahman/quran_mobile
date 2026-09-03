import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:quran_mobile/core/local_db/content_package.dart';
import 'package:quran_mobile/core/local_db/isar_collections.dart';
import 'package:quran_mobile/core/services/search_service.dart';

/// The search page queries one unified SearchIndexCollection, so every kind of
/// content has to survive in it at once. Seeding walks the packages in order
/// and rebuilds each in turn; a rebuild that reached beyond its own package
/// left the finished index holding only whichever package went last.

SurahCollection _surah(int number) => SurahCollection(
      number: number,
      nameAr: 'سورة $number',
      nameEn: 'Surah $number',
      nameKu: 'سورەتی $number',
      totalAyahs: 10,
      revelationType: 'meccan',
    );

AyahCollection _ayah(int surah, int ayah, String text) => AyahCollection(
      ayahId: surah * 1000 + ayah,
      surahNumber: surah,
      ayahNumber: ayah,
      textUthmani: text,
      pageNumber: 1,
    );

HadithCollection _hadith(int id, String arabic) => HadithCollection(
      hadithId: id,
      categoryId: 1,
      categoryNameKu: 'باوەڕ',
      categoryNameAr: 'الإيمان',
      arabicText: arabic,
      translationKu: 'وەرگێڕان $id',
      order: id,
      isActive: true,
      slug: 'hadith-$id',
      version: 1,
      updatedAt: DateTime(2026, 1, 1),
    );

NamesOfAllahCollection _name(int id, String arabic) => NamesOfAllahCollection(
      nameId: id,
      nameAr: arabic,
      nameKu: 'ناو $id',
      meaningKu: 'واتا $id',
      meaningEn: 'Meaning $id',
      verseAr: 'آية $id',
      verseKu: 'ئایەت $id',
      virtueKu: 'فەزڵ $id',
      slug: 'name-$id',
      version: 1,
      updatedAt: DateTime(2026, 1, 1),
    );

AdhkarCollection _dhikr(int id, String arabic) => AdhkarCollection(
      adhkarId: id,
      categoryId: 1,
      categoryNameKu: 'زیکری بەیانی',
      categoryNameAr: 'أذكار الصباح',
      categoryOrder: 1,
      arabicText: arabic,
      translationKu: 'وەرگێڕان $id',
      targetCount: 3,
      version: 1,
      updatedAt: DateTime(2026, 1, 1),
    );

NoteCollection _note(String id, String content) => NoteCollection(
      noteId: id,
      surahNumber: 1,
      ayahNumber: 1,
      content: content,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      isSynced: false,
    );

void main() {
  late Isar isar;
  late SearchService search;

  /// Every package the seeder indexes, in the order it indexes them.
  const seedOrder = [
    ContentPackage.quran,
    ContentPackage.tafsir,
    ContentPackage.hadith,
    ContentPackage.adhkar,
    ContentPackage.seerah,
    ContentPackage.sahaba,
    ContentPackage.allah_names,
    ContentPackage.tajweed,
  ];

  Future<Set<String>> indexedTypes() async {
    final entries = await isar.searchIndexCollections.where().findAll();
    return entries.map((e) => e.type).toSet();
  }

  Future<List<SearchIndexCollection>> matching(String text) => isar
      .searchIndexCollections
      .filter()
      .contentContains(text, caseSensitive: false)
      .findAll();

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [
        SurahCollectionSchema,
        AyahCollectionSchema,
        HadithCollectionSchema,
        AdhkarCollectionSchema,
        NamesOfAllahCollectionSchema,
        SeerahCollectionSchema,
        SahabaCollectionSchema,
        TafsirCollectionSchema,
        NoteCollectionSchema,
        SearchIndexCollectionSchema,
      ],
      directory: '',
      name: 'search_index_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    search = SearchService.withIsar(isar);

    await isar.writeTxn(() async {
      await isar.surahCollections.putAll([_surah(1), _surah(2)]);
      await isar.ayahCollections.putAll([
        _ayah(1, 1, 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
        _ayah(2, 255, 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ'),
      ]);
      await isar.hadithCollections.putAll([
        _hadith(1, 'إنما الأعمال بالنيات'),
        _hadith(2, 'الدين النصيحة'),
      ]);
      await isar.adhkarCollections.put(_dhikr(1, 'أصبحنا وأصبح الملك لله'));
      await isar.namesOfAllahCollections.put(_name(1, 'الرحمن'));
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('a full seeding pass', () {
    setUp(() async {
      for (final pkg in seedOrder) {
        await search.rebuildIndex(pkg);
      }
    });

    test('leaves every seeded package in the index', () async {
      expect(await indexedTypes(), {'ayah', 'hadith', 'adhkar', 'allah_name'});
    });

    test('keeps the ayahs, which are indexed first and lost most easily',
        () async {
      // 6236 of the app's index entries are ayahs, and quran is the first
      // package seeded — so it was the first thing the next rebuild discarded.
      final hits = await matching('الرَّحْمَٰنِ الرَّحِيمِ');
      expect(hits, hasLength(1));
      expect(hits.single.type, 'ayah');
      expect(hits.single.surahNumber, 1);
      expect(hits.single.ayahNumber, 1);
    });

    test('finds a hadith as well as an ayah', () async {
      expect((await matching('الأعمال بالنيات')).single.type, 'hadith');
      expect((await matching('الْحَيُّ الْقَيُّومُ')).single.type, 'ayah');
    });

    test('indexes one entry per record', () async {
      expect(await isar.searchIndexCollections.count(), 6);
    });
  });

  group('rebuilding one package', () {
    setUp(() async {
      await search.rebuildIndex(ContentPackage.quran);
      await search.rebuildIndex(ContentPackage.hadith);
      await search.indexNote(_note('n1', 'تێبینی سەبارەت بە ئایەتی کورسی'));
    });

    test('does not disturb the other packages', () async {
      await search.rebuildIndex(ContentPackage.hadith);

      expect(await indexedTypes(), {'ayah', 'hadith', 'note'});
      expect(await matching('الرَّحْمَٰنِ الرَّحِيمِ'), hasLength(1));
    });

    test('leaves the notes the user wrote indexed', () async {
      // Notes are only re-indexed at the end of a full seed, so a package
      // rebuild that cleared them dropped them out of search until the next
      // time that note was edited.
      await search.rebuildIndex(ContentPackage.quran);

      final hits = await matching('ئایەتی کورسی');
      expect(hits, hasLength(1));
      expect(hits.single.type, 'note');
    });

    test('picks up edited records without duplicating them', () async {
      await isar.writeTxn(() async {
        await isar.hadithCollections.put(_hadith(1, 'من حسن إسلام المرء'));
      });

      await search.rebuildIndex(ContentPackage.hadith);

      expect(await matching('الأعمال بالنيات'), isEmpty);
      expect(await matching('حسن إسلام المرء'), hasLength(1));
      expect(
        await isar.searchIndexCollections
            .filter()
            .typeEqualTo('hadith')
            .count(),
        2,
      );
    });

    test('clears its own entries when the package is deleted', () async {
      // deletePackage() empties the records and then rebuilds, which has to
      // leave that package unsearchable and everything else intact.
      await isar.writeTxn(() async {
        await isar.hadithCollections.clear();
      });

      await search.rebuildIndex(ContentPackage.hadith);

      expect(await indexedTypes(), {'ayah', 'note'});
    });
  });

  test('a package with nothing to index touches nothing', () async {
    await search.rebuildIndex(ContentPackage.quran);

    // tajweed and audio_metadata have no index entries of their own, and
    // returned before ever reaching the clear() at the top of the rebuild.
    await search.rebuildIndex(ContentPackage.tajweed);
    await search.rebuildIndex(ContentPackage.audio_metadata);

    expect(await indexedTypes(), {'ayah'});
  });
}
