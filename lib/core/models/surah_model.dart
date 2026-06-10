class SurahModel {
  final int id;
  final int number;
  final String nameAr;
  final String nameEn;
  final String nameKu;
  final int totalAyahs;
  final String revelationType;
  final int? pageStart;
  final int? pageEnd;

  const SurahModel({
    required this.id,
    required this.number,
    required this.nameAr,
    required this.nameEn,
    required this.nameKu,
    required this.totalAyahs,
    required this.revelationType,
    this.pageStart,
    this.pageEnd,
  });

  bool get isMeccan => revelationType.toLowerCase() == 'meccan';

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      nameKu: json['name_ku'] as String? ?? '',
      totalAyahs: json['total_ayahs'] as int? ?? json['ayah_count'] as int? ?? 0,
      revelationType: json['revelation_type'] as String? ?? 'Meccan',
      pageStart: json['page_start'] as int?,
      pageEnd: json['page_end'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'name_ar': nameAr,
      'name_en': nameEn,
      'name_ku': nameKu,
      'total_ayahs': totalAyahs,
      'revelation_type': revelationType,
      'page_start': pageStart,
      'page_end': pageEnd,
    };
  }
}

