import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/api/proxmox_api_client.dart';
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
}
