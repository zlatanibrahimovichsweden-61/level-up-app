# Agent 10 — DevOps & Workflow

**Scope:** Git workflow, CI, hooks, analyzer/formatter configuration, branch
protection, developer workflow, skills-duplication topology.

**Baseline:** `dev` @ `e3651e6`, working tree clean.

**Provenance note.** The Agent-10 subagent was terminated mid-stream by an API
error after it had written `.github/workflows/ci.yml`, `.githooks/pre-commit`
and `.githooks/pre-push`, but before it wrote `tool/validate.ps1` or this
report. The orchestrator completed both, re-deriving every figure below
directly from the repository rather than inheriting the subagent's claims.
Where a figure appears in `ci.yml`'s header comments it has been independently
re-verified here; all of them held.

**Repository areas inspected:** `.git` (full history, 43 commits, all refs),
`git ls-files`, `.gitignore`, `android/.gitignore`, `android/gradle.properties`,
`android/app/build.gradle.kts`, `.metadata`, `pubspec.yaml`, `pubspec.lock`,
`analysis_options.yaml`, `l10n.yaml`, `.claude/skills/` (22 skills),
`F:\level\level_up\level_up\skills\` (7), `F:\level\level_up\level_up\.agents\skills\` (15),
`test/goldens/`, `docs/KNOWN_BUGS.md`, `F:\level\level_up\level_up\01_Flutter_Specs\`.

---

## Findings

### F-10-01 [HIGH] [ARCHITECTURE ISSUE] No CI existed at all — every quality claim this repo makes is unenforced

**Evidence:** `.github/` did not exist at `e3651e6`. `git log --diff-filter=A --name-only`
shows no workflow file was ever added and later deleted — there has simply
never been one.

**Why it matters:** the repo's central claim about itself is "~730 green tests".
Nothing verified that claim on any commit except by a human remembering to run
it locally. Combined with F-10-02 (no hooks), the entire quality gate for 43
commits of a production app handling minors' PII was one developer's
discipline. It held — `git log` shows no revert commits and no "fix CI" churn —
but it is not a property of the repository, and it does not survive a second
contributor or a bad week.

**Recommended fix:** DONE — `.github/workflows/ci.yml` created (see *Files
Changed*). It is not a template; every decision in it is derived from a measured
fact about this repo, documented inline. See F-10-05, F-10-06, F-10-07 for the
three non-obvious ones.

**Risk of fixing:** none to app code. The workflow will not run until pushed to
GitHub. First run may need `FLUTTER_VERSION` corrected — see F-10-04.

**Validation required:** push the branch and confirm the `analyze + test` job
goes green. Expect the advisory `goldens` job to be the interesting one.

---

### F-10-02 [MEDIUM] [QUALITY IMPROVEMENT] No git hooks — nothing catches cheap problems before they reach a reviewer

**Evidence:** `.git/hooks/` contains only `*.sample` files. No `core.hooksPath`
configured.

**Why it matters:** format and analyze failures are the cheapest possible class
of failure and the most annoying to discover from a CI email four minutes after
pushing.

**Recommended fix:** DONE — `.githooks/pre-commit` and `.githooks/pre-push`
created, **not installed**. Installing into `.git/hooks` is the developer's
call, not an auditor's; the opt-in is one line:

```sh
git config core.hooksPath .githooks
```

The design respects the brief's warning that hooks must not slow normal work:
`pre-commit` only ever looks at *staged* Dart files (and exits instantly if you
staged none); `pre-push` skips the suite entirely when a push touches nothing
under `lib/`, `test/`, `pubspec.*`, `l10n.yaml` or `analysis_options.yaml`, so
docs-only and contract-only pushes cost zero. Both honour `--no-verify` and
`LEVELUP_SKIP_HOOKS=1`.

**A deliberate design choice worth stating:** `pre-commit` **checks** formatting
rather than rewriting and re-staging. A hook that silently reformats changes the
diff you just reviewed — that is worse than a two-second failure.

**Risk of fixing:** zero until opted in.

**Validation required:** enable, then make one deliberately mis-formatted commit
and confirm it is blocked.

---

### F-10-03 [MEDIUM] [ARCHITECTURE ISSUE] `analysis_options.yaml` is stock `flutter_lints` with zero project rules, and does not exclude generated code

**Evidence:** `analysis_options.yaml` — 24 of its 28 lines are the boilerplate
comments `flutter create` emits. The `rules:` block contains **two commented-out
examples and nothing else**. There is no `analyzer:` section at all, therefore
no `exclude:` and no `errors:` escalation.

**Why it matters, precisely:** the project has written down its own engineering
rules in five separate places — `01_Flutter_Specs/Flutter_Common_Mistakes.md`,
`Performance.md`, `State_Management.md`, `Testing_and_Quality.md`, and the
`.claude/skills/`. **None of them are machine-enforced.** Agents 2 and 4 both
found the same shape of failure independently: `Performance.md:13`,
`Flutter_Common_Mistakes.md:10` and `State_Management.md:31` all mandate
`ref.watch(...select(...))`, and the codebase contains **zero** uses of it
across 70 `ref.watch` sites. A written rule with no enforcement decays into
folklore. That is the real finding here, and it is bigger than any individual
lint.

**Recommended fix:** see the two-stage proposal below. **The orchestrator has
NOT applied it** — per this pass's constraints, `analysis_options.yaml` is
untouched. Blast radius is measured, not guessed, so the developer can adopt
stage 1 with confidence and schedule stage 2.

#### Stage 1 — adopt now (blast radius: near zero)

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.freezed.dart"
    - "**/*.g.dart"
    - "lib/l10n/app_localizations*.dart"
    - "build/**"

  language:
    strict-casts: true
    strict-raw-types: true

  errors:
    # An unawaited Future in this codebase means a silently-dropped network
    # call or an un-surfaced error. Escalate from hint to error.
    unawaited_futures: error
    # BUG-001's neighbourhood: using a BuildContext after an await.
    use_build_context_synchronously: error
    # A missing required ARB key fails silently to English — Arabic is the
    # baseline locale here, so this must be loud.
    missing_required_param: error
    # Dead code and unused imports should not accumulate in a repo this clean.
    unused_import: error
    unused_local_variable: error
    dead_code: error
    # TODOs are tracked in docs/, not by the analyzer.
    todo: ignore

linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - cancel_subscriptions
    - close_sinks
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - require_trailing_commas
    - sized_box_for_whitespace
    - sort_child_properties_last
    - unnecessary_await_in_return
    - unnecessary_parenthesis
    - use_super_parameters
    - avoid_slow_async_io
    - no_adjacent_strings_in_list
    - unnecessary_statements
```

