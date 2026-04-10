import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/task.dart';
import 'package:proxdroid/features/tasks/data/task_repository.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import '../../../support/proxmox_test_client.dart';

void main() {
  test('getTasks forwards start, limit, typefilter', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse([
        <String, dynamic>{
          'upid': 'UPID:pve:00001:00002',
          'type': 'vzdump',
          'status': 'ok',
        },
      ]),
    ]);

    final repo = TaskRepository(client);
    final tasks = await repo.getTasks(
      'pve',
      start: 10,
      limit: 25,
      typefilter: 'vzdump',
    );

    expect(tasks, hasLength(1));
    expect(tasks.single.node, 'pve');
    expect(tasks.single.type, 'vzdump');
    expect(tasks.single.status, TaskStatus.ok);

    final opts = adapter.requests.single;
    expect(opts.path, ApiEndpoints.nodeTasks('pve'));
    expect(opts.queryParameters['start'], 10);
    expect(opts.queryParameters['limit'], 25);
    expect(opts.queryParameters['typefilter'], 'vzdump');
  });
}
