# CW12a — Support tickets, text only — REPORT

**Status:** IMPLEMENTED, gated, emulator-verified, **UNCOMMITTED**. 2026-10-10, owner instruction "NEXT SCREEN
IMPLEMENTATION — CW12 SUPPORT TICKETS" plus the clarification on skills and provisional copy. Brief:
`CW12a_PLAN.md`. Design log: `docs/DESIGN_ISSUES.md` #131. Opus planned and triaged; Sonnet built (3 agents), reviewed
(4 agents, independent) and fixed (1 agent).

## 1. Baseline and preservation

- Start (2026-10-10T07:37Z): branch `merged`, HEAD `b227f61` = `origin/merged`, 0 staged, 78 status lines (56 M, 22
  untracked). Baseline blobs of all 99 dirty/untracked files: scratchpad `cw12_base_blobs.txt`.
- The CW07a pre-wave copies were re-verified against their recorded blob ids before relying on them (8/8 match).
  CW12a took its own copies of all 17 files it could touch: `cw12a_prewave/` (`SHA_LIST.txt`, 07:47:32Z).
- End: 0 staged; HEAD and `origin/merged` unchanged; nothing committed or pushed. The 86 pre-CW12a dirty/untracked
  files outside CW12a's shared set are byte-identical; the shared files gained additive hunks only (§6).

## 2. Skills and instructions found (and used)

Three `CLAUDE.md` files (`F:\level`, the app repo, and the vault `level_up\level_up` — the last belongs to the
knowledge vault, not this repo). Project skills: `build-screen` (the loop), `figma-frame`, `screen-states` (the 8-cell
definition of done), `river` (Riverpod pattern), `seif-api-contract`, `level-up-domain`, plus generic
`flutter-setup-localization`, `flutter-add-widget-test`, `flutter-build-responsive-layout`,
`flutter-apply-architecture-best-practices` and Dart helpers. Plugin skill: `figma-design-to-code` (used for the
three `get_design_context` reads and the asset rules). **No visual-verification skill exists**; the repo's goldens and
the AVD routine (memory: uiautomator coordinates, measurable screenshots) were used. Where a skill and the code
disagree (e.g. "skeleton loading" vs the inbox/leaderboard spinner precedent), the code's precedent was followed and
noted.

## 3. Boundary resolved

- **Frames** (read by name and content): list `178:2800`, create `178:3222`, thread `178:3378`. `309:8713`,
  `309:8819`, `180:7154` are light duplicates. **Not support:** `309:8915` and `178:3518` ("Upgrade to premium"
  paywall — the latter named "Customer Support") and `309:9146`, `296:3154` ("Favorite questions"). No dark and no
  Arabic support frame exists.
- **Contract:** the four text operations are `stable` on the pin `eddb6ac` and unchanged in upstream `cc2a29d`
  (3.48) — CW12a is correct on the current pin. Photos (spec-067) are out of scope (CW12b, after CW04).
- **Release gate for provisional copy: none exists** (no guard, flag or flavor resource excludes copy from a release).
  So no proposed EN or AR text was added to app resources (§5).
- **Files**: new feature folder; the placeholder `customer_support_screen.dart` (clean at HEAD) keeps its path and
  class name and becomes the list; shared files take additive blocks only.

## 4. What was built

- `/support` — **ticket list** (`178:2800`): the "Create a New Ticket" card (one button) → create; "Recent Tickets";
  rows with subject (full), `TK-n · yyyy-MM-dd`, and a "Closed" pill only for closed tickets; paged by 20 with Load
  more; loading / empty / error / offline / pending-deletion / rate-limit states; Retry rules as the inbox.
- `/support/new` — **create** (`178:3222`): Subject (≤120) and Details (≤4000), required-field and server field
  errors, submitting state, no double submit, success replaces the form with the new thread and refreshes the list.
- `/support/tickets/:ticketId` — **thread** (`178:3378`): header with the subject (2 lines max) and divider; the
  opening `details` shown first as "You", then replies (student = own avatar, staff = the frame's avatar, labelled
  "Customer Support"); all pages walked up to 10; composer (≤4000, keyboard Send key sends, send glyph mirrors in RTL);
  closed tickets get a closed bar ("Closed" + "Create a New Ticket") instead of the composer; `409 ticket_closed`
  switches to it; malformed-cursor `400` restarts from page one.
- Mock (`lib/dev/mock_support.dart`, 22 tickets incl. an unknown status, a 25-reply thread, 5-per-session create limit
  with `Retry-After`, 409/404/400 rules) wired into `mock_backend.dart`.

