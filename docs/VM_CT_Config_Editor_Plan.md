# VM & LXC config editor — implementation plan

**Plan status:** Draft — execution checkboxes below start **unchecked** (`[ ]`). Mark `[x]` when done.  
**Date:** April 2026  
**Audience:** Cursor / implementers. Follow **phases in order** unless a phase explicitly allows skipping.

---

## How to use this document (implementers)

1. Work **Phase 0 → Phase 7** sequentially. Do **not** start Phase *N+1* until **all** acceptance checkboxes for Phase *N* are `[x]`.
2. **Optional** phases (8+) are out of strict order; still complete acceptance before merging.
3. After **each** phase: run local CI parity from `.cursor/rules/ci-local-verification.mdc` (`pub get`, format check, `build_runner`, `gen-l10n`, `analyze`, `test`).
4. Keep **ProxDroid** conventions: `ApiEndpoints` only (no hard-coded paths), `ProxmoxException` from repos, Riverpod codegen, Freezed + json_serializable, **ARB for all UI strings**, feature-first folders (`features/vms/`, `features/containers/`).
5. When a **phase** ships: update `docs/ProxDroid_Roadmap.md` checklist if applicable; update `docs/ProxDroid_Architecture.md` §8 route table when routes land.

---

## 1. Goals & non-goals

**Goals**

- **Edit** QEMU VM and LXC CT via `GET`/`PUT …/config` with a **form** (Tier A first).
- **Create** VM/CT via `POST` + `GET /cluster/nextid` where applicable.
- **Delta PUT:** send only changed keys; support `delete=` for removed indices when implementing networks (Phase 8+).
- **Passthrough:** keys returned by `GET` that the UI does not model must not be lost on save (carry in a map until Advanced mode exists).

**Non-goals (v1 of this plan)**

- Node migration, in-place `vmid` change, full disk wizard, full Proxmox UI parity, OCI-only LXC create (**9.1+**) until explicitly added in an optional phase.

---

## 2. Master tracker (quick view)

Use the detailed phase sections below for full tasks; this table is optional high-level only (no checkboxes here to avoid duplication).

| Phase | Name |
|-------|------|
| 0 | API paths + GET config + repositories + tests |
| 1 | Config models + passthrough + parse tests |
| 2 | PUT delta + repository update + tests |
| 3 | Riverpod load/save providers |
| 4 | Routes + VM Tier-A edit UI + l10n + entry point |
| 5 | Container Tier-A edit UI + entry point |
| 6 | Create VM (minimal) + nextid + tasks if UPID |
| 7 | Create CT (minimal) + tasks if UPID |
| 8 (opt) | `netN` editor + `delete=` |
| 9 (opt) | Disks / `rootfs` / `mpN` |
| 10 (opt) | Cloud-init & advanced |

---

## 3. Phase 0 — API surface & GET config

**Objective:** Read VM/CT config from Proxmox with typed client + repos; no UI.

### 3.1 Tasks

- [ ] Add to `lib/shared/constants/api_endpoints.dart` (names illustrative; keep consistent style):
  - [ ] `GET|PUT` path builder for `/nodes/{node}/qemu/{vmid}/config`
  - [ ] `GET|PUT` path builder for `/nodes/{node}/lxc/{vmid}/config` (CT id is API `vmid`)
  - [ ] `POST` create `/nodes/{node}/qemu` and `/nodes/{node}/lxc`
  - [ ] `GET /cluster/nextid`
- [ ] `ProxmoxApiClient`: methods to **GET** QEMU and LXC config; parse Proxmox envelope and return the inner `data` map (or typed DTO used by Phase 1).
- [ ] `VmRepository` / `ContainerRepository`: `getQemuConfig` / `getLxcConfig` (names align with codebase conventions).
- [ ] Map `DioException` → `ProxmoxException` only (no raw Dio in UI).

### 3.2 Acceptance criteria (Phase 0 complete when all checked)

