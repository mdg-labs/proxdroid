import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/task.dart' as pve;
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/backups/ui/trigger_backup_sheet.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/features/vms/data/vm_repository.dart';
import 'package:proxdroid/features/settings/providers/settings_providers.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/features/vms/ui/widgets/cpu_chart.dart';
import 'package:proxdroid/features/vms/ui/widgets/disk_io_chart.dart';
import 'package:proxdroid/features/vms/ui/widgets/memory_chart.dart';
import 'package:proxdroid/features/vms/ui/widgets/network_chart.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/proxmox_tag_colors_provider.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/guest_instrument_metric_grid.dart';
import 'package:proxdroid/shared/widgets/guest_power_action_icon_pills.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';
import 'package:proxdroid/shared/widgets/proxmox_tag_widgets.dart';
import 'package:proxdroid/shared/widgets/resource_chart.dart';
import 'package:proxdroid/shared/widgets/compact_labeled_app_bar_action.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class VmDetailScreen extends ConsumerStatefulWidget {
  const VmDetailScreen({required this.node, required this.vmid, super.key});

  final String node;
  final String vmid;

  @override
  ConsumerState<VmDetailScreen> createState() => _VmDetailScreenState();
}

class _VmDetailScreenState extends ConsumerState<VmDetailScreen> {
  bool _powerBusy = false;

