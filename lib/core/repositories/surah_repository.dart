import 'dart:convert';
import 'package:flutter/services.dart';
import '../cache/cache_manager.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/banner_model.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/api_result.dart';

class SurahRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  SurahRepository(this._apiClient, this._cacheManager);

  /// Fetch all Surahs. Uses Cache-First strategy.
  Future<ApiResult<List<SurahModel>>> getSurahs({bool forceRefresh = false}) async {
    const cacheKey = 'cache_surahs';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        final cachedList = cachedJson.map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(cachedList);
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.surahs);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final surahs = rawList.map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
        
        // Cache it
        await _cacheManager.set(cacheKey, rawList, ApiConstants.surahsTtl);
        return ApiSuccess(surahs);
      } else {
        return const ApiError('هەڵەیەک لە داڕشتەی داتاکاندا هەیە');
      }
    } on ApiException catch (e) {
      // If error but we have cached data, return the cache wrapped in ApiError
      final cachedJson = _cacheManager.get(cacheKey);
      List<SurahModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        cachedList = cachedJson.map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedList);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<SurahModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        cachedList = cachedJson.map((e) => SurahModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return ApiError(e.toString(), cachedData: cachedList);
    }
  }

  /// Fetch all Ayahs for a Surah. Uses Cache-First strategy.
  Future<ApiResult<List<AyahModel>>> getAyahs(int surahId, {bool forceRefresh = false}) async {
    final cacheKey = 'cache_ayahs_$surahId';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        final cachedList = cachedJson.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(cachedList);
      }
    }

    try {
      final response = await _apiClient.get(
        ApiConstants.ayahs(surahId),
        queryParameters: {'per_page': 500},
      );
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawData = responseData['data'];
        List? rawList;

        if (rawData is List) {
          rawList = rawData;
        } else if (rawData is Map<String, dynamic>) {
          if (rawData.containsKey('ayahs') && rawData['ayahs'] is List) {
            rawList = rawData['ayahs'] as List;
          } else if (rawData.containsKey('data') && rawData['data'] is List) {
            rawList = rawData['data'] as List;
          }
        }

        if (rawList != null) {
          final ayahs = rawList.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();

          // Cache it
          await _cacheManager.set(cacheKey, rawList, ApiConstants.ayahsTtl);
          return ApiSuccess(ayahs);
        } else {
          return _fallbackToLocalAssets(surahId, cacheKey, 'هەڵەیەک لە داڕشتەی ئایەتەکاندا هەیە');
        }
      } else {
        return _fallbackToLocalAssets(surahId, cacheKey, 'سەرکەوتوو نەبوو لە بارکردنی ئایەتەکان');
      }
    } catch (e) {
      return _fallbackToLocalAssets(surahId, cacheKey, e.toString());
    }
  }

  Future<ApiResult<List<AyahModel>>> _fallbackToLocalAssets(int surahId, String cacheKey, String errorMsg) async {
    // 1. Try local cache first
    final cachedJson = _cacheManager.get(cacheKey);
    if (cachedJson != null && cachedJson is List) {
      try {
        final cachedList = cachedJson.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(cachedList);
      } catch (_) {}
    }

    // 2. Fallback to local assets/data/quran/surah_$surahId.json
    try {
      final jsonString = await rootBundle.loadString('assets/data/quran/surah_$surahId.json');
      final rawList = jsonDecode(jsonString) as List;
      final ayahs = rawList.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
      return ApiSuccess(ayahs);
    } catch (e) {
      return ApiError('$errorMsg | فایلی ناوخۆیی بار نەکرا: $e');
    }
  }

  /// Fetch the deterministic Verse of the Day. Uses Cache-First strategy.
  Future<ApiResult<AyahModel>> getDailyVerse({bool forceRefresh = false}) async {
    const cacheKey = 'cache_daily_verse';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is Map<String, dynamic>) {
        return ApiSuccess(AyahModel.fromJson(cachedJson));
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.dailyVerse);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawMap = responseData['data'] as Map<String, dynamic>;
        final ayah = AyahModel.fromJson(rawMap);

        // Cache it
        await _cacheManager.set(cacheKey, rawMap, ApiConstants.dailyVerseTtl);
        return ApiSuccess(ayah);
      } else {
        return const ApiError('هەڵەیەک لە داڕشتەی ئایەتی ڕۆژدا هەیە');
      }
    } on ApiException catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      AyahModel? cachedAyah;
      if (cachedJson != null && cachedJson is Map<String, dynamic>) {
        cachedAyah = AyahModel.fromJson(cachedJson);
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedAyah);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      AyahModel? cachedAyah;
      if (cachedJson != null && cachedJson is Map<String, dynamic>) {
        cachedAyah = AyahModel.fromJson(cachedJson);
      }
      return ApiError(e.toString(), cachedData: cachedAyah);
    }
  }

  /// Fetch all Ayahs for a page. Uses Cache-First strategy.
  Future<ApiResult<List<AyahModel>>> getPageAyahs(int pageNumber, {bool forceRefresh = false}) async {
    final cacheKey = 'cache_page_$pageNumber';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        final cachedList = cachedJson.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(cachedList);
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.pageAyahs(pageNumber));
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawData = responseData['data'];
        List? rawList;

        if (rawData is List) {
          rawList = rawData;
        } else if (rawData is Map<String, dynamic>) {
          if (rawData.containsKey('ayahs') && rawData['ayahs'] is List) {
            rawList = rawData['ayahs'] as List;
          } else if (rawData.containsKey('data') && rawData['data'] is List) {
            rawList = rawData['data'] as List;
          }
        }

        if (rawList != null) {
          final ayahs = rawList.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();

          // Cache it
          await _cacheManager.set(cacheKey, rawList, ApiConstants.ayahsTtl);
          return ApiSuccess(ayahs);
        } else {
          return const ApiError('هەڵەیەک لە داڕشتەی ئایەتەکاندا هەیە');
        }
      } else {
        return const ApiError('سەرکەوتوو نەبوو لە بارکردنی لاپەڕەکە');
      }
    } on ApiException catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<AyahModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        cachedList = cachedJson.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedList);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<AyahModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        cachedList = cachedJson.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return ApiError(e.toString(), cachedData: cachedList);
    }
  }

  /// Fetch all active banners. Uses Network-First with Cache fallback strategy.
  Future<ApiResult<List<BannerModel>>> getBanners({bool forceRefresh = false}) async {
    const cacheKey = 'cache_banners';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        final cachedList = cachedJson.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(cachedList);
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.banners);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['status'] == 'success') {
        final rawList = responseData['data'] as List;
        final banners = rawList.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();

        // Cache it
        await _cacheManager.set(cacheKey, rawList, const Duration(hours: 4));
        return ApiSuccess(banners);
      } else {
        return const ApiError('هەڵەیەک لە داڕشتەی بانەرەکاندا هەیە');
      }
    } on ApiException catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<BannerModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        cachedList = cachedJson.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return ApiError(e.message, statusCode: e.statusCode, cachedData: cachedList);
    } catch (e) {
      final cachedJson = _cacheManager.get(cacheKey);
      List<BannerModel>? cachedList;
      if (cachedJson != null && cachedJson is List) {
        cachedList = cachedJson.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return ApiError(e.toString(), cachedData: cachedList);
    }
  }
}
