# WAVE 3 VERDICT

**Reviewer:** Fable (independent, adversarial) · 2026-08-15
**Tree audited:** `dev` @ `a5b8228` + 20 modified / 2 untracked paths
**Validation record:** run finished 2026-08-15T15:53:32Z — format PASS (214
files), analyze PASS (0 issues), **849 passed / 0 failed**. No file under
`lib/`, `test/`, `tool/`, `.github/`, `android/app/src/` or `pubspec.yaml` is
newer than that run, so the record describes this exact tree.
**Method:** every finding re-derived from source. All guard detectors
re-implemented independently in Python and run against the tree. The Figma file
was **queried directly** to test the 3D stop claim rather than accepting it.
Nothing was modified.

---

## Overall Verdict

# APPROVED WITH WARNINGS

Wave 3 is honest work. Its most valuable output is not code — it is two
**refusals**: 3D was stopped rather than faked, and 3C/others were rejected
rather than converted into busywork. Both refusals survived my attempt to break
them, and the 3D refusal I verified against the actual design file.

One genuine defect remains: **the 3A lifecycle fix is incomplete in the exact
notifier it was written for** (`OtpNotifier.verify`), and the new guard is
structurally incapable of detecting it. That is a MEDIUM, not a blocker — the
hazard window is narrow and the fix direction is small — but it means "3A
lifecycle: done" is not accurate. Two prior audit claims (mine included) also
turned out to be stated on inaccurate evidence.

---

## 3A Lifecycle

### Findings

Four `autoDispose` notifiers received a `_disposed` flag wired through
`ref.onDispose`, guarding post-`await` `state =` assignments.

### Independent verification

**Scope narrowing (9 → 4) is CORRECT.** I re-derived it: of the notifiers K-13
named, only `otpProvider`, `editProfileProvider`, `quizSetupProvider` and
`schoolSearchProvider` are `autoDispose`. The other six are container-lifetime
and cannot be disposed mid-`await`. Guarding them would have been cargo-cult,
and refusing to was right.

**Mechanism is sound.** `ref.onDispose(() => _disposed = true)` is used in all
four. In `SchoolSearchNotifier.build` the registration is deliberately placed
**before** the first `await`, so a dispose during the initial page load is
recorded — I verified that ordering; it is the kind of detail that is wrong more
often than right.

**Placement reasoning is correct where it was applied.** In
`OtpNotifier.verify` the guard sits *after* `writeTokens` and
`markAuthenticated()`, so a student who pops the screen mid-verify still ends up
authenticated. Guarding earlier would have produced a worse bug. This is the
right call and it is documented in-source.

**`EditProfileNotifier` self-correction is real.** The disposed branch returns
`!result.hasError` and touches nothing — no `ref.invalidate` on a dead `ref`.
The accepted cost (a stale `meProvider` until something refreshes it) is
recorded in-source rather than hidden.

### W3-1 · MEDIUM — the fix is incomplete in `OtpNotifier.verify`

**Evidence.** `verify()` has three sequential `await`s, and `ref` is used
*after* two of them with no guard in between:

```dart
final device = await ref.read(deviceInfoProvider.future);        // ref.read evaluated pre-suspension — safe
final result = await ref.read(authRepositoryProvider)            // line 110 — runs AFTER await #1 resumed
    .verifyOtp(...);
await ref.read(secureStorageProvider).writeTokens(...);          // line 115 — runs AFTER await #2 resumed
ref.read(authControllerProvider.notifier).markAuthenticated();   // line 123 — runs AFTER await #3 resumed
if (_disposed) return;                                           // guard starts only here
```

**Why it matters.** This is internally inconsistent with Wave 3's own stated
premise. `edit_profile_notifier.dart` says, in source: *"`ref` is dead too, and
invalidating through it would throw exactly like the state assignment does."*
If that premise is true, then the three `ref.read` calls above throw in exactly
the scenario 3A set out to fix — popping the OTP screen mid-verify, the
headline example in the implementation report. If the premise is false, then
`EditProfileNotifier` accepted a real staleness cost for no reason. **Both
cannot be true**, and one of the two is a defect either way.