Measured blast radius for the riskiest entries: `avoid_print` — **0** hits
(Agent 9 confirmed zero `print`/`debugPrint` in `lib/`). `cancel_subscriptions`
/ `close_sinks` — **0** (Agent 2 found no `StreamSubscription` and no
`AnimationController` anywhere; these are pure regression guards).
`use_build_context_synchronously` — **0** violations (Agent 2 checked all 8
post-`await` `context` uses; all correctly guarded). So the three rules most
likely to hurt cost nothing today and lock in properties the codebase already
has. That is the ideal shape for a first adoption.

`require_trailing_commas` and `prefer_const_constructors` will produce some
churn but are auto-fixable in one pass: `dart fix --apply`.

#### Stage 2 — adopt after a cleanup commit (blast radius measured, non-trivial)

| Rule | Measured hits | Note |
| --- | --- | --- |
| `always_use_package_imports` | **447** | See F-10-08 — the import style is genuinely split, 447 relative vs 385 `package:`. Pick one, `dart fix` it, then lock it. |
| `prefer_single_quotes` | ~268 | Approximate (the grep counts doc-comment quotes too). Auto-fixable. |
| `public_member_api_docs` | very large | **Do not adopt.** Wrong tool for an app; this is a package lint. |
| `lines_longer_than_80_chars` | large | **Do not adopt.** `dart format` already handles line width; this rule fights it. |

