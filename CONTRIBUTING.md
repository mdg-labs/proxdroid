# Contributing to ProxDroid

Thank you for your interest in contributing to ProxDroid! This document covers everything you need to get started.

---

## Prerequisites

- **Flutter SDK** >= 3.x (stable channel) — [installation guide](https://docs.flutter.dev/get-started/install)
- **Android SDK** (API 26+)
- **Dart** (included with Flutter)

---

## Local Setup

```bash
git clone https://github.com/mdg-labs/proxdroid.git
cd proxdroid
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

After pulling changes that affect generated files (Freezed models, Riverpod providers), re-run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Code Style

- Run `dart format .` before committing. CI will reject unformatted code.
- Follow the **feature-first folder structure** defined in `docs/ProxDroid_Architecture.md §4`:
  - Feature code lives under `lib/features/<feature>/` with `data/`, `providers/`, and `ui/` sub-folders.
  - Shared widgets go in `lib/shared/widgets/`.
  - Shared constants go in `lib/shared/constants/`.
- **File naming conventions:**
  - Screens: `*_screen.dart`
  - Repositories: `*_repository.dart`
  - Provider files: `*_providers.dart`
  - Notifiers: `*_notifier.dart`
- Never put UI code in data/repository files or data/API code in UI files.

---

## PR Process

1. Fork the repository.
2. Create a feature branch from `main`: `git checkout -b feat/my-feature`
3. Make your changes following the code style guidelines above.
4. Open a pull request targeting `main`.
5. CI must pass before a PR can be merged (format check, analyze, tests).
6. Keep PRs scoped to one concern — split unrelated changes into separate PRs.

---

## Commit Message Conventions

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>: <short description>
```

Allowed types:

| Type | When to use |
|---|---|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation changes only |
| `chore` | Maintenance, dependency updates, tooling |
| `refactor` | Code restructuring without behavior change |
| `test` | Adding or updating tests |

Examples:

```
feat: add VM start/stop actions to detail screen
fix: handle null server in apiClientProvider on first launch
docs: update CONTRIBUTING with integration test instructions
chore: bump flutter_riverpod to 3.1.0
```

---

## Integration tests / live PVE

End-to-end tests live under `integration_test/` (see `integration_test/app_test.dart`). Tag each test with `tags: ['integration']` on `testWidgets` so you can run them selectively with `--tags integration`.

**Default CI and local checks:** `flutter test` only runs the `test/` tree. It does **not** run `integration_test/` unless you pass that path, so the default suite stays green without a Proxmox server.

**Run tagged integration tests** (placeholder today; use this when you add device-level or live-PVE scenarios):

```bash
flutter test integration_test --tags integration
```

**Live PVE (optional, maintainer / manual only):** Real cluster tests are opt-in. When you add them, gate API calls on environment variables or secrets and document the setup here. A VM running Proxmox VE (7.x or 8.x) on a local machine (e.g. QEMU/KVM) is enough for manual runs. See the [Proxmox VE documentation](https://pve.proxmox.com/pve-docs/).

---

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md).
