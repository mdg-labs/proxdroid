# ProxDroid – Architecture Document

**Version:** 0.1 | **Date:** April 2026 | **Status:** Draft

---

## 1. Overview

This document defines the technical architecture of ProxDroid. All decisions follow Flutter best practices (as of 2026) and are optimized for a solo project – minimal boilerplate, clear conventions, and designed to scale if contributors join later.

> For product requirements, feature scope and target audience → see `ProxDroid_MVP_PRD.md`
> For detailed per-phase development tasks → see `ProxDroid_Roadmap.md`

---

## 2. Architecture Principles

- **Feature-first** – code is organized by feature, not by technical layer
- **Unidirectional data flow** – UI reads state, state is never mutated directly from the UI
- **Immutable state** – state objects are never mutated, always recreated (via Freezed)
- **Repository pattern** – the UI never knows where data comes from (API, cache, local)
- **Separation of concerns** – API, business logic and UI are strictly separated

---

## 3. Tech Stack (Finalized)

| Decision | Choice | Rationale |
|---|---|---|
| Framework | Flutter (Dart) | Android-native UI, Material 3, performant |
| State Management | **Riverpod** | Modern, minimal boilerplate, ideal for solo dev |
| Navigation | **go_router** | Official Flutter standard, deep link support |
| HTTP Client | **Dio** | SSL override for self-signed certs, interceptors |
| Data Models | **Freezed** | Immutable, auto-generates copyWith/toJson |
| Charts | **fl_chart** | Lightweight, highly customizable |
| Local Storage | **hive_ce** + **flutter_secure_storage** | hive_ce (community-maintained Hive fork) for non-sensitive data; flutter_secure_storage for credentials (Android Keystore) |
| Code Generation | **build_runner** + **riverpod_generator** | Required for Freezed + Riverpod Generator |
| CI/CD | **GitHub Actions** | Free for open source |

---

## 4. Folder Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart                  # Root widget, ProviderScope
│   ├── router.dart               # go_router configuration
│   └── theme/
│       ├── app_theme.dart        # Dark + light theme
│       └── app_colors.dart       # Color constants
│
├── core/
│   ├── api/
│   │   ├── proxmox_api_client.dart   # Dio client, SSL override
│   │   ├── api_interceptors.dart     # Auth, error handling
│   │   └── api_exceptions.dart       # Typed exceptions
│   ├── models/                       # Shared data models (Freezed)
│   │   ├── server.dart
│   │   ├── node.dart
│   │   ├── vm.dart
│   │   ├── container.dart
│   │   ├── task.dart
│   │   ├── backup.dart               # BackupJob + BackupContent
│   │   ├── storage.dart
│   │   └── resource_data_point.dart  # Chart data (CPU, RAM, net, disk over time)
│   ├── storage/
│   │   └── server_storage.dart       # Server metadata (Hive) + credentials (flutter_secure_storage)
│   └── utils/
│       ├── formatters.dart           # Bytes, CPU%, uptime, etc.
│       └── extensions.dart
│
├── features/
│   ├── servers/                      # Multi-server management
│   │   ├── data/
│   │   │   └── server_repository.dart
│   │   ├── providers/
│   │   │   └── server_providers.dart
│   │   └── ui/
│   │       ├── server_list_screen.dart
│   │       ├── add_server_screen.dart
│   │       └── edit_server_screen.dart   # Reuses AddServerScreen form, pre-filled
│   │
│   ├── dashboard/                    # Node overview & summary
│   │   ├── data/
│   │   │   └── dashboard_repository.dart
│   │   ├── providers/
│   │   │   └── dashboard_providers.dart
│   │   └── ui/
│   │       └── dashboard_screen.dart
│   │
│   ├── vms/                          # VM management
│   │   ├── data/
│   │   │   └── vm_repository.dart
│   │   ├── providers/
│   │   │   └── vm_providers.dart
│   │   └── ui/
│   │       ├── vm_list_screen.dart
│   │       ├── vm_detail_screen.dart
│   │       └── widgets/
│   │           ├── vm_status_badge.dart
│   │           └── vm_resource_chart.dart
│   │
│   ├── containers/                   # LXC container management
│   │   ├── data/
│   │   ├── providers/
│   │   └── ui/
│   │
│   ├── storage/                      # Storage overview
│   │   ├── data/
│   │   ├── providers/
│   │   └── ui/
│   │
│   ├── backups/                      # Backup list & trigger
│   │   ├── data/
│   │   ├── providers/
│   │   └── ui/
│   │
│   ├── tasks/                        # Task viewer
│   │   ├── data/
│   │   ├── providers/
│   │   └── ui/
│   │
│   └── settings/                     # Settings (theme, about, donations)
│       ├── providers/
│       └── ui/
│           └── settings_screen.dart
│
└── shared/
    ├── widgets/
    │   ├── resource_chart.dart       # Reusable chart widget
    │   ├── status_badge.dart
    │   ├── error_view.dart           # Error message + retry button
    │   ├── loading_shimmer.dart
    │   └── empty_state.dart          # Icon + message for empty lists
    ├── constants/
    │   └── api_endpoints.dart        # All API paths in one place
    └── providers/
        └── connectivity_provider.dart # Streams ConnectivityResult; drives offline banner
