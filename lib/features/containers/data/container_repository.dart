import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/container.dart';
import 'package:proxdroid/core/models/guest_create_result.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';

class ContainerRepository {
  ContainerRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<Container>> getAllContainers() => _client.fetchAllContainers();

  Future<List<Container>> getContainers(String node) =>
      _client.fetchContainersForNode(node);

  Future<String> startContainer(String node, int ctid) =>
      _client.startLxc(node, ctid);

  Future<String> shutdownContainer(
    String node,
    int ctid, {
    bool? forceStop,
    int? timeout,
  }) => _client.shutdownLxc(node, ctid, forceStop: forceStop, timeout: timeout);

  Future<String> stopContainer(String node, int ctid) =>
      _client.stopLxc(node, ctid);

  Future<String> rebootContainer(String node, int ctid) =>
      _client.rebootLxc(node, ctid);

  Future<LxcContainerConfig> getLxcConfig(String node, int ctid) =>
      _client.fetchLxcConfig(node, ctid);

  Future<void> updateLxcConfig(
    String node,
    int ctid,
    Map<String, dynamic> body, {
    List<String>? deleteKeys,
  }) => _client.updateLxcConfig(node, ctid, body, deleteKeys: deleteKeys);

  /// Next free cluster guest id (`GET /cluster/nextid`).
  Future<int> fetchNextGuestId() => _client.fetchClusterNextId();

  /// `POST /nodes/{node}/lxc` — create CT; see [ProxmoxApiClient.createLxc].
  Future<GuestCreateResult> createContainer(
    String node,
    Map<String, dynamic> body,
  ) => _client.createLxc(node, body);
}
