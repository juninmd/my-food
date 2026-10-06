import 'package:flutter/material.dart';
import 'package:webdiet/widgets/surprise_me_content.dart';

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
      final results = await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        widget.quoteFuture,
      ]);

      if (!mounted) return;

      widget.onReveal();

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
    return Dialog(
      backgroundColor: const Color(0xFFF8F9FA),
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
          child: SurpriseMeContent(
            loading: _loading,
            error: _error,
            quote: _quote,
            scaleAnimation: _scaleAnimation,
            onOk: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