#### Stage 3 — the rule that would actually have caught BUG-001

No core lint catches "provider mutated during build". `riverpod_lint` does, via
`provider_dependencies` and its build-phase checks. Adding:

```yaml
dev_dependencies:
  custom_lint: ^0.7.0
  riverpod_lint: ^3.0.0
```

...plus `analyzer: plugins: [custom_lint]` would make the *literal* BUG-001
class machine-detectable. **This is a `pubspec.yaml` change and therefore out of
scope for this pass** — recorded as a recommendation. Note it costs analysis
time; benchmark before making it a CI gate. Agent 8 independently proposed a
hand-written guard test (`test/core/discipline_test.dart`) for the same purpose;
the two are complementary and the test is cheaper. **Recommend the test first,
`riverpod_lint` second.**

**Validation required:** apply stage 1, run `flutter analyze`, confirm the issue
count is what this section predicts. If it is materially higher, something in
this analysis is wrong and stage 1 should be trimmed rather than force-adopted.

---

### F-10-04 [MEDIUM] [BUG] Three sources disagree about which Flutter SDK this project uses

**Evidence:**
- `.metadata:7` records revision `f6ff1529fd6d8af5f706051d9251ac9231c83407`
- `pubspec.yaml:22` declares `sdk: ^3.10.4`
- `pubspec.lock` was resolved by an SDK reporting `flutter: ">=3.44.0"` / `dart: ">=3.12.0"`

**Why it matters:** `.metadata` records the revision the project was *created or
migrated* with; `flutter upgrade` does not rewrite it. So pinning CI to the
`.metadata` revision — the obvious move, and the one the audit brief implied —
would pin CI to an SDK **too old to resolve the committed lockfile**, and CI
would fail on its first run for a reason that looks like a code problem.

**Recommended fix:** `ci.yml` pins `FLUTTER_VERSION: "3.44.0"` (the floor implied
by the lockfile) and adds a *warning*, not a failure, when the runner's revision
differs from `.metadata`. **The developer must run `flutter --version` once and
set `FLUTTER_VERSION` to the exact local version.** This is the single manual
step required before CI is trustworthy. There is also a `Lockfile did not drift`
step that fails loudly if the pinned SDK resolves a different dependency set
than the committed lock — which converts this whole class of confusion into one
clear error message.

**Validation required:** run `flutter --version` locally; update `FLUTTER_VERSION`.

---

### F-10-05 [MEDIUM] [QUALITY IMPROVEMENT] Golden tests will fail on a Linux runner even when the code is correct

**Evidence:** `test/goldens/` holds 18 `.png` baselines, all captured on the
developer's Windows machine. Flutter goldens embed platform-specific text
shaping and anti-aliasing.

**Why it matters:** this is the classic first-CI trap. A naive workflow runs
`flutter test` on `ubuntu-latest`, the goldens fail, and the developer either
deletes the goldens or stops trusting CI. Both outcomes are worse than having no
CI. The audit brief explicitly warns against leaving the developer to discover
this.

**Recommended fix:** DONE, in three parts in `ci.yml`. (1) The Linux gate runs
`test/core test/dev test/features` explicitly — everything except goldens.
(2) A separate `windows-latest` job runs `test/goldens`, marked
`continue-on-error: true` so it is **advisory until it has been green once**.
(3) On failure it uploads the actual/diff PNGs as an artifact, because "goldens
failed" without images is an unactionable red X.

**Deferred, deliberately:** the cheaper long-term fix is to tag the golden tests
`@Tags(['golden'])` and run one Linux job with `--exclude-tags golden`. That
edits `test/`, which this pass may not touch. Recorded in *Deferred Improvements*.

---

### F-10-06 [LOW] [QUALITY IMPROVEMENT] Generated code is committed — which is defensible, and dictates the CI shape

