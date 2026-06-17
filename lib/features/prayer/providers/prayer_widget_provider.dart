import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prayer_widget_model.dart';
import '../repositories/prayer_widget_repository.dart';
import '../../../core/providers/app_providers.dart';

final prayerWidgetRepositoryProvider = Provider<PrayerWidgetRepository>((ref) {
  return PrayerWidgetRepository(ref.watch(apiClientProvider));
});

class PrayerWidgetNotifier extends AsyncNotifier<PrayerWidgetModel?> {
  @override
  Future<PrayerWidgetModel?> build() async {
    final repo = ref.watch(prayerWidgetRepositoryProvider);
    return await repo.getWidgetData();
  }

  Future<void> refreshWidgetData() async {
    state = const AsyncValue.loading();
    final repo = ref.read(prayerWidgetRepositoryProvider);
    try {
      final data = await repo.getWidgetData(forceRefresh: true);
      state = AsyncValue.data(data);
    } catch (e, stack) {
      // In case of error, try to fallback to whatever is in the cache (from repository)
      final cached = await repo.getWidgetData();
      if (cached != null) {
        state = AsyncValue.data(cached);
      } else {
        state = AsyncValue.error(e, stack);
      }
    }
  }
}

final prayerWidgetProvider = AsyncNotifierProvider<PrayerWidgetNotifier, PrayerWidgetModel?>(
  PrayerWidgetNotifier.new,
);
