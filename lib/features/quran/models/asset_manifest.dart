class AssetManifest {
  final String mushafEdition;
  final String assetVersion;
  final String coordinateFormatVersion;
  final String assetType; // 'vector' or 'raster'
  final Map<String, String> checksums;

  const AssetManifest({
    required this.mushafEdition,
    required this.assetVersion,
    required this.coordinateFormatVersion,
    required this.assetType,
    required this.checksums,
  });

  factory AssetManifest.fromJson(Map<String, dynamic> json) {
    final edition = json['mushafEdition'] as String? ?? 'kfqc-hafs';
    final version = json['assetVersion'] as String? ?? '1.0.0';
    final coordVersion = json['coordinateFormatVersion'] as String? ?? '1.0';
    final type = json['assetType'] as String? ?? 'vector';
    final checksumsMap = Map<String, String>.from(json['checksums'] as Map? ?? {});

    return AssetManifest(
      mushafEdition: edition,
      assetVersion: version,
      coordinateFormatVersion: coordVersion,
      assetType: type,
      checksums: checksumsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mushafEdition': mushafEdition,
      'assetVersion': assetVersion,
      'coordinateFormatVersion': coordinateFormatVersion,
      'assetType': assetType,
      'checksums': checksums,
    };
  }
}