```

---

## 5. Layer Architecture per Feature

Every feature follows the same 3-layer pattern:

```
UI (Screens & Widgets)
        ↓ reads/watches
Providers (Riverpod)
        ↓ calls
Repository (Data Layer)
        ↓ uses
API Client / Local Storage (hive_ce)
```

### Example: Starting a VM

```
vm_detail_screen.dart
  → ref.read(vmProvider.notifier).startVm(node, vmid)   // node required for all Proxmox API calls
      → VmNotifier calls vm_repository.startVm(node, vmid)
          → vmRepository calls proxmox_api_client.post('/nodes/$node/qemu/$vmid/status/start')
              → Response: task ID → forwarded to features/tasks/data/task_repository.dart
```

---

## 6. Data Models (Freezed)

All models are immutable and generated with Freezed. Example:

```dart
@freezed
class Vm with _$Vm {
  const factory Vm({
    required int vmid,        // Integer in the Proxmox API
    required String name,
    required VmStatus status,
    required String node,
    double? cpu,              // Matches Proxmox API field name
    int? maxMem,
    int? mem,
    int? maxDisk,
    int? disk,
    int? uptime,
  }) = _Vm;

  factory Vm.fromJson(Map<String, dynamic> json) => _$VmFromJson(json);
}

enum VmStatus { running, stopped, paused, unknown }

// LXC containers do not have a paused state — use a separate enum to avoid exposing an invalid state
enum ContainerStatus { running, stopped, unknown }
```

Core models: `Server`, `Node`, `Vm`, `Container`, `Task`, `BackupJob`, `BackupContent`, `Storage`, `ResourceDataPoint`

---

## 7. API Client & SSL Handling

The Proxmox API client is provided as a singleton via Riverpod. SSL override for self-signed certificates is a mandatory requirement and is handled via `IOHttpClientAdapter` (Dio v5+):

```dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart'; // required for IOHttpClientAdapter

final dio = Dio(BaseOptions(
  baseUrl: 'https://$host:$port/api2/json',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 30),
));

if (allowSelfSigned) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      // Accept self-signed certificates – user explicitly opts in per-server
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    },
  );
}
```

> **Security note:** `badCertificateCallback = true` disables certificate validation entirely. This is intentional for homelab use, where self-signed certs are the norm. Users who need stricter validation can leave `allowSelfSigned` off and rely on system CAs. A future enhancement could support certificate pinning (store the expected cert fingerprint per server).

> **Deprecated API:** Dio v4 used `DefaultHttpClientAdapter` with `onHttpClientCreate`. Dio v5 replaced this with `IOHttpClientAdapter` and `createHttpClient`. Do **not** use the v4 pattern.

> **HTTPS enforcement:** The app enforces HTTPS-only connections. At the "Add Server" form level, validate that the host input does not include an `http://` scheme and display a clear error if it does. Android API 28+ blocks cleartext HTTP at the OS level, producing cryptic errors — catching this early in the UI is far better UX. No `android:usesCleartextTraffic` override is needed or wanted.

