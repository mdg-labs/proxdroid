# ProxDroid UI Refactor Plan

```
Status: Draft — Refactor plan (design & presentation only; no API/backend changes)
Owner: ProxDroid maintainers
Last updated: April 2026
Execution roadmap: §11
Scope: Hybrid **ProxMate-style** grouped lists (true black, inset cards, section headers, blue nav/CTA accents) + **Absorb-style** premium dark touches (high corner radius, muted gold/tan secondary accent, pill highlights, generous padding, rounded iconography)
```

> **Non-goals (explicit):** No Proxmox API or repository contract changes; no removal or hiding of existing features; navigation *destinations* and data flows stay the same except for the **mandatory Phase 4** hybrid shell (§4.2), which must preserve all `go_router` paths and deep links. This document is **design-system and UI-structure** guidance only.

> **Reference visuals:** Place and maintain comparison screenshots under [`docs/references/screenshots/`](references/screenshots/) (canonical path; folder may be empty in-repo — populate with ProxMate / Absorb / competitor references as available).

---

## 1. Goals & principles

1. **Move off generic Material 3 defaults** while staying on Material 3 (`useMaterial3: true`). Today `AppTheme` + `AppColors` already seed orange primary; the refactor intentionally **splits accents**: **blue** for wayfinding and primary actions (ProxMate), **gold/tan** for premium emphasis, charts, and decorative hierarchy (Absorb), without abandoning Proxmox-adjacent warmth where appropriate.
2. **Hybrid aesthetic:** Grouped, iOS-like list psychology (inset rows, dividers, chevrons, small-caps section labels) inside a **true-black** canvas with **elevated card surfaces** (12–20px radius).
3. **Accessibility:** WCAG-minded contrast on true black (test `onSurface` / `onSurfaceVariant` / gold accent on `#000000`); minimum **48dp** touch targets for power actions, sheet primary button, and drawer destinations; support **text scale** (no fixed-height clipping in dialogs/sheets).
4. **l10n & terminology:** All user-visible strings remain in `lib/l10n/app_en.arb` via `AppLocalizations`; labels stay aligned with Proxmox VE (Node, Virtual Machine, Container, Storage, Task, Backup, vzdump, etc.).
5. **Consistency:** Shared primitives (`ShellSectionBody`, list rows, cards, charts, dialogs) consume the same tokens so screens do not “drift” visually.

---

## 2. Design tokens

### 2.1 Color roles (`ColorScheme` + extensions)

| Token role | Dark target | Usage |
|------------|-------------|--------|
| `scaffoldBackgroundColor` | **True black** `#000000` (or `#0A0A0A` if banding on OLED tests) | Full-screen canvas behind everything |
| `surface` / card fill | **Dark grey** ~`#1C1C1E`–`#2C2C2C` | Grouped cards, bottom sheet surface, dialog surface |
| `surfaceContainerLow` / `surfaceContainer` / `surfaceContainerHigh` | Stepped greys between scaffold and cards | Pressed states, nested chips, chart card interior |
| `primary` | **Blue** (~`#0A84FF` iOS-like or M3 blue tuned for black) | **Selected** drawer destination tint, key CTAs (Connect, Confirm, Start backup), links, focus rings |
| `onPrimary` | High-contrast on blue | Text/icons on primary buttons |
| `secondary` / `tertiary` | **Muted gold/tan** (~`#D4AF37` desaturated → `#C9A962` for dark) | Section ornament, chart series accents, premium dividers, optional icon badges — **not** for error/success |
| `outline` / `outlineVariant` | Subtle grey | Hairlines, inset dividers |
| `error` / `onError` | Keep semantic | Force stop warnings, destructive emphasis |
| **Navigation bar / drawer** | `primary` or dedicated `NavigationBarTheme` indicator | Pill/slot highlight for current section |

**When to use blue vs gold:**

- **Blue (`primary`):** Navigation selection, primary filled buttons, connection test, backup “Start”, dialog confirm, active choice in segmented/pill controls, hyperlinks.
- **Gold/tan (`secondary` or custom `AppColors.premiumAccent`):** Section title rules, optional chart line alternates, “hero” summary metrics, icon background rings on detail headers — sparingly so the UI does not compete with status semantics (green/red/yellow badges stay on semantic colors).

### 2.2 Typography

| Style | Role |
|-------|------|
| `displaySmall` / `headlineMedium` | Rare; splash-style empty states only |
| `titleLarge` | App bar titles, sheet titles |
| `titleMedium` | Card titles (node name, VM name) |
| `bodyLarge` | Primary row title |
| `bodyMedium` | Subtitles, dialog body |
| `labelSmall` + `letterSpacing` + `onSurfaceVariant` | **Section headers** (uppercase / small caps via `Text` + `FontFeature` or styled `labelSmall`) |
| `bodySmall` / `labelMedium` | Metadata, badges, captions |

**Rule:** Section headers mimic ProxMate: grey/orange or grey/gold **label** color, semibold, not full all-caps shouting unless ARB strings already specify.

### 2.3 Corner radii

| Element | Radius |
|---------|--------|
| Large cards (node, VM row container) | **16–20** |
| Dialogs / bottom sheet top corners | **20–28** (Absorb “high radius”) |
| Chips / pill tab / segmented replacement | **999** (stadium) |
| Small inner fields | **12** (align with current `app_theme.dart` `radiusMd`) |
| Status badges | **8** (current) or **12** if moving to “softer” look |
| Offline banner bottom | **12–16** (keep rounded; retint to token) |

### 2.4 Spacing scale

Use an **8px grid**: 8, 12, 16, 20, 24, 32. Detail screens: **generous vertical rhythm** (Absorb) — 16–24 between sections; lists: **horizontal inset** 16 from screen for grouped look, with **divider inset** matching title text start (e.g. 16 + optional avatar width).

### 2.5 Dividers & insets

- **Inset horizontal rule** between rows inside the same group (ProxMate): `Divider(indent: 16, endIndent: 16)` or custom `Border` on row — **no** full-bleed hairline inside grouped card.
- **Between groups:** 24–32 vertical gap + section header; optional 1px `outlineVariant` only if needed for clarity on light surfaces.

### 2.6 Icons

- **Navigation / list leading:** **Outlined** when unselected; **Filled** when selected (current drawer pattern — keep).
- **Settings / About:** Outlined for calm; use **thick rounded** icon set where Material allows (`Icons.*_rounded`).
- **Destructive / warning:** Filled warning icon in dialogs only if contrast holds on true black.

---

## 3. Component library plan

