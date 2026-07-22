import 'package:flutter/material.dart';

Widget buildTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  final theme = Theme.of(context);
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
    ),
    validator: validator,
  );
}
