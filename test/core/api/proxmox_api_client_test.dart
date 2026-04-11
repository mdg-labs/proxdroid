import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/guest_create_result.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

import 'fake_http_client_adapter.dart';

void main() {
  final serverToken = Server(
    id: 's1',
    name: 'Test',
    host: 'pve.example',
    port: 8006,
    authType: ServerAuthType.apiToken,
    allowSelfSigned: false,
  );

  final serverUser = Server(
    id: 's2',
    name: 'Test2',
    host: 'pve.example',
    port: 8006,
    authType: ServerAuthType.usernamePassword,
    allowSelfSigned: false,
  );

  test('API token: Authorization PVEAPIToken header on request', () async {
    final json = '{"data":{"version":"8.2","release":"1"}}';
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        json,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);

    final dio = Dio();
    dio.httpClientAdapter = adapter;

    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );

    final v = await client.fetchVersion();
    expect(v.version, '8.2');
    expect(v.release, '1');

    expect(adapter.requests, hasLength(1));
    final opts = adapter.requests.single;
    expect(opts.path, ApiEndpoints.version);
    expect(opts.headers['Authorization'], 'PVEAPIToken=root@pam!tok=secret');
  });

  test('username/password: ticket POST then Cookie on GET /version', () async {
    final ticketJson =
        '{"data":{"ticket":"PVE:root@pam:ABC","CSRFPreventionToken":"csrf123"}}';
    final versionJson = '{"data":{"version":"7.4","release":"3"}}';

    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        ticketJson,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
      ResponseBody.fromString(
        versionJson,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);

    final dio = Dio();
    dio.httpClientAdapter = adapter;

    final client = ProxmoxApiClient.withUsernamePassword(
      server: serverUser,
      username: 'root@pam',
      password: 'pw',
      dioOverride: dio,
    );

    final v = await client.fetchVersion();
    expect(v.version, '7.4');

    expect(adapter.requests, hasLength(2));

    final ticketReq = adapter.requests[0];
    expect(ticketReq.path, ApiEndpoints.accessTicket);
    expect(ticketReq.extra['proxmoxSkipAuth'], true);
    expect(ticketReq.data, isA<Map<String, dynamic>>());
    final body = ticketReq.data as Map<String, dynamic>;
    expect(body['username'], 'root@pam');
    expect(body['password'], 'pw');

    final versionReq = adapter.requests[1];
    expect(versionReq.path, ApiEndpoints.version);
    expect(versionReq.headers['Cookie'], 'PVEAuthCookie=PVE:root@pam:ABC');
  });

  test('rejects host containing http://', () {
    final bad = Server(
      id: 'b',
      name: 'B',
      host: 'http://evil',
      port: 8006,
      authType: ServerAuthType.apiToken,
      allowSelfSigned: false,
    );
    expect(
      () => ProxmoxApiClient.withApiToken(server: bad, apiToken: 't'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('rejects allowSelfSigned without pinnedTlsSha256', () {
    final bad = Server(
      id: 'x',
      name: 'X',
      host: 'pve.example',
      port: 8006,
      authType: ServerAuthType.apiToken,
      allowSelfSigned: true,
    );
    expect(
      () => ProxmoxApiClient.withApiToken(server: bad, apiToken: 't'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test(
    'username/password: 401 on GET refreshes ticket once then succeeds',
    () async {
      final ticketJson =
          '{"data":{"ticket":"PVE:root@pam:ONE","CSRFPreventionToken":"csrf1"}}';
      final ticketJson2 =
          '{"data":{"ticket":"PVE:root@pam:TWO","CSRFPreventionToken":"csrf2"}}';
      final versionJson = '{"data":{"version":"8.0","release":"0"}}';

      final adapter = FakeHttpClientAdapter([
        ResponseBody.fromString(
          ticketJson,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
        ResponseBody.fromString(
          '{}',
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
        ResponseBody.fromString(
          ticketJson2,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
        ResponseBody.fromString(
          versionJson,
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      ]);

      final dio = Dio();
      dio.httpClientAdapter = adapter;

      final client = ProxmoxApiClient.withUsernamePassword(
        server: serverUser,
        username: 'root@pam',
        password: 'pw',
        dioOverride: dio,
      );

      final v = await client.fetchVersion();
      expect(v.version, '8.0');
      expect(adapter.requests, hasLength(4));
      expect(adapter.requests[1].path, ApiEndpoints.version);
      expect(adapter.requests[3].path, ApiEndpoints.version);
      expect(
        adapter.requests[3].headers['Cookie'],
        'PVEAuthCookie=PVE:root@pam:TWO',
      );
    },
  );

  test('403 maps to PermissionException', () async {
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        '{"errors":"no way"}',
        403,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio();
    dio.httpClientAdapter = adapter;

    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );

    expect(client.fetchVersion(), throwsA(isA<PermissionException>()));
  });

  test('fetchQemuVmConfig parses data envelope', () async {
    final inner = <String, dynamic>{
      'vmid': 100,
      'name': 'vm1',
      'memory': 2048,
      'cores': 2,
      'net0': 'virtio=AA:BB,bridge=vmbr0',
    };
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': inner}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );

    final cfg = await client.fetchQemuVmConfig('node-1', 100);
    expect(cfg.name, 'vm1');
    expect(cfg.memory, '2048');
    expect(cfg.cores, '2');
    expect(cfg.netLines.single.apiKey, 'net0');
    expect(cfg.netLines.single.value, contains('vmbr0'));
    expect(
      adapter.requests.single.path,
      ApiEndpoints.nodeQemuVmConfig('node-1', 100),
    );
  });

  test('fetchLxcConfig parses data envelope', () async {
    final inner = <String, dynamic>{
      'vmid': 200,
      'hostname': 'ct1',
      'memory': 512,
      'rootfs': 'local:200/vm-200-disk-0.raw,size=4G',
      'mp0': 'local:snippets,mp=/snippets',
    };
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': inner}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );

    final cfg = await client.fetchLxcConfig('n2', 200);
    expect(cfg.hostname, 'ct1');
    expect(cfg.memory, '512');
    expect(cfg.mpLines.single.apiKey, 'mp0');
    expect(cfg.mpLines.single.value, contains('snippets'));
    expect(
      adapter.requests.single.path,
      ApiEndpoints.nodeLxcCtConfig('n2', 200),
    );
  });

  test('403 on GET qemu config maps to PermissionException', () async {
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        '{}',
        403,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 't',
      dioOverride: dio,
    );
    expect(
      client.fetchQemuVmConfig('n', 1),
      throwsA(isA<PermissionException>()),
    );
  });

  test('updateQemuVmConfig PUT form body contains only changed keys', () async {
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': null}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );

    await client.updateQemuVmConfig('my-node', 100, {'name': 'only-name'});
    final req = adapter.requests.single;
    expect(req.method, 'PUT');
    expect(req.path, ApiEndpoints.nodeQemuVmConfig('my-node', 100));
    expect(req.data, isA<Map>());
    expect((req.data as Map).length, 1);
    expect((req.data as Map)['name'], 'only-name');
    expect(
      req.headers['content-type'],
      contains('application/x-www-form-urlencoded'),
    );
  });

  test('updateQemuVmConfig passes delete=net1 query when requested', () async {
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': null}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );

    await client.updateQemuVmConfig(
      'n',
      50,
      {'name': 'x'},
      deleteKeys: ['net1'],
    );
    final req = adapter.requests.single;
    expect(req.queryParameters['delete'], 'net1');
  });

  test('fetchClusterNextId parses numeric data', () async {
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': 150}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );
    expect(await client.fetchClusterNextId(), 150);
    expect(adapter.requests.single.path, ApiEndpoints.clusterNextId);
  });

  test('createQemuVm POST form body and parses UPID string in data', () async {
    const upid = 'UPID:pve:00123456:0789ABCD:qmcreate:100:root@pam:';
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': upid}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 'root@pam!tok=secret',
      dioOverride: dio,
    );
    final body = <String, dynamic>{
      'vmid': 100,
      'name': 'vm-new',
      'memory': 512,
      'ostype': 'l26',
      'net0': 'virtio,bridge=vmbr0',
      'scsi0': 'local-lvm:8',
      'scsihw': 'virtio-scsi-single',
    };
    final r = await client.createQemuVm('node-a', body);
    expect(r, isA<GuestCreateResult>());
    expect(r.vmid, 100);
    expect(r.upid, upid);
    final req = adapter.requests.single;
    expect(req.path, ApiEndpoints.nodeQemuCreate('node-a'));
    expect(req.method, 'POST');
    expect(
      req.headers['content-type']?.toLowerCase(),
      contains('application/x-www-form-urlencoded'),
    );
    expect(req.data, isA<Map>());
    expect((req.data as Map)['vmid'], 100);
    expect((req.data as Map)['name'], 'vm-new');
  });

  test('createQemuVm null data yields result without UPID', () async {
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': null}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 't',
      dioOverride: dio,
    );
    final r = await client.createQemuVm('n', {
      'vmid': 101,
      'name': 'x',
      'memory': 128,
      'ostype': 'l26',
      'net0': 'virtio,bridge=vmbr0',
      'scsi0': 'local:1',
    });
    expect(r.vmid, 101);
    expect(r.upid, isNull);
  });

  test('createLxc POST uses nodeLxcCreate path', () async {
    const upid = 'UPID:pve:::::lxc_create:200:root@pam:';
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({'data': upid}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 't',
      dioOverride: dio,
    );
    final r = await client.createLxc('n2', {
      'vmid': 200,
      'hostname': 'ct-new',
      'password': 'secret',
      'ostype': 'debian',
      'rootfs': 'local-lvm:8',
      'memory': 512,
      'net0': 'name=eth0,bridge=vmbr0',
      'unprivileged': 1,
    });
    expect(r.upid, upid);
    expect(adapter.requests.single.path, ApiEndpoints.nodeLxcCreate('n2'));
  });

  test('fetchNodeNetworkIfaces GET nodeNetwork path', () async {
    final adapter = FakeHttpClientAdapter([
      ResponseBody.fromString(
        jsonEncode({
          'data': [
            {'iface': 'vmbr0', 'type': 'bridge'},
            {'iface': 'eth0', 'type': 'eth'},
          ],
        }),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ProxmoxApiClient.withApiToken(
      server: serverToken,
      apiToken: 't',
      dioOverride: dio,
    );
    final list = await client.fetchNodeNetworkIfaces('my-node');
    expect(adapter.requests.single.path, ApiEndpoints.nodeNetwork('my-node'));
    expect(list, hasLength(2));
    expect(list[0].iface, 'vmbr0');
    expect(list[0].isGuestAttachableBridge, isTrue);
    expect(list[1].isGuestAttachableBridge, isFalse);
  });
}
