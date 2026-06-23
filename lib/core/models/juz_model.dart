class JuzModel {
  final int id;
  final String slug;
  final int sortOrder;
  final int juzNumber;
  final String arabicName;
  final String englishName;
  final String kurdishName;
  final String startWords;
  final int startSurah;
  final int startAyah;
  final int startPage;
  final int endPage;

  const JuzModel({
    required this.id,
    required this.slug,
    required this.sortOrder,
    required this.juzNumber,
    required this.arabicName,
    required this.englishName,
    required this.kurdishName,
    required this.startWords,
    required this.startSurah,
    required this.startAyah,
    required this.startPage,
    required this.endPage,
  });

  static const List<JuzModel> list = [
    JuzModel(id: 1, slug: 'juz-1', sortOrder: 1, juzNumber: 1, arabicName: 'الجزء الأول', englishName: 'Juz 1', kurdishName: 'جزءی ١', startWords: 'آلم', startSurah: 1, startAyah: 1, startPage: 1, endPage: 21),
    JuzModel(id: 2, slug: 'juz-2', sortOrder: 2, juzNumber: 2, arabicName: 'الجزء الثاني', englishName: 'Juz 2', kurdishName: 'جزءی ٢', startWords: 'سيقول', startSurah: 2, startAyah: 142, startPage: 22, endPage: 41),
    JuzModel(id: 3, slug: 'juz-3', sortOrder: 3, juzNumber: 3, arabicName: 'الجزء الثالث', englishName: 'Juz 3', kurdishName: 'جزءی ٣', startWords: 'تلك الرسل', startSurah: 2, startAyah: 253, startPage: 42, endPage: 61),
    JuzModel(id: 4, slug: 'juz-4', sortOrder: 4, juzNumber: 4, arabicName: 'الجزء الرابع', englishName: 'Juz 4', kurdishName: 'جزءی ٤', startWords: 'لن تنالوا', startSurah: 3, startAyah: 93, startPage: 62, endPage: 81),
    JuzModel(id: 5, slug: 'juz-5', sortOrder: 5, juzNumber: 5, arabicName: 'الجزء الخامس', englishName: 'Juz 5', kurdishName: 'جزءی ٥', startWords: 'والمحصنات', startSurah: 4, startAyah: 24, startPage: 82, endPage: 101),
    JuzModel(id: 6, slug: 'juz-6', sortOrder: 6, juzNumber: 6, arabicName: 'الجزء السادس', englishName: 'Juz 6', kurdishName: 'جزءی ٦', startWords: 'لا يحب الله', startSurah: 4, startAyah: 148, startPage: 102, endPage: 121),
    JuzModel(id: 7, slug: 'juz-7', sortOrder: 7, juzNumber: 7, arabicName: 'الجزء السابع', englishName: 'Juz 7', kurdishName: 'جزءی ٧', startWords: 'لتجدن', startSurah: 5, startAyah: 82, startPage: 122, endPage: 141),
    JuzModel(id: 8, slug: 'juz-8', sortOrder: 8, juzNumber: 8, arabicName: 'الجزء الثامن', englishName: 'Juz 8', kurdishName: 'جزءی ٨', startWords: 'ولو أننا', startSurah: 6, startAyah: 111, startPage: 142, endPage: 161),
    JuzModel(id: 9, slug: 'juz-9', sortOrder: 9, juzNumber: 9, arabicName: 'الجزء التاسع', englishName: 'Juz 9', kurdishName: 'جزءی ٩', startWords: 'قال الملأ', startSurah: 7, startAyah: 88, startPage: 162, endPage: 181),
    JuzModel(id: 10, slug: 'juz-10', sortOrder: 10, juzNumber: 10, arabicName: 'الجزء العاشر', englishName: 'Juz 10', kurdishName: 'جزءی ١٠', startWords: 'واعلموا', startSurah: 8, startAyah: 41, startPage: 182, endPage: 201),
    JuzModel(id: 11, slug: 'juz-11', sortOrder: 11, juzNumber: 11, arabicName: 'الجزء الحادي عشر', englishName: 'Juz 11', kurdishName: 'جزءی ١١', startWords: 'يعتذرون', startSurah: 9, startAyah: 93, startPage: 202, endPage: 221),
    JuzModel(id: 12, slug: 'juz-12', sortOrder: 12, juzNumber: 12, arabicName: 'الجزء الثاني عشر', englishName: 'Juz 12', kurdishName: 'جزءی ١٢', startWords: 'وما من دابة', startSurah: 11, startAyah: 6, startPage: 222, endPage: 241),
    JuzModel(id: 13, slug: 'juz-13', sortOrder: 13, juzNumber: 13, arabicName: 'الجزء الثالث عشر', englishName: 'Juz 13', kurdishName: 'جزءی ١٣', startWords: 'وما أبرئ', startSurah: 12, startAyah: 53, startPage: 242, endPage: 261),
    JuzModel(id: 14, slug: 'juz-14', sortOrder: 14, juzNumber: 14, arabicName: 'الجزء الرابع عشر', englishName: 'Juz 14', kurdishName: 'جزءی ١٤', startWords: 'ربما', startSurah: 15, startAyah: 1, startPage: 262, endPage: 281),
    JuzModel(id: 15, slug: 'juz-15', sortOrder: 15, juzNumber: 15, arabicName: 'الجزء الخامس عشر', englishName: 'Juz 15', kurdishName: 'جزءی ١٥', startWords: 'سبحان الذي', startSurah: 17, startAyah: 1, startPage: 282, endPage: 301),
    JuzModel(id: 16, slug: 'juz-16', sortOrder: 16, juzNumber: 16, arabicName: 'الجزء السادس عشر', englishName: 'Juz 16', kurdishName: 'جزءی ١٦', startWords: 'قال ألم', startSurah: 18, startAyah: 75, startPage: 302, endPage: 321),
    JuzModel(id: 17, slug: 'juz-17', sortOrder: 17, juzNumber: 17, arabicName: 'الجزء السابع عشر', englishName: 'Juz 17', kurdishName: 'جزءی ١٧', startWords: 'اقترب للناس', startSurah: 21, startAyah: 1, startPage: 322, endPage: 341),
    JuzModel(id: 18, slug: 'juz-18', sortOrder: 18, juzNumber: 18, arabicName: 'الجزء الثامن عشر', englishName: 'Juz 18', kurdishName: 'جزءی ١٨', startWords: 'قد أفلح', startSurah: 23, startAyah: 1, startPage: 342, endPage: 361),
    JuzModel(id: 19, slug: 'juz-19', sortOrder: 19, juzNumber: 19, arabicName: 'الجزء التاسع عشر', englishName: 'Juz 19', kurdishName: 'جزءی ١٩', startWords: 'وقال الذين', startSurah: 25, startAyah: 21, startPage: 362, endPage: 381),
    JuzModel(id: 20, slug: 'juz-20', sortOrder: 20, juzNumber: 20, arabicName: 'الجزء العشرون', englishName: 'Juz 20', kurdishName: 'جزءی ٢٠', startWords: 'أمن خلق', startSurah: 27, startAyah: 56, startPage: 382, endPage: 401),
    JuzModel(id: 21, slug: 'juz-21', sortOrder: 21, juzNumber: 21, arabicName: 'الجزء الحادي والعشرون', englishName: 'Juz 21', kurdishName: 'جزءی ٢١', startWords: 'اتل ما أوحي', startSurah: 29, startAyah: 46, startPage: 402, endPage: 421),
    JuzModel(id: 22, slug: 'juz-22', sortOrder: 22, juzNumber: 22, arabicName: 'الجزء الثاني والعشرون', englishName: 'Juz 22', kurdishName: 'جزءی ٢٢', startWords: 'ومن يقنت', startSurah: 33, startAyah: 31, startPage: 422, endPage: 441),
    JuzModel(id: 23, slug: 'juz-23', sortOrder: 23, juzNumber: 23, arabicName: 'الجزء الثالث والعشرون', englishName: 'Juz 23', kurdishName: 'جزءی ٢٣', startWords: 'وما لي', startSurah: 36, startAyah: 28, startPage: 442, endPage: 461),
    JuzModel(id: 24, slug: 'juz-24', sortOrder: 24, juzNumber: 24, arabicName: 'الجزء الرابع والعشرون', englishName: 'Juz 24', kurdishName: 'جزءی ٢٤', startWords: 'فمن أظلم', startSurah: 39, startAyah: 32, startPage: 462, endPage: 481),
    JuzModel(id: 25, slug: 'juz-25', sortOrder: 25, juzNumber: 25, arabicName: 'الجزء الخامس والعشرون', englishName: 'Juz 25', kurdishName: 'جزءی ٢٥', startWords: 'إليه يرد', startSurah: 41, startAyah: 47, startPage: 482, endPage: 501),
    JuzModel(id: 26, slug: 'juz-26', sortOrder: 26, juzNumber: 26, arabicName: 'الجزء السادس والعشرون', englishName: 'Juz 26', kurdishName: 'جزءی ٢٦', startWords: 'حم', startSurah: 46, startAyah: 1, startPage: 502, endPage: 521),
    JuzModel(id: 27, slug: 'juz-27', sortOrder: 27, juzNumber: 27, arabicName: 'الجزء السابع والعشرون', englishName: 'Juz 27', kurdishName: 'جزءی ٢٧', startWords: 'قال فما خطبكم', startSurah: 51, startAyah: 31, startPage: 522, endPage: 541),
    JuzModel(id: 28, slug: 'juz-28', sortOrder: 28, juzNumber: 28, arabicName: 'الجزء الثامن والعشرون', englishName: 'Juz 28', kurdishName: 'جزءی ٢٨', startWords: 'قد سمع الله', startSurah: 58, startAyah: 1, startPage: 542, endPage: 561),
    JuzModel(id: 29, slug: 'juz-29', sortOrder: 29, juzNumber: 29, arabicName: 'الجزء التاسع والعشرون', englishName: 'Juz 29', kurdishName: 'جزءی ٢٩', startWords: 'تبارك الذي', startSurah: 67, startAyah: 1, startPage: 562, endPage: 581),
    JuzModel(id: 30, slug: 'juz-30', sortOrder: 30, juzNumber: 30, arabicName: 'الجزء الثلاثون', englishName: 'Juz 30', kurdishName: 'جزءی ٣٠', startWords: 'عم يتساءلون', startSurah: 78, startAyah: 1, startPage: 582, endPage: 604),
  ];
}
