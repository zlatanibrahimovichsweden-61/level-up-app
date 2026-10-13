# CW12a — Support tickets, text only (wave brief)

**Status:** FORMULATED 2026-10-10 · implementation follows in the same task (owner: "NEXT SCREEN IMPLEMENTATION — CW12
SUPPORT TICKETS", plus the clarification on provisional copy). Opus plans; Sonnet implements and reviews.
**Wave ID:** `CW12a`, a split of roadmap CW12 (`04_COMPLETION_ROADMAP.md:86`), on the CW07a / CW07b precedent. `CW12b` =
photo attachments (gated on CW04, Terms; roadmap `CW04 ==> CW12(photos)`). No `CW12a`/`CW12b` id existed before.
**Contract:** pin `eddb6ac` (3.46.0-m1). The text-ticket operations and schemas (`openapi.yaml:2654-2845`, `:3911-4010`)
are **unchanged** in upstream `cc2a29d` (3.48.0-m1); only photo and Terms prose moved. CW12a is correct on the pin.
**Baseline:** HEAD `b227f61` = `origin/merged`, 0 staged, 78 status lines (56 M, 22 untracked). Pre-wave copies of the
17 files CW12a may touch: `cw12a_prewave/` (blob ids in `SHA_LIST.txt`, taken 2026-10-10T07:47:32Z).

---

## 1. Boundary

**In:** the student's own text tickets. (a) The list `/support` (`listMySupportTickets`, paged by 20, `Load more`);
(b) create `/support/new` (`createSupportTicket`, text only, never Terms-gated); (c) the thread
`/support/tickets/:ticketId` (`getMySupportTicket` + `listMySupportTicketMessages`) with a text reply
(`postMySupportTicketMessage`). Loading / empty / error / offline for each; EN/AR, LTR/RTL; light/dark; text scale;
a11y; the mock; tests.

**Out:** photos of any kind (`attachmentIds`, upload, content fetch, the Attach box `178:3357`, its hint `178:3368`) →
CW12b after CW04. The camera `178:3407` and mic `178:3471` (DG-54: no operation exists). The "Seen" receipt
`178:3418` (no read-receipt field in the contract). "See All" (`178:3080`, hidden in the frame). The Message-tab
placement and the `support_ticket_replied` inbox row / push tap (CW07b, CW08a). The nav bar the frames draw (the
existing `/support` route is pushed outside the shell; unchanged).

## 2. Figma (verified by name, `P6044i0giD9TmdQ7C2AmLq`)

| Node | Name | Use |
| --- | --- | --- |
| `178:2800` | Customer Support | the list |
| `178:3222` | Create Ticket | create |
| `178:3378` | Customer support chat | the thread |
| `309:8713`, `309:8819`, `180:7154` | same names | light School duplicates (180:7154 = an older thread header). Not used. |
| `309:8915`, `178:3518` | "Upgrade to premium" (178:3518 misnamed "Customer Support") | **a paywall — never used** (purchase-silent). DG-15/DG-17 mis-map them. |
| `309:9146`, `296:3154` | "Favorite questions" (misnamed "Customer Support") | **not support.** DG-15/DG-17 mis-map them. |

No dark and no Arabic/RTL support frame exists. Dark = stand-ins (§5.4), RTL = derived by the directional rules.

## 3. Contract rules that shape the UI

- Status: `open`, `in_progress`, `pending`, `closed`; **an unknown value is "in progress — not closed"**; only `closed`
  refuses a reply; no reopen (`:3911-3922`, `:2803-2805`). Never fail to parse an unknown status.
- `reference` (`TK-{n}`) is a display label, never an id; `ticketId` is the only handle (`:3924-3929`).
- `details` is the opening text, NOT a thread message; the thread holds replies only, oldest first, pages of 20, no
  `limit`, branch on `hasMore` (`:2665`, `:2766-2769`).
- A staff reply has `authorKind: staff` and no identity — "show it as Customer support" (`:2769`, `:3972`).
- Create: `subject` 1–120, `details` 1–4000 after server trim; 5 creates per student per day (`429`, honour
  `Retry-After`); `400 validation_failed` with a field map. Reply: `body` 1–4000 after trim; `409 ticket_closed`; 60 per
  hour (`429`). `403 account_pending_deletion` on all five (do not log out, do not retry). `404 not_found` for an
  unknown or foreign ticket.
- The app sends no `attachmentIds` in CW12a. `attachments` on responses is not modelled in CW12a (photos are CW12b).

## 4. Copy — what is approved, what is isolated

**Owner rules (2026-10-10):** do not treat unreviewed Arabic as approved; prefer approved existing translations; no
provisional text in app resources unless an **existing, verified** mechanism excludes it from a release build.
**Finding:** there is none. No guard, build flag, flavor resource or test excludes or blocks provisional copy
(searched `test/`, `tool/`, `.github/`, `lib/` for `provisional`, `kReleaseMode`, `appFlavor`, `fromEnvironment`). The
#114 precedent only tags ARB descriptions. So **no proposed text (EN or AR) enters the app.**

### 4.1 Reused approved keys (EN + AR already approved)

| Key | EN / AR | Where |
| --- | --- | --- |
| `profileCustomerSupport` | Customer Support / دعم العملاء | list title `178:2828`; **staff author label** `178:3426` (contract/Figma say "Customer support" — casing only) |
| `createTicket` | Create Ticket / إنشاء تذكرة | create heading `178:3342` (exact) |
| `leaderboardYou` | You / أنت | student author label `178:3416` (exact) |
| `nothingHere` | Nothing here yet / لا يوجد شيء هنا بعد | empty list |
| `retry`, `offline`, `genericError`, `loadMore`, `rateLimited`, `rateLimitedIn`, `errorValidationFailed`, `fieldRequired`, `fieldRejected`, `accountPendingDeletion` | approved | states, validation, failures |

### 4.2 New keys — English is Figma design copy, Arabic NOT supplied (AR value = the English text)

`app_ar.arb` carries the **English** text for these keys, so the Arabic UI visibly shows English: no unapproved
Arabic is presented as Arabic. Each `@key` description says `ARABIC NOT SUPPLIED (CW12a copy register)`. A
feature test pins this state (tracking only — **not** a release gate; nothing stops a release build from shipping
English in the Arabic UI).

| Key | EN (verbatim) | Figma | Proposed AR — PROVISIONAL, NOT IN APP |
| --- | --- | --- | --- |
| `supportCreateNewTicket` | Create a New Ticket | `178:3061` | إنشاء تذكرة جديدة |
| `supportDescribeYourIssue` | Describe your issue | `178:3065` | اشرح مشكلتك |
| `supportRecentTickets` | Recent Tickets | `178:3079` | أحدث التذاكر |
| `supportNewTicketTitle` | New Ticket | `178:3250` | تذكرة جديدة |
| `supportCreateTicketSubtitle` | Describe your issue and we'll help you | `178:3343` | اشرح مشكلتك وسنساعدك |
| `supportSubjectLabel` | Subject | `178:3334` | الموضوع |
| `supportDetailsLabel` | Details | `178:3346` | التفاصيل |
| `supportDetailsHint` | Describe the issue in detail... | `178:3352` | اشرح المشكلة بالتفصيل... |
| `supportSubmitTicket` | Submit Ticket | `178:3375` | إرسال التذكرة |
| `supportStatusClosed` | Closed | `178:3131` | مغلقة |
| `supportComposerHint` | Write your message | `178:3469` | اكتب رسالتك |
| `supportTicketMeta` | `{reference} · {date}` | `178:3110` minus "#" (DG-53) | format only, no words — same in AR |

### 4.3 Isolated — no approved text in either language, so NOT built

| Needed | Proposed EN / AR (PROVISIONAL, NOT IN APP) | Boundary in CW12a |
| --- | --- | --- |
| Status pill `open` | Open / مفتوحة | **no pill** on a non-closed row |
| Status pill `in_progress` (and any unknown status) | In progress / قيد المعالجة | **no pill** |
| Status pill `pending` | Pending / معلّقة (meaning to confirm with Seif) | **no pill** |
| Send button accessible label | Send / إرسال | the visible send icon is **hidden from screen readers**; the accessible send path is the keyboard's Send action (`TextInputAction.send`, labelled by the OS keyboard in the user's language) |

