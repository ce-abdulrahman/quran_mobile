import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Web stub: renders SVG from bundled assets (no dart:io File access)
Widget buildMushafSvg(dynamic localFile, String pageStr, BoxFit fit) {
  return SvgPicture.asset(
    'assets/quran/svg/$pageStr.svg',
    fit: fit,
  );
}
