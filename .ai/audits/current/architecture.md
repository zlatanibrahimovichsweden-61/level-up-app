# Agent 1 — Architecture

**Scope:** Clean-architecture consistency, folder structure, feature boundaries,
dependency direction, repository/notifier/model responsibilities, core-vs-feature
separation, naming, missing/unnecessary abstractions, coupling. Divergence from
the project's own written architecture rule
(`level_up/01_Flutter_Specs/Architecture_and_Folders.md`).

**Baseline:** dev @ e3651e6

**Repository areas inspected:**
- `lib/core/**` (all 21 files read or scanned)
- `lib/features/**` structure (all 12 features enumerated; every `repository/` file read
  in full; `settings_screen.dart`, `main_shell.dart`, `shell_body.dart`,
  `friends_screen.dart`, `app_router.dart`, `quiz_screen.dart` head read)
- `lib/main_{dev,staging,prod,mock}.dart`, `lib/bootstrap.dart`, `lib/app.dart`, `lib/dev/mock_backend.dart`
- `android/app/build.gradle.kts`, `ios/Runner.xcodeproj/xcshareddata/xcschemes/`, `analysis_options.yaml`
- `contract/openapi.yaml` (path list only), `docs/DECISIONS.md`, `docs/DESIGN_ISSUES.md`
- Vault: `01_Flutter_Specs/Architecture_and_Folders.md`, `00_Project/Glossary.md`

**Method note.** Import direction was computed mechanically: every relative import in
`lib/features/**/*.dart` (excluding generated `*.freezed.dart`/`*.g.dart`) was resolved
with `realpath` and classified as intra-feature / core / cross-feature. 25 cross-feature
edges exist; each is judged below. A naive `grep 'features/'` finds **zero** of them
because features address each other as `../../<other>/...` — worth knowing before anyone
writes a lint for this.

---

## Findings

### F-1-01 [MEDIUM] [ARCHITECTURE ISSUE] `Track` — the glossary's first binding term — lives inside one feature, making `profile` an accidental shared kernel

**Evidence:**
- `lib/features/profile/models/student_profile.dart:29` — `enum Track { school, university }`
- Consumers outside `profile` that must import it: `lib/features/catalog/models/subject_tree.dart:3`
  (`import '../../profile/models/student_profile.dart' show Track;`),
  `lib/features/home/screens/home_screen.dart:9`,
  `lib/features/settings/screens/settings_screen.dart:12`
- `Track` is referenced in **26** non-generated files spanning 6 features
  (catalog, home, profile, quiz, registration, core/router).
- `00_Project/Glossary.md:12` marks `Track` as binding, app-wide vocabulary — not
  profile-scoped.

**Why it matters:** `Track` is the app's top-level domain discriminator (it forks Home,
the catalog tree, registration and the quiz setup). Housing it in a feature's model file
means four unrelated features have a compile-time dependency on `profile` for a reason
that has nothing to do with profiles. The `show Track` in `subject_tree.dart:3` is the
tell — the author already knew they wanted only the enum, not the feature. This is the
single largest source of the coupling in F-1-02 and F-1-03; it is why the import graph
has a hub.

**Recommended fix:** Move `Track` (and only `Track`) to `lib/core/models/track.dart`.
`student_profile.dart` re-exports it if you want zero churn at call sites. This is a
~30-minute mechanical change, not a redesign.

**Risk of fixing:** Low. Pure move + import rewrite; `Track` has a `@JsonValue`-free
`enum` shape so no serialization surface changes. Touches ~26 files, so it should be one
isolated commit.

**Validation required:** `flutter analyze` + full test run after the move.

---

### F-1-02 [MEDIUM] [ARCHITECTURE ISSUE] `profile` depends on `registration` for shared reference data and a generic pagination primitive

**Evidence:**
- `lib/features/profile/models/student_profile.dart:4` — `import '../../registration/models/reference_models.dart';`
- `lib/features/profile/widgets/avatar_sheets.dart:14` — same import
- `lib/features/profile/widgets/avatar_sheets.dart:15` — `import '../../registration/notifier/reference_providers.dart';`
  (pulls `avatarsProvider`, declared at `lib/features/registration/notifier/reference_providers.dart:75`)
