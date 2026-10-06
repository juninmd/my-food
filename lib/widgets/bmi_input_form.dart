import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';

class BmiInputForm extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController heightController;

  const BmiInputForm({
    super.key,
    required this.weightController,
    required this.heightController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.bmiWeightLabel,
              hintText: 'e.g. 70.5',
              prefixIcon: Icon(Icons.monitor_weight_outlined,
                  color: colorScheme.primary),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.bmiHeightLabel,
              hintText: 'e.g. 1.75',
              prefixIcon:
                  Icon(Icons.height_outlined, color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
