class BackupModel {
  final int id;
  final String backupType;
  final String storageType;
  final String backupVersion;
  final String fileName;
  final int fileSize;
  final String checksumSha256;
  final bool isEncrypted;
  final String status;
  final String? deviceType;
  final String? platform;
  final String? appVersion;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const BackupModel({
    required this.id,
    required this.backupType,
    required this.storageType,
    required this.backupVersion,
    required this.fileName,
    required this.fileSize,
    required this.checksumSha256,
    required this.isEncrypted,
    required this.status,
    this.deviceType,
    this.platform,
    this.appVersion,
    required this.createdAt,
    this.expiresAt,
  });

  factory BackupModel.fromJson(Map<String, dynamic> json) {
    return BackupModel(
      id: json['id'] as int? ?? 0,
      backupType: json['backup_type'] as String? ?? 'manual',
      storageType: json['storage_type'] as String? ?? 'local',
      backupVersion: json['backup_version'] as String? ?? '1.0',
      fileName: json['file_name'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      checksumSha256: json['checksum_sha256'] as String? ?? '',
      isEncrypted: json['is_encrypted'] == true || json['is_encrypted'] == 1,
      status: json['status'] as String? ?? 'pending',
      deviceType: json['device_type'] as String?,
      platform: json['platform'] as String?,
      appVersion: json['app_version'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'backup_type': backupType,
      'storage_type': storageType,
      'backup_version': backupVersion,
      'file_name': fileName,
      'file_size': fileSize,
      'checksum_sha256': checksumSha256,
      'is_encrypted': isEncrypted,
      'status': status,
      'device_type': deviceType,
      'platform': platform,
      'app_version': appVersion,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
