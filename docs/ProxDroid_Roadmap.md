# ProxDroid – Development Roadmap

**Version:** 0.1 | **Date:** April 2026 | **Status:** Draft

> For architecture decisions and tech stack → see `ProxDroid_Architecture.md`
> For feature scope and product goals → see `ProxDroid_MVP_PRD.md`

---

## Overview

| Phase | Focus | Exit Criteria |
|---|---|---|
| **Phase 0** | Project setup & infrastructure | App builds, CI passes, empty shell runs on device |
| **Phase 1** | API foundation & server management | Can authenticate and connect to a live PVE instance |
| **Phase 2** | Node, VM & container overview | Can view all nodes, VMs and containers with live status |
| **Phase 3** | VM & container actions + task viewer | Can start, stop, reboot VMs/containers and track tasks |
| **Phase 4** | Resource monitoring charts | Full real-time charts for CPU, RAM, network, disk I/O |
| **Phase 5** | Storage & backup management | Can browse storage and trigger/view backups |
| **Phase 6** | Polish & release prep | App is stable, polished, and ready for Play Store |
| **Post-MVP** | Extended features | Console, push notifications, homescreen widget |

---

## Phase 0 – Project Setup & Infrastructure

**Goal:** A working Flutter project skeleton with CI/CD in place. No features yet, but everything compiles, tests run, and the app launches on a real device.

### 0.1 Repository
- [ ] Create GitHub repository (`proxdroid`)
- [ ] Add `README.md` with project description, status badge, setup instructions
- [ ] Add `LICENSE` file (GPL v3 or MIT – decide before this step)
- [ ] Add `.gitignore` for Flutter/Dart
- [ ] Set up branch protection on `main` (require PR + CI pass)

### 0.2 Flutter Project
- [ ] Initialize Flutter project (`flutter create proxdroid`)
- [ ] Remove default counter app boilerplate (`lib/main.dart` content, `test/widget_test.dart`)
- [ ] Set minimum SDK to Android API 26 in `android/app/build.gradle`
- [ ] Add all dependencies to `pubspec.yaml` (Riverpod, Dio, Freezed, go_router, Hive, fl_chart, flutter_secure_storage, connectivity_plus, package_info_plus, url_launcher, intl)
- [ ] Run `flutter pub get` and confirm no version conflicts
- [ ] Set up `build_runner` and confirm code generation works (`dart run build_runner build`)

### 0.3 Folder Structure
- [ ] Create full folder structure as defined in `ProxDroid_Architecture.md`
- [ ] Add placeholder `// TODO` files in each feature folder so the structure is visible in git
- [ ] Set up `app/theme/app_colors.dart` with initial dark theme color palette
- [ ] Set up `app/theme/app_theme.dart` with `ThemeData` for dark (default) and light

### 0.4 App Skeleton
- [ ] Set up `main.dart` with `ProviderScope` wrapping the app
- [ ] Set up `app/app.dart` as root `MaterialApp.router` with go_router
- [ ] Set up `app/router.dart` with placeholder routes for all screens
- [ ] Create empty placeholder screens for: servers, dashboard, VMs, containers, storage, backups, tasks, settings
- [ ] Confirm app launches and navigates between placeholder screens

### 0.5 CI/CD (GitHub Actions)
- [ ] Add workflow: `ci.yml` – runs on every push/PR to `main`
  - `flutter pub get`
  - `dart format --output=none --set-exit-if-changed .` (fail if code is not formatted)
  - `dart run build_runner build --delete-conflicting-outputs`
  - `flutter analyze`
  - `flutter test`
- [ ] Add workflow: `build.yml` – runs on tags (`v*`)
  - Build release APK (`flutter build apk --release`)
  - Upload APK as GitHub Release asset
- [ ] Confirm both workflows pass on a clean run

---

## Phase 1 – API Foundation & Server Management

**Goal:** The user can add a Proxmox server (by hostname/IP, port, API token or username/password), the app connects to it, authenticates successfully, and stores the configuration locally. Self-signed certificates must work.

### 1.1 Core Data Models
- [ ] Implement `Server` model (Freezed) – Hive-persisted fields only: id, name, host, port, authType, allowSelfSigned
  - **Note:** credentials (`apiToken`, `password`) are NOT fields on the `Server` model – they are stored separately in `flutter_secure_storage` keyed by server id, and loaded at runtime when building the `ProxmoxApiClient`
