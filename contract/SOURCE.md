# Vendored API contract — pinned copy

Source: https://github.com/seifhamdii-collab/level-up-contract
Pinned commit: ded6213 (`ded62139739866f8bd4aa995190cb80d215874e0`, "Mirror contract from level-up-backend@2e2c36f7a90f216524b7c5fab1215aaa9192f917", 2026-10-14T02:08:35Z)
Vendored: 2026-10-14 (wave SEIF1014, change set CV352, `docs/DECISIONS.md` D-025; uncommitted at the time of writing)
Previous pin: eddb6ac ("Mirror contract from level-up-backend@a158daa33231f2d8d8812092d8c9f7745552362a", v3.46.0-m1), vendored 2026-10-09 (CW01, D-022) and committed in `b227f61`. Before it: 65245be (v3.38.0-m1, never committed) and 0df5cf4 (v3.28.0-m1, the last pin committed before `b227f61`).

info.version at this pin: 3.52.0-m1

Operation census at this pin, counted by parsing `paths` with a YAML parser (never
`grep -c "x-stability: …"` — header and description prose inflate both counts):
**89 stable · 0 draft · 89 total**. Of the 89, 4 are `x-consumers: [web]` and are forbidden to
the app (`listTerms`, `redeemSubscriptionCode`, `requestRedemptionSessionOtp`,
`verifyRedemptionSessionOtp`), leaving **85 stable operations the app may build against**; 21 are
public (`security: []`). An absent `x-consumers` means mobile. The previous pin (eddb6ac) was
**86 stable · 0 draft · 86 total** (82 app-buildable, 19 public); 65245be was 53 · 24 · 77
(49 app-buildable); 0df5cf4 was 38 · 16 · 54 (35 app-buildable).

All four vendored files are blob-identical to upstream `ded6213` (`git hash-object` on each equals
`git rev-parse ded6213:<file>`) and are **LF, as upstream stores them**: 0 CR bytes in each,
counted 2026-10-14 — first on a dry-run copy in a scratch folder outside the repo, then again on the
files in `contract/`. Blob ids at this pin: `openapi.yaml` `1f067289cd73da97f9bbf9491bdd6017f4d8c43d`,
`contract-changelog.md` `57dc8a4a37ceb6abcbbe76ae5e82743eeddffa71`, `error-codes.md`
`ab767838047042af51b970cf6a2e7aca77792a9b`, `realtime.md` `171e9ee361aa34db9cd7676dbfa182e8f11dcbd1`
— `git hash-object contract/<file>` re-checks them without a clone. Upstream stores all four as LF
(true at `0df5cf4`, `65245be`, `eddb6ac` and `ded6213` alike; an uncommitted 2026-10-07 edition of
this file once claimed CRLF, which was never true). Copy with
`git -C <clone> show <sha>:<file> > contract/<file>` from Git Bash or `cmd` — never a PowerShell `>`,
which writes UTF-16 — and never from a clone's checkout, which can hold CRLF (the local clone's
checked-out `realtime.md` does); `.gitattributes` keeps them LF here (`* text=auto eol=lf`).
`test/guards/contract_pin_test.dart` fails on any CR byte in these four files and on a version line
here that disagrees with `openapi.yaml`. All four changed in this delta.

## Delta from 3.46.0-m1 — six mobile versions (2026-10-14 re-vendor, SEIF1014)

Re-vendored on the owner's authorisation (the SEIF1014 prompt, 2026-10-14, D-025) to the upstream commit carrying
**3.52.0-m1**, because Seif's School-launch messages (`docs/SEIF_MESSAGE_2026-10-12_school-launch-stages.md`,
`docs/SEIF_MESSAGE_2026-10-13_school-stages-stable.md`) rest on `listSchoolStages`, which the old pin lacks. Upstream
moved **16 commits** past `eddb6ac` (2026-10-10 → 2026-10-14). Eight touch the mobile files (`1fdae81`, `cc2a29d`,
`56542a5`, `eeac4c5`, `f2c0b41`, `3718644`, `8ef3306`, `1b4b0d5`); the other eight touch only the admin files. Nine
commits carry 3.52.0-m1 (`8ef3306` … `ded6213`); the mobile blobs are identical from `1b4b0d5` on, and the newest,
`ded6213`, is pinned. `git fetch` and `git ls-remote` on 2026-10-14 returned `ded6213` for `HEAD` and `main`: no
version after 3.52.0-m1 exists upstream. In the same wave the app builds `listSchoolStages`, the `status` field and
the two registration codes (Job 2), and `listModules` (Job 3; it was already `stable` at the old pin).

