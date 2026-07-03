import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:isar/isar.dart';
import 'package:dio/dio.dart';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:quran_mobile/core/local_db/isar_service.dart';
import 'package:quran_mobile/core/local_db/isar_collections.dart';
import 'package:quran_mobile/core/local_db/content_package.dart';
import 'package:quran_mobile/core/local_db/package_manager.dart';
import 'package:quran_mobile/core/services/data_transfer_service.dart';

class FakePathProvider extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getLibraryPath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return Directory.systemTemp.path;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return [Directory.systemTemp.path];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) async {
    return [Directory.systemTemp.path];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return Directory.systemTemp.path;
  }
}

class MockAdapter implements HttpClientAdapter {
  int hadithDownloadCount = 0;
  final Map<String, Uint8List> _zips = {};
  final Map<String, String> _checksums = {};

  MockAdapter() {
    _generateZip('quran');
    _generateZip('translations');
    _generateZip('hadith');
  }

  void _generateZip(String pkgName) {
    final archive = Archive();
    final List<dynamic> recordsJson = pkgName == 'quran' ? [
      {
        'number': 1,
        'name_ar': 'الفاتحة',
        'name_en': 'Al-Fatihah',
        'name_ku': 'الفاتحة',
        'total_ayahs': 7,
        'revelation_type': 'Meccan',
      }
    ] : (pkgName == 'translations' ? [
      {
        'surah_number': 1,
        'ayah_number': 1,
        'language_code': 'ku',
        'content': 'به‌ناوی خوای به‌خشنده‌ی میهره‌بان',
      }
    ] : [
      {
        'id': 1,
        'arabic_text': 'الحمد لله',
        'translation_ku': 'سپاس بۆ خوا',
        'is_active': true,
      }
    ]);

    final dataStr = jsonEncode(recordsJson);
    archive.addFile(ArchiveFile('data.json', dataStr.length, utf8.encode(dataStr)));
    
    final zipList = ZipEncoder().encode(archive)!;
    final zipBytes = Uint8List.fromList(zipList);
    
    _zips[pkgName] = zipBytes;
    _checksums[pkgName] = sha256.convert(zipBytes).toString();
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = options.path;

    if (path.endsWith('/manifests')) {
      final data = {
        'status': 'success',
        'data': [
          {
            'package': 'quran',
            'version': 1,
            'minimum_app_version': 1,
            'recommended_app_version': 1,
            'schema_version': 1,
            'created_at': '2026-06-25T12:00:00Z',
            'updated_at': '2026-06-25T12:00:00Z',
            'checksum': _checksums['quran'],
            'records': 1,
            'compressed_size': 100,
            'uncompressed_size': 200,
            'signature': 'signed_${_checksums['quran']}',
            'supports_delta': false,
            'dependencies': [],
          },
          {
            'package': 'translations',
            'version': 1,
            'minimum_app_version': 1,
            'recommended_app_version': 1,
            'schema_version': 1,
            'created_at': '2026-06-25T12:00:00Z',
            'updated_at': '2026-06-25T12:00:00Z',
            'checksum': _checksums['translations'],
            'records': 1,
            'compressed_size': 100,
            'uncompressed_size': 200,
            'signature': 'signed_${_checksums['translations']}',
            'supports_delta': false,
            'dependencies': ['quran'],
          },
          {
            'package': 'hadith',
            'version': 1,
            'minimum_app_version': 1,
            'recommended_app_version': 1,
            'schema_version': 1,
            'created_at': '2026-06-25T12:00:00Z',
            'updated_at': '2026-06-25T12:00:00Z',
            'checksum': _checksums['hadith'],
            'records': 1,
            'compressed_size': 100,
            'uncompressed_size': 200,
            'signature': 'signed_${_checksums['hadith']}',
            'supports_delta': false,
            'dependencies': [],
          }
        ],
      };
      
      final payload = utf8.encode(jsonEncode(data));
      return ResponseBody.fromBytes(
        Uint8List.fromList(payload),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (path.contains('/manifest')) {
      final segments = path.split('/');
      final pkgName = segments[segments.length - 2];
      final isTranslations = pkgName == 'translations';
      final isHadith = pkgName == 'hadith';
      
      int version = 1;
      String checksum = _checksums[pkgName]!;
      String signature = 'signed_$checksum';
      
      if (isHadith && hadithDownloadCount > 0) {
        version = 2;
        signature = 'bad';
      }

      final data = {
        'status': 'success',
        'data': {
          'package': pkgName,
          'version': version,
          'minimum_app_version': 1,
          'recommended_app_version': 1,
          'schema_version': 1,
          'created_at': '2026-06-25T12:00:00Z',
          'updated_at': '2026-06-25T12:00:00Z',
          'checksum': checksum,
          'records': 1,
          'compressed_size': 100,
          'uncompressed_size': 200,
          'signature': signature,
          'supports_delta': false,
          'dependencies': isTranslations ? ['quran'] : [],
        },
      };

      final payload = utf8.encode(jsonEncode(data));
      return ResponseBody.fromBytes(
        Uint8List.fromList(payload),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (path.contains('/download')) {
      final segments = path.split('/');
      final pkgName = segments[segments.length - 2];

      if (pkgName == 'hadith') {
        hadithDownloadCount++;
      }

      final zipBytes = _zips[pkgName]!;

      // Write mock zip file to temp directory where the client expects it
      final tempDir = Directory.systemTemp;
      final zipFile = File('${tempDir.path}/$pkgName.zip');
      await zipFile.writeAsBytes(zipBytes);

      return ResponseBody.fromBytes(
        zipBytes,
        200,
        headers: {
          Headers.contentTypeHeader: ['application/zip'],
        },
      );
    }

    throw UnimplementedError('Not mocked path: $path');
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences prefs;
  late Isar isar;
  late Dio dio;
  late MockAdapter interceptor;

  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProvider();

    // Initialize Isar Core for testing
    await Isar.initializeIsarCore(download: true);
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
        AudioFavoriteCollectionSchema,
        DownloadCollectionSchema,
        SearchIndexCollectionSchema,
        AdhkarCollectionSchema,
      ],
      directory: tempDir.path,
    );
    IsarService.initForTest(isar);
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    
    interceptor = MockAdapter();
    dio = Dio(BaseOptions(baseUrl: 'http://localhost/api/v1'));
    dio.httpClientAdapter = interceptor;
    
    await isar.writeTxn(() async {
      await isar.clear();
    });
  });

  group('PackageManager Tests', () {
    test('Downloads and resolves dependencies recursively', () async {
      final manager = PackageManager(prefs, dio: dio);
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
      final manager = PackageManager(prefs, dio: dio);
      
      // First, set up a successful version 1 download
      await manager.downloadPackage(ContentPackage.hadith);
      final initialManifest = await manager.getManifest(ContentPackage.hadith);
      expect(initialManifest!.version, equals(1));

      // Try to download/verify: must throw validation error and rollback to 1
      try {
        await manager.downloadPackage(ContentPackage.hadith);
        fail('Should have failed signature validation');
      } catch (e) {
        expect(e.toString(), contains('signature'));
      }

      final activeManifest = await manager.getManifest(ContentPackage.hadith);
      expect(activeManifest!.version, equals(1), reason: 'Should rollback to backup version 1');
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
