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
| Agent workflow | `docs/AGENT_WORKFLOW.md` | |
| Audit protocol | `docs/AUDIT_PROTOCOL.md` | |
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
subscription · track · onboarding · shell · account_shells.

**Entrypoints.** `main_dev` · `main_staging` · `main_prod` · `main_mock`,
selected via `lib/core/config/app_config.dart`.
⚠ Base URLs are `TBD.example` placeholders — blocked on the backend partner.

**Scale.** 178 files / ~36k LOC in `lib`; 66 files / ~15k LOC in `test`
(~730 cases, 185 groups); 22 of 36 contract paths consumed — **all 21 stable
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
pwsh -File tool\validate.ps1     # Windows
```
```sh
sh tool/validate.sh              # Git Bash / macOS / Linux
```

Writes a self-contained record to `.ai/audits/current/test-results.md`:
toolchain versions, format, analyze, full test output, pass/fail counts.
Continues past failures rather than stopping at the first.

**Optional hooks** (not installed by default):
```sh
git config core.hooksPath .githooks
```
`pre-commit` formats + analyses **staged files only**; `pre-push` runs the suite
and skips entirely when a push touches no Dart or config. Both honour
`--no-verify`.

**CI** — `.github/workflows/ci.yml`. ⚠ Set `FLUTTER_VERSION` to your local
`flutter --version` before the first run; three sources in this repo currently
disagree about the SDK.
