# Notification inbox after contract 3.28.0-m1 — investigation

**Date:** 2026-10-04 · **Type:** read-only investigation; nothing was implemented · **Branch:** `merged`
**Contract pin:** `0df5cf4` (`info.version` 3.28.0-m1), vendored in `03fd7cf`
**HEAD:** `03fd7cf` when the investigation started; `f4cd5a9` from 22:04:09, when a peer session committed (§11)

Every claim cites its source and carries one of these tags:

| Tag | Source |
| --- | --- |
| **[CONTRACT]** | `contract/openapi.yaml`, `contract-changelog.md`, `error-codes.md` or `realtime.md` |
| **[CODE]** | app source at the cited line |
| **[FIGMA]** | file `P6044i0giD9TmdQ7C2AmLq`, read with `get_metadata` on 2026-10-04 |
| **[RECORD]** | a project record or brief |
| **[INFERENCE]** | my conclusion; not written anywhere, never a requirement |

Line numbers are working-tree lines on 2026-10-04. `PARENT` means a file in `F:\level\`, outside the repo.

---

## 1. Executive summary

- **What 3.28.0-m1 changes.** The three inbox operations go `draft` → `stable`:
  - `listMyNotifications`
  - `getUnreadNotificationCount`
  - `markNotificationRead`

  Each item also gains a required `category`, and the list gains an optional `?category=` filter. The app may now build an in-app inbox that it polls: a paged list with tabs, a total unread count, and mark-one-read. There is no push, realtime, delete, mark-all-read, detail view or navigation target.
- **What the backend sends today.** Exactly one kind exists, `enrolment_opened`: a welcome item written after a student's first enrolment opens. It belongs to `system`. Nothing maps to `announcements` or `support` yet.
- **What the product briefs ask for.** The inbox is in contracted scope for two purposes: admin broadcasts, and the end-of-year promotion prompt ("did you move up a year?", leading to the School→University transfer). **The contract has no kind for either.**
- **What the app has.** It calls none of the three operations. The only preparation is presentational:
  - an inert Home bell, whose unread dot is gated behind a permanently false flag;
  - the `/message` "Coming soon" placeholder;
  - four disabled notification toggles in Settings;
  - a reusable `CursorPage<T>` model.

  There is no data path. There is also no Firebase, push, deep-link or notification state.
- **What Figma has.** Two Notifications frames, `180:8386` and `309:9525`. They have chips All (6) / Announcements / Support / System / Promotions, and six sample rows, each with an icon, title, body, category pill, relative time and unread dot.
  - **The sample rows are kinds the contract does not have.**
  - **Two sample rows are purchase offers.**
  - No row is drawn for `enrolment_opened`.
  - No detail or empty-state frame was found.
- **The records disagree on where the inbox lives.** One audit table maps it to the Home bell; another audit row, and a code comment, map it to the Message tab. Neither is an owner or designer ruling.
- **Recommendation: INVESTIGATE FURTHER.** The opportunity is real and in scope, and the contract is close to enough for a minimal inbox. Six dependencies are open (§7):
  - D1: the EN/AR copy for `enrolment_opened`;
  - D2: the entry point;
  - D3: what tapping a row does;
  - D4: what "All (N)" counts;
  - D5: the Promotions chip and the sample kinds (an owner ruling the records already ask for);
  - D6: the dark and Arabic frame values (investigable).

  **D1 must come first**: without it, the only item that exists cannot be rendered. D2–D6 could be carried as wave gates, as Wave 22 did. The operations have also never been probed on staging. "READY TO FORMULATE, owner-gated" is the closest alternative; §9 explains why it was not chosen.

---

## 2. The three newly stable operations

All three are `x-stability: stable` (`openapi.yaml:983,1033,1052`). None carries `x-consumers`, which by the header rule means mobile-only (`openapi.yaml:34-45`). The changelog agrees: "none of the three carries `x-consumers`" (`contract-changelog.md:7`). [CONTRACT]

| | `listMyNotifications` | `getUnreadNotificationCount` | `markNotificationRead` |
| --- | --- | --- | --- |
| Method and path | `GET /me/notifications` (`openapi.yaml:980-1029`) | `GET /me/notifications/unread-count` (`:1030-1048`) | `POST /me/notifications/{notificationId}/read` (`:1049-1069`) |
| Tag | `profile` | `profile` | `profile` |
| Request | `cursor` (opaque; omit for the first page), `limit` (1–100, default 20), `category` (optional; `system`, `announcements` or `support`; absent means All) (`:987-995`; components `:2454-2464`) | none | path `notificationId`, a UUID (`:1056`) |
| Success | `200` `CursorPage` with `items`, `nextCursor` and `hasMore` (`:1005-1023`; `CursorPage` `:2481-2488`) | `200 {unreadCount: integer ≥ 0}` (`:1037-1045`) | `204`, no body (`:1058-1061`) |
| Declared errors | `400 validation_failed`: bad cursor, `limit` out of range, or unknown `category` (`:1024-1026`). `401` (`:1027-1029`). | `401` | `404 not_found` (`:1062-1066`). `401` (`:1067-1069`). |
| Auth | global `bearerAuth` (`:110-111`); no per-operation override | same | same |

**Item shape** (`openapi.yaml:1014-1023`). All six fields are required:

| Field | Type | Line |
| --- | --- | --- |
| `notificationId` | `Uuid`, an opaque UUIDv7 (`:2549-2553`) | `:1017` |
| `kind` | enum `[enrolment_opened]` | `:1018` |
| `category` | enum `[system, announcements, support]` | `:1019` |
| `data` | object of string values, with no key list | `:1020` |
| `createdAt` | date-time | `:1021` |
| `readAt` | date-time or `null` | `:1022` |

---

## 3. Contract behaviour

| Topic | What the contract says | Where |
| --- | --- | --- |
| **Ordering** | Newest first. `?category=` uses the same newest-first cursor paging. | `openapi.yaml:985,999`; changelog `:9` |
| **Pagination** | Cursor keyset. `nextCursor` "Absent/null = no more pages". Branch on `hasMore`, never on `items.length`. | `:1001`, `:2481-2488`; changelog `:94` |
| **Category** | Derived server-side from `kind`. `enrolment_opened` → `system`. No kind maps to `announcements` or `support` yet, so those tabs return empty pages. | `:993-994,1001-1002`; changelog `:8` |
| **Unread count** | "Always the total" across tabs; there is no per-tab count. Zero is an ordinary answer. | `:994`, `:1038`; changelog `:9` |
| **Read/unread** | `readAt` is nullable, and the first mark-read sets it. So `null` reads as "not yet read". The contract implies this rather than stating it in one sentence; the count's summary is "How many … are unread". Mark-read is idempotent: `readAt` is set once and never moved, and a retry is `204` again. | `:1022`, `:1035`, `:1058-1061`; changelog `:95` |
| **Unknown values** | Clients **MUST ignore** an item whose `kind` they do not recognise, and **MUST ignore** an unknown `category` value. | `:1002-1004`; changelog `:10` |
| **Rendering** | `kind` + `data` is a localization contract, not display text. The client renders its own string for each `kind` and substitutes `data`. The backend ships no Arabic or English copy, and will not. | `:999-1001`; changelog `:92` |
| **Personal data** | `data` never contains personal data. It holds ids, counts and category names. | changelog `:93` only |
| **`enrolment_opened`'s `data` keys** | **Not documented anywhere.** `data` is `additionalProperties: string`. | `:1020`; grep of `contract/` |
| **Ownership and `404`** | No operation takes a student id; the owner is the token's bearer. An unknown id and another student's id are both `404 not_found`, byte-identically and permanently. Do not treat that as a defect. | `:1062-1066`; changelog `:96` |
| **Realtime / state sync** | None. The inbox "is polled over these three operations and has no SignalR surface". `realtime.md` lists only the `leaderboard`, `streaks` and `chat` hubs, all "not drafted". | changelog `:90,97`; `realtime.md:5-11` |
| **Push** | "This is an INBOX. It is not push." No delivery pipeline exists. Do not build a "notifications enabled" indicator, delivery-state UI or push-permission prompt from this entry. 3.28 states "No push-channel change". | changelog `:97`, `:7` |
| **Deliberately absent** | Delete or dismiss, mark-all-read, a per-kind filter, an unread-only filter, a preferences or mute surface, a consent endpoint, an admin or staff view of anybody's inbox, realtime push. | changelog `:98` |
| **When items appear** | "Today exactly one": a welcome item written by a background job shortly after a student's first enrolment opens. An inbox that is empty right after sign-up is normal. The contract does not say whether a later enrolment writes another; a track transfer opens a new enrolment. | changelog `:99`; `openapi.yaml:1225-1226` |
| **Global rules** | Any authenticated operation can return `401 session_superseded` / `authentication_required`, and `403 account_pending_deletion` during deletion grace. That rule is default-deny, and these three are not among its four exceptions. | `openapi.yaml:54-83`; `error-codes.md:13,20,45` |
| **Rate limits** | None declared. | `:980-1069` |
| **Cross-endpoint dependency** | None, except that mark-read takes an id the list returned. | `:1049-1069` |

**The wording on unknown kinds tightened.** 3.19.0-m1 said an unrecognised `kind` "must be skipped **or rendered generically**" (changelog `:92`). 3.28.0-m1 and `openapi.yaml` now say "**MUST ignore**" (`:1002-1004`; changelog `:10`), and the later, stricter rule governs. 3.28.0-m1 does not restate or retract the other 3.19.0-m1 bullets: no personal data, polling, not push, and the list of absent features. Nothing in it contradicts them. 3.19's "no per-kind filter" and 3.28's new per-*category* filter are different things, so they do not contradict either. [CONTRACT]

---

## 4. Existing Flutter support

### 4a. Wired, but adjacent — no notification code [CODE]

| What | Where |
| --- | --- |
| Generic freezed `CursorPage<T>`, already used by the leaderboard and flashcards repositories | `lib/features/registration/models/reference_models.dart:122`; `leaderboard_repository.dart:39,58`; `flashcards_repository.dart:67,77` |
| Five-tab shell. Message is tab index 3, with no badge. | `lib/features/shell/main_shell.dart:56-62` |
| A refetch on app resume, for entitlements only | `lib/features/profile/notifier/me_notifier.dart:81` |
| Connectivity providers, and the `OfflineBanner` widget | `lib/core/providers/core_providers.dart:52-55`; `lib/core/widgets/offline_banner.dart:12` |
| Paging notifiers built on `CursorPage` | `leaderboard_notifier.dart`, `lecture_flashcards_notifier.dart`, `school_search_notifier.dart` |
| Pushed screens outside the shell, which cover the nav bar (`/refer`, `/support`, `/friends`). A navigation precedent for D2. | `lib/core/router/app_router.dart:408-423` |
| The sign-out invalidation registry. It has no notification provider. | `lib/core/session/session_scope.dart:58-103` |
| The `403 account_pending_deletion` handling is **a predicate only**. There is no interceptor: `ErrorInterceptor` maps `401`, `400 validation_failed` and `429 rate_limited`, and turns everything else into `ApiException`. Each feature applies the predicate in its own error copy and suppresses Retry itself. The contract's "route to the cancel screen" is not implemented. | `lib/core/network/exceptions.dart:95-135` (`:127-129`); `lib/core/network/interceptors/error_interceptor.dart:29-41` |
| The shared `StateWidget`. Its default empty and offline text is hardcoded English ('Empty', 'Offline'), so a new screen must pass localized text. | `lib/core/widgets/state_widget.dart:38,52` |

### 4b. Inert or placeholder [CODE]

**Home bell** (`lib/features/home/widgets/home_header.dart`):
- It has no tap handler.
- Its doc reads "intentionally INERT … there is no notifications endpoint in the contract" (`:14-17`). That has been stale since 3.19.0-m1 (draft) and is wrong since 3.28.0-m1. `api_ui_endpoint_inventory.md:97` (F10) already flags it.
- `hasUnreadNotifications` defaults to `false` (`:23`, `:36`), with a TODO citing DESIGN_ISSUES #41 (`:29-35`). Its only caller passes no flag (`home_screen.dart:83`).
- The dot is built and token-coloured: `bellUnreadDot`, `#E67E22` light / `#AE87E7` dark (`app_colors.dart:277-283`, whose comment repeats "no notifications endpoint").
- `test/features/home/home_header_unread_test.dart` pins the dot as absent by default.

