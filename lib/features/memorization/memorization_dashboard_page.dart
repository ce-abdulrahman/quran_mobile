import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/widgets/auth_gate_card.dart';
import 'memorization_providers.dart';
import 'due_reviews_page.dart';
import 'weak_ayahs_page.dart';
import 'revision_modes_page.dart';
import 'memorization_progress_page.dart';
import 'memorization_analytics_page.dart';
import 'memorization_quiz_page.dart';

class MemorizationDashboardPage extends ConsumerStatefulWidget {
  const MemorizationDashboardPage({super.key});

  @override
  ConsumerState<MemorizationDashboardPage> createState() => _MemorizationDashboardPageState();
}

class _MemorizationDashboardPageState extends ConsumerState<MemorizationDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        AuthGateCard.showProtectProgressSheet(
          context,
          ref,
          featureContext: 'پلانەکانی لەبەرکردن و مێژووی پێداچوونەوەکانت بە پارێزراوی لە هەوردا پاشەکەوت دەبن و لەسەر هەموو ئامێرەکانت هاوکات دەکرێن.',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(memorizationDashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.9),
              theme.colorScheme.primary.withOpacity(0.08),
            ],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(memorizationDashboardProvider);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Premium Glassmorphic App Bar
                SliverAppBar(
                  expandedHeight: 90,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'ناوەندی لەبەرکردن',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                    titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () {
                        ref.invalidate(memorizationDashboardProvider);
                      },
                    ),
                  ],
                ),

                // Main Content
                SliverToBoxAdapter(
                  child: dashboardAsync.when(
                    data: (data) {
                      if (data == null) {
                        return _buildEmptyState(context);
                      }
                      return _buildDashboardContent(context, ref, data);
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(50.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, stack) => _buildErrorState(context, err.toString()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, WidgetRef ref, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final totalMemorized = data['total_memorized'] as int? ?? 0;
    final totalLearning = data['total_learning'] as int? ?? 0;
    final streakDays = data['streak_days'] as int? ?? 0;
    final dueReviews = data['due_reviews_count'] as int? ?? 0;
    final weakAyahs = data['weak_ayahs_count'] as int? ?? 0;
    final remainingDays = data['remaining_days'] as int? ?? 0;
    final estCompletion = data['estimated_completion_date'] as String? ?? 'N/A';

    final completionPercentage = (totalMemorized / 6236.0) * 100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Islamic Greeting / Encouragement
          _buildEncouragementCard(context, streakDays),
          const SizedBox(height: 20),

          // Core Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'لەبەرکراو',
                  value: '$totalMemorized',
                  subtitle: 'ئایەتەکان',
                  icon: Icons.auto_stories,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  context,
                  title: 'خوێندن',
                  value: '$totalLearning',
                  subtitle: 'لە پرۆسەدایە',
                  icon: Icons.edit_note_rounded,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildInteractiveStatCard(
                  context,
                  title: 'پێداچوونەوە',
                  value: '$dueReviews',
                  subtitle: dueReviews > 0 ? 'کرداری پێویستە' : 'هەمووی تەواوە',
                  icon: Icons.history_edu_rounded,
                  color: dueReviews > 0 ? Colors.redAccent : Colors.teal,
                  badge: dueReviews > 0 ? 'پێویستە' : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DueReviewsPage()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildInteractiveStatCard(
                  context,
                  title: 'ئایەتە لاوازەکان',
                  value: '$weakAyahs',
                  subtitle: 'سەرنجدانی پێویستە',
                  icon: Icons.warning_amber_rounded,
                  color: weakAyahs > 0 ? Colors.orange : Colors.blueGrey,
                  badge: weakAyahs > 0 ? 'ئاگاداری' : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WeakAyahsPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Forecast Card
          _buildForecastCard(context, completionPercentage, remainingDays, estCompletion),
          const SizedBox(height: 25),

          // Quick Actions Section Title
          Text(
            'کردارە خێراکان',
            style: theme.textTheme.titleMedium?.copyWith(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),

          // Quick Action Cards
          _buildActionItem(
            context,
            title: 'تاقیکردنەوەی پێداچوونەوە',
            description: 'تاقیکردنەوە لەو ئایەتانەی پێویستیان بە پێداچوونەوەیە بکە بۆ بەهێزکردنی یادگەت.',
            icon: Icons.quiz_rounded,
            gradient: const LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MemorizationQuizPage(showBackButton: true)),
              );
            },
          ),
          _buildActionItem(
            context,
            title: 'بەشەکانی پێداچوونەوە',
            description: 'پێداچوونەوە بەپێی سورەت، جزء، یان بەشە لاوازە دیاریکراوەکان.',
            icon: Icons.layers_rounded,
            gradient: const LinearGradient(colors: [Color(0xFF00c6ff), Color(0xFF0072ff)]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RevisionModesPage()),
              );
            },
          ),
          _buildActionItem(
            context,
            title: 'بەدواداچوونی پێشکەوتن',
            description: 'بەدواداچوونی بینراو لەسەرجەم سورەت و جزءەکان.',
            icon: Icons.insights_rounded,
            gradient: const LinearGradient(colors: [Color(0xFF11998e), Color(0xFF38ef7d)]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MemorizationProgressPage()),
              );
            },
          ),
          _buildActionItem(
            context,
            title: 'ئامار و بەردەوامی',
            description: 'مێژووی خوێندن، کاتەکان، و پێوەرەکانی بەردەوامی.',
            icon: Icons.analytics_outlined,
            gradient: const LinearGradient(colors: [Color(0xFFf12711), Color(0xFFf5af19)]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MemorizationAnalyticsPage()),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildEncouragementCard(BuildContext context, int streak) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: Colors.orange[800],
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ڕیتمەکەت بپارێزە!',
                  style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  streak > 0 ? '$streak ڕۆژ بەردەوام چالاکە!' : 'ئەمڕۆ دەست بە پێداچوونەوەی ڕۆژانەت بکە.',
                  style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'Cairo', color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    String? badge,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.04),
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
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCard(
    BuildContext context,
    double percentage,
    int remainingDays,
    String estCompletion,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تەواوبوونی پێشبینیکراو',
                style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
              Icon(Icons.query_stats_rounded, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'پێشکەوتنی قورئان',
                style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'Cairo', color: theme.colorScheme.onSurfaceVariant),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 10,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'کاتی ماوە',
                      style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'Cairo', color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$remainingDays ڕۆژ',
                      style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: 35,
                width: 1,
                color: theme.colorScheme.outlineVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ڕێکەوتی تەواوبوون',
                      style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'Cairo', color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      estCompletion,
                      style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.space_dashboard_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text('هیچ زانیارییەکی ئامار نەدۆزرایەوە.', style: TextStyle(fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            'بارکردنی زانیارییەکان سەرکەوتوو نەبوو.',
            style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
