class FingerprintSettingsModel {
  final int? id;
  final String countMode;
  final int holdIntervalSeconds;
  final String hapticProfile;
  final int customHapticVibrationMs;
  final String audioProfile;
  final bool blindMode;
  final bool focusMode;

  const FingerprintSettingsModel({
    this.id,
    required this.countMode,
    required this.holdIntervalSeconds,
    required this.hapticProfile,
    required this.customHapticVibrationMs,
    required this.audioProfile,
    required this.blindMode,
    required this.focusMode,
  });

  factory FingerprintSettingsModel.fromJson(Map<String, dynamic> json) {
    return FingerprintSettingsModel(
      id: json['id'] as int?,
      countMode: json['count_mode'] as String? ?? 'single_touch',
      holdIntervalSeconds: json['hold_interval_seconds'] as int? ?? 1,
      hapticProfile: json['haptic_profile'] as String? ?? 'normal',
      customHapticVibrationMs: json['custom_haptic_vibration_ms'] as int? ?? 50,
      audioProfile: json['audio_profile'] as String? ?? 'soft_click',
      blindMode: json['blind_mode'] == true || json['blind_mode'] == 1,
      focusMode: json['focus_mode'] == true || json['focus_mode'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count_mode': countMode,
      'hold_interval_seconds': holdIntervalSeconds,
      'haptic_profile': hapticProfile,
      'custom_haptic_vibration_ms': customHapticVibrationMs,
      'audio_profile': audioProfile,
      'blind_mode': blindMode,
      'focus_mode': focusMode,
    };
  }

  FingerprintSettingsModel copyWith({
    int? id,
    String? countMode,
    int? holdIntervalSeconds,
    String? hapticProfile,
    int? customHapticVibrationMs,
    String? audioProfile,
    bool? blindMode,
    bool? focusMode,
  }) {
    return FingerprintSettingsModel(
      id: id ?? this.id,
      countMode: countMode ?? this.countMode,
      holdIntervalSeconds: holdIntervalSeconds ?? this.holdIntervalSeconds,
      hapticProfile: hapticProfile ?? this.hapticProfile,
      customHapticVibrationMs: customHapticVibrationMs ?? this.customHapticVibrationMs,
      audioProfile: audioProfile ?? this.audioProfile,
      blindMode: blindMode ?? this.blindMode,
      focusMode: focusMode ?? this.focusMode,
    );
  }

  factory FingerprintSettingsModel.defaultSettings() {
    return const FingerprintSettingsModel(
      countMode: 'single_touch',
      holdIntervalSeconds: 1,
      hapticProfile: 'normal',
      customHapticVibrationMs: 50,
      audioProfile: 'soft_click',
      blindMode: false,
      focusMode: false,
    );
  }
}
