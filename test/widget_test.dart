import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_app/main.dart';
import 'package:quran_app/core/providers/app_providers.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Animate.isWidgetTest = true;

    // Mock SharedPreferences initial values
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefsProvider.overrideWithValue(prefs),
        ],
        child: const QuranApp(),
      ),
    );

    // Settle the 2.5 second splash delay and transition animation
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