**Evidence:** `git ls-files` tracks **34** generated Dart files (18
`*.freezed.dart`, 16 `*.g.dart`) plus 3 `lib/l10n/app_localizations*.dart`.
`pubspec.lock` is tracked (correct for an application). `build/` is **not**
tracked (0 files). `.idea/` and `level_up_app.iml` are present in the working
tree but **not tracked** — `.gitignore` covers them correctly.

**The argument, both ways.** Against committing: 34 files of churn in every
model diff, and merge conflicts in bytes no human wrote. For committing: a fresh
clone compiles without a 60–120 s `build_runner` step, `flutter analyze` works
immediately, and CI does not pay codegen on every PR. **For a single-developer
app with a partner-controlled API contract, committing is the right call** and I
recommend keeping it.

But it creates an obligation: something must detect a model edited without
regenerating. `ci.yml` handles this with a `codegen-drift` job that runs
`build_runner` and diffs — scoped to **`main` pushes and `workflow_dispatch`
only**, because on a PR it would be pure cost for bytes already in the tree. The
much cheaper `flutter gen-l10n` drift check runs on **every** PR, because a
stale `.arb` regeneration shows up as a missing Arabic string, and Arabic is
this project's baseline locale, not an edge case.

---

### F-10-07 [LOW] [BUG] `android/gradle.properties` requests 8 GB of heap — more than a CI runner can safely give

**Evidence:** `android/gradle.properties` — `org.gradle.jvmargs=-Xmx8G
-XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m`.

**Why it matters:** tuned for the dev machine. A GitHub-hosted `ubuntu-latest`
runner has 16 GB total; asking Gradle for 8 GB heap plus 4 GB metaspace, with
the Kotlin and Dart compilers also resident, invites an OOM kill that presents
as a mysterious build failure.

**Recommended fix:** DONE — `ci.yml`'s release job overrides via
`GRADLE_OPTS: "-Dorg.gradle.jvmargs=-Xmx4g -Dorg.gradle.daemon=false"` rather
than editing `android/gradle.properties` (out of scope, and the local value is
correct for the local machine).

---

### F-10-08 [LOW] [QUALITY IMPROVEMENT] Import style is split roughly 50/50 between relative and `package:`

**Evidence:** 447 relative imports (`import '../..`) vs 385 self-`package:`
imports (`import 'package:level_up_app/...`) across the 207 hand-written Dart
files.

**Why it matters:** mostly cosmetic, but it has one real consequence Agent 1
hit: a grep for `features/` finds **zero** cross-feature imports, because half
of them are written as `../../<feature>/...`. Inconsistent import style makes
the codebase harder to audit mechanically — including by the analyzer rule that
would enforce feature boundaries.

**Recommended fix:** pick `always_use_package_imports`, run `dart fix --apply`,
lock it in stage 2 of F-10-03. Not urgent.

---

### F-10-09 [LOW] [QUALITY IMPROVEMENT] `main` is 3 commits ahead of `dev`, and both `backup/*` branches are fully stale

**Evidence:**
- `git rev-list --count main..dev` = **23** — `dev` is 23 ahead, as expected.
- `git rev-list --count dev..main` = **3** — **`main` carries 3 commits `dev` does not.**
- `backup/pre-day7-reorder`: **0** commits not already in `dev` (17 behind).
- `backup/pre-split`: **0** commits not already in `dev` (27 behind).

**Why it matters:** the 3 commits on `main` are the live one. `dev` is not a
strict superset of `main`, so the next `dev` → `main` merge will be a real merge
with real conflict potential, at exactly the moment the developer expects a
fast-forward. Worth resolving now, while it is 3 commits, rather than at release
time. The two `backup/*` branches are fully contained in `dev` and are pure
clutter — they served their purpose and can be deleted.

**Recommended fix:** inspect the 3 commits (`git log dev..main --oneline`),
merge or cherry-pick them into `dev`, then delete both backup branches. **Do not
force-push either long-lived branch.**

