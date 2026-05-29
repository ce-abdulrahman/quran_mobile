import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/app_providers.dart';
import '../../core/l10n/app_localizations.dart';
import '../auth/auth_provider.dart';
import 'community_provider.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  Future<void> _refreshData(String period) async {
    HapticFeedback.lightImpact();
    ref.invalidate(leaderboardProvider(period));
    ref.invalidate(myStatsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final l = context.l10n;
    final period = ref.watch(leaderboardPeriodProvider);
    final leaderboardAsync = ref.watch(leaderboardProvider(period));
    final myStatsAsync = ref.watch(myStatsProvider);
    final currentUser = ref.watch(authProvider).user;
    final lang = ref.watch(localeProvider).languageCode;
    final isRtl = lang != 'en';

    return Scaffold(
      backgroundColor: cs.bg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(period),
          color: cs.primary,
          child: CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l.communityTitle,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: cs.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh_rounded, color: cs.textSecondary),
                        onPressed: () => _refreshData(period),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),

              // ── Segmented Control Filter ───────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cs.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.cardBorder),
                  ),
                  child: Row(
                    children: [
                      _buildPeriodTab('daily', l.communityDaily, period, cs),
                      _buildPeriodTab('weekly', l.communityWeekly, period, cs),
                      _buildPeriodTab('monthly', l.communityMonthly, period, cs),
                      _buildPeriodTab('alltime', l.communityAllTime, period, cs),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              ),

              // ── Leaderboard Content ───────────────────────────────
              leaderboardAsync.when(
                data: (users) {
                  if (users.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          l.communityNoUsers,
                          style: TextStyle(fontFamily: 'Cairo', color: cs.textSecondary),
                        ),
                      ),
                    );
                  }

                  final hasPodium = users.length >= 3;
                  final podiumUsers = hasPodium ? users.sublist(0, 3) : <Map<String, dynamic>>[];
                  final listUsers = hasPodium ? users.sublist(3) : users;

                  return SliverList(
                    delegate: SliverChildListDelegate([
                      // Podium for top 3
                      if (hasPodium)
                        _Podium(
                          users: podiumUsers,
                          currentUser: currentUser,
                          cs: cs,
                          ptsLabel: l.communityPoints,
                          streakLabel: l.communityStreak,
                        ).animate().fadeIn(duration: 500.ms, delay: 150.ms),

                      const SizedBox(height: 12),

                      // Rank list for the rest
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: listUsers.length,
                        itemBuilder: (context, i) {
                          final user = listUsers[i];
                          final isMe = currentUser != null && currentUser.id == user['id'];
                          final rank = user['rank'] ?? (i + (hasPodium ? 4 : 1));

                          return _UserRankRow(
                            user: user,
                            rank: rank,
                            isMe: isMe,
                            cs: cs,
                            ptsLabel: l.communityPoints,
                            streakLabel: l.communityStreak,
                            isRtl: isRtl,
                          ).animate().fadeIn(duration: 300.ms, delay: (i * 30).ms);
                        },
                      ),

                      // Bottom padding to avoid overlaying floating bar
                      const SizedBox(height: 100),
                    ]),
                  );
                },
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, stack) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Error: $err',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Cairo', color: AppColors.error),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Sticky User Rank at bottom
      bottomNavigationBar: myStatsAsync.when(
        data: (stats) {
          final myRank = stats['rank'] as int? ?? 0;
          final myUser = stats['user'] as Map<String, dynamic>?;
          if (myUser == null) return const SizedBox.shrink();

          // If the user is logged in, show their sticky ranking row
          return _StickyMyRankBar(
            rank: myRank,
            user: myUser,
            cs: cs,
            isRtl: isRtl,
            ptsLabel: l.communityPoints,
            streakLabel: l.communityStreak,
            youText: l.communityYou,
          ).animate().slideY(begin: 1.0, duration: 400.ms, curve: Curves.easeOut);
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildPeriodTab(String key, String label, String activeKey, AppColorScheme cs) {
    final isActive = key == activeKey;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          ref.read(leaderboardPeriodProvider.notifier).state = key;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : cs.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── 3D Podium for Top 3 ──────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  const _Podium({
    required this.users,
    required this.currentUser,
    required this.cs,
    required this.ptsLabel,
    required this.streakLabel,
  });

  final List<Map<String, dynamic>> users;
  final UserModel? currentUser;
  final AppColorScheme cs;
  final String ptsLabel;
  final String streakLabel;

  @override
  Widget build(BuildContext context) {
    // 0: First, 1: Second, 2: Third in data.
    // In layout: [2nd, 1st, 3rd]
    final user1 = users[0];
    final user2 = users[1];
    final user3 = users[2];

    final isMe1 = currentUser != null && currentUser!.id == user1['id'];
    final isMe2 = currentUser != null && currentUser!.id == user2['id'];
    final isMe3 = currentUser != null && currentUser!.id == user3['id'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      decoration: BoxDecoration(
        color: cs.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 2nd Place
          Expanded(
            child: _PodiumColumn(
              user: user2,
              rank: 2,
              height: 100,
              isMe: isMe2,
              cs: cs,
              ptsLabel: ptsLabel,
              streakLabel: streakLabel,
              color: const Color(0xFFC0C0C0), // Silver
            ),
          ),
          // 1st Place
          Expanded(
            child: _PodiumColumn(
              user: user1,
              rank: 1,
              height: 140,
              isMe: isMe1,
              cs: cs,
              ptsLabel: ptsLabel,
              streakLabel: streakLabel,
              color: AppColors.accentGold, // Gold
              hasCrown: true,
            ),
          ),
          // 3rd Place
          Expanded(
            child: _PodiumColumn(
              user: user3,
              rank: 3,
              height: 80,
              isMe: isMe3,
              cs: cs,
              ptsLabel: ptsLabel,
              streakLabel: streakLabel,
              color: const Color(0xFFCD7F32), // Bronze
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({
    required this.user,
    required this.rank,
    required this.height,
    required this.isMe,
    required this.cs,
    required this.ptsLabel,
    required this.streakLabel,
    required this.color,
    this.hasCrown = false,
  });

  final Map<String, dynamic> user;
  final int rank;
  final double height;
  final bool isMe;
  final AppColorScheme cs;
  final String ptsLabel;
  final String streakLabel;
  final Color color;
  final bool hasCrown;

  @override
  Widget build(BuildContext context) {
    final initials = user['name'] != null && (user['name'] as String).isNotEmpty
        ? (user['name'] as String).substring(0, 1).toUpperCase()
        : '?';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Avatar + Crown
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: rank == 1 ? 64 : 52,
              height: rank == 1 ? 64 : 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: rank == 1 ? 3 : 2),
                gradient: LinearGradient(
                  colors: isMe
                      ? [cs.primary, cs.primary.withValues(alpha: 0.7)]
                      : [cs.surface, cs.cardBorder],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: rank == 1 ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.white : cs.textPrimary,
                  ),
                ),
              ),
            ),
            if (hasCrown)
              Positioned(
                top: -18,
                child: const Text(
                  '👑',
                  style: TextStyle(fontSize: 20),
                ).animate().shake(duration: 1.seconds, hz: 2),
              ),
            // Rank badge below avatar
            Positioned(
              bottom: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            user['name'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: isMe ? FontWeight.w800 : FontWeight.w700,
              color: isMe ? cs.primary : cs.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 2),
        // Points
        Text(
          '${user['points']} $ptsLabel',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        // Streak indicator
        if ((user['streak_days'] ?? 0) > 0) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 10)),
              const SizedBox(width: 2),
              Text(
                '${user['streak_days']}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  color: cs.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        // Podium Column bar
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.02)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border(
              top: BorderSide(color: color.withValues(alpha: 0.3), width: 1.5),
              left: BorderSide(color: color.withValues(alpha: 0.1), width: 1),
              right: BorderSide(color: color.withValues(alpha: 0.1), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Standard Rank List Row ───────────────────────────────────────────────────

class _UserRankRow extends StatelessWidget {
  const _UserRankRow({
    required this.user,
    required this.rank,
    required this.isMe,
    required this.cs,
    required this.ptsLabel,
    required this.streakLabel,
    required this.isRtl,
  });

  final Map<String, dynamic> user;
  final int rank;
  final bool isMe;
  final AppColorScheme cs;
  final String ptsLabel;
  final String streakLabel;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final initials = user['name'] != null && (user['name'] as String).isNotEmpty
        ? (user['name'] as String).substring(0, 1).toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? cs.primary.withValues(alpha: 0.08) : cs.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe ? cs.primary.withValues(alpha: 0.3) : cs.cardBorder,
          width: isMe ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Rank Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMe ? cs.primary : cs.bg,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.white : cs.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // User Initial Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: cs.primary.withValues(alpha: 0.12),
            child: Text(
              initials,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // User Name & Streak
          Expanded(
            child: Column(
              crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'] ?? '',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: cs.textPrimary,
                  ),
                ),
                if ((user['streak_days'] ?? 0) > 0) ...[
                  const SizedBox(height: 2),
                  Row(
                    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${user['streak_days']} $streakLabel',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10.5,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Points
          Text(
            '${user['points']} $ptsLabel',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sticky User Ranking Bottom Bar ──────────────────────────────────────────

class _StickyMyRankBar extends StatelessWidget {
  const _StickyMyRankBar({
    required this.rank,
    required this.user,
    required this.cs,
    required this.isRtl,
    required this.ptsLabel,
    required this.streakLabel,
    required this.youText,
  });

  final int rank;
  final Map<String, dynamic> user;
  final AppColorScheme cs;
  final bool isRtl;
  final String ptsLabel;
  final String streakLabel;
  final String youText;

  @override
  Widget build(BuildContext context) {
    final initials = user['name'] != null && (user['name'] as String).isNotEmpty
        ? (user['name'] as String).substring(0, 1).toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color: cs.card.withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: cs.primary.withValues(alpha: 0.4), width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              // Rank
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // User Initial
              CircleAvatar(
                radius: 16,
                backgroundColor: cs.primary.withValues(alpha: 0.15),
                child: Text(
                  initials,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name & You label
              Expanded(
                child: Column(
                  crossAxisAlignment: isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Text(
                          user['name'] ?? '',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: cs.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            youText,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if ((user['streak_days'] ?? 0) > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        '🔥 ${user['streak_days']} $streakLabel',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10.5,
                          color: cs.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Points
              Text(
                '${user['points_total']} $ptsLabel',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
