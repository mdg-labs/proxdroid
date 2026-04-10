import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/task.dart' as pve;
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/tasks/data/task_repository.dart';

part 'task_providers.g.dart';

@riverpod
Future<TaskRepository?> taskRepository(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) return null;
  return TaskRepository(client);
}

/// Merged cluster task list: per-node tasks (first page), sorted by
/// [pve.Task.startTime] descending (nulls last). Pull-to-refresh:
/// `ref.read(taskListProvider.notifier).refresh()`.
@riverpod
class TaskList extends _$TaskList {
  @override
  Future<List<pve.Task>> build() async {
    final nodes = await ref.watch(nodeListProvider.future);
    final repo = await ref.watch(taskRepositoryProvider.future);
    if (repo == null || nodes.isEmpty) {
      return const [];
    }

    final lists = await Future.wait(
      nodes.map((n) => repo.getTasks(n.name, start: 0, limit: 50)),
    );

    final merged = lists.expand((e) => e).toList();
    merged.sort((a, b) {
      final at = a.startTime;
      final bt = b.startTime;
      if (at == null && bt == null) return 0;
      if (at == null) return 1;
      if (bt == null) return -1;
      return bt.compareTo(at);
    });
    return merged;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Live task status for a single UPID, for **power-action follow-up** after
/// start/stop/reboot: refetches every 3s while [pve.TaskStatus.running], then
/// stops polling once the task reaches a terminal status.
@Riverpod(keepAlive: true)
Future<pve.TaskStatus> taskStatus(
  TaskStatusRef ref,
  String node,
  String upid,
) async {
  final repo = await ref.watch(taskRepositoryProvider.future);
  if (repo == null) {
    return pve.TaskStatus.unknown;
  }

  var disposed = false;
  ref.onDispose(() => disposed = true);

  while (true) {
    if (disposed) {
      return pve.TaskStatus.unknown;
    }
    final status = await repo.getTaskStatus(node, upid);
    if (disposed) {
      return pve.TaskStatus.unknown;
    }
    if (status != pve.TaskStatus.running) {
      return status;
    }
    await Future<void>.delayed(const Duration(seconds: 3));
  }
}

/// Task log lines for [taskDetailScreen] (first page).
@riverpod
Future<List<String>> taskLog(TaskLogRef ref, String node, String upid) async {
  final repo = await ref.watch(taskRepositoryProvider.future);
  if (repo == null) {
    return const [];
  }
  return repo.getTaskLog(node, upid, start: 0, limit: 500);
}