**Validation required:** `git log dev..main --oneline` — read the 3 before doing
anything.

---

### F-10-10 [LOW] [QUALITY IMPROVEMENT] Commit hygiene is excellent — recorded as a positive, not a finding

**Evidence:** **43 of 43** commits follow Conventional Commits
(`feat(scope): …`, `fix(theme): …`, `docs(day8): …`). 100%, with no exceptions
in the entire history.

**Why it is here:** an audit that only lists defects gives a false picture. This
is the strongest single signal of process discipline in the repository, and it
means a `commit-msg` hook enforcing the convention would be **redundant** — the
behaviour is already there. Recommending one would be automation for its own
sake, which the brief explicitly warns against. **No hook added.**

---

### F-10-11 [MEDIUM] [ARCHITECTURE ISSUE] The project's rules exist in four places with no sync mechanism

**Evidence:**

| Rule set | Location A | Location B | State |
| --- | --- | --- | --- |
| 7 project skills (`bloc`, `build-screen`, `river`, `screen-states`, `figma-frame`, `level-up-domain`, `seif-api-contract`) | `level_up_app/.claude/skills/` | `level_up/skills/` | **byte-identical** (md5 verified on all 7) |
| 15 generic Flutter/Dart skills | `level_up_app/.claude/skills/` | `level_up/.agents/skills/` | mirrored |
| Engineering rules prose | `level_up/01_Flutter_Specs/*.md` (21 files) | — | outside the app repo entirely |
| Per-feature specs | `level_up_app/docs/day*_brief.md` (12 files) | — | in-repo |

**Why it matters:** they are in sync *today*, by luck and by one person's care.
Nothing keeps them so. And the divergence, when it comes, will be silent — a
skill updated in the vault but not in `.claude/` means the coding agent reads
the stale copy and confidently does the wrong thing. Two agents already hit the
consequence of this from the other direction: Agent 1 found
`01_Flutter_Specs/Architecture_and_Folders.md` is wrong in 5 of ~10 assertions
about the current code, and Agent 6 found `bloc/SKILL.md` promises a
`QuizTimeExpired` event that was deliberately never built. **The docs have
already drifted from the code; the only reason the two skill *copies* have not
drifted from each other is that nobody has edited one in isolation yet.**

**Recommended fix — one canonical side, and it should be the app repo.**
Considered and rejected: *symlink* (breaks on Windows without developer mode and
this developer is on Windows — a non-starter); *git submodule* (heavyweight for
22 markdown files, and adds a checkout step to CI); *sync script* (needs to be
remembered, which is the problem it purports to solve).

Recommend: **`level_up_app/.claude/skills/` is canonical.** It is version-
controlled with the code it describes, it is what the coding agent actually
loads, and a skill change lands in the same PR as the code change that motivated
it — which is the only mechanism that reliably keeps rules and code together.
The vault copies become read-only mirrors, refreshed by an explicit copy when
the developer wants them in Obsidian. Document the direction in
`docs/AGENT_WORKFLOW.md` so the next person knows which way the arrow points.

**Risk of fixing:** none — it is a documentation decision, not a code change.

---

### F-10-12 [MEDIUM] [QUALITY IMPROVEMENT] No branch protection

**Evidence:** cannot be verified from the local clone; GitHub-side setting.
Given no CI existed until this pass, no status check *could* have been required.

**Recommended fix** — concrete settings for the developer to click, after CI has
gone green once:

*On `main`:*
- Require a pull request before merging (approvals: 0 is fine for a solo repo —
  the value is the PR, which is where CI runs, not the review)
- Require status checks to pass → select **`analyze + test`**
- Require branches to be up to date before merging
- Require conversation resolution before merging
- **Do not allow force pushes. Do not allow deletions.**
- Do *not* require the `goldens` check until it has passed once (F-10-05)

*On `dev`:*
- Require status checks to pass → **`analyze + test`**
- Allow force pushes: **no** (the `backup/*` branches suggest history rewriting
  has been a habit; the backups are the mitigation, protection is the fix)
