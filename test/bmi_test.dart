import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_food/utils/bmi_calculator.dart';

void main() {
  group('BmiCalculator Tests', () {
    test('Calculates BMI correctly', () {
      // Weight 70kg, Height 175cm = 1.75m
      // BMI = 70 / (1.75 * 1.75) = 70 / 3.0625 = 22.857...
      final result = BmiCalculator.calculate(70, 175);
      expect(result.bmi, closeTo(22.86, 0.01));
    });

    test('Categorizes Underweight correctly', () {
      // BMI < 18.5
      // 50kg, 175cm -> 50 / 3.0625 = 16.32
      final result = BmiCalculator.calculate(50, 175);
      expect(result.category, 'Abaixo do peso');
      expect(result.color, Colors.orange);
    });

    test('Categorizes Normal Weight correctly', () {
      // BMI 22.86 (from before)
      final result = BmiCalculator.calculate(70, 175);
      expect(result.category, 'Peso normal');
      expect(result.color, Colors.green);
    });

    test('Categorizes Overweight correctly', () {
      // BMI 25-30
      // 85kg, 175cm -> 85 / 3.0625 = 27.75
      final result = BmiCalculator.calculate(85, 175);
      expect(result.category, 'Sobrepeso');
      expect(result.color, Colors.orangeAccent);
    });

    test('Categorizes Obesity correctly', () {
      // BMI >= 30
      // 100kg, 175cm -> 100 / 3.0625 = 32.65
      final result = BmiCalculator.calculate(100, 175);
      expect(result.category, 'Obesidade');
      expect(result.color, Colors.red);
    });

    test('Categorizes Edge Cases correctly (Logic Fix Verification)', () {
      // Old logic bug area: 24.95
      // Let's force a value.
      // Height 100cm (1m). Weight 24.95kg -> BMI 24.95
      final result = BmiCalculator.calculate(24.95, 100);
      expect(result.category, 'Peso normal'); // Should be Normal (<25)

      // Height 100cm. Weight 25.0kg -> BMI 25.0
      final result2 = BmiCalculator.calculate(25.0, 100);
      expect(result2.category, 'Sobrepeso'); // Should be Overweight (>=25)
    });

    test('Throws error on invalid height', () {
      expect(() => BmiCalculator.calculate(70, 0), throwsArgumentError);
      expect(() => BmiCalculator.calculate(70, -10), throwsArgumentError);
    });
  });
}
