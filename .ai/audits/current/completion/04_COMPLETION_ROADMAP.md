# Level Up — Completion Roadmap v1 (2026-10-09)

> **Lead review (Opus control plane, 2026-10-09).** Drafted by Sonnet, adversarially verified by a second Sonnet agent, composed with the verifier's findings applied, then reviewed by the lead. Workflow run `wf_6986d53d-04f`. Nothing in this file has been sent to anyone.

> **Lead amendments (2026-10-09, after review).** (1) The `Accept: application/json` header and the true `ErrorInterceptor` comment were delivered in CW00 as safe prerequisite-light work (uncommitted, see `01_SAFE_WORK.md`); CW02 keeps the rest of its scope. (2) The owner verbs for this program are `FORMULATE`, `START WAVE <ID>`, `REVIEW`, `NEXT WAVE`, `WALK`, `STOP` (D-024); where this file says "`NEXT`" read `NEXT WAVE`. (3) The WALK substrate for new surfaces (staging with seeded accounts vs an extended mock) is still an owner decision (discovery B-3(d)); it is listed in `COMPLETION_STATE.md`. (4) The lead's BUILD dry run at `eddb6ac` already passed (`00_BASELINE.md` §9), which de-risks CW01.

**Basis (2026-10-09).**
- The repo is `merged@8e641e9` (LB, "lead baseline").
- The contract target is `eddb6ac` (3.46.0-m1).
- A census of `git show eddb6ac:openapi.yaml` found 86 operations, all `x-stability: stable`. A second reproduction by YAML parse gave the same result.
- Four operations are `x-consumers: [web]` (`requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `listTerms`, `redeemSubscriptionCode`), so 82 are app-buildable. 72 carry no `x-consumers` key (mobile by default, `C:c:586-587`). 19 are public. `info.version` is 3.46.0-m1 and all four upstream blobs have 0 CR bytes.
- No consumed operation carries a `x-behaviour-changed` stamp from 3.29 onward. The stamps sit on five chat operations, `forwardQuestion` and `redeemSubscriptionCode`. `verifyOtp` gained `403 account_banned` (`C:c:73`, `C:o:231`).
- Observation, not a claim of cleanup: on 2026-10-09 the OS temp dir held `contract-changelog.md` and `openapi_cccd.yaml`. Their owner is NOT KNOWN. This roadmap does not depend on them, and the repo was not touched.

**Citation key.**
- `D:n` is line n of `.ai/audits/current/PRE_EXECUTION_DISCOVERY.md`.
- `C:o:n`, `C:c:n`, `C:e:n`, `C:r:n` are lines of openapi.yaml, contract-changelog.md, error-codes.md and realtime.md at `eddb6ac`.
- `LB` is the lead baseline.
- Other cites are repo `path:line`.

**Corrections to discovery text.** These supersede the discovery text they name.
1. **Photos and avatars are stable at 3.46.**
   - Three support-photo operations (`C:o:2849,2900,2946`) and two avatar operations (`C:o:982,1042`) flipped on 2026-10-08 (`C:c:7`). The discovery row that says "BLOCKED (contract draft)" is stale (`D:2995`).
   - The stale prose also remains inside the contract. `C:e:16` and `C:e:61-67` still say "draft".
   - I list this as a question for Seif, not a blocker.
2. **The contract gate is "stable AND NOT `x-consumers: [web]`."** It is not "lists mobile" (`D:5671`).
3. **T02 is split.** The seam and the banned screen land in CW02. The pending-deletion redirect target lands in CW05 (`D:5682`).
4. **The Terms step is required, not optional** (`D:5672`).
5. **Three graph arrows are H, not G:** T07–T15, T04–T18 and T04–T19 (`D:5683`).
6. **The Wave 03 School-registration walk is an RC gate item** (`D:5689`, `wave_state.md:22-24`).
7. **Edge labels follow the discovery matrix.**
   - T02–T12 is H (`D:4891`), so CW06–CW02 is H. The plan adds a functional need for the banned screen.
   - T10–T14 is M (`D:4899`), so CW04–CW15 is M.
   - T03–T15 and T06–T15 are H (`D:4892,4895`, K3 at `D:5026`).
   - T07–T15 is H (`D:4896`).

**Status vocabulary.**
- **READY:** all inputs are in hand once predecessors close.
- **READY INDEPENDENT WORK:** a named subset can proceed with no external answer, and the rest is gated as stated.
- **PREPARATION ONLY:** only non-shipping groundwork is possible.
- **BLOCKED:** an external input is missing.
- **OWNER DECISION REQUIRED**
- **DESIGN REQUIRED**

**Shorthand used in the table.**
- STATES = loading, empty, error and offline, in AR (RTL) and EN (LTR).
- GS = the §6 per-wave gate.
- STD = mock-extended REST plus a staging check, and a Pixel 8 walk in EN/AR × light/dark. The device is intermittent, so call adb by its full path and re-check at every WALK (`D:5676`, `D:2899`).
- NK = NOT KNOWN.

**Standing constraints and protocol** (restated from the owner brief in the lead task and from `D:4452`, `D:5301`).
- **No auto-advance.** Each wave runs START WAVE → IMPLEMENT → VALIDATE → REVIEW → owner decision → NEXT WAVE. Nothing advances without `NEXT`, `WALK` or `FORMULATE`.
- **Roles.** Opus plans, Sonnet executes, Fable audits at agreed checkpoints only (§6 proposes them).
- **Git.** No commit or push without an explicit owner request. Never force-push. `dev` stays frozen. `main` moves only by `--ff-only` on the owner's word.
- **Backup branch.** Preserve `backup/2026-08-22-dirty-tree`. `git log --all -- tell_claude.md` finds only its commit `e4006e7`, and the file is absent from the working tree (checked 2026-10-09).
- **Release scope.** Release 1 includes push, chat, the notifications inbox and the Message tab. Account deletion and banned-account handling are not deferred.
- **Purchase silence** (adr-049, D-015). There is no paywall, price, checkout or purchase hand-off. The only exception is the contract-verbatim `explanationSubscriptionRequired` copy.
- **Other owner rulings.**
  - Presigned storage PUTs never use the signed-in Dio client.
  - There is no camera permission or camera flow.
  - Chat is text-only.
  - Support attachments are JPEG/PNG/WebP per contract limits.
  - The app does not show the user's own leaderboard rank.
  - Referral reward copy awaits an owner ruling.
  - Deletion confirm copy awaits a Seif-approved safe variant.

## 1. Wave table

Execution order is not ID order. §3 gives the recommended order.

| Wave ID | Goal | Scope | Exact files/areas | Dependencies | Backend questions (topic) | Design dependencies | Owner decisions | Acceptance criteria | Tests | Device/server requirement | Store impact | Estimated risk | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CW00 | Recorded baseline, rulings, state, long-lead requests | Docs and state only. Record the settled rulings and model roles. Reconcile stale state. Allocate id ranges and the lock table. Send the Seif, designer, legal and client batches. Persist this roadmap. | `.ai/audits/current/wave_state.md` (stale at :90,:108,:1829, `D:5102`); `docs/DECISIONS.md` (next D-022); `docs/WAVE_STATUS.md` (`D:5101`); `docs/RISKS.md` (R-3 stale, next R-12); `docs/seif_fight.md` (S46); `CLAUDE.md` "849" floor (`D:2680`). No lib/, no contract/. | None | Send once: ratified ids (`D:5680`); prod host and reviewer login; retention and web-deletion URL; Q-B1..Q-B10, never filed (`D:5179,5687`) | Designer batch of every frame in §5c, each asked once (`D:5679`) | Push or hold 8e641e9 (docs-only, one commit ahead of origin/merged, LB). Fate of the untracked paths (four at 2026-10-09: the discovery report, `.ai/audits/current/completion/` and the two stale roadmap files; `D:4601-4603` listed three). WALK substrate, mock versus staging (not in the brief; confirm with the lead whether B-3(d) counts as settled). Whether Fable may write (`D:4496`). | `wave_state.md` shows roles, cadence and the §6 template; settled rulings recorded as D-022+; stale lines fixed; lock table and id counters written; Wave 03 walk listed as an RC gate; batches sent only on the owner's go | Guards alone, because docs are read by `android_identity_test` and `workflow_test` (`D:2742`) | None. A CI read needs an authorised push. | Starts the lead-time items for E-1, E-6, E-7, E-8, Firebase and Apple (§5e) | Low | READY INDEPENDENT WORK; OWNER DECISION REQUIRED (the three items in the Owner decisions column) |
| CW01 | Pin the contract at eddb6ac with integrity checks (T01) | Replace the 5 contract files with LF blobs from `git show eddb6ac:<f>`. Fix the false CRLF sentence in `SOURCE.md` (LB). Re-check upstream `ls-remote` at start and before commit. Run a BUILD dry run in a clone first (none exists at 3.46, `D:4560`). Update the mock's pin comment. Re-census. Add a pin-integrity check. Own commit, on the owner's request. | `contract/{openapi.yaml,contract-changelog.md,error-codes.md,realtime.md,SOURCE.md}`; `lib/dev/mock_backend.dart:19-20` (stale pin comment "f462968, v3.27.0-m1"); `test/guards/contract_models_test.dart`; fixture comments in catalog/profile/quiz fixtures; scribe-written `docs/seif_fight.md` and `docs/WAVE_STATUS.md` | CW00 | Stale "draft" prose at `C:e:16,61-67`; `C:o:1095` ("serves no Terms text") versus `C:o:819-820`; how contract moves are announced before RC | None | Authorise the contract commit (P-6, `D:5308`) | The 4 changed files are `git hash-object`-equal to upstream blobs with 0 CR; `info.version` is 3.46.0-m1; `SOURCE.md` names `eddb6ac`, the version and the correct EOL; census recorded (86/86/0/4, 82 app-buildable); no `lib/` behaviour change; commit on the owner's request only | `contract_models_test` 14/14 run alone; new pin-integrity test with a CR-injection mutation probe; full suite ≥2067/0/0 (`D:2661`); `git diff --quiet -- pubspec.lock` | `git ls-remote` (network); CI only after an authorised push | Enabler for every contract-backed P0. G-03 is re-checked at RC. | Medium: CRLF hazard (`D:2683`), upstream may move, the guard binds only part of the schemas (`D:4553`) | **DONE 2026-10-09, uncommitted (PASS WITH WARNINGS; `CW01_REPORT.md`)** |
| CW02 | Core API conformance: error and routing seam (T02) | Send `Accept: application/json` on every call. Apply the unknown-outcome rule (a non-2xx without a parsable body and `code` is handled like `internal_error`, `C:o:3883-3890`). Add a GoRouter `errorBuilder`. Add return-to-target. Add an `account_banned` screen on the `verifyOtp` path. Add a pending-deletion seam that asserts "no redirect yet" (target lands in CW05). Fix the stale comment at `error_interceptor.dart:9-10`. | `lib/core/network/dio_client.dart:19`; `interceptors/error_interceptor.dart:9-10,29-41`; `exceptions.dart:134`; `auth_interceptor.dart:70-72`; `auth_controller.dart`; `login_screen.dart:66-70`; `auth_error_copy.dart`; `app_router.dart:52,74-83,108-112`; `/home` landings (`otp_screen.dart:122`, `school_detail_screen.dart:362`, `university_detail_screen.dart:328`); mock `buildMockDio`; ARB ×2 and generated l10n ×3. Today there is no Accept header and no errorBuilder (re-grepped). | CW01 (G). Opens L-AUTH-ROUTER. | Signed-out contact channel for a banned student (shared with CW06); `Retry-After` format; refresh 4xx set (Q-B batch) | Banned-account frame and AR/EN copy; generic error-page frame | Where a banned student is routed for support (needs Seif) | Every request carries Accept; empty-body or 5xx/timeout responses take the unknown-outcome path; banned `verifyOtp` stores no tokens and does not retry the code; unknown route renders errorBuilder; return-to-target round-trips; the `invalidateSessionScope` count test is updated on purpose (`session_scope_discipline_test:182-190`); the "no redirect yet" seam is asserted at every local `account_pending_deletion` copy site (list under CW05); no personal data in logs | New Accept-header test (none exists, `D:4841`); extend `error_interceptor_test`, `auth_interceptor_test`, `app_router_test`, `login_logout_message_test`, `session_isolation_test`, `account_pending_deletion_test`; one assertion per local copy site | Mock plus a staging 4xx check; a banned account on staging is NK, so extend the mock | Prerequisite for UGC ban handling; the global seam for E-3 | High: first of the H-on-H K4 clique (`D:4920`) | READY INDEPENDENT WORK; DESIGN REQUIRED (banned frame and copy) |
| CW03 | iOS identity, 15.0, privacy manifest, E-4 (Env Wave 3, T19) | SOURCE-level only: ids `com.levelupworld.app` and `.stg` (RunnerTests included), deployment 15.0, display names, `CFBundleLocalizations` ar/en, `ITSAppUsesNonExemptEncryption`, new `PrivacyInfo.xcprivacy`. Replace the `device_info_plus` `model` path (R-11). Add an iOS identity text guard. Per-flavor schemes, Podfile and SwiftPM review wait for the Mac. | `ios/Runner.xcodeproj/project.pbxproj:349,371,387,404,419,475,526,550,572` (LB); `ios/Flutter/AppFrameworkInfo.plist:23-24`; `ios/Runner/Info.plist:7-8,15-16`; `lib/features/auth/repository/device_info_provider.dart`; `pubspec.yaml`; `docs/ENVIRONMENTS.md` §4.2; `workflow_test.dart:147-363`; `tool/verify_guards.ps1` | CW18a (H, order chosen, `D:5683`). Mac for BUILD. | None (client-only) | None (display name and icons already settled) | DR-02 fix shape (MethodChannel versus drop `model`); DR-06 orientation; DR-07 iPad; DR-26 name the Mac and Apple team | The guard pins ids, 15.0 and names; no invented `DEVELOPMENT_TEAM`; the manifest declares no false reason (`RISKS.md` R-11); the device-binding path uses no disk-space API. On the Mac: the archive Privacy Report is clean and the schemes build. | New iOS guard plus a `verify_guards.ps1` probe; device_info tests | Mac with Xcode 26 and an Apple developer team (NK); no iOS device known. SOURCE work is never reported as BUILD. | E-4 (P0), R-9, R-11; rubric 1b-d, 2b-c, 3a, 6f, 11 (iOS) | Medium-High: a malformed pbxproj cannot be detected without Xcode | READY INDEPENDENT WORK (ids, 15.0, names, localizations, guard); OWNER DECISION REQUIRED (DR-02 gates the model-path fix and the manifest contents); BLOCKED (BUILD: Mac and team) |
| CW04 | Legal viewer, Terms acceptance, settings entry (T10) | `getLegalDocument` (terms or privacy, ar or en, ETag/304, 404 `legal_document_unavailable`, `C:o:816-860`) rendered in-app and reachable signed-out. A Markdown renderer. The Terms step during registration and from settings, using `getTermsAcceptance` and `acceptTerms` (`C:o:1087,1116`). Replace the 3 `levelup.example` links on Login. Drop or re-source the Cookie link (no cookie document exists, `C:o:830`). A `terms_acceptance_required` handler for CW12 and CW13. | `lib/features/account_shells/screens/legal_document_screen.dart`; `app_router.dart:52,426-435`; `profile_screen.dart:287-306`; `login_screen.dart:43-48,122-124`; `school_detail_screen.dart:362`; `university_detail_screen.dart:328`; `otp_screen.dart:122`; registration controller; `pubspec.yaml`; mock; ARB; `project_rules_test.dart:127,139` | CW01 (G). K4: H with CW02, CW05, CW06, so serialise. CW15 shares registration files (M). | Who approved the r4 text and production parity; legal entity name (texts say only "Level Up", `D:2948`); public web URL for the consoles; `C:o:1095` versus `:819`; whether the server will enforce Terms beyond photos (`C:o:1122`) | Terms step placement and viewer states (I-10/I-21) | Whether the Terms step blocks (the contract says "recorded, not enforced", but served Terms §2 promises a prompt, `D:2951`). Markdown dependency (N-12). Parent-consent question. Confirm that rendering the server-served Terms §4 "Subscriptions" text is consistent with purchase silence (see Acceptance). | Signed-out reads of terms and privacy work in AR and EN; STATES, with 404 as "unavailable" and never an empty 200; a null `currentVersion` skips the step (`C:o:1091-1093`); `acceptTerms` sends `currentVersion`; no `.example` host left in `lib/` (grep); the served text renders as served. Staging Terms §4 "Subscriptions" (GET of the terms document, 2026-10-09, API level) names the two subscriptions in prose only, with no price, link or call to action. The purchase-silence scan therefore needs a content-level note for server-served legal text. | Repository, ETag and 404 tests; signed-out router test; registration-with-Terms test; ratchets (Text baseline 4, ARB parity); purchase-silence scan; new `contract_models_test` bindings with a mutation probe | Staging serves 4 documents, version r4-2026-10-07 (`D:2939`); production parity NK; STD | E-2 in-app half (P0); precondition for UGC and photos | Medium: registration flow, AR/RTL Markdown tables | READY INDEPENDENT WORK (viewer, repository, route, links); DESIGN REQUIRED (Terms step); OWNER DECISION REQUIRED (gate shape) |
| CW05 | Account deletion, cancel, pending-deletion state (T11) | `requestAccountDeletion` (`C:o:1267`) and `cancelAccountDeletion` (`C:o:1315`). Pending state from `GET /me` `pendingDeletion.effectiveAt`. Global `403 account_pending_deletion` goes to the cancel screen with no logout and no retry (`C:o:67-83`). Token purge after the 202 (a third sign-out path). The redirect target lands here (`D:5682`). Confirm copy only after Seif's safe variant, because the contract text says "paid" and "refund" (`C:o:1281-1288`). | New deletion feature; entry row in Settings or Profile (undecided). Code sites that match `isAccountPendingDeletion` (grep of `lib/`, 2026-10-09): definition `exceptions.dart:134`; `catalog_states.dart:95,139`; `flashcards_error_copy.dart:81`; `board_failure.dart:17,32`; `profile_error_copy.dart:22`; `quiz_error_copy.dart:30,52`. Comment-only references to the behaviour: `flashcard_study_screen.dart:39,193`; `mistakes_repository.dart:46-49`; `mistakes_overview_screen.dart:45-50`; `ai_explanation_panel.dart:128`; `explanation_state.dart:71`. Also `auth_controller.dart`; `app_router.dart`; `session_scope.dart`; prefer a new repository file (hotspot A15); `account_pending_deletion_test.dart`; mock; ARB. | CW02 (H, order chosen); CW04 (H); CW01 | Safe confirm-copy variant (Q-B2, never filed); web deletion URL (E-8); retention and erasure facts (E-7) | Request, confirm and cancel frames (missing, I-8/I-21) | Entry-point placement; final copy once Seif answers | On a 202 the session is revoked (`C:o:1276-1278`): the app purges the token pair and routes to login, because a retry with that token fails. Re-login during grace reaches the cancel screen from `GET /me` `pendingDeletion`. Only the contract's allowlisted calls work in grace (the draft read: `GET /me`, the two deletion calls and logout). Any other call answers `403 account_pending_deletion` and routes to the cancel screen with no logout and no retry. Cancel restores access. No verbatim "paid" or "refund" text unless Seif approves it. STATES. | Extend `account_pending_deletion_test`; `authRedirect` pure cases; the call count in `session_scope_discipline_test:182-190`; `pendingDeletion` fixtures; one test per code site listed under Exact files; purchase-silence scan | Staging: a deletion blocks that phone for the whole grace window (`C:o:1289`), so use disposable whitelisted numbers (`C:o:94-98`) | E-3 in-app half (P0). E-8 and E-7 are external. | High: auth state, effectively irreversible action, copy conflict, wide blast radius across screens | PREPARATION ONLY; DESIGN REQUIRED; BLOCKED (Seif copy variant) |
| CW06 | Lost-phone recovery and signed-out Support access (T12) | The 4-operation ladder (`C:o:462,507,547,590`). `confirmRecovery` returns `AuthenticatedResult` and joins the OTP sign-in path. `recovery_unavailable` (404, one code, `C:e:29`) goes to the support path. Banned arms on `verifyParentOtp` and `confirmRecovery` (`C:o:542,625`). Recovery PII providers get autoDispose or registry handling. Signed-out support: no public support operation exists (`D:5181`), so build only what Seif and the designer specify. | `login_screen.dart` (entry); `app_router.dart:52-57`; `otp_notifier.dart`; `auth_result.dart`; new recovery feature; `session_isolation_test`; `project_rules_test.dart:127,139`; mock; ARB | CW05 (H, serialise); CW02 (H per matrix `D:4891`; the plan adds a functional need for the banned screen); CW01 | Signed-out support channel; `recovery_unavailable` UX; ladder rate limits | Recovery ladder frames (none exist) | Support contact route; guardian wording for minors (DR-08) | The full ladder works on mock, then staging; PII is cleared on exit and never in logs or URLs; sign-in lands on `/home` or the return target; banned arms mapped; STATES | Ladder notifier tests; the pre-auth route list; PII disposal; bindings with a mutation probe | A recoverable staging account (seed NK) | Account-safety for minors; part of banned handling | Medium-High | PREPARATION ONLY; DESIGN REQUIRED; BLOCKED (support channel answer) |
| CW07 | Notifications inbox, bell, Message tab shell (T03) | `listMyNotifications` (`C:o:1148`, category filter), `getUnreadNotificationCount`, `markNotificationRead`. Wire the Home bell: `hasUnreadNotifications` is never passed today (`home_header.dart:23,36,79`). Replace the `/message` placeholder with a real shell hosting the inbox and a reserved conversations slot for CW10. Decode `kind` open-ended. Unknown kinds are ignored. The `moderation_warning` kind (additive enum value) shows the fixed EN/AR text from the operation description, in the UI language (`C:c:79-80`). | `home_header.dart:23-36,78-80`; `home_screen.dart`; `app_router.dart:311-318`; `lib/features/shell/screens/tab_placeholder.dart`; `main_shell.dart`; `settings_screen.dart:341-421` (4 inert toggles); new notifications feature; `session_scope.dart`; mock; ARB; `app_colors.dart`; harnesses `profile_harness` ×3, `catalog_harness`, `quiz_harness`, `settings_harness`; goldens `home_header_bell_*`, `nav_bar_*_tab3` | CW01 (G); CW05 (c: grace 403); first holder of L-MESSAGE-SLOT and L-HOME-HARNESS. H with CW10 and CW16a (harness overrides), CW07 first. | Copy for kinds without contract text (N-14); staging inbox seeds; preference storage (S28) | Inbox frames incl. AR and dark; kind copy; Message tab composition | Where the inbox lives, tab or bell or both (unsettled since 2026-09-24, `D:5265`); disposition of the 4 inert toggles | Unread count equals the server; mark-read is idempotent; the bell and tab open the inbox; `moderation_warning` renders its fixed text; STATES; no Home autoDispose teardown failure (hold helper) | `home_header_unread_test`, `home_screen_test`, `main_shell_test`, settings tests, harness hold helper, regenerated goldens, session discipline, bindings | STD | Closes E-5, the placeholder tab (P1); the push tap fallback target | Medium: golden churn, harness trap (`D:4728`) | READY INDEPENDENT WORK (data layer, bell, shell); DESIGN REQUIRED; OWNER DECISION REQUIRED (placement) |
| CW08a | Push, Dart side (T04, no SDK) | A push gateway interface with a Firebase-free mock entry. `PUT /me/fcm-token` after sign-in and on every refresh (`C:o:1064`, `C:r:108`). A tap-routing resolver for the 4 kinds, with unknown going to the notifications screen (`C:r:106`). Foreground policy. Android 13+ permission UX. Clearing the token at sign-out waits for Seif's answer. | New push module; `bootstrap.dart:10-31`; `app.dart` (auth listener); `app_router.dart` tap targets; `main_{dev,staging,prod,mock}.dart`; session scope; ARB | CW02 (G, `D:4933`); CW07 (target); CW05 (c); soft on CW09, CW10, CW12 | Does logout clear the token (the contract is silent, `D:3057`)? Staging push delivery switch-on (`C:r:80`) | Permission pre-prompt frame (I-16/I-21) | Prompt timing (N-13); the D-021 Q7 "no deep links in release 1" note versus tap routing | The token is registered once per sign-in and refresh; the resolver covers 4 kinds plus the unknown fallback; no message text, name or token in logs; the `main_mock` entry stays Firebase-free | Resolver and token-lifecycle tests with a fake gateway; a `main_mock` Firebase-free test | Fake gateway only. Real delivery cannot be proved while it is off everywhere (`C:r:80`). | Rubric 8a once the decision is recorded | Medium | READY INDEPENDENT WORK (resolver, register and refresh); DESIGN REQUIRED (pre-prompt); BLOCKED (sign-out token semantics) |
| CW08b | Push, platform legs (T04 + Env) | `firebase_core` and `firebase_messaging`, the google-services plugin, per-flavor `google-services.json`, `POST_NOTIFICATIONS`, native localized strings for the 8 `push_*` keys (EN and AR text is in `C:r:83-104`, rendered from native resources). iOS: Push capability, entitlement, APNs, `GoogleService-Info.plist`, `ar.lproj`, Privacy Report review. | `pubspec.yaml/lock`; `android/settings.gradle.kts:20-24`; `android/app/build.gradle.kts`; `android/app/src/{prod,staging}/google-services.json`; `AndroidManifest.xml`; new `res/values*/strings.xml`; `android_identity_test.dart:203-240`; `workflow_test.dart:109-145`; `ios/**`; `docs/ENVIRONMENTS.md` §7 (`:340-360`) | CW18a (H, order chosen); CW03 (H, order chosen: CW03 first, `D:5016,5027`); CW08a; L-BOOT-BUILD and L-IOS | Firebase and APNs ownership; delivery on staging | None | Firebase ownership and project sharing (DR-18); crash visibility (DR-12); the data-collection trade-off of ending the "zero SDKs" posture (N-12); explicit authorisation before any console registration. Optionally split the wave into Android and iOS legs so the Android leg can run before CW03; this is not done here. | Per-flavor files match their own package (the guard stops being vacuous); the 8 strings exist in EN and AR; `aapt2` shows `POST_NOTIFICATIONS` and no unexpected permission; the iOS Privacy Report is clean | `android_identity_test` Firebase group; `verify_guards.ps1` probe 8 (`D:4843`); `aapt2` on a fresh flavor APK | Firebase projects (NK); an Apple team with an APNs key (NK); delivery on staging (Seif) | Push prerequisites (conditional P0, now required); Data Safety and App Privacy rows | High: external accounts, privacy, minors | PREPARATION ONLY (native string files); BLOCKED (Firebase, Apple, Mac); OWNER DECISION REQUIRED |
| CW09 | Friends, block, report, blocked list (T05) | The 12 friend-graph operations (`C:o:2987-3346`) and `reportStudent` (`C:o:3667`). A real `/friends` screen plus an entry point. Unfriend and the blocked list. Leaderboard rows already hide blocked students both ways. | Replaces `account_shells/screens/friends_screen.dart` (`app_router.dart:423`); entry row in Profile (`profile_screen.dart:229-325`) or Settings (undecided); `leaderboard_row.dart:99` and `podium.dart:154` only if H-1 is approved; `shell_screens_test.dart:23-30,90-100`; new feature; mock (12 ops); ARB; bindings | CW01 (G); CW04 (c: Terms before UGC, `D:3065`) | Staging seeds for friend states; text and name moderation and report SLA (unknown, `D:3005`) | Decline, my friends, blocked list, report sheet (I-21/I-22) | Entry point (S36 ask 2, open); leaderboard report/block (DR-04/H-1); minors and phone lookup (DR-08) | All 12 operations pass through the real seam; every error code maps (`friend_target_unavailable`, `already_friends`, ...); block is mutual; report confirmed; STATES; no phone number or name in logs | Shells test; bindings (Friend, FriendRequest, StudentCard, PhoneLookupResult) with mutation probes; leaderboard tests | STD with seeded states (NK) | UGC controls: block, report, contact | High: minors, UGC, phone lookup | PREPARATION ONLY; DESIGN REQUIRED; OWNER DECISION REQUIRED |
| CW10 | Text chat, SignalR hub, reconnect, REST backfill (T06) | The 7 chat REST operations in `C:o:3370-3630`: `listConversations`, `listConversationMessages`, `sendChatMessage`, `editChatMessage`, `deleteChatMessage`, `markConversationRead` and `reportChatMessage`. (`reportStudent`, `C:o:3667`, is in CW09. Discovery `D:5265` counts 8 chat operations. This grep finds 7 in range plus `reportStudent`; the discovery's eighth is not identified there.) Also `/hubs/chat`: WebSockets only, `skipNegotiation: true` (`C:r:24`); access token via the client option; at most 3 connections (`C:r:33`); reconnect then backfill; `clientMessageId`; `conversationRemoved`; text only. | `/message/:conversationId` route and the `/message` slot; `main_shell.dart` (badge); `pubspec.yaml` (SignalR client; direct `uuid`); hub provider tied to auth and `session_scope.dart`; fake hub in `main_mock.dart`; `rules.dart:577` retry-guard gap for StreamProvider; 10 nav goldens | CW09 (G); CW07 (H, slot, CW07 first); CW16a (H, harness overrides, CW10 first); CW01; CW04 (c) | Staging chat seeds and hub verification; token-expiry behaviour on the hub | Chat list, conversation, report and block, empty and error states (I-21/I-22) | SignalR package (N-12); FLAG_SECURE on forwarded cards (AF6, `D:4416`); badge placement | Two accounts exchange messages in real time; reconnect backfills with no duplicates; the hub aborts on sign-out or supersede; edit and delete windows map to their 409 codes; STATES; no message text in logs or push | Fake-hub helper; notifier tests; retry-guard fix; session discipline; `main_shell_test`; goldens regenerated; bindings | A mock cannot fake a WebSocket (`D:5055`). Needs staging with two accounts (seeds NK). | UGC chat; Data Safety and privacy rows | High | PREPARATION ONLY (REST layer, fake hub, SignalR spike); DESIGN REQUIRED; BLOCKED (staging hub verification) |
| CW11 | Forwarded questions and friend streaks (T07) | `forwardQuestion` (`C:o:3699`), `answerForwardedQuestion` (`C:o:3766`), `listMyFriendStreaks` (`C:o:3825`); the `forwardedQuestion` chat card; hub events `forwardedQuestionAnswered` and `friendStreakChanged`. Points are displayed from the server only. | `quiz_review_screen.dart`, `quiz_screen.dart`, `quiz_result_screen.dart`, `quiz_repository.dart` (L-QUIZ-REVIEW); chat models from CW10; `quiz_harness`, `quiz_fixtures` | CW10 (G, T05→T06→T07); CW16a (H, order chosen: CW16a first, `D:5014`) | Seeds for cards and streaks; the same question held by two friends (`C:c:14-18`) | Forward-action placement on the question and review UI; card; streak display | Placement | Cards render in-conversation; one answer per card; 409 shows the per-sender message; points come from the server only | Quiz review tests; `blocOutsideQuiz` guard; bindings | Staging with two accounts | UGC coverage | Medium | DESIGN REQUIRED; BLOCKED (CW10) |
| CW12 | Support tickets and photo attachments (T08) | Tickets (`C:o:2658,2705,2740,2801`). Photos: `createSupportAttachmentUpload` (`C:o:2849`, ≤7,000,000 bytes, SHA-256), a PUT to the presigned URL through an isolated plain client with no bearer token, sending exactly the headers in `upload.headers` before `upload.expiresAt` (at most 15 minutes, `C:o:2852-2856`), `completeSupportAttachment` (`:2900`), content fetch (`:2946`, 410 gone). JPEG/PNG/WebP, 3 per message, 10 per ticket. System photo picker, no camera. Terms 403 sends the user to the Terms screen or to a no-photo send (`C:e:67`). Moderation copy "can't be sent" (`C:e:16`). | `customer_support_screen.dart` (`app_router.dart:416-419`, `profile_screen.dart:276-284`); `account_shells/widgets/shell_body.dart`; `shell_screens_test.dart:32-35`; a picker and upload helper built once and shared with CW13; `pubspec.yaml`; `Info.plist` only if the picker needs it; mock; ARB | CW01; CW04 (G for photos; text tickets are never gated, `C:e:67`) | Ticket status labels; staging ticket seeds; storage egress host; stale "draft" prose | Tickets list, detail, new, attach, status labels (I-20/I-21) | Picker dependency (N-12) | Text tickets create, list and reply. The photo flow runs end to end. The presigned PUT carries no Authorization header (asserted) and sends the signed headers verbatim. An expired URL is handled by starting a new upload (plan choice, to confirm with Seif). A hash mismatch and each 422 or 403 code map to copy. Limits are enforced, with the server authoritative. Nothing from the image is logged. STATES | Upload-helper test with a fake Dio; SHA-256 test; `deadControls` update; bindings | Seif's changelog records a staging proof on 2026-10-08 (`C:c:15`; CONTRACT/DOC level, not reproduced by us). The first increment is a cheap unauthenticated 401-versus-404 probe. A real photo on the device. | UGC contact channel (required); Data Safety (photos) | Medium-High: photos of minors | READY INDEPENDENT WORK (text tickets, helper); DESIGN REQUIRED; photo leg after CW04 |
| CW13 | Custom avatar (T09) | `PUT /me/avatar` multipart `image` (≤2 MiB, 128–4,096 px, not animated, `C:o:982`), `DELETE /me/avatar` (idempotent 204, `C:o:1042-1047`). Error codes `image_too_large`, `image_content_invalid`, `image_rejected_by_moderation` ("can't be used"). Terms gate. A replaced avatar can stay cached up to 1 hour (`C:c:7-18`). | `avatar_sheets.dart:196-207`; `edit_profile_screen.dart`; `avatar_disc.dart`; `board_avatar.dart`; a new repository file; the CW12 helper; `app_colors_test.dart` avatar group; mock; `profile_fixtures` (about 22 importers) | CW04 (G); CW12 helper; CW01 | `avatarId` 400 versus 404 (S45) | Crop, remove, rejected frames (I-21) | Whether client crop is in scope (design-driven) | Upload updates the avatar everywhere; remove is idempotent; each code maps; offline handled; STATES | `edit_profile_screen_test` (62), `mock_backend_profile_test`, size tests | Staging; a real photo | Data Safety (photos); minors | Medium | DESIGN REQUIRED; starts after CW04 closes (G edge) |
| CW14 | Track transfer (T13) | `transferToUniversity` (`C:o:1338`): once only, `secondary3` students only (`C:o:1353`). `track_transfer_not_eligible` 403 hides or disables the control and explains it opens in the final school year (`C:e:60`). `track_transfer_not_allowed` 409 (already University or already transferred, `C:e:59`) means re-read `GET /me`, render University and never offer the transfer again. Enable the Go-to-Uni confirm. Partial invalidation after success. | `profile_screen.dart:311,339-353`; registration pickers; mock `_track` (`mock_backend.dart:78`, used at `:182,:210`); session invalidation next to `invalidateSessionScope` | CW01; CW10 (M: `conversationRemoved`) | Eligibility signal; what happens to friendships and conversations | Confirm frame; university pickers | Show only to `secondary3` versus show and handle the 403 (N-09) | Transfer happens once; confirm is explicit; me, entitlements, catalog, mistakes and leaderboard refresh; both 403 and 409 handled; STATES | `profile_screen_test`; mock track; refresh tests | A disposable School `secondary3` account (NK) | None | Medium: irreversible | DESIGN REQUIRED; OWNER DECISION REQUIRED |
| CW15 | Referral and sign-up `inviteCode` (T14) | `getMyInvite` (`C:o:1434`) feeds the Refer screen. The optional `inviteCode` and `inviteCodeApplied` on registration (`C:o:390`). The reward copy is unresolved: the contract gives +10 to the inviter only, Figma says 500 to both. | `refer_a_friend_screen.dart` (`app_router.dart:415`, `profile_screen.dart:260-272`); `registration_draft.dart:17,41`; `school_registration.dart:96`; `university_registration.dart:78`; `registration_controller.dart:38`; `registration_submit_notifier.dart`; `auth_result.dart`; about 8 generated files; share dependency in `pubspec.yaml` | CW01; CW04 (M, shared registration files; serialise by plan choice) | University `inviteCode` wording (`C:o:4182`; default: do not send) | Redraw (I-18) | Reward copy ruling (pending); share mechanism | Code shown and shareable; `inviteCode` sent only when entered; a bad code never blocks registration; no unapproved reward copy | Registration tests; build_runner drift in a worktree; bindings | Staging registration consumes whitelisted numbers | None | Medium | DESIGN REQUIRED; OWNER DECISION REQUIRED |
| CW16a | Quiz history, favourites, review from history (T15) | `listQuizHistory` (`C:o:1877`), `getQuizReview` (`:1912`), favourites (`:2106,2131`), `mode: favorites` (`:1850`), Continue Learning. | `quiz_repository.dart`; `quiz_review_screen.dart`; `quiz_result_screen.dart`; `quiz_setup_screen.dart`; `quiz_mode.dart:23-27`; `app_router.dart:345-386`; `profile_screen.dart:236-259`; `coming_soon_section.dart:76-81`; mock | CW01; CW07 and CW10 (H, harness overrides A12, K3 `D:5026`; they go first); CW11 (H, L-QUIZ-REVIEW, CW16a goes first) | S2 resume (open); S43 replay; S40 | History and favourites list frames (I-21) | Favourites quiz mode in release 1 (DR-19) | History lists and reviews a finished quiz; favourites add, remove and list; STATES | `quiz_models_test`, `mock_backend_quiz_test`, `quiz_harness`; bindings | STD | None | Medium | DESIGN REQUIRED |
| CW16b | Module picker and solved-questions summary (T16, T17) | `listModules` (`C:o:1685`, university only; "All subjects" stays), `getMyQuizSummary` (`:1731`). The user's own leaderboard rank is excluded by the owner ruling. | `catalog_repository.dart`; `subjects_notifier.dart`; `leaderboard_repository.dart`; `profile_screen.dart:38-45`; `settings_screen.dart:272-330`; `top_student_section.dart`; mock | CW01 (M-only lane) | Not S25: own rank is out of scope by ruling (S25 stays open for the record) | Module picker; third summary card (the Rank option is excluded by the no-own-rank ruling; Badges or none remains a design and owner question, `D:4426`) | N-17: filling the Solved Questions card from `getMyQuizSummary` reopens the standing "Points only" ruling #101. N-18 (D-008, no self-rank) stays closed by the owner ruling. Both are flagged in `D:3983-3984,4173-4176,4212,4215`. | Summary values come from the server; the picker works; no own rank shown | `leaderboard_screen_test`; `subjects_screen_test`; bindings | STD | None | Low-Medium | DESIGN REQUIRED; OWNER DECISION REQUIRED (N-17). **Modules half BUILT 2026-10-14** (wave SEIF1014 Job 3: provisional pill row on Subjects, no frame, DESIGN_ISSUES #134; AVD-checked against staging as U1; uncommitted). The Solved Questions half (`getMyQuizSummary`, N-17) is not started |
| CW17 | Missing design states and integration polish | Fill the STATES gaps on all new surfaces. `session_superseded` screen (N-10). BUG-017 wording. BUG-020 remainder. Text-scale pass. Final Message tab composition. | `KNOWN_BUGS.md:570-590,676`; `docs/RESPONSIVE.md`; new-surface screens; goldens | All feature waves it polishes | Min-version signal (DR-17) | Remaining frames | DR-06/07/09/10/15/16/29 | No new surface lacks a state; the parked wave items are ruled or recorded | Screen-state tests; goldens | Pixel 8 | None | Medium | DESIGN REQUIRED; OWNER DECISION REQUIRED |
| CW18a | Env Wave 2: flavor boot assertion and fail-closed config (T18) | Flavor-to-platform boot assertion. `main_mock` refuses to run in release. A visible `isDev` indicator. A build failure for a prod flavor with a `.example` host (`ENVIRONMENTS.md:301,313`). The prod URL stays a placeholder until `servers:` announces it. No `/redeem` slot (withdrawn, `env_chapter_state.md:89-92`). Consequence of the build failure: it hits every `--flavor prod` release build. That includes the main-only release compile gate (`ci.yml:318-330`, build line `:380`) while `_baseUrlFor(prod)` is `https://TBD.example/api/v1` (`app_config.dart:54`). The gate goes red on the first `--ff-only` promotion to `main` until E-1 (CW18b) supplies a real host. | `app_config.dart:51-55`; `bootstrap.dart`; `main_{dev,staging,prod,mock}.dart`; `app.dart`; `android/app/build.gradle.kts`; `android_identity_test.dart`; `verify_guards.ps1`; `ENVIRONMENTS.md` (§4.3 and table `:311-315`); `.github/workflows/ci.yml:318-413` | None (needs no pin, `D:4441`) | None | None | Where the `.example` build failure runs. Options: (a) only in an RC or release job, not the main compile gate; (b) land it together with the production host in CW18b; (c) accept a red gate. | A mismatched flavor fails at boot; a prod release with a `.example` host fails the build in the job chosen by the owner; a release run of `main_mock` is refused; the choice is recorded in `DECISIONS.md` | New boot and refusal tests; `android_identity_test`; verify_guards probe | Android build | Rubric 2d/2e | Medium: the build failure interacts with the CI gate and with CW19 prod builds | READY INDEPENDENT WORK (boot assertion, mock refusal, isDev); OWNER DECISION REQUIRED (placement of the `.example` build failure) |
| CW18b | Production host, signing, flavored AAB, CI release gate (T18, T20) | Swap in the production host once `servers:` carries it. Signing config fed by an owner-held keystore (fail-closed, `build.gradle.kts:81-100`). Play App Signing. A flavored AAB, 16 KB check and `aapt2` inspection. A CI AAB job and the release gate. The stale AAB with the dropped id is do-not-upload (`D:2970`). Version and description. | `android/app/build.gradle.kts:70-100`; `key.properties.example`; `RELEASE_SIGNING.md`; `ci.yml:318-413`; `tool/verify_release_manifest.ps1`; `pubspec.yaml` (`version: 1.0.0+1`, description) | CW18a (and its `.example` placement decision); Seif host; owner keystore | Production host in `servers:` (E-1); reviewer login (E-6) | None | Keystore custody; crash visibility (DR-12), obfuscation (DR-13), AAB-only (DR-20) | A signed flavored AAB with the right package, 16 KB aligned; no `.example` host in the artifact; the CI gate stays green under the CW18a decision | `workflow_test`; verify_guards probes 9-11 | Production host (NK); keystore (owner) | E-1 and AND-02 (P0); rubric 3b-d, 4c | High | BLOCKED; OWNER DECISION REQUIRED; PREPARATION ONLY (CI job, docs) |
| CW19 | Android and iOS build and release validation, device walks (Env Wave 4) | Prod and staging flavor builds on both platforms. Physical-device staging walk (the 2026-10-06 release walk was an AVD, `D:2910`). Prod identity installed side by side. Extended smoke harness. Wave 03 School registration walk on the Pixel 8 (mock, then staging), including the Terms step and `inviteCode` (`D:5689`). `main` promotion, then the first flavored CI release gate. | Walks, harnesses, `tool/smoke/real_api_smoke_test.dart` (about 22 operations today, `D:2780`) | All feature waves; CW03; CW18b. A prod build needs the production host, or the CW18a option that tolerates `.example`. | Production host; push on staging | None | Whether the iOS build is a hard gate (`D:2878`) | The `D:5689` walk passes; both identities run; the smoke run covers the new operations; guard probes N/N | Full GS plus smoke | Pixel 8; Mac; production host | Rubric 4d, 10d, 9b-c | High | BLOCKED |
| CW20 | Store compliance closure and release candidate (T21) | Data Safety and App Privacy matching what ships; content rating and audience (minors); listing assets; support URL and email; reviewer notes and login (E-6); public privacy URL and entity name (E-2 second half); web deletion URL (E-8); retention facts (E-7); RC tag; `--ff-only` promotion on the owner's word; Fable RC hand-off. Claude drafts text only. | `docs/STORE_*`; `store_submission_checklist`; privacy manifest | CW04, CW05, CW08, CW12, CW13, CW03, CW18b (G, `D:4937`); CW19 | E-6, E-7, E-8, support URL | Listing assets | Accounts (DC-20); age floor and minors memo (DR-08); data-protection basis (DR-27) | All §7 P0 rows closed or consciously accepted. The Wave 03 School-registration walk (`D:5689`, run in CW19) has passed and its evidence is attached; the RC cannot close without it. | Release checklist | Store accounts (owner) | All | High | BLOCKED; OWNER DECISION REQUIRED |

**Splits and merges (one line each).**
- CW08 splits into a (Dart seam, no SDK) and b (platform legs). a needs no Firebase project, b is externally blocked.
- CW16 splits into a (history, favourites, review) and b (modules, summary). a has H edges to CW07, CW10, CW11 and the harnesses, while b is M-only (`D:4426-4427`).
- CW18 splits into a (Env Wave 2) and b (host, signing, AAB). a needs no pin and no external input, while b needs Seif and the keystore.
- Banned-account handling is split. CW02 lands the screen and the `verifyOtp` path, CW06 the recovery arms and signed-out support, and CW05 only checks that all four operations are mapped.

## 2. Dependency graph

Legend:
- `==>` is a hard ordering (G).
- `~~>` is serialise-only (H), with the order chosen by this plan and reversible.
- `..>` is a compliance ordering chosen by this plan (c), which is not technical.

```
CW00 ==> CW01 ==> (CW02 .. CW16b)                            [T01 -> T02..T17]
CW01 ==> CW02 ==> CW08a                                      [T02 -> T04]
K4 clique (L-AUTH-ROUTER): CW02 ~~> CW04 ~~> CW05 ~~> CW06   [all 6 pairs H, D:5025]
CW04 ==> CW12(photos), CW13                                  [T10 -> T08/T09, D:4935]
CW04 ..> CW09, CW10        (Terms before UGC)
CW04 -- CW15               (M, shared registration files; CW04 first by plan choice)
CW05 ..> CW07, CW08a       (grace 403 on every authenticated call)
CW09 ==> CW10 ==> CW11                                       [T05 -> T06 -> T07]
CW07 ~~> CW10              (L-MESSAGE-SLOT; CW07 holds first)
K3 {CW07, CW10, CW16a}: CW07 ~~> CW10 ~~> CW16a              [T03/T06 - T15 are H, D:5026]
CW07 ~~> CW16a             (H, harness overrides)
CW16a ~~> CW11             (T07-T15 is H; order chosen)
CW18a ~~> CW03 ~~> CW08b   [T18 -> T19 -> T04 order, D:5027; the arrows are H, D:5683]
CW03, CW04, CW05, CW08, CW12, CW13, CW18b ==> CW20           [D:4937]
All feature waves, CW03, CW18b ==> CW19 ==> CW20
External chains: Seif host --> CW18b ; Mac + Apple team --> CW03 BUILD, CW19 ;
                 Firebase + APNs --> CW08b ; keystore --> CW18b
Plan-added interaction: CW18a .example failure <-> CI main gate <-> CW18b host (owner decision)
```

## 3. Critical path

Recommended serial order:
CW00, CW01, CW02, CW18a, CW04, CW05, CW06, CW07, CW09, CW10, CW12, CW13, CW08a, CW16a, CW11, CW16b, CW14, CW15, CW03, CW08b, CW17, CW18b, CW19, CW20.

- CW16a precedes CW11 (L-QUIZ-REVIEW, `D:5014`). CW03 precedes CW08b (L-IOS, `D:5016,5027`).
- CW03's SOURCE leg only needs CW18a and the DR-02 ruling, so it can be pulled forward as the non-screen wave beside any screen wave. Its BUILD leg waits for the Mac.
- If the owner wants Android push before iOS identity, split CW08b into Android and iOS legs first. That needs an owner call and is not done here.
- The protocol allows at most one screen wave plus one non-screen wave at a time (`D:4452`, `D:5301`). Externally gated waves slot in when their inputs arrive.

| Step | Wave | Gate | Owner of the gate | Exit evidence |
|---|---|---|---|---|
| 1 | CW00 | Rulings recorded; batches sent | Product owner | `wave_state.md` and `DECISIONS.md` entries; batches sent |
| 2 | CW01 | Authorisation for the contract commit; Fable pin audit (`D:4506-4511`) | Owner, Fable | Hash-equal blobs, 0 CR, guard 14/14, suite ≥2067 |
| 3 | CW02, then CW18a as the non-screen companion | Banned frame and copy. CW18a needs the `.example` placement decision. | Designer, owner, Fable T02 audit | Seam tests green; the call-count test updated deliberately; boot and refusal tests |
| 4 | CW04, CW05, CW06 (serial) | Terms placement; Seif's safe deletion copy; signed-out support answer; frames | Designer, Seif, owner | Per-wave GS; Fable on each (`D:4514`) |
| 5 | CW07, CW09, CW10 | Message tab and inbox placement; frames; staging seeds and hub verification | Owner, designer, Seif | STD walks; the fake-hub tests green |
| 6 | CW12, CW13 | CW04 closed; frames; picker dependency | Owner | Photo flow tests; DEVICE walk |
| 7 | CW08a | Sign-out token answer; pre-prompt frame | Seif, designer | Resolver and token-lifecycle tests with a fake gateway |
| 8 | CW16a, CW11, CW16b, CW14, CW15 | Frames; referral and transfer rulings; N-17 | Designer, owner | GS per wave |
| 9 | CW03, then CW08b | Mac and Apple team for BUILD; DR-02; Firebase project and APNs; delivery on staging | Owner, Seif | iOS guard; Privacy Report; `aapt2` and guard evidence; delivery proof needs staging on |
| 10 | CW17 | Remaining frames and rulings | Designer, owner | Screen-state tests, goldens |
| 11 | CW18b | Seif's production host; owner keystore | Seif, owner | Signed flavored AAB; `aapt2` |
| 12 | CW19 | All of the above | Release manager | Physical-device staging walk; Wave 03 walk; smoke; `main` promotion; first flavored CI release gate |
| 13 | CW20 | Accounts; legal; reviewer login | Owner, Seif, legal | Forms filed by the owner; RC tagged |

Everything marked "Seif", "designer", "Firebase", "Apple" or "keystore" is a lead-time item. Request it in CW00 so it does not land last.

## 4. Parallel-safe lanes and locks

**Lanes.** The owner-gated protocol allows one screen wave and one non-screen wave at a time. Lanes show what may overlap if the owner opens two waves.
- **Lane A (serial K4):** CW02, CW04, CW05, CW06.
- **Lane B (messaging and quiz review):** CW07, CW09, CW10, CW16a, CW11, with CW08a beside it. CW16a sits here because it has three H edges into this lane (CW07, CW10, CW11).
- **Lane C (env and release):** CW18a, CW03, CW08b, CW18b.
- **Lane D (profile and learning, M-only edges):** CW16b, CW14, CW15.
- **Branches off lane A after CW04:** CW12 and CW13, sharing one picker helper.

Lane-width confidence is LOW. The discovery's rendered matrix and its scratch render disagree about lane C's independence.
- The rendered rows show T08 and T09 against T19 as M and against T18 and T20 as `.` (`D:4897-4898`).
- The appendix reports M for T08 and T09 against T18 and T20 in the scratch render (`D:5674`).
- So this plan does not assert that lane C shares no code with lanes A, B and D. It treats the T04 edges (CW08b) and the conditional `Info.plist` edge to T19 as the known links.

**Locks** (enforced by process only, because no hook or branch protection is active, `D:5004`).

| Lock | Files | Rule |
|---|---|---|
| L-CONTRACT | `contract/**`, mock pin comment, `contract_models_test` bindings | CW01 only. Everything else waits for its commit. Never `git add -A` while `contract/*` is dirty. |
| L-AUTH-ROUTER | `authRedirect`, `_authRoutes`, `GoRouter(` args, the `/home` landings, `auth_controller`, `error_interceptor`, `exceptions`, `session_scope_discipline_test:182-190` | CW02, then CW04, CW05, CW06 one at a time. CW08a consumes it. |
| L-MESSAGE-SLOT / L-HOME-HARNESS | `/message` builder, `tab_placeholder.dart`, `main_shell.dart`, 10 nav goldens, 6 harness override anchors, `holdBoards`/`holdProfile` | CW07 first, then CW10 and CW16a. The first wave adds one shared hold helper, later waves add one line. |
| L-QUIZ-REVIEW | `quiz_review_screen`, `quiz_screen`, `quiz_repository`, `quiz_harness` | CW16a, then CW11. |
| L-BOOT-BUILD / L-IOS | `bootstrap.dart`, `main_*`, `app.dart`, `app_config.dart`, gradle, `android_identity_test`, `ENVIRONMENTS.md`, `ios/**` | CW18a, then CW03, then CW08b. |
| L-SHELLS-PROFILE | `shell_screens_test.dart`, `account_shells/*`, the `profile_screen.dart` menu | Adjacent map entries conflict (`/support` versus `/friends`). Order CW15, CW12, CW09, CW04 by map position, or serialise. |
| L-TOKENS | `app_colors.dart` (6 places per token), `app_colors_test.dart`, `app_elevation*.dart` | Each wave adds its own mid-file group. |
| L-REGISTRY | `session_scope.dart` and its exemption map | Short critical sections. Each wave uses its own comment-headed block, and exemptions go at the head, not the tail. |
| L-GENERATED | l10n ×3, `*.freezed`/`*.g` ×42, `pubspec.lock`, goldens ×43 | Regenerate, never hand-merge. |
| L-LOGS | Doc logs and id counters | One scribe. Next free ids: DESIGN_ISSUES #127, seif_fight S46, KNOWN_BUGS BUG-026, DECISIONS D-022, RISKS R-12 (`D:4662-4674`). Re-read the counters at CW00 and pre-allocate ranges. |

**Rules for every wave** (`D:4469-4476`):
- Insert beside your own siblings, never at the tail. This removed 5 of 5 retested conflicts (`D:4791`).
- Do not grow `ProfileRepository`. Prefer new files.
- Take a `git status` fingerprint before and after, announce the file list, and check `ListAgents`.
- The ARB files, mock if-chain, router, session scope and pubspec are the universal hotspots.

## 5. Lists

**5a. Implementable now, with no external answer.**
- CW00 (its three owner decisions still apply), CW01 and the placement-independent part of CW18a (boot assertion, mock refusal, isDev).
- CW02, except the banned frame and copy.
- The CW04 viewer, repository, signed-out route and link replacement.
- The CW07 data layer, bell and tab shell.
- The CW08a resolver and the register and refresh token lifecycle. Clearing the token at sign-out waits for Seif.
- The native push strings of CW08b.
- The CW12 text tickets. The CW12 photo helper and all CW13 work start only after CW04, because CW04 ==> CW12 (photos) and CW13 is a G edge.
- The CW03 SOURCE edits for ids, 15.0, display names, localizations and the guard. The `device_info_plus` model-path fix and the manifest contents wait for DR-02.
- The non-visual layer of every contract-backed wave: repositories, bindings, mock extension and tests. Build it as the first increment of each wave, not as a separate wave. Waves with a G gate on CW04 (CW12 photos, CW13) follow that gate.

**5b. Waiting for Seif (topic to waves).**

| Topic | Waves |
|---|---|
| Production host in `servers:` (E-1) | CW18b, CW19 |
| Reviewer login (E-6) | CW20, CW19 |
| Retention and erasure facts (E-7); web deletion URL (E-8) | CW05, CW20 |
| Safe deletion confirm copy (Q-B2) | CW05 |
| Signed-out support channel | CW02, CW06 |
| FCM token at sign-out; push delivery on staging | CW08a, CW08b, CW19 |
| Staging seeds: friends, chat, tickets, notifications, banned and recoverable accounts | CW02, CW06, CW07, CW09, CW10, CW11, CW12 |
| Legal text approval; entity name; Terms enforcement; `C:o:1095` prose | CW04 |
| Stale "draft" prose (`C:e:16,61-67`); University `inviteCode` wording; `avatarId` 400/404 | CW01, CW12, CW13, CW15 |
| Resume quiz (S2), replay (S43), `createQuiz` precedence (S40) | CW16a |
| Min-version signal (DR-17) | CW17 |

**5c. Waiting for the designer.**
- Banned-account frame: CW02.
- Terms step and legal viewer states: CW04.
- Deletion request, confirm and cancel: CW05.
- Recovery ladder: CW06.
- Inbox frames, kind copy and tab composition: CW07.
- Push permission pre-prompt: CW08a.
- Friends (decline, my friends, blocked list, report): CW09.
- Chat: CW10.
- Forward action and card: CW11.
- Tickets: CW12.
- Avatar crop, remove and rejected: CW13.
- Track-transfer confirm: CW14.
- Referral redraw: CW15.
- History, favourites and module-picker lists, and the third summary card: CW16a and CW16b.
- `session_superseded` screen and remaining states: CW17.
- Listing assets: CW20.

**5d. Owner, client and legal.**
- Record rulings and decide repo-truth items: CW00.
- The decisions listed in the table's Owner decisions column.
- The `.example` build-failure placement: CW18a.
- N-17 (reopening "Points only", #101): CW16b.
- The listing set: accounts, age rating, target audience, data-protection basis, minors memo, entity name, privacy URL: CW20.
- Keystore custody: CW18b.
- BUG-017 wording: CW17. **Done 2026-10-15** (SEIF1014 second follow-up): the owner dropped both Rank help lines.

**5e. External prerequisites (to waves).**
- **Mac with Xcode 26 (NK):** CW03 BUILD, CW08b iOS leg, CW19 iOS.
- **Apple Developer team and APNs key (NK):** CW03, CW08b, CW20.
- **Firebase project and ownership (NK):** CW08b.
- **Play Console and App Store Connect accounts (NK):** CW20.
- **Production host (not resolvable, LB):** CW18b, CW19.
- **Signing keystore (absent, LB):** CW18b.
- **Two staging accounts and seeds (NK):** CW09 to CW12.
- **Pixel 8 (intermittent):** every walk.

## 6. Per-wave validation gate and close-out template

**Gate (GS).** Run in this order and quote the output at its verification level (SOURCE, BUILD, ARTEFACT, DEVICE, CI). Never round up.
1. **Start checks.** `git status` and diff fingerprints; `ListAgents`; announced file list; `git ls-remote` on the contract against the pin; every operation in scope is `stable` and not `x-consumers: [web]`.
2. **Format** covers hand-written Dart, including untracked files: `git ls-files -o --exclude-standard '*.dart'`, because `validate.ps1` formats only tracked files (`D:2666,2750`). Use `xargs -s 7000` on Git Bash (`D:2663`).
3. **`flutter analyze --no-pub`** reports 0 issues.
4. **Tests.**
   - Targeted test files, each run alone (the expanded reporter prints in-flight names only, `D:2847`).
   - The full suite at ≥2067/0/0 plus the wave's new tests (`D:2661`).
   - `test/guards` alone at ≥122.
   - The contract guard at 14/14 plus a binding and a mutation probe for each new response schema (`D:4553`).
5. **Drift.** `git diff --quiet -- pubspec.lock` (validate only warns, CI fails, `D:2750`); `gen-l10n` diff, ARB parity and a duplicate-key grep; `build_runner` drift in a worktree when models change.
6. **Identity and platform.** The Android identity guard (and the iOS guard once CW03 lands); `aapt2` on a fresh flavor APK for identity, Firebase and push waves.
7. **Safety scans.** Purchase silence (a tree-wide scan with an allow-list for the contract-verbatim `explanationSubscriptionRequired`, `app_en.arb:516`, `C:o:2069`, and a content-level note for server-served legal text); no price, paywall, checkout or `/redeem`. Security: no `debugPrint`, `dart:developer` or `LogInterceptor`; tokens only in secure storage; no bearer token on a presigned PUT; no personal data in URLs or logs.
8. **Staging check** with the whitelisted `+20100000000xx` numbers, 11 digits after `+20` (`C:o:94-98`; LB).
9. **Device walk** when the Pixel 8 is attached: `--flavor staging -t lib/main_mock.dart` (`D:5315`), `uiautomator` coordinates, EN/AR × light/dark. Score F/V/I (`D:5307`).
10. **CI** after an authorised push only: quote `gh run view` at CI level.
11. **Wave-type gates.** A re-vendor gets a clone dry run with LF blobs and updated `SOURCE.md`. A release candidate gets `verify_guards.ps1` N/N, the smoke run, an AAB inspected with `aapt2`, a physical-device staging walk and the Wave 03 School-registration walk.

Run `validate.ps1` with `LEVELUP_VALIDATE_OUT` set so the tracked `test-results.md` stays untouched (`D:4571`).

**Close-out template fields.**
- Wave ID.
- Scope delivered versus planned.
- Files changed.
- Verbatim gate outputs with levels.
- Guard-proof N/N.
- Contract operations used and their gate result.
- Device and staging evidence.
- Acceptance F/V/I scores.
- Limitations and deferred items.
- Rejected options.
- Open owner decisions.
- Backend sentence.
- Rubric movement.
- Fable verdict (APPROVED, APPROVED WITH WARNINGS or REJECTED).
- Owner decision (`NEXT`, `WALK` or `FORMULATE`). Nothing advances without one of these.

Commits happen only when the owner asks, with one concern per commit, and never as a force-push.

**Proposed Fable checkpoints, for owner agreement** (the cadence is still open, `D:5673`; source list `D:4506-4525`).
- CW01 pin integrity.
- CW02 foundation.
- CW04, CW05 and CW06 individually.
- The privacy-sensitive waves CW08, CW10, CW12 and CW13.
- Integration audits capped at four named hand-overs: L-AUTH-ROUTER at CW06 close, L-MESSAGE-SLOT at CW10 close, L-QUIZ-REVIEW at CW11 close, and L-BOOT-BUILD/L-IOS at CW08b close.
- The RC.

## 7. Readiness measurement model

Track three separate measures and never merge them.
- **Implementation completeness** is operations and screens wired and tested at SOURCE and BUILD, over the scoped release-1 set of the 82 app-buildable operations. A screen counts only if all STATES exist in AR and EN.
- **Functional verification** is the highest level reached per capability: SOURCE, BUILD, ARTEFACT, DEVICE or CI. Report F/V/I per walk. No iOS BUILD or DEVICE level exists without a Mac. Push and chat cannot reach DEVICE while delivery or the staging hub is not proven (`C:r:80`).
- **Store readiness** is the frozen rubric (`docs/STORE_READINESS_RUBRIC.md`). Its last logged scores are Play 44% and Apple 20% (2026-10-06). The rubric is frozen for the chapter, so a wave moves items only on evidence. Open blockers hold the verdict at NOT READY regardless of score.

**P0 store blockers and the waves that close them** (`D:3078-3089`):

| Blocker | Closing wave | External gate |
|---|---|---|
| E-1 production API host | CW18b, then CW19 on a prod build | Seif host plus the contract entry |
| E-2 privacy and terms | CW04 (in-app half) and CW20 (public URL and entity name) | Approval, entity name and public URL (Seif, web, legal) |
| E-3 account deletion | CW05 | Designs, Seif's safe copy, and E-8 web URL |
| E-4 iOS required-reason API | CW03 | DR-02, then a Mac Privacy Report |
| E-6 reviewer login | CW20, verified in CW19 | Seif |
| E-7 retention facts | CW20 | Seif and legal |
| E-8 web deletion URL | CW20 | Seif or web |
| AND-02 keystore and Play App Signing | CW18b | Owner custody |
| Conditional, now required: UGC controls and ban handling | CW02, CW06, CW09, CW10, CW12 | Designs |
| Conditional, now required: push prerequisites | CW08a, CW08b | Firebase and APNs |
| Photo Terms gate | CW04, CW12, CW13 | None |
| Wrong-id AAB (do-not-upload) | CW18b | Owner |
| H-7 ScreenProtectorKit on iOS 26 | CW19 | Mac |
| Minors and age floor | CW20 | Owner and legal memo |

## 8. Recommended first wave: CW01

**Recommendation.** Run CW01, the contract re-vendor to `eddb6ac`, first. CW00 is its docs-only entry step. If and when the owner requests commits, CW00 and CW01 are separate commits, because the re-vendor must stay its own commit. Until then the work is staged and validated only.

**Why first.** CW01 is the root of the critical path. A hard dependency runs from it to every contract-backed wave from CW02 through CW16b (`D:4932`). Until it lands, the committed pin `0df5cf4` lacks 3.29–3.46, and the dirty tree holds 3.38.

**What it completes.**
- The pin at 3.46.0-m1 is validated with its census. It is committed only on the owner's request.
- `SOURCE.md` is corrected.
- The mock's pin comment is fixed.
- A mechanised pin-integrity check exists.

**What it does not depend on.** No Seif answer, no designer frame, no Mac, no Firebase and no keystore.

**What it unblocks.** All sixteen feature waves. It also makes the photo operations buildable, since they flipped to stable at 3.46.

**What could go wrong.**
- A copy made from the clone's old working tree or from CRLF checkouts breaks 13 of 14 guards with a misleading error (`D:2683`).
- Upstream moves between decision and commit. Re-check `ls-remote` at start and again before committing.
- `git add -A` sweeps in the untracked files.
- The guard stays green while blind to the unbound schemas (27 of 34 at 3.46, `D:4553`). Each consuming wave must add bindings.

**How it is reviewed.**
- A BUILD dry run in a clone first.
- Hash equality and a CR count of 0 against the upstream blobs.
- The guard run alone at 14/14, and the full suite at ≥2067/0/0 with no lockfile diff.
- A Fable pin-integrity audit (`D:4506-4511`).
- CI read only after an authorised push.

Absolute paths: the discovery report is `F:/level/level_up/level_up_app/.ai/audits/current/PRE_EXECUTION_DISCOVERY.md`. The contract clone's object database is `F:/level/level_up/level_up/level-up-contract`, read only through `git show eddb6ac:<file>`.

## Verification notes

Findings are numbered V1–V23 in the verifier's order. Missing items are M1–M8.

- V1 applied: §3 order and step 8 put CW16a before CW11, matching the lock table, graph and CW11 cell (`D:4465,5014`).
- V2 applied: §3 order is CW18a, CW03, CW08b (`D:5016,5027`). Step 9 is rebuilt, and an optional Android/iOS split of CW08b is noted for the owner.
- V3 applied: CW15–CW04 is now M (`D:4899`, matrix row T10).
- V4 applied: CW06–CW02 is now H per the matrix (`D:4891`, K4 at `D:5025`). The functional need for the banned screen is labelled plan-added.
- V5 applied: the H edges CW07~~>CW16a and CW10~~>CW16a are added to the Dependencies cells and the graph (`D:4892,4895,5026`). CW16a moves to lane B, and lane D is M-only.
- V6 applied: CW05 acceptance now says the 202 revokes the session, so tokens are purged and the app routes to login. The pending state is reached by re-login (`C:o:1276-1278`). "On execution" is dropped.
- V7 applied: CW16b drops "rank" from the Goal and the backend questions. The Rank option is excluded by the no-own-rank ruling. N-17 (#101) is added as an owner decision. N-18 (D-008, `D:3984,4212`) is stated as staying closed.
- V8 applied: CW18a records the CI-gate consequence (`ci.yml:318-330,380`; `app_config.dart:54`; `ENVIRONMENTS.md:301,313`). Risk is raised to Medium and a placement owner decision is added. CW18b and CW19 prerequisites are updated. The gate goes red only after promotion to `main`, since the job runs on `refs/heads/main` pushes.
- V9 applied: §8 and CW01 say commits happen only on the owner's request.
- V10 applied: §5a is qualified for CW08a (sign-out token), CW12 photo and CW13 (after CW04), and CW03 (DR-02 items).
- V11 applied: CW05 lists the grep-derived code sites and the comment-only references. A per-site test is added to CW02 and CW05.
- V12 applied: CW10 now says 7 REST operations in `C:o:3370-3630`, with `reportStudent` in CW09. The discovery's count of 8 (`D:5265`) is noted as unreconciled.
- V13 applied: the CW14 `_track` cite is now `mock_backend.dart:78` (used at `:182,:210`), re-read.
- V14 applied: the CW01 pin-comment cite is now `mock_backend.dart:19-20`, re-read.
- V15 applied: the CW08b cite is now `ENVIRONMENTS.md` §7 `:340-360` (§7 starts at :340, §8 at :361, grep).
- V16 applied: correction 1 keeps only `D:2995` and counts three support-photo and two avatar operations. `D:4418` and `D:4813` carry no draft wording (re-read). The contract "draft" prose is `C:e:16,61-67` (re-read).
- V17 applied: CW04 cites the staging Terms §4 "Subscriptions" text as an API-level GET on 2026-10-09. It names subscriptions in prose with no price, link or call to action. The purchase-silence consequence is added as an owner decision.
- V18 applied: CW12 now frames the staging proof as Seif's changelog claim (`C:c:15`, CONTRACT/DOC, not reproduced). A 401-versus-404 probe is added as the first increment.
- V19 applied: the temp-copy sentence is removed. The Basis records only that two files were observed in the OS temp dir with owner NOT KNOWN. I did not delete anything (read-only task).
- V20 applied: Fable audit points are labelled "proposed, for owner agreement", and integration audits are capped at four named hand-overs (the four hand-overs are a plan proposal).
- V21 applied with a caveat: CW00 status becomes READY INDEPENDENT WORK; OWNER DECISION REQUIRED. Untracked paths are now counted as four (git status 2026-10-09). The WALK-substrate item stays, flagged "confirm with the lead whether B-3(d) counts as settled", because the owner brief is silent on it.
- V22 applied: the lane C "no shared code" claim is removed. The rendered matrix (`D:4897-4898`, T08/T09 against T19 only) and the scratch render (`D:5674`) disagree, and that is stated.
- V23 applied: the §7 E-2 row now names CW04 (in-app) and CW20 (public URL and entity name).
- M1 applied: the `moderation_warning` kind is added to CW07 (`C:c:79-80`, re-read).
- M2 applied: CW12 requires the signed `upload.headers` verbatim before `upload.expiresAt`, at most 15 minutes (`C:o:2852-2856`, re-read). Re-presigning on expiry is labelled a plan choice to confirm with Seif.
- M3 applied: CW14 adds the `track_transfer_not_allowed` 409 (`C:e:59`) beside `track_transfer_not_eligible` (`C:e:60`), both re-read.
- M4 applied: the no-auto-advance rule is now in "Standing constraints and protocol" and in the close-out template.
- M5 applied: "dev frozen" and the preserved backup branch are restated. The `tell_claude.md` claim is evidenced by `git log --all`, which finds only commit `e4006e7`, and by the file's absence from the working tree.
- M6 applied: the CW18a/CI-gate interaction is in CW18b and CW19 prerequisites (see V8).
- M7 applied: the CW16b N-17/N-18 owner-decision handling is in the CW16b row (see V7).
- M8 applied: CW20 acceptance names the Wave 03 School-registration walk (`D:5689`), and the §6 RC gate repeats it.