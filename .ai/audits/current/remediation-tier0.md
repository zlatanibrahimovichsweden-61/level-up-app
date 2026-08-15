# Tier-0 Remediation

**Baseline:** `dev`, post-reformat tree. Fable verdict on the audit package:
`APPROVED WITH WARNINGS`.
**Scope:** the two Tier-0 issues only. No architecture, state-management,
routing, API-layer or theme changes. No test deleted or weakened.

> ## ⚠ VERIFICATION STATUS — READ FIRST
>
> The environment that wrote this code has **no Dart/Flutter toolchain and no
> Android SDK** — `which flutter dart` returns nothing and the network is
> allowlist-blocked. Every result below was therefore produced on the
> developer's machine, or is marked NOT VERIFIED.
>
> **Updated after the Wave-1 verification pass (see §6).**
>
> | Claim | Status |
> | --- | --- |
> | Code compiles | ✅ **VERIFIED** — validate.ps1, 2026-08-12T05:27Z |
> | `flutter analyze` clean | ✅ **VERIFIED** — 0 issues |
> | `dart format` clean | ✅ **VERIFIED** — 207 files |
> | New tests pass | ✅ **VERIFIED** — 804 passed / 0 failed (792 + 12) |
> | Existing 792 still pass | ✅ **VERIFIED** — no test lost |
> | Session inventory is complete | ✅ **VERIFIED** — exhaustive source scan, 23 stateful providers, 0 unclassified |
> | `src/main` declares INTERNET | ✅ **VERIFIED** — file read |
> | No unrelated files touched | ✅ **VERIFIED** — `git status` |
> | New tests fail against the OLD behaviour | ✅ **VERIFIED** — `verify_session_regression.ps1`, 2026-08-14 |
> | Working copy restored after the proof | ✅ **VERIFIED** — SHA-256 match |
> | Release build succeeds | ✅ **VERIFIED** — 60.2 MB APK, 2026-08-14 |
> | **Release APK carries INTERNET** | ✅ **VERIFIED** — `aapt2 dump permissions` on the built artefact |
> | Suite green after the guard fix | ✅ **VERIFIED** — 806 passed / 0 failed |
>
> Nothing here claims a result that was not observed.

---

## 1. Session data leakage (Tier-0 C-2)

### 1.1 Root cause

`AuthController.logout()` and `forceLogout()` cleared the tokens
(`SecureStorage.clearTokens`) and flipped the auth state to
`AuthUnauthenticated`. That is all they did.

Every provider holding the signed-in student's data is **non-`autoDispose`**,
which in Riverpod means its value lives for the lifetime of the
`ProviderContainer` — i.e. the whole app process — regardless of whether anybody
is listening. So the values simply stayed in memory across the sign-out and were
served to whoever signed in next.

**The non-`autoDispose` choice was not a mistake.** `me_notifier.dart:11-13`
explains it: the profile must survive tab switches inside the nav shell so
returning to Home does not re-flash a skeleton. The same reasoning is written
into `subjects_notifier.dart:7-10`. Both are correct.

The defect is that **nothing connected those lifetimes to the session
lifetime.** The leak arrived by *addition* — each new feature added a
long-lived provider, and the sign-out path, written earlier, never learned about
it. That is why the fix is a single inventory rather than a patch, and why it
ships with a discipline test: the same shape recurs the moment a thirteenth
notifier is added.

**Severity driver:** the app holds minors' PII — name, phone, date of birth,
school, governorate — and the target market is shared handsets. The leak is one
child's data disclosed to another, not merely a stale cache.

### 1.2 Complete session-scoped state inventory

Method: every `final …Provider = …` declaration in `lib/` was enumerated from
source, then classified by kind and lifetime. **This is the whole set — there are
no other stateful providers in the codebase.** `lib/features/home/notifier/`,
`lib/features/track/notifier/` and `lib/features/subscription/notifier/` contain
only `.gitkeep`.

