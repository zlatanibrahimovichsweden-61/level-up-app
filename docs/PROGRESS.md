# Level Up — build progress & session handoff

> ## ⚠ THIS IS A HISTORICAL LOG, NOT CURRENT STATE
>
> Entries below are **dated records of what was true when written** — including
> test counts like "792 green", which was accurate on that day and is not
> accurate now. They are deliberately left unedited: rewriting a build log to
> match today falsifies the history it exists to preserve.
>
> **For current project state, read `docs/WAVE_STATUS.md`.** For live risks,
> `docs/RISKS.md`. For the current test count, run `flutter test` — no document
> should freeze it.
>
> This banner was added in Wave 4 because the numbers below otherwise read as
> live claims.

> Read this first to re-ground after a chat compaction or in a new session.
> Durable truth lives in files, not chat memory: this doc + the briefs + the vault
> `00_Project/Decisions_Log.md` / `Open_Questions.md` + `contract/openapi.yaml`.

_Last updated: 2026-07-23 (superseded for project state — see `WAVE_STATUS.md`)_

## Repo & branches
- App repo: `level_up_app` (GitHub: zlatanibrahimovichsweden-61/level-up-app, private).
- `main` = promoted, green checkpoints (auth epic merged).
- `dev` = active branch. **Day 2 is being built on `dev` in Claude Code right now.**
- Workflow: Claude (this chat) writes briefs + reviews; **Claude Code** implements on `dev`;
  user commits after review; promote `dev → main` when green.
- Flutter 3.44.7 / Dart 3.10. Stack: Riverpod + Bloc(quiz only) + go_router + Dio +
  freezed + flutter_secure_storage + hive_ce + intl. `country_flags` for the picker.

## Done (committed)
- **Day 0 foundation:** feature-first `lib/core` + `lib/features`, sealed `ScreenState` +
  `StateWidget`, Dio client + interceptors, `SecureStorage`, 2-theme `AppColors` (light green
  `#384F47` / dark purple `#AE87E7`), go_router, i18n AR(RTL)+EN, flavors, bundled fonts.
- **Day 1 auth:** Login (phone, E.164 + Arabic-digit fold) + OTP verify (6-digit, verify fork)
  — light/dark, AR/EN, offline as a distinct state.
- **Day 1b session:** `AuthController`, single-flight loop-safe token refresh, `AuthInterceptor`
  (session_superseded→forceLogout; authentication_required→refresh+retry once), router redirect
  guard, forced-logout message. `clearTokens()` preserves `device_id`. 46 tests green.

## Day 00 — onboarding (brief: `docs/day00_onboarding_brief.md`) — built, awaiting review
The onboarding SCREEN was deferred behind the router guard during the Day-0 infrastructure pass and
never built; `/` served a `_Placeholder`. It now renders `OnboardingScreen` (Figma `337:15146` dark /
`459:43873` light sheet), `initialLocation` is `/`, and `authRedirect` keeps a signed-out student on
it while bouncing an authenticated one to `/home` — which is why **no "onboarding seen" flag is
stored**. Also reconciled the OTP success view against `155:786` and landed the three brand assets.

## In progress — Day 2 (brief: `docs/day2_registration_brief.md`)
Scope: **Sign Up_1** (identity) + **Sign Up_2** (track picker) + `RegistrationController` spine
(holds registrationToken + 10-min deadline) + the **7 reference-picker providers**
(countries/governorates/cities/schools/education-systems/universities/avatars).
NOT in Day 2: track-detail field screens, `POST /auth/register` (both → Day 3).

## Next — Day 3
Track-specific screens inside School/University Student Flow (geography conditionality adr-010,
stage+educationSystem OR university→faculty→year, avatar, dateOfBirth) + final `POST /auth/register`.
Figma frames still to pull (School/University flows).

## Day 7 — quiz engine (brief: `docs/day7_quiz_brief.md`) — built, awaiting review
Setup → taking → results, plus the free-plan limit sheet. **The first and only use of `flutter_bloc`:**
`QuizBloc` owns one session (questions, index, per-question grade, explanation, summary) with guarded
transitions — double-submit, re-answering a committed question and finishing mid-flight are all
rejected deterministically. Everything else in the app stays Riverpod, including setup
(`AsyncNotifier`, one request then navigate) and invalidating `/me` after finish.

