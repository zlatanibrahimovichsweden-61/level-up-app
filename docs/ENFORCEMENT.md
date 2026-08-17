# Mechanically Enforced Rules

Every rule in this project that a machine can check, and how.

**Why this file exists.** The ten-agent audit found eight documented rules that
the code violated — `select()` mandated in three separate spec files and used
zero times out of seventy, `state_widget.dart` declaring itself the only place
that switches on `ScreenState` while four other implementations existed, a
back-chip widget whose own comment said it was created to stop drift, with three
forks in the tree. Meanwhile the *one* rule with a guard test — the colour
palette — held perfectly across 36,000 lines with zero exceptions.

The conclusion is not that the team is careless. It is that **prose rules decay
and mechanised rules hold**, and the gap between those two outcomes is the most
actionable thing the audit produced.

So: when you write a new rule, the first question is not "where should I
document this" but **"can this be a test instead?"** A rule that cannot be
mechanised should say so and say why.

---

## The one command

```powershell
powershell -ExecutionPolicy Bypass -File tool\validate.ps1   # Windows
```
```sh
sh tool/validate.sh                                          # Git Bash / macOS / Linux
```

Format → analyze → the full test suite, including every guard below. Continues
past failures rather than stopping at the first, and writes a self-contained
record to `.ai/audits/current/test-results.md`.

This is what CI runs and what the pre-push hook runs. One definition, three
callers — so "it passed locally" means the same thing everywhere.

---

## The rules

| Rule | Where enforced | Fails when |
| --- | --- | --- |
| No colour decided outside the palette | `test/core/theme/palette_discipline_test.dart` | a hex literal, `Colors.black/white`, or a raw shadow appears outside `lib/core/theme/` |
| Session-scoped state is cleared on sign-out | `test/core/session/session_scope_discipline_test.dart` | a non-`autoDispose` stateful provider is neither invalidated nor documented as exempt |
| Both sign-out paths clear the session | same file | `logout` or `forceLogout` stops calling `invalidateSessionScope` |
| `forceLogout` keeps its re-entry guard | same file | the early return is deleted, reopening the invalidate→401→logout loop |
| Bloc stays inside the quiz feature | `test/guards/project_rules_test.dart` | `flutter_bloc` is imported outside `lib/features/quiz/` |
| No provider mutation in `initState` | same file | a provider is written to during element mount without `addPostFrameCallback` |
| User-facing copy is localized | same file | a new file introduces `Text('literal')`, or the total rises above the frozen baseline |
| Typography comes from the theme (ratchet) | same file | the hardcoded `fontSize` count rises above its baseline |
| Both ARB files carry the same keys | same file | a key exists in `app_en.arb` with no Arabic translation |
| CI cannot silently skip tests | `test/guards/workflow_test.dart` | a path argument is passed to `flutter test` in CI |
| Goldens are tagged, not path-selected | same file | a golden test file loses its `@Tags(['golden'])` |
| The SDK pin has one source | same file | CI hardcodes a version instead of reading `.flutter-version` |
| Release networking (Tier-0 C-1) | same file + CI | `src/main` stops declaring `INTERNET`, or CI stops inspecting the built APK |
| Shell scripts are NUL-safe | same file | a bare `xargs` appears in **any** of `pre-commit`, `pre-push` or `tool/validate.sh` |
| `validate.sh` builds a NUL list | same file | it stops using `git ls-files -z` / `xargs -0` |
| Pre-push reuses the canonical script | same file | the hook grows its own copy of format/analyze/test |
| PowerShell scripts are ASCII-only | same file | a typographic character enters a `.ps1`, which PowerShell 5.1 mis-decodes as ANSI |

### Proving a guard can fail

```powershell
powershell -ExecutionPolicy Bypass -File tool\verify_guards.ps1
```

Breaks each rule on purpose and proves the **specific** guard went red.

