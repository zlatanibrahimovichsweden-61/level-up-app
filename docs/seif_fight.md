# Contract history & questions for Seif — the backend counterpart to DESIGN_ISSUES.md

> Everything the **contract** can't answer, contradicts, or leaves us guessing goes here — one
> place, so nothing gets lost in chat and Seif gets a single list rather than a trickle.
>
> Contract: `contract/openapi.yaml` (vendored, pinned commit 184d6ec — v3.0.0-m1, 2026-09-04) · App repo: `level_up_app`
>
> **Ground rule stays: the contract wins.** Where the contract is silent we build the safe
> thing, ship it, and log it here. Nothing in this file blocks a build — it records what we
> assumed and what we need confirmed so the assumption can be replaced.
>
> **Restructured 2026-09-05 (Phase 3B).** This file now has two parts. **Part A** is the
> contract-change ladder — a level-by-level history of every pin this app has carried: what
> each pin communicated, what the client built against it, what changed later, what the rework
> cost, and an engineering-impact score per transition, so the cost of contract instability is
> visible rather than anecdotal. **Part B** is the live question register (S1–S44) this file
> has always been — nothing in it is deleted; a handful of entries are updated where a later
> pin re-anchored their citations or narrowed their asks (S6, S37), and three new entries
> (S39–S41) are filed from the 2026-09-04 Phase 2 contract-impact audit. Part A records history
> and accountability; Part B records open questions. Neither blocks a build.

---

## Part A — Contract change ladder

### A.0 How to read this ladder

**Levels are vendored pins, not every published version.** `contract-changelog.md` publishes a
new `info.version` far more often than this app re-vendors `contract/`. A "LEVEL" below is a
commit this app actually pinned (`contract/SOURCE.md`); a published version the app skipped past
without ever building against it in isolation is recorded as **absorbed** or
**skipped-then-absorbed** inside the level that eventually adopted it, not scored on its own —
the client was never exposed to it as a standalone state. **LEVEL 0** predates any contract and
carries no score.

**Labels used throughout Part A (verbatim, bold):** **Historical**, **Superseded**, **Current**,
**Open question**, **Backend dependency**, **Confirmed fact**, **Unverified assumption**.

**Evidence categories for behaviour claims (verbatim, bold):** **Confirmed by contract** ·
**Confirmed by client implementation** · **Confirmed by staging** (date + build) · **Not yet
observed on the wire** · **Unverifiable from outside the private backend repo**.

**Scoring anchors** — applied identically to every transition (LEVEL 1→2, 2→3, 3→4). Each
dimension scores 0–5 against the anchor in the matching column; scores are **summed for
comparability only**, never converted to hours or developer-days.

| Dimension | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| API/schema (contract side) | none | prose only | additive on draft / optional fields | additive on stable needing client handling (codes, responses) | breaking on a stable schema (field removed/renamed/required added) | multiple breaking items, or a path removed plus a breaking schema |
| Model changes (client) | none | comment | one model, additive | one model restructured or several additive | several models restructured/regenerated | new type hierarchies across features |
| UI changes | none | copy only | one widget | one screen or several widgets | several screens | a surface removed/added across screens + router |
| Business-logic | none | comment | one rule | several rules in one feature | rules across features | architectural |
| Test changes | none | one test | a few tests in one file | several files, or assertions inverted (green-and-wrong) | across features or ≥30 tests net | suite-wide |
| Mock/fixture | none | comment | one handler/fixture | several handlers or shapes | mock rewrite across features | — |
| Documentation | none | pin bump only | one record | a reconciliation set (decisions + design issues + S-entries) | plus a new brief or audit document | cross-cutting incl. instruction set / several briefs stamped |
| Deleted/reworked implementation | none | comments | one element removed | a feature-internal surface removed or rebuilt | shipped work across ≥2 features deleted/rebuilt | a whole product surface deleted |
| Verification blockage | none | minor | change unverifiable on the wire for reasons external to it | behavioural change with zero build signal | the specific change cannot be observed on staging | cannot be observed AND backend version unconfirmable AND required routes missing |

**Bands:** 0–10 LOW · 11–20 MEDIUM · 21–30 HIGH · 31+ CRITICAL (max 45, nine dimensions × 5).

**Caveat, stated once, applying to every score below:** these are **ordinal judgements**,
anchored on the table above and assigned by the phase lead reviewing the whole transition, not
re-derived by whoever next edits this file. They are summed only so two transitions can be
compared side by side (A.6), never to produce an hours/days estimate. Where the arithmetic band
and the lead's qualitative reading of the same transition disagree, **both are shown** — the
qualitative reading is a second, independent signal, not a veto of the number.

---

### LEVEL 0 — Pre-contract product briefs (2026-06) — provenance, not a contract level, NO score

The Paymob web-checkout hand-off and the Fawry `pending`-until-paid state that this app's
instruction layer taught for six weeks trace to no pinned contract at all. They come from the
2026-06 product briefs, outside this repo:
- `F:\level\00_project_brief_and_team_model.md:110` — "Fawry via the existing Paymob account
  (incl. cash-by-reference-code, `pending`-until-paid state)"
- `02_role_flutter_partner.md:7,19` — "the paywall screens and the hand-off to the external
  Paymob web checkout"
- `04_interfaces_and_handoff_contract.md:76`
- `F:\level\CLAUDE.md:11-12` — the owner's own standing instructions, stating the same hand-off

**Confirmed fact.** No vendored contract version ever specified a Fawry `pending` state.
`/checkout/sessions`'s description at pins 1–3 read "There is NO pending state and the payment
webhook is backend-internal"; pin 4's `GET /me/entitlements` (`openapi.yaml:754`) reads "There is
no `pending` state — an entitlement is active or it isn't." The word `Fawry` never appears in any
contract file at any pin. `EntitlementState` has been `required: [type, active, inGrace]` at
every pin — no `SubscriptionStatus` schema, ever. The contract carried the Paymob checkout only
as the draft `POST /checkout/sessions` (present 1.0.0-m1 → 2.1.0-m1), deleted at 2.2.0-m1 as "a
product decision, not a deferral" (`contract-changelog.md`, 2026-08-19).

What the client built from the briefs, before or beside the contract: the `/subscription` +
`/subscription/return` routes and `TODO(deep-link): register the Paymob return route scheme once
Seif provides it`, in the very first scaffold commit `5e4a512` (2026-07-22) — **one day before
the contract was first vendored**; and the instruction set
(`.claude/skills/{level-up-domain,river,screen-states,build-screen,seif-api-contract}/SKILL.md`,
`river/evals/evals.json`, `F:\level\CLAUDE.md`) teaching the Paymob hand-off and a Fawry pending
state. By contrast, `lib/features/profile/models/entitlement_state.dart:14` has said "adr-020:
card payments have NO pending state" since it was written — **the Dart followed the contract; the
instructions followed the briefs.**

**Superseded** for the mobile app by adr-049 §3 (contract 2.2.0-m1). The instruction set was
corrected 2026-09-05 (Phase 3B, workstream W2).

**Stated plainly, with no blame assigned:** the contract was internally consistent on this point
from its first draft. The product briefs and this app's instruction layer were not updated when
the product direction changed. The briefs at `F:\level\*.md` remain uncorrected — they sit
outside this repo and outside this phase's scope. **Superseded (out-of-repo, not edited).**

---

### LEVEL 1 — Contract 1.0.0-m1 (pin 23f0535)

#### Contract (Version · Pin · Source · Date/commit)
1.0.0-m1, drafted 2026-07-19 (33 paths; scaffold 2026-07-18). Pin `23f0535`, vendored
2026-07-22, mirrored into the app at commit `47d15a2` (2026-07-23). Source:
`contract-changelog.md` 2026-07-18/2026-07-19 entries.

