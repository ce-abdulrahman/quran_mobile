import 'package:flutter/material.dart';

abstract class PageGeometryProvider {
  Size getBaseDimensions(int pageNumber);
  double getAspectRatio(int pageNumber);
}
