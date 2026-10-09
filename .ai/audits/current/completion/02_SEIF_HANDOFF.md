# Reply to Seif — draft for owner review (2026-10-09)

> **Lead review (Opus control plane, 2026-10-09).** Drafted by Sonnet, adversarially verified by a second Sonnet agent, composed with the verifier's findings applied, then reviewed by the lead. Workflow run `wf_6986d53d-04f`. Nothing in this file has been sent to anyone.

*Draft only; nothing has been sent. Send A.1 and A.4 plus the Section B questions. A.2, A.3, the "Blocking wave" column of B, and Sections C, D and E are lead-only backing material. Strip internal paths and CW ids before the owner sends anything.*

*Basis: repo `merged @ 8e641e9`, contract `eddb6ac` read through `git show`, and `.ai/audits/current/PRE_EXECUTION_DISCOVERY.md` (cited as D:N). Citation keys are `oa:N` for `openapi.yaml`, `cl:N` for `contract-changelog.md`, `rt:N` for `realtime.md` and `ec:N` for `error-codes.md`, all at `eddb6ac`. `SF:N` is `docs/seif_fight.md`.*

*This pass re-ran the read-only probes at 2026-10-09T12:35Z. The staging health body is unchanged and the four legal-document GETs are unchanged. The hub URL still answers 401 and a nonexistent API path 404. `api.level-upworld.com` still does not resolve (curl exit 6). `git ls-remote` on the contract repo at 12:36:15Z still shows `eddb6aca993f1edeef49a03fd1f2454c314b645e`.*

---

## A. Confirmed information we can provide now

### A.1 Message to Seif (ready to send after owner review)

Hi Seif,

Thanks for the handoff. Below is what we can confirm today. What we need from you is in the question list (Section B).

1. **App identities (facts for your records; nothing is registered anywhere yet).**
   - Android: `com.levelupworld.app` (production, label "Level Up") and `com.levelupworld.app.stg` (staging, label "Level Up STG").
   - iOS: the same two IDs, minimum iOS 15.0.
   - The Android project already carries these. The iOS project still holds a template ID and iOS 13.0 until we have a Mac, so please do not read the iOS values from the repo.
   - Please do not register these IDs in any Firebase, Apple or Google console yet. The owner has to authorise that, and Firebase ownership is not settled.
2. **Contract.**
   - We are building against `eddb6ac` (3.46.0-m1). Upstream was still at that commit when we checked on 2026-10-09 at 12:36Z.
   - We will check again before the re-vendor starts.
   - Between our current pin and 3.38, none of the 26 operations the app already consumes changed structurally. Up to 3.46 the only changes to them are additive: `403 account_banned` on `verifyOtp` (3.42, behavioural; the app will handle it) and the optional `inviteCode` on registration (3.44).
   - We dry-ran the app against the `eddb6ac` files on 2026-10-09: it compiles with no analyzer issues and all 2,067 tests pass (contract-model guard 14/14). The re-vendor itself is a separate step on our side.
3. **Backend.**
   - Staging reports commit `a158daa33231f2d8d8812092d8c9f7745552362a`. That is the commit named in the `eddb6ac` mirror.
   - We use `https://level-up-backend-staging.up.railway.app/api/v1`.
   - The planned production host `api.level-upworld.com` does not resolve yet. Please announce the real host through the contract.
4. **Release 1 scope.** Push notifications, text chat, the notifications inbox and the Message tab are in release 1. Account deletion and banned-account handling are not deferred.
5. **Your item 1, the subscription screen with a website link.**
   - Purchase silence stands (adr-049 §3, `cl:576`): no website link, no redemption reference, no price and no call to action.
   - Whether a link-free, read-only status screen exists is an owner decision. We are not asking you about it.
6. **Push.**
   - The app will send only the FCM token, to `PUT /me/fcm-token`.
   - No Firebase project, app registration, `google-services.json`, `GoogleService-Info.plist` or APNs key exists on our side.
   - Your handoff implies separate staging and production Firebase projects. Ownership is not settled, so nothing will be registered until the owner says so.
7. **Confirmations of your handoff items.**
   - The notifications Support tab is now backed by `category: support` and `kind: support_ticket_replied` (`oa:1186-1192`).
   - Chat photos, voice and groups are not in the contract (`oa:143-150`, `rt:17`).
   - Avatar upload and support photos are `stable` (`cl:7-18`).
   - The app will start sending `Accept: application/json` on all calls.
8. **Mock backend.** Our mock has no routes for anything added since 3.38. Everything from 3.39 to 3.46 has been read from the contract, not run. That is why Section B asks for seeded staging accounts.

Section B follows. P0 items block store submission or a build. P1 items block a feature. P2 items have a default we will use if you do not answer.

### A.2 Evidence table (lead-only)

