import 'package:flutter/material.dart';

import 'package:proxdroid/app/theme/app_colors.dart';

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
        border: Border.all(
          color: AppColors.premiumAccent.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: scheme.primary),
    );
  }
}
