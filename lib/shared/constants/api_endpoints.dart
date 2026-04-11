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

  /// `GET /cluster/resources` — nodes, guests, storage, etc. (optional `type`
  /// query). Some gateways only allow `type` in `{ vm, storage, node, sdn }`;
  /// container list code tries `type=lxc` first, then `type=vm` plus client-side
  /// filter for `lxc` rows.
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

  /// `GET /nodes/{node}/qemu/{vmid}/rrddata` — optional `timeframe` query
  /// (`hour`, `day`, `week`, `month`).
  static String nodeQemuVmRrdData(String node, int vmid) =>
      '/nodes/${Uri.encodeComponent(node)}/qemu/'
      '${Uri.encodeComponent(vmid.toString())}/rrddata';

  /// `GET /nodes/{node}/lxc/{ctid}/rrddata` — optional `timeframe` query.
  static String nodeLxcCtRrdData(String node, int ctid) =>
      '/nodes/${Uri.encodeComponent(node)}/lxc/'
      '${Uri.encodeComponent(ctid.toString())}/rrddata';

  /// `GET /nodes/{node}/rrddata` — node-level RRD; optional `timeframe` query.
  static String nodeRrdData(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/rrddata';

  /// `GET /nodes/{node}/storage` — storage pools on a node.
  static String nodeStorage(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/storage';

  /// `GET /nodes/{node}/storage/{storage}/status` — capacity and usage.
  static String nodeStorageStatus(String node, String storage) =>
      '/nodes/${Uri.encodeComponent(node)}/storage/'
      '${Uri.encodeComponent(storage)}/status';

  /// `GET /nodes/{node}/storage/{storage}/content` — volumes (optional
  /// `content` query, e.g. `backup`, `iso`).
  static String nodeStorageContent(String node, String storage) =>
      '/nodes/${Uri.encodeComponent(node)}/storage/'
      '${Uri.encodeComponent(storage)}/content';

  /// `GET /cluster/backup` — scheduled vzdump jobs (cluster-scoped).
  static const String clusterBackup = '/cluster/backup';

  /// `POST /nodes/{node}/vzdump` — run a manual backup (form body).
  static String nodeVzdump(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/vzdump';

  /// `GET|PUT /nodes/{node}/qemu/{vmid}/config` — QEMU VM configuration.
  static String nodeQemuVmConfig(String node, int vmid) =>
      '/nodes/${Uri.encodeComponent(node)}/qemu/'
      '${Uri.encodeComponent(vmid.toString())}/config';

  /// `GET|PUT /nodes/{node}/lxc/{vmid}/config` — LXC CT configuration (CT id
  /// is API `vmid`).
  static String nodeLxcCtConfig(String node, int vmid) =>
      '/nodes/${Uri.encodeComponent(node)}/lxc/'
      '${Uri.encodeComponent(vmid.toString())}/config';

  /// `POST /nodes/{node}/qemu` — create QEMU VM (form body).
  static String nodeQemuCreate(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/qemu';

  /// `POST /nodes/{node}/lxc` — create LXC container (form body).
  static String nodeLxcCreate(String node) =>
      '/nodes/${Uri.encodeComponent(node)}/lxc';

  /// `GET /cluster/nextid` — next free guest ID.
  static const String clusterNextId = '/cluster/nextid';
}
