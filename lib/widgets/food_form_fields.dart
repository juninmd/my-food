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
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.6),
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 4.0),
              child: Icon(prefixIcon, color: colorScheme.primary),
            )
          : null,
    ),
    validator: validator,
  );
}
