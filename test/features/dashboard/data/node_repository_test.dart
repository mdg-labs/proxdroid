import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/features/dashboard/data/node_repository.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import '../../../support/proxmox_test_client.dart';

void main() {
  test('getNodeStatus flattens swap, loadavg, and iowait', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(<String, dynamic>{
        'uptime': 3600,
        'cpu': 0.12,
        'memory': <String, dynamic>{'used': 1 << 30, 'total': 4 << 30},
        'rootfs': <String, dynamic>{'used': 10 << 30, 'total': 100 << 30},
        'swap': <String, dynamic>{'used': 1 << 20, 'total': 2 << 30},
        'loadavg': <String>['0.42', '0.50', '0.55'],
        'iowait': 0.03,
        'cpuinfo': <String, dynamic>{'cpus': 8},
      }),
    ]);

    final repo = NodeRepository(client);
    final node = await repo.getNodeStatus('pve-a');

    expect(adapter.requests.single.path, ApiEndpoints.nodeStatus('pve-a'));
    expect(node.name, 'pve-a');
    expect(node.maxCpu, 8);
    expect(node.swapUsed, 1 << 20);
    expect(node.swapTotal, 2 << 30);
    expect(node.loadavg1m, 0.42);
    expect(node.ioWait, 0.03);
  });

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
