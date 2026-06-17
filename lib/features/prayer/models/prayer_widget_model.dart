class PrayerWidgetModel {
  final String nextPrayer;
  final String nextPrayerTime;
  final String nextPrayerRemaining;
  final String currentCity;
  final String hijriDate;
  final String gregorianDate;
  final String activePrayerMethod;
  final Map<String, String> prayerTimes;
  final String timezone;
  final double utcOffset;
  final bool dstActive;
  final String versionHash;

  PrayerWidgetModel({
    required this.nextPrayer,
    required this.nextPrayerTime,
    required this.nextPrayerRemaining,
    required this.currentCity,
    required this.hijriDate,
    required this.gregorianDate,
    required this.activePrayerMethod,
    required this.prayerTimes,
    required this.timezone,
    required this.utcOffset,
    required this.dstActive,
    required this.versionHash,
  });

  factory PrayerWidgetModel.fromJson(Map<String, dynamic> json) {
    final Map<String, String> pTimes = {};
    if (json['prayer_times'] != null) {
      (json['prayer_times'] as Map<dynamic, dynamic>).forEach((key, val) {
        pTimes[key.toString()] = val.toString();
      });
    }
    return PrayerWidgetModel(
      nextPrayer: json['next_prayer'] as String? ?? 'fajr',
      nextPrayerTime: json['next_prayer_time'] as String? ?? '',
      nextPrayerRemaining: json['next_prayer_remaining'] as String? ?? '',
      currentCity: json['current_city'] as String? ?? '',
      hijriDate: json['hijri_date'] as String? ?? '',
      gregorianDate: json['gregorian_date'] as String? ?? '',
      activePrayerMethod: json['active_prayer_method'] as String? ?? '',
      prayerTimes: pTimes,
      timezone: json['timezone'] as String? ?? 'Asia/Baghdad',
      utcOffset: (json['utc_offset'] as num?)?.toDouble() ?? 3.0,
      dstActive: json['dst_active'] as bool? ?? false,
      versionHash: json['version_hash'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'next_prayer': nextPrayer,
      'next_prayer_time': nextPrayerTime,
      'next_prayer_remaining': nextPrayerRemaining,
      'current_city': currentCity,
      'hijri_date': hijriDate,
      'gregorian_date': gregorianDate,
      'active_prayer_method': activePrayerMethod,
      'prayer_times': prayerTimes,
      'timezone': timezone,
      'utc_offset': utcOffset,
      'dst_active': dstActive,
      'version_hash': versionHash,
    };
  }
}
