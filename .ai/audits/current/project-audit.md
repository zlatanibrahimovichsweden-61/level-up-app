# Level Up — Consolidated Project Audit

**Baseline:** `dev` @ `e3651e6` · working tree clean at audit start · 2026-08-11
**Method:** ten specialised Opus agents, report-only, each grounded in `file:line` evidence.
**Toolchain status:** no Dart/Flutter SDK was available to any agent, so every
finding below is derived from **reading source**, not from execution.

**Validation was subsequently run by the developer (2026-08-12):**
✅ **792 tests passed / 0 failed** · analyzer **0 issues** · formatter clean.
Flutter 3.44.7, Dart 3.12.2. Full record in `test-results.md`.

So the *baseline* is now verified — but the *findings* remain statically derived.
Those are different claims and should not be conflated: a green suite confirms
the code does what its tests say, not that the audit's reasoning about untested
paths is correct.

**One tree change since `e3651e6`:** `dart format` applied to 141 files
(Dart 3.12 tall style). Proven behaviour-preserving — token stream byte-identical
after normalising whitespace and optional trailing commas — and the suite re-ran
green afterwards. See `changed-files.md`.

---

## 1. Project health — the honest summary

**This is a well-engineered codebase.** That is the finding, stated first,
because an audit that opens with a defect list would misrepresent it.

Evidence for that claim, all measured rather than asserted:

- **Zero** hardcoded `Color(0x…)` literals in `lib/` outside `lib/core/theme/`,
  enforced by an existing guard test (`test/core/theme/palette_discipline_test.dart`).
- **Zero** nullability or enum mismatches between `contract/openapi.yaml` and the
  Dart models, across all 21 consumed endpoints. Agent 7 went looking for the
  classic "contract-optional field declared non-nullable" crash and found *none*.
- **Zero** unguarded `BuildContext` uses after `await` (all 8 sites correct).
- **Zero** leaked controllers, timers or subscriptions.
- **Zero** secrets in the working tree *or* in all 43 commits of history
  (677 blobs, 82,296 patch lines scanned).
- **43 of 43** commits follow Conventional Commits.
- ~730 test cases across 185 groups; 6 repositories with uniform typed-exception
  boundaries; a 401→refresh→retry path that is correct *including* under
  concurrent 401s.
- Keyboard handling and safe areas are correct on every screen — Agent 5 went
  looking for form-overflow bugs and found the count is zero.

**The defects that exist are concentrated in three places:** (1) things that only
manifest in a *release* build, which nobody has ever produced; (2) things that
only manifest against a *real* API, which does not exist yet; (3) things the
project **wrote down as rules and then did not enforce mechanically**.

That third category is the structural finding of this audit and it recurs in
five independent agents' reports. See §4.

---

## 2. Findings register — consolidated and de-duplicated

116 raw findings across ten reports, de-duplicated to **9 CRITICAL/HIGH**,
**24 MEDIUM**, **~40 LOW**, and a long tail of positives-recorded-as-findings.
Agent-local IDs are preserved so every row traces back to its full write-up.

### CRITICAL — must be fixed before any release build ships

| # | Finding | Evidence | Agents |
| --- | --- | --- | --- |
| **C-1** | **The release APK has no `INTERNET` permission.** `android/app/src/main/AndroidManifest.xml` declares no `uses-permission` at all; `INTERNET` exists *only* in `src/debug/` and `src/profile/`. Release builds merge neither. Every network call in a release build fails, and this is **invisible during development** because debug builds work perfectly. | `android/app/src/main/AndroidManifest.xml` (no `uses-permission` node) vs `src/debug/AndroidManifest.xml:6`, `src/profile/AndroidManifest.xml:6` | 9 · **re-verified by orchestrator** |
| **C-2** | **Logout leaks the previous student's data to the next one.** `logout()` and `forceLogout()` clear tokens and flip auth state but invalidate **no** providers; `meProvider` and `entitlementsProvider` are non-`autoDispose`. The next student to sign in on the same handset sees the previous student's name, level, points, school and entitlements on Home. On a shared device — the norm in this market — this is **disclosure of one minor's PII to another**. | `auth_controller.dart:56-71` (no `ref.invalidate`), `me_notifier.dart:39,73` (not `autoDispose`), reachable at `profile_screen.dart:348` and automatically via `auth_interceptor.dart:75,129,144,146` | 6 (F-6-01) + 9 (F-9-03) · **re-verified by orchestrator** |

