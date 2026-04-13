import 'package:flutter/material.dart';
import 'package:proxdroid/app/theme/app_colors.dart';

/// Semantic display variant for [StatusBadge].
///
/// - [success]  – cyan-tinted “online / healthy” (Stitch primary story)
/// - [running]  – cyan with animated pulse dot: task in progress
/// - [warning]  – magenta tertiary: paused / attention (not amber)
/// - [error]    – [ColorScheme.error] story: offline, task failed
/// - [stopped]  – muted surface: powered off, not an error
/// - [neutral]  – unknown state
enum StatusBadgeVariant { success, running, warning, error, stopped, neutral }

/// Compact status pill with semantic color and optional animated pulse dot.
///
/// When [variant] is [StatusBadgeVariant.running], a pulsing dot is prepended
/// to the label to signal that the item is actively in progress.
class StatusBadge extends StatefulWidget {
  const StatusBadge({required this.label, required this.variant, super.key});

  final String label;
  final StatusBadgeVariant variant;

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulse;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(StatusBadge old) {
    super.didUpdateWidget(old);
    if (old.variant != widget.variant) {
      _pulse?.dispose();
      _pulse = null;
      _initAnimation();
    }
  }

  void _initAnimation() {
    if (widget.variant == StatusBadgeVariant.running) {
      _pulse = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1100),
      )..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _colorsFor(context, widget.variant);

    Widget? dot;
    if (widget.variant == StatusBadgeVariant.running && _pulse != null) {
      dot = AnimatedBuilder(
        animation: _pulse!,
        builder:
            (_, child) =>
                Opacity(opacity: 0.35 + 0.65 * _pulse!.value, child: child),
        child: Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: style.foreground,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: style.foreground.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot != null) ...[dot, const SizedBox(width: 5)],
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: style.foreground,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
              ),
            ),
          ],
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

_BadgeColors _colorsFor(BuildContext context, StatusBadgeVariant variant) {
  final scheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return switch (variant) {
    StatusBadgeVariant.success => _BadgeColors(
      background:
          isDark
              ? AppColors.darkStatusSuccessBackground
              : AppColors.lightStatusSuccessBackground,
      foreground:
          isDark
              ? AppColors.darkStatusSuccessForeground
              : AppColors.lightStatusSuccessForeground,
    ),
    StatusBadgeVariant.running => _BadgeColors(
      background:
          isDark
              ? AppColors.darkStatusRunningBackground
              : AppColors.lightStatusRunningBackground,
      foreground:
          isDark
              ? AppColors.darkStatusRunningForeground
              : AppColors.lightStatusRunningForeground,
    ),
    StatusBadgeVariant.warning => _BadgeColors(
      background:
          isDark
              ? AppColors.darkStatusWarningBackground
              : AppColors.lightStatusWarningBackground,
      foreground:
          isDark
              ? AppColors.darkStatusWarningForeground
              : AppColors.lightStatusWarningForeground,
    ),
    StatusBadgeVariant.error => _BadgeColors(
      background: scheme.errorContainer,
      foreground: scheme.onErrorContainer,
    ),
    StatusBadgeVariant.stopped => _BadgeColors(
      background:
          isDark
              ? AppColors.darkStatusStoppedBackground
              : AppColors.lightStatusStoppedBackground,
      foreground:
          isDark
              ? AppColors.darkStatusStoppedForeground
              : AppColors.lightStatusStoppedForeground,
    ),
    StatusBadgeVariant.neutral => _BadgeColors(
      background: scheme.surfaceContainerHighest,
      foreground: scheme.onSurfaceVariant,
    ),
  };
}
