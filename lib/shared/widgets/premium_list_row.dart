import 'package:flutter/material.dart';

/// Single row: leading, title, subtitle, trailing, optional chevron; inset
/// divider below (§2.5).
class PremiumListRow extends StatelessWidget {
  const PremiumListRow({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.showChevron = false,
    this.showDividerBelow = true,
    this.onTap,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool showChevron;
  final bool showDividerBelow;
  final VoidCallback? onTap;

  static const double _leadingSlot = 48;

  double get _dividerIndent {
    if (leading != null) {
      return 16 + _leadingSlot + 12;
    }
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final row = InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              SizedBox(width: _leadingSlot, child: Center(child: leading!)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style:
                        textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurface,
                        ) ??
                        TextStyle(color: scheme.onSurface),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle(
                      style:
                          textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ) ??
                          TextStyle(color: scheme.onSurfaceVariant),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            if (showChevron) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );

    if (!showDividerBelow) {
      return row;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row,
        Divider(
          height: 1,
          thickness: 1,
          indent: _dividerIndent,
          endIndent: 16,
          color: scheme.outlineVariant.withValues(alpha: 0.22),
        ),
      ],
    );
  }
}
