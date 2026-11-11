import 'package:flutter/material.dart';
import 'package:webdiet/theme/app_tokens.dart';
import 'package:webdiet/theme/app_type.dart';

/// Top of every tab: a small context line above a large display title,
/// with an optional action on the right.
class ViewHeader extends StatelessWidget {
  final String overline;
  final String title;
  final Widget? trailing;

  const ViewHeader({
    super.key,
    required this.overline,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(overline, style: TextStyle(fontSize: 13, color: t.ink2)),
            const SizedBox(height: 4),
            Semantics(
              header: true,
              child: Text(title, style: AppType.display(32, color: t.ink)),
            ),
          ]),
        ),
        if (trailing != null) trailing!,
      ]),
    );
  }
}

/// Section title with a small hint on the right.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? hint;

  const SectionTitle({super.key, required this.title, this.hint});

  @override
  Widget build(BuildContext context) {
    final t = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(children: [
        Expanded(child: Text(title, style: AppType.display(20, color: t.ink))),
        if (hint != null)
          Text(hint!.toUpperCase(), style: AppType.label(t.ink2)),
      ]),
    );
  }
}

/// Centers content and caps its width on large screens; leaves room at the
/// bottom for the floating navigation.
class PageFrame extends StatelessWidget {
  final List<Widget> slivers;
  final double maxWidth;

  const PageFrame({super.key, required this.slivers, this.maxWidth = 1040});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final side = c.maxWidth > maxWidth ? (c.maxWidth - maxWidth) / 2 : 0.0;
      return CustomScrollView(slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(18 + side, 8, 18 + side, 120),
          sliver: SliverMainAxisGroup(slivers: slivers),
        ),
      ]);
    });
  }
}
