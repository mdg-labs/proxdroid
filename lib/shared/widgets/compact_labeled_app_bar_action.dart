import 'package:flutter/material.dart';

/// App bar action: icon with a single-line caption below (VM / LXC detail).
class CompactLabeledAppBarAction extends StatelessWidget {
  const CompactLabeledAppBarAction({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
    this.maxLabelWidth = 64,
    super.key,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback? onPressed;
  final double maxLabelWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final enabled = onPressed != null;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color:
                        enabled
                            ? scheme.onSurface
                            : scheme.onSurface.withValues(alpha: 0.38),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: maxLabelWidth,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.labelSmall?.copyWith(
                        fontSize: 10,
                        height: 1.1,
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
