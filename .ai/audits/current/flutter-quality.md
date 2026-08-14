# Agent 2 — Flutter/Dart Quality

**Scope:** Idiomatic Dart, widget composition, rebuild scope, state lifecycle,
async correctness, duplication, oversized widgets, dead code, inappropriate
abstractions, `const` discipline, list rendering.

**Baseline:** dev @ e3651e6

**Repository areas inspected:** all of `lib/` except `*.freezed.dart`,
`*.g.dart`, `lib/l10n/app_localizations*.dart`. Read in full: the eight named
screens, `lib/core/widgets/{state_widget,offline_banner,form_fields}.dart`,
`lib/core/providers/core_providers.dart`, `lib/app.dart`,
`lib/features/quiz/bloc/quiz_bloc.dart`, `lib/features/quiz/screens/quiz_screen.dart`,
`lib/features/home/screens/home_screen.dart`,
`lib/features/settings/screens/settings_screen.dart`,
`lib/features/catalog/widgets/catalog_states.dart`,
`lib/features/catalog/screens/{subjects,units,chapters,lessons,lectures}_screen.dart`,
`lib/features/catalog/widgets/quiz_type_tabs.dart`,
`lib/features/registration/screens/university_detail_screen.dart`,
`lib/features/registration/widgets/{city_field,school_picker_field}.dart`,
`lib/features/registration/notifier/{reference_providers,school_search_notifier}.dart`,
`lib/features/profile/{notifier/me_notifier.dart,widgets/avatar_sheets.dart}`,
`lib/features/auth/notifier/otp_notifier.dart`.
Cross-checked against `level_up/01_Flutter_Specs/{Flutter_Common_Mistakes,Performance,State_Management}.md`.

---

## Findings

### F-2-01 [HIGH] [QUALITY IMPROVEMENT] `ref.watch(provider.select(...))` is used exactly zero times in the app — a rule the project wrote down three times and then never applied

**Evidence:**
- The rule, stated by the project itself: `level_up/01_Flutter_Specs/Performance.md:13`
  — "`ref.watch(provider.select(...))` to narrow rebuilds"; `Flutter_Common_Mistakes.md:10`
  — "`select()` instead of parent-wide rebuilds"; `State_Management.md:31` —
  "Use `ref.watch(provider.select((u) => u.totalPoints))` to rebuild only what changed."
- Measured: 70 `ref.watch(` call sites in `lib/`. Grep for `.select(` returns
  **two** hits, both unrelated — `settings_screen.dart:96` and `:136` call a
  `Notifier` *method* named `select`, not `ProviderListenable.select`.
- Measured: **zero** `Consumer(` builder widgets in `lib/`. The only
  rebuild-scoping tool in use is "promote the subtree to its own `ConsumerWidget`".

Highest-value sites, in order:

1. **`settings_screen.dart:183`** — `_RankSection` does `ref.watch(meProvider)`
   and reads only `profile.privacy.leaderboardVisible` (`:228`) and
   `profile.privacy.scoreHidden` (`:238`). Any `/me` invalidation — after every
   finished quiz (`quiz_screen.dart:213`), after every avatar or name save —
   rebuilds this section. Textbook `select`.
2. **16 × `ref.watch(isOnlineProvider).value == false`** (`login_screen.dart:124`,
   `otp_screen.dart:58`, `home_screen.dart:42`, `profile_screen.dart:58`,
   `edit_profile_screen.dart:62`, `settings_screen.dart:44`,
   `subjects_screen.dart:48`, `subject_tree_screen.dart:39`,
   `chapters_screen.dart:35`, `lessons_screen.dart:39`,
   `quiz_setup_screen.dart:54`, `school_detail_screen.dart:73`,
   `university_detail_screen.dart:61`, `signup_identity_screen.dart:98`,
   `signup_track_screen.dart:51`). The provider is
   `StreamProvider<bool>` (`core_providers.dart:57`) mapped off
   `connectivity_plus`'s `onConnectivityChanged`, which emits on *any* transport
   change (wifi→wifi+vpn, mobile→mobile) — every such emission produces a new
   `AsyncData<bool>` identity and rebuilds the entire screen even when the
   derived boolean is unchanged. `ref.watch(isOnlineProvider.select((v) => v.value == false))`
   collapses that to a `bool` and drops the rebuild.