**Files.** New: `lib/features/support/` — models (+ generated), repository, 3 notifiers, error copy, 2 screens, 8
widgets; `lib/dev/mock_support.dart`; `assets/icons/support_{headset_disc,add,send}.svg` (Figma exports, byte-exact),
`assets/images/support_staff_avatar.png` (the frame's fill, 2048→108 px, no other change); tests:
`test/features/support/` (12 files) and `test/dev/mock_backend_support_test.dart`. Modified, clean at HEAD:
`customer_support_screen.dart` (+15/−17), `shell_screens_test.dart` (+1/−8, the `/support` placeholder rows only).
Modified, shared (additive): `app_router.dart` (+16), `mock_backend.dart` (+41), `app_en.arb` (+56), `app_ar.arb`
(+13/−1 comma), the 3 generated l10n files (+72/+39/+39), `app_colors.dart` (+222, 14 tokens), `app_elevation.dart`
(+230, 7 shadow lists + 4 Glass styles), `app_colors_test.dart` (+227), `app_elevation_test.dart` (+168/−1, the
props count 93→104), `docs/DESIGN_ISSUES.md` (+104, #131), `COMPLETION_STATE.md`.

## 5. Copy — approval status

| Class | Keys | EN | AR in the app | Status |
| --- | --- | --- | --- | --- |
| Reused, approved | `profileCustomerSupport` (title; staff author), `createTicket`, `leaderboardYou`, `nothingHere`, `retry`, `offline`, `genericError`, `loadMore`, `rateLimited`, `rateLimitedIn`, `errorValidationFailed`, `fieldRequired`, `fieldRejected`, `accountPendingDeletion` | approved | approved | final |
| New, Figma English | `supportCreateNewTicket`, `supportDescribeYourIssue`, `supportRecentTickets`, `supportNewTicketTitle`, `supportCreateTicketSubtitle`, `supportSubjectLabel`, `supportDetailsLabel`, `supportDetailsHint`, `supportSubmitTicket`, `supportStatusClosed`, `supportComposerHint` | Figma verbatim (design copy) | **the same English** — no Arabic | **Arabic NOT SUPPLIED** — proposals PROVISIONAL in the brief §4.2, not in the app |
| New, format only | `supportTicketMeta` = `{reference} · {date}` | — | same | no words |
| Isolated, not built | open / in_progress / pending pills; the send button's accessible label | proposed only | proposed only | **not in the app**; rows show no pill unless closed; send is reached by the keyboard's Send key |

`support_copy_status_test.dart` pins this state (tracking only — **not a release gate**). Nothing prevents a release
build from shipping English text in the Arabic UI of these screens.

## 6. Validation (gate `cw12a_gate.sh`, 2026-10-10T10:06:33–10:20:23Z)

| Check | Result |
| --- | --- |
| format (tracked + untracked) | 0 changed |
| gen-l10n drift | none (hash equal before/after) |
| ARB | 288 = 288, no duplicates; added exactly the 12 registered keys; AR == EN for them; no Arabic script in them; no pre-existing key changed; N-26 `phoneHint`, CW02 `errorAccountBanned`, CW07a `notifFilterAll` intact; **0 proposed-Arabic strings added to lib/ or the ARBs** |
| analyze | No issues found |
| targeted (each alone) | support +410, mock support +63, dev +194, settings +86, profile +199, notifications +173, home +73, shell +11, app_router +11, return_target +61 (CW02, unchanged), session_scope_discipline +6, account_pending_deletion +21, goldens +43, core/theme +113 — all passed |
| guards / contract / pin | +124 / 14/14 / 2/2 |
| `validate.sh` (full) | **2933 passed / 0 failed / 0 skipped**, OVERALL PASS (10:12:45–10:16:36Z) |
| `validate.ps1` (full) | **2933 passed / 0 failed / 0 skipped**, OVERALL PASS (10:17:01–10:20:08Z); changed-file blobs identical at gate start and end |
| tracked `test-results.md` | unchanged (report redirected via `LEVELUP_VALIDATE_OUT`) |
| safety scans (4,427 added lines) | logging 0; purchase words 0 (widened 0); phone/e-mail literals 0; `attachmentIds` only in "never sent" doc comments |
| separation | shared files: additions only, except the AR trailing comma and the elevation props count; 86/86 other pre-CW12a files byte-identical; CW07a's hunks still intact; N-26 lines intact (the old number appears only in the six historical audit files it was already in) |

Count reconciliation: CW07a closed at 2453; CW12a adds 480 (support 410 + mock 63 + copy/theme/route deltas − the
removed `/support` placeholder expectations) → 2933.

## 7. Review and fixes

Four independent Sonnet reviews (contract/data, visual fidelity, l10n/a11y/RTL, separation/test honesty): **0
blocker, 0 major**. Fixed in one round (each with tests, mutation-checked): malformed-cursor `400` restarts from page
one (list, thread, first walk); a stale send no longer leaves the composer disabled, and a 409 after a mid-send
refresh still closes the thread; a sent reply is not duplicated; the ticket row is 75.315 high with an 8 pill gap;
the staff avatar is drawn at its frame size 36×35; the composer's two drop-shadows converted (blur 3.7 / 1.6 — the
export's drop-shadow value is half the Figma blur); the send glyph mirrors in RTL; failures are live regions for
screen readers; the thread title wraps to 2 lines in its content direction; a rate-limited load says so
(`rateLimited`/`rateLimitedIn`); five test names/assertions made honest. Logged, not changed (shared or precedent):
`TitledChrome` clips titles at 2.0×, `CircleBackButton` is 35 dp (<48), spinners not skeletons, the light hint
contrast as drawn.

## 8. Visual evidence — Android emulator (AVD Pixel_8, API 36, 1080×2400 @ 420 dpi), mock build

`flutter build apk --debug --flavor staging -t lib/main_mock.dart`, fresh install 10:08Z. Screenshots:
scratchpad `cw12a_avd/01–21.png`. Walked: sign-in → Account → Customer Support → list → thread → reply sent (appended;
list re-ordered) → closed thread (closed bar) → create (empty submit → "هذا الحقل مطلوب" ×2; filled → new TK-1023
thread; Back → origin; list shows it first) → Load more (23 tickets, footer gone at the end).

- **Arabic light and dark, English light and dark**: RTL mirroring correct (back chip, discs, plus, pill, send
  glyph); approved strings in Arabic; the 11 unsupplied strings show in English in the Arabic UI, as designed.
- **Measured vs `178:2800`** (from accessibility bounds, ±0.4 dp): create card 104.0 dp (104); row 75.05 (75.3);
  row gap 10.3 (10); card → heading 24.8 (25); heading → first row 25.1 (25); composer field 56.0 (56).
- **Keyboard**: Gboard shows a Send action key for the composer (the accessible send path); not verified with
  TalkBack.
- **Text scale 2.0**: CW12a content wraps and grows without clipping; the shared `TitledChrome` title overlaps the
  back chip and is cut (inherited, #131 §11).
- Observations, not changed: in the Arabic UI an English one-line message hugs the right while wrapped English text
  aligns left (the BUG-020 content-direction rule; disappears with Arabic text); in dark, the full-width composer
  bar's Glass rim shows faint side edges (dark is a stand-in, #131 §4).
- **Not done:** physical device (Pixel 8 `45131FDJH0009G` attached but USB-unauthorized), iOS, staging backend,
  TalkBack/VoiceOver.

## 9. Blockers and decisions

- **O-14 (owner): the support copy.** Approve Arabic for the 11 keys (or replace the proposals), and EN + AR for the
  three status pills and the send label. Until then the Arabic UI shows English on these screens and non-closed rows
  carry no status pill. No mechanism stops a release with that state.
- **Designer:** status pills (DG-53), dark + Arabic frames, undrawn states and the closed bar, the staff avatar,
  date choice, type scale (#131).
- **Seif:** staging ticket seeds (SQ-15); the meaning of `pending` to a student; staging deployment of the support
  operations (not probed by us).
- **O-15 (owner):** shared-widget fixes (`CircleBackButton` 48 dp target, `TitledChrome` text scaling).
- Photos (CW12b) wait on CW04 (Terms) and the picker dependency.

## 10. Contract 3.48 — separate decision (O-11), not part of CW12a

CW12a needs nothing from 3.47/3.48. Adopting `cc2a29d` would mean, for the app:
- **`422 name_not_allowed`** (new behaviour on the stable `completeRegistration` and `updateMyProfile`): a blocked
  display name is refused; the registration token is not consumed, so the student edits the name and resubmits; do not
  retry the same name. Today the app does not recognise the code and would show a generic error. Needs a field error on
  the name and EN/AR copy (none is suggested in the contract).
- **`account_banned` wording**: the suggested client copy changed from "Account banned — contact Support" (what CW02
  ships, the 3.46 suggestion) to a sentence that tells the student to e-mail Support at a published address, with a
  matching Arabic suggestion; there is no anonymous in-app support channel. The client owns the strings — an owner
  decision whether to adopt and show the address.
- **Account deletion**: a suggested confirm-screen text (EN + AR) before `requestAccountDeletion`, marked "final
  wording pending the client's approval" — feeds CW05; nothing in the app uses it yet.
- Also: a new stable `getAppVersionPolicy` (anonymous, on launch), server-side push-token cleanup on ban/deletion,
  `enrolment_opened` data `{track}`, draft daily tasks. Re-vendoring updates `contract/` and the pin guard's blob ids;
  it is an owner call (D-022).

## 11. Store readiness

The frozen rubric (`docs/STORE_READINESS_RUBRIC.md`) has no item for support or stub screens, so **CW12a moves no
rubric score**. Last logged: Play 44%, Apple 20%; item 9b "CI observed green" is evidenced by run 37950164225 (≈46% /
22%), not yet written into the rubric. The reviewer walkthrough's REV-08d ("Customer Support → empty screen +
disabled Create Ticket") is superseded on the mock build only; staging is unverified.

## 12. Versions (read from the repo)

Flutter **3.44.7** (`.flutter-version`, pinned); Dart SDK `^3.10.4` (`pubspec.yaml`); Android `minSdk 24`,
`targetSdk 36`, `compileSdk 36` (`android/app/build.gradle.kts`); iOS deployment target **13.0**
(`project.pbxproj`; D-021's 15.0 is a planned Wave 3 change, not applied). Riverpod 3.3.2, go_router 17.3.0, Dio
5.10, flutter_svg 2.3, intl 0.20.2.

## 13. Git

Nothing staged, committed or pushed. Commit order when asked: N-26 → CW02 → CW07a → CW12a, explicit paths; CW12a's
shared-file hunks are separable against `cw12a_prewave/`.
