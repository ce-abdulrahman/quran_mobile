import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'isar_collections.dart';
import 'content_package.dart';
import '../services/search_service.dart';

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
      SearchIndexCollectionSchema,
      AdhkarCollectionSchema,
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
    return _instance!;
  }

  /// Helper to safely load JSON from standard packages directory, or fall back to old asset structure.
  Future<List<dynamic>> _loadPackageData(String packageName, String fallbackAssetPath) async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/packages/$packageName/data.json');
      final decoded = jsonDecode(jsonString);
      if (decoded is List) return decoded;
      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        return decoded['data'] as List;
      }
      return [];
    } catch (_) {
      // Fallback
      final jsonString = await rootBundle.loadString(fallbackAssetPath);
      return jsonDecode(jsonString) as List;
    }
  }

  final List<void Function(String status, double progress)> _progressCallbacks = [];
  Future<void>? _seedingFuture;

  /// Runs database seeding with progressive state callbacks.
  /// Fully resumable if interrupted.
  Future<void> seedDatabaseWithProgress({
    required Function(String status, double progress) onProgress,
  }) async {
    _progressCallbacks.add(onProgress);
    if (_seedingFuture != null) {
      return _seedingFuture!;
    }

    _seedingFuture = _seedDatabaseInternal();
    try {
      await _seedingFuture!;
    } finally {
      _seedingFuture = null;
      _progressCallbacks.clear();
    }
  }

  Future<void> _seedDatabaseInternal() async {
    final prefs = await SharedPreferences.getInstance();

    // Total steps:
    // 8 core data seeds (Names, Seerah, Sahaba, Reciters, Hadiths, Tajweed, Surahs, Adhkars) = 8 steps
    // 114 Surahs individual ayahs import = 114 steps
    // Search index rebuild = 1 step
    // Total = 123 steps.
    const double totalSteps = 123.0;
    int completedSteps = 0;

    void update(String status) {
      final double progress = (completedSteps / totalSteps).clamp(0.0, 1.0);
      for (final cb in _progressCallbacks) {
        try {
          cb(status, progress);
        } catch (_) {}
      }
    }

    try {
      bool isStepDone(String key) => prefs.getBool('seed_step_$key') ?? false;
      Future<void> markStepDone(String key) async {
        await prefs.setBool('seed_step_$key', true);
        completedSteps++;
      }

      // 1. Names of Allah
      if (!isStepDone('names_of_allah')) {
        update('بارکردنی ناوەکانی خودا...');
        final namesCount = await isar.namesOfAllahCollections.count();
        if (namesCount == 0) {
          final data = await _loadPackageData('allah_names', 'assets/data/names_of_allah.json');
          final items = data.map((json) {
            final id = json['id'] ?? json['nameId'] ?? 0;
            return NamesOfAllahCollection(
              nameId: id as int,
              nameAr: (json['name_ar'] ?? json['nameAr'] ?? '') as String,
              nameKu: (json['name_ku'] ?? json['nameKu'] ?? '') as String,
              meaningKu: (json['meaning_ku'] ?? json['meaningKu'] ?? '') as String,
              meaningEn: (json['meaning_en'] ?? json['meaningEn'] ?? '') as String,
              verseAr: (json['verse_ar'] ?? json['verseAr'] ?? '') as String,
              verseKu: (json['verse_ku'] ?? json['verseKu'] ?? '') as String,
              virtueKu: (json['virtue_ku'] ?? json['virtueKu'] ?? '') as String,
              slug: (json['slug'] ?? 'name-$id') as String,
              version: (json['version'] ?? 1) as int,
              updatedAt: json['updated_at'] != null 
                  ? DateTime.parse(json['updated_at'] as String) 
                  : DateTime.now(),
            );
          }).toList();
          await isar.writeTxn(() => isar.namesOfAllahCollections.putAll(items));
        }
        await markStepDone('names_of_allah');
      } else {
        completedSteps++;
      }

      // 2. Seerah
      if (!isStepDone('seerah')) {
        update('بارکردنی ژیاننامەی پێغەمبەر ﷺ...');
        final seerahCount = await isar.seerahCollections.count();
        if (seerahCount == 0) {
          final data = await _loadPackageData('seerah', 'assets/data/seerah.json');
          final items = data.map((json) {
            final id = json['id'] ?? json['seerahId'] ?? 0;
            return SeerahCollection(
              seerahId: id as int,
              titleKu: (json['title_ku'] ?? json['titleKu'] ?? '') as String,
              titleAr: (json['title_ar'] ?? json['titleAr'] ?? '') as String,
              period: (json['period'] ?? '') as String,
              contentMd: (json['content_md'] ?? json['contentMd'] ?? '') as String,
              slug: (json['slug'] ?? 'seerah-$id') as String,
              version: (json['version'] ?? 1) as int,
              updatedAt: json['updated_at'] != null 
                  ? DateTime.parse(json['updated_at'] as String) 
                  : DateTime.now(),
            );
          }).toList();
          await isar.writeTxn(() => isar.seerahCollections.putAll(items));
        }
        await markStepDone('seerah');
      } else {
        completedSteps++;
      }

      // 3. Sahaba
      if (!isStepDone('sahaba')) {
        update('بارکردنی هاوەڵان...');
        final sahabaCount = await isar.sahabaCollections.count();
        if (sahabaCount == 0) {
          final data = await _loadPackageData('sahaba', 'assets/data/sahaba.json');
          final items = data.map((json) {
            final id = json['id'] ?? json['sahabaId'] ?? 0;
            return SahabaCollection(
              sahabaId: id as int,
              nameKu: (json['name_ku'] ?? json['nameKu'] ?? '') as String,
              nameAr: (json['name_ar'] ?? json['nameAr'] ?? '') as String,
              epithetKu: (json['epithet_ku'] ?? json['epithetKu'] ?? '') as String,
              summaryKu: (json['summary_ku'] ?? json['summaryKu'] ?? '') as String,
              biographyMd: (json['biography_md'] ?? json['biographyMd'] ?? '') as String,
              virtuesKu: (json['virtues_ku'] ?? json['virtuesKu'] ?? '') as String,
              slug: (json['slug'] ?? 'sahaba-$id') as String,
              version: (json['version'] ?? 1) as int,
              updatedAt: json['updated_at'] != null 
                  ? DateTime.parse(json['updated_at'] as String) 
                  : DateTime.now(),
            );
          }).toList();
          await isar.writeTxn(() => isar.sahabaCollections.putAll(items));
        }
        await markStepDone('sahaba');
      } else {
        completedSteps++;
      }

      // 4. Reciters
      if (!isStepDone('reciters')) {
        update('بارکردنی قورئانخوێنەکان...');
        final recitersCount = await isar.reciterCollections.count();
        if (recitersCount == 0) {
          final data = await _loadPackageData('audio_metadata', 'assets/data/reciters.json');
          final items = data.map((json) {
            final id = json['reciterId'] ?? json['id'] ?? 0;
            return ReciterCollection(
              reciterId: id as int,
              nameKu: (json['name_ku'] ?? json['nameKu'] ?? '') as String,
              nameAr: (json['name_ar'] ?? json['nameAr'] ?? '') as String,
              type: (json['type'] ?? 'arabic') as String,
              bioKu: (json['bio_ku'] ?? json['bioKu'] ?? '') as String,
              imageAsset: (json['image_asset'] ?? json['imageAsset'] ?? 'assets/images/default_reciter.png') as String,
              sampleAudioUrl: (json['sample_audio_url'] ?? json['sampleAudioUrl'] ?? '') as String,
              downloadBaseUrl: (json['download_base_url'] ?? json['downloadBaseUrl'] ?? '') as String,
              slug: (json['slug'] ?? 'reciter-$id') as String,
              version: (json['version'] ?? 1) as int,
              updatedAt: json['updated_at'] != null 
                  ? DateTime.parse(json['updated_at'] as String) 
                  : DateTime.now(),
            );
          }).toList();
          await isar.writeTxn(() => isar.reciterCollections.putAll(items));
        }
        await markStepDone('reciters');
      } else {
        completedSteps++;
      }

      // 5. Hadiths
      if (!isStepDone('hadiths')) {
        update('بارکردنی فەرموودەکان...');
        final hadithsCount = await isar.hadithCollections.count();
        if (hadithsCount == 0) {
          final data = await _loadPackageData('hadith', 'assets/data/hadiths.json');
          final items = data.map((json) {
            final id = json['id'] ?? json['hadithId'] ?? 0;
            return HadithCollection(
              hadithId: id as int,
              categoryId: (json['category_id'] ?? json['categoryId'] ?? 1) as int,
              categoryNameAr: (json['category_name_ar'] ?? json['categoryNameAr'] ?? 'عام') as String,
              categoryNameKu: (json['category_name_ku'] ?? json['categoryNameKu'] ?? 'گشتی') as String,
              arabicText: (json['arabic_text'] ?? json['arabicText'] ?? '') as String,
              translationKu: (json['translation_ku'] ?? json['translationKu'] ?? '') as String,
              translationEn: (json['translation_en'] ?? json['translationEn']) as String?,
              narrator: json['narrator'] as String?,
              source: json['source'] as String?,
              explanationKu: (json['explanation_ku'] ?? json['explanationKu']) as String?,
              explanationEn: (json['explanation_en'] ?? json['explanationEn']) as String?,
              order: (json['order'] ?? 0) as int,
              isActive: json['is_active'] != false && json['isActive'] != false,
              slug: (json['slug'] ?? 'hadith-$id') as String,
              version: (json['version'] ?? 1) as int,
              updatedAt: json['updated_at'] != null 
                  ? DateTime.parse(json['updated_at'] as String) 
                  : DateTime.now(),
            );
          }).toList();
          await isar.writeTxn(() => isar.hadithCollections.putAll(items));
        }
        await markStepDone('hadiths');
      } else {
        completedSteps++;
      }

      // 6. Tajweed Rules
      if (!isStepDone('tajweed_rules')) {
        update('بارکردنی یاساکانی تەجوید...');
        final rulesCount = await isar.tajweedRuleCollections.count();
        if (rulesCount == 0) {
          final data = await _loadPackageData('tajweed', 'assets/data/tajweed_rules.json');
          final List<TajweedRuleCollection> items = [];
          for (final cat in data) {
            final catId = cat['id'] as int? ?? cat['categoryId'] as int? ?? 0;
            final catSlug = cat['slug'] as String? ?? '';
            final catNameKu = cat['name_ku'] as String? ?? cat['nameKu'] as String? ?? '';
            final catNameAr = cat['name_ar'] as String? ?? cat['nameAr'] as String? ?? '';
            final catNameEn = cat['name'] as String? ?? cat['nameEn'] as String? ?? '';
            final catOrder = cat['order'] as int? ?? 0;
            int rulePriority = 0;

            final rulesList = cat['rules'] as List<dynamic>? ?? [];
            for (final rule in rulesList) {
              items.add(TajweedRuleCollection(
                ruleId: rule['id'] as int? ?? rule['ruleId'] as int? ?? 0,
                ruleSlug: rule['slug'] as String? ?? '',
                nameAr: rule['name_ar'] as String? ?? rule['nameAr'] as String? ?? '',
                nameEn: rule['name'] as String? ?? rule['nameEn'] as String? ?? '',
                nameKu: rule['name_ku'] as String? ?? rule['nameKu'] as String? ?? '',
                colorCode: rule['color_code'] as String? ?? rule['colorCode'] as String? ?? '#000000',
                description: rule['description_ku'] as String? ?? rule['descriptionKu'] as String? ?? rule['description'] as String?,
                categoryId: catId,
                categorySlug: catSlug,
                categoryNameAr: catNameAr,
                categoryNameEn: catNameEn,
                categoryNameKu: catNameKu,
                categoryOrder: catOrder,
                rulePriority: rulePriority++,
              ));
            }
          }
          if (items.isNotEmpty) {
            await isar.writeTxn(() => isar.tajweedRuleCollections.putAll(items));
          }
        }
        await markStepDone('tajweed_rules');
      } else {
        completedSteps++;
      }

      // 7. Surahs
      if (!isStepDone('surahs')) {
        update('بارکردنی ناوی سوورەتەکان...');
        final surahsCount = await isar.surahCollections.count();
        if (surahsCount == 0) {
          final rawData = await _loadPackageData('quran', 'assets/data/surahs.json');
          final data = rawData.where((x) => x is Map && x.containsKey('number')).toList();
          final items = data.map((x) {
            final json = x as Map<String, dynamic>;
            return SurahCollection(
              number: (json['number'] ?? 0) as int,
              nameAr: (json['name_ar'] ?? json['nameAr'] ?? '') as String,
              nameEn: (json['name_en'] ?? json['nameEn'] ?? '') as String,
              nameKu: (json['name_ku'] ?? json['nameKu'] ?? '') as String,
              totalAyahs: (json['ayah_count'] ?? json['totalAyahs'] ?? 0) as int,
              revelationType: (json['revelation_type'] ?? json['revelationType'] ?? 'Meccan') as String,
              pageStart: json['page_start'] as int?,
              pageEnd: json['page_end'] as int?,
            );
          }).toList();
          await isar.writeTxn(() => isar.surahCollections.putAll(items));
        }
        await markStepDone('surahs');
      } else {
        completedSteps++;
      }

      // 8. Adhkars
      if (!isStepDone('adhkars')) {
        update('بارکردنی ئەزکار و زیکرەکان...');
        final adhkarCount = await isar.adhkarCollections.count();
        if (adhkarCount == 0) {
          final data = await _loadPackageData('adhkar', 'assets/data/adhkars.json');
          final List<AdhkarCollection> items = [];
          for (final cat in data) {
            final categoryId = cat['id'] as int? ?? cat['categoryId'] as int? ?? 0;
            final categoryNameKu = cat['name_ku'] as String? ?? cat['nameKu'] as String? ?? '';
            final categoryNameAr = cat['name_ar'] as String? ?? cat['nameAr'] as String? ?? '';
            final categoryNameEn = cat['name_en'] as String? ?? cat['nameEn'] as String?;
            final categoryIcon = cat['icon'] as String?;
            final categoryOrder = cat['order'] as int? ?? 0;

            final adhkarList = cat['adhkars'] as List? ?? [];
            for (final item in adhkarList) {
              items.add(AdhkarCollection(
                adhkarId: item['id'] as int? ?? item['adhkarId'] as int? ?? 0,
                categoryId: categoryId,
                categoryNameKu: categoryNameKu,
                categoryNameAr: categoryNameAr,
                categoryNameEn: categoryNameEn,
                categoryIcon: categoryIcon,
                categoryOrder: categoryOrder,
                arabicText: item['arabic_text'] as String? ?? item['text'] as String? ?? '',
                translationKu: item['translation_ku'] as String? ?? item['translation'] as String? ?? '',
                translationEn: item['translation_en'] as String?,
                description: item['description'] as String? ?? item['benefit'] as String?,
                targetCount: item['count'] as int? ?? item['targetCount'] as int? ?? 1,
                source: item['source'] as String?,
                version: item['version'] as int? ?? 1,
                updatedAt: DateTime.now(),
              ));
            }
          }
          if (items.isNotEmpty) {
            await isar.writeTxn(() => isar.adhkarCollections.putAll(items));
          }
        }
        await markStepDone('adhkars');
      } else {
        completedSteps++;
      }

      // 9. Seeding individual Surah Ayahs (114 Surahs)
      final int lastCompletedSurah = prefs.getInt('seed_last_completed_surah') ?? 0;
      completedSteps += lastCompletedSurah;

      for (int i = lastCompletedSurah + 1; i <= 114; i++) {
        update('بارکردنی سوورەتی $i...');
        
        final List<AyahCollection> surahAyahs = [];
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

            final segmentsJson = json['tajweed_segments'] as List<dynamic>? ?? [];
            final tajweedSegments = segmentsJson.map((x) {
              final m = x as Map<String, dynamic>;
              return TajweedSegment()
                ..startIndex = m['start_index'] as int?
                ..endIndex = m['end_index'] as int?
                ..ruleId = m['rule_id'] as int? ?? m['rule'] as int?
                ..colorId = m['color_id'] as int?
                ..connectsToLeft = m['connects_to_left'] as bool?
                ..connectsToRight = m['connects_to_right'] as bool?
                ..textSegment = m['text_segment'] as String?;
            }).toList();

            surahAyahs.add(AyahCollection(
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
              tajweedSegments: tajweedSegments,
            ));
          }

          if (surahAyahs.isNotEmpty) {
            await isar.writeTxn(() async {
              await isar.ayahCollections.filter().surahNumberEqualTo(i).deleteAll();
              await isar.ayahCollections.putAll(surahAyahs);
            });
          }
        } catch (e) {
          if (kDebugMode) {
            print("Failed to seed surah $i: $e");
          }
        }

        await prefs.setInt('seed_last_completed_surah', i);
        completedSteps = 8 + i; // 8 metadata steps + current surah index
      }

      // 10. Rebuild Search Index
      if (!isStepDone('search_index')) {
        update('نوێکردنەوەی ئیندێکسی گەڕان...');
        await SearchService.instance.rebuildAll();
        await markStepDone('search_index');
      } else {
        completedSteps++;
      }

      // 11. Mark all as complete
      await prefs.setBool('is_db_initialized', true);
      update('تەواوبوو');
      
      // Save default manifests representing our preloaded DB state
      await _registerDefaultManifests(prefs);

    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Resumable Seeder failed: $e\n$stackTrace");
      }
      rethrow;
    }
  }

  Future<void> _registerDefaultManifests(SharedPreferences prefs) async {
    final now = DateTime.now();
    for (final pkg in ContentPackage.values) {
      final key = 'pkg_manifest_${pkg.name}';
      if (prefs.getString(key) == null) {
        final manifest = PackageManifest(
          package: pkg,
          version: 1,
          createdAt: now,
          updatedAt: now,
          checksum: 'local_seed_v1',
          isComplete: true,
          records: pkg == ContentPackage.quran ? 6236 : 0,
        );
        await prefs.setString(key, jsonEncode(manifest.toJson()));
      }
    }
  }

  /// Checks if any critical collection is empty, returning true if seeding is required.
  Future<bool> checkNeedSeeding() async {
    try {
      final namesCount = await isar.namesOfAllahCollections.count();
      final seerahCount = await isar.seerahCollections.count();
      final sahabaCount = await isar.sahabaCollections.count();
      final recitersCount = await isar.reciterCollections.count();
      final hadithsCount = await isar.hadithCollections.count();
      final rulesCount = await isar.tajweedRuleCollections.count();
      final surahsCount = await isar.surahCollections.count();
      final adhkarsCount = await isar.adhkarCollections.count();

      if (namesCount == 0 ||
          seerahCount == 0 ||
          sahabaCount == 0 ||
          recitersCount == 0 ||
          hadithsCount == 0 ||
          rulesCount == 0 ||
          surahsCount == 0 ||
          adhkarsCount == 0) {
        final prefs = await SharedPreferences.getInstance();
        if (namesCount == 0) await prefs.setBool('seed_step_names_of_allah', false);
        if (seerahCount == 0) await prefs.setBool('seed_step_seerah', false);
        if (sahabaCount == 0) await prefs.setBool('seed_step_sahaba', false);
        if (recitersCount == 0) await prefs.setBool('seed_step_reciters', false);
        if (hadithsCount == 0) await prefs.setBool('seed_step_hadiths', false);
        if (rulesCount == 0) await prefs.setBool('seed_step_tajweed_rules', false);
        if (surahsCount == 0) await prefs.setBool('seed_step_surahs', false);
        if (adhkarsCount == 0) await prefs.setBool('seed_step_adhkars', false);
        await prefs.setBool('is_db_initialized', false);
        return true;
      }
      return false;
    } catch (_) {
      return true; // Seed on error to be safe
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
