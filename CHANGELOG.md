# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- GitHub Actions: `build.yml` runs on every push to `beta`/`main` (path filter removed); gate still decides build vs skip. Added **workflow_dispatch** with a branch choice for manual retries without bumping `pubspec.yaml`.

## [1.0.0-beta.22] - 2026-04-13

Combines **1.0.0-beta.20** and **1.0.0-beta.21** (beta.20 was not tagged on the remote; this section is the single changelog entry for that work plus the follow-up release hygiene).

### Added

- Language preference support with localization enhancements.

### Changed

- Server editor (password auth): in-app guidance to use API tokens when the Proxmox account has two-factor authentication (TFA) enabled.
- Improved accessibility and UI semantics across the application.
- Integrated Google Fonts and refined theme typography.
- README: Android requirements, Download/Obtainium guidance (including one-tap add link), and maintainer doc links for releases and signing.

### Internal

- Bump version to `1.0.0-beta.20` and refresh `CHANGELOG.md` for that prerelease.
- GitHub Actions: `permissions.contents: read` on the CI workflow; `permissions.workflows: write` on the release workflow so tag pushes succeed when the release commit touches `.github/workflows`.
- Changelog updates for the 1.0.0-beta.20 release entry.
- Bump version to `1.0.0-beta.21` in `pubspec.yaml`.

## [1.0.0-beta.19] - 2026-04-13

### Changed

- Enhanced VM and LXC configuration editor with improved UI and data handling.

## [1.0.0-beta.18] - 2026-04-11

### Security

- Self-signed TLS now uses a stored leaf certificate SHA-256 pin (`pinnedTlsSha256`) with a fetch action in the server editor; release Android builds use R8 shrinking, optional Dart obfuscation in CI, stricter Gradle release signing, `FLAG_SECURE` on server credential screens, disabled ADB backup, Dio send timeout, and redacted verbose connection diagnostics.

### Added

- VM and LXC creation and editing.
- Expanded VM and LXC config editor functionality with improved data handling.

### Changed

- Task status handling for PVE list rows.

### Internal

- Updated architecture documentation, configuration models, and VM/LXC config editor roadmap planning.

## [1.0.0-beta.16] - 2026-04-11

### Changed

- Premium dialog now uses the branch navigator for clearer context handling.
- Task list supports guest filtering with improved status presentation.
- Container and VM detail screens use consolidated power action icon pills.
- Container and VM list screens updated with refined UI components and theme integration.
- Node detail screen shows additional metrics with improved data handling.
- Preferences screen adds theme selection with localization updates.

### Internal

- Bumped version to `1.0.0-beta.16+1` in `pubspec.yaml`.

## [1.0.0-beta.15] - 2026-04-11

### Added

- Preferences screen with default chart timeframe settings.
- Proxmox guest tags integrated into UI components with localization updates.
- Server management enhancements using tags and related UI updates.
- Node detail screen and routing updates.
- App icon on the settings screen.
- Enhanced task status handling and presentation on the task list screen.

### Changed

- GitHub Actions: `build.yml` now runs on push to **`beta`** or **`main`** when
  **`pubspec.yaml`** changes; CI creates `v<version>` if missing, publishes
  **beta** pre-releases or **main** stable **draft** releases (see `README.md`).
- Simplified dashboard screen layout.

### Internal

- Bumped version to `1.0.0-beta.15+1` in `pubspec.yaml`.
- `dart format` on several UI files; removed unused `Theme` locals; `SectionHeader`
  tests and muted goldens aligned with uppercase muted titles and `onSurfaceVariant` alpha.
- Documentation: refreshed `CHANGELOG.md` for CI changes, removed obsolete changelog ideas
  document, clarified changelog guidance for Cursor rules and hooks.

## [1.0.0-beta.14] - 2026-04-11

### Changed

- Refined CI workflow: trigger on both `main` and `beta` branches; updated version bump step.
- Refactored `CHANGELOG.md` and `README.md` to clarify CI processes and release conventions.

## [1.0.0-beta.13+1] - 2026-04-11

### Added

- Premium UI redesign across all primary screens and navigation shell.

### Fixed

- Fixed three chart display bugs: label text wrapping, missing memory data, and cramped sparklines.

### Internal

- Enhanced CI workflow; bumped version to `1.0.0-beta.13+1`.

## [1.0.0-beta.11] - 2026-04-10

