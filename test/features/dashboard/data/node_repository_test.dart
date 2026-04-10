import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/features/dashboard/data/node_repository.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import '../../../support/proxmox_test_client.dart';

void main() {
  test('getNodes uses cluster/resources?type=node', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse([
        <String, dynamic>{
          'type': 'node',
          'node': 'pve-a',
          'status': 'online',
          'maxcpu': 8,
          'cpu': 0.05,
        },
      ]),
    ]);

    final repo = NodeRepository(client);
    final nodes = await repo.getNodes();

    expect(nodes.single.name, 'pve-a');
    expect(nodes.single.status, 'online');
    expect(nodes.single.maxCpu, 8);

    expect(adapter.requests.single.path, ApiEndpoints.clusterResources);
    expect(adapter.requests.single.queryParameters['type'], 'node');
  });
}
