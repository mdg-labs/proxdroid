import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/models/task.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/upid_parser.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/premium_list_row.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  static StatusBadgeVariant _statusVariant(TaskStatus status) {
    return switch (status) {
      TaskStatus.running => StatusBadgeVariant.warning,
      TaskStatus.ok => StatusBadgeVariant.success,
      TaskStatus.error => StatusBadgeVariant.error,
      TaskStatus.unknown => StatusBadgeVariant.neutral,
    };
  }

  static String _statusLabel(TaskStatus status, AppLocalizations l10n) {
    return switch (status) {
      TaskStatus.running => l10n.statusRunning,
      TaskStatus.ok => l10n.taskStatusCompleted,
      TaskStatus.error => l10n.taskStatusFailed,
      TaskStatus.unknown => l10n.statusUnknown,
    };
  }

  static String _guestLabel({
    required int? vmid,
    required String taskNode,
    required List<Vm> vms,
    required List<px.Container> containers,
    required AppLocalizations l10n,
  }) {
    if (vmid == null) {
      return l10n.valueUnavailable;
    }
    for (final v in vms) {
      if (v.vmid == vmid && v.node == taskNode) {
        return v.name.isEmpty ? '$vmid' : '${v.name} ($vmid)';
      }
    }
    for (final c in containers) {
      if (c.vmid == vmid && c.node == taskNode) {
        return c.name.isEmpty ? '$vmid' : '${c.name} ($vmid)';
      }
    }
    for (final v in vms) {
      if (v.vmid == vmid) {
        return v.name.isEmpty ? '$vmid' : '${v.name} ($vmid)';
      }
    }
    for (final c in containers) {
      if (c.vmid == vmid) {
        return c.name.isEmpty ? '$vmid' : '${c.name} ($vmid)';
      }
    }
    return '$vmid';
  }

  static String _formatDurationSeconds(int startSec, int? endSec) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final end = endSec ?? now;
    var secs = end - startSec;
    if (secs < 0) {
      secs = 0;
    }
    final d = Duration(seconds: secs);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:'
          '${m.toString().padLeft(2, '0')}:'
          '${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final tasksAsync = ref.watch(taskListProvider);
    final vms = ref.watch(allVmsProvider).valueOrNull ?? const <Vm>[];
    final containers =
        ref.watch(allContainersProvider).valueOrNull ?? const <px.Container>[];
    final minPullHeight = MediaQuery.sizeOf(context).height * 0.5;

    Future<void> refreshTasks() async {
      ref.read(taskListProvider.notifier).refresh();
      await ref.read(taskListProvider.future);
    }

    final body = tasksAsync.when(
      loading:
          () => RefreshIndicator(
            onRefresh: refreshTasks,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: minPullHeight,
                  child: const LoadingShimmer(
                    itemCount: 8,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
              ],
            ),
          ),
      error:
          (e, _) => RefreshIndicator(
            onRefresh: refreshTasks,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: minPullHeight,
                  child: ErrorView(
                    message: proxmoxExceptionMessage(e, l10n),
                    onRetry: () => ref.read(taskListProvider.notifier).refresh(),
                  ),
                ),
              ],
            ),
          ),
      data: (tasks) {
        if (tasks.isEmpty) {
          return RefreshIndicator(
            onRefresh: refreshTasks,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: minPullHeight,
                  child: EmptyState(
                    icon: Icons.task_alt_outlined,
                    title: l10n.taskListEmptyTitle,
                    message: l10n.taskListEmptyMessage,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: refreshTasks,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final vmid = vmidFromProxmoxUpid(task.upid);
              final guest = _guestLabel(
                vmid: vmid,
                taskNode: task.node,
                vms: vms,
                containers: containers,
                l10n: l10n,
              );
              final start = task.startTime;
              String startedText = l10n.valueUnavailable;
              if (start != null) {
                final dt = DateTime.fromMillisecondsSinceEpoch(
                  start * 1000,
                  isUtc: true,
                ).toLocal();
                startedText = DateFormat.yMMMd(locale).add_Hm().format(dt);
              }
              final durationText =
                  start != null
                      ? _formatDurationSeconds(start, task.endTime)
                      : l10n.valueUnavailable;

              return PremiumListRow(
                title: Text(
                  task.type,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.taskRowGuest}: $guest',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                    Text(
                      '${l10n.taskRowStarted}: $startedText · '
                      '${l10n.taskRowDuration}: $durationText',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                trailing: StatusBadge(
                  label: _statusLabel(task.status, l10n),
                  variant: _statusVariant(task.status),
                ),
                showDividerBelow: index < tasks.length - 1,
                onTap: () => context.push(
                  '/tasks/${Uri.encodeComponent(task.node)}/${Uri.encodeComponent(task.upid)}',
                ),
              );
            },
          ),
        );
      },
    );

    return ShellSectionBody(title: Text(l10n.sectionTasks), body: body);
  }
}
