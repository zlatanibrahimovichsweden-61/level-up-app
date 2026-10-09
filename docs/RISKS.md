# Active Risk Register

Live risks only. A risk leaves this file when it is closed by evidence, not when
it stops being mentioned. Every entry has an owner and a next action — an item
with neither is not a risk, it is a wish.

**Last reviewed:** 2026-10-09 (completion-program baseline — `.ai/audits/current/completion/00_BASELINE.md`; R-3, R-8, R-9 updated). Previously 2026-10-06 (release-readiness reconciliation — `.ai/audits/current/release_readiness_reconciliation_2026-10-06.md`)

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

## R-2 · W3-1 — `ref` used after `await` in `OtpNotifier.verify` — **CLOSED 2026-10-06**

| | |
| --- | --- |
| **Impact** | If `Ref` is dead after disposal, the OTP verify path throws in exactly the scenario Wave 3A set out to fix, and `markAuthenticated()` never runs — a student left authenticated but unrouted. |
| **Evidence** | Fable Wave-3 verdict, W3-1. Three `await`s in `verify()`; `ref.read` at lines ~110, ~115, ~123, guard only after. Contradicts the premise stated in `edit_profile_notifier.dart` source. |
| **Owner** | Engineering |
| **Next action** | ~~First confirm `Ref.read`-after-dispose semantics~~ **Confirmed 2026-09-04** (see below). Capture `deviceInfo`, the repository, secure storage and the auth controller before the first `await` in `verify()`, and add a dispose-mid-`verify` test. Deliberately not applied in the 2026-09-04 contract wave — out of its scope. |
| **Closed by** | The recorded fix, applied in the 2026-10-06 release-readiness reconciliation: `verify()` reads the repository, secure storage and the auth controller **before** its first `await` and uses the captures afterwards (`deviceInfoProvider.future` was already read synchronously). Red-first test `verify_fork_test.dart` "popped mid-verify → the tokens are still written and auth still flips": on the old code the notifier was disposed mid-flight, `ref.read` threw `UnmountedRefException` into the generic `catch`, and `writeTokens` was never called (mocktail: "No matching calls") — the OTP consumed server-side, the student signed out. Green after. |
| **Status** | **CLOSED.** R-5's limitation stands (the structural guard still cannot see a misplaced read); the behavioural test now covers this one path. |

**Either way this is a defect.** If `ref` dies on disposal, the OTP path is
broken. If it does not, `EditProfileNotifier` accepted a real staleness cost for
nothing. One of the two is wrong and the same lookup settles both.

**Settled 2026-09-04:** `ref` dies. `riverpod-3.3.2/lib/src/core/ref.dart:232-240` —
`_throwIfInvalidUsage` throws `UnmountedRefException` once `!mounted`, and every
`read`/`watch` goes through it. The OTP path is the broken one; `EditProfileNotifier`'s
premise was right. Status stays **OPEN — MEDIUM** until the fix and its test land.

---

## R-3 · CI observed on the push path; the main-only release gate has not run in its flavored form — **NARROWED 2026-10-09**

