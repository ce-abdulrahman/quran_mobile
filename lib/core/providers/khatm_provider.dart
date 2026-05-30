import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Local Khatm Plan Model
// ─────────────────────────────────────────────────────────────────────────────

class LocalKhatmPlan {
  final String id;
  final String title;
  final DateTime startDate;
  final int targetDays;
  final bool isCompleted;
  final DateTime? completedDate;

  const LocalKhatmPlan({
    required this.id,
    required this.title,
    required this.startDate,
    required this.targetDays,
    this.isCompleted = false,
    this.completedDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'startDate': startDate.toIso8601String(),
        'targetDays': targetDays,
        'isCompleted': isCompleted,
        'completedDate': completedDate?.toIso8601String(),
      };

  factory LocalKhatmPlan.fromJson(Map<String, dynamic> json) => LocalKhatmPlan(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? 'ختمی قورئان',
        startDate: DateTime.parse(json['startDate'] as String),
        targetDays: json['targetDays'] as int? ?? 30,
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedDate: json['completedDate'] != null
            ? DateTime.parse(json['completedDate'] as String)
            : null,
      );

  LocalKhatmPlan copyWith({
    String? id,
    String? title,
    DateTime? startDate,
    int? targetDays,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return LocalKhatmPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      targetDays: targetDays ?? this.targetDays,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Khatm Notifier
// ─────────────────────────────────────────────────────────────────────────────

class KhatmNotifier extends StateNotifier<LocalKhatmPlan?> {
  final SharedPreferences _prefs;
  static const _key = 'active_khatm_plan';

  KhatmNotifier(this._prefs) : super(null) {
    _load();
  }

  void _load() {
    final raw = _prefs.getString(_key);
    if (raw != null) {
      try {
        state = LocalKhatmPlan.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {}
    }
  }

  Future<void> startKhatm(String title, int targetDays) async {
    final plan = LocalKhatmPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'ختمی نوێ' : title,
      startDate: DateTime.now(),
      targetDays: targetDays <= 0 ? 30 : targetDays,
    );
    state = plan;
    await _save();
  }

  Future<void> deleteKhatm() async {
    state = null;
    await _prefs.remove(_key);
  }

  Future<void> checkCompletion(int currentReadCount) async {
    if (state == null || state!.isCompleted) return;
    
    // Quran total Ayahs = 6236
    if (currentReadCount >= 6236) {
      state = state!.copyWith(
        isCompleted: true,
        completedDate: DateTime.now(),
      );
      await _save();
    }
  }

  Future<void> _save() async {
    if (state != null) {
      await _prefs.setString(_key, jsonEncode(state!.toJson()));
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider Definition
// ─────────────────────────────────────────────────────────────────────────────

final khatmProvider = StateNotifierProvider<KhatmNotifier, LocalKhatmPlan?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return KhatmNotifier(prefs);
});
