# Wave 2 Remediation — CI, Hooks, Enforcement

> ## ⚠ VERIFICATION STATUS
>
> Written in an environment with **no Dart/Flutter toolchain**; every result
> below was produced on the developer's machine, or is marked NOT VERIFIED.
>
> | Claim | Status |
> | --- | --- |
> | Guard logic produces the right verdicts on the real repo | ✅ **VERIFIED** — independent Python re-implementation |
> | ARB false-positive found and fixed | ✅ **VERIFIED** — 246/246, 4 fixtures pass |
> | CI has no path argument to `flutter test` | ✅ **VERIFIED** — comment-stripped scan |
> | Goldens tagged, hooks NUL-safe, pin readable | ✅ **VERIFIED** — file inspection |
> | New Dart compiles / analyzer clean | ✅ **VERIFIED** — 0 issues, 2026-08-14 |
> | Full suite green with the new guards | ✅ **VERIFIED** — **847 passed / 0 failed** |
> | `dart format` clean on the new files | ✅ **VERIFIED** |
> | **Guards fail when their rule is broken** | ✅ **VERIFIED** — 6/6 fired, `verify_guards.ps1` |
> | Probe left the tree unmodified | ✅ **VERIFIED** — SHA-256 on both edited files |
> | CI actually runs green on GitHub | ❌ **NOT VERIFIED** — never pushed |

## Baseline

- **Wave-1 commit:** `4909856` (`style: dart format the session tests`)
- **Branch:** `dev`, clean at start
- Wave 1 verified: 806 passed / 0 failed, release APK carries INTERNET, session
  regression reproduced against old behaviour.

---

## CI

### Original problems

| # | Problem | Severity |
| --- | --- | --- |
| 1 | **`flutter test test/core test/dev test/features`** — a hand-maintained directory list. It **silently skipped `test/widget_test.dart`**, which sits at the root of `test/`, and would silently skip every future directory. Not hypothetical: one file was already being missed. | **HIGH** |
| 2 | `FLUTTER_VERSION: "3.44.0"` hardcoded in the workflow, while the validated local SDK is **3.44.7** — CI and the developer were on different SDKs by construction. | HIGH |
| 3 | The pin existed only in CI, so nothing connected it to the local toolchain. | MEDIUM |
| 4 | Goldens selected by path (`test/goldens`), so a golden added elsewhere would run on Linux and fail for platform reasons that look like a real regression. | LOW |

### Changes

- **Test discovery is now repository-driven.** `flutter test --exclude-tags golden`
  with **no path argument** walks the whole `test/` tree. Goldens are selected by
  **tag** (`--tags golden`) on the Windows job. A new test directory is picked up
  automatically; nothing to remember.
- **`.flutter-version`** at the repo root is the single source of truth, pinned
  to **3.44.7**. Every job reads it in a `shell: bash` step and feeds it to
  `subosito/flutter-action`; the workflow no longer carries its own copy. The
  cache keys derive from the same value.
- `.metadata`'s revision remains a **warning only**, never the pin — it records
  the revision the project was created with, which `flutter upgrade` does not
  rewrite.

### Enforcement behaviour

| Trigger | Runs |
| --- | --- |
| PR / push to `dev` or `main` | source-level INTERNET check → toolchain report → `pub get` → lockfile drift → l10n drift → format → analyze → **whole suite except goldens** |
| Push to `main` only | + codegen drift (`build_runner`), + release APK compile, + **`aapt2` permission check on the built artefact** |
| Any push (advisory) | goldens on `windows-latest`, `continue-on-error` until green once |

### Deliberately unchanged

`build-release-apk` stays **`main`-only**. Moving the APK-level permission check
to every PR would add 6–10 minutes of Android build to each one. The fast source
check already runs everywhere and catches the likely regression (the line is
deleted); the artefact check catches the exotic one (a merger or plugin strips
it). Recorded as an accepted trade, not an oversight.

---

## Hooks

Opt-in preserved — that was a deliberate Wave-1 decision and nothing in Wave 2
changed the reasoning.

### pre-commit — fast, staged-only

- Format + analyze on **staged Dart files only**. Exits instantly if none.
- **Checks** formatting, never rewrites. A hook that silently reformats and
  re-stages changes the diff you just reviewed.
- Never runs the test suite. That is pre-push's job.

**Fixed in Wave 2:** the previous version piped newline-separated paths into a
bare `xargs`, which splits on whitespace — a path containing a space became two
nonexistent paths and the hook either failed confusingly or checked the wrong
files. Now NUL-delimited end to end (`git diff -z` → `grep -zZv` → `xargs -0`),
with `--` terminating option parsing so a file named `-x.dart` cannot be read as
a flag. Guarded by `workflow_test.dart`.

