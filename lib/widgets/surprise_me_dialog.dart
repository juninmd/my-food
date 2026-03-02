import 'package:flutter/material.dart';
import 'package:my_food/l10n/generated/app_localizations.dart';

class SurpriseMeDialog extends StatefulWidget {
  final Future<String> quoteFuture;
  final VoidCallback onReveal;

  const SurpriseMeDialog({
    super.key,
    required this.quoteFuture,
    required this.onReveal,
  });

  @override
  State<SurpriseMeDialog> createState() => _SurpriseMeDialogState();
}

class _SurpriseMeDialogState extends State<SurpriseMeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _loading = true;
  String? _quote;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _startSurprise();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startSurprise() async {
    try {
      // Wait for both the minimum delay and the quote
      final results = await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        widget.quoteFuture,
      ]);

      if (!mounted) return;

      widget.onReveal(); // Update parent state

      setState(() {
        _loading = false;
        _quote = results[1] as String;
      });

      _controller.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_loading) ...[
              const SizedBox(height: 20),
              CircularProgressIndicator(color: theme.primaryColor),
              const SizedBox(height: 24),
              Text(
                "${l10n.surpriseMeButton}...",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            ] else if (_error != null) ...[
              Icon(Icons.error_outline,
                  color: theme.colorScheme.error, size: 48),
              const SizedBox(height: 16),
              Text(l10n.quoteErrorMessage),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ] else ...[
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.green, size: 48),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.surpriseMeFeedback,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_quote != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _quote!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
