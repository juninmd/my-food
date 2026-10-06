import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';

class SurpriseMeContent extends StatelessWidget {
  final bool loading;
  final String? error;
  final String? quote;
  final Animation<double> scaleAnimation;
  final VoidCallback onOk;

  const SurpriseMeContent({
    super.key,
    required this.loading,
    required this.error,
    required this.quote,
    required this.scaleAnimation,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (loading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: theme.primaryColor,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "${l10n.surpriseMeButton}...",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    }

    if (error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 56),
          const SizedBox(height: 24),
          Text(
            l10n.quoteErrorMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onOk,
              child: const Text("OK"),
            ),
          )
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: theme.primaryColor,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.surpriseMeFeedback,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        if (quote != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.format_quote_rounded,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.3),
                    size: 24),
                const SizedBox(height: 8),
                Text(
                  quote!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onOk,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("OK"),
          ),
        ),
      ],
    );
  }
}
