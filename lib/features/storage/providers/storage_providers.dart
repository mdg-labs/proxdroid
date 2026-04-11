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

/// Active storage pools on [node] that advertise [contentKind] in PVE `content`
/// (e.g. `images` for QEMU disks, `rootdir` for LXC root).
@riverpod
Future<List<Storage>> nodeStoragePoolsWithKind(
  NodeStoragePoolsWithKindRef ref,
  String node,
  String contentKind,
) async {
  final repo = await ref.watch(storageRepositoryProvider.future);
  if (repo == null) {
    return const [];
  }
  final pools = await repo.getStorageForNode(node);
  final k = contentKind.toLowerCase();
  final filtered =
      pools
          .where((s) => s.active && s.content.any((c) => c.toLowerCase() == k))
          .toList()
        ..sort((a, b) => a.id.compareTo(b.id));
  return filtered;
}

/// Volumes under a pool filtered by PVE `content` (e.g. `images`, `rootdir`).
@riverpod
Future<List<BackupContent>> guestStorageContentByKind(
  GuestStorageContentByKindRef ref,
  String node,
  String storageId,
  String contentKind,
) async {
  final repo = await ref.watch(storageRepositoryProvider.future);
  if (repo == null) {
    return const [];
  }
  return repo.getStorageContent(
    node,
    storageId,
    contentKind: contentKind,
    start: 0,
    limit: 500,
  );
}
