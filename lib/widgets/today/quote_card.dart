import 'package:flutter/material.dart';
import 'package:webdiet/l10n/generated/app_localizations.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';

/// Dark card with the quote of the day. New quotes slide in; a failed
/// request shows the encouraging fallback line instead of an error.
class QuoteCard extends StatelessWidget {
  final Future<String> quoteFuture;
  final VoidCallback onRefresh;

  const QuoteCard(
      {super.key, required this.quoteFuture, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    final l10n = AppLocalizations.of(context)!;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? t.mintSoft : t.ink;
    final fg = dark ? t.ink : t.paper;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: t.card(color: bg),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.quoteOfTheDay.toUpperCase(),
            style: AppType.label(fg.withValues(alpha: 0.65))),
        const SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<String>(
            future: quoteFuture,
            builder: (context, snap) {
              final done = snap.connectionState == ConnectionState.done;
              final text = !done
                  ? null
                  : snap.hasError
                      ? l10n.quoteFallbackMessage
                      : snap.data!;
              return AnimatedSwitcher(
                duration: AppMotion.of(context, AppMotion.tick),
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position:
                        Tween(begin: const Offset(0, 0.15), end: Offset.zero)
                            .animate(a),
                    child: child,
                  ),
                ),
                child: text == null
                    ? Align(
                        key: const ValueKey('loading'),
                        alignment: Alignment.topLeft,
                        child: SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: t.mint),
                        ),
                      )
                    : Align(
                        key: ValueKey(text),
                        alignment: Alignment.topLeft,
                        child: Text(
                          text,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.display(15,
                              color: fg, weight: FontWeight.w600),
                        ),
                      ),
              );
            },
          ),
        ),
        TextButton(
          onPressed: onRefresh,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            foregroundColor:
                dark ? t.mint : Color.lerp(t.mint, Colors.white, 0.25),
          ),
          child: Text('${l10n.anotherQuote} →',
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}
