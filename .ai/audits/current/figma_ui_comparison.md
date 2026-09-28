# COMPARE — Figma ↔ contract ↔ Flutter, per screen (2026-09-24)

**Stage:** COMPARE (user command). Investigation only — no `lib/`/`test/` edits.
**Contract:** `ea83099` / 3.23.0-m1. **UI source:** Figma MCP (connector `c80bb840…`, identity Ahmed
Mohamed; reads by direct node id). A notice that a *different* server named `figma` needs OAuth is
unrelated. The first quiz agent was misled by it and made zero Figma calls; its visual column was
re-run (see Quiz section).
**Method:** six Sonnet agents, one per screen group, each reading Figma nodes, the screen code, the
contract block, `docs/DESIGN_ISSUES.md` (88 entries) and the 2026-09-12/19/20 device reports; the
lead re-verified every claim that decides a verdict (list at the end).
**Verification level:** SOURCE + Figma reads + *prior* DEVICE evidence (dated). Nothing was run on
a device in this stage; that is WALK.

Legend — ✅ match · ❌ mismatch · ⚠ known/ruled (DESIGN_ISSUES #N, seif_fight S-N, DECISIONS D-N) ·
⬜ not built · ❓ unread.

## Scope — what counts as a UI-assisted screen

A screen that calls, or is designed to consume, at least one **stable, app-buildable** operation.
**22 screens.** Excluded (no endpoint): Onboarding, Sign-up identity (`/register`), track picker
(`/register/track`) — both sign-up screens say "No network call on this screen" in their headers;
the dev `/track-select` placeholder; `/message`, `/refer`, `/support`, `/friends`, `/legal/*`
(no stable operation exists for any of them).

## Summary table

| # | Screen | Route | Figma (light school / uni / dark) | Endpoints | Func | Visual | Verdict (primary / secondary) |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Login | `/login` | `82:819` / — / `337:15652` | requestOtp | 9/9 | ✅ + 1 ❌ copy | **IMPLEMENT** (bidi `+`) / design (legal wording) |
| 2 | OTP | `/otp` | `82:1171`, `82:1170`, `155:786` / — / `337:19271` | verifyOtp, requestOtp | 9/9 | ✅ (⚠ #5 #25 #49) | **READY** / cross-cutting only |
| 3 | School registration | `/register/school` | `125:511` (❓) / — / `337:5269` | 5 reference ops, completeRegistration | 10/10 | ✅ (⚠ #2 #44) | **READY** / design #44 |
| 4 | University registration | `/register/university` | `125:2336` (❓) / — / `337:10373` | reference ops, completeRegistration | 10/10 | ⚠ #3 #4 | **READY** / design sign-off #4 |
| 5 | Home | `/home` | `59:1439` / `125:2373` | getMyProfile; **getLeaderboard (unwired)** | 3/4 | ⚠ #42 #43 #19 #78 | **IMPLEMENT** (Top Student ← `GET /leaderboard`) / API (Daily Tasks none, Continue Learning draft) |
| 6 | Leaderboard | `/leaderboard` | `133:3117` / `134:3626` (❓) | getLeaderboard, getMyProfile | 8/9 | 7/9 (⚠ #86, toggle AA) | **READY** / design rulings |
| 7 | Profile | `/profile`, `/account` | `166:4416` / `309:7940`; Logout `180:4704`; Go-to-Uni `180:4445` | getMyProfile, logout | 6/7 | 6/8 + **1 ❌ new** | **IMPLEMENT** (Logout No/Yes; stale profile after re-login) / API (S24/S25) |
| 8 | Edit Profile | `/profile/edit` | `176:1201`, `216:3341`, `180:4153` / `309:8268` (copy of school) | getMyProfile, updateMyProfile, listDefaultAvatars | 8/9 | 5/6 + **1 ❌ new** | **IMPLEMENT** (avatar action-sheet chrome; mock `PATCH /me`) / design (no real uni frame) |
| 9 | Settings | `/settings` | `176:1840` / `309:8452` | getMyProfile, updateMyProfile; **deletion ×2, fcm-token unbuilt** | 4/6 | ⚠ #45 #46 #48 | **DESIGN CLARIFICATION** (account deletion has no design; push needs a product call) / implement once answered |
| 10 | Subjects | `/learn` | `134:3837` / `308:4521` / — (no dark frame) | listSubjects | 7/9 | ✅ light; dark ❓ | **IMPLEMENT** (RTL chevron) / design (no dark frame) |
| 11 | Subject tree root (Units / Lectures) | `/learn/subject/:id` | `135:815` / `180:5354`, `180:5208` / `337:5894` | getSubjectTree | 8/9 | ⚠ #17 #18 #77 #81; ❓ circle glyph | **IMPLEMENT** (RTL chevron; dead back chip, uni) / design (circle glyph, no dark Lectures) |
| 12 | Chapters | `…/unit/:unitId` | `135:1270` / — / `337:6047` | (cached tree) | 5/6 | ✅ (⚠ #14 #16) | **READY** / API #16 (no chapter progress) |
| 13 | Lessons | `…/chapter/:chapterId` | `135:1485` / — / `337:6143` | (cached tree) → createQuiz | 6/6 | ✅ | **READY** |
| 14 | Mistakes overview | `/learn/mistakes` | `404:6292` / same / `404:7428` | getMyMistakes | 8/10 | ✅ (⚠ #59 #68 #71) | **IMPLEMENT** (card button semantics; BUG-002 AR overflow) / design #68 #71 |
| 15 | Mistakes subject | `/learn/mistakes/subject/:id` | `404:6539` / `404:7181`, `404:7110` | getMyMistakesForSubject | full | ✅ (⚠ #59 #65 #66 #68 #71) | **IMPLEMENT** (row button semantics — shared `TreeListRow`) / design |
| 16 | Mistakes chapters | `…/unit/:unitId` | `404:6677` | (cached) | full | ✅ | **READY** (shared fixes only) |
| 17 | Mistakes lessons | `…/chapter/:chapterId` | `404:6762`, `404:6853` | (cached) | full | ✅ | **READY** |
| 18 | Quiz setup | `/quiz/setup` | `135:1622` / `309:5771`; limit sheet `199:2335` | createQuiz | full | 6/9 (⚠ #31 #35; ❌ limit-sheet ✕) | **IMPLEMENT** (limit-sheet ✕; subject caption) / design #51 #74 |
| 19 | Quiz question | `/quiz/:quizId` | `159:845`, `159:1695`, `216:2973` / `309:5878`… | submitAnswer, getExplanation, finishQuiz | 1 ❌ contract | 6/10 (❌ app-bar AI icon, panel glyph; ⚠ #33 #83 #87 #88) | **IMPLEMENT** (✕ label; 409 retry) + **OWNER RULING** (explanation `subscription_required` popup) / design #87 |
| 20 | Quiz result | `/quiz/:id/result` | `159:1964` / `309:6375` | finishQuiz (in-memory) | full | 6/9 (❌ subtitle, rewards runs, CTA icon; ⚠ #29 #50) | **IMPLEMENT** (bidi `+{points}`) / design #50 |
| 21 | Quiz review | `/quiz/:id/result/review` | `162:2377` / — / `337:6705`, RTL `549:20324` | getExplanation (in-memory session) | full | 8/9 (⚠ #52–#58) | **READY** / add 1.30–1.35× row test |
| 22 | Flashcards | — (not built) | `225:5582` (+ component `247:3260`) / uni only | getFlashcardsForLecture, setFlashcardSelfGrade | ⬜ | 2 ❌ vs contract | **DESIGN CLARIFICATION** (5 questions) / then new screen |

**Counts (primary verdict):** READY **9** · NEEDS IMPLEMENTATION **11** · NEEDS DESIGN
CLARIFICATION **2** (Settings, Flashcards) · NEEDS API WORK **0** as primary, **5** as secondary
(Home, Profile, Chapters, Leaderboard time filter, Flashcards bookmark/share). Quiz question is
counted once, under IMPLEMENT; its popup ruling is listed as a blocker.

## Per-screen detail

### 1 · Login — `82:819` (dark `337:15652`) — requestOtp
- Functional 9/9 ✅ (shape `{phone}` → `{resendAfterSeconds, expiresInSeconds}`; loading, inline error,
  offline banner + disabled CTA, `push /otp`).
- Visual ✅ (fields 60dp r20 = `82:896`; dark verified by screenshot). ❌ **legal line wording**: Figma
  `82:1086` "By Continue to join or sign in, you agree to Level Up's User Agreement, Privacy Policy, and
  Cookie Policy." vs `app_en.arb:36` "By continuing, you agree to our User Agreement, Privacy Policy and
  Cookie Policy." — not logged; belongs with #9. ⚠ #6 (`+20`), #8, #9.
- Behaviour/A11y: ❌ **leading `+` flips in Arabic** — `login_screen.dart:298-301` (dial-code `Text`
  has no LTR; the `TextField` beside it does); same at `signup_identity_screen.dart:267-270`.
  Device-found 2026-09-20; no commit since touched it. ❓ language pill `82:1093` is 36.1 dp tall.
- Work: (1) LTR-isolate the dial code at both sites. (2) Legal wording → designer/legal via #9.
- ⚠ **Correction from the Wave 01 WALK (2026-09-24):** "Visual ✅" above was wrong. On device the
  dark bird logo is black (frame `#FCFBF9`), the subtitle is `bodyLarge` centred (frame Bold 20
  start-aligned), the logo is 88 dp (frame 132.85) and the vertical rhythm is compressed. The
  COMPARE agent checked the field (`82:896`) and a dark screenshot, not the header. See
  `device_walk_results.md` W01-1…5 — treat other screens' "✅ structure" claims as leads until walked.

### 2 · OTP — `82:1171` / `82:1170` / `155:786` (dark `337:19271`) — verifyOtp, requestOtp
- Functional 9/9 ✅ (discriminated result, `ref.listen` fork per BUG-001, resend, offline).
- Visual ✅; ⚠ #5 (6 boxes — contract), #49 (dot separator), #25 (no dark success frame).
- Cross-cutting only: no width cap (Pinput `spaceBetween`, `otp_screen.dart:224-268`) and the
  35 dp `CircleBackButton` (same root as #80 / D-013).
- Verdict READY.

### 3 · School registration — dark `337:5269` (light `125:511` not read) — reference ×5, completeRegistration
- Functional 10/10 ✅ (`SchoolRegistration` field-by-field; per-picker load/empty/error/retry;
  `RegistrationExpiredView`; `201` → `/home`; `registration_token_invalid` / `phone_already_registered` → `/login`).
- Visual ✅ dark; shadows unverifiable via MCP (Glass). ⚠ #2 (DOB not in frame), #44 (adr-028 links, no frame).
- Cross-cutting: 35 dp back chip. ❓ 1.3× text scale unmeasured on this stack.
- Verdict READY.

### 4 · University registration — dark `337:10373` (light `125:2336` not read)
- Functional 10/10 ✅ (`UniversityRegistration`, `studyYearId` must be `active`).
- ⚠ #3 (governorate absent from frame, contract-required), #4 (field order — cascade order is
  correct; designer sign-off pending, nothing to build either way).
- Verdict READY (sign-off pending).

### 5 · Home — `59:1439` / `125:2373` — getMyProfile (+ getLeaderboard available)
- Functional 3/4: skeleton, retry, offline ✅; `quiz_screen.dart:231` invalidates `meProvider` so
  points refresh ✅; no empty state (correct). ❌ **stale profile after logout → re-login as a
  different student** (device-found 2026-09-20; `session_scope.dart` has invalidated `meProvider`
  since 2026-08-14 and has not changed since 2026-09-12, so the defect is **still open** — the
  agent's "fixed" claim was refuted by the lead). Owned by the Profile wave (logout lives there).
- Visual ⚠ #42 (resolved), #43 (medallion art blocked), banner art, #19 (Latin digits in AR), #78.
- **New endpoint mapping:** Figma draws a **Top Student** block; the code shows it as "coming soon"
  with the comment "no endpoint yet" (`home_screen.dart:27`). That was true until D-008 closed on
  2026-09-22 — `GET /leaderboard` is stable, deployed and already decoded by the app. **Open
  question before building:** which `scope` and how many rows the block shows (the frame's
  content decides; read it in the wave).
- API gaps: Daily Tasks (no operation), Continue Learning (`GET /quizzes` draft), bell (draft).
- Verdict IMPLEMENT (Top Student) / API (rest).

### 6 · Leaderboard — `133:3117` / `134:3626` — getLeaderboard, getMyProfile
- Functional 8/9 ✅ (scope/cursor/limit per contract; `hasMore` paging; empty only when
  `items.isEmpty && !hasMore`; 403 pending-deletion copy; 429 withholds retry; offline).
- Visual 7/9: podium 129/82, rings 5/3/2, rows 48 r12 ✅. ⚠ #86 ("You" row 1.75:1). Scope-toggle
  selected label 1.74:1 / 2.02:1 (same family as #77). Figma toggle reads **"NOW / Last Month"**,
  the contract has no time dimension, code builds `System | Governorate`
  (`scope_toggle.dart:9-21`) — documented in code, **not** a numbered DESIGN_ISSUES entry → log it.
- Verdict READY (designer rulings pending). University frame not screenshotted.

### 7 · Profile — `166:4416` / `309:7940` — getMyProfile, logout
- Functional 6/7: Solved Questions + Rank tier omitted (S24/S25, no field) ✅; logout best-effort
  revoke then clear ✅; ❌ stale profile after re-login (see Home).
- Visual 6/8: Subscription row correctly **absent** (adr-049; Figma still draws it).
  ❌ **NEW — Logout dialog:** Figma `180:4704` draws two 155×60 buttons **"No"** (`180:4755`) and
  **"Yes"** (`180:4712`) plus a ✕ (lead re-read the node). `ProfileConfirmDialog`
  (`profile_confirm_dialog.dart:18-20`) says "the frame draws no Cancel button" — true only for
  Go-to-Uni (`180:4445`). Not in DESIGN_ISSUES.
- Verdict IMPLEMENT (Logout No/Yes; stale-profile fix).

### 8 · Edit Profile — `176:1201`; action sheet `216:3158`→`216:3341`; picker `180:3989`→`180:4153` — getMyProfile, updateMyProfile, listDefaultAvatars
- Functional 8/9 ✅ (diff-only body; email tri-state explicit null; 400 → inline field errors;
  `meProvider` invalidated after save). ❌ **mock has no `PATCH /me`** → Save cannot be walked on
  `main_mock.dart`. ⚠ S20/S34 (read-only fields, no `parentPhone`).
- Visual 5/6: ❌ **NEW — `AvatarActionSheet`** (`avatar_sheets.dart`) wraps the two actions in the
  `_SheetCard` chrome (title + close ✕) and bordered r16 rows with leading icons; frame `216:3341`
  draws only a drag handle and two plain rows split by a hairline. `ChooseAvatarSheet` matches.
  ❓ `309:8268` is a copy of the school frame (shows Education System / Grade / School) — there is no
  real university reference; code renders University/Faculty/Study Year per contract.
- Verdict IMPLEMENT (sheet chrome to the frame; mock `PATCH /me`).

### 9 · Settings — `176:1840` / `309:8452` (identical) — getMyProfile, updateMyProfile
- Visual = ⚠ #45 (3 theme circles vs 2), #46 (one Show-Rank switch vs two booleans), #48, S26–S28.
- Functional: ✅ Rank round-trips both booleans, no optimistic UI; ❌ mock `PATCH /me`;
  ❌ `requestAccountDeletion` / `cancelAccountDeletion` stable, zero consumer, **no design**;
  `registerFcmToken` stable, zero consumer, needs Firebase + a product call; the four notification
  toggles have no contract storage.
- Stale doc: `docs/STORE_READINESS.md:59` still says there is no deletion endpoint.
- Verdict DESIGN CLARIFICATION (deletion is store-mandatory; needs a design and copy per adr-114 D3).

### 10 · Subjects — `134:3837` / `308:4521` — listSubjects
- Functional 7/9 ✅ (`[]` is normal per adr-091; unreleased term absent, not badged; no 403 documented).
- Visual ✅ light (2-col grid, card 173×89 r10.7, search 56 r15); ❓ dark page composition — **no
  dark Subjects frame exists** for either track (the `336:*` ids are light duplicates or mislabeled
  Mistakes frames); component dark tokens come from `337:5732` / `337:5724`.
  **Corrected 2026-09-25 (API→UI Wave 07):** `337:5702` is a full dark Subjects frame, and `337:5732` /
  `337:5724` are its card and search field. The light card also did NOT match: title, chevron, bar fill and
  track differed (W07-2…5).
- ❌ **RTL chevron never mirrors** — `forwardChevron()` (`catalog_scaffold.dart:105-108`) returns
  `Icons.chevron_left` for RTL, and every chevron/arrow icon in the SDK is
  `matchTextDirection: true` (lead read `/c/flutter/.../icons.dart`: `chevron_left`, `chevron_right`,
  `arrow_back_ios_new`, `arrow_forward_ios`), so it is flipped back. `backChevron()` (`:100-102`)
  has the same double flip. Sites: `subject_card.dart:66`, `tree_list_row.dart:198`,
  `mistakes_subject_card.dart:95`. (The Mistakes agent's "chevrons are fine" was refuted by this.)
- ⚠ #80 pill 35 dp (D-013); SubjectCard 9.1 px overflow at 1.3× (RESPONSIVE queue); #15.
- Verdict IMPLEMENT (chevron helper — fixes screens 10–17 at once).

### 11 · Subject tree root — Units `135:815` (dark `337:5894` ✅) · Lectures `180:5354`, `180:5208` — getSubjectTree
- Functional 8/9 ✅. `Lecture.hasFlashcards` unused, and the Figma lecture row (`309:5714`) draws no
  flashcards affordance → no designed entry point (root shared with #18).
- ⚠ #77 (segmented AA 2.74:1), #81 (built), #18 (Flashcard tab omitted), #17 (Lectures search drawn
  `180:5232`, not built).
- ❓ **NEW:** `180:5208` (Midterm tab selected) draws a trailing **circle** (`Group 37220`, 20×20)
  on each row where `180:5354` (Normal) draws a chevron — multi-select, or duplication drift?
- ❌ RTL chevron (shared). ❌ **dead back chip on the Subjects root, university only** (device-proven
  2026-09-20; `CatalogHeader` draws it `if (GoRouter.canPop())`; root cause not visible statically).
  TreeListRow progress overflow 7/20 px at 1.3× (not in RESPONSIVE queue). Dark clipped
  crescents under uni tabs (device-proven, cause plausible at SOURCE only). No dark Lectures frame.
  **Corrected 2026-09-25 (API→UI Wave 08):** dark Lectures frames exist, `349:15962` (Normal) and
  `337:11059` (Midterm). The circle is a radio with no contract behind it (DESIGN_ISSUES #94). The dead chip's
  cause WAS visible statically: `GoRouter.canPop()` is app-wide and never rebuilds the header (KNOWN_BUGS
  BUG-010). The light row did NOT match: the chevron and the bar were off (W08-3, W08-4), and the list rhythm
  was 12 where the frames have 16 (W08-5). The 7/20 px overflow was the test font; with the app's fonts the
  row holds at 375 and 411 dp up to 2.0× (RESPONSIVE item 12).
- Verdict IMPLEMENT / design (circle glyph).

### 12 · Chapters — `135:1270` (dark `337:6047`)
- Functional 5/6; ⚠ #16 — Figma draws "80%" per chapter, contract gives chapters no counter → API gap.
- Visual ✅ via the shared `TreeListRow`; title singular/plural open inside #14.
- Verdict READY (shared chevron fix lands via screen 10).
- **Correction 2026-09-25 (Wave 09 frame re-read):** COMPARE missed one visual defect. Both frames stack the rows
  16 apart and the build had 12 (W09-1, fixed). The row paint matches the Wave 08 tokens.

### 13 · Lessons — `135:1485` (dark `337:6143`)
- 6/6 ✅ (lesson `questionCounter` is real; row always tappable). Trailing "{a} / {t} questions" vs
  Figma "80%" is a confirm-only item in #16. Verdict READY.
- **Correction 2026-09-25 (Wave 10 frame re-read):** COMPARE missed the same rhythm defect as Chapters. The rows sit
  16 apart and the build had 12 (W10-1, fixed). The row paint, bar included, matches the Wave 08 tokens.

### 14 · Mistakes overview — `404:6292` (dark `404:7428`) — getMyMistakes
- Functional 8/10: ✅ bare array, server order, empty-as-happy-path, offline (DEVICE 09-12).
  ⚠ overview not refreshed after an ordinary quiz — **code-documented known gap**
  (`mistakes_notifiers.dart:39-56`; trigger belongs in the quiz return path, flagged in the Day 10
  brief as "a real design question"). 403 branches BUILD-verified only (mock cannot produce them).
- Visual ✅ (dark card `#27282C`@30% + cream text = #70). ⚠ #59, #68, #71 (2.68:1 / 4.07:1).
- ❌ BUG-002 open (`KNOWN_BUGS.md:104`) — Arabic overflow at 1.3× / 2.0×.
- ❌ **NEW:** `MistakesSubjectCard` taps through `ElevatedSurface(onTap:)` with no
  `Semantics(button: true)`; the sibling `_MistakesButton` already carries that exact fix.
- Verdict IMPLEMENT.

### 15 · Mistakes subject — `404:6539` / uni `404:7181`, `404:7110` — getMyMistakesForSubject
- Functional ✅ (track discriminator; unknown id → empty; autoDispose decay; #61 default copy).
- ⚠ #59 #65 #66 #68 #71 (row 3.91:1 dark). ❌ `TreeListRow` tappable branch lacks button semantics
  (`tree_list_row.dart:120-124`) — shared with 11–13. BUG-002 unmeasured on tree rows.
- Verdict IMPLEMENT (shared semantics fix).

### 16 · Mistakes chapters — `404:6677` · 17 · Mistakes lessons — `404:6762` / `404:6853`
- ✅; leaf rows inert by the 2026-09-12 owner ruling (replay quiz `404:7234` out of scope); ICU plural
  ships ("1 mistake", #66). Verdict READY for both.

### 18–21 · Quiz flow — see "Quiz" section below (visual re-pull)

### 22 · Flashcards — NOT BUILT — `225:5582` (+ component `247:3260`), university only
- Contract: `getFlashcardsForLecture` (cursor + `pageSize`; `403 flashcard_subscription_required`
  when the weekly preview is used up) and `setFlashcardSelfGrade` (`FlashcardSelfGrade` is a
  **closed** enum `{gotIt, again}`; server keeps only the latest grade — no spaced repetition).
  `seif_fight.md` S6 is stale on the contract half (stable since 3.13.0-m1).
- Data layer ✅ built + tested (`FlashcardCard{id, front, back, imageUrl, selfGrade}`, paging on
  `hasMore`, non-optimistic grade). ⬜ screen, route, entry point, mock routes, and
  `flashcard_subscription_required` copy.
- Figma: header ✕, "Flash cards", bookmark, share (AI icon `hidden`); progress "1/10"; card
  front = image + "What is A ?", back = "Sclera" placed one card-width to the right (no reveal
  mechanism drawn); a "<" button (the app's standard back glyph) + **Confirm**; bottom nav visible
  (lives inside the shell).
- ❌ no self-grade control for `gotIt` / `again`; ❌ bookmark/share have no contract field.
- **Open design questions:** (1) how Confirm / "<" map to `gotIt` / `again`, and whether "<" is
  flip or previous; (2) front → back reveal (swipe? tap?); (3) bookmark/share — omit (S24/S25
  precedent) or ask for a field; (4) per-lecture entry point for `hasFlashcards` vs the #18 tab;
  (5) rewrite S6.
- Verdict DESIGN CLARIFICATION, then a new screen.

## Quiz (screens 18–21)

Functional/behaviour from source (agent 5); visual column from the Figma re-pull (agent 5b, working
connector). Unopened there: `225:6634`, `225:7001`, `549:20324`, dark tiles `337:6434`–`:6447`, dark AI
panel `337:9270`/`:9278` (DESIGN_ISSUES #83/#87 hold Properties-panel reads for those).

### 18 · Quiz setup — `135:1622` / `309:5771` — createQuiz
- Functional ✅ (422 `not_enough_questions`, 403 `insufficient_scope` inline, 403 paywall codes →
  `LimitSheet` ⚠ #51 copy / ⚠ #74 dark scrim, offline). ⚠ #82 (shared header, resolved). Pool-progress
  and points preview omitted (S15/S12). Cross-cutting 35 dp back chip; no width cap.
- Visual 6/9 (frames `135:1622` = `309:5771`, identical): ⚠ **subject caption dropped** — the frame
  shows "Biology" above "Cell Membrane"; code renders `scopeName` only and its comment
  (`quiz_setup_screen.dart:74-78`) says this is "flagged in docs/DESIGN_ISSUES.md" — **it is not**
  (grepped). Log it; buildable by carrying the subject name in `QuizSetupArgs` from the catalog.
  ❓ idle-chip hairline: seen in a screenshot, contradicted by the code's Properties-panel reading of
  `146:2315`/`146:2316` — screenshot colours are unread, so re-read the panel in the wave.
  ⚠ #31 (pool card, points preview), #35 (nav bar). **Limit sheet `199:2335`:** ❌ the frame
  draws a ✕ close beside the title; the built sheet has none (drag handle + "Not now"). ⚠ #30, #51, #74.
- Verdict moves READY → **IMPLEMENT** (limit-sheet ✕; subject caption decision).
- **Correction 2026-09-26 (Wave 11 frame re-read):** COMPARE missed three things. (1) The limit "sheet" is a
  **centred card** in `199:2335` (`207:5904`, 345 wide, radius 22), not a bottom sheet (owner: build as drawn).
  (2) The dark frame `337:6239` draws the scope `#FCFBF9`; the build used the dark primary (lavender). (3) The dark
  header rule is `rgba(204,213,210,0.2)` at 0.5; the build had `#2E2D32` at 1.18. All three are fixed. The
  idle-chip ❓ is closed: `146:2315` and dark `337:6289` carry no stroke, so the build was already right.

### 19 · Quiz question — `159:845`, `159:1695` (AI), `216:2973` (photo) / `309:5878` — submitAnswer, getExplanation, finishQuiz
- Functional ✅ idempotent answer retry, 409, 403 codes (limit sheet re-shown mid-quiz), explanation
  202 poll 2 s × 10, 429 retryable, finish → invalidate `meProvider` → result.
- ❌ **Contract-mandated popup not built.** `openapi.yaml:1688-1703` (lead re-read): on
  `getExplanation` `403 subscription_required` "Show this popup, using this approved copy verbatim:
  'AI explanations are available with a Level Up subscription. Subscribe to get step-by-step
  explanations and more learning features.'" — `ai_explanation_panel.dart:125-142` renders the
  generic `explanationUnavailable` line instead. No ruling found in `docs/` (grepped). This sits on
  the purchase-silent line (adr-049 §3): **owner ruling required** — adopt verbatim, or record a
  deliberate divergence like #51.
- 🟡 409 `quiz_already_finished` still offers Retry (`suppressesRetry` excludes only
  `account_pending_deletion`).
- ❌ close ✕ is a bare `IconButton` with no tooltip/semantics (`quiz_screen.dart:130-137`) — device
  item 6 (2026-09-20) still open.
- ⚠ #33, #83, 🔴 #87 still present (`question_option_tile.dart` paints the label `textPrimary`
  in every state → dark CORRECT 1.11:1), #88 (`<u>` literal, `mcq_renderer.dart:72-79`).
- Visual 6/10 (`309:5878` = `159:845`): ❌ **app-bar icons** — the frame draws three trailing icons:
  an AI "sparkle-cap" glyph (undocumented, unbuilt), bookmark and share (covered: favourites draft,
  no share surface, S11). ❌ **AI panel header** uses `Icons.school_outlined`
  (`ai_explanation_panel.dart:74-78`) where the frame draws the sparkle + mortarboard glyph the app
  already ships as `assets/icons/ai_education.svg`. ⚠ the frame's two sub-headed bodies ("Why is this
  wrong?" / "Why is the correct answer right?") vs the contract's single `text` (S17).

### 20 · Quiz result — `159:1964` / `309:6375`
- Functional ✅ pure render of `QuizSummary`; back → `/learn` per #82.
- ❌ `+{points} نقطة` (`app_ar.arb:189`) renders `3+ نقطة` — device item 4, no LTR isolate.
- Visual 6/9 (`159:1964` = `309:6375`; **`309:6488` is a duplicate of Review, not a Result
  variant**): ❌ subtitle "Biology — Cell Structure" vs `scopeName` only (`quiz_result_screen.dart:72-80`,
  same root as Setup); ❌ rewards line drawn as two runs ("+200" accent, "Points" plain) vs one colour
  (`:330-338`; colour values to be read off the panel, not the screenshot); ❌ "Review Questions" CTA
  has a leading sparkle-cap icon in the frame, text-only in code (`:126-139`; not covered by #76).
  ⚠ "Pass" label omitted (no threshold in contract), #29 (Skipped bucket), #50 (meter removed, D-006).

### 21 · Quiz review — `162:2377` (dark `337:6705`, RTL `549:20324`)
- Functional ✅ in-memory; filter chips client-side with 48 dp targets; FLAG_SECURE correct.
- ⚠ #52, #53 (resolved), #54 (two sub-items open), #55, #56, #57, #58. Row min-height 73 overflows at
  1.35× (13 px slack, self-documented) → pin with a test.
- Visual 8/9 — **matches**; every visible divergence is ruled (#52–#57). Verdict READY.

## Cross-cutting findings (not owned by one screen)

| Item | Where | Status |
| --- | --- | --- |
| RTL forward/back chevron double-flip | `catalog_scaffold.dart:100-108` | open, device-proven — one fix, screens 10–17 |
| Leading `+` bidi flip | `login_screen.dart:298`, `signup_identity_screen.dart:267`, `app_ar.arb:189` | open, device-proven |
| `CircleBackButton` 35×35 hit area | `circle_back_button.dart:52` | same root as #80 / D-013 (owner assigned it to the header owner) |
| Button semantics on `ElevatedSurface(onTap)` / `TreeListRow` | mistakes card, `tree_list_row.dart:120` | new |
| No width cap on tablets | whole app (`docs/RESPONSIVE.md` 0/11 applied) | proposed, not applied — owner's call |
| Text-scale overflows | SubjectCard 9.1 px, TreeListRow 7/20 px, BUG-002 | known; TreeListRow missing from the RESPONSIVE queue |
| Latin digits in Arabic | #19 | awaiting designer |
| Mock backend gaps | no `PATCH /me`, no `/flashcards`, no explanation `429` | blocks WALK for screens 7–9, 22 |

## Lead verifications (claims that decide a verdict)

| Claim | Result |
| --- | --- |
| Stale profile after re-login is fixed (agent 2) | **Refuted** — no code change since the device finding |
| RTL chevrons are fine (agent 4) | **Refuted** — SDK icons are `matchTextDirection: true` |
| Logout frame has No/Yes buttons (agent 2) | **Confirmed** — `get_metadata 180:4704` |
| Explanation `subscription_required` needs a verbatim popup (agent 5) | **Confirmed** — `openapi.yaml:1688-1703`; no ruling in `docs/` |
| Flashcard self-grade is `{gotIt, again}` (agent 6) | **Confirmed** — `flashcard.dart:18`, contract `FlashcardSelfGrade` |
| Mistakes overview stale after quiz (agent 4, "new") | **Reclassified KNOWN** — self-documented at `mistakes_notifiers.dart:39-56` |
| 35 dp back chip (agents 1, 5, "new") | **Reclassified KNOWN-family** — #80 / D-013 |
| Quiz agent "Figma unauthenticated" | **Wrong server** — visual re-run with the working connector |