**On C-1's severity.** Agent 9 filed this HIGH; the orchestrator raised it to
CRITICAL after independent verification. One caveat is recorded honestly: Flutter's
manifest merger lets *plugin* manifests contribute permissions, so a plugin could
in principle supply `INTERNET`. Agent 9 reports none does. This cannot be settled
without building. **Verification is one command** — see `known-issues.md`.

**On C-2's severity.** Both agents filed HIGH independently, from different
angles (Agent 6: state correctness; Agent 9: data protection). Merged and
raised, because the two angles compound: it is not merely a stale-cache bug, it
is a stale-cache bug in an app that holds minors' PII on shared hardware. The fix
is **one line**, using a pattern the codebase already contains at
`edit_profile_notifier.dart:57`.

### HIGH

| # | Finding | Evidence | Agents |
| --- | --- | --- | --- |
| H-1 | **`/subscription` is a live dead-end on the revenue path.** The quiz paywall pushes a route that lands on `_Placeholder`: hardcoded English "Subscription — not built yet", bare `AppBar`, no theme. The Profile entry point was correctly disabled; this second door was missed. | `limit_sheet.dart:123` → `app_router.dart:250,347` | 3 (F-3-01), 6 |
| H-2 | **The first real API response with a schema drift will hang the app silently.** Repositories catch `on DioException` and `QuizBloc` catches `on AppException`, but `fromJson` runs *outside* Dio and throws `TypeError`. It escapes both catches, emits no state, and the screen sits on a spinner. The mock never sends a malformed body, so no test covers it. | repository catch clauses; `quiz_bloc.dart`; `mock_backend.dart:40` | 7 (F-7-01) |
| H-3 | **Onboarding's primary CTA dead-ends.** "Get Started" does `context.go('/register')` with no seeded draft → `RegistrationExpiredView`. This is the *exact* defect already found and fixed on Login and documented at `login_screen.dart:76-85`, never applied here. | `onboarding_screen.dart:54` | 6 (F-6-02) |
| H-4 | **There is no `TextTheme`.** `grep textTheme lib/` = 0 hits. 153 inline `TextStyle(`, 153 hardcoded `fontSize`, 82 `fontWeight`. This is the identical violation class the palette guard test was built to prevent, applied to typography, and completely uncaught. | `app_theme.dart` (69 lines, no `TextTheme`); worst: `login_screen.dart` (13), `signup_identity_screen.dart` (12), `otp_screen.dart` (11) | 4 (F-4-02), 5 |
| H-5 | **Dark-mode placeholder text is indistinguishable from typed text.** Dark `hint` and dark `textPrimary` are both `#FCFBF9` — pixel-identical at the same 18px. | `app_colors.dart:504,506`; rendered at `form_fields.dart:156-161` | 4 (F-4-01) |
| H-6 | **Inactive nav labels fail contrast badly in light mode.** `mutedText` `#B3B3B3` measures **2.03:1** on the light canvas (WCAG floor: 4.5:1), used for every inactive bottom-nav label at 11px and a 10px points caption. Dark is fine at 7.39:1 — a light-only defect, in a token whose own comment claims it "is not a guess". | `app_colors.dart`; `main_shell.dart:265,333`, `level_card.dart:147` | 4 (F-4-03) |
| H-7 | **No text-scale policy at all.** Zero references to `textScaler` anywhere. The Subjects grid overflows at **1.2×**, the quiz progress bar clips at **1.25×**, and five title bars clip at **1.3×** — on every question of every quiz. System font scaling is commonly raised on the target devices. | `subject_card.dart:21` via `subjects_screen.dart:175`; `quiz_screen.dart:259` | 5 |
| H-8 | **`ref.watch(...select(...))` is used zero times** in 70 `ref.watch` sites, and `Consumer(` zero times — a rule the project wrote down in **three** separate spec files. The 16 `ref.watch(isOnlineProvider).value == false` sites rebuild entire screens on every `connectivity_plus` emission. | `Performance.md:13`, `Flutter_Common_Mistakes.md:10`, `State_Management.md:31` vs. all 70 call sites | 2 (F-2-01), 9, 10 |
| H-9 | **Three structural test blind spots.** (a) The registration wizard's terminal screens never run through the real `routerProvider` — only a synthetic 3-route stub. This is BUG-001's exact seam, one screen further along. (b) OTP resend/countdown/rate-limit has **zero** coverage; every OTP test sets `resendAfterSeconds:0` to dodge the timer. (c) Connectivity is never real — 15 `isOnlineProvider` overrides, all `Stream.value`. | `registration_router_flow_test.dart`; `otp_notifier.dart:133-161`; `core_providers.dart:56` | 8 (F-8-01/02/03) |