| Item | Value | Status | Evidence |
|---|---|---|---|
| Android production application ID | `com.levelupworld.app`, label "Level Up". `namespace com.levelup.level_up_app` is a code package only, not the store ID. `main` still carries the old ID. | CONFIRMED (SOURCE, DOC, ARTEFACT) | `android/app/build.gradle.kts:55,72,31`; `docs/DECISIONS.md:1054`; `git show main:android/app/build.gradle.kts:43`; aapt2 on the 2026-10-06 prod APK and guard `test/guards/android_identity_test.dart` (D §7.1, lead baseline) |
| Android staging application ID | `com.levelupworld.app.stg`, label "Level Up STG". The dev flavor and the mock harness share this identity, so there is one staging Firebase app per platform. | CONFIRMED | `build.gradle.kts:76-77`; `DECISIONS.md:1055` |
| iOS production bundle ID | Ratified `com.levelupworld.app`. Xcode still holds the template `com.levelup.levelUpApp` (tests `.RunnerTests`). | PLANNED-NOT-DEPLOYED. Applying it is CW03 and needs a Mac. | `DECISIONS.md:1054`; `ios/Runner.xcodeproj/project.pbxproj:371,550,572` (tests `:387,404,419`) |
| iOS staging bundle ID | Ratified `com.levelupworld.app.stg`. Xcode has no staging configuration or scheme: Debug/Release/Profile only, one scheme `Runner.xcscheme`. | PLANNED-NOT-DEPLOYED | `DECISIONS.md:1054`; lead baseline |
| iOS deployment minimum | Ratified 15.0. Xcode holds 13.0. The Firebase iOS SDK floor is NOT KNOWN because no Firebase dependency exists yet. | PLANNED-NOT-DEPLOYED | `DECISIONS.md:1057`; `project.pbxproj:349,475,526`; `ios/Flutter/AppFrameworkInfo.plist:23-24` |
| Contract target | `eddb6ac` (3.46.0-m1), owner-selected. At that commit there are 86 operations, all stable, and 4 are `x-consumers: [web]`, which leaves 82 app-buildable. The committed pin is `0df5cf4` (3.28.0-m1). The uncommitted working-tree vendor is `65245be` (3.38). The re-vendor is CW01 and is not done. | CONFIRMED | `oa:28`; lead baseline; D Appendix census "86/86/0/4→82" |
| Upstream HEAD | `eddb6aca993f1edeef49a03fd1f2454c314b645e`, 3.46.0-m1, mirrored 2026-10-08T14:56:03Z from `level-up-backend@a158daa33231f2d8d8812092d8c9f7745552362a`. Unchanged at 2026-10-09T12:36:15Z. | CONFIRMED | `git ls-remote` (this pass); `git log -1 eddb6ac` in the contract clone |
| Backend staging identity | `GET https://level-up-backend-staging.up.railway.app/health/version` returns HTTP 200 `{"commit":"a158daa33231f2d8d8812092d8c9f7745552362a","environment":"Staging","builtAtUtc":"2026-10-08T15:16:14Z"}`. The path is at the host root, not under `/api/v1`. Staging runs the commit the mirror names. | CONFIRMED (LIVE-PROBE) | Lead baseline 12:00Z; re-run 12:35Z, identical body |
| Staging API base URL | `https://level-up-backend-staging.up.railway.app/api/v1`. Dev and staging flavors both use it. | CONFIRMED | `oa:107-108` (only `servers:` entry); `lib/core/config/app_config.dart:44,52-53` |
| Planned production API host | Plan only: `https://api.level-upworld.com/api/v1`. The prod flavor holds the fail-closed placeholder `https://TBD.example/api/v1`. DNS fails (curl exit 6) for `api.level-upworld.com`, `level-upworld.com` and `www.level-upworld.com`. | PLANNED-NOT-DEPLOYED | `DECISIONS.md:1058`; `app_config.dart:54`; `oa:107-108`; lead baseline 12:00Z; probe 12:35Z |
| Chat hub | Route `/hubs/chat`, outside `/api/v1`. WebSockets only, `skipNegotiation: true`, bearer in the `access_token` query parameter. Production runs behind a load balancer, which is why negotiation is skipped. Staging URL derived from the host: `https://level-up-backend-staging.up.railway.app/hubs/chat`. An unauthenticated GET returns 401 and a nonexistent `/api/v1` path returns 404, so the route exists and needs a token. No WebSocket handshake was run. | CONFIRMED (path, staging route). Production host and date: NOT KNOWN. | `rt:21,22,24,26`; `cl:43-44`; probe 12:35Z |
| Firebase project and app IDs | None exist. There is no `google-services.json`, `GoogleService-Info.plist`, `firebase_options*.dart` or `firebase.json`. There is no Firebase, messaging or local-notification dependency, no Google Services Gradle plugin and no `POST_NOTIFICATIONS`. As of 2026-10-06 Seif said the backend held no credential and one-versus-two projects was "not finalised". The 2026-10-07 handoff, as transcribed in the discovery, implies separate staging and production projects. Ownership is still not settled. | ABSENT (files). NOT KNOWN (project and app IDs). Registration is barred until ownership is settled and the owner authorises it. | Lead baseline; `DECISIONS.md:1060`; `ENVIRONMENTS.md:343-347,349-357`; `RISKS.md:137`; D:1022, D:5282 |
| APNs and Apple team | No APNs key. No `DEVELOPMENT_TEAM` in the pbxproj. No `*.entitlements` and no `CODE_SIGN_ENTITLEMENTS`, so no `aps-environment`. | ABSENT. NOT KNOWN (Apple Team ID); the Apple account holder supplies it via the owner or client. | `DECISIONS.md:1060`; `ENVIRONMENTS.md:343-348`; lead baseline |
| Push token endpoint | `registerFcmToken`, `PUT /api/v1/me/fcm-token`, `x-stability: stable`. The body has one required field, `token` (string). Responses: 204 stored; 400 `validation_failed` (absent, empty, whitespace-only or over 4096 characters); 401 `authentication_required` or `session_superseded`. There is no unregister operation. | CONFIRMED | `oa:1060-1082`; `rt:108` |
| Push delivery | "Delivery is off in every environment until the staging verification is recorded, then switched on in production per adr-221." | PLANNED-NOT-DEPLOYED | `rt:80`; `cl:46,71` |
| Uploads and limits | **Avatar:** `PUT /me/avatar`, multipart part `image`, JPEG/PNG/WebP. At most 2,097,152 bytes, 128–4,096 px a side, at most 16,000,000 pixels. 5 uploads per hour, and after 3 refused photos in an hour uploads are refused until the hour clears. A refused photo shows "this photo can't be used" and the previous avatar is unchanged. **Support photos:** presign, then PUT to storage, then complete. At most 7,000,000 bytes, 3 per message, 10 per ticket. 30 uploads and 30 completes per hour, with a lockout after 5 refused. A refused photo shows "this photo can't be sent", is deleted, and needs a fresh upload. **Terms gate:** both need the current Terms accepted (`403 terms_acceptance_required`). Text-only support is never gated. | CONFIRMED (contract). Staging live proof passed 2026-10-08 (photos 18/0, avatars 19/0). | `oa:982-1040,1031,1034`; `oa:2672,2812,2834,2882,2891,2934,2937`; `cl:7-18` |
| Notifications inbox and chat scope | The Support tab is backed (`category: support`, `kind: support_ticket_replied`, data keys `ticketId` and `reference`). Chat is text only; photos, voice and groups are not in the contract. | CONFIRMED | `oa:1186-1192`; `oa:143-150`; `rt:17`; D:1029 |
| Drift on consumed operations | Zero structural diffs on the 26 operations the app consumes, between `0df5cf4` and `65245be`. Between `0df5cf4` and `2e5bb69`, 24 of 26 have zero diffs; the 2 that changed are additive and add no `required` property. The 3.45 to 3.46 diff is the version line plus 5 `x-stability` lines. `transferToUniversity` is stable. | CONFIRMED (discovery diff and Fable re-derivation) | D:3460; D Appendix (5665-5689); `oa:1337-1340` |
| Reviewer access | Staging: a reserved block of fake test numbers with a fixed one-time code, whitelisted "in staging config only", no SMS and production-identical rate limits. The numbers and code are not reproduced here. Production: "Absent from production configuration". | Staging CONFIRMED (contract text; also exercised on a device 2026-10-06 per project memory `staging-walk-release-build-recipe`). Production NOT KNOWN. | `oa:96-98`; `docs/STORE_READINESS.md:37,66,84,159-165,263`. Note: `STORE_READINESS.md:66` ("staging enforces real OTP", dated 2026-08-23) conflicts with `oa:96-98`, and the contract wins. |
| Public legal and support URLs | The only verified legal source is the staging JSON endpoint `GET /api/v1/reference/legal-documents/{terms or privacy}?language={ar or en}` (public, stable). All four GETs return 200 with `version: r4-2026-10-07`: terms en 6,002 bytes, terms ar 8,793, privacy en 7,675, privacy ar 11,329. The app's legal links are placeholders (`levelup.example/legal/...`). No public page, support URL or email, or web deletion URL is known. | CONFIRMED (API endpoint). NOT KNOWN (public pages, support contact, web deletion URL, production Terms version). | `oa:816-831`; probe 12:35Z; `lib/features/auth/screens/login_screen.dart:46-48`; `ENVIRONMENTS.md:407`; `cl:511` |
| Store ownership | Nothing is registered anywhere (Play Console, App Store Connect, Firebase). The Play listing URLs returned 404 on 2026-10-06, which shows nothing is published, not that nobody holds the ID. | NOT KNOWN. The owner or client supplies the account type and holder. | `DECISIONS.md:1054`; `ENVIRONMENTS.md:444-447`; `STORE_READINESS.md` §14 |
| iOS readiness | Missing: (1) the project is the template ID at 13.0; (2) no prod or staging configurations or schemes; (3) no `DEVELOPMENT_TEAM`; (4) no entitlements or Push capability; (5) no `ios/Podfile` and no `PrivacyInfo.xcprivacy`; (6) `Info.plist` display name "Level Up App" (`:7-8`); (7) no `UIBackgroundModes` and no `CFBundleLocalizations`, with `knownRegions = (en, Base)` and no `ar` (`pbxproj:188-191`); (8) no Firebase plist; (9) no APNs key. **iOS has never been built.** That last claim is INFERRED from the absence of a Podfile, a team, entitlements and any macOS CI job. The machine is Windows 11 with no macOS or Xcode, so nothing iOS can be built or verified here. | ABSENT. CW03 needs a Mac. | Lead baseline; D:2015-2196 (§7.3), D:2074, D:3034 |
| Android readiness | Identity, flavors and SDK levels (compileSdk 36, minSdk 24, targetSdk 36) are applied and guarded. Release is unsigned by design: no `android/key.properties`, no keystore, and `signingConfig = findByName("release")` is null (`build.gradle.kts:98`). There is no Play App Signing enrolment, no flavored AAB, no Google Services plugin and no `POST_NOTIFICATIONS`. The only AAB under `build/app/outputs/bundle` is `app-release.aab` (62,144,628 bytes, 2026-10-04 22:29). Its base manifest carries `com.levelup.level_up_app` (5 hits) and `com.levelupworld.app` (0 hits). **It carries the dropped ID and must never be uploaded.** Flavored release APKs `app-prod-release.apk` and `app-staging-release.apk` exist under `build/app/outputs/flutter-apk` and are the ARTEFACT basis for the identity claim. | CONFIRMED (identity). ABSENT (signing, flavored AAB, push). | `build.gradle.kts:55-57,76,98`; `docs/RELEASE_SIGNING.md`; `ENVIRONMENTS.md` next-action row (aapt2 on both release APKs) |
| Device evidence | The physical Pixel 8 is intermittent. It was attached at the Fable audit earlier on 2026-10-09, with `com.levelup.level_up_app` and `com.levelupworld.app.stg` installed and no prod package. It was not attached at the lead check (2026-10-09T12:00:51Z). AVDs Pixel_8 and Medium_Phone_API_36.1 exist. | INTERMITTENT | Lead baseline; D Appendix (5665-5689) |
| CI evidence | The latest CI run on `merged` is `c87b90a`, success, 2026-10-06. `8e641e9` is not pushed (docs-only, one commit ahead). Flutter is 3.44.7. The release-APK compile job runs on pushes to `main` only. It has never run in its flavored form (flavors added by `2dfd969` on 2026-10-06; the two `main` runs predate it). CI builds an unsigned APK only. | CONFIRMED | Lead baseline; `.github/workflows/ci.yml:318-322,380`; D Appendix |

