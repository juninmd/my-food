import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class DashboardSurpriseButton extends StatelessWidget {
  final VoidCallback onSurpriseMe;

  const DashboardSurpriseButton({
    super.key,
    required this.onSurpriseMe,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: InkWell(
        onTap: onSurpriseMe,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: colorScheme.primary, // Flat mint green
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03), // Subtle shadow
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_fix_high, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.surpriseMeButton,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