> **Key API efficiency:** Use `GET /cluster/resources` (with optional `?type=vm` or `?type=lxc`) to retrieve all VMs and containers across all nodes in a single call. This is substantially more efficient than iterating `GET /nodes/{node}/qemu` and `GET /nodes/{node}/lxc` per node, and is the preferred approach for populating list screens and the dashboard summary.

**Auth flow:**
1. API Token → `Authorization: PVEAPIToken=USER@REALM!TOKENID=UUID` header
2. Username/Password → POST `/access/ticket` → cookie + CSRFPreventionToken

---

## 8. Navigation (go_router)

```
/                                   → Redirect → /servers or /dashboard
/servers                            → Server list
/servers/add                        → Add server
/servers/edit/:serverId             → Edit server (name, host, port, credentials, SSL toggle)
/dashboard                          → Node overview (after server selection)
/vms                                → VM list (all nodes)
/vms/:node/:vmid                    → VM detail + charts
/containers                         → Container list (all nodes)
/containers/:node/:ctid             → Container detail
/storage                            → Storage overview
/storage/:node/:storage             → Storage detail + content list
/backups                            → Backup list
/tasks                              → Task viewer
/tasks/:node/:upid                  → Task detail + log output
/settings                           → Settings
```

> **Note:** All Proxmox API calls require both `node` and the resource ID. Routes include `:node` to keep all navigation self-contained without relying on provider state for the node lookup.

---

## 9. State Management – Riverpod Patterns

### Server list (persistent, hive_ce)
```dart
// serverStorageProvider lives in core/storage/server_storage.dart
// and exposes ServerStorage as a Riverpod provider
@riverpod
ServerStorage serverStorage(Ref ref) => ServerStorage();

@riverpod
class ServerListNotifier extends _$ServerListNotifier {
  @override
  List<Server> build() => ref.watch(serverStorageProvider).getAll();

  void addServer(Server server) { ... }
  void removeServer(String id) { ... }
}
```

### API data (async, cluster-wide)
```dart
// Primary: use GET /cluster/resources for all-nodes VM list (one call, no N-node iteration)
@riverpod
Future<List<Vm>> allVms(Ref ref) async {
  final api = ref.watch(apiClientProvider); // watch invalidates when server switches
  return api.getAllVms(); // calls GET /cluster/resources?type=vm
}

// Secondary: per-node fetch used only when node context is known (e.g. node detail screens)
@riverpod
Future<List<Vm>> nodeVms(Ref ref, String node) async {
  final api = ref.watch(apiClientProvider);
  return api.getVms(node); // calls GET /nodes/{node}/qemu
}
```

### Server-switching invalidation (how it works)

`apiClientProvider` watches `selectedServerProvider`. When the user switches servers, `selectedServerProvider` emits a new value, Riverpod rebuilds `apiClientProvider`, and because every API data provider `watch`es `apiClientProvider`, they are all invalidated and rebuilt in turn. This chain only works if `apiClientProvider` uses `ref.watch` — never `ref.read` — for `selectedServerProvider`.

```dart
@riverpod
ProxmoxApiClient apiClient(Ref ref) {
  final server = ref.watch(selectedServerProvider); // watch, not read
  return ProxmoxApiClient(server: server);
}
```

> **Null safety:** On first launch (no servers configured), `selectedServerProvider` holds `null`. `apiClientProvider` should guard against this — either by throwing a typed exception that the UI catches to redirect to `/servers`, or by making `apiClientProvider` return `null` and having all API providers short-circuit gracefully. The recommended approach is to redirect to `/servers` via go_router's `redirect` callback when `selectedServerProvider` is null, so API providers never fire without a server.

### Connectivity check