**`/message` tab:**
- The route is at `app_router.dart:311-318`.
- `MessagePlaceholderScreen` is documented as "the in-app inbox (admin broadcasts, end-of-year promotion)" (`tab_placeholder.dart:54`). It renders "Coming soon".
- `test/features/shell/main_shell_test.dart:121-133` pins it: "no endpoint exists for it" (`:127`).
- `customer_support_screen.dart:9-11` describes "the whole Message tab" as part of the designed support surface (S33).

**Settings, Notification Preferences** (`settings_screen.dart:341-421`, a dirty Wave 21 file):
- There are four switches: Announcements / Promotions / Support / System.
- Each is `value: true` with no `onChanged`, so disabled (TODO S28).
- `test/features/settings/settings_screen_test.dart:425-494` asserts they are non-interactive.

**ARB keys that exist:**
- `notifications`: the bell's semantic label (`app_en.arb:195`, `app_ar.arb:114`).
- `navMessage`: EN "Message", AR "الرسائل".
- `settingsNotifications`.
- `notifAnnouncements`, `notifPromotions`, `notifSupport`, `notifSystem` (`app_en.arb:629-632`).
- `settingsNotificationsUnavailable`.

**Mock backend:** its header pins `f462968` / v3.27.0-m1 (`lib/dev/mock_backend.dart:19-20`), which is stale. It has no `/me/notifications*` or `/me/fcm-token` route, so an unmocked call becomes a 404 problem (`:553-561`).

