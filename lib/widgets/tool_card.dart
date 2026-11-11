import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/pressable.dart';

/// Large tappable tile for one tool, tinted with the tool's [color].
class ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const ToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Pressable(
      onTap: onTap,
      semanticLabel: title,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: t.card(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Icon(Icons.arrow_outward_rounded, color: t.ink2, size: 20),
          ]),
          const Spacer(),
          Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppType.display(18, color: t.ink)),
          const SizedBox(height: 4),
          Text(description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: t.ink2, height: 1.35)),
        ]),
      ),
    );
  }
}
