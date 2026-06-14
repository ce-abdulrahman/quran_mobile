import 'tasbih_theme_model.dart';

class TasbihThemeCategoryModel {
  final int id;
  final String icon;
  final String name;
  final List<TasbihThemeModel> themes;

  const TasbihThemeCategoryModel({
    required this.id,
    required this.icon,
    required this.name,
    required this.themes,
  });

  factory TasbihThemeCategoryModel.fromJson(Map<String, dynamic> json) {
    var rawThemes = json['themes'] as List? ?? [];
    List<TasbihThemeModel> themeList = rawThemes
        .map((e) => TasbihThemeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return TasbihThemeCategoryModel(
      id: json['id'] as int? ?? 0,
      icon: json['icon'] as String? ?? 'bi bi-tag',
      name: json['name'] as String? ?? '',
      themes: themeList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'themes': themes.map((e) => e.toJson()).toList(),
    };
  }
}
