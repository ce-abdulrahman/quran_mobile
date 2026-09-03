import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/providers/adhkar_provider.dart';
import 'package:quran_mobile/core/providers/dhikr_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late AdhkarNotifier notifier;

  Future<void> build([Map<String, Object> initial = const {}]) async {
    SharedPreferences.setMockInitialValues(initial);
    prefs = await SharedPreferences.getInstance();
    notifier = AdhkarNotifier(prefs);
  }

  setUp(() async => build());

  group('session progress', () {
    test('starts empty', () {
      expect(notifier.progressFor('morning').isEmpty, isTrue);
    });

    test('round-trips an in-progress run', () async {
      await notifier.saveProgress('morning', itemIndex: 2, count: 17);

      final saved = notifier.progressFor('morning');
      expect(saved.itemIndex, 2);
      expect(saved.count, 17);
      expect(saved.isEmpty, isFalse);
    });

    test('survives a fresh notifier, which is the whole point', () async {
      // Leaving the screen mid-dhikr used to discard the count entirely.
      await notifier.saveProgress('morning', itemIndex: 3, count: 42);

      final reopened = AdhkarNotifier(prefs);
      final saved = reopened.progressFor('morning');

      expect(saved.itemIndex, 3);
      expect(saved.count, 42);
    });

    test('keeps categories apart', () async {
      await notifier.saveProgress('morning', itemIndex: 1, count: 5);
      await notifier.saveProgress('evening', itemIndex: 4, count: 90);

      expect(notifier.progressFor('morning').count, 5);
      expect(notifier.progressFor('evening').count, 90);
      expect(notifier.progressFor('sleep').isEmpty, isTrue);
    });
  });

  group('daily expiry', () {
    test('ignores progress saved on an earlier day', () async {
      // Morning and evening adhkar are daily; yesterday's half-finished run
      // must not be offered as something to continue.
      await build({
        'adhkar_session_progress': jsonEncode({
          'morning': {'date': '2020-01-01', 'index': 2, 'count': 30},
        }),
      });

      expect(notifier.progressFor('morning').isEmpty, isTrue);
    });

    test('keeps progress saved today', () async {
      await build({
        'adhkar_session_progress': jsonEncode({
          'morning': {'date': dhikrDayKey(), 'index': 2, 'count': 30},
        }),
      });

      expect(notifier.progressFor('morning').count, 30);
    });
  });

  group('clearing', () {
    test('completing a category drops its progress', () async {
      await notifier.saveProgress('morning', itemIndex: 4, count: 99);
      await notifier.completeCategory('morning');

      expect(notifier.progressFor('morning').isEmpty, isTrue);
      expect(notifier.isCompletedToday('morning'), isTrue);
    });

    test('resetting a category drops its progress', () async {
      await notifier.saveProgress('morning', itemIndex: 4, count: 99);
      await notifier.completeCategory('morning');
      await notifier.resetCategory('morning');

      expect(notifier.progressFor('morning').isEmpty, isTrue);
      expect(notifier.isCompletedToday('morning'), isFalse);
    });

    test('clearing one category leaves the others alone', () async {
      await notifier.saveProgress('morning', itemIndex: 1, count: 5);
      await notifier.saveProgress('evening', itemIndex: 2, count: 10);

      await notifier.clearProgress('morning');

      expect(notifier.progressFor('morning').isEmpty, isTrue);
      expect(notifier.progressFor('evening').count, 10);
    });
  });

  group('corrupt or unexpected stored data', () {
    test('unparseable JSON reads as no progress', () async {
      await build({'adhkar_session_progress': 'not json at all'});
      expect(notifier.progressFor('morning').isEmpty, isTrue);
    });

    test('an entry of the wrong shape reads as no progress', () async {
      await build({
        'adhkar_session_progress': jsonEncode({'morning': 'unexpected'}),
      });
      expect(notifier.progressFor('morning').isEmpty, isTrue);
    });

    test('missing fields fall back to zero rather than throwing', () async {
      await build({
        'adhkar_session_progress': jsonEncode({
          'morning': {'date': dhikrDayKey()},
        }),
      });

      final saved = notifier.progressFor('morning');
      expect(saved.itemIndex, 0);
      expect(saved.count, 0);
    });
  });
}
