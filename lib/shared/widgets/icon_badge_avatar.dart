import 'package:flutter/material.dart';

/// Rounded icon holder for empty states and premium headers (§3).
class IconBadgeAvatar extends StatelessWidget {
  const IconBadgeAvatar({
    required this.icon,
    this.size = 80,
    this.iconSize = 40,
    this.borderRadius = 16,
    super.key,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  /// Corner radius for the rounded square (§2.3 large cards).
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: scheme.primary),
    );
  }
}