| Version | Change | Breaking | App impact (SOURCE, read 2026-10-14 against the working tree) |
| --- | --- | --- | --- |
| 3.47.0-m1 | 🔴 Four behavioural items: **push-token cleanup** (the server drops the device's push registration on logout, on any new sign-in session, on a ban and on an accepted deletion request; `registerFcmToken` now declares `403 account_pending_deletion`); the **`leveledUp` ladder fix** (`finishQuiz`); **`422 name_not_allowed`** (`completeRegistration`, both bodies; `updateMyProfile` when the name is new or changed); the **recovery code lock** (`verifyParentOtp` + `confirmRecovery`: three failures, then a shared 30-minute lock that answers `429 otp_throttled` to every call). New **`stable`** `getAppVersionPolicy` (`GET /app/version-policy`, public). The deletion confirm copy no longer mentions paid time, refunds or subscriptions. `account_banned`: new suggested copy, and the client rule is now "the channel is email" (no anonymous support operation). Clarifications: `Retry-After` is whole seconds and absent from `otp_throttled`; inbox kind `enrolment_opened`; support-photo re-PUT / `503` / `413` / `422`; Terms enforced for photos; `flashcard_subscription_required` = zero cards deliverable; `avatar_not_found` unused; reviewer sign-in note; `getLeaderboard`/`getMyRank` re-stamped `x-behaviour-changed: 3.36.0-m1` (a relabel of an old change); `UniversityRegistration.inviteCode` prose | **BEHAVIOURAL** (`registerFcmToken`, `finishQuiz`, `completeRegistration`, `updateMyProfile`, `verifyParentOtp`, `confirmRecovery`) | Name filter: built ahead of the old pin (NNA), matched on `code`, token kept, never resent. Push, recovery, version policy, photos, friends, chat: not built, so no effect. `leveledUp`, `level`, `badges`: shown as sent or only parsed; nothing computes the ladder except Home's progress-bar target (below). `account_banned`: the app shows the OLD suggestion ("Account banned — contact Support"), now stale — follow-up 3. Deletion: not built (CW05). The four acknowledgments to Seif are still owed (`docs/BACKEND_HANDOFF.md` BH-B4) |
| 3.48.0-m1 | `listMyDailyTasks` (`GET /me/daily-tasks`) **`draft`**, tag `dailyTasks`, schemas `MyDailyTasksPage`, `MyDailyTask`, `DailyTaskSubject` | no | none (draft) |
| 3.49.0-m1 | `listMyDailyTasks` → **`stable`** | no | not built. Home's Daily Tasks block is a "Coming soon" placeholder whose stated premise ("no tasks endpoint") is now false — follow-up 4. The tag text still ends in "`draft`" (an upstream inconsistency; `x-stability` governs) |
| 3.50.0-m1 | **Production in `servers:`** (first entry `https://api.level-upworld.com/api/v1`; staging second); `realtime.md` names both chat hub hosts. Same version, 2026-10-12 entry, `openapi.yaml` unchanged: admins may correct university, faculty, subject and lecture names ("don't cache them across sessions"), open a `soon` Study Year for good, and remove an empty subject or lecture (an old id may then answer `404`) | no (server behaviour, no stamp) | The prod flavor still points at the fail-closed placeholder (`lib/core/config/app_config.dart:54`) — follow-up 5. Catalogue and `/me` names are held in memory and dropped at sign-out: compliant. `universitiesProvider` lives for the app process, so a corrected university/faculty name or a newly opened year stays stale until restart on the registration screens (low; University year picker out of SEIF1014 scope) — follow-up 6. A removed subject or lecture ends in the generic error with a Retry that cannot succeed — follow-up 7 |
| 3.51.0-m1 | `listSchoolStages` (`GET /reference/school-stages`) **`draft`**; `listEducationSystems` items gain **required** `status: active \| soon`; `completeRegistration` answers `422 school_stage_not_available` / `422 education_system_not_available` (School body only; after every `400`, before `name_not_allowed`; both closed → the stage code; token not consumed) | **BEHAVIOURAL** (`completeRegistration`, `listEducationSystems`) | Until SEIF1014 Job 2, the shipped School screen offered every stage and system as selectable and answered both codes with "Something went wrong" (it stayed on the screen with the draft and token; no name mark, no restart). Production applies the launch rule from its next deploy, so this mattered as soon as a prod base URL exists. Job 2 builds it |
| 3.52.0-m1 | `listSchoolStages`, the `status` field and the two codes → **`stable`**. 2026-10-13 note: AI explanations go through OpenRouter with safety checks (server only) | no | Job 2 builds against it. Explain stays gated on `AnswerResult.explanationAvailable` (unchanged) |

**Wire-shape audit** (both revisions parsed with PyYAML; descriptions, summaries and examples stripped): no
operation or schema was removed and no route moved. **3 operations added** (`listSchoolStages`,
`getAppVersionPolicy`, `listMyDailyTasks`) and **5 schemas** (`AppVersionPolicy`, `PlatformVersionPolicy`,
`MyDailyTasksPage`, `MyDailyTask`, `DailyTaskSubject`). Wire changes to pre-existing operations, all four of them:
`completeRegistration` (+ `422`), `listEducationSystems` (+ required `status` on its inline item), `updateMyProfile`
(+ `422`), `registerFcmToken` (+ `403`). The other 17 changed operations changed prose or stamps only. Three
component schemas changed prose only: `UniversityRegistration` (`inviteCode`), `StudentProfile` (`level`, `badges`),
`QuizSummary` (`leveledUp`). **All 13 schemas bound in `test/guards/contract_models_test.dart` are wire-identical**,
so the re-vendor alone needs no model, mock or fixture change. The app decodes one changed shape,
`listEducationSystems`' item (`EducationSystemRef`): before Job 2 the new key was simply ignored (nothing in `lib/`
sets `disallowUnrecognizedKeys`); Job 2 models it. `error-codes.md`: 62 → 65 codes (+ `name_not_allowed`,
`school_stage_not_available`, `education_system_not_available`), none removed; rows amended in place (see 3.47).
`realtime.md`: two bullets. `servers:` gains production. `listModules`, `listSubjects` and `getSubjectTree` are
byte-identical at the operation level.