### A.3 Implemented locally versus absent (lead-only)

`lib/dev/mock_backend.dart` routes only auth, `/me`, `/me/entitlements`, `/me/mistakes`, `/leaderboard`, catalogue subjects and tree, `POST /quizzes` with its answers, finish and explanation, flashcards, and the reference lists including `/reference/avatars` (`mock_backend.dart:156-549`). Mock coverage is nil for every row below. Every operation below is `stable` and none is web-only.

| Area | Contract operations | App status and evidence |
|---|---|---|
| Push / FCM | `registerFcmToken` PUT `/me/fcm-token` (`oa:1064`) | **Absent.** The only mention in `lib/` is a comment at `settings_screen.dart:344`. There is no Firebase package. Settings notification toggles are inert. |
| Chat, hub, social | Conversations and messages: `listConversations`, `listConversationMessages`, `sendChatMessage`, `editChatMessage`, `deleteChatMessage`, `markConversationRead`, `forwardQuestion`, `answerForwardedQuestion`. Friends: `listMyFriends`, `removeFriend`, `listFriendSuggestions`, `lookupStudentByPhone`, and the friend-request operations (list, send, cancel, accept, decline). Safety: `listMyBlocks`, `blockStudent`, `unblockStudent`, `reportChatMessage` POST `/message-reports`, `reportStudent` POST `/student-reports`. Streaks: `listMyFriendStreaks` GET `/friend-streaks`. Hub `/hubs/chat` (`rt:15`, stable since 3.39). | **Absent.** No SignalR or websocket dependency in `pubspec.yaml`. No chat or conversation code in `lib/`. `/friends` is a disabled shell (`app_router.dart:423`). |
| Notifications inbox | `listMyNotifications`, `getUnreadNotificationCount`, `markNotificationRead` | **Absent.** No call sites. The Home bell is inert: `hasUnreadNotifications` defaults to false (`home_header.dart:23`) and no caller passes it. The Message tab is a placeholder (`app_router.dart:314`). |
| Legal viewer and Terms | `getLegalDocument` GET `/reference/legal-documents/{document}` (`oa:816`, public), `getTermsAcceptance` (`oa:1087`), `acceptTerms` (`oa:1116`) | **Absent.** `/legal/privacy` and `/legal/terms` exist (`app_router.dart:427-433`) but render "not published". No call to any of the three operations. Signed-out users cannot reach `/legal/*` (`app_router.dart:52`). |
| Account deletion | `requestAccountDeletion` POST `/me/deletion-request` (`oa:1267`), `cancelAccountDeletion` DELETE (`oa:1315`) | **Data layer only.** `pendingDeletion` is decoded (`student_profile.dart:70-77`) and `isAccountPendingDeletion` (`exceptions.dart:134`) drives error copy on a few screens. Neither operation is called and no screen exists. |
| Banned handling | `403 account_banned` on `verifyOtp` (`oa:194,231`), `verifyParentOtp` (`oa:511`) and `confirmRecovery` (`oa:594`). The code is consumed and no tokens are issued (`ec:51`). The fourth operation listed there is web-only. | **Absent.** The string `account_banned` does not occur in `lib/`, so a banned student sees the generic error. |
| Recovery | `startRecovery` (`oa:466`), `verifyParentOtp`, `submitNewPhone` (`oa:551`), `confirmRecovery` | **Absent.** No call sites. |
| Support and photos | `createSupportTicket` (`oa:2658`), `listMySupportTickets`, `getMySupportTicket`, `listMySupportTicketMessages`, `postMySupportTicketMessage`, `createSupportAttachmentUpload` (`oa:2849`), `completeSupportAttachment` (`oa:2900`), `getMySupportAttachmentContent` (`oa:2946`) | **Absent.** `/support` is a disabled shell (`app_router.dart:417`). |
| Avatar | `uploadCustomAvatar` PUT `/me/avatar` (`oa:982`), `removeCustomAvatar` DELETE (`oa:1042`) | **Absent.** The upload row is disabled with a TODO (`avatar_sheets.dart:196`). Default avatars from `/reference/avatars` are implemented and mocked. |
| Referral and `inviteCode` | `getMyInvite` GET `/me/invite` (`oa:1434`); optional `inviteCode` on `completeRegistration` (`oa:390`, stable since 3.44) | **Absent.** `/refer` is a shell (`app_router.dart:415`). The registration draft collects a referral code but does not submit it. |
| Track transfer | `transferToUniversity` POST `/me/track-transfer` (`oa:1338`) | **Absent.** The confirm button is disabled and the operation is never called. |
| Quiz history, favourites, review | `listQuizHistory` (`oa:1877`), `getQuizReview` (`oa:1912`), `listFavorites` (`oa:2131`), `addFavorite`, `removeFavorite`, `listModules` (`oa:1685`), `getMyQuizSummary` (`oa:1731`) | **Absent.** The in-app quiz loop uses only create, answer, finish and explanation. |

