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

    // 1. Group contiguous character clusters (graphemes)
    final graphemes = text.characters;
    final List<Color> clusterColors = [];
    final List<bool> clusterBold = [];
    final List<String> clusterTexts = [];

    final sorted = List<TajweedSegmentModel>.from(segments)
      ..sort((a, b) => (a.startIndex ?? 0).compareTo(b.startIndex ?? 0));

    int currentOffset = 0;
    for (final grapheme in graphemes) {
      final len = grapheme.length;
      final start = currentOffset;
      final end = currentOffset + len;
      currentOffset = end;

      Color selectedColor = defaultColor;
      bool selectedBold = false;

      for (final seg in sorted) {
        final segStart = seg.startIndex;
        final segEnd = seg.endIndex;
        if (segStart == null || segEnd == null || segStart < 0 || segEnd > text.length || segStart >= segEnd) continue;

        final isActive = seg.ruleId != null
            ? !inactiveRules.contains(seg.ruleId)
            : (seg.ruleSlug == null || !inactiveRules.contains(seg.ruleSlug));
        if (!isActive) continue;

        // Overlap: cluster [start, end) and segment [segStart, segEnd)
        if (start < segEnd && end > segStart) {
          selectedColor = (seg.colorId != null && ruleColors.containsKey(seg.colorId))
              ? ruleColors[seg.colorId]!
              : _parseColor(seg.colorCode, defaultColor);
          selectedBold = true;
          break; // Color with the first overlapping segment rule
        }
      }

      clusterColors.add(selectedColor);
      clusterBold.add(selectedBold);
      clusterTexts.add(grapheme);
    }

    if (clusterTexts.isEmpty) return [];

    // 2. Build temporary groups of contiguous clusters
    final List<List<String>> groups = [];
    final List<Color> groupColors = [];
    final List<bool> groupBold = [];

    int startIdx = 0;
    Color currentColor = clusterColors[0];
    bool currentBold = clusterBold[0];

    for (int i = 1; i < clusterTexts.length; i++) {
      if (clusterColors[i] != currentColor || clusterBold[i] != currentBold) {
        groups.add(clusterTexts.sublist(startIdx, i));
        groupColors.add(currentColor);
        groupBold.add(currentBold);

        startIdx = i;
        currentColor = clusterColors[i];
        currentBold = clusterBold[i];
      }
    }
    groups.add(clusterTexts.sublist(startIdx));
    groupColors.add(currentColor);
    groupBold.add(currentBold);

    // 3. Precomputed ZWJ insertion at boundaries between groups
    final List<String> groupStrings = groups.map((g) => g.join()).toList();

    int boundaryIndex = 0;
    for (int i = 0; i < groupStrings.length - 1; i++) {
      boundaryIndex += groupStrings[i].length;

      final prevChar = text.substring(boundaryIndex - 1, boundaryIndex);
      final nextChar = text.substring(boundaryIndex, boundaryIndex + 1);

      if (_connectsToLeft(prevChar) && _connectsToRight(nextChar)) {
        groupStrings[i] = '${groupStrings[i]}\u200d';
        groupStrings[i + 1] = '\u200d${groupStrings[i + 1]}';
      }
    }

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
      0x062F, 0x0630, 0x0688, 0x0689, 0x068A, 0x068B, 0x068C, 0x068D, 0x068E, 0x068F, 0x0690, // Dals
      0x0631, 0x0632, 0x0691, 0x0692, 0x0693, 0x0694, 0x0695, 0x0696, 0x0697, 0x0698, 0x0699, // Ras
      0x0648, 0x0676, 0x0677, 0x06C4, 0x06C5, 0x06C6, 0x06C7, 0x06C8, 0x06C9, 0x06CA, 0x06CB, 0x06CF, // Waws
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
