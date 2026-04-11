import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/node_network_iface.dart';
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

/// Live fields from `GET /nodes/{node}/status` for the node detail grid.
///
/// Returns `null` when no API client is configured (should not happen on
/// `/dashboard/:node` due to router redirect).
@riverpod
Future<Node?> nodeDetailStatus(Ref ref, String nodeName) async {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  if (repo == null) {
    return null;
  }
  return repo.getNodeStatus(nodeName);
}

/// Linux / OVS bridges and related ifaces for guest `bridge=` pickers.
@riverpod
Future<List<NodeNetworkIface>> nodeNetworkBridges(
  NodeNetworkBridgesRef ref,
  String node,
) async {
  final repo = await ref.watch(nodeRepositoryProvider.future);
  if (repo == null) {
    return const [];
  }
  final list = await repo.getNetworkIfaces(node);
  final bridges =
      list.where((i) => i.isGuestAttachableBridge).toList()
        ..sort((a, b) => a.iface.compareTo(b.iface));
  return bridges;
}