#### What was communicated
**Confirmed by contract.** Stable: OTP request/verify, discriminated `POST /auth/register`
(school | university bodies, no `device`), refresh (rotation + reuse detection), logout, all
seven `/reference/*` pickers, `GET`/`PATCH /me`, `GET /me/entitlements`, catalog (subjects + tree
with `answered`/`total`), the quiz loop (create → per-question answer, idempotent → finish,
idempotent) + AI explanation. Draft: recovery (4 steps), custom avatar upload, FCM token, quiz
history/review, favourites, checkout sessions, code redemption, leaderboard + self-rank.
`SchoolRegistration` carried `schoolName` as a real field; no `device` object existed anywhere;
several schema descriptions were corrupted by unquoted YAML flow mappings (repaired at 1.1.0-m1;
the Day 7c diff counted five, not the changelog's six — S21).

#### What the client implemented
**Confirmed by client implementation** — commits, files, +/− from `git show --stat`/reportC:
`47d15a2` vendors the contract (20 files +1984/−27) · `99ef322` Login+OTP (39, +3743/−16) ·
`b3683c6` refresh/route-guard (20, +1067/−29) · `08a0b61` Sign Up_1/2 (26, +4892/−4) ·
`57fab32` (2026-07-26, Day 3) registration incl. `POST /auth/register` v1.0 shape — no `device`,
has `schoolName` (48, +6554/−46) · `8d5fc9f` (Day 4) Home/`GET /me` (36, +6279/−3) · `9fa2a61`
(Day 5) catalog (41, +5863/−15) · `c2ddc30` (Day 6) uni parity (36, +2772/−193) · `7dff9e5`
(2026-08-04, Day 7) quiz engine (63 files, +10917/−120) — **no commit body, no test count
recorded**, and this same commit re-pins the contract to `ee2ed8f` (1.1.0-m1).

Two things built here outlived their contract basis: `limit_sheet.dart` (created at `7dff9e5`,
136 lines, Upgrade `FilledButton` + benefits card) and the ten-field `QuizSummary` (incl.
`totalPoints`/`level`, also `7dff9e5`) — see Transition C, LEVEL 3. The `/subscription` routes
are **LEVEL 0** work (built a day before this pin existed).

#### What changed later — Transition A: 1.0.0-m1 → 1.1.0-m1
2026-07-30, adr-028. **Breaking: yes**, on stable paths. City union — `cityId` OR `cityName`, at
least one required, both → `validation_failed`; `schoolId` optional for every school-track
student (was Egypt-required); **`schoolName` removed from the contract entirely** — "rejected
server-side as an unknown property" (`contract-changelog.md`, 2026-07-30); `StudentProfile
.geography.city` becomes a union; `country_not_found` + `rate_limited` added; corrupted
schema descriptions repaired (the changelog says six; the Day 7c diff found five — S21).

**This contract update invalidated previously implemented client work** — `schoolName`, end to
end.

**Gap facts.** `schoolName` was built 2026-07-26 (`57fab32`); the contract changed 2026-07-30 —
**4 days** later; the new pin was vendored 2026-08-03, inside the Day 7 commit `7dff9e5`
(2026-08-04), which **has no commit body**; the reconciliation landed 2026-08-05 (Day 7c).
Between publication (2026-07-30) and reconciliation (2026-08-05), two feature commits landed on
the old pin: `c2ddc30` (Day 6, 2026-07-30 — the same day the change was published) and
`7dff9e5` (Day 7, 2026-08-04 — which re-vendored the new pin without reconciling the
registration and profile code it invalidated). Days 4 and 5 (`8d5fc9f` 07-28, `9fa2a61` 07-29)
predate the publication and were built against a pin that was still current.

#### Rework required — Day 7c, 2026-08-05 (seven commits)
`2b02a11` (17 files +456/−258, tests → 570) → `ffe16c8` (3, +141/−15, → 578) → `7fdc16b` (12,
+621/−42, incl. new `city_field.dart`, → 590) → `26ebba9` `ProfileCity` sealed union (5, +544/−52, → 596)
→ `bc5ed2b` 429/404 mapping (12, +259/−6, → 608) → `ff23317` mock v1.1 (2, +571/−13, → 625) →
`b1b6416` docs (7, +874/−5, count unchanged at 625).

`2b02a11`'s body, quoted: "schoolName is deleted, not deprecated… rejected server-side as an
unknown property." Deleted end to end: the draft field on both registration bodies, the doc
comments, the `freeTextSchool` branch, the controller setter, the screen branch, the
`SchoolNameField` widget, `ProfileSchool.schoolName`. `ffe16c8` **inverted two assertions** —
"Egypt REQUIRES governorate + city + school", an incomplete-draft test — the "green-and-wrong"
case: tests that passed while asserting a rule the new contract had made false.

#### Evidence
Commits above (reportC §1). `D-004` (`DECISIONS.md`) records the sharpest single defect this
transition produced: under 1.0.0-m1 the client modelled city as a bare `NamedRef` with a
non-null `id` — a free-text city would have **thrown on a well-formed `GET /me`**, the only
drift in this bump that was a runtime crash rather than a wrong message. It was free to fix on
Day 7c because `ProfileGeography.city` had zero call sites anywhere in `lib/` at that point; Day
8 is the day that stopped being true. Docs: `b1b6416`, 7 files +874/−5 — `DECISIONS.md` +103
(D-003/D-004/D-005), `DESIGN_ISSUES.md` +58 (#44), `PROGRESS.md` +59, a new 572-line
`day7c_contract_v11_brief.md`, `seif_fight.md` +77 (S20/S21 filed here).

#### Engineering impact
| Dimension | Score | Basis |
|---|---|---|
| API/schema | 4 | Breaking: yes on stable — register bodies, `GET /me` shape; +404/+429/+400 |
| Model changes | 4 | `SchoolRegistration`, `UniversityRegistration`, `StudentProfile` → `ProfileCity` sealed union with hand-written `toJson` (D-004), `ProfileSchool`; regenerated |
| UI changes | 3 | `SchoolNameField` deleted; city escape + school skip built ahead of the design, new `city_field.dart` (D-003/D-005) |
| Business-logic | 3 | body factory `cityId` XOR `cityName`; validation rules inverted; `RegistrationDraft` field |
| Test changes | 4 | 563 → 625 across the seven commits (570/578/590/596/608/625); two assertions inverted — "green and wrong" (`ffe16c8`) |
| Mock/fixture | 3 | `ff23317` +571/−13: city union, no `schoolName`, 429/404 paths |
| Documentation | 4 | `b1b6416` 7 files +874/−5: new 572-line Day 7c brief, D-003/004/005, DESIGN_ISSUES #44, S20/S21, PROGRESS |
| Deleted/reworked implementation | 4 | `schoolName` end to end in registration AND profile — field, widget, setter, validation, 2 ARB keys, tests; built 2026-07-26, rebuilt 2026-08-05 — **10 days** |
| Verification blockage | 2 | no real server existed anywhere in Level 1 (`TBD.example`), so the runtime-crash class (free-text city on a well-formed `GET /me`) was undetectable by the suite — external to the change itself |
| **TOTAL** | **31** | **Band: CRITICAL** (at the threshold) |

**Lead's qualitative reading: HIGH** — the largest single-day reconciliation in the repo (7
commits, a runtime-crash class caught, shipped work deleted), mitigated by no real user having
been served yet. Both readings are shown per A.0.

#### Rework summary
Counted from git only: `schoolName` removed end to end (field, `SchoolNameField` widget,
controller setter, validation branch, 2 ARB keys, tests) 10 days after being built; two test
assertions inverted ("green and wrong"); mock rewritten (+571/−13); 7 documentation files
touched (+874/−5).

#### What should have happened
Objective, no blame. Registration was built 2026-07-26 (`57fab32`) — four days after the pin was
vendored (2026-07-22) and four days before the 1.1.0-m1 change was published (2026-07-30). The
new pin was vendored four days after publication (2026-08-03) and reconciled two days after that
(2026-08-05): a six-day window in which Day 6 and Day 7 were committed on the old pin, and in
which the Day 7 commit vendored the new contract without reconciling the code it invalidated.
Building `schoolName` against a four-day-old contract was an ordinary timing risk on a
fast-moving spec, not on its own a process failure; the repeatable lesson is the six-day window:
**check `contract-changelog.md`'s newest entry against the vendored pin before starting each
day's feature, not only when a build breaks — and never vendor a new pin inside a feature commit
without reconciling against it in the same step.**

---

### LEVEL 2 — Contract 1.1.0-m1 (pin ee2ed8f)

#### Contract (Version · Pin · Source · Date/commit)
1.1.0-m1, published 2026-07-30 (adr-028). Pin `ee2ed8f`, vendored 2026-08-03, mirrored into the
app inside `7dff9e5` (2026-08-04, Day 7 — the same commit that shipped the quiz engine and
carries no commit body).

#### What was communicated
**Confirmed by contract.** The city union, optional `schoolId`, no `schoolName`,
`country_not_found`/`rate_limited` — see Transition A above; this is the state the app carried
through the whole of Day 7c and Day 8.

#### What the client implemented
**Confirmed by client implementation.** Day 7c's seven commits (Transition A's "Rework
required", above) brought the app onto this pin. Built directly on top of it afterward: Day 8 —
`6edf922` Profile hub, **adds** a disabled Subscription row (18 files +2232/−16) · `fdf8d73` Edit
Profile/`PATCH /me`, commit body claims "21/21 stable" (18, +2768/−18) · `81d4ea2` Settings (28,
+2811/−50, tests → 764) · `6f96cbc` l10n. `seif_fight.md` S20/S21 (Day 7c) and S24–S36 (Day 8)
are filed against this pin.

#### What changed later — Transition B: 1.1.0-m1 → 2.1.0-m1
**Skipped-then-absorbed**, four published versions the app never vendored on their own, all
folded into one 2026-08-22 commit:
- **1.2.0-m1** (2026-08-11, adr-036/037/038) — **BEHAVIOURAL**: catalog gated on release ∩
  entitlement (two independent gates), `[]` becomes a normal response, `termId`/`termNumber`
  additive, draft `GET /catalog/modules`.
- **1.2.1-m1** (2026-08-11) — **no**: real staging host replaces `staging.TBD.example`.
- **1.3.0-m1** (2026-08-13) — **no**: `429` on the four unbuilt `/reference/*` pickers,
  `400`/`404` on `/reference/schools`, 8 not-found codes registered.
- 1.3.0-m1 prose fix (2026-08-15) — **no**, no version bump: `recovery_unavailable` description
  corrected.
- **2.0.0-m1** (2026-08-16, adr-019) — **yes, "the first genuinely breaking change this contract
  has ever shipped"** (`contract-changelog.md`): `device` becomes REQUIRED on both registration
  bodies.
- 2.1.0-m1 (2026-08-16) — **no**: `POST /auth/recovery/new-phone` declares a `400` it always
  returned. **This is the pin.**
- **1.4.0-m1 is invalid** — published 2026-08-14, reverted ~15 minutes later, no changelog
  entry; permanently skipped.

**The previously communicated contract behaviour was later superseded, requiring client rework**
on two fronts: the catalog gate (BEHAVIOURAL, appeared and later reversed — see Transition C)
and `device` (structurally required, never actually exercised against a live server before the
client caught up).

#### Rework required — 89a8a88 (2026-08-22) + 67bdcc1
`89a8a88`: 20 files +618/−127. Commit body: "BUILD VERIFIED only as part of the whole
uncommitted tree (validate.ps1, 856 passed). This commit in isolation is SOURCE VERIFIED." Adds
`{required DeviceInfo device}` to both `fromDraft` constructors, `RegistrationSubmitNotifier`,
and 3 test files (`57fab32`'s `school_registration.dart` had no `device` at all). `67bdcc1`
adopts the real staging host in one file, +16/−5.

Follow-ups the `89a8a88` commit body names but does **not** do: an empty-catalog UI state (the
lead independently verified `subjects_screen.dart:69` already had a "No subjects yet" empty
state since Day 5 — **the follow-up was moot**), cached-`subjectId` 403 handling, `termNumber`
ordering, two AR/EN 404 strings. `termNumber` ordering and the two 404 strings remain open
follow-ups recorded only in the `89a8a88` commit body — no S-entry exists for them.

#### Evidence
`89a8a88` (Confirmed by client implementation) + `67bdcc1`. No standalone reconciliation
document was written for this pin — the follow-ups live only inside the `89a8a88` commit body,
not in `DECISIONS.md` or `DESIGN_ISSUES.md`. `day9_quiz_review_brief.md` (`0451284`,
2026-08-20) was written against this pin.

#### Engineering impact
| Dimension | Score | Basis |
|---|---|---|
| API/schema | 4 | 2.0.0-m1 Breaking: yes — `device` required on both stable register bodies; 1.2.0-m1 BEHAVIOURAL catalog gating; 1.3.0-m1 +429 ×4, +400/404 on schools, 8 codes; 1.2.1-m1 real server URL; 1.2.0-m1 `termId`/`termNumber` additive; draft `/catalog/modules` |
| Model changes | 3 | `Subject` + `ProfileUniversity` gain `termId`/`termNumber` (nullable); both registration bodies gain `device` |
| UI changes | 0 | none required — the "No subjects yet" empty state already existed since Day 5; `termNumber` ordering and the two 404 strings remain **Open question** follow-ups |
| Business-logic | 2 | `RegistrationSubmitNotifier` resolves `device` inside `AsyncValue.guard` |
| Test changes | 3 | 3 registration test files (several files), +94 lines; 856 passed whole-tree |
| Mock/fixture | 0 | no mock file touched in `89a8a88` |
| Documentation | 1 | `SOURCE.md` + vendored changelog only — no reconciliation record; follow-ups live only in the commit body |
| Deleted/reworked implementation | 2 | `fromDraft` signatures rewritten across both tracks; nothing deleted |
| Verification blockage | 3 | the BEHAVIOURAL catalog gate had zero build signal and could never be observed — `/catalog/subjects` answered 404 on staging on 2026-08-23 (`0b53cdc`) and `200 []` on 2026-09-04 (`78c6e5d`, built 2026-09-03); the deployment moment in between was not observed; 2.0.0-m1's "who is affected: nobody" held for live integrations, but the client had carried device-less bodies since `57fab32` |
| **TOTAL** | **18** | **Band: MEDIUM** |

**Lead's qualitative reading: MEDIUM** — four published versions absorbed in one 20-file commit;
the cost was mostly the un-observable behavioural change and the un-done follow-ups, not code
volume.

#### Rework summary
`device` added to two registration bodies + notifier + 3 test files; real host swapped in one
file; the "empty catalog" follow-up in the commit body turned out to already be built (moot);
`termNumber` ordering and two 404 strings never done — carried forward as open follow-ups
(recorded only in the `89a8a88` commit body; no S-entry).

#### What should have happened
The contract published the real staging URL 2026-08-11 (1.2.1-m1); the app adopted it in
`67bdcc1` on 2026-08-22, and the first real request followed 2026-08-23. 1.2.0-m1's BEHAVIOURAL
catalog gate published the same day (2026-08-11) and was adopted at `89a8a88` on 2026-08-22 (11
days); for those same 11 days the app carried the Day 5/6 catalog code (`9fa2a61`/`c2ddc30`)
with no gating awareness — harmless in practice because the
client renders whatever set the server returns and already had an empty state; the failure
adr-038 warns about, a client heuristic built on the old set, never existed here.
The lesson from Transition A repeats: a BEHAVIOURAL entry produces zero codegen diff by design
(adr-038), so it will never surface as a compile error — it has to be read, not waited for.

---

### LEVEL 3 — Contract 2.1.0-m1 (pin 61905ce) — absorbs 1.2.0-m1, 1.2.1-m1, 1.3.0-m1, 2.0.0-m1 (1.4.0-m1 invalid)

#### Contract (Version · Pin · Source · Date/commit)
2.1.0-m1, published 2026-08-16. Pin `61905ce`, vendored 2026-08-18, mirrored into the app at
`89a8a88` (2026-08-22).

#### What was communicated
**Confirmed by contract.** `device` required on registration; catalog gated on release ∩
entitlement (two independent gates, adr-036/037); `termId`/`termNumber` additive; the four
unbuilt `/reference/*` pickers declare `429`; eight not-found codes registered.

#### What the client implemented
**Confirmed by client implementation.** `89a8a88` and `67bdcc1` (Transition B's "Rework
required", above) — this is the state the app carried from 2026-08-22 to 2026-09-04. The Day 9
brief (`0451284`, 2026-08-20) targets this pin; the smoke harness commits (`f3edc33`,
`dcd655b`, `b17b7de`) run against it. `seif_fight.md` S37 is filed against this pin (2026-08-23).

#### What changed later — Transition C: 2.1.0-m1 → 3.0.0-m1
**Skipped-then-absorbed**, two published versions plus one prose-only entry, all folded into
four 2026-09-04 commits:
- **2.2.0-m1** (2026-08-19, adr-049) — **no** (the deleted path was `draft`, never implemented,
  never served): `POST /checkout/sessions` deleted, `commerce` tag narrowed to voucher
  redemption only, `payment_initiation_failed` removed from `error-codes.md`.
- 2.2.0-m1 2nd entry, same day (adr-057) — **no**: `x-consumers` added to ten operations.
- 2.2.0-m1 prose fix, same day — **no**, no version bump: two `error-codes.md` Notes cells
  updated for the purchase-silent app.
- **2.3.0-m1** (2026-08-29, adr-091) — **BEHAVIOURAL**: the catalog stops being
  entitlement-gated; `listSubjects`/`getSubjectTree`/`createQuiz` re-stamped `1.2.0-m1` →
  `2.3.0-m1`.
- **3.0.0-m1** (2026-09-03, adr-102) — **yes**: `QuizSummary` loses `totalPoints` and `level`.
  **This is the pin.**

**The previously communicated contract behaviour was later superseded, requiring client rework**
on three fronts at once: the whole purchase surface (2.2.0-m1), the catalog gate direction
reversed a second time (2.3.0-m1), and the result screen's points/level display (3.0.0-m1).

**The changelog itself records that two published statements could not both hold:** the
2026-08-29 entry states the catalog-gating contradiction "has been carried since `1.2.0-m1`…
Both statements were published; they could not both hold" — the 1.2.0-m1 entry said the catalog
was entitlement-gated *and* that an unentitled student had a 50-question weekly allowance, while
Gate B filtered that student's catalog to `[]`, leaving nothing for the allowance to draw from.
Neither operation had actually shipped with Gate B, so this corrected a published intention, not
an already-live behaviour.

#### Rework required — 3db4f04, b7d0dfb, 5c4b855, ce7da9a, 7e7129c (2026-09-04) + the Phase 2 audit + Phase 3B
Excluding `.ai/audits/current/test-results.md` (generated, excluded throughout this ladder):
- `3db4f04` — contract only, 4 files +177/−92, 861 passed.
- `b7d0dfb` — `QuizSummary` model: 15 files +108/−145, 862 passed. Deletes 2 model fields + the
  freezed/`.g.dart` output + the result-screen line + 2 ARB keys × 2 locales + 3 generated l10n
  files; adds 1 forward-compat test proving a 2.x body still parses.
- `5c4b855` — purchase surface removed: 12 files +66/−187, 862 passed. Upgrade button + benefits
  card (net −43 in `limit_sheet.dart`), 2 routes + the `TODO(deep-link)` (net −12; dead 44 days
  since `5e4a512`), the Profile row (net −9; 29 days since `6edf922`), 6 ARB keys × 2 locales
  (net −87 across the two ARB files and the generated l10n); swaps one "row renders disabled" test for one asserting
  absence.
- `ce7da9a` — limit-sheet copy: 6 files +24/−15, 862 passed (D-007).
- `7e7129c` — records: 7 files +534/−19 (docs only).
- Phase 2 audit (`docs/CONTRACT_3_0_0_IMPLEMENTATION_IMPACT.md`, untracked, 1095 lines) found
  the instruction set (six skill files + `F:\level\CLAUDE.md`) still taught the deleted purchase
  surface as of 2026-09-04 (FINDING-01) — corrected in Phase 3B workstream W2, alongside four
  day-briefs stamped, K-3 retired, S6 re-anchored (Part B, below), and this ladder.

#### Evidence
Commits above (reportC §1–2). Quotes: day7 brief — "parses all ten required fields";
`openapi.yaml:1652-1681` now requires eight. `zna.md` (`7e7129c`) records the same outgoing set:
model drops two fields; Upgrade/benefits/routes/Profile row/Paymob references gone. **Confirmed
by staging** (host/commit `78c6e5d`, built 2026-09-03T15:38:17Z): `GET /catalog/subjects`
deployed, answers `200 []` for the test account; `PATCH /me` 405, `GET /me/entitlements` 404 —
unchanged between `0b53cdc` and `78c6e5d` (the 404s were also seen at `fbab748` by curl on
2026-08-21; the 405 was first recorded at `0b53cdc`). **Not yet observed on the wire:** the 3.0.0-m1
`finish` body. **Unverifiable from outside the private backend repo:** whether `78c6e5d` carries
adr-102 at all (`contract/SOURCE.md` self-declares this unverifiable).

#### Engineering impact
| Dimension | Score | Basis |
|---|---|---|
| API/schema | 5 | 3.0.0-m1 Breaking: yes — two required fields removed from a stable response; 2.2.0-m1 path `POST /checkout/sessions` removed + `payment_initiation_failed` removed; 2.3.0-m1 BEHAVIOURAL re-stamp on 3 ops; `x-consumers` ×10 |
| Model changes | 3 | `QuizSummary` restructured + regenerated; forward-compat test added |
| UI changes | 5 | result screen "Level N · P points" removed (D-006); limit-sheet Upgrade `FilledButton` + benefits card removed; Profile "Subscription" row removed; `/subscription` + `/subscription/return` routes removed; sheet bodies rewritten in EN + AR (D-007) |
| Business-logic | 2 | standing now readable only from `GET /me` — the post-finish invalidate already existed; no "empty ⇒ unsubscribed" heuristic ever existed to remove; `getSubjectTree` 403 causes narrowed (FINDING-16, pre-existing) |
| Test changes | 3 | 6 distinct test files touched (4 in `b7d0dfb`, 2 in `5c4b855`, 1 in `ce7da9a`, one shared); one generated test removed, two added; 861 → 862; assertions rewritten to assert absence |
| Mock/fixture | 3 | mock `finish` stops emitting 2 keys; quiz fixtures −8 lines; the idempotency test now reads `/me` |
| Documentation | 5 | `7e7129c` 7 files +534/−19 incl. `zna.md` (139 lines) and the smoke doc (141 lines); Phase 2 audit doc 1095 lines (untracked); Phase 3B: 6 skill files + `F:\level\CLAUDE.md` corrected, 4 day-briefs stamped, K-3 retired, smoke/RISKS school-cohort corrections, this ladder |
| Deleted/reworked implementation | 5 | a whole product surface: routes present since the scaffold `5e4a512` (2026-07-22, **44 days**), the Upgrade button since `7dff9e5` (2026-08-04, **31 days**), the Profile row since `6edf922` (2026-08-06, **29 days**); the result-screen element since `7dff9e5`; 8 ARB keys × 2 locales; **−187 deletions (net −121)** in `5c4b855` |
| Verification blockage | 5 | the 3.0.0-m1 `finish` body has never been observed on the wire; whether staging `78c6e5d` carries adr-102 is unverifiable from outside the private backend repo; `PATCH /me` 405 and `GET /me/entitlements` 404 unchanged between `0b53cdc` and `78c6e5d` (the 404s also at `fbab748`; the 405 first recorded at `0b53cdc`); the quiz loop is gated on seed data for the school-track test account |
| **TOTAL** | **36** | **Band: CRITICAL** |

**Lead's qualitative reading: CRITICAL for verification and instruction-set consequences** (the
auto-loaded skills and `F:\level\CLAUDE.md` still taught the deleted surface until 2026-09-05 —
Phase 2 FINDING-01); **HIGH for code volume alone** (four commits: +375/−439 excluding the generated validation
record, net −64; net −149 excluding the contract-only `3db4f04`).

#### Rework summary
A whole product surface deleted across ≥2 features (quiz result screen, limit sheet, profile,
router, l10n) plus the instruction layer that taught it; one model restructured and regenerated;
−187 deletions (net −121) in the single largest deletion commit (`5c4b855`); zero of it observable on the
wire because the route it would exercise (`POST /quizzes/{quizId}/finish`) has never returned a
body under this pin.

#### What should have happened
2.2.0-m1 was published 2026-08-19 with an explicit instruction: "Flutter partner — what to do:
nothing… If a purchase, pricing or paywall screen exists in the mobile design, it is dead." At
that date the Upgrade button had existed 15 days and the router placeholders 28 days; **the
surface stayed live 16 more days** until `5c4b855`. 2.3.0-m1 (2026-08-29) reversed 1.2.0-m1's
Gate B, and the changelog itself flags the contradiction it resolves. 3.0.0-m1 (2026-09-03) was
adopted the next day (2026-09-04) — fast by this project's own history — but the ten-field
`QuizSummary` it corrected had been rendered on the result screen since `7dff9e5`, **30 days**
earlier. The instruction set (skills + `F:\level\CLAUDE.md`) was the slowest-moving layer of
all: it was still teaching the deleted purchase surface when the Phase 2 audit found it on
2026-09-04 (FINDING-01), and was corrected the next day — a machine-readable contract change does not automatically
propagate to prose that a human (or an agent loading it fresh) reads instead of building
against.

---

### LEVEL 4 / CURRENT — Contract 3.0.0-m1 (pin 184d6ec) — absorbs 2.2.0-m1, 2.3.0-m1

#### Contract (Version · Pin · Source · Date/commit)
3.0.0-m1, published 2026-09-03 (adr-102). **Current** pin: `184d6ec` (full SHA
`184d6ec80cbde708acfe605d00eb8a5c756de797`), vendored 2026-09-04, mirrored into the app at
`3db4f04`. `contract/SOURCE.md`: mirror message "Mirror contract from
level-up-backend@4a8e7cfe63696bbfc2125b158e7ffdbcd149ed27"; the four vendored files are
byte-identical at `184d6ec` and at the earlier commit that actually introduced 3.0.0-m1
(`36a37d1`, 2026-09-03T07:05Z) — `184d6ec` (2026-09-03T09:39Z) changed only the admin-SPA files
this app does not vendor.

#### What was communicated
**Confirmed by contract.** `QuizSummary` retains `quizId`, `score`, `totalQuestions`,
`answeredCount`, `pointsAwarded`, `questions` (required, `openapi.yaml:1681`); `leveledUp`/
`newBadge` are retained as frozen events. The student's current level/points live only on
`GET /me` (`points.school`, `points.university`, `points.total`, `level`, `badges` — unchanged
since the first contract). `StudentProfile.level`: "1–12, thresholds every 500 points; static,
not configurable" (`:1514`). The catalog is browse-only (Gate B removed, adr-091); release-gating
(Gate A) stays university-only (`:795-799`) and school subjects are never release-gated and carry
`termId: null` (`:810`). The app is purchase-silent (adr-049 §3): no in-app checkout of any kind
exists or is coming back. `PATCH /me` accepts exactly five fields (`:663-683`).

#### What the client implemented
**Confirmed by client implementation.** The four rework commits under Transition C, above
(`3db4f04`, `b7d0dfb`, `5c4b855`, `ce7da9a`), plus the records commit `7e7129c`, plus Phase 3B
(this workstream and its siblings W2/W3): the instruction set corrected, four day-briefs
stamped, K-3 retired, this ladder written.

#### What changed later
**Not applicable — this is the current pin.** Nothing has superseded 3.0.0-m1 yet, so there is
no Transition D to score. What follows instead is this pin's own confirmation/open-question
ledger (per A.0's evidence categories), carried over from Phase 2 §9:

| Claim | Category |
|---|---|
| School subjects are never release-gated; a school account's `[]` reflects unseeded (education system, stage) cohort data, not an unreleased term | **Confirmed by contract** (`openapi.yaml:795-799`, `:810`) + **Confirmed by staging** (`78c6e5d`, 2026-09-04 — `Track.school`, `200 []`) |
| The catalog is not entitlement-gated; only quiz creation and question delivery are | **Confirmed by contract** (adr-091, `contract-changelog.md` 2026-08-29) |
| The client parses both the 2.x and 3.x `finish` shapes without a runtime branch | **Confirmed by client implementation** (`b7d0dfb`'s forward-compat test) |
| The 3.0.0-m1 `finish` body's actual wire shape | **Not yet observed on the wire** — the quiz loop is gated on empty seed data for the test account |
| Whether staging `78c6e5d` carries adr-102 at all | **Unverifiable from outside the private backend repo** (`contract/SOURCE.md`) |
| When a point is credited — at `submitAnswer` or at `finish` | **Open question** — contract prose reads "immediately" (`:1036-1039`); adr-102 D2 says the award "is already reflected… in `GET /me`" at finish; the mock does the opposite (FINDING-12). The strong reading (award at answer time) is treated here as an **Unverified assumption**, not a **Confirmed fact**, until observed. Filed as **S39** in Part B. |
| `createQuiz`'s three 403 codes have no stated discriminator | **Open question** — filed as **S40** |
| `getSubjectTree`'s 403 has two causes, one code | **Open question**, pre-existing (dates to 1.2.0-m1) — filed as **S41** |
| Where "flashcards are university-only" lives now that its only machine-readable home (`/checkout/sessions`'s description) was deleted | **Open question** — S6, re-anchored in Part B |

#### Rework required
**Not applicable in the "cost of a past transition" sense — nothing has forced rework against
this pin yet.** What is instead owed, as **Backend dependency**: `PATCH /me` and
`GET /me/entitlements` deployed on staging (S37, two routes); seed data for the school-track
cohort of `+2010000000001`, or a separate university test account (S37 ask 2, corrected wording
in Part B); the account-deletion endpoint (S38); checklist steps 5 (a short-lived token for the
401→refresh→retry pipeline) and 9 (forced 500/429), both from `api-data.md` §4. **Deliberately
not done in this wave**, per `WAVE_STATUS.md` 2026-09-04: the silent auto-retry fix on seven
registration `FutureProvider`s and two more providers; the W3-1 `ref`-after-`await` fix (R-2,
OPEN — MEDIUM); Day 9 quiz review; the account-deletion screen; voucher redemption
(`x-consumers: [web]`, must not be built).

**Source-prose corrections (Dart comments and log strings only — done 2026-09-05, after the
documentation pass):** `tool/smoke/real_api_smoke_test.dart`'s empty-catalog log line no longer
says `v2.1: pre-term accounts` (it now names the unseeded cohort and adr-073) and its
`getExplanation` comment names the one 403 the contract documents there
(`openapi.yaml:1126-1128`); Phase 2 items 17–23 are corrected (`mock_backend.dart` header →
pin `184d6ec`; `session_scope.dart` catalogue note → adr-091; `quiz_bloc.dart` → the `/me`
invalidate lives in `quiz_screen.dart`; `quiz_repository.dart` replay note → `pointsDelta: 0`;
`level_card.dart` S3 `TODO(contract)` retired; the `saveChanges` ARB description no longer
cites the deleted `upgradeCta`), plus `profile_screen.dart`'s row table, `quiz_fixtures.dart`'s
pin and the two registration models' version labels. Item 24 (the "lesson" noun in
`subscriptionRequiredBody`) is user-facing copy and stays with DESIGN_ISSUES #51. The 17 stale
`openapi.yaml:NNN` anchors (Phase 2 FINDING-11) were not re-anchored; the two registration
models now cite the schema name instead of a line.

#### Evidence
`WAVE_STATUS.md` "Contract v3.0.0-m1 adopted — 2026-09-04" table (commit-by-commit
`validate.ps1` counts); `RISKS.md` R-8 (narrowed, not closed, 2026-09-04);
`docs/CONTRACT_3_0_0_IMPLEMENTATION_IMPACT.md` §9 (Backend-Blocked Verification, reproduced in
A.7 below).

#### Engineering impact
**Not scored — there is no transition to score at the current pin.** Transition C, above, is the
score for reaching LEVEL 4 from LEVEL 3.

#### Rework summary
**Not applicable.** See Transition C's rework summary, above.

#### What should have happened
The clearest lesson at this pin is about propagation speed, not about the contract: the schema
change (3.0.0-m1) was adopted in the client code within one day of publication, but the
*product-direction* change it was downstream of (adr-049, 2026-08-19 — the app is
purchase-silent) took 16 more days to reach the UI (`5c4b855`, 2026-09-04), and the instruction
layer was still teaching the old direction on 2026-09-04, when the Phase 2 audit caught it
(corrected 2026-09-05). A schema change fails loud (the compiler flags it); a product-direction or BEHAVIOURAL
change fails silent (adr-038's own point) and the only defence is reading the changelog on a
cadence, not waiting for a build to break.

---

### A.6 Impact summary table

| Transition | Levels | API | Model | UI | Logic | Tests | Mock | Docs | Deleted | Verif. | **Total** | Band | Lead's qualitative reading |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 1.0.0-m1 → 1.1.0-m1 | 4 | 4 | 3 | 3 | 4 | 3 | 4 | 4 | 2 | **31** | CRITICAL (at threshold) | HIGH — largest single-day reconciliation, mitigated by no live user |
| B | 1.1.0-m1 → 2.1.0-m1 | 4 | 3 | 0 | 2 | 3 | 0 | 1 | 2 | 3 | **18** | MEDIUM | MEDIUM — un-observable behavioural change, un-done follow-ups |
| C | 2.1.0-m1 → 3.0.0-m1 | 5 | 3 | 5 | 2 | 3 | 3 | 5 | 5 | 5 | **36** | CRITICAL | CRITICAL for verification/instructions; HIGH for code volume alone |

**Process lessons (objective, no blame), across all three transitions:**
1. **Every transition's most expensive item was a change the compiler could not flag.**
   Transition A's crash class needed no server to exist to be dangerous; Transition B's
   BEHAVIOURAL gate produced a zero-byte codegen diff by design (adr-038); Transition C's
   product-direction change (adr-049) preceded its schema change (3.0.0-m1) by 16 days with
   nothing in the build to mark the gap. **A pinned-contract diff review on a cadence, not only
   at build-break time, is the one intervention that would have caught all three.**
2. **The vendored pin lagged the published changelog in two of three transitions** (A: the new
   pin was vendored 4 days after publication and reconciled 6 days after it, with Day 6 and
   Day 7 committed on the old pin in between; B: 11 days between the 2026-08-11 publication of
   1.2.0-m1/1.2.1-m1 and their adoption on 2026-08-22). This is a client-side habit, not a contract
   defect — `contract-changelog.md` is dated and public; re-diffing it against
   `contract/SOURCE.md` before each day's feature is cheap.
3. **Shipped work invalidated by a later contract move was, every time, work built ahead of or
   beside an unstable surface** — `schoolName`, built four days after the pin was vendored and four
   days before the contract removed it (Transition A);
   the purchase surface, sourced from the pre-contract product briefs rather than the contract
   itself (LEVEL 0, unwound at Transition C). Building against `draft` paths or out-of-repo
   product briefs is a deliberate, sometimes necessary bet against a moving target — the record
   here is what that bet cost each time it did not land, not an argument against ever taking it.
4. **Documentation and the instruction layer are the slowest-moving artifacts, not the
   fastest.** Transitions A and C both score docs 4–5 (dense reconciliation sets); Transition C
   additionally shows a machine-readable schema change (1 day to adopt) outrun by a prose-only
   instruction correction (still wrong 1 day after this phase's own audit found it —
   FINDING-01). Where a rule can be a test, Wave 4's own finding stands: prose rules decay,
   mechanised rules hold (`docs/ENFORCEMENT.md`) — the same logic applies to contract-tracking
   prose, not only to code style.

---

### A.7 Blocked verification ledger

| Level / area | What is blocked | Category | Source |
|---|---|---|---|
| L1–L2 | Every "it works" claim before 2026-08-23 was validated only against `lib/dev/mock_backend.dart` — `baseUrl` was `staging.TBD.example` | **Not yet observed on the wire** (resolved partially at L3) | S1, reportC §4 |
| L3 | 12 of 21 stable ops decoded against staging `0b53cdc` (2026-08-23); `PATCH /me` 405, `GET /me/entitlements` 404, `GET /catalog/subjects` 404 — also seen by direct curl 2026-08-21 (`fbab748`), so not a one-build regression | **Confirmed by staging** (partial) | S37, reportC §4 |
| L4 | 13 of 21 decoded against `78c6e5d` (2026-09-04) — `GET /catalog/subjects` now `200 []`; `PATCH /me` 405 and `GET /me/entitlements` 404 unchanged since `0b53cdc` (the 404s also seen at `fbab748`); the quiz loop (6 operations) unreachable behind the empty catalog | **Confirmed by staging** (partial) | S37 update, `RISKS.md` R-8 |
| L4 | The 3.0.0-m1 `finish` body | **Not yet observed on the wire** — gated on seed data, not on the client | Phase 2 §9A |
| L4 | Whether staging `78c6e5d` (built *after* the mirror commit) actually carries adr-102 | **Unverifiable from outside the private backend repo** | `contract/SOURCE.md` |
| L4 | When a point is credited — `submitAnswer` or `finish` | **Open question**, blocked on either Seif's answer or seeded data | S39, Phase 2 §9C.1 |
| L4 | Account deletion — no endpoint exists to verify against | **Backend dependency** | S38 |
| L4 | Checklist steps 5 (short-lived token → 401→refresh→retry) and 9 (forced 500/429) | **Backend dependency** — needs Seif's cooperation to stage | S37 ask 3, `api-data.md` §4 |

---

### Part B — the question register (S1–S44)

**Filed-at level index** (from `git show <commit>:docs/seif_fight.md`). S1–S19 were all filed in
`7dff9e5` (Day 7, 2026-08-04) — the questions arose from Days 4–7 built on pin `23f0535` (L1),
and that same commit vendored L2 (`ee2ed8f`) · S20–S21 filed at L2 on Day 7c (`b1b6416`,
2026-08-05); S24–S36 filed at L2 on Day 8 (S5/S6 upgraded then) · S37 filed at L3 (2026-08-23)
· S38 filed at L4 (2026-09-04) · S39–S41 filed at L4 on 2026-09-05 (Phase 3B, from the Phase 2
audit §9C) · **S42–S44 filed 2026-09-12** with `docs/day10_mistakes_brief.md`, against **upstream `2dca3c5` (3.13.0-m1)** — ahead of the pin, so **no new LEVEL is allocated in Part A yet**; the re-vendor that would create it is that brief's STEP 0 gate. S22/S23 were never allocated — see the note preserved below the summary table.

## Severity
🔴 Blocks a real user flow · 🟠 Shipped on an assumption that may be wrong · 🟡 Confirm / tidy

## Summary

| # | Question | Sev | Status | Code marker |
|---|---|---|---|---|
| ~~S1~~ | ~~Staging/prod `baseUrl` still `TBD.example` — nothing has ever run against a real server~~ | 🔴 | **Resolved (2026-08-23)** — 12/21 stable ops decoded against staging `0b53cdc` | `app_config.dart:43` |
| S2 | No way to resume an interrupted quiz — `GET /quizzes/{quizId}` is `draft` | 🟠 | Open (Day 7) | — |
| ~~S3~~ | ~~Level thresholds: `GET /me` returns `level` but no target to progress toward~~ | 🔴 | **Resolved by contract prose (2026-09-04)** — `StudentProfile.level`: "thresholds every 500 points; static, not configurable" | `level_card.dart:21` |
| S4 | Units/Chapters rows show a % progress the contract cannot supply | 🔴 | Open | `tree_list_row.dart` |
| S5 | Referral is a designed SCREEN with no contract, not the stray signup field we filed | 🟠 | Open (upgraded Day 8) | `registration_draft.dart:18`, `refer_a_friend_screen.dart` |
| ~~S6~~ | ~~Flashcards: full screen designed + sellable entitlement, zero contract support~~ | 🔴 | **Resolved (2026-09-29)** — both operations `stable` since 3.13.0-m1, `flashcardCount` at 3.27.0-m1; built in API→UI Wave 22. Four narrower asks remain (S6, 2026-09-29) | `flashcard_study_screen.dart` |
| S7 | Quiz timer drawn in the design, no field in the contract | 🟠 | Open | — |
| ~~S8~~ | ~~Paymob return deep-link scheme/host not specified~~ | 🟠 | **Withdrawn (2026-09-04)** — adr-049: there is no in-app checkout, so there is no return link to specify | — |
| S9 | University Home "Learning Tools" cards have no endpoint in M1 | 🟠 | Open | `home_screen.dart` |
| S10 | `error-codes.md` mapping is per-feature guesswork | 🟡 | Open | `error_interceptor.dart:9` |
| S11 | Favourites: reading state is stable+required, writing it is draft | 🟡 | Open, built around (Day 7) | `quiz_question.dart:50` |
| S12 | Quiz points in the design are ~20× what the contract can award | 🔴 | Open, built around (Day 7) | `answer_result.dart:36` |
| S13 | Result screen shows a "Pass" verdict; no pass threshold exists | 🟠 | Open, built around (Day 7) | `quiz_summary.dart:97` |
| S14 | Review from HISTORY needs `GET /quizzes/{quizId}`, which is draft | 🟠 | NARROWED — review-from-result shipped Day 8-9, no endpoint | `quiz_review_screen.dart` (doc comment) |
| S15 | Setup draws a question-pool progress bar with no data source | 🟠 | Open, built around (Day 7) | `quiz_setup_screen.dart:24` |
| S16 | Limit sheet says "Daily"; the contract limit is weekly | 🟡 | Open, built around (Day 7) | `limit_sheet.dart:16` |
| S17 | AI explanation is drawn as TWO sections; the endpoint returns ONE string | 🟠 | Open, built around (Day 7) | `ai_explanation_panel.dart:9` |
| ~~S18~~ | ~~`AnswerResult.pointsDelta` — "original result" vs "0 on retry replay"~~ | 🟢 | **Resolved (2026-09-04)** — adr-102 D2: the field doc governs; a replay returns `pointsDelta: 0`, which the mock already did | `mock_backend.dart:_submitAnswer` |
| S19 | No quiz endpoint returns a subject name; two frames show one | 🟡 | Open, built around (Day 7) | `quiz.dart:32` |
| S20 | `PATCH /me` cannot edit school or geography — one design option you offered is unbuildable | 🟠 | Open (Day 7c) | `openapi.yaml:614-624` |
| S21 | v1.1 internal inconsistencies found by diffing the vendored contract | 🟡 | Open (Day 7c) | `openapi.yaml:483`, `:1281` |
| S24 | Solved Questions — no lifetime answered counter exists anywhere | 🔴 | Open (Day 8) | — (omitted) |
| S25 | Rank "HERO" — no rank tier string; `level` is an int and `badges` is an int | 🔴 | Open (Day 8) | — (omitted) |
| S26 | Settings Mode draws three themes; the app has two palettes | 🟠 | Open (Day 8) | `settings_screen.dart` |
| S27 | Show Rank is one switch; the contract has two independent booleans | 🟠 | Open (Day 8) | `settings_screen.dart` |
| S28 | Notification Preferences — four toggles, nothing persists them | 🟠 | Open (Day 8) | `settings_screen.dart` |
| S29 | Upload photo — `PUT /me/avatar` is draft AND moderated | 🟠 | Open (Day 8) | `avatar_sheets.dart:121` |
| S30 | Privacy & policy / Terms — no endpoint needed, but NO COPY SUPPLIED | 🟠 | Open (Day 8) | `profile_screen.dart` ×2, `legal_document_screen.dart` |
| S31 | Go to Uni — track switching; no endpoint, and adr-003 makes it a data-model question | 🔴 | Open (Day 8) | `profile_screen.dart` |
| S32 | "your progress" — a designed screen with no endpoint of any kind | 🟠 | Open (Day 8) | `profile_screen.dart` |
| S33 | Customer Support — fully designed, zero endpoints | 🟠 | Open (Day 8) | `customer_support_screen.dart` |
| S34 | **`parentPhone` is WRITE-ONLY** — required at registration, absent from `GET /me` | 🔴 | Open (Day 8) | — (row not built) |
| S35 | `GET /me` returns raw wire codes with no display names | 🟠 | Open (Day 8) | `edit_profile_screen.dart` |
| S36 | A `Friends` screen exists, with no endpoint and no entry point | 🟡 | Open (Day 8) | `friends_screen.dart` |
| S37 | **Staging does not serve two stable routes** — `PATCH /me` 405, `/me/entitlements` 404 (`/catalog/subjects` answers `200 []` on `78c6e5d`, built 2026-09-03, observed 2026-09-04) | 🔴 | Open, narrowed (2026-09-04) | `tool/smoke/real_api_smoke_test.dart` |
| S38 | **Account deletion has no endpoint** — required by Google Play and Apple 5.1.1(v); never filed until now | 🔴 | **Narrowed** (2026-09-12) — ask (1) answered upstream; the screen is still unbuilt | `docs/STORE_READINESS.md` §6 |
| S39 | When is a point credited — at `submitAnswer` or at `finish`? | 🟠 | Open (2026-09-05, from the Phase 2 audit §9C) | `mock_backend.dart:_finishQuiz` |
| S40 | `createQuiz`'s three 403 codes have no stated rule for which applies when | 🟠 | Open (2026-09-05, from the Phase 2 audit §9C) | `quiz_repository.dart` / `limit_sheet.dart` |
| S41 | `getSubjectTree`'s 403 has two causes and one code, no discriminator | 🟡 | Open (2026-09-05, from the Phase 2 audit §9C) | `catalog_states.dart:51` |
| S42 | `getMyMistakes` — are `termId`/`termNumber` always present-and-nullable, or genuinely optional? | 🟠 | Open (2026-09-12, Day 10 brief) | not yet built |
| S43 | A leaf badged "8 mistakes" replays a 10/30/50-question *ever wrong* quiz — no guidance on what to show | 🟠 | Open (2026-09-12, Day 10 brief) | not yet built |
| S44 | Neither Mistakes operation can be exercised: the only test account's catalog is empty, so it can never have a wrong answer | 🔴 | Open (2026-09-12, Day 10 brief) | `tool/smoke/real_api_smoke_test.dart` |
| S45 | `updateMyProfile`: is an unknown (well-formed) `avatarId` a 400 or a 404, and is `errors` always on its 400? | 🟡 | Open (2026-09-28, API→UI Wave 20) | `lib/dev/mock_backend.dart` (`_profilePatchViolations`) |

> **S22 and S23 were never allocated.** Not a gap in the record — the numbers were skipped when
> the Day 8 brief reserved S24 onward. Nothing is missing; do not renumber to close it, because
> every `TODO(contract)` in `lib/` and the partner notice both cite these numbers.

---

## S1. 🔴 We have never made a single real request

**Where:** `contract/openapi.yaml` `servers:` → `https://staging.TBD.example/api/v1`.
**What:** every flavor points at a placeholder host. `.example` is a reserved TLD, so it fails
closed rather than leaking traffic somewhere real — but it means **every "it works" claim in this
repo is validated only against our own 641-line mock** (`lib/dev/mock_backend.dart`), which by
construction encodes the same assumptions as the client it's mocking.
**Ask:** the real staging host, even an unstable one behind a VPN. One afternoon against a real
server is worth more than another week of mock-green.

**Resolved 2026-08-23.** The host is `https://level-up-backend-staging.up.railway.app/api/v1`
(`app_config.dart:43`, verbatim from the contract's `servers:` block). The smoke harness
decoded 12 of the 21 stable operations against backend commit `0b53cdc` through the real
client seam; every answer arrived either as a model or as a typed `AppException`. What the
server does *not* yet serve is S37.

## S2. 🟠 An interrupted quiz cannot be resumed

**Where:** `GET /quizzes/{quizId}` — `x-stability: draft`.
**What:** `POST /quizzes` returns the questions once, at creation. If the app is killed mid-quiz
(call comes in, OS reclaims memory, student switches away), there is no stable endpoint to fetch
that quiz back. Answers already submitted via `POST /quizzes/{quizId}/answers` are safely recorded
server-side, but the client cannot rebuild the screen.

**What we built (Day 7):** quiz state is **in-memory only**. An interrupted quiz is lost and the
student starts a new one. We deliberately did **not** cache the `Quiz` payload to Hive, because
`POST /quizzes` explicitly frames the question bank as the product ("correct answers never ship
with questions — content protection"), and writing questions to disk cuts against that.

**Ask Seif:**
1. Is `GET /quizzes/{quizId}` going to be promoted to `stable` in M1? If yes, we wire resume and
   delete the local workaround.
2. If not — is a partially-answered quiz **abandoned** server-side, or does it stay open and keep
   counting against the free plan's 50-questions/week allowance? A student who loses signal twice
   could burn their weekly quota on quizzes they never finished. That is a product problem, not
   just a client one.
3. Related: is there a "abandon/cancel quiz" call we should make on exit, or does the server time
   them out on its own?

## S3. 🔴 `level` has no threshold to progress toward

**Where:** `GET /me` → `StudentProfile.level` (int 1–12), `points` (int).
**What:** Home draws a progress bar toward the next level. The contract gives the current level
and current points, but never the points needed to reach level N+1 — so the bar has a numerator
and no denominator.
**Ask:** either a `nextLevelAt` / `pointsToNextLevel` field on `StudentProfile`, or a static
thresholds table we can hard-code (and a promise it won't move server-side without a contract bump).

**Update 2026-09-04 — answered by the contract itself, and had been for a while.**
`StudentProfile.level` carries the description *"1–12, thresholds every 500 points; static, not
configurable."* (`openapi.yaml:1514` at the 3.0.0-m1 pin, and already present at 2.1.0-m1), and
adr-102's changelog entry restates it as the result-frame meter formula `(points.total mod 500) / 500`.
That is the static thresholds table plus the no-move promise this entry asked for. `level_card.dart`
already builds the Home bar on it (`kPointsPerLevel = 500`, `kMaxLevel = 12`). Closed; nothing further
owed — the entry stayed open only because nobody re-read the field description after Day 4.

## S4. 🔴 Units/Chapters progress % has no source

**Where:** `UniversitySubjectTree` / school tree payloads.
**What:** the Learn drill-down rows are designed with a per-row completion percentage. Nothing in
the tree response carries per-unit or per-chapter completion.
**Ask:** add per-node progress to the tree payload, or confirm the design should drop the bars.
Currently built to render only when a value exists.

## S5. 🟠 Referral is a designed product surface, not a stray signup field

> **Upgraded 2026-08-06 (Day 8).** This was filed as one orphaned input. It is bigger than that.

**Where:** Sign Up_1 (`337:15875`) has an Invitation Code field. `POST /auth/register` has no
matching property in either `SchoolRegistration` or `UniversityRegistration`.
**What:** we render the field (design) but **never submit it** (contract). A student can type a
referral code and it silently evaporates.

**What Day 8 found.** The Account cluster contains a whole **`Refer a Friend`** screen. So referral
is not a leftover field somebody forgot to delete — it is a feature with an entry point on the
Profile hub, a screen, a sharing flow and an implied reward, and **none of it has a contract**.
That changes the question from "should we keep this input" to "is this feature in milestone 1".

There are three parts, and they are separable:

| Part | What it needs |
|---|---|
| Accepting a code at signup | a field on `POST /auth/register` + an error code for an invalid one |
| Handing a student their own code | something on `GET /me`, or an endpoint that mints one |
| Paying the reward | an attribution model — who gets what, when it lands, which point pool (adr-003) |

We are shipping `Refer a Friend` as a **disabled shell** (`lib/features/account_shells/screens/refer_a_friend_screen.dart`)
— the screen renders, the share control is dead. Deliberately **no invented code**: a plausible
string is the one thing on that screen a student would act on, and they would share something
meaningless with their friends.

**Ask (Seif + PM):** in or out. If in, all three rows above need answers and the middle one is the
blocker for us. If out, the field comes off Sign Up_1 and the screen comes out of the design —
either is fine; today's state is not, because we are asking students for something we discard.

## S6. 🔴 Flashcards: fully designed, sellable, and completely unimplementable

> **Upgraded 🟠 → 🔴 after finding the screen.** This is no longer "an entitlement with no
> endpoint" — there is a finished screen and a nav path to it.

**Where:**
- **Screen: `225:5582`.** Frame is *named* "Quiz page"; its title text reads **"Flash cards"**.
  That mismatch is why it survived every name-based search of the file.
- Lectures tab row (Day 6) draws a **Flashcard** tab — `quiz_type_tabs.dart`, `DESIGN_ISSUES.md` #18.
- `EntitlementType.flashcardSubscription` — a thing a student can **buy**.

**What the screen actually is — a second question renderer, not a quiz state:**
- No options list. MCQ uses a four-button container (`308:5152`); flashcards use one component
  instance, `247:3260` "Component 17" (358×454). It being a *component* means the flip/reveal
  states are variants inside it — hence only one flashcard frame in the whole file.
- The AI icon is explicitly `hidden="true"` (`503:6802`); no AI EXPLANATION panel. No explanations.
- Shares the entire session shell with MCQ: progress bar, `1/10` counter, Confirm, nav bar.

**What the contract has: nothing.** Verified across all 33 paths / 36 operations — no flashcard
content endpoint exists. The word "flashcard" appears exactly **three** times in `openapi.yaml`,
and all three are about *selling* it, never about using it:
- `openapi.yaml:1342` — `EntitlementType: [baseSubscription, flashcardSubscription]`
- `openapi.yaml:1002` — `/checkout/sessions`: *"School students requesting flashcardSubscription
  get `insufficient_scope` (**university-only**)"*
- `openapi.yaml:1027` — the matching 403 on that checkout call

**Flashcards are university-only.** That constraint lives only in a checkout description. It is
consistent with the Flashcard tab sitting on the university Lectures screen, but it should be
stated somewhere a client can act on, not buried in a payment endpoint's prose.

**The orphan error code — this is the strongest evidence something was dropped.**
`contract/error-codes.md:13` defines:

| `flashcard_subscription_required` | 403 | Flashcards require `flashcardSubscription` | University-only |

**No endpoint in the contract can ever return this code.** Error codes do not get invented
speculatively — a bespoke 403 for "you tried to use flashcards without the subscription" implies an
endpoint that *would* serve flashcards was specified and then dropped or lost.

So: a student can pay for `flashcardSubscription`, see a Flashcard tab, reach a finished screen,
and there is no call we can make to fill it. (And `/checkout/sessions` is itself `draft`, so in M1
they cannot even complete the purchase that leads nowhere.)

**What we built (Day 7):** MCQ renderer only, behind a `QuestionRenderer` seam so a flashcard
renderer drops in later without touching the screen, the Bloc or the tests. No stub, no
`isFlashcard` flag, no invented enum member.

**Ask Seif — this one needs a decision, not just an answer:**
1. **Lead with the orphan code:** `flashcard_subscription_required` is defined in `error-codes.md`
   but no endpoint can return it. **Where did the flashcard endpoint go?** That is much harder to
   wave away than "are flashcards in M1?", and the answer probably explains everything else here.
2. If flashcards are in M1: we need the question shape (front/back text? image + prompt + answer?
   self-graded or server-graded?) and a build/serve endpoint.
3. If they are not — **`flashcardSubscription` must not be sellable**, and the Flashcard tab plus
   screen should come out of the design until it is. Selling access to a screen that cannot load is
   worse than not offering it at all.
4. Either way: does answering a flashcard award points? `pointsDelta` assumes a graded MCQ.
5. Confirm **university-only** is intended, and move that rule somewhere a client can read it
   rather than leaving it in a checkout endpoint's description.

**Update 2026-09-05 — citations re-anchored (Superseded lines).** `openapi.yaml:1002` and
`:1027` were deleted with `POST /checkout/sessions` at 2.2.0-m1 (adr-049); `:1342` is now
`:1532`. At 3.0.0-m1 the word `flashcard` appears once in openapi.yaml (the `EntitlementType`
enum, `:1532`), and the university-only rule survives only in `contract/error-codes.md:15`'s
Notes column ("University-only") — prose the changelog says "is never machine-read". Ask 5
therefore stands and is sharper: the constraint has no machine-readable home at all now. The
sentence "(And /checkout/sessions is itself draft, so in M1 they cannot even complete the
purchase that leads nowhere.)" is **Historical** — there is no in-app purchase of any kind
(adr-049 §3). Phase 2 FINDING-08.

**Resolved 2026-09-29 — the contract answered it, and API→UI Wave 22 built it.** Everything above is
**Historical**. Since 3.13.0-m1 the contract carries two `stable`, mobile-only operations:
`getFlashcardsForLecture` (`GET /flashcards/lectures/{lectureId}/cards`, cursor + `pageSize`) and
`setFlashcardSelfGrade` (`PUT /flashcards/cards/{flashcardId}/self-grade`, a closed `{gotIt, again}`,
latest-wins, no points). `flashcard_subscription_required` is no longer an orphan: it is the
`getFlashcardsForLecture` 403 for a used-up weekly preview. University-only is now machine-readable:
`Lecture.hasFlashcards` exists only on `UniversitySubjectTree`. Asks 1-5 are answered: flashcards
are a separate surface, not a renderer inside the quiz; self-graded; no points; university-only.
The app is purchase-silent, so nothing is "sellable" in it. At 3.27.0-m1 (pinned 2026-09-29)
`Lecture.flashcardCount` gives the Flash Card Setup screen its count.

**Four narrower asks remain (filed 2026-09-29):**
1. **Where does the next round start?** The changelog says "one `pageSize=10` page per round" but not
   where round two begins. The app continues at the previous round's `nextCursor` while the
   student stays on Setup, wraps to the start after the last page, and starts over when they leave
   Setup. Confirm, or specify.
2. **The card list's order.** The operation promises "stable and resumable" but names no sort key.
3. **A card delivered in an earlier week.** Is it charged again this week, and gradable before it is?
   The contract says only that a card charged "this week" re-delivers free.
4. **`error-codes.md` still describes `flashcard_subscription_required` as "Flashcards require
   `flashcardSubscription`"**, while `openapi.yaml` defines it as "the free weekly preview is used
   up". Align the registry's wording.

## S7. 🟠 Quiz timer: designed, not specified

**Where:** quiz-taking frames show a countdown. `Quiz` / `QuizQuestion` carry no duration.
**Ask:** is the timer server-authoritative (a per-quiz or per-question limit we must enforce and
that `finish` validates), or purely cosmetic pacing? These are very different builds, and if the
server ever enforces it, a client-only timer is a cheating vector.

## S8. 🟠 Paymob return deep link is undefined

**Where:** `app_router.dart:72` `TODO(deep-link)`; route `/subscription/return` is a placeholder.
**What:** the contract says checkout "returns via deep link" but never gives the scheme or host.
**Ask:** the exact scheme/host, and confirmation of the security model. **We will treat the return
link as a hint to refetch, never as proof of payment** — on return the client re-queries
`GET /me/entitlements` and trusts only the server. Any app on the device can fire that intent, so
if the intended design is "trust the deep-link payload", say so now and we will push back.

**Update 2026-09-04 — withdrawn.** Contract 2.2.0-m1 (adr-049) deleted `POST /checkout/sessions`
and made the app **purchase-silent**: every purchase happens on the website, and there is no deep-link
return. The `/subscription/return` placeholder, the `TODO(deep-link)` in `app_router.dart` and the
disabled Profile "Subscription" row went with the rest of the purchase surface. The security stance
above — a return link is a hint to refetch, never proof of payment — survives as the on-resume refetch
of `GET /me/entitlements`, which is the only entitlement signal the app now acts on.

## S9. 🟠 "Learning Tools" cards have nothing behind them

**Where:** University Home (`125:2373`).
**What:** the frame draws a Learning Tools section with no matching M1 endpoint. Built as a
stub/hidden section (DESIGN_ISSUES #20).
**Ask (Seif + PM):** M1 or later? If later, hide it in the design too.

## S10. 🟡 Error-code mapping is being reverse-engineered per feature

**Where:** `error_interceptor.dart:9`.
**What:** every non-2xx is RFC 9457 ProblemDetails with a stable `code`, which is good — but we
are discovering the code set feature by feature from endpoint descriptions rather than working
from `error-codes.md` as a whole.
**Ask:** the current `error-codes.md`, vendored alongside `openapi.yaml` and versioned with it, so
our mapping can be exhaustive instead of incremental.

## S11. 🟡 Favourites: half a feature

**Where:** `QuizQuestion.isFavorite` is in the **required** list on `POST /quizzes` (stable).
`POST`/`DELETE /questions/{questionId}/favorite` and `GET /me/favorites` are all **draft**.
`mode: favorites` is in the stable `POST /quizzes` enum.

**What:** reading favourite state is stable and mandatory; writing it is draft. So every question
we render carries a flag no student can ever set — `isFavorite` will be `false` for everyone, for
all of M1 — and `mode: favorites` is a stable mode whose only pool is filled by draft endpoints.
The design *does* draw the control (bookmark icon, node `295:3139`, in the quiz header).

**What we built (Day 7):** `isFavorite` is parsed into the model (it's required), no control is
rendered, `mode: favorites` is not offered.

**Ask:** is favourites in M1? If yes, promote the three endpoints and we ship the star. If no, make
`isFavorite` optional and drop `favorites` from the mode enum, so the contract stops advertising a
feature that cannot work — and tell the designer to pull the icon.

## S12. 🔴 Quiz points: the design promises ~20× what the contract can award

**Where:** setup frame previews "Questions: 10 · Points: **+30**"; the result frame shows
"**+200** Points". Contract: `AnswerResult.pointsDelta` is *"0 or 1"*, and `submitAnswer` says
*"+1 per correct"*.

**What:** a 10-question quiz can award **at most 10 points**. A student shown "+200" and given 7
will consider it a bug — and it is, on one side or the other.

**What we built (Day 7):** no client-side points arithmetic at all. The setup preview is **omitted**;
the result screen renders `pointsAwarded` verbatim.

**Ask:** is the award rule really 1/correct, or is there a multiplier (quiz length? difficulty?
streak?) that the contract doesn't express? If there is a multiplier, `pointsDelta` needs to carry
it. If there isn't, the design's numbers need to come down.

## S13. 🟠 The result screen declares "Pass" with no threshold to pass

**Where:** result frames `159:1964` / `309:6375` render "50% — **Pass**". Nothing in `QuizSummary`
or anywhere else defines a passing score.

**What we built (Day 7):** the percentage ring only. **No Pass/Fail word** — we will not invent an
academic threshold and show it to a student.

**Ask:** is there a pass mark? Is it global, per-subject, or per-track? If it exists it belongs in
`QuizSummary` (or a static rule we can hard-code with a contract note). Deferred until answered.

## S14. 🟠 Review from HISTORY is blocked by a draft endpoint

**Narrowed 2026-09-08.** The original framing — *"Review Questions is blocked"* — was too wide, and
it cost this feature a release. It is corrected here rather than deleted, because the reasoning is
the useful part.

**Where:** result frames draw a **Review Questions** CTA; the review screen itself is `162:2377`.

**What was wrong with the original:** reviewing was read as needing `GET /quizzes/{quizId}`, the only
endpoint returning correct answers for a finished quiz (`openapi.yaml:1010`), which is `draft`. True
for review from history — **not** true for the frame's actual entry point. At the moment
`POST /quizzes/{quizId}/finish` returns, the app already holds, in `QuizSession`, every field the
draft `QuizReview.questions[]` schema would return: the questions, the chosen option, the correct
option, correctness, and explanation availability. Field for field. The only obstacle was
self-inflicted — `QuizCompleted` dropped the session on the way to the result screen.

**What we built (Day 8-9):** `/quiz/:quizId/result/review`, fed entirely from that retained session.
**Zero endpoints consumed** — coverage is unchanged by this screen. The CTA is live. The payload is
in memory only and is never cached, so review dies with the process, exactly as S2 requires.

**What is still blocked, and the ask is unchanged:** promoting `GET /quizzes/{quizId}` is what
unblocks (1) reviewing any quiz but the one just finished, (2) reviewing after a process restart, and
(3) quiz resume (S2). Still the single highest-value promotion for the quiz feature — the Day 8-9
screen is a stopgap over a session that survives one app lifetime, not a replacement for it.

## S15. 🟠 Setup draws a question-pool progress bar with no data source

**Where:** setup frames `135:1622` / `309:5771` — *"QUESTION POOL PROGRESS · 45 out of 100
questions · 55 questions remaining in pool"*.

**What:** nothing exposes a per-scope pool size or how much of it a student has consumed.
`POST /quizzes` only reveals the pool was too small *after* the fact, via 422
`not_enough_questions`.

**What we built (Day 7):** the card is **hidden**. We will not fabricate a denominator.

**Ask:** can the lesson/lecture node in the catalog tree carry `questionCount` and
`answeredCount`? (`UniversitySubjectTree.lectures[].questionCounter` already exists — is that the
same idea, and does it extend to school lessons?) Otherwise the card should come out of the design.

## S16. 🟡 "Daily Limit Reached" vs a weekly contract limit

**Where:** limit frames `199:2335` / `225:6634` / `225:7001` say *"Daily Limit Reached"*.
Contract: *"Free plan: 50 questions/WEEK"*, error code `weekly_question_limit_reached`.

**What we built (Day 7):** **weekly** copy — the server owns the rule and the code name agrees.

**Ask:** confirm weekly is correct, then the designer updates the frames. If it is genuinely a
daily cap, the error code is misnamed and needs a contract change.

---

## S17. 🟠 The AI explanation is designed as two sections; the endpoint returns one string

**Where:** quiz frame `159:1695`. The AI EXPLANATION panel renders **two labelled bodies**:
*"WHY IS THIS WRONG?"* (`159:1828`, with its own paragraph at `159:1831`) and *"WHY IS THE CORRECT
ANSWER RIGHT?"* (`159:1835`, paragraph `159:1838`). They are separate cards with different heading
colours and genuinely different content in the mock copy.

**Contract:** `GET /questions/{questionId}/explanation` → `200` is
`{ status: "ready", text: string }`, `required: [status, text]` (`openapi.yaml:914`–`919`).
**One string. No second field, no delimiter, no schema hint that `text` has internal structure.**

**Why this cannot be worked around client-side:** splitting the string on a heuristic (blank line,
first sentence, a "because" clause) would invent a response format GPT-4o-mini never promised. The
generator is an LLM — the first time it phrases an answer as one paragraph, or leads with the
correct answer, the split silently produces nonsense in a labelled box a student will trust.

There is a second problem the design does not address: *"WHY IS THIS WRONG?"* is meaningless when the
student answered **correctly**. The frame only ever shows the wrong-answer case.

**What we built (Day 7):** the panel, its header and its card chrome exactly as drawn, with `text`
rendered verbatim in **one** section and both sub-headings omitted. Owner decision. When the field is
split this becomes two of the same card and nothing above it moves.

**Ask (either is fine, pick one):**
1. Split the response — `{ status, whyWrong?, whyCorrect? }`, both optional so a correct answer can
   omit the first; or
2. Confirm one free-text explanation is the intent, and the designer collapses the two boxes into
   one.

---

## S18. 🟢 `pointsDelta` on a retry: "the ORIGINAL result" or "0"?

**Where:** `openapi.yaml:845`–`850` (operation description) says a retry *"returns the ORIGINAL
result"*. The field doc at `:1443` says `pointsDelta` is *"0 or 1 (server-side award; **0 on retry
replay** or free-plan edge)"*.

If `pointsDelta` becomes 0 on replay, the response is not literally the original result. The two
sentences describe different things and the more specific one is presumably right.

**Impact: none, today.** The app never sums `pointsDelta` — the only points figure it renders is
`QuizSummary.pointsAwarded` from `finish` (see S12). This is logged so it does not get discovered
later by someone who *does* try to use it, e.g. for an in-quiz running total.

**What we built:** the mock backend implements the field doc — the replay returns the original
`correct`/`correctOptionId` with `pointsDelta: 0`.

**Ask:** low priority. Confirm which sentence governs, and reword the other.

**Update 2026-09-04 — resolved by adr-102 D2 (3.0.0-m1 changelog).** The field doc governs:
`pointsDelta` reports what THIS call awarded, and a replay awards nothing, so it returns `0`. The
server had been returning the original award and was corrected; `openapi.yaml` is unchanged and
`submitAnswer` carries no `x-behaviour-changed` stamp because the published text already said so.
The mock backend implemented the field doc from the start (`_submitAnswer`: `'pointsDelta': replay ?
0 : …`), so nothing changed on our side. Verdict, correct option and explanation flag stay
byte-identical on a replay.

---

## S19. 🟡 No quiz endpoint returns a subject name, but two frames show one

**Where:** setup `135:1622` renders *"Biology"* above *"Cell Membrane"* (nodes `146:2289` /
`146:2291`); the result frame `159:1964` renders *"Biology — Cell Structure"*.

**Contract:** `Quiz` carries `scopeName` and nothing else identifying (`openapi.yaml:1432`).
`QuizSummary` carries **neither** a subject nor a scope (`:1446`). `QuizHistoryItem` and `QuizReview`
both *do* have `subjectName` — so the field exists in the contract's vocabulary, just not on the two
schemas these screens have.

Client-side it is reachable only from `GET /catalog/subjects`, four screens up the Learn stack, and
plumbing it would mean changing screens Day 7 is explicitly not allowed to touch.

**What we built (Day 7):** both screens title themselves with `scopeName` alone; the result screen
gets it forwarded from the `Quiz` in the route's `extra`.

**Ask:** add `subjectName` to `Quiz` and to `QuizSummary` (it is already on two sibling schemas), or
confirm scope-only titling and the designer drops the subject line.

**Update 2026-09-26:** built client-side meanwhile (API→UI Waves 11 and 13, owner rulings): the Learn stack's
cached subjects list supplies the name, carried by navigation to setup and on to the result, display only. It is
null on a cold deep link, which is why the ask stands (D-001 update).

---

## S20. 🟠 `PATCH /me` cannot edit school or geography — so one of the three options you offered the designer is unbuildable

**Where:** your partner notice of 2026-07-30 asks the UI/UX partner: *"How does the profile screen
render a student with no school? Blank row, hidden row, or an 'أضف مدرستك' prompt?"*

**Contract:** `PATCH /me` accepts exactly five fields — `name`, `email`, `avatarId`,
`leaderboardVisible`, `scoreHidden` (`openapi.yaml:614-624`). There is no school field, no
geography field, and no other endpoint that writes either. **School and geography are immutable
after registration in v1.1.**

So the third option is not implementable. If the designer picks "أضف مدرستك", we will be asked to
build a prompt with nothing behind it — a button that can only ever open a dead end. The first two
options (blank row / hidden row) are both fine and cost nothing.

This is worth answering **before** the design revision rather than after, because it is cheaper to
remove an option from a question than to remove a screen from a build.

**Ask — two questions:**
1. Is post-registration school selection intended at all in M1? (adr-028 §2 makes the field
   optional at registration, which is exactly the situation that creates students who might want to
   add one later.)
2. If yes: does `PATCH /me` gain `schoolId`, or does a separate endpoint appear? Either way it
   needs a pinned contract commit before we build against it.

The same question applies, more weakly, to the free-text city: a student who used the adr-028 §1
fallback has no way to upgrade to a coded city once their city is added to the list.

---

## S21. 🟡 Three internal inconsistencies in v1.1, found by diffing `23f0535..ee2ed8f`

None of these blocks Day 7c — all three were built around, following the prose over the schema.
Listed so the document and the implementation do not drift apart.

**1. `anyOf` permits what the prose forbids.** `SchoolRegistration` (`:1281-1283`) and
`UniversityRegistration` (`:1306-1308`) express the city union as:

```yaml
anyOf:
  - required: [cityId]
  - required: [cityName]
```

`anyOf` is *at least one* — a body carrying **both** satisfies this schema. The prose on both
fields says both → `validation_failed`. A strict schema validator and the server would disagree.
`oneOf` says what the descriptions say. **We built the prose:** the body factory throws on both,
so it never reaches you.

**2. `/reference/schools` still describes free-text school as the non-Egypt path** (`:483-484`):
*"non-Egypt students use optional free text in registration instead (adr-010, never blocked)"* —
which adr-028 §2 cancelled outright three lines of diff earlier
(`SchoolRegistration`, `:1258`: *"Free-text `schoolName` does not exist on this contract"*). The
path description was not updated. Harmless to us; misleading to the next reader.

**3. `rate_limited` is documented on 3 of the 6 `/reference/*` paths.** The changelog says these
paths carry a per-IP limit because they are unauthenticated by design, and the response
descriptions themselves say *"unauthenticated per-IP limit on /reference/\*"* — but the `429` is
only declared on `/reference/countries`, `.../governorates` and `/reference/cities`.
`/reference/schools`, `/reference/education-systems` and `/reference/universities` have none.
`/reference/schools` is the one that matters: it is the only *paginated* reference endpoint, so it
is the one a client can hammer. **We handle 429 on all of them** (the interceptor is path-agnostic)
and the mock triggers it on schools too.

**Ask:** confirm the limiter covers all six, and declare the `429` on the other three — or say it
is genuinely scoped to three and we will stop expecting it elsewhere.

**Also worth noting, not a defect:** the changelog says *"six corrupted schema descriptions
fixed"*; the diff contains **five** (`TokenPair.accessToken`, `SchoolRegistration.email`,
`StudentProfile.badges`, `PATCH /me`'s `email`, `QuizQuestion.imageUrl`). `StudentProfile.email`
had no description in v1.0 and has none in v1.1, so there was nothing there to repair. No impact —
we hand-write models rather than generating from the document, and none of the five was
transcribed from the corrupted text (verified field-by-field in Day 7c section 0).

---

## S24. 🔴 "Solved Questions — 300" has no source anywhere in the contract

**Where:** Profile (`166:4416`) draws a lifetime solved-questions counter.
**What:** `StudentProfile` carries `points {school, university, total}`, `level` and `badges`. There
is **no answered/solved counter**. `SubjectTree` has per-node `answered`/`total`, but that is per
subject, per track, and summing it client-side would be both wrong (it counts nothing outside the
loaded tree) and expensive (it needs every subject fetched).

**What we built (Day 8 step 1): nothing.** The card is **omitted outright** — the rule since S12
(quiz points off by 20×) is that a displayed number comes from the server verbatim or does not
render. **There is no code marker to grep**, because there is no code: an omission leaves nothing
behind.

**Ask:** is this a real product concept? If yes it belongs on `GET /me` — it is a profile fact, not
a leaderboard fact, and a student should see it from cache while offline. If no, it comes off the
frame.

## S25. 🔴 "Rank — HERO" is a tier name the contract cannot produce

**Where:** Profile (`166:4416`) draws a rank *tier*.
**What:** the contract has `level` (integer 1–12) and `badges` (integer, post-level-12 milestones).
There is no rank string and no tier enum. `GET /leaderboard/me` is the only endpoint that might
plausibly have carried one — it is `draft`, and its schema does not have it either.

**What we built: nothing**, same as S24, and for the same reason. A card rendering "—" was the
alternative and is worse: a visible blank invites the next person to fill it in with a guess. **No
code marker.**

**Ask:** is `HERO` a tier system (a mapping from level or points to a name, which the server must
own so it can be changed without an app release), or is it design flavour text? If it is real it
needs to be on `GET /me` next to `level`. Related and still open: **S3** — `level` has no threshold
table, so we render level 8 with no way to say what reaches level 9.

> **Note 2026-09-27 (API→UI Wave 19).** Only the light frames draw Rank here. The dark (`337:7433`, `349:12919`) and
> RTL (`549:21052`, `549:26384`) Profile frames draw **Badges** in this slot, which `badges` on `GET /me` can fill.
> The owner ruled to keep Points only until the designer reconciles the frames (DESIGN_ISSUES #101). The question
> above stands for the light frames.

## S26. 🟠 Settings "Mode" draws three themes; the app has two

**Where:** Setting (`176:1840`) draws three colour circles under **Mode**.
**What:** `AppColors` has exactly two canvases — light `#FCFBF9` / green `#384F47` and dark
`#232428` / purple `#AE87E7` — and the whole Day 7b fidelity pass was measured against those two.
A third would mean inventing roughly fifty token values and calling the result a design.

**What we built:** **two** options, wired to a real theme switch. Also in `DESIGN_ISSUES.md` #45,
because this one is the designer's to answer, not Seif's.

**Ask (designer):** what is the third circle? If it is "follow the system", that is a mode and not
a palette and we will build it as one. If it is a third palette, it needs tokens.

## S27. 🟠 "Show Rank" is one switch where the contract has two booleans

**Where:** Setting (`176:1840`) draws a single **Show Rank** toggle.
**What:** `PATCH /me` accepts **`leaderboardVisible`** (am I listed at all) and **`scoreHidden`**
(listed, but with my score suppressed) — `openapi.yaml:620-621`, defaulted `true`/`false` by
adr-023 at `:1380-1382`. They answer different questions and they default differently. One switch
cannot express two independent booleans, and mapping one control onto both would mean **silently
choosing a privacy policy on behalf of a minor**.

**What we built:** **both** toggles, each labelled with a line explaining what it does, each
sending only its own field. Also in `DESIGN_ISSUES.md` #46.

**Ask (designer):** confirm two rows is right, or tell us which single policy the one switch was
meant to express.

## S28. 🟠 Notification Preferences — four toggles, nothing stores them

**Where:** Setting (`176:1840`) — Announcements · Promotions · Support · System.
**What:** nothing in the contract persists a notification preference. `PUT /me/fcm-token` is a
**device token**, not a preference set, and it is `draft` besides.

**What we built:** all four render **disabled and off**. Off rather than on because any value we
displayed would be a state we invented; a switch that slides and then forgets is worse than one
that visibly cannot move.

**Ask:** if notification preferences are milestone 1, they need somewhere to live. The natural home
is an object on `PATCH /me` beside the privacy toggles — same kind of per-student setting, same
endpoint, no new path. Related: the Home bell's unread dot has been gated behind a permanently
false flag since Day 7b pending any notifications endpoint, and there is a `Notifications` frame in
this cluster we have not built.

## S29. 🟠 "Upload photo" needs an endpoint that is draft *and* moderated

**Where:** Edit Profile's avatar sheet (`180:3989` variants) offers **Upload photo** and **Use
Avatar**. Code: `lib/features/profile/widgets/avatar_sheets.dart:121`.
**What:** `GET /reference/avatars` + `PATCH /me { avatarId }` are both stable, so **Use Avatar
works**. `PUT /me/avatar` is `draft`, and adr-021 makes it *moderated* (SafeSearch) — which means
even once it stabilises, an upload is not synchronously "set". The UI has to express a pending
state that nothing in the contract currently describes.

**What we built:** Use Avatar opens the existing Day 2 picker; Upload photo renders disabled.

**Ask:** two things, and the second is the one that will bite. (1) Is `PUT /me/avatar` milestone 1?
(2) When it lands, **what does the client show between upload and approval** — does `GET /me`
return the old avatar, the new one optimistically, or a status field? A moderated write needs a
readable moderation state or the screen has to guess.

## S30. 🟠 Privacy & policy and Terms & Conditions have no text

**Where:** Profile (`166:4416`) rows 7 and 8. Code: `lib/features/profile/screens/profile_screen.dart`
(both rows) and `lib/features/account_shells/screens/legal_document_screen.dart`.
**What:** **not a contract gap** — neither document needs an endpoint. They need *text*, in Arabic
and English, and nobody has supplied any or owns supplying it.

This is in this file rather than only in `DESIGN_ISSUES.md` because it is a **milestone-1 blocker
with no owner**, which is exactly the kind of item that drifts until it is a launch problem. An app
for minors that ships without a privacy policy is not a design nit.

**What we built:** both rows navigate to a shared screen carrying a `TODO(content)` and one line
saying the document has not been published. **We did not write legal copy** — text that binds a
minor's guardian is not something an implementer invents, and a plausible placeholder is more
dangerous than an empty page because it looks reviewed.

**Ask (PM/legal, not Seif):** who is writing these, and do they ship as bundled asset text or as
something the server serves? If the latter it becomes a contract item and comes back to you.

## S31. 🔴 "Go to Uni" switches track — and adr-003 makes that a data-model question

**Where:** the `Go to Uni` dialog (`180:4301`): *"Are you sure you want to convert to Uni Track?"*
Code: `lib/features/profile/screens/profile_screen.dart`.
**What:** track is fixed at registration by a discriminated body (`SchoolRegistration` |
`UniversityRegistration`) whose two arms have different **shapes** — adr-010 gives university no
country field. There is no endpoint, and `PATCH /me` cannot express it.

The missing route is the easy half. The hard half is **adr-003 dual point pools**:

- Does the school pool survive, transfer, or reset?
- `points.total` is your sum — does it keep counting the abandoned pool?
- Does `level` recompute, and can a student's level go **down** as a result?
- What happens to entitlements bought against the old track?

**What we built:** the dialog, with **Confirm disabled**.

**Ask:** this is a product decision before it is an endpoint. Even "not milestone 1" is an answer we
can build to — we would then take the row off the hub rather than showing a dialog nobody can
complete.

## S32. 🟠 "your progress" — a designed screen with no endpoint of any kind

**Where:** a `your progress` frame in the Account cluster, reached from the Profile hub.
Code: `lib/features/profile/screens/profile_screen.dart`.
**What:** `GET /me` carries points, level and badges — a **snapshot**, with no history. Nothing in
the contract returns a time series, a per-day figure, or a streak record. Per-subject counters on
`SubjectTree` are a position, not a progress timeline, and they are per subject.

**What we built:** the row is **disabled**. Unlike Refer a Friend and Customer Support it gets no
shell, because a progress screen with no data would be an empty chart — and an empty chart reads as
"you have done nothing", which is a lie about the student rather than about the app.

> Renumbered from S30 in Day 8 step 3. S30 is the missing-legal-copy issue alone.

**Ask:** is there a progress/statistics endpoint planned? If yes, what is its grain — daily points,
per-subject accuracy, streaks? The frame will answer it better than we can guess.

## S33. 🟠 Customer Support is fully designed and has zero endpoints

**Where:** `Customer Support` ×3, `Create Ticket`, `Customer support chat`, `Messages` ×2 — plus a
whole Message **tab** in the nav bar. Code:
`lib/features/account_shells/screens/customer_support_screen.dart`.
**What:** there is **no endpoint of any kind** for support. Not draft — absent. This is a complete
ticketing product in the design with nothing behind it.

**What we built:** the Profile row navigates to a shell whose Create Ticket control is disabled.
**No invented data** — no ticket list, no thread, no reference number. A support screen that
accepts a message and drops it is worse than one that says it is not open, because the student
walks away believing they have been heard.

> Renumbered from S30 in Day 8 step 3.

**Ask:** is support milestone 1, and is it in-app at all? A `mailto:` or a WhatsApp hand-off is a
perfectly good milestone-1 answer and needs no contract — but it needs deciding, because the design
promises a ticketing system.

## S34. 🔴 `parentPhone` is WRITE-ONLY — we collect it and can never show it back

> **Found in Day 8 step 2, while building Edit Profile.** This is worse than "another immutable
> field", which is how the partner notice originally framed it.

**Where:** `parentPhone` is **required** on both registration bodies — `openapi.yaml:1280`
(`SchoolRegistration`) and `:1305` (`UniversityRegistration`). It is **absent from
`StudentProfile`**. The Edit Profile frame (`180:3989`) draws the row.
**What:** we compel a student to supply a parent's phone number at registration, and then there is
no endpoint that will ever tell them what they gave us. Not read-only. Not masked. **Not at all.**

The rest of Edit Profile's read-only block works because `GET /me` returns the values — phone, city,
school, stage, education system are all there, and we render them locked. `parentPhone` is the one
row we could not build, so **the frame's row is not rendered**, and a student cannot check whether
the number they typed months ago was a typo.

**The server clearly has it.** `POST /auth/recovery/start` returns **`parentPhoneMasked`**
(`openapi.yaml:272`) — account recovery reads the value back to prove identity. So this is a
missing *field on a response*, not a missing value in the database.

**Ask:** put the same masked form on `GET /me`. Masked rather than raw is almost certainly the right
answer for a minor's parent's number — it is enough for "yes, that is my mum's number" and it does
not turn `GET /me` into a way to harvest guardian contacts from a stolen token. If you would rather
it stay hidden entirely, say so and we will ask the designer to delete the row.

## S35. 🟠 `GET /me` returns raw wire codes; a student sees `nationalLanguages`

> **Found in Day 8 step 2**, same pass as S34.

**Where:** Edit Profile's read-only block. Code:
`lib/features/profile/screens/edit_profile_screen.dart`.
**What:** the geography and academic values on `StudentProfile` arrive as **wire codes with no
display names**. Rendered honestly, a student sees `nationalLanguages` and `secondary2` where the
frame draws "American" and "Grade 11".

Everything else on the profile carries both locales: `NamedRef` has `nameAr`/`nameEn`, so
governorate, city, school, university and faculty all render properly. `stage` and
`educationSystem` are bare strings.

**Why we did not just map them client-side, which is the obvious fix:**

1. `EducationSystem` is documented **extensible** — *"clients must tolerate unknown values"*. There
   is no closed set to translate against, so any map we write goes stale the day you add a system,
   and it fails by showing a raw code to exactly the students on the newest option.
2. `Stage` does have ARB copy from the registration wizard, but translating one and not the other
   would be worse than translating neither — the two rows sit adjacent.
3. Fetching `/reference/education-systems` to label a **read-only** row is a network call for
   cosmetics, on a screen that otherwise makes zero requests.

**Ask:** return the display names you already have. Either `stage` and `educationSystem` become
`NamedRef`-shaped (`{code, nameAr, nameEn}`) like everything else on the object, or `GET /me` gains
a sibling block of resolved names. The first is more consistent with the rest of the schema.

## S36. 🟡 A `Friends` screen exists, with no endpoint and no way in

**Where:** a `Friends` frame in the Account cluster. Code:
`lib/features/account_shells/screens/friends_screen.dart`.
**What:** two separate gaps, and the second is the odd one.

1. **No endpoint.** There is no friends list, no friend requests, no social graph of any kind in the
   contract. Interestingly the *concept* is in the contract's prose — `scoreHidden`'s description
   (`openapi.yaml:1094`) says it "affects profiles/friends" — so somebody has thought about it.
2. **No entry point.** The Profile hub draws ten rows and none of them is Friends. Nothing anywhere
   in the app navigates to this screen. We built it as a shell and routed it at `/friends`, but a
   student cannot reach it, and we did **not** invent an eleventh row to give it a door.

**Ask (designer first, then Seif):** where is this screen entered from? If the answer is "it is not
milestone 1", it comes out of the cluster and we delete the shell. If it is real, it needs both a
door and a contract, and the privacy toggles in S27 are already written as though it exists.

---

## S37. 🔴 Staging does not serve two routes the contract marks `stable` (three when filed 2026-08-23; narrowed 2026-09-04)

**Where:** staging backend commit `0b53cdcad20cc0029fea0f18ef2e62a980b48aca` (`/health/version`,
built 2026-08-23T10:53:37Z). Observed by `tool/smoke/real_api_smoke_test.dart` on 2026-08-23
with a registered staging test number; status + `code` only, bodies not logged.
**What:** three `x-stability: stable` operations answer with a route-level error, not a
domain one:

| Operation | Staging answers | Contract says |
| --- | --- | --- |
| `PATCH /me` (same-name no-op body) | **405** with `code: internal_error` | `200` + `StudentProfile`; `internal_error` is the 500 code in error-codes.md, so a 405 carrying it looks like a fallback handler, not a routed endpoint |
| `GET /me/entitlements` (Bearer) | **404** `not_found` | `200` + `EntitlementsResponse` — a deployed route would answer 401/200 like `GET /me` does |
| `GET /catalog/subjects` (Bearer) | **404** `not_found` | `200` + subject list; everything under `/catalog/*`, `/quizzes/*` and `/questions/*` is unreachable from the client until this exists |

The same two 404s were seen by direct curl on 2026-08-21 (build `fbab748`), so this is not a
one-build regression. Everything else stable — all seven `/reference/*` reads, the full OTP
walk, `GET /me`, refresh with rotation, logout — decodes cleanly.

**Ask:** (1) when do `PATCH /me`, `/me/entitlements` and `/catalog/*` land on staging, and is
the 405-as-`internal_error` a routing fallback we should expect elsewhere? (2) Once they are
up, we need a staging account with a seeded term so `POST /quizzes` has questions to draw —
the v2.1 empty-catalog state is contract-legal and the harness already handles it, but it
cannot prove the quiz loop. (**Superseded 2026-09-05:** "seeded term" is university-shaped
wording; see the 2026-09-04 update below.) (3) Still owed from `api-data.md` §4: a ~60 s access token for
checklist step 5 (the 401 → refresh → retry pipeline) and a forced `500` + `429` for step 9.

**Update 2026-09-04 — narrowed to two.** Against backend `78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1`
(built 2026-09-03T15:38:17Z): `GET /catalog/subjects` answers `401 authentication_required`
unauthenticated and **`200 []`** for the test account — **deployed**, and the empty list is
contract-legal; the test account is **school-track** (`track: Track.school` in the harness
output), and school subjects are never release-gated (`openapi.yaml:795-799`, adr-073) — so
`[]` here means no subjects are seeded under the account's (education system, stage) cohort
(`:775-780`), not an unreleased term. `PATCH /me` still answers **405** `internal_error` and
`GET /me/entitlements` still **404** `not_found`, unchanged between the `0b53cdc` and `78c6e5d`
builds (the 404s were also seen at `fbab748` by curl; the 405 was first recorded at `0b53cdc`). Evidence: `.ai/audits/current/smoke-staging-2026-09-04.md`. Asks (1) and (3) stand for the
two remaining routes. Ask (2) — seed subjects for the school cohort (education system, stage) of
`+2010000000001`, or register a university test account, for which "seed a released term" would
be the right ask — is now the only thing between us and proving the quiz loop, and it would also be
the first observation of the 3.0.0-m1 `QuizSummary` on the wire (whether `78c6e5d` includes adr-102
cannot be checked from outside the private backend repo; the client accepts both shapes meanwhile).

---

## S38. 🔴 Account deletion has no endpoint, and it had never been filed

**Where:** the whole contract — 3.0.0-m1 has no `DELETE /me`, no deletion-request operation, and no
mention of deletion anywhere in `contract-changelog.md`. `docs/STORE_READINESS.md` §6 records the
store requirement.
**What:** both stores require an in-app path to delete the account — Google Play's account-deletion
requirement under Data safety, and Apple's App Review Guideline 5.1.1(v). The app can draw the screen;
it cannot do anything when the student confirms. This is a hard store blocker, not a polish item, and
it had never appeared in this file — that is the gap this entry closes.
**Ask:** (1) an operation — `DELETE /me`, or a `POST /me/deletion-requests` that starts a grace
period — marked `stable` before the store-submission wave; (2) the semantics for a minor's data:
immediate hard delete or a grace period, what happens to leaderboard rows, quiz history and the parent
phone number, and whether the same phone may register again afterwards; (3) the `ProblemDetails` codes
it can return (`authentication_required` and `session_superseded` at least). Until it lands the app can
only ship a `TODO(contract)` shell that says deletion is not available in-app yet, which does not satisfy
either policy.

> ⚠ **Narrowed 2026-09-12 (Day 10 brief) — ask (1) is answered, upstream.** `POST /me/deletion-request` (`requestAccountDeletion`) and `DELETE /me/deletion-request` (`cancelAccountDeletion`) are both **`x-stability: stable`** at upstream `2dca3c5` (3.13.0-m1); they entered the contract at `3.3.0-m1` (adr-114) as draft and have since flipped. The semantics are a **30-day grace window**, and during it every authenticated endpoint is refused `403 account_pending_deletion` **except an exact four** (`GET /me`, `POST /me/deletion-request`, `DELETE /me/deletion-request`, `POST /auth/logout`) — not a `/me` prefix. `StudentProfile.pendingDeletion` is **present only while a request is pending, absent otherwise, never `null`**, so presence is the flag, and it carries `effectiveAt`.
>
> **This is not resolved.** The contract is no longer the blocker — build effort is. Nothing in `lib/` calls either operation, there is no cancel screen, and the Mistakes flow's mandated `403` destination therefore does not exist (`DESIGN_ISSUES.md` #62). Asks (2) minor-data semantics and (3) the full code list still need re-reading against the new pin. **This entry stays Open until the re-vendor lands and the screen is built.**
>
> ⚠ **Re-vendor landed 2026-09-12** — `contract/` is now at `2dca3c5` (3.13.0-m1), so both
> operations are `stable` *in this repo*, not only upstream. **Half of the remaining blocker
> is therefore gone and the entry is still Open**, because the screen is not built and asks
> (2) and (3) are still unanswered.
>
> Day 10 (Mistakes) touched this deliberately and minimally: its screens do **not** handle
> `403 account_pending_deletion` — that belongs in the global error interceptor, one place
> for every endpoint, which is the contract's own framing. What they do guarantee is that
> the code is **not swallowed and not mistaken for a scope refusal**: it falls through to the
> generic error with a retry, and a test asserts exactly that. A `TODO(contract)` in
> `mistakes_overview_screen.dart` points back here.

---

## S39. 🟠 When is a point credited — at `submitAnswer` or at `finish`?

> **Filed 2026-09-05, from the Phase 2 contract-impact audit §9C.1.**

**Where:** `openapi.yaml`'s `submitAnswer` summary reads "returns correctness + points delta
immediately"; its description reads "Points are awarded server-side only (+1 per correct — dual
pool per track, adr-003)" (`:1036-1039`). adr-102 D2 (`contract-changelog.md`, 2026-09-03 entry)
reads "the awarded point is already reflected in `pointsAwarded` at finish and in `GET /me`."

**What:** the strong reading of both quotes together is that a point is credited at
`submitAnswer` time, not at `finish`. **Not yet observed on the wire** — the quiz loop is
unreachable against staging (empty seed data for the test account). `lib/dev/mock_backend.dart`'s
`_finishQuiz` moves the running total only at finish — the opposite reading (Phase 2
FINDING-12) — so the one thing in this repo that could exercise the question encodes the answer
the contract text argues against.

**Consequence:** `GET /me`'s freshness after an abandoned quiz is unclear either way (Phase 2
FINDING-02) — if points post at answer time, a student who abandons mid-quiz should already see
them on `GET /me`; the app's only refresh of that call is on `QuizCompleted`, so an abandoned
quiz's points (if already awarded) would not show until the next natural refetch.

**Ask:** confirm the award timing in writing. We will not correct the mock until this is
answered — the mock's current behaviour is itself the reason FINDING-02 stayed invisible during
development, and guessing wrong a second time would recreate the same blind spot deliberately.

**Code marker:** `lib/dev/mock_backend.dart` (`_finishQuiz`).

## S40. 🟠 `createQuiz`'s three 403 codes have no stated rule for which one fires

> **Filed 2026-09-05, from the Phase 2 contract-impact audit §9C.2.**

**Where:** `createQuiz`'s `403` response lists three codes: `weekly_question_limit_reached`,
`subscription_required`, `insufficient_scope`.

**What:** after adr-091 (2.3.0-m1 — the catalog is no longer entitlement-gated; entitlement
moved to quiz creation), an unsubscribed student can build against the free weekly allowance.
Nothing in the contract states the rule for when that student gets `subscription_required`
instead of simply exhausting the free allowance and getting `weekly_question_limit_reached`. The
client already handles all three codes, so nothing is broken today — but the distinction is not
derivable from the document, only guessed at per call site.

**Ask:** state the rule that decides between the three codes.

**Code marker:** `lib/features/quiz/repository/quiz_repository.dart` / `lib/features/quiz/widgets/limit_sheet.dart`.

## S41. 🟡 `getSubjectTree`'s 403 has two causes and one code, with no discriminator

> **Filed 2026-09-05, from the Phase 2 contract-impact audit §9C.3. Pre-existing — the
> un-release cause dates from 1.2.0-m1 (2026-08-11); this is not a 3.0.0-m1 regression.**

**Where:** `openapi.yaml:843-849` — a cached `subjectId` "can still return `403
insufficient_scope`… without any schema change: the subject fell outside the caller's enrolment
scope, or the admin un-released its term for the cohort (adr-037 §3)."

**What:** two causes, one code, no discriminator — and they are not equivalent to a student.
Falling outside enrolment scope is **permanent** (the subject is not part of this student's
course); an un-released term is **reversible** (it may open later).
`lib/features/catalog/widgets/catalog_states.dart:51-65` currently suppresses the retry button
and renders "isn't part of your course" for both — correct for the first cause, wrong for the
second (Phase 2 FINDING-16).

**Ask:** either a discriminator on the 403 body, or confirmation that one copy string must cover
both causes (in which case the copy, not the code, needs to stop implying permanence).

**Code marker:** `lib/features/catalog/widgets/catalog_states.dart:51`.

---

## S42. 🟠 `getMyMistakes` — are `termId`/`termNumber` present-and-nullable, or optional?

> **Filed 2026-09-12 with `docs/day10_mistakes_brief.md`. Cited against UPSTREAM `2dca3c5`
> (3.13.0-m1) — this surface does not exist at our pin `184d6ec`.**

**Where:** `openapi.yaml:908-921` (upstream). The overview item declares four properties plus
`mistakeCount`, but `required` is **`[id, name, mistakeCount]`** (`:921`) — `termId` and
`termNumber` are **not in it**. Two lines earlier the `200` description says *"School subjects
carry `termId: null`"* (`:903`), which reads as though the key is always sent.

**What:** the two readings produce different clients and the difference is not cosmetic.

| Reading | Dart | Behaviour on a school payload |
| --- | --- | --- |
| Always present, nullable | `String? termId` from a key that is always there | `{"termId": null}` |
| Genuinely optional | key may be absent entirely | `{}` — and `json['termId']` is also `null` |

`json_serializable` happens to decode both to `null`, so **the app will not crash either way** and
this does not block the build. It matters for (a) whether a missing key is contract drift worth
throwing on, and (b) whether a university payload can legitimately omit them during the summer gap
rather than sending `null` — `TermId`'s own description (`:2079-2082`) says null is normal
there too.

**Ask:** confirm which. If the keys are always sent, adding them to `required` costs nothing and
removes the ambiguity permanently. If they are genuinely optional, say so in the description so the
`termId: null` sentence stops implying otherwise.

**Code marker:** none yet — not built.

---

## S43. 🟠 A leaf badged "8 mistakes" replays a quiz that is neither 8 questions nor those 8

> **Filed 2026-09-12 with `docs/day10_mistakes_brief.md`. Forward-looking — it bites at the
> replay step, which is deliberately out of Day 10's scope.**

**Where:** the interaction of `getMyMistakesForSubject` (upstream `:942`) with `POST /quizzes`
`mode: retakeWrong` as changed by **`3.11.0-m1`** (2026-09-10, adr-136/adr-135).

**What:** `3.11.0-m1` made `{mode: retakeWrong, lessonId|lectureId, length}` legal and the
changelog names it *"the terminal `replay` step of the Mistakes flow: tapping 'Cell Structure —
8 mistakes' now builds a quiz from that lesson's wrong answers."* But the two pools are
**deliberately different sets** (adr-133):

- the badge counts **currently wrong** — it decays the moment a question is answered right;
- the retake pool is **ever wrong** — it does not decay.

So the student taps a row promising **8** and is served a quiz of **10, 30 or 50** (`length` is a
closed enum — there is no "just these 8" option) drawn from a **superset** that includes
questions they have since answered correctly. The contract is emphatic that this is intended and
that the client must not reconcile the numbers — which is right, but it leaves the **product**
question open.

**Ask:** with no way to scope a retake to *currently* wrong and no way to request "as many as I got
wrong", what should the student be told? Either (a) a way to narrow the retake to the decayed set,
(b) a `length` that can track the pool, or (c) an explicit ruling that the badge and the quiz are
allowed to disagree and copy should stop implying a relationship. **We will not invent (c)
silently.**

**Code marker:** none yet — the replay is out of Day 10's scope; `quiz_mode.dart:34`
(`offeredQuizModes`) is the one-line gate that will open it.

---

## S44. 🔴 Neither Mistakes operation can be exercised against staging — by construction

> **Filed 2026-09-12 with `docs/day10_mistakes_brief.md`. Extends S37 rather than repeating it.**

**Where:** `tool/smoke/real_api_smoke_test.dart` and the staging record
`.ai/audits/current/smoke-staging-2026-09-04.md`.

**What:** a `mistakeCount` exists only where a student has a **graded wrong answer**. Producing one
requires the full chain: a seeded catalog → `POST /quizzes` → `POST /quizzes/{id}/answers`
→ a wrong answer. The only staging test account, **`+2010000000001`**, is **school-track** and
its catalog answers `200 []` — school subjects are never release-gated (adr-073), so that is
not an unreleased term, it means **no subjects are seeded for its (education system, stage)
cohort** (S37). No catalog → no quiz → no answer → no mistake.

So on today's staging both operations will answer `200 []` and `403`/`200`-empty **forever**, and
every one of them is a contract-legal response. **A green smoke run would prove nothing**, and
reporting one as evidence the flow works would be exactly the SOURCE-reported-as-DEVICE error
`WAVE_STATUS.md`'s ladder exists to prevent.

**Ask:** the same ask as S37, and this entry exists to record that a second feature now depends on
it — either **seed that cohort**, or **register a university test account** on a released
term. Ideally seed one account far enough to have answered a question wrongly, so the decay rule
itself can be observed rather than assumed.

**Impact if unanswered:** Day 10 can reach **BUILD** verification and no further. Its DEVICE and
live-staging rows stay empty, and must be reported empty rather than inferred from the mock.

**Code marker:** `tool/smoke/real_api_smoke_test.dart`; see also `docs/RISKS.md` R-8.

---

## S45. 🟡 `updateMyProfile`: an unknown `avatarId`, and the 400's field map

> **Filed 2026-09-28, API→UI Wave 20 (the mock `PATCH /me`).**

**Where:** `contract/openapi.yaml`, `PATCH /me` (`updateMyProfile`), and the mock that imitates it,
`lib/dev/mock_backend.dart` (`_profilePatchViolations`).

**What:** (1) `avatarId` is a `Uuid` that must name one of `GET /reference/avatars`, a closed set. The operation
declares `200`, `400 validation_failed` and `401`, and no `404`, while the reference lookups say a well-formed but
unknown id is a `404`, not a `400`. Which does `PATCH /me` answer? (2) Its `400` says only `validation_failed`;
`completeRegistration`'s says "field map in `errors`". Is `errors` always present on this one?

**Today:** the app cannot send an unknown id (it picks from the list), and without `errors` it degrades safely (the
banner shows, no field is marked). The mock answers an unknown id with a `400` on `avatarId` and says so.

**Ask:** state both in the contract.

**Impact if unanswered:** none on the app today; the mock may imitate the wrong status.

---

## How to use this file

- New question → add a row to the summary table **and** a section, with the `file:line` marker if
  code already carries an assumption.
- Answered → mark **Resolved** in the Status column, strike the row, keep the section (the
  reasoning is worth more than the tidiness) and delete the `TODO(contract)` marker in code.
- Anything here that turns into a contract change needs a new pinned commit in
  `contract/openapi.yaml` and a note in `contract-changelog.md` before we build against it.
- A new contract pin gets a new LEVEL in Part A (the template in A.0), with the transition scored
  on the anchors there. New S-entries get a level tag added to the "Filed-at level index" above
  Part B's summary table.
