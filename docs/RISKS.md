# Active Risk Register

Live risks only. A risk leaves this file when it is closed by evidence, not when
it stops being mentioned. Every entry has an owner and a next action — an item
with neither is not a risk, it is a wish.

**Last reviewed:** 2026-09-04 (contract v3.0.0-m1 adoption)

Severity reflects **impact × likelihood of going unnoticed**. A defect nothing
can detect ranks above a louder one that any gate would catch.

---

## R-1 · Typography scale — **CLOSED 2026-08-21**

| | |
| --- | --- |
| **Was** | 153 inline `fontSize` values across 49 files, with no scale to migrate onto. Figma defined **one** text style; twelve day-briefs carried no numbers. Wave 3D was BLOCKED and the ratchet held at 153 purely so it could not worsen. |
| **Closed by** | The designer's handoff `typography-style-inter.md` (2026-08-21) — 18 named styles on the scale `28 → 24 → 20 → 18 → 16 → 14 → 12 → 10`, plus `11` for bottom navigation only. Transcribed **verbatim** into `lib/core/theme/app_typography.dart` as `AppType`, and projected onto Material's `TextTheme` so framework widgets stop drawing stock sizes. |
| **Enforcement** | `test/core/theme/typography_discipline_test.dart` — the palette guard's twin, same `lib/core/theme/` exemption, and it names `file:line`. Bans `fontSize:` **and** `fontWeight:` at call sites, checks the scale has not grown an unissued size, and checks no style names a font family (which would drop the Arabic fallback). The old ratchet in `project_rules_test.dart` is kept as the counting half and lowered **153 → 0**. |
| **Owner** | — |
| **Status** | **CLOSED.** Wave 3D is unblocked. |

The old note here said "deriving the scale from frequency is forbidden — it
would author a design system and freeze it into 49 files". That held: the scale
was **supplied**, not inferred. Where a call site's old size was not on the
supplied scale, it was remapped by the **role** the designer's own usage notes
describe, and every such change is listed for sign-off rather than absorbed
silently — see the reconciliation register.

---

## R-2 · W3-1 — `ref` used after `await` in `OtpNotifier.verify`

| | |
| --- | --- |
| **Impact** | If `Ref` is dead after disposal, the OTP verify path throws in exactly the scenario Wave 3A set out to fix, and `markAuthenticated()` never runs — a student left authenticated but unrouted. |
| **Evidence** | Fable Wave-3 verdict, W3-1. Three `await`s in `verify()`; `ref.read` at lines ~110, ~115, ~123, guard only after. Contradicts the premise stated in `edit_profile_notifier.dart` source. |
| **Owner** | Engineering |
| **Next action** | ~~First confirm `Ref.read`-after-dispose semantics~~ **Confirmed 2026-09-04** (see below). Capture `deviceInfo`, the repository, secure storage and the auth controller before the first `await` in `verify()`, and add a dispose-mid-`verify` test. Deliberately not applied in the 2026-09-04 contract wave — out of its scope. |
| **Status** | **OPEN — MEDIUM.** Deliberately not fixed during Wave 4 (documentation must not silently change code). |

**Either way this is a defect.** If `ref` dies on disposal, the OTP path is
broken. If it does not, `EditProfileNotifier` accepted a real staleness cost for
nothing. One of the two is wrong and the same lookup settles both.

**Settled 2026-09-04:** `ref` dies. `riverpod-3.3.2/lib/src/core/ref.dart:232-240` —
`_throwIfInvalidUsage` throws `UnmountedRefException` once `!mounted`, and every
`read`/`watch` goes through it. The OTP path is the broken one; `EditProfileNotifier`'s
premise was right. Status stays **OPEN — MEDIUM** until the fix and its test land.

---

## R-3 · CI has never been observed running

| | |
| --- | --- |
| **Impact** | The whole Wave-2 enforcement layer is statically verified only. `subosito/flutter-action` accepting `3.44.7` is unproven. A workflow that fails on first run teaches the team to ignore CI. |
| **Evidence** | `origin/dev` is 6 commits behind local. No Actions run has been inspected. |
| **Owner** | Developer |
| **Next action** | Push when ready, then read the `analyze + test` job. Watch two steps: *Read pinned Flutter version* (should echo `3.44.7`) and *Set up Flutter*. |
| **Status** | **OPEN — accepted by choice.** The developer has deferred pushing; this is a known, deliberate gap, not neglect. |

