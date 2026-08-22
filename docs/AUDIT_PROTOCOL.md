# Audit Protocol

How to run an audit pass and what its output must contain.
Companion to `docs/AGENT_WORKFLOW.md`.

---

## Layout

```
.ai/
  audits/
    current/
      _AGENT_CONTEXT.md          shared brief — every agent reads this first
      architecture.md            agent 1
      flutter-quality.md         agent 2
      ui.md                      agent 3
      theme.md                   agent 4
      responsive.md              agent 5
      state-navigation.md        agent 6
      api-data.md                agent 7
      testing.md                 agent 8
      security-performance.md    agent 9
      devops.md                  agent 10

      project-audit.md           consolidated, de-duplicated register
      changed-files.md           exactly what was touched
      test-results.md            produced by tool/validate.*
      known-issues.md            the ordered fix queue
      decisions.md               judgement calls, so they can be challenged
      risks.md                   risks in the project AND in the audit
      final-summary.md
      FABLE_REVIEW_BRIEF.md
    archive/
      YYYY-MM-DD/                previous passes, moved wholesale
```

Audit artefacts stay in `.ai/` and never mix into `lib/`.

---

## Before you start

1. **Working tree clean.** Record the branch and commit — everything is relative
   to that baseline.
2. **Write `_AGENT_CONTEXT.md` first.** Ten agents each re-deriving the project
   shape is the single largest waste in a pass. Put the measured facts in the
   shared brief: file counts, the state-management split, what's already known
   broken. Include the constraints (what agents may write; whether a toolchain
   exists).
3. **State the toolchain situation explicitly.** If tests cannot be run, say so
   in the brief and in `test-results.md`. An audit that quietly implies
   verification it did not perform is worse than one that admits the gap.
4. **Decide report-only vs implement.** If the suite cannot be run, report-only
   is the only defensible choice.

---

## Required report shape

Every agent produces:

```
# Agent N — <name>

**Scope:**
**Baseline:** <branch> @ <sha>
**Repository areas inspected:** (paths actually read)

## Findings

### F-N-01 [SEVERITY] [CATEGORY] <one-line title>
**Evidence:** `path/file.dart:123` — <quote or precise description>
**Why it matters:**
**Recommended fix:**
**Risk of fixing:**
**Validation required:**

## Changes Made
## Files Changed
## Tests Run
## Test Results
## Remaining Risks
## Deferred Improvements
## Recommendations (ranked)
```

Target 150–400 lines. Evidence over prose.

---

## Rules

- **`file:line` or it didn't happen.**
- **Record positives explicitly.** "Checked X, found it correct" tells the next
  reader which ground is covered so it isn't re-audited. An audit that lists only
  defects misrepresents the codebase.
- **Do not manufacture findings.** Three real issues beat twenty nitpicks.
- **Contradict the brief when evidence demands it**, and say so loudly. Two
  agents did this in the 2026-08-11 pass and both were right.
- **Never convert a `PRODUCT DECISION` into an engineering one.** Flag it and
  leave it.
- **Independently re-verify anything filed CRITICAL** before it reaches the
  package. The orchestrator does this, not the agent that filed it.
- **Preserve the conflicts.** Where two agents disagree, record the tension and
  the resolution in `project-audit.md`. Do not smooth it over.

---

## Consolidation checklist

1. Collect all ten reports
2. Detect overlapping findings → merge, keeping both agent IDs
3. Detect conflicting findings → resolve against evidence, **record the reasoning**
4. Re-verify every CRITICAL independently
5. Normalise severity across agents
6. Run `tool/validate.*`; paste the result into `test-results.md`
7. `git status --short` and `git diff --stat` — confirm nothing unrelated moved
8. Write `project-audit.md`, `changed-files.md`, `known-issues.md`,
   `decisions.md`, `risks.md`, `final-summary.md`
9. Write `FABLE_REVIEW_BRIEF.md` — including **what to attack**

---

## The Fable handoff — required contents

A wave is not ready for review until all ten are present. Anything missing is
itself a finding.

1. **Wave scope** — what was in, what was explicitly out
2. **Files changed** — complete, with `git status` proving nothing else moved
3. **Commits** — SHAs and messages
4. **Validation result** — verbatim `validate.ps1` output, not a summary
5. **Guard proof result** — `verify_guards.ps1`, N/N
6. **Runtime / build evidence** — with its **verification level** (SOURCE /
   BUILD / ARTEFACT / DEVICE / CI). Say which; never round up.
7. **Known limitations** — including what a guard *cannot* catch
8. **Deferred findings** — with reasons
9. **Rejected findings** — with the evidence that rejects them
10. **Design/product decisions still required** — named, with what would unblock

**Tell Fable where the work is weakest.** A handoff that only presents strengths
wastes the review. Every Fable pass in this project has found something real,
and the passes that found the most were the ones pointed at their own soft spots.

### Fable verifies, never trusts

Fable must independently re-derive claims from the repository. "Claude reported
X" is not evidence. Fable has already caught: a guard harness that proved the
wrong thing, a bare `xargs` in the canonical script, and an incomplete lifecycle
fix (W3-1) — none of which the implementation report flagged as suspect.

### Finding severity

`CRITICAL` · `HIGH` · `MEDIUM` · `LOW` · `INFORMATIONAL`

Weight by **impact × likelihood of going unnoticed**. A defect no gate can
detect outranks a louder one something would catch.

### After the verdict

```
Fable verdict
  → fix valid findings          (smallest correct change)
  → record rejected findings    (with evidence, so they stay rejected)
  → rerun validation            (validate + guard proof)
  → commit remediation
  → update WAVE_STATUS.md and RISKS.md
  → only then advance
```

**Never advance with an unrecorded open finding.** W3-1 is open and is recorded
in both `WAVE_STATUS.md` and `RISKS.md`; that is what "recorded" means.

**Never fix a bug found during a documentation wave as part of that wave.**
Record it, report it, fix it deliberately. Wave 4 found W3-1 outstanding and
left the code untouched.

---

## Fable's role

Fable is the **final independent reviewer**, not the discoverer. Opus does the
expensive work first; Fable challenges it.

Fable receives: the ten reports, `project-audit.md`, `changed-files.md`,
`test-results.md`, `known-issues.md`, `decisions.md`, `risks.md`,
`final-summary.md`.

Fable's job is **adversarial**: find missed bugs, unjustified severities,
architectural inconsistencies, theme violations, hardcoded values, test gaps,
security problems, CI mistakes, bad abstractions, regressions, and contradictions
between the project's rules and its implementation. Confirming that the work
looks good is not the assignment.

**A good package tells Fable where it is weakest.** `FABLE_REVIEW_BRIEF.md` must
name the findings most likely to be wrong and the shortcuts taken.

### Verdict

`APPROVED` · `APPROVED WITH WARNINGS` · `REJECTED`

If rejected, each issue must carry:

```
Issue · Severity · Evidence · Required Fix · Suggested Location · Validation Required
```

Then: Opus fixes → tests → audit → Fable re-review. Repeat until the acceptance
criteria hold.

---

## Archiving

When a pass closes, move `current/` wholesale to `archive/YYYY-MM-DD/` and start
the next one clean. Never edit an archived report — a superseded finding is part
of the record.