- `reference_models.dart` declares `Country`, `NamedRef`, `EducationSystemRef`,
  `UniversityRef`, `Avatar` and a **generic** `CursorPage<T>`
  (`lib/features/registration/repository/reference_repository.dart:73` returns
  `CursorPage<NamedRef>`)

**Why it matters:** Two distinct problems in one edge.
(a) The `/reference/*` endpoints are a cross-cutting *catalog of app-wide lookup data*
(the contract lists 7 of them, `contract/openapi.yaml:396-586`); `GET /reference/avatars`
is used by profile avatar editing, which is not registration at all. Registration is
merely their first consumer, not their owner.
(b) `CursorPage<T>` is a generic pagination envelope — a core networking primitive —
declared inside a feature. The next paginated endpoint (`/leaderboard`,
`contract/openapi.yaml:1082`) will either import `registration` or duplicate it.

**Recommended fix:** Promote `reference_models.dart` + `reference_repository.dart` +
`reference_providers.dart` to a `lib/features/reference/` feature (they already have the
full `{models,repository,notifier}` shape), or `lib/core/` if you prefer them as
infrastructure. Separately, move `CursorPage<T>` to `lib/core/models/`.

**Risk of fixing:** Low–medium. Larger blast radius than F-1-01 (registration screens,
profile widgets, 7 providers, their tests). Purely mechanical; no behaviour change.
This one can also legitimately be deferred — it is not costing anything today.

**Validation required:** `flutter analyze` + the registration and profile test suites.

---

### F-1-03 [MEDIUM] [ARCHITECTURE ISSUE] `settings` is not a feature — it is a `profile` screen in its own folder

**Evidence:** `lib/features/settings/` contains 3 files, no `models/`, no `repository/`,
no `notifier/`. Its screen reaches into `profile` five times:
- `lib/features/settings/screens/settings_screen.dart:11` `../../profile/models/profile_update.dart`
- `:12` `../../profile/models/student_profile.dart`
- `:13` `../../profile/notifier/edit_profile_notifier.dart`
- `:14` `../../profile/notifier/me_notifier.dart`
- `:15` `../../profile/profile_error_copy.dart`
- `lib/features/settings/widgets/settings_rows.dart:8` `../../profile/widgets/profile_menu_row.dart show kProfileDisabledOpacity`

Importing another feature's **notifiers** (`:13`, `:14`) is the hard signal — that is not
a shared surface, that is the other feature's state machine. The screen's own doc comment
(`settings_screen.dart:27-29`) confirms it: "Rank is two `PATCH /me` fields … writes
through Step 2's `ProfileRepository.updateMe` — **the same single path, not a second one**."

**Why it matters:** The boundary claims a separation that does not exist. Two of Settings'
four sections (Languages, Mode) are genuinely core-preference screens with zero profile
dependency; the third (Rank) is pure `PATCH /me`. So the folder is 60% profile UI and 40%
core-preferences UI, and the split is drawn in the wrong place.

**Recommended fix:** Either (a) fold `settings/` into `profile/screens/` +
`profile/widgets/`, which removes 6 cross-feature edges at a stroke, or (b) keep the
folder and accept it as a documented profile sub-surface — but then add that sentence to
`Architecture_and_Folders.md` so the next agent does not read the folder as an
independent feature.

**Risk of fixing:** Low for (a) — file moves only. Zero for (b) — a doc edit.

**Validation required:** `test/features/settings/` still passes after any move.

---

### F-1-04 [MEDIUM] [ARCHITECTURE ISSUE] `lib/core/` imports `lib/features/auth/` and forms a genuine provider cycle with it

**Evidence:**
- `lib/core/network/dio_client.dart:3` — `import '../../features/auth/notifier/auth_controller.dart';`
- `lib/core/network/interceptors/auth_interceptor.dart:3-4` — imports auth's `token_pair.dart` and `auth_controller.dart`
- `lib/core/providers/core_providers.dart:5-6` — imports auth's `auth_controller.dart` and `auth_repository.dart`
- The other side: `lib/features/auth/repository/auth_repository.dart:5` imports
  `core_providers.dart`. The cycle is acknowledged in-source at
  `lib/core/providers/core_providers.dart:36-38`: *"dioProvider and
  authRepositoryProvider reference each other … a static reference cycle — annotating the
  variable breaks the inference cycle."*