3. **`school_detail_screen.dart:71`** / **`university_detail_screen.dart:59`** —
   `ref.watch(registrationControllerProvider)` returns the whole draft. Every
   setter (`setCountry`, `setCity`, `setDateOfBirth`, …) rebuilds all seven
   dropdown subtrees plus the `CityField` and `SchoolPickerField` states.
4. **`home_screen.dart:39`** / **`profile_screen.dart:55`** /
   **`edit_profile_screen.dart:61`** — watching the whole
   `AsyncValue<StudentProfile>` at the screen root is *correct* (they need the
   four states), but nothing below narrows: `HomeHeader`, `LevelCard`,
   `ProfileHeaderCard`, `ProfileStatCard` are all rebuilt for a change to any
   unrelated profile field.

`settings_screen.dart` is the one file that already does the right shape —
`_LanguagesSection` / `_ModeSection` / `_RankSection` are separate
`ConsumerWidget`s each subscribing to one provider (`:93`, `:133`, `:183`), and
its `ListView` children are `const` (`:57-65`) so the top-level
`isOnlineProvider` watch cannot leak into them. That is the pattern to copy.

**Why it matters:** the project's stated performance target is "smooth on a
mid-range Android device" (`Performance.md:7`). This is the single cheapest
mechanical win available and the codebase has none of it.

**Recommended fix:** in priority order — (a) the `isOnlineProvider` idiom (one
`select`, 16 call sites, no behaviour change); (b) `_RankSection`; (c) split the
two registration screens' draft reads. Consider a
`bool get isOffline(WidgetRef ref)` extension so (a) is a one-token change per site.

**Risk of fixing:** low and mechanical for (a) and (b). (c) needs care: the
draft is a single object, so narrowing means either `select` per field or
splitting the form into per-field `ConsumerWidget`s.

**Validation required:** DevTools "Track widget rebuilds" on Home and Settings
with the connectivity stream toggling, before and after. Cannot be measured in
this environment.

---

### F-2-02 [MEDIUM] [ARCHITECTURE ISSUE] Four parallel implementations of "AsyncValue → four screen states", in a codebase whose shared component documents itself as the only one

**Evidence:** `core/widgets/state_widget.dart:5-6` — *"The ONLY place that
switches on `ScreenState`. If a screen re-derives its own state enum or
booleans, fix that first."* In practice:

| Implementation | Location | Uses `StateWidget`? |
|---|---|---|
| `CatalogAsyncView<T>` | `catalog_states.dart:20` | yes (`:55`) |
| `profileScreenState()` | `profile_screen.dart:103` | yes (`:73`) |
| ad-hoc `me.when(...)` | `home_screen.dart:51` | **no** |
| `EditProfileScreen` | `edit_profile_screen.dart:72` | yes, reuses `profileScreenState` |

`CatalogAsyncView` (`catalog_states.dart:20-81`) is already the generic,
correct version — `AsyncValue<T>` in, `isEmpty` predicate, skeleton slot,
offline-by-exception-type, retry suppression for `insufficient_scope`. It is
identical in intent to `profileScreenState` (`profile_screen.dart:103-112`) and
to `home_screen.dart:51-58`, but lives under `features/catalog/`.

The leaf widgets have multiplied with it:

- **Centred icon + text + retry**, 5 copies: `state_widget.dart:47 _CenterMessage`,
  `catalog_states.dart:85 CatalogMessage`, `profile_screen.dart:403 _Message`,
  `edit_profile_screen.dart:707 _Message` (byte-identical to the previous one),
  `home_screen.dart:174 _Failure`.
- **Grey skeleton block**, 4 copies: `catalog_states.dart:129 CatalogBlock`,
  `profile_screen.dart:382 _Block`, `home_screen.dart:152 _Block`, and an inline
  `block()` closure at `edit_profile_screen.dart:668`.

**Why it matters:** `home_screen.dart` bypassing `StateWidget` entirely means
Home's offline view is chosen by `isOffline(error)` inline at `:183` rather than
by the shared mapping — the two can drift, and the shared file's own contract
says they must not.

**Recommended fix:** promote `CatalogAsyncView` to `core/widgets/` as
`AsyncStateView<T>` (it has no catalog-specific code beyond the
`insufficient_scope` branch, which can become an optional predicate), promote
`CatalogMessage` and `CatalogBlock` alongside it, and route Home, Profile and
Edit Profile through it. Deletes roughly 200 lines.

