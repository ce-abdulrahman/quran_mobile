import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement_model.dart';
import '../repositories/achievement_repository.dart';
import 'app_providers.dart';

// ── Repository Provider ──────────────────────────────────────────────────────

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AchievementRepository(apiClient);
});

// ── State ────────────────────────────────────────────────────────────────────

class AchievementState {
  final List<AchievementModel> achievements;
  final AchievementSummaryModel? summary;
  final bool isLoading;
  final String? errorMessage;
  /// Achievements just unlocked in the last sync — shown in the overlay
  final List<AchievementModel> newlyUnlocked;
  /// Selected category filter (null = all)
  final int? selectedCategoryId;

  const AchievementState({
    this.achievements = const [],
    this.summary,
    this.isLoading = false,
    this.errorMessage,
    this.newlyUnlocked = const [],
    this.selectedCategoryId,
  });

  AchievementState copyWith({
    List<AchievementModel>? achievements,
    AchievementSummaryModel? summary,
    bool? isLoading,
    String? errorMessage,
    List<AchievementModel>? newlyUnlocked,
    int? selectedCategoryId,
    bool clearNewlyUnlocked = false,
    bool clearError = false,
  }) {
    return AchievementState(
      achievements:       achievements ?? this.achievements,
      summary:            summary ?? this.summary,
      isLoading:          isLoading ?? this.isLoading,
      errorMessage:       clearError ? null : (errorMessage ?? this.errorMessage),
      newlyUnlocked:      clearNewlyUnlocked ? [] : (newlyUnlocked ?? this.newlyUnlocked),
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  /// Achievements grouped by category name
  Map<String, List<AchievementModel>> get byCategory {
    final Map<String, List<AchievementModel>> map = {};
    for (final a in filtered) {
      final catName = a.category?.name ?? 'Other';
      map.putIfAbsent(catName, () => []).add(a);
    }
    return map;
  }

  /// Achievements filtered by selectedCategoryId
  List<AchievementModel> get filtered {
    if (selectedCategoryId == null) return achievements;
    return achievements
        .where((a) => a.category?.id == selectedCategoryId)
        .toList();
  }

  List<AchievementModel> get completed =>
      achievements.where((a) => a.isCompleted).toList();

  List<String> get categoryNames {
    final names = <String>{'All'};
    for (final a in achievements) {
      if (a.category != null) names.add(a.category!.name);
    }
    return names.toList();
  }

  List<AchievementCategoryModel> get categories {
    final seen = <int>{};
    final cats = <AchievementCategoryModel>[];
    for (final a in achievements) {
      if (a.category != null && seen.add(a.category!.id)) {
        cats.add(a.category!);
      }
    }
    return cats;
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class AchievementNotifier extends StateNotifier<AchievementState> {
  final AchievementRepository _repository;

  AchievementNotifier(this._repository) : super(const AchievementState());

  /// Load all achievements from the API.
  Future<void> loadAchievements() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getAchievements();
    result.when(
      success: (data) {
        final rawList = (data['achievements'] as List?) ?? [];
        final achievements = rawList
            .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final summary = data['summary'] != null
            ? AchievementSummaryModel.fromJson(data['summary'] as Map<String, dynamic>)
            : null;
        state = state.copyWith(
          achievements: achievements,
          summary: summary,
          isLoading: false,
        );
      },
      error: (msg, _, __) {
        state = state.copyWith(isLoading: false, errorMessage: msg);
      },
    );
  }

  /// Sync progress with backend — evaluates all condition types from payload.
  /// Returns list of newly unlocked achievements (shown in overlay).
  Future<List<AchievementModel>> syncProgress({
    int? totalDhikrCount,
    int? currentStreak,
    int? goalsCompleted,
    int? sessionDhikrCount,
  }) async {
    final result = await _repository.sync(
      totalDhikrCount: totalDhikrCount,
      currentStreak: currentStreak,
      goalsCompleted: goalsCompleted,
      sessionDhikrCount: sessionDhikrCount,
    );

    return result.when(
      success: (newlyUnlocked) {
        if (newlyUnlocked.isNotEmpty) {
          // Update state with newly unlocked — triggers UI overlay
          state = state.copyWith(newlyUnlocked: newlyUnlocked);
          // Refresh the full list to get updated progress values
          loadAchievements();
        }
        return newlyUnlocked;
      },
      error: (_, __, ___) => [],
    );
  }

  /// Clear the newly unlocked queue after showing the overlay.
  void clearNewlyUnlocked() {
    state = state.copyWith(clearNewlyUnlocked: true);
  }

  /// Set category filter (null = show all).
  void setCategory(int? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────

final achievementProvider =
    StateNotifierProvider<AchievementNotifier, AchievementState>((ref) {
  final repo = ref.watch(achievementRepositoryProvider);
  return AchievementNotifier(repo);
});