### A.4 Integration facts (send with the message)

1. **Ratified identities (facts for your records; nothing is registered yet).**
   - Android prod `com.levelupworld.app` and staging `com.levelupworld.app.stg`. iOS prod `com.levelupworld.app` and staging `com.levelupworld.app.stg`, minimum iOS 15.0. Display names are "Level Up" and "Level Up STG" (`DECISIONS.md:1054-1057`).
   - **Do not register these in any Firebase, Apple or Google console until the owner authorises it.** Firebase ownership is unsettled (`RISKS.md:137`).
   - The staging app talks to the staging backend and the production app to the production backend, with no development backend (D-021 Q6, `DECISIONS.md:1059`). Four registrations will be needed before push (`DECISIONS.md:1060`).
   - The Xcode project does not yet carry the iOS IDs. A Firebase iOS registration made against the ratified ID will not match the project until CW03.
2. **FCM token registration (once the push wave lands).**
   - `PUT /api/v1/me/fcm-token`, `Authorization: Bearer <access token>`, body `{"token": "<FCM registration token>"}`.
   - The token is the only field the contract defines. The app will not send platform, device ID, bundle ID, language or environment. The backend cannot tell staging tokens from production ones from the request.
   - It is sent after sign-in and on every token refresh (`rt:108`), and the app expects 204.
   - *Inferred from standard FCM behaviour, not stated in the contract:* each backend needs the credential for the Firebase project that issued its tokens. The staging backend needs the project behind the `.stg` apps and production needs the other one.
   - While a deletion request is pending, every authenticated endpoint except four answers `403 account_pending_deletion`, and the rule is default-deny (`oa:63-83`). Treat that as applying to `registerFcmToken` as well. Its response list omits the 403; see SQ-24(m).
3. **Push content the app will handle.**
   - The four kinds are `support_ticket_replied`, `friend_request_received`, `academic_year_opened` and `chat_message_received`.
   - The `data` payload carries `kind` plus `ticketId`, `friendRequestId`, nothing, or `conversationId` respectively (`rt:86-91,106`). An unknown kind opens the notifications screen.
   - The server sends localization keys, never text: Android `title_loc_key` and `body_loc_key`, iOS `title-loc-key` and `loc-key` (`rt:83`). The `push_*` keys therefore have to ship as native strings.
   - *Inferred, to be proven at the first staging push:* that means Android `values` plus `values-ar`, and iOS `Localizable.strings` with `ar` in the regions. None of these exist yet.
4. **Chat hub.**
   - The app connects to `<host>/hubs/chat`, with the host taken from the base URL minus `/api/v1`. It uses WebSockets only with `skipNegotiation: true` and the bearer in the `access_token` query parameter.
   - It opens one connection per app instance and reconnects with a fresh token (the access JWT lives about 15 minutes, `oa:56`). After each reconnect it backfills through REST (`listConversations`, then `listConversationMessages`; `rt:67-72`).
   - Chat is text only. The app uses no camera permission.
5. **Uploads.**
   - Avatar: multipart part `image` to `PUT /me/avatar`, with the limits in A.2. The server rejects out-of-range images.
   - Support photos: `createSupportAttachmentUpload`, then a plain `PUT` of the bytes to `upload.url` with exactly `upload.headers`, then `completeSupportAttachment`. The `PUT` goes through an isolated client that carries no bearer token.
   - Support attachments are JPEG, PNG or WebP only, 7,000,000 bytes at most, 3 per message and 10 per ticket (`cl:7-18`, `oa:2849-2860`).
6. **HTTP behaviour change planned.** The app sends no `Accept` header today (`dio_client.dart:15-20`). It will send `Accept: application/json` and will handle error responses that carry no body or no `code`.
7. **Gaps only Seif or the owner can fill.**
   - The production API host and its DNS.
   - Firebase ownership and the number of projects, the four registrations, the APNs key and the Apple Team ID. No registration happens without the owner's explicit go-ahead.
   - A production reviewer account and a seeded cohort.
   - A public legal URL, a support URL or email, and a web account-deletion URL.
   - The date staging push delivery is verified and on, and what the backend does with a stored FCM token at logout.
   - Approved deletion-confirm text that avoids "paid" and "refund" (SQ-03).

---

## B. What we need from you

These are the questions for Seif, with stable IDs. SQ-19 is retired (folded into SQ-24) so the other IDs stay put. The Blocking wave column is lead-only.

