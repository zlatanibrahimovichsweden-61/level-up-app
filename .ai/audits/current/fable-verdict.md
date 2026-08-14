# Fable Independent Review — Verdict

**Reviewer:** Fable (independent, adversarial) · 2026-08-12
**Baseline reviewed:** `dev` @ `e3651e6` + the untracked audit/infra/docs additions
**Method:** every load-bearing claim in the package was re-derived from the
repository directly — greps re-run, contrast ratios recomputed, font tables
parsed byte-level, manifests inspected, contract spot-checked, all four
infrastructure files read as code. Nothing was accepted on the package's word.

---

## VERDICT: APPROVED WITH WARNINGS

The package's factual claims survived adversarial verification at every point
tested (~15 independent checks). Two claims are overstated (§3), none is
fabricated. The infrastructure is competently written but has never executed,
and the test suite remains unrun by anyone — including this review, which also
had no Dart toolchain. That is the load-bearing warning.

---

## 1. The two CRITICALs — independently verified

### C-1 · Missing `INTERNET` permission — **CONFIRMED, and strengthened**

The package said this "cannot be settled without building." **That was wrong —
the evidence was already on disk.** `build/` contains per-plugin merged
manifests from a prior debug build:

- `build/connectivity_plus/…/AndroidManifest.xml` → contributes only
  `ACCESS_NETWORK_STATE`
- `device_info_plus`, `flutter_secure_storage`, `screen_protector`,
  `shared_preferences_android`, `sqflite_android`, `url_launcher_android`,
  `jni`, `jni_flutter` → **no `uses-permission` at all**
- `dio` and `cached_network_image` have **no Android platform component**
  (absent from the plugin build list entirely — pure Dart)

No plugin supplies `INTERNET`. The main manifest declares no `uses-permission`.
The release merge therefore cannot contain it. **C-1 is a certain, total
release-build failure, not an inference. CRITICAL is the correct severity.**
The one-line fix in K-1 stands; the device-login validation in K-1 still
applies.

*Meta-finding:* ten agents plus an orchestrator declared this unverifiable
while the answer sat in `build/`. Add "inspect existing build intermediates"
to `docs/AUDIT_PROTOCOL.md`'s evidence checklist.

### C-2 · Logout data leak — **CONFIRMED; the proposed fix is incomplete, as the package itself suspected**

`auth_controller.dart` `logout()`/`forceLogout()` verified: tokens cleared,
state flipped, **zero invalidations**. K-2's two-provider fix is not
exhaustive. Full enumeration of non-`autoDispose` session-scoped providers:

| Provider | Holds | Leak class |
| --- | --- | --- |
| `meProvider` | name, level, points, school, DOB-derived data | PII — in K-2 |
| `entitlementsProvider` | paywall state | in K-2 |
| **`subjectsProvider`** | track-scoped subject list (`catalog/`) | **missing from K-2** — a school student logging in after a university student sees the wrong catalog until refetch (`main_mock.dart` itself documents that track "changes Home, the subject list and the whole shape of the Learn tab") |
| **`subjectTreeProvider` (family)** | per-subject trees | **missing** — invalidate the whole family |
| **`loginProvider`** | last `OtpRequestResult` (phone-adjacent) | **missing** — low sensitivity, still stale-session state |
| **`registrationControllerProvider`** | `RegistrationDraft` (name, DOB, phone) | **missing** — a force-logout mid-registration leaves a minor's draft PII in memory for the next user |

**Required fix (revised):** do not hand-list invalidations inside
`AuthController`. Create one `void invalidateSessionScope(Ref ref)` in
`core/providers/` listing all six, called from both `logout()` and
`forceLogout()` — and add a guard test (discipline-test style) asserting every
non-`autoDispose` provider under `lib/features/` is either in that list or
explicitly annotated session-independent. That converts the fix from a
hand-list into a mechanised rule, which is the package's own structural
thesis applied to its own top finding.

