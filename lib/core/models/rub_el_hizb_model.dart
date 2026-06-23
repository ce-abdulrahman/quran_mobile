import 'rub_el_hizb_data.dart';

class RubElHizbModel {
  final int id;
  final String slug;
  final int sortOrder;
  final int rubNumber;
  final int startSurah;
  final int startAyah;
  final int startPage;

  const RubElHizbModel({
    required this.id,
    required this.slug,
    required this.sortOrder,
    required this.rubNumber,
    required this.startSurah,
    required this.startAyah,
    required this.startPage,
  });

  static List<RubElHizbModel> get list {
    return RubElHizbData.list.map((q) {
      final rubNum = q['rub_number']!;
      return RubElHizbModel(
        id: rubNum,
        slug: 'rub-$rubNum',
        sortOrder: rubNum,
        rubNumber: rubNum,
        startSurah: q['start_surah']!,
        startAyah: q['start_ayah']!,
        startPage: q['start_page']!,
      );
    }).toList();
  }
}
