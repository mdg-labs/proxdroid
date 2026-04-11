import 'package:flutter/material.dart';

/// Tokenized surface card wrapping a [ResourceLineChart] or any chart widget.
///
/// Per §3 / §9: outer card 16 radius, inner padding 16, [title] in
/// [TextTheme.titleMedium], optional [subtitle], optional [timeframeSelector]
/// (pill segmented) placed right-aligned in the header row, [child] fills the
/// remainder.
///
/// When [compact] is `true`, the Card wrapper is omitted (for embedding inside
/// node cards on the dashboard), padding is reduced to 8 vertical, and the
/// title uses [TextTheme.labelMedium].
class ChartCard extends StatelessWidget {
  const ChartCard({
    required this.title,
    required this.child,
    this.subtitle,
    this.timeframeSelector,
    this.compact = false,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// Optional pill timeframe selector — displayed right-aligned in the header.
  final Widget? timeframeSelector;

  final Widget child;

  /// When `true`, skips the Card wrapper and reduces padding (dashboard use).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final titleStyle = compact ? tt.labelMedium : tt.titleMedium;
    final padding =
        compact
            ? const EdgeInsets.symmetric(vertical: 8)
            : const EdgeInsets.all(16);
    final gap = compact ? 4.0 : 12.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: titleStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: tt.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (timeframeSelector != null) ...[
              const SizedBox(width: 8),
              timeframeSelector!,
            ],
          ],
        ),
        SizedBox(height: gap),
        child,
      ],
    );

    if (compact) {
      return Padding(padding: padding, child: content);
    }
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: padding, child: content),
    );
  }
}
