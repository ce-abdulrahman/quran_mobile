import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:quran_mobile/core/local_db/isar_collections.dart';
import 'package:quran_mobile/core/network/api_result.dart';

/// Mirrors TafsirRepository's queries against a real in-memory Isar, so the
/// three states the sheet renders are exercised against the actual schema
/// rather than a stub: package absent, package present but no entry for this
/// ayah, and an entry that exists.
class _TafsirQueries {
  final Isar isar;
  _TafsirQueries(this.isar);

  Future<bool> isInstalled() async => await isar.tafsirCollections.count() > 0;

  Future<ApiResult<TafsirCollection?>> getForAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    if (!await isInstalled()) {
      return const ApiError('پاکێجی تەفسیر دانەگیراوە.');
    }
    final entry = await isar.tafsirCollections
        .filter()
        .surahNumberEqualTo(surahNumber)
        .ayahNumberEqualTo(ayahNumber)
        .findFirst();
    return ApiSuccess(entry);
  }

  Future<Map<int, TafsirCollection>> getForSurah(int surahNumber) async {
    final entries = await isar.tafsirCollections
        .filter()
        .surahNumberEqualTo(surahNumber)
        .findAll();
    return {for (final e in entries) e.ayahNumber: e};
  }
}

TafsirCollection _entry(int surah, int ayah, String text) => TafsirCollection(
      surahNumber: surah,
      ayahNumber: ayah,
      text: text,
      slug: 'tafsir-$surah-$ayah',
      version: 1,
      updatedAt: DateTime(2026, 1, 1),
    );

void main() {
  late Isar isar;
  late _TafsirQueries queries;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [TafsirCollectionSchema],
      directory: '',
      name: 'tafsir_test_${DateTime.now().microsecondsSinceEpoch}',
    );
    queries = _TafsirQueries(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('with no tafsir package installed', () {
    test('reports not installed', () async {
      expect(await queries.isInstalled(), isFalse);
    });

    test('returns an error the sheet turns into a download prompt', () async {
      final result = await queries.getForAyah(surahNumber: 1, ayahNumber: 1);

      expect(result.isError, isTrue);
      result.when(
        success: (_) => fail('expected an error'),
        error: (message, _, __) => expect(message, isNotEmpty),
      );
    });
  });

  group('with the package installed', () {
    setUp(() async {
      await isar.writeTxn(() async {
        await isar.tafsirCollections.putAll([
          _entry(1, 1, 'تەفسیری بسم اللە'),
          _entry(1, 2, 'تەفسیری الحمد للە'),
          _entry(2, 255, 'تەفسیری ئایەتی کورسی'),
        ]);
      });
    });

    test('reports installed', () async {
      expect(await queries.isInstalled(), isTrue);
    });

    test('returns the entry for an ayah that has one', () async {
      final result = await queries.getForAyah(surahNumber: 1, ayahNumber: 2);

      final entry = result.dataOrNull;
      expect(entry, isNotNull);
      expect(entry!.text, 'تەفسیری الحمد للە');
      expect(entry.surahNumber, 1);
      expect(entry.ayahNumber, 2);
    });

    test('succeeds with null for an ayah that has none', () async {
      // Distinct from "not installed": the sheet says the package has no
      // entry for this ayah rather than telling the user to download it.
      final result = await queries.getForAyah(surahNumber: 1, ayahNumber: 7);

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, isNull);
    });

    test('does not mix ayahs across surahs', () async {
      // Surah 2 has ayah 255; surah 1 does not. A missing surah filter would
      // wrongly return Ayat al-Kursi for al-Fatiha.
      final wrongSurah =
          await queries.getForAyah(surahNumber: 1, ayahNumber: 255);
      expect(wrongSurah.dataOrNull, isNull);

      final rightSurah =
          await queries.getForAyah(surahNumber: 2, ayahNumber: 255);
      expect(rightSurah.dataOrNull?.text, 'تەفسیری ئایەتی کورسی');
    });

    test('getForSurah keys every entry by ayah number', () async {
      final map = await queries.getForSurah(1);

      expect(map.keys.toSet(), {1, 2});
      expect(map[1]!.text, 'تەفسیری بسم اللە');
      expect(map[2]!.text, 'تەفسیری الحمد للە');
    });

    test('getForSurah is empty for a surah with no tafsir', () async {
      expect(await queries.getForSurah(3), isEmpty);
    });
  });
}
