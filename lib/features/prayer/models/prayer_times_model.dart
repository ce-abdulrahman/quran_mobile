/// Models for the Prayer Times Calendar API response.
/// Endpoint: GET /api/v1/prayer-times

class PrayerTimesResponse {
  final String city;
  final int cityId;
  final String timezone;
  final int year;
  final String? dateFrom;
  final String? dateTo;
  final int total;
  final List<PrayerTimeEntry> data;
  final String versionHash;

  const PrayerTimesResponse({
    required this.city,
    required this.cityId,
    required this.timezone,
    required this.year,
    this.dateFrom,
    this.dateTo,
    required this.total,
    required this.data,
    required this.versionHash,
  });

  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List<dynamic>? ?? [];
    return PrayerTimesResponse(
      city:        json['city'] as String? ?? '',
      cityId:      json['city_id'] as int? ?? 0,
      timezone:    json['timezone'] as String? ?? 'Asia/Baghdad',
      year:        json['year'] as int? ?? DateTime.now().year,
      dateFrom:    json['date_from'] as String?,
      dateTo:      json['date_to'] as String?,
      total:       json['total'] as int? ?? rawData.length,
      data:        rawData
          .map((e) => PrayerTimeEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      versionHash: json['version_hash'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'city':         city,
    'city_id':      cityId,
    'timezone':     timezone,
    'year':         year,
    'date_from':    dateFrom,
    'date_to':      dateTo,
    'total':        total,
    'data':         data.map((e) => e.toJson()).toList(),
    'version_hash': versionHash,
  };
}

/// One day's prayer times.
class PrayerTimeEntry {
  final String date; // "YYYY-MM-DD"
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String source;

  const PrayerTimeEntry({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    this.source = 'import',
  });

  factory PrayerTimeEntry.fromJson(Map<String, dynamic> json) {
    return PrayerTimeEntry(
      date:    json['date'] as String? ?? '',
      fajr:    json['fajr'] as String? ?? '--:--',
      sunrise: json['sunrise'] as String? ?? '--:--',
      dhuhr:   json['dhuhr'] as String? ?? '--:--',
      asr:     json['asr'] as String? ?? '--:--',
      maghrib: json['maghrib'] as String? ?? '--:--',
      isha:    json['isha'] as String? ?? '--:--',
      source:  json['source'] as String? ?? 'import',
    );
  }

  Map<String, dynamic> toJson() => {
    'date':    date,
    'fajr':    fajr,
    'sunrise': sunrise,
    'dhuhr':   dhuhr,
    'asr':     asr,
    'maghrib': maghrib,
    'isha':    isha,
    'source':  source,
  };

  /// Returns a map of prayer name → time string for UI display.
  Map<String, String> get timesMap => {
    'fajr':    fajr,
    'sunrise': sunrise,
    'dhuhr':   dhuhr,
    'asr':     asr,
    'maghrib': maghrib,
    'isha':    isha,
  };

  /// Parse "HH:MM" into a [DateTime] for today's date.
  DateTime? timeAsDateTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) return null;
      final now = DateTime.now();
      return DateTime(
        now.year, now.month, now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }
}

/// City info returned from GET /api/v1/prayer-times/cities.
class PrayerTimeCity {
  final int id;
  final String name;
  final double lat;
  final double lng;
  final String timezone;
  final List<int> availableYears;
  final int totalEntries;

  const PrayerTimeCity({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.timezone,
    required this.availableYears,
    required this.totalEntries,
  });

  factory PrayerTimeCity.fromJson(Map<String, dynamic> json) {
    final years = (json['available_years'] as List<dynamic>? ?? [])
        .map((e) => e as int)
        .toList();
    return PrayerTimeCity(
      id:             json['id'] as int? ?? 0,
      name:           json['name'] as String? ?? '',
      lat:            (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng:            (json['lng'] as num?)?.toDouble() ?? 0.0,
      timezone:       json['timezone'] as String? ?? 'Asia/Baghdad',
      availableYears: years,
      totalEntries:   json['total_entries'] as int? ?? 0,
    );
  }
}
