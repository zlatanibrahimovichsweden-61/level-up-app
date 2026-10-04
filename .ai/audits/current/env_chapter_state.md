# Environment & Architecture chapter — state

**Chapter:** Identity / Flavors / Store-ready environment workflow · **Opened:** 2026-10-04
**Architecture record:** `docs/ENVIRONMENTS.md` · **Rubric:** `docs/STORE_READINESS_RUBRIC.md` ·
**Decision:** `docs/DECISIONS.md` D-021 · **Risk:** `docs/RISKS.md` R-9
**Protocol per wave:** snapshot → read-only investigation → implementation → validation → post-wave
audit → focused commit → report (with rubric score, supported versions, backend sentence).

| Wave | Name | Status | Blocked by |
| --- | --- | --- | --- |
| 0 | Architecture & identity decision | **DONE 2026-10-04** — documentation only | — |
| 1 | Android environment architecture | not started | **owner: D-021 Q1–Q4** |
| 2 | Flutter environment contract | not started | Wave 1 |
| 3 | iOS environment architecture | not started | D-021; **a Mac with Xcode 26** (SOURCE-level authoring possible here, BUILD is not) |
| 4 | Cross-platform validation & release safety | not started | Waves 1–3 |

## Wave 0 record

- **Pre-wave snapshot:** branch `merged`, HEAD `03fd7cf`, dirty tree (20 modified + 4 untracked files
  belonging to the settings/elevation and wave-audit sessions), `git status --porcelain | sha1sum` =
  `7eff6bbde9b8cddd04a970c59da450ef90c93fc1`. Two Claude worktrees exist under `.claude/worktrees/`
  on `e71e9a1`; untouched.
- **Baseline validation (before any write):** `tool/validate.sh` with `LEVELUP_VALIDATE_OUT` redirected
  to the scratchpad → analyze PASS (0 issues), tests **2036 passed / 0 failed / 0 skipped**, format step
  **did not run** ("The command line is too long." — the known Git Bash / cmd.exe 8191-character limit
  on `dart format` with 320 files; `validate.sh` is not the Windows entry point). The canonical Windows
  run is `tool/validate.ps1`; its result is recorded in the Wave 0 report. The committed
  `test-results.md` was not touched.
- **Files added:** `docs/ENVIRONMENTS.md`, `docs/STORE_READINESS_RUBRIC.md`, this file. The input audit
  `.ai/audits/current/app_identity_environment_audit_2026-10-04.md` (written 2026-10-04 by the
  read-only investigation) is committed with the wave.
- **Files edited (append/insert only):** `docs/DECISIONS.md` (+D-021 proposed), `docs/RISKS.md` (+R-9),
  `docs/WAVE_STATUS.md` (+chapter pointer), `docs/PROJECT_GUIDE.md` (+index row).
- **No application code, Gradle, Xcode, Firebase or signing file was modified.** No secrets.
- **Owner decisions required before Wave 1:** D-021 Q1 (production ids: keep template / one shared
  token / other prefix), Q2 (two or three installable identities), Q3 (display names), Q4 (confirm
  minSdk 24 / target 36 / iOS 13.0).
