class SajdahModel {
  final int surahId;
  final int ayahNumber;
  final String surahNameAr;
  final String surahNameEn;
  final String surahNameKu;
  final int pageNumber;
  final bool isObligatory;

  const SajdahModel({
    required this.surahId,
    required this.ayahNumber,
    required this.surahNameAr,
    required this.surahNameEn,
    required this.surahNameKu,
    required this.pageNumber,
    required this.isObligatory,
  });

  static const List<SajdahModel> list = [
    SajdahModel(surahId: 7, ayahNumber: 206, surahNameAr: 'الأعراف', surahNameEn: "Al-A'raf", surahNameKu: 'ئەعراف', pageNumber: 176, isObligatory: false),
    SajdahModel(surahId: 13, ayahNumber: 15, surahNameAr: 'الرعد', surahNameEn: "Ar-Ra'd", surahNameKu: 'ڕەعد', pageNumber: 251, isObligatory: false),
    SajdahModel(surahId: 16, ayahNumber: 49, surahNameAr: 'النحل', surahNameEn: 'An-Nahl', surahNameKu: 'نەحل', pageNumber: 272, isObligatory: false),
    SajdahModel(surahId: 17, ayahNumber: 109, surahNameAr: 'الإسراء', surahNameEn: 'Al-Isra', surahNameKu: 'ئیسرا', pageNumber: 293, isObligatory: false),
    SajdahModel(surahId: 19, ayahNumber: 58, surahNameAr: 'مريم', surahNameEn: 'Maryam', surahNameKu: 'مەریەم', pageNumber: 309, isObligatory: false),
    SajdahModel(surahId: 22, ayahNumber: 18, surahNameAr: 'الحج', surahNameEn: 'Al-Hajj', surahNameKu: 'حەج', pageNumber: 334, isObligatory: false),
    SajdahModel(surahId: 22, ayahNumber: 77, surahNameAr: 'الحج', surahNameEn: 'Al-Hajj', surahNameKu: 'حەج', pageNumber: 341, isObligatory: false),
    SajdahModel(surahId: 25, ayahNumber: 60, surahNameAr: 'الفرقان', surahNameEn: 'Al-Furqan', surahNameKu: 'فورقان', pageNumber: 365, isObligatory: false),
    SajdahModel(surahId: 27, ayahNumber: 26, surahNameAr: 'النمل', surahNameEn: 'An-Naml', surahNameKu: 'نەمل', pageNumber: 379, isObligatory: false),
    SajdahModel(surahId: 32, ayahNumber: 15, surahNameAr: 'السجدة', surahNameEn: 'As-Sajdah', surahNameKu: 'سەجدە', pageNumber: 416, isObligatory: true),
    SajdahModel(surahId: 38, ayahNumber: 24, surahNameAr: 'ص', surahNameEn: 'Sad', surahNameKu: 'ساد', pageNumber: 454, isObligatory: false),
    SajdahModel(surahId: 41, ayahNumber: 38, surahNameAr: 'فصلت', surahNameEn: 'Fussilat', surahNameKu: 'فوسسیلەت', pageNumber: 480, isObligatory: true),
    SajdahModel(surahId: 53, ayahNumber: 62, surahNameAr: 'النجم', surahNameEn: 'An-Najm', surahNameKu: 'نەجم', pageNumber: 528, isObligatory: true),
    SajdahModel(surahId: 84, ayahNumber: 21, surahNameAr: 'الانشقاق', surahNameEn: 'Al-Inshiqaq', surahNameKu: 'ئینشقاق', pageNumber: 589, isObligatory: false),
    SajdahModel(surahId: 96, ayahNumber: 19, surahNameAr: 'العلق', surahNameEn: 'Al-Alaq', surahNameKu: 'عەلاق', pageNumber: 598, isObligatory: true),
  ];
}
