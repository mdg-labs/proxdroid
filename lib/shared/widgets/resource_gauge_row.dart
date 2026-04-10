import 'package:flutter/material.dart';

/// Label + linear gauge + optional suffix string (e.g. "4.2 GB / 8.0 GB").
///
/// Used in storage cards and any screen that needs a compact resource gauge.
/// Callers are responsible for outer horizontal/vertical padding; this widget
/// renders content without its own insets so it composes cleanly inside
/// [Card] padding or [PremiumListRow] trailing slots.
class ResourceGaugeRow extends StatelessWidget {
  const ResourceGaugeRow({
    required this.label,
    this.value,
    this.valueSuffix,
    super.key,
  });

  /// Section or metric name, e.g. "Usage", "CPU", "Memory".
  final String label;

  /// Progress fraction 0.0–1.0; when null no gauge bar is shown (unavailable).
  final double? value;

  /// Optional text shown to the right of the label row, e.g. "4.2 / 8.0 GB".
  final String? valueSuffix;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                  color: scheme.onSurfaceVariant,
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
              minHeight: 6,
            ),
          ),
        ],
      ],
    );
  }
}
