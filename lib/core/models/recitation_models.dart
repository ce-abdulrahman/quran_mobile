enum RepeatMode { none, ayah, range, surah }

enum GapMode { none, betweenAyahs, betweenRepeats, custom }

enum RecitationEngineState { idle, playing, waitingGap, repeating, completed }

class RecitationSettings {
  final RepeatMode repeatMode;
  final int repeatCount; // -1 for infinite
  final GapMode gapMode;
  final int gapSeconds;
  final bool autoNext;
  final double playbackSpeed;
  final bool memorizationMode;

  const RecitationSettings({
    this.repeatMode = RepeatMode.none,
    this.repeatCount = 1,
    this.gapMode = GapMode.none,
    this.gapSeconds = 0,
    this.autoNext = true,
    this.playbackSpeed = 1.0,
    this.memorizationMode = false,
  });

  RecitationSettings copyWith({
    RepeatMode? repeatMode,
    int? repeatCount,
    GapMode? gapMode,
    int? gapSeconds,
    bool? autoNext,
    double? playbackSpeed,
    bool? memorizationMode,
  }) {
    return RecitationSettings(
      repeatMode: repeatMode ?? this.repeatMode,
      repeatCount: repeatCount ?? this.repeatCount,
      gapMode: gapMode ?? this.gapMode,
      gapSeconds: gapSeconds ?? this.gapSeconds,
      autoNext: autoNext ?? this.autoNext,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      memorizationMode: memorizationMode ?? this.memorizationMode,
    );
  }

  factory RecitationSettings.fromJson(Map<String, dynamic> json) {
    return RecitationSettings(
      repeatMode: RepeatMode.values.firstWhere(
        (e) => e.name == json['repeatMode'],
        orElse: () => RepeatMode.none,
      ),
      repeatCount: json['repeatCount'] as int? ?? 1,
      gapMode: GapMode.values.firstWhere(
        (e) => e.name == json['gapMode'],
        orElse: () => GapMode.none,
      ),
      gapSeconds: json['gapSeconds'] as int? ?? 0,
      autoNext: json['autoNext'] as bool? ?? true,
      playbackSpeed: (json['playbackSpeed'] as num? ?? 1.0).toDouble(),
      memorizationMode: json['memorizationMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'repeatMode': repeatMode.name,
      'repeatCount': repeatCount,
      'gapMode': gapMode.name,
      'gapSeconds': gapSeconds,
      'autoNext': autoNext,
      'playbackSpeed': playbackSpeed,
      'memorizationMode': memorizationMode,
    };
  }
}

class RecitationSession {
  final int currentSurahId;
  final int currentAyahNumber;
  final int repeatIndex;
  final int rangeStartAyah;
  final int rangeEndAyah;
  final int playbackPositionMs;
  final int lastSavedPositionMs;
  final bool endedCleanly;
  final String? interruptedState;

  const RecitationSession({
    this.currentSurahId = 1,
    this.currentAyahNumber = 1,
    this.repeatIndex = 1,
    this.rangeStartAyah = 1,
    this.rangeEndAyah = 1,
    this.playbackPositionMs = 0,
    this.lastSavedPositionMs = 0,
    this.endedCleanly = true,
    this.interruptedState,
  });

  RecitationSession copyWith({
    int? currentSurahId,
    int? currentAyahNumber,
    int? repeatIndex,
    int? rangeStartAyah,
    int? rangeEndAyah,
    int? playbackPositionMs,
    int? lastSavedPositionMs,
    bool? endedCleanly,
    String? interruptedState,
  }) {
    return RecitationSession(
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentAyahNumber: currentAyahNumber ?? this.currentAyahNumber,
      repeatIndex: repeatIndex ?? this.repeatIndex,
      rangeStartAyah: rangeStartAyah ?? this.rangeStartAyah,
      rangeEndAyah: rangeEndAyah ?? this.rangeEndAyah,
      playbackPositionMs: playbackPositionMs ?? this.playbackPositionMs,
      lastSavedPositionMs: lastSavedPositionMs ?? this.lastSavedPositionMs,
      endedCleanly: endedCleanly ?? this.endedCleanly,
      interruptedState: interruptedState ?? this.interruptedState,
    );
  }