**Follow-ups this delta surfaces — none is done by the re-vendor** (only SEIF1014 Jobs 2 and 3 build anything):

1. 🔴 **School launch availability** (3.51/3.52) — SEIF1014 Job 2 (`SEIF1014_REPORT.md`).
2. **The four 3.47 behavioural acknowledgments** to Seif — owner (BH-B4). Nothing in the app breaks under them.
3. **`account_banned`** — the app's line is the old suggestion and says "contact Support"; the contract now says the
   channel is email (`error-codes.md`, `account_banned` row). The comment at `lib/core/network/exceptions.dart:155-157`
   ("no signed-out Support route yet (a question for Seif)") is stale. A copy change needs the owner's approval.
4. **Daily tasks** (`listMyDailyTasks`, stable since 3.49) — not built; the Home placeholder's premise is stale.
5. **Production base URL** — the contract now carries it; the prod flavor still fails closed on a placeholder
   (environment wave, owner decision).
6. **Reference cache vs admin corrections** — `universitiesProvider` is process-lifetime (low severity).
7. **Removed subject or lecture** — a `404` lands on a generic error with a futile Retry (low; no code is documented).
8. **Home level card at Level 12** shows a 6,000 target (`lib/features/home/widgets/level_card.dart:41`, `:169`),
   a client-side figure the ladder does not have (Level 12 is at 5,500; the next milestone is the first badge at
   11,000). Pre-existing, already in BH-E10; the 3.47 text only states the ladder exactly.
9. **Stale wording, comments only:** `lib/features/registration/registration_error_copy.dart:106` and
   `lib/features/profile/profile_error_copy.dart:49` say `name_not_allowed` is "past the vendored pin (3.46.0-m1)";
   `lib/l10n/app_localizations.dart:431`, `:1769` and `:1775` (generated from the ARB `@` descriptions) cite "pin
   eddb6ac"; the NNA test headers (`edit_profile_name_not_allowed_test.dart:22`,
   `registration_name_not_allowed_test.dart:39`) say "ahead of the vendored 3.46.0-m1 pin". All are in other waves'
   uncommitted hunks and none is a test assertion, so none was changed (line numbers as of 2026-10-14, after SEIF1014).
10. **Answered upstream:** SQ-09 (push-token lifecycle), the chat-hub half of SQ-01, and SQ-24(l) / H-19 / I-5
    (`inviteCode` stable on both bodies) — record them as answered in the next handoff pass.
11. **Two upstream inconsistencies to mention to Seif:** the `dailyTasks` tag text still says `draft`; the
    `redemption_in_progress` wording (web only, no app impact).

⚠️ **Line-number drift.** `openapi.yaml` grows by 366 lines (4,935 → 5,301). Line 28 (`info.version`) changes in
place; the first insertion lands after old line 90 (inside `info.description`), so nearly every `openapi.yaml:NNN`
citation in `lib/` and `test/` is off by an irregular amount. Treat every citation as approximate.

## Delta from 3.38.0-m1 — eight mobile versions (2026-10-09 re-vendor, CW01, kept for history)

Re-vendored on the owner's authorisation (2026-10-09, D-022), as a contract update only: nothing is
built against it yet. Upstream moved 13 commits past 65245be (2026-10-07 → 2026-10-08); ten touch
the mobile files and three (`1df7b16`, `ddfef0e`, `4930a9c`) touch only the admin files.
`git ls-remote` at the start of CW01 (2026-10-09T13:12Z) and again immediately before the copy
(13:15Z) returned `eddb6ac` for `HEAD` and `main`.