`QuestionRenderer`/`McqRenderer` splits the screen at the flashcard seam — the shell is
renderer-agnostic, and no flashcard renderer, bool or enum member was built (no contract shape).
`screen_protector` is on behind an injectable seam so on-mount/off-dispose is asserted in tests, not
assumed. Quiz state is in memory only (nothing cached to Hive) with a confirm-on-exit dialog.
Mock backend covers all four endpoints and every error path.

Six frame elements were built around rather than invented — points preview, pool card, Pass verdict,
Review Questions, the limit sheet's usage bar and the AI panel's second section. See `seif_fight.md`
S11–S19 and `DESIGN_ISSUES.md` #29–#35.

## Day 7b — design-fidelity pass (brief: `docs/day7b_design_fixes_brief.md`) — built, awaiting review
Not a feature day and **no endpoint change** — a correction of four surfaces built in Days 00–7
against what the app actually looks like on a device. Five commits, one per section, closing
`DESIGN_ISSUES.md` #36–#42; #43 stays blocked on the designer.

**Nav bar** now uses the five exported SVGs (fitted `BoxFit.contain`, not forced square — three of
them have a non-square viewBox), and the bar is the frame's Union outline: a 30-radius sheet with a
r=32 notch, painted by `CustomPainter` and clipped by `CustomClipper`. `navBarPath()` is
parametric rather than a scaled replay of the export, so the notch stays circular and concentric
with the centre button at any width. Selection on the centre tab moved to the **circle fill**; the
glyph goes grey→white and never takes the accent.

**Language pill** got the stroke-drawn translate glyph and the frame's metrics, and its border is
now **light-only** — `languagePillBorder` is nullable per canvas. The duplicate `_LanguagePill` in
`login_screen.dart` is deleted; all six call sites share one widget.

**Track picker** renders the two committed illustrations (the only assets in the pass drawn without
a `colorFilter`), a 1px gradient border that is absent in dark, an r=9.5 hollow radio, and a new
shared `core/widgets/circle_back_button.dart`. `track_school.svg` was edited: `flutter_svg` cannot
blur, and its Figma shadow group rendered as a hard grey duplicate, so the group was deleted.

**Home** is the highest-value item: the light frame `59:1439` exists and shows Home is **exempt from
the green/purple accent flip** — purple in both canvases. New `homeAccent` token carries the
exemption in the palette; `colorScheme.primary` is gone from `lib/features/home/`. The bell became a
ring + glyph + dot chip, with the dot **gated** behind a flag that is permanently false pending a
notifications endpoint.

**Tests:** 18 goldens in both canvases (`test/goldens/`, `matchesGoldenFile`, no new package, fonts
loaded from `FontManifest.json`) plus 7 behavioural widget tests for the two claims a golden cannot
explain. Suite is 563 green, `flutter analyze` clean.

