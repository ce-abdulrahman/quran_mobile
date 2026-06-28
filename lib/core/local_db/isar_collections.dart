import 'package:isar/isar.dart';

part 'isar_collections.g.dart';

@collection
class SurahCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int number;

  String nameAr;
  String nameEn;
  String nameKu;
  int totalAyahs;
  String revelationType;
  int? pageStart;
  int? pageEnd;

  SurahCollection({
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.nameKu,
    required this.totalAyahs,
    required this.revelationType,
    this.pageStart,
    this.pageEnd,
  });
}

@collection
class AyahCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int ayahId;

  int surahNumber;
  int ayahNumber;
  String textUthmani;
  String? textEn;
  String? textKu;
  int? pageNumber;
  int? juzNumber;
  int? hizbNumber;
  int? rubNumber;
  String? tajweedSegmentsJson;

  AyahCollection({
    required this.ayahId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.textUthmani,
    this.textEn,
    this.textKu,
    this.pageNumber,
    this.juzNumber,
    this.hizbNumber,
    this.rubNumber,
    this.tajweedSegmentsJson,
  });
}

@collection
class TajweedRuleCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String ruleSlug;

  String nameAr;
  String nameEn;
  String nameKu;
  String colorCode;
  String? description;

  TajweedRuleCollection({
    required this.ruleSlug,
    required this.nameAr,
    required this.nameEn,
    required this.nameKu,
    required this.colorCode,
    this.description,
  });
}

@collection
class PrayerTimesCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String cacheKey;

  double latitude;
  double longitude;
  String locationHash;
  String date;
  String prayerTimesJson;

  PrayerTimesCollection({
    required this.cacheKey,
    required this.latitude,
    required this.longitude,
    required this.locationHash,
    required this.date,
    required this.prayerTimesJson,
  });
}

@collection
class MemorizationPlanCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String planId;

  int surahId;
  int fromAyah;
  int toAyah;
  String status;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSynced;

  MemorizationPlanCollection({
    required this.planId,
    required this.surahId,
    required this.fromAyah,
    required this.toAyah,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
}

@collection
class MemorizationReviewCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String reviewId;

  String planId;
  DateTime reviewedAt;
  String performance;
  DateTime updatedAt;
  bool isSynced;

  MemorizationReviewCollection({
    required this.reviewId,
    required this.planId,
    required this.reviewedAt,
    required this.performance,
    required this.updatedAt,
    required this.isSynced,
  });
}

@collection
class TasbihSessionCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String sessionId;

  DateTime startTime;
  DateTime? endTime;
  int durationSeconds;
  int totalCount;
  double avgPerMinute;
  String sessionDate;
  String status;
  String? customDhikrName;
  DateTime updatedAt;
  bool isSynced;

  TasbihSessionCollection({
    required this.sessionId,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    required this.totalCount,
    required this.avgPerMinute,
    required this.sessionDate,
    required this.status,
    this.customDhikrName,
    required this.updatedAt,
    required this.isSynced,
  });
}

@collection
class ReadingHistoryCollection {
  Id id = Isar.autoIncrement;

  int surahNumber;
  int pageNumber;
  DateTime readAt;
  int durationSeconds;

  ReadingHistoryCollection({
    required this.surahNumber,
    required this.pageNumber,
    required this.readAt,
    required this.durationSeconds,
  });
}

@collection
class BookmarkCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String bookmarkId;

  int surahNumber;
  int ayahNumber;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSynced;

  BookmarkCollection({
    required this.bookmarkId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
}

@collection
class NoteCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String noteId;

  int surahNumber;
  int ayahNumber;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSynced;

  NoteCollection({
    required this.noteId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
}

@collection
class AudioFavoriteCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String favoriteKey; // 'reciter_1' or 'surah_114'

  int favoritableId;
  String favoritableType; // 'reciter' or 'surah'
  DateTime createdAt;

  AudioFavoriteCollection({
    required this.favoriteKey,
    required this.favoritableId,
    required this.favoritableType,
    required this.createdAt,
  });
}

@collection
class DownloadCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String downloadKey; // 'reciterId_surahId'

  int reciterId;
  int surahId;
  String filePath;
  double sizeMb;
  String status; // 'downloading', 'completed', 'failed'
  double progress; // 0.0 to 100.0
  DateTime createdAt;
  DateTime lastAccessedAt;

  DownloadCollection({
    required this.downloadKey,
    required this.reciterId,
    required this.surahId,
    required this.filePath,
    required this.sizeMb,
    required this.status,
    required this.progress,
    required this.createdAt,
    required this.lastAccessedAt,
  });
}

