import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/containers/ui/widgets/container_status_badge.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/labeled_row.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class ContainerDetailScreen extends ConsumerWidget {
  const ContainerDetailScreen({
    required this.node,
    required this.ctid,
    super.key,
  });

  final String node;
  final String ctid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(allContainersProvider);
    final id = int.tryParse(ctid);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.entityContainer),
        ),
        Expanded(
          child: async.when(
            loading: () => const LoadingShimmer(itemCount: 4),
            error:
                (e, _) => ErrorView(
                  message: proxmoxExceptionMessage(e, l10n),
                  onRetry:
                      () => ref.read(allContainersProvider.notifier).refresh(),
                ),
            data: (containers) {
              if (id == null) {
                return EmptyState(
                  icon: Icons.error_outline,
                  title: l10n.containerNotFoundTitle,
                  message: l10n.containerNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                );
              }

              px.Container? found;
              for (final c in containers) {
                if (c.node == node && c.vmid == id) {
                  found = c;
                  break;
                }
              }

              if (found == null) {
                return EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: l10n.containerNotFoundTitle,
                  message: l10n.containerNotFoundMessage,
                  action: FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(l10n.actionGoBack),
                  ),
                );
              }

              final ct = found;
              final title =
                  ct.name.isEmpty ? '${l10n.labelCtid} ${ct.vmid}' : ct.name;

              return RefreshIndicator(
                onRefresh: () async {
                  ref.read(allContainersProvider.notifier).refresh();
                  await ref.read(allContainersProvider.future);
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
                    ContainerStatusBadge(status: ct.status),
                    const SizedBox(height: 24),
                    LabeledRow(label: l10n.labelCtid, value: '${ct.vmid}'),
                    LabeledRow(label: l10n.entityNode, value: ct.node),
                    LabeledRow(
                      label: l10n.metricCpu,
                      value: formatCpuPercent(ct.cpu),
                    ),
                    LabeledRow(
                      label: l10n.metricMemory,
                      value: formatMemoryRatio(ct.mem, ct.maxMem),
                    ),
                    LabeledRow(
                      label: l10n.metricDisk,
                      value: formatMemoryRatio(ct.disk, ct.maxDisk),
                    ),
                    LabeledRow(
                      label: l10n.metricUptime,
                      value: formatUptimeSeconds(ct.uptime),
                    ),
                    LabeledRow(
                      label: l10n.labelContainerOsType,
                      value: ct.ostype ?? l10n.valueUnavailable,
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
