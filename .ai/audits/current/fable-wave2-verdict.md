# WAVE 2 INDEPENDENT FABLE AUDIT
### CI · Hooks · Single-Source Validation · Mechanized Enforcement

**Reviewer:** Fable (independent, adversarial) · 2026-08-15
**Baseline:** `dev` @ `e3651e6` + uncommitted Wave-1/Wave-2 working tree
**Validation record reviewed:** `.ai/audits/current/test-results.md`,
run 2026-08-15T13:30:11Z → 13:31:32Z · format PASS (210 files) · analyze PASS
(0 issues) · **847 passed / 0 failed**
**Method:** every guard's detection logic was **re-implemented independently in
Python and run against the real tree** to reproduce its counts; each guard was
then attacked with hand-built evasion and false-positive probes; the CI guard's
regex was executed against the real `ci.yml`; the release APK evidence from
Wave 1 was re-confirmed. No claim was taken from the remediation report.

---

## Executive Summary

Wave 2 is **substantially real, not theatre**. The central claim — that
important rules moved from prose into automated failure — holds. I reproduced
every published baseline exactly (fontSize 153, Text-literal 7, ARB 246/246,
bloc-outside-quiz 0), confirmed the comment-stripping architecture is applied
consistently in Dart *and* YAML, and confirmed the CI test-discovery fix is
genuine rather than a string rearrangement.

The design decision that most deserves credit is the split between
`rules.dart` (pure functions), `rules_test.dart` (fixtures proving each
detector fires **and** that prose does not trip it) and
`project_rules_test.dart` (the repo). That is the correct architecture for
this problem, and it directly encodes the Wave-1 lesson.

Two defects and several gaps were found, none fatal:

- **W2-1 (MEDIUM)** — the guard-proof harness's pass criterion can credit the
  wrong guard, because it looks for a test *name* in output where the expanded
  reporter prints **every** test name, passing ones included.
- **W2-2 (MEDIUM)** — `tool/validate.sh:129` still pipes into a **bare
  `xargs`**, the exact defect the hook guard forbids in `pre-commit`. The
  canonical script is less safe than the hook that delegates to it, and no
  guard covers it.
- Plus documented-but-real detector blind spots (W2-3…W2-6) and two stale
  counts in comments.

I also chased and **discarded** one apparent finding: the 847-run log names
only 30 of 62 test files. I initially read that as guards not executing. It is
an artifact of the expanded reporter reprinting the active test while other
suites advance the counter (visible as the same test printed three times at
+208/+209/+210). Static case counting gives ~815 including 41 guard and 14
session cases against 847 reported — consistent with full execution. Recorded
here because a less careful audit would have filed it as critical.

---

## CI Test Discovery

### VERIFIED

**Evidence:**

- Executable YAML contains exactly two `flutter test` invocations, both
  path-free: `flutter test --no-pub --reporter expanded --exclude-tags golden`
  (line 196, Linux gate) and `--tags golden` (line 241, Windows job).
- The old command survives **only** at line 184 as a `#` comment documenting
  the defect. Correct: history preserved, behavior fixed.
- `test/widget_test.dart` sits at `test/` root and is now reachable — it was
  outside all three previously enumerated directories.
- Future directories cannot be omitted: discovery is the tree, not a list.
- No hidden filtering. `dart_test.yaml` declares only the `golden` tag with a
  description; it sets no global excludes, no `platforms`, no `paths`.
- Failure propagation intact: each `run:` block is a separate step, and the
  test steps carry no `continue-on-error` (only the advisory goldens **job**
  does, unchanged from Wave 1 and documented).
- **The guard tests executable behavior, not preferred strings.**
  `workflow_test.dart:20-22` strips full-line YAML comments before matching,
  then asserts *absence* of `flutter test … test/`. I ran its regex against the
  real file: zero hits on executable YAML, one hit on the raw file (the
  comment) — proving the comment-stripping is load-bearing and that a comment
  cannot cause a false failure.

*Nuance worth stating:* the guard proves CI does not pass a path; it cannot
prove GitHub actually ran the suite. That is the runtime gap below, not a
discovery defect.

