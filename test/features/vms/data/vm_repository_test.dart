import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/api/api_exceptions.dart';
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
          'tags': 'public;color=FF0000',
        },
        <String, dynamic>{
          'type': 'lxc',
          'vmid': 200,
          'name': 'ct1',
          'status': 'running',
          'node': 'n1',
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
    expect(vm.tags, hasLength(1));
    expect(vm.tags.single.label, 'public');
    expect(vm.tags.single.inlineBackgroundHex, 'FF0000');

    expect(adapter.requests, hasLength(1));
    expect(adapter.requests.single.path, ApiEndpoints.clusterResources);
    expect(adapter.requests.single.queryParameters['type'], 'vm');
  });

  test('getQemuConfig returns parsed config from client', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(<String, dynamic>{
        'name': 'r-vm',
        'memory': 1024,
        'scsi0': 'local:vm-disk',
      }),
    ]);
    final repo = VmRepository(client);
    final cfg = await repo.getQemuConfig('node-a', 10);
    expect(cfg.name, 'r-vm');
    expect(cfg.memory, '1024');
    expect(cfg.diskLines.single.apiKey, 'scsi0');
    expect(cfg.diskLines.single.value, 'local:vm-disk');
    expect(
      adapter.requests.single.path,
      ApiEndpoints.nodeQemuVmConfig('node-a', 10),
    );
  });

  test('getQemuConfig maps 403 to PermissionException', () async {
    final (client, _) = proxmoxClientWithFakeAdapter([
      ResponseBody.fromString(
        jsonEncode(<String, dynamic>{}),
        403,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    await expectLater(
      VmRepository(client).getQemuConfig('n', 1),
      throwsA(isA<PermissionException>()),
    );
  });

  test('updateQemuConfig sends PUT with given body map', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(null),
    ]);
    await VmRepository(client).updateQemuConfig('n', 99, {'name': 'only'});
    expect(adapter.requests.single.method, 'PUT');
    expect(adapter.requests.single.data, {'name': 'only'});
  });

  test('createVm POST returns UPID from envelope', () async {
    const upid = 'UPID:x:y:z:qmcreate:105:root@pam:';
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(upid),
    ]);
    final r = await VmRepository(client).createVm('node-x', {
      'vmid': 105,
      'name': 'a',
      'memory': 1024,
      'ostype': 'l26',
      'net0': 'virtio,bridge=vmbr0',
      'scsi0': 'local-lvm:16',
    });
    expect(r.vmid, 105);
    expect(r.upid, upid);
    expect(adapter.requests.single.path, ApiEndpoints.nodeQemuCreate('node-x'));
  });

  test('fetchNextGuestId calls cluster nextid', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([jsonResponse(199)]);
    expect(await VmRepository(client).fetchNextGuestId(), 199);
    expect(adapter.requests.single.path, ApiEndpoints.clusterNextId);
  });
}
