import 'package:flutter/material.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

/// Standard shell layout: [AppBar] + [Expanded] body, optional FAB overlay.
///
/// Use for section screens inside [AppShell]. Pass [title] as [Text] or a custom
/// [Widget]. Body padding is left to the child (e.g. [ListView.padding] or
/// [SliverPadding]) so pull-to-refresh and scroll views stay edge-to-edge.
class ShellSectionBody extends StatelessWidget {
  const ShellSectionBody({
    super.key,
    required this.title,
    required this.body,
    this.leading,
    this.actions,
    this.floatingActionButton,
  });

  final Widget title;
  final Widget body;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: leading ?? shellAppBarLeading(context),
          title: title,
          actions: actions,
        ),
        Expanded(child: body),
      ],
    );

    if (floatingActionButton == null) {
      return column;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        column,
        Positioned(right: 16, bottom: 16, child: floatingActionButton!),
      ],
    );
  }
}
