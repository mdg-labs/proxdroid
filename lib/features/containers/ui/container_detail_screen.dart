import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/task.dart' as pve;
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/containers/data/container_repository.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/features/containers/ui/widgets/container_status_badge.dart';
import 'package:proxdroid/features/containers/ui/widgets/cpu_chart.dart';
import 'package:proxdroid/features/containers/ui/widgets/disk_io_chart.dart';
import 'package:proxdroid/features/containers/ui/widgets/memory_chart.dart';
import 'package:proxdroid/features/containers/ui/widgets/network_chart.dart';
import 'package:proxdroid/features/backups/ui/trigger_backup_sheet.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/proxmox_tag_colors_provider.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/guest_power_action_icon_pills.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';
import 'package:proxdroid/shared/widgets/proxmox_tag_widgets.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class ContainerDetailScreen extends ConsumerStatefulWidget {
  const ContainerDetailScreen({
    required this.node,
    required this.ctid,
    super.key,
  });

  final String node;
  final String ctid;

  @override
  ConsumerState<ContainerDetailScreen> createState() =>
      _ContainerDetailScreenState();
}

class _ContainerDetailScreenState extends ConsumerState<ContainerDetailScreen> {
  bool _powerBusy = false;

  Future<void> _runPowerAction(
    px.Container ct,
    Future<String> Function(ContainerRepository repo) invoke,
    String successActionLabel,
  ) async {
    if (!mounted) {
      return;
    }
    setState(() => _powerBusy = true);
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = await ref.read(containerRepositoryProvider.future);
      if (repo == null) {
        if (mounted) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.errorProxmoxUnknown)),
          );
        }
        return;
      }
      final upid = await invoke(repo);
      if (!mounted) {
        return;
      }
      final status = await ref.read(taskStatusProvider(ct.node, upid).future);
      if (!mounted) {
        return;
      }
      ref.invalidate(allContainersProvider);
      ref.invalidate(taskListProvider);
      await ref.read(allContainersProvider.future);
      if (!mounted) {
        return;
      }
      switch (status) {
        case pve.TaskStatus.ok:
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.powerActionCompleted(successActionLabel)),
            ),
          );
          break;
        case pve.TaskStatus.error:
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.powerActionTaskFailed)),
          );
          break;
        case pve.TaskStatus.running:
        case pve.TaskStatus.unknown:
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.powerActionTaskUnknown)),
          );
          break;
      }
    } catch (e, _) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(proxmoxExceptionMessage(e, l10n))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _powerBusy = false);
      }
    }
  }

  Future<bool?> _confirmStop() async {
    final l10n = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    return showPremiumDialog<bool>(
      context: context,
      title: Text(l10n.powerConfirmStopTitle),
      content: Text(l10n.powerConfirmStopBody, style: tt.bodyMedium),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context, true);
          },
          child: Text(l10n.actionConfirm),
        ),
      ],
    );
  }

  Future<bool?> _confirmForceStop() async {
    final l10n = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return showPremiumDialog<bool>(
      context: context,
      title: Text(l10n.powerConfirmForceStopTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.powerConfirmForceStopBody, style: tt.bodyMedium),
          const SizedBox(height: 12),
          Text(
            l10n.powerConfirmForceStopWarning,
            style: tt.bodyMedium?.copyWith(color: scheme.error),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context, true);
          },
          child: Text(l10n.actionConfirm),
        ),
      ],
    );
  }

  Future<bool?> _confirmReboot() async {
    final l10n = AppLocalizations.of(context)!;
    final tt = Theme.of(context).textTheme;
    return showPremiumDialog<bool>(
      context: context,
      title: Text(l10n.powerConfirmRebootTitle),
      content: Text(l10n.powerConfirmRebootBody, style: tt.bodyMedium),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context, true);
          },
          child: Text(l10n.actionConfirm),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(allContainersProvider);
    final id = int.tryParse(widget.ctid);

    return async.when(
      loading:
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.entityContainer),
              ),
              const Expanded(child: LoadingShimmer(itemCount: 4)),
            ],
          ),
      error:
          (e, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.entityContainer),
              ),
              Expanded(
                child: ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry:
                      () => ref.read(allContainersProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
      data: (containers) {
        if (id == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.entityContainer),
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: l10n.containerNotFoundTitle,
                  message: l10n.containerNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                ),
              ),
            ],
          );
        }

        px.Container? found;
        for (final c in containers) {
          if (c.node == widget.node && c.vmid == id) {
            found = c;
            break;
          }
        }

        if (found == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.entityContainer),
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: l10n.containerNotFoundTitle,
                  message: l10n.containerNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                ),
              ),
            ],
          );
        }

        final ct = found;
        final title =
            ct.name.isEmpty ? '${l10n.labelCtid} ${ct.vmid}' : ct.name;
        final tagColors =
            ref.watch(proxmoxTagColorsProvider).valueOrNull ??
            const <String, String>{};

        final canStart =
            ct.status == px.ContainerStatus.stopped ||
            ct.status == px.ContainerStatus.unknown;
        final canStopOrReboot = ct.status == px.ContainerStatus.running;
        final chartTf = ref.watch(defaultChartTimeframeProvider);
        void setChartTf(ChartTimeframe tf) =>
            ref.read(defaultChartTimeframeProvider.notifier).setTimeframe(tf);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              leading: shellAppBarLeading(context),
              title: Text(l10n.entityContainer),
              actions: [
                IconButton(
                  tooltip: l10n.actionBackup,
                  icon: const Icon(Icons.backup_outlined),
                  onPressed:
                      _powerBusy
                          ? null
                          : () => showTriggerBackupSheet(
                            context,
                            ref,
                            initialGuest: BackupGuestTarget(
                              node: ct.node,
                              vmid: ct.vmid,
                              isLxc: true,
                              displayLabel:
                                  ct.name.isEmpty
                                      ? '${l10n.entityContainer} ${ct.vmid}'
                                      : ct.name,
                            ),
                          ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      ref.read(allContainersProvider.notifier).refresh();
                      await ref.read(allContainersProvider.future);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        _ContainerHeroHeader(
                          ct: ct,
                          title: title,
                          l10n: l10n,
                          clusterTagHexByLabel: tagColors,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        if (canStart || canStopOrReboot) ...[
                          GuestPowerActionIconPills(
                            l10n: l10n,
                            canStart: canStart,
                            canStopOrReboot: canStopOrReboot,
                            busy: _powerBusy,
                            onStart: () {
                              HapticFeedback.lightImpact();
                              _runPowerAction(
                                ct,
                                (r) => r.startContainer(ct.node, ct.vmid),
                                l10n.actionStart,
                              );
                            },
                            onStop: () async {
                              final ok = await _confirmStop();
                              if (ok == true && mounted) {
                                await _runPowerAction(
                                  ct,
                                  (r) => r.shutdownContainer(ct.node, ct.vmid),
                                  l10n.actionStop,
                                );
                              }
                            },
                            onForceStop: () async {
                              final ok = await _confirmForceStop();
                              if (ok == true && mounted) {
                                await _runPowerAction(
                                  ct,
                                  (r) => r.stopContainer(ct.node, ct.vmid),
                                  l10n.actionForceStop,
                                );
                              }
                            },
                            onReboot: () async {
                              final ok = await _confirmReboot();
                              if (ok == true && mounted) {
                                await _runPowerAction(
                                  ct,
                                  (r) => r.rebootContainer(ct.node, ct.vmid),
                                  l10n.actionReboot,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],

                        _ContainerMetricGrid(ct: ct, l10n: l10n),
                        const SizedBox(height: AppSpacing.lg),

                        ChartTimeframeSelector(
                          selected: chartTf,
                          expandToWidth: true,
                          l10n: l10n,
                          onChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ContainerCpuChart(
                          node: ct.node,
                          ctid: ct.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ContainerMemoryChart(
                          node: ct.node,
                          ctid: ct.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ContainerNetworkChart(
                          node: ct.node,
                          ctid: ct.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ContainerDiskIoChart(
                          node: ct.node,
                          ctid: ct.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                  if (_powerBusy) ...[
                    const ModalBarrier(
                      dismissible: false,
                      color: Color(0x66000000),
                    ),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ContainerHeroHeader extends StatelessWidget {
  const _ContainerHeroHeader({
    required this.ct,
    required this.title,
    required this.l10n,
    required this.clusterTagHexByLabel,
  });

  final px.Container ct;
  final String title;
  final AppLocalizations l10n;
  final Map<String, String> clusterTagHexByLabel;

  Color _statusColor(px.ContainerStatus status) => switch (status) {
    px.ContainerStatus.running => AppColors.darkStatusSuccessForeground,
    px.ContainerStatus.stopped => AppColors.darkStatusStoppedForeground,
    px.ContainerStatus.unknown => AppColors.darkStatusStoppedForeground,
  };

  Color _statusBg(px.ContainerStatus status) => switch (status) {
    px.ContainerStatus.running => AppColors.darkStatusSuccessBackground,
    px.ContainerStatus.stopped => AppColors.darkStatusStoppedBackground,
    px.ContainerStatus.unknown => AppColors.darkStatusStoppedBackground,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accent = _statusColor(ct.status);
    final accentBg = _statusBg(ct.status);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.inventory_2_rounded, color: accent, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${l10n.labelCtid} ${ct.vmid}  ·  ${ct.node}',
                  style: tt.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                if (ct.tags.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.sectionGuestTags,
                    style: tt.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ProxmoxTagRow(
                    tags: ct.tags,
                    clusterTagHexByLabel: clusterTagHexByLabel,
                    density: ProxmoxTagDensity.comfortable,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ContainerStatusBadge(status: ct.status),
        ],
      ),
    );
  }
}

class _ContainerMetricGrid extends StatelessWidget {
  const _ContainerMetricGrid({required this.ct, required this.l10n});

  final px.Container ct;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final cells = [
      (l10n.labelCtid, '${ct.vmid}'),
      (l10n.entityNode, ct.node),
      (l10n.metricCpu, formatCpuPercent(ct.cpu)),
      (l10n.metricMemory, formatMemoryRatio(ct.mem, ct.maxMem)),
      (l10n.metricDisk, formatMemoryRatio(ct.disk, ct.maxDisk)),
      (l10n.metricUptime, formatUptimeSeconds(ct.uptime)),
      (l10n.labelContainerOsType, ct.ostype ?? l10n.valueUnavailable),
    ];

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          for (var row = 0; row < cells.length; row += 2) ...[
            if (row > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.35),
              ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _ContainerMetricCell(
                      label: cells[row].$1,
                      value: cells[row].$2,
                      scheme: scheme,
                      tt: tt,
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: scheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                  if (row + 1 < cells.length)
                    Expanded(
                      child: _ContainerMetricCell(
                        label: cells[row + 1].$1,
                        value: cells[row + 1].$2,
                        scheme: scheme,
                        tt: tt,
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ContainerMetricCell extends StatelessWidget {
  const _ContainerMetricCell({
    required this.label,
    required this.value,
    required this.scheme,
    required this.tt,
  });

  final String label;
  final String value;
  final ColorScheme scheme;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: tt.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
