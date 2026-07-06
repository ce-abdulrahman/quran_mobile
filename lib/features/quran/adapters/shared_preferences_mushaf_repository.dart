import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/mushaf_repository_contracts.dart';

/// Concrete repository implementation using SharedPreferences to store
/// reading progress, background modes, and settings.
class SharedPreferencesMushafRepository implements MushafSettingsRepository {
  final SharedPreferences prefs;

  @override
  final ValueNotifier<String> bgModeNotifier = ValueNotifier<String>('cream');

  SharedPreferencesMushafRepository({required this.prefs}) {
    bgModeNotifier.value = prefs.getString('reader_bg_mode') ?? 'cream';
  }

  @override
  Future<void> saveLastReadPage(int pageNumber) async {
    await prefs.setInt('quran.last_mushaf_page', pageNumber);
  }

  @override
  Future<int> getLastReadPage() async {
    return prefs.getInt('quran.last_mushaf_page') ??
           prefs.getInt('mushaf_last_read_page') ??
           1;
  }

  @override
  Future<void> setBgMode(String bgMode) async {
    await prefs.setString('reader_bg_mode', bgMode);
    bgModeNotifier.value = bgMode;
  }
}

/// Concrete repository implementation using SharedPreferences to store
/// page-level bookmarks in a simple string-list schema (fully offline-first).
class SharedPreferencesBookmarkRepository implements BookmarkRepository {
  static const String _pageBookmarksKey = 'quran.page_bookmarks';

  const SharedPreferencesBookmarkRepository();

  @override
  Future<void> addPageBookmark(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_pageBookmarksKey) ?? [];
    final String pageStr = pageNumber.toString();
    if (!list.contains(pageStr)) {
      list.add(pageStr);
      await prefs.setStringList(_pageBookmarksKey, list);
    }
  }

  @override
  Future<void> removePageBookmark(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_pageBookmarksKey) ?? [];
    final String pageStr = pageNumber.toString();
    if (list.contains(pageStr)) {
      list.remove(pageStr);
      await prefs.setStringList(_pageBookmarksKey, list);
    }
  }

  @override
  Future<bool> isPageBookmarked(int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_pageBookmarksKey) ?? [];
    return list.contains(pageNumber.toString());
  }
}
