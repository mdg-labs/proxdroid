import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/features/vms/ui/widgets/vm_status_badge.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

enum _VmStatusFilter { all, running, stopped }

class VmListScreen extends ConsumerStatefulWidget {
  const VmListScreen({super.key});

  @override
  ConsumerState<VmListScreen> createState() => _VmListScreenState();
}

class _VmListScreenState extends ConsumerState<VmListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  _VmStatusFilter _statusFilter = _VmStatusFilter.all;
  String? _nodeFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _compareVm(Vm a, Vm b) {
    final aActive = a.status == VmStatus.running || a.status == VmStatus.paused;
    final bActive = b.status == VmStatus.running || b.status == VmStatus.paused;
    if (aActive != bActive) {
      return aActive ? -1 : 1;
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }

  List<Vm> _applyFilters(List<Vm> vms) {
    var out = List<Vm>.from(vms);

    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      out = out.where((v) => v.name.toLowerCase().contains(q)).toList();
    }

    switch (_statusFilter) {
      case _VmStatusFilter.all:
        break;
      case _VmStatusFilter.running:
        out =
            out
                .where(
                  (v) =>
                      v.status == VmStatus.running ||
                      v.status == VmStatus.paused,
                )
                .toList();
      case _VmStatusFilter.stopped:
        out = out.where((v) => v.status == VmStatus.stopped).toList();
    }

    if (_nodeFilter != null) {
      out = out.where((v) => v.node == _nodeFilter).toList();
    }

    out.sort(_compareVm);
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final async = ref.watch(allVmsProvider);
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> refreshVms() async {
      ref.read(allVmsProvider.notifier).refresh();
      await ref.read(allVmsProvider.future);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.sectionVms),
        ),
        Expanded(
          child: async.when(
            loading:
                () => RefreshIndicator(
                  onRefresh: refreshVms,
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
                  onRefresh: refreshVms,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: minPullHeight,
                        child: ErrorView(
                          message: proxmoxExceptionMessage(e, l10n),
                          onRetry:
                              () => ref.read(allVmsProvider.notifier).refresh(),
                        ),
                      ),
                    ],
                  ),
                ),
            data: (vms) {
              if (vms.isEmpty) {
                return RefreshIndicator(
                  onRefresh: refreshVms,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: minPullHeight,
                        child: EmptyState(
                          icon: Icons.computer_outlined,
                          title: l10n.vmListEmptyTitle,
                          message: l10n.vmListEmptyMessage,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final nodes = vms.map((v) => v.node).toSet().toList()..sort();
              final filtered = _applyFilters(vms);

              return RefreshIndicator(
                onRefresh: refreshVms,
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
                                hintText: l10n.searchVmsHint,
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged:
                                  (v) => setState(() => _searchQuery = v),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: l10n.filterByStatus,
                                      border: const OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<_VmStatusFilter>(
                                        isExpanded: true,
                                        value: _statusFilter,
                                        items: [
                                          DropdownMenuItem(
                                            value: _VmStatusFilter.all,
                                            child: Text(l10n.filterAll),
                                          ),
                                          DropdownMenuItem(
                                            value: _VmStatusFilter.running,
                                            child: Text(l10n.filterRunning),
                                          ),
                                          DropdownMenuItem(
                                            value: _VmStatusFilter.stopped,
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
                                      border: const OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                          final vm = filtered[index];
                          return ListTile(
                            title: Text(
                              vm.name.isEmpty
                                  ? '${l10n.labelVmid} ${vm.vmid}'
                                  : vm.name,
                            ),
                            subtitle: Text(
                              '${l10n.labelVmid} ${vm.vmid} · ${l10n.entityNode} ${vm.node}',
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                VmStatusBadge(status: vm.status),
                                const SizedBox(height: 4),
                                Text(
                                  formatCpuPercent(vm.cpu),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  formatMemoryRatio(vm.mem, vm.maxMem),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            onTap:
                                () => context.push(
                                  '/vms/${Uri.encodeComponent(vm.node)}/${Uri.encodeComponent(vm.vmid.toString())}',
                                ),
                          );
                        }, childCount: filtered.length),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
