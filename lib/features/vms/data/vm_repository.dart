import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/vm.dart';

class VmRepository {
  VmRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<Vm>> getAllVms() => _client.fetchAllVms();

  Future<List<Vm>> getVms(String node) => _client.fetchVmsForNode(node);
}
