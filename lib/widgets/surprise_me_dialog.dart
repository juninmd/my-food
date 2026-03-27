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
      backgroundColor: const Color(0xFFF8F9FA), // Clean off-white
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_loading) ...[
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
                  "${l10n.aiRecommendationTitle}...",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
              ] else if (_error != null) ...[
                Icon(Icons.error_outline,
                    color: theme.colorScheme.error, size: 56),
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                )
              ] else ...[
                ScaleTransition(
                  scale: _scaleAnimation,
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
                  l10n.aiRecommendationDesc,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                if (_quote != null)
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
                            color: theme.colorScheme.secondary.withValues(alpha: 0.3), size: 24),
                        const SizedBox(height: 8),
                        Text(
                          _quote!,
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
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(l10n.viewPlanButton),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