**Risk of fixing:** medium — five screens change shape. Golden tests exist for
Home's header and the track screen; they will need re-baselining if paddings
shift. Do it as one commit, not incrementally.

**Validation required:** `flutter test` including `test/goldens/`.

---

### F-2-03 [MEDIUM] [QUALITY IMPROVEMENT] `OfflineBanner` is a shared core widget used by 13 screens; the two auth screens each carry a private byte-identical copy

**Evidence:** `core/widgets/offline_banner.dart:11-46` versus
`login_screen.dart:274-309` and `otp_screen.dart:138-173`. All three are the
same `Material(color: cs.errorContainer)` → `Padding(h16 v10)` → centred `Row`
→ `Icon(Icons.wifi_off, 18)` → `SizedBox(width: 8)` → `Flexible(Text(l10n.offline, w600, 14))`,
down to the doc comment. Thirteen other screens already import the core one
(`home_screen.dart:49`, `profile_screen.dart:71`, `settings_screen.dart:50`,
`school_detail_screen.dart:99`, `signup_identity_screen.dart:109`, and 8 more).

Same file pair: `_InlineMessage` is duplicated at `login_screen.dart:376` and
`otp_screen.dart:453` (the only difference is `Expanded` vs `Flexible` and a
`MainAxisAlignment.center`).

**Why it matters:** the offline banner is the one cue that has to look
identical everywhere, and it is the one component with three sources.

**Recommended fix:** delete both private classes, import
`core/widgets/offline_banner.dart`. Lift `_InlineMessage` next to it as a shared
`InlineMessage`.

**Risk of fixing:** none — the widgets are identical, and `const _OfflineBanner()`
→ `const OfflineBanner()` is a rename.

**Validation required:** `flutter test`.

---

### F-2-04 [MEDIUM] [QUALITY IMPROVEMENT] `signup_identity_screen.dart` re-implements four `core/widgets/form_fields.dart` primitives privately

**Evidence:**

| Private copy | Shared original | Delta |
|---|---|---|
| `signup_identity_screen.dart:207 _FieldLabel` | `form_fields.dart:16 FieldLabel` | none |
| `signup_identity_screen.dart:369 _InlineError` | `form_fields.dart:101 InlineFieldError` | none |
| `signup_identity_screen.dart:227 _PlainField` | `form_fields.dart:126 PlainTextField` | rebuilds the pill inline instead of using `FieldShell`, so it **cannot render the error border** — the error text at `:160`/`:175` appears with no field highlight, unlike every other form in the app |
| `signup_identity_screen.dart:315 _DialCodePhoneField` | `login_screen.dart:311 _PhoneField` | `enabled`/`onSubmitted` dropped; otherwise identical |

The `_DialCodePhoneField` / `_PhoneField` pair duplicates the phone-entry
primitives specifically: the `🇪🇬` glyph (`signup:334` / `login:338`), the
`Phone.egyptDialCode` chip, and `FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))`
(`signup:352` / `login:358`).

**Why it matters:** the input mask that decides what a student can type into a
phone field exists in two places. `Phone.tryParse` is shared; the thing that
feeds it is not.

**Recommended fix:** delete `_FieldLabel` and `_InlineError` outright (pure
renames). Replace `_PlainField` with `PlainTextField` — this also fixes the
missing error border. Extract the phone field to
`core/widgets/dial_code_phone_field.dart` with `enabled`/`onSubmitted` optional,
and use it from both screens.

**Risk of fixing:** low. `_PlainField` → `PlainTextField` changes the rendered
border on error, which is a visible (and correct) change; check no widget test
asserts the absence of it.

**Validation required:** `flutter test`, plus an RTL screenshot of Sign Up_1.

---

### F-2-05 [MEDIUM] [ARCHITECTURE ISSUE] `school_detail_screen` and `university_detail_screen` duplicate ~120 lines of registration-form scaffolding

**Evidence:** identical or near-identical in both files —

| Concern | School | University |
|---|---|---|
| `_edit(void Function())` | `:62-65` | `:50-53` |
| `_handleSubmitOutcome(l10n)` incl. post-frame `reset()` | `:339-366` | `:290-312` |
| `_namedRefRows(List<NamedRef>)` | `:431-438` | `:326-333` |
| local `errorFor(String)` | `:90-93` | `:81-84` |
| `_cityOptions` | `:394-411` | `:314-324` |
| Scaffold→SafeArea→Column→OfflineBanner→Expanded→SingleChildScrollView→`RegistrationHeader`→title→subtitle | `:95-121` | `:86-112` |
| submit `FilledButton` + inline spinner | `:283-303` | `:255-275` |

