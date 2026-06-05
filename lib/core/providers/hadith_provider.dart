
// ─────────────────────────────────────────────────────────────────────────────
// Hadith Item Model
// ─────────────────────────────────────────────────────────────────────────────

class HadithItem {
  final int id;
  final int categoryId;
  final String arabicText;
  final String translationKu;
  final String? translationEn;
  final String? narrator;
  final String? source;
  final String? explanationKu;
  final String? explanationEn;
  final int order;
  final bool isActive;

  const HadithItem({
    required this.id,
    required this.categoryId,
    required this.arabicText,
    required this.translationKu,
    this.translationEn,
    this.narrator,
    this.source,
    this.explanationKu,
    this.explanationEn,
    required this.order,
    required this.isActive,
  });

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    return HadithItem(
      id: json['id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      arabicText: json['arabic_text'] as String? ?? '',
      translationKu: json['translation_ku'] as String? ?? '',
      translationEn: json['translation_en'] as String?,
      narrator: json['narrator'] as String?,
      source: json['source'] as String?,
      explanationKu: json['explanation_ku'] as String?,
      explanationEn: json['explanation_en'] as String?,
      order: json['order'] as int? ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hadith Category Model
// ─────────────────────────────────────────────────────────────────────────────

class HadithCategory {
  final int id;
  final String nameKu;
  final String nameAr;
  final String? nameEn;
  final String? icon;
  final int order;
  final bool isActive;
  final List<HadithItem> hadiths;

  const HadithCategory({
    required this.id,
    required this.nameKu,
    required this.nameAr,
    this.nameEn,
    this.icon,
    required this.order,
    required this.isActive,
    required this.hadiths,
  });

  factory HadithCategory.fromJson(Map<String, dynamic> json) {
    final rawHadiths = json['hadiths'] as List? ?? [];
    final items = rawHadiths
        .map((x) => HadithItem.fromJson(x as Map<String, dynamic>))
        .toList();

    return HadithCategory(
      id: json['id'] as int? ?? 0,
      nameKu: json['name_ku'] as String? ?? '',
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String?,
      icon: json['icon'] as String?,
      order: json['order'] as int? ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      hadiths: items,
    );
  }
}