### pre-push — honest, and no longer a second implementation

Delegates to **`tool/validate.sh`**. It does not reimplement format/analyze/test.

That was the substantive change: a hook carrying its own copy of the checks
drifts from CI, and a green hook that means something different from a green CI
is worse than no hook. The report is redirected via `LEVELUP_VALIDATE_OUT` to a
temp file so pushing does not dirty the committed evidence at
`.ai/audits/current/test-results.md`.

Skips entirely when a push touches nothing under `lib/`, `test/`, `pubspec.*`,
`l10n.yaml`, `analysis_options.yaml`, `dart_test.yaml` or `.flutter-version`.
Fails **closed**: if a ref range cannot be determined, it validates rather than
skipping.

### Installation and bypass

```sh
git config core.hooksPath .githooks     # enable, once per clone
git config --unset core.hooksPath       # disable
git commit --no-verify                  # bypass one commit
git push   --no-verify                  # bypass one push
LEVELUP_SKIP_HOOKS=1 git commit ...     # bypass via env
```

### Performance

| Hook | Cost |
| --- | --- |
| pre-commit | seconds — staged files only, no tests |
| pre-push | ~3–5 min, and **zero** for docs-only pushes |

A hook developers disable protects nothing, which is why the expensive check
lives at push time and not at commit time.

---

## Canonical validation

```powershell
powershell -ExecutionPolicy Bypass -File tool\validate.ps1   # Windows
sh tool/validate.sh                                          # POSIX / Git Bash
```

Checks: toolchain versions, **local SDK vs `.flutter-version` (warns on drift)**,
`pub get`, lockfile drift, `dart format --set-exit-if-changed` on hand-written
Dart, `flutter analyze`, the full test suite including every guard. Continues
past failures; writes a self-contained record.

```
developer  →  tool/validate.*  ←  pre-push hook
                    ↑
                   CI  (authoritative)
```

---

## Automated enforcement

| Rule | Enforcement | Test | Status |
|------|-------------|------|--------|
| No colour outside the palette | `palette_discipline_test.dart` | pre-existing | ✅ Wave 0 |
| Session state cleared on sign-out | `session_scope_discipline_test.dart` | 5 tests | ✅ Wave 1 |
| Bloc confined to the quiz feature | `blocOutsideQuiz` | 3 fixtures | ✅ **new** — 0 violations |
| No provider mutation in `initState` | `providerMutationInInitState` | 5 fixtures | ✅ **new** — 0 violations |
| Copy is localized | `rawTextLiterals` | 4 fixtures | ✅ **new** — allowlist + ratchet at 7 |
| Typography from the theme | `hardcodedFontSizeCount` | 3 fixtures | ✅ **new** — ratchet at 153 |
| ARB key parity | `arbKeyDrift` | 4 fixtures | ✅ **new** — 246/246 |
| CI cannot skip tests | `workflow_test.dart` | — | ✅ **new** |
| Goldens tagged not path-selected | `workflow_test.dart` | — | ✅ **new** |
| SDK pin has one source | `workflow_test.dart` | — | ✅ **new** |
| Release INTERNET (C-1) | `workflow_test.dart` + CI `aapt2` | — | ✅ **new local guard** |
| Hooks NUL-safe | `workflow_test.dart` | — | ✅ **new** |
| pre-push reuses validate.sh | `workflow_test.dart` | — | ✅ **new** |

**The guards are themselves tested.** `rules_test.dart` feeds each detector a
real violation and asserts it is caught, then feeds it a **comment containing the
same violation** and asserts it is not.

That second half caught a real bug during this wave. `ci.yml` explains the old
broken command *in a comment*, so a naive scan for `flutter test test/…` would
have found the prose and reported the bug as still present. YAML comments are
now stripped for exactly the reason Dart comments are.

**A second real bug was found by verification.** The first `arbKeyDrift` used a
regex for `"key":` and reported five false positives — it matched keys nested
inside `@metadata` objects (`placeholders`, `count`, `description`), which exist
in English and legitimately do not exist in Arabic. Fixed to parse the ARB as
JSON and compare **top-level non-`@` keys only**. A guard that cries wolf gets
deleted, so a false positive is a worse defect here than a missed violation.

---

## Theme enforcement

The palette rule was already the project's strongest guard: **zero** `Color(0x…)`
literals outside `lib/core/theme/` across 36k lines, plus no `Colors.black/white`
and no raw shadows. The audit judged all 15 `Colors.*` uses benign individually
(11 × `Colors.transparent`, 2 doc comments, 2 legitimate theme-picker swatches)
and confirmed all 5 `BoxShadow` sites read the `elevationShadow` token.

