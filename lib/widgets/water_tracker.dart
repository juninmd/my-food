import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class WaterTracker extends StatelessWidget {
  final int currentGlasses;
  final int targetGlasses;
  final VoidCallback onAdd;

  const WaterTracker({
    super.key,
    required this.currentGlasses,
    required this.targetGlasses,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    double progress = targetGlasses > 0 ? currentGlasses / targetGlasses : 0;
    if (progress > 1.0) progress = 1.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1976D2)], // Blue 400 - Blue 700
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.waterTrackerTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.hydrationStatus(currentGlasses, targetGlasses),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                LinearPercentIndicator(
                  lineHeight: 6.0,
                  percent: progress,
                  progressColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  barRadius: const Radius.circular(3),
                  padding: EdgeInsets.zero,
                  animation: true,
                  animationDuration: 500,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onAdd,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.add,
                  color: const Color(0xFF1976D2),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
