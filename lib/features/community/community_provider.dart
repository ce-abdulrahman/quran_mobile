import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';

// Current leaderboard period selection: 'daily', 'weekly', 'monthly', 'alltime'
final leaderboardPeriodProvider = StateProvider<String>((ref) => 'alltime');

// Leaderboard list provider
final leaderboardProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, period) async {
  final client = ref.watch(quranApiClientProvider);
  return await client.fetchLeaderboard(period);
});

// User personal ranking and stats provider
final myStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = ref.watch(quranApiClientProvider);
  return await client.fetchMyStats();
});
