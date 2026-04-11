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
| HTTP Client | **Dio** | TLS pin for self-signed mode, interceptors |
| Data Models | **Freezed** | Immutable, auto-generates copyWith/toJson |
| Charts | **fl_chart** | Lightweight, highly customizable |
| Local Storage | **hive_ce** + **flutter_secure_storage** | hive_ce (community-maintained Hive fork) for non-sensitive data; flutter_secure_storage for credentials (Android Keystore) |
| Code Generation | **build_runner** + **riverpod_generator** | Required for Freezed + Riverpod Generator |
| CI/CD | **GitHub Actions** | Free for open source |
| Localization | **flutter_localizations** + **intl** + ARB files + gen_l10n | Official Flutter i18n approach; ARB files under `lib/l10n/`; `gen_l10n` generates type-safe `AppLocalizations` class |
| IDE / Rules | **Cursor** + `.cursor/rules/` | Rule files enforce Riverpod patterns, Freezed usage, feature-first layout, go_router conventions, naming, API client patterns, local CI parity after edits, and roadmap updates; see §3 “Cursor IDE Rules” table |

### Cursor IDE Rules (`.cursor/rules/`)

Cursor rule files live under `.cursor/rules/` at the repository root. Each rule file enforces a specific domain:

| Rule file | Enforces |
|---|---|
| `flutter-dart-style.mdc` | `dart format`; feature-first folder layout matching §4; file naming (`*_screen.dart`, `*_repository.dart`, `*_providers.dart`, `*_notifier.dart`) |
| `riverpod.mdc` | Code-gen (`@riverpod`); `ref.watch` (never `ref.read`) for `selectedServerProvider` in `apiClientProvider`; async notifier vs FutureProvider conventions; provider file placement under `features/*/providers/` |
| `freezed-json.mdc` | Freezed + json_serializable for API models; `part` file order; no mutable API models; sealed exception pattern from §10 |
| `go-router.mdc` | Route paths match §8 table; typed path params (`:node`, `:vmid`, `:ctid`, `:upid`, `:serverId`, `:storage`); redirect rules for null `selectedServerProvider` |
| `proxmox-api.mdc` | HTTPS-only validation; Dio v5 `IOHttpClientAdapter` only (no v4); auth header formats; `GET /cluster/resources` preference over per-node list calls |
| `hive-secure-storage.mdc` | Credentials only in `flutter_secure_storage`; metadata in hive_ce; no credentials on the `Server` Freezed model |
| `ui-patterns.mdc` | Optimistic UI only for non-destructive reads (see PRD §6); Material 3; shared widget locations (`shared/widgets/`) |
| `ci-local-verification.mdc` | After substantive edits, run the same steps as `.github/workflows/ci.yml` (`pub get`, format check, `build_runner`, `gen-l10n`, `analyze`, `test`) until all pass |
| `update-plan-files.mdc` | Keep `docs/ProxDroid_Roadmap.md` (and related plans) aligned with completed work |
| `orchestrator-only.mdc` | Optional workflow: delegation mode only — see rule preamble (default single-agent sessions use `ci-local-verification.mdc`) |

> These rules are created in **Phase 0** of the Roadmap (see `ProxDroid_Roadmap.md` §Phase 0.1).

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
│   │   └── server_storage.dart       # Server metadata (hive_ce) + credentials (flutter_secure_storage)
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
│   │   │   ├── dashboard_repository.dart
│   │   │   └── rrd_repository.dart   # Proxmox rrddata (VM/LXC/node charts)
│   │   ├── providers/
│   │   │   ├── dashboard_providers.dart
│   │   │   └── rrd_providers.dart      # Chart data + 60s polling
│   │   └── ui/
│   │       ├── dashboard_screen.dart
│   │       ├── node_detail_screen.dart   # cluster row + `/nodes/{node}/status` metrics, guest counts
│   │       └── widgets/              # node-level chart wrappers (node RRD)
│   │           ├── node_cpu_chart.dart
│   │           ├── node_memory_chart.dart
│   │           ├── node_network_chart.dart
│   │           └── node_disk_io_chart.dart
│   │
│   ├── vms/                          # VM management
│   │   ├── data/
│   │   │   └── vm_repository.dart
│   │   ├── providers/
│   │   │   ├── vm_providers.dart
│   │   │   └── vm_config_providers.dart
│   │   └── ui/
│   │       ├── vm_list_screen.dart
│   │       ├── vm_detail_screen.dart
│   │       ├── vm_edit_screen.dart
│   │       ├── vm_create_screen.dart
│   │       └── widgets/
│   │           ├── vm_status_badge.dart
│   │           ├── cpu_chart.dart
│   │           ├── memory_chart.dart
│   │           ├── network_chart.dart
│   │           └── disk_io_chart.dart
│   │
│   ├── containers/                   # LXC container management
│   │   ├── data/
│   │   │   └── container_repository.dart
│   │   ├── providers/
│   │   │   ├── container_providers.dart
│   │   │   └── container_config_providers.dart
│   │   └── ui/
│   │       ├── container_list_screen.dart
│   │       ├── container_detail_screen.dart
│   │       ├── container_edit_screen.dart
│   │       ├── container_create_screen.dart
│   │       └── widgets/              # chart wrappers (parallel to vms/widgets)
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
│   └── settings/                     # Settings (preferences, theme, about, donations)
│       ├── providers/
│       └── ui/
│           ├── settings_screen.dart
│           └── preferences_screen.dart
│
├── shared/
│   ├── widgets/
│   │   ├── resource_chart.dart       # Reusable chart widget
│   │   ├── status_badge.dart
│   │   ├── error_view.dart           # Error message + retry button
│   │   ├── loading_shimmer.dart
│   │   └── empty_state.dart          # Icon + message for empty lists
│   ├── constants/
│   │   └── api_endpoints.dart        # All API paths in one place
│   └── providers/
│       └── connectivity_provider.dart # Streams ConnectivityResult; drives offline banner
│
└── l10n/
    └── app_en.arb            # English ARB file — base locale; Proxmox-aligned UI label keys
