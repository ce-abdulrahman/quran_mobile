import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache/cache_manager.dart';
import '../network/api_client.dart';
import '../repositories/surah_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/audio_repository.dart';
import '../repositories/adhkar_repository.dart';
import '../repositories/tasbih_repository.dart';
import '../repositories/hadith_repository.dart';
import '../repositories/tajweed_repository.dart';
import '../models/ayah_model.dart';
import '../models/banner_model.dart';
import '../models/tajweed_rule_model.dart';

import '../models/app_settings_model.dart';

import 'adhkar_provider.dart';
import 'tasbih_provider.dart';
import 'hadith_provider.dart';

export 'favorites_provider.dart';
export 'reading_tracker_provider.dart';
export 'khatm_provider.dart';
export 'adhkar_provider.dart';
export 'tasbih_provider.dart';
export 'hadith_provider.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences in main.dart first');
});

final cacheManagerProvider = Provider<CacheManager>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CacheManager(prefs);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final surahRepositoryProvider = Provider<SurahRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return SurahRepository(client, cache);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return SettingsRepository(client, cache);
});

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return AudioRepository(client);
});

final appSettingsProvider = FutureProvider<AppSettingsModel>((ref) async {
  final repo = ref.watch(settingsRepositoryProvider);
  final result = await repo.getSettings();
  return result.when(
    success: (data) => data,
    error: (message, code, cachedData) {
      if (cachedData != null) return cachedData;
      return const AppSettingsModel(fontSize: 16.0, themeMode: 'system');
    },
  );
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  /// Cycles: system → light → dark → system
  void cycle() {
    state = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }

  /// For settings page direct set
  void setMode(ThemeMode mode) => state = mode;

  // Keep backward compat with home_page.dart toggle()
  void toggle() => cycle();
}

class ReaderSettings {
  final double fontSize;
  final bool showKurdish;
  final bool showEnglish;
  final bool distractionFree;
  final bool showTajweed;

  const ReaderSettings({
    required this.fontSize,
    required this.showKurdish,
    required this.showEnglish,
    required this.distractionFree,
    required this.showTajweed,
  });

  ReaderSettings copyWith({
    double? fontSize,
    bool? showKurdish,
    bool? showEnglish,
    bool? distractionFree,
    bool? showTajweed,
  }) {
    return ReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      showKurdish: showKurdish ?? this.showKurdish,
      showEnglish: showEnglish ?? this.showEnglish,
      distractionFree: distractionFree ?? this.distractionFree,
      showTajweed: showTajweed ?? this.showTajweed,
    );
  }
}

class ReaderSettingsNotifier extends StateNotifier<ReaderSettings> {
  final SharedPreferences _prefs;
  static const _fontSizeKey = 'reader_font_size';
  static const _showKuKey = 'reader_show_kurdish';
  static const _showEnKey = 'reader_show_english';
  static const _distractionFreeKey = 'reader_distraction_free';
  static const _showTajweedKey = 'reader_show_tajweed';

  ReaderSettingsNotifier(this._prefs)
      : super(ReaderSettings(
          fontSize: _prefs.getDouble(_fontSizeKey) ?? 18.0,
          showKurdish: _prefs.getBool(_showKuKey) ?? true,
          showEnglish: _prefs.getBool(_showEnKey) ?? true,
          distractionFree: _prefs.getBool(_distractionFreeKey) ?? true,
          showTajweed: _prefs.getBool(_showTajweedKey) ?? true,
        ));

  Future<void> setFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    await _prefs.setDouble(_fontSizeKey, size);
  }

  Future<void> toggleKurdish(bool val) async {
    state = state.copyWith(showKurdish: val);
    await _prefs.setBool(_showKuKey, val);
  }

  Future<void> toggleEnglish(bool val) async {
    state = state.copyWith(showEnglish: val);
    await _prefs.setBool(_showEnKey, val);
  }

  Future<void> toggleDistractionFree(bool val) async {
    state = state.copyWith(distractionFree: val);
    await _prefs.setBool(_distractionFreeKey, val);
  }

  Future<void> toggleTajweed(bool val) async {
    state = state.copyWith(showTajweed: val);
    await _prefs.setBool(_showTajweedKey, val);
  }
}

