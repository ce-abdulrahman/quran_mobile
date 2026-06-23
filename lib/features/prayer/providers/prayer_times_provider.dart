import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prayer_times_model.dart';
import '../repositories/prayer_times_repository.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/providers/prayer_times_provider.dart';

// ─── Repository Provider ──────────────────────────────────────────────────────

final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>((ref) {
  return PrayerTimesRepository(
    ref.watch(apiClientProvider),
  );
});

// ─── State: Selected City & Year ──────────────────────────────────────────────

class PrayerTimesSelection {
  final int cityId;
  final int year;

  const PrayerTimesSelection({required this.cityId, required this.year});

  PrayerTimesSelection copyWith({int? cityId, int? year}) => PrayerTimesSelection(
        cityId: cityId ?? this.cityId,
        year:   year   ?? this.year,
      );
}

final cityIdForSettingsProvider = Provider<int>((ref) {
  final settings = ref.watch(prayerTimesSettingsProvider);
  final city = settings.selectedCity;
  final matched = settings.cities.firstWhere(
    (c) => c.nameEn.toLowerCase() == city.nameEn.toLowerCase(),
    orElse: () => city,
  );
  return matched.id ?? 1;
});

final prayerTimesSelectionProvider =
    StateProvider<PrayerTimesSelection>((ref) {
  final cityId = ref.watch(cityIdForSettingsProvider);
  return PrayerTimesSelection(
    cityId: cityId,
    year:   DateTime.now().year,
  );
});

// ─── Main Notifier ────────────────────────────────────────────────────────────

class PrayerTimesNotifier extends AsyncNotifier<PrayerTimesResponse?> {
  @override
  Future<PrayerTimesResponse?> build() async {
    final selection = ref.watch(prayerTimesSelectionProvider);
    final repo = ref.watch(prayerTimesRepositoryProvider);

    return await repo.fetchYear(
      cityId: selection.cityId,
      year:   selection.year,
    );
  }

  /// Force a fresh fetch from the API (ignores cache version hash).
  Future<void> refresh() async {
    final selection = ref.read(prayerTimesSelectionProvider);
    final repo = ref.read(prayerTimesRepositoryProvider);

    state = const AsyncValue.loading();
    try {
      final data = await repo.fetchYear(
        cityId: selection.cityId,
        year:   selection.year,
        forceRefresh: true,
      );
      state = AsyncValue.data(data);
    } catch (e, st) {
      // Fallback to whatever is in cache
      final cached = await repo.fetchYear(
        cityId: selection.cityId,
        year:   selection.year,
      );
      state = cached != null ? AsyncValue.data(cached) : AsyncValue.error(e, st);
    }
  }

  /// Switch to a different city and reload.
  void selectCity(int cityId) {
    ref.read(prayerTimesSelectionProvider.notifier).update(
          (s) => s.copyWith(cityId: cityId),
        );
    // Rebuild triggered automatically by ref.watch in build()
  }

  /// Switch to a different year and reload.
  void selectYear(int year) {
    ref.read(prayerTimesSelectionProvider.notifier).update(
          (s) => s.copyWith(year: year),
        );
  }
}

/// Main provider for the full year's prayer times.
final prayerTimesProvider =
    AsyncNotifierProvider<PrayerTimesNotifier, PrayerTimesResponse?>(
  PrayerTimesNotifier.new,
);

// ─── Per-Date Provider ────────────────────────────────────────────────────────

/// Family provider to look up prayer times for a specific date string "YYYY-MM-DD".
/// Returns the DB entry if cached, or null (caller applies adhan fallback).
final prayerTimeForDateProvider =
    FutureProvider.family<PrayerTimeEntry?, String>((ref, date) async {
  final selection = ref.watch(prayerTimesSelectionProvider);
  final repo = ref.watch(prayerTimesRepositoryProvider);

  return await repo.getForDate(
    cityId: selection.cityId,
    date:   date,
  );
});

// ─── Cities List Provider ─────────────────────────────────────────────────────

final prayerTimesCitiesProvider =
    FutureProvider<List<PrayerTimeCity>>((ref) async {
  final repo = ref.watch(prayerTimesRepositoryProvider);
  return await repo.fetchCities();
});
