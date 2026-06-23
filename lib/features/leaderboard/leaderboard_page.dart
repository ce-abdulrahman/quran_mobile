import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/widgets/auth_gate_card.dart';
import '../../core/models/leaderboard_model.dart';
import '../../core/models/leaderboard_settings_model.dart';
import '../../core/providers/leaderboard_provider.dart';

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        AuthGateCard.showProtectProgressSheet(
          context,
          ref,
          featureContext: 'ڕیزبەندی پێشەنگەکان خاڵەکانی بەکارهێنەران نیشان دەدات لەسەر بنەمای تەسبیحەکان و پێشکەوتنی لەبەرکردنی قورئان لەگەڵ هەموو بەکارهێنەرانی تر.',
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(leaderboardProvider.notifier).fetchRankings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final cs = AppColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: cs.bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorScheme.darken(cs.primary, 0.35) : cs.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'پێشەنگەکان', // Leaderboard in Kurdish
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            onPressed: () => _showFiltersSheet(context),
          ),
          if (authState.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.security_rounded, color: Colors.white),
              onPressed: () => _showPrivacySheet(context),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // ── Period Selectors (Sliding Pills) ──────────────────────────
              _buildPeriodSelector(state),

              // ── Main Content / Listings ───────────────────────────────────
              Expanded(
                child: RefreshIndicator(
                  color: cs.primary,
                  onRefresh: () => ref.read(leaderboardProvider.notifier).fetchRankings(refresh: true),
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.errorMessage != null
                          ? Center(child: Text(state.errorMessage!, style: const TextStyle(fontFamily: 'Cairo')))
                          : CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                // 1. Podium Showcase for Top 3
                                SliverToBoxAdapter(
                                  child: _buildPodium(context, state.rankings),
                                ),

                                // 2. Standing Listings
                                SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (ctx, idx) {
                                        if (idx >= state.rankings.length) {
                                          return state.isLoadMore
                                              ? const Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16),
                                                  child: Center(child: CircularProgressIndicator()),
                                                )
                                              : const SizedBox.shrink();
                                        }
                                        // Skip the top 3 since they are in the podium
                                        if (idx < 3) return const SizedBox.shrink();

                                        final userRank = state.rankings[idx];
                                        return _buildRankCard(context, userRank, cs);
                                      },
                                      childCount: state.rankings.length + 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),

          // ── Sticky User Rank Status Bar at Bottom ────────────────────────
          if (state.userDetails != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildStickyUserPanel(context, state.userDetails!, cs),
            ),
        ],
      ),
    );
  }

  /// Period Selector Horizontal Bar
  Widget _buildPeriodSelector(LeaderboardState state) {
    final periods = [
      {'key': 'daily', 'label': 'ڕۆژانە'},
      {'key': 'weekly', 'label': 'هەفتانە'},
      {'key': 'monthly', 'label': 'مانگانە'},
      {'key': 'alltime', 'label': 'هەمیشەیی'},
      {'key': 'achievement', 'label': 'دەستکەوت'},
      {'key': 'streak', 'label': 'بەردەوامی'},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: periods.length,
        itemBuilder: (ctx, idx) {
          final p = periods[idx];
          final active = state.periodType == p['key'];
          final activeColor = AppColorScheme.of(context).primary;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => ref.read(leaderboardProvider.notifier).changePeriod(p['key']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? activeColor : activeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  p['label']!,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: active ? Colors.white : activeColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Podiums Grid
  Widget _buildPodium(BuildContext context, List<LeaderboardModel> rankings) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place (Left)
          _buildPodiumCell(
            context,
            rankings.length > 1 ? rankings[1] : null,
            2,
            height: 110,
            badgeColor: const Color(0xFFC0C0C0),
          ),
          const SizedBox(width: 16),
          // 1st Place (Center)
          _buildPodiumCell(
            context,
            rankings.isNotEmpty ? rankings[0] : null,
            1,
            height: 145,
            badgeColor: const Color(0xFFFFD700),
            showCrown: true,
          ),
          const SizedBox(width: 16),
          // 3rd Place (Right)
          _buildPodiumCell(
            context,
            rankings.length > 2 ? rankings[2] : null,
            3,
            height: 90,
            badgeColor: const Color(0xFFCD7F32),
          ),
        ],
      ),
    );
  }

  /// Singular Podium item
  Widget _buildPodiumCell(
    BuildContext context,
    LeaderboardModel? user,
    int rank, {
    required double height,
    required Color badgeColor,
    bool showCrown = false,
  }) {
    final cs = AppColorScheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (user != null) ...[
          if (showCrown)
            const Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD700), size: 28)
                .animate()
                .scale(delay: 200.ms, duration: 400.ms),
          CircleAvatar(
            radius: 26,
            backgroundColor: badgeColor.withValues(alpha: 0.2),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: cs.primary,
              child: Text(
                user.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            user.name,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: cs.textPrimary,
            ),
          ),
          Text(
            '${user.score} خاڵ',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ] else ...[
          const CircleAvatar(
            radius: 23,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person_outline_rounded, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text('—', style: TextStyle(color: Colors.grey)),
        ],
        const SizedBox(height: 10),
        // The Podium Base
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [badgeColor, badgeColor.withValues(alpha: 0.6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withValues(alpha: 0.25),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ).animate().slideY(begin: 0.2, curve: Curves.easeOutQuad, duration: 500.ms);
  }

  /// List tile card
  Widget _buildRankCard(BuildContext context, LeaderboardModel user, AppColorScheme cs) {
    return Card(
      color: cs.card,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.cardBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Rank Number
            SizedBox(
              width: 35,
              child: Text(
                '#${user.rank}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: cs.textSecondary,
                ),
              ),
            ),

            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: cs.primary.withValues(alpha: 0.15),
              child: Text(
                user.name.substring(0, 1).toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary),
              ),
            ),
            const SizedBox(width: 12),

            // User Profile Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: cs.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Score Value
            Text(
              '${user.score} خاڵ',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 12),

            // Movement
            _buildMovementIcon(user.movement),
          ],
        ),
      ),
    );
  }

  /// Movement indicator builder
  Widget _buildMovementIcon(String movement) {
    if (movement == 'up') {
      return const Icon(Icons.arrow_upward_rounded, color: Colors.green, size: 18);
    } else if (movement == 'down') {
      return const Icon(Icons.arrow_downward_rounded, color: Colors.red, size: 18);
    } else if (movement == 'none') {
      return const Icon(Icons.remove_rounded, color: Colors.grey, size: 18);
    }
    return const Icon(Icons.star_rounded, color: Colors.blue, size: 18); // 'new'
  }

  /// Sticky user profile panel
  Widget _buildStickyUserPanel(
    BuildContext context,
    Map<String, dynamic> me,
    AppColorScheme cs,
  ) {
    final rank = me['rank'] ?? 0;
    final score = me['score'] ?? 0;
    final gap = me['next_rank_gap'] ?? 0;
    final movement = me['movement'] ?? 'new';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: cs.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      'پلەت: #$rank',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: cs.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildMovementIcon(movement),
                  ],
                ),
                if (gap > 0)
                  Text(
                    '+$gap بۆ پلەی داهاتوو',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.textSecondary,
                    ),
                  ),
              ],
            ),
            Text(
              '$score خاڵ',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Geographic Filters Sheet
  void _showFiltersSheet(BuildContext context) {
    final countryCtrl = TextEditingController();
    final provinceCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColorScheme.of(context).card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final cs = AppColorScheme.of(context);
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'پاڵاوتنی ڕیزبەندی',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: countryCtrl,
                decoration: const InputDecoration(labelText: 'وڵات (Country)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: provinceCtrl,
                decoration: const InputDecoration(labelText: 'پارێزگا (Province)'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final c = countryCtrl.text.trim();
                  final p = provinceCtrl.text.trim();
                  ref.read(leaderboardProvider.notifier).applyFilters(
                        country: c.isEmpty ? null : c,
                        province: p.isEmpty ? null : p,
                      );
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'جێبەجێکردن',
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// User Privacy Settings Sheet
  void _showPrivacySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColorScheme.of(context).card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            // Read initial state
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'پاراستنی تایبەتمەندی',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text('پڕۆفایلی گشتی', style: TextStyle(fontFamily: 'Cairo')),
                    subtitle: const Text('ناوی ڕاستەقینەت لە ڕیزبەندی نیشان بدرێت', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ref.read(leaderboardProvider.notifier).updatePrivacy(
                            LeaderboardSettingsModel(isPublic: true, isAnonymous: false, isHidden: false),
                          );
                      Navigator.pop(ctx);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('مۆدی نادیار (Anonymous)', style: TextStyle(fontFamily: 'Cairo')),
                    subtitle: const Text('ناوی پڕۆفایلەکەت وەک بەکارهێنەرێکی نەناسراو نیشان بدرێت', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ref.read(leaderboardProvider.notifier).updatePrivacy(
                            LeaderboardSettingsModel(isPublic: false, isAnonymous: true, isHidden: false),
                          );
                      Navigator.pop(ctx);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('شاردراوە لە ڕیزبەندی', style: TextStyle(fontFamily: 'Cairo')),
                    subtitle: const Text('خاڵەکانت تۆمار بکرێن بەڵام لە ڕیزبەندی نیشان نەدرێیت', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ref.read(leaderboardProvider.notifier).updatePrivacy(
                            LeaderboardSettingsModel(isPublic: false, isAnonymous: false, isHidden: true),
                          );
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
