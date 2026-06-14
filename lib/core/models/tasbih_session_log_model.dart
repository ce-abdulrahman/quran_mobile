class TasbihSessionLogModel {
  final String eventUuid;
  final String eventType;
  final int value;
  final DateTime timestamp;

  const TasbihSessionLogModel({
    required this.eventUuid,
    required this.eventType,
    required this.value,
    required this.timestamp,
  });

  factory TasbihSessionLogModel.fromJson(Map<String, dynamic> json) {
    return TasbihSessionLogModel(
      eventUuid: json['event_uuid'] as String? ?? '',
      eventType: json['event_type'] as String? ?? 'increment',
      value: json['value'] as int? ?? 1,
      timestamp: DateTime.parse(json['timestamp'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_uuid': eventUuid,
      'event_type': eventType,
      'value': value,
      'timestamp': timestamp.toUtc().toIso8601String().replaceAll('T', ' ').substring(0, 19), // Format: YYYY-MM-DD HH:mm:ss for backend validation
    };
  }
}
