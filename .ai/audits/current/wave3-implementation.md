# Wave 3 — Application Quality Implementation

> **STATUS: PARTIALLY COMPLETE — 3A, 3B, 3E implemented and VERIFIED. 3C
> rejected on evidence. 3D stopped, needs design input.**
>
> Written in an environment with **no Dart/Flutter toolchain**, so every batch
> was handed to the developer for validation before the next was started —
> the brief's own *"work in small batches"* instruction. That discipline caught
> two of my own defects mid-wave.
>
> | Batch | Result |
> | --- | --- |
> | 3A lifecycle | ✅ **849 passed / 0 failed**, analyze 0 issues |
> | 3B localization | ✅ **849 passed / 0 failed** — no count change, as predicted |
> | 3E cache / storage | ✅ **849 passed / 0 failed** |
> | 3C ScreenState | ✅ rejected — the finding was about a different type |
> | 3D typography | ⛔ stopped — see §5 |

---

## 1. Findings investigated

All twelve investigation targets were re-derived from source rather than
inherited from prior reports. Two prior claims did not survive.

| # | Finding | Verdict |
| --- | --- | --- |
| 3 | `ref.mounted` / async lifecycle | **CONFIRMED, narrowed** — 4 real sites, not 9 |
| 2 | Localization leaks | **CONFIRMED** — 2 genuine of 7 reported |
| 4 | ScreenState switch duplication | **REJECTED** — see §3 |
| 5 | Navigation dead-ends | **PARTIALLY REJECTED** — reachable, but not dead-ends |
| 6 | `memCacheWidth` | **CONFIRMED** — 5 sites, none set it |
| 7 | Hive | **CONFIRMED** — genuinely dead, 3 unused packages |
| 1 | Typography / TextTheme | **CONFIRMED — but a STOP condition**, see §10 |
| 8 | RTL / Arabic | Prior correction upheld; no new work |
| 9/10 | Theme + hardcoded colours | **REJECTED** — 0 violations, guard valid |
| 11 | Font metrics | Evidence, not an action |
| 12 | API boundary | Out of scope by instruction |

---

## 2. Findings CONFIRMED and FIXED — batch 3A

### The hazard, precisely

An `autoDispose` provider is disposed the moment its last listener goes. If that
happens while an `await` is in flight, the continuation resumes and assigns to
`state` on a dead notifier, which throws. It surfaces as an **unhandled async
error, not a crash** — which is exactly why 848 green tests never saw it.

### Scope: 4 sites, not 9

The K-13 finding said "9 sites, zero `ref.mounted` guards". Re-deriving from
source, only **`autoDispose`** providers can hit this. Non-`autoDispose`
providers live for the container's lifetime and cannot be disposed mid-await, so
guarding them would be cargo-cult.

| Notifier | autoDispose | Real hazard | User action that triggers it |
| --- | --- | --- | --- |
| `OtpNotifier.verify` / `.resend` | ✅ | **yes** | pop the OTP screen mid-verify |
| `EditProfileNotifier.save` | ✅ | **yes** | leave Edit Profile mid-save |
| `QuizSetupNotifier.create` | ✅ | **yes** | back out of setup while `POST /quizzes` runs |
| `SchoolSearchNotifier.loadMore` / `.refresh` | ✅ | **yes** | close the picker mid-page |
| `AuthController`, `LoginNotifier`, `MeNotifier`, `SubjectsNotifier`, `SubjectTreeNotifier`, `RegistrationSubmitNotifier` | ❌ | **no** | — deliberately untouched |

### Mechanism: an `onDispose` flag, not `ref.mounted`

`ref.mounted` would be the tidier expression of this. **I could not verify that
API exists in `flutter_riverpod` 3.3.2** — the pub cache is outside this
environment's reach — and three separate times this session I have shipped Dart
that failed to compile on an unverified assumption.