@collection
class NamesOfAllahCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int nameId;

  String nameAr;
  String nameKu;
  String meaningKu;
  String meaningEn;
  String verseAr;
  String verseKu;
  String virtueKu;

  @Index()
  String slug;

  int version;
  DateTime updatedAt;

  NamesOfAllahCollection({
    required this.nameId,
    required this.nameAr,
    required this.nameKu,
    required this.meaningKu,
    required this.meaningEn,
    required this.verseAr,
    required this.verseKu,
    required this.virtueKu,
    required this.slug,
    required this.version,
    required this.updatedAt,
  });
}

@collection
class SeerahCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int seerahId;

  String titleKu;
  String titleAr;
  String period;
  String contentMd;

  @Index()
  String slug;

  int version;
  DateTime updatedAt;

  SeerahCollection({
    required this.seerahId,
    required this.titleKu,
    required this.titleAr,
    required this.period,
    required this.contentMd,
    required this.slug,
    required this.version,
    required this.updatedAt,
  });
}

@collection
class SahabaCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int sahabaId;

  String nameKu;
  String nameAr;
  String epithetKu;
  String summaryKu;
  String biographyMd;
  String virtuesKu;

  @Index()
  String slug;

  int version;
  DateTime updatedAt;

  SahabaCollection({
    required this.sahabaId,
    required this.nameKu,
    required this.nameAr,
    required this.epithetKu,
    required this.summaryKu,
    required this.biographyMd,
    required this.virtuesKu,
    required this.slug,
    required this.version,
    required this.updatedAt,
  });
}

@collection
class HadithCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int hadithId;

  int categoryId;
  String categoryNameKu;
  String categoryNameAr;
  String arabicText;
  String translationKu;
  String? translationEn;
  String? narrator;
  String? source;
  String? explanationKu;
  String? explanationEn;
  int order;
  bool isActive;

  @Index()
  String slug;

  int version;
  DateTime updatedAt;

  HadithCollection({
    required this.hadithId,
    required this.categoryId,
    required this.categoryNameKu,
    required this.categoryNameAr,
    required this.arabicText,
    required this.translationKu,
    this.translationEn,
    this.narrator,
    this.source,
    this.explanationKu,
    this.explanationEn,
    required this.order,
    required this.isActive,
    required this.slug,
    required this.version,
    required this.updatedAt,
  });
}

@collection
class TafsirCollection {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('ayahNumber')])
  int surahNumber;
  int ayahNumber;

  String text;

  @Index()
  String slug;

  int version;
  DateTime updatedAt;

  TafsirCollection({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.slug,
    required this.version,
    required this.updatedAt,
  });
}

@collection
class ReciterCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int reciterId;

  String nameKu;
  String nameAr;
  String type; // 'arabic' | 'kurdish'
  String bioKu;
  String imageAsset;
  String sampleAudioUrl;
  String downloadBaseUrl;

  @Index()
  String slug;

  int version;
  DateTime updatedAt;

  ReciterCollection({
    required this.reciterId,
    required this.nameKu,
    required this.nameAr,
    required this.type,
    required this.bioKu,
    required this.imageAsset,
    required this.sampleAudioUrl,
    required this.downloadBaseUrl,
    required this.slug,
    required this.version,
    required this.updatedAt,
  });
}

@collection
class FavoriteCollection {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String favoriteId; // format: 'hadith_5' or 'ayah_2_255' or 'seerah_1' or 'sahaba_3' or 'name_of_allah_1'

  String favoritableType; // 'ayah' | 'hadith' | 'seerah' | 'sahaba' | 'name_of_allah'
  int favoritableId;

  int? surahNumber; // helper for ayah favorites
  int? ayahNumber;  // helper for ayah favorites
  String? previewText;

  DateTime createdAt;
  DateTime updatedAt;
  bool isSynced;

  FavoriteCollection({
    required this.favoriteId,
    required this.favoritableType,
    required this.favoritableId,
    this.surahNumber,
    this.ayahNumber,
    this.previewText,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
}
