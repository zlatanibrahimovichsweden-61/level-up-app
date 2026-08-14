# Decisions taken during this audit

Judgement calls made by the orchestrator, recorded so they can be challenged.
Each states what was decided, why, and what would change the answer.

---

## D-1 · Report-only. No application code was touched.

**Decided:** all ten agents were forbidden from editing `lib/`, `test/`,
`android/`, `ios/`, `assets/`, `pubspec.yaml` or `analysis_options.yaml`.

**Why:** no Dart toolchain was available, so the ~730-case suite could not be
run. A change that cannot be validated cannot be shown not to have broken
something. With a codebase this healthy, unvalidated edits trade a known-good
state for an unknown one.

**What would change it:** a working toolchain. With the suite runnable, Tier-0
and Tier-1 fixes in `known-issues.md` are small and well-specified enough to
apply directly.

**Confirmed with the developer before starting.**

---

## D-2 · Infrastructure *was* written, despite D-1.

**Decided:** CI, hooks and validation scripts were created; app code was not.

**Why:** these files are inert. The workflow does not run until pushed to
GitHub; the hooks do nothing until `core.hooksPath` is set; the scripts do
nothing until invoked. None can change app behaviour. And `tool/validate.*` is
the instrument that lifts the D-1 constraint, so writing it was a precondition
for the next pass.

---

## D-3 · Two findings were raised above what the agents filed.

**Decided:** the missing `INTERNET` permission and the logout data leak were
promoted from HIGH to CRITICAL.

**Why:** both were **independently re-verified by the orchestrator** rather than
accepted on report. The permission finding means the app cannot function in
release at all — there is no severity below CRITICAL for "does not work when
shipped". The logout finding was filed HIGH twice, by Agent 6 (state
correctness) and Agent 9 (data protection); the two angles compound into
disclosure of a minor's PII on shared hardware.

**What would change it:** for C-1, a merged release manifest that does contain
`INTERNET` via a plugin — the exact command to check is in `known-issues.md`.

---

## D-4 · The eight-document structure in the brief was deliberately not built.

**Decided:** four documents were created — `PROJECT_GUIDE.md`, `RESPONSIVE.md`,
`AGENT_WORKFLOW.md`, `AUDIT_PROTOCOL.md` — rather than the eight the mission
brief listed.

**Why:** the brief also says *"Do not duplicate the same rule across many
documents. Every rule should have a clear home."* Those two instructions
conflict here, because four of the eight proposed documents describe rules that
**already have homes**:

| Proposed | Already lives at | Verdict |
| --- | --- | --- |
| `ARCHITECTURE.md` | `level_up/01_Flutter_Specs/Architecture_and_Folders.md` | Don't duplicate — **fix the existing one** (it is wrong in 5 of ~10 assertions, K-35) |
| `TESTING.md` | `01_Flutter_Specs/Testing_and_Quality.md` + `.claude/skills/dart-*`, `flutter-add-*-test` | Don't duplicate — extend |
| `DESIGN_SYSTEM.md` | `lib/core/theme/app_colors.dart` (heavily documented) + `docs/DESIGN_ISSUES.md` + `docs/ASSET_MANIFEST.md` | Don't duplicate |
| `API_CONTRACTS.md` | `contract/` (`openapi.yaml`, `SOURCE.md`, `error-codes.md`, `contract-changelog.md`) + `.claude/skills/seif-api-contract` | Don't duplicate — the contract **is** the document |

Creating four more files restating those would have made drift *more* likely,
which is the exact problem in `project-audit.md` §4. `RESPONSIVE.md` was created
because it is the one rule with genuinely **no home anywhere**.

`PROJECT_GUIDE.md` is therefore an **index and hierarchy**, not a rulebook — it
says where each rule lives and which source wins in a conflict.

**What would change it:** if the vault is ever decoupled from the app repo,
`ARCHITECTURE.md` and `TESTING.md` would need in-repo homes.

---

## D-5 · `.claude/skills/` is recommended as canonical over the vault.

**Decided:** recommend the app repo's copy as the single source, with vault
copies as read-only mirrors.

**Why:** it is version-controlled alongside the code it describes, it is what
the coding agent actually loads, and a skill change lands in the same commit as
the code change that motivated it. Rejected alternatives: **symlinks** (break on
Windows without developer mode; this developer is on Windows), **git submodule**
(heavyweight for 22 markdown files), **sync script** (must be remembered — which
is the problem it claims to solve).

**Note this is a recommendation, not an applied change.** Nothing was moved or
deleted. The 7 project skills remain byte-identical in both locations.

---

## D-6 · Three agent findings were left as PRODUCT DECISIONS, not converted to engineering ones.

The brief is explicit that this line must not be crossed silently.

1. **Clamping `textScaler` at 1.3** (K-11) fixes 20 of 22 responsive defects for
   three lines — but it overrides a user's accessibility setting. That is a
   product call about an education app used by students who may need large text.
   **Not decided here.** Whichever way it goes, it needs a `DECISIONS.md` entry.
2. **Dark `hint` and light `mutedText` colour values** (K-5, K-6) are contrast
   defects with no correct value derivable from code. Inventing one would violate
   the theme rule about not guessing dark values. **Design must supply them.**
3. **Arabic w600** (K-10): Tajawal ships no semibold and 45 sites request it.
   Adding a face, remapping to w700, or accepting synthetic bolding are three
   different design answers. **Not decided here.**

---

## D-7 · Agents were told to prefer few real findings over many nitpicks.

**Decided:** the shared brief said explicitly *"An agent that reports 3 real
issues beats one that reports 20 nitpicks"* and *"Do not manufacture findings to
look thorough."*

**Why:** the failure mode of a ten-agent audit is volume — 200 low-severity
observations that bury the two that matter.

**Observable effect:** agents pushed back on the orchestrator's own premises
three times. Agent 5 **refuted** the briefed claim that Arabic text runs 20–30%
longer, by reading the actual ARB pairs. Agent 7 **corrected** the briefed
assumption that the mock backend only emits happy responses. Agent 4 found
`Brand.*` correctly sealed and all 15 `Colors.*` uses benign, and said so rather
than padding. Those corrections are recorded in `project-audit.md` §3 and are
better evidence of a working process than a longer defect list would have been.

---

## D-8 · Agent 10's work was completed by the orchestrator after it crashed.

**Decided:** when the Agent-10 subagent was terminated mid-stream by an API
error — after writing `ci.yml` and both hooks, before writing `validate.ps1` or
its report — the orchestrator finished the job rather than re-running the agent.

**Why:** the surviving artefacts were high quality and evidently research-backed
(they cite the committed-generated-files finding, the Windows-golden platform
issue, and the `-Xmx8G` Gradle setting — all independently re-verified as
correct). Re-running would have re-derived the same conclusions at full cost.

**How the risk was handled:** the orchestrator re-derived every figure in
`devops.md` from the repository directly rather than inheriting the subagent's
claims, and the provenance is disclosed at the top of that report. All figures
held.

---

## D-9 · Scope of validation was stated rather than papered over.

**Decided:** `test-results.md` exists as an explicit **UNVERIFIED** marker rather
than being omitted, and it records three falsifiable predictions about what the
suite will show.

**Why:** the failure mode of an audit package is a reader assuming coverage that
does not exist. Making the gap a named artefact, with predictions that can be
scored, is more useful than silence — and if a prediction is wrong, that is
itself a finding about this audit's quality.
