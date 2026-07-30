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

## Endpoint coverage (21 stable / 36 total)
Done: auth otp/request, otp/verify, refresh, logout (4). After Day 2: +7 reference = 11/21 (52%).
Pending: register (Day 3), profile GET/PATCH /me, /me/entitlements, catalog x2, quiz x4.

## Open conflicts / change requests
- **To Seif:** staging/prod `baseUrl` (still `TBD.example`); Paymob return deep-link scheme;
  flashcard endpoints (none exist); quiz-timer field (design has timer, contract doesn't);
  **referral/invitation code** (Sign Up_1 field has no backend field — confirm scope).
- ~~**To designer/owner:** Figma export is disabled + our seat is View-only~~ — **RESOLVED
  2026-07-30.** Re-verified with `download_assets`: SVG + PNG now return for every blocked node, with
  no change needed on our side. Bird logo `82:849`, OTP success badge `82:1598` and the onboarding
  illustration `337:15166` are all landed in `assets/images/` and rendering through `flutter_svg`;
  both `TODO(design-asset)` markers are deleted and `DESIGN_ISSUES.md` #1 is closed.
  **Still placeholders** (same blocker, now liftable — needs its own round): notification bell
  `337:5330`, level medallion `337:5338`, Home banner art `337:5486`, catalog back glyph, footer nav
  glyphs. Five `TODO(design-asset)` sites remain in `lib/`.
- **Design vs contract (build contract's way):** OTP 6 not 4 · phone `+20` not `+02` · dark≠inverted
  light (real purple palette) · student phone read-only (bound to registrationToken) · dateOfBirth
  location TBD.

## Key figma node ids (dark-mode; light equivalents exist, theme handles colour)
Login 82:819 (dark 337:15652) · OTP entry 82:1171 · OTP error comp 82:1170(light)/337:19271(dark) ·
Sign Up_1 337:15875 · Sign Up_2 (track) 337:15947 · bird logo 82:849 · file key P6044i0giD9TmdQ7C2AmLq.

## Brief index
`docs/day00_onboarding_brief.md` · `docs/day1_login_otp_brief.md` · `docs/day1b_forced_logout_brief.md` ·
`docs/day2_registration_brief.md` · `docs/day3_registration_complete_brief.md` ·
`docs/day4_home_brief.md` · `docs/day5_learn_brief.md` · `docs/day6_university_brief.md`

> ⚠️ The section headers above ("In progress — Day 2", "Next — Day 3", the endpoint-coverage
> percentages) are stale as of 2026-07-30: Days 3–6 are built, and Day 00 landed the onboarding
> screen. Only the export conflict and this index were corrected in the Day-00 pass — the rest needs
> a deliberate re-grounding rather than a guess.
