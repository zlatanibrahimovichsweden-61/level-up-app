# Shared Agent Context — Level Up Flutter audit

**Do not re-derive this. Read it, then go straight to your scope.**

Baseline: branch `dev`, commit `e3651e6`, working tree clean, 2026-08-11.

## Repo location (use these exact paths)

- Flutter app root: `F:\level\level_up\level_up_app`
- Rules vault (Obsidian, outside the app): `F:\level\level_up\level_up`
- Bash-side equivalents: `/sessions/upbeat-brave-fermat/mnt/level_up/level_up_app`
  and `/sessions/upbeat-brave-fermat/mnt/level_up/level_up`

## HARD CONSTRAINTS FOR THIS PASS

1. **REPORT ONLY. Do not edit, create or delete anything under `lib/`, `test/`,
   `android/`, `ios/`, `assets/`, `pubspec.yaml` or `analysis_options.yaml`.**
   Your only write target is your own report file under `.ai/audits/current/`.
2. **No Flutter/Dart toolchain is available and the network is allowlist-blocked.**
   You cannot run `flutter analyze`, `flutter test`, `dart format` or any build.
   Every claim you make must be grounded in *reading the source*, with
   `file:line` evidence. If a finding can only be confirmed by running the
   toolchain, say so and put it under "Validation Required".
3. Cite `file:line` for every finding. A finding without evidence is noise.
4. Distinguish `BUG` / `ARCHITECTURE ISSUE` / `QUALITY IMPROVEMENT` /
   `OPTIONAL IMPROVEMENT` / `PRODUCT DECISION`. Never silently convert a product
   decision into an engineering one.
5. Severity: `CRITICAL` / `HIGH` / `MEDIUM` / `LOW`. Be honest — this codebase is
   mature and mostly good. Do not manufacture findings to look thorough. An
   agent that reports "3 real issues" beats one that reports "20 nitpicks".
6. Respect existing deliberate decisions. `docs/DECISIONS.md`, `docs/KNOWN_BUGS.md`,
   `docs/DESIGN_ISSUES.md` and the vault's `00_Project/Decisions_Log.md` record
   choices that were made on purpose. Re-litigating them without new evidence is
   a wasted finding.

## Project shape (already established — don't spend tokens rediscovering)

- Flutter stable, Dart SDK `^3.10.4`. 178 dart files / ~36k LOC in `lib`,
  66 files / ~15k LOC in `test` (~731 `test`/`testWidgets` cases, 185 groups).
- Feature-first layering: `lib/features/<feature>/{models,repository,notifier,screens,widgets}`
  plus `lib/core/{config,models,network,providers,router,storage,theme,widgets}`.
  Features: auth, registration, home, catalog, quiz, profile, settings,
  subscription, track, onboarding, shell, account_shells.
- State: Riverpod is primary (51 files) + DI (no get_it). **Bloc is deliberately
  scoped to the quiz engine only** (`lib/features/quiz/bloc/quiz_bloc.dart`,
  consumed by `quiz_screen.dart`). This is a documented rule, not an accident.
- Routing: GoRouter, single file `lib/core/router/app_router.dart` (350 lines).
- Networking: Dio + `lib/core/network/interceptors/{auth,error}_interceptor.dart`,
  typed `AppException` in `lib/core/network/exceptions.dart`.
- Storage: `flutter_secure_storage` for tokens, `shared_preferences` for
  non-secret prefs (`lib/core/storage/`), `hive_ce` present in deps.
- Theme: `lib/core/theme/app_colors.dart` (754 lines) — a `ThemeExtension`
  `AppColors` carrying ~55 semantic tokens, plus `Brand` seeds. The primary
  accent *flips* by theme (green light / purple dark) by design.
  `lib/core/theme/app_theme.dart` is only 69 lines.
  **Measured: zero `Color(0x...)` literals in `lib/` outside `lib/core/theme/`,
  and zero `withOpacity(` calls.** Theme discipline is already enforced by
  `test/core/theme/palette_discipline_test.dart`.
- l10n: gen-l10n, `lib/l10n/app_en.arb` + `app_ar.arb`, `AppLocalizations`,
  RTL is a first-class requirement (Arabic is the baseline, not an edge case).
  Bundled fonts Inter / Tajawal / Cairo — no `google_fonts`, works offline.
- Flavors: `main_dev` / `main_staging` / `main_prod` / `main_mock`, driven by
  `lib/core/config/app_config.dart`. Base URLs are `TBD.example` placeholders
  with a `TODO(contract)` — known, blocked on the backend partner.
- Mock backend for development: `lib/dev/mock_backend.dart` (1527 lines).
- Contract lives in-repo at `contract/openapi.yaml` (+ `SOURCE.md`,
  `error-codes.md`, `contract-changelog.md`, `realtime.md`). 21/21 stable
  endpoints consumed; the 14 unconsumed paths are all `x-stability: draft`.
- Golden tests exist: `test/goldens/` (nav bar × 5 tabs × 2 themes, track screen,
  level card, language pill, home header bell).

## Known gaps already confirmed by the orchestrator (don't just re-report these — go deeper)

- **No CI.** `.github/` does not exist.
- **No git hooks.** `.git/hooks/` contains only samples.
- **`analysis_options.yaml` is stock `flutter_lints` with zero custom rules** and
  no `errors:` severity escalation, no `exclude:` for generated files.
- **No `integration_test/` directory** — zero end-to-end coverage.
- **Responsive is the weakest area:** only 2 `MediaQuery` references and
  **0** `LayoutBuilder` in the whole of `lib/`; 257 `SizedBox(` sites; **0**
  references to `textScaler`/text scaling anywhere.
- **Source-of-truth fragmentation:** the 7 project skills exist byte-identical in
  BOTH `level_up_app/.claude/skills/` and `level_up/skills/`, and the 15 generic
  Flutter skills in BOTH `.claude/skills/` and `level_up/.agents/skills/`.
  Currently in sync, no mechanism keeps them so. The authoritative *rules* live
  in the vault at `level_up/01_Flutter_Specs/*.md`, outside the app repo.
- `docs/PROGRESS.md` self-declares its own header sections stale.
- 51 `TODO(...)` markers in `lib/`: 23 `TODO(contract)`, 17 `TODO(design)`,
  6 `TODO(design-asset)`, 4 `TODO(content)`, 1 `TODO(legal)`, 1 `TODO(deep-link)`.
- 7 raw string literals inside `Text(` in `lib/` — check each; some are
  legitimately non-translatable (the `🇪🇬` flag glyph, punctuation joiners) and
  at least two look like real l10n leaks
  (`app_router.dart:347`, `state_widget.dart:65`).

## Report format (mandatory — write exactly this shape)

```
# Agent N — <name>

**Scope:**
**Baseline:** dev @ e3651e6
**Repository areas inspected:** (list the paths you actually read)

## Findings

### F-N-01 [SEVERITY] [CATEGORY] <one-line title>
**Evidence:** `path/to/file.dart:123` — <quote or precise description>
**Why it matters:**
**Recommended fix:**
**Risk of fixing:**
**Validation required:**

(repeat)

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

## Remaining Risks

## Deferred Improvements

## Recommendations (ranked)
```

Keep the report tight. Target 150–400 lines. Evidence over prose.
