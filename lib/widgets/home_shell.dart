import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_motion.dart';
import 'package:webdiet/widgets/nav/pill_nav_bar.dart';
import 'package:webdiet/widgets/nav/pill_nav_rail.dart';

/// Responsive frame of the app: floating pill bar on phones, floating rail
/// on wide screens, and a fade-and-lift transition between tabs.
class HomeShell extends StatelessWidget {
  static const desktopBreakpoint = 800.0;

  final int currentIndex;
  final ValueChanged<int> onTab;
  final int marketBadge;
  final Widget child;

  const HomeShell({
    super.key,
    required this.currentIndex,
    required this.onTab,
    required this.marketBadge,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width > desktopBreakpoint;
    final body = AnimatedSwitcher(
      duration: AppMotion.of(context, AppMotion.page),
      switchInCurve: AppMotion.decel,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.02), end: Offset.zero)
              .animate(animation),
          child: child,
        ),
      ),
      child: child,
    );

    return Scaffold(
      extendBody: true,
      body: wide
          ? Row(children: [
              PillNavRail(
                currentIndex: currentIndex,
                onTap: onTab,
                marketBadge: marketBadge,
              ),
              Expanded(child: SafeArea(child: body)),
            ])
          : SafeArea(bottom: false, child: body),
      bottomNavigationBar: wide
          ? null
          : PillNavBar(
              currentIndex: currentIndex,
              onTap: onTab,
              marketBadge: marketBadge,
            ),
    );
  }
}
