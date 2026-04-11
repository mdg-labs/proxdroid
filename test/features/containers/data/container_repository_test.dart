import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/models/container.dart';
import 'package:proxdroid/features/containers/data/container_repository.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import '../../../support/proxmox_test_client.dart';

ResponseBody _error400LxcNotInEnum() => ResponseBody.fromString(
  jsonEncode({
    'errors':
        '400 value "lxc" does not have a value in the enum \'vm, storage, node, sdn\'',
  }),
  400,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  test(
    'getAllContainers falls back to type=vm when type=lxc returns 400 enum error',
    () async {
      final (client, adapter) = proxmoxClientWithFakeAdapter([
        _error400LxcNotInEnum(),
        jsonResponse([
          <String, dynamic>{
            'type': 'qemu',
            'vmid': 100,
            'name': 'web',
            'status': 'running',
            'node': 'n1',
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

      final repo = ContainerRepository(client);
      final list = await repo.getAllContainers();

      expect(list, hasLength(1));
      expect(list.single.vmid, 200);
      expect(list.single.name, 'ct1');
      expect(list.single.status, ContainerStatus.running);
      expect(list.single.node, 'n1');

      expect(adapter.requests, hasLength(2));
      expect(adapter.requests[0].path, ApiEndpoints.clusterResources);
      expect(adapter.requests[0].queryParameters['type'], 'lxc');
      expect(adapter.requests[1].path, ApiEndpoints.clusterResources);
      expect(adapter.requests[1].queryParameters['type'], 'vm');
    },
  );

  test(
    'getAllContainers falls back to type=vm on 400 with empty JSON body',
    () async {
      final (client, adapter) = proxmoxClientWithFakeAdapter([
        ResponseBody.fromString(
          jsonEncode(<String, dynamic>{}),
          400,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
        jsonResponse([
          <String, dynamic>{
            'type': 'lxc',
            'vmid': 201,
            'name': 'ct-empty-400',
            'status': 'running',
            'node': 'n1',
          },
        ]),
      ]);

      final list = await ContainerRepository(client).getAllContainers();
      expect(list, hasLength(1));
      expect(list.single.vmid, 201);
      expect(adapter.requests, hasLength(2));
      expect(adapter.requests[0].queryParameters['type'], 'lxc');
      expect(adapter.requests[1].queryParameters['type'], 'vm');
    },
  );

  test('getAllContainers uses type=lxc when server accepts it', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse([
        <String, dynamic>{
          'type': 'lxc',
          'vmid': 300,
          'name': 'ct2',
          'status': 'stopped',
          'node': 'n2',
        },
      ]),
    ]);

    final repo = ContainerRepository(client);
    final list = await repo.getAllContainers();

    expect(list, hasLength(1));
    expect(list.single.vmid, 300);
    expect(adapter.requests, hasLength(1));
    expect(adapter.requests.single.queryParameters['type'], 'lxc');
  });

  test('getLxcConfig returns parsed config from client', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(<String, dynamic>{
        'hostname': 'ct-x',
        'memory': 256,
        'net0': 'bridge=vmbr0',
      }),
    ]);
    final cfg = await ContainerRepository(client).getLxcConfig('node-b', 202);
    expect(cfg.hostname, 'ct-x');
    expect(cfg.memory, '256');
    expect(cfg.passthrough['net0'], 'bridge=vmbr0');
    expect(
      adapter.requests.single.path,
      ApiEndpoints.nodeLxcCtConfig('node-b', 202),
    );
  });

  test('getLxcConfig maps 403 to PermissionException', () async {
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
      ContainerRepository(client).getLxcConfig('n', 2),
      throwsA(isA<PermissionException>()),
    );
  });

  test('updateLxcConfig passes delete query to client', () async {
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(null),
    ]);
    await ContainerRepository(
      client,
    ).updateLxcConfig('n', 7, {'hostname': 'h'}, deleteKeys: ['net1']);
    expect(adapter.requests.single.queryParameters['delete'], 'net1');
  });

  test('createContainer POST returns UPID from envelope', () async {
    const upid = 'UPID:n:::::lxc_create:300:root@pam:';
    final (client, adapter) = proxmoxClientWithFakeAdapter([
      jsonResponse(upid),
    ]);
    final r = await ContainerRepository(client).createContainer('node-y', {
      'vmid': 300,
      'hostname': 'ct',
      'password': 'pw',
      'ostype': 'ubuntu',
      'rootfs': 'local-lvm:4',
      'memory': 256,
      'net0': 'name=eth0,bridge=vmbr0,ip=dhcp',
      'unprivileged': 1,
    });
    expect(r.vmid, 300);
    expect(r.upid, upid);
    expect(adapter.requests.single.path, ApiEndpoints.nodeLxcCreate('node-y'));
  });
}