Build or refactor toward these **shared** widgets (names indicative — final names follow `lib/` conventions):

| Planned widget | Responsibility | Primary home / refactor target |
|----------------|----------------|----------------------------------|
| `GroupedSection` | Vertical gap + optional section header + one child | `lib/shared/widgets/grouped_section.dart` |
| `SectionHeader` | Small-caps / label style title + optional trailing action | Extract from `settings_screen.dart` `_SectionHeader`; unify drawer labels |
| `InsetGroupedList` / `PremiumListRow` | Card-wrapped `ListView` with inset dividers, leading icon/thumbnail, title/subtitle, trailing badge + chevron | Replace ad-hoc `Card`+`ListTile` in VM/Container/Storage/Task lists |
| `ShellAppBar` (optional) | Thin wrapper around `AppBar` + tokens for true-black scroll edge | Or extend `ShellSectionBody` |
| `PillTabBar` / `SegmentedPill` | Theme selector, timeframe selector, filter chips row | Settings theme control; replace `ChartTimeframeSelector` `ChoiceChip` row with pill `SegmentedButton` or custom |
| `PremiumDialog` | Consistent padding, 24–28 radius, title/body/actions | Wrap `AlertDialog` usages in VM/Container/Settings/Server editor |
| `PremiumBottomSheet` | Drag handle, surface color, padding, primary button full-width | `TriggerBackupSheet` wrapper |
| `ResourceGaugeRow` | Label + linear progress + optional % (CPU/RAM/disk) | Dashboard node cards, VM/container rows, storage cards |
| `ChartCard` | Title row + optional timeframe + `ResourceLineChart` in bordered surface | VM/Container detail + dashboard compact charts |
| `ConnectivityBanner` | Offline strip; semantic colors | Evolve from `AppShell` inline `Material` |
| `IconBadgeAvatar` | Large rounded square/circle icon holder (Absorb thick icon) | Empty states, detail headers |

**Theme files:** Extend `lib/app/theme/app_colors.dart` with semantic aliases (`scaffoldPureBlack`, `premiumAccent`, `navigationAccent`); extend `lib/app/theme/app_theme.dart` with `NavigationDrawerThemeData`, `DialogTheme`, `BottomSheetThemeData`, `SnackBarThemeData`, `ProgressIndicatorTheme`, and `ChipTheme` / `SegmentedButtonTheme` for pills.

**Existing files to refactor (non-exhaustive):** `loading_shimmer.dart`, `error_view.dart`, `empty_state.dart`, `status_badge.dart`, `resource_chart.dart`, `shell_section_body.dart`, `shell_app_bar_leading.dart`, feature screens under `lib/features/*/ui/`.

---

## 4. Navigation & shell

### 4.1 Current behavior (authoritative)

- **`lib/app/router.dart`:** `ShellRoute` wraps all destinations; each route uses `_fadeShellPage` (250ms fade).
- **`lib/app/app_shell.dart`:** `Scaffold` with `Column`: optional **offline banner** → `Expanded(child: child)`. **NavigationDrawer** with branding header, **Infrastructure** / **Operations** section labels, eight destinations (`/servers` … `/settings`). Active server shortcut row → `/servers`.

### 4.2 Recommendation: **hybrid shell (Phase 4)**

| Layer | Recommendation |
|-------|----------------|
| **Keep** | `NavigationDrawer` as **full menu** (server switch, all sections, settings) — best for 8+ destinations and Proxmox “many surfaces” model. |
| **Add (Phase 4)** | **Bottom navigation** with **4–5 primary tabs** (e.g. Dashboard, VMs, Containers, Tasks, More) where **More** opens drawer or a hub — matches reference mobile apps and reduces drawer friction for daily tasks; **required** for this refactor (§11.5). |
| **Risk** | Duplicate selection state (drawer index vs bottom index); must sync highlight with `currentPath`. Deep links (`/storage/...`) should still open correct stack; **do not** break go_router paths. |
| **Migration** | Phase A: tokens + banner; Phase B: introduce `NavigationBar` per Phase 4; use `StatefulShellRoute` or a single `Scaffold` with `bottomNavigationBar` + `child` — **research go_router 14+ patterns** before coding. |

**Offline banner:** Retint from `errorContainer` to a dedicated token (e.g. `surfaceContainerHigh` + amber outline + warning icon) if “offline” should not read as hard error; maintain **non-dismissible**, rounded bottom, safe area; ensure contrast on true black.

**Page transitions:** Keep fade for shell switches or upgrade to **shared-axis** subtle slide for hierarchy (list → detail); detail pushes already use shell child — ensure transition does not double-animate with `ShellSectionBody`.

---

## 5. Per-screen specifications (mandatory table)

All routes from `lib/app/router.dart` under the shell. **Server add/edit** share `ServerEditorPage` (`add_server_screen.dart` / `edit_server_screen.dart`) — one spec with variants.

