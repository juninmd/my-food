import 'package:flutter/material.dart';

Widget buildMealDetailMacroItem(BuildContext context, String label, String value,
    IconData icon, Color color, Color bgColor) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(height: 12),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget buildMealDetailDivider() {
  return Container(
    height: 40,
    width: 1,
    color: Colors.grey.shade200,
  );
}
