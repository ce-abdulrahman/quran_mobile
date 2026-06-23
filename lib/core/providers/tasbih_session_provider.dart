import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tasbih_session_model.dart';
import '../models/tasbih_session_log_model.dart';
import '../models/tasbih_session_analytics_model.dart';
import '../repositories/tasbih_session_repository.dart';
import 'app_providers.dart';
import '../network/api_result.dart';

class TasbihSessionState {
  final bool isLoading;
  final bool isSyncing;
  final String? errorMessage;
  final TasbihSessionModel? activeSession;
  final List<TasbihSessionModel> history;
  final TasbihSessionAnalyticsModel? analytics;
  final int currentCount;
  final int activeDurationSeconds;
  final String mode; // normal, focus, minimal
  final bool isPaused;
  final List<TasbihSessionLogModel> unsyncedIncrements;

  TasbihSessionState({
    this.isLoading = false,
    this.isSyncing = false,
    this.errorMessage,
    this.activeSession,
    this.history = const [],
    this.analytics,
    this.currentCount = 0,
    this.activeDurationSeconds = 0,
    this.mode = 'normal',
    this.isPaused = false,
    this.unsyncedIncrements = const [],
  });

  TasbihSessionState copyWith({
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    TasbihSessionModel? activeSession,
    bool clearActiveSession = false,
    List<TasbihSessionModel>? history,
    TasbihSessionAnalyticsModel? analytics,
    int? currentCount,
    int? activeDurationSeconds,
    String? mode,
    bool? isPaused,
    List<TasbihSessionLogModel>? unsyncedIncrements,
  }) {
    return TasbihSessionState(
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: errorMessage ?? this.errorMessage,
      activeSession: clearActiveSession ? null : (activeSession ?? this.activeSession),
      history: history ?? this.history,
      analytics: analytics ?? this.analytics,
      currentCount: currentCount ?? this.currentCount,
      activeDurationSeconds: activeDurationSeconds ?? this.activeDurationSeconds,
      mode: mode ?? this.mode,
      isPaused: isPaused ?? this.isPaused,
      unsyncedIncrements: unsyncedIncrements ?? this.unsyncedIncrements,
    );
  }
}

final tasbihSessionRepositoryProvider = Provider<TasbihSessionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TasbihSessionRepository(ref, apiClient);
});

class TasbihSessionNotifier extends StateNotifier<TasbihSessionState> {
  final TasbihSessionRepository _repository;
  Timer? _tickerTimer;
  Timer? _syncTimer;
  DateTime _lastTapTime = DateTime.fromMillisecondsSinceEpoch(0);

  TasbihSessionNotifier(this._repository) : super(TasbihSessionState()) {
    // Check server for active session on app startup (Session Recovery)
    recoverActiveSession();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }

  /// RESTORE Session if active on server.
  Future<void> recoverActiveSession() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getActiveSession();
    if (result is ApiSuccess<TasbihSessionModel?>) {
      final session = result.data;
      if (session != null) {
        // Calculate duration offset between start time and now (excluding pause time if server status was paused)
        final bool isPaused = session.status == 'paused';
        final int initialDuration = session.durationSeconds > 0 
            ? session.durationSeconds
            : DateTime.now().difference(session.startTime).inSeconds;

        state = state.copyWith(
          isLoading: false,
          activeSession: session,
          currentCount: session.totalCount,
          activeDurationSeconds: initialDuration,
          isPaused: isPaused,
        );

        if (!isPaused) {
          _startTicker();
        }
        _startSyncTimer();
      } else {
        state = state.copyWith(isLoading: false, clearActiveSession: true);
      }
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  /// START a new structured session.
  Future<bool> startSession({int? dhikrId, String? customDhikrName}) async {
    _tickerTimer?.cancel();
    _syncTimer?.cancel();

    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _repository.startSession(
      dhikrId: dhikrId,
      customDhikrName: customDhikrName,
    );

    if (result is ApiSuccess<TasbihSessionModel>) {
      state = state.copyWith(
        isLoading: false,
        activeSession: result.data,
        currentCount: 0,
        activeDurationSeconds: 0,
        isPaused: false,
        unsyncedIncrements: [],
      );
      _startTicker();
      _startSyncTimer();
      return true;
    } else if (result is ApiError<TasbihSessionModel>) {
      state = state.copyWith(isLoading: false, errorMessage: result.message);
      return false;
    }
    return false;
  }

  /// INCREMENT count locally & enqueue for sync (Anti Double-Tap & Queue Sync).
  void increment() {
    final now = DateTime.now();
    // 50ms Debouncer Guard
    if (now.difference(_lastTapTime).inMilliseconds < 50) {
      return;
    }
    _lastTapTime = now;

    if (state.activeSession == null) return;

    final updatedCount = state.currentCount + 1;
    final log = TasbihSessionLogModel(
      eventUuid: _generateUuid(),
      eventType: 'increment',
      value: 1,
      timestamp: DateTime.now().toUtc(),
    );

    state = state.copyWith(
      currentCount: updatedCount,
      unsyncedIncrements: [...state.unsyncedIncrements, log],
    );
  }

  /// PAUSE structured session.
  Future<void> pause() async {
    if (state.activeSession == null || state.isPaused) return;

    // Force flush increments before state change
    await syncQueuedIncrements();

    final uuid = _generateUuid();
    final timeStr = DateTime.now().toUtc().toIso8601String().replaceAll('T', ' ').substring(0, 19);

    _tickerTimer?.cancel();
    state = state.copyWith(isPaused: true);

    await _repository.pauseSession(
      sessionId: state.activeSession!.id,
      eventUuid: uuid,
      timestamp: timeStr,
    );
  }

  /// RESUME structured session.
  Future<void> resume() async {
    if (state.activeSession == null || !state.isPaused) return;

    final uuid = _generateUuid();
    final timeStr = DateTime.now().toUtc().toIso8601String().replaceAll('T', ' ').substring(0, 19);

    state = state.copyWith(isPaused: false);
    _startTicker();

    await _repository.resumeSession(
      sessionId: state.activeSession!.id,
      eventUuid: uuid,
      timestamp: timeStr,
    );
  }

  /// END structured session (syncs final count and unlocks achievements).
  Future<TasbihSessionModel?> end() async {
    if (state.activeSession == null) return null;

    _tickerTimer?.cancel();
    _syncTimer?.cancel();

    // Flush any pending queue
    await syncQueuedIncrements();

    state = state.copyWith(isLoading: true);

    final uuid = _generateUuid();
    final timeStr = DateTime.now().toUtc().toIso8601String().replaceAll('T', ' ').substring(0, 19);

    final result = await _repository.endSession(
      sessionId: state.activeSession!.id,
      eventUuid: uuid,
      finalCount: state.currentCount,
      timestamp: timeStr,
    );

    if (result is ApiSuccess<TasbihSessionModel>) {
      final completedSession = result.data;
      state = state.copyWith(
        isLoading: false,
        clearActiveSession: true,
        currentCount: 0,
        activeDurationSeconds: 0,
      );
      // Refresh history & analytics on background
      fetchHistory(refresh: true);
      fetchAnalytics();
      return completedSession;
    } else {
      state = state.copyWith(isLoading: false);
      return null;
    }
  }

  /// Change active session display mode.
  void setMode(String mode) {
    state = state.copyWith(mode: mode);
  }

  /// Sync queued tap events.
  Future<void> syncQueuedIncrements() async {
    if (state.activeSession == null || state.unsyncedIncrements.isEmpty || state.isSyncing) {
      return;
    }

    final logsToSync = List<TasbihSessionLogModel>.from(state.unsyncedIncrements);
    state = state.copyWith(
      isSyncing: true,
      unsyncedIncrements: [], // temporarily clear list to hold updates
    );

    final result = await _repository.syncIncrements(
      sessionId: state.activeSession!.id,
      increments: logsToSync,
    );

    if (result is ApiSuccess<Map<String, dynamic>>) {
      state = state.copyWith(isSyncing: false);
    } else {
      // Re-append to queue if offline or failed
      state = state.copyWith(
        isSyncing: false,
        unsyncedIncrements: [...logsToSync, ...state.unsyncedIncrements],
      );
    }
  }

  /// Fetch history items.
  Future<void> fetchHistory({bool refresh = false}) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getHistory();
    if (result is ApiSuccess<List<TasbihSessionModel>>) {
      state = state.copyWith(
        isLoading: false,
        history: result.data,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Fetch analytics statistics.
  Future<void> fetchAnalytics() async {
    final result = await _repository.getAnalytics();
    if (result is ApiSuccess<TasbihSessionAnalyticsModel>) {
      state = state.copyWith(analytics: result.data);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _startTicker() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPaused && state.activeSession != null) {
        state = state.copyWith(
          activeDurationSeconds: state.activeDurationSeconds + 1,
        );
      }
    });
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      syncQueuedIncrements();
    });
  }

  String _generateUuid() {
    final random = Random();
    final hex = List.generate(16, (i) => random.nextInt(16).toRadixString(16)).join();
    final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
    return '$timestamp-$hex';
  }
}

final tasbihSessionProvider =
    StateNotifierProvider<TasbihSessionNotifier, TasbihSessionState>((ref) {
  final repo = ref.watch(tasbihSessionRepositoryProvider);
  return TasbihSessionNotifier(repo);
});
