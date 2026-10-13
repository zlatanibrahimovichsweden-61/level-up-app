# Design handoff — draft for owner review (2026-10-09)

> **Lead review (Opus control plane, 2026-10-09).** Drafted by Sonnet, adversarially verified by a second Sonnet agent, composed with the verifier's findings applied, then reviewed by the lead. Workflow run `wf_6986d53d-04f`. Nothing in this file has been sent to anyone.

**Message to the designer (ready to send)**

Hi, we are building the Level Up student app for Release 1. The backend is now ready for much more than the Figma file covers. We need new frames, redrawn frames and a set of missing states. The rows below say exactly what.

A polished happy path alone is not enough for any of these screens. Every screen and flow needs these states drawn:
- loading
- empty
- error with Retry
- offline
- permission denied or not asked
- denied or refused by the server
- upload failure (for photos)

Arabic (RTL) and English (LTR) are required, in light and dark, with a University twin wherever a School frame exists.

Rules that apply to every frame:
- **No camera.** There is no camera permission and no camera flow anywhere.
- **Chat is text only.** There is no photo, voice or group chat.
- **No purchase surface.** The app shows no paywall, price, upgrade, checkout or "where to buy". A limit card keeps its title, body and "Not now" only.
- **No own leaderboard rank.** Do not draw a self-rank number or a pinned self row.
- **Do not invent copy, points, rewards or streak rules.** Where the copy is not supplied, write `[[COPY: owner]]` and keep going. The server decides all numbers.
- **Use only the existing tokens and type scale.**
- **Rows marked HELD are not final.** Draw a clearly labelled placeholder or skip them until we rule.

Please return one table in the format of section 8. Order it P0 first, then P1, then P2. For every redraw, give the old and the new node id.

**Basis.** The evidence is repo records and the contract only (SOURCE level). Figma was not opened.

**Citation keys**
- Contract at eddb6ac: `oa` = openapi.yaml, `ec` = error-codes.md, `rt` = realtime.md, `cl` = contract-changelog.md.
- Repo records:
  - PED = .ai/audits/current/PRE_EXECUTION_DISCOVERY.md
  - DI = docs/DESIGN_ISSUES.md
  - EUM = .ai/audits/current/endpoint_ui_mapping.md
  - NIN = .ai/audits/current/notification_inbox_3_28_investigation.md
  - FUC = .ai/audits/current/figma_ui_comparison.md
  - WS = .ai/audits/current/wave_state.md
  - RRR = .ai/audits/current/release_readiness_reconciliation_2026-10-06.md
- Node ids come from the repo records. A line is cited where one is given. Otherwise the default sources are PED:1119-1123 (screen census), PED:1958-1990 (Figma coverage table) and EUM:144-147.
- Anything the records do not name is written NEW FRAME REQUIRED or NOT KNOWN.

**Contract status.**
- All 86 operations are `x-stability: stable` at eddb6ac, including the avatar and support-photo operations. PED:1961-1962 still lists those as draft, which is stale.
- Four operations are `x-consumers: [web]` and are never designed for: `redeemSubscriptionCode`, `requestRedemptionSessionOtp`, `verifyRedemptionSessionOtp`, `listTerms`.

**Applies to every row** (unless the row says otherwise):
- EN and AR copy, RTL for Arabic, light and dark.
- A University twin wherever a School frame exists.
- Priority:
  - P0 = store blocker, or an owner-mandated item that cannot be deferred (deletion, banned account, the Message tab flow).
  - P1 = Release-1 feature.
  - P2 = completeness.

---

## 1. Missing required screens

