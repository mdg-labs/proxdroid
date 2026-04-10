import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/backup.dart';
import 'package:proxdroid/core/models/storage.dart';
import 'package:proxdroid/features/dashboard/providers/dashboard_providers.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/storage/data/storage_repository.dart';

part 'storage_providers.g.dart';

@riverpod
Future<StorageRepository?> storageRepository(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) return null;
  return StorageRepository(client);
}

/// All storage pools across nodes with usage from [GET …/status] per pool.
///
/// Pull-to-refresh: `ref.read(allClusterStorageProvider.notifier).refresh()`.
@riverpod
class AllClusterStorage extends _$AllClusterStorage {
  @override
  Future<List<Storage>> build() async {
    final nodes = await ref.watch(nodeListProvider.future);
    final repo = await ref.watch(storageRepositoryProvider.future);
    if (repo == null || nodes.isEmpty) {
      return const [];
    }
    final lists = await Future.wait(
      nodes.map((n) => repo.getStorageWithUsageForNode(n.name)),
    );
    return lists.expand((e) => e).toList();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Status row for a single pool (detail header).
@riverpod
Future<Storage> storageDetail(
  StorageDetailRef ref,
  String node,
  String storageId,
) async {
  final repo = await ref.watch(storageRepositoryProvider.future);
  if (repo == null) {
    throw StateError('storageRepository unavailable');
  }
  return repo.getStorageStatus(node, storageId);
}

/// All content entries for a pool (backups, ISOs, …).
@riverpod
Future<List<BackupContent>> storageContent(
  StorageContentRef ref,
  String node,
  String storageId,
) async {
  final repo = await ref.watch(storageRepositoryProvider.future);
  if (repo == null) {
    return const [];
  }
  return repo.getStorageContent(node, storageId);
}
