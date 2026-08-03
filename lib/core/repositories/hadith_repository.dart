import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import '../providers/hadith_provider.dart';
import '../network/api_result.dart';

class HadithRepository {
  final Isar _isar = IsarService.instance.isar;

  HadithRepository([dynamic a, dynamic b]); // Match constructor signature

  /// Fetch all hadith categories. Reads exclusively from Isar.
  Future<ApiResult<List<HadithCategory>>> getHadiths({bool forceRefresh = false}) async {
    try {
      final collections = await _isar.hadithCollections.where().findAll();

      if (collections.isEmpty) {
        return const ApiError('فەرموودەکان هێشتا بارنەکراون. تکایە پەیجی سپڵاش بکەرەوە.');
      }

      // Group hadith items by categoryId
      final Map<int, List<HadithItem>> groups = {};
      final Map<int, HadithCollection> categoryMeta = {};

      for (final h in collections) {
        final list = groups.putIfAbsent(h.categoryId, () => []);
        // Prevent duplicates based on hadithId
        if (!list.any((item) => item.id == h.hadithId)) {
          list.add(HadithItem(
            id: h.hadithId,
            categoryId: h.categoryId,
            arabicText: h.arabicText,
            translationKu: h.translationKu,
            translationEn: h.translationEn,
            narrator: h.narrator,
            source: h.source,
            explanationKu: h.explanationKu,
            explanationEn: h.explanationEn,
            order: h.order,
            isActive: h.isActive,
          ));
        }
        categoryMeta[h.categoryId] = h;
      }

      final List<HadithCategory> categories = [];
      groups.forEach((catId, items) {
        final meta = categoryMeta[catId]!;
        // Sort items by order
        items.sort((a, b) => a.order.compareTo(b.order));

        categories.add(HadithCategory(
          id: catId,
          nameKu: meta.categoryNameKu,
          nameAr: meta.categoryNameAr,
          nameEn: null,
          icon: _sourceIcon(meta.source),
          order: catId,
          isActive: true,
          hadiths: items,
        ));
      });

      // Sort categories by id/order
      categories.sort((a, b) => a.order.compareTo(b.order));

      return ApiSuccess(categories);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  String _sourceIcon(String? source) {
    if (source == null || source.isEmpty) return 'menu_book_rounded';
    final s = source.toLowerCase();
    if (s.contains('بخاري') || s.contains('bukhari')) return 'menu_book_rounded';
    if (s.contains('مسلم') || s.contains('muslim')) return 'library_books_rounded';
    if (s.contains('ترمذي') || s.contains('tirmidhi')) return 'shield_rounded';
    if (s.contains('أبو داود') || s.contains('abu dawud')) return 'mosque_rounded';
    if (s.contains('نسائي') || s.contains('nasai')) return 'star_rounded';
    if (s.contains('ابن ماجه') || s.contains('ibn majah')) return 'favorite_rounded';
    if (s.contains('أحمد') || s.contains('ahmad')) return 'shield_rounded';
    return 'menu_book_rounded';
  }
}
