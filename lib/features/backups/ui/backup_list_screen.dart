import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/models/task.dart' as pve;
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/formatters.dart';
import 'package:proxdroid/core/utils/upid_parser.dart';
import 'package:proxdroid/features/backups/providers/backup_providers.dart';
import 'package:proxdroid/features/backups/ui/trigger_backup_sheet.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

class BackupListScreen extends ConsumerWidget {
  const BackupListScreen({super.key});

  void _refresh(WidgetRef ref) {
    ref.read(backupJobsProvider.notifier).refresh();
    ref.read(clusterBackupContentProvider.notifier).refresh();
    ref.read(clusterVzdumpTasksProvider.notifier).refresh();
  }

  static String _guestName(
    int? vmid,
    List<Vm> vms,
    List<px.Container> cts,
    AppLocalizations l10n,
  ) {
    if (vmid == null) {
      return l10n.backupGroupedUnknownGuest;
    }
    for (final v in vms) {
      if (v.vmid == vmid) {
        return v.name.isEmpty ? '${l10n.entityVirtualMachine} $vmid' : v.name;
      }
    }
    for (final c in cts) {
      if (c.vmid == vmid) {
        return c.name.isEmpty ? '${l10n.entityContainer} $vmid' : c.name;
      }
    }
    return '${l10n.labelVmid} $vmid';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final jobsAsync = ref.watch(backupJobsProvider);
    final filesAsync = ref.watch(clusterBackupContentProvider);
    final tasksAsync = ref.watch(clusterVzdumpTasksProvider);
    final vmsAsync = ref.watch(allVmsProvider);
    final ctsAsync = ref.watch(allContainersProvider);

    if (jobsAsync.hasError || filesAsync.hasError || tasksAsync.hasError) {
      final err = jobsAsync.error ?? filesAsync.error ?? tasksAsync.error!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.sectionBackups),
          ),
          Expanded(
            child: ErrorView(
              message: proxmoxExceptionMessage(err, l10n),
              onRetry: () => _refresh(ref),
            ),
          ),
        ],
      );
    }

    if (!jobsAsync.hasValue ||
        !filesAsync.hasValue ||
        !tasksAsync.hasValue ||
        !vmsAsync.hasValue ||
        !ctsAsync.hasValue) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            leading: shellAppBarLeading(context),
            title: Text(l10n.sectionBackups),
          ),
          const Expanded(child: LoadingShimmer(itemCount: 8)),
        ],
      );
    }

    final jobs = jobsAsync.requireValue;
    final files = filesAsync.requireValue;
    final vzTasks = tasksAsync.requireValue;
    final vms = vmsAsync.requireValue;
    final cts = ctsAsync.requireValue;

    final byVmid = <int?, List<BackupContentEntry>>{};
    for (final e in files) {
      byVmid.putIfAbsent(e.item.vmid, () => []).add(e);
    }
    final sortedKeys =
        byVmid.keys.toList()..sort((a, b) {
          if (a == null && b == null) return 0;
          if (a == null) return 1;
          if (b == null) return -1;
          return a.compareTo(b);
        });

    final emptyFiles = files.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.sectionBackups),
        ),
        Expanded(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  _refresh(ref);
                  await ref.read(clusterBackupContentProvider.future);
                  await ref.read(backupJobsProvider.future);
                  await ref.read(clusterVzdumpTasksProvider.future);
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (jobs.isNotEmpty) ...[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            l10n.backupSectionScheduledJobs,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final j = jobs[i];
                          return Card(
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    j.id,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  if (j.schedule.isNotEmpty)
                                    Text(
                                      j.schedule,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  if (j.storage.isNotEmpty)
                                    Text(
                                      '${l10n.backupFieldStorage}: ${j.storage}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  if (j.vmids.isNotEmpty)
                                    Text(
                                      l10n.backupJobVmids(j.vmids.join(', ')),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  if (j.nextRun != null)
                                    Text(
                                      l10n.backupJobNextRun(
                                        formatProxmoxUnixSeconds(j.nextRun),
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  if (j.lastRun != null)
                                    Text(
                                      l10n.backupJobLastRun(
                                        formatProxmoxUnixSeconds(j.lastRun),
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }, childCount: jobs.length),
                      ),
                    ],
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          l10n.backupSectionFiles,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    if (emptyFiles)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: EmptyState(
                            icon: Icons.folder_off_outlined,
                            title: l10n.backupListEmptyTitle,
                            message: l10n.backupListEmptyMessage,
                          ),
                        ),
                      )
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final vmid = sortedKeys[i];
                          final entries = byVmid[vmid]!;
                          final title = _guestName(vmid, vms, cts, l10n);
                          return ExpansionTile(
                            title: Text(title),
                            subtitle: Text(
                              l10n.entityBackup,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                            children:
                                entries.map((e) {
                                  final it = e.item;
                                  return ListTile(
                                    title: Text(
                                      it.volid,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      [
                                        l10n.storagePoolOnNode(
                                          e.storageId,
                                          e.node,
                                        ),
                                        if (it.format.isNotEmpty)
                                          '${l10n.labelFormat}: ${it.format}',
                                        if (it.ctime != null)
                                          formatProxmoxUnixSeconds(it.ctime),
                                        if (it.size != null)
                                          formatBytes(it.size),
                                      ].join(' · '),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );
                        }, childCount: sortedKeys.length),
                      ),
                    if (vzTasks.isNotEmpty) ...[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            l10n.backupSectionRecentTasks,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                          final t = vzTasks[i];
                          final vmid = vmidFromProxmoxUpid(t.upid);
                          final guest = _guestName(vmid, vms, cts, l10n);
                          return ListTile(
                            title: Text(guest),
                            subtitle: Text(
                              '${t.type} · ${_statusLine(t, l10n)}',
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            ),
                            onTap:
                                () => context.push(
                                  '/tasks/${Uri.encodeComponent(t.node)}/${Uri.encodeComponent(t.upid)}',
                                ),
                          );
                        }, childCount: vzTasks.length),
                      ),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 88)),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () => showTriggerBackupSheet(context, ref),
                  tooltip: l10n.backupFabTooltip,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _statusLine(pve.Task t, AppLocalizations l10n) {
    final st = t.status;
    switch (st) {
      case pve.TaskStatus.running:
        return l10n.statusRunning;
      case pve.TaskStatus.ok:
        return l10n.taskStatusCompleted;
      case pve.TaskStatus.error:
        return l10n.taskStatusFailed;
      case pve.TaskStatus.unknown:
        return l10n.statusUnknown;
    }
  }
}
