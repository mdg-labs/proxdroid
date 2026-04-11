Here are practical patterns that fit “mostly manual, but easier before beta,” without tying `CHANGELOG.md` to `build.yml`.

### 1. Treat `[Unreleased]` as the only automation you need

Keep a single **`## [Unreleased]`** section and add bullets as you merge work (Added / Changed / Fixed). When you bump `pubspec` for beta, **rename** that block to `## [1.0.0-beta.13] - 2026-04-11` and start a fresh `[Unreleased]`. No CI required; `build.yml` stays focused on GitHub release bodies.

That stays fully manual but predictable.

### 2. Nudge locally (no “auto text,” just discipline)

- **PR template** (you may already have one): checkbox — “Updated `CHANGELOG.md` `[Unreleased]` for user-visible changes.”
- **Optional git hook** (pre-commit or pre-push): *warn* (not block) if `lib/` changed but `CHANGELOG.md` did not—easy to ignore for refactors, still catches forgetfulness.

This keeps control 100% human.

### 3. Fragment-based tools (good “hybrid”)

Tools like **[Changie](https://github.com/miniscruff/changie)** (or Changesets-style flows) match what you described:

- During development you run something like `changie new` and drop a **small file** (or answer prompts) per change.
- Files live under e.g. `.changes/unreleased/` until release.
- At release you run `changie batch` / `changie merge` and it **stitches** those fragments into `CHANGELOG.md` in proper Keep a Changelog shape.

You still write meaningful text; the tool handles **ordering, sections, and the final merge** so you’re not hand-editing huge blocks. That’s usually nicer than appending raw `git log` into `CHANGELOG.md`.

### 4. Generate a *draft* locally, then you curate

If you like conventional commits (`feat:`, `fix:`), **`git-cliff`** (or similar) can print a **draft** section from `git log`. You copy the useful lines into `[Unreleased]` and delete noise. Fully manual final text; automation only suggests.

---

**Recommendation for your workflow:** keep **`[Unreleased]` + manual bullets** as source of truth; optionally add **Changie** (or a light hook + PR checkbox) if you want structure without CI touching `CHANGELOG.md`. Reserve **GitHub release notes** from `build.yml` for what you already automated there.

If you want to go further next step, say whether you prefer **Changie-style fragments** vs **only hooks + template**—implementation effort differs a lot.