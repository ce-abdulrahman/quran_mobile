import 'package:isar/isar.dart';

import '../local_db/isar_collections.dart';
import '../local_db/isar_service.dart';
import '../network/api_result.dart';

/// Reads tafsir straight out of Isar.
///
/// Tafsir ships as a downloadable content package rather than with the app, so
/// an empty result is the normal state until the user installs it — the caller
/// is expected to offer the download instead of treating it as a failure.
class TafsirRepository {
  final Isar _isar = IsarService.instance.isar;

  TafsirRepository();

  /// Whether any tafsir at all is installed.
  Future<bool> isInstalled() async {
    final count = await _isar.tafsirCollections.count();
    return count > 0;
  }

  /// Tafsir for a single ayah.
  ///
  /// Returns an [ApiError] carrying a reader-facing message when the package is
  /// missing entirely, and `null` data when the package is installed but has no
  /// entry for this particular ayah.
  Future<ApiResult<TafsirCollection?>> getForAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    try {
      if (!await isInstalled()) {
        return const ApiError('پاکێجی تەفسیر دانەگیراوە.');
      }

      final entry = await _isar.tafsirCollections
          .filter()
          .surahNumberEqualTo(surahNumber)
          .ayahNumberEqualTo(ayahNumber)
          .findFirst();

      return ApiSuccess(entry);
    } catch (e) {
      return ApiError('کێشە لە خوێندنەوەی تەفسیر: $e');
    }
  }

  /// Every ayah of a surah that has tafsir, keyed by ayah number.
  Future<Map<int, TafsirCollection>> getForSurah(int surahNumber) async {
    try {
      final entries = await _isar.tafsirCollections
          .filter()
          .surahNumberEqualTo(surahNumber)
          .findAll();

      return {for (final e in entries) e.ayahNumber: e};
    } catch (_) {
      return const {};
    }
  }
}
