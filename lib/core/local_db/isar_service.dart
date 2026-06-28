import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'isar_collections.dart';

class IsarService {
  static IsarService? _instance;
  late final Isar isar;

  IsarService._(this.isar);

  static IsarService get instance {
    if (_instance == null) {
      throw StateError('IsarService has not been initialized. Call init() first.');
    }
    return _instance!;
  }

  static Future<IsarService> init() async {
    if (_instance != null) return _instance!;

    if (kIsWeb) {
      _instance = IsarService._(MockIsar());
      return _instance!;
    }

    final String directoryPath = (await getApplicationDocumentsDirectory()).path;
    
    final schemas = [
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
      AudioFavoriteCollectionSchema,
      DownloadCollectionSchema,
      NamesOfAllahCollectionSchema,
      SeerahCollectionSchema,
      SahabaCollectionSchema,
      HadithCollectionSchema,
      TafsirCollectionSchema,
      ReciterCollectionSchema,
      FavoriteCollectionSchema,
    ];

    Isar isarInstance;
    try {
      isarInstance = await Isar.open(
        schemas,
        directory: directoryPath,
        inspector: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Isar failed to open: $e. Re-initializing database.");
      }
      
      try {
        final existing = Isar.getInstance();
        if (existing != null) {
          await existing.close(deleteFromDisk: true);
        }
      } catch (closeError) {
        if (kDebugMode) {
          print("Failed to close existing Isar instance: $closeError");
        }
      }
      
      try {
        final dbFile = io.File('$directoryPath/default.isar');
        final lockFile = io.File('$directoryPath/default.isar.lock');
        if (await dbFile.exists()) {
          await dbFile.delete();
        }
        if (await lockFile.exists()) {
          await lockFile.delete();
        }
      } catch (deleteError) {
        if (kDebugMode) {
          print("Failed to delete Isar database files: $deleteError");
        }
      }

      isarInstance = await Isar.open(
        schemas,
        directory: directoryPath,
        inspector: true,
      );
    }

    _instance = IsarService._(isarInstance);
    
    // Seed database with local offline JSON seed files if empty
    if (!kIsWeb) {
      await _instance!._seedDatabase();
    }

    return _instance!;
  }