The model keeps `status`, so each pill is a small additive change once its copy is approved.

## 5. Visual spec (light, from `get_design_context`; map every value to a token — never inline)

### 5.1 List `178:2800`
- Header: the existing `TitledChrome` (title `profileCustomerSupport`, back key `support_back`).
- **Create card** `178:3052`: 363×104 (full width minus 20+20), radius 15, fill `#FCFBF9` (= `background`), drop shadow
  (0.5, 0.5) blur 4 `#000000` 25%; 25 below the title row (card top 120, title row 60–95). Row inside, start inset 18,
  vertically centred: the headset disc `178:3057` (69×69, asset `support_headset_disc.svg`, as drawn), gap 13.529, a
  column (gap 10.824): title "Create a New Ticket" Inter SemiBold 18.941 `#1A1A1A`; subtitle "Describe your issue"
  Inter SemiBold 14 `#424242`. At the end side, 299 from start (= 24 from the end): the add button `178:3066` 40×40
  circle `#384F47` (`greenPrimary` family), shadow (0.028, 0.028) blur 1.3 25%, the plus `support_add.svg` (23.3,
  fill `#FCFBF9`) centred. The **whole card is one button** (one semantics node: label = title + subtitle) → `/support/new`.
- "Recent Tickets" `178:3079`: Inter SemiBold 18, black (`textPrimary`), 25 below the card; 25 to the first row.
- **Row** `178:3104`: full width, min height 75.315, radius 16, fill white, border 0.5 `#4B675E`, inset shadow
  (0.02, 0.02) blur 2.8 25%; padding 16.5; gap 10 between rows. Start column: subject Inter SemiBold 14/21 `#384F47`
  **in full** (wraps; no truncation), then meta 2 below: `supportTicketMeta` with `reference` and `createdAt` formatted
  `DateFormat('yyyy-MM-dd', locale)` (the frame's pattern), Inter SemiBold 12/18 `#4B675E`. End: the status pill
  (only `closed`, §4.3): height 23.974, min width 73.323, stadium, fill `#B6B6B6` 13%, text 12/16 SemiBold `#444444`,
  centred. Tap → `/support/tickets/{ticketId}`. One semantics node per row (button; label = subject, meta, status).
- States below the heading: loading spinner; empty `nothingHere`; error/offline message + Retry (Retry withheld for
  429 and pending deletion, as CW07a); `Load more` footer only when `hasMore && nextCursor != null`; append Retry.
  The create card stays visible in every state.

### 5.2 Create `178:3222`
- Header: `TitledChrome` (title `supportNewTicketTitle`, back key `support_new_back`).
- Content at 20 side insets, 25 below the header row; heading block (gap 8): "Create Ticket" (`createTicket`) Inter
  Bold 22 / 1.3 black; subtitle Inter Regular 20 / 1.3 `#7C7C7C`. 25 to the form.
- Form, gap 20. **Field section** `178:3333` / `178:3345`: radius 8, fill `#FCFBF9`, inset shadow (0.2, 0.2) blur 3.4
  25%; label at (20, 20) Inter Bold 14 / 17.236, letter-spacing 0.42, `#384F47`; the input at (20, 50), full section
  width minus 40, radius 10, fill white, inset shadow (0, 0) blur 3.3 25%; subject input height 43 (section 107),
  details input height 94 (section 165), multi-line. Details hint "Describe the issue in detail..." at (16.69, 15.33),
  16 / 24, `#B7B7B7` (the frame sets Cairo; use the app's 16 regular style). Subject has no hint in the frame.
- Limits: `subject` max 120, `details` max 4000 (enforced as you type, counter hidden). Validation on submit: trimmed
  empty → `fieldRequired` under that field; a `400` field map → `fieldRejected` under the named field, otherwise
  `errorValidationFailed`.
- **Submit Ticket** `178:3374`: the shared `PrimaryCta` if it can express it (362×60, radius 20, `#384F47`, drop
  shadow (0.5, 0.5) Figma blur 4 25% — the export's `drop-shadow(… 2px …)` is half the Figma blur, *corrected after
  review*; the same conversion applies to the composer's two drop-shadows: 3.7 and 1.6, Inter SemiBold 22 / 1.3 `#FCFBF9`); otherwise compose from the same tokens. 20 below
  the details section (the Attach box is out). Submitting: spinner in the button, fields and button disabled, a second
  tap is impossible (5 creates per day).
- Success → `ref.invalidate` the list, then **replace** the create route with `/support/tickets/{ticketId}`.
- Failure → follow the app's existing form-failure pattern (find how Edit Profile reports a failed save and reuse it):
  offline → `offline`; 429 → `rateLimitedIn(seconds)` when `Retry-After` is known, else `rateLimited`; pending
  deletion → `accountPendingDeletion`; anything else → `genericError`. Text kept in the fields.

### 5.3 Thread `178:3378`
- Header `178:3398`: height 63 under the status bar, bottom border 1.18 `#7C3AED` @10%; the shared `CircleBackButton`
  (35) at start inset 21, top 14; title = the ticket's `subject`, Inter SemiBold 18 / 21 `#384F47`, centred. *Corrected
  after review:* the subject appears nowhere else on the thread (the first row is `details`), so the header is min 63
  high and the title wraps to 2 lines before ellipsis, laid out in its content direction. `TitledChrome` cannot express this header (18 / `#384F47` /
  divider), so build a small header from the shared back button. Back key `support_thread_back`.
- Messages `178:3410`: start inset 21, end inset 21, top 42 below the header; gap 20 between messages. Message row: a
  31 disc, gap 13, a column: name (Inter SemiBold ~16.6 → the 16 semibold style, `#384F47`), 1 below it the body
  (regular ~16.6 / 26.4 → the 16 regular style, `#384F47`), full text, selectable not required.
  - **First row = the ticket's `details`**, authored by the student (it is the student's opening text; the contract
    keeps it out of the thread, the design draws only messages). Then the replies in order.
  - Student: name `leaderboardYou`; disc = the shared `AvatarDisc` (31) holding the student's own `avatar.url` from
    `GET /me` (the profile's cached-network image pattern); gradient only while it loads / if it fails.
  - Staff (`authorKind != student`): name `profileCustomerSupport`; disc = `AvatarDisc` (31) holding
    `assets/images/support_staff_avatar.png` (the frame's `Avaters` fill `178:3424`, downscaled 2048→108 px = 3× the drawn
    36; no other change). The frame's disc gradient (#95CDBB→#4B675E) differs slightly from `AvatarDisc`; reuse
    `AvatarDisc` and log it.
  - An empty `body` (a photo-only reply from another client) renders the name only.
- Composer `178:3467`: bar fill `#FCFBF9`, drop shadow (0, −1) blur 1.85 `#000000` 10%, padding start 20 / end 16 /
  vertical 10, at the bottom above the keyboard and the safe area. Field `178:3468`: white stadium (radius 30), min
  height 56, drop shadow (0.2, 0.2) blur 0.8 13%, start padding 22; hint `supportComposerHint` 16 bold `#A1A1A1`
  (frame: Cairo Bold); 1–4 lines; max 4000; `TextInputAction.send` sends. Send icon `support_send.svg` 24, at the end
  (16 from the end edge), tinted with a token, a ≥48 tap target, disabled when the trimmed text is empty or a send is
  in flight (spinner while sending); **wrapped in `ExcludeSemantics`** (§4.3).
- **Closed** (`status == closed`): the composer slot shows a bar with the `supportStatusClosed` pill and a text
  button `supportCreateNewTicket` → `/support/new`. Stand-in layout (not drawn), logged.
- Send: success → append the returned message (if every page is loaded, otherwise refresh), clear the field,
  `ref.invalidate` the list (its order changes). `409 ticket_closed` → re-read the ticket, the closed bar appears.
  Other failures → the same mapping as create, shown with the same pattern; the text stays.
- Paging: build loads the ticket and the first page together, then walks `nextCursor` while `hasMore`, **at most 10
  pages** (200 replies); beyond that a `Load more` footer. After the first load and after a send, scroll to the end.
- States: loading spinner; error/offline full-screen with Retry (same withholding rules); `404 not_found` →
  `genericError` with no Retry.

### 5.4 Dark, tokens, elevation
No dark frame exists → **stand-ins**, exactly as CW07a did (`DESIGN_ISSUES` #130): each new token's dark value is
copied from an existing dark token in the same role (canvas, card, row, primary text, secondary text, border, CTA);
cite the source token in the doc comment. Dark elevation = Glass G5 via `GlassStyle` (null in light), never a dark
shadow (designer ruling 2026-09-16/17). Reuse existing tokens where the hex matches (e.g. `background` `#FCFBF9`,
`greenPrimary` `#384F47`, `#4B675E` tokens, `avatarDisc*`); add tokens only for genuinely new values, each with doc,
light, dark, `copyWith`, `lerp`, and guard/test coverage like CW07a's. Shadows go in `AppElevation` (`FigmaShadow`,
inset supported). SVG glyphs that must follow the theme are tinted by `ColorFilter` from a token (the send icon).

### 5.5 Type
Map to `AppType` (28/24/20/18/16/14/12/10); never a new `fontSize`/`fontWeight`. Off-scale values (18.941, 22, 16.632)
go to the nearest existing style with the right weight and are logged (precedent #97/#99/#115). Arabic falls back to
Tajawal/Cairo per the theme.

## 6. Files

**New:** `lib/features/support/` — `models/support_models.dart` (freezed + json, like `leaderboard_models.dart`; reuse
`CursorPage` from `registration/models/reference_models.dart`), `repository/support_repository.dart`,
`notifier/support_tickets_notifier.dart`, `notifier/support_thread_notifier.dart`, `notifier/create_ticket_notifier.dart`,
`support_error_copy.dart`, `screens/create_support_ticket_screen.dart`, `screens/support_ticket_screen.dart`,
`widgets/*`; `lib/dev/mock_support.dart`; assets `assets/icons/support_{headset_disc,add,send}.svg`,
`assets/images/support_staff_avatar.png`; tests `test/features/support/*`, `test/dev/mock_backend_support_test.dart`.
**Clean at HEAD, CW12a-only edits:** `lib/features/account_shells/screens/customer_support_screen.dart` (keeps its
path and class name — the router and CW02's `return_target_test.dart` refer to it — and becomes the list);
`test/features/settings/shell_screens_test.dart` (drop the `/support` dead-control rows).
**Shared (dirty with N-26/CW02/CW07a) — additive blocks only:** `app_router.dart` (two flat routes beside `/support`),
`mock_backend.dart` (one dispatch block), both ARBs + the 3 generated l10n files, `app_colors.dart`,
`app_elevation.dart`, their two tests, `docs/DESIGN_ISSUES.md` (entry #131), `COMPLETION_STATE.md`.
**Never touched:** `contract/`, `return_target.dart`, `return_target_test.dart`, any N-26 / CW02 / CW07a line,
`pubspec.yaml` (asset folders are already declared), `test-results.md`.

## 7. Tests (targets)
Models (contract-shaped samples, unknown status tolerated, `closedAt` null, required fields), repository (paths,
cursor, trimmed bodies, never `attachmentIds`, error mapping), notifiers (paging, bounded walk, send/append, 409 →
closed, epoch/dispose guards, `retry` null), mock (every route, 404, 400, 409, 429 after 5 creates, created ticket on
top), widgets for the three screens in EN and AR (RTL mirroring, English shown for §4.2 keys), dark theme, text scale
2.0 without overflow, `meetsGuideline` (labelled / Android tap targets), one semantics node per card/row, the closed
bar, the send icon excluded from semantics + the IME send action, a copy-status test pinning §4.2 (AR == EN for those
keys, the description marker present, every `support*` key registered). `shell_screens_test` updated. CW02's
`return_target_test.dart` and every existing test pass unchanged.

## 8. Acceptance
Format 0 changed; gen-l10n no drift beyond the new keys; ARB parity; analyze 0; targeted + guards + contract 14/14 +
pin 2/2; `validate.sh` and `validate.ps1` all green with `LEVELUP_VALIDATE_OUT` (tracked `test-results.md` untouched);
shared files gain additive hunks only versus `cw12a_prewave/`; every other N-26/CW02/CW07a file byte-identical; no
logging of bodies/subjects/details/ids; purchase-silent; AVD visual check of the three screens (EN/AR, light/dark)
against the frames. DEVICE stays pending unless the Pixel 8 is authorised.

## 9. Rollback
Delete `lib/features/support/`, `lib/dev/mock_support.dart`, the four assets and the new tests; restore
`customer_support_screen.dart` and `shell_screens_test.dart` from HEAD; remove the CW12a hunks from the shared files by
diffing against `cw12a_prewave/` (the copies hold the exact pre-wave bytes). Nothing is committed.
