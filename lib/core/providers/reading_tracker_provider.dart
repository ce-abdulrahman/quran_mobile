// reading_tracker_provider.dart
// v1.0.4 — Reading statistics feature removed.
// This file is kept as a no-op stub so that any remaining import does not break
// compilation. All public symbols are preserved but do nothing.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';

// ─── Minimal no-op models ────────────────────────────────────────────────────

class LocalReadingHistory {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final int? juzNumber;
  final int? hizbNumber;
  final int? pageNumber;
  final DateTime timestamp;
  final int secondsSpent;

  const LocalReadingHistory({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    this.juzNumber,
    this.hizbNumber,
    this.pageNumber,
    required this.timestamp,
    required this.secondsSpent,
  });
}

class LocalLastRead {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final int mushafPageNumber;
  final String readingMode;
  final DateTime timestamp;

  const LocalLastRead({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.mushafPageNumber,
    required this.readingMode,
    required this.timestamp,
  });
}

class LocalRecentRead {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final int pageNumber;
  final String readingMode;
  final DateTime timestamp;

  const LocalRecentRead({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.pageNumber,
    required this.readingMode,
    required this.timestamp,
  });
}

class CachedQuranStats {
  final int completedSurahs;
  final int completedJuz;
  final int completedHizb;
  final int currentStreak;
  final int longestStreak;

  const CachedQuranStats({
    required this.completedSurahs,
    required this.completedJuz,
    required this.completedHizb,
    required this.currentStreak,
    required this.longestStreak,
  });
}

class ReadingTrackerState {
  final List<LocalReadingHistory> history;
  final LocalLastRead? lastRead;
  final List<LocalRecentRead> recentReads;
  final int dailyGoalAyahs;
  final CachedQuranStats cachedStats;

  const ReadingTrackerState({
    required this.history,
    this.lastRead,
    required this.recentReads,
    required this.dailyGoalAyahs,
    required this.cachedStats,
  });

  ReadingTrackerState copyWith({
    List<LocalReadingHistory>? history,
    LocalLastRead? lastRead,
    List<LocalRecentRead>? recentReads,
    int? dailyGoalAyahs,
    CachedQuranStats? cachedStats,
  }) {
    return ReadingTrackerState(
      history: history ?? this.history,
      lastRead: lastRead ?? this.lastRead,
      recentReads: recentReads ?? this.recentReads,
      dailyGoalAyahs: dailyGoalAyahs ?? this.dailyGoalAyahs,
      cachedStats: cachedStats ?? this.cachedStats,
    );
  }
}

// ─── No-op Notifier ──────────────────────────────────────────────────────────

class ReadingTrackerNotifier extends StateNotifier<ReadingTrackerState> {

  static const List<int> juzTotalAyahs = [
    148, 111, 125, 132, 124, 110, 149, 142, 159, 127,
    151, 170, 154, 227, 185, 269, 190, 202, 343, 171,
    178, 169, 357, 175, 188, 195, 399, 137, 431, 564,
  ];

  static const List<int> hizbTotalAyahs = [
    32, 18, 16, 15, 17, 14, 18, 18, 16, 19,
    12, 14, 16, 14, 10, 10, 10,  9, 11, 18,
    18, 19, 23, 18, 20, 20, 20, 18, 15, 15,
    11, 12, 12, 22, 16, 14, 12, 14, 21, 13,
    15, 14, 11, 15, 14, 10, 16, 15, 15, 12,
    24, 23, 23, 15, 21, 16, 16, 14, 10, 15,
  ];

  ReadingTrackerNotifier(SharedPreferences prefs, Ref ref)
      : super(const ReadingTrackerState(
          history: [],
          recentReads: [],
          dailyGoalAyahs: 0,
          cachedStats: CachedQuranStats(
            completedSurahs: 0,
            completedJuz: 0,
            completedHizb: 0,
            currentStreak: 0,
            longestStreak: 0,
          ),
        ));

  // All methods are no-ops — reading statistics removed in v1.0.4.
  void trackRead(int surahId, String surahName, int ayahNumber,
      {int secondsSpent = 1,
      String readingMode = 'list',
      int? mushafPageNumber}) {}

  void clearHistory() {}

  double getSurahProgress(int surahId, int totalAyahs) => 0.0;
  int getSurahReadCount(int surahId) => 0;
  int getTotalUniqueAyahsRead() => 0;
  int getTotalTimeSpentSeconds() => 0;
  int getTotalSessions() => 0;
}

// ─── Provider ────────────────────────────────────────────────────────────────

final readingTrackerProvider =
    StateNotifierProvider<ReadingTrackerNotifier, ReadingTrackerState>((ref) {
  return ReadingTrackerNotifier(ref.read(sharedPreferencesProvider), ref);
});
