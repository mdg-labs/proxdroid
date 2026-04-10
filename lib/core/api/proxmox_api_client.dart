import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/api/api_interceptors.dart';
import 'package:proxdroid/core/models/container.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/proxmox_json_helpers.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

/// Parsed `GET /version` payload (`data` object).
final class ProxmoxVersion {
  const ProxmoxVersion({required this.version, this.release});

  final String version;
  final String? release;

  factory ProxmoxVersion.fromDataJson(Map<String, dynamic> json) {
    final v = json['version'];
    final r = json['release'];
    return ProxmoxVersion(
      version: v is String ? v : v?.toString() ?? '',
      release: r is String ? r : r?.toString(),
    );
  }
}

/// Dio client for Proxmox `api2/json` with token or ticket authentication.
///
/// Credentials ([apiToken] or [username]/[password]) must be loaded from
/// secure storage by the caller — this class does not persist them.
/// Ticket and CSRF tokens for password auth exist only in memory on the
/// [ProxmoxAuthInterceptor] instance.
class ProxmoxApiClient {
  ProxmoxApiClient._(this._dio, this._auth);

  final Dio _dio;
  final ProxmoxAuthInterceptor _auth;

  /// Creates a client for [server] using an API token (full
  /// `USER@REALM!TOKENID=SECRET` value for the `PVEAPIToken=` header).
  factory ProxmoxApiClient.withApiToken({
    required Server server,
    required String apiToken,
    Dio? dioOverride,
    HttpClientAdapter? httpClientAdapterOverride,
  }) {
    _assertServerAuth(server, ServerAuthType.apiToken);
    return _create(
      server: server,
      serverAuthIsToken: true,
      apiToken: apiToken,
      dioOverride: dioOverride,
      httpClientAdapterOverride: httpClientAdapterOverride,
    );
  }

  /// Creates a client for [server] using username/password (ticket flow).
  factory ProxmoxApiClient.withUsernamePassword({
    required Server server,
    required String username,
    required String password,
    Dio? dioOverride,
    HttpClientAdapter? httpClientAdapterOverride,
  }) {
    _assertServerAuth(server, ServerAuthType.usernamePassword);
    return _create(
      server: server,
      serverAuthIsToken: false,
      username: username,
      password: password,
      dioOverride: dioOverride,
      httpClientAdapterOverride: httpClientAdapterOverride,
    );
  }

  /// Unified factory: prefer [withApiToken] / [withUsernamePassword].
  factory ProxmoxApiClient({
    required Server server,
    String? apiToken,
    String? username,
    String? password,
    Dio? dioOverride,
    HttpClientAdapter? httpClientAdapterOverride,
  }) {
    switch (server.authType) {
      case ServerAuthType.apiToken:
        if (apiToken == null) {
          throw ArgumentError(
            'apiToken is required for ServerAuthType.apiToken',
          );
        }
        return ProxmoxApiClient.withApiToken(
          server: server,
          apiToken: apiToken,
          dioOverride: dioOverride,
          httpClientAdapterOverride: httpClientAdapterOverride,
        );
      case ServerAuthType.usernamePassword:
        if (username == null || password == null) {
          throw ArgumentError(
            'username and password are required for '
            'ServerAuthType.usernamePassword',
          );
        }
        return ProxmoxApiClient.withUsernamePassword(
          server: server,
          username: username,
          password: password,
          dioOverride: dioOverride,
          httpClientAdapterOverride: httpClientAdapterOverride,
        );
    }
  }

  static void _assertServerAuth(Server server, ServerAuthType expected) {
    if (server.authType != expected) {
      throw ArgumentError(
        'Server.authType is ${server.authType}, expected $expected',
      );
    }
  }

  static ProxmoxApiClient _create({
    required Server server,
    required bool serverAuthIsToken,
    String? apiToken,
    String? username,
    String? password,
    Dio? dioOverride,
    HttpClientAdapter? httpClientAdapterOverride,
  }) {
    final baseUrl = _buildBaseUrl(server);
    final ownDio = dioOverride == null;
    final dio =
        dioOverride ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );

    dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 30);

    if (httpClientAdapterOverride != null) {
      dio.httpClientAdapter = httpClientAdapterOverride;
    } else if (ownDio) {
      dio.httpClientAdapter = _adapterForServer(server);
    }

    final auth = ProxmoxAuthInterceptor(
      dio: dio,
      serverAuthIsToken: serverAuthIsToken,
      apiToken: apiToken,
      username: username,
      password: password,
    );

    final err = ProxmoxErrorInterceptor();
    if (ownDio) {
      dio.interceptors
        ..clear()
        ..add(err)
        ..add(auth);
    } else {
      dio.interceptors.insertAll(0, [auth, err]);
    }

    return ProxmoxApiClient._(dio, auth);
  }

  static String _buildBaseUrl(Server server) {
    final host = _normalizeHost(server.host);
    final uri = Uri(
      scheme: 'https',
      host: host,
      port: server.port,
      pathSegments: const ['api2', 'json'],
    );
    var s = uri.toString();
    if (s.endsWith('/')) {
      s = s.substring(0, s.length - 1);
    }
    return s;
  }

  /// Strips accidental scheme; rejects cleartext. IPv6 may be stored with or
  /// without brackets — [Uri] expects the host without brackets.
  static String _normalizeHost(String raw) {
    var h = raw.trim();
    if (h.isEmpty) {
      throw ArgumentError('Server host is empty');
    }
    final lower = h.toLowerCase();
    if (lower.startsWith('http://')) {
      throw ArgumentError(
        'Cleartext HTTP is not supported. Enter host without http:// — '
        'the app always uses HTTPS.',
      );
    }
    if (lower.startsWith('https://')) {
      h = h.substring(8);
      final slash = h.indexOf('/');
      if (slash >= 0) {
        h = h.substring(0, slash);
      }
    }
    if (h.startsWith('[') && h.endsWith(']')) {
      h = h.substring(1, h.length - 1);
    }
    return h;
  }

  static HttpClientAdapter _adapterForServer(Server server) {
    if (server.allowSelfSigned) {
      return IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }
    return IOHttpClientAdapter();
  }

  /// Clears in-memory ticket session (e.g. after logout). No-op for API token.
  void clearSession() => _auth.clearSession();

  /// Connection check: `GET /version`.
  Future<ProxmoxVersion> fetchVersion() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.version),
    );
    final body = response.data;
    if (body == null) {
      throw const ServerException(502, message: 'Empty version response');
    }
    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const ServerException(502, message: 'Invalid version response');
    }
    return ProxmoxVersion.fromDataJson(data);
  }

  /// `GET /nodes` — cluster node list (online/offline, fingerprint, …).
  Future<List<Node>> fetchNodes() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodes),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Node.fromJson(m);
    }).toList();
  }

  /// `GET /nodes/{node}/status` — CPU, memory, uptime, etc.
  ///
  /// Normalizes nested `memory`, `rootfs`, and `cpuinfo` into flat keys expected
  /// by [Node.fromJson], and sets `node` to [node].
  Future<Node> fetchNodeStatus(String node) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeStatus(node)),
    );
    final body = response.data;
    final raw = body?['data'];
    if (raw is! Map<String, dynamic>) {
      throw const ServerException(502, message: 'Invalid node status response');
    }
    return Node.fromJson(_normalizeNodeStatusJson(raw, node));
  }

  /// `GET /cluster/resources?type=node` — node rows (resource view).
  Future<List<Node>> fetchClusterResourceNodes() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.clusterResources,
        queryParameters: const {'type': 'node'},
      ),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Node.fromJson(m);
    }).toList();
  }

  /// `GET /cluster/resources?type=vm` — all QEMU guests cluster-wide.
  Future<List<Vm>> fetchAllVms() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.clusterResources,
        queryParameters: const {'type': 'vm'},
      ),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Vm.fromClusterResourcesItem(m);
    }).toList();
  }

  /// `GET /nodes/{node}/qemu` — VMs on one node.
  Future<List<Vm>> fetchVmsForNode(String node) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeQemu(node)),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Vm.fromQemuListRow(m, node: node);
    }).toList();
  }

  /// `GET /cluster/resources?type=lxc` — all LXCs cluster-wide.
  Future<List<Container>> fetchAllContainers() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.clusterResources,
        queryParameters: const {'type': 'lxc'},
      ),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Container.fromClusterResourcesItem(m);
    }).toList();
  }

  /// `GET /nodes/{node}/lxc` — containers on one node.
  Future<List<Container>> fetchContainersForNode(String node) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeLxc(node)),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Container.fromLxcListRow(m, node: node);
    }).toList();
  }

  Future<Response<T>> _unwrap<T>(Future<Response<T>> future) async {
    try {
      return await future;
    } on DioException catch (e) {
      final err = e.error;
      if (err is ProxmoxException) {
        throw err;
      }
      throw mapDioException(e);
    }
  }
}

List<dynamic> _dataAsList(dynamic data) {
  if (data is! List<dynamic>) {
    throw const ServerException(502, message: 'Expected JSON array in data');
  }
  return data;
}

/// Flattens PVE node status payload for [Node.fromJson].
Map<String, dynamic> _normalizeNodeStatusJson(
  Map<String, dynamic> data,
  String nodeName,
) {
  final out = Map<String, dynamic>.from(data);
  out['node'] = nodeName;

  final memory = data['memory'];
  if (memory is Map) {
    out['mem'] ??= proxmoxInt(memory['used']);
    out['maxmem'] ??= proxmoxInt(memory['total']);
  }

  final rootfs = data['rootfs'];
  if (rootfs is Map) {
    out['disk'] ??= proxmoxInt(rootfs['used']);
    out['maxdisk'] ??= proxmoxInt(rootfs['total']);
  }

  if (out['maxcpu'] == null && data['cpuinfo'] is Map<String, dynamic>) {
    final ci = data['cpuinfo'] as Map<String, dynamic>;
    out['maxcpu'] = proxmoxInt(ci['cpus']);
  }

  return out;
}
