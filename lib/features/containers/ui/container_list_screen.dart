import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/containers/ui/widgets/container_status_badge.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/proxmox_tag_colors_provider.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/node_filter_dropdown.dart';
import 'package:proxdroid/shared/widgets/proxmox_tag_widgets.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';

enum _ContainerStatusFilter { all, running, stopped }

class ContainerListScreen extends ConsumerStatefulWidget {
  const ContainerListScreen({super.key});

  @override
  ConsumerState<ContainerListScreen> createState() =>
      _ContainerListScreenState();
}

class _ContainerListScreenState extends ConsumerState<ContainerListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  _ContainerStatusFilter _statusFilter = _ContainerStatusFilter.all;
  String? _nodeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _compareContainer(px.Container a, px.Container b) {
    final aActive = a.status == px.ContainerStatus.running;
    final bActive = b.status == px.ContainerStatus.running;
    if (aActive != bActive) {
      return aActive ? -1 : 1;
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }

  List<px.Container> _applyFilters(List<px.Container> list) {
    var out = List<px.Container>.from(list);

    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      out = out.where((c) => c.name.toLowerCase().contains(q)).toList();
    }

    switch (_statusFilter) {
      case _ContainerStatusFilter.all:
        break;
      case _ContainerStatusFilter.running:
        out = out.where((c) => c.status == px.ContainerStatus.running).toList();
      case _ContainerStatusFilter.stopped:
        out = out.where((c) => c.status == px.ContainerStatus.stopped).toList();
    }

    if (_nodeFilter != null) {
      out = out.where((c) => c.node == _nodeFilter).toList();
    }

    out.sort(_compareContainer);
    return out;
  }

  Color _containerStatusAccent(px.ContainerStatus status) {
    return switch (status) {
      px.ContainerStatus.running => AppColors.darkStatusSuccessForeground,
      px.ContainerStatus.stopped => AppColors.darkStatusStoppedForeground,
      px.ContainerStatus.unknown => AppColors.darkStatusStoppedForeground,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final async = ref.watch(allContainersProvider);
    final tagColorMap =
        ref.watch(proxmoxTagColorsProvider).valueOrNull ??
        const <String, String>{};
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> refreshContainers() async {
      ref.read(allContainersProvider.notifier).refresh();
      await ref.read(allContainersProvider.future);
    }

    return ShellSectionBody(
      title: Text(l10n.sectionContainers),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.guestCreateFabCt,
        onPressed: () {
          final q =
              _nodeFilter != null
                  ? '?node=${Uri.encodeComponent(_nodeFilter!)}'
                  : '';
          context.push('/containers/create$q');
        },
        child: const Icon(Icons.add),
      ),
      body: async.when(
        loading:
            () => RefreshIndicator(
              onRefresh: refreshContainers,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: const LoadingShimmer(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
            ),
        error:
            (e, _) => RefreshIndicator(
              onRefresh: refreshContainers,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: ErrorView(
                      message: proxmoxExceptionMessage(e, l10n),
                      onRetry:
                          () =>
                              ref
                                  .read(allContainersProvider.notifier)
                                  .refresh(),
                    ),
                  ),
                ],
              ),
            ),
        data: (containers) {
          if (containers.isEmpty) {
            return RefreshIndicator(
              onRefresh: refreshContainers,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: minPullHeight,
                    child: EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: l10n.containerListEmptyTitle,
                      message: l10n.containerListEmptyMessage,
                    ),
                  ),
                ],
              ),
            );
          }

          final nodes = containers.map((c) => c.node).toSet().toList()..sort();
          final filtered = _applyFilters(containers);

          return RefreshIndicator(
            onRefresh: refreshContainers,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SearchBar(
                          controller: _searchController,
                          hintText: l10n.searchContainersHint,
                          leading: Icon(
                            Icons.search,
                            color: scheme.onSurfaceVariant,
                            size: 20,
                          ),
                          trailing:
                              _searchQuery.isNotEmpty
                                  ? [
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      onPressed:
                                          () => setState(() {
                                            _searchController.clear();
                                            _searchQuery = '';
                                          }),
                                    ),
                                  ]
                                  : null,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          elevation: const WidgetStatePropertyAll(0),
                          backgroundColor: WidgetStatePropertyAll(
                            scheme.surfaceContainerHighest,
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: scheme.outlineVariant),
                            ),
                          ),
                          padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 12),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            tt.bodyMedium?.copyWith(color: scheme.onSurface),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: SegmentedButton<_ContainerStatusFilter>(
                                style: ButtonStyle(
                                  visualDensity: VisualDensity.compact,
                                  textStyle: WidgetStatePropertyAll(
                                    tt.labelSmall,
                                  ),
                                  padding: const WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                ),
                                segments: [
                                  ButtonSegment(
                                    value: _ContainerStatusFilter.all,
                                    label: Text(l10n.filterAll),
                                  ),
                                  ButtonSegment(
                                    value: _ContainerStatusFilter.running,
                                    label: Text(l10n.filterRunning),
                                  ),
                                  ButtonSegment(
                                    value: _ContainerStatusFilter.stopped,
                                    label: Text(l10n.filterStopped),
                                  ),
                                ],
                                selected: {_statusFilter},
                                onSelectionChanged:
                                    (s) =>
                                        setState(() => _statusFilter = s.first),
                              ),
                            ),
                            if (nodes.length > 1) ...[
                              const SizedBox(width: AppSpacing.sm),
                              NodeFilterDropdown(
                                nodes: nodes,
                                selected: _nodeFilter,
                                allLabel: l10n.filterAll,
                                filterByNodeLabel: l10n.filterByNode,
                                onChanged:
                                    (v) => setState(() => _nodeFilter = v),
                                scheme: scheme,
                                tt: tt,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.filter_alt_off_outlined,
                      title: l10n.listFilteredEmptyTitle,
                      message: l10n.listFilteredEmptyMessage,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final ct = filtered[index];
                        final accent = _containerStatusAccent(ct.status);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _ContainerListTile(
                            container: ct,
                            accent: accent,
                            clusterTagHexByLabel: tagColorMap,
                            l10n: l10n,
                            scheme: scheme,
                            tt: tt,
                            onTap:
                                () => context.push(
                                  '/containers/${Uri.encodeComponent(ct.node)}/${Uri.encodeComponent(ct.vmid.toString())}',
                                ),
                          ),
                        );
                      }, childCount: filtered.length),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ContainerListTile extends StatelessWidget {
  const _ContainerListTile({
    required this.container,
    required this.accent,
    required this.clusterTagHexByLabel,
    required this.l10n,
    required this.scheme,
    required this.tt,
    required this.onTap,
  });

  final px.Container container;
  final Color accent;
  final Map<String, String> clusterTagHexByLabel;
  final AppLocalizations l10n;
  final ColorScheme scheme;
  final TextTheme tt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name =
        container.name.isEmpty
            ? '${l10n.labelCtid} ${container.vmid}'
            : container.name;

    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: accent),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                ),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.inventory_2_rounded,
                    color: accent,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${l10n.labelCtid} ${container.vmid}  ·  ${container.node}',
                        style: tt.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (container.tags.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        ProxmoxTagRow(
                          tags: container.tags,
                          clusterTagHexByLabel: clusterTagHexByLabel,
                          density: ProxmoxTagDensity.compact,
                          spacing: 5,
                        ),
                      ],
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            formatCpuPercent(container.cpu),
                            style: tt.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '  ·  ',
                            style: tt.labelSmall?.copyWith(
                              color: scheme.outlineVariant,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            formatMemoryRatio(container.mem, container.maxMem),
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ContainerStatusBadge(status: container.status),
                    const SizedBox(height: AppSpacing.xs),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: scheme.outlineVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
