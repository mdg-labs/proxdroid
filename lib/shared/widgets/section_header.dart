import 'package:flutter/material.dart';

/// ProxMate-style section label: settings lists vs drawer / muted variant.
enum SectionHeaderVariant {
  /// Primary accent, [TextTheme.titleSmall] — settings and grouped screens.
  emphasis,

  /// Muted label — drawer section titles (§6.1).
  muted,
}

/// Small label row for grouped lists and the navigation drawer.
///
/// Pass localized [title] from callers (ARB); optional [trailing] for actions.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.trailing,
    this.variant = SectionHeaderVariant.emphasis,
    super.key,
  });

  final String title;
  final Widget? trailing;
  final SectionHeaderVariant variant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final TextStyle? baseStyle = switch (variant) {
      SectionHeaderVariant.emphasis => textTheme.titleSmall?.copyWith(
        color: scheme.primary,
        fontWeight: FontWeight.w600,
      ),
      SectionHeaderVariant.muted => textTheme.labelSmall?.copyWith(
        color: scheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    };

    final EdgeInsets padding = switch (variant) {
      SectionHeaderVariant.emphasis => const EdgeInsets.fromLTRB(16, 20, 16, 8),
      SectionHeaderVariant.muted => const EdgeInsets.fromLTRB(28, 12, 16, 4),
    };

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Text(title, style: baseStyle)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