So the guard uses `ref.onDispose`, which `otp_notifier.dart:77` already proves
compiles in this codebase, setting a `bool _disposed`. Functionally equivalent,
zero API risk. If `ref.mounted` is confirmed available later, swapping to it is
a mechanical simplification.

### Placement matters more than presence

The brief warns against blanket `if (!ref.mounted) return;`. `OtpNotifier.verify`
shows why:

```dart
await ...writeTokens(...);                                  // must happen
ref.read(authControllerProvider.notifier).markAuthenticated();  // must happen
if (_disposed) return;                                      // <- guard HERE
state = state.copyWith(outcome: const AuthenticatedOutcome());
```

Guarding earlier — or wrapping the whole block — would write tokens and then
never flip auth, leaving a student authenticated but unrouted. That is a worse
bug than the one being fixed. The guard protects only the UI-state assignment;
every side effect that must survive the screen closing runs before it.

### A bug introduced and caught during this batch

The first version of the `EditProfileNotifier` fix called `ref.invalidate(meProvider)`
inside the disposed branch — to keep the profile fresh after an interrupted
save. **`ref` is dead too once the notifier is disposed**, so that would have
thrown for exactly the reason the guard exists. Corrected to touch nothing:

```dart
if (_disposed) return !result.hasError;
```

The accepted cost is recorded in the source: `meProvider` keeps the pre-edit
profile until something else refreshes it. A narrow staleness window (the
student left mid-request) is strictly better than an unhandled exception, and
closing it properly needs a live ref from the screen or router — a larger change
than this hazard justifies.

### Regression coverage

**Source-level guard** — `autoDisposeNotifiersWithoutDisposalFlag` in
`test/guards/rules.dart`, asserted in `project_rules_test.dart`. Any new
`autoDispose` notifier that `await`s without a disposal flag fails the suite.
Verified by simulation: 4/4 current files pass, an unguarded probe is caught,
and all 6 non-`autoDispose` notifiers are correctly ignored.

**A behavioural race test was considered and deliberately not written.**
Reproducing it requires disposing a provider at a precise point inside an
in-flight `await` — timing-sensitive by construction. Written blind, without a
toolchain to check it, such a test is likely to be flaky or to pass for the
wrong reason, which is worse than no test. Recorded as a deferred item rather
than faked.

---

## 3. Findings REJECTED as false positives

### ScreenState switch duplication — REJECTED

> **CORRECTED 2026-08-15 (Wave 4), per Fable finding W3-4.** The paragraph
> below originally claimed `ScreenState` was *"referenced in exactly three
> places"*. **That was wrong.** It appears in **18 files**. The error was mine
> and mechanical: the scan was `grep -rn "ScreenState" lib | head -12`, and I
> read a truncated result as a complete one.
>
> The **conclusion still stands** — no screen `switch`es on `ScreenState`, so
> there is nothing to centralise — but it rests on different evidence than
> stated. Fable's independent scan found two `AsyncValue → ScreenState` bridges
> (`catalog_states.dart:42`, `profile_screen.dart:103`) and one bypass
> (`home_screen.dart:51`). Those are `AsyncValue` mapping sites, not
> `ScreenState` switches, which is why the no-refactor verdict is unaffected.
>
> Recorded rather than quietly edited: a wrong number that produced a right
> answer is still a wrong number, and the next reader needs to know which part
> to trust.

`state_widget.dart:5` claims to be *"The ONLY place that switches on
`ScreenState`"*. Verified: **no screen switches on it.** The claim in the
source is accurate.

The prior audit's finding — *"4 parallel AsyncValue→4-state implementations"* —
is about **`AsyncValue`** handling, a different type. Conflating the two would
have produced a refactor chasing a problem that does not exist. Whether the
`AsyncValue` mapping duplication is worth centralising is a separate question,
deferred to §5.

### Hardcoded colours — REJECTED as work

0 violations across `lib/`, guard valid and passing. The brief explicitly says
not to perform a meaningless mass refactor. No action.

