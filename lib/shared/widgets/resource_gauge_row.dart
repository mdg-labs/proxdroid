import 'package:flutter/material.dart';
import 'package:proxdroid/app/theme/app_colors.dart';

/// Label + linear gauge + optional suffix string (e.g. "4.2 GB / 8.0 GB").
///
/// The gauge bar changes color semantically based on [value]:
/// - < 65 %   → primary (blue)
/// - 65–85 %  → warning (amber)
/// - > 85 %   → error (red)
///
/// Used in storage cards and any screen that needs a compact resource gauge.
class ResourceGaugeRow extends StatelessWidget {
  const ResourceGaugeRow({
    required this.label,
    this.value,
    this.valueSuffix,
    super.key,
  });

  final String label;
  final double? value;
  final String? valueSuffix;

  Color _gaugeColor(double v, ColorScheme scheme, bool isDark) {
    if (v >= 0.85) return scheme.error;
    if (v >= 0.65) {
      return isDark
          ? AppColors.darkStatusWarningForeground
          : AppColors.lightStatusWarningForeground;
    }
    return scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            if (valueSuffix != null)
              Text(
                valueSuffix!,
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        if (value != null) ...[
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 5,
              color: _gaugeColor(value!, scheme, isDark),
              backgroundColor: scheme.surfaceContainerHighest,
            ),
          ),
        ],
      ],
    );
  }
}