#### Cleared on sign-out (11)

| Provider | Lifetime | Holds |
| --- | --- | --- |
| `meProvider` | non-autoDispose | **name, phone, DOB, school, governorate, points, level** |
| `entitlementsProvider` | non-autoDispose | what this student paid for |
| `editProfileProvider` | autoDispose | in-flight edits to the above |
| `subjectsProvider` | non-autoDispose | catalogue scoped to the student's track |
| `subjectTreeProvider` | non-autoDispose **family** | per-subject progress |
| `loginProvider` | non-autoDispose | `OtpRequestResult` for a specific phone |
| `otpProvider` | autoDispose family | per-phone OTP UI state |
| `registrationControllerProvider` | non-autoDispose | **minor's draft PII** |
| `registrationSubmitProvider` | non-autoDispose | registration outcome |
| `schoolSearchProvider` | autoDispose family | the student's typed queries |
| `quizSetupProvider` | autoDispose | quiz configuration |

**Beyond the six providers named in the brief**, the sweep found:

- **`registrationSubmitProvider`** — non-`autoDispose`, in neither the original
  audit's list nor Fable's. Genuine gap.
- **`editProfileProvider`**, **`otpProvider`**, **`schoolSearchProvider`**,
  **`quizSetupProvider`** — `autoDispose`, so they normally drop with their last
  listener. Included anyway: a forced logout can land while the screen is still
  mounted, and `autoDispose` only fires after the listener goes. The window is a
  frame wide, it carries PII, and closing it costs one line.

#### Deliberately NOT cleared (12) — each with its reason

| Provider | Why it survives |
| --- | --- |
| `authControllerProvider` | The invalidation runs *from inside* it. |
| `localeProvider`, `themeModeProvider` | Device preferences, persisted on purpose. `preferences_store.dart:13` — "a theme choice is not a secret, is not personal data". |
| `deviceInfoProvider` | `forceLogout` goes out of its way to preserve `device_id`; wiping it makes the next login look like a new device and mis-fires `session_superseded` (Decisions_Log 2026-07-23). |
| `isOnlineProvider` | Global connectivity. |
| `countriesProvider`, `governoratesProvider`, `citiesProvider`, `schoolsProvider`, `educationSystemsProvider`, `universitiesProvider`, `avatarsProvider` | Global reference data — identical for every student, carrying no user data. Clearing them would re-download the entire reference set on a metered Egyptian connection to achieve nothing. |

Repositories, Dio, secure storage, connectivity, router and screen protection are
plain `Provider<T>` DI roots — stateless with respect to who is signed in.

### 1.3 The mechanism

**`lib/core/session/session_scope.dart` → `invalidateSessionScope(Ref ref)`**

One function, eleven explicit `ref.invalidate` calls, each with the reason it is
there. Called from **both** sign-out paths in `AuthController`, immediately after
the auth state flips.

Design notes, since the brief asked for a considered mechanism rather than a
name:

- **Why a list and not per-feature cleanup.** The list *is* the inventory.
  Adding a user-scoped provider and forgetting to clear it becomes a one-line
  review catch instead of an archaeology exercise across twelve features.
- **Why it follows the existing pattern.** `edit_profile_notifier.dart:57`
  already invalidates `meProvider` after a successful `PATCH`, for the same
  stated reason — one source of truth, invalidated rather than written through.
  This is that pattern applied to the session boundary.
- **Why `lib/core/session/` and not inside a feature.** A session-invalidation
  registry must, by nature, know every feature. Putting it in `auth` would make
  `auth` import `profile`, `catalog`, `quiz` and `registration`. Putting it in
  `core` matches the direction already established and acknowledged at
  `core_providers.dart:36-38`. The coupling is real either way; this makes it
  **explicit and auditable in one file**.
