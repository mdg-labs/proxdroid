import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/app/theme/app_theme.dart';
import 'package:proxdroid/core/models/task.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';
import 'package:proxdroid/shared/widgets/status_badge.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({required this.node, required this.upid, super.key});

  final String node;
  final String upid;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _scheduledLogScroll = false;

  @override
  void didUpdateWidget(TaskDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.upid != widget.upid || oldWidget.node != widget.node) {
      _scheduledLogScroll = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLogToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Task? _taskFromList(List<Task>? list) {
    if (list == null) {
      return null;
    }
    for (final t in list) {
      if (t.upid == widget.upid && t.node == widget.node) {
        return t;
      }
    }
    return null;
  }

  Future<void> _refreshLog(WidgetRef ref) async {
    ref.invalidate(taskLogProvider(widget.node, widget.upid));
    ref.read(taskListProvider.notifier).refresh();
    await ref.read(taskLogProvider(widget.node, widget.upid).future);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final logAsync = ref.watch(taskLogProvider(widget.node, widget.upid));
    final taskMeta = _taskFromList(ref.watch(taskListProvider).valueOrNull);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          titleSpacing: AppSpacing.sm,
          toolbarHeight: kToolbarHeight,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.entityTask,
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${widget.node} · ${widget.upid}',
                style: tt.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshLog(ref),
            child: logAsync.when(
              loading:
                  () => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _MetadataCard(
                        l10n: l10n,
                        scheme: scheme,
                        taskMeta: taskMeta,
                        upid: widget.upid,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _LogCard(
                        scheme: scheme,
                        title: l10n.taskDetailLogTitle,
                        child: LoadingShimmer(
                          itemCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
              error:
                  (e, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _MetadataCard(
                        l10n: l10n,
                        scheme: scheme,
                        taskMeta: taskMeta,
                        upid: widget.upid,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _LogCard(
                        scheme: scheme,
                        title: l10n.taskDetailLogTitle,
                        child: ErrorView(
                          message: proxmoxExceptionMessage(e, l10n),
                          onRetry:
                              () => ref.invalidate(
                                taskLogProvider(widget.node, widget.upid),
                              ),
                        ),
                      ),
                    ],
                  ),
              data: (lines) {
                if (!_scheduledLogScroll) {
                  _scheduledLogScroll = true;
                  void scrollTwice() {
                    if (!mounted) {
                      return;
                    }
                    _scrollLogToBottom();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _scrollLogToBottom();
                      }
                    });
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollTwice();
                  });
                }
                final mono =
                    tt.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontFamilyFallback: const ['monospace'],
                      fontSize: 12,
                      height: 1.35,
                      color: scheme.onSurfaceVariant,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ) ??
                    TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.35,
                      color: scheme.onSurfaceVariant,
                    );
                return ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _MetadataCard(
                      l10n: l10n,
                      scheme: scheme,
                      taskMeta: taskMeta,
                      upid: widget.upid,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _LogCard(
                      scheme: scheme,
                      title: l10n.taskDetailLogTitle,
                      child:
                          lines.isEmpty
                              ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                child: Text(
                                  l10n.taskDetailLogEmpty,
                                  style: TextStyle(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                              : DecoratedBox(
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      for (final line in lines)
                                        SelectableText(line, style: mono),
                                    ],
                                  ),
                                ),
                              ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Card-wrapped metadata strip showing task type, status badge, node, and UPID.
class _MetadataCard extends StatelessWidget {
  const _MetadataCard({
    required this.l10n,
    required this.scheme,
    required this.taskMeta,
    required this.upid,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final Task? taskMeta;
  final String upid;

  static StatusBadgeVariant _variantFor(TaskStatus status) => switch (status) {
    TaskStatus.ok => StatusBadgeVariant.success,
    TaskStatus.error => StatusBadgeVariant.error,
    TaskStatus.running => StatusBadgeVariant.warning,
    TaskStatus.unknown => StatusBadgeVariant.neutral,
  };

  static String _statusLabel(TaskStatus status, AppLocalizations l10n) =>
      switch (status) {
        TaskStatus.running => l10n.statusRunning,
        TaskStatus.ok => l10n.taskStatusCompleted,
        TaskStatus.error => l10n.taskStatusFailed,
        TaskStatus.unknown => l10n.statusUnknown,
      };

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (taskMeta != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      taskMeta!.type,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(
                    label: _statusLabel(taskMeta!.status, l10n),
                    variant: _variantFor(taskMeta!.status),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${l10n.taskDetailNodeLabel}: ${taskMeta!.node}',
                style: tt.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              l10n.taskDetailUpidLabel,
              style: tt.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SelectableText(
              upid,
              style: tt.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card wrapping the monospace log section.
class _LogCard extends StatelessWidget {
  const _LogCard({
    required this.scheme,
    required this.title,
    required this.child,
  });

  final ColorScheme scheme;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}
