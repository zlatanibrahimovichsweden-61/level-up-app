# Agent Workflow

How autonomous work is run on this project. Companion to
`docs/AUDIT_PROTOCOL.md` (which covers audit *passes*); this file covers
**building features** and **remediation waves**.

Current project state lives in **`docs/WAVE_STATUS.md`** — read it first. Live
risks live in **`docs/RISKS.md`**.

---

## The canonical loop

Every wave and every feature runs this. Steps are not optional and not
reorderable.

```
DISCOVER → INSPECT → PLAN → IMPLEMENT → FORMAT → ANALYZE → TEST
        → GUARD PROOF (when a rule changed) → AUDIT EVIDENCE
        → COMMIT → FABLE (when required) → NEXT WAVE
```

| Step | Do | Success | Stop if |
| --- | --- | --- | --- |
| **DISCOVER** | Read the brief. Read `WAVE_STATUS.md` and `RISKS.md`. List the findings in scope. | You can name every finding and its current status | A finding is already REJECTED with evidence — do not reopen without *new* evidence |
| **INSPECT** | Re-derive every claim **from source**. Never inherit a prior report's numbers. | Each finding is CONFIRMED, NARROWED or REJECTED with `file:line` | Source contradicts the brief — say so and stop |
| **PLAN** | Smallest correct change. Search for an existing implementation/token/pattern first. | You can state what changes, what does not, and why | The fix needs a decision from §"Stop and ask" |
| **IMPLEMENT** | One batch at a time. Never stack unvalidated batches. | The change is minimal and reversible | Scope grows beyond the finding |
| **FORMAT** | `dart format lib test` | no diff | — |
| **ANALYZE** | included in validate | 0 issues | any issue |
| **TEST** | `powershell -ExecutionPolicy Bypass -File tool\validate.ps1` | **OVERALL: PASS** | any failure — fix, do not weaken |
| **GUARD PROOF** | `powershell -ExecutionPolicy Bypass -File tool\verify_guards.ps1` | every probed guard fires **in isolation** | a guard passes while its rule is broken |
| **AUDIT EVIDENCE** | Update `.ai/audits/current/`. Record the verification **level** (see below). | claims match evidence exactly | you would have to write "verified" for something unobserved |
| **COMMIT** | One concern per commit. Code before the guards enforcing it. | tree clean; each commit independently green | — |
| **FABLE** | Hand off per `AUDIT_PROTOCOL.md` | verdict recorded | — |

### Predict before you run

State the expected test count **before** running validation, then reconcile any
difference explicitly. This has caught real errors repeatedly — a count that
differs from prediction is information, and "close enough" discards it.

### Verification levels

SOURCE → BUILD → ARTEFACT → DEVICE → CI. Defined in `WAVE_STATUS.md`. **Never
report a lower level as a higher one.** Two shipped bugs in this project were
SOURCE-correct and still broken.

---

## Batch discipline

Hand each batch off for validation before starting the next. It is slower and it
is not optional: in Wave 3 it caught two defects the author had introduced,
including one where the fix reproduced the very bug it was fixing.

**Never accumulate unvalidated changes across batches.**

---

## The feature lifecycle

```
Figma frame + contract endpoints
        ↓
Implementation brief
        ↓
Repository inspection  ← reuse search happens HERE, not after
        ↓
Implementation plan    ← approved before any code
        ↓
Implementation
        ↓
Tests (new + existing)
        ↓
Code quality audit
        ↓
Visual QA on a physical device   ← not optional, not automatable
        ↓
Fix → re-test
        ↓
Audit package (if the change warrants it)
        ↓
Fable review (if the change warrants it)
        ↓
Stable git checkpoint
```

**Do not start at "Implementation."** The two expensive failure modes on this
project are building against invented contract shapes, and shipping screens that
miss states or break in Arabic. Steps 3 and 4 close both off cheaply.

---

## Planning is mandatory

Before code, produce a short plan covering:

1. Which **existing components** are reused. Search `lib/core/widgets/`, then the
   feature's own `widgets/`, then sibling features — *before* writing a widget.
2. Route path, params, guard behaviour.
3. State technique, per `01_Flutter_Specs/State_Management.md`: `AsyncNotifier`
   for server data, **Bloc only for the quiz engine**, `setState` only for
   ephemeral local UI. Never network data in `setState`.
