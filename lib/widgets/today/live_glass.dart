import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_motion.dart';

/// A glass whose water level rises with a spring and whose surface waves
/// for a few cycles after each change, then settles.
class LiveGlass extends StatefulWidget {
  /// Fill level, 0..1.
  final double level;
  final Color water;
  final Color rim;
  final Size size;

  const LiveGlass({
    super.key,
    required this.level,
    required this.water,
    required this.rim,
    this.size = const Size(64, 84),
  });

  @override
  State<LiveGlass> createState() => _LiveGlassState();
}

class _LiveGlassState extends State<LiveGlass>
    with SingleTickerProviderStateMixin {
  static const _cycles = 3;
  late final AnimationController _wave =
      AnimationController(vsync: this, duration: AppMotion.wave * _cycles);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) &&
        _wave.status == AnimationStatus.dismissed) {
      _wave.forward();
    }
  }

  @override
  void didUpdateWidget(LiveGlass old) {
    super.didUpdateWidget(old);
    if (old.level != widget.level && !AppMotion.reduced(context)) {
      _wave.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: widget.level.clamp(0.0, 1.0)),
      duration: AppMotion.of(context, const Duration(milliseconds: 900)),
      curve: AppMotion.springCurve,
      builder: (context, level, _) => AnimatedBuilder(
        animation: _wave,
        builder: (context, _) => CustomPaint(
          size: widget.size,
          painter: _GlassPainter(
            level: level,
            phase: _wave.value * _cycles,
            calm: _wave.value,
            water: widget.water,
            rim: widget.rim,
          ),
        ),
      ),
    );
  }
}

class _GlassPainter extends CustomPainter {
  final double level;
  final double phase;
  final double calm;
  final Color water;
  final Color rim;

  _GlassPainter({
    required this.level,
    required this.phase,
    required this.calm,
    required this.water,
    required this.rim,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final glass = RRect.fromRectAndCorners(
      Offset.zero & size,
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomLeft: const Radius.circular(18),
      bottomRight: const Radius.circular(18),
    );
    canvas.save();
    canvas.clipRRect(glass);
    if (level > 0) {
      final surface = size.height * (1 - level);
      final amp = level >= 1 ? 0.0 : 3.0 * (1 - calm * 0.7);
      final path = Path()..moveTo(0, size.height);
      for (double x = 0; x <= size.width; x += 2) {
        final y = surface +
            math.sin((x / size.width * 2 + phase) * 2 * math.pi) * amp;
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height)
        ..close();
      canvas.drawPath(path, Paint()..color = water.withValues(alpha: 0.85));
    }
    canvas.restore();
    canvas.drawRRect(
      glass.deflate(1),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = rim,
    );
  }

  @override
  bool shouldRepaint(_GlassPainter old) =>
      old.level != level || old.phase != phase || old.water != water;
}
