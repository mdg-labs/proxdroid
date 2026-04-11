import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:proxdroid/core/api/api_exceptions.dart';
import 'package:proxdroid/core/api/api_interceptors.dart';
import 'package:proxdroid/core/models/backup.dart';
import 'package:proxdroid/core/models/container.dart';
import 'package:proxdroid/core/models/node.dart';
import 'package:proxdroid/core/models/node_network_iface.dart';
import 'package:proxdroid/core/models/proxmox_json_helpers.dart';
import 'package:proxdroid/core/models/storage.dart';
import 'package:proxdroid/core/models/resource_data_point.dart';
import 'package:proxdroid/core/models/server.dart';
import 'package:proxdroid/core/models/task.dart';
import 'package:proxdroid/core/models/lxc_container_config.dart';
import 'package:proxdroid/core/models/proxmox_version.dart';
import 'package:proxdroid/core/models/qemu_vm_config.dart';
import 'package:proxdroid/core/models/guest_create_result.dart';
import 'package:proxdroid/core/models/vm.dart';
import 'package:proxdroid/core/network/proxmox_server_host.dart';
import 'package:proxdroid/core/network/tls_pinning.dart';
import 'package:proxdroid/shared/constants/api_endpoints.dart';

export 'package:proxdroid/core/models/proxmox_version.dart' show ProxmoxVersion;

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
    if (server.allowSelfSigned) {
      if (!isValidPinnedTlsSha256Format(server.pinnedTlsSha256)) {
        throw ArgumentError(
          'allowSelfSigned requires pinnedTlsSha256: a 64-character '
          'hexadecimal SHA-256 fingerprint of the server leaf certificate '
          '(use Fetch certificate fingerprint in the server editor).',
        );
      }
    }
    final baseUrl = _buildBaseUrl(server);
    final ownDio = dioOverride == null;
    final dio =
        dioOverride ??
        Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );

    dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..sendTimeout = const Duration(seconds: 30)
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
    final host = normalizeProxmoxServerHost(server.host);
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

  static HttpClientAdapter _adapterForServer(Server server) {
    if (!server.allowSelfSigned) {
      return IOHttpClientAdapter();
    }
    final pin = normalizePinnedTlsSha256(server.pinnedTlsSha256)!;
    return IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                certificateMatchesPin(cert, pin);
        return client;
      },
    );
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

  /// `GET /cluster/resources?type=vm` — QEMU guests cluster-wide.
  ///
  /// Some API versions return only `type: qemu` rows; others return mixed guest
  /// kinds under `type=vm` — only map rows with `type: qemu`.
  Future<List<Vm>> fetchAllVms() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.clusterResources,
        queryParameters: const {'type': 'vm'},
      ),
    );
    final list = _dataAsList(response.data?['data']);
    final out = <Vm>[];
    for (final e in list) {
      final m = Map<String, dynamic>.from(e as Map);
      if (m['type'] == 'qemu') {
        out.add(Vm.fromClusterResourcesItem(m));
      }
    }
    return out;
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

  /// `GET /cluster/resources?type=lxc` — all LXCs cluster-wide (legacy filter).
  ///
  /// Newer gateways only allow `type` in `{ vm, storage, node, sdn }`. On HTTP 400
  /// from `type=lxc` (including when the error body parses to a null message),
  /// falls back to `type=vm` and keeps rows with `type: lxc`.
  Future<List<Container>> fetchAllContainers() async {
    try {
      final response = await _unwrap(
        _dio.get<Map<String, dynamic>>(
          ApiEndpoints.clusterResources,
          queryParameters: const {'type': 'lxc'},
        ),
      );
      return _containersFromClusterResourcesData(response.data?['data']);
    } on ServerException catch (e) {
      if (e.statusCode == 400) {
        return _fetchAllContainersViaVmGuestFilter();
      }
      rethrow;
    }
  }

  Future<List<Container>> _fetchAllContainersViaVmGuestFilter() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.clusterResources,
        queryParameters: const {'type': 'vm'},
      ),
    );
    final list = _dataAsList(response.data?['data']);
    final out = <Container>[];
    for (final e in list) {
      final m = Map<String, dynamic>.from(e as Map);
      if (m['type'] == 'lxc') {
        out.add(Container.fromClusterResourcesItem(m));
      }
    }
    return out;
  }

  List<Container> _containersFromClusterResourcesData(dynamic data) {
    final list = _dataAsList(data);
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Container.fromClusterResourcesItem(m);
    }).toList();
  }

  /// `GET /nodes/{node}/qemu/{vmid}/config` — QEMU VM configuration.
  Future<QemuVmConfig> fetchQemuVmConfig(String node, int vmid) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeQemuVmConfig(node, vmid)),
    );
    final raw = response.data?['data'];
    if (raw is! Map) {
      throw const ServerException(502, message: 'Invalid QEMU config response');
    }
    return QemuVmConfig.fromProxmoxConfigData(Map<String, dynamic>.from(raw));
  }

  /// `PUT /nodes/{node}/qemu/{vmid}/config` — partial update (form body).
  ///
  /// [deleteKeys] becomes query `delete` (comma-separated) per PVE API.
  Future<void> updateQemuVmConfig(
    String node,
    int vmid,
    Map<String, dynamic> body, {
    List<String>? deleteKeys,
  }) async {
    final query = <String, dynamic>{};
    if (deleteKeys != null && deleteKeys.isNotEmpty) {
      query['delete'] = deleteKeys.join(',');
    }
    await _unwrap(
      _dio.put<Map<String, dynamic>>(
        ApiEndpoints.nodeQemuVmConfig(node, vmid),
        queryParameters: query.isEmpty ? null : query,
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
    );
  }

  /// `GET /nodes/{node}/lxc/{vmid}/config` — LXC CT configuration ([vmid] is
  /// the CT id).
  Future<LxcContainerConfig> fetchLxcConfig(String node, int vmid) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeLxcCtConfig(node, vmid)),
    );
    final raw = response.data?['data'];
    if (raw is! Map) {
      throw const ServerException(502, message: 'Invalid LXC config response');
    }
    return LxcContainerConfig.fromProxmoxConfigData(
      Map<String, dynamic>.from(raw),
    );
  }

  /// `PUT /nodes/{node}/lxc/{vmid}/config` — partial update (form body).
  Future<void> updateLxcConfig(
    String node,
    int vmid,
    Map<String, dynamic> body, {
    List<String>? deleteKeys,
  }) async {
    final query = <String, dynamic>{};
    if (deleteKeys != null && deleteKeys.isNotEmpty) {
      query['delete'] = deleteKeys.join(',');
    }
    await _unwrap(
      _dio.put<Map<String, dynamic>>(
        ApiEndpoints.nodeLxcCtConfig(node, vmid),
        queryParameters: query.isEmpty ? null : query,
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
    );
  }

  /// `POST /nodes/{node}/qemu` — create QEMU VM (x-www-form-urlencoded body).
  ///
  /// **Minimal field set (PVE 8.x / 9.x)** used by the create-VM form and
  /// expected by the API for a simple guest: `vmid`, `name`, `memory`, `ostype`,
  /// `net0`, and a boot disk key (`scsi0` plus `scsihw=virtio-scsi-single`, or
  /// alternatively `virtio0` / `ide0` without `scsihw`). Additional keys may be
  /// required for specific storage types; the server returns standard API errors.
  ///
  /// Response: `data` is usually the task **UPID** string; if `data` is absent,
  /// the create is treated as complete without task polling.
  Future<GuestCreateResult> createQemuVm(
    String node,
    Map<String, dynamic> body,
  ) async {
    final vmid = proxmoxInt(body['vmid']);
    if (vmid == null) {
      throw ArgumentError.value(body['vmid'], 'vmid', 'vmid is required');
    }
    final response = await _unwrap(
      _dio.post<Map<String, dynamic>>(
        ApiEndpoints.nodeQemuCreate(node),
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
    );
    return _parseCreateGuestResponse(response.data, vmid);
  }

  /// `POST /nodes/{node}/lxc` — create LXC container (x-www-form-urlencoded).
  ///
  /// **Minimal field set (PVE 8.x / 9.x)** for a typical unprivileged CT:
  /// `vmid`, `hostname`, `password` (root), `ostype`, `rootfs`, `memory`, `net0`,
  /// and `unprivileged` (`0`/`1`). Privileged templates or SSH-key-only flows may
  /// need different keys; errors come from the API.
  Future<GuestCreateResult> createLxc(
    String node,
    Map<String, dynamic> body,
  ) async {
    final vmid = proxmoxInt(body['vmid']);
    if (vmid == null) {
      throw ArgumentError.value(body['vmid'], 'vmid', 'vmid is required');
    }
    final response = await _unwrap(
      _dio.post<Map<String, dynamic>>(
        ApiEndpoints.nodeLxcCreate(node),
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
    );
    return _parseCreateGuestResponse(response.data, vmid);
  }

  /// `GET /cluster/nextid` — next free VM/CT ID.
  Future<int> fetchClusterNextId() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.clusterNextId),
    );
    final data = response.data?['data'];
    final id = proxmoxInt(data);
    if (id == null) {
      throw const ServerException(502, message: 'Invalid nextid response');
    }
    return id;
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

  /// `POST /nodes/{node}/qemu/{vmid}/status/start` — returns task UPID.
  Future<String> startVm(String node, int vmid) =>
      _postPowerAction(ApiEndpoints.nodeQemuVmStatus(node, vmid, 'start'));

  /// `POST .../status/shutdown` — graceful shutdown; optional [forceStop] and
  /// [timeout] (seconds) as query params per PVE API.
  Future<String> shutdownVm(
    String node,
    int vmid, {
    bool? forceStop,
    int? timeout,
  }) => _postPowerAction(
    ApiEndpoints.nodeQemuVmStatus(node, vmid, 'shutdown'),
    queryParameters: _shutdownQuery(forceStop: forceStop, timeout: timeout),
  );

  /// `POST .../status/stop` — immediate power-off (force stop).
  Future<String> stopVm(String node, int vmid) =>
      _postPowerAction(ApiEndpoints.nodeQemuVmStatus(node, vmid, 'stop'));

  /// `POST .../status/reboot`.
  Future<String> rebootVm(String node, int vmid) =>
      _postPowerAction(ApiEndpoints.nodeQemuVmStatus(node, vmid, 'reboot'));

  /// `POST /nodes/{node}/lxc/{ctid}/status/start` — returns task UPID.
  Future<String> startLxc(String node, int ctid) =>
      _postPowerAction(ApiEndpoints.nodeLxcCtStatus(node, ctid, 'start'));

  /// `POST .../lxc/.../shutdown` — graceful; optional [forceStop] and
  /// [timeout] query params.
  Future<String> shutdownLxc(
    String node,
    int ctid, {
    bool? forceStop,
    int? timeout,
  }) => _postPowerAction(
    ApiEndpoints.nodeLxcCtStatus(node, ctid, 'shutdown'),
    queryParameters: _shutdownQuery(forceStop: forceStop, timeout: timeout),
  );

  /// `POST .../lxc/.../stop` — immediate stop.
  Future<String> stopLxc(String node, int ctid) =>
      _postPowerAction(ApiEndpoints.nodeLxcCtStatus(node, ctid, 'stop'));

  /// `POST .../lxc/.../reboot`.
  Future<String> rebootLxc(String node, int ctid) =>
      _postPowerAction(ApiEndpoints.nodeLxcCtStatus(node, ctid, 'reboot'));

  /// `GET /nodes/{node}/tasks` with pagination.
  ///
  /// Optional [typefilter] (e.g. `vzdump`) when supported by the PVE version.
  Future<List<Task>> fetchTasksForNode(
    String node, {
    int start = 0,
    int limit = 50,
    String? typefilter,
  }) async {
    final query = <String, dynamic>{'start': start, 'limit': limit};
    if (typefilter != null && typefilter.isNotEmpty) {
      query['typefilter'] = typefilter;
    }
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.nodeTasks(node),
        queryParameters: query,
      ),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((dynamic e) {
      final m = Map<String, dynamic>.from(e as Map);
      m.putIfAbsent('node', () => node);
      return Task.fromJson(m);
    }).toList();
  }

  /// `GET /nodes/{node}/tasks` filtered to vzdump-style tasks (uses
  /// `typefilter=vzdump` when available, plus a client-side type check).
  Future<List<Task>> fetchVzdumpTasksForNode(
    String node, {
    int start = 0,
    int limit = 50,
  }) async {
    final tasks = await fetchTasksForNode(
      node,
      start: start,
      limit: limit,
      typefilter: 'vzdump',
    );
    return tasks.where((t) {
      final ty = t.type.toLowerCase();
      return ty == 'vzdump' || ty.contains('vzdump');
    }).toList();
  }

  /// `GET /nodes/{node}/network` — interface list for bridge pickers.
  Future<List<NodeNetworkIface>> fetchNodeNetworkIfaces(String node) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeNetwork(node)),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((dynamic e) {
      final m = Map<String, dynamic>.from(e as Map);
      return NodeNetworkIface.fromJson(m);
    }).toList();
  }

  /// `GET /nodes/{node}/storage` — storage pools.
  Future<List<Storage>> fetchStorageForNode(String node) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeStorage(node)),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((dynamic e) {
      final m = Map<String, dynamic>.from(e as Map);
      return Storage.fromNodeStorageListRow(m, node: node);
    }).toList();
  }

  /// `GET /nodes/{node}/storage/{storage}/status` — usage and flags.
  Future<Storage> fetchStorageStatus(String node, String storage) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.nodeStorageStatus(node, storage),
      ),
    );
    final body = response.data;
    final raw = body?['data'];
    if (raw is! Map<String, dynamic>) {
      throw const ServerException(502, message: 'Invalid storage status');
    }
    final m = Map<String, dynamic>.from(raw);
    m['node'] = node;
    m.putIfAbsent('storage', () => storage);
    return Storage.fromJson(m);
  }

  /// `GET /nodes/{node}/storage/{storage}/content` — optional [contentKind]
  /// limits rows (e.g. `images`, `rootdir`, `backup`). [start]/[limit] map to
  /// PVE list pagination when set.
  Future<List<BackupContent>> fetchStorageContent(
    String node,
    String storage, {
    String? contentKind,
    int? start,
    int? limit,
  }) async {
    final query = <String, dynamic>{};
    if (contentKind != null && contentKind.isNotEmpty) {
      query['content'] = contentKind;
    }
    if (start != null) {
      query['start'] = start;
    }
    if (limit != null) {
      query['limit'] = limit;
    }
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.nodeStorageContent(node, storage),
        queryParameters: query.isEmpty ? null : query,
      ),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((dynamic e) {
      final m = Map<String, dynamic>.from(e as Map);
      return BackupContent.fromJson(m);
    }).toList();
  }

  /// `GET /cluster/backup` — backup job definitions.
  Future<List<BackupJob>> fetchClusterBackupJobs() async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.clusterBackup),
    );
    final list = _dataAsList(response.data?['data']);
    return list.map((dynamic e) {
      final m = Map<String, dynamic>.from(e as Map);
      return BackupJob.fromJson(m);
    }).toList();
  }

  /// `POST /nodes/{node}/vzdump` — manual backup; returns task UPID.
  ///
  /// [compress] is sent as PVE expects (`0` none, or `zstd` / `lzo` / `gzip`).
  Future<String> triggerVzdump(
    String node, {
    required int vmid,
    required String storage,
    required String mode,
    required String compress,
  }) async {
    final response = await _unwrap(
      _dio.post<Map<String, dynamic>>(
        ApiEndpoints.nodeVzdump(node),
        data: <String, dynamic>{
          'vmid': vmid,
          'storage': storage,
          'mode': mode,
          'compress': compress,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      ),
    );
    return _parsePowerActionUpid(response.data);
  }

  /// `GET /nodes/{node}/tasks/{upid}/status`.
  Future<TaskStatus> fetchTaskStatus(String node, String upid) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(ApiEndpoints.nodeTaskStatus(node, upid)),
    );
    return taskStatusFromApiData(response.data?['data']);
  }

  /// `GET /nodes/{node}/qemu/{vmid}/rrddata?timeframe=…`
  Future<List<ResourceDataPoint>> fetchQemuRrdData(
    String node,
    int vmid,
    ChartTimeframe timeframe,
  ) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.nodeQemuVmRrdData(node, vmid),
        queryParameters: <String, dynamic>{'timeframe': timeframe.apiValue},
      ),
    );
    return parseProxmoxRrdData(response.data?['data']);
  }

  /// `GET /nodes/{node}/lxc/{ctid}/rrddata?timeframe=…`
  Future<List<ResourceDataPoint>> fetchLxcRrdData(
    String node,
    int ctid,
    ChartTimeframe timeframe,
  ) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.nodeLxcCtRrdData(node, ctid),
        queryParameters: <String, dynamic>{'timeframe': timeframe.apiValue},
      ),
    );
    return parseProxmoxRrdData(response.data?['data']);
  }

  /// `GET /nodes/{node}/rrddata?timeframe=…`
  Future<List<ResourceDataPoint>> fetchNodeRrdData(
    String node,
    ChartTimeframe timeframe,
  ) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.nodeRrdData(node),
        queryParameters: <String, dynamic>{'timeframe': timeframe.apiValue},
      ),
    );
    return parseProxmoxRrdData(response.data?['data']);
  }

  /// `GET /nodes/{node}/tasks/{upid}/log` with pagination.
  Future<List<String>> fetchTaskLog(
    String node,
    String upid, {
    int start = 0,
    int limit = 500,
  }) async {
    final response = await _unwrap(
      _dio.get<Map<String, dynamic>>(
        ApiEndpoints.nodeTaskLog(node, upid),
        queryParameters: <String, dynamic>{'start': start, 'limit': limit},
      ),
    );
    return _taskLogLinesFromData(response.data?['data']);
  }

  static Map<String, dynamic>? _shutdownQuery({bool? forceStop, int? timeout}) {
    final q = <String, dynamic>{};
    if (forceStop != null) {
      q['forceStop'] = forceStop ? 1 : 0;
    }
    if (timeout != null) {
      q['timeout'] = timeout;
    }
    return q.isEmpty ? null : q;
  }

  Future<String> _postPowerAction(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _unwrap(
      _dio.post<Map<String, dynamic>>(path, queryParameters: queryParameters),
    );
    return _parsePowerActionUpid(response.data);
  }

  String _parsePowerActionUpid(Map<String, dynamic>? body) {
    if (body == null) {
      throw const ServerException(502, message: 'Empty power action response');
    }
    final data = body['data'];
    if (data is String && data.isNotEmpty) {
      return data;
    }
    throw const ServerException(
      502,
      message: 'Invalid power action response (expected UPID string in data)',
    );
  }

  GuestCreateResult _parseCreateGuestResponse(
    Map<String, dynamic>? body,
    int vmid,
  ) {
    if (body == null) {
      return GuestCreateResult(vmid: vmid);
    }
    final data = body['data'];
    if (data is String && data.isNotEmpty) {
      return GuestCreateResult(vmid: vmid, upid: data);
    }
    return GuestCreateResult(vmid: vmid);
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

/// Parses Proxmox `rrddata` response `data` field into [ResourceDataPoint]s.
///
/// **Object rows:** reads `time`, `cpu`, `mem`, `netin`, `netout`,
/// `diskread`, `diskwrite` (case-insensitive keys).
///
/// **Array rows (QEMU/LXC RRD order):** index `0` = Unix time (seconds);
/// `2` = `cpu`; `3` = `mem` (bytes); `5` = `netin`; `6` = `netout`;
/// `7` = `diskread`; `8` = `diskwrite`. Index `1` is `maxcpu` (ignored here).
///
/// Sparse trailing rows (time-only) are skipped when no metrics are present.
List<ResourceDataPoint> parseProxmoxRrdData(dynamic data) {
  if (data == null) {
    return const [];
  }
  if (data is! List<dynamic>) {
    throw const ServerException(
      502,
      message: 'Expected JSON array in rrddata data',
    );
  }
  final out = <ResourceDataPoint>[];
  for (final row in data) {
    final point = _resourceDataPointFromRrdRow(row);
    if (point != null) {
      out.add(point);
    }
  }
  return out;
}

ResourceDataPoint? _resourceDataPointFromRrdRow(dynamic row) {
  if (row is Map) {
    final m = Map<String, dynamic>.from(row);
    final ts = _rrdTimestamp(m['time'] ?? m['t']);
    if (ts == null) {
      return null;
    }
    final cpu = _rrdDouble(m, 'cpu');
    // Node rrddata uses 'memused' instead of 'mem' — accept both.
    final mem = _rrdDouble(m, 'mem') ?? _rrdDouble(m, 'memused');
    final netIn = _rrdDouble(m, 'netin');
    final netOut = _rrdDouble(m, 'netout');
    final diskRead = _rrdDouble(m, 'diskread');
    final diskWrite = _rrdDouble(m, 'diskwrite');
    final hasMetric =
        cpu != null ||
        mem != null ||
        netIn != null ||
        netOut != null ||
        diskRead != null ||
        diskWrite != null;
    if (!hasMetric) {
      return null;
    }
    return ResourceDataPoint(
      timestamp: ts,
      cpu: cpu,
      mem: mem,
      netIn: netIn,
      netOut: netOut,
      diskRead: diskRead,
      diskWrite: diskWrite,
    );
  }
  if (row is List<dynamic>) {
    if (row.isEmpty) {
      return null;
    }
    final ts = _rrdTimestamp(row[0]);
    if (ts == null) {
      return null;
    }
    double? cpu;
    double? mem;
    double? netIn;
    double? netOut;
    double? diskRead;
    double? diskWrite;
    if (row.length > 2) {
      cpu = proxmoxDouble(row[2]);
    }
    if (row.length > 3) {
      mem = proxmoxDouble(row[3]);
    }
    if (row.length > 5) {
      netIn = proxmoxDouble(row[5]);
    }
    if (row.length > 6) {
      netOut = proxmoxDouble(row[6]);
    }
    if (row.length > 7) {
      diskRead = proxmoxDouble(row[7]);
    }
    if (row.length > 8) {
      diskWrite = proxmoxDouble(row[8]);
    }
    final hasMetric =
        cpu != null ||
        mem != null ||
        netIn != null ||
        netOut != null ||
        diskRead != null ||
        diskWrite != null;
    if (!hasMetric) {
      return null;
    }
    return ResourceDataPoint(
      timestamp: ts,
      cpu: cpu,
      mem: mem,
      netIn: netIn,
      netOut: netOut,
      diskRead: diskRead,
      diskWrite: diskWrite,
    );
  }
  return null;
}

DateTime? _rrdTimestamp(dynamic value) {
  final secs = proxmoxInt(value) ?? proxmoxDouble(value)?.toInt();
  if (secs == null) {
    return null;
  }
  return DateTime.fromMillisecondsSinceEpoch(secs * 1000, isUtc: true);
}

double? _rrdDouble(Map<String, dynamic> map, String key) {
  for (final e in map.entries) {
    if (e.key.toLowerCase() == key) {
      return proxmoxDouble(e.value);
    }
  }
  return null;
}

/// PVE task log `data`: list of `{ "n": int, "t": "line" }` or plain strings.
List<String> _taskLogLinesFromData(dynamic data) {
  if (data == null) {
    throw const ServerException(502, message: 'Invalid task log response');
  }
  if (data is! List<dynamic>) {
    throw const ServerException(
      502,
      message: 'Expected JSON array in task log data',
    );
  }
  return data.map(_taskLogLineFromEntry).toList();
}

String _taskLogLineFromEntry(dynamic entry) {
  if (entry is String) {
    return entry;
  }
  if (entry is Map) {
    final t = entry['t'];
    if (t != null) {
      return t.toString();
    }
    final text = entry['text'];
    if (text != null) {
      return text.toString();
    }
  }
  return entry.toString();
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

  final swap = data['swap'];
  if (swap is Map) {
    out['swapused'] ??= proxmoxInt(swap['used']);
    out['swaptotal'] ??= proxmoxInt(swap['total']);
  }

  final loadavg = data['loadavg'];
  if (loadavg is List && loadavg.isNotEmpty) {
    out['loadavg1m'] = proxmoxDouble(loadavg.first);
  }

  final iw = proxmoxDouble(data['iowait']);
  if (iw != null) {
    out['iowait'] = iw;
  }

  return out;
}
