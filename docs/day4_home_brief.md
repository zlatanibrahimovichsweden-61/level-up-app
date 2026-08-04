# Day 4 Brief — Home (school) + bottom-nav shell  (Option A + b)

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Scope chosen by the owner: **A** (build only stable-endpoint sections; stub/hide the
> draft-dependent ones) **+ b** (Home + the bottom-nav shell), **school Home only**.
>
> Prerequisite: BUG-001 (registration red-screen) should be fixed & committed first so the
> real login→register→/home path works; Day 4 is reachable in the mock harness regardless.

## What Day 4 builds
1. **Home (school)** — Figma `337:5303`. Only the `GET /me`-backed sections are real; the rest
   are stubbed/hidden (they need draft or non-existent endpoints).
2. **Bottom-nav shell** — the 5-tab bar (Home · Leaderboard · Learn · Message · Account) as a
   go_router `ShellRoute`. **Home** is the only real tab; the other four are placeholder screens.

## Explicitly OUT of Day 4 (do NOT build)
- `GET /catalog/subjects` / subjects list — that's the **Learn tab**, not Home. Deferred.
- Daily Tasks, Continue Learning, Top Student — draft/no endpoint (stub only).
- University Home. Leaderboard/Message/Account tab content (placeholders only).

## Skills (invoke from .claude/skills/)
`level-up-domain` · `build-screen` · `seif-api-contract` · `figma-frame` · `river` ·
`screen-states` · (+ `flutter-setup-declarative-routing` for the ShellRoute, `flutter-add-widget-test`).

---

## Endpoints (both stable)

### `GET /me` → `StudentProfile`  (the whole Home is powered by this one call)
Required fields: `id, track, name, phone, dateOfBirth, avatar, geography, points, level, badges,
privacy, entitlements, createdAt`.
- `avatar`: `{ type: "default"|"custom", id?, url }` → network image (`cached_network_image`).
- `points` (int), `level` (int, 1–12), `badges` (int) → the level card. **Display-only.**
- `entitlements`: embedded `EntitlementState[]` for first paint (same shape as `/me/entitlements`).

### `GET /me/entitlements` → `{ items: EntitlementState[] }`
`EntitlementState { type: baseSubscription|flashcardSubscription, active, expiresAt?, inGrace, graceEndsAt? }`.
Refetch on app resume. For Day 4, wire the provider; Home may not display it prominently (no
obvious entitlement widget in this frame) — fetch it, keep it available for the paywall later.

**OPERATING RULE (level-up-domain):** points / level / badges are **server-authoritative** — render
exactly what `/me` returns. NEVER compute or increment them client-side.

---

## Home layout (`337:5303`) — build real vs stub

Top → bottom, scrollable, inside the nav shell (`/home` tab), AR-RTL + EN, light/dark theme tokens:

1. **Header** ✅ REAL — avatar (`profile.avatar.url`, cached) + "Welcome back, {name}" + 🔔 bell.
   Bell has no endpoint → static icon, no badge, no action (or a `TODO` no-op).