- [ ] No API path strings outside `api_endpoints.dart`.
- [ ] Unit tests (mock Dio) prove GET config success and error mapping (`403` → permission path, etc.).
- [ ] `flutter analyze` and `flutter test` pass after this phase.

---

## 4. Phase 1 — Config models & lossless read

**Objective:** Turn `GET …/config` `data` into a Dart model safe for editing: structured Tier-A fields + **passthrough** for unknown keys.

### 4.1 Tasks

- [ ] Add Freezed models under `lib/core/models/` (e.g. `qemu_vm_config.dart`, `lxc_container_config.dart`) with `part` files per project rules.
- [ ] **Tier A (initial)** — parse at minimum for **both** QEMU and LXC:
  - [ ] Identity: `name`, `description`, `tags` (QEMU); `hostname`, `description`, `tags` (LXC)
  - [ ] Resources: `memory`, `cores` (+ LXC: `swap`, `cpulimit`, `cpuunits` if present)
  - [ ] QEMU: `sockets`, `vcpus`, `cpu`, `ostype`, `onboot`, `startup`, `agent` (as strings if compound)
  - [ ] LXC: `ostype`, `arch`, `onboot`, `startup`, `unprivileged`, `features` (string), `rootfs` (string — read-only in UI until Phase 9 unless product decides otherwise)
- [ ] **Passthrough map:** all keys from GET not assigned to structured fields remain in `Map<String, String>` (or values normalized to string per `proxmox_json_helpers` patterns).
- [ ] `build_runner` generates clean; no analyzer issues in new files.

### 4.2 Acceptance criteria

- [ ] From a representative **QEMU** `GET` JSON fixture, parsing preserves **every** key-value pair (either in structured fields or passthrough).
- [ ] Same for **LXC** fixture.
- [ ] Include **two** fixture flavours (e.g. “8.x-shaped” and “9.x-shaped”) differing in at least one optional key to lock permissive parsing.
- [ ] `flutter test` passes.

---

## 5. Phase 2 — PUT config (delta + delete hook)

**Objective:** Persist edits without wiping unmodeled keys: **only send changed** structured fields; merge passthrough; prepare optional `delete` list for future indexed keys.

### 5.1 Tasks

- [ ] Implement **diff builder**: given `original` vs `edited` config objects, produce `Map<String, dynamic>` (or string map) of **only** keys that changed, suitable for `x-www-form-urlencoded` PUT.
- [ ] `ProxmoxApiClient` + repositories: `updateQemuConfig` / `updateLxcConfig` accepting body map + optional `delete` query (comma-separated key names per PVE).
- [ ] Ensure **passthrough** keys untouched by the user are **not** dropped: either omit from PUT or re-send unchanged (document chosen strategy in code comment; **prefer omit** for unchanged passthrough keys if PVE treats missing as “leave unchanged” — verify against PVE PUT semantics for your fields; if unsafe for certain keys, re-send merged full passthrough for stability).

### 5.2 Acceptance criteria

- [ ] Unit test: changing only `name` results in PUT body containing **only** `name` (plus auth), not full config dump of dozens of keys.
- [ ] Unit test: `delete` query includes `net1` when caller requests removal (stub for Phase 8; implement when Phase 8 lands, or add minimal hook now).
- [ ] `flutter test` passes.

---

## 6. Phase 3 — Riverpod: load, draft, save

**Objective:** UI layer can watch async config and call save without talking to Dio directly.

### 6.1 Tasks

- [ ] `@riverpod` family (or equivalent codegen) for **fetch** QEMU config and LXC config by `(node, id)`.
- [ ] Notifier or controller pattern for **draft** state (mutable editing buffer) separate from immutable parsed snapshot, **or** documented `copyWith` flow.
- [ ] `save()` triggers repository PUT, then `ref.invalidate` on success: at minimum `allVmsProvider` / `allContainersProvider` and the config provider for that guest.
- [ ] Surface `ProxmoxException` as `AsyncValue` error or SnackBar-ready message (reuse `proxmoxExceptionMessage`).

