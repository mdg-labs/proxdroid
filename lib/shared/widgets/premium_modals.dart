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
Future<T?> showPremiumDialog<T>({
  required BuildContext context,
  required Widget title,
  required Widget content,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    builder:
        (ctx) =>
            PremiumDialog(title: title, content: content, actions: actions),
  );
}

/// Body scaffold for modal bottom sheets (§3 / [BottomSheetThemeData]).
///
/// Drag handle and top radius come from theme. Use inside
/// [showModalBottomSheet] `builder`.
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
