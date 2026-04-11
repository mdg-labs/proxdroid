import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/container.dart' as models;
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/backups/ui/trigger_backup_sheet.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/features/dashboard/ui/widgets/node_cpu_chart.dart';
import 'package:proxdroid/features/dashboard/ui/widgets/node_disk_io_chart.dart';
import 'package:proxdroid/features/dashboard/ui/widgets/node_memory_chart.dart';
import 'package:proxdroid/features/dashboard/ui/widgets/node_network_chart.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

/// Merges `GET /nodes/{node}/status` into the cluster resource row for the grid.
Node _mergedNodeForDetailGrid(Node listRow, AsyncValue<Node?> statusAsync) {
  return statusAsync.when(
    data: (status) {
      if (status == null) {
        return listRow;
      }
      return listRow.copyWith(
        status: status.status ?? listRow.status,
        cpu: status.cpu ?? listRow.cpu,
        maxCpu: status.maxCpu ?? listRow.maxCpu,
        mem: status.mem ?? listRow.mem,
        maxMem: status.maxMem ?? listRow.maxMem,
        disk: status.disk ?? listRow.disk,
        maxDisk: status.maxDisk ?? listRow.maxDisk,
        uptime: status.uptime ?? listRow.uptime,
        swapUsed: status.swapUsed ?? listRow.swapUsed,
        swapTotal: status.swapTotal ?? listRow.swapTotal,
        loadavg1m: status.loadavg1m ?? listRow.loadavg1m,
        ioWait: status.ioWait ?? listRow.ioWait,
      );
    },
    loading: () => listRow,
    error: (_, _) => listRow,
  );
}

class NodeDetailScreen extends ConsumerWidget {
  const NodeDetailScreen({required this.nodeName, super.key});

  /// Proxmox node name (decoded route segment).
  final String nodeName;

