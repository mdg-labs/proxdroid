import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/features/containers/providers/container_providers.dart';
import 'package:proxdroid/features/dashboard/data/dashboard_repository.dart';
import 'package:proxdroid/features/dashboard/data/node_repository.dart';
import 'package:proxdroid/features/servers/providers/server_providers.dart';
import 'package:proxdroid/features/vms/providers/vm_providers.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<NodeRepository?> nodeRepository(Ref ref) async {
  final client = await ref.watch(apiClientProvider.future);
  if (client == null) return null;
  return NodeRepository(client);
}

@riverpod
Future<DashboardRepository?> dashboardRepository(Ref ref) async {
  final nodes = await ref.watch(nodeRepositoryProvider.future);
  final vms = await ref.watch(vmRepositoryProvider.future);
  final containers = await ref.watch(containerRepositoryProvider.future);
  if (nodes == null || vms == null || containers == null) return null;
  return DashboardRepository(nodes, vms, containers);
}

/// Cluster node list (`nodeListProvider`). Pull-to-refresh:
/// `ref.read(nodeListProvider.notifier).refresh()`.
@riverpod
class NodeList extends _$NodeList {
  @override
  Future<List<Node>> build() async {
    final repo = await ref.watch(nodeRepositoryProvider.future);
    if (repo == null) return const [];
    return repo.getNodes();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
