import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _refreshAll(WidgetRef ref) {
    ref.read(nodeListProvider.notifier).refresh();
    ref.read(allVmsProvider.notifier).refresh();
    ref.read(allContainersProvider.notifier).refresh();
  }

  bool _nodeOnline(Node node) {
    final s = node.status?.toLowerCase();
    return s == 'online';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final nodesAsync = ref.watch(nodeListProvider);
    final vmsAsync = ref.watch(allVmsProvider);
    final containersAsync = ref.watch(allContainersProvider);

    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> pullRefresh() async {
      _refreshAll(ref);
      await ref.read(nodeListProvider.future);
      await ref.read(allVmsProvider.future);
      await ref.read(allContainersProvider.future);
    }

    if (nodesAsync.hasError || vmsAsync.hasError || containersAsync.hasError) {
      final err = nodesAsync.error ?? vmsAsync.error ?? containersAsync.error!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.sectionDashboard),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: pullRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: ErrorView(
                      message: proxmoxExceptionMessage(err, l10n),
                      onRetry: () => _refreshAll(ref),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (!nodesAsync.hasValue ||
        !vmsAsync.hasValue ||
        !containersAsync.hasValue) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.sectionDashboard),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: pullRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: const LoadingShimmer(
                      itemCount: 6,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final nodes = nodesAsync.requireValue;
    final vms = vmsAsync.requireValue;
    final containers = containersAsync.requireValue;

    final runningVms =
        vms
            .where(
              (v) =>
                  v.status == VmStatus.running || v.status == VmStatus.paused,
            )
            .length;

    if (nodes.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.sectionDashboard),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: pullRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: EmptyState(
                      icon: Icons.dns_outlined,
                      title: l10n.dashboardEmptyNodesTitle,
                      message: l10n.dashboardEmptyNodesMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.sectionDashboard),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: pullRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dashboardClusterSummary,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            _SummaryRow(
                              label: l10n.dashboardSummaryTotalVms,
                              value: '${vms.length}',
                            ),
                            _SummaryRow(
                              label: l10n.dashboardSummaryRunningVms,
                              value: '$runningVms',
                            ),
                            _SummaryRow(
                              label: l10n.dashboardSummaryTotalContainers,
                              value: '${containers.length}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final node = nodes[index];
                      final online = _nodeOnline(node);
                      final cpuFrac = nodeCpuFraction(node.cpu, node.maxCpu);
                      final memFrac = memoryFraction(node.mem, node.maxMem);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        node.name,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                    ),
                                    StatusBadge(
                                      label:
                                          online
                                              ? l10n.statusOnline
                                              : l10n.statusOffline,
                                      variant:
                                          online
                                              ? StatusBadgeVariant.success
                                              : StatusBadgeVariant.error,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${l10n.metricUptime}: ${formatUptimeSeconds(node.uptime)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.metricCpu,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(height: 4),
                                if (cpuFrac != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: cpuFrac,
                                      minHeight: 8,
                                    ),
                                  )
                                else
                                  Text(
                                    l10n.valueUnavailable,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                if (cpuFrac != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    formatCpuPercent(cpuFrac),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Text(
                                  l10n.metricMemory,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                const SizedBox(height: 4),
                                if (memFrac != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: memFrac,
                                      minHeight: 8,
                                    ),
                                  )
                                else
                                  Text(
                                    l10n.valueUnavailable,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                if (memFrac != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    formatMemoryRatio(node.mem, node.maxMem),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                                if (online) ...[
                                  const SizedBox(height: 16),
                                  _NodeRrdSparklines(nodeName: node.name),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: nodes.length),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact CPU + memory line charts from node-level rrddata (1h, no selector).
class _NodeRrdSparklines extends ConsumerWidget {
  const _NodeRrdSparklines({required this.nodeName});

  final String nodeName;

  static const _tf = ChartTimeframe.hour;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(nodeRrdDataProvider(nodeName, _tf));

    return async.when(
      loading:
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.metricCpu,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    const PulsingPlaceholder(height: 88),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.metricMemory,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    const PulsingPlaceholder(height: 88),
                  ],
                ),
              ),
            ],
          ),
      error:
          (e, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.metricCpu,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.metricMemory,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Icon(Icons.error_outline, size: 28, color: scheme.error),
              const SizedBox(height: 8),
              Text(
                proxmoxExceptionMessage(e, l10n),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: scheme.onSurface),
              ),
              TextButton.icon(
                onPressed:
                    () => ref.invalidate(nodeRrdDataProvider(nodeName, _tf)),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.actionRetry),
              ),
            ],
          ),
      data:
          (points) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.metricCpu,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    ResourceLineChart(
                      data: points,
                      metric: ResourceChartMetric.cpu,
                      primaryColor: scheme.primary,
                      timeframe: _tf,
                      onTimeframeChanged: (_) {},
                      l10n: l10n,
                      compact: true,
                      chartHeight: 88,
                      showTimeframeSelector: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.metricMemory,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    ResourceLineChart(
                      data: points,
                      metric: ResourceChartMetric.memory,
                      primaryColor: scheme.secondary,
                      timeframe: _tf,
                      onTimeframeChanged: (_) {},
                      l10n: l10n,
                      compact: true,
                      chartHeight: 88,
                      showTimeframeSelector: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
