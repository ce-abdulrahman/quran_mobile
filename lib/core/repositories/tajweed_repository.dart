import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import '../models/tajweed_rule_model.dart';
import '../models/tajweed_category_model.dart';
import '../network/api_result.dart';

class TajweedRepository {
  final Isar _isar = IsarService.instance.isar;

  TajweedRepository([dynamic a, dynamic b]); // Match provider signature

  /// Fetch all active Tajweed rules. Reads exclusively from Isar.
  Future<ApiResult<List<TajweedRuleModel>>> getTajweedRules({bool forceRefresh = false}) async {
    try {
      final collections = await _isar.tajweedRuleCollections.where().findAll();
      
      if (collections.isEmpty) {
        return const ApiError('یاساکانی تەجوید بارنەکراون. تکایە پەیجی سپڵاش بکەرەوە.');
      }

      final rules = collections.map((r) => TajweedRuleModel(
        id: r.id,
        slug: r.ruleSlug,
        name: r.nameEn,
        nameKu: r.nameKu,
        nameAr: r.nameAr,
        colorCode: r.colorCode,
        description: r.description ?? '',
        descriptionKu: r.description ?? '',
        priority: r.rulePriority,
        isActive: true,
      )).toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));

      return ApiSuccess(rules);
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  /// Fetch all active Tajweed categories (with nested rules). Reads exclusively from Isar.
  Future<ApiResult<List<TajweedCategoryModel>>> getTajweedCategories({bool forceRefresh = false}) async {
    try {
      final collections = await _isar.tajweedRuleCollections.where().findAll();

      if (collections.isEmpty) {
        return const ApiError('یاساکانی تەجوید بارنەکراون. تکایە پەیجی سپڵاش بکەرەوە.');
      }

      final Map<int, List<TajweedRuleModel>> categoryRules = {};
      final Map<int, TajweedRuleCollection> categoryMeta = {};

      for (final r in collections) {
        categoryRules.putIfAbsent(r.categoryId, () => []).add(TajweedRuleModel(
          id: r.id,
          slug: r.ruleSlug,
          name: r.nameEn,
          nameKu: r.nameKu,
          nameAr: r.nameAr,
          colorCode: r.colorCode,
          description: r.description ?? '',
          descriptionKu: r.description ?? '',
          priority: r.rulePriority,
          isActive: true,
        ));
        categoryMeta[r.categoryId] = r;
      }

      final List<TajweedCategoryModel> categories = [];
      categoryRules.forEach((catId, rulesList) {
        final meta = categoryMeta[catId]!;
        rulesList.sort((a, b) => a.priority.compareTo(b.priority));

        categories.add(TajweedCategoryModel(
          id: catId,
          slug: meta.categorySlug,
          name: meta.categoryNameEn,
          nameKu: meta.categoryNameKu,
          nameAr: meta.categoryNameAr,
          descriptionKu: null,
          order: meta.categoryOrder,
          rules: rulesList,
        ));
      });

      categories.sort((a, b) => a.order.compareTo(b.order));
      return ApiSuccess(categories);
    } catch (e) {
      return ApiError(e.toString());
    }
  }
}
