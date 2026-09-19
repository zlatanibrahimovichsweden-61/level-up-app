# Level Up — Project Guide

**The entry point. Start here.**

This is an **index and a hierarchy**, not a rulebook. It says where each rule
lives and which source wins when two disagree. It deliberately does not restate
rules that already have homes — duplicating them is how they drift.

Last grounded: 2026-08-11, `dev` @ `e3651e6`.

---

## 1. Source-of-truth hierarchy

When two sources conflict, **the higher one wins.**

| # | Source | Where |
| --- | --- | --- |
| 1 | **Product requirements** | The owner. Not written down in one place — ask. |
| 2 | **API contract** | `contract/openapi.yaml` + `contract/error-codes.md`. Authoritative over design. |
| 3 | **Figma / design intent** | File key `P6044i0giD9TmdQ7C2AmLq`. Node ids in `docs/PROGRESS.md` and the day briefs. |
| 4 | **Existing project architecture** | The code, then `level_up/01_Flutter_Specs/`. ⚠ see §4. |
| 5 | **Project-wide engineering rules** | `.claude/skills/` + `level_up/01_Flutter_Specs/` |
| 6 | **Feature-specific rules** | `docs/day*_brief.md` |
| 7 | **Task instructions** | The current brief |
| 8 | **Implementation decisions** | `docs/DECISIONS.md` |

**Contract beats design.** This is settled and has already been exercised: OTP is
6 digits not 4, the phone prefix is `+20` not `+02`, dark is a real purple
palette not an inverted light one, and the student phone is read-only because it
is bound to the registration token. When Figma and the contract disagree, build
the contract's way and log it in `docs/DESIGN_ISSUES.md`.

**Figma MCP output is structured input, not truth.** It routinely misses shadows,
subtle borders, opacity, gradients, responsive intent, interaction behaviour and
semantic tokens. Extract with it, then verify on a device against the frame.

---

## 2. Where every rule lives

| Topic | Home | Notes |
| --- | --- | --- |
| Architecture & folders | `level_up/01_Flutter_Specs/Architecture_and_Folders.md` | ⚠ **known stale** — wrong in 5 of ~10 assertions. The code is right in 4 of 5. Fix the doc. |
| State management | `01_Flutter_Specs/State_Management.md` + `.claude/skills/river`, `.claude/skills/bloc` | Riverpod everywhere; **Bloc only for the quiz engine** |
| Screen states | `.claude/skills/screen-states/SKILL.md` | loading / empty / error / offline × AR/EN = 8 checks |
| Building a screen | `.claude/skills/build-screen/SKILL.md` | The standard loop |
| API contract | `contract/` + `.claude/skills/seif-api-contract` | Never invent shapes — raise a change request |
| Networking & errors | `01_Flutter_Specs/Networking_and_API.md`, `contract/error-codes.md` | |
| Models & serialization | `01_Flutter_Specs/Models_and_Serialization.md` | freezed + json_serializable, **generated code is committed** |
| Navigation | `01_Flutter_Specs/Navigation_and_Deep_Links.md` | GoRouter, one file: `lib/core/router/app_router.dart` |
| Theme & design system | `lib/core/theme/app_colors.dart` (the tokens *are* the doc) + `docs/DESIGN_ISSUES.md` | ⚠ **no `TextTheme` exists** — typography is unenforced |
| **Responsive & text scaling** | **`docs/RESPONSIVE.md`** | **New.** Previously had no home anywhere |
| i18n / RTL | `01_Flutter_Specs/i18n_and_RTL.md`, `l10n.yaml`, `lib/l10n/*.arb` | Arabic is the baseline, not an edge case |
| Storage & security | `01_Flutter_Specs/Storage_and_Security.md` | Tokens → secure storage; prefs → shared_preferences |
| Performance | `01_Flutter_Specs/Performance.md` | ⚠ its `select()` rule is currently violated 70/70 |
| Testing | `01_Flutter_Specs/Testing_and_Quality.md` + `.claude/skills/dart-*`, `flutter-add-*-test` | |
| Common mistakes | `01_Flutter_Specs/Flutter_Common_Mistakes.md` | |
| Glossary | `level_up/00_Project/Glossary.md` | Use terms **verbatim** in class, field, file and route names |
| Assets | `docs/ASSET_MANIFEST.md` | Flutter asset dirs are **not recursive** |
| Release signing | `docs/RELEASE_SIGNING.md` | |
| Decisions | `docs/DECISIONS.md` + `00_Project/Decisions_Log.md` | |
| Bugs | `docs/KNOWN_BUGS.md` | Entries keep their history — the "why tests missed it" note is the point |
| Design ↔ contract gaps | `docs/DESIGN_ISSUES.md` | |
| **Project state** | **`docs/WAVE_STATUS.md`** | **Wave status, verification levels, open findings, ratchets. If another doc disagrees, this one wins.** |
| **Active risks** | **`docs/RISKS.md`** | **Live risk register — every entry has an owner and a next action.** |
| **Automated enforcement** | **`docs/ENFORCEMENT.md`** | **Every rule a machine checks, and how. Read before writing a new rule.** |
| Agent workflow | `docs/AGENT_WORKFLOW.md` | The canonical loop, the DO-NOT-GUESS protocol, Claude's autonomy boundaries |
| Audit protocol | `docs/AUDIT_PROTOCOL.md` | Running an audit; the Fable handoff |
| Current audit | `.ai/audits/current/` | |