### MEDIUM — 24 findings

Summarised by theme; full detail in the per-agent reports.

- **Architecture (Agent 1):** `Track` — the glossary's first binding term, used in
  26 files across 6 features — is declared inside `profile/models/student_profile.dart:29`,
  making `profile` an accidental shared kernel. `lib/core/` imports
  `lib/features/auth/` and forms a provider cycle the source itself acknowledges
  at `core_providers.dart:36-38`. Nothing *enforces* that `lib/dev/mock_backend.dart`
  stays out of release builds — it is excluded by convention only.
- **Reuse (Agent 2):** four parallel `AsyncValue`→4-state implementations despite
  `state_widget.dart:5` declaring itself "the ONLY place that switches on
  `ScreenState`"; `home_screen.dart:51` bypasses it. `signup_identity_screen.dart`
  privately re-implements four core form primitives (183 of its 389 lines), and its
  copy drops `FieldShell`, making it the only screen in the app that shows an
  error message with no error border.
- **API/data (Agent 7):** no 5xx arm and `ProblemDetails.traceId` — which
  `error-codes.md` calls "the support handle" — is never read, so the first
  production 500 is unsupportable. The mock short-circuits at `onRequest`, so
  nothing is ever JSON round-tripped, hiding `DateOnlyConverter` and every
  `includeIfNull: false` omission. `main_mock.dart` does not override
  `refreshDioProvider`, so a mock-mode refresh would hit `TBD.example`.
  **`hive_ce` × 3 packages are declared and entirely unused** — zero Dart
  references; there is no caching layer of any kind.
- **Security (Agent 9):** freezed `toString()` prints both bearer tokens in full
  (`TokenPair`) and a minor's name, phone, DOB, school and governorate
  (`StudentProfile`) — latent only because no crash reporter is wired yet, and a
  verbatim violation of `Storage_and_Security.md:22`. Screenshot protection ships
  2 of the 4 steps `Platform_Specifics.md` mandates. R8/minification is **off** and
  Dart obfuscation is undocumented, against `Flutter_Common_Mistakes.md:16`.
- **UI (Agent 3):** Day 7b's design pass finished sections A–D and stopped — the
  Days 00–3 screens still carry the pre-pass 24pt inset where the app-wide value
  is 20, and `otp_screen.dart:375` names 20 as "the app-wide horizontal padding"
  while its own siblings use 24. Three forks of the 35×35 back chip exist,
  including two bare `IconButton`s — the exact drift `circle_back_button.dart:12-14`
  says it was created to stop. Login's three legal links point at
  `levelup.example`, which never resolves.
- **State (Agent 6):** zero `ref.mounted` guards; nine post-`await` `state =`
  assignments in `autoDispose` notifiers, most reachable by popping the OTP
  screen mid-verify.
- **Testing (Agent 8):** `AuthRepository` is the only repository with no test —
  delete its body and the suite still goes green. 397 English string assertions.
  Five guard-test properties hold today and are enforced by nothing.
- **DevOps (Agent 10):** `analysis_options.yaml` is stock with zero project
  rules and no generated-file exclusion. Three sources disagree about the Flutter
  SDK version. `main` carries 3 commits `dev` does not. The rules live in four
  places with no sync mechanism.
