class ReciterModel {
  final int id;
  final String name;
  final String riwayah;
  final String language;
  final String? image;

  const ReciterModel({
    required this.id,
    required this.name,
    required this.riwayah,
    required this.language,
    this.image,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      riwayah: json['riwayah'] as String? ?? 'Hafs',
      language: json['language'] as String? ?? 'ar',
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'riwayah': riwayah,
      'language': language,
      'image': image,
    };
  }
}
