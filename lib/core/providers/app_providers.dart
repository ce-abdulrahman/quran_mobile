import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import '../local_db/isar_service.dart';
import '../local_db/isar_collections.dart';
import '../cache/cache_manager.dart';
import '../network/api_client.dart';
import '../repositories/surah_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/audio_repository.dart';
import '../repositories/adhkar_repository.dart';
import '../repositories/tasbih_repository.dart';
import '../repositories/hadith_repository.dart';
import '../repositories/tajweed_repository.dart';
import '../repositories/backup_repository.dart';

import '../models/ayah_model.dart';
import '../models/banner_model.dart';
import '../models/tajweed_rule_model.dart';
import '../models/tajweed_category_model.dart';
import '../services/reciter_history_sync_queue.dart';

import '../models/app_settings_model.dart';
import '../constants/app_colors.dart';

import 'adhkar_provider.dart';
import 'tasbih_provider.dart';
import 'hadith_provider.dart';

export 'favorites_provider.dart';
export 'reading_tracker_provider.dart';

export 'adhkar_provider.dart';
export 'tasbih_provider.dart';
export 'hadith_provider.dart';
export 'reminder_provider.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences in main.dart first');
});

final appVersionProvider = Provider<String>((ref) {
  throw UnimplementedError('Initialize app version in main.dart first');
});

final hiveCacheBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('Initialize Hive cache box in main.dart first');
});

final prayerTimesHiveBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError(
    'Initialize Prayer Times Hive box in main.dart first',
  );
});

final cacheManagerProvider = Provider<CacheManager>((ref) {
  final box = ref.watch(hiveCacheBoxProvider);
  return CacheManager(box);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ApiClient(tokenProvider: () => prefs.getString('auth_token') ?? '');
});

