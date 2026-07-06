import 'package:flutter/material.dart';

class AyahCoordinate {
  final int surahNumber;
  final int ayahNumber;
  final double x;
  final double y;
  final String polygonString;
  final Path path;

  const AyahCoordinate({
    required this.surahNumber,
    required this.ayahNumber,
    required this.x,
    required this.y,
    required this.polygonString,
    required this.path,
  });
}

class PageCoordinates {
  final int pageNumber;
  final List<AyahCoordinate> ayahs;

  const PageCoordinates({
    required this.pageNumber,
    required this.ayahs,
  });
}

abstract class CoordinateProvider {
  Future<PageCoordinates> getCoordinates(int pageNumber);
}