```

> **`l10n.yaml`** lives at the **project root** (same level as `pubspec.yaml`) and configures `gen_l10n`:
> ```yaml
> arb-dir: lib/l10n
> template-arb-file: app_en.arb
> output-localization-file: app_localizations.dart
> ```
> Enable code generation: set `flutter: generate: true` in `pubspec.yaml`.

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

> **Post-MVP note:** `VmStatus` will be extended with a `suspended` state when the Suspend/Resume feature is implemented (see Roadmap Post-MVP). `ContainerStatus` will not change — LXC containers do not support suspend.

Core models: `Server`, `Node`, `Vm`, `Container`, `Task`, `BackupJob`, `BackupContent`, `Storage`, `ResourceDataPoint`

---

## 7. API Client & SSL Handling

The Proxmox API client is provided via Riverpod. For **self-signed** (or otherwise non–public-CA) servers, the user enables **Allow self-signed** and must store a **TLS pin** on the `Server` record: `pinnedTlsSha256` — lowercase hex, 64 characters, **SHA-256 of the leaf certificate DER**. The server editor can **fetch** this fingerprint over TLS (one-time trust-on-first-use style handshake) before saving.

When `allowSelfSigned` is true, `ProxmoxApiClient` uses `IOHttpClientAdapter` (Dio v5+) with `badCertificateCallback` that returns **only** if the presented certificate matches `pinnedTlsSha256` (`certificateMatchesPin` in `lib/core/network/tls_pinning.dart`). Unconditional `true` is never used — that would allow trivial MITM.

Default CA validation applies when `allowSelfSigned` is false (standard `IOHttpClientAdapter()`).

> **Operational note:** If the server renews its certificate to a new leaf, the stored pin no longer matches — the user must **re-fetch** the fingerprint in the server editor (same as after changing hostname/port).

> **Deprecated API:** Dio v4 used `DefaultHttpClientAdapter` with `onHttpClientCreate`. Dio v5 replaced this with `IOHttpClientAdapter` and `createHttpClient`. Do **not** use the v4 pattern.

> **HTTPS enforcement:** The app enforces HTTPS-only connections. At the "Add Server" form level, validate that the host input does not include an `http://` scheme and display a clear error if it does. Android API 28+ blocks cleartext HTTP at the OS level, producing cryptic errors — catching this early in the UI is far better UX. No `android:usesCleartextTraffic` override is needed or wanted.

> **Key API efficiency:** Use `GET /cluster/resources` to retrieve VMs and containers cluster-wide in one call (preferred over iterating per-node `qemu` / `lxc` lists). VMs use `?type=vm` and map rows with `type: qemu`. Containers normally use `?type=lxc`; some gateways only allow query `type` in `{ vm, storage, node, sdn }` — the client then retries with `?type=vm` and keeps rows where the resource `type` field is `lxc`.

**Auth flow:**
1. API Token → `Authorization: PVEAPIToken=USER@REALM!TOKENID=UUID` header — stateless, no expiry
2. Username/Password → POST `/access/ticket` → returns `ticket` (used as cookie `PVEAuthCookie`) + `CSRFPreventionToken` (sent as header on all mutating requests)
   - Ticket expires after **2 hours** (PVE default). The interceptor must detect a `401` response and automatically re-authenticate before retrying the original request.
   - Store ticket and CSRF token in memory only (never on disk) — re-authenticate on app restart.