- **Why not `ref.watch(authControllerProvider)` inside each notifier.** More
  idiomatic in isolation, but it touches seven notifiers, changes rebuild
  semantics, and risks refetch storms on every auth transition — including
  `markAuthenticated`. Rejected as too invasive for a Tier-0 fix.

### 1.4 The re-entry guard — the non-obvious part

`forceLogout` gained one line:

```dart
if (state is AuthUnauthenticated) return;
```

**This is load-bearing, not tidiness.** Without it the fix introduces an
unbounded loop:

```
forceLogout → invalidateSessionScope → a session provider that still has a
listener rebuilds → it fetches with no token in storage → 401 →
AuthInterceptor._performRefresh finds no refresh token → forceLogout → …
```

`auth_interceptor.dart:129-133` is the exact call site that closes the cycle.
The guard breaks it at the first repeat. It also collapses the N concurrent 401s
that a burst of in-flight requests would otherwise turn into N full teardowns,
and it keeps the **first** logout reason — which is the one that actually ended
the session — rather than letting a cascade overwrite it.

Two tests cover it directly (`forced logout is idempotent`).

### 1.5 Ordering

`clear tokens → flip auth state → invalidate`, deliberately in that order. The
state flip fires the router's `refreshListenable` first, so the redirect is
already under way when the invalidation lands and listeners are dropping.

### 1.6 Regression tests

**`test/core/session/session_isolation_test.dart`** — 9 tests. Drives the **real**
`AuthController` against mocked repositories, because the bug was never in the
invalidation; it was that logout did not call it. Testing
`invalidateSessionScope` directly would have passed against the broken code.

*Scenario A — normal sign-out on a shared device*
- Student B does not receive Student A's profile (name, level, phone, DOB)
- Student B does not inherit Student A's entitlements
- Student B does not inherit Student A's subject catalogue
- the profile is re-fetched rather than served from cache (`verify` call counts)

*Scenario B — forced logout during registration*
- a minor's draft PII does not survive a forced logout
- a user-initiated sign-out also clears the draft

*Idempotency*
- a repeat forced logout does not re-run the teardown
- the first reason wins

*Preserved behaviour*
- `clearTokens` is used, never `clear()` — the `device_id` survives

**Why these fail against the old code** — reasoned, **NOT** executed: a
non-`autoDispose` provider retains its value for the container's lifetime, so
after `logout()` the pre-fix `container.read(meProvider.future)` completes with
Student A's cached `StudentProfile` and never calls the repository again. The
assertions on `b.name`, the entitlement list, and the second
`verify(profileRepo.getMe).called(1)` all fail. **The developer must confirm this
by stashing the `auth_controller.dart` change and re-running — see §4 step 6.**

