---
name: changelog
description: >-
  Syncs git remote tags, compares them to CHANGELOG.md, and updates CHANGELOG.md
  using Keep a Changelog layout. Use when the user runs /changelog, asks to align
  the changelog with releases or tags, or to backfill missing version sections
  from git history.
---

# Changelog maintenance (`/changelog`)

## When to use

- User invokes **`/changelog`** or asks to refresh, reconcile, or backfill `CHANGELOG.md` against **git tags** (especially after `git fetch`).
- Preparing a release: ensure published tags have matching sections and `[Unreleased]` is accurate.

## Prerequisites

- Git repo with `origin` (or ask which remote to use).
- Project uses tags `v<version>` matching `pubspec.yaml` `version:` (see `README.md` / `build.yml`).

## Workflow (run in order)

### 1. Fetch remote tags

```bash
git fetch origin --tags --prune
```

If the default remote is not `origin`, use that remote name consistently below.

### 2. Build two inventories

**A — Tags (semver-ish order, newest last for scanning gaps):**

```bash
git tag -l 'v*' --sort=version:refname
```

Strip the leading `v` to compare to changelog headings (e.g. `v1.0.0-beta.1` → `1.0.0-beta.1`).

**B — Documented versions in CHANGELOG.md**

- Read [`CHANGELOG.md`](CHANGELOG.md).
- Collect every `## [x.y.z…]` heading (including `[Unreleased]` — do not treat it as a released tag).
- Normalize: heading text inside brackets is the version key.

### 3. Compare and classify

> **⚠️ Early exit — no tags found:**  
> If `git tag -l 'v*'` returns no output, **stop here** and **do not** continue to Step 4 (or the **Otherwise** branch below).
>
> - Ensure `CHANGELOG.md` has **`## [Unreleased]`** at the top with correct Keep a Changelog subsection structure (`### Added`, `### Changed`, etc. as needed — create empty scaffolding only if the file is missing or malformed).
> - After ensuring `[Unreleased]` exists, resolve the remote URL via `git remote get-url origin` and **append** (or **update**) the following footer link at the bottom of `CHANGELOG.md`:
>
>   ```
>   [Unreleased]: https://github.com/OWNER/REPO/commits/HEAD
>   ```
>
>   Use **`commits/HEAD`** (not a `compare/` link) since there is no base tag to compare against yet. Parse `OWNER` and `REPO` from the remote URL, supporting both `https://github.com/OWNER/REPO.git` and `git@github.com:OWNER/REPO.git` formats.
> - Jump to **Step 6**.

Otherwise:

- **Tag with no matching `## [<version>]` section** → **missing section** (backfill candidate).
- **`## [version]` with no matching remote tag** → append that heading’s version string to a **Warnings** list (stale heading, renamed tag, or not yet pushed). Do not delete without explicit user confirmation. In **Step 6**, print this **Warnings** list explicitly so nothing is silently skipped.
- **`pubspec.yaml` `version:`** → if it differs from the latest tag and work is unreleased, keep bullets under **`## [Unreleased]`** until the user cuts a release; do not invent a dated release section for an unpublished version.

### 4. Update `CHANGELOG.md` (Keep a Changelog)

**Principles**

- Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/): `Added`, `Changed`, `Fixed`, `Removed`, `Security` as appropriate; use **past tense**, imperative-style bullets, one idea per line.
- **Do not invent** user-visible product copy. For backfills, prefer:
  - **`### Changed`** (or `### Added`) with bullets derived from **merge commit subjects** or **conventional** `feat:` / `fix:` lines when present, or
  - **`### Notes (from git)`** subsection **only** when user-facing commits exist but their subjects are too terse or ambiguous to group into standard categories — label it so maintainers can rewrite later. Never use `### Notes (from git)` for version-bump-only tags; use `### Changed` / `- Version bump; no user-visible changes.` for those instead.

**Squash merges (GitHub):** If the project relies on **squash-merge** PRs, `git log … --no-merges` can drop the **only** commit that carries the squashed PR description (depending on how the tag points at history). In that case, either **omit `--no-merges`** and curate noisy output manually, or run a **second pass** such as `git log <range> --merges --pretty=format:'- %s'` and merge sensible bullets with the first pass.

**For each missing tag** (oldest gap first, to preserve chronological order in the file):