Note the "these side effects must survive disposal" argument is self-defeating
at line 123: if `ref` is dead, `markAuthenticated()` cannot run at all, so the
student ends up authenticated-but-not-routed — the precise outcome the comment
says the placement prevents.

**Exact required fix (not applied).** Capture the dependencies *before* the
first `await`, so they survive disposal by not going through a dead `ref`:

```dart
final storage = ref.read(secureStorageProvider);
final auth    = ref.read(authControllerProvider.notifier);
final repo    = ref.read(authRepositoryProvider);
// ... awaits ...
await storage.writeTokens(...);
auth.markAuthenticated();
if (_disposed) return;
```

**Validation required.** Confirm `Ref.read`-after-dispose semantics in
`flutter_riverpod` 3.3.2 (one line in the pub cache the developer *does* have);
then a test that disposes the container mid-`verify` and asserts no unhandled
error and that tokens are still written.

### W3-2 · LOW — the new guard cannot detect W3-1

`autoDisposeNotifiersWithoutDisposalFlag` checks only that a file *declares*
`bool _disposed = false` and *wires* it in `onDispose`. It cannot see whether
any particular assignment is guarded, nor whether `ref` is used post-`await`.
I confirmed by simulation: a file with the flag and zero guards passes. The
detector's own docstring states this limitation honestly ("asserts the
*mechanism* exists, not that every assignment is guarded"), so it is not
dishonest — but it means 3A's regression coverage is weaker than "guarded."

### W3-3 · LOW — no behavioural test exists for any of the four fixes

Deliberate and explained (a dispose-mid-`await` race written without a
toolchain would likely be flaky or pass for the wrong reason). I accept the
reasoning; it remains a coverage gap, not a covered behaviour. The four fixes
are currently protected by a structural check only.

### Regressions

None. No authentication or business side effect was moved behind a guard: I
traced `writeTokens` and `markAuthenticated` (both still unconditional), the
quiz `create` server call, and the school-search cursor update — all preserved.
`_nextCursor` is assigned before the guard in `loadMore`, which is correct.

### Verdict — **PARTIALLY VERIFIED.** Correct scope, correct mechanism, correct placement philosophy; incomplete execution in the flagship case (W3-1).

---

## 3B Localization

### Findings

Two genuine leaks fixed; ratchet lowered 7 → 5.

### Independent verification

I re-ran the detector myself. **Exactly 5 `Text('literal')` sites remain**, and
I inspected every one:

| Site | Content | Assessment |
| --- | --- | --- |
| `login_screen.dart:340` | `Text('🇪🇬')` | Untranslatable — flag glyph |
| `login_screen.dart:429` | `Text('${l10n.legalPrefix} ')` | Punctuation on a localized half |
| `login_screen.dart:431` | `Text('، ')` | Arabic comma joiner |
| `login_screen.dart:433` | `Text(' ${l10n.legalAnd} ')` | Punctuation on a localized half |
| `signup_identity_screen.dart:335` | `Text('🇪🇬')` | Untranslatable — flag glyph |

**Zero genuine user-facing leaks remain.** The two fixes are real, not
cosmetic: `state_widget.dart:85` now reads
`Text(AppLocalizations.of(context).retry)` and `app_router.dart:374` renders
`AppLocalizations.of(context).comingSoon`.

**No fake fix.** Nothing was moved into a constant to dodge the regex — both
sites call `AppLocalizations`. **No invented translation:** both keys pre-existed
in both ARBs with correct Arabic (`إعادة المحاولة`, `قريبًا`), which I read
directly from the files. **ARB parity holds: 246 keys each, zero drift in both
directions**, by independent JSON parse.

**The ratchet lowering is legitimate**, not an accommodation: the count fell
because the violations were removed, and the two now-clean files were correctly
dropped from the allowlist — which *tightens* the guard, since either file
reintroducing a literal now fails the "no NEW file" test.

One judgement worth recording: `_Placeholder`'s **app-bar title** remains the
raw route name (`'Subscription'`). Classified in-source as a developer label
for an unbuilt route, with the body being the line a student reads. I accept
that, but it is an interim state that disappears only when the product decision
below is taken.

### Verdict — **VERIFIED.**

---

## 3C Architecture

