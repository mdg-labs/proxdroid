import 'package:flutter/material.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

/// Reserved vertical space above the bottom shell chrome for FAB positioning.
///
/// Phase 4 ships [NavigationBar] as [Scaffold.bottomNavigationBar], which
/// handles its own layout — the scaffold body is already placed above the bar.
/// This constant is therefore 0; only system view-padding is added to the FAB
/// bottom offset inside [ShellSectionBody].
const double kShellBottomNavReserve = 0;

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
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: leading ?? shellAppBarLeading(context),
          title: title,
          actions: actions,
          backgroundColor: scaffoldBg.withValues(alpha: 0),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        Expanded(child: body),
      ],
    );

    if (floatingActionButton == null) {
      return column;
    }

    final bottomInset =
        MediaQuery.viewPaddingOf(context).bottom + kShellBottomNavReserve + 16;

    return Stack(
      fit: StackFit.expand,
      children: [
        column,
        Positioned(
          right: 16,
          bottom: bottomInset,
          child: floatingActionButton!,
        ),
      ],
    );
  }
}
