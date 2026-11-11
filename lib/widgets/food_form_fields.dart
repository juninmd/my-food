import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webdiet/theme/app_tokens.dart';

/// Text field styled by the theme, with an optional leading icon.
Widget buildTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
  IconData? prefixIcon,
}) {
  final t = AppTokens.of(context);
  final numeric = keyboardType == TextInputType.number;
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    inputFormatters: numeric ? [FilteringTextInputFormatter.digitsOnly] : null,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: t.mint) : null,
    ),
    validator: validator,
  );
}
