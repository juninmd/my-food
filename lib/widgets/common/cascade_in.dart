import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_motion.dart';

/// Fades and lifts its child in, [index] steps after the first item,
/// so lists arrive as a short cascade instead of all at once.
class CascadeIn extends StatelessWidget {
  final int index;
  final Widget child;
  final double offset;

  const CascadeIn({
    super.key,
    required this.index,
    required this.child,
    this.offset = 12,
  });

  @override
  Widget build(BuildContext context) {
    final step = AppMotion.cascadeStep * index;
    final total = AppMotion.of(context, AppMotion.cascade + step);
    final delay = total == Duration.zero
        ? 0.0
        : step.inMilliseconds / total.inMilliseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(delay, 1, curve: AppMotion.springCurve),
      builder: (context, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - v) * offset),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