  Future<void> _seedDatabase() async {
    try {
      // 1. Seed Names of Allah
      final namesCount = await isar.namesOfAllahCollections.count();
      if (namesCount == 0) {
        final jsonString = await rootBundle.loadString('assets/data/names_of_allah.json');
        final List<dynamic> data = jsonDecode(jsonString);
        final items = data.map((json) => NamesOfAllahCollection(
          nameId: json['id'] as int,
          nameAr: json['name_ar'] as String,
          nameKu: json['name_ku'] as String,
          meaningKu: json['meaning_ku'] as String,
          meaningEn: json['meaning_en'] as String,
          verseAr: json['verse_ar'] as String,
          verseKu: json['verse_ku'] as String,
          virtueKu: json['virtue_ku'] as String,
          slug: json['slug'] as String,
          version: json['version'] as int,
          updatedAt: DateTime.parse(json['updated_at'] as String),
        )).toList();
        await isar.writeTxn(() => isar.namesOfAllahCollections.putAll(items));
      }

      // 2. Seed Seerah
      final seerahCount = await isar.seerahCollections.count();
      if (seerahCount == 0) {
        final jsonString = await rootBundle.loadString('assets/data/seerah.json');
        final List<dynamic> data = jsonDecode(jsonString);
        final items = data.map((json) => SeerahCollection(
          seerahId: json['id'] as int,
          titleKu: json['title_ku'] as String,
          titleAr: json['title_ar'] as String,
          period: json['period'] as String,
          contentMd: json['content_md'] as String,
          slug: json['slug'] as String,
          version: json['version'] as int,
          updatedAt: DateTime.parse(json['updated_at'] as String),
        )).toList();
        await isar.writeTxn(() => isar.seerahCollections.putAll(items));
      }

      // 3. Seed Sahaba
      final sahabaCount = await isar.sahabaCollections.count();
      if (sahabaCount == 0) {
        final jsonString = await rootBundle.loadString('assets/data/sahaba.json');
        final List<dynamic> data = jsonDecode(jsonString);
        final items = data.map((json) => SahabaCollection(
          sahabaId: json['id'] as int,
          nameKu: json['name_ku'] as String,
          nameAr: json['name_ar'] as String,
          epithetKu: json['epithet_ku'] as String,
          summaryKu: json['summary_ku'] as String,
          biographyMd: json['biography_md'] as String,
          virtuesKu: json['virtues_ku'] as String,
          slug: json['slug'] as String,
          version: json['version'] as int,
          updatedAt: DateTime.parse(json['updated_at'] as String),
        )).toList();
        await isar.writeTxn(() => isar.sahabaCollections.putAll(items));
      }

      // 4. Seed Reciters
      final recitersCount = await isar.reciterCollections.count();
      if (recitersCount == 0) {
        final jsonString = await rootBundle.loadString('assets/data/reciters.json');
        final List<dynamic> data = jsonDecode(jsonString);
        final items = data.map((json) => ReciterCollection(
          reciterId: json['reciterId'] as int,
          nameKu: json['name_ku'] as String,
          nameAr: json['name_ar'] as String,
          type: json['type'] as String,
          bioKu: json['bio_ku'] as String,
          imageAsset: json['image_asset'] as String,
          sampleAudioUrl: json['sample_audio_url'] as String,
          downloadBaseUrl: json['download_base_url'] as String,
          slug: json['slug'] as String,
          version: json['version'] as int,
          updatedAt: DateTime.parse(json['updated_at'] as String),
        )).toList();
        await isar.writeTxn(() => isar.reciterCollections.putAll(items));
      }

      // 5. Seed Hadiths (flat format from imanikurd)
      final hadithsCount = await isar.hadithCollections.count();
      if (hadithsCount == 0) {
        final jsonString = await rootBundle.loadString('assets/data/hadiths.json');
        final List<dynamic> data = jsonDecode(jsonString);
        final items = data.map((json) => HadithCollection(
          hadithId: json['id'] as int,
          categoryId: json['category_id'] as int? ?? 1,
          categoryNameAr: json['category_name_ar'] as String? ?? 'عام',
          categoryNameKu: json['category_name_ku'] as String? ?? 'گشتی',
          arabicText: json['arabic_text'] as String,
          translationKu: json['translation_ku'] as String,
          translationEn: json['translator_en'] as String?,
          narrator: json['narrator'] as String?,
          source: json['source'] as String?,
          explanationKu: json['explanation_ku'] as String?,
          explanationEn: json['explanation_en'] as String?,
          order: json['order'] as int? ?? 0,
          isActive: json['is_active'] != false,
          slug: json['slug'] as String? ?? 'hadith-${json['id']}',
          version: json['version'] as int? ?? 1,
          updatedAt: DateTime.now(),
        )).toList();
        await isar.writeTxn(() => isar.hadithCollections.putAll(items));
      }

      // 6. Seed Tajweed Rules
      final rulesCount = await isar.tajweedRuleCollections.count();
      if (rulesCount == 0) {
        final jsonString = await rootBundle.loadString('assets/data/tajweed_rules.json');
        final List<dynamic> data = jsonDecode(jsonString);
        final List<TajweedRuleCollection> items = [];
        for (final cat in data) {
          final rulesList = cat['rules'] as List<dynamic>? ?? [];
          for (final rule in rulesList) {
            items.add(TajweedRuleCollection(
              ruleSlug: rule['slug'] as String,
              nameAr: rule['name_ar'] as String? ?? '',
              nameEn: rule['name'] as String? ?? '',
              nameKu: rule['name_ku'] as String? ?? '',
              colorCode: rule['color_code'] as String? ?? '#000000',
              description: rule['description_ku'] as String? ?? rule['description'] as String?,
            ));
          }
        }
        if (items.isNotEmpty) {
          await isar.writeTxn(() => isar.tajweedRuleCollections.putAll(items));
        }
      }

      // 7. Seed Surahs
      final surahsCount = await isar.surahCollections.count();
      if (surahsCount == 0) {
        final jsonString = await rootBundle.loadString('assets/data/surahs.json');
        final List<dynamic> data = jsonDecode(jsonString);
        final items = data.map((json) => SurahCollection(
          number: json['number'] as int,
          nameAr: json['name_ar'] as String? ?? '',
          nameEn: json['name_en'] as String? ?? '',
          nameKu: json['name_ku'] as String? ?? '',
          totalAyahs: json['ayah_count'] as int? ?? 0,
          revelationType: json['revelation_type'] as String? ?? 'Meccan',
          pageStart: json['page_start'] as int?,
          pageEnd: json['page_end'] as int?,
        )).toList();
        await isar.writeTxn(() => isar.surahCollections.putAll(items));
      }

      // 8. Seed Ayahs
      final ayahsCount = await isar.ayahCollections.count();
      if (ayahsCount == 0) {
        final List<AyahCollection> allAyahs = [];
        for (int i = 1; i <= 114; i++) {
          try {
            final jsonString = await rootBundle.loadString('assets/data/quran/surah_$i.json');
            final List<dynamic> data = jsonDecode(jsonString);
            for (final json in data) {
              final translations = json['translations'] as List<dynamic>? ?? [];
              String? textEn;
              String? textKu;
              for (final t in translations) {
                if (t['language_code'] == 'en') {
                  textEn = t['content'] as String?;
                } else if (t['language_code'] == 'ku') {
                  textKu = t['content'] as String?;
                }
              }

              final segments = json['tajweed_segments'] as List<dynamic>? ?? [];
              final slugs = segments.map((s) => s['rule']['slug'] as String).toList();
              final tajweedSegmentsJson = jsonEncode(slugs);

              allAyahs.add(AyahCollection(
                ayahId: json['id'] as int,
                surahNumber: i,
                ayahNumber: json['ayah_number'] as int,
                textUthmani: json['text_uthmani'] as String? ?? '',
                textEn: textEn,
                textKu: textKu,
                pageNumber: json['page_number'] as int?,
                juzNumber: json['juz_number'] as int?,
                hizbNumber: json['hizb_number'] as int?,
                rubNumber: json['rub_number'] as int?,
                tajweedSegmentsJson: tajweedSegmentsJson,
              ));
            }
          } catch (e) {
            if (kDebugMode) {
              print("Failed to load surah_$i.json: $e");
            }
          }
        }

        if (allAyahs.isNotEmpty) {
          await isar.writeTxn(() => isar.ayahCollections.putAll(allAyahs));
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Database seeding failed: $e\n$stackTrace");
      }
    }
  }

  static void initForTest(Isar isarInstance) {
    _instance = IsarService._(isarInstance);
  }
}

class MockIsar implements Isar {
  @override
  IsarCollection<T> collection<T>() {
    return MockCollection<T>();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #writeTxn) {
      final callback = invocation.positionalArguments.first as Function;
      return Future.sync(() => callback());
    }
    if (invocation.memberName == #txn) {
      final callback = invocation.positionalArguments.first as Function;
      return Future.sync(() => callback());
    }
    return MockCollection<dynamic>();
  }
}

class MockCollection<T> implements IsarCollection<T> {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #filter) {
      return MockQueryBuilder<T, T, QFilterCondition>();
    }
    if (invocation.memberName == #where) {
      return MockQueryBuilder<T, T, QWhere>();
    }
    if (invocation.memberName == #put || invocation.memberName == #putAll) {
      return Future.value(0);
    }
    if (invocation.memberName == #delete || invocation.memberName == #deleteAll) {
      return Future.value(true);
    }
    if (invocation.memberName == #clear) {
      return Future.value();
    }
    if (invocation.memberName == #findAll) {
      return Future.value(<T>[]);
    }
    if (invocation.memberName == #findFirst) {
      return Future.value(null);
    }
    if (invocation.memberName == #count) {
      return Future.value(0);
    }
    return this;
  }
}

class MockQueryBuilder<T, R, Q> implements QueryBuilder<T, R, Q> {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #findFirst) {
      return Future.value(null);
    }
    if (invocation.memberName == #findAll) {
      return Future.value(<R>[]);
    }
    if (invocation.memberName == #count) {
      return Future.value(0);
    }
    return this;
  }
}
