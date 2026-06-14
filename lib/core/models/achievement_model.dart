class AchievementCategoryModel {
  final int id;
  final String name;
  final String icon;

  const AchievementCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory AchievementCategoryModel.fromJson(Map<String, dynamic> json) {
    return AchievementCategoryModel(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      icon: (json['icon'] as String?) ?? '🏆',
    );
  }
}

class AchievementModel {
  final int id;
  final String key;
  final String name;
  final String? description;
  final String icon;
  final String? badgeImage;
  final AchievementCategoryModel? category;
  final String conditionType;
  final int conditionValue;
  final String rewardType;
  final int rewardPoints;
  final String? rewardValue;
  final int version;
  final bool isHidden;
  // User progress
  final bool isCompleted;
  final int progressValue;
  final DateTime? completedAt;
  final int? unlockedVersion;

  const AchievementModel({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    required this.icon,
    this.badgeImage,
    this.category,
    required this.conditionType,
    required this.conditionValue,
    required this.rewardType,
    required this.rewardPoints,
    this.rewardValue,
    required this.version,
    required this.isHidden,
    required this.isCompleted,
    required this.progressValue,
    this.completedAt,
    this.unlockedVersion,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as int,
      key: json['key'] as String,
      name: (json['name'] as String?) ?? '',
      description: json['description'] as String?,
      icon: (json['icon'] as String?) ?? '🏆',
      badgeImage: json['badge_image'] as String?,
      category: json['category'] != null
          ? AchievementCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      conditionType: json['condition_type'] as String,
      conditionValue: json['condition_value'] as int,
      rewardType: (json['reward_type'] as String?) ?? 'POINTS',
      rewardPoints: (json['reward_points'] as int?) ?? 0,
      rewardValue: json['reward_value'] as String?,
      version: (json['version'] as int?) ?? 1,
      isHidden: (json['is_hidden'] as bool?) ?? false,
      isCompleted: (json['is_completed'] as bool?) ?? false,
      progressValue: (json['progress_value'] as int?) ?? 0,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      unlockedVersion: json['unlocked_version'] as int?,
    );
  }

  /// Completion progress as 0.0–1.0
  double get progressFraction =>
      conditionValue > 0 ? (progressValue / conditionValue).clamp(0.0, 1.0) : 0.0;

  /// Whether the achievement name/icon should still be hidden from the user
  bool get isStillHidden => isHidden && !isCompleted;
}

class AchievementSummaryModel {
  final int totalAvailable;
  final int totalEarned;
  final double completionPct;
  final int rareEarned;

  const AchievementSummaryModel({
    required this.totalAvailable,
    required this.totalEarned,
    required this.completionPct,
    required this.rareEarned,
  });

  factory AchievementSummaryModel.fromJson(Map<String, dynamic> json) {
    return AchievementSummaryModel(
      totalAvailable: (json['total_available'] as int?) ?? 0,
      totalEarned: (json['total_earned'] as int?) ?? 0,
      completionPct: ((json['completion_pct'] as num?) ?? 0).toDouble(),
      rareEarned: (json['rare_earned'] as int?) ?? 0,
    );
  }
}