**Validation:** the K-2 widget test (sign in as A → logout → sign in as B →
assert B's data), extended to assert the Learn tab refetches.

---

## 2. Single-source claims — recomputed, all held

| Claim | My check | Result |
| --- | --- | --- |
| `mutedText` 2.03:1 light / 7.39:1 dark | WCAG luminance recomputed programmatically | **Exact match** — H-6 stands |
| Dark `hint` ≡ `textPrimary` `#FCFBF9` | `app_colors.dart:504,506` read | Confirmed — H-5 stands |
| Font line-heights Inter 1.210 / Tajawal 1.200 / Cairo 1.874 | `head`/`hhea` tables parsed from the TTFs | **Exact match** — RESPONSIVE.md Rule 6 is sound |
| Tajawal no w600, 45 sites request it | pubspec fonts block: Tajawal 400/500/700 only | Confirmed |
| `select()` 0 of 70 | grep: 2 `.select(` hits are notifier *methods*, not Riverpod selectors | Confirmed |
| Palette guard: 0 hardcoded colours outside theme | independent grep, `Color(0x` = 0 hits | Confirmed |
| No `TextTheme` | grep `textTheme` in lib = 0 | Confirmed |
| `hive_ce` unused | 5 grep hits, all comments | Confirmed — delete (K-28) |
| `memCacheWidth` 0 of 5 | grep | Confirmed |
| 43/43 Conventional Commits | `git log --format=%s` regex | Confirmed |
| Secrets: `key.properties` never committed; signing fails closed via `findByName` | `git log --all --oneline -- android/key.properties` empty; gradle read | Confirmed |
| Contract↔model nullability (spot-check `StudentProfile`) | every nullable contract field (`email`, `governorate`, `school`, `school.school`, `avatar.id`) nullable in the model | Clean |
| Quiz timer omission deliberate | `quiz_state.dart:93-96` in-source doc → `seif_fight.md S7` | Confirmed — resolution 3.3 correct |
| `/subscription` dead-end + onboarding CTA dead-end | `app_router.dart:250,347` `_Placeholder`, `limit_sheet.dart:123` push, `onboarding_screen.dart` `context.go('/register')` vs the fix documented at `login_screen.dart:76-85` | Both confirmed live |
| `main_mock` doesn't override `refreshDioProvider` | source comment admits it | Confirmed (K-16) |
| `main` vs `dev`: 3 commits | `git log dev..main` = 3 merges | Confirmed (K-34) |

The severity raises (D-3) are **upheld**: C-1 is now proven, and "does not
work when shipped" has no tier below CRITICAL; C-2 is minors' PII on shared
hardware in this market. The structural finding (§4) is **real, not
narrative** — four of its eight rows were independently re-verified here and
the mechanised-vs-prose asymmetry is exactly as described.

---

## 3. Errors found in the audit package

### E-1 · H-2 is overbroad — MEDIUM (audit accuracy)

**Evidence:** repositories run `fromJson` inside `try { } on DioException`;
but every Riverpod consumer reaches them via `AsyncNotifier.build` or
`AsyncValue.guard`, both of which catch **all** thrown objects. A `TypeError`
there becomes `AsyncError` → the error view renders. The "screen sits on a
spinner" outcome is real **only for `QuizBloc`** (`on AppException` at
`quiz_bloc.dart:140,252,295` — an escaped `TypeError` emits nothing).
**Why it matters:** the fix queue would otherwise drive a defensive rewrite of
six repositories to cure a symptom that exists in one Bloc.
**Fix:** rescope K-12 — wrap the quiz repository calls (or the Bloc handlers)
so unexpected errors emit a failure state; optionally map `TypeError` to a
typed `SchemaException` at the repository boundary for *better messages*
everywhere, but the hang is quiz-only.
**Validation:** a bloc_test feeding malformed JSON through the quiz repository
asserting a failure state, plus one widget test asserting a Riverpod screen
shows the error view on malformed payload.

### E-2 · "RTL coverage 0%" is false as consolidated — LOW (audit accuracy)

**Evidence:** 18 test files pump `Locale('ar')`; at least four assert
`Directionality`/`TextDirection.rtl` (login, catalog ×2, subjects). The true
claim is **RTL *golden* coverage is 0%**. `project-audit.md` §4 and the
structural-finding table dropped the qualifier.
**Why it matters:** overstating a gap burns credibility exactly where the
package asks to be trusted, and K-26's size estimate should account for the
existing Arabic harness (it makes the golden work *smaller*).
**Fix:** correct the row in `project-audit.md` §4 and `PROJECT_GUIDE.md` §4 to
"0 Arabic **goldens**". K-26 stands.

### E-3 · `changed-files.md`'s own verification block is wrong — LOW

**Evidence:** it claims `git status --short` shows only `?? .ai/ .githooks/
.github/ tool/` and says "expect only the 4 ?? directories". Actual status
also shows the four new `docs/*.md` files. The files are legitimate and listed
elsewhere in the same document — the *verification recipe* is what's stale.
**Why it matters:** it is the package's integrity check; as written it would
"fail" and trigger the document's own "reject this package" clause.
**Fix:** update the status block. **Validation:** re-run the three commands.

### E-4 · Minor count drift — INFO

Inline `TextStyle(` measures 148, not 153, at this baseline. The finding (H-4)
is unaffected.

---

## 4. The unrun infrastructure — read as code

**Overall: competent, unusually well-annotated, and safe to adopt.** Findings:

### I-1 · CI's release gate passes with C-1 present — MEDIUM

