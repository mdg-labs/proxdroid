import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/backup.dart';
import 'package:proxdroid/core/models/task.dart' as pve;
import 'package:proxdroid/features/backups/data/backup_repository.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/storage/providers/storage_providers.dart';

part 'backup_providers.g.dart';

@riverpod
Future<BackupRepository?> backupRepository(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) return null;
  return BackupRepository(client);
}

/// One backup file row plus where it was listed (for debugging / future actions).
class BackupContentEntry {
  const BackupContentEntry({
    required this.node,
    required this.storageId,
    required this.item,
  });

  final String node;
  final String storageId;
  final BackupContent item;
}

/// Cluster vzdump job definitions from [GET /cluster/backup].
///
/// Pull-to-refresh: `ref.read(backupJobsProvider.notifier).refresh()`.
@riverpod
class BackupJobs extends _$BackupJobs {
  @override
  Future<List<BackupJob>> build() async {
    final repo = await ref.watch(backupRepositoryProvider.future);
    if (repo == null) {
      return const [];
    }
    return repo.getBackupJobs();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Recent vzdump tasks across all nodes (`typefilter=vzdump` when supported).
///
/// Pull-to-refresh: `ref.read(clusterVzdumpTasksProvider.notifier).refresh()`.
@riverpod
class ClusterVzdumpTasks extends _$ClusterVzdumpTasks {
  @override
  Future<List<pve.Task>> build() async {
    final nodes = await ref.watch(nodeListProvider.future);
    final repo = await ref.watch(backupRepositoryProvider.future);
    if (repo == null || nodes.isEmpty) {
      return const [];
    }
    final lists = await Future.wait(
      nodes.map((n) => repo.getVzdumpTasksForNode(n.name, limit: 25)),
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

/// Backup images from every pool whose `content` list includes `backup`.
///
/// Fetches [GET …/content?content=backup] per pool. Partial node failures are
/// skipped (empty list for that pool) so one offline node does not blank the
/// whole screen.
///
/// Pull-to-refresh: `ref.read(clusterBackupContentProvider.notifier).refresh()`.
@riverpod
class ClusterBackupContent extends _$ClusterBackupContent {
  @override
  Future<List<BackupContentEntry>> build() async {
    final allStorage = await ref.watch(allClusterStorageProvider.future);
    final repo = await ref.watch(storageRepositoryProvider.future);
    if (repo == null) {
      return const [];
    }

    final targets =
        allStorage.where((s) {
          return s.content.any((c) => c.toLowerCase() == 'backup');
        }).toList();

    final out = <BackupContentEntry>[];
    for (final s in targets) {
      try {
        final items = await repo.getStorageContent(
          s.node,
          s.id,
          contentKind: 'backup',
        );
        for (final item in items) {
          out.add(
            BackupContentEntry(node: s.node, storageId: s.id, item: item),
          );
        }
      } on Object {
        // Skip pools we cannot read (permissions, offline node, etc.).
      }
    }

    out.sort((a, b) {
      final at = a.item.ctime;
      final bt = b.item.ctime;
      if (at == null && bt == null) return 0;
      if (at == null) return 1;
      if (bt == null) return -1;
      return bt.compareTo(at);
    });
    return out;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