So Wave 2 **did not add a second colour guard** — there was nothing left to
catch, and a redundant rule is maintenance cost with no yield.

What the palette guard could *not* see was **typography**: no `TextTheme` exists,
and 153 call sites set `fontSize` inline. That is the identical class of
violation — a design value decided at the call site instead of in the design
system — applied to a dimension the guard never covered.

It cannot be enforced at zero without a refactor that is out of Wave-2 scope, so
it is a **ratchet frozen at 153**. New screens cannot make it worse; the debt is
paid down deliberately and the baseline lowered as it falls. That converts
"we should add a `TextTheme` one day" from an aspiration into a boundary.

```
designer value → theme token → light + dark        ✅ enforced for colour
designer value → hardcoded  → dark theme breaks    ✅ blocked for colour
                                                   🔒 ratcheted for type
```

---

## Architecture enforcement

Mechanised: **Bloc containment** (Riverpod everywhere, Bloc only for the quiz
engine — written in three spec files, unenforced until now) and **no provider
mutation during `initState`** (BUG-001 as a test — the defect that red-screened
the entire registration wizard on a device while 216 widget tests stayed green,
because only router-driven navigation reaches the assert).

Both are currently at **zero violations**, so they are enforced at zero rather
than ratcheted.

---

## Deferred rules

Left to human review, with the reason, so a reviewer's actual responsibility
stays honest:

| Rule | Why not mechanised |
| --- | --- |
| `select()` usage | Whether a `select` is warranted depends on what the widget renders. A blanket rule would be wrong more often than right. |
| Figma fidelity | Needs the design as ground truth. Device QA. |
| RTL beyond ARB parity | Structural RTL bugs are visual; needs Arabic goldens (Wave 3). |
| Architecture layering | Cross-feature imports are written `../../feature/…`, so a reliable check needs real import resolution, not grep. |
| Duplicated widget logic | Near-duplicate detection false-positives at a rate that would get the guard deleted. |
| `ref.mounted` after `await` | Needs flow analysis. Wave-3 fix first, then consider a lint. |
| Screen state coverage | A machine cannot confirm an empty state is *correct*. |

`custom_lint` + `riverpod_lint` have real AST access and would cover several of
these. That is a `pubspec.yaml` change plus CI cost — deferred rather than rushed.

---

## Compatibility

- **Windows** — hooks are POSIX `sh`, run by Git for Windows' bundled shell; no
  chmod or `.sh` extension needed. The `Read pinned Flutter version` CI step
  declares `shell: bash` because the Windows runner defaults to pwsh.
  `validate.ps1` remains the primary local entry point.
- **Flutter 3.44.7** — pinned in `.flutter-version`, read by CI, checked by
  `validate.*`.
- **Dart 3.12.2** — `pubspec.yaml` still declares `sdk: ^3.10.4`. Left alone
  deliberately: it is a valid lower bound, and raising it changes the language
  version and therefore `dart format` output.
- **Android** — only the `main`-only jobs need the Android toolchain.

---

## Validation results

### Executed — `tool/validate.ps1`, 2026-08-14

```
dart format      PASS   210 hand-written files
flutter analyze  PASS   0 issues
flutter test     PASS   846 passed / 0 failed
OVERALL          PASS
```

**846 = 806 (Wave 1) + 40 new guard tests** — 23 fixture tests of the detectors,
7 repo-scan rules, 10 infrastructure guards. The count reconciles exactly with
the failed intermediate run: 818 collected there because two files failed to
*load*, so their 30 tests were never counted (816 + 30 = 846).

**Two defects were found by running it**, both mine, both from writing Dart with
no compiler available:

1. `library;` placed after the imports in `rules.dart` — one misplaced directive
   produced three symptoms (an analyzer error and two test files failing to
   compile). Swept the whole tree afterwards; it was the only occurrence.
2. Unformatted hand-written Dart, same as Wave 1.

Recorded because the pattern is now established rather than incidental: **any
Dart I hand-write without a toolchain should be assumed to need one compile-fix
round-trip.**

### Static pre-verification (before execution)

Independent Python re-implementation against the real repository:

```
lib sources scanned            142
bloc outside quiz              []          (enforced at zero)
initState provider mutation    []          (enforced at zero)
raw Text literals              7           (== baseline)
fontSize count                 153         (== baseline)
arb missingInAr / extraInAr    [] / []     (246/246 after the JSON fix)

flutter test with a path arg   []          <- the Fable finding, closed
has --exclude-tags golden      True
has --tags golden              True
reads .flutter-version         True
hardcodes a version            False
untagged goldens               []
pre-commit xargs -0            True
pre-commit bare xargs          False
pre-push uses validate.sh      True
main manifest INTERNET         True
CI aapt2 artefact check        True
```

