import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/containers/ui/widgets/container_status_badge.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/premium_list_row.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(allContainersProvider);
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> refreshContainers() async {
      ref.read(allContainersProvider.notifier).refresh();
      await ref.read(allContainersProvider.future);
    }

    return ShellSectionBody(
      title: Text(l10n.sectionContainers),
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: l10n.searchContainersHint,
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                          ),
                          onChanged: (v) => setState(() => _searchQuery = v),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: l10n.filterByStatus,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<_ContainerStatusFilter>(
                                    isExpanded: true,
                                    value: _statusFilter,
                                    items: [
                                      DropdownMenuItem(
                                        value: _ContainerStatusFilter.all,
                                        child: Text(l10n.filterAll),
                                      ),
                                      DropdownMenuItem(
                                        value: _ContainerStatusFilter.running,
                                        child: Text(l10n.filterRunning),
                                      ),
                                      DropdownMenuItem(
                                        value: _ContainerStatusFilter.stopped,
                                        child: Text(l10n.filterStopped),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() => _statusFilter = v);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: l10n.filterByNode,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String?>(
                                    isExpanded: true,
                                    value: _nodeFilter,
                                    items: [
                                      DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text(l10n.filterAll),
                                      ),
                                      ...nodes.map(
                                        (n) => DropdownMenuItem(
                                          value: n,
                                          child: Text(n),
                                        ),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      setState(() => _nodeFilter = v);
                                    },
                                  ),
                                ),
                              ),
                            ),
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final ct = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: Card(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.antiAlias,
                          child: PremiumListRow(
                            title: Text(
                              ct.name.isEmpty
                                  ? '${l10n.labelCtid} ${ct.vmid}'
                                  : ct.name,
                            ),
                            subtitle: Text(
                              '${l10n.labelCtid} ${ct.vmid} · ${l10n.entityNode} ${ct.node}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ContainerStatusBadge(status: ct.status),
                                const SizedBox(height: 4),
                                Text(
                                  formatCpuPercent(ct.cpu),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  formatMemoryRatio(ct.mem, ct.maxMem),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            showChevron: true,
                            showDividerBelow: false,
                            onTap:
                                () => context.push(
                                  '/containers/${Uri.encodeComponent(ct.node)}/${Uri.encodeComponent(ct.vmid.toString())}',
                                ),
                          ),
                        ),
                      );
                    }, childCount: filtered.length),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
