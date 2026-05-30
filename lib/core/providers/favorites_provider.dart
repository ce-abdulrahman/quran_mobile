import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_providers.dart';

class LocalFavorite {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final String textUthmani;
  final String? textKu;
  final String? textEn;

  const LocalFavorite({
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.textUthmani,
    this.textKu,
    this.textEn,
  });

  Map<String, dynamic> toJson() => {
        'surahId': surahId,
        'surahName': surahName,
        'ayahNumber': ayahNumber,
        'textUthmani': textUthmani,
        'textKu': textKu,
        'textEn': textEn,
      };

  factory LocalFavorite.fromJson(Map<String, dynamic> json) => LocalFavorite(
        surahId: json['surahId'] as int? ?? 0,
        surahName: json['surahName'] as String? ?? '',
        ayahNumber: json['ayahNumber'] as int? ?? 0,
        textUthmani: json['textUthmani'] as String? ?? '',
        textKu: json['textKu'] as String?,
        textEn: json['textEn'] as String?,
      );
}

class FavoritesNotifier extends StateNotifier<List<LocalFavorite>> {
  final SharedPreferences _prefs;
  static const _key = 'local_favorites';

  FavoritesNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final raw = _prefs.getStringList(_key);
    if (raw != null) {
      try {
        state = raw
            .map((e) => LocalFavorite.fromJson(jsonDecode(e) as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }
  }

  Future<void> toggle(LocalFavorite favorite) async {
    final index = state.indexWhere((f) =>
        f.surahId == favorite.surahId && f.ayahNumber == favorite.ayahNumber);
    if (index != -1) {
      state = state.where((f) =>
          !(f.surahId == favorite.surahId && f.ayahNumber == favorite.ayahNumber))
          .toList();
    } else {
      state = [...state, favorite];
    }
    await _save();
  }

  bool isFavorited(int surahId, int ayahNumber) {
    return state.any((f) => f.surahId == surahId && f.ayahNumber == ayahNumber);
  }

  Future<void> _save() async {
    final raw = state.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs.setStringList(_key, raw);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<LocalFavorite>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesNotifier(prefs);
});
