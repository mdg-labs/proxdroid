import 'package:flutter/material.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/l10n/app_localizations.dart';

/// Stadium “pills” for guest power actions (VM / LXC detail) with compact
/// captions under each icon.
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
  static const _pillPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor =
        isDark
            ? AppColors.darkStatusWarningForeground
            : AppColors.lightStatusWarningForeground;

    final idle = !busy;
    final captionStyle = tt.labelSmall?.copyWith(
      fontSize: 10,
      height: 1.1,
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

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
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (canStart)
              _LabeledPowerPill(
                label: l10n.actionStart,
                captionStyle: captionStyle,
                child: IconButton.filled(
                  onPressed: idle ? onStart : null,
                  tooltip: l10n.actionStart,
                  icon: const Icon(Icons.play_arrow_rounded, size: _iconSize),
                  style: IconButton.styleFrom(
                    shape: _stadium,
                    padding: _pillPadding,
                  ),
                ),
              ),
            if (canStopOrReboot) ...[
              _LabeledPowerPill(
                label: l10n.actionStop,
                captionStyle: captionStyle,
                child: IconButton.outlined(
                  onPressed: idle ? onStop : null,
                  tooltip: l10n.actionStop,
                  icon: const Icon(Icons.stop_rounded, size: _iconSize),
                  style: IconButton.styleFrom(
                    shape: _stadium,
                    foregroundColor: warningColor,
                    side: BorderSide(
                      color: warningColor.withValues(alpha: 0.35),
                    ),
                    padding: _pillPadding,
                  ),
                ),
              ),
              _LabeledPowerPill(
                label: l10n.actionForceStop,
                captionStyle: captionStyle,
                child: IconButton.filled(
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
              ),
              _LabeledPowerPill(
                label: l10n.actionReboot,
                captionStyle: captionStyle,
                child: IconButton.outlined(
                  onPressed: idle ? onReboot : null,
                  tooltip: l10n.actionReboot,
                  icon: const Icon(Icons.refresh_rounded, size: _iconSize),
                  style: IconButton.styleFrom(
                    shape: _stadium,
                    padding: _pillPadding,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LabeledPowerPill extends StatelessWidget {
  const _LabeledPowerPill({
    required this.label,
    required this.captionStyle,
    required this.child,
  });

  final String label;
  final TextStyle? captionStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 96),
          child: ExcludeSemantics(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: captionStyle,
            ),
          ),
        ),
      ],
    );
  }
}