**Evidence:** `build-release-apk` compiles only; the package's own
final-summary admits the gap.
**Why it matters:** the one CRITICAL class CI could cheaply catch is left to
device QA.
**Fix:** append one step to the job:
```yaml
- name: Release manifest sanity
  run: |
    m=$(find build/app/intermediates/merged_manifests -name AndroidManifest.xml | head -1)
    grep -q 'android.permission.INTERNET' "$m" || {
      echo "::error::Release manifest lacks INTERNET permission"; exit 1; }
```
**Validation:** job fails at `e3651e6`, passes after K-1.

### I-2 · CI test step enumerates directories — LOW

**Evidence:** `flutter test test/core test/dev test/features` — a future
`test/<newdir>/` is silently never run; root `test/widget_test.dart` (a
harmless placeholder) is already skipped.
**Fix:** delete the placeholder, tag goldens `@Tags(['golden'])`, and run
`flutter test --exclude-tags golden` — the ci.yml header comment already
proposes exactly this; promote it from comment to code once test/ can be
touched. **Validation:** CI case count matches local minus 5 goldens.

### I-3 · pre-commit space-safety comment is wrong — LOW

**Evidence:** the hook builds a newline list "so paths with spaces stay
intact", then pipes to bare `xargs`, which re-splits on spaces. No current
path has spaces, so it is latent.
**Fix:** `xargs -d '\n'` (both hooks' Git-for-Windows environment ships GNU
xargs), or `tr '\n' '\0' | xargs -0`. Same in `validate.sh:113`.
**Validation:** stage a file with a space in a scratch clone; hook still works.

### I-4 · Goldens job green-washes the workflow — INFO

`continue-on-error: true` at job level means golden failures never redden the
run. The file documents flipping it after first green — hold to that.

### I-5 · Verified correct, worth recording

`pre-push` handles new branches conservatively (unknown remote SHA → run the
suite, never skip). `validate.ps1`'s 60-file chunking clears the Windows
command-line limit; its `+N -N` counter regex matches the expanded reporter;
`$PSNativeCommandUseErrorActionPreference` degrades harmlessly on PS 5.1.
`FLUTTER_VERSION: 3.44.0` as a floor-pin with a mandatory first-run
reconciliation note is the right call given `.metadata` is stale by design.
CI's env-context interpolation in `with:` blocks is valid syntax.

---

## 5. Scope, workflow, documentation

- **Scope control: clean.** `git diff` / `--cached` empty; zero tracked files
  modified; all additions are inert-until-invoked. No refactoring occurred at
  all — "unnecessary refactoring" is vacuously satisfied.
- **Report-only (D-1) was rigour, not risk aversion** — with no way to run 730
  tests, editing `lib/` would have been the reckless option. But note the
  asymmetry: the same missing toolchain means **every "green suite" claim in
  this repo is still inherited from the last human run.** Running
  `tool/validate.ps1` remains the single highest-value action and gates any
  Tier-0 fix.
- **D-4 (four docs, not eight): correct.** The four created docs index rather
  than duplicate; `PROJECT_GUIDE.md`'s source-of-truth hierarchy and its §4
  warning are the best guard against the drift the audit diagnosed.
  `RESPONSIVE.md` is well-scoped (rules, not abstractions; explicitly rejects
  breakpoint/sizing-package cargo-culting) and its product-decision flags
  (textScaler clamp) are honestly held open. One correction needed per E-2.
- **The ten-agent system:** the disagreement-and-refutation record (§3 of the
  register) is genuine — I verified the quiz-timer and mock-backend
  resolutions against source. Two process gaps to write into
  `AUDIT_PROTOCOL.md`: (1) check local build intermediates before declaring a
  platform question unverifiable (C-1); (2) consolidation must not strengthen
  agent claims — "0 Arabic goldens" became "RTL coverage 0%" at the
  orchestrator layer (E-2).

---

## 6. Conditions attached to this approval

1. **Run `tool/validate.ps1` and commit `test-results.md`** before any Tier-0
   fix merges. Every code-level claim above is static; the suite has still
   never been run against this baseline by anyone.
2. Apply **K-1 exactly as written** (now proven, not inferred).
3. Apply **K-2 in the revised form of §1** (six providers, centralized, with
   the guard test) — not the two-provider version.
4. Rescope **K-12** per E-1 before anyone rewrites six repositories.
5. Correct **E-2/E-3** in the package before archiving it.
6. Adopt **I-1** when ci.yml first lands; schedule I-2/I-3 with Tier-3 work.

No REJECTED-level defect was found: no fabricated evidence, no scope
violation, no hidden change to app code, no secret in tree or history, and
the two CRITICALs are real — one now proven beyond the package's own
confidence level.
