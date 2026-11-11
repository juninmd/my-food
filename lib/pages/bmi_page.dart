import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/utils/bmi_calculator.dart';
import 'package:webdiet/widgets/bmi_gauge.dart';

/// Live BMI: move height and weight, the gauge and category follow.
class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  double _height = 175;
  double _weight = 72;

  String _label(AppLocalizations l10n, BmiCategory c) => switch (c) {
        BmiCategory.underweight => l10n.bmiUnderweight,
        BmiCategory.normal => l10n.bmiNormal,
        BmiCategory.overweight => l10n.bmiOverweight,
        BmiCategory.obesity => l10n.bmiObesity,
      };

  Widget _slider(String label, String value, double v, double min, double max,
      ValueChanged<double> onChanged, AppTokens t) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(child: Text(label, style: TextStyle(color: t.ink2))),
        Text(value, style: AppType.data(14, color: t.ink)),
      ]),
      Slider(
        value: v,
        min: min,
        max: max,
        divisions: (max - min).round(),
        label: value,
        semanticFormatterCallback: (_) => value,
        onChanged: onChanged,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final t = AppTokens.of(context);
    final result = BmiCalculator.calculate(_weight, _height);
    final colors = [t.water, t.mint, t.carbs, t.protein];
    final color = colors[result.category.index];
    final locale = Localizations.localeOf(context).languageCode;
    final bmiText = result.bmi.toStringAsFixed(1);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bmiTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.bmiCalculateTitle,
                      style: AppType.display(26, color: t.ink)),
                  const SizedBox(height: 6),
                  Text(l10n.bmiHint, style: TextStyle(color: t.ink2)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: t.card(),
                    child: Column(children: [
                      BmiGauge(
                          bmi: result.bmi, bandColors: colors, needle: t.ink),
                      const SizedBox(height: 12),
                      Text(l10n.bmiResultLabel,
                          style: TextStyle(color: t.ink2)),
                      Text(
                          locale == 'pt'
                              ? bmiText.replaceAll('.', ',')
                              : bmiText,
                          style: AppType.display(44, color: t.ink)),
                      const SizedBox(height: 6),
                      AnimatedContainer(
                        duration: AppMotion.of(context, AppMotion.tick),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(_label(l10n, result.category),
                            style: TextStyle(
                                color: dark ? t.paper : Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 20),
                      _slider(
                          l10n.bmiHeightLabel,
                          '${_height.round()} cm',
                          _height,
                          140,
                          210,
                          (v) => setState(() => _height = v),
                          t),
                      _slider(
                          l10n.bmiWeightLabel,
                          '${_weight.round()} kg',
                          _weight,
                          40,
                          150,
                          (v) => setState(() => _weight = v),
                          t),
                    ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
