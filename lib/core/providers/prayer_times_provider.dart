import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'app_providers.dart';
import '../services/prayer_notification_service.dart';

import '../../features/prayer/providers/prayer_times_provider.dart';
import '../../features/prayer/providers/prayer_widget_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Kurdish City Model & Data
// ─────────────────────────────────────────────────────────────────────────────

class KurdishCity {
  final int? id;
  final String nameKu;
  final String nameEn;
  final double latitude;
  final double longitude;

  const KurdishCity({
    this.id,
    required this.nameKu,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameKu': nameKu,
        'nameEn': nameEn,
        'latitude': latitude,
        'longitude': longitude,
      };

  factory KurdishCity.fromJson(Map<String, dynamic> json) => KurdishCity(
        id: json['id'] as int?,
        nameKu: json['nameKu'] as String? ?? 'هەولێر',
        nameEn: json['nameEn'] as String? ?? 'Erbil',
        latitude: (json['latitude'] as num? ?? 36.1912).toDouble(),
        longitude: (json['longitude'] as num? ?? 44.0091).toDouble(),
      );

  factory KurdishCity.fromApi(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? '';
    String nameKu = name;
    if (name.toLowerCase() == 'erbil') {
      nameKu = 'هەولێر';
    } else if (name.toLowerCase() == 'sulaymaniyah') {
      nameKu = 'سلێمانی';
    } else if (name.toLowerCase() == 'duhok') {
      nameKu = 'دهۆک';
    } else if (name.toLowerCase() == 'kirkuk') {
      nameKu = 'کەرکووک';
    } else if (name.toLowerCase() == 'halabja') {
      nameKu = 'هەڵەبجە';
    }
    
    return KurdishCity(
      id: json['id'] as int?,
      nameKu: nameKu,
      nameEn: name,
      latitude: (json['lat'] as num? ?? 0.0).toDouble(),
      longitude: (json['lng'] as num? ?? 0.0).toDouble(),
    );
  }
}

const List<KurdishCity> kurdishCities = [
  KurdishCity(id: 1, nameKu: 'هەولێر', nameEn: 'Erbil', latitude: 36.1901, longitude: 44.0091),
  KurdishCity(id: 2, nameKu: 'دهۆک', nameEn: 'Duhok', latitude: 36.8668, longitude: 42.9506),
  KurdishCity(id: 3, nameKu: 'زاخۆ', nameEn: 'Zakho', latitude: 37.1440, longitude: 42.6876),
  KurdishCity(id: 4, nameKu: 'سلێمانی', nameEn: 'Sulaymaniyah', latitude: 35.5600, longitude: 45.4350),
  KurdishCity(id: 5, nameKu: 'هەڵەبجە', nameEn: 'Halabja', latitude: 35.1787, longitude: 45.9862),
  KurdishCity(id: 6, nameKu: 'چەمچەماڵ', nameEn: 'Chamchamal', latitude: 35.5264, longitude: 44.8367),
  KurdishCity(id: 7, nameKu: 'ڕانیە', nameEn: 'Ranya', latitude: 36.2553, longitude: 44.8781),
  KurdishCity(id: 8, nameKu: 'ئاکرێ', nameEn: 'Akre', latitude: 36.7436, longitude: 43.8841),
  KurdishCity(id: 9, nameKu: 'پێنجوێن', nameEn: 'Penjwen', latitude: 35.6248, longitude: 45.9436),
  KurdishCity(id: 10, nameKu: 'دەربەندیخان', nameEn: 'Darbandikhan', latitude: 35.1103, longitude: 45.6964),
  KurdishCity(id: 11, nameKu: 'دۆکان', nameEn: 'Dokan', latitude: 35.9500, longitude: 44.9600),
  KurdishCity(id: 12, nameKu: 'کفری', nameEn: 'Kifri', latitude: 34.6880, longitude: 44.9740),
  KurdishCity(id: 13, nameKu: 'کەلار', nameEn: 'Kalar', latitude: 34.6314, longitude: 45.3228),
  KurdishCity(id: 14, nameKu: 'خانەقین', nameEn: 'Khanaqin', latitude: 34.3379, longitude: 45.3705),
  KurdishCity(id: 15, nameKu: 'کەرکووک', nameEn: 'Kirkuk', latitude: 35.4681, longitude: 44.3922),
  KurdishCity(id: 16, nameKu: 'کۆیە', nameEn: 'Koysinjaq', latitude: 36.0866, longitude: 44.6315),
  KurdishCity(id: 17, nameKu: 'مەخموور', nameEn: 'Makhmur', latitude: 35.7706, longitude: 43.5843),
  KurdishCity(id: 18, nameKu: 'قەڵادزێ', nameEn: 'Qaladiza', latitude: 36.1781, longitude: 45.1240),
  KurdishCity(id: 19, nameKu: 'قەسرێ', nameEn: 'Qasre', latitude: 36.8500, longitude: 44.5000),
  KurdishCity(id: 20, nameKu: 'گۆخلان', nameEn: 'Gokhlan', latitude: 37.0000, longitude: 43.5000),
  KurdishCity(id: 21, nameKu: 'توز خورماتوو', nameEn: 'Tuz Khurma', latitude: 34.8871, longitude: 44.6390),
];

enum PrayerType { fajr, dhuhr, asr, maghrib, isha }

// ─────────────────────────────────────────────────────────────────────────────
// State Class
// ─────────────────────────────────────────────────────────────────────────────

class PrayerTimesState {
  final KurdishCity selectedCity;
  final bool isAzanEnabled;
  final Map<String, bool> prayerToggles; // {'Fajr': true, 'Dhuhr': true...}
  final String calculationMethod;
  final List<KurdishCity> cities;
  final String versionHash;
  final String adhanSound; // Selected adhan sound filename (without extension)

