import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../core/database/app_database.dart';
import 'package:drift/drift.dart';

// Selected tab in Quran page: 0 = All Surahs, 1 = Meccan, 2 = Medinan, 3 = Bookmarks
final quranTabFilterProvider = StateProvider<int>((ref) => 0);

// Search Query for Quran list
final quranSearchQueryProvider = StateProvider<String>((ref) => '');

// All Surahs in the database
final localSurahsProvider = FutureProvider<List<Surah>>((ref) async {
  final db = ref.read(databaseProvider);
  
  // Try loading from database
  final list = await (db.select(db.surahs)..orderBy([(t) => OrderingTerm(expression: t.number)])).get();
  
  if (list.isEmpty) {
    try {
      final apiClient = ref.read(quranApiClientProvider);
      final apiSurahs = await apiClient.fetchSurahs();
      final List<SurahsCompanion> surahCompanions = [];
      
      for (var map in apiSurahs) {
        surahCompanions.add(
          SurahsCompanion.insert(
            id: Value(map['id'] as int),
            number: map['number'] as int,
            nameAr: map['name_ar'] as String,
            nameEn: map['name_en'] as String,
            nameKu: Value(map['name_ku'] as String?),
            totalAyahs: map['ayah_count'] as int? ?? map['total_ayahs'] as int? ?? 0,
            revelationType: (map['revelation_type'] as String? ?? 'makki').toLowerCase() == 'madani' ? 'Medinan' : 'Meccan',
          ),
        );
      }
      
      await db.batch((batch) {
        batch.insertAll(db.surahs, surahCompanions, mode: InsertMode.insertOrReplace);
      });
    } catch (e) {
      // Fallback offline prepopulate if connection fails
      await _prepopulateSurahs(db);
    }
    
    return (db.select(db.surahs)..orderBy([(t) => OrderingTerm(expression: t.number)])).get();
  }
  
  return list;
});

// Fetch Ayahs for a Surah, using database cache first, else API
final ayahsForSurahProvider = FutureProvider.family<List<Ayah>, int>((ref, surahId) async {
  final db = ref.read(databaseProvider);
  final apiClient = ref.read(quranApiClientProvider);

  // Check if we have Ayahs in the local database
  final localList = await (db.select(db.ayahs)
    ..where((t) => t.surahId.equals(surahId))
    ..orderBy([(t) => OrderingTerm(expression: t.ayahNumber)])).get();

  if (localList.isNotEmpty) {
    return localList;
  }

  // Fetch from Laravel API
  final apiAyahs = await apiClient.fetchAyahs(surahId);
  final List<AyahsCompanion> companions = apiAyahs.map((map) {
    return AyahsCompanion.insert(
      id: Value(map['id'] as int),
      surahId: surahId,
      ayahNumber: map['ayah_number'] as int,
      pageNumber: map['page_number'] as int? ?? 1,
      juzNumber: map['juz_number'] as int? ?? 1,
      textUthmani: map['text_uthmani'] as String,
      textSimple: Value(map['text_simple'] as String?),
      textEn: Value(map['text_en'] as String?),
      textKu: Value(map['text_ku'] as String?),
    );
  }).toList();

  // Save to database
  await db.batch((batch) {
    batch.insertAll(db.ayahs, companions, mode: InsertMode.insertOrReplace);
  });

  // Return loaded list from database
  return (db.select(db.ayahs)
    ..where((t) => t.surahId.equals(surahId))
    ..orderBy([(t) => OrderingTerm(expression: t.ayahNumber)])).get();
});


class BookmarkedAyah {
  final Bookmark bookmark;
  final Ayah ayah;
  final Surah surah;

  BookmarkedAyah({
    required this.bookmark,
    required this.ayah,
    required this.surah,
  });
}

// Bookmarks List Provider
final bookmarksListProvider = StreamProvider<List<Bookmark>>((ref) {
  final db = ref.read(databaseProvider);
  return db.select(db.bookmarks).watch();
});

