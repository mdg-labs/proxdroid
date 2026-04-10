import 'package:flutter/material.dart';

/// Semantic style for [StatusBadge] (Material 3–friendly; success/warning/error
/// use distinct hues — labels must be passed from l10n by the caller).
enum StatusBadgeVariant { success, warning, error, neutral }

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.label, required this.variant, super.key});

  final String label;
  final StatusBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(context, variant);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: style.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BadgeColors {
  const _BadgeColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

_BadgeColors _styleFor(BuildContext context, StatusBadgeVariant variant) {
  final scheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  switch (variant) {
    case StatusBadgeVariant.success:
      return _BadgeColors(
        background: isDark ? const Color(0xFF1B4332) : const Color(0xFFE8F5E9),
        foreground: isDark ? const Color(0xFF95D5B2) : const Color(0xFF1B4332),
      );
    case StatusBadgeVariant.warning:
      return _BadgeColors(
        background: isDark ? const Color(0xFF5C4A00) : const Color(0xFFFFF8E1),
        foreground: isDark ? const Color(0xFFFFE082) : const Color(0xFF5C4A00),
      );
    case StatusBadgeVariant.error:
      return _BadgeColors(
        background: scheme.errorContainer,
        foreground: scheme.onErrorContainer,
      );
    case StatusBadgeVariant.neutral:
      return _BadgeColors(
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurfaceVariant,
      );
  }
}