Expect the advisory `goldens` job to be **red** — baselines are local-Windows,
the runner is a different Windows. That is designed behaviour, not a regression.

---

## R-4 · No device verification of the release build

| | |
| --- | --- |
| **Impact** | C-1 is ARTEFACT VERIFIED but not DEVICE VERIFIED. The APK declares `INTERNET`; nobody has installed it and completed a login. |
| **Evidence** | `tool/verify_release_manifest.ps1` run, 2026-08-14: 60.2 MB APK, `aapt2` confirms the permission. No install performed. |
| **Owner** | Developer |
| **Next action** | Install the release APK, complete a login end to end. |
| **Status** | **OPEN.** Both bugs this project has shipped were device-only classes. |

---

## R-5 · Lifecycle fixes have structural coverage only

| | |
| --- | --- |
| **Impact** | The 3A guard proves a disposal flag *exists*, not that every post-`await` assignment is guarded — it cannot detect W3-1 (W3-2). No behavioural race test exists (W3-3). |
| **Evidence** | Fable confirmed by simulation that a file with the flag and zero guards passes. The detector's own docstring states the limitation. |
| **Owner** | Engineering |
| **Next action** | Bundle with R-2: one dispose-mid-`await` test would cover the behaviour and validate the guard's blind spot. |
| **Status** | **ACCEPTED** — documented limitation, not a hidden one |

---

## R-6 · `/subscription` is an unbuilt screen on the revenue path — **CLOSED 2026-09-04**

| | |
| --- | --- |
| **Was** | Students hitting the weekly quiz limit reached a placeholder behind an "Upgrade" button. Back worked, so not a trap — but it was the paywall, and whether to build or disable it was a product decision this project refused to invent. |
| **Closed by** | The contract decided it. adr-049 §3 (contract 2.2.0-m1, vendored at `184d6ec`): the mobile app is **purchase-silent** — no paywall, no price, no upgrade link, no where-to-buy, no voucher redemption (`x-consumers: [web]`). The entry point was therefore **removed, not built** (`5c4b855`): the Upgrade button and benefits card left `limit_sheet.dart`, `/subscription` and `/subscription/return` left the router, the disabled Profile row left `profile_screen.dart`, six ARB keys left both locales. The sheet bodies stopped saying upgrade/subscribe in `ce7da9a` (D-007). |
| **Enforcement** | None mechanised. A route that no longer exists cannot be pushed without a failing test, and the ARB parity guard catches a re-added key in one locale only. A grep guard for `Upgrade`/`/subscription` was considered and not added — the surface is gone, not merely hidden. |
| **Owner** | — |
| **Status** | **CLOSED.** The open remainder is copy, not product: DESIGN_ISSUES #51. |

---

## R-7 · Two ratchets can rot silently

| | |
| --- | --- |
| **Impact** | If someone reduces a count without lowering the baseline, the guard silently stops protecting the difference. |
| **Evidence** | `fontSize` 153, `Text` literals 5, both in `project_rules_test.dart`. |
| **Owner** | Whoever reduces a count |
| **Next action** | Lower the baseline in the same commit as the reduction. Reviewers: treat an unchanged baseline beside a reduction as a review comment. |
| **Status** | **ACCEPTED** — inherent to the ratchet pattern |

---

## R-8 · Real API never connected

