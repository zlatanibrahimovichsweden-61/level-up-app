# Known Issues — the fix queue

Ordered by what should be done first, not by severity alone. Every row carries
`file:line`, an estimated size, and what must be true before it can be called
fixed.

Nothing here has been applied. See `changed-files.md`.

---

## Tier 0 — before any release build leaves the machine

### K-0 · Commit the reformat as one isolated commit (uncommitted right now)

**State:** 141 files are formatted but **not committed**. Verified
behaviour-preserving (token stream byte-identical to `e3651e6`) and the suite is
green at 792/0.

**Why it needs care:** a 141-file commit rewrites `git blame` for 68% of the
codebase. The fix is to make it a *pure* formatting commit — no other change
mixed in — and then tell git to skip it when assigning blame.

```powershell
cd F:\level\level_up\level_up_app
git add -A -- lib test
git commit -m "style: dart format the tree (tall style, Dart 3.12)"

# make blame skip it — GitHub honours this file automatically
git rev-parse HEAD | Out-File -Encoding ascii .git-blame-ignore-revs
git config blame.ignoreRevsFile .git-blame-ignore-revs
git add .git-blame-ignore-revs
git commit -m "chore: ignore the formatting commit in git blame"
```

**Commit `lib` and `test` only in the first commit** — the new `.github/`,
`.githooks/`, `tool/`, `docs/` and `.ai/` files belong in separate commits, or
the blame-ignore trick stops being safe to apply.

**Done when:** `dart format --set-exit-if-changed` passes on a clean tree, and
`git blame` on a reformatted file still attributes lines to their original
authors.

### K-1 · The release APK has no `INTERNET` permission

**Where:** `android/app/src/main/AndroidManifest.xml` — no `uses-permission`
node at all. `INTERNET` is declared only in `src/debug/AndroidManifest.xml:6`
and `src/profile/AndroidManifest.xml:6`, neither of which merges into release.

**Effect:** every network call in a release build fails. The app launches, shows
its shell, and nothing loads. Completely invisible in development.

**Verify before fixing** — this is one command, and it settles whether a plugin
manifest happens to supply the permission:

```sh
flutter build apk --release -t lib/main_prod.dart
grep -i "uses-permission" build/app/intermediates/merged_manifests/release/AndroidManifest.xml
```

If `android.permission.INTERNET` is absent from the merged manifest, the finding
is confirmed.

**Fix:** add to `android/app/src/main/AndroidManifest.xml`, above `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

**Size:** 1 line. **Done when:** the merged release manifest contains it *and* a
release build on a device successfully completes a login.

---

### K-2 · Logout leaks the previous student's data to the next

**Where:** `auth_controller.dart:56-71` — `forceLogout()` and `logout()` clear
tokens and set state, and invalidate nothing. `me_notifier.dart:39,73` —
`meProvider` and `entitlementsProvider` are plain `AsyncNotifierProvider`, not
`autoDispose`.

**Reachable via:** the Sign Out button at `profile_screen.dart:348`, and
automatically whenever the interceptor force-logs-out
(`auth_interceptor.dart:75,129,144,146` — session expiry, superseded device).

**Effect:** the next student to sign in on the same handset sees the previous
student's name, level, points, school, governorate and entitlements on Home
until each provider happens to refetch. On shared hardware this is disclosure of
one minor's PII to another.

**Fix:** invalidate on both paths. The codebase already uses this exact pattern
at `edit_profile_notifier.dart:57`:

```dart
ref.invalidate(meProvider);
ref.invalidate(entitlementsProvider);
// plus any other provider holding student-scoped data — audit the full list
// before shipping; do not assume these two are exhaustive.
```

**Size:** ~4 lines in `auth_controller.dart`, plus an audit of student-scoped
providers. **Done when:** a widget test signs in as A, logs out, signs in as B,
and asserts B's name on Home. That test does not exist today.

---

## Tier 1 — user-visible defects

| # | Issue | Where | Size |
| --- | --- | --- | --- |
| K-3 | `/subscription` dead-end reachable from the quiz paywall — hardcoded English, unthemed | `limit_sheet.dart:123` → `app_router.dart:250,347` | Disable the entry point (mirror how Profile's was disabled), or build the screen. Small either way. |
| K-4 | Onboarding "Get Started" dead-ends on `RegistrationExpiredView` — no seeded draft | `onboarding_screen.dart:54`; the fix already exists at `login_screen.dart:76-85` | Small — copy the existing pattern |
| K-5 | Dark-mode hint text is identical to typed text (`#FCFBF9` for both) | `app_colors.dart:504,506`; `form_fields.dart:156-161` | 1 token value. **Needs a design decision on the correct dark hint colour — do not invent it.** |
| K-6 | Inactive nav labels at 2.03:1 contrast in light mode | `app_colors.dart` `mutedText`; `main_shell.dart:265,333`, `level_card.dart:147` | 1 token value + re-check the 5 sites. **Design decision.** |
| K-7 | Login's three legal links open `levelup.example` (never resolves) | `login_screen.dart:39-42,112` | Point at the in-app `legal_document_screen.dart`, which already handles missing copy correctly |
| K-8 | Subjects grid overflows at textScale 1.2× | `subject_card.dart:21` via `subjects_screen.dart:175` | Covered by the `textScaler` clamp (K-11) |
| K-9 | Quiz progress bar clips at 1.25× — every question of every quiz | `quiz_screen.dart:259` | `Size.fromHeight(30)` → `minHeight` |
| K-10 | Arabic semibold renders wrong — Tajawal has no w600, 45 call sites request it; `Cairo-SemiBold.ttf` can never load | `pubspec.yaml` fonts block | Add the Tajawal w600 face, or map w600→w700 for Arabic. **Design decision.** |

