import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

/// Generic premium card — wraps any child in a rounded, shadowed surface.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.color,
    this.gradient,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final Gradient? gradient;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final cs = AppColorScheme.of(context);
    final radius = borderRadius ?? BorderRadius.circular(AppSpacing.radiusLg);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: gradient == null ? (color ?? cs.card) : null,
          gradient: gradient,
          borderRadius: radius,
          border: border ?? Border.all(color: cs.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius as BorderRadius?,
          splashColor: cs.primary.withValues(alpha: 0.08),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
