import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';

/// A titled card grouping related form fields.
class FoodFormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const FoodFormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: t.card(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(icon, size: 16, color: t.mint),
          const SizedBox(width: 8),
          Expanded(
              child: Text(title.toUpperCase(), style: AppType.label(t.ink2))),
        ]),
        const SizedBox(height: 14),
        ...children,
      ]),
    );
  }
}
