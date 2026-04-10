import 'package:flutter/material.dart';

import 'package:proxdroid/app/theme/app_colors.dart';

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
        borderRadius: BorderRadius.circular(12),
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
        background:
            isDark
                ? AppColors.darkStatusSuccessBackground
                : AppColors.lightStatusSuccessBackground,
        foreground:
            isDark
                ? AppColors.darkStatusSuccessForeground
                : AppColors.lightStatusSuccessForeground,
      );
    case StatusBadgeVariant.warning:
      return _BadgeColors(
        background:
            isDark
                ? AppColors.darkStatusWarningBackground
                : AppColors.lightStatusWarningBackground,
        foreground:
            isDark
                ? AppColors.darkStatusWarningForeground
                : AppColors.lightStatusWarningForeground,
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
