import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/task.dart' as pve;
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/backups/ui/trigger_backup_sheet.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/features/vms/data/vm_repository.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/features/vms/ui/widgets/cpu_chart.dart';
import 'package:proxdroid/features/vms/ui/widgets/disk_io_chart.dart';
import 'package:proxdroid/features/vms/ui/widgets/memory_chart.dart';
import 'package:proxdroid/features/vms/ui/widgets/network_chart.dart';
import 'package:proxdroid/features/vms/ui/widgets/vm_status_badge.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/icon_badge_avatar.dart';
import 'package:proxdroid/shared/widgets/labeled_row.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/premium_modals.dart';
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
  ChartTimeframe _cpuChartTf = ChartTimeframe.hour;
  ChartTimeframe _memChartTf = ChartTimeframe.hour;
  ChartTimeframe _netChartTf = ChartTimeframe.hour;
  ChartTimeframe _diskChartTf = ChartTimeframe.hour;

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
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
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

        final canStart =
            vm.status == VmStatus.stopped || vm.status == VmStatus.unknown;
        final canStopOrReboot =
            vm.status == VmStatus.running || vm.status == VmStatus.paused;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              leading: shellAppBarLeading(context),
              title: Text(l10n.entityVirtualMachine),
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
                      padding: const EdgeInsets.all(16),
                      children: [
                        // — Premium header (T6.9 / T6.7) —
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconBadgeAvatar(
                              icon: Icons.computer_rounded,
                              size: 56,
                              iconSize: 28,
                              borderRadius: 14,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: tt.titleLarge),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '${l10n.labelVmid} ${vm.vmid}',
                                        style: tt.bodySmall?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        child: Text(
                                          '·',
                                          style: tt.bodySmall?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        vm.node,
                                        style: tt.bodySmall?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  VmStatusBadge(status: vm.status),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // — Power actions row —
                        if (canStart || canStopOrReboot) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (canStart)
                                FilledButton(
                                  onPressed:
                                      _powerBusy
                                          ? null
                                          : () {
                                            HapticFeedback.lightImpact();
                                            _runPowerAction(
                                              vm,
                                              (r) =>
                                                  r.startVm(vm.node, vm.vmid),
                                              l10n.actionStart,
                                            );
                                          },
                                  child: Text(l10n.actionStart),
                                ),
                              if (canStopOrReboot) ...[
                                FilledButton.tonal(
                                  onPressed:
                                      _powerBusy
                                          ? null
                                          : () async {
                                            final ok = await _confirmStop();
                                            if (ok == true && mounted) {
                                              await _runPowerAction(
                                                vm,
                                                (r) => r.shutdownVm(
                                                  vm.node,
                                                  vm.vmid,
                                                ),
                                                l10n.actionStop,
                                              );
                                            }
                                          },
                                  child: Text(l10n.actionStop),
                                ),
                                FilledButton.tonal(
                                  onPressed:
                                      _powerBusy
                                          ? null
                                          : () async {
                                            final ok =
                                                await _confirmForceStop();
                                            if (ok == true && mounted) {
                                              await _runPowerAction(
                                                vm,
                                                (r) =>
                                                    r.stopVm(vm.node, vm.vmid),
                                                l10n.actionForceStop,
                                              );
                                            }
                                          },
                                  child: Text(l10n.actionForceStop),
                                ),
                                FilledButton.tonal(
                                  onPressed:
                                      _powerBusy
                                          ? null
                                          : () async {
                                            final ok = await _confirmReboot();
                                            if (ok == true && mounted) {
                                              await _runPowerAction(
                                                vm,
                                                (r) => r.rebootVm(
                                                  vm.node,
                                                  vm.vmid,
                                                ),
                                                l10n.actionReboot,
                                              );
                                            }
                                          },
                                  child: Text(l10n.actionReboot),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],

                        // — Labeled metric rows (T6.9) —
                        Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                LabeledRow(
                                  label: l10n.labelVmid,
                                  value: '${vm.vmid}',
                                ),
                                LabeledRow(
                                  label: l10n.entityNode,
                                  value: vm.node,
                                ),
                                LabeledRow(
                                  label: l10n.metricCpu,
                                  value: formatCpuPercent(vm.cpu),
                                ),
                                LabeledRow(
                                  label: l10n.metricMemory,
                                  value: formatMemoryRatio(vm.mem, vm.maxMem),
                                ),
                                LabeledRow(
                                  label: l10n.metricDisk,
                                  value: formatMemoryRatio(vm.disk, vm.maxDisk),
                                ),
                                LabeledRow(
                                  label: l10n.metricUptime,
                                  value: formatUptimeSeconds(vm.uptime),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // — Charts (each wrapped in ChartCard by their widget) —
                        VmCpuChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _cpuChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _cpuChartTf = tf),
                        ),
                        const SizedBox(height: 16),
                        VmMemoryChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _memChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _memChartTf = tf),
                        ),
                        const SizedBox(height: 16),
                        VmNetworkChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _netChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _netChartTf = tf),
                        ),
                        const SizedBox(height: 16),
                        VmDiskIoChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _diskChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _diskChartTf = tf),
                        ),
                        const SizedBox(height: 16),
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
