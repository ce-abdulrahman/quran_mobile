class DailyGoalModel {
  final int goalValue;
  final int todayProgress;
  final double percentage;
  final bool isCompleted;

  const DailyGoalModel({
    required this.goalValue,
    required this.todayProgress,
    required this.percentage,
    required this.isCompleted,
  });

  factory DailyGoalModel.fromJson(Map<String, dynamic> json) {
    return DailyGoalModel(
      goalValue: json['goal_value'] as int? ?? 100,
      todayProgress: json['today_progress'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_value': goalValue,
      'today_progress': todayProgress,
      'percentage': percentage,
      'is_completed': isCompleted,
    };
  }
}
