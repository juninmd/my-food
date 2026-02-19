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
    // final l10n = AppLocalizations.of(context)!; // Unused if we don't need text
    const waterColor = Color(0xFF29B6F6); // Light Blue 400

    // Determine the number of icons to show
    final int totalIcons = currentGlasses > targetGlasses ? currentGlasses : targetGlasses;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
        child: Row(
          children: [
            // Water Drop Visuals
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "$currentGlasses",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                          color: waterColor,
                        ),
                      ),
                      Text(
                        " / $targetGlasses",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(totalIcons, (index) {
                      final isFilled = index < currentGlasses;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          isFilled ? Icons.water_drop : Icons.water_drop_outlined,
                          color: isFilled ? waterColor : Colors.grey.withValues(alpha: 0.2),
                          size: 26,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Add Button (Big circular button)
            Material(
              color: waterColor,
              borderRadius: BorderRadius.circular(20),
              elevation: 4,
              shadowColor: waterColor.withValues(alpha: 0.4),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