**Why it matters:** `Architecture_and_Folders.md:7` states the rule as "**Feature-first**
under `lib/features/`, **shared infrastructure** in `lib/core/`". Infrastructure that
imports a feature is not shared infrastructure. Concretely: `lib/core/network/` cannot be
lifted into a package, cannot be unit-tested without `auth`, and any future consumer of
`DioClient` inherits `AuthController`. The workaround at `:36-38` (explicit left-side type
annotation to break Dart's inference cycle) is the compiler telling you the layering is
inverted — it works, but it is load-bearing and undocumented outside that comment.

**Honest counter-argument, stated for the record:** the alternative — a `TokenProvider`
interface in `core/` that `auth` implements — is three extra types to remove one edge, and
this app will only ever have one auth feature. `app_router.dart:5-33` importing 30 feature
screens is **not** part of this finding: a central router is inherently a composition root
and that inversion is normal and correct.

**Recommended fix:** Narrow the surface rather than invert it. Define
`abstract interface class SessionSink { void forceLogout(LogoutReason r); }` and
`typedef TokenRefresher` in `lib/core/network/`; have `AuthController` implement it. That
deletes the `dio_client.dart:3` and `auth_interceptor.dart:4` edges and leaves only
`core_providers.dart` (a composition root, where the edge is legitimate). `TokenPair`
should move to `core/network/` alongside it.

**Risk of fixing:** Medium — the refresh/retry path is the most safety-critical code in
the app (`auth_interceptor.dart` explicitly guards against re-entrant 401s). Do not
attempt this without the auth interceptor tests green first. **Deferring this is a
defensible call.**

**Validation required:** `test/core/network/` in full, plus a manual 401-refresh walk.

---

### F-1-05 [MEDIUM] [ARCHITECTURE ISSUE] The project's own architecture spec is stale on five counts

This is the deliverable the brief asked for: divergence from a *written project rule*.
`01_Flutter_Specs/Architecture_and_Folders.md` carries `status: decided`, so it reads as
authoritative, and it is wrong in five places. **In four of the five the code is right and
the doc is wrong** — the fix is to the doc.

| # | Spec says | Code does | Verdict |
|---|---|---|---|
| 1 | `features/learning_item/`, `features/flashcard/` (`:25-26`) | Neither exists; `features/catalog/` covers the browse stack | **Code right.** `catalog` mirrors the contract's `/catalog/*` paths (`contract/openapi.yaml:711,737`). Spec must be updated. |
| 2 | Feature list omits `registration`, `onboarding`, `shell`, `account_shells`, `catalog` (`:21-30`) | All five exist | **Code right.** Spec is 5 features behind. |
| 3 | `core/i18n/  l10n setup` (`:29`) | No `lib/core/i18n/`; l10n is `lib/l10n/` | **Code right** — and the same doc contradicts itself at `:31` (`l10n/  app_en.arb, app_ar.arb`). Delete line 29. |
| 4 | "ShellRoute wraps `/home`, `/profile`, `/settings` for bottom nav" (`:42`) | `StatefulShellRoute.indexedStack` over **five** branches: `/home`, `/leaderboard`, `/learn`, `/message`, `/account` (`lib/core/router/app_router.dart:133-218`). `/settings` is at `:272`, **outside** the shell. | **Code right** — the Figma nav is 5 tabs (`main_shell.dart:10-14`). Spec predates it. |
| 5 | Routes `/track-select`, `/learning-item/:itemId`, `/flashcard/:subscriptionId` (`:42`) | `/track-select` → `_Placeholder` (`app_router.dart:128`); the other two do not exist | **Doc right, code incomplete** — but correctly so: no stable endpoint backs them. |

**Why it matters:** A `status: decided` spec that is wrong in 5 of ~10 assertions actively
misleads. Every agent in this ten-agent pass was told to read it. An architecture doc that
disagrees with the code is worse than no doc, because it gets trusted.

**Recommended fix:** Rewrite `Architecture_and_Folders.md` from the tree as-built. Keep
the **Layering rule** section (`:35-39`) verbatim — that part is correct, followed, and
the most valuable thing in the file. Add the two rules the code follows but the doc never
stated: (a) features address each other as `../../<feature>/...`; (b) shared domain
vocabulary belongs in `core/models/`.

**Risk of fixing:** None — vault doc only, outside the app repo.

**Validation required:** None.

---

### F-1-06 [LOW] [QUALITY IMPROVEMENT] `features/shell` and `features/account_shells` use "shell" in two unrelated senses

**Evidence:**
- `lib/features/shell/main_shell.dart:10` — "The 5-tab bottom-nav shell" (a *navigation* shell)
- `lib/features/account_shells/widgets/shell_body.dart:11` — "**These are shells, not mocks.**
  No referral code, no ticket list…" (a *placeholder* screen)
- `lib/core/router/app_router.dart:273` — "The Account cluster's SHELLS"

**Why it matters:** Two of the twelve top-level feature names collide on a word that means
opposite things two directories apart. Neither name is in `Glossary.md`. This is a pure
readability cost, but it is exactly the kind of thing a new contributor gets wrong once.

The boundary itself is **justified**, to be clear — I checked, and the answer is not
fragmentation: `shell/` is nav chrome consumed by the router's `StatefulShellRoute`;
`account_shells/` is 4 routed leaf screens (`/refer`, `/support`, `/friends`,
`/legal/*`) that share exactly one widget. Merging them would be worse.

**Also in scope here:** `lib/features/shell/main_shell.dart` sits at the feature root while
its sibling `lib/features/shell/screens/tab_placeholder.dart` is under `screens/`. One of
the two is in the wrong place.

**Recommended fix:** Rename `account_shells/` → `account_stubs/` (or `unbuilt_screens/`),
and move `main_shell.dart` → `shell/screens/main_shell.dart`.

**Risk of fixing:** Trivial — import rewrites only.

**Validation required:** `flutter analyze`.

---

### F-1-07 [LOW] [QUALITY IMPROVEMENT] `_asAppException` is duplicated verbatim in all six repositories

**Evidence:** identical 4-line private method, same doc comment, at
`auth_repository.dart:101`, `catalog_repository.dart:70`, `profile_repository.dart:73`,
`quiz_repository.dart:149`, `reference_repository.dart:140`,
`registration_repository.dart:59`:

```dart
AppException _asAppException(DioException e) {
  final err = e.error;
  return err is AppException ? err : const UnknownException();
}
```

**Why it matters:** Six copies of the one function that decides what every network failure
in the app becomes. If the `ErrorInterceptor` contract ever changes, five of six get
updated and the sixth silently swallows errors as `UnknownException`. Low probability,
but the failure mode is invisible.

**Recommended fix:** One extension in `lib/core/network/exceptions.dart`:
`extension DioExceptionX on DioException { AppException get asAppException => ... }`.
Six deletions, one addition.

**Risk of fixing:** Very low. Mechanical.

**Validation required:** All repository tests.

---

### F-1-08 [LOW] [QUALITY IMPROVEMENT] Two features are entirely empty scaffolding, yet routed

**Evidence:**
- `lib/features/subscription/{models,repository,notifier,screens}/` — every one contains
  only `.gitkeep`. Zero Dart files in the whole feature.
- `lib/features/track/{models,repository,notifier,screens}/` — identical.
- Yet routed: `app_router.dart:128` (`/track-select`), `:250` (`/subscription`),
  `:251` (`/subscription/return`) — all three build `_Placeholder`
  (`app_router.dart:339-350`), which renders the untranslated literal
  `'$title — not built yet'` at `:347`.
- Also empty: `lib/features/home/{models,notifier,repository}/` — Home is
  screens+widgets only, reading `meProvider` from profile
  (`home_screen.dart:10`).

**Why it matters:** Two of the twelve "features" in the project's own inventory are 8
empty directories. Anyone counting features (including the shared agent context, which
lists `subscription` and `track` as features) overstates what exists. Home's empty triple
is a *different* and benign case — Home legitimately has no state of its own — but the
`.gitkeep`s imply a repository that is coming, which for Home it is not.

**Recommended fix:** Delete `features/subscription/` and `features/track/` until they have
a first file; the `_Placeholder` routes already document the gap and are the honest
artifact. Delete Home's three empty dirs. Note `app_router.dart:347` is also an l10n leak
already flagged in the shared context — same line, different agent's finding.

**Risk of fixing:** None. Deleting empty directories.

**Validation required:** None.

---

### F-1-09 [LOW] [QUALITY IMPROVEMENT] A design token is exported from a feature widget and imported by two other features

**Evidence:** `kProfileDisabledOpacity` is declared in
`lib/features/profile/widgets/profile_menu_row.dart` and imported with `show` by:
- `lib/features/account_shells/widgets/shell_body.dart:7`
- `lib/features/settings/widgets/settings_rows.dart:8`

Both sites carry an explicit justification comment (`shell_body.dart:4-6`: *"CROSS-FEATURE
IMPORT, deliberate … unavailable must look identical everywhere in this cluster"*). The
intent is right; the home is wrong.

**Why it matters:** The reasoning given — one constant so disabled looks identical
everywhere — is precisely the argument for putting it in `lib/core/theme/`. As it stands,
a design token's canonical location is a profile menu row, and two features import a
widget file to get a `double`.

**Recommended fix:** Move to `lib/core/theme/app_colors.dart` (or a small
`core/theme/app_opacities.dart`) and drop all three imports to one core import.

**Risk of fixing:** Trivial.

**Validation required:** Golden tests that cover disabled states.

---

### F-1-10 [LOW] [QUALITY IMPROVEMENT] Same-purpose files are filed in three different places across features

**Evidence:**
- Error-copy mappers at feature root: `lib/features/auth/auth_error_copy.dart`,
  `lib/features/profile/profile_error_copy.dart`,
  `lib/features/registration/registration_error_copy.dart`
- Same thing, under `widgets/`: `lib/features/quiz/widgets/quiz_error_copy.dart`
- A Riverpod provider declared under `screens/`:
  `lib/features/quiz/screens/screen_protection.dart:40` — `final screenProtectionProvider = Provider<ScreenProtection>(...)`

**Why it matters:** Small, but it defeats the one thing feature-first buys you: knowing
where to look. Four features, three conventions for the same file.

**Recommended fix:** Pick one — feature root is the better choice (error copy is neither a
widget nor a model) — and move `quiz_error_copy.dart` up. Move `screen_protection.dart`
to `quiz/notifier/` or `quiz/` root, since it is a service + provider, not a screen.

**Risk of fixing:** Trivial.

**Validation required:** `flutter analyze`.

---

### F-1-11 [LOW] [PRODUCT DECISION → flagged, not re-litigated] `RegTrack` is a synonym for the binding glossary term `Track`

**Evidence:**
- `lib/features/registration/models/registration_draft.dart:7` — `enum RegTrack { school, university }`
- `lib/features/profile/models/student_profile.dart:27-28` — *"Distinct from registration's
  `RegTrack`, which is the wizard's local draft discriminator; this one is what the server
  says the account actually is."*
- `00_Project/Glossary.md:8` — *"**Do not invent synonyms**"*; `:12` defines `Track`.

**Why it matters:** The distinction drawn in the doc comment is real and defensible (draft
intent vs. server-confirmed fact), and I am **not** arguing it should be collapsed. But
the *name* is a synonym, which a `binding: true` glossary forbids, and the code carries
two identical `{school, university}` enums that a `switch` must convert between
(`registration_submit_notifier.dart:100-101`).

**Recommended fix:** Either rename to something that names the *difference* rather than
the feature — `DraftTrack` or `SelectedTrack` — or add a `RegTrack` row to `Glossary.md`
so the vocabulary is legal. The glossary edit is the cheaper honest option.

**Risk of fixing:** Rename touches 14 sites. The doc edit touches one line.

**Validation required:** Registration test suite if renamed.

---

### F-1-12 [LOW] [QUALITY IMPROVEMENT] The mock backend is correctly excluded from production — but nothing *enforces* it

This was the brief's question 4. The short answer is **the mock does not ship, and the
isolation is real.** Detail, because the question was a size/attack-surface one:

**Evidence that it is safe:**
- `lib/dev/mock_backend.dart` is imported by exactly one file in the repo:
  `lib/main_mock.dart:30`. Verified by grep across all of `lib/` — nothing in
  `lib/core/**` or `lib/features/**` references `dev/` at all.
- `lib/main_prod.dart` is 5 lines: `void main() => bootstrap(Flavor.prod);`.
  `lib/bootstrap.dart:25-30` overrides only `preferencesStoreProvider`. The mock enters
  solely via `main_mock.dart:63` — `dioProvider.overrideWith((ref) => buildMockDio())`.
- Dart AOT tree-shakes from the entrypoint, so a `-t lib/main_prod.dart --release` build
  cannot contain the 1527 lines. The file's own header states the design
  (`mock_backend.dart:12-14`), and it is accurate.
- The injection design is genuinely good: one provider override, zero production files
  aware of the mock. This is the right way to do it.

**Evidence that nothing enforces it:**
- `android/app/build.gradle.kts` has **no `productFlavors` block** and no `flavorDimensions`;
  `ios/.../xcschemes/` contains a single `Runner.xcscheme`. Flavor selection is entirely
  `flutter run/build -t <file>`. There is no build-configuration guard that makes
  `main_mock.dart` unbuildable as a release artifact — only convention and a `-t` argument.
- `analysis_options.yaml` has no `exclude:` and no `errors:` block, so nothing would flag
  a future `import '../dev/mock_backend.dart'` from `lib/features/`.
- `test/dev/` has four mock-backend tests (`mock_backend_{catalog,profile,quiz,v11}_test.dart`)
  but none of them asserts the isolation property — i.e. no test fails if someone imports
  the mock from production code.

**Why it matters:** The property currently holds by construction and by one comment. With
no CI (already established in the shared context) and no build flavors, the guard is
"nobody types the wrong `-t`". The risk is low but the mitigation is ~15 lines.

**Recommended fix:** Add a source-level guard test —
walk `lib/core/` and `lib/features/` and assert no file's imports resolve into `lib/dev/`.
Ten lines of `dart:io`, runs in the existing suite, no toolchain additions. Separately,
adding real Gradle product flavors would fix this *and* the missing per-flavor
applicationId, but that is a larger change and belongs to whoever owns release config.
Do **not** move `lib/dev/` out of `lib/` — it needs to import `core/network/interceptors/`
(`mock_backend.dart:31`) and moving it buys nothing.

**Risk of fixing:** None for the guard test.

**Validation required:** The new test must be run once to confirm it passes today.

---

## Assessed — no finding (recorded so the next pass does not redo the work)

**`lib/core/providers/core_providers.dart` is NOT a god-file** (brief question 6).
It is **61 lines** and declares 5 providers: `secureStorageProvider`,
`preferencesStoreProvider`, `refreshDioProvider`, `dioProvider`, `connectivityProvider`,
`isOnlineProvider`. That is precisely the set `Architecture_and_Folders.md:18` prescribes
("dio, secureStorage, connectivity, isOffline"). Locale and theme correctly live in
sibling files (`locale_provider.dart`, `theme_provider.dart`), not in it. Every provider
has a doc comment explaining a non-obvious decision. This is a textbook DI root and
should be left alone. The only mark against it is F-1-04's feature import.

**The repository layer is consistent** (brief question 3). All six repositories:
take `Dio` via constructor injection from `dioProvider` (never construct it inline);
return **domain models only** — no `Response`, no `Map<String, dynamic>`, no `dynamic`
crosses the boundary (verified by grep across all repository files); wrap every call in
`try/on DioException` and rethrow a typed `AppException`; declare their provider at the
bottom of their own file as `Provider<T>((ref) => T(ref.watch(dioProvider)))`. Two
justified deviations, both documented in-source: `AuthRepository` takes a second bare
`refreshDio` (`auth_repository.dart:19-24`, loop-safety), and `CatalogRepository`
dispatches on the contract's discriminator before parsing
(`catalog_repository.dart:56-62`). **Zero screens, widgets, notifiers or blocs import
`package:dio`** — verified by grep. The one screen that imports a repository
(`quiz_screen.dart:13`) does so only to hand it to `BlocProvider`
(`quiz_screen.dart:78`), which is the standard Riverpod→Bloc bridge, not an API call.
This layer is the strongest part of the codebase.

**There should NOT be a use-case/domain layer** (brief question 5). Arguing both sides:
*For* — the app has real invariants (registration's conditional-required matrix,
quiz scope construction) and a doc that says "The server decides"
(`Architecture_and_Folders.md:39`), which is exactly the sort of rule a domain layer
protects. *Against, and decisive* — the invariants are **already** extracted into pure
Dart with no framework dependency: `registration/models/registration_validation.dart`
(177 lines, no Flutter import), `registration/models/registration_body.dart` (factory
per track), `quiz/models/quiz_setup_args.dart` (two constructors that make the
illegal combination unrepresentable, per `quiz_repository.dart:31-34`), and the four
`*_error_copy.dart` mappers. The notifiers that would otherwise bloat are small — the
largest is 196 lines (`registration_controller.dart`), median ~80, total 1169 lines
across 12 files. Nothing here is orchestrating three repositories. A `usecases/` layer
would add a file per method to forward a single call. **Recommendation: do not add one.**
The existing pattern — pure-Dart logic files inside `models/` — is the right size for this
app; if anything it deserves a name in the spec, e.g. "`models/` may contain pure domain
logic, not just data classes."

**Feature-internal consistency** (brief question 7). Six features follow
`{models,repository,notifier,screens,widgets}` fully: auth, catalog, profile, quiz,
registration (+ quiz's documented `bloc/`). The six that do not are each fine for a
stated reason: `home` (screens+widgets, reads `meProvider` — no state of its own),
`onboarding` (one static screen), `shell` (nav chrome), `account_shells` (stub screens
with, correctly, nothing to fetch), and `settings` (see F-1-03). `subscription`/`track`
are empty (F-1-08). The absence of `models/`/`repository/` in a screens-only feature is
**not** a defect — inventing an empty repository would be the defect.

**Naming against the glossary** (brief question 8). Checked all 17 glossary terms
against `lib/`. `Track`, `Question`, `Flashcard`, `Level`, `Badge`, `totalPoints`,
`Country`/`Governorate`/`City` all appear with the glossary's exact spelling.
`LearningItem`, `StreakPair`, `ForwardedQuestion`, `Institution`, `schoolPoints`,
`universityPoints`, `flashcard_subscription` appear **nowhere in `lib/`** — correctly, as
none has a stable endpoint (they are M2 concepts). `base_subscription` appears only in
`lib/dev/mock_backend.dart` and the l10n bundle. The one violation is F-1-11 (`RegTrack`).
Naming the browse feature `catalog` rather than the spec's `learning_item` is the
**right** call — it mirrors `contract/openapi.yaml:711`.

**Cross-feature imports: 19 of 25 are healthy.** Beyond the ones cited above, the
remainder are ordinary flow adjacency and I judged each: `auth/screens/otp_screen.dart:12-13`
→ registration (OTP forks into the wizard — the flow genuinely continues there);
`catalog/screens/lessons_screen.dart:8`, `lectures_screen.dart:5-6`,
`widgets/quiz_type_tabs.dart:5` → `quiz/models/quiz_setup_args.dart` and `quiz_type.dart`
(catalog launches quizzes; passing the typed args object is better than passing loose
strings); `registration/notifier/registration_submit_notifier.dart:8` and
`profile/screens/profile_screen.dart:12` → `auth_controller.dart` (register-logs-you-in
and logout — both must flip auth state); `registration/repository/registration_repository.dart:6`
→ `auth/models/auth_result.dart` (the contract returns an `AuthenticatedResult` from
`POST /auth/register`, `contract/openapi.yaml:158`); `home/screens/home_screen.dart:9-10`
and `quiz/screens/quiz_screen.dart:9` → `meProvider` (the signed-in student's profile is
app-wide read state). None of these is a violation. **`quiz/models/quiz_type.dart` is a
borderline case** — it is imported by 3 catalog files and only 1 quiz file, so it arguably
belongs to catalog; not worth moving on its own, but worth moving alongside F-1-01 if that
happens.

---

## Changes Made
NONE — report-only pass.

## Files Changed
NONE.

## Tests Run
NONE — no Dart toolchain available in this environment.

## Test Results
N/A. See `.ai/audits/current/test-results.md` for the developer-run suite.

---

## Remaining Risks

1. **Every finding above is static-analysis-only.** No `flutter analyze` was run. The
   import graph in F-1-01/02/03 was computed by resolving relative paths with `realpath`
   over 178 files; generated `*.freezed.dart`/`*.g.dart` were excluded, so a generated
   file could in principle add an edge I did not count (unlikely — generated parts
   inherit their library's imports).
2. **F-1-04's provider cycle is stated as safe by its own comment; I could not prove it.**
   `core_providers.dart:36-38` claims the explicit type annotation breaks Dart's inference
   cycle and that the runtime link is lazy. Reading the code, that is correct. Confirming
   it needs a build.
3. **F-1-12's tree-shaking claim rests on Dart AOT semantics, not on an inspected
   artifact.** I verified the import graph but could not build a release APK and inspect
   it. If absolute certainty is needed, build `main_prod.dart --release` and grep the
   snapshot for a mock-only string such as `http://mock.local/api/v1`
   (`mock_backend.dart:47`).
4. **`Architecture_and_Folders.md` lives in the vault, outside the app repo**, and nothing
   keeps it in sync with `lib/`. F-1-05 fixes today's drift; it does not prevent tomorrow's.
   This compounds the source-of-truth fragmentation already noted in the shared context.

---

## Deferred Improvements

- **F-1-02** (promote `reference/`) — real, but costs nothing today. Do it the day a
  second feature needs `/reference/*` or a second endpoint needs `CursorPage<T>`.
- **F-1-04** (invert the core↔auth edge) — the fix touches the refresh/retry path, which
  is the highest-risk code in the app. Do not attempt without CI. Defensible to keep.
- **Android/iOS product flavors.** Out of this agent's scope but adjacent to F-1-12: there
  are none, so flavor identity is a `-t` argument and nothing more. Whoever owns
  `docs/RELEASE_SIGNING.md` should decide.
- **An import-direction lint.** The three highest-value rules (`core/` may not import
  `features/`; a feature may not import another feature's `notifier/` or `repository/`;
  nothing outside `lib/dev/` may import `lib/dev/`) are all expressible as a ~30-line test
  over the file tree, needing no new dependency. That would make F-1-01/03/04/12 regressions
  impossible rather than merely noted.

---

## Recommendations (ranked)

1. **Update `01_Flutter_Specs/Architecture_and_Folders.md` to match the code** (F-1-05).
   Highest value, zero risk, no app-repo edit. A `status: decided` doc that is wrong in
   half its claims is misleading every agent that reads it — including the other nine in
   this pass.
2. **Move `Track` to `lib/core/models/`** (F-1-01). One enum, ~30 minutes, removes the
   structural reason four features import `profile`. Best effort-to-benefit ratio in the
   report.
3. **Add the import-direction guard test** (F-1-12 + Deferred). Ten to thirty lines, no
   new dependency, converts four findings from "noted" to "cannot regress". Do this before
   the refactors, not after.
4. **Decide `settings`' status explicitly** (F-1-03) — fold it into `profile/`, or write
   one sentence in the spec declaring it a profile sub-surface. Either is fine; leaving it
   ambiguous is not.
5. **Sweep the cheap consistency items together** (F-1-06 through F-1-10): rename
   `account_shells`, move `main_shell.dart` into `screens/`, hoist `_asAppException` into
   an extension, delete the two empty features, move `kProfileDisabledOpacity` to
   `core/theme/`, unify `*_error_copy.dart` placement. One commit, all mechanical, no
   behaviour change.
6. **Do not add a use-case layer** (question 5). Recorded here as an active
   recommendation, not an omission — the pure-logic-in-`models/` pattern already in use is
   correctly sized for this app, and formalising it in the spec is worth more than adding
   a layer.
7. **Leave `core_providers.dart` alone** (question 6). It is a correct DI root at 61 lines.
