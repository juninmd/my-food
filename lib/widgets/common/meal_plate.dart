import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/utils/nutrition_math.dart';

/// A plate whose ring shows where the calories come from
/// (protein, carbs, fat). With [image] the photo fills the plate instead.
class MealPlate extends StatelessWidget {
  final int protein;
  final int carbs;
  final int fat;
  final double size;
  final Uint8List? image;

  /// Rotate and grow in on first build (used by sheet heroes).
  final bool spinIn;

  const MealPlate({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.size = 56,
    this.image,
    this.spinIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final shares = NutritionMath.calorieShares(protein, carbs, fat);
    final plate = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: t.surface,
        shape: BoxShape.circle,
        border: Border.all(color: t.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            spreadRadius: -4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(image == null ? size * 0.11 : 0),
      child: image != null
          ? ClipOval(child: Image.memory(image!, fit: BoxFit.cover))
          : TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: AppMotion.of(context, AppMotion.spring),
              curve: AppMotion.decel,
              builder: (context, v, _) => CustomPaint(
                painter: _PlatePainter(
                  shares: shares,
                  colors: [t.protein, t.carbs, t.fat],
                  sweep: v,
                ),
              ),
            ),
    );
    if (!spinIn) return plate;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.of(context, const Duration(milliseconds: 800)),
      curve: AppMotion.springCurve,
      builder: (context, v, child) => Transform.rotate(
        angle: (1 - v) * -2.1,
        child: Transform.scale(scale: 0.6 + 0.4 * v, child: child),
      ),
      child: plate,
    );
  }
}

class _PlatePainter extends CustomPainter {
  final List<double> shares;
  final List<Color> colors;
  final double sweep;

  _PlatePainter(
      {required this.shares, required this.colors, required this.sweep});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.32;
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    var start = -math.pi / 2;
    for (var i = 0; i < shares.length; i++) {
      final angle = shares[i] * 2 * math.pi * sweep;
      paint.color = colors[i];
      canvas.drawArc(rect.deflate(stroke / 2), start, angle, false, paint);
      start += angle;
    }
  }

  @override
  bool shouldRepaint(_PlatePainter old) =>
      old.sweep != sweep || old.shares != shares || old.colors != colors;
}
