import 'user_theme_preference_model.dart';

class ThemeAssetModel {
  final String assetType; // background, sound, animation, font, particle
  final String filePath;
  final int fileSize;
  final String checksum;
  final int version;

  const ThemeAssetModel({
    required this.assetType,
    required this.filePath,
    required this.fileSize,
    required this.checksum,
    required this.version,
  });

  factory ThemeAssetModel.fromJson(Map<String, dynamic> json) {
    return ThemeAssetModel(
      assetType: json['asset_type'] as String? ?? '',
      filePath: json['file_path'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      checksum: json['checksum'] as String? ?? '',
      version: json['version'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asset_type': assetType,
      'file_path': filePath,
      'file_size': fileSize,
      'checksum': checksum,
      'version': version,
    };
  }
}

class TasbihThemeModel {
  final int id;
  final String themeKey;
  final int categoryId;
  final String name;
  final String description;
  final String? previewImage;
  final String? thumbnail;
  final int version;
  final bool isFeatured;
  final String unlockType;
  final String? unlockValue;
  final String? minAppVersion;
  final String? maxAppVersion;
  final Map<String, dynamic> themeMetadata;
  final bool isActive;
  final bool isFavorite;
  final bool isUnlocked;
  final String? unlockedAt;
  final UserThemePreferenceModel? preferences;
  final List<ThemeAssetModel> assets;

  const TasbihThemeModel({
    required this.id,
    required this.themeKey,
    required this.categoryId,
    required this.name,
    required this.description,
    this.previewImage,
    this.thumbnail,
    required this.version,
    this.isFeatured = false,
    required this.unlockType,
    this.unlockValue,
    this.minAppVersion,
    this.maxAppVersion,
    required this.themeMetadata,
    this.isActive = false,
    this.isFavorite = false,
    this.isUnlocked = true,
    this.unlockedAt,
    this.preferences,
    this.assets = const [],
  });

  factory TasbihThemeModel.fromJson(Map<String, dynamic> json) {
    var rawAssets = json['assets'] as List? ?? [];
    List<ThemeAssetModel> assetList = rawAssets
        .map((e) => ThemeAssetModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return TasbihThemeModel(
      id: json['id'] as int? ?? 0,
      themeKey: json['theme_key'] as String? ?? '',
      categoryId: json['category_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      previewImage: json['preview_image'] as String?,
      thumbnail: json['thumbnail'] as String?,
      version: json['version'] as int? ?? 1,
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      unlockType: json['unlock_type'] as String? ?? 'free',
      unlockValue: json['unlock_value']?.toString(),
      minAppVersion: json['min_app_version'] as String?,
      maxAppVersion: json['max_app_version'] as String?,
      themeMetadata: json['theme_metadata'] as Map<String, dynamic>? ?? {},
      isActive: json['is_active'] == true || json['is_active'] == 1,
      isFavorite: json['is_favorite'] == true || json['is_favorite'] == 1,
      isUnlocked: json['is_unlocked'] == true || json['is_unlocked'] == 1,
      unlockedAt: json['unlocked_at']?.toString(),
      preferences: json['preferences'] != null
          ? UserThemePreferenceModel.fromJson(json['preferences'] as Map<String, dynamic>)
          : null,
      assets: assetList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theme_key': themeKey,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'preview_image': previewImage,
      'thumbnail': thumbnail,
      'version': version,
      'is_featured': isFeatured,
      'unlock_type': unlockType,
      'unlock_value': unlockValue,
      'min_app_version': minAppVersion,
      'max_app_version': maxAppVersion,
      'theme_metadata': themeMetadata,
      'is_active': isActive,
      'is_favorite': isFavorite,
      'is_unlocked': isUnlocked,
      'unlocked_at': unlockedAt,
      'preferences': preferences?.toJson(),
      'assets': assets.map((e) => e.toJson()).toList(),
    };
  }

  TasbihThemeModel copyWith({
    bool? isActive,
    bool? isFavorite,
    bool? isUnlocked,
    UserThemePreferenceModel? preferences,
  }) {
    return TasbihThemeModel(
      id: id,
      themeKey: themeKey,
      categoryId: categoryId,
      name: name,
      description: description,
      previewImage: previewImage,
      thumbnail: thumbnail,
      version: version,
      isFeatured: isFeatured,
      unlockType: unlockType,
      unlockValue: unlockValue,
      minAppVersion: minAppVersion,
      maxAppVersion: maxAppVersion,
      themeMetadata: themeMetadata,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt,
      preferences: preferences ?? this.preferences,
      assets: assets,
    );
  }
}
