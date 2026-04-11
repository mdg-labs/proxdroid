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
        color: scheme.onSurfaceVariant.withValues(alpha: 0.65),
        fontWeight: FontWeight.w700,
        fontSize: 10,
        letterSpacing: 1.4,
      ),
    };

    final EdgeInsets padding = switch (variant) {
      SectionHeaderVariant.emphasis => const EdgeInsets.fromLTRB(16, 20, 16, 8),
      SectionHeaderVariant.muted => const EdgeInsets.fromLTRB(24, 18, 16, 6),
    };

    final displayTitle =
        variant == SectionHeaderVariant.muted ? title.toUpperCase() : title;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Text(displayTitle, style: baseStyle)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
