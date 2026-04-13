import 'package:flutter/material.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Icon-only stadium “pills” for guest power actions (VM / LXC detail).
///
/// Callbacks and visibility match the previous labeled button row; tooltips
/// carry the same strings as the old button labels for a11y.
class GuestPowerActionIconPills extends StatelessWidget {
  const GuestPowerActionIconPills({
    required this.l10n,
    required this.canStart,
    required this.canStopOrReboot,
    required this.busy,
    required this.onStart,
    required this.onStop,
    required this.onForceStop,
    required this.onReboot,
    super.key,
  });

  final AppLocalizations l10n;
  final bool canStart;
  final bool canStopOrReboot;
  final bool busy;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onForceStop;
  final VoidCallback onReboot;

  static const _stadium = StadiumBorder();
  static const _iconSize = 22.0;
  static const _pillPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor =
        isDark
            ? AppColors.darkStatusWarningForeground
            : AppColors.lightStatusWarningForeground;

    final idle = !busy;

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (canStart)
              IconButton.filled(
                onPressed: idle ? onStart : null,
                tooltip: l10n.actionStart,
                icon: const Icon(Icons.play_arrow_rounded, size: _iconSize),
                style: IconButton.styleFrom(
                  shape: _stadium,
                  padding: _pillPadding,
                ),
              ),
            if (canStopOrReboot) ...[
              IconButton.outlined(
                onPressed: idle ? onStop : null,
                tooltip: l10n.actionStop,
                icon: const Icon(Icons.stop_rounded, size: _iconSize),
                style: IconButton.styleFrom(
                  shape: _stadium,
                  foregroundColor: warningColor,
                  side: BorderSide(color: warningColor.withValues(alpha: 0.35)),
                  padding: _pillPadding,
                ),
              ),
              IconButton.filled(
                onPressed: idle ? onForceStop : null,
                tooltip: l10n.actionForceStop,
                icon: const Icon(
                  Icons.power_settings_new_rounded,
                  size: _iconSize,
                ),
                style: IconButton.styleFrom(
                  shape: _stadium,
                  backgroundColor: scheme.errorContainer,
                  foregroundColor: scheme.onErrorContainer,
                  padding: _pillPadding,
                ),
              ),
              IconButton.outlined(
                onPressed: idle ? onReboot : null,
                tooltip: l10n.actionReboot,
                icon: const Icon(Icons.refresh_rounded, size: _iconSize),
                style: IconButton.styleFrom(
                  shape: _stadium,
                  padding: _pillPadding,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