- [ ] Implement `Node` model (Freezed) – fields: name, status, cpu, maxCpu, mem, maxMem, uptime
- [ ] Add `ServerAuthType` enum: `apiToken`, `usernamePassword`
- [ ] Run `build_runner` and confirm generated files are correct

### 1.2 Local Storage
- [ ] Initialize Hive in `main.dart` for non-sensitive data (server names, hostnames, preferences)
- [ ] Register Hive adapters for `Server` model (excluding credentials)
- [ ] Initialize `flutter_secure_storage` for sensitive data (API tokens, passwords) – stored encrypted using Android Keystore
- [ ] Implement `ServerStorage` – methods: `getAll()`, `save()`, `delete()`, `get(id)`
  - Server metadata (name, host, port, authType) → Hive
  - Credentials (apiToken, password) → `flutter_secure_storage`, keyed by server id
- [ ] Write unit tests for `ServerStorage`

### 1.3 Proxmox API Client
- [ ] Implement `ProxmoxApiClient` with Dio
- [ ] Add `BaseOptions`: base URL (`https://$host:$port/api2/json`), timeouts (connect: 10s, receive: 30s)
- [ ] Implement SSL override using `IOHttpClientAdapter` + `createHttpClient` (Dio v5 API) for self-signed certs
  - **Do not use** `DefaultHttpClientAdapter` – that is the Dio v4 API and was removed in v5
- [ ] Implement `ApiInterceptor` for:
  - Attaching auth headers on every request (API token or ticket cookie)
  - Catching Dio errors and converting to typed `ProxmoxException` (`AuthException`, `NetworkException`, `TimeoutException`, `ServerException`, `PermissionException`)
- [ ] Implement API Token auth: attach `Authorization: PVEAPIToken=...` header
- [ ] Implement Username/Password auth: POST `/access/ticket` → store ticket + CSRFPreventionToken, refresh on expiry
- [ ] Expose `ProxmoxApiClient` as a Riverpod provider (scoped to selected server)
- [ ] Write unit tests for auth logic (mock Dio)

### 1.4 Server Repository & Providers
- [ ] Implement `ServerRepository` – wraps `ServerStorage`, exposes typed methods
- [ ] Implement `ServerListNotifier` (Riverpod) – manages list of servers, persists via Hive
- [ ] Implement `selectedServerProvider` – tracks which server is currently active
- [ ] Implement `apiClientProvider` – creates `ProxmoxApiClient` for the selected server

### 1.5 Add Server UI
- [ ] Build `ServerListScreen` – shows all saved servers, empty state with CTA
- [ ] Build `AddServerScreen` – form with fields: name, host, port (default 8006), auth type toggle, credentials, allow self-signed toggle
- [ ] Add connection test button – calls `GET /version` (returns PVE version info) and shows success/error feedback
- [ ] Add server to list on success, show typed error message on failure
- [ ] Add swipe-to-delete on server list items
- [ ] Wire up go_router: `/servers` → `ServerListScreen`, `/servers/add` → `AddServerScreen`
- [ ] Redirect to `/servers` on first launch (no servers saved), else to `/dashboard`

---

## Phase 2 – Node, VM & Container Overview

**Goal:** After connecting to a server, the user can see all nodes with their resource usage, and browse a full list of VMs and LXC containers with live status indicators.

### 2.1 API Methods
- [ ] Implement `GET /nodes` → list of nodes
- [ ] Implement `GET /nodes/{node}/status` → node resource details
- [ ] Implement `GET /nodes/{node}/qemu` → list of VMs
- [ ] Implement `GET /nodes/{node}/lxc` → list of containers
- [ ] Add all relevant API endpoint constants to `shared/constants/api_endpoints.dart` (including `GET /version` for connection test)

### 2.2 Data Models
- [ ] Extend `Node` model with all relevant fields from API response
- [ ] Implement `Vm` model (Freezed) – vmid (int), name, status (VmStatus), node, cpu, maxMem, mem, maxDisk, disk, uptime
- [ ] Implement `Container` model (Freezed) – same fields as `Vm` but status uses `ContainerStatus` (not `VmStatus`), add `ostype`
- [ ] Implement `VmStatus` enum: `running`, `stopped`, `paused`, `unknown`
- [ ] Implement `ContainerStatus` enum: `running`, `stopped`, `unknown` (LXC has no paused state)