| Version | Change | Breaking | App impact |
| --- | --- | --- | --- |
| 3.39.0-m1 | **22 operations `draft` → `stable`** (launch mode, adr-207): recovery (`startRecovery`, `verifyParentOtp`, `submitNewPhone`, `confirmRecovery`), chat (`listConversations`, `listConversationMessages`, `sendChatMessage`, `editChatMessage`, `deleteChatMessage`, `markConversationRead`, `reportChatMessage`, `reportStudent`), `transferToUniversity`, quiz review and favourites (`getQuizReview`, `addFavorite`, `removeFavorite`, `listFavorites`) and text-only support tickets (5). The entries that introduced them remain the specification | no | 22 newly buildable; none built |
| 3.40.0-m1 | `getLegalDocument` (`GET /reference/legal-documents/{document}`, public, Markdown, `ETag`/`304`, `404 legal_document_unavailable`) added as **`draft`**; `listQuizHistory` routed (+ `400` for a bad `cursor` or `limit`), still `draft` | no | none (draft) |
| 3.41.0-m1 | Inbox kind `support_ticket_replied` | BEHAVIOURAL (`listMyNotifications`) | none: the app calls no inbox operation; unknown kinds are ignored by rule |
| 3.42.0-m1 | 🔴 `403 account_banned` on `verifyOtp`, `verifyParentOtp`, `confirmRecovery` and (web) `verifyRedemptionSessionOtp` — only after the code is proven, no tokens issued, show "contact Support", do not retry. Inbox kind `moderation_warning` (fixed EN/AR text). A chat message removed by Support is a tombstone. Support photos (three **`draft`** operations; optional `attachmentIds` on two requests; a **required** `attachments` array on `SupportTicket` and `SupportTicketMessage`) and custom avatars (`uploadCustomAvatar` finalised at ≤ 2 MiB, new `removeCustomAvatar`, both `draft`); eight new error codes (`account_banned` and seven photo, avatar and Terms codes). `updateMyProfile` (prose): choosing a default `avatarId` also replaces an active custom avatar. **No `x-behaviour-changed` stamp marks any 3.41.0-m1 or 3.42.0-m1 change** — a stamp scan misses `account_banned` | **BEHAVIOURAL** | 🔴 **the app calls `verifyOtp` today and has no `account_banned` handling** (no match in `lib/`) — owed by CW02. The rest: none yet |
| 3.43.0-m1 | `getLegalDocument` and `listQuizHistory` → **`stable`**. Refer a Friend (`getMyInvite`; optional `inviteCode` on registration; `inviteCodeApplied` on the `201`), forwarded questions and friend streaks (`forwardQuestion`, `answerForwardedQuestion`, `listMyFriendStreaks`) as `draft`, with three new error codes. `ChatMessage` gains **required** `kind` (`text` / `forwardedQuestion`) and `forwardedQuestion`; five chat operations carry `x-behaviour-changed: '3.43.0-m1'`. Inbox kind `academic_year_opened`. `realtime.md` gains a Push notifications section (four kinds, eight localisation keys); push is off in every environment. Later, version unchanged: the chat hub connects with WebSockets only and `skipNegotiation: true` | **BEHAVIOURAL** (chat) | none yet: inbox, chat and push are unbuilt |
| 3.44.0-m1 | Refer a Friend and forwarded questions → **`stable`**, with hub events `forwardedQuestionAnswered` and `friendStreakChanged` | no | registration may now send an optional `inviteCode`; the app does not (no match in `lib/`) |
| 3.45.0-m1 | `forwardQuestion`'s `409 forwarded_question_already_pending` now fires per sender (FS-8) | BEHAVIOURAL (`forwardQuestion`) | none |
| 3.46.0-m1 | Support photos (`createSupportAttachmentUpload`, `completeSupportAttachment`, `getMySupportAttachmentContent`) and avatars (`uploadCustomAvatar`, `removeCustomAvatar`) → **`stable`** | no | none yet. The bytes go straight to storage at `upload.url` with exactly `upload.headers`; by owner rule (2026-10-09 brief) that `PUT` never goes through the signed-in Dio client, whose auth interceptor would send the app's bearer token to the storage host |

**Wire-shape audit** (descriptions and examples stripped, both revisions parsed with PyYAML): no
operation or schema was removed and no route moved; 9 operations and 10 schemas were added. Eight
pre-existing schemas changed shape: `ChatMessage` (+ required `kind`, `forwardedQuestion`),
`SupportTicket` and `SupportTicketMessage` (+ required `attachments`), `AuthenticatedResult`
(+ optional `inviteCodeApplied`), `SchoolRegistration` and `UniversityRegistration` (+ optional
`inviteCode`), `CreateSupportTicketRequest` and `PostSupportTicketMessageRequest` (+ optional
`attachmentIds`). Pre-existing operations whose declared responses changed: `verifyOtp`,
`verifyParentOtp`, `confirmRecovery` and `verifyRedemptionSessionOtp` (+ `403`);
`createSupportTicket` (+ `404`, `409`); `uploadCustomAvatar` (+ `400`, `403`, `413`, `429`, `503`);
`listQuizHistory` (+ `400`); `listMyNotifications` (the `kind` enum). `error-codes.md` gains 12
codes (50 → 62) and loses none. Of all this, the app decodes
only `AuthenticatedResult` (an optional field its decoder ignores — nothing in `lib/` sets
`disallowUnrecognizedKeys`) and sends only the two registration bodies (an optional field it does not
send). **No schema bound in `test/guards/contract_models_test.dart` changed shape**, so no model, mock or
fixture change came with this re-vendor. One bound schema changed prose only: `StudentProfile` —
`school.parentReportStatus` reads `active` only with delivery switched on **and** the delivery mode
`Production` (3.42.0-m1, spec-071; the app models it at `student_profile.dart:224` and no screen
reads it), and `avatar.id` / `avatar.url` now describe `custom` avatars (a new CDN url per upload). The new required fields sit on schemas no Dart class
decodes yet; their bindings land with the waves that first decode them. `servers:` is unchanged
(staging only), and `registerFcmToken` is unchanged.

**Follow-ups this delta surfaces — none is done by the re-vendor** (wave ids from
`.ai/audits/current/completion/04_COMPLETION_ROADMAP.md`):

1. 🔴 **`account_banned` on `verifyOtp`** (3.42.0-m1) — CW02.
2. **Inbox kinds** `support_ticket_replied`, `moderation_warning` and `academic_year_opened` — CW07,
   which must decode `kind` open-ended.
3. **Refer a Friend** — optional `inviteCode` / `inviteCodeApplied` and `getMyInvite` — CW15; the
   reward copy is unresolved.
4. **Every operation is now `stable`.** The 3.38.0-m1 delta's owner question on
   `transferToUniversity` (follow-up 5 below) and `docs/seif_fight.md` S11 (favourites) no longer
   turn on stability — CW14 and CW16a.
5. The 3.38.0-m1 delta's follow-ups 1 (`Accept: application/json`) and 2 (the interceptor comment)
   were done in CW00 (`.ai/audits/current/completion/01_SAFE_WORK.md` C1, C2).