| ID | Screen / flow | Existing frame / node id | States / variants | Entry -> destination | Backend ops assumed | Open rule / owner | Pri |
|---|---|---|---|---|---|---|---|
| DG-01 | Account deletion: request, confirm, success | NEW FRAME REQUIRED. No deletion frame exists (WS:1606-1607; DI:2048-2064). | **Confirm screen** must show, before the call: reversible only within 30 days by logging in again; a new account on the same phone starts from zero; the phone stays blocked until erasure (`oa:1282-1291`). **The confirm paragraph is HELD:** the contract text mentions "paid" and "refund" (`oa:1284-1285`). Draw a placeholder slot only (H-02). `effectiveAt` means "no earlier than", up to about 24 h late (`oa:1271-1273`). States: submitting, 409 `deletion_already_requested` -> DG-02, offline, error. Success: the session is already revoked, so go to Login (`oa:1274-1277`). | Settings (new row) -> confirm -> success -> Login | `requestAccountDeletion` oa:1267 | Q-B2 to Seif (never filed); store blocker E-3 (RRR:71) | P0 |
| DG-02 | Pending-deletion screen, cancel, post-cancel | NEW FRAME REQUIRED | Shown after login when `GET /me` has `pendingDeletion`, and on any 403 `account_pending_deletion`. Route here, do not log out, do not retry (`oa:82-83`). Shows `effectiveAt` (`oa:4308-4316`). Actions: Cancel deletion, Log out. Only 4 calls work in grace (`oa:63-70`). Support is not allowed in grace, so no in-app Support link (`oa:2691`). States: cancelling; success ("account restored", leaderboard return may lag); 404 `no_pending_deletion` (erasure already began, terminal); offline; error. | Login -> pending screen -> cancel -> Home | `cancelAccountDeletion` oa:1315; `getMyProfile` | none | P0 |
| DG-03 | Banned-account screen | NEW FRAME REQUIRED | Trigger: 403 `account_banned` after a correct code (`oa:231` verifyOtp, `oa:542` verifyParentOtp, `oa:625` confirmRecovery; `ec:51`; `cl:78`). No tokens are issued; do not retry. Contract-suggested EN "Account banned — contact Support" and AR "تم حظر الحساب — تواصل مع الدعم" (`ec:51`); owner approval is pending. The contact action is HELD (H-03). | OTP or recovery -> banned screen -> Login | none | I-4 (PED:3730-3736). Owner-mandated, not an E-item. | P0 |
| DG-04 | Lost-phone recovery (4 steps) | NEW FRAME REQUIRED. Weak lead only: OTP `82:1171`, error `82:1170` (EUM:133, EUM:154-155). | ① old phone ② parent OTP (masked parent number, 60 s resend, 5 min expiry) ③ new phone (`phone_already_registered` possible) ④ OTP on new phone. Success: phone replaced, only this device active, other sessions revoked (`oa:594-606`). Per step: loading, error, `otp_throttled` 15-min lock (`oa:86-88`), `recovery_unavailable` -> support path HELD (`ec:29`), `account_banned` -> DG-03, offline. | Login ("lost my phone" link, new) -> steps -> Home | `startRecovery` oa:466; `verifyParentOtp` oa:511; `submitNewPhone` oa:551; `confirmRecovery` oa:594 | I-4 / I-10(f) support contact (H-03) | P1 |
| DG-05 | Legal document viewer | NEW FRAME REQUIRED. Profile rows exist: "Privacy & policy" `170:4901`, "Terms & Conditions" `170:4912` (PED:1975). | Terms and Privacy in the UI language. Content is Markdown with its own `# ` title (`oa:816-820`). States: loading; content; 404 `legal_document_unavailable` (generic "unavailable", not cached, `ec:22`); offline; error. **Markdown constructs:** the staging text (r4-2026-10-07) uses headings, tables and horizontal rules (PED:100, PED:343, PED:2947). That is an API-probe finding, not contract; the contract says only "Markdown, including its own # title line". Designer supplies heading, table and rule styles from the existing scale. Seif/legal confirm the final construct set. | Login consent links `82:1086` (Login `82:819`), DG-06, Profile rows -> viewer | `getLegalDocument` oa:816 (public) | S30 text approver; Cookie link HELD (H-05); store blocker E-2 | P0 |
| DG-06 | Terms acceptance step in registration | NEW FRAME REQUIRED. Registration base frames: School `125:511` (dark `337:5269`); University `125:2336` (dark `337:10373`) (PED:1121). | Appears after the registration 201, because `acceptTerms` needs a token. Summary, links to DG-05, accept button. States: loading, accepting, error, already accepted (skip), `currentVersion: null` (feature inert, skip; `oa:1087-1110`). Gate shape HELD (H-05). | Registration complete -> Terms step -> Home | `getTermsAcceptance` oa:1087; `acceptTerms` oa:1116 | I-14 (placement only) | P1 |
| DG-07 | Terms prompt inside photo features | NEW FRAME REQUIRED | Sheet: accept Terms to add photos, then resume. Support offers "send without photos". States: accepting, failed, version null (photos unavailable). | Avatar upload or attach photo -> sheet | `acceptTerms` oa:1116 | I-14 | P1 |
| DG-08 | Notifications inbox | Existing `180:8386`; University `309:9525` (NIN:187-197). | Chips: All, Announcements, Support, System only. Promotions has no contract category (`oa:1159`). Row by `kind`:<br>- announcement: server bilingual plain text, never auto-linked.<br>- moderation_warning: fixed contract EN/AR copy (`oa:1170-1185`).<br>- support_ticket_replied, academic_year_opened (with {track}, {academicYear}) and enrolment_opened copy: NOT KNOWN (owner/Seif).<br>- Unknown kind or category: no row.<br>Read and unread. States: loading, empty per tab, error, offline, load-more. "All (N)": drop N or show the unread count (NIN:348). Dark and RTL ids NOT KNOWN (NIN:350). | Bell (DG-40) -> inbox | `listMyNotifications` oa:1148; `markNotificationRead` oa:1246; `getUnreadNotificationCount` oa:1227 | I-17, I-20 | P1 |
| DG-09 | Chat conversation list (Message tab) | Existing `162:2797`, redraw text-only (PED:1964). University Messages set (6 frames; which one is the list twin is NOT KNOWN): `309:6654`, `309:7340`, `309:7490`, `180:7398`, `309:7722`, `309:7778` (EUM:146; PED:1964). | Row: avatar, name, last-message preview, unread count, time, Seen. Flame plus count only for live streaks, with `stepTakenToday` true and false variants (`oa:4866-4878`; flame nodes `661:8319` / `649:8889`). Peer erased: name and avatar null, read-only (`oa:4742`; copy NOT KNOWN). Suggestions carousel `216:3470`: name and avatar only. States: empty (no friends -> Friends), loading, error, offline. | Message tab -> thread | `listConversations` oa:3370; `listMyFriendStreaks` oa:3825 | I-17 tab composition; store blocker E-5 (RRR:73) | P0 |
| DG-10 | Chat thread (text-only) | Existing `166:3156`, `215:2628`, redraw. | - Sent and received bubbles; Seen (`oa:4894-4897`); text composer (500 characters max, `oa:4772`).<br>- Send states: sending, failed, retry.<br>- Edit within 10 s (`oa:3507-3509`) and delete-for-everyone within 60 s (`oa:3552-3553`; 409 `message_delete_window_closed` at `oa:3583`); delete-for-me anytime. "Edited" marker (`editedAt`, `rt:48`). Deleted tombstone.<br>- Peer "typing" indicator, shown for about 5 s (`rt:51`).<br>- Unknown kind: neutral "not supported" bubble (`oa:4767`).<br>- Forwarded card (DG-14).<br>- `canSend` false: read-only.<br>- 404 `conversation_not_found` (friendship ended) -> back to list.<br>- Rate limit 45 per 60 s (`oa:3499`).<br>- Connection: connecting, live, reconnecting, offline.<br>- Messages expire 24 h after read or 30 days after send (`oa:3412-3425`); notice copy NOT KNOWN.<br>- Loading, empty, error. | List or push tap -> thread | `listConversationMessages` oa:3412; `sendChatMessage` oa:3454; `editChatMessage` oa:3506; `deleteChatMessage` oa:3550; `markConversationRead` oa:3592 | none. P0 because the owner-mandated Message tab is not usable without a thread. | P0 |
| DG-11 | Friends hub | Existing `216:3784` (University `309:6906`), redraw. | Sections:<br>- My friends (points absent if the friend hides score, `oa:2993`).<br>- Incoming requests (Accept and Decline).<br>- Outgoing requests (Cancel).<br>- Suggestions (Add).<br>- Phone lookup: exact E.164; result is name plus avatar; not found; 10 per hour (`oa:3113`).<br>Request outcomes: pending, auto-accepted, already friends, unavailable (`oa:3160-3184`). Write limit 30 per 60 s. Empty, loading, error, offline per list. No phone digits (`oa:3055`, `oa:4665-4669`). | New entry (S36 open; I-17) -> hub | `listMyFriends`, `listFriendSuggestions` oa:3046, `lookupStudentByPhone` oa:3084, `listMyFriendRequests`, `sendFriendRequest`, `cancelFriendRequest`, `acceptFriendRequest`, `declineFriendRequest` | I-17 | P1 |
| DG-12 | Block, report, unfriend, Blocked list | NEW FRAME REQUIRED (PED:1981) | - Report message: recipient only, no reasons or free text, idempotent, not on forwarded cards or own messages (`oa:3630-3640`).<br>- Report student (`oa:3667`). "Report and block" calls report first (`oa:3637`).<br>- Block confirm: removes the friendship and deletes the conversation; the other student is not told; unblock restores nothing.<br>- Unfriend confirm (not notified).<br>- Blocked list with Unblock; empty, loading, error.<br>- Result toasts.<br>- **Leaderboard rows** (peer names are user-generated content): report/block control or "Option 0" (rank, points, avatar, no names). HELD (H-21). | Thread overflow or friend card -> sheets. Blocked-list entry in Settings or Profile (designer proposes). | `reportChatMessage` oa:3630; `reportStudent` oa:3667; `blockStudent` oa:3311; `unblockStudent`; `listMyBlocks` oa:3276; `removeFriend` | Q-B9 / I-11 to Seif (PED:3783-3788); H-21 | P0 |
| DG-13 | Push permission pre-prompt, denied state, foreground banner | NEW FRAME REQUIRED | Pre-prompt shown once: value line, Allow, Not now. OS states: not asked, granted, denied (with an "open device settings" row, not a toggle). Foreground in-app banner -> target. The 8 push strings are system-rendered from `rt:93-104` and are not designed. Timing and copy HELD (H-06). | Per owner timing -> OS prompt | `registerFcmToken` oa:1064 | I-16 | P1 |
| DG-14 | Forwarded question | Partial: picker `171:5031` ("All" `171:5238`); rows `171:5013`, `215:2470` (PED:1986). | One friend per call (no "All"). Card, sender view: sent, then answered right or wrong only. Card, recipient view: pending -> options -> reveal selected and correct. `contentState: unavailable` placeholder (`oa:4829`). Errors: daily limit 100 per Cairo day with reset time (`ec:70`), already pending, not forwardable. Recipient allowance exhausted: limit card with no upgrade CTA. No local points; the response carries no points field (`oa:3774-3779`). Entry point HELD (H-14). | Entry NOT DRAWN -> picker -> thread | `forwardQuestion` oa:3699; `answerForwardedQuestion` oa:3766 | I-17 | P1 |
| DG-15 | Support ticket list | Existing `178:2800` (PED:1962), redraw. University `309:8713`, ~~`309:8915`~~, ~~`309:9146`~~, `309:8819`, `180:7154` (PED:1962; EUM:145); per-frame mapping NOT KNOWN. **Corrected 2026-10-10 (§10.1): `309:8915` is a paywall and `309:9146` a favourites list, not Support; the CW12a plan reads the other three as light School duplicates, not University twins.** | Status pills: open, in_progress, pending, closed; an unknown status reads as "in progress" (`oa:3911-3922`); remove "resolved". Label `TK-{n}` without "#". Empty, loading, error, offline, page size 20. | Profile Support row, inbox row, push tap -> list | `listMySupportTickets` oa:2705 | none | P1 |
| DG-16 | Create ticket | Existing `178:3222`, redraw. University twins as DG-15. | Subject at most 120, details at most 4000, no category. Attachments (DG-18). Validation, submitting, 5-per-day limit state, success -> thread. | List -> create -> thread | `createSupportTicket` oa:2658 | none | P1 |
| DG-17 | Ticket thread | Existing `178:3378`; also ~~`178:3518`~~, ~~`296:3154`~~ (**not Support — a paywall and a favourites list; corrected 2026-10-10, §10.1**). University twins as DG-15. | Student and staff bubbles (staff shown as "Customer support", no identity). Reply at most 4000, may be empty with a photo. Closed: no reopen, offer a new ticket (409 `ticket_closed`). Photo thumbnails: ready, expired, removed (copy NOT KNOWN). Remove mic `178:3471` and camera `178:3407` (DG-54). | List, inbox or push -> thread | `getMySupportTicket` oa:2740; `listMySupportTicketMessages` oa:2763; `postMySupportTicketMessage` oa:2801; `getMySupportAttachmentContent` oa:2946 | none | P1 |
| DG-18 | Support photo attach | NEW FRAME REQUIRED | Picker (gallery only, PROVISIONAL pending H-16), preparing (downscale to about 2048 px JPEG, `oa:2861`), uploading with progress, scanning, ready thumbnail. **Deselect before send:** the contract gives the student no way to delete an uploaded photo (`oa:4015`). A deselected photo stays held until it is sent or expires 24 h after the upload call, and counts toward the 10-unattached cap (`oa:2862-2863`). Failures with Retry: too large (`ec:61`), wrong type including PDF, invalid, moderation refusal "this photo can't be sent" (`ec:16`), storage unavailable 503 (text still works), limit reached, 30 uploads per hour (`oa:2891`), Terms gate (DG-07). Replacement for the `178:3368` hint is HELD (H-15). | Create or reply -> picker | `createSupportAttachmentUpload` oa:2849; `completeSupportAttachment` oa:2900 | I-15 | P1 |
| DG-19 | Custom avatar | Existing sheet `216:3341` (dark `337:8135`, RTL `549:21753`, University `309:8194`, DI:4606). | Enable "Upload photo". Add "Remove photo" when a custom avatar exists. Gallery picker (PROVISIONAL, H-16), square crop step (upright), preview, uploading, success. Failures: too large (`oa:1028`), invalid, moderation "this photo can't be used" (`ec:16`), rate limit 5 per hour with lockout after 3 refused (`oa:1034`), 503, Terms gate. Public-CDN disclosure copy NOT KNOWN (`oa:984-986`). | Edit Profile -> sheet | `uploadCustomAvatar` oa:982; `removeCustomAvatar` oa:1042 | I-15 (minors' photos; owner/legal; H-16) | P2 |
| DG-20 | Track transfer | Partial: dialog `180:4301` -> `180:4445` (DI:1609; WS), dark `337:7561`, RTL `549:21179` (PED:1173); Profile row `170:4921`. | University, faculty and study-year pickers; only `active` years selectable. Disclosure the contract says to state plainly (`oa:1350`, `oa:1364-1368`):<br>- permanent and once, no way back;<br>- points, level and badges carry;<br>- friends and pending requests start fresh, blocks stay;<br>- school boards are left;<br>- the parent number is kept for recovery only, and the parent stops receiving reports.<br>Second confirmation. Success; errors (not eligible, not allowed, pending deletion, offline). University Profile without the row. Eligibility display: designer proposes "hide unless eligible" or "show with not-eligible state". | Profile -> flow | `transferToUniversity` oa:1338 | I-20 copy; only School `secondary3` is eligible (`oa:1353`) | P2 |
| DG-21 | Referral screen | Existing `176:2425` / `309:8565` (PED:1960), redraw. | Server values only: 8-character code, friends joined, points earned. Copy-code feedback. **Share:** the contract says text only, with no invite link and no web page (`oa:1442-1443`). The mechanism (OS share sheet or copy-only) is OPEN (N-05, PED:5247; N-13, PED:3979). Designer draws Copy; the Share frame is PROVISIONAL. Loading, error, offline, zero state. Reward copy HELD (H-01). | Profile row `170:4777` -> screen | `getMyInvite` oa:1434 | I-18; H-01 | P2 |
| DG-22 | Sign-up invite-code field | Existing `337:15875`; captions `216:3348`, `216:3393`. | Optional field; case, spaces and hyphens ignored. Registration never fails on the code. `inviteCodeApplied: false` gives a non-blocking "not applied" notice, with no reason (`oa:4087`, `oa:4146-4150`). University body awaits I-5. | Sign Up_1 | `completeRegistration` | H-01, H-19 | P2 |
| DG-23 | Quiz history list | NEW FRAME REQUIRED (EUM:130) | Row from `scopeName`, `subjectName` (empty for retakeWrong/favorites), mode, score/total, `finishedAt` (`oa:4607-4617`). No percentage, streak or lessons-left. Loading, empty, error, offline, pagination. No resume/continue operation exists, so do not design one. | Designer proposes (Home "See All" `59:2033` / card `308:4186` is only a lead, see DG-44) -> DG-24 | `listQuizHistory` oa:1877 | entry: owner | P2 |
| DG-24 | Review from history (cold open) | Existing `162:2377` (dark `337:6705`, RTL `549:20324`; EUM:162). | Add loading, error, offline. Mode label. Skipped-question row (only correct and wrong are drawn, DI:1861-1879). Title fallback when `subjectName` is null. | History -> review | `getQuizReview` oa:1912 | none | P2 |
| DG-25 | Favourites | Profile row `295:3144` (PED:1135); quiz bookmark `295:3139` (PED:1986). | List screen, add and remove states, empty, loading, error, offline, start a quiz from favourites. | Profile -> list | `listFavorites` oa:2131; `addFavorite` oa:2106; `removeFavorite` oa:2118 | none | P2 |
| DG-26 | University module picker | NEW FRAME REQUIRED | Modules (School gets `[]`), permanent "All subjects" view (`oa:1681-1700`), loading, empty, error. | Learn (University) | `listModules` oa:1685 | none | P2 |

---

## 2. Missing states for existing screens

| ID | Screen / flow | Existing frame / node id | States / variants | Entry -> destination | Backend ops assumed | Open rule / owner | Pri |
|---|---|---|---|---|---|---|---|
| DG-30 | OTP lockout (`otp_throttled`, 15-min lock) | Login `82:819`, OTP `82:1171`, error `82:1170`. Dark OTP-success also missing (`155:786`, DI:454-460). | Lockout state for `otp_throttled` only (default per N-16, PED:3982). Presentation (pop-up or inline) is for the designer to propose. No countdown variant (N-1 unanswered, PED:3967). | OTP -> lockout state | `requestOtp`, `verifyOtp` | H-11 | P1 |
| DG-31 | Shared state kit | All screens | Loading skeleton, empty, error with Retry, offline banner, rate-limited with Retry-After, "unavailable". Also frames for the error, offline, empty and expired states of the eight buttons that have no frame (DI:3367-3405; fix at DI:3404-3405). | n/a | n/a | none | P1 |
| DG-32 | Registration | School `125:511` (dark `337:5269`); University `125:2336` (dark `337:10373`) (PED:1121). | "My city isn't listed" and "I can't find my school" states (DI:1144-1198), plus DG-06 and DG-22. | Registration | reference reads, `completeRegistration` | none | P1 |
| DG-33 | Settings | `176:1840`; dark `337:8141`; RTL `549:21759` (WS:1606). | The Arabic frame lacks the **Rank privacy block** (two leaderboard-visibility toggles, `leaderboardVisible` and `scoreHidden`; `lib/features/settings/screens/settings_screen.dart:252-272`; DI:4735-4741). This is not a rank display. Add a Delete-account row (DG-01). | Profile -> Settings | `getMyProfile`, `updateMe` | none | P1 |
| DG-34 | Mistakes, flashcards, edit profile | Flashcards dark `337:14475`, Arabic `549:28041`; Setup `1234:8797`. | Mistakes empty state (DI:1993-2018). Flashcard loading, empty, preview-used-up and grade-failed (DI:4868-4891). Dark and Arabic of the updated flashcard layout and of Setup (DI:4759-4806). A real University Edit Profile frame: `309:8268` copies School (FUC:137). | existing | existing | none | P2 |
| DG-35 | Dark and RTL counterparts | Notifications, Friends, Messages, Support, Refer | Dark and Arabic (RTL) node ids are NOT KNOWN for these screens (NIN:350; PED:3940). Return them or draw them. University twins ARE recorded for the existing frames: Notifications `309:9525`, Friends `309:6906`, Refer `309:8565`, Messages (6 ids, see DG-09), Support (5 ids, see DG-15 — **two are not Support and three are read as School duplicates; see §10.1**). University twins are NOT KNOWN only for the new frames. | n/a | n/a | none | P1 |
| DG-36 | "Logged in on another device" | NEW FRAME REQUIRED for the default. Today it is a one-time message after a forced logout to Login. | Draw the message on Login in EN/AR, RTL, light and dark (default per N-20, PED:3986). A dedicated screen is HELD (H-12). | Any call returns 401 `session_superseded` -> Login with message | none (401 on any call) | I-21 (PED:3919-3944); N-20 | P1 |

---

## 3. Entry points and navigation decisions

| ID | Decision | Existing | Needed from designer | Open rule / owner | Pri |
|---|---|---|---|---|---|
| DG-40 | Bell -> inbox, unread dot | Bell `59:1466`, dark `337:5330` (DI:1010). | The dot reflects the total unread count only, with no per-tab split (`oa:1227-1238`, op `getUnreadNotificationCount`). | I-17 / NIN D2 | P1 |
| DG-41 | What the Message tab holds | Nav icon layer is named "notification" (NIN:235). Header "people" icon `649:8837`. | Propose chat-only versus chat plus inbox. No aggregate chat-unread operation exists (only per-conversation `unreadCount`, `oa:4890`), so draw no numeric tab badge. **Do not delete `649:8837`:** its target is unknown (PED:896, PED:1196, PED:1708) and I-17 asks what it opens. Designer and owner rule on it. | I-17; H-17 | P1 |
| DG-42 | Notification -> screen map | none | Inbox row tap: ticket reply -> DG-17; other rows mark-read only unless ruled otherwise. Push taps (`rt:106`): ticket -> DG-17; friend request -> incoming requests (DG-11); academic year -> inbox; chat -> that conversation; unknown kind -> inbox. | I-17 / D3; N-14, N-15 | P1 |
| DG-43 | Still-undrawn entries | `/friends` has none (PED:1627). | Entry points for Friends, Blocked list, quiz history and forwardQuestion. | I-17 | P1 |
| DG-44 | Home "Continue Learning" card | Card `59:1439` > `308:4186`; "See All" `59:2033`; personal streak `308:4203` (PED:1958-1990). | Define what the card shows. `QuizHistoryItem` carries scope, subject, mode, score/total and finish time only: no percentage, lessons-left or streak (I-21). Remove the personal streak (DG-61). Whether the card links to DG-23 is the owner's call. | I-21; entry: owner (PROVISIONAL) | P2 |

---

## 4. Figma vs backend conflicts

| ID | Frame / nodes | What it draws | Conflict (source) | Redraw | Pri |
|---|---|---|---|---|---|
| DG-50 | Refer `176:2425`; `178:2646`, `178:2767`, `178:2791-2798` (PED:1960). | "You both earn 500 bonus points"; code AHMED2024 (9 characters); "1,500 Points Earned". | The contract pays the inviter +10 only, the new student nothing, and the code is 8 characters (`oa:1434-1450`). | Remove the amount sentence (H-01). Use an 8-character sample and neutral counters. | P2 |
| DG-51 | Sign Up_1 `337:15875`; `216:3348`, `216:3393`. | "Earn points together" caption. | Same rule as DG-50. | Remove the caption until H-01 resolves. | P2 |
| DG-52 | Create Ticket hint `178:3368`. | "PNG, JPG, or PDF up to 10MB". | Allowed: JPEG, PNG or WebP, at most 7,000,000 bytes, at most 3 photos (`oa:4032-4033`). | Replace the hint. Wording is HELD (H-15). | P1 |
| DG-53 | Support list `178:2800`. | Pills "resolved" and "Closed"; "#TK-1042". | Statuses are open, in_progress, pending, closed; label is `TK-` only (`oa:3911-3922`). | Redraw the four status pills and the label. | P1 |
| DG-56 | Friends `216:3784`; masked phone `756:8447`; Accept-only `216:4318`. | Masked phone digits; no Decline. | Cards carry no phone digits (`oa:4665-4669`). | Remove the digits. Add Decline (DG-11). | P1 |
| DG-60 | Settings `176:2394` (4 toggles). | Announcements, Promotions, Support, System toggles. | The contract has no preference storage (S28). | Remove them, or replace with the DG-13 OS-permission status row. No functional toggles (H-07). | P1 |
| DG-61 | Home "12 days Streak" `308:4203`. | Personal streak. | No personal-streak operation or field exists. | Remove from Release 1 (H-09). | P1 |
| DG-62 | Profile stat cards: light `166:4416` (Rank "HERO"); dark `337:7433`; RTL `549:21052` (DI:4515-4528). | Frames disagree: Rank versus Badges. | Rank tier has no source, and no leaderboard rank is shown. | **PROVISIONAL / HELD.** The owner ruling of 2026-09-27 is "keep Points only"; the current build ships Points only. Designer reconciles all canvases to one block. The third card is pending N-17 (PED:3983, H-20). If Solved Questions is used, its source is `getMyQuizSummary` oa:1731. | P1 |

---

## 5. Existing designs to redraw (prohibited or non-existent capability)

| ID | Frame / nodes | What it draws | Rule broken | Redraw | Pri |
|---|---|---|---|---|---|
| DG-54 | Support chat `178:3378`; camera `178:3407`; mic `178:3471`. | Camera icon, voice mic. | No camera; no voice operation. | Delete both. | P1 |
| DG-55 | Messages `162:2797` (camera `649:8835`, photo row `649:8851`); thread `215:2628` (`215:2657`, `215:2697`, `215:2708`, `215:2719`, Player `215:2727`, mic `215:2732`, Save/Replay `215:2940`); `166:3156` (Player `166:4150`, mic `166:3522-3523`); camera `166:4260` (`166:4269`, `166:4280`, `166:4296`); editor `166:4319`; picker `171:5031` ("All" `171:5238`). | Camera, photo or snap rows, voice player, multi-recipient send. | Chat is text only (`oa:149`; `rt:17`); no camera. | Delete these elements and frames. Text composer only. One recipient per forward. **The header "people" icon `649:8837` is not on the delete list;** see DG-41. | P0 |
| DG-57 | Notifications `180:8386`; chip row `180:8554`; "Premium Offer — 40% Off!" `180:8768`, `180:8773`; "Daily Streak!" `180:8786`, `180:8789`. | Promotions chip; premium row; streak row. | Purchase silence; no `promotions` category; no personal-streak field. | Remove the chip and both rows. Use contract kinds only (DG-08). | P0 |
| DG-58 | Profile "Upgrade to premium" `170:4890`, icon `170:4891`. | Upgrade row. | adr-049 / D-007 (purchase silence). | Delete the row. | P0 |
| DG-59 | Limit frames `199:2335`, `225:6634`, `225:7001`; component `207:5904` ("Subscribe now", "Subscription Expired"). | "Upgrade To Premium" CTA and benefits card. | adr-049 §3; DI:1581-1618 (#51). | Redraw title, body and "Not now" only. Add the missing dark frame (DI:3234-3290, #74). Title and bodies HELD (H-08). | P0 |

---

## 6. HOLD — do not finalise yet

| ID | Item | Waiting on |
|---|---|---|
| H-01 | Referral reward copy and amounts: contract +10 to the inviter only versus Figma 500 to both. | Owner, Seif (I-18) |
| H-02 | Deletion confirm paragraph: the contract text says "paid" and "refund" (`oa:1284-1285`). Draw a placeholder slot only. | Seif Q-B2 (never filed) |
| H-03 | Banned-account and recovery "contact Support" action. There is no signed-out channel and no contact detail anywhere. | Owner, Seif (I-4, I-10f) |
| H-04 | Whether any subscription/entitlement status screen exists at all is HELD until the owner and Seif resolve the adr-049 conflict (I-9, N-01, PED:5243); `getMyEntitlements` stays a legitimate read of entitlement state (`cl:576` area, adr-049 entry). Redemption surfaces, prices, links and website hand-offs are PROHIBITED (section 7, rule 6), not held. The designer returns node ids of the commissioned "dual subscription screens" for retirement (`F:\level\03_role_uiux_partner.md:15` via PED:3803). | Owner and Seif (I-9, R-10) |
| H-05 | Terms gate shape (whole app versus photo features), parent-consent position, Login consent sentence `82:1086`, "Cookie Policy" link (`getLegalDocument` serves only terms and privacy), text approver. | Owner, legal (I-14, S30, DI:149-156) |
| H-06 | Push pre-prompt timing and copy, foreground presentation, return-to-target after sign-in (default: dropped). | Owner (I-16, N-15 at PED:3981) |
| H-07 | Notification preference toggles. There is no backend storage; do not draw functional toggles. | Seif S28; owner O-6 |
| H-08 | Limit-card title wording (DI #51 ask 3, DI:1596-1602) and body copy (provisional engineering copy today). | Owner |
| H-09 | Progress screen (`309:9671`, `334:3453`, `310:10166`, `334:3622`: weekly chart, study time, percentages), Daily Tasks, personal streak. No backend. | Seif (I-7, S32) |
| H-10 | Chat photos, voice and groups. Not in the contract; do not design. | n/a |
| H-11 | Lockouts other than `otp_throttled`; countdown timers. | Owner, Seif (N-16, N-1) |
| H-12 | A dedicated "logged in on another device" screen. Default: existing message on Login (DG-36). | Owner (N-20) |
| H-13 | Final copy for: support-reply, academic-year and enrolment inbox rows; photo errors; Terms-gate prompt; expired/removed attachment; transfer disclosure; recovery steps; chat-expiry notice. | Owner (I-20) |
| H-14 | Entry point for forwarding; the "All" multi-send chip. The cap is 100 per day (`ec:70`). | Owner (I-17) |
| H-15 | Replacement wording for the `178:3368` photo hint. | Owner (I-20) |
| H-16 | Photo-privacy legal review, including whether it covers gallery or Photo Picker photos (I-15, PED:3854-3858): avatar and support-photo builds and the public-avatar disclosure. | Owner, legal |
| H-17 | Inbox versus Message tab final composition, and a numeric chat tab badge. | Owner (I-17) |
| H-18 | Replay with an empty mistakes pool (`questions: []`). | Owner, Seif (N-19, PED:3985) |
| H-19 | University `inviteCode` (contract prose still says draft, `oa:4182`). | Seif (I-5) |
| H-20 | Profile third stat card final choice. | Owner (N-17, PED:3983) |
| H-21 | Leaderboard peer names as user-generated content: report/block controls versus "Option 0" (rank, points, avatar, no names). | Owner; Seif Q-B9 (PED:3783-3788, PED:3006) |

---

## 7. Design rules that apply to every frame

1. **No camera.** Do not ask for camera permission or draw camera flows (`.claude/skills/level-up-domain/SKILL.md:22`). That line covers the camera only. A gallery or Photo Picker path is PROVISIONAL until the photo-privacy review (H-16).
2. **Chat is text only.** No photos, voice or groups (`oa:149`; `rt:17`). Text body is at most 500 characters (`oa:4772`).
3. **Support photos.**
   - Types: JPEG, PNG or WebP only (`oa:4032`).
   - Size: at most 7,000,000 bytes (`oa:4033`).
   - Count: at most 3 per ticket or reply (`oa:3990`, `oa:4006`), at most 10 on a ticket (`ec:66`), at most 10 held unattached (`oa:2862`).
   - Figma's "PDF up to 10MB" (`178:3368`) is wrong.
4. **Avatar photo.** JPEG, PNG or WebP, at most 2,097,152 bytes, 128 to 4,096 px per side, at most 16,000,000 px, not animated, cropped square and upright (`oa:987-990`).
5. **Terms gate.** Avatar and support photos return 403 `terms_acceptance_required` until Terms are accepted (`oa:1025`, `oa:2672`, `oa:2882`; `ec:67`).
6. **Purchase silence (adr-049, D-007).**
   - Prohibited: paywall, price, upgrade, checkout, purchase hand-off, subscription redemption, website hand-off, "where to buy", and any premium wording.
   - HELD, not prohibited: any subscription/entitlement status screen (H-04) — do not draw it until the owner rules.
   - The four web-only operations are never designed.
   - The one exception is the contract-verbatim "Subscribe to get step-by-step explanations" card (DI:1612-1618).
7. **No own leaderboard rank.** No pinned or synthetic self-rank number or row (owner ruling D-008; EUM:93-97). The leaderboard list itself may contain the student's row only when the server returns it inside the page (EUM:95).
8. **Server is authoritative.** Do not invent points, rewards, progress, streaks or notification preferences. Forwarded-question points are +1 server-side only; the response carries no points field (`oa:3774-3779`).
9. **Legal text is rendered in the app** (`oa:816-820`). Public store URLs are a separate deliverable.
10. **Copy.** Do not write copy the contract does not supply. Leave `[[COPY: owner]]` placeholders. Use existing tokens and the existing type scale only.
11. **States.** Every screen needs loading, empty, error with Retry, and offline. Photo and permission flows add denied, refused and upload-failed states.
12. **Languages and themes.** EN (LTR) and AR (RTL), light and dark, and a University twin wherever a School frame exists.

---

## 8. What to send back (exact return table format)

One table, one row per frame variant, as CSV or a table.

| Column | Content |
|---|---|
| Screen / flow | The DG-id plus the screen or flow name |
| Frame / node id | The Figma node id, or `NEW` |
| States / variants | Each state drawn, from the lists above |
| EN/AR | Yes or no for each language, with the AR frame id |
| RTL | Yes or no, with the RTL frame id |
| Dark | Yes or no, with the dark frame id |
| Entry point | Where the student comes from |
| Destination | Where it leads |
| Backend ops assumed | The operationIds from section 1 |
| Open rule | The H-id or I-id that gates it, or none |
| Figma link | Link to the node |

Return rules:
1. Order the rows P0 first, then P1, then P2.
2. Mark each row FINAL, PROVISIONAL or HELD. Never mark an H-item FINAL.
3. Return node ids for every existing frame the records leave NOT KNOWN: the dark and Arabic (RTL) frames of Notifications, Friends, Messages, Support and Refer, and the University twins of any new frame. Also confirm which of the six University Messages ids is the list twin, and which Support University id maps to the list, create and thread frames.
4. Use `[[COPY: owner]]` placeholders for unsupplied copy. Do not write the copy.
5. For every redraw in sections 4 and 5, return the old node id and the new node id.

---

## 9. Verification notes (one line per finding)

Evidence level for everything here is SOURCE. All findings were applied; none was rejected. The verifier's 8 "missing" items are M1-M8.

- **F1 (MEDIUM, preamble overclaim), applied.** Reworded: node ids come from repo records, a line is cited where given, and the default source ranges are named.
- **F2 (MEDIUM, DG-09 University twins), applied.** EUM:146 and PED:1964 list six University Messages ids as a flat set. Now written as "6 frames, list twin NOT KNOWN", and `309:7722` / `309:7778` are included.
- **F3 (MEDIUM, DG-55 deleting `649:8837`), applied.** PED:896, PED:1196 and PED:1708 call it unconfirmed with an unknown target. It is removed from the delete list and kept in DG-41 as "do not delete".
- **F4 (MEDIUM, DG-05 Markdown NOT KNOWN), applied.** PED:100, PED:343 and PED:2947 give headings, tables and rules from an API probe. The contract (`oa:816-820`) says only "Markdown, including its own # title line". The probe finding is labelled as such.
- **F5 (MEDIUM, DG-21 share), applied.** Re-read: `oa:1442-1443` says "no invite link and no web page", and `oa:1446-1448` is the 200 response. The contract never mentions QR. The mechanism is OPEN (PED:5247, PED:3979), so the Share frame is PROVISIONAL.
- **F6 (MEDIUM, DG-11 `oa:3055`), applied.** Re-read: the limit of 10 lookups per hour is at `oa:3113`, in `lookupStudentByPhone` (opId `oa:3084`). `oa:3055` is the "cards carry no phone digits" sentence and is now cited for that.
- **F7 (LOW, line cites), applied.** Re-checked each:
  - `markConversationRead` opId is `oa:3592`.
  - The 10 s edit window is `oa:3507-3509`; the 60 s delete window is `oa:3552-3553`; the 409 for a closed delete window is `oa:3583`.
  - `getMyQuizSummary` opId is `oa:1731`.
  - `309:8268` is at FUC:137.
  - `295:3139` is at PED:1986.
  - E-3 is RRR:71 and E-5 is RRR:73.
  - DG-31 is reworded to match DI #76's "Fix we need" (DI:3404-3405).
- **F8 (LOW, DG-06/32 registration ids), applied.** Base frames `125:511` and `125:2336` are added alongside the dark `337:5269` and `337:10373` (PED:1121).
- **F9 (LOW, DG-35 University twins), applied.** University twins are recorded for Notifications, Friends, Refer, Messages and Support. NOT KNOWN is now restricted to dark/RTL ids and to University twins of new frames.
- **F10 (LOW, H-04 versus rule 6), applied.** Redemption, website hand-off and subscription-status screens are moved to PROHIBITED (rule 6). H-04 keeps only the N-01 entitlement-info-screen question and the request to return the "dual subscription screens" node ids.
- **F11 (LOW, DG-30 "inline"), applied.** N-16 (PED:3982) says only `otp_throttled` gets lockout treatment. Presentation is left to the designer. No countdown (N-1, PED:3967).
- **F12 (LOW, DG-33 Rank block and rule 7), applied.** The "Rank block" is the two privacy toggles in `_RankSection` (`settings_screen.dart:252-272`, DI:4735-4741), not a rank display. Rule 7 now matches EUM:93-97, which allows the own row only when it is inside the returned page.
- **F13 (LOW, DG-62), applied.** Marked PROVISIONAL / HELD. DI:4515-4517 holds the owner ruling "keep Points only". N-17 (PED:3983) is open.
- **F14 (LOW, DG-18 "remove before send"), applied.** Re-read `oa:4015` ("A student cannot delete a photo") and `oa:2862-2863`. Now "deselect before send", and the photo stays held up to 24 h against the 10-unattached cap.
- **F15 (LOW, rule 1 gallery), applied.** `SKILL.md:22` supports "no camera permission" only. The gallery path is PROVISIONAL pending H-16 (I-15, PED:3854-3858).
- **F16 (LOW, priority tiering), applied.** P0 is redefined to include owner-mandated non-deferrable items. DG-10 is raised to P0 with DG-09. DG-01's confirm paragraph is tagged HELD in the row. DG-03's P0 now says "owner-mandated, not an E-item".
- **F17 (LOW, DG-59 title), applied.** Title wording is added to H-08 (DI #51 ask 3, DI:1596-1602).
- **F18 (LOW, DG-43 "Terms accepted on" line), applied.** Removed. No record or owner decision requests it.
- **M1 (Continue Learning), applied.** New DG-44.
- **M2 (session_superseded), applied.** New DG-36, with H-12 still holding the dedicated-screen option.
- **M3 (typing and edited marker), applied.** Added to DG-10 (`rt:51`, `rt:48`).
- **M4 (leaderboard UGC), applied.** DG-12 now includes leaderboard rows, and there is a new H-21 (PED:3783-3788, PED:3006).
- **M5 (base Registration frames), applied.** Added to DG-06 and DG-32.
- **M6 (Support University twins), applied.** Added to DG-15, DG-16, DG-17 and DG-35.
- **M7 (`getUnreadNotificationCount`), applied.** Added to DG-08 and DG-40. Re-read: `oa:1227` is the operationId line.
- **M8 (no explicit minimum coverage list).** I checked coverage against I-21 (PED:3919-3944):

  | I-21 item | Where it is covered |
  |---|---|
  | Lost-phone recovery | DG-04 |
  | Track transfer | DG-20 |
  | Banned account | DG-03 |
  | OTP lockout | DG-30 |
  | Deletion, cancel, pending | DG-01, DG-02 |
  | Terms step and legal viewer | DG-05, DG-06, DG-07 |
  | Logged in on another device | DG-36 |
  | Chat report, block, unfriend, Blocked list | DG-12 |
  | Decline and "my friends" list | DG-11 |
  | Support statuses | DG-15 |
  | Photo-refused error | DG-18 |
  | Quiz history and Continue Learning | DG-23, DG-44 |
  | Favourites | DG-25 |
  | Module picker | DG-26 |
  | Empty replay | H-18 |
  | Notification pre-prompt | DG-13 |
  | Loading/empty/error/offline states | DG-31 |
  | Corrections (text-only Messages, referral copy, subscription screen, photo hint, masked phone) | DG-50, DG-52, DG-55, DG-56, H-04 |

  No further gaps found.

---

## 10. Addendum 2026-10-10 — Support (CW12a) follow-up. Draft, NOT sent.

*The CW12a text-ticket screens (list `178:2800`, create `178:3222`, thread `178:3378`) are built (uncommitted). This
addendum corrects this file and adds what was never asked. It does not repeat DG-15, DG-16, DG-17, DG-35, DG-52,
DG-53 or DG-54, which stand. Copy is the owner's (O-14): use `[[COPY: owner]]`.*

*Revised 2026-10-10, second pass (§10.4): the frame correction, the dark-frame lead, the removals wording and the
message were corrected after a read-only check against `CW12a_PLAN.md` §2 and `DESIGN_ISSUES.md` #55 / #131. The
first draft was never sent; it is kept in `fu2_prewave/03_DESIGNER_HANDOFF.md.prewave`.*

*Revised 2026-10-10, third pass (§10.5): the owner approved the Support copy (O-14) except `pending`. The message
now carries the approved words and says how the pills are built today. Nothing was sent, and Figma was not
opened. The second-pass text is kept in `o14_prewave/03_DESIGNER_HANDOFF.md.prewave`.*

### 10.1 Correction — four frames this file maps to Support are not Support

Verified by frame name and content on 2026-10-10 (CW12a_PLAN §2):

| Frame | What it is |
| --- | --- |
| `309:8915` | "Upgrade to premium" (a paywall) |
| `178:3518` | "Upgrade to premium", although the frame is named "Customer Support" |
| `309:9146` | "Favorite questions", although the frame is named "Customer Support" |
| `296:3154` | "Favorite questions", although the frame is named "Customer Support" |

DG-15 lists `309:8915` and `309:9146` as Support's University twins. DG-17 lists `178:3518` and `296:3154` as thread
frames. **Read those four ids as removed from DG-15 and DG-17.** The app is purchase-silent, so the paywall is
never built.

Three of the four are even named "Customer Support": `178:3518`, `309:9146` and `296:3154`.

`309:8713`, `309:8819` and `180:7154` carry the Support frames' names. DG-15 calls them University twins, but the
CW12a plan read them by name and content as **light School duplicates** (`180:7154` is an older thread header,
and it has the School frames' `180:` prefix). No University (purple) Support frame is confirmed. Figma was not
re-opened in this pass.

**Dark-frame lead (not yet reconciled).** The CW12a plan says no dark Support frame exists, so dark uses stand-ins.
But the Glass audit (`DESIGN_ISSUES.md` #55, "Recorded, not built") lists Glass on **Customer Support `337:8390`**
(its panel `337:8543`, row G17) and on **Create Ticket**. Glass is the dark elevation, so these may be the dark
Support frames. The message asks the designer to confirm before drawing anything new.

### 10.2 New row

| ID | Screen | Request | P |
| --- | --- | --- | --- |
| DG-63 | Support list, create, thread | (a) **Rename** `178:3518`, `309:9146` and `296:3154` (all three named "Customer Support"; `309:8915` is the other paywall frame) so nothing else maps them to Support. Confirm that `309:8713`, `309:8819` and `180:7154` are light School duplicates that can be retired, and say whether University (purple) Support frames exist. Confirm whether `337:8390` / `337:8543` and the Create Ticket Glass frame (#55) are the dark Support frames. (b) **Staff avatar:** the thread's "Customer support" author has a character avatar. Is that intended, or should it be a support glyph? (c) **Ticket-row date:** creation time or last activity? The build shows creation (`createdAt`). (d) **Type sizes off the scale:** 18.941 SemiBold, 22 Bold (heading), 20 Regular (create subtitle), 22 SemiBold (Submit), 16.632 (message name and body, SF Pro), Cairo for the hints. Move them onto the scale or add entries (DESIGN_ISSUES #131 §5). (e) **Light contrast:** details hint `#B7B7B7` on white is 2.01:1, composer hint `#A1A1A1` on white 2.58:1, create subtitle `#7C7C7C` on `#FCFBF9` 4.04:1 at 20 px regular. All are under 4.5:1 (#131 §9). (f) **Confirm removals:** "Seen" `178:3418` is not built because the contract has no read-receipt field (not a "for now"); "See All" `178:3080` is hidden in the frame and not built; the nav bar is not shown (the support route sits above the shell). The Attach box `178:3357` and its hint `178:3368` return with the photo step (CW12b; DG-18, DG-52). The camera `178:3407` and mic `178:3471` are **deleted for good**, not deferred (DG-54: no operation exists). (g) **States not drawn and specific to Support** (the generic ones are DG-15/16/17 and DG-31): create limit reached (5/day; already in DG-16), reply limit reached (60/hour), ticket not found (unknown, malformed and another student's ticket must look the same; no Retry), reply failed with the draft kept, load-more and its Retry, and the closed thread (already in DG-17): the build puts a bar with the "Closed" pill and a "Create a New Ticket" button where the composer was; there is no reopen. Account pending deletion is **not** Support-specific: the contract routes it to the cancel screen (DG-02), and the build shows an inline line until that screen exists (CW05). (h) **Pills:** any status the app does not recognise shows as in progress, not closed (DG-15); every pill must reach 4.5:1 in light and dark (the inbox category pills fail as drawn, #130). (i) **Thread timestamps:** each message has a `createdAt`, but the frame draws none, so the build shows none. Should it? | P1 |

The back chip's 48 dp target and the titled bar's text scaling were fixed in code (O-15, DESIGN_ISSUES #132)
without moving any drawn pixel. Nothing to draw.

*DG-63, third pass 2026-10-10 (O-14 approved):* (g) the closed bar reads مغلقة / إنشاء تذكرة in Arabic. (h) Open
and In progress pills are now built with the approved words, and an unknown status shows In progress. They reuse
the drawn Closed pill's look, so only the words differ. The light pill is 8.97:1 (computed). `pending` still has
no words (SQ-32) and shows no pill. A per-status pill design, and how a pill behaves at very large text, are still
asks. (e) is unchanged: the approved Arabic uses the same hint and subtitle tokens, so the three ratios stand.

### 10.3 Message to the designer (ready to send after owner review; revised 2026-10-10, third pass)

Hi! A follow-up on the Support screens: ticket list `178:2800`, Create Ticket `178:3222` and chat `178:3378`.
They're built from your frames, text only for now (photos come later). The general rules in our first message still
apply. Here's what's specific to Support, most important first:

1. **Dark and Arabic.** We found Glass on `337:8390` (Customer Support) and on a Create Ticket frame. Are those the
   dark Support screens, and is there a dark chat? If not, please draw them. We also need Arabic for all three, and
   for each new state below (DG-35). The Arabic wording is now approved: it's in the list at the end.
2. **Status pills:** open, in progress, pending and closed. There is no "resolved", and the label is `TK-1042` without
   "#" (DG-53). Any status we don't recognise shows as "In progress". The words for Open, In progress and Closed are
   now approved (list at the end). For now the app draws Open and In progress in your Closed pill's grey, so only
   the words differ. Could you design a pill for each status? `pending` has no approved words yet, so it shows no
   pill: use `[[COPY: owner]]` for it. Please make every pill at least 4.5:1 contrast in light and dark, and show
   how a pill should behave at very large text on a small phone. At 3x on a 320 dp screen, "In progress" leaves
   the ticket subject very little room.
3. **Support states** (on top of the usual loading, empty, error with Retry, and offline):
   - list: "load more" and its Retry
   - create: field errors (subject up to 120 characters, details up to 4,000) and the daily limit (5 tickets a day)
   - chat: sending, reply failed (we keep the draft), and the reply limit (60 an hour)
   - ticket not found: an unknown ticket and someone else's must look the same, with no Retry
   - closed ticket: there is no reopen, so we replaced the composer with a bar showing the "Closed" pill and a
     "Create a New Ticket" button (in Arabic: مغلقة and إنشاء تذكرة). Please draw it.
4. **Frames that aren't Support.** `178:3518`, `309:9146` and `296:3154` are all named "Customer Support", but
   `178:3518` is the premium paywall and the other two are the favourite-questions list (`309:8915` is the other
   paywall frame). Could you rename them? `309:8713`, `309:8819` and `180:7154` look like light School copies of the
   Support screens (`180:7154` is an older chat header). Can they be retired? Is there a University (purple) version?
5. **Quick decisions:**
   - Staff avatar `178:3424`: keep the 3D character, or use a support icon? The backend gives staff no identity,
     and a student could pick a similar character.
   - Ticket-row date: we show the creation date, but the list is sorted by last activity. After a reply the dates
     can look out of order. Which date should it be?
   - Chat timestamps: every message has a time, but the frame shows none. Should it?
6. **Type and contrast.** We mapped the off-scale sizes to the nearest styles. The 22 Bold heading is drawn at
   24 Bold, the 20 Regular subtitle at 16 Regular, the 22 SemiBold Submit at 16 SemiBold, and the 16.63 message text
   at 16. Please confirm, or add 22 and 20 to the scale. Three light texts are below 4.5:1:
   - details hint `#B7B7B7` on white: 2.01:1
   - chat hint `#A1A1A1` on white: 2.58:1
   - create subtitle `#7C7C7C` on `#FCFBF9`: 4.04:1

   Could you darken them?
7. **Please confirm what we left out:**
   - "Seen": the backend has no read receipts.
   - "See All": it's hidden in your frame.
   - The Attach box and its hint: they come back with the photo step.
   - The camera and the mic: removed for good (DG-54).

**Approved words** (please use them as written):

| Where | English | Arabic |
| --- | --- | --- |
| List card title, and the closed-ticket button | Create a New Ticket | إنشاء تذكرة |
| List card subtitle | Describe your issue | اشرح مشكلتك |
| List heading | Recent Tickets | التذاكر الأخيرة |
| Create screen, top bar | New Ticket | تذكرة جديدة |
| Create screen, heading (unchanged) | Create Ticket | إنشاء تذكرة |
| Create screen, subtitle | Describe your issue and we'll help you | اشرح مشكلتك وسنساعدك |
| Field labels | Subject / Details | الموضوع / التفاصيل |
| Details hint | Describe the issue in detail... | اشرح المشكلة بالتفصيل... |
| Submit button | Submit Ticket | إرسال التذكرة |
| Chat hint | Write your message | اكتب رسالتك |
| Pills | Open / In progress / Closed | مفتوحة / قيد المعالجة / مغلقة |
| Pending pill | `[[COPY: owner]]` | `[[COPY: owner]]` |

Please answer in the table from our first message (section 8), using row DG-63. Thanks!

### 10.4 Revision note (lead-only, second pass 2026-10-10)

Read-only Sonnet check of §10 against the brief and the records, then corrected here:
- **Frames:** the misnamed set is three (`178:3518`, `309:9146`, `296:3154`), not two. The twins are now paired
  (`309:8915` paywall, `309:9146` favourites). `309:8713` / `309:8819` / `180:7154` are now asked as School
  duplicates (CW12a_PLAN §2), not as University twins. DG-15, DG-17 and DG-35 are struck through in place (never
  deleted).
- **Dark:** the Glass audit's `337:8390` / `337:8543` / Create Ticket entries (#55) contradict "no dark Support frame".
  They are asked about instead of requesting new frames.
- **Removals:** camera and mic are a permanent deletion (DG-54), not part of the photo step. "Seen" has no contract
  field.
- **Type:** the first draft asked to "confirm as drawn", but the build does not draw them as drawn. It now states the
  mapping (#131 §5).
- **Contrast:** names each element with its hex values.
- **States:** pending deletion moved out of the Support-specific list (DG-02; the contract routes it to the cancel
  screen; CW05).
- **Answers:** the designer is asked to reply in the §8 table under DG-63.
- **Not done:** Figma was not opened in this pass (the Figma connector needs re-authorising), so all node facts are
  the repo's records.

### 10.5 Revision note (lead-only, third pass 2026-10-10)

- **Why:** the owner approved the O-14 copy (`CW12a_FOLLOWUP_REPORT.md` §13). The message asked for
  `[[COPY: owner]]` on every pill. It now gives the approved words, and keeps `[[COPY: owner]]` for `pending` only.
- **Added:** the approved-words table (owner-approved text, no new wording), the current pill stand-in (Closed's
  look reused), and the large-text question (measured with the bundled fonts: no overflow up to 3.0×, but at
  320 dp and 3.0× an In progress row leaves the subject column 21 dp in English and 11 dp in Arabic).
- **Unchanged:** the asks for Arabic and dark versions of the three screens and their states, the frame
  corrections, the type mapping, the three low-contrast texts (still 2.01, 2.58 and 4.04 to 1, not fixed), the
  avatar, date and timestamp questions, and the confirmed removals ("Seen", "See All", the Attach box, camera,
  mic).
- **Not done:** Figma was not opened (the connector still needs re-authorising), and nothing was sent.

## 11. Addendum 2026-10-10 — Legal viewer (CW04a) built on an interim style. Draft, NOT sent.

**Why:** the owner approved building the viewer without a frame (instruction "NEXT STEP — ACCEPT NNA, CLOSE BUG-027,
AND IMPLEMENT CW04a", D3). DG-05 stays **NEW FRAME REQUIRED**: what is built is an interim from the existing scale and
theme, not a design. Figma was not opened (the connector needs re-authorising); node ids below are the repo's records.
Full record: `CW04a_REPORT.md`.

**What the designer should replace (DG-05)** — every value is an existing token:

| Element | Interim (existing token) |
|---|---|
| Document title (the served `# ` heading) | `AppType.h2`, `textPrimary` |
| Section heading (`##`) | `AppType.h3`, `textPrimary` (`###`–`######`: `h4`) |
| Body text, list items, table cells | `AppType.bodyMedium`, `textSecondary` |
| Bold (`**…**`) | `AppType.bodyMediumStrong` (weight 500) — no heavier 14 pt style exists in the scale |
| Table header cell | `AppType.labelLarge`, `textPrimary` |
| Rules (`---`) and table lines | theme `ColorScheme.outlineVariant` (Material's divider role), 1 px |
| Link (none served today) | `bodyMedium` in `link`, underlined |
| Spacing | blocks 12, table cells 8, page 20 at the sides; list markers in a 24 indent |

**Decisions already taken by the owner, for the frame to follow:**
- **C3 — one title.** Once the document is shown, its own heading is the page title and the bar keeps only the back
  chip (no second title). While loading, or on a failure, the bar shows the existing "Privacy & policy" /
  "Terms & Conditions" title.
- **C1 / C2 — Login line (`82:1086` in `82:819`).** "User Agreement" opens the Terms of Use. The Cookie Policy link is
  removed, with its clause, because no cookie document exists. The line now reads "By continuing, you agree to our
  User Agreement and Privacy Policy" (existing fragments only; its EN + AR wording still needs product/legal
  approval, `DESIGN_ISSUES.md` #9). The frame still draws three links.

**Questions (answer in the §8 table under DG-05):**
1. Heading, body, bold, table and rule styles for the viewer, in light and dark, EN and AR.
2. The bar while the document is shown: back chip only (as built), or something else?
3. Wide tables on 320 dp: the build wraps cells inside the screen width (no sideways scrolling). Keep?
4. Arabic tables: columns run right to left and cells start at the right, as built. Confirm.
5. The Login line with two links instead of three (C2).

**Not done:** nothing was sent, and Figma was not opened.

### 11.1 Message to the designer (draft, NOT sent; prepared 2026-10-11 for owner review)

It asks the questions above in one short message; it is not a second request. The O-16 wording is still pending
(`O16_DECISION_NOTE.md`), so the message presents the Login sentence as interim, not approved.

> Hi! Two quick things about the legal documents, please.
>
> 1. **Legal document viewer (DG-05).** Privacy and Terms now open inside the app, from Profile and from the Login
>    line. There was no Figma frame for this screen, so for now it uses our existing type scale and theme colours.
>    That's a stand-in, not a design. Could you draw the frame, or confirm the stand-in? If they're part of the
>    design, please include these states:
>    - loading
>    - the document itself (headings, body text, bold, lists, tables, dividers), in light and dark, English and
>      Arabic
>    - not published yet (the document isn't available)
>    - offline
>    - too many requests (try again in a few seconds)
>    - general error, with Retry
>
>    Once the document shows, its own heading is the page title and the top bar keeps only the back button. Is that
>    OK?
> 2. **Login line (`82:1086`).** Your frame has three links: User Agreement, Privacy Policy and Cookie Policy. The
>    app now has two, because there's no cookie document to open. It reads "By continuing, you agree to our User
>    Agreement and Privacy Policy", and "User Agreement" opens the Terms document. Product/legal still have to
>    approve this wording in English and Arabic, so please don't treat it as final copy.
> 3. **Is two links OK for now?** Please confirm the two-link line works as an interim layout, or send the revised
>    frame.
>
> Please answer in the table from our first message (section 8), row DG-05. Thanks!

**Not done:** not sent. Nothing in it is approved, and Figma was not opened.
