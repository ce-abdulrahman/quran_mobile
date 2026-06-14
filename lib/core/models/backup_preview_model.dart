class BackupPreviewModel {
  final String backupVersion;
  final String appVersion;
  final String deviceType;
  final String platform;
  final DateTime? createdAt;
  final String? userUuid;
  
  final int sessionsCount;
  final int goalsCount;
  final int achievementsCount;
  final int remindersCount;
  final int bookmarksCount;
  final int favoritesCount;

  final int sessionConflicts;
  final int goalConflicts;

  const BackupPreviewModel({
    required this.backupVersion,
    required this.appVersion,
    required this.deviceType,
    required this.platform,
    this.createdAt,
    this.userUuid,
    required this.sessionsCount,
    required this.goalsCount,
    required this.achievementsCount,
    required this.remindersCount,
    required this.bookmarksCount,
    required this.favoritesCount,
    required this.sessionConflicts,
    required this.goalConflicts,
  });

  factory BackupPreviewModel.fromJson(Map<String, dynamic> json) {
    final counts = json['counts'] as Map<String, dynamic>? ?? {};
    final conflicts = json['conflicts'] as Map<String, dynamic>? ?? {};

    return BackupPreviewModel(
      backupVersion: json['backup_version'] as String? ?? '1.0',
      appVersion: json['app_version'] as String? ?? 'Unknown',
      deviceType: json['device_type'] as String? ?? 'Unknown',
      platform: json['platform'] as String? ?? 'Unknown',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      userUuid: json['user_uuid'] as String?,
      
      sessionsCount: counts['sessions'] as int? ?? 0,
      goalsCount: counts['goals'] as int? ?? 0,
      achievementsCount: counts['achievements'] as int? ?? 0,
      remindersCount: counts['reminders'] as int? ?? 0,
      bookmarksCount: counts['bookmarks'] as int? ?? 0,
      favoritesCount: counts['favorites'] as int? ?? 0,

      sessionConflicts: conflicts['sessions'] as int? ?? 0,
      goalConflicts: conflicts['goals'] as int? ?? 0,
    );
  }
}
