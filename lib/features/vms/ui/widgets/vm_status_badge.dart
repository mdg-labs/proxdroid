import 'package:flutter/material.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

/// Maps [VmStatus] to [StatusBadge] (localized label; colors follow theme [ColorScheme] via shared badge).
class VmStatusBadge extends StatelessWidget {
  const VmStatusBadge({required this.status, super.key});

  final VmStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (variant, label) = switch (status) {
      VmStatus.running => (StatusBadgeVariant.success, l10n.statusRunning),
      VmStatus.stopped => (StatusBadgeVariant.stopped, l10n.statusStopped),
      VmStatus.paused => (StatusBadgeVariant.warning, l10n.statusPaused),
      VmStatus.unknown => (StatusBadgeVariant.neutral, l10n.statusUnknown),
    };
    return StatusBadge(label: label, variant: variant);
  }
}
