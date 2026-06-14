class LeaderboardSettingsModel {
  final bool isPublic;
  final bool isAnonymous;
  final bool isHidden;

  LeaderboardSettingsModel({
    required this.isPublic,
    required this.isAnonymous,
    required this.isHidden,
  });

  factory LeaderboardSettingsModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardSettingsModel(
      isPublic: json['is_public'] ?? true,
      isAnonymous: json['is_anonymous'] ?? false,
      isHidden: json['is_hidden'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_public': isPublic,
      'is_anonymous': isAnonymous,
      'is_hidden': isHidden,
    };
  }

  LeaderboardSettingsModel copyWith({
    bool? isPublic,
    bool? isAnonymous,
    bool? isHidden,
  }) {
    return LeaderboardSettingsModel(
      isPublic: isPublic ?? this.isPublic,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