---

## Golden Test Selection

### VERIFIED

**Evidence:**

- Both golden files carry `@Tags(['golden'])` above `library;` —
  `design_goldens_test.dart` and `nav_bar_golden_test.dart`. Syntax is correct
  Dart (annotation before the library directive).
- `dart_test.yaml` declares the tag with a description, which also suppresses
  the unknown-tag warning.
- CI selects by intent on both sides: Linux `--exclude-tags golden`, Windows
  `--tags golden`. Ordinary tests are not excluded — only the tag is.
- `workflow_test.dart:58-76` fails if any file in `test/goldens/` loses the
  annotation, so goldens cannot silently vanish from the Windows job.
- **Residual directory assumption, correctly scoped:** the tag guard still
  enumerates `Directory('test/goldens')`. A golden placed elsewhere would be
  untagged and unnoticed — but it would then run on Linux and fail loudly, so
  the failure mode is noisy, not silent. Acceptable.

---

## Flutter Version

### VERIFIED

**Evidence:**

- `.flutter-version` contains exactly `3.44.7`, matching the SDK the green run
  actually used (`Flutter 3.44.7 · Dart 3.12.2` in the toolchain block).
- All four CI jobs read it identically:
  `echo "version=$(tr -d '[:space:]' < .flutter-version)" >> "$GITHUB_OUTPUT"`
  → `flutter-version: ${{ steps.fv.outputs.version }}`. No job hardcodes.
- `validate.sh:77-81` and `validate.ps1:84-96` both read the pin and **warn**
  (not fail) when the local SDK differs — the right severity for a developer
  machine.
- `workflow_test.dart:92-106` asserts both directions: `.flutter-version` is
  referenced **and** no literal `flutter-version: X.Y.Z` remains. A future
  hardcode fails the suite.
- No competing source can override it: `.metadata`'s revision is used only for
  a `::warning`, and `pubspec.yaml`'s `sdk: ^3.10.4` is a Dart language
  constraint, not an SDK pin. The Wave-0 "three sources disagree" problem is
  resolved.

---

## Git Hooks

### VERIFIED (with one portability note)

**Evidence:**

- **NUL-safety is genuinely end-to-end** in `pre-commit`:
  `git diff --cached -z` → `grep -zZv` → `xargs -0 -r … --`. The `--`
  terminator also defeats a file named `-x.dart`. The count uses
  `tr -dc '\0' | wc -c`, correct for NUL-delimited records where `wc -l` would
  return 0.
- No bare `xargs` remains in either hook (verified by grep and by the guard's
  own negative-lookahead regex).
- Failure propagation: `set -eu`; both checks set `fail=1` and the hook exits 1
  — it cannot silently succeed after a failed command.
- **`pre-push` genuinely delegates**: `LEVELUP_VALIDATE_OUT="$report" sh
  tool/validate.sh`, and `validate.sh:31` honors that variable, so a push does
  not dirty the committed `test-results.md`. No duplicated format/analyze/test
  logic remains in the hook.
- Fails **closed**: unknown ref range or new branch → `run_anyway=1` → validate.
  The skip path requires a positively-matched no-Dart diff.
- Installation (`git config core.hooksPath .githooks`), bypass
  (`--no-verify` / `LEVELUP_SKIP_HOOKS=1`) and "CI remains authoritative" are
  all documented in the hook headers and `ENFORCEMENT.md`.
- **Portability note (not a defect):** `grep -zZ` and `xargs -r` are GNU
  extensions. Correct on Git-for-Windows and Linux; would fail on macOS/BSD.
  The hooks are developer-side and CI never runs them, so blast radius is a
  macOS contributor — worth one line of documentation, not a change.

---

## Canonical Validation

### PARTIALLY VERIFIED

**Evidence for:** one script, three callers is real. `pre-push` invokes
`validate.sh`; both scripts read `.flutter-version`; both run the same
format → analyze → full-suite sequence and continue past failures; the
`LEVELUP_VALIDATE_OUT` indirection prevents callers from clobbering each
other's evidence.