  const PrayerTimesState({
    required this.selectedCity,
    required this.isAzanEnabled,
    required this.prayerToggles,
    this.calculationMethod = 'kurdistan',
    this.cities = kurdishCities,
    this.versionHash = '',
    this.adhanSound = 'azan', // Default to built-in azan.mp3
  });

  PrayerTimesState copyWith({
    KurdishCity? selectedCity,
    bool? isAzanEnabled,
    Map<String, bool>? prayerToggles,
    String? calculationMethod,
    List<KurdishCity>? cities,
    String? versionHash,
    String? adhanSound,
  }) {
    return PrayerTimesState(
      selectedCity: selectedCity ?? this.selectedCity,
      isAzanEnabled: isAzanEnabled ?? this.isAzanEnabled,
      prayerToggles: prayerToggles ?? this.prayerToggles,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      cities: cities ?? this.cities,
      versionHash: versionHash ?? this.versionHash,
      adhanSound: adhanSound ?? this.adhanSound,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// State Notifier
// ─────────────────────────────────────────────────────────────────────────────

class PrayerTimesNotifier extends StateNotifier<PrayerTimesState> {
  final SharedPreferences _prefs;
  final Ref _ref;
  static const _cityKey = 'prayer_selected_city';
  static const _azanEnabledKey = 'prayer_azan_enabled';
  static const _togglesKey = 'prayer_toggles';
  static const _adhanSoundKey = 'prayer_adhan_sound';

  PrayerTimesNotifier(this._prefs, this._ref)
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


  void _syncCityOnTrigger(KurdishCity city) {
    try {
      final matched = state.cities.firstWhere(
        (c) => c.nameEn.toLowerCase() == city.nameEn.toLowerCase(),
        orElse: () => city,
      );
      final cityId = matched.id ?? 1;
      final year = DateTime.now().year;
      _ref.read(prayerTimesRepositoryProvider).fetchYear(
        cityId: cityId,
        year: year,
      ).then((_) {
        reschedule();
        _ref.read(prayerWidgetProvider.notifier).refreshWidgetData().catchError((_) {});
      }).catchError((_) {});
    } catch (_) {}
  }

  Future<void> reschedule() async {
    try {
      await PrayerNotificationService().schedulePrayerNotifications(
        city: state.selectedCity,
        toggles: state.prayerToggles,
        isAzanEnabled: state.isAzanEnabled,
        adhanSound: state.adhanSound,
      );
    } catch (e) {
      debugPrint('reschedule error: $e');
    }
  }

  void _loadSettings() {
    final rawCity = _prefs.getString(_cityKey);
    final rawAzan = _prefs.getBool(_azanEnabledKey);
    final rawToggles = _prefs.getString(_togglesKey);
    final rawAdhanSound = _prefs.getString(_adhanSoundKey);

    // Load API cached settings
    final cachedMethod = _prefs.getString('prayer_settings_calculation_method') ?? 'kurdistan';
    final cachedHash = _prefs.getString('prayer_settings_version_hash') ?? '';
    final cachedCitiesRaw = _prefs.getString('prayer_settings_cities_list');
    
    List<KurdishCity> listCities = kurdishCities;
    if (cachedCitiesRaw != null) {
      try {
        final decoded = jsonDecode(cachedCitiesRaw) as List<dynamic>;
        listCities = decoded.map((c) => KurdishCity.fromJson(c as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    KurdishCity city = listCities.first;
    if (rawCity != null) {
      try {
        city = KurdishCity.fromJson(jsonDecode(rawCity) as Map<String, dynamic>);
      } catch (_) {}
    }

    bool exists = listCities.any((c) => c.nameEn == city.nameEn);
    if (!exists && listCities.isNotEmpty) {
      city = listCities.first;
    }

    bool azanEnabled = rawAzan ?? true;
    String adhanSound = rawAdhanSound ?? 'azan'; // Default to built-in azan.mp3

    // Migrate old sound IDs to corrected filenames
    const soundMigrations = {'azan_mekka': 'azan_makkah', 'azan_turkey': 'azan'};
    if (soundMigrations.containsKey(adhanSound)) {
      adhanSound = soundMigrations[adhanSound]!;
      _prefs.setString(_adhanSoundKey, adhanSound);
    }

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

    // Check if user is authenticated and overwrite city if they have a province set
    KurdishCity initialSelectedCity = city;


    state = PrayerTimesState(
      selectedCity: initialSelectedCity,
      isAzanEnabled: azanEnabled,
      prayerToggles: toggles,
      calculationMethod: cachedMethod,
      cities: listCities,
      versionHash: cachedHash,
      adhanSound: adhanSound,
    );

    // Run rescheduling and API sync
    Future.microtask(() {
      reschedule();
      syncWithApi();
    });
  }

  Future<void> syncWithApi() async {
    try {
      final client = _ref.read(apiClientProvider);
      final storedHash = _prefs.getString('prayer_settings_version_hash') ?? '';
      
      final response = await client.get(
        '/prayer-settings',
        queryParameters: {'version_hash': storedHash},
      );
      
      if (response.statusCode == 304) {
        return;
      }
      
      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data as Map<String, dynamic>;
        final data = resData['data'] as Map<String, dynamic>;
        final newHash = data['version_hash'] as String? ?? '';
        final method = data['calculation_method'] as String? ?? 'kurdistan';
        final isEnabled = data['global_notifications_enabled'] as bool? ?? true;
        
        final rawCities = data['cities'] as List<dynamic>? ?? [];
        List<KurdishCity> fetchedCities = [];
        for (final c in rawCities) {
          fetchedCities.add(KurdishCity.fromApi(c as Map<String, dynamic>));
        }
        
        if (fetchedCities.isEmpty) {
          fetchedCities = kurdishCities;
        }
        
        // Save to cache
        await _prefs.setString('prayer_settings_version_hash', newHash);
        await _prefs.setString('prayer_settings_calculation_method', method);
        await _prefs.setBool('prayer_settings_global_notifications', isEnabled);
        await _prefs.setString('prayer_settings_cities_list', jsonEncode(fetchedCities.map((c) => c.toJson()).toList()));
        
        // Update selected city if not in the list anymore
        KurdishCity currentSelected = state.selectedCity;
        bool exists = fetchedCities.any((c) => c.nameEn == currentSelected.nameEn);
        if (!exists && fetchedCities.isNotEmpty) {
          currentSelected = fetchedCities.first;
        }
        await _prefs.setString(_cityKey, jsonEncode(currentSelected.toJson()));
        
        state = state.copyWith(
          selectedCity: currentSelected,
          calculationMethod: method,
          cities: fetchedCities,
          versionHash: newHash,
        );
        
        await reschedule();
      }
    } catch (e) {
      // Offline fallback
    }
  }

  Future<void> changeCity(KurdishCity city) async {
    state = state.copyWith(selectedCity: city);
    await _prefs.setString(_cityKey, jsonEncode(city.toJson()));
    await reschedule();
    _syncCityOnTrigger(city);
  }

  Future<void> toggleAzan(bool enabled) async {
    // Request notification permission before enabling azan
    if (enabled && !kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')) {
      final plugin = FlutterLocalNotificationsPlugin();
      final androidPlugin = plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        if (granted == false) {
          debugPrint('Notification permission denied — azan not enabled.');
          return; // Do not enable if permission denied
        }
      }
    }
    state = state.copyWith(isAzanEnabled: enabled);
    await _prefs.setBool(_azanEnabledKey, enabled);
    await reschedule();
  }

  Future<void> togglePrayerNotification(String prayerName, bool enabled) async {
    final updatedToggles = Map<String, bool>.from(state.prayerToggles);
    updatedToggles[prayerName] = enabled;
    state = state.copyWith(prayerToggles: updatedToggles);
    await _prefs.setString(_togglesKey, jsonEncode(updatedToggles));
    await reschedule();
  }

  Future<void> changeAdhanSound(String soundName) async {
    state = state.copyWith(adhanSound: soundName);
    await _prefs.setString(_adhanSoundKey, soundName);
    await reschedule();
  }

  Future<void> changeCalculationMethod(String key) async {
    // 1. Update state locally
    state = state.copyWith(calculationMethod: key);
    await _prefs.setString('prayer_settings_calculation_method', key);
    reschedule();


  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final prayerTimesSettingsProvider =
    StateNotifierProvider<PrayerTimesNotifier, PrayerTimesState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrayerTimesNotifier(prefs, ref);
});

// Calculate prayer times for a given day
final prayerTimesForDateProvider =
    Provider.family<PrayerTimes, DateTime>((ref, date) {
  final settings = ref.watch(prayerTimesSettingsProvider);
  final city = settings.selectedCity;
  
  final coordinates = Coordinates(city.latitude, city.longitude);
  
  CalculationParameters params;
  switch (settings.calculationMethod) {
    case 'egyptian':
      params = CalculationMethod.egyptian.getParameters();
      break;
    case 'karachi':
      params = CalculationMethod.karachi.getParameters();
      break;
    case 'umm_al_qura':
      params = CalculationMethod.umm_al_qura.getParameters();
      break;
    case 'gulf':
      params = CalculationMethod.dubai.getParameters();
      break;
    case 'moonsighting_committee':
      params = CalculationMethod.moon_sighting_committee.getParameters();
      break;
    case 'isna':
    case 'north_america':
      params = CalculationMethod.north_america.getParameters();
      break;
    case 'kurdistan':
      params = CalculationMethod.muslim_world_league.getParameters();
      break;
    case 'turkey':
      params = CalculationMethod.turkey.getParameters();
      break;
    case 'singapore':
      params = CalculationMethod.singapore.getParameters();
      break;
    case 'tehran':
      params = CalculationMethod.tehran.getParameters();
      break;
    case 'shia':
      params = CalculationMethod.other.getParameters();
      break;
    case 'muslim_world_league':
    default:
      params = CalculationMethod.muslim_world_league.getParameters();
      break;
  }
  
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
  final PrayerType prayerType;

  NextPrayerInfo({
    required this.arabicName,
    required this.kurdishName,
    required this.time,
    required this.remaining,
    required this.prayerType,
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
      'type': PrayerType.fajr,
    },
    {
      'nameAr': 'الظهر',
      'nameKu': 'نیوەڕۆ',
      'time': todayTimes.dhuhr.toLocal(),
      'type': PrayerType.dhuhr,
    },
    {
      'nameAr': 'العصر',
      'nameKu': 'عەسڕ',
      'time': todayTimes.asr.toLocal(),
      'type': PrayerType.asr,
    },
    {
      'nameAr': 'المغرب',
      'nameKu': 'مەغریب',
      'time': todayTimes.maghrib.toLocal(),
      'type': PrayerType.maghrib,
    },
    {
      'nameAr': 'العشاء',
      'nameKu': 'عیشا',
      'time': todayTimes.isha.toLocal(),
      'type': PrayerType.isha,
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
        prayerType: p['type'] as PrayerType,
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
    prayerType: PrayerType.fajr,
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Prayer Calculation Methods Model & Providers
// ─────────────────────────────────────────────────────────────────────────────

class AppPrayerMethod {
  final int id;
  final String key;
  final String translationKeyName;
  final String translationKeyDesc;
  final Map<String, dynamic> config;
  final bool isDefault;
  final bool isUserActive;

  AppPrayerMethod({
    required this.id,
    required this.key,
    required this.translationKeyName,
    required this.translationKeyDesc,
    required this.config,
    required this.isDefault,
    required this.isUserActive,
  });

  factory AppPrayerMethod.fromJson(Map<String, dynamic> json) => AppPrayerMethod(
        id: json['id'] as int? ?? 0,
        key: json['key'] as String? ?? '',
        translationKeyName: json['translation_key_name'] as String? ?? '',
        translationKeyDesc: json['translation_key_desc'] as String? ?? '',
        config: json['config'] as Map<String, dynamic>? ?? {},
        isDefault: json['is_default'] as bool? ?? false,
        isUserActive: json['is_user_active'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'translation_key_name': translationKeyName,
        'translation_key_desc': translationKeyDesc,
        'config': config,
        'is_default': isDefault,
        'is_user_active': isUserActive,
      };
}

class PrayerMethodsState {
  final List<AppPrayerMethod> methods;
  final bool isLoading;
  final String versionHash;

  PrayerMethodsState({
    this.methods = const [],
    this.isLoading = false,
    this.versionHash = '',
  });

  PrayerMethodsState copyWith({
    List<AppPrayerMethod>? methods,
    bool? isLoading,
    String? versionHash,
  }) {
    return PrayerMethodsState(
      methods: methods ?? this.methods,
      isLoading: isLoading ?? this.isLoading,
      versionHash: versionHash ?? this.versionHash,
    );
  }
}

class PrayerMethodsNotifier extends StateNotifier<PrayerMethodsState> {
  final SharedPreferences _prefs;
  final Ref _ref;

  PrayerMethodsNotifier(this._prefs, this._ref) : super(PrayerMethodsState()) {
    _loadFromCache();
    Future.microtask(() => syncMethods());
  }

  void _loadFromCache() {
    final cachedHash = _prefs.getString('prayer_methods_version_hash') ?? '';
    final cachedListRaw = _prefs.getString('prayer_methods_list_json');
    List<AppPrayerMethod> list = [];
    if (cachedListRaw != null) {
      try {
        final decoded = jsonDecode(cachedListRaw) as List<dynamic>;
        list = decoded.map((c) => AppPrayerMethod.fromJson(c as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    state = PrayerMethodsState(methods: list, versionHash: cachedHash);
  }

  Future<void> syncMethods() async {
    state = state.copyWith(isLoading: state.methods.isEmpty);
    try {
      final client = _ref.read(apiClientProvider);
      final storedHash = state.versionHash;
      
      final response = await client.get(
        '/prayer-methods',
        queryParameters: {'version_hash': storedHash},
      );

      if (response.statusCode == 304) {
        state = state.copyWith(isLoading: false);
        return;
      }

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data as Map<String, dynamic>;
        final data = resData['data'] as Map<String, dynamic>;
        final newHash = data['version_hash'] as String? ?? '';
        final rawMethods = data['methods'] as List<dynamic>? ?? [];
        
        final fetchedMethods = rawMethods.map((m) => AppPrayerMethod.fromJson(m as Map<String, dynamic>)).toList();
        
        await _prefs.setString('prayer_methods_version_hash', newHash);
        await _prefs.setString('prayer_methods_list_json', jsonEncode(fetchedMethods.map((m) => m.toJson()).toList()));
        
        final activeMethodKey = data['active_method_key'] as String?;
        if (activeMethodKey != null && activeMethodKey.isNotEmpty) {
          final settingsNotifier = _ref.read(prayerTimesSettingsProvider.notifier);
          if (settingsNotifier.state.calculationMethod != activeMethodKey) {
            settingsNotifier.state = settingsNotifier.state.copyWith(calculationMethod: activeMethodKey);
            await _prefs.setString('prayer_settings_calculation_method', activeMethodKey);
            settingsNotifier.reschedule();
          }
        }

        state = PrayerMethodsState(
          methods: fetchedMethods,
          versionHash: newHash,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final prayerMethodsListProvider = StateNotifierProvider<PrayerMethodsNotifier, PrayerMethodsState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrayerMethodsNotifier(prefs, ref);
});
