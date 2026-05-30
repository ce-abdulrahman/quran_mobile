import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'app_providers.dart';
import '../services/prayer_notification_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Kurdish City Model & Data
// ─────────────────────────────────────────────────────────────────────────────

class KurdishCity {
  final String nameKu;
  final String nameEn;
  final double latitude;
  final double longitude;

  const KurdishCity({
    required this.nameKu,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'nameKu': nameKu,
        'nameEn': nameEn,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory KurdishCity.fromJson(Map<String, dynamic> json) => KurdishCity(
        nameKu: json['nameKu'] as String? ?? 'هەولێر',
        nameEn: json['nameEn'] as String? ?? 'Erbil',
        latitude: (json['latitude'] as num? ?? 36.1912).toDouble(),
        longitude: (json['longitude'] as num? ?? 44.0091).toDouble(),
      );
}

const List<KurdishCity> kurdishCities = [
  KurdishCity(nameKu: 'هەولێر', nameEn: 'Erbil', latitude: 36.1912, longitude: 44.0091),
  KurdishCity(nameKu: 'سلێمانی', nameEn: 'Sulaymaniyah', latitude: 35.5619, longitude: 45.4375),
  KurdishCity(nameKu: 'دهۆک', nameEn: 'Duhok', latitude: 36.8601, longitude: 42.9961),
  KurdishCity(nameKu: 'کەرکووک', nameEn: 'Kirkuk', latitude: 35.4681, longitude: 44.3922),
  KurdishCity(nameKu: 'هەڵەبجە', nameEn: 'Halabja', latitude: 35.1778, longitude: 45.9861),
];

// ─────────────────────────────────────────────────────────────────────────────
// State Class
// ─────────────────────────────────────────────────────────────────────────────

class PrayerTimesState {
  final KurdishCity selectedCity;
  final bool isAzanEnabled;
  final Map<String, bool> prayerToggles; // {'Fajr': true, 'Dhuhr': true...}

  const PrayerTimesState({
    required this.selectedCity,
    required this.isAzanEnabled,
    required this.prayerToggles,
  });

  PrayerTimesState copyWith({
    KurdishCity? selectedCity,
    bool? isAzanEnabled,
    Map<String, bool>? prayerToggles,
  }) {
    return PrayerTimesState(
      selectedCity: selectedCity ?? this.selectedCity,
      isAzanEnabled: isAzanEnabled ?? this.isAzanEnabled,
      prayerToggles: prayerToggles ?? this.prayerToggles,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// State Notifier
// ─────────────────────────────────────────────────────────────────────────────

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  final SharedPreferences _prefs;
  static const _cityKey = 'prayer_selected_city';
  static const _azanEnabledKey = 'prayer_azan_enabled';
  static const _togglesKey = 'prayer_toggles';

  PrayerTimesNotifier(this._prefs)
      : super(
          PrayerTimesState(
            selectedCity: kurdishCities.first,
            isAzanEnabled: true,
            prayerToggles: {
              'Fajr': true,
              'Dhuhr': true,
              'Asr': true,
              'Maghrib': true,
              'Isha': true,
            },
          ),
        ) {
    _loadSettings();
  }

  void reschedule() {
    PrayerNotificationService().schedulePrayerNotifications(
      city: state.selectedCity,
      toggles: state.prayerToggles,
      isAzanEnabled: state.isAzanEnabled,
    );
  }

  void _loadSettings() {
    final rawCity = _prefs.getString(_cityKey);
    final rawAzan = _prefs.getBool(_azanEnabledKey);
    final rawToggles = _prefs.getString(_togglesKey);

    KurdishCity city = kurdishCities.first;
    if (rawCity != null) {
      try {
        city = KurdishCity.fromJson(jsonDecode(rawCity) as Map<String, dynamic>);
      } catch (_) {}
    }

    bool azanEnabled = rawAzan ?? true;

    Map<String, bool> toggles = {
      'Fajr': true,
      'Dhuhr': true,
      'Asr': true,
      'Maghrib': true,
      'Isha': true,
    };
    if (rawToggles != null) {
      try {
        final decoded = jsonDecode(rawToggles) as Map<String, dynamic>;
        decoded.forEach((key, value) {
          if (value is bool) toggles[key] = value;
        });
      } catch (_) {}
    }

    state = PrayerTimesState(
      selectedCity: city,
      isAzanEnabled: azanEnabled,
      prayerToggles: toggles,
    );

    // Run rescheduling in microtask to avoid running during constructor init
    Future.microtask(() => reschedule());
  }

  Future<void> changeCity(KurdishCity city) async {
    state = state.copyWith(selectedCity: city);
    await _prefs.setString(_cityKey, jsonEncode(city.toJson()));
    reschedule();
  }

  Future<void> toggleAzan(bool enabled) async {
    state = state.copyWith(isAzanEnabled: enabled);
    await _prefs.setBool(_azanEnabledKey, enabled);
    reschedule();
  }

  Future<void> togglePrayerNotification(String prayerName, bool enabled) async {
    final updatedToggles = Map<String, bool>.from(state.prayerToggles);
    updatedToggles[prayerName] = enabled;
    state = state.copyWith(prayerToggles: updatedToggles);
    await _prefs.setString(_togglesKey, jsonEncode(updatedToggles));
    reschedule();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final prayerTimesSettingsProvider =
    StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrayerTimesNotifier(prefs);
});

// Calculate prayer times for a given day
final prayerTimesForDateProvider =
    Provider.family<PrayerTimes, DateTime>((ref, date) {
  final settings = ref.watch(prayerTimesSettingsProvider);
  final city = settings.selectedCity;
  
  final coordinates = Coordinates(city.latitude, city.longitude);
  final params = CalculationMethod.muslim_world_league.getParameters();
  params.madhab = Madhab.shafi;

  final dateComponents = DateComponents(date.year, date.month, date.day);
  return PrayerTimes(coordinates, dateComponents, params);
});

// Real-time calculation helper to determine next prayer and remaining duration
class NextPrayerInfo {
  final String arabicName;
  final String kurdishName;
  final DateTime time;
  final Duration remaining;

  NextPrayerInfo({
    required this.arabicName,
    required this.kurdishName,
    required this.time,
    required this.remaining,
  });
}

// Provider that calculates the next prayer
final nextPrayerProvider = Provider<NextPrayerInfo?>((ref) {
  final now = DateTime.now();
  final todayTimes = ref.watch(prayerTimesForDateProvider(now));
  
  final List<Map<String, dynamic>> prayers = [
    {
      'nameAr': 'الفجر',
      'nameKu': 'بەیانی',
      'time': todayTimes.fajr.toLocal(),
    },
    {
      'nameAr': 'الظهر',
      'nameKu': 'نیوەڕۆ',
      'time': todayTimes.dhuhr.toLocal(),
    },
    {
      'nameAr': 'العصر',
      'nameKu': 'عەسڕ',
      'time': todayTimes.asr.toLocal(),
    },
    {
      'nameAr': 'المغرب',
      'nameKu': 'مەغریب',
      'time': todayTimes.maghrib.toLocal(),
    },
    {
      'nameAr': 'العشاء',
      'nameKu': 'عیشا',
      'time': todayTimes.isha.toLocal(),
    },
  ];

  // Find first prayer that is after now
  for (final p in prayers) {
    final pTime = p['time'] as DateTime;
    if (pTime.isAfter(now)) {
      return NextPrayerInfo(
        arabicName: p['nameAr'] as String,
        kurdishName: p['nameKu'] as String,
        time: pTime,
        remaining: pTime.difference(now),
      );
    }
  }

  // If all today's prayers have passed, the next prayer is Fajr of tomorrow
  final tomorrow = now.add(const Duration(days: 1));
  final tomorrowTimes = ref.watch(prayerTimesForDateProvider(tomorrow));
  final tomorrowFajr = tomorrowTimes.fajr.toLocal();

  return NextPrayerInfo(
    arabicName: 'الفجر',
    kurdishName: 'بەیانی',
    time: tomorrowFajr,
    remaining: tomorrowFajr.difference(now),
  );
});