| | |
| --- | --- |
| **Impact** | `analyze + test` is proven by use on `merged`. No run has exercised `build-release-apk` (push to `main` only) in its current flavored form (`--flavor prod -t lib/main_prod.dart`): the only two `main` runs (`f987f20` 2026-09-19, `e71e9a1` 2026-09-20) predate the flavors (`2dfd969`, 2026-10-06). A step that fails on its first run teaches the team to ignore CI. |
| **Evidence** | `gh run list`, 2026-10-09: 15 runs, 2026-08-15 → 2026-10-06 — 14 success, 1 failure (`f10b112`, 2026-10-06, format check: a file committed unformatted, fixed in `56f74e7`). By branch: `merged` 11 success + 1 failure, `main` 2 success, `dev` 1 success. Latest `merged` run `c87b90a`: success. `8e641e9` is unpushed, so it has no run. |
| **Owner** | Developer |
| **Next action** | When `main` is next promoted (`--ff-only`, on the owner's word), read the release compile gate job once — the first observation of its flavored form. Read CI after every authorised push. |
| **Status** | **OPEN — NARROWED 2026-10-09.** ~~CI has never been observed running~~ — false since 2026-08-15. Remaining gap: the flavored release gate on `main`. |

Expect the advisory `goldens` job to be **red** — baselines are local-Windows,
the runner is a different Windows. That is designed behaviour, not a regression.

---

## R-4 · No device verification of the release build

| | |
| --- | --- |
| **Impact** | C-1 is ARTEFACT VERIFIED but not DEVICE VERIFIED. The APK declares `INTERNET`; nobody has installed it and completed a login. |
| **Evidence** | `tool/verify_release_manifest.ps1` run, 2026-08-14: 60.2 MB APK, `aapt2` confirms the permission. No install performed. |
| **Owner** | Developer |
| **Next action** | ~~Install the release APK, complete a login end to end.~~ **Done 2026-10-06 on the `Pixel_8` AVD against staging:** `app-staging-release.apk` built from `f10b112` (`--flavor staging -t lib/main_staging.dart`, R8 on, 60.9 MB; `apksigner verify` → unsigned, by design) — a scratch copy signed with the local debug key, outside the repo, installed over the mock build and completed the whitelisted login, the catalogue, a 10-question quiz (+2, `/me` 31 → 33), the one-row board, an offline round trip and sign-out (`release_readiness_reconciliation_2026-10-06.md` §15.2). Remaining: the same walk once with the **production keystore and the prod flavor**, after E-1 and P-1. |
| **Status** | **OPEN — NARROWED 2026-10-06.** The release bytes have run on a device; only the signature and the host differ from the store artefact. |

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
| **Impact** | The production base URL is still the fail-closed placeholder `https://TBD.example/api/v1` (`app_config.dart:54`); staging is real (`:44`) and the planned `api.level-upworld.com` did not resolve on 2026-10-09. Every test has only ever met mocktail stubs or `mock_backend.dart`, which cannot produce 401s, 5xx, timeouts or malformed bodies. |
| **Evidence** | **2026-09-04:** same harness against staging `78c6e5d` — **13 of 21** decoded: `GET /catalog/subjects` is deployed and answers `200 []` (contract-legal — the test account is school-track, and school subjects are never release-gated (adr-073, `openapi.yaml:795-799`), so the empty result means no subjects are seeded under its (education system, stage) cohort, not an unreleased term); `PATCH /me` 405 and `/me/entitlements` 404 unchanged between the `0b53cdc` and `78c6e5d` builds (the 404s were also seen at `fbab748` by curl on 2026-08-21; the 405 was first recorded at `0b53cdc`); 6 still unreachable behind the empty catalog (tree, the quiz loop, explanation). `.ai/audits/current/smoke-staging-2026-09-04.md`. **2026-08-23:** `tool/smoke/real_api_smoke_test.dart` against staging `0b53cdc` — 12 of 21 stable operations decoded through the real seam (all `/reference/*`, the OTP walk, `GET /me`, refresh, logout); 3 answered with a typed server state (`PATCH /me` 405, `/me/entitlements` 404, `/catalog/subjects` 404 — `seif_fight.md` S37); 6 unreachable behind the catalog 404. No untyped error leaked. F-7-01 closed in `068390d`. The `TBD.example` placeholder was replaced earlier (`app_config.dart:43`). |
| **Owner** | Backend partner + engineering |
| **Next action** | Seif: deploy `PATCH /me` and `/me/entitlements` (S37 — two left), and seed subjects for the school (education system, stage) cohort of `+2010000000001` — or register a university test account, for which "seed a released term" is the right ask — so `POST /quizzes` has questions to draw (S37 ask 2). Then re-run the harness — the quiz loop, explanation 202 and register arm are the untested remainder, and the `finish` body is the first chance to see the 3.0.0-m1 `QuizSummary` on the wire (the client accepts both shapes, so nothing waits on it). Checklist steps 5 (short-lived token → 401 pipeline) and 9 (forced 500/429) still need Seif's cooperation. |
| **Status** | **OPEN — NARROWED again 2026-10-06.** ~~2026-09-04: 13/21 decoded; two routes missing; the quiz loop gated on seed data.~~ 2026-09-22: `PATCH /me`, `/me/entitlements` and `GET /leaderboard` decode (S37 is stale). **2026-10-06, on a release build on a device:** the quiz loop (`POST /quizzes` → 10 × `submitAnswer` → `finish`, +2 points, `/me` re-read) ran against staging's seeded 53-question bank; the catalogue, tree, board, offline and sign-out paths too. Still unobserved: the explanation 202→200 arm (`explanationAvailable` was false for every seeded question), the register arm, a 5xx, a real 429 with `Retry-After`, an expired-token refresh round-trip, `session_superseded`. Closes when those run — they need Seif's cooperation (a seeded explanation, a forced error, a short-lived token). |

---

## R-9 · iOS still carries the template platform identity (Android ratified and applied)

| | |
| --- | --- |
| **Impact** | *(Updated 2026-10-09.)* The ids are ratified (D-021: `com.levelupworld.app` / `.stg`) and applied on Android (`build.gradle.kts:55,69-77`, guarded by `test/guards/android_identity_test.dart`), so the two Android builds coexist on one phone with different labels. iOS is untouched: `PRODUCT_BUNDLE_IDENTIFIER` is still the template `com.levelup.levelUpApp` (`project.pbxproj:371,550,572`), one scheme, deployment target 13.0 where D-021 Q4 ratified 15.0. A wrong-environment build is still indistinguishable on screen (`AppConfig.isDev` is read by nothing: `app_config.dart:13,18,33`). The only AAB on disk (2026-10-04) carries the dropped id `com.levelup.level_up_app` — never upload it. The id becomes permanent at the first Play upload or Apple App ID registration and keys every later Firebase registration. Nobody has confirmed the template strings are the ones the business wants. |
| **Evidence** | `android/app/build.gradle.kts:42-43` (template TODO + id); `project.pbxproj:371,550,572`; no `productFlavors` ever (`git log -S`); one Xcode scheme; `.ai/audits/current/app_identity_environment_audit_2026-10-04.md`; flagged before by F-9-08 (2026-08-14), BS-D-09 / BS-C-13 (2026-09). |
| **Owner** | Product owner (decision D-021) · engineering (Waves 1–3 of the Environment & Architecture chapter) |
| **Next action** | ~~Owner answers D-021~~ **done 2026-10-06** (`com.levelupworld.app` / `.stg`). ~~Wave 1 Android flavors~~ **done 2026-10-06**, ARTEFACT-verified (`aapt2 dump badging` on both release APKs). Remaining: CW03 (Env Wave 3) — iOS schemes, bundle ids and 15.0 on a Mac with Xcode 26, after checking the actual Xcode project structure (owner, 2026-10-09); a DEVICE check of the two Android identities side by side (CW19, was Env Wave 4). Nothing may be uploaded to any store track or registered with Firebase before the client's accounts and the Firebase ownership question are settled (`ENVIRONMENTS.md` §7, §10). |
| **Status** | **OPEN — MITIGATING.** Opened 2026-10-04; identity ratified and the Android half implemented 2026-10-06. iOS still carries the template id `com.levelup.levelUpApp` in one scheme. Closes when iOS carries the ratified ids at BUILD level on a Mac. |

---

## R-10 · The planned "/redeem in the browser" hand-off contradicts the contract's purchase-silence rule

| | |
| --- | --- |
| **Impact** | `docs/ENVIRONMENTS.md` §10 records Seif's D-021 Q7 input that the app "opens the website's `/redeem` page in the browser" and re-reads entitlements on return, as an Env Wave 2 per-flavor config slot. `contract/contract-changelog.md:360` (adr-049 §3) says the app "never carries a purchase link, and never tells the student where to buy", and the 2026-10-04 store re-check classed an adr-171 link as an Apple 3.1.1 violation on the Egypt storefront. Built as planned, the slot would be the first purchase surface in a purchase-silent app, and a likely rejection. |
| **Evidence** | `docs/ENVIRONMENTS.md` §10 ("Public website host"); `contract/contract-changelog.md:360`; `store_readiness_recheck.md` §7 ("Purchases / external links"); nothing in `lib/` implements it (SOURCE, 2026-10-06). |
| **Owner** | Product owner + Seif (contract) |
| **Next action** | Do **not** build the slot. Seif states in a changelog entry whether adr-049 §3 is being revised; the owner accepts or declines the 3.1.1 exposure. The identity session annotates §10 to cite this risk. `release_readiness_reconciliation_2026-10-06.md` O-4 / Q-B10. |
| **Status** | **OPEN — DECISION.** Opened 2026-10-06; nothing in code. |

---

## R-11 · iOS required-reason API (DiskSpace) reached through `device_info_plus`, undeclared at the plugin level

| | |
| --- | --- |
| **Impact** | Apple refuses uploads whose binary uses a required-reason API without a declaration (ITMS-91053). `device_info_plus` 13.2.0 (the locked version; 11.5.0 is the same) reads `NSFileSystemFreeSize` / `NSFileSystemSize` in `FPPDeviceInfoPlusPlugin.m:42-43` while shipping a `PrivacyInfo.xcprivacy` whose `NSPrivacyAccessedAPITypes` is **empty**, so upgrading does not fix it. The app uses only `info.model`; none of Apple's permitted DiskSpace reasons (85F4.1 display, E4AC.1 free-space check, 7D9E.1 bug report, B728.1 health research) describes this app, so a Runner manifest declaring one would be a false declaration. This is store blocker E-4's root cause. |
| **Evidence** | pub cache `device_info_plus-13.2.0/ios/.../FPPDeviceInfoPlusPlugin.m:42-43` and `.../PrivacyInfo.xcprivacy`; `lib/features/auth/repository/device_info_provider.dart:21-27`; `contract/openapi.yaml:2559-2566` (`model` optional). SOURCE, 2026-10-06. |
| **Owner** | Engineering (the change) · product owner (the shape: O-3 in the reconciliation) |
| **Next action** | Replace the plugin on the device-binding path (adr-019): a small `MethodChannel` returning `Build.MODEL` / `UIDevice.current.model` with no required-reason API, or drop `model`. The iOS half is only provable by an Xcode archive's Privacy Report (Env Wave 3, a Mac). |
| **Status** | **OPEN — HIGH for the Apple upload.** Opened 2026-10-06 as the plugin-level finding behind E-4. |

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
| `ref` after `await` in `OtpNotifier.verify` (R-2) | 2026-10-06 — captures before the first await; dispose-mid-verify test red on the old code |