**Why it matters:** the submit-outcome handler is the piece that navigates to
`/home`, resets the draft after the frame, and restarts at `/login` on
`registration_token_invalid`. Two copies of that is two places to get the
post-frame ordering wrong.

**Recommended fix:** a `RegistrationFormScaffold` widget for the chrome and a
`RegistrationSubmitMixin<T extends ConsumerStatefulWidget>` carrying `_edit`,
`_handleSubmitOutcome`, `errorFor` and `_namedRefRows`. The *field lists* stay
per-track — they legitimately differ (adr-010).

**Risk of fixing:** medium. These are the two screens where a mistake strands a
student mid-registration with a consumed token. Cover with widget tests for both
outcomes on both tracks before touching.

**Validation required:** `flutter test`, including the registration expiry-guard tests.

---

### F-2-06 [MEDIUM] [QUALITY IMPROVEMENT] Conditional `ref.watch` inside a helper called from `build`, plus a post-frame callback rescheduled every build

**Evidence:** `school_detail_screen.dart:320-336`

```dart
void _seedDefaultCountry(String? currentCode) {
  if (currentCode != null) return;            // :321 — early return
  final countries = ref.watch(countriesProvider).value;   // :322 — conditional watch
  ...
  WidgetsBinding.instance.addPostFrameCallback((_) { ... });  // :328
}
```

called unconditionally from `build` at `:76`.

Two problems:

1. **The `ref.watch` at `:322` runs on some builds and not others.** Riverpod
   drops a subscription that is not re-established during a build, so this
   provider's subscription lifetime depends on a data condition. It currently
   works only because `_countryOptions()` (`:370-387`) watches the same provider
   unconditionally from `:139` — coincidence, not design. Restructure the country
   dropdown and the seeder silently stops firing. Note that the same build also
   returns early at `:79-81` (`RegistrationExpiredView`), so the *set* of watched
   providers legitimately differs between the guard branch and the form branch.
2. **`:328` schedules a fresh `addPostFrameCallback` on every build** while
   `countryCode` is null. The callback body re-checks (`:330`) so it is idempotent,
   but the scheduling is not bounded.

**Why it matters:** conditional `ref.watch` is the Riverpod failure mode that
does not throw — it just quietly stops updating. The current correctness is
accidental.

**Recommended fix:** hoist `ref.watch(countriesProvider)` to the top of `build`
unconditionally and pass the value into `_seedDefaultCountry`. Guard the
scheduling with a `bool _seedScheduled` field.

**Risk of fixing:** low, and it is a strict improvement.

**Validation required:** the existing school-registration widget tests must
still show Egypt pre-selected.

---

### F-2-07 [LOW] [QUALITY IMPROVEMENT] Dead code: `schoolsProvider` and `SchoolsQuery`

**Evidence:** `reference_providers.dart:23-33` (`typedef SchoolsQuery`) and
`:52-62` (`final schoolsProvider = FutureProvider.family<CursorPage<NamedRef>, SchoolsQuery>`).
Zero references in `lib/` and zero in `test/`. Superseded by
`SchoolSearchNotifier` / `schoolSearchProvider` (`school_search_notifier.dart:130`),
which is what `school_picker_field.dart:188` actually watches. Its own doc
comment at `:25` still promises *"Day 3 wires the infinite-scroll on top of
this"* — Day 3 wired a different notifier instead.

**This is the only dead code in `lib/`.** A mechanical sweep of every public
`class`/`mixin`/`enum`/`extension`/`typedef` and every `*Provider` in `lib/`,
counted against all of `lib/` plus all of `test/`, produced exactly this one
result. Every non-entrypoint file in `lib/` is imported by another file
(`lib/main.dart` is the deliberate `flutter run` shim documented at its `:1-3`).

**Recommended fix:** delete both. Adopt whichever `///` prose is still accurate
into `SchoolSearchNotifier`'s doc.

**Risk of fixing:** none.

**Validation required:** `flutter analyze` to confirm no import becomes unused.

---