---

## 3. The project in one screen

**Stack.** Flutter stable · Riverpod (state *and* DI — no get_it) · Bloc for the
quiz engine only · GoRouter · Dio + two interceptors · freezed +
json_serializable · flutter_secure_storage · gen-l10n (en/ar) · Pinput ·
bundled Inter/Tajawal/Cairo (no `google_fonts` — works offline).

**Layout.**
```
lib/
  core/      config · models · network/interceptors · providers · router · storage · theme · widgets
  features/  <feature>/{models,repository,notifier,screens,widgets}
  dev/       mock_backend.dart — mock entrypoint only, never shipped
  l10n/      *.arb + generated AppLocalizations
```

Features: auth · registration · home · catalog · quiz · profile · settings ·
subscription (four `.gitkeep` scaffold dirs, never populated since `5e4a512`; the purchase routes
were removed in `5c4b855`/D-007 — the app is purchase-silent, adr-049 §3) ·
track · onboarding · shell · account_shells.

**Entrypoints.** `main_dev` · `main_staging` · `main_prod` · `main_mock`,
selected via `lib/core/config/app_config.dart`.
⚠ Only the prod base URL is still a `TBD.example` placeholder (`app_config.dart:54`). Dev and
staging use the real staging host since `67bdcc1` (`app_config.dart:43`).

**Scale.** 178 files / ~36k LOC in `lib`; 66 files / ~15k LOC in `test`
(run `flutter test` for the current count); 22 of 36 contract paths consumed — **all 21 stable
ones**, and every remaining path is `x-stability: draft`.

**Git.** `main` = stable, `dev` = active. Conventional Commits, **43/43**.
Never force-push either long-lived branch.

---

## 4. Read this before trusting any document here

The audit found **eight documented rules that current code violates**, and the
cause is not carelessness — it is that **prose rules are not enforced and decay,
while mechanised rules hold perfectly.**

The evidence is stark. The one rule with a guard test —
`test/core/theme/palette_discipline_test.dart` — has held across 36k lines with
**zero** exceptions: there is not a single hardcoded colour outside the theme
layer. Every rule left as prose has drifted:

- `Performance.md:13` mandates `ref.watch(...select(...))` → **0 of 70** sites use it
- `state_widget.dart:5` says it is "the ONLY place that switches on `ScreenState`" → **4** parallel implementations exist
- `circle_back_button.dart:12-14` says it was created to stop back-chip drift → **3** forks exist
- `screen-states/SKILL.md` mandates AR + EN verification → **0** Arabic goldens
- `Architecture_and_Folders.md` → wrong in 5 of ~10 assertions