### Navigation "dead-ends" — PARTIALLY REJECTED

`/subscription` **is** reachable, from `limit_sheet.dart:127`. But it uses
`context.push`, not `context.go`, so **back navigation works** — it is not a
dead-end in the trapped sense. The real defects are that the screen is
unbuilt and its placeholder text is hardcoded English (§4).

Three routes share `_Placeholder`: `/track-select` (132), `/subscription` (258),
`/paymob-return` (262). Only `/subscription` has a user-reachable entry point.

---

## 4. Findings CONFIRMED, NOT YET IMPLEMENTED

### 3B — Localization — IMPLEMENTED (validated pending)

**Both genuine leaks needed ZERO new ARB keys.** `retry` and `comingSoon`
already existed in both `app_en.arb` and `app_ar.arb` with proper Arabic
(`إعادة المحاولة`, `قريبًا`). No translation was invented, ARB parity was never
at risk, and gen-l10n has nothing new to generate.

| Site | Fix |
| --- | --- |
| `state_widget.dart` `Text('Retry')` | → `AppLocalizations.of(context).retry` |
| `app_router.dart` `'$title — not built yet'` | → `AppLocalizations.of(context).comingSoon` |

`state_widget.dart` was the **only English holdout among ten retry buttons** —
the other nine already read `l10n.retry`. It is the shared fallback reached from
every screen without a custom error view, which is precisely why it survived:
the screens that are well-tested pass their own error view, so this path is
lightly exercised.

The `_Placeholder` app-bar title is deliberately left as the raw route name. It
is a developer label for an unbuilt route, not product copy; the body is the
line a student reads. Localising the placeholder is an **interim** fix — the
real choice (disable the paywall entry point as Profile's was, or build the
screen) is a product decision, recorded in §8.

**Ratchet lowered 7 → 5, after remediation, not to make anything pass.** The
five remaining are all genuinely untranslatable: two flag emoji and three
punctuation joiners between already-localized halves
(`Text('${l10n.legalPrefix} ')`). **Zero genuine leaks remain.** The allowlist
dropped `app_router.dart` and `state_widget.dart` because they are now clean.

### 3B — original investigation (2 genuine leaks of 7 reported)

| Site | Verdict |
| --- | --- |
| `state_widget.dart:76` `Text('Retry')` | **Genuine, and the worst of the seven** — the shared retry button on *every* error state in an Arabic-baseline app |
| `app_router.dart:362` `'$title — not built yet'` | **Genuine** — reachable via `/subscription` |
| `login_screen.dart:340`, `signup_identity_screen.dart:335` — `Text('🇪🇬')` | Not translatable |
| `login_screen.dart:429/431/433` | Punctuation joining already-localized halves |

Fix is small and low-risk. Held back only to keep batch 3A independently
verifiable.

### 3E — `memCacheWidth`: 5 `CachedNetworkImage` sites, none set it

`home_header`, `edit_profile_screen`, `avatar_sheets`, `profile_header_card`,
`mcq_renderer`. Avatars render small but decode at full resolution — a real
memory cost on the low-end Android devices this app targets. Genuine, small fix.

### 3E — Hive: genuinely dead

`hive_ce`, `hive_ce_flutter`, `hive_ce_generator` in `pubspec.yaml`; **zero**
Dart references. The only three matches are comments *saying data is not cached
to Hive*. Removing three unused dependencies is safe but touches the dependency
graph and lockfile — worth its own batch.

---

## 5. STOP condition — 3D typography

**Not implemented, and not attempted, deliberately.**

153 inline `fontSize` values across 49 files, no `TextTheme`. The brief asks for
semantic styles — headline / title / body / label / caption — and says *"Do NOT
blindly convert every fontSize"* and *"use engineering judgment"*.

