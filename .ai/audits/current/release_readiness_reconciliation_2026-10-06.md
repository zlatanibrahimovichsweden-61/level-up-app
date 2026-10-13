# Level Up — Release Readiness Reconciliation (2026-10-06, after the Fable-eye audit)

**Question answered:** after the Fable pass, what still prevents Level Up from being called release-ready,
and which of it needs code, a product decision, a backend decision, or verification nobody on this machine
can perform?

**Method.** Phase 1 verified the starting point from the repository, not from any document. Phase 2 read
every truth source (`docs/RISKS.md`, `docs/KNOWN_BUGS.md`, `docs/DESIGN_ISSUES.md`, `docs/WAVE_STATUS.md`,
`docs/STORE_READINESS.md`, `docs/DECISIONS.md`, `docs/ENVIRONMENTS.md`, `docs/seif_fight.md`,
`contract/SOURCE.md`, the 2026-10-04 store re-check and its ledger, the environment-chapter state, the
Fable-eye audit) and re-verified every open item against the tree at `f10b112`. Four read-only source
audits were delegated (network/error paths; contract ↔ app; Android/iOS configuration; store policy and
purchase silence) and their claims were spot-checked. Then, because staging was reachable and a device was
attached, the parts of the question that SOURCE cannot answer were taken to a **release build on a device
against the real staging backend** (§15). Verification levels are stated per row: SOURCE → BUILD →
ARTEFACT → API → DEVICE → WEB; nothing is rounded up.

**Verdict: `NOT READY`** — for the same eight reasons the 2026-10-04 re-check found, none of which is a
Flutter defect, plus one new owner decision. No P0 or P1 defect exists in the frontend code. Two P2/P3
defects were fixed in this pass with red-first tests; the rest is content, backend, console and iOS work.

---

## 1. Current baseline (Phase 1 — VERIFIED from the repository)

| Item | Value | Evidence |
| --- | --- | --- |
| Branch / HEAD / remote | `merged` / `f10b112` / `origin/merged` = `f10b112` (fetched) | `git rev-parse HEAD origin/merged` |
| Working tree at start | clean (`git status --porcelain` empty, sha1 `da39a3ee…`) | — |
| Fable fixes pushed | yes — `a0585eb`, `423a610`, `1bf749c`, `882c889`, `c4b00af`, `f10b112` are all in `origin/merged` | `git log --oneline -12` |
| Latest Fable audit | `.ai/audits/current/fable_eye_audit_2026-10-06.md` (2026-10-06 04:12) | `ls -la` |
| Latest project audits | `store_readiness_recheck.md` + ledger (2026-10-04); `app_identity_environment_audit_2026-10-04.md`; `env_wave1_report.md` (2026-10-06); `wave_20_21_state_audit.md` (09-30) | `ls -lt .ai/audits/current` |
| Known-bugs register | BUG-001…BUG-024; open: **BUG-017** only (owner wording) | `docs/KNOWN_BUGS.md` headings |
| Design-issues register | #1…#126; #120–#126 added by the Fable pass | `docs/DESIGN_ISSUES.md` |
| Contract pin | `0df5cf4` = **3.28.0-m1**, vendored 2026-10-04; 38 stable / 16 draft / 54; 3 web-only | `contract/SOURCE.md` |
| Upstream contract drift | **none** — `git fetch` in the contract clone: `0df5cf4..origin/main` is empty; all four vendored blobs equal `origin/main` | ARTEFACT (delegated, re-stated) |
| Flutter / Dart | 3.44.7 stable (`84fc5cbb22`) / 3.12.2; `.flutter-version` 3.44.7 | `flutter --version` |
| App version | `1.0.0+1` | `pubspec.yaml:19` |
| Validation baseline | **2059 passed / 0 failed / 0 skipped**, format PASS, analyze 0 (`2026-10-06T00:53:59Z`, tree `3913f86`+fixes) | `.ai/audits/current/test-results.md` |
| Readiness rubric | Play **44 %**, App Store **20 %** (after Env Wave 1) | `docs/STORE_READINESS_RUBRIC.md:90-91` |
| Staging | reachable at 01:30–01:35Z: `/me` → `401 authentication_required` (typed ProblemDetails); `/reference/*` 200; one **transient** `404 not_found` on `/reference/countries` at 01:30Z that answered 200 on both re-probes four minutes later | `curl` (API) |

No code was modified during Phases 1–9.

---

## 2. Fable outcome (carried, not repeated)

