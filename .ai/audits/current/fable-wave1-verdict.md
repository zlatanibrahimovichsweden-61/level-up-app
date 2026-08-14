# WAVE 1 INDEPENDENT FABLE RE-AUDIT

**Reviewer:** Fable (independent, adversarial) · 2026-08-14
**Repository state reviewed:** `dev` @ `e3651e6` + uncommitted working tree
(152 changed/added paths), release APK built 2026-08-14 22:06 +0300,
validation run finished 2026-08-14 19:12:27Z.
**Method:** no claim accepted from any report. Source read directly; the
release APK's **binary AXML manifest parsed by this reviewer's own parser**;
artifact hashes recomputed; file mtimes cross-checked against the validation
run; every arithmetic claim recounted.

---

## C-1 — Android Release Networking

### VERIFIED

**Evidence:**

1. **Correct source set.** `android/app/src/main/AndroidManifest.xml:19`
   declares `<uses-permission android:name="android.permission.INTERNET"/>`.
   `src/main` is the only source set that merges into every build type. The
   debug/profile declarations remain untouched, as they should.
2. **Release APK exists** — `build/app/outputs/flutter-apk/app-release.apk`,
   63,147,895 bytes, mtime 2026-08-14 22:06, i.e. **after** the manifest fix
   (2026-08-12 08:00). I recomputed its SHA-1 and it matches the build's
   sidecar (`2986ec1c…7557`) — the artifact on disk is the one the build
   produced.
3. **The actual APK carries the permission.** I did not rely on the
   developer's aapt2 output. I extracted `AndroidManifest.xml` from the APK
   and **parsed the binary AXML chunk structure directly** (string pool +
   element walk). The packaged manifest contains exactly three
   `uses-permission` elements:
   - `android.permission.INTERNET`
   - `android.permission.ACCESS_NETWORK_STATE` (from connectivity_plus)
   - `com.levelup.level_up_app.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (AndroidX standard)
   `android.permission.DUMP` also appears in the string pool — I chased it: it
   is only the **protection attribute on the androidx.profileinstaller
   receiver**, not a requested permission. No surprise permissions, nothing
   removed.
4. **No merger rule strips it.** The source manifest contains no `tools:`
   attributes at all; all four release merge stages
   (`merged_manifest/…/processReleaseMainManifest`, `merged_manifests`,
   `packaged_manifests`) contain `INTERNET`.
5. **CI protection exists and checks the final artifact.** Two layers in
   `ci.yml`: a millisecond grep of `src/main` on **every PR** (line ~125), and
   the `main`-only release job's "Release APK actually carries INTERNET" step,
   which runs `aapt2 dump permissions` **on the built APK** with a
   merged-manifest fallback. This is a genuine final-artifact check, not a
   source-level proxy.

**On the framing question asked:** the developer's line "VERIFIED — the
release artefact can reach the network" is **evidence of permission, not proof
of API communication**, and should be read that way. The permission removes
the one known certain blocker; end-to-end networking in release remains
unproven and *unprovable* today, because `AppConfig` base URLs are still
`TBD.example` and no backend exists. K-1's original "done when" (a release
build completes a login on a device) stays open until there is a server to log
into. That is a product dependency, not a defect in this fix.

---

## C-2 — Session Isolation

### VERIFIED

**Evidence:**

1. **`lib/core/session/session_scope.dart`** — `invalidateSessionScope(Ref)`
   makes exactly **11** `ref.invalidate` calls: `meProvider`,
   `entitlementsProvider`, `editProfileProvider`, `subjectsProvider`,
   `subjectTreeProvider` (family), `loginProvider`, `otpProvider` (family),
   `registrationControllerProvider`, `registrationSubmitProvider`,
   `schoolSearchProvider`, `quizSetupProvider`. This is a **superset of the
   six providers my Wave-0 audit enumerated**; the sweep additionally caught
   `registrationSubmitProvider`, which no prior audit had listed.
2. **Classification arithmetic verified:** 11 invalidated + 12 exempt = 23,
   matching the report exactly; the discipline test's scan leaves **0
   unclassified** and its stale-exemption test reports **0**.
3. **Exemptions are legitimate.** All 12 checked against source: seven
   reference providers are global catalogue data (identical for every
   student); `localeProvider`/`themeModeProvider` are device preferences
   persisted by documented design; `isOnlineProvider` is connectivity;
   `deviceInfoProvider` and the preserved `device_id` implement the
   Decisions_Log 2026-07-23 anti-`session_superseded` rule;
   `authControllerProvider` cannot invalidate itself mid-teardown.
   `QuizBloc` is correctly absent from the inventory: it is
   `BlocProvider`-scoped to the quiz route (`quiz_screen.dart:77-79`) and is
   closed when the router redirects on logout.
4. **Both paths invalidate.** `logout()` (line 84) and `forceLogout()`
   (line 71) each call `invalidateSessionScope(ref)`, both **after** the state
   flip, matching the documented ordering requirement.
5. **The re-entry guard exists** — `forceLogout` line 68:
   `if (state is AuthUnauthenticated) return;`. The loop it breaks
   (invalidate → still-listened provider rebuilds → tokenless 401 →
   interceptor → forceLogout) is real, and the guard halts it at the first
   repeat because the state flip precedes invalidation. Unbounded recursion is
   not possible in any interleaving I could construct: every re-entrant call
   after the flip early-returns, and invalidation itself is synchronous
   mark-dirty, not synchronous rebuild.

**Two LOW notes (hygiene, not defects):**

- **L-1 · The structural guard test can be satisfied without the guard.**
  `session_scope_discipline_test.dart:201` asserts
  `RegExp(r'if\s*\(state is AuthUnauthenticated\)')` matches somewhere in the
  file — and `clearReason()` (`auth_controller.dart:89`) contains the
  **identical expression**. Delete the forceLogout guard and this test still
  passes. It is covered behaviorally: the idempotency test
  (`clearTokens` verified `.called(1)` across two forceLogouts) fails without
  the guard. Defense-in-depth hole only. *Fix when convenient:* scope the
  regex to the `forceLogout` method body.
- **L-2 · The guard is check-then-act across an `await`.** Two *truly
  concurrent* `forceLogout` calls can both pass the guard before either flips
  state → double (finite, idempotent) teardown, and the **last** reason wins,
  contradicting the "FIRST reason wins" doc and test, which only cover
  *sequential* repeats. In practice the interceptor serialises refresh
  failure, so the window is theoretical. *Fix when convenient:* flip state
  before the `await`, or add a sync in-progress flag.

**On the comment-parsing defect specifically:** confirmed fixed. `code()`
strips `/* */` and `//` comments before any matching; invalidations are parsed
from actual `ref.invalidate(NAME)` call syntax
(`session_scope_discipline_test.dart:88-99`); and the test documents the
original defect honestly at lines 79-87 — including the admission that the old
version reached the right verdict by luck. The "both paths" test (line 172)
also strips comments before counting `invalidateSessionScope(` calls.