⚠️ **Line-number drift.** `openapi.yaml` grows by 747 lines (4,188 → 4,935). Lines change in place
from line 28 (`info.version`); the first insertion lands after old line 229, so nearly every
`openapi.yaml:NNN` citation in `lib/` and `test/` is off by an irregular amount. The lecture's
`flashcardCount` property and `required` list, `:3812-3825` at 3.38.0-m1, are now `:4447-4460`
(+635). Treat every citation as approximate.

## Delta from 3.28.0-m1 — ten mobile versions (2026-10-07 re-vendor to 65245be, never committed; kept for history)

Re-vendored on the owner's request (2026-10-07), as a contract update only: nothing is built
against it yet. Upstream moved eight commits past 0df5cf4 (2026-10-06 → 2026-10-07). Three carry
the mobile contract — `cacb21b` (3.28.0-m1 → **3.36.0-m1** in one mirror commit), `285d5a8`
(3.37.0-m1) and `0fd8fc8` (3.38.0-m1); `8cd514a`, `0738d43`, `e4af85b`, `5733ce8` and `65245be`
touch only the admin files.

| Version | Change | Breaking | App impact |
| --- | --- | --- | --- |
| 3.29.0-m1 | Friend graph: twelve **`draft`** operations under `/friends`, `/friend-requests` and `/blocks`, new tag `social`, seven schemas used only by them (`StudentCard`, `Friend`, `FriendRequest`, `SendFriendRequestResult`, `PhoneLookupRequest`, `PhoneLookupResult`, `StudentIdBody`); `error-codes.md` + `friend_target_unavailable`, `friend_request_not_found` (404), `already_friends`, `friend_request_already_pending` (409) | no | see 3.37.0-m1 |
| 3.30.0-m1 | `listTerms` (`GET /reference/terms`), **`x-consumers: [web]`** | no | none: forbidden to the app |
| 3.31.0-m1 | Friend text chat: eight **`draft`** operations (`/conversations`, `/message-reports`, `/student-reports`), new tag `chat`, seven schemas; `realtime.md`'s `chat` hub goes "not drafted" → **`draft`** (`/hubs/chat`, Bearer or `access_token` query); `error-codes.md` + `conversation_not_found`, `message_not_found` (404), `message_edit_window_closed`, `message_delete_window_closed` (409) | no | none (draft) |
| 3.32.0-m1 | Corrections, prose only: OTP delivery is SMS only (`requestOtp`); 🔴 `ProblemDetails` no longer promises that every non-2xx carries a body — parse defensively, treat a body-less error like `internal_error`, and **send `Accept: application/json` on every call**; `redeemSubscriptionCode` (web) — a `500` is an UNKNOWN outcome, re-stamped `x-behaviour-changed: 3.21.0-m1 → 3.32.0-m1` | **BEHAVIOURAL** (web only: `redeemSubscriptionCode`) | two follow-ups below (Accept header, interceptor comment) |
| 3.33.0-m1 | `listMyNotifications`' `kind` enum gains `announcement` → `category: announcements`; its `data` is exactly `announcementId`, `titleAr`, `titleEn`, `bodyAr`, `bodyEn` — Admin-written display text, the one exception to the localization contract (plain text, never auto-linked) | no | none: the app calls no inbox operation |
| 3.34.0-m1 | `getMyQuizSummary` (`GET /me/quiz-summary`) → `{ solvedQuestions }`: distinct questions ever answered correctly, lifetime and cross-track. 🔴 Not `QuestionCounter.answered` — never derive or reconcile it | no | see 3.37.0-m1 |
| 3.35.0-m1 | Support tickets, still **`draft`**: `SupportTicketStatus` documents `in_progress` and `pending`; `SupportTicket` and `SupportTicketSummary` gain a **required** `reference` (`TK-{n}`, a display label — never an id) | no | none (draft) |
| 3.36.0-m1 | `getLeaderboard` / `getMyRank` exclude students blocked in either direction with the caller; `rank` is dense per caller. Prose only — wire unchanged, **no `x-behaviour-changed` stamp** | no | the board decodes unchanged. "Do not compare or cache ranks across accounts": `leaderboardProvider` is `autoDispose` (`leaderboard_notifier.dart:197`) |
| 3.37.0-m1 | **Fifteen operations `draft` → `stable`**: `listModules`, `getMyQuizSummary`, all twelve friend-graph operations, and `listTerms` (web). The entry's prose also says "18 `x-stability` values change … mobile for 17 of the 18"; the YAML has exactly **15** flips (parsed) — the headline's 15 is the true count | no | **14 newly buildable for the app** (35 → 49). None is built; each needs design and a FORMULATE first |
| 3.38.0-m1 | `transferToUniversity` (`POST /me/track-transfer`) — School → University, once and for good, `secondary3` only — **`draft`**; `error-codes.md` + `track_transfer_not_allowed` (409), `track_transfer_not_eligible` (403); the reserved-codes line now reads "none at present" | no | none (draft). ⚠️ The entry says "the screens may be built against it now (Q-45.1, contract-first)" — that conflicts with this file's build-only-against-`stable` rule and needs an owner ruling before any wave picks it up |

