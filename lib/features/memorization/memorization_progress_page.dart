import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'memorization_providers.dart';

class MemorizationProgressPage extends ConsumerStatefulWidget {
  const MemorizationProgressPage({super.key});

  @override
  ConsumerState<MemorizationProgressPage> createState() => _MemorizationProgressPageState();
}

class _RevisionTimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final String result;
  final int score;
  final Color statusColor;

  const _RevisionTimelineItem({
    required this.title,
    required this.date,
    required this.result,
    required this.score,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 50,
                color: theme.colorScheme.outlineVariant,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        date,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          result.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'نمرە: $score/100',
                        style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MemorizationProgressPageState extends ConsumerState<MemorizationProgressPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(memorizationStatsProvider);
    final historyAsync = ref.watch(detailedProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'پێشکەوتنی لەبەرکردن',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
          tabs: const [
            Tab(text: 'سورەتەکان'),
            Tab(text: 'جزءەکان'),
            Tab(text: 'مێژوو'),
          ],
        ),
      ),
      body: statsAsync.when(
        data: (stats) {
          if (stats == null) {
            return const Center(child: Text('هیچ ئامارێک بەردەست نییە.', style: TextStyle(fontFamily: 'Cairo')));
          }

          final overallPercentage = stats['overall_completion_percentage'] as num? ?? 0.0;
          final surahList = stats['surahs_progress'] as List? ?? [];
          final juzList = stats['juz_progress'] as List? ?? [];

          return TabBarView(
            controller: _tabController,
            children: [
              // Surahs Tab
              _buildSurahsTab(context, overallPercentage.toDouble(), surahList),

              // Juz Tab
              _buildJuzTab(context, overallPercentage.toDouble(), juzList),

              // History Tab
              _buildHistoryTab(context, historyAsync),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('کێشە لە بارکردنی ئاماری پێشکەوتن: $err', style: const TextStyle(fontFamily: 'Cairo'))),
      ),
    );
  }

  Widget _buildSurahsTab(BuildContext context, double overallPercentage, List surahs) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildOverallHeader(context, overallPercentage),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final s = surahs[index] as Map<String, dynamic>;
            final name = s['name'] as String? ?? 'Surah';
            final number = s['surah_number'] as int? ?? 0;
            final total = s['ayah_count'] as int? ?? 0;
            final memorized = s['memorized_count'] as int? ?? 0;
            final percentage = s['percentage'] as num? ?? 0.0;

            return _buildProgressRow(
              context,
              title: '$number. $name',
              percentage: percentage.toDouble(),
              subtitle: '$memorized / $total ئایەت',
            );
          },
        ),
      ],
    );
  }

  Widget _buildJuzTab(BuildContext context, double overallPercentage, List juzs) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildOverallHeader(context, overallPercentage),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: juzs.length,
          itemBuilder: (context, index) {
            final j = juzs[index] as Map<String, dynamic>;
            final number = j['juz_number'] as int? ?? 0;
            final total = j['total_ayahs'] as int? ?? 0;
            final memorized = j['memorized_count'] as int? ?? 0;
            final percentage = j['percentage'] as num? ?? 0.0;

            return _buildProgressRow(
              context,
              title: 'جزءی $number',
              percentage: percentage.toDouble(),
              subtitle: '$memorized / $total ئایەت',
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryTab(BuildContext context, AsyncValue<Map<String, dynamic>?> historyAsync) {
    return historyAsync.when(
      data: (history) {
        if (history == null) {
          return const Center(child: Text('هیچ مێژوویەک بەردەست نییە.', style: TextStyle(fontFamily: 'Cairo')));
        }
        final recentReviews = history['recent_reviews'] as List? ?? [];
        if (recentReviews.isEmpty) {
          return const Center(child: Text('تا ئێستا هیچ پێداچوونەوەیەک تۆمار نەکراوە.', style: TextStyle(fontFamily: 'Cairo')));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: recentReviews.length,
          itemBuilder: (context, index) {
            final r = recentReviews[index] as Map<String, dynamic>;
            final surahNum = r['surah_number'] as int? ?? 0;
            final ayahNum = r['ayah_number'] as int? ?? 0;
            final date = r['review_date'] as String? ?? '';
            final result = r['result'] as String? ?? 'perfect';
            final score = r['score'] as int? ?? 100;

            Color statusColor = const Color(0xFF10B981);
            if (result == 'forgot') statusColor = Colors.redAccent;
            if (result == 'needs_work') statusColor = Colors.orange;

            return _RevisionTimelineItem(
              title: 'سورەتی $surahNum: ئایەتی $ayahNum',
              date: date,
              result: result,
              score: score,
              statusColor: statusColor,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('کێشە لە بارکردنی مێژوو: $err', style: const TextStyle(fontFamily: 'Cairo'))),
    );
  }

  Widget _buildOverallHeader(BuildContext context, double percentage) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.25),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'کۆی گشتی لەبەرکردنی قورئان',
                style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 12,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgressRow(
    BuildContext context, {
    required String title,
    required double percentage,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: percentage > 0 ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 6,
                backgroundColor: theme.colorScheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage == 100 ? const Color(0xFF10B981) : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
