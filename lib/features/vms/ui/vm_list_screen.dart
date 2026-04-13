import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/features/vms/ui/widgets/vm_status_badge.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/proxmox_tag_colors_provider.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/node_filter_dropdown.dart';
import 'package:proxdroid/shared/widgets/proxmox_tag_widgets.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';

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
    if (aActive != bActive) return aActive ? -1 : 1;
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
    final tt = Theme.of(context).textTheme;
    final async = ref.watch(allVmsProvider);
    final tagColorMap =
        ref.watch(proxmoxTagColorsProvider).valueOrNull ??
        const <String, String>{};
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> refreshVms() async {
      ref.read(allVmsProvider.notifier).refresh();
      await ref.read(allVmsProvider.future);
    }

    return ShellSectionBody(
      title: Text(l10n.sectionVms),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.guestCreateFabVm,
        onPressed: () {
          final q =
              _nodeFilter != null
                  ? '?node=${Uri.encodeComponent(_nodeFilter!)}'
                  : '';
          context.push('/vms/create$q');
        },
        child: const Icon(Icons.add),
      ),
      body: async.when(
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
                // ── Search + filters ─────────────────────────────────────
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
                        // Search bar
                        SearchBar(
                          controller: _searchController,
                          hintText: l10n.searchVmsHint,
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
                            scheme.surfaceContainerHigh,
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: scheme.outlineVariant.withValues(
                                  alpha: 0.28,
                                ),
                              ),
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
                        // Status filter chips
                        Row(
                          children: [
                            Expanded(
                              child: SegmentedButton<_VmStatusFilter>(
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
                                    value: _VmStatusFilter.all,
                                    label: Text(l10n.filterAll),
                                  ),
                                  ButtonSegment(
                                    value: _VmStatusFilter.running,
                                    label: Text(l10n.filterRunning),
                                  ),
                                  ButtonSegment(
                                    value: _VmStatusFilter.stopped,
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

                // ── VM list ───────────────────────────────────────────────
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
                        final vm = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _VmListTile(
                            vm: vm,
                            clusterTagHexByLabel: tagColorMap,
                            l10n: l10n,
                            scheme: scheme,
                            tt: tt,
                            onTap:
                                () => context.push(
                                  '/vms/${Uri.encodeComponent(vm.node)}/${Uri.encodeComponent(vm.vmid.toString())}',
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

// ────────────────────────────────────────────────────────────────────────────
// VM list tile
// ────────────────────────────────────────────────────────────────────────────

class _VmListTile extends StatelessWidget {
  const _VmListTile({
    required this.vm,
    required this.clusterTagHexByLabel,
    required this.l10n,
    required this.scheme,
    required this.tt,
    required this.onTap,
  });

  final Vm vm;
  final Map<String, String> clusterTagHexByLabel;
  final AppLocalizations l10n;
  final ColorScheme scheme;
  final TextTheme tt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = vm.name.isEmpty ? '${l10n.labelVmid} ${vm.vmid}' : vm.name;

    final strip = scheme.primary.withValues(alpha: 0.35);

    return Material(
      color: scheme.surfaceContainer,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: strip),
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
                    color: scheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.computer_rounded,
                    color: scheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              // Text content
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
                        '${l10n.labelVmid} ${vm.vmid}  ·  ${vm.node}',
                        style: tt.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (vm.tags.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        ProxmoxTagRow(
                          tags: vm.tags,
                          clusterTagHexByLabel: clusterTagHexByLabel,
                          density: ProxmoxTagDensity.compact,
                          spacing: 5,
                        ),
                      ],
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            formatCpuPercent(vm.cpu),
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
                            formatMemoryRatio(vm.mem, vm.maxMem),
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
              // Trailing: badge + chevron
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    VmStatusBadge(status: vm.status),
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