**Evidence against full centralization:**

- **W2-2 (MEDIUM) · `tool/validate.sh:129` uses a bare `xargs`:**
  `xargs dart format --output=none --set-exit-if-changed < "$tmp/dartfiles.txt"`
  with a newline-delimited list. This is precisely the whitespace-splitting
  defect Wave 2 fixed in `pre-commit` and mechanized a guard against — but the
  guard reads only `.githooks/pre-commit`, so the canonical script is
  unprotected and currently unsafe. A path with a space would be split into two
  nonexistent paths and `dart format` would either error confusingly or check
  the wrong file. *Impact today:* latent (no such path exists). *Why it
  matters:* the hook is safe and the script it delegates to is not, which
  inverts the intended trust hierarchy.
- CI does **not** call `validate.sh`; it re-expresses the same three commands
  as separate steps. That is defensible (annotations, caching, per-step
  timing), but it means "same canonical logic" is true for developer+hook and
  only *equivalent* for CI. `ENFORCEMENT.md:36` says "This is what CI runs",
  which slightly overstates it.

---

## Mechanized Enforcement

### VERIFIED

**Evidence:** I re-implemented every detector independently and ran it against
the real tree. All published numbers reproduce **exactly**:

| Rule | Published | My independent recount | Match |
| --- | --- | --- | --- |
| `blocOutsideQuiz` | 0 | 0 | ✓ |
| `providerMutationInInitState` | 0 | 0 | ✓ |
| `rawTextLiterals` | 7 (baseline) | 7, same 7 sites | ✓ |
| `hardcodedFontSizeCount` | 153 (baseline) | 153 | ✓ |
| ARB parity | 0 drift | en 246 / ar 246, both diffs empty | ✓ |
| lib/ scan canary | >100 | 142 sources | ✓ |

The rule→failure chain is genuine: each detector is pure, each is pointed at
the real repo, and each failure message names the file and the fix.

---

## Guard Quality

### PARTIALLY VERIFIED — good architecture, four documented-but-real blind spots

I attacked each detector with evasion and false-positive probes. Results:

**Comment resistance: VERIFIED across the board.** Every Dart detector calls
`stripComments` first; `workflow_test.dart` strips YAML comments; the ARB guard
parses JSON. I confirmed each fixture pair behaves as claimed.

