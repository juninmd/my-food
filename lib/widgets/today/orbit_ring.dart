import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_motion.dart';

/// Concentric progress rings, outermost first. Each ring draws itself from
/// its previous value to the new one with the "breathe" motion.
class OrbitRing extends StatefulWidget {
  /// Progress of each ring, 0..1, outermost first.
  final List<double> values;
  final List<Color> colors;
  final Color track;
  final double size;
  final Widget? center;

  const OrbitRing({
    super.key,
    required this.values,
    required this.colors,
    required this.track,
    this.size = 150,
    this.center,
  });

  @override
  State<OrbitRing> createState() => _OrbitRingState();
}

class _OrbitRingState extends State<OrbitRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: AppMotion.breathe);
  late List<double> _from = List.filled(widget.values.length, 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _c.duration = AppMotion.of(context, AppMotion.breathe);
    if (_c.status == AnimationStatus.dismissed) _c.forward();
  }

  @override
  void didUpdateWidget(OrbitRing old) {
    super.didUpdateWidget(old);
    if (!_same(old.values, widget.values)) {
      _from = _current(old.values);
      _c.forward(from: 0);
    }
  }

  bool _same(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  List<double> _current(List<double> target) {
    final t = AppMotion.decel.transform(_c.value);
    return [
      for (var i = 0; i < target.length; i++)
        lerpDouble(i < _from.length ? _from[i] : 0, target[i], t)!,
    ];
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, child) => CustomPaint(
          painter: _OrbitPainter(
            values: _current(widget.values),
            colors: widget.colors,
            track: widget.track,
          ),
          child: child,
        ),
        child: Center(child: widget.center),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final Color track;

  _OrbitPainter(
      {required this.values, required this.colors, required this.track});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final outer = size.width / 2;
    final widths = [size.width * 0.066, size.width * 0.05];
    var r = outer - widths[0] / 2;
    for (var i = 0; i < values.length; i++) {
      final w = i == 0 ? widths[0] : widths[1];
      if (i > 0) r -= w * 1.5;
      final rect = Rect.fromCircle(center: c, radius: r);
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(c, r, p..color = track);
      final sweep = values[i].clamp(0.0, 1.0) * 2 * math.pi;
      if (sweep > 0.001) {
        canvas.drawArc(rect, -math.pi / 2, sweep, false, p..color = colors[i]);
      }
      if (i == 0) r -= w * 0.5;
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.values != values || old.colors != colors || old.track != track;
}
