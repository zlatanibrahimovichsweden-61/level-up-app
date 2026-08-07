# Day 8 Brief — Account: Profile, Edit Profile, Settings

> Repo `level_up_app`, branch `dev`. Self-contained.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq`, page **`design`** · Contract: `contract/openapi.yaml`
> **pinned `ee2ed8f` (v1.1.0-m1)** — see `contract/SOURCE.md`.
> Prereq: Day 7c committed, `dev` clean.
>
> **This day is split into THREE STEPS.** Each step is a self-contained unit of work that ends in a
> shippable state. The owner will instruct Claude Code to implement **one step at a time** — do not
> start Step 2 until told, and do not start Step 3 until told.
>
> **Day 8 consumes the last unbuilt stable endpoint.** After it, endpoint coverage is **21/21
> stable (100%)** and **22/36 total**. Every one of the remaining 14 is `x-stability: draft`.

---

# Why this day is strange, and read this before anything else

Day 8 has **one** endpoint to build (`PATCH /me`) and **eight** designed screens. That ratio is the
whole story of this day.

The Account cluster was drawn as a complete product surface — profile stats, a friends list, a
referral programme, customer-support ticketing, notification preferences, track switching. Almost
none of it has a contract. Of the eight menu rows on the Profile screen, **exactly one** leads
somewhere fully buildable.

So this day is not "build the Account tab". It is:

1. Build what the contract supports, properly.
2. Render what it does not support **visibly disabled**, so the shape of the product is honest on
   the device instead of hidden behind a placeholder.
3. Write the backend a notice listing every gap, with frame evidence, so the next contract version
   can close them.

That third item is a deliverable, not a footnote. It ships in Step 3.

---

# Assumptions this brief is built on

Locked with the owner before writing. If any is wrong, **stop and say so**.

1. **Whole Account cluster is in scope**, delivered as three steps.
2. **Screens with no contract are built as DISABLED shells**, not omitted and not mock-driven. A
   student can see them and cannot use them. This is the Day 7 "Review Questions" treatment (S14),
   applied at scale.
3. **A partner notice for Seif is a Step 3 deliverable** — a standalone `.md` written to him, in the
   same shape as the notice he sent us on 2026-07-30.
4. **Default avatars only.** `PATCH /me { avatarId }` + the existing `avatarsProvider` from Day 2.
   `PUT /me/avatar` is draft — the "Upload photo" option in the design's bottom sheet renders
   disabled.
5. **Privacy toggles are built** — `leaderboardVisible` and `scoreHidden` are on a stable endpoint
   and server-enforced (adr-023) whether or not our Leaderboard tab exists yet.
6. **No new packages.**
7. **The frame is authoritative for layout; the contract is authoritative for data.** Where the
   frame draws a value the contract cannot supply, the control renders and is disabled or omitted
   per the rules in each step — never invented, never faked from a client-side computation.

---

# Rules for this day

1. **Never compute a displayed number client-side.** This repo has been burned once already (S12,
   quiz points off by 20×). Points, level, badges and any counter come from the server verbatim or
   do not render.
2. **Disabled means visibly disabled, and identifiable in a test.** Every disabled control gets a
   stable `Key` so a widget test can assert it is present AND non-interactive. A row that merely
   does nothing on tap is a bug, not a disabled state.
3. **One reason per disabled control, recorded once.** Each gets a `TODO(contract)` comment naming
   the `seif_fight.md` entry that tracks it. No orphan TODOs.
4. **Reuse before building.** The avatar picker, `ReferenceDropdown`, `FieldLabel`, `CircleBackButton`,
   `LanguagePill`, `StateWidget` and the form-field set all exist. A second implementation of any of
   them is a review failure.
5. **Riverpod.** `flutter_bloc` is the quiz's alone and the quiz is not touched.
6. **Every string is an ARB pair, AR + EN.** Verify AR(RTL) + EN × light + dark.
7. **Do not touch** auth, catalog, quiz, registration, Home, or anything Day 7c landed.

---

# Figma frame map

Page **`design`** → group **`light mode`** (`310:10280`) → **`School Student Flow`**.
Dark and RTL variants live in the sibling `Dark mode` / `RTL` top-level groups; the theme carries
colour, so build once and verify in all four combinations.

| Screen | Node | Size | Notes |
|---|---|---|---|
| **Profile** (Account tab root) | `166:4416` | 402×1154 | The hub. Eight menu rows. |
| **Setting** | `176:1840` | 402×966 | Languages · Mode · Rank · Notification Preferences |
| **Edit Profile** | `180:3989` | 402×961 | Three variants exist — base, avatar action sheet, avatar carousel |
| **Go to Uni** | `180:4301` | 402×966 | **A dialog over Profile**, not a route |
| **Logout** | adjacent to `180:4301` | 402×966 | **A dialog over Profile**, not a route |

**Look up by layer name** (not yet ID'd — pull with `get_metadata` on `310:10280`'s
`School Student Flow` child, or select by name): `Friends`, `Refer a Friend`, `Notifications`,
`your progress`, `Favorite questions`, `Customer Support` ×3, `Create Ticket`, `Messages` ×2.

**Two things the layer list makes obvious and the brief depends on:**

- **`Logout` and `Go to Uni` are not screens.** Both frames render the *Profile* screen with a modal
  dialog on top. They are dialogs, so they get no route. Building them as routes would be wrong.
- **The University Student Flow group mirrors this cluster**, exactly as it did for the quiz (Day 7).
  Build one Account feature; do not branch by track inside these screens.

The Figma plan has a hard MCP call limit. Pull a frame only for detail this brief does not give you.

---

# ⚠️ CONFLICTS — every one of these is real, and found by reading the frames

### 1. 🔴 Edit Profile draws six fields `PATCH /me` cannot accept

The frame renders, top to bottom: avatar · **Full Name** · **E-Mail** · **Phone Number** (`+02`) ·
**Parent's Number** (`+02`) · **City** (`Cairo`) · **School Name** (`Modern school`) — and on the
other variants **Education System** (`Amarican`) and **Grade**.

`PATCH /me` accepts exactly five things (`openapi.yaml:614-624`):

```
name · email · avatarId · leaderboardVisible · scoreHidden
```

Phone, parent phone, city, school, education system and grade are **immutable after registration**
in v1.1. Phone especially — it is the identity anchor (adr-019, phone-verify-first) and cannot be
a free edit.

**Do:** render `name` and `email` as live inputs. Render the rest **read-only** — visible, filled
from `GET /me`, not editable, with no Save participation. Do not hide them; the student should see
their own data. Do not render them as disabled *inputs* that look broken — read-only rows.
This is `seif_fight.md` **S20**, already raised on Day 7c, now with frame evidence.

### 2. 🔴 "Solved Questions 300" has no source

Profile renders a solved-questions counter. `StudentProfile` carries `points {school, university,
total}`, `level`, `badges` — **no answered/solved counter**. `SubjectTree` has per-node
`answered`/`total`, but that is per subject and not summable into a lifetime figure.

**Do:** **omit the counter entirely.** Do not sum anything client-side. Logged as **S24**.

### 3. 🔴 "Rank HERO" has no source

Profile renders a rank *tier name*. The contract has `level` (integer 1–12) and `badges` (integer).
There is no rank string, no tier enum, and `GET /leaderboard/me` — which might have carried one — is
draft.

**Do:** render the **Points** stat card (that one is real: `points.total`) and **omit the Rank
card**, or render it disabled with an em-dash. Prefer omission; a card showing "—" invites someone
to fill it in with a guess. Logged as **S25**.

### 4. 🟠 Settings "Mode" offers three themes; the app has two

The frame draws three colour circles under **Mode**. `AppColors` has exactly two canvases — light
green `#384F47` and dark purple `#AE87E7` — and the entire Day 7b fidelity pass was measured against
those two.