final readerSettingsProvider = StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ReaderSettingsNotifier(prefs);
});

// ─────────────────────────────────────────────────────────────────────────────
// Accent Color Provider
// ─────────────────────────────────────────────────────────────────────────────

class AccentColorNotifier extends StateNotifier<Color> {
  final SharedPreferences _prefs;
  static const _key = 'accent_color_value';

  AccentColorNotifier(this._prefs)
      : super(Color(_prefs.getInt(_key) ?? const Color(0xFF1AB66D).toARGB32()));

  Future<void> setColor(Color color) async {
    state = color;
    await _prefs.setInt(_key, color.toARGB32());
  }
}

final accentColorProvider =
    StateNotifierProvider<AccentColorNotifier, Color>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AccentColorNotifier(prefs);
});

final dailyVerseProvider = FutureProvider<AyahModel>((ref) async {
  final repo = ref.watch(surahRepositoryProvider);
  final result = await repo.getDailyVerse();
  return result.when(
    success: (ayah) => ayah,
    error: (msg, code, cached) {
      if (cached != null) return cached;
      throw Exception(msg);
    },
  );
});

final bannersProvider = FutureProvider<List<BannerModel>>((ref) async {
  final repo = ref.watch(surahRepositoryProvider);
  final result = await repo.getBanners();
  return result.when(
    success: (banners) => banners,
    error: (msg, code, cached) {
      if (cached != null) return cached;
      throw Exception(msg);
    },
  );
});

final adhkarRepositoryProvider = Provider<AdhkarRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return AdhkarRepository(client, cache);
});

final adhkarCategoriesFutureProvider = FutureProvider<List<AdhkarCategory>>((ref) async {
  final repo = ref.watch(adhkarRepositoryProvider);
  final result = await repo.getAdhkars();
  return result.when(
    success: (categories) => categories,
    error: (msg, code, cached) {
      if (cached != null) return cached;
      throw Exception(msg);
    },
  );
});

final tasbihRepositoryProvider = Provider<TasbihRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return TasbihRepository(client, cache);
});

final tasbihProvider = StateNotifierProvider<TasbihNotifier, TasbihState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TasbihNotifier(prefs, ref);
});

final hadithRepositoryProvider = Provider<HadithRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return HadithRepository(client, cache);
});

final hadithCategoriesFutureProvider = FutureProvider<List<HadithCategory>>((ref) async {
  final repo = ref.watch(hadithRepositoryProvider);
  final result = await repo.getHadiths();
  return result.when(
    success: (categories) => categories,
    error: (msg, code, cached) {
      if (cached != null) return cached;
      throw Exception(msg);
    },
  );
});

final tajweedRepositoryProvider = Provider<TajweedRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return TajweedRepository(client, cache);
});

final tajweedRulesFutureProvider = FutureProvider<List<TajweedRuleModel>>((ref) async {
  final repo = ref.watch(tajweedRepositoryProvider);
  final result = await repo.getTajweedRules();
  return result.when(
    success: (rules) => rules,
    error: (msg, code, cached) {
      if (cached != null) return cached;
      throw Exception(msg);
    },
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Active/Inactive Tajweed Rules Provider
// ─────────────────────────────────────────────────────────────────────────────

class InactiveTajweedRulesNotifier extends StateNotifier<Set<String>> {
  final SharedPreferences _prefs;
  static const _key = 'inactive_tajweed_rules';

  InactiveTajweedRulesNotifier(this._prefs) : super(_loadInactiveRules(_prefs));

  static Set<String> _loadInactiveRules(SharedPreferences prefs) {
    final list = prefs.getStringList(_key);
    if (list == null) return {};
    return list.toSet();
  }

  Future<void> toggleRule(String slug, bool active) async {
    final newState = Set<String>.from(state);
    if (active) {
      newState.remove(slug); // Remove from inactive -> active
    } else {
      newState.add(slug); // Add to inactive -> inactive
    }
    state = newState;
    await _prefs.setStringList(_key, newState.toList());
  }
}

final inactiveTajweedRulesProvider =
    StateNotifierProvider<InactiveTajweedRulesNotifier, Set<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return InactiveTajweedRulesNotifier(prefs);
});