The blocker is that **the mapping from a size to a semantic role is a design
decision that cannot be inferred from the repository.** Nothing in the source
says whether `fontSize: 18` on the Home greeting is `titleMedium` or
`headlineSmall`; the screens were built frame-by-frame from Figma, and the sizes
cluster without a documented scale. Choosing a mapping myself would invent a
design system and then bake it into 49 files.

This meets the brief's own stop criterion: *"a design decision cannot be
inferred from the repository"*. It also meets *"a major architecture rewrite
appears necessary"* — a `TextTheme` plus 153 call-site migrations is not a
small batch.

**What is needed to proceed:** the design's type scale (the distinct sizes and
what each is *for*), or a decision to derive one from the existing clusters and
review it against Figma. Both are product/design input, not engineering
inference.

**The ratchet is left at 153 and has NOT been lowered.** Lowering it without
genuine remediation is explicitly forbidden and would be a false fix.

---

## 6. Files changed (batch 3A)

| File | Change |
| --- | --- |
| `lib/features/auth/notifier/otp_notifier.dart` | disposal flag + 7 guards across `verify`/`resend` |
| `lib/features/profile/notifier/edit_profile_notifier.dart` | disposal flag + guard in `save` |
| `lib/features/quiz/notifier/quiz_setup_notifier.dart` | disposal flag + guard in `create`; split `state = await` |
| `lib/features/registration/notifier/school_search_notifier.dart` | disposal flag + 3 guards; split `state = await` |
| `test/guards/rules.dart` | new detector |
| `test/guards/project_rules_test.dart` | new guard test |
| `.ai/audits/current/wave3-implementation.md` | this file |

No routing, API, contract, theme, CI, hook or Wave-2 guard architecture touched.
No test deleted or weakened. No dependency added. No baseline lowered.

---

## 7. Validation

**NOT YET RUN** — no toolchain here. Batch 3A adds 1 guard test, so the expected
count is **849** (848 + 1). Any other number needs explaining before the batch
is accepted.

---

## 8. Remaining and deferred

| Item | Status |
| --- | --- |
| 3B localization (2 sites) | Confirmed, not implemented |
| 3E `memCacheWidth` (5 sites) | Confirmed, not implemented |
| 3E Hive removal (3 packages) | Confirmed, not implemented |
| 3E `/subscription` entry point | Confirmed; **product decision** — disable the entry or build the screen |
| 3C `AsyncValue`→4-state duplication | Investigated; centralising is a judgement call, not a defect |
| 3D typography | **STOPPED** — needs design input |
| Behavioural race test for 3A | Deferred — flaky by construction without a toolchain |
| `ref.mounted` instead of the flag | Deferred — mechanical, once the API is confirmed |


---

## 9. Batch 3E — UI / cache / storage

### `memCacheWidth` — 4 of 5 sites fixed, 1 deliberately not

`CachedNetworkImage` decodes at the **source** resolution unless told otherwise.
A 1024px avatar drawn at 51dp costs roughly 4 MB of heap instead of ~110 KB. On
the low-end Android handsets this app targets, with several avatars alive at
once, that is a real cost rather than a micro-optimisation.

| Site | Drawn at | Fixed |
| --- | --- | --- |
| `home_header.dart` | 51dp | ✅ |
| `profile_header_card.dart` | 69dp | ✅ |
| `avatar_sheets.dart` | 69dp, **in a grid** | ✅ — worst case, the cost multiplies by the number on screen |
| `edit_profile_screen.dart` | 151dp | ✅ — smallest saving, still caps an oversized source |
| `mcq_renderer.dart` | full-width question image | ❌ **deliberately not** |

`mcq_renderer` was left alone on purpose. It renders **question artwork** —
diagrams a student has to read — at a width that depends on the screen rather
than a fixed constant. Downsampling educational content to save memory is a
legibility trade the audit did not ask for and that nothing in the repository
justifies. The brief's instruction was *"fix only if there is a real issue… do
not optimize blindly"*; on that site the issue is not established.