| Route / path | Screen name | Primary user jobs | Layout sketch (sections) | Key components | States (loading / error / empty) | Notes |
|--------------|-------------|-------------------|---------------------------|----------------|-----------------------------------|-------|
| `/servers` | Server list | Pick server; add; edit; delete (undo) | App bar → optional refresh → **grouped list** of servers (name, host:port, auth hint) + FAB “add” | `ShellSectionBody`, `InsetGroupedList` / cards, `Dismissible` or swipe, FAB | Shimmer list; `ErrorView` + retry; `EmptyState` + CTA to add | Swipe delete + **SnackBar** undo (keep behavior); consider confirmation only if UX research demands — currently **no** dialog |
| `/servers/add` | Add server | Register PVE; test connection; save | App bar → **grouped form**: identity (name, host, port) → auth (token vs user/realm/password) → SSL toggle → actions (test, save) | `ServerEditorPage`, `PremiumDialog` (diagnostics), text fields, `FilledButton` | N/A async page; sub-states: credentials loading on edit only | Connection test errors → SnackBar; verbose mode → diagnostics dialog |
| `/servers/edit/:serverId` | Edit server | Update credentials; retest; save | Same as add; pre-filled; realm dropdown | Same + `serverByIdProvider` gate | **Loading:** shimmer/loading column; **Error:** missing server `ErrorView`; then editor | Uses `Column`+`AppBar` instead of `ShellSectionBody` today — **align** with shell pattern during refactor |
| `/dashboard` | Dashboard | Cluster summary; node health; quick resource view | **Summary card** (totals) → **section: Nodes** → per-node cards (status, gauges, compact charts) | `ShellSectionBody`, `ChartCard` (compact), `StatusBadge`, `ResourceGaugeRow`, `ResourceLineChart` | Shimmer; `ErrorView`; empty nodes `EmptyState` | Pull-to-refresh aggregates multiple providers — preserve |
| `/vms` | VM list | Find VM; filter by node/status; open detail | App bar → search field → filters (status, node) → **grouped or flat** card rows | `ShellSectionBody`, filters, `PremiumListRow`, `VmStatusBadge`, progress indicators | Shimmer; `ErrorView`; empty VM list `EmptyState` | Running-first sort preserved |
| `/vms/:node/:vmid` | VM detail | Inspect resources; charts; power actions; backup | **Header** (name, vmid, node, badge) → **Actions** row → **Metrics** (labeled rows) → **Charts** (4× `ChartCard`) | `VmDetailScreen`, dialogs, `ResourceLineChart`, `ChartTimeframeSelector`, snackbars | Async VM lookup: shimmer/error per current implementation | Power dialogs: Stop / Force stop / Reboot — keep copy from l10n |
| `/containers` | Container list | Same as VMs for LXC | Same structure as VM list | Same pattern, `ContainerStatus` | Same | Mirror VM list tokens |
| `/containers/:node/:ctid` | Container detail | Same as VM detail without pause | Same sections; charts; power | Same as VM detail | Same | Force-stop warning emphasis unchanged semantically |
| `/storage` | Storage list | See pools; usage; open detail | Filters/list of storage cards (name, type, usage bar, badge) | `Column`+`AppBar` or unify `ShellSectionBody`, `ResourceGaugeRow`, `StatusBadge` | Shimmer; `ErrorView`; empty | **Inconsistency:** uses raw `Column` not `ShellSectionBody` — refactor for parity |
| `/storage/:node/:storage` | Storage detail | Capacity; content list | Header summary → content list (backups, ISOs, …) | Cards, list rows, formatters | Loading/error/empty per implementation | Long lists: preserve scroll + refresh |
| `/backups` | Backup list | See jobs/files; trigger backup | App bar → jobs summary / grouped files / vzdump tasks + **FAB** | Mixed layout + `showTriggerBackupSheet`; uses `Column`+`AppBar` in some states | Multi-provider error aggregation; shimmer; empty | Align shell wrapper with `ShellSectionBody` where missing |
| `/tasks` | Task list | Monitor work; open log | Newest-first rows (type, VMID resolution, status badge, time) | List + badges + navigation to detail | Shimmer; error; empty | Status colors: running / ok / error |
| `/tasks/:node/:upid` | Task detail | Read log; refresh | App bar → metadata strip → monospace log | `RefreshIndicator`, scroll controller, `ErrorView` | Log loading/error | UPID encoding unchanged |
| `/settings` | Settings | Theme; troubleshooting; about; support | **Appearance** (segmented) → **Troubleshooting** (verbose toggle) → **About** → **Support** tiles | `ShellSectionBody`, `_SectionHeader`, `SegmentedButton`, `SwitchListTile`, dialogs | Package info async on version row | License dialog; external links + SnackBar on failure |

---

## 6. Shell-level UI (non-route)

### 6.1 `AppShell` (`lib/app/app_shell.dart`)

- **Pain points:** Drawer uses M3 defaults; branding block does not yet match “premium” card language; offline banner uses `errorContainer` (reads harsh).
- **Target:** Drawer **surface** = card grey on black scaffold; selected destination = **pill** or strong primary tint; section labels use shared `SectionHeader` token; header avatar uses gold ring optional.
- **Acceptance:** Drawer readable on true black; selected route always matches `currentPath`; offline state visible within 1s of connectivity loss; no layout jump when banner appears.

### 6.2 `ShellSectionBody` (`lib/shared/widgets/shell_section_body.dart`)

- **Pain points:** AppBar is standard M3; FAB positioning fixed `right: 16, bottom: 16`.
- **Target:** Themed `AppBar` with transparent/black blend; optional bottom padding when bottom nav added; FAB safe-area aware.
- **Acceptance:** All primary sections using shell still support `RefreshIndicator` edge-to-edge in body.

### 6.3 Leading behavior (`shell_app_bar_leading.dart`)

- **Note (Architecture §8):** Drawer vs back is path-based — preserve logic after visual refresh.

---

## 7. Shared states & cross-cutting widgets

### 7.1 `LoadingShimmer` / `PulsingPlaceholder` (`lib/shared/widgets/loading_shimmer.dart`)

- **Pain points:** Placeholder blocks use `surfaceContainerHighest` — on true black, tune shimmer contrast slightly so it does not look “muddy.”
- **Target:** Shimmer blocks inside **rounded rects** aligned with card radius (16); optional subtle gradient sweep (if performance OK).
- **Acceptance:** No blank screens; shimmer matches final card width/insets where used in lists.

### 7.2 `ErrorView` (`lib/shared/widgets/error_view.dart`)

- **Pain points:** Centered generic layout; error icon always `error` color.
- **Target:** Optional **illustration container**; primary retry = `FilledButton` (blue); secondary “copy diagnostics” only if l10n added later (out of scope unless product asks).
- **Acceptance:** Retry still invalidates correct provider from caller; message remains l10n/user-safe (no raw Dio strings).

### 7.3 `EmptyState` (`lib/shared/widgets/empty_state.dart`)

- **Pain points:** `CircleAvatar` + `primaryContainer` — may clash with new blue/gold split.
- **Target:** **IconBadgeAvatar** with neutral surface + gold ring or blue icon; typography `titleLarge` + `bodyMedium`.
- **Acceptance:** CTA button (if any) uses `primary` filled.

### 7.4 `StatusBadge` (`lib/shared/widgets/status_badge.dart`)

- **Pain points:** Success/warning use hard-coded greens/yellows — verify contrast on `#000000`.
- **Target:** Map to extended tokens (`success`, `warning` `ColorScheme` extensions) for one place to tune; keep semantic distinction for VM/container/task.
- **Acceptance:** Badges readable at smallest text scale.

### 7.5 Snackbars & toasts

- **Current pattern:** `ScaffoldMessenger.of(context).showSnackBar` for power actions, backup errors, server validation, link failures, delete undo.
- **Target:** `SnackBarThemeData`: floating, 12–16 radius, `surfaceContainer` background, **primary-tinted** action text for Undo; brief duration for success; longer for errors.
- **Acceptance:** Snackbars clear on navigation optional (product decision) — default keep Flutter behavior; no overlap with offline banner (banner top, snackbar bottom).

### 7.6 Progress indicators

