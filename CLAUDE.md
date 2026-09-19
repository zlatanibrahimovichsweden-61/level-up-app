# CLAUDE.md — standing context for Level Up

This file is loaded automatically at the start of every Claude Code session in this repository.
It exists so nobody has to paste context in by hand.

It mirrors the **HOW TO USE THIS FILE** section of `tell_claude.md`, the migration handoff
written 2026-08-20. If `tell_claude.md` is still present in this folder, **read it first,
end to end** — it is far longer and carries the full state of the project. Once it has been
deleted (per its own read-receipt protocol), this file is the standing context and
`docs/WAVE_STATUS.md` is the live source of truth.

---

## HOW TO USE THIS FILE

### 1.1 What you are

You are the Flutter front-end engineering assistant on **Level Up**. You are not being asked
to re-derive this project. It has been running since 2026-07-19 and has 63 commits, ~36k lines
of `lib/`, 849 passing tests, 12 day-briefs, 29 documents in `docs/`, 27 audit reports in
`.ai/audits/current/`, a vendored API contract, and a design-gap register with 48 entries.
Everything below is sourced from those files.

### 1.2 Read order — do not skip

1. **This file, all of it, top to bottom.** It ends with a COOKIE (§14) that proves you did.
2. Then, before touching code, read in this order:
   - `docs/WAVE_STATUS.md` — **the single source of project truth.** If any other document
     (including this one) disagrees with it about wave state, that file wins.
   - `docs/RISKS.md` — the live risk register. Eight open risks, each with an owner.
   - `docs/PROJECT_GUIDE.md` — the index. Says where every rule lives and which source wins.
   - `docs/AGENT_WORKFLOW.md` — the canonical loop and the DO-NOT-GUESS protocol.
   - `contract/SOURCE.md` — which contract commit is pinned right now.
3. Read a `docs/day*_brief.md` only when working on that feature. They are **dated records**,
   not current state. Contract references in every brief are **stale** — Days 00–7b cite
   `23f0535`, Days 7c–8 cite `ee2ed8f`, Day 9 cites `61905ce`, and the pin has since moved to
   `184d6ec` (3.0.0-m1). The Day 7, 7b, 7c, 8 and 9 briefs carry dated superseded-pin banners
   (2026-09-05); the earlier briefs do not. `contract/SOURCE.md` is the truth.

### 1.3 The five rules that matter more than the rest

These are the rules this project has actually paid for, in bugs.

1. **The contract wins.** `contract/openapi.yaml` beats Figma, beats a brief, beats your
   intuition. Where design and contract disagree, build the contract's way and log the
   divergence in `docs/DESIGN_ISSUES.md`. Where the contract is *missing* something, **stop
   and file a question in `docs/seif_fight.md`** — never invent a shape. Source:
   `docs/PROJECT_GUIDE.md` §1, `.claude/skills/seif-api-contract/SKILL.md`.
2. **Reading is not running.** Every claim carries a verification level —
   SOURCE → BUILD → ARTEFACT → DEVICE → CI. Never report a lower level as a higher one. This
   project has shipped two bugs that were SOURCE-correct and still broken (the release manifest
   that lost `INTERNET` at merge time; a PowerShell script whose *content* was verified while
   its *decoding* was not). Source: `docs/WAVE_STATUS.md`.
3. **Prose rules decay; mechanised rules hold.** The one rule with a guard test — the colour
   palette — has held across 36k lines with zero exceptions. Every rule left as prose has
   drifted (`select()` mandated in three spec files, used 0/70 times). When you write a new
   rule, ask first whether it can be a test. Source: `docs/ENFORCEMENT.md`.
4. **Never invent.** Typography scales, product behaviour, API semantics, business rules,
   translations, design tokens, navigation intent. A reasonable-looking guess is still a guess,
   and here a wrong guess becomes "the design system" that everyone downstream inherits as
   fact. Source: `docs/AGENT_WORKFLOW.md` §"Never invent".
5. **The owner is not a rubber stamp.** Product intent, visual interpretation not in Figma,
   contract ambiguity, destructive migrations, security/privacy trade-offs, and
   business/revenue decisions all **stop and ask**. Everything else in §10.3 you just do.

### 1.4 What to do when a document and the code disagree

Check which is right *before* "fixing" either. In the 2026-08-11 ten-agent audit, **four times
out of five the code was correct and the document was stale**
(`docs/PROJECT_GUIDE.md` §4). `level_up/01_Flutter_Specs/Architecture_and_Folders.md` is
specifically known wrong in 5 of ~10 assertions.

### 1.5 Marker conventions used in this file

- `[INFERRED]` — I concluded this from evidence in the repo; it is not stated anywhere.
- `[UNVERIFIED]` — I could not check it from this session. Treat as a lead, not a fact.
- `[UNVERIFIED — source unreachable]` — a source the owner asked me to mine that this session
  could not reach. See §1.6.
- Bare claims with a `path:line` or a filename are quoted or paraphrased from that file.

### 1.6 Sources that were requested and could NOT be read — a real gap

The owner asked for two sources outside the repo. **Neither was reachable from this session**
and their content is therefore absent from this file:

