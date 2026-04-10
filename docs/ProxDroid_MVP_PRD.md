# ProxDroid – MVP / Product Requirements Document

**Version:** 0.1 | **Date:** April 2026 | **Status:** Draft

---

## 1. Project Overview

ProxDroid is a modern, open-source Android client for Proxmox Virtual Environment (PVE). The goal is to fill the existing gap of high-quality, modern PVE clients on Android. The available alternatives (official PVE app, ProxMate) are outdated, buggy, or functionally limited.

| | |
|---|---|
| **Project Name** | ProxDroid |
| **Platform** | Android (Flutter) |
| **License** | Open Source (MIT) |
| **Monetization** | Free, donation model (GitHub Sponsors, Ko-fi) |
| **Target Audience** | Homelab enthusiasts, hobbyist admins, IT professionals |
| **Repository** | [github.com/mdg-labs/proxdroid](https://github.com/mdg-labs/proxdroid) |

---

## 2. Problem Statement

Proxmox VE is a widely used virtualization platform, especially in the homelab space. The existing Android clients have significant shortcomings:

- **Official PVE App:** Outdated UI, known bugs, little active development
- **ProxMate:** Functionally limited, UI not up to modern standards
- No app offers a modern, intuitive user experience with charts and dark theme

---

## 3. Project Goals

### 3.1 Primary Goals (MVP)

- Full VM and container management (start, stop, force stop, reboot, status)
- Resource monitoring with real-time charts (CPU, RAM, network, disk I/O)
- Storage overview, backup list, and manual backup trigger
- Multi-server support from day one
- Modern dark-theme UI with charts and visualizations
- Reliable Proxmox REST API integration including self-signed certificate support
- Localization-ready UI: all user-visible strings externalized via Flutter ARB files and `gen_l10n`; English as the base locale; UI terminology aligned with Proxmox VE web UI (Node, Virtual Machine, Container, Storage, Task, Backup, etc.)

### 3.2 Secondary Goals (Post-MVP)

- Console access (noVNC for QEMU VMs / xterm.js for LXC containers via WebView)
- Push notifications for critical events
- Homescreen widget & quick actions
- Snapshot management
- Suspend / Resume for QEMU VMs

---

## 4. Technical Decisions

### 4.1 Tech Stack

| | |
|---|---|
| **Framework** | Flutter (Dart) |
| **Target Platform** | Android (API 26+, Android 8.0+) |
| **State Management** | Riverpod (finalized) |
| **Navigation** | go_router (finalized) |
| **HTTP Client** | Dio (with SSL override for self-signed certs) |
| **Data Models** | Freezed (immutable, code-generated) |
| **Charts** | fl_chart |
| **Local Storage** | hive_ce (non-sensitive data) + flutter_secure_storage (credentials) |
| **CI/CD** | GitHub Actions |
| **Distribution** | Google Play Store + F-Droid + GitHub Releases (APK) |
| **Localization** | flutter_localizations (SDK) + intl + ARB files + gen_l10n |

### 4.2 API Integration

- Proxmox REST API v2
- Authentication: **API Token** (preferred) + username/password (fallback)
- Self-signed SSL certificates must work – **mandatory requirement**
- Direct connection to PVE server, no proxy/backend
- HTTPS only

### 4.3 Multi-Server Support

Multi-server support is built into the architecture from day one. Users can add multiple PVE instances and switch between them – a clear differentiator from the competition.

---

## 5. Feature Overview

| Feature | Priority | Scope |
|---|---|---|
| Multi-server management | P0 | MVP |
| API token & password auth | P0 | MVP |
| Self-signed SSL support | P0 | MVP |
| Node overview | P0 | MVP |
| VM list & status display | P0 | MVP |
| Container (LXC) list & status | P0 | MVP |
| VM/container start / stop / reboot | P0 | MVP |
| VM/container force stop | P1 | MVP |
| CPU / RAM monitoring (charts) | P0 | MVP |
| Network I/O charts | P1 | MVP |
| Disk I/O charts | P1 | MVP |
| Storage overview | P1 | MVP |
| Backup list & status | P1 | MVP |
| Manual backup trigger | P1 | MVP |
| Task viewer (running & past tasks) | P1 | MVP |
| Dark theme | P0 | MVP |
| Light theme (optional, user-toggled) | P1 | MVP |
| Localization-ready (ARB + gen_l10n, English base) | P1 | MVP |
| Edit saved server | P1 | MVP |
| Console access (noVNC / xterm.js) | P2 | Post-MVP |
| Push notifications | P2 | Post-MVP |
| Homescreen widget & quick actions | P3 | Post-MVP |
| Snapshot management | P2 | Post-MVP |
| Suspend / Resume (QEMU) | P3 | Post-MVP |

---

## 6. Design & UX Principles

- Dark theme as default, light theme optional
- Modern, clean UI – Material 3
- Charts and visualizations instead of plain text tables
- Fast load times – optimistic UI updates for read-only state; **never** for destructive or power actions (start/stop/reboot must reflect actual server state after the task completes)
- Error messages clear and human-readable (no raw API error output)
- Simple onboarding – add a server in under 60 seconds
- Localization-ready by default: all user-visible strings defined in ARB files (`lib/l10n/app_en.arb`); no hard-coded copy in widgets; UI labels follow Proxmox VE terminology for consistency with the Proxmox web UI

---

## 7. Open Source & Monetization

### 7.1 Open Source

- Fully open-source on GitHub
- License: **MIT** – permissive, maximizes contribution friendliness
- Contributions via pull requests
- Issues & feature requests via GitHub Issues
- Semantic versioning (SemVer)

### 7.2 Monetization

No ads. Free. Exclusively voluntary donations:

- GitHub Sponsors
- Ko-fi / Buy Me a Coffee
- Donation button in the app's About screen

---

## 8. Target Audience

### 8.1 Primary: Homelab Enthusiasts
- Run Proxmox at home or in small offices
- Want to monitor and manage their server conveniently from their phone
- Tech-savvy, appreciate good UX and modern design

### 8.2 Secondary: IT Professionals & Admins
- Manage Proxmox in professional environments
- Need quick access on the go
- Higher requirements for stability and security

---

## 9. Risks & Assumptions

| Type | Description |
|---|---|
| Risk | Proxmox API changes in future PVE versions may require updates |
| Risk | Self-signed SSL handling can be complex on older Android versions |
| Risk | Flutter ecosystem may be limited for certain native Android features |
| Risk | Credentials (API tokens, passwords) must be stored securely on-device – plain hive_ce storage is not encrypted and is not sufficient for credentials; requires `flutter_secure_storage` (Android Keystore-backed) |
| Risk | Google Play Store requires a Privacy Policy URL for apps that handle credentials and network configuration |
| Assumption | Users have direct network access to the PVE server (LAN or VPN) |
| Assumption | Proxmox VE 7.x and 8.x are supported; PVE 6.x is explicitly out of scope |
| Assumption | Community interest is sufficient for active continued development |

---

## 10. Next Steps

- [x] Tech stack decided (Flutter, Riverpod, Freezed, go_router, hive_ce + flutter_secure_storage, Dio)
- [x] App architecture defined → see `ProxDroid_Architecture.md`
- [x] License finalized: MIT
- [ ] Create GitHub repository and set up initial Flutter project
- [ ] Add community files: `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, GitHub issue/PR templates
- [ ] Set up CI/CD with GitHub Actions (build + test)
- [ ] Create and host Privacy Policy page (GitHub Pages recommended; required for Play Store)
- [ ] Implement Proxmox API wrapper module (Phase 1)
- [ ] First test setup with a local Proxmox server

---

## 11. References & Links

### Proxmox VE

| Resource | Link |
|---|---|
| Proxmox VE API Documentation (Wiki) | [pve.proxmox.com/wiki/Proxmox_VE_API](https://pve.proxmox.com/wiki/Proxmox_VE_API) |
| Proxmox VE API Viewer (interactive) | [pve.proxmox.com/pve-docs/api-viewer/](https://pve.proxmox.com/pve-docs/api-viewer/) |
| Proxmox VE Administration Guide | [pve.proxmox.com/pve-docs/](https://pve.proxmox.com/pve-docs/) |

### Flutter & Dart

| Resource | Link |
|---|---|
| Flutter Documentation | [docs.flutter.dev](https://docs.flutter.dev) |
| pub.dev (Dart/Flutter Packages) | [pub.dev](https://pub.dev) |
| Flutter Material 3 Guide | [m3.material.io](https://m3.material.io) |

### Key Packages (pub.dev)

| Package | Purpose | Link |
|---|---|---|
| `dio` | HTTP client with SSL override | [pub.dev/packages/dio](https://pub.dev/packages/dio) |
| `flutter_riverpod` | State management | [pub.dev/packages/flutter_riverpod](https://pub.dev/packages/flutter_riverpod) |
| `riverpod_annotation` | Riverpod code-gen annotations | [pub.dev/packages/riverpod_annotation](https://pub.dev/packages/riverpod_annotation) |
| `go_router` | Navigation | [pub.dev/packages/go_router](https://pub.dev/packages/go_router) |
| `freezed_annotation` | Immutable data models | [pub.dev/packages/freezed_annotation](https://pub.dev/packages/freezed_annotation) |
| `fl_chart` | Charts & visualizations | [pub.dev/packages/fl_chart](https://pub.dev/packages/fl_chart) |
| `hive_ce` | Core Hive CE API – boxes, adapters, storage engine | [pub.dev/packages/hive_ce](https://pub.dev/packages/hive_ce) |
| `hive_ce_flutter` | Flutter integration for hive_ce (init, path provider) | [pub.dev/packages/hive_ce_flutter](https://pub.dev/packages/hive_ce_flutter) |
| `flutter_secure_storage` | Secure credential storage | [pub.dev/packages/flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) |
| `connectivity_plus` | Network availability detection | [pub.dev/packages/connectivity_plus](https://pub.dev/packages/connectivity_plus) |
| `package_info_plus` | App version info for Settings/About screen | [pub.dev/packages/package_info_plus](https://pub.dev/packages/package_info_plus) |
| `url_launcher` | Open donation and GitHub links from within the app | [pub.dev/packages/url_launcher](https://pub.dev/packages/url_launcher) |
| `intl` | Date/time formatting and generated app localizations (via `flutter_localizations` + ARB files + `gen_l10n`) | [pub.dev/packages/intl](https://pub.dev/packages/intl) |
| `flutter_localizations` | SDK package for Material and Cupertino localization delegates (included with Flutter SDK, not a pub.dev package) | [docs.flutter.dev/accessibility-and-localization/internationalization](https://docs.flutter.dev/accessibility-and-localization/internationalization) |

> **Development tooling:** Cursor IDE rules live under `.cursor/rules/` in the repository root and enforce project architecture, Riverpod patterns, Freezed usage, feature-first folder structure, go_router conventions, and naming conventions. These are set up in Phase 0 of the Roadmap.

### Tools & Infrastructure

| Resource | Link |
|---|---|
| GitHub Actions Documentation | [docs.github.com/actions](https://docs.github.com/en/actions) |
| Google Play – Publish an app | [developer.android.com/distribute](https://developer.android.com/distribute/google-play/start) |
| F-Droid – Inclusion How-To | [f-droid.org/docs/Inclusion_How-To](https://f-droid.org/docs/Inclusion_How-To/) |
| Riverpod Documentation | [riverpod.dev](https://riverpod.dev) |

### Project Documents

| Document | Description |
|---|---|
| `ProxDroid_MVP_PRD.md` | This document – vision, features, goals |
| `ProxDroid_Architecture.md` | Technical architecture, folder structure, milestones |
| `ProxDroid_Roadmap.md` | Detailed development roadmap with per-phase subtasks |

---

*ProxDroid MVP/PRD v0.1 – continuously updated*