| ID | Priority | Exact question / request | Why needed | Expected answer / artifact | Blocking wave |
|---|---|---|---|---|---|
| SQ-01 | P0 | When will the production API be live (DNS and TLS)? Is the base URL exactly `https://api.level-upworld.com/api/v1`? Please add the host to `servers:` and state in `realtime.md` the host for `/hubs/chat` (we assume it is the same host). | The prod base URL is a fail-closed placeholder (`app_config.dart:54`). The planned host does not resolve (checked 2026-10-09T12:35Z). `oa:107-108` lists staging only. `rt:21` gives a route, not a host. The load-balancer behaviour is already documented (`rt:26`), so we are not asking about it. | Date window, confirmed URL, changelog entry | CW18, CW19, CW20 (hub URL: CW10) |
| SQ-02 | P0 | How will App Review and Play review sign in to a production build? The staging test numbers are "absent from production configuration" (`oa:96-98`). Will you provision production reviewer numbers with a fixed one-time code for the review window? We need one School and one University account per store, because a login on a second device evicts the first (`oa:198-200`). Deliver them only through the owner's private channel. | Both stores need working demo access, and the contract has no mechanism for production. | Yes or no, the mechanism, the count, the validity window | CW19, CW20 |
| SQ-03 | P0 | `requestAccountDeletion` mandates a confirm text saying an active paid subscription is forfeited with no partial refund (`oa:1282-1286`). The app is purchase-silent (adr-049 §3, `cl:576`). Will you publish, in a changelog entry, approved EN and AR confirm text that never says paid, refund or subscription? | Account deletion is store-mandatory and the contract requires that text before the call. | Verbatim EN and AR text, or a written contract relaxation | CW05, CW20 |
| SQ-04 | P0 | Where will the public privacy-policy page, terms page and web account-deletion-request page live (URL, owner, go-live date)? Will they mirror `getLegalDocument` for the same version? | Play needs a public non-PDF privacy URL and a web deletion link. Apple needs a privacy URL. The web deletion URL is a "still-unowned decision" (`cl:511`). `getLegalDocument` returns JSON on the API host, not a page (`oa:816-831`). | Three URLs or dates, plus the owner | CW20 (CW04 unaffected) |
| SQ-05 | P0 | Is a Terms version configured in production at release? Without one, `getLegalDocument` returns 404 `legal_document_unavailable` (`ec:22`) and the photo 403 stays inert (`ec:67`). Is it identical to staging `r4-2026-10-07`? When you publish a new version, does `version` change, and must every student re-accept? | The registration Terms step (`oa:819`) and the photo gate depend on the current version. Staging already serves r4, so only production is open. | Yes or no, parity statement, versioning rule | CW04, CW20 |
| SQ-06 | P0 | Beyond what the served privacy text r4 already states, please give the hosting region(s) where student data is processed and the log and backup retention periods. Please also supply the `security.md` that `oa:98` cites. | Needed for Data Safety and App Privacy. The text says data "may" be processed outside Egypt and names no regions or log retention. | Regions, periods, document | CW20 |
| SQ-07 | P0 | For Apple 1.2 and Play UGC: (a) are display names filtered or reviewed before other students see them (friends, leaderboard, chat)? (b) Is chat text filtered? (c) Who reviews `reportChatMessage` and `reportStudent` reports, and what response time may the app state? | In 3.37 chat was deferred until "a review path for message and student reports" existed (`cl:162`). 3.39 made chat stable without recording it. Chat is in release 1. | Yes or no per item, plus a response-time statement | CW09, CW10, CW20 |
| SQ-08 | P1 | (a) Is there a contract version or date that freezes the mobile contract for release 1, and is `eddb6ac` (3.46.0-m1) the intended mobile target? (b) Can a breaking or BEHAVIOURAL change to an operation the app consumes ship before release 1, and with what minimum notice? (c) Please confirm no change since 3.38 touches an operation the app consumes beyond what the changelog entries state. | Stable is documented as frozen with announced changes (`oa:30-32`, `cl:120`). Yet 3.43 and 3.45 shipped BEHAVIOURAL changes to stable operations (`cl:47`, `cl:19`). The contract moved from 3.39 to 3.46 in about 28 hours (mirror commits 2026-10-07T11:12Z to 2026-10-08T14:56Z). | Freeze version or date, target confirmation, notice rule, confirmation for (c) | CW01, CW20 |
| SQ-09 | P1 | Does the server clear or detach the stored FCM token (a) on `POST /auth/logout`, (b) when a session is superseded, (c) on deletion request or execution, and (d) when a second student registers the same device token? The contract has one token per student, latest wins, and no unregister operation (`cl:326-331`, `oa:1076`). If nothing detaches it, will you add an unregister operation, or should the client delete its local FCM token at sign-out? | Shared family phones and many minors: a signed-out student's pushes could reach the next student. | Per-case yes or no, plus the chosen fix | CW08 |
| SQ-10 | P1 | (a) Which Firebase project and sender credential does the backend FCM sender use in staging and in production, and is it configured today? (b) Must the app's `google-services.json` and plist belong to the same project that owns the sender credential? (c) Please confirm that staging and production use separate Firebase projects, as your handoff implies. | Senders now exist behind off-by-default gates (`cl:46`). On 2026-10-06 you said the backend held no credential (`docs/ENVIRONMENTS.md:343-347`). A project mismatch fails silently. | Ownership and configuration statement per environment. Do not invent IDs. | CW08, CW18, CW03 |
| SQ-11 | P1 | When will staging push delivery be switched on? Can you then send a test push of each of the four kinds to a whitelisted number whose token is registered? | Delivery is off in every environment until the staging verification is recorded (`rt:80`). | Date, plus a trigger method | CW08, CW19 |
| SQ-12 | P1 | A banned student gets 403 `account_banned` after a correct code and is told to contact Support (`cl:78`, `ec:51`). `recovery_unavailable` says "route to the support path" (`ec:29`, `oa:477`). Every `/support/*` operation needs a bearer token, and none of the 19 operations without one is a support one (our census of `eddb6ac`). Is there, or will there be, an anonymous support-contact operation, or is the channel outside the app? | The banned screen and the recovery-failure screen are dead ends without a destination. | Operation id, or "outside the app" | CW02, CW06, CW20 |
| SQ-13 | P1 | Does the backend have, or plan, operations for (a) the Progress screen (history or time series), (b) Daily Tasks and their XP, (c) a personal daily streak (not the friend-pair streak)? If no, please say so in writing. | A grep of all four contract files at `eddb6ac` finds none (`rt:10` folds the streaks hub into chat). The server is authoritative, so nothing can be computed on the client. | Per-item yes, no or version | CW16, CW17 |
| SQ-14 | P1 | Please seed a University-track whitelisted account on a released term. It needs questions, lecture flashcards and at least one wrong answer. State its cohort. | University learning surfaces and per-lecture `retakeWrong` have never run against a real server (S37 ask 2, `RISKS.md:125`). | Account plus cohort | CW16, CW19 |
| SQ-15 | P1 | For two or more whitelisted accounts, please seed: an accepted friendship; a pending incoming friend request; an open conversation with messages, one being a forwarded-question card; an open support ticket with a staff reply; and a closed ticket. | Social, chat and support surfaces added after 3.28 have never been exercised by this app against staging (`RISKS.md:118-126`). | Seeded accounts and a state list | CW09-CW12, CW19 |
| SQ-16 | P1 | Please seed one inbox item per kind on a whitelisted account: `announcement`, `moderation_warning`, `support_ticket_replied`, `academic_year_opened`, and `enrolment_opened` if it can still be written. Also name a separate whitelisted account that Support has banned. | Inbox rendering by kind (`oa:1170-1197`) and `account_banned` after a correct code cannot be checked on a device otherwise. | Accounts and item lists | CW02, CW07, CW19 |
| SQ-17 | P1 | `LeaderboardEntry.name` is required on every row (`oa:4660-4664`). Are leaderboard display names moderated, and by the same process as in SQ-07(a)? | Peers' names are user-generated content on the leaderboard. | Yes or no, plus the moderation process | CW17, CW09 |
| SQ-18 | P2 | Will the monthly School parent report (adr-165) be delivered in production at release 1? If yes, when, and will the privacy text change? | Affects the Data Safety and App Privacy answers. `cl:269` says nothing is sent, and `parentReportStatus` (`oa:4265`) goes `active` only when delivery is on. | Yes or no, date | CW20 |
| SQ-19 | — | *Retired. Folded into SQ-24(l).* | — | — | — |
| SQ-20 | P2 | Is `enrolment_opened` still written? Which `data` keys does it carry? Should the app render it? (It is never pushed: `rt:82`.) | It is in the enum (`oa:1211`, category `system` at `cl:224`), but its keys are documented nowhere. | Yes or no, keys | CW07 |
| SQ-21 | P2 | What are the per-kind hourly push limits? `rt:107` says "limited per student per hour" without a number. | Informational only. | Four numbers | CW08 |
| SQ-22 | P2 | Will `429 otp_throttled` carry `Retry-After` or the remaining lock time? Is `Retry-After` always whole seconds on every 429? | `Retry-After` is declared on `rate_limited` and `forward_daily_limit_reached` (`ec:24,70`), not on `otp_throttled` (`oa:187,200,234`). | Yes or no, format | CW02 |
| SQ-23 | P2 | Will there be a minimum-version or forced-update signal before release 1? | A grep of `oa`, `cl` and `rt` finds none. | Yes or no | CW20 |
| SQ-24 | P2 | Please issue one wording-correction entry covering: (a) support tag "Text only for launch" (`oa:136-137`); (b) "no streaks" in the social and chat tags (`oa:142,149`); (c) `getTermsAcceptance` "serves no Terms text" (`oa:1095`); (d) `acceptTerms` "not enforced" (`oa:1122`) versus the live photo 403; (e) `ec:61-67` still say "(draft)"; (f) the 3.46 entry lacks the "Consumers affected" line required at `cl:3`; (g) `sendFriendRequest` "no push or inbox item" (`oa:3162`), although the inbox enum (`oa:1211`) has no friend-request kind and a push exists; (h) `ChatMessageReceived` (`cl:208`, `oa:3708`) versus `chat_message_received`; (i) the 3.37 headline says 15 operations and the body says 18 (`cl:150`), and 3.35 is skipped (`cl:169`); (j) `getLeaderboard` and `getMyRank` carry no 3.36 `x-behaviour-changed` stamp (`oa:2470,2578`); (k) `ec:15` flashcard wording versus `oa:2185`; (l) `UniversityRegistration.inviteCode` (`oa:4182`) still says "this field is `draft`" while `oa:390`, `oa:4147` and the 3.44 entry say it is stable; (m) the `registerFcmToken` response list (`oa:1060-1082`) omits the 403 `account_pending_deletion` that the default-deny rule at `oa:63-83` implies (the support operations list it, e.g. `oa:2691`). | The contract contradicts itself where agents read it as build guidance. | One changelog entry | CW01, CW15 |
| SQ-25 | P2 | When a presigned PUT fails (expired URL, signature mismatch), what does storage return? May the app retry the same URL before `expiresAt`, or must it presign again? | The contract specifies the request and the 15-minute expiry (`oa:2854-2860,4052`), not the storage failure. `complete` on 503 keeps the upload (`oa:2912,2940`). | Short rule | CW12, CW13 |
| SQ-26 | P2 | What is the storage hostname for presigned URLs, and is it stable per environment? | The avatar CDN host is documented as separate (`cl:96`). The storage host is not documented anywhere. | Hostname or pattern | CW12, CW13, CW18 |
| SQ-27 | P2 | Please confirm or specify these edge cases. **S39:** is a point credited at `submitAnswer` or at `finish`, and is it visible in `GET /me` after an abandoned quiz? **S40:** the rule among the three `createQuiz` 403 codes. **S41:** the discriminator on the `getSubjectTree` 403. **S43:** what a "N mistakes" badge replays versus the "ever wrong" pool. **S2:** does an abandoned quiz count against the weekly allowance? (The 24-hour auto-finish is already stated at `oa:1987`.) **S45:** `avatarId` 400 versus 404. **S6 asks 1 and 2:** where flashcard round two starts, and the list order. **S42:** `getMyMistakes` declares `required: [id, name, mistakeCount]` (`oa:1500-1508`) although the prose says School subjects carry `termId: null` (`oa:1490`). Please declare `termId` and `termNumber` in `required` or state that they may be absent. | The contract text for each is unchanged (`SF:1472-1535`). | Per-item answers | CW16 |
| SQ-28 | P2 | **S25:** is there a "HERO" rank-tier string? **S28:** will notification preferences be stored, e.g. on `PATCH /me`? **S34:** will `parentPhone` stay write-only? **Level ladder:** where does it start, and how do level 12 and the first badge at 11,000 relate (`oa:4294-4295`)? | The Profile third card, the Settings toggles and the level meter depend on these. | Per-item answers | CW08 (S28), CW16, CW17 |
| SQ-29 | P2 | The served privacy text names Sentry. Is Sentry backend-only? | The app ships no crash reporter. This matters if a client crash reporter is chosen. | Yes or no | CW20 |
| SQ-30 | P2 | For error-path coverage, can you provide a short-lived access token (or a switch to force a 401-refresh round trip), a forced 5xx and 429 on a chosen endpoint, and a question with `explanationAvailable: true`? | These remain unobserved against staging (`RISKS.md:126`, S37 ask 3). | Hooks or dates | CW19 |

