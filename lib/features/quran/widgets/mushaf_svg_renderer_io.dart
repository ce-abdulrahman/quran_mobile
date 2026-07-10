import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildMushafSvg(dynamic localFile, String pageStr, BoxFit fit) {
  if (localFile is File) {
    return SvgPicture.file(
      localFile,
      fit: fit,
    );
  }
  return SvgPicture.asset(
    'assets/quran/svg/$pageStr.svg',
    fit: fit,
  );
}
