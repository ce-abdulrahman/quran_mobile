// ignore_for_file: constant_identifier_names

enum ContentPackage {
  quran,           // Surahs + Ayahs + Juz + Page + Hizb
  tafsir,          // Tafsir books + Tafsir entries
  hadith,          // Collections + Chapters + Hadiths
  adhkar,          // Categories + Adhkars
  seerah,          // Prophet's biography
  sahaba,          // Companions' biography
  allah_names,     // 99 Names of Allah
  prayer_database, // Annual prayer times database
  translations,    // Ayah translations
  audio_metadata,  // Reciters + audio timings
  tajweed,         // Rules + Explanations
}

class PackageManifest {
  final ContentPackage package;
  final int version;
  final int minimumAppVersion;
  final int recommendedAppVersion;
  final int schemaVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String checksum;
  final int records;
  final int compressedSize;
  final int uncompressedSize;
  final String signature;
  final bool supportsDelta;
  final bool isComplete;
  final List<ContentPackage> dependencies;
  final int? backupVersion;
  final String? backupChecksum;

  PackageManifest({
    required this.package,
    required this.version,
    this.minimumAppVersion = 1,
    this.recommendedAppVersion = 1,
    this.schemaVersion = 1,
    required this.createdAt,
    required this.updatedAt,
    required this.checksum,
    this.records = 0,
    this.compressedSize = 0,
    this.uncompressedSize = 0,
    this.signature = '',
    this.supportsDelta = false,
    required this.isComplete,
    this.dependencies = const [],
    this.backupVersion,
    this.backupChecksum,
  });

  PackageManifest copyWith({
    int? version,
    int? minimumAppVersion,
    int? recommendedAppVersion,
    int? schemaVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? checksum,
    int? records,
    int? compressedSize,
    int? uncompressedSize,
    String? signature,
    bool? supportsDelta,
    bool? isComplete,
    List<ContentPackage>? dependencies,
    int? backupVersion,
    String? backupChecksum,
  }) {
    return PackageManifest(
      package: package,
      version: version ?? this.version,
      minimumAppVersion: minimumAppVersion ?? this.minimumAppVersion,
      recommendedAppVersion: recommendedAppVersion ?? this.recommendedAppVersion,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checksum: checksum ?? this.checksum,
      records: records ?? this.records,
      compressedSize: compressedSize ?? this.compressedSize,
      uncompressedSize: uncompressedSize ?? this.uncompressedSize,
      signature: signature ?? this.signature,
      supportsDelta: supportsDelta ?? this.supportsDelta,
      isComplete: isComplete ?? this.isComplete,
      dependencies: dependencies ?? this.dependencies,
      backupVersion: backupVersion ?? this.backupVersion,
      backupChecksum: backupChecksum ?? this.backupChecksum,
    );
  }

  Map<String, dynamic> toJson() => {
        'package': package.name,
        'version': version,
        'minimum_app_version': minimumAppVersion,
        'recommended_app_version': recommendedAppVersion,
        'schema_version': schemaVersion,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'checksum': checksum,
        'records': records,
        'compressed_size': compressedSize,
        'uncompressed_size': uncompressedSize,
        'signature': signature,
        'supports_delta': supportsDelta,
        'isComplete': isComplete,
        'dependencies': dependencies.map((e) => e.name).toList(),
        'backupVersion': backupVersion,
        'backupChecksum': backupChecksum,
      };

  factory PackageManifest.fromJson(Map<String, dynamic> json) => PackageManifest(
        package: ContentPackage.values.firstWhere((e) => e.name == json['package']),
        version: json['version'] as int? ?? 1,
        minimumAppVersion: json['minimum_app_version'] as int? ?? 1,
        recommendedAppVersion: json['recommended_app_version'] as int? ?? 1,
        schemaVersion: json['schema_version'] as int? ?? 1,
        createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
        checksum: json['checksum'] as String? ?? '',
        records: json['records'] as int? ?? 0,
        compressedSize: json['compressed_size'] as int? ?? json['sizeBytes'] as int? ?? 0,
        uncompressedSize: json['uncompressed_size'] as int? ?? 0,
        signature: json['signature'] as String? ?? '',
        supportsDelta: json['supports_delta'] as bool? ?? false,
        isComplete: json['isComplete'] as bool? ?? false,
        dependencies: (json['dependencies'] as List? ?? [])
            .map((e) => ContentPackage.values.firstWhere((p) => p.name == e))
            .toList(),
        backupVersion: json['backupVersion'] as int?,
        backupChecksum: json['backupChecksum'] as String?,
      );
}

class PackageDownloadEvent {
  final ContentPackage package;
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final bool isError;
  final String? errorMessage;

  PackageDownloadEvent({
    required this.package,
    required this.progress,
    required this.isCompleted,
    this.isError = false,
    this.errorMessage,
  });
}
