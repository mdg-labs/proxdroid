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
| Framework | Flutter (Dart) | Cross-platform, modern UI, iOS-ready |
| State Management | **Riverpod** | Modern, minimal boilerplate, ideal for solo dev |
| Navigation | **go_router** | Official Flutter standard, deep link support |
| HTTP Client | **Dio** | SSL override for self-signed certs, interceptors |
| Data Models | **Freezed** | Immutable, auto-generates copyWith/toJson |
| Charts | **fl_chart** | Lightweight, highly customizable |
| Local Storage | **Hive** + **flutter_secure_storage** | Hive for non-sensitive data; flutter_secure_storage for credentials (Android Keystore) |
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
│   │       └── add_server_screen.dart
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
    │   ├── error_view.dart
    │   └── loading_shimmer.dart
    └── constants/
        └── api_endpoints.dart        # All API paths in one place
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
API Client / Hive Storage
```

### Example: Starting a VM

```
vm_detail_screen.dart
  → ref.read(vmProvider.notifier).startVm(vmid)
      → VmNotifier calls vm_repository.startVm(vmid)
          → vmRepository calls proxmox_api_client.post('/nodes/{node}/qemu/{vmid}/status/start')
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

**Auth flow:**
1. API Token → `Authorization: PVEAPIToken=USER@REALM!TOKENID=UUID` header
2. Username/Password → POST `/access/ticket` → cookie + CSRFPreventionToken

---

## 8. Navigation (go_router)

```
/                                   → Redirect → /servers or /dashboard
/servers                            → Server list
/servers/add                        → Add server
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

### Server list (persistent, Hive)
```dart
@riverpod
class ServerListNotifier extends _$ServerListNotifier {
  @override
  List<Server> build() => ref.watch(serverStorageProvider).getAll();

  void addServer(Server server) { ... }
  void removeServer(String id) { ... }
}
```

### API data (async, auto-refresh)
```dart
@riverpod
Future<List<Vm>> vmList(Ref ref, String node) async {
  // apiClientProvider is scoped to the currently selectedServerProvider
  // – switching servers invalidates all API providers automatically
  final api = ref.watch(apiClientProvider);
  return api.getVms(node);
}
```

---

## 10. Error Handling

No raw API errors in the UI. All errors are converted into typed exceptions:

```dart
sealed class ProxmoxException implements Exception {
  const ProxmoxException();
}
class AuthException extends ProxmoxException { const AuthException(); }
class NetworkException extends ProxmoxException { const NetworkException(); }
class TimeoutException extends ProxmoxException { const TimeoutException(); }
class ServerException extends ProxmoxException {
  final int statusCode;
  final String? message;
  const ServerException(this.statusCode, {this.message});
}
class PermissionException extends ProxmoxException { const PermissionException(); }
```

These are translated into human-readable messages in the UI. `TimeoutException` covers both connection and receive timeouts from Dio. `ServerException` carries the HTTP status code so the UI can differentiate 4xx from 5xx errors.

---

## 11. pubspec.yaml – Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # State management
  flutter_riverpod: ^3.x
  riverpod_annotation: ^4.x
  # Navigation
  go_router: ^15.x
  # HTTP
  dio: ^5.x
  # Data models
  freezed_annotation: ^3.x
  json_annotation: ^4.x
  # Storage
  hive_flutter: ^1.x           # Non-sensitive data (server names, preferences)
  flutter_secure_storage: ^9.x # Sensitive data (API tokens, passwords) – encrypted
  # Charts
  fl_chart: ^0.x
  # Utilities
  connectivity_plus: ^6.x      # Detect network availability before API calls
  package_info_plus: ^8.x      # Show app version in Settings/About
  url_launcher: ^6.x           # Open donation links, GitHub URL from the app
  intl: ^0.x                   # Date/time formatting (task timestamps, backup dates)

dev_dependencies:
  build_runner: ^2.x
  riverpod_generator: ^4.x
  freezed: ^3.x
  json_serializable: ^6.x

# Post-MVP (add when needed):
# webview_flutter: ^4.x       # Console access (noVNC / xterm.js)
```

> **Note on Hive:** The original `hive` / `hive_flutter` package has not had a major release since 2022. The community-maintained fork **`hive_ce`** (Hive Community Edition) is a drop-in replacement with active maintenance and Dart 3 / null-safety fixes. Consider using `hive_ce` + `hive_ce_flutter` instead. Alternatively, **Isar** is a more modern embedded database for Flutter if a richer query model is needed.

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
| **Post-MVP** | iOS, console, push notifications, widget | v2.0 |

---

*ProxDroid Architecture v0.1 – continuously updated*
