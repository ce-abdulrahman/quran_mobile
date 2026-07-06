import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import '../providers/adhkar_provider.dart';
import '../network/api_result.dart';

class AdhkarRepository {
  final Isar _isar = IsarService.instance.isar;

  AdhkarRepository([dynamic a, dynamic b]); // Match constructor signature

  /// Fetch all active Adhkars grouped by Category. Reads exclusively from Isar.
  Future<ApiResult<List<AdhkarCategory>>> getAdhkars({bool forceRefresh = false}) async {
    try {
      final collections = await _isar.adhkarCollections.where().findAll();

      if (collections.isEmpty) {
        return const ApiError('ئەزکارەکان هێشتا بارنەکراون. تکایە پەیجی سپڵاش بکەرەوە.');
      }

      // Group adhkar items by categoryId
      final Map<int, List<AdhkarItem>> groups = {};
      final Map<int, AdhkarCollection> categoryMeta = {};

      for (final a in collections) {
        groups.putIfAbsent(a.categoryId, () => []).add(AdhkarItem(
          id: a.adhkarId,
          categoryId: a.categoryId,
          text: a.arabicText,
          translation: a.translationKu,
          translationEn: a.translationEn ?? '',
          benefit: a.description ?? '',
          targetCount: a.targetCount,
          source: a.source,
        ));
        categoryMeta[a.categoryId] = a;
      }

      final List<AdhkarCategory> categories = [];
      groups.forEach((catId, items) {
        final meta = categoryMeta[catId]!;
        // Sort items by id/order
        items.sort((a, b) => a.id.compareTo(b.id));

        categories.add(AdhkarCategory(
          id: catId,
          nameKu: meta.categoryNameKu,
          nameAr: meta.categoryNameAr,
          nameEn: meta.categoryNameEn,
          icon: meta.categoryIcon,
          order: meta.categoryOrder,
          isActive: true,
          adhkars: items,
        ));
      });

      // Sort categories by order
      categories.sort((a, b) => a.order.compareTo(b.order));

      return ApiSuccess(categories);
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
