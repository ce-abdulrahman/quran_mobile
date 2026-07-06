import 'package:flutter/material.dart';
import '../models/tajweed_segment_model.dart';

class TajweedSpanCache {
  static final Map<String, List<InlineSpan>> _cache = {};

  static List<InlineSpan> getOrBuild({
    required int ayahId,
    required String text,
    required List<TajweedSegmentModel> segments,
    required Color defaultColor,
    required Set<dynamic> inactiveRules,
    required Map<int, Color> ruleColors,
    required String fontFamily,
    required double fontSize,
  }) {
    final key = '$ayahId-$fontFamily-$fontSize-${defaultColor.value}-${inactiveRules.join(',')}';
    return _cache.putIfAbsent(key, () {
      return TajweedEngine.buildSpans(
        text: text,
        segments: segments,
        defaultColor: defaultColor,
        inactiveRules: inactiveRules,
        ruleColors: ruleColors,
      );
    });
  }

  static void clear() {
    _cache.clear();
  }
}

class TajweedEngine {
  static const Map<int, String> _ruleIdToSlug = {
    1: 'idhhar-halqi',
    2: 'idgham-halqi',
    3: 'iqlab',
    4: 'ikhfa-haqiqi',
    5: 'words-with-idgham',
    6: 'ikhfa-shafawi',
    7: 'idgham-shafawi',
    8: 'idhhar-shafawi',
    9: 'madd-tabii',
    10: 'madd-muttasil',
    11: 'madd-munfasil',
    12: 'madd-badal',
    13: 'madd-aridh',
    14: 'madd-leen',
    15: 'madd-lazim-kalimi-muthaqqal',
    16: 'madd-lazim-kalimi-mukhaffaf',
    17: 'madd-lazim-harfi-muthaqqal',
    18: 'madd-lazim-harfi-mukhaffaf',
    19: 'madd-silah-kubra',
    20: 'madd-silah-sughra',
    21: 'madd-iwad',
    22: 'raa-tafkhim',
    23: 'raa-tarqiq',
    24: 'raa-jawaz',
    25: 'qalqalah-kubra',
    26: 'qalqalah-sughra',
    27: 'ghunnah-mushaddadah',
    28: 'laam-tafkhim',
    29: 'laam-tarqiq',
    30: 'idhhar-qamari',
    31: 'idgham-shamsi',
    32: 'idgham-mutamathilayn',
    33: 'idgham-mutajanisayn',
    34: 'idgham-mutaqaribayn',
    35: 'saktah',
    36: 'silent-letters',
  };