Use `connectivity_plus` to check network availability before initiating API calls and to surface a persistent "No network connection" banner when offline. Expose a `connectivityProvider` that streams `ConnectivityResult` from `Connectivity().onConnectivityChanged`. API repositories do not need to check connectivity themselves — the interceptor layer can reject calls early when offline is detected, surfacing a `NetworkException`.

---

## 10. Error Handling

No raw API errors in the UI. All errors are converted into typed exceptions:

```dart
sealed class ProxmoxException implements Exception {
  const ProxmoxException();
}
class AuthException extends ProxmoxException { const AuthException(); }
class NetworkException extends ProxmoxException { const NetworkException(); }
class ApiTimeoutException extends ProxmoxException { const ApiTimeoutException(); } // named ApiTimeoutException to avoid conflict with dart:async TimeoutException
class ServerException extends ProxmoxException {
  final int statusCode;
  final String? message;
  const ServerException(this.statusCode, {this.message});
}
class PermissionException extends ProxmoxException { const PermissionException(); }
```

These are translated into human-readable messages in the UI. `ApiTimeoutException` covers both connection and receive timeouts from Dio. Note: the class is named `ApiTimeoutException` (not `TimeoutException`) to avoid shadowing `dart:async`'s `TimeoutException`. `ServerException` carries the HTTP status code so the UI can differentiate 4xx from 5xx errors.

---

## 11. pubspec.yaml – Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State management
  flutter_riverpod: ^3.x
  riverpod_annotation: ^3.x   # Must match flutter_riverpod major version
  # Navigation
  go_router: ^15.x
  # HTTP
  dio: ^5.x
  # Data models
  freezed_annotation: ^3.x
  json_annotation: ^4.x
  # Storage
  hive_ce: ^2.x                # Core Hive CE API – list as explicit direct dependency (do not rely on transitive)
  hive_ce_flutter: ^2.x        # Flutter integration for hive_ce (initialisation, path provider)
  flutter_secure_storage: ^9.x # Sensitive data (API tokens, passwords) – encrypted via Android Keystore
  # Charts
  fl_chart: ^0.x
  # Utilities
  connectivity_plus: ^6.x      # Network availability detection; drives offline banner + API call gating
  package_info_plus: ^8.x      # Show app version in Settings/About
  url_launcher: ^6.x           # Open donation links, GitHub URL from the app
  intl: ^0.x                   # Date/time formatting (task timestamps, backup dates) – not used for full i18n

dev_dependencies:
  build_runner: ^2.x
  riverpod_generator: ^3.x     # Must match flutter_riverpod major version
  freezed: ^3.x
  json_serializable: ^6.x

# Post-MVP (add when needed):
# webview_flutter: ^4.x       # Console access (noVNC / xterm.js)
```

> **Note on Hive:** The original `hive` / `hive_flutter` package has not received a major release since 2022 and is not actively maintained. Use **`hive_ce`** (Hive Community Edition) — `hive_ce` + `hive_ce_flutter` — which is a drop-in replacement with active maintenance, Dart 3 support, and null-safety fixes. Do not use the original `hive` packages. Isar is a more feature-rich alternative if complex querying becomes necessary, but is overkill for ProxDroid's simple key-value storage needs.

---

## 12. Development Milestones

| Phase | Content | Goal |
|---|---|---|
| **Phase 0** | Repo, Flutter project, CI/CD skeleton | Everything runs, empty app skeleton |
| **Phase 1** | API client, auth (token + password), SSL, add server | Can connect to a PVE instance |
| **Phase 2** | Node overview, VM/container list & status | Basic monitoring working |
| **Phase 3** | VM/container start/stop/reboot, task viewer | First real management actions |
| **Phase 4** | Charts (CPU, RAM, network, disk I/O) | Monitoring complete |
| **Phase 5** | Storage, backup list & manual trigger | MVP feature-complete |
| **Phase 6** | Polish, error handling, UX details | MVP release-ready |
| **Post-MVP** | Console, push notifications, homescreen widget, snapshot management, suspend/resume | v2.0 |

---

*ProxDroid Architecture v0.1 – continuously updated*
