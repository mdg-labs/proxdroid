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
import 'package:proxdroid/shared/widgets/labeled_row.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class VmDetailScreen extends ConsumerWidget {
  const VmDetailScreen({required this.node, required this.vmid, super.key});

  final String node;
  final String vmid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(allVmsProvider);
    final id = int.tryParse(vmid);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.entityVirtualMachine),
        ),
        Expanded(
          child: async.when(
            loading: () => const LoadingShimmer(itemCount: 4),
            error:
                (e, _) => ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry: () => ref.read(allVmsProvider.notifier).refresh(),
                ),
            data: (vms) {
              if (id == null) {
                return EmptyState(
                  icon: Icons.error_outline,
                  title: l10n.vmNotFoundTitle,
                  message: l10n.vmNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                );
              }

              Vm? found;
              for (final v in vms) {
                if (v.node == node && v.vmid == id) {
                  found = v;
                  break;
                }
              }

              if (found == null) {
                return EmptyState(
                  icon: Icons.computer_outlined,
                  title: l10n.vmNotFoundTitle,
                  message: l10n.vmNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                );
              }

              final vm = found;
              final title =
                  vm.name.isEmpty ? '${l10n.labelVmid} ${vm.vmid}' : vm.name;

              return RefreshIndicator(
                onRefresh: () async {
                  ref.read(allVmsProvider.notifier).refresh();
                  await ref.read(allVmsProvider.future);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    VmStatusBadge(status: vm.status),
                    const SizedBox(height: 24),
                    LabeledRow(label: l10n.labelVmid, value: '${vm.vmid}'),
                    LabeledRow(label: l10n.entityNode, value: vm.node),
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
              );
            },
          ),
        ),
      ],
    );
  }
}
