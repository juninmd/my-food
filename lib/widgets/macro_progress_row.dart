import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MacroProgressRow extends StatelessWidget {
  final String label;
  final int value;
  final int target;
  final Color color;
  final Color bgColor;

  const MacroProgressRow({
    super.key,
    required this.label,
    required this.value,
    required this.target,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    double progress = target > 0 ? value / target : 0;
    if (progress > 1.0) progress = 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              "${value}g / ${target}g",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 6.0,
          percent: progress,
          progressColor: color,
          backgroundColor: bgColor,
          barRadius: const Radius.circular(3),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 1000,
        ),
      ],
    );
  }
}
