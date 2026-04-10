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

  /// `POST /nodes/{node}/qemu/{vmid}/status/{action}` — [action] is one of
  /// `start`, `shutdown`, `stop`, `reboot`.
  static String nodeQemuVmStatus(String node, int vmid, String action) =>
      '/nodes/${Uri.encodeComponent(node)}/qemu/'
      '${Uri.encodeComponent(vmid.toString())}/status/'
      '${Uri.encodeComponent(action)}';

  /// `POST /nodes/{node}/lxc/{ctid}/status/{action}` — [action] is one of
  /// `start`, `shutdown`, `stop`, `reboot`.
  static String nodeLxcCtStatus(String node, int ctid, String action) =>
      '/nodes/${Uri.encodeComponent(node)}/lxc/'
      '${Uri.encodeComponent(ctid.toString())}/status/'
      '${Uri.encodeComponent(action)}';

  /// `GET /nodes/{node}/tasks` — optional `start` and `limit` query params.
  static String nodeTasks(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/tasks';

  /// `GET /nodes/{node}/tasks/{upid}/status` — [upid] must be URL-encoded.
  static String nodeTaskStatus(String node, String upid) =>
      '/nodes/${Uri.encodeComponent(node)}/tasks/'
      '${Uri.encodeComponent(upid)}/status';

  /// `GET /nodes/{node}/tasks/{upid}/log` — [upid] must be URL-encoded;
  /// optional `start` and `limit` query params.
  static String nodeTaskLog(String node, String upid) =>
      '/nodes/${Uri.encodeComponent(node)}/tasks/'
      '${Uri.encodeComponent(upid)}/log';
}