4. Files to create, under `lib/features/<feature>/{models,repository,notifier,screens,widgets}`.
5. Which theme tokens are used, and whether any **new** token is genuinely needed.
6. Which of the four states need custom visuals vs `StateWidget` defaults.
7. Which tests are required.
8. Ambiguities — named, not guessed.

The plan is short. A page. Its job is to make the reuse and contract questions
answerable before they become expensive.

---

## Component reuse

Before creating a widget:

1. Search `lib/core/widgets/`
2. Search the current feature's `widgets/`
3. Search sibling features
4. Only then create — and decide deliberately whether it is screen-specific,
   feature-specific, or shared

**This is a live problem, not a hypothetical.** The audit found
`signup_identity_screen.dart` privately re-implementing four core form
primitives — 183 of its 389 lines — and its copy of `PlainTextField` drops
`FieldShell`, which makes it the only screen in the app that shows an error
message with no error border. That is what skipping the search costs.

---

## Theme discipline — hard rule

Never convert a Figma colour into a literal in a widget.

```
Does a semantic token already exist?
   YES → use it
   NO  → is this genuinely a new design token?
           YES → add it to AppColors with BOTH light and dark values
           NO  → you are using the wrong token; find the right one
```

If the correct **dark** value cannot be safely inferred, **document the
uncertainty** in the audit rather than inventing a value. The palette is
`test/core/theme/palette_discipline_test.dart`-enforced and has held with zero
exceptions across 36k lines — do not be the first.

⚠ **The same discipline does not yet exist for typography.** There is no
`TextTheme`, and 153 inline `TextStyle(` sites with hardcoded `fontSize` exist.
Do not add to them.

---

## The ten specialist agents

Used for audit passes and for large or risky features. Each has a fixed scope so
that findings are attributable and coverage is legible.

| # | Agent | Scope |
| --- | --- | --- |
| 1 | Architecture | layers, boundaries, dependency direction, abstractions |
| 2 | Flutter/Dart Quality | idiom, composition, rebuilds, async, duplication, dead code |
| 3 | UI / Figma Fidelity | spacing, typography, assets, states, cross-screen consistency |
| 4 | Design System / Theme | light/dark, tokens, contrast, typography, component theming |
| 5 | Responsive & Accessibility | sizes, text scale, keyboard, safe areas, touch targets, semantics |
| 6 | State & Navigation | Riverpod, Bloc, GoRouter, guards, lifecycle, transitions |
| 7 | API & Data | contract conformance, models, repositories, errors, migration readiness |
| 8 | Testing & QA | coverage, blind spots, brittleness, edge cases |
| 9 | Security & Performance | secrets, PII, storage, logging, release config, rebuilds, memory |
| 10 | DevOps & Workflow | git, CI, hooks, lints, branch protection, documentation |

### Rules for agents

- **Isolated workspaces.** Agents never write to the same branch concurrently.
  Report-only passes write to `.ai/audits/current/<scope>.md` and nothing else.
- **Evidence or silence.** Every finding carries `file:line`. A finding without
  evidence is noise.
- **Classify:** `BUG` · `ARCHITECTURE ISSUE` · `QUALITY IMPROVEMENT` ·
  `OPTIONAL IMPROVEMENT` · `PRODUCT DECISION`.
  **Never silently convert a product decision into an engineering one.**
- **Severity:** `CRITICAL` / `HIGH` / `MEDIUM` / `LOW`.
- **Few real findings beat many nitpicks.** Manufacturing findings to look
  thorough is a failure, not thoroughness.
- **Contradict the brief when the evidence says so.** In the 2026-08-11 pass,
  Agent 5 refuted the brief's claim about Arabic text expansion and Agent 7
  refuted its claim about the mock backend. Both were right. That is the
  behaviour to reward.
- **Respect recorded decisions.** `docs/DECISIONS.md`, `docs/KNOWN_BUGS.md`,
  `docs/DESIGN_ISSUES.md` and `00_Project/Decisions_Log.md` record deliberate
  choices. Re-litigating one without new evidence wastes a finding.

### Orchestrator consolidation

1. Collect reports · 2. Detect overlaps · 3. Detect **conflicts** ·
4. Resolve against project rules and evidence · 5. Independently re-verify
anything filed CRITICAL · 6. Run the suite · 7. Verify `git diff` contains no
unrelated changes · 8. Produce the package.

**Never merge blindly.** Conflicts between agents are signal — record the
resolution, do not average it away.

---

