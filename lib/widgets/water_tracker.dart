import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    // Each glass is 250ml
    int currentMl = currentGlasses * 250;
    int targetMl = targetGlasses * 250;

    double progress = targetGlasses > 0 ? currentGlasses / targetGlasses : 0;
    if (progress > 1.0) progress = 1.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
      ),
      color: Colors.blue.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.water_drop, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.waterTrackerTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    lineHeight: 10.0,
                    percent: progress,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    barRadius: const Radius.circular(5),
                    padding: EdgeInsets.zero,
                    animation: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$currentMl / $targetMl ml",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              tooltip: l10n.addWater,
            ),
          ],
        ),
      ),
    );
  }
}