Values are scaled by `MediaQuery.devicePixelRatioOf(context)` rather than a
hardcoded 2x/3x guess, so the cap tracks the actual display.

### Hive — 3 dead packages removed

`hive_ce`, `hive_ce_flutter` (dependencies) and `hive_ce_generator`
(dev_dependency) were declared and **never used**: zero Dart references in
`lib/` or `test/`, no generated adapters anywhere, no `build.yaml`. The only
three matches in the whole codebase are comments stating that quiz data is
deliberately *not* cached to Hive.

This is removal of unused dependencies, **not** a storage migration — the brief
forbids the latter and this is not it. There is no caching layer in this app;
Riverpod holds state in memory and that is the design.

**`pubspec.lock` will change.** `validate.ps1` will report lockfile drift on the
next run, which is correct and expected — the regenerated lock needs committing
alongside `pubspec.yaml`.

### `/subscription` entry point — NOT changed, product decision

`limit_sheet.dart:127` pushes `/subscription` from the quiz paywall. Wave 3
localised the placeholder body so it no longer shows English text, but the
underlying choice — **disable the entry point** (as the Profile row already was)
**or build the screen** — decides whether students hitting the weekly quiz limit
see a dead end or a paywall. That is a product call about the revenue path, not
an engineering one, and it is left open deliberately.


---

## 10. Batch 3E — validation

```
dart format      PASS
flutter analyze  PASS   0 issues
flutter test     PASS   849 passed / 0 failed
OVERALL          PASS
```

### The Hive analysis was confirmed by `pub get`

Removing three declared packages actually dropped **five**:

```
- hive_ce 2.19.3
- hive_ce_flutter 2.3.4
- hive_ce_generator 1.11.2
- isolate_channel 0.6.1      <- transitive, existed only for hive_ce
- yaml_writer 2.1.0          <- transitive, existed only for hive_ce_generator
Changed 5 dependencies!
```

Nothing outside that subtree depended on any of them, which independently
confirms the dead-dependency finding: had any application code used Hive, the
resolver would have failed rather than quietly dropping the graph. `pubspec.lock`
changed and must be committed alongside `pubspec.yaml`.

### Test count unchanged across all three batches

849 before and after 3B and 3E. Neither batch added a test: 3B rewired two
existing call sites to keys that already existed, and 3E changed image decode
parameters and dependency declarations. **Behaviour that no test covers did not
gain a test** — recorded plainly rather than papered over. The one new test in
Wave 3 is the 3A source-level guard (848 → 849).

---

# Wave 3D — Typography

**STOPPED. No code changed. Ratchet unchanged at 153.**

The previous stop was an assumption — *"the design probably doesn't define a
scale"*. This one is a finding: I queried the actual Figma file and it does not.

## Design source used

Figma file `P6044i0giD9TmdQ7C2AmLq`, via the Figma MCP, authenticated as the
project account (View seat). Four independent sources were checked.

### 1. Figma typography variables — one style, and it isn't ours

`get_variable_defs` on three major screens:

| Screen | Node | Typography variables returned |
| --- | --- | --- |
| Login | `82:819` | `Regular/None/Medium` — Inter Medium 16/16/0 |
| Home | `337:5303` | `Regular/None/Medium` — same |
| Sign Up_1 | `337:15875` | `Regular/None/Medium` — same |

**One text style across the whole app**, and on Login and Sign Up it appears
alongside the `Countries/Africa/EG - Egypt/*` colours — i.e. it is bound to the
imported country-flag component, not authored for this product. A design system
with a semantic scale would return `Display/…`, `Headline/…`, `Body/…` here. It
returns one kit default.

### 2. Figma layer names — content, not roles

`get_metadata` on the Login frame. Every text layer is named after **the words
it contains**:

```
<text id="82:885"  name="Welcome back" />
<text id="82:886"  name="Enter your phone number to continue" />
<text id="82:894"  name="Phone Number" />
<text id="82:1068" name="Send OTP" />
<text id="82:1069" name="OR" />
<text id="82:1073" name="Create New Account" />
```

