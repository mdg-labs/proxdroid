import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';

/// Thin repository for Proxmox RRD chart endpoints (delegates to [ProxmoxApiClient]).
class RrdRepository {
  RrdRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<ResourceDataPoint>> getVmRrd(
    String node,
    int vmid,
    ChartTimeframe timeframe,
  ) => _client.fetchQemuRrdData(node, vmid, timeframe);

  Future<List<ResourceDataPoint>> getLxcRrd(
    String node,
    int ctid,
    ChartTimeframe timeframe,
  ) => _client.fetchLxcRrdData(node, ctid, timeframe);

  Future<List<ResourceDataPoint>> getNodeRrd(
    String node,
    ChartTimeframe timeframe,
  ) => _client.fetchNodeRrdData(node, timeframe);
}