---

## Regression Test Integrity

### VERIFIED (design); execution evidence externally supplied and internally consistent

**Evidence:**

The tests drive the **real `AuthController`** through **real providers** in a
live `ProviderContainer`, mocking only repositories and storage — the
docstring's stated rationale ("the bug was never in the invalidation, it was
that logout did not call it") is correct and the design follows it.

Mapping each reported OLD-implementation failure to its detecting test:

| Reported OLD failure | Detecting test | Fails without the fix because |
| --- | --- | --- |
| profile survived sign-out | Scenario A / "Student B does not receive Student A profile" | non-`autoDispose` `meProvider` in a held container returns the cached A on the second `.future` read — deterministic Riverpod semantics |
| entitlements survived | Scenario A / entitlements test | same mechanism |
| subject catalogue survived | Scenario A / catalogue test | same mechanism |
| profile not re-fetched | "re-fetched, not served from cache" | `verify(getMe).called(1)` twice — a cache hit means the second `verify` finds zero new calls |
| registration draft PII survived | Scenario B ×2 (forced + user-initiated) | `registrationControllerProvider` read returns the non-null draft |
| idempotency/reason failed | "repeat forced logout" + "FIRST reason wins" | pre-fix `forceLogout` had no early return → `clearTokens` called twice and the second reason overwrites |
| discipline test detected missing invalidation | "both sign-out paths call the invalidation" | pre-fix file contains **0** `invalidateSessionScope(` calls; expected 2 |