---

## C. Question → wave → while-waiting map (lead-only)

| ID | Blocks | BLOCKED or PREPARATION ONLY, and the seam | Lead trace |
|---|---|---|---|
| SQ-01 | CW18, CW19, CW20 (hub URL: CW10) | PREPARATION ONLY. Per-flavor base and hub URL slots, plus the build-time `.example` refusal (CW18). No real URL is committed. | I-2, Q-B3, E-1 |
| SQ-02 | CW19, CW20 | BLOCKED (external). The reviewer-notes section is drafted with empty slots in CW20. | I-2 part 2, E-6 |
| SQ-03 | CW05, CW20 | PREPARATION ONLY. Request, cancel and pending-deletion repository, state and tests. The redirect target for `account_pending_deletion` (`oa:82-83`) lands with CW05. The confirm step stays unwired. | I-8, Q-B2, S38 |
| SQ-04 | CW20 (CW04 unaffected) | BLOCKED for console entries. The in-app viewer (CW04) proceeds. | I-10(a), E-2, E-8 |
| SQ-05 | CW04, CW20 | PREPARATION ONLY. Viewer with an "unavailable" state that is never cached (`ec:22`). | I-10(b), I-6(c), S30 |
| SQ-06 | CW20 | BLOCKED (form facts, no code). | I-10(d), Q-B1, E-7 |
| SQ-07 | CW09, CW10, CW20 | PREPARATION ONLY. Block, report and unfriend wiring on stable operations. No client-side filter is invented. | I-11, Q-B9 |
| SQ-08 | CW01, CW20 | PREPARATION ONLY. Re-vendor and census at the start of each wave. The pin stays provisional. | I-1 |
| SQ-09 | CW08 | BLOCKED for enabling push. PREPARATION ONLY: token registration after sign-in and refresh (`rt:108`) behind a disabled flag. No sign-out behaviour is committed. | I-3 |
| SQ-10 | CW08, CW18, CW03 | BLOCKED for Firebase-enabled builds. PREPARATION ONLY: reserved file slots (`docs/ENVIRONMENTS.md:349-353`). Nothing is registered (R-9). | I-12 (Seif half), DR-18 |
| SQ-11 | CW08, CW19 | PREPARATION ONLY. Tap routing and foreground handling against synthetic payloads built from `rt:86-91,106`. DEVICE verification stays capped. | I-6(d) |
| SQ-12 | CW02, CW06, CW20 | PREPARATION ONLY. Both screens built with approved copy and no action control. The contact slot stays empty. The concrete contact comes from the owner (Section D.2). | I-4, I-10(f) |
| SQ-13 | CW16, CW17 | BLOCKED. No seam exists without client computation. Placeholders are unchanged. | I-7, S32 |
| SQ-14 | CW16, CW19 | PREPARATION ONLY. Contract-driven tests. DEVICE is capped at BUILD or mock. | I-6(a), S37, S44 |
| SQ-15 | CW09-CW12, CW19 | PREPARATION ONLY. Unit and fixture level. | I-6(b) |
| SQ-16 | CW02, CW07, CW19 | PREPARATION ONLY. Contract fixtures. | I-4, N-3 |
| SQ-17 | CW17, CW09 | PREPARATION ONLY. One switch on name rendering, with no behaviour change until the owner rules. | I-11, DR-04 |
| SQ-18 | CW20 | PREPARATION ONLY. Default: answer the forms as "not delivered", and re-check `parentReportStatus` at the release candidate. | I-10(e) |
| SQ-19 | — | Retired. Folded into SQ-24(l). | I-5 |
| SQ-20 | CW07 | PREPARATION ONLY. Default: ignore the kind, which the contract allows (`oa:1163`). | N-3 |
| SQ-21 | CW08 | PREPARATION ONLY. The app never depends on delivery. | N-4 |
| SQ-22 | CW02 | PREPARATION ONLY. Default: generic lockout copy, or the documented 15-minute lock (`oa:200`). | N-1, Q-B5 |
| SQ-23 | CW20 | PREPARATION ONLY. Default: no forced update in release 1. | N-6, DR-17 |
| SQ-24 | CW01, CW15 | PREPARATION ONLY. Build from the operation definitions, `ec` and `rt`, and record these as known errors. Default for (l): do not send `inviteCode` for University; the School path is unaffected. | N-2, S6 ask 4, I-5 |
| SQ-25 | CW12, CW13 | PREPARATION ONLY. Default: any non-2xx on the PUT means restart from presign. An isolated plain client is used, never the signed-in Dio client. | N-4 |
| SQ-26 | CW12, CW13, CW18 | PREPARATION ONLY. Default: use `upload.url` exactly as returned, with no host allowlist. | N-4 |
| SQ-27 | CW16 | PREPARATION ONLY. Default: as built. S43 stays read-only replay. | N-5, Q-B8 |
| SQ-28 | CW08 (S28), CW16, CW17 | PREPARATION ONLY. Default: Settings toggles stay disabled. Display the server `level` and `badges` only. | N-5 |
| SQ-29 | CW20 | PREPARATION ONLY. Default: the app declares no third-party SDK collection. | D unknowns list |
| SQ-30 | CW19 | PREPARATION ONLY. These paths stay at unit-test level. | R-8, S37 |

