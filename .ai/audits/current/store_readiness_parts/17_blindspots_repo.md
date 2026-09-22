# Wave 3-A — Blind-spot hunt (repo scan), independent of prior waves

Scope: `store_readiness_state.md` read first; every finding below is checked against its
consolidated ID list (FE/AND/IOS/API/SEC/PRIV/DEP/POL/ENT/RED/REV/DECL/PERM) and is either NEW
or explicitly marked "not new" with a pointer to the ID that already owns it. HEAD `bf967d6`.
No files edited except this one. No builds run — all evidence is static read/grep, or reasoning
from vendored package source already on disk (`intl-0.20.3` in the local pub cache).

Severity scale matches the rest of the audit: A blocker, B high, C medium, D low/hygiene, F pass.

---

## BS-A-01 · C · Numeric strings ship naive concatenation while the ARB's only other
quantity string gets full Arabic pluralisation — an internal inconsistency

`lib/l10n/app_ar.arb:152` (`mistakeCount`) is the **only** ICU `plural` construct in either ARB
file, and it is done right — all six Arabic categories are present:
`{count, plural, zero{لا أخطاء} one{خطأ واحد} two{خطآن} few{{count} أخطاء} many{{count} خطأً} other{{count} خطأ}}`.
That answers the brief's direct question ("does any plural key lack few/many?") with **no** —
the one plural key that exists is complete.

But three other user-facing quantity strings skip ICU entirely and hardcode a single Arabic
noun form regardless of the count substituted in:

| Key | EN (`app_en.arb`) | AR (`app_ar.arb`) | Problem |
|---|---|---|---|
| `pointsAwarded` | `app_en.arb:432` `"+{points} Points"` | `app_ar.arb:189` `"+{points} نقطة"` | نقطة is the Arabic **singular** of "point". Grammatically this reads as "+15 point" for every value — wrong for 2 (dual نقطتان), wrong for 3–10 (plural نقاط), and the EN side has the mirror (English-only) issue of "+1 Points" being ungrammatical. |
| `rateLimitedIn` | `app_en.arb:14` `"…in {seconds} seconds."` | `app_ar.arb:8` `"…بعد {seconds} ثانية."` | ثانية is Arabic singular "second"; correct only for the 11–99 range, wrong for 2 (ثانيتان) and 3–10 (ثوانٍ /ثواني). |
| `resendIn` | `app_en.arb:50` `"Resend in {seconds}s"` | `app_ar.arb:30` `"إعادة الإرسال خلال {seconds} ث"` | Same noun-form problem, abbreviated to "ث" — same grammar gap, now also less legible standalone. |

