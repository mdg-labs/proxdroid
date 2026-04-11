import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/node_network_iface.dart';

/// Loads node overview data for the dashboard and node list.
///
/// [getNodes] uses [ProxmoxApiClient.fetchClusterResourceNodes] — one
/// `cluster/resources?type=node` request — so the UI gets resource-oriented rows
/// for every node without N per-node list calls. Use [getNodeStatus] when a
/// screen needs the full `/nodes/{node}/status` payload (CPU, memory, uptime,
/// etc.) for a single node.
class NodeRepository {
  NodeRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<Node>> getNodes() => _client.fetchClusterResourceNodes();

  Future<Node> getNodeStatus(String node) => _client.fetchNodeStatus(node);

  /// `GET /nodes/{node}/network` — bridges and related ifaces for guest `netN`.
  Future<List<NodeNetworkIface>> getNetworkIfaces(String node) =>
      _client.fetchNodeNetworkIfaces(node);
}