### 6.2 Acceptance criteria

- [ ] Widget-less test or notifier test: mock repo → save → invalidation contract verified where feasible.
- [ ] No `Dio` / path strings in provider files.
- [ ] `flutter analyze` / `test` pass.

---

## 7. Phase 4 — VM edit: routes + Tier-A form

**Objective:** User opens VM edit from the app, edits Tier-A fields, saves, sees list/detail refresh.

### 7.1 Tasks

- [ ] Add go_router routes (exact paths **must** be added to `docs/ProxDroid_Architecture.md` §8): e.g. `/vms/:node/:vmid/edit`.
- [ ] New screen under `lib/features/vms/ui/` (e.g. `vm_edit_screen.dart`) using `Form`, `GroupedSection`, `SectionHeader`, `LoadingShimmer`, `ErrorView`, pattern from `ServerEditorPage`.
- [ ] All labels / buttons / errors in `lib/l10n/app_en.arb` + `gen-l10n`.
- [ ] Entry point: `VmDetailScreen` → navigate to edit (icon button or menu).
- [ ] On success: SnackBar or inline success feedback; invalidate providers from Phase 3.

### 7.2 Acceptance criteria

- [ ] With a real **PVE 8.x or 9.x** cluster (manual): open edit, change `name` or `description`, save, confirm in Proxmox UI or list row.
- [ ] Router redirect behaviour unchanged for null server (edit routes require selected server like other API routes).
- [ ] CI sequence passes; no hard-coded user strings.

---

## 8. Phase 5 — Container edit: routes + Tier-A form

**Objective:** Same as Phase 4 for LXC.

### 8.1 Tasks

- [ ] Routes: e.g. `/containers/:node/:ctid/edit` + Architecture doc update.
- [ ] `ContainerEditScreen` under `features/containers/ui/`.
- [ ] ARB strings (reuse shared keys where identical concepts, e.g. “Save”, “Discard”).
- [ ] Entry from `ContainerDetailScreen`.

### 8.2 Acceptance criteria

- [ ] Manual save on 8.x or 9.x changes at least one Tier-A field (e.g. `hostname` or `memory`).
- [ ] CI passes.

---

## 9. Phase 6 — Create VM (minimal)

**Objective:** Create a **new** QEMU VM with the smallest safe parameter set; use `nextid`; handle UPID if returned.

### 9.1 Tasks

- [ ] Repository + client: `GET /cluster/nextid`; `POST /nodes/{node}/qemu` with documented minimal body (align with PVE docs for your test matrix: **vmid**, **name**, **memory**, **net0**, **ostype** / **ide** / **scsihw** — **document exact minimal set in code comment** after verifying against PVE 8.4 + 9.x).
- [ ] Screen + route: e.g. `/vms/create?node=…` or node picker step + form.
- [ ] If POST returns **UPID**: poll `taskStatusProvider` like power actions; on `ok` invalidate VM list.
- [ ] l10n + error handling.

### 9.2 Acceptance criteria

- [ ] Manual: create VM on **Tier-1** cluster (§11); VM appears in list; failed create shows readable error.
- [ ] If UPID path exists: task failure surfaces appropriately (no silent success).
- [ ] CI passes.

---

## 10. Phase 7 — Create CT (minimal)

**Objective:** Same as Phase 6 for `POST /nodes/{node}/lxc` with minimal fields (`vmid`, `hostname`, `ostype`, `password` or auth mode per PVE, `rootfs`, `memory`, `net0` — **verify** against docs).

### 10.1 Tasks

- [ ] Client/repo POST create LXC.
- [ ] Route + screen: e.g. `/containers/create`.
- [ ] UPID handling if applicable.

### 10.2 Acceptance criteria

- [ ] Manual create on Tier-1 cluster; CT appears in list.
- [ ] CI passes.

