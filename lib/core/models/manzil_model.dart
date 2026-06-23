class ManzilModel {
  final int id;
  final String slug;
  final int sortOrder;
  final int manzilNumber;
  final int startSurah;
  final int startAyah;
  final int startPage;
  final int endPage;

  const ManzilModel({
    required this.id,
    required this.slug,
    required this.sortOrder,
    required this.manzilNumber,
    required this.startSurah,
    required this.startAyah,
    required this.startPage,
    required this.endPage,
  });

  static const List<ManzilModel> list = [
    ManzilModel(id: 1, slug: 'manzil-1', sortOrder: 1, manzilNumber: 1, startSurah: 1, startAyah: 1, startPage: 2, endPage: 105),
    ManzilModel(id: 2, slug: 'manzil-2', sortOrder: 2, manzilNumber: 2, startSurah: 5, startAyah: 1, startPage: 106, endPage: 207),
    ManzilModel(id: 3, slug: 'manzil-3', sortOrder: 3, manzilNumber: 3, startSurah: 10, startAyah: 1, startPage: 208, endPage: 281),
    ManzilModel(id: 4, slug: 'manzil-4', sortOrder: 4, manzilNumber: 4, startSurah: 17, startAyah: 1, startPage: 282, endPage: 366),
    ManzilModel(id: 5, slug: 'manzil-5', sortOrder: 5, manzilNumber: 5, startSurah: 26, startAyah: 1, startPage: 367, endPage: 445),
    ManzilModel(id: 6, slug: 'manzil-6', sortOrder: 6, manzilNumber: 6, startSurah: 37, startAyah: 1, startPage: 446, endPage: 517),
    ManzilModel(id: 7, slug: 'manzil-7', sortOrder: 7, manzilNumber: 7, startSurah: 50, startAyah: 1, startPage: 518, endPage: 604),
  ];
}