### 2.3 Repositories & Providers
- [ ] Implement `NodeRepository` with `getNodes()` and `getNodeStatus(node)`
- [ ] Implement `VmRepository` with `getVms(node)`
- [ ] Implement `ContainerRepository` with `getContainers(node)`
- [ ] Implement async Riverpod providers for node list, VM list, container list
- [ ] Add pull-to-refresh support on all list providers

### 2.4 Dashboard Screen
- [ ] Build `DashboardScreen` – shows all nodes in cards
- [ ] Each node card: name, online/offline badge, CPU usage bar, RAM usage bar, uptime
- [ ] Show cluster-wide summary at top (total VMs, running VMs, total containers)
- [ ] Handle loading state (shimmer), error state (retry button), empty state

### 2.5 VM List & Detail
- [ ] Build `VmListScreen` – filterable list of all VMs across all nodes
- [ ] Each VM row: name, vmid, node name, status badge (color-coded), CPU%, RAM usage
- [ ] Build `VmDetailScreen` – full details: all resource fields, uptime, node
- [ ] Add status badge widget (`shared/widgets/status_badge.dart`) – green/red/yellow
- [ ] Wire up go_router: `/vms` → `VmListScreen`, `/vms/:vmid` → `VmDetailScreen`

### 2.6 Container List & Detail
- [ ] Build `ContainerListScreen` – same structure as VM list
- [ ] Build `ContainerDetailScreen` – same structure as VM detail
- [ ] Wire up go_router: `/containers`, `/containers/:ctid`

### 2.7 Shared Widgets
- [ ] Implement `LoadingShimmer` widget for list placeholders
- [ ] Implement `ErrorView` widget with message + retry button
- [ ] Implement `EmptyState` widget with icon + message

---

## Phase 3 – VM & Container Actions + Task Viewer

**Goal:** The user can perform power actions (start, stop, reboot) on VMs and containers, and view running and past tasks with their status and log output.

### 3.1 API Methods
- [ ] Implement `POST /nodes/{node}/qemu/{vmid}/status/start`
- [ ] Implement `POST /nodes/{node}/qemu/{vmid}/status/stop` (graceful, with optional `forceStop=1` body param)
- [ ] Implement `POST /nodes/{node}/qemu/{vmid}/status/reboot`
- [ ] Implement `POST /nodes/{node}/lxc/{ctid}/status/start`
- [ ] Implement `POST /nodes/{node}/lxc/{ctid}/status/stop` (graceful, with optional `forceStop=1` body param)
- [ ] Implement `POST /nodes/{node}/lxc/{ctid}/status/reboot`
- [ ] Implement `GET /nodes/{node}/tasks` → list of tasks
- [ ] Implement `GET /nodes/{node}/tasks/{upid}/status` → task status
- [ ] Implement `GET /nodes/{node}/tasks/{upid}/log` → task log output

### 3.2 Data Models
- [ ] Implement `Task` model (Freezed) – upid, node, type, status, startTime, endTime, user
- [ ] Implement `TaskStatus` enum: `running`, `ok`, `error`, `unknown`

### 3.3 Actions in VM/Container Detail
- [ ] Add action buttons to `VmDetailScreen`: Start, Stop, Force Stop, Reboot
  - **Stop** → `POST .../status/stop` (sends ACPI shutdown signal – graceful)
  - **Force Stop** → `POST .../status/stop` with `forceStop=1` body param (immediate kill)
- [ ] Show buttons only when action is valid (e.g. no Start when already running)
- [ ] Show confirmation dialog before Stop, Force Stop, and Reboot
  - Force Stop dialog must clearly warn that the action is immediate and may cause data loss
- [ ] On action: show loading indicator, call API, poll task status until complete
- [ ] On success: refresh VM status, show snackbar confirmation
- [ ] On error: show typed error message
- [ ] Mirror all of the above for `ContainerDetailScreen`

### 3.4 Task Repository & Providers
- [ ] Implement `TaskRepository` with `getTasks(node)`, `getTaskStatus(upid)`, `getTaskLog(upid)`
- [ ] Implement `taskListProvider` – lists all tasks across nodes, sorted by start time
- [ ] Implement `taskStatusProvider(upid)` – polls running tasks every 3 seconds