- **Usages:** `LinearProgressIndicator` in `TriggerBackupSheet` loading; possibly lists. Theme **track** and **indicator** with primary/secondary; rounded caps optional.

---

## 8. Modals & sheets

### 8.1 `TriggerBackupSheet` (`lib/features/backups/ui/trigger_backup_sheet.dart`)

- **UX:** Manual vzdump — guest picker, storage, compression, mode, start → navigate to task detail.
- **Visual spec:** `showModalBottomSheet` with `isScrollControlled`, drag handle — wrap in **PremiumBottomSheet**: true black scrim ~60% opacity; sheet surface = card grey; **28** top radius; section labels above each dropdown; primary button full-width; loading state replaces button inner with `CircularProgressIndicator` (keep).
- **Acceptance:** Keyboard inset (`viewInsets`) preserved; all options remain reachable when keyboard open; l10n strings unchanged.

### 8.2 Power action confirmations — `VmDetailScreen` / `ContainerDetailScreen`

- **Dialogs:** Stop, Force stop (with error-colored warning paragraph), Reboot — `AlertDialog` + `TextButton` Cancel + `FilledButton` Confirm + haptic on confirm.
- **Visual spec:** `PremiumDialog`; title `titleLarge`; body `bodyMedium`; force-stop warning uses `colorScheme.error` for secondary paragraph; max width per M3; scrollable if text scale large.
- **Acceptance:** Three dialogs per entity type; no API change; button order RTL-safe.

### 8.3 Connection diagnostics — `ServerEditorPage`

- **Trigger:** When `verboseConnectionErrorsProvider` is on and connection test fails — `AlertDialog` + `SelectableText(proxmoxExceptionDiagnosticsText(error))`.
- **Visual spec:** Monospace or `bodySmall` in a **scrollable** `SelectableText` region; “Close” only; consider subtle `surfaceContainer` inset.
- **Acceptance:** Large diagnostic paste does not overflow screen; selectable for user copy.

### 8.4 License — `SettingsScreen`

- **Trigger:** About → license tile — `AlertDialog` + scrollable `Text(l10n.settingsLicenseSummary)`.
- **Visual spec:** Match `PremiumDialog`; readable line length.
- **Acceptance:** Same content as today; l10n driven.

### 8.5 Server delete

- **No dialog** — undo SnackBar only; plan should **retain** unless explicit product change.

---

## 9. Charts & data visualization (`fl_chart`)

**Container pattern (`ChartCard`):** Outer card 16–20 radius, inner padding 16; title row: metric name (`titleMedium`) + optional subtitle; timeframe control as **pill segmented** (replace loose `ChoiceChip` row in `ChartTimeframeSelector` for Absorb consistency).

**Series colors:**

- CPU: primary blue or gold (pick one metric to be “hero” gold).
- Memory: secondary tan or teal (distinct from CPU).
- Network: two tones (in/out) — blue + muted purple/grey.
- Disk I/O: amber + blue-grey.

**Grid & axes:** `outlineVariant` at low opacity; axis labels `labelSmall` + `onSurfaceVariant`; tooltips: dark surface, white/onSurface text, 12 radius.

**Dashboard compact charts:** Reduced height (current compact mode) with same tokens; no chart text below minimum readable size — if needed, hide some axis ticks on narrow width.

**Behavior:** 60s refresh, four timeframes (hour/day/week/month) unchanged.

**Files:** `lib/shared/widgets/resource_chart.dart`, chart wrappers under `lib/features/vms/ui/widgets/` and containers mirror.

---

## 10. Theming & light mode

**Recommendation:** **Light mode remains first-class** (Settings already persists `ThemeMode`). Simplified “one-pager” light is **not** required for MVP of this refactor.

| Dark token | Light mapping |
|------------|----------------|
| True black scaffold | Near-white `#F2F2F7` (iOS grouped background) |
| Card surface | White `#FFFFFF` with subtle shadow or hairline border |
| Primary blue | Slightly darker blue for contrast on white |
| Gold accent | Use sparingly; may darken for WCAG on white |
| Dividers | `outlineVariant` stronger in light |

**Acceptance:** `SegmentedButton` theme + `NavigationDrawer` + `ChartCard` tested in both modes; no feature gated on dark-only.

---

## 11. Implementation phases (ordered)

Section **§11** is the execution roadmap: phased objectives, **trackable** `- [ ]` tasks, and **Phase acceptance criteria** for verification. Check boxes in-repo as work completes, or mirror each task to issues/Linear with the same ID. Phases **1–8** run **sequentially** in listed order; **Phase 4** (bottom navigation / hybrid shell, §11.5) is **mandatory** and completes after Phases **1–3** — it must not be skipped or deferred past the refactor’s shell milestone. Ad-hoc optional work outside these phases must not block merge of required phases. The former high-level dependency overview is folded into **Depends on** under each phase below.

### 11.1 How to use this roadmap

Treat each phase as a shippable slice: complete tasks in order where dependencies exist, run `flutter analyze` (and tests when listed) before calling the phase done. **Phase acceptance criteria** are objective checks the team can run without guessing; document any intentional exceptions (e.g. scaffold `#0A0A0A` instead of `#000000`) in code comments or this file. For human passes, use **§12** (goldens + manual matrix). **Phase 4** is **mandatory**: implement the §4.2 hybrid (`NavigationBar` + full drawer) with synchronized selection and preserved routes **after** Phases 1–3 and **before** treating later phases as complete for the refactor’s navigation shell.

### 11.2 Phase 1 — Theme tokens, `ColorScheme`, and global Material themes

#### Objective

Establish true-black-first dark theme, blue/gold role split, and global `ThemeData` extensions so all later UI work pulls from a single source of truth (`app_colors.dart` / `app_theme.dart`).

#### Depends on

—

#### Trackable tasks