---

## 8. Navigation (go_router)

```
/                                   → Redirect → /servers or /dashboard
/servers                            → Server list
/servers/add                        → Add server
/servers/edit/:serverId             → Edit server (name, host, port, credentials, SSL toggle)
/dashboard                          → Node overview (after server selection)
/dashboard/:node                    → Node detail + resource charts (host Disk I/O from rrddata may be absent on PVE 9+; see dashboard feature note above)
/vms                                → VM list (all nodes)
/vms/create                         → Create VM (optional `?node=` query for default node)
/vms/:node/:vmid                    → VM detail + charts
/vms/:node/:vmid/edit               → VM Tier-A config editor
/containers                         → Container list (all nodes)
/containers/create                  → Create LXC (optional `?node=` query)
/containers/:node/:ctid             → Container detail
/containers/:node/:ctid/edit       → LXC Tier-A config editor
/storage                            → Storage overview
/storage/:node/:storage             → Storage detail + content list
/backups                            → Backup list
/tasks                              → Task viewer
/tasks/:node/:upid                  → Task detail + log output
/settings                           → Settings
/settings/preferences               → Preferences (theme + default chart time range, etc.)
```

> **Shell AppBar leading:** On section roots (`/vms`, `/dashboard`, `/servers`, …) the app bar shows the drawer (hamburger). On nested routes (`/servers/add`, `/dashboard/:node`, `/vms/:node/:vmid`, …) it shows back. The implementation keys off `GoRouterState.uri.path` and `isShellDrawerRootPath` — not `GoRouter.canPop()`, which can stay true on section roots after redirects or pops and would incorrectly show only the back affordance.

> **Note:** All Proxmox API calls require both `node` and the resource ID. Routes include `:node` to keep all navigation self-contained without relying on provider state for the node lookup.

> **UPID encoding in routes:** Proxmox UPIDs contain colons and other characters that are not safe in raw URL path segments (example: `UPID:node:0000ABCD:00000001:5F3E45A2:qmstart:100:root@pam:`). When constructing the `/tasks/:node/:upid` route, **percent-encode** the UPID before pushing to go_router (e.g. `Uri.encodeComponent(upid)`), and decode it in the receiving screen (`Uri.decodeComponent(upidParam)`). Without encoding, the colons in the UPID will be misinterpreted as path separators and navigation will fail.

### UI shell and theme (Material 3)

- **`AppShell`** (`lib/app/app_shell.dart`): `Scaffold` with `NavigationBar` + `NavigationDrawer` (More opens drawer). Drawer includes a branding header (avatar, app title, localized subtitle), optional **active server** row (`selectedServerProvider`) that navigates to `/servers`, section labels (**Infrastructure** / **Operations** from ARB), then **seven** drawer destinations (Dashboard, VMs, Containers, Storage, Backups, Tasks, Settings — no duplicate **Servers** row; `/servers` is also linked from **Settings** above Troubleshooting). Offline banner uses light elevation and rounded bottom corners.
- **`ShellSectionBody`** (`lib/shared/widgets/shell_section_body.dart`): Reusable **AppBar + Expanded(body)** for shell routes; optional **FAB** via `Stack` (used on server list). Prefer this for new section screens; body padding stays inside scroll/sliver children where pull-to-refresh applies.
- **`AppTheme`** (`lib/app/theme/app_theme.dart`): Shared **card** shape (16px radius, elevation 0, `surfaceContainerHighest`), **filled inputs** with rounded borders, **list tile** shape/padding, **filled/text buttons**, **segmented** shape hint, **app bar** with `scrolledUnderElevation` on scroll.

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

### Selected server (source of truth for which server is active)

> **Implementation note — preserving user selection:** A simple `StateProvider` for `selectedServerProvider` would watch `serverListNotifierProvider`. In Riverpod, this means the provider **rebuilds** whenever the server list changes (add, remove, edit). On every rebuild, state resets to `servers.first`, discarding any explicit selection the user made. For MVP with a short server list this is acceptable, but the correct production pattern is: (1) persist the **selected server ID** (not the full object) in hive_ce; (2) implement `selectedServerProvider` as a `@riverpod class` `Notifier<Server?>` that loads the persisted ID on `build()`, falls back to `servers.first` if the persisted ID is not in the list, and persists the new ID when the user explicitly switches servers.

### Server-switching invalidation (how it works)

