enum ContentPackage {
  quran,       // Surahs + Ayahs + Juz + Page + Hizb
  tajweed,     // Rules + Categories + Explanations + Examples
  adhkar,      // Categories + Adhkar + Translations
  hadith,      // Categories + Hadiths + Translations
  tafsir,      // Tafsir books + Tafsir entries
  translations // Ayah translations (multi-language)
}

class PackageManifest {
  final ContentPackage package;
  final String version;       // semver: "1.0.0"
  final String checksum;      // SHA256 of data bundle
  final DateTime cachedAt;
  final int sizeBytes;
  final bool isComplete;
  final List<ContentPackage> dependencies;
  final String? backupVersion;
  final String? backupChecksum;

  PackageManifest({
    required this.package,
    required this.version,
    required this.checksum,
    required this.cachedAt,
    required this.sizeBytes,
    required this.isComplete,
    this.dependencies = const [],
    this.backupVersion,
    this.backupChecksum,
  });

  PackageManifest copyWith({
    String? version,
    String? checksum,
    DateTime? cachedAt,
    int? sizeBytes,
    bool? isComplete,
    List<ContentPackage>? dependencies,
    String? backupVersion,
    String? backupChecksum,
  }) {
    return PackageManifest(
      package: package,
      version: version ?? this.version,
      checksum: checksum ?? this.checksum,
      cachedAt: cachedAt ?? this.cachedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      isComplete: isComplete ?? this.isComplete,
      dependencies: dependencies ?? this.dependencies,
      backupVersion: backupVersion ?? this.backupVersion,
      backupChecksum: backupChecksum ?? this.backupChecksum,
    );
  }

  Map<String, dynamic> toJson() => {
        'package': package.name,
        'version': version,
        'checksum': checksum,
        'cachedAt': cachedAt.toIso8601String(),
        'sizeBytes': sizeBytes,
        'isComplete': isComplete,
        'dependencies': dependencies.map((e) => e.name).toList(),
        'backupVersion': backupVersion,
        'backupChecksum': backupChecksum,
      };

  factory PackageManifest.fromJson(Map<String, dynamic> json) => PackageManifest(
        package: ContentPackage.values.firstWhere((e) => e.name == json['package']),
        version: json['version'] as String? ?? '1.0.0',
        checksum: json['checksum'] as String? ?? '',
        cachedAt: DateTime.parse(json['cachedAt'] as String? ?? DateTime.now().toIso8601String()),
        sizeBytes: json['sizeBytes'] as int? ?? 0,
        isComplete: json['isComplete'] as bool? ?? false,
        dependencies: (json['dependencies'] as List? ?? [])
            .map((e) => ContentPackage.values.firstWhere((p) => p.name == e))
            .toList(),
        backupVersion: json['backupVersion'] as String?,
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
