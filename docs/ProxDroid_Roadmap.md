# ProxDroid – Development Roadmap

**Version:** 0.1 | **Date:** April 2026 | **Status:** Draft — Phase 6 polish complete; **GitHub Releases** via `build.yml` (beta pre-releases + stable draft APKs); Play Store & F-Droid **deferred**

> For architecture decisions and tech stack → see `ProxDroid_Architecture.md`
> For feature scope and product goals → see `ProxDroid_MVP_PRD.md`

---

## Overview

| Phase | Focus | Exit Criteria |
|---|---|---|
| **Phase 0** | Project setup & infrastructure | **Complete** — app ID `com.mdglabs.proxdroid`; CI + shell verified locally |
| **Phase 1** | API foundation & server management | **Complete** — server config, auth, Hive + secure storage, Dio client, go_router redirects, add/edit server UI |
| **Phase 2** | Node, VM & container overview | **Complete** — dashboard, VM/LXC lists + detail, shared status badge, l10n |
| **Phase 3** | VM & container actions + task viewer | **Complete** — power actions on detail screens + merged task list, detail log, encoded UPID routes |
| **Phase 4** | Resource monitoring charts | **Complete** — VM/LXC/node rrddata charts with timeframe selector and 60s refresh |
| **Phase 5** | Storage & backup management | **Complete** — browse storage usage/content, cluster backup jobs, aggregated backup files, manual vzdump + task navigation |
| **Phase 6** | Polish & release prep | **Complete** for polish + **GitHub Releases** (beta pre-release + stable draft APK via branch push); Play Store & F-Droid **deferred** |
| **Post-MVP** | Extended features | Console, push notifications, homescreen widget, snapshot management, suspend/resume |

---

## Phase 0 – Project Setup & Infrastructure

**Goal:** A working Flutter project skeleton with CI/CD in place. No features yet, but everything compiles, tests run, and the app launches on a real device.

**Verification:** Android, iOS, macOS, Linux, and Windows project metadata use the same application / bundle identifier **`com.mdglabs.proxdroid`** as documented under Phase 0.2 below (required before store submission).