### F-2-08 [LOW] [QUALITY IMPROVEMENT] Two `ConsumerWidget`s that never touch `ref`

**Evidence:** `profile_screen.dart:114 _Loaded` — `build(BuildContext, WidgetRef ref)`
at `:120`, `ref` unused through `:150`. `school_picker_field.dart:26 SchoolPickerField`
— `build(BuildContext, WidgetRef ref)` at `:61`, `ref` unused through `:119`
(the sheet it opens is its own `ConsumerStatefulWidget`).

**Why it matters:** a `ConsumerWidget` reads as "this subscribes to something".
Both should be `StatelessWidget`.

**Recommended fix:** downgrade both. `profile_screen.dart:173 _Menu` should stay
a `ConsumerWidget` — it genuinely needs `ref` at `:287`/`:333`.

**Risk of fixing:** none.

**Validation required:** `flutter analyze`.

---

### F-2-09 [LOW] [OPTIONAL IMPROVEMENT] `StateWidget` takes eagerly-constructed `Widget`s rather than builders

**Evidence:** `state_widget.dart:24-28` — `loading`/`empty`/`error`/`offline`
are `final Widget?`, not `WidgetBuilder?`. Callers therefore construct every
state's tree on every build regardless of which one renders:
`profile_screen.dart:76-86` builds `_Skeleton` and two `_Message`s per frame
while Loaded; `edit_profile_screen.dart:75-89` builds three
`EditProfileChrome` subtrees per frame.

**Why it matters:** cheap today (the trees are shallow and mostly `const`-able),
but it is a shape that stops being cheap the moment a skeleton grows a shimmer
or a chart. It is also the reason the `_Message` instances at
`profile_screen.dart:77` and `:82` cannot be `const`.

**Recommended fix:** change the four slots to `Widget Function()?`. Roughly six
call sites.

**Risk of fixing:** low; purely mechanical.

**Validation required:** `flutter test`.

---

### F-2-10 [LOW] [OPTIONAL IMPROVEMENT] Pagination trigger has no local re-entry guard

**Evidence:** `school_picker_field.dart:176-182` — `_onScroll` fires on every
scroll notification and calls
`ref.read(schoolSearchProvider(_filter).notifier).loadMore()` whenever within
240px of the end, with no `if (_loading) return`.

Not a bug: `SchoolSearchNotifier.loadMore` (`school_search_notifier.dart:88-93`)
rejects on `current.isLoadingMore`, `!current.hasMore` and `cursor == null`. The
guard is correct — it is just remote and single-point, so the widget issues one
provider read per scroll frame to be told "no". Recorded for completeness rather
than as a defect.

---

## Verdicts on the eight large screens

Line counts below separate comment and blank lines from code, because in this
repo the doc comments are load-bearing (they carry the contract reasoning) and
inflate every file.

| File | total / code | Verdict |
|---|---|---|
| `profile/screens/edit_profile_screen.dart` | 741 / 576 | **Fine as-is, one extraction.** Already decomposed into 8 private widgets. The one genuine extraction is `_ReadOnlySection` (`:382-495`, 113 lines) — it is a self-contained render of `StudentProfile`'s immutable half with its own school/university branch, and belongs in `profile/widgets/read_only_profile_section.dart` next to `read_only_field.dart`. |
| `auth/screens/otp_screen.dart` | 478 / 399 | **Structural.** 5 private widgets, each one frame element. The only cut is deleting `_OfflineBanner` (F-2-03) and `_InlineMessage` (F-2-03). |
| `registration/screens/school_detail_screen.dart` | 449 / 352 | **Missing extraction.** `build` is 245 lines (`:68-312`). The seven field blocks are already components; what is left is the chrome (F-2-05) and the six `_*Options` mappers (`:370-438`), which should move to a `SchoolRegistrationOptions` helper class taking `(ref, context)`. |
| `profile/screens/profile_screen.dart` | 438 / 288 | **Fine.** 124 comment lines. `_Menu` (`:173-350`) is a flat list of ten rows with a `TODO(contract)` each — that is data, not complexity. Only cut is F-2-02 (`_Message`/`_Block`). |
| `auth/screens/login_screen.dart` | 436 / 377 | **Missing extraction.** Lowest comment ratio of the eight (32 lines). `build` is 153 lines (`:116-269`). Extract the logo→title→subtitle→phone→errors block as `_LoginForm`; extract `_PhoneField` to core (F-2-04); delete `_OfflineBanner`/`_InlineMessage` (F-2-03). |
| `quiz/screens/quiz_screen.dart` | 405 / 306 | **Fine.** Shell / renderer boundary is deliberate and documented at `:21-36`; `_ProgressBar`, `_ActionBar`, `_RetryRow` are already out. `_QuizView.build` at 113 lines is the `BlocConsumer` body and does not decompose further without inventing seams. |
| `registration/screens/signup_identity_screen.dart` | 389 / 331 | **Missing extraction — but the extraction already exists.** 183 of its 389 lines (`:207-389`) are private re-implementations of `core/widgets/form_fields.dart` and `login_screen.dart`'s phone field. Applying F-2-04 takes this file to ~200 lines with no new abstraction invented. |
| `shell/main_shell.dart` | 373 / 256 | **Fine.** ~90 lines are the Figma path-derivation commentary at `:110-153`; `navBarPath`, `_NavBarPainter`, `_NavBarClipper`, `_NavTab`, `_CentreTab` are all separate. `shouldRepaint` compares both fields (`:212-213`); `shouldReclip` is `false` (`:223`). Correct. |