  Future<void> _runPowerAction(
    Vm vm,
    Future<String> Function(VmRepository repo) invoke,
    String successActionLabel,
  ) async {
    if (!mounted) {
      return;
    }
    setState(() => _powerBusy = true);
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repo = await ref.read(vmRepositoryProvider.future);
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
      final status = await ref.read(taskStatusProvider(vm.node, upid).future);
      if (!mounted) {
        return;
      }
      ref.invalidate(allVmsProvider);
      ref.invalidate(taskListProvider);
      await ref.read(allVmsProvider.future);
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
    final async = ref.watch(allVmsProvider);
    final id = int.tryParse(widget.vmid);

    return async.when(
      loading:
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.entityVirtualMachine),
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
                title: Text(l10n.entityVirtualMachine),
              ),
              Expanded(
                child: ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry: () => ref.read(allVmsProvider.notifier).refresh(),
                ),
              ),
            ],
          ),
      data: (vms) {
        if (id == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.entityVirtualMachine),
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: l10n.vmNotFoundTitle,
                  message: l10n.vmNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                ),
              ),
            ],
          );
        }

        Vm? found;
        for (final v in vms) {
          if (v.node == widget.node && v.vmid == id) {
            found = v;
            break;
          }
        }

        if (found == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBar(
                leading: shellAppBarLeading(context),
                title: Text(l10n.entityVirtualMachine),
              ),
              Expanded(
                child: EmptyState(
                  icon: Icons.computer_outlined,
                  title: l10n.vmNotFoundTitle,
                  message: l10n.vmNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                ),
              ),
            ],
          );
        }

        final vm = found;
        final title =
            vm.name.isEmpty ? '${l10n.labelVmid} ${vm.vmid}' : vm.name;
        final tagColors =
            ref.watch(proxmoxTagColorsProvider).valueOrNull ??
            const <String, String>{};

        final canStart =
            vm.status == VmStatus.stopped || vm.status == VmStatus.unknown;
        final canStopOrReboot =
            vm.status == VmStatus.running || vm.status == VmStatus.paused;
        final chartTf = ref.watch(defaultChartTimeframeProvider);
        void setChartTf(ChartTimeframe tf) =>
            ref.read(defaultChartTimeframeProvider.notifier).setTimeframe(tf);

        final scheme = Theme.of(context).colorScheme;
        final tt = Theme.of(context).textTheme;
        final statusLabel = _vmStatusLabel(vm, l10n);
        final appBarSubtitle =
            '$statusLabel · ${vm.node} · ${l10n.labelVmid} ${vm.vmid}';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              leading: shellAppBarLeading(context),
              titleSpacing: AppSpacing.sm,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    appBarSubtitle,
                    style: tt.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: [
                CompactLabeledAppBarAction(
                  icon: Icons.edit_outlined,
                  label: l10n.actionEditGuestConfig,
                  tooltip: l10n.actionEditGuestConfig,
                  maxLabelWidth: 72,
                  onPressed:
                      _powerBusy
                          ? null
                          : () => context.push(
                            '/vms/${Uri.encodeComponent(vm.node)}/${Uri.encodeComponent(vm.vmid.toString())}/edit',
                          ),
                ),
                CompactLabeledAppBarAction(
                  icon: Icons.backup_outlined,
                  label: l10n.actionBackup,
                  tooltip: l10n.actionBackup,
                  maxLabelWidth: 56,
                  onPressed:
                      _powerBusy
                          ? null
                          : () => showTriggerBackupSheet(
                            context,
                            ref,
                            initialGuest: BackupGuestTarget(
                              node: vm.node,
                              vmid: vm.vmid,
                              isLxc: false,
                              displayLabel:
                                  vm.name.isEmpty
                                      ? '${l10n.entityVirtualMachine} ${vm.vmid}'
                                      : vm.name,
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
                      ref.read(allVmsProvider.notifier).refresh();
                      await ref.read(allVmsProvider.future);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        if (canStart || canStopOrReboot) ...[
                          GuestPowerActionIconPills(
                            l10n: l10n,
                            canStart: canStart,
                            canStopOrReboot: canStopOrReboot,
                            busy: _powerBusy,
                            onStart: () {
                              HapticFeedback.lightImpact();
                              _runPowerAction(
                                vm,
                                (r) => r.startVm(vm.node, vm.vmid),
                                l10n.actionStart,
                              );
                            },
                            onStop: () async {
                              final ok = await _confirmStop();
                              if (ok == true && mounted) {
                                await _runPowerAction(
                                  vm,
                                  (r) => r.shutdownVm(vm.node, vm.vmid),
                                  l10n.actionStop,
                                );
                              }
                            },
                            onForceStop: () async {
                              final ok = await _confirmForceStop();
                              if (ok == true && mounted) {
                                await _runPowerAction(
                                  vm,
                                  (r) => r.stopVm(vm.node, vm.vmid),
                                  l10n.actionForceStop,
                                );
                              }
                            },
                            onReboot: () async {
                              final ok = await _confirmReboot();
                              if (ok == true && mounted) {
                                await _runPowerAction(
                                  vm,
                                  (r) => r.rebootVm(vm.node, vm.vmid),
                                  l10n.actionReboot,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],

                        ChartTimeframeSelector(
                          selected: chartTf,
                          expandToWidth: true,
                          l10n: l10n,
                          onChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        GuestInstrumentMetricGrid(
                          node: vm.node,
                          guestId: vm.vmid,
                          timeframe: chartTf,
                          isLxc: false,
                          cpuHeadline: formatCpuPercent(vm.cpu),
                          memoryHeadline: formatMemoryRatio(vm.mem, vm.maxMem),
                          diskAllocationHeadline: formatMemoryRatio(
                            vm.disk,
                            vm.maxDisk,
                          ),
                          l10n: l10n,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        if (vm.tags.isNotEmpty) ...[
                          Material(
                            color: scheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(14),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.sectionGuestTags,
                                    style: tt.labelSmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  ProxmoxTagRow(
                                    tags: vm.tags,
                                    clusterTagHexByLabel: tagColors,
                                    density: ProxmoxTagDensity.comfortable,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],

                        VmCpuChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        VmMemoryChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        VmNetworkChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        VmDiskIoChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: chartTf,
                          onTimeframeChanged: setChartTf,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                  if (_powerBusy) ...[
                    ModalBarrier(
                      dismissible: false,
                      color: scheme.scrim.withValues(alpha: 0.45),
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

String _vmStatusLabel(Vm vm, AppLocalizations l10n) => switch (vm.status) {
  VmStatus.running => l10n.statusRunning,
  VmStatus.paused => l10n.statusPaused,
  VmStatus.stopped => l10n.statusStopped,
  VmStatus.unknown => l10n.statusUnknown,
};