| Source requested | Result |
| --- | --- |
| `C:\Users\musta\.claude\projects\**\*.jsonl` — Claude Code CLI transcripts | **Unreachable.** `device_request_folder_access` refused the path three times (`~\.claude`, `~\AppData\Roaming\Claude`, `C:\Users\musta\.claude\projects`). The device home-directory skeleton lists `.cagent`, `.copilot`, `.cursor` but **no `.claude`** — so either the folder does not exist under that profile or it is filtered from the listing. |
| `%APPDATA%\Claude\local-agent-mode-sessions\` — Cowork session outputs | **Unreachable**, same refusal. |

**What this costs you:** decisions, rejected approaches and bug-hunts that were only ever
discussed in chat and never written into a repo file are lost. **What softens it:** this
project has an unusually strong habit of writing decisions into files —
`docs/DECISIONS.md`, `docs/KNOWN_BUGS.md`, `docs/DESIGN_ISSUES.md`, `docs/seif_fight.md`,
the twelve day-briefs and the commit messages carry the reasoning, not just the outcome.
The commit bodies in particular are unusually long and are a primary source (see §7).

The username on the machine is **`musta`** (recovered from a path inside
`.claude/settings.local.json`), so if a future session gets folder access, the path to try is
`C:\Users\musta\.claude\projects\F--level-level-up-level-up-app\`. `[INFERRED]` — that
directory-name mangling pattern appears in
`.claude/settings.local.json`'s temp path `C:/Users/musta/AppData/Local/Temp/claude/F--level-level-up-level-up-app/`.

### 1.7 Your first five minutes

```powershell
cd F:\level\level_up\level_up_app
git status --short          # expect a dirty tree — see §3.4, do not "clean" it
git log --oneline -5
Get-Content docs\WAVE_STATUS.md
powershell -ExecutionPolicy Bypass -File tool\validate.ps1
```

Expect `OVERALL: PASS` and a test count **at or above 849**. If it is lower, something
regressed — find out what before doing anything else.

### 1.8 Finally

Do §14 (THE COOKIE). It is the migration's completion signal.

---


## Quick reference

| Need | Go to |
| --- | --- |
| What is true about the project **right now** | `docs/WAVE_STATUS.md` — **wins over every other document** |
| Live risks, each with an owner | `docs/RISKS.md` |
| Where every rule lives, and which source wins | `docs/PROJECT_GUIDE.md` |
| The build/remediation loop and autonomy boundaries | `docs/AGENT_WORKFLOW.md` |
| Running an audit; the Fable handoff contract | `docs/AUDIT_PROTOCOL.md` |
| What a machine checks, and what is left to humans | `docs/ENFORCEMENT.md` |
| Decisions with their reasoning and rejected alternatives | `docs/DECISIONS.md` |
| Runtime defects, incl. "why tests missed it" | `docs/KNOWN_BUGS.md` |
| Design ↔ contract gaps (48 entries) | `docs/DESIGN_ISSUES.md` |
| Open questions for Seif (backend) | `docs/seif_fight.md` |
| Responsive & text-scaling rules (**proposed, not applied**) | `docs/RESPONSIVE.md` |
| Which contract commit is pinned | `contract/SOURCE.md` |
| The ordered fix queue | `.ai/audits/current/known-issues.md` |
| Feature-specific rules | `docs/day*_brief.md` — **dated records, not current state** |

## The one command

```powershell
powershell -ExecutionPolicy Bypass -File tool\validate.ps1   # Windows
```
```sh
sh tool/validate.sh                                          # Git Bash / macOS / Linux
```

Format → analyze → the full test suite including every guard. Required result:
**OVERALL: PASS**. It writes a self-contained record to `.ai/audits/current/test-results.md`.

To prove a guard can actually fail:

```powershell
powershell -ExecutionPolicy Bypass -File tool\verify_guards.ps1
```

## Non-negotiables, in one screen

- **The contract wins.** `contract/openapi.yaml` beats Figma, beats a brief, beats intuition.
  Build only against `x-stability: stable`. Never invent a shape — file it in
  `docs/seif_fight.md`.
- **Do not edit anything under `contract/`.** It is vendored from Seif's repo.
- **No colour outside `lib/core/theme/`.** Guard-enforced, zero exceptions across 36k lines.
- **No new hardcoded `fontSize`.** The ratchet is **0** — one inline `fontSize` outside
  `lib/core/theme/` fails the suite in two places. The guard bans inline `fontWeight:` too, so
  `.copyWith(fontWeight: …)` is not an escape hatch; switch to a differently-named `AppType` style.
  (This line used to read "the ratchet is 153 and Wave 3D is BLOCKED". Both were true until
  2026-08-21, when the designer supplied the scale and all 153 call sites were migrated; Wave 3D
  closed 2026-08-21 and the ratchet reached 0 on 2026-08-22 — `WAVE_STATUS.md:193`, `:295`.)
- **Bloc only in `lib/features/quiz/`.** Everything else is Riverpod. Guard-enforced.
- **No provider mutation in `initState`** (BUG-001). Guard-enforced.
- **All user-facing copy through `AppLocalizations`**, both ARB files, parity guard-enforced.
- **Never log personal data, tokens, or request/response bodies.** Many users are minors.
  No debug-build exemption.
- **Reading is not running.** SOURCE → BUILD → ARTEFACT → DEVICE → CI. Never round up.
- **Never force-push `main` or `dev`.** Conventional Commits; one concern per commit;
  commit bodies carry the reasoning, not a summary of the diff.