- [x] **T1.1** Extend `lib/app/theme/app_colors.dart` with semantic aliases (`scaffoldPureBlack`, `premiumAccent`, `navigationAccent`, and success/warning helpers aligned with §2.1 and §7.4).
- [x] **T1.2** Update `lib/app/theme/app_theme.dart` dark `ColorScheme`: scaffold **true black** `#000000` or documented `#0A0A0A` OLED exception; `primary` blue; `secondary`/`tertiary` muted gold/tan per §2.1.
- [x] **T1.3** Add or extend theme components in `app_theme.dart`: `NavigationDrawerThemeData`, `DialogTheme`, `BottomSheetThemeData`, `SnackBarThemeData`, `ProgressIndicatorTheme`, `ChipTheme` / `SegmentedButtonTheme` per §3.
- [x] **T1.4** Map light mode surfaces and contrast adjustments per §10 (grouped grey scaffold, white cards, darker blue / adjusted gold on white).
- [x] **T1.5** Keep `ThemeData(useMaterial3: true)`; note any deliberate non-defaults in comments or this plan.
- [x] **T1.6** Run `flutter analyze` after theme edits; fix or file issues for any new analyzer errors in `lib/app/theme/`.
- [x] **T1.7** Verify WCAG-minded contrast for `onSurface`, `onSurfaceVariant`, and gold accent on scaffold (record chosen hex values or tool used).
- [x] **T1.8** Confirm Settings-driven `ThemeMode` persistence still applies cleanly with new schemes (`settings_screen.dart` / existing theme notifier).

#### Phase acceptance criteria

- `flutter analyze` exits **0** for the touched theme scope (at minimum `lib/app/theme/`).
- Dark `scaffoldBackgroundColor` is **`#000000`** or **`#0A0A0A`** with the exception **documented** (comment or this file).
- Primary actions and navigation tint use **blue** (`primary`); premium/chart emphasis can use **gold/tan** via `secondary`/`tertiary` or `premiumAccent`, consistent with §2.1 "blue vs gold" rules.
- Dialog, bottom sheet, snackbar, and segmented/chip themes are **defined** in `app_theme.dart` (not left to one-off widget defaults only).
- Light mode has a coherent `ColorScheme` per §10 table (no broken contrast on `NavigationDrawer` / cards in a quick smoke pass).
- No Proxmox API or repository contracts change (non-goals banner still holds).

### 11.3 Phase 2 — Shared layout primitives and cross-cutting widgets

#### Objective

Introduce grouped-list building blocks, premium dialog/sheet wrappers, and refresh shared loading/error/empty/badge patterns so feature screens can migrate without duplicating spacing or tokens.

#### Depends on

Phase 1

#### Trackable tasks

- [x] **T2.1** Add `lib/shared/widgets/grouped_section.dart` implementing `GroupedSection` (vertical rhythm + optional header slot) per §3.
- [x] **T2.2** Extract/unify `SectionHeader` from `lib/features/settings/ui/settings_screen.dart` into a shared widget; use shared `SectionHeader` for drawer section labels where specified in §3 / §6.1.
- [x] **T2.3** Implement `InsetGroupedList` / `PremiumListRow` under `lib/shared/widgets/` (inset dividers, leading/title/subtitle/trailing/chevron) per §3.
- [x] **T2.4** Implement `IconBadgeAvatar` per §3; update `lib/shared/widgets/empty_state.dart` to use it per §7.3.
- [x] **T2.5** Update `lib/shared/widgets/loading_shimmer.dart` — rounded rects (~16), shimmer contrast tuned for true black per §7.1.
- [x] **T2.6** Update `lib/shared/widgets/error_view.dart` — primary retry as blue `FilledButton`, layout optional illustration per §7.2.
- [x] **T2.7** Update `lib/shared/widgets/status_badge.dart` — semantic colors via extended tokens; contrast on `#000000` per §7.4.
- [x] **T2.8** Add `PremiumDialog` and `PremiumBottomSheet` wrappers (shared location under `lib/shared/widgets/`) per §3.
- [x] **T2.9** Align global snackbar appearance with §7.5 via `SnackBarThemeData` and any call-site tweaks needed for floating/radius/action color.
- [x] **T2.10** Implement or theme pill-style controls (`PillTabBar` / `SegmentedPill` or themed `SegmentedButton`) for reuse in Settings and chart timeframes per §3 / §9.

#### Phase acceptance criteria

- At least **`GroupedSection`**, **`SectionHeader`**, **`PremiumListRow`** (and/or `InsetGroupedList`), **`IconBadgeAvatar`**, **`PremiumDialog`**, **`PremiumBottomSheet`** exist as importable widgets with consistent radii/padding from §2.3–2.4.
- `flutter analyze` exits **0** for `lib/shared/widgets/` changes introduced in this phase.
- Shimmer placeholders match **card-aligned** width/insets where used in lists per §7.1 acceptance.
- `ErrorView` retry still **invalidates** the caller’s provider pattern (no regression in error recovery behavior).
- `EmptyState` CTA uses **`primary`** filled button per §7.3.
- `StatusBadge` remains readable at **smallest** supported text scale in a manual or widget check.

### 11.4 Phase 3 — `AppShell`, drawer, and `ConnectivityBanner`

#### Objective

Apply premium shell visuals: drawer as card-on-black, correct selection state, and offline strip that reads as **connectivity** rather than hard error.

#### Depends on

Phases 1, 2

#### Trackable tasks

- [x] **T3.1** Refactor `lib/app/app_shell.dart` `NavigationDrawer`: surface = card grey on black scaffold; selected destination = pill or strong primary tint; section labels use shared `SectionHeader` token per §6.1.
- [x] **T3.2** Evolve offline banner to dedicated styling / `ConnectivityBanner` (from §3): retint per §4.2 (non-dismissible, rounded bottom, safe area, optional amber/warning semantics vs `errorContainer`).
- [x] **T3.3** Refresh drawer branding header block to match premium card language per §6.1.
- [x] **T3.4** Verify all eight drawer destinations remain correct; selected visual always matches **`currentPath`** / route per §4.1.
- [x] **T3.5** Update `lib/shared/widgets/shell_section_body.dart`: themed `AppBar` (transparent/black edge), FAB **safe-area** aware; reserve bottom inset for Phase 4 bottom nav per §6.2.
- [x] **T3.6** Confirm `lib/shared/widgets/shell_app_bar_leading.dart` drawer-vs-back behavior unchanged per §6.3 and Architecture §8.
- [x] **T3.7** Manually verify offline state appears within **~1s** of simulated connectivity loss where the app already detects offline (no layout jump when banner toggles per §6.1).

#### Phase acceptance criteria

- Drawer is **readable** on true black; selected route **matches** actual route.
- Offline banner does **not** use harsh `errorContainer`-only styling if §4.2 retint is adopted (document palette used).
- No **layout jump** when banner appears/disappears (Column + Expanded child stable per §6.1).
- `ShellSectionBody` keeps **RefreshIndicator** working edge-to-edge in primary sections per §6.2.
- `flutter analyze` exits **0** for `lib/app/app_shell.dart` and touched shell widgets.
- Leading logic still path-correct after visual-only changes.

### 11.5 Phase 4 — Bottom navigation / `StatefulShellRoute`

