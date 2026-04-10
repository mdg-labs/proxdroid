# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Persistent offline banner when the device has no network connectivity (`connectivity_plus`).
- Settings screen: appearance (dark / light / system), about (version, repo, license), support links.
- Theme mode preference persisted with Hive (`settings` box).
- Router page transitions; haptic feedback on VM/LXC power actions.
- Representative tests: repository fakes, Riverpod theme mode, Freezed JSON roundtrips, settings and server editor widget tests; `integration_test` scaffold (tagged, opt-in per `CONTRIBUTING.md`).

### Changed

- Error messages and empty states reviewed; Proxmox exceptions mapped to localized strings.
- Pull-to-refresh and shimmer loading patterns on data-heavy screens.
- Localization pass: formatted UI strings moved into `app_en.arb`; ongoing terminology alignment with Proxmox UI.
- GitHub Actions: release workflow runs only on beta prerelease tags (`v*-beta*`) and publishes GitHub **prereleases** with the release APK.