**Do:** render **two** options, wired to the existing theme switch. Do not invent a third palette.
Logged as **S26** and `DESIGN_ISSUES.md`.

### 5. 🟠 Settings "Show Rank" is one toggle; the contract has two privacy fields

The frame draws a single **Show Rank** switch. `PATCH /me` has **`leaderboardVisible`** (am I listed
at all) and **`scoreHidden`** (am I listed but with my score suppressed). They are different
questions and adr-023 defaults them differently (`true` / `false`).

**Do:** render **both** toggles, labelled clearly, with the frame's row styling. One switch cannot
express two independent booleans, and collapsing them would silently pick a policy. Logged as
**S27**.

### 6. 🟠 Notification Preferences — four toggles, zero endpoint

Announcements · Promotions · Support · System. Nothing in the contract stores these. `PUT
/me/fcm-token` is draft and is a device token, not a preference set.

**Do:** render all four **disabled**, in the frame's styling. Logged as **S28**.

### 7. 🟠 "Upload photo" needs a draft endpoint

The avatar bottom sheet offers **Upload photo** and **Use Avatar**. `PUT /me/avatar` is draft and
moderated (adr-021). `GET /reference/avatars` + `PATCH /me { avatarId }` are both stable.

**Do:** **Use Avatar** works and opens the existing Day 2 picker. **Upload photo** renders disabled.
Logged as **S29**.