Containers carry auto-generated names — `Frame 427319516`, `Group 37218`. The
only semantically named node in the entire frame is `Button / Light`, a
component. **Not one layer encodes a typographic role.**

### 3. The twelve day briefs — silent on typography

`docs/day*_brief.md` are the per-screen implementation specs, written from the
frames. Across all twelve: **two incidental mentions**, neither a scale
(`day7b` notes one label at "~14 / line-height 21"; `day00` records one heading
as "22 w600"). No size table, no role names, no scale.

### 4. The code — 17 sizes, no `TextTheme`

```
 size  uses  files          size  uses  files
 44.0     1      1          14.0    31     21
 36.0     2      2        13.145     2      1
 32.0     4      4          13.0     7      5
 28.0     1      1          12.0     7      5
 24.0     1      1          11.0     5      4
 22.0    23     16          10.0     2      2
 20.0    12      9
 19.0     1      1        total 153 occurrences, 17 distinct sizes
 18.0    33     15        weights: w600 x45, bold x23, w500 x13, w700 x1
 16.0    20     17
 15.0     1      1
```

## Why this is a stop, not a judgement call

Four sizes carry 70% of all uses (18, 14, 22, 16) and there is a long tail of
true one-offs (44, 28, 24, 19, 15, and a computed `13.145`). It is tempting to
read a scale out of that shape.

**The brief explicitly forbids it:** *"Do NOT infer a type scale merely from the
numeric frequency of fontSize values."* And the prohibition is right. Frequency
tells you 18 is common; it does not tell you whether 18 on the Home greeting is
`titleMedium` or `headlineSmall`. Those Material slots carry defined meaning,
and assigning one is a **design claim**, not an engineering deduction. Making
153 of them would author a type scale under the guise of a refactor — and freeze
it into 49 files where changing it later is another 49-file migration.

The design was built **frame by frame with per-element font settings**. That is
a legitimate way to design; it simply means the semantic layer this migration
needs has never existed, in Figma or in the briefs.

## Exactly what is missing

1. **The set of roles.** Which semantic levels the product actually has —
   display / headline / title / body / label / caption, or a shorter set.
2. **Size → role assignment**, at minimum for the four sizes carrying 70% of
   uses: **18, 14, 22, 16**. These four alone would let ~107 of 153 call sites
   migrate.
3. **A ruling on the long tail.** Are 44 / 36 / 32 / 28 / 24 / 19 / 15
   deliberate one-offs (hero numerals, a single illustration caption) or drift
   that should collapse into the scale?
4. **`13.145` in `ai_explanation_panel.dart`** — not a designed value. Almost
   certainly a computed or pasted artifact. Needs a decision: round to 13, or
   confirm it is intentional.
5. **Weight pairing.** `w600` × 45 and `bold` × 23 are used interchangeably in
   places; a scale needs to say which weight belongs to which role.

## What would unblock it

Any one of:

- **The designer names the levels** and assigns the four dominant sizes. Half a
  page of answer; migration is then mechanical and reviewable.
- **A Figma text-style pass** — define styles in the file and apply them. The
  MCP would then return the scale directly and this becomes a lookup.
- **An explicit decision to derive** the scale from the existing clusters and
  review the result against the frames. Legitimate, but it is a **product
  decision to author a design system**, and must be recorded as one rather than
  smuggled in as a refactor.

## State

- Original baseline: **153**
- Migrated values: **0**
- Remaining intentional exceptions: **n/a — nothing was migrated**
- Theme changes: **none**
- Light / dark / RTL verification: **n/a — no visual change made**
- Ratchet: **unchanged at 153**, deliberately. Lowering it without remediation
  is a false fix and is explicitly forbidden.

The `153` in `project_rules_test.dart` remains the honest signal that this work
is outstanding. It also still does its job: no new screen can raise the count
while the design question is open.
