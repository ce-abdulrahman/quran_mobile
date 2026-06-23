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
