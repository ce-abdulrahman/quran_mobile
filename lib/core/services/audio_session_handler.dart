import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class AudioSessionHandler {
  final VoidCallback onPause;
  final VoidCallback onResume;
  StreamSubscription? _interruptionSubscription;
  StreamSubscription? _becomingNoisySubscription;
  bool _initialized = false;

  AudioSessionHandler({
    required this.onPause,
    required this.onResume,
  });

  Future<void> initialize() async {
    if (kIsWeb) return;
    if (_initialized) return;

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      // Listen to audio interruptions (phone calls, notifications, etc.)
      _interruptionSubscription = session.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              onPause();
              break;
            case AudioInterruptionType.duck:
              // Policy: continue playback (ducking handles volume automatically)
              break;
          }
        } else {
          // Interruption ended
          if (event.type == AudioInterruptionType.pause) {
            onResume();
          }
        }
      });

      // Listen to headphone unplugging (becoming noisy)
      _becomingNoisySubscription = session.becomingNoisyEventStream.listen((_) {
        // Policy: pause playback on headphone unplug
        onPause();
      });

      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing AudioSessionHandler: $e');
    }
  }

  Future<bool> requestFocus() async {
    if (kIsWeb) return true;
    try {
      final session = await AudioSession.instance;
      return await session.setActive(true);
    } catch (e) {
      debugPrint('Error requesting audio focus: $e');
      return false;
    }
  }

  Future<void> abandonFocus() async {
    if (kIsWeb) return;
    try {
      final session = await AudioSession.instance;
      await session.setActive(false);
    } catch (e) {
      debugPrint('Error abandoning audio focus: $e');
    }
  }

  void dispose() {
    _interruptionSubscription?.cancel();
    _becomingNoisySubscription?.cancel();
  }
}