### 3.5 Task Viewer UI
- [ ] Build `TaskListScreen` – list of all tasks, newest first
- [ ] Each task row: type, VM/CT name, status badge, start time, duration
- [ ] Color-code status: running (blue), ok (green), error (red)
- [ ] Build `TaskDetailScreen` – full task log output in monospace font, auto-scroll to bottom
- [ ] Wire up go_router: `/tasks`, `/tasks/:upid`

---

## Phase 4 – Resource Monitoring Charts

**Goal:** VM and container detail screens show real-time and historical charts for CPU, RAM, network I/O and disk I/O using fl_chart.

### 4.1 API Methods
- [ ] Implement `GET /nodes/{node}/qemu/{vmid}/rrddata` – historical resource data (timeframe: hour/day/week)
- [ ] Implement `GET /nodes/{node}/lxc/{ctid}/rrddata` – same for containers
- [ ] Implement `GET /nodes/{node}/rrddata` – node-level resource data
- [ ] Support `timeframe` parameter: `hour`, `day`, `week`

### 4.2 Chart Data Models
- [ ] Implement `ResourceDataPoint` model in `core/models/resource_data_point.dart` (Freezed) – fields: timestamp, cpu, mem, netIn, netOut, diskRead, diskWrite
- [ ] Implement `ChartTimeframe` enum in same file: `hour`, `day`, `week`

### 4.3 Chart Widgets
- [ ] Implement reusable `ResourceLineChart` widget (`shared/widgets/resource_chart.dart`)
  - Accepts: list of `ResourceDataPoint`, metric type, color, timeframe
  - Shows: line chart with gradient fill, axis labels, tooltip on touch
- [ ] Implement `CpuChart` – CPU usage % over time
- [ ] Implement `MemoryChart` – RAM usage (used vs total) over time
- [ ] Implement `NetworkChart` – inbound + outbound traffic (two lines)
- [ ] Implement `DiskIoChart` – read + write (two lines)
- [ ] Add timeframe selector (1h / 1d / 1w) above each chart

### 4.4 Integration
- [ ] Add all four charts to `VmDetailScreen` below the status/info section
- [ ] Add all four charts to `ContainerDetailScreen`
- [ ] Add node-level CPU and RAM charts to `DashboardScreen` node cards (compact version)
- [ ] Implement auto-refresh: charts refresh every 30 seconds while screen is active

---

## Phase 5 – Storage & Backup Management

**Goal:** The user can browse all storage pools and their usage, view backup jobs and their history, and manually trigger a backup for a VM or container.

### 5.1 API Methods
- [ ] Implement `GET /nodes/{node}/storage` → list of storage pools
- [ ] Implement `GET /nodes/{node}/storage/{storage}/status` → storage details
- [ ] Implement `GET /nodes/{node}/storage/{storage}/content` → list of content/backups
- [ ] Implement `GET /cluster/backup` → list of backup jobs
- [ ] Implement `POST /nodes/{node}/vzdump` → trigger a backup
- [ ] Implement `GET /nodes/{node}/tasks` filtered by type `vzdump` for backup task tracking

### 5.2 Data Models
- [ ] Implement `BackupJob` model in `core/models/backup.dart` (Freezed) – id, vmid, node, storage, schedule, lastRun, nextRun
- [ ] Implement `BackupContent` model in `core/models/backup.dart` (Freezed) – volid, vmid, format, size, ctime
- [ ] Implement `Storage` model in `core/models/storage.dart` (Freezed) – id, node, type, content, total, used, available, active

### 5.3 Storage UI
- [ ] Build `StorageListScreen` – list of all storage pools across nodes
- [ ] Each storage card: name, type, usage bar (used/total), availability badge
- [ ] Build `StorageDetailScreen` – full details + list of content (backups, ISOs, etc.)
- [ ] Wire up go_router: `/storage`, `/storage/:id`

### 5.4 Backup UI
- [ ] Build `BackupListScreen` – list of backup content grouped by VM/CT
- [ ] Each backup row: VM name, date/time, size, format (vma, tar, etc.)
- [ ] Add manual backup trigger button (FAB or per-VM action)
- [ ] Build `TriggerBackupSheet` (bottom sheet) – select storage, compression, mode
- [ ] On trigger: call vzdump API, navigate to task viewer to track progress
- [ ] Wire up go_router: `/backups`

