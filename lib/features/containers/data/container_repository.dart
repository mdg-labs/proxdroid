import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/container.dart';

class ContainerRepository {
  ContainerRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<Container>> getAllContainers() => _client.fetchAllContainers();

  Future<List<Container>> getContainers(String node) =>
      _client.fetchContainersForNode(node);
}
