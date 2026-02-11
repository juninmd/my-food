import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';
import '../utils/bmi_calculator.dart';

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double? _bmi;
  BmiCategory? _bmiCategory;
  Color _resultColor = Colors.black;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);

    if (weight != null && height != null && height > 0) {
      setState(() {
        final result = BmiCalculator.calculate(weight, height);
        _bmi = result.bmi;
        _bmiCategory = result.category;
        _resultColor = result.color;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.bmiErrorInvalidInput)),
      );
    }
  }

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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bmiTitle),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.bmiCalculateTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.bmiWeightLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.monitor_weight),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.bmiHeightLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                l10n.bmiCalculateButton,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            if (_bmi != null && _bmiCategory != null)
              Column(
                children: [
                  Text(
                    l10n.bmiResultLabel,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Text(
                    _bmi!.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _resultColor,
                    ),
                  ),
                  Text(
                    _getCategoryText(context, _bmiCategory!),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _resultColor,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
