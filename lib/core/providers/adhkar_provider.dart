import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Adhkar Item Model
// ─────────────────────────────────────────────────────────────────────────────

class AdhkarItem {
  final int id;
  final int categoryId;
  final String text;
  final String translation;
  final String benefit;
  final int targetCount;
  final String? source;

  const AdhkarItem({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.translation,
    required this.benefit,
    required this.targetCount,
    this.source,
  });

  factory AdhkarItem.fromJson(Map<String, dynamic> json) {
    return AdhkarItem(
      id: json['id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      text: json['arabic_text'] as String? ?? '',
      translation: json['translation_ku'] as String? ?? json['translation_en'] as String? ?? '',
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

class AdhkarNotifier extends StateNotifier<Map<String, String>> {
  final SharedPreferences _prefs;
  static const _key = 'adhkar_completed_sessions';

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
    final todayStr = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    final newState = {...state, categoryKey: todayStr};
    state = newState;
    await _prefs.setString(_key, jsonEncode(newState));
  }

  bool isCompletedToday(String categoryKey) {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    return state[categoryKey] == todayStr;
  }

  Future<void> resetCategory(String categoryKey) async {
    final newState = {...state};
    newState.remove(categoryKey);
    state = newState;
    await _prefs.setString(_key, jsonEncode(newState));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider Definition
// ─────────────────────────────────────────────────────────────────────────────

final adhkarProvider = StateNotifierProvider<AdhkarNotifier, Map<String, String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AdhkarNotifier(prefs);
});
