import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/surah_model.dart';
import '../../core/models/ayah_model.dart';
import '../../core/models/reciter_model.dart';
import '../../core/repositories/audio_repository.dart';
import '../../core/providers/app_providers.dart';

class SurahListNotifier extends AsyncNotifier<List<SurahModel>> {
  @override
  Future<List<SurahModel>> build() async {
    final repo = ref.watch(surahRepositoryProvider);
    final result = await repo.getSurahs();
    
    return result.when(
      success: (data) => data,
      error: (message, code, cachedData) {
        if (cachedData != null && cachedData.isNotEmpty) {
          return cachedData;
        }
        throw Exception(message);
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repo = ref.read(surahRepositoryProvider);
    final result = await repo.getSurahs(forceRefresh: true);
    
    state = result.when(
      success: (data) => AsyncValue.data(data),
      error: (message, code, cachedData) {
        if (cachedData != null && cachedData.isNotEmpty) {
          return AsyncValue.data(cachedData);
        }
        return AsyncValue.error(Exception(message), StackTrace.current);
      },
    );
  }
}

final surahListProvider = AsyncNotifierProvider<SurahListNotifier, List<SurahModel>>(
  SurahListNotifier.new,
);

final ayahsProvider = FutureProvider.family<List<AyahModel>, int>((ref, surahId) async {
  final repo = ref.watch(surahRepositoryProvider);
  final result = await repo.getAyahs(surahId, forceRefresh: true);
  
  return result.when(
    success: (data) => data,
    error: (message, code, cachedData) {
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData;
      }
      throw Exception(message);
    },
  );
});

final recitersProvider = FutureProvider<List<ReciterModel>>((ref) async {
  final repo = ref.watch(audioRepositoryProvider);
  final result = await repo.getReciters();
  return result.when(
    success: (data) => data,
    error: (message, _, __) => throw Exception(message),
  );
});

class SurahAudioFamilyParam {
  final int surahId;
  final int reciterId;

  const SurahAudioFamilyParam({
    required this.surahId,
    required this.reciterId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahAudioFamilyParam &&
          runtimeType == other.runtimeType &&
          surahId == other.surahId &&
          reciterId == other.reciterId;

  @override
  int get hashCode => surahId.hashCode ^ reciterId.hashCode;
}

final surahAudioProvider = FutureProvider.family<SurahAudioResponse, SurahAudioFamilyParam>((ref, param) async {
  final repo = ref.watch(audioRepositoryProvider);
  final result = await repo.getSurahAudio(param.surahId, param.reciterId);
  return result.when(
    success: (data) => data,
    error: (message, _, __) => throw Exception(message),
  );
});

final pageAyahsProvider = FutureProvider.family<List<AyahModel>, int>((ref, pageNumber) async {
  final repo = ref.watch(surahRepositoryProvider);
  final result = await repo.getPageAyahs(pageNumber, forceRefresh: true);
  
  return result.when(
    success: (data) => data,
    error: (message, code, cachedData) {
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData;
      }
      throw Exception(message);
    },
  );
});

