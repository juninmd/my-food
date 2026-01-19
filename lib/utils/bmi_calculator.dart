import 'package:flutter/material.dart';

class BmiResult {
  final double bmi;
  final String category;
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

    String category;
    Color color;

    if (bmi < 18.5) {
      category = 'Abaixo do peso';
      color = Colors.orange;
    } else if (bmi < 25.0) {
      category = 'Peso normal';
      color = Colors.green;
    } else if (bmi < 30.0) {
      category = 'Sobrepeso';
      color = Colors.orangeAccent;
    } else {
      category = 'Obesidade';
      color = Colors.red;
    }

    return BmiResult(bmi: bmi, category: category, color: color);
  }
}
