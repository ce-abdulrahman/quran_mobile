class TajweedRuleModel {
  final int id;
  final String name;
  final String nameKu;
  final String? nameAr;
  final String slug;
  final String? category;
  final String? colorCode;
  final String description;
  final String descriptionKu;
  final String? exampleText;
  final int priority;
  final bool isActive;

  const TajweedRuleModel({
    required this.id,
    required this.name,
    required this.nameKu,
    this.nameAr,
    required this.slug,
    this.category,
    this.colorCode,
    required this.description,
    required this.descriptionKu,
    this.exampleText,
    required this.priority,
    required this.isActive,
  });

  factory TajweedRuleModel.fromJson(Map<String, dynamic> json) {
    return TajweedRuleModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameKu: json['name_ku'] as String? ?? json['name'] as String? ?? '',
      nameAr: json['name_ar'] as String?,
      slug: json['slug'] as String? ?? '',
      category: json['category'] as String?,
      colorCode: json['color_code'] as String?,
      description: json['description'] as String? ?? '',
      descriptionKu: json['description_ku'] as String? ?? json['description'] as String? ?? '',
      exampleText: json['example_text'] as String?,
      priority: json['priority'] as int? ?? 0,
      isActive: json['is_active'] is bool 
          ? json['is_active'] as bool 
          : (json['is_active'] == 1 || json['is_active'] == '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ku': nameKu,
      'name_ar': nameAr,
      'slug': slug,
      'category': category,
      'color_code': colorCode,
      'description': description,
      'description_ku': descriptionKu,
      'example_text': exampleText,
      'priority': priority,
      'is_active': isActive,
    };
  }
}