### 8. 🟠 Six of eight Profile menu rows have no destination

| Row | Backing | Tracked as | Step 1 | Step 3 |
|---|---|---|---|---|
| Settings | none needed | — | **live** → `/settings` | screen built |
| Favorite questions | `/me/favorites` **draft** | **S11** | disabled | stays disabled |
| your progress | nothing at all | **S32** | disabled | stays disabled |
| Refer a Friend | nothing at all | **S5** | disabled | → disabled shell screen |
| Customer Support | nothing at all | **S33** | disabled | → disabled shell screen |
| Subscription | `/checkout/sessions` **draft** | **S8** | disabled | stays disabled |
| Privacy & policy | no copy supplied | **S30** | disabled | → `TODO(content)` empty screen |
| Terms & Conditions | no copy supplied | **S30** | disabled | → `TODO(content)` empty screen |

**Corrected 2026-08-06 after Step 1.** Three fixes to this table, all defects in the brief rather
than in the implementation:

1. **`Subscription` is disabled, not routed.** An earlier draft of this table said "routes to the
   existing `/subscription` placeholder" while the Step 1 body said "the other seven disabled".
   Step 1 followed the body and flagged the contradiction. Disabled is correct — the placeholder has
   nothing behind it and `/checkout/sessions` is draft. **Step 3 must not flip this back.**
2. **`your progress` = S32 and `Customer Support` = S33.** Neither had a number, so Step 1 filed both
   under S30 alongside Privacy/Terms. S30 is *only* the missing-legal-copy issue. Step 3 renumbers
   the two `TODO(contract)` markers when it writes the entries.
3. **The frame draws TEN rows, not eight.** `Go to University` and `Logout` are rows in the same
   list, styled differently (black / red outline, lavender icon disc, no chevron) and opening
   dialogs rather than navigating. Found in Step 1. No contract impact — recorded so the count
   stops being wrong.

**S24 and S25 have no code marker anywhere**, because Solved Questions and Rank are *omitted*
(conflicts 2 and 3), not disabled. There is nothing in `lib/` to grep for. Step 3 writes them from
this brief.

**Privacy & policy / Terms & Conditions** need no endpoint but they do need *text*, and nobody has
supplied any. Build the rows and route them to a screen that renders a single
`TODO(content)`-marked empty state. Do not write legal copy. Logged as **S30**.

### 9. 🟠 "Go to Uni" switches track — and the contract forbids it

The dialog reads *"Are you sure you want to convert to Uni Track?"*. Track is set at registration by
a discriminated body (`SchoolRegistration` | `UniversityRegistration`), and adr-010 gives the two
tracks different *shapes* — university has no country field at all. There is no endpoint, and
`PATCH /me` cannot express it. Worse, `points` are **dual-pool per track** (adr-003) — a switch
raises a question nobody has answered: what happens to the school pool?

**Do:** build the dialog, **Confirm disabled**. Logged as **S31**, and flag the points question
explicitly — it is a data-model question, not a UI one.

### 10. 🟡 Notifications screen exists, and the bell is already gated

A `Notifications` frame sits in the cluster. `DESIGN_ISSUES.md` #41 already gates the Home bell's
unread dot behind a permanently-false flag pending a notifications endpoint. Still no endpoint.

**Do:** out of Day 8 entirely. Do not add a route. Note it in the partner notice so it is counted.

### 11. 🟢 Logout is the one thing that fully works

