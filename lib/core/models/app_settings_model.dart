class AppSettingsModel {
  final double fontSize;
  final String themeMode;

  const AppSettingsModel({
    required this.fontSize,
    required this.themeMode,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      fontSize: double.tryParse(json['font_size']?.toString() ?? '20') ?? 20.0,
      themeMode: json['theme_mode']?.toString() ?? 'system',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'font_size': fontSize.toString(),
      'theme_mode': themeMode,
    };
  }
}