Each probe runs **only the one test under proof** (`--plain-name`), so the exit
code is unambiguous — nothing else ran, so nothing else can explain a failure.
Every probe is a three-point proof: the target test passes on the clean tree,
fails under the violation, and the tree is restored with SHA-256 verification.

That design is a correction. The first version concluded success from *"the
suite went red AND the guard's name appears in the output"* — but
`--reporter expanded` prints every test name as it runs, **passing or failing**,
so the second condition was true whenever the test merely existed. It proved
"something broke" and attributed it to whichever guard was being probed. Fable
caught it. Running one test in isolation removes the ambiguity rather than
pattern-matching harder.

### The guards are themselves tested

`test/guards/rules_test.dart` feeds every detector a hand-written violation and
asserts it is caught, then feeds it a **comment** containing the same violation
and asserts it is not.

That second half is not ceremony. In Wave 1 the session-scope guard matched
provider names with a substring search over a file whose doc comment listed
those providers — so prose satisfied a rule about behaviour, and four providers
were reported as cleared when none of them was. It reached the right verdict by
luck. Every detector now strips comments first, and every one is tested against
its own prose.

The same class of bug was caught again while building `workflow_test.dart`:
`ci.yml` explains the old broken command *in a comment*, so a naive scan would
have found `flutter test test/core test/dev test/features` and reported the bug
as still present. YAML comments are stripped for the same reason.

---

## Ratchets

Two rules cannot be enforced at zero without a refactor that was out of scope,
so they are **ratchets**: the number may fall, never rise.

| Ratchet | Baseline | Frozen |
| --- | --- | --- |
| Hardcoded `fontSize` | 153 | 2026-08-14 |
| `Text('literal')` sites | 7 | 2026-08-14 |

A ratchet turns "we should fix this one day" from an aspiration into a boundary.
New screens cannot make it worse while the existing debt is paid down
deliberately. **If you legitimately reduce a count, lower the baseline in the
test** — otherwise it silently stops protecting anything.

---

## What is deliberately NOT mechanised

Recorded so nobody re-litigates it, and so the list of what a human reviewer is
actually responsible for stays honest.

| Rule | Why not |
| --- | --- |
| `ref.watch(...select(...))` usage | Whether a `select` is warranted depends on what the widget renders. A blanket rule would be wrong more often than right. |
| Figma fidelity — spacing, radii, shadows | Requires the design as ground truth. Device QA territory. |
| RTL correctness beyond ARB parity | Structural RTL bugs are visual. Needs Arabic goldens, which is Wave-3 work. |
| Architecture layering / dependency direction | Detectable in principle, but the codebase's cross-feature imports are written as `../../feature/…`, so a reliable check needs real import resolution rather than grep. |
| Duplicated widget logic | Near-duplicate detection produces false positives at a rate that would get the guard deleted. |
| `ref.mounted` after `await` | A genuine defect class (9 sites) but reliable detection needs flow analysis, not regex. Wave-3 fix, then consider a lint. |
| Error/loading/empty/offline coverage per screen | "Has an empty state" is not something a machine can confirm is *correct*. |

For several of these the right long-term tool is `custom_lint` + `riverpod_lint`,
which have real AST access. That is a `pubspec.yaml` change and a CI cost, and
was deferred rather than rushed.

---

## Adding a rule

1. Write the detector as a **pure function** in `test/guards/rules.dart` —
   source text in, violations out. No `expect`, no filesystem.
2. **Strip comments first.** Always.
3. Add fixture tests in `rules_test.dart`: one proving it catches a real
   violation, one proving a comment does not trip it, one proving the legitimate
   case passes.
4. Point it at the repo in `project_rules_test.dart` with the reason it exists.
5. If the codebase already violates it, ratchet rather than skip.

## When a guard fails

The failure message names the file and says what to do. If a guard is wrong,
**fix the guard** — do not weaken it to get green. A false positive is a worse
defect than a missed violation, because a guard that cries wolf gets deleted.
