import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/vm.dart';

class VmRepository {
  VmRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<Vm>> getAllVms() => _client.fetchAllVms();

  Future<List<Vm>> getVms(String node) => _client.fetchVmsForNode(node);

  Future<String> startVm(String node, int vmid) => _client.startVm(node, vmid);

  Future<String> shutdownVm(
    String node,
    int vmid, {
    bool? forceStop,
    int? timeout,
  }) => _client.shutdownVm(node, vmid, forceStop: forceStop, timeout: timeout);

  Future<String> stopVm(String node, int vmid) => _client.stopVm(node, vmid);

  Future<String> rebootVm(String node, int vmid) =>
      _client.rebootVm(node, vmid);
}
