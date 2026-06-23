class HizbModel {
  final int id;
  final String slug;
  final int sortOrder;
  final int hizbNumber;
  final int startSurah;
  final int startAyah;
  final int startPage;
  final int endPage;

  const HizbModel({
    required this.id,
    required this.slug,
    required this.sortOrder,
    required this.hizbNumber,
    required this.startSurah,
    required this.startAyah,
    required this.startPage,
    required this.endPage,
  });

  static const List<HizbModel> list = [
    HizbModel(id: 1, slug: 'hizb-1', sortOrder: 1, hizbNumber: 1, startSurah: 1, startAyah: 1, startPage: 2, endPage: 10),
    HizbModel(id: 2, slug: 'hizb-2', sortOrder: 2, hizbNumber: 2, startSurah: 2, startAyah: 75, startPage: 11, endPage: 21),
    HizbModel(id: 3, slug: 'hizb-3', sortOrder: 3, hizbNumber: 3, startSurah: 2, startAyah: 142, startPage: 22, endPage: 31),
    HizbModel(id: 4, slug: 'hizb-4', sortOrder: 4, hizbNumber: 4, startSurah: 2, startAyah: 203, startPage: 32, endPage: 41),
    HizbModel(id: 5, slug: 'hizb-5', sortOrder: 5, hizbNumber: 5, startSurah: 2, startAyah: 253, startPage: 42, endPage: 50),
    HizbModel(id: 6, slug: 'hizb-6', sortOrder: 6, hizbNumber: 6, startSurah: 3, startAyah: 15, startPage: 51, endPage: 61),
    HizbModel(id: 7, slug: 'hizb-7', sortOrder: 7, hizbNumber: 7, startSurah: 3, startAyah: 93, startPage: 62, endPage: 71),
    HizbModel(id: 8, slug: 'hizb-8', sortOrder: 8, hizbNumber: 8, startSurah: 3, startAyah: 171, startPage: 72, endPage: 81),
    HizbModel(id: 9, slug: 'hizb-9', sortOrder: 9, hizbNumber: 9, startSurah: 4, startAyah: 24, startPage: 82, endPage: 91),
    HizbModel(id: 10, slug: 'hizb-10', sortOrder: 10, hizbNumber: 10, startSurah: 4, startAyah: 88, startPage: 92, endPage: 101),
    HizbModel(id: 11, slug: 'hizb-11', sortOrder: 11, hizbNumber: 11, startSurah: 4, startAyah: 148, startPage: 102, endPage: 111),
    HizbModel(id: 12, slug: 'hizb-12', sortOrder: 12, hizbNumber: 12, startSurah: 5, startAyah: 27, startPage: 112, endPage: 121),
    HizbModel(id: 13, slug: 'hizb-13', sortOrder: 13, hizbNumber: 13, startSurah: 5, startAyah: 82, startPage: 122, endPage: 130),
    HizbModel(id: 14, slug: 'hizb-14', sortOrder: 14, hizbNumber: 14, startSurah: 6, startAyah: 36, startPage: 131, endPage: 141),
    HizbModel(id: 15, slug: 'hizb-15', sortOrder: 15, hizbNumber: 15, startSurah: 6, startAyah: 111, startPage: 142, endPage: 149),
    HizbModel(id: 16, slug: 'hizb-16', sortOrder: 16, hizbNumber: 16, startSurah: 6, startAyah: 165, startPage: 150, endPage: 161),
    HizbModel(id: 17, slug: 'hizb-17', sortOrder: 17, hizbNumber: 17, startSurah: 7, startAyah: 88, startPage: 162, endPage: 172),
    HizbModel(id: 18, slug: 'hizb-18', sortOrder: 18, hizbNumber: 18, startSurah: 7, startAyah: 171, startPage: 173, endPage: 181),
    HizbModel(id: 19, slug: 'hizb-19', sortOrder: 19, hizbNumber: 19, startSurah: 8, startAyah: 41, startPage: 182, endPage: 191),
    HizbModel(id: 20, slug: 'hizb-20', sortOrder: 20, hizbNumber: 20, startSurah: 9, startAyah: 34, startPage: 192, endPage: 201),
    HizbModel(id: 21, slug: 'hizb-21', sortOrder: 21, hizbNumber: 21, startSurah: 9, startAyah: 93, startPage: 202, endPage: 211),
    HizbModel(id: 22, slug: 'hizb-22', sortOrder: 22, hizbNumber: 22, startSurah: 10, startAyah: 26, startPage: 212, endPage: 221),
    HizbModel(id: 23, slug: 'hizb-23', sortOrder: 23, hizbNumber: 23, startSurah: 11, startAyah: 6, startPage: 222, endPage: 230),
    HizbModel(id: 24, slug: 'hizb-24', sortOrder: 24, hizbNumber: 24, startSurah: 11, startAyah: 84, startPage: 231, endPage: 241),
    HizbModel(id: 25, slug: 'hizb-25', sortOrder: 25, hizbNumber: 25, startSurah: 12, startAyah: 53, startPage: 242, endPage: 250),
    HizbModel(id: 26, slug: 'hizb-26', sortOrder: 26, hizbNumber: 26, startSurah: 13, startAyah: 19, startPage: 251, endPage: 261),
    HizbModel(id: 27, slug: 'hizb-27', sortOrder: 27, hizbNumber: 27, startSurah: 15, startAyah: 1, startPage: 262, endPage: 271),
    HizbModel(id: 28, slug: 'hizb-28', sortOrder: 28, hizbNumber: 28, startSurah: 16, startAyah: 51, startPage: 272, endPage: 281),
    HizbModel(id: 29, slug: 'hizb-29', sortOrder: 29, hizbNumber: 29, startSurah: 17, startAyah: 1, startPage: 282, endPage: 291),
    HizbModel(id: 30, slug: 'hizb-30', sortOrder: 30, hizbNumber: 30, startSurah: 17, startAyah: 99, startPage: 292, endPage: 301),
    HizbModel(id: 31, slug: 'hizb-31', sortOrder: 31, hizbNumber: 31, startSurah: 18, startAyah: 75, startPage: 302, endPage: 311),
    HizbModel(id: 32, slug: 'hizb-32', sortOrder: 32, hizbNumber: 32, startSurah: 19, startAyah: 22, startPage: 312, endPage: 321),
    HizbModel(id: 33, slug: 'hizb-33', sortOrder: 33, hizbNumber: 33, startSurah: 21, startAyah: 1, startPage: 322, endPage: 335),
    HizbModel(id: 34, slug: 'hizb-34', sortOrder: 34, hizbNumber: 34, startSurah: 22, startAyah: 38, startPage: 336, endPage: 341),
    HizbModel(id: 35, slug: 'hizb-35', sortOrder: 35, hizbNumber: 35, startSurah: 23, startAyah: 1, startPage: 342, endPage: 351),
    HizbModel(id: 36, slug: 'hizb-36', sortOrder: 36, hizbNumber: 36, startSurah: 24, startAyah: 21, startPage: 352, endPage: 361),
    HizbModel(id: 37, slug: 'hizb-37', sortOrder: 37, hizbNumber: 37, startSurah: 25, startAyah: 21, startPage: 362, endPage: 370),
    HizbModel(id: 38, slug: 'hizb-38', sortOrder: 38, hizbNumber: 38, startSurah: 26, startAyah: 111, startPage: 371, endPage: 381),
    HizbModel(id: 39, slug: 'hizb-39', sortOrder: 39, hizbNumber: 39, startSurah: 27, startAyah: 56, startPage: 382, endPage: 390),
    HizbModel(id: 40, slug: 'hizb-40', sortOrder: 40, hizbNumber: 40, startSurah: 28, startAyah: 51, startPage: 391, endPage: 401),
    HizbModel(id: 41, slug: 'hizb-41', sortOrder: 41, hizbNumber: 41, startSurah: 29, startAyah: 46, startPage: 402, endPage: 411),
    HizbModel(id: 42, slug: 'hizb-42', sortOrder: 42, hizbNumber: 42, startSurah: 31, startAyah: 22, startPage: 412, endPage: 421),
    HizbModel(id: 43, slug: 'hizb-43', sortOrder: 43, hizbNumber: 43, startSurah: 33, startAyah: 31, startPage: 422, endPage: 430),
    HizbModel(id: 44, slug: 'hizb-44', sortOrder: 44, hizbNumber: 44, startSurah: 34, startAyah: 24, startPage: 431, endPage: 441),
    HizbModel(id: 45, slug: 'hizb-45', sortOrder: 45, hizbNumber: 45, startSurah: 36, startAyah: 28, startPage: 442, endPage: 450),
    HizbModel(id: 46, slug: 'hizb-46', sortOrder: 46, hizbNumber: 46, startSurah: 37, startAyah: 145, startPage: 451, endPage: 461),
    HizbModel(id: 47, slug: 'hizb-47', sortOrder: 47, hizbNumber: 47, startSurah: 39, startAyah: 32, startPage: 462, endPage: 470),
    HizbModel(id: 48, slug: 'hizb-48', sortOrder: 48, hizbNumber: 48, startSurah: 40, startAyah: 41, startPage: 471, endPage: 481),
    HizbModel(id: 49, slug: 'hizb-49', sortOrder: 49, hizbNumber: 49, startSurah: 41, startAyah: 47, startPage: 482, endPage: 490),
    HizbModel(id: 50, slug: 'hizb-50', sortOrder: 50, hizbNumber: 50, startSurah: 43, startAyah: 24, startPage: 491, endPage: 501),
    HizbModel(id: 51, slug: 'hizb-51', sortOrder: 51, hizbNumber: 51, startSurah: 46, startAyah: 1, startPage: 502, endPage: 512),
    HizbModel(id: 52, slug: 'hizb-52', sortOrder: 52, hizbNumber: 52, startSurah: 48, startAyah: 18, startPage: 513, endPage: 521),
    HizbModel(id: 53, slug: 'hizb-53', sortOrder: 53, hizbNumber: 53, startSurah: 51, startAyah: 31, startPage: 522, endPage: 530),
    HizbModel(id: 54, slug: 'hizb-54', sortOrder: 54, hizbNumber: 54, startSurah: 54, startAyah: 55, startPage: 531, endPage: 541),
    HizbModel(id: 55, slug: 'hizb-55', sortOrder: 55, hizbNumber: 55, startSurah: 58, startAyah: 1, startPage: 542, endPage: 550),
    HizbModel(id: 56, slug: 'hizb-56', sortOrder: 56, hizbNumber: 56, startSurah: 61, startAyah: 1, startPage: 551, endPage: 561),
    HizbModel(id: 57, slug: 'hizb-57', sortOrder: 57, hizbNumber: 57, startSurah: 67, startAyah: 1, startPage: 562, endPage: 571),
    HizbModel(id: 58, slug: 'hizb-58', sortOrder: 58, hizbNumber: 58, startSurah: 72, startAyah: 1, startPage: 572, endPage: 581),
    HizbModel(id: 59, slug: 'hizb-59', sortOrder: 59, hizbNumber: 59, startSurah: 78, startAyah: 1, startPage: 582, endPage: 590),
    HizbModel(id: 60, slug: 'hizb-60', sortOrder: 60, hizbNumber: 60, startSurah: 87, startAyah: 1, startPage: 591, endPage: 604),
  ];
}
