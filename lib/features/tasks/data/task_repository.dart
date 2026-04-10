import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/task.dart';

class TaskRepository {
  TaskRepository(this._client);

  final ProxmoxApiClient _client;

  Future<List<Task>> getTasks(String node, {int start = 0, int limit = 50}) =>
      _client.fetchTasksForNode(node, start: start, limit: limit);

  Future<TaskStatus> getTaskStatus(String node, String upid) =>
      _client.fetchTaskStatus(node, upid);

  Future<List<String>> getTaskLog(
    String node,
    String upid, {
    int start = 0,
    int limit = 500,
  }) => _client.fetchTaskLog(node, upid, start: start, limit: limit);
}