- **Performance (Agent 9):** zero `memCacheWidth` at all 5 `CachedNetworkImage`
  sites — a full-resolution decode into memory on cheap devices.

### Recorded positives — checked specifically, found correct

Listing these matters: it tells the next reader (and Fable) which ground has
already been covered, so it is not re-audited.

- Keyboard handling: **all 8** text-field screens correctly inside scrollables.
- Safe areas: 25 sites, consistent and deliberate.
- The bottom nav bar survives **2.5×** text scale — it uses the explicit
  height-ratio pattern the rest of the app should copy.
- Repository uniformity: all 6 inject Dio, return domain models, throw typed
  `AppException`. Zero screens/notifiers/blocs import `package:dio`.
- 401 → refresh → retry: correct, with two independent loop guards, and
  `_refreshing ??=` assigns synchronously before any await so N concurrent 401s
  produce exactly one refresh.
- Release signing **fails closed** to an unsigned build — the debug-keystore
  fallback the brief warned about does not exist.
- Git history is clean of secrets across all 43 commits.
- `Brand.*` colour seeds are correctly sealed — zero references outside `lib/core/theme/`.
- All 15 `Colors.*` uses outside the theme layer are benign, judged individually.
- All 5 `BoxShadow` sites correctly use the `elevationShadow` token.
- The quiz Bloc rejects every illegal transition, backed by 29 `blocTest` cases.
- Asset hygiene is clean 1:1; both nested asset dirs correctly declared.
- `empty ≠ zero-items` is honoured everywhere it can occur.
- The mock backend is **better than assumed**: it emits 400/403/404/409/422/429
  with the real ProblemDetails envelope, a real `Retry-After` header, nulls for
  nullable fields and empty lists on purpose.

---

## 3. Where agents disagreed, and the resolution

Three genuine tensions surfaced. Recording them matters more than smoothing them
over — each was resolved against evidence, not by averaging.

**3.1 — Is the mock backend a fidelity risk?**
Agent 7 found it emits realistic 4xx bodies, nulls and empty lists, and
explicitly *corrected the orchestrator's premise* rather than confirming it.
Agent 8 found the app is never driven against it at all — the tests use mocktail
stubs. **Resolution: both are right and they compose.** The mock is high-fidelity
for status codes but cannot produce 401, 5xx, timeouts or malformed bodies, and
short-circuits at `onRequest` so nothing is JSON round-tripped. The gap is
therefore narrower than feared and sharper than assumed: transport failures and
serialisation round-trips are the untested surface. That is exactly H-2's
territory.

**3.2 — Is Arabic text expansion an overflow risk?**
The orchestrator's brief asserted Arabic runs 20–30% longer. **Agent 5 checked
the actual ARB pairs and refuted it** — Arabic here is mostly equal or shorter
(`See All`→`عرض الكل`), and the two longer strings already sit in ellipsised
`Expanded` slots. **Resolution: the premise was wrong and the agent was right to
say so.** The real RTL risk is *vertical*: Agent 5 read the bundled font tables
and found Inter 1.210em, Tajawal 1.200em, **Cairo 1.874em**. Arabic resolves to
Tajawal today so it is safe, but any fallback into Cairo makes every fixed-height
box 55% undersized. Compounding this, Agent 4 found **Tajawal has no w600 while
45 call sites request w600**, so Arabic semibold renders wrong and
`Cairo-SemiBold.ttf` can never load. Two agents, two halves of one defect.

**3.3 — Does the quiz need a countdown timer?**
`bloc/SKILL.md` and `State_Management.md:34` justify using Bloc partly via a
`QuizTimeExpired` event. Agent 2 found no timer in `quiz_bloc.dart`; Agent 6
found the omission is **deliberate**, citing `quiz_state.dart:93-96` → `seif_fight.md S7`.
**Resolution: the code is right and the written rule is stale.** Filed against
the spec, not the implementation. This is a `PRODUCT DECISION`, not a bug — the
design has a timer, the contract does not, and that conflict is already logged as
an open request to the backend partner.

