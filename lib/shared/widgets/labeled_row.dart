import 'package:flutter/material.dart';

/// Label + value row for resource detail screens.
class LabeledRow extends StatelessWidget {
  const LabeledRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 112,
                child: Text(
                  label,
                  style: tt.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: tt.bodyLarge?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
