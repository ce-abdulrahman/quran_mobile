import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';

class LocalBookmark {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final String preview;

  const LocalBookmark({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.preview,
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'preview': preview,
      };

  factory LocalBookmark.fromJson(Map<String, dynamic> json) => LocalBookmark(
        surahId: json['surahId'] as int? ?? 0,
        surahName: json['surahName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int? ?? 0,
        preview: json['preview'] as String? ?? '',
      );
}

class BookmarksNotifier extends StateNotifier<List<LocalBookmark>> {
  final SharedPreferences _prefs;
  static const _key = 'local_bookmarks';

  BookmarksNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final raw = _prefs.getStringList(_key);
    if (raw != null) {
      try {
        state = raw
            .map((e) => LocalBookmark.fromJson(jsonDecode(e) as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
  }

  Future<void> toggle(LocalBookmark bookmark) async {
    final index = state.indexWhere((b) =>
        b.surahId == bookmark.surahId && b.ayahNumber == bookmark.ayahNumber);
    if (index != -1) {
      state = state.where((b) =>
          !(b.surahId == bookmark.surahId && b.ayahNumber == bookmark.ayahNumber))
          .toList();
    } else {
      state = [...state, bookmark];
    }
    await _save();
  }

  bool isBookmarked(int surahId, int ayahNumber) {
    return state.any((b) => b.surahId == surahId && b.ayahNumber == ayahNumber);
  }

  Future<void> _save() async {
    final raw = state.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_key, raw);
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<LocalBookmark>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BookmarksNotifier(prefs);
});
