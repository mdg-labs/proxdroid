Here’s a clear split between what **rules** can do vs what **hooks** can do in Cursor, given you’re mostly “developing with Cursor” rather than typing every line yourself.

### Hooks are not a good place to “have Cursor evaluate” the changelog

Cursor hooks run **scripts** or small **prompt-policy** checks. They receive JSON on stdin and return JSON on stdout. They do **not** spin up a full agent pass that reads the whole repo and rewrites `CHANGELOG.md` like a mini-conversation.

What hooks *can* do usefully:

- **`postToolUse`** (often with a matcher on `Write` / edits under `lib/`): inject **`additional_context`** reminding the model: “If this was user-visible, add a line under `[Unreleased]` in `CHANGELOG.md`.” That nudges **during** the run, right after an edit, which is usually better than “at conversation end.”
- **`stop`**: useful for **follow-up loops** in some setups (see Cursor hook docs for exact fields), but using it to force changelog maintenance tends to be **fragile or noisy** (every stop, merge conflicts with “one more turn,” etc.).
- **Deterministic checks only** in a command hook: e.g. “warn if `lib/` changed in git diff but `CHANGELOG.md` did not” — no LLM, just `git diff`.

So: **there isn’t a hook that reliably means “before each conversation end, run Cursor again to fix CHANGELOG.”** The model that should maintain the changelog is **already** the agent in the thread; hooks are sidecars.

### A **rule** is the better default for your situation

The reliable pattern is: **tell the agent, in repo rules, that updating the changelog is part of “done.”**

Concretely:

- Add a **project rule** (e.g. `.cursor/rules/changelog-unreleased.mdc`) that says something like:
  - When completing a task that changes **user-visible** behavior (UI copy, flows, defaults, permissions, etc.), **append** a bullet under `CHANGELOG.md` → `## [Unreleased]` in the right subsection (Added / Changed / Fixed).
  - Skip for refactors, tests-only, internal renames, comment-only, CI-only, unless user-facing.
  - Do **not** invent marketing text; one factual line is enough.
  - If nothing user-facing shipped, **do not** touch `CHANGELOG.md`.

Pair it with your existing **“update roadmap when affected”** rule so both stay in the same mental “before you say you’re finished” bucket.

Use **`alwaysApply: true`** only if you want that reminder in every chat (more tokens). Prefer **`alwaysApply: false` + globs** on paths the agent usually touches for features (`lib/**/*.dart`, maybe `lib/l10n/*.arb`) so the rule appears when those files are in play—**never** combine `alwaysApply: true` with `globs` in the same rule file (your workspace rules call that out).

### Practical combo (what I’d actually use)

1. **Rule** — primary: “changelog is part of completion for user-visible work.”
2. **Optional `postToolUse` hook** — secondary: after writes under `lib/`, inject one line of `additional_context` pointing at that rule + `CHANGELOG.md`. That’s a **nudge**, not a second agent.

### Why not rely on “conversation end” only?

The agent doesn’t have a special “end” hook that runs **after** it has already said “all done” in a way you trust. By then you’re relying on the **last** assistant turn to have included the edit. Nudges **right after `lib/` edits** (rule + optional `postToolUse`) line up better with how agents actually work.

---

If you want this codified in the repo next, say whether you prefer **`alwaysApply` + short checklist** or **globs on `lib/**` only**, and I can draft the exact `.mdc` (and optionally a minimal `postToolUse` entry in `.cursor/hooks.json`).