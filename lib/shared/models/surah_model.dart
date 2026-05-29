enum SurahType { meccan, medinan }

class SurahModel {
  const SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameTranslit,
    required this.ayahCount,
    required this.type,
    required this.revelationOrder,
  });

  final int number;
  final String nameArabic;
  final String nameTranslit;
  final int ayahCount;
  final SurahType type;
  final int revelationOrder;

  bool get isMeccan  => type == SurahType.meccan;
  bool get isMedinan => type == SurahType.medinan;
}
