import 'package:flutter/material.dart';

enum BmiCategory { underweight, normal, overweight, obesity }

class BmiResult {
  final double bmi;
  final BmiCategory category;
  final Color color;

  const BmiResult({
    required this.bmi,
    required this.category,
    required this.color,
  });
}

class BmiCalculator {
  static BmiResult calculate(double weight, double heightCm) {
    if (heightCm <= 0) {
      throw ArgumentError('Height must be greater than 0');
    }

    double heightInMeters = heightCm / 100;
    double bmi = weight / (heightInMeters * heightInMeters);

    BmiCategory category;
    Color color;

    if (bmi < 18.5) {
      category = BmiCategory.underweight;
      color = Colors.orange;
    } else if (bmi < 25.0) {
      category = BmiCategory.normal;
      color = Colors.green;
    } else if (bmi < 30.0) {
      category = BmiCategory.overweight;
      color = Colors.orangeAccent;
    } else {
      category = BmiCategory.obesity;
      color = Colors.red;
    }

    return BmiResult(bmi: bmi, category: category, color: color);
  }
}
