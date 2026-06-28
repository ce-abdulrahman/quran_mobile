import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../local_db/isar_collections.dart';
import '../local_db/isar_service.dart';
import '../network/api_client.dart';
import '../providers/app_providers.dart';
import '../services/audio_event_bus.dart';

class AudioFavoritesState {
  final List<int> favoriteReciters;
  final List<int> favoriteSurahs;
  final bool isLoading;

  AudioFavoritesState({
    required this.favoriteReciters,
    required this.favoriteSurahs,
    this.isLoading = false,
  });

  AudioFavoritesState copyWith({
    List<int>? favoriteReciters,
    List<int>? favoriteSurahs,
    bool? isLoading,
  }) {
    return AudioFavoritesState(
      favoriteReciters: favoriteReciters ?? this.favoriteReciters,
      favoriteSurahs: favoriteSurahs ?? this.favoriteSurahs,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AudioFavoritesNotifier extends StateNotifier<AudioFavoritesState> {
  final ApiClient _apiClient;

  AudioFavoritesNotifier(this._apiClient)
      : super(AudioFavoritesState(favoriteReciters: [], favoriteSurahs: [])) {
    _loadFromLocal();
    _fetchFromRemote();
  }

  Future<void> _loadFromLocal() async {
    if (kIsWeb) return;
    try {
      final isar = IsarService.instance.isar;
      final favorites = await isar.audioFavoriteCollections.where().findAll();
      final reciters = favorites
          .where((f) => f.favoritableType == 'reciter')
          .map((f) => f.favoritableId)
          .toList();
      final surahs = favorites
          .where((f) => f.favoritableType == 'surah')
          .map((f) => f.favoritableId)
          .toList();
      state = state.copyWith(
        favoriteReciters: reciters,
        favoriteSurahs: surahs,
      );
    } catch (_) {}
  }

  Future<void> _fetchFromRemote() async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _apiClient.get('audio-favorites');
      final data = response.data['data'];
      final List<int> reciters = List<int>.from(data['reciter_ids'] ?? []);
      final List<int> surahs = List<int>.from(data['surah_ids'] ?? []);

      state = state.copyWith(
        favoriteReciters: reciters,
        favoriteSurahs: surahs,
        isLoading: false,
      );

      if (kIsWeb) return;

      final isar = IsarService.instance.isar;
      await isar.writeTxn(() async {
        await isar.audioFavoriteCollections.clear();
        for (final id in reciters) {
          await isar.audioFavoriteCollections.put(AudioFavoriteCollection(
            favoriteKey: 'reciter_$id',
            favoritableId: id,
            favoritableType: 'reciter',
            createdAt: DateTime.now(),
          ));
        }
        for (final id in surahs) {
          await isar.audioFavoriteCollections.put(AudioFavoriteCollection(
            favoriteKey: 'surah_$id',
            favoritableId: id,
            favoritableType: 'surah',
            createdAt: DateTime.now(),
          ));
        }
      });
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleFavorite(String type, int id) async {
    final isReciter = type == 'reciter';
    final isFav = isReciter
        ? state.favoriteReciters.contains(id)
        : state.favoriteSurahs.contains(id);

    final updatedReciters = List<int>.from(state.favoriteReciters);
    final updatedSurahs = List<int>.from(state.favoriteSurahs);

    if (isFav) {
      if (isReciter) {
        updatedReciters.remove(id);
      } else {
        updatedSurahs.remove(id);
      }
    } else {
      if (isReciter) {
        updatedReciters.add(id);
      } else {
        updatedSurahs.add(id);
      }
    }

    state = state.copyWith(
      favoriteReciters: updatedReciters,
      favoriteSurahs: updatedSurahs,
    );

    if (!kIsWeb) {
      try {
        final isar = IsarService.instance.isar;
        final key = '${type}_$id';
        await isar.writeTxn(() async {
          if (isFav) {
            await isar.audioFavoriteCollections.filter().favoriteKeyEqualTo(key).deleteAll();
          } else {
            await isar.audioFavoriteCollections.put(AudioFavoriteCollection(
              favoriteKey: key,
              favoritableId: id,
              favoritableType: type,
              createdAt: DateTime.now(),
            ));
          }
        });
      } catch (_) {}
    }

    AudioEventBus().fire(FavoriteToggledEvent(
      type: type,
      id: id,
      isFavorite: !isFav,
    ));

    try {
      await _apiClient.post(
        'audio-favorites/toggle',
        data: {
          'favoritable_type': type,
          'favoritable_id': id,
        },
      );
    } catch (e) {
      final revertedReciters = List<int>.from(state.favoriteReciters);
      final revertedSurahs = List<int>.from(state.favoriteSurahs);
      if (isFav) {
        if (isReciter) {
          revertedReciters.add(id);
        } else {
          revertedSurahs.add(id);
        }
      } else {
        if (isReciter) {
          revertedReciters.remove(id);
        } else {
          revertedSurahs.remove(id);
        }
      }

      state = state.copyWith(
        favoriteReciters: revertedReciters,
        favoriteSurahs: revertedSurahs,
      );

      if (!kIsWeb) {
        try {
          final isar = IsarService.instance.isar;
          final key = '${type}_$id';
          await isar.writeTxn(() async {
            if (isFav) {
              await isar.audioFavoriteCollections.put(AudioFavoriteCollection(
                favoriteKey: key,
                favoritableId: id,
                favoritableType: type,
                createdAt: DateTime.now(),
              ));
            } else {
              await isar.audioFavoriteCollections.filter().favoriteKeyEqualTo(key).deleteAll();
            }
          });
        } catch (_) {}
      }

      AudioEventBus().fire(FavoriteToggledEvent(
        type: type,
        id: id,
        isFavorite: isFav,
      ));
    }
  }

  bool isReciterFavorited(int id) => state.favoriteReciters.contains(id);
  bool isSurahFavorited(int id) => state.favoriteSurahs.contains(id);
}

final audioFavoritesProvider =
    StateNotifierProvider<AudioFavoritesNotifier, AudioFavoritesState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AudioFavoritesNotifier(apiClient);
});
