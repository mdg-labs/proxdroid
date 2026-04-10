import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/backup.dart';
import 'package:proxdroid/core/models/task.dart';

/// Cluster backup jobs, vzdump trigger, and vzdump task listing.
class BackupRepository {
  BackupRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<BackupJob>> getBackupJobs() => _client.fetchClusterBackupJobs();

  Future<String> triggerVzdump(
    String node, {
    required int vmid,
    required String storage,
    required String mode,
    required String compress,
  }) => _client.triggerVzdump(
    node,
    vmid: vmid,
    storage: storage,
    mode: mode,
    compress: compress,
  );

  Future<List<Task>> getVzdumpTasksForNode(
    String node, {
    int start = 0,
    int limit = 50,
  }) => _client.fetchVzdumpTasksForNode(node, start: start, limit: limit);
}
