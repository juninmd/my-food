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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: Colors.blue.shade50, // Keep the blue tint for water context
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blue.shade100.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.local_drink_rounded,
                color: Colors.blue.shade400,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Progress & Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.waterTrackerTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      Text(
                        "$currentGlasses / $targetGlasses",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: progress,
                    progressColor: Colors.blue.shade400,
                    backgroundColor: Colors.white,
                    barRadius: const Radius.circular(4),
                    padding: EdgeInsets.zero,
                    animation: true,
                    animationDuration: 500,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Add Button
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
