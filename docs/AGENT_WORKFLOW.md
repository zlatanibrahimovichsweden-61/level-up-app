# Agent Workflow

How autonomous work is run on this project. Companion to
`docs/AUDIT_PROTOCOL.md` (which covers audit *passes*); this file covers
**building features**.

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
