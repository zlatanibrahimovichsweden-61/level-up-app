# Changed Files

**Baseline:** `dev` @ `e3651e6`.

## The headline: no behavioural change to application code

**During the audit pass: zero modifications.** Every one of the 116 findings is
a *proposal*, not an applied change. That was the mandate — with no Dart
toolchain, the suite could not be run, and shipping unvalidated changes to fix
unproven defects would trade a known-good state for an unknown one.

**After the pass, one change was applied on the developer's instruction:**
`dart format` across the 141 files that needed it. See below.

### The reformat (2026-08-12)

`tool/validate.ps1` reported `format: FAIL` on 141 of 207 hand-written files.
Cause: Dart 3.12's formatter uses **tall style**; the tree was written in the
older short style (8-space continuation indents). Nothing had ever enforced
formatting, because there was no CI and no hook.

```
141 files modified — all under lib/ and test/
generated output (*.freezed.dart, *.g.dart, l10n) excluded
```

**Proven behaviour-preserving before the suite was re-run.** For each of the 141
files, the committed version at `e3651e6` and the formatted version were
normalised — all whitespace stripped, optional trailing commas before `)`, `]`
and `}` removed — and compared:

```
files checked            : 141
differ after normalising : 0
```

Byte-identical token stream in every file. The only changes are line re-wrapping
and optional trailing commas, neither of which affects program meaning in Dart.
The full suite then re-ran **792 passed / 0 failed**, confirming it.

*Caveat, stated for the reviewer:* the normalisation strips all whitespace,
which would also mask a whitespace change inside a string literal. `dart format`
does not modify string literals, and the green suite covers it, but the check is
not a formal proof.

One file, `settings_screen.dart`, carried CRLF endings that the repo's existing
`.gitattributes` normalises to LF on commit — the repo's own rule, not a stray edit.

**Not yet committed.** See `known-issues.md` K-0 for how to commit it without
destroying `git blame` for 68% of the codebase.

Nothing under `android/`, `ios/`, `assets/`, `pubspec.yaml`, `pubspec.lock`,
`analysis_options.yaml`, `l10n.yaml` or `contract/` was touched at any point.

## Files added

### Infrastructure — intended to be committed

| File | Lines | Purpose |
| --- | --- | --- |
| `.github/workflows/ci.yml` | 268 | CI: analyze + test gate on every PR/push to `dev`/`main`; advisory Windows golden job; `main`-only codegen-drift and release-compile jobs |
| `.githooks/pre-commit` | 82 | Format + analyze, **staged files only**. Not installed — opt in with `git config core.hooksPath .githooks` |
| `.githooks/pre-push` | 90 | Test suite, skipped entirely when a push touches no Dart/config |
| `tool/validate.sh` | 246 | Full validation run (POSIX/Git Bash) → writes `test-results.md` |
| `tool/validate.ps1` | 232 | Same, PowerShell. **This is the one to run on Windows.** |

Every one of these is inert until acted on: the workflow does not run until
pushed to GitHub, the hooks do nothing until `core.hooksPath` is set, and the
scripts do nothing until invoked. **Adding them cannot break the app.**

### Audit artefacts — commit or gitignore, your call

| File | Size |
| --- | --- |
| `.ai/audits/current/_AGENT_CONTEXT.md` | 6.7 KB |
| `.ai/audits/current/architecture.md` | 33 KB |
| `.ai/audits/current/flutter-quality.md` | 29 KB |
| `.ai/audits/current/ui.md` | 40 KB |
| `.ai/audits/current/theme.md` | 33 KB |
| `.ai/audits/current/responsive.md` | 36 KB |
| `.ai/audits/current/state-navigation.md` | 32 KB |
| `.ai/audits/current/api-data.md` | 50 KB |
| `.ai/audits/current/testing.md` | 41 KB |
| `.ai/audits/current/security-performance.md` | 42 KB |
| `.ai/audits/current/devops.md` | 16 KB |
| `.ai/audits/current/project-audit.md` | consolidated register |
| `.ai/audits/current/changed-files.md` | this file |
| `.ai/audits/current/test-results.md` | **does not exist yet — see below** |
| `.ai/audits/current/known-issues.md` | |
| `.ai/audits/current/decisions.md` | |
| `.ai/audits/current/risks.md` | |
| `.ai/audits/current/final-summary.md` | |
| `.ai/audits/current/FABLE_REVIEW_BRIEF.md` | |

~360 KB of markdown. The precedent in this repo is that
`docs/device_pass/` is gitignored because "a single pass is ~12 MB of PNGs that
git can never shrink again" — the same reasoning does **not** apply here (text
compresses, and these are the evidence trail for a review), so the
recommendation is to **commit `.ai/`**. It is your call; the reasoning is
recorded either way.

### Documentation — intended to be committed

| File | Purpose |
| --- | --- |
| `docs/PROJECT_GUIDE.md` | The central source of truth. Index + hierarchy, deliberately *not* a copy of rules that already have homes |
| `docs/RESPONSIVE.md` | New — this rule had no home anywhere before |
| `docs/AGENT_WORKFLOW.md` | The ten-agent protocol and the mandatory feature lifecycle |
| `docs/AUDIT_PROTOCOL.md` | How to run an audit pass and what a report must contain |

## Verification

To confirm this package touched nothing:

```sh
git status --short          # expect only the 4 ?? directories
git diff --stat             # expect empty
git diff --cached --stat    # expect empty
```

If any of those three shows a file under `lib/` or `test/`, something has gone
wrong and this package should be rejected.
