import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tasbih_model.dart';
import 'app_providers.dart';

// State representing the merged list of active tasbihs + custom user tasbihs, and their counts.
class TasbihState {
  final List<TasbihModel> dhikrs;
  final Map<String, int> counts;
  final bool isLoading;
  final String? errorMessage;

  const TasbihState({
    required this.dhikrs,
    required this.counts,
    this.isLoading = false,
    this.errorMessage,
  });

  TasbihState copyWith({
    List<TasbihModel>? dhikrs,
    Map<String, int>? counts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TasbihState(
      dhikrs: dhikrs ?? this.dhikrs,
      counts: counts ?? this.counts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TasbihNotifier extends StateNotifier<TasbihState> {
  final SharedPreferences _prefs;
  final Ref _ref;

  static const _customKey = 'tasbih_custom_list';
  static const _countsKey = 'tasbih_session_counts';

  TasbihNotifier(this._prefs, this._ref)
      : super(const TasbihState(dhikrs: [], counts: {}, isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    // 1. Load custom local dhikrs
    final customRaw = _prefs.getString(_customKey);
    List<TasbihModel> customDhikrs = [];
    if (customRaw != null) {
      try {
        final decoded = jsonDecode(customRaw) as List;
        customDhikrs = decoded.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    // 2. Load dynamic counts
    final countsRaw = _prefs.getString(_countsKey);
    Map<String, int> counts = {};
    if (countsRaw != null) {
      try {
        final decoded = jsonDecode(countsRaw) as Map<String, dynamic>;
        counts = decoded.map((k, v) => MapEntry(k, v as int));
      } catch (_) {}
    } else {
      // Migrate legacy counts: tasbih_count, tasbih_count_1, tasbih_count_2
      final count0 = _prefs.getInt('tasbih_count') ?? 0;
      final count1 = _prefs.getInt('tasbih_count_1') ?? 0;
      final count2 = _prefs.getInt('tasbih_count_2') ?? 0;
      if (count0 > 0 || count1 > 0 || count2 > 0) {
        counts['1'] = count0;
        counts['2'] = count1;
        counts['3'] = count2;
        await _prefs.setString(_countsKey, jsonEncode(counts));
      }
    }

    state = state.copyWith(counts: counts);

    // 3. Fetch remote dhikrs and merge
    await fetchRemoteDhikrs(customDhikrs);
  }

  Future<void> fetchRemoteDhikrs(List<TasbihModel> customDhikrs) async {
    try {
      final repo = _ref.read(tasbihRepositoryProvider);
      final result = await repo.getTasbihs();

      result.when(
        success: (remoteList) {
          final merged = [...remoteList, ...customDhikrs];
          state = state.copyWith(
            dhikrs: merged,
            isLoading: false,
            errorMessage: null,
          );
        },
        error: (msg, code, cached) {
          final List<TasbihModel> merged = [...(cached ?? <TasbihModel>[]), ...customDhikrs];
          state = state.copyWith(
            dhikrs: merged,
            isLoading: false,
            errorMessage: msg,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addCustomDhikr(String name, int target) async {
    final newDhikr = TasbihModel(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      target: target,
      isCustom: true,
    );

    final updatedDhikrs = [...state.dhikrs, newDhikr];
    
    // Save to SharedPreferences custom list
    final customList = updatedDhikrs.where((e) => e.isCustom).toList();
    await _prefs.setString(_customKey, jsonEncode(customList.map((e) => e.toJson()).toList()));

    state = state.copyWith(dhikrs: updatedDhikrs);
  }

  Future<void> incrementCount(String dhikrId) async {
    final current = state.counts[dhikrId] ?? 0;
    final updatedCounts = {...state.counts, dhikrId: current + 1};
    state = state.copyWith(counts: updatedCounts);
    await _prefs.setString(_countsKey, jsonEncode(updatedCounts));
  }

  Future<void> resetCount(String dhikrId) async {
    final updatedCounts = {...state.counts, dhikrId: 0};
    state = state.copyWith(counts: updatedCounts);
    await _prefs.setString(_countsKey, jsonEncode(updatedCounts));
  }

  Future<void> deleteCustomDhikr(String dhikrId) async {
    final updatedDhikrs = state.dhikrs.where((e) => e.id != dhikrId).toList();
    final customList = updatedDhikrs.where((e) => e.isCustom).toList();
    await _prefs.setString(_customKey, jsonEncode(customList.map((e) => e.toJson()).toList()));

    final updatedCounts = {...state.counts};
    updatedCounts.remove(dhikrId);
    await _prefs.setString(_countsKey, jsonEncode(updatedCounts));

    state = state.copyWith(dhikrs: updatedDhikrs, counts: updatedCounts);
  }
}