2. **Level card** ✅ REAL — trophy + `LEVEL {level}` + `Pts Balance {points}` + a progress bar to
   the next level + `Level {level} / Level {level+1}`.
   ⚠️ **GAP (add to DESIGN_ISSUES as #13):** `/me` gives `points` + `level` but NOT the next-level
   threshold. The design shows "2,450 / 5,000", but the contract's rule is "levels 1–12, thresholds
   every 500 points" (and 5,000 is actually the post-L12 **badge** cadence). So the "/5,000" is
   ambiguous. **For now:** show `LEVEL` + `points` for real; render the progress bar from a documented
   client constant (`kPointsPerLevel = 500`) and add `// TODO(contract): confirm level thresholds with
   Seif`. Do not invent a "/5000".
3. **Daily Tasks** ❌ STUB — section header "Daily Tasks / See All", then a **"Coming soon"
   placeholder card** (or hide the whole section behind a `const kShowDailyTasks = false`). No fake rows.
4. **Continue Learning** ❌ STUB — same treatment (needs quiz-history, draft).
5. **Top Student** ❌ STUB — same (needs leaderboard, draft).
6. **"Learn Today, Lead Tomorrow" banner** ❌ PLACEHOLDER — it's a **carousel** (paging dots) of
   marketing slides; the illustration is export-blocked (DESIGN_ISSUES #1). Render ONE themed
   placeholder box (no carousel logic — no content endpoint), `TODO(design-asset)`.

_Verified against the live Figma via the Chrome extension: header "Welcome back, Ahmed Mohamed";
level card `LEVEL 8 / Pts Balance 2,450` with `Level 8 → Level 9`, `2,450 / 5,000`; Daily Tasks
(Complete 2 Quizzes 1/2 +200, Solve 30 Questions 30/30 +300 completed, Complete Biology Quiz 0/1
+150); Continue Learning (Physics, 80%, 12 lessons left, 12-day streak); Top Student (Sara 18,200 /
Omar 16,800 / Nour 15,400). All Daily Tasks / Continue Learning / Top Student values are mock — do
NOT reproduce them; those sections are stubbed._

Home states (screen-states DoD): **loading** (skeleton of header+level card), **error** (retry
re-calls `/me`), **offline** (distinct banner). No "empty" — `/me` always returns a profile.

## Bottom-nav shell

- go_router **ShellRoute** wrapping the 5 destinations; bottom bar from Figma nav (`59:1264` light
  / `348:6686` dark). Tabs left→right: **Home** (real) · Leaderboard · **Learn** (center, visually
  elevated / FAB-style) · Message · Account. Home is active (purple) on this frame.
- Only `/home` renders HomeScreen; the other four are simple placeholder screens ("Coming soon",
  themed) at `/leaderboard`, `/learn`, `/message`, `/account`.
- Preserve tab state; Home is the initial/selected tab post-login.
- The existing `/home` placeholder in `app_router.dart` is replaced by the shell's Home.

## Files
```
lib/features/profile/            (or lib/features/me/)
  models/      student_profile.dart (+ entitlement_state.dart, avatar, geography) — freezed+json, camelCase
  repository/  profile_repository.dart  (GET /me, GET /me/entitlements; typed AppException)
  notifier/    me_notifier.dart  (AsyncNotifier<StudentProfile>)
lib/features/home/
  screens/     home_screen.dart
  widgets/     level_card.dart, home_header.dart, coming_soon_section.dart
lib/features/shell/
  main_shell.dart  (ShellRoute scaffold + bottom nav)
  screens/     leaderboard_placeholder.dart, learn_placeholder.dart, message_placeholder.dart, account_placeholder.dart
```
Router: add the ShellRoute + the 4 placeholder routes; wire `/home` to HomeScreen inside the shell.
Add dep if not present: `cached_network_image` (avatar).

Note: registration currently carries the profile as an **opaque Map**; Day 4 introduces the **typed
`StudentProfile`**. You may leave the registration opaque-carry as-is (it just needs tokens), or wire
it to the new model if trivial — do NOT expand scope for it.

## l10n (add, both .arb)
`homeWelcome` ("Welcome back, {name}"), `levelLabel`, `pointsBalance`, `levelProgress` (Level {a} /
Level {b}), `dailyTasks`, `continueLearning`, `topStudent`, `seeAll`, `comingSoon`, tab labels
`navHome`/`navLeaderboard`/`navLearn`/`navMessage`/`navAccount`.

## Acceptance / DoD
- [ ] Home renders header + level card from a real `GET /me`; points/level/badges display-only (no client math).
- [ ] Daily Tasks / Continue Learning / Top Student are stubbed (coming-soon) or hidden — **no fake data**.
- [ ] Loading / error / offline on Home, AR (RTL) + EN, light + dark.
- [ ] Bottom-nav shell: 5 tabs, Home real, 4 placeholders; tab state preserved.
- [ ] `StudentProfile` + `EntitlementState` freezed models (camelCase, no `@JsonKey` bridge); `fromJson` tests.
- [ ] `me_notifier` test (mock Dio: success/error/offline). Router test: post-login lands on `/home` in the shell.
- [ ] `flutter analyze` clean · `build_runner` ok · full suite green.
- [ ] Add DESIGN_ISSUES #13 (level-progress threshold) with the code `TODO(contract)` marker.
- [ ] Works in the mock harness (mock `/me` returns a StudentProfile → Home renders on device).

## Scope / do NOT
- No subjects/Learn tab, no leaderboard/history/tasks real data, no university Home, no Paymob.
- Do NOT commit — leave for review.
