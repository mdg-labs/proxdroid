# UI refactor plan: Stitch “Obsidian Command Center” alignment

**Goal:** Preserve **routes, navigation graph, Riverpod/data layer, repositories, and user-visible copy** unless a layout change forces an `app_en.arb` tweak. Refactor **layout, visual hierarchy, typography, color tokens, and reusable chrome** to match the Google Stitch reference under `docs/references/stitch/stitch/`, led by `obsidian_flux/DESIGN.md` and the three `code.html` + `screen.png` pairs.

**Navigation (explicit):** **Do not change** the product’s information architecture: **same** bottom-nav destinations and order (Dashboard · VMs · Containers · Tasks · More), **same** drawer entries and paths, **same** `go_router` branches and redirects. Stitch HTML shows a **different** tab set (e.g. Storage, Nodes on the bar); treat that as **visual inspiration only**. Work on this plan is limited to **design tokens**, **screen layout / component placement** inside existing routes, and **styling** of the existing `NavigationBar` / `NavigationDrawer` (colors, blur, pills, typography)—not adding, removing, or reordering destinations.

**Canonical references (read-only):**

| Path | Use |
| --- | --- |
| `docs/references/stitch/stitch/obsidian_flux/DESIGN.md` | Rules: no-line surfaces, glass/gradient, typography roles, do/don’t |
| `.../proxdroid_dashboard/code.html` | Dashboard: fixed header, summary tiles, cluster chart, node cards, bottom nav, FAB |
| `.../vm_detail_ubuntu_web_server/code.html` | Guest detail: sticky header, power strip, timeframe pills, 2×2 metrics, bento KV, gauge panel |
| `.../storage_overview/code.html` | Storage: hero metrics, pool cards, distribution bars, bottom nav |
| `*/screen.png` | Pixel pass: spacing, weight, icon scale |

**Stitch HTML vs our app (context only — we do not adopt prototype nav):** The static prototypes use a **different** bottom bar (e.g. Storage + Nodes on the bar, fewer items). ProxDroid **keeps** its current chrome: Dashboard · VMs · Containers · Tasks · **More**, with Storage / Backups / Tasks / Settings / server access via the **drawer** as today. When HTML shows “bottom nav,” reuse **look** (frosted bar, active pill, label treatment), not **tab count or labels**.

**Policy:** Do **not** delete features or routes. Do **not** change navigation structure (see **Navigation (explicit)** above). Refactor scope = **design + in-screen layout** only.

---

## 1. Canonical design tokens (implement in `AppColors` / `ColorScheme`)

Values below are the **Stitch HTML + DESIGN.md** targets. Dark theme is in scope first; light theme is a **explicit branch** (defer or rebuild—see Phase A).

| Token role | Hex | Notes |
| --- | --- | --- |
| Canvas / `scaffold` / `surface` (base) | `#0c0e17` | Replaces OLED `#000000` as default canvas unless contrast study keeps black for OLED |
| `surface_container_low` | `#11131d` | Summary tiles, recessed strips |
| `surface_container` | `#171924` | Primary cards, chart shells |
| `surface_container_high` | `#1c1f2b` | Bento row / nested modules |
| `surface_container_highest` / chart wells | `#222532` | DESIGN lists `surface_variant` `#222532` — align naming with `ColorScheme` |
| `surface_bright` (elevated hover) | `#282b3a` | Pool row hover in HTML |
| `on_surface` | `#f0f0fd` | Headlines / primary text |
| `on_surface_variant` | `#aaaab7` | Body secondary, micro-labels |
| `primary` | `#81ecff` | CTAs, online, CPU accent |
| `primary_container` | `#00e3fd` | Gradient end, filled chip selected |
| `on_primary` | `#005762` | Text on solid primary (per HTML) |
| `on_primary_container` | `#004d57` | Selected pill label on primary fill |
| `secondary` | `#7e98ff` | RAM / network series, secondary emphasis |
| `tertiary` | `#fab0ff` | Warning path (DESIGN: “sophisticated alternative to orange”) |
| `error` | `#ff716c` | Critical / destructive emphasis |
| `outline_variant` | `#464752` | Ghost border @ ~15% opacity when required |

**Gradients:** Primary CTA / hero fills: `primary` → `primary_container`. Ambient float shadow: `Y=8`, blur `24`, `rgba(0,0,0,0.4)` (DESIGN §4).

**Typography:** **Space Grotesk** — display/headline/metrics. **Inter** — body, labels, dense tables. Map to Flutter `textTheme`: `displayMedium`/`headlineSmall` for big numbers, `labelSmall` for IP/MAC/uptime (DESIGN §3).

**Rules to enforce in code review:** No **1px solid box borders** between sections; prefer surface shift + spacing + optional ghost outline. No **pure white** body copy—use `on_surface_variant` where HTML does.

