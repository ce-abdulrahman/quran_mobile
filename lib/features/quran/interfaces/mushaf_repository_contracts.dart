import 'package:flutter/foundation.dart';

/// Abstract storage contract for Mushaf application configurations and last-read progress.
/// Independent of third-party state managers like Riverpod or Bloc.
abstract class MushafSettingsRepository {
  /// Persists the last read page index to storage.
  Future<void> saveLastReadPage(int pageNumber);

  /// Retrieves the saved last read page index from storage.
  Future<int> getLastReadPage();

  /// Saves the active reading background theme mode.
  Future<void> setBgMode(String bgMode);

  /// Dynamic notifier for real-time background mode updates.
  ValueNotifier<String> get bgModeNotifier;
}

/// Abstract storage contract for managing page-level bookmarks.
abstract class BookmarkRepository {
  /// Adds a page bookmark.
  Future<void> addPageBookmark(int pageNumber);

  /// Removes a page bookmark.
  Future<void> removePageBookmark(int pageNumber);

  /// Checks if a specific page is bookmarked.
  Future<bool> isPageBookmarked(int pageNumber);
}