- Everything else: leave permissive. `dev` is the working branch and should not
  need a PR for every commit.

---

## Changes Made

Infrastructure only. **No file under `lib/`, `test/`, `android/`, `ios/`,
`assets/`, `pubspec.yaml` or `analysis_options.yaml` was created, modified or
deleted.** Verified with `git status --short`: the only entries are the four new
untracked directories below.

## Files Changed

| File | Lines | By |
| --- | --- | --- |
| `.github/workflows/ci.yml` | 268 | Agent 10 |
| `.githooks/pre-commit` | 82 | Agent 10 |
| `.githooks/pre-push` | 90 | Agent 10 |
| `tool/validate.sh` | 246 | Agent 10 |
| `tool/validate.ps1` | 232 | orchestrator (agent terminated before writing it) |
| `.ai/audits/current/devops.md` | this file | orchestrator |

All six are new. Nothing was overwritten.

## Tests Run

NONE — no Dart toolchain in this environment. That is precisely why
`tool/validate.*` exists.

## Test Results

N/A. `tool/validate.sh` / `tool/validate.ps1` writes
`.ai/audits/current/test-results.md`; until the developer runs one of them, that
file does not exist and **every "the suite is green" claim in this audit package
is unverified**. This is stated again in `known-issues.md` and `risks.md`.

## Remaining Risks

1. **`FLUTTER_VERSION` is a guess** (`3.44.0`, the lockfile floor). Until the
   developer sets the real local version, CI's first run may fail on dependency
   resolution rather than on code. F-10-04.
2. **The `goldens` job has never run.** It is `continue-on-error` so it cannot
   block, but it may be permanently red for a platform reason, in which case
   it is noise rather than signal. Decide after the first run: flip it to
   blocking, or take the `@Tags(['golden'])` route.
3. **The hooks have never executed.** They are POSIX `sh` and rely on Git for
   Windows' bundled shell. Confirmed-correct by construction, not by running.
4. **`build-release-apk` has never run**, and it exercises the Android toolchain
   for the first time in CI. Agent 9's F-10-adjacent finding — no `INTERNET`
   permission in the release manifest — means the resulting APK, while it will
   *compile*, describes an app that cannot reach the network. The compile gate
   will pass and the app would still be broken. **CI cannot catch that; only a
   device can.**

## Deferred Improvements

- Tag golden tests `@Tags(['golden'])` and collapse to one Linux job — needs a
  `test/` edit (F-10-05).
- Add `custom_lint` + `riverpod_lint` — needs a `pubspec.yaml` edit (F-10-03
  stage 3). Prefer Agent 8's guard test first; it is cheaper and catches the
  same BUG-001 class.
- Normalise import style and enable `always_use_package_imports` (F-10-08).
- Coverage reporting. Deliberately **not** added: a coverage percentage on a
  codebase whose real gaps are structural (Agent 8's blind spots) would be a
  number that goes up while the actual risk stays put.
- A `dev` → `main` release checklist, once there is a distribution channel.

## Recommendations (ranked)

1. **Run `tool/validate.ps1` and paste back `test-results.md`.** Everything in
   this audit package is unverified until that file exists. One command.
2. **Set `FLUTTER_VERSION` in `ci.yml`** from `flutter --version`, then push and
   let CI run. (F-10-04)
3. **Apply the stage-1 `analysis_options.yaml`.** Measured blast radius near
   zero, and it converts three properties the codebase *happens* to have into
   properties it *must* keep. (F-10-03)
4. **Enable the hooks** — `git config core.hooksPath .githooks`. (F-10-02)
5. **Reconcile `dev` with the 3 commits on `main`; delete both `backup/*`
   branches.** (F-10-09)
6. **Turn on branch protection** once CI is green. (F-10-12)
7. **Declare `.claude/skills/` canonical** and write the direction down. (F-10-11)
8. Stage 2 lints, after a `dart fix` cleanup commit. (F-10-03, F-10-08)
