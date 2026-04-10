import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/container.dart';

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
}
