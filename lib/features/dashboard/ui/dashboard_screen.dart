import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/dashboard/providers/rrd_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/chart_card.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';
import 'package:proxdroid/shared/widgets/resource_gauge_row.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';
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

    return ShellSectionBody(
      title: Text(l10n.sectionDashboard),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ── Cluster overview card ────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: _ClusterOverviewCard(
                  nodes: nodes,
                  vms: vms,
                  containers: containers,
                  runningVms: runningVms,
                  onlineNodes: onlineNodes,
                  l10n: l10n,
                  nodeOnline: _nodeOnline,
                ),
              ),
            ),

            // ── Per-node cards ───────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final node = nodes[index];
                  final online = _nodeOnline(node);
                  final cpuFrac = nodeCpuFraction(node.cpu, node.maxCpu);
                  final memFrac = memoryFraction(node.mem, node.maxMem);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _NodeCard(
                      node: node,
                      online: online,
                      cpuFrac: cpuFrac,
                      memFrac: memFrac,
                      l10n: l10n,
                    ),
                  );
                }, childCount: nodes.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Cluster overview card
// ────────────────────────────────────────────────────────────────────────────

class _ClusterOverviewCard extends StatelessWidget {
  const _ClusterOverviewCard({
    required this.nodes,
    required this.vms,
    required this.containers,
    required this.runningVms,
    required this.onlineNodes,
    required this.l10n,
    required this.nodeOnline,
  });

  final List<Node> nodes;
  final List<Vm> vms;
  final List<dynamic> containers;
  final int runningVms;
  final int onlineNodes;
  final AppLocalizations l10n;
  final bool Function(Node) nodeOnline;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allOnline = onlineNodes == nodes.length && nodes.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDark
                ? const Color(0xFF08304A)
                : scheme.primaryContainer.withValues(alpha: 0.6),
            isDark ? const Color(0xFF141820) : scheme.surfaceContainerHigh,
          ],
        ),
        border: Border.all(
          color: scheme.primary.withValues(alpha: isDark ? 0.30 : 0.20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — Header row —
            Row(
              children: [
                Icon(Icons.hub_outlined, size: 16, color: scheme.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.dashboardClusterSummary.toUpperCase(),
                  style: tt.labelSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                // Nodes online indicator
                DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        allOnline
                            ? AppColors.darkStatusSuccessBackground
                            : AppColors.darkStatusStoppedBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          allOnline
                              ? AppColors.darkStatusSuccessForeground
                                  .withValues(alpha: 0.3)
                              : AppColors.darkStatusStoppedForeground
                                  .withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                allOnline
                                    ? AppColors.darkStatusSuccessForeground
                                    : AppColors.darkStatusStoppedForeground,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$onlineNodes/${nodes.length}',
                          style: tt.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color:
                                allOnline
                                    ? AppColors.darkStatusSuccessForeground
                                    : AppColors.darkStatusStoppedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // — Stat grid —
            IntrinsicHeight(
              child: Row(
                children: [
                  _StatCell(
                    value: '${vms.length}',
                    label: l10n.dashboardSummaryTotalVms,
                    scheme: scheme,
                    tt: tt,
                  ),
                  _StatDivider(scheme: scheme),
                  _StatCell(
                    value: '$runningVms',
                    label: l10n.dashboardSummaryRunningVms,
                    scheme: scheme,
                    tt: tt,
                    valueColor:
                        runningVms > 0
                            ? AppColors.darkStatusSuccessForeground
                            : null,
                  ),
                  _StatDivider(scheme: scheme),
                  _StatCell(
                    value: '${containers.length}',
                    label: l10n.dashboardSummaryTotalContainers,
                    scheme: scheme,
                    tt: tt,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.label,
    required this.scheme,
    required this.tt,
    this.valueColor,
  });

  final String value;
  final String label;
  final ColorScheme scheme;
  final TextTheme tt;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: tt.headlineMedium?.copyWith(
              color: valueColor ?? scheme.onSurface,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: tt.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider({required this.scheme});
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 1,
      thickness: 1,
      color: scheme.outlineVariant.withValues(alpha: 0.5),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Node card
// ────────────────────────────────────────────────────────────────────────────

class _NodeCard extends StatelessWidget {
  const _NodeCard({
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
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.dns_rounded, color: statusColor, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.name,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.metricUptime}: ${formatUptimeSeconds(node.uptime)}',
                        style: tt.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
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
            const SizedBox(height: AppSpacing.lg),

            // ── Gauges ────────────────────────────────────────────────
            ResourceGaugeRow(
              label: l10n.metricCpu,
              value: cpuFrac,
              valueSuffix:
                  cpuFrac != null
                      ? formatCpuPercent(cpuFrac)
                      : l10n.valueUnavailable,
            ),
            const SizedBox(height: AppSpacing.md),
            ResourceGaugeRow(
              label: l10n.metricMemory,
              value: memFrac,
              valueSuffix:
                  memFrac != null
                      ? formatMemoryRatio(node.mem, node.maxMem)
                      : l10n.valueUnavailable,
            ),

            // ── Sparklines ────────────────────────────────────────────
            if (online) ...[
              const SizedBox(height: AppSpacing.lg),
              Divider(
                height: 1,
                thickness: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.35),
              ),
              _NodeRrdSparklines(nodeName: node.name),
            ],
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Compact sparklines (node-level RRD, 1 h)
// ────────────────────────────────────────────────────────────────────────────

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
          () => Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ChartCard(
                  title: l10n.metricCpu,
                  compact: true,
                  child: const PulsingPlaceholder(height: 120),
                ),
                const SizedBox(height: AppSpacing.md),
                ChartCard(
                  title: l10n.metricMemory,
                  compact: true,
                  child: const PulsingPlaceholder(height: 120),
                ),
              ],
            ),
          ),
      error:
          (e, _) => Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 16, color: scheme.error),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    proxmoxExceptionMessage(e, l10n),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: scheme.error),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed:
                      () => ref.invalidate(nodeRrdDataProvider(nodeName, _tf)),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                  ),
                  child: Text(l10n.actionRetry),
                ),
              ],
            ),
          ),
      data:
          (points) => Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ChartCard(
                  title: l10n.metricCpu,
                  compact: true,
                  child: ResourceLineChart(
                    data: points,
                    metric: ResourceChartMetric.cpu,
                    primaryColor: scheme.primary,
                    timeframe: _tf,
                    onTimeframeChanged: (_) {},
                    l10n: l10n,
                    compact: true,
                    chartHeight: 120,
                    showTimeframeSelector: false,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ChartCard(
                  title: l10n.metricMemory,
                  compact: true,
                  child: ResourceLineChart(
                    data: points,
                    metric: ResourceChartMetric.memory,
                    primaryColor: scheme.secondary,
                    timeframe: _tf,
                    onTimeframeChanged: (_) {},
                    l10n: l10n,
                    compact: true,
                    chartHeight: 120,
                    showTimeframeSelector: false,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
