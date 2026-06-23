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

    final dir = await getApplicationDocumentsDirectory();
    final isarInstance = await Isar.open(
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
      ],
      directory: dir.path,
      inspector: true,
    );

    _instance = IsarService._(isarInstance);
    return _instance!;
  }

  static void initForTest(Isar isarInstance) {
    _instance = IsarService._(isarInstance);
  }
}