---

## D. Not sent to Seif

### D.1 Already answered — do not ask

- **Push kinds.** Exactly four kinds push, and `enrolment_opened` is never pushed (`rt:82`). The Seif question reduces to inbox keys (SQ-20).
- **Push `data` keys, localization keys and tap handling.** An unknown kind opens the notifications screen (`rt:86-91,106`). Push text follows the phone language (`rt:83`).
- **FCM token model.** One token per student, latest wins, no unregister operation. "Uninstalling or registering a new device is how a token stops being used" (`cl:326-331`, `oa:1076`). SQ-09 asks only about detachment.
- **`registerFcmToken` during the deletion grace window.** Every authenticated endpoint except four answers `403 account_pending_deletion`, and the rule is default-deny (`oa:63-83`). `registerFcmToken` is not in the allowlist. Only the missing 403 in its response list is a wording item (SQ-24(m)).
- **Chat hub transport and load balancer.** Production runs behind a load balancer, so WebSockets only with `skipNegotiation`; at most 3 connections; REST backfill (`rt:24-33,67-72`). The staging hub answers 401 without a token.
- **Presign mechanics.** Expiry is at most 15 minutes, signed headers are exact, bytes go direct to storage, `complete` on 503 keeps the upload, and unattached photos are deleted after 24 hours (`oa:2854-2860,2912`).
- **Photo and avatar readiness and limits.** Both are stable and served. Staging live proof passed. Limits are in A.2 (`cl:7-18`, `oa:982-1040`).
- **Staging Terms version.** Configured as `r4-2026-10-07` in EN and AR. Only production is open (SQ-05).
- **Terms semantics.** Terms are recorded, not enforced except for photos, and are not parent consent (`oa:1096,1122`, `ec:67`).
- **Sub-processors and content retention.** The served privacy text names the sub-processors and gives retention for chat, reports, support photos and profile photo. Chat expires 24 hours after read or 30 days after send (`rt:72`). Only regions and log retention remain (SQ-06).
- **Second verify after a ban.** The code is consumed and no session is issued (`oa:231`, `ec:51`).
- **Deletion semantics.** 30-day grace, session revoked, leaderboard removal, same phone starts from zero, four allowed endpoints, route to the cancel screen (`oa:62-80,1264-1292`, `ec:48-50`). Only the confirm copy remains (SQ-03).
- **Refresh 4xx set.** Only 401 `refresh_token_invalid` and `session_superseded` (`oa:449`). There is no 400 on refresh or `recovery/start`, and "do not code a 400 branch" (`cl:598`).
- **`/reference/cities` 400.** `validation_failed` with a field map naming `governorateId` (`oa:705`).
- **Level thresholds.** Static, every 500 points (`oa:4294`, `SF:694-710`).
- **Per-node progress.** `SubjectTree` nodes carry `answered` and `total` (`oa:4385-4386`).
- **Referral rule.** The inviter gets +10 once per verified new account, the new student gets nothing, and there is no invite link or web page (`oa:1440-1445`). `inviteCode` on `completeRegistration` is stable (`oa:390`).
- **Flashcard re-charge.** A card not shown this week is charged again (`oa:2174-2178`).
- **Quiz auto-finish.** Unfinished quizzes auto-finish server-side after 24 hours (`oa:1987`). Only the weekly-allowance part of S2 is open.
- **Closed by stable operations.** S11, S14, S24, S29, S30, S31 and S33 are answered by stable operations (D:5146-5165). The S37 and S44 premises are stale (D:5169, D:5176).
- **Test numbers.** A reserved staging-only block and a fixed one-time code exist, and are absent from production (`oa:96-98`).
- **OTP rules.** 6 digits, 5-minute expiry, 60-second cooldown, 5 failures lock for 15 minutes (`oa:86-88,200`).
- **Consumer rule.** Absence of `x-consumers` means mobile; only `[web]` excludes the app (`cl:3,586-587`, `oa:35-48`).
- **Production host plan.** `api.level-upworld.com` is planned, with no date, and will be announced through the contract (`docs/ENVIRONMENTS.md:397-403`). SQ-01 asks only for the date and confirmation.
- **Quiz, favourites and history operations.** Stable (D:5146-5149).
- **Inbox tabs and unread count.** Backed by the `category` enum and `getUnreadNotificationCount` (D:4202, D:4214).

### D.2 Route to owner, designer, legal or client

- **Statements, not questions, for the message.** These are already in A.1 and A.4:
  - the ratified identities and the Firebase freeze;
  - purchase silence;
  - no camera, text-only chat, photos per contract limits, and release 1 scope.
- **Subscription status screen (handoff item 1).**
  - The link is refuted by adr-049 §3 (`cl:576`).
  - Whether a link-free, read-only status screen exists at all is the owner's call (I-9). `getMyEntitlements` is stable and consumed only in the data layer (`oa:1409-1412`). There is no `pending` state.
  - Any status copy also needs a designer frame.
- **Owner (Mostafa).**
  - Firebase ownership and registrations, APNs key, Apple team, a Mac, Play account type and store-account ownership (I-12 owner half, I-13).
  - The signed-out support contact to show and approval of the ban copy (I-4, I-10(f)).
  - Who signs product decisions (N-7).
  - Promoting `main` (I-19), repo housekeeping and GitHub settings (N-8 to N-11).
  - Version and build-number policy (N-12), and dependency approvals (N-13).
  - Release-configuration rulings (N-22).
  - The owner `WALK` of Wave 03 School registration (D:5689).
  - The Figma credential rotation (N-25) and the sample phone number in the ARB hint (N-26).
- **Owner and legal.**
  - Who approved the EN and AR legal text (moved here from SQ-05; I-10(b)).
  - Legal entity name (I-10(c)).
  - Terms gate placement and parent consent (I-14).
  - Photos of minors review (I-15).
  - Minors and data-protection memo, and font and package licences (I-22).
