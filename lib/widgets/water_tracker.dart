import 'package:flutter/material.dart';
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

    // Determine the number of icons to show. If current exceeds target, show current.
    final int totalIcons = currentGlasses > targetGlasses ? currentGlasses : targetGlasses;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: Colors.blue.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.waterTrackerTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.hydrationStatus(currentGlasses, targetGlasses),
                    style: TextStyle(
                      fontSize: 12, // Slightly smaller to fit
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: List.generate(totalIcons, (index) {
                      final isFilled = index < currentGlasses;
                      return Icon(
                        isFilled ? Icons.water_drop : Icons.water_drop_outlined,
                        color: Colors.blue,
                        size: 20,
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            FloatingActionButton.small(
              onPressed: onAdd,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