**Evasion gaps found (all are false NEGATIVES — none weakens today's state):**

- **W2-3 (LOW) · initState guard is single-method and non-transitive.** A write
  moved into a helper called from `initState`, or into
  `didChangeDependencies` (which mounts in the same phase), is not detected. I
  verified both slip past. Also, a body containing *both* a bare write and an
  unrelated `addPostFrameCallback` is cleared wholesale — the check is
  body-level, not statement-level.
- **W2-4 (LOW) · Bloc containment matches only `package:flutter_bloc`.** An
  `import 'package:bloc/bloc.dart'` — the same architectural drift — is not
  caught. One-word fix available; not urgent, since `bloc` is not a direct
  dependency.
- **W2-5 (LOW) · `rawTextLiterals` misses `Text(r'raw')` and any non-`Text`
  widget** (`SelectableText`, `Tooltip(message:)`, `AppBar(title: Text(…))` is
  caught only because it contains `Text(`). Reasonable scope, worth stating.
- **W2-6 (LOW) · fontSize ratchet is regex-counted and evadable by
  indirection** — `fontSize: kBigSize` counts 0. That is arguably *correct*
  (a named constant is closer to a token), but it means the ratchet measures
  literal digits, not design-value discipline.

**False-positive resistance: strong.** The two ratchets are `lessThanOrEqualTo`,
so removing violations passes. The allowlist is keyed by **file**, not
`path:line`, for the "no NEW file" test — a deliberate and correct choice,
since line-keyed entries would break on every edit above them. The `path:line`
form is used only in the pure function's optional `allow` parameter, which the
repo test does not use. No probe produced a false positive.

**Maintainability:** good. Adding a rule is a documented five-step recipe; the
pure-function split keeps detectors testable without the filesystem.

---

## Guard Proof Harness

### PARTIALLY VERIFIED

**What is sound:**

- Backup/restore for the two real-file probes uses `Copy-Item` to `$TEMP`,
  restoration inside `finally`, and a **SHA-256 comparison against the
  pre-probe hash** before proceeding — with the recovery command printed if it
  mismatches. That is the right shape.
- The scratch probe `lib/__guard_probe.dart` is **gitignored** (I confirmed the
  entry), so a crashed run cannot leave it committable.
- Step [0] refuses to run against an already-red tree — without it, every probe
  would "pass" vacuously. Good.
- A final clean-tree re-run confirms nothing was left broken, and its result is
  ANDed into the exit code.

**W2-1 (MEDIUM) · The pass criterion can credit the wrong guard.**
`Check()` sets `good = $failed -and $named`, where `$named` tests whether the
expected test name appears **anywhere** in output. But `RunGuards` uses
`--reporter expanded`, which prints the name of **every** test, passing ones
included — I confirmed this against the real run log, where all 847 printed
lines are passing tests. Therefore `$named` is true whenever the guard suite
runs at all, and the criterion collapses to "**some** test failed". A probe
that broke rule A while guard A silently regressed would still report PASS if
any other guard failed. The reported "6/6 detected" is thus weaker evidence
than it appears: it proves each probe made the suite red, not that the named
guard is what fired. *Fix direction (not applied):* match the failure marker
adjacent to the name, e.g. require the name on a line containing `[E]`.

**Lesser harness notes:**

- `$ErrorActionPreference = 'Continue'` means a mid-script terminating error
  would not stop execution — but the `finally` blocks and the SHA-256 gate
  contain the damage.
- Ctrl-C at a PowerShell prompt does not reliably run `finally`. The temp
  backups and the printed recovery path mitigate this; the residual risk is a
  modified `ci.yml`/manifest that `git status` would immediately reveal.
- The harness calls `flutter test test/guards` — a hardcoded path, the very
  pattern its own CI guard forbids. Harmless in a tool (scoping a probe run is
  the point), but mildly ironic and worth a comment.

---

## Theme / Color Enforcement

### VERIFIED (unchanged by Wave 2, still sound)

**Evidence:** `test/core/theme/palette_discipline_test.dart` remains intact
and is not weakened by any Wave-2 change. It scans every `lib/` file except
`lib/core/theme/`, failing on `0xFF|Color\(0x`, on `Colors.*` outside the
allowlisted benign set, and on raw `BoxShadow` colours — i.e. it distinguishes
design-system definitions (exempt directory), intentional constants
(individually judged), and generated code (excluded) from accidental
screen-level hardcoding. I re-confirmed **0 violations** in the current tree.

**On the question asked — does it protect the future or merely report a clean
present?** It protects the future: the check is a scan over the whole tree at
every run, so a colour added to a new screen tomorrow fails the suite. That is
exactly why this rule held for 36k lines while the prose rules decayed, and it
is the model the Wave-2 guards correctly copied. It is neither overly broad
(one exempt directory, judged exceptions) nor too weak (zero tolerance for
hex at call sites).

---

## Typography Ratchet

### VERIFIED

**Evidence:**

- Baseline 153 reproduced exactly by my independent recount.
- Direction is correct: `lessThanOrEqualTo(153)` — a new inline `fontSize:`
  makes 154 and fails; removing violations passes and the failure message
  explicitly instructs lowering the baseline.
- Comments cannot manipulate the count (`stripComments` first; fixture proves
  `// TextStyle(fontSize: 14)` counts 0). Generated code cannot either —
  `libSources()` excludes `*.g.dart`, `*.freezed.dart` and
  `l10n/app_localizations*`.
- False-positive risk is essentially nil: the count only rises on a genuinely
  new literal.
- **Honestly documented as temporary.** `ENFORCEMENT.md` §Ratchets names both
  ratchets with baselines and freeze dates and states the reason; the in-test
  comment says plainly there is no `TextTheme` and that this is a boundary, not
  a solution; `PROJECT_GUIDE.md` still flags typography as unenforced
  architecture. No pretense that the typography story is complete.
- Caveat W2-6 above: it measures literal digits, so indirection through a named
  constant is invisible.

---

## Localization / ARB

### VERIFIED

**Evidence:**

- **JSON is parsed, not pattern-matched:** `jsonDecode` then
  `.keys.where((k) => !k.startsWith('@'))` — top-level, non-`@` keys only.
- I independently parsed both files: **246 translation keys each**,
  `missingInAr` empty, `extraInAr` empty.
- The metadata false-positive class is genuinely fixed. Nested keys inside
  `@meta` objects (`placeholders`, `description`, `type`) are unreachable
  because only `decoded.keys` — the top level — is inspected. The dedicated
  fixture (`ignores @-metadata entries`) proves it.
- Both directions fail as intended: a missing Arabic key and an orphan Arabic
  key each have a passing fixture, and the repo test asserts both sets empty.
- Valid metadata does not fail the guard (confirmed against the real
  `app_en.arb`, which carries `@` entries the Arabic file legitimately lacks).
- The copy ratchet (7 sites, file-keyed allowlist of 4 files) is separate and
  correctly documents which two of the seven are genuine Wave-3 leaks versus
  the untranslatable flag emoji and punctuation joiners.

---

## Release INTERNET Protection

### VERIFIED — strengthened, not weakened

**Evidence:**

- `android/app/src/main/AndroidManifest.xml:19` still declares INTERNET.
- CI retains **both** halves: the fast source check on every PR (line 133) and
  the `main`-only `aapt2 dump permissions` against the **built APK**
  (line 344ff), with a merged-manifest fallback when `aapt2` is not on PATH.
  Both arms `exit 1` on absence.
- Wave 2 **added** a third layer: `workflow_test.dart:109-144` fails the local
  suite if `src/main` loses the permission **or** if `ci.yml` stops mentioning
  `aapt2` — i.e. the protection is now itself protected against silent removal.
- No new rule bypasses it. The `--exclude-tags golden` change touches test
  selection only; the release job is untouched apart from reading the pin.
- **Permission ≠ connectivity**, and the documentation says so. Base URLs
  remain `TBD.example`; end-to-end release networking stays unproven and
  unprovable until a backend exists. Correctly framed everywhere I checked.

---

## Application Scope

### VERIFIED

**Evidence:** `git diff --stat lib/ android/` returns **empty** for Wave 2 —
no screens, models, repositories, services, routing, theme or state-management
changes. `lib/features/home/screens/home_screen.dart` carries a fresh mtime but
a **zero-byte diff** (touched, not modified). The only new path under `lib/` is
`lib/core/session/` from Wave 1. Wave 2's footprint is `.github/`, `.githooks/`,
`tool/`, `test/guards/`, `dart_test.yaml`, `.flutter-version`,
`.git-blame-ignore-revs`, `.gitignore`, `docs/`. Correct discipline.

---

## Documentation

### PARTIALLY VERIFIED

**Accurate:** `ENFORCEMENT.md` states what is mechanized (a 15-row table
mapping rule → file → failure condition), what is ratcheted (both baselines
with freeze dates), and — unusually good practice — **what is deliberately not
mechanized and why** (7 rows, including `select()`, Figma fidelity,
`ref.mounted`, layering), with `custom_lint`/`riverpod_lint` named as the
right long-term tool. Hook installation, bypass, the canonical command and the
Flutter-version source of truth are all documented and match the code.

**Stale/overstated items found:**

- `ci.yml:127` still says "the 792-case suite"; the suite is 847. Exactly the
  hardcoded-count decay the audit warns about, in the Wave-2 file itself.
- `ci.yml:52` says "806 passing" — one wave out of date.
- `PROJECT_GUIDE.md:96` still says "~730 cases".
- `ENFORCEMENT.md:36` "This is what CI runs" overstates: CI re-expresses the
  same commands rather than invoking `validate.sh` (see W2-2).
- `ENFORCEMENT.md` does not mention `validate.sh`'s bare `xargs`, nor the GNU
  `grep -z`/`xargs -r` portability assumption.

---

## Actual GitHub Actions Runtime

### NOT VERIFIED

**What is missing, explicitly:** there is no evidence any of this executed on
GitHub. `.github/workflows/ci.yml` is untracked — it has never been pushed, so
no run can exist. I found no run logs, no badge, no `gh` output, no branch
protection record. Everything above about CI is **static analysis of YAML plus
local execution of the guards that inspect that YAML.**

Specific runtime risks that only a real run can settle:

1. **`subosito/flutter-action@v2` accepting `3.44.7`** — the pin is now read
   from a file, so a typo or an unavailable build fails at setup. Unproven.
2. **Linux shell behavior** — `mapfile`/`jq`/`sed` in the toolchain and format
   steps are fine on `ubuntu-latest` in principle; unproven in practice. Note
   CI does **not** run `validate.sh`, so that script's Linux behavior is
   untested by CI as well.
3. **`ANDROID_HOME` / `aapt2` availability** on `ubuntu-latest` — the step
   already fails soft to the merged-manifest path, which is sound design, but
   which arm actually runs is unknown.
4. **Artifact paths** — `build/app/outputs/flutter-apk/app-release.apk` and the
   `test/goldens/failures/` upload path are unverified on a runner.
5. **Permissions** — `permissions: contents: read` is correct and minimal for
   these jobs (checkout + caches only; no PR comments, no releases). Static
   review only.
6. **Hook independence** — CI does not depend on hooks; confirmed by reading,
   unproven by execution.

**This is a warning, not a Wave-2 failure**, exactly as the brief anticipates.
The first push to a branch with a PR will settle items 1–4 in one run.

---

## False Positives / False Negatives

**False positives found in the current design: none.** Every probe I built
that represented legitimate code passed cleanly (themed lookups, localized
`Text(l10n.x)`, deferred `initState` writes, read-only `initState`, ARB
metadata, quiz-internal Bloc imports).

**False negatives (all documented above):** W2-3 initState transitivity and
`didChangeDependencies`; W2-4 `package:bloc`; W2-5 `Text(r'…')` and non-`Text`
widgets; W2-6 fontSize via named constant. All four are *narrowing* gaps, not
correctness failures — they cannot cause a green suite to hide a violation that
exists **today**, and each is a small, well-scoped future improvement.

**One near-miss worth recording:** the 847-run log names only 30 of 62 test
files, which reads as "guards never ran". It is a reporter artifact
(re-printing the active test while parallel suites advance the counter). Static
case counting (~815, including 41 guard + 14 session cases) is consistent with
847 actually executing. Filed here so no future reader re-raises it as a
critical finding.

---

## Over-Engineering Concerns

**Verdict: proportionate.** ~600 lines of guard code and ~190 of harness to
mechanize eight rules, on a project whose central diagnosed failure was rules
decaying in prose, is a reasonable trade. Specifically defensible choices:

- Regex-and-strip rather than a full Dart AST — matched to the rules chosen,
  and `ENFORCEMENT.md` names `custom_lint`/`riverpod_lint` as the successor
  when AST access is genuinely needed. Deferring that is the right call.
- Two ratchets instead of two large refactors.
- The explicit "NOT mechanised" table — the discipline to *stop* adding guards
  is the strongest anti-over-engineering signal in the package.
- Hook cost control (pre-commit staged-only; pre-push skips on non-Dart pushes)
  means the hooks are unlikely to be habitually bypassed.

**Mild concerns only:** the harness's ~190 lines currently deliver weaker proof
than their length implies (W2-1); and the guard-on-the-guard layer
(`workflow_test.dart` asserting facts about `ci.yml` text) is one meta-level
deep — justified today, but it should not grow, or CI becomes a string-matching
exercise about itself.

---

## Security Concerns

**None material.**

- No secrets, credentials or tokens introduced in any Wave-2 file (scanned
  `tool/`, `.githooks/`, `.github/`, `test/guards/`; only hit is a comment
  about wiring signing via secrets later).
- CI permissions are minimal and appropriate: `contents: read`.
- No dangerous git operations anywhere — the harness never calls `git
  checkout/reset/clean`; it uses file copies and SHA-256 verification.
- Temporary mutations are restored in `finally` with hash verification, and the
  scratch probe path is gitignored.
- Scripts fail safely: `validate.*` deliberately omit `set -e` (documented, so
  all steps run and the report is complete) while still returning a non-zero
  overall exit; hooks use `set -eu` and fail closed.
- `-ExecutionPolicy Bypass` in documented invocations is standard for local
  scripts and introduces no remote-execution path.

---

## Wave-2 Warnings

Genuine, and all fixable without touching application code:

1. **W2-1 (MEDIUM)** — Harness pass criterion credits any failure, not the
   named guard. Require the expected name on an `[E]` line before "6/6" can be
   claimed as proof of *specific* detection.
2. **W2-2 (MEDIUM)** — `tool/validate.sh:129` bare `xargs` on a
   newline-delimited list; the canonical script is less NUL-safe than the hook
   that delegates to it, and the existing hook guard does not cover it.
3. **W2-3…W2-6 (LOW)** — detector blind spots: `initState` transitivity /
   `didChangeDependencies`; `package:bloc`; `Text(r'…')` and non-`Text`
   widgets; fontSize via named constant.
4. **DOC (LOW)** — stale counts: `ci.yml:127` "792-case", `ci.yml:52` "806",
   `PROJECT_GUIDE.md:96` "~730"; and `ENFORCEMENT.md:36` overstates that CI
   runs `validate.sh`.
5. **PORTABILITY (LOW)** — hooks rely on GNU `grep -z` / `xargs -r`; fine on
   Git-for-Windows and Linux, would fail on macOS/BSD. Document the assumption.
6. **RUNTIME (WARNING, carried)** — GitHub Actions has never executed this
   workflow; `.github/` is still untracked. Until it runs once, CI confidence
   is design-level only.
7. **CARRIED FROM WAVE 1** — the entire verified state remains **uncommitted**.
   Two waves of work now sit in the working tree. This is the single largest
   practical risk in the project right now.

---

## Wave-3 Deferred Findings

Not Wave-2 failures; recorded only:

`TextTheme` refactor (the 153 ratchet's real fix) · the two genuine
localization leaks behind the 7-site ratchet (`app_router.dart` placeholder
copy, `state_widget.dart` Retry label) · `ref.mounted` after `await` (9 sites)
· QuizBloc `TypeError` escape and other application-quality findings ·
navigation dead ends (`/subscription`, onboarding CTA) · `memCacheWidth` at 5
`CachedNetworkImage` sites · `hive_ce` removal · font-metric and contrast
product decisions (Tajawal w600, dark hint, `mutedText`) · Arabic goldens /
RTL golden coverage · `custom_lint` + `riverpod_lint` adoption.

---

## FINAL VERDICT

# APPROVED WITH WARNINGS

Wave 2 does what it set out to do. The rule → automated enforcement → violation
→ failure chain is real and I verified it by reproducing every baseline
independently and by attacking every detector. The CI test-discovery fix is
genuine, the SDK pin now has exactly one source, the hooks are properly
NUL-safe and delegate rather than duplicate, the ARB guard's metadata
false-positive class is correctly eliminated by parsing JSON, and the Wave-1
release-networking protection is not merely preserved but now guarded against
its own removal. Application code was untouched. The package also shows the
right instinct about *what not to automate*.

It is not APPROVED outright for three reasons, in order of weight: the guard
proof harness proves less than it claims (W2-1), the canonical validation
script contains the exact unsafe-`xargs` defect Wave 2 mechanized a guard
against elsewhere (W2-2), and **no GitHub Actions run has ever occurred** — the
workflow file is still untracked, so every CI conclusion in this report is
design-level. None of these compromises the codebase's current correctness;
all three weaken the *evidence* that the enforcement layer will hold.

Recommended next actions, in order: commit Waves 1–2 so CI can run at all;
push a branch and let one real workflow execution settle the runtime unknowns;
then close W2-1 and W2-2.