Left deliberately unfixed and flagged: the track card's **selected** state (a Day-2 invention the
frame does not draw — replacing one guess with another is worse), the level medallion (#43), the
pill's label wording, and `cardFill` light `#FDFDFD` vs the frame's `#FCFBF9`.

## Day 7c — contract v1.1 reconciliation (brief: `docs/day7c_contract_v11_brief.md`) — built, awaiting review
Not a feature day and not a design day. **No new endpoint is consumed; coverage stays 21/36.** It
closes the gap between the vendored contract — re-pinned to **v1.1.0-m1 (`ee2ed8f`)** during the Day 7
commit and never reconciled — and the registration/profile code, which was still v1.0. Seven commits,
one per section. The 563-test suite was **green and wrong** walking in: every registration test
asserted the dead rules.

**Section 0 found no seventh drift, and proved it.** The changelog is Seif's summary of his own
change, not a diff, so the vendored file was diffed across the re-pin (`git diff 7dff9e5~1 7dff9e5 --
contract/openapi.yaml`) — fourteen hunks, every one accounted for by the brief's six-row table plus
five description repairs. Three *contract-internal* inconsistencies did surface and are logged as
`seif_fight.md` **S21**: the city union is `anyOf` (which permits both) while the prose forbids both;
`/reference/schools` still describes free-text school as the non-Egypt path; and `429` is declared on
only 3 of the 6 `/reference/*` paths.

**Request bodies + validation.** `cityId` **OR** `cityName` (free text, max 100), resolved once by a
shared `cityUnionFromDraft` — exactly one key is serialized and the other is **omitted, not nulled**,
because on this wire those are different things. Neither throws; **both** throws rather than letting
the server catch it. `schoolName` is deleted everywhere — model, widget, setter, ARB, tests, mock.
`schoolId` is never required, Egypt included. `governorateId` is untouched: adr-028 does not touch
adr-010.

**The one that could throw.** `StudentProfile.geography.city` was a bare `NamedRef` with a non-null
`id`, so a free-text city would have **crashed a well-formed `GET /me`**. Now a sealed
`ProfileCity.coded/.freeText` union discriminated on the presence of `id`, chosen over optional
fields for compiler-enforced exhaustiveness at the Day 8 call sites that do not exist yet
(`DECISIONS.md` D-004). Fixed while `ProfileGeography.city` still had **zero** call sites in `lib/`.
`ProfileSchool.school` needed no change for a skipped school — it was already nullable, which we got
right by luck, not by design.

**Two new registration states, built ahead of the design** (`DECISIONS.md` D-003, `DESIGN_ISSUES.md`
#44). Day 7b's "do not invent states the design does not draw" rule was suspended by owner decision:
the backend is the restricting authority this day, and Seif's partner notice of 2026-07-30 is the
spec of record. A city escape link on **both** tracks swaps the dropdown for a text field in place;
the school step is Egypt-only and skippable, reading *"لم أجد مدرستي"* and rendering as **resolved**
rather than blank. Behaviour is invented; styling is not — every colour, size and component already
existed on those screens. The consequence easiest to miss is covered: a free-text city has no
`cityId`, so the Egyptian school search falls back to **governorate-only** scoping rather than being
disabled.

**Error mapping.** `429 rate_limited` becomes a typed `RateLimitedException` carrying a defensively
parsed `Retry-After` (delta-seconds only — a date form would mean trusting the device clock). It is
deliberately **not** `otp_throttled`, which would show an OTP message for a geography lookup.
`404 country_not_found` gets the code and nothing else: no subclass, no new UI, per Seif's notice §3.

**Mock backend** is now strict where the server is strict — it rejects `schoolName` and both-cities,
emits both arms of the city union, and carries device-reachable triggers for the new 400/404/429
paths (three rows in the country picker, plus typing `429` in the school search).

**Tests:** 625 green, `flutter analyze` clean. No new goldens by design — the two new states have no
approved frame, and a golden would freeze a look we invented.

> ⚠️ **Contract pin references in every brief predating this one are STALE.** Days 00–7b all say
> `pinned 23f0535`, which is two versions old. **`contract/SOURCE.md` is authoritative** — it pins
> `ee2ed8f` (v1.1.0-m1), vendored 2026-08-03. Do not trust a contract reference in an older brief.

## Day 8 — the Account cluster (brief: `docs/day8_account_brief.md`) — built, awaiting review
**The day the contract ran out.** One endpoint to build (`PATCH /me`) and eight designed screens.
Three commits, one per step; the split was deliberate so the owner could review between them.

**Step 1 — Profile hub** (`6edf922`). `ProfileScreen` (Figma `166:4416`) replaces
`AccountPlaceholderScreen` on the `/account` branch, powered by the `/me` Home already fetched —
switching tabs costs no request. **Points renders `points.total` verbatim; Solved Questions and Rank
are omitted outright** because the contract has neither (S24, S25) and a card showing "—" invites
somebody to fill it in with a guess. The frame draws **ten** rows, not eight: `Go to University` and
`Logout` are rows too, styled differently, opening dialogs rather than navigating. Logout is the one
thing on the screen that fully works.

**Step 2 — Edit Profile + `PATCH /me`** (`fdf8d73`). The last unconsumed stable endpoint.
The whole step turned on one field: **`email` is the only place in this app where sending an
explicit JSON `null` is correct** — absent means unchanged, `null` means clear it. `String?` cannot
carry three states, and the repo's standing `includeIfNull: false` habit would have made *clearing
an email silently impossible*. Modelled as a sealed `EmailPatch { unchanged | set | cleared }` with
a hand-written `toJson`; the "cleared" test was proven to bite by temporarily reverting the
handling and watching three assertions go red. `ProfileCity` got its first real call site and is
switched on exhaustively. Six fields the frame draws as inputs render **read-only**, and one —
Parent's Number — could not be built at all, which is how **S34** was found.

**Step 3 — Settings, shells, and the records** (this commit). `SettingsScreen` (`176:1840`) replaces
the `/settings` placeholder: Languages and Mode are client preferences, Rank is two `PATCH /me`
booleans through Step 2's one repository method, Notification Preferences is four dead toggles.
**Mode closes `DESIGN_ISSUES.md` #10** — both palettes have existed since Day 0 and nothing could
select between them, so half the design was unreachable on a device. Four Profile rows now open
**disabled shells** (Refer a Friend, Customer Support, Privacy, Terms); three stay dead because a
shell for them would have to invent the missing thing. `seif_fight.md` gained **S24–S36**.

**The rule that governed all three steps:** shells, not mocks. No invented referral code, no fake
ticket, no placeholder friend row, no legal copy. Every disabled control has a `Key`, a
`TODO(contract)` naming its entry, and a widget test asserting it is **structurally** dead — no ink
response anywhere in its subtree, not merely a null callback.

**Tests:** 764 green (Step 1 +35, Step 2 +59, Step 3 +45), `flutter analyze` clean, no new goldens
and the existing 18 untouched.

## Theme wiring pass — after Day 8, no endpoint, no package
**Two commits. Coverage is unchanged at 21/21 stable · 22/36 total** — this is a follow-through on
what Step 3's Mode selector exposed, not a feature day.

**Persistence** (`8bd95da`). Neither preference survived a launch: a student picked dark, killed the
app and got light back. `LocaleController`'s doc had carried a deferral naming its own trigger
condition — *"add a SharedPreferences-backed load/save when settings lands"* — and settings had
landed. Both ship together, because a launch where the language sticks and the theme does not reads
as a bug rather than a scope line. `PreferencesStore` wraps the **already-declared, until-now-unused
`shared_preferences`** (no new package), and is deliberately **not** `SecureStorage` — that store's
Keychain policy exists for tokens and the `device_id`. It is loaded in `bootstrap()` *before*
`runApp` and injected as an override, so both controllers stay synchronous and the first frame is
already correct; a lazy async load would flash the wrong canvas on every cold start, which is worse
than the defect being fixed. A key holding the wrong type makes `getString` **throw** — on the
startup path — so every read and write swallows its own failure and falls back to the default.

**Call sites that ignored the canvas** (this commit). Four of them:

| What | Before | After |
|---|---|---|
| Go-to-Uni dialog's disabled Confirm label | literal `#FCFBF9` — the light surface value | `cs.onPrimary`, the same slot the enabled label uses |
| Five drop shadows | raw black on both canvases | one `elevationShadow` token, per canvas (`DESIGN_ISSUES.md` #47) |
| Status bar / system nav icons | never set at all | one `AnnotatedRegion` at the app root, driven by the brightness in force |
| Notification toggles | OFF | ON, matching the frame (`DESIGN_ISSUES.md` #48) |

The shadows are the real defect: black at 25% drops the light canvas ≈21 L\* and the dark canvas
≈5, so **elevation silently disappeared in dark mode**. The token has no alpha — each frame's
measured depth stays at its call site. The dark value is derived and marked `TODO(design)`.

`test/core/theme/palette_discipline_test.dart` now holds the Day 7b rule — *no hex, no raw
black/white outside `lib/core/theme/`, one status-bar style in the whole app* — as a test rather
than a grep somebody has to remember. That rule had been failing quietly for two months, because a
hardcoded colour compiles, analyses clean and looks perfect on the canvas it was measured against.

**Tests:** 792 green (+28). Goldens: **none moved** — no golden subject carries one of the five
shadows, and `navShadow` was deliberately left alone.

## What the app looks like after Day 8
A five-tab nav bar with **three real tabs** — Home, Learn, Account — and **two placeholders**:

| Tab | State | What unblocks it |
|---|---|---|
| Home · Learn · Account | real | — |
| **Leaderboard** | placeholder | `GET /leaderboard` + `/leaderboard/me` are `draft`. Schema is written; it needs promoting. The cheaper of the two. |
| **Message** | placeholder | **No endpoint exists at all** — not draft, absent. A complete support/ticketing product in Figma with nothing behind it (S33). |

**Neither is fixable from our side.** That is the honest state of the app and the next person should
not have to rediscover it.

## Endpoint coverage — 21/21 stable (100%) · 22/36 total
**Every stable path in the contract is consumed.** `PATCH /me` (Day 8 step 2) was the last one.
**Every one of the 14 remaining paths is `x-stability: draft`**, so there is no further endpoint
work until Seif promotes something — the next feature day depends on a contract change, not on us.

The 22nd consumed path is `GET /me/entitlements`; the 14 unconsumed are the three favourites, quiz
history and review, `/checkout/sessions`, both leaderboard paths, `PUT /me/avatar`,
`PUT /me/fcm-token` and the four `/auth/recovery/*`.

## Endpoint coverage before Day 8 (historical)
Done: auth otp/request, otp/verify, refresh, logout (4). After Day 2: +7 reference = 11/21 (52%).
**Quiz x4 are now done** — `POST /quizzes`, `POST /quizzes/{id}/answers`,
`POST /quizzes/{id}/finish`, `GET /questions/{id}/explanation` (Day 7).
Pending: register (Day 3), profile GET/PATCH /me, /me/entitlements, catalog x2.
Not consumed (all `x-stability: draft`): `GET /quizzes` (history), `GET /quizzes/{id}` (review),
the three favourite endpoints.

## Open conflicts / change requests
- **To Seif:** staging/prod `baseUrl` (still `TBD.example`); Paymob return deep-link scheme;
  flashcard endpoints (none exist); quiz-timer field (design has timer, contract doesn't);
  **referral/invitation code** (Sign Up_1 field has no backend field — confirm scope).
- ~~**To designer/owner:** Figma export is disabled + our seat is View-only~~ — **RESOLVED
  2026-07-30.** Re-verified with `download_assets`: SVG + PNG now return for every blocked node, with
  no change needed on our side. Bird logo `82:849`, OTP success badge `82:1598` and the onboarding
  illustration `337:15166` are all landed in `assets/images/` and rendering through `flutter_svg`;
  both `TODO(design-asset)` markers are deleted and `DESIGN_ISSUES.md` #1 is closed.
  ~~**Still placeholders**: notification bell `337:5330`, level medallion `337:5338`, Home banner art
  `337:5486`, catalog back glyph, footer nav glyphs~~ — **mostly closed 2026-08-04 (Day 7b).** The
  footer nav glyphs, the bell, the back chevron, the translate glyph and both track illustrations
  are exported and wired. **Three `TODO(design-asset)` sites remain**: `level_card.dart` (the
  medallion — genuinely blocked, see #43: per-level RASTER artwork, so it needs an image set, not an
  export), `home_banner.dart` (`337:5486` carousel art) and `catalog_scaffold.dart`.
- **Design vs contract (build contract's way):** OTP 6 not 4 · phone `+20` not `+02` · dark≠inverted
  light (real purple palette) · student phone read-only (bound to registrationToken) · dateOfBirth
  location TBD.

## Key figma node ids (dark-mode; light equivalents exist, theme handles colour)
Login 82:819 (dark 337:15652) · OTP entry 82:1171 · OTP error comp 82:1170(light)/337:19271(dark) ·
Sign Up_1 337:15875 · Sign Up_2 (track) 337:15947 · bird logo 82:849 · file key P6044i0giD9TmdQ7C2AmLq.

## Brief index
`docs/day00_onboarding_brief.md` · `docs/day1_login_otp_brief.md` · `docs/day1b_forced_logout_brief.md` ·
`docs/day2_registration_brief.md` · `docs/day3_registration_complete_brief.md` ·
`docs/day4_home_brief.md` · `docs/day5_learn_brief.md` · `docs/day6_university_brief.md` ·
`docs/day7_quiz_brief.md` · `docs/day7b_design_fixes_brief.md` ·
`docs/day7c_contract_v11_brief.md` · `docs/day8_account_brief.md`

**Partner notice:** `docs/for_seif_account_surface.md` — sent 2026-08-06 ahead of implementation,
amended 2026-08-07 with what building it turned up (sections 9–11, and a correction to section 1).

> ⚠️ The section headers above ("In progress — Day 2", "Next — Day 3", the endpoint-coverage
> percentages) are stale as of 2026-07-30: Days 3–6 are built, and Day 00 landed the onboarding
> screen. Only the export conflict and this index were corrected in the Day-00 pass — the rest needs
> a deliberate re-grounding rather than a guess.
