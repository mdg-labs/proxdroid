import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/guest_create_result.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';
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

  Future<QemuVmConfig> getQemuConfig(String node, int vmid) =>
      _client.fetchQemuVmConfig(node, vmid);

  Future<void> updateQemuConfig(
    String node,
    int vmid,
    Map<String, dynamic> body, {
    List<String>? deleteKeys,
  }) => _client.updateQemuVmConfig(node, vmid, body, deleteKeys: deleteKeys);

  /// Next free cluster guest id (`GET /cluster/nextid`).
  Future<int> fetchNextGuestId() => _client.fetchClusterNextId();

  /// `POST /nodes/{node}/qemu` — create VM; see [ProxmoxApiClient.createQemuVm].
  Future<GuestCreateResult> createVm(String node, Map<String, dynamic> body) =>
      _client.createQemuVm(node, body);
}
