import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webdiet/theme/app_motion.dart';

/// Wraps a tappable surface so it sinks while pressed and springs back,
/// with a light haptic tick. Exposed to accessibility as a button.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final String? semanticLabel;

  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.96,
    this.semanticLabel,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null || _down == v) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                widget.onTap!();
              },
        child: AnimatedScale(
          scale: _down ? widget.pressedScale : 1,
          duration: AppMotion.of(context, const Duration(milliseconds: 220)),
          curve: AppMotion.springCurve,
          child: widget.child,
        ),
      ),
    );
  }
}
