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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double progress = (currentGlasses / targetGlasses).clamp(0.0, 1.0);

    const waterColor = Color(0xFF29B6F6); // Light Blue 400

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: waterColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: waterColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Progress and Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.waterTrackerTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: "$currentGlasses",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: waterColor,
                        ),
                        children: [
                          TextSpan(
                            text: "/$targetGlasses",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: waterColor.withValues(alpha: 0.1),
                    color: waterColor,
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Add Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: waterColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add,
                  color: waterColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
