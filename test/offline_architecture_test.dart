import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'package:quran_mobile/core/local_db/isar_service.dart';
import 'package:quran_mobile/core/local_db/isar_collections.dart';
import 'package:quran_mobile/core/local_db/content_package.dart';
import 'package:quran_mobile/core/local_db/package_manager.dart';
import 'package:quran_mobile/core/services/data_transfer_service.dart';


void main() {
  late SharedPreferences prefs;
  late Isar isar;

  setUpAll(() async {
    // Initialize Isar Core for testing
    await Isar.initializeIsarCore(download: true);
    // Initialize Isar Service in memory for testing
    // To isolate from device documents, we use a temporary dir
    final tempDir = Directory.systemTemp.createTempSync('isar_test_');
    isar = await Isar.open(
      [
        SurahCollectionSchema,
        AyahCollectionSchema,
        TajweedRuleCollectionSchema,
        PrayerTimesCollectionSchema,
        MemorizationPlanCollectionSchema,
        MemorizationReviewCollectionSchema,
        TasbihSessionCollectionSchema,
        ReadingHistoryCollectionSchema,
        BookmarkCollectionSchema,
        NoteCollectionSchema,
        NamesOfAllahCollectionSchema,
        SeerahCollectionSchema,
        SahabaCollectionSchema,
        HadithCollectionSchema,
        TafsirCollectionSchema,
        ReciterCollectionSchema,
        FavoriteCollectionSchema,
      ],
      directory: tempDir.path,
    );
    IsarService.initForTest(isar);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    await isar.writeTxn(() async {
      await isar.clear();
    });
  });

  group('PackageManager Tests', () {
    test('Downloads and resolves dependencies recursively', () async {
      final manager = PackageManager(prefs);
      final events = <PackageDownloadEvent>[];
      manager.downloadEvents.listen(events.add);

      // Trigger a package with dependencies (translations depends on quran)
      await manager.downloadPackage(ContentPackage.translations);

      expect(events.isNotEmpty, isTrue);
      // Base Quran must be ready
      final quranReady = await manager.isPackageReady(ContentPackage.quran);
      expect(quranReady, isTrue);
      
      // Translation must be ready
      final transReady = await manager.isPackageReady(ContentPackage.translations);
      expect(transReady, isTrue);
    });

    test('Rolls back to previous version when validation fails', () async {
      final manager = PackageManager(prefs);
      
      // First, set up a successful version
      await manager.downloadPackage(ContentPackage.hadith);
      final initialManifest = await manager.getManifest(ContentPackage.hadith);
      expect(initialManifest!.version, equals('1.0.0'));

      // Try to download/verify: must throw validation error and rollback to 1.0.0
      try {
        await manager.downloadPackage(ContentPackage.hadith);
      } catch (e) {
        expect(e.toString(), contains('Validation failed'));
      }

      final activeManifest = await manager.getManifest(ContentPackage.hadith);
      expect(activeManifest!.version, equals('1.0.0'), reason: 'Should rollback to backup version 1.0.0');
    });
  });

  group('DataTransferService (Import/Export) Tests', () {
    test('Exports all user progress collections offline and imports them back', () async {
      // 1. Populate Isar with some user data
      await isar.writeTxn(() async {
        await isar.noteCollections.put(NoteCollection(
          noteId: 'note_123',
          surahNumber: 1,
          ayahNumber: 7,
          content: 'My test note content',
          createdAt: DateTime(2026, 6, 20),
          updatedAt: DateTime(2026, 6, 20),
          isSynced: false,
        ));
        
        await isar.bookmarkCollections.put(BookmarkCollection(
          bookmarkId: 'bookmark_456',
          surahNumber: 2,
          ayahNumber: 255,
          createdAt: DateTime(2026, 6, 20),
          updatedAt: DateTime(2026, 6, 20),
          isSynced: false,
        ));
      });

      final transferService = DataTransferService(prefs);

      // 2. Export Data to Map
      final backup = await transferService.exportData();
      expect(backup['version'], equals('1.0.0'));
      expect(backup['data']['notes'].length, equals(1));
      expect(backup['data']['bookmarks'].length, equals(1));

      // 3. Clear Database
      await isar.writeTxn(() async {
        await isar.clear();
      });
      expect(await isar.noteCollections.count(), equals(0));

      // 4. Import Backup Data Map
      final success = await transferService.importData(backup);
      expect(success, isTrue);

      // 5. Verify database has been fully restored
      final restoredNote = await isar.noteCollections.filter().noteIdEqualTo('note_123').findFirst();
      expect(restoredNote, isNotNull);
      expect(restoredNote!.content, equals('My test note content'));

      final restoredBookmark = await isar.bookmarkCollections.filter().bookmarkIdEqualTo('bookmark_456').findFirst();
      expect(restoredBookmark, isNotNull);
      expect(restoredBookmark!.surahNumber, equals(2));
    });
  });
}