None of this is store-blocking (Apple/Google do not reject over Arabic noun agreement), but it
is a real, concrete quality gap that sits right next to a key that proves the team already knows
how to do this correctly with ICU. Recommendation: promote these three keys to `plural` the same
way `mistakeCount` was done, or explicitly document why they were left as plain substitution (no
such note exists in their `@`-metadata today — checked both `app_en.arb` blocks for these three
keys, no rationale comment present, unlike `mistakeCount`'s own long design-history comment).

**Not the same finding as** FE-27/FE-32/33 (Arabic-Indic digit *input* asymmetry, login vs OTP)
— that is about which numerals a keyboard emits; this is about noun grammar around a number that
displays correctly either way.

---

## BS-A-02 · D · Multiple custom tap targets sized under the 48dp/44pt minimum, hit-tested to
their literal (small) bounds — a repeated pattern, not a one-off

The brief asked specifically for "IconButtons with custom sizes." Four independent, unrelated
call sites all shrink the tappable area below the platform-recommended minimum, using the same
technique (`BoxConstraints.tightFor` / a fixed small `width`/`height` with no compensating
padding):

- `lib/core/widgets/circle_back_button.dart:52` — `_size = 35.0` (35×35 dp circle). The tap
  handler is wired straight to `ElevatedSurface`'s own `InkWell` at that exact size
  (`lib/core/widgets/elevation/elevated_surface.dart:108-111`: `Material` + `InkWell(onTap:
  onTap, customBorder: shape, child: content)`, no padding inserted for `onTap` cases). Used on
  9 screens (`grep -c CircleBackButton\( lib` across features = 9 call sites).
- `lib/core/widgets/language_pill.dart:28` — `_height = 36.10` (full pill height, no minimum-height
  padding). Its own doc comment says it is "shared across auth + registration screens — this is
  the only copy" and "all seven dark instances are identical" — i.e. ~7 screens inherit the same
  sub-48dp height.
- `lib/features/profile/widgets/avatar_sheets.dart:74-79` — dismiss `IconButton` explicitly set to
  `padding: EdgeInsets.zero` + `constraints: const BoxConstraints.tightFor(width: 35, height: 35)`.
- `lib/features/profile/widgets/profile_confirm_dialog.dart:136-139` — identical pattern, same
  dismiss-button use case.

None of these are Play/App Store submission blockers by themselves, but Play Console's
pre-launch report and the Android Accessibility Scanner both flag sub-48dp targets by default,
and this fails WCAG 2.5.5/2.5.8 (Target Size). Given it is the same 35dp figure recurring across
four independently-written files, this reads like a shared Figma spec being followed literally
rather than a single oversight — worth one design conversation (pad the hit area, not
necessarily the visible circle/pill) rather than four separate patches.

**Accessibility is otherwise handled with real care** in the same files — worth stating
precisely since the brief asked which guards/patterns exist: `CircleBackButton` wraps itself in
`Semantics(button: true, label: MaterialLocalizations.of(context).backButtonTooltip)`
(`circle_back_button.dart:65-67`); `quiz_review_screen.dart:490` and `quiz_screen.dart:467` both
use `excludeFromSemantics: true` on a decorative glyph nested inside an already-labelled parent
specifically to avoid double-announcement (with a comment explaining why); `home_header.dart:137`
passes a real `semanticsLabel` to the notification bell. The touch-target sizing above is the one
concrete gap found in an otherwise deliberate a11y layer — not evidence of a broader pattern of
neglect.

`MediaQuery.textScaler` clamps: confirmed absent app-wide (grep for `textScaler`/`TextScaler`
across `lib/` returns only the 34 unrelated hits already catalogued) — this is **not new**, it is
FE-16/BUG-002, cited here only to confirm the negative per the brief's checklist.

---

## BS-A-03 · C · Android cold-start splash colour mismatches the app's real canvas in BOTH
themes, and the mismatch is structural, not just "no logo"

This directly answers the brief's specific question ("how does cold start look"):

- `android/app/src/main/res/drawable-v21/launch_background.xml` (the file that actually applies
  on effectively every real device) paints `?android:colorBackground` — a **theme attribute**,
  resolved by whichever `LaunchTheme` is active.
- `android/app/src/main/res/values/styles.xml` (light) sets `LaunchTheme`'s parent to stock
  `@android:style/Theme.Light.NoTitleBar` → `colorBackground` resolves to pure **`#FFFFFF`**.
- `android/app/src/main/res/values-night/styles.xml` (dark) sets the same theme's parent to
  stock `@android:style/Theme.Black.NoTitleBar` → resolves to pure **`#000000`**.
- The app's actual canvases are neither: the light canvas is a warm cream (elevation docs cite
  `#FCFBF9`, e.g. `docs/DECISIONS.md`/elevation guide language "reverses #47 cream"), and the
  dark canvas is `#232428` (`lib/app.dart:74` comment: "a white system bar under a `#232428`
  app"). So **every** cold start on **both** themes flashes a colour visibly different from the
  first real Flutter frame — light flashes bright white into cream, dark flashes true black into
  charcoal.
- The base (API<21) `drawable/launch_background.xml` is still the literal, untouched
  `flutter create` template — hardcoded `@android:color/white`, and the `<!-- <item><bitmap
  android:src="@mipmap/launch_image"/> --` custom-art hook is still commented out in both the
  base and v21 files. No `drawable-night*` override exists to correct this at the drawable level
  either (`find … -iname "*night*"` under `res/` returns only the `values-night` directory).
  No `android:windowSplashScreen*` attributes exist anywhere (`styles.xml`, manifest) and no
  `core-splashscreen`/`flutter_native_splash` dependency is present, so nothing customizes the
  Android 12+ SplashScreen API either.
- Corollary, not a separate bug: because the launcher icon is still the stock Flutter icon
  (already AND-03/AND-04), the Android 12+ *system-synthesized* splash (mandatory on API 31+ for
  every app, customized or not) will additionally show that stock icon inside the default white
  circle-and-dot animation — i.e. the branding gap is visible at the single most-seen moment of
  the whole app (every cold start), not just on the home screen.

Not previously itemized this specifically — AND-03/AND-04 cover the *icon*; this is the *splash
background colour* and is a distinct fix (edit two XML files + optionally add a
`drawable-night-v21` override, no new asset required as a first pass).

---

## BS-A-04 · C · No guard test exists for any of the six things the brief asked about — and
this is very likely *why* the FE-01 blocker (placeholder prod URL) shipped undetected

The brief asked which guards exist, by name, so the final report can state coverage precisely.
Full enumeration (all six guard files read in full, not sampled):

| File | What it actually guards |
|---|---|
| `test/guards/project_rules_test.dart` | `lib/` is being scanned at all; Bloc stays inside `features/quiz/`; no provider mutated in `initState` (BUG-001); autoDispose notifiers track their own disposal; user-facing copy goes through `AppLocalizations` (two sub-checks: no *new* hardcoded string, and the existing-violation count doesn't grow — i.e. a ratchet, not a ban); hardcoded `fontSize` ratchet (currently 0); no raw elevation effect (`BoxShadow`, non-zero `elevation:`, `shadowColor:`, `MaskFilter.blur`, `ImageFilter.blur`, `BackdropFilter`, `PhysicalModel`) outside the two design-system folders; both ARB files carry the same keys. |
| `test/guards/rules_test.dart` | Unit tests *of the rule-detection primitives themselves* (comment-stripping, the Bloc/initState/Text/fontSize/elevation regexes, ARB key-drift diff, OpenAPI required-field extraction, Dart field/class-scoping) — meta-tests, not project-content checks. |
| `test/guards/rules.dart` | The regex/parsing primitives the two files above share. Its own internal `banned` list (`rules.dart:304`) is scoped to the **elevation-effect** ratchet (`BoxShadow(`, `shadowColor:`, `MaskFilter.blur`, `ImageFilter.blur`, `BackdropFilter`, `PhysicalModel(`) — it is not a vocabulary/copy blocklist of any kind, despite the name. |
| `test/guards/workflow_test.dart` | CI never passes a bare directory to `flutter test` (so no future test dir is silently skipped); every golden test file carries `@Tags(['golden'])`; `.flutter-version` is the single source of the pinned SDK version and CI reads it rather than hardcoding it; the main manifest declares `INTERNET` **and** CI inspects the *built artefact* for it, not just the source; every release-build command in CI/docs targets `lib/main_prod.dart`; the two `validate.sh`/`validate.ps1` scripts exist and the pre-push hook reuses `validate.sh` rather than reimplementing it; PowerShell scripts are pure ASCII; every shell script that batches files does so NUL-safely. |
| `test/guards/contract_models_test.dart` | Every contract-`required` field (per `openapi.yaml`) is actually modelled somewhere in `lib/`. |
| `test/guards/validate_reporting_test.dart` | The validate scripts' own pass/fail *reporting* format (e.g. how a skip count is parsed) — tooling about the tooling. |

Cross-checked against every item the brief listed by name:

- **Logging ban**: no guard. (Matches the brief's own expectation — "no".)
- **Permission allow-list**: no guard. (Matches AND-08, already flagged as a gap.)
- **Draft/web endpoint usage**: no guard. The zero-draft-calls fact in `parts/05`'s census was
  produced by manual review, not by anything CI re-checks on every PR.
- **Hardcoded URLs**: no guard. This is the one worth dwelling on — `AppConfig`'s prod base URL
  being the literal string `https://TBD.example/api/v1` (FE-01/AND-01/SEC-01, already a
  Blocker) is exactly the class of defect a five-line guard test (`the prod baseUrl is not a
  known placeholder host`) would catch on every commit. None of the six files above check
  `app_config.dart` at all. Given CLAUDE.md's own stated lesson — "prose rules decay; mechanised
  rules hold… the one rule with a guard test has held across 36k lines with zero exceptions" —
  this gap is the mechanism, not just a missing nice-to-have: it is consistent with *why* a
  Blocker-severity defect reached a built release artefact undetected.
- **Query params in `launchUrl`**: no guard, and more starkly, **no test references
  `launchUrl`/`url_launcher` at all** (`grep -rln "launchUrl\|url_launcher" test` returns nothing).
  The app's one production call site today, `login_screen.dart:118`
  (`launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)`), has zero test coverage of
  its URL or `LaunchMode` — including no regression test that would catch the URL silently
  regaining a query string, or the mode silently changing away from
  `externalApplication` (which matters directly for the redemption-link work `RED-01` already
  flags as the one safe mode on Android).
- **Banned vocabulary** (adr-171's price/buy/purchase/subscribe/etc. list): no guard. FE-24's
  "no banned vocabulary found" result in `parts/10` was a manual grep for one session, not
  something CI re-asserts going forward — the next PR that touches subscription copy has nothing
  stopping it from reintroducing a banned word.

None of this is itself store-blocking, but it is a genuine, previously-unstated blind spot: the
project's own stated philosophy (mechanised > prose) has not yet been applied to the exact
categories that produced this audit's worst findings.

---

## BS-A-05 · D · The committed "irreplaceable skills" backup mirror has silently gone stale

`skills/` (repo root, git-tracked) exists specifically as a disaster-recovery mirror of
`.claude/skills/` — its own `skills/RESTORE.md` states it was "Copied 2026-08-20… a
**byte-identical mirror**… because `.claude/` is a tool-managed directory that some tooling
treats as disposable," lists 7 "custom (project-specific, **irreplaceable**)" skills by name, and
gives the documented recovery command: `Copy-Item -Recurse -Force skills\* .claude\skills\`.

A direct `diff -rq .claude/skills skills` today shows it is **no longer byte-identical** — 6
files differ, and critically 4 of them are inside the "irreplaceable" set the mirror exists to
protect: `build-screen/SKILL.md`, `level-up-domain/SKILL.md`, `river/SKILL.md` (+ its
`evals/evals.json`), `screen-states/SKILL.md`, `seif-api-contract/SKILL.md`. `.claude/skills/`
has clearly been edited since 2026-08-20 (7 months of work through the days/waves this project
has logged); `skills/` was never regenerated to match.

This is not store-relevant, but it is a live landmine for the project's own stated recovery
procedure: if anyone ever runs the documented restore command in good faith (e.g. after a
tooling wipe of `.claude/`), it will **silently overwrite** the current, presumably-improved
skills with 7-month-stale content for 4 of the project's most load-bearing, hand-written skills,
with no diff/confirmation step in the documented command. One-line fix: regenerate the mirror
(`Copy-Item -Recurse -Force .claude\skills\* skills\`) or delete the now-false
"byte-identical" claim from `RESTORE.md` and mark it historical.

---

## BS-A-06 · D · No macOS-side verification runbook — three of five guard/release scripts are
Windows-only, and CI has zero macOS job

Root-cause note for the already-known IOS-01 ("iOS never built: no Podfile/Pods"). Of the five
scripts in `tool/`:

- `tool/validate.ps1` / `tool/validate.sh` — the one pair with parity (Windows + POSIX).
- `tool/verify_guards.ps1` — **PowerShell only**, no `.sh`.
- `tool/verify_release_manifest.ps1` — **PowerShell only**, no `.sh`.
- `tool/verify_session_regression.ps1` — **PowerShell only**, no `.sh`.

`.github/workflows/ci.yml` runs four jobs total — three on `ubuntu-latest`, one on
`windows-latest` (the golden-test job, per `runs-on:` at lines 72/212/263/322) — and **no**
`macos-latest` job exists anywhere in the file. Since the iOS release build this project's own
state file lists as required next work ("iOS: UNVERIFIED — REQUIRES LOCAL RELEASE BUILD
(macOS/Xcode 26)") can only happen on a Mac, whoever does that work has no scripted way to run
the same artefact/guard verification used to gate the Android release (`verify_release_manifest`,
`verify_guards`) without first hand-porting three scripts to POSIX, or running them from a
second, Windows machine against the Mac-built artefact. Not a store blocker; a process gap that
will slow down the exact next step the project has already queued.

---

## BS-A-07 · D · Repo hygiene odds and ends (grouped, all low-severity, none store-relevant)

- `README.md` is the fully unedited `flutter create` template — "A new Flutter project", generic
  codelab links, no project name, no pointer to `docs/WAVE_STATUS.md` or the memory system. Not
  shipped to either store; flagged only because Area 7 asked for a README template check.
- `analysis_options.yaml` includes only `package:flutter_lints/flutter.yaml` with **zero**
  project-specific overrides (the `rules:` block is entirely commented-out template
  boilerplate). For a 36k-line project whose whole enforcement philosophy is "mechanised rules
  hold," none of its many conventions are enforced via `analyzer:`/lint config — all enforcement
  lives in the separate `test/guards/` regex suite instead (see BS-A-04). That is a defensible
  architecture choice, but it also means ordinary stricter-analyzer catches (`unawaited_futures`,
  `strict-raw-types`, `strict-inference`) are not enabled, which is worth a conscious decision
  rather than default-by-omission for an app handling minors' data.
- `.metadata` is git-tracked — correct per its own header comment ("This file should be version
  controlled"), no path/username leakage found in it. Confirmed fine, not a finding.
- `.gitattributes` correctly forces `*.ps1`→CRLF and `*.sh`/`gradlew`→LF, which is consistent
  with (and explains the mechanics behind) the already-flagged Windows-only tooling above — not
  itself a new defect.

---

## Confirmed NOT new (checked, already covered — listed so the final reconciliation doesn't
re-derive these)

- `flutter_svg`'s `unhandled element <filter/>` warning in `.ai/audits/current/test-results.md:509,525`
  traces to `assets/images/success_badge.svg`'s drop-shadow filter (`filter0_d_0_4`, uses
  `feFlood`/`feColorMatrix`/`feOffset`/`feGaussianBlur`/`feComposite`) — already fully documented
  as `docs/DESIGN_ISSUES.md` #28 ("shadow absent"). Traced to source for completeness only.
- Arabic digit *display*: `NumberFormat.decimalPattern('ar')` (7 call sites across the generated
  `app_localizations_ar.dart`, e.g. lines 346-360, 412-417, 471-473, 848-856) uses `intl`'s
  built-in `ar` symbol table, which sets `ZERO_DIGIT: '0'` (confirmed by reading
  `intl-0.20.3/lib/number_symbols_data.dart:64-80` in the local pub cache) — so points/level/quiz
  progress numerals render in **Western** digits, not Arabic-Indic (٠١٢…), consistently
  app-wide. This is a distinct axis from FE-27 (Arabic-Indic digit *input* on Login/OTP, already
  flagged) — reported here as a verified PASS, not a new defect, since the brief explicitly asked
  whether this was checked.
- Pubspec asset declarations vs disk: every file under `assets/icons/`, `assets/icons/nav/`,
  `assets/images/`, `assets/fonts/` is both declared and present; no missing/undeclared drift.
  PASS.
- ARB key parity: 259/259 keys match between `app_en.arb` and `app_ar.arb` (scripted diff), both
  `@@locale` fields correct (`en`/`ar`). No `TODO`/`TBD`/`lorem ipsum` literal copy in either file
  (the only regex hits were the ARB schema's own `"placeholders": {...}` metadata blocks — a
  false positive from the search term, not content). No emoji in any EN string. No mention of
  Google/Apple/App Store/Play Store/Android/iOS/iPhone/a named carrier/"beta"/"demo"/"test" in
  any user-facing ARB copy — clean against Apple 2.3.10. All PASS.
- `date_of_birth_field.dart` computing "no client-side minimum age" is a **documented, deliberate**
  choice (`date_of_birth_field.dart:14-16`: "Many Level Up students are minors, so no minimum age
  is enforced client-side — the server owns that rule"), not an oversight distinct from
  FE-15/API-09 — confirms intent, does not add a new finding.
- Registration token expiry (`registration_controller.dart:31`, `registration_draft.dart:68`)
  computes an absolute local deadline from a **server-supplied** relative TTL
  (`args.expiresInSeconds`), converted via `DateTime.now().add(...)` once at draft-start — a
  correct, standard pattern, not a clock-trust bug. Checked because Area 9 asked about
  `DateTime.now()` call sites generally; the other two call sites found
  (`mock_backend.dart:1473`, `date_of_birth_field.dart:35`) are dev-harness/date-picker-bounds
  uses with no store-readiness implication.
- `bootstrap.dart`/`app.dart`/`main*.dart` fully read: correct `WidgetsFlutterBinding
  .ensureInitialized()` → `AppConfig.init()` → await preferences → `runApp` ordering; no
  `HttpOverrides`, no `debugPaintSizeEnabled`, no `timeDilation`, no stray `Intl.defaultLocale`
  call (unnecessary — `AppLocalizations.localeName` is read directly wherever needed); no
  `ProviderScope` observers (consistent with, not additive to, the already-flagged absence of
  crash/analytics reporting, FE-14/SEC-11). `ThemeMode.system` is deliberately not offered
  (documented in `app.dart:36-38`) — matches REV-27, not new. All PASS / not new.
- No `GestureDetector` or custom-Semantics gap found beyond BS-A-02's touch-target sizing — the
  two `GestureDetector(` call sites in the whole of `lib/` (`segmented_track.dart`,
  `login_screen.dart`) are both either already carefully annotated
  (`segmented_track.dart:271-280`, with a comment explaining why the tap action is deliberately
  re-declared after `excludeFromSemantics`) or rely on Flutter's default tap-exposes-to-semantics
  behaviour for a plain link `Text` (`login_screen.dart:372-375`) — not treated as a defect.

---

## Areas scanned with nothing new to report

- Android `values-ar`/`strings.xml`/mipmap check: no `strings.xml` anywhere (confirms, does not
  extend, FE-09/AND-03/AND-04 — `android:label="level_up_app"` is a literal manifest attribute,
  not a `@string/app_name` resource, so it could not be localized via `values-ar/strings.xml`
  even if one were added without also changing the manifest attribute itself — a mechanical
  footnote on the existing finding, not a new one).
- `windowLayoutInDisplayCutoutMode` / `windowOptOutEdgeToEdgeEnforcement` /
  `enableOnBackInvokedCallback` / `supportsRtl` / `localeConfig`: all absent, all already owned by
  AND-09/AND-10/AND-11 — corroborated, not new.
- `.githooks/pre-push` correctly reuses `tool/validate.sh` verbatim rather than reimplementing
  checks (already covered by the workflow_test.dart guard cited in BS-A-04, and by
  AND-07/SEC-05/SEC-06's "hooks unset on this clone" — corroborating, not new).
