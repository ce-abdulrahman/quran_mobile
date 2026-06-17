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

  PackageManifest({
    required this.package,
    required this.version,
    required this.checksum,
    required this.cachedAt,
    required this.sizeBytes,
    required this.isComplete,
  });

  Map<String, dynamic> toJson() => {
        'package': package.name,
        'version': version,
        'checksum': checksum,
        'cachedAt': cachedAt.toIso8601String(),
        'sizeBytes': sizeBytes,
        'isComplete': isComplete,
      };

  factory PackageManifest.fromJson(Map<String, dynamic> json) => PackageManifest(
        package: ContentPackage.values.firstWhere((e) => e.name == json['package']),
        version: json['version'] as String? ?? '1.0.0',
        checksum: json['checksum'] as String? ?? '',
        cachedAt: DateTime.parse(json['cachedAt'] as String? ?? DateTime.now().toIso8601String()),
        sizeBytes: json['sizeBytes'] as int? ?? 0,
        isComplete: json['isComplete'] as bool? ?? false,
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
