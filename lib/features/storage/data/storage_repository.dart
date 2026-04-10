import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/backup.dart';
import 'package:proxdroid/core/models/storage.dart';

/// Storage pools and content via Proxmox API.
class StorageRepository {
  StorageRepository(this._client);

  final ProxmoxApiClient _client;

  /// List rows from [GET /nodes/{node}/storage] (no usage until [getStorageWithUsageForNode]).
  Future<List<Storage>> getStorageForNode(String node) =>
      _client.fetchStorageForNode(node);

  /// Fetches each pool’s [GET …/status] and returns merged rows (falls back to list row on failure).
  Future<List<Storage>> getStorageWithUsageForNode(String node) async {
    final pools = await _client.fetchStorageForNode(node);
    final out = <Storage>[];
    for (final s in pools) {
      try {
        final st = await _client.fetchStorageStatus(node, s.id);
        // Status payload may omit `active`; keep the list row flag when set.
        out.add(st.copyWith(active: st.active || s.active));
      } on Object {
        out.add(s);
      }
    }
    return out;
  }

  Future<Storage> getStorageStatus(String node, String storageId) =>
      _client.fetchStorageStatus(node, storageId);

  Future<List<BackupContent>> getStorageContent(
    String node,
    String storageId, {
    String? contentKind,
  }) => _client.fetchStorageContent(node, storageId, contentKind: contentKind);
}
