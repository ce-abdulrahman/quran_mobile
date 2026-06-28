import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';
import '../models/surah_model.dart';
import '../../features/quran/quran_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Reading History Model
// ─────────────────────────────────────────────────────────────────────────────

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

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'juzNumber': juzNumber,
        'hizbNumber': hizbNumber,
        'pageNumber': pageNumber,
        'timestamp': timestamp.toIso8601String(),
        'secondsSpent': secondsSpent,
      };

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static int? _toNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  factory LocalReadingHistory.fromJson(Map<String, dynamic> json) =>
      LocalReadingHistory(
        surahId: _toInt(json['surahId']),
        surahName: json['surahName']?.toString() ?? '',
        ayahNumber: _toInt(json['ayahNumber']),
        juzNumber: _toNullableInt(json['juzNumber']),
        hizbNumber: _toNullableInt(json['hizbNumber']),
        pageNumber: _toNullableInt(json['pageNumber']),
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
            : DateTime.now(),
        secondsSpent: _toInt(json['secondsSpent']),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Last Read Model (Smart Resume expanded fields)
// ─────────────────────────────────────────────────────────────────────────────

class LocalLastRead {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final int mushafPageNumber;
  final String readingMode; // 'list' | 'mushaf'
  final DateTime timestamp;

  const LocalLastRead({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.mushafPageNumber,
    required this.readingMode,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'mushafPageNumber': mushafPageNumber,
        'readingMode': readingMode,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LocalLastRead.fromJson(Map<String, dynamic> json) => LocalLastRead(
        surahId: LocalReadingHistory._toInt(json['surahId']),
        surahName: json['surahName']?.toString() ?? '',
        ayahNumber: LocalReadingHistory._toInt(json['ayahNumber']),
        mushafPageNumber: LocalReadingHistory._toInt(json['mushafPageNumber'] ?? json['pageNumber'] ?? 1),
        readingMode: json['readingMode']?.toString() ?? 'list',
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Recent Read Model
// ─────────────────────────────────────────────────────────────────────────────

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

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'pageNumber': pageNumber,
        'readingMode': readingMode,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LocalRecentRead.fromJson(Map<String, dynamic> json) => LocalRecentRead(
        surahId: LocalReadingHistory._toInt(json['surahId']),
        surahName: json['surahName']?.toString() ?? '',
        ayahNumber: LocalReadingHistory._toInt(json['ayahNumber']),
        pageNumber: LocalReadingHistory._toInt(json['pageNumber']),
        readingMode: json['readingMode']?.toString() ?? 'list',
        timestamp: json['timestamp'] != null
            ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Cached Statistics Layer Model
// ─────────────────────────────────────────────────────────────────────────────

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

  Map<String, dynamic> toJson() => {
        'completedSurahs': completedSurahs,
        'completedJuz': completedJuz,
        'completedHizb': completedHizb,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
      };

  factory CachedQuranStats.fromJson(Map<String, dynamic> json) =>
      CachedQuranStats(
        completedSurahs: json['completedSurahs'] as int? ?? 0,
        completedJuz: json['completedJuz'] as int? ?? 0,
        completedHizb: json['completedHizb'] as int? ?? 0,
        currentStreak: json['currentStreak'] as int? ?? 0,
        longestStreak: json['longestStreak'] as int? ?? 0,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// State Class
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// Notifier Class
// ─────────────────────────────────────────────────────────────────────────────

class ReadingTrackerNotifier extends StateNotifier<ReadingTrackerState> {
  final SharedPreferences _prefs;
  final Ref _ref;

  static const _historyKey = 'local_reading_history';
  static const _lastReadKey = 'local_last_read';
  static const _recentReadsKey = 'local_recent_reads';
  static const _dailyGoalKey = 'local_quran_daily_goal';
  static const _cachedStatsKey = 'cached_quran_stats';

  // Static total ayahs per Juz for completion checks
  static const List<int> juzTotalAyahs = [
    148, 111, 125, 132, 124, 110, 149, 142, 159, 127,
    151, 170, 154, 227, 185, 269, 190, 202, 343, 171,
    178, 169, 357, 175, 188, 195, 399, 137, 431, 564
  ];

  // Static total ayahs per Hizb for completion checks
  static const List<int> hizbTotalAyahs = [
    32, 18, 16, 15, 17, 14, 18, 18, 16, 19,
    12, 14, 16, 14, 10, 10, 10, 9, 11, 18,
    18, 19, 23, 18, 20, 20, 20, 18, 15, 15,
    11, 12, 12, 22, 16, 14, 12, 14, 21, 13,
    15, 14, 11, 15, 14, 10, 16, 15, 15, 12,
    24, 23, 23, 15, 21, 16, 16, 14, 10, 15
  ];

  ReadingTrackerNotifier(this._prefs, this._ref)
      : super(const ReadingTrackerState(
          history: [],
          recentReads: [],
          dailyGoalAyahs: 10,
          cachedStats: CachedQuranStats(
            completedSurahs: 0,
            completedJuz: 0,
            completedHizb: 0,
            currentStreak: 0,
            longestStreak: 0,
          ),
        )) {
    _load();
  }

  void _load() {
    final rawHistory = _prefs.getStringList(_historyKey);
    final rawLastRead = _prefs.getString(_lastReadKey);
    final rawRecentReads = _prefs.getStringList(_recentReadsKey);
    final dailyGoalVal = _prefs.getInt(_dailyGoalKey) ?? 10;
    final rawCachedStats = _prefs.getString(_cachedStatsKey);

    List<LocalReadingHistory> loadedHistory = [];
    if (rawHistory != null) {
      try {
        loadedHistory = rawHistory
            .map((e) => LocalReadingHistory.fromJson(
                jsonDecode(e) as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    LocalLastRead? loadedLastRead;
    if (rawLastRead != null) {
      try {
        loadedLastRead = LocalLastRead.fromJson(
            jsonDecode(rawLastRead) as Map<String, dynamic>);
      } catch (_) {}
    }

    List<LocalRecentRead> loadedRecent = [];
    if (rawRecentReads != null) {
      try {
        loadedRecent = rawRecentReads
            .map((e) => LocalRecentRead.fromJson(
                jsonDecode(e) as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    CachedQuranStats loadedStats = const CachedQuranStats(
      completedSurahs: 0,
      completedJuz: 0,
      completedHizb: 0,
      currentStreak: 0,
      longestStreak: 0,
    );
    if (rawCachedStats != null) {
      try {
        loadedStats = CachedQuranStats.fromJson(
            jsonDecode(rawCachedStats) as Map<String, dynamic>);
      } catch (_) {
        loadedStats = _recalculateCachedStats(loadedHistory);
      }
    } else if (loadedHistory.isNotEmpty) {
      loadedStats = _recalculateCachedStats(loadedHistory);
    }

    state = ReadingTrackerState(
      history: loadedHistory,
      lastRead: loadedLastRead,
      recentReads: loadedRecent,
      dailyGoalAyahs: dailyGoalVal,
      cachedStats: loadedStats,
    );
  }

  Future<void> setDailyGoal(int goal) async {
    state = state.copyWith(dailyGoalAyahs: goal);
    await _prefs.setInt(_dailyGoalKey, goal);
  }

  Future<void> trackRead(
    int surahId,
    String surahName,
    int ayahNumber, {
    int secondsSpent = 0,
    int? mushafPageNumber,
    String? readingMode,
    int? juzNumber,
    int? hizbNumber,
    int? pageNumber,
  }) async {
    final now = DateTime.now();
    
    var resolvedJuz = juzNumber;
    var resolvedHizb = hizbNumber;
    var resolvedPage = pageNumber ?? mushafPageNumber ?? 1;

    try {
      final ayahsVal = _ref.read(ayahsProvider(surahId));
      if (ayahsVal.hasValue && ayahsVal.value != null) {
        final match = ayahsVal.value!.firstWhere((a) => a.ayahNumber == ayahNumber);
        resolvedJuz ??= match.juzNumber;
        resolvedHizb ??= match.hizbNumber;
        resolvedPage = pageNumber ?? mushafPageNumber ?? match.pageNumber ?? 1;
      }
    } catch (_) {}

    final resolvedMode = readingMode ?? 'list';

    // 1. Update Last Read
    final newLastRead = LocalLastRead(
      surahId: surahId,
      surahName: surahName,
      ayahNumber: ayahNumber,
      mushafPageNumber: resolvedPage,
      readingMode: resolvedMode,
      timestamp: now,
    );

    // 2. Add to Reading History (limit history size to 1000 items to conserve memory)
    final newEntry = LocalReadingHistory(
      surahId: surahId,
      surahName: surahName,
      ayahNumber: ayahNumber,
      juzNumber: resolvedJuz,
      hizbNumber: resolvedHizb,
      pageNumber: resolvedPage,
      timestamp: now,
      secondsSpent: secondsSpent,
    );

    var newHistory = [newEntry, ...state.history];
    if (newHistory.length > 1000) {
      newHistory = newHistory.sublist(0, 1000);
    }

    // 3. Update Recent Reads (unique per Surah)
    var newRecent = List<LocalRecentRead>.from(state.recentReads);
    newRecent.removeWhere((r) => r.surahId == surahId);
    newRecent.insert(
      0,
      LocalRecentRead(
        surahId: surahId,
        surahName: surahName,
        ayahNumber: ayahNumber,
        pageNumber: resolvedPage,
        readingMode: resolvedMode,
        timestamp: now,
      ),
    );
    if (newRecent.length > 10) {
      newRecent = newRecent.sublist(0, 10);
    }

    // 4. Update Cached Stats
    final newStats = _recalculateCachedStats(newHistory);

    state = state.copyWith(
      history: newHistory,
      lastRead: newLastRead,
      recentReads: newRecent,
      cachedStats: newStats,
    );

    await _save();
    
    // Check if current Khatmah plan completion changes
    try {
      final totalRead = getTotalUniqueAyahsRead();
      _ref.read(khatmProvider.notifier).checkCompletion(totalRead);
    } catch (_) {}
  }

  Future<void> clearHistory() async {
    state = const ReadingTrackerState(
      history: [],
      recentReads: [],
      dailyGoalAyahs: 10,
      cachedStats: CachedQuranStats(
        completedSurahs: 0,
        completedJuz: 0,
        completedHizb: 0,
        currentStreak: 0,
        longestStreak: 0,
      ),
    );
    await _prefs.remove(_historyKey);
    await _prefs.remove(_lastReadKey);
    await _prefs.remove(_recentReadsKey);
    await _prefs.remove(_cachedStatsKey);
  }

  Future<void> _save() async {
    final rawHistory = state.history.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_historyKey, rawHistory);

    if (state.lastRead != null) {
      await _prefs.setString(_lastReadKey, jsonEncode(state.lastRead!.toJson()));
    }

    final rawRecent = state.recentReads.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_recentReadsKey, rawRecent);

    await _prefs.setString(_cachedStatsKey, jsonEncode(state.cachedStats.toJson()));
  }

  // ── Cached Statistics Recalculation ──

  CachedQuranStats _recalculateCachedStats(List<LocalReadingHistory> history) {
    if (history.isEmpty) {
      return const CachedQuranStats(
        completedSurahs: 0,
        completedJuz: 0,
        completedHizb: 0,
        currentStreak: 0,
        longestStreak: 0,
      );
    }

    // 1. Calculate Streaks
    final uniqueDates = history
        .map((h) => DateTime(h.timestamp.year, h.timestamp.month, h.timestamp.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Descending order

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayRead = uniqueDates.contains(today);
    final yesterdayRead = uniqueDates.contains(yesterday);

    int currentStreak = 0;
    int longestStreak = 0;

    if (todayRead || yesterdayRead) {
      DateTime checkDate = todayRead ? today : yesterday;
      while (uniqueDates.contains(checkDate)) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }

    // Calculate longest streak
    final ascendingDates = List<DateTime>.from(uniqueDates)..sort((a, b) => a.compareTo(b));
    int currentRun = 0;
    DateTime? prevDate;

    for (final date in ascendingDates) {
      if (prevDate == null) {
        currentRun = 1;
      } else {
        final diff = date.difference(prevDate).inDays;
        if (diff == 1) {
          currentRun++;
        } else if (diff > 1) {
          currentRun = 1;
        }
      }
      if (currentRun > longestStreak) {
        longestStreak = currentRun;
      }
      prevDate = date;
    }

    // 2. Completed Surahs
    int completedSurahsCount = 0;
    try {
      // Try to read cached surahs directly
      const cacheKey = 'cache_surahs';
      final cachedJson = _ref.read(cacheManagerProvider).get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        final surahs = cachedJson.map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
        for (final surah in surahs) {
          final uniqueReadInSurah = history
              .where((h) => h.surahId == surah.id)
              .map((h) => h.ayahNumber)
              .toSet()
              .length;
          if (uniqueReadInSurah >= surah.totalAyahs && surah.totalAyahs > 0) {
            completedSurahsCount++;
          }
        }
      }
    } catch (_) {}

    // 3. Completed Juz
    int completedJuzCount = 0;
    for (int i = 1; i <= 30; i++) {
      final uniqueReadInJuz = history
          .where((h) => h.juzNumber == i)
          .map((h) => '${h.surahId}-${h.ayahNumber}')
          .toSet()
          .length;
      if (uniqueReadInJuz >= juzTotalAyahs[i - 1]) {
        completedJuzCount++;
      }
    }

    // 4. Completed Hizb
    int completedHizbCount = 0;
    for (int i = 1; i <= 60; i++) {
      final uniqueReadInHizb = history
          .where((h) => h.hizbNumber == i)
          .map((h) => '${h.surahId}-${h.ayahNumber}')
          .toSet()
          .length;
      if (uniqueReadInHizb >= hizbTotalAyahs[i - 1]) {
        completedHizbCount++;
      }
    }

    return CachedQuranStats(
      completedSurahs: completedSurahsCount,
      completedJuz: completedJuzCount,
      completedHizb: completedHizbCount,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }

  // ── Helper Stats Methods ──

  int getSurahReadCount(int surahId) {
    return state.history
        .where((h) => h.surahId == surahId)
        .map((h) => h.ayahNumber)
        .toSet()
        .length;
  }

  double getSurahProgress(int surahId, int totalAyahs) {
    if (totalAyahs == 0) return 0.0;
    final readCount = getSurahReadCount(surahId);
    return (readCount / totalAyahs).clamp(0.0, 1.0);
  }

  int getAyahsReadToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return state.history
        .where((h) {
          final hDate = DateTime(h.timestamp.year, h.timestamp.month, h.timestamp.day);
          return hDate == today;
        })
        .map((h) => '${h.surahId}-${h.ayahNumber}')
        .toSet()
        .length;
  }

  int getTotalUniqueAyahsRead() {
    return state.history.map((h) => '${h.surahId}-${h.ayahNumber}').toSet().length;
  }

  int getTotalTimeSpentSeconds() {
    return state.history.fold(0, (sum, item) => sum + item.secondsSpent);
  }

  int getTotalSessions() {
    if (state.history.isEmpty) return 0;
    int sessions = 1;
    final sorted = List<LocalReadingHistory>.from(state.history)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i].timestamp.difference(sorted[i - 1].timestamp).inMinutes > 30) {
        sessions++;
      }
    }
    return sessions;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider Definition
// ─────────────────────────────────────────────────────────────────────────────

final readingTrackerProvider =
    StateNotifierProvider<ReadingTrackerNotifier, ReadingTrackerState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ReadingTrackerNotifier(prefs, ref);
});