**Therefore: when a document and the code disagree, check which is right before
"fixing" either.** Four times out of five in this audit, the code was correct and
the document was stale.

**And when you write a new rule, ask whether it can be a test instead.** A rule
that cannot be mechanised should say so and say why.

Wave 2 acted on this: bloc containment, the BUG-001 `initState` rule, ARB
parity, localization leaks and typography drift are now tests rather than prose,
and the guards are themselves tested against their own comments. See
`docs/ENFORCEMENT.md` — including the list of rules deliberately left to human
review, so what a reviewer is actually responsible for stays honest.

---

## 5. Definition of Done

A screen is not done because tests pass.

**Functional** — success · failure · loading · empty/offline where applicable
**Architecture** — correct layer · correct state technique · components reused
**Design** — Figma-checked: spacing, typography, colour, shadow, radius, assets
**Platform** — light · dark · RTL · LTR · text scale · keyboard
**Testing** — relevant tests pass · meaningful new tests added · full suite at a checkpoint
**Quality** — analyzer clean · formatter clean · no secrets · no unrelated edits
**Review** — audit done · Fable review where warranted · findings resolved
**Git** — stable checkpoint · `main` protected · reproducible

**Visual QA on a physical device is mandatory and is not replaceable by
automation.** The audit's own CRITICAL finding proves why: the release APK
appears to be missing the `INTERNET` permission, which **compiles cleanly and
passes every test**. Only a device catches that class.

---

## 6. Running the quality gate

```powershell
powershell -ExecutionPolicy Bypass -File tool\validate.ps1   # Windows
```
```sh
sh tool/validate.sh                                          # Git Bash / macOS / Linux
```

**This is the canonical command.** Format → analyze → full test suite, including
every automated guard. Continues past failures rather than stopping at the
first, and writes a self-contained record to
`.ai/audits/current/test-results.md` — toolchain versions, branch, commit, full
output.

The same definition runs in three places, so "it passed locally" means the same
thing everywhere:

```
developer  →  tool/validate.*  ←  pre-push hook
                    ↑
                   CI  (authoritative)
```

**SDK pin.** `.flutter-version` at the repo root is the single source of truth —
currently **3.44.7**, the version the suite was validated against. CI reads that
file; `validate.*` warns if your local SDK differs. To move it: run
`flutter --version`, update the file, re-run the suite before committing.

**Optional hooks** — opt-in, and deliberately so:

```sh
git config core.hooksPath .githooks     # enable
git config --unset core.hooksPath       # disable
```

`pre-commit` checks format + analyze on **staged files only** (seconds, and it
never rewrites your diff). `pre-push` runs the canonical validation, and skips
entirely when a push touches no Dart or config. Both honour `--no-verify` and
`LEVELUP_SKIP_HOOKS=1`. CI remains authoritative — hooks are early feedback,
not the only protection.

**Automated rules** — see `docs/ENFORCEMENT.md` for the full list of what is
mechanically enforced, what is a ratchet, and what deliberately remains human
review.

**Release verification** — `tool/verify_release_manifest.ps1` builds a release
APK and proves with `aapt2` that it carries `android.permission.INTERNET`.
Source inspection is not proof; that was Tier-0 C-1.

**Guard proof** — `tool/verify_guards.ps1` breaks each rule on purpose and
proves the responsible guard fires **in isolation**. A guard that has only run
against a clean codebase has demonstrated nothing.

### The validation contract

| Command | Required result |
| --- | --- |
| `tool\validate.ps1` | format **PASS** · analyze **PASS** · tests **PASS** · **OVERALL: PASS** |
| `tool\verify_guards.ps1` | every probed guard fires; tree restored, SHA-verified |

**A green static check is not runtime proof.** Claims carry a level —
SOURCE / BUILD / ARTEFACT / DEVICE / CI — defined in `docs/WAVE_STATUS.md`.
Never report a lower level as a higher one. This project has shipped two bugs
that were SOURCE-correct and still broken: the release manifest that lost
`INTERNET` at merge time, and a PowerShell script whose *content* was verified
while its *decoding* was not.
