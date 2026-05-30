import 'surah_model.dart';

class BannerModel {
  final int id;
  final String? titleArabic;
  final String verse;
  final String? source;
  final int? surahId;
  final int? ayahNumber;
  final bool isActive;
  final int order;
  final SurahModel? surah;

  const BannerModel({
    required this.id,
    this.titleArabic,
    required this.verse,
    this.source,
    this.surahId,
    this.ayahNumber,
    required this.isActive,
    required this.order,
    this.surah,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int? ?? 0,
      titleArabic: json['title_arabic'] as String?,
      verse: json['verse'] as String? ?? '',
      source: json['source'] as String?,
      surahId: json['surah_id'] as int?,
      ayahNumber: json['ayah_number'] as int?,
      isActive: json['is_active'] is bool 
          ? json['is_active'] as bool 
          : (json['is_active'] == 1 || json['is_active'] == '1'),
      order: json['order'] as int? ?? 0,
      surah: json['surah'] != null
          ? SurahModel.fromJson(json['surah'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_arabic': titleArabic,
      'verse': verse,
      'source': source,
      'surah_id': surahId,
      'ayah_number': ayahNumber,
      'is_active': isActive,
      'order': order,
      'surah': surah?.toJson(),
    };
  }
}
