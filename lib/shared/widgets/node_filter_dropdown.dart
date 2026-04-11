import 'package:flutter/material.dart';
import 'package:proxdroid/app/theme/app_theme.dart';

/// Compact node filter used on VM and container list screens.
class NodeFilterDropdown extends StatelessWidget {
  const NodeFilterDropdown({
    required this.nodes,
    required this.selected,
    required this.allLabel,
    required this.filterByNodeLabel,
    required this.onChanged,
    required this.scheme,
    required this.tt,
    super.key,
  });

  final List<String> nodes;
  final String? selected;
  final String allLabel;
  final String filterByNodeLabel;
  final ValueChanged<String?> onChanged;
  final ColorScheme scheme;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            isDense: true,
            value: selected,
            hint: Text(
              filterByNodeLabel,
              style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            style: tt.bodySmall?.copyWith(color: scheme.onSurface),
            dropdownColor: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            icon: Icon(
              Icons.unfold_more,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
            items: [
              DropdownMenuItem<String?>(value: null, child: Text(allLabel)),
              ...nodes.map(
                (n) => DropdownMenuItem<String>(value: n, child: Text(n)),
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
