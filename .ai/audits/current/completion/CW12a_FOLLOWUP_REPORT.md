# CW12a follow-up — O-14 copy table, O-15 shared-widget fix, staging and design handoffs, 3.48 impact

*2026-10-10 · owner instruction "NEXT ACTION — CW12a COPY DECISION, SHARED ACCESSIBILITY FIXES, AND STAGING
READINESS". Opus plans and builds; Sonnet subagents did the three read-only inventories (Seif handoff, designer
handoff, 3.48 diff), and the key 3.48 facts were re-checked by hand. Nothing is staged, committed, pushed or sent.*

## 1. Baseline (verified before any change)

- Branch `merged`, HEAD `b227f61` = `origin/merged` (0 ahead / 0 behind). Staged: 0. 91 status lines, 33 untracked.
- **The 2933/0/0 CW12a gate still described the code:** all 121 changed/untracked files outside `completion/`
  were byte-identical to the CW12a gate's end blobs (`cw12a_blobs_end.txt`).
- `cw12a_prewave/` (17 copies + `SHA_LIST.txt`) present. `o15_prewave/` added now for the two shared docs O-15
  touches (`DESIGN_ISSUES.md`, `COMPLETION_STATE.md`).
- Skills used: `screen-states` (states + both languages), `flutter-fix-layout-issues` (constraint reasoning),
  `figma-frame` / `build-screen` (tokens, never eyeballed values), `seif-api-contract` (the support operations),
  `level-up-domain`. The instructions applied: both `CLAUDE.md` files (no inline colour/fontSize/fontWeight, the
  contract wins, never invent copy, reading is not running), memory (provisional-copy rule, D-013's "a box refuses a
  pointer outside its own size", device-test recipes). There is no visual-verification skill; before/after goldens
  in a throwaway copy did that job.

## 2. O-14 — the support copy, for owner approval

**Status: waiting on the owner. Nothing below is in the app's Arabic.** There is still no verified mechanism that
keeps provisional strings out of a release build, so no proposed text was added. The Arabic UI shows English for
rows 1–11, and rows 13–16 are not built.

| # | Key | EN (in app) | Proposed AR — PROVISIONAL | Where it appears | Status | Concerns |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `supportCreateNewTicket` | Create a New Ticket | إنشاء تذكرة جديدة | List · create card title (`178:3061`) | EN = Figma copy; AR not supplied | Near-duplicate of the approved `createTicket` "Create Ticket" / "إنشاء تذكرة" (create heading). One wording for both is worth considering |
| 2 | `supportDescribeYourIssue` | Describe your issue | اشرح مشكلتك | List · create card subtitle (`178:3065`) | same | Masculine singular imperative, the usual UI default. Confirm the house style for a mixed audience (also rows 8 and 11) |
| 3 | `supportRecentTickets` | Recent Tickets | أحدث التذاكر | List · section heading (`178:3079`) | same | "أحدث" reads "latest"; "التذاكر الأخيرة" is the closer "recent" |
| 4 | `supportNewTicketTitle` | New Ticket | تذكرة جديدة | Create · title bar (`178:3250`) | same | — |
| 5 | `supportCreateTicketSubtitle` | Describe your issue and we'll help you | اشرح مشكلتك وسنساعدك | Create · subtitle (`178:3343`) | same | Copy is fine. Its light contrast is 4.04:1 at 20 px (a design issue, #131 §9) |
| 6 | `supportSubjectLabel` | Subject | الموضوع | Create · field label = the field's accessible name (`178:3334`) | same | — |
| 7 | `supportDetailsLabel` | Details | التفاصيل | Create · field label = accessible name (`178:3346`) | same | — |
| 8 | `supportDetailsHint` | Describe the issue in detail... | اشرح المشكلة بالتفصيل... | Create · Details placeholder (`178:3352`) | same | A placeholder only; the label carries the meaning. Hint contrast 2.01:1 (design) |
| 9 | `supportSubmitTicket` | Submit Ticket | إرسال التذكرة | Create · primary button (`178:3375`) | same | The verb إرسال is already approved in `sendOtp` ("إرسال رمز التحقق") |
| 10 | `supportStatusClosed` | Closed | مغلقة | List row pill and thread (`178:3131`) | same | Feminine agrees with تذكرة |
| 11 | `supportComposerHint` | Write your message | اكتب رسالتك | Thread · composer placeholder (`178:3469`) | same | It is the composer's only accessible name and is gone once the student types. Contrast 2.58:1 (design) |
| 12 | `supportTicketMeta` | `{reference} · {date}` | (format only — identical) | List row meta (`178:3110` minus "#") | no words, nothing to approve | In RTL the Latin `TK-…` sits inside Arabic; the date follows the locale |
| 13 | pill `open` | Open | مفتوحة | List row, thread | **not built** — no approved text in either language | — |
| 14 | pill `in_progress` | In progress | قيد المعالجة | List row, thread | **not built** | The contract reads any unknown status as "in progress — not closed", so this label also covers statuses the app does not know |
| 15 | pill `pending` | Pending | معلّقة | List row, thread | **not built; blocked on SQ-32** | معلّقة can read as "suspended" / "on hold". The right word depends on what `pending` means to the student, so do not approve before Seif answers |
| 16 | send button's accessible name | Send | إرسال | Thread · composer send icon | **not built**: the icon is hidden from screen readers and the keyboard's Send action is the accessible path | Approving it lets the icon become a labelled button (better for TalkBack, VoiceOver and switch users) |

**Decision needed (O-14):** approve or edit the Arabic for rows 1–11, and EN + AR for rows 13, 14 and 16. Row 15
waits on SQ-32. On approval, the change is the AR values of 11 existing keys (EN unchanged), three new pill keys and
one label key, then the pills and the labelled send button.

## 3. O-15 — the back chip's 48 dp target, and titled bars at 2.0× text (BUILT, uncommitted)

Full record: `docs/DESIGN_ISSUES.md` #132.

**What changed:**
- `CircleBackButton` gained an opt-in padded mode (`tapTargetSize: MaterialTapTargetSize.padded`). The same 35 chip
  is laid out in a 48 box, centred or flush to one edge (`chipAlignment`), with one labelled button node the size of
  the box. `chipKey` keys the drawn chip.
- The bars that host it grow to at least 48 and take the extra out of their insets.
- `TitledChrome`'s title keeps clear of the 48 box on both sides and wraps instead of being cut.
- `EditProfileChrome` is now `TitledChrome`.

**Screens fixed (48 dp target, nothing drawn moves):** Settings, Customer Support (ticket list), New Ticket,
Notifications, Friends, Refer a Friend, Privacy & policy, Terms & Conditions, Quiz Setup, Flash Card Setup, Edit
Profile, Subjects / Units / Chapters / Lessons / Lectures, the Mistakes screens, Leaderboard, Quiz Result, Quiz
Review, Sign Up_1, Sign Up_2. **Text scaling fixed** on every `TitledChrome` screen (11 titles, incl. CW12a's list
and create, CW07a's inbox) and Edit Profile.

**Files (all clean at HEAD before O-15, so separable from every wave):**

| Group | Files |
| --- | --- |
| Shared widgets | `lib/core/widgets/{circle_back_button,titled_chrome,language_pill}.dart` |
| Catalog and profile | `lib/features/catalog/widgets/catalog_scaffold.dart`, `lib/features/profile/screens/edit_profile_screen.dart` |
| Leaderboard | `lib/features/leaderboard/screens/leaderboard_screen.dart` |
| Quiz | `lib/features/quiz/screens/quiz_{result,review}_screen.dart` |
| Registration | `lib/features/registration/screens/signup_{identity,track}_screen.dart` |
| Tests | new `test/core/widgets/back_chip_target_test.dart` and `test/features/registration/signup_back_target_test.dart`; edited `test/features/{leaderboard/leaderboard_screen,quiz/quiz_result_screen,quiz/quiz_review_screen,mistakes/mistakes_screens}_test.dart` |
| Docs | `docs/RESPONSIVE.md`, `DESIGN_ISSUES.md` (#132, additive), the two handoffs, this file |

No CW02, N-26, CW07a or CW12a file was edited. Their tests pass unchanged because `chipKey` keeps "the back chip"
meaning the drawn chip.

**Evidence (BUILD level, plus the Android emulator in §4; no physical device):**
- **Before/after captures.** 52 captures in a throwaway copy, made with the bundled fonts: EN + AR, 411 and 360 dp,
  plus light and dark for the chromes.
  - 44 are pixel-identical.
  - The 8 English `TitledChrome` / Edit Profile captures differ only in title anti-aliasing (≤ 0.43 dp, 0.04–0.41 % of
    pixels, none in the chip strip), because the title is now centred within its line box. A control run with the
    old alignment matched 32/32.
- **Regression tests.** `back_chip_target_test.dart` has 19 and `signup_back_target_test.dart` has 8. There is one
  each in the leaderboard, quiz result and quiz review tests. They prove:
  - the target is 48 × 48;
  - taps outside the drawn chip but inside the box go back;
  - there is one button node of 48 × 48, not an image;
  - `androidTapTargetGuideline` passes;
  - at 2.0×, every titled bar's title in EN and AR at 360 and 411 dp is whole: no clipping, no ellipsis, never under
    the target, body below it;
  - at 1.0× every title is one line from 360 dp.
- **Tests fail on the old behaviour.**
  - Against the pre-O-15 code, the three screen tests fail. The new widget tests do not compile there, because the
    API is new.
  - Behavioural mutations:

| Mutation | Tests that fail |
| --- | --- |
| padded drawn as 35 | 18 |
| a 35 `TitledChrome` bar with a one-line title | 9, incl. all four 2.0× tests |
| a 35 catalog header (D-013's mechanism) | 2 |

**Still limited (reported, not hidden):**
1. **Four call sites still have a 35 dp target.** OTP (`otp_screen.dart`, N-26/CW02), the unknown-route page
   (`route_error_screen.dart`, CW02), the support thread header (`support_ticket_screen.dart`, CW12a) and School /
   University detail (`RegistrationHeader`; the screens are N-26/CW02). Their files hold other waves' uncommitted
   work. Each is a one-site change once those commit.
2. **Mid-word breaks at 2.0×.** English "Notifications" breaks inside the word on 360 dp and narrower, and
   "Terms & Conditions" does at 320 dp. There is no mid-word break at 411 dp (Pixel 8 width) and none in Arabic.
   Avoiding it needs a layout decision, e.g. the title under the chip at large scales.
3. **Arabic "Edit Profile" at 320 dp, 1.0×.** "تعديل الملف الشخصي" takes two lines; it was one before. From 360 dp up
   nothing wraps at 1.0×.
4. **Other small targets unchanged.** The Mistakes pill (35, #80) and the language pill (36.1, #89).
5. **No ink in the padded slop.** A tap there shows no ripple.
6. **Walks not done.** Physical device, iOS and TalkBack. The Android emulator check passed (§4).

## 4. Validation

Gate `o15_gate.sh`, 2026-10-10T11:13:56–11:26:24Z (scratchpad log `o15_gate.log`). Every step exit 0.

**Format, l10n, analyze:**

| Check | Result |
| --- | --- |
| `dart format`, tracked + untracked hand-written Dart | rc 0, **0 changed** |
| `flutter gen-l10n` | no drift (generated hash `0cb025fb…` before = after) |
| ARBs and the 3 generated l10n files | byte-identical to the CW12a gate's end (O-15 adds no copy) |
| `flutter analyze` | rc 0, **No issues found** |

**Each run alone, all `All tests passed!`:**

| Run | Passed |
| --- | --- |
| `back_chip_target_test.dart` | 19 |
| `signup_back_target_test.dart` | 8 |
| `test/core/widgets` | 134 |
| catalog | 182 |
| mistakes | 78 |
| leaderboard | 54 |
| quiz | 299 |
| registration | 240 |
| profile | 199 |
| settings | 86 |
| notifications | 173 |
| support | 410 |
| flashcards | 223 |
| auth | 86 |
| home | 73 |
| shell | 11 |
| `test/core/router` | 72 |
| goldens | 43 |
| guards | **124** |
| contract guard | **14/14** |
| pin guard | **2/2** |

**Full suite:**
- `validate.sh`: rc 0, **OVERALL: PASS, 2963 passed / 0 failed / 0 skipped**. That is 2933 + the 30 new tests.
- `validate.ps1`: rc 0, **OVERALL: PASS, 2963 / 0 / 0**.
- Both wrote their report to the scratchpad (`LEVELUP_VALIDATE_OUT`). The tracked
  `.ai/audits/current/test-results.md` is unchanged (blob `57716a44`).

**Safety scans** over 914 added O-15 lines:
- logging 0, purchase words 0, inline colour / fontSize / fontWeight 0;
- one phone-shaped literal: the N-26 mock fixture in the new sign-up test, the same one `registration_screens_test`
  uses.

**Separation:**
- All 17 O-15 code, test and doc files were clean at HEAD before O-15.
- `DESIGN_ISSUES.md` is additions only against `o15_prewave/` (removed 0).
- **All 120 other changed or untracked files (N-26, CW02, CW07a, CW12a) are byte-identical to the CW12a gate's end.**
- The N-26 check is unchanged; the old number appears only in the six historical audit files it was already in.
- Changed-file blobs at the gate's end are identical to its start.

**Android emulator** (AVD Pixel_8, API 36, 1080 × 2400 @ 420 dpi, mock staging debug build, 2026-10-10 ~11:40Z).
The first install failed silently on low emulator storage. That build's two captures are discarded and marked
`00_OLDBUILD_*`. This project's own debug app was uninstalled and the new build installed (update time confirmed).

- **Back button node = 126 × 126 px = 48 dp** on:
  - Notifications, EN and AR
  - Customer Support list, AR, at 1.0× and 2.0×
  - Settings, AR and EN, at 2.0×
  - Leaderboard, EN: 7–55 dp, so the chip is still at 20–55
  - Units, EN; tapping it returned to Subjects

  RTL places it 13 dp from the right edge.
- **Customer Support list, AR, 1.0×:** the title-bar band (y 140–320 px) is pixel-identical to CW12a's pre-O-15
  emulator capture. The only difference is 180 px in one column at the emulator's frame edge, max 3/255.
- **2.0× font scale:** the AR Support title is whole, centred and clear of the chip; it overlapped and was cut
  before O-15. The EN "Notifications" title is one line and whole at 411 dp.
- **Captures:** scratchpad `o15_avd/`.

**Not done:** physical Pixel 8 (USB not authorised), iOS, TalkBack, staging.

## 5. Seif — staging questions and the message

Inventory: nothing in `02_SEIF_HANDOFF.md` has been sent. SQ-01 to SQ-30 are drafted, and SQ-31 is proposed but not
filed. `pending` meaning, support staging availability and ticket `Retry-After` were not asked anywhere. SQ-15
covered only "an open ticket with a staff reply; and a closed ticket".

**Added (draft, not sent), as `02_SEIF_HANDOFF.md` §F:**
- **SQ-15 (support part, amended):** an open ticket with a staff reply, an in-progress, a pending and a closed
  ticket. Account A owns them and account B has none, for the isolation check. Details go through the owner's
  private channel.
- **SQ-32 (new):** what `pending` means to the student.
- **SQ-33 (new):** are the five text-ticket operations deployed on staging? The brief said four; the contract has
  five.
- **SQ-34 (new):** `Retry-After` presence and format on ticket create and reply 429s. It shares a format answer with
  SQ-22.

The ready-to-send message is §F.1 there. The app's documented fallback when `Retry-After` is absent, an HTTP-date or
otherwise unparseable: the generic rate-limit line with no countdown, and no Retry.

**Preserved, not re-asked:**
- SQ-20 (`enrolment_opened`)
- SQ-31 (proposed, not filed)
- the CW07a unread-count and inbox-copy questions (proposed, no id)
- `name_not_allowed` staging behaviour (behind O-11)

**Verification level:** contract-defined only. No ticket operation has been called on staging with a signed-in
account; the only evidence is an unauthenticated 401, from 2026-10-08.

*Superseded by §12.4–§12.5 (second pass): all five operations were verified signed in on staging, SQ-33 is
withdrawn and SQ-34 is answered by upstream 3.47.0-m1 text.*

## 6. Designer — the message

Inventory: nothing in `03_DESIGNER_HANDOFF.md` has been sent.
- **Already asked, kept:** dark and Arabic frames (DG-35), status pills (DG-53), generic states (DG-15 to DG-17,
  DG-31), camera and mic removal (DG-54), photo hint and attach (DG-52, DG-18).
- **Never asked:** the avatar, the date meaning, off-scale sizes, contrast, "Seen" / "See All", the Support-specific
  error states, and renaming the mis-mapped frames.
- **Wrong in the handoff itself:** DG-15 and DG-17 list four paywall and favourites frames as Support.

**Added (draft, not sent), as `03_DESIGNER_HANDOFF.md` §10:**
- §10.1 corrects DG-15 and DG-17.
- New row **DG-63** covers the unasked items. DG-55 was already taken, so the next free id is used.
- §10.3 is the ready-to-send message.

The shared-widget fixes stay implementation work. Nothing in them waits on the designer.

## 7. Contract 3.48 — impact for O-11 / D-022 (the pin stays `eddb6ac`; nothing under `contract/` changed)

Upstream `cc2a29d` (3.48.0-m1) was confirmed by `git ls-remote` this session. Facts were read from the local clone
by a Sonnet agent, and the key ones re-checked by hand: `info.version`, error-codes rows 53 and 73, the deletion
copy, `getAppVersionPolicy`, and no change to the support operations.

| Change | Relevance | Who decides |
| --- | --- | --- |
| **`422 name_not_allowed`** (3.47, BEHAVIOURAL, stable `completeRegistration` + `updateMyProfile`) | **Now.** The app shows the generic error, highlights no field, and the student may resubmit the same name. Correct handling: a name-field error, EN/AR copy, keep the draft so the name can be corrected and resubmitted. The registration token is not consumed, and a PATCH checks only a new or changed name. There is no field pointer in the response, so the code itself maps to "name". The contract suggests EN "This name isn't allowed. Please choose another." / AR "هذا الاسم غير مسموح. يرجى اختيار اسم آخر." — still copy for the owner to approve. Whether staging already enforces it is unprobed | Owner (re-vendor + copy) |
| **`account_banned` copy** | **Now, if wanted.** The suggestion now names `support@level-upworld.com`; CW02 shows "Account banned — contact Support". The client owns the wording, so it was not adopted. Showing an e-mail address to minors, and whether that mailbox exists, are owner and backend questions | Owner + Seif |
| **Deletion confirm copy** | **Later (CW05).** Suggested EN/AR is "pending the client's approval". It removes the old paid/refund wording that clashed with purchase silence (SQ-03) | Owner |
| **`getAppVersionPolicy`** (new, stable, public, mobile) | **Later (release prep).** Blocking-update and nudge rules; it answers SQ-23. New scope, no breakage | Owner (scope) |
| **Push-token cleanup** on logout, new session, ban and deletion | **Later (CW08a).** Input to the push design; the client must re-register after every sign-in, token refresh and cancelled deletion. Mostly answers SQ-09 | — |
| **`enrolment_opened` data `{track}`** | **Later (CW07b).** Half of SQ-20; still no copy. The app ignores the kind, and the mock's empty `data` is now out of step | Seif (copy) |
| **Daily tasks** (`listMyDailyTasks`) | **Not buildable** (draft) | Seif (flip to stable) |
| Other stamps (level ladder fix, recovery lock) | No app change now (CW06 for the lock) | — |

*Updated by §12.7–§12.8 (second pass): staging enforces `name_not_allowed` on `updateMyProfile`, and the client behaviour is BUILD-reproduced. `getAppVersionPolicy` is live on staging.*

**Mechanics if approved:**
- Copy the four files with `git show cc2a29d:<file>`; all are LF.
- Update `SOURCE.md`: commit, `info.version at this pin: 3.48.0-m1` (the only value `contract_pin_test` checks
  exactly), the census (re-count with a YAML parser) and the four blob ids.
- `contract_models_test` is expected to pass unchanged (no required-list change).
- About 139 `openapi.yaml:NNN` / `error-codes.md:NNN` line citations go stale; this is cosmetic.
- CW12a's operations are unchanged.

## 8. CW12b (photos) — still blocked

Photo attachments stay out of CW12a. Nothing in this pass added a camera, microphone, picker or upload. CW12b is
blocked by two things:
1. **CW04 Terms acceptance.** Photos are Terms-gated with `403 terms_acceptance_required`; text never is.
2. **An approved photo-picker dependency.** No new dependency was added. H-16 holds the picker decision.

Also needed: the photo designs (DG-18, DG-52), the hint wording (H-15), and SQ-25 / SQ-26 (storage failure rules
and host).

## 9. Versions (read from the repo this session)

| Component | Version | Source |
| --- | --- | --- |
| Flutter | **3.44.7** | `.flutter-version` |
| Dart SDK | `^3.10.4` | `pubspec.yaml` |
| Android | `minSdk 24`, `targetSdk 36`, `compileSdk 36` | `android/app/build.gradle.kts` |
| iOS deployment target | **13.0** | `ios/Runner.xcodeproj/project.pbxproj`, 3 occurrences; D-021's 15.0 is planned, not applied |

## 10. Store readiness

The frozen rubric (`docs/STORE_READINESS_RUBRIC.md`) has no tap-target, text-scaling or accessibility item, so
**O-15 and O-14 move no rubric score.**
- **Last logged score: Play 44 %, Apple 20 %.** These are the rubric's own numbers, not re-scored now.
- The CI-green item (run 37950164225, about 46 % / 22 %) is still not written into the rubric.
- No new verified score is claimed.

## 11. Git

- **Branch and commit:** `merged`, HEAD `b227f61` = `origin/merged` (0 / 0).
- **Staged: 0. Committed: nothing. Pushed: nothing. Sent: nothing** (Seif and designer messages are drafts in the
  handoff files).
- **Status:** 91 → **112** lines (75 modified, 37 untracked).
  - **17 newly modified, all clean at HEAD before:** the 10 lib files, the 4 test files, `docs/RESPONSIVE.md`,
    `02_SEIF_HANDOFF.md` and `03_DESIGNER_HANDOFF.md`.
  - **4 new untracked:** the 2 new tests, this report and `o15_prewave/`.
  - **2 already-dirty shared docs gained O-15 hunks:**
    - `docs/DESIGN_ISSUES.md`: #132 only, additive.
    - `COMPLETION_STATE.md`: 4 lines CW12a had written were updated, and CW12a's version is in `o15_prewave/`.
- **Contract:** `contract/` unchanged and the pin still `eddb6ac`. No dependency was added; `pubspec.yaml` and
  `pubspec.lock` are unchanged.
- **Suggested commit order, on request:** N-26 → CW02 → CW07a → CW12a → O-15. O-15 is a self-contained commit:
  its code and test files touch no other wave's lines.

---

## 12. Second pass — 2026-10-10, "NEXT STEP — FINALIZE CW12a COPY, VERIFY STAGING READINESS, AND CLOSE REMAINING GAPS"

*Opus leads, and five read-only Sonnet checks ran in one workflow: the O-15 claims, the `name_not_allowed` client
path, Seif de-duplication, designer de-duplication and the O-14 cross-check. Two Sonnet re-checks verified the load-
bearing two. The staging run and the reproduction are Opus's own, in a throwaway copy. Nothing is staged, committed,
pushed or sent. No app code, copy, ARB, contract file, pin or guard changed in this pass.*

### 12.1 Baseline

- `merged` @ `b227f61` = `origin/merged` (0 / 0). Staged 0.
- **Code = the 2963/0/0 gate.** All 138 changed or untracked files outside `completion/` are byte-identical to the
  O-15 gate's end blobs (`o15_blobs_end.txt`). The one exception is `docs/DESIGN_ISSUES.md`: the post-gate evidence
  lines inside #132, which add 0 removed lines against `o15_prewave/`.
- `o15_prewave/` blob ids match `SHA_LIST.txt`. Tracked `test-results.md` is still blob `57716a44`.
- `fu2_prewave/` (taken 2026-10-10T12:08:12Z) holds copies of the five docs this pass could touch.
- **Status:** 112 → 114 lines. New untracked: `smoke-staging-2026-10-10.md` and `fu2_prewave/`. Newly modified:
  none (the three edited handoff/state docs were already modified).

### 12.2 O-14 — final copy approval table

*Superseded by §13 (third pass, 2026-10-10): the owner approved this table (Pending excepted) and it is applied. The table below is kept as the approval record.*

Cross-checked character for character against `CW12a_PLAN.md` (rows 1–12 in §4.2, rows 13–16 in §4.3) and the
ARBs. **Every proposal matches the plan; nothing was invented.** Wording the plan does not contain is marked **NEW
SUGGESTION**. None of the Arabic below is in the app: rows 1–11 show the English in the Arabic UI, and rows 13–16
are not built.

| # | Key | English (in app) | Proposed Arabic (plan, provisional) | New suggestion (not in plan) | Concern |
| --- | --- | --- | --- | --- | --- |
| 1 | `supportCreateNewTicket` | Create a New Ticket | إنشاء تذكرة جديدة | Reuse the approved `createTicket` "إنشاء تذكرة" for both | Near-duplicate of `createTicket` |
| 2 | `supportDescribeYourIssue` | Describe your issue | اشرح مشكلتك | — | Masculine imperative: confirm house style (also rows 5, 8, 11). It matches approved strings such as "أدخل رقم هاتفك" |
| 3 | `supportRecentTickets` | Recent Tickets | أحدث التذاكر | التذاكر الأخيرة | أحدث reads "latest" |
| 4 | `supportNewTicketTitle` | New Ticket | تذكرة جديدة | — | — |
| 5 | `supportCreateTicketSubtitle` | Describe your issue and we'll help you | اشرح مشكلتك وسنساعدك | — | Contrast 4.04:1 (design) |
| 6 | `supportSubjectLabel` | Subject | الموضوع | — | It is the field's accessible name |
| 7 | `supportDetailsLabel` | Details | التفاصيل | — | It is the field's accessible name |
| 8 | `supportDetailsHint` | Describe the issue in detail... | اشرح المشكلة بالتفصيل... | — | Placeholder only; contrast 2.01:1 (design) |
| 9 | `supportSubmitTicket` | Submit Ticket | إرسال التذكرة | — | إرسال is approved vocabulary (`sendOtp`) |
| 10 | `supportStatusClosed` | Closed | مغلقة | — | **Current closed wording:** "Closed" in both languages. No Arabic was ever approved |
| 11 | `supportComposerHint` | Write your message | اكتب رسالتك | — | The composer's only accessible name; contrast 2.58:1 |
| 12 | `supportTicketMeta` | `{reference} · {date}` | (format, identical) | — | Nothing to approve |
| 13 | pill `open` (new key) | Open | مفتوحة | — | Not built |
| 14 | pill `in_progress` (new key) | In progress | قيد المعالجة | — | Not built; it also labels any status the app does not know (contract rule) |
| 15 | pill `pending` (new key) | Pending | معلّقة | — | **Do not approve: waits on SQ-32.** It can read as "suspended" |
| 16 | send button label (new key) | Send | إرسال | — | Not built; it turns the hidden icon into a labelled button |

**Decision needed from the owner (O-14):**
- For **rows 1–11**, approve or edit the Arabic (row 10 is the "Closed" pill).
- For **rows 13, 14 and 16**, approve or edit the English and the Arabic.
- Pick or reject the new suggestions in rows 1 and 3.
- Rule on the house style for the imperative (rows 2, 5, 8 and 11).
- **Row 15 waits for Seif's answer to SQ-32.**

Silence is not approval. Until the owner answers, the English stays in the Arabic UI, rows show no pill unless the
ticket is closed, and the send icon stays unlabelled.

*Adversarial re-check (Sonnet), after the hand-back:* all 16 rows were re-confirmed code point for code point, and
the "Closed" claim holds (no Arabic was ever approved). The supporting detail had three slips, none of which
changes a row:
- `supportCreateNewTicket` (row 1) is **also the closed-thread bar's button label**. Adopting the row 1 suggestion
  ("إنشاء تذكرة") changes that button too.
- إرسال also appears in the approved `resendIn` ("الإرسال").
- The `رسالة` precedent cited for row 11 (`notifModerationWarning*`) is CW07a's uncommitted copy, not at HEAD.
The `name_not_allowed` re-check confirmed the client path (generic line, no field marked, draft and token kept,
same name re-sendable). It corrected only side remarks: 422 is already used for quiz `not_enough_questions`, and
one existing test drives a real Dio through the interceptors.

### 12.3 O-15 — verification

The claims were re-checked against the current code (a read-only Sonnet check with its own BUILD probes in a
scratch copy, plus a fresh run in the repo). **The claims hold.**

| Claim | Result | Evidence |
| --- | --- | --- |
| `CircleBackButton(tapTargetSize: padded)` gives one labelled 48×48 node, and the drawn chip stays 35 | **Confirmed** | `circle_back_button.dart:85-160`; probe: 1 node, 1 tap action, label "Back" |
| `TitledChrome` bar ≥ 48, title wraps (no `maxLines`), kept clear of the box, chip still at (20, 16), body at 59 | **Confirmed** | `titled_chrome.dart:69-100`; `back_chip_target_test.dart:204-221` |
| Call sites | **7 padded constructor sites** (`TitledChrome`, `CatalogHeader`, Leaderboard, Quiz Result, Quiz Review, Sign Up 1 and 2). Through `TitledChrome`, `CatalogScaffold` and `EditProfileChrome` they cover Settings, the Support list, New Ticket, Notifications, Friends, Refer, Privacy, Terms, Quiz Setup, Flash Card Setup, Edit Profile, every catalog level and every Mistakes level. **4 shrinkWrap**: OTP `otp_screen.dart:119`, route error `route_error_screen.dart:45`, support thread `support_ticket_screen.dart:307`, RegistrationHeader `registration_chrome.dart:27` (School and University detail) | grep of every `CircleBackButton(` |
| Regression tests | **19 + 8** in the two new files, plus 1 each in Leaderboard, Quiz Result and Quiz Review. Fresh run in the repo: **125/125** across the five files. The three mutations still give 18 / 9 / 2 failures | BUILD |
| Mid-word wrap at 2.0× (EN "Notifications" ≤ 360 dp; "Terms & Conditions" at 320) | **Confirmed**, not pinned by any test (the 2.0× tests assert whole text at 360/411 only). Arabic never breaks mid-word | probe with the bundled fonts |
| Arabic Edit Profile wraps at 320 dp, 1.0× | **Confirmed** (one line from 360) | probe |
| Mistakes pill 35 dp (#80), language pill 36.1 dp (#89) | **Confirmed** | `subjects_screen.dart:139`, `language_pill.dart:31` |
| Support screens: other targets under 48? | **None** besides the thread's back chip: send 48, closed-bar button 48, rows ≥ 75 | source |

**Correction to the earlier record.** "Their files hold other waves' work" is exact for three sites, not four:
- **OTP:** CW02, 12 hunks. The header lines sit outside them, but one scroll padding the fix needs is inside a CW02
  hunk. The fix is 5 coordinated edits, including a 48 dp strut so the success view does not jump.
- **Route error page:** a whole untracked CW02 file.
- **Support thread:** a whole untracked CW12a file.
- **RegistrationHeader** lives in `registration_chrome.dart`, which is **clean**. The compensating insets (scroll
  padding, and the 25 gap after the header) are in `school_detail_screen.dart` / `university_detail_screen.dart`.
  Both carry CW02 hunks, though the lines to change are outside them. Some existing geometry tests measure from the
  header rect, so they need their measurement updated, not their expectations.

**The narrow fixes, explained and not made** (they would mix O-15 hunks into other waves' commits):

| Site | Files | Change | Test | Risk / where it lands |
| --- | --- | --- | --- | --- |
| Support thread | `support_ticket_screen.dart` (CW12a, untracked) | `start: _chipStart - tapSlop`, `chipKey:`, padded. No vertical change: the 63 header fits 48 | Geometry in EN and AR, a tap 10 dp past the chip pops. Tighten `expectOnlyTheBackChipIsSmall` to a plain guideline check | Low; **can fold into the CW12a commit on the owner's word** |
| Route error | `route_error_screen.dart` (CW02, untracked) | padded + `8 - tapSlop` top inset | `return_target_test.dart` errorBuilder group: 48 box, chip at (24, 8), tap past the chip goes Home | Low. The centred message moves about 3 dp (no frame exists). Lands in CW02 |
| RegistrationHeader | `registration_chrome.dart` (clean) + 2 detail screens (CW02-dirty) | padded/centerStart + a `slop` constant; callers: top inset and gap minus slop | Geometry and tap tests in both tracks and both languages; re-measure the 25-gap tests | Low-medium; 3 files, hunk-split from CW02 |
| OTP | `otp_screen.dart` (CW02) | 5 edits incl. the strut | OTP rhythm test re-measured; tap test | Medium; entangled with the CW02 banned-notice hunk |

**New candidate (clean files):** the **Mistakes pill** on Subjects (#80). Its blocker, the 35-tall `CatalogHeader`, is
gone since O-15: the header is now a 48 floor. So the pill's hit box could be padded to 48 in
`subjects_screen.dart` (clean), with `subjects_screen_test.dart:353-381` (clean, which pins 35 today) updated.
**Not made**: it is a new scope item for the owner.

**Doc nits found in O-15's own work (not fixed, so no code changed in this pass):**
- `titled_chrome.dart:16-18` still says it is used by "Settings and the four shell screens" and that
  `EditProfileChrome` "is left alone". It has 10 users, and O-15 made Edit Profile delegate to it.
- `subjects_screen.dart:113-135` and `subjects_screen_test.dart:343-351` still describe a 35-tall header.
- `DESIGN_ISSUES` #89 cites `_height` (now the public `height`).
- #80 is not annotated with O-15.

These are one-line fixes for the commit-prep step.

### 12.4 Staging — the five ticket operations, signed in

Record: **`.ai/audits/current/smoke-staging-2026-10-10.md`** (new, untracked). The run used the documented
whitelisted staging test account through the app's own seam (AppConfig → Dio → interceptors → repositories →
freezed). Only `SecureStorage` was stubbed, and the run was a scratch probe in a throwaway copy, never in the repo.
The backend was commit `1f4f0a8`, built 2026-10-10T05:01:43Z. The run took 12:03:16–12:03:54Z and exited 0. The
level is **API**: not DEVICE, not a UI walk, not CI.

| Evidence | Result |
| --- | --- |
| Unauthenticated: the 5 routes / an unknown route | 401 `authentication_required` / 404 `not_found` (routed, not proof of function) |
| `listMySupportTickets` | ✅ decodes; the account had **0 tickets** (then 1 after the create) |
| `getMySupportTicket` | ✅ decodes |
| `listMySupportTicketMessages` | ✅ decodes (0 → 1 message, `authorKind` `student`) |
| `createSupportTicket` | ✅ `open`, `TK-<digits>`, `closedAt` null; the new ticket is listed first |
| `postMySupportTicketMessage` | ✅ `authorKind` `student`; the status stays `open` after the reply |
| Unknown or malformed id on get / messages / reply | 404 `not_found` |
| **Not verified** | another student's ticket (needs account B), staff reply, `in_progress` / `pending` / `closed`, `409 ticket_closed`, 429 + `Retry-After` (would take 6 creates or 61 replies — not done on purpose) |
| **Left on staging** | one open test ticket ("Mobile app staging check - please ignore", one student reply). The revised Seif message asks Customer Service to close it. The account's name is unchanged |

The pinned contract already said these five are "deployed to staging" (changelog 3.39.0-m1, `cl:119-120`). That was
contract evidence; this run is the live evidence. `GET /app/version-policy` (3.47) answers 200 with every value
`null`.

### 12.5 Seif — revised draft (not sent)

`02_SEIF_HANDOFF.md` §F was corrected in place, and the first draft is kept in `fu2_prewave/`. §F.4 records why.
- **SQ-33 is withdrawn.** It was answered by the pinned changelog and by the run.
- **SQ-34 is answered by upstream 3.47.0-m1 text.** `Retry-After` is "always a whole number of seconds" and is sent
  with `rate_limited`, the code both ticket 429s use. It is not in the pin until O-11 and was not observed live.
- **SQ-15:** Section B's two support items are struck so the seed ask goes once, and the row is cross-referenced with
  SQ-16.
- **SQ-32** stays open.
- **New in the message:** please close the test ticket.
- **F.3:** `name_not_allowed` is now "enforced on `updateMyProfile`". A list of Section B questions that 3.47.0-m1
  text answers (SQ-22, 23, 24, 25, the ladder part of 28; partly SQ-03, 09, 12, 20, 26) marks them "do not send as
  written".
- **Preserved:** SQ-20, SQ-31 (reserved, not filed), the unread-count and inbox-copy questions, the registration
  half of `name_not_allowed`.

The message, ready for the owner to send, is §F.1. Its full text is in the final hand-back.

### 12.6 Designer — revised draft (not sent)

`03_DESIGNER_HANDOFF.md` §10 was corrected in place, with the first draft in `fu2_prewave/`. §10.4 records why. The
read-only check found real errors in the first draft:
- **Frames:** **three** frames are misnamed "Customer Support" (`178:3518` paywall; `309:9146` and `296:3154`
  favourites), not two. `309:8713`, `309:8819` and `180:7154` are recorded as light **School** duplicates, so they
  are not asked about as University twins. DG-15, DG-17 and DG-35 now carry struck-through ids and pointers; nothing
  was deleted.
- **Dark-frame lead:** the Glass audit (#55) records Customer Support `337:8390` / `337:8543` and a Create Ticket
  frame with Glass. Glass is the dark elevation, so these may be the dark Support frames that "do not exist". The
  message asks before requesting new frames. Figma was not opened: the Figma connector needs re-authorising.
- **Wording:** the camera and mic are deleted for good (DG-54), not part of the photo step. "Seen" has no contract
  field. The type mapping that was actually built is stated, instead of "confirm as drawn". Contrast now names each
  element and its hex. Pending deletion is not a Support state (DG-02 / CW05).
- **Added:** the pill contrast and unknown-status rule, the thread-timestamp question, the "list is sorted by last
  activity" fact for the date question, and "answer under DG-63 in the §8 table".

### 12.7 `name_not_allowed` (3.47.0-m1) — findings

| Question | Answer | Level |
| --- | --- | --- |
| Does staging enforce it? | **Yes on `updateMyProfile`**: 422 `name_not_allowed`, name unchanged; a PATCH re-sending the stored name is not refused. **Registration not probed**: it needs an unregistered number, and an unenforced filter would create an account | API (staging run) |
| What does the network layer make of it? | A plain `ApiException(status: 422, code: 'name_not_allowed')`: the default arm, code preserved, not `unknown` (`error_interceptor.dart:48`) | SOURCE + API (seen through the real Dio stack on staging) |
| What does the student see today: sign-up (School and University)? | The detail screen's banner says **"Something went wrong"** (generic in AR too). No field is marked, and the name field is two screens back on Sign Up 1. The draft and `registrationToken` are kept, no tokens are written, and nothing routes away. **The same name can be sent again** | BUILD (reproduced in a throwaway copy) |
| …and on Edit Profile? | The banner says **"Something went wrong"**, with nothing under the name field. The student stays on `/profile/edit`, the typed name is kept, and the same name can be saved again | BUILD (reproduced) |
| Minimal handling | **Edit Profile:** `rejectedFields` (clean `profile_error_copy.dart`) returns `{'name'}` for this code; the screen already renders a rejected name with the approved `fieldRejected` line. **Sign-up:** `fieldIssuesFrom` (clean `registration_error_copy.dart`) maps it to the name field. The detail screens (CW02 hunks) then send the student back to Sign Up 1 **without resetting the draft**, and drop it from the banner. Sign Up 1 (O-15 hunks) shows the name error and clears the stale submit error. Add a code predicate beside `isAccountBanned`. Tests: mapping, both mappers, the notifier (same token resubmitted), and widget tests in EN and AR | SOURCE (plan) |
| Copy needing approval | The minimal variant needs **none**: it reuses the approved `fieldRejected` ("Please check this field"). A dedicated message needs owner-approved EN and AR. The contract suggests EN "This name isn't allowed. Please choose another." / AR "هذا الاسم غير مسموح. يرجى اختيار اسم آخر." — **not adopted** | — |
| Navigation intent | "Send the student back to Sign Up 1" is a navigation decision with no frame, so it is the owner's call | — |
| Is re-vendoring to 3.48 necessary? | **Technically no.** The code string already reaches the app, and no guard ties error codes to the vendored contract. **By the project rules, effectively yes.** The pinned 3.46.0-m1 declares neither 422, and code that handles it cites unvendored text. That needs O-11, or an explicit owner OK to build ahead of the pin | SOURCE |

Nothing was implemented: no copy, no pin change, no guard change.

### 12.8 3.48 — what changed since §7

§7 stands, with three facts added:
- **`name_not_allowed` is live** on staging for profile edits (§12.7).
- **`getAppVersionPolicy` is live** on staging and returns all `null`.
- **The 3.47 `Retry-After` note answers SQ-34 and SQ-22.**

These stay separate later-scope decisions, none adopted: the banned-account wording, the deletion wording (CW05),
`getAppVersionPolicy` (release prep), push-token cleanup (CW08a), `enrolment_opened` (CW07b) and draft daily tasks.

### 12.9 CW12b — unchanged

Still blocked on CW04 Terms acceptance and an approved photo-picker dependency (H-16). It also needs DG-18, DG-52,
H-15 and SQ-25 / SQ-26 (SQ-25's rule is now in 3.47 text; SQ-26 still has no hostname). No photo, camera, microphone
or upload code was added.

### 12.10 Validation (this pass)

No app code, test, ARB, generated file, contract file, pin, guard or dependency changed in this pass, so these runs
re-confirm the unchanged tree:

| Check | Exit | Result |
| --- | --- | --- |
| Focused O-15 tests (two new files + Leaderboard, Quiz Result, Quiz Review), in the repo | 0 | **125 passed** |
| `test/guards` alone | 0 | 124 passed |
| `contract_models_test` / `contract_pin_test` | 0 / 0 | 14 / 2 passed |
| `sh tool/validate.sh` (`LEVELUP_VALIDATE_OUT` = scratchpad), 12:15:07–12:18:23Z | **0** | format 0 changed, analyze "No issues found!", **2963 passed / 0 failed / 0 skipped, OVERALL: PASS** |
| `tool/validate.ps1` (same redirect), 12:18:24–12:21:09Z | **0** | analyze "No issues found!", **2963 / 0 / 0, OVERALL: PASS** |
| Tracked `.ai/audits/current/test-results.md` | — | unchanged (blob `57716a44`) |
| Scratch: staging probe (throwaway copy) | 0 | see §12.4 |
| Scratch: `name_not_allowed` reproduction (throwaway copy, 3 injected tests) | 0 | 3 passed (findings in §12.7) |

Not done: physical Pixel 8, iOS, TalkBack, a UI walk against staging.

### 12.11 Git (end of the second pass)

- `merged` @ `b227f61` = `origin/merged` (0 / 0). **Staged 0, committed nothing, pushed nothing, sent nothing.**
- **Status:** 112 → **114 lines**, adding 2 untracked: `.ai/audits/current/smoke-staging-2026-10-10.md` and
  `completion/fu2_prewave/`.
- **Edited, all docs and all already modified:**
  - `02_SEIF_HANDOFF.md`: §F rewritten; Section B SQ-15 struck for its two support items.
  - `03_DESIGNER_HANDOFF.md`: §10 rewritten; DG-15, DG-17 and DG-35 struck in place.
  - `COMPLETION_STATE.md`.
  - This report (untracked).
- **Unchanged:** every lib, test and tool file, `contract/` and `pubspec.*`. They match the O-15 gate's end blobs.
- **Commit order, on request:** N-26 → CW02 → CW07a → CW12a → O-15. This pass adds only docs. The smoke record and
  the handoff changes belong with whichever commit the owner chooses for the records.

## 13. Third pass — 2026-10-10, "APPLY APPROVED O-14 COPY, CLOSE CW12a GAPS, AND PREPARE THE NEXT IMPLEMENTATION DECISIONS"

The owner approved the O-14 copy table in writing (the brief's §2). This pass applies **exactly** that table and
nothing else: `pending`, `name_not_allowed`, contract 3.48, the remaining O-15 scope and CW12b stay behind their own
decisions.

### 13.1 Baseline

- `merged` @ `b227f61` = `origin/merged` (0 / 0). 114 status lines (75 M, 39 ??). Staged 0, stash 0.
  `backup/2026-08-22-dirty-tree` and the two idle worktrees are present.
- **Every dirty path matched the second pass's end list** byte for byte (`fu2_blobs_end.txt`, raw hashes). The
  only differences were in `completion/` itself, from this report's own second-pass edits. So the 2963 / 0 / 0
  baseline applied.
- The brief names `F:\level\level\level_up_app`. The repository is `F:\level\level_up\level_up_app` (same branch,
  HEAD and status), which is what this pass used.
- **Backups:** `completion/o14_prewave/` holds 18 files, plus `SHA_LIST.txt` and `TAKEN_AT.txt`
  (2026-10-10T13:53:14Z; the create-ticket test was added to it before its first edit). It covers every file this
  pass touches, including the removed `support_closed_pill.dart`.

### 13.2 The approved copy, applied

Every Arabic string was checked code point for code point against its source before writing (patch script
`o14_patch_arb.py`):
- rows 2 and 4–11, 13, 14 and 16 against `CW12a_PLAN.md` §4.2 and §4.3
- row 1 against the approved `createTicket`
- row 3 against §12.2's new suggestion

| # | Key | English | Arabic (approved) | Where it shows |
| --- | --- | --- | --- | --- |
| 1 | `supportCreateNewTicket` | Create a New Ticket | إنشاء تذكرة | Create card title (`support_create_card.dart:85`) **and** the closed bar's button (`support_composer.dart:329`) |
| 2 | `supportDescribeYourIssue` | Describe your issue | اشرح مشكلتك | Create card subtitle (`support_create_card.dart:92`) |
| 3 | `supportRecentTickets` | Recent Tickets | التذاكر الأخيرة | List heading (`support_tickets_list.dart:168`) |
| 4 | `supportNewTicketTitle` | New Ticket | تذكرة جديدة | Create screen top bar (`create_support_ticket_screen.dart:146`) |
| 5 | `supportCreateTicketSubtitle` | Describe your issue and we'll help you | اشرح مشكلتك وسنساعدك | Create screen subtitle (`:165`) |
| 6 | `supportSubjectLabel` | Subject | الموضوع | Subject label and the field's accessible name (`:174`) |
| 7 | `supportDetailsLabel` | Details | التفاصيل | Details label and the field's accessible name (`:186`) |
| 8 | `supportDetailsHint` | Describe the issue in detail... | اشرح المشكلة بالتفصيل... | Details hint (`:187`) |
| 9 | `supportSubmitTicket` | Submit Ticket | إرسال التذكرة | Submit button (`:205`) |
| 10 | `supportStatusClosed` | Closed | مغلقة | Row pill and the closed bar's pill (`support_status_pill.dart:42`, `support_composer.dart:310`) |
| 11 | `supportComposerHint` | Write your message | اكتب رسالتك | Reply hint, and now also the field's accessible name once there is text (`support_composer.dart:173`, `:206-208`) |
| 12 | `supportTicketMeta` | `{reference} · {date}` | unchanged | Row meta line. No wording change, as approved |
| 13 | `supportStatusOpen` **(new key)** | Open | مفتوحة | Row pill (`support_status_pill.dart:43`) |
| 14 | `supportStatusInProgress` **(new key)** | In progress | قيد المعالجة | Row pill for `in_progress` **and any unknown status** (`:44`) |
| 15 | — | — | — | **`pending`: not added.** No key, no label, no pill (SQ-32) |
| 16 | `supportSend` **(new key)** | Send | إرسال | Send button's accessible name (`support_composer.dart:220`) |

- **ARBs:** 11 Arabic values replaced and 3 keys added in both files, with the support keys in the same order in
  both. In the English descriptions, the 11 `ARABIC NOT SUPPLIED` markers became "Arabic approved by the owner
  2026-10-10 (O-14)". No English value changed.
- **Generated localisation files:** regenerated with `flutter gen-l10n`. Regenerating the untouched ARBs first
  gave byte-identical files, so the only diff is the support getters.
- **Owner rulings applied:**
  - the shorter إنشاء تذكرة, also on the closed bar
  - التذاكر الأخيرة, not أحدث التذاكر
  - the imperative اشرح / اكتب
- **No other wording was added.** Nothing came from contract suggestions.

### 13.3 Code changes (all in CW12a's own untracked files)

| File | Change |
| --- | --- |
| `support_status_pill.dart` (new; replaces `support_closed_pill.dart`, backed up) | `SupportStatusPill(label)`, with the Closed pill's exact look, and `SupportStatusPill.labelFor(l10n, status)`: closed, open and in progress each get their approved words; **unknown → In progress** (the contract's rule); **`pending` → `null`** (no pill) |
| `support_ticket_row.dart` | The pill is drawn whenever `labelFor` returns words. The row is still one semantics node, and it now names the status. A pending row names none |
| `support_composer.dart` | The send glyph is now **one button node named `supportSend`**: enabled only with text, disabled while sending, with the spinner excluded so it adds no progress-bar role (BUG-021). The reply field **keeps its name once there is text** (§13.5). The closed bar's button style moved onto its label (§13.4) |

### 13.4 The closed-ticket call to action

- **Wording:** it shares row 1's key, so in Arabic it now reads **إنشاء تذكرة**. That is the same words as the
  create screen's own heading (`createTicket`), and the shorter form is the owner's ruling. In English it is
  unchanged ("Create a New Ticket"). A test pins the two Arabic values as equal, and a mutation to a second variant
  fails 2 tests. The button is still one button node named by those words, at least 48 high, on one line, and it
  opens `/support/new` (EN and AR tests).
- **Found and fixed: its label had no font family.**
  - **Cause:** `TextButton.styleFrom(textStyle: AppType.buttonMedium)` *replaces* the theme's text style, and
    `AppType` deliberately names no family. So the label lost Inter and its Tajawal/Cairo fallback.
  - **Evidence:** in a bundled-font render it drew in the test placeholder face, in **English as well as Arabic**.
    So this predates O-14; the Arabic made it visible. On a device it would draw in the platform's default face,
    not tofu (inference: system font fallback).
  - **Fix:** the style moved onto the `Text`, where it merges with the theme's (the pattern `city_field.dart`
    already uses).
  - **After:** Inter in English and Tajawal in Arabic, bundled-font render (§13.6).
  - **Guard:** a test asserts family `Inter`, fallback `Tajawal` and `Cairo`, and the scale's size and weight.

### 13.5 Accessibility and RTL checks

| Check | Result | Evidence |
| --- | --- | --- |
| Subject / Details are named fields | **Yes, before and after typing, EN and AR.** The visible label names the field. The empty Details field also reads its hint, and the hint goes once there is text | BUILD probe (stable node, label "Subject" / "Details" after typing); tests in both languages |
| The reply field has a name before typing | Yes, the hint (اكتب رسالتك in AR) | BUILD probe; test |
| …and after the hint disappears | **It did not: a gap that predates this pass**, found by probe. Material drops the hint from semantics once there is text, which left an unnamed field showing only its value. **Fixed** by restating the same approved words as the field's label only while it has text. A constant label read the name twice while empty. A `null` label re-created the node (id 4 → 5), which would lose a screen reader's focus on the first character. `''` keeps one node (id stable) and one name | BUILD probes of four variants; tests check the label before, after and after clearing, plus the node id; 2 mutations each fail 2 tests |
| The send button has the approved name | **Yes:** Send / إرسال, a button, disabled when empty or sending; a screen reader's tap sends | Test in EN and AR (`tester.semantics.tap`); mutation back to `ExcludeSemantics` fails 2 tests |
| No status fallback shows an unapproved Pending | **Yes.** No key, value or drawn text for pending in either language; a pending row has no pill and its node names no status | Copy test (no `support*pending*` key, no "Pending" / معلّقة value) and list tests; a mutation giving pending the In progress words fails 5 tests |
| Unknown statuses | Show **In progress** (the contract's "in progress, not closed") | List tests; a mutation dropping it fails 16 tests |
| RTL | The Arabic lines lay out RTL. Pills sit at the row's end (the left), and the closed bar mirrors. The details hint's "..." ends the sentence at the left, which is correct now that the hint is Arabic. The send glyph is mirrored | Tests (`RenderParagraph.textDirection`, geometry); bundled-font renders looked at directly |
| Contrast | **Unchanged and not fixed.** The approved Arabic uses the same tokens: details hint 2.01:1, reply hint 2.58:1, create subtitle 4.04:1 (light, as drawn). The pills (one look for all three) compute to **8.97:1** light and about **8.67:1** dark (token hexes, Glass ignored) | Computed |
| Large text | **Bundled fonts:** no overflow for any pill at 320 / 360 / 411 dp and 1.0 / 1.3 / 2.0 / 3.0× in either language. **But** at 320 dp and 3.0×, an In progress row leaves the subject column **21 dp (EN) / 11 dp (AR)**, and at 360 dp and 2.0× the Arabic In progress row breaks its date "2026-10-" / "09". Logged for the designer (pill behaviour at large text), **not redesigned**. *The test placeholder face (much wider than the real fonts) does overflow 50 / 74 px at 320 dp and 2.0×; that is not a device fact, so the large-text test loads the real fonts* | BUILD probe (bundled fonts, 72 cases); `support_status_pill_layout_test.dart` (49 tests) |

Not done: physical Pixel 8, iOS, TalkBack (semantics are BUILD-level, from the test tree), Figma.

### 13.6 Tests, mutations and pixel parity

- **Updated:**
  - `support_copy_status_test.dart` now pins the **approved** register: 15 keys, values character for character,
    no marker, the approval note, the shared Arabic for row 1, and no pending label.
  - `support_list_screen_test.dart`: the pills per status in EN and AR, the Arabic list, and the row semantics per
    status.
  - `create_support_ticket_screen_test.dart`: the Arabic form, field names before and after typing in EN and AR,
    and the submit button's name in EN and AR.
  - `support_ticket_screen_test.dart`: the send button, the field's name, the Arabic thread and the closed bar's
    Arabic, name and font.
- **New:** `support_status_pill_layout_test.dart`, which loads the bundled fonts, as O-15's tests do.
- **Support suite:** **472 passed** (410 at the O-15 gate, +62; run alone) (the new file is 49 of them).
- **Mutations** (throwaway copy), each failing as expected:

  | Mutation | Failures |
  | --- | --- |
  | `null` label | 2 |
  | label never restated | 2 |
  | pending borrows In progress | 5 |
  | unknown gets no pill | 16 |
  | send hidden again | 2 |
  | a second Arabic variant for row 1 | 2 |

  The unmutated copy passes 211 / 211.
- **Pixel parity** (bundled fonts, English, before vs after):
  - The composer in 4 states × 2 canvases: **8 / 8 identical**. The semantics changes moved no pixel.
  - The closed bar: **2 / 2 differ**, intended: the label now draws in Inter instead of the default face.

### 13.7 O-15 — intact, not broadened

- The five-file O-15 suite, re-run after the change: **125 / 125**.
- No O-15 or CW02 file was touched.
- Remaining items, unchanged:
  - **35 dp back chips:** OTP, unknown-route page, support thread header, School / University detail.
  - **2.0× text:** mid-word wraps (EN "Notifications" at 360 dp or less, "Terms & Conditions" at 320).
  - **Arabic Edit Profile:** two lines at 320 dp.
  - **Pills under 48 dp:** Mistakes 35, language 36.1.
- The support thread's back chip could still fold into the CW12a commit on the owner's word (§12.3); it is not made.

### 13.8 Staging — unchanged, not re-run

- **Evidence stands as recorded** in `smoke-staging-2026-10-10.md`: the five text-ticket operations were exercised
  signed in, through the app's network code in a throwaway copy (**API level, not a device or UI walk**).
- **Not re-run, and nothing new created.** No rate limit was provoked, and nothing was closed.
- **The test ticket** "Mobile app staging check - please ignore" (one student reply) **is still open.**
- **Still unverified on staging:**
  - the staff reply in a thread
  - `in_progress`, `pending` and `closed`, now drawn differently
  - the closed thread's `409 ticket_closed`
  - cross-account 404
  - a real 429

### 13.9 Seif and designer drafts (NOT sent)

- **`02_SEIF_HANDOFF.md` §F**, third pass (§F.5):
  - F.1 item 3 now says which statuses carry a label.
  - SQ-15 and SQ-32 have third-pass rows.
  - The asks are unchanged: close or reuse the test ticket; seed an `open` ticket with a staff reply,
    `in_progress`, `pending` and `closed`, plus an optional ticketless second account, with details arranged
    privately; and what `pending` means and whether the student should act.
  - SQ-33 and SQ-34 are not re-asked.
- **`03_DESIGNER_HANDOFF.md` §10**, third pass (§10.5):
  - The message now carries the approved-words table (`[[COPY: owner]]` only for Pending).
  - It says how the pills are built today and asks for per-status pills and their large-text behaviour.
  - It gives the closed bar's Arabic.
  - Kept: DG-63, the corrected frame references, the Arabic and dark requests, type and contrast, avatar, date and
    timestamps, and the confirmed removals.
  - Figma was not opened (the connector needs re-authorising).
- **`DESIGN_ISSUES` #131:** dated "superseded 2026-10-10 (O-14)" notes in §2, §3, §6, §9 and the asks. Nothing
  deleted.

### 13.10 `name_not_allowed` — decision note (nothing implemented)

What is known stands as §12.7 records:
- **Staging:** enforced on `updateMyProfile`.
- **Sign-up:** **not tested against staging.**
- **The app today:** a generic line, no field marked, the draft and token kept.

The smallest safe fixes:

**Edit Profile (small, clean files).**
- `rejectedFields` in `profile_error_copy.dart` returns `{'name'}` for this code.
- The screen already renders a rejected name with the approved `fieldRejected` line, and keeps the typed name.
- Tests: the mapper, plus the screen in EN and AR.

**Sign-up (more involved; an owner navigation call).**
- **State is safe to keep:**
  - The draft lives in `RegistrationController`, a plain `Notifier` that is not auto-disposed.
  - `start` is idempotent for the same token.
  - Sign Up 1 re-fills its fields from the draft, Track pre-selects from it, and both detail screens watch it.
  - The contract says a refused name does not consume the `registrationToken`, so the same token can resubmit
    until `tokenExpiresAt` (the detail screens already show the expired view after that).
- **The cleanest return** is `context.go('/register')`. The route already accepts a null `extra` and reuses the
  seeded draft, and it rebuilds the same one-screen stack the OTP step leaves.
- **What has to be added:**
  - a "name rejected" signal Sign Up 1 can read: a draft field or a small provider, set by the detail screen
    *before* navigating, never in `initState` (BUG-001)
  - Sign Up 1 showing it under the name
  - clearing the stale submit error so the detail banner does not reappear
- **These touch CW02-dirty detail screens and the O-15-touched Sign Up 1**, so the hunks must be split by wave.

**Copy.**
- The minimal variant needs **none**: it reuses the approved `fieldRejected` ("Please check this field"), which
  does not say why.
- A dedicated message ("This name isn't allowed…") needs **owner-approved EN and AR**. The contract's suggested
  wording is **not adopted**.

**Decision needed first:** O-11 (re-vendor to 3.48), **or** an explicit OK to build ahead of the pinned 3.46.0-m1.
Then the sign-up navigation intent, and which copy.

### 13.11 3.48's other impacts and CW12b — unchanged

**3.48:** the pin stays `eddb6ac` (3.46.0-m1), and nothing under `contract/` changed. These stay separate,
undecided items:
- banned-account wording
- deletion wording (CW05)
- `getAppVersionPolicy` (release prep)
- push-token cleanup (CW08a)
- `enrolment_opened` (CW07b)
- draft daily tasks

**CW12b** stays blocked, and no photo, camera, microphone or upload code was added. It needs:
- CW04 Terms acceptance
- the photo-picker dependency approval (H-16)
- DG-18 and DG-52
- H-15
- SQ-25 / SQ-26

### 13.12 Validation (this pass)

All exit codes and counts below are from this pass's own runs (gate script `o14_gate.sh`; logs in the scratchpad).

| Check | Exit | Result |
| --- | --- | --- |
| `sh tool/validate.sh` (`LEVELUP_VALIDATE_OUT` = scratchpad), 14:48:48–15:04:04Z | **0** | format **0 changed** (326 hand-written files); analyze **0 issues**; **3025 passed / 0 failed / 0 skipped, OVERALL: PASS** |
| `tool/validate.ps1` (same redirect), 15:04:04–15:08:49Z | **0** | analyze **0 issues**; **3025 / 0 / 0, OVERALL: PASS** |
| Delta vs the baseline 2963 | — | **+62**, all in `test/features/support` (410 → **472**, run alone: all passed) |
| `test/guards` alone | 0 | **124** passed (unchanged) |
| `contract_models_test` / `contract_pin_test` | 0 / 0 | **14 / 2** passed (pin unchanged: `eddb6ac`, 3.46.0-m1) |
| `flutter gen-l10n` after the change | 0 | **no drift** (generated files' hash identical before and after) |
| O-15 five-file suite | 0 | **125 / 125** |
| `dart format` on the untracked new and changed Dart files | 0 | 0 changed (validate formats tracked files only) |
| `git diff --check` (tracked changes) and trailing whitespace (untracked) | 0 | clean |
| Tracked `.ai/audits/current/test-results.md` | — | **unchanged** (blob `57716a44` before and after) |

Not done: physical Pixel 8, iOS, TalkBack, a UI walk on staging, Figma.

### 13.13 Versions (re-read from the repo this pass)

| Item | Value |
| --- | --- |
| Flutter | 3.44.7 (`flutter --version`) |
| Dart SDK constraint | `^3.10.4` |
| Android | `compileSdk 36`, `minSdk 24`, `targetSdk 36` |
| iOS | `IPHONEOS_DEPLOYMENT_TARGET = 13.0` ×3 (15.0 still not applied) |
| Packages | `flutter_riverpod ^3.3.2`, `go_router ^17.3.0`, `dio ^5.10.0` |

### 13.14 Store readiness

**Not re-scored.** The last logged rubric score stays **Play 44 %, Apple 20 %**. The rubric has no copy,
accessibility or text-scaling item, so this pass moves no score by itself.

### 13.15 Git

- `merged` @ `b227f61` = `origin/merged` (0 / 0). **Staged 0. Nothing committed, pushed, merged, rebased, reset,
  stashed or cleaned. Nothing sent.**
- **Status:** 114 → **115 lines** (75 M, 40 ??). The one new top-level entry is `completion/o14_prewave/`. The new
  `support_status_pill.dart` and `support_status_pill_layout_test.dart` sit inside the already-untracked
  `lib/features/support/` and `test/features/support/`.
- **Changed in this pass** (compared with the hashes taken at its start):

  | Area | Files |
  | --- | --- |
  | Copy | `lib/l10n/app_en.arb`, `app_ar.arb` and the 3 generated `app_localizations*.dart` (all already modified by earlier waves; only the support getters changed here) |
  | CW12a code (untracked) | `support_composer.dart` and `support_ticket_row.dart` changed; `support_status_pill.dart` new; `support_closed_pill.dart` removed (backed up) |
  | CW12a tests (untracked) | 4 changed, 1 new |
  | Docs | `docs/DESIGN_ISSUES.md` (#131 notes), `02_SEIF_HANDOFF.md`, `03_DESIGNER_HANDOFF.md`, `COMPLETION_STATE.md`, this report |

- **Untouched:** every CW02, CW07a, N-26 and O-15 file, `contract/`, `pubspec.*`, guards and tool scripts.
- **Commit order, on request:** N-26 → CW02 → CW07a → CW12a → O-15. This pass's code, copy and tests belong to the
  **CW12a** commit. The ARB and generated-file hunks are support keys only, but those files also hold CW07a hunks,
  so split by hunk.

### 13.16 What the owner decides next

1. **`pending`:** after Seif answers SQ-32, approve EN + AR words (none is shipped).
2. **Send the drafts** (§F.1 to Seif, §10.3 to the designer). Both are owner actions.
3. **`name_not_allowed`:** O-11, or an OK to build ahead of the pin; then the sign-up navigation and the copy
   (§13.10).
4. **The closed-bar font fix and the composer name fix** were made inside CW12a's files. Accept them with CW12a, or
   say otherwise.
5. **A commit request** (order N-26 → CW02 → CW07a → CW12a → O-15), a device walk, or the next wave.
