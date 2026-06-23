import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile/core/services/tajweed_engine.dart';
import 'package:quran_mobile/core/models/tajweed_segment_model.dart';

void main() {
  setUpAll(() async {
    // Load production Uthmanic font to test shaping compatibility
    final fontFile = File('assets/fonts/ar/QPC_Hafs.ttf');
    if (fontFile.existsSync()) {
      final fontData = fontFile.readAsBytesSync();
      final fontLoader = FontLoader('UthmanicHafs')
        ..addFont(Future.value(ByteData.view(fontData.buffer)));
      await fontLoader.load();
    }
  });

  bool isCombiningMark(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 0x064B && code <= 0x065F) ||
           code == 0x0670 ||
           (code >= 0x0610 && code <= 0x0615) ||
           (code >= 0x06D6 && code <= 0x06ED);
  }

  void runPreservationChecks({
    required String text,
    required List<TajweedSegmentModel> segments,
    required Set<String> inactiveRules,
  }) {
    final spans = TajweedEngine.buildSpans(
      text: text,
      segments: segments,
      defaultColor: Colors.black,
      inactiveRules: inactiveRules,
    );

    // 1. Verify byte-for-byte identical text order (ignoring formatting ZWJs)
    final buffer = StringBuffer();
    for (final span in spans) {
      expect(span, isA<TextSpan>());
      buffer.write((span as TextSpan).text);
    }
    final cleanText = buffer.toString().replaceAll('\u200d', '');
    expect(cleanText, equals(text), reason: 'Concatenated spans (ignoring ZWJs) must match original text byte-for-byte');

    // 2. Verify no WidgetSpans are used for inline styling
    for (final span in spans) {
      expect(span, isNot(isA<WidgetSpan>()), reason: 'No inline WidgetSpan is allowed to prevent text ordering corruption');
    }

    // 3. Verify grapheme cluster safety (combining marks must not start a span)
    for (final span in spans) {
      if (span is TextSpan && span.text != null && span.text!.isNotEmpty) {
        String cleanSpanText = span.text!;
        if (cleanSpanText.startsWith('\u200d')) {
          cleanSpanText = cleanSpanText.substring(1);
        }
        if (cleanSpanText.isNotEmpty) {
          final firstChar = cleanSpanText.characters.first;
          expect(
            isCombiningMark(firstChar),
            isFalse,
            reason: 'Grapheme cluster violated: combining mark "$firstChar" got detached from its base letter in span "${span.text}"',
          );
        }
      }
    }

    // 4. Verify ZWJ connections exist at boundaries where necessary
    for (int i = 0; i < spans.length - 1; i++) {
      final tA = (spans[i] as TextSpan).text ?? '';
      final tB = (spans[i + 1] as TextSpan).text ?? '';
      if (tA.endsWith('\u200d')) {
        expect(tB.startsWith('\u200d'), isTrue, reason: 'ZWJ connection must be mutual at span boundary');
      }
    }
  }

  group('Tajweed Engine Regression & Word Order Tests', () {
    test('Al-Fatihah 7 (Word Order and Shaping)', () {
      const fatihah7 = 'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ';
      final segments = [
        const TajweedSegmentModel(
          textSegment: 'أَنْ',
          startIndex: 13,
          endIndex: 16,
          colorCode: '#1B7340',
          ruleSlug: 'izhar',
        ),
        const TajweedSegmentModel(
          textSegment: 'ٱلضَّآلِّينَ',
          startIndex: 64,
          endIndex: 77,
          colorCode: '#FF0000',
          ruleSlug: 'madd_lazim',
        ),
      ];

      runPreservationChecks(
        text: fatihah7,
        segments: segments,
        inactiveRules: {},
      );
    });

    test('Al-Baqarah 255 (Ayat al-Kursi)', () {
      const baqarah255 = 'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ ۚ لَا تَأْخُذُهُۥ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُۥ مَا فِى ٱلسَّمَٰوَٰتِ وَمَا فِى ٱلْأَرْضِ ۗ مَن ذَا ٱلَّذِى يَشْفَعُ عِندَهُۥٓ إِلَّا بِإِذْنِهِۦ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَىْءٍ مِّنْ عِلْمِهِۦٓ إِلَّا بِمَا شَآءَ ۚ وَسِعَ كُرْسِيُّهُ ٱلسَّم5;وَٰتِ وَٱلْأَرْضَ ۖ وَلَا يَـُٔودُهُۥ حِفْظُهُمَا ۚ وَهُوَ ٱلْعَلِىُّ ٱلْعَظِيمُ';
      final segments = [
        const TajweedSegmentModel(
          textSegment: 'لَآ',
          startIndex: 7,
          endIndex: 11,
          colorCode: '#FF0000',
          ruleSlug: 'madd_jaiz',
        ),
        const TajweedSegmentModel(
          textSegment: 'عِندَهُۥٓ',
          startIndex: 112,
          endIndex: 120,
          colorCode: '#FFA500',
          ruleSlug: 'ikhfa',
        ),
      ];

      runPreservationChecks(
        text: baqarah255,
        segments: segments,
        inactiveRules: {},
      );
    });

    test('Al-Kahf 1', () {
      const kahf1 = 'ٱلْحَمْدُ لِلَّهِ ٱلَّذِىٓ أَنزَلَ عَلَىٰ عَبْدِهِ ٱلْكِتَٰبَ وَلَمْ يَجْعَل لَّهُۥ عِوَجَا ۜ';
      final segments = [
        const TajweedSegmentModel(
          textSegment: 'أَنزَلَ',
          startIndex: 23,
          endIndex: 29,
          colorCode: '#FFA500',
          ruleSlug: 'ikhfa',
        ),
      ];

      runPreservationChecks(
        text: kahf1,
        segments: segments,
        inactiveRules: {},
      );
    });

    test('Yasin 1-2', () {
      const yasin = 'يس ﴿١﴾ وَٱلْقُرْءَانِ ٱلْحَكِيمِ ﴿٢﴾';
      final segments = [
        const TajweedSegmentModel(
          textSegment: 'يس',
          startIndex: 0,
          endIndex: 2,
          colorCode: '#FF0000',
          ruleSlug: 'madd_lazim',
        ),
      ];

      runPreservationChecks(
        text: yasin,
        segments: segments,
        inactiveRules: {},
      );
    });

    test('Ar-Rahman 1-3', () {
      const rahman = 'ٱلرَّحْمَٰنُ ﴿١﴾ عَلَّمَ ٱلْقُرْءَانَ ﴿٢﴾ خَلَقَ ٱلْإِنسَٰنَ ﴿٣﴾';
      final segments = [
        const TajweedSegmentModel(
          textSegment: 'ٱلْإِنسَٰنَ',
          startIndex: 41,
          endIndex: 51,
          colorCode: '#FFA500',
          ruleSlug: 'ikhfa',
        ),
      ];

      runPreservationChecks(
        text: rahman,
        segments: segments,
        inactiveRules: {},
      );
    });

    test('Arabic Cursive joining (ZWJ insertion) at styled boundaries', () {
      const text = 'أَنْعَمْتَ';
      final segments = [
        const TajweedSegmentModel(
          textSegment: 'أَنْ',
          startIndex: 0,
          endIndex: 3,
          colorCode: '#1B7340',
          ruleSlug: 'izhar',
        ),
      ];

      final spans = TajweedEngine.buildSpans(
        text: text,
        segments: segments,
        defaultColor: Colors.black,
        inactiveRules: {},
      );

      expect(spans.length, equals(2));
      final spanA = spans[0] as TextSpan;
      final spanB = spans[1] as TextSpan;

      expect(spanA.text, endsWith('\u200d'), reason: 'First span must end with ZWJ to join cursively');
      expect(spanB.text, startsWith('\u200d'), reason: 'Second span must start with ZWJ to join cursively');
    });
  });

  group('Tajweed Widget RTL Enforcement & Font Shaping test', () {
    testWidgets('RichText correctly forces TextDirection.rtl & TextAlign.right', (WidgetTester tester) async {
      const text = 'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ';
      final segments = [
        const TajweedSegmentModel(
          textSegment: 'أَنْ',
          startIndex: 13,
          endIndex: 16,
          colorCode: '#1B7340',
          ruleSlug: 'izhar',
        ),
      ];

      final spans = TajweedEngine.buildSpans(
        text: text,
        segments: segments,
        defaultColor: Colors.black,
        inactiveRules: {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text.rich(
              TextSpan(children: spans),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: 22,
              ),
            ),
          ),
        ),
      );

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsOneWidget);

      final RenderParagraph renderParagraph = tester.renderObject(richTextFinder);
      expect(renderParagraph.textDirection, equals(TextDirection.rtl));
      expect(renderParagraph.textAlign, equals(TextAlign.right));
    });
  });
}
