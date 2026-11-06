import 'package:flutter/material.dart';

class MacroDistributionBar extends StatelessWidget {
  final double pPct;
  final double cPct;
  final double fPct;
  final ColorScheme colorScheme;
  final double height;
  final bool showLabels;
  final bool showTitle;

  const MacroDistributionBar({
    super.key,
    required this.pPct,
    required this.cPct,
    required this.fPct,
    required this.colorScheme,
    this.height = 4.0,
    this.showLabels = false,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Row(
            children: [
              Text(
                "Macro Distribution",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height >= 12 ? 12 : 4),
          child: Container(
            height: height,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Row(
              children: [
                if ((pPct * 100).round() > 0)
                  Expanded(
                    flex: (pPct * 100).round(),
                    child: Container(color: colorScheme.primary),
                  ),
                if ((cPct * 100).round() > 0)
                  Expanded(
                    flex: (cPct * 100).round(),
                    child: Container(color: Colors.blue.shade800),
                  ),
                if ((fPct * 100).round() > 0)
                  Expanded(
                    flex: (fPct * 100).round(),
                    child: Container(color: Colors.red.shade800),
                  ),
              ],
            ),
          ),
        ),
        if (showLabels) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${(pPct * 100).toStringAsFixed(1)}% P", style: TextStyle(color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("${(cPct * 100).toStringAsFixed(1)}% C", style: TextStyle(color: Colors.blue.shade800, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("${(fPct * 100).toStringAsFixed(1)}% F", style: TextStyle(color: Colors.red.shade800, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ],
    );
  }
}
