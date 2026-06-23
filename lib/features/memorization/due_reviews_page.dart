import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'memorization_providers.dart';
import '../quran/quran_providers.dart';
import '../../core/models/surah_model.dart';
import 'quiz_screen.dart';

class DueReviewsPage extends ConsumerWidget {
  const DueReviewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueReviewsAsync = ref.watch(dueReviewsProvider);
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'پێداچوونەوەی پێویست',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: dueReviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return _buildEmptyState(context);
          }

          // Group reviews by Surah ID
          final Map<int, List<UserAyahProgressModel>> grouped = {};
          for (final r in reviews) {
            final ayah = r.ayah;
            if (ayah == null) continue;
            grouped.putIfAbsent(ayah.surah?.id ?? 0, () => []).add(r);
          }

          return surahsAsync.when(
            data: (allSurahs) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: grouped.keys.length,
                itemBuilder: (context, index) {
                  final surahId = grouped.keys.elementAt(index);
                  final items = grouped[surahId]!;
                  final surah = allSurahs.firstWhere(
                    (s) => s.id == surahId,
                    orElse: () => SurahModel(
                      id: surahId,
                      number: surahId,
                      nameAr: 'Unknown',
                      nameEn: 'Unknown',
                      nameKu: 'Unknown',
                      totalAyahs: 0,
                      revelationType: 'Meccan',
                    ),
                  );

                  return _buildSurahDueCard(context, ref, surah, items, allSurahs);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error loading Surahs: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSurahDueCard(
    BuildContext context,
    WidgetRef ref,
    SurahModel surah,
    List<UserAyahProgressModel> items,
    List<SurahModel> allSurahs,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameEn,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${items.length} ئایەت بۆ پێداچوونەوە',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Cairo',
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                surah.nameAr,
                style: const TextStyle(
                  fontFamily: 'UthmanicHafs',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          
          // Verses inline list
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'ئایەتی ${item.ayah?.ayahNumber ?? item.ayahId}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text(
              'دەستپێکردنی پێداچوونەوە',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
            onPressed: () => _startReview(context, ref, surah, items, allSurahs),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    );
  }

  void _startReview(
    BuildContext context,
    WidgetRef ref,
    SurahModel surah,
    List<UserAyahProgressModel> dueItems,
    List<SurahModel> allSurahs,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final allAyahs = await ref.read(ayahsProvider(surah.id).future);
      if (context.mounted) Navigator.pop(context); // Close loading dialog

      if (allAyahs.isEmpty) {
        throw Exception("No ayahs found in this surah");
      }

      final targetIds = dueItems.map((e) => e.ayahId).toList();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              surah: surah,
              ayahs: allAyahs,
              allSurahs: allSurahs,
              questionCount: targetIds.length,
              quizType: 'continue',
              targetAyahIds: targetIds,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Close loading dialog if open
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('کێشە لە بارکردنی ئایەتەکان: $e', style: const TextStyle(fontFamily: 'Cairo')),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: const Color(0xFF10B981).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'هیچ پێداچوونەوەیەک نییە!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'پێداچوونەوەی هەموو ئایەتە لەبەرکراوەکانی خۆت کردووە. دەست خۆش!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'Cairo',
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