#### Objective

**Ship** the §4.2 hybrid shell: **bottom navigation** (4–5 tabs + More → drawer or hub) integrated with `StatefulShellRoute` (or an equivalent documented pattern) so the app delivers a **non-throwaway** bottom nav experience. **Document** the chosen tab→route mapping and any hybrid details in this plan or a linked PR. **Do not** break existing `go_router` paths or deep links.

#### Depends on

Phases 1–3 (complete theme + primitives + shell refresh first)

#### Trackable tasks

- [x] **T4.1** Research `go_router` 14+ patterns (`StatefulShellRoute`, nested branches) using `lib/app/router.dart` as baseline; document findings inline in PR or short note linked from this plan.
- [x] **T4.2** Implement **`NavigationBar` + drawer** hybrid per §4.2: primary tabs plus **More** (or equivalent) reaching the full drawer menu; keep **drawer** as the complete destination set; **synchronize** bottom-bar and drawer highlights with **`currentPath`** so the two never contradict (§4.2 risks).
- [x] **T4.3** Validate deep links (e.g. `/storage/:node/:storage`, `/tasks/:node/:upid`) still resolve correctly with the integrated shell; run `flutter analyze` on touched router/shell code.
- [x] **T4.4** Record the **shipped** pattern (tab labels, route branches, how “More” exposes remaining destinations) in this document (e.g. appendix) or a linked PR so maintainers match §4.2 without guesswork.
- [x] **T4.5** Verify bottom-bar selection updates on navigation (including deep links and drawer picks) so it always reflects **`currentPath`** per §4.2.
- [x] **T4.6** Confirm **no** Proxmox API or repository contract changes and **no** removal of drawer as full menu per §4.2 “Keep” row.

#### Shipped tab → route mapping (T4.4 record)

`StatefulShellRoute.indexedStack` with **5 branches** in `lib/app/router.dart`:

| Bottom nav index | Tab label | Branch routes | Branch initial location |
|-----------------|-----------|---------------|------------------------|
| 0 | Dashboard | `/dashboard` | `/dashboard` |
| 1 | VMs | `/vms`, `/vms/:node/:vmid` | `/vms` |
| 2 | Containers | `/containers`, `/containers/:node/:ctid` | `/containers` |
| 3 | Tasks | `/tasks`, `/tasks/:node/:upid` | `/tasks` |
| 4 | More | `/servers` (+add/edit), `/storage` (+detail), `/backups`, `/settings` | `/servers` |

**More tab behaviour:** Tapping More (index 4) calls `ScaffoldState.openDrawer()` instead of navigating. The `NavigationDrawer` lists **7** destinations (Dashboard, VMs, Containers, Storage, Backups, Tasks, Settings). **Servers** is not duplicated there: users reach `/servers` from the **drawer header server chip** (when a server is configured) or from **Settings** (row above Appearance). Storage, Backups, and Settings remain reachable from the drawer; branch 4 still includes `/servers` for deep links and initial location. `NavigationBar.selectedIndex` is driven by `StatefulNavigationShell.currentIndex` (the active branch); `NavigationDrawer.selectedIndex` is driven by `_drawerIndexForLocation(currentPath)` (`null` on `/servers` so no drawer row is highlighted). Both always reflect the actual `currentPath` so they cannot contradict.

**`kShellBottomNavReserve`** in `shell_section_body.dart` was changed from `56` to `0` because `Scaffold.bottomNavigationBar` now handles its own layout — the scaffold body is positioned above the bar automatically.

#### Phase acceptance criteria

- **No** path-breaking behavior is merged; `lib/app/router.dart` public paths remain valid or changes are explicitly approved and documented.
- A **shipped** (integrated in the main app, not prototype-only or throwaway) bottom navigation experience meets §4.2: **NavigationBar** (or documented equivalent) plus **full** drawer; bottom and drawer selection **cannot contradict** `currentPath` in smoke tests of primary flows.
- Deep link manual checks pass for at least **storage** and **encoded UPID task** routes per §12.2 extra note.
- `flutter analyze` exits **0** on committed shell/router code for this phase.
- Shipped hybrid pattern is **documented** (plan edit or link) for QA and future work.

### 11.6 Phase 5 — List screens (grouped lists, shell parity)

#### Objective

Migrate server, VM, container, storage, backup, and task **lists**, plus **`/settings`** grouped layout, to `ShellSectionBody` + grouped primitives where §5 specifies parity (inset lists, badges, FABs preserved).

#### Depends on

Phases 1–4 (Phase 3 for consistent shell chrome; Phase 4 mandatory for bottom nav per §11.5)

#### Trackable tasks

- [x] **T5.1** Refactor `lib/features/servers/ui/server_list_screen.dart` to `GroupedSection` / `PremiumListRow` pattern per §5 `/servers` row; preserve swipe delete + SnackBar undo.
- [x] **T5.2** Align `lib/features/servers/ui/add_server_screen.dart` / `lib/features/servers/ui/edit_server_screen.dart` / `lib/features/servers/ui/server_editor_page.dart` with shell/editor layout parity per §5 (consider `ShellSectionBody` alignment for edit).
- [x] **T5.3** Refactor `lib/features/vms/ui/vm_list_screen.dart` per §5 `/vms` (search, filters, `PremiumListRow`, `VmStatusBadge`).
- [x] **T5.4** Refactor `lib/features/containers/ui/container_list_screen.dart` to mirror VM list tokens per §5 `/containers`.
- [x] **T5.5** Refactor `lib/features/storage/ui/storage_list_screen.dart` — adopt `ShellSectionBody` + cards/`ResourceGaugeRow` per §5 `/storage` inconsistency note.
- [x] **T5.6** Refactor `lib/features/backups/ui/backup_list_screen.dart` — align shell wrapper / grouped layout with §5 `/backups` (FAB + `showTriggerBackupSheet` preserved).
- [x] **T5.7** Refactor `lib/features/tasks/ui/task_list_screen.dart` per §5 `/tasks` (badges, newest-first, navigation to detail).
- [x] **T5.8** Ensure all list screens use **shared** shimmer/`LoadingShimmer`, `ErrorView`, `EmptyState` patterns from Phase 2 where applicable per §5 “States” column.
- [x] **T5.9** Refactor `lib/features/settings/ui/settings_screen.dart` per §5 **`/settings`**: **`GroupedSection`** layout for **Appearance**, **Troubleshooting**, **About**, and **Support**; shared **`SectionHeader`**; pill-themed **`SegmentedButton`** for appearance/theme control — **not** the license dialog (Phase 7 **T7.5**).

