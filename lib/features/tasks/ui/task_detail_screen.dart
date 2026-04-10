import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proxdroid/core/models/task.dart';
import 'package:proxdroid/features/servers/ui/proxmox_exception_messages.dart';
import 'package:proxdroid/features/tasks/providers/task_providers.dart';
import 'package:proxdroid/l10n/app_localizations.dart';
import 'package:proxdroid/shared/widgets/error_view.dart';
import 'package:proxdroid/shared/widgets/loading_shimmer.dart';
import 'package:proxdroid/shared/widgets/shell_app_bar_leading.dart';

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
    final logAsync = ref.watch(taskLogProvider(widget.node, widget.upid));
    final taskMeta = _taskFromList(ref.watch(taskListProvider).valueOrNull);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          leading: shellAppBarLeading(context),
          title: Text(l10n.entityTask),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshLog(ref),
            child: logAsync.when(
              loading:
                  () => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      _MetadataBlock(
                        l10n: l10n,
                        scheme: scheme,
                        taskMeta: taskMeta,
                        upid: widget.upid,
                      ),
                      Text(
                        l10n.taskDetailLogTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const LoadingShimmer(
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
              error:
                  (e, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      _MetadataBlock(
                        l10n: l10n,
                        scheme: scheme,
                        taskMeta: taskMeta,
                        upid: widget.upid,
                      ),
                      Text(
                        l10n.taskDetailLogTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ErrorView(
                        message: proxmoxExceptionMessage(e, l10n),
                        onRetry:
                            () => ref.invalidate(
                              taskLogProvider(widget.node, widget.upid),
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
                final mono = TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: scheme.onSurface,
                );
                return ListView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    _MetadataBlock(
                      l10n: l10n,
                      scheme: scheme,
                      taskMeta: taskMeta,
                      upid: widget.upid,
                    ),
                    Text(
                      l10n.taskDetailLogTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (lines.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          l10n.taskDetailLogEmpty,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      )
                    else
                      ...lines.map((line) => SelectableText(line, style: mono)),
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

class _MetadataBlock extends StatelessWidget {
  const _MetadataBlock({
    required this.l10n,
    required this.scheme,
    required this.taskMeta,
    required this.upid,
  });

  final AppLocalizations l10n;
  final ColorScheme scheme;
  final Task? taskMeta;
  final String upid;

  static String _statusLabel(TaskStatus status, AppLocalizations l10n) {
    switch (status) {
      case TaskStatus.running:
        return l10n.statusRunning;
      case TaskStatus.ok:
        return l10n.taskStatusCompleted;
      case TaskStatus.error:
        return l10n.taskStatusFailed;
      case TaskStatus.unknown:
        return l10n.statusUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (taskMeta != null) ...[
          Text(taskMeta!.type, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '${l10n.taskDetailNodeLabel}: ${taskMeta!.node}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '${l10n.taskRowStatus}: ${_statusLabel(taskMeta!.status, l10n)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
        ],
        Text(
          l10n.taskDetailUpidLabel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        SelectableText(
          upid,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