### Confirmed / rejected findings

**The rejection's conclusion is correct; its stated evidence is not.**

The implementation report claims `ScreenState` is *"referenced in exactly three
places"* — its definition, two doc comments, and `state_widget.dart` — and
that **"No screen switches on it."**

The second claim is **true and I verified it**: `state_widget.dart` is the only
place that *switches* on `ScreenState`, so its self-description is accurate and
no refactor is warranted there. Rejecting the "4 parallel implementations"
finding as being about a different type (`AsyncValue`) is also correct.

The first claim is **false**. `ScreenState` is referenced in at least five code
locations, including two **AsyncValue → ScreenState bridges** that the report's
scan missed:

- `lib/features/catalog/widgets/catalog_states.dart:42` —
  `value.when<ScreenState<T>>(data/loading/error → Empty/Loaded/Offline/Error)`
- `lib/features/profile/screens/profile_screen.dart:103` —
  `profileScreenState(AsyncValue<StudentProfile>)`, same shape, consumed also by
  `edit_profile_screen.dart:73`
- `lib/features/home/screens/home_screen.dart:51` — handles `AsyncValue`
  directly via `.when`, bypassing `ScreenState` entirely

So genuine, mild duplication **does** exist (two near-identical bridges plus one
bypass). It is correctly classified as a judgement call rather than a defect —
the two bridges differ in their empty-state and 403-scope handling, so merging
them is not free — but the audit trail should say "two bridges exist and
consolidating them is optional," not "no screen references it."

**No new architectural inconsistency was introduced by Wave 3.** The four
lifecycle edits follow one identical pattern; no new abstraction, no new
state-management approach, no layering violation.

### Verdict — **PARTIALLY VERIFIED.** Right conclusion, inaccurate supporting evidence; correct the record rather than the code.

---

## 3D Typography

### Design verification — I queried Figma directly

This is the load-bearing claim of Wave 3, so I did not accept it. Using the
Figma MCP against file `P6044i0giD9TmdQ7C2AmLq`:

| Node | Typography variables returned |
| --- | --- |
| Login `82:819` | `Regular/None/Medium` → `Inter Medium 16/16/0` — **and nothing else** |
| Home `337:5303` | `Regular/None/Medium` → identical |

**The claim is CONFIRMED.** The file exposes exactly **one** text style, it is
a kit default (Inter Medium 16, returned on Login alongside the
`Countries/Africa/EG - Egypt/*` flag-component colours), and it is identical
across two unrelated screens. A design system with a semantic scale would return
`Display/…`, `Headline/…`, `Body/…` here. **There is no type scale to migrate
to.** Opus's stop rests on a fact, not an assumption.

### TextTheme verification

`grep textTheme lib/` → **0**. `TextTheme` does not appear in
`app_theme.dart`. No semantic styles exist. **Nothing was migrated.**

### Remaining inline values

**153**, across **17 distinct sizes** — I recomputed the full distribution and it
matches the report exactly: 18.0×33, 14.0×31, 22.0×23, 16.0×20, 20.0×12, then a
long tail including the anomalous `13.145`. Four sizes carry ~70% of uses.

### Light / dark / RTL verification

**Not applicable — and that is the correct answer, not an evasion.** No visual
change was made, so there is nothing to verify in either canvas or either
direction. I confirmed no theme file was touched (`app_theme.dart`,
`app_colors.dart` unmodified) and the palette guard still passes with 0
violations.

### The ratchet

**Still 153, unchanged.** This is the single most important integrity signal in
Wave 3: the easy path was to migrate a few sites, lower the number, and claim
progress. The baseline in `project_rules_test.dart:160` is untouched, and it
still prevents any new screen from making it worse while the design question is
open. I attempted to find a quiet reduction and there is none.

### Verdict — **VERIFIED AS CORRECTLY STOPPED.** Not "complete" — the work is genuinely outstanding, and the reason is a real, externally-confirmed design gap rather than an engineering excuse. **The framing in the audit request ("this is the newly completed portion") does not match the repository: 3D was not implemented.**

---

## 3E UI / Cache / Storage

