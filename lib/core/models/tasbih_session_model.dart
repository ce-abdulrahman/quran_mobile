import 'tasbih_model.dart';

class TasbihSessionModel {
  final int id;
  final int userId;
  final int? dhikrId;
  final String? customDhikrName;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final int totalCount;
  final double avgPerMinute;
  final String sessionDate;
  final String status;
  final TasbihModel? dhikr;

  const TasbihSessionModel({
    required this.id,
    required this.userId,
    this.dhikrId,
    this.customDhikrName,
    required this.startTime,
    this.endTime,
    this.durationSeconds = 0,
    this.totalCount = 0,
    this.avgPerMinute = 0.0,
    required this.sessionDate,
    required this.status,
    this.dhikr,
  });

  factory TasbihSessionModel.fromJson(Map<String, dynamic> json) {
    return TasbihSessionModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      dhikrId: json['dhikr_id'] as int?,
      customDhikrName: json['custom_dhikr_name'] as String?,
      startTime: DateTime.parse(json['start_time'] as String).toLocal(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String).toLocal()
          : null,
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      totalCount: json['total_count'] as int? ?? 0,
      avgPerMinute: double.tryParse((json['avg_per_minute'] ?? 0.0).toString()) ?? 0.0,
      sessionDate: json['session_date'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      dhikr: json['dhikr'] != null ? TasbihModel.fromJson(json['dhikr'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dhikr_id': dhikrId,
      'custom_dhikr_name': customDhikrName,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime?.toUtc().toIso8601String(),
      'duration_seconds': durationSeconds,
      'total_count': totalCount,
      'avg_per_minute': avgPerMinute,
      'session_date': sessionDate,
      'status': status,
      if (dhikr != null) 'dhikr': dhikr!.toJson(),
    };
  }
}