---

## Phase 6 – Polish & Release Prep

**Goal:** The app is stable, handles all error cases gracefully, feels polished, and is ready for a public release on the Play Store and GitHub.

### 6.1 Error Handling & Edge Cases
- [ ] Audit all screens for unhandled error states
- [ ] Ensure all `ProxmoxException` types have clear, user-friendly messages
- [ ] Handle network timeout gracefully (with retry option)
- [ ] Handle session expiry for username/password auth (auto re-authenticate)
- [ ] Handle empty states on all list screens

### 6.2 UX Polish
- [ ] Add smooth page transitions (go_router transitions)
- [ ] Add haptic feedback on action buttons (start/stop/reboot)
- [ ] Add pull-to-refresh on all data screens
- [ ] Ensure all loading states use shimmer (no blank screens)
- [ ] Review all typography, spacing, icon usage for consistency
- [ ] Test dark and light theme on multiple screen sizes

### 6.3 Settings Screen
- [ ] Build `SettingsScreen` with sections:
  - **Appearance:** theme toggle (dark/light/system)
  - **About:** app version, GitHub link, license info
  - **Support:** donation links (Ko-fi, GitHub Sponsors)
- [ ] Wire up theme toggle to persist preference in Hive

### 6.4 Testing
- [ ] Unit tests for all repositories (mock API client)
- [ ] Unit tests for all Riverpod providers
- [ ] Unit tests for all Freezed models (fromJson/toJson roundtrip)
- [ ] Widget tests for critical UI flows (add server, start VM)
- [ ] Integration tests using `integration_test` package for end-to-end flows (add server → dashboard → VM action)
- [ ] Manual end-to-end test on a real Proxmox instance (PVE 7.x and 8.x)

### 6.5 Play Store Release
- [ ] Create app icons (launcher icon, adaptive icon for Android)
- [ ] Create Play Store screenshots (at least 4, phone + tablet)
- [ ] Write Play Store listing: short description, full description, keywords
- [ ] Set up Google Play Console, create app entry
- [ ] Create and host a Privacy Policy (required by Play Store for apps handling credentials/network config)
- [ ] Complete the Play Store Data Safety form (declare what data is collected: credentials stored on-device only, no data sent to third parties)
- [ ] Sign release APK with upload keystore
  - Generate keystore file locally
  - Add `*.jks` and `*.keystore` to `.gitignore` – **never commit the keystore file**
  - Store keystore as base64-encoded GitHub Actions secret (`KEYSTORE_BASE64`)
  - Store keystore password, key alias and key password as separate GitHub Actions secrets
  - Decode and use in `build.yml` via `echo "$KEYSTORE_BASE64" | base64 --decode > upload.jks`
- [ ] Configure `build.yml` GitHub Action to build signed APK on tag push
- [ ] Submit to Play Store internal testing track first, then production

### 6.6 GitHub Release
- [ ] Tag `v1.0.0`
- [ ] Write release notes (changelog)
- [ ] Attach signed APK to GitHub Release
- [ ] Update `README.md` with download badges (Play Store + GitHub Releases)

---

## Post-MVP – Extended Features

These are tracked here for planning purposes but are not in scope for v1.0.

### Console Access
- [ ] Research noVNC WebSocket token flow via Proxmox API
- [ ] **QEMU VMs:** Implement `POST /nodes/{node}/qemu/{vmid}/vncproxy` to get VNC ticket → embed noVNC in a `WebView` using `webview_flutter`
- [ ] **LXC Containers:** Use `POST /nodes/{node}/lxc/{ctid}/termproxy` (terminal/shell access) → embed xterm.js in a `WebView` – containers do not have a graphical VNC console
- [ ] Handle authentication and session management for WebSocket connections in both cases

### Push Notifications
- [ ] Research Proxmox webhook/notification support (PVE 8.x)
- [ ] Design notification backend or polling approach
- [ ] Integrate Firebase Cloud Messaging (FCM) or local notifications

### Homescreen Widget
- [ ] Research Flutter homescreen widget options (`home_widget` package)
- [ ] Design widget: shows running VM count + server status at a glance
- [ ] Implement background refresh for widget data

---

*ProxDroid Roadmap v0.1 – continuously updated*