final reciterHistorySyncQueueProvider = Provider<ReciterHistorySyncQueue>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final client = ref.watch(apiClientProvider);
  return ReciterHistorySyncQueue(prefs: prefs, apiClient: client);
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
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return ThemeModeNotifier(prefs);
  },
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  static const _key = 'app_theme_mode';

  ThemeModeNotifier(this._prefs) : super(_load(_prefs));

  static ThemeMode _load(SharedPreferences p) {
    final saved = p.getString(_key);
    return switch (saved) {
      'dark' => ThemeMode.dark,
      _ => ThemeMode.light, // default to light, not system
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  /// Toggles between light and dark only
  void toggle() => setMode(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  void cycle() => toggle();
}

class ReaderSettings {
  final double fontSize;
  final bool showKurdish;
  final bool showEnglish;
  final bool distractionFree;
  final bool showTajweed;
  final double lineHeight;
  final String bgMode; // 'light' | 'dark' | 'cream' | 'khaki'
  // Internal automatic font management - no user selection
  // Quran font: AmiriQuran (loaded lazily when needed)
  // UI font: Cairo (Kurdish/English), IBMPlexSansArabic (Arabic)

  const ReaderSettings({
    required this.fontSize,
    required this.showKurdish,
    required this.showEnglish,
    required this.distractionFree,
    required this.showTajweed,
    required this.lineHeight,
    required this.bgMode,
  });

  ReaderSettings copyWith({
    double? fontSize,
    bool? showKurdish,
    bool? showEnglish,
    bool? distractionFree,
    bool? showTajweed,
    double? lineHeight,
    String? bgMode,
  }) {
    return ReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      showKurdish: showKurdish ?? this.showKurdish,
      showEnglish: showEnglish ?? this.showEnglish,
      distractionFree: distractionFree ?? this.distractionFree,
      showTajweed: showTajweed ?? this.showTajweed,
      lineHeight: lineHeight ?? this.lineHeight,
      bgMode: bgMode ?? this.bgMode,
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
  static const _lineHeightKey = 'reader_line_height';
  static const _bgModeKey = 'reader_bg_mode';

  ReaderSettingsNotifier(this._prefs)
    : super(
        ReaderSettings(
          fontSize: _prefs.getDouble(_fontSizeKey) ?? 18.0,
          showKurdish: _prefs.getBool(_showKuKey) ?? true,
          showEnglish: _prefs.getBool(_showEnKey) ?? true,
          distractionFree: _prefs.getBool(_distractionFreeKey) ?? true,
          showTajweed: _prefs.getBool(_showTajweedKey) ?? false,
          lineHeight: _prefs.getDouble(_lineHeightKey) ?? 2.0,
          bgMode: _prefs.getString(_bgModeKey) ?? 'cream',
        ),
      );

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

  Future<void> setLineHeight(double height) async {
    state = state.copyWith(lineHeight: height);
    await _prefs.setDouble(_lineHeightKey, height);
  }

  Future<void> setBgMode(String mode) async {
    state = state.copyWith(bgMode: mode);
    await _prefs.setString(_bgModeKey, mode);
  }
}

final readerSettingsProvider =
    StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return ReaderSettingsNotifier(prefs);
    });

// ─────────────────────────────────────────────────────────────────────────────
// Font Utilities (Internal Automatic Management)
// ─────────────────────────────────────────────────────────────────────────────

/// Font families for internal automatic management only.
/// No user-facing font selection - fonts are chosen automatically based on language/context.
class FontFamilies {
  // Quran fonts (installed in pubspec.yaml)
  static const String amiriQuran = 'AmiriQuran';

  // Arabic UI font
  static const String ibmPlexSansArabic = 'IBMPlexSansArabic';

  // Kurdish/English UI font
  static const String cairo = 'Cairo';

  /// Get appropriate font for language/context
  static String getFontForLanguage({
    required String languageCode, // 'ku', 'ar', 'en'
  }) {
    switch (languageCode) {
      case 'ar':
        return amiriQuran;
      case 'ku':
        return cairo;
      case 'en':
        return cairo;
      default:
        return amiriQuran;
    }
  }
}

class AccentGradient extends Color {
  final Color start;
  final Color end;
  final Color primary;

  AccentGradient({
    required this.start,
    required this.end,
    required this.primary,
  }) : super(primary.value);

  // Default: Logo Green (سەوزی قورئانەکەم)
  static final AccentGradient defaultGradient = AccentGradient(
    start: const Color(0xFF075E45),
    end: const Color(0xFF023224),
    primary: const Color(0xFF075E45),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Accent Color Provider (keeps backward compat via .primary)
// ─────────────────────────────────────────────────────────────────────────────

class AccentColorNotifier extends StateNotifier<AccentGradient> {
  final SharedPreferences _prefs;
  static const _keyStart = 'accent_gradient_start';
  static const _keyEnd = 'accent_gradient_end';
  static const _keyPrimary = 'accent_color_value'; // kept for compat

  AccentColorNotifier(this._prefs) : super(_load(_prefs));

  static AccentGradient _load(SharedPreferences p) {
    final startVal = p.getInt(_keyStart);
    final endVal = p.getInt(_keyEnd);
    final primaryVal = p.getInt(_keyPrimary);
    if (startVal == null) return AccentGradient.defaultGradient;
    return AccentGradient(
      start: Color(startVal),
      end: endVal != null ? Color(endVal) : Color(startVal),
      primary: primaryVal != null ? Color(primaryVal) : Color(startVal),
    );
  }

  Future<void> setColor(Color color) async {
    state = AccentGradient(start: color, end: color, primary: color);
    await _prefs.setInt(_keyStart, color.toARGB32());
    await _prefs.setInt(_keyEnd, color.toARGB32());
    await _prefs.setInt(_keyPrimary, color.toARGB32());
  }

  Future<void> setGradient(Color start, Color end, Color primary) async {
    state = AccentGradient(start: start, end: end, primary: primary);
    await _prefs.setInt(_keyStart, start.toARGB32());
    await _prefs.setInt(_keyEnd, end.toARGB32());
    await _prefs.setInt(_keyPrimary, primary.toARGB32());
  }

  Future<void> cycle() async {
    final opts = AppColors.accentGradientOptions;
    final currentIndex = opts.indexWhere(
      (o) => o.$1.toARGB32() == state.start.toARGB32(),
    );
    final nextIndex = (currentIndex + 1) % opts.length;
    final next = opts[nextIndex];
    await setGradient(next.$1, next.$2, next.$3);
  }
}

final accentColorProvider =
    StateNotifierProvider<AccentColorNotifier, AccentGradient>((ref) {
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

final adhkarCategoriesFutureProvider = FutureProvider<List<AdhkarCategory>>((
  ref,
) async {
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

final tasbihProvider = StateNotifierProvider<TasbihNotifier, TasbihState>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return TasbihNotifier(prefs, ref);
});

final hadithRepositoryProvider = Provider<HadithRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  final cache = ref.watch(cacheManagerProvider);
  return HadithRepository(client, cache);
});

final hadithCategoriesFutureProvider = FutureProvider<List<HadithCategory>>((
  ref,
) async {
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

final tajweedRulesFutureProvider = FutureProvider<List<TajweedRuleModel>>((
  ref,
) async {
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

final tajweedCategoriesProvider = FutureProvider<List<TajweedCategoryModel>>((
  ref,
) async {
  final repo = ref.watch(tajweedRepositoryProvider);
  final result = await repo.getTajweedCategories();
  return result.when(
    success: (cats) => cats,
    error: (msg, code, cached) {
      if (cached != null) return cached;
      throw Exception(msg);
    },
  );
});

// Synchronous lookup map: ruleId → TajweedRuleModel
// Used by _TajweedText to resolve a tapped segment's rule instantly.
final tajweedRuleMapProvider = Provider<Map<int, TajweedRuleModel>>((ref) {
  final rulesAsync = ref.watch(tajweedRulesFutureProvider);
  return rulesAsync.maybeWhen(
    data: (rules) => {for (final r in rules) r.id: r},
    orElse: () => {},
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

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return BackupRepository(client);
});

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppLocaleNotifier(prefs);
});

class AppLocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  static const _key = 'app_language_code';

  AppLocaleNotifier(this._prefs)
    : super(Locale(_prefs.getString(_key) ?? 'ku'));

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await _prefs.setString(_key, languageCode);
  }
}

final tajweedRuleSegmentsCountProvider = FutureProvider.family<int, String>((ref, ruleSlug) async {
  if (kIsWeb) return 0;
  final isar = IsarService.instance.isar;
  final rule = await isar.tajweedRuleCollections.filter().ruleSlugEqualTo(ruleSlug).findFirst();
  if (rule == null) return 0;

  final count = await isar.ayahCollections
      .filter()
      .tajweedSegmentsElement((q) => q.ruleIdEqualTo(rule.ruleId))
      .count();
  return count;
});

final tajweedCategorySegmentsCountProvider = FutureProvider.family<int, TajweedCategoryModel>((ref, category) async {
  if (kIsWeb) return 0;
  final isar = IsarService.instance.isar;
  int total = 0;
  for (final rule in category.rules) {
    final count = await isar.ayahCollections
        .filter()
        .tajweedSegmentsElement((q) => q.ruleIdEqualTo(rule.id))
        .count();
    total += count;
  }
  return total;
});

final mushafZoomProvider = StateNotifierProvider<MushafZoomNotifier, double>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return MushafZoomNotifier(prefs);
});

class MushafZoomNotifier extends StateNotifier<double> {
  final SharedPreferences _prefs;
  MushafZoomNotifier(this._prefs) : super(_prefs.getDouble('quran.page_zoom') ?? 1.0);

  Future<void> setZoom(double val) async {
    state = val.clamp(1.0, 3.0);
    await _prefs.setDouble('quran.page_zoom', state);
  }
}
