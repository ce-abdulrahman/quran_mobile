import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/banner_model.dart';
import '../models/tajweed_segment_model.dart';
import '../network/api_client.dart';
import '../network/api_result.dart';

class SurahRepository {
  final ApiClient _apiClient;
  final Isar _isar = IsarService.instance.isar;

  SurahRepository(this._apiClient, [dynamic _]); // Match constructor signature

  /// Fetch all Surahs. Reads exclusively from Isar.
  Future<ApiResult<List<SurahModel>>> getSurahs({bool forceRefresh = false}) async {
    try {
      final collections = await _isar.surahCollections.where().sortByNumber().findAll();
      
      if (collections.isEmpty) {
        return const ApiError('قورئانی پیرۆز هێشتا بارنەکراوە. تکایە پەیجی سپڵاش بکەرەوە.');
      }

      final list = collections.map((c) => SurahModel(
        id: c.number,
        number: c.number,
        nameAr: c.nameAr,
        nameEn: c.nameEn,
        nameKu: c.nameKu,
        totalAyahs: c.totalAyahs,
        revelationType: c.revelationType,
        pageStart: c.pageStart,
        pageEnd: c.pageEnd,
      )).toList();

      return ApiSuccess(list);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch all Ayahs for a Surah. Reads exclusively from Isar.
  Future<ApiResult<List<AyahModel>>> getAyahs(int surahId, {bool forceRefresh = false}) async {
    try {
      final collections = await _isar.ayahCollections
          .filter()
          .surahNumberEqualTo(surahId)
          .sortByAyahNumber()
          .findAll();

      if (collections.isEmpty) {
        return ApiError('ئایەتەکانی سوورەتی $surahId نەدۆزرانەوە لە بنکەی زانیاری.');
      }

      // Load Surah metadata for mapping
      final surahCol = await _isar.surahCollections.filter().numberEqualTo(surahId).findFirst();
      final surahModel = surahCol != null 
          ? SurahModel(
              id: surahCol.number,
              number: surahCol.number,
              nameAr: surahCol.nameAr,
              nameEn: surahCol.nameEn,
              nameKu: surahCol.nameKu,
              totalAyahs: surahCol.totalAyahs,
              revelationType: surahCol.revelationType,
              pageStart: surahCol.pageStart,
              pageEnd: surahCol.pageEnd,
            )
          : null;

      final list = collections.map((a) {
        final segments = (a.tajweedSegments ?? []).map((s) => TajweedSegmentModel(
          textSegment: s.textSegment ?? '',
          startIndex: s.startIndex,
          endIndex: s.endIndex,
          ruleId: s.ruleId,
          colorId: s.colorId,
          connectsToLeft: s.connectsToLeft,
          connectsToRight: s.connectsToRight,
        )).toList();

        return AyahModel(
          id: a.ayahId,
          ayahNumber: a.ayahNumber,
          textUthmani: a.textUthmani,
          textEn: a.textEn,
          textKu: a.textKu,
          surah: surModelWithNumber(surahModel, a.surahNumber),
          pageNumber: a.pageNumber,
          juzNumber: a.juzNumber,
          hizbNumber: a.hizbNumber,
          rubNumber: a.rubNumber,
          tajweedSegments: segments,
        );
      }).toList();

      return ApiSuccess(list);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  SurahModel? surModelWithNumber(SurahModel? m, int num) {
    if (m != null) return m;
    return SurahModel(
      id: num,
      number: num,
      nameAr: '',
      nameEn: 'Surah $num',
      nameKu: 'سوورەتی $num',
      totalAyahs: 0,
      revelationType: 'Meccan',
    );
  }

  /// Fetch the deterministic Verse of the Day. Reads exclusively from Isar.
  Future<ApiResult<AyahModel>> getDailyVerse({bool forceRefresh = false}) async {
    try {
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
      
      final totalAyahs = await _isar.ayahCollections.count();
      if (totalAyahs == 0) {
        return const ApiError('بنکەی زانیاری قورئان هێشتا بەتاڵە.');
      }

      // Get a deterministic Ayah ID from 1 to totalAyahs
      final int ayahId = (dayOfYear % totalAyahs) + 1;
      
      final a = await _isar.ayahCollections.filter().ayahIdEqualTo(ayahId).findFirst();
      if (a == null) {
        return const ApiError('ئایەتی دیاریکراو نەدۆزرایەوە.');
      }

      final segments = (a.tajweedSegments ?? []).map((s) => TajweedSegmentModel(
        textSegment: s.textSegment ?? '',
        startIndex: s.startIndex,
        endIndex: s.endIndex,
        ruleId: s.ruleId,
        colorId: s.colorId,
        connectsToLeft: s.connectsToLeft,
        connectsToRight: s.connectsToRight,
      )).toList();

      final surahCol = await _isar.surahCollections.filter().numberEqualTo(a.surahNumber).findFirst();
      final surahModel = surahCol != null 
          ? SurahModel(
              id: surahCol.number,
              number: surahCol.number,
              nameAr: surahCol.nameAr,
              nameEn: surahCol.nameEn,
              nameKu: surahCol.nameKu,
              totalAyahs: surahCol.totalAyahs,
              revelationType: surahCol.revelationType,
              pageStart: surahCol.pageStart,
              pageEnd: surahCol.pageEnd,
            )
          : null;

      final ayah = AyahModel(
        id: a.ayahId,
        ayahNumber: a.ayahNumber,
        textUthmani: a.textUthmani,
        textEn: a.textEn,
        textKu: a.textKu,
        surah: surModelWithNumber(surahModel, a.surahNumber),
        pageNumber: a.pageNumber,
        juzNumber: a.juzNumber,
        hizbNumber: a.hizbNumber,
        rubNumber: a.rubNumber,
        tajweedSegments: segments,
      );

      return ApiSuccess(ayah);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch all Ayahs for a page. Reads exclusively from Isar.
  Future<ApiResult<List<AyahModel>>> getPageAyahs(int pageNumber, {bool forceRefresh = false}) async {
    try {
      final collections = await _isar.ayahCollections
          .filter()
          .pageNumberEqualTo(pageNumber)
          .findAll();

      if (collections.isEmpty) {
        return ApiError('ئایەتەکانی لاپەڕەی $pageNumber نەدۆزرانەوە لە بنکەی زانیاری.');
      }

      final List<AyahModel> list = [];
      for (final a in collections) {
        final segments = (a.tajweedSegments ?? []).map((s) => TajweedSegmentModel(
          textSegment: s.textSegment ?? '',
          startIndex: s.startIndex,
          endIndex: s.endIndex,
          ruleId: s.ruleId,
          colorId: s.colorId,
          connectsToLeft: s.connectsToLeft,
          connectsToRight: s.connectsToRight,
        )).toList();

        final surahCol = await _isar.surahCollections.filter().numberEqualTo(a.surahNumber).findFirst();
        final surahModel = surahCol != null 
            ? SurahModel(
                id: surahCol.number,
                number: surahCol.number,
                nameAr: surahCol.nameAr,
                nameEn: surahCol.nameEn,
                nameKu: surahCol.nameKu,
                totalAyahs: surahCol.totalAyahs,
                revelationType: surahCol.revelationType,
                pageStart: surahCol.pageStart,
                pageEnd: surahCol.pageEnd,
              )
            : null;

        list.add(AyahModel(
          id: a.ayahId,
          ayahNumber: a.ayahNumber,
          textUthmani: a.textUthmani,
          textEn: a.textEn,
          textKu: a.textKu,
          surah: surModelWithNumber(surahModel, a.surahNumber),
          pageNumber: a.pageNumber,
          juzNumber: a.juzNumber,
          hizbNumber: a.hizbNumber,
          rubNumber: a.rubNumber,
          tajweedSegments: segments,
        ));
      }

      return ApiSuccess(list);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Banners load safely from API with fallback to empty list (non-blocking).
  Future<ApiResult<List<BannerModel>>> getBanners({bool forceRefresh = false}) async {
    try {
      final response = await _apiClient.get('/banners').timeout(const Duration(seconds: 3));
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final banners = rawList.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(banners);
      }
      return const ApiSuccess([]);
    } catch (_) {
      return const ApiSuccess([]);
    }
  }
}
