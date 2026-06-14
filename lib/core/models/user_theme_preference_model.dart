class UserThemePreferenceModel {
  final bool soundEnabled;
  final bool hapticEnabled;
  final bool animationEnabled;
  final String? customRingColor;
  final double customFontScale;

  const UserThemePreferenceModel({
    this.soundEnabled = true,
    this.hapticEnabled = true,
    this.animationEnabled = true,
    this.customRingColor,
    this.customFontScale = 1.0,
  });

  factory UserThemePreferenceModel.fromJson(Map<String, dynamic> json) {
    return UserThemePreferenceModel(
      soundEnabled: json['sound_enabled'] as bool? ?? true,
      hapticEnabled: json['haptic_enabled'] as bool? ?? true,
      animationEnabled: json['animation_enabled'] as bool? ?? true,
      customRingColor: json['custom_ring_color'] as String?,
      customFontScale: (json['custom_font_scale'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sound_enabled': soundEnabled,
      'haptic_enabled': hapticEnabled,
      'animation_enabled': animationEnabled,
      'custom_ring_color': customRingColor,
      'custom_font_scale': customFontScale,
    };
  }

  UserThemePreferenceModel copyWith({
    bool? soundEnabled,
    bool? hapticEnabled,
    bool? animationEnabled,
    String? customRingColor,
    double? customFontScale,
  }) {
    return UserThemePreferenceModel(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      animationEnabled: animationEnabled ?? this.animationEnabled,
      customRingColor: customRingColor ?? this.customRingColor,
      customFontScale: customFontScale ?? this.customFontScale,
    );
  }
}
