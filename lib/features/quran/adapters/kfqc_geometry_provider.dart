import 'package:flutter/material.dart';
import '../interfaces/page_geometry_provider.dart';

class KFQCGeometryProvider implements PageGeometryProvider {
  const KFQCGeometryProvider();

  @override
  Size getBaseDimensions(int pageNumber) {
    return (pageNumber == 1 || pageNumber == 2)
        ? const Size(235.0, 235.0)
        : const Size(345.0, 550.0);
  }

  @override
  double getAspectRatio(int pageNumber) {
    final dims = getBaseDimensions(pageNumber);
    return dims.width / dims.height;
  }
}
