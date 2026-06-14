import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/leaderboard_model.dart';
import '../models/leaderboard_settings_model.dart';
import '../repositories/leaderboard_repository.dart';
import 'app_providers.dart';
import '../network/api_result.dart';

class LeaderboardState {
  final bool isLoading;
  final bool isLoadMore;
  final String? errorMessage;
  final List<LeaderboardModel> rankings;
  final Map<String, dynamic>? userDetails;
  final int currentPage;
  final int lastPage;
  final String periodType; // daily, weekly, monthly, alltime, achievement, streak
  final String? country;
  final String? province;

  LeaderboardState({
    this.isLoading = false,
    this.isLoadMore = false,
    this.errorMessage,
    this.rankings = const [],
    this.userDetails,
    this.currentPage = 1,
    this.lastPage = 1,
    this.periodType = 'weekly',
    this.country,
    this.province,
  });

  LeaderboardState copyWith({
    bool? isLoading,
    bool? isLoadMore,
    String? errorMessage,
    List<LeaderboardModel>? rankings,
    Map<String, dynamic>? userDetails,
    int? currentPage,
    int? lastPage,
    String? periodType,
    String? country,
    String? province,
  }) {
    return LeaderboardState(
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      errorMessage: errorMessage ?? this.errorMessage,
      rankings: rankings ?? this.rankings,
      userDetails: userDetails ?? this.userDetails,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      periodType: periodType ?? this.periodType,
      country: country ?? this.country,
      province: province ?? this.province,
    );
  }
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaderboardRepository(apiClient);
});

class LeaderboardNotifier extends StateNotifier<LeaderboardState> {
  final LeaderboardRepository _repository;

  LeaderboardNotifier(this._repository) : super(LeaderboardState());

  /// Fetch rankings with infinite scrolling.
  Future<void> fetchRankings({bool refresh = false}) async {
    if (state.isLoading || state.isLoadMore) return;

    final int targetPage = refresh ? 1 : state.currentPage + 1;
    if (!refresh && targetPage > state.lastPage) return;

    if (refresh) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    } else {
      state = state.copyWith(isLoadMore: true, errorMessage: null);
    }

    final result = await _repository.getLeaderboard(
      type: state.periodType,
      page: targetPage,
      country: state.country,
      province: state.province,
    );

    if (result is ApiSuccess<Map<String, dynamic>>) {
      final List<LeaderboardModel> newRankings = result.data['rankings'] ?? [];
      final userDetails = result.data['current_user_rank'];
      final pagination = result.data['pagination'] ?? {};

      state = state.copyWith(
        isLoading: false,
        isLoadMore: false,
        rankings: refresh ? newRankings : [...state.rankings, ...newRankings],
        userDetails: userDetails,
        currentPage: pagination['current_page'] ?? targetPage,
        lastPage: pagination['last_page'] ?? 1,
      );
    } else if (result is ApiError<Map<String, dynamic>>) {
      state = state.copyWith(
        isLoading: false,
        isLoadMore: false,
        errorMessage: result.message,
      );
    }
  }

  /// Change leaderboard period filter.
  void changePeriod(String type) {
    state = state.copyWith(periodType: type, currentPage: 1, rankings: []);
    fetchRankings(refresh: true);
  }

  /// Apply geographic filters.
  void applyFilters({String? country, String? province}) {
    state = state.copyWith(
      country: country,
      province: province,
      currentPage: 1,
      rankings: [],
    );
    fetchRankings(refresh: true);
  }

  /// Update privacy preferences and clear cached rankings locally.
  Future<bool> updatePrivacy(LeaderboardSettingsModel settings) async {
    final result = await _repository.updatePrivacy(settings);
    if (result is ApiSuccess<LeaderboardSettingsModel>) {
      // Re-fetch rankings list to update matching data immediately
      fetchRankings(refresh: true);
      return true;
    }
    return false;
  }
}

final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, LeaderboardState>((ref) {
  final repo = ref.watch(leaderboardRepositoryProvider);
  return LeaderboardNotifier(repo)..fetchRankings(refresh: true);
});
