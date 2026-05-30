import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Reading History Model
// ─────────────────────────────────────────────────────────────────────────────

class LocalReadingHistory {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final DateTime timestamp;
  final int secondsSpent;

  const LocalReadingHistory({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.timestamp,
    required this.secondsSpent,
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'timestamp': timestamp.toIso8601String(),
        'secondsSpent': secondsSpent,
      };

  factory LocalReadingHistory.fromJson(Map<String, dynamic> json) =>
      LocalReadingHistory(
        surahId: json['surahId'] as int? ?? 0,
        surahName: json['surahName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int? ?? 0,
        timestamp: DateTime.parse(json['timestamp'] as String),
        secondsSpent: json['secondsSpent'] as int? ?? 0,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Last Read Model
// ─────────────────────────────────────────────────────────────────────────────

class LocalLastRead {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final DateTime timestamp;

  const LocalLastRead({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'timestamp': timestamp.toIso8601String(),
      };

  factory LocalLastRead.fromJson(Map<String, dynamic> json) => LocalLastRead(
        surahId: json['surahId'] as int? ?? 0,
        surahName: json['surahName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int? ?? 0,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// State Class
// ─────────────────────────────────────────────────────────────────────────────

class ReadingTrackerState {
  final List<LocalReadingHistory> history;
  final LocalLastRead? lastRead;

  const ReadingTrackerState({
    required this.history,
    this.lastRead,
  });

  ReadingTrackerState copyWith({
    List<LocalReadingHistory>? history,
    LocalLastRead? lastRead,
  }) {
    return ReadingTrackerState(
      history: history ?? this.history,
      lastRead: lastRead ?? this.lastRead,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier Class
// ─────────────────────────────────────────────────────────────────────────────

class ReadingTrackerNotifier extends StateNotifier<ReadingTrackerState> {
  final SharedPreferences _prefs;
  static const _historyKey = 'local_reading_history';
  static const _lastReadKey = 'local_last_read';

  ReadingTrackerNotifier(this._prefs)
      : super(const ReadingTrackerState(history: [])) {
    _load();
  }

  void _load() {
    final rawHistory = _prefs.getStringList(_historyKey);
    final rawLastRead = _prefs.getString(_lastReadKey);

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

    state = ReadingTrackerState(
      history: loadedHistory,
      lastRead: loadedLastRead,
    );
  }

  Future<void> trackRead(int surahId, String surahName, int ayahNumber,
      {int secondsSpent = 0}) async {
    final now = DateTime.now();

    // 1. Update Last Read
    final newLastRead = LocalLastRead(
      surahId: surahId,
      surahName: surahName,
      ayahNumber: ayahNumber,
      timestamp: now,
    );

    // 2. Add to Reading History (limit history size to 1000 items to conserve memory)
    final newEntry = LocalReadingHistory(
      surahId: surahId,
      surahName: surahName,
      ayahNumber: ayahNumber,
      timestamp: now,
      secondsSpent: secondsSpent,
    );

    var newHistory = [newEntry, ...state.history];
    if (newHistory.length > 1000) {
      newHistory = newHistory.sublist(0, 1000);
    }

    state = state.copyWith(
      history: newHistory,
      lastRead: newLastRead,
    );

    await _save();
  }

  Future<void> clearHistory() async {
    state = const ReadingTrackerState(history: [], lastRead: null);
    await _prefs.remove(_historyKey);
    await _prefs.remove(_lastReadKey);
  }

  Future<void> _save() async {
    final rawHistory = state.history.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_historyKey, rawHistory);

    if (state.lastRead != null) {
      await _prefs.setString(_lastReadKey, jsonEncode(state.lastRead!.toJson()));
    }
  }

  // ── Stats Calculations ──

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

  Map<String, dynamic> calculateStreak() {
    if (state.history.isEmpty) {
      return {
        'current_streak': 0,
        'longest_streak': 0,
        'today_read': false,
      };
    }

    final uniqueDates = state.history
        .map((h) => DateTime(h.timestamp.year, h.timestamp.month, h.timestamp.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // Descending order

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayRead = uniqueDates.contains(today);
    final yesterdayRead = uniqueDates.contains(yesterday);

    if (!todayRead && !yesterdayRead) {
      return {
        'current_streak': 0,
        'longest_streak': calculateLongestStreak(),
        'today_read': false,
      };
    }

    int currentStreak = 0;
    DateTime checkDate = todayRead ? today : yesterday;

    while (uniqueDates.contains(checkDate)) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return {
      'current_streak': currentStreak,
      'longest_streak': calculateLongestStreak(),
      'today_read': todayRead,
    };
  }

  int calculateLongestStreak() {
    if (state.history.isEmpty) return 0;

    final uniqueDates = state.history
        .map((h) => DateTime(h.timestamp.year, h.timestamp.month, h.timestamp.day))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b)); // Ascending order

    int longest = 0;
    int current = 0;
    DateTime? prevDate;

    for (final date in uniqueDates) {
      if (prevDate == null) {
        current = 1;
      } else {
        final diff = date.difference(prevDate).inDays;
        if (diff == 1) {
          current++;
        } else if (diff > 1) {
          current = 1;
        }
      }
      if (current > longest) {
        longest = current;
      }
      prevDate = date;
    }

    return longest;
  }

  int getTotalUniqueAyahsRead() {
    // Unique key: surahId-ayahNumber
    return state.history.map((h) => '${h.surahId}-${h.ayahNumber}').toSet().length;
  }

  int getTotalTimeSpentSeconds() {
    return state.history.fold(0, (sum, item) => sum + item.secondsSpent);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider Definition
// ─────────────────────────────────────────────────────────────────────────────

final readingTrackerProvider =
    StateNotifierProvider<ReadingTrackerNotifier, ReadingTrackerState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ReadingTrackerNotifier(prefs);
});
