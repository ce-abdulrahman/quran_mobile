import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';
import 'dhikr_time.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Adhkar Item Model
// ─────────────────────────────────────────────────────────────────────────────

class AdhkarItem {
  final int id;
  final int categoryId;
  final String text;
  final String translation;
  final String translationEn;
  final String benefit;
  final int targetCount;
  final String? source;

  const AdhkarItem({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.translation,
    this.translationEn = '',
    required this.benefit,
    required this.targetCount,
    this.source,
  });

  String getTranslation(String localeCode) {
    if (localeCode == 'en' && translationEn.isNotEmpty) {
      return translationEn;
    }
    return translation;
  }

  factory AdhkarItem.fromJson(Map<String, dynamic> json) {
    return AdhkarItem(
      id: json['id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      text: json['arabic_text'] as String? ?? '',
      translation: json['translation_ku'] as String? ?? '',
      translationEn: json['translation_en'] as String? ?? '',
      benefit: json['description'] as String? ?? '',
      targetCount: json['count'] as int? ?? 1,
      source: json['source'] as String?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Adhkar Category Model
// ─────────────────────────────────────────────────────────────────────────────

class AdhkarCategory {
  final int id;
  final String nameKu;
  final String nameAr;
  final String? nameEn;
  final String? icon;
  final int order;
  final bool isActive;
  final List<AdhkarItem> adhkars;

  const AdhkarCategory({
    required this.id,
    required this.nameKu,
    required this.nameAr,
    this.nameEn,
    this.icon,
    required this.order,
    required this.isActive,
    required this.adhkars,
  });

  String getName(String localeCode) {
    if (localeCode == 'en' && nameEn != null && nameEn!.isNotEmpty) {
      return nameEn!;
    }
    return nameKu;
  }

  factory AdhkarCategory.fromJson(Map<String, dynamic> json) {
    final rawAdhkars = json['adhkars'] as List? ?? [];
    final items = rawAdhkars
        .map((x) => AdhkarItem.fromJson(x as Map<String, dynamic>))
        .toList();

    return AdhkarCategory(
      id: json['id'] as int? ?? 0,
      nameKu: json['name_ku'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String?,
      icon: json['icon'] as String?,
      order: json['order'] as int? ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      adhkars: items,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Adhkar Notifier
// ─────────────────────────────────────────────────────────────────────────────

/// Where the user got to in one category's adhkar.
class AdhkarProgress {
  /// Index of the dhikr being recited.
  final int itemIndex;

  /// Repetitions completed of that dhikr.
  final int count;

  const AdhkarProgress({required this.itemIndex, required this.count});

  static const empty = AdhkarProgress(itemIndex: 0, count: 0);

  bool get isEmpty => itemIndex == 0 && count == 0;

  Map<String, dynamic> toJson() => {'index': itemIndex, 'count': count};

  factory AdhkarProgress.fromJson(Map<String, dynamic> json) => AdhkarProgress(
        itemIndex: json['index'] as int? ?? 0,
        count: json['count'] as int? ?? 0,
      );
}

class AdhkarNotifier extends StateNotifier<Map<String, String>> {
  final SharedPreferences _prefs;
  static const _key = 'adhkar_completed_sessions';
  static const _progressKey = 'adhkar_session_progress';

  AdhkarNotifier(this._prefs) : super({}) {
    _load();
  }

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(raw) as Map<String, dynamic>;
        state = decoded.map((k, v) => MapEntry(k, v as String));
      } catch (_) {}
    }
  }

  Future<void> completeCategory(String categoryKey) async {
    final todayStr = dhikrDayKey();
    final newState = {...state, categoryKey: todayStr};
    state = newState;
    await _prefs.setString(_key, jsonEncode(newState));
    // The run is over; a resume offer would be meaningless.
    await clearProgress(categoryKey);
  }

  bool isCompletedToday(String categoryKey) {
    return state[categoryKey] == dhikrDayKey();
  }

  // ── In-progress session ──────────────────────────────────────────────────
  //
  // The session screen used to hold the count and the current dhikr in widget
  // state alone, so leaving the page — a phone call partway through a 100x
  // dhikr — dropped everything and restarted at the first item.

  Map<String, dynamic> _readProgressMap() {
    final raw = _prefs.getString(_progressKey);
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  /// Saved progress for [categoryKey], or [AdhkarProgress.empty].
  ///
  /// Progress is stamped with the day it was made: morning and evening adhkar
  /// are daily acts, so yesterday's half-finished run should not be offered as
  /// something to continue.
  AdhkarProgress progressFor(String categoryKey) {
    final entry = _readProgressMap()[categoryKey];
    if (entry is! Map<String, dynamic>) return AdhkarProgress.empty;
    if (entry['date'] != dhikrDayKey()) return AdhkarProgress.empty;
    return AdhkarProgress.fromJson(entry);
  }

  Future<void> saveProgress(
    String categoryKey, {
    required int itemIndex,
    required int count,
  }) async {
    final map = _readProgressMap();
    map[categoryKey] = {
      'date': dhikrDayKey(),
      ...AdhkarProgress(itemIndex: itemIndex, count: count).toJson(),
    };
    await _prefs.setString(_progressKey, jsonEncode(map));
  }

  Future<void> clearProgress(String categoryKey) async {
    final map = _readProgressMap();
    if (map.remove(categoryKey) == null) return;
    await _prefs.setString(_progressKey, jsonEncode(map));
  }

  Future<void> resetCategory(String categoryKey) async {
    final newState = {...state};
    newState.remove(categoryKey);
    state = newState;
    await _prefs.setString(_key, jsonEncode(newState));
    await clearProgress(categoryKey);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider Definition
// ─────────────────────────────────────────────────────────────────────────────

final adhkarProvider = StateNotifierProvider<AdhkarNotifier, Map<String, String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AdhkarNotifier(prefs);
});
