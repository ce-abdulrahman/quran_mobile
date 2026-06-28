import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';

// Legacy LocalFavorite model kept for backwards compatibility in old views
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

class FavoritesNotifier extends StateNotifier<List<FavoriteCollection>> {
  FavoritesNotifier() : super([]) {
    _load();
  }

  void _load() {
    if (kIsWeb) return;
    try {
      final isar = IsarService.instance.isar;
      state = isar.favoriteCollections.where().sortByCreatedAtDesc().findAllSync();
    } catch (_) {}
  }

  // Backward compatible toggle for Ayahs using the old LocalFavorite class
  Future<void> toggle(LocalFavorite favorite) async {
    final idStr = 'ayah_${favorite.surahId}_${favorite.ayahNumber}';
    final isar = IsarService.instance.isar;

    await isar.writeTxn(() async {
      final existing = await isar.favoriteCollections.filter().favoriteIdEqualTo(idStr).findFirst();
      if (existing != null) {
        await isar.favoriteCollections.delete(existing.id);
      } else {
        final newFav = FavoriteCollection(
          favoriteId: idStr,
          favoritableType: 'ayah',
          favoritableId: favorite.surahId * 1000 + favorite.ayahNumber,
          surahNumber: favorite.surahId,
          ayahNumber: favorite.ayahNumber,
          previewText: favorite.textUthmani,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await isar.favoriteCollections.put(newFav);
      }
    });
    _load();
  }

  // Unified generic toggle
  Future<void> toggleGeneric({
    required String favoritableType,
    required int favoritableId,
    int? surahNumber,
    int? ayahNumber,
    String? previewText,
  }) async {
    final idStr = '${favoritableType}_$favoritableId';
    final isar = IsarService.instance.isar;

    await isar.writeTxn(() async {
      final existing = await isar.favoriteCollections.filter().favoriteIdEqualTo(idStr).findFirst();
      if (existing != null) {
        await isar.favoriteCollections.delete(existing.id);
      } else {
        final newFav = FavoriteCollection(
          favoriteId: idStr,
          favoritableType: favoritableType,
          favoritableId: favoritableId,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          previewText: previewText,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isSynced: false,
        );
        await isar.favoriteCollections.put(newFav);
      }
    });
    _load();
  }

  bool isFavorited(String favoritableType, int favoritableId) {
    final idStr = '${favoritableType}_$favoritableId';
    return state.any((f) => f.favoriteId == idStr);
  }

  bool isAyahFavorited(int surahNumber, int ayahNumber) {
    final idStr = 'ayah_${surahNumber}_$ayahNumber';
    return state.any((f) => f.favoriteId == idStr);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<FavoriteCollection>>((ref) {
  return FavoritesNotifier();
});
