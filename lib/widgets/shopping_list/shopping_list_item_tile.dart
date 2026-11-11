import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';

/// A row of the shopping list. Checking it fills and tilts the box, draws
/// the tick and strikes the name through.
class ShoppingListItemTile extends StatelessWidget {
  final String ingredient;
  final int count;
  final bool isChecked;
  final bool isLast;
  final ValueChanged<bool?> onChanged;

  const ShoppingListItemTile({
    super.key,
    required this.ingredient,
    required this.count,
    required this.isChecked,
    required this.isLast,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final d = AppMotion.of(context, AppMotion.tick);

    return Semantics(
      checked: isChecked,
      label: ingredient,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.lightImpact();
          onChanged(!isChecked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          decoration: BoxDecoration(
            border: isLast ? null : Border(bottom: BorderSide(color: t.line)),
          ),
          child: Row(children: [
            AnimatedRotation(
              turns: isChecked ? -0.022 : 0,
              duration: d,
              curve: AppMotion.springCurve,
              child: AnimatedContainer(
                duration: d,
                curve: AppMotion.springCurve,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isChecked ? t.mint : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: isChecked ? t.mint : t.line, width: 2),
                ),
                child: AnimatedScale(
                  scale: isChecked ? 1 : 0,
                  duration: d,
                  curve: AppMotion.springCurve,
                  child: const Icon(Icons.check_rounded,
                      size: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(alignment: Alignment.centerLeft, children: [
                  AnimatedDefaultTextStyle(
                    duration: d,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isChecked ? t.ink2 : t.ink,
                    ),
                    child: Text(ingredient),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(end: isChecked ? 1 : 0),
                          duration: d,
                          curve: AppMotion.decel,
                          builder: (context, v, _) => FractionallySizedBox(
                            widthFactor: v,
                            child: Container(height: 2, color: t.ink2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            if (count > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: t.mintSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('x$count', style: AppType.data(11, color: t.mint)),
              ),
          ]),
        ),
      ),
    );
  }
}