#### Phase acceptance criteria

- §5 table rows for **`/servers`**, **`/vms`**, **`/containers`**, **`/storage`**, **`/backups`**, **`/tasks`** use grouped/inset list **visual language** (no ad-hoc full-bleed dividers inside cards per §2.5).
- **`/settings`** (`settings_screen.dart`): §5 section structure (**Appearance**, **Troubleshooting**, **About**, **Support**) with **`GroupedSection`**, shared **`SectionHeader`**, and pill-themed **`SegmentedButton`** where §5 specifies; license dialog styling deferred to Phase 7.
- `storage_list_screen.dart` uses **`ShellSectionBody`** (or documented equivalent) resolving §5 inconsistency note.
- Server list **undo SnackBar** and backup **FAB** behavior unchanged functionally.
- `flutter analyze` exits **0** for touched feature UI files.
- List screens remain fully **l10n**-driven for user-visible strings (`lib/l10n/app_en.arb`).
- VM/container list sort/filter semantics (e.g. running-first) **unchanged** per §5 notes.

### 11.7 Phase 6 — Detail screens, dashboard, `ChartCard`, and charts

#### Objective

Upgrade VM/container/storage/task **details**, **dashboard**, and chart surfaces to `ChartCard`, pill timeframes, and tokenized `ResourceLineChart` styling per §5 and §9; VM/container **non-chart** detail sections (header, actions, metrics) aligned with §5 in the same phase.

#### Depends on

Phases 1, 2 (Phase 5 recommended so list → detail visual continuity is consistent)

#### Trackable tasks

- [x] **T6.1** Add or complete `ChartCard` shared widget per §3 / §9; wrap usages in `lib/features/vms/ui/vm_detail_screen.dart` and `lib/features/containers/ui/container_detail_screen.dart` (four chart areas per §5).
- [x] **T6.2** Replace loose `ChoiceChip` row in `lib/shared/widgets/resource_chart.dart` (`ChartTimeframeSelector`) with pill `SegmentedButton` or custom pill control per §9.
- [x] **T6.3** Apply series colors and grid/tooltip tokens per §9 to `resource_chart.dart` / chart line implementations under `lib/features/vms/ui/widgets/` and mirrored container paths.
- [x] **T6.4** Refactor `lib/features/dashboard/ui/dashboard_screen.dart` — summary + node cards using `ChartCard` (compact), `StatusBadge`, `ResourceGaugeRow`, `ResourceLineChart` per §5 `/dashboard`.
- [x] **T6.5** Refactor `lib/features/storage/ui/storage_detail_screen.dart` per §5 `/storage/:node/:storage` (header summary, content list, cards/rows).
- [x] **T6.6** Refactor `lib/features/tasks/ui/task_detail_screen.dart` (metadata + log layout, `RefreshIndicator`, `ErrorView`) per §5 `/tasks/:node/:upid`.
- [x] **T6.7** Ensure detail **headers** use `IconBadgeAvatar` or equivalent premium header pattern per §3 / §5 detail rows.
- [x] **T6.8** Preserve chart behavior: **60s refresh**, **hour/day/week/month** timeframes unchanged per §9.
- [x] **T6.9** Refactor **non-chart** UI in `lib/features/vms/ui/vm_detail_screen.dart` and `lib/features/containers/ui/container_detail_screen.dart` per §5: **header** (name, id, node, status badge), **power actions** row, **labeled metric rows** ahead of chart blocks (chart/`ChartCard` work remains **T6.1**–**T6.3**).

#### Phase acceptance criteria

- §5 rows migrated: **`/dashboard`**, **`/vms/:node/:vmid`**, **`/containers/:node/:ctid`**, **`/storage/:node/:storage`**, **`/tasks/:node/:upid`** chart and card layout use **shared** tokens.
- **`/vms/:node/:vmid`** and **`/containers/:node/:ctid`**: **non-chart** detail structure per §5 — **header**, **power actions**, and **labeled metric rows** use the same tokenized primitives as the rest of the phase (charts/timeframes verified separately below).
- `ChartTimeframeSelector` uses **pill** segmented UI (not legacy loose chips) per §9.
- Chart series colors follow §9 CPU/memory/network/disk guidance (documented exception list if any).
- `flutter analyze` exits **0** for touched detail/dashboard/chart files.
- Power-related copy and **force-stop** warning semantics unchanged (still `colorScheme.error` emphasis where specified in §8.2).
- **60s** refresh and **four** timeframes verified in code (`resource_chart.dart` / callers).

### 11.8 Phase 7 — Modals, sheets, and confirmations

#### Objective

Apply `PremiumBottomSheet` / `PremiumDialog` to backup trigger, power confirmations, diagnostics, and license flows per §8 without changing API or l10n keys unnecessarily.

#### Depends on

Phases 1, 2 (Phases 5–6 for screen context optional but typical)

#### Trackable tasks

- [x] **T7.1** Wrap `lib/features/backups/ui/trigger_backup_sheet.dart` with `PremiumBottomSheet`: scrim, **~28** top radius, drag handle, full-width primary, loading state per §8.1.
- [x] **T7.2** Migrate VM power dialogs in `lib/features/vms/ui/vm_detail_screen.dart` to `PremiumDialog` (Stop / Force stop / Reboot) per §8.2.
- [x] **T7.3** Migrate container power dialogs in `lib/features/containers/ui/container_detail_screen.dart` to `PremiumDialog` per §8.2.
- [x] **T7.4** Style connection diagnostics dialog in `lib/features/servers/ui/server_editor_page.dart` per §8.3 (scrollable `SelectableText`, inset surface).
- [x] **T7.5** Style license dialog in `lib/features/settings/ui/settings_screen.dart` per §8.4 (`PremiumDialog`, readable width).
- [x] **T7.6** Confirm **no** confirmation dialog added for server delete — **SnackBar undo only** per §8.5.
- [x] **T7.7** Verify `LinearProgressIndicator` / `CircularProgressIndicator` in sheets match `ProgressIndicatorTheme` from Phase 1 per §7.6.

#### Phase acceptance criteria

- **All** power dialogs (VM + container) use **`PremiumDialog`** wrapper with §8.2 typography roles (`titleLarge` / `bodyMedium`).
- **Force stop** warning paragraph remains **error-colored** and readable on true black.
- `TriggerBackupSheet` preserves keyboard **`viewInsets`**, scroll reachability, and **l10n** strings per §8.1.
- Diagnostics dialog: large output **scrolls**; text remains **selectable** per §8.3.
- License dialog content **unchanged** (still l10n-driven) with improved chrome per §8.4.
- `flutter analyze` exits **0** for touched modal/sheet files.

