class FingerprintStatisticsModel {
  final int? id;
  final int totalCounts;
  final int totalSessions;
  final int totalBlindSessions;
  final int totalFocusSessions;
  final double avgTouchRate;
  final String favoriteMode;
  final DateTime? lastUsedAt;

  const FingerprintStatisticsModel({
    this.id,
    required this.totalCounts,
    required this.totalSessions,
    required this.totalBlindSessions,
    required this.totalFocusSessions,
    required this.avgTouchRate,
    required this.favoriteMode,
    this.lastUsedAt,
  });

  factory FingerprintStatisticsModel.fromJson(Map<String, dynamic> json) {
    return FingerprintStatisticsModel(
      id: json['id'] as int?,
      totalCounts: json['total_counts'] as int? ?? 0,
      totalSessions: json['total_sessions'] as int? ?? 0,
      totalBlindSessions: json['total_blind_sessions'] as int? ?? 0,
      totalFocusSessions: json['total_focus_sessions'] as int? ?? 0,
      avgTouchRate: (json['avg_touch_rate'] as num?)?.toDouble() ?? 0.0,
      favoriteMode: json['favorite_mode'] as String? ?? 'single_touch',
      lastUsedAt: json['last_used_at'] != null 
          ? DateTime.tryParse(json['last_used_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_counts': totalCounts,
      'total_sessions': totalSessions,
      'total_blind_sessions': totalBlindSessions,
      'total_focus_sessions': totalFocusSessions,
      'avg_touch_rate': avgTouchRate,
      'favorite_mode': favoriteMode,
      'last_used_at': lastUsedAt?.toIso8601String(),
    };
  }

  FingerprintStatisticsModel copyWith({
    int? id,
    int? totalCounts,
    int? totalSessions,
    int? totalBlindSessions,
    int? totalFocusSessions,
    double? avgTouchRate,
    String? favoriteMode,
    DateTime? lastUsedAt,
  }) {
    return FingerprintStatisticsModel(
      id: id ?? this.id,
      totalCounts: totalCounts ?? this.totalCounts,
      totalSessions: totalSessions ?? this.totalSessions,
      totalBlindSessions: totalBlindSessions ?? this.totalBlindSessions,
      totalFocusSessions: totalFocusSessions ?? this.totalFocusSessions,
      avgTouchRate: avgTouchRate ?? this.avgTouchRate,
      favoriteMode: favoriteMode ?? this.favoriteMode,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  factory FingerprintStatisticsModel.zero() {
    return const FingerprintStatisticsModel(
      totalCounts: 0,
      totalSessions: 0,
      totalBlindSessions: 0,
      totalFocusSessions: 0,
      avgTouchRate: 0.0,
      favoriteMode: 'single_touch',
    );
  }
}
