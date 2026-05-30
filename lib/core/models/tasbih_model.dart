class TasbihModel {
  final String id;
  final String name;
  final int target;
  final bool isCustom;
  final bool isActive;

  const TasbihModel({
    required this.id,
    required this.name,
    required this.target,
    this.isCustom = false,
    this.isActive = true,
  });

  factory TasbihModel.fromJson(Map<String, dynamic> json) {
    return TasbihModel(
      id: (json['id'] ?? '').toString(),
      name: json['name'] as String? ?? '',
      target: json['target'] as int? ?? 33,
      isCustom: json['is_custom'] as bool? ?? false,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'target': target,
      'is_custom': isCustom,
      'is_active': isActive,
    };
  }
}
