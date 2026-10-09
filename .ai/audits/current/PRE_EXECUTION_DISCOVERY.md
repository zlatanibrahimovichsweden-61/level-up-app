# Level Up: pre-execution discovery and missing-information audit

Date 2026-10-08. Branch `merged` @ `8e641e9`. READ-ONLY audit: nothing in the repo was modified except creating this file. Method: 12 investigators (Opus for the contract and planning analysis, Sonnet for the inventories), each re-checked by an independent Fable verifier and then corrected; synthesis by Opus with a Fable audit. Evidence levels: CONTRACT, SOURCE, DOC, BUILD, ARTEFACT, DEVICE, CI; never rounded up.

Contract pins: committed `0df5cf4` (3.28.0-m1); working tree `65245be` (3.38.0-m1, uncommitted); upstream HEAD at report time `eddb6ac` (**3.46.0-m1**, every one of 86 operations stable, 82 app-buildable). See section 3.0.

**Discovery status: NOT READY FOR WORKFLOW.** Three blocking owner questions are still unanswered. B-1 asks which contract pin the workflow builds against. The choice is between committing 65245be (3.38) and then re-vendoring, discarding it and re-vendoring straight to that day's upstream HEAD (eddb6ac, 3.46.0-m1 today), or waiting for a release-1 freeze from Seif (I-1). It also asks whether the pin moves per wave. B-2 asks for the release-1 scope matrix: 16 rows, including push and the Message tab, plus 2 rows that are already required. B-3 asks which protocol governs the work: the model roles in the new brief against "Subagents: Sonnet only" (wave_state.md:92-94), how work that is not one screen becomes waves, the commit policy, and where WALKs run. The discovery work itself is complete. Every dimension was investigated, Fable-verified and corrected, the cross-section errata were reconciled, and the evidence reaches CONTRACT, SOURCE, BUILD, ARTEFACT and CI level. Without B-1 the operation set is unknown: it is 35, 49 or 82 app-buildable operations depending on the pin, and push, ban, photo and legal content exists only from 3.42–3.46. Without B-2 neither the wave count nor the store duties can be fixed. Without B-3, FORMULATE cannot give the remaining multi-screen and non-screen work a wave shape. Until the owner answers, only a provisional, owner-gated Wave 0 can be drafted: a contract-only re-vendor to that day's HEAD after `git ls-remote`, followed by a re-census. Env Waves 2–4, the store blockers and the conformance fixes (the Accept header and global 403 routing) can be drafted too, but no feature wave can.

> A Fable audit of sections 1, 4, 14-17, 19 and 20 ran last. Its HIGH finding is corrected in the text; its MEDIUM and LOW findings are listed in the final Appendix and supersede the text they name.

## 1. Executive summary

### 1. Executive summary

**Discovery verdict: NOT READY FOR WORKFLOW.** Three questions block the workflow: B-1 (the contract pin), B-2 (release-1 scope) and B-3 (the protocol and model roles). All facts below were re-checked read-only on 2026-10-08/09. Levels are given in brackets and are never rounded up.

**Git and repository**
- **Repository state** (SOURCE, `git status -sb` on 2026-10-09):
  - `merged` @ `8e641e9` is 1 commit ahead of `origin/merged` `c87b90a`. The unpushed commit is docs-only: `docs/ENVIRONMENTS.md` and `env_chapter_state.md`.
  - The only tracked changes are the 5 `contract/*` files of the uncommitted 3.38 re-vendor (+1,498/−217). They are blob-identical to upstream `65245be`.
  - Three files are untracked: the two stale roadmap files (5.2 MB HTML and 444 KB JSON, pinned to `0df5cf4`) and this report.
  - `main` `e71e9a1` is a strict ancestor of `merged`, 32 commits behind, so an `--ff-only` promotion is possible. `dev`'s 6 local commits are already contained in `merged` and `main`.
  - Waves 20–22 are committed and pushed (`fa88b3a`, `af0eadb`, `a988a1f`). `wave_state.md` still says that Waves 20 and 21 are uncommitted.
- **Work that is at risk or wrong** (SOURCE):
  - The `xargs -s 7000` batching patch exists only in two gitignored worktrees.
  - `tell_claude.md` exists only on the local branch `backup/2026-08-22-dirty-tree`.
  - `contract/SOURCE.md:17` says the files are "CRLF exactly as upstream stores them". The blobs are LF, so this sentence must be fixed before any contract commit.

**Contract**
- **The pins** (CONTRACT, PyYAML census):

  | Pin | Commit | Version | Operations | Stable | Draft | App-buildable |
  |---|---|---|---|---|---|---|
  | Committed | `0df5cf4` | 3.28.0-m1 | 54 | 38 | 16 | 35 |
  | Working tree (uncommitted) | `65245be` | 3.38.0-m1 | 77 | 53 | 24 | 49 |
  | Upstream HEAD | `eddb6ac` | 3.46.0-m1 | 86 | 86 | 0 | 82 |

  - `eddb6ac` was mirrored 2026-10-08 14:56 UTC, and `git ls-remote` confirmed it as HEAD again on 2026-10-09.
  - At `eddb6ac`, 4 operations are web-only (`requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `redeemSubscriptionCode`, `listTerms`), which leaves 82 app-buildable.
  - `servers:` lists staging only.
- **What 3.46 changed** (CONTRACT + LIVE-PROBE):
  - It changed only the version line and 5 `x-stability` lines. Avatar upload/remove and the 3 support-photo operations flipped to stable. Seif states "no shape changed".
  - `realtime.md` and `error-codes.md` did not change.
  - Staging `/health/version` reports backend `a158daa`, the commit that `eddb6ac` mirrors (unauthenticated probe on 2026-10-08, below DEVICE).
- **Moving-pin rule** (CONTRACT):
  - Upstream moved 8 minor versions (3.39 → 3.46) in about 28 hours.
  - "3.38.0-m1" names three different snapshots, so pin by commit, never by version.
  - Run `git ls-remote https://github.com/seifhamdii-collab/level-up-contract HEAD` at workflow start and before any wave that consumes a new operation.
  - Vendor LF blobs with `git show <sha>:<file>`. The contract guard fails 13 of 14 tests on CRLF copies, with a misleading "no required:" error.
  - Re-census after every move.
- **The 3.38 copy is already obsolete for planning** (CONTRACT). It lacks:
  - the push section (3.43), and it spells the chat push kind `ChatMessageReceived`;
  - `403 account_banned` (3.42);
  - `getLegalDocument` (3.43);
  - stable recovery, chat, support, track transfer, favourites and quiz review (3.39);
  - referral (3.44);
  - the photo and avatar operations (stable since 3.46).

**The app**
- **API consumption** (SOURCE + BUILD):
  - The app calls exactly 26 operations. All are stable at every pin, and none is draft, web-only or invented.
  - Of the 82 app-buildable operations: 25 are implemented (24 with a screen, plus `refreshTokens`), 1 is data-layer only (`getMyEntitlements`, never watched) and **56 are not integrated**.
  - Only two consumed operations changed by 3.46, both additively:
    - `verifyOtp` gained `403 account_banned` (3.42, a behavioural change).
    - Registration gained the optional `inviteCode` / `inviteCodeApplied` (3.43/3.44).
- **What is built** (SOURCE):
  - Auth and OTP; School and University registration; onboarding; profile, edit profile and default avatars; settings (partial); Home.
  - The catalogue (School tree and University lectures); the quiz (Bloc); flashcards; Mistakes (read-only); the leaderboard; the limit sheet; logout; and the forced logout on `session_superseded`.
  - The purchase-silence sweep is clean. The one exception is the contract-verbatim "Subscribe to get…" line, kept by ruling D-015.
- **What has been walked** (DOC):
  - All 22 API→UI waves are implemented. 21 were walked to 100% on the physical Pixel 8 against the **mock** backend. Wave 03 (School registration) was never walked.
  - The only run against a real server was the 2026-10-06 staging release build on the `Pixel_8` **AVD**, school track only: login, catalogue, a 10-question loop (+2 points), the leaderboard, offline and sign-out.
  - The phone's 2026-10-06 re-walk was a debug build on mock data.
  - Never run against a real server: the University track, lectures, flashcards, Mistakes, the explanation 202→200 transition and `session_superseded`. No release build has ever run on physical hardware.
- **BUILD results** (2026-10-08):
  - Working tree with the 3.38 files: format 0 changed (369 files), analyze 0, 2067 passed / 0 failed / 0 skipped, guards 122/122.
  - Isolated clone with the 3.45 files: 2067/0/0, guards 122/122, no codegen or l10n drift.
  - No BUILD run exists at 3.46 yet. One is owed before any re-vendor commit.
  - At 3.46 the contract guard binds only 7 of the 34 response schemas that carry a `required` list (27 unbound).

**The biggest gaps**
- **Push** (SOURCE + CONTRACT):
  - The app has no push code at all: no Firebase, no `POST_NOTIFICATIONS`, no token call, no native strings and no tap destinations.
  - The shape has been stable since 3.43, but delivery is OFF in every environment.
  - There is no unregister operation, and `logout` says nothing about the token (I-3).
  - RISKS R-9 forbids any Firebase registration until ownership is settled.
- **Chat and social** (SOURCE + CONTRACT):
  - The contract has 10 stable chat operations plus the hub (3.39/3.44) and 13 stable social operations (friend graph since 3.37). The app makes zero calls to any of them.
  - `/message` is a placeholder, and `/friends` is a shell with no entry point. There is no SignalR client.
  - Figma draws photo and voice chat, which the contract excludes.
  - There are no frames for report, block, unfriend or the blocked list.
- **Support** (SOURCE + CONTRACT):
  - 5 text operations (stable 3.39) and 3 photo operations (stable 3.46); `/support` is a disabled shell.
  - Photos also need Terms acceptance, an image picker and a downscale step. `crypto` is already present as a transitive dependency.
- **Account deletion and cancel** (CONTRACT + SOURCE):
  - Both operations are stable at every pin, but there is no UI and there are no frames.
  - The contract-mandated confirm copy says "paid … no partial refund". Q-B2, which asks Seif about it, was never filed.
  - Students with a pending deletion hit a dead end at 5 copy sites. This is store blocker E-3.
- **Legal documents and Terms** (CONTRACT + SOURCE + LIVE-PROBE):
  - `getLegalDocument` has been stable since 3.43, and staging serves `r4-2026-10-07` in Arabic and English.
  - In the app, `/legal/*` are signed-in-only "not published" shells, and the Login links point to `levelup.example`.
  - `getTermsAcceptance` and `acceptTerms` are stable at every vendored pin (0df5cf4 included) and are never called.
  - Photo uploads return 403 until the student accepts Terms. That gate is live on staging.
- **Banned accounts** (SOURCE + CONTRACT):
  - `account_banned` falls through to "Something went wrong" after the OTP has been consumed.
  - The contract asks for a dedicated screen, but none of the 19 public operations is a support operation, so a banned student has no signed-out path to Support (I-4).
- **iOS** (SOURCE):
  - The project still has the template id `com.levelup.levelUpApp` and a 13.0 deployment target. The ratified values are `com.levelupworld.app` / `.stg` and 15.0.
  - It has never been built: no team, no Podfile, no entitlements and no `PrivacyInfo.xcprivacy`. No Mac is known.
  - Android identity is applied and proven in the built APK, on `merged` only.
- **Other gaps** (SOURCE):
  - No `Accept: application/json` header is sent, although the contract has asked for it since 3.32, and the comment at `error_interceptor.dart:9-10` is stale.
  - The inbox has been stable since 3.28, but the Home bell is inert.
  - The referral code is collected at sign-up and dropped.
  - The handoff asks for a subscription screen "with a website link". That conflicts with adr-049 §3/§4, which no version up to 3.46 revises, and R-10 is open.

**Store blockers**
- **P0, all open:**
  - E-1: production host (`TBD.example`; `servers:` lists staging only).
  - E-2: legal documents. The text now exists; still owed: app wiring, approval, legal entity, a public URL and the Terms gate.
  - E-3: in-app account deletion.
  - E-4: iOS required-reason API (`device_info_plus`).
  - E-6: reviewer login (the fixed-OTP whitelist is absent from production).
  - E-7: retention and sub-processor facts (narrowed by the staging policy text).
  - E-8: the web deletion URL for Play.
  - AND-02: keystore and Play App Signing (`key.properties` is absent).
- **Do not upload the only AAB on disk.** It carries the dropped id `com.levelup.level_up_app`, and no flavored AAB exists.
- **P1:** the Message tab (E-5), leaderboard peer names (H-1), iOS, and the listing assets, which include a missing support URL/email.
- **Conditional P0:** UGC controls if social features ship; push prerequisites if push ships.
- **Correction:** R8 is ON for release builds, but `mapping.txt` is archived nowhere.

**Gates**
- **CI** (CI):
  - 15 runs in total. On `merged`, 12 runs: 11 green and 1 format failure at `f10b112`. `main` had 2 runs and `dev` 1, all green.
  - The latest run, at `c87b90a`, is green. R-3 ("CI never observed") is stale.
  - The flavored release compile gate runs on pushes to `main` only and has never run in its flavored form (the two `main` runs of 2026-09-19/20 predate `2dfd969`). Codegen-drift also accepts `workflow_dispatch`.
  - No branch is protected, so no check is required.
- **Local gates** (BUILD):
  - Hooks are inactive (`core.hooksPath` unset, mode 100644).
  - `tool/validate.sh` fails on Windows Git Bash (exit 123).
  - The local format step skips untracked `.dart` files; this is what caused the `f10b112` CI failure.
- **Missing guards:** nothing enforces the four screen states, purchase silence, the no-logging rule or the iOS identity.
- **Upcoming change:** `ubuntu-latest` moves to Ubuntu 26 from 2026-10-19.

**Device**
- **Physical phone** (DEVICE): a Pixel 8 on Android 17 / API 37 over USB. On 2026-10-08 it had `com.levelup.level_up_app` (orphan) and `com.levelupworld.app.stg` installed; prod was not installed.
- **Availability:** the phone was absent at 2026-10-08 22:03 and absent at one check on 2026-10-09, then present again at the Fable audit and at report assembly (`adb devices -l`: Pixel 8, authorised, 2026-10-09). It comes and goes, so every WALK must re-check. `adb` is not on PATH.
- **Emulators:** the AVDs `Pixel_8` and `Medium_Phone_API_36.1` exist.
- **Walk limits:**
  - FLAG_SECURE blacks out screencaps of the quiz and review screens.
  - The documented WALK command lacks `--flavor`, which Gradle has refused since `2dfd969`.
  - The mock backend has no route for anything added in 3.39–3.46.
- No iOS device is known.

**Protocol**
- **Current rules** (DOC, `wave_state.md:92-94`):
  - nothing advances without the owner's NEXT, WALK or FORMULATE;
  - one screen per wave;
  - "Subagents: Sonnet only";
  - a checkpoint at about 40% context;
  - nothing is committed unless the owner asks.
- **Conflicts with the new brief:**
  - The 22-wave FORMULATE list is used up.
  - About half the remaining work is not a single screen.
  - The brief's split of Opus orchestration, Sonnet execution and Fable audit conflicts with "Sonnet only".

**Records** (SOURCE)
- Q-B1 to Q-B10 from 2026-10-06 were never filed in `docs/seif_fight.md`.
- The contract now answers S5, S11, S14, S24, S29, S30, S31 and S33.
- Stale project documents:
  - R-3, `WAVE_STATUS.md` and `wave_state.md`.
  - The `CLAUDE.md` counts: 849 tests (now 2067), 63 commits (now 136), pin `184d6ec` (now `0df5cf4`), 48 DESIGN_ISSUES entries (now 125).
  - `STORE_READINESS.md:68`, which says R8 is off.

**The three blocking questions**
- **B-1 · pin:** commit `65245be` and then re-vendor, discard it and re-vendor to that day's HEAD, or wait for Seif's freeze. Also: should the pin move during the workflow?
- **B-2 · release-1 scope:** 16 rows (plus 2 already required), including push and the Message tab.
- **B-3 · protocol:** model roles against "Sonnet only", how non-screen work becomes waves, the commit policy, and where WALKs run.

22 important questions (I-1 to I-22) block named waves, and 26 non-blocking ones (N-1 to N-26) have safe defaults.

## 1A. Errata and cross-section reconciliation (supersedes section text)

**Critic pass: completeness and consistency across the 12 corrected sections (cor_*.md), 2026-10-08.**

**Method.** I read all 12 `cor_*.md` files in full and scanned the `remaining_questions`, `key_facts` and `disputes` fields of every `cor_*.json`. I re-derived the facts that decide each disagreement from primary sources, read-only:
- `git ls-remote` on the contract repo returns HEAD `eddb6ac`.
- A PyYAML census of all four pins (`SCRATCH/crit/census346.py`).
- A re-run of the guard-coverage script against 3.46 (`SCRATCH/crit/guard_cov346.py`).
- `gh run list` and `gh run view --json jobs`.
- `adb` and `flutter devices`.
- Greps over `lib/`, `docs/` and `.ai/`.
- A secret-pattern scan of the tracked files and of the full git history.
- The R8 mapping artefacts under `build/`.

**Repo state.** I modified nothing in the repo; all scripts are under `SCRATCH/crit/`. The repo is unchanged at `8e641e9`, with one exception: a new untracked file, `.ai/audits/current/PRE_EXECUTION_DISCOVERY.md` (608,110 B), appeared at 22:00:08 +0300. The orchestrating workflow wrote it (its own header says so); this critic did not.

**Row prefixes in the errata table:**
- **A** = a fact two or more sections state differently.
- **B** = staleness caused by 3.46 (`eddb6ac`).
- **C** = document drift that no section caught.

### Errata and cross-section reconciliation

| # | Section | Statement as written | Correct fact | Evidence | Level |
|---|---|---|---|---|---|
| A1 | store (`cor_store.md:95`); env_push_impl (`:106`); roadmap_registers (`:99`, `:126`) | store: "never observed running (R-3, cannot verify from here)". env: "G-8 … CI never observed, R-3". roadmap: "R-3 … Unchanged … CI runs cannot be checked from this machine"; "S1 … R-3 open" | CI has run 15 times:<br>• 12 on `merged`: 11 success, 1 failure (`f10b112`, format step).<br>• 2 on `main`, both success.<br>• 1 on `dev`, success.<br>The latest pushed head `c87b90a` is green. CI is observable through `gh` 2.102.0, authenticated as the owner. R-3 should be closed. S1's "observe CI" is now a routine `gh run list` after each push. | Critic re-ran `gh run list` and got 15 runs (ids 31889824926 … 37403810413); `cor_git.md:14`; `cor_ci_validation.md:13` | CI |
| A2 | git (`:181`) vs ci_validation (`:45`) | git: goldens "succeeded on 12 of 12 [merged runs] … and on the `main` run". ci: "Green in all 15 runs" | ci_validation is right. Goldens also passed on dev run 31889824926 and on both main runs (35459502111, 35543020958). | `gh run view --json jobs` on the three non-merged runs, re-run by the critic | CI |
| A3 | features_learning (`:157`); the orchestrator fact "physical Pixel 8 did a debug staging re-walk (§15.1)" | "The only real-server device pass is the 2026-10-06 release build against staging" (no device named) | The only run against a real server was on the **`Pixel_8` AVD (emulator)** (§15.2).<br>The physical Pixel 8 (§15.1) ran `app-staging-debug.apk`. That APK has the staging-*flavor* identity but was built from `main_mock.dart`, and its data are mock data:<br>• Biology 216/480 = `mock_backend.dart:1519`.<br>• 1,252 pts = mock `_totalPoints = 1250` (`:100`) plus 2.<br>Staging showed English 0/53 and 31→33 pts.<br>**No physical-device run against a real server exists.** Read every "DEVICE against staging" claim as emulator. | reconciliation `:367`, `:381`, `:387-392`; `env_wave1_report.md:69,92`; `RISKS.md:77` | DOC + SOURCE |
| A4 | roadmap_registers (`:12`); features_learning (`:156`) vs design (`:49`) | "All 22 formulated waves are complete"; "100% for W05-W18 and W22" | All 22 waves are implemented, and 21 were walked to 100%. Wave 03 (School registration) is "CLOSED (implemented, unwalked)": the owner advanced with NEXT, not WALK. | `wave_state.md:22-24`, `:187` | DOC |
| A5 | design §3 Quiz-history row (`:75`) | "`listQuizHistory` + `getQuizReview` **stable** since 3.43" | `getQuizReview` has been stable since **3.39** (`e5886a6`; draft in the 65245be parse). Only `listQuizHistory` is 3.43. contract_delta `:105`/`:129`, api_census `:180` and learning `:129` already say 3.39. | Critic census (draft at 65245be); changelog@eddb6ac 3.39 entry `:124` | CONTRACT |
| A6 | design (`:12`, `:74`, `:117`) | "`getMyQuizSummary` has been stable since 3.38" | It flipped in **3.37** (`285d5a8`). 65245be (3.38) is just the first pin that could be vendored with it. contract_delta `:103`, api_census `:160` and learning `:38` say 3.37. | changelog@eddb6ac `:150`, `:154` | CONTRACT |
| A7 | api_census (`:258`); store E-3 row (`:66`) | "contract-mandated text contains 'paid' twice and 'refund' (openapi.yaml:1083-1095) while the contract's own app rule bans purchase vocabulary (:2080-2081)"; "vocabulary rule at :2449-2450 conflicts" | features_account §5 (`:122`) is right. The word list is "no price, no 'buy', no 'purchase', no 'payment', no provider name". It sits inside the web-only `redeemSubscriptionCode` 500 text, and "paid"/"refund" are not on it. The real tension is with adr-049 §3's intent and Apple 3.1.1, so Q-B2/DR-03 should be framed that way. api_census's cites are unlabelled 0df5cf4 line numbers. | openapi@eddb6ac `:1284-1285` (confirm copy), `:2450-2451` (word list); @0df5cf4 `:1088-1091`, `:2080-2081` | CONTRACT |
| A8 | design (`:86`) vs features_account (`:18`) vs features_social (`:209`) | "six surfaces" / "five code sites" / "7 files across 6 features" | All three are right once the units are named:<br>• 5 copy-producing sites: `catalog_states.dart:106`, `flashcards_error_copy.dart:82`, `board_failure.dart:18`, `profile_error_copy.dart:22`, `quiz_error_copy.dart:31`.<br>• 7 files call `isAccountPendingDeletion`, plus its definition in `exceptions.dart`.<br>• 6 features: catalog, flashcards, leaderboard, mistakes, profile, quiz. | grep over `lib/` | SOURCE |
| A9 | git §6 (`:110`), §12 (`:206`) | The handoff's "2067/0/0, guard 14/14" for the 3.38 re-vendor "remains DOC" | It was reproduced at BUILD in the live working tree: format 0 changed, analyze 0, `+2067: All tests passed!`, guards 122/122 including contract_models 14/14. It was not run via `validate.ps1` and not in a throwaway worktree. | `cor_contract_delta.md:61`; `cor_ci_validation.md:21-24`; SCRATCH `test_full.log`, `guards_338_worktree.log` | BUILD |
| A10 | features_account (`:7`, `:19`, §7 Terms row); api_census (`:245`); contract_delta (`:385`) | "Staging was never called … Seif's own changelog (DOC)"; "no network probe was made"; "nothing was probed" | store, social and upload_push probed staging on 2026-10-08 (unauthenticated GETs):<br>• Legal docs return 200 for terms/privacy × ar/en, at `r4-2026-10-07`.<br>• `/health/version` returns commit a158daa, built 15:16:14Z.<br>• These routes return 401, which means the route exists: `/me/invite`, `/friend-streaks`, `/conversations`, `/support/tickets`, `/me/notifications`, `/hubs/chat` and all five photo routes. Control paths return 404.<br>This proves the routes are registered, not their behaviour. | `cor_store.md:5`, `:20`; `cor_features_social.md:31`; `cor_upload_push_contract.md:48-53` | API (LIVE-PROBE, below DEVICE) |
| A11 | store iOS-minimum row (`:57`) vs env_push_impl (`:79`) | "Firebase iOS floor is UNKNOWN (not checked)" | `firebase_core` 4.3.0 (in the pub cache, from another project) declares `ios.deployment_target = '15.0'`. That Firebase generation cannot install at the project's 13.0, so the ratified 15.0 is a practical prerequisite for push. Which version the project would adopt is UNKNOWN. | `firebase_core-4.3.0/ios/firebase_core.podspec:30` | SOURCE |
| A12 | store "Release hardening" row (`:73`), echoing `docs/STORE_READINESS.md:68` | "R8 / resource shrinking off … no mapping file" | **R8 and resource shrinking are ON** for release builds. This is Flutter's default: `FlutterPlugin.kt:215-227` sets `isMinifyEnabled = true` and `isShrinkResources`, and `FlutterPluginUtils.kt:208-215` defaults the shrink switch to true. Mapping files exist: `build/app/outputs/mapping/{prodRelease,stagingRelease,release}/mapping.txt` (11.7 MB, header "# compiler: R8"). RISKS.md:77 also says "R8 on".<br>What *is* true: there is no Dart `--obfuscate`/`--split-debug-info` (DR-13), no `proguard-rules.pro`, and the mapping file is archived nowhere (Play needs it to de-obfuscate crashes). | `C:\flutter\packages\flutter_tools\gradle\src\main\kotlin\FlutterPlugin.kt`; the mapping files | ARTEFACT + SOURCE |
| A13 | store §5 (`:170`) vs design (`:41`) | store: "P1 … E-5 Message tab". design: E-5 is among the "Release blockers … E-1..E-8" | The source document contradicts itself: §3.1 `:73` says "E-5 RELEASE BLOCKER (Apple 2.1 likely)", while §4 `:141` says "P1 (Apple 2.1 likely rejection)". Treat E-5 as a P1 likely rejection; DR-01 settles it. | `release_readiness_reconciliation_2026-10-06.md:73`, `:141` | DOC |
| A14 | features_social headline 10 (`:31`); store (`:5`) | "a158daa … is newer than the one the 3.45 contract mirrors … staging may carry changes not yet in any contract"; "staging was built after the mirror was cut" | `eddb6ac` is "Mirror contract from level-up-backend@a158daa…" (14:56:03Z), the same backend commit staging reports (built 15:16:14Z). **Staging runs exactly the backend that the 3.46 mirror describes.** | `git log` in the upstream clone; `/health/version` | CONTRACT + API |
| A15 | features_social headline 3 (`:24`) | "Pinning at 3.38 therefore unlocks the friend graph only" | This holds within the social dimension only. Across the whole contract, 65245be adds 14 app-buildable operations over 0df5cf4 (35 → 49): 12 social, plus `listModules` and `getMyQuizSummary`. | Critic census | CONTRACT |
| A16 | features_social (`:125`); api_census (`:188`) | "There is no UUID generator for `clientMessageId`"; "pubspec.yaml has no http, WebSocket …" | There is no **direct** dependency for these. pubspec.lock already has them **transitively**: `uuid` 4.6.0, `crypto` 3.0.7, `http` 1.6.0, `http_parser` 4.1.2, `mime` 2.0.0, `web_socket_channel` 3.0.3. Promoting one is a pubspec change, not a new third-party package; Dio's `FormData` already covers the avatar multipart. Genuinely absent: SignalR client, image picker/compression, Markdown renderer, share, Firebase, local notifications, permission handler. | pubspec.lock lookup | SOURCE |
| A17 | features_account (`:7`) | "Tests were read, not executed, because … `flutter test` may regenerate the tracked l10n" | `flutter test --no-pub` (full suite and per area) ran with identical `git status`/`git diff` fingerprints before and after. Running the suite does not dirty the tree. | `cor_ci_validation.md:20`, `:27` | BUILD |
| A18 | env_push_impl (`:36`); orchestrator device fact | The device is attached and its packages are installed | At 2026-10-08 22:03 +0300, `adb devices -l` lists no device, and `flutter devices` lists only Windows, Chrome and Edge. The AVDs `Pixel_8` and `Medium_Phone_API_36.1` exist. The device comes and goes, so every WALK must re-check. | adb (`platform-tools\adb.exe`); `emulator -list-avds` | DEVICE (negative) |
| B1 | api_census headline (`:13`) | "At the 3.45 upstream head there are **77** stable app-buildable operations … **51 are not implemented**. All 5 draft operations … untouched" | At `eddb6ac` (3.46.0-m1): 86 operations, 86 stable, 0 draft, 4 web-only, 82 app-buildable. Of the 82: 25 implemented, 1 data-layer-only, 56 not implemented, and all 56 are now stable. | `crit/census346.py`; `git ls-remote` HEAD = `eddb6aca99…` | CONTRACT |
| B2 | api_census rows (`:53-54`, `:91-93`) | `uploadCustomAvatar` "D … NOT IMPLEMENTED (draft; not buildable under the stable-only rule)"; `removeCustomAvatar` and the three support-attachment rows "(draft)" | All five are stable at 3.46. They remain unimplemented. They become buildable once the pin is ≥ `eddb6ac`, and photo uploads still return `403 terms_acceptance_required` until the student accepts Terms. | openapi@eddb6ac `:981`, `:1041`, `:2848`, `:2899`, `:2945` | CONTRACT |
| B3 | api_census Counts (`:118`, `:126-131`, `:156`) | "stable 38 / 53 / 81, draft 16 / 24 / 5 … 77"; "25 (32.5 percent) ship" | Add a 3.46 row: 86 stable, 82 mobile, 26 consumed, 56 stable-mobile unconsumed, 0 draft. Of the 82, 25 ship (30.5%) and 26 have a repo method (31.7%). | Critic census | CONTRACT |
| B4 | api_census Focused list B (`:171`) | "28; stable at 2e5bb69, not at 65245be" | **33** at `eddb6ac`: the 28 plus the 5 photo operations flipped in 3.46. | same | CONTRACT |
| B5 | api_census "Support launch coupling" (`:223`) | "the stated promotion trigger for the five operations still draft" | The trigger was met. 3.46 records the staging live proof (photos 18/0, avatars 19/0) and flips all five, with "Breaking: no; no shape changed". adr-187's condition ("support does not launch until attachments ship") is satisfied at contract level. Text-first versus photos-together is now purely a scope decision (DR-25). | changelog@eddb6ac `:9-20` | CONTRACT |
| B6 | api_census (`:240`) | "Still true at 3.45: `avatar_sheets.dart:196-197`, `profile_update.dart:44`, `edit_profile_screen.dart:35,46` (`uploadCustomAvatar` is draft)" | These TODOs are stale at 3.46. | openapi@eddb6ac `:981` | CONTRACT |
| B7 | api_census (`:245`, `:255`, `:267`); json `remaining_questions[0]`, `key_facts[1]`, `[5]` | "no network probe was made"; "re-vendor to 2e5bb69 or later"; "five photo operations still draft"; "When will Seif promote …?" | Staging was probed (see A10). The candidate head is `eddb6ac`. The promotion happened on 2026-10-08, with shapes identical to the draft text. | `diff 2e5bb69 eddb6ac`: 5 `x-stability` lines and the version line | CONTRACT |
| B8 | contract_delta census (`:7`, `:14-28`, `:32-38`) | "upstream HEAD `2e5bb69` … 86 / 81 / 5 / 77"; "The five drafts left at 3.45 are …" | Upstream HEAD is `eddb6ac`: 86 operations, 86 stable / 0 draft, 82 app-buildable, 63 schemas.<br>• error-codes.md (62 codes) and realtime.md are unchanged.<br>• openapi.yaml is still 4,935 lines; the version line and 5 `x-stability` lines changed in place.<br>• The changelog is now 648 lines, 12 more than at 3.45.<br>No drafts remain. | Critic diff and census | CONTRACT |
| B9 | contract_delta (`:123`, `:258`, `:323`) | "Avatars … both are draft"; "No custom avatars can exist while upload is draft"; "Both avatar ops are still draft at 3.45" | Both avatar operations have been stable since 3.46. The staging live proof uploaded avatars (19 PASS), so a staging profile may already return `avatar.type: custom`. `ProfileAvatar` decodes that (`student_profile.dart:115-122`). | changelog@eddb6ac `:9-20` | CONTRACT |
| B10 | contract_delta Options (`:334`, `:337`) | Option B "Re-vendor straight to 2e5bb69 (3.45) … 17 versions; census 86/81/5/77"; "Upstream moved 12 commits and 7 versions (3.39–3.45) in about 32 hours" | Option B now targets `eddb6ac`: 18 versions (3.28 → 3.46), census 86/86/0/82. Upstream is 13 commits and 8 versions (3.39–3.46) past 65245be as of 2026-10-08 14:56Z. | `git log 0df5cf4..eddb6ac` (21 commits) | CONTRACT |
| B11 | contract_delta (`:347`, `:354`, `:389`); json `remaining_questions[5]`, `[9]`, `key_facts[0]`, `[11]` | "When the 5 photo and avatar drafts flip … no date"; "support tag … while 3 draft photo ops carry that tag"; "Whether upstream has moved past 2e5bb69" | The drafts flipped on 2026-10-08. The tag inconsistency now runs the other way: the `support` tag still says "Text only for launch … attachments arrive later" while the attachment operations are stable. Upstream has moved to `eddb6ac`. | openapi@eddb6ac `:133-137` | CONTRACT |
| B12 | features_account (`:9`, `:24`, `:44`, `:73-74`) | "`uploadCustomAvatar` draft x3, `removeCustomAvatar` -/-/draft"; "§1.12 … still draft at C45"; row 12 "draft-only" | Both are stable at 3.46. Row 12 becomes "contract-ready, not integrated". | openapi@eddb6ac `:981`, `:1041` | CONTRACT |
| B13 | features_account (`:133`, `:137`, `:168`, `:171`) | "still draft at C45"; "support: 3 draft ops"; "Whether 3.45 itself is deployed to staging is not established"; "§8.4 … both still draft" | All of these are stable. The Terms gate is live on staging (see Additional finding 1). Staging runs a158daa, the source of the 3.46 mirror (A14). | — | CONTRACT + API |
| B14 | features_social headline 3 (`:24`); json `key_facts[1]` | "The only social-adjacent drafts left at 3.45 are … 3.45 = 86 / 81 / 5" | There are 0 drafts at 3.46 (86/86). | Critic census | CONTRACT |
| B15 | features_social (`:140`, `:147`, `:148`, `:265`, `:279`); json `remaining_questions[5]`, `key_facts[5]` | "**draft at 3.45**"; "three `support`-tagged operations are `draft`"; Support-photos row "none / **draft** \| Backend (draft) \| No (stable-only rule)"; "Upload endpoints now exist as draft at 3.45" | Stable at 3.46. What still blocks support photos: the pin, the Terms step, an image-picker/downscale dependency decision, and the missing design states. | openapi@eddb6ac `:2848`, `:2899`, `:2945` | CONTRACT |
| B16 | design (`:20`, `:22`, `:69`, `:70`) | Pin table "support … 5 stable, 3 draft (photo ops)"; Avatar row "**draft** … Draft, so not buildable under the stable-only rule"; Support row "Photos … are **draft**" | At 3.46: support is 8 stable, and avatar plus photos are buildable at a pin ≥ `eddb6ac`. | same | CONTRACT |
| B17 | design (`:106`, `:113`, `:114`); json `key_facts[4]`, `remaining_questions[5]` | "The three photo operations are **still draft at 3.45**, so they are not buildable …"; "avatar upload (draft), support photos (draft)"; "What is missing is stability, not shapes" | Stability arrived in 3.46 with no shape change, so nothing is missing on the contract side. The domain-rule-9 question (picker versus camera for minors) still stands. | changelog@eddb6ac `:9-20` | CONTRACT |
| B18 | store (`:76`, `:140`, `:149`); json `key_facts[11]` | "Avatar upload, support photos \| BLOCKED (contract draft) … still `draft` at 3.45"; "under the stable-only rule they cannot ship yet"; "stable (+ photos draft)" | The contract no longer blocks them. The status becomes "BLOCKED by pin + Terms acceptance UI + picker/permission decision + design". | same | CONTRACT |
| B19 | store (`:5`) | "staging was built after the mirror was cut" (2e5bb69 / f5e5424) | See A14: staging runs a158daa, the backend that `eddb6ac` mirrors. | — | CONTRACT + API |
| B20 | roadmap_registers (`:7`); json `key_facts[0]` | "contract upstream 3.45.0-m1 `2e5bb69`"; "81 stable, 77 app-buildable; 42 … not stable at the committed pin" | `eddb6ac` 86/82. 47 app-buildable operations are stable at 3.46 but not at 0df5cf4. | Critic census | CONTRACT |
| B21 | roadmap_registers S29 (`:71`), S33 (`:75`), N-04 (`:156`) | "**OPEN (still draft)**"; "The photo operations are still draft"; "photos wait for the draft operations" | S29 can be closed: the operations are stable since 3.46 and the semantics were already answered in 3.42 (`cor_upload_push_contract.md:224`). S33 is fully answered (text 3.39, photos 3.46). For N-04, photos now wait only on the pin, the Terms step, the picker dependency and design. | changelog@eddb6ac `:9-20` | CONTRACT |
| B22 | roadmap_registers R-8 (`:103`), G-03 (`:145`), DR-23 (`:197`), DR-25 (`:199`) | "28 … (42 versus the committed …)"; "17 minor versions behind … 20 upstream commits"; "Upstream is now `2e5bb69` … 12 commits past `65245be` and 20 past `0df5cf4`"; "About 77 app-buildable" | At `eddb6ac`:<br>• R-8: 33 newly app-buildable vs 65245be; 47 vs 0df5cf4.<br>• G-03: 18 versions and 21 commits behind.<br>• DR-23: 13 commits past 65245be, 21 past 0df5cf4.<br>• DR-25: 82 app-buildable. | `git log`; census | CONTRACT |
| B23 | ci_validation (`:128`); json `key_facts[10]` | "Of the 77 … it exercises roughly 29%" | The smoke harness exercises 22 of 82 operations, about 27%. | — | CONTRACT |
| B24 | ci_validation (`:10`, `:147`) | "binds only 7 of the 32 response schemas"; table "3.45 … 77 \| 36 \| 32 \| 25" | Add a 3.46 row: 82 \| 38 \| 34 \| **27 unbound**. The two new unbound schemas are `SupportAttachment` and `SupportAttachmentUpload`. The avatar `200 {avatarUrl}` is an inline schema, so the guard (which binds component schemas) cannot bind it. | `crit/guard_cov346.py` (the section's own script, re-pointed) | CONTRACT (parsed) |
| B25 | ci_validation (`:224`) | "adopt the proposed 3.38 re-vendor … or jump to 3.45" | The candidate head is `eddb6ac` (3.46). No BUILD dry run has been made at 3.46: `clone345` used `2e5bb69`. The diff is 6 lines and no test reads `x-stability` (`cor_ci_validation.md:150`), so the risk is low (INFERRED), but the run is still owed. | — | INFERRED |
| B26 | env_push_impl (`:5`, `:161`, `:175`) | "Upstream 2e5bb69 … (contract 3.45.0-m1)"; "already 12 upstream commits behind … latest 3.45.0-m1"; "12 commits behind 2e5bb69" | 13 commits behind `eddb6ac`; latest is 3.46.0-m1. `realtime.md` is byte-identical at 3.46, so every push conclusion stands. | `git diff --quiet 2e5bb69 eddb6ac -- realtime.md` | CONTRACT |
| B27 | features_learning (`:5`, `:138`); features_social (`:16`); design (`:5`); contract_delta (`:7`) | `2e5bb69` labelled "upstream HEAD" / "latest" | The label is stale. The conclusions hold at 3.46: no learning, social or chat shape changed. | `diff 2e5bb69 eddb6ac` | CONTRACT |
| B28 | git (`:211`) | Unknown: "Whether schemas the app decodes changed between 3.38 and 3.46 (not diffed)" | Answered. 2 of the 26 consumed operations changed, both additively, by 3.45: `verifyOtp` gained `403 account_banned`, and `completeRegistration` gained the optional `inviteCode`/`inviteCodeApplied`. 3.46 changed no shape. | `cor_api_census.md:197-202`; 3.46 diff | CONTRACT |
| B29 | upload_push_contract | — | Already updated for 3.46. One related item: `cor_api_census.json` and `cor_features_social.json` still carry "when will Seif promote" questions; mark them resolved. | — | — |
| C1 | `level_up_app/CLAUDE.md:19-21`, `:37`, `:114`, `:136` (git §9 caught only the commit count, test count and pin) | "63 commits, ~36k lines, 849 passing tests, 12 day-briefs, 29 documents in docs/, 27 audit reports … 48 entries"; pin `184d6ec` | • 136 commits on `merged`.<br>• 37,474 hand-written `lib` lines (57,301 including generated code).<br>• 2067 tests.<br>• 15 `docs/day*_brief.md` files.<br>• 43 tracked `docs/` files.<br>• 75 tracked files in `.ai/audits/current/`.<br>• **DESIGN_ISSUES has 125 entries** (#1–#126, no #91).<br>• Pin is `0df5cf4`; `65245be` is uncommitted; upstream is `eddb6ac`. | `git rev-list --count`; `git ls-files` counts; `grep -cE '^## [0-9]+\. '` | SOURCE |
| C2 | Documents git §9 did not list | "CI has never run (R-3)" | Stale in: `docs/ENVIRONMENTS.md:335`, `:369` (Env Wave 4 scope "first observed CI run"), `:450`; `env_wave0_report.md:43`; `env_wave1_report.md:80`, `:154`; `app_identity_environment_audit_2026-10-04.md:225`, `:359`; reconciliation `:84`, `:223`; `fable_eye_audit_2026-10-06.md:68`. The planned docs-reconciliation commit (git §11 step 7) should include all of them. | `git grep "never observed\|CI has never\|R-3"` | SOURCE |

### Coverage check against the brief

The brief's own text was not among the critic's inputs. The items below are the ones the task text enumerated. For §13, §15, §16, §17's questions 1–5, §19 and §11, the brief's exact item wording was unavailable, so the rows map the closest section content.

| Brief item | Covered in | Status | Note |
|---|---|---|---|
| §13 git: refs/divergence, dev's 6, Waves 20–22, contract files vs upstream, worktrees/backups, peer artefacts, stale docs, CI, checkpoint options | git §2–§11 | COVERED | Add the new untracked `PRE_EXECUTION_DISCOVERY.md` to the §8 inventory (Additional finding 12). |
| §14 authentication, OTP | account §2 rows 2–4, §4; api_census | COVERED | Lockout and ban arrive only as generic inline copy. |
| §14 profile, settings | account §2 rows 8–13 | COVERED | |
| §14 avatar | account §1.12; upload_push A; design | PARTIAL | Only upload_push is current for 3.46; account, design, store and api_census are stale (B2, B12, B16, B18). |
| §14 rank, leaderboard | learning rows 24–25, §3.5, §3.8 | COVERED | |
| §14 quiz, quiz history, flashcards, lectures, progress, streak | learning §1–§3; design §3 | COVERED | Design has a version error for quiz history (A5). |
| §14 referral, friends, chat | social §3.1–3.3; account §1.13; upload_push (chat realtime) | COVERED | |
| §14 support | social §3.4; upload_push B | PARTIAL | The photo half is stale everywhere except upload_push (B15). |
| §14 notifications | social §3.5; upload_push inbox; learning row 4 | COVERED | |
| §14 subscription, terms | account §1.1–1.2, §1.7, §5; store §1; design §5.1 | COVERED | |
| §14 track transfer, account deletion, account cancellation, lost phone, another-device login | account §1.6, §1.8, §1.9, §7; api_census | COVERED | |
| §14 offline/loading/empty/error states | learning §2; social §3.7; account §7 | COVERED | No guard enforces the four states (social §3.7). |
| §14 environment/flavors, push | env §1–§8; upload_push push; store §4 | COVERED | |
| §15 features | features_learning, features_account, features_social | COVERED | One addition: screenshot protection for forwarded-question cards (Additional finding 6). |
| §16 device | env §1 (`pm list packages`); roadmap C4/P-5; design §2 | ADDED-HERE | Device not attached at 22:03; AVDs exist; physical-vs-AVD clarified (A3, A18). |
| §17 CI workflows | ci §2.1; git §10 | COVERED | store, env and roadmap contradict it (A1). |
| §17 pre-commit, pre-push, validation scripts | ci §2.2–2.3; git §7 | COVERED | |
| §17 format, analyze, test checks | ci §1 (BUILD) | COVERED | |
| §17 contract guards | ci §3; contract_delta | PARTIAL | The 3.46 coverage row was missing; added in B24. |
| §17 generated artefacts | ci §1(e') codegen and l10n drift | COVERED | |
| §17 secret scans | ci §2.1 (tooling absent; repo setting unknown) | ADDED-HERE | Scan of tracked files and all history: clean (Additional finding 9). |
| §17 build verification, APK/AAB verification | ci §2.7; env §1; store | COVERED | No build of HEAD exists, and no flavor-era AAB. |
| §17 iOS verification | env §3; ci | COVERED | SOURCE only; no Mac known. |
| §17 Fable/audit automation | ci §2.6 | COVERED | Manual process only. Protocol conflict with the new brief: Additional finding 7. |
| §17 questions 1–5 | ci §6–§7 and the json remaining/resolved questions | PARTIAL | The answerable ones are answered: CI history, protection, hooks, whitelist range. Still open: Mac, staging seeding, secret-scanning setting. |
| §18 Android release config, signing, package IDs | store §2; env §1–§2 | COVERED | |
| §18 iOS bundle IDs, iOS minimum | store; env §3 | COVERED | A11 reconciles the Firebase floor. |
| §18 Firebase environments | env §4; store; contract_delta | COVERED | R-9 currently forbids registration (env §6). |
| §18 production URLs, staging config, placeholder/mock URLs, debug/mock strings | store §2; contract_delta gaps | COVERED | |
| §18 legal URLs, privacy policy, terms | store §1; account §1.7 | COVERED | |
| §18 data safety | store row "Data Safety / App Privacy drafts" | PARTIAL | The drafts predate push, chat, photos and invites. |
| §18 permissions, notifications | store; env §2, §8; upload_push | COVERED | |
| §18 purchase silence | account §5; store | COVERED | |
| §18 app-store metadata | store row "Store listing assets" | COVERED | Status MISSING; support URL/email also missing. |
| §18 production build config | store "Release hardening" | PARTIAL | The R8 claim is wrong (A12). |
| §18 test-only code in production | store "`main_prod.dart` import graph" | COVERED | |
| §18 screenshot restrictions | store | COVERED | New surface to decide: Additional finding 6. |
| §18 UGC requirements | store §4; social headline 9 | COVERED | |
| §19 census columns | api_census full table | PARTIAL | It has tag, operation, method/path, 3.28/3.38/3.45 stability, repo method, provider, route/UI, tests, mock, smoke and status. **It has no 3.46 column**, and the 5 photo rows are wrong for 3.46. Per-row design and blocker columns exist only for list B. |
| §11 open questions (handoff item 8: transfer draft rule, Accept header, interceptor comment, S11, Friends TODO, S36, S24, line references) | contract_delta (a)–(h); upload_push 8.1–8.7; account §6; social §5 | COVERED | |
| §7 identity questions (Seif's request for app IDs) | env §6; upload_push row 5; store | COVERED | Seif must be given the *ratified* iOS id, not the Xcode template id. R-9 blocks the Firebase registration until the owner lifts it. |
| Material: new dependencies | contract_delta, roadmap N-12, upload_push | PARTIAL / ADDED-HERE | Licences and iOS minimums were never checked (Additional finding 5). |
| Material: mock-backend extension | roadmap protocol collision 2 | COVERED | |
| Material: smoke-harness refresh | ci §2.5; roadmap S7 | COVERED | |
| Material: staging test accounts | ci §2.5 (whitelist `+20100000000xx`, OTP `000000`); learning (university seed) | PARTIAL / ADDED-HERE | Additional finding 8. |
| Material: localisation of new copy | upload_push decisions; store §4; contract_delta | COVERED | Native push strings fall outside the ARB parity guard. |
| Material: designer capacity | none | ADDED-HERE | Not recorded anywhere (Additional finding 10). |
| Material: the 3.46 Terms gate on photos | upload_push (Terms gate) | PARTIAL / ADDED-HERE | The gate is live on staging (Additional finding 1). |

### Additional findings

1. **The photo Terms gate is live on staging, so the Terms step must come before any photo wave** (CONTRACT + API).
   - `getLegalDocument`'s `version` "always equals the server's current Terms version — the value `getTermsAcceptance` returns as `currentVersion`" (openapi@eddb6ac `:820-821`). It answers 404 when no version is configured.
   - Staging serves `r4-2026-10-07` (`cor_store.md:20`), so a current Terms version exists there.
   - `terms_acceptance_required` is "inert while no current Terms version is published" (error-codes `:67`). On staging it is therefore active for avatar upload and support photos.
   - Consequence: every staging test account must accept r4 before photo tests. `getTermsAcceptance`/`acceptTerms` have been stable since before `0df5cf4`, so this step is buildable on the committed pin.

2. **R8 is on, and its mapping file is unmanaged** (ARTEFACT; see A12).
   - The store row and `docs/STORE_READINESS.md:68` must be corrected.
   - The real release-hardening gaps are: no archived `mapping.txt` per release, no Dart obfuscation decision (DR-13), and no crash-visibility SDK (DR-12).

3. **What exactly changed in 3.46** (CONTRACT).
   - **openapi.yaml:** only the version line and 5 `x-stability` lines. Every `openapi.yaml@2e5bb69:N` cite in the sections is still valid at `eddb6ac`.
   - **Changelog:** every `contract-changelog.md@2e5bb69:N` cite is `:N+12` at 3.46. For example, adr-049 §3 moves from `:564` to `:576`.
   - **realtime.md and error-codes.md:** unchanged.
   - **Residual "draft" wording:**
     - `UniversityRegistration.inviteCode` still says "this field is `draft`" (`:4182`), the only draft text left in the file. The referral wave must still wait for Seif to clarify it.
     - error-codes rows still label the photo uses "(draft)".
   - **Missing changelog line:** the 3.46 entry has no "Consumers affected" line, which the file's own rule requires.
   - **New facts in 3.46:**
     - Avatars are public on the CDN once scanned, and a replaced or removed avatar can stay cached for up to 1 hour.
     - Support photos are in private storage.

4. **No BUILD run exists at 3.46** (BUILD gap).
   - The isolated-clone run (2067/0/0, guards 122/122) used `2e5bb69`.
   - At 3.46 the contract guard binds 7 of 34 directly returned schemas; 27 are unbound (B24).
   - A 3.46 dry run is owed before any re-vendor commit, and `git ls-remote` must be re-run first: upstream moved 8 versions in about 28 hours (3.39 `e5886a6` 2026-10-07 11:12Z → 3.46 2026-10-08 14:56Z).

5. **New dependencies** (SOURCE; the rest UNKNOWN).
   - Available transitively today: uuid, crypto, http, http_parser, mime, web_socket_channel (A16).
   - Needed as new packages: a SignalR client (WebSockets only, `skipNegotiation`, `access_token` query), Firebase core and messaging, an image picker plus downscale (contract: about 2048 px JPEG), a Markdown renderer for `contentMarkdown` (which uses tables, headings and rules), and probably a share mechanism.
   - **Licences and iOS minimums were not checked by any section, and cannot be read offline.** The pub cache holds none of these packages. The only cached relevant packages are `firebase_core` 4.3.0 (iOS 15.0), `flutter_local_notifications` 17.2.4 and `permission_handler` 11.4.0, all from other projects.
   - Each addition also feeds DR-28 (licence notices, open), DR-12 and N-12 (the zero-SDK privacy position), and the Data Safety and App Privacy forms.

6. **Screenshot protection may need to reach forwarded-question cards** (CONTRACT + SOURCE; owner decision).
   - `ForwardedQuestionCard` requires the question content and `correctOptionId` (viewer-specific, after answering) (openapi@eddb6ac schemas).
   - Screen protection is "the quiz screens ONLY", justified as "the bank is the product" (`lib/features/quiz/screens/screen_protection.dart:14-18`).
   - A chat thread rendering these cards would show bank content without protection. No section raises this.
   - Extending `FLAG_SECURE` there would also black out screencap-based WALK evidence in chat.

7. **The wave protocol conflicts with the new brief** (DOC).
   - `wave_state.md:92-94` says "Subagents: Sonnet only".
   - The owner's new brief asks for Fable audit. If Fable runs as a subagent, P-3 needs an explicit owner amendment recorded in `wave_state.md`.
   - Memory requires workflow scripts to pin `model:`.
   - A new FORMULATE is also needed: the 22-wave list is exhausted, and the multi-screen and non-screen work does not fit "one screen per wave" (roadmap protocol collisions 4–5).

8. **Staging test accounts** (CONTRACT + DOC).
   - The contract whitelists `+20100000000xx` (up to 100 numbers, fixed OTP `000000`, staging only, openapi `:96`).
   - Only one registered school account has been observed (`+2010000000001`, 31→33 pts, reconciliation `:387-392`).
   - Still undocumented: a university account (S37 ask 2 / R-8), and seeded friendship, conversation, ticket and pending-request states (ci remaining question 1).
   - Chat and friends tests need at least two registered numbers.
   - Seif's avatar live proof may have left custom avatars on some test accounts; which ones is UNKNOWN.

9. **Secret scan (added here)** (SOURCE).
   - No section scanned tracked content for secrets. The critic did, on HEAD's tracked files and on `git log --all -p`, for high-signal patterns: Google API key, private-key block, GitHub tokens, AWS key id, `sk_live`, Slack token, JWT. Both scans found 0 hits.
   - The only `storePassword`/`keyPassword` matches are the Gradle property reads (`build.gradle.kts:85,87`), the `CHANGE_ME` placeholders in `key.properties.example`, and an audit document describing the rule.
   - No keystore, `google-services.json`, `GoogleService-Info.plist` or `.env` file is tracked. The GitHub-side secret-scanning setting is still UNKNOWN.

10. **Designer capacity is not recorded anywhere** (grep of `docs/` and `.ai/` for designer availability or capacity: none).
    - Owed frames: design §7 lists about 16 groups, and roadmap WS-E counts 15 handoff designs that do not exist.
    - Every new surface also lacks empty, offline and error frames (#76).
    - Who designs, and when, is an owner question the plan cannot assume.

11. **Responsive rules are proposed, not applied** (DOC).
    - `docs/RESPONSIVE.md:3-4` says "proposed, 2026-08-11 … Nothing here has been applied to code yet". No section mentions it.
    - New screens will be built either with or without it, and iPad (DR-07) is open. It needs ratifying or explicitly deferring before UI waves resume.

12. **A new untracked file appeared during this critic run** (SOURCE).
    - `.ai/audits/current/PRE_EXECUTION_DISCOVERY.md` (608,110 B, 22:00:08 +0300) was written by the orchestrating workflow; its header says so.
    - `git status` now shows three untracked files, not the two that git §3/§8 inventory. Any commit plan must decide its fate explicitly.

13. **CI timing risk inside the plan window** (CI, from git §10).
    - `ubuntu-latest` migrates to Ubuntu 26 starting 2026-10-19.
    - The flavored release compile gate runs for the first time only when `merged` is promoted to `main`.
    - Promoting early, after a green `merged` run, separates the two risks. Codegen drift can be dry-run through `workflow_dispatch`, but whether a `merged` ref is accepted is UNKNOWN.

14. **The privacy text names SDKs the app does not ship** (API + SOURCE).
    - The served privacy text lists Sentry and Firebase Cloud Messaging as sub-processors (`cor_store.md:36`). The app ships neither SDK.
    - It is UNKNOWN whether Sentry is backend-only. If DR-12 picks an app-side crash reporter, that is another new dependency and a Data Safety change.

## 2. Current Git state
_Verification (Fable): 18 claims - 15 confirmed, 3 partial (corrected), 0 refuted (corrected), 0 unverifiable._

### Git / branch / worktree state and CI observation

Levels used: **SOURCE** = observed now in the repo or by a read-only git command (file:line or command output); **CONTRACT** = read in the vendored or upstream contract; **CI** = observed in GitHub Actions through the authenticated `gh` CLI (read-only); **DOC** = a project document says so; **ARTEFACT** = a file produced by a real tool run (for example a `validate.ps1` record) that lives outside git and outside CI. Every command was read-only. `git ls-remote` and `gh run list|view`, `gh api` GET, `gh repo view`, `gh pr list` and `gh workflow list` were used. No fetch in the repo, no checkout, no validate script was run. Scratch files stayed under SCRATCH. (added in correction) The only `git fetch` of the whole dimension was run inside the scratch clone `SCRATCH/upstream-contract`, never in the repo; it moved that clone from `2e5bb69` to `eddb6ac` (see section 6).

#### 1. Verdict

- **Repository state is simple and clean.** Branch `merged` at `8e641e9`, 1 commit ahead of `origin/merged` (`c87b90a`). Nothing is staged. The only dirty files are the 5 `contract/*` files (the proposed 3.38 re-vendor) plus 2 untracked roadmap files. No merge, rebase, cherry-pick, bisect or `index.lock`; stash empty; no tags. Re-checked at correction time with `git status -sb`: unchanged. (SOURCE)
- **dev's 6 unpushed commits are NOT stranded work.** All six are ancestors of `merged`, `main` and `origin/main`. `git cherry -v merged dev` prints nothing. Only the local `dev` ref is ahead of `origin/dev`, which is a branch-hygiene question and not a content question. (SOURCE)
- **Waves 20, 21 and 22 are all committed and pushed** (`fa88b3a`, `af0eadb`, `a988a1f`; all in `origin/merged`, none in `main`). `wave_state.md` is stale where it says Waves 20 and 21 are not committed (lines 90, 108, 1829, 1833; exact wording in section 5). (SOURCE)
- **The four working-tree contract files are byte-identical to upstream `65245be`.** Hashes match in both `--no-filters` and plain mode. One sentence in the uncommitted `contract/SOURCE.md:17` is wrong: it says "CRLF exactly as upstream stores them", but upstream's blobs have 0 CR bytes. The sentence is still in the file at correction time. (CONTRACT)
- **Upstream has moved twice since the working-tree pin, and once more since this section was investigated.** The investigator and the verifier both saw live HEAD `2e5bb69` (3.45.0-m1, 12 commits past `65245be`). At correction time `git ls-remote https://github.com/seifhamdii-collab/level-up-contract HEAD` returns `eddb6ac` (info.version `3.46.0-m1`, commit dated 2026-10-08 14:56:03 +0000): 1 commit past `2e5bb69`, 13 past `65245be`, 21 past the committed pin `0df5cf4`. (added in correction; CONTRACT)
- **RISKS R-3 ("CI has never been observed running") is refuted.** GitHub shows 15 runs in total: 12 on `merged` (11 success, 1 failure), 2 on `main`, 1 on `dev`. The latest push to `origin/merged` (`c87b90a`) is green. (CI)
- **The `--flavor prod` release compile gate has never run in CI.** It runs on pushes to `main` only (`ci.yml:320`), and `main`'s last run (2026-09-20) predates the flavor commit `2dfd969`. The sibling `codegen drift` job is different: `ci.yml:262` also admits `workflow_dispatch`, so it can be run on demand. (CI + SOURCE)
- **Unlanded work exists outside `merged`.** Two gitignored worktrees under `.claude/worktrees/` hold an uncommitted `xargs -s 7000` batching patch for `.githooks/pre-commit` and `tool/validate.sh`. It is in no branch, and it applies cleanly to `merged`. (SOURCE)
- **The `tell_claude.md` migration handoff survives in git only on one local-only backup commit** (`e4006e7`). It is absent from `merged` and from disk. (added in verification; SOURCE)

#### 2. Refs and divergence (item 1)

Live `git ls-remote origin` equals the local remote-tracking refs, so no ref is stale: `dev a5b8228`, `main e71e9a1` (= `HEAD`), `merged c87b90a`. Re-checked at correction time with the same result. (SOURCE)

| Branch | Local tip | `origin/<b>` | Ahead of origin | Behind origin | Relationship |
| --- | --- | --- | --- | --- | --- |
| `merged` (checked out; tracks `origin/merged`) | `8e641e9` (2026-10-06 05:23 +0300) | `c87b90a` | **1** | 0 | 136 commits total |
| `main` (tracks `origin/main`) | `e71e9a1` (2026-09-21) | `e71e9a1` | 0 | 0 | 104 commits. Strict ancestor of `merged` (`merged..main` = 0, `main..merged` = **32**), so `--ff-only` promotion is possible |
| `dev` (tracks `origin/dev`) | `d71a205` (2026-08-17) | `a5b8228` | **6** | 0 | 63 commits. Ancestor of `main` (`dev..main` = 41) and `merged` (73); `origin/dev` is an ancestor of `dev` |

Every one of the 32 commits in `main..merged` has the single author `zlatanibrahimovichsweden-61` and a Conventional Commit subject. The only trailers are `Co-Authored-By: Claude …` (Fable 5.1 ×17, Opus 5 ×8, Opus 5.5 ×7). (SOURCE)

The unpushed commit `8e641e9` touches 2 files only: `.ai/audits/current/env_chapter_state.md` and `docs/ENVIRONMENTS.md` (21 insertions, 9 deletions). No `lib/` or `test/` change is waiting for a push. (SOURCE)

#### 3. Working tree, exactly (items 1 and 5)

| Class | Content |
| --- | --- |
| Staged | none (`git diff --cached --stat` is empty) |
| Unstaged (tracked, modified) | `contract/SOURCE.md` (+69/-12), `contract/contract-changelog.md` (+83/-0), `contract/error-codes.md` (+13/-3), `contract/openapi.yaml` (+1284/-201), `contract/realtime.md` (+49/-1). Total 1,498 insertions, 217 deletions. These are the only tracked changes. |
| Untracked | `level_up_master_completion_roadmap.html` (5,186,787 B), `level_up_master_completion_roadmap.json` (443,697 B). Neither is gitignored (`git check-ignore` rc=1), and no tracked file references them (`git grep` finds none). |
| Ignored, but not build output | `.claude/settings.local.json`, `.claude/worktrees/` (108 MB per worktree), `docs/device_pass/` (85 files, 12 MB of 2026-08-04 device screenshots, `.gitignore:60`), generated Android/iOS plugin files. |
| In progress | none: no `MERGE_HEAD`, `CHERRY_PICK_HEAD`, `REVERT_HEAD`, `BISECT_LOG`, `rebase-merge/` or `rebase-apply/`; no `.git/index.lock`; `git stash list` is empty; `git tag` is empty. Two harmless leftovers (added in verification): `.git/ORIG_HEAD` (= `882c889`, a leftover of the 2026-10-06 resets below) and an empty `.git/lfs/` directory (`objects/` and `tmp/` only, created 2026-10-06 02:03; `.gitattributes` has no lfs filter, 0 matches for "lfs"). |
| Hooks | `core.hooksPath` is unset in every config scope. `.git/hooks` holds samples only. `.githooks/pre-commit` and `pre-push` exist but are inactive. This is documented as opt-in (`docs/PROJECT_GUIDE.md:194-195`, `docs/ENVIRONMENTS.md:334`). |
| Config | `core.autocrlf=true`. `.gitattributes:2` is `* text=auto eol=lf`, with no `contract/` override. `git ls-files --eol contract` shows `i/lf w/lf attr/text=auto eol=lf` for all five files. |

**Reflog (corrected).** `git reflog` shows a local history rewrite on 2026-10-06, not just a no-op reset. `HEAD@{8}` is `reset: moving to HEAD~2` (04:15:21 +0300), which dropped the two unpushed commits `0751c55` and `65b6f6f` (made 04:13). `HEAD@{7}` is `reset: moving to HEAD` (04:15:21). The same two changes were then re-made as `c4b00af` and `f10b112` (04:15:21 and 04:15:22), followed by four more normal commits (`56f74e7`, `e3364ab`, `5c0a27d`, `c87b90a`) and `8e641e9`. Harmless in effect: `git branch -a --contains 0751c55` and `… 65b6f6f` print nothing, so the dropped commits were never on any branch or remote. `f10b112` was pushed afterwards (its CI run started 01:15Z = 04:15 +0300). The verifier also reports 17 dangling commits from `git fsck --no-reflogs --dangling` (not re-run here). (SOURCE)

#### 4. dev's six unpushed commits (item 2)

`git log origin/dev..dev` yields exactly these six, all dated 2026-08-17 19:33 +0300. For every sha, `git branch -a --contains` lists `merged`, `main`, `origin/main`, `origin/merged`, both worktree branches and the dirty-tree backup. `merge-base dev merged` is `d71a205`, i.e. `dev` itself, so `merged` contains `dev`. (SOURCE)

| sha | Subject | Files |
| --- | --- | --- |
| `9fe6098` | fix(ci): prove the specific guard fires, and make validate.sh NUL-safe | `docs/ENFORCEMENT.md`, `test/guards/workflow_test.dart`, `tool/validate.sh`, `tool/verify_guards.ps1` |
| `e2ec9e8` | fix(lifecycle): guard autoDispose notifiers against mid-await disposal | otp, edit_profile, quiz_setup, school_search notifiers |
| `6f96cbc` | fix(l10n): localize the shared Retry button and the placeholder route | `app_router.dart`, `state_widget.dart` |
| `ac87455` | perf: cap avatar decode size; drop unused Hive dependencies | 4 avatar sites, `pubspec.yaml`, `pubspec.lock` |
| `c8688cd` | test(guards): add the lifecycle rule; lower the l10n ratchet 7 -> 5 | `test/guards/project_rules_test.dart`, `rules.dart` |
| `d71a205` | docs(audit): Wave 2.1 and Wave 3 implementation records | 5 audit docs |

**Conclusion.** Nothing needs content reconciliation. The documented standing policy is "leave `dev` frozen" (`docs/WAVE_STATUS.md:6-7`; memory `branch-topology-merged`: never push or commit to `main` or `dev` unless the owner says so; 2026-09-19 entry "`dev` is still frozen"), so the default is to leave `dev` and `origin/dev` alone; only the owner can change that policy (see section 11, step 5). `origin/dev`'s only CI run is 2026-08-15 (`a5b8228`, success). A push of `dev` would trigger one CI run.

#### 5. Waves 20, 21, 22 (item 3)

| Wave | Commit | Commit date (+0300) | In `origin/merged` | In `main` | What the commit message says about validation |
| --- | --- | --- | --- | --- | --- |
| 01-19 | `cccd2f1` | 2026-09-28 | yes | no | checkpoint on contract 3.23.0-m1 |
| 22 Flashcards | `a988a1f` | 2026-09-30 14:56 | yes | no | `validate.ps1` in a throwaway worktree: 1985 passed / 0 failed / 0 skipped |
| (sync) | `e6e6567` | 2026-09-30 15:06 | yes | no | wave_state fixes only |
| 20 Edit Profile | `fa88b3a` | 2026-09-30 21:40 | yes | no | throwaway-dir run: format 0 changed, analyze 0, 2015 / 0 / 0 |
| 21 Settings | `af0eadb` | 2026-10-06 02:04 | yes | no | **pre-audit checkpoint, "not re-validated at this commit"** |

`git merge-base --is-ancestor <sha> origin/merged` is true and `… main` is false for all five. The tracked files for Waves 20-22 all exist at HEAD: `lib/features/profile/widgets/avatar_disc.dart`, `test/features/settings/settings_frame_test.dart` and `lib/features/flashcards/*`. (SOURCE)

**`.ai/audits/current/wave_state.md` is stale (corrected wording).** Four lines say Waves 20 and 21 are uncommitted, in two different wordings:
- `:90` ("Next action" row), `:1829` and `:1833` say "Waves 20 and 21 are not committed".
- `:108` (the "Branch / HEAD" row) says "`merged` = `origin/merged`. Last product checkpoint `a988a1f` … Not committed: Waves 20 (Edit Profile) and 21 (Settings), finished and walked, in the working tree". It is also stale in a second way: `merged` is now 1 ahead of `origin/merged`, and the last product checkpoint is `af0eadb`, not `a988a1f`.
- The task's `:327` and `:345` hold unrelated Wave 04/05 text; line numbers moved.
- Its `Last updated` (`:3`) is "2026-09-30 · session 'Level Up Flutter API audit workflow (fork)'". `git log -1 -- .ai/audits/current/wave_state.md` is `af0eadb` (2026-10-06 02:04): the Wave 21 checkpoint commit itself carried the text saying Wave 21 is uncommitted. The staleness was committed with the file, not accrued afterwards. (SOURCE)

The CI result for the pushed head is the only independent check of the Wave 21 tree. `c87b90a` is green (analyze + test and the Windows goldens job both success), see section 10. (CI)

#### 6. The 4 contract files vs upstream 65245be (item 4)

Upstream clone is `SCRATCH/upstream-contract`, which was at HEAD `2e5bb69` when investigated and was fetched to `eddb6ac` during correction; `65245be` is an ancestor of both. Hashes are the first 12 hex digits. (CONTRACT)

| File | Working tree `hash-object --no-filters` | Working tree plain `hash-object` | Upstream `rev-parse 65245be:<f>` | HEAD blob (= upstream `0df5cf4`) |
| --- | --- | --- | --- | --- |
| `openapi.yaml` | `c26b51dd1f7a` | `c26b51dd1f7a` | `c26b51dd1f7a` | `f7742d593853` |
| `contract-changelog.md` | `f0a99fc0dfa0` | `f0a99fc0dfa0` | `f0a99fc0dfa0` | `b6286b9f5d5d` |
| `error-codes.md` | `67eb0610f363` | `67eb0610f363` | `67eb0610f363` | `662d8aaff111` |
| `realtime.md` | `4ab6f0faa662` | `4ab6f0faa662` | `4ab6f0faa662` | `b495de0aadeb` |

- **All four are blob-identical to upstream `65245be`.** The same four HEAD blobs equal upstream `0df5cf4`, so the committed pin is also exact. The handoff's "hashes matched" claim is confirmed (re-run by the verifier).
- **Line endings.** Working-tree CR count is 0 for all five files. HEAD blobs: 0. Upstream `65245be` blobs: 0 (`git show 65245be:f | tr -cd '\r' | wc -c`). The upstream clone's own index reports `i/lf` and its Windows working copy `w/crlf` (because `core.autocrlf=true`). So the blobs are LF, and `git add contract/…` will not rewrite them.
- **Wrong sentence in the uncommitted `contract/SOURCE.md:17`:** "CRLF exactly as upstream stores them". Upstream stores LF. [INFERRED] The author looked at the clone's CRLF working copy. The sentence should be corrected before any commit; it is still present at correction time (`grep -n CRLF contract/SOURCE.md` hits line 17). HEAD's `SOURCE.md` has no CRLF statement. (added in verification, updated in correction) The same false fact had also been written into memory `upstream-contract-3-10-unlocks.md`; that memory file was rewritten at 2026-10-08 21:24 +0300 and now says "Upstream BLOBS are LF (0 CR bytes, verified 2026-10-08)", so the repo file `contract/SOURCE.md:17` is the only place left that carries the error.
- **The SOURCE.md diff (+69/-12) does the following.**
  - Moves `Pinned commit` to `65245be`, `Vendored` to 2026-10-07, `Previous pin` to `0df5cf4`, and `info.version` to 3.38.0-m1.
  - Updates the census to 53 stable / 24 draft / 77 total (4 web-only, 49 app-buildable).
  - Adds a "Delta from 3.28.0-m1 — ten mobile versions" table for 3.29-3.38 with a wire-shape audit. It states that no schema bound in `test/guards/contract_models_test.dart` changed.
  - Adds five follow-ups: the `Accept: application/json` header at `dio_client.dart:19`, the stale comment at `error_interceptor.dart:10`, seif_fight S24/S36 answered upstream, S11 still open, and an owner ruling on `transferToUniversity`.
  - Adds a line-number-drift warning (`openapi.yaml` 3,105 → 4,188 lines).
  - Records that the admin files are not vendored.
  - Keeps the 3.27→3.28 delta "for history".
- **SOURCE.md prose is not recoverable from upstream.** `65245be`'s tree has 7 files (changelog, error-codes, openapi, realtime and three admin files) and no `SOURCE.md`. If the working copy is discarded or `git restore`d, the delta analysis is gone.
- **The uncommitted state is deliberate.** `contract/SOURCE.md:19` says "Re-vendored on the owner's request", and memory `upstream-contract-3-10-unlocks` (2026-10-07 entry) records that the owner asked to re-vendor, not to commit. (added in verification; DOC)
- **Only `contract/*` is dirty.** Nothing under `lib/`, `test/` or `docs/` changed, matching the handoff.
- **Eight upstream commits lie between the pins.** `0df5cf4..65245be` is 8 commits, matching SOURCE.md's count of eight. `0df5cf4..2e5bb69` is 20; `0df5cf4..eddb6ac` is 21.
- **Re-vendors have precedent as standalone contract-only commits:** `03fd7cf` (3 files, 2026-10-04) and `aeb22fc` (4 files).
- **Upstream moved again: `eddb6ac` = 3.46.0-m1 (added in correction; CONTRACT).** `git diff --stat 2e5bb69 eddb6ac` shows `openapi.yaml` (12 lines changed), `contract-changelog.md` (+12) and the two admin files (not vendored). The 3.46 changelog entry (2026-10-08) says: the support-photo operations `createSupportAttachmentUpload`, `completeSupportAttachment`, `getMySupportAttachmentContent` (plus `attachmentIds` / `attachments` on the ticket operations) and the avatar operations `uploadCustomAvatar`, `removeCustomAvatar` are now `stable`; "Breaking: no; no shape changed". It states the limits JPEG/PNG/WebP, photos at most 7,000,000 bytes with at most 3 per message and 10 per ticket, avatars at most 2 MiB and 128-4,096 px a side, every image safety-scanned and a flagged photo refused with `image_rejected_by_moderation`, and that the flip was made on Seif's explicit word. These are the five operations that were still draft at 3.45. I read only the changelog and the diff stat; I did not diff schemas (contract dimension). The earlier fact that "5 drafts remain at 3.45" is therefore superseded at the live head.
- **Not re-verified here:** the handoff's "validated in a throwaway worktree: format PASS, analyze 0, 2067/0/0, guard 14/14" for the 3.38 re-vendor is DOC. I did not run it; running a validate script was prohibited.

#### 7. Worktrees, backup branches (item 5)

| Item | Branch / tip | State | Meaning |
| --- | --- | --- | --- |
| `.claude/worktrees/angry-antonelli-cf9094` | `claude/angry-antonelli-cf9094` @ `e71e9a1` (= `main`, 2026-09-21), local-only | 2 modified files: `.githooks/pre-commit` (+29/-3), `tool/validate.sh` (+24/-3); `git diff --stat` = 53 insertions, 6 deletions in those two files only. Files last written 2026-09-27 15:18-15:23. | `xargs -0 -r -s 7000` batching for dart/flutter under Git Bash (cmd.exe 8191-char limit) and a corrected format-failure hint. **Not in `merged` or `main`.** `git apply --check` of its diff against the `merged` working tree succeeds. |
| `.claude/worktrees/jovial-bhaskara-018e57` | `claude/jovial-bhaskara-018e57` @ `e71e9a1`, local-only | 1 modified file: `tool/validate.sh` (+14/-2). Written 2026-09-27 15:11. | A strict subset of angry's change: a direct diff of the two `validate.sh` files differs only at line 162, where angry replaces the old hint with a NUL-safe batched hint; angry additionally has the hook edits. |
| `backup/pre-split` @ `9fa2a61` (2026-07-29) | local-only | ancestor of `merged`, `main`, `dev` | Pure label; no unique content. |
| `backup/pre-day7-reorder` @ `175478b` (2026-08-04) | local-only | ancestor of `merged`, `main`, `dev` | Pure label; no unique content. |
| `backup/2026-08-22-dirty-tree` @ `e4006e7` (2026-08-22 22:34:29 +0300) | local-only | **1 unique commit** (parent `99b5cba`; 143 files: 36 added, 107 modified, +13,679/-1,575). `git cherry` marks it `+`. | Safety snapshot taken before splitting a dirty tree. **142 of the 143 paths exist in `merged`; 1 is missing (`tell_claude.md`); 45 are byte-identical and 97 differ.** The split finished 36 minutes after the snapshot: ten commits `89a8a88` (22:37:01) through `0451284` (23:10:28) landed in `merged` (contract v2.1.0-m1, typography scale, OTP, CI, Wave 4 docs plus `CLAUDE.md`). Supersession of the 97 differing paths is not proven line by line. Origin has no `backup/*` ref, so the snapshot exists only in this clone. |

(Counts for the dirty-tree snapshot were recomputed in correction by joining `git ls-tree -r e4006e7` with `git ls-tree -r merged` over the 143 paths of `git diff-tree 99b5cba e4006e7`: missing 1, identical 45, differ 97. The first investigation's "all 143 exist, 44 identical, 99 differ" and "35 minutes" were wrong.)

**`tell_claude.md` (added in verification).** It is the one snapshot path absent from `merged`; the snapshot adds it with 6,232 lines, it is not on disk (`ls` fails), and `git log --all -- tell_claude.md` returns only `e4006e7`. `level_up_app/CLAUDE.md` says it is deleted "per its own read-receipt protocol", and memory `branch-topology-merged` lists it as owner-decision-pending. So the backup commit is the only copy of that migration handoff in git, which is a concrete reason to keep `backup/2026-08-22-dirty-tree`.

The worktree directories are gitignored (`!! .claude/worktrees/`). The batching patch therefore lives only in those directories and in no branch. Removing the worktrees (for example with a clean-up tool) would lose it. `merged`'s `tool/validate.sh` has no `-s` batching, so under Git Bash it keeps the unbatched `xargs` call (`HEAD:.githooks/pre-commit` lines 69 and 80 and `HEAD:tool/validate.sh` line 139; 0 hits for "s 7000"). The code comment in the patch records that a run died with "The command line is too long" at about 280 paths (DOC). The repo has 369 tracked `.dart` files. The canonical Windows entry point is `validate.ps1`; this affects `validate.sh` and the hooks only.

**Are the worktrees live? (answered in verification).** No. Nothing under either worktree or its `.git/worktrees/<name>/` metadata has changed since 2026-09-27 15:23:30 (angry `validate.sh`), 15:18:50 (angry `pre-commit`) and 15:11:04 (jovial `validate.sh`); the two `.git/worktrees/*/index` files were last written 15:19:52 and 15:16:22 the same day; `git worktree list --porcelain` shows neither locked nor prunable. Memory `gitbash-dart-cmd-line-limit` (session `6ff6a274-8f24-4d9f-b4a2-6eb758444fab`, 2026-09-27) is the session that made them and records the rule "any new shell code that passes a file list to dart/flutter must batch it with `-s 7000`". (DOC + SOURCE)

#### 8. Peer-session artifacts and other uncommitted-but-important files (item 6)

| Artifact | Provenance and status |
| --- | --- |
| `level_up_master_completion_roadmap.json` | Top-level keys: `generated`, `repo`, `counts`, `verdict`, `dashboard`, `master_issues`, `decisions`, `requirements`, `critical_path`, `workstreams`, `gates`, `risks`. `generated` = `2026-10-08T02:59:36.242535` (no timezone; it equals the file mtime 02:59:36 +0300). `repo` = `{branch: merged, head: 8e641e9, contract_pin: "0df5cf4 (3.28.0-m1)", contract_working_tree: "65245be (3.38.0-m1), uncommitted re-vendor by a concurrent session, 2026-10-07", flutter: 3.44.7, validation: "2067/0/0 at 8e641e9, clean tree (2026-10-06T11:25Z)"}`. `counts`: 35 domains, `findings_master` 522 (`master_issues` has 525 entries = 522 + `aggregates` 3), 8 open P0, 29 decisions. `workstreams` has 10 entries (carrying `name`, `owner`, `prereq`, `outputs`, `deps`, `blocker`, no `id` key). **`gates` has 14 entries, G-01 through G-14, not 13** (re-counted in correction); a plan keyed on "G-01..G-13" would drop G-14. `verdict.release_ready` = `NO`. No author or session id inside the file. |
| `level_up_master_completion_roadmap.html` | Only the first 400 KB was read. `<title>` is "Level Up — Master Completion Roadmap"; first `<h1>` is the same. Meta description: "Evidence-based completion audit and production roadmap for the Level Up Flutter app at merged@8e641e9 (contract pin 0df5cf4), 2026-10-06 to 2026-10-07". |
| Generating session (identified in verification, spot-checked in correction) | Session `99eae648-c806-4019-bc31-ddf6699b22f1`. Its Temp scratchpad (`C:\Users\musta\AppData\Local\Temp\claude\F--level-level-up-level-up-app\99eae648-c806-4019-bc31-ddf6699b22f1\scratchpad`) holds `gen/build_report.py` (usage line "python build_report.py model.json out.html out.json", mtime 02:56:21) and `final_view.html` (5,186,765 B at 02:59:03, 22 bytes smaller than the repo HTML written 02:59:36). The current orchestrator session (`513a53c3`) uses the files as input, so operationally they are an input to this workflow, while stale against the live contract (see next row). I did not read any transcript content. |
| Staleness | Both files predate the discovery of upstream 3.39-3.46 (22+ operations flipped to stable at 3.39, the last five drafts at 3.46). Its `contract_pin` is the committed 0df5cf4. It sits in the repo root, untracked and not ignored. For scale: the largest tracked HTML is `.ai/audits/current/project_files_forensic_audit.html` (208 KB, committed in `3913f86`); this HTML is about 25 times larger. |
| Everything else recently modified | `find` over everything except build/.dart_tool/.git/.gradle/worktrees found nothing modified after 2026-10-07 10:00 other than the two roadmap files. All other files touched since 2026-10-06 are committed (git status clean for them). No sign of a concurrent writer after 2026-10-08 02:59 (file timestamps cannot prove liveness). |
| `docs/device_pass/` | 12 MB of 2026-08-04 screenshots, gitignored on purpose (`.gitignore:60`), referenced from `docs/STORE_READINESS_AUDIT_2026-09-05.md`. Exists only on this machine. |

**Validation record behind "2067/0/0 at 8e641e9" (corrected).** The committed `.ai/audits/current/test-results.md` records a run at `f10b112` with `tree clean: NO - uncommitted changes present`, 2067 passed / 0 failed / 0 skipped (started 2026-10-06T02:18:05Z). It does not record `8e641e9`, and no tracked file contains "11:25Z". The matching record does exist outside git (ARTEFACT): `C:\Users\musta\AppData\Local\Temp\claude\F--level-level-up-level-up-app\99eae648-c806-4019-bc31-ddf6699b22f1\scratchpad\test-results_2026-10-06_this_session.md`, a verbatim `tool/validate.ps1` output: "Validation run - 2026-10-06T11:25:04Z", finished 11:30:01Z, branch `merged`, commit `8e641e9`, `tree clean : yes`, `dart format` PASS (324 files), `flutter analyze` 0 issues, `flutter test` 2067 passed / 0 failed / 0 skipped, OVERALL PASS. The mtime puzzle is explained by that session saving its run over the tracked file and restoring it: the scratch copy's mtime is 2026-10-06 14:36:07.217 +0300 and the repo file's is 14:36:07.322 +0300, and `git diff` on the tracked file is empty. So the roadmap's validation claim is ARTEFACT-level (a real validate.ps1 record at `8e641e9`), not just DOC; it is still not CI and not in git, and it predates every later change (the 3.38 working-tree contract and anything after 2026-10-06).

#### 9. Stale Git or branch statements in documents (item 7)

| Where | Says | Reality |
| --- | --- | --- |
| `docs/WAVE_STATUS.md:3` | "Last updated: 2026-09-22 …" | The file has sections dated 2026-10-04 and 2026-10-06 below it (lines 18-37; last touched by `c87b90a`). |
| `docs/WAVE_STATUS.md:6-7` | `dev` and `main` "kept untouched as history and all work continues on `merged`" | `main` is no longer untouched. It was fast-forwarded on 2026-09-19 (`f987f20`) and again to `e71e9a1` (2026-09-21). The memory note says the owner asked for it. `dev` is untouched. |
| `docs/WAVE_STATUS.md:8-11` | "Unpushed: the 2026-08-23 commits … and the 2026-09-04 commits … (R-3)" | Everything up to `c87b90a` is on `origin/merged`. Only `8e641e9` is unpushed. |
| `docs/WAVE_STATUS.md:55` | "no upstream contract drift (`0df5cf4` == `origin/main`)" | `origin/main` here is the contract repo's. Upstream is now `eddb6ac` (3.46.0-m1; `2e5bb69` / 3.45.0-m1 when investigated), 21 commits past `0df5cf4`. The app repo's `origin/main` is `e71e9a1`. The wording is ambiguous. |
| `docs/WAVE_STATUS.md:107-110` | "uncommitted — see the dated section below" for Docs 09-05, Day 8-9, Day 10 | These are committed long ago (for example `bd592f6` feat(mistakes); `f987f20` quiz review). |
| `.ai/audits/current/wave_state.md:90, :108, :1829, :1833` | Waves 20 and 21 not committed (`:108`: "Not committed: Waves 20 (Edit Profile) and 21 (Settings) … in the working tree"; also "`merged` = `origin/merged`. Last product checkpoint `a988a1f`") | Committed in `fa88b3a` and `af0eadb`, both pushed. The stale text was committed by `af0eadb` itself. |
| `docs/RISKS.md:55-63` (R-3) | "CI has never been observed running"; "No Actions run has been inspected"; `:65-66` "Expect the advisory `goldens` job to be **red**" | Refuted: 15 runs exist, the first on 2026-08-15, and the goldens job passed on every `merged` run. See section 10. The one true half is "`origin/dev` is 6 commits behind local" (still 6). |
| `docs/RISKS.md:60` | "origin/dev is 6 commits behind local" | Correct, but harmless: the six are already in `main` and `merged`. |
| `docs/ENVIRONMENTS.md:334-336` (added in verification) | "Hooks are **not enabled on this clone** (`git config core.hooksPath` unset — re-checked 2026-10-06). CI has never been observed running (R-3). Both facts cap every CI/hook claim in this chapter at SOURCE level" | The hooks half is still true. The CI half is stale for the same reason as R-3 (15 runs observed). The investigator cited this line only for the hooks fact. |
| Memory `branch-topology-merged.md` (added in verification) | The 2026-10-06 entry said CI on `merged` cannot be observed from this machine (`gh` not installed, API anonymous-404) | `gh` 2.102.0 is installed at `C:\Program Files\GitHub CLI\gh.exe` and authenticated as the owner. The memory file now carries a "2026-10-08 correction" (line 98, rewritten 21:24 +0300), so this one is already fixed. |
| `level_up_app/CLAUDE.md` §1.1 and §1.7 | "63 commits … 849 passing tests"; contract pin `184d6ec` | `merged` has 136 commits; the last recorded suite is 2067 tests; the pin is `0df5cf4`, with `65245be` proposed in the working tree. `tell_claude.md` is absent, as the file expects after deletion. |
| `contract/SOURCE.md:17` (uncommitted) | "CRLF exactly as upstream stores them" | Upstream stores LF (section 6). |

#### 10. CI observation (item 8)

GitHub slug: `zlatanibrahimovichsweden-61/level-up-app` (private; default branch `main`; the repo has one workflow, `CI`, active, id 335057335). `gh` is installed at `C:\Program Files\GitHub CLI\gh.exe` (v2.102.0) but not on PATH. It is authenticated as the owner's own account `zlatanibrahimovichsweden-61` (token scopes `gist, read:org, repo, workflow`; the token was not printed). (CI)

| Branch | Runs seen | Result |
| --- | --- | --- |
| `merged` | 12, from 2026-08-22 (`0451284`) to 2026-10-06 (`c87b90a`) | 11 success, **1 failure** (`f10b112`, run `37398238597`, 2026-10-06 01:15Z: step "Format check (hand-written Dart only)" failed, so Analyze and Test were skipped; `56f74e7` formatted the offending file and a later push is green). Re-counted in correction. |
| `main` | 2 (`f987f20` 2026-09-19, `e71e9a1` 2026-09-20, run `35543020958`) | both success; in the `e71e9a1` run all four jobs (`analyze + test`, `goldens`, `codegen drift`, `release compile gate`) succeeded, the last with the old unflavored build command |
| `dev` | 1 (`a5b8228`, 2026-08-15) | success |

Latest `merged` run `37403810413` (head `c87b90a`, push, 2026-10-06 02:22-02:29Z): **success**.

- `goldens (windows, advisory)` succeeded in 6m17s.
- `analyze + test` succeeded in 6m57s. Its steps all succeeded: toolchain report, "Release manifest declares INTERNET", "Lockfile did not drift", "Localizations are up to date", "Format check", "Analyze", "Test (whole suite except goldens)".
- `codegen drift (main only)` and `release compile gate (main only)` were **skipped** on this run and on every `merged` run. Their conditions differ (corrected): `ci.yml:320` (release gate) requires `github.event_name == 'push' && github.ref == 'refs/heads/main'`; `ci.yml:262` (codegen drift) is `workflow_dispatch` **or** a push to `refs/heads/main`.

Observations:

- **R-3 is refuted.** CI has been observed on `dev` since 2026-08-15 and on `merged` since 2026-08-22. R-3's expectation that the goldens job would be red is also wrong: it passed on `merged`.
- **Release compile gate never exercised since the flavor change.** `ci.yml:380` now runs `flutter build apk --release --no-pub --flavor prod -t lib/main_prod.dart`, and `:393` expects `app-prod-release.apk`. `main`'s `ci.yml` still has the old unflavored command (`:377`, `app-release.apk` at `:390`). `main` differs from `merged` by `.github/workflows/ci.yml` (16 lines) and `android/app/build.gradle.kts` (88 lines). The flavor commit `2dfd969` (2026-10-06 00:44 +0300) is in `origin/merged` and not in `main`, and it was the last change to `ci.yml`. The first push of `merged` to `main` will be the first-ever CI run of the flavored release gate, and `workflow_dispatch` cannot exercise it because that job requires a push to `main`.
- **Codegen drift can be exercised on demand (corrected, added in verification).** `ci.yml:30` declares `workflow_dispatch` (also in `main`'s `ci.yml`), and `:258` says the job is "Also runnable on demand via workflow_dispatch". So half of the first-run risk on the `merged`-to-`main` push can be retired before promotion. UNKNOWN: whether GitHub accepts a dispatch with `ref=merged`; I did not test it (it would be an outbound action).
- **The goldens job is still advisory although its own flip condition is met (added in verification).** `ci.yml:200-201` says "ADVISORY (continue-on-error) until it has been green once — flip continue-on-error to false at that point and add it to branch protection"; `:214` is `continue-on-error: true`. In correction I re-queried all 12 `merged` run ids with `gh run view --json jobs`: the goldens job succeeded on 12 of 12 (including the `f10b112` run where analyze + test failed), and on the `main` run. The second half of that comment (branch protection) is not available through rulesets here (HTTP 403, below); classic branch protection was not tested.
- **No guard on the remote.** `gh api repos/…/branches` shows `protected=False` for `dev`, `main` and `merged`. The rulesets API returns HTTP 403 ("Upgrade to GitHub Pro or make this repository public"). `gh pr list --state all` and `gh issue list` return nothing: no PR was ever opened. "Never force-push main/dev" is a convention only.
- **Annotations on the green run.** `actions/checkout@v4` and `actions/cache@v4` are forced from Node 20 to Node 24 (deprecation warning). The runner image note says the `ubuntu-latest` label migrates to Ubuntu 26 beginning **2026-10-19**. CI pins Flutter 3.44.7 via `.flutter-version`; the run's toolchain report says "CI is on 84fc5cbb…, `.metadata` records f6ff1529…", which is expected.
- **Hooks would have caught the one failure.** The red run was a format failure; `core.hooksPath` is unset so the pre-commit hook never ran on this clone. `validate.ps1` formats tracked files only (memory `validate-skips-untracked-files`, DOC); `.ai/audits/current/release_readiness_reconciliation_2026-10-06.md:406` records the same root cause (the file was untracked when `git ls-files` fed `dart format`).

#### 11. Checkpoint options for Mostafa (item 9) — nothing here was performed

Every step below needs Mostafa's explicit yes. Pushing is outbound. Per the memory note, `main` is promoted only on the owner's word.

**Do not do before the contract choice:** `git restore contract/`, `git checkout -- contract/`, or `git stash`. They would destroy the SOURCE.md delta analysis, which is not recoverable from upstream.

| Order | Checkpoint | Options and consequences |
| --- | --- | --- |
| 1 | Push `8e641e9` to `origin/merged` (plain fast-forward) | Docs-only (2 files). Triggers one CI run, about 7 minutes. Independent of every other choice; removes "ahead 1". Alternatively wait and push it together with step 2, which saves one CI run but delays the safe part. |
| 2 | Contract working tree (decision first, see Q1) | **A. Commit 3.38 now, then re-vendor the then-current upstream head.** First commit is `chore(contract): re-vendor … 3.38.0-m1 (65245be)`: the 5 files, with the CRLF sentence in SOURCE.md corrected first. A second contract-only commit follows for the upstream head (3.46.0-m1 at `eddb6ac` at correction time; 3.45.0-m1 at `2e5bb69` when investigated). Keeps the 3.29-3.38 delta analysis and a bisectable intermediate pin; matches precedent `03fd7cf` and `aeb22fc`. Cost: an extra commit and a SOURCE.md rewritten twice; the 3.38 note that `transferToUniversity` is draft is already superseded upstream (stable from 3.39). **B. Copy SOURCE.md's prose to a safe place, discard the 3.38 copy, re-vendor straight to the upstream head.** One commit and a current pin, but the 3.38 "validated 2067/0/0" evidence no longer applies and the new tree must be re-validated. The schemas the app decodes may have moved in 3.39-3.46; I did not diff them (other dimension). **C. Leave it uncommitted.** Risk of loss; the dirty tree makes `validate` report "tree clean: NO"; every other commit must stage by explicit path. A contract-only commit has zero `lib/`/`test/` risk, since blob identity is proven. Whichever is chosen, the upstream head can move again before the commit lands, so run `git ls-remote` immediately before vendoring (memory `vendored-pin-can-lag-badly`, DOC). |
| 3 | Roadmap `.json` and `.html` | **(a)** Leave untracked for now (it is stale against the live contract and pinned to `0df5cf4`). **(b)** Commit the 444 KB JSON under `.ai/audits/current/` in its own `docs(audit)` commit after the pin decision; keep the 5.2 MB HTML out of git, because it permanently bloats history on a private repo with no history-rewrite budget (an empty `.git/lfs/` exists, but no lfs filter is configured). **(c)** Move both outside the repo. **(d)** Regenerate against the chosen pin with the generating session's `gen/build_report.py`, then commit the JSON only. Any option keeps `git status` free of the untracked pair. |
| 4 | Worktree tooling patch | **Land** angry-antonelli's diff on `merged` as `fix(tool): batch dart/flutter xargs under Git Bash` (clean `git apply --check`; consistent with the recorded rule in memory `gitbash-dart-cmd-line-limit`). The patch does not modify `test/guards/workflow_test.dart` (its `git diff --stat` shows only `.githooks/pre-commit` and `tool/validate.sh`); it only writes a hint string whose text that NUL-safety guard scans, so re-run the guard suite after landing. Then the two worktrees and their `claude/*` branches can be retired. **Discard** it: lose a fix whose problem was measured on this machine on 2026-09-27. Leaving it where it is risks loss if the worktrees are cleaned. |
| 5 | `dev` | **Leave** `dev` as the frozen history marker (the documented default, section 4). **Fast-forward push** (a5b8228 → d71a205) republishes nothing new (content is already on `main`); one CI run on `dev`; clears "ahead 6". **Retire** `dev` (delete the remote branch): destructive to the pointer only, since `main` contains every commit; it needs the owner's word. Whichever is chosen, correct R-3 and WAVE_STATUS. |
| 6 | Promote `merged` → `main` | `--ff-only`, 32 commits, possible today. Established ritual (memory `branch-topology-merged`, 2026-09-21 entry): `main` is fast-forwarded onto `merged` only on the owner's explicit request, expected at the end of a wave; last promotion `e71e9a1` on 2026-09-21. Exposes the flavored release compile gate and the codegen drift job to their first CI run on `main`. Optionally dry-run codegen drift first via `workflow_dispatch` (UNKNOWN whether a `merged` ref is accepted). Recommend doing it after steps 1-2 and a green `merged` run, and only on the owner's word. |
| 7 | Docs reconciliation commit | One `docs(workflow)` commit correcting section 9 (WAVE_STATUS header, wave_state rows at `:90`, `:108`, `:1829`, `:1833`, R-3 closed with `gh run list` evidence, `docs/ENVIRONMENTS.md:334-336`, CLAUDE.md counts, and `contract/SOURCE.md:17` if not fixed with step 2). Low risk, high value because later waves read these documents as state. |
| 8 | Hygiene (optional) | Delete `backup/pre-split` and `backup/pre-day7-reorder` (no unique content). Keep `backup/2026-08-22-dirty-tree` (the only copy of that snapshot, and the only copy of `tell_claude.md` in git). Decide whether to run `git config core.hooksPath .githooks`, which needs step 4 first, since the patch is what keeps the hooks usable on large commits (DOC). Optionally flip the goldens job's `continue-on-error` to false: its own comment's condition (green once) is met on 12 of 12 `merged` runs; this changes a CI gate, so it needs the owner's word. |

#### 12. Unknowns (not resolved by verification)

- Whether any other Claude session is currently writing to the repo; no file outside the roadmap pair was modified after 2026-10-07 10:00, but liveness cannot be proven from files.
- Whether the handoff's throwaway-worktree validation of the 3.38 re-vendor (format PASS, analyze 0, 2067/0/0, guard 14/14) is true; I did not run it (prohibited), so it remains DOC.
- Whether the dirty-tree backup commit's content is fully superseded line by line (only path presence, blob identity and commit-split timing were verified).
- Whether the flavored release compile gate will pass in CI; it has never run.
- Whether GitHub accepts a `workflow_dispatch` of `CI` with `ref=merged` for codegen drift; not tested.
- Whether classic branch protection is available on this plan (only the rulesets API was tried: HTTP 403).
- Whether schemas the app decodes changed between 3.38 and 3.46 (not diffed; belongs to the contract dimension).

## 3. Current contract state
### 3.0 Read first: the upstream pin moved twice during this audit

| Pin | Commit | `info.version` | Ops | Stable | Draft | Web-only stable | App-buildable | Where it is |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Committed | `0df5cf4` | 3.28.0-m1 | 54 | 38 | 16 | 3 | 35 | `HEAD:contract/` |
| Proposed re-vendor | `65245be` | 3.38.0-m1 | 77 | 53 | 24 | 4 | 49 | working tree, **uncommitted** |
| Upstream at audit start | `2e5bb69` | 3.45.0-m1 | 86 | 81 | 5 | 4 | 77 | mirrored 2026-10-08 12:29 UTC |
| **Upstream at report time** | **`eddb6ac`** | **3.46.0-m1** | **86** | **86** | **0** | **4** | **82** | mirrored 2026-10-08 14:56 UTC |

All four rows were produced by parsing `paths` with a YAML parser (never by grepping `x-stability`). Web-only =
`x-consumers` without `mobile`: `requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`,
`redeemSubscriptionCode`, `listTerms`. `getLegalDocument` is `[mobile, web]` and therefore app-buildable.

**3.46.0-m1 (`eddb6ac`)**, changelog entry 2026-10-08: "Support photos and custom avatars are now `stable`".
It flips `createSupportAttachmentUpload`, `completeSupportAttachment`, `getMySupportAttachmentContent`,
`uploadCustomAvatar` and `removeCustomAvatar` to `stable` (plus the `attachmentIds` / `attachments` fields on the
ticket operations). No shape changed. Evidence cited by the changelog: staging live proof on 2026-10-08 (photos
18 PASS / 0 FAIL, avatars 19 PASS / 0 FAIL, real Google Vision scan), main CI green, an Opus security review fixed
by `b17f9e9`, and Seif's explicit word ("stable all of them"). `servers:` is unchanged: **staging only**.

**Consequences for everything below.** The sections were investigated against `2e5bb69` (3.45) and
Fable-verified; where they say the five photo operations are `draft` or that avatar upload and support photos
"cannot be built under the stable-only rule", **3.46 supersedes them**: both are now buildable under the rule,
subject to the Terms gate (`403 terms_acceptance_required`) and the owner's scope decisions. The errata table in
§1A lists each affected statement. At 3.46 **every** mobile operation in the contract is `stable`, so the
draft-vs-stable question no longer gates any wave; the open contract questions are now about *missing* things
(production host, FCM-token removal at logout, a signed-out support channel for banned students, deletion copy)
and about the contract's internal prose contradictions.

**Rule for the final workflow.** Upstream moved eight minor versions in about 28 hours (3.39 at 2026-10-07 11:12Z → 3.46 at 2026-10-08 14:56Z). The pin
must be re-checked with `git ls-remote https://github.com/seifhamdii-collab/level-up-contract HEAD` at workflow
start and before each wave that consumes a new operation, and every re-vendor must copy blobs with
`git cat-file blob` (the contract-model guard fails 13/14 on CRLF copies with a misleading "no required:" error;
`cor_ci_validation`, CI-05).

### Current contract state

**Method.** Every count below comes from parsing the YAML with PyYAML, not from grepping `x-stability`. The scripts are in the session scratchpad: `census.py`, `per_commit.py`, `errcodes.py`, `consumed_diff.py`, `enums.py`, `unconsumed.py`, `cite_drift.py` and `dartcheck/check.dart`. They ran against `git -C <scratch>/upstream-contract show <rev>:<file>`. The test evidence cited in this section comes from logs an earlier pass of this audit left in the scratchpad (`test_full.log`, `test_full_345_clone.log`, `guards_338_worktree.log`, `guards_345_clone_lf.log`); the verification pass re-read their tails, exit files and contract blob hashes but did not re-run them.

- **Upstream clone.** The upstream contract repo at `2e5bb69` (mirrored 2026-10-08 12:29 UTC).
- **Working tree matches 65245be.** The four working-tree contract files are blob-identical to `65245be`. `git hash-object --no-filters contract/<f>` equals `git -C upstream rev-parse 65245be:<f>` for openapi.yaml (`c26b51dd…`), error-codes.md, realtime.md and contract-changelog.md (CONTRACT).
- **Scratch copy matches HEAD.** `scratch/openapi_0df5cf4.yaml` is byte-identical to `git show HEAD:contract/openapi.yaml` (md5 `c8050560…`).
- **Line endings: LF, not CRLF (added in verification).** `grep -c $'\r'` returns 0 for all four working-tree contract files, and the upstream blobs at both `65245be` and `2e5bb69` hold 0 CR bytes. `.gitattributes` sets `* text=auto eol=lf` and `git check-attr` reports `eol: lf` for `contract/openapi.yaml` (SOURCE + CONTRACT). The uncommitted `contract/SOURCE.md:17` says the files are "CRLF exactly as upstream stores them". **That sentence is wrong and must be corrected before any commit that carries the 65245be text** (see the guard section and the options table).

#### Census at the three pins (CONTRACT, parsed)

| Metric | committed `0df5cf4` | working tree `65245be` (uncommitted) | upstream HEAD `2e5bb69` |
|---|---|---|---|
| `info.version` | 3.28.0-m1 | 3.38.0-m1 | 3.45.0-m1 |
| openapi.yaml lines | 3,105 | 4,188 | 4,935 |
| Operations | 54 | 77 | 86 |
| Stable / draft | 38 / 16 | 53 / 24 | 81 / 5 |
| Stable `x-consumers: [web]` (forbidden to the app) | 3 | 4 (`+listTerms`) | 4 |
| **Stable, app-buildable** | **35** | **49** | **77** |
| Consumed by the app today | 26 | 26 | 26 |
| App-buildable but not consumed | 9 | 23 | 51 |
| Schemas | 38 | 53 | 63 |
| Error codes (rows parsed from error-codes.md) | 40 | 50 | 62 |
| Tags | 10 | 12 (`social`, `chat`) | 12 |
| `servers:` | staging only (`:107-109`) | staging only | staging only, no production host |
| changelog / error-codes / realtime lines | 432 / 50 / 13 | 515 / 60 / 61 | 636 / 72 / 108 |

The four web-only stable operations are `requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `listTerms` and `redeemSubscriptionCode`. Absence of `x-consumers` means mobile-only (`openapi.yaml@2e5bb69` header, `## Consumers`). `getLegalDocument` carries `x-consumers: [mobile, web]` (`@2e5bb69:815`).

The five drafts left at 3.45 are:

- `uploadCustomAvatar` (`:982`)
- `removeCustomAvatar` (`:1042`)
- `createSupportAttachmentUpload` (`:2849`)
- `completeSupportAttachment` (`:2900`)
- `getMySupportAttachmentContent` (`:2946`)

#### Verification of the handoff's 3.28 → 3.38 summary

| Handoff item | Result | Evidence |
|---|---|---|
| ops 54→77, stable 38→53, draft 16→24, web-only 3→4, app-buildable 35→49 | ✅ exact | census table |
| 49 stable app-buildable at 65245be | ✅ 53 stable − 4 `[web]` = 49 | `census.py` |
| +10 error codes | ✅ 40→50 | See the list below. |
| +15 schemas | ✅ 38→53 | See the list below. |
| new tags `social`, `chat` | ✅ | `census.py` tag diff |
| openapi.yaml 3105→4188 lines | ✅ | `git show <rev>:openapi.yaml \| wc -l` |
| 3.29 friend graph draft, stable at 3.37 | ✅ | changelog@2e5bb69:203, :138 |
| 3.30 listTerms web-only | ✅ `x-consumers: [web]` | changelog:199 |
| 3.31 chat, 8 ops + hub, draft | ✅ | changelog:187 |
| 3.32 SMS-only, body-less errors, send `Accept: application/json` | ✅ | changelog:182-184; `ProblemDetails`@65245be:3367-3376 |
| 3.33 inbox `announcement` | ✅ `kind` enum `[enrolment_opened, announcement]` | @65245be:1071 |
| 3.34 getMyQuizSummary | ✅ | changelog:162 |
| 3.35 support statuses + `reference` | ✅ | `SupportTicket`/`SupportTicketSummary` shape moved (draft only) |
| 3.36 leaderboard hides blocked students, dense rank, wire unchanged | ✅ prose only. `getLeaderboard` keeps `x-behaviour-changed: 3.4.0-m1` (not re-stamped). | @65245be:2304-2305, :4010, :4017 |
| 3.37: 15 stable, 14 newly app-buildable | ✅ exactly 15 flips in `285d5a8` (`cacb21b`→`285d5a8` = 15; `285d5a8`→`8cd514a` = 0); 14 if `listTerms` is excluded. ⚠️ The changelog prose at :138 says "18 x-stability values … mobile for 17 of the 18", but its own bullets at :140-143 enumerate 15 and the YAML has 15. | `per_commit.py`; changelog@2e5bb69:138, :140-143 |
| 3.38 transferToUniversity draft, "may be built now" | ✅ | changelog@65245be:7 |
| No schema the app decodes changed | ✅ For the 26 consumed operations, only descriptions changed 3.28→3.38: `requestOtp`, `getLeaderboard`, `LeaderboardEntry`, `ProblemDetails`. (Past 3.41 this stops being true; see the consumed-operations table.) | `consumed_diff.py ops/schemas` |
| "Validated 2067/0/0 (format PASS, analyze 0, guard 14/14)" for the 3.38 re-vendor (added in verification) | ✅ **Reproduced at BUILD level in scratch.** `test_full.log` (live working tree, contract = 65245be): `+2067: All tests passed!`, exit 0; `analyze.log` "No issues found!"; `format_all.log` "(0 changed)". `guards_338_worktree.log`: the 13 contract-model binding tests and the canary pass. These runs were `flutter test`/`dart analyze`/`dart format` directly in the live tree, not `tool/validate.ps1` and not a throwaway worktree; the handoff's own run was not located. | scratchpad `test_full.log`, `analyze.log`, `format_all.log`, `chain_progress.txt`, `guards_338_worktree.log` |
| Same suite at 2e5bb69 (added in verification) | ✅ `test_full_345_clone.log` (scratch clone `clone345` = HEAD 8e641e9 plus the 3.45 contract files; `contract/openapi.yaml` blob `d570a425…` equals `2e5bb69:openapi.yaml`): `+2067: All tests passed!`, exit 0. `guards_345_clone_lf.log`: contract-model bindings and canary pass. | scratchpad `test_full_345_clone.log`, `clone_full_progress.txt`, `guards_345_clone_lf.log` |

**+10 error codes (3.28 → 3.38):**

- `friend_target_unavailable` 404
- `friend_request_not_found` 404
- `already_friends` 409
- `friend_request_already_pending` 409
- `conversation_not_found` 404
- `message_not_found` 404
- `message_edit_window_closed` 409
- `message_delete_window_closed` 409
- `track_transfer_not_allowed` 409
- `track_transfer_not_eligible` 403

**+15 schemas (3.28 → 3.38):** `ChatMessage`, `ChatPeer`, `ConversationSummary`, `EditChatMessageRequest`, `Friend`, `FriendRequest`, `MarkConversationReadRequest`, `PhoneLookupRequest`, `PhoneLookupResult`, `ReportChatMessageRequest`, `SendChatMessageRequest`, `SendFriendRequestResult`, `StudentCard`, `StudentIdBody`, `SupportTicketReference`.

**Version is not content identity.**

- **3.29–3.36 have no mirror commits of their own.** `cacb21b` jumps 3.28 → 3.36 in a single mirror commit.
- **3.38.0-m1 has two later mobile-relevant commits after the `65245be` pin, with the version unchanged** (`git show --stat`: `b33e658` touches contract-changelog.md, openapi.yaml, realtime.md; `495dc45` touches contract-changelog.md only; both report `info.version: 3.38.0-m1`):
  - `b33e658` (openapi.yaml +14/−6, realtime.md +1). It adds the chat-hub 3-connection cap, stores a cross-Track `blockStudent` block hidden, and changes `listMyBlocks` paging.
  - `495dc45` (changelog: `listMyFriendRequests` paging).
- **3.44.0-m1 was never mirrored on its own.** Upstream goes from `c7badad` (3.43) straight to `2e5bb69` (3.45).

Pin by commit, never by version (CONTRACT, `git log` plus a `grep -c` of `65245be:contract-changelog.md` that returned 0 for the cap and stored-block entries).

#### Per-version table 3.29 → 3.45

The "Breaking" column is as each entry declares it. Line numbers are `scratch/changelog_2e5bb69.md`. The "Mirror commit" column lists the commit(s) that changed the mobile files; admin-only commits at the same version are shown in parentheses (`git show --stat` per commit shows `8cd514a`, `0738d43`, `e4af85b`, `5733ce8`, `65245be`, `4930a9c`, `ddfef0e` and `1df7b16` touch only `*-admin` files).

| Version | Mirror commit | What changed in the mobile contract | Breaking | `x-behaviour-changed` | Census after (ops/stable/draft/app-buildable) | App impact |
|---|---|---|---|---|---|---|
| 3.29 (:203) | in `cacb21b` | 12 draft friend-graph ops, tag `social`, 7 schemas, 4 codes | no | — | — | none (draft, not consumed) |
| 3.30 (:199) | in `cacb21b` | `listTerms` draft, `[web]` | no | — | — | none (web-only) |
| 3.31 (:187) | in `cacb21b` | 8 draft chat ops, tag `chat`, 7 schemas, 4 codes, chat hub drafted | no | — | — | none |
| 3.32 (:173, :182) | in `cacb21b` | SMS-only OTP prose. `ProblemDetails` may have no body: send `Accept: application/json`, treat a body-less error as `internal_error`. `redeemSubscriptionCode` 500 = unknown (web). | BEHAVIOURAL (web, `redeemSubscriptionCode`); otherwise no | `redeemSubscriptionCode` → 3.32.0-m1 | — | `Accept` header missing; stale interceptor comment (see the impact section) |
| 3.33 (:167) | in `cacb21b` | inbox `kind` += `announcement` (`category: announcements`, Admin display text) | no | — | — | none (inbox not consumed) |
| 3.34 (:162) | in `cacb21b` | `getMyQuizSummary` draft | no | — | — | none |
| 3.35 (:157) | in `cacb21b` | `SupportTicketStatus` documents `in_progress` / `pending`; required `reference` | no | — | — | none (draft) |
| 3.36 (:152) | `cacb21b` | leaderboard excludes students blocked in either direction; dense rank per caller; prose only | no | not re-stamped | 76/38/38/35 | `getLeaderboard` (consumed): wire unchanged; `leaderboardProvider` is `autoDispose` (`leaderboard_notifier.dart:197`), so there is no cross-account rank cache |
| 3.37 (:138) | `285d5a8` (+ admin-only `8cd514a`) | 15 draft→stable: `listModules`, `listTerms` (web), `getMyQuizSummary`, 12 social | no | — | 76/53/23/49 | +14 app-buildable, none consumed |
| 3.38 (:128; post-pin :119, :122) | `0fd8fc8` (+ mobile `b33e658`, `495dc45`; admin-only `0738d43`, `e4af85b`, `5733ce8`, `65245be`) | `transferToUniversity` draft, 2 codes; post-pin: 3-connection cap, hidden cross-Track blocks, paging prose | no | — | 77/53/24/49 | none |
| 3.39 (:107) | `e5886a6` (+ admin-only `4930a9c`, `ddfef0e`) | **22 draft→stable**: recovery ×4, chat ×8, `transferToUniversity`, `getQuizReview`, `addFavorite`, `removeFavorite`, `listFavorites`, support ×5 (text only); chat hub stable | no | — | 77/75/2/71 | answers S11, S14, S31, S33 (below) |
| 3.40 (:95) | `069195b` (+ admin-only `1df7b16`) | new draft `getLegalDocument` (public, AR/EN Markdown, `ETag` / `If-None-Match` / 304); `listQuizHistory` routed (+ a new `400 validation_failed` for a bad `cursor` or a `limit` outside 1–100, changelog:101-105); code `legal_document_unavailable` 404 | no | — | 78/75/3/71 | S30 |
| 3.41 (:87) | `43352fb` | inbox `kind` += `support_ticket_replied` (`category: support`, `data` = `ticketId`, `reference`) | BEHAVIOURAL | none stamped | 78/75/3/71 | none (inbox not consumed) |
| 3.42 (:60) | `c7904bf` | See the 3.42 note below. | BEHAVIOURAL | — | 82/75/7/71 | **`verifyOtp` (consumed) gains 403** |
| 3.43 (:35, :30) | `cadba7b`, `c7badad` | See the 3.43 note below. | BEHAVIOURAL | `listConversations`, `listConversationMessages`, `editChatMessage`, `deleteChatMessage`, `reportChatMessage` → 3.43.0-m1 | 86/77/9/73 | `completeRegistration` (consumed): optional request and response fields, decode-safe |
| 3.44 (:16) | none (first mirrored in `2e5bb69`) | stable: `getMyInvite`, `forwardQuestion`, `answerForwardedQuestion`, `listMyFriendStreaks`, the forwarded-question card, hub events | no | — | — | none |
| 3.45 (:7) | `2e5bb69` | `forwardQuestion` 409 `forwarded_question_already_pending` is now per sender | BEHAVIOURAL | `forwardQuestion` → 3.45.0-m1 | 86/81/5/77 | none |

**3.42 changes:**

- **Account bans.** `403 account_banned` on `verifyOtp`, `verifyParentOtp`, `confirmRecovery` and `verifyRedemptionSessionOtp`.
- **Inbox.** `kind` += `moderation_warning`, with approved EN/AR copy.
- **Chat.** A message Support removes shows as a tombstone.
- **Support photos.**
  - 3 new draft ops.
  - Optional `attachmentIds` on the stable `createSupportTicket` and `postMySupportTicketMessage` (at most 3, no repeats: openapi@2e5bb69:2667, :2809).
  - A required `attachments[]` on `SupportTicket` and `SupportTicketMessage`.
  - Limits the contract states (KC-16, confirmed in verification): JPEG, PNG or WebP; `sizeBytes` at most 7,000,000; lowercase-or-uppercase hex SHA-256; a presigned PUT that must replay `upload.headers` exactly, expiring in at most 15 minutes (`:2845-2870`); at most 10 photos not yet attached per student, an unattached photo deleted 24 hours later (`:2862-2865`); `attachment_limit_reached` 409 when the caller holds 10 unattached photos or the photos would take the ticket over 10 (error-codes@2e5bb69:66); photos need accepted Terms (`terms_acceptance_required`, error-codes:67); the photo operations "stay `draft` until they are served on staging" (changelog:79).
- **Avatars.** `uploadCustomAvatar` is finalised and `removeCustomAvatar` is added; both are draft. Limits (openapi@2e5bb69:978-1040): at most 2,097,152 bytes (2 MiB), each side 128 to 4,096 px, at most 16,000,000 pixels, not animated, at most 5 uploads per student per hour. Photo uploads are gated by `403 terms_acceptance_required`.
- **Prose.** `updateMyProfile` and `getMyProfile`.
- **Totals.** +3 schemas, +8 codes.

**3.43 changes:**

- **Stable flips.** `getLegalDocument` and `listQuizHistory` become stable.
- **Refer a Friend.**
  - New draft `getMyInvite`.
  - Optional `inviteCode` on registration, plus `inviteCodeApplied` on the 201.
  - The inviter gets +10 per new verified account. The new student gets 0.
- **Forwarded questions and streaks.** 3 draft ops; `ChatMessage.kind` += `forwardedQuestion`.
- **Inbox.** `kind` += `academic_year_opened`.
- **realtime.md.** Push section added; the streaks hub is folded into chat.
- **`c7badad` (same version).** The chat hub must use WebSockets only with `skipNegotiation: true`.
- **Totals.** +7 schemas, +3 codes.

#### 3.38 → 3.45 delta: lists (CONTRACT)

**New operations (9):**

- `getLegalDocument`
- `removeCustomAvatar`
- `createSupportAttachmentUpload`
- `completeSupportAttachment`
- `getMySupportAttachmentContent`
- `getMyInvite`
- `forwardQuestion`
- `answerForwardedQuestion`
- `listMyFriendStreaks`

None removed, no routes moved, no new tags.

**draft→stable:**

- 23 pre-existing ops:
  - 22 in 3.39
  - `listQuizHistory` in 3.43
- 5 ops that were both introduced and stabilised inside the range:
  - `getLegalDocument` in 3.43
  - 4 in 3.44

53 + 23 + 5 = 81.

**New schemas (10):** `AnswerForwardedQuestionRequest`, `AnswerForwardedQuestionResult`, `CreateSupportAttachmentUploadRequest`, `ForwardQuestionRequest`, `ForwardedQuestionCard`, `ForwardedQuestionContent`, `FriendStreak`, `MyInvite`, `SupportAttachment`, `SupportAttachmentUpload`.

**Pre-existing schemas whose shape moved:**

- `SupportTicket`, `SupportTicketMessage`, `CreateSupportTicketRequest`, `PostSupportTicketMessageRequest` (3.42)
- `AuthenticatedResult` (+ optional `inviteCodeApplied`) (3.43)
- `SchoolRegistration`, `UniversityRegistration` (+ optional `inviteCode`) (3.43)
- `ChatMessage` (3.43)

**New error codes (12), from error-codes.md@2e5bb69:**

| Code | HTTP | Version | Line |
|---|---|---|---|
| `legal_document_unavailable` | 404 | 3.40 | :22 |
| `account_banned` | 403 | 3.42 | :51 |
| `image_too_large` | 413 | 3.42 | :61 |
| `image_content_invalid` | 422 | 3.42 | :62 |
| `image_upload_unavailable` | 503 | 3.42 | :63 |
| `attachment_not_found` | 404 | 3.42 | :64 |
| `attachment_gone` | 410 | 3.42 | :65 |
| `attachment_limit_reached` | 409 | 3.42 | :66 |
| `terms_acceptance_required` | 403 | 3.42 | :67 |
| `question_not_forwardable` | 422 | 3.43 | :68 |
| `forwarded_question_already_pending` | 409 | 3.43, meaning amended in 3.45 | :69 |
| `forward_daily_limit_reached` | 429 | 3.43; `Retry-After` = seconds to Cairo midnight | :70 |

Amended rows: `image_rejected_by_moderation`, `weekly_question_limit_reached` (answering a forwarded card spends allowance), `message_not_found`, `message_edit_window_closed`. No status changed and no code was removed.

**Enums at 3.45:**

- **Inbox `kind`** (`@2e5bb69:1211`):

  | `kind` | `category` | Since |
  |---|---|---|
  | `enrolment_opened` | `system` | before 3.28 |
  | `announcement` | `announcements` | 3.33 |
  | `moderation_warning` | `system` | 3.42 |
  | `support_ticket_replied` | `support` | 3.41 |
  | `academic_year_opened` | `system` | 3.43 |

- **Categories** (unchanged since 3.28): `system`, `announcements`, `support`. Clients must ignore an unknown `kind` or `category`.
- **`ChatMessage.kind`** = `[text, forwardedQuestion]` (`:4765`). Render an unknown value as a neutral "not supported" bubble.
- **`SupportTicketStatus`** is a free string, not an enum (`:3911`): `open`, `in_progress`, `pending`, `closed`. Treat an unknown value as "not closed".
- **`SupportAttachment.status`** is a free string (`:4011`): `ready`, `expired`, `removed`. Treat an unknown value as "not available".
- **Others:** `ForwardedQuestionCard.contentState` `[visible, unavailable]`; `FriendRequest.direction` `[incoming, outgoing]`; `SendFriendRequestResult.status` `[pending, accepted]`.

**Headers.** `components.headers` is empty at every pin. `getLegalDocument` adds a request header `If-None-Match` and response headers `ETag` and `Cache-Control`, with a 304. The presigned support-photo PUT must replay the returned `upload.headers` verbatim: `Content-Type`, `Content-Length`, `x-amz-checksum-sha256`, `x-amz-acl`. `Retry-After` stays prose-only on 429s.

**realtime.md at 3.45:**

- **Chat hub.** `/hubs/chat` is stable (3.39), outside `/api/v1`.
- **Transport.** WebSockets only with `skipNegotiation: true`. The token travels in the `access_token` query parameter. At most 3 connections per student (`realtime.md@2e5bb69:24`, `:33`).
- **Events.** `messageCreated`, `messageEdited`, `messageDeleted`, `conversationRead`, `conversationRemoved`, `typing`, `forwardedQuestionAnswered`, `friendStreakChanged`.
- **Push.** The new "Push notifications (FCM)" section (`:78-108`) states exactly four kinds (`support_ticket_replied`, `friend_request_received`, `academic_year_opened`, `chat_message_received`; "Nothing else is ever pushed — not `enrolment_opened`, not `announcement`"), the `data` keys per kind (`kind` plus `ticketId`, `friendRequestId`, `conversationId` or nothing), the eight loc keys `push_{kind}_{title,body}`, and a table of the eight EN/AR strings the app ships. The four kinds, data keys and eight key names agree with the handoff text available to this audit (CONTRACT). **Whether the EN/AR string values match the handoff word for word is UNVERIFIABLE here: the handoff text supplied to this run says only that EN/AR text exists and carries no string values.** The section also says:
  - Delivery is **off in every environment** until the staging verification is recorded (`:80`).
  - Notifications are OS-rendered from loc keys, so **"the text follows the phone's language, not the in-app language switch"** (`:83`).
  - Tap handling includes "An unknown `kind`: open the notifications screen and ignore the rest" (`:106`); the app registers its FCM token after sign-in and on every token refresh, one token per student, the latest wins (`:108`).



## 4. Backend handoff verification

### 4. Backend handoff verification

**Verdicts**

| Verdict | Meaning |
|---|---|
| VERIFIED | The claim holds against upstream `eddb6ac` (3.46.0-m1) and against the repo at `8e641e9`. |
| PARTLY | True, but incomplete or imprecise. |
| STALE | Was true; superseded by 3.39–3.46. |
| REFUTED | Contradicted by the contract or the repo. |
| NOT VERIFIABLE | No contract or repo source can confirm it. |

**Line keys**
- `openapi@3.46:N`, `realtime@3.46:N` and `error-codes@3.46:N` use the same numbering at `2e5bb69` and `eddb6ac`.
- `changelog@3.46:N` equals `changelog@2e5bb69:N−12`.

**Source and coverage**
- The handoff text itself was not an input to this synthesis. Claims are as quoted by the dimension sections, and the 16 push strings rest on the investigators' transcription.
- Contract rules the handoff omits are folded into the nearest row's "Current fact" column.

| Claim | Verdict | Current fact | Evidence | Level |
|---|---|---|---|---|
| §3.1 The Figma Subscription screen is incompatible with the purchase-silent app | VERIFIED | No standalone subscription frame is recorded. The conflicting Figma surfaces are the Profile row "Upgrade to premium" (`170:4890`), the inbox row "Premium Offer — 40% Off!" (`180:8768`) and the limit frames that draw an Upgrade CTA (#51). The app has no subscription surface: `lib/features/subscription/` holds only `.gitkeep`, and `/subscription` was removed (D-007) | `app_router.dart:484-487`; `DESIGN_ISSUES.md` #51; `DECISIONS.md:252-290`; cor_design §5.1 | DESIGN (Figma read) + SOURCE + DOC |
| §3.2 Turn it into a subscription status / information screen | PARTLY | A read-only status with no link (active / `expiresAt` / `inGrace`; there is no `pending` state) breaks no rule found. `getMyEntitlements` is stable at every pin and is already decoded, but its provider is never watched. No frame exists, D-007 governs any status copy, and whether the screen should exist at all is the owner's call (I-9) | `openapi@3.46:1409-1412`; `me_notifier.dart:78-101`; Q.md I-9 / DC-6 | CONTRACT + SOURCE |
| §3.3 …with a link to the website | REFUTED (conflicts with the contract) | adr-049 §3: the app "never carries a purchase link, and never tells the student where to buy". §4: the app never mentions code redemption. No contract version up to 3.46 revises this. R-10 is OPEN — DECISION, and `8e641e9` withdrew the `/redeem` URL slot. Allowing the link needs a Seif changelog revision plus the owner's acceptance of the Apple 3.1.1/3.1.3 exposure | `changelog@3.46:576`, `:338`, `:585-589`; `RISKS.md:142-150`; `ENVIRONMENTS.md:405-412` | CONTRACT + DOC |
| §4.1 Subscription: in Figma, not backed by the backend | VERIFIED | Still unbacked, by rule. Only `getMyEntitlements` exists, at data level. The 4 redemption operations are `x-consumers: [web]` | `openapi@3.46` x-consumers; `changelog@3.46:576` | CONTRACT |
| §4.2 Chat photos: in Figma, no backend | VERIFIED | No operation at any pin, 3.46 included: chat is text plus forwarded-question cards. The Figma camera, snap and editor frames also conflict with domain rule 9 (camera blocked) | `openapi@3.46:143-150`; `realtime@3.46:17`; Figma `649:8851`, `166:4260`, `166:4319`; `.claude/skills/level-up-domain/SKILL.md:22` | CONTRACT + DESIGN |
| §4.3 Chat voice: in Figma, no backend | VERIFIED | The contract excludes it. Figma has a player (`215:2727`, `166:4150`) and a mic (`215:2732`) | `openapi@3.46:149`; `realtime@3.46:17` | CONTRACT + DESIGN |
| §4.4 Chat groups: in Figma, no backend | PARTLY | The backend half holds: there is one conversation per friendship. No group frame was found; there is only a `bi:people` header icon (`649:8837`), so the Figma half is unconfirmed | `openapi@3.46:143-150`; cor_features_social §3.3 | CONTRACT + DESIGN |
| §4.5 Notification "Support" tab: no backend | STALE (superseded by 3.39-3.46) | Now backed: `listMyNotifications?category=support` (the category enum is stable since before 3.28) is filled by the kind `support_ticket_replied` (3.41). The inbox operations have been stable since 3.28 and are still never called. The Promotions chip has no category | `openapi@3.46:1153-1159`, `:1186-1192`, `:1211`; `changelog@3.46:99`; Figma chip `180:8726-8730` | CONTRACT + DESIGN |
| §4.6 Streak flames: no backend | PARTLY | The friend flame is backed by `listMyFriendStreaks` and the hub event `friendStreakChanged` (stable 3.44). The personal "12 days Streak" (`308:4203`) and the "Daily Streak" inbox row (`180:8786`) have no operation and no field | `openapi@3.46:3825`; `realtime@3.46:10`, `:58-63` | CONTRACT + DESIGN |
| §4.7 Referral contradiction: Figma gives 500 points to both, the backend 10 to the inviter | VERIFIED | Figma `178:2646` says "you both earn 500 bonus points!" and shows a 9-character sample code. `getMyInvite` gives +10 to the sharer per new OTP-verified account, in the current Track's points, and nothing to the new student. There is no credit without an active enrolment, and codes are 8 characters. A third, stale definition ("Referral codes (50% off)") sits in the parent roadmap. This is not decided here (I-18) | `openapi@3.46:1434-1450`, `:4193-4219`; `F:\level\05_roadmap_scaffold.md:69`; cor_design §5.2 | CONTRACT + DESIGN (read twice) |
| §4.8 Quiz history: in Figma, no backend | STALE (superseded by 3.39-3.46) | Now backed: `getQuizReview` is stable since 3.39 and `listQuizHistory` since 3.43. No history-list frame was found. Home "Continue Learning" (`308:4186`) is only a lead, and `QuizHistoryItem` cannot fill that card as drawn | `changelog@3.46:119`; `openapi@3.46:1877`; `endpoint_ui_mapping.md:130` | CONTRACT + DOC |
| §4.9 Avatar upload: not previously backed | STALE (superseded by 3.39-3.46) | `uploadCustomAvatar` existed as draft at every vendored pin, with the old "≤ 5 MB" shape at 3.28 and 3.38. It was finalised in 3.42, when `removeCustomAvatar` was added, and both are stable since 3.46. The Figma sheet `216:3341` has an Upload row but no crop, remove, rejected, rate-limit or Terms states | `openapi@3.46:981`, `:1041`; `changelog@3.46:7-18`; `openapi_65245be:912-942` | CONTRACT + DESIGN |
| §4.10 Settings notification preferences: no backend | VERIFIED | No preference, mute or consent operation exists at any pin, 3.46 included. The 4 toggles render ON and disabled (S28 is open) | `changelog@3.46:331`; `settings_screen.dart:341-421` | CONTRACT + SOURCE |
| §4.11 Progress: no backend | PARTLY | One number is backed: `getMyQuizSummary` returns `{solvedQuestions}` (stable 3.37, never called). The weekly chart, study time, the "+30%" figure and the badge history in `309:9671` have no backend. The Solved Questions tile is held back by ruling #101 ("Points only") | `openapi@3.46:1727-1745`; `changelog@3.46:150`; DESIGN_ISSUES #101 | CONTRACT + DOC |
| §5.1 Terms step: backend built, design missing | VERIFIED (with an addition) | `getTermsAcceptance` and `acceptTerms` are stable at every vendored pin (0df5cf4 included); `getLegalDocument` is stable since 3.43. Staging serves Terms and Privacy `r4-2026-10-07` in Arabic and English. Figma has only a passive consent line (`82:1086`), and no code in `lib/` calls these operations. **Addition:** photo uploads answer `403 terms_acceptance_required` once a Terms version is published, and on staging one is. `acceptTerms` needs authentication, so acceptance can only come after the registration 201 or after a sign-in | `openapi@3.46:816-831`, `:1025`, `:1087-1123`; `error-codes@3.46:67`; staging probe 2026-10-08 | CONTRACT + SOURCE + LIVE-PROBE |
| §5.2 Track-transfer confirmation: backend built, design missing | PARTLY | `transferToUniversity` is stable since 3.39 (draft at 3.38, absent at 3.28). A confirm-dialog frame exists (`180:4301`, dark `337:7561`, RTL `549:21179`) and is built with Confirm disabled. Missing: the University, faculty and study-year pickers, the irreversible second confirmation, the disclosure, and the success and error frames. The row also shows for University students | `openapi@3.46:1338-1412`; `error-codes@3.46:59`; `profile_screen.dart:307-353` | CONTRACT + SOURCE + DESIGN |
| §5.3 Account deletion: backend built, design missing | VERIFIED | `requestAccountDeletion` is stable at every pin, with no UI and no frame. The mandated confirm copy says "An active paid subscription is forfeited — there is no partial refund" (Q-B2, never filed). The 202 obliges the app to purge the token pair | `openapi@3.46:1267`, `:1276-1286`; `wave_state.md:1607`; DESIGN_ISSUES #62 | CONTRACT + SOURCE + DOC |
| §5.4 Account cancellation: backend built, design missing | VERIFIED | `cancelAccountDeletion` is stable at every pin. The contract says "route to the cancel screen", but no screen or frame exists. The `account_pending_deletion` copy appears at 5 code sites, and none offers a way out | `openapi@3.46:82-83`, `:1315`; `exceptions.dart:95-135` | CONTRACT + SOURCE |
| §5.5 Lost-phone recovery screens: backend built, design missing | VERIFIED (at a pin ≥ 3.39) | The 4 operations are stable since 3.39 (draft at 3.28 and 3.38). There are no flow frames; the only weak lead is the OTP copy on `82:1171`. Recovery is designed to work with cancel-deletion, and `parentPhone` is write-only (S34) | `openapi@3.46:72-79`, `:466-594`; `endpoint_ui_mapping.md:133` | CONTRACT + DOC |
| §5.6 Logged in on another device: backend built, design missing | PARTLY | The design is indeed missing, but the behaviour is already built and tested: any `401 session_superseded` forces a logout, and `/login` shows a one-time message. The contract text says "show the forced-logout screen". Whether the message is enough is N-20 | `openapi@3.46:58-60`; `auth_interceptor.dart:75-78`, `:147-151`; `login_screen.dart:60-76`; `login_logout_message_test.dart:57` | CONTRACT + SOURCE |
| §5.7 Chat report: backend built, design missing | VERIFIED (at a pin ≥ 3.39) | `reportChatMessage` and `reportStudent` are stable since 3.39 (draft at 3.38). No frame was found. The report comes before the block, takes no reasons, and forwarded cards cannot be reported | `openapi@3.46:3630`, `:3667` | CONTRACT + DESIGN |
| §5.8 Chat block: backend built, design missing | VERIFIED | `blockStudent` is stable since 3.37. It always answers 204, removes the friendship and the conversation, and does not notify the other student. No frame | `openapi@3.46:3311` | CONTRACT + DESIGN |
| §5.9 Chat unfriend: backend built, design missing | VERIFIED | `removeFriend` is stable since 3.37 (idempotent 204; the other student is not notified). No frame | `openapi@3.46:3022` | CONTRACT + DESIGN |
| §5.10 Blocked list: backend built, design missing | VERIFIED | `listMyBlocks` and `unblockStudent` are stable since 3.37. There is no frame and no entry point | `openapi@3.46:3276`, `:3346` | CONTRACT + DESIGN |
| §5.11 Limit pop-ups: backend built, design missing | PARTLY (the design half is REFUTED) | Already built (`LimitSheet`; Wave 11 walked to 100% on mock). Light frames exist (`199:2335`, `225:6634`, `225:7001`) but draw a forbidden Upgrade CTA (#51). Only the dark frame is missing (#74) | `quiz/widgets/limit_sheet.dart`; DESIGN_ISSUES #51, #74 | SOURCE + DOC |
| §5.12 Lockout pop-ups: backend built, design missing | PARTLY | `429 otp_throttled` (a 15-minute lock after 5 failed verifies) is stable at every pin. The app shows it only as an inline line, there is no frame, and the contract declares no `Retry-After` on it. The repo uses "lockout" to mean `otp_throttled`; whether the handoff also means `account_banned` is N-16 | `openapi@3.46:200`, `:234`; `auth_error_copy.dart:18-19`; `day1_login_otp_brief.md:114` | CONTRACT + SOURCE + DOC |
| §5.13 Empty states: design missing | PARTLY | There are no frames (DI #60, #76, #119), but list screens already have empty states. No guard enforces them | `catalog_states.dart`; cor_features_social §3.7 | SOURCE + DOC |
| §5.14 Loading states: design missing | PARTLY | Built (skeletons and button spinners), without dedicated frames | `home_screen.dart:146-185`; `catalog_states.dart:221` | SOURCE |
| §5.15 Offline states: design missing | PARTLY | `OfflineBanner` is on 22 screens; the quiz question, result and review screens lack it. There are no frames and no guard | `lib/core/widgets/offline_banner.dart`; MAT 5.2 | SOURCE |
| §5 (completeness) The list above is the full set of backend-built surfaces without design | PARTLY | The list omits five surfaces: the `account_banned` screen the contract asks for (3.42; no frame; no signed-out Support channel); where a student with a pending deletion lands; the University module picker (`listModules`, stable 3.37); the quiz-history list; and the favourites list (no frames) | `changelog@3.46:78`; `error-codes@3.46:51`; `openapi@3.46:1685`, `:1877`, `:2131` | CONTRACT + DOC |
| §6.1 Support photos: JPEG, PNG, WebP; PDF not supported | VERIFIED | The `contentType` enum is `[image/jpeg, image/png, image/webp]` | `openapi@3.46:4032` | CONTRACT |
| §6.2 Support photos: at most 7 MB = 7,000,000 bytes each | VERIFIED | 1 to 7,000,000 decimal bytes; above that the answer is `413 image_too_large` | `openapi@3.46:4033`; `error-codes@3.46:61` | CONTRACT |
| §6.3 At most 3 photos per message | VERIFIED | `attachmentIds` takes at most 3, with no repeats, when creating a ticket or replying | `openapi@3.46:2667`, `:2809`, `:3990` | CONTRACT |
| §6.4 At most 10 photos per ticket | VERIFIED | Above 10 the answer is `409 attachment_limit_reached`. **The handoff omits:** at most 10 unattached photos per student, deleted 24 h after presign; a presigned PUT valid for ≤ 15 minutes that must replay `upload.headers` exactly; and `410 attachment_gone` 90 days after the ticket closes | `openapi@3.46:2697`, `:2840`, `:2854-2863`, `:4023` | CONTRACT |
| §6.5 Every photo is safety-checked, and an unsafe photo is refused | VERIFIED | The server checks size, SHA-256, magic bytes, ≤ 50 MP and not animated, then runs Google SafeSearch. "A refused photo is gone" | `openapi@3.46:2904-2912`; `error-codes@3.46:16` | CONTRACT |
| §6.6 Copy: "This photo can't be sent" | VERIFIED (English only) | This is the contract's own suggested support string. No Arabic is supplied, and the client owns the strings (I-20) | `openapi@3.46:2934`; `error-codes@3.46:16` | CONTRACT |
| §6.7 Staff replies never contain photos | VERIFIED | `attachments` is "always empty on a staff reply" | `openapi@3.46:3980` | CONTRACT |
| §6.8 Voice notes come later | NOT VERIFIABLE | The contract says nothing about voice in support, and chat excludes voice outright. "Later" is a product statement with no contract source. Figma still draws a support mic (`178:3471`) | `openapi@3.46:149`; `realtime@3.46:17` | CONTRACT + DESIGN |
| §6.9 The old Figma wording "PNG, JPG, or PDF up to 10MB" is wrong | VERIFIED | Figma `178:3368` reads exactly that, and it contradicts the contract (no PDF, 7,000,000 bytes, WebP accepted). The designer owes the replacement copy | Figma `178:3368` (read twice); `openapi@3.46:4032-4033` | DESIGN + CONTRACT |
| §6.10 The exact upload endpoints, request shapes and error codes "will come from the next contract version" | STALE (superseded by 3.39-3.46) | Published as draft in 3.42 and stable since 3.46 with no shape change ("build these screens now"). That covers the 3 support-photo operations, the finalised `uploadCustomAvatar`, `removeCustomAvatar`, 7 image and attachment codes, and `terms_acceptance_required`. None of them is in `65245be`. The staging routes answer 401/405 | `changelog@3.46:7-18`, `:72-96`; `openapi@3.46:978-1059`, `:2845-2982`; probe 2026-10-08 | CONTRACT + LIVE-PROBE |
| §6.11 Avatar: JPEG, PNG, WebP | VERIFIED | The same three types. The bytes decide, not the part's Content-Type or file name | `openapi@3.46:985-998` | CONTRACT |
| §6.12 Avatar: at most 2 MB | PARTLY | The cap is 2,097,152 bytes (2 MiB), not 2,000,000, so a client pre-check must use 2,097,152. **The handoff omits:** 128–4,096 px a side, ≤ 16,000,000 px, not animated, cropped square and uploaded upright, ≤ 5 uploads an hour, uploads locked for the rest of the hour after 3 refused photos, and `503 image_upload_unavailable` | `openapi@3.46:987-990`, `:1028`, `:1034-1038`; `changelog@3.46:11` | CONTRACT |
| §6.13 Avatar: the same safety check | VERIFIED | Yes, but the avatar copy is "this photo can't be used", not "can't be sent" | `openapi@3.46:993-995`, `:1031`; `error-codes@3.46:16` | CONTRACT |
| §6.14 If an avatar is rejected, the default avatar remains | PARTLY | The contract says "nothing is stored and the previous avatar stays". The previous avatar may be an earlier custom photo, not the default | `openapi@3.46:995`, `:1031` | CONTRACT |
| §6.15 The student can replace and remove the avatar | VERIFIED | PUT replaces it: every upload gets a new CDN URL and the previous photo is deleted. DELETE returns to the last chosen default (idempotent 204, no Terms gate). Choosing a default `avatarId` through PATCH `/me` also deletes the custom photo. Both are stable since 3.46. **The handoff omits:** upload needs accepted Terms (403); avatars are public on the CDN once scanned; and a replaced photo may stay cached for up to 1 hour | `openapi@3.46:951-952`, `:981`, `:996-997`, `:1041-1059`; `changelog@3.46:14-15` | CONTRACT |
| §7.1 Seif needs the Android application ID and the iOS bundle ID | VERIFIED (answerable from the repo) | D-021 Q1 (ratified 2026-10-06): `com.levelupworld.app` for prod and `com.levelupworld.app.stg` for staging, on both platforms; display names "Level Up" and "Level Up STG"; iOS minimum 15.0. Android has these ids on `merged` only, proven in the built APK. iOS Xcode still has the template `com.levelup.levelUpApp` at 13.0, so Seif must be given the ratified id. Nothing is registered anywhere | `DECISIONS.md:1054-1058`; `build.gradle.kts:55`, `:76`; aapt2 on `app-prod-release.apk`; `android_identity_test.dart` 9/9; `project.pbxproj:349`, `:371` | DOC + SOURCE + ARTEFACT + BUILD |
| §7.2 The staging app (`.stg`) uses a staging Firebase project and production uses a production one | NOT VERIFIABLE | The contract carries no Firebase or app-id data. Seif's input of 2026-10-06: no Firebase credential, nothing registered, and whether the flavors share a project is "not finalised". No config file exists; the slots are reserved and the Android guard passes vacuously. RISKS R-9 forbids any Firebase registration until ownership is settled (I-12) | `ENVIRONMENTS.md:340-357`; `DECISIONS.md:1060`; `RISKS.md:137`; `android_identity_test.dart:202-239` | DOC + SOURCE |
| §8.1 Exactly 8 localization keys, with the listed EN and AR strings | VERIFIED (contract side) | The 8 `push_{kind}_{title,body}` keys and their strings compare identical, codepoint by codepoint, re-run against 3.46. The contract has no key the handoff lacks. The handoff side rests on the transcription. The push section exists only from 3.43, so neither vendored pin has it | `realtime@3.46:93-104`; SCRATCH `compare_push.py` | CONTRACT |
| §8.2 The old `enrolment_opened` keys are no longer sent | VERIFIED | "Nothing else is ever pushed — not `enrolment_opened`, not `announcement`". `enrolment_opened` remains an inbox kind, and its `data` keys are documented nowhere (N-3) | `realtime@3.46:82`; `openapi@3.46:1211` | CONTRACT |
| §8.3 …but they may remain in the app | REFUTED | No `enrolment_opened` or `push_*` string exists in `lib/`, `test/` or `android/app/src`, and no contract snapshot ever defined `enrolment_opened` push keys | grep (0 hits); `git log -S enrolment_opened -- realtime.md` | SOURCE + CONTRACT |
| §8.4 The payload always carries `kind`, one of 4 values | VERIFIED | The four kinds are `support_ticket_replied`, `friend_request_received`, `academic_year_opened` and `chat_message_received`. `data` holds `kind` and opaque string ids only | `realtime@3.46:82-84` | CONTRACT |
| §8.5 Per-kind data: `ticketId`; `friendRequestId`; nothing else; `conversationId` | VERIFIED | Exactly as stated. `friendRequestId` equals the incoming request's `requestId` | `realtime@3.46:86-91`, `:106` | CONTRACT |
| §8.6 Unknown kind: open the notifications screen and ignore the rest | VERIFIED | This is a contract rule, not only an app rule. No notifications screen exists yet (`/message` is a placeholder and the bell is inert), and which screen it should be is open (I-17) | `realtime@3.46:106`; `app_router.dart:313-316` | CONTRACT + SOURCE |
| §8.7 Privacy: no names, phone numbers or message text; chat pushes carry no sender name or text | VERIFIED | "No title or body text, no name, no message text and no ticket subject", and no other key is ever sent. A chat push writes no inbox row and is limited to one per conversation per 5 minutes | `realtime@3.46:76`, `:83-84` | CONTRACT |
| §8.8 Request notification permission on iOS and on Android 13+ | NOT VERIFIABLE (against the contract) | A platform requirement the contract never mentions. The app has no `POST_NOTIFICATIONS`, no permission or messaging package, and no iOS entitlement or `UIBackgroundModes`. Prompt timing and copy are for the owner and designer (I-16) | `AndroidManifest.xml:19`; `pubspec.yaml:30-65`; `store_readiness_parts/14_declarations_permissions.md:165` | SOURCE + DOC |
| §8.9 Send the FCM token to `PUT /api/v1/me/fcm-token` after sign-in and on every new token | VERIFIED | `registerFcmToken` is stable at every pin: one token per student, and the latest wins. The roadmap's "POST" is wrong, and the app has no call site. **The handoff omits:** there is no unregister operation, and `logout` says nothing about the token (I-3) | `openapi@3.46:451-461`, `:1060-1082`; `realtime@3.46:108`; `changelog@3.46:331` | CONTRACT + SOURCE |
| §8.10 A tap while the app is closed or in the background opens the correct screen | PARTLY | The contract gives a target per kind: the ticket, the friend-requests list, the notifications screen and the conversation. It does not describe the app lifecycle or the signed-out and evicted cases. All four destinations are unbuilt. `authRedirect` drops the tapped location and the router has no `errorBuilder`. Whether tap routing counts as a "deep link" under D-021 Q7 is N-14 | `realtime@3.46:106`; `app_router.dart:74-83`, `:109-112`; `DECISIONS.md:1060` | CONTRACT + SOURCE + DOC |
| §8.11 The app ships the strings | PARTLY | The phone renders the keys "from strings shipped in the app", so the text follows the phone's language, not the in-app switch (N-24). The strings must therefore be native resources: Android `values/` and `values-ar/` `strings.xml`, and iOS `Localizable.strings`. None of these exists, iOS `knownRegions` lacks `ar`, and the ARB parity guard does not cover native files. That the OS resolves them natively is INFERRED until a real push arrives | `realtime@3.46:83`; `project.pbxproj:188-191`; `android/app/src/main/res` listing | CONTRACT + SOURCE (INFERRED) |
| §8.12 The required behaviour can be built and tested now | PARTLY | Buildable from the stable 3.43 shape. However, delivery is OFF in every environment until Seif records the staging verification, so no push can reach a device (I-6d). Server senders exist behind gates | `realtime@3.46:80`; `changelog@3.46:46`, `:71` | CONTRACT |
| §9.1 3.28 → 3.38: operations 54 → 77, stable 38 → 53, draft 16 → 24, web-only 3 → 4, app-buildable 35 → 49 | VERIFIED | Reproduced by independent PyYAML parses | SCRATCH `census.py`, `crit/census346.py` | CONTRACT |
| §9.2 +10 error codes | VERIFIED | 40 → 50: 4 friend codes, 4 chat codes, `track_transfer_not_allowed` and `track_transfer_not_eligible` | `error-codes.md` at both pins | CONTRACT |
| §9.3 +15 schemas | VERIFIED | 38 → 53 | `census.py` | CONTRACT |
| §9.4 New tags `social` and `chat` | VERIFIED | 10 → 12 tags | `census.py` | CONTRACT |
| §9.5 `openapi.yaml` grew from 3,105 to 4,188 lines | VERIFIED | Counted with `git show <rev>:openapi.yaml`. At 3.46 it is 4,935 lines | upstream clone | CONTRACT |
| §9.6 No schema the app decodes changed | VERIFIED (for 3.28 → 3.38 only) | Only descriptions of consumed operations changed. This does not hold for a re-vendor to 3.46: `verifyOtp` gained `403 account_banned` (3.42, a behavioural change), and registration gained the optional `inviteCode` / `inviteCodeApplied` (3.43/3.44). 24 of the 26 consumed operations are structurally unchanged, and the 13 guard-bound `required` lists are identical at all four pins | `consumed_diff.py`, `drift_check.py`; `openapi@3.46:230-232`, `:4087-4093` | CONTRACT |
| §9.7 The working-tree contract hashes match upstream `65245be` | VERIFIED | All four files are blob-identical, in both `--no-filters` and plain mode. The HEAD blobs equal `0df5cf4` | `git hash-object` vs `git rev-parse 65245be:<f>` | CONTRACT + SOURCE |
| §9.8 Validated in a throwaway worktree: format PASS, analyze 0, 2067/0/0, guard 14/14 | VERIFIED (reproduced; the original run was not located) | Reproduced on 2026-10-08 in the live working tree: format 0 changed (369 files), analyze 0, `+2067: All tests passed!`, guards 122/122 including contract_models 14/14, and an unchanged repo fingerprint. It was not run through `validate.ps1` or in a throwaway worktree | SCRATCH `test_full.log`, `guards_338_worktree.log`, `analyze.log`, `format_all.log` | BUILD |
| §9.9 Re-vendor record: the files are "CRLF exactly as upstream stores them" | REFUTED | The upstream blobs and the working tree contain 0 CR bytes, and `.gitattributes` enforces LF. The guard parser fails 13 of 14 tests on a CRLF copy. Fix `contract/SOURCE.md:17` before any commit | `contract/SOURCE.md:17`; `tr -cd '\r'` counts; `test/guards/rules.dart:368`, `:403-406`; `aud/probe_crlf.log` | SOURCE + CONTRACT + BUILD |
| §9.10 `65245be` (3.38) is the upstream head to vendor | STALE (superseded by 3.39-3.46) | Upstream HEAD is `eddb6ac` (3.46.0-m1), 13 commits and 8 versions later; `git ls-remote` re-confirmed it on 2026-10-09. "3.38.0-m1" also labels two later mobile snapshots that `65245be` lacks: `b33e658` (the 3-connection hub cap, hidden cross-Track blocks, `listMyBlocks` paging) and `495dc45` (`listMyFriendRequests` paging) | `git ls-remote`; `git log 65245be..eddb6ac`; `changelog@3.46:131`, `:134` | CONTRACT |
| §9.11 Eight upstream commits lie between the pins | VERIFIED | `0df5cf4..65245be` = 8 commits (21 to `eddb6ac`) | `git log` in the upstream clone | CONTRACT |
| §10.1 3.29: the friend graph, draft; stable at 3.37 | VERIFIED | 12 draft operations, the `social` tag, 7 schemas and 4 codes; all stable in 3.37 | `changelog@3.46:215`, `:150` | CONTRACT |
| §10.2 3.30: `listTerms`, web-only | VERIFIED | `x-consumers: [web]`. These are academic terms, not the legal Terms, and the app must not consume it | `changelog@3.46:211` | CONTRACT |
| §10.3 3.31: chat, 8 operations plus the hub, draft | VERIFIED (status STALE) | As stated for 3.31. All 8 operations and the hub are stable since 3.39 | `changelog@3.46:199`, `:119`; `realtime@3.46:11` | CONTRACT |
| §10.4 3.32: OTP by SMS only; errors may have no body; send `Accept: application/json` | VERIFIED | As stated. The app still sends no `Accept` header | `changelog@3.46:194-196`; `dio_client.dart:19` | CONTRACT + SOURCE |
| §10.5 3.33: inbox kind `announcement` | VERIFIED | The kind enum became `[enrolment_opened, announcement]`; it has 5 kinds at 3.46 | `changelog@3.46:179`; `openapi@3.46:1211` | CONTRACT |
| §10.6 3.34: `getMyQuizSummary` | VERIFIED | Draft at 3.34, stable at 3.37 (not 3.38) | `changelog@3.46:174`, `:150` | CONTRACT |
| §10.7 3.35: support statuses and `reference` | VERIFIED | `in_progress` and `pending` were documented and `reference` became required, still draft then. The entry's own bump line, "3.28 → 3.35", skips 3.34 (N-2i) | `changelog@3.46:169` | CONTRACT |
| §10.8 3.36: the leaderboard hides blocked students, ranks are dense, the wire is unchanged | VERIFIED | A prose-only change, with no new `x-behaviour-changed` stamp (N-2j). The app's provider is autoDispose, so no rank is cached across accounts | `changelog@3.46:164`; `leaderboard_notifier.dart:197` | CONTRACT + SOURCE |
| §10.9 3.37: 15 operations became stable, 14 of them newly app-buildable | VERIFIED | Exactly 15 flips in `285d5a8`: `listModules`, `listTerms` (web), `getMyQuizSummary` and 12 social operations. The changelog prose itself says "18", which is a contract error (N-2i) | `changelog@3.46:150-155`; `per_commit.py` | CONTRACT |
| §10.10 3.38: `transferToUniversity` is draft, and its screens "may be built now" | STALE (superseded by 3.39-3.46) | True at 3.38. It is stable since 3.39, so the draft-exception question (DR-24) is moot at any pin ≥ 3.39 | `changelog@3.46:140`, `:119`; `openapi@3.46:1337` | CONTRACT |
| §11.a Open question: `transferToUniversity` is draft, which the stable-only rule forbids | STALE (superseded by 3.39-3.46) | Stable since 3.39 (`e5886a6`). The question is live only if `65245be` is committed and transfer work starts before the next re-vendor | `openapi@3.46:1337` | CONTRACT |
| §11.b Open question: `Accept: application/json` | VERIFIED (an open gap) | The app sends no `Accept` header: `BaseOptions` sets only `Content-Type`, and Dio 5.10.0 adds none. The photo read needs a per-request `Accept: image/*, application/problem+json`. Whether the missing header ever produces a body-less error is unknown. The gap is already noted in the uncommitted `SOURCE.md:52-55` | `openapi@3.46:2953`, `:3883-3890`; `dio_client.dart:15-20` | CONTRACT + SOURCE |
| §11.c Open question: the old comment in `error_interceptor.dart` | VERIFIED (the comment is stale) | `:9-10` says every non-2xx body is ProblemDetails with a stable `code`; 3.32 withdrew that promise. The code already falls back to `code: 'unknown'` (`:25-27`) | `error_interceptor.dart:9-10`, `:25-27`; `changelog@3.46:196` | SOURCE + CONTRACT |
| §11.d Open question: S11 (favourites) is still open | STALE (superseded by 3.39-3.46) | `addFavorite`, `removeFavorite` and `listFavorites` are stable since 3.39. They are draft at 3.38, so "open" holds only at that pin. The Profile row is still disabled | `openapi@3.46:2105-2131`; `profile_screen.dart:240-248` | CONTRACT + SOURCE |
| §11.e Open question: the FriendScreen TODO may be stale | VERIFIED | Stale since 3.37, when the 12 social operations became stable. Its citation `openapi.yaml:1094` matches no pin; the text was removed upstream on 2026-09-04 (`8ae7ed1`) | `friends_screen.dart:9-13` | SOURCE + CONTRACT |
| §11.f Open question: S36 (where students enter Friends) | VERIFIED (still open) | Ask 1 (endpoints) is answered. But nothing navigates to `/friends`, and the Profile frame has no Friends row; the only hint is the push target. A designer and owner question (I-17) | `app_router.dart:420-423`; `friends_screen.dart:15-19`; `realtime@3.46:106` | SOURCE + CONTRACT |
| §11.g Open question: S24 is answered by `GET /me/quiz-summary` | VERIFIED | `getMyQuizSummary` returns `{solvedQuestions}` and is stable since 3.37. It is a separate read, not a `/me` field. It is never called, and the card is held back by ruling #101 | `openapi@3.46:1727-1745`; `profile_screen.dart:38-41` | CONTRACT + SOURCE |
| §11.h Open question: contract line references have shifted | VERIFIED | Of the 82 citations in `lib/` and `test/` that are relative to `0df5cf4`: against `65245be`, 15 are on the same line and 67 shifted; against `2e5bb69` (same numbering as 3.46), 15 are the same, 64 shifted and 3 now sit on changed lines. `lib/` holds 64 such citations in 37 hand-written files (plus 8 in generated files), `test/` 18 and `docs/` 111. Example: `F:\level\CLAUDE.md:11` cites `openapi.yaml:754` for "no pending state", which is `:1412` at 3.46 | SCRATCH `cite_drift.py`; `openapi@3.46:1412` | SOURCE + CONTRACT |
| §12.1 Branch `merged` @ `8e641e9`, 1 ahead of `origin/merged` | VERIFIED | Re-checked on 2026-10-09. The unpushed commit touches 2 docs files only | `git status -sb`; `git show --stat 8e641e9` | SOURCE |
| §12.2 Committed pin `0df5cf4` (3.28.0-m1); the 3.38 re-vendor `65245be` is in the working tree, uncommitted | VERIFIED | Uncommitted on purpose: the owner asked for a re-vendor, not a commit. The SOURCE.md delta prose exists nowhere upstream, so `git restore contract/` would destroy it | `contract/SOURCE.md:19`; `git diff --stat` | SOURCE + DOC |
| §12.3 Only `contract/*` is dirty | PARTLY | The only tracked changes are the 5 `contract/*` files (+1,498/−217), with nothing in `lib/`, `test/` or `docs/`. But 3 untracked files exist: the two roadmap files (5.2 MB HTML and 444 KB JSON, not ignored, stale at `0df5cf4`) and `.ai/audits/current/PRE_EXECUTION_DISCOVERY.md`, written by this workflow | `git status --porcelain` on 2026-10-09 | SOURCE |
| §12.4 The hooks are part of the working state | REFUTED (on this clone) | `.githooks/pre-commit` and `pre-push` exist but are inactive: `core.hooksPath` is unset, and the files are mode 100644, which git on macOS and Linux ignores. `pre-push` delegates to `tool/validate.sh`, which fails on Windows Git Bash (exit 123), and it skips contract-only and docs-only pushes | `git config --get-all core.hooksPath` (empty); `git ls-files -s .githooks`; `.githooks/pre-push:81`, `:93`; SCRATCH `validate_sh_format_repro.log` | SOURCE + BUILD |
| §12.5 2067 tests pass | VERIFIED | 2067/0/0 both in the working tree (3.38 files) and in a 3.45 clone (BUILD, 2026-10-08). There is also a `validate.ps1` record at `8e641e9` (2026-10-06 11:25Z), kept outside git. CLAUDE.md's floor of 849 is stale. CI last ran at `c87b90a` (green) and has never seen the 3.38 files | SCRATCH logs; cor_git §8; `gh run list` | BUILD + ARTEFACT + CI |

### 4.x Detailed contract-side verification table
### Backend handoff verification table

Verdicts:

- **MATCH:** the contract says the same.
- **MISMATCH:** the contract says something different.
- **PARTIAL:** true but incomplete or imprecise.
- **ABSENT:** the contract is silent; this is an app-side or ops rule.
- **STALE:** true earlier, superseded now.

| # | Handoff claim | Contract says (quote) | Verdict | Citation |
|---|---|---|---|---|
| 4.1 | Support photos: JPEG, PNG, WebP; PDF not supported | `contentType … enum: [image/jpeg, image/png, image/webp]` | MATCH | `OA:4032` |
| 4.2 | Max 7 MB per photo = 7,000,000 bytes | "`sizeBytes` … maximum: 7000000 … Above 7,000,000 is `413 image_too_large`" | MATCH (decimal bytes, not MiB) | `OA:4033`, `EC:61` |
| 4.3 | Max 3 photos per message | "`attachmentIds` (at most 3, no repeats)" | MATCH | `OA:2667`, `OA:2809`, `OA:3990` |
| 4.4 | Max 10 photos per ticket | "the photos would take the ticket over 10" → `409 attachment_limit_reached` | MATCH | `OA:2697`, `OA:2840` |
| 4.5 | (not in handoff) unattached cap | "at most 10 photos that are not yet attached … deleted 24 hours after this call" | handoff OMITS | `OA:2862-2863`, `OA:2885` |
| 4.6 | Every photo automatically safety-checked; unsafe photo refused | "checks the photo with Google SafeSearch … A refused photo is gone" | MATCH | `OA:2904-2912`, `EC:16` |
| 4.7 | Copy "This photo can't be sent" | "`image_rejected_by_moderation` — … show \"this photo can't be sent\"" (English guidance only; ASCII apostrophe U+0027; no Arabic given) | MATCH (EN); AR ABSENT | `OA:2934`, `EC:16` |
| 4.8 | Staff replies never contain photos | "always empty on a staff reply" | MATCH | `OA:3980` |
| 4.9 | Voice notes are future | Support: no mention of voice. Chat: "No photo, voice, group chat" | ABSENT for support (product statement) | `OA:149`, `RT:17` |
| 4.10 | Avatar: JPEG, PNG, WebP | "JPEG, PNG or WebP" | MATCH | `OA:987` |
| 4.11 | Avatar: max 2 MB | "at most 2,097,152 bytes (2 MiB)"; 413 "over 2,097,152 bytes" | PARTIAL: the contract cap is **2,097,152 bytes (2 MiB), not 2,000,000**. A client pre-check must use 2,097,152; "2 MB" in UI copy is a rounding. Unchanged at 3.46 (`CL46:11` "Avatars are at most 2 MiB") | `OA:987`, `OA:1006`, `OA:1028`, `EC:61` |
| 4.12 | Avatar: same safety check | "runs a safety check … `image_rejected_by_moderation` — show \"this photo can't be used\"" | MATCH, but the avatar copy is "**can't be used**", not "can't be sent" | `OA:993-995`, `OA:1031` |
| 4.13 | If rejected, the default avatar remains | "nothing is stored and **the previous avatar stays**" / "the avatar is unchanged" | PARTIAL: the previous avatar stays, which may be an earlier **custom** photo, not necessarily the default | `OA:995`, `OA:1031` |
| 4.14 | Student can replace and remove the avatar | PUT: "the previous custom photo is deleted"; DELETE `removeCustomAvatar` → back to the chosen default; PATCH `avatarId` "REPLACES an active custom avatar" | MATCH in shape. **Both PUT and DELETE are `stable` since 3.46.0-m1 (eddb6ac)**; they were `draft` at 3.42–3.45 and are absent/old-draft in the 3.38 re-vendor (65245be) | `OA:981`, `OA:996-997`, `OA:1041-1047`, `OA:951-952`, `CL46:7-18` |
| 4.15 | (not in handoff) avatar dimensions/limits | 128–4,096 px a side, ≤16,000,000 px, not animated, square, upright; 5 uploads/h; 3 refusals/h lockout; 403 `terms_acceptance_required` | handoff OMITS | `OA:987-990`, `OA:1025`, `OA:1034` |
| 4.16 | "Exact upload endpoints, request shapes and error codes will come from the next contract version" | `createSupportAttachmentUpload` / `completeSupportAttachment` / `getMySupportAttachmentContent` / `uploadCustomAvatar` (finalised) / `removeCustomAvatar`, plus 7 error codes, were published in **3.42.0-m1** as draft and are **`stable` since 3.46.0-m1 (eddb6ac)** | STALE: they are already in the contract, and stable upstream; they are not in the 3.38 re-vendor (65245be) | `CL:71-84`, `OA:2845-2982`, `OA:978-1059`, `CL46:7-18` |
| 4.17 | Old Figma wording "PNG/JPG/PDF up to 10MB" (support) | contract: no PDF (`OA:4032`), cap 7,000,000 bytes (`OA:4033`), WebP accepted | MISMATCH (Figma vs contract). The contract wins; the Figma text needs replacing (designer). The Figma wording is not recorded anywhere in the repo (grep `10 ?MB\|PNG/JPG\|PDF up to` → no design hit), so it is DOC-unverified | `OA:4032-4033` |
| 6.1 | Exactly 8 localization keys (EN/AR listed) | the same 8 keys and strings | MATCH on the 8 keys; the contract strings compare ALL IDENTICAL to the transcribed handoff strings (re-run by verifier and corrector, also against 3.46). The transcription itself is UNVERIFIED (see "The eight strings") | `RT:97-104` |
| 6.2 | Old `enrolment_opened` keys no longer sent; may remain in the app | "Nothing else is ever pushed — not `enrolment_opened`, not `announcement`". `enrolment_opened` remains a valid **inbox** kind | MATCH for push. App: no `enrolment_opened` or `push_*` strings exist in `lib/` or `android/app/src` (SOURCE), and no mirrored contract ever defined `enrolment_opened` push keys (`git log -S enrolment_opened -- realtime.md` → first at cadba7b, in the "never pushed" sentence) | `RT:82`, `OA:1211` |
| 6.3 | Payload always has `kind` in the 4 values | "Exactly four kinds push"; "`data` holds `kind` … and opaque ids only, all string values" | MATCH | `RT:82`, `RT:84` |
| 6.4 | support → `ticketId`; friend → `friendRequestId`; academic year → nothing else; chat → `conversationId` | table `RT:88-91` | MATCH | `RT:86-91` |
| 6.5 | Unknown kind: open the notifications screen, ignore the kind | "An unknown `kind`: open the notifications screen and ignore the rest." | MATCH. This **is** in the contract, not an app-only rule | `RT:106` |
| 6.6 | Privacy: no names, phone numbers or message text; chat pushes have no sender name or text | "no title or body text, no name, no message text and no ticket subject"; "Any other key is never sent" | MATCH. Phone numbers are covered implicitly by "opaque ids only" | `RT:83-84`, `RT:76` |
| 6.7 | Request notification permission on iOS and Android 13+ | — | ABSENT (platform/app rule). App: no `POST_NOTIFICATIONS` (`AndroidManifest.xml:19` is the only permission); no iOS push entitlement or `UIBackgroundModes` (SOURCE). Store-policy guidance in the repo says request it "in the correct context, not at launch" (DOC, `.ai/audits/current/store_readiness_parts/14_declarations_permissions.md:165`) | — |
| 6.8 | Send FCM token to `PUT /api/v1/me/fcm-token` after sign-in and on every new token | "registers its FCM token after sign-in and on every token refresh … one token per student, the latest wins" | MATCH | `RT:108`, `OA:1060-1082` |
| 6.9 | Staging `com.levelupworld.app.stg` uses the staging Firebase project; production uses the production one | — | ABSENT from the contract. DOC: Q7 said project sharing "not finalised" (`docs/ENVIRONMENTS.md:346`); the handoff now states two projects | — |
| 6.10 | Tapping a notification while closed/backgrounded opens the correct screen | per-kind targets: ticket / friend-requests list / notifications screen / conversation | MATCH (targets), but the open/closed/background lifecycle is not described. DOC: "no deep links in release 1" (`docs/DECISIONS.md:1060`) is most plausibly about URL entry points, not FCM-payload routing (INFERRED; owner to confirm) | `RT:106` |
| 6.11 | (not in handoff) push is OFF everywhere | "Delivery is off in every environment until the staging verification is recorded" | handoff OMITS; still true at 3.46 | `RT:80`, `CL:34`, `CL:59` |
| 6.12 | (not in handoff) text follows the phone language | "the text follows the phone's language, not the in-app language switch" | handoff OMITS: the strings must be native resources | `RT:83` |
| 6.13 | (not in handoff) logout / token removal | "No `DELETE`/unregister …"; `logout` says nothing about the token | handoff OMITS: UNKNOWN server behaviour on logout | `CL:319`, `OA:451-461` |
| 5 | App IDs requested: Android application ID, iOS bundle ID | — (the contract carries no app ids) | ABSENT. Answerable from the repo: D-021 ratified `com.levelupworld.app` / `com.levelupworld.app.stg` for both platforms (DOC `docs/ENVIRONMENTS.md:349-350`). Android implemented (`build.gradle.kts:55`, `:76`); iOS `pbxproj` still `com.levelup.levelUpApp` (`project.pbxproj:371`, `docs/ENVIRONMENTS.md:101`), so the iOS id given to Seif must be the ratified one, not the one currently in Xcode | — |
| 2 | Not previously backed: Chat photos / voice / groups | "No photo, voice, group chat or streaks" (chat tag); "Photo, voice and group chat are not part of it" | MATCH: still unbacked | `OA:143-150`, `RT:17` |
| 2 | Not previously backed: Notification Support tab | `category: support` + `kind: support_ticket_replied` (stable since 3.41) | Now **backed** at 3.41+ (not in the 3.38 re-vendor) | `OA:1186-1192`, `CL:87` |
| 2 | Not previously backed: Avatar upload | full shape since 3.42; `stable` since 3.46.0-m1 | defined and **buildable once a pin at or above 3.46 is vendored** (in 65245be it is the old "≤ 5 MB" draft) | `OA:978-1059`, `CL46:7-18` |
| 2 | Not previously backed: Settings preferences | "no notification preferences"; "no preferences or mute surface" | MATCH: still unbacked (S28) | `CL:319`, `CL:302` |
| 2 | Referral contradiction (Figma 500 to both vs backend 10 to inviter) | `MyInvite.pointsEarned`: "10 per credited friend"; "The new student earns no referral points" | contract = +10 inviter only. The Figma 500 is not in the contract. **Product decision; kept tracked, not chosen** | `OA:4204-4210`, `CL:44` |
| 8.1 | `transferToUniversity` draft vs stable-only | `x-stability: stable` | resolved upstream (stable since 3.39); draft only in the 3.38 re-vendor | `OA:1337`, `CL:111` |
| 8.2 | `Accept: application/json` | "Send `Accept: application/json` (or `application/problem+json`)"; a request "whose `Accept` excludes JSON" may get no body | still in the contract. App sends no `Accept` (`dio_client.dart:19`, SOURCE). The photo read needs a different, per-request `Accept: image/*, application/problem+json` (`OA:2953`). Whether an *absent* header ever yields a body-less error: UNKNOWN (absent ≠ "excludes JSON", INFERRED). **Already recorded** in the uncommitted `contract/SOURCE.md:52-55` with the same reasoning and an `[UNVERIFIED]`-on-the-wire tag (DOC, added in verification) | `OA:3884-3890` |
| 8.3 | Old comment in `error_interceptor.dart` | "Some failures carry no body, or a body without `code` … treat it like `internal_error`" | comment STALE: `error_interceptor.dart:9-10` says "Every non-2xx body is RFC 9457 ProblemDetails with a stable `code`". The code tolerates it (falls back to `code: 'unknown'`, `:27-29`) (SOURCE) | `OA:3884-3889` |
| 8.4 | S11 favourites still open | `addFavorite` / `removeFavorite` / `listFavorites` `stable` | resolved upstream (3.39); draft in the 3.38 re-vendor | `OA:2105`, `OA:2130`, `CL:112` |
| 8.5 | FriendScreen TODO may be stale | friend graph stable since 3.37 | TODO still present (`friends_screen.dart:9-13`, S36 "the contract has nothing behind it"): STALE on the endpoint half; entry point is still a design question | ops_table |
| 8.6 | S24 answered by GET `/me/quiz-summary` | `getMyQuizSummary`: "The Profile 'Solved Questions' number — distinct questions the caller has ever answered correctly", stable | MATCH | `OA:1727-1745` |
| 8.7 | Contract line references shifted | e.g. `docs/ENVIRONMENTS.md:342` cites `openapi.yaml:896-900` for fcm-token: correct at 0df5cf4 (`:896`), `:943` at 65245be, `:1060` at 2e5bb69 (unchanged at eddb6ac) | MATCH | grep at three pins |

**Push string comparison (character by character).**

- **Method:** the 16 handoff strings were transcribed from the handoff text into `SCRATCH/compare_push.py` (and again into `SCRATCH/aud/push_cmp.py`) and compared by exact codepoints with `RT:97-104`.
- **Command:** `python -I -X utf8 compare_push.py upstream-contract/realtime.md`; the corrector re-ran it against the 3.46 `realtime.md`.
- **Output:** `ALL IDENTICAL`. EN codepoint lengths 15/44/14/30/17/59/11/23; AR 13/29/9/20/14/40/11/17.
- **Punctuation:** the Arabic sentences end in the ASCII full stop U+002E in both sources.
- **Hidden characters:** no bidi/control characters in the contract text.
- **Key set:** the contract has no key the handoff lacks.
- **Limit:** the contract half is re-verified; the handoff half rests on the transcription (UNVERIFIED, see above).

| Key | Handoff EN | `RT` EN | Handoff AR | `RT` AR | Result |
|---|---|---|---|---|---|
| `push_support_ticket_replied_title` | Support replied | Support replied | رد فريق الدعم | رد فريق الدعم | identical |
| `push_support_ticket_replied_body` | You have a new reply on your support ticket. | (same) | لديك رد جديد على تذكرة الدعم. | (same) | identical |
| `push_friend_request_received_title` | Friend request | (same) | طلب صداقة | (same) | identical |
| `push_friend_request_received_body` | You have a new friend request. | (same) | لديك طلب صداقة جديد. | (same) | identical |
| `push_academic_year_opened_title` | New academic year | (same) | عام دراسي جديد | (same) | identical |
| `push_academic_year_opened_body` | A new academic year has started. Open the app to get ready. | (same) | بدأ عام دراسي جديد. افتح التطبيق واستعد. | (same) | identical |
| `push_chat_message_received_title` | New message | (same) | رسالة جديدة | (same) | identical |
| `push_chat_message_received_body` | You have a new message. | (same) | لديك رسالة جديدة. | (same) | identical |

**Handoff rules that are app-side, not contract:**

- the OS notification permission prompt (iOS, Android 13+);
- Firebase project per environment;
- app IDs;
- "default avatar remains", which is imprecise: the contract says "previous avatar stays".

**Handoff rules that turned out to BE in the contract:**

- "unknown kind → notifications screen" (`RT:106`);
- the "this photo can't be sent" copy, English only (`OA:2934`).

**Contract rules the handoff omits:**

- push is off everywhere;
- push text follows the phone's language;
- no token unregister;
- the 10-unattached / 24 h rules;
- avatar pixel limits and rate limits;
- the Terms gate on every photo path;
- per-request `Accept` and binary response for photo reads;
- the presigned-PUT exact-header rule;
- `account_banned`;
- `moderation_warning` copy.



## 5. Feature inventory

**Basis.** This section combines `cor_features_learning`, `cor_features_account`, `cor_features_social`, `cor_api_census`, `cor_design` and `cor_env_push_impl`. Each cell was re-checked read-only against the repo at `merged@8e641e9` and against the contract at upstream `eddb6ac` (3.46.0-m1). The repo was not modified. The only new files are scratch helpers: `consol_census346.py` and an LF copy `consol_eddb6ac_lf.yaml`.

**Line references.** `@346:N` means line N of `openapi.yaml` at `eddb6ac`. The diff from 2e5bb69 (BUILD, `diff`) is only `info.version` plus the five `x-stability` lines (981, 1041, 2848, 2899, 2945). Every `@2e5bb69` line cited in the source sections therefore still resolves at 3.46.

**Stability triple.** Each triple reads committed `0df5cf4` (3.28) / working-tree `65245be` (3.38) / upstream `eddb6ac` (3.46). S = stable, D = draft, – = absent.

**Path shorthand.** Code paths are relative to `lib/features/`; `router` means `lib/core/router/app_router.dart`, and DI #n is a `docs/DESIGN_ISSUES.md` entry.

**Device column.**
- "Wn x% (mock)": the owner's wave walk on the physical Pixel 8 against the mock backend (DOC `wave_state.md`).
- "STG-AVD": the 2026-10-06 staging release-build walk on the Pixel_8 **AVD emulator** (DOC reconciliation §15.2).
- "STG-P8": the physical Pixel 8 debug re-walk against staging (§15.1).

No new DEVICE evidence was produced for this section, and no iOS device or Mac is known to be available.

**Census at 3.46** (BUILD, PyYAML on `eddb6ac`):
- 86 operations, all 86 stable, 0 draft, and 4 web-only (`requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `redeemSubscriptionCode`, `listTerms`). That leaves **82 app-buildable**.
- Of the 82: **25 implemented** (24 with a screen, plus `refreshTokens`), **1 data-layer-only** (`getMyEntitlements`) and **56 not integrated**.
- All 26 operations the app consumes are stable at all three pins.

Re-check the pin with `git ls-remote` at workflow start: upstream moved 8 versions in about 28 hours.

**"Independently implementable" means:** contract-backed at a stated pin, a frame exists or none is needed, and no open owner decision blocks it. The committed pin is 3.28, so anything stable only at a later version waits for the pin decision (roadmap DR-23, untracked roadmap, DOC).

#### 5.1 Master feature table

| # | Area | Status category | Route(s) | Flutter code (key files) | Contract ops (3.28 / 3.38 / 3.46) | Design (Figma / DI) | Device acceptance | Blockers | Independently implementable? | Product decision missing? |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Authentication / login | implemented (gaps: placeholder legal URLs, no lost-phone entry) | `/login` (router:121) | `auth/screens/login_screen.dart`, `auth/notifier/login_notifier.dart:14-36`, `auth/repository/auth_repository.dart:29` | requestOtp S/S/S; refreshTokens S/S/S | Login `82:819`, dark `337:15652`, consent `82:1086`; DI #8, #9 | W01 100% (mock); STG-AVD OTP request | Login links open `https://levelup.example/...` (`login_screen.dart:43-48,122-124`) | Yes (done) | Legal-link target (DR-14); lost-phone entry (row 38) |
| 2 | OTP | implemented; lockout, ban and pending-deletion all show the generic line | `/login/otp` (router:125) | `auth/screens/otp_screen.dart`, `otp_notifier.dart:69-220`, `auth_error_copy.dart:10-25` | verifyOtp S/S/S (`403 account_banned` only from 3.42, @346:231); `429 otp_throttled` S/S/S (@346:200,234) | `82:1171`, error `82:1170`, success `155:786`, dark `337:19271`; one error line (DI #49, `DESIGN_ISSUES.md:1503`) | W02 100% (mock); STG-AVD verify | `account_banned` unmapped; no `Retry-After` documented on `otp_throttled` | Yes for the mapping | Ban copy/screen; lockout presentation |
| 3 | Registration | implemented; `inviteCode` collected but not sent; no Terms step | `/register`, `/register/track`, `/register/school`, `/register/university` (router:142-160; pre-auth :57) | `registration/screens/*`, `registration_submit_notifier.dart:48-130`, `registration_repository.dart:37`, `reference_repository.dart` | completeRegistration S/S/S; 6 reference reads S/S/S; `inviteCode`/`inviteCodeApplied` –/–/S (3.44; @346:4087,4144,4179) | School `125:511`/dark `337:5269`; Uni `125:2336`/dark `337:10373`; invitation field `337:15875`; DI #2, #3, #7, #90 | **W03 school NOT walked** (`wave_state.md:22-24`); W04 uni 100% (mock) | `UniversityRegistration.inviteCode` prose still says "draft" at 3.46 (@346:4182) | Partly (`inviteCode` needs pin ≥3.44 plus Seif's clarification) | Referral reward; where Terms is asked |
| 4 | Onboarding | implemented | `/` (router:114) | `onboarding/screens/onboarding_screen.dart:11-45` | none | dark `337:15146`, illustration `337:15166` (`day00_onboarding_brief.md:12`) | Not one of the 22 waves; elevation pass only (`DEVICE_VERIFICATION_2026-09-19.md:43-44`) | none | n/a | No |
| 5 | Profile | implemented hub; Favorites and Progress rows disabled; Refer, Support and legal rows lead to shells | `/account` (router:325), `/profile` (:396) | `profile/screens/profile_screen.dart:52-95,218-327`, `me_notifier.dart:39` | getMyProfile S/S/S | `166:4416`/`309:7940`, dark `337:7433`/`349:12919`, RTL `549:21052`/`549:26384`; DI #101-#103 | W19 100% (mock); STG-P8 FE-02 rows | Solved Questions and Rank tiles omitted (`profile_screen.dart:38-45`) | Yes | Reopen #101 "Points only" now that Solved Questions has a source |
| 6 | Edit profile | implemented | `/profile/edit` (router:401) | `edit_profile_screen.dart:33-62`, `edit_profile_notifier.dart:52` | updateMyProfile S/S/S | `176:1201`/`180:6349`, dark `337:7795`/`349:12688`, RTL `549:21413`/`549:26807`; DI #105 | W20 100% (mock); STG-AVD offline banner | — | Yes | No |
| 7 | Avatar: default + custom upload/remove | default **implemented**; custom: **stub (dimmed row)** + **contract exists, not integrated** (stable only at 3.46) | sheet from `/profile/edit` | `profile/widgets/avatar_sheets.dart:15-30,130-231` (Upload row :196-207) | listDefaultAvatars S/S/S; **uploadCustomAvatar D/D/S** (@346:981-982); **removeCustomAvatar –/–/S** (@346:1041-1042) | sheet `216:3341` (2 rows only), `216:3158`, picker `180:3989`/`180:4153`; DI #106 | W20 100% for the default path (mock) | Pin 3.46. `403 terms_acceptance_required` (@346:1025). No `image_picker` dependency or photo permission. Frame has no crop, remove, rejected or rate-limit states, yet the contract needs an upright square (@346:988-990). Picking a default deletes the custom photo. Avatars are public on the CDN (@346:986) | No (pin + Terms gate + frames + dependency) | Photo Picker only vs camera (domain rule 9); publicly visible avatars for minors (DR-08); where the Terms gate sits |
| 8 | Settings (preferences) | partially implemented | `/settings` (router:407) | `settings/screens/settings_screen.dart:44-85,129-250,272-421` | updateMyProfile S/S/S (2 privacy booleans); **no preference operation at any pin** | `176:1840` (= `309:8452`), dark `337:8141`, AR `549:21759`, prefs card `176:2394`; DI #45, #46, #48, #107-#111 | W21 100% (mock) | Third theme blocked (#45/S26); 4 notification toggles have no backend; BUG-017 wording | Partly (Languages, 2 Mode options and Rank are done) | Hide the inert toggles (DR-05, O-6); BUG-017 copy (DR-09) |
| 9 | Rank (`getMyRank`) | backend exists, UI missing (by decision D-008) | none | none (`leaderboard/repository/leaderboard_repository.dart:11-15`) | getMyRank S/S/S (@346:2579) | Profile Rank "HERO" tile in `166:4416` (DI #101); no self row in `133:3117` | none | D-008 stands; "HERO" tier has no source (S25) | Technically yes | Reopen D-008: the contract calls it the optional read below the 200 bound (@346:2513-2518) |
| 10 | Leaderboard | implemented | `/leaderboard` (router:189) | `leaderboard/screens/leaderboard_screen.dart`, `leaderboard_notifier.dart:117`, `leaderboard_repository.dart:39-51` | getLeaderboard S/S/S | `133:3117`, `134:3626`, dark `337:5528`; DI #92, #93 | W06 100% (mock); STG-AVD one-row board; STG-P8 FE-07 | No wire/decode test | Yes | Showing peers' names and avatars (H-1, DR-04) |
| 11 | Home | implemented, with 3 coming-soon sections, a static banner and an inert bell | `/home` (router:175) | `home/screens/home_screen.dart`, `widgets/home_header.dart:14-36`, `level_card.dart:23-40`, `top_student_section.dart`, `coming_soon_section.dart:76-81` | getMyProfile, getLeaderboard S/S/S; 3 inbox ops S/S/S **not called**; listQuizHistory D/D/S not called | `59:1439`/`125:2373`, Continue Learning `308:4186`, Daily Tasks `337:5353`; DI #1, #13, #20, #41, #79 | W05 100% (mock); STG-AVD Home; STG-P8 FE-08 | Daily Tasks, Learning Tools and Continue Learning have no matching operation shape; level bar target is client-derived (`kPointsPerLevel = 500`) | Bell yes, after the inbox ruling | Bell destination (D2/DR-01); the client level constant vs "server is authoritative" |
| 12 | Learn / catalog (subjects, units, chapters, lessons) | implemented | `/learn`, `/learn/subject/:subjectId` (+ unit, chapter) (router:205,258-274) | `catalog/screens/*`, `subjects_notifier.dart`, `subject_tree_notifier.dart`, `catalog_repository.dart:24-70` | listSubjects, getSubjectTree S/S/S | Subjects `337:5702`/`134:3837`, Chapters `135:1270`/`337:6047`, Lessons `135:1485`/`337:6143`; DI #16-#19, #80, #94, #100 | W07-W10 100% (mock); STG-AVD catalogue (school only) | — | Yes | No |
| 13 | Lectures (university) | implemented | `/learn/subject/:subjectId` (track discriminator) | `catalog/screens/lectures_screen.dart:87-95,198-231`, `widgets/quiz_type_tabs.dart` | getSubjectTree (university arm) S/S/S | `180:5208`/`349:15962`; DI #94 | W08 100% (mock); **never run on staging** (no university seed, R-8) | University staging seed (S37 ask 2 / R-8) | Yes | No |
| 14 | Modules (`listModules`) | contract exists, not integrated; no design found | none | none (`Subject.termId` parsed, never rendered) | listModules D/S/S (@346:1685) | none found (`endpoint_ui_mapping.md:131`) | none | No frame; the contract requires an "All subjects" view | No (design) | Yes: whether to group by module |
| 15 | Quiz: setup, question, result, review, explanation | implemented (Bloc); review is session-only | `/quiz/setup` (router:337), `/quiz/:quizId` (:346), `/result` (:362), `/result/review` (:377) | `quiz/screens/quiz_setup_screen.dart`, `quiz_screen.dart`, `bloc/quiz_bloc.dart`, `widgets/ai_explanation_panel.dart`, `quiz_result_screen.dart`, `quiz_review_screen.dart`, `quiz_repository.dart:46-152` | createQuiz, submitAnswer, finishQuiz, getExplanation S/S/S; getQuizReview D/D/S (not called) | setup `135:1622`/`337:6239`; question `159:845`, AI `159:1695`; result `159:1964`/`309:6375`; review `162:2377`/`337:6705`/`549:20324`; DI #50, #95-#97 | W11-W14 100% (mock); STG-AVD real 10-question loop (explanation 202→200 never observed) | Quiz screen has no offline banner; `questions: []` would throw (`quiz_state.dart:53`) once retakeWrong or favorites is sent | Yes | Cold re-open via getQuizReview; entry point for forwarding a question |
| 16 | Quiz history | contract exists, not integrated; design missing | none | none (mock serves only POST `/quizzes`, `mock_backend.dart:431`) | listQuizHistory D/D/S (@346:1877) | No list frame; lead only: Home Continue Learning (`endpoint_ui_mapping.md:130`) | none | No frame; `QuizHistoryItem` cannot fill Continue Learning as drawn | No (design) | Yes: where history lives |
| 17 | Favorites | UI exists but inert (Profile row) + contract exists, not integrated | Profile row only | `profile_screen.dart:240-248`; `isFavorite` parsed (`quiz/models/quiz_question.dart:47-54`) | addFavorite, removeFavorite, listFavorites D/D/S (@346:2106-2131); createQuiz `mode: favorites` | bookmark `295:3139`; Profile row `295:3144`; no list frame | none | No list frame; `questions: []` guard | Partly (the star has a frame, the list does not) | Yes: favorites list and favorites quiz in release 1 |
| 18 | Flashcards | implemented (university) | `/learn/subject/:subjectId/lecture/:lectureId/flashcards` (+ `/study`) (router:290-303) | `flashcards/screens/flashcard_setup_screen.dart`, `flashcard_study_screen.dart`, `lecture_flashcards_notifier.dart`, `flashcards_repository.dart:67-111` | getFlashcardsForLecture, setFlashcardSelfGrade S/S/S | `1234:8797`, `225:5582`, dark `337:14475`, AR `549:28041`; DI #114, #119, #126 | W22 92% → 100% (mock); never run on staging | "Preview used up" state not drawn (#119) | Yes | No (AR copy provisional, #114) |
| 19 | Mistakes (+ retakeWrong) | implemented, read-only; replay quiz: design exists, impl missing (out of scope by owner ruling 2026-09-12) | `/learn/mistakes` (+ subject, unit, chapter) (router:221-247) | `mistakes/screens/*`, `mistakes_notifiers.dart`, `mistakes_repository.dart:50-84` | getMyMistakes, getMyMistakesForSubject S/S/S; createQuiz `mode: retakeWrong` S/S/S (@346:1783-1813) | `404:6292`, `404:6539`, `404:6677`, `404:6762`, dark `404:7428`; replay `404:6853`/`404:7234`; DI #60-#64, #99 | W15-W18 100% (mock); never run on staging (S44) | `questions: []` crash path; S43 count semantics | Partly | DR-19: replay in release 1 |
| 20 | Progress (`getMyQuizSummary`) | Solved Questions tile: contract exists, not integrated. "Your progress" screen: design exists, backend missing | none | `profile_screen.dart:38-41,250-260` | getMyQuizSummary –/S/S (@346:1731); no time-series operation | `309:9671`, `334:3453`, `310:10166`, `334:3622`; tile in `166:4416` | none | Screen has no backend (chart, study time, %); the tile is held only by the #101 ruling | Tile yes (pin ≥3.38); screen no | Reopen #101; drop or defer the progress screen (S32) |
| 21 | Streak: personal vs friend | personal: design exists, backend missing; friend: contract exists, not integrated | none | none (no streak code in `lib/`) | personal: **none at any pin**; listMyFriendStreaks –/–/S (@346:3825); hub event `friendStreakChanged` | friend flame `661:8319`/`649:8889` in `162:2797`; personal "12 days Streak" `308:4203`; "Daily Streak" inbox sample `180:8786` | none | Friend flame needs the chat list; personal streak has no backend | No | Yes: drop the personal-streak art; flame semantics |
| 22 | Referral (`getMyInvite` + `inviteCode`) | stub (Share disabled) + contract exists, not integrated; design conflicts with the contract | `/refer` (router:415) | `account_shells/screens/refer_a_friend_screen.dart:9-52`; code collected and dropped (`signup_identity_screen.dart:86-94`) | getMyInvite –/–/S (@346:1434); `inviteCode` –/–/S | `176:2425` (uni `309:8565`), reward text `178:2646`; Profile row `170:4777`; DI #7 | STG-P8 FE-04/FE-05 (disabled-CTA semantics only) | Reward conflict; no share package; university `inviteCode` prose (@346:4182) | Data layer yes (pin ≥3.44) | Yes: reward copy; share mechanism |
| 23 | Friends: graph, requests, suggestions, phone lookup | stub with no entry point + contract exists, not integrated | `/friends` (router:423; nothing navigates to it) | `account_shells/screens/friends_screen.dart:7-43` | 9 operations –/S/S (@346:2987-3250) | `216:3784`/`309:6906`; carousel in `162:2797` | none | No entry point (S36). Frame shows phone digits the contract forbids (@346:4665-4669). No Decline or "my friends" frame | Data layer yes (pin ≥3.38) | Yes: entry point, phone mask, Decline |
| 24 | Blocked list (+ block, unblock, unfriend) | backend exists, UI missing | none | none | listMyBlocks, blockStudent, unblockStudent, removeFriend –/S/S (@346:3276,3311,3346,3022) | none found | none | No frame or entry point | Data layer yes; UI no | Yes |
| 25 | Chat (+ report message, report student) | backend exists, UI missing (`/message` placeholder) | `/message` (router:314) | `shell/screens/tab_placeholder.dart:54-61` | 6 core ops –/D/S (@346:3370-3592); reportChatMessage, reportStudent –/D/S (@346:3630,3667) | `162:2797`, threads `166:3156`/`215:2628` (+ university twins); no report or block frame | none | SignalR client; UUID source; text-only contract vs Figma photos and voice | No | Yes: Message tab = chat or inbox (DR-01); report affordance |
| 26 | Forwarded questions | backend exists, UI missing | none | none (no `forward` in `quiz/`) | forwardQuestion, answerForwardedQuestion –/–/S (@346:3699,3766) | indirect: "Tap to see question" `171:5013`, "Send to" `171:5031` (inference) | none | Needs chat; entry point on the question or review screen; answers spend the 50/week allowance | No | Yes |
| 27 | Friend streaks | contract exists, not integrated | none | none | listMyFriendStreaks –/–/S; `streaks` hub folded into `chat` (`realtime.md@346:10`) | flame `661:8319` | none | Needs chat; advances only through forwarded-question answers | No | Yes: meaning of `stepTakenToday=false` |
| 28 | Chat realtime hub | not integrated | n/a | none; no SignalR or WebSocket dependency (`pubspec.yaml:30-65`) | `chat` hub: not drafted / draft (3.31) / **stable** (3.39) (`realtime.md@346:11`) | n/a | none (RUNTIME: staging `/hubs/chat` answers 401) | WebSockets only, `skipNegotiation`, token in the URL query (logging privacy); superseded session must reach `forceLogout` | No (package spike) | Partly: client dependency choice |
| 29 | Support tickets (+ photos) | stub (Create disabled) + contract exists, not integrated | `/support` (router:417) | `account_shells/screens/customer_support_screen.dart:17-43` | 5 ticket ops D/D/S (@346:2658-2801); **3 photo ops –/–/S** (3.46; @346:2849,2900,2946) | `178:2800`, `178:3222`, `178:3378` (+ `178:3518`, `296:3154`, university twins) | none | Figma says "PNG, JPG, or PDF up to 10MB" (`178:3368`); "resolved" is not a contract status; voice mic; Terms gate for photos; SHA-256 and picker dependencies | Text: yes (pin ≥3.39). Photos: pin 3.46 + Terms + dependencies | Yes: release-1 scope (DR-25); Photo Picker only |
| 30 | Notifications inbox (+ Support tab) | contract exists, not integrated; design exists | none (bell inert; `/message` placeholder) | `home/widgets/home_header.dart:14-36` (`hasUnreadNotifications` hard `false`, :36) | listMyNotifications, getUnreadNotificationCount, markNotificationRead S/S/S (@346:1148,1227,1246); `category=support` S/S/S; kind `support_ticket_replied` –/–/S | `180:8386`/`309:9525`, Support chip `180:8726-8730`; DI #41 | none | Entry point (D2/DR-01); Promotions chip, "Premium Offer" and "Daily Streak" rows conflict | Mostly yes (pin 3.28 suffices for a minimal list) | Yes |
| 31 | Push notifications | not integrated (absent end to end) | none | none; no Firebase dependency; no `POST_NOTIFICATIONS` (`android/app/src/main/AndroidManifest.xml:19`) | registerFcmToken S/S/S (@346:1064); push shape only in `realtime.md` ≥3.43 (`realtime.md@346:78-108`); delivery off | none (system UI) | none | Firebase ownership and the R-9 gate (`RISKS.md:137`); native localized strings; destination screens unbuilt; router has no return-to | No | Yes (DR-11, DR-18) |
| 32 | Subscription (status screen) | not built by decision (purchase-silent); data layer only | none (`/subscription` removed, router:484-487) | `lib/features/subscription/` = `.gitkeep` only; `profile/notifier/me_notifier.dart:78-101` (never watched) | getMyEntitlements S/S/S (@346:1409); 4 redemption ops web-only | No status frame. Profile "Upgrade to premium" `170:4890`; limit frames with CTA (DI #51) | none | adr-049 §3 (`contract-changelog.md@346:576`); R-10 OPEN | Status-only: data yes, design no | Yes: whether a status screen exists at all; any link is R-10 |
| 33 | Terms acceptance | contract exists, not integrated | none | none | getTermsAcceptance, acceptTerms S/S/S (@346:1087,1116) | none (only passive consent `82:1086`) | none | No frame. Contract says "recorded, not enforced" (@346:1122-1123), yet photo uploads return 403 (@346:1025,2672,2882) | No (design) | Yes: placement and gate behaviour |
| 34 | Legal documents (`getLegalDocument`, `/legal`, Login links) | stub shells + contract exists, not integrated | `/legal/privacy`, `/legal/terms` (router:427-435; signed-in only, :52-57,77) | `account_shells/screens/legal_document_screen.dart:34-55`; Login `levelup.example` links | getLegalDocument –/–/S (@346:816, public); staging serves `r4-2026-10-07` in ar and en (API probe, cor_store) | Profile rows `170:4901`/`170:4912`; no viewer frame; DI #9 | none | Markdown renderer dependency; un-gating `/legal/*` before sign-in; the Cookie link has no document (enum is terms/privacy) | Partly (shell chrome exists) | Yes: DR-14; the Cookie Policy link |
| 35 | Track transfer | stub dialog (Confirm hard-disabled) + contract exists, not integrated | dialog from Profile (deliberately no route, router:391-394) | `profile_screen.dart:307-353` | transferToUniversity –/D/S (@346:1338; body: universityId, facultyId, studyYearId, `acknowledgeIrreversible`) | `180:4301`, dark `337:7561`, RTL `549:21179`; row `170:4921` | W19 (dialog only, mock) | No frames for pickers, disclosure, success or errors; the row also shows to university students | No (design) | Yes: eligibility and disclosure copy; hide for University students |
| 36 | Account deletion | backend exists, UI missing | none | none | requestAccountDeletion S/S/S (@346:1267) | none (`wave_state.md:1607`; DI #62) | none | No frame; mandated copy says "paid" and "refund" (@346:1282-1286) | No | Yes: DR-03 / Q-B2; Play web-deletion leg (E-8) |
| 37 | Account cancellation (pending deletion) | backend exists, UI missing; partial plumbing | none | `lib/core/network/exceptions.dart:95-135`; `profile/models/student_profile.dart:77`; copy at 5 sites | cancelAccountDeletion S/S/S (@346:1315); client rule "route to the cancel screen" (@346:82-83) | none (DI #62) | none | No frame; router redirect | Partly (the 403 routing hook) | Yes: where a pending student lands |
| 38 | Lost-phone recovery | backend exists, UI missing | none | none | startRecovery, verifyParentOtp, submitNewPhone, confirmRecovery D/D/S (@346:466-594) | weak lead: OTP `82:1171` recovery copy | none | No flow frames; `parentPhone` is write-only (S34); designed to work with cancel-deletion (@346:72-79) | No | Yes |
| 39 | Another-device login (`session_superseded`) | implemented as forced logout + one-time Login message; implementation exists, design missing | `/login` | `lib/core/network/interceptors/auth_interceptor.dart:75-78,147-151`, `auth/notifier/auth_controller.dart:67-72`, `login_screen.dart:60-76` | `401 session_superseded` S/S/S (@346:58-60 says "show the forced-logout screen") | none (`day1b_forced_logout_brief.md:4-7`) | None recorded | Contract asks for a screen; the chat hub's abort must reach the same path | Yes (done) | Is a message acceptable instead of a screen? |
| 40 | Account banned | contract exists, not integrated (falls through to the generic error) | none | `auth_error_copy.dart:10-25` (no branch) | `403 account_banned` –/–/S (from 3.42; @346:231,371,542,625) | none | none | Changelog asks for a dedicated screen ("What to build", `contract-changelog.md@346:78`); a signed-out student has no Support channel | Mapping yes | Yes: copy; support contact |
| 41 | Logout | implemented | dialog from Profile | `profile_screen.dart:355-388`, `auth_controller.dart:76-85` | logout S/S/S (@346:455) | `180:4598` (+ 5 variants) | W19 100% (mock); STG-AVD sign-out → sign-in | — | Yes | No |
| 42 | Limit pop-ups | implemented | dialog over `/quiz/setup` and `/quiz/:quizId` | `quiz/widgets/limit_sheet.dart`, `quiz_error_copy.dart:44-60`; flashcards inline (`flashcards_error_copy.dart:45-51`) | `403 weekly_question_limit_reached`, `subscription_required`, `flashcard_subscription_required` S/S/S | `199:2335`, `225:6634`, `225:7001` (draw the forbidden CTA, #51); no dark frame (#74) | W11 100% (mock) | Dark scrim (#74, BLOCKED); provisional copy (D-007); `answerForwardedQuestion` needs a second caller | Yes | Copy (D-007); the "Subscribe" line (D-015) |
| 43 | Lockout pop-ups | not built (inline line only) | n/a | `auth_error_copy.dart:18-19`, `app_en.arb:117` | `429 otp_throttled` S/S/S (15-minute lock after 5 failed verifies, @346:200,234); also `rate_limited`, `forward_daily_limit_reached`, avatar refusals (@346:1034) | none | none | Lock duration source undocumented (`Retry-After` not on `otp_throttled`; Q-B5) | Partly | Yes: what "lockout" means; pop-up vs inline |
| 44 | Offline / loading / empty / error states | implemented per screen; no guard | all data screens | `lib/core/widgets/state_widget.dart`, `offline_banner.dart`, `lib/core/providers/core_providers.dart:55-60`, 6 error-copy files | n/a; `Accept: application/json` (@346:3883-3890) not sent (`lib/core/network/dio_client.dart:15-20`) | no frames (DI #76 at :3404-3405, #119, #60) | Scored per wave (mock); STG-AVD offline | Quiz screen has no offline banner; `StateWidget` English defaults; no mechanical guard | Yes | No (copy per new screen) |
| 45 | Environment / flavors | Android done (Env Wave 1); Dart Wave 2 not started | n/a | `android/app/build.gradle.kts:55,68-79,103-146`, `lib/core/config/app_config.dart:43-55`, `lib/main_*.dart` | `servers:` lists staging only at every pin (@346:107-108) | n/a | DEVICE: `.stg` installed on the Pixel 8, prod not installed; BUILD identity guard 9/9 | Prod URL `TBD.example`; `isDev` never read; the release-compile CI job is main-only and has never run against the flavored `ci.yml` | Yes (Wave 2) | Production host (Seif) |
| 46 | iOS identity | not applied (template id, target 13.0) | n/a | `ios/Runner.xcodeproj/project.pbxproj:371,550,572` (id), `:349,475,526` (13.0); `Info.plist` | n/a | n/a | No iOS device or Mac (UNKNOWN) | Mac (DR-26); APNs and Firebase; PrivacyInfo (R-11) | SOURCE-level only | Yes (DR-26, DR-18) |

#### 5.2 Backend-built / no-design matrix (brief section 5)

Columns: 1 Flutter implementation · 2 route · 3 Figma/design record · 4 contract support (3.28 / 3.38 / 3.46) · 5 blocked by design · 6 independently implementable · 7 product decision missing.

| Item | 1 Flutter impl | 2 Route | 3 Design record | 4 Contract | 5 Blocked by design? | 6 Independently implementable? | 7 Product decision missing? |
|---|---|---|---|---|---|---|---|
| Terms step | No (grep of `registration` for terms/agree/consent = 0) | none (`/legal/*` are signed-in shells) | Only passive consent `82:1086` on Login `82:819` (`endpoint_ui_mapping.md:127`) | getTermsAcceptance, acceptTerms S/S/S; getLegalDocument –/–/S | Yes for the acceptance step; no for a plain document viewer | Partly: viewer (needs a Markdown dependency). `acceptTerms` is authenticated, so acceptance can only follow the registration 201 or a sign-in | Yes: placement; whether the app gates (API: "recorded, not enforced", @346:1122-1123, except photo uploads); Cookie link; text ownership (S30); two contract contradictions to file with Seif |
| Track-transfer confirmation | Partial: dialog with Confirm hard-disabled (`profile_screen.dart:339-353`) | none (a dialog by design) | `180:4301` (+ dark `337:7561`, RTL `549:21179`); no picker, disclosure, success or error frames | transferToUniversity –/D/S (@346:1338) | Yes beyond the one dialog | No (design); the registration pickers could be reused | Yes: hide for University students (`error-codes.md` row 59); eligibility and disclosure copy |
| Account deletion | No | none | None (`wave_state.md:1607`; DI #62) | requestAccountDeletion S/S/S | Yes | No | Yes: "paid"/"refund" copy (DR-03 / Q-B2, never filed in `seif_fight.md`); Play web leg (E-8). On success the client must purge the token pair (@346:1276-1279) |
| Account cancellation | No; plumbing only (`isAccountPendingDeletion`, `exceptions.dart:134`; copy at 5 sites; Retry withheld) | none | None (DI #62) | cancelAccountDeletion S/S/S; client rule @346:82-83 | Yes (screen) | Partly (403 routing hook and guard) | Yes: where a pending student lands; coupling with recovery (@346:72-79) |
| Lost-phone recovery screens | No | none | Weak lead only (OTP `82:1171` copy) | 4 ops D/D/S | Yes | No | Yes: Login entry; support path for `recovery_unavailable`; S34 (`parentPhone` write-only) |
| "Logged in on another device" | Yes, as forced logout + one-time message (`login_screen.dart:60-76`; tests `login_logout_message_test.dart:57`) | `/login` | None ("infrastructure, not a designed screen") | `401 session_superseded` S/S/S; contract text says "forced-logout screen" (@346:58-60) | Only for a dedicated screen | Yes (behaviour done) | Is the message acceptable for release? |
| Chat report | No | none | None found (13 nodes read; repo grep) | reportChatMessage, reportStudent –/D/S (@346:3630,3667); recipient only, no reasons; forwarded cards cannot be reported | Yes | No (needs the chat thread first) | Yes: entry point; combined "report and block" (contract: report before block) |
| Chat block | No | none | None found | blockStudent –/S/S (@346:3311): always 204, removes the friendship, not notified | Yes | Data layer yes; UI no | Yes: confirm copy (blocking deletes the conversation) |
| Chat unfriend | No | none | None found | removeFriend –/S/S (@346:3022): idempotent 204, not notified | Yes | Data layer yes; UI no | Yes: confirm copy |
| Blocked list | No | none | None found | listMyBlocks + unblockStudent –/S/S | Yes (no frame, no entry) | Data layer yes; UI no | Yes: Settings or Profile |
| Limit pop-ups | Yes (`LimitSheet`; flashcards inline) | dialog | Light frames `199:2335`, `225:6634`, `225:7001` with the forbidden CTA; no dark frame (#51, #74) | 403 codes S/S/S | Dark scrim only | Yes (built; W11 100%) | Copy is provisional (D-007); "Subscribe" line (D-015) |
| Lockout pop-ups | No pop-up; inline `errorOtpThrottled` | n/a | None (one OTP error line, `DESIGN_ISSUES.md:1503`) | `429 otp_throttled` S/S/S (15-minute lock, @346:200) | Yes for a pop-up | Partly (copy and no-hammer behaviour; countdown needs a duration source) | Yes: what "lockout" means (the Day 1 brief uses it for `otp_throttled`, `day1_login_otp_brief.md:105`); pop-up vs inline; Q-B5 |
| Empty states | Per feature where a list exists (`noSubjects`, `noMistakes`, `leaderboardEmpty`, …) | n/a | No frames (DI #60, #76, #119) | n/a | No | Yes | No (copy per new screen) |
| Loading states | Yes (skeletons and button spinners) | n/a | No dedicated frames | n/a | No | Yes | No |
| Offline states | Yes (`OfflineBanner` in 21 files, 22 screens) except the quiz question, result and review screens | n/a | Shared widget; no frames | n/a | No | Yes | No |
| Account banned | No (generic error) | none | None (`grep -ci banned DESIGN_ISSUES.md` = 0) | `403 account_banned` –/–/S; changelog asks for a dedicated screen (`contract-changelog.md@346:78`) | Yes (screen) | Mapping and no-retry yes; screen no | Yes: copy; no signed-out Support channel in the contract |

#### 5.3 Figma-exists / previously-unbacked list (brief section 4)

| Feature | Figma evidence | Backing at 3.46 (`eddb6ac`) | Conflict / residual gap |
|---|---|---|---|
| Subscription | No status-screen frame recorded. Profile "Upgrade to premium" `170:4890`; inbox "Premium Offer — 40% Off!" `180:8768`; limit frames with "Upgrade" CTA (#51); the designer brief commissioned paywall screens (`F:\level\03_role_uiux_partner.md:14-15`, stale) | getMyEntitlements S/S/S (data layer only, never watched); redemption is web-only | **Rule conflict:** adr-049 §3 (`contract-changelog.md@346:576`, never revised). A status-only screen (active / expiresAt / inGrace, no `pending`) is not forbidden but has no design; any website link or redeem mention is forbidden (R-10 OPEN; `/redeem` slot withdrawn in 8e641e9) |
| Chat photos | `649:8835`, "Sent new photo" `649:8851`, capture `166:4260`, editor `166:4319`, "Tap to replay or save" `215:2697` | **None at any pin.** The contract excludes it ("No photo, voice, group chat or streaks", @346:149; `realtime.md@346:17`) | Figma vs contract; also collides with domain rule 9 (camera BLOCKED) |
| Chat voice | Player `215:2727` / `166:4150`; mic `215:2732`; support mic `178:3471` | None; excluded | Figma vs contract |
| Chat groups | No group frame found (only the `bi:people` icon `649:8837`; UNKNOWN) | None; "one conversation per friendship" (@346:143-150) | Unconfirmed design; no backend |
| Notification "Support" tab | Chip "Support" in `180:8386` (`180:8726-8730`) | **Backed:** `listMyNotifications?category=support` S since 3.28; kind `support_ticket_replied` from 3.41 | Promotions chip has no category and conflicts with purchase-silence; "Daily Streak" row has no kind; entry point unsettled (D2/DR-01) |
| Streak flames | Friend flame `661:8319`/`649:8889` in `162:2797`; personal "12 days Streak" `308:4203`; "Daily Streak" row `180:8786` | **Friend:** listMyFriendStreaks S (from 3.44). **Personal:** none | Personal streak and the daily notification have no backend; the friend flame needs the chat list and moves only through forwarded answers |
| Referral | `176:2425`: "you both earn 500 bonus points" (`178:2646`), 9-character sample code `AHMED2024`, "1,500 Points Earned" | getMyInvite + `inviteCode` S (from 3.44) | **Reward conflict:** contract gives +10 to the inviter only and nothing to the new student (@346:1434-1450), with an 8-character code. `UniversityRegistration.inviteCode` prose still says "draft" (@346:4182). No share package |
| Quiz history | No list frame. Home Continue Learning `308:4186` ("80%", "lessons left", streak) is only a lead | listQuizHistory S (3.43) + getQuizReview S (3.39) | Design missing; `QuizHistoryItem` cannot produce the Continue Learning card as drawn |
| Avatar upload | Sheet `216:3341` "Upload photo" `216:3344` | **Changed at 3.46: uploadCustomAvatar + removeCustomAvatar now stable** (draft through 3.45) | Frame lacks crop (contract needs an upright square), remove, rejected, rate-limit and Terms states. Terms gate (`403 terms_acceptance_required`). Photo Picker only (rule 9). Avatars public on the CDN for minors. Picking a default deletes the custom photo |
| Settings preferences | Notification Preferences card `176:2394` (4 toggles) | **None at any pin, 3.46 included** (no preference or mute operation) | Toggles stay inert; `registerFcmToken` registers a device, not a choice; hide-for-R1 proposal O-6/DR-05 |
| Progress | `309:9671` (weekly chart, study time, +30%, hidden badges), `334:3453`, `310:10166`, `334:3622`; Solved Questions tile in `166:4416` | Only getMyQuizSummary `{solvedQuestions}` S (from 3.37/3.38) | Chart, study time, week-over-week % and badge history have no backend; the tile is backable but held by the #101 "Points only" ruling |

##### Notes on this inventory (corrections, disputes, residuals)

**Superseded by 3.46.**
- Sections written against 3.45 listed `uploadCustomAvatar`, `removeCustomAvatar` and the 3 support-photo operations as draft. At 3.46 all 86 operations are stable (changelog `contract-changelog.md@346:7-18`: "build these screens now"; staging live proof photos 18/0, avatars 19/0).
- The census becomes 82 app-buildable: 25 implemented, 1 data-only, 56 not integrated.

**Staging matches 3.46 (as of the probe).** `eddb6ac`'s commit message mirrors `level-up-backend@a158daa3…`. Staging's `/health/version` reported the same commit prefix, `a158daa`, on 2026-10-08 (RUNTIME probe in cor_store and cor_features_social). At that probe time, staging ran the backend that 3.46 describes. Re-probe before relying on it.

**Two in-contract inconsistencies remain at 3.46 (raise with Seif).**
- The `support` tag still says "Text only for launch … attachments arrive later" (@346:135-137), against stable attachment operations.
- `UniversityRegistration.inviteCode` still says "draft … send it only once it is stable" (@346:4182).
- The two Terms contradictions from cor_design §4 also remain.

**Dispute: what "Lockout pop-ups" means.** The sources disagree:
- cor_features_account reads it as `otp_throttled`.
- cor_features_social reads it as `account_banned`.
- cor_design leaves it unconfirmed.

Repo evidence (`day1_login_otp_brief.md:105`) uses "lockout" for `otp_throttled`. Both are tabulated here, with Account banned as its own row. The meaning is still for the owner to confirm.

**Device evidence.**
- Every 100% wave score is a Pixel 8 walk against the **mock** backend.
- The only real-server device runs: STG-AVD on the emulator (school track only: login, catalogue, quiz loop, leaderboard, offline, sign-out) and STG-P8 (FE fixes only).
- Never run against staging: university track, lectures, flashcards, Mistakes, the explanation 202→200 transition, session-superseded.

**Pin gating.** Rows marked "–/–/S" or "D/D/S" depend on the pin decision (DR-23):
- the committed pin is 3.28;
- the working tree holds an uncommitted 3.38;
- upstream is 3.46.

Push additionally needs ≥3.43: the push section of `realtime.md` and the wire kind `chat_message_received`, which 3.38 spells `ChatMessageReceived`.

### 5.4 Learning surfaces (detail)
_Verification (Fable): 18 claims - 16 confirmed, 2 partial (corrected), 0 refuted (corrected), 0 unverifiable._

#### Feature inventory — learning surfaces (Home, Learn/catalog, Quiz, Quiz history, Favorites, Flashcards, Mistakes, Progress, Streak, Rank, Leaderboard, Limit pop-ups)

**Method.** Each area was traced route (`lib/core/router/app_router.dart`) -> screen -> provider/notifier/bloc -> repository -> contract operation, and the screen code was read to classify it. Contract claims were checked against the three pins: the committed `0df5cf4` (3.28), the proposed working-tree `65245be` (3.38) and upstream `2e5bb69` (3.45). The orchestrator's `SCRATCH/ops_table.txt` was used for stability, and the 3.45 YAML was re-read for every learning operation. A second pass (Fable verifier plus the corrector) re-parsed the three YAML pins with PyYAML for stability and did a prose-stripped structural diff of the twelve consumed operations. Tags: **CONTRACT** read in the API contract · **SOURCE** read in code · **DOC** a project document says so (weaker; flagged where code disagrees) · **BUILD** run now · **UNKNOWN**. No DEVICE or CI evidence was produced in this pass. Device claims below are DOC (wave logs). The repo was not modified: `git status --short` was identical before and after (5 modified `contract/` files plus 2 untracked roadmap files; HEAD `8e641e9`).

**BUILD verification run now (read-only).** `flutter test --no-pub --reporter compact test/features/<area>` per directory, all green: home **64**, catalog **182**, flashcards **223**, mistakes **78**, quiz **297**, leaderboard **53**, shell **11** = **908 passed / 0 failed** across 44 test files (13 + 5 + 6 + 2 + 11 + 5 + 2 by glob). Logs are in SCRATCH (`test_<area>.log`); the verifier re-ran `test/features/shell` alone and got +11 (added in verification). The orchestrator's earlier full-suite log (`test_full.log`) ends `+2067: All tests passed!`.

##### 1. Master table

Legend for **States**: L = loading, E = empty, Err = error with retry, Off = offline (banner and/or own view). "n/a" means the state cannot occur because the screen fetches nothing, as documented.

Repository cites below are the line of the path literal (`'/quizzes'` etc.); the `_dio.get/post(` call itself is one line earlier for multi-line calls (corrected in verification).

| # | Area / sub-surface | Route(s) | Screen file(s) | State mgmt -> repository | Contract ops consumed (stability @0df5cf4 / @65245be / @2e5bb69) | Classification |
|---|---|---|---|---|---|---|
| 1 | Home: header, avatar, name | `/home` (`app_router.dart:175`) | `features/home/screens/home_screen.dart`, `widgets/home_header.dart` | Riverpod `meProvider` (autoDispose AsyncNotifier) -> `profile_repository.dart:27` | `getMyProfile` GET /me (stable x3) | **implemented** |
| 2 | Home: level headline + points | same | `widgets/level_card.dart` | same | same | **implemented**, with a client-derived bar and target (see 3.1) |
| 3 | Home: Top Student | same | `widgets/top_student_section.dart` | `leaderboardProvider(scope)` (shared with the tab) -> `leaderboard_repository.dart:51` | `getLeaderboard` (stable x3) | **implemented** |
| 4 | Home: bell + unread dot | same | `home_header.dart:78-81,139-151` | none (inert; `hasUnreadNotifications` defaults `false`, `:36`) | `listMyNotifications`, `getUnreadNotificationCount`, `markNotificationRead` (stable x3), **not called**. The inbox tab filter `category` [system, announcements, support] exists at all three pins (`openapi_0df5cf4.yaml:995`, `openapi_65245be_worktree.yaml:1042`, `openapi_2e5bb69.yaml:1159`) (added in verification) | **contract-exists-not-integrated** (+ design-exists-impl-missing: Notifications frames `180:8386`/`309:9525`, DOC) |
| 5 | Home: Daily Tasks | same | `widgets/coming_soon_section.dart` via `home_screen.dart:94-98` | none | **no operation exists** (grep of the 3.45 contract) | **stub-placeholder**; design exists (`337:5353`) |
| 6 | Home: Learning Tools (university only) | same | `home_screen.dart:111-121` | none | no operation | **stub-placeholder**; design exists (`125:2373`); owner ruling 2026-09-29 (`home_screen.dart:101-110`) |
| 7 | Home: Continue Learning | same | `home_screen.dart:127-131` | none | `listQuizHistory` (draft / draft / **stable**) not called | **stub-placeholder** + **contract-exists-not-integrated** (upstream only) |
| 8 | Home: "Learn Today, Lead Tomorrow" banner | same | `widgets/home_banner.dart` | none | none (no content endpoint) | **stub-placeholder** (one static box, Material icon, `TODO(design-asset)` `:11-21`) |
| 9 | Learn: Subjects | `/learn` (`:204-207`) | `catalog/screens/subjects_screen.dart` | `subjectsProvider` AsyncNotifier -> `catalog_repository.dart:26` | `listSubjects` (stable x3) | **implemented** (client-side search) |
| 10 | Learn: school tree (Units / Chapters / Lessons) | `/learn/subject/:id`, `.../unit/:uid`, `.../chapter/:cid` (`:258-274`) | `subject_tree_screen.dart`, `units_screen.dart`, `chapters_screen.dart`, `lessons_screen.dart` | `subjectTreeProvider(subjectId)` family, one fetch -> `catalog_repository.dart:54` | `getSubjectTree` (stable x3) | **implemented** |
| 11 | Learn: university Lectures, quiz-type tabs, Flashcard tab | `/learn/subject/:id` (same route, `track` discriminator) | `lectures_screen.dart`, `widgets/quiz_type_tabs.dart` | same provider; tab is `setState` | `getSubjectTree` | **implemented** |
| 12 | Learn: modules | none | none | none | `listModules` (draft / **stable** / stable) | **contract-exists-not-integrated**; no design found (DOC `endpoint_ui_mapping.md:131`) |
| 13 | Quiz: setup | `/quiz/setup` (`:337`, outside shell) | `quiz/screens/quiz_setup_screen.dart` | Riverpod `quizSetupProvider` (autoDispose command notifier) -> `quiz_repository.dart:53` | `createQuiz` (stable x3) | **implemented**; only `mode: normal` offered (`quiz_mode.dart:34`) |
| 14 | Quiz: question + AI explanation | `/quiz/:quizId` (`:346`) | `quiz_screen.dart`, `widgets/ai_explanation_panel.dart`, `mcq_renderer.dart` | **Bloc** `QuizBloc` (the one allowed Bloc feature) -> `quiz_repository.dart:94,118,152` | `submitAnswer`, `finishQuiz`, `getExplanation` (stable x3) | **implemented** (poll cap, `rate_limited` retry) |
| 15 | Quiz: favourite star | none | none (`isFavorite` parsed only, `quiz_question.dart:47-54`) | none | `addFavorite`, `removeFavorite` (draft / draft / **stable**) | **design-exists-impl-missing** (bookmark `295:3139`, DOC) + **contract-exists-not-integrated** (upstream) |
| 16 | Quiz: result | `/quiz/:id/result` (`:362`) | `quiz_result_screen.dart` | none; data in `QuizResultArgs` | none (renders `finishQuiz` summary) | **implemented** |
| 17 | Quiz: review (just-finished quiz) | `/quiz/:id/result/review` (`:377`) | `quiz_review_screen.dart` | none; data in `QuizReviewArgs` | none | **implemented** (session-scoped). Review **from history**: `getQuizReview` (draft / draft / **stable**) -> **contract-exists-not-integrated** |
| 18 | Quiz history | none | none | none | `listQuizHistory` (draft / draft / **stable**) | **contract-exists-not-integrated**; design: none found -> **UNKNOWN** |
| 19 | Favorites list / Profile row / `mode: favorites` | Profile row only | `profile/screens/profile_screen.dart:240-248` | none | `listFavorites` (draft / draft / **stable**) | Profile row **UI-exists-inert**; list **contract-exists-not-integrated**; design for a list: none found |
| 20 | Flashcards: setup + study | `/learn/subject/:id/lecture/:lid/flashcards` (+ `/study`) (`:290-303`) | `flashcards/screens/flashcard_setup_screen.dart`, `flashcard_study_screen.dart` | `lectureFlashcardsProvider` family (autoDispose) + `flashcardRoundPositionProvider` -> `flashcards_repository.dart:74,112` | `getFlashcardsForLecture`, `setFlashcardSelfGrade` (stable x3) | **implemented** (university only; no completion screen by owner ruling, `DESIGN_ISSUES.md:4888-4889`) |
| 21 | Mistakes: overview + subject + school tree | `/learn/mistakes` (+ `/subject/:id`, `/unit`, `/chapter`) (`:221-247`) | `mistakes/screens/*` | `mistakesOverviewProvider`, `mistakesTreeProvider` -> `mistakes_repository.dart:52,85` | `getMyMistakes`, `getMyMistakesForSubject` (stable x3) | **implemented, read-only**; replay quiz **design-exists-impl-missing** (`404:6853`, `404:7234`, owner: out of scope) |
| 22 | Progress ("your progress", Solved Questions) | none | none (disabled Profile row `profile_screen.dart:250-260`) | none | `getMyQuizSummary` (absent / **stable** / stable) not called. No progress/statistics op at all | Screen **design-exists-impl-missing** (`309:9671`, `334:3453` / `310:10166`, `334:3622`, DOC). Solved Questions tile **contract-exists-not-integrated**. Progress screen: **backend-missing** |
| 23 | Streak | none | none | none | **No personal-streak operation.** Only friend streaks: `listMyFriendStreaks` (absent / absent / **stable**). The realtime `streaks` hub is "not drafted" at both vendored pins and "Folded into `chat` ... will not be built" at 3.45 (`contract/realtime.md:10`; `SCRATCH/upstream-contract/realtime.md:10`) (added in verification) | Personal streak **backend-missing**; friend streak **contract-exists-not-integrated** (chat dimension) |
| 24 | Rank | none | none (Profile "Rank HERO" omitted, `profile_screen.dart:42-45`) | none | `getMyRank` GET /leaderboard/me (stable x3) | **contract-exists-not-integrated** (by recorded decision D-008) |
| 25 | Leaderboard tab | `/leaderboard` (`:189`) | `leaderboard/screens/leaderboard_screen.dart`, `widgets/podium.dart`, `leaderboard_row.dart`, `scope_toggle.dart` | `leaderboardProvider(scope)` family autoDispose (paging) -> `leaderboard_repository.dart:51` | `getLeaderboard` (stable x3) | **implemented** |
| 26 | Limit pop-ups | raised from `/quiz/setup`, `/quiz/:id` | `quiz/widgets/limit_sheet.dart`, `quiz_error_copy.dart:44-60`, `flashcards_error_copy.dart` | listeners in setup/quiz; flashcards inline | 403 `weekly_question_limit_reached`, `subscription_required` (createQuiz, submitAnswer); `flashcard_subscription_required`; getExplanation `subscription_required` | **implemented** (reactive card; flashcard gate is inline text, not a pop-up) |

##### 2. States, tests, design record and waves (per screen)

| Screen | L | E | Err (retry) | Off | AR + EN | Test files (BUILD pass count for the area) | Design record | Wave / acceptance (DOC) |
|---|---|---|---|---|---|---|---|---|
| Home | skeleton `home_screen.dart:146-185` | n/a (documented `:36`) | `_Failure` + `refresh()` `:57-60,209-247` | banner `:52` + own view `:218-235` | ARB keys present in both files; `home_header_unread_test`, `home_screen_test` use `ar` | `home_screen_test`, `home_header_unread_test`, `level_card_test`, `top_student_section_test`, `coming_soon_section_test` = 5 files, **64** | `337:5303`, `125:2373`, `59:1439`, `337:5323`, `59:1466`, `308:4209`, `337:5353`, `337:5427`, `59:2086`, `337:5485`; DESIGN_ISSUES #1, #13, #20, #41, #79 | W05 impl complete; walk 60% -> 100% (`wave_state.md:29,85`); BUG-023 Arabic headline fixed 2026-10-06 (`882c889`) |
| Top Student block | spinner in card `top_student_section.dart:86-95` | `leaderboardEmpty` `:80-81` | `boardFailureText` + `boardRetryAllowed` `:96-102` | own copy `:97` | yes | within `top_student_section_test` | `59:2086`, `337:5456` | W05 |
| Subjects / tree / chapters / lessons / lectures | `CatalogListSkeleton` (`catalog_states.dart:221`); wrapper `CatalogAsyncView` (`:51`) | `noSubjects`, `noSubjectsMatch`, `nothingHere`, `noLectures` | `CatalogMessage` (`:150`) + retry; retry withheld for futile `insufficient_scope` and `account_pending_deletion` (`:119-121`) | banner + `offline` view (`:123-125`) | yes (5 of 13 test files use `ar`) | 13 files, **182** | `337:5702`, `134:3837`, `308:4521`, `135:815`, `337:5894`, `135:1270`, `337:6047`, `135:1485`, `337:6143`, `180:5208`, `180:5354`, `349:15962`, `337:11059`; #16, #17, #18, #19, #80, #94, #100 | W07 100%, W08 89% -> 100%, W09 100%, W10 100% (`wave_state.md:35,38,41,44`) |
| Quiz setup | in-button spinner `quiz_setup_screen.dart:171-176` | n/a | inline text `:148-157`; 403 -> `LimitSheet` `:226-228` | banner `:74` + CTA disabled `:166,170` | yes | `quiz_setup_screen_test` (quiz area: 11 files, **297**) | `135:1622`, `309:5771`, `337:6239`, `199:2335`; S12, S15, #51, #74 | W11 78% -> 100% after W11-5/6/7 (`wave_state.md:49`) |
| Quiz question | transitional spinner only `quiz_screen.dart:128-132` | **no guard for `questions: []`** (`quiz_state.dart:53`) | `_RetryRow` for `AnswerFailed`/`FinishFailed` `:218-235` | no banner (only `quiz_setup_screen.dart` uses `OfflineBanner`/`isOnlineProvider` in `quiz/screens`; 0 hits in quiz, result, review); offline copy via error row | yes | `quiz_screen_test`, `quiz_bloc_test`, `quiz_repository_test`, `quiz_models_test`, `ai_explanation_panel_test`, `question_stem_text_test`, ... | `159:845`, `159:1695`, `159:1852`, `216:2973`, `295:3139`; #95, #96 | W12 100% (`wave_state.md:53`) |
| Quiz result / review | n/a (data in hand) | review filter empty only (`quiz_review_screen.dart:128`) | cold deep link -> `_QuizUnavailableScreen` `app_router.dart:448-475` | n/a | yes | `quiz_result_screen_test`, `quiz_review_screen_test` | `159:1964`, `309:6375`, `337:6628`, `349:14522`; `162:2377`, `337:6705`, `549:20324`; #29, #50, #55, #97 | W13 44% baseline -> 100%; W14 100% (`wave_state.md:58,83`) |
| Flashcards setup / study | skeleton `_SetupSkeleton` / `flashcard_skeleton` | `nothingHere` | `flashcardsErrorCopy` with `canRetry` (`flashcards_error_copy.dart:70-90`) | banner; Start and grading disabled offline | yes (4 of 6 files use `ar`) | 6 files, **223** | `1234:8797`, `225:5582`, dark `337:14475`, AR `549:28041`; #114, S6 | W22 92% -> 100% after BUG-020 (`wave_state.md:89`) |
| Mistakes (4 screens) | `CatalogListSkeleton` | `noMistakes` (happy path, #60) | `enrolmentPending` copy keeps retry (#61) | banner + view | yes | 2 files, **78** | `404:6292`, `404:6539`, `404:6677`, `404:6762`, `404:7110`, `404:7181`, dark `404:7428`; #60-#64, #99 | W15-W18 each 100% (`wave_state.md:80,77,74,71`) |
| Leaderboard | spinner `leaderboard_screen.dart:211` | `leaderboardEmpty` | `_Message` + retry unless rate-limited/pending deletion (`:211-229`, `board_failure.dart:31-32`) | `ScreenOffline` view + banner | yes | 5 files, **53** | `133:3117`, `134:3626`, `337:5528`; #92, #93 | W06 78% -> 100% (`wave_state.md:32`) |

##### 3. Per-area notes

**3.1 Home.**
- *Wiring.* `HomeScreen` is one screen for both tracks. `GET /me` feeds the header and level card (`home_screen.dart:42,83-92`). `TopStudentSection` reads `leaderboardProvider(LeaderboardScope.defaultFor(profile))` (`top_student_section.dart:52-53`). School defaults to `system` and university to `global`. "See All" does `context.go('/leaderboard')` (`:124`). The block invalidates the whole leaderboard family when `points.total` changes (`:67-74`). Its states live inside the block, so a failed board never fails Home.
- *Bell.* The bell has no tap handler (`home_header.dart:14-17`). The dot is gated by `hasUnreadNotifications = false`, and the only caller passes none (`home_screen.dart:83`). The file says "there is no notifications endpoint in the contract" (`:31-36`). That comment was already false at 3.19.0-m1, when the three inbox ops first existed as `draft` (`contract/SOURCE.md:175`), and they are `stable` at all three pins (CONTRACT, parsed). It is already recorded as F10 in `.ai/audits/current/api_ui_endpoint_inventory.md:97` (so not a new finding). At 3.45 the inbox has 5 kinds: `enrolment_opened`, `announcement`, `moderation_warning`, `support_ticket_replied`, `academic_year_opened` (`contract@2e5bb69:openapi.yaml:1147-1148,1211`). `test/features/home/home_header_unread_test.dart:8-11,63-64` pins "dot absent by default" on the same stale reason.
- *Inbox tabs are contract-backed (added in verification).* The inbox list also takes a `category` filter [system, announcements, support] at all three pins (`openapi_0df5cf4.yaml:995,1019`; `openapi_65245be_worktree.yaml:1042,1071-1072`; `openapi_2e5bb69.yaml:1153-1159,1212`), and `support_ticket_replied` maps to category `support` (`:1186`). So the Figma chips Announcements, Support and System map one-to-one onto the enum, which means the handoff's "Notification Support tab" has had a contract basis since 3.28 (first populated by `support_ticket_replied` at 3.41); only the Promotions chip has no contract counterpart (`notification_inbox_3_28_investigation.md:354`).
- *Bell destination.* Who owns the destination is open and is already formulated as decision D2 (with D1 copy, D3 row tap, D4 "All (N)", D5 Promotions chip and the "Daily Streak"/"Premium Offer" sample rows) in `.ai/audits/current/notification_inbox_3_28_investigation.md:43-49,345-349` (DOC): Notifications frames `180:8386`/`309:9525` versus the Message tab.
- *Level headline and points.* Both come straight from `profile.level` and `profile.points.total`. `LevelCard` also derives the bar fill and the target on the client from a constant: `kPointsPerLevel = 500` (`level_card.dart:23`), `kMaxLevel = 12` (`:27`), `levelProgressFraction` (`:33-37`), `nextLevelThreshold(level) = level * 500` (`:40`). The contract says only `level`: "1-12, thresholds every 500 points; static, not configurable" (CONTRACT, `StudentProfile.level`, `openapi_2e5bb69.yaml:4294`), with badges "first at 11,000" (`:4295`). **Level-12 edge (SOURCE):** the right-hand label is already clamped to "Level 12" (`level_card.dart:82`), but the points line at `:169` prints `levelProgressPoints(totalPoints, nextLevelThreshold(level))`, so a level-12 student sees `"{points} / 6,000"` (`app_en.arb:216-229` formats both placeholders with `decimalPattern`). **Test coverage (corrected in verification):** the level-12 *fraction* IS tested (`test/features/home/home_screen_test.dart:367-370`: `levelProgressFraction(level: kMaxLevel, ...) == 1` for 6000 and 99999). What has no test is the rendered `"{points} / 6,000"` string at level 12, the level-12 label, and any badge case (grep `badge` in `test/features/home`: none). The server-authoritative rule in `CLAUDE.md` makes the constant a judgement call for the owner (see decisions).
- *Placeholders.* Daily Tasks, Learning Tools (university only) and Continue Learning render `ComingSoonSection`: a real header, a "Coming soon" body and an inert "See All" (`coming_soon_section.dart:76-81`). Figma shows invented sample values, including "12 lessons left" and a "12-day streak" (DOC `day4_home_brief.md:71`). No personal-streak data exists in the contract (3.5). The Daily Tasks sample rewards (+150..+300) conflict with the contract's +1 per correct answer (S12).

**3.2 Learn / catalog.**
- *Wiring.* Subjects list: `subjectsProvider` -> `GET /catalog/subjects`. Tree: `subjectTreeProvider(subjectId)` is fetched once, and every level is a view over the cached object (`subject_tree_notifier.dart`). The repository dispatches on the contract `track` discriminator (`catalog_repository.dart:53-70`). Both providers are non-autoDispose, set `retry: noCatalogRetry`, and are dropped at sign-out (`session_scope.dart:69-70`).
- *University.* `LecturesView` builds quiz-type tabs from `tree.quizTypes`. The Flashcard tab is a `FlashcardsTab` beside the quiz types, not a `QuizType` value, and is hidden unless some lecture has `hasFlashcards` (`lectures_screen.dart:87-95,198-231`).
- *Not integrated: modules.* `listModules` is `stable` from 3.37 (`contract@2e5bb69:openapi.yaml:1685-1703`). The contract says a picker MUST keep an "All subjects" view. Nothing in `lib/` mentions modules, and `Subject.termId`/`termNumber` are parsed but never rendered (grep; optional on the wire, `subject.dart:67-68`). No Figma frame was found for a module picker (DOC `endpoint_ui_mapping.md:131`).
- *Not built, by record.* Drill-down search (#17, `lectures_screen.dart:27-30`), Units/Chapters progress bars (#16, `units_screen.dart`) and the Subjects header pill's 48 dp target (#80).

**3.3 Quiz (setup, question, result, review).**
- *Ops.* Only `createQuiz`, `submitAnswer`, `finishQuiz` and `getExplanation` are consumed (`quiz_repository.dart:53,94,118,152`). `mode` is always `normal` (`quiz_setup_screen.dart:197`, `offeredQuizModes.single`). `retakeWrong` and `favorites` exist in the enum but are never sent. Note that `offeredQuizModes.single` throws a `StateError` the day a second mode is added, so that line must change with the list.
- *Empty `questions: []`.* The contract returns `201` with an empty list as a normal outcome for `retakeWrong` with no wrong answers: outcome one is `201` with `questions: []`, "a NORMAL response" (`contract@2e5bb69:openapi.yaml:1810-1813`; operation `:1773-1830`). `QuizSession.question` is `quiz.questions[index]` (`quiz_state.dart:53`); `questionCount` would be 0 and `isLast` true (`quiz.dart:55`), but the getter throws `RangeError`. There is no emptiness guard in bloc, state or screen (grep `isEmpty` in `lib/features/quiz`: only `question_stem_text.dart` and `quiz_review_screen.dart:128`) and no test for it (grep `questions: []` in `test/`: none). It is unreachable today because only `normal` is sent and `normal` answers `422 not_enough_questions` on a short pool. It becomes a crash the moment `retakeWrong` or `favorites` is enabled.
- *AI explanation.* The panel appears only when `AnswerResult.explanationAvailable` is true. The bloc polls with a cap, and `rate_limited` is retryable (`explanation_state.dart`). The contract's mandated 403 copy is shipped verbatim: "AI explanations are available with a Level Up subscription. Subscribe to get step-by-step explanations..." (`app_en.arb:516`, identical to `openapi_2e5bb69.yaml:2069-2070`; AR at `app_ar.arb:206`). The sheet has no CTA, price or link.
- *Result.* Renders `QuizSummary` only. `wrong` and `skipped` are derived by subtraction (`quiz_summary.dart`). There is no "Pass", no level meter (#50), and `leveledUp`/`newBadge` are parsed but not celebrated.
- *Review.* Session-only, via `QuizReviewArgs`. A cold deep link shows the "unavailable" screen. `getQuizReview` is `stable` at 3.45 (draft at both vendored pins).
- *Screen protection.* The quiz and review screens read `screenProtectionProvider` into `_protection` and call `_protection.enable()` in `initState` (`quiz_screen.dart:75-76`, `quiz_review_screen.dart:73-74`); the result screen does not (corrected in verification: it is an instance obtained through the provider, not a static `ScreenProtection.enable()`).
- *Forward a question: the entry point is a learning surface (added in verification).* `forwardQuestion` is `stable` (`x-behaviour-changed: '3.45.0-m1'`, `openapi_2e5bb69.yaml:3696-3705`). It can only forward "a question the caller has already answered in one of their own quizzes, on their current Track" (`:3702-3704`, `:4791`), else `422 question_not_forwardable` (`:3756-3758`). So the affordance has to sit on the quiz question screen after grading, the review screen, or a history/favorites list; none of them offers it today (grep `forward` in `lib/features/quiz`: no match). The quiz header's share/AI icons (#95) and the flashcard header's share icon were omitted on the premise "no endpoint, no sharing story" (`flashcard_study_screen.dart:48-49`), which is stale at 3.44+. No frame or doc records an entry point (grep `forward` in `endpoint_ui_mapping.md`, `DESIGN_ISSUES.md`, `seif_fight.md`: only unrelated hits).

**3.4 Quiz history, Favorites.**
- *Quiz history.* No route, provider, test or mock handler exists for `GET /quizzes` (`mock_backend.dart:431` serves only POST). `listQuizHistory` returns `QuizHistoryItem {id, subjectName, scopeName, mode, score, totalQuestions, finishedAt}`. `subjectName` is "" for `retakeWrong` and `favorites` quizzes (`contract@2e5bb69:openapi.yaml:4607-4617`).
- *Home mismatch.* That shape cannot fill Home's Continue Learning card as drawn ("80%", "lessons left", "12-day streak"). No history-list frame was found (DOC `endpoint_ui_mapping.md:130`).
- *Favorites.* The Profile row `profile_row_favorites` is disabled with a `TODO(contract) S11` (`profile_screen.dart:240-248`). `isFavorite` is a required response field and is parsed but unused. The mock fakes `isFavorite: i % 5 == 0` (`mock_backend.dart:2158`).
- *Staleness.* The S11 and S14 TODOs and `test/features/profile/profile_screen_test.dart:43` ("S11 - /me/favorites is draft") are right against the vendored pin and stale against upstream 3.45. Four more comment sites rest on the same premise "`GET /quizzes/{quizId}` is draft" and go stale at 3.45 (added in verification): `app_router.dart:342-343`, `:369-370`, `:444-446` (the `_QuizUnavailableScreen` cold-deep-link rationale and the S14 note) and `quiz_summary.dart:62-68` (`QuizSummary.questions` "parsed, not rendered"). `contract/SOURCE.md:64-65` (working tree) confirms the 3.38 re-vendor leaves favourites and `getQuizReview` draft.

**3.5 Streak, Progress, Rank.**
- *Streak.* The only streak operation in the contract is `FriendStreak {friendStudentId, conversationId, count, stepTakenToday}` from `listMyFriendStreaks` (`contract@2e5bb69:openapi.yaml:3825,4866`, required list at `:4866`). It is stable from 3.44 and drawn on a conversation row. The contract has **no personal streak** operation and no progress/daily-task operation (grep of the 3.45 YAML for streak/progress/daily: only tag prose at `:142,:149`, the flashcard note `:2265`, chat `:3380,:3559`, the forwarded-question/friend-streak items `:3772-3852` and `FriendStreak` `:4804-4881`). **`StreakPair` provenance (corrected in verification):** it is not an OpenAPI schema at any pin, but it is named in prose in `contract/realtime.md:10` at both vendored pins (`0df5cf4`, and `65245be` in the working tree): "`streaks` | Social | StreakPair updates, ForwardedQuestion events | not drafted". At 3.45 that row reads "Folded into `chat` (spec-056, adr-219) — will not be built" (`SCRATCH/upstream-contract/realtime.md:10`), and `chat` (stable) carries "forwarded-question cards and friend-streak changes" (`:11`, `friendStreakChanged` event `:63`). The glossary term itself comes from the owner's project glossary (`F:\level\00_project_brief_and_team_model.md:88`, `F:\level\level_up\level_up\00_Project\Glossary.md:23`, `.claude/skills/level-up-domain/SKILL.md:40`), not from the `seif-api-contract` skill example; it defines StreakPair as the social two-friend streak, which 3.44's `FriendStreak` now backs. Figma places a flame on a conversation row (`162:2797`, DOC), a "12-day streak" on Home Continue Learning (DOC) and a "Daily Streak" sample notification. Nothing in `lib/` references streaks beyond a comment (grep).
- *Progress.* Profile shows "Points" only. The "Solved Questions" tile is omitted citing S24 (`profile_screen.dart:38-41`). `getMyQuizSummary` (`{solvedQuestions}`, lifetime, cross-track, stable from 3.37) now answers S24 but is not called (`contract@2e5bb69:openapi.yaml:1727-1772`). The "your progress" row stays disabled (S32). The contract still has no time-series, per-day or statistics operation (grep for "progress" in the 3.45 YAML found none).
- *Rank.* `getMyRank` is stable at all three pins and not called. `profile_screen.dart:43-44` calls it "draft", which is stale. `DECISIONS.md:469-471` records "the contract's 'do not add a synthetic self-rank row' is why the app does not call it" (decision D-008), and `smoke-staging-2026-09-22.md:35-36` repeats it. The contract text is: "Do not add a synthetic self-rank row to the board. If the client needs the caller's exact standing below the published display bound (currently 200), call `GET /leaderboard/me` as a separate optional read" (`contract@2e5bb69:openapi.yaml:2513-2518`; also `:2498-2500`, `:2589-2592` "the only one that can answer"). The recorded rationale therefore misreads the contract, although not calling the read is contract-legal because the contract calls it "optional". D-008 is a standing owner decision (`endpoint_ui_mapping.md:90-95`: "owner decision — no synthetic self-rank row"; `screen_api_gaps.md:41`: "Decision, not a gap: reopening it is the owner's call"), so the open question is whether to reopen it, not whether a decision exists. Consequence: a student ranked below 200 appears on no page and has no `isMe` row, and the app shows no own-rank element. Error modes: `404 not_ranked`, `403 score_hidden_leaderboard_unavailable`.

**3.6 Flashcards.**
- *Round mechanics.* Setup reads `Lecture.flashcardCount` from the cached tree and never calls the cards endpoint, because the endpoint charges the weekly preview (`flashcard_setup_screen.dart:21-30`). A round is a page of 10 (`flashcardRoundSize`). Grading is non-optimistic, and after the last card the route pops and the round position moves on. This is an owner ruling: "The end of a round: no frame and no wording. Owner ruling: return to where the student came from — the study screen pops back to Setup. No completion screen." (`DESIGN_ISSUES.md:4888-4889`, repeated for #126 at `:4953`).
- *Allowance.* There is no operation that reports remaining allowance (grep of 3.45 paths for allowance|remaining|usage|quota: none). The 50 per week is shared across quiz questions, flashcards and (3.43+) forwarded-question answers (CONTRACT `getFlashcardsForLecture`, `contract@2e5bb69:openapi.yaml:2166-2192`, shared 50/week at `:2173-2176`). The app discovers exhaustion only via `403 flashcard_subscription_required`, shown as the inline `flashcardPreviewUsedUp` line with no retry, and it never opens `LimitSheet` (`flashcards_error_copy.dart:45-51,72-76`).
- *Open.* The "preview used up" state is a designer ask already filed under #119 (`DESIGN_ISSUES.md:4891`: "the loading, empty, error, preview-used-up and grading-failure states"); the inline treatment ships until the designer answers. Arabic Setup pill/helper strings are provisional (#114). Dark and Arabic frames are older layouts built from the light one.

**3.7 Mistakes.**
- *Read-only.* Overview, subject, and school unit/chapter/lesson trees. University stops at the subject level. Every leaf row is inert, with no chevron or ripple (`mistakes_subject_screen.dart:215-219`, `mistakes_tree_screens.dart:149-152`; owner ruling 2026-09-12). The replay quiz (`404:6853`/`404:7234`) is out of scope by that ruling.
- *`retakeWrong` open question.* The contract (3.11+) accepts one optional leaf id, which would let a leaf row start a replay (`contract@2e5bb69:openapi.yaml:1783-1787`). S43 (a "8 mistakes" badge versus an "ever wrong" pool of 10/30/50) is unanswered (`seif_fight.md:645`). `mistakeCount` decays and the retake pool does not (`mistakes_subject.dart:49-58`).
- *Empty is the happy path* (`noMistakes`, #60). The overview passes `ScopeErrorCopy.enrolmentPending` (`mistakes_overview_screen.dart:76-87`).
- *Never run against a real server.* S44 (`seif_fight.md:646`): the only staging account's catalog was empty. Mistakes was BUILD and mock only as of the records. The seed ask is already filed as "register a university test account ... 'seed a released term'" (S37 ask 2; `docs/RISKS.md:125`, R-8).

**3.8 Leaderboard.**
- *Behaviour.* One endpoint, scoped by `LeaderboardScope.scopesFor(profile)`: school `[system, governorate (EG only)]`, university `[global, cohort]`. Cursor paging with `loadMore`, podium, `isMe` row, and a 429 path with no retry (`board_failure.dart`).
- *Contract notes.* 3.36 prose: blocked students are hidden and ranks stay dense (`openapi_2e5bb69.yaml:2480-2483`). The wire is unchanged (CONTRACT schema diff: `LeaderboardEntry` description only). A caller ranked below the 200 bound is on no page and `isMe` may never be true on any row (`:2491-2500`; `leaderboard_models.dart:78-84`). D-008 is closed and the route is un-gated (`app_router.dart:180-191`).
- *Privacy.* The board renders peers' names and avatars. Reconciliation H-1 flags this as an owner decision (DOC `release_readiness_reconciliation_2026-10-06.md:108`).

**3.9 Limit pop-ups.**
- *`LimitSheet`.* A centred card with a close icon and "Not now", no CTA, price or link (`limit_sheet.dart:196-202`, adr-049 §3). Titles (`limit_sheet.dart:89-97`): `freeUsageReachedTitle` ("Free Usage Reached") for `weekly_question_limit_reached`, and `subscriptionRequiredTitle` for `subscription_required` and the explanation popup.
- *Triggers.* `POST /quizzes` 403 via the setup listener (`quiz_setup_screen.dart:226-227`), a mid-quiz `submitAnswer` 403 (`quiz_screen.dart:276-277`), and the getExplanation lock (`:117`). A repeat 403 stacking two cards was fixed in W11-6. Callers of `LimitSheet` in `lib/`: only `quiz_setup_screen.dart` and `quiz_screen.dart` (grep).
- *Dark scrim.* No dark Limitation frame exists, so the scrim falls back to the framework default (#74).
- *Cross-feature.* The same weekly-limit 403 now also applies to `answerForwardedQuestion` (chat), which spends the same allowance (`openapi_2e5bb69.yaml:3780-3783,3813`), so the sheet needs a second caller. Any "website link" in these pop-ups is a purchase hand-off and falls under R-10 / adr-049 §3, which the contract still states at 3.45 (`contract-changelog.md:326`).
- *Pending deletion.* `account_pending_deletion` is handled as copy plus suppressed retry in every learning screen. The mandated route to a cancel screen does not exist (#62).

##### 4. Learning operations versus integration (verified)

Stability below was re-parsed from the three YAML pins (PyYAML), not read from the ops table (verified).

| Operation | Path | @0df5cf4 | @65245be | @2e5bb69 | Called from `lib/`? |
|---|---|---|---|---|---|
| getMyProfile | GET /me | stable | stable | stable | yes (`profile_repository.dart:27`) |
| listSubjects / getSubjectTree | /catalog/subjects, /tree | stable | stable | stable | yes |
| **listModules** | /catalog/modules | draft | stable | stable | **no** |
| getMyMistakes / getMyMistakesForSubject | /me/mistakes... | stable | stable | stable | yes |
| **getMyQuizSummary** | /me/quiz-summary | absent | stable | stable | **no** |
| createQuiz / submitAnswer / finishQuiz / getExplanation | /quizzes... | stable | stable | stable | yes |
| **listQuizHistory** | GET /quizzes | draft | draft | **stable** | **no** |
| **getQuizReview** | GET /quizzes/{id} | draft | draft | **stable** | **no** |
| **addFavorite / removeFavorite / listFavorites** | /questions/{id}/favorite, /me/favorites | draft | draft | **stable** | **no** |
| getFlashcardsForLecture / setFlashcardSelfGrade | /flashcards/... | stable | stable | stable | yes |
| getLeaderboard | GET /leaderboard | stable | stable | stable | yes |
| **getMyRank** | GET /leaderboard/me | stable | stable | stable | **no** (decision D-008) |
| **listMyNotifications / getUnreadNotificationCount / markNotificationRead** | /me/notifications... | stable | stable | stable | **no** |
| **listMyFriendStreaks** | GET /friend-streaks | absent | absent | **stable** | **no** |

- *Structural diff.* A prose-stripped structural diff of the consumed learning operations between `0df5cf4` and `2e5bb69` found **no non-prose change** to `listSubjects`, `getSubjectTree`, `getMyMistakes`, `getMyMistakesForSubject`, `createQuiz`, `submitAnswer`, `finishQuiz`, `getExplanation`, `getFlashcardsForLecture`, `setFlashcardSelfGrade`, `getLeaderboard`, `getMyProfile` (reproduced independently by the verifier for 0df->338 and 0df->345; `x-behaviour-changed` stamps are identical at all three pins: createQuiz 3.11.0-m1, getLeaderboard 3.4.0-m1, listSubjects/getSubjectTree 2.3.0-m1). Component schemas that changed since the committed pin: `LeaderboardEntry` (description), `StudentProfile` (descriptions), `QuizHistoryItem` (description), `ProblemDetails` (prose; no-body errors and `Accept` guidance), plus chat/support/registration schemas outside this dimension. Re-vendoring to 3.45 adds no decode risk for learning surfaces.
- *Guard coverage.* `test/guards/contract_models_test.dart:73-156` mechanises 13 bindings: `StudentProfile` and **five** sub-objects (`school`, `geography`, `points`, `privacy`, `pendingDeletion`; corrected in verification from "four"), `EntitlementState`, `UniversitySubjectTree` (+ `lectures[]` as `Lecture`), `SchoolSubjectTree`, `AnswerResult`, `NamedRef`, `FlashcardCard`. It does **not** cover `Quiz`, `QuizQuestion`, `QuizSummary`, `LeaderboardEntry`, `QuestionCounter`, the Subject list item (an inline array item of `listSubjects`' 200, required [id, name, questionCounter], not a component schema) or the Mistakes models. Hand comparison of the required lists against the Dart models matches for `Quiz` (`quiz.dart:22-45`, `quizType` optional), `QuizQuestion` (`quiz_question.dart:20-55`), `QuizSummary` (8 required, `quiz_summary.dart:25-70`), `LeaderboardEntry` (6, `leaderboard_models.dart:71-85`) and `QuestionCounter` [answered, total] (`subject.dart:21-22`) (SOURCE; the corrector re-checked `QuestionCounter`).

##### 5. Placeholders, inert controls and omissions (learning scope)

1. Home `ComingSoonSection` x3, "See All" inert (`coming_soon_section.dart:76-81`).
2. Home bell inert, dot hard-gated off (`home_header.dart:36`).
3. Home banner: static single slide, Material icon, `TODO(design-asset)` (`home_banner.dart:11-21`).
4. `/message` tab renders "Coming soon" (`app_router.dart:314-316`, `tab_placeholder.dart:54-61`: "the in-app inbox (admin broadcasts, end-of-year promotion)"), pinned by `main_shell_test.dart:166-167`.
5. `/track-select` renders `_Placeholder('Track select')` (`app_router.dart:161-164`, comment `:484`) with **no inbound navigation** anywhere in `lib/` (grep `track-select`: only those two sites). Already recorded as an unreachable dev placeholder (M-3) with "delete `/track-select` at the next router touch" (`release_readiness_reconciliation_2026-10-06.md:92`).
6. Profile rows "Favorite questions" and "your progress" disabled (`profile_screen.dart:240-260`). "Solved Questions" and "Rank HERO" tiles omitted (`:38-45`).
7. Mistakes leaf rows inert (above).
8. Omitted by record: quiz header bookmark and AI sparkle (#95), flashcards header bookmark and share (`flashcard_study_screen.dart:48-51`; the "no sharing story" premise is stale at 3.44+, see 3.3), drill-down search (#17), Units/Chapters progress (#16), setup pool-progress card and points preview (`quiz_setup_screen.dart:31-37`), result "Pass" and level meter (#50), flashcard completion screen (owner ruling, `DESIGN_ISSUES.md:4888-4889`).
9. No `TabPlaceholder` is used by any learning tab other than Message. Learn, Leaderboard and Account placeholders were removed (comments in `tab_placeholder.dart`).
10. Stale-premise comments that gate nothing but mislead (added in verification): the "draft" comments listed in 3.4 (`app_router.dart:342-343,369-370,444-446`; `quiz_summary.dart:62-68`) and the "no notifications endpoint" / "draft GET /leaderboard/me" comments (F10, `api_ui_endpoint_inventory.md:97`).

##### 6. Verification provenance

- Per-wave "Pixel 8" acceptance (100% for W05-W18 and W22) was run on a **plain mock build** (`wave_state.md:61-89`: W15-W22 rows say "Pixel 8 on a plain mock build", W14 `:82` "on a normal build"). That is DEVICE against the mock, not against a real server. `device_walk_results.md` contains no "staging"; `smoke-staging-2026-09-22.md:14` is "API ... Not DEVICE, not CI".
- The only real-server device pass is the 2026-10-06 release build against staging. It covered login, the catalogue (one English subject, "0 / 53"), the 10-question quiz loop (+2 points), a one-row leaderboard, offline and sign-out (`release_readiness_reconciliation_2026-10-06.md:85-86,387-397`, school track). It did not exercise the university track, lectures, flashcards, Mistakes (S44) or the explanation 202 -> 200 arm (`explanationAvailable` was false for every seeded question); R-8 lists the still-unobserved items (explanation 202->200, 5xx, 429, refresh; `docs/RISKS.md:118-126`).
- Git: every `lib/features/{home,catalog,flashcards,mistakes,quiz,leaderboard,shell}` directory is committed (last touches: Home `882c889`, catalog `423a610`, flashcards `a988a1f`, mistakes `cccd2f1`, quiz `5c0a27d`, leaderboard/shell `a0585eb`). The only dirty files are the five `contract/` files and the roadmap files.
- Already recorded elsewhere, to be cited as repeats rather than new findings (added in verification): the stale "no notifications endpoint" and "draft GET /leaderboard/me" comments (F10, `api_ui_endpoint_inventory.md:97`); the orphan `/track-select` (M-3, `release_readiness_reconciliation_2026-10-06.md:92`); the bell versus Message-tab entry point (decision D2, `notification_inbox_3_28_investigation.md:345-349`); the university seed ask (S37 ask 2 / R-8, `docs/RISKS.md:125`); the no-completion-screen ruling (`DESIGN_ISSUES.md:4888-4889`).

### 5.5 Account, identity, session, subscription (detail)
_Verification (Fable): 16 claims - 13 confirmed, 3 partial (corrected), 0 refuted (corrected), 0 unverifiable._

#### Feature inventory: account, identity, session, subscription

**Scope.** Onboarding, Login, OTP, Registration, Terms and legal, Profile, Edit Profile, Avatar, Settings, Track select and track transfer, account deletion and its cancellation, lost-phone recovery, 'logged in on another device', account banned, Logout, Subscription and entitlements, plus the purchase-silence sweep. 'Identity' in this section means student identity. The app identifiers (Android `applicationId` `com.levelupworld.app` with `.stg` for staging, `android/app/build.gradle*:55,76`; iOS `PRODUCT_BUNDLE_IDENTIFIER` still `com.levelup.levelUpApp`, `ios/Runner.xcodeproj/project.pbxproj:371`) belong to the environment-chapter dimension and are cross-referenced only (added in verification, SOURCE).

**Evidence levels.** CONTRACT and SOURCE were read this session. DOC marks what a project document claims. **No BUILD, ARTEFACT, DEVICE or CI evidence was produced by this section, by its verification, or by the correction pass.** Tests were read, not executed, because `pubspec.yaml:144` has `generate: true` and `flutter test` may regenerate the tracked `lib/l10n/app_localizations*.dart`, which the read-only rules forbid. Where a test is cited it proves only what the test source asserts. Staging was never called: every statement about what staging serves is Seif's own changelog (DOC), not an observation.

**Contract shorthand.** `C28` = committed pin 0df5cf4 (3.28.0-m1). `C38` = working-tree re-vendor 65245be (3.38.0-m1). `C45` = upstream 2e5bb69 (3.45.0-m1). `C45:231` means line 231 of `openapi.yaml` at that pin. `UP:contract-changelog.md:499` and `UP:error-codes.md:59` mean those lines of the upstream clone at 2e5bb69 (`SCRATCH/upstream-contract`). The working-tree `contract/contract-changelog.md` and `contract/error-codes.md` are the C38 copies. Stability columns read C28 / C38 / C45 and come from `SCRATCH/ops_table.txt`, spot-checked against the YAML (re-read in verification: recovery x4 draft/draft/stable, `transferToUniversity` -/draft/stable, `getLegalDocument` -/-/stable, `getMyInvite` -/-/stable, terms pair, deletion pair and `registerFcmToken` stable x3, `uploadCustomAvatar` draft x3, `removeCustomAvatar` -/-/draft).

##### 1. Headline findings

1. **The subscription surface does not exist, by decision.** `lib/features/subscription/` and `lib/features/track/` hold only `.gitkeep` files (4 empty subfolders each: models, notifier, repository, screens). There is no `/subscription` route (`app_router.dart:477-499`; the removal note at `:484-487` names `/subscription` and `/subscription/return`). The Profile hub has no Subscription row (`profile_screen.dart:284-285`). Nothing in the UI displays an entitlement. `GET /me/entitlements` has a repository method and a provider (`me_notifier.dart:78-101`) that no widget watches. It is only invalidated at sign-out (`session_scope.dart:64`). The entitlements embedded in `/me` are decoded (`student_profile.dart:55-62`) and never rendered (SOURCE, repo-wide grep; re-run in verification: `entitlementsProvider` appears only at `me_notifier.dart:97`, `session_scope.dart:64` and a comment at `profile_repository.dart:77`, other references are tests).
2. **Handoff item 1 ('status screen with a website link') is half compatible with the contract.** A status-only screen (type, `active`, `expiresAt`, `inGrace`) is compatible. A website link, or any mention of redeeming codes on the website, contradicts adr-049 §3/§4 as quoted in the working-tree `contract/contract-changelog.md:443` ('never carries a purchase link, and never tells the student where to buy'), `:201` and `:205` ('the Flutter app never consumes or mentions voucher redemption … Do not build a redemption screen'), `docs/RISKS.md:142-150` (R-10, OPEN-DECISION) and `docs/DESIGN_ISSUES.md:1581-1600` (#51: copy may not mention 'the website'). Note: `RISKS.md` cites the same sentence at changelog `:360`; that is the committed-pin (0df5cf4) line (`git show HEAD:contract/contract-changelog.md` line 360 reads the same), and the uncommitted re-vendor moved it to `:443`. HEAD commit 8e641e9 withdrew the planned `/redeem` slot for exactly this reason (`docs/ENVIRONMENTS.md:405-412` 'DO NOT BUILD (R-10)'). This needs a contract changelog entry plus an owner acceptance of the Apple 3.1.1 exposure; Claude cannot decide it.
3. **Only 8 account and auth operations are consumed.** They are `requestOtp`, `verifyOtp`, `completeRegistration`, `refreshTokens`, `logout`, `getMyProfile`, `updateMyProfile` and `listDefaultAvatars`, plus the registration `/reference/*` lookups (path grep of `lib/`, excluding `lib/dev`; the census in verification found `/auth/otp/request`, `/auth/otp/verify`, `/auth/register`, `/auth/refresh`, `/auth/logout`, `/me`, `/me/entitlements`, `/me/mistakes`, `/reference/*`, `/quizzes`, `/leaderboard`). **Not consumed at all:** the terms pair, `getLegalDocument`, the 4 recovery operations, the deletion pair, `transferToUniversity`, `registerFcmToken`, `getMyInvite`, `uploadCustomAvatar`/`removeCustomAvatar`, `getMyQuizSummary`. Of these, the terms pair, the deletion pair and `registerFcmToken` are stable at all three pins.
4. **Four of the twelve handoff section-5 rows depend on something that is stable, or present at all, only at C45: Lost-phone recovery (4 operations), Track-transfer confirmation (`transferToUniversity`), the Terms step's in-app document viewer (`getLegalDocument`) and Account banned (`account_banned`, declared from 3.42, absent from C38).** That is seven operations or codes across four rows. (Corrected in verification: the earlier text said 'seven of the twelve rows'; the other eight rows are stable at all three pins or are cross-cutting states, see §7 and `ops_table.txt`.) The 3.39.0-m1 changelog entry flipped recovery, chat, track transfer, review/favourites and support to stable (`UP:contract-changelog.md:107-110`, 'routed, covered by integration tests and deployed to staging'). The working-tree re-vendor (C38) still shows recovery and transfer as draft. **The pin decision (DR-23) therefore gates this part of the inventory.**
5. **`account_banned` is not handled anywhere** (0 hits in `lib/`, `test/`, `docs/`, `.ai/` and the vendored contract; re-run in verification). `authErrorMessage` falls through to `genericError` ('Something went wrong'), `auth_error_copy.dart:10-25`, and `error_interceptor.dart:40` builds a plain `ApiException(status, code)` for unknown 403s. The OTP code has already been consumed server-side (`C45:231`). **The contract asks for a dedicated screen, not inline copy** (added in verification): 'What to build: a "this account has been banned — contact Support" screen. Do not retry.' (`UP:contract-changelog.md:62-66`; `UP:error-codes.md:51`). The ban also revokes the student's open sessions (`UP:contract-changelog.md:65`).
6. **Pending deletion is a dead end in the UI.** The contract's client rule is 'route to the cancel screen' (`C45:82-83`). The app has no cancel screen (`exceptions.dart:127-129`: 'is NOT implemented, because that screen does not exist'). It shows `accountPendingDeletion` ('Cancel the request to use Level Up again', `app_en.arb:692`) from **five code sites** (`catalog_states.dart:106`, `flashcards_error_copy.dart:82`, `board_failure.dart:18`, `profile_error_copy.dart:22`, `quiz_error_copy.dart:30-31`), which feed several screens (catalog, Mistakes via `CatalogAsyncView`, flashcards, leaderboard, profile save, quiz), and nothing can cancel. (Corrected in verification: the earlier text said 'six error surfaces'; the cited evidence is five copy sites.) `pendingDeletion` is decoded (`student_profile.dart:77`) and read by no code. **Whether any non-app channel can create a deletion request is answered by the contract (added in verification):** it publishes none. 'No admin/staff-initiated deletion (that surface does not exist and is not planned in this contract); … no web deletion URL (the Google Play Data-safety web leg is a separate, still-unowned decision)' (`UP:contract-changelog.md:499`), and `requestAccountDeletion` carries no `x-consumers` (mobile default, `ops_table.txt`; `C45:1262-1270`). So, on the contract text alone, no product surface starts a grace window until the app ships the request screen (CONTRACT/DOC inference; staging not probed).
7. **Terms and legal.** There is no Terms step in registration (`grep 'terms|agree|consent' lib/features/registration` = 0 hits). `/legal/privacy` and `/legal/terms` are `TODO(content)` shells that say 'This document hasn't been published yet' (`legal_document_screen.dart:34-55`, `app_en.arb:644`). They are auth-gated: `_authRoutes = {'/', '/login', '/login/otp'}` plus `/register*` (`app_router.dart:52,56-57`) and a signed-out student on any other route goes to `/login` (`:77`), so the documents cannot be read before sign-up. Login's three legal links open `https://levelup.example/...` externally (`login_screen.dart:43-48,122-124`), the only `url_launcher` call in `lib/`. `getLegalDocument` (public, stable at C45 only) returns Markdown for in-app rendering. `pubspec.yaml` has no Markdown renderer. Staging state (added in verification): Seif's changelog states 'Staging serves `11ab701` … `getLegalDocument` answers `200` there' (`UP:contract-changelog.md:37-38`, DOC; not verified against staging here).
8. **Track transfer.** 'Go to Uni' is a dialog whose Confirm is hard-disabled (`profile_screen.dart:339-353`, `confirmEnabled: false`). The row is rendered for both tracks (no track check, `:307-316`). The contract answers `409 track_transfer_not_allowed` for a University-track caller ('already on the University track: registered there, or already transferred', `C45:1403`) and `403 track_transfer_not_eligible` unless the stage is `secondary3` (`C45:1352-1356`). The instruction 'Client: re-read `GET /me` and render the University track; never offer the transfer again' is in `UP:error-codes.md:59` (and the working-tree `contract/error-codes.md`), **not** in `openapi.yaml` (corrected in verification; the earlier text attributed it to `C45:1338-1412`). The contract also answers the data-model question that `seif_fight.md` S31 (`:1265-1285`, still asking the four pool questions) holds as open: points, level, badges, subscription and privacy carry over (`C45:1360-1364`).
9. **Session superseded is implemented as a snackbar, not a screen.** The interceptor forces logout on `session_superseded` from any endpoint (`auth_interceptor.dart:75-78`, refresh path `:147-151`). `/login` shows `sessionEndedSuperseded` once (`login_screen.dart:60-76`; test `login_logout_message_test.dart:57`). The contract text says 'show the forced-logout screen' (`C45:58-60`). The design record is 'infrastructure, not a designed screen' (`docs/day1b_forced_logout_brief.md:4-7`). There is no DEVICE or staging record of this flow in `docs/DEVICE_VERIFICATION_2026-09-{12,19,20,20-edit5}.md` or `.ai/audits/current/device_walk_results.md` (grep, 0 hits).
10. **Lockout is inline text only.** `otp_throttled` maps to 'Too many attempts. Please wait a moment…' (`app_en.arb:117`; `auth_error_copy.dart:18-19`). The contract states a **15-minute lock after 5 failed verifies** (`C45:200`; the 429 answer is `C45:234`). There is no countdown and no pop-up. `Retry-After` is parsed only under `429 when code == 'rate_limited'` (`error_interceptor.dart:34-36,64-70`). The contract documents `Retry-After` on `rate_limited` (the `/reference/*` limit and several authenticated limits), on `forward_daily_limit_reached` (`C45:3760`, chat) and inside the web-only `redeemSubscriptionCode` 429 (`C45:2432`), but **not on `otp_throttled`** (`C45:234`; the `UP:error-codes.md:12` row mentions none). (Corrected in verification: the earlier text said 'rate_limited only'; the conclusion that the lockout duration source is undocumented stands.) The only `otp_throttled` test is the interceptor mapping (`test/core/network/error_interceptor_test.dart:204-208`).
11. **Dio sends no `Accept` header.** The contract (3.32.0-m1, `C45:3889`) says to send `Accept: application/json` on every call so the API can write its error body. `dio_client.dart:15-20` (`BaseOptions`, `headers` at `:19`) sets only `Content-Type`; no `Accept` is set anywhere in `lib/` (grep, 0 hits). Runtime absence is inferred from library defaults, not packet-captured. **The gap is pin-independent** (added in verification): the same sentence is already in the working-tree pin at `contract/openapi.yaml:3375` and is absent from C28 (0 hits in `openapi_0df5cf4.yaml`), so it applies as soon as the uncommitted re-vendor lands (upstream changelog `:182-185`).
12. **Avatar upload: the exact contract now exists but is still draft at C45.** `PUT /me/avatar` is multipart with one `image` part, JPEG/PNG/WebP, at most 2,097,152 bytes, 128-4096 px. It returns `403 terms_acceptance_required` when Terms are not accepted (the 403 answer is `C45:1025`), `413 image_too_large`, `422 image_content_invalid` or `422 image_rejected_by_moderation`, `429` and `503` (`C45:982-1040`; 3.42 changelog: both avatar operations draft, limit 'was 5 MB', `UP:contract-changelog.md:78-82`). `DELETE /me/avatar` is draft (`C45:1042`). The handoff statement that exact shapes 'will come from the next contract version' is stale for avatars. **Photo upload depends on Terms acceptance.** The app has no `image_picker`, no camera or photo permissions (`AndroidManifest.xml:19` has only INTERNET; `Info.plist` has no `*UsageDescription`), and no Firebase dependency. (Added in verification) Once custom avatars exist, choosing a default `avatarId` through the existing PATCH /me picker also replaces an active custom avatar and deletes its photo (`UP:contract-changelog.md:83`, description-only change on stable `updateMyProfile`), so the current avatar sheet would become a silent 'remove photo' path.
13. **Referral.** Sign Up_1 collects an optional referral code and never submits it ('Collected, NOT submitted', `signup_identity_screen.dart:86-94`; `school_registration.dart:96-97`; `university_registration.dart:78`). The contract now has an optional `inviteCode` on both register bodies and `inviteCodeApplied` on the 201 (`C45:4087-4093`). `getMyInvite` became stable at 3.44.0-m1 (introduced as draft in 3.43; `UP:contract-changelog.md:16-18`, `:41`); the operation description says 'stable since 3.44.0-m1' (`C45:390-391`) and the SchoolRegistration property agrees (`C45:4144-4146`). **Contract inconsistency to raise with Seif (added in verification):** the `UniversityRegistration.inviteCode` property at `C45:4179-4183` still reads 'this field is `draft` — send it only once it is `stable`, because an older backend refuses unknown properties with `validation_failed`'. It must be clarified before the university body sends `inviteCode`. `/refer` is a disabled shell (`refer_a_friend_screen.dart:9-19`). `getMyInvite` is `+10` points to the sharer once per new OTP-verified account, in their current Track's points; the new student earns none; 'no invite link and no web page' (`C45:1434-1450`). The handoff's Figma '500 to both' conflict is recorded, not decided here.

##### 2. Surface inventory (route, screen, provider, repository, operation)

Class vocabulary as in the other inventories.

| # | Area | Route | Screen | Provider / state | Repository, operation | Class | Evidence (SOURCE unless marked) |
|---|---|---|---|---|---|---|---|
| 1 | Onboarding | `/` | `OnboardingScreen` | none (locale only) | none | **implemented** | `onboarding_screen.dart:11-45`; CTAs `go('/login')` `:92-93`; signed-in bounce `app_router.dart:67,78-81` |
| 2 | Login | `/login` | `LoginScreen` | `loginProvider` (`login_notifier.dart:14-36`) | `AuthRepository.requestOtp` → `requestOtp` | **implemented** (+ gaps: placeholder legal URLs, no lost-phone entry, 'Create New Account' runs the same action, DESIGN_ISSUES #8) | `login_screen.dart:94-120,250-273` |
| 3 | OTP | `/login/otp` (nested, BUG-005) | `OtpScreen` | `otpProvider` autoDispose family `Notifier` (`otp_notifier.dart:69-220`) | `verifyOtp`, `requestOtp` (resend) | **implemented** (6 boxes, resend countdown, wrong-code state, offline). Lockout, ban and pending-deletion arrive only as the generic inline line | `otp_screen.dart:293-304`; `auth_error_copy.dart:10-30` |
| 4 | Registration wizard | `/register`, `/register/track`, `/register/school`, `/register/university` (all pre-auth) | `SignupIdentityScreen`, `SignupTrackScreen`, `SchoolDetailScreen`, `UniversityDetailScreen` | `RegistrationController`, `RegistrationSubmitNotifier` | `completeRegistration` | **implemented**; `inviteCode` **contract-not-integrated**; **no Terms step** | `app_router.dart:141-160`; `registration_submit_notifier.dart:48-130`; grep 'terms\|agree\|consent' in `features/registration` = 0 hits |
| 5 | Terms acceptance | none | none | none | `getTermsAcceptance`, `acceptTerms` | **contract-not-integrated** (stable at C28/C38/C45) | 0 callers in `lib/` |
| 6 | Legal documents | `/legal/privacy`, `/legal/terms` (signed-in only) | `LegalDocumentScreen` | none | none (`getLegalDocument` unused) | **stub** (`TODO(content)` shell) + **contract-not-integrated** at C45 | `legal_document_screen.dart:34-55`; `app_router.dart:426-435` |
| 7 | Login legal line | n/a | `_LegalLine` on Login | none | external `launchUrl` | **partial / dead links** (three `levelup.example` URLs, never in-app) | `login_screen.dart:43-48,122-124,380-421`; DESIGN_ISSUES #9 `:144` |
| 8 | Profile hub | `/account` (tab root), `/profile` | `ProfileScreen` | `meProvider` autoDispose (`me_notifier.dart:61-65`) | `getMyProfile` | **implemented** (loading skeleton, error, offline; no empty state by design). 9 rows: Settings live; Favorites and Your progress disabled; Refer and Support lead to shells; Privacy and Terms lead to shells; Go to Uni opens a dead dialog; Logout works | `profile_screen.dart:52-95,218-327` |
| 9 | Profile 'Solved Questions' card | in hub | omitted | none | `getMyQuizSummary` stable at C38/C45 | **contract-not-integrated** (S24 answered by contract, see §6) | `profile_screen.dart:38-41`; `C45:1727` |
| 10 | Edit Profile | `/profile/edit` | `EditProfileScreen` | `editProfileProvider` | `updateMyProfile` | **implemented** (name, email tri-state, avatarId editable; phone, city, school, grade read-only) | `edit_profile_screen.dart:33-62` |
| 11 | Avatar picker (defaults) | sheet | `AvatarActionSheet`, `ChooseAvatarSheet` | `avatarsProvider` | `listDefaultAvatars`, then PATCH `avatarId` | **implemented**. (Added in verification) once custom avatars exist, picking a default also deletes the custom photo (`UP:contract-changelog.md:83`) | `avatar_sheets.dart:15-30,130-231` |
| 12 | Avatar upload / remove | sheet row | 'Upload photo' row | none | `uploadCustomAvatar` (draft C28/C38/C45), `removeCustomAvatar` (draft C45) | **stub (dimmed, inert, with caption)** + **draft-only**; design exists (`180:3989`/`216:3158`, DOC `endpoint_ui_mapping.md:129`) | `avatar_sheets.dart:196-231`; DESIGN_ISSUES #106 `:4604` |
| 13 | Settings | `/settings` | `SettingsScreen` | `localeProvider`, `themeModeProvider`, `meProvider`, `editProfileProvider` | PATCH `/me` for 2 privacy booleans | **partial**: Languages live; Mode live (2 of the frame's 3 themes, S26/#45 **blocked**); Rank 2 toggles live; Notification Preferences 4 toggles **UI-without-backend** (inert, drawn ON; class doc `settings_screen.dart:341-356`, `value: true` + `disabledHint` `:400-421`) | `settings_screen.dart:44-85,129-250,272-421` |
| 14 | Registration track pick | `/register/track` | `SignupTrackScreen` | `registrationControllerProvider` | none | **implemented** | `app_router.dart:146-149` |
| 15 | `/track-select` | `/track-select` | `_Placeholder('Track select')` | none | none | **route-but-no-UI** (orphan; no `go`/`push` anywhere targets it) | `app_router.dart:161-164,477-499`; grep 'track-select' = 1 hit |
| 16 | Go to Uni | dialog (deliberately no route, `app_router.dart:391-394`) | `ProfileConfirmDialog` | none | `transferToUniversity` (draft C38, stable C45) | **stub** (Confirm hard-disabled) + **contract-not-integrated** | `profile_screen.dart:307-316,339-353`; `app_en.arb:562-566` |
| 17 | Account deletion (request) | none | none | none | `requestAccountDeletion` (stable at all 3 pins) | **backend-without-UI**; no design (`.ai/audits/current/wave_state.md:1607`) | 0 callers |
| 18 | Account deletion (cancel) | none | none | `pendingDeletion` decoded only; `isAccountPendingDeletion` predicate | `cancelAccountDeletion` (stable at all 3 pins) | **backend-without-UI** with partial plumbing | `exceptions.dart:95-135`; `student_profile.dart:77` |
| 19 | Lost-phone recovery | none | none | none | `startRecovery`, `verifyParentOtp`, `submitNewPhone`, `confirmRecovery` (draft C28/C38, **stable C45**) | **backend-without-UI**, **draft-only** at the working-tree pin | 0 callers |
| 20 | Session superseded | `/login` | snackbar in `LoginScreen` | `AuthController.forceLogout` | `session_superseded` on any 401 | **implemented as snackbar**; **impl-without-design** | `auth_interceptor.dart:75-78,145-152`; `auth_controller.dart:67-72`; `login_screen.dart:60-76`; tests `login_logout_message_test.dart:57,86` |
| 21 | Account banned | none | none | none | `403 account_banned` on `verifyOtp` (+3 ops) | **contract-not-integrated** (in neither vendored pin; the contract asks for a dedicated screen) | 0 hits |
| 22 | Logout | dialog from Profile | `ProfileConfirmDialog` | `AuthController.logout` | `logout` | **implemented** (best-effort revoke, clears tokens only, keeps `device_id`, invalidates session scope) | `profile_screen.dart:355-388`; `auth_controller.dart:76-85` |
| 23 | Subscription / entitlements | none | none | `entitlementsProvider` never watched | `getMyEntitlements` | **design-without-impl by decision** (purchase-silent); status display not built | §1.1; `lib/features/subscription/` empty |
| 24 | Refer a Friend | `/refer` | `ReferAFriendScreen` | none | `getMyInvite` (stable C45 only; stable since 3.44.0-m1) | **stub** (disabled Share control) + **contract-not-integrated** | `refer_a_friend_screen.dart` |
| 25 | Customer Support | `/support` | `CustomerSupportScreen` | none | support ops (draft C38, stable C45, text only) | **stub**; cross-reference only | `customer_support_screen.dart` |
| 26 | Friends | `/friends` | `FriendsScreen` | none | friend graph (12 ops stable at C38/C45) | **stub, no entry point**; its doc comment ('nothing behind it') is **stale** | `friends_screen.dart:7-24`; `ops_table.txt` |
| 27 | Push token | none | none | none | `registerFcmToken` (stable all pins) | **contract-not-integrated** (no Firebase dependency, `pubspec.yaml`); cross-reference only | 0 callers |

##### 3. Contract operations in this domain versus the app

Stability column is C28 / C38 / C45 (`-` = not in that pin).

| Operation | Stability | App | Note |
|---|---|---|---|
| requestOtp, verifyOtp, refreshTokens, logout, completeRegistration | stable / stable / stable | consumed | verifyOtp 429 lock `C45:200,234`; `account_banned` `C45:231` |
| startRecovery, verifyParentOtp, submitNewPhone, confirmRecovery | draft / draft / **stable** | not consumed | `C45:466,511,551,594`; `recovery_unavailable` 404 routes to the support path (`UP:error-codes.md:29`); `account_banned` on verifyParentOtp and confirmRecovery `C45:542,625`. (Added in verification) the whole anonymous ladder, recovery included, keeps working during the deletion grace window (`C45:74-79`) |
| getTermsAcceptance, acceptTerms | stable x3 | not consumed | `C45:1087,1116`; 'recorded, not enforced' (`C45:1122-1123`); `currentVersion` may be null (inert); `acceptTerms` is authenticated (absent from the 19-operation `security: []` list) |
| getLegalDocument | - / - / **stable** | not consumed | `C45:816`; public; `document` enum is `terms` or `privacy` only (no cookie policy, `C45:831`); 404 `legal_document_unavailable` when no Terms version is configured |
| listTerms | - / stable / stable, `x-consumers: [web]` | must not be consumed | academic terms, unrelated to legal Terms |
| getMyProfile, updateMyProfile | stable x3 | consumed | StudentProfile property set unchanged C28 to C45 (schema diff run this session); `avatar.type` may be `custom`; choosing a default `avatarId` also deletes an active custom photo (`UP:contract-changelog.md:83`) |
| uploadCustomAvatar | draft x3 | not consumed | `C45:982` |
| removeCustomAvatar | - / - / draft | not consumed | `C45:1042` |
| registerFcmToken | stable x3 | not consumed | `C45:1064` |
| requestAccountDeletion, cancelAccountDeletion | stable x3 | not consumed | `C45:1267,1315`; mandated confirm copy contains 'paid subscription is forfeited … no partial refund' `C45:1284-1285`; the 202 revokes the session and refresh chain (`C45:1276-1279`) |
| transferToUniversity | - / draft / **stable** | not consumed | `C38:1198`, `C45:1338`; refusal order `account_pending_deletion`, then 409 `track_transfer_not_allowed`, then 403 `track_transfer_not_eligible` (stage `secondary3` only), then 400 |
| getMyEntitlements | stable x3 | repository + provider only; never watched | `C45:1409`; 'no `pending` state' (`C45:1412`) |
| getMyInvite | - / - / **stable** (stable since 3.44.0-m1) | not consumed | `C45:1434`; `MyInvite {code, friendsJoined, pointsEarned}`; `inviteCode` on the University register body is still labelled draft (`C45:4179-4183`), contradicting `C45:390-391` and `C45:4144-4146` |
| getMyQuizSummary | - / stable / stable | not consumed | `{solvedQuestions}` |
| redeemSubscriptionCode, requestRedemptionSessionOtp, verifyRedemptionSessionOtp | stable x3, `x-consumers: [web]` | correctly absent | forbidden for the app |

##### 4. Area notes

**Onboarding.** Presentational only, no endpoint, no flag (`onboarding_screen.dart:34-36` explains why none is stored). Both CTAs go to `/login`.

**Login.** Phone is Egypt-only (`+20` chip). Always advances to OTP on 202 (anti-enumeration). States: button spinner, inline validation, inline server or offline error, `OfflineBanner` plus disabled CTAs (`login_screen.dart:135-141,226-253`). DEVICE walk 2026-09-24 (DOC `.ai/audits/current/device_walk_results.md:8-32`) passed requestOtp, offline banner and navigation. No entry for 'lost my phone'.

**OTP.**
- *Countdown.* Seeded from the server's `resendAfterSeconds`; a local one-second ticker; resend enabled at 0 (`otp_notifier.dart:176-216`). A 429 on resend sets only the inline error and leaves the countdown at 0.
- *`expiresInSeconds`.* Carried in `OtpArgs` and never displayed (grep).
- *Wrong code.* `otp_invalid` turns the cells red (`forceErrorState`) and the red state persists until the next verify; the pin field is not cleared (`otp_screen.dart:286`, no `clear()` call).
- *Lockout.* `otp_throttled` has copy (`errorOtpThrottled`) but no UI test; only the interceptor mapping is tested (`error_interceptor_test.dart:204-208`).
- *Verify outcomes.* `authenticated` writes tokens, then `markAuthenticated()`. `registrationRequired` seeds the wizard (`otp_screen.dart:67-84`). A popped screen mid-verify is guarded (`otp_notifier.dart:140,149`).

**Registration.** Phone-verify-first. The draft holds a 10-minute registration token. There is no Terms or consent step. The optional referral code is collected and dropped (see §1.13). Errors: `registration_token_invalid` and `phone_already_registered` restart at `/login` (`registration_error_copy.dart:70-81`).

**Terms and legal.** See §1.7. The contract says the text is 'rendered IN the app rather than by opening a browser' (`C45:816-830`, Seif 2026-10-07), is public, cacheable (ETag) and shown 'during registration and from settings'. `getTermsAcceptance` returns `currentVersion: null` while the feature is inert, and then every `acceptTerms` is refused. `acceptTerms` is authenticated and `completeRegistration` returns tokens, so a pre-account consent step is not possible: acceptance can only be asked right after the registration 201 or at first sign-in (added in verification). At the API level acceptance is soft: 'recorded, not enforced: no other operation refuses a student who has not accepted' (`C45:1122-1123`), with one exception, photo uploads (avatar and support), which answer `403 terms_acceptance_required` (`C45:1025`) and only once a Terms version is configured (`UP:error-codes.md:67`, 'Inert while no current Terms version is published'). Acceptance 'is not parent consent' (`C45:1096`). Login's third link is 'Cookie Policy'; `getLegalDocument` has no cookie document (enum `terms`, `privacy`, `C45:831`).

**Profile and Edit Profile.** Wiring is clean; `meProvider` is the single source (Home, Profile, Edit Profile, Settings all watch it). The `/me` allowlist during pending deletion is `GET /me` only, so a save answers 403, which the app handles with the pending-deletion copy (`profile_error_copy.dart:19-24`). `Solved Questions` and `Rank` cards are omitted; S24 is answered by `getMyQuizSummary`; S25 stays open ('HERO' tier string not producible).

**Settings.** No Terms, Privacy, deletion or logout entry. Notification Preferences render ON and disabled with 'Notification settings aren't available yet.' (`app_en.arb:633`). The contract through C45 has no preference-storage path (full path list checked; only `/me/notifications`, `/me/notifications/unread-count` and `/me/notifications/{notificationId}/read` match 'notification'), so these toggles remain UI-without-backend (DESIGN_ISSUES #45 `:1202`). BUG-017 (the help line contradicts adr-111) is still open per `docs/KNOWN_BUGS.md:570`.

**Session.** Tokens live in `flutter_secure_storage` only; iOS accessibility `first_unlock_this_device`, no iCloud sync; Android backup disabled (`AndroidManifest.xml:34-36`). `device_id` is a 32-hex id kept across logout (`secure_storage.dart:51-83`). No `print` or `log` call exists in `lib/` outside `lib/dev` (grep). Refresh is single-flight and loop-safe (`auth_interceptor.dart:119-156`). A dead refresh chain gives `sessionExpired`; a superseded device gives `supersededOtherDevice`. The cold start resolves auth from token presence only (`auth_controller.dart:43-48`). A banned account's open sessions are revoked server-side (`UP:contract-changelog.md:65`), so the student sees 'Your session expired' and then, at the next sign-in, the generic OTP error (SOURCE reasoning from `auth_error_copy.dart`, plus the changelog line above; not observed on a device). `SecureStorage.clear()` (full wipe, documented for 'account deletion / reinstall semantics', `secure_storage.dart:61-64`) has no caller in `lib/`; logout and forced logout call `clearTokens()` only (`auth_controller.dart:67-85`) (added in verification, grep).

**Subscription / entitlements.** See §1.1 and §5.

##### 5. Purchase-silence check (adr-049 §3)

Commands, all against non-generated `lib/` and both ARB files.
- `grep -rniE 'price|EGP|paywall|checkout|subscribe|upgrade|redeem|Paymob|Fawry|purchase|buy|payment|premium'`
- `grep` for Arabic equivalents (اشتر, سعر, جنيه, ادفع, دفع, ترقية, اشتراك)
- `grep -rn 'url_launcher\|launchUrl\|canLaunchUrl'`

Result: **no price, EGP amount, paywall, checkout, Paymob, Fawry, redeem or purchase surface exists in code or ARB.** Remaining hits are doc comments declaring the rule, ARB `@description` metadata that is never rendered (`app_en.arb:509,514,518,733`), `entitlement_state.dart` / `me_notifier.dart` comments, the removal notes in `app_router.dart:477-499`, and subscription-required **copy**. Re-run in verification with the same result; `url_launcher` / `launchUrl` appear only in `login_screen.dart:6,44,123`, no file in `test/` mentions them, and `test/guards/` has 0 hits for `launchUrl`, paywall, purchase or subscribe.

| Finding | Where | Assessment |
|---|---|---|
| Only `url_launcher` use | `login_screen.dart:122-124` (3 legal links, placeholder `levelup.example` URLs) | Not a purchase hand-off. Placeholder, never resolves. |
| 'Subscribe to get step-by-step explanations…' / AR 'اشترك لتحصل…' | `app_en.arb:516`; AR `app_ar.arb:206`; `limit_sheet.dart:61-66` | **Documented exception**: contract-verbatim approved copy (`C28:1722`, `C38:1892`, `C45:2069`) and owner ruling D-015 (`docs/DECISIONS.md:851`). It carries no price, link or button, but it is an imperative 'Subscribe'. The earlier roadmap treats it as an Apple 3.1.1 risk; whether to keep it is an owner decision. |
| 'Subscription Required' title; 'needs an active subscription' | `app_en.arb:511-512,527` (AR `app_ar.arb:204-206,211`) | Names the entitlement, no destination. DESIGN_ISSUES #51 point (3) leaves the title as product's call. |
| Deletion confirm copy mandated by the contract mentions 'paid' and 'refund' | `C45:1282-1286` | Not built yet. (Corrected in verification) The earlier text said this conflicts with the contract's own vocabulary rule at `C45:2451`. That rule sits inside the web-only `redeemSubscriptionCode` description and bans price, 'buy', 'purchase', 'payment' and a provider name; 'paid' and 'refund' are not on that list. The tension is with adr-049 §3's intent (the app never talks about buying or paying) and the Apple 3.1.1 exposure, and the question to Seif should be framed that way. Open as Q-B2 / DR-03 in `.ai/audits/current/release_readiness_reconciliation_2026-10-06.md:184,206`. |
| Mechanisation | `test/guards/*.dart` | No repo-wide guard greps `launchUrl` or purchase vocabulary; coverage is per-string tests (`account_pending_deletion_test.dart:178-196`, `profile_screen_test.dart:155`). The rule is prose-enforced, so it can drift. |

**Verdict:** no violation of adr-049 §3 in the shipped code. One imperative-copy exception is owner-ruled. Handoff item 1's website link would be the **first** violation.

##### 6. Handoff cross-check (account half)

| Handoff item | Verdict | Evidence |
|---|---|---|
| (1) Subscription screen becomes status plus website link | **Partly contradicted**: status-only is allowed; the link is not (see §1.2). | `contract-changelog.md:443,201,205`; RISKS R-10; DESIGN_ISSUES #51 |
| (1) 'Figma Subscription screen is incompatible' | Consistent: the Profile row is absent although Figma still draws it. | DOC `.ai/audits/current/figma_ui_comparison.md:123`; `profile_screen_test.dart:155` |
| (2) Avatar upload 'not previously backed' | **Outdated**: `uploadCustomAvatar` has been in the contract (draft) since at least C28, still draft at C45. | `ops_table.txt`; `C45:982` |
| (2) Settings preferences, Progress | **Confirmed still unbacked** through C45 (no preference or progress path; `listQuizHistory` and `getMyQuizSummary` do not equal the 'your progress' frame, S32). | path list of `C45` |
| (2) Referral 500 vs 10 | Contract side verified (+10 inviter, nothing for invitee, `C45:1434-1450`). The Figma '500' side is **not verified** (the Figma MCP needs authorisation and Figma was not read). | `C45` |
| (3) Terms step, deletion, cancellation, recovery, 'another device', limit and lockout pop-ups, empty/loading/offline: 'backend built, design missing' | Mostly right; nuances: limit pop-up has light Figma frames (with the forbidden CTA) and only the dark frame is missing; 'another device' is built as a snackbar and the contract asks for a screen; **account banned** is a contract-requested dedicated screen with no frame; recovery and cancel-deletion are coupled by the contract (`C45:74-79`). | §7 table |
| (4) Photo limits; 'exact endpoints will come next' | Limits match the contract (avatar 2,097,152; support 7,000,000; 3 per message; 10 per ticket). **The endpoints are already in C45** (support: 3 draft ops `C45:2849`...; avatar `C45:982`). Photo flows also need Terms accepted. | `C45` |
| (8) `transferToUniversity` draft vs stable-only | **Dissolved upstream** by 3.39 (stable). At C38 it is draft with the changelog line 'do NOT ship it to students yet; the screens may be built against it now'. | `contract/contract-changelog.md:7`; `UP:contract-changelog.md:107-110` |
| (8) `Accept: application/json` | **Confirmed gap**, see §1.11 (pin-independent). | `dio_client.dart:15-20`; `UP:contract-changelog.md:182-185` |
| (8) old comment in `error_interceptor.dart` | `error_interceptor.dart:9` 'TODO(contract): full mapping … lands per-feature' is still literally true; `account_banned` and the transfer and deletion codes have no mapping. | SOURCE |
| (8) S11 favourites | Still open at C38 (draft). Stable at C45 (`addFavorite`, `removeFavorite`, `listFavorites`). Profile row stays disabled (`profile_screen.dart:240-247`). | `ops_table.txt` |
| (8) FriendScreen TODO stale | **Confirmed stale** (friend graph stable since 3.37). S36 entry-point question is still open: the Profile frame draws no Friends row. | `friends_screen.dart:7-24` |
| (8) S24 answered by `/me/quiz-summary` | **Confirmed** (`solvedQuestions`), Profile card still omitted. | `C45:1727`; `profile_screen.dart:38-41` |
| (8) contract line references shifted | **Confirmed for two anchors, not for all** (corrected in verification): `F:\level\CLAUDE.md:11` cites `openapi.yaml:754` for 'no pending'; the sentence is at `:1148` (C28), `:1272` (C38), `:1412` (C45). `student_profile.dart:30-76` cites `:2430-2436` for `pendingDeletion`; it is at `:2753` (C28), `:3676` (C38), `:4311` (C45). Other anchors still resolve: `student_profile.dart:88` (`:83`), `exceptions.dart:103` (`:62-71`) and `profile_error_copy.dart:16` (`:67-69`) are correct at C38 and C45. | greps this session and in verification (`cmp` showed the worktree snapshot byte-identical to `contract/openapi.yaml`) |
| (App IDs requested: Android package + iOS bundle) (added in verification) | Out of this dimension; cross-reference to the environment chapter. Android `applicationId` is `com.levelupworld.app`; the iOS bundle identifier is still `com.levelup.levelUpApp`. | `android/app/build.gradle*:31,55,76`; `ios/Runner.xcodeproj/project.pbxproj:371` |

##### 7. Handoff section-5 table

Legend: Impl = Flutter implementation; Route = routed destination; Design = design record in `docs/DESIGN_ISSUES.md`, `.ai/audits/current/wave_state.md`, `figma_ui_comparison.md`, `endpoint_ui_mapping.md`. Contract column is the operation and stability at C38 / C45.

| Item | Impl? | Route? | Design record? | Contract (C38 / C45) | Blocked by design? | Independently implementable? | Product decision missing? |
|---|---|---|---|---|---|---|---|
| **Terms step** | No. No call, no checkbox. Passive consent text on Login only | No gate route. `/legal/terms` and `/legal/privacy` exist as signed-in-only shells | Passive consent text `82:1086` on Login `82:819` only (DESIGN_ISSUES #9 addendum; DOC `endpoint_ui_mapping.md:127`: 'no checkbox, no screen'). No step frame | `getTermsAcceptance`, `acceptTerms`: stable / stable. `getLegalDocument`: absent / stable | Yes for the acceptance step. No for a plain in-app document viewer (existing shell chrome) | Partly: un-gate `/legal/*` and render `getLegalDocument` Markdown (needs a renderer dependency). Seif's changelog says `getLegalDocument` answers 200 on staging at `11ab701` (`UP:contract-changelog.md:37-38`, DOC, not verified here) (added in verification). The acceptance step needs a design | Yes: where acceptance is asked (`acceptTerms` is authenticated and `completeRegistration` returns tokens, so right after the registration 201 or at first sign-in; the text is shown 'during registration and from settings', `C45:819-820`); whether the app gates on acceptance (soft at API level, 'recorded, not enforced', `C45:1122-1123`, except photo uploads, `403 terms_acceptance_required`, `C45:1025`, inert while no Terms version is published, `UP:error-codes.md:67`); Cookie Policy link (enum is `terms` or `privacy` only); who owns the text (S30); the endpoint 'is not parent consent' (`C45:1096`) |
| **Track-transfer confirmation** | Partial: dialog exists, Confirm hard-disabled; row shown to both tracks | No route by design (dialog) | Dialog frames `180:4301`, dark `337:7561`, RTL `549:21179` (wave_state `:1388`). No frames for the university/faculty/year pickers, the second confirmation, or the University disclosure the contract requires (`C45:1338-1360`) | `transferToUniversity`: **draft / stable** | Yes for the flow beyond the one dialog | No (design; and C38 is draft). Registration pickers could be reused (SOURCE `reference_providers.dart`) | Yes: show or hide for University-track students (the University frame draws it; the contract says to render the University track and never offer the transfer again, `UP:error-codes.md:59`); eligibility copy ('opens in the final school year'); disclosure copy; DR-24 |
| **Account deletion** | No | No | None: 'No account-deletion frame exists anywhere on the design page' (wave_state `:1607`); DESIGN_ISSUES #62 `:2048` | `requestAccountDeletion`: stable / stable | Yes | No | Yes: mandated confirm copy has 'paid' and 'refund' (Q-B2 / DR-03; the tension is with adr-049 §3's intent and Apple 3.1.1, see §5). Web deletion URL for Play (E-8): the contract says none exists and calls the Play Data-safety web leg 'a separate, still-unowned decision' (`UP:contract-changelog.md:499`), so this is an owner decision, not a contract gap (added in verification). Local wipe semantics: the token half is fixed by the contract, the 202 revokes the session and refresh chain and the client must 'send the student to the login screen and purge the token pair' (`C45:1276-1279`); `SecureStorage.clear()` has no caller and logout clears tokens only (`secure_storage.dart:61-64`, `auth_controller.dart:67-85`); whether anything beyond the token pair (for example `device_id`) must be wiped is not addressed in the contract text read (UNKNOWN beyond that) (added in verification) |
| **Account cancellation (cancel deletion)** | No. Plumbing only: `pendingDeletion` decoded, `isAccountPendingDeletion` predicate, copy at five code sites (`catalog_states`, `flashcards_error_copy`, `board_failure`, `profile_error_copy`, `quiz_error_copy`; the Mistakes overview reuses `catalog_states`), Retry withheld | No | None (DESIGN_ISSUES #62: 'no cancel screen, no route') | `cancelAccountDeletion`: stable / stable; `GET /me` `pendingDeletion` | Yes (screen) | Partly: the 403 routing hook and a guard can be built; the screen needs design and copy | Yes: where a pending student lands; whether the router redirects on `/me`. Whether any non-app channel can create requests: **answered**, the contract publishes none (`UP:contract-changelog.md:499`), so until the app ships the request screen no product surface starts a grace window (CONTRACT/DOC inference; staging not probed). Coupling (added in verification): the anonymous ladder, recovery included, works during grace 'so a student who lost their device must be able to recover an account in order to cancel its deletion' (`C45:74-79`), so cancel and recovery are designed to be used together |
| **Lost-phone recovery (4 steps)** | No | No | Weak: OTP frame `82:1171` carries recovery-variant copy (DOC `endpoint_ui_mapping.md:133`); no flow frames | `startRecovery`, `verifyParentOtp`, `submitNewPhone`, `confirmRecovery`: **draft / stable** | Yes | No (design; and C38 is draft) | Yes: Login entry point; the support path for `recovery_unavailable`; parent-OTP and new-phone screens; interaction with `account_banned` (on `verifyParentOtp` and `confirmRecovery`). Dependency (added in verification): recovery relies on a parent number the student can neither see nor change, `parentPhone` is required at registration (`C45:4141,4153,4176`) but absent from StudentProfile and not among PATCH /me's five fields; already filed as `docs/seif_fight.md:1322` S34; `edit_profile_screen.dart:59-62`. Coupled with cancel-deletion (`C45:74-79`) |
| **Logged-in-on-another-device screen** | Partial: forced logout plus one-time snackbar on `/login` | `/login` | None, 'infrastructure, not a designed screen' (`day1b_forced_logout_brief.md:4-7`). The contract text mentions a 'forced-logout screen' (`C45:58-60`) | `session_superseded` 401: stable x3 | No for the current snackbar; yes for a dedicated screen | Yes for the current behaviour (already done, tests exist); a dedicated screen needs design | Whether the snackbar is acceptable for release |
| **Limit pop-ups** | Yes: `LimitSheet` for `POST /quizzes` and `submitAnswer` 403s and the explanation popup; flashcards use inline lines | Dialog | Light frames `199:2335`, `225:6634`, `225:7001` (draw the forbidden 'Upgrade' CTA); dark frame missing (DESIGN_ISSUES #51 `:1581`, #74 `:3234`) | `weekly_question_limit_reached`, `subscription_required`, `flashcard_subscription_required`: stable x3 | Dark scrim only | Yes (built) | Copy is 'provisional engineering copy' (D-007); the 'Subscribe' exception (D-015) |
| **Lockout pop-ups** | No pop-up. Inline text 'wait a moment' for `otp_throttled` | n/a | None (OTP error line only, DESIGN_ISSUES #49) | `429 otp_throttled`: stable x3 (15-minute lock, `C45:200`) | Yes for any pop-up | Partly: accurate copy and no-hammer behaviour can be built; a lock countdown needs a duration source, and `Retry-After` is documented on other 429s but not on `otp_throttled` (`C45:234`; `UP:error-codes.md:12`), so it is UNKNOWN whether it is sent | Yes: pop-up versus inline; show the 15 minutes or not; confirm whether `Retry-After` is sent (Q-B5) |
| **Empty states** | Per feature. None on the account screens: Profile and Edit Profile have no empty state by design (`profile_screen.dart:48-51`) | n/a | No Figma empty-state frames cited for the account cluster | n/a | n/a | Yes where a list exists | No for this cluster |
| **Loading states** | Yes: Profile and Edit Profile skeletons, button spinners on Login, OTP and registration submit, Settings Rank loading | n/a | Shapes follow frames (comments), no dedicated loading frames | n/a | No | Yes | No |
| **Offline states** | Yes: `OfflineBanner` with CTAs disabled on Login, OTP, all 4 registration screens, Profile, Edit Profile, Settings; Profile has a dedicated offline view | n/a | Built from shared widget; Login offline DEVICE-walked (DOC `device_walk_results.md:26`) | n/a | No | Yes | No |
| **Account banned** | No (generic error) | n/a | None | `403 account_banned`: not in C38 / declared on 4 stable ops at C45 (`verifyOtp`, `verifyParentOtp`, `confirmRecovery`, `verifyRedemptionSessionOtp`; the last is web-only); contract suggests EN 'Account banned — contact Support', AR 'تم حظر الحساب — تواصل مع الدعم' (the client owns the strings) | Yes for the dedicated screen the contract asks for ('What to build: a "this account has been banned — contact Support" screen. Do not retry.', `UP:contract-changelog.md:66`); no frame exists. (Corrected in verification: the earlier text said 'copy and layout only') | Yes at the plumbing level (map the code, no Retry); the screen and copy need design and approval | Yes: a signed-out banned student has no authenticated Support channel in the contract. Re-checked in verification: all 19 `security: []` operations at C45 are auth, recovery and reference reads, none is a support operation |

##### 8. Dependencies and ordering (inputs for the completion workflow)

1. **Pin decision first (DR-23, DR-24).** Everything marked 'stable at C45 only' (recovery, track transfer, `getLegalDocument`, `account_banned`, `getMyInvite`, `inviteCode`) waits for it. Whether 3.45 itself is deployed to staging is not established: Seif's changelog says the 3.39-stable operations are 'deployed to staging' (`UP:contract-changelog.md:108`) and that staging served `11ab701` at the 3.43 entry (`:37-38`), nothing newer (DOC).
2. **Design-free plumbing** (no new screens): add `Accept: application/json`; map `account_banned` and `account_pending_deletion` in `authErrorMessage`; stop offering Retry where the contract says not to; accurate `otp_throttled` copy. This needs only the copy decisions above. The banned case still wants a screen per the contract; the plumbing is the mapping and no-retry only.
3. **Legal in-app** (DR-14): add `/legal/*` to the pre-auth set, render `getLegalDocument`, replace Login's `levelup.example` links. Needs a Markdown renderer choice and Cookie Policy ruling.
4. **Terms acceptance** gates avatar upload and support photos (`terms_acceptance_required`), both still draft.
5. **Account deletion request plus cancel** is a store-mandatory P0 (E-3 in the reconciliation) blocked by design and copy. The request's 202 forces a purge of the token pair and a return to login (`C45:1276-1279`).
6. **Recovery and track transfer** need designs and the 3.39+ pin. Recovery should be planned together with cancel-deletion (`C45:74-79`) and with S34 (`parentPhone` write-only).
7. **Subscription status screen**: data is already decoded; the screen waits on the adr-049 decision and a replacement design.
8. **Referral** needs the 3.44 pin, the reward-value ruling, sending `inviteCode`, and Seif's clarification of the `UniversityRegistration.inviteCode` draft wording (`C45:4179-4183`) before the university body sends it.
9. **Profile Solved Questions** is buildable on `getMyQuizSummary` once the 3.38 re-vendor lands (frame exists).

##### 9. Stale project records found

- `.ai/audits/current/api_ui_endpoint_inventory.md:77` and `screen_api_gaps.md:56` list the terms pair as draft; it is stable at C28, C38 and C45.
- `.ai/audits/current/screen_api_gaps.md:57` and `api_ui_endpoint_inventory.md:75` list recovery as draft; stable at C45.
- `docs/seif_fight.md` S31 (`:1265`) says track transfer has no endpoint and asks the points question; the contract answers it (`C45:1352-1364`).
- `friends_screen.dart:7-24`, `refer_a_friend_screen.dart:6-15` and `profile_screen.dart:262-266` describe contract gaps that closed at C38 (friends) and C45 (referral).
- `app_localizations.dart:1679` doc comment still says the cancel screen 'does not exist yet' (true) while the string tells the student to cancel.
- Contract line anchors that drifted: `F:\level\CLAUDE.md:11` (cites `openapi.yaml:754`, now `:1412` at C45) and `student_profile.dart:68` (cites `:2430-2436`, now `:4311` at C45). Not every anchor is stale: `student_profile.dart:88` (`:83`), `exceptions.dart:103` (`:62-71`) and `profile_error_copy.dart:16` (`:67-69`) still resolve (corrected in verification; see §6).
- `docs/RISKS.md` R-10 cites the adr-049 §3 sentence at `contract/contract-changelog.md:360`; in the uncommitted re-vendored file it is at `:443`.
- `secure_storage.dart:62-66` states secure storage 'is cleared on uninstall'. That holds for Android here (backup disabled) and is **unverified for iOS Keychain** (UNVERIFIED lead; needs a Mac).

### 5.6 Social, chat, support, notifications, states (detail)
_Verification (Fable): 17 claims - 15 confirmed, 2 partial (corrected), 0 refuted (corrected), 0 unverifiable (the Figma half of five confirmed claims, K4, K5, K7, K11 and K12, could not be re-read because the Figma MCP is unauthenticated in this session; it stays DESIGN-level and is corroborated by `results/inv_design.md`). Also: 7 section errors fixed, 8 omissions added (marked "added in verification"), 3 further corrections from the correction pass (marked "added in correction")._

#### Feature inventory: social, chat, support, notifications, cross-cutting states

Investigator: social-half feature inventory. Read-only. Repo HEAD `8e641e9`, `git status` unchanged before and after (only the five `contract/` re-vendor files and the two untracked roadmap files).

##### 0. Conventions

Levels follow the task: CONTRACT, SOURCE, DOC, BUILD, ARTEFACT, DEVICE, CI. The investigator ran no build, test, device or staging call, so nothing in the investigator's text is above SOURCE/CONTRACT. One level is added, **DESIGN**: text and structure read from Figma file `P6044i0giD9TmdQ7C2AmLq` on 2026-10-08 with `get_metadata` (and one `get_design_context`) on individual safe nodes (162:2797, 166:3156, 166:4260, 166:4319, 171:5031, 176:2425, 178:2759, 178:2800, 178:3222, 178:3378, 180:8554, 215:2628, 216:3784). Node 1240:9847 and page 57:36 were never requested. DESIGN is "what the designer drew", not what ships, and a frame I did not read is "not found", not "does not exist". The verification and correction passes could not re-read Figma (MCP unauthenticated), so every DESIGN statement below is the investigator's read, corroborated where noted by `results/inv_design.md` (an independent same-day read) or by a repo record.

A second level is added in verification: **RUNTIME** = an unauthenticated HTTP GET against the staging host (status codes and the public `/health/version` body only; no token, no app, no device). It proves a route or hub is deployed on the 2026-10-08 staging build; it proves nothing about request or response shapes or behaviour, and it is below DEVICE.

Contract pins, with the scratch copies used (`SCRATCH` = the session scratchpad):
- **3.28** = `0df5cf4`, committed (`SCRATCH/openapi_0df5cf4.yaml`).
- **3.38** = `65245be`, the uncommitted working tree (`contract/openapi.yaml`).
- **3.45** = `2e5bb69`, upstream HEAD, "Mirror contract from level-up-backend@f5e5424a..." committed 2026-10-08 12:29 UTC (`SCRATCH/openapi_2e5bb69.yaml`; it has the same content as `SCRATCH/upstream-contract/openapi.yaml` after LF normalisation, but the clone copy has CRLF line endings, so the files are not byte-identical; line numbers match). Cited as `@3.45:LINE`.

The project rule is "build only against `x-stability: stable`" (`level_up_app/CLAUDE.md`, non-negotiables).

##### 1. Headline findings

1. **The app makes zero API calls for any social, chat, support, inbox, referral, friend-streak or push operation.** Repositories exist only for auth, registration, reference, profile (`/me`, `/me/entitlements`, `PATCH /me`), catalogue, quiz, mistakes, leaderboard and flashcards (`grep "_dio.(get|post|put|patch|delete)" lib` lists 26 call sites in those repositories). `registerFcmToken`, the three inbox operations and every `/friends`, `/friend-requests`, `/blocks`, `/conversations`, `/support`, `/me/invite` path have no call site; the only `lib/` hits for those paths are comments (`friends_screen.dart:7-12`, `customer_support_screen.dart:7`, `settings_screen.dart:344`, `app_router.dart:417/423`, `profile_screen.dart:282`) (SOURCE).
2. **Four routed surfaces are static shells or placeholders** whose controls are dead by design. `/refer`, `/support` and `/friends` render `ShellBody`; `/message` renders the "Coming soon" tab placeholder (SOURCE, table 2). Existing tests pin this (`test/features/settings/shell_screens_test.dart:37-227`, `test/features/shell/main_shell_test.dart:162-167`), so each build wave must change them in the same commit.
3. **Contract readiness is very different at the three pins.** At 3.38 only the friend graph and blocks (12 `social` operations) and the inbox are stable; the 8 `chat`-tag operations (six core operations plus `reportChatMessage` and `reportStudent`) and the 5 support-ticket operations are still draft. At 3.45 all of those are stable, plus `getMyInvite`, `forwardQuestion`, `answerForwardedQuestion` and `listMyFriendStreaks` (the `chat` tag then holds 10 operations, the `social` tag 13). The only social-adjacent drafts left at 3.45 are the 3 support-attachment operations and the 2 avatar operations (table 3; `SCRATCH/ops_table.txt`; re-derived by the verifier and again in the correction pass with PyYAML: 3.28 = 54 ops / 38 stable / 16 draft, 3.38 = 77 / 53 / 24, 3.45 = 86 / 81 / 5). Pinning at 3.38 therefore unlocks the friend graph only (on top of what is already stable at 3.28, such as the inbox and the Terms pair).
4. **Chat photos, chat voice and group chat have no operation at any pin, and the contract says so.** `realtime.md@3.45:17` ("Photo, voice and group chat are not part of it") and `openapi.yaml@3.45:143-150` (chat tag). Figma draws photos and voice; I found no group frame (DESIGN, section 3.3).
5. **The inbox has been `stable` since the committed pin (3.28), yet the app still says "no notifications endpoint".** `listMyNotifications`, `getUnreadNotificationCount` and `markNotificationRead` are stable at `0df5cf4:984,1034,1053` (CONTRACT; the upstream changelog dates the flip to 2026-09-26, `contract-changelog.md:211`, before the 3.28 pin). The Home bell comment (`lib/features/home/widgets/home_header.dart:14-17, 29-36`) and the `/message` doc (`lib/features/shell/screens/tab_placeholder.dart:54`) are stale. The existing `.ai/audits/current/notification_inbox_3_28_investigation.md` (DOC) already says so.
6. **The referral contradiction is real and confirmed on both sides.** Figma `178:2646` reads "When a friend signs up with your code, you both earn 500 bonus points!". The contract rule is +10 points to the sharer only, nothing to the new student (`getMyInvite`, `@3.45:1434-1450`; changelog 3.43 repeats it). No `lib/` or ARB copy mentions a referral amount (grep `500` in `lib/`: only level thresholds, `kPointsPerLevel = 500` at `level_card.dart:23`, and typography comments).
7. **Push does not exist at all.** No Firebase or notification package, no `POST_NOTIFICATIONS`, no native localized strings, no Firebase files, no iOS push capability (SOURCE, section 3.6). Delivery is off in every environment (`realtime.md@3.45:80`). The push SHAPE (kinds, keys, payload, tap handling) exists in the contract only from 3.43; the 3.38 working-tree `realtime.md` has no push section, only a one-line note that chat push "is inert until the adr-129 gate opens" (`contract/realtime.md:61`) (added in verification).
8. **Cross-cutting state handling has shared building blocks but no mechanical guard** (section 3.7).
9. **The social surfaces are user-generated content for store-policy purposes.** Chat messages, forwarded cards, support photos and custom avatars need in-app report, block and Terms acceptance. `.ai/audits/current/store_readiness_matrix.md:24` says "no moderation op"; that is stale. `blockStudent` has been stable since 3.37 and `reportStudent` since 3.39, and `LeaderboardEntry` already carries `studentId` (`lib/features/leaderboard/models/leaderboard_models.dart:73`). The Terms-acceptance pair needed for the gate is already stable (item 11).
10. **Staging already serves the 3.43-3.45 routes and the chat hub (added in verification, RUNTIME, 2026-10-08, re-run in the correction pass).** `GET https://level-up-backend-staging.up.railway.app/health/version` returns 200 `{commit: a158daa3..., environment: Staging, builtAtUtc: 2026-10-08T15:16:14Z}`; that backend commit is newer than the one the 3.45 contract mirrors (`f5e5424a`, 12:29 UTC), so staging may carry changes not yet in any contract. Without a token, `/hubs/chat`, `/api/v1/me/invite`, `/api/v1/friend-streaks`, `/api/v1/conversations`, `/api/v1/support/tickets` and `/api/v1/me/notifications` all answer 401, while a control path `/api/v1/nonexistent-probe-zz` answers 404. 401 against 404 shows the routes exist; `/health/version` carries a commit, not a contract version string, so the exact contract version staging implements is still not readable. Base URL: `lib/core/config/app_config.dart:43-44`.
11. **The Terms-acceptance pair (`getTermsAcceptance`, `acceptTerms`) is `stable` at all three pins, including the committed 3.28 (added in verification).** `0df5cf4:922-923, 951-952`; changelog 2026-09-24 (`contract-changelog.md:232`); same in my PyYAML parse of 3.38 and 3.45. The Terms gate that chat, support photos and the UGC duty depend on is therefore buildable without a re-vendor. See 3.4 for the `currentVersion: null` caveat.
12. **A banned student gets the generic error at sign-in (added in verification).** `403 account_banned` (new in 3.42; absent at 3.28 and 3.38) is returned after a correct code on `verifyOtp`, `verifyParentOtp`, `confirmRecovery` and `verifyRedemptionSessionOtp` (`@3.45:231, 371, 542, 625`; `error-codes.md@3.45:51`). `lib/features/auth/auth_error_copy.dart:10-25` maps only `otp_invalid`, `otp_expired`, `otp_throttled` and `validation_failed`, everything else becomes `genericError`, and `grep account_banned lib` is empty (SOURCE). This is the handoff's "Lockout pop-up" item.

##### 2. Route to screen to provider to repository to operation

| Route (`lib/core/router/app_router.dart`) | Screen | Provider / repository | Operation(s) consumed | Notes (SOURCE) |
| --- | --- | --- | --- | --- |
| `/refer` (:415) | `ReferAFriendScreen`, `refer_a_friend_screen.dart:20-45` | none | none | `ShellBody(icon: share, message: referUnavailable)` plus `DisabledActionButton` (`refer_share_button`). Entry: Profile row `profile_screen.dart:267-272`. TODO(contract) S5 at :9-19 is stale. |
| `/friends` (:423) | `FriendsScreen`, `friends_screen.dart:22-43` | none | none | **No entry point anywhere**: `grep "'/friends'" lib` hits only the router (`app_router.dart:420-423`); the Profile frame draws ten rows and none is Friends (`friends_screen.dart:15-19`). TODO(contract) S36 at :9-19 is stale since 3.37. |
| `/support` (:416-419) | `CustomerSupportScreen`, `customer_support_screen.dart:17-42` | none | none | Disabled "Create Ticket" (`support_create_ticket_button`). Entry: Profile row `profile_screen.dart:278-283`. |
| `/message` (:311-318) | `MessagePlaceholderScreen`, `tab_placeholder.dart:54-61` | none | none | Renders `comingSoon`. The doc comment (:54) calls it "the in-app inbox (admin broadcasts, end-of-year promotion)". No badge in the nav (`main_shell.dart:56-62`). |
| Home bell (in `/home`) | `HomeHeader` / `_BellChip`, `home_header.dart:18-156` | none | none | No tap handler. `hasUnreadNotifications` defaults false (:23, :36); `home_screen.dart:83` passes no flag. `test/features/home/home_header_unread_test.dart` pins the dot absent. |
| `/settings` | `_NotificationsSection`, `settings_screen.dart:341-421` | none | none | Four ON-but-disabled toggles (`notifAnnouncements`, `notifPromotions`, `notifSupport`, `notifSystem`). Contract has no preference storage (S28). |
| `/register/*` | `signup_identity_screen.dart:46, 86-94, 182-187` | `registration_controller.dart:38-50` | `completeRegistration` (no invite code) | "Referral Code (Optional)" is collected and **not submitted** (`registration_draft.dart:17`, `school_registration.dart:96`, `university_registration.dart:78`). |
| `/track-select` (:161-164) | `_Placeholder('Track select')` | none | none | **Orphan**: nothing navigates to it (`grep track-select lib` hits only the router). |
| `/legal/privacy`, `/legal/terms` (:426-435) | `LegalDocumentScreen` | none | none | Shell with `legalNotPublished`. The shell says the blocker is text, not an endpoint (see section 7). |
| (none) | no route for: notifications list, ticket list or detail, friend requests, blocked list, conversation list or thread, referral stats | | | These are the targets a push tap must open (section 3.6). The full route list `app_router.dart:100-437` has no `/notifications`, `/support/:ticketId`, `/friend-requests` or `/conversations` route. |
| Dev harness | `lib/dev/mock_backend.dart:19-20` pins `f462968`/3.27.0-m1 | | | Has no route for any of these operations (an unmocked call becomes a 404 problem). `tool/smoke/real_api_smoke_test.dart` has no social, inbox, support or invite probe (grep). |

##### 3. Area by area

###### 3.1 Referral

- **App:** shell only (table 2). Registration collects a code and drops it. ARB: `referralCodeOptional`/`referralCodeHint` (`lib/l10n/app_en.arb:104-105`), `referUnavailable`, `shareInvite` (:640-641).
- **Contract (3.45):**
  - `getMyInvite` `GET /me/invite`, stable (`@3.45:1434`). Returns `MyInvite {code, friendsJoined, pointsEarned}` (:4193-4211). `code` matches `^[0-9A-HJKMNP-TV-Z]{8}$` (eight characters), one per student, never regenerated, created on first call.
  - Rule: sharer earns +10 per new OTP-verified account, in the current Track's points; the new student earns nothing; no credit while the sharer has no active enrolment; a new credit appears a few moments after registration; "no invite link and no web page" (:1440-1447).
  - `completeRegistration` takes an optional string `inviteCode` and returns `inviteCodeApplied` only when a code was sent (:4087, :4144, :4179). It never fails registration. The changelog (3.44) says stable, and `SchoolRegistration.inviteCode` (`@3.45:4144-4152`, text at :4147) and the `completeRegistration` description (:390-391) say "`stable` since 3.44.0-m1". **The stale copy is `UniversityRegistration.inviteCode` (`@3.45:4179-4188`, text at :4182-4183): "this field is `draft` - send it only once it is `stable`, because an older backend refuses unknown properties with `validation_failed`".** So the in-contract inconsistency is between the two registration bodies. The "older backend refuses unknown properties" rationale is the contract's own statement at :4182-4183, so the field must not be sent until the pin is at least 3.44 and staging is confirmed.
  - At 3.38 neither `getMyInvite` nor `inviteCode` exists (`grep -c inviteCode contract/openapi.yaml` = 0; `getMyInvite` absent in the 3.38 parse).
- **DESIGN `176:2425`:**
  - Copy "Share & Earn / ... you both earn 500 bonus points!" (`178:2646`).
  - Sample code `AHMED2024` (`178:2767`) is 9 characters, while the contract code is 8.
  - "Share with Friends" button (`178:2781`).
  - "Referral State" block: "3 Friends Joined", "1,500 Points Earned" (`178:2791`, `178:2796`), which is 500 per friend.
  - Share icon hidden (`178:2454`).
  - Corroborated by `results/inv_design.md:87` (independent read).
- **Share mechanism:** no share package in `pubspec.yaml` (`url_launcher` :54 only). The contract says "share the code however the app lets the student share text".
- **Verdict:** data path is contract-ready at 3.45 only. The reward copy must not be built until a product ruling (see questions).

###### 3.2 Friend graph: friends, requests, suggestions, phone lookup, block, unfriend, blocked list

- **App:** nothing (table 2). No friends model, repository or notifier.
- **Contract:** all 12 `social` operations are stable at 3.38 and 3.45 (`contract/openapi.yaml:2651-3009`; `@3.45:2987-3346`); `listMyFriendStreaks` is the 13th, stable at 3.45 only (`@3.45:3821`, path `/friend-streaks`):
  - `listMyFriends` (pages of 20, `points` omitted when `scoreHidden`)
  - `removeFriend` (idempotent `204`, no notification)
  - `listFriendSuggestions` (same Track and cohort, at most 100)
  - `lookupStudentByPhone` (exact E.164, 10 per hour)
  - `listMyFriendRequests` (`direction` required)
  - `sendFriendRequest` (`201` `pending` or `accepted`)
  - `cancelFriendRequest`, `acceptFriendRequest`, `declineFriendRequest`
  - `listMyBlocks`, `blockStudent` (always `204`, removes the friendship), `unblockStudent` (restores nothing)
- Social writes are limited to 30 per 60 s (`429 rate_limited`). New error codes: `friend_target_unavailable`, `friend_request_not_found`, `already_friends`, `friend_request_already_pending` (`error-codes.md@3.45:36-39`). **None is mapped in `lib/`** (grep).
- **Contract tension (reconciled in verification):** `sendFriendRequest` says "the recipient is not notified (no push or inbox item in this version)" (`@3.45:3162`), while `realtime.md@3.45:82-89` lists `friend_request_received` as a push kind. Both are current: the 3.43 changelog says the push senders now exist server-side "behind the off-by-default gates (the FCM sender, the friend-request push, ...)" (`contract-changelog.md:34`) and push delivery is off in every environment (`realtime.md@3.45:80`), so "not notified" describes today's behaviour and a `friend_request_received` push follows once delivery is switched on. What no contract text says is whether an inbox row will ever be written for a friend request (the inbox `kind` enum at 3.45, `@3.45:1211`, has no friend-request kind); that residual is folded into the contract clean-up question.
- **DESIGN `216:3784` "Friends":**
  - Title "Suggestions Friends"; search field "Search by phone number" (`216:4077`); "Friends request" carousel with an **Accept** button only and "See All" (`216:4318-4460`).
  - Suggestion rows with a masked phone **"************99"** (`756:8447`) and an "Add" button.
  - The contract's `StudentCard` is name and avatar only, "never points, level or any phone digits" (`@3.45:4665-4669`, :3055). So the design shows phone digits the contract forbids.
  - No Decline control, no "my friends" list frame and no unfriend or block affordance appear in the frames I read. The Messages frame has a "Suggestions Friends" carousel with Add buttons (`216:3470`).
  - Corroborated by `results/inv_design.md:58`.
  - Repo `.ai/audits/current/endpoint_ui_mapping.md:143` lists Friends `216:3784` / `309:6906` as "shell, no entry point" (DOC); line 144 is Refer a Friend.
- **Blocked list, block, unfriend:** no frame found in the 13 nodes read, and no repo record (grep of `docs/` and `.ai/audits/current/*.md` for unfriend, block, blocked list, report). `results/inv_design.md:71` found none either (university twins and other frames unread). The handoff (section 3) also says design is missing.

###### 3.3 Chat

- **App:** `/message` placeholder only. No conversation or message model, no realtime client. No SignalR or WebSocket package: `pubspec.yaml:30-65`; `pubspec.lock:1349-1361` lists `web_socket`/`web_socket_channel` as transitive only; `grep -i "websocket|signalr|hubs/chat" lib test` is empty.
- **Contract at 3.38:** the 8 `chat`-tag operations are `draft` (`contract/openapi.yaml:3031` `listConversations` ... `:3283` `reportChatMessage`). They are six core operations (`listConversations`, `listConversationMessages`, `sendChatMessage`, `editChatMessage`, `deleteChatMessage`, `markConversationRead`) plus the two report operations (`reportChatMessage`, `reportStudent`); the 3.39 changelog entry counts them the same way ("chat (8)", `contract-changelog.md:107-110`).
- **Contract at 3.45:** stable; the `chat` tag then also holds `forwardQuestion` and `answerForwardedQuestion` (10 operations).
  - `listConversations`, `listConversationMessages` (newest first, limit 1-100).
  - `sendChatMessage`: `clientMessageId` UUID idempotency key, body 1-500 Unicode scalar values after trim, 45 sends per 60 s.
  - `editChatMessage`: sender only, **within 10 s** of `sentAt`, else `409 message_edit_window_closed`.
  - `deleteChatMessage`: `scope=everyone` within **60 s** (else `409 message_delete_window_closed`), `scope=me` any time.
  - `markConversationRead`.
  - `reportChatMessage` `POST /message-reports`: recipient only, no reasons or free text, idempotent `202`, "report before block".
  - `reportStudent` `POST /student-reports`: `202` for any well-formed id.
  - Messages expire 24 h after the recipient reads them or 30 days after sending (`@3.45:3415-3420`). A friendship ending (unfriend, block, Track transfer) deletes the conversation and gives `404 conversation_not_found` (`@3.45:3418-3420`).
- **Forwarded questions and streaks (stable at 3.44/3.45):**
  - `forwardQuestion` (100 per Cairo day, `422 question_not_forwardable`, `409 forwarded_question_already_pending`, `429 forward_daily_limit_reached`; the 409 is per sender since 3.45, **BEHAVIOURAL**).
  - `answerForwardedQuestion`: any committed answer, right or wrong, advances the friend streak (at most once per friend pair per Cairo day). **Points: +1 only for a CORRECT answer, and only the first time the caller answers that question correctly through any forwarded card (a re-forward by the same or another friend never pays twice); a wrong answer earns 0; the award is applied server-side after the answer is stored and the response carries no points field, so the app must re-read the caller's standing where points are shown, never add a local +1** (`@3.45:3774-3779`; changelog 3.43 "A correct answer earns +1 point, once per question") (corrected in verification). Free plan spends the weekly 50-question allowance, `403 weekly_question_limit_reached`.
  - `listMyFriendStreaks` (only live streaks).
  - `ChatMessage.kind` is `text` or `forwardedQuestion`; an unknown kind must render a neutral "not supported" bubble (`@3.45:4763-4769`).
- **Realtime (`realtime.md@3.45:15-76`, hub stable):**
  - Route `/hubs/chat`, bearer token as `access_token` query parameter, **WebSockets only with `skipNegotiation: true`**, at most 3 connections per student (`realtime.md@3.45:21-24, 33`).
  - Events: `messageCreated`, `messageEdited`, `messageDeleted`, `conversationRead`, `typing`, `conversationRemoved`, `forwardedQuestionAnswered`, `friendStreakChanged`. Delivery is at-most-once; REST is the source of truth for backfill.
  - The hub is deployed on staging: an unauthenticated `GET /hubs/chat` answers 401, not 404 (RUNTIME, 2026-10-08; see headline 10) (added in verification).
- **DESIGN (Messages frames):**
  - `162:2797`: header "Messages" with camera and people icons; "Suggestions Friends" carousel; conversation rows with "Sent new photo", "Seen", and a **flame with count 20** (`661:8320`, `661:8323`).
  - `166:3156` / `215:2628` (thread): text bubbles with "Seen" ticks; media bubbles "Tap to replay or save", "Tap to View", "Tap to see question" (`171:4985`, `171:5016`, `215:2472`); a voice **Player** instance (`166:4150`); composer with a **microphone** icon and send (`166:3522-3523`); a bottom sheet with "Save" and "Replay" (`216:2963-2966`).
  - `166:4260` camera capture and `166:4319` photo editor (text, draw, sticker, scissors, music, attach) with a "Send to" button.
  - `171:5031` "Send to" friend picker with search and an "All" chip.
  - I found **no group-chat frame** in these six light frames (the repo record lists 12 Messages frames, six school and six university twins, `endpoint_ui_mapping.md:145`; the university twins were not read). The `bi:people` header icon (`649:8837`) is the only candidate and its target is unknown.
  - "Tap to see question" and the "Send to" picker plausibly correspond to forwarded questions (INFERENCE, unconfirmed).
  - Photos, voice and the Player corroborated by `results/inv_design.md:54`.
- **Consequences for the app:**
  - There is no UUID generator for `clientMessageId`: `uuid` is transitive (`pubspec.lock:1285`) and the device id is 32 hex characters (`lib/core/storage/secure_storage.dart:66-81`, generated with `Random.secure`, not a UUID).
  - Any new session-scoped provider (conversations, messages, friends, blocks, tickets, inbox, invite) must be registered in `invalidateSessionScope` (`lib/core/session/session_scope.dart:58`); `test/core/session/session_scope_discipline_test.dart` fails the suite otherwise.
  - A superseded session must reach the existing forced-logout path: the hub refuses connect and aborts on an invalid or superseded session (`realtime.md@3.45:23, 30-31`), and the app already turns a REST `session_superseded` into `forceLogout(LogoutReason.supersededOtherDevice)` and a Login-screen message (see 3.7) (added in verification).

###### 3.4 Support

- **App:** shell only (table 2). Test pins it in `shell_screens_test.dart`.
- **Contract:**
  - **Tickets (5 operations):** draft at 3.28 and 3.38 (`0df5cf4:2279-2409`; `contract/openapi.yaml:2480-2611`), **stable at 3.45** (`@3.45:2658, 2705, 2740, 2763, 2801`).
    - Create: `subject` 1-120, `details` 1-4000, no category or priority; 5 creates per day.
    - Reply: body 1-4000; 60 per hour; `409 ticket_closed`, with no reopen.
    - Lists page by 20 and take no `limit`.
    - Statuses `open`, `in_progress`, `pending`, `closed`; an unknown status must be treated as not closed.
    - Reference label `TK-{n}` is a display label only.
    - A staff message has `authorKind: staff` and shows as "Customer support".
  - **Photos:** optional `attachmentIds` (at most 3, no repeats; `@3.45:2667, 2809, 3990, 4006`) on the stable `createSupportTicket`/`postMySupportTicketMessage`, but the three operations that produce them are **draft at 3.45**: `createSupportAttachmentUpload` (:2848-2849), `completeSupportAttachment` (:2899-2900), `getMySupportAttachmentContent` (:2945-2946).
    - Flow: presigned PUT with exact signed headers, and the request needs the **SHA-256 of the bytes** (`sha256` pattern `@3.45:4034`).
    - Limits: JPEG, PNG or WebP only (`@3.45:4032`), 7,000,000 bytes (`maximum` at :4033), 10 unattached photos (:2862, :2885), 10 per ticket (:2811). Staff reply attachments are "always empty" (:3980).
    - `403 terms_acceptance_required` blocks photos until `acceptTerms` has been called (:2672, 2691, 2834, 2882); no `lib/` consumer of the Terms pair exists (`grep -rni "acceptTerms|getTermsAcceptance|terms-acceptance" lib` is empty).
    - `422 image_rejected_by_moderation` means "this photo can't be sent" (:2934); 5 refusals per hour then `429` (:2937); `503 image_upload_unavailable` (:2940).
    - Reading a photo is an authenticated byte stream, not a URL (:2950-2954). A student cannot delete a photo (:4015).
  - **Terms gate (added in verification):** `getTermsAcceptance` (`GET /me/terms-acceptance`) and `acceptTerms` (`POST /me/terms-acceptance`) are `stable` at 3.28, 3.38 and 3.45 (`0df5cf4:922-923, 951-952`; stable since 2026-09-24, `contract-changelog.md:232`). `currentVersion` "is the server-configured version the student must accept, or `null` when none is configured (the feature is inert until one is - every accept is then refused)"; the version is an opaque identifier and the backend serves no Terms text and no link (`@3.45:1087-1096`). The Terms and Privacy text itself is `getLegalDocument` (`GET /reference/legal-documents/{document}`, public, mobile and web, stable at 3.45, `@3.45:814-819`; absent at 3.28 and 3.38), which staging served in ar and en at version `r4-2026-10-07` on 2026-10-08 (`results/inv_store.md:16`, RUNTIME by another investigator). Whether staging has a Terms `currentVersion` configured cannot be read without a token.
  - **A note on the support tag text (added in correction):** the `support` tag description at 3.45 still reads "Text only for launch (Seif 2026-10-07, amending adr-187): attachments arrive later ... Every operation here is `stable`" (`@3.45:135-137`), while three `support`-tagged operations are `draft` (parse; :2848, :2899, :2945). This is a stale tag text, not a conflict in the operations.
  - So the handoff numbers (JPEG/PNG/WebP, 7 MB = 7,000,000 bytes, 3 per message, 10 per ticket, no PDF, staff replies never carry photos, "This photo can't be sent") are **all confirmed in the contract**, and the exact endpoints and shapes the handoff said were "coming" now exist at 3.42+ as draft.
- **DESIGN:**
  - `178:2800` "Customer Support": "Create a New Ticket" card; "Recent Tickets" rows `#TK-1042 · 2024-03-01` with status text "resolved" and "Closed".
  - `178:3222` "Create Ticket": Subject, Details, "Attatch File" with the old **"PNG, JPG, or PDF up to 10MB"** (`178:3368`; corroborated by `results/inv_design.md:88`), "Submit Ticket".
  - `178:3378` "Customer support chat": title is the ticket subject, a camera icon, and a composer with a microphone.
  - Gaps against the contract: "resolved" is not a status; PDF and 10 MB are wrong; the microphone (voice) has no contract; the `#` prefix is design-only.

###### 3.5 Notification inbox

- **App:** none (table 2). Settings toggles are dead; ARB keys `notifications` (:195), `settingsNotifications` (:608), `notifSupport` (:631), `settingsNotificationsUnavailable` (:633).
- **Contract:**
  - Three operations stable since 3.28 (`0df5cf4:984-1069`; `@3.45:1148-1262`).
  - `kind` enum: `[enrolment_opened]` at 3.28, `[enrolment_opened, announcement]` at 3.38 (`contract/openapi.yaml:1071`), `[enrolment_opened, announcement, moderation_warning, support_ticket_replied, academic_year_opened]` at 3.45 (`@3.45:1211`). `category` is `[system, announcements, support]` (`@3.45:1159, 1212`).
  - Rules:
    - Unknown `kind` or `category` must be ignored.
    - `announcement` carries bilingual **plain-text** `titleAr/titleEn/bodyAr/bodyEn`, never auto-linked.
    - `moderation_warning` has **contract-supplied approved EN/AR copy** (`@3.45:1174-1185`).
    - `support_ticket_replied` carries `ticketId`, `reference`.
    - `academic_year_opened` carries `track`, `academicYear`.
    - `?category=` is `system|announcements|support` (no `promotions`).
    - The unread count is total only.
  - Copy and `data` keys for `enrolment_opened` are still undocumented at 3.45 (grep).
  - No preference or mute operation exists at 3.45 (S28 stands).
- **DESIGN:** Notifications `180:8386` / `309:9525` chips read "All (6)", "Announcements", "Support", "System", "Promotions" (`180:8556-8720`); the repo record `notification_inbox_3_28_investigation.md:38, 187-192` reads the same chips and a "Premium Offer" sample row. The "Support" chip is real and the contract can now fill it (`category=support` from 3.28, `support_ticket_replied` from 3.41). The Promotions chip has no contract category and conflicts with purchase-silence (DOC).
- **Entry-point conflict** (`notification_inbox_3_28_investigation.md` section 5b): this session adds DESIGN evidence. The Messages frames are **friend chat**, not an inbox. The Notifications frame is a separate pushed screen (back arrow, no nav bar), consistent with the bell. The code comment calling `/message` "the in-app inbox" (`tab_placeholder.dart:54`) therefore looks wrong. This is an observation, not a ruling; entry points are the owner's call. The repo already records the choice as owner/designer decision D2 (`notification_inbox_3_28_investigation.md:346`), warns that the comment's "end-of-year promotion" is the year-advancement prompt and not a commercial offer (:236), and `release_readiness_reconciliation_2026-10-06.md:183` (O-1) proposes "(a) hide the tab for release 1" (listed under "For the owner" in `docs/WAVE_STATUS.md:61-62`).

###### 3.6 Push

- **App:** nothing.
  - `pubspec.yaml` has no `firebase_*`, `flutter_local_notifications` or `permission_handler`.
  - `android/app/src/main/AndroidManifest.xml` has only `INTERNET`, no `POST_NOTIFICATIONS`, no FCM service.
  - No `google-services` plugin in `android/build.gradle.kts` or `android/app/build.gradle.kts` (only `google()` repositories); no `google-services.json` under `android/`.
  - `res/values/` has only `colors.xml` and `styles.xml` (`values-night/styles.xml` also exists; `app_name` is a per-flavor `resValue`, `build.gradle.kts:72,77`).
  - iOS: `Info.plist` has no `UIBackgroundModes` and no `CFBundleLocalizations`; `ios/Runner/` has no entitlements file, no `GoogleService-Info.plist` and only `Base.lproj`; `AppDelegate.swift` is stock.
  - `registerFcmToken` has no call site (mentioned only in the `settings_screen.dart:344` comment).
  - No `push_*` key and **no `enrolment_opened` string** exists anywhere in `lib/`, `test/` or `docs/` (grep). The handoff's "old enrolment_opened keys may remain in the app" is not the case.
  - The pub cache holds `firebase_core-4.3.0`, `firebase_auth-6.1.3` and their platform packages (from another project; this app does not depend on them), but no `firebase_messaging` and no SignalR package.
- **Contract (`realtime.md@3.45:78-108`, push shape stable, delivery off everywhere):**
  - Exactly four kinds: `support_ticket_replied` (`ticketId`), `friend_request_received` (`friendRequestId`), `academic_year_opened` (`kind` only), `chat_message_received` (`conversationId`).
  - Titles and bodies are **localization keys, never text**: Android `title_loc_key`/`body_loc_key`, iOS `title-loc-key`/`loc-key`. The phone renders them from **strings shipped in the app, in the phone's language, not the in-app language switch**.
  - The 8 keys and EN/AR strings match the handoff exactly (:93-104).
  - Tap handling: ticket opens `getMySupportTicket`; friend request opens the incoming-requests list; academic year opens the notifications screen; chat opens the conversation; **unknown kind opens the notifications screen** (:106). None of those four screens exists.
  - Token: `PUT /me/fcm-token`, body `{token}` at most 4096 characters, `204` (`@3.45:1064-1082`), registered after sign-in and on token refresh (`realtime.md@3.45:108`). `registerFcmToken` is stable at all three pins.
  - The push shape (kinds, keys, payload, tap handling) does not exist in the contract below 3.43: the 3.38 working-tree `contract/realtime.md` has only the one-line chat note at :61 (added in verification).
- **Inferences (platform mechanics, not read in code here):**
  - The 8 strings must be native resources (Android `strings.xml` in `values/` and `values-ar/`, iOS `Localizable.strings` with an Arabic localisation plus `CFBundleLocalizations`), **not Flutter ARB**, because the OS resolves the key while the Flutter engine is not running.
  - `authRedirect` (`app_router.dart:74-83`) sends an unauthenticated tap to `/login` with no return-to, so a push tap while signed out loses its target.
  - go_router drops a non-JSON `extra` on refresh (BUG-005, memory note, DOC), so tap targets must use path parameters.
- **Environment:** reserved Firebase file locations are `docs/ENVIRONMENTS.md:351-353`; `android_identity_test.dart` is vacuous until the files exist; as of 2026-10-06 the backend held no Firebase credential and project ownership was unsettled (`docs/ENVIRONMENTS.md:344-347`, DOC, possibly stale).

###### 3.7 Cross-cutting states

**Shared building blocks (SOURCE):**
- `ScreenState<T>` sealed model, `lib/core/models/screen_state.dart:9-36`.
- `StateWidget<T>`, `lib/core/widgets/state_widget.dart:11-57`. Retry is always a tap, never automatic (:76).
- `OfflineBanner`, `lib/core/widgets/offline_banner.dart:12-47`.
- `isOnlineProvider`, `lib/core/providers/core_providers.dart:55-60`. It is connectivity_plus radio state, not reachability. The stream does emit the current state on listen on Android (`connectivity_plus-7.3.0/android/.../ConnectivityBroadcastReceiver.java`, `onListen` ends with `sendEvent(getNetworkTypes())`), so a cold start offline is detected there.
- 22 screens watch `isOnlineProvider` (21 files under `lib/features/*/screens`; `mistakes_tree_screens.dart:43,:153` holds two screens) and `OfflineBanner(` appears in 21 files (grep).
- `StateWidget` is used by catalog (`catalog_states.dart:97`), leaderboard (`leaderboard_screen.dart:208`), edit profile (:83) and profile (`profile_screen.dart:74`).
- Error mapping is **per feature, six separate files**: `auth_error_copy.dart`, `registration_error_copy.dart`, `profile_error_copy.dart`, `flashcards_error_copy.dart`, `quiz_error_copy.dart`, `board_failure.dart`. There is no central `code` to message map. Shared ARB: `retry`, `offline`, `genericError`, `rateLimited`, `rateLimitedIn`, `accountPendingDeletion`.
- `ErrorInterceptor` (`error_interceptor.dart:29-41`) types only 401, `400 validation_failed` and `429 rate_limited`; every other code becomes `ApiException(status, code)`. A body without a `code` becomes `'unknown'` (:25-27).
- `isAccountPendingDeletion` (defined in `lib/core/network/exceptions.dart`) is used in 7 files across 6 features (catalog, flashcards, leaderboard, mistakes in two files, profile, quiz). The contract's "route to the cancel screen" is **not implemented** (`exceptions.dart:127-129`); the `accountPendingDeletion` message points to a cancel flow that does not exist.
- Retry-After countdown copy is used in one place only (`registration_error_copy.dart:44-49`). No `RefreshIndicator` anywhere in `lib/`.
- **Logged-in-on-another-device is already implemented (added in verification):** a `401 session_superseded` on any endpoint or on refresh calls `forceLogout(LogoutReason.supersededOtherDevice)` (`lib/core/network/interceptors/auth_interceptor.dart:75-78, 149-151`; `lib/features/auth/notifier/auth_controller.dart:31`), and the Login screen shows `sessionEndedSuperseded` ("You've been signed out - your account was used on another device.", `lib/features/auth/screens/login_screen.dart:67`, `lib/l10n/app_en.arb:96`). The handoff lists this state as backend-built with no design; for this dimension the point is that the chat hub's connect failure or abort on a superseded session (`realtime.md@3.45:23, 30-31`) must route into the same `forceLogout` path.

**Screens that lack states** (checked against the four states, per `lib/features/*/screens`):

| Screen | Missing | Reason |
| --- | --- | --- |
| `/refer`, `/support`, `/friends`, `/legal/*` shells | all four | static, nothing fetched (by design today). Each becomes a data screen when built. |
| `/message` placeholder, `/track-select` placeholder | all four | placeholders |
| Quiz result and review | loading, error, offline | no network call (`quiz_review_screen.dart:26-31`) |
| Quiz screen | offline banner | maps errors to `l10n.offline` (`quiz_error_copy.dart:16`) but never watches `isOnlineProvider` |
| `_QuizUnavailableScreen` | offline | `genericError` plus a back button |
| Onboarding | all | static |

All other routed screens handle loading, error and offline; empty is handled where a list exists.

**Findings in the shared layer:**
- `StateWidget` defaults `'Empty'` (:38) and `'Offline'` (:52) are English literals. The localized-copy guard only matches `Text('...')`/`Text("...")` (`test/guards/rules.dart:174-177`), so these escape it.
- `ErrorInterceptor`'s header comment "Every non-2xx body is RFC 9457 ProblemDetails with a stable code" (`error_interceptor.dart:9-10`) is stale since 3.32 (`contract-changelog.md:182-184`, 2026-10-03); the contract now says some failures carry no body or no `code` and to treat them like `internal_error` and to send `Accept: application/json` (`openapi.yaml@3.45:3883-3890`).
- `DioClient._baseOptions` sets only `Content-Type` (`dio_client.dart:15-20`), and Dio 5.10.0 defines `acceptHeader` but never sets it by default (`dio-5.10.0/lib/src/headers.dart:22`, no other use). The app therefore sends no `Accept: application/json`, which the contract asks for (`@3.45:3883-3890`). The handoff lists this as an open question; the contract text itself requests the header, so adding it is a conformance fix for the first wave that touches the Dio client.
- None of the 3.31-3.45 social, chat, support and attachment error codes is handled in `lib/` (grep `account_banned|conversation_not_found|friend_target|terms_acceptance_required|forward_daily_limit|ticket_closed|message_edit_window|image_rejected` is empty). `403 account_banned` is the one that lands on the already-shipped login flow (headline 12): `auth_error_copy.dart:10-25` falls through to `genericError` and `lib/features/auth` has no 403 arm (added in verification).

**Guards (test/guards):**
- `project_rules_test.dart`:
  - Bloc only in `lib/features/quiz` (:34)
  - no provider mutation in `initState` (:51)
  - autoDispose notifiers that await track disposal (:69)
  - every async provider has `retry: (_, _) => null` (:90)
  - hardcoded `Text()` literals at baseline 4 (:108-169)
  - fontSize ratchet (:172), raw elevation effects (:207), ARB key parity (:295), no mirrored glyphs (:321)
- `contract_models_test.dart` binds required fields of 13 existing models only; **no notification, support, friend, chat or invite schema is bound**.
- `session_scope_discipline_test.dart` (above; `session_isolation_test.dart` also exists).
- **No guard enforces "every data screen has loading, empty, error, offline"** (`grep OfflineBanner|isOnlineProvider|StateWidget|ScreenState test/guards` is empty). That rule is prose (screen-states skill) plus per-screen widget tests (22 test files reference offline).

##### 4. Requested table: handoff items 5 and 4

Stability is "at 3.38 / at 3.45". "Design" is DESIGN unless marked DOC. "Implementable" means buildable now from contract plus existing design with no other missing piece.

| Item | Flutter impl? | Route? | Design record? | Contract (op, stability 3.38 / 3.45) | Blocked by design? | Independently implementable? | Product decision missing? |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Chat report (message) | No | None | None found in 13 nodes read; none in repo | `reportChatMessage` `POST /message-reports`: draft / stable | Yes (no frame) | No. Needs the chat thread UI, plus an affordance and confirmation design. | Yes: where it appears; whether a combined "report and block" exists (contract: report first, no reasons). |
| Chat report (student) | No | None | None found | `reportStudent` `POST /student-reports`: draft / stable | Yes | Data layer after pin at least 3.39. UI has no home (friend card, chat header). | Yes: entry point |
| Chat block | No | None | None found | `blockStudent` `POST /blocks`: stable / stable | Yes | Data layer yes. UI needs a surface and confirm copy (block deletes the conversation). | Yes |
| Chat unfriend | No | None | None found | `removeFriend` `DELETE /friends/{studentId}`: stable / stable | Yes | Data layer yes; no UI surface | Yes: confirm copy; the removed student is not told |
| Blocked list | No | None | None found | `listMyBlocks` + `unblockStudent`: stable / stable | Yes (no frame, no entry) | Data layer yes; UI no | Yes: where it lives (Settings or Profile) |
| Chat photos | No | None | DESIGN exists: camera icon and "Sent new photo" (`649:8851`), "Tap to replay or save" (`171:4985`), capture `166:4260`, editor `166:4319` | **No operation**: none / none (`realtime.md@3.45:17`) | Blocked by the backend, not by design | No | Yes: is it a future feature or dropped |
| Chat voice | No | None | DESIGN exists: Player `166:4150`, microphone `166:3523` | **No operation**: none / none | Blocked by the backend | No | Yes (backend says "future") |
| Chat groups | No | None | Not found in 6 light frames; `bi:people` icon only | **No operation**: none / none | Backend | No | Yes: does a group design exist |
| Notification "Support" tab | No | None (no inbox screen) | DESIGN exists: chip "Support" (`180:8726-8730`) in `180:8386` | `listMyNotifications?category=support`: stable / stable; filled by kind `support_ticket_replied`: absent / present | No (frame exists); Promotions chip conflicts with purchase-silence | Yes from pin at least 3.41 for the kind. The inbox shell needs an entry-point ruling first. | Yes: bell vs Message tab; `enrolment_opened` rendering; Promotions chip |
| Streak flames | No (no streak concept in `lib/`) | None | DESIGN exists: flame and count on conversation rows (`661:8320`, `661:8323`) | `listMyFriendStreaks`: absent / stable | No | No: flame sits on a conversation row, so it needs the chat list. Streaks advance only via forwarded-question answers. | Yes: flame semantics for `stepTakenToday=false` (alive until midnight) |
| Referral | Shell only (disabled share) | `/refer` | DESIGN exists `176:2425`, says 500 to both and a 9-character code | `getMyInvite`: absent / stable. `inviteCode` and `inviteCodeApplied`: absent / stable (3.44) | Yes: the copy and numbers contradict the contract | Data layer yes at pin at least 3.44; reward copy no | **Yes**: 500-both vs +10 sharer; share mechanism |
| Friends / requests / suggestions / phone lookup | Shell only | `/friends` (no entry) | DESIGN `216:3784` (masked phone shown; Accept only) | 9 operations (`listMyFriends`, `removeFriend`, `listFriendSuggestions`, `lookupStudentByPhone`, `listMyFriendRequests`, `sendFriendRequest`, `cancelFriendRequest`, `acceptFriendRequest`, `declineFriendRequest`): stable / stable; the 3 block operations are in the Blocked-list and Chat-block rows | Partly: masked phone contradicts the contract; no Decline, no "my friends" | Data layer yes now (3.38 suffices). UI needs the entry and the mask decision. | Yes |
| Chat core (list, thread, send, edit, delete, read, realtime) | No | `/message` placeholder | DESIGN `162:2797`, `166:3156` | 6 operations (`listConversations`, `listConversationMessages`, `sendChatMessage`, `editChatMessage`, `deleteChatMessage`, `markConversationRead`) plus the hub: draft / stable; hub stable since 3.39; the two report operations have their own rows | No for text; photos and voice must be excluded | No: needs pin at least 3.39, a SignalR client spike, a UUID source | Yes: Message tab = chat or inbox |
| Forwarded questions | No | none | DESIGN plausible: "Send to" picker `171:5031`, "Tap to see question" (INFERENCE) | `forwardQuestion`, `answerForwardedQuestion`: absent / stable (+1 point only for a first correct answer; no points field in the response) | Unconfirmed | No: needs chat plus quiz review entry | Yes |
| Support tickets (text) | Shell, create disabled | `/support` | DESIGN `178:2800/3222/3378` | 5 operations: draft / stable | Partly: "resolved" status and PDF/10 MB wording differ | Yes at pin at least 3.39 (text only) | Yes: mailto fallback in S33 is moot; confirm in-app |
| Support photos | No | none | DESIGN: camera icon; wording stale | 3 upload operations: none / **draft** | Backend (draft) | No (stable-only rule); also needs the Terms gate (next row) | Yes: image picker permissions, downscale step |
| Terms acceptance gate (added in verification) | No (`grep acceptTerms|getTermsAcceptance|terms-acceptance lib` empty) | none | None found in this dimension | `getTermsAcceptance`, `acceptTerms`: stable / stable (stable at 3.28 too); text via `getLegalDocument`: absent / stable | Unknown (no frame found; handoff lists the Terms step as backend-built, no design) | Contract yes now; UI needs a design and a decision on `currentVersion: null` behaviour (feature inert, every accept refused) | Yes: where the gate appears (registration, first chat or photo use) |
| Lockout pop-up: banned account (added in verification) | No (generic error) | login / OTP screens | None found in this dimension | `403 account_banned` on `verifyOtp`, `verifyParentOtp`, `confirmRecovery`, `verifyRedemptionSessionOtp`: absent / stable (behavioural, 3.42) | Yes (no frame; handoff: backend-built, no design) | Mapping yes once copy is ruled; no retry makes sense (the code is consumed) | Yes: copy and whether support contact is shown |
| Inbox (bell, list, unread) | No | none | DESIGN `180:8386` | 3 operations: stable / stable (since 3.28) | No, except Promotions and the entry point | Mostly yes (contract is enough for a minimal list) | Yes: entry point, `enrolment_opened` copy |
| Push | No | none | none (system UI) | `registerFcmToken`: stable / stable; push shape only from 3.43; delivery off | n/a | No: Firebase files, native strings, permission, tap routes all missing | Yes: push in release 1; Firebase ownership |

##### 5. Handoff verification (items I touched)

| Handoff statement | Result |
| --- | --- |
| (2) Referral: Figma 500 to both, backend 10 to the inviter | **Confirmed.** Figma `178:2646`; contract `@3.45:1434-1450`. Also a 9-character sample code vs an 8-character contract code. |
| (2) Figma exists but backend did not back: Chat photos, Chat voice, Chat groups, Streak flames, Notification Support tab | Photos, voice, flames, Support chip found in Figma. **Groups not found** in frames read. Photos, voice and groups have **no contract at 3.45**. Flames and the Support tab are now contract-backed. |
| (3) Backend built, design missing: Chat report, block, unfriend, Blocked list | Contract exists (stable at 3.45; block, unfriend and list at 3.38). No frame found. |
| (3) Backend built, design missing: Terms step, Lockout pop-ups, Logged-in-on-another-device (added in verification) | Terms pair stable since 3.28 (no `lib/` consumer). Lockout: `403 account_banned` is stable at 3.45 and unhandled in `lib/` (generic error). Logged-in-on-another-device: already implemented (`session_superseded` to `forceLogout` to Login message, 3.7). |
| (4) Support photo limits and wording | **All confirmed** (section 3.4). Upload endpoints now exist as draft at 3.45. Figma still says "PNG, JPG, or PDF up to 10MB". |
| (6) Push: 8 keys, 4 kinds, payload ids, privacy, "unknown kind opens notifications", `PUT /me/fcm-token` | **Contract matches exactly** (`realtime.md@3.45:78-108`). App state: nothing implemented. "enrolment_opened keys may remain in the app": **they do not exist** in `lib/`. |
| (8) Old comment in `error_interceptor.dart` | Stale: lines 9-10 (section 3.7). |
| (8) FriendScreen TODO may be stale | **Stale.** `friends_screen.dart:9-19` says "no friends list ... no social graph"; 12 stable operations exist since 3.37. |
| (8) S36 design or entry-point question | Still open (no entry point; DESIGN `216:3784` is suggestions, requests and phone search, not an entry door). |
| (8) Accept: application/json | The app sends no `Accept` header (`dio_client.dart:15-20`); the contract asks for it (`@3.45:3883-3890`). |

##### 6. Build constraints for later waves

- Chat needs a SignalR-capable Dart client that supports WebSockets-only, `skipNegotiation` and an `access_token` query parameter (or an own implementation of the SignalR JSON protocol). I could not verify any package (UNKNOWN): none is in `pubspec.yaml`, `pubspec.lock` or the pub cache. The hub itself is deployed on staging (RUNTIME, headline 10).
- UUID source for `clientMessageId`; SHA-256 for support photos (a `crypto`-style dependency); an image picker with permissions and a downscale step (contract: about 2048 px JPEG).
- Support photo reads need an authenticated byte fetch, so `cached_network_image` as used for avatars does not apply directly.
- The 8 push strings go into native resources (inference); iOS needs an Arabic localisation entry.
- Models: `kind` and `category` must decode leniently, as the contract requires unknown values to be ignored; the inbox item is an inline schema that `contract_models_test.dart` does not bind.
- `x-behaviour-changed: '3.43.0-m1'` on five chat operations means cards can appear in lists, edit, delete and report.
- **Privacy of the hub URL (added in verification):** the chat hub carries the bearer token in the WebSocket URL (`access_token` query parameter, `realtime.md@3.45:22, 24`). The app currently has no request or URL logging (`grep -rnE "LogInterceptor|debugPrint|print\(" lib/core/network lib/core/config` finds nothing), which is the right starting point; the chat wave must keep hub URLs out of exception messages, crash reports and debug logs (Dio and WebSocket exceptions can embed the URI). This follows the standing rule "never log personal data, tokens" for minors (`level_up_app/CLAUDE.md`).
- **Points display (added in verification):** after `answerForwardedQuestion` the response carries no points field; the app re-reads the caller's standing (server-authoritative) and never adds the +1 locally (`@3.45:3774-3779`).
- **Superseded session on the hub (added in verification):** hub connect refusal or abort on a superseded or invalid session must call the existing forced-logout path (see 3.3 and 3.7).

##### 7. Outside my dimension but adjacent

- `getLegalDocument` (`GET /reference/legal-documents/{document}`) is stable at 3.45 (`SCRATCH/ops_table.txt`; own parse), mobile and web, public, and the contract says the text is rendered in the app rather than in a browser (`@3.45:814-820`). The `/legal/*` shells say the blocker is missing text with no endpoint (`legal_document_screen.dart:11-17`). Staging served terms and privacy in ar and en on 2026-10-08 (`results/inv_store.md:16`).
- `listQuizHistory` (draft at 3.28 and 3.38), `getQuizReview` and the favorites operations are stable at 3.45, and `transferToUniversity` is stable (it was draft at 3.38 and absent at 3.28).
- The roadmap JSON decisions DR-01, DR-05 and DR-11 were computed at pin 3.28 (`level_up_master_completion_roadmap.json`, DOC) and predate chat, support and push becoming stable.


## 6. Design / Figma gaps
_Verification (Fable): 20 claims - 14 confirmed, 6 partial (corrected), 0 refuted (corrected), 0 unverifiable at claim level. The verifier's Figma connector was unauthenticated, so the Figma-sourced halves of C4, C5, C7, C9 and C12 were unverifiable to it; the corrector re-read them through the connector on 2026-10-08 and they reproduce (see "Figma access")._

### Design / Figma gap analysis (handoff sections 4, 5, 15)

**Scope and method.** Read-only. I read `docs/DESIGN_ISSUES.md`, the audit records named in the task, `docs/seif_fight.md` (S5, S29, S30, S31, S32, S33, S36), `docs/DECISIONS.md` D-007, `docs/RISKS.md` R-10, `docs/ENVIRONMENTS.md` §10, the parent folder `F:\level` (the role briefs, e.g. `03_role_uiux_partner.md`, `05_roadmap_scaffold.md`, and `F:\level\level_up\level_up\00_Project\Scope_v2_Features.md`, 24 lines, which exists at that depth), and the upstream contract at `2e5bb69` (3.45.0-m1; clone at SCRATCH `upstream-contract`, `openapi.yaml` 4935 lines). No repo file was changed (`git status --short` is identical before and after: five modified `contract/*` files plus two untracked roadmap files).

**Figma access.** The Figma MCP (connector `c80bb840…`, file `P6044i0giD9TmdQ7C2AmLq`) was reachable to the investigator and to the corrector. `get_metadata` with no node returns only page `0:1 "Assets / component"`, the same as the 2026-09-24 record (`endpoint_ui_mapping.md:5-8`), so the frame pages cannot be enumerated. Node ids were read one by one with `get_metadata`, plus `get_design_context` (no screenshot) for the full referral text. Nobody called a Figma tool on page `57:36` or node `1240:9847`. Evidence tags used below:
- **FIGMA-READ x2** = read by the investigator and re-read by the corrector today (source-class, not DEVICE). Re-read nodes: `176:2425` (+ full text of `178:2646` via `178:2759`), `178:3222`, `178:2800`, `178:3378`, `216:3341`, `216:3784`, `166:4416`, `59:1439`, `162:2797`, `215:2628`, `166:4260`, `171:5031`, `309:9671`, `180:8386`.
- **FIGMA-READ x1** = investigator's single-session read, not re-read (e.g. `166:3156`, Player `166:4150`, "Tap to see question" `171:5013`/`215:2470`, university twins, `180:4301`, `199:2335`, `225:6634`, `225:7001`).
- **DOC** = recorded in a repo file only.

**Staleness warning.** `figma_ui_comparison.md`, `screen_api_gaps.md`, `endpoint_ui_mapping.md`, `api_ui_endpoint_inventory.md` and `implementation_waves.md` are all dated 2026-09-24 against contract 3.23.0-m1. For example `screen_api_gaps.md:9` says "there is no friends, referral, support-ticket, chat or streak operation in any contract version". At `2e5bb69` that is false: 13 `social` stable ops, 10 `chat` stable ops, 5 `support` stable plus 3 draft, `getMyInvite`, `listMyFriendStreaks` (SCRATCH `ops_table.txt`, counted by tag). Use those records for Figma node ids and design history, not for contract status. Also stale against the contract: `docs/seif_fight.md` S11 (`:615` favourites "draft"), S14 (`:618`), S24 (`:626`), S36 (`:638`), and the doc comment in `lib/features/quiz/screens/quiz_review_screen.dart:22-25` ("`GET /quizzes/{quizId}` ... is `x-stability: draft` (`openapi.yaml:1010`)") - at `2e5bb69` `getQuizReview`, `addFavorite`, `removeFavorite`, `listFavorites` are stable and `getMyQuizSummary` has been stable since 3.38 (SCRATCH `ops_table.txt`) (added in verification). Parent-folder briefs are stale too: `Scope_v2_Features.md:23` still describes a Fawry `pending` subscription state, which the project rules reject (no `pending` entitlement state, F:\level\CLAUDE.md operating rules) (added in verification).

**Which pin unlocks what (added in verification; derived by the corrector from SCRATCH `ops_table.txt` columns 4-6, CONTRACT).**

| Tag | Committed pin `0df5cf4` (3.28) | Working tree `65245be` (3.38) | Upstream `2e5bb69` (3.45) |
| --- | --- | --- | --- |
| chat | 10 absent | 8 draft, 2 absent | 10 stable |
| social | 13 absent | 12 stable, 1 absent (`listMyFriendStreaks`) | 13 stable |
| support | 5 draft, 3 absent | 5 draft, 3 absent | 5 stable, 3 draft (photo ops) |

So against the committed pin none of the chat or social operations exist at all, and against the proposed re-vendor chat is still draft. The statements in sections 3-4 about "stable" operations hold only at `2e5bb69`.

---

#### 1. DESIGN_ISSUES.md census

| Measure | Value | Evidence |
| --- | --- | --- |
| Numbered entries | **125** (#1-#126; **#91 does not exist**) | `grep -c '^## [0-9]+\. '` = 125; no `## 91.` between `docs/DESIGN_ISSUES.md:4222` (#90) and #92 (`:4265`); `git log -S'## 91.'` finds nothing, so #91 never existed |
| Heading marker ✅ resolved/built/fixed | 29 | parsed headings (SCRATCH `di_headings.txt`), re-parsed by the verifier |
| Heading marker ❌ withdrawn | 2 (#63, #70) | same |
| Heading marker ⛔ BLOCKED | 1 (#43, level medallion is per-level raster art, `DESIGN_ISSUES.md:1111`) | same |
| Heading marker 🔴 | 12: #2, #3, #13, #16, #40, #44, #51, #59, #68, #71, #74, #87 | same; matches the list at `fable_eye_audit_2026-10-06.md` Phase 1 |
| Heading marker 🟠 / 🟡 | 28 / 53 | same |
| Headings with no closed marker | 94 (1 + 12 + 28 + 53) | derived |

Caveats on the open count:
- The marker is the severity at filing; bodies often record a build or workaround without changing it. Examples: #2/#3 (DoB and governorate built, `DESIGN_ISSUES.md:79-93`), #59 (built the contract's way, `:1970-1976`), #61 (fixed 2026-09-12, `:2021`), #68 (mapped to the nearest `AppType`).
- No per-entry open/closed ledger exists. The Summary table (`DESIGN_ISSUES.md:17-46`) stops at #28. The project's own figure on 2026-10-06 was "119 entries, ~70 open" (`fable_eye_audit_2026-10-06.md`, Phase 1). **That "119" is the highest entry number; at that audit's HEAD `3913f86` the file held 118 numbered entries** (`git show 3913f86:docs/DESIGN_ISSUES.md | grep -cE '^## [0-9]+\. '` = 118, last entry #119, #91 already absent). #120-#126 (7 entries, all 🟡) were added after, which reconciles to 125. Treat "~70-77 open, 94 unmarked-as-closed" as a range; a true count needs an entry-by-entry read (UNKNOWN).
- **No entry is marked "release-blocking".** The file defines 🔴 as "Blocking (breaks a required flow)" (`DESIGN_ISSUES.md:13`); `grep -niE 'release[- ]block|store[- ]block'` finds nothing. Release blockers live in `release_readiness_reconciliation_2026-10-06.md:69-76` (E-1..E-8); the design-related ones are E-3 (account deletion: "design frames for request/confirm/cancel are owed regardless", O-2 at `:184`), E-5 (Message tab placeholder, O-1 at `:183`) and E-2 (legal copy).
- The 🔴 items that are really designer-owed and unbuilt: #13/#16 (no data source; #13 later resolved by contract prose, `seif_fight.md:607`), #40 (selected track card 2.19:1), #44 (no frame for the two adr-028 states), #51 (three limit frames still draw the forbidden CTA), #71, #74 (no dark Limitation frame; `limitSheetScrim` dark is `null` by design, `:3243-3248`), #87 (dark CORRECT tile 1.11:1).

#### 2. Visual-acceptance records that exist

| Record | What it covers | Level |
| --- | --- | --- |
| `device_walk_results.md` + `wave_state.md` (Waves 01-22) | 22 formulated screens, walked on a Pixel 8 (Android 17) against the **mock** backend, criteria self-defined per wave in `implementation_waves.md` | DEVICE per the records (DOC for me) |
| Final acceptance | **21 of 22 waves at 100%.** Intermediate walks: W01 70, W02 78, W04 78, W05 60, W06 78, W08 89, W11 78, W13 44 (baseline), W22 92, each re-walked to 100 after fixes. **Wave 03 (School registration) was never walked** (`wave_state.md:22-24`, `:187` "not scored (unwalked)"). Wave 11's re-walk to 100% is recorded at `wave_state.md:49` (and `device_walk_results.md` ~`:749`, `implementation_waves.md:270`); the wave-log summary table row `wave_state.md:195` still reads 78% with W11-5/W11-6 open and is stale; `:47` is the chronological first-walk row | DOC |
| **Release build against staging, DEVICE + API** (added in verification) | `release_readiness_reconciliation_2026-10-06.md:381-396` (section 15.2): staging-flavor release APK built from `f10b112` (`com.levelupworld.app.stg`, scratch copy signed with the debug key outside the repo) walked on the **`Pixel_8` AVD** on 2026-10-06 through OTP, catalogue, a real 10-question quiz loop, leaderboard and offline. Unscored and functional, **not a visual acceptance** | DOC (DEVICE + API per the record) |
| `DEVICE_VERIFICATION_2026-09-12 / -09-19 / -09-20 / -09-20-edit5.md` | earlier device passes (elevation, Glass, contrast) | DOC |
| `fable_eye_audit_2026-10-06.md` | blind device traversal, 21 findings (FE-01..FE-21), 9 fixed and device-verified | DOC |
| `fable-verdict.md`, `fable-wave1/2/3-verdict.md`, `fable-style-fitting-register.md` | **code, CI and typography audits (2026-08-12..08-22)**, not per-feature visual acceptance | DOC |

Limits of those records: the 22 scored wave walks used the mock backend (many branches N/A on the mock, e.g. Wave 12 F2/F3/F5); a separate unscored functional pass of a staging release build exists (row above), so "no scored visual acceptance exists for release builds or staging" is the accurate statement; Android only (no iOS device pass; DESIGN_ISSUES appendix `:5043-5045` also lists the limit sheet, offline/error states and text scale above 1.3 as unverified); contract 3.23-3.28, not 3.38-3.45; the surfaces in sections 3 and 4 below have **no** visual acceptance because they are unbuilt or shells.

Stale "walked" claims to discount (added in verification): `fable_eye_audit_2026-10-06.md` Phase 1 "Wave state" row says "API->UI Waves 01-22 all COMPLETE and walked", which contradicts `wave_state.md:22-24` / `:187` (Wave 03 unwalked); and the `wave_state.md:195` Wave 11 row described above.

---

#### 3. Feature matrix (Figma exists, backend previously absent)

Contract column is CONTRACT at `2e5bb69` (`openapi.yaml` unless noted); see the pin table above for what exists at the committed pin. "Impl vs Figma" is the state at HEAD `8e641e9` (SOURCE).

| Feature | Figma reference (node ids) | DESIGN_ISSUES / other record | Impl vs Figma? (wave, acceptance) | Contract today | Open findings |
| --- | --- | --- | --- | --- | --- |
| **Subscription** | No standalone Subscription *screen* node is recorded anywhere (UNKNOWN whether one exists), and `endpoint_ui_mapping.md:85` says "no subscription / plan / price frame found anywhere" (2026-09-24). **But the designer's scope brief commissioned them (stale, Paymob era):** school list "subscription/paywall + web-checkout hand-off", university list "its own paywall, dual subscription screens (base + flashcard)" (`F:\level\03_role_uiux_partner.md:14-15`); `docs/day8_account_brief.md:225-227` records that the Figma Profile table carried a Subscription row (built disabled, removed by `5c4b855`) (added in verification). Closest frames: Profile row **"Upgrade to premium" `170:4890`** (icon `fluent:payment-28-filled` `170:4891`; FIGMA-READ x2 in `166:4416`); Notifications sample row **"Premium Offer — 40% Off!" / "Upgrade to Premium and unlock unlimited quizzes an…"** (`180:8768`/`180:8773`, category Promotions; FIGMA-READ x2); `limitation` component variants `Subscribe now`, `Subscription Expired`, `Explanations Locked`, `daily limit` (`DESIGN_ISSUES.md:3258-3260`); limit frames `199:2335`, `225:6634`, `225:7001` | #51 (CTA + benefits list forbidden), D-007, D-015, #74; R-10 | **Not built, by rule.** `lib/features/subscription/` = 4 `.gitkeep` only (`git ls-files`); Profile row and `/subscription` routes removed (`DECISIONS.md:252-290`). Limit card built to `199:2335` without CTA: Wave 11, 100% | `getMyEntitlements` stable (data layer only). `redeemSubscriptionCode` + redemption-session OTP are `x-consumers:[web]`. Changelog entry (`contract-changelog.md:564`, adr-049 §3) still says the app "never carries a purchase link, and never tells the student where to buy"; no later entry revises it (`grep` for "website link", "level-upworld", "/redeem", "status screen" in the changelog = none) | Frames #51 not redrawn; limit-sheet bodies are provisional engineering copy; R-10 OPEN (see section 5). D-007 "Revisit when" names the gates for any status copy: designer-approved copy, or a product rule on whether "subscription" may appear in student-facing copy |
| **Referral** | Refer a Friend **`176:2425`** (FIGMA-READ x2: "Share & Earn" `178:2644`, reward sentence `178:2646`, "Your referral Code" `178:2763`, sample code `AHMED2024` `178:2767`, "Share with Friends" button `178:2782`, "Referral State" `178:2787`, "3 / Friends Joined" `178:2791/2793`, "1,500 / Points Earned" `178:2796/2798`); university twin `309:8565` (DOC); Profile row `170:4777`; Sign Up_1 invitation field `337:15875` (caption frame `216:3348`/`216:3393` per `project_files_forensic_audit.html:556`) | #7 (field has no backend), S5 | Shell only: `refer_a_friend_screen.dart` = icon + message + **disabled** "Share invite"; Sign Up_1 field is collected and **never submitted** (`lib/features/registration/screens/signup_identity_screen.dart:182-189`, `lib/features/registration/models/school_registration.dart:96-97`, also `university_registration.dart:78`, `registration_controller.dart:38`). No wave, no acceptance | `getMyInvite` **stable** (`:1430`): code = 8 chars `^[0-9A-HJKMNP-TV-Z]{8}$`, `friendsJoined`, `pointsEarned`; `inviteCode` optional on both registration bodies (`:390`, `:4144`, `:4179`) plus `inviteCodeApplied` on 201 (`:4087`) | Reward conflict (section 5). #7 and S5 are stale (say "no contract") |
| **Avatar upload** | Edit Profile avatar sheet `216:3341` (FIGMA-READ x2: exactly two rows, "Upload photo" `216:3344` and "Use Avatar" `216:3346`; no size copy, no Remove row, no preview/crop, no rejected state); sheet parent `216:3158`; picker `180:3989` | #106 (sheet built to frame; Upload dimmed with a caption), S29 | Sheet built to frame, Wave 20, **100%**. "Upload photo" is **disabled** | `uploadCustomAvatar` **draft** (`:978`, opId `:982`): JPEG/PNG/WebP, **max 2,097,152 bytes**, 128-4,096 px per side, <=16,000,000 px, multipart part `image`, "Crop to a square and upload it upright" (`:988-990`); `removeCustomAvatar` **draft** (`:1042`); 422 `image_rejected_by_moderation` -> show "this photo can't be used" (`error-codes.md:16`); `terms_acceptance_required` 403 (`:1025`); 5 uploads/hour, lockout after 3 refused/hour (`:1031-1033`) | Draft, so not buildable under the stable-only rule. Frame has no Remove/replace/rejected/Terms/rate-limit states and no crop UI although the contract needs an upright square crop (added in verification). The store audit already plans the Photo Picker for avatar upload (`store_readiness_audit.md:232`), not the camera |
| **Support** | Customer Support `178:2800` (FIGMA-READ x2: "Create a New Ticket" `178:3061`, "Recent Tickets" `178:3079`, rows `#TK-1042 · 2024-03-01` with status pills "resolved"/"Closed"); Create Ticket **`178:3222`** (FIGMA-READ x2: Subject, Details, "Attatch File" `178:3364`, hint **`178:3368` "PNG, JPG, or PDF up to 10MB"**, "Submit Ticket"; **no category field**); support chat `178:3378` (FIGMA-READ x2: header camera icon `ic:round-photo-camera` `178:3407`, composer microphone `178:3471`, "Customer support" bubble `178:3426`); further ids `178:3518`, `296:3154`, university `309:8713/8915/9146/8819`, `180:7154` (DOC) | S33; Glass note `DESIGN_ISSUES.md:2849-2853` ("recorded, not built") | Shell only (`customer_support_screen.dart`, Create Ticket disabled). No wave | Text support **stable**: `createSupportTicket` (subject <=120, details <=4000), list/get/messages/post (`:3983-4010`); `ticket_closed` 409. Photos: `createSupportAttachmentUpload` (`:2849`) / `completeSupportAttachment` (`:2900`) / `getMySupportAttachmentContent` (`:2946`) are **draft**; `attachmentIds` optional, **max 3** per ticket/message; **max 10** unattached; **<=7,000,000 bytes**; JPEG/PNG/WebP; SHA-256 + presigned PUT + complete; `terms_acceptance_required` for photos only (`:2672`, `:2812`, `:2882`; `error-codes.md:67`); "this photo can't be sent" (`error-codes.md:16`) | Figma attachment hint is wrong against the contract (section 5). Frames have no photo-thumbnail, rejected-photo, closed-ticket or Terms states. Voice mic in `178:3378` has no contract. The camera icon `178:3407` meets domain rule 9 (section 5, point 3) |
| **Notifications "Support" tab** | Notifications `180:8386` (FIGMA-READ x2, was DOC): chips All (6), Announcements, **Support**, System, **Promotions**; 6 sample rows (4 distinct): "New Biology Quiz Available!" (Announcements), "Premium Offer — 40% Off!" (Promotions), "Daily Streak! 🔥 / You've maintained a 14-day streak! Keep it up!" (System, `180:8786/8789`), "Ticket #1042 Updated" (Support, `180:8802`); university twin `309:9525` (DOC, same chips/rows per `notification_inbox_3_28_investigation.md:187-197`). Dark and Arabic ids not recorded | #41 (bell); investigation D1-D6 | Not built: `/message` = `MessagePlaceholderScreen` (`app_router.dart:314`); bell inert. No wave | Inbox ops stable (3). Kinds at 3.45: `enrolment_opened`, `announcement`, `moderation_warning`, `support_ticket_replied`, `academic_year_opened` (`:1211`); categories `system`/`announcements`/`support` (`:1212`). So the Support tab is now fillable; **no `promotions` category and no streak kind** | Where the inbox lives (bell vs Message tab) is unsettled (investigation `:209-210`); O-1 recommends hiding the tab; Promotions chip and purchase/streak sample rows conflict with adr-049 §3 / contract |
| **Chat photos / voice / groups** | Messages list **`162:2797`** (FIGMA-READ x2: header `solar:camera-outline` `649:8835` and `bi:people` `649:8837`; rows "Sent new photo" `649:8851`, "Seen", flame + count `661:8319`/`649:8889`, per-row camera icons; "Suggestions Friends" carousel with add tiles); thread **`215:2628`** (FIGMA-READ x2: header camera `215:2657`; photo/snap rows "Tap to replay or save" `215:2697`, "Tap to View" `215:2708`/`215:2719` with `mdi:camera`; voice **"Player"** instance `215:2727`; composer microphone `215:2732`; Save/Replay action sheet `215:2940`); thread **`166:3156`** (x1, Player instance `166:4150`, "Tap to see question" rows); camera/compose **`166:4260`** (FIGMA-READ x2: flip-camera `166:4269`, "Your Photos" `166:4296`, shutter `166:4280`), **`166:4319`** (x1, edit tools, "Send to"), recipient sheet **`171:5031`** (FIGMA-READ x2: composer "Send to" `171:5058`; sheet "Send to" `171:5205`, "All" `171:5238`, Search, six selectable rows). University twins `309:6654/7340/7490`, `180:7398`, `309:7722/7778` (DOC) | S33 (mentions Messages); none for photos/voice | Not built (`/message` placeholder). No wave | `chat` tag is **text only**: "No photo, voice, group chat or streaks" (`openapi.yaml:149`; `realtime.md@2e5bb69:17` "Photo, voice and group chat are not part of it."). Kinds: `text`, `forwardedQuestion` (`:4763-4769`); body <=500; 10 ops stable | Figma draws camera/photo/voice/multi-recipient flows the contract excludes. **No group-conversation frame was found** (only the `bi:people` icon; UNKNOWN). Camera frames collide with the standing "camera is BLOCKED" rule (section 5, point 3) |
| **Settings preferences** | Settings `176:1840` (= `309:8452`), dark `337:8141`, Arabic `549:21759`; Notification Preferences card `176:2394` (4 toggles) (x1/DOC) | #45, #46, #48, #107-#111; S26-S28 | Built to frames, Wave 21, **100%** (F 2/2, F3 N/A). The 4 notification rows are dimmed, dead, with a build-authored line "Notification settings aren't available yet." (`DESIGN_ISSUES.md:4716`) | **No preference/mute storage anywhere** (grep of `openapi.yaml@2e5bb69` for preference/mute/notificationSettings = none). Rank privacy = 2 booleans on `PATCH /me` (already built) | Four toggles remain inert; O-6 recommends hiding them for release 1. BUG-017 wording owed (O-8) |
| **Progress** | "your progress" **`309:9671`** (FIGMA-READ x2: "Learning overview" weekly bar chart MO-Sun with a "100" label `310:9985`, "This week" / "Apr 1 - Apr 7", "You're doing good! / You almost reached your goal", Study Time "20h 30m", "+30%" "VS last Week", **hidden** group "Recent Badges" `544:6973` with Champion/Hero/Elite/Warrior); school `334:3453`, university `310:10166`, `334:3622` (DOC). Profile `166:4416` (FIGMA-READ x2): row "your progress" `308:5570`; tiles Solved Questions "300", Points "2,450", Rank "HERO" | S32, S24, S25 | Profile row disabled. **No screen.** `getMyQuizSummary` is **not called anywhere in `lib/`** (`grep -rnE 'getMyQuizSummary\|solvedQuestions\|quiz-summary' lib` = none), so the "Solved Questions" tile is omitted | Only `getMyQuizSummary` (`:1727`, opId `:1731`, stable since 3.38): one integer `solvedQuestions` (lifetime, all tracks). **No time series, study time, weekly figure, week-over-week %, or badge-history operation** | Chart, study time and % have no backend. The Solved Questions tile is now backable (S24 answered, `seif_fight.md:626` still says Open) but unbuilt |
| **Quiz history** | **No history-list frame recorded.** The project's own mapping places it at Home "Continue Learning" ("FUTURE FEATURE; design incomplete", `endpoint_ui_mapping.md:130-131`). Adjacent frames: Home "Continue Learning" card (`59:1439` > `308:4186`, "See All" `59:2033`; FIGMA-READ x2), Review `162:2377`, Profile "Favorite questions" row `295:3144` (FIGMA-READ x2) | S14, mapping `endpoint_ui_mapping.md:130-131` | Not built. Review is in-memory only (`quiz_review_screen.dart:19-25`, DOC) | `listQuizHistory` + `getQuizReview` **stable** since 3.43 (`:1877`, `:1912`; finished quizzes only, newest first, cursor); favourites ops stable | Needs a design; the location lead (Home Continue Learning) is a 2026-09-24 mapping lead, not a ruling. Cold re-open of Result/Review has no frame |
| **Friends** | Friends **`216:3784`** (FIGMA-READ x2: title "Suggestions Friends" `216:3812`, "Search by phone number" `216:4077`, "Friends request" `216:4318` with "Accept" cards, list rows with masked phone `************99` and "Add"); suggestions carousel in `162:2797`; send-to `171:5031` | S36 | Shell at `/friends`, **no entry point** (`grep "'/friends'" lib` = only `lib/core/router/app_router.dart:423`, the GoRoute itself) | 13 `social` ops stable (graph, requests, phone lookup, blocks, `listMyFriendStreaks`) | Frame draws Accept/Add/search only; no remove-friend, block, blocked list, report, empty or error states |
| **Streak flames** | (a) **friend streak**: `noto:fire` + count "20" on conversation rows (`661:8319`, `649:8889`, in `162:2797`; FIGMA-READ x2). (b) **personal streak**: Home Continue Learning "**12 days Streak**" with `noto:fire` (frame `308:4203`, icon `308:4204`, text `308:4207`, FIGMA-READ x2 in `59:1439`; also DOC `day4_home_brief.md:71`). (c) Notifications sample row "Daily Streak! 🔥" (`180:8786`, FIGMA-READ x2) | none (no DESIGN_ISSUES entry mentions a streak) | Nothing built | **Friend streak only**: `listMyFriendStreaks` stable (`:3821`, opId `:3825`), `FriendStreak {friendStudentId, conversationId, count, stepTakenToday}` (`:4866`), only live streaks listed; advanced by `answerForwardedQuestion` (`:3772`). `ConversationSummary` carries **no** streak (`:4881`). **No personal-streak field or op** (every "streak" hit in the contract is friend/chat/self-grade prose; `StudentProfile` has none) | (b) and (c) have no backend; (a) is backed |

#### 4. Backend-built / no-design items

| Item | Figma coverage (local records + today) | Backend state (CONTRACT `2e5bb69`) | App state (SOURCE) | Notes |
| --- | --- | --- | --- | --- |
| **Terms step** | None. Only passive consent text `82:1086` on Login `82:819` (#9; wording and URLs also owed). Profile rows "Privacy & policy" `170:4901`, "Terms & Conditions" `170:4912` exist (FIGMA-READ x2 in `166:4416`) but no document-viewer frame is recorded | `getTermsAcceptance` / `acceptTerms` stable (`:1087`, `:1116`); `getLegalDocument` stable (`:816`, public `security: []`): text is rendered **in the app** "during registration and from settings" as Markdown (`contentMarkdown`), 404 `legal_document_unavailable` when inert. **The contract contradicts itself twice here** (added in verification): (a) `acceptTerms` says "Acceptance is recorded, not enforced: no other operation refuses a student who has not accepted" (`:1122-1123`) while `uploadCustomAvatar` (`:1025`), `createSupportAttachmentUpload` (`:2882`) and `createSupportTicket` / `postMySupportTicketMessage` with `attachmentIds` (`:2672`, `:2812`, `error-codes.md:67`) return 403 `terms_acceptance_required`; (b) `getTermsAcceptance` says "the backend serves no Terms text and no link" (`:1095-1096`) while `getLegalDocument` serves it (`:816-827`) | `/legal/privacy`, `/legal/terms` static "not published" shells; no Markdown renderer dependency in `pubspec.yaml` (`grep -i markdown pubspec.yaml` = none) | A registration Terms step and a document viewer both lack frames. Text ownership is S30 (unassigned). Both contradictions belong in `docs/seif_fight.md` before the Terms step is designed, else the step is built to prose the backend contradicts |
| **Track-transfer confirmation** | **Partial.** Dialog "Go to Uni" `180:4301` ("Are you sure you want to convert to Uni Track?", S31) with dark and RTL twins (x1); Profile row "GO to University" `170:4921` (FIGMA-READ x2). No frame for success, not-eligible, not-allowed or error | `transferToUniversity` **stable at 3.45** (draft at 3.38, absent at 3.28): errors `track_transfer_not_allowed` 409, `track_transfer_not_eligible` 403 (`error-codes.md:59-60`) | Dialog built, **Confirm disabled** ("Switching tracks isn't available yet", `lib/features/profile/screens/profile_screen.dart:339-351`; `app_en.arb:562-566`; Wave 19 100%) | Stable at the latest pin, so the stable-only objection in the handoff lapses at 3.45 |
| **Account deletion** | **None** (`endpoint_ui_mapping.md:47-49`; S38; E-3) | `requestAccountDeletion` / `cancelAccountDeletion` stable; contract mandates confirm copy that contains "paid" and "refund" (O-2; `openapi.yaml:1282-1285` at `2e5bb69`) | No consumer in `lib/` (only doc comments in `exceptions.dart:101/:118` and the `pendingDeletion` model) | Store-mandatory (E-3, E-8). Design and copy ruling owed. The "paid"/"refund" question is already filed as **Q-B2** (`release_readiness_reconciliation_2026-10-06.md:206`, recommended option (a): ask Seif for an app-safe variant) but was **never carried into `docs/seif_fight.md`** (`grep -niE 'refund\|Q-B2' docs/seif_fight.md` = none) (added in verification) |
| **Account cancellation (cancel deletion)** | **None.** Contract: "route to the cancel screen, drawn from `GET /me`'s `pendingDeletion.effectiveAt`" (#62) | stable | `pendingDeletion` modelled, never rendered; `403 account_pending_deletion` shows copy on six surfaces with Retry withheld; no cancel route | #62 (`DESIGN_ISSUES.md:2048-2064`) and `exceptions.dart:127-135` |
| **Lost-phone recovery** | **None** (`day8_account_brief.md:396`: "no design in this cluster"; weak lead: OTP `82:1171` carries recovery-variant copy) | 4 ops (`startRecovery`, `verifyParentOtp`, `submitNewPhone`, `confirmRecovery`) **stable** since 3.39 (draft at 3.28 and 3.38); `recovery_unavailable` 404 -> "app routes to support path" | Absent | A recovery flow needs 4+ frames; the "support path" has no signed-out destination |
| **Logged in on another device** | **None.** `day1b_forced_logout_brief.md:4-7`: "the Figma ... has no forced-logout frame" | `session_superseded` 401 | Built as redirect to `/login` plus a one-time message, copy `sessionEndedSuperseded` (`app_en.arb:96`) | Infrastructure, not a designed screen |
| **Chat report / block / unfriend / Blocked list** | **None found** in the Messages/Friends/Support/Notifications frames read by the investigator and the corrector (`162:2797`, `166:3156`, `215:2628`, `166:4260`, `166:4319`, `171:5031`, `216:3784`, `178:2800`). Not exhaustive (university twins and others unread) | `reportChatMessage` (`:3630`, recipient only, no reasons/free text, "report before block"), `reportStudent` (`:3667`), `blockStudent`, `unblockStudent`, `listMyBlocks`, `removeFriend` all stable | Absent | Store-policy relevance: O-5 (UGC) |
| **Limit pop-ups** | **Exist** (light only): `199:2335` (school), `225:6634`, `225:7001` (university) + `207:5904` (x1); **draw the forbidden CTA and benefits list** (#51); no dark frame (#74) | `weekly_question_limit_reached`, `subscription_required`, `flashcard_subscription_required` | Built as the frame's centred card with title + body + "Not now" (Wave 11, 100%; D-007, D-015); flashcard preview line owner-worded (#119) | Bodies are provisional engineering copy; frames not redrawn |
| **Lockout pop-ups** | **None found as a frame.** The repo does use the word once: `docs/day1_login_otp_brief.md:114` "`otp_expired` / lockout (`otp_throttled`) -> localized message; offer resend when the timer allows" (corrected in verification; `DESIGN_ISSUES.md` never uses it). Other candidates in the contract: `rate_limited` 429, avatar upload "after 3 refused photos in an hour every upload is refused" (`:1031`), `forward_daily_limit_reached` 429 (100/day) | see left | OTP throttle uses the single OTP error line (`DESIGN_ISSUES.md:1503`; `errorOtpThrottled` exists) | The handoff author's meaning is still unconfirmed; the narrowed question is whether it means the OTP throttle as in the Day 1 brief |
| **Empty / Loading / Offline states** | **No frames by design.** #76 (`:3404-3405`): "frames for the error, offline, empty and expired states" owed by the designer; #119 (`:4868`), #126 (`:4949`) list flashcard states nobody drew; #60 (`:1993`) Mistakes empty state | n/a | Shared `StateWidget` (`lib/core/widgets/state_widget.dart`), `offline_banner.dart` (both exist), per-screen skeletons; each wave scored loading/empty/error/offline where reachable | Every new surface will need these built with no Figma reference and engineering-authored EN+AR copy |
| **Account banned (3.42)** | **None**; no DESIGN_ISSUES hit for "banned" (`grep -ci banned` = 0) | `account_banned` 403 only after a code is proven, on `verifyOtp`, `verifyParentOtp`, `confirmRecovery`, `verifyRedemptionSessionOtp`; no tokens issued; suggested copy EN "Account banned — contact Support", AR "تم حظر الحساب — تواصل مع الدعم"; "Do not retry; route to Support" (`error-codes.md:51`) | No handling (no ARB key; no branch; `grep -rni banned lib` = only a code-style comment in `lib/core/models/screen_state.dart:4`) | A signed-out student cannot reach authenticated Support ops, and no support phone/e-mail is recorded in the contract or docs; the only related open item is `seif_fight.md:1318` asking whether support is "a mailto: or a WhatsApp hand-off" (unanswered). Also inbox `moderation_warning` has **contract-approved EN+AR copy** (`:1172-1185`) |
| **Forwarded-question cards (3.43-3.45)** | Partial and indirect: chat rows "Tap to see question" (`171:5013`, `215:2470` family, x1); quiz-header bookmark/share `295:3139`; recipient sheet `171:5031` ("Send to" + "All"; FIGMA-READ x2) | `forwardQuestion` / `answerForwardedQuestion` stable; one friend per call, <=100/day, `forward_daily_limit_reached`, per-sender 409 (3.45); a card cannot be reported | Absent | Entry point (quiz review? question screen?) is not drawn; "All" multi-send would be N calls against a daily cap |

---

#### 5. Figma-vs-backend conflicts: confirmed and located

1. **Subscription (in-app payment vs purchase-silent).** CONFIRMED as a rule conflict, not a missing screen.
   - The recorded Figma subscription surfaces are the Profile "Upgrade to premium" row (`170:4890`, FIGMA-READ x2), the Notifications "Premium Offer — 40% Off!" row (`180:8768`), the `limitation` variants "Subscribe now" / "Subscription Expired", and limit frames carrying "Upgrade To Premium" plus a benefits card (#51, `DESIGN_ISSUES.md:1585-1590`). The designer's scope brief also commissioned "dual subscription screens (base + flashcard)" and a flashcard paywall (`F:\level\03_role_uiux_partner.md:14-15`, Paymob era); whether those frames exist in the file is UNKNOWN (no node id recorded; `endpoint_ui_mapping.md:85` found none on 2026-09-24). That commissioning is what the handoff's "Figma Subscription screen is incompatible" most plausibly refers to (added in verification).
   - The rule: adr-049 §3 as relayed in `contract-changelog.md:564` and D-007 (`DECISIONS.md:252-290`): no paywall, price, upgrade link or "where to buy". `openapi.yaml` (redemption 500 text, around `:2445-2455`) also bans "price, buy, purchase, payment, provider name" vocabulary.
   - **Website URL source: there is none.** `ENVIRONMENTS.md:405-412` records Seif's Q7 `/redeem` hand-off (host `level-upworld.com`, "decided, not live") and withdraws it ("DO NOT BUILD", R-10). `RISKS.md:142-150` R-10 is OPEN (owner + Seif). Release-readiness O-4 (`:186`) says do not build the slot until the contract changes the rule in a changelog entry and the owner accepts Apple 3.1.1 exposure. Env Wave 2 has no URL slot (`ENVIRONMENTS.md:367`). Nothing in `lib/` implements it (grep for `redeem|checkout|premium|upgrade` finds only comments).
   - A "status/information screen with a website link" would carry the link the contract forbids; a status screen *without* the link is not prohibited by anything found, but no record says it is wanted, no Figma frame exists for it, and any status copy is gated by D-007's "Revisit when". A status screen must show active or not only (no `pending`; the Fawry `pending` line in `Scope_v2_Features.md:23` is stale).
2. **Referral reward.** CONFIRMED (Figma half re-read by the corrector). FIGMA-READ x2 `178:2646` (frame `176:2425`): "When a friend signs up with your code, you both earn **500 bonus points**!". The same frame shows "3 Friends Joined" and "1,500 Points Earned" (`178:2791-2798`) and a sample code "AHMED2024" (9 characters). Contract (`:1437-1444`, `:4193-4219`): the **inviter** earns **+10** per new OTP-verified account, in their current Track's points, the **new student earns no referral points**, no credit while the sharer has no active enrolment, no invite link and no web page, code is 8 characters. The `MyInvite` shape (`code`, `friendsJoined`, `pointsEarned`) matches the frame's two counters, so only the amounts and the new-student reward conflict. No record contains a ruling (grep "500" in docs finds only level-threshold text). **A third, stale definition exists** in the parent roadmap: `F:\level\05_roadmap_scaffold.md:69` "Referral codes (50% off)" under Phase 4 "Payments, dashboards, reporting" (Seif-owned, Paymob era, superseded by adr-049 purchase-silence) (added in verification).
3. **Support photos, avatar photos and the camera rule.** Support photos CONFIRMED: Figma `178:3368` says "PNG, JPG, or PDF up to 10MB" (FIGMA-READ x2). Contract: JPEG, PNG or WebP only; `sizeBytes` <= 7,000,000; up to 3 per ticket/message; 10 held; PDF not supported; unsafe photo -> "this photo can't be sent" (`error-codes.md:16`). The three photo operations are **still draft at 3.45**, so they are not buildable under the stable-only rule. **Domain rule 9** (`.claude/skills/level-up-domain/SKILL.md:22`; `Scope_v2_Features.md:24`): "Camera-based streak is BLOCKED pending privacy/legal review (minors' imagery, Law 151/2020, parental consent) ... don't even request camera permission". As written it blocks camera capture and the camera permission, which every Figma camera/snap frame and the camera icons in the Support chat (`178:3407`) and thread headers (`215:2657`) collide with; it implies gallery/Photo-Picker-only intake for avatar and support photos (the store audit already lists Photo Picker for avatar, `store_readiness_audit.md:232`). Whether minors' photo upload through the picker needs the same privacy/legal review is not recorded (added in verification).
4. **Avatar size copy.** No size copy exists in the Figma sheet `216:3341` (two rows only, FIGMA-READ x2), so there is nothing to conflict with. The 2 MB figure from the handoff matches the contract exactly (2,097,152 bytes). Rejection copy "this photo can't be used" is contract-suggested (`error-codes.md:16`); the app has no such string yet.
5. **Chat photos / voice / groups.** CONFIRMED conflict (Figma half re-read by the corrector for `162:2797`, `215:2628`, `166:4260`, `171:5031`). Figma draws camera, photo-snap, voice player and multi-recipient "Send to"; the contract is text-only plus the forwarded-question card (`openapi.yaml:149`, `realtime.md:17`, `:4763-4769`). Group chat has no confirmed frame (header icon `bi:people` only).
6. **Streak flames.** Friend streak is backed (`listMyFriendStreaks`, section 3). The personal "12 days Streak" on Home Continue Learning (`308:4203`) and the "Daily Streak" notification row have **no contract operation or field**. `StudentProfile` carries no streak (no "streak" hit in it).

#### 6. Corrections to the handoff

- (2) "Figma exists but backend was not previously backed" is accurate for the 2026-09 records but **stale at 3.45**: Referral, Friends, text chat, text support, the inbox (incl. a Support tab), quiz history and favourites are now stable. Still unbacked or draft: Subscription (by rule), chat photos/voice/groups, personal streak, Progress beyond one integer, notification preferences, avatar upload (draft), support photos (draft). None of the chat or social operations exist at the committed pin `0df5cf4` (pin table above).
- (4) "Exact upload endpoints/request shapes/error codes will come from the next contract version": they are **already in the contract as draft** (support: `POST /support/attachments`, `/complete`, `GET .../content`; avatar: `PUT/DELETE /me/avatar`; error codes `image_too_large` 413, `image_content_invalid` 422, `image_upload_unavailable` 503, `attachment_limit_reached` 409, `attachment_gone` 410, `terms_acceptance_required` 403). What is missing is stability, not shapes.
- (3) "Terms step ... missing": the contract adds that photo upload (avatar **and** support) is gated by Terms acceptance, so the Terms step is a prerequisite for both photo features; and the contract contradicts itself on whether any operation enforces acceptance and whether the backend serves Terms text (section 4, Terms row) - both need a `docs/seif_fight.md` entry first.
- (6) The eight push keys match `realtime.md:97-104` EN/AR text exactly (CONTRACT). Push needs no new design except tap-routing targets, **and those targets are unbuilt surfaces**: `friend_request_received` opens the friend requests list (`listMyFriendRequests`) and `chat_message_received` opens the conversation by `conversationId` (`realtime.md@2e5bb69:106`), but `/friends` has no entry point (`app_router.dart:423`) and `/message` is `MessagePlaceholderScreen` (`app_router.dart:314`); there is no conversation screen (added in verification).
- Handoff open questions touching this dimension: S11, S14, S24 and S36 are stale in `docs/seif_fight.md` against `2e5bb69` (section "Staleness warning"); S24 is answered by `getMyQuizSummary` (stable since 3.38) but unbuilt.

#### 7. Items for the designer / owner (see structured questions)

Frames owed or undefined: Subscription replacement (or confirmation none), Terms step + document viewer, deletion request/confirm/cancel, recovery flow, account banned, chat report/block/unfriend/blocked list, forwarded-question entry, quiz-history location, text-only chat, support photo states, avatar remove/rejected/rate-limit/crop, empty/loading/offline/lockout, Notifications dark/RTL ids, a dark Limitation frame (#74), redrawn limit frames without CTA (#51). Seif-side filings owed: the two Terms contradictions (section 4) and the unsent Q-B2 deletion-copy question, both to `docs/seif_fight.md`.

## 7. Environment / identity state (includes the push implementation audit, 7.8)
_Verification (Fable): 17 claims - 16 confirmed, 1 partial (corrected), 0 refuted (corrected), 0 unverifiable; 6 section-level errors fixed and 6 missed items added._

### Environment / identity / Firebase / push - implementation state (as of 2026-10-08, branch `merged` @8e641e9)

Level tags: **SOURCE** read in code/config, **CONTRACT** read in the contract, **DOC** a project document says so, **BUILD** run now, **ARTEFACT** inspected a built file, **DEVICE** observed on the Pixel 8. "Upstream 2e5bb69" = SCRATCH/upstream-contract (contract 3.45.0-m1). Nothing in the repo was modified; the only command run that touches the tree was `flutter test --no-pub test/guards/android_identity_test.dart` (log in SCRATCH, `git status` identical before/after; the verifier re-ran the same file with the same result). The corrector re-checked, read-only: `git show` / grep across `HEAD`, the working tree and SCRATCH/upstream-contract; `aapt2 dump badging` on the built APKs; a Python `-I` `zipfile` read of the AAB manifest; a PyYAML parse of the three openapi pins; the cited source lines. Items marked "(added in verification)" were not in the investigator's draft.

#### 0. Verdict

| Question | Answer | Level |
| --- | --- | --- |
| Android identity (prod / staging) | `com.levelupworld.app` / `com.levelupworld.app.stg`, labels "Level Up" / "Level Up STG" | SOURCE + ARTEFACT + BUILD (guard 9/9) |
| iOS identity (prod / staging) | **Still the template `com.levelup.levelUpApp` for every configuration; no prod/staging scheme.** D-021 ratified `com.levelupworld.app` / `.stg` but Wave 3 (needs a Mac) has not run | SOURCE |
| iOS deployment target | **13.0** in code (ratified 15.0, not applied) | SOURCE |
| Firebase | **None anywhere** (deps, config files, Gradle plugin, Xcode) | SOURCE |
| Push client | **ABSENT** end to end (no permission prompt, no token call, no tap routing, no 8 `push_*` keys, no destination screens) | SOURCE + ARTEFACT |
| Does the vendored contract contain the push shape? (added in verification) | **No.** The committed pin 0df5cf4 `realtime.md` has no push/fcm text at all (`git show HEAD:contract/realtime.md` with `grep -c -i "fcm\|push"` = 0). The proposed 65245be has only a one-line chat-push mention (`realtime.md:61`, kind spelled `ChatMessageReceived`). The `Push notifications` section (4 kinds, 8 keys, tap rules, token rule) exists only upstream 2e5bb69 `realtime.md:78-108` (>= 3.43.0-m1), where the kind is `chat_message_received` | CONTRACT |
| Env Wave 2 (Dart contract) | Not started: prod URL still `https://TBD.example/api/v1`, `isDev` never read, no boot assertion | SOURCE |
| Can Seif's request (Android package + iOS bundle ID) be answered from the repo today? | **Yes** - the ratified ids are in `docs/DECISIONS.md:1054`. Caveats in section 6 | DOC + SOURCE |
| Conflict with `env_chapter_state.md` / 2026-10-04 identity audit? | **No conflict with env_chapter_state** (its wave table matches the code). The identity audit is a dated pre-Wave-1 record; its Android findings are closed, iOS/push findings still true (section 7) | SOURCE |

#### 1. Identity matrix and consistency

| Platform | Environment | Identifier | Display name | Evidence |
| --- | --- | --- | --- | --- |
| Android | prod | `com.levelupworld.app` | Level Up | `android/app/build.gradle.kts:55,72`; `aapt2 dump badging build/app/outputs/flutter-apk/app-prod-release.apk` -> `package: name='com.levelupworld.app' versionCode='1' versionName='1.0.0'`, `application-label:'Level Up'`, min 24 / target 36 / compile 36 (APK built 2026-10-06 00:32, re-dumped read-only now by investigator and verifier) |
| Android | staging (and dev, mock) | `com.levelupworld.app.stg` | Level Up STG | `build.gradle.kts:74-78` (`applicationIdSuffix = ".stg"`); `app-staging-release.apk` and `app-staging-debug.apk` badging -> `com.levelupworld.app.stg`, label `Level Up STG` |
| Android | namespace / Kotlin package | `com.levelup.level_up_app` (unchanged on purpose) | - | `build.gradle.kts:28-31`; `android/app/src/main/kotlin/com/levelup/level_up_app/MainActivity.kt:1`; aapt2 `launchable-activity: name='com.levelup.level_up_app.MainActivity'` |
| iOS | prod / staging / dev (one identity) | `com.levelup.levelUpApp` (template) | "Level Up App" (`CFBundleName` `level_up_app`) | `ios/Runner.xcodeproj/project.pbxproj:371` (Profile), `:550` (Debug), `:572` (Release); `ios/Runner/Info.plist:7-8,15-16` |
| iOS | test target | `com.levelup.levelUpApp.RunnerTests` | - | `project.pbxproj:387,404,419` |

Consistency across the project (SOURCE unless noted):
- **Android is internally consistent:** Gradle (`build.gradle.kts:55,76`) = guard `test/guards/android_identity_test.dart:23-28` = `tool/verify_release_manifest.ps1:35` = `.github/workflows/ci.yml:376-408` = `tool/verify_guards.ps1:246-250` = `docs/ENVIRONMENTS.md` section 2.0 = `docs/DECISIONS.md:1054`. The `android_identity_test.dart` run now: **9 passed, 0 failed** (BUILD; log `SCRATCH/env_identity_guard.log`; re-run by the verifier, `SCRATCH/verifier_env_identity_guard.log`). No file under `test/` references the old template ids.
- **Android namespace vs applicationId differ deliberately** (`build.gradle.kts:28-30`; `DECISIONS.md:1062-1064`); manifest uses `.MainActivity` (`AndroidManifest.xml:38`), which resolves against the namespace. ARTEFACT confirms the activity is `com.levelup.level_up_app.MainActivity`.
- **iOS is inconsistent with everything else by design (D-021 "iOS pending Wave 3", `DECISIONS.md:1024`; `RISKS.md:138`):** Xcode carries the template id, Gradle/docs/guards carry the ratified ones. No iOS guard test exists (`test/guards/` has only `android_identity_test.dart`, `contract_models_test.dart`, `project_rules_test.dart`, `rules*.dart`, `validate_reporting_test.dart`, `workflow_test.dart`).
- **Branch skew:** `git show <branch>:android/app/build.gradle.kts` -> `merged` and `origin/merged` have `applicationId = "com.levelupworld.app"`; **`main`, `origin/main`, `dev`, `origin/dev` still have `com.levelup.level_up_app`** (2dfd969, 2026-10-06 00:44, is only on `merged` and `origin/merged`). CI's `build-release-apk` job runs on `main` only (`ci.yml:318-320`, `if: github.event_name == 'push' && github.ref == 'refs/heads/main'`; `RELEASE_SIGNING.md:95`), so the flavored CI path has never been on the branch that triggers it. (added in verification: the `analyze-and-test` job does trigger on `dev`, `main` and `merged`, `ci.yml:24-30`; only the release compile gate is main-only.)
- **Device (DEVICE, `adb shell pm list packages`, 2026-10-08, investigator and verifier independently, identical results):** `com.levelup.level_up_app` (orphan, old id) and `com.levelupworld.app.stg` installed; `com.levelupworld.app` (prod) not installed, so the two-identities-side-by-side check (Wave 4) is still not done (`env_wave1_report.md:143-145`). Caveat: the corrector's later `adb devices` re-check had to restart the adb daemon and listed no attached device, so the corrector could not re-confirm these DEVICE facts; they rest on the two earlier same-day observations.
- **Stale build outputs (gitignored, `.gitignore:33`) - three pre-flavor artefacts carry the template id; none is a store candidate:**
  - `build/app/outputs/flutter-apk/app-release.apk` (2026-09-22 18:50) -> `package: name='com.levelup.level_up_app'`, label `level_up_app` (aapt2, ARTEFACT).
  - `build/app/outputs/flutter-apk/app-debug.apk` (2026-09-30 21:05) -> same package and label (aapt2, ARTEFACT) (added in verification).
  - `build/app/outputs/bundle/release/app-release.aab` (2026-10-04 22:29) predates the flavors (commit 2dfd969). ARTEFACT, not merely "inferred from dates": its `base/manifest/AndroidManifest.xml` names `com.levelup.level_up_app`, `.MainActivity` and `.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, and contains no `POST_NOTIFICATIONS` (string extraction from the binary-protobuf manifest via Python `zipfile`, done by the verifier and repeated by the corrector; not a full aapt2 dump) (corrected in verification).
  - **No flavored AAB exists** (`build/app/outputs/bundle/` holds only `release/`). The flavored APKs that do exist are `app-prod-release.apk` (2026-10-06 00:32), `app-staging-debug.apk` (03:52) and `app-staging-release.apk` (04:37).

#### 2. Android build and manifest

| Item | State | Evidence |
| --- | --- | --- |
| compileSdk / minSdk / targetSdk | 36 / 24 / 36 as literals | `build.gradle.kts:39,56,57`; guarded by `android_identity_test.dart:175-200` |
| Toolchain | AGP 8.11.1, Kotlin 2.2.20, Gradle 8.14, Java 17 | `android/settings.gradle.kts` plugins block; `gradle-wrapper.properties:5`; `build.gradle.kts:42-49` |
| Flavors | `flavorDimensions += "env"`; `prod` (`resValue app_name "Level Up"`), `staging` (`applicationIdSuffix ".stg"`, `app_name "Level Up STG"`). No `android/app/src/prod|staging` source sets exist (only `debug`, `main`, `profile`) | `build.gradle.kts:68-79`; `ls android/app/src` |
| Label | `android:label="@string/app_name"` (generated per flavor; no `strings.xml`, no `values-ar/` in `android/app/src/main/res`; `values/` holds `colors.xml` and `styles.xml` only) | `AndroidManifest.xml:31`; res listing |
| versionCode / versionName | `flutter.versionCode` / `flutter.versionName` <- `pubspec.yaml:19` `version: 1.0.0+1`; ARTEFACT versionCode 1 / versionName 1.0.0 | `build.gradle.kts:58-59` |
| Signing | `android/key.properties` **absent** (only `key.properties.example` tracked); `release` buildType uses `signingConfigs.findByName("release")` = null -> **unsigned by design**; `.gitignore` covers `key.properties`, `*.keystore`, `*.jks` | `build.gradle.kts:19-25,92-100,150-155`; `android/.gitignore`; `ls android/key.properties` -> missing |
| Permissions (source) | `INTERNET` only (in `src/main`, deliberately); debug/profile manifests add `INTERNET` again. **No `POST_NOTIFICATIONS`** | `AndroidManifest.xml:19`; `src/debug|profile/AndroidManifest.xml:6` |
| Permissions (ARTEFACT) | prod/staging release + staging debug APKs: `INTERNET`, `ACCESS_NETWORK_STATE`, `<id>.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` only; merged manifests `build/app/intermediates/merged_manifest/{prodRelease,stagingRelease}/...` agree (package + label `@string/app_name`) | aapt2 now; Wave 1 report `env_wave1_report.md:70-72` |
| Launcher activity | `.MainActivity`, `exported=true`, `launchMode=singleTop`, `taskAffinity=""`; the **only** intent filter is MAIN/LAUNCHER -> **no deep links / app links / custom scheme** (the `<queries>` block is PROCESS_TEXT only, `:70-75`) | `AndroidManifest.xml:37-58` (`:40,41,54-57`); matches `ENVIRONMENTS.md:416-417` (D-021 Q7: none in release 1) |
| Backup | `allowBackup=false`, `fullBackupContent=false`, `dataExtractionRules` excludes cloud-backup and device-transfer | `AndroidManifest.xml:34-36`; `res/xml/data_extraction_rules.xml` |
| Flavor <-> entrypoint rule | Gradle reads `-Ptarget` (`findProperty("target")`, default `lib/main.dart`) and throws in `compileFlutterBuild(Prod|Staging)(Debug|Profile|Release)` unless: `prod` -> `main_prod.dart` only; `staging` -> `main_staging.dart`/`main_dev.dart`/`main.dart` (+ `main_mock.dart` in debug/profile only). Anchored on `compileFlutterBuild*` not `preBuild` | `build.gradle.kts:103-146`. BUILD-level negative proofs recorded in `env_wave1_report.md:74-78` (four refused builds; not re-run now) |

#### 3. iOS project state (never built; SOURCE only from this machine)

| Item | State | Evidence |
| --- | --- | --- |
| `PRODUCT_BUNDLE_IDENTIFIER` | `com.levelup.levelUpApp` in Debug/Release/Profile of Runner; `.RunnerTests` in the test target | `project.pbxproj:371,550,572,387,404,419` |
| `IPHONEOS_DEPLOYMENT_TARGET` | **13.0** x3 (Profile `:349`, Debug `:475`, Release `:526`); `MinimumOSVersion` 13.0 | `project.pbxproj`; `ios/Flutter/AppFrameworkInfo.plist:23-24`. Ratified 15.0 is **not** in code (`ENVIRONMENTS.md:154-157,170`) |
| Build configurations / schemes | Debug, Release, Profile only (no `Debug-staging` etc.); **one shared scheme `Runner`** (no `prod`/`staging`) | `project.pbxproj:586-608`; `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme` |
| xcconfigs | `ios/Flutter/Debug.xcconfig` and `Release.xcconfig` contain only `#include "Generated.xcconfig"` (no Pods include, no per-flavor values) | `cat` of both files |
| Info.plist | `CFBundleDisplayName` "Level Up App", `CFBundleName` `level_up_app`, version from `$(FLUTTER_BUILD_NAME/NUMBER)`; landscape allowed. **Absent:** `CFBundleLocalizations`, `ITSAppUsesNonExemptEncryption`, `UIBackgroundModes`, any `NS*UsageDescription`, `CFBundleURLTypes` | `ios/Runner/Info.plist:7-8,15-16,19-24,31-42`; grep for the absent keys exits 1 |
| Localization regions | `knownRegions = (en, Base)` - **no `ar`** | `project.pbxproj:188-191` (corrected in verification from `:186-191`) |
| `PrivacyInfo.xcprivacy` | absent (`find ios -iname 'PrivacyInfo*'` empty) | R-11 / E-4 context: `RISKS.md:154-162` |
| Podfile / Pods | **absent** (not in tree, not tracked); store audit expects the first Mac build to generate files and possibly rewrite `AppDelegate.swift`/`Info.plist` (UIScene, SwiftPM) | `ls ios/Podfile*` -> none; DOC: `store_readiness_audit.md:39,138,284` |
| Entitlements / team | no `*.entitlements`, no `CODE_SIGN_ENTITLEMENTS`, no `DEVELOPMENT_TEAM` -> no `aps-environment` | `find ios`; pbxproj grep |
| AppDelegate | stock `FlutterAppDelegate`; no `UNUserNotificationCenter` code | `ios/Runner/AppDelegate.swift` |

#### 4. Firebase / push toolchain - proof of absence (SOURCE)

- `pubspec.yaml` and `pubspec.lock`: grep for `firebase|messaging|notification|permission_handler|fcm|apns|push` -> **0 matches** (exit 1); the corrector re-ran this and the broader pattern with `app_links|signalr` added: both exit 1, zero matches. Notification-relevant deps do not exist: no `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `permission_handler`, no SignalR/websocket client, no `app_links`. Relevant existing deps: `url_launcher ^6.3.2` (`pubspec.yaml:54`), `screen_protector ^1.5.3` (`:55`), `device_info_plus ^13.2.0` (`:60`).
- `find` (excluding build/.git/worktrees) for `google-services*.json`, `GoogleService-Info*.plist`, `firebase*.json`, `firebase_options*.dart`, `.firebaserc` -> **none**. grep of `android/` and `ios/` for `gms|google-services|firebase|GoogleService|aps-environment|remote-notification|UIBackgroundModes|PrivacyInfo|UNUserNotification` -> none. `android/settings.gradle.kts` plugin block has only the Flutter loader, AGP and Kotlin (no Google Services plugin). Generated plugin registrants contain no Firebase.
- Reserved-but-empty slots (DOC `ENVIRONMENTS.md:349-357`): `android/app/src/{prod,staging}/google-services.json`, `ios/Runner/Firebase/{prod,staging}/GoogleService-Info.plist`. The Android half is guarded and **vacuous**: `android_identity_test.dart:202-239` (the per-flavor test `continue`s when the file does not exist; a second test refuses a file in `src/main`). There is no iOS equivalent.
- Cross-check of the pub cache: `firebase_core-4.3.0` exists in `C:\Users\musta\AppData\Local\Pub\Cache` but is **not** a dependency of this project; its podspec has `s.ios.deployment_target = '15.0'` with Firebase SDK 12.6.0 (`firebase_core-4.3.0/ios/firebase_core.podspec:30`, `firebase_sdk_version.rb`; re-read by the verifier). At least that Firebase generation therefore cannot be installed at the repo's current iOS target 13.0; D-021's 15.0 is in practice a prerequisite for iOS push (SOURCE on a non-project version; the version the project would adopt is UNKNOWN).

#### 5. Dart environment configuration

| Item | State | Evidence |
| --- | --- | --- |
| `Flavor { dev, staging, prod }`, `AppConfig` (`flavor`, `baseUrl`, `isDev`) | unchanged by Wave 1 | `lib/core/config/app_config.dart:7-35` |
| Base URLs | dev = staging = `https://level-up-backend-staging.up.railway.app/api/v1`; **prod = `https://TBD.example/api/v1` (fail-closed placeholder)**; upstream `servers:` at 3.45 still lists staging only | `app_config.dart:43-55`; `openapi_2e5bb69.yaml:107-109` (CONTRACT) |
| Entrypoints | `lib/main.dart` -> `main_dev.dart`; `main_dev`/`main_staging`/`main_prod` -> `bootstrap(Flavor.x)`; `main_mock.dart` = dev + `dioProvider` override, resets tokens each launch | `lib/main*.dart`; `lib/bootstrap.dart:10-31`; `main_mock.dart:41-70` |
| `isDev` | computed, **never read** (grep `isDev lib test` -> only `app_config.dart`) | SOURCE |
| Boot assertion Flavor <-> platform flavor; `.example`-in-prod build failure; `main_mock` release refusal in Dart; on-screen env indicator | **all absent** (no `kReleaseMode`, no `fromEnvironment`, no `kDebugMode`/`kProfileMode` in `lib/`) | grep; `env_chapter_state.md:82-93` |
| Env Wave 2 | **not started** (Wave 1 done 2026-10-06; Waves 2-4 not started; Wave 3 blocked on a Mac) | `env_chapter_state.md:9-15`; `app_config.dart` untouched by env commits |
| Other placeholders | legal URLs `https://levelup.example/legal/...` in `lib/features/auth/screens/login_screen.dart:43-48` | SOURCE |
| HTTP defaults | `BaseOptions` sets only `Content-Type: application/json` - no `Accept` header (grep `Accept` in `lib` -> none), although contract 3.32 says to send `Accept: application/json` (or `application/problem+json`) on every call so the API can write its error body (`contract-changelog.md:184`@2e5bb69). (added in verification) The error interceptor's header comment still asserts the sentence 3.32 withdrew: `/// Every non-2xx body is RFC 9457 ProblemDetails with a stable `code`.` (`lib/core/network/interceptors/error_interceptor.dart:10`); 3.32 says some failures carry no body or no `code` and must be treated as an unknown outcome | `lib/core/network/dio_client.dart:15-20`; `error_interceptor.dart:10` (SOURCE); `contract-changelog.md:184`@2e5bb69 (CONTRACT) |

#### 6. Seif's request (handoff item 5) - what the repo can answer

Answerable from `docs/DECISIONS.md` D-021 Q1 (`:1054`, ratified 2026-10-06, same string on both platforms): **Android** `com.levelupworld.app` (prod), `com.levelupworld.app.stg` (staging); **iOS** `com.levelupworld.app` (prod), `com.levelupworld.app.stg` (staging); display names "Level Up" / "Level Up STG"; Flutter 3.44.7 (`.flutter-version`, `flutter --version` BUILD), Android 24/36/36, iOS 15.0 (`:1057`). Caveats to state alongside the answer:
1. **Android is applied and artefact-proven; iOS is ratified only.** Xcode still holds the template id and 13.0 (section 3), so an iOS Firebase registration made against the ratified id does not match the project until Wave 3 changes it on a Mac.
2. **Nothing is registered anywhere** (Play Console, App Store Connect, Firebase); Firebase ownership and project sharing are unsettled and the APNs key does not exist (`DECISIONS.md:1060`, `ENVIRONMENTS.md:343-348`). Play listing URLs returned 404 on 2026-10-06 - proves no published app, not that nobody holds the id (`ENVIRONMENTS.md:444-447`). (added in verification) `RISKS.md` R-9 "Next action" (`:137`) is itself written as a standing prohibition - "Nothing may be uploaded to any store track or registered with Firebase before the client's accounts and the Firebase ownership question are settled" - so the repo's own risk register currently blocks the Firebase registration the handoff asks for until the owner lifts or amends that gate.
3. D-021 says store registrations and account ownership are **not** decided (`DECISIONS.md:1054` last sentence).
4. The dev flavor shares the staging identity (D-021 Q2), so there is exactly one staging Firebase app per platform, not three.
5. Only the `merged` branch carries the Android ids; `main`/`dev` do not.

#### 7. Documents - state and drift

- `env_chapter_state.md` (Wave 0 and 1 done; 2, 3, 4 not started) matches the code. `RISKS.md` R-9 "OPEN - MITIGATING" is accurate (iOS template id remains). R-10 (the `/redeem` hand-off contradicts adr-049 section 3) and R-11 (`device_info_plus` required-reason API; Wave 3 proves it with the archive Privacy Report) are open and unchanged.
- **2026-10-04 identity audit** (`app_identity_environment_audit_2026-10-04.md`, gap table `:243-253`): G-1, G-2, G-3 (Android part) and G-9 (Android part) are now closed by Wave 1 (ARTEFACT above). Still true: G-4 (`isDev` dead), G-5 (prod host placeholder), G-6 (iOS never built, no team/Podfile/entitlements, single scheme), G-8 (no AAB/iOS lane in CI; CI never observed, R-3), G-9 iOS half ("Level Up App"), G-10 (dev == staging), G-11 (mock refresh reaches live staging). G-7 ("Firebase/FCM planned but identity not fixed first") is half-satisfied: the ids are ratified and applied on Android (section 1) but not on iOS (corrector note, derived from the G-7 text and section 3). Audit section 2.6 (`:201`, "Not implemented on either platform: no POST_NOTIFICATIONS, no APNs entitlement, no FCM SDK") is still literally true.
- **Doc/code drift found:** (a) `docs/ENVIRONMENTS.md:238` says the check runs "in the variant's `preBuild` task"; the code and `env_wave1_report.md:64-68` anchor it on `compileFlutterBuild<Variant>` (`build.gradle.kts:117-118,130-131`). (b) Root-level `flutter_frontend_workflow.md:62-64,702-704` still teaches flavorless commands (`flutter run -t lib/main_prod.dart`, `flutter build apk --release -t lib/main_prod.dart`, `flutter run -t lib/main_mock.dart`) that Gradle now refuses (`ENVIRONMENTS.md:251-253,279`); the guard scans only `docs`, `tool`, `.github`, `.githooks` (`test/guards/workflow_test.dart:168`), so this file escapes it. (c) **Corrected in verification - this is NOT drift today:** `ENVIRONMENTS.md:342` (and `app_identity_environment_audit_2026-10-04.md:184`) cite `openapi.yaml:896-900` for `registerFcmToken`, and that is exact against the committed pin 0df5cf4 (`git show HEAD:contract/openapi.yaml`: `/me/fcm-token` at `:896`, `operationId: registerFcmToken` at `:900`; other audits cite `:896-918` and `:896-899`). It becomes stale only when the uncommitted re-vendor lands: in the working-tree 65245be the path block starts at `:943` (operationId `:947`, not `:945`), and upstream 2e5bb69 has `:1060-1082` (operationId `:1064`).

#### 8. Push implementation - requirement by requirement

Contract source (CONTRACT, upstream 2e5bb69 `realtime.md:78-108`; **the committed pin 0df5cf4 has no push text in `realtime.md` at all, and the proposed 65245be does not vendor this section** - `grep -c "Push notifications" contract/realtime.md` = 0 in the working tree and in `HEAD`): four kinds (`support_ticket_replied`, `friend_request_received`, `academic_year_opened`, `chat_message_received`), localization-key notification messages, `data` = `kind` + opaque ids, the 8 keys (the handoff's EN/AR strings match `realtime.md:97-104` word for word; the verifier compared all 16), tap handling `:106`, token registration "after sign-in and on every token refresh" `:108`, and **"Delivery is off in every environment until the staging verification is recorded"** `:80` (`contract-changelog.md:59`). `registerFcmToken` is `stable`, 204/400/401, one token per student (`openapi_2e5bb69.yaml:1060-1082`). (added in verification) 65245be is not fully silent on push: `contract/realtime.md:61` and `contract/contract-changelog.md:75` already describe a chat push of kind `ChatMessageReceived` (PascalCase, "inert until the adr-129 gate opens"); upstream 3.43+ names the wire string `chat_message_received` (`realtime.md:76,82,91`), and only the 3.31 changelog entry still carries the old spelling as history (`contract-changelog.md:196`@2e5bb69). A payload parser built against the proposed 3.38 pin would never match the real kind. Severity MEDIUM; one more reason the pin must move to >= 3.43 before any push code.

| # | Handoff requirement | Status | Evidence |
| --- | --- | --- | --- |
| 1 | Notification permission prompt on iOS and Android 13+ | **ABSENT** | no permission or messaging package (`pubspec.lock` grep); no `POST_NOTIFICATIONS` in source (`AndroidManifest.xml:19`) or in the built release manifests (aapt2); no iOS code/entitlement. The contract text does not mention a prompt at all (`grep -i permission realtime.md` empty); this requirement comes from the handoff only |
| 2 | `registerFcmToken` (`PUT /me/fcm-token`) after sign-in | **ABSENT** | no call site: `grep -ri fcm lib test` -> only the comment `lib/features/settings/screens/settings_screen.dart:344` (plus one binary golden PNG); no repository method, no mock route. Natural hook points exist but are unused: `AuthController.markAuthenticated` (`lib/features/auth/notifier/auth_controller.dart:51`) and the cold-start token resolve (`:43-48`) |
| 3 | Re-register on token refresh | **ABSENT** | no Firebase SDK |
| 4 | Staging / production Firebase files | **ABSENT** | section 4; slots reserved, guard vacuous |
| 5 | Tap from terminated/background routes to the right screen | **ABSENT** | no `getInitialMessage`/`onMessageOpenedApp`-style code; router has no payload entry (`lib/core/router/app_router.dart` route list); see 8.1 for the router prerequisites |
| 5a | `ticketId` -> support ticket | **ABSENT (destination missing)** | `/support` is a disabled shell with a disabled Create Ticket button and no ticket list/detail (`app_router.dart:416-419`; `lib/features/account_shells/screens/customer_support_screen.dart:1-41`) |
| 5b | `friendRequestId` -> friend requests list | **ABSENT (destination missing)** | `/friends` is a disabled shell with no entry point (`app_router.dart:420-423`; `friends_screen.dart:1-43`); no friend-request model |
| 5c | `conversationId` -> conversation | **ABSENT** | no chat screen, route, SignalR client or conversation model; `grep conversation lib` finds no app code |
| 5d | `academic_year_opened` -> notifications screen | **PARTIAL** | a route exists but is a "coming soon" placeholder: `/message` -> `MessagePlaceholderScreen` (`app_router.dart:313-316`; `lib/features/shell/screens/tab_placeholder.dart:54-61`) |
| 6 | Unknown `kind` -> open notifications screen, ignore the rest | **ABSENT** | no push or inbox model; the inbox operations are never called (`grep listMyNotifications\|me/notifications lib test` -> nothing); Home bell is inert with a permanently-false unread flag (`lib/features/home/widgets/home_header.dart:14-17,29-36`); Settings notification toggles render disabled (`settings_screen.dart:341-355`) |
| 7 | The 8 `push_*` localization keys | **ABSENT** | `grep -i "push_" lib/l10n/*.arb` -> 0 (also 0 for `academic_year` except the unrelated label `studyYearLabel` "Academic Year", `app_en.arb:159`). Also no native resources: no `android/app/src/main/res/values/strings.xml` or `values-ar`, no iOS `Localizable.strings`, `knownRegions` lacks `ar` |
| 8 | Old `enrolment_opened` keys "may remain" | **Not present as push keys** | `grep -ri "enrolment_opened\|enrolmentOpened\|academic_year" lib test` -> 0 hits (the only `enrolment` ARB key is the unrelated `mistakesEnrolmentPending`, `app_en.arb:348`). (added in verification) `enrolment_opened` is nevertheless still an INBOX `kind` enum value at every pin even though it is never pushed (`realtime.md:82`: "not `enrolment_opened`, not `announcement`"): 0df5cf4 `openapi.yaml:1018` `[enrolment_opened]`; 65245be `:1071` `[enrolment_opened, announcement]`; 2e5bb69 `:1211` `[enrolment_opened, announcement, moderation_warning, support_ticket_replied, academic_year_opened]`. Any future inbox model must still decode `enrolment_opened`. Severity LOW |
| 9 | Privacy (no names/phones/text) | n/a client-side | server-side rule `realtime.md:83` |

Net: **zero of the push requirements are implemented**; the only "PARTIAL" is a route for the notifications screen that has no content. Platform-level prerequisites (Firebase, APNs key, entitlement, deployment target 15.0, native strings, Android POST_NOTIFICATIONS) are all missing.

##### 8.1 Routing prerequisites for tap handling (added in verification; severity MEDIUM)

- `authRedirect` (`lib/core/router/app_router.dart:74-83`): `if (status is AuthUnauthenticated && !atAuthRoute) return '/login';` - an unauthenticated student at any protected location is sent to `/login` and the location is discarded (no `from`/return parameter). A push tap that arrives while signed out, or after `session_superseded` eviction, therefore cannot be honoured after login. SOURCE.
- The `GoRouter` is built with `initialLocation: '/'`, `refreshListenable` and `redirect` only (`app_router.dart:109-112`); `grep errorBuilder|onException|errorPageBuilder` in `app_router.dart` -> none. A payload whose id leads to a route that does not exist has no localized fallback (go_router's built-in error page would apply; behaviour not run). An untracked roadmap from an earlier session (secondary, not a primary source) records the same gap as MI-244 / GAP2-19 ("before any deep-link or push work") and MI-236 / GAP13-12.
- Consequence: the handoff's "tapping a notification opens the correct screen" needs a router change (return-to-target and an error fallback), not only a Firebase message handler. The contract tap rules (`realtime.md:106`) are silent on the signed-out and evicted cases.

##### 8.2 Destination buildability by contract pin under the stable-only rule (added in verification; severity LOW)

The project builds only against `x-stability: stable` (`F:\level\level_up\level_up_app\CLAUDE.md`). Stability below was parsed by the corrector from the three openapi pins (matches SCRATCH/ops_table.txt):

| Push kind -> destination operations | 0df5cf4 (committed) | 65245be (proposed) | 2e5bb69 (upstream) | In-app destination today |
| --- | --- | --- | --- | --- |
| `support_ticket_replied` -> `getMySupportTicket` (+ `createSupportTicket`, `listMySupportTicketMessages`) | draft | draft | stable | `/support` disabled shell |
| `friend_request_received` -> `listMyFriendRequests` (+ `listMyFriends`) | absent | stable | stable | `/friends` disabled shell, no entry point |
| `chat_message_received` -> `listConversations` / `listConversationMessages` / `sendChatMessage` | absent | draft | stable | none |
| `academic_year_opened` / unknown kind -> inbox `listMyNotifications` | stable | stable | stable | `/message` placeholder; operations never called. The inbox enum contains `academic_year_opened` only at 2e5bb69 (`openapi_2e5bb69.yaml:1211`) |
| token registration `registerFcmToken` | stable | stable | stable | no call site |

So at the committed pin three of the four push destinations cannot be built under the stable-only rule (support draft; friends and chat absent); at 65245be two of four (support, chat) still cannot; only 2e5bb69 has all stable. The TODO comments in the two shells are stale to different degrees: `customer_support_screen.dart:9-11` (S33: "no endpoint of any kind. Not draft - absent") is already inaccurate at the committed pin, where the support operations exist as draft; `friends_screen.dart:9-13` (S36: "the contract has nothing behind it") is accurate at the committed pin and stale against 65245be and 2e5bb69.

#### 9. Decisions and risks that mention push; supersession

- **No D-0xx decides push.** D-001..D-021 contain no push decision; the only mention is D-021 Q7 (Seif input): "Firebase: the four ids ... must be registered before push, nothing registered, ownership and project sharing unsettled, backend has no Firebase credential and sends no push" (`DECISIONS.md:1060`).
- `docs/ENVIRONMENTS.md` section 7 (`:340-357`) and section 10 (`:420`, `:425-426`): "Treat push as not ready until told otherwise"; Firebase/FCM/APNs work follows Waves 1 and 3 and Seif saying push is ready. `RISKS.md` has **no push risk** (R-9 only notes ids key Firebase registration, `:134,:137`). `STORE_READINESS_RUBRIC.md:69-70` item 8a "decision recorded: push in v1 or deferred" is **open** (not ticked; note "a status, not a v1 decision"); `STORE_READINESS.md:230` and `seif_fight.md:1213-1227` (S28: no stored notification preference) are the other mentions. `docs/seif_fight.md` has no entry about FCM token removal (grep `fcm` -> `:123` and S28 `:1216` only).
- (added in verification) **R-9 as a gate:** `RISKS.md:137` (R-9 "Next action") forbids registering anything with Firebase until the client's accounts and Firebase ownership are settled, so a Firebase registration requested by the handoff conflicts with the register as written; the owner must lift or amend it. An untracked roadmap item MI-069 / GAP4-06 asks the owner the same (secondary). `notification_inbox_3_28_investigation.md:335` records the opposite for the inbox alone: it "does not depend on D-021 or R-9".
- **The 3.19.0-m1 guidance** ("This is an INBOX ... push still does not work ... Do not build ... a push-permission prompt from this entry") is at `contract-changelog.md:97` in the committed pin 0df5cf4 (`git show HEAD:contract/contract-changelog.md`), `:180` in the uncommitted working-tree copy (65245be) and `:301` upstream 2e5bb69 (corrected in verification: the investigator cited `:180` as "in the pin"). It was scoped to *that inbox entry*. It is **superseded in scope** by 3.43.0-m1 (2026-10-08), which publishes the push shape as `stable` and tells the app to register its token after sign-in and on refresh (`realtime.md:78,108`). It is **not superseded in timing**: delivery is still OFF in every environment (`realtime.md:80`), so "do not expect a push from any environment" stands. `notification_inbox_3_28_investigation.md:335` ("Not needed for the inbox: Firebase, POST_NOTIFICATIONS, APNs or a permission prompt") remains correct for the inbox alone.
- `roadmap_decisions.txt:91-99` in SCRATCH (the earlier session's untracked roadmap, DR-11 "Push notifications in v1?", question at `:92`, recommendation at `:96`) recommends recording "no push in v1"; that recommendation pre-dates the 3.43 push contract and the handoff and is not a decision.

#### 10. Implications for the completion workflow (SOURCE-derived, flagged where inferred)

1. Push cannot start from the repo as vendored: the pin must move to a contract that contains `realtime.md` section "Push notifications" (>= 3.43.0-m1; latest 3.45.0-m1). The proposed 3.38 re-vendor is already 12 upstream commits behind (`git log 65245be..2e5bb69` in the upstream clone = 12), lacks the section, and spells the chat push kind `ChatMessageReceived` where 3.43+ uses `chat_message_received` (section 8).
2. **Inferred (not BUILD-verified): the 8 keys are resolved by the phone, not by Flutter.** The contract says the phone "renders the keys from strings shipped in the app" and that text "follows the phone's language, not the in-app language switch" (`realtime.md:83`), and it sends `android.notification.title_loc_key`/`body_loc_key` and `apns...title-loc-key`/`loc-key`. By FCM/APNs semantics those keys resolve against native Android string resources (`values/` + `values-ar/`) and iOS `Localizable.strings` (needing `ar` in `knownRegions`/`CFBundleLocalizations`), so the ARB files alone will not satisfy the contract. The repo has none of those native resources today. Proof requires the first staging push once delivery is switched on.
3. iOS needs: bundle ids per scheme, deployment target 15.0, Push Notifications capability/entitlement, APNs key in Firebase, per-scheme `GoogleService-Info.plist`, Podfile/SwiftPM resolution, a re-check that the first Mac build's expected `AppDelegate`/`Info.plist` rewrite (DOC) keeps notification handling intact.
4. Android needs: `POST_NOTIFICATIONS` declared, runtime request on API 33+ (targetSdk is 36), per-flavor `google-services.json` under `src/{prod,staging}/`, the Google Services Gradle plugin. Whether the FCM SDK merges the permission automatically is UNKNOWN until built.
5. The contract is silent on three things the app must still decide or ask: the permission-prompt moment and denial path; foreground display; and what happens to the stored FCM token on logout/`session_superseded` (only `PUT` exists, `logout` says nothing about the token: `openapi_2e5bb69.yaml:451-461,1060-1082`; no DELETE; `:1075` "one token per the single active device").
6. (added in verification) Tap routing needs a router change first: return-to-target after sign-in and an `errorBuilder` (section 8.1), and three of the four destinations are not buildable under the stable-only rule until the pin is >= 3.43/3.44 (section 8.2).
7. (added in verification) The owner must lift or amend R-9's Firebase-registration gate (`RISKS.md:137`) and record rubric item 8a before any registration is requested of the client.
8. (added in verification) The `Accept: application/json` header (3.32) is unimplemented and `error_interceptor.dart:10` carries a comment 3.32 withdrew (section 5); independent of push, but part of this dimension's HTTP-defaults state.

#### 11. Decisions reserved for the owner or others (carried from the investigation; not for Claude to take)

- Whether push ships in release 1 or is deferred (rubric 8a) - product owner.
- Firebase project ownership and structure (one vs two projects), Apple Developer account/Team ID, APNs key issuance, registration of the four ids, and whether R-9's registration gate stands (D-021 does not decide store/account ownership) - owner/client with Seif.
- Production keystore generation, Play App Signing enrolment, and the first-upload version/build-number policy - owner.
- Moving the vendored contract pin (proposed 65245be is uncommitted and 12 commits behind 2e5bb69; push section needs >= 3.43.0-m1) - owner.
- Notification permission-prompt timing and copy, foreground-notification behaviour, and which screen is "the notifications screen" (Message tab vs bell) - designer and owner.
- Handoff item (1) "status screen with a website link" versus adr-049 section 3 / RISKS R-10 (no purchase link; the per-flavor `/redeem` URL slot withdrawn in 8e641e9) - owner and Seif must revise the contract rule or decline.
- Whether to keep or delete `lib/main.dart`, and any change to the ratified flavor names - low stakes but owner-visible (`ENVIRONMENTS.md` section 4.3).
- Whether to build the Wave 3 iOS changes at SOURCE level on this machine before a Mac exists (reported at SOURCE only) - owner scheduling call.


## 8. Push notification state (contract side; implementation side is in section 7)
### Push notification contract state

**Status (unchanged at 3.46: `realtime.md` untouched, and `CL46:7-18` does not mention push).** "**The shape below is `stable`. Delivery is off in every environment until the staging verification is recorded, then switched on in production per adr-221.** Build against the shape now; do not expect a push from any environment until you are told it is on." (`RT:80`)

- **Server side:** the senders exist "behind the off-by-default gates (the FCM sender, the friend-request push, the academic-year opening and the coalesced chat push)… push delivery is still off in every environment" (`CL:34`).
- "Push is off in every environment today. Nothing is sent until the staging check is recorded." (`CL:59`)
- The stable inbox description agrees: "Push delivery is not enabled in any environment today." (`OA:1191-1192`)

(CONTRACT)

**Kinds, keys and data** (`RT:82-91`): "Exactly four kinds push … Nothing else is ever pushed — not `enrolment_opened`, not `announcement`."

| `kind` | Title key / body key | FCM `data` | Tap behaviour (`RT:106`) | Inbox row? |
|---|---|---|---|---|
| `support_ticket_replied` | `push_support_ticket_replied_title` / `_body` | `kind`, `ticketId` | open the ticket (`getMySupportTicket`) | yes, same kind (`OA:1186-1192`) |
| `friend_request_received` | `push_friend_request_received_title` / `_body` | `kind`, `friendRequestId` | `friendRequestId` equals the incoming request's `requestId`; open the friend-requests list (`listMyFriendRequests`) | no (not in the inbox enum, `OA:1211`) |
| `academic_year_opened` | `push_academic_year_opened_title` / `_body` | `kind` only | open the notifications screen; the same event arrives as an inbox item whose `track` / `academicYear` are inbox `data`, "never push `data`" | yes |
| `chat_message_received` | `push_chat_message_received_title` / `_body` | `kind`, `conversationId` | open the conversation | **no**: "it writes no inbox row" (`RT:76`, `RT:106`) |
| unknown | — | — | "**open the notifications screen and ignore the rest**" (`RT:106`) | — |

**Wire format** (`RT:83-84`):

- These are notification messages "with localization keys, never text".
- Android receives `android.notification.title_loc_key` / `body_loc_key`.
- iOS receives `apns.payload.aps.alert.title-loc-key` / `loc-key` with `sound: default`.
- "The phone renders the keys from strings shipped in the app, so **the text follows the phone's language**, not the in-app language switch."
- "`data` holds `kind` … and opaque ids only, all string values. Any other key is never sent."
- Privacy: "no title or body text, no name, no message text and no ticket subject" (`RT:83`).

**The eight strings** (`RT:93-104`, unchanged at 3.46). The contract side was verified twice: the verifier re-ran `python -I -X utf8 compare_push.py upstream-contract/realtime.md` and the corrector re-ran it against the 3.46 `realtime.md`, both with output `ALL IDENTICAL` (8/8 keys at `realtime.md:97-104`, no contract key missing from the handoff set, no bidi/control characters). **The handoff side is unverifiable by the verifier and the corrector:** the 16 EN/AR handoff strings exist only as transcriptions of the handoff text inside `SCRATCH/compare_push.py:4-13` and `SCRATCH/aud/push_cmp.py` (both scripts carry the same 16 strings), and the computed task text names the 8 keys without their text. "Identical to the handoff" therefore rests on those transcriptions (UNVERIFIED); nothing found contradicts it.

| Key | English | Arabic |
|---|---|---|
| `push_support_ticket_replied_title` | Support replied | رد فريق الدعم |
| `push_support_ticket_replied_body` | You have a new reply on your support ticket. | لديك رد جديد على تذكرة الدعم. |
| `push_friend_request_received_title` | Friend request | طلب صداقة |
| `push_friend_request_received_body` | You have a new friend request. | لديك طلب صداقة جديد. |
| `push_academic_year_opened_title` | New academic year | عام دراسي جديد |
| `push_academic_year_opened_body` | A new academic year has started. Open the app to get ready. | بدأ عام دراسي جديد. افتح التطبيق واستعد. |
| `push_chat_message_received_title` | New message | رسالة جديدة |
| `push_chat_message_received_body` | You have a new message. | لديك رسالة جديدة. |

**Frequency** (`RT:107`, `RT:76`):

- At most one push per event.
- "Each kind is limited per student per hour"; the numeric limit is not stated.
- A chat conversation produces at most one push per 5 minutes, and none "while the app's chat connection received the message".

**Token registration.** "The app registers its FCM token after sign-in and on every token refresh (`registerFcmToken`, `PUT /api/v1/me/fcm-token`); one token per student, the latest wins." (`RT:108`)

`registerFcmToken` (`OA:1060-1082`) is stable:

- **Body:** `{token: string}` (required).
- **`204`:** "Stored (idempotent; one token per the single active device)".
- **`400 validation_failed`:** `token` absent, empty or whitespace-only, or longer than 4096 characters. A non-JSON body is also `400`, "never `415`" (`CL:316`).
- **`401`:** declared.
- **403:** none declared, but the global default-deny `403 account_pending_deletion` applies (`OA:63-71`).
- **Missing operations:** "No `DELETE`/unregister (uninstalling the app or registering a new device is how a token stops being used), no per-device registration, no token read-back, no notification preferences, no consent endpoint of any kind, and no send/test operation." (`CL:319`; also `CL:302`)
- **Logout:** `logout` (`OA:451-461`) says only "Revoke this session (access + refresh chain)" and declares only 204/401. **Nothing is said about the stored FCM token on logout** (UNKNOWN; see questions). A grep of `docs/seif_fight.md` for `fcm` hits only `:123` and `:1216` (S28), so the logout question is not already filed (DOC).

**Absent from the contract** (grep for `firebase|google-services|applicationId|bundle id|permission` over `OA`, `RT`, `EC`, `CL` → 0 hits):

- which Firebase project serves each environment;
- app IDs;
- the APNs key;
- the OS notification-permission prompt.

**Corrected in verification:** an older changelog entry forbade a permission prompt "from this entry": only `CL:301` (the 3.19 inbox entry) says "Do not build … a push-permission prompt from this entry". `CL:308` (the 3.18 promotion) forbids a "notifications enabled" indicator, an inbox or any delivery-state UI from that promotion and does **not** mention a permission prompt. Both are superseded by `RT:80` "Build against the shape now".

Repo docs record Seif's Q7 (2026-10-06):

- "no Firebase credential in any environment";
- "ownership and app registration are not yet coordinated";
- "whether the two flavors share one Firebase project is not finalised";
- iOS needs an APNs key.

They also reserve the file locations `android/app/src/{prod,staging}/google-services.json` and `ios/Runner/Firebase/{prod,staging}/GoogleService-Info.plist` (DOC, `docs/ENVIRONMENTS.md:340-357`, `docs/DECISIONS.md:1060`). The same Q7 line says "**no deep links in release 1**" next to "website host `level-upworld.com` with `/redeem` opened in the browser" (`docs/DECISIONS.md:1060`). The push tap routing in `RT:106` needs reconciling with that. **Reading (INFERRED, added in verification):** Q7 is Seif's input about URL entry points; a push tap navigates from an FCM `data` payload (`kind` + opaque id, `RT:84`, `RT:106`), not from a URL, so the two are different mechanisms. The store audit records that the current manifest has no deep links/App Links (`.ai/audits/current/store_readiness_audit.md:76`; the only intent-filter in `android/app/src/main/AndroidManifest.xml` is MAIN/LAUNCHER, 1 filter). That line describes the build, it is not a reading of Q7. The owner still has to confirm the reading.

**App state (SOURCE):**

- No `firebase_*` dependency (`pubspec.yaml:30-65`), and no Firebase config files (established).
- The source `android/app/src/main/AndroidManifest.xml` declares only `INTERNET` (`:19`); there is **no `POST_NOTIFICATIONS`**. (DOC-recorded ARTEFACT: the merged release manifest also carries `ACCESS_NETWORK_STATE` from `connectivity_plus`, `.ai/audits/current/store_readiness_parts/03_android_src.md:33`; not re-measured here.)
- `android/app/src/main/res/values/` holds only `colors.xml` and `styles.xml`; `values-night/` holds only `styles.xml`. There is no source `strings.xml` and no `values-ar`. (The `app_name` string resource is generated per flavor at build time by Gradle `resValue`, `android/app/build.gradle.kts:72`, `:77`, not by a source file.)
- `ios/Runner` holds `AppDelegate.swift`, `Assets.xcassets`, `Base.lproj`, `GeneratedPluginRegistrant.*`, `Info.plist`, `Runner-Bridging-Header.h`: no `.strings` file, and `Info.plist` has no `CFBundleLocalizations` (only `CFBundleDevelopmentRegion`, `:5`).
- **iOS push prerequisites (added in verification, SOURCE):** there is no `*.entitlements` file anywhere under `ios/` (so no `aps-environment`), and `Info.plist` has no `UIBackgroundModes` / `remote-notification`. The Push Notifications capability (and Background Modes if background delivery is wanted) must be added in Xcode, which, like the rest of Wave 3, needs a Mac with Xcode 26 (`docs/ENVIRONMENTS.md:101`, `:284`, `:368`). The iOS bundle id is still the template id `com.levelup.levelUpApp` (`ios/Runner.xcodeproj/project.pbxproj:371`) with deployment target 13.0 (`:349`).
- No ARB `push_*` keys exist.
- No `enrolment_opened` string exists anywhere in `lib/` (grep for `enrolment_opened|support_ticket_replied|moderation_warning|academic_year_opened|firebase|signalr|account_banned|terms_acceptance_required|push_` over `lib/` → 0 files), so the handoff's "old keys may remain in the app" is moot: there are none.

Because the OS resolves the loc keys before Flutter runs, the 8 strings must ship as **native** resources: Android `values/` + `values-ar/` `strings.xml`, and iOS `en.lproj` / `ar.lproj` `Localizable.strings` (with `CFBundleLocalizations` added). Flutter ARB alone cannot serve them (INFERRED from `RT:83`).

**Contract inconsistencies about push (CONTRACT, unchanged at 3.46):**

- (a) The stable `sendFriendRequest` says "The recipient is not notified (no push or inbox item in this version)" (`OA:3162`). `realtime.md` defines `friend_request_received` (`RT:82`, `RT:89`).
- (b) `forwardQuestion` says a push of kind "`ChatMessageReceived`" is made (`OA:3707-3708`). The wire string is `chat_message_received` (`RT:76`, `RT:82`, `RT:91`). The working-tree 3.38 `contract/realtime.md:61` also says `ChatMessageReceived`.
- (c) **(3.46, added in verification)** The `support` tag description still reads "Text only for launch (Seif 2026-10-07, amending adr-187): attachments arrive later as an additive change in their own spec. Every operation here is `stable`." (`OA:133-137`, byte-identical at `eddb6ac`), although the photo operations are now stable and carry the attachments.
- (d) **(3.46, added in verification)** `error-codes.md` rows 16 and 61-67 still say "(draft)" for the photo uses (see above).
- (e) **(3.46, added in verification)** The `CL46:7-18` entry carries no "Consumers affected" line, which the file's own standing rule requires (`contract-changelog.md@eddb6ac:3`: "every entry must state which consumers it affects").
- (f) At 3.45 the same support tag also contradicted the three then-draft photo operations (`OA:133-137` vs `OA:2848/2899/2945`); this is the 3.45 form of (c).

### Inbox and moderation contract

**`listMyNotifications`**: GET `/me/notifications`, stable (`OA:1144-1222`).

- **Parameters:**
  - `cursor`.
  - `limit` (1..100, default 20; `OA:3869-3879`).
  - optional `category` ∈ `{system, announcements, support}`. Absent means All; "A category no kind maps to yet returns an empty page"; an unknown value is `400 validation_failed` (`OA:1153-1159`, `OA:1218`).
- **`200`:** a `CursorPage` of `{notificationId: Uuid, kind: enum, category: enum, data: map<string,string>, createdAt, readAt: date-time|null}`, all required (`OA:1198-1216`).
- **Rules** (`OA:1162-1168`):
  - "`kind` + `data` are a LOCALIZATION CONTRACT".
  - "Branch on `hasMore`".
  - "Clients MUST ignore an item whose `kind` they do not recognise, and MUST ignore an unknown `category` value".

| `kind` | `category` | `data` keys | Rendering rule | Push? | Cite |
|---|---|---|---|---|---|
| `enrolment_opened` | `system` | **not documented** (only "a flat `data` map of string substitution values"; written "shortly after a student's first enrolment opens"). Searched: the three `openapi.yaml` pins, the changelog, `openapi-admin.yaml`, `contract-changelog-admin.md` → no key list anywhere | app-localized | never (`RT:82`) | `CL:212`, `CL:296`, `CL:303` |
| `announcement` | `announcements` | exactly `announcementId, titleAr, titleEn, bodyAr, bodyEn` | Admin-written display text: Ar/En by **UI** language, plain text, keep line breaks, **never auto-link** | never | `OA:1168-1174` |
| `moderation_warning` | `system` | always empty | fixed approved copy (below), in the UI language | no | `OA:1174-1185`, `CL:67-69` |
| `support_ticket_replied` | `support` | exactly `ticketId`, `reference` (`TK-…`, display only); never reply text or staff name; one item per staff reply | app-localized; open with `getMySupportTicket` | yes, once push is enabled | `OA:1186-1192`, `CL:87-94` |
| `academic_year_opened` | `system` | exactly `track` (`school`/`university`), `academicYear` (`YYYY/YYYY`), as localization parameters | app-localized | yes; the push carries neither key | `OA:1193-1197` |

**`kind` enum history:**

- 0df5cf4 `[enrolment_opened]` (`OA28:1018`).
- 65245be `[enrolment_opened, announcement]` (`OA65:1071`).
- 2e5bb69 adds `moderation_warning, support_ticket_replied, academic_year_opened` (`OA:1211`); the `category` enum is `[system, announcements, support]` (`OA:1159`, `OA:1212`). Unchanged at 3.46.

The contract supplies no EN/AR copy for `enrolment_opened`, `support_ticket_replied` or `academic_year_opened`. The changelog suggests only a generic English "Support replied to your ticket" (`CL:94`).

**`moderation_warning` approved copy** ("approved in writing by the client, 2026-10-07", `OA:1177-1185`, verbatim after YAML folding; the verifier reproduced it exactly via PyYAML):

- **EN title:** "A message about your account".
- **EN body:** "We received a report about content from your account that does not follow the Level Up community rules. This is a warning. Please keep your messages and photos respectful. If this happens again, your account may be banned. If you think this is a mistake, contact Support from the app."
- **AR title:** "رسالة بخصوص حسابك".
- **AR body:** "وصلنا بلاغ عن محتوى من حسابك لا يتوافق مع قواعد مجتمع Level Up. هذا تنبيه لك. من فضلك حافظ على احترام الآخرين في رسائلك وصورك. إذا تكرر ذلك فقد يتم إيقاف حسابك نهائيا. إذا كنت ترى أن هذا حدث بالخطأ، تواصل مع الدعم من داخل التطبيق."

**Other inbox operations:**

- **`getUnreadNotificationCount`:** returns `{unreadCount: integer ≥0}` (required). "Zero is an ordinary answer"; it is always the total across tabs, never per tab (`OA:1223-1241`, `OA:1157-1158`, `CL:213`).
- **`markNotificationRead`:** POST `/me/notifications/{notificationId}/read` → `204`, idempotent; "`readAt` is set once and is never moved". An unknown **or foreign** id gets `404 not_found`, deliberately not 403 (`OA:1242-1262`).
- **Not provided:** delete/dismiss, mark-all-read, unread-only filter, preferences/mute, and any realtime push of inbox items. Clients poll (`CL:302`, `CL:294`, `CL:301`).

**App (SOURCE):**

- No inbox client exists; nothing in `lib/` calls `me/notifications`.
- The `/message` tab is `MessagePlaceholderScreen` (`lib/core/router/app_router.dart:313-316`).
- There is no notifications route. The established route list has no ticket-detail, conversation or friend-requests route either. So every push tap target in `RT:106` still has to be built.

**Account bans (spec-062, CONTRACT):**

- **Where it is returned:** `403 account_banned` comes back "**only after a one-time code has been verified**", by exactly four operations (PyYAML confirms `403` on exactly these four):
  - `verifyOtp` (`OA:230-232`; the code is consumed);
  - `verifyRedemptionSessionOtp` (`OA:371`; web);
  - `verifyParentOtp` (`OA:542`);
  - `confirmRecovery` (`OA:625`).
- **Result:** "No tokens and no session are issued."
- **Never returned:**
  - before a code is proven (`requestOtp`, `requestRedemptionSessionOtp` and `startRecovery` answer normally);
  - on `refreshTokens` or any authenticated request. "The ban revoked every session, so those answer the existing `401`s (`refresh_token_invalid`, `authentication_required`) and the next sign-in shows this code." A Support Admin can lift a ban (`EC:51`).
- **Client copy:** "suggested; the client owns the strings": EN "Account banned — contact Support", AR "تم حظر الحساب — تواصل مع الدعم". "Do not retry; route to Support" (`EC:51`).
- **What to build:** "a 'this account has been banned — contact Support' screen" (`CL:66`). "A signed-in app falls back to its normal signed-out path" (`CL:65`).
- **Chat hub:** the hub refuses invalid tokens (`RT:23`).
- **Gap:** every `/support/*` operation requires bearer auth (global `security: bearerAuth`, `OA:110-111`; none declares `security: []`), and a banned student never gets a session. **The contract offers a banned student no in-app Support path** (CONTRACT, UNKNOWN resolution).
- **App (SOURCE):** `authErrorMessage` maps only `otp_invalid`, `otp_expired`, `otp_throttled` and `validation_failed` (`lib/features/auth/auth_error_copy.dart:13-22`) and returns `l10n.genericError` otherwise (`:24`). `account_banned` falls through to `genericError` (grep `account_banned` over `lib/` → 0).

### Chat realtime contract

| Item | Contract | Cite |
|---|---|---|
| Protocol / library | "Realtime contract — SignalR (ADR-026 §9)". No Dart client is named; "in most SignalR clients: `transport: WebSockets`, `skipNegotiation: true`" | `RT:1`, `RT:24` |
| Status | `chat` hub **stable** since 3.39.0-m1; forwarded-question events stable since 3.44.0-m1. `leaderboard` hub "not drafted"; `streaks` folded into `chat`, "will not be built" | `RT:9-11`, `RT:15`, `RT:56`, `CL:118` |
| Scope | "Every state change in chat is a REST call … this hub only **pushes** what changed, plus one fire-and-forget `typing` signal. Photo, voice and group chat are not part of it." | `RT:17` |
| Route | `/hubs/chat` (outside `/api/v1`) | `RT:21` |
| Auth | same bearer access token as REST, in `Authorization` or, for the WebSocket handshake, the `access_token` query parameter ("scrubbed from every server log") | `RT:22` |
| Connect refused | invalid/expired token, superseded session, account pending deletion | `RT:23` |
| Transport | "**WebSockets only, with `skipNegotiation: true`** … Pass the token through the client's access-token option". Reason: multi-server production behind a load balancer; "Do this before you point a build at production" | `RT:24-26`, `CL:30-33` |
| Session checks | at connect, on every invocation, before every push; superseded → aborted; closes when the access token expires, so reconnect with a fresh one | `RT:30-32` |
| Connection cap | "At most 3 open `chat` connections per student … A fourth connection closes the OLDEST one … Open one connection per app instance and reuse it." | `RT:33` |
| Client → server | `typing({conversationId})`, fire-and-forget; unauthorized or over the limit (30 per student per 60 s) is dropped silently | `RT:39` |
| Server → client | `messageCreated {message: ChatMessage}` · `messageEdited {message}` · `messageDeleted {conversationId, messageId}` (for-everyone only) · `conversationRead {conversationId, lastReadMessageId}` (the peer's cursor) · `typing {conversationId}` (show for about 5 s, client-side timeout) · `conversationRemoved {conversationId}` (unfriend, block or Track transfer, identical in every case: "never infer a block") | `RT:45-52` |
| Forwarded questions | a card arrives via `messageCreated` with `message.kind: forwardedQuestion`. `forwardedQuestionAnswered {message: ChatMessage}` (each side gets its OWN view; replace the card). `friendStreakChanged {friendStreak: FriendStreak}`: `friendStudentId` is always the other participant; not sent when the count is unchanged; a break at Cairo midnight emits nothing | `RT:58-63` |
| Delivery / backfill | at-most-once, best-effort. "after (re)connecting, call `listConversations`, then `listConversationMessages` for the open conversation. REST is the source of truth." Streak/card backfill: `listMyFriendStreaks`, `listConversationMessages`. Expiry emits no event; drop what REST no longer returns | `RT:65`, `RT:69-72` |
| Payload schemas | `ChatMessage` = `messageId, conversationId, sentByMe, kind` (enum `[text, forwardedQuestion]`; render an unknown kind as a neutral "not supported in your version" bubble), `body` (nullable, ≤500; null for tombstones and cards), `forwardedQuestion` (nullable), `sentAt, editedAt` (nullable), `deletedForEveryone`, all required. `FriendStreak` = `friendStudentId, conversationId, count` (≥1), `stepTakenToday` | `OA:4750-4782`, `OA:4866-4878` |
| Tombstones | a message Support removed after a report has the same shape as delete-for-everyone; "the client cannot tell the two apart and must not try" | `OA:4755-4757`, `CL:70` |
| Chat push | `chat_message_received`, at most one per conversation per 5 min, none when the hub delivered on the serving instance, no inbox row; a forwarded card pushes like text, and answering a card pushes nothing | `RT:76` |

INFERRED consequences:

- **Hub URL:** the app's base URL includes `/api/v1` (`lib/core/config/app_config.dart:44`), so the hub URL must be derived from the host. Staging would be `https://level-up-backend-staging.up.railway.app/hubs/chat` (`OA:107-109` + `RT:21`). The production host is TBD (`app_config.dart:54`; the planned `api.level-upworld.com` is not in `servers:`, `docs/DECISIONS.md:1056`).
- **Reconnects:** the access JWT lives about 15 min (`OA:56`), so the hub connection will close and reconnect on that cadence (`RT:32`).

SOURCE: there is no SignalR client in `pubspec.yaml:30-65` (also `docs/STATUS_REPORT_2026-07-28.md:66`). `web_socket_channel` 3.0.3 is present only transitively (`pubspec.lock:1357-1361`), and it is not a SignalR client.

**Pin drift (CONTRACT, `git -C upstream-contract show <c>:realtime.md`):**

- 65245be (the working-tree re-vendor) has the hub as **draft** ("Do not build against it yet"), **no** `skipNegotiation`, **no** 3-connection cap, **no** forwarded-question events, and **no** Push section. The working-tree `contract/realtime.md` is 61 lines, the hub is marked draft at `:11`/`:15`, and a grep for `skipNegotiation|At most 3|Push notifications` over it → 0 hits.
- The cap first appears in b33e658 and the version string stays `3.38.0-m1` (cap counts: 65245be 0, b33e658 1, 495dc45 1). So "3.38.0-m1" names three different contract snapshots.
- Push appears at cadba7b (3.43); `skipNegotiation` at c7badad (labelled 3.43).
- 3.44 was never mirrored as its own snapshot: 2e5bb69 carries both 3.44 and 3.45.
- 3.46 (eddb6ac) did not touch `realtime.md`.



## 9. Upload / photo state
### Upload/photo contract state

#### Stability of every photo-related operation across the pins (CONTRACT, `SCRATCH/ops_table.txt`; `eddb6ac` column added in verification)

| operationId | Method + path | 0df5cf4 (3.28, committed) | 65245be (3.38, working tree) | 2e5bb69 (3.45) | **eddb6ac (3.46, live upstream HEAD)** |
|---|---|---|---|---|---|
| `listDefaultAvatars` | GET `/reference/avatars` | stable | stable | stable (`OA:908`) | stable |
| `getMyProfile` / `updateMyProfile` | GET / PATCH `/me` | stable | stable | stable (`OA:932`, `OA:946`) | stable |
| `uploadCustomAvatar` | PUT `/me/avatar` | draft | draft (old shape "≤ 5 MB", only 200/401/422, `OA65:912-942`) | draft (finalised in 3.42, `OA:981`) | **stable** (`OA:981` flipped) |
| `removeCustomAvatar` | DELETE `/me/avatar` | (absent) | (absent) | draft (`OA:1041`) | **stable** (`OA:1041` flipped) |
| `createSupportTicket`, `listMySupportTickets`, `getMySupportTicket`, `listMySupportTicketMessages`, `postMySupportTicketMessage` | `/support/tickets…` | draft | draft | **stable** since 3.39 (`OA:2657/2704/2739/2762/2800`, `CL:113`) | stable |
| `createSupportAttachmentUpload` | POST `/support/attachments` | (absent) | (absent) | draft (`OA:2848`) | **stable** (`OA:2848` flipped) |
| `completeSupportAttachment` | POST `/support/attachments/{attachmentId}/complete` | (absent) | (absent) | draft (`OA:2899`) | **stable** (`OA:2899` flipped) |
| `getMySupportAttachmentContent` | GET `/support/tickets/{ticketId}/attachments/{attachmentId}/content` | (absent) | (absent) | draft (`OA:2945`) | **stable** (`OA:2945` flipped) |
| `getTermsAcceptance` / `acceptTerms` | GET / POST `/me/terms-acceptance` | stable | stable | stable (`OA:1086`, `OA:1115`) | stable |
| `getLegalDocument` | GET `/reference/legal-documents/{document}` | (absent) | (absent) | stable since 3.43 (`OA:814`) | stable |

**Corrected conclusion.** At 3.45 the five operations still `draft` were exactly the five photo operations. At 3.46 nothing is `draft` (86/86 `stable`), so the stable-only rule (`OA:3`, `OA:30-31` "Paths marked `x-stability: draft` are NOT safe to build against") no longer blocks avatar upload/removal or support photos upstream. What still blocks them is the pin: neither the committed pin 0df5cf4 nor the proposed 65245be contains these shapes (at 65245be `uploadCustomAvatar` is the old "≤ 5 MB" draft with only 200/401/422, `OA65:912-942`, and there are no support-attachment operations). Text-only support has been buildable since 3.39 (CONTRACT).

**The flip (3.46.0-m1, 2026-10-08), `CL46:7-18`:**

- Title: "Support photos and custom avatars are now `stable` — build these screens now"; "Breaking: no; no shape changed."
- Evidence it cites: "the staging live proof passed on 2026-10-08: photos 18 PASS / 0 FAIL, avatars 19 PASS / 0 FAIL, real Google Vision scan, private photo storage, metadata stripped from avatars"; "main CI is green and staging serves these operations"; "Flipped on Seif's explicit word".
- The earlier flip criterion was "The photo operations stay `draft` until they are served on staging" (`CL:79`). That criterion is now recorded as met (CONTRACT; the changelog's live-proof figures are Seif's claim and were not reproduced by us).

**Staging serves the routes (LIVE-PROBE, 2026-10-08, unauthenticated, added in verification).**

- `GET https://level-up-backend-staging.up.railway.app/health/version` → `{"commit":"a158daa33231f2d8d8812092d8c9f7745552362a","environment":"Staging","builtAtUtc":"2026-10-08T15:16:14Z"}`. That is the backend commit `eddb6ac` mirrors ("Mirror contract from level-up-backend@a158daa"). Run by the verifier and re-run by the corrector.
- Verifier's probes, all `401` (route matched, auth required): `PUT /api/v1/me/avatar`, `DELETE /api/v1/me/avatar`, `POST /api/v1/support/attachments`, `POST /api/v1/support/attachments/<uuid>/complete`, `GET /api/v1/support/tickets/<uuid>/attachments/<uuid>/content`.
- Corrector's re-run (GET only): the attachment-content route → `401`; `GET /api/v1/me/avatar` → `405` (the route exists but allows only PUT/DELETE); a non-existent `/api/v1/support/nonexistent-xyz` → `404`; control `GET /api/v1/me` → `401`; control `GET /api/v1/this-route-does-not-exist` → `404`.
- **Caveat:** `401`/`405` prove the route is registered, not that storage and SafeSearch are configured. A `503 image_upload_unavailable` remains possible. The "18 / 19 PASS" live proof is the changelog's claim.

#### A. Avatar

**`listDefaultAvatars`**: GET `/reference/avatars`, stable, `x-consumers: [mobile, web]`, `security: []` (public), "The 20 default avatars". `200` returns a bare array of `{id: Uuid, url: uri}`, both fields required. `429 rate_limited` asks the client to honour `Retry-After` (`OA:905-928`). (CONTRACT)

**`StudentProfile.avatar`** (stable, and required on `StudentProfile`, `OA:4317`), from `OA:4229-4240`:

| Field | Type | Required | Contract text |
|---|---|---|---|
| `type` | enum `[default, custom]` | yes | |
| `id` | Uuid | no | "Present for default avatars; absent for `custom`." |
| `url` | uri | yes | For `custom`: "the student's own photo on the avatars CDN — a NEW url on every upload, so never cache by url across uploads; clients must not assume the default-avatar host." |

PyYAML shows `required: [type, url]` already at 0df5cf4 and 65245be, so no pin ever required `id` (CONTRACT, added in verification).

App (SOURCE): `ProfileAvatar` is `{required String type, String? id, required String url}` (`lib/features/profile/models/student_profile.dart:115-122`). It already decodes a `custom` avatar, which has no `id`. No decode break.

**`updateMyProfile`**: PATCH `/me`, stable. Every body field is optional ("absent = unchanged"):

- `name` (maxLength 100)
- `email` (string or null; null clears it)
- `avatarId` (Uuid)
- `leaderboardVisible`
- `scoreHidden`

The description reads: "Choosing `avatarId` (a default avatar) also REPLACES an active custom avatar, whose photo is deleted (spec-070)" (`OA:949-965`). Responses are 200 `StudentProfile`, 400 `validation_failed` and 401 (`OA:966-977`). The contract does not say what an unknown `avatarId` returns on PATCH. `avatar_not_found` (404) is registered for "registration (spec-002)" only (`EC:47`), and PATCH declares no 404. **UNKNOWN in the contract — but already filed as `S45` (`docs/seif_fight.md:647`, full entry `:1635-1650`, filed 2026-09-28), so the workflow must not file it a second time (DOC, added in verification).**

**`uploadCustomAvatar`**: PUT `/me/avatar`, **draft at 3.42–3.45, stable since 3.46.0-m1** (`OA:979-1038`, stability line `OA:981`).

- **Request:** `multipart/form-data` with exactly one required part named `image` (binary) (`OA:1002-1007`).
- **Byte rules** (`OA:985-998`):
  - JPEG, PNG or WebP.
  - **at most 2,097,152 bytes (2 MiB)**.
  - each side 128–4,096 px.
  - at most 16,000,000 pixels.
  - not animated.
  - "nothing after the image's end".
  - The part's Content-Type and file name are ignored; the bytes decide.
- **Client guidance:** crop to a square and upload it upright. PNG/WebP orientation metadata is not kept.
- **Server behaviour:**
  - It strips metadata without re-encoding; a JPEG keeps only its orientation.
  - It runs a safety check.
  - "If any step refuses, nothing is stored and the previous avatar stays."
  - On success, every upload gets a **new** URL on the avatars CDN host, and the previous custom photo is deleted.

| Status | Body / code | Meaning (contract) | Cite |
|---|---|---|---|
| 200 | `{avatarUrl: uri}` (required) | "Accepted, published and set." The URL contains no identity and changes on every upload | `OA:1009-1017` |
| 400 | `validation_failed` | not exactly one multipart part named `image` | `OA:1018-1020` |
| 401 | `authentication_required` · `session_superseded` | | `OA:1021-1023` |
| 403 | `account_pending_deletion` · `terms_acceptance_required` | "photo uploads need it" | `OA:1024-1026` |
| 413 | `image_too_large` | over 2,097,152 bytes; "The server stops reading at the limit" | `OA:1027-1029` |
| 422 | `image_content_invalid` · `image_rejected_by_moderation` | one answer for every byte-level cause · safety check refused: show "this photo can't be used"; nothing stored, avatar unchanged | `OA:1030-1032` |
| 429 | `rate_limited` | ≤5 uploads per student per hour; after 3 refused photos in an hour, every upload is refused until the hour clears; honour `Retry-After` | `OA:1033-1035` |
| 503 | `image_upload_unavailable` | storage or safety check not configured, down, timed out or no usable answer ("never treated as a pass"); nothing stored | `OA:1036-1038` |

**`removeCustomAvatar`**: DELETE `/me/avatar`, **draft at 3.42–3.45, stable since 3.46.0-m1** (stability line `OA:1041`).

- **Effect:** the profile goes back to "the default avatar the student last chose (or the server default)".
- **Public file:** deleted; CDN edge copies expire within an hour.
- **Idempotent:** returns `204` when there is no custom avatar.
- **Other responses:**
  - 401.
  - 403 `account_pending_deletion` only; there is **no Terms gate** on removal.
  - 429 shares the profile-write budget.
- Cite: `OA:1039-1059`.

**History:** 3.42 moved the avatar cap from 5 MB to 2,097,152 bytes and added the 400/403/413/429/503 answers. It also added `removeCustomAvatar` and the `updateMyProfile` replace rule (`CL:80-84`). 3.46 made both operations `stable` (`CL46:7-18`) with no shape change; `CL46:11` repeats "Avatars are at most 2 MiB and 128–4,096 px a side". The working-tree re-vendor (65245be) still carries the pre-3.42 text: "JPEG/PNG/WebP ≤ 5 MB" (`OA65:925`).

#### B. Support photos (spec-067)

**Flow (CONTRACT).** All three photo operations are `stable` at `eddb6ac` (3.46); they were `draft` at 3.42–3.45.

1. **Presign:** `createSupportAttachmentUpload`, POST `/support/attachments` (`OA:2846-2895`, stability line `OA:2848`).
   - **Request** (`CreateSupportAttachmentUploadRequest`, `OA:4029-4035`), all required:
     - `contentType`: enum `[image/jpeg, image/png, image/webp]`.
     - `sizeBytes`: int64, 1..**7,000,000**, "the exact byte length of what will be PUT".
     - `sha256`: pattern `^[0-9a-fA-F]{64}$`, "hex SHA-256 of exactly the bytes that will be PUT".
   - **`201`** (`SupportAttachmentUpload`, `OA:4036-4054`): `{attachmentId: Uuid, upload: {method: enum [PUT], url: uri, headers: map<string,string>, expiresAt: date-time}}`, all required. There is no `Location` header.
   - **Never log or share the URL** (`OA:2871`, `OA:4045`).
   - **`upload.headers`:** "Send EVERY header here verbatim with the PUT (`Content-Type`, `Content-Length`, `x-amz-checksum-sha256`, `x-amz-acl`); they are part of the signature" (`OA:4049-4051`).
   - **Guidance:** "Downscale before uploading (about 2048 px on the long edge, JPEG)" (`OA:2861`).
2. **PUT to storage:** "PUT the bytes to `upload.url` with EXACTLY the headers in `upload.headers` (they are signed; a missing or changed header fails), before `upload.expiresAt` (at most 15 minutes). The bytes go straight to storage, never through the API." (`OA:2854-2856`)
   - The storage host's response on success, signature failure or expiry is **not specified** (UNKNOWN).
   - The `x-amz-*` headers imply an S3-compatible store (INFERRED).
3. **Complete:** `completeSupportAttachment`, POST `/support/attachments/{attachmentId}/complete`, no body (`OA:2896-2941`, stability line `OA:2899`).
   - **Server checks:** size, SHA-256, magic bytes ("the declared `contentType` must be true"), at most 50 megapixels, not animated, then Google SafeSearch.
   - **`200`** returns `SupportAttachment` with status `ready`. The call is idempotent once `ready`.
   - **"A refused photo is gone."** (the contract marks this with a red-circle warning glyph). After `413` or either `422`, the photo is deleted and the id is dead; start a fresh upload.
   - **"A `503` keeps the upload: retry this call later."**
4. **Attach:** the optional `attachmentIds` field on the stable `createSupportTicket` / `postMySupportTicketMessage` (`OA:2667-2672`, `OA:2809-2813`, `OA:3988-3993`, `OA:4004-4009`).
5. **Read:** `getMySupportAttachmentContent` (`OA:2942-2982`, stability line `OA:2945`).
   - Streams `image/jpeg|png|webp` with `X-Content-Type-Options: nosniff` and `Cache-Control: private, max-age=3600`.
   - "There is no URL for a photo anywhere."
   - The server re-hashes before sending and answers `410` on mismatch.
   - "Send `Accept: image/*, application/problem+json` so an error body keeps its `code`" (`OA:2953-2954`).

**Limits (CONTRACT):**

| Limit | Value | When exceeded | Cite |
|---|---|---|---|
| Types | JPEG, PNG, WebP. **No PDF** | 400 `validation_failed` (declared type) / 422 `image_content_invalid` (bytes) | `OA:4032`, `OA:2876`, `OA:2934` |
| Size per photo | 1 – **7,000,000 bytes** (decimal; not 7 MiB) | 413 `image_too_large` | `OA:4033`, `OA:2888`, `OA:2931`, `EC:61` |
| Pixels | ≤50 megapixels, not animated | 422 `image_content_invalid` | `OA:2904-2905` |
| Photos per message (ticket opening or reply) | ≤3, no repeats | 400 `validation_failed` | `OA:3990-3991`, `OA:4006-4007`, `OA:2685`, `OA:2828` |
| Photos per ticket | ≤10 | 409 `attachment_limit_reached`; nothing written | `OA:2697`, `OA:2811`, `OA:2840` |
| Unattached photos per student | ≤10 | 409 `attachment_limit_reached` at presign | `OA:2862`, `OA:2885` |
| Unattached lifetime | deleted 24 h after presign; must be attached within 24 h | 404 `attachment_not_found` | `OA:2863`, `OA:2670`, `OA:2906-2907` |
| Upload URL lifetime | ≤15 min | storage refuses (shape unknown) | `OA:2856`, `OA:4052` |
| Presign rate | 30 / student / hour | 429 | `OA:2891` |
| Complete rate | 30 / hour; after 5 refused (422) in an hour, all refused | 429 | `OA:2937` |
| Photo reads | 300 / hour | 429 | `OA:2978` |
| Ticket creates / replies | 5 / day; 60 / hour (separate budgets) | 429 | `OA:2700`, `OA:2843` |
| Retention | `expired` 90 days after the ticket closed | 410 `attachment_gone` | `OA:4023`, `OA:2975` |
| Student deletes a photo | not possible; "they ask Customer Service in a reply" | — | `OA:4015` |
| Staff replies | `attachments` "always empty on a staff reply" | — | `OA:3980` |
| Photo-only reply | `body` may be `""` with ≥1 attachment | 400 if empty without attachments | `OA:2809-2810`, `OA:4001-4003`, `OA:2828` |

**Support schemas (CONTRACT):**

| Schema | Fields (all `required` unless noted) | Cite |
|---|---|---|
| `SupportTicketStatus` | string: `open`, `in_progress`, `pending`, `closed` "today". "Clients MUST tolerate an unknown `status`": treat it as "in progress — not closed". Only `closed` refuses replies; there is no reopen | `OA:3911-3923` |
| `SupportTicketReference` | `TK-{n}`, no padding; "A display label, never an id" | `OA:3924-3930` |
| `SupportTicketSummary` | `ticketId, reference, subject, status, createdAt, lastActivityAt` | `OA:3931-3944` |
| `SupportTicket` | `ticketId, reference, subject, details, status, createdAt, lastActivityAt, closedAt` (nullable), `attachments[]` (the ticket's OPENING photos) | `OA:3945-3967` |
| `SupportTicketMessage` | `messageId, authorKind` enum `[student, staff]`, `body` (may be `""`), `createdAt, attachments[]` | `OA:3968-3982` |
| `SupportAttachment` | `attachmentId, contentType, sizeBytes` (int64 ≥1), `status` (`ready`, `expired`, `removed` today; unknown → "not available"), `createdAt`. No digest, storage key or URL | `OA:4011-4028` |

Other ticket rules (CONTRACT):

- **Ticket fields:** `subject` is 1–120 and `details` 1–4000 characters, after trimming. No category or priority (`OA:2661-2664`).
- **Ticket list:** `lastActivityAt` descending, pages of 20, no `limit` parameter (`OA:2707-2711`).
- **Thread:** oldest first, pages of 20. A staff reply is shown as "Customer support" (`OA:2765-2769`).
- **Closed tickets:** `409 ticket_closed`, with no reopen (`OA:2839-2840`, `EC:35`).

The required `attachments` arrays on the stable `SupportTicket` / `SupportTicketMessage` arrived in **3.42** (`OA:3963-3967`, `OA:3978-3982`, `CL:76` "stable responses gain a required `attachments` array (additive, empty when none)"). At 65245be the spec says "No attachment field exists and none is reserved" (`OA65:2487`). A support model generated from the 3.38 re-vendor would silently drop the student's own photos.

**Terms gate (CONTRACT):**

- **Where it applies:** `403 terms_acceptance_required` is returned by:
  - `createSupportAttachmentUpload` (`OA:2882`);
  - `createSupportTicket` / `postMySupportTicketMessage`, **only when `attachmentIds` is sent** (`OA:2672`, `OA:2691`, `OA:2834`);
  - `uploadCustomAvatar` (`OA:1025`).
- **Never for text**, and "Inert while no current Terms version is published" (`EC:67`).
- **Client rule:** "offer the Terms screen, or send without photos" (`EC:67`).
- **`getTermsAcceptance`** returns `{currentVersion: string|null, acceptedVersion: string|null, acceptedAtUtc: date-time|null, isCurrent: boolean}`, all required. `isCurrent` is true only when `currentVersion` is non-null and equals `acceptedVersion` (`OA:1089-1109`).
- **`acceptTerms`** takes `{termsVersion}`, which must equal `currentVersion`. It answers `204` (idempotent), otherwise 400 `validation_failed` (`OA:1113-1140`).
- **`getLegalDocument`** is public. Its parameters are `document ∈ {terms, privacy}` and `language ∈ {ar, en}`, both required, and it returns `version == currentVersion`. It supports `ETag`/`If-None-Match` → `304`, and answers `404 legal_document_unavailable` when no version is configured (`OA:811-860`, `EC:22`).
- **Staging (corrected in verification):** the changelog says `getLegalDocument` "answers `200`" on staging (`CL:38`; restated at `CL46:16` as "staging serves these operations"). Observed directly: unauthenticated `GET /api/v1/reference/legal-documents/terms?language=en` → **HTTP 200** (LIVE-PROBE 2026-10-08, verifier and corrector). Because the contract answers `404 legal_document_unavailable` when no version is configured, a Terms version **is** configured on staging (observed, no longer inferred). Whether the `403 terms_acceptance_required` gate actually fires for a student who has not accepted remains unobserved.
- **Internal contradiction:** the stable `acceptTerms` still says "Acceptance is recorded, not enforced: no other operation refuses a student who has not accepted." (`OA:1122-1123`). Four operations now refuse on exactly that ground (`OA:1025`, `OA:2672`/`OA:2691`, `OA:2834`, `OA:2882`; `EC:67`). Unchanged at 3.46.

**Image / attachment error codes (CONTRACT, `EC:16`, `EC:61-67`):**

| Code | HTTP | Meaning | Client instruction in contract |
|---|---|---|---|
| `image_rejected_by_moderation` | 422 | SafeSearch rejected (support: adult, racy or violence at LIKELY or above) | avatar: "this photo can't be used"; support: "this photo can't be sent"; ticket/reply text unaffected |
| `image_too_large` | 413 | above cap (support 7,000,000; avatar 2 MiB) | downscale (~2048 px, JPEG) and start again |
| `image_content_invalid` | 422 | bytes not an acceptable photo (one answer for all causes) | fresh upload of a real JPEG/PNG/WebP |
| `image_upload_unavailable` | 503 | storage/SafeSearch down; fail closed | retry later; on complete the upload is KEPT; text support works |
| `attachment_not_found` | 404 | unknown, foreign, not `ready`, already attached, >24 h, or not on that ticket (BOLA one-answer) | nothing was written |
| `attachment_gone` | 410 | expired / removed / failed integrity re-check | show "attachment expired" / "removed" |
| `attachment_limit_reached` | 409 | 10 unattached, or ticket would exceed 10 | nothing was written |
| `terms_acceptance_required` | 403 | current Terms not accepted; photos only | offer Terms screen or send without photos |

Stale labelling at 3.46 (added in verification): `error-codes.md` rows 16 and 61-67 still label the spec-067 / spec-070 uses "(draft)" (`EC:16`, `EC:61-67`) although the operations are now `stable`; the file was not touched by 3.46 (CONTRACT).

**App state (SOURCE):**

- **No calls:** no code in `lib/` calls `/me/avatar`, `/support/…` or `/support/attachments`. A grep of `lib/` for `me/notifications|unread-count|/support/|/conversations|friend-requests|/me/avatar|me/invite|fcm-token|terms-acceptance|legal-documents|hubs/chat` finds only comments and ARB text: `profile_update.dart:44`, `edit_profile_screen.dart:46`, `avatar_sheets.dart:196`, `settings_screen.dart:344`, `app_en.arb:598`, `app_localizations.dart:1445`.
- **Avatar sheet:** "Upload photo" renders disabled (`lib/features/profile/widgets/avatar_sheets.dart:196-221`). Its TODO reasons that an upload "is not even synchronously 'set'" and that there is "no defined UX for a rejected image". **Both premises are stale at 3.42+:** the `200` means "Accepted, published and set" (`OA:1010`), and `422 image_rejected_by_moderation` defines the outcome (`OA:1031`). The operation is now `stable` (3.46). The S29 ask "what does the client show between upload and approval — old avatar, new one optimistically, or a status field?" (`docs/seif_fight.md:1241-1244`) is therefore answered by the contract (200 = set, with `avatarUrl`; 422 = nothing stored, avatar unchanged); S29 can be closed, not just the code TODO marked stale (DOC + CONTRACT, added in verification).
- **Support screen:** it is a shell whose TODO says support has "**no endpoint of any kind**" (`lib/features/account_shells/screens/customer_support_screen.dart:9-11`, S33). That is stale: text support has been stable since 3.39.
- **Dependencies:** `pubspec.yaml:30-65` has no image-picker, image-compression, SHA-256 (`crypto`), SignalR or Firebase package. The presign step needs a hex SHA-256 of the exact bytes (`OA:4034`). **(added in verification)** `package:crypto` 3.0.7, `package:http` 1.6.0 and `package:web_socket_channel` 3.0.3 are already in the graph as **transitive** dependencies (`pubspec.lock:252-256`, `:536-540`, `:1357-1361`), so the presign hash and the un-intercepted storage PUT need no new third-party package, only promoting an existing one to a direct dependency. The picker and image-compression packages are still missing.
- **Main Dio client (corrected in verification):**
  - It sends only `Content-Type: application/json` as a default header (`lib/core/network/dio_client.dart:19`).
  - `AuthInterceptor.onRequest` (`lib/core/network/interceptors/auth_interceptor.dart:52-61`) reads the access token and sets `options.headers['Authorization'] = 'Bearer …'` (`:58`) on **every** request, with no host check (SOURCE). So any request sent through `DioClient.create` would send the student's access token to whatever host the URL names. The presigned storage PUT must therefore not go through that client. This is SOURCE-provable (the first pass labelled it INFERRED); only the storage host's reaction to an extra or unsigned header is INFERRED (`OA:2855` "a missing or changed header fails").
  - `DioClient.createBare` (`dio_client.dart:45-49`) drops `AuthInterceptor`, but it keeps `ErrorInterceptor` and the API `baseUrl`, so a third, plain client is still needed for the storage PUT.
- **Platform prerequisites for photo picking (added in verification, SOURCE):**
  - `ios/Runner/Info.plist` contains no `NSPhotoLibraryUsageDescription` and no `NSCameraUsageDescription` (grep → 0). Which of these the app needs depends on the picker route chosen (library vs camera capture); none exists today.
  - The source Android manifest declares only `INTERNET` (`android/app/src/main/AndroidManifest.xml:19`) and no media permission; `minSdk = 24` (`android/app/build.gradle.kts:56`), so pre-Android-13 devices are in scope and the picker route (system Photo Picker vs a storage permission) is a dependency decision.
  - `.ai/audits/current/store_readiness_audit.md:232` already lists "`POST_NOTIFICATIONS`/APNs (push), Photo Picker (avatar upload), camera (blocked by domain rule 9)" as future items that "must arrive with declarations in the same change" (DOC).


> **3.46 update:** all five photo operations are `stable` at `eddb6ac`; read "draft" above as "draft at 3.45". See 3.0.
### Owner decisions and unknowns carried forward (updated in verification)

**Decisions that belong to the owner, not to Claude** (changes marked):

- Which contract pin to commit and build against: the proposed uncommitted 65245be (3.38) or upstream `eddb6ac` (3.46.0-m1). **`2e5bb69` is no longer a candidate** (upstream moved to `eddb6ac`, which differs from it only by the five photo-op `stable` flips and the version line); whether to re-vendor again before execution.
- ~~Whether to build any draft photo operation early~~ **No longer applies:** all five photo operations are `stable` at `eddb6ac`. The decision is now only the pin decision above.
- Whether push ships in v1 or is deferred (`docs/STORE_READINESS_RUBRIC.md:69`, item 8a is not recorded).
- Firebase project ownership and per-environment setup, the APNs key, and adding Firebase/FCM dependencies.
- The choice of Dart SignalR client package (it must support WebSockets and `skipNegotiation`; none evaluated).
- Choice of image-picker and image-compression dependencies for photo flows. **Narrowed:** SHA-256 and a plain HTTP client need no new third-party package (`crypto` 3.0.7 and `http` 1.6.0 are already transitive; promoting one to a direct dependency is a `pubspec.yaml` change).
- All English and Arabic copy not supplied by the contract: photo refusals, attachment expired/removed, inbox kind strings, Terms-gate prompt, banned screen (the contract copy is only "suggested; the client owns the strings").
- Replacing the Figma support-photo hint "PNG/JPG/PDF up to 10MB" with contract limits (designer), and logging it in DESIGN_ISSUES.
- The notification-permission prompt timing (repo guidance: in context, not at launch) and the foreground-notification behaviour.
- Whether logout deletes the local FCM token (a privacy trade-off for minors).
- Whether notification-tap routing is allowed under "no deep links in release 1" (reading above: probably yes; owner to confirm).
- Where Terms acceptance happens: a registration step vs on demand at the first photo (design missing per the handoff).
- The referral points contradiction (Figma 500 to both vs contract +10 to inviter only): kept tracked, not chosen.
- Accepting that push text follows the phone language, not the in-app language switch (contract-imposed product consequence).
- **(added in verification)** Photo-picker route (system Photo Picker vs a storage permission on Android; library vs camera on iOS), given `minSdk` 24 and the store audit's note that camera is "blocked by domain rule 9" (`.ai/audits/current/store_readiness_audit.md:232`).

**Unknowns carried forward:**

- What PATCH `/me` returns for an unknown `avatarId` (already filed as S45, `docs/seif_fight.md:647`).
- The storage host's response, errors and retry semantics for the presigned PUT, and the storage hostname (needed for network policy).
- The inbox kind `enrolment_opened`'s `data` keys.
- The numeric per-kind hourly push limit (`RT:107` says "limited per student per hour" with no number).
- ~~Whether the five draft photo operations are deployed on staging today~~ **Resolved:** routed on staging (LIVE-PROBE above). Still unknown: whether storage and SafeSearch are configured end to end for a real student upload (a `503 image_upload_unavailable` is still possible).
- When push delivery will be switched on, and whether staging or production Firebase projects exist yet.
- Server behaviour for the stored FCM token on logout or on account switch on the same device.
- Whether an absent `Accept` header (as the app sends today) can ever produce a body-less ProblemDetails (recorded as `[UNVERIFIED]` in `contract/SOURCE.md:52-55`).
- Whether Dio's global `Content-Type: application/json` header is correctly overridden for a multipart avatar upload (not run; BUILD-level check needed).
- The exact Figma support-photo wording "PNG/JPG/PDF up to 10MB": not recorded in the repo, so the handoff claim is DOC-unverified.
- Whether the `403 terms_acceptance_required` gate fires on staging for a student who has not accepted (a Terms version is configured there; the gate itself is unobserved).


## 10. CI / hooks / validation state
_Verification (Fable): 20 claims - 18 confirmed, 1 partial (corrected), 1 refuted (corrected), 0 unverifiable._ Corrector re-checked the primary sources behind the refuted and partial verdicts (GitHub Actions API via the installed `gh`, APK and commit timestamps, `ci.yml` and validator line numbers) and agrees with the verifier. Items marked "(added in verification)" were missed by the investigator.

### CI, hooks and validation gates, with BUILD-level evidence (3.38 working tree and 3.45 dry run)

Investigator: CI / hooks / validation gates. Date: 2026-10-08. Baseline: branch `merged` @ `8e641e9`. Levels: SOURCE = read in code; BUILD = run now; ARTEFACT = inspected a built file; DOC = a project document says so; CI = a GitHub Actions run result read through the API (reached in this dimension only after verification); DEVICE = not reached in this dimension.

#### 0. Headline

1. **The working tree with the proposed 3.38 contract is green.** Format exit 0, `flutter analyze` 0 issues, full suite **2067 passed / 0 failed / 0 skipped** (BUILD). This equals the handoff figure and is 1218 above the CLAUDE.md "849" floor. The repo fingerprint was identical before and after (section 1).
2. **The 3.45 dry run (isolated clone) is also green:** guards 122/122 (contract guard 14/14) and the full suite 2067/0/0 (BUILD, section 2). The guard was not tested against anything the 3.39 to 3.45 surfaces added: **the contract guard binds only 7 of the 32 response schemas that carry a `required` list** (BUILD mutation probe plus script count). Passing against 3.45 is therefore weak evidence about the new chat, support, invite and streak models. The clone overlaid only the four upstream contract files that tests can see; `contract/SOURCE.md` was left at the committed 3.28 text, so it was not a full re-vendor rehearsal (added in verification; no test reads `SOURCE.md`, so the result stands).
3. **`sh tool/validate.sh` cannot pass on this Windows machine** (BUILD repro, exit 123, "The command line is too long"). Since `.githooks/pre-push` calls it (`pre-push:93`), the pre-push hook would also fail on every Dart-touching push if it were enabled. `validate.ps1` is unaffected (it chunks 60 files per call, `validate.ps1:146-148`).
4. **Hooks are inactive** (`core.hooksPath` unset, `.git/hooks` has only `*.sample`). Even if enabled they are stored as mode `100644`, so macOS and Linux git would ignore them (git's documented executable-bit requirement; not tested here).
5. **CI HAS run, 15 times, and the earlier "never observed" statement was wrong** (CI level; corrected in verification). `gh` 2.102.0 is installed at `/c/Program Files/GitHub CLI/gh` and authenticated as the user's own account. The unauthenticated WebFetch 404 is simply what a private repo returns. `gh api repos/zlatanibrahimovichsweden-61/level-up-app/actions/runs` gives `total_count` 15 (first 2026-08-15, last 2026-10-06T02:22Z at `c87b90a` = `HEAD~1`, success); Actions is enabled (`allowed_actions` all); **no branch is protected** (`dev`, `main`, `merged` all `protected=false`), so **no required status check exists**. Full history in section 2.1. `docs/RISKS.md:55` (R-3, "CI has never been observed running") and `.ai/audits/current/fable-wave3-verdict.md:414` ("still zero executions") are stale DOC. **Scope limit:** CI has only ever seen the committed tree with the 3.28 contract (the last run was at `c87b90a`; `HEAD` differs from it only in `docs/ENVIRONMENTS.md` and `.ai/audits/current/env_chapter_state.md`, and `ENVIRONMENTS.md` is read by `android_identity_test`, covered by the local BUILD run above, not by a CI run). CI has never seen the uncommitted 3.38 files, so "CI green" says nothing about them.
6. **A local `OVERALL: PASS` can precede a CI red, and it already did** (added in verification, CI + SOURCE). The local format gate is fed by `git ls-files`, so a brand-new untracked `.dart` file is not format-checked until it is `git add`ed (`tool/validate.ps1:136`, `tool/validate.sh:129`). CI run #14 (`f10b112`, run id 37398238597) failed its `analyze + test` job at the step "Format check (hand-written Dart only)": "Changed test/features/account_shells/disabled_action_button_test.dart ... Formatted 324 files (1 changed)" (log read by `gh run view --log-failed`, confirmed by the corrector). Commit `56f74e7`'s body says the validate run that recorded 2059 / 0 / 0 "never saw it either, because the file was untracked then and the format step is fed by `git ls-files`".

#### 1. Part 2: what was run (all output under SCRATCH)

| Step | Command | Result | Level |
|---|---|---|---|
| Fingerprint BEFORE | `git status --porcelain=v1 \| sha1sum`; `git diff \| sha1sum` | status `21cbcead8f53055f7ceecfc65cd582a3743461b2`, diff `9dd3cd0d34e0f6a63616cd18c19a4e5e2cc97d3f`; HEAD `8e641e9`; `pubspec.lock` sha1 `723bd1ca3bfc...` | BUILD |
| (b) format | `git ls-files -z "*.dart" \| xargs -0 -r -s 7000 dart format --output=none --set-exit-if-changed` | **exit 0**, 369 files in 3 batches (145+143+81), **0 changed**. CI-equivalent set (generated files excluded, 324 files, 148+142+34): exit 0, 0 changed | BUILD |
| (c) analyze | `flutter analyze --no-pub` | **exit 0, "No issues found! (ran in 78.4s)"**. No `pub get` was needed, and `pubspec.lock` is unchanged | BUILD |
| (d) full suite, working tree (3.38 contract files present) | `flutter test --no-pub` (no tag filter, so goldens run) | **exit 0, final line `02:14 +2067: All tests passed!`**. No `~` skip counter and no `-N` failure counter anywhere in the log, 0 `[E]` lines. Wall time about 2m33s. Goldens (7 files) ran and passed on Windows. Log: `SCRATCH/test_full.log` (log-verified by the verifier; suite not re-run) | BUILD |
| (d') guard dir alone, working tree | `flutter test --no-pub --reporter expanded test/guards` | **122 passed**: android_identity 9, **contract_models 14**, project_rules 11, rules 61, validate_reporting 12, workflow 15. All 14 contract tests appear by name, including the canary and 13 bindings. So the **3.38 re-vendor passes the contract guard 14/14** | BUILD |
| (e) 3.45 dry run | clone of HEAD `8e641e9` to `SCRATCH/clone345`; the four `2e5bb69` contract files (`openapi.yaml`, `error-codes.md`, `realtime.md`, `contract-changelog.md`) laid over `contract/` as LF blobs (`git hash-object` equals the upstream blob for all four, e.g. openapi `d570a42549`; CR count 0); `info.version: 3.45.0-m1`; `flutter pub get --offline` exit 0, lock unchanged. **`contract/SOURCE.md` was not updated in the clone** (still the committed 0df5cf4 / 3.28.0-m1 text, blob `86f420de15`; added in verification) | **Guards 122/122 (contract_models 14/14). Full suite exit 0, 2067 passed / 0 failed** (`02:05 +2067: All tests passed!`). No guard fails against 3.45 | BUILD |
| (e') codegen and l10n drift (the CI `codegen-drift` and gen-l10n steps, run in the clone) | `dart run build_runner build --delete-conflicting-outputs` (69s, 62 outputs); `flutter gen-l10n` | **0 drifted `*.freezed.dart` / `*.g.dart`; 0 drifted `lib/l10n`.** Committed generated code is in sync at HEAD. CI corroboration: the "Localizations are up to date" step passed in run #15 (`c87b90a`); `codegen-drift` last passed on `main` at `e71e9a1` (older code) | BUILD, CI |
| (f) Fingerprint AFTER | same two commands | status `21cbcead...` and diff `9dd3cd0d...` are **identical to BEFORE**, the porcelain text is identical (5 modified `contract/*`, 2 untracked roadmap files), `pubspec.lock` unchanged, no `.git/index.lock`, `test-results.md` untouched. The corrector re-read the same two hashes at the end of verification: still `21cbcead...` / `9dd3cd0d...`, HEAD `8e641e9` | BUILD |

Counts versus references: 2067 now = 2067 (handoff) = the figure recorded in the tracked `.ai/audits/current/test-results.md` (run of 2026-10-06T02:18Z, DOC). CLAUDE.md's "at or above 849" (`CLAUDE.md:114`, and "849 passing tests" at `:20`) is stale by 1218 tests. **Caveat on that tracked record (added in verification):** `test-results.md:1-16` names commit `f10b112` and says "tree clean : NO - uncommitted changes present" with OVERALL PASS 2067/0/0. That dirty tree already carried the `56f74e7` format fix, while CI on the clean `f10b112` failed the format step (run #14). Anyone reading "f10b112 PASS" is misled; the record should carry the dirty-file list or the diff fingerprint beside the sha.

**The failed first 3.45 attempt (a setup artefact, not a contract incompatibility).** The first overlay copied files from `SCRATCH/upstream-contract`, whose `core.autocrlf=true` checkout holds CRLF (4935 CR in `openapi.yaml`; error-codes 72, realtime 108, changelog 636). The guard then failed **13 of 14** tests with `ContractShapeException: no 'required:' at indent 6 for StudentProfile` (final counter `+109 -13`). Cause: `contractRequiredFields` does `yaml.split('\n')` (`test/guards/rules.dart:368`), leaves a trailing `\r`, and the `required:\s*(.*)$` match (`rules.dart:403-406`) cannot match across it (Dart `.` does not match `\r`); navigation via `child()` (`:375-388`) trims, which is why the error names the right schema. The repo itself is safe because `.gitattributes` has `* text=auto eol=lf` and all five `contract/*` files have 0 CR. The hazard is a re-vendor done by copying from a Windows CRLF clone: the guard fails loudly but with a misleading message. Re-done with LF blobs, 14/14 pass.

Extra BUILD probes, run in the clone only (verified from the logs; mutations not re-run):
- **Guard can fail:** adding `inviteCode` to `StudentProfile.required` fails the guard with "contract/openapi.yaml marks inviteCode as REQUIRED on StudentProfile, but ...student_profile.dart does not take it".
- **Guard is blind outside its bindings:** adding a required field to the unbound `Quiz` response schema leaves `contract_models_test` at 14/14 green.
- **Linux case-portability scan:** 1875 first-party imports, 3 pubspec asset entries and 26 asset-path literals all resolve with exact case against `git ls-files`; 0 case-colliding tracked paths. This was the proxy used before the CI history was known; it is now superseded in strength by the CI history (analyze + test passed on the ubuntu runner in 14 of the 15 runs, the one failure being the format step, not the platform).

#### 2. Part 1: inventory

##### 2.1 `.github/workflows/ci.yml` (1 file; 4 jobs; the only workflow)

| Job | Trigger | Gates | Required or advisory | Evidence |
|---|---|---|---|---|
| `analyze-and-test` ("analyze + test") | PR to or push on `dev`, `main`, `merged`; manual dispatch (`ci.yml:25-30`); ubuntu, 20 min (`:72-73`) | Release manifest declares INTERNET (grep, `:133-141`); `pub get`; lockfile did not drift (`:146-153`, a hard `exit 1`); gen-l10n drift (`:158-166`); format of hand-written Dart (`:171-178`); `flutter analyze --no-pub` (`:181`); `flutter test --no-pub --reporter expanded --exclude-tags golden` with no path argument (`:195-196`) | **Not a required status check:** no branch protection on `dev`, `main` or `merged` (`protected=false` on all three, CI level via the GitHub API). A red run is visible but blocks nothing. Run results: success in 14 of 15 runs; failure in run #14 (format step, section 0 item 6) | SOURCE, CI |
| `goldens` ("windows, advisory") | same triggers; windows-latest (`:212`) | `flutter test --tags golden` (`:241`), uploads failure PNGs | **Advisory**: `continue-on-error: true` (`:214`). **Green in all 15 runs** (CI level). The comment at `:200-201` says to flip it to blocking after one green run and add it to branch protection; that condition has been met for weeks (the flip is an owner decision). The RISKS.md R-3 expectation that it would be red is stale | SOURCE, CI, DOC |
| `codegen-drift` | `workflow_dispatch` or **push to `main` only** (`:262`) | build_runner then diff of `*.freezed.dart` / `*.g.dart` (`:295-304`) | Not on PRs, not on `merged`, not on `dev`. Ran on `main` twice and **passed both times** (run #5 `f987f20` 2026-09-19, run #9 `e71e9a1` 2026-09-20; skipped in every `merged` run) | SOURCE, CI |
| `build-release-apk` ("release compile gate") | **push to `main` only** (`:320`); `needs: analyze-and-test` (`:321`); 30 min | `flutter build apk --release --no-pub --flavor prod -t lib/main_prod.dart` (`:380`); then `aapt2 dump badging` must give `com.levelupworld.app` and `aapt2 dump permissions` must list INTERNET (`:390-426`); falls back to the merged-manifest grep | This **is** a release-compile gate, but unsigned, APK only, prod flavor only, main only. It ran and **passed on `main` twice (runs #5 and #9), but only in its pre-flavor form** (`origin/main:ci.yml:377` is `flutter build apk --release --no-pub -t lib/main_prod.dart`). **The flavor-aware form (`:380` on `merged`, commit `2dfd969`, 2026-10-06) has never executed in CI**: no run on `main` exists after 2026-09-20 | SOURCE, CI |

**CI run history (added in verification; CI level, `gh api .../actions/runs`, all `push` events; corrector re-read the list and the four key runs' job conclusions):**

| Run | Date (UTC) | Branch | Commit | `ci.yml` blob | Result |
|---|---|---|---|---|---|
| 1 | 2026-08-15 | dev | a5b8228 | 0f6b193d | success |
| 2 | 2026-08-22 | merged | 0451284 | 1f1d7406 | success |
| 3 | 2026-09-07 | merged | 7e7129c | 1f1d7406 | success |
| 4 | 2026-09-19 | merged | f987f20 | 1f1d7406 | success |
| 5 | 2026-09-19 | **main** | f987f20 | 1f1d7406 | success; all 4 jobs success, including codegen drift and release compile gate |
| 6 | 2026-09-19 | merged | 7876242 | 1f1d7406 | success |
| 7 | 2026-09-19 | merged | 4215e1c | 1f1d7406 | success |
| 8 | 2026-09-20 | merged | e71e9a1 | 1f1d7406 | success |
| 9 | 2026-09-20 | **main** | e71e9a1 | 1f1d7406 | success; all 4 jobs success |
| 10 | 2026-09-28 | merged | cccd2f1 | 1f1d7406 | success |
| 11 | 2026-09-30 | merged | a988a1f | 1f1d7406 | success |
| 12 | 2026-09-30 | merged | e6e6567 | 1f1d7406 | success |
| 13 | 2026-10-05 | merged | 3913f86 | c359cd1b | success |
| 14 | 2026-10-06T01:15Z | merged | f10b112 | c359cd1b | **FAILURE**: `analyze + test`, step "Format check (hand-written Drepresent only)" |
| 15 | 2026-10-06T02:22Z | merged | c87b90a | c359cd1b | success: analyze + test success (~7 min), goldens success, main-only jobs skipped |

(Run 14's step name is "Format check (hand-written Dart only)".) Only runs 13 to 15 used the current `ci.yml` blob `c359cd1b` (the blob-per-commit column was added by the corrector with `git rev-parse <sha>:.github/workflows/ci.yml`); runs 2 to 12 used `origin/main`'s older blob `1f1d7406`, run 1 used `origin/dev`'s `0f6b193d`. The goldens job was green in all 15 runs. `subosito/flutter-action` accepts 3.44.7 (the pin in `.flutter-version`, unchanged for all later runs) and the suite behaves on ubuntu: two former "unknowns" are now known.

Other facts:
- `permissions: contents: read` (`:38`); `concurrency` cancels superseded runs (`:34-36`). Actions are tagged by version (`@v4`, `@v2`), not pinned by SHA.
- The SDK pin lives in `.flutter-version` (3.44.7) and CI reads it (`:83-92`). `workflow_test.dart` forbids a hard-coded version.
- **Nothing runs on iOS or macOS.** There is no `macos` runner, `xcodebuild` or `flutter build ios` anywhere in `ci.yml` (grep, no match).
- **No AAB is built** in CI or any script. `flutter build appbundle` appears only as documentation (`docs/ENVIRONMENTS.md:267`, `docs/STORE_READINESS.md:58,265`, `docs/STORE_READINESS_AUDIT_2026-09-05.md:123`).
- **No secret scanning:** no gitleaks, trufflehog or detect-secrets in any tracked non-doc file (grep). **No dependency automation:** no `.github/dependabot.yml`, `renovate.json` or `CODEOWNERS`. The only tracked file under `.github/` is `ci.yml`. Whether GitHub-side secret scanning or push protection is on is UNKNOWN (the corrector's `gh api repos/... --jq .security_and_analysis` returned nothing, so the setting is not visible through this token).
- `ci.yml` still says the golden suite is "5 cases, 2 test files" (`:13`, `:204`; corrected from `:207`, which is the `--exclude-tags` suggestion). There are now 7 `@Tags(['golden'])` files with 19 `test(`/`testWidgets(` calls, so the cost note is stale (cosmetic).
- Three different `ci.yml` blobs exist on the three remotes: `origin/main` `1f1d7406`, `origin/dev` `0f6b193d` (older still), and `origin/merged` / HEAD `c359cd1b` (corrected in verification; `dev` was last pushed at run 1). The flavor-aware workflow (commit `2dfd969`, 2026-10-06) exists only on `merged`. `git log -- .github/workflows/ci.yml`: `2dfd969` 2026-10-06, `20cb836` 2026-08-22, `94e9c9a` 2026-08-15, `36d543b` 2026-08-14. The **flavor-aware** `build-release-apk` step will run for the first time when `main` is promoted (the pre-flavor form already ran twice, see the table).

##### 2.2 Hooks

| File | What it does | State |
|---|---|---|
| `.githooks/pre-commit` | Staged `*.dart` only (generated files excluded, NUL-safe): `dart format --output=none --set-exit-if-changed` (`:69`) then `flutter analyze --no-pub` on those files (`:80`). Skippable with `--no-verify` or `LEVELUP_SKIP_HOOKS=1`. Because it checks staged files it would have caught the untracked-file hole in section 0 item 6 | **INACTIVE** |
| `.githooks/pre-push` | If the push touches `lib/ test/ android/ ios/ tool/ .github/ .githooks/`, `pubspec.*`, `l10n.yaml`, `analysis_options.yaml`, `dart_test.yaml` or `.flutter-version`, it runs `LEVELUP_VALIDATE_OUT=<tmp> sh tool/validate.sh` (`:81`, `:93`). The output goes to a temp file so the tracked evidence is not dirtied | **INACTIVE** |

Evidence of inactivity (BUILD): `git config --show-origin --get-all core.hooksPath` printed nothing and exited 1. `git config --get-regexp hook` was empty. `.git/hooks/` holds only 14 `*.sample` files. Both hook files are mode **100644** in the index (`git ls-files -s .githooks`: pre-commit `fd4411c3`, pre-push `76e5cc67`).

Defects found in the hooks, none of them active now:
- **Contract and docs pushes skip validation.** The pre-push regex (`pre-push:81`) has no `contract/` or `docs/`, and the header says "docs-only and contract-only pushes cost nothing" (`:20-22`; `:25-29` explains why other trees were added: guards read them). But `contract_models_test.dart:61` reads `contract/openapi.yaml`, `android_identity_test.dart:21,43,188-199` reads `docs/ENVIRONMENTS.md`, and `workflow_test.dart:168` lists `docs` among its operational trees. A pure re-vendor push (the 3.38 case) would skip the very guard written for it. CI has no path filter, so CI would still run.
- **Non-executable mode.** On macOS and Linux (the planned Mac session for iOS) git silently ignores a non-executable hook even with `core.hooksPath` set.
- **The `validate.sh` format step breaks on Windows** (see 2.3).

##### 2.3 `tool/` scripts

| Script | Steps | Notes |
|---|---|---|
| `tool/validate.ps1` | env, toolchain, `pub get`, format of hand-written Dart (chunks of 60, `:146-150`), analyze, `flutter test --no-pub --reporter=expanded` (**goldens included**), writes `.ai/audits/current/test-results.md` (**tracked**) unless `LEVELUP_VALIDATE_OUT` is set (`:37`). Never stops at the first failure; exit 0 only if all pass; the tally parser is itself guarded by `validate_reporting_test.dart` | Windows path. NOT run (forbidden); its three steps were replayed directly and passed. **Two gaps (added in verification):** the format step enumerates `git ls-files '*.dart'` (`:136`), so untracked new `.dart` files are not checked; and `pubspec.lock` drift only prints a note (`:122-127`) without setting `$overall = 1`, while CI hard-fails on it (`ci.yml:146-153`) |
| `tool/validate.sh` | same, POSIX | **Broken on Windows Git Bash**: `xargs -0 -r dart format ...` (`:139-140`) passes 324 paths (15,366 characters) in one call. Replayed lines 129-141 verbatim: **exit 123, "The command line is too long."** (BUILD; `xargs --show-limits` allows 17,372 so one call is issued, and `/c/flutter/bin/dart` is a bash launcher script). The `-s 7000` batching known to the project was never applied. `workflow_test.dart` checks that `xargs` carries `-0`, not that the line is short enough. Same two gaps as above (`:129-132` untracked files; `:111-114` lockfile warn-only) |
| `tool/verify_guards.ps1` | Proves guards can fail: **11 probes**, each running one test by `--plain-name`, with SHA-256 restore. Six scratch-file probes (Bloc containment `:155`, initState mutation `:159`, hard-coded `Text` `:163`, fontSize `:167`, raw elevation `:176`, mirror glyph `:182`) and five edit probes (CI path argument `:201`, INTERNET `:210`, flavor missing `:224`, flavor/entrypoint mismatch `:235`, applicationId `:245`) | Mutates tracked files (restored in `finally`). NOT run |
| `tool/verify_release_manifest.ps1` | Builds `--release --flavor prod -t lib/main_prod.dart`, then aapt2 checks INTERNET and package `com.levelupworld.app` | NOT run (it builds) |
| `tool/verify_session_regression.ps1` | Swaps `auth_controller.dart` for the **old HEAD `e3651e6`** version, expects `test/core/session/` to fail, restores, expects a pass | Its baseline is a pre-Tier-0 commit; NOT run |
| `tool/smoke/real_api_smoke_test.dart` | Manual live-staging harness, deliberately outside `test/`, run as `flutter test tool/smoke/...`. Authenticated part needs `--dart-define=SMOKE_PHONE=<whitelisted number>` (`:284`) | See 2.5 |

`flutter analyze` does compile `tool/smoke/` (it is in the package), so the harness cannot rot at compile level, but it is never executed by any gate.

##### 2.4 `test/guards/*` and the other mechanised rules

| File (tests) | Rule enforced | Notes |
|---|---|---|
| `rules.dart` | Pure detector functions (source text in, violations out); `libSources()` | Not a test file |
| `rules_test.dart` (61) | Fixture-proves each detector: catches a violation, ignores a comment with the same text | `stripComments`, bloc, initState, async-retry, raw Text, fontSize, elevation, ARB drift, contract-required extraction, field and class scoping, mirror glyph |
| `project_rules_test.dart` (11) | Bloc only in `lib/features/quiz/`; no provider write in `initState` (BUG-001); autoDispose notifiers that await have a disposal flag; every `FutureProvider` / `AsyncNotifierProvider` has `retry:`; no new file with a hard-coded `Text('...')` and total at most 4 (`:139`); `fontSize` at most 0 (`:193`); raw elevation effects must be empty (`:281-284`); `app_en.arb` and `app_ar.arb` same keys; no mirror-glyph swap; `lib/` scan canary (more than 100 files) | Ratchets are at 4, 0 and 0 |
| `workflow_test.dart` (15) | CI never passes a test path; the golden tag is used on both sides; every golden file in `test/goldens/` is tagged (`:58-76`); `.flutter-version` is a plain x.y.z and CI reads it; `src/main` declares INTERNET; CI still has the aapt2 check; every runnable `flutter build apk|appbundle|ipa|ios` in `docs/ tool/ .github/ .githooks/` pairs `--flavor` with a matching `-t` (with at least 3 found, so the scan is not vacuous); validate scripts exist; pre-push delegates to `validate.sh`; `.ps1` files are ASCII; `xargs` carries `-0` | Dated-record docs are excluded by filename. **Latent gap (added in verification):** the golden-tag guard lists only `test/goldens/` (`:61`), so a `matchesGoldenFile` test placed elsewhere would be untagged, run on ubuntu and fail for platform reasons; none exists today (`grep -rl matchesGoldenFile test` outside `test/goldens` is empty) |
| `android_identity_test.dart` (9) | applicationId is `com.levelupworld.app`; flavors are exactly prod and staging in `env`; staging suffix `.stg`; `app_name` strings; manifest label is `@string/app_name`; Gradle flavor/entrypoint check present; minSdk 24 / targetSdk 36 / compileSdk 36 are literals and match `docs/ENVIRONMENTS.md`; no `google-services.json` in `src/main`; per-flavor Firebase file names its own package | Firebase tests pass **vacuously** until a file exists (by design). **There is no iOS equivalent** (no test mentions `pbxproj`, `Info.plist`, `IPHONEOS_DEPLOYMENT_TARGET`, `PRODUCT_BUNDLE_IDENTIFIER` or `GoogleService-Info`; `ios/Runner.xcodeproj/project.pbxproj:349,475,526` still `IPHONEOS_DEPLOYMENT_TARGET = 13.0`, `:371,550,572` `com.levelup.levelUpApp`) |
| `contract_models_test.dart` (14) | The `required: [...]` list is read from `contract/openapi.yaml` at run time and each name must be a constructor parameter of the bound Dart class | 1 canary plus 13 bindings (`:73-156`) over 7 top-level schemas; see section 3 |
| `validate_reporting_test.dart` (12) | The validator's pass/skip/fail tally regex extracted from `validate.ps1` | Mechanises the 2026-09-12 "923 passed / 0 failed" lie |
| `test/core/theme/palette_discipline_test.dart` | No `0xFF` / `Color(0x` / `Colors.black|white` outside `lib/core/theme/`; `SystemChrome` only in `lib/app.dart` | |
| `test/core/theme/typography_discipline_test.dart` | No `fontSize` / `fontWeight` at call sites; scale matches designer sizes; no family or colour in styles | |
| `test/core/session/session_scope_discipline_test.dart` | Every session-scoped provider is invalidated on sign-out; both sign-out paths call it; `forceLogout` keeps its re-entry guard | |

Other facts: **124 tracked `*_test.dart` files under `test/`** (125 repo-wide: `tool/smoke/real_api_smoke_test.dart` is also tracked); **no `integration_test/` directory and no `integration_test` dependency** (so there is no scripted device or end-to-end automation); `dart_test.yaml` declares only the `golden` tag; `analysis_options.yaml` is the stock `flutter_lints` include with no custom rules or strict modes (`analysis_options.yaml:10`); `lib/` contains **zero** `print` / `debugPrint` / `dart:developer` / `Logger` / `LogInterceptor` uses (grep), so "no personal data in logs" is currently true but unmechanised beyond the `avoid_print` lint. The purchase-wording tests (7 files) are not all screen tests (`account_pending_deletion_test.dart:178` is an interceptor test, `flashcards_error_copy_test.dart:45-53` a copy test, `me_notifier_test.dart` a notifier test); the conclusion that no tree-wide guard exists holds.

`docs/ENFORCEMENT.md` is stale in three places: its ratchet table lists fontSize 153, `Text` 7 and elevation 11 (`ENFORCEMENT.md:117-119`, table `:115-119`; corrected from `:116-120`) while the code enforces 0, 4 and 0; it says "This is what CI runs" (`:36`) although CI also does lock, gen-l10n, INTERNET and release steps that validate does not, and validate runs goldens that CI excludes; and it says `verify_guards.ps1` "breaks each rule" (`:74`) when it probes 11 (the contract, async-retry, autoDispose, ARB-parity, palette, typography, session-scope, SDK-pin, Firebase, NUL-safety, SDK-literal and flavor-name rules are covered only by fixture tests or not at all).

##### 2.5 Smoke harness versus the pin

`tool/smoke/real_api_smoke_test.dart` last changed in `f685804` (2026-09-22). It drives the real seam (`AppConfig` to `DioClient` to repositories to freezed models) against staging. It covers about **22 operations** (approximate, counted from test headings at `:196` health/version, `:207-278` seven reference endpoints, `:283` OTP + verify + registration, `:471` authenticated surface): `GET /health/version` plus 7 `/reference/*`, requestOtp, verifyOtp, completeRegistration (opt-in `SMOKE_REGISTER`, `:432`), refreshTokens, logout, getMyProfile, updateMyProfile, getMyEntitlements, getLeaderboard (2 pages), listSubjects, getSubjectTree, createQuiz, submitAnswer, getExplanation, finishQuiz (SOURCE). It covers none of mistakes, flashcards, favourites, quiz summary or history, notifications, FCM token, friends, blocks, chat, support, legal documents, invite, recovery, modules or rank (grep: the only hit is the word "contract-legal"). Of the 77 stable app-buildable operations at 3.45 it exercises roughly 29%, and none of the 3.29 to 3.45 surfaces. Whether it still passes against today's staging is UNKNOWN (not run: it needs the network and a whitelisted number). **Staging numbers (added in verification, CONTRACT):** the contract itself defines the whitelist: `openapi.yaml:96` (identical at 3.28 committed, 3.38 working tree and 3.45 upstream) says reserved fake numbers `+20100000000xx` are whitelisted in staging only, fixed OTP `000000`, no SMS, rate limits identical to prod. So up to 100 reserved numbers exist by contract; the 11-digits-after-`+20` format matters (`release_readiness_reconciliation_2026-10-06.md:391` records a 10-digit attempt that was not whitelisted). Only the seeding of friendship / conversation / ticket states is documented nowhere.

##### 2.6 Fable and audit automation

`docs/AUDIT_PROTOCOL.md` defines a 10-agent audit layout under `.ai/audits/current/`, a ten-item "Fable handoff" (wave scope, files changed, commits, verbatim `validate.ps1`, guard-proof N/N, runtime evidence with level, limitations, deferred, rejected, open decisions), and verdicts APPROVED / APPROVED WITH WARNINGS / REJECTED. It is a **document-driven manual process**: no script, workflow or hook enforces any of it (grep over `tool/`, `.github/`, `.githooks/`). `.claude/settings.local.json` is gitignored and contains no hooks (grep).

##### 2.7 Existing release artefacts (ARTEFACT, stale relative to HEAD)

`aapt2` 36.1.0 `dump badging/permissions` on the local APKs: `build/app/outputs/flutter-apk/app-prod-release.apk` (built 2026-10-06 00:32 local, +0300) has package `com.levelupworld.app`, label "Level Up", INTERNET present, targetSdk 36. `app-staging-release.apk` (2026-10-06 04:37 local) has `com.levelupworld.app.stg`, label "Level Up STG", INTERNET present. **Only the prod APK predates commit `2dfd969` (2026-10-06 00:44:07 +0300); the staging APK was built after it, from `f10b112` (committed 04:15:22 +0300), as `docs/RISKS.md:77` records** (corrected in verification; the machine clock is +0300 like the commit stamps). **Both APKs predate HEAD's code and the 3.38 contract:** `git diff --stat f10b112..HEAD -- lib` touches six files (`features/auth/notifier/login_notifier.dart`, `features/auth/notifier/otp_notifier.dart`, `features/auth/repository/device_info_provider.dart`, `features/profile/notifier/edit_profile_notifier.dart`, `features/quiz/notifier/quiz_setup_notifier.dart`, `features/registration/notifier/registration_submit_notifier.dart`, via `5c0a27d` and `e3364ab`), and the 3.38 contract files carry mtime 2026-10-07 09:35 (`SOURCE.md` 09:39). The only AAB on disk is `build/app/outputs/bundle/release/app-release.aab` (2026-10-04 22:29, the pre-flavor path; no `prodRelease/` directory exists), so **no flavor-era AAB has ever been produced here**. Nothing was rebuilt in this audit.

#### 3. The contract guard in detail (the gate most relevant to the re-vendor)

- **What it protects:** the `required` list of 13 bound schema paths: `StudentProfile` (plus its school, geography, points, privacy and pendingDeletion sub-objects), `EntitlementState`, `UniversitySubjectTree` (plus `lectures[]`), `SchoolSubjectTree`, `AnswerResult`, `NamedRef`, `FlashcardCard`. Its own header lists what it cannot see: unbound schemas, optional fields, types and nullability, the response-to-schema link.
- **Coverage, computed by script over the pinned YAML** (`SCRATCH/ci_guard_coverage.py`, 2xx response `$ref`s of stable operations whose consumers include mobile; re-run by the verifier with identical counts):

| Pin | Stable and app-buildable ops | Directly returned 2xx schemas | With a `required` list | Unbound |
|---|---|---|---|---|
| 3.28 (`0df5cf4`) | 35 | 21 | 17 | 10 |
| 3.38 (`65245be`) | 49 | 26 | 22 | 15 |
| 3.45 (`2e5bb69`) | 77 | 36 | 32 | **25** |

The 25 unbound at 3.45 include `AuthenticatedResult`, `TokenPair`, `Quiz`, `QuizSummary`, `LeaderboardEntry`, `CursorPage`, the mistakes trees, and every post-3.28 shape: `Friend`, `FriendRequest`, `StudentCard`, `PhoneLookupResult`, `SendFriendRequestResult`, `ConversationSummary`, `ChatMessage`, `AnswerForwardedQuestionResult`, `FriendStreak`, `MyInvite`, `QuizHistoryItem`, `QuizReview`, `SupportTicket`, `SupportTicketSummary`, `SupportTicketMessage`. The method (top-level `$ref` of 2xx responses, no `allOf` flattening) is approximate, so read the counts as indicative.
- **It only reads `contract/openapi.yaml`.** No test reads `error-codes.md`, `realtime.md`, `SOURCE.md`, operation stability (`x-stability`), the operation set, enums, or the `Accept: application/json` requirement (grep of `test/` for `SOURCE.md|x-stability|realtime.md` is empty). Nothing verifies that the vendored files equal the pinned upstream blobs (the "hashes matched" claim in the handoff is a manual check). The working-tree files equal upstream `65245be` (openapi `c26b51dd1f`, error-codes `67eb0610f3`, realtime `4ab6f0faa6`, changelog `f0a99fc0df`; `info.version` 3.38.0-m1; verifier-checked).
- **It is fail-safe in one direction:** an unreadable schema raises rather than passing, which is why the CRLF case failed loudly.

#### 4. Part 3: gate classification

Legend: Exists = present in the repo; Reliable = demonstrated able to fail (and by what); Mandatory = where it is enforced.

| Gate | Exists | Reliable (can fail?) | Mandatory where | Completion-workflow gate? |
|---|---|---|---|---|
| Format (hand-written Dart) | yes | Standard `dart format` exit code. Ran green now. **Proven to catch what local validate missed:** CI run #14 failed on an untracked-at-validate-time file | CI step; `validate.ps1`; pre-commit (inactive). `validate.sh` is broken on Windows. **Local validate skips untracked new `.dart` files** (`git ls-files`) | **YES** (every wave), via `validate.ps1` or the `-s 7000` form, **plus** a format check of untracked files (`git ls-files -o --exclude-standard '*.dart'`) or `dart format --output=none --set-exit-if-changed lib test tool` by directory |
| Analyze | yes (stock `flutter_lints`) | 0 issues now. Weak lint set; `debugPrint` / `developer.log` are not flagged | CI; validate; pre-commit (staged only; inactive) | **YES** (zero issues) |
| Full test suite | yes (2067) | Exit code plus a validator that rejects an unparsable tally. CI green at `c87b90a` (HEAD's code, 3.28 pin) | CI (minus goldens); validate | **YES**, with a floor of 2067 passed / 0 failed / 0 skipped (the 849 floor is stale and no mechanised count floor exists) |
| Golden tests (19 tests, 7 files) | yes | Pixel diff; pass on Windows now; **green in all 15 CI runs on windows-latest** | Local validate; CI: advisory, `continue-on-error`, flip condition (`ci.yml:200-201`) already met | YES locally on Windows when UI changes; owner decides whether CI goldens become blocking |
| Guard suite (122) | yes | Detectors fixture-proven (61 tests); 11 end-to-end probes in `verify_guards.ps1` (manual) | CI and validate (part of the suite) | **YES**; run it alone and quote the file-level counts |
| Contract guard | yes, narrow | Proven to fail on a contract-side change and to be blind to unbound schemas (BUILD probes); CRLF-fragile | Part of the suite | **YES but insufficient**: needs bindings for each new response schema before any new model is accepted |
| Contract pin integrity (files equal upstream blobs, `SOURCE.md` matches) | **no** | n/a | Manual only (and the 3.45 dry run left `SOURCE.md` at 3.28) | **ADD**: `git hash-object` against the upstream blob plus a CR count of 0, and a `SOURCE.md` consistency check |
| Stable-only, operation coverage, error-code coverage | **no** | n/a | none | ADD or keep as a reviewed checklist |
| gen-l10n drift | yes (CI) | BUILD: 0 drift; CI "Localizations are up to date" passed in run #15 | CI each PR/push; not in validate | YES per wave touching ARB |
| ARB en/ar parity | yes | fixture-proven | suite | YES (in suite) |
| build_runner drift | yes (CI) | BUILD in clone: 0 drift; CI passed on `main` twice (last at `e71e9a1`, older code) | **main push only**; never local or on `merged` | YES per wave touching models (run in a worktree) |
| Lockfile drift | yes (CI) | `git diff --quiet`; hard failure in CI (`ci.yml:146-153`) | CI each PR; **validate only warns** (`validate.ps1:122-127`, `validate.sh:111-114`), so a local PASS can precede a CI red | YES (check the `pubspec.lock` hash explicitly) |
| Release compile (APK, prod) | yes (CI) | aapt2 package and INTERNET check; passed on `main` twice in its pre-flavor form; **flavor form never run in CI** | **main push only**; locally `verify_release_manifest.ps1` | YES at release-candidate waves; do not wait for `main` |
| AAB build | **no** (doc only) | n/a | none | ADD at release-candidate waves |
| Release signing | n/a | Unsigned by design (`key.properties` absent) | n/a | owner action |
| Android identity (Gradle plus tests) | yes | Gradle throws on a flavor/entrypoint mismatch; guard fails on an edit; aapt2 on local APKs matched | suite, Gradle | YES |
| **iOS identity and deployment target** | **no** | n/a | none (pbxproj still `com.levelup.levelUpApp`, 13.0) | **ADD** (a text guard on `project.pbxproj`; BUILD itself needs a Mac) |
| iOS build and signing | **no** | n/a | none | needs a Mac (see Q2) |
| Firebase and FCM file slot | guard exists, vacuous | Fires only once a file exists | suite | YES, and extend to iOS `GoogleService-Info.plist` |
| Purchase-silent (adr-049 §3) | per-screen / per-layer tests only (7 files; flashcards study, quiz, pending-deletion and others) | Word-list assertions on those screens | suite | **ADD** a tree-wide scan; it must allow-list contract-verbatim copy (see decisions) |
| No personal data in logs | none beyond `avoid_print` | currently 0 logging calls in `lib/` | analyze | ADD (ban `debugPrint`, `dart:developer`, `LogInterceptor`) |
| Staging smoke harness | yes, manual | decodes through the real seam | none | **ADD to release-candidate waves**, after extending it to the new stable ops |
| Secret scanning | **no** | n/a | none | ADD (repo setting plus a pre-release scan) |
| Dependency updates / audit | **no** | n/a | none | decision |
| Branch protection and required checks | **none configured** (`protected=false` on `dev`, `main`, `merged`; CI level) | n/a | n/a | owner decision whether to enable (see decisions) |
| CI run on the pushed commit (added in verification) | yes, 15 runs | Caught a defect that local PASS missed (run #14) | Runs on push/PR; blocks nothing (no protection) | **YES after every push**: read the run result with `gh run list` / `gh run view` and quote it at CI level; it covers only pushed commits, so the uncommitted 3.38 contract is invisible to it until committed and pushed |
| Pre-commit and pre-push hooks | yes, inactive, with the defects in 2.2 | `dart format` and `validate.sh` | **none today** | fix first, then decide (decisions list) |
| Device verification | manual (adb on the Pixel 8) | n/a | none | YES per UI wave, labelled DEVICE |
| Fable audit | document process | n/a | none | YES for the close-out, per `AUDIT_PROTOCOL.md` |

#### 5. Recommended completion-workflow gates (proposals only; nothing was modified)

**Every wave, before the commit**
1. Record the `git status --porcelain=v1` and `git diff` fingerprints and the intended file list (other sessions edit this repo concurrently). Record the dirty-file list or diff fingerprint beside any commit sha quoted in a validation record (the tracked `test-results.md` currently names `f10b112` for a dirty tree).
2. Format check using the chunked or `-s 7000` form, or `validate.ps1` with `LEVELUP_VALIDATE_OUT` pointing outside the repo so the tracked `test-results.md` is not dirtied; **also format-check untracked new `.dart` files** (`git ls-files -o --exclude-standard '*.dart'`, or `dart format --output=none --set-exit-if-changed lib test tool` by directory), because the `git ls-files` feed misses them (CI run #14).
3. `flutter analyze --no-pub` equals 0 issues.
4. `flutter test --no-pub` with the final reporter line quoted (`+N: All tests passed!`), **N at least 2067**, 0 skipped; add the new tests to the floor each wave. Run any single claimed test file on its own, because the expanded reporter prints in-flight names only.
5. `flutter test test/guards` alone, with the per-file counts (122 now).
6. `git diff --quiet -- pubspec.lock` explicitly (validate only warns; CI fails).
7. After the push, read the Actions run for that commit (`gh run list`, `gh run view`) and quote its conclusion as CI level (added in verification).

**Wave-type gates**
- Contract re-vendor: first dry-run in a clone with LF blobs (`git show <sha>:<file>`; CR count 0; `git hash-object` equals the upstream blob), updating `SOURCE.md` too; then the guard; then add the missing bindings.
- New model or endpoint: add a `contract_models_test` binding for each new response schema, and show a mutation probe (add a required field upstream-side, expect red).
- Model, freezed or json edits: build_runner in a worktree plus `git diff` on generated files (CI only checks this on `main`).
- ARB edits: gen-l10n diff, ARB parity, and grep for duplicate keys (the Wave 13 hazard).
- Identity, Firebase or push waves: aapt2 on a fresh flavor APK and AAB, plus the new iOS guard.

**Release candidate**
- Prod and staging flavor APKs, plus the first flavor AAB, inspected with aapt2 (ARTEFACT).
- `verify_guards.ps1` N/N, an extended smoke run, a device walk (DEVICE), the iOS build on a Mac, and the Fable pass.

**Fixes the workflow should schedule first (small, mechanical, outside this audit's remit)**
- Batch the `validate.sh` format step; make both validators format-check untracked `.dart` files and treat `pubspec.lock` drift as a failure; mark the hooks executable and add `contract/` and `docs/` to the pre-push trigger list; make `contractRequiredFields` tolerate CRLF; refresh the stale `ENFORCEMENT.md` ratchet table, the `ci.yml` golden counts, `RISKS.md` R-3, and the CLAUDE.md "849" floor; extend the golden-tag guard beyond `test/goldens/`.

#### 6. Unknowns

Resolved by verification (no longer unknown): Actions run history and results (15 runs, section 2.1); whether Actions is enabled (yes); branch protection and required checks (none configured); whether `subosito/flutter-action` accepts 3.44.7 (yes, all runs set up the SDK); ubuntu-latest behaviour of the suite (analyze + test passed in 14 of 15 runs, the one failure was the format step).

Still unknown: whether `validate.ps1` itself passes right now (not run; its three steps were replayed directly); `verify_guards.ps1` N/N at this commit (not run, it edits tracked files); the staging smoke result against today's staging; whether HEAD builds a flavor release APK or AAB (the local APKs predate HEAD's lib changes and no flavor AAB exists); how CI behaves on the 3.38 or 3.45 contract files (never committed or pushed, so CI has not seen them); whether the flavor-aware `build-release-apk` step passes on `main` (it has never executed); everything iOS; GitHub-side secret scanning and push protection (not visible through the API token used); whether the 25 unbound 3.45 response schemas are all genuinely app-consumed (the count is by top-level `$ref` of 2xx responses without `allOf` flattening, so it is indicative).

#### 7. Decisions reserved for the owner (carried from the investigator's structured output, updated after verification)

- Whether to enable `core.hooksPath` on this clone and make the hooks mandatory, only after the `validate.sh` Windows format defect, the `100644` mode and the missing `contract/` and `docs/` triggers are fixed.
- Whether to change GitHub repo settings: enable branch protection and required status checks (none exist today), flip the `goldens` job from advisory to blocking (its own flip condition, one green run, has been met: green in all 15 runs), enable secret scanning and push protection, enable Dependabot. These need the owner's explicit permission.
- Whether to adopt the proposed 3.38 re-vendor (uncommitted) or jump to 3.45 and which pin the completion workflow is built on; also whether the draft transferToUniversity-style "can be built now" notes override the stable-only rule.
- Whether the release compile gate (and the codegen drift check) should also run on `merged` or on PRs, accepting 6 to 10 minutes per run (run #9 timings: codegen ~2 min, release gate ~6 min), rather than only on `main`; the flavor-aware form is otherwise first exercised at promotion.
- Whether to pay for a macOS CI runner or use a local Mac for iOS verification, and whether iOS build verification is a hard gate.
- What a tree-wide purchase-silent guard may allow: `app_en.arb:516` `explanationSubscriptionRequired` contains "Subscribe to get step-by-step explanations", copied verbatim from the contract's approved 403 copy and ratified by an owner ruling on 2026-09-26, so a naive word ban would fail on contract-mandated text.
- Whether to raise the stale "849" floor in CLAUDE.md to the measured 2067 and whether to mechanise a test-count ratchet (CI removed frozen counts on purpose in `20cb836`).
- Scope of extending the contract guard: all stable app-buildable response schemas, or only those the app consumes (a wider guard will flag models deliberately not modelled and needs an owner ruling on each exception).
- Whether Fable-style audits become a required step of each wave close-out, or only of release candidates.
> **Correction:** `gh` 2.102.0 is installed and authenticated; CI is observable (15 runs, latest push green). Section 2.10 is right; any "CI never observed" text here is superseded.


## 11. Device state

Observed 2026-10-08 with read-only commands only (`flutter devices`, `adb devices -l`, `adb shell getprop`,
`adb shell pm list packages`, `adb shell dumpsys package|battery`, `adb shell wm size|density`). Nothing was
installed, launched, cleared or changed on the device. Level: **DEVICE** (observed now).

| Field | Value |
| --- | --- |
| Model | Google Pixel 8 (`product:shiba`, `model:Pixel_8`) |
| Platform / OS | Android **17**, API **37**, security patch 2026-09-05, ABI `arm64-v8a` |
| Screen | 1080 × 2400 px, density 420 |
| Connection | USB; `adb devices -l` state `device` (authorised); battery 30 %, USB-powered; developer settings on |
| Seen by Flutter | Yes: `flutter devices` lists `Pixel 8 (mobile) … android-arm64 … Android 17 (API 37)` (plus Windows, Chrome, Edge desktop/web targets, irrelevant here) |
| adb location | `C:\Users\musta\AppData\Local\Android\Sdk\platform-tools\adb.exe`; **not on PATH** (`adb` fails in Git Bash; call it by full path) |
| Level Up packages installed | `com.levelup.level_up_app` (the old template id; first install 2026-08-04, last update 2026-10-04, 1.0.0 / 1, min 24 / target 36) and `com.levelupworld.app.stg` (staging identity; first install 2026-10-06 02:15, updated 04:37, 1.0.0 / 1). **`com.levelupworld.app` (prod) is not installed.** |
| iOS device | None seen. No Mac or Xcode is known to be available (UNKNOWN; see questions) |

**What it can be used for later.** Android DEVICE-level verification: device walks (EN/AR × light/dark),
uiautomator-driven checks, screen recordings, pixel measurements from screencaps. Known limits from the project
records: `FLAG_SECURE` blacks out screencaps on the quiz and review screens; the BACK key at the root closes the
app; the owner's font scale is not changed by sessions (the 1.3× text-scale checks run on the `Pixel_8` AVD).

**Two facts the final workflow must carry.**

1. The 2026-10-06 **release-build** run against staging was on the **`Pixel_8` AVD (emulator)**, not on this
   phone (`release_readiness_reconciliation_2026-10-06.md` §15.2; `docs/RISKS.md:77`). The physical Pixel 8 got a
   **debug** staging re-walk (§15.1). A release build has therefore never been DEVICE-verified on physical
   hardware.
2. The mock build and the staging build share the id `com.levelupworld.app.stg` and replace each other on
   install (`cor_roadmap_registers`, KC-12). The prod-identity side-by-side check (prod + staging installed together)
   has not happened, because the prod flavour has never been installed on the phone.


## 12. Store / production readiness
_Verification (Fable): 18 claims - 17 confirmed, 1 partial (corrected), 0 refuted (corrected), 0 unverifiable._

#### Store / production readiness — current state re-verified (2026-10-08)

**Scope and method.** Re-verified against the tree at HEAD `8e641e9` (branch `merged`), the committed pin `0df5cf4` (3.28), the uncommitted re-vendor in the working tree `65245be` (3.38), and upstream HEAD `2e5bb69` (3.45, scratch clone). I also ran read-only checks on the existing artefact `build/app/outputs/flutter-apk/app-prod-release.apk` (mtime 2026-10-06 00:32:40 +0300) with `aapt2`, `apksigner` and a `libapp.so` string scan. I made 5 public, unauthenticated GETs against staging: the four `/reference/legal-documents/*` documents and `/health/version`. Result of the `/health/version` probe (added in verification): the host-root path `https://level-up-backend-staging.up.railway.app/health/version` returns HTTP 200 `{commit a158daa…, environment Staging, builtAtUtc 2026-10-08T15:16:14Z}`; the `/api/v1/health/version` path is 404 `not_found` (API; re-probed by the verifier and by the corrector with the same result). The 3.45 contract mirror `2e5bb69` (committed 12:29 UTC) cites `level-up-backend@f5e5424` (upstream clone `git log -1`), so staging was built after the mirror was cut; use that when dating further staging probes. Nothing was built, formatted, validated or written in the repo. Levels: CONTRACT / SOURCE / DOC / BUILD / ARTEFACT / DEVICE / CI as defined; **API** = a live staging response (my own probe; not a tier in the brief; it proves existence, not production parity). No DEVICE or CI evidence was gathered by me.

**ARTEFACT scope caveat (corrected in verification).** The prod APK was built at 00:32:40 +0300 on 2026-10-06. By commit date it predates **seven** `lib/` commits (`af0eadb` Settings checkpoint 02:04; `a0585eb`, `423a610`, `1bf749c`, `882c889` a11y/catalog/home fixes 04:13; `e3364ab`, `5c0a27d` OTP and `retry:` work 05:20), of which only the last two come after `f10b112`. It also predates the Wave 1 flavor commit `2dfd969` (00:44:07, the only commit touching `android/` since 2026-10-04 22:00), yet it already carries `com.levelupworld.app`, so it was built from a then-uncommitted tree (INFERENCE from `aapt2` identity plus `git log`). The identity, permission, signing and host-string facts below are what that build shows; none of the seven commits touched `android/`, `ios/` or `pubspec` after the baseline `f10b112` (SOURCE, next paragraph), but the APK is not a build of HEAD.

**Delta since the 2026-10-06 audit records.** The diff baseline `f10b112` is `docs(audit): record the 2026-10-06 Fable-eye full audit` (04:15 +0300); the reconciliation record itself is `c87b90a` (05:20 +0300) (label corrected in verification). SOURCE: `f10b112..HEAD` is **five** commits — `56f74e7` (test formatting), `e3364ab` (OTP verify fix), `5c0a27d` (Riverpod `retry:` opt-out plus guard), `c87b90a` and `8e641e9` (docs); only the last two are docs. `git diff --stat f10b112 HEAD -- lib android ios pubspec.yaml pubspec.lock test` = 11 files: six `lib/` files (login, otp, edit_profile, quiz_setup and registration_submit notifiers, plus `device_info_provider.dart`, which gained only `retry: (_, _) => null` and a doc comment) and five test files; `git diff --name-only f10b112 HEAD` adds only `.ai/audits/` and `docs/` files. **No store-relevant file moved** (no router, legal, settings, manifest, Gradle, iOS or pubspec change). From the reconciliation record `c87b90a` to HEAD only `8e641e9` remains (`docs/ENVIRONMENTS.md`, `.ai/audits/current/env_chapter_state.md`). What changed is outside the repo: upstream contract 3.38 → 3.45 and staging now serving the legal texts (below). The 02:59 roadmap was built against pin `0df5cf4`, so it cannot see any of it.

---

##### 1. The question the brief singled out: does `getLegalDocument` change blocker E-2?

**Yes, materially, but it only removes one of E-2's four parts.**

| Fact | Evidence |
|---|---|
| `getLegalDocument` (`GET /reference/legal-documents/{document}?language=ar\|en`, `document` in `terms\|privacy`) is `x-stability: stable`, `x-consumers: [mobile, web]`, public (`security: []`), returns `{document, version, language, title, contentMarkdown}`, ETag + `Cache-Control: public, max-age=3600`, `404 legal_document_unavailable` when no Terms version is configured. The contract says the text is rendered **in the app, not in a browser** (Seif 2026-10-07). | CONTRACT `openapi.yaml@2e5bb69:811-860` (operationId `:816`, "rendered IN the app" `:819-820`, never-an-empty-200 `:826`, 404 description `:856`); changelog `@2e5bb69:36,95-100`; `error-codes.md@2e5bb69:22` |
| Staging serves it: HTTP 200 for terms and privacy in both ar and en, `version: r4-2026-10-07` on all four, with `Cache-Control: public, max-age=3600` and an `etag` header. Response sizes: privacy en 7,675 / privacy ar 11,329 / terms en 6,002 / terms ar 8,793 bytes. Titles "Level Up — Privacy Policy", "Level Up — Terms of Use" and the Arabic equivalents. | API (curl 2026-10-08; saved as `scratchpad/sr_legal_*.json`, re-probed by the verifier as `ver_store_legal_*.json/.hdr`, identical sizes and version) |
| The app does **not** call it. `/legal/privacy` and `/legal/terms` render "This document hasn't been published yet." (`legalNotPublished`); the file's own comment says "nobody has supplied any [text]" (S30) and forbids the implementer writing legal copy. | SOURCE `legal_document_screen.dart:13-23,50`; `app_en.arb:644` |
| Signed-out students can reach **no** legal text in-app: `/legal/*` are not in `_authRoutes = {'/', '/login', '/login/otp'}`, so `authRedirect` sends signed-out users to `/login`. | SOURCE `app_router.dart:52,73-76,427-434` |
| Login's three legal links (User Agreement, Privacy Policy, Cookie Policy) open `https://levelup.example/legal/...` in the external browser (`.example` never resolves). Each of the three `libapp.so` in the prod APK of 2026-10-06 carries `levelup.example` ×3 and `TBD.example` ×1. | SOURCE `login_screen.dart:45-48,123,410-417`; ARTEFACT `libapp.so` scan (arm64-v8a, armeabi-v7a, x86_64 each: 3 and 1; re-run by verifier and corrector) |
| There is **no** cookie-policy source: the `document` enum is `terms\|privacy` only. | CONTRACT `openapi.yaml@2e5bb69:830` |

**What E-2 still needs after this change**

1. **App work (now unblocked by contract, not started):** repository + provider for `getLegalDocument` (ETag/304, 404 → "unavailable" state, offline/error/loading, AR+EN), a Markdown renderer (the text uses tables, headings, rules; `pubspec.yaml` has no markdown package — a dependency decision), un-gate `/legal/*` for signed-out use and registration, replace the three Login URLs, drop or re-source the Cookie link. Owner: Flutter.
2. **Approval and production parity (UNKNOWN):** the contract calls it "approved text" (changelog `@2e5bb69:96`), but nothing in the repo or contract says who approved r4, or that production will serve the same version. Both documents name the controller only as `Level Up ("we", "us")` (privacy §1, terms §1) — no legal entity, which `docs/STORE_READINESS.md:213` says the store privacy policy must name. The entity itself is undecided in the project record: D-021 Q1 calls it "the still-unknown legal company name" and `docs/STORE_READINESS.md:245-252` §14 item 3 lists "entity name must match privacy policy" as an open owner decision (added in verification). Owner: Mostafa/legal + Seif.
3. **Public web URL for the consoles (still MISSING):** Play requires an active public non-PDF URL and Apple needs a Privacy Policy URL (`docs/STORE_READINESS.md:61,213`; DOC). The endpoint is JSON on the API host, not a policy page. The website host `level-upworld.com` is an owned domain (D-021 Q1; `docs/ENVIRONMENTS.md:80`) and is "decided, not live" (`docs/ENVIRONMENTS.md:407`; the host appears in `DECISIONS.md` D-021 Q7). No page URL, owner or date is recorded anywhere (citation corrected in verification). Owner: Seif/web.
4. **Terms acceptance (MISSING):** `getTermsAcceptance` / `acceptTerms` are stable and never called (grep of `lib/`); Login only shows a passive "By continuing, you agree to our…" line. Terms §2 promises a re-accept prompt on a new version.
   - **(added in verification) The promised gate has no server counterpart.** Served Terms §2 (r4-2026-10-07) says that when the terms change in an important way the app will show the new version and ask the student to accept it before continuing, and that some features may stay unavailable until then (API). The contract, however, says acceptance is "recorded, not enforced: no other operation refuses a student who has not accepted" (`openapi.yaml@2e5bb69:1122-1123`); the only server gate is the photo paths (`403 terms_acceptance_required`; "Text tickets and replies are never gated"; client guidance "offer the Terms screen, or send without photos", `error-codes.md@2e5bb69:67`), and the contract places the display "during registration and from settings" (`openapi.yaml@2e5bb69:819`). Publishing r4 therefore commits the app to a gate that exists nowhere in `lib/` (grep for `acceptTerms|getTermsAcceptance|terms-acceptance` → none). The gate is wholly the app's to build; its shape is an owner decision (remaining Q10).

**Ordering hazard (SOURCE vs API):** the staging policy and terms say "You can ask to delete your account from inside the app" (privacy §7, terms §10) and "contact us through the Support section in the app" (privacy §1/§8, terms §1/§9). The app has no deletion flow and its Support screen is a disabled shell (`customer_support_screen.dart:26-39`). Publishing these texts before E-3 and the Support screen exist would make the policy untrue for the shipped app. (added in verification) Two further consequences of the same texts: (a) the Terms §2 acceptance gate above; (b) **no support URL or support email exists anywhere** (grep of `lib/` and the contract → none) while both texts route every contact and data-rights request to the in-app Support shell; `docs/STORE_READINESS.md:213-216` lists "support URL/email" and an "iOS Support URL" among the required listing assets, and the item table below carries it as MISSING.

**E-7 is narrowed, not closed.** The staging privacy text names the sub-processors (BeOn SMS, DigitalOcean hosting and storage, Sentry, Google Cloud Vision, Google Firebase Cloud Messaging), retention for chat (24 h after read / 30 days), reports, support photos (90 days after closing), profile photo, and the account-deletion scope with what is kept (§5-§7) (API). Still absent: regions ("may store or process data outside Egypt"), log and backup retention periods, `security.md`. `docs/seif_fight.md` still holds no retention/reviewer/production-host entry (last entry S45; grep) — Q-B1..Q-B10 remain unfiled.

---

##### 2. Item table (status: COMPLETE / PARTIAL / MISSING / BLOCKED)

"Changed?" compares with the 2026-10-06 reconciliation and the 02:59 roadmap.

| Item | Status | Evidence | Owner | Changed? |
|---|---|---|---|---|
| Android `applicationId`, flavors, labels | COMPLETE | `build.gradle.kts:55,72,76,77`; ARTEFACT aapt2 on `app-prod-release.apk`: `com.levelupworld.app`, label "Level Up", versionCode 1 / 1.0.0, `targetSdkVersion 36`, `compileSdkVersion 36`, native code arm64-v8a / armeabi-v7a / x86_64; staging flavor is `.stg` / "Level Up STG" (`build.gradle.kts:72-77`). D-021 ratified | — | no |
| Android SDK levels | COMPLETE | literals `compileSdk 36`, `minSdk 24`, `targetSdk 36` (`build.gradle.kts:39,56,57`) | — | no |
| Flavor ⇄ entrypoint coherence (refuses `prod` from other `-t`, mock in release) | COMPLETE (SOURCE; BUILD per DOC) | `build.gradle.kts:119-146` | — | no |
| Android release signing | BLOCKED | `android/key.properties` absent (only `.example`); `apksigner verify` on the prod APK: "DOES NOT VERIFY / Missing META-INF/MANIFEST.MF" (ARTEFACT; APK is not a build of HEAD, see the artefact caveat above); fail-closed by design `build.gradle.kts:81-100`; `.gitignore` covers key.properties, jks, keystore | Owner / release manager | no |
| Play App Signing, flavored AAB, CI AAB job | MISSING | only an unflavored `build/app/outputs/bundle/release/app-release.aab` (2026-10-04 22:29, see the identity hazard in the next row); CI builds an unsigned APK only (`ci.yml:380`) and only on `main` push (`:318-322`); runners are ubuntu/windows only (`ci.yml:72,212,263,322`); `.github/workflows/` holds only `ci.yml` | Release manager | no |
| **Release-artefact identity hazard (added in verification)** | OPEN (MEDIUM) | ARTEFACT: the AAB's `base/manifest/AndroidManifest.xml` contains `com.levelup.level_up_app` (5 occurrences incl. `.MainActivity` and the `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` name) and zero occurrences of `com.levelupworld.app` — the **dropped template identity** (D-021: "The template ids are dropped"). No AAB under `com.levelupworld.app` exists. Uploading this file would register the wrong package name on Play; D-021 says Q1 is not revisitable after the first store upload ("Revisit when: never for Q1 after the first store upload"). Treat it as do-not-upload | Release manager | **yes (new finding)** |
| Production API URL | BLOCKED | `app_config.dart:54` = `https://TBD.example/api/v1`; ARTEFACT prod APK contains `TBD.example` ×1 per ABI; contract `servers:` still staging-only at 3.45 (`openapi.yaml@2e5bb69:107-109`); planned `api.level-upworld.com` "not deployed" (`DECISIONS.md` D-021 Q5; `ENVIRONMENTS.md:54`); no build-time `.example` refusal (`ENVIRONMENTS.md:367` Wave 2 not started; no `.example` guard in `test/guards`) | Seif → app | no (new hint: changelog `@2e5bb69:31-32` says production runs the API behind a load balancer and "Do this before you point a build at production", so production is planned, not announced) |
| Staging config | COMPLETE | `app_config.dart:43-44`; staging answers (API) | — | no |
| Environment indicator | MISSING | `AppConfig.isDev` has no consumer outside `app_config.dart` (grep). In-app, staging and prod are indistinguishable until Wave 2; at install level they already differ since Wave 1 (launcher label "Level Up" vs "Level Up STG", `.stg` applicationId; ARTEFACT label on the prod APK, `build.gradle.kts:72-77`) | Flutter (Wave 2) | no |
| Firebase environments | MISSING | no `google-services.json` / `GoogleService-Info.plist` anywhere under `android/` `ios/` (find); no `firebase_*` in `pubspec.yaml`/`pubspec.lock`; guard slots only (`android_identity_test.dart:203-236`); Seif 2026-10-06: nothing registered (`ENVIRONMENTS.md:340-357`) | Seif (projects, files, APNs key) + Flutter | no (handoff item 6 is new input) |
| iOS bundle ids | MISSING | `project.pbxproj:371,550,572` and RunnerTests `:387,404,419` = `com.levelup.levelUpApp`; ratified `com.levelupworld.app` / `.stg` | Flutter on a Mac | no |
| iOS minimum version | MISSING | `IPHONEOS_DEPLOYMENT_TARGET 13.0` ×3 (`pbxproj:349,475,526`), `AppFrameworkInfo.plist:23-24` `MinimumOSVersion` 13.0; ratified 15.0 (D-021 Q4). Firebase iOS floor is UNKNOWN (not checked) | Flutter on a Mac | no |
| iOS signing, schemes, Podfile | MISSING | no `DEVELOPMENT_TEAM` (grep), one scheme `Runner.xcscheme`, no Podfile/Pods/entitlements/xcconfig per flavor (`find ios` shows only Debug/Release/Generated.xcconfig and Base.lproj), `TARGETED_DEVICE_FAMILY "1,2"` (`pbxproj:353,479,532`) | Owner (team) + Mac | no |
| iOS template residue | MISSING | `Info.plist:7-8,15-16` "Level Up App"/`level_up_app`; no `ITSAppUsesNonExemptEncryption`; `knownRegions en, Base` (`pbxproj:188-191`), no `CFBundleLocalizations`; landscape allowed (`Info.plist` orientations) | Flutter on a Mac | no |
| iOS privacy manifest (E-4) | BLOCKED | no `ios/Runner/PrivacyInfo.xcprivacy`; `device_info_plus` locked 13.2.0 (`pubspec.lock:284-291`) reads `NSFileSystemFreeSize/Size` (`FPPDeviceInfoPlusPlugin.m:42-43`) with an empty `NSPrivacyAccessedAPITypes` in its own manifest; the app only uses `model` (`device_info_provider.dart:27-33`). Sweep of the other iOS plugins (verifier, SOURCE): `shared_preferences_foundation` declares its UserDefaults reason; `sqflite_darwin`, `flutter_secure_storage_darwin`, `connectivity_plus`, `url_launcher_ios` ship manifests with empty accessed-API arrays; `path_provider_foundation` and `screen_protector` ship none and show no required-reason API use — `device_info_plus` is the sole known undeclared user. Apple's actual accept/warn behaviour UNVERIFIED | Flutter + owner (fix shape O-3) | no |
| Legal screens and links | PARTIAL | §1 above | Flutter | **yes (contract/API)** |
| Public privacy / terms web URL for consoles | MISSING | §1 item 3 | Seif/web | no |
| Terms acceptance (and the gate served Terms §2 promises) | MISSING | `acceptTerms`, `getTermsAcceptance` stable, uncalled; server records but does not enforce (`openapi.yaml@2e5bb69:1122-1123`); served Terms §2 promises an in-app accept-before-continue prompt (API); §1 item 4 | Flutter + Seif (shape: owner) | **yes (served text, added in verification)** |
| Retention / sub-processor facts (E-7) | PARTIAL | §1 last paragraph | Seif/legal | **yes (API text)** |
| Data Safety / App Privacy drafts | PARTIAL | drafts exist (`store_readiness_parts/14_declarations_permissions.md`, 2026-09-22) but predate push, chat, photos, invites and the 3.28+ surface; filing now would be false (account deletion, `model`, parent phone answers) | Console owner | no |
| In-app account deletion (E-3) | MISSING | no call to `/me/deletion-request` in `lib/` (grep: only a comment at `exceptions.dart:101`); `exceptions.dart:95-135` maps `account_pending_deletion`; `pendingDeletion` parsed, never rendered; Profile hub has no such row (`profile_screen.dart:229-325`: Settings, Favourite questions, Your progress, Refer a friend, Customer support, Privacy policy, Terms, Go to University, Logout); contract unchanged through 3.45 (`openapi.yaml@2e5bb69:1263-1333`, both operations stable) incl. the mandated confirm copy with "paid" and "refund" (`:1281-1288`); vocabulary rule at `:2449-2450` conflicts; no design | Flutter + designer + Seif (copy ruling Q-B2) | no |
| Web deletion URL (Play) | MISSING | changelog `@2e5bb69:499`: "no web deletion URL … still-unowned decision"; no later entry | Seif/web | no |
| Cancel-deletion screen / global 403 route | MISSING | same as E-3 | Flutter + designer | no |
| Minors: age floor, consent, purpose text | BLOCKED | `dateOfBirth` is `format: date` only, `parentPhone` required on both tracks (`openapi.yaml@2e5bb69:4133,4141,4153,4169,4176,4189`); no age rule anywhere in the contract (grep); policy text now gives a purpose for the guardian phone (recovery) | Legal memo + Seif + Mostafa | partly (policy text) |
| Android manifest permissions | COMPLETE for today's features | ARTEFACT: `INTERNET`, `ACCESS_NETWORK_STATE`, AGP `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` only; source manifest has no `POST_NOTIFICATIONS`, camera, media or `AD_ID` (`AndroidManifest.xml:19`); `allowBackup=false` + extraction rules | — | no |
| **16 KB page-size compliance (added in verification)** | COMPLETE for the prod APK (ARTEFACT); UNVERIFIED for an AAB | `zipalign -c -P 16 -v 4 app-prod-release.apk` (build-tools 36.1.0): all 12 `lib/*/*.so` "(OK)", "Verification successful"; ELF `PT_LOAD` alignment scan (verifier and corrector): `libapp.so`/`libflutter.so` 0x10000 on arm64-v8a and x86_64, `libdartjni.so` and `libdatastore_shared_counter.so` 0x4000 on all ABIs, armeabi-v7a `libapp.so` 0x4000 — every segment at least 16 KB. No AAB exists under the right id to check | Release manager | **yes (was listed unverified)** |
| **Android 15/16 behaviours forced by targetSdk 36 (added in verification)** | UNVERIFIED (DEVICE) | mandatory edge-to-edge: `lib/app.dart:70-85` sets transparent system bars (SOURCE only); predictive back: `enableOnBackInvokedCallback` undeclared, `PopScope` ×3; `android:supportsRtl` and `localeConfig` absent for an Arabic-first app (`AndroidManifest.xml`, grep → none). Recorded as GP-13 / AND-09..11 (grade C/D) in `.ai/audits/current/store_readiness_audit.md:74,124` and `store_readiness_matrix.md:41`. MI-028 (predictive back) is outside this dimension | Flutter + device owner | no |
| **Release hardening and hygiene (added in verification)** | PARTIAL (open decision) | R8 / resource shrinking off (`grep isMinifyEnabled\|isShrinkResources\|proguard android/app/build.gradle.kts` → none; `android/app/proguard*` absent); no `--obfuscate` / `--split-debug-info` path; the prod APK ships `DebugProbesKt.bin` and 266 country-flag assets (2,601,667 bytes) (ARTEFACT zip listing). `docs/STORE_READINESS.md:68` ("Pre-launch report hygiene: PARTIAL — R8 off, no mapping file"), `:195`, `:273` (§15 checklist) still open | Owner (decision) + Flutter | no |
| Push notifications | MISSING | no FCM/Firebase/permission code anywhere (grep `lib/`, `android/app/src`, `ios/Runner`, `pubspec.yaml`, `pubspec.lock`); no `UIBackgroundModes`, no entitlements; `PUT /me/fcm-token` stable and uncalled. Requirements in §4 | Flutter + Seif | handoff new; contract push section `realtime.md@2e5bb69:78-107` |
| Notification preference toggles | PARTIAL (inert) | four `Switch` rendered ON and disabled, incl. "Promotions" (`settings_screen.dart:344-415`); no preference storage in contract (grep "preference" → none); only 4 kinds ever push (`realtime.md@2e5bb69:82`) | Mostafa/designer | no |
| Avatar upload, support photos | BLOCKED (contract draft) | the shapes now exist: avatar `PUT /me/avatar` multipart `image`, ≤ 2,097,152 bytes, 128–4,096 px, not animated, `DELETE /me/avatar`; support `POST /support/attachments` (presigned PUT), `.../complete`, `.../content`, ≤ 7,000,000 bytes, JPEG/PNG/WebP, 3 per message, 10 per ticket; codes `image_too_large`, `image_content_invalid`, `image_rejected_by_moderation`, `image_upload_unavailable`, `attachment_not_found`, `attachment_gone`, `attachment_limit_reached`, `terms_acceptance_required` (CONTRACT `openapi.yaml@2e5bb69:987,1006,2853,4033`; `error-codes.md@2e5bb69:16,61-67`). All 5 photo operations (`uploadCustomAvatar`, `removeCustomAvatar`, `createSupportAttachmentUpload`, `completeSupportAttachment`, `getMySupportAttachmentContent`) still `draft` at 3.45; the app's "Upload photo" row is disabled (`avatar_sheets.dart:196-203`) | Seif (flip) → Flutter | **yes (handoff item 4 says shapes "will come"; they are in the contract since 3.42, draft)** |
| Purchase silence | COMPLETE (one contract-mandated caveat) | greps of `lib/` and both ARB value sets: no price, EGP, paywall, checkout, redeem, Paymob, Fawry, buy, purchase, billing; `lib/features/subscription/{models,notifier,repository,screens}` hold only `.gitkeep`; `app_router.dart:484-487` records `/subscription` and `/subscription/return` as removed, not built; only `launchUrl` call is the Login legal links (`login_screen.dart:123`); the caveat is `explanationSubscriptionRequired` "Subscribe to get step-by-step explanations…" (`app_en.arb:516`), verbatim from the contract (`openapi.yaml@2e5bb69:2069`); soft markers: "Not now", "Promotions" toggle, discarded referral-code field. The served Terms §4 "Subscriptions" names no price, website or where to buy (API), so rendering it in-app stays within adr-049 §3 | Mostafa (D-015 ruling stands) | no |
| Handoff item 1: Subscription screen as status page "with a website link" | BLOCKED (decision) | contract: the app "never carries a purchase link, and never tells the student where to buy" (changelog `@2e5bb69:564`, adr-049 §3), still in force at 3.45 (no reversal found; the later redemption entries are web-side `redeemSubscriptionCode` corrections, changelog `:173-176`); project record R-10 (`RISKS.md:142`, OPEN — DECISION; `ENVIRONMENTS.md:405-409` withdrew the `/redeem` slot). A status/information screen without a link is consistent; the link is not | Mostafa + Seif | no |
| `main_prod.dart` import graph / mock | COMPLETE | import-graph walk (`scratchpad/sr_reach.py`, re-run by verifier as `ver_store_scan2.py`): 225 of 230 files reachable, `lib/dev/*`, `main.dart`, `main_mock.dart`, `main_dev.dart`, `main_staging.dart` unreachable; `lib/dev` imported only by `main_mock.dart`; no `http://`, `localhost`, `10.0.2.2` in `lib/` outside `lib/dev` | — | no |
| Placeholder/mock strings in prod binary | PARTIAL | ARTEFACT: 0 × staging host, 0 × mock host/picsum/`10.0.2.2` in each `libapp.so`; present and expected: `TBD.example` ×1, `levelup.example` ×3 per ABI. `000000` / `localhost` hits are symbol-table noise (context checked). Phone hint "01…999" is a real-looking number in both ARBs (`app_en.arb:32`, `app_ar.arb:15`); mock backend keeps phone-shaped literals (`lib/dev/mock_backend.dart:165,617,2371`; unreachable from prod) | Mostafa (hint) | no |
| Screenshot restrictions | COMPLETE (Android) / UNVERIFIED (iOS) | scope = quiz and review only (`screen_protection.dart:14-37`, used `quiz_screen.dart:68-75`, `quiz_review_screen.dart:56-73`, no other consumer); iOS plugin runs `ScreenProtectorKit.initial(...)` inside `register(with:)` at every launch (pub cache `screen_protector-1.5.3/ios/Classes/SwiftScreenProtectorPlugin.swift:32-37`; registrant `ios/Runner/GeneratedPluginRegistrant.m:57`). iOS 26 crash report (H-7) not reproducible without a Mac | Mac + owner (IOS-D2) | no |
| UGC: report | MISSING in app | no report/block code in `lib/` (grep). Contract: `reportStudent`, `reportChatMessage` stable (`openapi.yaml@2e5bb69:3664-3693`; ops table) | Flutter + designer | **yes (contract)** |
| UGC: block and blocked list | MISSING in app | `blockStudent`, `unblockStudent`, `listMyBlocks` stable since 3.37; leaderboard already hides blocked students both ways (`LeaderboardEntry`, `@2e5bb69:4641-4664`) | Flutter + designer | **yes (contract)** |
| UGC: contact support | MISSING | Support is a disabled shell (`customer_support_screen.dart:26-39`) while 5 support ops are stable (3.39) | Flutter + designer | **yes (contract)** |
| UGC: ban handling | MISSING | `403 account_banned` on `verifyOtp`, `verifyParentOtp`, `confirmRecovery`, `verifyRedemptionSessionOtp` (`error-codes.md@2e5bb69:51`; `openapi.yaml@2e5bb69:231,371,542,625` — "the code is consumed and no tokens or session were issued"); `account_banned` appears nowhere in `lib/`; `authErrorMessage` maps unknown codes to `genericError` (`auth_error_copy.dart:12-27`) so a banned student sees a generic error after the OTP is consumed | Flutter + designer | **yes (3.42; absent from the 3.38 working-tree vendor)** |
| UGC: name and text filtering, report SLA | UNKNOWN | no contract text on display-name moderation or text filtering (grep "profan\|moderat"); photos are scanned (policy §5) | Seif | no |
| Leaderboard peer names (H-1) | PARTIAL / decision | `leaderboard_row.dart:99`, `podium.dart:154` show `entry.name`; `studentId` already decoded (`leaderboard_models.dart:73`) so report/block can be wired without new data | Mostafa (Option 0 vs controls) | **yes (the report/block option is now buildable)** |
| Message tab placeholder (E-5) | BLOCKED (decision) | `tab_placeholder.dart:33,55-61`, route `app_router.dart:314`; contract now also offers inbox, chat, support, friends | Mostafa | no |
| Stub / inert surfaces (H-3) | PARTIAL | Refer (`refer_a_friend_screen.dart`), Friends (`friends_screen.dart`, no entry point), Support, Favorites, Progress, Go-to-Uni confirm disabled, four ON-but-disabled toggles; Registration discards the referral code (`registration_draft.dart:17`) although `inviteCode` is stable (`openapi.yaml@2e5bb69:390`, 3.44) | Mostafa + Flutter | **yes (contract unlocked most of them)** |
| Reviewer access (E-6) | BLOCKED | fixed-OTP whitelist "Absent from production configuration" (`openapi.yaml@2e5bb69:96-98`) | Seif | no |
| Store listing assets, fastlane/metadata | MISSING | no fastlane, metadata, screenshots, feature graphic anywhere (find depth 4); default `pubspec.yaml:2` description | Design + Mostafa | no |
| **Support URL / support email for the listings (added in verification)** | MISSING | `docs/STORE_READINESS.md:213-216` lists "support URL/email" and "iOS Support URL" as required listing assets (DOC; current store requirements not re-fetched by me); no support URL or email exists in `lib/` or the contract (grep → none); both served legal texts send every request to the in-app Support section, a disabled shell (`customer_support_screen.dart:26-39`) | Mostafa + Seif/web | **yes (new finding)** |
| Developer accounts, closed test | UNKNOWN | nothing in repo; Play URL for the ratified ids 404 on 2026-10-06 (DOC `STORE_READINESS_RUBRIC.md:54`); publish-account type listed as an open owner decision (`STORE_READINESS.md` §14 item 5) | Mostafa / client | no |
| iPad, orientation, portrait lock | MISSING (decision) | no `screenOrientation`; iPhone landscape and iPad families enabled | Mostafa | no |
| CI | PARTIAL | `ci.yml` has analyze-and-test, goldens, codegen drift, APK compile gate (`:70,210,260,318`); never observed running (R-3, cannot verify from here) | Owner | no |

---

##### 3. Roadmap P0 / P1 master issues re-checked (29 rows from `master_issues`)

| MI | ID | Re-verified now | Delta vs roadmap |
|---|---|---|---|
| MI-001 | AND-02 keystore | CONFIRMED (ARTEFACT: apksigner fails; `key.properties` absent) | none; (added in verification) the only AAB on disk carries the dropped id `com.levelup.level_up_app` and must not be uploaded |
| MI-002 | API-02 deletion | CONFIRMED (SOURCE: uncalled; contract stable and unchanged; copy conflict persists) | none |
| MI-003 | API-25 prod host | CONFIRMED (3.45 `servers:` staging only) | none |
| MI-004 | API-26 reviewer | CONFIRMED (CONTRACT `:96-98`) | none |
| MI-005 | FEAT-C-14 / E-2 | CONFIRMED in the app; **premise changed** (text exists on staging, §1) | roadmap action "Legal supplies hosted AR and EN copy" is obsolete; remaining: wire, approve, public URL, entity, and the Terms §2 acceptance gate |
| MI-006 | GAP2-02 journeys | not re-verified (aggregate, outside this dimension) | — |
| MI-007 | PRIV-STORE-07 / E-7 | CONFIRMED unfiled; **narrowed** by policy text (§1) | roadmap "never requested" is half stale |
| MI-008 | PRIV-STORE-08 / E-8 | CONFIRMED (changelog `:499`, no later entry) | none |
| MI-009 | SEC-17 / E-4 | CONFIRMED (SOURCE) | none |
| MI-010 | FEAT-C-09 / H-1 | CONFIRMED; options widened | report/block + `acceptTerms` all stable; name moderation unknown |
| MI-011 | GAP11-03 guardian phone | CONFIRMED in app (no purpose text, required on both tracks, never read back) | policy now states the purpose (recovery); but see Q8 about parent reports |
| MI-012 | GAP4-03 Apple critical path | unchanged (no team, no Mac evidence in repo) | — |
| MI-013 | IOS-01 never built | CONFIRMED (no Podfile/Pods; no macOS job) | — |
| MI-014 | IOS-13 signing | CONFIRMED; **requirement changed** | roadmap says register App IDs "with no capabilities"; push needs the Push Notifications capability on both App IDs plus an APNs key (INFERENCE, standard APNs requirement; handoff item 6) |
| MI-015 | NAV-02 Message tab | CONFIRMED | contract now supplies real content for it |
| MI-016 | PRIV-STORE-11 under-13 | CONFIRMED (no age rule in contract 3.45) | — |
| MI-017 | PRIV-STORE-21 iOS keys | CONFIRMED | `ar.lproj` becomes functional, not cosmetic, once push strings are needed (§4) |
| MI-018 | PRIV-STORE-23 listing assets | CONFIRMED (none) | support URL/email added to the asset list (added in verification) |
| MI-019 | PRIV-STORE-34 closed test | UNKNOWN (no evidence either way) | — |
| MI-022..027 | scope, PDPL, transfers, Q-B filing, chains, owner decisions | CONFIRMED process gaps; MI-025 verified (`seif_fight.md` has no retention/reviewer/prod-host entry) | MI-024 narrowed (processors named, regions not) |
| MI-028 | GAP6-01 predictive back | not re-verified (outside dimension); see the Android 15/16 row in §2 | — |
| MI-029 | PRIV-STORE-12 "Subscribe" | CONFIRMED (`app_en.arb:516` is mandated by contract `:2069`) | — |
| MI-030 | UI-05 #87 | not re-verified (design) | — |
| MI-399 | IOS-07 / H-7 | CONFIRMED at SOURCE that init runs at registration (every launch); runtime crash still unverifiable | — |

---

##### 4. Requirements the new backend inputs add (not yet in any plan)

**Push (handoff item 6).** The 8 keys, EN/AR texts, 4 kinds, payload keys and tap rules in the handoff match the contract exactly (`realtime.md@2e5bb69:82-107`; four kinds `:82`, `title_loc_key`/`body_loc_key` as "strings shipped in the app" `:84`, the 8-key table, data keys, "unknown kind: open the notifications screen", "registers its FCM token after sign-in and on every token refresh"). Delivery is off in every environment until backend staging verification is recorded (`:80`); the only push operation is `PUT /me/fcm-token` ("204 Stored (idempotent; one token per the single active device)", `openapi.yaml@2e5bb69:1062-1082`). Store-relevant consequences:
- Android: `POST_NOTIFICATIONS` is absent from the manifest and needs a runtime request on Android 13+ (`targetSdk 36`); per-flavor `google-services.json` at the reserved `android/app/src/{prod,staging}/` paths (`ENVIRONMENTS.md:351-353`).
- The phone renders `title_loc_key`/`body_loc_key` from **strings shipped in the app and follows the phone language, not the in-app switch** (`realtime.md@2e5bb69:84`). That means native resources (Android `strings.xml` + `values-ar`; iOS `Localizable.strings` in `en.lproj` and `ar.lproj`), not the Flutter ARB files (INFERENCE from FCM behaviour; the contract only says "shipped in the app"). The ARB parity guard does not cover native strings, and iOS `knownRegions` must gain `ar` (H-4 becomes mandatory).
- iOS: Push Notifications capability and entitlement, APNs key, App Review notes, privacy manifest for the Firebase pods (UNVERIFIED which pods ship manifests).
- Tap routing needs targets that do not exist: ticket (Support is a shell), friend-request list (Friends is a shell), conversation (no chat screen), notifications screen (Message tab is a placeholder). "Unknown kind → open the notifications screen" presupposes that screen.
- Privacy: Firebase Messaging ends the zero-SDK posture (`STORE_READINESS.md:42,230`; row corrected in verification — line 44 is the logging row): Data Safety "Device or other IDs", App Privacy "Identifiers", `AD_ID` to re-check in the merged manifest; the staging privacy text already lists FCM.
- Sign-out: the contract keeps one token per student, last write wins, and has no delete-token operation (changelog `@2e5bb69:314-316`, `openapi.yaml@2e5bb69:1060-1082`); the `logout` operation says only "Revoke this session (access + refresh chain)" (`:451-462`), and the 3.17/3.18 entries and the `realtime.md` push section are silent on sign-out, so whether `POST /auth/logout` clears the token is not stated (Q7).

**Photos (handoff item 4).** Avatar and support photos are `draft` (5 operations), so under the stable-only rule they cannot ship yet. When they do: prefer the system photo picker (no `READ_MEDIA_IMAGES`; DOC `STORE_READINESS.md:63`), iOS PHPicker needs no purpose string, camera capture would need `CAMERA` and `NSCameraUsageDescription` (INFERENCE); support photos upload by presigned PUT to a storage host (new HTTPS egress) with a client-computed SHA-256 of the bytes (`openapi.yaml@2e5bb69:2853`); photo paths require accepted Terms (`403 terms_acceptance_required`). User copy: the handoff's "This photo can't be sent" is exactly the contract's client string for a rejected **support** photo, and the contract's avatar string is "this photo can't be used" (both in `error-codes.md@2e5bb69:16`, `image_rejected_by_moderation`; corrected in verification — the investigator had read only the "can't be used" half); final wording is still the designer's and AR text is not supplied.

**UGC (Apple 1.2 / Play UGC; policy summaries are DOC, fetched 2026-10-04 per `store_readiness_recheck.md:114-148`, not re-fetched by me).** Contract coverage at 3.45 versus the app:

| Control | Contract | App |
|---|---|---|
| Terms acceptance before UGC | `getTermsAcceptance`, `acceptTerms` stable; recorded, not enforced server-side except photo paths | none |
| Report message / student | stable | none |
| Block / unblock / list | stable | none |
| Contact (support tickets) | stable (+ photos draft) | disabled shell |
| Ban handling | `403 account_banned`, inbox `moderation_warning` | not handled |
| Filtering, SLA | photos scanned (policy §5); text/name filter UNKNOWN | — |

If release 1 ships only the leaderboard (Option 0, no peer names) and hides Message/Friends/chat, none of this is a store blocker; if friends, chat or forwarded questions ship, every row is.

---

##### 5. P0 store blockers — current status

| # | Blocker | Status 2026-10-08 | Movement since 10-06 |
|---|---|---|---|
| E-1 | Production API host | OPEN | none; production implied but not announced |
| E-2 | Privacy policy and terms | OPEN, **re-shaped**: text exists on staging; app wiring, approval, entity, public URL and the Terms §2 acceptance gate open | contract/API |
| E-3 | In-app account deletion (+cancel, 403 routing) | OPEN | none; needs design + copy ruling |
| E-4 | iOS required-reason API (`device_info_plus`) | OPEN | none |
| E-6 | Production reviewer login | OPEN | none |
| E-7 | Retention / erasure / sub-processor facts | OPEN, **narrowed** by policy text | API |
| E-8 | Web deletion URL (Play) | OPEN | none |
| AND-02 | Upload keystore / Play App Signing | OPEN (prerequisite); the only AAB on disk has the wrong package id and must not be uploaded | none (identity hazard added in verification) |

P1 (unchanged status): E-5 Message tab; H-1 peer names; iOS never built / no team; listing assets (now including a support URL/email). **Conditional P0 depending on release-1 scope:** UGC controls and ban handling (if friends/chat ship); push prerequisites (if push ships in v1; rubric category 8 needs a recorded decision either way).

**Not verified by me:** a build of HEAD, a flavored AAB (and therefore 16 KB alignment of an AAB; the prod APK is ARTEFACT-verified), CI runs, any device behaviour, iOS anything, current Apple/Google policy text, production backend state, whether any Firebase project exists.

## 13. Contract impact analysis
### Contract impact analysis

#### What the app consumes (SOURCE)

The app calls exactly **26 operations**, all stable at all three pins (25 `_dio.*` call sites plus the bare-Dio `/auth/refresh` at `auth_repository.dart:86-87`; no other Dio or http callers in `lib/` except `dev/mock_backend.dart` and `dio_client.dart`):

| Repository | Operations (file:line) |
|---|---|
| `auth_repository.dart` | `requestOtp` :32, `verifyOtp` :59, `refreshTokens` :87 (bare Dio), `logout` :109 |
| `registration_repository.dart` | `completeRegistration` :40 |
| `reference_repository.dart` | 7 reference reads at :26, :47, :73, :106, :135, :155, :175 |
| `profile_repository.dart` | `getMyProfile` :27, `updateMyProfile` :58, `getMyEntitlements` :80 |
| `mistakes_repository.dart` | `getMyMistakes` :52, `getMyMistakesForSubject` :85 |
| `catalog_repository.dart` | `listSubjects` :26, `getSubjectTree` :54 |
| `quiz_repository.dart` | `createQuiz` :53, `submitAnswer` :94, `finishQuiz` :118, `getExplanation` :152 |
| `flashcards_repository.dart` | `getFlashcardsForLecture` :74, `setFlashcardSelfGrade` :112 |
| `leaderboard_repository.dart` | `getLeaderboard` :51 |

Nothing in `lib/` calls these as API endpoints; they occur only in comments, or (for `/friends` and `/support`) as go_router route paths, not API calls: `/me/notifications*`, `/me/fcm-token`, `/me/terms-acceptance`, `/me/deletion-request`, `/leaderboard/me`, `/me/quiz-summary`, `/friends` (route at `lib/core/router/app_router.dart:423`), `/conversations`, `/support/*` (route `/support` at `app_router.dart:417`; `context.push('/support')` at `profile_screen.dart:282`).

**Decoder strictness.** There is no `build.yaml`. No generated decoder uses `$checkKeys` or `disallowUnrecognizedKeys` (grep over `lib` returns 0), so extra JSON keys are ignored. The only closed enums on consumed wire values are:

- `Track {school, university}` (`student_profile.dart:29`), unchanged at all pins.
- `FlashcardSelfGrade`, `QuizMode`, `QuizType`, unchanged.
- `EntitlementType`, which has an `unknown` fallback (`entitlement_state.dart:21-29`).

#### Operations the app consumes that changed

| Operation (consumed) | Where it changed | Change | Will the existing model decode? | Behaviour today | Evidence |
|---|---|---|---|---|---|
| `verifyOtp` | 3.42 (`c7904bf`) | New `403 account_banned`, only after the code is proven. The code is consumed and no tokens are issued. Contract: "Do not retry; route to Support". | n/a (error path) | `ErrorInterceptor` maps it to `ApiException(403, 'account_banned')` (:29-41). `OtpNotifier.verify` stores it (:158-164). `authErrorMessage` has no case for it and falls back to `genericError` "Something went wrong" / "حدث خطأ ما" (`auth_error_copy.dart:10-25`). No ban screen, no crash, and nothing in `otp_notifier` blocks a further `verify()` call, so the student can keep retrying. | openapi@2e5bb69:230-232 (the `'403'` block; corrected from :231-233); error-codes@2e5bb69:51 (SOURCE + CONTRACT; not DEVICE) |
| `verifyOtp` / `completeRegistration` → `AuthenticatedResult` | 3.43 | + optional `inviteCodeApplied`, only on `completeRegistration` and only when `inviteCode` was sent | ✅ `AuthResult.authenticated` reads only `tokens` and `profile` (opaque `Map`) (`auth_result.g.dart:9-14`) | Field absent: the app never sends `inviteCode` | @2e5bb69:4087-4093 |
| `completeRegistration` request (`SchoolRegistration` / `UniversityRegistration`) | 3.43 (stable 3.44) | + optional `inviteCode` (string; a bad code never fails registration). **The two schemas disagree on stability (added in verification):** `SchoolRegistration.inviteCode` says "`stable` since 3.44.0-m1" (:4147), the `completeRegistration` description says the same (:390-391) and the 3.44 entry says "the optional `inviteCode` on registration … now stable" (changelog:16-18), but `UniversityRegistration.inviteCode` still says "this field is `draft` — send it only once it is `stable`, because an older backend refuses unknown properties with `validation_failed`" (:4182). Upstream `git log -S` puts that wording at `cadba7b` (3.43), untouched at `2e5bb69`. | n/a (request) | The code is collected and dropped (`signup_identity_screen.dart:92`; `registration_draft.dart:18` "no backend field", now stale) | @2e5bb69:4144-4152, :4179-4188, :390 |
| `getMyProfile` / `updateMyProfile` (`StudentProfile`) | 3.42 | Prose only. A `custom` avatar URL is on the avatars CDN host. Choosing `avatarId` replaces an active custom avatar. `parentReportStatus` `active` needs Production delivery. | ✅ `ProfileAvatar.type` and `url` are Strings (`student_profile.dart:114-126`); `parentReportStatus` is `String?` (:224) | No custom avatars can exist while upload is draft. Image loaders (`CachedNetworkImage` / `Image.network`) apply no host allowlist. | `consumed_diff.py`: desc-only |
| `getLeaderboard` (`LeaderboardEntry`) | 3.36 | Prose only: students blocked either way are excluded; ranks dense per caller | ✅ unchanged | `autoDispose` provider, no cross-account cache | @65245be:2304-2305 |
| `requestOtp` | 3.32 | Prose: SMS only | ✅ | none | changelog:182-183 |
| All operations (`ProblemDetails`) | 3.32 | Body may be absent or lack `code`. Send `Accept: application/json`. | ✅ The fallback `code: 'unknown'` covers it (`error_interceptor.dart:25-27`). A code-less 401 is not refreshed (`auth_interceptor.dart:160-163`, then :81-83) and becomes `UnauthorizedException('unknown')`, so the generic error shows. | No `Accept` sent (below) | @65245be:3367-3376 |
| `createQuiz` / `submitAnswer` (`weekly_question_limit_reached` row) | 3.43 | error-codes text: answering a forwarded card also spends the weekly allowance | ✅ | App copy unchanged. The allowance can drain outside quizzes once friends forward questions (not possible until chat is built). | error-codes@2e5bb69:31 |

**Unchanged across all three pins** (operation and transitively referenced schemas; description-stripped compare): `refreshTokens`, `logout`, the 7 reference reads, `getMyEntitlements`, `getMyMistakes`, `getMyMistakesForSubject`, `listSubjects`, `getSubjectTree`, `createQuiz`, `submitAnswer`, `finishQuiz`, `getExplanation`, `getFlashcardsForLecture`, `setFlashcardSelfGrade`. That is 20 of 26. No consumed operation's `x-behaviour-changed` stamp moved in 3.29–3.45. Re-run in verification (`structdiff.py`): of the 30 schemas transitively referenced by consumed operations, only `AuthenticatedResult`, `SchoolRegistration` and `UniversityRegistration` changed structurally 0df5cf4→2e5bb69; `LeaderboardEntry`, `ProblemDetails` and `StudentProfile` changed in prose only; `verifyOtp` is the only consumed operation whose response set changed (`+'403'`).

**Error-handling limits that bound the above (added in verification).** `ErrorInterceptor` parses `Retry-After` only when `status == 429` and `code == 'rate_limited'` (`error_interceptor.dart:34-36`, `_retryAfter` :64-70, delta-seconds only). `otp_throttled` (429, consumed today) and `forward_daily_limit_reached` (429 with `Retry-After` = seconds to Cairo midnight, error-codes@2e5bb69:70) fall through to a plain `ApiException` with no `retryAfter`. This is not a current defect (`otp_throttled` declares no `Retry-After`), but it bounds roadmap Q-B5 and any lockout pop-up.

#### Contract-model guard

`test/guards/contract_models_test.dart` has **13 bindings plus 1 canary = 14 tests** (:73-156). The bindings are:

- `StudentProfile` and 5 nested blocks
- `EntitlementState`
- `UniversitySubjectTree` and `lectures[]`
- `SchoolSubjectTree`
- `AnswerResult`
- `NamedRef`
- `FlashcardCard`

The guard's own parser (`test/guards/rules.dart:366-431`) was copied verbatim into `scratch/dartcheck/check.dart` and run with Dart 3.12.2 against all three files; it was re-run independently in verification with the same result (SAME for all 13 bindings). **All 13 `required` lists are identical at 0df5cf4, 65245be and 2e5bb69.** PyYAML agrees: every bound schema is structurally unchanged, and `StudentProfile` / `.school` changed only in prose. The canary (`length > 100000`) holds at all pins (171,110 / 234,617 / 288,365 bytes).

**The guard test and the full suite did run at both candidate pins (corrected from "BUILD-lite: the test itself was not run").** In scratch logs from an earlier pass: `test_full.log` (live working tree, contract = 65245be) ends `+2067: All tests passed!`, exit 0, with `analyze.log` "No issues found!" and `format_all.log` "0 changed"; `guards_338_worktree.log` lists the 13 binding tests plus the canary passing; `test_full_345_clone.log` (scratch clone with the 2e5bb69 contract) ends `+2067: All tests passed!`, exit 0; `guards_345_clone_lf.log` lists the 13 binding tests plus the canary passing (6 test files, no failures). Limits: the full-suite logs use the expanded reporter, which names only in-flight tests, so only the file-subset logs show the guard by name; none of these runs used `tool/validate.ps1`; they were not CI. **Level: BUILD** (the verifier proposed ARTEFACT, but `docs/WAVE_STATUS.md:74-77` defines BUILD VERIFIED as "compiles and the suite is green" and reserves ARTEFACT for built output such as `aapt2` on the APK, so BUILD is kept). Re-vendoring to either pin therefore needs no model change for the guard.

**Parser fragility: it requires LF (added in verification).** On a CRLF copy of the 3.45 file every one of the 13 bindings throws `ContractShapeException` ("no `required:` at indent 6 for <Schema>"; `scratchpad/aud/probe_crlf.log` shows `+1 -13`, the canary passing). The vendored files are LF (see "Line endings" above), so this is a fragility, not a current failure; a re-vendor that lands with CRLF (for example through a Windows redirect) would fail 13 guard tests loudly. The earlier note that the parser "handles the CRLF contract files correctly" is withdrawn: the files are not CRLF, and the parser does not tolerate CRLF.

#### Contract open questions re-checked against the files

- **(a) `transferToUniversity`.**
  - Stability: absent at 0df5cf4; `draft` at 65245be (`openapi.yaml@65245be:1194-1198`, x-stability :1197); `stable` at 2e5bb69 (`:1334-1338`, :1337).
  - The 3.38 entry (changelog@65245be:7, @2e5bb69:128) says: "Still `draft`: do NOT ship it to students yet; the screens may be built against it now (Q-45.1, contract-first)."
  - 3.39 (changelog@2e5bb69:107, :111) lists it under "22 OPERATIONS ARE NOW `stable` — build against these now" (`profile` — `transferToUniversity`).
  - **The draft-exception question (roadmap DR-24) is moot at any pin ≥ 3.39 (`e5886a6`). It stays live only if 65245be is committed and transfer work starts before the next re-vendor.**
  - The 3.38 entry (:129-135) also answers the old S31 data-model questions: points, level, badges, subscription and privacy carry over; the friend list resets; blocks stay; school-track quizzes are refused with 403 after the transfer.
- **(b) `Accept: application/json`.** `lib/core/network/dio_client.dart:19` sets `headers: const {'Content-Type': 'application/json'}` only (both `create` and `createBare`). Dio 5.10.0 never sets `Accept`: `lib/src/headers.dart:22` only defines the constant, and it is the only `accept` reference in `headers.dart`/`options.dart`/`dio_mixin.dart`/`io_adapter.dart`. `dart:io` adds only `accept-encoding: gzip` (`dart-sdk/lib/_http/http_impl.dart:2311`). **The app sends no `Accept` header** (SOURCE; not captured on the wire). An absent `Accept` does not exclude JSON, so body-less errors from this cause are unlikely, but the contract asks for the header on every call.
- **(c) `error_interceptor.dart`.**
  - The comment at :9-10 ("TODO(contract)… Every non-2xx body is RFC 9457 ProblemDetails with a stable `code`") is stale since 3.32 (the 0df5cf4 `ProblemDetails` said "EVERY non-2xx body has this shape", `openapi_0df5cf4.yaml:2468`; the 3.32 entry, changelog@2e5bb69:182, withdrew the promise).
  - The fallback at :25-27 (`data is Map && data['code'] is String ? … : 'unknown'`) already implements the defensive parse. The `'unknown'` code reaches the generic copy, which matches "treat like `internal_error`".
- **(d) S11 favourites** (`seif_fight.md:882-898`; `profile_screen.dart:240`). Open at 0df5cf4 and 65245be (draft). **Answered at ≥ 3.39**: `addFavorite`, `removeFavorite`, `listFavorites` stable (`@2e5bb69:2106`, `:2118`, `:2131`).
- **(e) `friends_screen.dart:9-13` `TODO(contract)`.** The "no friends list, no requests, no social graph" half has been stale since 3.37, so it is already stale at 65245be (12 stable social ops). Its citation `openapi.yaml:1094` ("affects profiles/friends") points to prose that appears at none of the three pins: "friends" has 0 hits at 0df5cf4. Upstream `git log -S'profiles/friends'` (verifier): present at `23f0535`, removed at `8ae7ed1` (2026-09-04), i.e. stale before the committed pin.
- **(f) S36 entry point.** Still open: the contract defines no navigation. The only hint is a push destination, not an in-app door: `friend_request_received` → "open the friend requests list (`listMyFriendRequests`)" (realtime@2e5bb69:106). This is a designer question.
- **(g) S24.** Answered by `getMyQuizSummary` → `{solvedQuestions}`. It was draft in 3.34 and became stable in 3.37 (`@65245be:1564`, `@2e5bb69:1731`). It is its own read, not the `GET /me` field S24 asked for.
- **(h) Line-citation drift.** `openapi.yaml:NNN` citations:
  - lib: 64 in 37 hand-written files, plus 8 copies in generated `.freezed.dart` (72 total).
  - test: 18 in 12 files.
  - docs: 111.
  - lib hand-written files also hold 32 bare `:NNN`–`:NNNNN` cites (28 lines) by the regex `[^a-zA-Z0-9_.]:[0-9]{3,5}\b`; the figure is regex-dependent (a backticked-4-digit-only pattern gives fewer).

  Mapping 0df5cf4 lines through `difflib` (`cite_drift.py`, 82 hand-written lib + test cites; re-derived independently in verification):
  - vs 65245be: 15 still on the same line, 67 shifted, 0 on changed lines.
  - vs 2e5bb69: 15 same, 64 shifted, 3 now on changed lines.

  Some cites were already stale before this (see (e)).

**Other `seif_fight.md` items answered in 3.29–3.45 (CONTRACT vs DOC):**

| Item | What the contract now says |
|---|---|
| S5 referral | `getMyInvite` + `inviteCode` / `inviteCodeApplied`; reward rule +10 to the inviter (3.43, stable 3.44). `refer_a_friend_screen.dart:9` is stale. The University registration schema still labels `inviteCode` draft (see the consumed-operations table). |
| S14 review from history | `getQuizReview` stable 3.39 and `listQuizHistory` stable 3.43 |
| S30 legal text | `getLegalDocument` stable 3.43; changelog:38 says staging answers 200. `legal_document_screen.dart:12-23` and `profile_screen.dart:287/298` are stale. |
| S31 Go to Uni | `transferToUniversity` stable 3.39, rules at changelog:129-135 |
| S33 support | 5 ops stable 3.39 (text). `customer_support_screen.dart:9-11` "no endpoint of any kind. Not draft — absent" was already false at the committed pin (5 draft support ops at 0df5cf4: `openapi_0df5cf4.yaml:2278-2409`). |
| S29 avatar upload | Semantics answered in 3.42: the check is synchronous, a refusal stores nothing and keeps the old avatar, copy is "this photo can't be used". **Both avatar ops are still draft at 3.45.** |
| S2 resume | Only partly: `GET /quizzes/{quizId}` (`getQuizReview`, operation at `@2e5bb69:1912`) is stable but finished-only (`403 quiz_not_finished`, `@2e5bb69:1938`). Resume is still impossible; asks 2–3 (abandon / budget) still open. |
| `home_header.dart:31` | "no notifications endpoint" has been stale since **3.28, the committed pin** (`getUnreadNotificationCount` stable, `@0df5cf4:1030-1034`; `listMyNotifications` `:983-984`). |

**Not answered at 3.45:** S4, S7, S9, S10, S12, S13, S15–S17, S19–S21, S25–S28 (no preference field anywhere: "preference" has 0 hits), S32, S34, S35, S37, S39–S45, and roadmap Q-B4, Q-B6, Q-B7. Q-B5 is only partly answered: only `forward_daily_limit_reached` defines `Retry-After` as seconds, and `otp_throttled` declares no `Retry-After` at all.

#### Options for the pin (not chosen)

| Option | `contract/SOURCE.md` | Contract-model guard | Line citations | Other consequences |
|---|---|---|---|---|
| **A. Commit the 65245be re-vendor as-is** | Already drafted in the working tree (3.28 → 3.38 delta table, follow-ups 1–5). **`SOURCE.md:17` ("CRLF exactly as upstream stores them") is factually wrong and needs correcting first** (added in verification). | Unaffected (required lists identical). BUILD: suite green at this state in scratch (`test_full.log`, +2067). | 67/82 shifted | DR-24 (transfer draft) stays live. The app pins a 3.38 that lacks the post-pin 3.38 prose (`b33e658`, `495dc45`). The `account_banned` change to consumed `verifyOtp`, plus stable recovery, support, chat, favourites, history, legal, referral and push are all invisible to the pin. Another re-vendor is needed almost at once. |
| **B. Re-vendor straight to 2e5bb69 (3.45)** | The working-tree 3.38 text must be rewritten for a 3.28 → 3.45 delta (17 versions; census 86/81/5/77). "No schema the app decodes changed" no longer holds verbatim (`AuthenticatedResult` gains an optional field, decode-safe). The CRLF sentence disappears with the rewrite but the new text must say LF. | Unaffected. BUILD: suite green at this state in scratch (`test_full_345_clone.log`, +2067), not via `tool/validate.ps1`. | 64 shifted + 3 on changed lines | DR-24 becomes moot. One validation run (the repo's canonical `validate` still has to be run by its owner). Loses the separately reviewable 3.38 checkpoint. |
| **C. Two commits (65245be, then 2e5bb69)** | Keeps the project's one-"Delta from X"-section-per-re-vendor precedent; the second section covers 3.39–3.45. The first commit's text needs the same CRLF correction as A. | Unaffected at both | Drift lands twice | Each commit needs its own validation. The intermediate state is consistent. |

Upstream moved 12 commits and 7 versions (3.39–3.45) in about 32 hours after `65245be` (2026-10-07 04:14Z → 2026-10-08 12:29Z). Any pin taken today may be behind within a day.

#### Contract-level gaps still present at 3.45

| Gap | Evidence | Who |
|---|---|---|
| **No production host in the contract** | `servers:` is staging only at all pins (`:107-109`); "production host" has 0 changelog hits. `app_config.dart:46-54` TODO is still valid (prod resolves to the fail-closed `https://TBD.example/api/v1`). **Narrowed (added in verification):** Seif's 2026-10-06 input is already on record in `docs/ENVIRONMENTS.md:397-400` (DOC): planned host `api.level-upworld.com`, planned base URL `https://api.level-upworld.com/api/v1` (path carried over, not separately confirmed), nothing deployed, DNS unverified, not in `servers:`, no date, "the contract remains the announcement channel". What is still open is publication in `servers:` (and in `realtime.md` for `/hubs/chat`) and a date. Already Q-B3 (release_readiness §7), unanswered. | Seif |
| **Firebase project and config per environment** (staging `.stg` vs prod), bundle and app IDs | 0 hits for firebase / google-services / GoogleService / bundle id / applicationId / package name in all four mobile contract files at 2e5bb69. **Already asked and recorded (added in verification):** `docs/ENVIRONMENTS.md` §7 (:340-357) holds Seif's 2026-10-06 Q7 position (backend holds no Firebase credential in any environment, sends no push, project ownership and app registration not coordinated, whether the flavors share one project not finalised, iOS needs an APNs key), names the four registrations (Android and iOS × prod and `.stg`) and reserves `android/app/src/{prod,staging}/google-services.json` and `ios/Runner/Firebase/{prod,staging}/GoogleService-Info.plist`; `android_identity_test.dart` already refuses a file in `src/main` (:314, :325). | Seif / Mostafa |
| **FCM token after logout or on a shared device** | No DELETE operation. `logout` documents no token effect (`openapi@2e5bb69:455-461`). "One token per student, the latest wins" (realtime:108; changelog:314-315, 3.17 entry: "No DELETE/unregister"). | Seif |
| **Support channel for a banned student** | `account_banned` says "route to Support" (error-codes@2e5bb69:51, suggested copy "Account banned — contact Support"; the `moderation_warning` inbox copy says "contact Support from the app", `openapi@2e5bb69:1181-1182`), but every support op needs a bearer (only 19 public ops, none tagged support), and the ban revokes sessions | Seif / product |
| **When the 5 photo and avatar drafts flip** | "stay `draft` until they are served on staging" (changelog:79); no date | Seif |
| **Prose inconsistencies at 3.45** | See below. | Seif |
| **Not contract gaps** | "Logged in on another device" = `401 session_superseded` (error-codes:13), handled by `LogoutReason.supersededOtherDevice` → `login_screen.dart:67`. The weekly reset moment is adr-091 §3, Monday 00:00 Africa/Cairo, "not on the wire" (`DESIGN_ISSUES.md:1601`). The push strings are supplied. | — |
| **Inbox copy for `enrolment_opened`, `support_ticket_replied`, `academic_year_opened`** | The client authors it (localization contract, `@2e5bb69` listMyNotifications 200 description, `:1162-1197`). Only `moderation_warning` (approved EN/AR, `:1174-1185`) and the push strings are supplied; the 3.41 entry suggests only an English "Support replied to your ticket" with no AR and no approval (changelog:94); `academic_year_opened` data (`track`, `academicYear`) are "localization parameters, not display text" (`:1193-1196`). | Mostafa / designer |

The prose inconsistencies at 3.45:

- The `support` tag says "Text only for launch… Every operation here is `stable`" (`:133-137`), while 3 draft photo ops carry that tag.
- The `social` tag says "No … streaks here" (`:138-142`), while `listMyFriendStreaks` is tagged `social`.
- `getTermsAcceptance` says "the backend serves no Terms text and no link" (`:1095`), which contradicts `getLegalDocument` (`:811-830`).
- The 3.37 entry's "18 values" does not match the 15 flips in the YAML (changelog:138 vs :140-143).
- (added in verification) `UniversityRegistration.inviteCode` is described as `draft` (`:4182`) while `SchoolRegistration.inviteCode` (`:4147`), the `completeRegistration` description (`:390`) and the 3.44 entry (changelog:16-18) say `stable` since 3.44.0-m1.
- (added in verification) The 3.35 entry says "`info.version` bumped `3.28.0-m1` → `3.35.0-m1`" (changelog:157), but the preceding version is 3.34.0-m1 (the 3.34 entry, changelog:162).

**Implementation consequences the contract now fixes (SOURCE + CONTRACT; not decisions):**

- **Accept header.** Add `Accept: application/json` to `DioClient._baseOptions` (`dio_client.dart:19`) and update the interceptor comment (:9-10).
- **Native push strings.** The push loc keys must ship as native strings (Android `res/values{,-ar}/strings.xml`, iOS `en.lproj`/`ar.lproj`). Today the app has only `values/colors.xml` and `styles.xml` (plus `values-night/styles.xml`), and only `Base.lproj` (`android/app/src/main/res`, `ios/Runner`).
- **Terms gate on photos.** Photo uploads (avatar and support) are gated by `403 terms_acceptance_required`, and the app has never built `getTermsAcceptance` / `acceptTerms` (both `x-stability: stable` at 0df5cf4, `:922` and `:951`; no `lib` call to `/me/terms-acceptance`, only comments).
- **Presigned PUT.** It must not go through the main Dio: `AuthInterceptor` (:56-58) would attach the Bearer token to the storage URL. [INFERRED]
- **Conditional GET on `getLegalDocument` (added in verification).** Dio 5.10.0's default `validateStatus` accepts only 200-299 (`dio-5.10.0/lib/src/options.dart:697-699`) and the app never overrides it (no `validateStatus` in `lib`). A `304` answered to `If-None-Match` would therefore surface as a `DioException(badResponse)` that `ErrorInterceptor` maps to `ApiException(status: 304, code: 'unknown')` (`error_interceptor.dart:22-41`). A legal-document wave that sends `If-None-Match` must override `validateStatus` for that call, or not send the header. [INFERRED from library source and interceptor code; not executed.]
- **New packages.** None of SignalR, `firebase_messaging` or an image picker is in `pubspec.yaml` (:30-64).

#### Decisions reserved for the owner (not for Claude)

- **Contract pin** (A, B, C above, or wait for a freeze; roadmap DR-23). Mostafa decides. Whether the build-only-against-stable rule gets an exception for `transferToUniversity` while the pin is 3.38 (DR-24) is moot at any pin ≥ 3.39.
- **Release-1 scope** of the areas newly stable at 3.45: lost-phone recovery, Track transfer, support (text), friends and blocks, chat plus the SignalR hub, favourites, quiz history and review, Refer a Friend, forwarded questions, friend streaks, legal documents, inbox, push (DR-25, DR-01, DR-11).
- **Refer a Friend reward conflict:** Figma says 500 points to both students; the contract says +10 to the inviter only and nothing to the new student (changelog 3.43). Product decides; Claude must not choose. Separately, whether to start submitting the already-collected invitation code (`signup_identity_screen.dart:92`), and, for University students, only after Seif clarifies the `UniversityRegistration.inviteCode` wording.
- **Subscription screen with a website link (handoff item 1) versus purchase-silence:** `adr-049 §3` (contract-changelog.md@2e5bb69:564) says the app never carries a purchase link or tells the student where to buy; nothing in 3.29–3.45 revises it, and `docs/RISKS.md` R-10 is OPEN — DECISION (product owner + Seif).
- **Design and copy of the account-banned screen.** The contract offers suggested EN/AR strings but says the client owns them.
- **Legal documents in-app from `getLegalDocument` (stable 3.43) or as hosted pages** (DR-14).
- **Leaderboard user-generated-content option** (DR-04): `blockStudent` has been stable since 3.37 and `reportStudent` since 3.39.
- **Android and iOS identifiers to give the backend** (the contract does not carry them; iOS is still `com.levelup.levelUpApp`), **when and where the app asks for notification permission**, and **adding runtime packages** (a SignalR client, `firebase_messaging`, an image picker or cropper).
- **Whether to file the 3.36 leaderboard "blocked students excluded" change as BEHAVIOURAL** with Seif, since it carries no `x-behaviour-changed` stamp.

#### Unknowns (searched, not resolved)

- What a second `verify` with the same, now consumed, code returns after a 403 `account_banned` (the contract says only that the code is consumed).
- Whether staging actually serves the operations made stable in 3.37–3.44 (the changelog claims staging deploys; nothing was probed).
- Whether production has a configured Terms version (`getLegalDocument` may answer `404 legal_document_unavailable`; the changelog says only that staging answers 200).
- Whether the missing `Accept` header ever produces a body-less error on the real backend (no traffic captured).
- Whether the 0df5cf4-relative citation drift numbers are meaningful: some citations were already stale against 0df5cf4 itself, and the baseline accuracy of each of the 82 citations was not verified.
- Whether upstream has moved past `2e5bb69` since 2026-10-08 12:29 UTC (the clone was not re-fetched).
- The admin contract files (`openapi-admin.yaml` and the others) were not analysed; they are out of scope and not vendored.
- How inbox kinds that are not consumed would be rendered: there is no app model, so no decode test is possible.
- Whether the handoff's own throwaway-worktree validation run exists as a separate artefact. Its numbers are reproduced at BUILD level above; the run itself was not located.

### 13.x Per-operation census (all 86 operations)
_Verification (Fable): 15 claims - 15 confirmed, 0 partial (corrected), 0 refuted (corrected), 0 unverifiable. Four confirmed claims (K7, K8, K12, K15) carried citation or date corrections; 11 section-level citation or wording errors were corrected and 7 missed items were integrated (one of them qualified by the corrector, see "Support launch coupling")._

#### Per-operation Flutter consumption census (all 86 operations)

**Scope and method.** Every one of the 86 operations in `scratchpad/ops_table.txt` was traced from the contract to a Dart call site, a provider/notifier/bloc, a screen and route, tests, the dev mock and the staging smoke harness. Verification levels used below: **SOURCE** = read in code, **CONTRACT** = read or machine-parsed in the contract YAML, **DOC** = a project document says so, **BUILD** = a script I ran now (parsing only; no Flutter build, no test run, no network call, nothing written to the repo). The **Tests column is SOURCE-level** (test file references the method, path or provider). I did not execute the suite, because `tool/validate.*` is forbidden and a single-file run was not needed for a census.

Evidence generated this session (all under SCRATCH):
- `census_paths.py` maps every Dio call site in `lib/` to a (method, path) key and joins it against `ops_table.txt`. Output: 26 call sites, 26 distinct operations, all matched.
- `drift.py` and `drift2.py` resolve every `$ref` and diff request, parameters and response structure per consumed operation across the three pins, ignoring prose. `counts.py` produces the counts.
- Independent cross-check: `grep -rnE "\b_(dio|refreshDio|retryDio)\s*\.\s*(get|post|put|patch|delete|fetch|request|download)" lib` (excluding the mock) returns 27 hits. That is the 26 repository calls plus `core/network/interceptors/auth_interceptor.dart:109`, `_retryDio.fetch(options)`, which only replays the original request after a refresh.
- (added in verification) The verifier re-derived the load-bearing numbers independently (BUILD): its own PyYAML parse of the three pins reproduces 54 / 77 / 86 operations, 38 / 53 / 81 stable and 35 / 49 / 77 stable app-buildable with zero mismatches against `ops_table.txt` (stability, method+path, tag, consumers); its own `$ref`-resolving structural diff reproduces 0 of 26 changed (0df5cf4 to 65245be) and 2 of 26 changed (0df5cf4 to 2e5bb69); its Dio grep reproduces the 27 hits; the 26 mock route guards and the 13 contract-model bindings were re-counted. The corrector re-ran the tag counts, the 15-operation and 28-operation flip lists and the per-pin `x-behaviour-changed` enumeration from the three YAMLs and `ops_table.txt` (BUILD) and they match. Every test file named in the Tests column exists (BUILD, verifier `tests_exist.py`: 57 distinct test names resolved under `test/`; the two non-resolving tokens are `test/guards/contract_models_test`, which exists, and `tool/smoke/real_api_smoke_test`, which is outside `test/`).

**Headline.** The app calls exactly **26** contract operations (SOURCE + BUILD). All 26 are `x-stability: stable` at every pin (0df5cf4, 65245be, 2e5bb69), none is web-only, and nothing in `lib/` calls any other HTTP endpoint. At the 3.45 upstream head there are **77** stable app-buildable operations: **25 are implemented** (24 reach a screen, 1 is transparent token-refresh infrastructure), **1 is data-layer-only** (`getMyEntitlements`, never invoked at runtime) and **51 are not implemented**. All 5 draft operations and the 4 web-only operations are correctly untouched.

##### Legend

Paths are relative to `lib/features/` unless prefixed `lib/`.

| Symbol | Meaning |
|---|---|
| S / D / – | stable / draft / operation absent at that pin (3.28 = 0df5cf4 committed, 3.38 = 65245be working tree, 3.45 = 2e5bb69 upstream) |
| Test dirs | `auth`, `registration`, `profile`, `catalog`, `mistakes`, `quiz`, `flashcards`, `leaderboard`, `home`, `settings` = `test/features/<dir>/`; `dev` = `test/dev/`; `net` = `test/core/network/`; `sess` = `test/core/session/` |
| Wire test | the test drives the real repository class through a real Dio with a fake adapter |
| Mock | route served by `lib/dev/mock_backend.dart` (line shown); unserved paths answer a contract-shaped 404 (`mock_backend.dart:553-561`) |
| Smoke | `tool/smoke/real_api_smoke_test.dart` (manual, not in CI). `Y` = runs with no defines; `Y*` = only with `--dart-define=SMOKE_PHONE` for a registered number (or `SMOKE_REGISTER=true`), and the quiz loop additionally needs a non-empty catalog (`:571-612`, `:631`); `N` = not exercised |

##### Full census table (86 rows)

| Area (tag) | operationId | method path | 3.28 | 3.38 | 3.45 | Flutter repo method | Provider / notifier / bloc | Route / UI | Tests | Mock | Smoke | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| auth | requestOtp | POST /auth/otp/request | S | S | S | `auth/repository/auth_repository.dart:29` (call :31) | `loginProvider` `auth/notifier/login_notifier.dart:24`; `otpProvider` resend `otp_notifier.dart:184` | `/login` LoginScreen; `/login/otp` OtpScreen (resend) | `auth/login_validation_test`, `auth/otp_screen_test`, `registration/registration_router_flow_test` (mocked AuthRepository only; no wire test) | Y :156 | Y* :296 | IMPLEMENTED+UI |
| auth | verifyOtp | POST /auth/otp/verify | S | S | S | `auth_repository.dart:52` (call :58) | `otpProvider` `otp_notifier.dart:121` | `/login/otp` OtpScreen, then `/home` or `/register` | `auth/verify_fork_test`, `auth/otp_screen_test`, `auth/otp_success_router_test`, `auth/otp_elevation_test`, `auth/auth_result_test` (mocked repo; no wire test) | Y :163 | Y* :309 | IMPLEMENTED+UI (3.42 `403 account_banned`, openapi.yaml@2e5bb69:230-232, maps to generic copy: `auth/auth_error_copy.dart:12-24`, fall-through at :24) |
| auth | requestRedemptionSessionOtp | POST /auth/redemption-session/otp/request | S | S | S | NONE | – | – | – | N | N | WEB-ONLY correctly absent (`x-consumers: [web]`) |
| auth | verifyRedemptionSessionOtp | POST /auth/redemption-session/otp/verify | S | S | S | NONE | – | – | – | N | N | WEB-ONLY correctly absent |
| auth | completeRegistration | POST /auth/register | S | S | S | `registration/repository/registration_repository.dart:37` (call :39) | `registrationSubmitProvider` `registration/notifier/registration_submit_notifier.dart:89-90` | `/register/school` SchoolDetailScreen, `/register/university` UniversityDetailScreen (after `/register`, `/register/track`) | `registration/registration_repository_test` (wire), `registration_submit_notifier_test`, `register_body_test`, `school_detail_screen_test`, `university_detail_screen_test`, `registration_router_flow_test`, `dev/mock_backend_v11_test` | Y :198 | Y* body capture and incomplete-body probe :331-420; real POST only with `SMOKE_REGISTER` :432 | IMPLEMENTED+UI, partial: optional `inviteCode` never sent (`registration_draft.dart:17-18,41`, `school_registration.dart:96`, `university_registration.dart:78`) |
| auth | refreshTokens | POST /auth/refresh | S | S | S | `auth_repository.dart:81` (call :86, on bare `_refreshDio`) | refresher closure in `dioProvider` `lib/core/providers/core_providers.dart:43-47` driven by `AuthInterceptor` `lib/core/network/interceptors/auth_interceptor.dart:61-115` | no screen (transparent) | `net/auth_interceptor_test` (refresher faked; concurrent-401 test :184) | Y :223 (mock Dio has no AuthInterceptor) | Y* :680-682 (inside `refreshAndLogout`, :677) | IMPLEMENTED (infrastructure, no UI by design) |
| auth | logout | POST /auth/logout | S | S | S | `auth_repository.dart:107` (call :109) | `authControllerProvider.logout` `auth/notifier/auth_controller.dart:78` | `/account` and `/profile` ProfileScreen, logout row (`profile/screens/profile_screen.dart:323`) and confirm dialog (`_confirmLogout`, `:362-388`) | `auth/auth_controller_test`, `profile/profile_screen_test`, `sess/session_isolation_test` | Y :227 | Y* :694-696 | IMPLEMENTED+UI |
| auth | startRecovery | POST /auth/recovery/start | D | D | S | NONE | NONE | none (no lost-phone entry on Login or OTP) | – | N | N | NOT IMPLEMENTED |
| auth | verifyParentOtp | POST /auth/recovery/verify-parent | D | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| auth | submitNewPhone | POST /auth/recovery/new-phone | D | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| auth | confirmRecovery | POST /auth/recovery/confirm | D | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| reference | listCountries | GET /reference/countries | S | S | S | `registration/repository/reference_repository.dart:24` (call :26) | `countriesProvider` `registration/notifier/reference_providers.dart:50` | SchoolDetailScreen `registration/screens/school_detail_screen.dart:337,386` | `registration/reference_repository_test` (wire), `reference_providers_retry_test`, `school_detail_screen_test`, `dev/mock_backend_v11_test` | Y :483 | Y :207 | IMPLEMENTED+UI |
| reference | listGovernorates | GET /reference/countries/{countryCode}/governorates | S | S | S | `reference_repository.dart:44` (call :46) | `governoratesProvider` `reference_providers.dart:57` | SchoolDetailScreen `:181,404`; UniversityDetailScreen `:239` | `reference_repository_test`, `school_detail_screen_test`, `university_detail_screen_test`, `dev/mock_backend_v11_test` | Y :487-490 | Y :212 | IMPLEMENTED+UI |
| reference | listCities | GET /reference/cities | S | S | S | `reference_repository.dart:67` (call :72) | `citiesProvider` `reference_providers.dart:65` | SchoolDetailScreen `:215,419`; UniversityDetailScreen `:263,352` | `reference_repository_test`, both detail screen tests, `dev/mock_backend_v11_test` | Y :506 | Y :221,235 | IMPLEMENTED+UI |
| reference | searchSchools | GET /reference/schools | S | S | S | `reference_repository.dart:97` (call :105) | `schoolSearchProvider` `registration/notifier/school_search_notifier.dart:84,109,147` via `widgets/school_picker_field.dart:186`; `schoolsProvider` (`reference_providers.dart:77`) has no UI consumer | SchoolDetailScreen school picker | `registration/school_search_notifier_test`, `reference_repository_test`, `school_detail_screen_test` | Y :521 | Y :273 | IMPLEMENTED+UI |
| reference | listEducationSystems | GET /reference/education-systems | S | S | S | `reference_repository.dart:133` (call :135) | `educationSystemsProvider` `reference_providers.dart:89` | SchoolDetailScreen `:238,428` | `reference_repository_test`, `school_detail_screen_test` | Y :541 | Y :259 | IMPLEMENTED+UI |
| reference | listTerms | GET /reference/terms | – | S | S | NONE | – | – | – | N | N | WEB-ONLY correctly absent |
| reference | getLegalDocument | GET /reference/legal-documents/{document} | – | – | S | NONE | NONE | shell only: `/legal/privacy`, `/legal/terms` LegalDocumentScreen shows `legalNotPublished` (`account_shells/screens/legal_document_screen.dart:41-58`); Login links open placeholder `levelup.example` URLs (`auth/screens/login_screen.dart:46-48,123`) | – | N | N | NOT IMPLEMENTED (public, `security: []` at :828, text to be rendered in-app: openapi.yaml@2e5bb69:816-832). Request shape (added in verification): REQUIRED query `language` (`ar` or `en`, :831) and an optional `If-None-Match` header (:832, the only header parameter in the whole contract); response `contentMarkdown` is Markdown, `Cache-Control: public, max-age=3600` with a strong ETag, `404 legal_document_unavailable` when no Terms version is configured |
| reference | listUniversities | GET /reference/universities | S | S | S | `reference_repository.dart:153` (call :155) | `universitiesProvider` `reference_providers.dart:95` | UniversityDetailScreen `university_detail_screen.dart:81,155` | `reference_repository_test`, `university_detail_screen_test` | Y :545 | Y :278 | IMPLEMENTED+UI |
| reference | listDefaultAvatars | GET /reference/avatars | S | S | S | `reference_repository.dart:173` (call :175) | `avatarsProvider` `reference_providers.dart:119` | avatar sheet `profile/widgets/avatar_sheets.dart:352`, reached from `/profile/edit` | `profile/edit_profile_screen_test`, `dev/mock_backend_profile_test`, `reference_repository_test` | Y :549 | Y :268 | IMPLEMENTED+UI |
| profile | getMyProfile | GET /me | S | S | S | `profile/repository/profile_repository.dart:25` (call :27) | `meProvider` `profile/notifier/me_notifier.dart:39,48` | `/home` HomeScreen; `/account` and `/profile` ProfileScreen; `/profile/edit`; `/settings`; Top Student block; Leaderboard scope | `profile/profile_repository_test` (wire), `profile/me_notifier_test`, `home/home_screen_test`, `profile/profile_screen_test`, `dev/mock_backend_profile_test` | Y :234 | Y* :491 | IMPLEMENTED+UI |
| profile | updateMyProfile | PATCH /me | S | S | S | `profile_repository.dart:55` (call :57) | `editProfileProvider` `profile/notifier/edit_profile_notifier.dart:52` | `/profile/edit` (name, email tri-state, avatarId); `/settings` Rank section (leaderboardVisible, scoreHidden) `settings/screens/settings_screen.dart:279-304` | `profile/profile_repository_test`, `profile/profile_update_test`, `profile/edit_profile_screen_test`, `settings/settings_screen_test`, `dev/mock_backend_profile_test` | Y :246 | Y* :496-497 (no-op patch; its `say` heading is :494) | IMPLEMENTED+UI |
| profile | uploadCustomAvatar | PUT /me/avatar | D | D | D | NONE | NONE | disabled row `avatar_upload_photo` (`profile/widgets/avatar_sheets.dart:196-207`; TODO :196-200, row :201-207) | – | N | N | NOT IMPLEMENTED (draft; not buildable under the stable-only rule) |
| profile | removeCustomAvatar | DELETE /me/avatar | – | – | D | NONE | NONE | none (default-avatar choice goes through `PATCH /me avatarId`) | – | N | N | NOT IMPLEMENTED (draft) |
| profile | registerFcmToken | PUT /me/fcm-token | S | S | S | NONE | NONE | none; no `firebase_*` dependency (`pubspec.yaml` dependencies block); Settings notification toggles are disabled (`settings/screens/settings_screen.dart:344-420`) | – | N | N | NOT IMPLEMENTED |
| profile | getTermsAcceptance | GET /me/terms-acceptance | S | S | S | NONE | NONE | none (no Terms step in registration) | – | N | N | NOT IMPLEMENTED |
| profile | acceptTerms | POST /me/terms-acceptance | S | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED (prerequisite for photo uploads: `403 terms_acceptance_required`, openapi.yaml@2e5bb69:1025,2672) |
| profile | listMyNotifications | GET /me/notifications | S | S | S | NONE | NONE | `/message` MessagePlaceholderScreen (`shell/screens/tab_placeholder.dart`, router `app_router.dart:313-316`) | – | N | N | NOT IMPLEMENTED |
| profile | getUnreadNotificationCount | GET /me/notifications/unread-count | S | S | S | NONE | NONE | no call, but a UI seam exists and is hard-wired off (added in verification): `home/widgets/home_header.dart:23,36` `hasUnreadNotifications` defaults to `false` and no caller in `lib/` sets it (grep); its comment `:31-35` says "there is no notifications endpoint in the contract", which is false at every pin (stable at 0df5cf4, `openapi_0df5cf4.yaml:1030`) | – | N | N | NOT IMPLEMENTED (seam wired to constant `false`) |
| profile | markNotificationRead | POST /me/notifications/{notificationId}/read | S | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| profile | requestAccountDeletion | POST /me/deletion-request | S | S | S | NONE | NONE | none (no row in Profile or Settings) | – | N | N | NOT IMPLEMENTED (store blocker E-3, DOC) |
| profile | cancelAccountDeletion | DELETE /me/deletion-request | S | S | S | NONE | NONE | none; `pendingDeletion` parsed (`profile/models/student_profile.dart:77`) but never rendered; `isAccountPendingDeletion` (`lib/core/network/exceptions.dart:134`) is the seam | – | N | N | NOT IMPLEMENTED |
| profile | transferToUniversity | POST /me/track-transfer | – | D | S | NONE | NONE | Profile row "Go to Uni" (`profile/screens/profile_screen.dart:315`) opens a dialog whose confirm is disabled (`_showGoToUni` `:339-353`, `confirmEnabled: false` :349; doc comment :329-338) | – | N | N | NOT IMPLEMENTED (now stable at 3.45) |
| entitlements | getMyEntitlements | GET /me/entitlements | S | S | S | `profile_repository.dart:78` (call :80) | `entitlementsProvider` `me_notifier.dart:97` (resume listener :81); watched by nothing (only `lib/core/session/session_scope.dart:64` invalidates it) | none | `profile/profile_repository_test`, `profile/me_notifier_test` (:144-191), `sess/session_isolation_test`, `dev/mock_backend_profile_test` | Y :261 | Y* :505 | DATA-LAYER-ONLY (never invoked at runtime; DOC CR-02 agrees) |
| profile | getMyInvite | GET /me/invite | – | – | S | NONE | NONE | `/refer` ReferAFriendScreen shell, share control disabled (`account_shells/screens/refer_a_friend_screen.dart:31-52`) | – | N | N | NOT IMPLEMENTED |
| quiz | getMyMistakes | GET /me/mistakes | S | S | S | `mistakes/repository/mistakes_repository.dart:50` (call :52) | `mistakesOverviewProvider` `mistakes/notifier/mistakes_notifiers.dart:15,26` | `/learn/mistakes` MistakesOverviewScreen (entry `catalog/screens/subjects_screen.dart:166`) | `mistakes/mistakes_repository_test` (wire), `mistakes/mistakes_screens_test` | Y :350 (route untested) | N | IMPLEMENTED+UI |
| quiz | getMyMistakesForSubject | GET /me/mistakes/subjects/{subjectId} | S | S | S | `mistakes_repository.dart:82` (call :84) | `mistakesTreeProvider` `mistakes_notifiers.dart:91,110` | `/learn/mistakes/subject/:subjectId` (+ `/unit/:unitId`, `/chapter/:chapterId`) | `mistakes_repository_test`, `mistakes_screens_test` | Y :359-362 (untested) | N | IMPLEMENTED+UI |
| catalog | listSubjects | GET /catalog/subjects | S | S | S | `catalog/repository/catalog_repository.dart:24` (call :26) | `subjectsProvider` `catalog/notifier/subjects_notifier.dart:14,20` | `/learn` SubjectsScreen | `catalog/catalog_repository_test` (wire), `catalog_notifier_test`, `subjects_screen_test`, `dev/mock_backend_catalog_test` | Y :392 | Y* :567 | IMPLEMENTED+UI |
| catalog | getSubjectTree | GET /catalog/subjects/{subjectId}/tree | S | S | S | `catalog_repository.dart:51` (call :53) | `subjectTreeProvider` `catalog/notifier/subject_tree_notifier.dart:32,38` | `/learn/subject/:subjectId` (+ unit/chapter/lesson; lecture list; flashcard setup) | `catalog_repository_test`, `catalog_notifier_test`, `chapters_screen_test`, `lessons_screen_test`, `lectures_screen_test`, `dev/mock_backend_catalog_test` | Y :401-402 | Y* :586 | IMPLEMENTED+UI |
| catalog | listModules | GET /catalog/modules | D | S | S | NONE | NONE | none; `/learn` shows the flat subject list (university-only grouping, must keep an "All subjects" view: openapi.yaml@2e5bb69:1685-1700) | – | N | N | NOT IMPLEMENTED |
| quiz | getMyQuizSummary | GET /me/quiz-summary | – | S | S | NONE | NONE | the "Solved Questions" stat is omitted; Profile shows only the points card (`profile/screens/profile_screen.dart:181-188`; omission documented at :38). Figma frames that draw a Solved Questions card exist (docs/DESIGN_ISSUES.md #101, heading :4515: light `166:4416` / `309:7940`, dark `337:7433` / `349:12919`, RTL `549:21052` / `549:26384`) (added in verification) | – | N | N | NOT IMPLEMENTED |
| quiz | createQuiz | POST /quizzes | S | S | S | `quiz/repository/quiz_repository.dart:46` (call :52) | `quizSetupProvider` `quiz/notifier/quiz_setup_notifier.dart:50` | `/quiz/setup` then `/quiz/:quizId`; entries `catalog/screens/lessons_screen.dart:125`, `lectures_screen.dart:174`; only `mode: normal` is offered (`quiz/models/quiz_mode.dart:34`) | `quiz/quiz_repository_test` (wire), `quiz_setup_screen_test`, `quiz_models_test`, `dev/mock_backend_quiz_test` | Y :431 | Y* :631 | IMPLEMENTED+UI |
| quiz | listQuizHistory | GET /quizzes | D | D | S | NONE | NONE | none; Home "Continue Learning" is a ComingSoonSection (`home/screens/home_screen.dart`) | – | N | N | NOT IMPLEMENTED |
| quiz | getQuizReview | GET /quizzes/{quizId} | D | D | S | NONE | NONE | `/quiz/:quizId/result/review` renders in-memory `QuizReviewArgs` only (`quiz/models/quiz_review_args.dart:9-17`) | – | N | N | NOT IMPLEMENTED |
| quiz | submitAnswer | POST /quizzes/{quizId}/answers | S | S | S | `quiz_repository.dart:87` (call :93) | `QuizBloc` `quiz/bloc/quiz_bloc.dart:129` | `/quiz/:quizId` QuizScreen | `quiz/quiz_repository_test`, `quiz_bloc_test`, `quiz_screen_test`, `dev/mock_backend_quiz_test` | Y :435-436 | Y* :638 | IMPLEMENTED+UI |
| quiz | finishQuiz | POST /quizzes/{quizId}/finish | S | S | S | `quiz_repository.dart:115` (call :117) | `QuizBloc` `quiz_bloc.dart:340` | `/quiz/:quizId`, then `/quiz/:quizId/result` | `quiz_repository_test`, `quiz_bloc_test`, `quiz_screen_test`, `dev/mock_backend_quiz_test` | Y :440-441 | Y* :659 | IMPLEMENTED+UI |
| quiz | getExplanation | GET /questions/{questionId}/explanation | S | S | S | `quiz_repository.dart:149` (call :151) | `QuizBloc._poll` `quiz_bloc.dart:276` | AiExplanationPanel in QuizScreen (`quiz/screens/quiz_screen.dart:208`) | `quiz_repository_test`, `quiz_bloc_test`, `ai_explanation_panel_test`, `quiz_screen_test` | Y :445-448 | Y* :649 | IMPLEMENTED+UI |
| quiz | addFavorite | PUT /questions/{questionId}/favorite | D | D | S | NONE | NONE | none (`isFavorite` is parsed only, `quiz/models/quiz_question.dart:54`) | – | N | N | NOT IMPLEMENTED |
| quiz | removeFavorite | DELETE /questions/{questionId}/favorite | D | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| quiz | listFavorites | GET /me/favorites | D | D | S | NONE | NONE | Profile row `profile_row_favorites` is disabled (`profile_screen.dart:243-248`; its TODO at :240-242 still says the endpoint is draft, stale since 3.39) | – | N | N | NOT IMPLEMENTED |
| flashcards | getFlashcardsForLecture | GET /flashcards/lectures/{lectureId}/cards | S | S | S | `flashcards/repository/flashcards_repository.dart:67` (call :73) | `lectureFlashcardsProvider` `flashcards/notifier/lecture_flashcards_notifier.dart:119,171` | `/learn/subject/:subjectId/lecture/:lectureId/flashcards` and `/study` | `flashcards/flashcards_repository_test` (wire), `lecture_flashcards_notifier_test`, `flashcard_setup_screen_test`, `flashcard_study_screen_test`, `dev/mock_backend_flashcards_test` | Y :458-461 | N | IMPLEMENTED+UI |
| flashcards | setFlashcardSelfGrade | PUT /flashcards/cards/{flashcardId}/self-grade | S | S | S | `flashcards_repository.dart:106` (call :111) | `lectureFlashcardsProvider.notifier.setSelfGrade` `lecture_flashcards_notifier.dart:224-225` | `/study` FlashcardStudyScreen (`flashcard_study_screen.dart:393`) | same four files as above | Y :470-473 | N | IMPLEMENTED+UI |
| commerce | redeemSubscriptionCode | POST /subscription-codes/redemptions | S | S | S | NONE | – | – (purchase-silent; zero grep hits for redeem, redemption, subscription-codes in `lib/`) | – | N | N | WEB-ONLY correctly absent |
| leaderboard | getLeaderboard | GET /leaderboard | S | S | S | `leaderboard/repository/leaderboard_repository.dart:39` (call :50) | `leaderboardProvider` `leaderboard/notifier/leaderboard_notifier.dart:117,145` | `/leaderboard` LeaderboardScreen; Home Top Student block (`home/widgets/top_student_section.dart:53`) | `leaderboard/leaderboard_notifier_test`, `leaderboard_screen_test`, `home/top_student_section_test` (all with a mocked repo; NO wire test, NO model-decode test) | Y :289 | Y* :527,549 (+page 2) | IMPLEMENTED+UI |
| leaderboard | getMyRank | GET /leaderboard/me | S | S | S | NONE (deliberate: `leaderboard_repository.dart:11-15`) | NONE | none | – | N (`mock_backend.dart:276` says so) | N | NOT IMPLEMENTED by documented decision D-008 (`docs/DECISIONS.md:469-471`) |
| support | createSupportTicket | POST /support/tickets | D | D | S | NONE | NONE | `/support` CustomerSupportScreen shell, "Create Ticket" disabled (`account_shells/screens/customer_support_screen.dart:25-43`) | – | N | N | NOT IMPLEMENTED |
| support | listMySupportTickets | GET /support/tickets | D | D | S | NONE | NONE | same shell | – | N | N | NOT IMPLEMENTED |
| support | getMySupportTicket | GET /support/tickets/{ticketId} | D | D | S | NONE | NONE | same shell | – | N | N | NOT IMPLEMENTED |
| support | listMySupportTicketMessages | GET /support/tickets/{ticketId}/messages | D | D | S | NONE | NONE | same shell | – | N | N | NOT IMPLEMENTED |
| support | postMySupportTicketMessage | POST /support/tickets/{ticketId}/messages | D | D | S | NONE | NONE | same shell | – | N | N | NOT IMPLEMENTED |
| support | createSupportAttachmentUpload | POST /support/attachments | – | – | D | NONE | NONE | none | – | N | N | NOT IMPLEMENTED (draft) |
| support | completeSupportAttachment | POST /support/attachments/{attachmentId}/complete | – | – | D | NONE | NONE | none | – | N | N | NOT IMPLEMENTED (draft) |
| support | getMySupportAttachmentContent | GET /support/tickets/{ticketId}/attachments/{attachmentId}/content | – | – | D | NONE | NONE | none | – | N | N | NOT IMPLEMENTED (draft) |
| social | listMyFriends | GET /friends | – | S | S | NONE | NONE | `/friends` FriendsScreen shell with NO entry point (`app_router.dart:420-423`; `friends_screen.dart:9-21`) | – | N | N | NOT IMPLEMENTED |
| social | removeFriend | DELETE /friends/{studentId} | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | listFriendSuggestions | GET /friends/suggestions | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | lookupStudentByPhone | POST /friends/phone-lookup | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | listMyFriendRequests | GET /friend-requests | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | sendFriendRequest | POST /friend-requests | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | cancelFriendRequest | DELETE /friend-requests/{requestId} | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | acceptFriendRequest | POST /friend-requests/{requestId}/accept | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | declineFriendRequest | POST /friend-requests/{requestId}/decline | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | listMyBlocks | GET /blocks | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | blockStudent | POST /blocks | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | unblockStudent | DELETE /blocks/{studentId} | – | S | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | listConversations | GET /conversations | – | D | S | NONE | NONE | `/message` placeholder (no chat UI; no WebSocket/SignalR dependency in `pubspec.yaml`) | – | N | N | NOT IMPLEMENTED |
| chat | listConversationMessages | GET /conversations/{conversationId}/messages | – | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | sendChatMessage | POST /conversations/{conversationId}/messages | – | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | editChatMessage | PATCH /conversations/{conversationId}/messages/{messageId} | – | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | deleteChatMessage | DELETE /conversations/{conversationId}/messages/{messageId} | – | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | markConversationRead | PUT /conversations/{conversationId}/read | – | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | reportChatMessage | POST /message-reports | – | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | reportStudent | POST /student-reports | – | D | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | forwardQuestion | POST /conversations/{conversationId}/forwarded-questions | – | – | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| chat | answerForwardedQuestion | POST /conversations/{conversationId}/messages/{messageId}/answer | – | – | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |
| social | listMyFriendStreaks | GET /friend-streaks | – | – | S | NONE | NONE | none | – | N | N | NOT IMPLEMENTED |

Row count check (BUILD, `counts.py`; re-derived by the verifier and the corrector): 86 rows = 25 IMPLEMENTED + 1 DATA-LAYER-ONLY + 56 NOT IMPLEMENTED + 4 WEB-ONLY absent. Pin check: the table's stability columns equal `ops_table.txt` (86 rows), whose three-pin counts are stable 38 / 53 / 81, draft 16 / 24 / 5, and stable app-buildable 35 / 49 / 77.

##### Counts

**By stability at 3.45 (the upstream head)**

| Stability @3.45 | Ops | IMPLEMENTED | DATA-LAYER-ONLY | NOT IMPLEMENTED | WEB-ONLY absent | WEB-ONLY present (violation) |
|---|---|---|---|---|---|---|
| stable, app-buildable | 77 | 25 (24 with a screen, 1 infrastructure) | 1 | 51 | – | – |
| stable, web-only | 4 | – | – | – | 4 | 0 |
| draft | 5 | 0 | 0 | 5 | – | – |
| **Total** | **86** | **25** | **1** | **56** | **4** | **0** |

Of the 77 stable app-buildable operations, 25 (32.5 percent) ship and 26 (33.8 percent) have a repository method.

**By tag (all 86)**

| Tag | Ops | IMPLEMENTED | DATA-ONLY | NOT IMPL | WEB-absent |
|---|---|---|---|---|---|
| auth | 11 | 5 | – | 4 (recovery) | 2 |
| reference | 9 | 7 | – | 1 (getLegalDocument) | 1 (listTerms) |
| profile | 14 | 2 | – | 12 | – |
| entitlements | 1 | – | 1 | – | – |
| quiz | 12 | 6 | – | 6 | – |
| catalog | 3 | 2 | – | 1 (listModules) | – |
| flashcards | 2 | 2 | – | – | – |
| commerce | 1 | – | – | – | 1 |
| leaderboard | 2 | 1 | – | 1 (getMyRank) | – |
| support | 8 | – | – | 8 | – |
| social | 13 | – | – | 13 | – |
| chat | 10 | – | – | 10 | – |

**By pin (what each pin makes buildable versus consumed; BUILD)**

| Pin | Stable | Stable and mobile | Consumed | Stable, mobile, unconsumed | Draft |
|---|---|---|---|---|---|
| 0df5cf4 (3.28, committed) | 38 | 35 | 26 | 9 | 16 |
| 65245be (3.38, working tree) | 53 | 49 | 26 | 23 | 24 |
| 2e5bb69 (3.45, upstream) | 81 | 77 | 26 | 51 | 5 |

The 9 stable-mobile operations unconsumed at the committed pin are `registerFcmToken`, `getTermsAcceptance`, `acceptTerms`, `listMyNotifications`, `getUnreadNotificationCount`, `markNotificationRead`, `requestAccountDeletion`, `cancelAccountDeletion`, `getMyRank`. This agrees with `.ai/audits/current/release_readiness_reconciliation_2026-10-06.md` section 12 (DOC): "26 operations, all stable", nine unconsumed. Caveat (added in verification): the same paragraph (`:304`) asserts "Pin == upstream (no drift)", which does not hold on 2026-10-08 (committed pin 3.28.0-m1, working-tree pin 3.38.0-m1, upstream 3.45.0-m1; BUILD `ops_check.py`). Quote that document for the 26 / nine figures only, not for pin currency.

##### Focused list A: operations newly stable at 3.37 (stable at 65245be, not at 0df5cf4)

15 operations flipped; 14 are app-buildable. None is consumed.

| operationId | 3.28 | Status | What exists today | Note |
|---|---|---|---|---|
| listModules | D | NOT IMPLEMENTED | nothing; `/learn` is the flat subject list | University-only module grouping, school gets `[]`; the "All subjects" view must stay (openapi.yaml@2e5bb69:1685-1700). Whether a design frame exists is UNKNOWN: no `docs/*.md`, brief or DESIGN_ISSUES entry mentions a module picker (verifier grep; the only hits are contract notes in `docs/seif_fight.md:250,291`), and Figma was not opened |
| getMyQuizSummary | – | NOT IMPLEMENTED | "Solved Questions" stat deliberately omitted (S24, `docs/seif_fight.md:626`; `profile_screen.dart:181-188`) | Contract summary: "The Profile Solved Questions number" (openapi.yaml@2e5bb69:1731). Frames drawing the card exist (added in verification): `docs/DESIGN_ISSUES.md` #101 (heading :4515) lists `166:4416` / `309:7940` (light), `337:7433` / `349:12919` (dark), `549:21052` / `549:26384` (RTL) and records the owner ruling of 2026-09-27 "keep Points only", noting that Solved Questions (S24) and Rank (S25) "have no source" at that time. The source now exists, so wiring it means reopening that ruling, not commissioning a frame |
| listMyFriends, removeFriend, listFriendSuggestions, lookupStudentByPhone, listMyFriendRequests, sendFriendRequest, cancelFriendRequest, acceptFriendRequest, declineFriendRequest, listMyBlocks, blockStudent, unblockStudent (12) | – | NOT IMPLEMENTED | `/friends` shell, no entry point | The Profile hub draws no Friends row; creating one would be an invented entry point (`friends_screen.dart:9-21`). That file's comment still says the contract has "nothing behind it"; twelve social operations have been stable since 3.37 |
| listTerms | – | WEB-ONLY correctly absent | – | `x-consumers: [web]` |

##### Focused list B: operations newly stable at 3.39 to 3.45 (28; stable at 2e5bb69, not at 65245be)

Flip versions are from `contract-changelog.md` in the upstream clone (CONTRACT): line 107 (3.39, 22 operations), line 36 (3.43), line 16 (3.44). Every one is NOT IMPLEMENTED.

| Version | Operations | Existing UI or state | Blocking dependency visible in code or contract |
|---|---|---|---|
| 3.39 recovery (4) | startRecovery, verifyParentOtp, submitNewPhone, confirmRecovery | none | Login/OTP have no lost-phone entry; designs owed (DOC, handoff 3) |
| 3.39 chat (8) | listConversations, listConversationMessages, sendChatMessage, editChatMessage, deleteChatMessage, markConversationRead, reportChatMessage, reportStudent | `/message` placeholder | No WebSocket/SignalR package; the chat hub needs WebSockets only with `skipNegotiation: true` (changelog line 30, DOC) |
| 3.39 transfer (1) | transferToUniversity | "Go to Uni" dialog with confirm disabled (`profile_screen.dart:339-353`) | The contract needs university, faculty, study year and `acknowledgeIrreversible` (openapi.yaml@2e5bb69:1375-1383); the shell cannot supply them. Resolves handoff open question 8 |
| 3.39 review and favourites (4) | getQuizReview, addFavorite, removeFavorite, listFavorites | review screen uses in-memory args; favourites row disabled | S11/S14 in `docs/seif_fight.md` |
| 3.39 support (5) | createSupportTicket, listMySupportTickets, getMySupportTicket, listMySupportTicketMessages, postMySupportTicketMessage | `/support` shell | Photos need the 3 draft attachment operations and `acceptTerms` (`403 terms_acceptance_required`). Text-only is the shape the contract itself launches (contract-changelog.md@2e5bb69:113, "Text only for launch"); see "Support launch coupling" below |
| 3.43 (2) | getLegalDocument, listQuizHistory | `/legal/*` shell showing `legalNotPublished`; Home "Continue Learning" placeholder | Legal text arrives as Markdown (`contentMarkdown`); `pubspec.yaml` has no Markdown renderer. `language` query is required, `If-None-Match` is supported (openapi.yaml@2e5bb69:831-832) |
| 3.44 (4) | getMyInvite, forwardQuestion, answerForwardedQuestion, listMyFriendStreaks | `/refer` shell, share control disabled | Forwarding needs chat; streaks need friends |

##### Forbidden, invented and draft calls (expected empty; proved empty)

1. **Invented endpoints in `lib/`: none.** `census_paths.py` found 26 Dio call sites and every (method, path) joined to a contract operation (BUILD). The independent grep returned 27 hits, the extra one being the retry replay at `auth_interceptor.dart:109` (SOURCE). Query parameter names match the contract exactly: `listCities` (`countryCode`, `governorateId`: `reference_repository.dart:74-77`), `searchSchools` (`q`, `governorateId`, `cityId`, `cursor`, `limit`: `:107-113`), `getFlashcardsForLecture` (`cursor`, `pageSize`: `flashcards_repository.dart:75`), `getLeaderboard` (`scope`, `cursor`, `limit`: `leaderboard_repository.dart:52-56`) (CONTRACT, parameters read at both 0df5cf4 and 2e5bb69). The verifier also re-checked the wire enums (BUILD, `enum_check.py`): `createQuiz` mode `[normal, retakeWrong, favorites]`, length `[10, 30, 50]` and quizType, `setFlashcardSelfGrade` grade `[gotIt, again]`, `getLeaderboard` scope `[system, governorate, cohort, global]` all equal the Dart enums' `.name` (`quiz_mode.dart:23,44`, `quiz_type.dart:29`, `flashcard.dart:19`, `leaderboard_models.dart:18,50`).
2. **Only nine consumers of the Dio providers exist** (`dioProvider` / `refreshDioProvider` at `lib/core/providers/core_providers.dart:32,39`): the Auth, Catalog, Flashcards, Leaderboard, Mistakes, Profile, Quiz, Reference and Registration repositories (plus the `main_mock.dart:64` override). `pubspec.yaml` has no `http`, WebSocket, SignalR, Firebase, image picker, file picker or Markdown package, and `lib/` has no `HttpClient`. `Dio(` is constructed only at `dio_client.dart:28,46` and `dev/mock_backend.dart:47` (verifier). `url_launcher` is used once (`auth/screens/login_screen.dart:123`) for three placeholder `levelup.example` legal URLs (`:46-48`), which is not an API call. Network images load server-supplied URLs only (`cached_network_image`, `Image.network`).
3. **Calls to operations that are draft at the committed pin: none.** All 26 are `stable` at 0df5cf4 (the 3.28 column above; BUILD).
4. **Web-only operations present: none.** `grep -rniE "redemption|redeem|subscription-codes|reference/terms|listTerms" lib --include=*.dart` excluding `lib/l10n/` returns no lines at all (SOURCE). None of the 26 has `x-consumers: [web]`; `x-consumers` is `[mobile, web]` for the 9 public auth/reference operations and absent (mobile-only per openapi.yaml@2e5bb69:36-45) for the other 17 (verifier, CONTRACT).
5. **The dev mock invents nothing.** `lib/dev/mock_backend.dart` serves exactly the 26 operations (route guards at :156, 163, 198, 223, 227, 234, 246, 261, 289, 350, 362, 392, 402, 431, 436, 441, 448, 461, 473, 483, 490, 506, 521, 541, 545, 549) and answers any other path with a 404 (:553-561). Its header still cites pin `f462968` / 3.27.0-m1 (`:19-20`), which is a stale comment (DOC drift).
6. **Outside `lib/` (informational only).** `tool/smoke/real_api_smoke_test.dart:196-201` calls `GET {host}/health/version`, which is not a contract operation. It is a manual probe outside `/api/v1`, not shipped and not part of the suite. The smoke file's raw `POST /auth/register` incomplete-body probe (`:399-400`) is a contract operation.
7. **No guard enforces any of this.** `grep -rn "x-consumers|x-stability|web-only" test tool` finds nothing (re-run by the verifier over `{test,tool}/**`). `test/guards/contract_models_test.dart` binds 13 schemas for field presence only (`:73-156`; its own doc comment :29-45 says it checks `required` presence only): StudentProfile and five sub-objects, EntitlementState, the two subject trees and `Lecture`, AnswerResult, NamedRef, FlashcardCard. Nothing binds `LeaderboardEntry`, `Quiz`, `QuizSummary`, `Subject`, the Mistakes models, `AuthResult`, `TokenPair` or the other reference models. The reconciliation doc item M-1 (DOC) says the same.

##### Contract drift on the 26 consumed operations (CONTRACT, `drift.py`)

Request, parameters and response structure were diffed with `$ref` resolution and prose stripped. Zero structural diffs on all 26 between 0df5cf4 and 65245be, which confirms handoff item 7. Between 0df5cf4 and 2e5bb69, 24 of 26 have zero structural diffs. The two that changed are additive and none of the additions is `required` (verifier's independent diff, `drift_check.py`):

| Operation | Change 0df5cf4 to 2e5bb69 | App impact |
|---|---|---|
| verifyOtp | new `403 account_banned` response (openapi.yaml@2e5bb69:230-232); `AuthenticatedResult.inviteCodeApplied` added | 403 falls through to `genericError` (`auth/auth_error_copy.dart:12-24`); `AuthResult` ignores unknown keys (`auth/models/auth_result.dart`) |
| completeRegistration | optional `inviteCode` string on both request arms (openapi.yaml@2e5bb69:4144,4179; prose :390-391); `inviteCodeApplied` boolean on the 201 | Registration collects `referralCode` and discards it |

Prose-only changes on consumed operations (corrector's comparison of summary, description, response and parameter descriptions across the three pins, BUILD): `requestOtp` (SMS only) and `getLeaderboard` (blocked students excluded per caller; wire unchanged) differ already at 65245be; `updateMyProfile` (choosing `avatarId` replaces an active custom avatar) differs only at 2e5bb69; the other 21 consumed operations have identical prose at all three pins apart from the structural changes above.

`x-behaviour-changed` stamps: the four consumed operations that carry one (`listSubjects` and `getSubjectTree` 2.3.0-m1, `createQuiz` 3.11.0-m1, `getLeaderboard` 3.4.0-m1) carry the same stamp at all three pins, so no stamp on a consumed operation changed. Across the whole contract the set does move (corrector's PyYAML enumeration: 6 stamped operations at 0df5cf4, 6 at 65245be, 12 at 2e5bb69): `redeemSubscriptionCode` (web-only) moved 3.21.0-m1 to 3.32.0-m1 between 0df5cf4 and 65245be; `getMyRank` carries 3.9.0-m1 at every pin (unconsumed); 2e5bb69 adds stamps on five chat operations (`deleteChatMessage`, `editChatMessage`, `listConversationMessages`, `listConversations`, `reportChatMessage`: 3.43.0-m1) and on `forwardQuestion` (3.45.0-m1), none of them consumed, no app impact.

##### Test and smoke coverage gaps

- **Wire-level tests (real repository, real Dio, fake adapter) exist for 7 of 9 repositories:** catalog, flashcards, mistakes, profile, quiz, reference, registration. **Missing for `AuthRepository`** (requestOtp, verifyOtp, refreshTokens, logout: every auth test uses a mocked repository, and `net/auth_interceptor_test` fakes the refresher) **and `LeaderboardRepository`** (getLeaderboard, plus no `CursorPage<LeaderboardEntry>` decode test: that type appears only in hand-built fixtures, `leaderboard_fixtures.dart:26-32`). Each of those 5 operations is verified on the wire only by the manual smoke harness.
- **The smoke harness is not in CI** (`grep -rn smoke .github tool/*.ps1 tool/*.sh` returns nothing) and its header (`:1`) says it is "NOT part of the suite". It does not exercise `getMyMistakes`, `getMyMistakesForSubject`, `getFlashcardsForLecture` or `setFlashcardSelfGrade`. Everything past the 7 reference reads needs a registered staging number. Git history of the file (verified with `git log --date=short`): authored 2026-08-22 (`f3edc33`), extended 2026-08-23 (`dcd655b`, `b17b7de`), last touched 2026-09-19 (`f987f20`) and 2026-09-22 (`f685804`).
- **The mock's mistakes routes (`:350-362`) have no `test/dev` test.**
- (added in verification) `tool/verify_session_regression.ps1` exercises no API operation: it only runs `flutter test test/core/session/` twice, after temporarily replacing `lib/features/auth/notifier/auth_controller.dart` with HEAD's copy (restore in a `finally` block; script lines 1-40). It rewrites a `lib/` file, so it must not be run during this read-only audit.

##### Cross-cutting observations that touch the consumed operations

- **Entitlements are 403-driven, not read.** `entitlementsProvider` and its `AppLifecycleListener(onResume: refresh)` (`me_notifier.dart:78-95`; the listener is created inside `build()` at :81) are never instantiated because no widget watches the provider, so `GET /me/entitlements` is never requested in a shipped build. `StudentProfile.entitlements` is parsed (`student_profile.dart:61-62`) and read by no screen.
- **Referral and the registration contradiction.** Contract 3.44 made `inviteCode` stable and optional; the app already collects `referralCode` and drops it. Figma (500 points to both) versus backend (10 to the inviter) is a product conflict (handoff 2) and is not resolved here.
- **`getMyRank` and the 3.45 text.** The contract calls it "a separate optional read" (openapi.yaml@2e5bb69:2515-2518) and "the endpoint to call for the caller's own standing" below the 200-row display bound (:2589-2592). The app's refusal to call it is a recorded owner decision, not a violation (`docs/DECISIONS.md:469-471`, `docs/D008_LEADERBOARD_AUDIT.md:42-44`; the in-code statement is the doc comment at `leaderboard_repository.dart:11-15`).
- **`Accept: application/json`.** The contract's `ProblemDetails` text says to send it (openapi.yaml@2e5bb69:3881-3890). `lib/core/network/dio_client.dart:19` sets only `Content-Type`. `ErrorInterceptor` already tolerates a body without `code` (maps to `'unknown'`, `error_interceptor.dart:25-27`), so the gap is the missing header, not a crash path.
- **Account deletion** is the one place a stable operation pair is unconsumed while the app already receives its side effects: `403 account_pending_deletion` renders copy and withholds Retry, with no cancel screen (`exceptions.dart:96-135`; the file itself says the cancel-screen route "is NOT implemented, because that screen does not exist").
- **`session_superseded` already has a working baseline (added in verification).** Any endpoint answering `401 session_superseded` forces a logout with `LogoutReason.supersededOtherDevice` and no refresh attempt (`auth_interceptor.dart:74-78`, and again on the refresh path :149-150), and the router redirect lands the student on `/login` (`app_router.dart:88-91`; `exceptions.dart:34-35`). It is covered by `test/core/network/auth_interceptor_test.dart:130`, `test/core/router/app_router_test.dart:119` and `test/core/session/session_isolation_test.dart:252` (SOURCE). The contract declares the code at openapi.yaml@2e5bb69:58-59 and on 10+ operations. What the handoff lists as "Logged-in-on-another-device" (backend-built, no design) is therefore a missing pop-up design and copy, not missing behaviour.
- **Support launch coupling (added in verification; qualified by the corrector).** The upstream changelog says the three support-photo operations "stay `draft` until they are served on staging. Text-only support is unchanged." (contract-changelog.md@2e5bb69:79): that is the stated promotion trigger for the five operations still draft. The same changelog also holds an older line that "student support does not launch until attachments ship (adr-187)" (:149, inside the 2026-10-06 / 3.37 entry listing what stayed draft that day; originally :222, 2026-09-25). The later 3.39 entry (2026-10-07, :107-113) flipped all five core support operations to stable with "Text only for launch: there is still no attachment field. Attachments arrive later as an ADDITIVE change ... do not reserve UI that depends on them yet" (:113), and 3.42 then added optional `attachmentIds` to the stable `createSupportTicket` and `postMySupportTicketMessage` (openapi.yaml@2e5bb69:2667, :2809). So the contract's most recent word supports a text-only support wave first; whether the PRODUCT launches student support before photos ship is a release-scope decision (roadmap DR-25), which the contract does not settle.

##### Stale in-code contract comments (added in verification)

22 `TODO(contract)` lines exist in `lib/` (grep, reproduced by the corrector). The census rows above list operations; these comments are what the next wave's author reads first, and several are now false (SOURCE comments checked against the stability columns, CONTRACT):

| Location | What it says | Truth |
|---|---|---|
| `home/widgets/home_header.dart:31-35` (flag at :23,36) | bell dot permanently `false`: "there is no notifications endpoint in the contract" | False at the committed pin as well: `getUnreadNotificationCount`, `listMyNotifications` and `markNotificationRead` are stable at 0df5cf4 (`openapi_0df5cf4.yaml:1030` for the count). `docs/DESIGN_ISSUES.md` #41 (:1008, "dot gated") records the same open ask to Seif |
| `core/router/app_router.dart:369,446`, `quiz/models/quiz_review_args.dart:18`, `quiz/screens/quiz_review_screen.dart:24`, `quiz/screens/quiz_result_screen.dart:160`, ARB description `lib/l10n/app_en.arb:418` (generated into `app_localizations.dart:1067`) | `GET /quizzes/{quizId}` is draft | `getQuizReview` is stable at 3.45 (flipped 3.39) |
| `profile/screens/profile_screen.dart:240-242`, `quiz/models/quiz_mode.dart:29`, `quiz/models/quiz_question.dart:48` | favourites endpoints are draft | `addFavorite`, `removeFavorite`, `listFavorites` stable at 3.45 |
| `profile_screen.dart:331` (S31) | there is no track-switch endpoint | `transferToUniversity` is stable at 3.45 (draft at 3.38). The comment's deeper stated blocker (what happens to the school points pool on a switch) was not re-evaluated |
| `account_shells/screens/friends_screen.dart:9-13` (S36) | the contract has nothing behind the Friends frame | 12 social operations stable since 3.37 |
| `account_shells/screens/refer_a_friend_screen.dart:9`, `profile_screen.dart:262`, `registration/models/registration_draft.dart:18`, `registration/screens/signup_identity_screen.dart:92` (S5) | no referral endpoint / no backend field | `getMyInvite` and optional `inviteCode` stable at 3.44 |
| `account_shells/screens/customer_support_screen.dart:9`, `profile_screen.dart:274` (S33) | support "has no endpoint of any kind" | 5 support operations stable (3.39) |
| `core/network/interceptors/error_interceptor.dart:8-9` | "full mapping of error-codes.md codes lands per-feature" | Listed as an open handoff item; this census did not evaluate whether it is stale |

Still true at 3.45: `profile/widgets/avatar_sheets.dart:196-197`, `profile/models/profile_update.dart:44`, `profile/screens/edit_profile_screen.dart:35,46` (`uploadCustomAvatar` is draft, openapi.yaml@2e5bb69:981); `settings/screens/settings_screen.dart:343` (no preference-persisting operation exists among the 86; `registerFcmToken` registers a device, not a choice); `core/config/app_config.dart:46` (contract `servers:` lists staging only, openapi.yaml@2e5bb69:107-108).

##### Unknowns, owner decisions and newly discovered items (corrected)

**Unknowns (UNKNOWN + what was searched).**
- Whether staging has deployed the routes that became stable at 3.39 to 3.45: no network probe was made. DOC-level only: Seif's changelog says the 3.39 set is "deployed to staging" (contract-changelog.md@2e5bb69:108) and that staging served `11ab701` with `getLegalDocument` answering 200 at 3.43 (:38). These are the vendor's statements, not independently probed, and no equivalent statement was checked for the 3.44 and 3.45 flips.
- DEVICE behaviour of any consumed operation in this session: nothing was run on the Pixel 8; device status is DOC-only.
- Test execution results: the Tests column is SOURCE-level; I did not run the suite and cannot state any test passes now.
- Whether Figma frames exist for every missing screen (friends, chat, support threads, recovery, deletion, terms, inbox, modules): Figma was not opened. DOC knows of the Solved Questions frames (DESIGN_ISSUES #101) and records none for a module picker.
- Whether the production host or production Firebase files exist: `AppConfig` prod base URL is still `https://TBD.example/api/v1` (`app_config.dart:54`) and the contract `servers:` lists staging only (:107-108).
- The exact per-operation error-code handling needed for the 51 unbuilt operations beyond what the contract response lists was not derived here.
- RESOLVED (formerly unknown 5): `tool/verify_session_regression.ps1` exercises no operation (see Test and smoke coverage gaps).

**Owner decisions (not for Claude).**
- Release-1 feature scope per contracted area (roadmap DR-25, open): which of the 51 unconsumed stable operations ship, which are deferred, which go to Seif as change requests. This includes whether student support launches text-only or waits for photos (adr-187 versus the 3.39 "Text only for launch" line).
- Which contract pin to build against (roadmap DR-23, open): land 65245be, or re-vendor to 2e5bb69 or later.
- Whether to reopen D-008 and consume `getMyRank`, so students below the 200-row board see their own rank.
- Referral: whether to send the collected `referralCode` as `inviteCode` at registration and what the reward is (Figma 500 to both versus backend 10 to the inviter); tracked, not chosen here.
- Account deletion confirm copy: the contract-mandated text contains "paid" twice and "refund" (openapi.yaml:1083-1095) while the contract's own app rule bans purchase vocabulary (:2080-2081); reconciliation O-2 / DR-03.
- Adding dependencies that change privacy declarations or store forms: Firebase/FCM (`registerFcmToken`), a WebSocket/SignalR client (chat), an image picker (avatar and support photos), a Markdown renderer (`getLegalDocument`).
- Legal documents: render `getLegalDocument` in-app (public, Markdown) versus keep external hosted pages; Login currently links to `levelup.example` placeholders.
- Track transfer: build `transferToUniversity` now that it is stable, including irreversible double-confirm copy and the university, faculty and study-year pickers (needs design and copy).
- Mistakes replay and favourites quiz modes (`retakeWrong`, `favorites`) and the Home Learning Tools tiles: whether they ship in release 1.
- Whether the Message tab ships as an inbox on the three stable notification operations (which also feeds the Home bell seam) or is hidden for release 1.
- Copy for the new `account_banned` sign-in refusal (AR and EN) and any wording of terms acceptance.
- Whether to reopen the 2026-09-27 "keep Points only" ruling (DESIGN_ISSUES #101) now that `getMyQuizSummary` supplies the missing source.

**Newly discovered** (all reflected in the body above): `transferToUniversity` stable at 3.45; five photo operations still draft; 24 of 26 consumed operations structurally unchanged to 3.45; `getMyEntitlements` never called at runtime; referral code collected and dropped; no wire tests for Auth or Leaderboard repositories; no guard on stability or consumers; `getLegalDocument` is public Markdown with a required `language`; `403 terms_acceptance_required` gates photo uploads; mock header cites f462968; `Accept: application/json` not sent; stale in-code contract comments including a Home bell seam that contradicts the committed pin; a working `session_superseded` baseline.

### Open questions, consolidated (report sections 14–16) and decisions reserved for the owner

**Basis, 2026-10-08.**
- **Contract:** I re-ran `git ls-remote` at 19:01 UTC. Upstream contract HEAD is still `eddb6ac` (3.46.0-m1). My own PyYAML count of `openapi.yaml@eddb6ac`:
  - 86 operations: 86 stable, 0 draft.
  - 4 are web-only (`requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `redeemSubscriptionCode`, `listTerms`), which leaves **82 app-buildable**.
  - 19 are public (`security: []`); none of them is a support operation.
  - `servers:` lists staging only (CONTRACT).
- **Repo:** the committed pin is `0df5cf4` (3.28.0-m1). The working tree holds `65245be` (3.38.0-m1), uncommitted.
- **Inputs read:** `cor_*.json` remaining and resolved questions, `inv_*.json` decisions and unknowns, `ver_*.json` answerable questions, all 12 dimensions.
- **Source tags used below:** git, contract (contract_delta), upload-push, census (api_census), learning, account, social, design, env-push, ci, store, roadmap.

**How I re-tiered:**
- Every question that assumed operations were still draft, or that the stable-only rule blocks photos, avatars or track transfer, is **dropped or rewritten**. At 3.46 nothing is draft (see AA-1 to AA-4).
- **The pin question stays BLOCKING (B-1).** It is rewritten: the choice is now 3.38 versus `eddb6ac` or later, not 3.38 versus `2e5bb69`.
- **Push in release 1 and the Message tab are folded into the scope matrix (B-2).** env-push had push as BLOCKING and roadmap had the Message tab as IMPORTANT. Both change the workflow only through scope.
- **The protocol and model-role question moves up to BLOCKING (B-3).** The owner's new brief clashes with a rule that is recorded in the repo.
- **The referral reward is IMPORTANT.** Sections disagreed (IMPORTANT versus NON-BLOCKING); it is IMPORTANT because the Refer screen and the Sign Up_1 copy cannot ship without it.
- **NON-BLOCKING:** `Retry-After`, the contract wording errors, and the two self-contradictions in the Terms wording. Each has a default that stays within the contract.

---

## 14. Blocking questions

There are three. Without these answers, the workflow's scope, structure or order would be guesswork.

### B-1 · Which contract pin does the completion workflow build against? (Mostafa; Seif answers I-1)

**Question, ready to send:**
> Upstream is now `eddb6ac` = 3.46.0-m1. All 86 operations are stable and 82 can be built by the app.
>
> The working tree still holds the 3.38.0-m1 re-vendor (`65245be`). You asked for it on 2026-10-07 but did not ask to commit it. The committed pin is `0df5cf4` (3.28.0-m1). Which do you want?
>
> - (a) Commit `65245be` as its own contract commit, after fixing the wrong "CRLF" sentence at `contract/SOURCE.md:17`. Then re-vendor to the upstream HEAD of that day in a second contract-only commit.
> - (b) Discard the 3.38 working copy, keeping its SOURCE.md prose, and re-vendor straight to the upstream HEAD of that day.
> - (c) Wait for a release-1 freeze version from Seif (I-1).
>
> Also: should every wave start with `git ls-remote` and a re-census (a moving pin)? Or is the pin frozen for the whole workflow once it is vendored?

**Why this blocks planning:**
- The number of operations the app can build is 35 at `0df5cf4`, 49 at `65245be` and 82 at `eddb6ac`.
- Some contract content only exists from a given version:
  - the push section, from 3.43;
  - `403 account_banned` on the `verifyOtp` the app already calls, from 3.42 (a BEHAVIOURAL change);
  - photos and avatars, from 3.46.
- Without the pin, Wave 0's commit sequence and every wave's endpoint list are guesses.
- Upstream moved 8 minor versions in about 28 hours.
- Project rules say a re-vendor is its own commit and nothing is committed unless the owner asks (`implementation_waves.md:28-29`).

**Evidence searched:**
- `contract/SOURCE.md` (HEAD and working tree).
- Memory upstream-contract-3-10-unlocks: "owner asked to re-vendor, not to commit".
- Roadmap DR-23, and gate G-03 (pin equals upstream HEAD at release candidate).
- SCRATCH `ops_table.txt`.
- `git ls-remote` at 19:01 UTC.
- Precedent contract-only commits `03fd7cf` and `aeb22fc`.
- No document names a target pin or a rule for skipping intermediate pins.

**If unanswered:** only a provisional plan is possible. Wave 0 would be an owner-gated, contract-only re-vendor to the upstream HEAD of that day, followed by a re-census, and every later wave would be flagged pin-dependent.

**Blocks:** Wave 0 (contract) and every feature wave. The push, photo, avatar, ban-handling, legal and chat waves cannot be specified at 3.38.

**Raised by:** git, contract, upload-push, census, learning, account, social, store, roadmap; also in the ci and env-push owner decisions.

### B-2 · What is in release 1? (Mostafa, with the client)

**Question, ready to send:**
> Please mark each row **SHIP**, **DEFER** (recorded in `docs/DECISIONS.md`) or **CHANGE REQUEST TO SEIF**. Rows 0a and 0b are already required, so they are not asked.
>
> - 0a · Account deletion and cancel: store-mandatory (E-3).
> - 0b · Banned-account handling: required once the pin is 3.42 or later, because `verifyOtp` is already consumed.
> - 1 · Terms acceptance step. The in-app legal viewer is already what the contract says to build.
> - 2 · Lost-phone recovery (4 operations).
> - 3 · Track transfer to University.
> - 4 · Friends, friend requests, blocks and reports.
> - 5 · Chat: text, forwarded-question cards, friend streaks and the SignalR hub.
> - 6 · Support tickets, text.
> - 7 · Support photos.
> - 8 · Custom avatar upload.
> - 9 · Refer a Friend, plus sending the invite code at sign-up.
> - 10 · Notification inbox.
> - 11 · **Push notifications** (Firebase/FCM, permission, tap routing). This also records store rubric item 8a.
> - 12 · Quiz history, review from history, favourites and the quiz star.
> - 13 · Mistakes replay (`retakeWrong`) and the favourites quiz mode.
> - 14 · University module picker (`listModules`).
> - 15 · **The Message tab:** hide it, make it the inbox, make it chat, or inbox and chat.
> - 16 · Inert surfaces: hide or keep. These are the four notification toggles that save nothing, the Coming-soon Home cards, the Refer, Support and Friends shells, and the referral field that is never sent.

**Recommendations already on record, so the owner can answer quickly** (none is a ruling):
- O-1 / DR-01: hide the Message tab.
- O-6 / DR-05: hide the inert surfaces.
- DR-11: no push in v1. This was written before the 3.43 push contract.
- DR-19: keep the Mistakes replay inert.

**Why this blocks planning:**
- No release scope has been ratified: DR-25 and MI-022 are open, and nothing in D-001…D-021 covers it.
- About 26 operations are consumed today against 82 that could be built.
- Scope fixes the wave count and order and the P0 list.
- It decides which UGC, minors and privacy duties apply.
- It decides whether Firebase, APNs, `POST_NOTIFICATIONS`, Data Safety and privacy-manifest work exists at all.
- It decides the shell layout (E-5).

**Evidence searched:**
- `docs/DECISIONS.md`.
- Roadmap DR-01, DR-05, DR-11, DR-19, DR-25.
- `docs/STORE_READINESS_RUBRIC.md:69` (item 8a ❌).
- `docs/STORE_READINESS.md:245-256` (§14 item 7).
- Reconciliation O-1 (`:183`) and O-6.
- `wave_state.md:144-148`, `:1836`.
- `notification_inbox_3_28_investigation.md:345-349`.

**If unanswered:** only work that does not depend on scope can be sequenced:
- Wave 0 (contract);
- Env Waves 2–4;
- store blockers E-1…E-8, including deletion and the ban screen;
- the conformance fixes: the `Accept` header and global 403 routing.

No feature wave can be formulated.

**Blocks:** every feature track. Row 11 also gates the Firebase and APNs work; row 15 also gates the shell.

**Raised by:** census, social, design, env-push, store, roadmap; also in the learning, account, contract and upload-push decisions.

### B-3 · Which protocol governs the completion workflow? (Mostafa)

**Question, ready to send:**
> The 22-wave FORMULATE list is used up. The control rules still in force (`wave_state.md:92-94`) are:
> - nothing advances without your NEXT, WALK or FORMULATE;
> - one screen per wave;
> - "Subagents: Sonnet only";
> - a checkpoint at about 40% context;
> - nothing is committed unless you ask.
>
> Your new brief asks for Opus orchestration, Sonnet execution and Fable audit. Please rule on four points:
>
> - (a) Does that model split replace "Subagents: Sonnet only"? A Fable auditor run as a subagent is not Sonnet. Or should Fable stay the separate hand-off of `AUDIT_PROTOCOL.md`? Either way, is a Fable audit required at every wave close, or only for release candidates?
> - (b) How should work that is not one screen be divided into waves?
>   - Multi-screen features: deletion request/confirm/cancel; chat list, conversation, report and block; support list, ticket and new ticket; the recovery steps.
>   - Work with no screen: the contract re-vendor, Env Waves 2–4, the E-4 iOS fix, global 403 `account_pending_deletion` / `account_banned` routing, the `Accept` header, store prerequisites.
>   - Should these be exceptions to one-screen-per-wave, or a new kind of wave?
> - (c) Commit policy: a focused commit per wave, as the Env chapter does, or only on your request, as the API→UI waves did?
> - (d) For new surfaces, should WALKs run against staging with seeded accounts? Or must the mock backend be extended first? It covers none of the 3.39–3.46 endpoints, and the documented WALK build command has been stale since `2dfd969` because it now needs `--flavor`.

**Why this blocks planning:**
- FORMULATE's output *is* the wave structure.
- The recorded rules cannot express about half the remaining work.
- The brief's model roles clash with a recorded rule.
- Only the owner can change the protocol.

**Evidence searched:**
- `wave_state.md:12`, `:92-94`, `:1836-1837`.
- `implementation_waves.md:5-8`, `:20`, `:28-29`.
- `env_chapter_state.md:6-7`.
- `AGENT_WORKFLOW.md:17-57`.
- `AUDIT_PROTOCOL.md:121-149`.
- `android/app/build.gradle.kts:119-131`.
- Roadmap protocol-collision list items 1–6.

**If unanswered:** the stricter existing rules apply:
- one owner-gated wave at a time;
- Sonnet-only subagents, so Fable audits run outside subagents;
- no commits without a request.

Work that is not a screen then has no wave shape.

**Blocks:** the structure of every wave, starting with Wave 0 and the Env waves.

**Raised by:** roadmap; also the ci decision on Fable cadence and the orchestrator facts.

---

## 15. Important questions

The workflow can be drafted without these, but the named waves stay blocked until they are answered.

### Questions for Seif

**I-1 · Contract freeze for release 1** (raised by contract, git, census)
- **Ask:** "Is there a contract version or date that freezes the mobile contract for release 1? Is `eddb6ac` (3.46.0-m1) the intended mobile target? Will any minor version before release change an operation the app already consumes?"
- **Why:** the contract went from 3.38 to 3.46 in about 28 hours, and 3.39 alone made 22 operations stable. B-1 option (c) depends on this answer.
- **Evidence searched:** the only "freeze" hit in `contract-changelog@eddb6ac` is `:549`, about `totalPoints`. A grep of `docs/*.md` for a contract freeze finds nothing.
- **If unanswered:** re-vendor and re-census at the start of every wave; the pin stays provisional.
- **Blocks:** the release-candidate gate G-03, and any wave that lands after a contract move.

**I-2 · Production host and reviewer access** (Q-B3, parts 1–2; raised by contract, store, env-push, census)
- **Ask:** "When will the production host appear in `openapi.yaml` `servers:`? The planned host is `api.level-upworld.com` (`ENVIRONMENTS.md:397-400`). Is `/hubs/chat` on the same host, and will `realtime.md` say so? When will production reviewer numbers with a fixed OTP exist for App Review and Play review (E-6)?"
- **Why:** the production base URL is still the fail-closed placeholder `https://TBD.example/api/v1` (`lib/core/config/app_config.dart:54`). E-1 and E-6 gate every store review.
- **Evidence searched:** `openapi@eddb6ac` `servers:` (staging only); D-021 Q5; reconciliation `:207`; 0 hits for "production host" in `seif_fight.md`.
- **If unanswered:** staging-side waves continue, but the production flavor and the release waves cannot finish.
- **Blocks:** the production config in Env Wave 2, the release candidate, store submission, and device checks against production.

**I-3 · What happens to the FCM token at sign-out** (raised by contract, upload-push, env-push, store)
- **Ask:** "`registerFcmToken` keeps one token per student, and there is no delete operation (changelog `:327`, `:331`). Does any of these detach that token from the previous student: `POST /auth/logout`; a `session_superseded` eviction; another student calling `registerFcmToken` with the same device token? If not, will an unregister operation be added, or should the app delete its local FCM token at sign-out?"
- **Why:** family phones are shared and many users are minors. A signed-out student's pushes could reach the next student.
- **Evidence searched:** `openapi@eddb6ac:451-461` (logout says nothing about the token), `:1060-1082`; `realtime.md:108`. No open item exists in `seif_fight.md` (fcm appears only at `:123` and in S28).
- **If unanswered:** push sign-out behaviour stays undefined and the risk is recorded. Push cannot be switched on.
- **Blocks:** the push wave, if B-2 row 11 is SHIP.

**I-4 · How a signed-out student reaches Support** (Seif for the channel, Mostafa for the product; raised by contract, upload-push, account, social, design, roadmap)
- **Ask, Seif:** "A banned student gets `403 account_banned` after entering a correct code and is told to 'contact Support'. `recovery_unavailable` also says 'route to the support path'. But every `/support/*` operation needs a bearer token, and none of the 19 public operations is a support operation. Which signed-out channel should the app point to: an anonymous contact operation, or a contact outside the app?"
- **Ask, Mostafa:** "Which concrete phone number, e-mail, WhatsApp contact or web form may the app show? Do you approve the contract's suggested EN/AR ban wording? The contract says the client owns those strings."
- **Why:** the contract says to build a dedicated banned screen (changelog@eddb6ac `:78`). Without a destination that screen is a dead end. The mailto-or-WhatsApp question at `seif_fight.md:1318` was never answered.
- **Evidence searched:** `error-codes.md@eddb6ac:51`; `openapi@eddb6ac:1181`; my own public-operation list; `STORE_READINESS.md` §15 ("Support channel real"). No support URL or e-mail exists in the repo.
- **If unanswered:** a ban screen with copy and no action. The listing's support contact is also missing (see I-10).
- **Blocks:** the ban-handling wave, the recovery failure path, the store listing.

**I-5 · `UniversityRegistration.inviteCode` wording** (raised by contract, account, social)
- **Ask:** "At 3.46, `UniversityRegistration.inviteCode` still says 'this field is draft — send it only once it is stable' (`openapi.yaml:4182`). `SchoolRegistration.inviteCode` (`:4147`), `completeRegistration` (`:390`) and the 3.44 entry all say it has been stable since 3.44.0-m1. May the University registration body carry `inviteCode`?"
- **Why:** `completeRegistration` is already consumed, and an older backend refuses unknown properties with `validation_failed`.
- **If unanswered:** do not send `inviteCode` for University registrations. The School path is unaffected.
- **Blocks:** Refer-at-sign-up for University students.

**I-6 · Staging test setup** (raised by learning, ci, social, roadmap, upload-push)
- **Ask:**
  - (a) Chasing S37 ask 2 and R-8: "Please set up a University-track whitelisted account on a released term, with questions, lecture flashcards and at least one wrong answer."
  - (b) "For two or more `+20100000000xx` numbers, please create an accepted friendship, a pending friend request, an open conversation and an open support ticket."
  - (c) "Is a Terms version configured on staging (`currentVersion` not null), and will production have one?"
  - (d) "When will you record the staging push verification and switch delivery on (`realtime.md:80`)?"
- **Why:**
  - The University learning screens and every surface added after 3.28 have never run against a real server, and the mock backend lacks them.
  - The photo 403 and the Terms gate do nothing while `currentVersion` is null.
  - Push taps cannot be checked on a device while delivery is off.
- **Evidence searched:** `RISKS.md:118-126`; `seif_fight.md` S37 (`:639`) and S44; `openapi.yaml:96` (defines the numbers, not the data); `tool/smoke/real_api_smoke_test.dart` (a single `SMOKE_PHONE`); `openapi:1087-1096`.
- **If unanswered:**
  - University surfaces are capped at BUILD plus mock-backed DEVICE.
  - Social and support surfaces stay at SOURCE and unit-test level.
  - Push stays at BUILD.
- **Blocks:** device checks for University learning, friends, chat, support, Terms, photos and push.

**I-7 · Progress, Daily Tasks and a personal streak** (Seif; the designer and Mostafa for how frames map to data; raised by learning, design, account)
- **Ask:** "Does the backend have, or plan, an operation for any of these?
  - The Progress screen: frames `309:9671` / `310:10166`, the Profile 'your progress' row, S32.
  - Daily Tasks and their XP.
  - A personal daily streak: Home '12 days Streak' `308:4203` and the 'Daily Streak' inbox row.

  Or do `listQuizHistory` and `getMyQuizSummary` cover the Progress screen?"
- **Why:** 3.46 has only the friend-pair streak and one quiz-summary number. The server is authoritative; nothing may be computed in the app.
- **Evidence searched:** grep of `openapi`, the changelog, `realtime.md` and `error-codes.md` at `eddb6ac` for streak, progress, daily and task; `realtime.md:10` (the streaks hub was folded into chat); `seif_fight` S32.
- **If unanswered:** Progress, Daily Tasks, the personal streak and Home "Continue Learning" stay placeholders, or are hidden per B-2 row 16.
- **Blocks:** the Progress, Daily Tasks and Home streak / Continue Learning waves.

**I-8 · Deletion confirm wording and frames** (Seif; Mostafa; the designer; raised by account, design, store, roadmap, census)
- **Ask, Seif (this is Q-B2, never filed):** "The deletion confirm text you mandate says an active **paid** subscription is forfeited with no partial **refund** (`openapi.yaml:1284-1286`). adr-049 §3 keeps the app purchase-silent. Will you publish a version the app can safely show?"
- **Ask, the designer:** frames for the request, confirm and cancel screens, and for the `account_pending_deletion` state.
- **Why:**
  - Account deletion is store-mandatory (Apple 5.1.1(v); Play) and is the P0 item E-3.
  - The contract's literal banned-word list (`:2449-2451`: price, buy, purchase, payment, provider) does not include "paid" or "refund". The conflict is with the intent of adr-049 §3.
- **Evidence searched:** reconciliation O-2 (`:184`, option (a) recommended) and Q-B2 (`:206`); DR-03; `wave_state.md:1607`; DESIGN_ISSUES #62.
- **If unanswered:** the deletion wave cannot be built and store submission stays blocked on E-3.
- **Blocks:** the deletion track and store submission.

**I-11 · App-store UGC duties** (Seif; Mostafa rules on DR-04; raised by store, roadmap, design)
- **Ask, Seif (Q-B9):** "For Apple guideline 1.2 and Play's UGC policy: do you filter display names and chat text? Is there a published response time for reports? Will you endorse leaderboard 'Option 0' (rank, points and avatar, no names), or change the schema?"
- **Why:** chat, friends and leaderboard names are user-generated content.
- **Evidence searched:** reconciliation H-1, O-5, Q-B9 (`:213`); DR-04; `blockStudent` and `reportStudent` (stable since 3.37 and 3.39).
- **If unanswered:** the UGC position cannot be finalised.
- **Blocks:** the friends and chat waves, the leaderboard H-1 fix, store submission.

### Questions for Mostafa, or Mostafa with the client, legal or the designer

**I-9 · The subscription screen** (Mostafa and Seif; the designer; raised by account, design, roadmap; also in the contract, env-push, store and learning decisions)
- **Ask, Mostafa:** "The backend handoff, item 1, asks for a subscription status screen with a website link. What we have on record:
  - adr-049 §3: the app never carries a purchase link or tells the student where to buy (changelog@eddb6ac `:576`).
  - adr-049 §4: the app never mentions code redemption (`:338`, `:585-589`).
  - R-10 is OPEN, and you withdrew the `/redeem` slot from Env Wave 2 (`8e641e9`).

  Which do you want?
  - (a) No subscription screen.
  - (b) A link-free, read-only status screen: the entitlement is active or not, and there is no pending state.
  - (c) A status screen with a website link. This needs Seif to revise adr-049 in a changelog entry, and you to accept the Apple 3.1.1/3.1.3 exposure on the Egypt storefront."
- **Ask, Seif (Q-B10):** "Is adr-049 §3 or §4 being revised?"
- **Ask, the designer:** "What are the node ids of the commissioned 'dual subscription screens (base + flashcard)' (`F:\level\03_role_uiux_partner.md:15`)? Please draw a replacement frame for whichever option is chosen."
- **Evidence searched:** `RISKS.md:142-150`; D-007 (`DECISIONS.md:252`); `ENVIRONMENTS.md:405-412`; the Figma Profile row `170:4890` ("Upgrade to premium").
- **If unanswered:** nothing is built and no URL slot is added.
- **Blocks:** the subscription wave, and what happens to the Profile "Upgrade to premium" row.

**I-10 · Public legal pages, policy facts and the support contact** (Seif or the web team; Mostafa and legal; raised by store, roadmap, design)
- **Ask:**
  - (a) "Where will the public privacy-policy, terms and account-deletion-request pages live (URL, owner, date)? Will they mirror `getLegalDocument`? The contract calls the Play web-deletion leg 'still-unowned' (changelog@eddb6ac `:511`)."
  - (b) "Who approved the staging text r4-2026-10-07, and will production serve the same version?"
  - (c) "Which legal entity name goes into the policy and the store listings? D-021 calls it 'still-unknown'."
  - (d) **Q-B1, never filed:** "What are the retention periods, how is data that is not deleted erased, how long are logs kept, and who are the sub-processors (hosting, OTP provider)?"
  - (e) "Will the monthly School parent report (adr-165) be delivered in production? If so, will the privacy text change? It currently says the guardian is contacted only through account recovery (`openapi:4265-4276`)."
  - (f) "Which support URL or e-mail will the store listings use?"
- **Why:** store blockers E-2 (P0), E-7 and E-8, plus the Play Data Safety and Apple App Privacy forms.
- **Evidence searched:** D-021 Q1 and Q7; `ENVIRONMENTS.md:80`, `:405-409`; `STORE_READINESS.md:213-216`, `:245-262`; the staging legal texts read on 2026-10-08; 0 hits for "retention" in `seif_fight.md`.
- **If unanswered:** the in-app legal viewer can be built, but E-2, E-7 and E-8 stay blocked and the store consoles cannot be filled in.
- **Blocks:** the store-submission track.

**I-12 · Who owns Firebase** (Mostafa or the client, with Seif; raised by contract, upload-push, social, env-push, store, roadmap)
- **Ask:** "If push ships:
  - Who creates and owns the Firebase project(s)? One project with four apps, or separate staging and production projects, as the handoff implies?
  - Who registers `com.levelupworld.app` and `.stg` on Android and on iOS?
  - Who supplies `google-services.json` and `GoogleService-Info.plist` into the reserved slots?
  - Who issues the APNs key, and under which Apple team?
  - Do you lift R-9's rule that nothing may be registered with Firebase before ownership is settled?"
- **Why:** the config files cannot exist without the registrations, and an id is permanent once registered. The backend holds no Firebase credential (D-021 Q7).
- **Evidence searched:** `DECISIONS.md:1060`; `ENVIRONMENTS.md:340-357`, `:425-428`; `RISKS.md:137`; DR-18. There is no config file and no `firebase_*` dependency in the tree.
- **If unanswered:** the push client can only be written behind a placeholder. No Firebase-enabled build and no iOS push.
- **Blocks:** the push wave and the push capability in Env Wave 3.

**I-13 · Mac, Apple team and store accounts** (Mostafa or the client; raised by env-push, ci, store, roadmap)
- **Ask:**
  - "Which Mac with Xcode 26, or which paid macOS runner, will be used for Env Wave 3 and every iOS check, and from when?"
  - "Who holds the Apple Developer team, and under which legal entity?"
  - "Will Play publish from an organisation account or a personal one? A personal account needs a closed test with 12 testers for 14 days."
  - "Who owns the store accounts? DR-18 recommends organisation accounts owned by the client."
- **Evidence searched:** `ENVIRONMENTS.md:101`, `:284`, `:291`, `:368`; `env_chapter_state.md:13`; `ci.yml` has no macOS job; `STORE_READINESS.md:245-256` items 3 and 5; DR-18 and DR-26; the pbxproj has no `DEVELOPMENT_TEAM`.
- **If unanswered:** iOS work is written at SOURCE level only, and no dates can be worked out for App Store or Play production access.
- **Blocks:** Env Wave 3, the E-4 proof, iOS signing and APNs, store submission.

**I-14 · The Terms acceptance gate** (Mostafa, legal and the designer; raised by account, social, design, store; also in the upload-push and roadmap decisions)
- **Ask:** "The server records acceptance but enforces it only on photo uploads (`openapi@eddb6ac:1122`; `error-codes.md:67`). The served Terms §2 promises the app will ask for acceptance 'before you continue'.
  - Where should the app ask: right after registration (the 201), at first sign-in, before the first UGC action, or before the first photo?
  - Should the whole app block until the student accepts, or only certain features?
  - What happens to Login's 'Cookie Policy' link? `getLegalDocument` serves only terms and privacy (`:831`).
  - Who approves the AR/EN legal text (S30)?
  - `acceptTerms` 'is not parent consent' (`:1096`). What is the position on parent consent?"
- **Evidence searched:** `openapi@eddb6ac:816-831`, `:1087-1123`; staging Terms §2; `seif_fight` S30 (`:1246`); DESIGN_ISSUES #9; DR-14. Nothing in `lib/` calls `acceptTerms`.
- **If unanswered:** the viewer can be built, but there is no acceptance gate, and the photo and UGC waves stay gated.
- **Blocks:** the Terms/legal wave, the change to the registration flow, photos, chat.

**I-15 · Photos of minors** (Mostafa and legal; raised by design)
- **Ask:** "Domain rule 9 blocks the camera until a privacy/legal review is done (minors' images, Law 151/2020, parental consent). Does that review also cover photos picked from the gallery or the Photo Picker, both for custom avatars (public on the CDN once scanned; changelog@eddb6ac `:14-15`) and for support photos? Is the Terms-gated photo path acceptable? Should the app ever ask for camera permission?"
- **Evidence searched:** `.claude/skills/level-up-domain/SKILL.md:22`; `Scope_v2_Features.md:24`; `store_readiness_audit.md:232`; `openapi:988-990`.
- **If unanswered:** the avatar and support-photo waves stay blocked, now that their operations are stable.
- **Blocks:** avatar upload, support photos.

**I-16 · Push experience** (Mostafa and the designer; raised by upload-push, env-push, roadmap)
- **Ask:** "If push ships:
  - When is the system permission requested: after sign-in, at first run, from Settings, or at a moment that fits the context?
  - What explanation is shown before the system prompt, and what copy appears if the student refuses?
  - What should the student see when a push arrives while the app is open: an in-app banner, a system notification, or nothing?"
- **Evidence searched:** the push section of `realtime.md@eddb6ac` (`:78-108`) has no permission text. The 3.19 entry (changelog `:313`) only says not to build a prompt from the inbox. `store_readiness_parts/14_declarations_permissions.md:165` says to ask in context, not at launch. DESIGN_ISSUES has no push entry.
- **If unanswered:** the push wave stops at this design question once Firebase and delivery are ready.
- **Blocks:** the push wave.

**I-17 · Entry points and where the inbox lives** (Mostafa and the designer; raised by learning, social, design, env-push, roadmap)
- **Ask:**
  - "Please answer **D1–D5** in `notification_inbox_3_28_investigation.md:345-349`:
    - Does the bell open Notifications (`180:8386` / `309:9525`), or does the Message tab hold the inbox?
    - What does tapping a row do?
    - What does 'All (N)' show?
    - What happens to the Promotions chip?"
  - "Which screen is 'the notifications screen' that `academic_year_opened` and unknown-kind push taps open (`realtime.md:106`)?"
  - "Where do students enter Friends (S36 ask 2), the Blocked list and Support tickets?"
  - "What does the people icon in the Messages header open (`649:8837`)?"
  - "Where does `forwardQuestion` live: after grading, in the review, or in history? Do the share icons that were left out come back (#95, the flashcard header)?"
- **Evidence searched:** `notification_inbox_3_28_investigation.md:43`, `:345-355`; `endpoint_ui_mapping.md:126`, `:143`; `friends_screen.dart:15-19`; `app_router.dart:313-316`, `:420-423`; `home_header.dart:14-17`; `flashcard_study_screen.dart:48-49`.
- **If unanswered:** screens are built with routes but no way in; the bell stays inert; push taps go to the `/message` placeholder, marked provisional.
- **Blocks:** the inbox, friends, support, forwarding and push-tap waves.

**I-18 · Referral reward and the invite code** (Mostafa, with Seif and the designer; raised by account, social, design, roadmap; also in the upload-push and census decisions)
- **Ask:** "Three definitions exist:
  - Figma says 'you both earn 500 bonus points' (`178:2646`).
  - The contract says the sharer gets +10 points per new OTP-verified account, the new student gets nothing, and there is no credit while the sharer has no active enrolment (`openapi.yaml:1440-1442`).
  - The stale parent roadmap says 'Referral codes (50% off)' (`F:\level\05_roadmap_scaffold.md:69`).

  Which is the product rule? Does the designer redraw the copy and tiles, or does Seif change the rule? Does the Sign Up_1 line 'earn points together' stay? May the app start sending the collected referral code as `inviteCode` (School now, University after I-5)?"
- **Evidence searched:** DESIGN_ISSUES #7 (`:126-130`); `seif_fight` S5; `signup_identity_screen.dart:23`, `:86`.
- **If unanswered:** build Refer a Friend from server values only (`code`, `friendsJoined`, `pointsEarned`), state no amount anywhere, and keep not sending the code.
- **Blocks:** the Refer a Friend wave and the Sign Up_1 copy.

**I-19 · When to promote `main`** (Mostafa; raised by git)
- **Ask:** "`main` is 32 commits behind `merged` and is only ever fast-forwarded on your word. The release compile gate (`--flavor prod`) runs only on pushes to `main`. It has never run against the flavored `ci.yml`, and it cannot be dry-run with `workflow_dispatch`. Do we promote before the first store build, so that CI run happens first, or after?"
- **Evidence searched:** memory branch-topology-merged; `ci.yml:262`, `:320`; `ENVIRONMENTS.md:328`; `RELEASE_SIGNING.md:95`; `gh` run history (only main runs 5 and 9, both before flavors).
- **If unanswered:** promotion becomes a late, explicitly owner-gated step, preceded by a green run on `merged`.
- **Blocks:** the release-candidate track.

**I-20 · Copy the contract does not supply** (Mostafa or the designer; raised by contract, upload-push, roadmap, design, account)
- **Ask:** "Please supply or approve EN and AR copy for:
  - inbox kinds `enrolment_opened`; `support_ticket_replied` (the contract gives only an English hint, changelog `:106`); `academic_year_opened` (with its `track` and `academicYear` parameters);
  - 'this photo can't be sent' and 'this photo can't be used';
  - attachment expired, and attachment removed;
  - the Terms-gate prompt;
  - the ban screen (approve the contract's suggestion);
  - OTP lockout;
  - the track-transfer disclosure and second confirmation;
  - the recovery steps;
  - deletion request and cancel, after I-8;
  - the push permission explanation, after I-16;
  - the BUG-017 help lines (DR-09);
  - a replacement for the Figma hint 'PNG, JPG, or PDF up to 10MB'. The contract allows JPEG, PNG or WebP, at most 7,000,000 bytes, at most 3 photos per message and 10 per ticket."
- **Evidence searched:** `openapi:1162-1197`; `error-codes.md:16`, `:51`, `:61-67`; `lib/l10n/*.arb` (no inbox or push keys).
- **If unanswered:** these surfaces cannot meet the bilingual definition of done. The inbox can render only `announcement` and `moderation_warning`.
- **Blocks:** the inbox, photos, avatar, Terms, ban, lockout, transfer, recovery and deletion waves.

**I-21 · Missing frames** (the designer, through Mostafa; raised by account, social, design, roadmap, learning, census)
- **Ask:** "Please draw these, or give their node ids if they already exist:
  - Lost-phone recovery (4 steps).
  - Track transfer: the University, faculty and study-year pickers, the second confirmation and the University disclosure. Either show it only to `secondary3` students, or show it to everyone with a not-eligible state. Also the University Profile without 'Go to University'.
  - The banned-account screen.
  - OTP lockout.
  - Deletion request, confirm and cancel, and the pending-deletion state.
  - The Terms step and the legal-document viewer.
  - 'Logged in on another device'.
  - Chat report, block and unfriend, and the Blocked list.
  - Declining a friend request, and a 'my friends' list.
  - Support ticket status labels (`open`, `in_progress`, `pending`, `closed`) and the photo-refused error.
  - The Quiz history list, and what Home 'Continue Learning' shows. `listQuizHistory` returns only scope, subject, score/total and finish time: no percentage, no lessons left, no streak.
  - The Favorites list.
  - The University module picker.
  - The result screen when a replay has no questions.
  - The pre-prompt before the notification permission.
  - Loading, empty, error and offline states for each new screen.

  Corrections: Messages frames that are text only (no camera, voice or group); referral copy per I-18; the subscription screen per I-9; the support-photo hint; remove the masked phone from the Friends frame.

  Node ids wanted: the University versions, and the dark and Arabic Notifications, Friends, Messages and Support frames."
- **Evidence searched:** DESIGN_ISSUES; `wave_state.md:1607`; `endpoint_ui_mapping.md:127-150`; `figma_ui_comparison.md`; Figma `get_metadata` on 16 nodes (design corrector); handoff item 3.
- **If unanswered:** each UI wave stays "blocked by design" (class G). Data layers can still be built.
- **Blocks:** every UI wave listed above.

**I-22 · Minors and data-protection memo** (Mostafa and legal; Seif for hosting; raised by store, roadmap)
- **Ask:** "For DR-08 and DR-27, please give us:
  - the declared age groups and minimum age, and the stance on under-13s;
  - whether a University student must give a guardian phone;
  - the purpose wording for date of birth and parent phone;
  - which law applies (Egypt's PDPL, Law 151/2020, plus any launch countries);
  - who the data controller is, and the legal basis for minors' data;
  - where production data is hosted.

  The scope is now wider because of peer chat, phone lookup, scanned photos and FCM. For DR-28: must the app show the OFL font licences and the package licences, and where?"
- **Evidence searched:** `STORE_READINESS.md:245-252` item 1; DR-08, DR-27, DR-28; reconciliation H-5.
- **If unanswered:** the Data Safety, App Privacy, age-rating and Play Families answers cannot be filed.
- **Blocks:** store submission, and the minors' safeguards in the chat, friends and photo waves.

---

## 16. Non-blocking questions

These can be answered while the workflow runs. Each has a safe default.

| ID | Question (ready to send) | Who | Why / evidence | If unanswered | Blocks | Raised by |
| --- | --- | --- | --- | --- | --- | --- |
| N-1 | "Will `429 otp_throttled` carry `Retry-After`, or the remaining lock time? Is `Retry-After` always a number of seconds on every 429?" (Q-B5, narrowed) | Seif | `Retry-After` is declared only on `rate_limited` and `forward_daily_limit_reached` (`openapi:187`, `:200`, `:234`, `:306`). The app reads it only for `rate_limited` (`error_interceptor.dart:34-36`) | Generic copy, or the documented 15 minutes | Lockout copy | contract, account, design |
| N-2 | **One change request for wording errors at 3.46:** (a) the support tag still says "Text only for launch … attachments arrive later" (`:136-137`); (b) the social and chat tags say "no streaks" (`:142`, `:149`) although `listMyFriendStreaks` is stable; (c) `getTermsAcceptance` says "the backend serves no Terms text" (`:1095`) although `getLegalDocument` does; (d) `acceptTerms` says acceptance is "not enforced" (`:1122`) although photo uploads return 403 `terms_acceptance_required`; (e) `error-codes.md` rows 61-67 still say "(draft)"; (f) the 3.46 entry has no "Consumers affected" line, which the standing rule at changelog `:3` requires; (g) `sendFriendRequest` says "no push or inbox item" (`:3162`) although a `friend_request_received` push exists — will an inbox row ever be written?; (h) changelog `:208` spells the kind `ChatMessageReceived`, but `realtime.md` uses `chat_message_received`; (i) 3.37 counts 18 flips where 15 exist, and 3.35 skips a version; (j) the 3.36 leaderboard "blocked students excluded" change carries no `x-behaviour-changed` stamp | Seif | The contract contradicts itself in places that agents read as build guidance | Build from the operation definitions, `error-codes.md` and `realtime.md`; record these as known errors | None | contract, upload-push, social, design, roadmap |
| N-3 | "Is `enrolment_opened` still written? Which `data` keys does it carry? Should the app render it or ignore it?" | Seif and Mostafa | It is in the kind enum (`openapi:1211`) but its keys are documented nowhere | Ignore the kind; the contract allows ignoring kinds the app cannot render | Inbox | upload-push, social |
| N-4 | "What does the storage host return when a presigned PUT fails (an expired URL, a signature mismatch)? May the app retry the same URL before `expiresAt`, or must it presign again? What is the storage hostname, for network policy? What is the per-kind hourly push limit (`realtime.md:107`)?" | Seif | The contract specifies the request, not the storage response | Treat any non-2xx PUT as a failure and restart from presign | Photo robustness | upload-push |
| N-5 | **File the DR-22 batch:** Q-B4 (where the level ladder starts — S3 already settled "static, every 500"); Q-B6 (which 4xx codes `/auth/refresh` can return); Q-B7 (the `/reference/cities` 400 body); Q-B8 (S40 `createQuiz` 403 precedence, S39 when a point is credited, S45 `avatarId` 400 vs 404, S6 asks 1–3, close S37, narrow S38); S2 / DEC-05 (abandoned-quiz allowance). Also chase S25 (Rank "HERO" tier), S28 (notification preference storage), S34 (`parentPhone` is write-only), S43 (replay pool) | Seif | Never filed: `DR-22` "file one batch now"; no Q-B hits in `seif_fight.md` | Carried as known risks | Edge cases in quiz and auth | roadmap, learning, census |
| N-6 | "Will there be a minimum-version or forced-update signal before release 1?" (DR-17) | Seif and Mostafa | No signal at 3.46 | No forced update in release 1 | Release hardening | roadmap |
| N-7 | "Who signs off product and store decisions: you, the client, or 'Yousef'? `STORE_READINESS.md:245` names 'owner: Yousef' for §14; CLAUDE.md names you; the roadmap says 'Product owner + client'." | Mostafa | Decides where B-2, I-13 and I-22 are sent | Send everything to Mostafa | Message routing | consolidation |
| N-8 | "What should happen to the untracked `level_up_master_completion_roadmap.{json,html}`: leave untracked, commit the JSON only, move both out, or regenerate them for the chosen pin? May the 5.2 MB HTML ever enter git history?" | Mostafa | They are not ignored, are referenced nowhere, and are stale against the contract | Leave untracked; treat as non-authoritative | None | git |
| N-9 | Repo housekeeping: "May I (a) commit the `xargs -s 7000` batching patch from the `angry-antonelli` worktree and retire both `claude/*` worktrees and branches; (b) turn on `core.hooksPath .githooks`, and in which order relative to (a); (c) delete the three `backup/*` branches; (d) uninstall the orphan `com.levelup.level_up_app` from the Pixel 8 (D-021 says it can be removed); (e) keep or delete `lib/main.dart`?" | Mostafa | The patch exists in no branch; the hooks are not enabled on this clone | Touch nothing | Tooling | git, ci, env-push, roadmap |
| N-10 | GitHub settings: "Turn on branch protection and required checks? Make the goldens job required? Turn on secret scanning, push protection and Dependabot? Run the release compile gate on `merged` and on PRs (6–10 minutes per run)?" | Mostafa | No branch is protected; this token cannot see the security settings | Treat secret scanning as absent; keep Firebase and keystore files out by `.gitignore` plus a manual scan | CI and release hardening | ci, git |
| N-11 | "May I correct the stale documents, and in which commit?" R-3 (CI has now been observed); `WAVE_STATUS.md:56-57` (which device ran the walk); the 849 test floor in `CLAUDE.md` (measured today: 2067); the CRLF sentence at `SOURCE.md:17`; D-008's rationale; closing S5, S11, S14, S24, S29, S31, S33 and S37 in `seif_fight.md`; the stale TODOs at `profile_screen.dart:240`, `:331` and in the `home_header` comment. Also: should a test-count floor be enforced by a test? | Mostafa | Documents that disagree with the code mislead agents | Record in the report only | Docs | git, ci, learning, roadmap |
| N-12 | "What version and build-number policy applies to the first store uploads?" | Mostafa | `pubspec.yaml:19` is still `1.0.0+1`; the 2026-09-05 audit `:266` asked for an explicit decision | `1.0.0+1` first, then bump on every build | Store upload | env-push |
| N-13 | "Which new dependencies do you approve, one wave at a time: a Markdown renderer, a SignalR client (after a spike: WebSockets only, `skipNegotiation`, `access_token` in the query), `firebase_messaging`, an image picker and compressor, SHA-256, share, UUID? And how far should the contract guard extend: every stable app-buildable schema, or only the consumed ones?" | Mostafa | Each dependency changes the privacy manifest and Data Safety answers; none is in `pubspec.yaml` or `pubspec.lock` | Run a spike, then ask at the start of each wave | Chat hub, legal viewer, photos, push | account, store, social, upload-push, ci, roadmap |
| N-14 | "Is routing a notification tap to a ticket, friend requests, a conversation or the notifications screen allowed under D-021 Q7's 'no deep links in release 1'? That decision sits next to the `/redeem` browser link, and the store audit reads it as covering URL / App Links." | Mostafa | `DECISIONS.md:1060`; `store_readiness_audit.md:76`; `realtime.md:106`; the only intent filter is MAIN/LAUNCHER | Treat tap routing as not a deep link; record that reading in DECISIONS.md | Push | upload-push, roadmap |
| N-15 | "If a push is tapped while the student is signed out or was evicted, should the app go to the tapped target after sign-in?" | Mostafa and the designer | `app_router.dart:74-83` drops the location today | Drop the target; `/login` then `/home` | Push | env-push |
| N-16 | "Does 'Lockout pop-ups' in the handoff mean only `otp_throttled`, or also `rate_limited`, the avatar lock after 3 refused photos, or `forward_daily_limit_reached`?" | Mostafa or Seif | The repo uses the word once, meaning `otp_throttled` (`day1_login_otp_brief.md:114`) | Only `otp_throttled` gets the lockout treatment | Lockout | design |
| N-17 | "Should the 2026-09-27 ruling 'keep Points only' (#101) be reopened so the Solved Questions card is filled from `getMyQuizSummary`? Designer: should the third card be Rank (light frames) or Badges (dark and RTL frames)?" | Mostafa; the designer | The frames exist and the data source is now stable | Points only | Profile | census |
| N-18 | "Should D-008 be reopened so the app shows the caller's own rank via `getMyRank` (with `404 not_ranked` and `403 score_hidden`), and where? D-008's stated reason misreads the contract, which calls this 'a separate optional read' (`openapi:2517`)." | Mostafa; the designer; Seif for the S25 tier | Students ranked below 200 see no rank at all | No self-rank; correct the rationale | Leaderboard | learning |
| N-19 | "If replay ships (B-2 row 13): what does the app show when the badge says N mistakes but the 'ever wrong' pool differs (S43)? Is there a design for an empty pool (`201` with `questions: []`)?" | Mostafa; Seif; the designer | `mistakes_subject.dart:49-58`; `quiz_state.dart:53` | Mistakes stays read-only | Mistakes replay | learning |
| N-20 | "Is the one-time snackbar acceptable as the 'logged in on another device' experience for release, or do you want a dedicated screen?" | Mostafa and the designer | Today it is a forced logout to `/login` | Keep the snackbar and `/login` | Session | account, roadmap |
| N-21 | "Do you want to reopen D-015, which ships the contract's 'Subscribe to get…' explanation copy word for word, given the Apple 3.1.1 exposure? If it stays, a future purchase-silence guard must explicitly allow that string (`app_en.arb:516`)." | Mostafa (Seif for any new wording) | D-015 was accepted on 2026-09-26 | D-015 stands | Quiz explanation; guard | learning, account, store, ci |
| N-22 | Release-configuration rulings: DR-02 (how to fix E-4), DR-06 (orientation), DR-07 (iPad), DR-10 (repeated submit failure mid-quiz), DR-12 (crash reporter), DR-13 (obfuscation), DR-15 and DR-29 (Back behaviour and predictive back), DR-16 (where to return after a quiz, refetching), DR-20 (AAB only; `country_flags`), DR-21 (performance bar), IOS-D2 (the iOS leg of screen protection), distribution territories | Mostafa | Each has a recommendation on record and no ruling | Apply nothing until ruled | Release hardening | roadmap, store |
| N-23 | Rulings the designer and owner still owe: DESIGN_ISSUES #54, #72 (14 vs 18), #74 (dark scrim; no dark Limitation frame), #77, #86, #87, #90, #114 (provisional Arabic flashcard strings), #119–#126; when to schedule the D-019 mixed-font wave; W18-3; the size of the review AI glyph | The designer and Mostafa | Listed as open in `wave_state.md` and DESIGN_ISSUES | Keep the current provisional treatments | Polish | design, roadmap, learning |
| N-24 | "Do you accept that push text follows the phone's language, not the in-app language switch? This follows from the contract's native loc-keys." | Mostafa | `realtime.md@eddb6ac:97-104` | Accept the contract's behaviour | Push | upload-push, social |
| N-25 | "Will you remove and rotate the Figma file credential flagged on 2026-09-29? Claude has not read it and will not." | Mostafa | An exposed credential in a third-party file | It stays exposed | Security hygiene | roadmap |
| N-26 | "Please confirm the realistic-looking sample phone number in the hint text of both ARB files does not belong to a real person." The number is deliberately not repeated here. | Mostafa | Store-section unknown; a privacy concern for a minors' app | Leave it flagged | Privacy | store |

---

## Decisions that must not be made by Claude

For each: what is on record, what is decided and what is not, and who decides. Claude may lay out options and evidence, and must not choose.

**DC-1 · Referral reward**
- **On record, three definitions:**
  - Figma Refer frame `176:2425`, text `178:2646`: "you both earn 500 bonus points" (re-read by the design corrector). Sign Up_1 says "earn points together".
  - The contract (`getMyInvite`, `openapi@eddb6ac:1440-1442`, adr-185 D9): +10 to the sharer per new OTP-verified account, in the current Track's points; nothing for the new student; no credit while the sharer has no active enrolment.
  - The stale parent roadmap: "Referral codes (50% off)" under Payments (`F:\level\05_roadmap_scaffold.md:69`). This is from the Paymob era; a discount would also be a price surface, which adr-049 §3 forbids.
- **Decided:** the contract's rule exists, and the app displays only `code`, `friendsJoined` and `pointsEarned`.
- **Not decided:** the product truth, who changes which source, the copy, and whether to start sending `inviteCode` (`signup_identity_screen.dart:86` collects the code and never sends it).
- **Who:** Mostafa (product, with the client), plus Seif if the rule changes, plus the designer for the redraw. → I-18.

**DC-2 · Exception for draft `transferToUniversity`** (DR-24)
- **Moot from 3.39 on:** the operation is stable at `2e5bb69` and `eddb6ac` (my 3.46 count).
- **Live only if the owner stays at 3.38 (`65245be`).** There the changelog says the screens "may be built now" while the operation is draft, and `SOURCE.md` (working tree) flags that an owner ruling is needed.
- **Still open:** the pin choice (B-1), scope (B-2 row 3), and the eligibility UI and irreversible double confirmation (I-21).
- **Who:** Mostafa.

**DC-3 · Final Android package id**
- **Decided:** D-021 Q1, ratified 2026-10-06 (`DECISIONS.md:1054`).
  - `com.levelupworld.app` for production and `com.levelupworld.app.stg` for staging.
  - Two identities only (Q2); display names "Level Up" and "Level Up STG" (Q3).
  - Applied on `merged`: `android/app/build.gradle.kts:55`, `:76`; checked in the built APK (ARTEFACT, `aapt2`); guarded by `android_identity_test.dart`.
  - The namespace stays `com.levelup.level_up_app`, a reversible engineering choice that never shipped.
- **Not decided:** the Play Console registration, account ownership ("not decided here"), and the Firebase registration (blocked by the R-9 gate).
- **Claude's limit:** never change the id, register it or upload it. A package id is permanent once uploaded.
- **Who:** Mostafa or the client.

**DC-4 · Final iOS bundle id**
- **Ratified:** the same strings, `com.levelupworld.app` and `.stg` (D-021 Q1).
- **Not applied:**
  - `ios/Runner.xcodeproj/project.pbxproj:371`, `:550`, `:572` still say `com.levelup.levelUpApp`; RunnerTests is at `:387`, `:404`, `:419`.
  - No schemes exist yet.
  - Applying them needs a Mac with Xcode 26 (Env Wave 3).
- **Not registered:** no Apple App ID, no App Store Connect record, and the Apple team is unknown (DR-26).
- **Who:** Mostafa or the client, as the Apple team holder.

**DC-5 · iOS minimum version**
- **Decided:** 15.0.
  - D-021 Q4: the frontend chose 15.0 over Seif's rule of "the lowest version the pinned Flutter supports", which would be 13.0.
  - Every dependency's floor was checked to be 13.0 or lower (`ENVIRONMENTS.md` §3.2).
- **Not applied:** `IPHONEOS_DEPLOYMENT_TARGET = 13.0` at pbxproj `:349`, `:475`, `:526`.
- **Not decided:**
  - CocoaPods or Swift Package Manager (there is no Podfile in `ios/`).
  - Whether the Firebase iOS SDK would force a higher floor if push ships (unknown).
  - iPhone-only or iPad too (DR-07).
  - When the Mac is available (I-13).
- **Claude's limit:** may write the change at SOURCE level only, on the owner's go. Must not reopen the number.
- **Who:** Mostafa.

**DC-6 · The subscription screen, beyond purchase-silence**
- **Options:**
  - (a) No screen. This is the current state: D-007 removed the purchase surface, and R-6 is closed.
  - (b) A link-free, read-only entitlement status screen: active or not, with no pending state (`openapi.yaml:754`). Needs a designer frame and a ruling on the word "subscription" (D-007).
  - (c) What handoff item 1 asks for: a status screen with a website link. This conflicts with adr-049 §3 (changelog@eddb6ac `:576`: no paywall, price, purchase link or where to buy) and §4 (no mention of code redemption; `:338`, `:585-589`).
- **Status:** R-10 is OPEN — DECISION. Q-B10 was never filed. The `/redeem` slot was withdrawn from Env Wave 2 (`8e641e9`).
- **Option (c) needs:** a Seif changelog entry revising adr-049, and the owner accepting the Apple 3.1.1/3.1.3 exposure on the Egypt storefront.
- **Who:** Mostafa and Seif; the designer for the frame. → I-9.

**DC-7 · Product behaviour the backend does not represent**
- **Items with no backend:**
  - the Progress screen (S32), Daily Tasks and XP, a personal daily streak;
  - the Promotions chip;
  - photo, voice, camera and group chat (the contract's chat is text only, `openapi@eddb6ac:143-150`; `realtime.md:17`);
  - the Rank "HERO" tier (S25), a third theme (S26), storage for the notification toggles (S28);
  - a quiz timer (S7), a pass threshold (S13), the Learning Tools cards (S9);
  - a points scale about 20 times the design's (S12).
- **Already settled by the repo:** the "Premium Offer — 40% Off" and "Upgrade to Premium" rows cannot be built under adr-049 §3 and D-007 (`notification_inbox_3_28_investigation.md:351-353`).
- **Options:** drop or hide (DR-05 recommends hiding), raise a change request to Seif, or keep as "Coming soon" (a store 2.1 risk).
- **Claude's limit:** never compute these in the app and never invent them.
- **Who:** Mostafa; Seif for change requests. → I-7, B-2.

**DC-8 · Figma designs that are missing**
- **What:** the list in I-21.
- **Options:** the designer draws them; or the owner rules that a screen is built from shared patterns, with engineering copy recorded as a DESIGN_ISSUES entry (the design section's fallback). That ruling is itself the owner's to make.
- **Claude's limit:** never invent screens, tokens or where a screen is reached from.
- **Who:** the designer; Mostafa for any interim ruling.

**DC-9 · Business rules in general**
- **Includes:**
  - the referral rule (DC-1) and the deletion forfeiture wording (DC-11);
  - track-transfer eligibility: show only to `secondary3`, or show and handle `403 track_transfer_not_eligible`;
  - Terms gating (I-14), and where the level ladder starts (Q-B4);
  - when points are credited (S39), the weekly allowance on abandoned quizzes (S2 / DEC-05), and repeated submit failures mid-quiz (DR-10);
  - the minors' age floor and guardian phone (DR-08);
  - the UGC posture (DC-14);
  - push timing (I-16).
- **Who:** Mostafa or the client; Seif for server-side rules.

**DC-10 · Push in release 1** (rubric item 8a, DR-11)
- **Options:**
  - (a) No push in v1. DR-11 recommends this, but it was written before the 3.43 push contract; `ENVIRONMENTS.md:347` says "treat push as not ready".
  - (b) Push in v1, as handoff item 6 asks. The shape is stable (`realtime.md@eddb6ac:78-108`), server senders exist behind gates (changelog `:46`), and delivery is off everywhere.
- **What (b) brings with it:**
  - the end of the zero-SDK posture;
  - Firebase, APNs and `POST_NOTIFICATIONS`;
  - new Data Safety and privacy-manifest answers;
  - lifting the R-9 gate;
  - I-3, I-12 and I-16.
- **Who:** Mostafa, with the client, informed by Seif's date for switching delivery on. → B-2 row 11.

**DC-11 · Account-deletion confirm wording** (DR-03, O-2, Q-B2)
- **Options:**
  - (a) Ask Seif for a version the app can safely show. The reconciliation recommends this; DR-03 says "ask once".
  - (b) Ship the contract text word for word (`openapi:1284-1286`) and record the 3.1.3 risk as accepted.
  - (c) The owner writes neutral wording. This would need Seif's sign-off, because the text is contract-mandated.
- **Who:** Mostafa rules; Seif writes the variant; the designer draws the frames. → I-8.

**DC-12 · The Message tab** (DR-01, O-1, E-5, D2)
- **Options:**
  - (a) Hide it for release 1. O-1 and DR-01 recommend this.
  - (b) Make it a minimal inbox on the stable notification operations.
  - (c) Make it friend chat; the Figma Messages frames are chat.
  - (d) Both.
- **Linked to:** where the bell leads (D2).
- **Who:** Mostafa and the designer. → B-2 row 15, I-17.

**DC-13 · Which contract pin** (DR-23, G-03)
- **Options:**
  - commit `65245be` and then re-vendor;
  - discard 3.38 and re-vendor to HEAD (`eddb6ac` today);
  - wait for Seif's freeze version.
- **Constraints on record:**
  - G-03: the pin must equal upstream HEAD at the release candidate.
  - A re-vendor is its own commit (P-6).
  - The 3.38 copy is uncommitted on purpose.
- **Who:** Mostafa, after Seif answers I-1. → B-1.

**DC-14 · User-generated content on the leaderboard** (DR-04, H-1, O-5, Q-B9)
- **Options:**
  - Option 0: rank, points and avatar, with no names. Needs Seif's endorsement or a schema change.
  - Report and block plus Terms acceptance. This is now backed by the contract: `blockStudent` since 3.37, `reportStudent` since 3.39.
- **Who:** Mostafa and Seif. → I-11.

**DC-15 · Who owns Firebase** (DR-18, D-021 Q7, R-9, `ENVIRONMENTS.md` §7)
- **Options:** one project with four apps, or separate staging and production projects (the handoff implies separate).
- **DR-18 recommends:** organisation accounts owned by the client.
- **Claude's limit:** nothing may be registered before ownership is settled.
- **Who:** Mostafa or the client, plus Seif for the backend credential. → I-12.

**DC-16 · Model roles versus the "Sonnet-only" rule**
- **On record:**
  - `wave_state.md:93`: "Subagents: Sonnet only".
  - The owner's new brief: Opus orchestration, Sonnet execution, Fable audit.
  - `AUDIT_PROTOCOL.md:125-149`: the Fable hand-off is a separate pass that "verifies, never trusts".
  - `AGENT_WORKFLOW.md:20`: "FABLE (when required)".
- **What fits:** the orchestrating session is not a subagent, and Sonnet execution matches the rule.
- **What clashes:** Fable auditors run as subagents. Also open is how often Fable audits run: every wave, or release candidates only (a ci decision).
- **Who:** Mostafa. → B-3.

**DC-17 · New dependencies and the privacy posture**
- **What:** Firebase, a SignalR client, a Markdown renderer, an image picker and compressor, SHA-256, share, UUID, and a crash reporter (DR-12). Each one changes the Apple privacy manifest and the Play Data Safety answers.
- **Who:** Mostafa. → N-13.

**DC-18 · Legal documents in the app or as web pages** (DR-14)
- **Settled by the contract:** the text is rendered in the app, during registration and from settings (`openapi@eddb6ac:819`). DR-14's "hosted pages" recommendation contradicts that intent.
- **Separately:** both stores need public URLs (I-10).
- **Claude's limit:** may not swap in hosted pages only.
- **Who:** Mostafa; Seif or the web team for the URLs.

**DC-19 · Git actions that leave this machine**
- Every push is outbound and needs the owner's permission each time.
- `main` is promoted only by fast-forward, on the owner's word (I-19).
- `dev` stays frozen.
- Never force-push.
- Filing the Seif batch in `docs/seif_fight.md` is a repo write that needs the owner's go.
- **Who:** Mostafa.

**DC-20 · Store accounts, account type and legal entity** (DR-18, DR-26, `STORE_READINESS.md` §14 items 3–5)
- **What:** organisation or personal account, D-U-N-S, the entity name that must match the privacy policy, and distribution territories.
- **Who:** Mostafa or the client. → I-13, I-10.

**DC-21 · Minors and data protection** (DR-08, DR-27, I-15, I-22)
- **What:** chat retention (24 hours after reading, 30 days otherwise), exposure through phone lookup, photo intake, the guardian phone, and the legal basis.
- **Who:** Mostafa and legal, plus Seif.

**DC-22 · Reopening standing rulings**
- **Rulings:** D-008 (no self-rank), #101 (Points only), D-015 (the "Subscribe to get…" copy), and the 2026-09-12 ruling that the Mistakes replay is out of scope (DR-19).
- **Claude's limit:** must not reopen any of them.
- **Who:** Mostafa. → N-17, N-18, N-21, B-2 row 13.

**DC-23 · Notification experience and push language**
- **What:** the timing of the permission prompt, what happens in the foreground, returning to the target after sign-in, and push text following the phone's language.
- **Who:** Mostafa and the designer. → I-16, N-15, N-24.

**DC-24 · Repo settings, hooks, cleanup and version policy**
- **Who:** Mostafa. → N-9, N-10, N-12.

---

## Already answered by the repository (not asked)

Levels: CONTRACT, SOURCE, DOC, BUILD, ARTEFACT, DEVICE, CI. Rows AA-1 to AA-4 are questions dropped or rewritten because of 3.46.

| # | Question as raised (by) | Answer | Evidence (level) |
| --- | --- | --- | --- |
| AA-1 | When will `uploadCustomAvatar`, `removeCustomAvatar`, `createSupportAttachmentUpload`, `completeSupportAttachment` and `getMySupportAttachmentContent` become stable, and does staging serve them? (contract, census, social, upload-push) | **Already stable and served.** At `eddb6ac` (3.46.0-m1) all five are stable, along with the `attachmentIds` / `attachments` fields. On staging the routes answer 401, a control path answers 404, and `/health/version` reports `a158daa`, the backend commit `eddb6ac` mirrors. Caveat: a 401 proves the route exists, not that storage and safety scanning are configured, so a `503 image_upload_unavailable` is still possible | `openapi@eddb6ac:28` and its 5 `x-stability` lines; changelog@eddb6ac `:7-18`; probe on 2026-10-08 (CONTRACT; DEVICE, unauthenticated HTTP) |
| AA-2 | Does the stable-only rule block track transfer, photos or avatars? May draft operations be built early? (upload-push, census, account, ci) | **No.** 0 operations are draft at 3.46, and `transferToUniversity` has been stable since 3.39. Only the pin choice remains (B-1) | My own 3.46 census (CONTRACT) |
| AA-3 | Should support launch text-only first, or wait for photos? adr-187 says support "does not launch until attachments ship" (changelog@eddb6ac `:161`); 3.39 says "text only for launch" (`:125`). (census, social) | **Moot.** At 3.46 text and photos are both stable. Only the release-1 scope remains (B-2 rows 6–7) | changelog@eddb6ac `:7-18` (CONTRACT) |
| AA-4 | How many operations can the app build? (census, roadmap) | 86 operations, all stable; 4 web-only, so **82** app-buildable. 19 are public and none is a support operation. `servers:` lists staging only | My own parse of `openapi@eddb6ac` (CONTRACT) |
| AA-5 | Which Android package and iOS bundle ids go to Seif? (handoff item 5; env-push, store) | `com.levelupworld.app` and `.stg` on both platforms. Display names "Level Up" and "Level Up STG". Android has them applied; iOS does not yet | `DECISIONS.md:1054-1058`; `build.gradle.kts:55`, `:76`; `aapt2` (DOC, SOURCE, ARTEFACT) |
| AA-6 | What is the iOS minimum? (env-push) | 15.0, ratified but not applied: pbxproj still says 13.0 | D-021 Q4; pbxproj `:349`, `:475`, `:526` (DOC, SOURCE) |
| AA-7 | Has CI ever run, and with what results? Is the branch protected? (R-3; ci, git) | **Yes, 15 runs.** The latest, `c87b90a`, is green. `f10b112` failed the format check (fixed by `56f74e7`). The two `main` runs (`f987f20`, `e71e9a1`) passed all four jobs, before flavors were added. No branch is protected. R-3 is stale | `gh api` runs, jobs and branches (CI) |
| AA-8 | On what device did the 2026-10-06 staging release-build walk run? (roadmap) | The Pixel_8 **AVD** (emulator). The physical Pixel 8 did a debug staging re-walk | reconciliation §15.1/§15.2 (`:381`); `RISKS.md:77` (DOC) |
| AA-9 | Does staging serve the 3.43–3.46 routes and `/hubs/chat`? (social, account) | **Yes.** `/me/invite`, `/friend-streaks`, `/conversations`, `/support/tickets`, `/me/notifications` and `/hubs/chat` all answer 401; a control path answers 404 | Probe on 2026-10-08 (DEVICE, unauthenticated HTTP) |
| AA-10 | Is an unread-notification count coming? (census) | It already exists: `getUnreadNotificationCount` is stable at every pin. The `home_header` comment saying otherwise is false | `openapi@eddb6ac:1223-1227`; `home_header.dart:23` (CONTRACT, SOURCE) |
| AA-11 | Should the app send `Accept: application/json`? (census, social) | Yes, the contract says to. It is a one-header fix at `dio_client.dart:19`, which today sends only `Content-Type`. No decision needed | `openapi:3881-3890`; `dio_client.dart:15-20` (CONTRACT, SOURCE) |
| AA-12 | How many whitelisted staging numbers exist? (ci) | `+20100000000xx`, with fixed OTP `000000` and 11 digits after +20. Up to 100 numbers | `openapi.yaml:96-98`; reconciliation `:391` (CONTRACT) |
| AA-13 | Is Terms acceptance enforced by the server, and is it parent consent? (account, store) | **Not enforced,** except photo uploads (403, inert until a Terms version is published). The text is shown in the app during registration and from settings. It "is not parent consent." Where to put the gate remains open (I-14) | `openapi@eddb6ac:819`, `:1096`, `:1122`; `error-codes.md:67` (CONTRACT) |
| AA-14 | Is the text `getLegalDocument` serves the approved text? (store, roadmap) | The contract says so ("the approved text verbatim"), and staging answers 200. Production parity and the approver remain open (I-10) | `openapi:811-830`; changelog@eddb6ac `:50` (CONTRACT) |
| AA-15 | Legal text in the app or in a browser? (DR-14, the in-app half) | In the app, per the contract. The public URLs for the stores are a separate question (I-10) | `openapi@eddb6ac:819` (CONTRACT) |
| AA-16 | Do we already know the legal entity name? (store) | It is recorded as undecided ("still-unknown legal company name"). The value is asked in I-10(c) | D-021 Q1; `STORE_READINESS.md:245-252` (DOC) |
| AA-17 | Can any channel outside the app create a deletion request? (account) | No such channel is published | changelog@eddb6ac `:511` (CONTRACT) |
| AA-18 | What happens to tokens on account deletion? (account) | The 202 revokes the session; the app purges the token pair. `SecureStorage.clear()` has no caller | `openapi:1276-1279`; `secure_storage.dart:61-64` (CONTRACT, SOURCE) |
| AA-19 | Is there a flashcard completion state? Is "preview used up" a pop-up? (learning) | Owner ruling: no completion screen. "Preview used up" is already an open designer ask (#119) | `DESIGN_ISSUES.md:4888-4891` (DOC) |
| AA-20 | Is there a standing decision on showing the caller's own rank? (learning) | Yes, D-008. Only reopening it is open (N-18) | `DECISIONS.md:469-471` (DOC) |
| AA-21 | Is a separate realtime streaks feature planned? (learning) | No: "folded into chat — will not be built" | `realtime.md@eddb6ac:10` (CONTRACT) |
| AA-22 | Are the Figma notification tabs backed by the contract? (learning) | Announcements, Support and System are backed by the `category` enum; Promotions is not | `openapi:1153-1159` (CONTRACT) |
| AA-23 | Is there a frame for Solved Questions? (census) | Yes, in all six Profile frames. It was ruled "Points only" on 2026-09-27. Reopening is N-17 | DESIGN_ISSUES #101 (`:4515`) (DOC) |
| AA-24 | `sendFriendRequest` says the recipient is "not notified", yet a `friend_request_received` push exists. Which is right? (social) | Both: the sender exists behind gates and delivery is off. Only the inbox-row question is left (N-2g) | changelog@eddb6ac `:46`; `realtime.md:80` (CONTRACT) |
| AA-25 | Does Friends have a Profile row? (social) | No, by design. Where it is entered from is I-17 | `friends_screen.dart:15-19`; `app_router.dart:420-423` (SOURCE) |
| AA-26 | What does "lockout" mean in the repo? (design) | `otp_throttled`. Confirming the handoff means the same thing is N-16 | `day1_login_otp_brief.md:114` (DOC) |
| AA-27 | Does the Create Ticket frame have a category field? Is the hint "PNG, JPG, or PDF up to 10MB"? (design) | No category field. The hint is `178:3368`, and it conflicts with the contract: JPEG/PNG/WebP, 7,000,000 bytes, ≤3 per message, ≤10 per ticket | Figma read by the corrector; changelog@eddb6ac `:12-13` (CONTRACT) |
| AA-28 | Does the Profile frame have an "Upgrade to premium" row? (design) | Yes, `170:4890` in `166:4416` | Figma read by the corrector (DOC) |
| AA-29 | What should happen to `dev` and `origin/dev`? (git) | They stay frozen under the standing policy | `WAVE_STATUS.md:6-7` (DOC) |
| AA-30 | Is promoting `main` part of the workflow? (git) | Yes, by fast-forward on the owner's word. *When* is I-19 | memory branch-topology-merged (DOC) |
| AA-31 | Where is the record behind "2067/0/0 at `8e641e9`"? (git) | In the scratchpad of session 99eae648 (ARTEFACT). It was also reproduced today: the 3.38 working tree gives 2067/0/0, and a 3.45 clone gives 2067/0/0 with guards at 122/122 (BUILD) | cor_git; cor_ci_validation |
| AA-32 | Where do the roadmap files come from? (git) | Session 99eae648 `build_report.py`. They are stale against the contract. What to do with them is N-8 | cor_git (DOC) |
| AA-33 | Are the two worktrees in live use? (git) | No, idle since 2026-09-27 15:23. The patch applies cleanly. Only the go-ahead to commit is open (N-9) | cor_git (SOURCE) |
| AA-34 | Are the vendored contract files CRLF? (contract) | They are LF. A CRLF copy makes the guard parser fail. The CRLF sentence at `SOURCE.md:17` is wrong and must be fixed before any commit | `.gitattributes`; probe log (BUILD) |
| AA-35 | What is the planned production host? (contract) | `api.level-upworld.com`. It is not deployed and not in `servers:`. Publishing it, and when, is I-2 | `ENVIRONMENTS.md:397-400`; D-021 Q5 (DOC) |
| AA-36 | What is the state of Firebase? (contract) | Nothing is registered, the backend has no credential, and whether the flavors share a project is unsettled. File slots are reserved. Ownership is I-12 | `DECISIONS.md:1060`; `ENVIRONMENTS.md:340-357` (DOC) |
| AA-37 | Do the vendored pins contain the push shape? (env-push) | None at `0df5cf4`; one line at `65245be`; the full section only from 3.43 (`realtime.md@eddb6ac:76-108`). The handoff's 8 EN/AR strings match it word for word | cor_env_push_impl (CONTRACT) |
| AA-38 | Is any Firebase or push code already in the app? (env-push) | None: no dependency, no config file, no `POST_NOTIFICATIONS`, no call to `registerFcmToken` | pubspec, manifests, `aapt2` (SOURCE, ARTEFACT) |
| AA-39 | Do the old `enrolment_opened` push keys exist in the app? (env-push) | No. The inbox kind is still in the enum | `openapi:1211`; ARB grep (SOURCE) |
| AA-40 | Will the owner accept the "paid"/"refund" wording on the deletion confirm screen? (design, store) | Already filed as Q-B2, with option (a) recommended. Do not re-ask the owner; it goes to Seif (I-8) | reconciliation `:184`, `:206` (DOC) |
| AA-41 | Where would quiz history live? (design) | The mapping already places it at Home "Continue Learning", with Review `162:2377` for re-opening. Only the list frame is missing (I-21) | `endpoint_ui_mapping.md:130-131` (DOC) |
| AA-42 | Does the bell open Notifications, or is the inbox the Message tab? (learning, env-push) | Already written up as D1–D5. Answer it there (I-17) | `notification_inbox_3_28_investigation.md:345-349` (DOC) |
| AA-43 | Can Seif set up a University test account? (learning) | Already filed (R-8 next action; S37 ask 2; S44). It is chased in I-6(a), not asked as new | `RISKS.md:125`; `seif_fight.md:639` (DOC) |
| AA-44 | What should the banned screen be? (account) | A dedicated "this account has been banned — contact Support" screen, with no retry. Only the channel and copy approval are open (I-4) | changelog@eddb6ac `:78`; `error-codes.md:51` (CONTRACT) |
| AA-45 | Are S37 and S44 still valid? (roadmap) | S37 is stale: staging has answered `PATCH /me`, entitlements and leaderboard since 2026-09-22, so close it. S44's premise is stale: the School account shows 53 English questions | reconciliation `:390-391`; `RISKS.md:125-126` (DOC) |
| AA-46 | Are filed S-items now answered by the contract? (roadmap) | S5, S11, S14, S24, S29 (now at 3.46), S30 (the text source), S31 and S33 (text at 3.39, photos at 3.46), and S36 ask 1 — closing them is N-11 | cor_roadmap_registers table (CONTRACT) |
| AA-47 | Where are the level thresholds? (learning) | Static, every 500 points; S3 was closed on 2026-09-04. Q-B4 asks only where the ladder starts (N-5) | `seif_fight.md:697-710` (DOC) |
| AA-48 | Should Env Wave 2 add the `/redeem` URL slot? (env-push) | Withdrawn: commit `8e641e9` and R-10 say "do not build the slot". The adr-049 question remains (I-9) | `RISKS.md:142-150` (DOC) |
| AA-49 | Keep the "Subscribe to get…" explanation copy? (learning, account, store) | Decided by D-015 (owner, 2026-09-26), word for word with approved Arabic. Only reopening it is possible (N-21) | `DECISIONS.md:851-880` (DOC) |
| AA-50 | Can chat have photos, voice or groups? (design) | No: the contract's chat is text only. Only the Figma redraw remains (I-21) | `openapi@eddb6ac:143-150` (CONTRACT) |
| AA-51 | What is the contract's referral rule? (account, social) | +10 to the sharer and nothing to the new student. The product conflict stays open (DC-1, I-18) | `openapi@eddb6ac:1440-1442` (CONTRACT) |
| AA-52 | Is a Mac needed for iOS? (ci) | Yes, a Mac with Xcode 26 is required. Which Mac, and when, is I-13 | `ENVIRONMENTS.md:101`, `:284`, `:291` (DOC) |
| AA-53 | What does "no deep links in release 1" cover? (upload-push) | URL and App Link entry points, judging by where D-021 Q7 sits and how the store audit reads it. A push tap is a different mechanism. Only the owner's confirmation is open (N-14) | `DECISIONS.md:1060`; `store_readiness_audit.md:76` (DOC) |
| AA-54 | Where is `invalidateSessionScope`, and does `verify_session_regression.ps1` call the API? (social, census) | `session_scope.dart:58`. The script calls no API operation | grep (SOURCE) |
| AA-55 | Does "8 P0" undercount the roadmap? (roadmap) | No: `by_sev_open.P0` is 8, and GAP2-02 is an aggregate | roadmap JSON parse (SOURCE) |

---

## Message batches

**Q-B1 to Q-B10 from the 2026-10-06 reconciliation were never filed in `docs/seif_fight.md`, the canonical channel.**
- **Evidence:** `grep -cE 'Q-B[0-9]' docs/seif_fight.md` returns 0. Topic greps also return 0 for "retention", "refund", "production host", "Retry-After" and "redeem". The file was last changed in `af0eadb` (2026-10-06 02:04 +0300). Roadmap DR-22 says "never filed".
- **Where each one went in this report:**
  - Q-B1 → I-10(d)
  - Q-B2 → I-8
  - Q-B3 → I-2 and I-10(a)
  - Q-B4, Q-B6, Q-B7, Q-B8 → N-5
  - Q-B5 → N-1
  - Q-B9 → I-11
  - Q-B10 → I-9
- **Filing needs the owner's go:** writing these into `seif_fight.md` is a repo write.

**To Seif** (please answer by ID; once Mostafa approves, these will be filed in `docs/seif_fight.md`):
- I-1: release-1 contract freeze, and whether `eddb6ac` is the mobile target (this is B-1 option (c)).
- I-2: when the production host and the `/hubs/chat` host are published; production reviewer numbers with a fixed OTP.
- I-3: whether the FCM token is detached on logout, eviction or account switch, or whether an unregister operation is coming.
- I-4: the signed-out support channel for `account_banned` and `recovery_unavailable`.
- I-5: whether `UniversityRegistration.inviteCode` is draft or stable.
- I-6: a seeded University account; seeded social states; whether a Terms version is configured; the date for switching push delivery on.
- I-7: whether operations for Progress, Daily Tasks or a personal streak are planned.
- I-8: a deletion confirm text the app can show safely (Q-B2).
- I-9: whether adr-049 §3/§4 is being revised (Q-B10).
- I-10: (a) the public legal pages and the web deletion page; (b) who approved the text and whether production matches; (d) retention and sub-processors (Q-B1); (e) parent-report delivery.
- I-11: filtering, report response time, endorsement of Option 0 (Q-B9).
- I-12: the backend half of Firebase (sender credential).
- N-1 to N-6: `Retry-After`; the wording-errors batch; `enrolment_opened`; presigned PUT failures, storage host and push limit; the DR-22 / Q-B batch plus chasing S25, S28, S34, S43; the minimum-version signal.

**To the designer** (through Mostafa):
- I-21: every missing frame, the Figma corrections, and the node ids for the University versions and the dark/Arabic frames.
- I-9: node ids for the commissioned subscription screens, and the replacement frame.
- I-8: the deletion request, confirm, cancel and pending frames.
- I-14: the Terms step and the legal viewer.
- I-16: the permission pre-prompt and foreground behaviour.
- I-17: placement, decided jointly with Mostafa (D1–D5, Friends, Blocked, Support, the people icon, forwarding, the share icons).
- I-18: redraw the referral copy once ruled.
- I-20: the copy the designer owns.
- N-15, N-17 (the third card: Rank or Badges), N-19 (empty-pool state), N-20, N-23.

**To Mostafa** (most important first; items for legal are marked so they can be forwarded):
- **Blocking:**
  - B-1: the pin.
  - B-2: the release-1 scope matrix, including push and the Message tab.
  - B-3: the protocol and model roles (Opus / Sonnet / Fable against "Subagents: Sonnet only"), how to divide non-screen work into waves, commit policy, where WALKs run.
- **Important:**
  - I-9: the subscription option.
  - I-12: Firebase ownership and the R-9 gate.
  - I-13: the Mac, the Apple team, the Play account type.
  - I-14: Terms gate shape (parent-consent part → **legal**).
  - I-15: photos of minors → **legal**.
  - I-17: entry points, with the designer.
  - I-18: the referral rule.
  - I-19: when to promote `main`.
  - I-20: copy approvals.
  - I-22: the minors and data-protection memo → **legal**.
  - I-10 (b), (c), (f): the text approver, the entity name, the support contact → **legal**.
  - I-4: the product half (which contact may be shown; approval of the ban copy).
  - I-8: the ruling if Seif insists on the word-for-word text.
  - I-11: Option 0 or report/block (DR-04).
- **Non-blocking:**
  - N-7: who signs product decisions (Mostafa, the client, or "Yousef").
  - N-8 to N-14, N-16 to N-18, N-20 to N-22, N-24 to N-26.
- **Permission to act:** the go-ahead to file the Seif batch (including Q-B1 to Q-B10) in `docs/seif_fight.md`.

## 17. Recommended workflow shape

### 17. Recommended workflow shape

**Basis.** This section is read-only. I used these inputs:
- `syn/Q.md`: B-1 to B-3, I-1 to I-22, N-1 to N-26, DC-1 to DC-24 and AA-1 to AA-55.
- `syn/ERR.md` and `syn/MAT.md`.
- `cor_roadmap_registers.md`, `cor_ci_validation.md`, `cor_git.md`, `cor_env_push_impl.md` and `cor_store.md`.
- The merge-hotspot map that came with the task (SOURCE and EXEC; its merge simulations are synthetic).

I re-read the rule sources directly (DOC):
- `wave_state.md:92-94`
- `implementation_waves.md:1-30`
- `env_chapter_state.md:1-15`
- `AGENT_WORKFLOW.md:17-35`
- `AUDIT_PROTOCOL.md:121-149`
- memory notes `api-ui-wave-workflow-control`, `workflow-script-lf-and-model-pin`, `subagent-file-write-limits` and `concurrent-sessions-repo-etiquette`

On 2026-10-09 `git status --short` showed the repo unchanged at `8e641e9`: 5 modified `contract/*` files and 3 untracked files. I modified nothing.

This section recommends a **shape**. It is not the execution workflow.

---

#### 17.1 Verdict

**I recommend Option C (hybrid), on conditions. The final workflow cannot be generated until B-1, B-2 and B-3 are answered.**

- **Option A (one orchestrated master workflow) is rejected, with high confidence.** Six independent facts rule it out (17.2).
- **Option B in its pure form (independent waves) is rejected.** The waves are not independent. Of the 210 track pairs, 12 are hard conflicts (H) and 30 are hard ordering edges (G). Several invariants span waves: the pin, locks, id counters, generated files and the one device (17.3).
- **Option C** has three parts:
  - One persistent control plane: the owner-commanded orchestrating session, with `wave_state.md` as the single state record.
  - Short, owner-gated wave runs, each executed by Sonnet.
  - Fable audits at defined points.
  - Lanes run in parallel only where the conflict matrix shows no shared code file, and only if B-3 allows it.
- **What changes C under B-3's default.** If B-3 goes unanswered, the stricter existing rules apply: one owner-gated wave at a time, Sonnet-only subagents, no commits without a request (`Q.md:159-162`). C then narrows to a strictly serial chain of waves. The structure is the same; only one lane runs at a time.

---

#### 17.2 Why Option A fails

| # | Evidence (level) | Consequence for a single master run |
|---|---|---|
| 1 | P-1: no wave starts, no WALK runs and nothing advances without the owner's `NEXT`, `WALK` or `FORMULATE` (`wave_state.md:92-94`, DOC; memory `api-ui-wave-workflow-control`) | A master run advances by itself. Only the owner can change P-1 (B-3). |
| 2 | Many external gates, none with a date (Q.md §15):<br>• Seif: I-1 to I-8 and I-11.<br>• The designer: I-21, about 16 frame groups. Designer capacity is recorded nowhere (ERR AF10).<br>• A Mac: I-13.<br>• The Firebase owner: I-12.<br>• The production host: I-2.<br>• Store accounts: DC-20.<br>• The upload keystore: AND-02.<br>• Legal: I-10, I-14, I-15, I-22. | A single run stalls at the first gate it reaches. |
| 3 | The contract moved 8 minor versions (3.39 to 3.46) in about 28 hours (CONTRACT, `git ls-remote`). A re-vendor is its own owner-gated commit (P-6, `implementation_waves.md:28-29`). | A run built against one pin goes stale while it runs. |
| 4 | Runs die when the desktop session ends; keep them under about an hour. A resume re-runs agents that ran concurrently. Subagent writes may not persist. (DOC: memory `workflow-script-lf-and-model-pin` items 3–4; `subagent-file-write-limits`.) | A multi-week master run is not operationally viable. |
| 5 | WALKs need one physical Pixel 8, on the owner's `WALK` (P-5). | Every walk is serialised by a human command. |
| 6 | Scope (B-2) is unratified. No D-001 to D-021 entry covers it, and DR-25 is open. | Neither the wave count nor the wave order can be compiled into one script. |

---

#### 17.3 Why pure Option B fails

- **Shared files make the waves collide (EXEC/SOURCE, hotspot map §2 and §4).**
  - With the de-facto convention of appending at the tail, every pair of feature tracks collides on about seven universal hotspots: ARB plus the generated l10n, `mock_backend.dart`, `app_router.dart`, `session_scope.dart`, `app_colors.dart`, `pubspec.yaml`, and the doc logs with sequential ids.
  - In the simulation, each tail-vs-tail pair conflicted. Feature-local anchors removed the conflict in 5 of the 5 pairs retested.
  - K4 = {T02, T10, T11, T12} is H on all 6 of its pairs.
- **The precedent: hand-split commits and a published hold (DOC/SOURCE).**
  - Waves 20 to 22 had to be hand-split in exactly those files (`a988a1f` and `fa88b3a` bodies).
  - In 2026-10-06, an owner hold given to one session was invisible to a peer session. The peer published an uninspected commit (memory `concurrent-sessions-repo-etiquette`).
  - So a single, shared state and lock record is required.
- **Some invariants belong to no single wave:**
  - the pin: T01 is G for T02 to T17;
  - id counters: DESIGN_ISSUES #127, S46, BUG-026, D-022, R-12;
  - regenerating generated files (22 `*.freezed`, 20 `*.g`, 3 l10n files, 43 goldens);
  - scheduling the device;
  - reading CI after each push;
  - contract-guard bindings.
- **Nothing enforces any of this technically.**
  - The hooks are inactive (`core.hooksPath` unset; files stored as mode 100644).
  - No branch is protected.
  - `tool/validate.sh` cannot pass on Windows Git Bash.

  (BUILD/CI, `cor_ci_validation.md` §0 and §2.2.) Coordination therefore has to be a process, and a process needs one holder. That holder is the control plane in C.

---

#### 17.4 Track dependency graph and external gates

Track ids T01 to T21 are those of the hotspot map. In the graph below, an arrow means a hard ordering (G).

```
T01 pin (exclusive; B-1)
 ├─> T02 conformance/infra ─> T10 Terms/legal ─> T11 deletion/cancel ─> T12 recovery    [lane A, K4 serial]
 │                                └─> T08 support(+photos), T09 avatar   (Terms 403 gate)
 ├─> T03 inbox <─DC-12─> T06 chat ; T05 friends ─> T06 ─> T07 forward/streaks ; T15 ─> T07   [lane B]
 ├─> T16 rank/summary ─ T13 track transfer ─ T14 referral ─ T17 modules (M edges only)     [lane D]
 └─> T04 push (also needs T02: return-to-target and errorBuilder)
T18 Env W2 ─> T19 iOS W3 [Mac] ─> T04 push ─> T20 signing/AAB ─> T21 store             [lane C]
T04, T08, T09, T10, T11, T19, T20 ─> T21 (store last)
```

| Track | Hard predecessors (G) | Owner gates | Seif | Designer / legal | Platform / infra |
|---|---|---|---|---|---|
| T01 contract | none | B-1 (DC-13) | I-1 (freeze, option c) | — | `git ls-remote`; BUILD dry run at the pin (none exists at 3.46, ERR AF4) |
| T02 infra (`Accept` header, unknown-outcome rule, global 403 routing for `account_banned` and `account_pending_deletion`, `errorBuilder`, return-to-target) | T01 | B-2 row 0b (required at pin ≥ 3.42) | I-4 (signed-out support channel) | Ban copy and frame (I-20, I-21) | — |
| T03 inbox | T01 | B-2 rows 10 and 15 (DC-12); I-17 D1–D5 | N-3 | I-20 (kind copy); dark/AR node ids | — |
| T04 push | T01, T02, T18; iOS leg T19 | B-2 row 11 (DC-10); I-12 (lift R-9); I-16; N-13; N-14 | I-3 (FCM token at sign-out); I-6(d) (delivery on) | I-16 pre-prompt | Firebase projects; APNs under the Apple team (I-13) |
| T05 friends and blocks | T01 | B-2 row 4; I-17; I-11 | I-6(b) seeded states | I-21 (decline, my friends, blocked list); I-22 | — |
| T06 chat and hub | T01, T05 | B-2 rows 5 and 15; N-13 (SignalR spike); AF6 (FLAG_SECURE on cards) | I-11; I-6(b) | I-21; I-22 | The mock cannot fake a WebSocket, so a fake hub is needed |
| T07 forward and streaks | T05, T06, after T15 | I-17 (placement) | — | I-21 | — |
| T08 support (+photos) | T01; photos also T10 | B-2 rows 6 and 7; I-15 | N-4 | I-20; I-21 (status labels) | Picker dependency (N-13) |
| T09 avatar | T01, T10 | B-2 row 8; I-15 | — | I-21 (crop, remove, rejected) | Picker dependency |
| T10 Terms/legal | T01, after T02 | B-2 row 1; I-14 | N-2 (c), (d) | I-21; I-10 (public URLs, store half) | Markdown dependency |
| T11 deletion/cancel | T01, after T10 | B-2 row 0a (store-mandatory) | I-8 (safe confirm text) | I-8 frames; DC-11 | — |
| T12 recovery | T01, after T11 | B-2 row 2 | I-4 (`recovery_unavailable`) | I-21; I-20 | — |
| T13 track transfer | T01 | B-2 row 3; DC-9 (eligibility) | — | I-21 | — |
| T14 referral | T01 | B-2 row 9; I-18 (DC-1) | I-5 (University `inviteCode`) | I-18 redraw | Share dependency |
| T15 history and favourites | T01 | B-2 rows 12 and 13; DR-19 | N-19 | I-21 (history and favourites lists) | — |
| T16 rank and summary | T01 | N-17, N-18 (reopening #101 and D-008, DC-22) | S25 | Third card: Rank or Badges | — |
| T17 modules | T01 | B-2 row 14 | — | I-21 (module picker) | — |
| T18 Env Wave 2 | none | — | I-2 (prod host, for the prod config) | — | — |
| T19 iOS Wave 3 | T18 | I-13; DC-4; DR-02 (E-4) | — | — | A Mac with Xcode 26 (none known); SOURCE-only otherwise |
| T20 signing/AAB | T18 | N-12; I-19 (`main` promotion) | — | — | Keystore and Play App Signing (AND-02, owner custody) |
| T21 store | T04, T08–T11, T19, T20 | DC-20; I-22 | I-2 (E-6 reviewer numbers); I-10 (d) | I-10 | Store accounts (Claude creates no account) |

---

#### 17.5 What can run in parallel

- **Env/release vs screen tracks.** T18 to T21 share no code file with T05 to T17. There are two exceptions:
  - T08 and T09 have a conditional M edge to T19: `Info.plist` photo-usage keys, only if the picker needs them (anchor A19b, `mc/matrix.py:38`).
  - T08 and T09 are G into T21.
  - Note: the scratch rendering `mc/matrix_out.md` shows that edge under T18/T20 instead of T19. The anchor key and the task's table agree on T19.
- **T18 needs no pin** (T01–T18 is '.'), so Env Wave 2 can start before or beside T01.
- **Tracks with no H edge:** T01, T05, T08, T09, T13, T14, T16, T17, T20, T21. Lane D is internally M-only.
- **Work with no code-file conflict,** each item needing the owner's go:
  - the docs-reconciliation commit (`cor_git` §11 step 7; ERR A1 and C1–C2);
  - the `xargs -s 7000` tooling patch (`cor_git` §7; N-9);
  - sending the Seif, designer and legal batches (`Q.md` "Message batches"; filing in `seif_fight.md` is a repo write).
- **What actually limits parallelism:**
  - P-1 serialises wave starts.
  - P-2 makes screen waves serial anyway.
  - One device serialises every WALK.

  The realistic width is therefore one screen wave plus one non-screen wave, for example T02, T18, T19 at SOURCE level, T20, or tooling. Even that holds only if B-3(b) admits non-screen waves beside a screen wave. The hotspot map's "up to 3 code lanes (A, B, C) plus D" (§5.4) is a technical ceiling, not a protocol-permitted one.

---

#### 17.6 Controls against merge conflicts (from the hotspot map §5)

The control plane holds the lock table and the id allocation in `wave_state.md`. They are enforced by process, because no hook or branch protection exists.

| Lock | What it covers | Order |
|---|---|---|
| L-CONTRACT | `contract/**`, contract-guard bindings, fixtures | T01 only; everything else waits for its commit |
| L-AUTH-ROUTER | `authRedirect`, `_authRoutes`, `GoRouter(` arguments, `/home` landings, `auth_controller`, `error_interceptor`, `exceptions`, the `session_scope_discipline_test:182-190` call count | T02, then T10, T11, T12 one at a time; T04 consumes |
| L-MESSAGE-SLOT and L-HOME-HARNESS | The `/message` builder, `main_shell`, 10 nav goldens, the 6 harness override anchors | Order follows DC-12; T03, T06 and T15 run serially |
| L-QUIZ-REVIEW | Quiz review and question UI | T15, then T07 |
| L-BOOT-BUILD and L-IOS | Boot and config files; `ios/**` | T18, then T19 (Mac), then the T04 legs |
| L-SHELLS-PROFILE, L-TOKENS, L-REGISTRY | Shared shells, profile hub, tokens, session registry | Short critical sections, each track using its own block |

Rules for every wave:
- Insert next to your own siblings, never at the tail.
- Never hand-merge generated files. Regenerate them: `pub get`, `build_runner`, `gen-l10n`, goldens.
- Run `dart format` on untracked new files too. The precedents are `56f74e7` and `f10b112`.
- One scribe writes the logs.
- Pre-allocate id ranges per track.
- Prefer new files over extending hubs; for example, do not grow `ProfileRepository` (A15).
- Never `git add -A` while `contract/*` is dirty.

---

#### 17.7 Model roles, and where they conflict with the standing rule

| Role | Where it sits in C | Evidence | Conflict with "Subagents: Sonnet only" (`wave_state.md:93`, P-3)? |
|---|---|---|---|
| **Opus orchestrates** | The owner-commanded main session (the control plane). It does not decide; it prepares and sequences. | DC-16: "the orchestrating session is not a subagent" (`Q.md:612`) | **None,** as long as Opus is the main session. **Conflict** if Opus is spawned as a subagent (for example a planner subagent). |
| **Sonnet executes** | The implementation and verification subagents inside each wave run | P-3. Precedent: Wave 22 used "two read-only Sonnet verifiers" (`wave_state.md:86-88`) | None |
| **Fable audits** | Defined audit points (17.8) | `AUDIT_PROTOCOL.md:121-149` (ten-item hand-off; "Fable verifies, never trusts"); `AGENT_WORKFLOW.md:19` "FABLE (when required)" | **Conflict** if Fable runs as a subagent of the workflow: P-3 has no exception. **No conflict** if Fable stays the separate hand-off pass of `AUDIT_PROTOCOL.md`. How often Fable audits is also undefined (`cor_ci_validation.md` §7). |

**I state the conflict explicitly.** The brief's split (Opus orchestration, Sonnet execution, Fable audit) clashes with the recorded rule at exactly two points:
- any Fable auditor run as a subagent;
- any Opus subagent.

Only the owner can resolve it (B-3(a), DC-16). Claude must not reinterpret P-3. If unanswered, Fable runs outside subagents (`Q.md:159-162`).

Two more facts bear on the ruling:
- The rule was written for the API-to-UI wave workflow. Whether it binds the new completion workflow is part of B-3(a).
- This discovery audit itself used Fable verifiers: every `cor_*.md` carries a "Verification (Fable)" header. A Fable pass has also written code before: `56f74e7` formatted a file "committed unformatted by the Fable pass", and CI run #14 failed on it. So if Fable writes anything, its output must pass the same gates. Keeping Fable read-only is an option for the owner, not a recommendation I can make.

Every agent call in any workflow script must pin `model:` (memory `workflow-script-lf-and-model-pin` item 2). That makes the role split mechanically checkable.

---

#### 17.8 Where Fable should audit

These are proposed points. How often Fable audits is B-3(a); each audit uses the `AUDIT_PROTOCOL.md` ten-item hand-off.

1. **T01 close: pin integrity.** No mechanised check exists for any of these (`cor_ci_validation.md` §4):
   - each file's `git hash-object` equals the upstream blob;
   - the carriage-return count is 0 (the CRLF hazard broke 13 of 14 guards in the dry run);
   - `SOURCE.md` is consistent, with the `:17` CRLF sentence fixed;
   - the contract guard passes 14/14;
   - the re-census is recorded.
2. **T02 close: the foundation of the K4 chain.** The error layer, global 403 routing, the `invalidateSessionScope` call count, `errorBuilder` and return-to-target.
3. **Each lane-A wave (T10, T11, T12).** Redirect semantics; the token purge after deletion (AA-18); PII providers in recovery.
4. **Privacy-sensitive waves:**
   - T04: the FCM token at sign-out (I-3), minors.
   - T06: the token in the hub URL query, UGC, FLAG_SECURE on forwarded cards (AF6).
   - T08 and T09: photos of minors, the Terms 403 gate.
5. **Integration after each lock hand-over:** a rebase plus regenerated files.
6. **Release candidate:**
   - G-03 (pin equals upstream HEAD);
   - a flavour AAB inspected with `aapt2`;
   - `verify_guards.ps1` N/N;
   - the extended smoke harness;
   - the device walk on staging;
   - `main` promoted.

---

#### 17.9 Where real-device verification is required

- **Every UI wave's WALK** runs on the physical Pixel 8 (Android 17 / API 37, USB; adb is not on PATH), scored F/V/I (P-5).
  - The device comes and goes: it was absent at 2026-10-08 22:03 (ERR A18), so re-check at every WALK.
  - The documented WALK command is stale and needs `--flavor staging -t lib/main_mock.dart` (`implementation_waves.md:20`; `build.gradle.kts:119-131`).
  - The mock and staging builds share `.stg`, so each install replaces the other.
- **No physical-device run against a real server exists** (ERR A3). The staging release walk ran on the `Pixel_8` AVD. A physical-device staging walk is therefore owed before the release candidate.
- **New surfaces have nowhere to be walked yet.**
  - The mock covers none of the 3.39–3.46 operations; chat cannot be mocked; push cannot reach DEVICE level while delivery is off (`realtime.md@eddb6ac:80`).
  - Staging seeds are missing (I-6).
  - Whether WALKs move to staging is B-3(d).
- **Release:** the prod identity has never been installed. A side-by-side check of both identities and a prod-flavour run are needed (Env Wave 4; R-4).
- **FLAG_SECURE** blacks out screencaps on the quiz screens. It would do the same in chat if extended there (AF6).
- **iOS:** no iOS device and no Mac are known. iOS work is SOURCE-only and must never be reported as BUILD or DEVICE.

---

#### 17.10 Backend-contract gates

**At the start of every wave:**
1. Run `git ls-remote` on the contract repo and compare its HEAD with the pin. Moving pin versus frozen pin is a sub-question of B-1.
2. Check that each of the wave's operations is `x-stability: stable` at the pin and is NOT `x-consumers: [web]`-only (the rule in `contract/SOURCE.md:12-13`). An absent `x-consumers` key means mobile: 72 of the 86 operations at `eddb6ac` carry none, including every operation the app consumes today; only the 4 web-only operations are excluded. (Corrected after the Fable audit.)
3. For every new response schema, add a `contract_models_test` binding and a mutation probe.
   - Today the guard binds 13 schema paths across 7 top-level schemas.
   - At 3.46, 27 of the 34 directly returned schemas that carry a `required` list are unbound (ERR B24).
   - Passing the guard says nothing about the new models until they are bound.
4. Missing or ambiguous shapes go to `seif_fight.md`, never invented. Filing needs the owner's go.

**For a re-vendor:**
- It is its own commit (P-6).
- Copy LF blobs from `git show`.
- Run a BUILD dry run in a clone first. None exists at 3.46.
- Do not run `git restore contract/` before the B-1 ruling (`cor_git.md` §11).

---

#### 17.11 Git checkpoints

**Every wave:**
- Take a `git status` and `git diff` fingerprint before and after.
- Run `ListAgents` and announce the file list.
- One concern per commit.
- Run `validate.ps1` with `LEVELUP_VALIDATE_OUT` set, so the tracked `test-results.md` stays untouched. Check that:
  - the pass count is at least 2067 plus the wave's new tests;
  - the guards, run alone, pass (122 or more);
  - `pubspec.lock` has no diff.
- After a push, quote `gh run view` at CI level.

**When to commit:** this is B-3(c). The evidence favours a focused commit per wave, as the Env chapter does (P-8). The 4 checkpoint commits of the API-to-UI waves forced hand-splits (`a988a1f`, `fa88b3a`). The ruling is still the owner's.

**Push:** each push needs the owner's permission (DC-19).

**`main`:** `--ff-only`, on the owner's word only. The evidence favours promoting before the first store build (I-19), for two reasons:
- The release gate has never run in CI in its flavoured form (the two `main` runs predate `2dfd969`).
- `ubuntu-latest` moves to Ubuntu 26 from 2026-10-19 (ERR AF13).

Never force-push. `dev` stays frozen.

**Owner holds** are written to `wave_state.md` so peer sessions can see them.

---

#### 17.12 Preconditions before the final workflow can be generated

1. **B-1: the pin.** Choose option (a), (b) or (c), and whether the pin moves or is frozen. If (c), Seif must answer I-1 first.
2. **B-2: the scope matrix.** Rows 1 to 16 need an answer; rows 0a and 0b are already required. Row 11 (push, DC-10) and row 15 (the Message tab, DC-12) change the lane structure.
3. **B-3: the protocol.**
   - (a) Model roles, where Fable sits, and how often it audits.
   - (b) How multi-screen and non-screen work divide into waves.
   - (c) The commit policy.
   - (d) Whether WALKs run on staging or the mock is extended first.
4. **Repo truth.**
   - Push or hold `8e641e9`.
   - Decide the contract working tree.
   - Decide the 3 untracked files: the roadmap pair (N-8) and `PRE_EXECUTION_DISCOVERY.md` (AF12).
   - Land the docs-reconciliation commit (stale `wave_state.md` lines, `WAVE_STATUS.md`, R-3, the CLAUDE.md "849" floor). Waves read these files as state.
5. **A BUILD dry run at the chosen pin.**
6. **Conflict conventions adopted in the FORMULATE:** anchor discipline, id ranges, one scribe, the lock table.
7. **The message batches sent** (with the owner's go), so each blocked wave can be dated.

The I-items do **not** block generating the workflow. They block named waves, and the workflow must mark each such wave as blocked on its item.

---

#### 17.13 Phase skeleton (shape only, not the workflow)

| Phase | Entry gate | Exit gate | Parallel lanes (if B-3 allows) | Roles |
|---|---|---|---|---|
| 0. Rulings and truth sync | Discovery accepted by the owner | B-1 to B-3 recorded in `DECISIONS.md` and `wave_state.md`; repo-truth items decided; batches sent | Docs/tooling commits; T18 at SOURCE level | Opus prepares, the owner decides |
| 1. Contract gate (T01) | B-1; `ls-remote`; clean contract dry run | Pin committed (own commit); guard 14/14; re-census; Fable pin audit; CI green if pushed | T18 (needs no pin) | Opus, Sonnet, Fable |
| 2. Foundations (T02 and guard harness) | Phase 1 exit; owner `NEXT` | `Accept` header, unknown-outcome rule, 403 routing, `errorBuilder`, return-to-target; binding pattern and shared hold helper; validate and guards; Fable | T18; tooling | Opus, Sonnet, Fable |
| 3. Feature waves by lane | Phase 2 exit; each wave's owner gates and frames ready; owner `NEXT` | Each wave: contract gate, then build, then validate, then owner `WALK` on the Pixel 8, then Fable (per cadence), then commit (per policy) | Lane A (T10, T11, T12; T08 and T09 after T10); lane B (DC-12 order; T05, T06, T07; T15 before T07); lane D (T16, T13, T14, T17); beside them lane C (T19 SOURCE-only without a Mac, T04 after T18/T02, T20). The device and P-1 serialise WALKs | Opus, Sonnet, Fable |
| 4. Release candidate | All B-2 SHIP rows closed | G-03; extended smoke run; physical-device staging walk; prod identity installed; flavour AAB (`aapt2`); signed by the owner's keystore; `main` ff-only on the owner's word, then the flavoured CI release gate; iOS on a Mac if available; Fable RC hand-off | — | Opus, Sonnet, Fable; owner actions |
| 5. Store submission (T21) | E-1 to E-8 closed; accounts exist (owner) | Console forms filed by the owner | — | Claude drafts text only |

---

#### 17.14 Confidence

- **Rejecting A: HIGH.** Six independent DOC, CONTRACT and BUILD facts.
- **C over pure B: MEDIUM.** It rests on the conflict matrix (synthetic EXEC simulations, SOURCE anchors) and on DOC precedent.
- **Lane widths and order: LOW.** They are conditional on B-2, DC-12 and B-3.

No BUILD, DEVICE or CI evidence was produced in this section.


### 17.x Merge-conflict hotspots
#### Merge-conflict hotspots and shared-file map

**Basis.** Read-only audit of `merged@8e641e9`. Evidence levels used: SOURCE (files read), DOC (repo documents), CONTRACT (vendored or upstream YAML), and EXEC (a command run on real HEAD blobs). The EXEC items are `git merge-file` simulations with synthetic edits at the anchors a track would have to use. They are not the real implementations, and no level above SOURCE is claimed for them.

**Repo not touched.** `git status --short` was identical before and after: 5 modified `contract/*` files plus 3 untracked files. All helper scripts and outputs are in the scratchpad under `mc/`.

**Two things the raw counts hide.**
- The 22 API→UI waves were committed as four "checkpoint" commits (`cccd2f1` = Waves 01–19, `a988a1f` = W22, `fa88b3a` = W20, `af0eadb` = W21). Per-file commit counts therefore under-state how often a file was edited. The wave bodies document that Waves 20–22 had to be hand-split in exactly the files below.
- 24 commits exist since 2026-09-24, touching 268 unique paths (237 excluding 31 launcher-icon rasters).

---

##### 1. Counts

###### 1.1 Top 30 shared files since 2026-09-24 (`git log --since=2026-09-24 --name-only --format=`)

Columns: "Since" = commits touching the file out of 24. "Ckpt" = how many of the 4 checkpoint commits touch it. "All" = all-time commits. "±lines" = lines added plus deleted across the 4 checkpoints. GEN = generated.

| # | File | Since | Ckpt | All | ±lines | Note |
|---|---|---|---|---|---|---|
| 1 | `docs/KNOWN_BUGS.md` | 6 | 4 | 8 | 513 | append log; next id BUG-026 |
| 2 | `docs/DESIGN_ISSUES.md` | 5 | 4 | 23 | 891 | append log; next id #127 |
| 3 | `test/core/theme/app_colors_test.dart` | 5 | 4 | 11 | 374 | one `group('Wave N …')` per wave (:593, :640, :702) |
| 4 | `.ai/audits/current/wave_state.md` | 5 | 4 | 5 | 1854 | wave record |
| 5 | `.ai/audits/current/test-results.md` | 5 | 3 | 19 | 10970 | **GEN (`tool/validate.ps1` rewrites it, tracked)** |
| 6 | `lib/core/theme/app_colors.dart` | 4 | 4 | 22 | 967 | 2860-line ThemeExtension: field, ctor, copyWith, lerp, light, dark per token |
| 7 | `docs/seif_fight.md` | 4 | 4 | 10 | 76 | append log; next id S46 |
| 8 | `.ai/audits/current/device_walk_results.md` | 4 | 4 | 4 | 1503 | |
| 9 | `.ai/audits/current/implementation_waves.md` | 4 | 4 | 4 | 505 | |
| 10 | `docs/WAVE_STATUS.md` | 4 | 0 | 10 | 0 | touched by "sync" commits, e.g. `e6e6567` |
| 11 | `.ai/audits/current/env_chapter_state.md` | 4 | 0 | 4 | 0 | Env chapter |
| 12 | `lib/l10n/app_ar.arb` | 3 | 3 | 24 | 19 | 272 keys; last key has no comma |
| 13 | `lib/l10n/app_localizations_ar.dart` | 3 | 3 | 23 | 55 | **GEN (gen-l10n, tracked)** |
| 14 | `lib/dev/mock_backend.dart` | 3 | 3 | 14 | 769 | 2765 lines; one `onRequest` if-chain `:156-549`, 404 fall-through `:551-559` |
| 15 | `contract/SOURCE.md` | 3 | 2 | 9 | 79 | |
| 16 | `contract/contract-changelog.md` | 3 | 2 | 9 | 39 | |
| 17 | `contract/openapi.yaml` | 3 | 2 | 9 | 354 | now dirty in working tree (+1498/-217 over 5 files) |
| 18 | `docs/DECISIONS.md` | 3 | 1 | 12 | 214 | next id D-022 |
| 19 | `docs/RISKS.md` | 3 | 0 | 7 | 0 | next id R-12 |
| 20 | `docs/ENVIRONMENTS.md` | 3 | 0 | 3 | 0 | Env chapter |
| 21 | `lib/core/router/app_router.dart` | 2 | 2 | 24 | 65 | 499 lines; one `GoRouter(routes:[…])` literal |
| 22 | `lib/l10n/app_en.arb` | 2 | 2 | 23 | 76 | 735 lines (carries `@metadata`) |
| 23 | `lib/l10n/app_localizations.dart` | 2 | 2 | 22 | 86 | **GEN** |
| 24 | `lib/l10n/app_localizations_en.dart` | 2 | 2 | 22 | 60 | **GEN** |
| 25 | `lib/features/quiz/screens/quiz_screen.dart` | 2 | 2 | 9 | 530 | |
| 26 | `lib/features/home/screens/home_screen.dart` | 2 | 2 | 7 | 32 | |
| 27 | `test/features/catalog/lectures_screen_test.dart` | 2 | 2 | 6 | 603 | |
| 28 | `docs/ASSET_MANIFEST.md` | 2 | 2 | 5 | 3 | |
| 29 | `test/features/settings/settings_harness.dart` | 2 | 2 | 5 | 23 | harness helper |
| 30 | `lib/core/theme/app_elevation.dart` | 2 | 2 | 4 | 78 | 2174 lines |

Concurrency profile:
- 53 non-icon files were touched by 2 or more commits, 20 by 3 or more, and 11 by 4 or more.
- Others touched since 09-24 (2 commits each): `test/guards/{rules.dart,rules_test.dart,project_rules_test.dart}`, `tool/verify_guards.ps1`, `pubspec.yaml`, `test/features/profile/profile_screen_test.dart`, `test/core/widgets/shared_chrome_test.dart`.

###### 1.2 The four checkpoint commits, separately (`git show --name-only --format= <sha>`)

| Commit | Scope | Files (lib / test / docs+.ai) |
|---|---|---|
| `cccd2f1` | Waves 01–19, pin 3.23.0-m1 | 143 (58 / 62 / 14) |
| `a988a1f` | Wave 22 + BUG-020 | 57 (28 / 16 / 8) |
| `fa88b3a` | Wave 20 Edit Profile | 17 (6 / 3 / 7) |
| `af0eadb` | Wave 21 Settings | 21 (6 / 7 / 8) |

- The union is 189 files. 29 are in at least 2 checkpoints, 12 in at least 3, and 8 in all 4.
- **In all 4:** `device_walk_results.md`, `implementation_waves.md`, `wave_state.md`, `DESIGN_ISSUES.md`, `KNOWN_BUGS.md`, `seif_fight.md`, `lib/core/theme/app_colors.dart`, `test/core/theme/app_colors_test.dart`.
- **In 3:** `test-results.md`, `lib/dev/mock_backend.dart`, `lib/l10n/app_ar.arb`, `lib/l10n/app_localizations_ar.dart`.
- **In 2:** `app_router.dart`, `app_en.arb`, `app_localizations.dart`, `app_localizations_en.dart`, `home_screen.dart`, `quiz_screen.dart`, `settings_harness.dart`, `app_elevation.dart`, `app_elevation_test.dart`, `lectures_screen.dart`, `lectures_screen_test.dart`, `subject_tree_screen.dart`, `subject_tree_layout_test.dart`, `ASSET_MANIFEST.md`, `contract/{openapi.yaml,SOURCE.md,contract-changelog.md}`.

Hunk sizes in the hot files (`git show --numstat`):
- Router: +34/-4 (`cccd2f1`), +27/-0 (`a988a1f`).
- Mock backend: +16, +566/-44, +123/-19.
- `app_en.arb`: +35/-2, +39.
- `app_ar.arb`: +6, +9, +1/-1.
- `session_scope.dart`: +3 (`cccd2f1` only).
- `profile_screen.dart`: +56/-10 (`cccd2f1` only).
- All ARB and router additions are tail or sibling appends.

DOC evidence that these files are the real conflict set:
- `a988a1f` body: "In the files the waves share (app_colors.dart, mock_backend.dart, app_ar.arb, the token test, the docs and the audit records) this commit is HEAD plus Wave 22's hunks. The generated l10n was regenerated from these ARBs, not spliced."
- `fa88b3a` body: "app_colors.dart, app_colors_test.dart, wave_state.md, device_walk_results.md, implementation_waves.md, DESIGN_ISSUES.md, KNOWN_BUGS.md, seif_fight.md … built by insertion … Wave 20's block came first at every seam."
- `56f74e7` (a file "committed unformatted by the Fable pass") and `f10b112` (the CI format failure) show the same hazard on untracked files.

###### 1.3 Low-churn but high-fan-in files (structural hotspots)

| File | Commits since 09-24 / all | Why it is a hotspot |
|---|---|---|
| `lib/core/session/session_scope.dart` | 1 / 3 | 13 `ref.invalidate(` lines (`:63-102`) is the session inventory. `session_scope_discipline_test.dart` parses it and fails on any non-`autoDispose` stateful provider that is neither invalidated here nor exempted in the test (`notSessionScoped` `:25-49`). |
| `lib/features/auth/notifier/auth_controller.dart` | 0 / 2 | The guard asserts exactly 2 `invalidateSessionScope(` calls (`session_scope_discipline_test.dart:182-190`). `LogoutReason` is switched exhaustively in `login_screen.dart:66-70`. |
| `lib/features/profile/screens/profile_screen.dart` | 1 / 6 | `_Menu` rows `:230-323`: settings, favorites, progress, refer, support, privacy, terms, go_to_uni, logout. Paired with `profile_screen_test.dart` (923 lines). |
| `test/features/profile/profile_fixtures.dart` | 1 / 6 | `holdProfile` (`:124`); about 22 test files reference it (`grep -rl` by basename). |
| `test/features/leaderboard/leaderboard_fixtures.dart` | 1 / 2 | `holdBoards` (`:61`); about 13 test files reference it. |
| Harnesses: `profile_harness.dart` (270 lines), `catalog_harness.dart`, `quiz_harness.dart`, `settings_harness.dart` | 1–2 each | They boot the real router signed in. `holdBoards` is called at `profile_harness:78,126,176`, `catalog_harness:80`, `quiz_harness:105`, `settings_harness:63`. A new autoDispose provider watched from Home or the shell hits the same teardown trap (memory note "autoDispose on Home breaks harness teardown"). |
| `app_router.dart` | 2 / 24 | 17 test files reference `routerProvider`, `LevelUpApp` or `authRedirect` (grep). |
| `lib/dev/mock_backend.dart` | 3 / 14 | 5 test files (`test/dev/mock_backend_*_test.dart`) plus `lib/main_mock.dart`. |
| `pubspec.yaml` / `pubspec.lock` | 2 / 10 | Only 10 commits ever, but every dependency-adding track writes the `dependencies:` block. The lock is CI-gated for drift. |

###### 1.4 Generated or derived files, and the CI gates

| Kind | Count | Gate (`.github/workflows/ci.yml`) |
|---|---|---|
| `*.freezed.dart` | 22 tracked | `codegen-drift` job `:260-316`, main push and `workflow_dispatch` only. Stale generated models on `merged` are not caught until promotion. |
| `*.g.dart` | 20 tracked | same |
| `lib/l10n/app_localizations{,_ar,_en}.dart` | 3 tracked | "Localizations are up to date" `:158-169`, every push (`flutter gen-l10n` then `git diff --quiet -- lib/l10n`) |
| `pubspec.lock` | 1 | "Lockfile did not drift" `:146-156`, every push |
| `.ai/audits/current/test-results.md` | 1 | no gate. `tool/validate.ps1` and `validate.sh` rewrite it by default; `LEVELUP_VALIDATE_OUT` redirects (`validate.ps1:36-37`, `validate.sh:30-31`). |
| Golden PNGs | 43 | Windows job, advisory. `nav_bar_{light,dark}_tab0..4` is 10 files, `home_header_bell_{light,dark}` is 2. |
| Launcher icons | 31 rasters in the window | `flutter_launcher_icons` (re-breaks `project.pbxproj` per memory) |

Binary and generated merges must be regenerated, never hand-merged.

---

##### 2. Why they conflict: anchors and executed simulations

**Anchors (SOURCE).**
- **ARB:** both files end at `flashcardPreviewUsedUp` with no trailing comma. Every "append a key" edit also edits that last line (comma) and the closing brace.
- **Generated l10n:** getters are emitted in ARB order. After the last key (`app_localizations.dart`: `String get flashcardPreviewUsedUp;`) every append lands at the same place in all three generated files.
- **Mock:** all routes are one if-chain. The fall-through comment `// Anything not mocked fails loudly…` (`:551`) is where "add my routes at the end" lands.
- **Router:**
  - Imports are alphabetical.
  - `routes:[…]` ends at `/legal/terms` (`:431-435`).
  - The `/message` branch builder is one line (`:314-315`).
  - `authRedirect` is `:74-83` and `_authRoutes` is `:52`.
  - The `GoRouter(` constructor takes only `initialLocation`, `refreshListenable` and `redirect` (`:108-112`). There is no `errorBuilder`, `onException` or `errorPageBuilder` anywhere in `lib/` (grep).
  - `/home` is hard-coded at `otp_screen.dart:122`, `school_detail_screen.dart:362`, `university_detail_screen.dart:328` and `app_router.dart:80`.
- **Session scope:** the list is a flat tail after `ref.invalidate(quizSetupProvider);`, with six comment-headed blocks above it.
- **pubspec:** dependencies are appended after `cached_network_image` (`:61`). Asset directories are not recursive, so a new `assets/icons/<x>/` folder needs its own `assets:` line (`:146-150`).

**Executed simulations (EXEC).** Method: `git show HEAD:<path>` for the base blob, two synthetic edits A and B, then `git merge-file -p A base B`. The exit code is the number of conflict hunks. Scripts: `scratchpad/mc/mergesim.py`, `mergesim2.py`, `mergesim3.py`.

| File | Scenario | Conflicts |
|---|---|---|
| `app_en.arb`, `app_ar.arb` | both append 2 keys at EOF | **1 each** |
| same | one appends at EOF, one inserts after `leaderboardShare` | 0 |
| `app_localizations.dart`, `app_localizations_en.dart` | both add a getter after the last key | **1 each** |
| `app_router.dart` | both append a top-level route after `/legal/terms` | **1** |
| `app_router.dart` | inbox and chat both replace the `/message` builder line | **1** |
| `app_router.dart` | terms gate and pending-deletion both extend the tail of `authRedirect` | **1** |
| `app_router.dart` | two imports with the same alphabetical neighbour | **1** |
| `app_router.dart` | recovery edits `_authRoutes`; return-to-target edits the `authRedirect` signature | 0 (textually clean, semantically coupled) |
| `mock_backend.dart` | both add a block before the 404 fall-through | **1** |
| `session_scope.dart` | both append an invalidate after `quizSetupProvider` | **1** (**2** with the import line) |
| `session_scope_discipline_test.dart` | both add an exemption at the end of `notSessionScoped` | **1** |
| `profile_screen.dart` | two new rows after the Settings row | **1** |
| `profile_screen.dart` | support-row `onTap` vs refer-row `onTap` | 0 |
| `pubspec.yaml` | both add a dependency after `cached_network_image` | **1** |
| `profile_harness.dart` | both add a repository override after the leaderboard override | **3** (3 pump functions carry the anchor) |
| `shell_screens_test.dart` | retire `/support` vs `/friends` (adjacent map entries) | **1** |
| same | retire `/refer` vs `/legal/terms` (4 lines apart) | 0 |
| `main_shell.dart` | inbox and chat both relabel the Message destination | **1** |
| `auth_controller.dart` | `accountBanned` vs `accountDeleted` on the `LogoutReason` line | **1** |
| `error_interceptor.dart` | two typed arms before the default arm | **1** |
| `pubspec.yaml` | version bump vs a dependency (distant hunks) | 0 |
| `ci.yml` | `build-release-apk` edit vs the analyze step | 0 |
| **Distinct anchors** (mock sibling block, router sibling, own session-scope comment block, earlier pubspec line, head vs tail of the exemption map) | each pair of tail vs sibling edits | **0 of 5** |

Reading: conflicts are driven by the choice of insertion anchor, not by the amount of change. The repo's de-facto convention ("append at the end") makes every pair of feature tracks collide on about seven files. Feature-local anchors removed all five conflicts that were retested (mock, router, session scope, pubspec, exemption map).

---

##### 3. Per-track shared-file map

Track ids T01–T21 follow the order in the task. "New" files are conflict-free by construction. Entries marked [INFERRED] depend on a placement or pattern decision not yet made.

###### 3.1 Table A: shared production and config files

| Track | Shared files it must edit (anchor) | Generated or regenerated |
|---|---|---|
| **T01 Contract re-vendor** | `contract/{openapi.yaml,SOURCE.md,contract-changelog.md,error-codes.md,realtime.md}` (already dirty in the working tree); `mock_backend.dart` header pin text `:17-19` (still quotes `f462968`/3.27.0-m1); `docs/seif_fight.md`, `docs/WAVE_STATUS.md` | none expected: StudentProfile, EntitlementState, ProblemDetails, Quiz, QuizSummary and LeaderboardEntry are unchanged 3.28→3.46. `SchoolRegistration`/`UniversityRegistration` gain `inviteCode` and `AuthenticatedResult` gains `inviteCodeApplied` (additive). |
| **T02 Infra** | `dio_client.dart:19` (`_baseOptions`, shared by `create` + `createBare`) and the mock's own `buildMockDio` BaseOptions; `error_interceptor.dart:9-10` comment and the `:29-41` status switch; `exceptions.dart` (typed arms, `isAccountPendingDeletion` seam `:134`); `auth_interceptor.dart:70-72` (early return on non-401, so 403 never reaches it); `auth_controller.dart:25-27`; `login_screen.dart:66-70`; `auth_error_copy.dart`; `app_router.dart:52,56,74-83`, `:108-112` (errorBuilder, global 403), and the `/home` landings (`otp_screen:122`, `school_detail:362`, `university_detail:328`); ARB | l10n ×3 |
| **T03 Notifications inbox** | `home_header.dart:23-36,78-80` (`hasUnreadNotifications` permanently false); `home_screen.dart`; `/message` branch `app_router.dart:311-318`, `tab_placeholder.dart` (`MessagePlaceholderScreen`), `main_shell.dart` destinations; `settings_screen.dart:341-421` (4 inert toggles, hide ruling DR-05/O-6); `profile_repository.dart` [INFERRED]; new feature dir; mock; ARB; session registry; `app_colors.dart` | l10n ×3, goldens (bell ×2, nav tab3 ×2) |
| **T04 Push/FCM** | `pubspec.yaml/lock` (no Firebase package today); `android/settings.gradle.kts:20-24` plugin versions; `android/app/build.gradle.kts`; new `android/app/src/{prod,staging}/google-services.json` (none exist); `AndroidManifest.xml`; new `res/values*/strings.xml` for the 8 `push_*` keys; `bootstrap.dart:10-31`; `main_{dev,staging,prod}.dart` (mock entry must stay Firebase-free); `app.dart` or an auth-listening provider (`PUT /me/fcm-token` after sign-in and on refresh); `app_router.dart` tap routing (4 kinds + unknown → notifications); iOS: `Info.plist`, entitlements (none exist), `project.pbxproj`, `AppDelegate.swift`, `GoogleService-Info.plist`; `ENVIRONMENTS.md` §5/§7 | `pubspec.lock` |
| **T05 Friends + blocked** | replaces `account_shells/screens/friends_screen.dart` (route `/friends` `app_router.dart:423`, "no entry point"); entry row in Profile hub or Message tab [INFERRED, undecided]; blocked-list entry in Settings or Profile [INFERRED]; leaderboard (blocked excluded both directions since 3.36; report/block from rows is H-1/DR-04, undecided); new feature dir; mock (12 ops); ARB; session registry; tokens | l10n ×3 |
| **T06 Chat + hub** | `pubspec` (SignalR client; a direct `uuid` for `clientMessageId`, only transitive today per ERR A16); `/message` branch + `main_shell` (unread badge [INFERRED]); hub provider tied to auth (connect after sign-in, abort on superseded session, max 3 connections per student, per `realtime.md@2e5bb69`) → `auth_controller` / `session_scope`; `main_mock.dart` (the mock is a Dio interceptor and cannot fake a WebSocket, so a new fake hub is needed); `/message/:conversationId` route; ARB; tokens (bubbles) | l10n ×3, nav goldens |
| **T07 Fwd questions + streaks** | `quiz_review_screen.dart` (656 lines), `quiz_screen.dart` (468), `quiz_result_screen.dart` (632), `quiz_repository.dart` (187) [INFERRED, action placement]; chat models from T06; friend streaks from T05/T06; mock; ARB | quiz `*.freezed/*.g` only if models change |
| **T08 Support + photos** | replaces `customer_support_screen.dart` (`/support` `app_router.dart:416-419`, `profile_screen.dart:276-284` row); picker dependency and upload helper (`createSupportAttachmentUpload` + `completeSupportAttachment`); Terms 403 gate; push tap `/support/tickets/:id`; `Info.plist` keys only if the picker needs them; `account_shells/widgets/shell_body.dart`; mock; ARB; tokens | l10n ×3 |
| **T09 Avatar upload/remove** | `avatar_sheets.dart:196-207` (Upload row is currently dimmed); `edit_profile_screen.dart` (821 lines); `profile_repository.dart` (PUT/DELETE `/me/avatar`); picker dependency; Terms gate; `avatar_disc.dart`, `board_avatar.dart` (cache); mock; tokens (Wave-20 avatar group); ARB | l10n ×3 |
| **T10 Terms + legal** | `legal_document_screen.dart` and `/legal/*` (`app_router.dart:426-435`); `profile_screen.dart:287-306`; `login_screen.dart:43-48,122-124` (placeholder `levelup.example` links); a registration step or post-login gate (`school_detail:362`, `university_detail:328`, `otp_screen:122`, `authRedirect`); Markdown dependency (`getLegalDocument` is Markdown); `profile_repository` (`getTermsAcceptance`/`acceptTerms`); ARB; mock | l10n ×3; registration `*.freezed` if the draft changes |
| **T11 Account deletion/cancel** | entry row in Settings or Profile [INFERRED]; new screens and routes; 403 routing hook `exceptions.dart:134` plus 5 copy sites (`catalog_states.dart:95,139`, `flashcards_error_copy.dart:81`, `board_failure.dart:17,32`, mistakes screens); `auth_controller.dart` (purge the token pair after success, a third sign-out path); `app_router.dart` (pending-deletion routing); `profile_repository`; ARB; mock | l10n ×3 |
| **T12 Lost-phone recovery** | `login_screen.dart` (entry); `_authRoutes`/`_atAuthRoute` `app_router.dart:52-57` (pre-auth); 4 ops; `confirmRecovery` returns `AuthenticatedResult` so it joins the OTP sign-in path (`otp_notifier.dart`, `auth_result.dart`) and lands on `/home`; PII providers (`recoveryId`, `rebindToken`, masked parent phone) → registry or autoDispose; ARB; mock | l10n ×3 |
| **T13 Track transfer** | `profile_screen.dart:339-353` (`_showGoToUni`, Confirm hard-disabled) and row `:311`; `profile_repository`; registration pickers (`reference_providers.dart`, `school_search_notifier.dart`); a partial-scope invalidation next to `invalidateSessionScope` (me, entitlements, catalog, mistakes, leaderboard family); mock `_track` (`mock_backend.dart:112-114`); chat `conversationRemoved`; ARB | l10n ×3 |
| **T14 Referral** | replaces `refer_a_friend_screen.dart` (`/refer` `app_router.dart:415`; row `profile_screen.dart:260-272`); `profile_repository` (`getMyInvite`); `registration_draft.dart:17,41` (`referralCode` collected, not submitted), `school_registration.dart:96`, `university_registration.dart:78`, `registration_controller.dart:38`, `registration_submit_notifier.dart`; `auth_result.dart` (`inviteCodeApplied`); share dependency; mock; ARB | `registration_draft.freezed`, `school/university_registration.{freezed,g}`, `auth_result.{freezed,g}` (≈ 8 files) |
| **T15 Quiz history/review/favorites** | `quiz_repository.dart`; `quiz_review_screen.dart`; `quiz_result_screen.dart`; `quiz_setup_screen.dart` and `quiz_mode.dart:23-27` (`favorites` mode held back); `app_router.dart:345-386` (review is nested under result and `extra`-based, so a history entry needs a new route); `profile_screen.dart:236-259` (favorites and progress rows); Home Continue Learning (`coming_soon_section.dart:76-81`); mock; ARB | quiz `*.freezed/*.g` if models change |
| **T16 Rank + summary/progress** | `leaderboard_repository.dart:11-15`, `leaderboard_notifier.dart` (208), `leaderboard_screen.dart` (self row; D-008); `profile_screen.dart:38-45` (tiles omitted); `settings_screen.dart:272-330` (Rank section); `top_student_section.dart`; mock (`/leaderboard/me` deliberately not served, `mock_backend.dart:276-279`); ARB | leaderboard `*.freezed/*.g` if models change |
| **T17 listModules** | `catalog_repository.dart` (94), catalog models (7), `subjects_notifier.dart` / `subjects_screen.dart` (university-only; "All subjects" must stay); session registry (a new modules provider); mock; ARB | catalog `*.freezed/*.g` |
| **T18 Env Wave 2** | `app_config.dart:51-55` (prod `.example`); `bootstrap.dart`; `main_{dev,staging,prod,mock}.dart` (`kReleaseMode` refusal); `app.dart` builder (`isDev` indicator; the only file allowed `SystemChrome`); `android/app/build.gradle.kts` (flavor value bridge); `docs/ENVIRONMENTS.md` (§4.3, table `:311-315`); `env_chapter_state.md` | none |
| **T19 iOS Wave 3** | `project.pbxproj` (deployment target `:349,475,526`; bundle id `:371,387,404,419,550,572`); `Info.plist` (display name "Level Up App"); `AppFrameworkInfo.plist`; one scheme; no Podfile, entitlements or PrivacyInfo today; `ENVIRONMENTS.md` §4.2. Needs a Mac with Xcode 26 (none known). | none |
| **T20 Signing/AAB** | `android/app/build.gradle.kts:70-90` (signingConfigs, release buildType); `key.properties.example`; `docs/RELEASE_SIGNING.md`; `ci.yml` `build-release-apk` job `:318-413` (main-only; never run against the flavored workflow); `tool/verify_release_manifest.ps1`; `pubspec.yaml` `version: 1.0.0+1` | none |
| **T21 Store listing** | `docs/STORE_*`, `store_submission_checklist`; privacy and Data Safety text; iOS privacy manifest; `pubspec.yaml` `description: "A new Flutter project."`; assets | none |

**Universal hotspots** (every UI or endpoint track touches some of these):
- `app_en.arb` / `app_ar.arb` plus the 3 generated l10n files.
- `mock_backend.dart`.
- `app_router.dart` imports and routes.
- `session_scope.dart` plus its discipline test (for any non-autoDispose stateful provider).
- `app_colors.dart` plus `app_colors_test.dart` (for new tokens).
- `pubspec.yaml` / `pubspec.lock` (for dependencies).
- The doc logs with sequential ids.

###### 3.2 Table B: guard and test-harness files each track must update

| Track | Guards and tests |
|---|---|
| T01 | `test/guards/contract_models_test.dart` (13 bindings read the vendored YAML at run time; 14/14 at 3.38 and 3.45, canary included); fixture comments in `catalog/profile/quiz_fixtures.dart`; `test/dev/mock_backend_*_test.dart` (5) only if shapes change. Only this guard reads `contract/` at run time. |
| T02 | `app_router_test.dart` (pure `authRedirect` cases `:15-70`); `auth_interceptor_test`; `error_interceptor_test`; `account_pending_deletion_test`; `auth_controller_test`; `login_logout_message_test`; `session_isolation_test`; `session_scope_discipline_test.dart:182-190` (call count == 2); new `DioClient` header test (none exists) |
| T03 | `home_header_unread_test`, `home_screen_test`, `main_shell_test`, `settings_screen_test` / `settings_frame_test`, goldens (`home_header_bell_*`, `nav_bar_*_tab3`), Home-level harness overrides (`profile_harness` ×3 pumps, `catalog_harness`, `quiz_harness`, `settings_harness`) plus a hold helper |
| T04 | `android_identity_test.dart:203-240` (Firebase-slot group stops being vacuous); `workflow_test.dart:109-145` (INTERNET); `verify_guards.ps1` probe 8 (manifest line must stay verbatim); new tap-routing tests; `main_mock` Firebase-free test; session discipline |
| T05 | `shell_screens_test.dart:23-30` (`/friends` in the `shells` map, "a shell fetches nothing" group `:90-100`); `profile_screen_test` / settings tests if an entry row is added; leaderboard tests; `contract_models_test` bindings (+Friend/FriendRequest) |
| T06 | `main_shell_test`; 10 nav goldens; harness hold; session discipline (StreamProvider is scanned); **retry-guard gap**: `rules.dart:577` matches only `FutureProvider\|AsyncNotifierProvider`, and `isOnlineProvider` (a StreamProvider) has no `retry:`; `blocOutsideQuiz` (state stays Riverpod); a new fake-hub helper |
| T07 | quiz review and quiz tests, `quiz_harness` (4 importers) and `quiz_fixtures`; `blocOutsideQuiz` for any cross-feature import |
| T08 | `shell_screens_test.dart:32-35` (`deadControls`: `support_create_ticket_button`); `disabled_action_button_test`; `profile_screen_test` (`profile_row_support`); error-layer tests |
| T09 | `edit_profile_screen_test` (62 tests); `edit_profile_elevation_test`; `mock_backend_profile_test` (S45); `profile_fixtures` (≈22 importers); `app_colors_test.dart:593` (avatar group) |
| T10 | `shell_screens_test.dart:150-176` (legal group); `profile_screen_test` (privacy and terms rows); `project_rules_test.dart:127` (`knownFiles` lists `login_screen.dart`) and `:139` (`baseline = 4`); `app_router_test`; `registration_router_flow_test` |
| T11 | `account_pending_deletion_test.dart`; `session_scope_discipline_test.dart:182-190`; `session_isolation_test`; settings tests; `profile_fixtures` (`pendingDeletion` variants); binding `StudentProfile.pendingDeletion` already exists |
| T12 | `app_router_test` (pre-auth list); login and OTP tests (`otp_success_router_test`); `session_isolation_test` (PII drafts); `project_rules_test` Text-literal ratchet (`:139`, `:127`); `auth_result_test` |
| T13 | `profile_screen_test` (Go-to-Uni dialog); `mock_backend_*` tests (track switching); session tests; catalog and leaderboard refresh tests |
| T14 | `shell_screens_test.dart` (`/refer`, `refer_share_button`); `profile_screen_test`; `registration_harness.dart` (127 lines) and registration tests; `contract_models_test` bindings (+registration schemas, `AuthenticatedResult`) |
| T15 | `quiz_models_test`, `quiz_fixtures`, `quiz_harness`; `mock_backend_quiz_test`; `profile_screen_test`; `coming_soon_section_test`; Home tests |
| T16 | `leaderboard_screen_test`; `leaderboard_fixtures` (≈13 importers); `top_student_section_test`; `profile_screen_test`; settings tests; bindings |
| T17 | `catalog_fixtures` (189 lines); `catalog_harness` (9 importers); `subjects_screen_test`; `mock_backend_catalog_test` |
| T18 | `android_identity_test.dart`; `workflow_test.dart`; new boot-assertion and `main_mock` refusal tests; `verify_guards.ps1` (11 probes today); `palette_discipline_test` pins `lib/app.dart` as the only `SystemChrome` file |
| T19 | new iOS identity guard (analogue of `android_identity_test`); `workflow_test.dart:147-363` (scans `docs/`, `tool/`, `.github/`, `.githooks/` for `flutter build apk\|appbundle\|ipa\|ios`); `verify_guards.ps1` |
| T20 | `workflow_test.dart:147-363` and `:109-145`; `verify_guards.ps1` probes 9–11 (exact From-strings `flutter build apk --release --flavor prod -t lib/main_prod.dart` in `docs/RELEASE_SIGNING.md` and `applicationId = "com.levelupworld.app"` in the gradle file); `android_identity_test` (regexes over the gradle file) |
| T21 | `workflow_test.dart` doc scan (any doc containing a build command); nothing else |

**Guards every UI track trips** (SOURCE):
- ARB parity (`project_rules_test.dart:295`).
- Raw `Text('…')` baseline of 4 (`:139`).
- `fontSize`/`fontWeight` ratchet at 0 (`:193`).
- Raw elevation ratchet at 0 (`:207`): use `ElevatedSurface`/`PrimaryCta`.
- Palette discipline: no `0xFF`, `Colors.black/white` outside `lib/core/theme/`.
- `mirroredGlyphSwaps`.
- `blocOutsideQuiz`.
- No provider write in `initState`.
- autoDispose notifiers that `await` need a disposal flag.
- Every `FutureProvider`/`AsyncNotifierProvider` needs `retry:` (`rules.dart:574`).
- Session-scope classification (`session_scope_discipline_test.dart`).

**Pending tooling patch in two stale worktrees** (`.claude/worktrees/{angry-antonelli-cf9094,jovial-bhaskara-018e57}`, both at `e71e9a1`, unchanged since 2026-09-27): it edits `tool/validate.sh` and `.githooks/pre-commit`. The NUL-safety group in `workflow_test.dart` (`:410-473`) scans those files, so re-run the guard suite after landing it.

---

##### 4. Pairwise conflict matrix

**Legend (rule of construction).** Every cell is generated from the anchor key in §4.3 (`scratchpad/mc/matrix.py`), so it is traceable. Doc-log appends are excluded from pair scoring and handled as a scribe rule in §5.
- **H** = both tracks must edit the same function, hunk or symbol of a non-universal file. Textual conflict is certain or probable, and the semantic coupling means a clean textual merge is not safe.
- **G** = hard ordering (the earlier track defines what the later one consumes). It may merge textually, but they must not run concurrently.
- **M** = same non-universal file, different hunks, a shared test or harness, or a duplicated helper. A clean merge is likely; review the guard and harness side.
- **l** = only the universal hotspots in common. They still conflict textually if both use the tail anchor (§2).
- **.** = no shared code or config file.

|   | T01 | T02 | T03 | T04 | T05 | T06 | T07 | T08 | T09 | T10 | T11 | T12 | T13 | T14 | T15 | T16 | T17 | T18 | T19 | T20 | T21 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| **T01** | - | G | G | G | G | G | G | G | G | G | G | G | G | G | G | G | G | . | . | . | . |
| **T02** |  | - | l | G | l | l | l | M | M | H | H | H | l | l | l | l | l | . | . | . | . |
| **T03** |  |  | - | M | M | H | l | M | M | M | M | l | M | M | H | M | l | . | . | . | . |
| **T04** |  |  |  | - | M | M | l | M | M | M | M | M | M | M | l | l | l | H | H | M | G |
| **T05** |  |  |  |  | - | G | G | M | l | M | M | l | M | M | l | M | l | . | . | . | . |
| **T06** |  |  |  |  |  | - | G | M | l | l | l | M | M | l | H | l | l | . | . | . | . |
| **T07** |  |  |  |  |  |  | - | l | l | l | l | l | l | l | H | l | l | . | . | . | . |
| **T08** |  |  |  |  |  |  |  | - | M | G | l | M | M | M | M | M | l | . | M | . | G |
| **T09** |  |  |  |  |  |  |  |  | - | G | M | M | M | M | l | l | l | . | M | . | G |
| **T10** |  |  |  |  |  |  |  |  |  | - | H | H | M | M | M | M | l | . | . | . | G |
| **T11** |  |  |  |  |  |  |  |  |  |  | - | H | M | M | l | M | l | . | . | . | G |
| **T12** |  |  |  |  |  |  |  |  |  |  |  | - | l | l | l | l | l | . | . | . | . |
| **T13** |  |  |  |  |  |  |  |  |  |  |  |  | - | M | M | M | M | . | . | . | . |
| **T14** |  |  |  |  |  |  |  |  |  |  |  |  |  | - | M | M | l | . | . | . | . |
| **T15** |  |  |  |  |  |  |  |  |  |  |  |  |  |  | - | M | l | . | . | . | . |
| **T16** |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | - | l | . | . | . | . |
| **T17** |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | - | . | . | . | . |
| **T18** |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | - | G | M | M |
| **T19** |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | - | M | G |
| **T20** |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | - | G |
| **T21** |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | - |

Totals over 210 pairs: **H 12, G 30, M 59, l 51, none 58.**

Highest M-degree (hub tracks): T08 (12), T13 (12), T04 (11), T14 (10), T03 (9), T09 (9). T08, T13 and T14 sit on the Profile hub, the shells test and `profile_repository`. T04 sits on tap targets, AuthController and the Gradle/iOS files.

###### 4.1 HIGH pairs (12) and the shared anchors

| Pair | Why |
|---|---|
| T02–T10, T02–T11, T02–T12 | `authRedirect`/`_authRoutes` + test `app_router_test.dart`. `/home` landings (T02, T10, T12). The `error_interceptor` switch (T02–T11 certain; T10/T12 add typed arms). `login_screen` switch (T02, T10, T12). `auth_controller` (T02–T11). Sim: 1 conflict when both extend the tail; 1 on the `LogoutReason` line; 1 on the typed-arm line. |
| T10–T11, T10–T12, T11–T12 | Same `authRedirect` function (terms gate, pending-deletion target, pre-auth recovery routes). T11–T12 are also coupled by `cancelAccountDeletion` and recovery (contract @346:72-79). |
| T03–T06 | The `/message` slot: router builder line, `tab_placeholder.dart`, `main_shell.dart` destinations, 10 nav goldens. Product decision DC-12 is open (hide, inbox, chat, or both). |
| T03–T15, T06–T15 | Home- or shell-level providers (bell unread count, Message-tab badge, Continue Learning) force the same override anchor in the harnesses (sim: 3 conflicts in `profile_harness`). [INFERRED: none of these providers exists yet.] |
| T07–T15 | Both attach per-question actions to the review/question UI and `quiz_repository` (`quiz_review_screen.dart` 656 lines). [INFERRED: placement not designed.] |
| T04–T18 | `bootstrap.dart`, `main_*.dart`, `app_config.dart`, `build.gradle.kts`, `android_identity_test.dart`, `ENVIRONMENTS.md` (Firebase per flavor, R-9 gate, boot assertion). |
| T04–T19 | `project.pbxproj`, `Info.plist`, entitlements, `AppDelegate.swift`, `GoogleService-Info.plist`; T19 rewrites ids and targets in the same files push must extend. |

###### 4.2 Ordering gates (G), with evidence

| Gate | Basis |
|---|---|
| T01 → T02–T17 | Pin decision DC-13/B-1 (3.38 vs `eddb6ac`); a re-vendor is its own commit (P-6, `implementation_waves.md:28-29`). Committed pin `0df5cf4` lacks the operations (committed pin 54 ops, 38 stable; upstream 86 ops, all stable). 5 contract files are dirty today. |
| T02 → T04 | Tap routing needs return-to-target and an `errorBuilder` first (`cor_env_push_impl.md:166`); contract tap rules also say unknown kind opens notifications. |
| T05 → T06 → T07 | Chat is "one conversation per friendship" (@346:143-150); forwarded cards live inside a conversation. |
| T10 → T08, T09 | `403 terms_acceptance_required` on avatar and support-photo uploads (@346:1025; "recorded, not enforced except photo uploads" @346:1122-1123). |
| T18 → T19, T18 → T04 | The Firebase per-flavor slot and boot assertion come first; the iOS leg needs T19 and a Mac. |
| T04, T08, T09, T10, T11, T19, T20 → T21 | Data Safety / privacy declarations and store prerequisites follow what ships (Q.md DC-10). |
| Soft (not G) | T03, T05, T06 and T08 provide the four push tap targets (`realtime.md` Push section); T04 can stub them. |

---

##### 4.3 Anchor key (source of every H and M above)

| Id | Sev | Tracks | Where |
|---|---|---|---|
| A1 `/message` slot | H | 3, 6 | `app_router.dart:311-318`; `tab_placeholder.dart`; `main_shell.dart` destinations; 10 nav goldens |
| A2 authRedirect / `_authRoutes` | H | 2, 10, 11, 12 | `app_router.dart:52-83`; `app_router_test.dart` |
| A3 `/home` landings | H (2, 10, 12), M (4) | | `otp_screen:122`, `school_detail:362`, `university_detail:328`, `app_router:80` |
| A4 AuthController | H (2, 11), M hooks (4, 6, 12) | | `LogoutReason`, sign-out paths, guard count == 2 |
| A5 error layer | H (2, 11), M typed arms (2, 8, 9, 10, 12) | | `error_interceptor.dart:29-41`, `exceptions.dart` |
| A6 login_screen | M | 2, 10, 12 | `:66-70`, `:43-48`, entry link |
| A7 OTP path | M | 2, 4, 12 | `otp_screen`, `otp_notifier`, `auth_error_copy` |
| A8 shells test + dir | M | 5, 8, 10, 14 | `shell_screens_test.dart:23-37`; `account_shells/*` |
| A9 profile hub | M | 8, 10, 13, 14, 15, 16 | `profile_screen.dart:230-323`; `profile_screen_test.dart` |
| A10 settings | M | 3, 5, 11, 16 | `settings_screen.dart:272-421` |
| A11 Home widgets | M | 3, 15 | `home_header.dart`, `home_screen.dart`, `coming_soon_section.dart` |
| A12 Home/shell provider → harness overrides | H | 3, 6, 15 | `profile_harness` ×3, `catalog_harness`, `quiz_harness`, `settings_harness`, `main_shell_test` |
| A13 quiz review/question UI | H | 7, 15 | `quiz_review_screen.dart`, `quiz_screen.dart`, `quiz_repository.dart` |
| A14 leaderboard | M | 5, 16 | repository, notifier, screen, `leaderboard_fixtures` |
| A15 profile repository | M | 3, 4, 9, 10, 11, 13, 14 | `profile_repository.dart` (105 lines, 3 copies of the same try/catch). [INFERRED: only if profile-tag ops are added to it.] |
| A16 registration | M | 10, 14 | draft, controller, submit, school/university models (+6 generated) |
| A17 boot/config | H | 4, 18 | `bootstrap.dart`, `main_*`, `app.dart`, `app_config.dart`, gradle, `android_identity_test` |
| A18 gradle/ci | M | 4, 18, 20 | `build.gradle.kts`, `ci.yml`, `verify_guards.ps1` probes, `workflow_test.dart` |
| A19 ios/** | H | 4, 19 | pbxproj, plist, entitlements, AppDelegate |
| A19b ios/** (secondary) | M | 8, 9, 19 | plist usage keys (only if the picker needs them) |
| A20 env/signing/store docs | M | 4, 18, 19, 20, 21 | `ENVIRONMENTS.md`, `RELEASE_SIGNING.md`, `env_chapter_state.md`, `STORE_*` |
| A21 picker/upload helper | M | 8, 9 | picker dependency + upload helper |
| A22 `conversationRemoved` | M | 5, 6, 13 | unfriend, block and track transfer all remove a conversation |
| A23 friends→chat→forward chain | M | 5, 6, 7 | models and providers consumed downstream |
| A24 push tap targets | M | 3, 4, 5, 6, 8 | |
| A25 deletion ↔ recovery | M | 11, 12 | contract @346:72-79 |
| A26 catalog + track change | M | 13, 17 | |
| A27 Terms 403 gate | M | 8, 9, 10 | |
| A28 profile Favorites/Progress vs Rank/Solved | M | 15, 16 | |

---

##### 5. Serialisation recommendations

###### 5.1 Rules that apply to every track

1. **Pin first, in its own commit.** T01 lands before any track branches. A worktree cut from `HEAD` gets pin `0df5cf4`, not the dirty 3.38 tree. Never `git add -A` while the 5 `contract/*` files are modified.
2. **Anchor discipline** (EXEC, §2): never append at the tail. Insert next to your own siblings.
   - ARB: after your feature's neighbouring key.
   - Mock: next to the sibling feature block, not before the 404 fall-through.
   - Router: beside the sibling route.
   - Session scope: its own comment-headed block.
   - Exemption map: head, not tail.
   - pubspec: next to a related line.
   - Imports: respect alphabetical neighbours.

   Result: 0 conflicts in 5 of 5 retested pairs, against 1 or more for the same pairs at the tail.
3. **Never hand-merge generated files.** After any rebase run:
   - `flutter pub get`
   - `dart run build_runner build --delete-conflicting-outputs`
   - `flutter gen-l10n`
   - `dart format` on hand-written files, including new untracked ones (`validate` formats `git ls-files` only; `56f74e7` and `f10b112` are the precedent)
   - `tool/validate.ps1` with `LEVELUP_VALIDATE_OUT` set, so the tracked `test-results.md` is not rewritten by a track

   Golden PNG conflicts are resolved by regenerating.
4. **One scribe for logs.** Tracks write their own report files. One sync commit updates `WAVE_STATUS.md`, `wave_state.md`, `implementation_waves.md` and `device_walk_results.md`. Sequential ids collide semantically even when the text merges: next free are DESIGN_ISSUES #127, seif_fight S46, KNOWN_BUGS BUG-026, DECISIONS D-022, RISKS R-12. Pre-allocate id ranges per track.
5. **Prefer new files to extending hubs.** Give each track its own repository, notifier and screen files. Do not add the 13 un-integrated `profile`-tag operations to `ProfileRepository` (A15).
6. **Single physical device.** The Pixel 8 (USB) is a serialisation point for every WALK, regardless of code conflicts.
7. **No technical enforcement exists.** `core.hooksPath` is unset, there is no branch protection, and `tool/validate.sh` cannot pass on Windows Git Bash. Enforce locks by process.

###### 5.2 Locks

| Lock | Files and anchor | Holder order |
|---|---|---|
| L-CONTRACT | `contract/**`, pin comment in the mock header, `contract_models_test` bindings, fixtures | T01 only; all others wait for its commit |
| L-AUTH-ROUTER | `authRedirect`, `_authRoutes`, `GoRouter(` args and `errorBuilder`, 3 `/home` landings, `auth_controller.dart`, `login_screen`, `error_interceptor.dart`, `exceptions.dart`, `session_scope_discipline_test:182-190` | T02 → then T10, T11, T12 one at a time (K4 clique) → T04 consumes |
| L-MESSAGE-SLOT | `/message` builder, `tab_placeholder.dart`, `main_shell.dart`, 10 nav goldens | T03 or T06 first (after DC-12), the other rebases and regenerates goldens |
| L-HOME-HARNESS | `profile_harness` ×3, `catalog_harness`, `quiz_harness`, `settings_harness`, `main_shell_test`, `holdBoards` / `holdProfile` | T03, T06, T15 serially. The first adds one shared hold helper; later tracks add one line. |
| L-QUIZ-REVIEW | `quiz_review_screen`, `quiz_screen`, `quiz_repository`, `quiz_harness` | T15 → T07 |
| L-BOOT-BUILD | `bootstrap.dart`, `main_*`, `app.dart`, `app_config.dart`, `android/app/build.gradle.kts`, `android_identity_test`, `ENVIRONMENTS.md`, `verify_guards.ps1` | T18 → T04 (Android leg). T20 touches distant hunks (sim 0) but shares probe strings and docs. |
| L-IOS | `ios/**`, plist, `project.pbxproj` | T19 (Mac) → T04 iOS leg → T08/T09 plist keys → T21 |
| L-SHELLS-PROFILE | `shell_screens_test.dart` `shells` map, `account_shells/*`, `profile_screen.dart` `_Menu`, `profile_screen_test.dart` | Adjacent entries are conflict-prone (`/support`↔`/friends`); non-adjacent can merge (`/refer`↔`/legal/terms`). Order T14, T08, T05, T10 by map position, or serialise. |
| L-TOKENS | `app_colors.dart` (6 places per token), `app_colors_test.dart` (one group per wave), `app_elevation*.dart` | UI tracks; each adds its own mid-file group |
| L-REGISTRY | `session_scope.dart` plus its test exemption map | short critical sections; own comment block per track |
| L-GENERATED | l10n ×3, `*.freezed/*.g` ×42, `pubspec.lock`, goldens ×43 | regenerate, never merge |
| L-LOGS | doc logs and id counters | one scribe commit |

###### 5.3 Must not run concurrently without the named lock

- **K4 {T02, T10, T11, T12}:** strictly serial under L-AUTH-ROUTER. 6 of 6 pairs are H.
- **K3 {T03, T06, T15}** under L-MESSAGE-SLOT and L-HOME-HARNESS, plus **T07–T15** under L-QUIZ-REVIEW. T05 → T06 → T07 order also applies.
- **{T04, T18, T19}** under L-BOOT-BUILD and L-IOS. Order: T18 → T19 → T04.
- **{T08, T09}** share a picker/upload helper. Build the helper once.
- **T08/T09 after T10** (Terms 403 gate).
- **T21 last.**

Tracks with no H edge: T01, T05, T08, T09, T13, T14, T16, T17, T20, T21.
- **T18, T19, T20 and T21 share no code file with T05–T17** (all `.` in the matrix). They can run beside any screen wave.
- **T04** has only soft M edges to T03, T05, T06 and T08.

###### 5.4 Lane plan (conditional on owner decisions B-1, B-2 and DC-12)

| Lane | Order | Notes |
|---|---|---|
| 0 gate | T01 | exclusive. Needs the pin ruling (DC-13/B-1). |
| A auth/router | T02 → T10 → T11 → T12 | T08/T09 branch off after T10. |
| B messaging | T03 → T05 → T06 → T07, with T15 before T07 | order T03/T06 follows DC-12; T15 must also be serialised against T03/T06 (H) |
| C env/release | T18 → T19 (Mac) → T04 → T20 → T21 | T20 can start after T18 |
| D profile hub | T16 → T13 → T14 → T17 | all M edges within the lane; serialising removes them |

- Up to 3 lanes can write code at once (A, B, C), with D alongside under the anchor discipline.
- Cross-lane M edges to schedule merges around: T10–T14 (registration and rows), T13–T05/T06 (`conversationRemoved`), T04–T03/T05/T06/T08 (tap targets).
- If the repo's wave protocol stays in force (one screen per wave, NEXT/WALK/FORMULATE), screen waves are already serial. The matrix then matters mainly for T01, T02, T04 and T18–T21, which are the non-screen tracks that can run beside a screen wave.

###### 5.5 What would change this (decisions the repo does not answer)

- **DC-12 (Message tab):** if hidden or inbox-only, T03–T06 and A1/A12 collapse. If chat, T03 and T06 stay serial.
- **Entry points for friends, blocked list and deletion:** not designed. They add M edges on A9/A10 if placed in the Profile hub or Settings.
- **Whether profile-tag operations go into `ProfileRepository`:** if yes, A15 becomes H for 7 tracks.
- **Mock vs staging:** if screen waves stop using the mock for already-stable endpoints, the mock-chain hotspot shrinks. Chat cannot use the mock at all (no WebSocket).
- **B-3 (the protocol clash):** the owner's Opus-orchestration brief versus the recorded Sonnet-only rule. Parallel lanes depend on the ruling.

---

##### 6. Evidence: commands and outputs

```
git rev-parse --short HEAD; git branch --show-current          -> 8e641e9 / merged
git log --oneline --since=2026-09-24 | wc -l                   -> 24
git log --since=2026-09-24 --name-only --format= | sort | uniq -c | sort -rn   (table 1.1)
git show --name-only --format= cccd2f1|a988a1f|fa88b3a|af0eadb | wc -l  -> 143 | 57 | 17 | 21
python scratchpad/mc/churn.py top 36   -> unique 268 (237 excl. icons); >=2: 53; >=3: 20; >=4: 11
   checkpoint union 189; >=2: 29; >=3: 12; all-4: 8
git show --numstat --format= <ck> -- <hot files>               (hunk sizes in 1.2)
git ls-files | grep -c '\.freezed\.dart$' / '\.g\.dart$' / lib/l10n/app_localizations   -> 22 / 20 / 3
git ls-files test | grep harness|fixtures                      -> 12 files
grep -rn invalidateSessionScope lib test                       -> session_scope.dart:58; auth_controller.dart:71,84
grep -rn "errorBuilder|errorPageBuilder|onException" lib       -> none in app_router.dart
grep -rn "'/home'" lib                                         -> app_router:80,175; otp_screen:122; school_detail:362; university_detail:328; leaderboard_screen:116
grep -rln "routerProvider|LevelUpApp|authRedirect" test        -> 17 files
grep -rln "mock_backend|buildMockDio" test                     -> 5 files (test/dev) + lib/main_mock.dart
python scratchpad/mc/mergesim.py | mergesim2.py | mergesim3.py -> table in section 2
python scratchpad/mc/matrix.py matrix|tally|pairs H|pairs G    -> H 12, G 30, M 59, l 51, none 58 of 210
git status --short (before and after all of the above)         -> 5 M contract/* + 3 untracked, unchanged
```

**Scripts and outputs:** `C:\Users\musta\AppData\Local\Temp\claude\F--level-level-up-level-up-app\513a53c3-37d2-4201-8dd7-79f979aa4042\scratchpad\mc\` (`churn.py`, `mergesim.py`, `mergesim2.py`, `mergesim3.py`, `matrix.py`, `sim/`).

**Limits.**
- The simulations are synthetic edits at the anchors a track must use, not the tracks themselves.
- Entry points for friends, blocked list and deletion are not designed, so those cells are [INFERRED].
- Each "Since" count is in commits, not hunks. The wave era is compressed into 4 commits, so the count under-states how often each file was edited.
- Nothing above SOURCE/EXEC is claimed. No build, device or CI evidence was produced in this task.

### 17.y Prior plans, registers and wave protocol
_Verification (Fable): 18 claims - 18 confirmed, 0 partial (corrected), 0 refuted (corrected), 0 unverifiable; 6 section-level errors, 6 omissions and further re-check corrections are applied in place (omissions marked "added in verification")._

#### Prior plans and registers

##### What each planning artefact is, and how current it is

| Artefact | What it is | Basis / last touch | Verdict at 2026-10-08 (contract upstream 3.45.0-m1 `2e5bb69`) |
| --- | --- | --- | --- |
| `level_up_master_completion_roadmap.json` (+ `.html`), untracked | The master completion roadmap produced by an earlier session: 525 issue records (522 master + 3 aggregates), DR-01…DR-29, 51 requirements, a 10-stage critical path, 10 workstreams, **14** gates (G-01…G-14, not 13), 20 risks. Verdict `release_ready: NO` | `generated 2026-10-08T02:59:36`; `repo.contract_pin = 0df5cf4 (3.28.0-m1)`, aware of the staged `65245be` (JSON `repo`, `verdict`) | **Partly stale.** It reasons at 3.28 and 3.38. The 3.39–3.45 changes undo specific rows: DR-24 (now moot), DR-14 (contradicted by `getLegalDocument`), DR-25/F-23/F-26/F-18/F-19/F-22 ("no operation" / "draft"). F-20 cites `POST /me/fcm-token`, but the contract says **PUT** (`openapi.yaml@2e5bb69:1064-1066`). Its dashboard row "Vendored contract == upstream HEAD" is `true` with the qualifier "as of the clone's 2026-10-06 04:26 fetch (SOURCE)" (JSON `dashboard`, around line 177-180): true then, false now (upstream is `2e5bb69`, the committed pin is `0df5cf4`). The verdict's "8 P0" is **correct for distinct findings**: `master_issues` holds 9 records with severity P0, but one of them (GAP2-02, "No journey is COMPLETE at HEAD") is an aggregate roll-up (`aggregate: True`). The 8 distinct P0 findings are AND-02, API-02, API-25, API-26, FEAT-C-14, PRIV-STORE-07, PRIV-STORE-08 and SEC-17 (SOURCE: python parse of the JSON; `counts.by_sev_open.P0 = 8`). Its F-12 still cites S44 "empty catalogue". That premise is stale (see the conflicts table). The HTML twin was not read. |
| `flutter_frontend_workflow.md` (tracked, repo root) | **Not a plan or workflow.** It is an architecture walkthrough ("how does this application work from startup…", `:7`) | "Audit date 2026-09-08", pin `184d6ec` (`:3`). Added in `f987f20`. One sentence was edited in `2dfd969` (2026-10-06) (git log for the file shows exactly those two commits) | Historical reference only. Its numbers are stale: 190 lib files and 36 operations (`:21-34`), and `leaderboard/` marked "untracked". The final workflow must not be built on it. |
| `docs/WAVE_STATUS.md` | Self-declared "single source of project truth" (`:1`, `:13-14`) | Header says "Last updated 2026-09-22" (`:3`). Dated sections from 2026-10-04 and 2026-10-06 were added at the top (`:18-64`) | **Incomplete and internally inconsistent.** The Waves table (`:95-111`) stops at Day 10 / Leaderboard / "Final Fable NOT STARTED". It never records API→UI Waves 01–22 (the only `wave_state` mention is the env-chapter cross-reference at `:21`). W3-1 is still "OPEN" (`:526`), but R-2 is CLOSED (`RISKS.md:33-42`) and `:58` of the same file says it is fixed. "Unpushed…" (`:8-11`) is stale: `origin/merged` is at `c87b90a`. |
| `.ai/audits/current/wave_state.md` | Checkpoint of the API→UI wave workflow (22 waves, one screen each) | "Last updated 2026-09-30" (`:3`) | All 22 formulated waves are complete. "Next action: WAIT FOR USER COMMAND" (`:90`, `:1825-1837`). It is **stale on commits**: it says "Waves 20 and 21 are not committed" (`:90`, `:108`, `:1829`), but git shows `fa88b3a` (Wave 20, 2026-09-30) and `af0eadb` (Wave 21, 2026-10-06). Its pin note (`f462968`, 3.27) is also stale; the committed pin is `0df5cf4` (`03fd7cf`). |
| `.ai/audits/current/env_chapter_state.md` | State of the Environment & Architecture chapter | Last changed `8e641e9` | Wave 0 and Wave 1 DONE. Wave 2 is next. Wave 3 is blocked on a Mac with Xcode 26. Wave 4 comes after 1–3 (`:9-15`). It says Wave 1 "DEVICE not reached" (`:12`, `:75-78`). That is superseded for the **staging** identity: the 2026-10-06 reconciliation installed `app-staging-debug.apk` on the physical Pixel 8 (`release_readiness_reconciliation_2026-10-06.md:367-379`). The prod identity was never installed. |
| `docs/RISKS.md` | Live risk register | "Last reviewed 2026-10-06" (`:7`) | Current except for two stale cells in R-8: the "Impact" text (`TBD.example`, `:122`) and the "Next action" (`:125`, "Seif: deploy `PATCH /me` and `/me/entitlements` (S37 — two left)"), which contradicts R-8's own Status cell (`:126`: both decode since 2026-09-22, "S37 is stale") (second cell added in verification). R-10 (`:142-150`, OPEN — DECISION since 2026-10-06) was never closed; handoff (1) makes it live again. The roadmap's 20 risks were never merged into this file. |
| `docs/DECISIONS.md` | D-001…D-021 | D-021 ratified 2026-10-06 (`:1021-1073`) | **It records none of DR-01…DR-29** (headings D-001 `:19` … D-021 `:1021`; grep for Message tab / push / orientation / iPad / obfuscation / crash / BUG-017 / replay / predictive / licence returns nothing relevant; the only hit is `:1060`, D-021 Q7, recorded as Seif input, not a decision; no `O-n` ids are transcribed). |
| `docs/seif_fight.md` | Contract question register S1–S45 plus the change ladder | Last touched `af0eadb` (2026-10-06). Its contract reasoning stops at 3.27/3.28 | The summary table (`:603-647`) is stale on S5, S11, S14, S24, S30, S31, S33, S36 (ask 1 only) and S37 (see below). **Q-B1…Q-B10 from the 2026-10-06 reconciliation were never filed** (`grep -c 'Q-B\|retention' docs/seif_fight.md` → 0). |
| `docs/KNOWN_BUGS.md` | BUG-001…BUG-025 | — | One bug is open (BUG-017). The BUG-015 status line (`:516`) is stale, and so is BUG-018's (`:593-594`, added in verification; see C8). |
| `.ai/audits/current/known-issues.md` | The 2026-08-11 fix queue (K-0…K-37) | Last touched `f987f20` (2026-09-19). It still says "Nothing here has been applied" (`:7`) | **Stale.** Several K items are done: K-28 (hive removed, `pubspec.yaml:46`), K-23 (TextTheme, R-1 closed), K-1/K-2 (Wave 1 C-1/C-2), and K-4 (VERIFIED_FIXED in the roadmap). Do not use it as a queue. |
| `.ai/audits/current/store_readiness_state.md` | Compact state of the 2026-09 store audit | "updated 2026-09-22, Wave 1 launching" | Superseded by `store_readiness_audit.md`, `store_readiness_recheck*.md` and the 2026-10-06 reconciliation. |
| `.ai/audits/current/release_readiness_reconciliation_2026-10-06.md` | Latest consolidated release verdict before the roadmap. Holds O-1…O-15 and Q-B1…Q-B10 | 2026-10-06 | Verdict NOT READY. The roadmap absorbed it. |

##### Conflicts between documents, and which is right per evidence

| # | Conflict | Evidence | Which is right |
| --- | --- | --- | --- |
| C1 | `wave_state.md` says Waves 20 and 21 are uncommitted | `wave_state.md:90,108,1829` vs `git log`: `fa88b3a` (Wave 20, 2026-09-30), `af0eadb` (Wave 21, 2026-10-06). `wave_state.md` itself was last touched by `af0eadb`, so the Wave 21 checkpoint commit did not update the "not committed" lines | **git.** `wave_state.md` is stale. |
| C2 | `WAVE_STATUS.md` is "the single source of truth", but it has no API→UI Waves 01–22 | `WAVE_STATUS.md:95-111` vs `wave_state.md:7-90` | `wave_state.md` is the only record of those waves. By `PROJECT_GUIDE.md` rules WAVE_STATUS "wins", so it has to be brought up to date. |
| C3 | W3-1 is listed OPEN | `WAVE_STATUS.md:526-556` vs `RISKS.md:33-42` (R-2 CLOSED, red-first `verify_fork_test.dart`), commit `e3364ab`, and `WAVE_STATUS.md:58` | **RISKS / git.** W3-1 is fixed. |
| C4 | Was "a release build of HEAD on a device against staging" a physical device or an emulator? | `WAVE_STATUS.md:56-57` and the auto-memory say "on a device". `RISKS.md:77` and reconciliation §15.2 heading (`:381`, "DEVICE + API, `Pixel_8` AVD") say AVD; `:383-385` the `app-staging-release.apk` was signed with the debug key and installed over the mock build (same `.stg` id) | **The AVD (emulator).** Report it as an emulator DEVICE run. Only the debug staging build and the mock data ran on the physical Pixel 8 (§15.1). |
| C5 | Env Wave 1 "DEVICE not reached" | `env_chapter_state.md:12,75` vs reconciliation §15.1 (staging-flavor debug APK on the physical Pixel 8, 2026-10-06 04:37); the orchestrator's `adb` facts (`com.levelupworld.app.stg` installed) | The staging identity is DEVICE-installed. The side-by-side check of both identities is still owed, because prod `com.levelupworld.app` is not installed. |
| C6 | S44 says "the test account's catalogue is empty". Roadmap F-12 says Mistakes is "unobservable on staging by construction" | `seif_fight.md:1604-1633`, roadmap F-12 vs reconciliation §15.2 (`:390-391`: "English 0 / 53 questions", a 10-question quiz +2 points, with `+2010000000001` at `:387`) | **Reconciliation §15.2.** The premise is stale. Both Mistakes operations can now be exercised, but nobody has observed them yet (the roadmap itself records the staleness, JSON line about 5251). |
| C7 | S37 is "Open, narrowed" | `seif_fight.md:639` vs `RISKS.md:126` (2026-09-22: `PATCH /me`, `/me/entitlements` decode) and reconciliation Q-B8 ("S37 is stale", `:212`) | RISKS. Close S37. |
| C8 | BUG-015 "Not yet device-verified" (and, added in verification, BUG-018 "Not yet device-verified: the Wave 21 walk runs on the owner's WALK") | `KNOWN_BUGS.md:516` and `:593-594` vs `wave_state.md:67` (W19-1 verified on device, 81 recorded frames) and `wave_state.md:61`, `:1620`, `:1676` (Wave 21 walked 2026-09-29; the walk record verifies "a disabled row says its label once (BUG-018)") | `wave_state.md`. Both KNOWN_BUGS status lines are stale. |
| C9 | Roadmap DR-25 / F-23 / F-26 / F-18 / F-19 / F-22: social forwarding, streaks and friends have "no operation" or are draft; support "draft since 3.26" | Ops table at `2e5bb69` (`SCRATCH/ops_table.txt:57-87`): 12 friend-graph ops stable (3.37); chat ×8 stable (3.39); support ×5 stable (3.39); `forwardQuestion`, `answerForwardedQuestion`, `listMyFriendStreaks` stable (3.44) | **Contract 3.45.** The roadmap rows are stale. |
| C10 | Roadmap F-20 says `POST /me/fcm-token` | `openapi.yaml@2e5bb69:1064-1066` (`put`); `realtime.md@2e5bb69:108`; the handoff (6); roadmap F-20 `backend` field reads "POST /me/fcm-token (stable)" | **Contract.** The method is PUT. |
| C11 | D-021 Q7: "backend has no Firebase credential and sends no push" | `DECISIONS.md:1060` vs `contract-changelog.md@2e5bb69:34` (server-side senders exist behind off-by-default gates) and `:59` / `realtime.md:80` (delivery is off in every environment) | The contract changelog is newer. Senders exist; delivery is still OFF. |
| C12 | `PROJECT_GUIDE.md` says "Identity decision pending: D-021" (`:62`), "no TextTheme" (`:52`), and "`main` = stable, `dev` = active" (`:105`). `AGENT_WORKFLOW.md:151-153` says "no TextTheme, 153 inline sites" | D-021 ratified (`DECISIONS.md:1024`); R-1 closed (`RISKS.md:14-22`); work happens on `merged` | The code and the newer records are right. Those guide lines are stale. |
| C13 | Handoff (9) lists "hooks" as part of the working state | `core.hooksPath` is UNSET on this clone (orchestrator fact) | The hooks exist in `.githooks/` but are **inactive** here. Hook enforcement holds at CI and SOURCE level only. |
| C14 | Contract internal: `getTermsAcceptance` says "the backend serves no Terms text and no link" | `openapi.yaml@2e5bb69:1095` vs `:811-830` (`getLegalDocument` serves the approved Terms/Privacy text and ties its `version` to `getTermsAcceptance.currentVersion`) | Probably a stale sentence in the contract. Raise it with Seif (non-blocking). |
| C15 | The `/redeem` website hand-off (D-021 Q7; handoff (1) "status/information screen with a website link") vs purchase silence | `DECISIONS.md:1060`; `ENVIRONMENTS.md:405-406` (DO NOT BUILD); `RISKS.md:142-150` (R-10 OPEN — DECISION); no adr-049 §3 revision in `contract-changelog.md@2e5bb69` (grep for adr-049 / purchase / website link / `/redeem` hits only `:288`, `:322-326`, `:551-577`, all dated 2026-09-16 or earlier; the 3.29–3.45 entries occupy roughly `:7-240` and contain none) | **The contract wins until Seif changes it.** Still an open owner + Seif decision. |
| C16 (added in verification) | `error_interceptor.dart` states a contract rule that 3.32 made false, and the app sends no `Accept` header | `lib/core/network/interceptors/error_interceptor.dart:9-10` ("Every non-2xx body is RFC 9457 ProblemDetails with a stable `code`") vs `openapi.yaml@2e5bb69:3884-3890` (some failures carry no body, or no `code`; "Send `Accept: application/json`") and `contract-changelog.md@2e5bb69:182-184` (3.32.0-m1 correction). SOURCE: `grep -rn "'Accept'\|\"Accept\"\|Accept:" lib/` → 0 hits | **Contract.** The comment is stale, and no `Accept` header is sent today (SOURCE, 2026-10-08). The unknown-outcome rule ("a non-2xx without a parsable body and `code` is an unknown outcome; treat it like `internal_error`") is a mandatory client item (see S5). |
| C17 (added in verification) | Stale `TODO(contract)` markers in `lib/` that still say "no endpoint" | `lib/features/account_shells/screens/friends_screen.dart:9` (S36: "the contract has nothing behind it"); `lib/features/profile/screens/profile_screen.dart:240` (S11 favourites), `:262` (S5), `:274` (S33), `:287` and `:298` (S30), `:331` (S31, "there is no track-switch endpoint") | The register status of S5, S11, S30, S31, S33 and S36 (ask 1) is ANSWERED at 3.45 (table below), so each marker needs re-reading when its wave runs. The S31 marker is also contradicted by `transferToUniversity` (stable since 3.39). |

##### `docs/seif_fight.md` OPEN items, re-read against contract 3.45.0-m1

The register's own status column is `seif_fight.md:603-647`. "3.45 status" is re-derived from `SCRATCH/openapi_2e5bb69.yaml` (CONTRACT) unless marked otherwise.

| S | Ask (short) | Register says | Status at 3.45 | Evidence |
| --- | --- | --- | --- | --- |
| S2 | Resume an interrupted quiz | Open | **OPEN.** `getQuizReview` serves FINISHED quizzes only | `openapi.yaml@2e5bb69` getQuizReview summary ("Review a FINISHED quiz") |
| S4 | Per-node progress % | Open | **Likely stale (DOC).** S24's own text says `SubjectTree` has per-node `answered`/`total`, and Wave 08 built the row bar and caption. Claude should verify this, not Seif | `seif_fight.md:1142`; `wave_state.md:36` |
| S5 | Referral surface | Open | **ANSWERED.** `getMyInvite` stable (3.44); optional `inviteCode` on `completeRegistration`; inviter earns +10 per new verified account, new student earns nothing. Figma's "500 points to both" contradicts this. The contract wins and design/copy must change | `openapi.yaml@2e5bb69:1434-1445`; changelog `:16-22` |
| S7 | Quiz timer | Open | OPEN. No time field | grep `timeLimit\|timer` → none |
| S9 | Learning Tools cards | Open | OPEN / UNKNOWN. `listModules` (stable since 3.37) is a university module overlay. Not established that it is "Learning Tools" | `openapi.yaml@2e5bb69:1685-1693` |
| S10 | Error-code mapping | Open | OPEN (meta). `error-codes.md` grew by +10 codes (3.29–3.38) and more since | handoff (7); `error-codes.md@2e5bb69:51-70` |
| S11 | Favourites | Open | **ANSWERED.** `addFavorite`/`removeFavorite`/`listFavorites` stable (3.39). The `TODO(contract)` at `profile_screen.dart:240` is stale (C17) | ops table `:49-51`; changelog `:107-115` |
| S12 | Points ~20× the design | Open | OPEN (unchanged; forwarded answers +1) | changelog `:16-22` |
| S13 | "Pass" threshold | Open | OPEN. No field | grep → none |
| S14 | Review from history | Narrowed | **ANSWERED.** `getQuizReview` stable (3.39); `listQuizHistory` stable (3.43) | ops table `:44-45`; changelog `:36` |
| S15 | Pool progress bar | Open | OPEN (not re-checked) | — |
| S16 | "Daily" vs weekly | Open | OPEN (built around) | — |
| S17 | Two-section explanation | Open | OPEN (not re-checked) | — |
| S19 | Subject name on quiz | Open | OPEN as an ask; built client-side 2026-09-26 | `seif_fight.md:1057` |
| S20 | `PATCH /me` school/geography | Open | OPEN (not re-checked) | — |
| S21 | v1.1 inconsistencies | Open | Probably obsolete (cites the old pins) | `seif_fight.md:1092` |
| S24 | Solved Questions | Open | **ANSWERED.** `getMyQuizSummary` (stable in 65245be and 2e5bb69; not in 0df5cf4) | ops table `:42`; `openapi.yaml@2e5bb69` getMyQuizSummary |
| S25 | Rank "HERO" | Open | OPEN | — |
| S26 | Three themes | Open | OPEN (built with two) | — |
| S27 | Show Rank, two booleans | Open | Superseded by the 2026-09-29 adr-111 note; the remainder is BUG-017 wording | `seif_fight.md:1204-1218` |
| S28 | Notification preference storage | Open | **OPEN.** No preference field at 3.45 | grep `notificationPref\|pushEnabled` → none |
| S29 | Avatar upload | Open | **OPEN (still draft).** `uploadCustomAvatar` and `removeCustomAvatar` are draft at 3.45; spec finalised at 2,097,152 bytes | ops table `:24-25`; changelog `:79-83` |
| S30 | Legal copy | Open | **ANSWERED by the contract.** `getLegalDocument` is stable (3.43) and public, and the text is rendered in-app. The backend states staging answers 200 (BACKEND claim, not observed from this repo). Whether that text is approved for production is not known | `openapi.yaml@2e5bb69:811-830`; changelog `:38` |
| S31 | Go to Uni | Open | **ANSWERED.** `transferToUniversity` stable (3.39), with points semantics (schoolPoints stays; totalPoints carries). Only `secondary3` students are eligible | `openapi.yaml@2e5bb69:1338-1370` |
| S32 | "your progress" | Open | OPEN. No operation | — |
| S33 | Customer Support | Open | **ANSWERED (text).** Five operations stable (3.39). The photo operations are still draft | ops table `:57-64` |
| S34 | `parentPhone` write-only | Open | OPEN. `StudentProfile` still has no `parentPhone`; recovery returns `parentPhoneMasked` only | `openapi.yaml@2e5bb69:497-500,4141-4189` |
| S35 | Raw wire codes | Open | OPEN (not re-checked) | — |
| S36 | Friends | Open | **PARTLY ANSWERED** (corrected in verification). Ask (1), no endpoint: answered, the friend graph is stable (3.37). Ask (2), no entry point: **still open**. The Profile hub has no Friends row, nothing in `lib/` navigates to `/friends` (only the route at `app_router.dart:423` and the screen's own comment mention it), and `friends_screen.dart:9` still carries the stale `TODO(contract)` (C17). The handoff's "S36 entry point" question is exactly this | `seif_fight.md:1375-1389`; ops table `:65-76`; SOURCE grep `/friends` over `lib/` |
| S37 | Staging missing routes | Open, narrowed | **STALE. Close it** | C7 |
| S38 | Account deletion | Narrowed | Operations stable. Asks (2)/(3) are largely answered by the `requestAccountDeletion` prose (30-day grace, session revoked, leaderboard removal, same phone starts from zero). **Still blocked on design and the copy ruling (DR-03).** | `openapi.yaml@2e5bb69:1267-1292` |
| S39 | When a point is credited | Open | OPEN (not re-checked) | — |
| S40 | `createQuiz` 403 precedence | Open | **OPEN.** The only "Checked in this order" lines in the contract are for `forwardQuestion` (`:3722`) and `answerForwardedQuestion` (`:3788`); none is `createQuiz` (corrected in verification) | `openapi.yaml@2e5bb69:3722,3788` |
| S41 | Tree 403 discriminator | Open | OPEN (not re-checked) | — |
| S42 | `termId`/`termNumber` optionality | Open | OPEN (not re-checked) | — |
| S43 | Replay-quiz guidance | Open | OPEN. `retakeWrong` text is unchanged since 3.11 | `openapi.yaml@2e5bb69:1783-1852` |
| S44 | Mistakes untestable on staging | Open | **Premise stale** (C6). Re-probe on staging | reconciliation `:390-391` |
| S45 | `avatarId` 400 vs 404 | Open | OPEN (not re-checked) | — |

**Not in the register at all:** Q-B1…Q-B10 (retention and sub-processors, deletion copy, production host and reviewer login, level ladder, `Retry-After` format, refresh 4xx set, the `/reference/cities` 400 body, S-batch, display-name moderation, `/redeem`). They are listed in `release_readiness_reconciliation_2026-10-06.md:201-214` (under the heading at `:199`, "none is filed yet unless an S-number is given") and were never filed (roadmap GAP4-01, P1). New contract-era asks surfaced here are also missing:

- the signed-out "contact Support" channel for `403 account_banned`, since all support operations require sign-in (`openapi.yaml@2e5bb69` createSupportTicket `'401'`; `error-codes.md@2e5bb69:51`). Of the 19 `security: []` operations at 3.45 (python parse), none is a support operation, and the top-level `security: bearerAuth` (`:110-111`) applies to all of them;
- the `getTermsAcceptance` vs `getLegalDocument` prose (C14);
- whether staging push delivery will be switched on for verification.

##### Open risks (`docs/RISKS.md`)

| Risk | Status | Owner | Effect of 3.39–3.45 and the handoff |
| --- | --- | --- | --- |
| R-3 CI never observed | OPEN, accepted by choice (`:55-63`) | Developer | Unchanged. `merged` is 1 ahead of `origin/merged`; CI runs cannot be checked from this machine (roadmap P-06) |
| R-4 Release build on a device | OPEN, NARROWED (`:70-78`) | Developer | Remainder: a prod-flavor, production-keystore run. The 2026-10-06 run was on the **AVD** (C4) |
| R-5 Lifecycle guard structural only | ACCEPTED (`:82-90`) | Engineering | — |
| R-7 Ratchets can rot | ACCEPTED (`:106-114`) | Whoever reduces a count | — |
| R-8 Real API coverage | OPEN, NARROWED (`:118-126`) | Backend partner + engineering | **Widened.** 28 app-buildable operations are stable at 3.45 and were not stable at the staged `65245be` (42 versus the committed `0df5cf4`; python over `SCRATCH/ops_table.txt`). This repo has no call site and no smoke coverage for the path families it checked (`/conversations`, `/support/tickets`, `/me/invite`, `/me/track-transfer`, `/me/favorites`, `/reference/legal-documents`: matches in `lib/`, `test/`, `tool/` are only comments at `profile_screen.dart:240` and `quiz_question.dart:47` and one profile test), so none of them has been exercised by this app against staging. The backend states `getLegalDocument` answers 200 on staging (changelog `:38`; not observed here). The chat hub and push are untested. Two stale cells: Impact ("`TBD.example`", `:122`) and Next action (`:125`, S37 "two left", contradicted by `:126`) |
| R-9 Identity | OPEN, MITIGATING (`:130-138`) | Product owner (D-021) / engineering (Env Waves 1–3) | iOS ids and target are still template values (orchestrator facts). Firebase registration of the four ids is now on the push path (handoff 6) |
| R-10 `/redeem` hand-off vs purchase silence | OPEN, DECISION (`:142-150`; opened 2026-10-06, never closed) | Product owner + Seif | **Made live** by handoff (1). adr-049 §3 is unrevised at 3.45 |
| R-11 iOS required-reason API via `device_info_plus` | OPEN, HIGH (`:154-162`) | Engineering + product owner (O-3/DR-02) | Unchanged |

Closed: R-1 (its own heading, `RISKS.md:14`, "CLOSED 2026-08-21"), and R-2 and R-6 (the Closed table, `:166-179`, which also lists C-1, C-2 and the Wave 2 / 2.1 / 4 items) (corrected in verification: the Closed table does not name R-1). The roadmap's 20 risks (contract drift, backend production slip, UGC, minors, no crash visibility, the iOS 26 ScreenProtectorKit crash, keystore custody, …) live only in the untracked JSON. **They are not in `docs/RISKS.md`.**

##### Open known bugs

| Item | Status | Evidence |
| --- | --- | --- |
| **BUG-017** "Hide my points" help line contradicts adr-111 | **OPEN.** Waiting on owner wording, EN + AR (= DR-09). It is the only non-✅ entry in the file | `KNOWN_BUGS.md:570-590` |
| BUG-020 remainder: Lectures rows and other catalogue names take the app's direction | Open, "Still open, outside this fix" | `KNOWN_BUGS.md:676` |
| BUG-002 (both halves fixed) | 1.3 text-scale proof is emulator-only; physical-phone check not run | `KNOWN_BUGS.md:117-125`; reconciliation `:379` |
| BUG-025 | Fixed at SOURCE plus guard; device reproduction impossible by nature | `KNOWN_BUGS.md:765-766` |
| BUG-015 and BUG-018 (added in verification) | FIXED, but both status lines still say "Not yet device-verified" although the Wave 19 and Wave 21 walks have run (C8). Housekeeping, not defects | `KNOWN_BUGS.md:516`, `:593-594`; `wave_state.md:61,67` |
| **Unrecorded:** a Retry on a still-loading profile lands after a fresher answer and replaces it (probe-proven, pre-existing) | **Not in KNOWN_BUGS and not in the roadmap** (`grep -c -i fresher docs/KNOWN_BUGS.md` → 0; a retry+profile search over the roadmap's `master_issues` returns only JOURNEY-02, which is unrelated) | `wave_state.md:1834-1835` |
| Wave items parked for the owner: W02-7 (landscape overflow), W02-8 (Back from OTP success), W18-3, the review's AI-glyph size, #114 (provisional Arabic strings), DESIGN_ISSUES #90, D-019 placement | Owner calls | `wave_state.md:20,24,107,1830-1836` |

##### Roadmap critical path, workstreams and gates at 3.45

| Stage / stream / gate | Still valid? | Why (evidence) |
| --- | --- | --- |
| S1 Truth sync (push `8e641e9`, observe CI) | **VALID** | `merged` is 1 ahead; R-3 open |
| S2 Owner decision batch | **VALID, list STALE** | DR-24 is moot. DR-01/04/05/08/11/14/18/23/25/27 are reframed (table below; corrected in verification, the earlier list omitted DR-08 and DR-27). New decisions N-01…N-15 must join it |
| S3 Backend production readiness (E-1/E-6/E-7/E-8, Q-B2, DR-17) | **VALID, unchanged** | `servers:` is still staging only (`openapi.yaml@2e5bb69:107-109`). Reviewer OTP is still "Absent from production" (`:98`, identical at `0df5cf4`). Deletion copy is unchanged (`:1284`). No min-version signal (grep) |
| S4 Content and design inputs | **PARTLY STALE** | Legal text is now backend-served (`getLegalDocument`). The design-input list grows by the handoff (3) items, plus Figma corrections (handoff 2: Subscription, referral numbers, chat photos/voice/groups) |
| S5 Flutter release-1 code waves | **STALE in scope** | It assumes "hide Message tab and inert surfaces" and a "legal URL swap". At 3.45, inbox, chat, support, refer, friends, legal, transfer, recovery, history, review and favourites all have stable operations. Mandatory client items are added: `Accept: application/json` (3.32; SOURCE today: no `Accept` header anywhere in `lib/`, and `error_interceptor.dart:9-10` carries a comment the 3.32 correction made false, C16, added in verification), the unknown-outcome rule for a non-2xx without a parsable body and `code` (`openapi.yaml@2e5bb69:3884-3890`), a banned screen for `403 account_banned` on `verifyOtp` (3.42, BEHAVIOURAL, changelog `:60-66`), and a WebSockets-only hub with `skipNegotiation` if chat is built (changelog `:30-33`) |
| S6 iOS Wave 3 | **VALID** | It also needs APNs and the Push capability if push is adopted (INFERRED from handoff 6) |
| S7 Integration on production | **VALID** | The smoke harness must grow to the new consumed operations (`tool/smoke/real_api_smoke_test.dart` has none of the 3.39–3.45 paths) |
| S8 RC freeze / S9 Store submission / S10 Post-release | **VALID** | The data-safety and App Privacy forms must cover chat, photos and the push token if those ship |
| WS-A Backend | VALID, plus new asks | banned-contact channel, Terms prose, staging push switch-on, Q-B batch |
| WS-B Owner decisions | VALID, DR set outdated | — |
| WS-C Legal/content | **CHANGED** | The backend serves the text; E-7 facts and a store-listing URL are still needed |
| WS-D Flutter release-1 code | **CHANGED** (scope) | see S5 |
| WS-E Design | **CHANGED** | Handoff (3) lists 15 designs that do not exist |
| WS-F iOS (Mac) | VALID, plus APNs | — |
| WS-G Android release | VALID, plus per-flavor Firebase config if push ships | handoff (6) |
| WS-H QA | VALID | Realtime and push can't be DEVICE-verified while delivery is off everywhere (`realtime.md@2e5bb69:80`) |
| WS-I Store console / WS-J Docs hygiene | VALID | WS-J gains C1–C17 above |
| G-01 Requirements | VALID; matrix must be rebuilt at 3.45 | C9 |
| G-02 Decisions | **CHANGED** (DR set grows) | — |
| G-03 Backend contract (pin == upstream at RC) | VALID | The committed pin `0df5cf4` is 17 minor versions behind upstream (3.28 → 3.45; 20 upstream commits) |
| G-04…G-07, G-09…G-14 | VALID | — |
| G-08 Privacy ("hosted policy + terms reachable signed-out") | **CHANGED wording** | In-app public `getLegalDocument` now covers in-app reachability. A hosted URL for store listings is a separate question |

##### New decisions that are not in DR-01…DR-29

| ID | Decision | Who | Evidence |
| --- | --- | --- | --- |
| N-01 | **Subscription screen.** Should there be an entitlement status/info screen (`getMyEntitlements` is stable and consumed only in the data layer), and may it carry a website link? This conflicts with adr-049 §3 and R-10 unless Seif revises the contract; Apple 3.1.1/3.1.3 exposure goes with it | Mostafa + Seif (changelog) | handoff (1); `RISKS.md:142-150`; `ENVIRONMENTS.md:405`; roadmap PRIV-STORE-12 (P1) |
| N-02 | **Target pin.** Land `65245be` (3.38) as staged, or re-vendor straight to `2e5bb69` (3.45)? This supersedes DR-23's framing. Constraints from the repo: roadmap gate G-03 requires pin == upstream HEAD at RC; DR-23's own recommendation was to commit one contract commit before Phase 2 starts, so Phase 2 builds against one pin; `3.42` adds a BEHAVIOURAL `403 account_banned` to the consumed `verifyOtp`, so any pin below 3.42 leaves the app one behavioural change behind staging | Mostafa | orchestrator facts; changelog `:7-115`, `:60-66`; roadmap G-03, DR-23 |
| N-03 | **Chat in release 1:** text chat (8 ops + hub), forwarded questions and friend streaks (3.44). Report, block, unfriend and the blocked list have **no design**. Figma's photo, voice and group chat have **no backend** (`realtime.md@2e5bb69:17`) | Mostafa + designer | handoff (2), (3) |
| N-04 | **Support in release 1:** text tickets (stable); photos wait for the draft operations; the photo Terms gate (`403 terms_acceptance_required`) | Mostafa | `error-codes.md@2e5bb69:67`; ops table `:57-64` |
| N-05 | **Refer a Friend:** build on `getMyInvite` plus the registration `inviteCode`. Figma copy (500/500) must change to the contract rule (+10 to the inviter, nothing to the new student). Choose a share mechanism ("however the app lets the student share text") | Mostafa + designer | `openapi.yaml@2e5bb69:1434-1445` |
| N-06 | **Lost-phone recovery** (4 stable ops) in release 1. No design | Mostafa + designer | handoff (3); ops table `:9-12` |
| N-07 | **Banned-account screen:** copy, and how a signed-out student reaches Support | Mostafa + Seif | changelog `:60-66`; support ops 401 |
| N-08 | **Terms step:** where it sits (the contract says "during registration and from settings", `:819`), whether it blocks (the contract says acceptance is "recorded, not enforced", `:1121-1125`), and its design (missing) | Mostafa + designer | handoff (3) |
| N-09 | **Track transfer:** show "Go to Uni" only to `secondary3` students, or show it and handle `403 track_transfer_not_eligible`. Confirmation design is missing | Mostafa + designer | `openapi.yaml@2e5bb69:1352-1356`; `profile_screen.dart:330-337` (stale S31 TODO at `:331`, "built, confirm disabled", C17) |
| N-10 | **"Logged in on another device" screen** (`session_superseded`) — no design. Today it is a forced logout to `/login` | Mostafa + designer | handoff (3) |
| N-11 | **Quiz history, review from history and favourites in release 1** (stable 3.39/3.43) | Mostafa | ops table `:44-51` |
| N-12 | **New third-party dependencies:** Firebase (push), a SignalR client (chat hub), a Markdown renderer (`contentMarkdown`), an image picker (support photos / avatar), a share mechanism. Each changes the "zero SDKs" privacy position (roadmap DR-12 premise) | Mostafa (privacy trade-off) | `pubspec.yaml:30-65` (none present) |
| N-13 | **Push UX:** permission-prompt timing on Android 13+ and iOS. It is in the handoff only. The 3.43 push section of `realtime.md` has no "permission" or "prompt" text (`git show 2e5bb69:realtime.md \| grep -n -i 'permission\|prompt'` → no output). The only contract guidance is negative and entry-scoped: the 2026-09-16 inbox entry (`3.18.0-m1` → `3.19.0-m1`, while the inbox was still `draft`) said not to build a push-permission prompt **from that entry** (`contract-changelog.md@2e5bb69:294,301`); the inbox went stable on 2026-09-26 (`:211`). It is not a 3.28 entry (corrected in verification). Push strings render from **native** resources in the phone's language, not the in-app switch (`realtime.md@2e5bb69:83`), so the ARB parity guard won't cover them. Added in verification: D-021 Q7 (Seif input) records "no deep links in release 1" (`DECISIONS.md:1060`), while the push contract requires a notification tap from a closed or backgrounded app to open a ticket, the friend-requests list, a conversation or the notifications screen (`realtime.md@2e5bb69:106`). `DECISIONS.md` is silent on whether the two interact (INFERRED: the tap path is data-key routing, not URL deep linking) | Mostafa + designer | handoff (6) |
| N-14 | **Inbox copy** for kinds without contract text: `enrolment_opened`, `academic_year_opened` (with params), and `support_ticket_replied` (the EN guidance only, no AR) | Mostafa / designer | `openapi.yaml@2e5bb69` listMyNotifications 200 description; `notification_inbox_3_28_investigation.md:343-349` (D1) |
| N-15 | **Process:** a new FORMULATE (the 22-wave list is exhausted), how non-screen work (Env Waves 2–4, E-4, the global 403 routing, the `Accept` header, store work) fits "one screen per wave", and the commit policy (see the protocol section) | Mostafa | `wave_state.md:1836-1837` |

#### Decision register status (DR-01..DR-29)

"DECISIONS.md" = whether `docs/DECISIONS.md` (D-001…D-021) records an answer. It records none of them; the one partial exception is noted under DR-19. Dating (added in verification): the account-deletion, push and "which surface is the inbox" decisions were already recorded as unresolved product decisions in the COMPARE carry-over list (`wave_state.md:144,145,148`; the file's workflow state was reconciled 2026-09-24, `:5`), so DR-01, DR-03 and DR-11 have been pending since 2026-09-24, not only since the 2026-10-06 reconciliation.

| DR | Question (short) | Roadmap recommendation | DECISIONS.md | What 3.39–3.45 or the handoff changes | Status |
| --- | --- | --- | --- | --- | --- |
| DR-01 | Message tab: hide, or build the inbox | (a) hide for release 1 | none (O-1 unrecorded) | Chat 8 ops + hub stable (3.39); forwarded questions/streaks (3.44). Inbox kinds grow: `moderation_warning` (copy supplied), `support_ticket_replied`, `academic_year_opened`. Push taps target the notifications screen and conversations (`realtime.md@2e5bb69:106`). Option (b) now means inbox and/or chat; the D2 question (tab or bell) is still unresolved (unsettled since 2026-09-24, `wave_state.md:148`). The handoff lists chat photos/voice/groups with no backend, and report/block/unfriend with no design | **OPEN — CHANGED** |
| DR-02 | E-4 fix shape | MethodChannel or drop `model` | none | Nothing in the contract. If push is adopted, Firebase's iOS SDK joins the Wave 3 Privacy Report review (INFERRED) | **OPEN** |
| DR-03 | Deletion confirm copy ("paid subscription is forfeited") | (b) ask Seif for an app-safe variant | none | The mandated copy is unchanged at 3.45 (`openapi.yaml@2e5bb69:1284`; was `@0df5cf4:1091`; the sentence "An active paid subscription is forfeited — there is no partial refund…" is identical). The handoff confirms deletion and cancellation designs are missing. Pending since 2026-09-24 (`wave_state.md:144`) | **OPEN (unchanged)** |
| DR-04 | Leaderboard names (UGC): Option 0 vs report/block + terms | Option 0 | none | Block ops stable (3.37). `reportStudent` stable at 3.39 (`:3667-3670`; draft at 65245be, `:3316-3320` of the worktree copy). Bans and `moderation_warning` (3.42). Terms text and acceptance are now meaningful. No display-name moderation was found at 3.45 (grep over `openapi.yaml` hits only the `scopeName` field; `error-codes.md` has only `image_rejected_by_moderation` for photos) | **OPEN — CHANGED** (Option 1 is now contract-buildable but needs design) |
| DR-05 | Inert surfaces (toggles, Coming-soon sections, Refer/Support/Friends shells, dead referral field) | hide | none | Refer, Support, Friends and the registration `inviteCode` are now buildable. The notification toggles still have no storage (S28). Daily tasks still have no operation | **OPEN — CHANGED** |
| DR-06 | Orientation | lock portrait | none (W02-7 parked, `wave_state.md:20`) | — | **OPEN** |
| DR-07 | iPad | iPhone-only | none | — | **OPEN** |
| DR-08 | Minors (age groups, purpose text) | legal memo | none | Scope widens: peer chat, `lookupStudentByPhone`, safety-scanned photos, FCM | **OPEN — CHANGED** (scope) |
| DR-09 | BUG-017 wording | owner wording | none (BUG-017 OPEN) | — | **OPEN** |
| DR-10 | Mid-quiz persistent failure | allow Finish, withhold Retry | none | — | **OPEN** |
| DR-11 | Push in v1 | record "no push in v1" | none (D-021 Q7 is input only) | The push shape is stable (`realtime.md@2e5bb69:80-108`); server senders exist behind gates (changelog `:34`); delivery is off. The handoff (6) asks for it to be built. The recommendation no longer matches the backend's direction. Pending since 2026-09-24 as "Push: stable op, no Firebase setup, toggles have no contract storage → product decision" (`wave_state.md:145`). If push ships, D-021 Q7's "no deep links in release 1" needs reconciling with notification-tap routing (N-13) | **OPEN — CHANGED** |
| DR-12 | Crash visibility | decide before RC | none | Adopting Firebase ends the "zero SDKs" premise | **OPEN** |
| DR-13 | Dart obfuscation | off for release 1 | none | — | **OPEN** |
| DR-14 | Legal: in-app routes or hosted pages | hosted pages (needed by both stores anyway) linked from Login; in-app screens optional | none | `getLegalDocument` is public, stable since 3.43, and "rendered IN the app rather than by opening a browser (Seif 2026-10-07)" (`:816-830`); staging answers 200 (changelog `:38`). The roadmap's recommendation contradicts the contract's intent. A store-listing URL is a separate need. `login_screen.dart:46-49` still holds three `levelup.example` placeholder URLs | **OPEN — CHANGED** (the contract answers the in-app half) |
| DR-15 | Back on OTP success / tab roots | to `/home` | none (W02-8 owner's call) | — | **OPEN** |
| DR-16 | Refresh after a quiz | invalidate | none | `getMyQuizSummary` also goes stale if consumed | **OPEN** |
| DR-17 | Min-version / forced update | ask Seif | none | No signal at 3.45 (grep) | **OPEN** |
| DR-18 | Store and Firebase ownership | client organisation accounts | none (D-021: "not decided here") | The handoff requires separate staging and prod Firebase projects for the two ids, so Firebase ownership is now on the push critical path. D-021 Q7 already logs ownership and project sharing as unsettled | **OPEN — CHANGED** (urgency) |
| DR-19 | Replay quiz in release 1 | keep inert | **partial**: owner ruling 2026-09-12 put it out of Day 10 scope (`WAVE_STATUS.md:179`, `wave_state.md:72`); not a release-1 ruling | S43 unanswered; the favourites-mode quiz is now buildable | **OPEN** (prior scope ruling exists) |
| DR-20 | APK distribution / `country_flags` | AAB-only | none | — | **OPEN** |
| DR-21 | Performance bar | one profile pass | none | A realtime chat would widen the scope | **OPEN** |
| DR-22 | Seif follow-up batch (S40, Q-B4/5/6, S45, close S37, narrow S38) | file now | none; **never filed** (0 matches) | S40/Q-B4/Q-B5 unanswered at 3.45. S37 stale. S38 asks (2)/(3) mostly answered by prose | **OPEN** (not filed) |
| DR-23 | Land re-vendor `65245be` | commit as one contract commit | none | Upstream is now `2e5bb69` (3.45), 12 commits past `65245be` (`git rev-list --count 65245be..2e5bb69` → 12) and 20 past `0df5cf4`. 3.42 adds `403 account_banned` to `verifyOtp`, which the app consumes (BEHAVIOURAL). The question becomes "which pin" (N-02) | **OPEN — CHANGED** |
| DR-24 | `transferToUniversity` draft vs the stable-only rule | keep the rule | none | Stable since 3.39 (`:1338-1342`; `ops_table.txt:34` is `-/draft/stable`). The conflict disappears at any pin at or above 3.39. What remains is scope plus missing design (N-09) | **MOOT** (once the pin is 3.39 or later) |
| DR-25 | Release-1 feature scope | ratify a cut | none | About 77 app-buildable stable ops at 3.45 vs 49 at 3.38 and 35 at the committed `0df5cf4`. Forwarding and streaks now exist. The live-leaderboard hub is still "not drafted" (`realtime.md@2e5bb69:9`). Daily tasks and the camera streak have no operations | **OPEN — CHANGED** (matrix must be rebuilt) |
| DR-26 | Mac + Apple team | name both now | none | iOS push needs APNs under the Apple team (INFERRED) | **OPEN** |
| DR-27 | Data-protection basis | commission an assessment | none | Scope widens: chat retention (24 h / 30 d), photo safety-scanning, phone lookup, FCM | **OPEN — CHANGED** (scope) |
| DR-28 | Licence notices | About/Licences row | none | — | **OPEN** |
| DR-29 | Predictive back | decide with an Android 16 walk | none | — | **OPEN** |

**Count (corrected in verification):** 0 ANSWERED; 1 MOOT (DR-24, conditional on the pin); 10 OPEN — CHANGED (DR-01, 04, 05, 08, 11, 14, 18, 23, 25, 27); 1 OPEN with a partial prior scope ruling (DR-19); and 17 OPEN and unchanged (DR-02, 03, 06, 07, 09, 10, 12, 13, 15, 16, 17, 20, 21, 22, 26, 28, 29). 0 + 1 + 10 + 1 + 17 = 29.

#### Wave protocol constraints

These rules are in force today. The final workflow must follow them, or Mostafa must explicitly change them.

| # | Rule | Source |
| --- | --- | --- |
| P-1 | No wave starts, no screen is touched, no WALK runs and nothing advances without the owner's explicit **`NEXT`**, **`WALK`** or **`FORMULATE`**. Never auto-advance. Other owner verbs seen in the record: "STOP BEFORE NEXT", `fix` | `wave_state.md:5,92-94,1236,1836-1837` |
| P-2 | **One screen per wave** (waves = screens = 22). A READY screen still gets a verify-and-walk wave. The wave list is frozen and changes only on `FORMULATE` (e.g. D-019's wave waits for one) | `implementation_waves.md:5-8` (corrected in verification; was `:4-7`); `wave_state.md:12`; `DECISIONS.md:982-983` |
| P-3 | Subagents are **Sonnet only**. Replies are concise. Checkpoint `wave_state.md` at about **40%** context and ask the owner to run `/compact` | `wave_state.md:92-94` |
| P-4 | Standing per-wave steps: `git status` + `ListAgents` and announce the file list; never touch `contract/` except to re-vendor; use the build-screen, figma-frame, screen-states, river/bloc, seif-api-contract and level-up-domain skills; re-read the frame at build time; `validate.ps1` OVERALL PASS with a count at or above the previous wave's (baseline 1429 when formulated); rulings go into DESIGN_ISSUES / seif_fight in the same wave; never invent a value | `implementation_waves.md:11-19` |
| P-5 | **Acceptance scoring:** % = passed / listed criteria, where **F** = functional, **V** = visual, **I** = interaction/a11y. Criteria the mock cannot exercise are N/A and excluded. A walk runs on the physical Pixel 8 (`wave_state.md:61,67`) with `uiautomator` coordinates (`implementation_waves.md:20-24`). Typical cycle: walk → owner says fix → re-walk to 100% | `implementation_waves.md:25-27`; `device_walk_results.md:22-36` |
| P-6 | Nothing is committed unless the owner asks. One concern per commit. A contract re-vendor is its own commit | `implementation_waves.md:28-29` (corrected in verification; was `:31-32`) |
| P-7 | Canonical loop: DISCOVER → INSPECT → PLAN → IMPLEMENT → FORMAT → ANALYZE → TEST → GUARD PROOF → AUDIT EVIDENCE → COMMIT → FABLE. Predict the test count before running. Never stack unvalidated batches. DO-NOT-GUESS classes A–G. The stop-and-ask list. The never-invent list | `AGENT_WORKFLOW.md:17-57,207-290` |
| P-8 | The **Environment chapter** protocol differs: snapshot → read-only investigation → implementation → validation → post-wave audit → **focused commit** → report with rubric score, supported versions and a backend sentence | `env_chapter_state.md:6-7` |
| P-9 | Repo-level: never edit `contract/`; never force-push `main`/`dev`; work on `merged`. Never run `validate.ps1` casually, because it rewrites the tracked `test-results.md`. Concurrent sessions announce file lists | `CLAUDE.md`; `implementation_waves.md:11-12` |

**Where these rules collide with the remaining work (each needs a FORMULATE ruling, or for Mostafa to change a rule):**

1. **The WALK build command is stale.** `implementation_waves.md:20` says `flutter build apk --debug -t lib/main_mock.dart`. Since `2dfd969`, Gradle refuses a flavorless build (`android/app/build.gradle.kts:119-131`, `allowedEntrypoints(flavor, buildType)` with `else -> emptySet()`; the commit message says a flavorless `assembleRelease` assembles both flavors and no entrypoint satisfies both). The valid command is `--flavor staging -t lib/main_mock.dart` (`ENVIRONMENTS.md:248`; `:252-253` "A bare `flutter run` (no flavor) fails"). The mock and staging builds now share `com.levelupworld.app.stg`, so each install replaces the other (reconciliation `:385`).
2. **The mock backend covers none of the 3.39–3.45 features**, nor the inbox or deletion. In `lib/dev/mock_backend.dart` (2765 lines), `/conversations`, `/support/tickets`, `/friends`, `/me/invite`, `/auth/recovery`, `/reference/legal-documents`, `/me/notifications`, `/me/deletion-request`, `/me/track-transfer`, `/me/favorites` and `/me/fcm-token` each have 0 matches; so do `/blocks`, `/friend-requests`, `/me/avatar`, `/me/terms-acceptance` and `/me/quiz-summary` (added in verification). The route literals present are only `/auth/{otp/request,otp/verify,register,refresh,logout}`, `/me`, `/me/entitlements`, `/me/mistakes`, `/catalog/subjects`, `/quizzes`, `/leaderboard` and six `/reference/*` paths (`mock_backend.dart:156-549`). Their F criteria would be N/A unless each wave adds mock work first, as Wave 20 did with `PATCH /me` (`wave_state.md:141-142`).
3. **Realtime chat and push cannot be walked on the mock.** Push delivery is off in every environment (`realtime.md@2e5bb69:80`), so push-tap flows cannot reach DEVICE level until Seif switches staging delivery on.
4. **Multi-screen features** (deletion request/confirm/cancel; chat list/conversation/report/block; support list/ticket/new; recovery ladder) and **non-screen work** (Env Waves 2–4, E-4 MethodChannel, global `403 account_pending_deletion` / `account_banned` routing, `Accept` header and the unknown-outcome rule, C16) do not fit "one screen per wave".
5. **Commit policy differs** between API→UI waves (commit on owner request) and Env waves (focused commit per wave).
6. **iOS waves** cannot be walked on the Pixel 8 and need the Mac (DR-26).


## 18. Evidence index


**git** (13 items): git branch -vv; git branch -a -vv; git status -sb; git status --porcelain=v1 --untracked-files=all; git status --ignored --short; git rev-parse HEAD; git log -1; git rev-list --left-right --count merged...origin/merged | main...origin/main | dev...origin/dev | merged...main | dev...merged ; git remote -v; git ls-remote origin; git for-each-ref refs/remotes; git tag; git stash list; git worktree list [--porcelain]; ls .git, .git/hooks, .git/worktree; git log origin/dev..dev; git cherry -v merged dev; git cherry -v origin/merged dev; git branch -a --contains <6 shas>; git merge-base dev merged | dev origin/de; git log main..merged (32 commits, authors, trailers, conventional-subject check); git log --reverse 99b5cba..merged; git hash-object --no-filters and plain on contract/{openapi.yaml,contract-changelog.md,error-codes.md,realtime.md}; git rev-parse :contract/<f> and HEAD:contrac; git diff --stat; git diff --numstat; git diff --cached --stat; git diff contract/SOURCE.md; contract/SOURCE.md:1-25; git -C upstream ls-tree --name-only 65245be; git -C .claude/worktrees/{angry-antonelli-cf9094,jovial-bhaskara-018e57} status --short | diff | log -1; git apply --check on both patches (SCRATCH/angry_wt.pat; git log merged..backup/2026-08-22-dirty-tree; git show --stat backup/2026-08-22-dirty-tree; git diff-tree on the snapshot (143 files, SCRATCH/backup_files.txt, ; level_up_master_completion_roadmap.json (python json keys generated, repo, counts, verdict); level_up_master_completion_roadmap.html (first 400 KB only: title, ; docs/WAVE_STATUS.md:1-62, :107-110; .ai/audits/current/wave_state.md:3, :86-118, :327, :345, :1827-1836; .ai/audits/current/test-results.md:1-30; .ai/audits/cur; gh --version; gh auth status (token redacted); gh run list --repo zlatanibrahimovichsweden-61/level-up-app --branch merged -L 10 and -L 100 / --branch main -L 5; /f/level/level_up/level_up_app/.github/workflows/ci.yml:1-60, :171-180, :260-262, :318-400; git show main:.github/workflows/ci.yml; git diff --stat main merged 

**contract_delta** (34 items): F:\level\level_up\level_up_app\contract\openapi.yaml (working tree = 65245be; hash-object --no-filters c26b51dd…); F:\level\level_up\level_up_app\contract\SOURCE.md (git diff vs HEAD, working-tree 3.38 text); F:\level\level_up\level_up_app\contract\error-codes.md, realtime.md, contract-changelog.md (hash-object vs upstream); C:\Users\musta\AppData\Local\Temp\claude\F--level-level-up-level-up-app\513a53c3-37d2-4201-8dd7-79f979aa4042\scratchpad\openapi_0df5cf4.yaml, openapi_65245be_wo; ...\scratchpad\upstream-contract (git log 0df5cf4^..2e5bb69; git show <rev>:openapi.yaml|error-codes.md|realtime.md|contract-changelog.md; git diff 65245be 2e5b; ...\scratchpad\changelog_2e5bb69.md (lines 1-219 read: entries 3.29–3.45), plus :312-318, :564; ...\scratchpad\census.py, per_commit.py, errcodes.py, consumed_diff.py (modes ops/schemas/bound), enums.py, sec.py, unconsumed.py, cite_drift.py, dartcheck\chec; F:\level\level_up\level_up_app\lib\core\network\dio_client.dart:15-20; F:\level\level_up\level_up_app\lib\core\network\interceptors\error_interceptor.dart:1-89; F:\level\level_up\level_up_app\lib\core\network\interceptors\auth_interceptor.dart:56-58, :68-83, :160-163; F:\level\level_up\level_up_app\lib\core\network\exceptions.dart; F:\level\level_up\level_up_app\lib\features\auth\repository\auth_repository.dart; F:\level\level_up\level_up_app\lib\features\auth\notifier\otp_notifier.dart:98-172; F:\level\level_up\level_up_app\lib\features\auth\auth_error_copy.dart; F:\level\level_up\level_up_app\lib\features\auth\screens\otp_screen.dart:224-304; F:\level\level_up\level_up_app\lib\features\auth\models\auth_result.dart and auth_result.g.dart:9-14; F:\level\level_up\level_up_app\lib\features\registration\repository\registration_repository.dart, reference_repository.dart; F:\level\level_up\level_up_app\lib\features\registration\models\registration_draft.dart:10-30; screens\signup_identity_screen.dart:85-97; F:\level\level_up\level_up_app\lib\features\profile\models\student_profile.dart; repository\profile_repository.dart; F:\level\level_up\level_up_app\lib\features\profile\screens\profile_screen.dart:236-340; widgets\avatar_sheets.dart:192-200; F:\level\level_up\level_up_app\lib\features\account_shells\screens\friends_screen.dart, legal_document_screen.dart, refer_a_friend_screen.dart, customer_support; F:\level\level_up\level_up_app\lib\features\home\widgets\home_header.dart:26-36; lib\core\config\app_config.dart:40-52; F:\level\level_up\level_up_app\lib\features\leaderboard\notifier (leaderboardProvider autoDispose :197), models\leaderboard_models.dart, repository\leaderboard_; F:\level\level_up\level_up_app\lib\core\session\session_scope.dart; F:\level\level_up\level_up_app\lib\l10n\app_en.arb:9, app_ar.arb:6 (genericError); F:\level\level_up\level_up_app\test\guards\contract_models_test.dart (full); test\guards\rules.dart:340-431; F:\level\level_up\level_up_app\pubspec.yaml:30-64; pubspec.lock (dio 5.10.0); C:\Users\musta\AppData\Local\Pub\Cache\hosted\pub.dev\dio-5.10.0\lib\src\headers.dart:22; C:\flutter\bin\cache\dart-sdk\lib\_http\http_impl.dart:2311; F:\level\level_up\level_up_app\android\app\src\main\res (values, values-night); ios\Runner (Base.lproj only), ios\Runner\Info.plist:5-8; F:\level\level_up\level_up_app\docs\seif_fight.md:589-647 (summary), S2 :671-692, S5 :719-748, S11 :882-898, S14 :927-950, S24 :1138-1153, S28-S33 :1213-1320, S; F:\level\level_up\level_up_app\docs\WAVE_STATUS.md:50-58; docs\RISKS.md:142-170 (R-10, R-11); docs\DECISIONS.md:310; docs\AGENT_WORKFLOW.md:246-290; docs\DESIGN; F:\level\level_up\level_up_app\.ai\audits\current\release_readiness_reconciliation_2026-10-06.md:160, :200-216 (Q-B1..Q-B10); api_contract_update.md header; F:\level\level_up\level_up_app\level_up_master_completion_roadmap.json (repo block; decisions DR-01..DR-29, read only); Commands: git --no-optional-locks status --short; git --no-optional-locks log -1; git --no-optional-locks show --stat 8e641e9; git hash-object --no-filters cont

**upload_push_contract** (37 items): SCRATCH/openapi_2e5bb69.yaml (read lines 1-151, 189-256, 451-461, 536-546, 618-629, 811-860, 905-1143, 1144-1262, 1334-1340, 1727-1745, 2102-2131, 2654-2982, 31; SCRATCH/upstream-contract/openapi.yaml (CRLF; tr -d '\r' | cmp vs openapi_2e5bb69.yaml -> identical); SCRATCH/upstream-contract/realtime.md (full, 108 lines); SCRATCH/upstream-contract/error-codes.md (full, 72 lines); SCRATCH/upstream-contract/contract-changelog.md -> SCRATCH/changelog_lf.md (lines 1-125, 205-216, 290-320); SCRATCH/upstream-contract/contract-changelog-admin.md, openapi-admin.yaml (grep enrolment_opened: no data-key hits); SCRATCH/openapi_65245be_worktree.yaml (uploadCustomAvatar 912-942, registerFcmToken 943-965, inbox kind enum 1071, support text-only 2487, avatar schema 3604-36; SCRATCH/openapi_0df5cf4.yaml (inbox kind enum 1018, fcm-token 896, avatar schema 2681-2682); SCRATCH/ops_table.txt; git -C SCRATCH/upstream-contract log --oneline -14; per-commit 'version:' lines; git show <c>:realtime.md/openapi.yaml grep counts for cap/push/skipNegotiation/; SCRATCH/compare_push.py (written) + 'python -I -X utf8 compare_push.py upstream-contract/realtime.md' -> ALL IDENTICAL; python -I -X utf8 SCRATCH/extract.py (PyYAML: moderation copy, per-op response codes); Apostrophe codepoint check on openapi 1031/2934 and error-codes 16 (U+0027); contract/realtime.md (working tree) diff vs upstream realtime.md; git show HEAD:contract/realtime.md; pubspec.yaml:30-65; lib/core/network/dio_client.dart:1-50; lib/core/network/interceptors/auth_interceptor.dart:45-60; lib/core/network/interceptors/error_interceptor.dart:1-60; lib/core/network/exceptions.dart:60-95; lib/core/config/app_config.dart:44,54 (grep); lib/core/router/app_router.dart:305-330, 415-423; lib/features/auth/auth_error_copy.dart:1-30; lib/features/profile/models/student_profile.dart:100-125; lib/features/profile/widgets/avatar_sheets.dart:185-230; lib/features/account_shells/screens/customer_support_screen.dart:1-16; lib/features/account_shells/screens/friends_screen.dart:9-14; lib/features/settings/screens/settings_screen.dart:335-365; lib/l10n/app_en.arb (grep push_/enrolment); Grep lib for enrolment_opened|support_ticket_replied|moderation_warning|academic_year_opened|fcm|signalr|account_banned|terms_acceptance|attachment; Grep lib for me/notifications|unread-count|/support/|/conversations|friend-requests|/me/avatar|me/invite; android/app/src/main/res/values (ls), android/app/src (ls), android/app/src/main/AndroidManifest.xml (uses-permission grep), ios/Runner (ls), ios/Runner/Info.pl; docs/ENVIRONMENTS.md:340-368; docs/DECISIONS.md:1056-1062; docs/STORE_READINESS_RUBRIC.md:14-22, 66-72; docs/seif_fight.md (headings/summary rows S11, S24, S28, S29, S33, S36); docs/DESIGN_ISSUES.md (grep attach/photo); Grep repo for '10 ?MB|PNG/JPG|PDF up to' (no design hit)

**api_census** (17 items): C:/Users/musta/AppData/Local/Temp/claude/F--level-level-up-level-up-app/513a53c3-37d2-4201-8dd7-79f979aa4042/scratchpad/ops_table.txt (86 rows); SCRATCH/openapi_0df5cf4.yaml, SCRATCH/openapi_65245be_worktree.yaml, SCRATCH/openapi_2e5bb69.yaml (read, parsed with PyYAML); SCRATCH/upstream-contract/contract-changelog.md (lines 7, 16, 30, 35-36, 60, 87, 95, 107, 128) and git log; SCRATCH scripts written and run: census_paths.py, drift.py, drift2.py, counts.py (outputs inline above); lib/core/network/dio_client.dart, lib/core/network/exceptions.dart, lib/core/network/interceptors/auth_interceptor.dart, lib/core/network/interceptors/error_int; lib/features/auth/repository/auth_repository.dart, auth/notifier/login_notifier.dart, otp_notifier.dart, auth_controller.dart, auth/auth_error_copy.dart, auth/m; lib/features/registration/repository/registration_repository.dart, reference_repository.dart, registration/notifier/reference_providers.dart, registration_submi; lib/features/profile/repository/profile_repository.dart, profile/notifier/me_notifier.dart, edit_profile_notifier.dart, profile/models/student_profile.dart, pro; lib/features/catalog/repository/catalog_repository.dart, mistakes/repository/mistakes_repository.dart, mistakes/notifier/mistakes_notifiers.dart, quiz/repositor; lib/features/account_shells/screens/customer_support_screen.dart, friends_screen.dart, legal_document_screen.dart, refer_a_friend_screen.dart, widgets/shell_bod; lib/dev/mock_backend.dart (header :1-30, dispatch :156-549, fallthrough :554-562); pubspec.yaml dependencies block; tool/smoke/real_api_smoke_test.dart (full read of structure; lines 196-702); test/guards/contract_models_test.dart; test directory listings; grep results for repository class references and Dio/adapter users under test/; docs/DECISIONS.md:293-475 (D-008), docs/D008_LEADERBOARD_AUDIT.md, docs/WAVE_STATUS.md:109,128, docs/seif_fight.md (S11, S24 rows), .ai/audits/current/release_r; level_up_master_completion_roadmap.json (read-only skim of decisions DR-01..DR-29 and counts); Commands: Grep/Bash greps for Dio verbs, path literals, provider consumers, redemption/redeem/subscription-codes, firebase/signalr/web_socket/image_picker, x-co

**features_learning** (17 items): F:/level/level_up/level_up_app/lib/core/router/app_router.dart (read in full); lib/features/home/{screens/home_screen.dart, widgets/home_header.dart, level_card.dart, top_student_section.dart, coming_soon_section.dart, home_banner.dart} (r; lib/features/catalog/{repository/catalog_repository.dart, notifier/subjects_notifier.dart, subject_tree_notifier.dart, models/subject.dart, screens/*.dart, widg; lib/features/quiz/{repository/quiz_repository.dart, bloc/quiz_bloc.dart, quiz_state.dart, notifier/quiz_setup_notifier.dart, models/quiz.dart, quiz_mode.dart, q; lib/features/flashcards/{repository, notifier/lecture_flashcards_notifier.dart, screens/flashcard_setup_screen.dart, flashcard_study_screen.dart, widgets/flashc; lib/features/mistakes/{repository, screens/mistakes_overview_screen.dart, mistakes_subject_screen.dart, mistakes_tree_screens.dart, models/mistakes_subject.dart; lib/features/leaderboard/{repository, models/leaderboard_models.dart, board_failure.dart, screens/leaderboard_screen.dart} (read); lib/features/profile/screens/profile_screen.dart, models/student_profile.dart; lib/features/shell/{main_shell.dart, screens/tab_placeholder.dart}; lib/core/sess; lib/l10n/app_en.arb and app_ar.arb (22 state/limit keys spot-checked for parity); test/features/{home,catalog,flashcards,mistakes,quiz,leaderboard,shell}/*_test.dart (listed; 44 files); test/guards/{contract_models_test.dart, project_rules_te; docs/{WAVE_STATUS.md, seif_fight.md (S2-S44 table), DESIGN_ISSUES.md (headings), DECISIONS.md:466-471, RISKS.md (R-8, R-10), day4_home_brief.md, D008_LEADERBOAR; /f/level/CLAUDE.md and level_up_app/CLAUDE.md; .claude/skills/seif-api-contract/SKILL.md:24-30; F:/level/level_up/level_up_app/.ai/audits/current/{wave_state.md, endpoint_ui_mapping.md, screen_api_gaps.md, api_ui_endpoint_inventory.md, notification_inbox_3; level_up_master_completion_roadmap.json (keys and keyword search of master_issues for prior learning findings; used as leads only); SCRATCH: ops_table.txt; openapi_0df5cf4.yaml; openapi_65245be_worktree.yaml; openapi_2e5bb69.yaml (read listModules, getMyQuizSummary, createQuiz, listQuizHisto; Scripts I wrote in SCRATCH: schema_diff.py, schema_show.py, op_shape_diff.py (component and operation diffs across the three pins), run_area_tests.sh; Commands: flutter test --no-pub --reporter compact test/features/<area> for the 7 areas (home 64, catalog 182, flashcards 223, mistakes 78, quiz 297, leaderboar

**features_account** (19 items): F:\level\level_up\level_up_app\lib\core\router\app_router.dart (routes, authRedirect, _Placeholder); lib\features\auth\{screens\login_screen.dart, screens\otp_screen.dart, notifier\otp_notifier.dart, notifier\login_notifier.dart, notifier\auth_controller.dart, ; lib\core\network\{dio_client.dart, exceptions.dart, interceptors\auth_interceptor.dart, interceptors\error_interceptor.dart}; lib\core\{session\session_scope.dart, storage\secure_storage.dart, config\app_config.dart}; lib\features\profile\{screens\profile_screen.dart, screens\edit_profile_screen.dart, widgets\avatar_sheets.dart, models\student_profile.dart, models\entitlement; lib\features\settings\screens\settings_screen.dart; lib\features\account_shells\{screens\legal_document_screen.dart, customer_support_screen.dart, refer_a_frien; lib\features\registration\{screens\signup_identity_screen.dart, notifier\registration_submit_notifier.dart, registration_error_copy.dart, models\school_registra; lib\l10n\app_en.arb, app_ar.arb (keys: sessionEndedSuperseded, sessionExpired, errorOtpThrottled, accountPendingDeletion, legalNotPublished, uploadPhotoUnavaila; pubspec.yaml; android\app\src\main\AndroidManifest.xml; ios\Runner\Info.plist; l10n.yaml; lib\features\subscription\ and lib\features\track\ directory listings (only .gitkeep); test\: features\auth\{login_logout_message_test,verify_fork_test,otp_screen_test}.dart, core\network\{account_pending_deletion_test,auth_interceptor_test,error_; docs\{DESIGN_ISSUES.md (#7,#8,#9,#45,#48,#51,#62,#74,#106), seif_fight.md (S5,S24,S28-S33,S36,S38), DECISIONS.md (D-007,D-015), RISKS.md (R-10), KNOWN_BUGS.md, ; contract\{contract-changelog.md, openapi.yaml (C38), SOURCE.md}; git show HEAD:contract/openapi.yaml (C28); F:\level\CLAUDE.md:11; SCRATCH: openapi_0df5cf4.yaml, openapi_65245be_worktree.yaml, openapi_2e5bb69.yaml, ops_table.txt, upstream-contract\{contract-changelog.md, error-codes.md, ope; Python read-only scripts: schema diff of StudentProfile, EntitlementState, AuthenticatedResult, TokenPair, DeviceInfo, ProblemDetails, Registration bodies C28 v; Greps: purchase vocabulary over lib and ARB; url_launcher; account_banned; pendingDeletion; terms/legal operation names; API path census of lib; Accept header; ; Untracked level_up_master_completion_roadmap.json (decisions list only, read-only, DOC); Docs read: .ai\audits\current\{wave_state.md, figma_ui_comparison.md, endpoint_ui_mapping.md, api_ui_endpoint_inventory.md, screen_api_gaps.md, release_readines

**features_social** (46 items): F:\level\level_up\level_up_app\lib\core\router\app_router.dart (lines 1-120, 300-500); F:\level\level_up\level_up_app\lib\features\account_shells\screens\refer_a_friend_screen.dart; F:\level\level_up\level_up_app\lib\features\account_shells\screens\friends_screen.dart; F:\level\level_up\level_up_app\lib\features\account_shells\screens\customer_support_screen.dart; F:\level\level_up\level_up_app\lib\features\account_shells\screens\legal_document_screen.dart; F:\level\level_up\level_up_app\lib\features\account_shells\widgets\shell_body.dart; F:\level\level_up\level_up_app\lib\features\shell\screens\tab_placeholder.dart; F:\level\level_up\level_up_app\lib\features\shell\main_shell.dart; F:\level\level_up\level_up_app\lib\features\home\widgets\home_header.dart; F:\level\level_up\level_up_app\lib\features\home\screens\home_screen.dart (grep); F:\level\level_up\level_up_app\lib\features\settings\screens\settings_screen.dart (lines 330-440); F:\level\level_up\level_up_app\lib\features\profile\screens\profile_screen.dart (lines 225-315); F:\level\level_up\level_up_app\lib\features\registration\screens\signup_identity_screen.dart (grep); F:\level\level_up\level_up_app\lib\features\registration\notifier\registration_controller.dart (grep); F:\level\level_up\level_up_app\lib\features\registration\models\registration_draft.dart, school_registration.dart, university_registration.dart (grep); F:\level\level_up\level_up_app\lib\features\leaderboard\models\leaderboard_models.dart (grep studentId); F:\level\level_up\level_up_app\lib\features\quiz\screens\quiz_review_screen.dart (lines 20-40), quiz_screen.dart, quiz_result_screen.dart, quiz_setup_screen.dar; F:\level\level_up\level_up_app\lib\core\widgets\state_widget.dart; F:\level\level_up\level_up_app\lib\core\widgets\offline_banner.dart; F:\level\level_up\level_up_app\lib\core\models\screen_state.dart; F:\level\level_up\level_up_app\lib\core\providers\core_providers.dart; F:\level\level_up\level_up_app\lib\core\network\exceptions.dart; F:\level\level_up\level_up_app\lib\core\network\interceptors\error_interceptor.dart; F:\level\level_up\level_up_app\lib\core\network\dio_client.dart; F:\level\level_up\level_up_app\lib\core\session\session_scope.dart (lines 40-110); F:\level\level_up\level_up_app\lib\core\storage\secure_storage.dart (lines 60-100); F:\level\level_up\level_up_app\lib\features\profile\profile_error_copy.dart; F:\level\level_up\level_up_app\lib\l10n\app_en.arb, app_ar.arb (grep); F:\level\level_up\level_up_app\lib\dev\mock_backend.dart (header, grep); F:\level\level_up\level_up_app\pubspec.yaml, pubspec.lock (grep); F:\level\level_up\level_up_app\android\app\src\main\AndroidManifest.xml, debug, profile manifests; android\app\build.gradle.kts, build.gradle.kts, settings.grad; F:\level\level_up\level_up_app\ios\Runner\Info.plist (grep), AppDelegate.swift, directory listings; F:\level\level_up\level_up_app\test\guards\project_rules_test.dart, rules.dart, contract_models_test.dart; F:\level\level_up\level_up_app\test\core\session\session_scope_discipline_test.dart; F:\level\level_up\level_up_app\test\features\settings\shell_screens_test.dart (test names); F:\level\level_up\level_up_app\test\features\shell\main_shell_test.dart (grep); F:\level\level_up\level_up_app\tool\smoke\real_api_smoke_test.dart (grep); F:\level\level_up\level_up_app\contract\openapi.yaml (3.38 working tree, greps and lines 3025-3035); F:\level\level_up\level_up_app\contract\SOURCE.md (git show HEAD); F:\level\level_up\level_up_app\docs\seif_fight.md (S5, S33, S36), DESIGN_ISSUES.md, ENVIRONMENTS.md (sections 340-357), DECISIONS.md, WAVE_STATUS.md (lines 52-7; F:\level\level_up\level_up_app\.ai\audits\current\notification_inbox_3_28_investigation.md (lines 1-330), endpoint_ui_mapping.md, store_readiness_matrix.md, rel; F:\level\level_up\level_up_app\level_up_master_completion_roadmap.json (decisions list only; cross-check, not trusted); SCRATCH\openapi_0df5cf4.yaml, openapi_2e5bb69.yaml, ops_table.txt, upstream-contract\realtime.md, contract-changelog.md, error-codes.md, openapi.yaml; C:\Users\musta\AppData\Local\Pub\Cache\hosted\pub.dev\dio-5.10.0\lib\src\headers.dart (grep accept), connectivity_plus-7.3.0 (connectivity_plus.dart, Connectivi; Commands: git rev-parse/git status --short (before and after, unchanged); git show HEAD:contract/openapi.yaml and HEAD:contract/SOURCE.md (greps); find/grep ove; Figma MCP read-only on file P6044i0giD9TmdQ7C2AmLq: get_metadata for 162:2797, 166:3156, 166:4260, 166:4319, 171:5031, 176:2425, 178:2800, 178:3222, 178:3378, 1

**design** (11 items): docs/DESIGN_ISSUES.md (5045 lines; headings parsed to SCRATCH di_headings.txt; read :1-180, :245-330 headings, :1008-1045 skim, :1581-1625, :2019-2066, :2835-28; docs/seif_fight.md (S5 :719, S29 :1230, S30 :1246, S31 :1265, S32 :1286, S33 :1303, S36 :1375); docs/DECISIONS.md (D-007 :252-290 and headings index); docs/RISKS.md (R-10 :142-150), docs/ENVIRONMENTS.md (:367, :400-416), docs/WAVE_STATUS.md (:1-140), docs/ASSET_MANIFEST.md; docs/day8_account_brief.md (:190-260, :378-396), docs/day4_home_brief.md (:60-80), docs/day1b_forced_logout_brief.md, docs/day7_quiz_brief.md (Subscription refs; /.ai/audits/current/: figma_ui_comparison.md, screen_api_gaps.md, endpoint_ui_mapping.md, api_ui_endpoint_inventory.md, implementation_waves.md, wave_state.md (; F:\level: CLAUDE.md listing, folder listing, level_up\level_up\00_Project\Scope_v2_Features.md, level_up\MILESTONE-1-AUDIT.md (Subscription grep); repo .claude/; Contract: SCRATCH upstream-contract at 2e5bb69 (openapi.yaml lines 142-149, 390, 816-827, 978-1058, 1087-1123, 1159-1212, 1430-1475, 1727-1760, 1877, 2445-2475,; Code (read-only greps/reads): lib/features/account_shells/screens/refer_a_friend_screen.dart, lib/features/registration/screens/signup_identity_screen.dart:182-; Figma MCP (file P6044i0giD9TmdQ7C2AmLq, 2026-10-08): get_metadata with no node (pages: only 0:1), get_metadata on 176:2425, 166:4416, 309:9671, 216:3784, 166:31; Commands: git status --short (unchanged), git ls-files, grep/rg over docs, lib, contract; Python parse of DESIGN_ISSUES headings and ops_table awk counts by tag

**env_push_impl** (53 items): F:\level\level_up\level_up_app\android\app\build.gradle.kts; F:\level\level_up\level_up_app\android\app\src\main\AndroidManifest.xml; F:\level\level_up\level_up_app\android\app\src\debug\AndroidManifest.xml; F:\level\level_up\level_up_app\android\app\src\profile\AndroidManifest.xml; F:\level\level_up\level_up_app\android\app\src\main\kotlin\com\levelup\level_up_app\MainActivity.kt; F:\level\level_up\level_up_app\android\settings.gradle.kts; F:\level\level_up\level_up_app\android\build.gradle.kts; F:\level\level_up\level_up_app\android\gradle.properties; F:\level\level_up\level_up_app\android\gradle\wrapper\gradle-wrapper.properties; F:\level\level_up\level_up_app\android\.gitignore; F:\level\level_up\level_up_app\android\key.properties.example (and ls android/key.properties -> absent); F:\level\level_up\level_up_app\android\app\src\main\res\xml\data_extraction_rules.xml; F:\level\level_up\level_up_app\ios\Runner.xcodeproj\project.pbxproj (grep of bundle id, deployment target, knownRegions, configuration lists); F:\level\level_up\level_up_app\ios\Runner.xcodeproj\xcshareddata\xcschemes\Runner.xcscheme; F:\level\level_up\level_up_app\ios\Runner\Info.plist; F:\level\level_up\level_up_app\ios\Runner\AppDelegate.swift; F:\level\level_up\level_up_app\ios\Flutter\{Debug,Release}.xcconfig, AppFrameworkInfo.plist, Generated.xcconfig; F:\level\level_up\level_up_app\ios\.gitignore; ls ios/Podfile* (none); find ios for PrivacyInfo*/*.entitlements (none); F:\level\level_up\level_up_app\pubspec.yaml and pubspec.lock (grep firebase|messaging|notification|permission_handler|fcm|apns|push -> none); F:\level\level_up\level_up_app\lib\core\config\app_config.dart; F:\level\level_up\level_up_app\lib\bootstrap.dart, main.dart, main_dev.dart, main_staging.dart, main_prod.dart, main_mock.dart; F:\level\level_up\level_up_app\lib\core\network\dio_client.dart; F:\level\level_up\level_up_app\lib\core\router\app_router.dart; F:\level\level_up\level_up_app\lib\features\auth\notifier\auth_controller.dart; F:\level\level_up\level_up_app\lib\features\shell\screens\tab_placeholder.dart; F:\level\level_up\level_up_app\lib\features\home\widgets\home_header.dart; F:\level\level_up\level_up_app\lib\features\settings\screens\settings_screen.dart; F:\level\level_up\level_up_app\lib\features\account_shells\screens\{customer_support,friends}_screen.dart; F:\level\level_up\level_up_app\lib\l10n\app_en.arb and app_ar.arb (grep push_, enrolment_opened, notification); F:\level\level_up\level_up_app\test\guards\android_identity_test.dart (read and run); F:\level\level_up\level_up_app\test\guards\workflow_test.dart (scan roots :168); F:\level\level_up\level_up_app\tool\verify_release_manifest.ps1, tool\verify_guards.ps1 (id references); F:\level\level_up\level_up_app\.github\workflows\ci.yml (:376-408, no iOS lane); F:\level\level_up\level_up_app\.githooks\pre-push; F:\level\level_up\level_up_app\docs\DECISIONS.md (D-021 :1019-1073; grep notification/inbox); F:\level\level_up\level_up_app\docs\ENVIRONMENTS.md (read in full); F:\level\level_up\level_up_app\docs\RISKS.md (read in full); F:\level\level_up\level_up_app\docs\RELEASE_SIGNING.md, STORE_READINESS_RUBRIC.md, STORE_READINESS.md, WAVE_STATUS.md, seif_fight.md (grep); F:\level\level_up\level_up_app\.ai\audits\current\env_chapter_state.md, env_wave0_report.md, env_wave1_report.md (read in full); F:\level\level_up\level_up_app\.ai\audits\current\app_identity_environment_audit_2026-10-04.md (sections 0, 2.3-2.10, 3); F:\level\level_up\level_up_app\.ai\audits\current\notification_inbox_3_28_investigation.md, release_readiness_reconciliation_2026-10-06.md, store_readiness_audi; F:\level\level_up\level_up_app\flutter_frontend_workflow.md (lines 62-64, 702-704); F:\level\level_up\level_up_app\contract\openapi.yaml (registerFcmToken :945-959, servers :107-109), contract\realtime.md, contract\SOURCE.md, contract\contract-; git show HEAD:contract/realtime.md and git show HEAD:contract/openapi.yaml (committed pin 0df5cf4: registerFcmToken :900); SCRATCH\upstream-contract (2e5bb69): realtime.md:76-108, contract-changelog.md :7-59, :211, :301, openapi.yaml; SCRATCH\openapi_2e5bb69.yaml (:107-109, :451-461, :1060-1082, :1144-1216); SCRATCH\roadmap_decisions.txt, roadmap_plan.txt (grep push/identity); SCRATCH\env_identity_guard.log (output of flutter test --no-pub test/guards/android_identity_test.dart: 9 passed); C:\Users\musta\AppData\Local\Pub\Cache\hosted\pub.dev\firebase_core-4.3.0\ios\{firebase_core.podspec,firebase_sdk_version.rb}; build\app\outputs\flutter-apk\{app-prod-release,app-staging-release,app-staging-debug,app-release}.apk (aapt2.exe 36.1.0 dump badging, read-only); build\app\intermediates\merged_manifest\{prodRelease,stagingRelease}\...\AndroidManifest.xml; build\app\outputs\bundle\release\app-release.aab (timestamp only); commands: git log/branch/show (applicationId per branch), git status --short (unchanged), git config core.hooksPath (unset), git stash list (0), flutter --versi

**ci_validation** (30 items): F:\level\level_up\level_up_app\.github\workflows\ci.yml (read in full); F:\level\level_up\level_up_app\.githooks\pre-commit; F:\level\level_up\level_up_app\.githooks\pre-push; F:\level\level_up\level_up_app\tool\validate.sh; F:\level\level_up\level_up_app\tool\validate.ps1; F:\level\level_up\level_up_app\tool\verify_guards.ps1; F:\level\level_up\level_up_app\tool\verify_release_manifest.ps1; F:\level\level_up\level_up_app\tool\verify_session_regression.ps1; F:\level\level_up\level_up_app\tool\smoke\real_api_smoke_test.dart (headings, imports, SMOKE_* switches); F:\level\level_up\level_up_app\test\guards\rules.dart (contractRequiredFields :363-430); F:\level\level_up\level_up_app\test\guards\rules_test.dart (test names); F:\level\level_up\level_up_app\test\guards\project_rules_test.dart; F:\level\level_up\level_up_app\test\guards\workflow_test.dart; F:\level\level_up\level_up_app\test\guards\android_identity_test.dart; F:\level\level_up\level_up_app\test\guards\contract_models_test.dart; F:\level\level_up\level_up_app\test\guards\validate_reporting_test.dart; F:\level\level_up\level_up_app\test\core\theme\palette_discipline_test.dart, typography_discipline_test.dart; test\core\session\session_scope_discipline_test.da; F:\level\level_up\level_up_app\dart_test.yaml; analysis_options.yaml; pubspec.yaml (dev_dependencies); .gitignore; .gitattributes; F:\level\level_up\level_up_app\docs\ENFORCEMENT.md; docs\AUDIT_PROTOCOL.md; docs\RISKS.md (R-3); docs\ENVIRONMENTS.md (:267 appbundle, :450); .ai\audits\current; F:\level\level_up\level_up_app\android\app\build.gradle.kts (signing lines); lib\l10n\app_en.arb:514-520; git config --show-origin --get-all core.hooksPath; git config --get-regexp hook; ls .git/hooks; git ls-files -s .githooks tool; git ls-files .github; git ls-tre; git status --porcelain=v1 | sha1sum; git diff | sha1sum (before and after); sha1sum pubspec.lock; git ls-files -z "*.dart" | xargs -0 -r -s 7000 dart format --output=none --set-exit-if-changed (all files and CI-equivalent set); flutter analyze --no-pub; flutter test --no-pub (full); flutter test --no-pub --reporter expanded test/guards; git clone --no-hardlinks to SCRATCH/clone345; git show 2e5bb69:<file> overlays; git hash-object; flutter pub get --offline; flutter test --no-pub test/guards an; Replay of validate.sh lines 129-141 (xargs -0 -r dart format ... < dartfiles.z) -> exit 123; aapt2 36.1.0 dump badging/permissions on build/app/outputs/flutter-apk/app-prod-release.apk and app-staging-release.apk; ls build/app/outputs (APK/AAB timestamp; SCRATCH scripts and logs: run_chain.sh, run_clone_full.sh, ci_guard_coverage.py, ci_case_scan.py, format_all.log/.exit, format_ci.log/.exit, analyze.log/.exit, ; WebFetch https://github.com/zlatanibrahimovichsweden-61/level-up-app/actions (HTTP 404); gh --version absent; grep scans: secret-scanning tools, dependabot/renovate/CODEOWNERS, integration_test, iOS patterns in test/, logging calls in lib/, purchase wording in test/ and

**store** (37 items): docs/STORE_READINESS.md (read fully); docs/STORE_READINESS_RUBRIC.md (read fully); docs/RELEASE_SIGNING.md (read fully); docs/DECISIONS.md D-021 (lines 1019-1074); docs/ENVIRONMENTS.md (sections 7, 8, 9, 10; lines 336-440); docs/RISKS.md (headings; R-10 at 142, R-11 at 154); docs/seif_fight.md (grep for retention, reviewer, production host; S-list tail); .ai/audits/current/release_readiness_reconciliation_2026-10-06.md (read fully); .ai/audits/current/store_readiness_recheck.md (read fully); .ai/audits/current/store_readiness_matrix.md (read fully); .ai/audits/current/store_submission_checklist.md (read fully); .ai/audits/current/store_readiness_recheck_ledger.md (headings, B2/B3/B4 rows); .ai/audits/current/store_readiness_parts/14_declarations_permissions.md (headings); level_up_master_completion_roadmap.json (master_issues P0/P1, 29 rows; counts; verdict) via scratchpad/sr_roadmap.py and sr_roadmap_out.txt; lib/core/config/app_config.dart; lib/main_prod.dart; lib/main.dart; lib/bootstrap.dart; lib/features/auth/screens/login_screen.dart (lines 36-60,110-130,400-425); lib/features/auth/auth_error_copy.dart; lib/features/account_shells/screens/{legal_document,customer_support,refer_a_friend,friends}_screen.dart; lib/core/router/app_router.dart (lines 36-90, 160, 305-320, 405-435); lib/features/profile/screens/profile_screen.dart (lines 205-330); lib/features/settings/screens/settings_screen.dart (lines 335-420); lib/features/shell/screens/tab_placeholder.dart; lib/features/quiz/screens/screen_protection.dart; lib/features/auth/repository/device_info_provider.dart; lib/features/leaderboard/widgets/{leaderboard_row,podium}.dart; lib/features/registration/models/registration_draft.dart; lib/l10n/app_en.arb and app_ar.arb (Python value scan; keys 32, 516, 630-644); pubspec.yaml; pubspec.lock (device_info_plus 13.2.0; absence of firebase, markdown, image_picker); android/app/build.gradle.kts; android/app/src/main/AndroidManifest.xml; android/.gitignore; android/key.properties.example (redacted); android/app/src/main/res ; ios/Runner.xcodeproj/project.pbxproj (grep lines 188, 349, 353, 371, 387, 404, 419, 475, 526, 550, 572); ios/Runner/Info.plist; ios/Flutter/AppFrameworkInfo.pli; contract/SOURCE.md; grep of working-tree contract/openapi.yaml and error-codes.md for getLegalDocument|account_banned (0 hits); upstream contract clone scratchpad/upstream-contract at 2e5bb69: openapi.yaml (lines 96-98, 107-109, 811-860, 987-1031, 1060-1115, 1263-1333, 2444-2450, 2853, 3; scratchpad/ops_table.txt (stability of all operations at the three pins); pub cache: screen_protector-1.5.3/ios/Classes/SwiftScreenProtectorPlugin.swift and podspec; device_info_plus-13.2.0 FPPDeviceInfoPlusPlugin.m and PrivacyInfo.xc; git rev-parse / log / status / diff --stat f10b112 HEAD -- lib android ios pubspec.yaml pubspec.lock test; git diff --name-only f10b112 HEAD; git diff --stat --; aapt2 dump badging and dump permissions on build/app/outputs/flutter-apk/app-prod-release.apk; apksigner verify (Android Studio jbr as JAVA_HOME); python zipfil; scratchpad/sr_reach.py import-graph reachability from lib/main_prod.dart (225 reachable; dev/mock unreachable); curl (public GET, no auth) to https://level-up-backend-staging.up.railway.app/api/v1/reference/legal-documents/{privacy,terms}?language={en,ar} on 2026-10-08 an; find/ls checks: android/ios for google-services, GoogleService-Info, PrivacyInfo, Podfile, entitlements, xcconfig; repo for fastlane, metadata, ExportOptions, l; grep checks in lib/: purchase vocabulary, launchUrl/url_launcher, .example/localhost/http://, TODO taxonomy, account_banned/account_pending_deletion, report/blo; grep .github/workflows/ci.yml (runs-on, flavor/appbundle lines); test/guards/android_identity_test.dart (Firebase slot guard lines 203-236); Not run by design: tool/validate.ps1/.sh, flutter build/test, any git write command; no device, Figma or console access used

**roadmap_registers** (30 items): F:\level\level_up\level_up_app\level_up_master_completion_roadmap.json (parsed with python: repo, counts, verdict, decisions DR-01..DR-29, requirements, critica; C:\Users\musta\AppData\Local\Temp\claude\F--level-level-up-level-up-app\513a53c3-37d2-4201-8dd7-79f979aa4042\scratchpad\roadmap_decisions.txt and roadmap_plan.t; F:\level\level_up\level_up_app\flutter_frontend_workflow.md (:1-60, outline; git log; git show 2dfd969); F:\level\level_up\level_up_app\docs\WAVE_STATUS.md (read fully); F:\level\level_up\level_up_app\docs\RISKS.md (read fully); F:\level\level_up\level_up_app\docs\DECISIONS.md (index, :1-16, :965-1073, keyword greps); F:\level\level_up\level_up_app\docs\seif_fight.md (:589-658 summary, S-section update greps, S4/S9/S38 bodies); F:\level\level_up\level_up_app\docs\KNOWN_BUGS.md (index, status lines of BUG-002/015/017/025, BUG-020 remainder :676); F:\level\level_up\level_up_app\.ai\audits\current\known-issues.md (read fully); F:\level\level_up\level_up_app\.ai\audits\current\wave_state.md (:1-250, :1222-1241, :1800-1837, heading index); F:\level\level_up\level_up_app\.ai\audits\current\env_chapter_state.md (read fully); F:\level\level_up\level_up_app\.ai\audits\current\release_readiness_reconciliation_2026-10-06.md (index, §4 :128-150, §6-7 :179-214, §15 :365-408); F:\level\level_up\level_up_app\.ai\audits\current\implementation_waves.md (:1-40, acceptance lines); F:\level\level_up\level_up_app\.ai\audits\current\device_walk_results.md (:1-40); F:\level\level_up\level_up_app\.ai\audits\current\notification_inbox_3_28_investigation.md (:339-358); F:\level\level_up\level_up_app\.ai\audits\current\store_readiness_state.md (:1-25); F:\level\level_up\level_up_app\docs\PROJECT_GUIDE.md (:1-120); F:\level\level_up\level_up_app\docs\AGENT_WORKFLOW.md (read fully); F:\level\level_up\level_up_app\docs\ENVIRONMENTS.md (grep redeem/website/main_mock: :52,:77,:248,:282,:315,:367,:405-406); F:\level\level_up\level_up_app\lib\core\router\app_router.dart (grep: :314-315 MessagePlaceholderScreen, :415-432); F:\level\level_up\level_up_app\lib\features\profile\screens\profile_screen.dart (:295-340); F:\level\level_up\level_up_app\lib\features\auth\screens\login_screen.dart (grep levelup.example :46-48); F:\level\level_up\level_up_app\lib\dev\mock_backend.dart (grep -c per route); F:\level\level_up\level_up_app\pubspec.yaml (:30-65; grep markdown/signalr/firebase); F:\level\level_up\level_up_app\android\app\build.gradle.kts (grep :113-131 flavor/entrypoint rule); SCRATCH\ops_table.txt (orchestrator: every op x stability at 0df5cf4/65245be/2e5bb69); SCRATCH\openapi_2e5bb69.yaml (getLegalDocument :811-830; registerFcmToken :1064-1066; getTermsAcceptance/acceptTerms :1087-1130; listMyNotifications 200 descrip; SCRATCH\openapi_0df5cf4.yaml (deletion copy :1091; comparison greps); SCRATCH\upstream-contract (git log -15; contract-changelog.md :1-130 and greps; realtime.md full; error-codes.md :51,:65-72; git diff 0df5cf4 2e5bb69 --stat and; git log --format='%h %ad %s' -22; git log per file for wave_state.md, WAVE_STATUS.md, seif_fight.md, known-issues.md, flutter_frontend_workflow.md, store_readin


Working files (outside the repo): the per-dimension investigation, verification and correction JSON in the session scratchpad `results/`; upstream clone `upstream-contract/`.


## 19. What we know
### 19. What we know

**Repository and git**
- **Branch and working tree** (SOURCE, `git status -sb`, `git log`, 2026-10-09):
  - `merged` @ `8e641e9` is 1 commit ahead of `origin/merged` `c87b90a`. The unpushed commit is docs-only (2 files). `merged` has 136 commits.
  - Nothing is staged. The only tracked changes are 5 `contract/*` files. Three files are untracked: two roadmap files and `PRE_EXECUTION_DISCOVERY.md`.
  - No merge, rebase or other git operation is in progress; there is no `index.lock`, and stash and tags are empty.
- **`main` and `dev`** (SOURCE, `git rev-list --left-right --count`, `git cherry -v merged dev`):
  - `main` `e71e9a1` is a strict ancestor of `merged`, 32 commits behind, so `--ff-only` promotion is possible.
  - `dev`'s 6 local commits are all already in `merged` and `main`.
- **Waves 20–22** (SOURCE) are committed and pushed: `fa88b3a`, `af0eadb`, `a988a1f`. `wave_state.md:90`, `:108`, `:1829` and `:1833` still say they are uncommitted.
- **Contract working tree** (CONTRACT, `git hash-object` vs upstream):
  - The working-tree contract files are blob-identical to upstream `65245be`, and the HEAD blobs to `0df5cf4`. All are LF.
  - `contract/SOURCE.md:17` ("CRLF") is false.
  - The SOURCE.md 3.29–3.38 delta prose exists nowhere upstream.
- **Work outside `merged`** (SOURCE):
  - The `xargs -s 7000` batching patch lives only in the gitignored worktrees `angry-antonelli-cf9094` and `jovial-bhaskara-018e57`, idle since 2026-09-27. It applies cleanly to `merged`.
  - `tell_claude.md` exists only on the local-only `backup/2026-08-22-dirty-tree` (`e4006e7`).
- **Secret scan** (SOURCE): the tracked files and full history were scanned for high-signal secret patterns, with 0 hits. No keystore, `google-services.json`, `GoogleService-Info.plist` or `.env` is tracked.

**Contract**
- **Census at each pin** (CONTRACT, PyYAML; ERR B1/B8):

  | Pin | Version | Operations | Stable | Draft | Web-only | App-buildable |
  |---|---|---|---|---|---|---|
  | `0df5cf4` | 3.28.0-m1 | 54 | 38 | 16 | 3 | 35 |
  | `65245be` | 3.38.0-m1 | 77 | 53 | 24 | 4 | 49 |
  | `2e5bb69` | 3.45.0-m1 | 86 | 81 | 5 | 4 | 77 |
  | `eddb6ac` | 3.46.0-m1 | 86 | 86 | 0 | 4 | 82 |

  At `eddb6ac` there are 63 schemas and 62 error codes, and `servers:` lists staging only.
- **Upstream HEAD** (CONTRACT, `git ls-remote` 2026-10-09; `git diff 2e5bb69 eddb6ac`):
  - Upstream HEAD is `eddb6ac`, mirrored 2026-10-08 14:56 UTC from backend `a158daa`.
  - 3.46 touched only `info.version` and 5 `x-stability` lines.
  - `realtime.md` and `error-codes.md` are unchanged since 3.45.
- **Staging** (LIVE-PROBE, unauthenticated, 2026-10-08, below DEVICE):
  - It runs `a158daa`, built 2026-10-08 15:16:14Z: the same backend that 3.46 describes.
  - These routes answer 401, so they are deployed: the chat hub, invite, friend-streaks, conversations, support tickets, notifications and all 5 photo routes. Control paths answer 404.
  - Legal documents answer 200 with `r4-2026-10-07` in Arabic and English.
- **Versions are not content identities** (CONTRACT, `git log`):
  - 3.29–3.36 arrived in one mirror commit (`cacb21b`).
  - "3.38.0-m1" covers `0fd8fc8`, `b33e658` and `495dc45`.
  - 3.44 was never mirrored on its own.
  - Upstream moved 8 minor versions (3.39 → 3.46) in about 26–28 hours.
- **Contract self-contradictions still present at 3.46** (CONTRACT):
  - The `support` tag still says "Text only for launch" (`openapi@3.46:133-137`).
  - `UniversityRegistration.inviteCode` still says "draft" (`:4182`), against `:4147` and `:390`.
  - `acceptTerms` says acceptance is "not enforced" (`:1122`), yet photo uploads answer 403 `terms_acceptance_required`.
  - `getTermsAcceptance` says "no Terms text" is served (`:1095`), yet `getLegalDocument` serves it.
  - `sendFriendRequest` says "no push" (`:3162`).
  - `forwardQuestion` spells the push kind `ChatMessageReceived`.
  - The 3.37 entry says "18" flips where 15 exist.
  - `error-codes.md` rows still say "(draft)".
  - The 3.46 entry has no "Consumers affected" line.
- **Adjacent records** (CONTRACT/DOC):
  - adr-049 §3/§4 (purchase silence) is unrevised through 3.46 (`changelog@3.46:576`, `:338`, `:585-589`).
  - R-10 is OPEN (`RISKS.md:142-150`).

**App: API use and code**
- **API consumption** (SOURCE + BUILD; `census_paths.py`, `crit/census346.py`):
  - The app calls exactly 26 operations (27 Dio call expressions, one being the post-refresh replay). All are stable at every pin, and none is draft, web-only or invented.
  - Of the 82 app-buildable operations: 25 are implemented, 1 is data-layer only (`getMyEntitlements`) and 56 are not integrated.
- **Consumed operations that changed by 3.46** (CONTRACT, `drift_check.py`):
  - Only 2 of 26 changed structurally, both additively: `verifyOtp` (+403 `account_banned`, 3.42) and `completeRegistration` (optional `inviteCode`/`inviteCodeApplied`).
  - The 13 `required` lists that the guard binds are identical at every pin.
- **Error mapping** (SOURCE):
  - `account_banned` appears nowhere in `lib/`, so it maps to `genericError` (`auth_error_copy.dart:10-25`) after the OTP is consumed.
  - `account_pending_deletion` copy appears at 5 code sites, and no cancel screen exists.
- **Conformance gaps** (SOURCE):
  - No `Accept` header is sent (`dio_client.dart:15-20`).
  - The comment at `error_interceptor.dart:9-10` is stale.
  - `AuthInterceptor` attaches the bearer token to every request with no host check (`auth_interceptor.dart:52-61`), so a presigned storage PUT needs a separate plain client.
- **Shells and inert surfaces** (SOURCE):
  - `/refer`, `/support` and `/friends` are shells. `/friends` has no entry point (`app_router.dart:415-423`).
  - `/message` is a placeholder (`:313-316`).
  - The Home bell is inert, with `hasUnreadNotifications` hard-set to false (`home_header.dart:36`).
  - The Favorites and "Your progress" rows are disabled.
  - The "Go to Uni" dialog has Confirm disabled and also shows for University students.
  - The referral code is collected at sign-up and dropped (`signup_identity_screen.dart:86-94`).
- **Subscription surface** (SOURCE):
  - The purchase-silence sweep is clean: no price, paywall, checkout, redeem or purchase surface.
  - `features/subscription/` holds only `.gitkeep`.
  - The one exception is the contract-verbatim "Subscribe to get…" line (`app_en.arb:516`), kept by D-015.
- **Dependencies** (SOURCE, `pubspec.lock`):
  - Present only transitively: `uuid` 4.6.0, `crypto` 3.0.7, `http` 1.6.0, `mime` 2.0.0, `web_socket_channel` 3.0.3.
  - Absent: a SignalR client, image picker or compressor, Markdown renderer, share, Firebase, local notifications and permission handler.
- **Latent crash** (SOURCE + CONTRACT): a quiz with `questions: []` would throw a RangeError (`quiz_state.dart:53`). The contract returns that as a normal `retakeWrong` outcome (`openapi@3.46:1810-1813`). It is unreachable today.

**Build, CI and gates**
- **BUILD results** (2026-10-08, fingerprint unchanged before and after):
  - Working tree (3.38 files): format 0 changed (369 files), analyze 0, 2067/0/0, guards 122/122 (contract_models 14/14).
  - 3.45 clone: 2067/0/0, guards 122/122, no codegen or l10n drift.
  - Per area: 908/0 across home, catalog, flashcards, mistakes, quiz, leaderboard and shell.
- **Contract guard coverage** (BUILD, mutation probes and script):
  - At 3.46 it binds only 7 of the 34 response schemas that carry a `required` list (27 unbound).
  - It reads only `openapi.yaml`.
  - It fails 13 of 14 tests on CRLF copies.
- **CI history** (CI, `gh` 2.102.0 authenticated as the owner):
  - 15 runs: 12 on `merged` (11 green, 1 format failure at `f10b112`), 2 on `main` and 1 on `dev`, all green.
  - The latest run, at `c87b90a`, is green. The goldens job was green in all 15 runs but is still advisory.
  - No branch is protected, and the rulesets API answers 403.
- **Release compile gate** (CI + SOURCE):
  - The flavored gate (`ci.yml:380`) runs only on pushes to `main` (`:320`) and has never run in its flavored form (the two `main` runs predate `2dfd969`).
  - Codegen-drift also accepts `workflow_dispatch` (`:262`).
  - No macOS or AAB job exists.
- **Hooks and local validation** (BUILD):
  - Hooks are inactive (`core.hooksPath` unset, mode 100644).
  - `tool/validate.sh` fails on Windows Git Bash (exit 123, "command line too long").
  - The local format step skips untracked `.dart` files, which already caused the `f10b112` CI failure.
  - Lockfile drift only warns locally, while CI hard-fails on it.
- **Missing guards and tooling** (SOURCE):
  - No guard enforces the four screen states, purchase silence, the no-logging rule or the iOS identity.
  - There is no `integration_test`, secret scanner, Dependabot or CODEOWNERS.
- **Smoke harness** (SOURCE): it covers about 22 of the 82 operations (~27%), none from 3.29–3.46. The mock backend has no route for any 3.39–3.46 feature.

**Device and walks**
- **Wave walks** (DOC, `wave_state.md`):
  - All 22 API→UI waves are implemented. 21 were walked to 100% on the physical Pixel 8 against the mock backend.
  - Wave 03 (School registration) was never walked (`:22-24`, `:187`).
- **Real-server runs** (DOC, reconciliation §15.2 and `RISKS.md:77`):
  - The only real-server device run is the 2026-10-06 staging release build on the `Pixel_8` AVD, school track: login, catalogue, a 10-question loop (+2 points), the board, offline and sign-out.
  - The physical phone's 2026-10-06 re-walk ran a staging-flavor debug APK on mock data (ERR A3). No release build has run on physical hardware.
- **Device state** (DEVICE, `adb shell pm list packages`, 2026-10-08):
  - Pixel 8, Android 17 / API 37.
  - Installed: `com.levelup.level_up_app` (orphan) and `com.levelupworld.app.stg`. Prod is not installed.
  - Presence is intermittent: absent at 2026-10-08 22:03 and absent at this synthesis's `adb devices -l` on 2026-10-09. `adb` is not on PATH.
- **WALK command** (SOURCE): the documented WALK build command lacks `--flavor`, which Gradle has refused since `2dfd969` (`android/app/build.gradle.kts:119-131`).

**Environment, identity and store**
- **Android identity** (SOURCE + ARTEFACT + BUILD):
  - `com.levelupworld.app` / `.stg`, labelled "Level Up" / "Level Up STG"; SDK 24/36/36; version 1.0.0+1. The identity guard passes 9/9.
  - Only `merged` carries these ids.
- **iOS** (SOURCE): `com.levelup.levelUpApp`, deployment target 13.0, one scheme, and no team, Podfile, entitlements or PrivacyInfo (`project.pbxproj:349`, `:371`).
- **Firebase** (SOURCE): nothing exists anywhere. `firebase_core` 4.3.0 needs iOS 15.0 (seen in the pub cache, from another project).
- **Production config** (SOURCE + ARTEFACT):
  - The production base URL is `https://TBD.example/api/v1` (`app_config.dart:54`), and the prod APK embeds it.
  - The Login legal links point to `levelup.example`.
  - `isDev` is never read.
- **Release artefacts** (ARTEFACT):
  - The prod APK is unsigned, 16 KB-aligned and declares only INTERNET and ACCESS_NETWORK_STATE.
  - R8 and resource shrinking are ON, with mapping files under `build/app/outputs/mapping/`, archived nowhere.
  - The only AAB on disk carries the dropped id `com.levelup.level_up_app`.
- **Store P0 blockers** (DOC + CONTRACT): E-1, E-2, E-3, E-4, E-6, E-7, E-8 and AND-02 are all OPEN.
- **Served legal texts** (LIVE-PROBE):
  - They promise in-app deletion and in-app Support, neither of which exists.
  - Terms §2 promises an accept-before-continue prompt.
  - The privacy text names Sentry and FCM as sub-processors, although the app ships neither.
  - There is no support URL or email anywhere.

**Push, photos, social and legal (contract side)**
- **Push** (CONTRACT, `realtime@3.46:76-108`):
  - Exactly 4 kinds and 8 localization keys; `data` holds `kind` plus opaque ids.
  - An unknown kind opens the notifications screen.
  - The token goes to `PUT /me/fcm-token`, one per student, and the latest wins. There is no unregister operation.
  - Delivery is OFF in every environment. The text follows the phone's language.
- **Photos** (CONTRACT):
  - Support photos: JPEG/PNG/WebP up to 7,000,000 bytes; 3 per message; 10 per ticket; 10 unattached for 24 h; a presigned PUT that must replay its exact headers; a separate `Accept` for reads.
  - Avatars: up to 2,097,152 bytes; 128–4,096 px; 5 uploads per hour.
  - All photo paths are gated by Terms acceptance. Avatars are public on the CDN.
- **Chat** (CONTRACT): the hub is stable, WebSockets-only with `skipNegotiation`, takes the token as an `access_token` query parameter, and allows at most 3 connections per student. Delivery is at-most-once, with REST backfill.
- **Banned accounts** (CONTRACT): `account_banned` is returned only after a verified code, on 4 operations. None of the 19 public operations is a support operation.
- **Referral** (CONTRACT + DESIGN): the contract gives +10 to the inviter only, while Figma says 500 points to both. A third definition, "50% off", sits in the stale parent roadmap.

**Records, design and protocol**
- **`seif_fight.md`** (SOURCE): Q-B1 to Q-B10 were never filed (`grep -c 'Q-B'` = 0). S5, S11, S14, S24, S29, S30, S31 and S33 are answered by the contract, and S37 is stale.
- **Design records** (SOURCE/DOC):
  - DESIGN_ISSUES has 125 entries (#1–#126; #91 never existed).
  - No frames exist for deletion, cancellation, recovery, the banned state, report/block/unfriend/blocked list, the Terms step or document viewer, the quiz-history list, or the empty/loading/offline states.
- **Protocol** (DOC, `wave_state.md:92-94`; `implementation_waves.md:5-8`, `:28-29`):
  - Nothing advances without the owner's NEXT, WALK or FORMULATE.
  - One screen per wave.
  - "Subagents: Sonnet only".
  - A checkpoint at about 40% context.
  - Nothing is committed unless the owner asks.
  - The 22-wave FORMULATE list is exhausted.
- **Responsive rules** (DOC): `docs/RESPONSIVE.md` is "proposed, not applied".
- **Stale documents** (SOURCE/DOC):
  - R-3, `WAVE_STATUS.md`, `wave_state.md` and `ENFORCEMENT.md`.
  - The `CLAUDE.md` counts: 849 tests (now 2067), 63 commits (now 136), pin `184d6ec` (now `0df5cf4`), 48 DESIGN_ISSUES entries (now 125).
  - `STORE_READINESS.md:68`, which says R8 is off.

## 20. What we do NOT know
### 20. What we do NOT know

Each item says what was searched and who can answer. "Owner" means Mostafa.

**Owner decisions (blocking)**
- **Which pin the workflow builds against, and whether it moves per wave (B-1).**
  - Searched: `contract/SOURCE.md` (HEAD and working tree); memory upstream-contract-3-10-unlocks; DR-23 and G-03; `git ls-remote`.
  - No document names a target pin or a freeze.
  - Who: the owner, after Seif answers I-1.
- **The release-1 scope (B-2).** This covers push, the Message tab, chat, friends, support, photos, avatars, referral, recovery, track transfer, quiz history and favourites, `listModules`, and the inert surfaces.
  - Searched: D-001 to D-021; DR-01, DR-05, DR-11, DR-19 and DR-25; MI-022; rubric item 8a. None is ratified.
  - Who: the owner, with the client.
- **Which protocol governs the workflow (B-3).** Do the brief's model roles replace "Subagents: Sonnet only"? How often does Fable audit? What wave shape fits non-screen work? What is the commit policy? Do WALKs run against staging or against an extended mock?
  - Searched: `wave_state.md:92-94`, `AUDIT_PROTOCOL.md:121-149`, `AGENT_WORKFLOW.md:17-57`.
  - Who: the owner.

**Contract and backend (Seif)**
- **A release-1 contract freeze, and whether `eddb6ac` is the mobile target (I-1).**
  - Searched: the changelog at 3.46 (the only "freeze" hit is about `totalPoints`); `docs/`.
  - Who: Seif.
- **The production host and its date; whether `/hubs/chat` is on the same host; production reviewer numbers with a fixed OTP (I-2).**
  - Searched: `servers:` at every pin (staging only); `ENVIRONMENTS.md:397-400` (planned `api.level-upworld.com`, not deployed); `seif_fight.md` (0 hits).
  - Who: Seif.
- **What happens to the FCM token on logout, `session_superseded` or an account switch (I-3).**
  - Searched: `openapi@3.46:451-461`, `:1060-1082`; `realtime@3.46:108`; `seif_fight.md` (fcm only at `:123` and in S28).
  - Who: Seif. This is a privacy risk for minors on shared phones.
- **Which signed-out channel a banned student, or one hitting `recovery_unavailable`, can use to reach Support; and which contact the app may show (I-4).**
  - Searched: the 19 public operations (none is a support operation); `error-codes@3.46:51`; `seif_fight.md:1318` (unanswered).
  - Who: Seif for the channel; the owner for the contact and copy.
- **Whether `UniversityRegistration.inviteCode` is draft or stable (I-5).**
  - Searched: `openapi@3.46:4182` versus `:4147`, `:390` and the 3.44 entry.
  - Who: Seif.
- **Staging data and push timing (I-6).**
  - Unknown: a seeded University account; seeded friendship, request, conversation and ticket states; whether the photo 403 actually fires for a student who has not accepted Terms; when push delivery is switched on.
  - Searched: `RISKS.md:118-126`; S37 and S44; `openapi:96` (it defines the numbers, not the data). Only one registered school account has been observed.
  - Who: Seif.
- **Whether the backend has, or plans, operations for Progress, Daily Tasks or a personal streak (I-7).**
  - Searched: grep of all four contract files at 3.46; `realtime@3.46:10`; S32.
  - Who: Seif; the designer and the owner for how frames map to data.
- **Deletion confirm copy the app can show without the "paid"/"refund" wording (I-8, Q-B2 never filed).**
  - Searched: `openapi@3.46:1284-1286`; reconciliation `:184`, `:206`; DR-03.
  - Who: Seif; the owner rules; the designer draws the frames.
- **The UGC posture (I-11).** Unknown: whether display names and chat text are filtered, the response time for reports, and whether Seif endorses leaderboard "Option 0".
  - Searched: the contract (no text on filtering); reconciliation Q-B9.
  - Who: Seif; the owner rules on DR-04.
- **Presigned-PUT details (N-4) and the `enrolment_opened` data keys (N-3).** Unknown: what the storage host returns on failure, whether the same URL may be retried, the storage hostname and the per-kind hourly push limit.
  - Searched: `openapi`, the admin files and the changelog. None documents them.
  - Who: Seif.
- **Behaviour no probe could show.**
  - Whether staging storage and SafeSearch work end to end (a `503 image_upload_unavailable` is still possible).
  - Whether the missing `Accept` header ever yields a body-less error.
  - What a second verify returns after `account_banned`.
  - Whether production will have a Terms version (`getLegalDocument` may answer 404).
  - Only unauthenticated probes were made and no wire capture exists. Who: Seif, or a staging run with a whitelisted number.
- **Whether Sentry is backend-only.** The served privacy text names Sentry and FCM, but the app ships neither.
  - Searched: the staging privacy text; `pubspec`.
  - Who: Seif. This matters if DR-12 picks an app-side crash reporter.

**Product, legal and design (owner, client, legal, designer)**
- **The subscription option and the commissioned frames (I-9).** The options are no screen, a status screen without a link, or a status screen with a link (which needs adr-049 revised). The designer's node ids for the commissioned dual subscription screens are also unknown.
  - Searched: `RISKS.md:142-150`, D-007, `ENVIRONMENTS.md:405-412`, `F:\level\03_role_uiux_partner.md:14-15`; no node id is recorded.
  - Who: the owner and Seif; the designer.
- **Public legal and policy facts (I-10).**
  - Unknown: the public privacy, terms and deletion URLs; who approved `r4-2026-10-07` and whether production will match it; the legal entity name; retention periods, regions and sub-processors (Q-B1); whether the School parent report is delivered; and the support URL or email for the listings.
  - Searched: D-021 Q1 and Q7; `STORE_READINESS.md:213-262`; the staging legal texts.
  - Who: Seif or the web team; the owner and legal.
- **Firebase ownership (I-12).** Unknown: who owns the project or projects, who registers the 4 ids and with what structure, who issues the APNs key under which team, and whether R-9's gate on registration is lifted.
  - Searched: `DECISIONS.md:1060`; `ENVIRONMENTS.md:340-357`; `RISKS.md:137`; DR-18.
  - Who: the owner or the client, with Seif.
- **Apple and Play accounts (I-13).** Unknown: which Mac with Xcode 26 (or paid macOS runner) is available and from when, who holds the Apple team, and whether Play publishes from an organisation or a personal account.
  - Searched: `ENVIRONMENTS.md:101`, `:284`, `:368`; `ci.yml` (no macOS job); the pbxproj (no `DEVELOPMENT_TEAM`).
  - Who: the owner or the client.
- **The Terms gate (I-14).** Unknown: where it sits, whether the whole app blocks, what replaces the Cookie Policy link, who approves the AR/EN text (S30), and the position on parent consent.
  - Searched: `openapi@3.46:816-831`, `:1087-1123`; staging Terms §2; DR-14.
  - Who: the owner, legal and the designer.
- **Photos of minors (I-15).** Does the domain-rule-9 review cover picked photos for public avatars and support? Should the app ever ask for camera permission?
  - Searched: `.claude/skills/level-up-domain/SKILL.md:22`; `store_readiness_audit.md:232`.
  - Who: the owner and legal.
- **Push experience (I-16, N-15, N-24).** Unknown: when to ask for permission, the explanation shown first, the copy after a refusal, what shows when a push arrives while the app is open, and whether to return to the tapped target after sign-in.
  - Searched: `realtime@3.46:78-108` (no permission text); DESIGN_ISSUES (no push entry).
  - Who: the owner and the designer.
- **Entry points (I-17).** Unknown: where the bell leads versus the Message tab (D1–D5); entry to Friends, the Blocked list and Support; what the people icon `649:8837` opens; where `forwardQuestion` lives.
  - Searched: `notification_inbox_3_28_investigation.md:345-349`; `endpoint_ui_mapping.md`.
  - Who: the owner and the designer.
- **The referral rule (I-18): 500 points to both, or +10 to the inviter.** Also whether the app starts sending `inviteCode`.
  - Searched: DESIGN_ISSUES #7; S5.
  - Who: the owner, with Seif and the designer.
- **Copy the contract does not supply (I-20).** This covers inbox kinds, photo refusals, Terms, the ban screen, lockout, track transfer, recovery, deletion and the push pre-prompt.
  - Searched: `lib/l10n/*.arb` (no inbox or push keys); the contract (English hints only).
  - Who: the owner and the designer.
- **About 16 groups of missing frames, and designer capacity (I-21).**
  - Searched: DESIGN_ISSUES; `wave_state.md:1607`; Figma `get_metadata` on 16 nodes; grep of `docs/` and `.ai/` for designer availability (none).
  - Who: the designer, through the owner.
- **The minors and data-protection memo (I-22).** Unknown: age floor, guardian phone, purpose wording, the applicable law, the data controller, hosting region, and whether licence notices must be shown (DR-28).
  - Searched: `STORE_READINESS.md:245-252`; DR-08 and DR-27.
  - Who: the owner and legal, with Seif for hosting.
- **Who signs off product and store decisions (N-7):** the owner, the client, or "Yousef" (`STORE_READINESS.md:245`).
  - Who: the owner.

**Engineering facts not yet established**
- **Whether the suite is green at 3.46.**
  - Searched: no BUILD run exists at `eddb6ac`; the 3.45 clone was green.
  - Risk: low (INFERRED; a 6-line diff that no test reads), but the dry run is owed.
  - Who: a BUILD run before the re-vendor commit.
- **CI questions.** Will the flavored release compile gate pass on its first CI run? Does `workflow_dispatch` accept `ref=merged` for codegen-drift? How will the Ubuntu 26 migration (from 2026-10-19) affect runs?
  - Searched: `ci.yml:262`, `:320`, `:380`; `gh` run history. None was tested, because each would be an outbound action.
  - Who: CI, after the owner's go (I-19).
- **GitHub repository settings.** Is secret scanning or push protection on? Is classic branch protection available on this plan?
  - Searched: `gh api ... security_and_analysis` returned nothing; the rulesets API answered 403.
  - Who: the owner, in GitHub settings.
- **Whether the smoke harness still passes against today's staging, and whether Dio's global `Content-Type` is correctly overridden for a multipart avatar upload.**
  - Searched: neither was run (one needs the network and a whitelisted number; the other needs a BUILD-level test).
  - Who: a staging or BUILD run in the relevant wave.
- **New dependencies.** Which SignalR client, picker or compressor, Markdown renderer and Firebase versions to use; their licences; their iOS minimums.
  - Searched: the pub cache (none present except `firebase_core` 4.3.0, `flutter_local_notifications` and `permission_handler` from other projects). Cannot be checked offline.
  - Who: a spike, then the owner's approval per dependency (N-13).
- **iOS runtime behaviour.**
  - Unknown: whether the iOS Keychain is cleared on uninstall; whether `screen_protector` crashes on iOS 26 (H-7); Apple's reaction to the `device_info_plus` required-reason API; and whether the first Mac build rewrites `AppDelegate`/`Info.plist` in a way that breaks notification handling.
  - Searched: SOURCE only; no Mac is available.
  - Who: Env Wave 3 on a Mac.
- **Device availability and coverage.**
  - Unknown: whether the physical Pixel 8 stays attached (intermittent: absent 2026-10-08 22:03 and at one 2026-10-09 check; present at report assembly on 2026-10-09). There has been no release build on physical hardware, no prod-identity install with both identities side by side, and no physical-device run against a real server.
  - Searched: `adb devices -l` on 2026-10-08 22:03 and 2026-10-09 (none listed).
  - Who: the owner, who connects the phone; then a WALK.
- **Repo liveness and leftovers.**
  - Unknown: whether another Claude session is writing to the repo (file timestamps cannot prove liveness); the fate of the untracked roadmap files (N-8); whether the dirty-tree backup is superseded line by line.
  - Who: the owner.

## Appendix: Fable audit of the synthesis

Verdict: The synthesized artefacts are substantially accurate against primary sources. Re-derived read-only on 2026-10-09: the census at all four pins (54/38/16/3→35; 77/53/24/4→49; 86/81/5/4→77; 86/86/0/4→82), 19 public operations with no support op, 63 schemas / 62 error codes, the 3.46 diff (version line + 5 `x-stability` lines; realtime/error-codes unchanged), commit counts 8/13/21, openapi line counts 3105/4188/4935, the git facts (merged 136 commits @8e641e9, main 32 behind as a strict ancestor, dev 6 local commits all contained, +1498/−217 blob-identical to 65245be, hooks inactive, no branch protection), CI history (15 runs: 12 merged with the f10b112 format failure, 2 main, 1 dev), ci.yml:262/320/380, the hotspot-matrix arithmetic (12 H, 30 G, K4 all-H, the no-H list), the generated-file/golden counts (22/20/3/43/10), the hand-split commit bodies, the memory notes and nearly every code and contract file:line cite all hold. Nineteen corrections are returned: one HIGH (§17.10's per-wave gate 'lists `mobile` in `x-consumers`' contradicts the contract's own rule at changelog@eddb6ac:586 — 72 of 86 operations carry no key, so the gate would reject most consumed operations), three MEDIUM (the Terms step is tiered as optional scope although the contract directs an in-app Terms display during registration, by the same criterion the synthesis used for the banned-account row; B-3 sub-questions (a)/(c) have stated defaults and are over-tiered, and the brief's model split is itself an owner instruction to be recorded rather than re-ruled; §17.5's 'no shared code file' claim between env/release and screen tracks omits the T08/T09–T18/T20 M edges in the map's own rendering), and fifteen LOW items (mis-attributed protocol cites to wave_state.md:92-94, the device is in fact attached at audit time, the release-gate 'never run' wording, I-5 tiering, duplicated asks, the Seif batch omitting the ratified ids, a 'what we do not know' item answerable from ci.yml, a T02→T11 routing-destination dependency, three H edges drawn as G, cite/wording precision, the AA-40 vs 'never filed' contradiction, the unread handoff text, and the unwalked Wave 03 missing from the RC gate). No purchase-silence, invented-shape or owner-decision violations were found in the recommendation; the three blocking questions remain genuinely blocking on B-1, B-2 and B-3(b)/(d). Verdict: the discovery is NOT READY FOR WORKFLOW as stated, and the workflow shape is usable once the §17.10 gate is corrected and the Terms step is re-tiered.

Applied in the text above: HIGH contract gate 2; LOW device availability (summary); LOW device availability (dont-know); LOW flavored gate wording (summary); LOW flavored gate wording (know); LOW flavored gate wording (shape); LOW 26 h -> 28 h (4 texts). **Every other finding below supersedes the text it names** (they are LOW/MEDIUM wording, tiering and citation corrections; the MEDIUM ones re-tier B-2 row 1 and B-3 (a)/(c), and narrow the T18-T21 lane-independence claim).

- **Workflow shape §17.10 'Backend-contract gates', gate 2 ('lists `mobile` in `x-consumers`')** [HIGH]: The per-wave gate contradicts the contract's own rule and would reject most operations the app already consumes. At eddb6ac only 14 of 86 operations carry an `x-consumers` key (10 `[mobile, web]`, 4 `[web]`); 72 have none, including `completeRegistration`, `refreshTokens`, `logout`, `getMyProfile`, `updateMyProfile` and every inbox/chat/support/avatar operation. The contract states that absence means mobile-only and that the key is documentation metadata, not an authorisation source. §17.10 item 3 also recommends mechanising gates, so a check written from this wording would fail every feature wave. -> Rewrite gate 2 as: 'is `x-stability: stable` at the pin and is NOT `x-consumers: [web]`' (the rule `contract/SOURCE.md:12-13` and the census already apply). Drop 'lists `mobile`'. (CONTRACT: upstream `contract-changelog.md@eddb6ac:586` "Operations are mobile-consumed by default. Absence of `x-consumers` means mobile-only"; `:587` "`x-consumers` is documentation metadata and nothing else … not an authorization source". PyYAML census run by this audit on `scratchpad/fable_audit/openapi_eddb6ac.yaml`: consumer combos = {(), ('mobile','web'), ('web',)}; 72 operations with no key. SOURCE: `contract/SOURCE.md:12-13` defines app-buildable as stable minus `[web]`.)
- **Q.md §14 B-2 row 1 ('Terms acceptance step') tiered as an open SHIP/DEFER scope row; workflow shape §17.4 T10 'B-2 row 1'** [MEDIUM]: Inconsistent with the synthesis's own criterion for row 0b, which is 'already required' because the contract asks for a screen. The contract equally directs an in-app Terms display during registration: `getLegalDocument` says the app shows the text 'during registration and from settings, so the text is rendered IN the app'; `getTermsAcceptance`/`acceptTerms` are stable at the committed pin 0df5cf4; the photo 403 gate is live on staging (ERR AF1) and gates T08/T09 regardless of scope. Only the gate behaviour and placement (I-14) are genuinely open. Treating the Terms step as optional scope is a 'contract wins' violation by the same logic used for 0b. -> Move the Terms display-during-registration step to the required group (row 0c), keep I-14 for gate shape/placement/parent-consent, and mark T10 as a hard predecessor of T08 and T09 independent of B-2. (CONTRACT: `openapi.yaml@eddb6ac:819-820` (getLegalDocument description); `:1087-1096`, `:1116-1123` (stable at every pin — census shows both stable at 0df5cf4); `:1025` and `error-codes.md@eddb6ac:67` (`terms_acceptance_required`). Q.md:70-72 (0b criterion: 'required because `verifyOtp` is already consumed'; changelog `:78` 'What to build'). ERR.md Additional finding 1.)
- **Q.md §14 B-3 sub-questions (a) model roles / Fable cadence and (c) commit policy; workflow shape §17.7 and §17.12 item 3** [MEDIUM]: Mis-tiered. By the synthesis's own tiering rule (§16: non-blocking = has a safe default), (a) and (c) carry stated defaults ('If unanswered: Sonnet-only subagents, so Fable audits run outside subagents; no commits without a request'; cadence default = the close-out hand-off of `AGENT_WORKFLOW.md:20` / `cor_ci_validation.md` §2.6). Only (b) (no wave shape for multi-screen/non-screen work) and (d) (mock has no routes for 3.39–3.46, so no usable default) lack a default. In addition, the brief's Opus/Sonnet/Fable split is itself an owner instruction (task FACTS), so the recorded P-3 for the API→UI workflow is not a conflict the owner must newly rule on; it needs recording as an amendment in `wave_state.md`. -> Keep B-3 BLOCKING on (b) and (d). Move (a) and (c) to IMPORTANT with their defaults, phrased as 'confirm so the amendment to P-3/P-6 is written into wave_state.md and DECISIONS.md'. §17.7 should say the brief's split applies unless the owner says otherwise, with the only open parts being Fable cadence and whether Fable may write. (DOC: `.ai/audits/current/wave_state.md:92-94` (the rule text); `docs/AGENT_WORKFLOW.md:20` '→ COMMIT → FABLE (when required)'; `docs/AUDIT_PROTOCOL.md:125-149`. Q.md:159-164 ('If unanswered: the stricter existing rules apply'). Task FACTS: 'The owner's new brief asks for Opus orchestration, Sonnet execution and Fable audit.')
- **Workflow shape §17.5 'Env/release vs screen tracks. T18 to T21 share no code file with T05 to T17. There are two exceptions [T08/T09→T19 only]'** [MEDIUM]: The hotspot map's own rendering shows additional shared-file (M) edges that the sentence omits: T08–T18 M, T08–T20 M, T09–T18 M, T09–T20 M (rows T08 and T09, columns T18/T20 of `mc/matrix_out.md`), while `mc/matrix.py` anchor A19b = {8,9,19}. The shape notes a T19-vs-T18/T20 rendering discrepancy but still asserts the no-shared-file claim as fact; the parallel-lane recommendation (lane C beside lanes A/B/D) rests on it. -> Regenerate `matrix_out.md` from `matrix.py` before relying on it; until then state the claim as 'per the anchor key, T18–T21 share code only with T04 and, conditionally, T08/T09 (Info.plist keys) — the rendered matrix also marks T08/T09 vs T18/T20 as M'. Keep lane-width confidence LOW (as §17.14 already does). (EXEC/SOURCE (scratch): `scratchpad/mc/matrix_out.md` rows T08 and T09 (`| M | . | M | G |` under T18 T19 T20 T21); `scratchpad/mc/matrix.py:38` (`A19b … {8,9,19}`). Independent recount of the matrix by this audit: 12 H, 30 G, K4 all-H, no-H list — all as stated.)
- **Q.md §14 B-3 question text (Q.md:127-132) and Executive summary §1 'Protocol — Current rules (DOC, wave_state.md:92-94)'** [LOW]: Two of the five rules attributed to `wave_state.md:92-94` are not there. That passage carries only: nothing advances without NEXT/WALK/FORMULATE; 'Subagents: Sonnet only'; the ~40% checkpoint. 'One screen per wave' lives in `implementation_waves.md:1,6-8` (and `wave_state.md:12`); 'nothing is committed unless the owner asks' is `implementation_waves.md:28`. The 'What we know' §19 and `cor_roadmap_registers.md` P-2/P-6 cite these correctly; B-3's ready-to-send text and §1 do not. -> Cite `wave_state.md:92-94` for rules 1, 3 and 4; `implementation_waves.md:1,6-8` (+ `wave_state.md:12`) for one-screen-per-wave; `implementation_waves.md:28` for the commit rule. (DOC: `.ai/audits/current/wave_state.md:92-94` (read verbatim this audit: 'no wave starts, no screen is touched, no WALK runs, no advance happens without the owner's explicit command … Subagents: Sonnet only. Replies: concise. Context: checkpoint this file at ~40%'); `.ai/audits/current/implementation_waves.md:1` ('one wave per screen'), `:6-8`, `:28` ('Nothing is committed unless the owner asks'); `cor_roadmap_registers.md:213-218` (P-1..P-6 cites).)
- **Executive summary §1 'Device — Availability … absent again at this synthesis's own `adb devices -l` on 2026-10-09'; §20 'What we do NOT know — Device availability: when the physical Pixel 8 will be attached again'; workflow shape §17.9** [LOW]: Stale at audit time. On 2026-10-09 (this Fable pass) the physical Pixel 8 is attached over USB and enumerated by adb (serial `45131FDJH0009G`, product `shiba`); Android 17 / API 37; packages `com.levelup.level_up_app` and `com.levelupworld.app.stg` installed, no prod package; `adb` still not on PATH. Everything except presence matches the synthesis. -> Replace 'absent on 2026-10-09' with 'intermittent — absent at 2026-10-08 22:03 and at the synthesis's check, present at the 2026-10-09 Fable audit'; keep the 're-check at every WALK' rule. The 'what we do not know' item becomes 'whether it stays attached', not 'when it will be attached again'. (DEVICE: `C:\Users\musta\AppData\Local\Android\Sdk\platform-tools\adb.exe devices -l` → `45131FDJH0009G device product:shiba model:Pixel_8`; `adb shell pm list packages | grep levelup` → the two packages above; `getprop ro.build.version.release` = 17, `ro.build.version.sdk` = 37; `which adb` → none on PATH (2026-10-09).)
- **Executive summary §1 'Gates — CI: The flavored release compile gate runs on pushes to main only and has never run.' (also §17.11 'The flavoured release gate has never run in CI')** [LOW]: Imprecise. The `build-release-apk` job ran on both `main` pushes (#5 `f987f20`, #9 `e71e9a1`, 2026-09-19/20) in its pre-flavor form; ERR A7 records both main runs passing all four jobs. What has never run is the job in its flavored form (`--flavor prod -t lib/main_prod.dart`, added by `2dfd969` on 2026-10-06). The handoff table and §19 word it correctly ('never run against the flavored ci.yml'). -> '…runs on pushes to `main` only and has never run in its flavored form (the two `main` runs predate `2dfd969`).' (CI: `gh run list` (this audit): run 5 main f987f20 success 2026-09-19; run 9 main e71e9a1 success 2026-09-20; latest main-era commit with flavors `2dfd969` 2026-10-06. SOURCE: `.github/workflows/ci.yml:318-322`, `:380`. ERR.md A7.)
- **Q.md §15 I-5 ('UniversityRegistration.inviteCode wording') tiered IMPORTANT** [LOW]: It is a contract wording error of the same class as the N-2 batch and carries a safe default that Q.md itself states ('do not send `inviteCode` for University registrations'). `x-stability` is an operation-level key; `completeRegistration` is stable and `:390` plus `:4147` plus the 3.44 entry say the field is stable; only the property description at `:4182` retains draft prose. Tiering it as a separate IMPORTANT item inflates the blocker list; it blocks only the University half of the referral sub-wave. -> Fold I-5 into N-2 as item (k) (or keep a one-line pointer under I-18), with the default recorded. Keep it in the Seif batch. (CONTRACT: `openapi.yaml@eddb6ac:390` ('`inviteCode` (optional, spec-047, `stable` since 3.44.0-m1)'), `:4147` ('OPTIONAL (spec-047; `stable` since 3.44.0-m1)'), `:4182` (draft prose on the University property, no `x-stability` key on a property). Q.md:210 ('If unanswered: do not send `inviteCode` for University registrations').)
- **Q.md §15 I-4 / I-10(f) / I-14 / I-8 / I-16 / I-21 — duplicated asks** [LOW]: Several facts are asked twice across I-items: the support contact (I-4 Mostafa half and I-10(f)); who approves the AR/EN legal text (I-10(b) and I-14 'Who approves … (S30)'); the deletion request/confirm/cancel frames (I-8 designer ask and I-21); the push permission pre-prompt frame (I-16 and I-21). The designer batch therefore lists the same frames under two IDs. -> Ask each once and cross-reference: support contact → I-10(f) only (I-4 points to it); legal-text approver → I-10(b) only; deletion and pre-prompt frames → I-21 only (I-8/I-16 reference I-21). (Q.md:199-205 (I-4), :277-288 (I-10), :312-321 (I-14), :242-250 (I-8), :329-336 (I-16), :388-412 (I-21), :749-758 (designer batch).)
- **Q.md 'Message batches — To Seif' (Q.md:734-747)** [LOW]: Omits the one answer Seif explicitly asked for (handoff §7.1: the Android application id and iOS bundle id). AA-5 and ERR coverage row §7 both say the ratified ids must be sent to Seif (the iOS Xcode project still carries the template `com.levelup.levelUpApp` at 13.0, so Seif must not read it from the repo). The batch lists only questions I-1..I-12 and N-1..N-6. -> Add to the Seif batch: 'Ratified identities (D-021 Q1/Q4): Android and iOS `com.levelupworld.app` (prod) / `com.levelupworld.app.stg` (staging); iOS minimum 15.0. Nothing may be registered with Firebase until I-12 / R-9 is settled.' (DOC: `docs/DECISIONS.md:1054-1058` (Q1–Q4); SOURCE: `ios/Runner.xcodeproj/project.pbxproj:349` (13.0), `:371` (`com.levelup.levelUpApp`); `android/app/build.gradle.kts:55`, `:76`. Q.md AA-5 (:666); ERR.md coverage row '§7 identity questions'.)
- **Q.md §16 / §20 'What we do NOT know — CI questions: Does `workflow_dispatch` accept `ref=merged` for codegen-drift?'** [LOW]: Answerable from the repo at SOURCE level. `workflow_dispatch` is declared with no inputs or branch restriction, and the codegen-drift job's condition is `github.event_name == 'workflow_dispatch' || (push && ref == main)` — the dispatch arm has no ref condition, so a dispatch on `merged` runs the job. Whether it passes is the open part. -> Move to 'known (SOURCE)': a manual dispatch on `merged` runs codegen-drift; the unknown is only its result, which needs the owner's go (outbound action). (SOURCE: `.github/workflows/ci.yml:30` (`workflow_dispatch:` with no inputs), `:262` (`if: github.event_name == 'workflow_dispatch' || (github.event_name == 'push' && github.ref == 'refs/heads/main')`).)
- **Workflow shape §17.4 T02 row and §17.6 L-AUTH-ROUTER ('global 403 routing for `account_banned` and `account_pending_deletion`' in T02, before T10/T11)** [LOW]: Missed dependency: the contract's rule for `account_pending_deletion` is 'route to the cancel screen', but the cancel screen belongs to T11, which the K4 chain orders after T02 and T10. T02 would therefore wire a redirect to a destination that does not exist, or invent an interim target. The existing `isAccountPendingDeletion` seam (no screen) is the only thing T02 can land without inventing. -> Split the arm: T02 lands the router/error seam and the `account_banned` screen (its destination is in T02's own scope); the `account_pending_deletion` redirect target lands in T11, with the T02 seam asserting 'no redirect yet' until then. Record the split in the lock table. (CONTRACT: `openapi.yaml@eddb6ac:82-83` ('route to the cancel screen, drawn from `GET /me`'s `pendingDeletion.effectiveAt`'). SOURCE: `lib/core/network/exceptions.dart:134` (`isAccountPendingDeletion` seam, no screen); no `account_banned` string in `lib/` (grep 0). Workflow shape §17.4 graph (T02 → T10 → T11).)
- **Workflow shape §17.4 dependency graph ('T15 ─> T07'; 'T18 Env W2 ─> T19 ─> T04 push') with the legend 'an arrow means a hard ordering (G)'** [LOW]: Three arrows are not G edges in the matrix: T07–T15 is H (anchor A13 quiz review/question UI), T04–T18 is H (A17 boot/config) and T04–T19 is H (A19 ios/**). H means 'serialise'; the direction is the shape's own sequencing choice, not a dependency the map recorded. The table hedges ('after T15') but the graph presents them as G. -> Mark those three arrows as 'H — serialise, order chosen' (dashed) and keep G arrows only where `matrix_out.md` says G (T01→T02..T17, T02→T04, T05→T06→T07, T08/T09→T10, T18→T19, T19/T20/T04/T08–T11→T21). (EXEC/SOURCE (scratch): `scratchpad/mc/matrix_out.md` row T07 col T15 = H; row T04 cols T18, T19 = H; `mc/matrix.py` anchors A13 {7,15} H, A17 {4,18} H, A19 {4,19} H.)
- **Workflow shape §17.7 ('`AGENT_WORKFLOW.md:19` "FABLE (when required)"'); §17.3 ('In 2026-10-06, an owner hold given to one session was invisible…')** [LOW]: Two cite/wording slips. The loop line '→ COMMIT → FABLE (when required) → NEXT WAVE' is `docs/AGENT_WORKFLOW.md:20` (line 19 is '→ GUARD PROOF (when a rule changed) → AUDIT EVIDENCE'); Q.md DC-16 (:611) cites :20 correctly. The hold was given on 2026-09-30 ('commit Wave 20, do NOT push'); the peer's push that published it happened on 2026-10-06. -> Cite `AGENT_WORKFLOW.md:20`; write 'a hold given on 2026-09-30 was invisible to a peer, which published the held commit on 2026-10-06'. (DOC: `docs/AGENT_WORKFLOW.md:18-20` (read this audit); memory `concurrent-sessions-repo-etiquette` §'2026-10-06 — an owner hold given to ONE session' ('On 2026-09-30 the owner told my session … On 2026-10-06 the "Fable-eye" session … fast-forwarded origin/merged e6e6567 → 3913f86').)
- **Executive summary §1 'Upstream moved 8 minor versions (3.39 → 3.46) in about 26 hours' (also B-1, I-1, MAT header); ERR AF4 says 'about 28 hours'** [LOW]: Internal inconsistency and a rounding error. 3.39 (`e5886a6`) is 2026-10-07 11:12:40Z and 3.46 (`eddb6ac`) is 2026-10-08 14:56:03Z: 27 h 43 min. '26 hours' rounds down; §19 says '26–28 hours'. -> Use 'about 28 hours' everywhere (or '27 h 43 min, 2026-10-07 11:12Z → 2026-10-08 14:56Z'). (CONTRACT (git): `git log -1 --format='%ci'` in `scratchpad/upstream-contract` for `e5886a6` (2026-10-07 11:12:40 +0000) and `eddb6ac` (2026-10-08 14:56:03 +0000).)
- **Handoff table §8.6 / §19 'the Home bell is inert, with `hasUnreadNotifications` hard-set to false (`home_header.dart:36`)'; handoff table §5.2 evidence `openapi@3.46:1338-1412`** [LOW]: Cite precision. `home_header.dart:36` is the field declaration; the `false` is the constructor default at `:23`, and no caller in `lib/` passes the parameter at all (grep: zero call sites outside the file). The §5.2 range `:1338-1412` runs past `transferToUniversity` into `getMyEntitlements` (`:1409-1412`). -> Cite `home_header.dart:23` ('`this.hasUnreadNotifications = false`') plus 'never passed by any caller'; narrow §5.2 to `openapi@3.46:1337-1400` (the transfer operation) and cite `:1409-1412` separately where entitlements are meant. (SOURCE: `lib/features/home/widgets/home_header.dart:23`, `:36`; `grep -rn hasUnreadNotifications lib` → only the definition file. CONTRACT: `openapi.yaml@eddb6ac:1337-1340` (transferToUniversity), `:1409-1412` (getMyEntitlements).)
- **Q.md AA-40 ('Already filed as Q-B2, with option (a) recommended. Do not re-ask the owner') vs I-8, §5.3 and 'Message batches' ('Q-B2, never filed')** [LOW]: Internal contradiction in the consolidated questions. Q-B2 was drafted in the 2026-10-06 reconciliation document but was never filed in the canonical channel `docs/seif_fight.md` (grep for `Q-B[0-9]` returns 0, confirmed this audit). -> AA-40 should read 'already drafted as Q-B2 in the reconciliation (option (a) recommended); never filed in seif_fight.md — filing is part of the Seif batch, I-8'. (SOURCE: `grep -cE 'Q-B[0-9]' docs/seif_fight.md` = 0 (this audit). Q.md:701 (AA-40), :243 (I-8 'Q-B2, never filed'), :722 (message batches).)
- **Handoff verification table §4 header ('The handoff text itself was not an input to this synthesis. Claims are as quoted by the dimension sections')** [LOW]: Methodological gap, honestly disclosed but not resolved: 95 verdicts are issued on a document the synthesis never read; the 'Claim' column is reconstructed from investigator quotes. No handoff file exists in the repo (`git ls-files | grep -i handoff` → none beyond the parent-folder role briefs) or in the scratchpad (`nd_part2.txt` is 'newly discovered' notes, not the handoff). Any misquotation by an investigator becomes an unverifiable verdict (the §8.1 push-string row already says so). -> Add a precondition to §17.12: the owner attaches the backend handoff text (or its file path) so the §4 table can be re-run against the verbatim claims before the Seif batch is sent; until then mark the table 'claims as transcribed by investigators'. (SOURCE: `git ls-files | grep -iE 'handoff|hand-off'` → no handoff document in `level_up_app`; `F:\level\04_interfaces_and_handoff_contract.md` is the team-model brief, not Seif's 2026-10-07 handoff; scratchpad grep for the §3.1/§6.9 strings finds them only inside `results/cor_*.md` quotes.)
- **Executive summary §1 / §19 / §20 — Wave 03 (School registration) 'never walked'; workflow shape §17.13 Phase 4 exit gate** [LOW]: Missing gate. The synthesis records that Wave 03 was closed 'implemented, unwalked' (owner `NEXT` without `WALK`), yet no question, wave or release-candidate exit criterion names its walk. School registration is the entry path for every School student and will change again (Terms step after T10, `inviteCode` after T14). The Phase 4 gate lists a generic 'physical-device staging walk' only. -> Add 'Wave 03 School registration walked on the Pixel 8 (mock, then staging), including the Terms step and `inviteCode` once T10/T14 land' to the Phase 4 exit gate, and list it as an owner `WALK` item in the message batch. (DOC: `.ai/audits/current/wave_state.md:22-24` ('Wave 03 — School registration device walk | NOT RUN — owner advanced with NEXT'), `:187` ('not scored (unwalked)'). ERR.md A4.)