---

## Areas checked and found clean

These were in scope, were checked exhaustively, and produced no findings. Stated
explicitly so the next pass does not re-derive them.

**Async correctness — fully compliant.** A scan of every `await` in `lib/`
followed by a `context` reference produced 8 candidates; all 8 are
`await showDialog(context: context, …)` or `await Sheet.show(context)`, where
`context` is an argument on the same statement, not a use across the gap. Every
genuine post-await `context` use is guarded:
`edit_profile_screen.dart:241` (`if (!saved || !mounted) return;`), `:278`
(`&& mounted`), `:295` (`&& context.mounted`, with a comment at `:292-294`
explaining why the State's `mounted` is the *wrong* check inside `build`),
`login_screen.dart:100` (`if (result == null || !mounted) return;`),
`quiz_screen.dart:115` and `:125` (`context.mounted`),
`profile_screen.dart:333` (resolves `ref.read(...notifier)` *before* the await,
with the reason stated at `:331-332`),
`school_detail_screen.dart:341` and `university_detail_screen.dart:292`
(`if (!mounted) return;` first line of the listener).
This is the mistake `Flutter_Common_Mistakes.md:10` warns about hardest, and the
codebase has zero instances of it.

**Controller / listener disposal — fully compliant.** Every one, with its
disposal site: `login_screen.dart:32`→`:73`; `otp_screen.dart:34,35`→`:40,41`;
`signup_identity_screen.dart:40-42`→`:62-64`;
`edit_profile_screen.dart:168,169`→`:190,191`; `subjects_screen.dart:33`→`:38`;
`city_field.dart:65`→`:77`; `school_picker_field.dart:135,136,137`→`:152-155`
(debounce cancelled, listener removed symmetrically before disposal, both
controllers disposed); `otp_notifier.dart:73` `Timer` → `ref.onDispose(() => _timer?.cancel())`
at `:77`; `me_notifier.dart:57` `AppLifecycleListener` →
`ref.onDispose(listener.dispose)` at `:58`; `quiz_screen.dart:62`
`ScreenProtection` held via `ref.read` (not `watch`, reason at `:60-61`) and
disabled in `dispose()` at `:71`. There are **no** `AnimationController` and
**no** `StreamSubscription` instances anywhere in `lib/`.

**`quiz_bloc.dart` — correct, and it has no countdown `Timer`.** The audit brief
asked me to check one; there is none. `dart:async` is imported only for
`unawaited` (`:199`). The explanation poll is cancelled by a `_pollingFor` token
checked before every `add` and every `await` return (`:240`, `:243`, `:253`,
`:260`) together with `isClosed`, and `close()` at `:300-305` calls
`_stopPolling()` before `super.close()`. For a poll loop with no stream to
cancel this is the right mechanism and is better than a `StreamSubscription`.
Worst case is one orphaned `Future.delayed(_pollInterval)` (`:250`) outliving
`close()` by ≤2s, which then returns at `:240` without touching state.
*Divergence worth routing to whoever owns the spec, not an engineering defect:*
`State_Management.md:34` justifies Bloc here by naming three concurrent sources
including `QuizTimeExpired`, and `quiz_event.dart` has no such event — there is
no per-question timer in the implementation at all. The other two justifications
(answer tap racing an in-flight submit, network confirmation) are real and the
Bloc earns its place on them. **PRODUCT DECISION** — flag, do not "fix".

**Lists — compliant.** Every list of unbounded length uses `.builder` or
`.separated`: `units_screen.dart:23`, `chapters_screen.dart:99`,
`lessons_screen.dart:94`, `lectures_screen.dart:66`, `catalog_states.dart:158`,
`subjects_screen.dart:169` and `:195` (`GridView.builder`),
`avatar_sheets.dart:280`, `school_picker_field.dart:236`. The only
`ListView(children: [...])` is `settings_screen.dart:55`, with four `const`
children — correct for a fixed short list, not a finding. No nested scrollables:
every `ListView` sits under an `Expanded` or a height-constrained box. Missing
`itemExtent` is not applicable — `TreeListRow` has a conditional progress bar so
row height is not uniform. Missing item `key`s is not applicable — every list is
append-only and index-stable, none is reorderable or filterable in place.

**`const` discipline — compliant.** Every widget class declared in `lib/` has a
`const` constructor. List item builders and the nav bar use `const SizedBox` /
`const Icon` throughout (`main_shell.dart:275`, `:285`, `:297`, `:343`;
`units_screen.dart:27`; `chapters_screen.dart:103`; `lessons_screen.dart:96`).
`_NavBarClipper` is `const` with `shouldReclip => false` (`main_shell.dart:223`);
`_NavBarPainter.shouldRepaint` compares both fields (`:212-213`). No finding.

**State lifecycle — compliant.** `initState` never mutates a provider; both
places that could (`edit_profile_screen.dart:179-186`,
`signup_identity_screen.dart:48-58`) read only, each with a comment naming
BUG-001 as the reason. Provider seeding happens in the `ref.listen` callback at
`otp_screen.dart:62-79` instead, which is the correct place.

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

## Remaining Risks

- Every rebuild claim in F-2-01 is derived from reading subscription scope, not
  from a profiler. The *direction* is certain (a `select` cannot increase
  rebuilds); the magnitude is not. The `isOnlineProvider` case in particular
  depends on how often `connectivity_plus` emits on the target devices, which
  only a real mid-range Android session will show.
- F-2-02 and F-2-05 are the two refactors large enough to introduce a regression.
  Both touch screens with golden coverage; neither should be attempted without
  running `test/goldens/` first to establish a clean baseline.

## Deferred Improvements

- A lint would enforce most of this permanently. `analysis_options.yaml` is
  stock `flutter_lints`; `use_build_context_synchronously`,
  `cancel_subscriptions`, `close_sinks`, `prefer_const_constructors` and
  `unnecessary_lambdas` would have caught or prevented several of the above and
  will catch the next one. (Infrastructure — Agent 1's territory, noted here
  because the findings are what motivate it.)
- `leak_tracker` in dev, which `Performance.md:15` already calls for and which is
  not in `pubspec.yaml`.

## Recommendations (ranked)

1. **F-2-01, item 2 first.** One `select` on `isOnlineProvider`, applied at 16
   call sites, no behaviour change, no test churn. Highest ratio of measured
   improvement to risk in this report.
2. **F-2-01, item 1.** `_RankSection` → `meProvider.select((v) => v.value?.privacy)`.
   Single file, single line.
3. **F-2-03 + F-2-04.** Delete the six private duplicates of existing shared
   widgets. Removes ~200 lines, fixes the missing error border on Sign Up_1's
   name field as a side effect, and closes the phone-mask divergence.
4. **F-2-06.** Hoist the conditional `ref.watch`. Small, and it converts
   accidental correctness into intended correctness.
5. **F-2-07 + F-2-08.** Delete `schoolsProvider`/`SchoolsQuery`; downgrade the
   two `ref`-less `ConsumerWidget`s.
6. **F-2-02.** Promote `CatalogAsyncView` to core and collapse the five
   `_Message` / four `_Block` copies. Biggest cleanup, needs golden re-baselining.
7. **F-2-05.** Share the registration-form scaffolding. Do last, and only behind
   widget tests for both submit outcomes on both tracks.
8. **F-2-09, F-2-10, and the `_ReadOnlySection` extraction** — genuinely
   optional. Do not spend a release on them.