**Wire-shape audit** (descriptions stripped, both revisions parsed): no operation or schema was
removed; no route moved. The only wire change to a pre-existing operation is the
`listMyNotifications` `kind` enum (3.33.0-m1). The only pre-existing schemas whose shape moved are
`SupportTicket` and `SupportTicketSummary` (3.35.0-m1, draft-only). `LeaderboardEntry`,
`ProblemDetails` and `SupportTicketStatus` changed in prose only, as did `getLeaderboard`,
`getMyRank`, `requestOtp` and `requestRedemptionSessionOtp`. **No schema bound in
`test/guards/contract_models_test.dart` changed**, so no model, mock or fixture change came with
this re-vendor. `servers:` is unchanged (staging only), and `registerFcmToken` is unchanged.

**Follow-ups this delta surfaces — none is done by the re-vendor:**

1. **`Accept: application/json` (3.32.0-m1).** `lib/core/network/dio_client.dart:19` sets only
   `Content-Type`. Under HTTP semantics an absent `Accept` does not exclude JSON, so the app is not
   expected to hit the no-body case today — `[UNVERIFIED]` on the wire (no request was captured) —
   but the contract now asks for the header on every call.
2. **A stale comment, not stale code.** `lib/core/network/interceptors/error_interceptor.dart:10`
   says every non-2xx body is ProblemDetails; 3.32.0-m1 withdrew that promise. The code at `:25-27`
   already falls back to `code: 'unknown'` for a body without `code`.
3. **`docs/seif_fight.md` S24 and S36 are answered upstream.** S24 ("Solved Questions" has no
   source) → `getMyQuizSummary`, though as its own read rather than the `GET /me` field S24 asked
   for. S36 (Friends screen, no endpoint) → the stable friend graph; its second half — no entry
   point in the Profile hub — is a design question and is still open. The `TODO(contract)` on
   `lib/features/account_shells/screens/friends_screen.dart` now cites a gap that no longer exists.
4. **`docs/seif_fight.md` S11 (favourites) stays open.** `addFavorite`, `removeFavorite`,
   `listFavorites` and `getQuizReview` are still `draft`, waiting on a design check (3.37.0-m1).
5. **Owner ruling: `transferToUniversity`** — draft, but upstream invites building its screens now.

⚠️ **Line-number drift.** The first insertion lands after old line 137 (the new `social` and `chat`
tags), and the file grows by 1,083 lines (3,105 → 4,188), so every `openapi.yaml:NNN` citation past
line 137 is off by an irregular amount. The `flashcardCount` cite `openapi.yaml:2889-2902` is now
`:3812-3825` (+923), and the lecture's `required` list `:2902` is now `:3825`. Treat every citation
in `lib/` and `test/` as approximate.

## Delta from 3.27.0-m1 — one mobile-visible version (2026-10-04 re-vendor, kept for history)

Re-vendored on the owner's request (2026-10-04), as a contract update only: nothing is built
against it yet. Upstream moved one commit past f462968 (`0df5cf4`, 2026-10-01). It touches
`openapi.yaml` (+18 / −7) and `contract-changelog.md` (+6) only; the admin files did not move.

