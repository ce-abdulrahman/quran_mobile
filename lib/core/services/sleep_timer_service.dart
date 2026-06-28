import 'dart:async';
import 'package:flutter/foundation.dart';

enum SleepTimerMode {
  none,
  durationBased,
  surahEnd,
}

class SleepTimerState {
  final SleepTimerMode mode;
  final int remainingSeconds;
  final bool isActive;

  const SleepTimerState({
    this.mode = SleepTimerMode.none,
    this.remainingSeconds = 0,
    this.isActive = false,
  });

  SleepTimerState copyWith({
    SleepTimerMode? mode,
    int? remainingSeconds,
    bool? isActive,
  }) {
    return SleepTimerState(
      mode: mode ?? this.mode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'remainingSeconds': remainingSeconds,
      'isActive': isActive,
    };
  }

  factory SleepTimerState.fromJson(Map<String, dynamic> json) {
    return SleepTimerState(
      mode: SleepTimerMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => SleepTimerMode.none,
      ),
      remainingSeconds: json['remainingSeconds'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

class SleepTimerService {
  final VoidCallback onTimerExpired;
  Timer? _timer;
  SleepTimerState _state = const SleepTimerState();
  final _stateController = StreamController<SleepTimerState>.broadcast();

  SleepTimerService({required this.onTimerExpired}) {
    _stateController.add(_state);
  }

  Stream<SleepTimerState> get stateStream => _stateController.stream;
  SleepTimerState get state => _state;

  void startDurationTimer(int minutes) {
    _timer?.cancel();
    final totalSeconds = minutes * 60;
    _state = SleepTimerState(
      mode: SleepTimerMode.durationBased,
      remainingSeconds: totalSeconds,
      isActive: true,
    );
    _stateController.add(_state);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.remainingSeconds <= 1) {
        cancel();
        onTimerExpired();
      } else {
        _state = _state.copyWith(remainingSeconds: _state.remainingSeconds - 1);
        _stateController.add(_state);
      }
    });
  }

  void startSurahEndTimer() {
    _timer?.cancel();
    _state = const SleepTimerState(
      mode: SleepTimerMode.surahEnd,
      remainingSeconds: 0,
      isActive: true,
    );
    _stateController.add(_state);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _state = const SleepTimerState();
    _stateController.add(_state);
  }

  void handleSurahCompleted() {
    if (_state.mode == SleepTimerMode.surahEnd && _state.isActive) {
      cancel();
      onTimerExpired();
    }
  }

  void dispose() {
    _timer?.cancel();
    _stateController.close();
  }
}