---

## 11. Reference — Proxmox VE version coverage (QA)

**Tier 1 (must manually verify Tier-A / create before release):** Proxmox VE **8.4** (or latest **8.x**) and **9.x** stable.  
**Tier 2 (best-effort):** **7.4+** — do not block releases on 7-only issues.

- Use **`GET /version`** for optional UI hints; use **`GET …/config`** as schema source per guest.
- Version-gated examples (extend later): OCI LXC **9.1+**, TPM/qcow2 nuances **9.x** — see Proxmox wiki / API viewer.

---

## 12. Reference — API contract (short)

| Action | Method | Path pattern |
|--------|--------|----------------|
| Read VM config | GET | `/nodes/{node}/qemu/{vmid}/config` |
| Write VM config | PUT | same |
| Create VM | POST | `/nodes/{node}/qemu` |
| Read CT config | GET | `/nodes/{node}/lxc/{vmid}/config` |
| Write CT config | PUT | same |
| Create CT | POST | `/nodes/{node}/lxc` |
| Next vmid | GET | `/cluster/nextid` |

Many changes require guest **stopped**; show API errors clearly.

---

## 13. Reference — Property tiers (for later phases)

**QEMU Tier A (examples):** `name`, `description`, `tags`, `memory`, `sockets`, `cores`, `vcpus`, `cpu`, `ostype`, `onboot`, `startup`, `agent`, `balloon`, `boot`, `bootdisk`, …  
**LXC Tier A (examples):** `hostname`, `description`, `tags`, `memory`, `swap`, `cores`, `cpulimit`, `cpuunits`, `ostype`, `arch`, `rootfs`, `onboot`, `startup`, `unprivileged`, `features`, …

**Tier B:** `net0–31`, disks (`scsi*`, `virtio*`, …), `mp*`, `dev*`.  
**Tier C:** cloud-init keys.  
**Tier D:** read-only / other APIs.

Expand structured fields **per phase**; always keep passthrough until Tier B is fully modeled.

---

## 14. Optional Phase 8 — Network interfaces (`netN`)

### 14.1 Tasks

- [ ] UI list editor for `net0`… with add/remove/reorder if product requires.
- [ ] On save, emit `delete=netN` for removed indices and PUT new/changed `netM` values.
- [ ] Tests for diff/delete composition.

### 14.2 Acceptance criteria

- [ ] Manual add/remove net on test VM; Proxmox reflects change.
- [ ] CI passes.

---

## 15. Optional Phase 9 — Disks / `rootfs` / `mpN`

### 15.1 Tasks

- [ ] High-risk strings: confirm UX (confirm dialog, stopped-guest checks).
- [ ] Targeted tests with fixtures.

### 15.2 Acceptance criteria

- [ ] Documented manual test on non-production guest; CI passes.

---

## 16. Optional Phase 10 — Cloud-init & advanced

### 16.1 Tasks

- [ ] Subforms or raw editor with validation; version gates per §11.

### 16.2 Acceptance criteria

- [ ] Product-defined scope complete; CI passes.

---

## 17. Per-PR hygiene (always)

- [ ] `dart format` / CI format step clean  
- [ ] `dart run build_runner build --delete-conflicting-outputs` if models/providers changed  
- [ ] `flutter gen-l10n` after ARB edits  
- [ ] `flutter analyze` + `flutter test`  
- [ ] No credentials in models; HTTPS-only unchanged  

---

## 18. Related documents

- `ProxDroid_Architecture.md` — §4 layout, §8 routes, §10 errors  
- `ProxDroid_Roadmap.md` — Post-MVP VM/CT editor checkbox  
- `ProxDroid_UI_Refactor_Plan.md` — shared form widgets  
- Proxmox wiki — upgrade **8.4 → 9**, release notes for gated features  

---

*End of plan — execution state lives in the `[ ]` / `[x]` checkboxes above.*
