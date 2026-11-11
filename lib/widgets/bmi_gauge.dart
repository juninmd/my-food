import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_motion.dart';

/// Half-circle BMI gauge from 15 to 40 with one colored band per category
/// and a needle that swings to the value with a spring.
class BmiGauge extends StatelessWidget {
  static const minBmi = 15.0;
  static const maxBmi = 40.0;
  static const bands = [15.0, 18.5, 25.0, 30.0, 40.0];

  final double bmi;
  final List<Color> bandColors;
  final Color needle;

  const BmiGauge({
    super.key,
    required this.bmi,
    required this.bandColors,
    required this.needle,
  });

  @override
  Widget build(BuildContext context) {
    final target = ((bmi.clamp(minBmi, maxBmi) - minBmi) / (maxBmi - minBmi));
    return AspectRatio(
      aspectRatio: 2,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: target),
        duration: AppMotion.of(context, const Duration(milliseconds: 1000)),
        curve: AppMotion.springCurve,
        builder: (context, v, _) => CustomPaint(
          painter: _GaugePainter(value: v, colors: bandColors, needle: needle),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final List<Color> colors;
  final Color needle;

  _GaugePainter(
      {required this.value, required this.colors, required this.needle});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.07;
    final c = Offset(size.width / 2, size.height - stroke / 2);
    final r = math.min(size.width / 2, size.height) - stroke;
    final rect = Rect.fromCircle(center: c, radius: r);
    const span = BmiGauge.maxBmi - BmiGauge.minBmi;
    final band = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    for (var i = 0; i < BmiGauge.bands.length - 1; i++) {
      final a = (BmiGauge.bands[i] - BmiGauge.minBmi) / span;
      final b = (BmiGauge.bands[i + 1] - BmiGauge.minBmi) / span;
      canvas.drawArc(rect, math.pi + a * math.pi, (b - a) * math.pi - 0.02,
          false, band..color = colors[i]);
    }
    final angle = math.pi + value.clamp(0.0, 1.0) * math.pi;
    final tip = c + Offset(math.cos(angle), math.sin(angle)) * (r - stroke);
    final normal = Offset(-math.sin(angle), math.cos(angle)) * stroke * 0.28;
    final path = Path()
      ..moveTo(c.dx + normal.dx, c.dy + normal.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(c.dx - normal.dx, c.dy - normal.dy)
      ..close();
    final p = Paint()..color = needle;
    canvas.drawPath(path, p);
    canvas.drawCircle(c, stroke * 0.55, p);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.needle != needle || old.colors != colors;
}
