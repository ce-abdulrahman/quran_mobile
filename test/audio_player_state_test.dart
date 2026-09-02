import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/features/quran/providers/audio_player_provider.dart';

void main() {
  group('AudioPlayerState.copyWith', () {
    const base = AudioPlayerState(selectedReciterId: 1);

    test('omitting a nullable field keeps its current value', () {
      final withError = base.copyWith(
        errorMessage: 'no audio',
        currentAyahNumber: 12,
        streamUrl: 'https://example.com/1.mp3',
      );

      final unrelatedChange = withError.copyWith(isLoading: true);

      expect(unrelatedChange.errorMessage, 'no audio');
      expect(unrelatedChange.currentAyahNumber, 12);
      expect(unrelatedChange.streamUrl, 'https://example.com/1.mp3');
    });

    test('passing null clears a nullable field', () {
      // Regression: `errorMessage ?? this.errorMessage` silently ignored an
      // explicit null, so a single playback failure left the error set forever
      // and the play button stayed hidden until the app restarted.
      final withError = base.copyWith(
        errorMessage: 'no audio',
        currentAyahNumber: 12,
        streamUrl: 'https://example.com/1.mp3',
      );

      final cleared = withError.copyWith(
        errorMessage: null,
        currentAyahNumber: null,
        streamUrl: null,
      );

      expect(cleared.errorMessage, isNull);
      expect(cleared.currentAyahNumber, isNull);
      expect(cleared.streamUrl, isNull);
    });

    test('non-nullable fields are unaffected by the sentinel', () {
      final changed = base.copyWith(isPlaying: true, speed: 1.5);

      expect(changed.isPlaying, isTrue);
      expect(changed.speed, 1.5);
      expect(changed.selectedReciterId, 1);
      expect(changed.isAutoScrollEnabled, isTrue);
    });

    test('the reported failure path recovers: error set, then cleared', () {
      // 1. Playback fails (offline).
      final failed = base.copyWith(
        isLoading: false,
        streamUrl: null,
        errorMessage: 'فایلی دەنگی یان کاتەکان بەردەست نییە',
      );
      expect(failed.errorMessage, isNotNull);

      // 2. User retries once back online — loadSurah resets the state.
      final retrying = failed.copyWith(
        isLoading: true,
        errorMessage: null,
        currentAyahNumber: null,
      );

      // The play button is gated on errorMessage == null.
      expect(retrying.errorMessage, isNull);
    });
  });
}
