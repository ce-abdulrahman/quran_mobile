import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../quran/quran_providers.dart';
import '../../core/models/surah_model.dart';
import 'weak_ayahs_page.dart';
import 'due_reviews_page.dart';
import 'quiz_screen.dart';

class RevisionModesPage extends ConsumerStatefulWidget {
  const RevisionModesPage({super.key});

  @override
  ConsumerState<RevisionModesPage> createState() => _RevisionModesPageState();
}

class _RevisionModesPageState extends ConsumerState<RevisionModesPage> {
  SurahModel? _selectedSurah;
  int? _selectedJuz;

  // Static Juz to Surah mapping
  static const Map<int, List<int>> juzToSurahNumbers = {
    1: [1, 2],
    2: [2],
    3: [2, 3],
    4: [3, 4],
    5: [4],
    6: [4, 5],
    7: [5, 6],
    8: [6, 7],
    9: [7, 8],
    10: [8, 9],
    11: [9, 10, 11],
    12: [11, 12],
    13: [12, 13, 14],
    14: [15, 16],
    15: [17, 18],
    16: [18, 19, 20],
    17: [21, 22],
    18: [23, 24, 25],
    19: [25, 26, 27],
    20: [27, 28, 29],
    21: [29, 30, 31, 32, 33],
    22: [33, 34, 35, 36],
    23: [36, 37, 38, 39],
    24: [39, 40, 41],
    25: [41, 42, 43, 44, 45],
    26: [45, 46, 47, 48, 49, 50, 51],
    27: [51, 52, 53, 54, 55, 56, 57],
    28: [58, 59, 60, 61, 62, 63, 64, 65, 66],
    29: [67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77],
    30: [78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'شێوازەکانی پێداچوونەوە',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode 1: Quick Review (Weak Ayahs)
            _buildModeCard(
              context,
              title: 'پێداچوونەوەی خێرا',
              description: 'سەرنج بخەرە سەر ئەو ئایەتانەی کە لەبەرکردنیان لاوازە.',
              icon: Icons.flash_on_rounded,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WeakAyahsPage()),
                );
              },
            ),
            const SizedBox(height: 16),

            // Mode 2: Due Review (Spaced Repetition)
            _buildModeCard(
              context,
              title: 'پێداچوونەوەی پێویست',
              description: 'پێداچوونەوەی ئەو ئایەتانەی کە دیاریکراون بەپێی سیستەمی دووبارەکردنەوە.',
              icon: Icons.alarm_on_rounded,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DueReviewsPage()),
                );
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Mode 3: Surah Review Selector
            Text(
              'پێداچوونەوە بەپێی سورەت',
              style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            surahsAsync.when(
              data: (surahs) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SurahModel>(
                            value: _selectedSurah,
                            hint: const Text('سورەت هەڵبژێرە', style: TextStyle(fontFamily: 'Cairo')),
                            isExpanded: true,
                            items: surahs.map((s) {
                              return DropdownMenuItem<SurahModel>(
                                value: s,
                                child: Text('${s.number}. ${s.nameEn} (${s.nameAr})', style: const TextStyle(fontFamily: 'Cairo')),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedSurah = val);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _selectedSurah == null
                          ? null
                          : () => _startSurahReview(surahs),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('دەستپێکردن', style: TextStyle(fontFamily: 'Cairo')),
                    )
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error loading Surahs: $err'),
            ),
            const SizedBox(height: 24),

            // Mode 4: Juz Review Selector
            Text(
              'پێداچوونەوە بەپێی جزء',
              style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            surahsAsync.when(
              data: (surahs) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedJuz,
                            hint: const Text('جزء هەڵبژێرە', style: TextStyle(fontFamily: 'Cairo')),
                            isExpanded: true,
                            items: List.generate(30, (i) => i + 1).map((juz) {
                              return DropdownMenuItem<int>(
                                value: juz,
                                child: Text('جزء $juz', style: const TextStyle(fontFamily: 'Cairo')),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => _selectedJuz = val);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _selectedJuz == null
                          ? null
                          : () => _startJuzReview(surahs),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('دەستپێکردن', style: TextStyle(fontFamily: 'Cairo')),
                    )
                  ],
                );
              },
              loading: () => const SizedBox(),
              error: (err, _) => const SizedBox(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'Cairo', color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  void _startSurahReview(List<SurahModel> allSurahs) async {
    final surah = _selectedSurah!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final allAyahs = await ref.read(ayahsProvider(surah.id).future);
      if (mounted) Navigator.pop(context); // Close loading dialog

      if (allAyahs.isEmpty) {
        throw Exception("No ayahs found in this surah");
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              surah: surah,
              ayahs: allAyahs,
              allSurahs: allSurahs,
              questionCount: allAyahs.length,
              quizType: 'continue',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showError(e.toString());
    }
  }

  void _startJuzReview(List<SurahModel> allSurahs) async {
    final juz = _selectedJuz!;
    final surahNumbers = juzToSurahNumbers[juz] ?? [];
    if (surahNumbers.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Find the first surah of that Juz to review
      final surahNum = surahNumbers.first;
      final surah = allSurahs.firstWhere((s) => s.number == surahNum);
      final allAyahs = await ref.read(ayahsProvider(surah.id).future);
      if (mounted) Navigator.pop(context);

      if (allAyahs.isEmpty) {
        throw Exception("No ayahs found in the surah for this Juz");
      }

      // Filter to ayahs belonging to this Juz
      final juzAyahs = allAyahs.where((a) => a.juzNumber == juz).toList();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              surah: surah,
              ayahs: juzAyahs.isEmpty ? allAyahs : juzAyahs,
              allSurahs: allSurahs,
              questionCount: juzAyahs.isEmpty ? allAyahs.length : juzAyahs.length,
              quizType: 'continue',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('کێشە: $msg', style: const TextStyle(fontFamily: 'Cairo')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
