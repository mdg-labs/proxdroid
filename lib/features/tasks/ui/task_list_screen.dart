import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/container.dart' as px;
import 'package:proxdroid/core/models/proxmox_guest_tag.dart';
import 'package:proxdroid/core/models/task.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/utils/upid_parser.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/providers/proxmox_tag_colors_provider.dart';
import 'package:proxdroid/shared/widgets/empty_state.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_section_body.dart';
import 'package:proxdroid/shared/widgets/proxmox_tag_widgets.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

// ────────────────────────────────────────────────────────────────────────────
// List item model (header or task row)
// ────────────────────────────────────────────────────────────────────────────

sealed class _Item {}

class _DateHeader extends _Item {
  _DateHeader(this.label);
  final String label;
}

class _TaskRow extends _Item {
  _TaskRow(this.task);
  final Task task;
}

// ────────────────────────────────────────────────────────────────────────────
// Screen
// ────────────────────────────────────────────────────────────────────────────

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  static StatusBadgeVariant _statusVariant(TaskStatus status) {
    return switch (status) {
      TaskStatus.running => StatusBadgeVariant.running,
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
    if (vmid == null) return l10n.valueUnavailable;
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

  static List<ProxmoxGuestTag> _guestTagsForTask({
    required int? vmid,
    required String taskNode,
    required List<Vm> vms,
    required List<px.Container> containers,
  }) {
    if (vmid == null) return const [];
    for (final v in vms) {
      if (v.vmid == vmid && v.node == taskNode) return v.tags;
    }
    for (final c in containers) {
      if (c.vmid == vmid && c.node == taskNode) return c.tags;
    }
    for (final v in vms) {
      if (v.vmid == vmid) return v.tags;
    }
    for (final c in containers) {
      if (c.vmid == vmid) return c.tags;
    }
    return const [];
  }

  static String _formatDuration(int startSec, int? endSec) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final end = endSec ?? now;
    var secs = end - startSec;
    if (secs < 0) secs = 0;
    final d = Duration(seconds: secs);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m';
    }
    if (m > 0) {
      return '${m}m ${s.toString().padLeft(2, '0')}s';
    }
    return '${s}s';
  }

  /// Groups tasks into date-bucket flat list with [_DateHeader] separators.
  static List<_Item> _buildItems(List<Task> tasks, String locale) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    String? currentHeader;
    final items = <_Item>[];

    for (final task in tasks) {
      final start = task.startTime;
      final String header;
      if (start == null) {
        header = 'Earlier';
      } else {
        final dt =
            DateTime.fromMillisecondsSinceEpoch(
              start * 1000,
              isUtc: true,
            ).toLocal();
        final dtDate = DateTime(dt.year, dt.month, dt.day);
        if (dtDate == todayDate) {
          header = 'Today';
        } else if (dtDate == yesterdayDate) {
          header = 'Yesterday';
        } else {
          header = DateFormat.yMMMd(locale).format(dt);
        }
      }

      if (header != currentHeader) {
        currentHeader = header;
        items.add(_DateHeader(header));
      }
      items.add(_TaskRow(task));
    }

    return items;
  }

  static Map<TaskStatus, int> _taskStatusCounts(List<Task> tasks) {
    final counts = <TaskStatus, int>{
      TaskStatus.running: 0,
      TaskStatus.ok: 0,
      TaskStatus.error: 0,
      TaskStatus.unknown: 0,
    };
    for (final t in tasks) {
      counts[t.status] = counts[t.status]! + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final tasksAsync = ref.watch(taskListProvider);
    final vms = ref.watch(allVmsProvider).valueOrNull ?? const <Vm>[];
    final containers =
        ref.watch(allContainersProvider).valueOrNull ?? const <px.Container>[];
    final tagColorMap =
        ref.watch(proxmoxTagColorsProvider).valueOrNull ??
        const <String, String>{};
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
                    onRetry:
                        () => ref.read(taskListProvider.notifier).refresh(),
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

        final items = _buildItems(tasks, locale);
        final statusCounts = _taskStatusCounts(tasks);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshTasks,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    if (item is _DateHeader) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? AppSpacing.xs : AppSpacing.xl,
                          bottom: AppSpacing.sm,
                        ),
                        child: Text(
                          item.label,
                          style: tt.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant.withValues(
                              alpha: 0.65,
                            ),
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            letterSpacing: 1.3,
                          ),
                        ),
                      );
                    }

                    final task = (item as _TaskRow).task;
                    final vmid = vmidFromProxmoxUpid(task.upid);
                    final guest = _guestLabel(
                      vmid: vmid,
                      taskNode: task.node,
                      vms: vms,
                      containers: containers,
                      l10n: l10n,
                    );
                    final guestTags = _guestTagsForTask(
                      vmid: vmid,
                      taskNode: task.node,
                      vms: vms,
                      containers: containers,
                    );
                    final start = task.startTime;
                    String startedText = l10n.valueUnavailable;
                    if (start != null) {
                      final dt =
                          DateTime.fromMillisecondsSinceEpoch(
                            start * 1000,
                            isUtc: true,
                          ).toLocal();
                      startedText = DateFormat.jm(locale).format(dt);
                    }
                    final durationText =
                        start != null
                            ? _formatDuration(start, task.endTime)
                            : l10n.valueUnavailable;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _TaskTile(
                        task: task,
                        guest: guest,
                        guestTags: guestTags,
                        clusterTagHexByLabel: tagColorMap,
                        startedText: startedText,
                        durationText: durationText,
                        statusVariant: _statusVariant(task.status),
                        statusLabel: _statusLabel(task.status, l10n),
                        l10n: l10n,
                        scheme: scheme,
                        tt: tt,
                        onTap:
                            () => context.push(
                              '/tasks/${Uri.encodeComponent(task.node)}/${Uri.encodeComponent(task.upid)}',
                            ),
                      ),
                    );
                  },
                ),
              ),
            ),
            _TaskListStatusSummary(
              counts: statusCounts,
              l10n: l10n,
              scheme: scheme,
              tt: tt,
            ),
          ],
        );
      },
    );

    return ShellSectionBody(title: Text(l10n.sectionTasks), body: body);
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Sticky status counts (non-scrolling; sits above shell bottom nav)
// ────────────────────────────────────────────────────────────────────────────

