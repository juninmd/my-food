import 'package:flutter/material.dart';

Widget buildTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
  IconData? prefixIcon,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: colorScheme.primary)
          : null,
    ),
    validator: validator,
  );
}
