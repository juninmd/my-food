import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';
import 'package:webdiet/widgets/common/pressable.dart';

/// Gradient call to action for the AI day plan. The icon spins together
/// with the meal slot while it rolls.
class SurpriseButton extends StatelessWidget {
  final Animation<double> roll;
  final VoidCallback onTap;

  const SurpriseButton({super.key, required this.roll, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fg = Theme.of(context).brightness == Brightness.dark
        ? t.paper
        : Colors.white;

    return Pressable(
      onTap: onTap,
      pressedScale: 0.97,
      semanticLabel: l10n.surpriseMeButton,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [t.mint, Color.lerp(t.mint, t.water, 0.55)!],
          ),
          boxShadow: [
            BoxShadow(
              color: t.mint.withValues(alpha: 0.45),
              blurRadius: 24,
              spreadRadius: -10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: fg.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedBuilder(
              animation: roll,
              builder: (context, child) => Transform.rotate(
                angle: Curves.easeOutCubic.transform(roll.value) * 4 * math.pi,
                child: child,
              ),
              child: Icon(Icons.auto_fix_high, color: fg),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l10n.surpriseMeButton,
                  style: AppType.display(18, color: fg)),
              const SizedBox(height: 2),
              Text(l10n.surpriseMeSubtitle,
                  style: TextStyle(
                      fontSize: 12, color: fg.withValues(alpha: 0.9))),
            ]),
          ),
          Icon(Icons.arrow_forward_rounded, color: fg),
        ]),
      ),
    );
  }
}
