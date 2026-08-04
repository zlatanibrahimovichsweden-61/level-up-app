# Level Up — build progress & session handoff

> Read this first to re-ground after a chat compaction or in a new session.
> Durable truth lives in files, not chat memory: this doc + the briefs + the vault
> `00_Project/Decisions_Log.md` / `Open_Questions.md` + `contract/openapi.yaml`.

_Last updated: 2026-07-23_

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

## Endpoint coverage (21 stable / 36 total)
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
`docs/day7_quiz_brief.md` · `docs/day7b_design_fixes_brief.md`

> ⚠️ The section headers above ("In progress — Day 2", "Next — Day 3", the endpoint-coverage
> percentages) are stale as of 2026-07-30: Days 3–6 are built, and Day 00 landed the onboarding
> screen. Only the export conflict and this index were corrected in the Day-00 pass — the rest needs
> a deliberate re-grounding rather than a guess.