`apiClientProvider` watches `selectedServerProvider`. When the user switches servers, `selectedServerProvider` emits a new value, Riverpod rebuilds `apiClientProvider`, and because every API data provider `watch`es `apiClientProvider`, they are all invalidated and rebuilt in turn. This chain only works if `apiClientProvider` uses `ref.watch` — never `ref.read` — for `selectedServerProvider`.

```dart
@riverpod
ProxmoxApiClient apiClient(Ref ref) {
  final server = ref.watch(selectedServerProvider); // watch, not read
  return ProxmoxApiClient(server: server);
}
```

> **go_router `redirect` refresh:** go_router's `redirect` callback runs on navigation events but does **not** automatically re-execute when Riverpod state changes. To ensure `redirect` re-runs when `selectedServerProvider` changes (e.g. after the user adds the first server), wire go_router's **`refreshListenable`** parameter to a `ChangeNotifier` that notifies whenever `selectedServerProvider` emits. The recommended pattern is to expose the `GoRouter` instance as a Riverpod **`@riverpod` provider** that watches `selectedServerProvider`: when the provider rebuilds (server added/switched), the `GoRouter` instance is recreated with the updated redirect logic. Alternatively, use a `ChangeNotifier` subclass that calls `notifyListeners()` inside a `ref.listen` on `selectedServerProvider`, and pass it as `GoRouter(refreshListenable: ...)`. Without this wiring, the redirect fires correctly during navigation events but will not automatically re-route when the server state changes between navigations (e.g. first server saved with no pending navigation).

> **Null safety:** On first launch (no servers configured), `selectedServerProvider` holds `null`. `apiClientProvider` should guard against this — either by throwing a typed exception that the UI catches to redirect to `/servers`, or by making `apiClientProvider` return `null` and having all API providers short-circuit gracefully. The recommended approach is to redirect **API-requiring routes** (e.g. `/dashboard`, `/vms`, `/containers`, `/storage`, `/backups`, `/tasks`) to `/servers` via go_router's `redirect` callback when `selectedServerProvider` is null, so API providers never fire without a server. The routes `/servers`, `/servers/add`, `/servers/edit/:serverId`, and `/settings` must remain accessible with a null server — otherwise onboarding is impossible.

### Connectivity check

Use `connectivity_plus` to check network availability before initiating API calls and to surface a persistent "No network connection" banner when offline. Expose a `connectivityProvider` that streams `ConnectivityResult` from `Connectivity().onConnectivityChanged`. API repositories do not need to check connectivity themselves — the interceptor layer can reject calls early when offline is detected, surfacing a `NetworkException`.

### Concurrent refresh cycles

Two independent refresh cycles can be active simultaneously on the VM/container detail screen:

- **Task polling** (Phase 3): polls `taskStatusProvider` every 3 seconds while a task is running. Stops automatically once the task status is no longer `running`. Triggered only when an action (start/stop/reboot) is in progress.
- **Chart auto-refresh** (Phase 4): re-fetches rrddata every 60 seconds while the screen is visible. Always active on detail screens.

These two cycles are independent Riverpod providers and must not share timers or cancel each other. The 3-second task poller uses `ref.invalidate` or a `Timer`-based approach scoped to the notifier's lifecycle. The 60-second chart refresh uses `ref.keepAlive()` or an `AutoDisposeTimer` tied to the provider.

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
flutter:
  uses-material-design: true
  generate: true               # Required for gen_l10n to generate AppLocalizations from lib/l10n/app_en.arb

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
  flutter_secure_storage: ^9.x # Sensitive data (API tokens, passwords) – encrypted via Android Keystore; verify current major at implementation (was 9.x → 10.x transition exists)
  # Charts
  fl_chart: ^0.66.0            # Charts & visualizations — verify latest stable at implementation
  # Utilities
  connectivity_plus: ^6.x      # Network availability detection; drives offline banner + API call gating
  package_info_plus: ^8.x      # Show app version in Settings/About; verify current major at implementation
  url_launcher: ^6.x           # Open donation links, GitHub URL from the app
  intl: ^0.20.0                 # Date/time formatting AND generated app localizations (flutter_localizations + ARB + gen_l10n)
  # Localization
  flutter_localizations:       # SDK package — included with Flutter; not on pub.dev
    sdk: flutter

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
| **Phase 3** | VM/container start/stop/force stop/reboot, task viewer | First real management actions |
| **Phase 4** | Charts (CPU, RAM, network, disk I/O) | Monitoring complete |
| **Phase 5** | Storage, backup list & manual trigger | MVP feature-complete |
| **Phase 6** | Polish, error handling, UX details | MVP release-ready |
| **Post-MVP** | Console, push notifications, homescreen widget, snapshot management, suspend/resume | v2.0 |

---

*ProxDroid Architecture v0.1 – continuously updated*
