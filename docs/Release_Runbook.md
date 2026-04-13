# Release Runbook

## Overview

Releases are driven by GitHub Actions: when you push or merge to `beta` or `main` and `pubspec.yaml` is part of that changeset, the build workflow can run. A gate step reads the app version from `pubspec.yaml`, derives a Git tag, and either continues or skips with a notice. From there you follow one of two paths: a **beta** pre-release (branch `beta`, version includes `-beta`) that produces an immediate **pre-release** on GitHub with a signed APK, or a **stable** release (branch `main`, version without a pre-release suffix) that produces a **draft** release you publish manually after review.

## Prerequisites

You need Android release signing configured for the workflow. Secrets supply the keystore and key material: `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, and `KEY_ALIAS`. If `KEYSTORE_BASE64` is missing, the workflow fails early with an error that points you to `docs/Android_release_signing.md` for one-time setup. The keystore is written on the runner only for the build and removed afterward; use the same signing key over time so over-the-air updates (for example via Obtainium) keep working without reinstalling the app.

## Version numbering

The `version:` field in `pubspec.yaml` uses a semver-style value plus an optional build segment after `+`.

- **Pre-release (beta):** `MAJOR.MINOR.PATCH-beta.N+BUILD` (for example `1.0.0-beta.14+1`).
- **Stable:** `MAJOR.MINOR.PATCH+BUILD` (for example `1.0.0+1`).

The release gate strips everything from `+` onward for tagging: `1.0.0-beta.14+1` becomes tag `v1.0.0-beta.14`, and `1.0.0+1` becomes tag `v1.0.0`. The `+BUILD` number is not part of the Git tag name.

Example progression:

| Step | `pubspec.yaml` example | Git tag |
|------|-------------------------|---------|
| Beta | `1.0.0-beta.14+1` | `v1.0.0-beta.14` |
| Beta | `1.0.0-beta.15+1` | `v1.0.0-beta.15` |
| Stable | `1.0.0+1` | `v1.0.0` |

Increment `+BUILD` when you bump the version on the same logical release line if you need another workflow run without changing the semver prefix the gate uses (after stripping `+...`).

## Release workflows at a glance

| Branch | Version format | GitHub release type | Draft? | Auto-published (visible as latest)? |
|--------|----------------|---------------------|--------|--------------------------------------|
| `beta` | Contains `-beta` | Pre-release | No (not draft) | Yes, as pre-release when workflow completes |
| `main` | No `-beta` suffix | Stable release | Yes (draft) | No until you publish the draft; GitHub marks it `latest` when you publish |

## Beta release: step-by-step

**What you do**

1. Work on a feature branch and open a PR into `beta`.
2. Bump `version:` in `pubspec.yaml` to the next beta (for example `1.0.0-beta.15+1`). Increment the build number (`+N`) each time you bump if you follow that convention.
3. Merge the PR into `beta`, or push directly to `beta`.

**What CI does (`ci.yml`)**

On every push and PR to `main` or `beta` (no path filter), CI runs first on the same push, in order: `flutter pub get`, `dart format --output=none --set-exit-if-changed .`, `build_runner`, `gen-l10n`, `flutter analyze`, `flutter test`. CI is independent of the release build workflow.

**What the build workflow does on `beta` (when the gate passes)**

1. Flutter **3.41.6** stable is set up; then `pub get`, `build_runner`, and `gen-l10n`.
2. Android release signing is applied from the repository secrets. Missing `KEYSTORE_BASE64` fails fast with a pointer to `docs/Android_release_signing.md`.
3. `flutter build apk --release --obfuscate --split-debug-info=build/app/debug-info` produces a signed APK; the workflow uploads `build/app/debug-info` as an artifact for stack trace symbolication. The APK is renamed to `proxdroid-v<VERSION>.apk` where `<VERSION>` is the semver part after stripping build metadata (no `+...`).
4. Release notes list commits since the previous tag (or all commits if there is no previous tag):

```bash
git log <last_tag>..HEAD --pretty="- %s (%h)"
```
5. Git tag `v<VERSION>` is created and pushed to `origin`.
6. A GitHub Release is published immediately as a **pre-release** (not draft), with the APK attached.
7. An `always()` cleanup step removes signing artifacts (`.jks`, `key.properties`) from the runner.

Expect on the order of five to eight minutes after a successful run: tag `v1.0.0-beta.15` (for example) exists on GitHub and the pre-release includes the signed APK.

## Stable release: step-by-step

**What you do**

1. Merge desired beta work into `beta` and ship beta releases as needed.
2. Merge `beta` into `main` (or open a PR from `beta` to `main`).
3. Bump `version:` to stable form (for example `1.0.0+1`): remove the `-beta.N` suffix.
4. Push or merge to `main`.

**What CI does**

Same as for beta: on push/PR to `main` or `beta`, CI runs `flutter pub get`, `dart format --output=none --set-exit-if-changed .`, `build_runner`, `gen-l10n`, `flutter analyze`, and `flutter test` before the build workflow’s release steps.

**What the build workflow does on `main` (when the gate passes)**

1. Same Flutter version, `pub get`, `build_runner`, `gen-l10n`, signing, and obfuscated `flutter build apk --release` as on beta (including the split debug info artifact); APK is still named `proxdroid-v<VERSION>.apk`.
2. Release notes aggregate beta pre-releases merged into `main` since the previous stable tag. For each beta tag, the workflow tries to use the existing GitHub Release body; if that body is empty, it falls back to:

```bash
git log <prev_tag>..<beta_tag>
```
3. Git tag `v<VERSION>` is created and pushed.
4. A GitHub Release is created as a **draft** (not pre-release). You review and edit it on GitHub Releases, then publish it manually. When you publish the draft, GitHub marks it `latest` automatically.

## Gate logic and idempotency

The gate reads `VERSION` from `pubspec.yaml` by stripping build metadata after `+` (for example `1.0.0-beta.14+1` becomes `1.0.0-beta.14`). The Git tag is always `v<VERSION>`.

**Skip conditions**

- On **`beta`:** the workflow skips with a notice if the version string (after stripping `+...`) does **not** contain a `-beta` suffix, or if tag `v<VERSION>` already exists on the remote.
- On **`main`:** the workflow skips with a notice if the version still contains `-beta`, or if tag `v<VERSION>` already exists on the remote.

**Idempotency**

If the remote tag already exists, the workflow does not create a duplicate release. Re-pushing the same commit or force-pushing will hit this check and skip rather than publishing again.

## What does NOT trigger a release

- Pushes to any branch other than `beta` or `main`.
- Pushes to `beta` or `main` where `pubspec.yaml` is not in the changeset (the build workflow uses a path filter on `pubspec.yaml`).
- A push where the derived tag `v<VERSION>` already exists on the remote.
- A push to `beta` where the version (after stripping `+...`) has no `-beta` suffix.
- A push to `main` where the version (after stripping `+...`) still includes `-beta`.

## Re-releasing / fixing a broken release

If the workflow ran but the result was wrong (notes, APK, or similar), delete the GitHub Release and the remote tag, then push again or re-run the workflow. With the tag removed, the idempotency check no longer blocks you.

If CI fails, fix the problem and push again. Because the build workflow only runs when `pubspec.yaml` changes, a push that fixes code but not `pubspec.yaml` will not re-trigger the release build. To re-trigger without changing the semver again, make a no-op edit to `pubspec.yaml` (for example a comment) or bump the `+BUILD` segment.

## CI (separate from the release build)

Workflow file: `ci.yml`. It runs on **every** push and pull request targeting `main` or `beta`; there is no path filter, so it always runs regardless of which files changed. Step order: `flutter pub get`, `dart format --output=none --set-exit-if-changed .`, `build_runner`, `gen-l10n`, `flutter analyze`, `flutter test`. This runs independently and, on the same push, before the release build workflow completes its work.

## Appendix: workflow file reference

| Workflow file | Role | When it triggers |
|---------------|------|------------------|
| `build.yml` | Gate, Android APK build, signing, tagging, GitHub Release (pre-release on `beta`, draft on `main`) | Every push to `beta` or `main`; or **workflow_dispatch** with branch choice (`beta` / `main`) to retry without a new commit |
| `ci.yml` | Format, codegen, analyze, tests | Every push and PR to `main` or `beta` |
