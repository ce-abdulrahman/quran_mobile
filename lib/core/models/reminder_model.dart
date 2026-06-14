class ReminderModel {
  final String type;
  final String key;
  final String icon;
  final String title;
  final String body;
  final int priority;
  final int sortOrder;
  final int version;
  final Map<String, dynamic>? metadata;

  // User configuration properties (mutable for settings UI)
  bool enabled;
  String scheduledTime; // format "HH:MM"
  String frequency; // daily | weekdays | weekends | custom
  List<int> customDays; // [1..7] (1 = Monday, 7 = Sunday)
  String timezone;
  final DateTime? lastSentAt;

  ReminderModel({
    required this.type,
    required this.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.priority,
    required this.sortOrder,
    required this.version,
    this.metadata,
    required this.enabled,
    required this.scheduledTime,
    required this.frequency,
    required this.customDays,
    required this.timezone,
    this.lastSentAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      type: json['type'] as String,
      key: json['key'] as String,
      icon: (json['icon'] as String?) ?? '🔔',
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
      priority: (json['priority'] as int?) ?? 5,
      sortOrder: (json['sort_order'] as int?) ?? 0,
      version: (json['version'] as int?) ?? 1,
      metadata: json['metadata'] as Map<String, dynamic>?,
      enabled: (json['enabled'] as bool?) ?? false,
      scheduledTime: (json['scheduled_time'] as String?) ?? '08:00',
      frequency: (json['frequency'] as String?) ?? 'daily',
      customDays: (json['custom_days'] as List<dynamic>?)?.cast<int>() ?? [],
      timezone: (json['timezone'] as String?) ?? 'Asia/Baghdad',
      lastSentAt: json['last_sent_at'] != null
          ? DateTime.tryParse(json['last_sent_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'key': key,
      'enabled': enabled,
      'scheduled_time': scheduledTime,
      'frequency': frequency,
      'custom_days': customDays,
      'timezone': timezone,
    };
  }

  ReminderModel copyWith({
    bool? enabled,
    String? scheduledTime,
    String? frequency,
    List<int>? customDays,
    String? timezone,
  }) {
    return ReminderModel(
      type: type,
      key: key,
      icon: icon,
      title: title,
      body: body,
      priority: priority,
      sortOrder: sortOrder,
      version: version,
      metadata: metadata,
      enabled: enabled ?? this.enabled,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      timezone: timezone ?? this.timezone,
      lastSentAt: lastSentAt,
    );
  }
}