| Finding | Classification | Evidence |
| --- | --- | --- |
| `memCacheWidth` — 4 of 5 sites | **CONFIRMED, FIXED** | `home_header.dart:172`, `profile_header_card.dart:132`, `avatar_sheets.dart:333`, `edit_profile_screen.dart:545` all set it, each scaled by `MediaQuery.devicePixelRatioOf(context)` rather than a hardcoded 2×/3× guess — correct, since the cap then tracks the real display |
| `mcq_renderer.dart` — 5th site | **INTENTIONAL, correctly refused** | Question artwork a student must read, at screen-dependent width. Downsampling educational content to save heap is a legibility trade nothing in the repo justifies. Refusing a blanket "fix all 5" is the right engineering call |
| `hive_ce` × 3 packages | **CONFIRMED, FIXED** | Removed from `pubspec.yaml` with in-place comments recording why; `pubspec.lock` regenerated and modified. Resolver dropped 5 packages (3 declared + 2 transitives), which independently proves nothing depended on them — had any code used Hive, resolution would have failed rather than pruned |
| `/subscription` "dead end" | **PARTIALLY REJECTED + PRODUCT DECISION** | Verified: reachable from `limit_sheet.dart` via `context.push`, so Back works — not a trap. Body copy is now localized. The real choice (disable the entry point as Profile's was, or build the screen) is a revenue-path product call and is correctly left open, not silently invented |
| Hardcoded colours | **FALSE POSITIVE, correctly rejected** | 0 violations; palette guard valid and passing. No mass refactor performed |

### Verdict — **VERIFIED.**

---

## Wave 1 Regression Check

**INTACT.**

- `invalidateSessionScope` still makes **11** `ref.invalidate` calls — the same
  11 I enumerated in the Wave-1 audit; none removed.
- `auth_controller.dart` still calls it **twice** (`logout` + `forceLogout`).
- The re-entry guard `if (state is AuthUnauthenticated) return;` is present at
  line 68.
- `android/app/src/main/AndroidManifest.xml` still declares
  `android.permission.INTERNET`.
- Both session test files still exist and are unmodified by Wave 3.

## Wave 2 Regression Check

**INTACT, and two of my Wave-2 findings were actually fixed.**

- CI still runs `flutter test` with **no path argument**, both tag-selected
  invocations present; `aapt2` APK inspection retained (7 references).
- `.flutter-version` still `3.44.7`; no hardcoded version reintroduced.
- All four guard files present; **no baseline artificially lowered**
  (fontSize 153 unchanged; the 7 → 5 copy change is backed by real remediation
  I verified site-by-site).
- **W2-2 fixed:** `tool/validate.sh` now uses `git ls-files -z` → `grep -zZv` →
  `xargs -0 -r … --`, and a **new guard** in `workflow_test.dart` asserts no
  bare `xargs` survives in the canonical script — the gap I reported is now
  mechanized, not just patched.
- **W2-1 fixed:** `verify_guards.ps1` now runs each probe with `--plain-name`
  so only the test under proof executes, making the exit code unambiguous, plus
  a clean-tree pre-check that fails loudly if the name matches nothing. This
  correctly replaces the "suite went red AND the name appeared somewhere"
  criterion I rejected. Sound design — though, consistent with my standing
  position, it remains **unexecuted evidence** until run.

## Test Integrity

- **849 = 848 + 1**, and the one new test is the 3A structural guard. 3B and 3E
  added **no** tests, and the report says so plainly rather than implying
  coverage. Static case count (817) is consistent with 849 reported once
  loop-generated cases are allowed for.
- **No test was deleted, skipped or weakened.** I diffed every touched test
  file: the only assertions that changed are the copy baseline (7 → 5, a
  *tightening*) and the removal of two files from the allowlist (also a
  tightening).
- **Guards are not satisfiable by comments** — the new detector calls
  `stripComments` first, consistent with the Wave-2 architecture.
- **A test that can pass against broken code:** yes, one —
  `autoDisposeNotifiersWithoutDisposalFlag` (W3-2). It passes on a file that has
  the flag and guards nothing. Honestly documented, but it is the weakest guard
  in the suite.
- **Fixtures reproduce the real defect:** for the guards, yes. For the 3A
  *behaviour*, no fixture exists at all (W3-3).

---

## Critical Findings

**None.**

## High Findings

**None.**

## Medium Findings

- **W3-1** — `OtpNotifier.verify` uses `ref` after `await` at three sites with
  no disposal guard, contradicting the premise Wave 3 relies on elsewhere. The
  flagship 3A scenario is not fully fixed. Fix + validation specified above.

## Low Findings

- **W3-2** — the 3A guard proves the mechanism exists, not that assignments are
  guarded; it cannot catch W3-1.
- **W3-3** — no behavioural test for any of the four lifecycle fixes
  (deliberate, reasoned, still a gap).
- **W3-4** — 3C's rejection is supported by an inaccurate scan ("referenced in
  exactly three places"); two `AsyncValue → ScreenState` bridges exist
  (`catalog_states.dart:42`, `profile_screen.dart:103`) plus one bypass
  (`home_screen.dart:51`). Correct the record; the no-refactor conclusion stands.
- **W3-5** — `_Placeholder`'s app-bar title remains unlocalized English by
  design; acceptable only while the route is unbuilt.
- **W3-6** — carried from Wave 2 and still true: `ci.yml:127` says "792-case",
  `ci.yml:52` says "806", `PROJECT_GUIDE.md:96` says "~730". The suite is 849.

## False Positives

Correctly rejected, and they should **stay** rejected:

- Hardcoded colours — 0 violations; the palette guard is valid.
- "4 parallel `ScreenState` implementations" — conflated `ScreenState` with
  `AsyncValue`; no screen switches on `ScreenState`.
- `/subscription` as a *trapped* dead-end — `context.push` preserves Back.
- K-13's "9 sites" — only 4 are `autoDispose` and can hit the hazard.
- `mcq_renderer` `memCacheWidth` — refusing to downsample question artwork is
  correct.

## Deferred / Product Decisions

Not defects; do not let a later wave silently "fix" these:

1. **3D typography** — blocked on design input. Needs: the set of semantic
   roles; size→role for 18/14/22/16 (~107 of 153 sites); a ruling on the long
   tail (44/36/32/28/24/19/15); a decision on `13.145` in
   `ai_explanation_panel.dart`; and weight pairing (`w600`×45 vs `bold`×23).
2. **`/subscription` entry point** — disable it (as Profile's was) or build the
   screen. Revenue-path product call.
3. **`ref.mounted` instead of the flag** — mechanical, once the API is
   confirmed available in 3.3.2.
4. **`AsyncValue → ScreenState` bridge consolidation** — optional.
5. **Behavioural race tests for 3A** — needs a toolchain-backed author.
6. Wave-4 items unchanged: Arabic goldens/RTL coverage, contrast and font
   product decisions, `custom_lint`/`riverpod_lint`.

---

## Required Actions Before Wave 4

1. **Fix W3-1** — hoist the three `ref.read`s in `OtpNotifier.verify` above the
   first `await`. First settle `Ref`-after-dispose semantics in
   `flutter_riverpod` 3.3.2 from the local pub cache; whichever way it lands,
   reconcile the `EditProfileNotifier` comment with it so the codebase states
   one premise, not two.
2. **Commit Wave 3.** 20 modified files sit uncommitted, including the
   regenerated `pubspec.lock` that must land with `pubspec.yaml`.
3. **Get one real GitHub Actions run** — still zero executions. This is now the
   longest-standing unverified claim in the project.
4. **Run `tool/verify_guards.ps1`** once, to exercise the rewritten harness and
   convert W2-1's fix from design into evidence.
5. **Correct the record** for W3-4 and W3-6 (3C scan, stale test counts).
6. **Take or explicitly defer the 3D design decision.** Until then the 153
   ratchet is the correct, honest signal — do not let it be lowered by anything
   other than real migration.

---

**Closing note.** The strongest signal in this wave is what was *not* done. A
code agent under pressure to close findings had two easy exits — invent a type
scale, or migrate a handful of sizes and lower the ratchet — and took neither,
then documented why in terms I was able to verify against the design file
itself. That is the behaviour to keep. The remaining defect is a narrow one, in
the direction of *not finishing* a real fix rather than *faking* one, which is
the right direction to err.