---

## 4. The structural finding

Five agents, working independently on different scopes, converged on the same
shape:

| The project wrote the rule… | …and the code does not follow it | Found by |
| --- | --- | --- |
| `Performance.md:13`, `Flutter_Common_Mistakes.md:10`, `State_Management.md:31` — use `select()` | 0 of 70 `ref.watch` sites | 2, 9, 10 |
| `Storage_and_Security.md:22` — never expose tokens/PII in strings | freezed `toString()` prints both | 9 |
| `Platform_Specifics.md` — blur + screenshot-detection | 2 of 4 steps shipped | 9 |
| `Flutter_Common_Mistakes.md:16` — obfuscate at release | undocumented, R8 off | 9 |
| `screen-states/SKILL.md` — 4 states × AR/EN = 8 checks | 0 Arabic goldens; RTL coverage 0% | 3, 8 |
| `state_widget.dart:5` — "the ONLY place that switches on `ScreenState`" | 4 parallel implementations | 2 |
| `circle_back_button.dart:12-14` — created to stop back-chip drift | 3 forks exist | 3 |
| `Architecture_and_Folders.md` | wrong in 5 of ~10 assertions about current code | 1 |

**The pattern is not carelessness — it is the absence of enforcement.** Every
rule this project *did* mechanise has held perfectly: the palette guard test
means zero hardcoded colours, in 36k lines, with no exceptions. Every rule left
as prose has decayed. The gap between those two outcomes is the single most
actionable thing in this audit.

The remedy is not more documentation. It is converting the highest-value prose
rules into guard tests and lints — Agent 8 specified `test/core/discipline_test.dart`
(~120 lines, five properties that hold today and are enforced by nobody), and
Agent 10 specified a staged `analysis_options.yaml` with measured blast radius.
Those two artefacts together close most of the table above.

---

## 5. Gap analysis against the mission brief's checklist

| Area | State | Action |
| --- | --- | --- |
| Architecture | Strong; 2 medium boundary issues | Move `Track` to `core/models`; break the core→auth cycle |
| Flutter/Dart quality | Strong; 1 high (`select`) | Adopt `select()` at the 16 `isOnline` sites first |
| UI / Figma fidelity | Good; Day 7b pass incomplete | Finish sections E+; consolidate the back chip |
| Theme | Excellent discipline, **weak typography** | Add a `TextTheme`; fix 2 contrast defects |
| Responsive | **Weakest area — no strategy existed** | `docs/RESPONSIVE.md` written this pass; clamp `textScaler` |
| State management | Strong; Riverpod/Bloc split respected | Add `ref.mounted` guards |
| Navigation | Correct; no redirect loop possible | Fix onboarding CTA; kill `/subscription` dead-end |
| API / data | **Best-in-class model conformance** | Add a `fromJson` catch arm; delete dead `hive_ce` |
| Testing | 730 cases, 3 structural blind spots | Guard test; extend router flow; 3 integration tests |
| Security | Clean secrets; 3 release-only defects | `INTERNET` permission; `toString()`; R8 |
| Performance | Good; image decode unbounded | `memCacheWidth` at 5 sites |
| DevOps | **CI, hooks, lints all absent** | Built this pass — see `changed-files.md` |
| Documentation | Fragmented across 4 locations | `docs/PROJECT_GUIDE.md` written this pass |

---

## 6. What this audit did *not* cover

Stated plainly so the next reviewer does not assume coverage that does not exist.

- **Nothing was compiled, analysed, run or built.** No toolchain.
- **No device testing.** Visual QA, RTL rendering, keyboard behaviour on real
  hardware, and the release-build behaviour behind C-1 are all unverified.
- **No Figma comparison was performed this pass.** Agent 3 audited the *residue*
  of the project's prior device-vs-Figma passes rather than redoing them.
- **iOS was not audited.** Every platform finding is Android-specific.
- **No performance profiling.** All performance findings are static reasoning.
- **Coverage percentage is unknown** — and deliberately so; the real gaps are
  structural, and a coverage number would rise while the risk stayed put.
