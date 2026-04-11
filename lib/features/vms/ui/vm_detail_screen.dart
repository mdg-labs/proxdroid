import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/app/theme/app_colors.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
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
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        // ── Hero header ───────────────────────────────────
                        _VmHeroHeader(vm: vm, title: title, l10n: l10n),
                        const SizedBox(height: AppSpacing.lg),

                        // ── Power actions ────────────────────────────────
                        if (canStart || canStopOrReboot) ...[
                          _PowerActionsRow(
                            vm: vm,
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

                        // ── Metric grid ──────────────────────────────────
                        _MetricGrid(vm: vm, l10n: l10n),
                        const SizedBox(height: AppSpacing.lg),

                        // ── Charts ──────────────────────────────────────
                        VmCpuChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _cpuChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _cpuChartTf = tf),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        VmMemoryChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _memChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _memChartTf = tf),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        VmNetworkChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _netChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _netChartTf = tf),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        VmDiskIoChart(
                          node: vm.node,
                          vmid: vm.vmid,
                          timeframe: _diskChartTf,
                          onTimeframeChanged:
                              (tf) => setState(() => _diskChartTf = tf),
                        ),
                        const SizedBox(height: AppSpacing.lg),
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

// ────────────────────────────────────────────────────────────────────────────
// Hero header widget
// ────────────────────────────────────────────────────────────────────────────

class _VmHeroHeader extends StatelessWidget {
  const _VmHeroHeader({
    required this.vm,
    required this.title,
    required this.l10n,
  });

  final Vm vm;
  final String title;
  final AppLocalizations l10n;

  Color _statusColor(VmStatus status) => switch (status) {
    VmStatus.running => AppColors.darkStatusSuccessForeground,
    VmStatus.paused => AppColors.darkStatusWarningForeground,
    VmStatus.stopped => AppColors.darkStatusStoppedForeground,
    VmStatus.unknown => AppColors.darkStatusStoppedForeground,
  };

  Color _statusBg(VmStatus status) => switch (status) {
    VmStatus.running => AppColors.darkStatusSuccessBackground,
    VmStatus.paused => AppColors.darkStatusWarningBackground,
    VmStatus.stopped => AppColors.darkStatusStoppedBackground,
    VmStatus.unknown => AppColors.darkStatusStoppedBackground,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accent = _statusColor(vm.status);
    final accentBg = _statusBg(vm.status);

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
              color: accentBg,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.computer_rounded,
              color: accent,
              size: 26,
            ),
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
                  '${l10n.labelVmid} ${vm.vmid}  ·  ${vm.node}',
                  style: tt.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          VmStatusBadge(status: vm.status),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Power actions row
// ────────────────────────────────────────────────────────────────────────────

class _PowerActionsRow extends StatelessWidget {
  const _PowerActionsRow({
    required this.vm,
    required this.l10n,
    required this.canStart,
    required this.canStopOrReboot,
    required this.busy,
    required this.onStart,
    required this.onStop,
    required this.onForceStop,
    required this.onReboot,
  });

  final Vm vm;
  final AppLocalizations l10n;
  final bool canStart;
  final bool canStopOrReboot;
  final bool busy;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onForceStop;
  final VoidCallback onReboot;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = isDark
        ? AppColors.darkStatusWarningForeground
        : AppColors.lightStatusWarningForeground;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (canStart)
          FilledButton.icon(
            onPressed: busy ? null : onStart,
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: Text(l10n.actionStart),
          ),
        if (canStopOrReboot) ...[
          // Stop — outlined amber (soft stop, not destructive)
          OutlinedButton.icon(
            onPressed: busy ? null : onStop,
            icon: Icon(Icons.stop_rounded, size: 18, color: warningColor),
            label: Text(l10n.actionStop),
            style: OutlinedButton.styleFrom(
              foregroundColor: warningColor,
              side: BorderSide(color: warningColor.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
            ),
          ),
          // Force Stop — filled red (destructive)
          FilledButton.icon(
            onPressed: busy ? null : onForceStop,
            icon: const Icon(Icons.power_settings_new_rounded, size: 18),
            label: Text(l10n.actionForceStop),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.errorContainer,
              foregroundColor: scheme.onErrorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
            ),
          ),
          // Reboot — outlined neutral
          OutlinedButton.icon(
            onPressed: busy ? null : onReboot,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l10n.actionReboot),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// 2-column metric grid
// ────────────────────────────────────────────────────────────────────────────

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.vm, required this.l10n});

  final Vm vm;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final cells = [
      (l10n.labelVmid, '${vm.vmid}'),
      (l10n.entityNode, vm.node),
      (l10n.metricCpu, formatCpuPercent(vm.cpu)),
      (l10n.metricMemory, formatMemoryRatio(vm.mem, vm.maxMem)),
      (l10n.metricDisk, formatMemoryRatio(vm.disk, vm.maxDisk)),
      (l10n.metricUptime, formatUptimeSeconds(vm.uptime)),
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
