import 'surah_model.dart';
import 'tajweed_segment_model.dart';

class AyahModel {
  final int id;
  final int ayahNumber;
  final String textUthmani;
  final String? textEn;
  final String? textKu;
  final SurahModel? surah;
  final int? pageNumber;
  final int? juzNumber;
  final List<TajweedSegmentModel> tajweedSegments;

  const AyahModel({
    required this.id,
    required this.ayahNumber,
    required this.textUthmani,
    this.textEn,
    this.textKu,
    this.surah,
    this.pageNumber,
    this.juzNumber,
    this.tajweedSegments = const [],
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    String? textEn = json['text_en'] as String?;
    String? textKu = json['text_ku'] as String?;
    SurahModel? surah;

    if (json.containsKey('surah') && json['surah'] is Map<String, dynamic>) {
      surah = SurahModel.fromJson(json['surah'] as Map<String, dynamic>);
    }

    if (json.containsKey('translations') && json['translations'] is List) {
      final translationsList = json['translations'] as List;
      for (final t in translationsList) {
        if (t is Map<String, dynamic>) {
          final lang = t['language_code']?.toString().toLowerCase();
          final content = t['content']?.toString();
          if (lang == 'en') {
            textEn = content;
          } else if (lang == 'ku') {
            textKu = content;
          }
        }
      }
    }

    if (textEn != null) {
      textEn = textEn.replaceAll(RegExp(r'<[^>]*>'), '');
    }
    if (textKu != null) {
      textKu = textKu.replaceAll(RegExp(r'<[^>]*>'), '');
    }

    final rawSegments = json['tajweed_segments'] as List? ?? [];
    final segments = rawSegments
        .map((x) => TajweedSegmentModel.fromJson(x as Map<String, dynamic>))
        .toList();

    return AyahModel(
      id: json['id'] as int? ?? 0,
      ayahNumber: json['ayah_number'] as int? ?? 0,
      textUthmani: json['text_uthmani'] as String? ?? '',
      textEn: textEn,
      textKu: textKu,
      surah: surah,
      pageNumber: json['page_number'] as int?,
      juzNumber: json['juz_number'] as int?,
      tajweedSegments: segments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ayah_number': ayahNumber,
      'text_uthmani': textUthmani,
      'text_en': textEn,
      'text_ku': textKu,
      'surah': surah?.toJson(),
      'page_number': pageNumber,
      'juz_number': juzNumber,
      'tajweed_segments': tajweedSegments.map((x) => x.toJson()).toList(),
    };
  }
}
