import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local_db/isar_collections.dart';
import '../network/api_result.dart';
import '../repositories/tafsir_repository.dart';

final tafsirRepositoryProvider = Provider<TafsirRepository>((ref) {
  return TafsirRepository();
});

/// Identifies one ayah. Riverpod families compare arguments by value, so this
/// needs equality — without it every rebuild would spawn a fresh provider and
/// re-query Isar.
class AyahRef {
  final int surahNumber;
  final int ayahNumber;

  const AyahRef({required this.surahNumber, required this.ayahNumber});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahRef &&
          other.surahNumber == surahNumber &&
          other.ayahNumber == ayahNumber;

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber);
}

/// Tafsir for one ayah. `null` data means the package is installed but has
/// nothing for this ayah; an error means it isn't installed at all.
final ayahTafsirProvider =
    FutureProvider.family<ApiResult<TafsirCollection?>, AyahRef>(
  (ref, ayah) async {
    final repo = ref.watch(tafsirRepositoryProvider);
    return repo.getForAyah(
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
    );
  },
);

/// Whether the tafsir package is installed, for gating entry points.
final tafsirInstalledProvider = FutureProvider<bool>((ref) async {
  return ref.watch(tafsirRepositoryProvider).isInstalled();
});
