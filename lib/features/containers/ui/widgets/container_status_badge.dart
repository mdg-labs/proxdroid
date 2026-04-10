import 'package:flutter/material.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

/// Maps [px.ContainerStatus] to [StatusBadge] (localized label + semantic colors).
class ContainerStatusBadge extends StatelessWidget {
  const ContainerStatusBadge({required this.status, super.key});

  final px.ContainerStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (variant, label) = switch (status) {
      px.ContainerStatus.running => (
        StatusBadgeVariant.success,
        l10n.statusRunning,
      ),
      px.ContainerStatus.stopped => (
        StatusBadgeVariant.error,
        l10n.statusStopped,
      ),
      px.ContainerStatus.unknown => (
        StatusBadgeVariant.neutral,
        l10n.statusUnknown,
      ),
    };
    return StatusBadge(label: label, variant: variant);
  }
}