**Could they pass accidentally while the bug exists?** No credible path found.
Passing Scenario A with the bug present would require `meProvider` to be
`autoDispose` or the container to be rebuilt mid-test — neither is the case
(single container held across the logout, created once per test). The
`settleAuth` helper even guards the classic false-pass (force-logout before
auth resolves would no-op) and asserts the session is live first. The one
structural test with a bypass is L-1 above, and its bypass is closed by the
behavioral tests.

**Caveat, stated plainly:** this environment has no Flutter toolchain, so I
could not execute the OLD→FAIL / NEW→PASS cycle myself. What I verified is
that the test design **guarantees** those outcomes given Riverpod semantics,
and that the developer's reported failure list corresponds test-for-test to
what the suite would emit.

---

## Full Validation

### PARTIALLY VERIFIED — repository state fully consistent with the run; execution itself not reproducible here

**Evidence:**

- `.ai/audits/current/test-results.md` (written 2026-08-14 22:12 local):
  format **PASS** (207 files) · analyze **PASS, 0 issues** · tests
  **806 passed / 0 failed** · **OVERALL: PASS**, on Flutter 3.44.7 /
  Dart 3.12.2, branch `dev`, commit `e3651e6`, tree honestly recorded as
  **not clean** (the uncommitted Wave work).
- **The run corresponds to the current tree:** no file under `lib/`, `test/`,
  `android/app/src/` or `pubspec.yaml` has an mtime after the run finished
  (checked with `find -newermt`). Nothing changed since the green run.
- Both session test files appear in the run's expanded output (15 references,
  all five discipline cases named).
- The toolchain block resolves the Wave-0 SDK ambiguity: the real version is
  **3.44.7** — `ci.yml`'s `FLUTTER_VERSION: "3.44.0"` floor should be raised
  to it before first CI run (already flagged in the file's own comments).
- Cosmetic: a `ci.yml` comment says "792-case suite"; the suite is now 806.
  Stale prose, not a gate error.

---

## Remaining Wave-1 Risks

1. **The entire verified state is uncommitted.** 152 changed/added paths sit
   in the working tree at `e3651e6`. The project's own git rules demand a
   stable checkpoint; until Wave 1 is committed, the verified fix is one
   errant `git checkout --` from vanishing, and no CI ever runs on it.
   **Commit Wave 1 promptly** (and note the pre-push hook would run the suite
   on that push — a free re-verification).
2. **Permission ≠ connectivity.** Release-build networking end-to-end remains
   unproven and blocked on the backend partner (`TBD.example`). K-1's
   device-login criterion stays open — track it, don't re-litigate it.
3. **L-1 / L-2** above — two LOW test-hygiene items on the guard. Behaviorally
   covered today; close them in the next test-touching wave.

## Deferred Findings (Waves 2–4 — not Wave-1 failures)

- Wave 3: K-12 rescope per Wave-0 finding E-1 (the `fromJson` hang is
  QuizBloc-only); `/subscription` and onboarding dead-ends (K-3/K-4);
  `memCacheWidth` (K-19); `hive_ce` removal (K-28).
- Wave 2: CI test step's directory enumeration (silently skips a future
  `test/<newdir>/`); `xargs` space-safety in `pre-commit`/`validate.sh`;
  raise `FLUTTER_VERSION` to 3.44.7; refresh the "792-case" comment.
- Wave 3/4: RTL goldens (K-26), font/contrast product decisions (K-5/6/10/11),
  correct "RTL coverage 0%" → "0 Arabic goldens" in the audit package (E-2),
  `changed-files.md` status block (E-3).

---

## FINAL WAVE-1 VERDICT

# APPROVED WITH WARNINGS

Both Tier-0 remediations are **real, correctly implemented, and independently
confirmed from the repository and the shipped artifact** — including a
first-principles parse of the release APK's binary manifest and a
line-by-line adversarial read of the guard tests, which fixed their known
comment-parsing defect properly. The regression suite genuinely detects the
original defect and cannot plausibly pass with it present.

The warnings are precisely three, none of which touches the correctness of
the fixes: the verified state is **uncommitted**; the suite execution is
**externally evidenced** (this environment cannot run Flutter — the evidence
is internally consistent and mtime-corroborated, but not reproduced here); and
two **LOW** guard-test hygiene gaps (L-1, L-2) should be closed in the next
wave that touches tests.

Wave 1 may be committed and Wave 2 may proceed.
