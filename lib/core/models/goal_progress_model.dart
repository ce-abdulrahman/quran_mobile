class GoalProgressModel {
  final int currentProgress;
  final int goalValue;
  final double percentage;
  final bool isCompleted;
  final String? completedAt;

  const GoalProgressModel({
    required this.currentProgress,
    required this.goalValue,
    required this.percentage,
    required this.isCompleted,
    this.completedAt,
  });

  factory GoalProgressModel.fromJson(Map<String, dynamic> json) {
    return GoalProgressModel(
      currentProgress: json['current_progress'] as int? ?? 0,
      goalValue: json['goal_value'] as int? ?? 100,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
      completedAt: json['completed_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_progress': currentProgress,
      'goal_value': goalValue,
      'percentage': percentage,
      'is_completed': isCompleted,
      'completed_at': completedAt,
    };
  }
}
