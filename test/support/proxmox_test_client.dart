import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:proxdroid/core/api/proxmox_api_client.dart';
import 'package:proxdroid/core/models/server.dart';

import '../core/api/fake_http_client_adapter.dart';

/// Minimal [Server] for tests using [proxmoxClientWithFakeAdapter].
final Server kTestProxmoxServer = Server(
  id: 'test-srv',
  name: 'Test',
  host: 'pve.test',
  port: 8006,
  authType: ServerAuthType.apiToken,
  allowSelfSigned: false,
);

/// JSON envelope Proxmox uses: `{ "data": ... }`.
String proxmoxEnvelopeJson(Object data) => jsonEncode({'data': data});

/// [ProxmoxApiClient] with canned [responses] (API token auth, fake HTTP).
(ProxmoxApiClient client, FakeHttpClientAdapter adapter)
proxmoxClientWithFakeAdapter(List<ResponseBody> responses) {
  final adapter = FakeHttpClientAdapter(responses);
  final dio = Dio();
  dio.httpClientAdapter = adapter;
  final client = ProxmoxApiClient.withApiToken(
    server: kTestProxmoxServer,
    apiToken: 'root@pam!tok=test',
    dioOverride: dio,
  );
  return (client, adapter);
}

ResponseBody jsonResponse(Object data, [int status = 200]) =>
    ResponseBody.fromString(
      proxmoxEnvelopeJson(data),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