---

## Tier 2 — correctness, invisible today

| # | Issue | Where |
| --- | --- | --- |
| K-11 | No text-scale policy. Recommended: clamp `textScaler` to 1.3 in the existing `builder:` at `app.dart:51` — 3 lines, neutralises 20 of 22 responsive defects. **PRODUCT DECISION** — clamping overrides a user's accessibility setting; needs a `DECISIONS.md` entry either way | `app.dart:51` |
| K-12 | `fromJson` `TypeError` escapes every catch — repositories catch `on DioException`, `QuizBloc` catches `on AppException`. First real-API schema drift hangs the screen silently | repository catch clauses; `quiz_bloc.dart` |
| K-13 | Zero `ref.mounted` guards — 9 post-`await` `state =` assignments in `autoDispose` notifiers | OTP verify/resend, edit-profile save, quiz setup, school search |
| K-14 | freezed `toString()` prints both bearer tokens and a minor's full PII. Latent only because no crash reporter is wired — fix *before* one is | `TokenPair`, `StudentProfile` |
| K-15 | `ProblemDetails.traceId` never read; no 5xx arm. `error-codes.md` calls traceId "the support handle" | error mapping layer |
| K-16 | `main_mock.dart` doesn't override `refreshDioProvider` — a mock-mode refresh hits `TBD.example` | `main_mock.dart` |
| K-17 | R8/minification off; Dart obfuscation undocumented — against `Flutter_Common_Mistakes.md:16` | `android/app/build.gradle.kts:57-69` |
| K-18 | Screenshot protection ships 2 of the 4 steps `Platform_Specifics.md` mandates | `screen_protector` call sites |
| K-19 | Zero `memCacheWidth` at all 5 `CachedNetworkImage` sites — full-res decode into memory | 5 sites |

---

## Tier 3 — enforcement, so these classes stop recurring

These are the highest-leverage items in the whole audit. See `project-audit.md` §4.

| # | Item | Size |
| --- | --- | --- |
| K-20 | `test/core/discipline_test.dart` — five properties that hold today and are enforced by nobody: no-provider-write-in-`initState` (the literal BUG-001 guard), Bloc containment, RTL discipline, ARB parity, l10n leaks. Spec in `testing.md` | ~120 lines |
| K-21 | Stage-1 `analysis_options.yaml` — measured blast radius near zero. Full block in `devops.md` F-10-03 | 1 file |
| K-22 | Extend `registration_router_flow_test` through both detail screens to `/home` — closes the last stretch of the BUG-001 path | Medium |
| K-23 | Add a `TextTheme`. 153 inline `TextStyle(`, 153 hardcoded `fontSize`. Then a guard test in the palette-discipline style | Large — stage it |
| K-24 | OTP resend/countdown/rate-limit tests — currently zero; every OTP test sets `resendAfterSeconds:0` to dodge the timer | Medium |
| K-25 | Three integration tests: cold start with persisted session; sign-up end-to-end into the shell; quiz to completion with real `FLAG_SECURE`. Each crosses a platform channel no widget test can reach | Medium |
| K-26 | Arabic goldens — RTL golden coverage is currently 0%, against a rule the project calls a baseline requirement | Medium |
| K-27 | `select()` at the 16 `ref.watch(isOnlineProvider)` sites first — highest ratio of benefit to risk | Small |

---

## Tier 4 — hygiene

| # | Item |
| --- | --- |
| K-28 | Delete `hive_ce`, `hive_ce_flutter`, `hive_ce_generator` — declared, zero Dart references, no caching layer exists |
| K-29 | Move `Track` from `profile/models/student_profile.dart:29` to `core/models/` — removes the structural cause of most cross-feature coupling |
| K-30 | Break the `core/` → `features/auth/` provider cycle, acknowledged in-source at `core_providers.dart:36-38` |
| K-31 | Consolidate the 4 parallel `AsyncValue`→4-state implementations back into `StateWidget`; `home_screen.dart:51` is the main offender |
| K-32 | De-duplicate `signup_identity_screen.dart`'s 4 privately re-implemented form primitives (183 of 389 lines); its `PlainTextField` copy drops `FieldShell`, so it is the only screen showing an error message with no error border |
| K-33 | Finish the Day 7b design pass (sections E+) — 24pt vs 20pt inset drift, 3 forks of the back chip |
| K-34 | Reconcile `dev` with the 3 commits on `main`; delete both fully-stale `backup/*` branches |
| K-35 | Fix `Architecture_and_Folders.md` — wrong in 5 of ~10 assertions. Code is right in 4 of 5; the doc is what needs changing |
| K-36 | Delete the `QuizTimeExpired` promise from `bloc/SKILL.md` and `State_Management.md:34` — the omission is deliberate per `seif_fight.md S7` |
| K-37 | `AuthRepository` has no test — delete its body and the suite still goes green |

---

## Pre-existing issues this audit did **not** re-open

Deliberately left alone; they are already tracked and already correct.

- `docs/KNOWN_BUGS.md` BUG-001 — fixed; its scope claim was **independently
  re-verified at `e3651e6` and still holds** (all 6 `initState` sites
  re-classified; zero provider mutation in `build`).
- Base URLs are `TBD.example` — blocked on the backend partner, correctly marked
  `TODO(contract)`, and `docs/PROGRESS.md`'s claim that no further endpoint work
  is possible was **verified true** (all 15 unconsumed paths are `x-stability: draft`).
- The 14 draft endpoints, Leaderboard and Message — no backend exists. Product
  blockers, not engineering defects.
- The quiz timer's absence — deliberate, see K-36.