`POST /auth/logout` is stable and consumed since Day 1b, `AuthController` already owns the flow and
`clearTokens()` already preserves `device_id`. The dialog is new; the behaviour behind it is not.

---

# STEP 1 — Profile hub, and the Account tab stops being a placeholder

> Implement this step only. Stop at the end and report.

**Goal:** tapping Account shows the real Profile screen.

1. **`ProfileScreen`** at `lib/features/profile/screens/profile_screen.dart`, from frame `166:4416`.
   Replaces `AccountPlaceholderScreen` in the `/account` branch of the shell
   (`app_router.dart:203`).
2. **Data** from the existing `meNotifier` (`lib/features/profile/notifier/me_notifier.dart`) — it
   already fetches `GET /me`. **Do not add a second fetch.** Full `ScreenState` matrix via
   `StateWidget`: loading / error / offline.
3. **Header** — avatar (`profile.avatar.url`), name, level chip. The pencil routes to
   `/profile/edit`, which does not exist yet in Step 1: render it, route it, and let it land on a
   temporary empty screen you will replace in Step 2. Say so in the commit body.
4. **Stat cards** — render **Points** from `points.total` verbatim. **Omit Solved Questions
   (conflict 2) and Rank (conflict 3).**
5. **Menu rows** — all eight, per the conflict-8 table. Live rows navigate. Disabled rows render at
   full fidelity with reduced opacity and no tap target, each with a `Key` and a `TODO(contract)`
   naming its `seif_fight.md` entry.
6. **Logout dialog** (conflict 11) — red confirm / neutral dismiss, per frame. Confirm calls the
   existing `AuthController` logout. The router's redirect guard already handles the rest.
7. **`Go to Uni` dialog** (conflict 9) — built, **Confirm disabled**.

**Do NOT** build Edit Profile, Settings, or any shell screen in this step.

**Tests:** widget tests for the state matrix; that Points renders from the server value; that each
disabled row is present and non-interactive by `Key`; that Logout confirm calls the controller and
dismiss does not.

**Commit:** `feat(profile): Day 8 step 1 — Profile hub replaces the Account placeholder`

---

# STEP 2 — Edit Profile and `PATCH /me`

> Implement this step only, after Step 1 is reviewed. Stop at the end and report.

**Goal:** the last stable endpoint is consumed.

1. **`ProfileRepository.updateMe(...)`** — `PATCH /me`, returning the updated `StudentProfile`.
   Sends **only** present fields (`All fields optional; absent = unchanged`), so use
   `includeIfNull: false` discipline exactly as the registration bodies do. Handles `400
   validation_failed` into per-field errors via the existing `ValidationException`.
2. **`EditProfileScreen`** from `180:3989`, routed at `/profile/edit`.
   - **Editable:** Full Name (`maxLength: 100`), E-Mail (nullable — **clearing it sends `null`,
     which is meaningful**: `null` clears, absent means unchanged. Get this right; it is the one
     place in the whole app where explicit `null` is correct on the wire).
   - **Read-only** (conflict 1): Phone, Parent's Number, City, School Name, Education System, Grade.
     Fill from `GET /me`. For a free-text city (`ProfileCity.freeText`, landed Day 7c) render the
     plain string — this is the Day 7c union's **first call site**, so `switch` on it exhaustively.
   - **Avatar** — tapping opens the bottom sheet: **Use Avatar** → the existing Day 2
     `avatarsProvider` picker, selection sets `avatarId`; **Upload photo** → disabled (conflict 7).
3. **Save** — submits, then **invalidates `meNotifier`** so Profile and Home repaint. Same pattern
   as the quiz's post-finish `/me` invalidation.
4. **Unsaved-changes guard** on back, matching the quiz's confirm-on-exit dialog.

**Tests:** body contains only changed fields; email `null` vs absent are distinguishable and both
tested; `avatarId` round-trips; `validation_failed` maps to inline field errors; read-only fields
render but never appear in the request; a free-text city renders; save invalidates `/me`.

**Commit:** `feat(profile): Day 8 step 2 — Edit Profile, PATCH /me (21/21 stable)`

---

# STEP 3 — Settings, the disabled shells, and the partner notice

> Implement this step only, after Step 2 is reviewed.

