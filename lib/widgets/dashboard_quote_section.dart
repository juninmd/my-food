import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class DashboardQuoteSection extends StatelessWidget {
  final Future<String> quoteFuture;

  const DashboardQuoteSection({
    super.key,
    required this.quoteFuture,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder<String>(
      future: quoteFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.hasError) {
          final text =
              snapshot.hasError ? l10n.quoteFallbackMessage : snapshot.data!;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F9F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"',
                  style: TextStyle(
                    color: colorScheme.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
