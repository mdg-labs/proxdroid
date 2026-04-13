import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';
import 'package:proxdroid/shared/widgets/resource_gauge_row.dart';
import 'package:proxdroid/shared/widgets/section_header.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _refreshAll(WidgetRef ref) {
    ref.read(nodeListProvider.notifier).refresh();
    ref.read(allVmsProvider.notifier).refresh();
    ref.read(allContainersProvider.notifier).refresh();
    final tf = ref.read(defaultChartTimeframeProvider);
    ref.invalidate(clusterAggregatedNodeRrdProvider(tf));
  }

  bool _nodeOnline(Node node) {
    final s = node.status?.toLowerCase();
    return s == 'online';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

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
      return ShellSectionBody(
        title: Text(l10n.sectionDashboard),
        body: RefreshIndicator(
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
      );
    }

    if (!nodesAsync.hasValue ||
        !vmsAsync.hasValue ||
        !containersAsync.hasValue) {
      return ShellSectionBody(
        title: Text(l10n.sectionDashboard),
        body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: minPullHeight,
                child: LoadingShimmer(
                  itemCount: 6,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
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
    final onlineNodes = nodes.where(_nodeOnline).length;

    if (nodes.isEmpty) {
      return ShellSectionBody(
        title: Text(l10n.sectionDashboard),
        body: RefreshIndicator(
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
      );
    }

    final chartTf = ref.watch(defaultChartTimeframeProvider);
    void setChartTf(ChartTimeframe tf) =>
        ref.read(defaultChartTimeframeProvider.notifier).setTimeframe(tf);

    return ShellSectionBody(
      title: Text(l10n.sectionDashboard),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _SummaryTileRow(
                  runningVms: runningVms,
                  lxcCount: containers.length,
                  onlineNodes: onlineNodes,
                  totalNodes: nodes.length,
                  l10n: l10n,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _ClusterCpuRamCard(
                  l10n: l10n,
                  chartTf: chartTf,
                  onTimeframeChanged: setChartTf,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: l10n.entityNode,
                variant: SectionHeaderVariant.muted,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.crossAxisExtent;
                  final crossAxisCount = w >= 640 ? 2 : 1;
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisExtent: 132,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final node = nodes[index];
                      final online = _nodeOnline(node);
                      final cpuFrac = nodeCpuFraction(node.cpu, node.maxCpu);
                      final memFrac = memoryFraction(node.mem, node.maxMem);
                      return Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap:
                              () => context.push(
                                '/dashboard/${Uri.encodeComponent(node.name)}',
                              ),
                          child: _DashboardNodeCard(
                            node: node,
                            online: online,
                            cpuFrac: cpuFrac,
                            memFrac: memFrac,
                            l10n: l10n,
                          ),
                        ),
                      );
                    }, childCount: nodes.length),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTileRow extends StatelessWidget {
  const _SummaryTileRow({
    required this.runningVms,
    required this.lxcCount,
    required this.onlineNodes,
    required this.totalNodes,
    required this.l10n,
  });

  final int runningVms;
  final int lxcCount;
  final int onlineNodes;
  final int totalNodes;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _SummaryTile(
            value: '$runningVms',
            label: l10n.dashboardSummaryRunningVms,
            icon: Icons.play_circle_outline_rounded,
            scheme: scheme,
            tt: tt,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryTile(
            value: '$lxcCount',
            label: l10n.dashboardSummaryTotalContainers,
            icon: Icons.inventory_2_outlined,
            scheme: scheme,
            tt: tt,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryTile(
            value: '$onlineNodes/$totalNodes',
            label: l10n.dashboardSummaryOnlineNodes,
            icon: Icons.hub_outlined,
            scheme: scheme,
            tt: tt,
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.scheme,
    required this.tt,
  });

  final String value;
  final String label;
  final IconData icon;
  final ColorScheme scheme;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.05,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: tt.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 10,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: 36,
                height: 36,
                child: Icon(icon, size: 20, color: scheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClusterCpuRamCard extends ConsumerWidget {
  const _ClusterCpuRamCard({
    required this.l10n,
    required this.chartTf,
    required this.onTimeframeChanged,
  });

  final AppLocalizations l10n;
  final ChartTimeframe chartTf;
  final ValueChanged<ChartTimeframe> onTimeframeChanged;

  static bool _hasPlottableSeries(List<ResourceDataPoint> points) {
    for (final p in points) {
      if (p.cpu != null || p.mem != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final async = ref.watch(clusterAggregatedNodeRrdProvider(chartTf));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.dashboardClusterSummary,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ChartTimeframeSelector(
              selected: chartTf,
              expandToWidth: true,
              l10n: l10n,
              onChanged: onTimeframeChanged,
            ),
            const SizedBox(height: AppSpacing.md),
            async.when(
              loading:
                  () => const SizedBox(
                    height: 200,
                    child: PulsingPlaceholder(height: 200),
                  ),
              error:
                  (e, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        proxmoxExceptionMessage(e, l10n),
                        style: tt.bodySmall?.copyWith(color: scheme.error),
                      ),
                      TextButton(
                        onPressed:
                            () => ref.invalidate(
                              clusterAggregatedNodeRrdProvider(chartTf),
                            ),
                        child: Text(l10n.actionRetry),
                      ),
                    ],
                  ),
              data: (points) {
                if (points.isEmpty || !_hasPlottableSeries(points)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      l10n.chartNoData,
                      textAlign: TextAlign.center,
                      style: tt.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _LegendDot(
                          color: scheme.primary,
                          label: l10n.metricCpu,
                          tt: tt,
                          scheme: scheme,
                        ),
                        _LegendDot(
                          color: scheme.secondary,
                          label: l10n.metricMemory,
                          tt: tt,
                          scheme: scheme,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ResourceLineChart(
                      data: points,
                      metric: ResourceChartMetric.cpu,
                      primaryColor: scheme.primary,
                      timeframe: chartTf,
                      onTimeframeChanged: onTimeframeChanged,
                      l10n: l10n,
                      compact: true,
                      chartHeight: 132,
                      showTimeframeSelector: false,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ResourceLineChart(
                      data: points,
                      metric: ResourceChartMetric.memory,
                      primaryColor: scheme.secondary,
                      timeframe: chartTf,
                      onTimeframeChanged: onTimeframeChanged,
                      l10n: l10n,
                      compact: true,
                      chartHeight: 132,
                      showTimeframeSelector: false,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    required this.tt,
    required this.scheme,
  });

  final Color color;
  final String label;
  final TextTheme tt;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: tt.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _DashboardNodeCard extends StatelessWidget {
  const _DashboardNodeCard({
    required this.node,
    required this.online,
    required this.cpuFrac,
    required this.memFrac,
    required this.l10n,
  });

  final Node node;
  final bool online;
  final double? cpuFrac;
  final double? memFrac;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accent = online ? scheme.primary : scheme.tertiary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 4, color: accent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.dns_rounded,
                            size: 20,
                            color:
                                online
                                    ? scheme.primary
                                    : scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node.name,
                              style: tt.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            ResourceGaugeRow(
                              label: l10n.metricCpu,
                              value: cpuFrac,
                              valueSuffix:
                                  cpuFrac != null
                                      ? formatCpuPercent(cpuFrac)
                                      : l10n.valueUnavailable,
                            ),
                            const SizedBox(height: 4),
                            ResourceGaugeRow(
                              label: l10n.metricMemory,
                              value: memFrac,
                              valueSuffix:
                                  memFrac != null
                                      ? formatMemoryRatio(node.mem, node.maxMem)
                                      : l10n.valueUnavailable,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        formatUptimeSeconds(node.uptime),
                        style: tt.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