// Bookmarked Ayahs Stream Provider (with joins)
final bookmarkedAyahsStreamProvider = StreamProvider<List<BookmarkedAyah>>((ref) {
  final db = ref.watch(databaseProvider);
  
  final query = db.select(db.bookmarks).join([
    innerJoin(db.ayahs, db.ayahs.id.equalsExp(db.bookmarks.ayahId)),
    innerJoin(db.surahs, db.surahs.id.equalsExp(db.ayahs.surahId)),
  ]);

  return query.watch().map((rows) {
    return rows.map((row) {
      return BookmarkedAyah(
        bookmark: row.readTable(db.bookmarks),
        ayah: row.readTable(db.ayahs),
        surah: row.readTable(db.surahs),
      );
    }).toList();
  });
});

// Check if a Surah is bookmarked (contains any bookmarked Ayah)
final isSurahBookmarkedProvider = Provider.family<bool, int>((ref, surahId) {
  final bookmarkedAsync = ref.watch(bookmarkedAyahsStreamProvider);
  return bookmarkedAsync.when(
    data: (list) => list.any((b) => b.surah.id == surahId),
    loading: () => false,
    error: (_, __) => false,
  );
});

// Check if a specific Ayah is bookmarked
final isAyahBookmarkedProvider = Provider.family<bool, int>((ref, ayahId) {
  final bookmarkedAsync = ref.watch(bookmarkedAyahsStreamProvider);
  return bookmarkedAsync.when(
    data: (list) => list.any((b) => b.ayah.id == ayahId),
    loading: () => false,
    error: (_, __) => false,
  );
});

// Toggle bookmark for an Ayah
final quranBookmarkNotifierProvider = Provider((ref) {
  final db = ref.read(databaseProvider);
  return BookmarkNotifier(db, ref);
});

class BookmarkNotifier {
  final AppDatabase db;
  final Ref ref;
  BookmarkNotifier(this.db, this.ref);

  Future<void> toggleBookmark(int ayahId) async {
    final list = await (db.select(db.bookmarks)..where((t) => t.ayahId.equals(ayahId))).get();
    if (list.isEmpty) {
      await db.into(db.bookmarks).insert(
        BookmarksCompanion.insert(
          ayahId: ayahId,
          note: const Value('Ayah Bookmark'),
        ),
      );
    } else {
      await (db.delete(db.bookmarks)..where((t) => t.ayahId.equals(ayahId))).go();
    }
  }

  Future<void> toggleSurahBookmark(int surahId) async {
    try {
      final ayahs = await ref.read(ayahsForSurahProvider(surahId).future);
      if (ayahs.isEmpty) return;

      final ayahIds = ayahs.map((e) => e.id).toList();
      final bookmarksList = await (db.select(db.bookmarks)
            ..where((t) => t.ayahId.isIn(ayahIds)))
          .get();

      if (bookmarksList.isNotEmpty) {
        await (db.delete(db.bookmarks)
              ..where((t) => t.ayahId.isIn(ayahIds)))
            .go();
      } else {
        await db.into(db.bookmarks).insert(
              BookmarksCompanion.insert(
                ayahId: ayahs.first.id,
                note: const Value('Surah Bookmark'),
              ),
            );
      }
    } catch (e) {
      // Silently catch network errors during API fetch on list page
      debugPrint('Error toggling surah bookmark: $e');
    }
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    await (db.delete(db.bookmarks)..where((t) => t.id.equals(bookmarkId))).go();
  }
}

// Pre-populate Surah data for V1
Future<void> _prepopulateSurahs(AppDatabase db) async {
  final List<SurahsCompanion> surahCompanions = [];
  
  for (var i = 0; i < _surahMetadata.length; i++) {
    final metadata = _surahMetadata[i];
    surahCompanions.add(
      SurahsCompanion.insert(
        id: Value(i + 1),
        number: i + 1,
        nameAr: metadata['ar']!,
        nameEn: metadata['en']!,
        nameKu: Value(metadata['ku']!),
        totalAyahs: int.parse(metadata['ayahs']!),
        revelationType: metadata['type']!,
      ),
    );
  }

  await db.batch((batch) {
    batch.insertAll(db.surahs, surahCompanions);
  });
}

