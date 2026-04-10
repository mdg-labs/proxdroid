import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/features/vms/data/vm_repository.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import '../../../support/proxmox_test_client.dart';

void main() {
  test('getAllVms parses cluster/resources?type=vm and returns vms', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse([
        <String, dynamic>{
          'type': 'qemu',
          'vmid': 100,
          'name': 'web',
          'status': 'running',
          'node': 'n1',
          'cpu': 0.12,
          'maxmem': 1073741824,
          'mem': 536870912,
        },
      ]),
    ]);

    final repo = VmRepository(client);
    final vms = await repo.getAllVms();

    expect(vms, hasLength(1));
    final vm = vms.single;
    expect(vm.vmid, 100);
    expect(vm.name, 'web');
    expect(vm.status, VmStatus.running);
    expect(vm.node, 'n1');
    expect(vm.cpu, closeTo(0.12, 1e-9));
    expect(vm.maxMem, 1073741824);
    expect(vm.mem, 536870912);

    expect(adapter.requests, hasLength(1));
    expect(adapter.requests.single.path, ApiEndpoints.clusterResources);
    expect(adapter.requests.single.queryParameters['type'], 'vm');
  });
}
