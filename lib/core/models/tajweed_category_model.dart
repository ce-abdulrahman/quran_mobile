import 'tajweed_rule_model.dart';

class TajweedCategoryModel {
  final int id;
  final String slug;
  final String name;
  final String nameKu;
  final String? nameAr;
  final String? descriptionKu;
  final int order;
  final List<TajweedRuleModel> rules;

  const TajweedCategoryModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.nameKu,
    this.nameAr,
    this.descriptionKu,
    required this.order,
    required this.rules,
  });

  factory TajweedCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawRules = json['rules'] as List? ?? [];
    return TajweedCategoryModel(
      id: json['id'] as int? ?? 0,
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nameKu: json['name_ku'] as String? ?? json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      descriptionKu: json['description_ku'] as String?,
      order: json['order'] as int? ?? 0,
      rules: rawRules
          .map((r) => TajweedRuleModel.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}