### 4c. Does not exist [CODE]

Searched case-insensitively across `lib/`, `test/`, `android/`, `ios/`, `pubspec.*`, `assets/` and `tool/`. None of these exist:
- **Inbox data path:** any API method, model, repository, notifier or provider for `/me/notifications*`, and any notification route.
- **Push registration:** FCM token registration. `registerFcmToken` is never called.
- **Packages:** `firebase_*`, `firebase_messaging`, `flutter_local_notifications`, `permission_handler`, `app_links`, `uni_links`. The only websocket packages are transitive and unused.
- **Android manifest:** `POST_NOTIFICATIONS`, an FCM `<service>`, deep-link intent-filters. It has only `INTERNET` and MAIN/LAUNCHER.
- **iOS:** `UIBackgroundModes` `remote-notification`, `aps-environment`, associated domains, URL schemes.
- **Polling and refresh:** notification polling (the only `Timer.periodic` is the OTP countdown), and `RefreshIndicator` anywhere in `lib/`.
- **Storage keys:** none for notifications. `preferences_store.dart:35-36` holds only theme and locale.
- **Badge or count widgets.**
- **Relative-time strings** such as "5 min ago". No ARB key exists; `intl` is a dependency (`pubspec.yaml:56`).

**Conclusion:** the existing preparation is presentational only. It is the bell, its gated dot and token, the placeholder tab, four disabled toggles, and a reusable paging model.

---

## 5. Existing product and Figma evidence

### 5a. Explicitly designed or planned

**The inbox is in contracted scope** [RECORD]. PARENT `00_project_brief_and_team_model.md:102-105` says "These features are now **in scope**" (contract v2 final). It names:
- **Admin broadcast**: "Admin web composer → FCM → in-app inbox".
- **End-of-year promotion notification**: admin-triggered; asks whether the student moved up a year; makes the School→University transfer explicit for 3rd-secondary.

The same scope appears in:
- `02_role_flutter_partner.md:50`
- `03_role_uiux_partner.md:36` ("In-app inbox / notifications center")
- `Start_Here_Flutter.md:31`
- `project.md:90,266`
- in the repo, `skills/level-up-domain/SKILL.md:58`

**None of these briefs says which tab or entry point hosts the inbox.** Support tickets carry "FCM notify-on-reply" (`02_role_flutter_partner.md:49`). [RECORD]

**The Figma Notifications frames, `180:8386` and `309:9525`** [FIGMA], are structurally identical. The records list them as a pair (`endpoint_ui_mapping.md:126,166`).
- **Header:** back arrow, title "Notifications", hidden share icon. There is no nav bar.
- **Chip row** (`180:8554`): **All (6)**, Announcements, Support, System, **Promotions**. The row overflows its 362 width, so it scrolls.
- **Six rows** (`180:8844`). Each is a "Button" frame with a 40×40 category icon tile, title, two-line body, category pill and relative time:
  1. "New Biology Quiz Available!" (Announcements, 5 min ago), unread dot shown
  2. "Premium Offer — 40% Off!" / "Upgrade to Premium…" (Promotions, 2 hrs ago), dot shown
  3. "Daily Streak! 🔥" (System, 1 day ago), no dot
  4. "Ticket #1042 Updated" (Support, 2 days ago), no dot
  5. a repeat of row 1, dot hidden
  6. a repeat of row 2, dot hidden
- **Read and unread states are both drawn**, distinguished only by the 8×8 dot.