1. **`SettingsScreen`** from `176:1840`, routed at `/settings`, replacing the `_Placeholder`.
   - **Languages** — wire to the existing locale switch. Do not build a second mechanism; the
     `LanguagePill` logic already exists.
   - **Mode** — **two** options, not three (conflict 4), wired to the existing theme switch.
   - **Rank** — **two** toggles, not one (conflict 5): `leaderboardVisible` and `scoreHidden`, both
     via `PATCH /me` reusing Step 2's `updateMe`.
   - **Notification Preferences** — four toggles, **all disabled** (conflict 6).
2. **Disabled shell screens** — `Refer a Friend`, `Customer Support`, `Friends`, and the
   Privacy/Terms content screens. Each renders its frame's layout at full fidelity with every
   interactive control disabled and a single explanatory line. These are **shells, not mocks**: no
   invented data, no fake list rows, no placeholder friends.
3. **The partner notice** — `docs/for_seif_account_surface.md` **already exists** and was sent ahead
   of implementation, because Seif's answers take days and there is no reason to block on them.
   Your job is not to write it. Your job is to **reconcile it**: if implementation turns up a gap it
   does not list, or proves one of its claims wrong, amend it and say so in the report. Treat a
   disagreement between the notice and what you find in the frames as a finding, not a typo.
4. **`seif_fight.md`** — entries **S24–S35** per the conflicts above, each pointing at the notice.
   **Corrected 2026-08-07:** the range was S24–S33 when this brief was written. **Step 2 found two
   more** while building Edit Profile — **S34** (`parentPhone` is write-only: required at
   registration, absent from `GET /me`, so we can never show a student what they gave us) and
   **S35** (`GET /me` returns raw wire codes, so a student reads `nationalLanguages` off their own
   profile). **Step 3 then found S36** — a `Friends` screen with no endpoint *and* no entry point
   anywhere in the app. Final range: **S24–S36**. Note S22 and S23 were never allocated.
   Upgrade **S5** (referral) — it now has a whole screen behind it, not a stray signup field.
   **Renumber the four Step 1 `TODO(contract)` markers currently pointing at S30**: `your progress`
   → **S32**, `Customer Support` → **S33**. Only Privacy & policy and Terms & Conditions keep S30.
   Verify with `grep -rn "TODO(contract)" lib/features/profile/` — S30 must appear exactly twice.
5. **`DESIGN_ISSUES.md`** — the third-theme conflict and the one-toggle-vs-two conflict.
6. **`PROGRESS.md`** — Day 8 section, brief index, and the coverage line: **21/21 stable, 22/36
   total, every remaining endpoint draft.**

**Tests:** both privacy toggles round-trip through `PATCH /me`; theme and language switches change
the canvas; every disabled control is present and non-interactive by `Key`.

**Commit:** `feat(settings): Day 8 step 3 — Settings, disabled shells, partner notice`

---

# Definition of done

- [ ] `AccountPlaceholderScreen` is deleted; `/profile`, `/profile/edit` and `/settings` are real.
- [ ] `PATCH /me` consumed. Endpoint coverage **21/21 stable · 22/36 total**.
- [ ] No client-side computation of any displayed number — verifiable by reading the code.
- [ ] Every disabled control has a `Key`, a `TODO(contract)`, and a matching `seif_fight.md` entry.
- [ ] `ProfileCity` is switched on exhaustively at its first real call site.
- [ ] `docs/for_seif_account_surface.md` exists and is sendable without editing.
- [ ] `flutter analyze` clean; full suite green; existing goldens untouched.
- [ ] Three commits, one per step.

---

# Out of scope — do not build

- **Leaderboard tab** — both endpoints draft. Still a placeholder after Day 8.
- **Message tab** — fully designed (`Messages`, `Customer support chat`, `Create Ticket`,
  `Customer Support` ×3) and **has no endpoint of any kind**. Its own day, once a contract exists.
- **Notifications screen** (conflict 10).
- **`your progress`** and **`Favorite questions`** as working screens — rows are disabled in Step 1.
- **Subscription / Paymob** — routes to the existing placeholder and stops.
- **`PUT /me/avatar`**, **`PUT /me/fcm-token`** — draft.
- **Account recovery** — four draft endpoints, no design in this cluster.
- **The `/track-select` orphan route** — still out of scope.
- Writing legal copy for Privacy & policy or Terms & Conditions.
