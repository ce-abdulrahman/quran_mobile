import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prayer_widget_model.dart';
import '../providers/prayer_times_provider.dart';
import '../services/offline_prayer_widget_service.dart';
import '../../../core/providers/prayer_times_provider.dart';

class PrayerWidgetNotifier extends AsyncNotifier<PrayerWidgetModel?> {
  @override
  Future<PrayerWidgetModel?> build() async {
    // 1. Load locally immediately
    final localData = await OfflinePrayerWidgetService.getWidgetData(ref);

    // 2. Trigger background sync to keep cache fresh
    final settings = ref.read(prayerTimesSettingsProvider);
    final city = settings.selectedCity;
    final matchedCity = settings.cities.firstWhere(
      (c) => c.nameEn.toLowerCase() == city.nameEn.toLowerCase(),
      orElse: () => city,
    );
    final cityId = matchedCity.id ?? 1;
    final year = DateTime.now().year;

    ref.read(prayerTimesRepositoryProvider).fetchYear(
      cityId: cityId,
      year: year,
    ).then((freshResponse) {
      if (freshResponse != null) {
        OfflinePrayerWidgetService.getWidgetData(ref).then((updatedData) {
          state = AsyncValue.data(updatedData);
        }).catchError((_) {});
      }
    }).catchError((_) {});

    return localData;
  }

  Future<void> refreshWidgetData() async {
    state = const AsyncValue.loading();
    try {
      final settings = ref.read(prayerTimesSettingsProvider);
      final city = settings.selectedCity;
      final matchedCity = settings.cities.firstWhere(
        (c) => c.nameEn.toLowerCase() == city.nameEn.toLowerCase(),
        orElse: () => city,
      );
      final cityId = matchedCity.id ?? 1;
      final year = DateTime.now().year;

      // Force refresh cache
      await ref.read(prayerTimesRepositoryProvider).fetchYear(
        cityId: cityId,
        year: year,
        forceRefresh: true,
      );

      final data = await OfflinePrayerWidgetService.getWidgetData(ref);
      state = AsyncValue.data(data);
    } catch (e, stack) {
      try {
        final cachedData = await OfflinePrayerWidgetService.getWidgetData(ref);
        state = AsyncValue.data(cachedData);
      } catch (_) {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}

final prayerWidgetProvider = AsyncNotifierProvider<PrayerWidgetNotifier, PrayerWidgetModel?>(
  PrayerWidgetNotifier.new,
);
