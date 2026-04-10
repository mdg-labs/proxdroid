/// Proxmox REST paths relative to the API base `https://host:port/api2/json`.
///
/// Use with Dio [BaseOptions.baseUrl] ending in `/api2/json` so requests use
/// paths like [version] → `GET /api2/json/version`.
abstract final class ApiEndpoints {
  /// `GET /version` — cluster / daemon version (connection test).
  static const String version = '/version';

  /// `POST /access/ticket` — username/password login (form body).
  static const String accessTicket = '/access/ticket';

  /// `GET /nodes` — cluster node list.
  static const String nodes = '/nodes';

  /// `GET /nodes/{node}/status` — node resource / host status.
  static String nodeStatus(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/status';

  /// `GET /cluster/resources` — nodes, VMs, LXCs, storage, etc. (optional
  /// `type` query: `vm`, `lxc`, `node`, …).
  static const String clusterResources = '/cluster/resources';

  /// `GET /nodes/{node}/qemu` — VMs on a single node.
  static String nodeQemu(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/qemu';

  /// `GET /nodes/{node}/lxc` — LXCs on a single node.
  static String nodeLxc(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/lxc';
}