- **Owner and designer.**
  - Whether the client renders peer names on the leaderboard ("Option 0" versus report/block; moved here from SQ-17; DR-04).
  - Push permission timing, pre-prompt and foreground behaviour (I-16).
  - Entry points and inbox placement, D1 to D5 (I-17).
  - Push tap routing versus "no deep links" (N-14), tap while signed out (N-15), push text language (N-24).
  - "Lockout" meaning (N-16), the third Profile card (N-17), the empty replay pool (N-19), the evicted-session experience (N-20).
- **Owner ruling pending, then designer.** The referral reward conflict: contract +10 to the inviter only (`oa:1440-1442`) versus Figma "500 to both" (I-18). Seif is not asked to supply this copy.
- **Designer.** All missing frames and Figma corrections (I-21), copy the contract does not supply (I-20), and open DESIGN_ISSUES rulings (N-23).
- **Already settled by the owner.**
  - The D-015 "Subscribe to get step-by-step explanations" copy stays (N-21).
  - The user's own leaderboard rank is not shown (N-18).
  - Support attachments follow the contract limits (JPEG/PNG/WebP, 7,000,000 bytes), not Figma's PDF/10 MB.
- **Client or engineering (no question needed).**
  - The `Accept: application/json` header (`oa:3889`, AA-11), and the stale interceptor comment (D:737).
  - The global 403 seam.
  - Ignoring unknown inbox kinds.
  - Terms gate placement once ruled.
  - Stale TODOs and documents (N-11).

---

## E. Verification notes

Verifier findings, one line each:

- **HIGH, OTP literal printed in Section B:** applied. The code literal and the test-number pattern are removed everywhere. The reviewer-access row, SQ-14 to SQ-16 and the "Test numbers" bullet now say only "a reserved staging-only block and a fixed one-time code exist" (`oa:96-98`).
- **HIGH, "register against" heading:** applied. A.4 item 1 is now "Ratified identities (facts for your records; nothing is registered yet)", with the explicit "do not register until the owner authorises" sentence. The same line is in A.1 item 1.
- **MEDIUM, "WebSocket behaviour behind the load balancer not stated":** applied and confirmed by re-reading `rt:26`. The hub row and SQ-01 are reworded, the Gaps clause is dropped, and the load-balancer fact is in D.1.
- **MEDIUM, grace-window 403 question for `registerFcmToken`:** applied and confirmed by re-reading `oa:63-83` and `oa:2691`. The question is deleted and the answer is in D.1. The omitted 403 is now item (m) of SQ-24.
- **MEDIUM, SQ-05 and SQ-17 mix in non-Seif decisions:** applied. SQ-05 keeps only the production Terms version, parity and versioning. SQ-17 keeps only moderation. The approver and the "Option 0" choice moved to D.2.
- **MEDIUM, referral reward text listed as a Seif gap:** applied. It is removed from the Seif-facing gaps and kept in D.2 (owner ruling, then designer).
- **MEDIUM, "no subscription screen" overreach:** applied. A.1 item 5 and D.2 now state purchase silence precisely (no website link, no redemption reference, no price, no call to action). The link-free status screen is recorded as an owner decision (I-9).
- **MEDIUM, S42 wrongly "already answered":** applied and confirmed by re-reading `oa:1490,1500-1508`: `required` is `[id, name, mistakeCount]`. S42 moved out of D.1 into SQ-27.
- **LOW, Firebase row presents the 2026-10-06 position as current:** applied. The quote is dated, and the handoff's two-project implication is added (D:1022, D:5282) and asked in SQ-10(c).
- **LOW, "28 h" claim:** applied. It now reads "from 3.39 to 3.46 in about 28 hours" with mirror timestamps. Re-check: 65245be (3.38) at 2026-10-07T04:14:28Z to eddb6ac is about 34 h 42 min, so the original "3.38 to 3.46" wording was wrong.
- **LOW, citation slips:** applied after re-reading. The access JWT is `oa:56`. The OTP parameters are `oa:86-88`, one line wider than the verifier's 86-87, because line 88 holds the "previous code" sentence. `otp_throttled` is `oa:187,200,234`. The support-photo limits are `cl:7-18`. The support-lockout cite uses `oa:2937`.
- **LOW, "iOS has never been built" labelled SOURCE:** applied. It is now labelled INFERRED, from the absence of a Podfile, a team, entitlements and any macOS CI job.
- **LOW, S2 only partly open:** applied. SQ-27 is narrowed to the weekly-allowance question, and `oa:1987` (24-hour auto-finish, re-read) is cited.
- **LOW, "Appendix C", SQ-19 and internal Ref IDs:** applied. The "Appendix C" reference is removed. SQ-19 is folded into SQ-24(l), with the ID retired rather than renumbered. Internal references moved to the lead-only Section C "Lead trace" column.
- **LOW, "the only AAB on disk":** applied and confirmed by `find`. A second `.aab` exists in `build/app/intermediates`, so the claim is now limited to `build/app/outputs/bundle`. The flavored release APKs are named as the ARTEFACT basis.
- **LOW, reviewer-access "CONFIRMED (staging)" label:** applied. It is now labelled contract text, with the 2026-10-06 device exercise cited from project memory.
- **Missing, item 1 (website-link status screen):** applied in A.1 item 5 and D.2.
- **Missing, item 2 confirmations:** applied. The Support tab is backed, chat photos, voice and groups are unbacked, and avatars are stable (A.1 item 7; A.2 "Notifications inbox and chat scope").
- **Missing, item 3 (upload detail):** applied from evidence. The "can't be used" and "can't be sent" wording, 128–4,096 px and the 16,000,000-pixel cap are in. So are the 5 per hour avatar limit, the refusal lockouts, the support rates and the Terms gate (A.2 "Uploads and limits"). All are re-read from `oa:1025-1034` and `oa:2891-2937`.
- **Missing, item 4 (drift, `transferToUniversity`, `Accept` header):** applied. The diff result comes from D:3460, and `transferToUniversity` is stable at `eddb6ac`. The `Accept` header is in A.4 item 6. The stale interceptor comment and the Friends TODO are in D.2.
- **Missing, item 5 (two Firebase projects):** applied, as for the Firebase row above.
- **Missing, item 6 (mock has no routes for 3.39 to 3.46):** applied in A.1 item 8 and in the A.3 preface. The request for a list of changes since 3.38 touching consumed operations is SQ-08(c).
- **Limit on this pass:** Seif's handoff text is not in the repo, and the owner's item list was not supplied to this pass. Handoff items are taken from the discovery transcription (D:866-1030) and are marked "as transcribed" where the claim depends on it.
- **No verifier finding was rejected.** Where this pass differs from a finding, it is a refinement of the cited line numbers, noted above.
- **Facts re-checked this pass:** contract lines `rt:19-34`, `oa:54-88,134-152,186-202,980-1040,1184-1194,1409-1412,1486-1510,1985-1989,2932-2935`, `cl:5-20,576,586-587`, `ec` grep. Live: staging health, four legal-document GETs, hub GET 401, nonexistent-path 404, production DNS failure, and upstream HEAD unchanged (12:35Z to 12:36Z). Files: `build/**/*.aab`, `build/app/outputs/flutter-apk`, `docs/ENVIRONMENTS.md:340-360`, `docs/RISKS.md:137`, and the discovery Appendix (D:5665-5689).
- **Not re-run this pass:** the AAB manifest hit counts (taken from the draft, not disputed), and the repo `main` branch line cite `build.gradle.kts:43`.