class _TaskListStatusSummary extends StatelessWidget {
  const _TaskListStatusSummary({
    required this.counts,
    required this.l10n,
    required this.scheme,
    required this.tt,
  });

  final Map<TaskStatus, int> counts;
  final AppLocalizations l10n;
  final ColorScheme scheme;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    String labelFor(TaskStatus s) => switch (s) {
      TaskStatus.running => l10n.statusRunning,
      TaskStatus.ok => l10n.taskStatusCompleted,
      TaskStatus.error => l10n.taskStatusFailed,
      TaskStatus.unknown => l10n.statusUnknown,
    };

    final style = tt.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.w600,
      fontSize: 11,
    );
    final sepStyle = style?.copyWith(
      color: scheme.outlineVariant,
      fontWeight: FontWeight.w400,
    );

    Widget cell(TaskStatus s) =>
        Text('${labelFor(s)}: ${counts[s] ?? 0}', style: style);

    Widget sep() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Text('·', style: sepStyle),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.35),
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                cell(TaskStatus.running),
                sep(),
                cell(TaskStatus.ok),
                sep(),
                cell(TaskStatus.error),
                sep(),
                cell(TaskStatus.unknown),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Task tile
// ────────────────────────────────────────────────────────────────────────────

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.guest,
    required this.guestTags,
    required this.clusterTagHexByLabel,
    required this.startedText,
    required this.durationText,
    required this.statusVariant,
    required this.statusLabel,
    required this.l10n,
    required this.scheme,
    required this.tt,
    required this.onTap,
  });

  final Task task;
  final String guest;
  final List<ProxmoxGuestTag> guestTags;
  final Map<String, String> clusterTagHexByLabel;
  final String startedText;
  final String durationText;
  final StatusBadgeVariant statusVariant;
  final String statusLabel;
  final AppLocalizations l10n;
  final ColorScheme scheme;
  final TextTheme tt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.type,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      guest,
                      style: tt.bodySmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.75),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (guestTags.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      ProxmoxTagRow(
                        tags: guestTags,
                        clusterTagHexByLabel: clusterTagHexByLabel,
                        density: ProxmoxTagDensity.compact,
                        spacing: 5,
                      ),
                    ],
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          startedText,
                          style: tt.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                        if (durationText != l10n.valueUnavailable) ...[
                          Text(
                            '  ·  ',
                            style: tt.labelSmall?.copyWith(
                              color: scheme.outlineVariant,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            durationText,
                            style: tt.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Trailing: badge + chevron
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(label: statusLabel, variant: statusVariant),
                  const SizedBox(height: AppSpacing.xs),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: scheme.outlineVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