| | |
| --- | --- |
| Findings | 21 (FE-01…FE-21), 0 P0 / 0 P1 |
| Fixed + DEVICE-verified (emulator) | 9: nav tabs / profile rows / subject cards / language pill / dead controls as single `Button` nodes (BUG-021, BUG-024); the stale board after a quiz on the other scope (BUG-022); the Arabic level headline (BUG-023); the Subjects grid at text scale 1.3 (BUG-002's second half) |
| Recorded for the owner | 11, as `DESIGN_ISSUES` #120–#126 |
| Validation | 2046 → 2059 / 0 / 0; analyze 0; goldens 43 unchanged |
| Owed from that pass | the **Pixel 8 half of the re-walk** — **done today** (§15.1): 8 of the 9 checks reproduced on the phone, the ninth (text scale 1.3) stays emulator-only by the standing decision not to change the owner's phone font scale |

---

## 3. Historical issue reconciliation (Phases 2–3 — the consolidated matrix)

Statuses: VERIFIED FIXED · STILL BROKEN · OWNER DECISION REQUIRED · BACKEND DECISION REQUIRED ·
EXTERNAL VERIFICATION REQUIRED · RELEASE BLOCKER · NON-BLOCKING · DEFERRED · NO LONGER APPLICABLE ·
CANNOT VERIFY. "Level" is the verification level of the evidence column.

### 3.1 Store blockers from the 2026-10-04 re-check

| ID | Area | Current status | Evidence (level) | Owner | Action |
| --- | --- | --- | --- | --- | --- |
| E-1 | Production API host | **RELEASE BLOCKER** — unchanged | `app_config.dart:54` → `https://TBD.example/api/v1`; contract `servers:` still staging-only; D-021 Q5: planned `api.level-upworld.com`, not deployed, not in the contract (SOURCE) | Seif → app | Seif publishes the host in `servers:` + changelog; one-line swap; Env Wave 2 makes a `.example` prod release fail at build time |
| E-2 | Privacy policy / terms | **RELEASE BLOCKER** — unchanged | `login_screen.dart:46-48` three `levelup.example` URLs; `/legal/*` screens say "This document hasn't been published yet."; `/legal/*` is outside `_authRoutes` (`app_router.dart:52`) so no legal text is reachable signed-out (SOURCE) | Product/legal → app | hosted AR+EN copy (needs E-7 facts); then the URL swap and un-gating `/legal/*` |
| E-3 | Account deletion | **RELEASE BLOCKER** — unchanged | both ops stable (`openapi.yaml:1070-1140`); nothing in `lib/` calls them; `pendingDeletion` parsed, never rendered; `403 account_pending_deletion` → copy + Retry withheld on six surfaces, **no cancel screen** (`exceptions.dart:127-135`) (SOURCE) | App (+ design + copy ruling, §6) | FORMULATE request/confirm + cancel screens; route the 403; local wipe |
| E-4 | iOS required-reason API | **RELEASE BLOCKER (Apple upload)** — root cause narrowed today | `device_info_plus` **13.2.0** (locked) reads `NSFileSystemFreeSize`/`NSFileSystemSize` (`FPPDeviceInfoPlusPlugin.m:42-43`) while its own `PrivacyInfo.xcprivacy` declares an **empty** `NSPrivacyAccessedAPITypes` — in 11.5.0 and 13.2.0 alike, so an upgrade does not fix it; no `ios/Runner/PrivacyInfo.xcprivacy`; the app uses only `info.model` (`device_info_provider.dart:21-27`), which Apple's permitted DiskSpace reasons (85F4.1 display / E4AC.1 free-space check / 7D9E.1 bug report / B728.1 health research) do not cover — a Runner declaration with any of those reasons would be false (SOURCE, pub cache) | App + owner (§6) | replace the plugin on the device-binding payload path (adr-019): a ~30-line MethodChannel (`Build.MODEL` / `UIDevice.model`) or drop `model` (optional in the contract); the iOS half is verifiable only by an Xcode archive's Privacy Report |
| E-5 | "Message" placeholder tab | **RELEASE BLOCKER (Apple 2.1 likely)** — unchanged; now a decision with two concrete options | `tab_placeholder.dart:55-61` "Coming soon"; inbox ops stable since 3.28.0-m1 and uncalled; the inbox investigation's verdict is INVESTIGATE FURTHER with six open dependencies (SOURCE) | Product | hide the tab for release 1, or FORMULATE the minimal inbox |
| E-6 | Reviewer login | **RELEASE BLOCKER** — unchanged | whitelist + fixed OTP "Absent from production configuration" (`openapi.yaml:94-98`); no demo account (CONTRACT) | Seif | production reviewer numbers with a fixed OTP, documented in the contract |
| E-7 | Retention / sub-processor facts | **RELEASE BLOCKER (prerequisite to E-2 and both privacy forms)** — still never filed | `grep -i retention docs/seif_fight.md` → none (SOURCE) | Seif / legal; app files the question | file the question (§7 Q-B1) |
| E-8 | Web deletion URL (Play) | **RELEASE BLOCKER** — unchanged | nothing in docs/contract/lib (SOURCE) | Seif / web | stand up the page, hand the URL to the console owner |

### 3.2 Items the workflow named explicitly

| ID | Area | Current status | Evidence (level) | Owner | Action |
| --- | --- | --- | --- | --- | --- |
| BUG-017 | Settings "Hide my points" help line | **OWNER DECISION REQUIRED** — STILL PRESENT | `app_en.arb:625` "You'll still be listed — without your score."; Pixel dump today: the Switch still says it (DEVICE) | Owner (wording EN+AR) | supply the two lines; S27 carries the contract side |
| R-2 | `ref` after `await` in `OtpNotifier.verify` | **VERIFIED FIXED today** | red-first test "popped mid-verify → the tokens are still written and auth still flips": on the old code `writeTokens` was never called (mocktail: "No matching calls"); green after capturing repository, storage and auth before the first await (`otp_notifier.dart`) (BUILD) | — | closed in `docs/RISKS.md` |
| R-3 | CI never observed | **CANNOT VERIFY** from this session | `gh` not installed; the GitHub connector authenticates as a third-party account that 404s on the private repo; the built-in browser has no session | Owner | open `github.com/zlatanibrahimovichsweden-61/level-up-app/actions` once; the 2026-10-06 pushes to `merged` should have run `analyze-and-test` |
| R-4 | Release build never run on a device | **NARROWED today — closes on the signed artefact** | `app-staging-release.apk` built from HEAD (R8/AOT, 60.9 MB, 71 s), **unsigned by design** (`apksigner verify` → "Missing META-INF/MANIFEST.MF"); a scratch copy signed with the local debug key installed on the `Pixel_8` AVD, **completed a real login against staging** and the flows in §15.2 (DEVICE + API) | Release manager | repeat once with the production keystore and the prod flavor after E-1 |
| R-8 | Real API never fully connected | **NARROWED today** | the quiz loop (`POST /quizzes` → 10 × `submitAnswer` → `finish`, +2 points, `/me` re-read 31 → 33) ran on the release build against staging; the leaderboard, catalogue, tree, offline and sign-out paths too (§15.2). Still unobserved: the explanation 202→200 arm (`explanationAvailable` was false for every question of the seeded bank), the register arm, 5xx, a real 429, a refresh round-trip (DEVICE + API) | Seif + engineering | seed a question with an explanation; a forced 500/429; a short-lived token |
| R-9 | iOS identity | **DEFERRED to Env Wave 3** (needs a Mac) | `project.pbxproj:349,475,526` still `13.0`; bundle id `com.levelup.levelUpApp` ×3; one scheme; no Podfile (SOURCE) | Engineering (Mac) | Wave 3 |
| Message / legal | see E-5 / E-2 | RELEASE BLOCKER | — | — | — |
| #120 | Arabic headline FittedBox | **OWNER/DESIGNER DECISION** (fix stands) | DEVICE today on the Pixel: "المستوى 3" whole in dark mode | Designer | a rule to replace the shrink |
| #121–#126 | inert See All, "+20 ▾", Resend colour, board Back chip, 1.3 nav label, round end / Close / "Welcome back," | **OWNER/DESIGNER DECISION** — NON-BLOCKING | recorded 2026-10-06; unchanged | Owner / designer | rule each |
| Quiz/review visuals | #87 dark CORRECT tile 1.11:1, #54, #55 skipped state, #52, #56, #93 (FE-20) | **DESIGNER DECISION** — NON-BLOCKING; owner ruled 2026-09-20 the build must not choose | `DESIGN_ISSUES.md` appendix; quiz pixels unseen on device (FLAG_SECURE) | Designer | rulings |
| Navigation gaps | — | **NO LONGER APPLICABLE** | every `*Screen` is routed; `/track-select` is an unreachable dev placeholder (M-3); BUG-005 fixed (SOURCE + DEVICE) | — | delete `/track-select` at the next router touch |
| Contract/API discrepancies | see §12 | NON-BLOCKING | 16 rows, none HIGH except deletion (= E-3) | mixed | §12 |
| iOS-specific risks | E-4, R-9, H-7 (`ScreenProtectorKit` iOS 26 crash report), H-4 (knownRegions `en` only), no `ITSAppUsesNonExemptEncryption`, template display name "Level Up App", landscape allowed | **EXTERNAL VERIFICATION REQUIRED** (Mac + Xcode 26) | §10 | Engineering (Mac) | Wave 3 |
| Store-policy blockers | E-1…E-8 + H-1 (UGC names) | see §11 | — | — | — |

### 3.3 Older open items re-verified

| ID | Area | Current status | Evidence (level) | Owner | Action |
| --- | --- | --- | --- | --- | --- |
| K-4 | Onboarding "Get Started" dead-end | VERIFIED FIXED | `onboarding_screen.dart:92` → `/login`; DEVICE (Fable walk + today) | — | — |
| K-5 | Dark hint colour = text colour | **STILL PRESENT — DESIGNER DECISION** | `app_colors.dart`: dark `textPrimary` and `hint` both `0xFFFCFBF9` (SOURCE) | Designer | pick the dark hint token |
| K-6 | Inactive nav labels 2.03:1 | DESIGNER DECISION (unchanged) | — | Designer | — |
| K-7 | Login legal links open `levelup.example` | = E-2 | — | — | — |
| K-8 | Subjects grid at 1.2× | VERIFIED FIXED (FE-09) | DEVICE (emulator 1.3; Pixel cards 89 dp at 1.0) | — | — |
| K-9 | Quiz progress bar clips at 1.25× | VERIFIED FIXED at SOURCE | no `Size.fromHeight(30)` / `LinearProgressIndicator` left in `lib/features/quiz` | — | — |
| K-10 | Arabic w600 | DESIGNER DECISION (D-019 handled mixed-font lines) | `pubspec.yaml`: Tajawal 400/500/700, Cairo 400/600/700 (SOURCE) | Designer | — |
| H-1 | Leaderboard shows peers' names + avatars, no report/block, no terms acceptance | **OWNER DECISION REQUIRED** (likely-rejection risk) | `leaderboard_row.dart:93`; names unmoderated (`openapi.yaml:870` avatars only); DEVICE today: a real name on the staging board | Owner + Seif | Option 0 (rank + points + avatar) or report/block + terms |
| H-2 | Template label / bundle name / splash | Android label FIXED ("Level Up"/"Level Up STG", ARTEFACT); iOS display name "Level Up App", splash template → Wave 3 | `build.gradle.kts:72,77`; `Info.plist:7-8` | Engineering | Wave 3 |
| H-3 | Inert controls (4 ON toggles, 3 "Coming soon" cards, 3 shells) | **OWNER DECISION REQUIRED** (2.1/4.2 impression) | Pixel dump today: four `Switch … "aren't available yet"` ON and disabled (DEVICE) | Product | hide or finish before submission |
| H-4 | Always-Arabic launch, iOS bundle `en` only | DEFERRED to Wave 3 | — | Engineering | add `ar` |
| H-5 | Minors: no age floor, DOB unused, parent phone without purpose text | **OWNER DECISION REQUIRED** (legal memo) | `date_of_birth_field.dart:40` `lastDate: now`; contract: `dateOfBirth` is `format: date` with no rule (SOURCE) | Product/legal + Seif | declared age groups; a purpose line |
| H-6 | Entitlement refetch on resume is dead code | NON-BLOCKING (CR-02) | `entitlementsProvider` has no consumer; never requested (SOURCE) | Owner | §6 |
| H-7 | `ScreenProtectorKit` iOS 26 crash report | EXTERNAL VERIFICATION REQUIRED | not re-fetched | Mac/device | Wave 3 |
| M-1 | No guard against calling web-only ops | NON-BLOCKING | still none; nothing calls them (SOURCE) | Engineering | optional guard |
| M-2 | `STORE_READINESS.md` says R8 off | STALE DOC | R8 ON (ARTEFACT: `mapping.txt` 11.7 MB) | Docs | fix at next touch |
| M-3 | `/track-select` dead route | NON-BLOCKING | `app_router.dart:162` | Engineering | delete |
| M-4 | CI: no AAB job, no macOS job | DEFERRED (Env Wave 4) | `ci.yml:318-426` | Engineering | Wave 4 |
| M-5 | url_launcher WebView fallback | NON-BLOCKING (unreachable) | `LaunchMode.externalApplication` only | — | — |
| M-6 | Dirty tree / unpushed commits | NO LONGER APPLICABLE | clean, pushed | — | — |
| M-7 | `pubspec.yaml:2` template description | NON-BLOCKING | — | — | — |
| P-1…P-7 | keystore + Play App Signing; Mac archive; D-021 ratification; console forms; listing assets; developer accounts; closed-test cohort | prerequisites — **P-3 DONE** (D-021 ratified 2026-10-06, Android implemented); the rest unchanged | `DECISIONS.md` D-021 | Owner / release manager / store account | — |
| Phase 0 objection | the checkpoint push published Wave 20 (`fa88b3a`) and the two forensic files | **OWNER DECISION REQUIRED** | `git log`; `.ai/audits/current/project_files_forensic_audit.html` + `_inventory.json` tracked | Owner | keep, or `git rm --cached` in one commit (history stays) |
| Peer note A-23 | `edit_profile_notifier.dart:68/79` — `if (_disposed) return` skips `invalidate(meProvider)`, so leaving Settings mid-save can leave a stale Rank value | **OWNER DECISION / P3** (not probed; raised by the API-audit session during this pass) | SOURCE | Owner | probe on device, then decide |

---

## 4. Current P0 / P1 blockers (Phase 9)

**Frontend code defects at P0/P1: none.** Every blocker is content, backend, console or platform work:

| Priority | ID | What stops a release | Owner |
| --- | --- | --- | --- |
| P0 (both stores) | E-1 | the production build cannot reach any server | Seif → one line in the app |
| P0 (both stores) | E-2 | no reachable privacy policy or terms; placeholder URLs ship | Product/legal → app |
| P0 (both stores) | E-3 | no in-app account deletion (Apple 5.1.1(v), Play 13327111) | App (needs design + copy ruling) |
| P0 (Apple upload) | E-4 | undeclared required-reason API via `device_info_plus` | App (+ owner choice of fix) |
| P0 (both stores) | E-6 | no production reviewer login | Seif |
| P0 (prerequisite) | E-7 | retention / erasure / sub-processor facts never obtained | Seif / legal |
| P0 (Play) | E-8 | no web deletion-request URL | Seif / web |
| P1 (Apple 2.1 likely rejection) | E-5 | a primary tab is a "Coming soon" placeholder | Product |
| P1 (likely-rejection risk) | H-1 | peers' real names on the board with no report/block/terms | Owner + Seif |
| P1 (release prerequisite, not a defect) | P-1, P-2 | no keystore / no iOS build | Release manager / Mac |

If the owner had to ship **today**, the prod build would launch to a login screen that can never send an
OTP (E-1); even with a host, Apple would refuse the upload (E-4) and both reviews would fail on E-2/E-3/E-6.

---

## 5. P2 / P3 follow-ups (tracked; none blocks)

| Sev | ID | Finding | Evidence | Status / owner |
| --- | --- | --- | --- | --- |
| P2 → fixed | R-2 / NR-20 | OTP consumed server-side, no tokens written when the OTP screen is popped mid-verify | red-first test; `otp_notifier.dart` | **FIXED today** |
| P3 → fixed + mechanised | NR-09 / NR-19 | `deviceInfoProvider` had no `retry:` — a Keystore / `device_info_plus` fault held the OTP verify and registration submit spinners ≈38 s (Riverpod's ten retries) | `device_info_provider.dart`; new guard `asyncProvidersWithoutRetry` (`test/guards/rules.dart`) names any `FutureProvider` / `AsyncNotifierProvider` without `retry:` — it named five on the old tree | **FIXED today**; BUG-025 |
| P2 | NR-35 | A persistent `AnswerFailed` mid-quiz (weekly limit, scope, 409, pending deletion) is a dead end: Next/Previous/Finish are dropped, only ✕ "lose your progress" remains | `quiz_bloc.dart:156-172,329-335` (SOURCE) | Bloc state-machine change + product rule (what happens when the budget runs out mid-quiz) — **owner** |
| P2 → not reproduced | NR-28 | SOURCE reasoning: non-autoDispose catalog/mistakes providers refetch token-less at sign-out and hold `AsyncError` for the next student | DEVICE today on the release build against staging: visit Learn → sign out → sign in → Learn shows the catalogue, no error (user-initiated path; the forced-logout path not exercised) | downgraded to POTENTIAL; probe the forced-logout path once staging can issue `session_superseded` |
| P3 | NR-26 | `_chooseAvatar` calls `setState` after the second await with no `mounted` guard | `edit_profile_screen.dart:233-241`; no reachable reproduction found (the sheet and the screen share a navigator, so teardown removes both) | one-line guard at the next touch, with a test if a reproduction appears — **engineering**. **CLOSED 2026-10-12 at SOURCE + the existing Edit Profile avatar tests** (implementation workspace, uncommitted, not in the main tree): `if (picked == null || !mounted) return;` after the second await in `_chooseAvatar` (`edit_profile_screen.dart:213`). **No new test**: the sheet and the screen share a navigator and no reproduction exists. Not run on a device |
| P3 | NR-17 | `AuthController._resolveInitial` is unawaited: a Keystore read failure at cold start leaves `AuthUnknown` forever | `auth_controller.dart:34-48` | decide the fallback — **owner** |
| P3 | NR-05 | a refresh answered with an unmapped 4xx leaves a zombie session (every screen errors until manual sign-out) | `auth_interceptor.dart:145-153` | §7 Q-B6 — **Seif + engineering** |
| P3 | NR-02 | no `sendTimeout`; worst case ≈105 s of spinner through a refresh on a black-hole network | `dio_client.dart:15-20` | decide — **engineering** |
| P3 | NR-12 | the quiz page shows no offline banner (every other data screen does) | `quiz_screen.dart` | product call |
| P3 | NR-29 | `lastOtpArgs` (a phone number) outlives sign-out in the router closure | `app_router.dart:101-134` | clear in `invalidateSessionScope` — **engineering**. **CLOSED 2026-10-12 at SOURCE + router tests** (implementation workspace, uncommitted, not in the main tree; `KNOWN_BUGS.md` BUG-040): fixed in `routerProvider`'s auth listener, not in `invalidateSessionScope` — `lastOtpArgs` is nulled when the status moves into `AuthUnauthenticated` from another status, kept across the post-verify flip to `AuthAuthenticated`, and a repeat of signed-out is not a session end. `test/core/router/w1_otp_args_signout_test.dart` (8 tests). Not run on a device |
| P3 | NR-30 | user sign-out gives no feedback until the revoke returns (≤35 s offline) | `profile_screen.dart:371-388` | product call |
| P3 | NR-33 | an empty `/reference/avatars` renders as an error | `avatar_sheets.dart:397-407` | engineering |
| P3 | CR-03 / CR-07 / NR-38 | `Retry-After` on 429 is parsed and discarded (explanation, leaderboard) | `quiz_bloc.dart:291-298`, `board_failure.dart:16-19` | engineering |
| P3 | CR-08 | mid-quiz weekly-limit row offers a Retry that can only 403 again | `quiz_screen.dart:217-224` | engineering (with NR-35) |
| P3 | CR-04 | three stale comments contradict the pin (poll cap, `insufficient_scope` meaning, "no notifications endpoint") | `quiz_bloc.dart:18-19`, `quiz_repository.dart:141-144`, `home_header.dart:30-36` | engineering, next touch |
| P3 | CR-05 | review screen draws the AI glyph on wrong rows only; the contract says keep the affordance on correct answers | `quiz_review_screen.dart:514-520` (inert today) | when the review tap is built |
| P3 | CR-06 / PS-75 | the level bar's fill derives from the prose constant 500 and an assumed ladder origin | `level_card.dart:23-40` | §7 Q-B4 |
| P3 | PS-46 | the phone-field hint is a real-looking number "01021871999" in both ARBs | `app_en.arb:32`, `app_ar.arb:15` | designer/owner: an obviously fictitious pattern |
| P3 | PS-65 | the image disk cache survives sign-out (today only default avatars + question images; custom avatars are `draft`) | no `emptyCache` call | engineering, when custom avatars ship at the latest |
| P3 | PS-64 | freezed `toString` on `TokenPair` / PII models would carry secrets into any future logger | `token_pair.freezed.dart:40` | override before a crash reporter is ever added |
| P3 | M-3, CR-16, M-2, `ENVIRONMENTS.md:238` | dead route; stale S37; stale "R8 off"; "preBuild" wording | — | docs/engineering hygiene |
| Observation | staging | a 400 on `/reference/cities` with no `countryCode` answers the ASP.NET default body (`type: about:blank`, no `code`) — the app always passes the parameter, so unreachable | `curl` (API) | §7 Q-B7 |

---

## 6. Owner decisions required

| # | Decision needed | Current behaviour | Options | Recommendation |
| --- | --- | --- | --- | --- |
| O-1 | **E-5** the Message tab | "Coming soon" placeholder in the primary nav | (a) hide the tab for release 1; (b) build the minimal inbox (the contract is enough for `enrolment_opened`; six dependencies open per the inbox investigation) | (a) for release 1 — a hidden tab cannot fail 2.1; the inbox returns on its own FORMULATE |
| O-2 | **E-3** deletion copy | the contract mandates confirm copy containing "paid" ×2 and "refund" (`openapi.yaml:1083-1095`) while the contract's own app rule bans purchase vocabulary (`:2080-2081`) | (a) ask Seif for an app-safe variant; (b) ship the mandated text as-is; (c) owner-written neutral copy | (a), filed as §7 Q-B2; design frames for request/confirm/cancel are owed regardless |
| O-3 | **E-4** the fix shape | `device_info_plus` for the device-binding `model` label on both platforms | (a) a ~30-line MethodChannel (`Build.MODEL` / `UIDevice.current.model`), no required-reason API, iOS half compiled in Wave 3; (b) drop `model` (optional in the contract) and the plugin; (c) keep the plugin and declare a DiskSpace reason — **not acceptable, every permitted reason is false for this app** | (a); Seif told the label is "iPhone" on iOS today anyway (`UIDevice.model`) |
| O-4 | **New — the planned "/redeem in the browser" hand-off** | `ENVIRONMENTS.md` §10 records Seif's Q7 input that the app will open the website's `/redeem` page and re-read entitlements on return, as an Env Wave 2 config slot | contract-changelog.md:360 (adr-049 §3): "The mobile app never presents a paywall, never shows a price, **never carries a purchase link, and never tells the student where to buy**"; the 2026-10-04 re-check classed an adr-171 link as a 3.1.1 violation on the Egypt storefront | **do not build the slot** until the contract itself changes the rule in a changelog entry and the owner accepts the Apple 3.1.1 risk; the identity session will annotate §10 (ID: **R-10** in `docs/RISKS.md`) |
| O-5 | **H-1** UGC on the board | peers' registered names + avatars, default-visible, no report/block, no terms acceptance | Option 0 (rank + points + avatar); or report/block + `acceptTerms` once a Terms version exists | Option 0 for release 1 |
| O-6 | **H-3 / #121 / PS-56** inert surfaces | four ON-but-disabled notification toggles; three "Coming soon" Home sections with a live-looking "See All"; Refer/Support shells; a dead referral-code field (PS-08) | hide, or finish | hide the toggles, cards' "See All" and the referral field for release 1 |
| O-7 | **H-5** minors | no age floor, no purpose line for DOB / parent phone, no consent | legal memo on declared age groups; a purpose line; whether a client floor is wanted (the contract has none) | legal memo first; nothing invented in code |
| O-8 | BUG-017 | "You'll still be listed — without your score." contradicts adr-111 | two new lines, EN + AR | owner wording |
| O-9 | #120–#126, #87/#54/#55, K-5, K-6, K-10, PS-46 | design calls recorded | — | designer rulings; none blocks |
| O-10 | NR-35 | mid-quiz persistent failure is a dead end | allow Finish from `AnswerFailed`; withhold the futile Retry | rule, then a Bloc change |
| O-11 | Orientation | the app rotates (no `screenOrientation`, iPhone landscape allowed) while every frame is portrait | lock portrait, or test landscape | lock portrait |
| O-12 | Phase 0 objection | Wave 20 + two forensic files are in the pushed history | keep; or `git rm --cached` the two files | owner's call; no rewrite either way |
| O-13 | `--obfuscate` / `--split-debug-info` | R8 is on; Dart obfuscation is not used in any documented command | decide once, before the first store build | leave off for release 1 (symbolication needs a process first) |
| O-14 | Crash visibility | zero third-party SDKs; the first release flies blind | keep (privacy) or add a crash reporter (changes both privacy forms, needs PS-64 first) | keep for release 1 |
| O-15 | Peer note A-23 | leaving Settings mid-save may leave a stale Rank value | probe; then fix or accept | probe on device |

---

## 7. Backend decisions required (for `docs/seif_fight.md`; none is filed yet unless an S-number is given)

| # | Question | Blocks |
| --- | --- | --- |
| Q-B1 | **Retention, erasure-of-non-deleted-data, log retention and sub-processors** (hosting, OTP provider) — never filed (E-7) | E-2 copy, both privacy forms |
| Q-B2 | May the app's deletion confirm screen drop "paid" / "refund" (`openapi.yaml:1083-1095` vs `:2080-2081`)? | E-3 |
| Q-B3 | Production host in `servers:` + changelog (E-1); production reviewer numbers with a fixed OTP (E-6); the web deletion page and its anti-enumeration design (E-8) | E-1, E-6, E-8 |
| Q-B4 | Level ladder origin: does level n start at (n−1)×500, and will `nextLevelAt` be exposed so the bar is not client arithmetic? (CR-06) | — |
| Q-B5 | `Retry-After` format on every 429 — delta-seconds only? (the app ignores HTTP-date) | CR-03/07 |
| Q-B6 | Which 4xx codes can `/auth/refresh` emit besides `refresh_token_invalid` / `session_superseded`, and should a non-transient 4xx end the session? (NR-05) | — |
| Q-B7 | The parameter-less `/reference/cities` 400 answers the framework default body without `code` — intended? | — |
| Q-B8 | Open S-numbers that still matter for release: S40 (which 403 wins on `createQuiz`), S39 (when a point is credited), S45 (`avatarId` 400 vs 404), S6 asks 1–3 (flashcard rounds); **S37 is stale** (staging answers `PATCH /me` and `/me/entitlements` 200 since 2026-09-22 — propose closing); **S38** asks (2)(3) now appear answered in-contract — propose narrowing to "build only" | — |
| Q-B9 | Display-name moderation or endorsement of Option 0 (H-1) | H-1 |
| Q-B10 | Whether the "/redeem in the browser" hand-off (D-021 Q7) is meant to override contract-changelog.md:360, and if so a changelog entry that says so (O-4) | — |

---

## 8. External verification required (cannot be done from this machine)

| Item | Why | Who |
| --- | --- | --- |
| iOS: build, archive, Privacy Report (E-4, ITMS-91053), `ScreenProtectorKit` on iOS 26, Keychain across reinstall, iPad layout | no Mac / Xcode | engineering with a Mac (Env Wave 3) |
| CI runs on `origin/merged` (R-3) | repo private; no `gh`; no GitHub session here | owner, one look at the Actions tab |
| The **signed** production artefact on a device (R-4's last step) | no keystore; E-1 host | release manager after E-1 + P-1 |
| 16 KB alignment of the **AAB** (APK verified at ARTEFACT today: every `.so` `p_align` ≥ 16 KB, `zipalign -P 16` OK) | `bundletool` not installed; no flavored AAB built yet | release manager |
| Real 5xx, a real 429 with `Retry-After`, a short-lived token → 401 → refresh round-trip, `session_superseded` eviction, the explanation 202→200 arm | staging cannot be made to fail on request; the seeded bank has no explanations | Seif (a forced error toggle / a seeded explanation) |
| Play pre-launch report, Data safety form acceptance | console | console owner |
| The forced-logout variant of NR-28 | needs `session_superseded` from the server | Seif + a second device |

---

## 9. Android readiness (Phase 4 — SOURCE/ARTEFACT, delegated and re-stated; BUILD/DEVICE today)

| Check | Status | Evidence |
| --- | --- | --- |
| Toolchain | READY | AGP 8.11.1, Gradle 8.14, Kotlin 2.2.20, NDK 28.2.13676358 (`settings.gradle.kts:22-23`, `gradle-wrapper.properties:5`) |
| SDKs | READY | compile 36 / min 24 / target 36 literals (`build.gradle.kts:39,56-57`), ARTEFACT `aapt2` |
| Flavors / ids / labels | READY (ARTEFACT) | `prod` → `com.levelupworld.app` "Level Up"; `staging` → `.stg` "Level Up STG"; flavor ⇄ entrypoint Gradle check (`build.gradle.kts:119-146`) |
| Version | READY for a first upload | `1.0.0+1` → `versionCode 1` |
| Release build of HEAD | **BUILD today** | `flutter build apk --release --flavor staging -t lib/main_staging.dart` → 60.9 MB in 71 s; R8 on (`mapping.txt` 11.7 MB) |
| Signing | **NOT READY (prerequisite P-1)** | `android/key.properties` absent → unsigned, fail-closed by design (`build.gradle.kts:19-25,81-100`) |
| 16 KB pages | READY (ARTEFACT) | all 12 `.so` ≥ 16 KB `p_align`; `zipalign -c -P 16` OK (prod APK of 2026-10-06 00:32) |
| Manifest | READY | INTERNET only in source (+ `ACCESS_NETWORK_STATE` merged from connectivity_plus); no cleartext; `allowBackup=false` + extraction rules; `exported` set; no deep links; not debuggable |
| Network security | READY | HTTPS only; no `http://` outside the mock |
| Release-only Dart | **NOT READY (E-1)** | `main_prod.dart` → `TBD.example`; no `kReleaseMode` branches; screen protection flavor-independent; no logging sinks |
| Assets / icon | READY | 2.1 MB of assets all bundled; adaptive icon, inset 0; no `<monochrome>` (decision) |
| Package size | 60.9 MB APK (staging release, HEAD); 59.3 MB pre-flavor AAB (2026-10-04) | — |
| Pre-launch gates | **NOT READY** | unsigned + E-1 + no flavored AAB yet |
| Orientation | OWNER DECISION | no lock |
| Doc drift found | `STORE_READINESS.md:68,195` (R8 off → on); `ENVIRONMENTS.md:238` ("preBuild" → `compileFlutterBuild`); `RELEASE_SIGNING.md:95` line range; `store_readiness_recheck.md:34` (CODE_SIGN_STYLE line is RunnerTests') | fix at next touch |

---

## 10. iOS readiness (SOURCE only — never built; Flutter 3.44.7, min iOS **15.0 ratified, 13.0 in the project**)

| Check | Status | Evidence |
| --- | --- | --- |
| Deployment target | NOT READY vs decision | `13.0` ×3 (`project.pbxproj:349,475,526`), `AppFrameworkInfo.plist` 13.0; ratified 15.0 (D-021 Q4); every plugin floor ≤ 13.0 |
| Bundle id / display name | NOT READY | `com.levelup.levelUpApp` ×3; "Level Up App" (`Info.plist:7-8`) |
| Schemes / flavors | NOT READY | one scheme; no xcconfig per flavor; `--flavor` cannot work on iOS today |
| Signing | STORE-CONFIG | no `DEVELOPMENT_TEAM`; Runner has no `CODE_SIGN_STYLE` |
| Podfile / pods | EXTERNAL | none generated; SwiftPM off; only third-party pod `ScreenProtectorKit 1.5.1` |
| Privacy manifest | **NOT READY (E-4)** | none in Runner; `device_info_plus` under-declares (above); `screen_protector` ships none |
| Permissions / purpose strings | READY | none needed, none present |
| `ITSAppUsesNonExemptEncryption` | trivial, deferred to Wave 3 | absent (answered at upload otherwise) |
| Screenshot protection | SOURCE READY / runtime CANNOT VERIFY | `ScreenProtectorKit.enabledPreventScreenshot` (secure-text-field layer, not a hard block) |
| Icons / launch | icons READY (21 sizes, 1024 RGB); launch image is the 1×1 template → decision | — |
| Localisation / family | OWNER DECISION | knownRegions `en, Base`; `TARGETED_DEVICE_FAMILY "1,2"` (iPad screenshots required) |
| Build feasibility | EXTERNAL VERIFICATION REQUIRED | no record of any iOS build; CI has no macOS job |

---

## 11. Store-policy readiness (Phase 5)

**Purchase silence: HOLDS** (SOURCE sweep + DEVICE). No price, currency, plan, upgrade, checkout,
redemption, WebView or commerce SDK anywhere in `lib/`, the ARBs, `android/`, `ios/`, `pubspec`. The
single `launchUrl` opens the three (placeholder) legal links in the external browser. Every gate surface
offers only ✕ and "Not now" (the flashcard gate has no button); copy states cadence ("this week") without
a reset promise. One copy-level exception, ratified by the owner (D-015) and mandated verbatim by the
contract (`openapi.yaml:1719-1723`): the explanation gate says "Subscribe to get step-by-step
explanations…" / "اشترك لتحصل على…" — a reviewer may read the imperative as a call to action (owner:
keep or ask Seif for a neutral variant). Soft markers for the owner: "Not now" implies an offer; the
"Promotions" notification toggle; the dead referral-code field.

**Entitlements:** server-authoritative; no `pending` state anywhere; the app never reads
`GET /me/entitlements` or the embedded list — every gate is 403-driven (CR-02, a dead refetch-on-resume).

**Policy risks by class:**

| Class | Items |
| --- | --- |
| Code problem (Flutter) | E-3 deletion screens; E-4 plugin replacement; E-2 URL swap + un-gating `/legal/*` (after content); hide-for-release-1 items once ruled (E-5, H-3, PS-08) |
| Product decision | O-1…O-15 |
| Backend dependency | E-1, E-6, E-7, E-8, Q-B2, Q-B9, Q-B10 |
| Store / account configuration | keystore + Play App Signing; App Store Connect / Play Console records on the ratified ids; Data safety / App Privacy forms (gated on E-2/E-3/E-7); listing assets (none exist); content rating; target audience; AD_ID "No"; export compliance "No"; closed-test cohort if the account is personal |

Clean areas (ARTEFACT): permissions INTERNET + ACCESS_NETWORK_STATE only; no AD_ID / POST_NOTIFICATIONS;
no analytics / crash / ads / Firebase; zero logging sinks in `lib/`; backups excluded.

---

## 12. API / contract readiness (Phase 6)

- **Pin == upstream** (no drift). The app calls **26 operations, all `stable`, none `x-consumers: [web]`,
  no `draft`** (enumerated from every `_dio.*` call site). Nine stable mobile operations are deliberately
  unconsumed: `registerFcmToken`, the terms pair, the inbox trio, the deletion pair, `getMyRank`.
- **Verified correct, no discrepancy:** auth shapes/codes/interceptor rules; `PATCH /me` tri-state email;
  `StudentProfile` field set and nullability (incl. `pendingDeletion`, `parentReportStatus`);
  `EntitlementType` sink + no `pending`; flashcards models, page/round rule, `gotIt`/`again` body, 204
  handling; no hardcoded weekly number; leaderboard paging/cursor/limit/`isMe`; quiz models, idempotent
  retry, server-authoritative points; the explanation popup copy verbatim; `insufficient_scope` /
  `validation_failed` / `account_pending_deletion` mappings.
- **Discrepancies (16, contract wins in every row):** CR-01 deletion (= E-3, HIGH); CR-02 entitlements
  dead wiring (LOW, owner); CR-03/07 `Retry-After` discarded (LOW); CR-04 stale comments (trivial);
  CR-05 review glyph gate (LOW, inert); CR-06 level-bar arithmetic (LOW, Q-B4); CR-08 futile mid-quiz
  Retry (LOW); CR-09 FCM not called (INFO); CR-10 inbox unbuilt by design (INFO); CR-11 terms inert
  (INFO); CR-12 `getMyRank` unconsumed + D-008's device pass owed (LOW); CR-13 `retakeWrong` unconsumed
  (INFO, S43); CR-14 registry wording (CONTRACT-DOC); CR-15 "lesson" copy on a lecture (LOW, S40);
  CR-16 S37 stale (docs).
- **Staging today (API):** reference routes 200 (one transient 404 on `/reference/countries` at 01:30Z,
  200 on re-probe); `/me` 401 typed; the full quiz loop and `/me` re-read on a release build (§15.2).

---

## 13. Network / error readiness (Phase 7)

- **SOURCE (delegated, re-stated):** Dio 15 s connect / 20 s receive, no send timeout; interceptors
  `[Auth, Error]`; the 401 refresh is single-flight, loop-safe, state-only, logs out only on the two
  documented codes, never on transient errors (six paths tested); every fetch-on-build provider now carries
  `retry: null` **and a guard enforces it**; every data screen renders loading / empty / error+Retry /
  offline (matrix in the delegated report, 25 screens); server `detail` strings never rendered; no logging
  sinks; swallowed exceptions limited to the documented sign-out revoke and preferences.
- **Confirmed defects:** NR-09 (fixed today), NR-20 = R-2 (fixed today), NR-26 (P3, recorded), NR-35
  (P2, owner rule). **Potential:** NR-02, NR-05, NR-12, NR-17, NR-22, NR-29, NR-30, NR-33, NR-38, NR-28
  (not reproduced on device).
- **DEVICE + API today (release build, staging):** offline → "You are offline" + Retry on the subject
  tree and a banner on Edit Profile with the form usable; reconnect → recovered; a dead stored session
  (the mock's tokens under the same package) landed the release build on `/login` at first launch —
  consistent with the forced-logout path, not proven by logs; sign-out → `/login`; re-login → fresh data.
- **Still EXTERNAL:** 5xx, real 429, refresh round-trip on an expired token, `session_superseded`.

---

## 14. Final release recommendation

### `NOT READY`

Because: the production build has no server (E-1); no privacy policy or terms exist (E-2, gated on
E-7); account deletion is not built (E-3); Apple would refuse the upload on the undeclared required-reason
API (E-4); there is no reviewer login in production (E-6); Play needs a web deletion URL (E-8); a primary
tab is a placeholder (E-5); the board exposes peers' names with no UGC controls (H-1); no keystore and
no iOS build exist (P-1, P-2). **None of these is a Flutter defect at HEAD.** The frontend's own
remaining code work is bounded and known: E-3's screens (after design + the copy ruling), E-4's plugin
replacement (after the owner picks the shape), E-2's URL swap and un-gating (after content), and the
hide-for-release-1 items once ruled.

**What became true today:** the Fable fixes are DEVICE-verified on the physical Pixel 8 as well; a
release build of HEAD completed a real login, catalogue, quiz loop, points update, offline recovery and
sign-out against staging; R-2 is closed with a red-first test; the Riverpod retry rule is mechanised;
upstream contract drift is nil; and one planned feature ("/redeem" in the browser) was caught before it
contradicted the contract's purchase-silence rule.

---

## 15. Evidence captured today

### 15.1 The owed Pixel 8 re-walk (DEVICE, `app-staging-debug.apk` of the fixed tree installed 04:37)

| Check | Result on the Pixel 8 |
| --- | --- |
| FE-06 language pill | `Button 'العربية'` (was ImageView) ✅ |
| FE-01 nav tabs | `Button 'Home' / 'Leaderboard' / 'Learn' / 'Message' / 'Account'`, label once ✅ |
| FE-02 profile rows | `Button 'Settings'`, disabled rows `Button '…, Not available yet'` ✅ |
| FE-03 subject cards | `Button 'الأحياء\n216 / 480 questions'`, no ProgressBar, cards 234 px = 89 dp ✅ |
| FE-04 share | one `Button 'Share'` (disabled) ✅ |
| FE-05 refer CTA | `"Share invite, Inviting friends isn't available yet."` once ✅ |
| FE-07 stale board | board parked on Governorate → 10-question quiz (+2) → `'10\nYou\n1,252 pts'` ✅ (`x02_pixel_board_after_quiz.png`) |
| FE-08 Arabic headline | "المستوى 3" whole, dark mode (`x01_pixel_home_ar.png`) ✅ |
| FE-09 grid at 1.3 | not run on the phone (the owner's font scale is not changed by this session); emulator proof stands |

### 15.2 Release build against staging (DEVICE + API, `Pixel_8` AVD)

Artefact: `build/app/outputs/flutter-apk/app-staging-release.apk` built from `f10b112` (`--flavor staging
-t lib/main_staging.dart`, 60.9 MB); `apksigner verify` → unsigned (by design); a **scratch copy signed
with the local Android debug key** (outside the repo) installed over the mock build (same `.stg` id).

| Step | Observation |
| --- | --- |
| Cold launch | landed on `/login`, not onboarding — the package still held the mock build's fake tokens, which staging rejected (consistent with forced logout; not log-proven) |
| OTP request | `+2010000000001` → OTP screen, "Resend in 53s" (`resendAfterSeconds` honoured) |
| Wrong number first | my first attempt typed a 10-digit number (`+201000000001`, **not whitelisted**): the server answered 202 and `000000` was refused with "This is an incorrect code, try again" — the anti-enumeration path works; one OTP may have been dispatched to that number by staging's provider, an unintended side effect of this walk, not repeated |
| Verify | `000000` → "Successful" → Continue → Home "LEVEL 1", "31 / 500", board of one |
| Catalogue | "English 0 / 53 questions" → "Unit 1" → "Chapter 1" → "LevelUp_Question_Bank_Template 0 / 53" |
| Quiz | 10 questions, each graded ("Correct answer, am"), `+2 Points`, 20 % → Home "33 / 500" — a real `POST /quizzes`, 10 × `submitAnswer`, `finish`, `/me` re-read; no AI panel appeared (`explanationAvailable` false for every question of this bank) |
| Leaderboard | `'1\nmustafa\n31 pts'` + "That's the end of the board." (real one-row board) |
| Offline | wifi + data off → subject tree "You are offline" + Retry; Edit Profile banner with the form usable; data on → recovered |
| Sign-out → sign-in → Learn | catalogue rendered, no error (NR-28 not reproduced on this path) |
| Captures | `scratchpad/emu/fable_eye/s00…s13_*.png` (outside the repo) |

### 15.3 What this pass changed in code (Phase 10 — both red-first)

| Change | Files | Proof |
| --- | --- | --- |
| R-2: `OtpNotifier.verify` captures repository, storage and the auth controller before its first await | `lib/features/auth/notifier/otp_notifier.dart`; `test/features/auth/verify_fork_test.dart` | new test red on the old code ("No matching calls" for `writeTokens`), green after |
| Riverpod retry rule mechanised: `asyncProvidersWithoutRetry` detector + six fixture proofs + the repo check; `retry: null` added to `deviceInfoProvider` and, for uniformity, `loginProvider`, `editProfileProvider`, `quizSetupProvider`, `registrationSubmitProvider` | `test/guards/rules.dart`, `rules_test.dart`, `project_rules_test.dart`; the five `lib/` files | the repo check named exactly those five on the old tree, empty after |
| Format regression from the Fable pass: `test/features/account_shells/disabled_action_button_test.dart` was committed unformatted in `a0585eb` (the earlier validate never saw it — the file was untracked when `git ls-files` fed `dart format`); `validate.ps1`'s first run today flagged it (OVERALL FAIL on format alone, 2067 / 0 / 0 on tests) | that file, whitespace only | second validate run: OVERALL PASS (recorded in `test-results.md`) |

Validation after these edits (`tool/validate.ps1`): format PASS · analyze 0 · **2067 passed / 0 failed / 0 skipped** (2059 + 8 new tests, exactly as predicted) — the record is `.ai/audits/current/test-results.md`.
