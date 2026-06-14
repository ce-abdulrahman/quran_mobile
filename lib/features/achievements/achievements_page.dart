import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/achievement_model.dart';
import '../../core/providers/achievement_provider.dart';
import 'widgets/achievement_card.dart';
import 'widgets/stats_summary_bar.dart';
import 'widgets/achievement_unlock_overlay.dart';
import 'achievement_detail_page.dart';

class AchievementsPage extends ConsumerStatefulWidget {
  const AchievementsPage({super.key});

  @override
  ConsumerState<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends ConsumerState<AchievementsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<AchievementCategoryModel> _categories = [];
  int _overlayIndex = 0; // which newly unlocked achievement we're showing

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(achievementProvider.notifier).loadAchievements();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _rebuildTabController(int count) {
    if (_tabController.length != count + 1) {
      _tabController.dispose();
      _tabController = TabController(length: count + 1, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(achievementProvider);
    final newlyUnlocked = state.newlyUnlocked;

    // Rebuild tab controller when categories change
    _categories = state.categories;
    _rebuildTabController(_categories.length);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0E1A),
        elevation: 0,
        title: const Text(
          '🏆 دەستکەوتەکان',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: state.isLoading || _categories.isEmpty
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: const Color(0xFFFFD700),
                unselectedLabelColor: Colors.white54,
                indicatorColor: const Color(0xFFFFD700),
                tabs: [
                  const Tab(text: 'هەمووی'),
                  ..._categories.map((c) => Tab(text: '${c.icon} ${c.name}')),
                ],
              ),
      ),
      body: Stack(
        children: [
          _buildBody(state),

          // Achievement unlock overlay (shown one at a time)
          if (newlyUnlocked.isNotEmpty && _overlayIndex < newlyUnlocked.length)
            AchievementUnlockOverlay(
              achievement: newlyUnlocked[_overlayIndex],
              onClose: _handleOverlayClose,
            ),
        ],
      ),
    );
  }

  void _handleOverlayClose() {
    final state = ref.read(achievementProvider);
    if (_overlayIndex < state.newlyUnlocked.length - 1) {
      setState(() => _overlayIndex++);
    } else {
      setState(() => _overlayIndex = 0);
      ref.read(achievementProvider.notifier).clearNewlyUnlocked();
    }
  }

  Widget _buildBody(AchievementState state) {
    if (state.isLoading && state.achievements.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFD700)),
      );
    }

    if (state.errorMessage != null && state.achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(achievementProvider.notifier).loadAchievements(),
              child: const Text('دووبارە هەوڵ بدەرەوە'),
            ),
          ],
        ),
      );
    }

    if (state.achievements.isEmpty) {
      return const Center(
        child: Text('هیچ دەستکەوتەیەک نییە', style: TextStyle(color: Colors.white60)),
      );
    }

    return Column(
      children: [
        // Stats bar
        if (state.summary != null)
          StatsSummaryBar(
            summary: state.summary!,
            rareCount: state.achievements
                .where((a) => a.isHidden && a.isCompleted)
                .length,
          ),

        // Grid
        Expanded(
          child: _categories.isEmpty
              ? _buildGrid(state.achievements)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // "All" tab
                    _buildGrid(state.achievements),
                    // Category tabs
                    ..._categories.map((cat) {
                      final filtered = state.achievements
                          .where((a) => a.category?.id == cat.id)
                          .toList();
                      return _buildGrid(filtered);
                    }),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<AchievementModel> achievements) {
    if (achievements.isEmpty) {
      return const Center(
        child: Text('هیچ دەستکەوتەیەک نییە', style: TextStyle(color: Colors.white38)),
      );
    }

    // Sort: completed first, then by sort order
    final sorted = [...achievements]
      ..sort((a, b) {
        if (a.isCompleted && !b.isCompleted) return -1;
        if (!a.isCompleted && b.isCompleted) return 1;
        return 0;
      });

    return RefreshIndicator(
      color: const Color(0xFFFFD700),
      backgroundColor: const Color(0xFF1E1B4B),
      onRefresh: () =>
          ref.read(achievementProvider.notifier).loadAchievements(),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          return AchievementCard(
            achievement: sorted[index],
            onTap: sorted[index].isStillHidden
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AchievementDetailPage(achievement: sorted[index]),
                      ),
                    ),
          );
        },
      ),
    );
  }
}