**A dark Notifications frame probably exists, but no record gives its id.** [INFERENCE from two RECORD lines] `DESIGN_ISSUES.md:2849-2850` (and `edit1.md:250`) count "Notifications (G5 ×46)" Glass, and Glass is dark-only (`:2506`). The same passage lists it among screens whose Glass is "not built".

**The Home bell and its unread dot** are `59:1466` (light) and `337:5330` (dark), already built (DESIGN_ISSUES #41, `docs/DESIGN_ISSUES.md:1008-1041`). [RECORD][CODE]

**Settings Notification Preferences** (`176:1840` / `309:8452`) has four toggles with the same four names as the inbox chips (`seif_fight.md:1213-1230`, S28). [RECORD]

### 5b. Mentioned but unresolved [RECORD]

| Item | Status, owner | Where |
| --- | --- | --- |
| **Where the inbox lives — the records conflict.** "Home bell → Notifications inbox". "Message tab · Inbox list + mark read". `/message` is "the in-app inbox". "Message tab — fully designed (`Messages`, `Customer support chat`, `Create Ticket`, `Customer Support` ×3)". The nav Message icon's Figma layer is `icon/footer/notification/off`. "Which one the … notification operations feed is not settled by the frames." **Neither side is an owner or designer ruling.** The bell is an audit table's "Future destination" column; the Message tab is an audit row plus a code comment; the S33 support reading is a brief and a code comment. | open, owner/designer | `endpoint_ui_mapping.md:126`; `screen_api_gaps.md:43`; `tab_placeholder.dart:54`; `day8_account_brief.md:386-387`; `customer_support_screen.dart:9-11`; `DESIGN_ISSUES.md:669`; `endpoint_ui_mapping.md:148-150`; `wave_state.md:148` (dirty) |
| The Promotions chip and "Premium Offer" rows conflict with purchase-silence, and "Daily Streak" has no contract field. "Both need owner rulings before this is built." | open, owner | `endpoint_ui_mapping.md:126`; `wave_state.md:146-147` (dirty) |
| **The "Message" tab and store review.** APL-11 (class **A**): a placeholder primary tab is "a near-certain 2.1 … rejection". POL-12 / REV-06: "Rename or remove it" in a product declared for 13–17. Removing it is a nav-bar redesign. REV-09 also recommends hiding the four notification toggles. | open, product + frontend | `store_readiness_audit.md:45`; `store_readiness_parts/12_policy_gap_analysis.md:1190-1194`; `16_reviewer_walkthrough.md:254,332,409-415`; `19_blindspots_apple.md:477-480` |
| DESIGN_ISSUES #41, "confirm with Seif whether an unread count is coming" | answered by the contract (3.19 draft, 3.28 stable); the record was not updated | `docs/DESIGN_ISSUES.md:1040-1041` |
| S28: no contract storage for notification preferences | open, Seif; still true in 3.28 | `docs/seif_fight.md:1213-1230`; changelog `:98` |
| "Wait for stable" for the bell badge and the inbox | the trigger has fired; the record is stale | `screen_api_gaps.md:42-43` |
| Push: stable `registerFcmToken`, but no Firebase. Firebase is gated on D-021 app identity. Rubric 8a ("push in v1 or deferred") is ❌. | open, owner | `endpoint_ui_mapping.md:52-62`; `docs/ENVIRONMENTS.md:293,299`; `docs/RISKS.md:136` (R-9); `docs/STORE_READINESS_RUBRIC.md:66-68`; `docs/STORE_READINESS.md:230` |

**History** [RECORD]:
- **Day 4:** the bell was a "static icon, no badge, no action" (`day4_home_brief.md:50-51`).
- **Day 8:** the Notifications screen was "out of Day 8 entirely. Do not add a route." (`day8_account_brief.md:249-254`).
- **Waves 01–22:** excluded `/message` ("no stable operation exists", `figma_ui_comparison.md:18-23`). Wave 05 Home listed "bell (draft)" as out of scope (`implementation_waves.md:141`).
- **Status:** no DECISIONS or RISKS entry covers the inbox.

### 5c. Backend-only capability [CONTRACT]

- **`?category=`** serves Announcements and Support tabs, which are empty under 3.28.
- **The unread total** has no per-tab split.
- **`enrolment_opened`:** no design draws it, and no product or design record mentions it. Only the contract-delta record `contract/SOURCE.md:27` names it.

### 5d. My inferences, not requirements [INFERENCE]

- **The Figma Messages set looks like friend-to-friend chat.**
  - `162:2797` draws a "Messages" title with camera and people icons, a "Suggestions Friends" carousel ("Level 8", add buttons) and conversation rows ("Sent new photo", "Seen", a 🔥 20 streak), with the nav bar instance `162:2908`. [FIGMA]
  - `realtime.md:11` lists a `chat` hub for "Friend chat messages/photos". [CONTRACT]
  - The Notifications frame, by contrast, has a back arrow and no nav bar, which is consistent with a pushed screen, plausibly from the bell.
  - **But** the Message icon is named `notification` in Figma. I read no prototype links. Navigation intent is the owner's (CLAUDE.md rule 4). **Not established.**
- **"End-of-year promotion"** in `tab_placeholder.dart:54` and the briefs means the school-year advancement prompt, not a commercial offer. It must not be conflated with Figma's Promotions chip.

### 5e. Not checked

- The dark and Arabic Notifications node ids.
- Figma prototype links.
- A whole-page Figma text search. That was avoided under the exposed-credential rule, and node `1240:9847` was never read.

---

## 6. Backend → frontend gap analysis

### A. Does 3.28.0-m1 enable a new user-visible feature?

**Yes:** a polled in-app inbox, with a paged list and tabs, a total unread count, and mark-one-read. [CONTRACT] The count would naturally feed the Home bell's dot, but the contract does not mention the bell. [INFERENCE]

**Today's content is one kind:** a welcome item written after a student's first enrolment opens (`enrolment_opened` → `system`; changelog `:99`). The briefs' two purposes, broadcasts and the end-of-year prompt, have no kind in 3.28.

### B. Is the contract enough for a basic inbox?

| Capability | In 3.28? | Evidence |
| --- | --- | --- |
| List and pagination | ✅ | `:987-1023`, `CursorPage` |
| Refresh | ✅ by re-requesting the first page. [INFERENCE] The contract describes no refresh mechanism, and there is no "since" parameter. | `:987-995` |
| Category tabs | ✅ All + 3 | `:989-995` |
| Unread count | ✅ total only | `:1030-1048` |
| Mark one read | ✅ idempotent | `:1049-1061` |
| Per-item read state | ✅ `readAt` | `:1022` |
| Timestamps | ✅ `createdAt` | `:1021` |
| Type | ✅ `kind` (one value) and `category` | `:1018-1019` |
| Retry and error semantics | ✅ `400`/`401`/`404`, global `403`, idempotent mark-read | `:1024-1029,1062-1069`; `:54-83` |
| **Display copy for `enrolment_opened`** | ❌ client-owned; `data` keys undocumented | changelog `:92`; `:1020` |
| Mark all read | ❌ deliberately absent | changelog `:98` |
| Delete or dismiss | ❌ deliberately absent | changelog `:98` |
| Notification detail | ❌ no get-one operation, no body field | `:980-1069` |
| Navigation target or deep link | ❌ no field | `:1014-1023` |
| Total count (Figma "All (6)") | ❌ only `unreadCount` and `hasMore` | `:1037-1045`, `:2481-2488` |
| Per-tab unread count | ❌ deliberately total only | changelog `:9` |
| Realtime | ❌ polling only | changelog `:90,97` |
| Push token | ✅ `registerFcmToken` exists, but "Nothing is sent to this token yet" | `:896-918`; changelog `:97,114` |
| Preferences or mute | ❌ deliberately absent | changelog `:98`; S28 |
| Free-form admin broadcast text | ❌ no field; `data` is "ids, counts and category names", and the backend "ships no … copy" | changelog `:92-93` |

**Verdict:** yes for a minimal inbox that renders `enrolment_opened`, **once the client copy for it exists**. The contract cannot back the design's "All (N)", row tap targets or detail view, or any of its sample kinds.

### C. Is backend work needed beyond 3.28.0-m1?

**For a minimal inbox: no new operation, but a few clarifications and one verification step.**
- **`data` keys.** Seif publishes the keys of `enrolment_opened`, needed only if the copy interpolates them. Static copy needs nothing. [CONTRACT `:1020`]
- **Cursors across categories.** The contract does not say whether a cursor issued under one `category` is valid under another. It says only "a cursor this API issued" (`:1025`). A client with four tabs would keep one cursor per tab.
- **The R1 and R3 questions** (§8).
- **Staging (verification, not backend work).** "The three inbox operations made stable at 3.28.0-m1 have never been probed on staging" (`contract/SOURCE.md:155-156`), and the smoke harness predates them (`:152-155`). Their staging behaviour is unobserved.

**For the contracted product scope, yes** [RECORD vs CONTRACT]:
- kinds for admin broadcasts and for the end-of-year prompt;
- an answer path for "did you move up a year?" and the School→University transfer (none in 3.28);
- how admin-authored broadcast text fits a contract whose items carry no display text.

**Also open:** the unread count versus kinds the client ignores (R1). Push delivery does not exist in any environment (changelog `:97`).

### D. Frontend work beyond API integration (categories only)

- **Data layer:**
  - a freezed item model (it is an inline schema, so `contract_models_test.dart` does not cover it today);
  - lenient decoding of `kind` and `category`. Both are closed enums in the schema (`:1018-1019`), but unknown values MUST be ignored (`:1002-1004`), so a strict enum decode would break that rule;
  - one cursor per category tab;
  - polling that **stops** on `403 account_pending_deletion`. The contract says "do **not** retry" (`openapi.yaml:82-83`), and the app has only a predicate, no interceptor (§4a);
  - a repository for the three calls;
  - notifiers for the per-tab list, the count and mark-read;
  - registration in `session_scope.dart` for sign-out. This is mechanised: `test/core/session/session_scope_discipline_test.dart:103` fails the suite if a session-scoped provider is not cleared on sign-out. `project_rules_test.dart` also bans provider mutation in `initState` (BUG-001), which constrains "mark-read on view" and when a poll starts.
- **Dark canvas:** the dark Notifications frame's Glass values. Raw elevation effects are guard-banned outside the elevation folders (`test/guards/project_rules_test.dart:190`), so dark rows, chips and pills need measured tokens. The frame's node id is not recorded (§5a, D6).
- **UI:**
  - the inbox screen: tabs, rows, the unread dot, relative time;
  - the bell's dot fed from the count;
  - the route and entry point.
- **Copy (EN + AR):**
  - the string for `enrolment_opened`;
  - tab labels (the `notif*` keys exist);
  - a localized empty, error and offline state per tab (`StateWidget` defaults are English). Two tabs will always be empty under 3.28.
  - relative time ("5 min ago"). That touches the open designer ruling "Latin digits in Arabic (#19)" (`implementation_waves.md:493`).
- **State sync:**
  - when to poll (Home load, app resume, return from the inbox);
  - whether mark-read happens on tap or on view.

  The contract specifies neither; each is a product decision.
- **Mock and tests:**
  - `mock_backend.dart` routes;
  - unit, widget, golden and router tests;
  - possibly a guard for the inline item schema.
- **Records and comments to sync** (stale today):
  - `home_header.dart:14-17,29-35`
  - `app_colors.dart:281-282`
  - `home_header_unread_test.dart`
  - `main_shell_test.dart:124-127`
  - `test/goldens/design_goldens_test.dart:106-112` (pins the bell without the dot)
  - `tab_placeholder.dart:54`
  - DESIGN_ISSUES #41
  - `screen_api_gaps.md:42-43`
  - `wave_state.md:145-148`
- **Not needed for the inbox:** Firebase, `POST_NOTIFICATIONS`, APNs or a permission prompt. The contract says to poll, and forbids a push-permission prompt from this entry (changelog `:97`). The inbox therefore does **not** depend on D-021 or R-9.

---

## 7. Missing dependencies

D1 must be answered before FORMULATE. D2–D6 can be answered before FORMULATE, or carried into it as wave gates (the Wave 22 pattern, §9).

| # | Dependency | Who | Why it blocks |
| --- | --- | --- | --- |
| **D1** | **EN and AR copy for `enrolment_opened`** (title, and body if any), and whether it interpolates `data` (if so, Seif publishes the keys) | owner/designer; Seif for keys | The contract makes copy client-owned (changelog `:92`). No frame draws this kind. Translations are "never invent" (CLAUDE.md rule 4). Without the copy, the only item that exists cannot be rendered. |
| **D2** | **Entry point:** the Home bell pushes Notifications `180:8386`, **or** the inbox is the `/message` tab. If it is the tab, the store-review "rename or remove the Message tab" items apply. | owner/designer | Navigation intent is "never invent". The records conflict (§5b). |
| **D3** | **Row tap:** mark-read only, or navigate somewhere (the contract has no target field) | owner/designer | Rows are "Button" frames with no destination frame. |
| **D4** | **"All (N)":** drop the number, or show `unreadCount` | owner/designer | The contract has no total. Using `unreadCount` changes the label's meaning. |
| **D5** | **The Promotions chip, and the sample rows' kinds** ("Premium Offer", "Daily Streak") | owner | The records say "both need owner rulings before this is built" (`endpoint_ui_mapping.md:126`; `wave_state.md:146-147`). |
| **D6** | **The dark and Arabic Notifications frames:** node ids and Glass values | investigable (Figma desktop or the dev plugin), then designer if absent | Dark elevation must come from measured tokens (`project_rules_test.dart:190`). The dark frame's id is not recorded (§5a). |

**What existing rules already cover**, though the records still ask for the D5 ruling:
- **"Premium Offer — 40% Off!" / "Upgrade to Premium" rows.** A price discount and an upgrade link are exactly what adr-049 §3 / D-007 forbid: "never a paywall, a price, an upgrade link, or where to buy" (`docs/DECISIONS.md:256-258`). No such row can be built.
- **The Promotions chip itself.** It is not a payment surface. But the contract has no `promotions` category, so a Promotions tab would always be empty. Dropping it follows "the contract wins" (CLAUDE.md rule 1), but that is my reading, not a recorded ruling. The app already ships a disabled "Promotions" toggle in Settings (`settings_screen.dart:401-405`).
- **Sample kinds.** "New Biology Quiz", "Daily Streak" and "Ticket #1042" are not in the `kind` enum, so the app cannot show them. Whether the backend should add any of them is a product question.

---

## 8. Risks and questions

- **R1 — the unread dot may not clear.** [INFERENCE from contract text; not a contract statement]
  - **What the text says:**
    - the count is server-side: "How many of the caller's own inbox items are unread" (`:1035`);
    - new kinds will be added (changelog `:10`);
    - clients MUST ignore unknown kinds (`:1002-1004`);
    - there is no mark-all-read (changelog `:98`).
  - **The risk:** if an installed app meets a kind it does not know and simply skips the item, the count includes items the inbox never shows, and the dot stays lit.
  - **What the text does not say:**
    - that the count includes unrenderable kinds. `:994` says only that the `category` filter does not change it;
    - that "ignore" forbids a silent, idempotent mark-read of such an item. Every item carries a `notificationId` (`:1023`), and mark-read needs nothing else (`:1056`).
  - **Possible client answers** (product choices, not contract):
    - quietly mark unknown-kind items read;
    - derive the dot from the list instead of the count;
    - accept the risk.
  - **Question for Seif:** which is intended?
  - Latent today, with one kind.
- **R2 — low content value.** Until broadcast or end-of-year kinds ship, the inbox holds only the welcome item, and two of its three category tabs stay empty. [INFERENCE]
- **R3 — an ambiguous rule.** "MUST ignore an unknown `category` value" changes object from the first clause. The first clause ignores the *item* with an unknown `kind`; the second ignores the *value*. The literal reading is: keep the item, and disregard its category for tab placement. Low impact, because `category` is derived from `kind` (`:1001-1002`). A question for Seif.
- **R8 — not observed on staging.** The three operations have never been probed (`contract/SOURCE.md:155-156`). The contract is the only evidence of how they behave.
- **R4 — scoping.** Wiring the bell's dot without the inbox would point at nothing, and `home_header.dart:14-17` already argues against a tap that goes nowhere. The dot and the screen belong in one change. [INFERENCE]
- **R5 — the Message tab and store review cut both ways.**
  - If the inbox is hosted elsewhere, the Message tab stays a "Coming soon" placeholder. APL-11 calls that a class-A, "near-certain 2.1" rejection risk (`store_readiness_audit.md:45`).
  - If the inbox is hosted in the tab, the placeholder goes away, but the "Message" label issue remains (POL-12 / REV-06: rename or remove).
  - Either way, D2 interacts with an open store-readiness decision (§5b).
- **R6 — stale records.** Until the files in §6.D are synced, a reader would conclude the feature is still blocked.
- **R7 — concurrent sessions.** A peer committed during this investigation (§11). Any FORMULATE should re-snapshot first.

**No conflict found with:**
- **Privacy and minors:** `data` carries no personal data (changelog `:93`), and the no-logging rule in CLAUDE.md applies as usual.
- **Authentication:** the bearer token is global. The `401` refresh/forced-logout path is an interceptor. `403 account_pending_deletion` is **not** intercepted, so the inbox must apply the predicate itself and must not retry or keep polling (§6.D). New routes are default-deny under the auth redirect (`app_router.dart:44-83`).
- **Screenshot protection:** `FLAG_SECURE` is scoped to quiz screens (`day7_quiz_brief.md:430`).
- **Offline:** the app has no caching layer, so offline means the offline state, as on every other screen.

**Dependencies, not conflicts:**
- **Design system.** Colours and type come from tokens, and the bell dot has one. The dark canvas needs measured Glass tokens from a frame whose id is not recorded (D6).
- **RTL.** The usual AR/EN requirements apply. Relative time touches the open "Latin digits in Arabic (#19)" designer ruling (`implementation_waves.md:493`).
- **Session discipline.** The new providers fall under the mechanised sign-out guard (`session_scope_discipline_test.dart:103`).

**Conflicts:**
- **Purchase-silence:** the Promotions offer rows.
- **Store review:** the Message tab, either way D2 goes (R5).

---

## 9. Recommendation — **INVESTIGATE FURTHER**

**The strongest case against: READY TO FORMULATE, owner-gated.**
- D1–D5 are owner or designer rulings, and no further investigation answers them (D6 is investigable).
- The repo has a precedent for formulating with gates. Waves 21 and 22 were formulated as "build (gated)", with the owner inputs listed (`implementation_waves.md:55-56,444-448`; `wave_state.md:161,170-179`).
- The re-vendor record already framed the next step as "owner and design rulings and a new FORMULATE" (`contract/SOURCE.md:27`).

That reading is defensible.

**Wave 22 is the closest precedent, and it is close.** It was also a new screen: "entry point: **none drawn**", route "decide with the owner", and "**five design answers** first". It was still formulated as a gated wave (`implementation_waves.md:465-472`). An undecided entry point (D2), row tap (D3) and "All (N)" (D4) do not, on their own, block FORMULATE.

**Why INVESTIGATE FURTHER is still chosen:**
- **D1 is different in kind.** Wave 22's content comes from the API: cards carry their own text. Here the only kind that exists carries no display text by contract (changelog `:92`), and no frame draws it.
  - Without D1, a formulated wave would have no renderable item, and its acceptance criteria could not be written without inventing copy (CLAUDE.md rule 4).
  - The surface itself is also contested between records (D2: Home bell, or the Message tab, where the store-review "rename or remove" items apply). In Wave 22, the route under the Lectures view was at least proposed.
- **Two dependencies are investigable, not owner-only:**
  - The three operations have **never been probed on staging** (`contract/SOURCE.md:155-156`).
  - This investigation **did not read** Figma prototype links, or the dark and Arabic Notifications node ids (§5e). Either could inform D2 and D3 before the owner is asked.

**Why not BACKEND-ONLY / NO CURRENT APP WORK, or NOT RELEVANT:**
- The inbox is explicitly in contracted app scope (PARENT `00_project_brief…md:102-105`, `02_role_flutter_partner.md:50`).
- Figma draws it (`180:8386` / `309:9525`).
- The bell, dot, token and toggles already wait for it.
- The operations are now stable and mobile-only.

**What flips this to READY TO FORMULATE:**
1. An owner/designer answer to D1. If it needs interpolation, Seif publishes the `enrolment_opened` keys. D2–D6 can be answered at the same time, or carried as wave gates.
2. Optional, but cheap and useful before asking: a read-only staging probe of the three operations, and a read of the Figma prototype links and the dark/Arabic Notifications frames.

If the owner prefers the Wave 22 pattern — formulate now and carry D1–D6 as wave gates — that is a legitimate choice, and the owner's to make. This document's recommendation is only that D1 be answered first.

R1 and R3 are worth raising with Seif in parallel, but they do not block a minimal inbox. The broadcast and end-of-year kinds are a later backend dependency for the full scope; they do not block a first inbox.

---

## 10. Evidence and references

**Contract (pin `0df5cf4`):**
- `contract/openapi.yaml`:
  - `34-45` (consumers)
  - `54-83` (global auth and deletion grace)
  - `110-111` (security)
  - `896-918` (`registerFcmToken`)
  - `980-1069` (inbox)
  - `2454-2464` (Cursor, Limit)
  - `2481-2488` (CursorPage)
  - `2549-2553` (Uuid)
- `contract/contract-changelog.md`:
  - `7-11` (3.28.0-m1)
  - `18-26` (support tickets, 3.26.0-m1)
  - `90-100` (inbox draft, 3.19.0-m1)
  - `102-116` (FCM, 3.17/3.18)
- `contract/openapi.yaml:1035,1222-1228` (count summary; a track transfer opens a new enrolment)
- `contract/error-codes.md:9,13,20,21,45,50`
- `contract/realtime.md:5-11`
- `contract/SOURCE.md:27-30,144-157`
- `.ai/audits/current/implementation_waves.md:55-56,444-448,465-472` and `wave_state.md:161,170-179` (the gated-FORMULATE precedent)
- Added after review:
  - `lib/core/network/interceptors/error_interceptor.dart:29-41`
  - `lib/core/network/exceptions.dart:127-135`
  - `lib/core/widgets/offline_banner.dart:12`
  - `lib/core/router/app_router.dart:44-83,408-423`
  - `lib/features/account_shells/screens/customer_support_screen.dart:9-11`
  - `test/core/session/session_scope_discipline_test.dart:103`
  - `test/guards/project_rules_test.dart:190`
  - `test/goldens/design_goldens_test.dart:106-112`
  - `.ai/audits/current/store_readiness_audit.md:45` (APL-11)
  - `store_readiness_parts/16_reviewer_walkthrough.md:254,332`
  - `docs/DECISIONS.md:256-258`
  - `edit1.md:250`
- `git diff fa88b3a 03fd7cf -- contract/openapi.yaml`

**Code:**
- `lib/features/home/widgets/home_header.dart:11-36,79-151`
- `lib/features/home/screens/home_screen.dart:83`
- `lib/core/theme/app_colors.dart:277-283`
- `lib/core/router/app_router.dart:311-318`
- `lib/features/shell/screens/tab_placeholder.dart:7,54-61`
- `lib/features/shell/main_shell.dart:56-62`
- `lib/features/settings/screens/settings_screen.dart:341-421` (dirty)
- `lib/dev/mock_backend.dart:1-20,553-561`
- `lib/features/registration/models/reference_models.dart:122`
- `lib/features/profile/notifier/me_notifier.dart:81`
- `lib/core/session/session_scope.dart:58-103`
- `lib/core/network/exceptions.dart:95-135`
- `lib/core/storage/preferences_store.dart:35-36`
- `lib/core/widgets/state_widget.dart:38,52`
- `lib/l10n/app_en.arb:195,257,629-633`
- `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`, `pubspec.yaml`

**Tests:**
- `test/features/home/home_header_unread_test.dart`
- `test/features/shell/main_shell_test.dart:121-133`
- `test/features/settings/settings_screen_test.dart:425-494`

**Records:**
- `.ai/audits/current/`:
  - `endpoint_ui_mapping.md:52-62,126,148-150,166-168`
  - `screen_api_gaps.md:42-43`
  - `api_ui_endpoint_inventory.md:97`
  - `figma_ui_comparison.md:18-23`
  - `implementation_waves.md:141,493`
  - `wave_state.md:145-148` (dirty)
  - `store_readiness_parts/12_policy_gap_analysis.md:1189-1194`, `16_reviewer_walkthrough.md:409-415`, `19_blindspots_apple.md:476-480`
- `docs/`:
  - `DESIGN_ISSUES.md:669,1008-1041,2506,2849-2850`
  - `seif_fight.md:1213-1230`
  - `DECISIONS.md:253-262`
  - `ENVIRONMENTS.md:293,299`
  - `RISKS.md:136`
  - `STORE_READINESS.md:230`
  - `STORE_READINESS_RUBRIC.md:66-68`
  - `day4_home_brief.md:50-51`
  - `day7_quiz_brief.md:430`
  - `day8_account_brief.md:249-254,386-387`
- `skills/level-up-domain/SKILL.md:58`
- PARENT `F:\level\`:
  - `00_project_brief_and_team_model.md:102-107`
  - `02_role_flutter_partner.md:49-50`
  - `03_role_uiux_partner.md:36`
  - `Start_Here_Flutter.md:31`
  - `project.md:90,266`

**Figma** (read-only `get_metadata`, 2026-10-04; connector identity: a third-party student account):
- `180:8386` and `309:9525` (Notifications)
- `162:2797` (Messages)
- Node `1240:9847` was never read.

---

## 10a. Independent review (2026-10-04)

Two read-only Sonnet reviewers challenged the first draft.

**Contract and recommendation reviewer:**
- **Confirmed:** every operation, field, error and behaviour reading, and every §2/§3 line.
- **Overstatements fixed:**
  - `readAt: null` was presented as a contract statement;
  - "refresh" and the bell were tagged as contract;
  - "at most one item per student";
  - "nothing is ever sent";
  - R1 was stated as a contract fact.
- **Added:** the staging-unprobed gap, cursor-per-category, lenient enum decoding, and the Wave 21/22 gated-FORMULATE precedent.
- **On the status:** INVESTIGATE FURTHER is "defensible". It argued "READY TO FORMULATE, owner-gated" is at least as well supported. §9 now argues both, and rests the choice on D1.

**App, Figma, records and integrity reviewer:**
- **Confirmed:**
  - the integrity claims (the HEAD, the 24 entries, the one new file, nothing staged, no lib/test/contract mtime after 21:00 other than the re-vendor);
  - every §4c absence;
  - the Figma frame descriptions.
- **Factual error fixed:** the draft claimed a `403` interceptor; there is none.
- **Mislabels fixed:**
  - Promotions was "already decided"; it is now D5;
  - the dark frame was presented as a record; it is an inference;
  - the provenance of the entry-point records was not stated.
- **Added:**
  - APL-11;
  - the session-scope guard and the elevation guard (D6);
  - the stop-polling-on-`403` rule;
  - the shell-escaping pushed routes;
  - the support reading of the Message tab;
  - the golden to sync.
- **Off-by-one lines fixed:** `wave_state.md` and `main_shell_test.dart`.

---

## 11. Scope statement and integrity

**No implementation was performed.** Nothing was changed in:
- Dart code, tests, mocks or contract files;
- Figma;
- `wave_state.md`, `KNOWN_BUGS.md`, `seif_fight.md`, `DESIGN_ISSUES.md`, or any other record or comment.

No wave was created and FORMULATE was not run. Nothing was committed, pushed, merged, reset, cleaned, stashed or reverted. **This file is the only file the investigation created.**

**A concurrent change, not made by this investigation:**
- At 22:04:09, a peer session (Environment & Architecture chapter) committed `f4cd5a9` on `merged`.
- That commit took 8 of the 32 dirty entries recorded at the start: `docs/DECISIONS.md`, `PROJECT_GUIDE.md`, `RISKS.md`, `WAVE_STATUS.md`, `ENVIRONMENTS.md`, `STORE_READINESS_RUBRIC.md`, `.ai/audits/current/app_identity_environment_audit_2026-10-04.md` and `env_chapter_state.md`. It also committed its own `env_wave0_report.md`.
- Those 8 files were byte-identical on disk to this investigation's baseline.
- The other 24 entries stayed byte-identical throughout (sha256 per file), and `git diff HEAD --binary` hashes to `231061a3…`, the same as right after `03fd7cf`.
