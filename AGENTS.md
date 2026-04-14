# AGENTS.md

## Cursor Cloud specific instructions

### Project overview

ProxDroid is a Flutter/Dart Android client for Proxmox VE. Single app (no monorepo, no backend services). All unit/widget tests mock the API layer — no live Proxmox server needed for `flutter test`.

### Flutter SDK

CI pins **Flutter 3.41.6 stable**. The SDK is installed at `/opt/flutter` and is on `PATH` via `~/.bashrc`. Verify with `flutter --version`.

### CI verification chain

Run from repo root — see `.cursor/rules/ci-local-verification.mdc` and `.github/workflows/ci.yml`:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
```

All six commands must exit 0 before considering a task complete.

### Code generation

After editing Freezed models, Riverpod providers, or JSON-serializable classes, regenerate with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

After editing ARB localization files (`lib/l10n/*.arb`), regenerate with:

```bash
flutter gen-l10n
```

### Running the app

This is an Android app — `flutter run` requires an Android emulator or device, which is not available in this headless VM. The "hello world" validation for Cloud agents is the full CI chain (format, codegen, analyze, test) passing cleanly.

### Gotchas

- `build_runner` may emit a warning about SDK language version being newer than `analyzer` language version. This is cosmetic and does not affect correctness.
- `flutter gen-l10n` reads `l10n.yaml` in the project root; command-line arguments are ignored when that file exists.
- Tests run on the host VM without Android SDK. `flutter test` uses the Dart VM test runner, not a device.
- No Docker, no database, no external services are needed for development or testing.