| | |
| --- | --- |
| **Impact** | Base URLs are `TBD.example`. Every test has only ever met mocktail stubs or `mock_backend.dart`, which cannot produce 401s, 5xx, timeouts or malformed bodies. |
| **Evidence** | **2026-09-04:** same harness against staging `78c6e5d` — **13 of 21** decoded: `GET /catalog/subjects` is deployed and answers `200 []` (contract-legal — the test account is school-track, and school subjects are never release-gated (adr-073, `openapi.yaml:795-799`), so the empty result means no subjects are seeded under its (education system, stage) cohort, not an unreleased term); `PATCH /me` 405 and `/me/entitlements` 404 unchanged between the `0b53cdc` and `78c6e5d` builds (the 404s were also seen at `fbab748` by curl on 2026-08-21; the 405 was first recorded at `0b53cdc`); 6 still unreachable behind the empty catalog (tree, the quiz loop, explanation). `.ai/audits/current/smoke-staging-2026-09-04.md`. **2026-08-23:** `tool/smoke/real_api_smoke_test.dart` against staging `0b53cdc` — 12 of 21 stable operations decoded through the real seam (all `/reference/*`, the OTP walk, `GET /me`, refresh, logout); 3 answered with a typed server state (`PATCH /me` 405, `/me/entitlements` 404, `/catalog/subjects` 404 — `seif_fight.md` S37); 6 unreachable behind the catalog 404. No untyped error leaked. F-7-01 closed in `068390d`. The `TBD.example` placeholder was replaced earlier (`app_config.dart:43`). |
| **Owner** | Backend partner + engineering |
| **Next action** | Seif: deploy `PATCH /me` and `/me/entitlements` (S37 — two left), and seed subjects for the school (education system, stage) cohort of `+2010000000001` — or register a university test account, for which "seed a released term" is the right ask — so `POST /quizzes` has questions to draw (S37 ask 2). Then re-run the harness — the quiz loop, explanation 202 and register arm are the untested remainder, and the `finish` body is the first chance to see the 3.0.0-m1 `QuizSummary` on the wire (the client accepts both shapes, so nothing waits on it). Checklist steps 5 (short-lived token → 401 pipeline) and 9 (forced 500/429) still need Seif's cooperation. |
| **Status** | **OPEN — NARROWED again 2026-09-04** (13/21 decoded; two routes missing; the quiz loop gated on seed data, not on the client). Closes when the authenticated suite runs green end to end, quiz loop included. |

---

## R-9 · One platform identity for all environments; production id never ratified

| | |
| --- | --- |
| **Impact** | Staging and production share `com.levelup.level_up_app` / `com.levelup.levelUpApp`; a tester cannot hold both on one phone, and a wrong-environment build is indistinguishable by package name or on screen (`isDev` is dead code). The id becomes permanent at the first Play upload or Apple App ID registration and keys every later Firebase registration. Nobody has confirmed the template strings are the ones the business wants. |
| **Evidence** | `android/app/build.gradle.kts:42-43` (template TODO + id); `project.pbxproj:371,550,572`; no `productFlavors` ever (`git log -S`); one Xcode scheme; `.ai/audits/current/app_identity_environment_audit_2026-10-04.md`; flagged before by F-9-08 (2026-08-14), BS-D-09 / BS-C-13 (2026-09). |
| **Owner** | Product owner (decision D-021) · engineering (Waves 1–3 of the Environment & Architecture chapter) |
| **Next action** | Owner answers D-021 Q1–Q4 in `docs/DECISIONS.md`; then Wave 1 (Android flavors) per `docs/ENVIRONMENTS.md` §8. Nothing may be uploaded to any store track or registered with Firebase before that. |
| **Status** | **OPEN — opened 2026-10-04.** Closes when both platforms carry distinct, ratified staging and production ids verified at ARTEFACT level (Android) and BUILD level on a Mac (iOS). |

---

## Closed

| Risk | Closed by |
| --- | --- |
| Release APK has no `INTERNET` (Tier-0 C-1) | Wave 1 — `aapt2` on the built artefact |
| Session data leaks across sign-out (C-2) | Wave 1 — old behaviour reproduced red, new green |
| CI silently skipping tests | Wave 2 — repo-driven discovery + guard |
| Guard harness proved the wrong thing | Wave 2.1 — per-test isolation |
| Bare `xargs` in canonical script | Wave 2.1 — NUL-delimited + guard on all shell entry points |
| Stale test counts in docs and CI | Wave 4 — replaced with "run `flutter test`" |
| 3C rejection rested on an inaccurate scan | Wave 4 — record corrected (W3-4) |
| `/subscription` placeholder on the revenue path (R-6) | 2026-09-04 — the contract decided it (adr-049): purchase surface removed, not built |