  static List<InlineSpan> buildSpans({
    required String text,
    required List<TajweedSegmentModel> segments,
    required Color defaultColor,
    required Set<dynamic> inactiveRules,
    Map<int, Color> ruleColors = const {},
  }) {
    if (segments.isEmpty) {
      return [TextSpan(text: text, style: TextStyle(color: defaultColor))];
    }

    // 1. Walk the text grapheme-by-grapheme, tracking both UTF-16 offset and
    //    grapheme index. Segment startIndex/endIndex refer to UTF-16 code units.
    final graphemes = text.characters.toList();
    final int totalGraphemes = graphemes.length;

    if (totalGraphemes == 0) {
      return [TextSpan(text: text, style: TextStyle(color: defaultColor))];
    }

    // Build a lookup: grapheme[i] occupies UTF-16 range [utf16Start[i], utf16End[i])
    final List<int> utf16Start = List.filled(totalGraphemes, 0);
    final List<int> utf16End = List.filled(totalGraphemes, 0);
    int offset = 0;
    for (int i = 0; i < totalGraphemes; i++) {
      utf16Start[i] = offset;
      offset += graphemes[i].length; // .length on a single grapheme = UTF-16 units
      utf16End[i] = offset;
    }
    // Guard: offset must equal text.length
    assert(offset == text.length,
        'Grapheme offset mismatch: $offset vs ${text.length}');

    final sorted = List<TajweedSegmentModel>.from(segments)
      ..sort((a, b) => (a.startIndex ?? 0).compareTo(b.startIndex ?? 0));

    // 2. Assign a color to each grapheme
    final List<Color> clusterColors = List.filled(totalGraphemes, defaultColor);
    final List<bool> clusterBold = List.filled(totalGraphemes, false);

    for (int i = 0; i < totalGraphemes; i++) {
      final gStart = utf16Start[i];
      final gEnd = utf16End[i];

      for (final seg in sorted) {
        final segStart = seg.startIndex;
        final segEnd = seg.endIndex;

        if (segStart == null ||
            segEnd == null ||
            segStart < 0 ||
            segEnd > text.length ||
            segStart >= segEnd) {
          continue;
        }

        final slug = seg.ruleSlug ?? (seg.ruleId != null ? _ruleIdToSlug[seg.ruleId] : null);
        final isActive = slug != null
            ? !inactiveRules.contains(slug)
            : (seg.ruleId == null || !inactiveRules.contains(seg.ruleId.toString()));
        if (!isActive) {
          continue;
        }

        // Overlap: grapheme [gStart, gEnd) ∩ segment [segStart, segEnd)
        if (gStart < segEnd && gEnd > segStart) {
          clusterColors[i] = (seg.colorId != null &&
                  ruleColors.containsKey(seg.colorId))
              ? ruleColors[seg.colorId]!
              : _parseColor(seg.colorCode, defaultColor);
          clusterBold[i] = true;
          break;
        }
      }
    }

    // 3. Group contiguous graphemes that share the same color+bold
    final List<StringBuffer> groups = [];
    final List<Color> groupColors = [];
    final List<bool> groupBold = [];

    // Track grapheme-boundary UTF-16 positions for ZWJ detection
    // boundaryUtf16[k] = UTF-16 index of the START of group k+1 (= end of group k)
    final List<int> groupBoundaryUtf16 = [];

    StringBuffer current = StringBuffer(graphemes[0]);
    Color currentColor = clusterColors[0];
    bool currentBoldVal = clusterBold[0];

    for (int i = 1; i < totalGraphemes; i++) {
      if (clusterColors[i] != currentColor || clusterBold[i] != currentBoldVal) {
        groups.add(current);
        groupColors.add(currentColor);
        groupBold.add(currentBoldVal);
        groupBoundaryUtf16.add(utf16Start[i]); // UTF-16 start of next group

        current = StringBuffer(graphemes[i]);
        currentColor = clusterColors[i];
        currentBoldVal = clusterBold[i];
      } else {
        current.write(graphemes[i]);
      }
    }
    groups.add(current);
    groupColors.add(currentColor);
    groupBold.add(currentBoldVal);

    // 4. ZWJ insertion at color-group boundaries where Arabic letters connect
    //    Use grapheme-safe boundary positions (groupBoundaryUtf16) for lookups.
    final List<String> groupStrings = groups.map((b) => b.toString()).toList();

    for (int i = 0; i < groupBoundaryUtf16.length; i++) {
      final boundary = groupBoundaryUtf16[i];

      // boundary is the UTF-16 position between group i and group i+1
      // prevChar = last UTF-16 unit before boundary
      // nextChar = first UTF-16 unit at boundary
      if (boundary <= 0 || boundary >= text.length) continue;

      final prevChar = text[boundary - 1]; // single UTF-16 code unit
      final nextChar = text[boundary];     // single UTF-16 code unit

      if (_connectsToLeft(prevChar) && _connectsToRight(nextChar)) {
        groupStrings[i] = '${groupStrings[i]}\u200d';
        groupStrings[i + 1] = '\u200d${groupStrings[i + 1]}';
      }
    }

    // 5. Build InlineSpan list
    final List<InlineSpan> result = [];
    for (int i = 0; i < groupStrings.length; i++) {
      result.add(TextSpan(
        text: groupStrings[i],
        style: TextStyle(
          color: groupColors[i],
          fontWeight: groupBold[i] ? FontWeight.bold : null,
        ),
      ));
    }

    return result;
  }

  static bool _connectsToLeft(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    if (code < 0x0600 || code > 0x06FF) return false;

    const rightOnly = [
      0x0621, // Hamza
      0x0622, 0x0623, 0x0625, 0x0627, 0x0671, 0x0672, 0x0673, 0x0675, // Alifs
      0x062F, 0x0630, 0x0688, 0x0689, 0x068A, 0x068B, 0x068C, 0x068D,
      0x068E, 0x068F, 0x0690, // Dals
      0x0631, 0x0632, 0x0691, 0x0692, 0x0693, 0x0694, 0x0695, 0x0696,
      0x0697, 0x0698, 0x0699, // Ras
      0x0648, 0x0676, 0x0677, 0x06C4, 0x06C5, 0x06C6, 0x06C7, 0x06C8,
      0x06C9, 0x06CA, 0x06CB, 0x06CF, // Waws
      0x0629, 0x06C0, 0x06C2 // Teh Marbuta
    ];
    return !rightOnly.contains(code);
  }

  static bool _connectsToRight(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    if (code < 0x0600 || code > 0x06FF) return false;
    if (code == 0x0621) return false; // Hamza
    return true;
  }

  static Color _parseColor(String? hexString, Color defaultColor) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF1B7340);
    final cleaned = hexString.replaceFirst('#', '').toLowerCase();
    if (cleaned == '000000' || cleaned == 'ffffff') {
      return defaultColor;
    }
    try {
      final buffer = StringBuffer();
      if (cleaned.length == 6) buffer.write('ff');
      buffer.write(cleaned);
      final parsed = Color(int.parse(buffer.toString(), radix: 16));
      if (parsed == const Color(0xFF000000) || parsed == const Color(0xFFFFFFFF)) {
        return defaultColor;
      }
      return parsed;
    } catch (_) {
      return const Color(0xFF1B7340);
    }
  }
}