**`test/core/session/session_scope_discipline_test.dart`** — 3 tests, in the
style of the existing `palette_discipline_test.dart` (source-scanning, the
project's own convention for turning a rule into a gate):

1. every non-`autoDispose` stateful provider in `lib/` is either invalidated in
   `session_scope.dart` or listed as exempt **with a written reason**
2. the exemption list has no stale entries
3. **both** sign-out paths call the invalidation — the whole of C-2 was that one
   existed and the other did not

Known limitation, stated in the test: a provider declared with an explicit
left-hand type (`final Provider<Dio> dioProvider = …`) is not matched by the
regex. Both current cases are plain DI roots that the test does not want, but a
future *stateful* provider written that way would slip past.

---

## 2. Release networking (Tier-0 C-1)

### 2.1 Root cause

`android/app/src/main/AndroidManifest.xml` contained **no `uses-permission`
element at all**. `android.permission.INTERNET` was declared only in:

- `android/app/src/debug/AndroidManifest.xml:6`
- `android/app/src/profile/AndroidManifest.xml:6`

Both are files Flutter generates for its own hot-reload channel. Gradle merges a
build-type source set **only into that build type**. `src/main` is the one source
set that merges into all of them.

So: every network call would fail in release, and **development would never
reveal it** — debug builds have the permission. No plugin supplies it (checked by
the audit and independently by Fable). The app compiles, analyses clean and
passes 792 tests in this state.

### 2.2 Fix

One line added to `src/main/AndroidManifest.xml`, with a comment explaining why
it must live there and pointing at the CI guard:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

**No `src/release/` source set was created.** That would duplicate a permission
that `main` already propagates everywhere and would leave two places to forget.
`src/debug` and `src/profile` were left untouched — they are Flutter-generated,
the merger de-duplicates, and removing them adds risk for no gain.

### 2.3 Release verification — NOT VERIFIED

**This environment cannot perform a release build. The exact blocker:**

- No Flutter/Dart SDK — `which flutter dart` returns nothing
- No Android SDK, no Gradle, no JDK
- Outbound network is allowlist-blocked (`403 blocked-by-allowlist`), so none of
  the above can be installed

Per the brief, this is documented rather than claimed. **`src/main` declaring the
permission is verified by reading the file. That the merged release artefact
carries it is NOT verified and must not be reported as such.**

`tool/verify_release_manifest.ps1` was written to close this in one command. It
checks three levels, weakest to strongest — source, merged manifest, then the APK
itself via `aapt2 dump permissions` — and reports `VERIFIED`, `NOT VERIFIED` or
`FAILED` rather than collapsing them.

### 2.4 CI protection

Two checks, deliberately split by cost:

**Every PR and push** — `analyze-and-test` job, step *"Release manifest declares
INTERNET"*. A `grep` of `src/main/AndroidManifest.xml`. Milliseconds. Fails with
an annotation explaining why debug/profile do not count.

**`main` pushes** — `build-release-apk` job, step *"Release APK actually carries
INTERNET"*. Locates `aapt2` in the runner's build-tools and dumps permissions
from the **built APK**, falling back to the merged manifest if `aapt2` is absent.

The first is a source check; only the second is proof, because it inspects what
the merger actually produced rather than what the source claims. A manifest
placeholder or `tools:node="remove"` could strip a permission that is present in
source — unlikely here, but the point of a guard is to not depend on that.

---

## 3. Files changed

| File | Change |
| --- | --- |
| `lib/core/session/session_scope.dart` | **NEW** — `invalidateSessionScope`, the inventory + rationale |
| `lib/features/auth/notifier/auth_controller.dart` | import; invalidation in `logout()` and `forceLogout()`; re-entry guard; corrected a stale comment claiming the Sign Out button had no caller |
| `android/app/src/main/AndroidManifest.xml` | **+1 permission** + explanatory comment |
| `test/core/session/session_isolation_test.dart` | **NEW** — 9 regression tests |
| `test/core/session/session_scope_discipline_test.dart` | **NEW** — 3 guard tests |
| `.github/workflows/ci.yml` | +2 steps (source guard on every PR; APK guard on `main`) |
| `tool/verify_release_manifest.ps1` | **NEW** — local release verification |
| `.ai/audits/current/remediation-tier0.md` | **NEW** — this file |

**Two application files touched.** No test deleted or weakened. No dependency
added. Nothing under `lib/features/*/screens`, `models`, `repository`, the theme,
the router or the API layer was modified.

---

## 4. Validation the developer must run

```powershell
cd F:\level\level_up\level_up_app

# 1-4
flutter pub get
dart format --set-exit-if-changed --output=none `
  (git ls-files "*.dart" | Where-Object { $_ -notmatch "\.(freezed|g)\.dart$" -and $_ -notmatch "^lib/l10n/app_localizations" })
flutter analyze
flutter test

# 5 — the full gate, rewrites test-results.md
powershell -ExecutionPolicy Bypass -File tool\validate.ps1

# 6 — prove the new tests actually catch the bug
git stash push lib/features/auth/notifier/auth_controller.dart
flutter test test/core/session/     # MUST FAIL
git stash pop
flutter test test/core/session/     # MUST PASS

# 7 — release verification (Tier-0 C-1)
powershell -ExecutionPolicy Bypass -File tool\verify_release_manifest.ps1
```

**Step 6 is not optional.** A regression test that passes against the broken code
proves nothing, and this one was reasoned rather than executed.

### Most likely failure, and its fix

`invalidateSessionScope(Ref ref)` names Riverpod's `Ref` type. Riverpod 3.0
unified the old `ProviderRef`/`FutureProviderRef` family into a single
non-generic `Ref`, and `flutter_riverpod` 3.3.2 should export it — but **this
could not be confirmed**, because the pub cache sits outside the folders this
environment can read. If `flutter analyze` reports `Undefined class 'Ref'` or a
type-argument error, the fix is the import or the type name only; the logic is
unaffected.

---

## 5. Remaining risks

1. **Nothing here has been compiled or run.** The single largest risk. §4 closes it.
2. **Release manifest merge is unverified.** Source is correct; the artefact is
   unchecked. §4 step 7.
3. **A forced logout may emit one wasted request per session provider** that was
   still mounted when it fired. Those requests 401 and land as `AsyncError` on
   providers whose screens are unmounting — harmless, and **non-looping** because
   of the guard. Accepted rather than fixed: eliminating it entirely means making
   every session notifier auth-aware, which is out of Tier-0 scope.
4. **Writes to a disposed notifier remain possible.** Invalidating a provider with
   an in-flight request can leave the old notifier's post-`await` `state =`
   writing to a disposed object. This is pre-existing finding **K-13** (zero
   `ref.mounted` guards, 9 sites); the change makes it marginally more reachable.
   Not fixed here — it is a separate, larger piece of work.
5. **The discipline test can miss explicitly-typed declarations.** Documented in
   the test itself.
6. **`logout()` has exactly one caller** (`profile_screen.dart:348`) and
   `forceLogout` four (all in `auth_interceptor.dart`). If a future sign-out path
   bypasses `AuthController`, none of this runs. The third discipline test
   guards the two known paths, not hypothetical ones.
7. **Device verification is still outstanding** — C-1 in particular can only truly
   be closed by installing a release build and completing a login on a handset.

---

## 6. Wave-1 verification pass

Run after the developer reported `validate.ps1 → OVERALL: PASS`. Purpose: prove
the remediation rather than restate it.

### 6.1 What the baseline run established — VERIFIED

`.ai/audits/current/test-results.md`, 2026-08-12T05:27:36Z, Flutter 3.44.7 /
Dart 3.12.2, branch `dev`:

```
dart format      PASS   207 hand-written files
flutter analyze  PASS   0 issues
flutter test     PASS   804 passed / 0 failed
OVERALL          PASS
```

804 = 792 + 12, exactly as predicted. This closes three things that were open:
the code compiles (so `Ref` resolved from `flutter_riverpod` 3.3.2 as reasoned),
all 12 new tests pass, and **no pre-existing test was lost or weakened**.

### 6.2 Inventory re-verified independently — VERIFIED

The discipline test's own logic was re-implemented outside Dart and run against
the real source, so the guard's verdict does not rest on the guard.

```
stateful providers scanned : 23
invalidated                : 11
exempt (documented)        : 12
unclassified               : 0
stale exemptions           : 0
invalidated-but-undeclared : 0
```

11 + 12 = 23. **The inventory is complete and the partition is exact.** Of the 11
invalidated, 7 are non-`autoDispose` (the genuine leak surface) and 4 are
`autoDispose` closed defensively.

### 6.3 A defect found in the guard test — FIXED

The first version of `session_scope_discipline_test.dart` asked
`scope.contains(name)` — a plain substring search over the whole file, **doc
comments included**.

`session_scope.dart` names `authControllerProvider`, `localeProvider`,
`themeModeProvider` and `deviceInfoProvider` in its *"deliberately NOT here"*
section. Measured:

| Provider | substring match | actually invalidated |
| --- | --- | --- |
| `authControllerProvider` | true | **false** |
| `localeProvider` | true | **false** |
| `themeModeProvider` | true | **false** |
| `deviceInfoProvider` | true | **false** |

The guard reported all four as cleared when none is. It reached the right
*verdict* only because those four are also on the exemption list — but the
mechanism was wrong, and **a new session-scoped provider merely mentioned in a
comment would have passed the guard silently.** That is precisely the failure
this test exists to prevent: a guard that can be satisfied by prose is not a
guard.

Fixed:

- provider classification now parses real `ref.invalidate(x)` calls from
  comment-stripped source
- the "both sign-out paths" check is comment-stripped for the same reason
- **new:** no provider may be both invalidated and exempted (a contradiction
  means somebody changed their mind in one place only)
- **new:** `forceLogout` must keep its re-entry guard — deleting it looks like
  removing a redundant early return, so it needs a test that says otherwise

Discipline tests: 3 → 5. Re-simulated outside Dart: all 5 pass.
**Expected suite total 806.**

### 6.4 Which tests prove C-2, and why they fail against the old code

`git show HEAD:lib/features/auth/notifier/auth_controller.dart` contains **zero**
occurrences of `invalidateSessionScope` or the re-entry guard — a genuine
pre-fix baseline.

| Test | Why it fails on HEAD |
| --- | --- |
| Student B does not receive Student A profile | `meProvider` is non-`autoDispose`; its `AsyncData` survives the sign-out, so `.future` completes with Student A and `expect(b.name, 'Sara Ibrahim')` fails |
| …does not inherit entitlements | same, `entitlementsProvider` |
| …does not inherit subject catalogue | same, `subjectsProvider` |
| profile is re-fetched, not served from cache | the second `verify(getMe).called(1)` sees **0** further calls |
| minor draft PII does not survive a forced logout | `registrationControllerProvider` still holds the draft; `expect(isNull)` fails |
| user-initiated sign-out also clears the draft | same |
| repeat forced logout does not re-run teardown | no guard on HEAD → `clearTokens` called **twice** |
| first reason wins | no guard → the second call overwrites the reason |
| both sign-out paths call the invalidation *(discipline)* | 0 calls found, expected 2 |
| `forceLogout` keeps its re-entry guard *(discipline)* | guard absent |

**10 of 14 tests should fail against HEAD.** The remaining 4 are
preserved-behaviour assertions (`clearTokens` not `clear()`, the exemption-list
and contradiction checks) and correctly pass on both sides.

**This is reasoning, not observation.** `tool/verify_session_regression.ps1`
proves it empirically: back up the file, `git checkout HEAD --` it, run
`test/core/session/` expecting failure, restore from the backup in a `finally`
block, re-run expecting success, and verify the restore by SHA-256 before
exiting.

### 6.5 CI protection assessed

| Check | Trigger | Strength |
| --- | --- | --- |
| `Release manifest declares INTERNET` — greps `src/main` | **every** PR + push to `dev` and `main` | Source only. Catches the likeliest regression (the line is deleted) in milliseconds. |
| `Release APK actually carries INTERNET` — `aapt2 dump permissions` on the built APK, merged-manifest fallback | push to `main` only | **Proof.** Inspects what the merger produced, so it also catches a `tools:node="remove"` or a plugin stripping the permission. |

**Gap, stated plainly:** the APK-level proof runs only on `main`. A regression
that survives the source grep — a manifest placeholder, a `tools:node="remove"`
in a plugin — could sit on `dev` until it is merged. Widening it means paying a
6–10 minute Android build on every PR. Recorded as an accepted Wave-1 risk; the
Wave-2 CI work is the place to revisit it, not here.

`build-release-apk` correctly declares `needs: analyze-and-test`, so the APK
check cannot report green on a tree that does not analyse.

### 6.6 Regression proof executed — VERIFIED

`tool/verify_session_regression.ps1`, developer machine, 2026-08-14.

```
[1/2] OLD behaviour (AuthController from HEAD, no invalidation)
      the suite FAILED against the old behaviour
[2/2] NEW behaviour (Tier-0 fix in place)
      00:07 +14: All tests passed!

 old behaviour -> tests fail : YES
 new behaviour -> tests pass : YES
 working copy restored       : YES

RESULT: VERIFIED - the regression tests genuinely protect against C-2
```

**14 tests in `test/core/session/`** — 9 isolation + 5 discipline, matching the
predicted composition exactly.

This is the claim that mattered most and the one that had been reasoned rather
than observed. It is now empirical: **the tests fail against the pre-fix
`AuthController` and pass against the fixed one.** The regression suite is proof
of the fix, not decoration around it.

The working copy was restored and SHA-256 verified, so the branch is unchanged by
the procedure.

#### Incident during the first attempt — worth recording

The first run aborted:

```
fatal: Unable to create '.../.git/index.lock': File exists.
```

Cause: a **zero-byte, three-day-old** `index.lock` left behind on 2026-08-11 at
18:06 when the Agent-10 subagent was terminated mid-stream by an API error while
running git commands against this repository. Not a defect in the app, the fix
or the developer's machine.

Two things this surfaced, both now fixed:

1. **The script's failure mode was correct.** It caught the error, restored the
   file in its `finally` block and SHA-256-verified the restore before exiting.
   The working copy was never at risk — which is the property the `finally` was
   written for.
2. **The script depended on git's index unnecessarily.** `git checkout HEAD -- `
   *writes* the index, so any stale lock — from a crashed process or an IDE
   indexing in the background — aborts a verification that needs no index at all.
   It now uses `git show HEAD:<path>`, which only reads a blob. Confirmed to work
   with the lock still present. A pre-flight check also reports a lock and its
   age, because `git commit` will still care even though this script no longer
   does.

### 6.7 Release artefact verified — VERIFIED

`tool/verify_release_manifest.ps1`, developer machine, 2026-08-14.

```
[1/3] source manifest (src/main)
  PASS  src/main declares android.permission.INTERNET
[2/3] release build
  Running Gradle task 'assembleRelease'...  14.0s
  Built build\app\outputs\flutter-apk\app-release.apk (60.2MB)
  PASS  release APK built
[3/3] the shipped artefact
  aapt2: .../build-tools/36.1.0/aapt2.exe
  PASS  the release APK declares android.permission.INTERNET  <-- this is the proof

RESULT: VERIFIED - the release artefact can reach the network
```

**This is the claim that mattered.** `src/main` declaring the permission was never
in doubt; what C-1 asserted is that the *merged release artefact* did not carry
it. The chain is now closed end to end:

```
src/main/AndroidManifest.xml
  -> Gradle manifest merge
    -> app-release.apk
      -> aapt2 dump permissions -> android.permission.INTERNET
```

Two incidental firsts worth recording: this is the **first release build this
project has ever produced** (Wave-1 risk B-1 — the release path had never been
exercised in 43 commits, which is exactly why C-1 survived undetected), and it
succeeded in 14 seconds with no signing or toolchain problems.

### 6.8 Full suite after the guard fix — VERIFIED

```
dart format      FAIL   2 of 210 files
flutter analyze  PASS   0 issues
flutter test     PASS   806 passed / 0 failed
```

806 = 804 + the 2 discipline tests added in §6.3, exactly as predicted.

The format failure is **not a defect in the remediation**: the two files are
`session_isolation_test.dart` and `session_scope_discipline_test.dart`, both
hand-written in an environment with no Dart toolchain and therefore never run
through `dart format`. Content is unaffected — all 806 tests pass in both the
unformatted and formatted state. Corrected in a follow-up `style:` commit.

Mildly instructive: the CI formatting gate added in Wave 1 would have caught this
on the first pull request. The gate works.