1. Resolve previous tag (predecessor in `version:refname` order among `v*`).
2. Collect commits:

   ```bash
   git log <prev_tag>..<tag> --no-merges --pretty=format:'- %s'
   ```

   If there is no previous tag:

   ```bash
   git log <tag> --no-merges --pretty=format:'- %s'
   ```

   For repos with a **very long** initial history, this can be large — the maintainer should **manually trim or summarize** older commits in `CHANGELOG.md` after the agent’s pass; do not cap with an arbitrary commit count.

3. **Classify commits** before writing any bullets. Split the raw list into two buckets:

   - **Maintenance commits** — subjects matching any of the following patterns (case-insensitive):
     - `dart format`, `flutter format`
     - `build_runner`, `code gen`, `codegen`
     - `analyzer`, `lint`, `linting`
     - `unused import`, `unused variable`, `remove unused`
     - `test fix`, `fix test`, `align test`, `update test`, `golden`
     - `version bump`, `bump version`, `chore(release)`, `chore: update version`, `update version`
     - `remove unused … file`, `compiler session`, `.kotlin`
   - **User-facing commits** — everything else.

   **If all commits are maintenance-only** (the user-facing bucket is empty): write a single `### Changed` subsection with the text `- Version bump; no user-visible changes.` — do **not** list the individual maintenance commits and do **not** use `### Notes (from git)`.

   **If user-facing commits exist**: group them into `### Added`, `### Changed`, `### Fixed`, etc. as appropriate. Then, if any maintenance commits also exist, append a `### Internal` subsection **after** all user-facing subsections containing those bullets.

   **`### Notes (from git)`** is reserved for tags that have user-facing commits but the subjects are too terse or ambiguous to group meaningfully into standard Keep a Changelog categories. It must never be used for version-bump-only tags; use `### Changed` / `- Version bump; no user-visible changes.` for those instead.

4. Insert a new section **below `[Unreleased]`** and **above the next older documented release**, using:

   ```markdown
   ## [<version-without-v>] - YYYY-MM-DD

   Short optional summary line if clear from tags (e.g. first stable beta).

   ### Changed

   - …
   ```

   Set **YYYY-MM-DD** from the tag itself (works for **lightweight and annotated** tags):

   ```bash
   git for-each-ref --format='%(creatordate:short)' "refs/tags/<tag>"
   ```

5. Keep `[Unreleased]` at the top; never remove it. Move or merge duplicate bullets if backfill overlaps content already under `[Unreleased]`.

**Diff links (Keep a Changelog):** [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) recommends **reference-style compare links** at the **bottom** of `CHANGELOG.md`, one per documented version, e.g.:

```
[Unreleased]: https://github.com/OWNER/REPO/compare/vX.Y.Z...HEAD
[X.Y.Z]: https://github.com/OWNER/REPO/compare/vX.Y.Z-1...vX.Y.Z
```

Resolve `OWNER` and `REPO` from `git remote get-url origin` (support both `https://github.com/OWNER/REPO.git` and `git@github.com:OWNER/REPO.git`). Whenever the agent **adds or modifies** a version section (including `[Unreleased]` footers), **generate or update** these footer links so they stay consistent with the tag sequence and `HEAD`.

### 5. Consistency pass

- Re-read `CHANGELOG.md` for duplicate sections or duplicate bullets across `[Unreleased]` and a new section.
- If `pubspec.yaml` documents a version that now matches a **new** tag the user just pushed, offer to **rename** `[Unreleased]` content into `## [that version] - date` **only** when the user explicitly asked to “cut” or “finalize” that release; otherwise leave `[Unreleased]` as the working bucket.

### 6. Finish

- Summarize: tags fetched, sections added or skipped, any headings without tags.
- Print the **Warnings** list from Step 3 explicitly (every `## [version]` with no matching remote tag). If the list is empty, state that clearly.
- Suggest next human step: e.g. polish `### Notes (from git)` into real `Added` / `Changed` / `Fixed` bullets.
- **Do not stage, commit, or push any changes unless the user explicitly requests it.**

## Constraints

- Do not strip or rewrite historical sections the user may have curated, except to fix clear duplicates introduced in the same run.

## Success criteria

- `git fetch … --tags` has been run at least once in the session before comparing.
- Every **remote** `v*` tag the user cares about either maps to a `## […]` block or is listed as intentionally skipped with a one-line reason.
- `CHANGELOG.md` remains valid Keep a Changelog structure and keeps **`## [Unreleased]`** as the first version section.