## The DO-NOT-GUESS protocol

Every finding gets exactly one classification. The classification determines who
acts, not how convenient it is.

| | Class | Means | Who acts |
| --- | --- | --- | --- |
| **A** | VERIFIED BUG | reproduced or provable from source | Claude — fix it |
| **B** | LIKELY BUG | needs runtime/device/build evidence | Claude — gather evidence first |
| **C** | DESIGN DECISION REQUIRED | no authoritative answer in Figma or the repo | **Human** |
| **D** | PRODUCT DECISION REQUIRED | changes what the product does or earns | **Human** |
| **E** | REJECTED BY EVIDENCE | investigated, not real | nobody — **record the evidence** |
| **F** | DEFERRED | real, deliberately not now | scheduled, with a reason |
| **G** | BLOCKED | cannot proceed without an external input | named blocker + what unblocks it |

Every finding records: **ID · evidence (`file:line`) · affected files ·
severity · proposed solution · is the solution deterministic? · verification
method · status.**

### The model case — Wave 3D

Figma defines no semantic type scale. The sizes cluster suggestively (four
cover 70% of uses), and it would have been easy to map them.

**That is exactly the trap.** Frequency says 18 is common; it does not say
whether 18 is `titleMedium` or `headlineSmall`. Choosing authors a design system
under the guise of a refactor and freezes it into 49 files.

→ classified **G · BLOCKED**, ratchet held at 153, unblocking inputs named.

**A reasonable-looking guess is still a guess.** The cost of a wrong guess here
is not a bug — it is a fabricated design system that everyone downstream
inherits as fact.

### Never reopen a settled finding without new evidence

`E · REJECTED` findings are listed in `WAVE_STATUS.md` and the Fable verdicts.
Re-litigating one without new repository evidence wastes a wave. If you believe
a rejection is wrong, **produce the evidence first**.

---

## Claude's autonomy

**Proceed without asking** — these are inferable from the repository:

code inspection · behaviour-preserving refactors · tests · guards · CI and hook
fixes · documentation · static-analysis fixes · removing dependencies **proven**
unused · performance fixes with measured justification · bug fixes with
repository-backed evidence.

**Always, without being told:**

- inspect existing architecture before introducing a pattern
- search for an existing implementation before writing a new one
- prefer existing theme tokens; never hardcode a colour if a token exists
- preserve light/dark, RTL/LTR, localization, routing and state-management conventions
- run validation after modifying anything
- add a regression test where practical
- extend a guard when a rule is violated repeatedly
- **document what is unresolved instead of hiding it**

### Stop and ask

Stop when the answer is not in the repository and getting it wrong changes the
product:

- **product intent** — what the app should do
- **visual/design interpretation** not defined in Figma
- **API contract ambiguity** — never invent shapes; raise a change request
- **destructive migration** — storage, schema, irreversible refactors
- **security/privacy trade-offs**
- **business/revenue decisions** — e.g. the `/subscription` entry point (that example is resolved:
  the contract decided it — adr-049 §3; RISKS.md R-6 CLOSED 2026-09-04)
- **user-visible behaviour with no authoritative specification**

### Never invent

typography scales · product behaviour · API semantics · business rules ·
translations · design tokens · navigation intent.

Adding a token is legitimate **only** when the value is demonstrably a
design-system value (see `docs/ENFORCEMENT.md`). Inventing one to satisfy a
guard is a false fix.

---

## Refactoring boundary

```
Is this change necessary for correctness, security, the architecture the
current feature requires, preventing duplication, or preventing a known defect?

  YES → do it, if it is safe and testable
  NO  → record it as a separate improvement and move on
```

Unrelated mass refactoring is out of scope by default, however tempting the code
looks. Record it; don't do it.

---

## Learning loop

```
Mistake → Fix → Rule → Future prevention
```

When a mistake recurs:

1. Fix the instance.
2. Ask whether it represents a **missing rule**.
3. If so, put the rule in its **one correct home** (see `PROJECT_GUIDE.md` §2) —
   do not add a fourth copy.
4. **Ask whether it can be a test instead of prose.** The audit's central finding
   is that mechanised rules hold and prose rules decay. A rule that cannot be
   mechanised should say why.
5. Record it in `docs/KNOWN_BUGS.md` with the *"why tests missed it"* note. That
   note is the most valuable part of the entry — BUG-001's is why the whole
   direct-pump-vs-router-driven blind spot is now understood.