| Version | Change | Breaking | App impact |
| --- | --- | --- | --- |
| 3.28.0-m1 | The notification inbox goes **`draft` → `stable`**: `listMyNotifications` (`GET /me/notifications`), `getUnreadNotificationCount` (`GET /me/notifications/unread-count`), `markNotificationRead` (`POST /me/notifications/{notificationId}/read`), all mobile-only (no `x-consumers`). Each inbox item gains a **required** `category` (`system` / `announcements` / `support`, derived server-side from `kind`; today `enrolment_opened` → `system`, so the other two stay empty until a kind maps to them). `listMyNotifications` gains an optional `?category=` filter; an unknown value is the existing `400 validation_failed`. The unread count stays the total across all categories (changelog, 2026-09-26) | no | none yet: the app calls none of the three (the Home bell is inert and its unread dot is off, DESIGN_ISSUES #41; `/message` is a placeholder). An inbox needs owner and design rulings and a new FORMULATE first |

Clients MUST ignore an item whose `kind` they do not recognise and an unknown `category` value. The
3.19.0-m1 entry's push guidance still stands: this is an inbox, not push, so no push-permission
prompt or "notifications enabled" indicator is to be built from it. No `x-behaviour-changed` stamp and no
breaking entry. `getUnreadNotificationCount` and `markNotificationRead` keep their shapes. No schema
the app decodes changed, and no schema bound in `test/guards/contract_models_test.dart` changed (the
inbox item is an inline schema no Dart class decodes), so no model, mock or fixture change came with
this re-vendor.

⚠️ **Line-number drift.** Lines 1–988 keep their numbers (only line 28, `info.version`, and line 983,
the first of the three `x-stability` flips, change in place). The inbox block grows by 11 lines: old lines 989–1008 move
by +7 or +10, and every `openapi.yaml:NNN` citation past old line 1008 is now off by **+11**. The
`flashcardCount` cite `openapi.yaml:2878-2891` (in `subject_tree.dart` and its generated
`subject_tree.freezed.dart`) is now `:2889-2902`, and the single-line cite `openapi.yaml:2891` (the
lecture's `required` list, in those two files, `mock_backend.dart` and `catalog_models_test.dart`)
is now `:2902`.
Citations written against earlier pins were already approximate.

## Delta from 3.23.0-m1 — four mobile-visible versions (2026-09-29 re-vendor, kept for history)

Re-vendored on the owner's Wave 22 ruling (2026-09-29): the Flash Card Setup screen needs
`flashcardCount`, which only 3.27.0-m1 carries. Upstream moved seven commits past ea83099
(`96888a1`, `38a6550`, `6597313`, `d6d182b`, `0c44071`, `df955cc`, `f462968`); some touch only the
admin files, which are deliberately not vendored.

| Version | Change | Breaking | App impact |
| --- | --- | --- | --- |
| 3.24.0-m1 | `getQuizReview` (`GET /quizzes/{quizId}`) and `listFavorites` corrected — both still **`draft`**; `error-codes.md` + `quiz_not_finished` (403) | no | none: the app calls neither (the review is built from the in-memory session) |
| 3.25.0-m1 | `getTermsAcceptance` / `acceptTerms` **`draft` → `stable`** | no | stable but inert in every environment (`currentVersion: null`) and no design exists; not built |
| 3.26.0-m1 | five **`draft`** `/support/tickets` operations, new tag `support`; `error-codes.md` + `ticket_closed` (409) | no | none (draft) |
| 3.27.0-m1 | `UniversitySubjectTree.lectures[]` gains a **required** `flashcardCount` (`openapi.yaml:2878-2891`); `hasFlashcards` is exactly `flashcardCount > 0`; "one `pageSize=10` page per round" (changelog, 2026-09-25) | no | `Lecture.flashcardCount` added in the same change, with the mock and test fixtures — without it `test/guards/contract_models_test.dart` goes red |

No `x-behaviour-changed` stamp and no breaking entry. Both flashcards operations, their schemas,
`EntitlementType` / `EntitlementState`, `CursorPage` and `ProblemDetails` are unchanged.

⚠️ **Line-number drift.** New text lands at several places, so `openapi.yaml:NNN` citations in
`lib/` / `test/` comments written against earlier pins are approximate.

## Delta from 3.22.0-m1 — one mobile-visible commit (2026-09-24 re-vendor, kept for history)

Upstream moved three commits past 768e67d (`bc27953`, `200073c`, `ea83099`). The first two touch
**only** the admin files (`openapi-admin.yaml`, `error-codes-admin.md`,
`contract-changelog-admin.md`), which are deliberately not vendored. Only `ea83099` touches the
mobile contract:

| Version | Commit | Change | Breaking |
| --- | --- | --- | --- |
| 3.23.0-m1 | ea83099 | `GET /me/terms-acceptance` (`getTermsAcceptance`) and `POST /me/terms-acceptance` (`acceptTerms`) added — **both `draft`**, mobile-only (no `x-consumers`). Inert in every environment until the server configures a Terms version: `currentVersion: null`, every accept is `400 validation_failed`. Records the student's own acceptance — **not** parent consent | no |

Files changed: `openapi.yaml` (+62/−1: one new path, two operations, version line) and
`contract-changelog.md` (+9). `error-codes.md` and `realtime.md` are byte-identical to the previous
pin. No existing operation, schema, field, response, error code, `x-stability` value or
`x-behaviour-changed` stamp changed. **No new operation is buildable** — the delta adds two drafts.

⚠️ **Line-number drift.** The new path is inserted after old line 913, so every `openapi.yaml:NNN`
citation in `lib/`/`test/` comments that points past ~913 is now off by **+61**. The citations
were already a mix of pins (`184d6ec`, 3.13.0-m1, 768e67d); treat them as approximate.

The notes below are the 3.13.0-m1 → 3.22.0-m1 delta, kept for history; they were written at the
768e67d pin and its counts are that pin's.

Four operations became `stable` across this delta, and **only one of them is the app's to build**:
`registerFcmToken` (mobile). The other three are `x-consumers: [web]` — `redeemSubscriptionCode`,
`requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`.

## Why this pin moved, and what it unblocked

Re-vendored because the previous pin was **nine minor versions behind** and, more seriously, was
**actively misleading about `getExplanation`**. At 2dca3c5 that operation is published `stable`
while carrying a note saying there is no backend route and that `AnswerResult.explanationAvailable`
is "a hard `false`". Version 3.14.0-m1 discharges that note: the route is live, the surface is
gated on `baseSubscription`, it gains a `429`, and `explanationAvailable` becomes a real
per-question signal. **No `x-behaviour-changed` stamp was added** — Seif's reasoning is that an
operation with no route has no shipped behaviour to change. That reasoning does not hold for this
client, which shipped `lib/features/quiz/widgets/ai_explanation_panel.dart` anyway, so a
stamp-based scan for the dangerous class misses the single most consequential change in this delta.

⚠️ **The re-vendor this pin performs is the one `docs/DECISIONS.md` D-008 was waiting on.** The
leaderboard gate's comment at `lib/core/router/app_router.dart:152-158` claims `GET /leaderboard`
is "`x-stability: draft` AT OUR PIN". That was already false at 2dca3c5 (it is `stable` there) and
is false here. The remaining step is D-008's middle one — audit the board against the behavioural
changes it predates — not another re-vendor.

## Delta from 3.13.0-m1 — nine version bumps, one commit each, newest first

Full text in `contract-changelog.md`. Nothing was adopted between these two pins.

| Version | Commit | Change | Breaking |
| --- | --- | --- | --- |
| 3.22.0-m1 | 768e67d | `StudentProfile.school.parentReportStatus` added — optional, `active`/`inactive`, **School track only**. Reads `inactive` for every student and nothing is delivered to any parent. No `pending` value, ever | no |
| 3.21.0-m1 | bfa6cdd | Both redemption-session operations → `stable`; 🔴 `redeemSubscriptionCode` gains `redemption_in_progress`, splitting "still running" out of `redemption_scope_only` | **BEHAVIOURAL** (web) |
| 3.20.0-m1 | 9f4aacc | Redemption-scoped web session arrives (2 `draft` ops); `redeemSubscriptionCode` replays the original success for the same student instead of `409` | **BEHAVIOURAL** (web) |
| 3.19.0-m1 | 083183d | In-app notification **inbox** arrives: `listMyNotifications`, `getUnreadNotificationCount`, `markNotificationRead` — all three `draft` | no |
| 3.18.0-m1 | c0b63a1 | `registerFcmToken` → `stable`. **The only mobile stability unlock in this delta** | no |
| 3.17.0-m1 | 03adccc | `registerFcmToken` route goes live and declares `400 validation_failed` (absent/empty/whitespace token, >4096 chars, non-JSON body — no `415`, ever) | no |
| 3.16.0-m1 | fe4dab2 | `redeemSubscriptionCode` → `stable` (web) | no |
| 3.15.0-m1 | 62fa6ba | `redeemSubscriptionCode` route goes live; declares `400` and `429` (web) | no |
| 3.14.0-m1 | a42b84d | 🔴 **`getExplanation` IS NOW IMPLEMENTED** — the "DELIBERATELY UNIMPLEMENTED" note is gone, the surface is **subscription-gated** on `baseSubscription`, a `429 rate_limited` is added, and `explanationAvailable` stops being a hard `false` | no (but see above) |

Codegen surface of the whole delta, for a client that hand-writes its models: one added optional
property (`parentReportStatus`), one added `429` (`getExplanation`), one added `400`
(`registerFcmToken`), one added `500` (`redeemSubscriptionCode`, web). `error-codes.md` gains two
rows — `redemption_in_progress`, and narrowed wording on `redemption_scope_only` — both web-only.
**`realtime.md` has not changed since the initial contract commit (`23f0535`)** and is byte-identical
here; no realtime work is implied by this delta.

🔴 **Two of the four newly-stable operations are the first `stable` paths the app is FORBIDDEN to
call.** Every previously-forbidden operation was also `draft`, so "build only against
`x-stability: stable`" was sufficient protection on its own. At this pin it is not: `stable` must
now be read together with `x-consumers`. The three web-only stable operations are
`redeemSubscriptionCode`, `requestRedemptionSessionOtp` and `verifyRedemptionSessionOtp`; the app
is purchase-silent (adr-049 §3/§4) and must never build any of them.

The version string 1.4.0-m1 is PERMANENTLY INVALID — briefly published 2026-08-14, reverted
~15 minutes later without a changelog entry. Discard any document labelled 1.4.0-m1 on sight.

## Staging

**2026-10-09:** an unauthenticated `GET /health/version` on staging reports backend
`a158daa33231f2d8d8812092d8c9f7745552362a` (`Staging`, built 2026-10-08T15:16:14Z) — the backend
commit this pin mirrors. That is the only staging read made for this re-vendor; no operation was
re-probed, so the paragraph below still stands.

**Not re-probed at this pin, and the last observation is now stale by more than the delta.** The
most recent probe is 2026-09-22 against backend `0f97f289852b76a2762865169fb5efba909e7c1e` (built
2026-09-22T07:54:38Z), recorded in `.ai/audits/current/smoke-staging-2026-09-22.md`: exit 0, every
arm decoded, including `GET /leaderboard`, `PATCH /me` (200) and `GET /me/entitlements` (200). The
probe before it, 2026-09-04 against backend `78c6e5dc7c0a287046ea5428fa72c3cdebf3c9c1`
(`smoke-staging-2026-09-04.md`: 13 of the then-21 stable operations decode, `PATCH /me` 405,
`GET /me/entitlements` 404), is superseded and should not be quoted as current. **Every operation
this delta unblocks is UNOBSERVED**, and the smoke harness itself
(`tool/smoke/real_api_smoke_test.dart`) still walks the 2026-08-23 operation set plus the leaderboard
arm added 2026-09-22 — it is stale against the *previous* pin, never mind this one. The three inbox
operations made stable at 3.28.0-m1, and the fifteen made stable at 3.37.0-m1, have never been
probed on staging.

For the Mistakes pair, re-probing cannot help: `seif_fight.md` **S44** — the only staging test
account (`+2010000000001`, school-track) has an empty catalog, so it can never hold a graded wrong
answer and both operations will answer empty regardless of whether they are deployed.

## Rules

The source repo also carries `openapi-admin.yaml`, `error-codes-admin.md` and
`contract-changelog-admin.md` — the admin SPA's contract (adr-050). They are deliberately NOT
vendored: the app has never consumed them and they are not the mobile partner's surface.
All three moved in the 2026-09-29 delta (ea83099 → f462968); none moved in the 2026-10-04 delta
(f462968 → 0df5cf4); all three moved again in the 2026-10-07 delta (0df5cf4 → 65245be), where
every one of the eight commits touches at least one of them, and again in the 2026-10-09 delta
(65245be → eddb6ac). That is Badawy's document, not ours.

Do NOT edit these files here — they are Seif's owned artifact. When Seif publishes a
new version, re-copy from the source repo and bump the commit above. Build ONLY against
paths marked `x-stability: stable` **and not marked `x-consumers: [web]`**.
