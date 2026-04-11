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

### 2b. pubspec version check

Read `pubspec.yaml` and extract the `version:` field. Strip any build metadata after `+` (e.g. `1.0.0-beta.15+3` → use `1.0.0-beta.15` as the version key). Compare it against the latest tag from the `version:refname`-sorted tag list.

**If pubspec version == latest tag version:** nothing to do here — continue to Step 3 normally.

**⚠️ If pubspec version is ahead of all tags — promote `[Unreleased]` automatically:**

Do not ask for confirmation. Execute the following immediately.

Determine which scenario applies:

- **Scenario A — next pre-release** (e.g. pubspec is `1.0.0-beta.15`, latest tag is `v1.0.0-beta.14`): the pre-release identifier is the same base type (both `beta`, both `rc`, etc.).
- **Scenario B — stable release** (e.g. pubspec is `1.0.0` or `2.0.0`, latest tag is any pre-release of that same base version): pubspec version has no pre-release suffix. Check whether pre-release tags for this base version exist in the tag list (e.g. `1.0.0-beta.*`). **If no such pre-release tags exist** (e.g. latest tag is `v0.9.0` and pubspec is `1.0.0`): skip the beta summary entirely and proceed with **Scenario A** logic — collect commits since the latest tag, classify, and promote `[Unreleased]` as the new stable version.

**Scenario A — collect and promote:**

1. Collect all commits since the latest tag that are not yet tagged:

   ```bash
   git log <latest_tag>..HEAD --no-merges --pretty=format:'- %s'
   ```

2. Apply the same commit classification rules from Step 4 (maintenance vs. user-facing buckets, `### Internal`, version-bump-only fallback).
3. Use today's date (`date +%Y-%m-%d`) as the release date.
4. Rename `## [Unreleased]` to `## [<pubspec-version>] - <today>` and replace its content with the freshly collected and classified commits. If `[Unreleased]` already had bullets, merge them with the newly collected commits — deduplicate, do not double-count.
5. Insert a new empty `## [Unreleased]` section above the promoted section with no bullets.
6. Update the footer diff links: `[Unreleased]` → `compare/v<pubspec-version>...HEAD`; add `[<pubspec-version>]` → `compare/<latest_tag>...v<pubspec-version>`.

**Scenario B — stable release summary (pre-releases exist):**

1. Identify all beta/pre-release sections in `CHANGELOG.md` that belong to this stable version (e.g. for `1.0.0`: collect all `## [1.0.0-beta.*]`, `## [1.0.0-rc.*]` sections, in chronological order oldest-first).
2. Collect all commits since the tag that preceded the first of those pre-releases all the way to HEAD:

   ```bash
   git log <tag-before-first-prerelease>..HEAD --no-merges --pretty=format:'- %s'
   ```

3. Apply commit classification (Step 4 rules). Then additionally deduplicate against bullets already present across the collected pre-release sections — prefer the existing human-curated wording over the raw git subject when the same change appears in both.
4. Produce a single `## [<pubspec-version>] - <today>` section with a one-line summary (e.g. `First stable release.`) followed by the merged, deduplicated, classified bullets.
5. Do not remove the existing beta sections — keep them below the new stable section so the history is preserved.
6. Rename `## [Unreleased]` to the new stable version section and insert a fresh empty `## [Unreleased]` above it, exactly as in Scenario A steps 4–5.
7. Update footer diff links: `[Unreleased]` → `compare/v<pubspec-version>...HEAD`; add `[<pubspec-version>]` → `compare/<tag-before-first-prerelease>...v<pubspec-version>`.

After completing either scenario, continue to Step 3 to handle any remaining backfill gaps as usual.

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
- **`## [version]` with no matching remote tag** → append that heading's version string to a **Warnings** list (stale heading, renamed tag, or not yet pushed). Do not delete without explicit user confirmation. In **Step 6**, print this **Warnings** list explicitly so nothing is silently skipped.

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

   For repos with a **very long** initial history, this can be large — the maintainer should **manually trim or summarize** older commits in `CHANGELOG.md` after the agent's pass; do not cap with an arbitrary commit count.

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