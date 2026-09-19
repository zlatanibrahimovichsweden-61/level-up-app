# skills/ — mirror of `.claude/skills/`

Copied 2026-08-20 as part of the account migration (see `tell_claude.md` §9).

These 25 files are a **byte-identical mirror** of `.claude/skills/` at the time of the
handoff. They live here because `.claude/` is a tool-managed directory that some tooling
treats as disposable, and losing these would lose seven project-specific skills that exist
nowhere else.

## Restore

Copy the tree back over `.claude/skills/`, preserving the layout one-to-one:

```powershell
Copy-Item -Recurse -Force skills\* .claude\skills\
```

## Contents

7 custom (project-specific, irreplaceable):
`bloc` · `build-screen` · `figma-frame` · `level-up-domain` · `river` · `screen-states` ·
`seif-api-contract`

15 generic Dart/Flutter (upstream skill pack, replaceable):
`dart-add-unit-test` · `dart-collect-coverage` · `dart-generate-test-mocks` ·
`dart-migrate-to-checks-package` · `dart-resolve-package-conflicts` ·
`dart-run-static-analysis` · `dart-use-pattern-matching` · `flutter-add-integration-test` ·
`flutter-add-widget-preview` · `flutter-add-widget-test` ·
`flutter-apply-architecture-best-practices` · `flutter-build-responsive-layout` ·
`flutter-fix-layout-issues` · `flutter-setup-declarative-routing` ·
`flutter-setup-localization`

Plus `evals/evals.json` under `bloc`, `build-screen` and `river`.

## Known-stale claims in these files — do NOT act on them without reading tell_claude.md

- `level-up-domain` and `seif-api-contract` say the API is snake_case and to bridge with
  `@JsonKey(name:)`. **ADR-026 fixes camelCase on the wire.** The codebase adds no name
  bridges and must not start.
- `bloc` promises a `QuizTimeExpired` event and a countdown timer. **Neither exists,
  deliberately** — the contract has no duration field (`docs/seif_fight.md` S7). K-36 says
  delete that promise.
