import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'memorization_providers.dart';

class MemorizationAnalyticsPage extends ConsumerWidget {
  const MemorizationAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(memorizationDashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ئامار و بەردەوامی',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: dashboardAsync.when(
        data: (data) {
          if (data == null) {
            return const Center(child: Text('هیچ ئامارێک نەدۆزرایەوە.', style: TextStyle(fontFamily: 'Cairo')));
          }

          final totalReviews = data['total_reviews'] as int? ?? 0;
          final todayReviews = data['today_reviews'] as int? ?? 0;
          final streakDays = data['streak_days'] as int? ?? 0;
          final remainingDays = data['remaining_days'] as int? ?? 0;
          final dailyTarget = data['daily_target'] as int? ?? 5;

          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // Streaks & Consistency card
              _buildStreaksSection(context, streakDays),
              const SizedBox(height: 24),

              // Overview statistics
              Text(
                'کورتەی پێشکەوتن',
                style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      context,
                      title: 'کۆی پێداچوونەوەکان',
                      value: '$totalReviews',
                      icon: Icons.history,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricTile(
                      context,
                      title: 'پێداچوونەوەی ئەمڕۆ',
                      value: '$todayReviews',
                      icon: Icons.today,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      context,
                      title: 'ئامانجی ڕۆژانە',
                      value: '$dailyTarget ئایەت',
                      icon: Icons.flag,
                      color: Colors.orange[800]!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricTile(
                      context,
                      title: 'کاتی ماوە',
                      value: '$remainingDays ڕۆژ',
                      icon: Icons.timer,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Weekly Activity Bar Chart (Custom premium widget)
              Text(
                'چالاکی هەفتانە (پێداچوونەوە)',
                style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildWeeklyChart(context, todayReviews),
              const SizedBox(height: 30),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStreaksSection(BuildContext context, int streak) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFf12711), Color(0xFFf5af19)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 12),
          Text(
            '$streak ڕۆژ بەردەوامی',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            streak > 0 ? 'پابەندبوونێکی نایابە! بەردەوام بە لە پێداچوونەوەی ڕۆژانە.' : 'پێداچوونەوەکانی ئەمڕۆ تەواو بکە بۆ دەستپێکردنی ڕێڕەوی بەردەوامی!',
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'Cairo', color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, int todayCount) {
    final theme = Theme.of(context);
    // Custom premium representation of a bar chart
    final list = [2, 5, 0, 3, 4, todayCount, 0];
    final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final count = list[index];
          final double height = count == 0 ? 10 : (count * 15.0).clamp(10, 100);
          final isToday = index == 5; // Saturday/Today representation

          return Column(
            children: [
              Text(
                '$count',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isToday ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 16,
                height: height,
                decoration: BoxDecoration(
                  gradient: isToday
                      ? LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary])
                      : LinearGradient(colors: [Colors.grey[400]!, Colors.grey[300]!]),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                labels[index],
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
