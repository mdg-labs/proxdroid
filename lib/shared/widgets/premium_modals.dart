import 'package:flutter/material.dart';

/// [AlertDialog] aligned with §2.3 / global [DialogTheme] (24–28 radius).
///
/// Prefer this wrapper when adding new dialogs; Phase 7 migrates call sites.
class PremiumDialog extends StatelessWidget {
  const PremiumDialog({
    required this.title,
    required this.content,
    this.actions,
    super.key,
  });

  final Widget title;
  final Widget content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      title: DefaultTextStyle(
        style: textTheme.titleLarge ?? const TextStyle(),
        child: title,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(child: content),
      ),
      actions: actions,
    );
  }
}

/// Shows a dialog using [PremiumDialog].
///
/// Uses [useRootNavigator]: `false` so the route stacks on the same
/// [Navigator] as [StatefulShellRoute] branch pages. Action buttons that call
/// [Navigator.pop] with the caller screen context then dismiss this dialog
/// instead of popping the underlying detail route (root vs branch mismatch).
Future<T?> showPremiumDialog<T>({
  required BuildContext context,
  required Widget title,
  required Widget content,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    useRootNavigator: false,
    builder:
        (ctx) =>
            PremiumDialog(title: title, content: content, actions: actions),
  );
}

/// Body scaffold for modal bottom sheets (§3 / [BottomSheetThemeData]).
///
/// Drag handle, top radius, and sheet surface color come from theme (Phase C:
/// `surfaceContainerHigh`). Use inside [showModalBottomSheet] `builder`.
class PremiumBottomSheet extends StatelessWidget {
  const PremiumBottomSheet({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 8, 24, 24),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final resolved = padding.resolve(Directionality.of(context));
    return Padding(
      padding: resolved.copyWith(
        bottom: resolved.bottom + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: child,
    );
  }
}

/// [showModalBottomSheet] with scroll-friendly defaults; sheet chrome from theme.
Future<T?> showPremiumModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    builder: builder,
  );
}
