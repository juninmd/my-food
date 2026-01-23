import 'package:flutter/material.dart';
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
  String _resultText = '';
  Color _resultColor = Colors.black;

  void _calculateBMI() {
    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);

    if (weight != null && height != null && height > 0) {
      setState(() {
        final result = BmiCalculator.calculate(weight, height);
        _bmi = result.bmi;
        _resultText = result.category;
        _resultColor = result.color;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira valores válidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora IMC'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calcule seu Índice de Massa Corporal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Altura (cm)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'CALCULAR',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            if (_bmi != null)
              Column(
                children: [
                  Text(
                    'Seu IMC é:',
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
                    _resultText,
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
