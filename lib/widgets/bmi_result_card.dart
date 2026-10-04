import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/utils/bmi_calculator.dart';

class BmiResultCard extends StatelessWidget {
  final double bmi;
  final BmiCategory category;
  final Color resultColor;

  const BmiResultCard({
    super.key,
    required this.bmi,
    required this.category,
    required this.resultColor,
  });

  String _getCategoryText(BuildContext context, BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return AppLocalizations.of(context)!.bmiUnderweight;
      case BmiCategory.normal:
        return AppLocalizations.of(context)!.bmiNormal;
      case BmiCategory.overweight:
        return AppLocalizations.of(context)!.bmiOverweight;
      case BmiCategory.obesity:
        return AppLocalizations.of(context)!.bmiObesity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: resultColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            l10n.bmiResultLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bmi.toStringAsFixed(1),
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: resultColor,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: resultColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              _getCategoryText(context, category),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