### Internal

- Refactored UI code across multiple files for improved readability and consistency.

## [1.0.0-beta.10] - 2026-04-10

### Changed

- Refactored navigation and UI components for an improved user experience.
- Refactored UI component hierarchy and enhanced theme structure.

### Internal

- Updated documentation and `.gitignore` for design references.

## [1.0.0-beta.9] - 2026-04-10

### Changed

- Implemented Material 3 UI updates and enhanced overall navigation structure.

## [1.0.0-beta.8] - 2026-04-10

### Fixed

- Improved error handling in API interceptors for more robust network requests.

### Internal

- Enhanced API documentation for resource-fetching methods.

## [1.0.0-beta.7] - 2026-04-10

### Changed

- Version bump; no user-visible changes.

## [1.0.0-beta.6] - 2026-04-10

### Changed

- Enhanced Android release signing process in GitHub Actions for more reliable APK builds.

### Internal

- Removed unused Kotlin compiler session file from the Android project.

## [1.0.0-beta.5] - 2026-04-10

### Fixed

- Clarified network access requirement in `AndroidManifest.xml` to ensure correct
  runtime permissions in release builds.

## [1.0.0-beta.4] - 2026-04-10

### Changed

- Updated launcher icons for all required Android density buckets.
- Updated documentation and `AndroidManifest.xml` to clarify network permission
  requirements for release builds.

### Internal

- Refactored Proxmox login ID validation test case for correctness.

## [1.0.0-beta.3] - 2026-04-10

### Changed

- Enhanced connection diagnostics and refined Proxmox API settings integration.

## [1.0.0-beta.2] - 2026-04-10

### Added

- Launcher icon configuration integrated via `flutter_launcher_icons`; dependencies updated.

### Changed

- Updated README and release workflow to clarify APK naming conventions for GitHub Releases.

## [1.0.0-beta.1] - 2026-04-10

First public **beta** prerelease on GitHub Releases (APK via CI).

### Added

- Persistent offline banner when the device has no network connectivity (`connectivity_plus`).
- Settings screen: appearance (dark / light / system), about (version, repo, license), support links.
- Theme mode preference persisted with Hive (`settings` box).
- Router page transitions; haptic feedback on VM/LXC power actions.
- Representative tests: repository fakes, Riverpod theme mode, Freezed JSON roundtrips,
  settings and server editor widget tests; `integration_test` scaffold (tagged, opt-in
  per `CONTRIBUTING.md`).

### Changed

- Error messages and empty states reviewed; Proxmox exceptions mapped to localized strings.
- Pull-to-refresh and shimmer loading patterns on data-heavy screens.
- Localization pass: formatted UI strings moved into `app_en.arb`; ongoing terminology
  alignment with Proxmox UI.
- GitHub Actions: release workflow runs only on beta prerelease tags (`v*-beta*`) and
  publishes GitHub **prereleases** with the release APK.

[Unreleased]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.21...HEAD
[1.0.0-beta.21]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.19...v1.0.0-beta.21
[1.0.0-beta.19]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.18...v1.0.0-beta.19
[1.0.0-beta.18]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.16...v1.0.0-beta.18
[1.0.0-beta.16]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.15...v1.0.0-beta.16
[1.0.0-beta.15]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.14...v1.0.0-beta.15
[1.0.0-beta.14]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.13%2B1...v1.0.0-beta.14
[1.0.0-beta.13+1]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.11...v1.0.0-beta.13%2B1
[1.0.0-beta.11]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.10...v1.0.0-beta.11
[1.0.0-beta.10]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.9...v1.0.0-beta.10
[1.0.0-beta.9]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.8...v1.0.0-beta.9
[1.0.0-beta.8]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.7...v1.0.0-beta.8
[1.0.0-beta.7]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.6...v1.0.0-beta.7
[1.0.0-beta.6]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.5...v1.0.0-beta.6
[1.0.0-beta.5]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.4...v1.0.0-beta.5
[1.0.0-beta.4]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.3...v1.0.0-beta.4
[1.0.0-beta.3]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.2...v1.0.0-beta.3
[1.0.0-beta.2]: https://github.com/mdg-labs/proxdroid/compare/v1.0.0-beta.1...v1.0.0-beta.2
[1.0.0-beta.1]: https://github.com/mdg-labs/proxdroid/commits/v1.0.0-beta.1