  bool _nodeOnline(Node n) {
    final s = n.status?.toLowerCase();
    return s == 'online';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(nodeListProvider);

    return async.when(
      loading:
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.nodeDetailTitle),
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
                title: Text(l10n.nodeDetailTitle),
              ),
              Expanded(
                child: ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry: () => ref.read(nodeListProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
      data: (nodes) {
        Node? found;
        for (final n in nodes) {
          if (n.name == nodeName) {
            found = n;
            break;
          }
        }

        if (found == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.nodeDetailTitle),
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.dns_outlined,
                  title: l10n.nodeNotFoundTitle,
                  message: l10n.nodeNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                ),
              ),
            ],
          );
        }

        final chartTf = ref.watch(defaultChartTimeframeProvider);
        void setChartTf(ChartTimeframe tf) =>
            ref.read(defaultChartTimeframeProvider.notifier).setTimeframe(tf);

        final listNode = found;
        final statusAsync = ref.watch(nodeDetailStatusProvider(nodeName));
        final mergedNode = _mergedNodeForDetailGrid(listNode, statusAsync);
        final vms = ref.watch(allVmsProvider).valueOrNull ?? const <Vm>[];
        final containers =
            ref.watch(allContainersProvider).valueOrNull ??
            const <models.Container>[];
        final vmOnNode = vms.where((v) => v.node == listNode.name).toList();
        final vmTotal = vmOnNode.length;
        final vmRunning =
            vmOnNode.where((v) => v.status == VmStatus.running).length;
        final ctOnNode =
            containers.where((c) => c.node == listNode.name).toList();
        final ctTotal = ctOnNode.length;
        final ctRunning =
            ctOnNode
                .where((c) => c.status == models.ContainerStatus.running)
                .length;

        final online = _nodeOnline(listNode);
        final title = listNode.name;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              leading: shellAppBarLeading(context),
              title: Text(l10n.nodeDetailTitle),
              actions: [
                IconButton(
                  tooltip: l10n.actionBackup,
                  icon: const Icon(Icons.backup_outlined),
                  onPressed: () => showTriggerBackupSheet(context, ref),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(nodeDetailStatusProvider(nodeName));
                  ref.read(nodeListProvider.notifier).refresh();
                  ref.read(allVmsProvider.notifier).refresh();
                  ref.read(allContainersProvider.notifier).refresh();
                  await Future.wait([
                    ref.read(nodeListProvider.future),
                    ref.read(nodeDetailStatusProvider(nodeName).future),
                    ref.read(allVmsProvider.future),
                    ref.read(allContainersProvider.future),
                  ]);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _NodeHeroHeader(
                      node: listNode,
                      title: title,
                      online: online,
                      l10n: l10n,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _NodeMetricGrid(
                      node: mergedNode,
                      online: online,
                      vmRunning: vmRunning,
                      vmTotal: vmTotal,
                      ctRunning: ctRunning,
                      ctTotal: ctTotal,
                      l10n: l10n,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ChartTimeframeSelector(
                      selected: chartTf,
                      expandToWidth: true,
                      l10n: l10n,
                      onChanged: setChartTf,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    NodeCpuChart(
                      node: listNode.name,
                      timeframe: chartTf,
                      onTimeframeChanged: setChartTf,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    NodeMemoryChart(
                      node: listNode.name,
                      timeframe: chartTf,
                      onTimeframeChanged: setChartTf,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    NodeNetworkChart(
                      node: listNode.name,
                      timeframe: chartTf,
                      onTimeframeChanged: setChartTf,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    NodeDiskIoChart(
                      node: listNode.name,
                      timeframe: chartTf,
                      onTimeframeChanged: setChartTf,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NodeHeroHeader extends StatelessWidget {
  const _NodeHeroHeader({
    required this.node,
    required this.title,
    required this.online,
    required this.l10n,
  });

  final Node node;
  final String title;
  final bool online;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final statusColor =
        online
            ? AppColors.darkStatusSuccessForeground
            : AppColors.darkStatusStoppedForeground;
    final statusBg =
        online
            ? AppColors.darkStatusSuccessBackground
            : AppColors.darkStatusStoppedBackground;

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
              color: statusBg,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.dns_rounded, color: statusColor, size: 26),
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
                  l10n.entityNode,
                  style: tt.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusBadge(
            label: online ? l10n.statusOnline : l10n.statusOffline,
            variant:
                online
                    ? StatusBadgeVariant.success
                    : StatusBadgeVariant.stopped,
          ),
        ],
      ),
    );
  }
}

class _NodeMetricGrid extends StatelessWidget {
  const _NodeMetricGrid({
    required this.node,
    required this.online,
    required this.vmRunning,
    required this.vmTotal,
    required this.ctRunning,
    required this.ctTotal,
    required this.l10n,
  });

  final Node node;
  final bool online;
  final int vmRunning;
  final int vmTotal;
  final int ctRunning;
  final int ctTotal;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final cpuFrac = nodeCpuFraction(node.cpu, node.maxCpu);
    final statusLabel = online ? l10n.statusOnline : l10n.statusOffline;
    final ioWaitLabel =
        node.ioWait != null
            ? formatCpuPercent(node.ioWait)
            : l10n.valueUnavailable;

    final cells = <(String, String)>[
      (l10n.labelNodeHostStatus, statusLabel),
      (l10n.metricCpu, formatCpuPercent(cpuFrac)),
      (l10n.metricMemory, formatMemoryRatio(node.mem, node.maxMem)),
      (l10n.metricDisk, formatMemoryRatio(node.disk, node.maxDisk)),
      (l10n.metricUptime, formatUptimeSeconds(node.uptime)),
      (l10n.metricLoadAvg1m, formatLoadAvg(node.loadavg1m)),
      (l10n.metricSwap, formatMemoryRatio(node.swapUsed, node.swapTotal)),
      (l10n.metricIoWait, ioWaitLabel),
      (
        l10n.metricGuestVms,
        l10n.nodeDetailRunningTotalCount(vmRunning, vmTotal),
      ),
      (
        l10n.metricGuestContainers,
        l10n.nodeDetailRunningTotalCount(ctRunning, ctTotal),
      ),
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
                    child: _MetricCell(
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
                      child: _MetricCell(
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

class _MetricCell extends StatelessWidget {
  const _MetricCell({
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