  factory RecitationSession.fromJson(Map<String, dynamic> json) {
    return RecitationSession(
      currentSurahId: json['currentSurahId'] as int? ?? 1,
      currentAyahNumber: json['currentAyahNumber'] as int? ?? 1,
      repeatIndex: json['repeatIndex'] as int? ?? 1,
      rangeStartAyah: json['rangeStartAyah'] as int? ?? 1,
      rangeEndAyah: json['rangeEndAyah'] as int? ?? 1,
      playbackPositionMs: json['playbackPositionMs'] as int? ?? 0,
      lastSavedPositionMs: json['lastSavedPositionMs'] as int? ?? 0,
      endedCleanly: json['endedCleanly'] as bool? ?? true,
      interruptedState: json['interruptedState'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentSurahId': currentSurahId,
      'currentAyahNumber': currentAyahNumber,
      'repeatIndex': repeatIndex,
      'rangeStartAyah': rangeStartAyah,
      'rangeEndAyah': rangeEndAyah,
      'playbackPositionMs': playbackPositionMs,
      'lastSavedPositionMs': lastSavedPositionMs,
      'endedCleanly': endedCleanly,
      'interruptedState': interruptedState,
    };
  }
}

class DownloadedRecitation {
  final int reciterId;
  final int surahId;
  final String localPath;
  final int fileSize;
  final DateTime downloadedAt;
  final DateTime lastAccessedAt;

  DownloadedRecitation({
    required this.reciterId,
    required this.surahId,
    required this.localPath,
    required this.fileSize,
    required this.downloadedAt,
    required this.lastAccessedAt,
  });

  factory DownloadedRecitation.fromJson(Map<String, dynamic> json) {
    return DownloadedRecitation(
      reciterId: json['reciterId'] as int,
      surahId: json['surahId'] as int,
      localPath: json['localPath'] as String,
      fileSize: json['fileSize'] as int,
      downloadedAt: DateTime.parse(json['downloadedAt'] as String),
      lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reciterId': reciterId,
      'surahId': surahId,
      'localPath': localPath,
      'fileSize': fileSize,
      'downloadedAt': downloadedAt.toIso8601String(),
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
    };
  }
}

class MemorizationPreset {
  final String name;
  final int repeatCount;
  final int gapSeconds;

  const MemorizationPreset({
    required this.name,
    required this.repeatCount,
    required this.gapSeconds,
  });

  static const beginner = MemorizationPreset(name: 'Beginner', repeatCount: 3, gapSeconds: 5);
  static const intermediate = MemorizationPreset(name: 'Intermediate', repeatCount: 5, gapSeconds: 3);
  static const advanced = MemorizationPreset(name: 'Advanced', repeatCount: 10, gapSeconds: 2);
}

enum ResumeStrategy {
  exactPosition,
  ayahBoundary,
  surahStart,
  lastKnownState,
}

enum SessionRecoveryState {
  none,
  available,
  restoring,
  restored,
}

class MediaPlaybackMetadata {
  final String reciterName;
  final String surahName;
  final int ayahNumber;
  final double playbackSpeed;
  final bool isPlaying;
  final Duration duration;
  final Duration position;

  const MediaPlaybackMetadata({
    required this.reciterName,
    required this.surahName,
    required this.ayahNumber,
    required this.playbackSpeed,
    required this.isPlaying,
    required this.duration,
    required this.position,
  });

  MediaPlaybackMetadata copyWith({
    String? reciterName,
    String? surahName,
    int? ayahNumber,
    double? playbackSpeed,
    bool? isPlaying,
    Duration? duration,
    Duration? position,
  }) {
    return MediaPlaybackMetadata(
      reciterName: reciterName ?? this.reciterName,
      surahName: surahName ?? this.surahName,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }
}

class InterruptionPolicy {
  final bool resumeOnCallEnd;
  final bool duckOnNotification;
  final bool pauseOnHeadphoneUnplug;

  const InterruptionPolicy({
    this.resumeOnCallEnd = true,
    this.duckOnNotification = true,
    this.pauseOnHeadphoneUnplug = true,
  });
}
