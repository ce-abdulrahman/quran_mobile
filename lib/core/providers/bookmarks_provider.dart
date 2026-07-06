import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';

class LocalBookmark {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final String preview;
  final String category; // 'reading', 'memorization', 'reflection', 'favorite'

  const LocalBookmark({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.preview,
    this.category = 'reading',
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'preview': preview,
        'category': category,
      };

  factory LocalBookmark.fromJson(Map<String, dynamic> json) => LocalBookmark(
        surahId: json['surahId'] as int? ?? 0,
        surahName: json['surahName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int? ?? 0,
        preview: json['preview'] as String? ?? '',
        category: json['category'] as String? ?? 'reading',
      );
}

class BookmarksNotifier extends StateNotifier<List<LocalBookmark>> {
  BookmarksNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final isar = IsarService.instance.isar;
    final list = await isar.bookmarkCollections.where().findAll();

    final localBookmarks = <LocalBookmark>[];
    for (final b in list) {
      final surah = await isar.surahCollections.filter().numberEqualTo(b.surahNumber).findFirst();
      final ayah = await isar.ayahCollections.filter()
          .surahNumberEqualTo(b.surahNumber)
          .ayahNumberEqualTo(b.ayahNumber)
          .findFirst();

      localBookmarks.add(LocalBookmark(
        surahId: b.surahNumber,
        surahName: surah?.nameKu ?? (surah?.nameAr ?? 'سورەتێ ${b.surahNumber}'),
        ayahNumber: b.ayahNumber,
        preview: ayah?.textUthmani ?? '...',
        category: 'reading',
      ));
    }
    state = localBookmarks;
  }

  Future<void> toggle(LocalBookmark bookmark) async {
    final isar = IsarService.instance.isar;
    final bookmarkId = '${bookmark.surahId}_${bookmark.ayahNumber}';
    final existing = await isar.bookmarkCollections.filter().bookmarkIdEqualTo(bookmarkId).findFirst();

    await isar.writeTxn(() async {
      if (existing != null) {
        await isar.bookmarkCollections.delete(existing.id);
      } else {
        final newBookmark = BookmarkCollection(
          bookmarkId: bookmarkId,
          surahNumber: bookmark.surahId,
          ayahNumber: bookmark.ayahNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await isar.bookmarkCollections.put(newBookmark);
      }
    });

    await _load();
  }

  bool isBookmarked(int surahId, int ayahNumber, [String? category]) {
    return state.any((b) => b.surahId == surahId && b.ayahNumber == ayahNumber);
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<LocalBookmark>>((ref) {
  return BookmarksNotifier();
});

class PageBookmarksNotifier extends StateNotifier<List<int>> {
  PageBookmarksNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('quran.page_bookmarks') ?? [];
    // Sort page numbers ascending
    final pages = list.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0).toList();
    pages.sort();
    state = pages;
  }

  Future<void> toggle(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('quran.page_bookmarks') ?? [];
    final String pageStr = pageNumber.toString();
    if (list.contains(pageStr)) {
      list.remove(pageStr);
    } else {
      list.add(pageStr);
    }
    await prefs.setStringList('quran.page_bookmarks', list);
    await _load();
  }

  bool isBookmarked(int pageNumber) {
    return state.contains(pageNumber);
  }
}

final pageBookmarksProvider =
    StateNotifierProvider<PageBookmarksNotifier, List<int>>((ref) {
  return PageBookmarksNotifier();
});

