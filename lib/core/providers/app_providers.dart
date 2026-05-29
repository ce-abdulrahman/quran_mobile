import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../services/quran_api_client.dart';

// --- API Client Provider ---
final quranApiClientProvider = Provider<QuranApiClient>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return QuranApiClient(prefs: prefs);
});


// --- Database Provider ---
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// --- SharedPreferences Provider ---
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized yet');
});

// --- Shell Navigation Index Provider ---
final shellIndexProvider = StateProvider<int>((ref) => 0);

// --- Theme Provider ---
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _key = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(ThemeMode.dark) {
    final val = _prefs.getInt(_key) ?? 0; // 0=dark, 1=light, 2=system
    state = ThemeMode.values[val];
  }

  void setMode(ThemeMode mode) {
    state = mode;
    _prefs.setInt(_key, mode.index);
  }

  void toggle() {
    setMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
  
  bool get isDark => state == ThemeMode.dark;
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return ThemeModeNotifier(prefs);
});

// --- Locale Provider ---
class LocaleNotifier extends StateNotifier<Locale> {
  static const String _key = 'app_locale';
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs) : super(const Locale('ku')) {
    final lang = _prefs.getString(_key) ?? 'ku';
    state = Locale(lang);
  }

  void setLocale(Locale locale) {
    state = locale;
    _prefs.setString(_key, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return LocaleNotifier(prefs);
});

// --- Font Size Provider ---
class FontSizeNotifier extends StateNotifier<double> {
  static const String _key = 'font_size';
  final SharedPreferences _prefs;

  FontSizeNotifier(this._prefs) : super(24.0) {
    state = _prefs.getDouble(_key) ?? 24.0;
  }

  void setSize(double size) {
    state = size;
    _prefs.setDouble(_key, size);
  }
}

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return FontSizeNotifier(prefs);
});

// --- Kurdish Translation Toggle Provider ---
class ShowKurdishTranslationNotifier extends StateNotifier<bool> {
  static const String _key = 'show_kurdish_translation';
  final SharedPreferences _prefs;

  ShowKurdishTranslationNotifier(this._prefs) : super(true) {
    state = _prefs.getBool(_key) ?? true;
  }

  void setToggle(bool show) {
    state = show;
    _prefs.setBool(_key, show);
  }

  void toggle() {
    setToggle(!state);
  }
}

final showKurdishTranslationProvider = StateNotifierProvider<ShowKurdishTranslationNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return ShowKurdishTranslationNotifier(prefs);
});

// --- English Translation Toggle Provider ---
class ShowEnglishTranslationNotifier extends StateNotifier<bool> {
  static const String _key = 'show_english_translation';
  final SharedPreferences _prefs;

  ShowEnglishTranslationNotifier(this._prefs) : super(false) {
    state = _prefs.getBool(_key) ?? false;
  }

  void setToggle(bool show) {
    state = show;
    _prefs.setBool(_key, show);
  }

  void toggle() {
    setToggle(!state);
  }
}

final showEnglishTranslationProvider = StateNotifierProvider<ShowEnglishTranslationNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return ShowEnglishTranslationNotifier(prefs);
});

// --- Tasbih State Class ---
class TasbihState {
  final int totalCount;
  TasbihState({required this.totalCount});
}

// --- Tasbih Notifier ---
class TasbihNotifier extends StateNotifier<TasbihState> {
  static const String _totalKey = 'tasbih_total';
  final SharedPreferences _prefs;

  TasbihNotifier(this._prefs) : super(TasbihState(totalCount: 0)) {
    final tc = _prefs.getInt(_totalKey) ?? 0;
    state = TasbihState(totalCount: tc);
  }

  void incrementGlobal() {
    final newTotal = state.totalCount + 1;
    state = TasbihState(totalCount: newTotal);
    _prefs.setInt(_totalKey, newTotal);
  }

  void resetGlobal() {
    state = TasbihState(totalCount: 0);
    _prefs.setInt(_totalKey, 0);
  }
}

final tasbihCountProvider = StateNotifierProvider<TasbihNotifier, TasbihState>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return TasbihNotifier(prefs);
});

// --- Dynamic Dhikrs Providers ---

final selectedDhikrIdProvider = StateProvider<int>((ref) => 1);

final dhikrsStreamProvider = StreamProvider<List<Dhikr>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.dhikrs)..orderBy([(t) => OrderingTerm(expression: t.id)])).watch();
});

final activeDhikrProvider = Provider<AsyncValue<Dhikr>>((ref) {
  final dhikrsAsync = ref.watch(dhikrsStreamProvider);
  final selectedId = ref.watch(selectedDhikrIdProvider);

  return dhikrsAsync.when(
    data: (list) {
      if (list.isEmpty) {
        return const AsyncValue.loading();
      }
      final item = list.firstWhere((d) => d.id == selectedId, orElse: () => list.first);
      return AsyncValue.data(item);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

class DhikrController {
  final AppDatabase _db;
  final Ref _ref;
  DateTime _lastTapTime = DateTime.now();
  static const Duration _cooldown = Duration(milliseconds: 150);

  DhikrController(this._db, this._ref);

  Future<bool?> increment(int dhikrId, int currentCount, int target) async {
    final now = DateTime.now();
    if (now.difference(_lastTapTime) < _cooldown) {
      return null;
    }
    _lastTapTime = now;

    int newCount = currentCount + 1;
    bool hitTarget = false;
    if (newCount >= target) {
      newCount = 0;
      hitTarget = true;
    }

    await (_db.update(_db.dhikrs)..where((t) => t.id.equals(dhikrId)))
        .write(DhikrsCompanion(count: Value(newCount)));

    _ref.read(tasbihCountProvider.notifier).incrementGlobal();

    return hitTarget;
  }

  Future<void> reset(int dhikrId) async {
    await (_db.update(_db.dhikrs)..where((t) => t.id.equals(dhikrId)))
        .write(const DhikrsCompanion(count: Value(0)));
  }

  Future<void> resetAll() async {
    await (_db.update(_db.dhikrs)).write(const DhikrsCompanion(count: Value(0)));
    _ref.read(tasbihCountProvider.notifier).resetGlobal();
  }

  Future<void> addDhikr(String name, String? arabic, int target) async {
    await _db.into(_db.dhikrs).insert(
      DhikrsCompanion.insert(
        name: name,
        arabic: Value(arabic),
        target: target,
        isSystem: const Value(false),
      ),
    );
  }

  Future<void> deleteDhikr(int id) async {
    await (_db.delete(_db.dhikrs)..where((t) => t.id.equals(id))).go();
  }
}

final dhikrControllerProvider = Provider<DhikrController>((ref) {
  final db = ref.watch(databaseProvider);
  return DhikrController(db, ref);
});

