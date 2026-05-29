import 'package:flutter/material.dart';

/// Responsive utility for mobile + tablet layouts.
/// Breakpoints:
///   Phone  : width < 600dp
///   Tablet : width >= 600dp
class Responsive {
  Responsive._();

  static const double _tabletBreakpoint = 600.0;

  /// True when the shortest side >= 600dp (tablet)
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.shortestSide >= _tabletBreakpoint;
  }

  /// True when shortest side < 600dp (phone)
  static bool isPhone(BuildContext context) => !isTablet(context);

  /// Returns a value based on form factor.
  static T value<T>(
    BuildContext context, {
    required T phone,
    required T tablet,
  }) {
    return isTablet(context) ? tablet : phone;
  }

  // ─── Spacing ──────────────────────────────────────────────────────────────

  /// Horizontal page padding
  static double pagePadding(BuildContext context) =>
      isTablet(context) ? 32.0 : 20.0;

  /// Content max width (centers content on tablet)
  static double contentMaxWidth(BuildContext context) =>
      isTablet(context) ? 680.0 : double.infinity;

  // ─── Typography ───────────────────────────────────────────────────────────

  static double titleFontSize(BuildContext context) =>
      isTablet(context) ? 28.0 : 22.0;

  static double bodyFontSize(BuildContext context) =>
      isTablet(context) ? 16.0 : 14.0;

  static double arabicFontSize(BuildContext context) =>
      isTablet(context) ? 26.0 : 20.0;

  // ─── Grid / List ─────────────────────────────────────────────────────────

  /// Number of feature grid columns on home page
  static int homeGridColumns(BuildContext context) =>
      isTablet(context) ? 3 : 2;

  /// Bottom nav icon size
  static double navIconSize(BuildContext context) =>
      isTablet(context) ? 28.0 : 24.0;

  /// Bottom nav height
  static double navHeight(BuildContext context) =>
      isTablet(context) ? 80.0 : 68.0;
}

/// Widget that rebuilds when the screen size bucket changes.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.phone,
    this.tablet,
  });

  final WidgetBuilder phone;
  final WidgetBuilder? tablet;

  @override
  Widget build(BuildContext context) {
    if (tablet != null && Responsive.isTablet(context)) {
      return tablet!(context);
    }
    return phone(context);
  }
}

/// Centers content on tablet with a max width, full-width on phone.
class AdaptiveCenter extends StatelessWidget {
  const AdaptiveCenter({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final maxW = Responsive.contentMaxWidth(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: child,
      ),
    );
  }
}