---

## Files changed

**New**

| File | Purpose |
| --- | --- |
| `.flutter-version` | SDK pin, single source of truth |
| `dart_test.yaml` | declares the `golden` tag |
| `test/guards/rules.dart` | pure detection logic |
| `test/guards/rules_test.dart` | fixture tests of the detectors |
| `test/guards/project_rules_test.dart` | rules applied to the repo |
| `test/guards/workflow_test.dart` | guards on the infrastructure itself |
| `docs/ENFORCEMENT.md` | every mechanised rule, and what is not |
| `.ai/audits/current/remediation-wave2.md` | this file |

**Modified**

| File | Change |
| --- | --- |
| `.github/workflows/ci.yml` | repo-driven test discovery; pin read from file; tag-based goldens |
| `.githooks/pre-commit` | NUL-safe file handling |
| `.githooks/pre-push` | delegates to `tool/validate.sh` |
| `tool/validate.sh` | `LEVELUP_VALIDATE_OUT`; SDK-pin drift warning |
| `tool/validate.ps1` | same |
| `test/goldens/design_goldens_test.dart` | `@Tags(['golden'])` |
| `test/goldens/nav_bar_golden_test.dart` | `@Tags(['golden'])` |
| `docs/PROJECT_GUIDE.md` | canonical command, pin, hooks, enforcement index |

**No application code under `lib/` was touched.** No test deleted or weakened.
No dependency added. No secret introduced.

---

## Remaining risks

1. **Nothing has been compiled or run.** The largest gap; the guards' *logic* is
   verified but their *Dart* is not.
2. **The new Dart is unformatted** — hand-written with no formatter available.
   Expect `dart format` to change `test/guards/*.dart`; run it before validating.
3. **CI has never executed.** The workflow edits are static-verified only. First
   push is the real test, and `subosito/flutter-action` must accept 3.44.7.
4. **The `@Tags` change alters test selection.** If a golden were somehow
   untagged, the Linux gate would start running it and fail on platform pixels.
   Guarded, but never observed.
5. **Two ratchets can rot.** If someone lowers a count and forgets to lower the
   baseline, the guard silently stops protecting the delta.
6. **The APK-level permission check is `main`-only** — a non-source regression
   could sit on `dev` until merge. Accepted trade, documented above.
7. **`stripComments` treats `//` inside a string literal as a comment.** No
   current rule inspects string contents, so it does not bite — but a future
   rule that does would need a real parser.


---

## Guard proof — executed 2026-08-14

`tool/verify_guards.ps1`. Each rule broken on purpose; the responsible guard had
to go red, then the tree had to come back clean.

```
[0] clean tree                      PASS  guards pass on the clean tree
[1] Bloc confined to quiz           PASS  guard fired
[2] No provider mutation initState  PASS  guard fired
[3] Copy is localized               PASS  guard fired
[4] fontSize ratchet                PASS  guard fired
[5] CI cannot silently skip tests   PASS  guard fired   (ci.yml restored, sha256 verified)
[6] Release INTERNET permission     PASS  guard fired   (manifest restored, sha256 verified)
[final] tree restored               PASS  nothing was left broken

RESULT: VERIFIED - every probed guard fails when its rule is broken
```

Probe 5 is the one worth noting: it reintroduces **verbatim** the command Fable
found — `flutter test ... test/core test/dev` — and the guard caught it. The
regression that motivated Wave 2 is now demonstrably detectable rather than
merely fixed.

Final validation, same day:

```
dart format      PASS   211 hand-written files
flutter analyze  PASS   0 issues
flutter test     PASS   847 passed / 0 failed
OVERALL          PASS
```

847 = 806 (Wave 1) + 41 guard tests.

### A third defect found by execution

`verify_guards.ps1` failed to parse on its first run — not a logic error, an
**encoding** one. Windows PowerShell 5.1 reads a `.ps1` without a BOM as ANSI,
so the em-dashes were mis-decoded and broke quote pairing, producing a parse
error pointing at a line a hundred down from the real cause.

All four `tool/*.ps1` scripts contained em-dashes. **Three worked by luck.** All
are now ASCII-only, guarded by a new test.

The instructive part: this file's content *was* verified before it shipped —
probe strings matched their targets exactly once, expected test names existed
verbatim, braces balanced. The defect was not in the content but in how the file
would be **decoded at execution**, which no amount of reading it could reveal.

That is the same shape as Tier-0 C-1, where the source manifest was correct and
the built artefact was still broken. **Verifying content does not verify
execution** — now recorded twice, in two unrelated domains, which makes it a
property of this workflow rather than a coincidence.
