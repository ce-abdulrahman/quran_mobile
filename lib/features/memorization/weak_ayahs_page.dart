import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'memorization_providers.dart';
import '../quran/quran_providers.dart';
import '../../core/models/surah_model.dart';
import 'quiz_screen.dart';

class WeakAyahsPage extends ConsumerWidget {
  const WeakAyahsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weakAyahsAsync = ref.watch(weakAyahsProvider);
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ئایەتە لاوازەکان',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: weakAyahsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return _buildEmptyState(context);
          }

          // Group weak reviews by Surah ID
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

                  return _buildSurahWeakCard(context, ref, surah, items, allSurahs);
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

  Widget _buildSurahWeakCard(
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
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                    '${items.length} ئایەتی لاواز',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Cairo',
                      color: Colors.orange[800],
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
          
          // Verses detail list
          Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ئایەتی ${item.ayah?.ayahNumber ?? item.ayahId}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star_half_rounded, color: Colors.orange[600], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'هێز: ${item.strengthScore}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'Cairo',
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.report_problem_outlined, color: Colors.redAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'هەڵەکان: ${item.mistakesCount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'Cairo',
                            color: Colors.redAccent[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text(
              'پێداچوونەوە بکە',
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
    List<UserAyahProgressModel> weakItems,
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

      final targetIds = weakItems.map((e) => e.ayahId).toList();

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
              Icons.emoji_emotions_outlined,
              size: 80,
              color: const Color(0xFF10B981).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'هیچ ئایەتێکی لاواز نییە!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ئایەتە لەبەرکراوەکانت لە دۆخێکی نایابدان. بەردەوام بە لەسەر ئەم ئاستە!',
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
