import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static double pagePadding(BuildContext context) {
    return isTablet(context) ? 24.0 : 16.0;
  }
}