### 0.1 Repository
- [x] Create GitHub repository (`proxdroid`) — [github.com/mdg-labs/proxdroid](https://github.com/mdg-labs/proxdroid)
- [x] Add `README.md` with project description, status badge, setup instructions, download links
- [x] Add `LICENSE` file — **MIT** (already decided, see `ProxDroid_MVP_PRD.md` §7.1)
- [x] Add `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com) format — maintain incrementally, do not write from scratch at release
- [x] Add `CONTRIBUTING.md` — how to set up the project locally, code style guide, PR process, commit message conventions
- [x] Add `CODE_OF_CONDUCT.md` — use the [Contributor Covenant](https://www.contributor-covenant.org) v2.1 template
- [x] Add GitHub issue templates in `.github/ISSUE_TEMPLATE/`: `bug_report.yml`, `feature_request.yml`
- [x] Add GitHub PR template: `.github/pull_request_template.md`
- [x] Add `.gitignore` for Flutter/Dart (include `*.jks`, `*.keystore`, `key.properties`)
- [ ] Set up branch protection on `main` (require PR + CI pass) — **planned for stable release** (not required to close Phase 0)
- [x] Create `.cursor/rules/` directory with rule files enforcing project architecture, Riverpod patterns, Freezed usage, feature-first folder structure, go_router conventions, Proxmox API patterns, and naming conventions (see `ProxDroid_Architecture.md` §3 Cursor IDE Rules for full list)

### 0.2 Flutter Project
- [x] Initialize Flutter project (`flutter create --org com.mdglabs proxdroid`)
  - This sets the Android application ID to `com.mdglabs.proxdroid` — decide and set this now; it cannot be changed after Play Store submission or F-Droid inclusion
- [x] Remove default counter app boilerplate (`lib/main.dart` content, `test/widget_test.dart`)
- [x] Set minimum SDK to Android API 26 in `android/app/build.gradle`
- [x] Add all dependencies to `pubspec.yaml` (Riverpod, Dio, Freezed, go_router, hive_ce + hive_ce_flutter, fl_chart, flutter_secure_storage, connectivity_plus, package_info_plus, url_launcher, intl, flutter_localizations); set `flutter: generate: true` in `pubspec.yaml`; add `l10n.yaml` at project root
- [x] Run `flutter pub get` and confirm no version conflicts
- [x] Set up `build_runner` and confirm code generation works (`dart run build_runner build`)

### 0.3 Folder Structure
- [x] Create full folder structure as defined in `ProxDroid_Architecture.md`
- [x] Add placeholder `// TODO` files in each feature folder so the structure is visible in git
- [x] Set up `app/theme/app_colors.dart` with initial dark theme color palette
- [x] Set up `app/theme/app_theme.dart` with `ThemeData` for dark (default) and light
- [x] Create `lib/l10n/` directory with initial `app_en.arb` file containing Proxmox-aligned UI string keys for entities (Node, VirtualMachine, Container, Storage, Task, Backup), actions (start, stop, forceStop, reboot), status values (running, stopped, paused, unknown, online, offline), resource metrics (cpu, memory, disk, network, uptime), and UI sections (dashboard, settings, about, servers)
- [x] Add `l10n.yaml` at project root (`arb-dir: lib/l10n`, `template-arb-file: app_en.arb`, `output-localization-file: app_localizations.dart`)
- [x] Run `flutter gen-l10n` and confirm `AppLocalizations` is generated without errors

### 0.4 App Skeleton
- [x] Set up `main.dart` with `ProviderScope` wrapping the app
- [x] Set up `app/app.dart` as root `MaterialApp.router` with go_router
  - Once `flutter gen-l10n` has run in Phase 0.3, add the generated import to `app.dart` (this repo: `import 'package:proxdroid/l10n/app_localizations.dart';` per `l10n.yaml`); then wire `localizationsDelegates: AppLocalizations.localizationsDelegates` and `supportedLocales: AppLocalizations.supportedLocales` into `MaterialApp.router`
- [x] Set up `app/router.dart` with placeholder routes for all screens
  - Note: the `/` root redirect behavior (→ `/servers` or `/dashboard` based on `selectedServerProvider`) is scaffolded as a placeholder here; the full redirect logic is wired in **Phase 1.4** once `selectedServerProvider` is implemented
- [x] Create empty placeholder screens for: servers, dashboard, VMs, containers, storage, backups, tasks, settings
- [x] Confirm app launches and navigates between placeholder screens

### 0.5 CI/CD (GitHub Actions)
- [x] Add workflow: `ci.yml` – runs on every push/PR to `main`
  - Pin Flutter version via `subosito/flutter-action` (e.g. `flutter-version: '3.x.x'` or `channel: stable`) — unpinned Flutter causes random CI breakage when Google releases a new version
  - `flutter pub get`
  - `dart format --output=none --set-exit-if-changed .` (fail if code is not formatted)
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter gen-l10n` (validates ARB / generated localizations)
  - `flutter analyze`
  - `flutter test`
- [x] Add workflow: `build.yml` – runs on every push to **`beta`** or **`main`** (gate skips unless version/tag rules say build); **`workflow_dispatch`** with branch choice for manual retries; creates `v<pubspec version>` if missing; publishes APK to GitHub Releases
  - **Beta branch:** version must contain `-beta` → **pre-release** + commit log since previous tag
  - **Main branch:** version must not contain `-beta` → **draft** release (`make_latest` applies when draft is published) + aggregated beta release notes (with `git log` fallback when a beta body is empty)
  - Pin same Flutter version as `ci.yml`
  - `flutter pub get`
  - `dart run build_runner build --delete-conflicting-outputs` (must run before build; generates Freezed/Riverpod code)
  - `flutter gen-l10n`
  - Build release APK (`flutter build apk --release --obfuscate --split-debug-info=build/app/debug-info`); upload `build/app/debug-info` as a workflow artifact for symbolication
  - Upload as GitHub Release asset named `proxdroid-<tag>.apk` (e.g. `proxdroid-v1.0.0-beta.12+1.apk`)
- [x] Confirm both workflows pass on a clean run (verified locally: `flutter pub get`, format check, `build_runner`, `gen-l10n`, `flutter analyze`, `flutter test` — all exit 0; first GitHub Actions run should still be watched by maintainers)

---

## Phase 1 – API Foundation & Server Management

**Goal:** The user can add a Proxmox server (by hostname/IP, port, API token or username/password), the app connects to it, authenticates successfully, and stores the configuration locally. Self-signed certificates must work.

### 1.1 Core Data Models
- [x] Implement `Server` model in `core/models/server.dart` (Freezed) – hive_ce-persisted fields only: id, name, host, port, authType, allowSelfSigned, pinnedTlsSha256 (TLS pin when self-signed is enabled)
  - **Note:** credentials (`apiToken`, `password`) are NOT fields on the `Server` model – they are stored separately in `flutter_secure_storage` keyed by server id, and loaded at runtime when building the `ProxmoxApiClient`
- [x] Implement `Node` model in `core/models/node.dart` (Freezed) – fields: name, status, cpu, maxCpu, mem, maxMem, uptime
- [x] Add `ServerAuthType` enum: `apiToken`, `usernamePassword`
- [x] Run `build_runner` and confirm generated files are correct

### 1.2 Local Storage
- [x] Confirm `hive_ce` and `hive_ce_flutter` are listed in `pubspec.yaml` (added in Phase 0.2 — **not** the unmaintained `hive`/`hive_flutter`; see Architecture §11); Phase 1 task is initialization and adapter registration, not adding the dependency
- [x] Initialize `hive_ce` in `main.dart` for non-sensitive data (server names, hostnames, preferences)
- [x] Register `TypeAdapter`s for the `Server` model with hive_ce (excluding credentials — credentials live in flutter_secure_storage only)
- [x] Initialize `flutter_secure_storage` for sensitive data (API tokens, passwords) – stored encrypted using Android Keystore
- [x] Implement `ServerStorage` – methods: `getAll()`, `save()`, `delete()`, `get(id)`
  - Server metadata (name, host, port, authType) → `hive_ce`
  - Credentials (apiToken, password) → `flutter_secure_storage`, keyed by server id
- [x] Write unit tests for `ServerStorage`

### 1.3 Proxmox API Client
- [x] Implement `ProxmoxApiClient` with Dio
- [x] Add `BaseOptions`: base URL (`https://$host:$port/api2/json`), timeouts (connect: 10s, send: 30s, receive: 30s)
- [x] Implement self-signed TLS using `IOHttpClientAdapter` + `createHttpClient` (Dio v5 API) with **certificate pin** (`pinnedTlsSha256`); never accept all certificates
  - **Do not use** `DefaultHttpClientAdapter` – that is the Dio v4 API and was removed in v5
- [x] Enforce HTTPS-only: validate in `AddServerScreen` / `ServerEditorPage` that the host does not contain `http://` or `https://` and surface a clear error if it does (Android API 28+ blocks cleartext HTTP at OS level with cryptic errors) — **Phase 1.5** (client already rejects `http://` in host when building the base URL)
- [x] Implement `ApiInterceptor` for:
  - Attaching auth headers on every request (API token or ticket cookie)
  - Catching Dio errors and converting to typed `ProxmoxException` (`AuthException`, `NetworkException`, `ApiTimeoutException`, `ServerException`, `PermissionException`) — note `ApiTimeoutException`, not `TimeoutException`, to avoid conflict with `dart:async`
  - *Implementation:* `ProxmoxAuthInterceptor` + `ProxmoxErrorInterceptor` in `lib/core/api/api_interceptors.dart`
- [x] Implement API Token auth: attach `Authorization: PVEAPIToken=...` header
- [x] Implement Username/Password auth: POST `/access/ticket` → store ticket + CSRFPreventionToken, refresh on expiry
- [x] Expose `ProxmoxApiClient` as a Riverpod provider (scoped to selected server) — **Phase 1.4** with `selectedServerProvider` / `apiClientProvider`
- [x] Write unit tests for auth logic (mock Dio)

> API path constants: `lib/shared/constants/api_endpoints.dart` (`version`, `accessTicket`). Phase 1.5 connection test: `ProxmoxApiClient.fetchVersion()`.

### 1.4 Server Repository & Providers
- [x] Implement `ServerRepository` – wraps `ServerStorage`, exposes typed methods
- [x] Implement `ServerListNotifier` (Riverpod) – manages list of servers, persists via hive_ce
- [x] Implement `selectedServerProvider` – tracks which server is currently active; returns `null` when no server is configured
- [x] Implement `apiClientProvider` – creates `ProxmoxApiClient` for the selected server; watches (not reads) `selectedServerProvider` so all API providers invalidate on server switch
- [x] Wire go_router `refreshListenable` so the `redirect` callback re-executes whenever `selectedServerProvider` changes (see Architecture §9 for pattern options); without this, adding the first server will not automatically re-route to `/dashboard`
- [x] For MVP: implement `selectedServerProvider` as a `StateProvider` defaulting to `servers.first`; add a comment noting that a full `Notifier`-based implementation with persisted selection ID is the recommended upgrade once multi-server switching is a priority
- [x] Implement go_router `redirect` callback: if `selectedServerProvider` is null, redirect **API-requiring routes** (e.g. `/dashboard`, `/vms`, `/containers`, `/storage`, `/backups`, `/tasks`) to `/servers`; the routes `/servers`, `/servers/add`, `/servers/edit/:serverId`, and `/settings` must remain accessible without a configured server (otherwise onboarding is impossible)

### 1.5 Add Server UI
- [x] Build `ServerListScreen` – shows all saved servers, empty state with CTA
- [x] Build `AddServerScreen` – form with fields: name, host, port (default 8006), auth type toggle, credentials, allow self-signed toggle
- [x] API token credentials: **Token ID** and **Secret** as separate fields in `ServerEditorPage` (plus “Paste full token”), composed to the stored `USER@REALM!TOKENID=SECRET` value for `PVEAPIToken`
- [x] In-app note: accounts with **TFA** should use **API token** sign-in (password path does not support second-factor completion)
- [x] Add connection test button – calls `GET /version` (returns PVE version info) and shows success/error feedback
- [x] Add server to list on success, show typed error message on failure
- [x] Add swipe-to-delete on server list items with undo snackbar (destructive action)
- [x] Add tap-to-edit on server list items → `EditServerScreen` (reuse `AddServerScreen` form, pre-filled)
- [x] Wire up go_router: `/servers` → `ServerListScreen`, `/servers/add` → `AddServerScreen`, `/servers/edit/:serverId` → `EditServerScreen`
- [x] Redirect to `/servers` on first launch (no servers saved), else to `/dashboard` (handled by go_router `redirect`)

---

## Phase 2 – Node, VM & Container Overview

**Goal:** After connecting to a server, the user can see all nodes with their resource usage, and browse a full list of VMs and LXC containers with live status indicators.

### 2.1 API Methods
- [x] Implement `GET /nodes` → list of nodes
- [x] Implement `GET /nodes/{node}/status` → node resource details
- [x] Implement `GET /cluster/resources` → all VMs, containers, and nodes in a single call (preferred for list screens and dashboard summary; avoids N per-node requests)
  - Supports `?type=vm`, `?type=lxc`, `?type=node` filters
  - Use this as the primary source for `VmListScreen`, `ContainerListScreen`, and the cluster summary in `DashboardScreen`
- [x] Implement `GET /nodes/{node}/qemu` → list of VMs for a single node (used when per-node context is needed)
- [x] Implement `GET /nodes/{node}/lxc` → list of containers for a single node
- [x] Add all relevant API endpoint constants to `shared/constants/api_endpoints.dart` (including `GET /version` for connection test and `GET /cluster/resources`)

### 2.2 Data Models
- [x] Extend `Node` model with all relevant fields from API response
- [x] Implement `Vm` model in `core/models/vm.dart` (Freezed) – vmid (int), name, status (VmStatus), node, cpu, maxMem, mem, maxDisk, disk, uptime
- [x] Implement `Container` model in `core/models/container.dart` (Freezed) – same fields as `Vm` but status uses `ContainerStatus` (not `VmStatus`), add `ostype`
- [x] Implement `VmStatus` enum: `running`, `stopped`, `paused`, `unknown`
- [x] Implement `ContainerStatus` enum: `running`, `stopped`, `unknown` (LXC has no paused state — do **not** reuse `VmStatus` for containers)

### 2.3 Repositories & Providers
- [x] Implement `NodeRepository` with `getNodes()` and `getNodeStatus(node)`
- [x] Implement `VmRepository` with:
  - `getAllVms()` – uses `GET /cluster/resources?type=vm` (primary; call this for list screens)
  - `getVms(node)` – uses `GET /nodes/{node}/qemu` (secondary; use only when per-node context is required)
- [x] Implement `ContainerRepository` with:
  - `getAllContainers()` – uses `GET /cluster/resources?type=lxc` when accepted; otherwise falls back to `?type=vm` and filters `lxc` rows (some API surfaces reject `type=lxc` in the query enum)
  - `getContainers(node)` – uses `GET /nodes/{node}/lxc` (secondary)
- [x] Implement async Riverpod providers: `allVmsProvider`, `allContainersProvider`, `nodeListProvider`
- [x] Add pull-to-refresh support on all list providers

### 2.4 Dashboard Screen
- [x] Build `DashboardScreen` – shows all nodes in cards
- [x] Each node card: name, online/offline badge, CPU usage bar, RAM usage bar, uptime
- [x] Show cluster-wide summary at top (total VMs, running VMs, total containers)
- [x] Handle loading state (shimmer), error state (retry button), empty state
- [x] Wire up go_router: `/dashboard` → `DashboardScreen`, `/dashboard/:node` → `NodeDetailScreen` (node name URL-encoded)
- [x] `NodeDetailScreen` — VM-style layout: hero, metric grid, CPU/memory/network/disk charts with timeframe selectors, backup sheet entry; tap-through from dashboard node cards (no host power actions)

### 2.5 VM List & Detail
- [x] Build `VmListScreen` – filterable list of all VMs across all nodes
  - Filter dimensions: search by name (text field), filter by status (all / running / stopped), filter by node
  - Default sort: running VMs first, then alphabetical by name
- [x] Each VM row: name, vmid, node name, status badge (color-coded), CPU%, RAM usage
- [x] Build `VmDetailScreen` – full details: all resource fields, uptime, node
- [x] Add status badge widget (`shared/widgets/status_badge.dart`) – green/red/yellow
- [x] Wire up go_router: `/vms` → `VmListScreen`, `/vms/:node/:vmid` → `VmDetailScreen`

### 2.6 Container List & Detail
- [x] Build `ContainerListScreen` – same structure and filter dimensions as VM list (search by name, filter by status, filter by node; default sort: running first)
- [x] Build `ContainerDetailScreen` – same structure as VM detail
- [x] Wire up go_router: `/containers`, `/containers/:node/:ctid`

### 2.7 Shared Widgets
- [x] Implement `LoadingShimmer` widget for list placeholders
- [x] Implement `ErrorView` widget with message + retry button
- [x] Implement `EmptyState` widget with icon + message
- [x] Proxmox guest tags: `tags` field on `Vm` / `Container`, `tag-colors` from `GET /version` via `proxmoxTagColorsProvider`, `ProxmoxTagBadge` / `ProxmoxTagRow` on VM+LXC list/detail, backup file groups + recent vzdump tasks, task list, manual backup guest picker

---

## Phase 3 – VM & Container Actions + Task Viewer

**Goal:** The user can perform power actions (start, stop, force stop, and reboot) on VMs and containers, and view running and past tasks with their status and log output.

### 3.1 API Methods
- [x] Implement `POST /nodes/{node}/qemu/{vmid}/status/start`
- [x] Implement `POST /nodes/{node}/qemu/{vmid}/status/shutdown` → graceful ACPI shutdown; optional `forceStop` param forces an immediate stop if the guest has not shut down within `timeout` seconds
- [x] Implement `POST /nodes/{node}/qemu/{vmid}/status/stop` → immediate power-off (Force Stop; no ACPI, equivalent to pulling the power cord)
- [x] Implement `POST /nodes/{node}/qemu/{vmid}/status/reboot`
- [x] Implement `POST /nodes/{node}/lxc/{ctid}/status/start`
- [x] Implement `POST /nodes/{node}/lxc/{ctid}/status/shutdown` → graceful shutdown signal; optional `forceStop` param forces stop after timeout
- [x] Implement `POST /nodes/{node}/lxc/{ctid}/status/stop` → immediate stop (Force Stop)
- [x] Implement `POST /nodes/{node}/lxc/{ctid}/status/reboot`
- [x] Implement `GET /nodes/{node}/tasks` → list of tasks (supports `start` and `limit` query params for pagination — implement pagination from the start)
- [x] Implement `GET /nodes/{node}/tasks/{upid}/status` → task status
- [x] Implement `GET /nodes/{node}/tasks/{upid}/log` → task log output (also supports `start` and `limit` for pagination)

### 3.2 Data Models
- [x] Implement `Task` model in `core/models/task.dart` (Freezed) – upid, node, type, status, startTime, endTime, user
- [x] Implement `TaskStatus` enum: `running`, `ok`, `error`, `unknown`

### 3.3 Actions in VM/Container Detail
- [x] Add action buttons to `VmDetailScreen`: Start, Stop, Force Stop, Reboot
  - **Stop** → `POST .../status/shutdown` (sends ACPI shutdown signal – graceful; the OS shuts down cleanly)
  - **Force Stop** → `POST .../status/stop` (immediate power-off, like pulling the power cord – no ACPI signal sent)
- [x] Show buttons only when action is valid (e.g. no Start when already running)
- [x] Show confirmation dialog before Stop, Force Stop, and Reboot
  - Force Stop dialog must clearly warn that the action is immediate and may cause data loss
- [x] On action: show loading indicator, call API, poll task status until complete
- [x] On success: refresh VM status, show snackbar confirmation
- [x] On error: show typed error message
- [x] Mirror all of the above for `ContainerDetailScreen`
  - Note: containers have no Pause state (`ContainerStatus` has no `paused`) — do not show a Pause button for LXC containers

### 3.4 Task Repository & Providers
- [x] Implement `TaskRepository` with:
  - `getTasks(node, {int start = 0, int limit = 50})` – paginated; use `GET /nodes/{node}/tasks` per-node (while Proxmox VE does expose `GET /cluster/tasks`, it returns only recent tasks with limited pagination — the per-node endpoint provides full task history with proper pagination and is the preferred approach for the task viewer)
  - `getTaskStatus(node, upid)` – node is required for the status endpoint
  - `getTaskLog(node, upid, {int start = 0, int limit = 500})` – paginated log lines
- [x] Implement `taskListProvider` – fetches tasks from all known nodes and merges, sorted by start time descending; uses `nodeListProvider` to enumerate nodes
- [x] Implement `taskStatusProvider(node, upid)` – polls running tasks every 3 seconds until status is no longer `running`

### 3.5 Task Viewer UI
- [x] Build `TaskListScreen` – list of all tasks, newest first
- [x] Sticky bottom status summary on the task list (counts per task status), above the shell bottom nav — icons, per-status counts, safe-area padding, de-emphasized zero counts
- [x] Task status parsing: `GET .../tasks/{upid}/status` uses `stopped` + `exitstatus` (non-OK → Failed); **list rows** from `GET /nodes/{node}/tasks` use the same `exitstatus` rules (non-OK → Failed) and `TASK ERROR` in `type`; terminal strings such as `failed` / `aborted` / `cancelled` map to Failed
- [x] Task list **guest filter** (AppBar): filter merged tasks by VM/CT ID from UPID; sticky status counts reflect the filtered subset; empty filtered state reuses list filtered-empty copy
- [x] Each task row: type, VMID (decoded from UPID), status badge, start time, duration
  - Note: `Task.upid` encodes the node, type, PID, and VMID — parse the UPID to extract VMID, then resolve VMID → name via the VM/container list; if the VM no longer exists, fall back to displaying the raw VMID
- [x] Color-code status: running (blue), ok (green), error (red)
- [x] Build `TaskDetailScreen` – full task log output in monospace font, auto-scroll to bottom
- [x] Wire up go_router: `/tasks`, `/tasks/:node/:upid` — **percent-encode** the UPID when pushing the route (`Uri.encodeComponent(upid)`) and decode it in the receiving screen (`Uri.decodeComponent(upidParam)`); see Architecture §8 for the reason (UPIDs contain colons that must not be treated as path separators)

---

## Phase 4 – Resource Monitoring Charts

**Goal:** VM and container detail screens show real-time and historical charts for CPU, RAM, network I/O and disk I/O using fl_chart.

### 4.1 API Methods
- [x] Implement `GET /nodes/{node}/qemu/{vmid}/rrddata` – historical resource data (timeframe: hour/day/week/month)
- [x] Implement `GET /nodes/{node}/lxc/{ctid}/rrddata` – same for containers
- [x] Implement `GET /nodes/{node}/rrddata` – node-level resource data
- [x] Node detail: `/nodes/{node}/status` for swap, load (1m), richer grid; guest VM/CT counts; Disk I/O chart explains empty series on Proxmox VE 9+ (host RRD no longer includes disk throughput)
- [x] Support `timeframe` parameter: `hour`, `day`, `week`, `month` — expose all four in the UI timeframe selector; `year` is **not** exposed in the MVP UI (API supports it but granularity is too low to be useful on a small screen) and is **not** included in the `ChartTimeframe` enum

### 4.2 Chart Data Models
- [x] Implement `ResourceDataPoint` model in `core/models/resource_data_point.dart` (Freezed) – fields: timestamp, cpu, mem, netIn, netOut, diskRead, diskWrite
- [x] Implement `ChartTimeframe` enum in same file: `hour`, `day`, `week`, `month` (year is intentionally excluded — see §4.1)

### 4.3 Chart Widgets
- [x] Implement reusable `ResourceLineChart` widget (`shared/widgets/resource_chart.dart`)
  - Accepts: list of `ResourceDataPoint`, metric type, color, timeframe
  - Shows: line chart with gradient fill, axis labels, tooltip on touch
- [x] Implement `CpuChart`, `MemoryChart`, `NetworkChart`, `DiskIoChart` as thin wrappers around `ResourceLineChart`
  - Place in `features/vms/ui/widgets/` (VM-specific) and reuse for containers via `features/containers/ui/widgets/`
  - The underlying `ResourceLineChart` widget lives in `shared/widgets/resource_chart.dart`
- [x] Add timeframe selector (1h / 1d / 1w / 1m) above each chart

### 4.4 Integration
- [x] Add all four charts to `VmDetailScreen` below the status/info section
- [x] Add all four charts to `ContainerDetailScreen`
- [x] ~~Add node-level CPU and RAM charts to `DashboardScreen` node cards (compact version)~~ **Stitch Phase D (2026-04):** removed from dashboard cards (density); cluster CPU/RAM uses aggregated node RRD; per-node charts remain on `NodeDetailScreen`.
- [x] Implement auto-refresh: charts refresh every 60 seconds while screen is active (rrddata resolution is 60s per point; refreshing faster yields no new data)

---

## Phase 5 – Storage & Backup Management

**Goal:** The user can browse all storage pools and their usage, view backup jobs and their history, and manually trigger a backup for a VM or container.

### 5.1 API Methods
- [x] Implement `GET /nodes/{node}/storage` → list of storage pools
- [x] Implement `GET /nodes/{node}/storage/{storage}/status` → storage details
- [x] Implement `GET /nodes/{node}/storage/{storage}/content` → list of content/backups
- [x] Implement `GET /cluster/backup` → list of backup jobs (cluster-scoped endpoint; backup jobs are not tied to a single node)
- [x] Implement `POST /nodes/{node}/vzdump` → trigger a backup
- [x] Implement `GET /nodes/{node}/tasks` filtered by type `vzdump` for backup task tracking

### 5.2 Data Models
- [x] Implement `BackupJob` model in `core/models/backup.dart` (Freezed) – id, vmids (list), storage, schedule, lastRun, nextRun (no `node` field — `GET /cluster/backup` is cluster-scoped and jobs apply cluster-wide); vmids is a list — one job can cover multiple VMs/containers, which matches the GET /cluster/backup API response where a single job entry lists all covered vmids
- [x] Implement `BackupContent` model in `core/models/backup.dart` (Freezed) – volid, vmid, format, size, ctime
- [x] Implement `Storage` model in `core/models/storage.dart` (Freezed) – id, node, type, content, total, used, available, active

### 5.3 Storage UI
- [x] Build `StorageListScreen` – list of all storage pools across nodes
- [x] Each storage card: name, type, usage bar (used/total), availability badge
- [x] Build `StorageDetailScreen` – full details + list of content (backups, ISOs, etc.)
- [x] Wire up go_router: `/storage`, `/storage/:node/:storage`

### 5.4 Backup UI
- [x] Build `BackupListScreen` – list of backup content grouped by VM/CT
- [x] Each backup row: VM name, date/time, size, format (vma, tar, etc.)
- [x] Add manual backup trigger button (FAB or per-VM action)
- [x] Build `TriggerBackupSheet` (bottom sheet) – select storage, compression (zstd / lzo / gzip / none), mode (snapshot / suspend / stop)
- [x] On trigger: call vzdump API, navigate to task viewer to track progress
- [x] Wire up go_router: `/backups`

---

## Phase 6 – Polish & Release Prep

**Goal:** The app is stable, handles all error cases gracefully, feels polished, and is distributable via **GitHub Releases** (beta pre-releases and stable drafts from `build.yml`; see README). Play Store and F-Droid remain **deferred** (§6.5).

### 6.1 Error Handling & Edge Cases
- [x] Audit all screens for unhandled error states
- [x] Ensure all `ProxmoxException` types have clear, user-friendly messages
- [x] Handle network timeout gracefully (with retry option)
- [x] Handle session expiry for username/password auth (auto re-authenticate) — wired in `ProxmoxAuthInterceptor` (Phase 1+); verified unchanged in Phase 6
- [x] Handle empty states on all list screens
- [x] Implement persistent offline banner: when `connectivityProvider` reports no network, show a non-dismissible top banner across all screens; auto-dismiss when connectivity is restored
- [x] Connection diagnostics: surface Proxmox/Dio `message` in snackbars; realm selector (`user@realm`) on server form; Settings toggle for verbose connection-test dialog; HTML/proxy detection in error mapping; docs for `/api2/json` behind reverse proxies
- [x] Security baseline: TLS leaf certificate pin for self-signed mode (`pinnedTlsSha256` + fetch in server editor), `FLAG_SECURE` on add/edit server screens, `android:allowBackup="false"`, R8 minify/shrink for release, CI `--obfuscate` + split debug info artifact, Gradle release requires `android/key.properties` (no debug-signed release APKs)

### 6.2 UX Polish
- [x] Add smooth page transitions (go_router transitions)
- [x] Add haptic feedback on action buttons (start/stop/reboot)
- [x] Add pull-to-refresh on all data screens
- [x] Ensure all loading states use shimmer (no blank screens)
- [x] **Material 3 theme tokens:** `AppTheme` card / input / list tile / button / app bar (`lib/app/theme/app_theme.dart`)
- [x] **Navigation drawer:** branding header, Infrastructure vs Operations section labels (ARB), active-server shortcut to `/servers`; no duplicate Servers row under Infrastructure (`lib/app/app_shell.dart`)
- [x] **`ShellSectionBody`:** shared AppBar + body (+ optional FAB); adopted on Settings, Servers, VMs, Containers, Dashboard (`lib/shared/widgets/shell_section_body.dart`)
- [x] **Dashboard & lists (Stitch Phase D, 2026-04):** three summary tiles + aggregated cluster CPU/RAM RRD card + grid of slim node cards (accent strip, gauges); VM/container rows as cards with chevron; themed progress bars. **Stitch Phase E (2026-04):** VM/LXC list tonal cards + badge status; detail AppBar = guest name, 2×2 RRD instrument tiles, timeframe pills above metrics; create section cards + gradient submit; edit grouped sections without divider chains. **Stitch Phase F (2026-04-13):** storage list hero + health tiles + optional per-node used bars (from existing pool rows); pool/detail cards match Obsidian strip + gauges. **Stitch Phase G (2026-04-13):** tasks filter on premium sheet chrome; task detail log well + dense AppBar; backups list/sheet tonal cards; server list accent + connected chip, editor theme inputs + TLS inset; settings/preferences tonal scaffold (`UI_Refactor_Stitch_Plan.md` §10 G). **Stitch Phase H (2026-04-13):** QA closure per `UI_Refactor_Stitch_Plan.md` §10 H — a11y (shell leading tooltips, search clear tooltips, connected-pill semantics), instrument grid semantics order + overflow-safe headlines, §8 grep snapshot in plan §12, CI green; Stitch `screen.png` pixel pass remains manual on device.
- [x] **EmptyState** tonal icon background; offline banner elevation + rounded bottom
- [ ] Review all typography, spacing, icon usage for consistency — **ongoing**
- [ ] Test dark and light theme on multiple screen sizes — **ongoing** (manual QA)

### 6.3 Settings Screen
- [x] Build `SettingsScreen` with sections:
  - **Servers:** row → `/servers` (add/edit/switch Proxmox server)
  - **Preferences:** row → `/settings/preferences` (`PreferencesScreen`: theme dark/light/system; default chart time range for VM/container/node detail charts; both persisted in Hive)
  - **About:** app version (`package_info_plus`), link to `github.com/mdg-labs/proxdroid`, MIT license summary dialog (Play Store / F-Droid links deferred — out of scope for this release; see §6.5–6.6)
  - **Support:** Ko-fi and GitHub Sponsors tiles (`url_launcher`)
- [x] Wire up theme preference to hive_ce (`settings` box, key `themeMode`; values `dark` / `light` / `system`)
- [x] Wire up default chart timeframe to hive_ce (`settings` box, key `defaultChartTimeframe`; values match Proxmox `timeframe` query: `hour` / `day` / `week` / `month`)
- [x] go_router: `/settings` → `SettingsScreen`; nested `/settings/preferences` → `PreferencesScreen`

### 6.4 Testing
- [x] Representative repository unit tests (Vm, Node, Task via fake HTTP adapter + `ProxmoxApiClient`; `AppSettingsRepository` via Hive) — expand to remaining repos over time
- [x] Representative Riverpod unit test (`AppThemeMode` with `ProviderContainer` overrides)
- [x] Representative Freezed JSON roundtrip tests (`Vm`, `Node`, `Task`)
- [x] Widget tests: Preferences appearance + language l10n + theme `SegmentedButton` smoke (same keys as `PreferencesScreen`); `ServerEditorPage` save validation (empty name)
- [x] `integration_test` scaffold with `testWidgets(..., tags: ['integration'])`; documented in `CONTRIBUTING.md` (`flutter test integration_test --tags integration`); default `flutter test` does not run `integration_test/`
- [ ] Unit / widget coverage for all repositories, providers, and critical flows (e.g. start VM) — ongoing
- [ ] Integration tests for end-to-end flows (add server → dashboard → VM action) against optional live PVE
- [ ] Manual end-to-end test on a real Proxmox instance (PVE 7.x and 8.x)
  - Live-PVE tests remain opt-in; use `@Tags(['integration'])` and the command in `CONTRIBUTING.md`

### 6.5 Play Store / F-Droid Release (**deferred**)

Not in scope for the current **GitHub-only prerelease** path; pick up when targeting store listing. Checklist below unchanged for future work.

- [x] Create app icons (launcher icon, adaptive icon for Android) — PNG sources in `assets/icon/`; `flutter_launcher_icons` generates Android mipmaps + adaptive layers and iOS `AppIcon.appiconset`
- [ ] Create Play Store screenshots (at least 4, phone + tablet)
- [ ] Write Play Store listing: short description, full description, keywords
- [ ] Set up Google Play Console, create app entry
- [ ] Create and host Privacy Policy (required by Play Store for apps handling credentials/network config)
  - Host on GitHub Pages (`https://mdg-labs.github.io/proxdroid/privacy`)
  - Content must declare: credentials stored on-device only, no telemetry, no data sent to third parties
- [ ] Submit to F-Droid:
  - Ensure build is reproducible (no proprietary SDKs, no Firebase, no Google Play Services)
  - Open an inclusion request (merge request) at [gitlab.com/fdroid/fdroiddata](https://gitlab.com/fdroid/fdroiddata) — F-Droid maintainers add metadata to their own repo; you do not add metadata to the app repo
  - F-Droid inclusion takes several weeks — submit as early as possible, ideally when the app is in beta
- [ ] Complete the Play Store Data Safety form (declare what data is collected: credentials stored on-device only, no data sent to third parties)
- [x] Sign release APK with upload keystore (GitHub Actions path — **done**)
  - Maintainer steps: **`docs/Android_release_signing.md`**
  - CI: secrets `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`; decode to `android/proxdroid-release.jks`; `printf` → `android/key.properties`; Gradle reads `android/key.properties` and signs `release` with that keystore (local builds without `key.properties` still use debug signing for convenience)
  - `*.jks`, `*.keystore`, `key.properties` remain gitignored; template: `android/key.properties.example`
- [ ] Configure `build.yml` GitHub Action to build **two artifacts** on tag push:
  - Signed AAB (`flutter build appbundle --release`) → for Play Store submission (Play Store requires AAB for new apps; APK is no longer accepted for new app submissions)
  - Signed APK (`flutter build apk --release`) → for GitHub Releases and F-Droid sideload
- [ ] Submit to Play Store internal testing track first, then production

### 6.6 GitHub Release (beta + stable draft — **done** for current scope)
- [x] **Triggers:** every push to **`beta`** or **`main`**, plus **workflow_dispatch** (choose `beta` or `main`) — `build.yml` reads `version:`, skips if `v<version>` already exists or branch/version rules fail, otherwise creates the tag, builds the **release-signed** APK (requires Actions secrets in `docs/Android_release_signing.md`; Play/AAB path still §6.5), and publishes **beta** as pre-release or **main** as draft (latest when the draft is published).
- [x] **Release notes:** beta = commits since previous tag; stable draft = aggregated bodies from beta pre-releases in range (fallback: `git log` per beta tag if body empty). Maintain `[Unreleased]` in `CHANGELOG.md` during development; edit the stable draft on GitHub before publishing if needed.
- [x] **README:** download section documents GitHub Releases, branch/version rules, and deferred Play/F-Droid; optional `build.yml` status badge
- [x] **Prod / stable releases:** `build.yml` handles stable **`main`** pushes (non-beta `pubspec` version) as **draft** releases; maintainer publishes the draft on GitHub when ready.
- [ ] **Store download badges** in README — deferred with §6.5

### 6.7 Localization & Terminology Review
- [x] Audit `lib/features` for hard-coded user-visible UI strings; moved formatted subtitles (settings version, server host:port) to `app_en.arb`
- [ ] Verify all ARB keys use Proxmox-aligned terminology (Node, Virtual Machine, Container, Storage, Task, Backup — consistent with Proxmox web UI labels) — ongoing review
- [x] Run `flutter gen-l10n` after ARB changes (CI includes this step)
- [x] Error surfacing: `proxmoxExceptionMessage` maps exceptions to l10n; avoid showing raw exception text in UI
- [ ] Review release-facing strings: Play Store listing, Privacy Policy URL — **deferred** with §6.5; in-app About / GitHub-facing copy aligned with ARB where applicable — **ongoing**

### 6.8 UI / visual refactor (**in progress — plan §11**)
- **Plan:** `ProxDroid_UI_Refactor_Plan.md` (same `docs/` directory as this roadmap) — hybrid ProxMate + Absorb design language; **design-only** (no Proxmox API or client contract changes).
- [x] **Phase 1 (plan §11.2):** theme tokens, `ColorScheme`, global Material themes (`app_colors.dart` / `app_theme.dart`)
- [x] **Phase 2 (plan §11.3):** shared layout primitives (`GroupedSection`, `SectionHeader`, `PremiumListRow`, `InsetGroupedList`, `IconBadgeAvatar`, premium modals, pill segmented control) and cross-cutting widget updates (shimmer, `ErrorView`, `EmptyState`, `StatusBadge`); chart timeframe selector on pill control
- [ ] Execute remaining UI refactor per `ProxDroid_UI_Refactor_Plan.md`

---

## Post-MVP – Extended Features

These are tracked here for planning purposes but are not in scope for v1.0.

### VM & LXC config editor (create + edit)

- **Plan:** [`VM_CT_Config_Editor_Plan.md`](VM_CT_Config_Editor_Plan.md) — Phases **0–9** with `[ ]`/`[x]` tasks and acceptance criteria (through **netN** + **delete=**, **QEMU disks** / **LXC rootfs & mpN**, risk confirm + stopped-guest locks); optional **10** (cloud-init & advanced). CI hygiene per plan §17.
- **Progress:** Phases **0–9** are implemented in app code and CI; Tier-1 manual rows in the plan may remain until cluster QA. Create/edit flows use **node-scoped pickers** (storage pools, volumes, bridges) and **fixed OS / SCSI / NIC lists**, with an **advanced raw string** path when values do not match the simplified parser.
- [ ] Implement per plan through **Phase 7** minimum; optional phases **8+** as scoped

### Console Access
- [ ] Research noVNC WebSocket token flow via Proxmox API
- [ ] **QEMU VMs:** Implement `POST /nodes/{node}/qemu/{vmid}/vncproxy` to get VNC ticket → embed noVNC in a `WebView` using `webview_flutter`
- [ ] **LXC Containers:** Use `POST /nodes/{node}/lxc/{ctid}/termproxy` (terminal/shell access) → embed xterm.js in a `WebView` – containers do not have a graphical VNC console
- [ ] Handle authentication and session management for WebSocket connections in both cases

### Push Notifications
- [ ] Research Proxmox notification support (PVE 8.1+ has a built-in notification system with webhook targets)
- [ ] Design notification approach — two options based on distribution target:
  - **F-Droid-compatible (recommended):** Use polling (background `WorkManager`-style task via `flutter_background_service`) + local notifications (`flutter_local_notifications`) — no proprietary SDK, works on all devices
  - **Play Store only:** Firebase Cloud Messaging (FCM) via `firebase_messaging` — **not compatible with F-Droid** due to Google Play Services dependency; using FCM would require maintaining two separate build flavors
- [ ] If supporting both F-Droid and Play Store: implement [UnifiedPush](https://unifiedpush.org) as a push delivery abstraction that supports both FCM (via a re-transmitter) and self-hosted push servers, keeping the app free of proprietary SDK requirements

### Homescreen Widget
- [ ] Research Flutter homescreen widget options (`home_widget` package)
- [ ] Design widget: shows running VM count + server status at a glance
- [ ] Implement background refresh for widget data

### Snapshot Management (P2)
- [ ] Implement `GET /nodes/{node}/qemu/{vmid}/snapshot` → list snapshots for a VM
- [ ] Implement `POST /nodes/{node}/qemu/{vmid}/snapshot` → create snapshot (name, description, optional RAM state)
- [ ] Implement `DELETE /nodes/{node}/qemu/{vmid}/snapshot/{snapname}` → delete snapshot
- [ ] Implement `POST /nodes/{node}/qemu/{vmid}/snapshot/{snapname}/rollback` → rollback to snapshot
- [ ] Add snapshot list to `VmDetailScreen` with create/delete/rollback actions
- [ ] Show confirmation dialog before rollback (destructive, irreversible action)
- [ ] Note: LXC containers also support snapshots via the same pattern under `/nodes/{node}/lxc/{ctid}/snapshot`

### Suspend / Resume for QEMU VMs (P3)
- [ ] Implement `POST /nodes/{node}/qemu/{vmid}/status/suspend` → suspend VM (saves state to disk)
- [ ] Implement `POST /nodes/{node}/qemu/{vmid}/status/resume` → resume VM from suspended state
- [ ] Add Suspend/Resume buttons to `VmDetailScreen` (only show when VM is running / suspended respectively)
- [ ] Extend `VmStatus` enum with `suspended` state
- [ ] Note: Suspend/Resume is QEMU-only — LXC containers do not support this

---

*ProxDroid Roadmap v0.1 – continuously updated*
