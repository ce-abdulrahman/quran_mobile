import 'package:drift/drift.dart';

// Conditional import: native.dart on mobile/desktop, web.dart on browser
import 'connection/native.dart'
    if (dart.library.html) 'connection/web.dart';

part 'app_database.g.dart';

class Surahs extends Table {
  IntColumn get id => integer()();
  IntColumn get number => integer()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameKu => text().nullable()();
  IntColumn get totalAyahs => integer()();
  TextColumn get revelationType => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Ayahs extends Table {
  IntColumn get id => integer()();
  IntColumn get surahId => integer()();
  IntColumn get ayahNumber => integer()();
  IntColumn get pageNumber => integer()();
  IntColumn get juzNumber => integer()();
  TextColumn get textUthmani => text()();
  TextColumn get textSimple => text().nullable()();
  TextColumn get textEn => text().nullable()();
  TextColumn get textKu => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ayahId => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class TasbihLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()(); // YYYY-MM-DD
  IntColumn get count => integer()();
  TextColumn get dhikr => text()();
}

class Dhikrs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get arabic => text().nullable()();
  IntColumn get target => integer()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Surahs, Ayahs, Bookmarks, TasbihLogs, Dhikrs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openAppDatabase());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(ayahs, ayahs.textEn);
            await migrator.addColumn(ayahs, ayahs.textKu);
          }
          if (from < 3) {
            await migrator.createTable(dhikrs);
          }
        },
        beforeOpen: (details) async {
          final countQuery = await customSelect('SELECT COUNT(*) as c FROM dhikrs').getSingle();
          final rows = countQuery.read<int>('c');
          if (rows == 0) {
            await batch((b) {
              b.insertAll(dhikrs, [
                DhikrsCompanion.insert(name: 'SubhanAllah', arabic: const Value('سُبْحَانَ ٱللَّٰهِ'), target: 33, isSystem: const Value(true)),
                DhikrsCompanion.insert(name: 'Alhamdulillah', arabic: const Value('ٱلْحَمْدُ لِلَّٰهِ'), target: 33, isSystem: const Value(true)),
                DhikrsCompanion.insert(name: 'Allahu Akbar', arabic: const Value('ٱللَّٰهُ أَكْبَرُ'), target: 34, isSystem: const Value(true)),
                DhikrsCompanion.insert(name: 'Astaghfirullah', arabic: const Value('أَسْتَغْفِرُ ٱللَّٰهَ'), target: 33, isSystem: const Value(true)),
                DhikrsCompanion.insert(name: 'La Ilaha Illallah', arabic: const Value('لَا إِلَٰهَ إِلَّا ٱللَّٰهُ'), target: 33, isSystem: const Value(true)),
              ]);
            });
          }
        },
      );

}