// 114 Surahs Metadata
const List<Map<String, String>> _surahMetadata = [
  {"ar": "الفاتحة", "en": "Al-Fatihah", "ku": "فاتیحە", "ayahs": "7", "type": "Meccan"},
  {"ar": "البقرة", "en": "Al-Baqarah", "ku": "بەقەرە", "ayahs": "286", "type": "Medinan"},
  {"ar": "آل عمران", "en": "Ali 'Imran", "ku": "ئالی عیمران", "ayahs": "200", "type": "Medinan"},
  {"ar": "النساء", "en": "An-Nisa'", "ku": "نیسا", "ayahs": "176", "type": "Medinan"},
  {"ar": "المائدة", "en": "Al-Ma'idah", "ku": "مائیدە", "ayahs": "120", "type": "Medinan"},
  {"ar": "الأنعام", "en": "Al-An'am", "ku": "ئەنعام", "ayahs": "165", "type": "Meccan"},
  {"ar": "الأعراف", "en": "Al-A'raf", "ku": "ئەعراف", "ayahs": "206", "type": "Meccan"},
  {"ar": "الأنفال", "en": "Al-Anfal", "ku": "ئەنفال", "ayahs": "75", "type": "Medinan"},
  {"ar": "التوبة", "en": "At-Tawbah", "ku": "تەوبە", "ayahs": "129", "type": "Medinan"},
  {"ar": "يونس", "en": "Yunus", "ku": "یونس", "ayahs": "109", "type": "Meccan"},
  {"ar": "هود", "en": "Hud", "ku": "هود", "ayahs": "123", "type": "Meccan"},
  {"ar": "يوسف", "en": "Yusuf", "ku": "یووسف", "ayahs": "111", "type": "Meccan"},
  {"ar": "الرعد", "en": "Ar-Ra'd", "ku": "رەعد", "ayahs": "43", "type": "Medinan"},
  {"ar": "إبراهيم", "en": "Ibrahim", "ku": "ئیبراهیم", "ayahs": "52", "type": "Meccan"},
  {"ar": "الحجر", "en": "Al-Hijr", "ku": "حیجر", "ayahs": "99", "type": "Meccan"},
  {"ar": "النحل", "en": "An-Nahl", "ku": "نەحل", "ayahs": "128", "type": "Meccan"},
  {"ar": "الإسراء", "en": "Al-Isra'", "ku": "ئیسرا", "ayahs": "111", "type": "Meccan"},
  {"ar": "الكهف", "en": "Al-Kahf", "ku": "کەهف", "ayahs": "110", "type": "Meccan"},
  {"ar": "مريم", "en": "Maryam", "ku": "مەریەم", "ayahs": "98", "type": "Meccan"},
  {"ar": "طه", "en": "Taha", "ku": "تەها", "ayahs": "135", "type": "Meccan"},
  {"ar": "الأنبياء", "en": "Al-Anbiya'", "ku": "ئەنبیا", "ayahs": "112", "type": "Meccan"},
  {"ar": "الحج", "en": "Al-Hajj", "ku": "حەج", "ayahs": "78", "type": "Medinan"},
  {"ar": "المؤمنون", "en": "Al-Mu'minun", "ku": "موئمنون", "ayahs": "118", "type": "Meccan"},
  {"ar": "النور", "en": "An-Nur", "ku": "نوور", "ayahs": "64", "type": "Medinan"},
  {"ar": "الفرقان", "en": "Al-Furqan", "ku": "فورقان", "ayahs": "77", "type": "Meccan"},
  {"ar": "الشعراء", "en": "Ash-Shu'ara'", "ku": "شوعەرا", "ayahs": "227", "type": "Meccan"},
  {"ar": "النمل", "en": "An-Naml", "ku": "نەمل", "ayahs": "93", "type": "Meccan"},
  {"ar": "القصص", "en": "Al-Qasas", "ku": "قەسەس", "ayahs": "88", "type": "Meccan"},
  {"ar": "العنكبوت", "en": "Al-'Ankabut", "ku": "عەنکەبوت", "ayahs": "69", "type": "Meccan"},
  {"ar": "الروم", "en": "Ar-Rum", "ku": "ڕووم", "ayahs": "60", "type": "Meccan"},
  {"ar": "لقمان", "en": "Luqman", "ku": "لوقمان", "ayahs": "34", "type": "Meccan"},
  {"ar": "السجدة", "en": "As-Sajdah", "ku": "سەجدە", "ayahs": "30", "type": "Meccan"},
  {"ar": "الأحزاب", "en": "Al-Ahzab", "ku": "ئەحزاب", "ayahs": "73", "type": "Medinan"},
  {"ar": "سبأ", "en": "Saba'", "ku": "سەبەء", "ayahs": "54", "type": "Meccan"},
  {"ar": "فاطر", "en": "Fatir", "ku": "فاتر", "ayahs": "45", "type": "Meccan"},
  {"ar": "يس", "en": "Ya-Sin", "ku": "یاسین", "ayahs": "83", "type": "Meccan"},
  {"ar": "الصافات", "en": "As-Saffat", "ku": "سافات", "ayahs": "182", "type": "Meccan"},
  {"ar": "ص", "en": "Sad", "ku": "ساد", "ayahs": "88", "type": "Meccan"},
  {"ar": "الزمر", "en": "Az-Zumar", "ku": "زومەر", "ayahs": "75", "type": "Meccan"},
  {"ar": "غافر", "en": "Ghafir", "ku": "غافر", "ayahs": "85", "type": "Meccan"},
  {"ar": "فصلت", "en": "Fussilat", "ku": "فوسیلەت", "ayahs": "54", "type": "Meccan"},
  {"ar": "الشورى", "en": "Ash-Shura", "ku": "شورا", "ayahs": "53", "type": "Meccan"},
  {"ar": "الزخرف", "en": "Az-Zukhruf", "ku": "زوخروف", "ayahs": "89", "type": "Meccan"},
  {"ar": "الدخان", "en": "Ad-Dukhan", "ku": "دوخان", "ayahs": "59", "type": "Meccan"},
  {"ar": "الجاثية", "en": "Al-Jathiyah", "ku": "جاسیە", "ayahs": "37", "type": "Meccan"},
  {"ar": "الأحقاف", "en": "Al-Ahqaf", "ku": "ئەحقاف", "ayahs": "35", "type": "Meccan"},
  {"ar": "محمد", "en": "Muhammad", "ku": "موهەممەد", "ayahs": "38", "type": "Medinan"},
  {"ar": "الفتح", "en": "Al-Fath", "ku": "فەتح", "ayahs": "29", "type": "Medinan"},
  {"ar": "الحجرات", "en": "Al-Hujurat", "ku": "حوجورات", "ayahs": "18", "type": "Medinan"},
  {"ar": "ق", "en": "Qaf", "ku": "قاف", "ayahs": "45", "type": "Meccan"},
  {"ar": "الذاريات", "en": "Adh-Dhariyat", "ku": "زاریات", "ayahs": "60", "type": "Meccan"},
  {"ar": "الطور", "en": "At-Tur", "ku": "توور", "ayahs": "49", "type": "Meccan"},
  {"ar": "النجم", "en": "An-Najm", "ku": "نەجم", "ayahs": "62", "type": "Meccan"},
  {"ar": "القمر", "en": "Al-Qamar", "ku": "قەمەر", "ayahs": "55", "type": "Meccan"},
  {"ar": "الرحمن", "en": "Ar-Rahman", "ku": "ڕەحمان", "ayahs": "78", "type": "Medinan"},
  {"ar": "الواقعة", "en": "Al-Waqi'ah", "ku": "واقیعە", "ayahs": "96", "type": "Meccan"},
  {"ar": "الحديد", "en": "Al-Hadid", "ku": "حەدید", "ayahs": "29", "type": "Medinan"},
  {"ar": "المجادلة", "en": "Al-Mujadilah", "ku": "موجادیلە", "ayahs": "22", "type": "Medinan"},
  {"ar": "الحشر", "en": "Al-Hashr", "ku": "حەشر", "ayahs": "24", "type": "Medinan"},
  {"ar": "الممتحنة", "en": "Al-Mumtahanah", "ku": "مومتەحینە", "ayahs": "13", "type": "Medinan"},
  {"ar": "الصف", "en": "As-Saff", "ku": "سەف", "ayahs": "14", "type": "Medinan"},
  {"ar": "الجمعة", "en": "Al-Jumu'ah", "ku": "جومعە", "ayahs": "11", "type": "Medinan"},
  {"ar": "المنافقون", "en": "Al-Munafiqun", "ku": "مونافیقون", "ayahs": "11", "type": "Medinan"},
  {"ar": "التغابن", "en": "At-Taghabun", "ku": "تەغابون", "ayahs": "18", "type": "Medinan"},
  {"ar": "الطلاق", "en": "At-Talaq", "ku": "تەڵاق", "ayahs": "12", "type": "Medinan"},
  {"ar": "التحريم", "en": "At-Tahrim", "ku": "تەحریم", "ayahs": "12", "type": "Medinan"},
  {"ar": "الملك", "en": "Al-Mulk", "ku": "مولک", "ayahs": "30", "type": "Meccan"},
  {"ar": "القلم", "en": "Al-Qalam", "ku": "قەڵەم", "ayahs": "52", "type": "Meccan"},
  {"ar": "الحاقة", "en": "Al-Haqqah", "ku": "حاققە", "ayahs": "52", "type": "Meccan"},
  {"ar": "المعارج", "en": "Al-Ma'arij", "ku": "مەعاریج", "ayahs": "44", "type": "Meccan"},
  {"ar": "نوح", "en": "Nuh", "ku": "نووح", "ayahs": "28", "type": "Meccan"},
  {"ar": "الجن", "en": "Al-Jinn", "ku": "جن", "ayahs": "28", "type": "Meccan"},
  {"ar": "المزمل", "en": "Al-Muzzammil", "ku": "موزەممل", "ayahs": "20", "type": "Meccan"},
  {"ar": "المدثر", "en": "Al-Muddaththir", "ku": "موددەسسر", "ayahs": "56", "type": "Meccan"},
  {"ar": "القيامة", "en": "Al-Qiyamah", "ku": "قیامە", "ayahs": "40", "type": "Meccan"},
  {"ar": "الإنسان", "en": "Al-Insan", "ku": "ئینسان", "ayahs": "31", "type": "Medinan"},
  {"ar": "المرسلات", "en": "Al-Mursalat", "ku": "مورسەلات", "ayahs": "50", "type": "Meccan"},
  {"ar": "النبأ", "en": "An-Naba'", "ku": "نەبەء", "ayahs": "40", "type": "Meccan"},
  {"ar": "النازعات", "en": "An-Nazi'at", "ku": "نازیعات", "ayahs": "46", "type": "Meccan"},
  {"ar": "عبس", "en": "'Abasa", "ku": "عەبەس", "ayahs": "42", "type": "Meccan"},
  {"ar": "التكوير", "en": "At-Takwir", "ku": "تەکـویر", "ayahs": "29", "type": "Meccan"},
  {"ar": "الانفطار", "en": "Al-Infitar", "ku": "ئینفیتار", "ayahs": "19", "type": "Meccan"},
  {"ar": "المطففين", "en": "Al-Mutaffifin", "ku": "موتەففیفین", "ayahs": "36", "type": "Meccan"},
  {"ar": "الانشقاق", "en": "Al-Inshiqaq", "ku": "ئینشـیقاق", "ayahs": "25", "type": "Meccan"},
  {"ar": "البروج", "en": "Al-Buruj", "ku": "بورووج", "ayahs": "22", "type": "Meccan"},
  {"ar": "الطارق", "en": "At-Tariq", "ku": "تارق", "ayahs": "17", "type": "Meccan"},
  {"ar": "الأعلى", "en": "Al-A'la", "ku": "ئەعلا", "ayahs": "19", "type": "Meccan"},
  {"ar": "الغاشية", "en": "Al-Ghashiyah", "ku": "غاشیە", "ayahs": "26", "type": "Meccan"},
  {"ar": "الفجر", "en": "Al-Fajr", "ku": "فەجر", "ayahs": "30", "type": "Meccan"},
  {"ar": "البلد", "en": "Al-Balad", "ku": "بەلەد", "ayahs": "20", "type": "Meccan"},
  {"ar": "الشمس", "en": "Ash-Shams", "ku": "شەمس", "ayahs": "15", "type": "Meccan"},
  {"ar": "الليل", "en": "Al-Layl", "ku": "لەیـل", "ayahs": "21", "type": "Meccan"},
  {"ar": "الضحى", "en": "Ad-Duha", "ku": "زوحا", "ayahs": "11", "type": "Meccan"},
  {"ar": "الشرح", "en": "Ash-Sharh", "ku": "شەرح", "ayahs": "8", "type": "Meccan"},
  {"ar": "التين", "en": "At-Tin", "ku": "تین", "ayahs": "8", "type": "Meccan"},
  {"ar": "العلق", "en": "Al-'Alaq", "ku": "عەلەق", "ayahs": "19", "type": "Meccan"},
  {"ar": "القدر", "en": "Al-Qadr", "ku": "قەدر", "ayahs": "5", "type": "Meccan"},
  {"ar": "البينة", "en": "Al-Bayyinah", "ku": "بەیینە", "ayahs": "8", "type": "Medinan"},
  {"ar": "الزلزلة", "en": "Az-Zalzalah", "ku": "زەلزەلە", "ayahs": "8", "type": "Medinan"},
  {"ar": "العاديات", "en": "Al-'Adiyat", "ku": "عادیات", "ayahs": "11", "type": "Meccan"},
  {"ar": "القارعة", "en": "Al-Qari'ah", "ku": "قاریعە", "ayahs": "11", "type": "Meccan"},
  {"ar": "التكاثر", "en": "At-Takathur", "ku": "تەکاسور", "ayahs": "8", "type": "Meccan"},
  {"ar": "العصر", "en": "Al-'Asr", "ku": "عەسر", "ayahs": "3", "type": "Meccan"},
  {"ar": "الهمزة", "en": "Al-Humazah", "ku": "هومەزە", "ayahs": "9", "type": "Meccan"},
  {"ar": "الفيل", "en": "Al-Fil", "ku": "فیل", "ayahs": "5", "type": "Meccan"},
  {"ar": "قريش", "en": "Quraysh", "ku": "قورەیش", "ayahs": "4", "type": "Meccan"},
  {"ar": "الماعون", "en": "Al-Ma'un", "ku": "ماعون", "ayahs": "7", "type": "Meccan"},
  {"ar": "الكوثر", "en": "Al-Kawthar", "ku": "کەوسەر", "ayahs": "3", "type": "Meccan"},
  {"ar": "الكافرون", "en": "Al-Kafirun", "ku": "کافیرون", "ayahs": "6", "type": "Meccan"},
  {"ar": "النصر", "en": "An-Nasr", "ku": "نەسر", "ayahs": "3", "type": "Medinan"},
  {"ar": "المسد", "en": "Al-Masad", "ku": "مەسەد", "ayahs": "5", "type": "Meccan"},
  {"ar": "الإخلاص", "en": "Al-Ikhlas", "ku": "ئیخلاس", "ayahs": "4", "type": "Meccan"},
  {"ar": "الفلق", "en": "Al-Falaq", "ku": "فەلەق", "ayahs": "5", "type": "Meccan"},
  {"ar": "الناس", "en": "An-Nas", "ku": "ناس", "ayahs": "6", "type": "Meccan"}
];
