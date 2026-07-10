import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../interfaces/mushaf_asset_provider.dart';
import '../interfaces/coordinate_provider.dart';
import '../interfaces/page_geometry_provider.dart';

class WebAssetProvider implements MushafAssetProvider {
  final PageGeometryProvider geometryProvider;

  const WebAssetProvider({
    required this.geometryProvider,
  });

  @override
  Future<MushafPageAsset> getPageAsset(int pageNumber) async {
    final dimensions = geometryProvider.getBaseDimensions(pageNumber);

    return MushafPageAsset(
      pageNumber: pageNumber,
      imageProvider: const NetworkImage(''),
      dimensions: dimensions,
      type: MushafAssetType.vector,
      localFile: null,
    );
  }

  @override
  void prefetchPages(List<int> pageNumbers) {}
}

class WebCoordinateAdapter implements CoordinateProvider {
  const WebCoordinateAdapter();

  @override
  Future<PageCoordinates> getCoordinates(int pageNumber) async {
    final pageStr = pageNumber.toString().padLeft(3, '0');
    final jsonString = await rootBundle.loadString('assets/quran/json/$pageStr.json');
    final decoded = jsonDecode(jsonString) as List<dynamic>;

    final ayahs = decoded.map((x) {
      final jsonMap = x as Map<String, dynamic>;
      final surahNum = jsonMap['surahNumber'] as int? ?? 0;
      final ayahNum = jsonMap['ayahNumber'] as int? ?? 0;
      final xVal = (jsonMap['x'] as num? ?? 0.0).toDouble();
      final yVal = (jsonMap['y'] as num? ?? 0.0).toDouble();
      final polyStr = jsonMap['polygon'] as String? ?? '';
      final path = _parsePolygonPath(polyStr);

      return AyahCoordinate(
        surahNumber: surahNum,
        ayahNumber: ayahNum,
        x: xVal,
        y: yVal,
        polygonString: polyStr,
        path: path,
      );
    }).toList();

    return PageCoordinates(
      pageNumber: pageNumber,
      ayahs: ayahs,
    );
  }

  static Path _parsePolygonPath(String polyStr) {
    final path = Path();
    final s = polyStr.trim();
    if (s.isEmpty) return path;

    final regExp = RegExp(r'([MLZmlz])|(-?\d*\.?\d+)');
    final matches = regExp.allMatches(s).map((m) => m.group(0)!).toList();

    int i = 0;
    while (i < matches.length) {
      final token = matches[i];
      if (token == 'M' || token == 'm') {
        if (i + 2 < matches.length) {
          final x = double.tryParse(matches[i + 1]) ?? 0.0;
          final y = double.tryParse(matches[i + 2]) ?? 0.0;
          path.moveTo(x, y);
          i += 3;
        } else {
          i++;
        }
      } else if (token == 'L' || token == 'l') {
        if (i + 2 < matches.length) {
          final x = double.tryParse(matches[i + 1]) ?? 0.0;
          final y = double.tryParse(matches[i + 2]) ?? 0.0;
          path.lineTo(x, y);
          i += 3;
        } else {
          i++;
        }
      } else if (token == 'Z' || token == 'z') {
        path.close();
        i += 1;
      } else {
        if (i == 0) {
          final points = s.split(RegExp(r'\s+'));
          bool isFirst = true;
          for (final pt in points) {
            final coords = pt.split(',');
            if (coords.length == 2) {
              final x = double.tryParse(coords[0]) ?? 0.0;
              final y = double.tryParse(coords[1]) ?? 0.0;
              if (isFirst) {
                path.moveTo(x, y);
                isFirst = false;
              } else {
                path.lineTo(x, y);
              }
            }
          }
          path.close();
          break;
        }
        i++;
      }
    }
    return path;
  }
}
