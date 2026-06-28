import 'dart:convert';
import 'package:flutter/services.dart';
import '../cache/cache_manager.dart';
import '../network/api_client.dart';
import '../network/api_result.dart';
import '../network/api_constants.dart';
import '../providers/hadith_provider.dart';

class HadithRepository {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  HadithRepository(this._apiClient, this._cacheManager);

  /// Fetch all hadith categories. Loads from Laravel API with offline fallback.
  Future<ApiResult<List<HadithCategory>>> getHadiths({bool forceRefresh = false}) async {
    const cacheKey = 'cache_hadith_categories';

    if (!forceRefresh) {
      final cachedJson = _cacheManager.get(cacheKey);
      if (cachedJson != null && cachedJson is List) {
        try {
          final categories = cachedJson.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>)).toList();
          return ApiSuccess(categories);
        } catch (_) {}
      }
    }

    try {
      final response = await _apiClient.get(ApiConstants.hadiths);
      final responseData = response.data;
      if (responseData is Map<String, dynamic> && (responseData['status'] == 'success' || responseData['success'] == true)) {
        final rawList = responseData['data'] as List;
        final categories = rawList.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>)).toList();

        // Cache it for future offline usage (7 days)
        await _cacheManager.set(cacheKey, rawList, const Duration(days: 7));
        return ApiSuccess(categories);
      } else {
        return _fallbackToLocalAssets(cacheKey, 'سەرکەوتوو نەبوو لە وەرگرتنی داتا لە ڕاژەکار');
      }
    } catch (e) {
      return _fallbackToLocalAssets(cacheKey, e.toString());
    }
  }

  Future<ApiResult<List<HadithCategory>>> _fallbackToLocalAssets(String cacheKey, String errorMsg) async {
    // 1. Try local CacheManager cache first
    final cachedJson = _cacheManager.get(cacheKey);
    if (cachedJson != null && cachedJson is List) {
      try {
        final categories = cachedJson.map((e) => HadithCategory.fromJson(e as Map<String, dynamic>)).toList();
        return ApiSuccess(categories);
      } catch (_) {}
    }

    // 2. Fallback to parsing and grouping flat hadiths.json
    try {
      final jsonString = await rootBundle.loadString('assets/data/hadiths.json');
      final rawList = jsonDecode(jsonString) as List;

      if (rawList.isEmpty) return const ApiSuccess([]);

      final first = rawList.first as Map<String, dynamic>;
      if (first.containsKey('hadiths')) {
        // Categorized format
        final categories = rawList
            .map((e) => HadithCategory.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiSuccess(categories);
      }

      // New flat format from imanikurd
      final items = rawList.map((e) {
        final m = e as Map<String, dynamic>;
        return HadithItem(
          id: m['id'] as int? ?? 0,
          categoryId: m['category_id'] as int? ?? 1,
          arabicText: m['arabic_text'] as String? ?? '',
          translationKu: m['translation_ku'] as String? ?? '',
          narrator: m['narrator'] as String?,
          source: m['source'] as String?,
          explanationKu: m['explanation_ku'] as String?,
          order: m['order'] as int? ?? 0,
          isActive: m['is_active'] != false,
        );
      }).toList();

      // Group by source book
      final Map<String, List<HadithItem>> groups = {};
      for (final h in items) {
        final key = _sourceKey(h.source);
        groups.putIfAbsent(key, () => []).add(h);
      }

      // Build category list (sorted by count desc)
      final sortedKeys = groups.keys.toList()
        ..sort((a, b) => groups[b]!.length.compareTo(groups[a]!.length));

      final categories = sortedKeys.asMap().entries.map((entry) {
        final idx = entry.key + 1;
        final key = entry.value;
        final hadiths = groups[key]!;
        return HadithCategory(
          id: idx,
          nameKu: _sourceNameKu(key),
          nameAr: _sourceNameAr(key),
          nameEn: null,
          icon: _sourceIcon(key),
          order: idx,
          isActive: true,
          hadiths: hadiths,
        );
      }).toList();

      return ApiSuccess(categories);
    } catch (e) {
      return ApiError('$errorMsg | فایلی ناوخۆیی بار نەکرا: $e');
    }
  }

  /// Extract canonical source key from source string like "رواه البخاري ٨"
  String _sourceKey(String? source) {
    if (source == null || source.isEmpty) return 'other';
    final s = source.toLowerCase();
    if (s.contains('بخاري') || s.contains('bukhari')) return 'bukhari';
    if (s.contains('مسلم') || s.contains('muslim')) return 'muslim';
    if (s.contains('ترمذي') || s.contains('tirmidhi')) return 'tirmidhi';
    if (s.contains('أبو داود') || s.contains('abu dawud')) return 'abudawud';
    if (s.contains('نسائي') || s.contains('nasai')) return 'nasai';
    if (s.contains('ابن ماجه') || s.contains('ibn majah')) return 'ibnmajah';
    if (s.contains('أحمد') || s.contains('ahmad')) return 'ahmad';
    return 'other';
  }

  String _sourceIcon(String key) {
    const icons = {
      'bukhari': 'menu_book_rounded',
      'muslim': 'library_books_rounded',
      'tirmidhi': 'shield_rounded',
      'abudawud': 'mosque_rounded',
      'nasai': 'star_rounded',
      'ibnmajah': 'favorite_rounded',
      'ahmad': 'shield_rounded',
      'other': 'menu_book_rounded',
    };
    return icons[key] ?? 'menu_book_rounded';
  }

  String _sourceNameKu(String key) {
    const names = {
      'bukhari': 'بخاری',
      'muslim': 'موسلیم',
      'tirmidhi': 'ترمیزی',
      'abudawud': 'ئەبوداود',
      'nasai': 'نەسائی',
      'ibnmajah': 'ئیبن ماجە',
      'ahmad': 'ئەحمەد',
      'other': 'گشتی',
    };
    return names[key] ?? 'گشتی';
  }

  String _sourceNameAr(String key) {
    const names = {
      'bukhari': 'البخاري',
      'muslim': 'مسلم',
      'tirmidhi': 'الترمذي',
      'abudawud': 'أبو داود',
      'nasai': 'النسائي',
      'ibnmajah': 'ابن ماجه',
      'ahmad': 'أحمد',
      'other': 'عام',
    };
    return names[key] ?? 'عام';
  }
}