### 1A. Cross-check — main differences (current app ↔ Stitch)

This table is the **delta summary** between today’s shipped UI (`lib/app/theme/*`, `app_shell.dart`, feature screens) and the three Stitch HTML screens + `DESIGN.md`. Use it during visual QA (“does this row still describe us?”).

| Area | Current ProxDroid (today) | Stitch prototype | Refactor intent |
| --- | --- | --- | --- |
| **Navigation chrome (not IA)** | Five destinations + More → drawer; fixed route map | Prototype shows four different tabs | **No change** to destinations, order, or `router`/`AppShell` branch wiring. Apply Stitch **visual** language only (colors, blur, pill selection, typography) to the **existing** `NavigationBar` and `NavigationDrawer`. |
| **Canvas / background** | OLED-style **true black** scaffold (`#000000`) + dark grey cards | **Obsidian** base `#0c0e17`, layered slightly lighter surfaces | Move scaffold + surfaces toward §1 table; decide OLED vs obsidian per risk register. |
| **Primary accent** | iOS-style blue (`#0A84FF` / `navigationAccent`) | Electric cyan `#81ecff` + saturated container `#00e3fd` | Recolor `ColorScheme.primary` / charts / selection; audit every `navigationAccent` / `darkPrimary` use. |
| **Secondary / “premium”** | **Gold** (`premiumAccent`, secondary) for premium/drawer ring, memory series conflated with gold story | **Periwinkle** `#7e98ff` for secondary data (e.g. RAM, network in HTML) | Decouple “premium marketing gold” from chart secondary; map memory/network to Stitch secondary unless brand overrides. |
| **Tertiary / warning** | Amber/yellow status pairings in places | **Magenta** `#fab0ff` as “warning” sophistication | Remap warning **UI** (not necessarily semantic meaning) per DESIGN.md. |
| **Online / success** | **Green** success palette for running/online (`darkStatusSuccess*`) | **Cyan primary** dot + soft glow (“connected”, online) | Shift “running/online” **chrome** toward primary + glow; keep distinct **success** for true success copy if needed. |
| **Typography** | Default Material / system (no Space Grotesk / Inter in theme) | **Space Grotesk** headlines & big metrics; **Inter** dense UI | Add font families to `ThemeData`; tune `textTheme` weights/sizes. |
| **Icons** | `Icons.*` (Material rounded/outlined) | Material **Symbols** outlined (web CDN) | Optional: unify style; not required for parity if `Icons` kept with similar metaphors. |
| **Top chrome** | `ShellSectionBody` → centered **section** `AppBar` (e.g. “Dashboard”) | **Brand-forward** header: dns icon, **PROXDROID** wordmark, **Connected (host)** pill, sensors icon | Optional second row or redesigned `AppBar`: server context + denser tech aesthetic. |
| **Bottom chrome** | `NavigationBar`: opaque scaffold bg, thin outline top, M3 indicator | **Frosted** (`backdrop-blur`), stronger top hairline, diffuse **upward** shadow, **rounded** active pill with `primary/10` fill | `NavigationBarTheme` + custom `NavigationBar` or wrapper with `BackdropFilter` / solid fallback. |
| **Card & section borders** | Frequent **`Border.all`**, `VerticalDivider` / `Divider` in cards (e.g. `_ClusterOverviewCard`, `_NodeCard`, `_MetricGrid`, `_StatCell` row) | **No-line rule**: separation by **surface tier** + spacing; hairlines at most `white/5` scale | Remove heavy outlines; replace stat/grid separators with gap or tonal inset. |
| **Cluster / dashboard layout** | **One** large gradient **cluster overview** card (bordered) with **inline** 3-column stats (total VMs / running / containers) + nodes-online pill; **vertical list** of node cards | **Three** separate **summary tiles**; **dedicated** wide **cluster CPU & RAM** chart card; node section title + **grid** of simpler node cards | Restructure `dashboard_screen.dart`: split overview into tiles + add **cluster-level** CPU/RAM chart (implement via **aggregated/composed** node RRD data or a dedicated API path—**no fabricated** time series; label honestly if only partial cluster). |
| **Per-node cards** | Rich card: icon in **green/grey** tile, `StatusBadge`, **two** `ResourceGaugeRow`s, **divider**, **embedded** CPU+memory `ChartCard` sparklines when online | Slimmer card: **left accent** bar (primary vs tertiary warning), icon in neutral well, **uptime** top-right, **only** thin CPU + RAM bars (no embedded fl_chart in prototype) | Align density: accent strip + micro bars first; keep sparklines only if they fit Obsidian density or move behind “expand”. |
| **VM / LXC detail — title** | `AppBar` title is **generic** entity label; guest name lives in **hero** card | **Guest name** is the **AppBar** title; one-line **status • node • ID** under it | Move primary identification to `AppBar`; shrink or remove redundant hero. |
| **VM / LXC detail — metrics** | `_MetricGrid`: **six text metrics** (2-column grid with **vertical**/**horizontal** dividers) | **2×2** “instrument” tiles: **large numeric** + **spark** strip per tile (CPU, Memory, Network, Disk) | Replace text grid with four visual metric modules; keep same underlying data providers. |
| **VM / LXC detail — charts** | Separate `ChartCard` + `fl_chart` **below** metrics for time series | Timeframe **pills** then same metric family; HTML uses **bar spark** aesthetic in tiles | Align timeframe control styling; restyle `ChartCard`/`fl_chart` to match glow/fill rules. |
| **Power actions** | `GuestPowerActionIconPills` (icon column layout) | Single **rounded** low-surface strip with **four** labeled actions in a row | Restyle to match strip; same enable/disable rules. |
| **Storage overview** | List-first `Card`s + gauges; **no** hero “total cluster TB” band in same layout language | **Hero** row: total used/total + bar; **health** tile; then pool cards + **node distribution** mini-chart | Rebuild `storage_list_screen.dart` top hierarchy to match; distribution only with real aggregation. |
| **Drawer / server switcher** | **Gold gradient ring** around app icon in drawer header | Not shown — Obsidian would use **cyan** / neutral branding | Replace gold-forward decoration with new accent system (or keep gold only if product mandates—document deviation). |
| **Forms & inputs** | `InputDecorationTheme`: **full outline** borders on fields | **Filled** well + **bottom-edge** primary glow on focus (DESIGN §5) | Custom decoration / `Theme` extension. |
| **FAB** | Create FAB on some lists (`ShellSectionBody`); dashboard may omit | Dashboard shows **gradient FAB** | Optional parity; avoid duplicate create affordances. |

**Net:** Stitch is a **different color story** (cyan + purple + magenta on obsidian), **different information density rules** (fewer lines, more tonal layers), **different dashboard topology** (tiles + cluster chart + grid), and **different guest-detail hierarchy** (name in bar, 2×2 instrument tiles). The current app is closer to **Material 3 + iOS blue + premium gold** with **divider-heavy** grouped content. **Navigation topology stays ours**; only **look** and **within-screen structure** move toward the reference.

---

## 2. Route → screen file map (complete)

| Route | Screen / entry | Shell | Layout primitive |
| --- | --- | --- | --- |
| `/` | redirect | — | — |
| `/dashboard` | `features/dashboard/ui/dashboard_screen.dart` | Yes | `ShellSectionBody` |
| `/dashboard/:node` | `features/dashboard/ui/node_detail_screen.dart` | Yes | `Column` + `AppBar` |
| `/vms` | `features/vms/ui/vm_list_screen.dart` | Yes | `ShellSectionBody` |
| `/vms/create` | `features/vms/ui/vm_create_screen.dart` | Yes | `ShellSectionBody` |
| `/vms/:node/:vmid` | `features/vms/ui/vm_detail_screen.dart` | Yes | `Column` + `AppBar` |
| `/vms/:node/:vmid/edit` | `features/vms/ui/vm_edit_screen.dart` | Yes | `Column` + `AppBar` |
| `/containers` | `features/containers/ui/container_list_screen.dart` | Yes | `ShellSectionBody` |
| `/containers/create` | `features/containers/ui/container_create_screen.dart` | Yes | `ShellSectionBody` |
| `/containers/:node/:ctid` | `features/containers/ui/container_detail_screen.dart` | Yes | `Column` + `AppBar` |
| `/containers/:node/:ctid/edit` | `features/containers/ui/container_edit_screen.dart` | Yes | `Column` + `AppBar` |
| `/tasks` | `features/tasks/ui/task_list_screen.dart` | Yes | `ShellSectionBody` (+ raw `showModalBottomSheet`) |
| `/tasks/:node/:upid` | `features/tasks/ui/task_detail_screen.dart` | Yes | `Column` + `AppBar` |
| `/servers` | `features/servers/ui/server_list_screen.dart` | Yes (branch 4) | `ShellSectionBody` |
| `/servers/add` | `features/servers/ui/add_server_screen.dart` → `ServerEditorPage` | Yes | `ServerEditorPage` |
| `/servers/edit/:serverId` | `features/servers/ui/edit_server_screen.dart` | Yes | `Column` + `AppBar` + editor body |
| `/storage` | `features/storage/ui/storage_list_screen.dart` | Yes | `ShellSectionBody` |
| `/storage/:node/:storage` | `features/storage/ui/storage_detail_screen.dart` | Yes | custom scaffold |
| `/backups` | `features/backups/ui/backup_list_screen.dart` | Yes | `ShellSectionBody` |
| `/settings` | `features/settings/ui/settings_screen.dart` | Yes | `ShellSectionBody` |
| `/settings/preferences` | `features/settings/ui/preferences_screen.dart` | Yes | `ShellSectionBody` |

**Sheets / modals (not routes):**

| UI | File | Notes |
| --- | --- | --- |
| Premium dialog / bottom sheet helpers | `lib/shared/widgets/premium_modals.dart` | All `showPremiumDialog`, `showPremiumModalBottomSheet`, `PremiumBottomSheet` |
| Trigger backup | `lib/features/backups/ui/trigger_backup_sheet.dart` | Uses `showPremiumModalBottomSheet` |
| Task list filter sheet | `lib/features/tasks/ui/task_list_screen.dart` | Uses **non-premium** `showModalBottomSheet` — **must** be brought onto same sheet chrome tokens |

**Other root wiring:** `lib/app/app.dart` (`MaterialApp.router`, `theme` / `darkTheme` / `themeMode`), `lib/app/router.dart` (`CustomTransitionPage` 250ms fade for shell pages).

---

## 3. Widget inventory

### 3A. `lib/shared/widgets/` (every file — plan must account for all)

| File | Refactor scope |
| --- | --- |
| `chart_card.dart` | Surface, padding, legend, optional glow |
| `resource_chart.dart` | Series colors from `ColorScheme`; fill under line |
| `resource_gauge_row.dart` | Gradient bar, track color |
| `status_badge.dart` | Pill geometry, glow, semantic colors vs new `ColorScheme` |
| `section_header.dart` | Micro-label uppercase / tracking |
| `shell_section_body.dart` | AppBar styling, optional server pill row, FAB offset |
| `shell_app_bar_leading.dart` | Size, ink, align with dense header |
| `grouped_section.dart`, `inset_grouped_list.dart`, `labeled_row.dart`, `premium_list_row.dart` | Bento surfaces; reduce outline dividers |
| `pill_segmented.dart` | Track + selected fill |
| `guest_power_action_icon_pills.dart` | Four-action strip container |
| `premium_modals.dart` | Dialog/sheet surfaces, button styles |
| `loading_shimmer.dart`, `error_view.dart`, `empty_state.dart` | Base colors, radii |
| `connectivity_banner.dart` | Palette |
| `node_filter_dropdown.dart` | Menu surface, chips |
| `proxmox_tag_widgets.dart` | **Depends on** `proxmox_tag_colors_provider` — user hex still valid; ensure contrast on new `#0c0e17` |
| `icon_badge_avatar.dart` | Ring/accent colors (currently premium-adjacent) |
| `secure_window_scope.dart` | **No visual** change expected; verify no overlay clashes |
| `guest_config/guest_string_dropdown.dart` | Dropdown fill, borders → tonal |
| `guest_config/guest_net_line_editor.dart` | Same |
| `guest_config/guest_disk_volume_editor.dart` | Same |

### 3B. Feature-local charts & badges (triplicated patterns)

**Dashboard:** `features/dashboard/ui/widgets/node_cpu_chart.dart`, `node_memory_chart.dart`, `node_network_chart.dart`, `node_disk_io_chart.dart`

**VMs:** `features/vms/ui/widgets/cpu_chart.dart`, `memory_chart.dart`, `network_chart.dart`, `disk_io_chart.dart`, `vm_status_badge.dart`

**Containers:** `features/containers/ui/widgets/` — same four charts + `container_status_badge.dart`

**Plan requirement:** Either (1) **one styling pass in parallel** across all 12 files using shared tokens, or (2) extract thin shared `StitchChartChrome` / line-style helpers in `lib/shared/widgets/` to avoid drift. Record choice in “Notes / deviations”.

---

## 4. Screen-by-screen deltas (structure + design)

### 4.1 Dashboard (`dashboard_screen.dart`)

| Block | Target |
| --- | --- |
| Header | Dense bar: branding + optional “connected” pill (host from `selectedServerProvider`); align with HTML `header` |
| Summary | **Three** `surface_container_low` tiles: running VMs, LXC count, online nodes; trailing icon in `primary/10` rounded square |
| Cluster chart | Single large `surface_container` card: title row + legend dots + `ResourceChart` + time axis |
| Nodes | **Grid** of node cards: left accent 4px (`primary` / `tertiary`), icon well, uptime, dual micro progress bars |
| Pull-to-refresh / error / empty | Keep logic; restyle `LoadingShimmer` / `ErrorView` / `EmptyState` |

### 4.2 Node detail (`node_detail_screen.dart`)

| Block | Target |
| --- | --- |
| App bar | Subtitle / node status density like VM detail header |
| Body | Same chart cards + gauges as dashboard node cards, expanded |

### 4.3 VM & container **lists**

| Block | Target |
| --- | --- |
| Rows | Tonal card; status via `VmStatusBadge` / `ContainerStatusBadge` pills not full-row color |
| Filters | `node_filter_dropdown` + search field: pill segment track where applicable |
| FAB | Match theme FAB (gradient optional); position consistent with `ShellSectionBody` FAB inset |

### 4.4 VM & container **detail**

| Block | Target |
| --- | --- |
| App bar | **Guest name** as primary title (not generic “Virtual Machine” alone); subtitle: status dot + node + ID |
| Actions row | `GuestPowerActionIconPills` inside `surface_container_low` rounded panel |
| Timeframe | `pill_segmented` / `defaultChartTimeframeProvider` UI centered above charts |
| Metrics | 2×2 mini cards: CPU, RAM, Network, Disk — large Space Grotesk value + spark bars |
| Tags | `ProxmoxTagChip` row harmonized with new palette |
| Storage / backup actions | Keep; icon buttons align with header density |

### 4.5 VM & container **edit** (Tier-A)

| File | Target |
| --- | --- |
| `vm_edit_screen.dart`, `container_edit_screen.dart` | Same as §3A grouped inputs + `guest_*` editors; long forms: clear section separation **without** heavy `Divider` chains |

### 4.6 VM & container **create**

| File | Target |
| --- | --- |
| `vm_create_screen.dart`, `container_create_screen.dart` | Section cards + primary submit gradient |

### 4.7 Storage list / detail

| Screen | Target |
| --- | --- |
| `storage_list_screen.dart` | Hero row: **used/total** + capacity bar; second tile **healthy / degraded** counts from real aggregation only |
| | Pool cards: icon, type label, node, status pill, gradient bar (tertiary when warning) |
| | Node distribution: implement **only** if derivable from existing providers; else omit |
| `storage_detail_screen.dart` | Pool-card visual language; keep metrics |

### 4.8 Tasks

| Screen | Target |
| --- | --- |
| `task_list_screen.dart` | List rows + **migrate filter** `showModalBottomSheet` to `PremiumBottomSheet` or shared sheet theme |
| `task_detail_screen.dart` | Log text: `TextStyle` with monospace-friendly font + `on_surface_variant`; AppBar dense |

### 4.9 Backups

| Screen | Target |
| --- | --- |
| `backup_list_screen.dart` | List/card chrome |
| `trigger_backup_sheet.dart` | Sheet + form controls |

### 4.10 Servers

| Screen | Target |
| --- | --- |
| `server_list_screen.dart` | Cards + pills; remove gold-forward **visual** dependency unless product retains gold for brand |
| `server_editor_page.dart` | All form fields, segmented auth pills, TLS pin UI → new input + surface system |

### 4.11 Settings / preferences

| Screen | Target |
| --- | --- |
| `settings_screen.dart`, `preferences_screen.dart` | Grouped list on tonal scaffold; theme toggle (light) must remain **readable** if light phase deferred |

---

## 5. System, platform, motion

| Topic | Action |
| --- | --- |
| `SystemUiOverlayStyle` | Set status bar icons to **light** on dark `#0c0e17`; verify Android 15 edge-to-edge / `SafeArea` with colored nav bar |
| `MaterialApp` (`app.dart`) | After token change, validate `theme` + `darkTheme` + user `appThemeModeProvider` |
| Page transitions | Optional: align shell fade with prototype (low priority) |
| Motion | Prefer `Theme` animation defaults; no new physics unless specified |
| **Backdrop blur** on bottom bar | DESIGN requests blur — test **jank** on low-end devices; provide flag or solid fallback if needed |

---

## 6. Accessibility & semantics

- [ ] Every **new** icon-only control (power strip, header actions): `Tooltip` + `Semantics` label (existing l10n keys where possible).
- [ ] Focus order on dense headers and 2×2 metric grid: left→right, top→bottom.
- [ ] Contrast: `primary` on `#0c0e17`, `tertiary` warning text, **disabled** power actions.
- [ ] Text scale: headline numbers should **not** overflow 2×2 cells (`FittedBox` / `maxLines` strategy).

---

## 7. Tests & CI

Widget tests under `test/` that **assert colors, fonts, or specific widget types** may need updates after theming:

| Test file | Risk |
| --- | --- |
| `test/shared/widgets/chart_card_test.dart` | Layout / theme |
| `test/shared/widgets/premium_dialog_test.dart` | Dialog chrome |
| `test/shared/widgets/section_header_test.dart` | Typography |
| `test/shared/widgets/premium_list_row_test.dart` | Row chrome |
| `test/shared/widgets/error_view_empty_state_test.dart` | Colors |
| `test/features/settings/settings_screen_test.dart` | Full screen |
| `test/features/servers/server_editor_page_test.dart` | Forms |
| `test/shared/routing/shell_drawer_root_paths_test.dart` | Should **not** need edits for this refactor (nav paths unchanged) |

**CI:** After Dart edits, full chain in `ci-local-verification.mdc` (`flutter analyze`, `flutter test`, etc.).

---

## 8. Pre-flight & debt audits (run before / during Phase A)

```bash
# Hardcoded colors outside theme
rg "Color\(0x" lib/

# Outline / border usage (candidate “no-line” violations)
rg "Border\\.all|OutlineInputBorder|Divider\\(" lib/ --glob '*.dart'

# Premium / gold coupling
rg "premiumAccent|gold" lib/ docs/ --glob '*.dart'
```

Document counts in phase notes; trend **down** across phases.

---

## 9. Risk register

| Risk | Mitigation |
| --- | --- |
| Replacing `#000000` breaks OLED “true black” branding | A/B or setting; document in `AppTheme` comment |
| `secondary` was **gold** (premium); many charts use `colorScheme.secondary` for memory | Explicitly remap memory series to **purple** (`#7e98ff`) and verify legibility |
| User-defined Proxmox tag colors | `proxmox_tag_widgets.dart`: keep user hex, add border/outline if contrast fails WCAG |
| `NavigationBar` + blur + transparency | Test GPU overdraw; fallback solid `Color(0xFF0c0e17)` at 100% |
| Light theme deferred | `AppTheme.light` must not be **broken** (readable minimum); full Stitch light = later phase |

---

## 10. Phased execution (granular)

Phases **depend** in order: **A → B → C** unlock D–G. H runs continuously but formally last.

### Phase A — Tokens & typography

- [x] Add `google_fonts` (or ship `Space_Grotesk` / `Inter` under `assets/fonts` + `pubspec.yaml`).
- [x] Replace dark `ColorScheme` values with §1 table; document scaffold choice (`#0c0e17` vs black).
- [x] Wire `textTheme` / `primaryTextTheme` (display vs body font families).
- [x] Remap `AppColors` status helpers (`darkStatusWarning*` etc.) to align with tertiary/error story without breaking meaning.
- [x] **Decision log:** Light theme — **minimum contrast pass now**; full Stitch light redesign deferred (single choice).
- [x] Run §8 greps; snapshot counts.

### Phase B — Global chrome

- [x] `app_shell.dart`: `NavigationBar` — **styling only** (blur/solid, top border, active pill, label style). **Same five destinations + More;** no `goBranch` index or `NavigationDestination` list changes unless fixing a bug.
- [x] `NavigationDrawer`: surfaces, indicator, **header** (`_DrawerBrandingHeader`) remove/replace gold ring — **same** drawer destinations and `kDrawerPaths` order.
- [x] `router.dart` / `app.dart`: sanity check transitions + `themeMode` (no route-tree edits for Stitch).
- [x] Optional: `ShellSectionBody` server / connection pill.

### Phase C — Shared components (blocking for feature screens)

- [x] `cardTheme` / default `Card` / `InkWell` splash on new surfaces.
- [x] `InputDecorationTheme` + focus: bottom-edge glow; reduce full outline.
- [x] `status_badge.dart`, `guest_power_action_icon_pills.dart`, `pill_segmented.dart`, `resource_gauge_row.dart`.
- [x] `chart_card.dart`, `resource_chart.dart`.
- [x] `grouped_section.dart`, `inset_grouped_list.dart`, `labeled_row.dart`, `premium_list_row.dart`, `section_header.dart`.
- [x] `premium_modals.dart`, `PremiumBottomSheet`.
- [x] `loading_shimmer.dart`, `error_view.dart`, `empty_state.dart`, `connectivity_banner.dart`, `icon_badge_avatar.dart`.
- [x] `node_filter_dropdown.dart`, `proxmox_tag_widgets.dart` (+ contrast check).
- [x] Guest config editors (`guest_config/*.dart`).

### Phase D — Dashboard & node detail

- [x] `dashboard_screen.dart` — §4.1.
- [x] `node_detail_screen.dart` — §4.2.
- [x] Dashboard feature charts (`node_*_chart.dart`) — §3B.

### Phase E — VM & container surfaces

- [x] `vm_list_screen.dart`, `container_list_screen.dart`.
- [x] `vm_detail_screen.dart`, `container_detail_screen.dart` (hero/metric-grid replaced by AppBar identity + shared `GuestInstrumentMetricGrid`).
- [x] `vm_create_screen.dart`, `container_create_screen.dart`.
- [x] `vm_edit_screen.dart`, `container_edit_screen.dart`.
- [x] VM + container chart widgets + status badges — §3B.

### Phase F — Storage

- [x] `storage_list_screen.dart`, `storage_detail_screen.dart`.

### Phase G — Operations & admin

- [x] `task_list_screen.dart` (include bottom sheet unification), `task_detail_screen.dart`.
- [x] `backup_list_screen.dart`, `trigger_backup_sheet.dart`.
- [x] `server_list_screen.dart`, `server_editor_page.dart`, `add_server_screen.dart`, `edit_server_screen.dart`.
- [x] `settings_screen.dart`, `preferences_screen.dart`.

### Phase H — QA, a11y, closure

- [ ] §6 accessibility checklist.
- [ ] §7 all tests green; fix or update goldens if introduced later.
- [ ] §8 grep counts trend review.
- [ ] Visual comparison vs three `screen.png` references.
- [ ] Update this doc: tick phases, fill **Notes / deviations** (e.g. chart unification choice). **Navigation must remain unchanged** unless the product opens a separate IA project.

---

## 11. Explicit non-goals

- **No navigation / IA changes:** same tabs, same drawer items, same route paths and branch layout (`AppShell`, `router.dart`, `shell_drawer_root_paths.dart`). Stitch’s four-tab bar is **not** adopted.
- No switching chart engine away from **fl_chart** unless separately approved.
- No new **fake** metrics or placeholder charts.
- No removal of Containers, Tasks, Backups, or Settings from the product surface.
- No skipping `flutter test` / `flutter analyze` for production-merging UI batches.

---

## 12. Tracking

This file is the **source of truth** for Stitch UI refactors (not `ProxDroid_Roadmap.md`). Complete checkboxes in §10; append dated **Notes / deviations** below when a phase ships.

### Notes / deviations

- `2026-04-13 — Phase A: **google_fonts** (^6.2.1) is a declared dependency; `GoogleFonts.config.allowRuntimeFetching = false` in `AppTheme` so CI/devices never hit the network. **Space Grotesk** + **Inter** ship as variable TTFs under `assets/fonts/` (`pubspec.yaml` `flutter:` `fonts:`) and are wired through `ThemeData.textTheme` / `primaryTextTheme` via `TextStyle.copyWith(fontFamily: …)` (display/headline/titleLarge → Space Grotesk; body/labels/smaller titles → Inter). Dark scaffold uses **`#0c0e17`** (`AppColors.scaffoldObsidian`); **`#000000`** kept as `scaffoldPureBlack` for a future OLED opt-in (see `AppTheme` doc). §8 audit snapshots (repo root, `grep -r`): `Color(0x` under **lib/** → **79** lines; `Border.all|OutlineInputBorder|Divider(` in **lib/**/*.dart** → **98** lines; `premiumAccent|gold` under **lib/** + **docs/** (\*.dart) → **12** lines.`
- `2026-04-13 — Phase B: Bottom bar uses **BackdropFilter** blur (σ=20) under a **tinted overlay** — `AppColors.scaffoldObsidian` at **~55% alpha** on the blurred layer so the bar stays readable and matches the Obsidian canvas even when blur is unavailable, skipped (e.g. impeller/software), or too costly; a **cyan-tinted top hairline** + upward **diffuse shadow** sit on the foreground stack. **Light theme** skips blur and uses an opaque `ColorScheme.surface` bar. Drawer header **gold ring** replaced with **primary → primaryContainer** gradient ring + soft primary glow; `NavigationBarTheme` indicator uses **primary @ 10%** globally. **`ShellSectionBody`**: optional dense **Connected** pill row (`selectedServerProvider`) → `/servers`. **`app.dart`**: `AnnotatedRegion<SystemUiOverlayStyle>` — dark mode **light** status/nav icons on `scaffoldObsidian` nav bar color.`
- `2026-04-13 — Phase C: cardTheme uses surfaceContainer + zero margin; ink uses cyan-tinted splashColor / hoverColor / highlightColor / focusColor with InkRipple. InputDecorationTheme uses filled surfaceContainerHigh wells + StitchBottomInputBorder (lib/app/theme/stitch_bottom_input_border.dart) for hairline rest + primary bottom glow on focus and on focused error; SegmentedButtonTheme track = surfaceContainerHigh, selected = primaryContainer ~72% alpha, no outline. Shared widgets: tonal strips (power actions, labeled rows, list rows / dividers softened), gauges with primary → primaryContainer gradient fill, charts with softer grid/axes, network/disk second series area fill under line, disk series pinned to AppColors.chartDiskRead / chartDiskWrite, connectivity strip bottom accent → primary (gold removed from that strip), ProxmoxTagBadge ghost outline when tag fill vs #0c0e17 contrast is under 1.28 (user hex preserved). Guest config fields drop per-field OutlineInputBorder overrides so theme borders apply. §3B chart helper: not added — chart styling stays in resource_chart.dart plus existing AppColors disk hues.`
- `2026-04-13 — Phase C (verification pass): [ResourceLineChart] resolves omitted [secondaryColor] to [AppColors.chartNetworkOut] when [metric] is network (call sites may still pass explicitly). [IconBadgeAvatar] drops box border in favor of tonal [surfaceContainerHigh] + soft primary-tinted shadow only. Full CI chain re-run: analyze + test exit 0.`
- `2026-04-13 — Phase D: Dashboard uses three [surface_container_low] summary tiles (running VMs, total LXC, online/total nodes), a [surface_container] cluster CPU/RAM card, and a responsive node grid with 4px primary/tertiary accent + [ResourceGaugeRow] micro bars (no per-card embedded RRD). **Cluster chart data:** new [clusterAggregatedNodeRrdProvider] in [rrd_providers.dart] loads [GET /nodes/{node}/rrddata] for each **online** node (same [ChartTimeframe] as the card), merges samples **by index** (Proxmox-aligned rows): **CPU** = mean of per-node CPU samples (normalized like chart layer); **memory** = **sum** of per-node `mem` bytes per sample (cluster total RAM in use). Nodes whose RRD fetch throws are omitted (partial cluster); empty or non-plottable series shows [chartNoData]. One new ARB key: [dashboardSummaryOnlineNodes]. Node detail: dense AppBar (name + status · entity), hero panel matches dashboard node chrome + gauges, metric bento uses tonal cells without divider grid; node disk empty state uses chart-well surface.`
- `2026-04-13 — Phase E: VM/LXC **lists** use tonal [surface_container] rows, neutral icon wells, 4px primary-tint accent strip (not status wash), [SearchBar] ghost outline; status remains on [VmStatusBadge]/[ContainerStatusBadge]. **Detail:** AppBar primary title = guest name, subtitle = status · node · ID; [GuestPowerActionIconPills] unchanged semantically; **timeframe pills above** the new **2×2** [GuestInstrumentMetricGrid] ([lib/shared/widgets/guest_instrument_metric_grid.dart]) fed by existing [vmRrdDataProvider]/[lxcRrdDataProvider] + live snapshot headlines; tags (+ LXC ostype when present) in a tonal card; charts unchanged below. **Create:** section blocks wrapped in [Card] + gradient primary submit. **Edit:** removed [Divider] chains between [GroupedSection]s, [OutlineInputBorder] dropped for theme filled fields. **§3B:** no new chart helper type—VM/container chart files got doc comment alignment with [ColorScheme]/[AppColors] only; one ARB key [guestDetailMetricGridSemantics].`
- `2026-04-13 — Phase G: **Tasks** — guest filter uses [showPremiumModalBottomSheet] + [PremiumBottomSheet]; filter search field uses theme [InputDecoration]; list tiles + status summary strip are tonal (no hairline border on summary, soft shadow). **Task detail** — dense AppBar (title + node·UPID), log lines monospace + [onSurfaceVariant] in a [surfaceContainerHigh] well. **Backups** — job rows, expansion groups, and recent vzdump rows on [Card] + consistent padding; **trigger backup** sheet wraps form in [surfaceContainer] card, dropdowns in filled wells ([DropdownButtonHideUnderline]). **Servers** — list rows are [surfaceContainer] cards with optional 4px primary gradient accent + [shellConnectedLabel] chip when row matches [selectedServerProvider]; **editor** — all [OutlineInputBorder] overrides removed for theme wells; TLS pin block in [surfaceContainerHigh] inset with monospace-friendly pin text and [FilledButton.tonalIcon] fetch. **Settings / preferences** — [surfaceContainerLowest] scaffold behind grouped [surfaceContainer] section cards; soft internal dividers only. No router or shell changes.`
- `2026-04-13 — Phase F: Storage **list** uses a [surface_container] hero ([storageClusterHeroTitle]) with [ResourceGaugeRow] fed by **real** sums of `used`/`total` only across pools where both are present (same pairing as per-card usage); two [surface_container_low] tiles count **healthy** (active and usage below 65% or usage unknown) vs **at risk** (inactive or usage at/above 65%, matching gauge warning/error semantics). Pool rows are Stitch-style cards (4px accent from status/usage, neutral icon well, [StatusBadge], gradient gauge via [ResourceGaugeRow]). **Node distribution:** horizontal “used by node” bars when at least **two nodes** appear in the cluster list **and** summed `used` (pools with non-null `used` ≥0) is **positive**—values are grouped sums from [allClusterStorageProvider] only (no new API). **Detail** screen aligns header + usage + metadata with the same accent + tonal surfaces; content rows use [surface_container] tiles instead of default [Card]s.`