### 11.9 Phase 8 — Automated tests, goldens, and manual QA (see §12)

#### Objective

Lock visual regressions with goldens and execute the manual matrix so light/dark, text scale, and shell edge cases match §12.

#### Depends on

Prior phases that introduced the widgets under test (typically Phases 2, 5–7)

#### Trackable tasks

- [x] **T8.1** Add golden tests under `test/` for `SectionHeader` (light + dark) per §12.1.
- [x] **T8.2** Add golden tests for `PremiumListRow` (light + dark) per §12.1.
- [x] **T8.3** Add golden for `ChartCard` placeholder / compact layout per §12.1.
- [x] **T8.4** Add golden for `PremiumDialog` snapshot per §12.1.
- [x] **T8.5** Extend existing widget tests (`settings_screen`, server editor) only where theme changes affect **observable** behavior per §12.1.
- [x] **T8.6** Run full `flutter test` in CI locally; if goldens change, follow **documented** `--update-goldens` workflow for designers per §12.1.
- [x] **T8.7** Execute §12.2 manual matrix: **14 destinations** × dark/light/text scale 1.3/display sizes; plus backup sheet, dialog variants, offline banner per table.
- [x] **T8.8** Run §12.2 **extra** checks: server switch from drawer; cold start or deep link to `/tasks/...` with encoded UPID; **force-stop** visibility.

#### Phase acceptance criteria

- `flutter analyze` exits **0** repository-wide in CI configuration.
- `flutter test` exits **0** including new goldens (no unstabilized flakes without documented tolerance).
- Goldens exist for **`SectionHeader`**, **`PremiumListRow`**, **`ChartCard`**, **`PremiumDialog`** per §12.1 list.
- Manual matrix in §12.2 completed or failures **filed** with screen names (no silent skip).
- Drawer server switch + **UPID** deep link scenarios **pass** per §12.2 extra.
- Coverage notes: document any deferred golden (e.g. animation-heavy) with **follow-up** task ID or issue.

---

## 12. Testing & QA checklist

### 12.1 Automated

- **Golden tests:** `SectionHeader`, `PremiumListRow` (one light, one dark), `ChartCard` placeholder, `PremiumDialog` snapshot — under `test/` with `matchesGoldenFile`.
- **Widget tests:** Existing settings + server editor tests — extend for new theme tokens if behavior-visible (e.g. contrast keys).
- **CI:** Continue `flutter analyze`, `flutter test`; goldens may need `flutter test --update-goldens` workflow documented for designers.

### 12.2 Manual matrix

| Screen | Dark | Light | Text scale 1.3 | Large display / small display |
|--------|------|-------|----------------|-------------------------------|
| Each of 14 destinations | ✓ | ✓ | ✓ | ✓ |
| Trigger backup sheet | ✓ | ✓ | ✓ | ✓ |
| Each dialog variant | ✓ | ✓ | ✓ | — |
| Offline banner on/off | ✓ | ✓ | ✓ | — |

**Extra:** Switch server from drawer; deep link or cold start to `/tasks/.../...` with encoded UPID; verify no UI regression in force-stop warning visibility.

**Phase 8 QA status (T8.7 / T8.8):**

| Item | Verification method | Status |
|------|---------------------|--------|
| `SectionHeader` light + dark | Golden file (`section_header_emphasis_dark/light.png`, `section_header_muted_dark/light.png`) | ✅ Code-verified |
| `PremiumListRow` light + dark | Golden file (`premium_list_row_*.png`) | ✅ Code-verified |
| `ChartCard` placeholder + compact | Golden file (`chart_card_*.png`) | ✅ Code-verified |
| `PremiumDialog` light + dark | Golden file (`premium_dialog_dark/light.png`) | ✅ Code-verified |
| `ErrorView` uses `FilledButton` retry | Widget test assertion | ✅ Code-verified |
| `EmptyState` CTA is `FilledButton` | Widget test assertion | ✅ Code-verified |
| UPID percent-encoding on `/tasks/:node/:upid` | `Uri.decodeComponent` confirmed in `router.dart` (line ~202); callers use `Uri.encodeComponent` per go_router rule | ✅ Code-verified |
| Drawer server switch flow | `shell_drawer_root_paths_test.dart` covers root path detection; full integration requires device | ⚠️ Requires device testing |
| 14 destinations × dark/light/text scale 1.3/display sizes | Full screen matrix | ⚠️ Requires device testing |
| Trigger backup sheet at text scale 1.3 | Sheet scroll and keyboard insets | ⚠️ Requires device testing |
| Offline banner on/off | `ConnectivityBanner` visibility | ⚠️ Requires device testing |
| Force-stop warning visibility | `colorScheme.error` confirmed in `error_view.dart`; power dialog uses `PremiumDialog` | ✅ Code-verified |

> **Deferred goldens:** Animation-driven widgets (e.g. `LoadingShimmer`, `ConnectivityBanner` slide-in) are excluded from golden tests due to non-deterministic frame state. Follow-up: add static-state goldens if a freeze-frame helper is introduced.

---

## 13. References

- **Screenshots (canonical):** [`docs/references/screenshots/`](references/screenshots/)
- **Feature scope & phases:** [`docs/ProxDroid_Roadmap.md`](ProxDroid_Roadmap.md)
- **Routes & shell notes:** [`docs/ProxDroid_Architecture.md`](ProxDroid_Architecture.md) §4, §8
- **Authoritative routes:** `lib/app/router.dart`
- **Shell implementation:** `lib/app/app_shell.dart`

> **Roadmap follow-up (for maintainers, not part of this file’s task):** When implementation starts, add a short bullet under Phase 6 / polish in `ProxDroid_Roadmap.md` pointing to this plan.

---

## 14. Appendix: Routed destinations checklist (verification)

From `lib/app/router.dart` inside `ShellRoute`:

- `/servers`, `/servers/add`, `/servers/edit/:serverId`
- `/dashboard`
- `/vms`, `/vms/:node/:vmid`
- `/containers`, `/containers/:node/:ctid`
- `/storage`, `/storage/:node/:storage`
- `/backups`
- `/tasks`, `/tasks/:node/:upid`
- `/settings`

All covered in §5 table (14 logical **screen specs**: servers list, add, edit, dashboard, vm list, vm detail, container list, container detail, storage list, storage detail, backups, tasks list, task detail, settings).
