# Agent 6 — State & Navigation

**Scope:** Riverpod usage & lifecycle, the Bloc quiz engine, GoRouter, navigation
flows, redirects/guards, state transitions, BUG-001-class provider mutation.
**Baseline:** dev @ e3651e6
**Repository areas inspected:**
`lib/core/router/app_router.dart` · `lib/app.dart` · `lib/bootstrap.dart` ·
`lib/features/auth/{notifier,screens}/` · `lib/features/registration/{notifier,screens,widgets}/` ·
`lib/features/quiz/{bloc,notifier,screens}/` · `lib/features/profile/notifier/` ·
`lib/features/catalog/notifier/` · `lib/features/shell/` · `lib/features/onboarding/` ·
`android/app/src/main/AndroidManifest.xml` · `ios/Runner/Info.plist` ·
`test/core/router/` · `test/features/{registration,catalog,quiz,profile,shell,settings,auth}/` ·
vault `01_Flutter_Specs/{State_Management,Navigation_and_Deep_Links}.md` ·
`.claude/skills/{river,bloc}/SKILL.md` · `docs/KNOWN_BUGS.md` · `docs/day1b_forced_logout_brief.md`

---

## BUG-001 scope claim — independently re-verified

**The claim still holds. There are no provider mutations in `initState`,
`didChangeDependencies` or `build` anywhere in `lib/` at this commit.**

Complete census — every `initState` in `lib/` (6 sites), classified:

| Site | Classification |
|---|---|
| `login_screen.dart:45` | **SCHEDULES** — `addPostFrameCallback(_showLogoutReasonOnce)`; the callback writes (`clearReason()`, `:63`) but post-frame, outside the build phase. **Legal.** |
| `otp_screen.dart` | no `initState` (only `dispose`) |
| `edit_profile_screen.dart:179` | **READ ONLY** — seeds two `TextEditingController`s from `widget.profile`. Comment cites BUG-001. |
| `quiz_screen.dart:58` | **READ + side-effect on a plain service** — `ref.read(screenProtectionProvider)` then `_protection.enable()`. No provider state assigned. **Legal.** |
| `signup_identity_screen.dart:48` | **READ ONLY** — the BUG-001 fix; `start()` is gone, comment records why. |
| `signup_track_screen.dart:32` | **READ ONLY** — `ref.read(registrationControllerProvider)?.track`. |
| `school_picker_field.dart:145` | **NEITHER** — `_scrollController.addListener`. |

- `didChangeDependencies`: **zero occurrences in `lib/`.**
- Provider mutation in `build`: none. The two candidates both defer correctly —
  `school_detail_screen.dart:328` wraps `setCountry` in `addPostFrameCallback`,
  and `school_detail_screen.dart:348` / `university_detail_screen.dart:298` wrap
  `reset()` the same way.
- **Bloc equivalent (`add()` from `initState`): none.** `quiz_screen.dart:78-79`
  adds `QuizStarted` from `BlocProvider.create`, which runs lazily outside the
  mount path — correct.
- **`ref.listen` outside `build`: none.** All five call sites
  (`otp_screen.dart:62`, `quiz_setup_screen.dart:57`, `school_detail_screen.dart:340`,
  `university_detail_screen.dart:291`, `app_router.dart:88`) are reached from a
  `build` method or a provider body.

What the claim does **not** cover, and what F-6-06 is about: the class of bug is
still undetectable in four screens because they are never mounted by navigation.

---

## Findings

### F-6-01 [HIGH] [BUG] Signing out does not clear cached server data — the next student sees the previous one's profile

**Evidence:**
- `lib/features/profile/notifier/me_notifier.dart:39` — `meProvider` is a plain
  (non-`autoDispose`) `AsyncNotifierProvider`; same for `entitlementsProvider:73`,
  `subjectsProvider:31`, `subjectTreeProvider:47`.
- `lib/features/auth/notifier/auth_controller.dart:56-71` — `forceLogout()` and
  `logout()` clear tokens and flip `AuthStatus`. **Neither invalidates any provider.**
- `lib/features/profile/screens/profile_screen.dart:348` — `await auth.logout()`;
  the button is wired and shipped.
- The only `ref.invalidate(meProvider)` calls in `lib/` are
  `edit_profile_notifier.dart:57` and `quiz_screen.dart:213`. Grep for
  `invalidate` across `lib/` confirms nothing hangs off auth state.

**Why it matters:** a non-`autoDispose` provider lives for the container's
lifetime, and the container is created once in `bootstrap.dart:26`. Sequence:
student A signs in → `/home` caches `AsyncData(profileA)` → A taps Log out →
`/login` → student B verifies an OTP → `context.go('/home')`
(`otp_screen.dart:106`) → `HomeScreen` (`home_screen.dart:39`) reads the still-warm
`meProvider` and renders **student A's name, level, points, badges and avatar**.
`entitlementsProvider` does the same for the paywall signal (a paid student's
entitlements shown to a free one), and `subjectTreeProvider` for a school
student's catalog shown to a university student. Nothing corrects itself until a
manual retry or a `PATCH /me`. Shared devices are the normal case in this market.

**Recommended fix:** one listener at container level — a `Provider` (or
`ref.listen` inside `routerProvider`, which already mirrors `AuthStatus`) that on
any `AuthAuthenticated → AuthUnauthenticated` transition invalidates the
user-scoped set: `meProvider`, `entitlementsProvider`, `subjectsProvider`,
`subjectTreeProvider`, `editProfileProvider`, `registrationSubmitProvider`.
Do NOT invalidate `localeProvider` / `themeModeProvider` (device preferences) or
the reference providers (public data).

**Risk of fixing:** invalidating while `/home` is still mounted during the
logout frame would flash a skeleton before the redirect lands. Invalidate from a
post-frame callback, or key off the redirect completing.

**Validation required:** a router-driven widget test — sign in as A, log out,
sign in as B, assert `/home` shows B. No such test exists today.

---

### F-6-02 [HIGH] [BUG] Onboarding's "Get Started" dead-ends on the registration-expired screen

**Evidence:**
- `lib/features/onboarding/screens/onboarding_screen.dart:54` —
  `onGetStarted: () => context.go('/register')`, with no `extra`.
- `lib/core/router/app_router.dart:110-111` — `/register` builds
  `SignupIdentityScreen(args: state.extra as RegistrationArgs?)` → `null`.
- `lib/features/registration/screens/signup_identity_screen.dart:101` —
  `if (draft == null || draft.isExpired) return const RegistrationExpiredView();`
  The draft is only ever seeded at `otp_screen.dart:76`.
- `lib/features/auth/screens/login_screen.dart:76-85` documents this **exact**
  defect being removed from the Login screen: *"'Create New Account' used to push
  `/register` directly, which always dead-ended on the registration expiry
  guard"*. The fix was applied to Login and not to Onboarding.

**Why it matters:** `/` is the app's first screen for every signed-out student
(`app_router.dart:94`, and `authRedirect` keeps them there). The primary CTA on
that screen renders *"Your registration session expired"* + *"Back to login"*.
This is a 100 %-reproducible dead end on the app's front door.

**Recommended fix:** make `onGetStarted` do what Login's does — `context.go('/login')`.
The contract is phone-verify-first; there is no token-less registration entry.

**Risk of fixing:** none functionally; product may want distinct Login/Sign-up
copy on the destination (already logged as `docs/DESIGN_ISSUES.md #8`).

**Validation required:** `onboarding_screen_test.dart` currently asserts the
button exists, not where it lands. Add a router-driven assertion.

---

### F-6-03 [MEDIUM] [BUG] `autoDispose` notifiers write `state` after an `await` with no `ref.mounted` guard

**Evidence:** grep for `ref.mounted` across `lib/` returns **zero** hits
(Riverpod 3.3.2, `pubspec.yaml:37`, where `ref.mounted` exists). Post-await
assignments on `autoDispose` providers:
- `lib/features/auth/notifier/otp_notifier.dart:104,112,121,127` (`verify`) and
  `:138,144,146` (`resend`) — `otpProvider` is `NotifierProvider.autoDispose.family` (`:164`).
- `lib/features/profile/notifier/edit_profile_notifier.dart:52` (`state = result`)
  and `:57` (`ref.invalidate(meProvider)`) — `autoDispose` (`:69`).
- `lib/features/quiz/notifier/quiz_setup_notifier.dart:41` — `autoDispose` (`:60`).
- `lib/features/registration/notifier/school_search_notifier.dart:101,115,127` —
  `autoDispose.family` (`:130`).

**Why it matters:** the most reachable path is the OTP screen: the `AppBar` back
button (`otp_screen.dart:86`) is live while `state.isVerifying` is true. Popping
mid-verify removes the last listener, `autoDispose` tears the notifier down, and
the awaited `verifyOtp` then assigns `state` on a disposed notifier. The school
picker is the same shape and easier to hit — the sheet is dismissible while a
page append is in flight (`school_picker_field.dart:180` → `loadMore()`).

**Recommended fix:** `if (!ref.mounted) return;` immediately after every `await`
that precedes a `state =` in an `autoDispose` notifier. The screens already
follow the mirror-image discipline (`login_screen.dart:100`,
`quiz_setup_screen.dart:182`, `school_detail_screen.dart:341`), so this is
completing an existing convention, not introducing one.

**Risk of fixing:** none — pure guard.

**Validation required:** the exact Riverpod 3.3.2 behaviour of `state=` after
dispose (throw vs. silent no-op) cannot be confirmed without the toolchain. If it
is a silent no-op the severity drops to LOW (leak only); if it throws, this is an
uncaught async exception.

---

### F-6-04 [MEDIUM] [BUG] Three routes force-cast `state.extra`; one identical route guards it

**Evidence:**
- `lib/core/router/app_router.dart:103` — `OtpScreen(args: state.extra! as OtpArgs)`
- `lib/core/router/app_router.dart:226` — `QuizSetupScreen(args: state.extra! as QuizSetupArgs)`
- `lib/core/router/app_router.dart:246` — `QuizResultScreen(args: state.extra! as QuizResultArgs)`
- versus the correct pattern at `:234-237`:
  `switch (state.extra) { final Quiz quiz => QuizScreen(quiz: quiz), _ => const _QuizUnavailableScreen() }`
- No `errorBuilder` / `onException` is configured on the `GoRouter`
  (`app_router.dart:93-99`), so a `TypeError` thrown inside a route builder
  surfaces as Flutter's red `ErrorWidget`.

**Why it matters:** the author already reasoned this through once and shipped the
right answer for `/quiz/:quizId`. The other three are the same hazard with the
opposite treatment. Currently **not** user-reachable — there is no deep-link
plumbing (F-6-08) and no `restorationScopeId` on `MaterialApp.router`
(`app.dart:31-63`), so `extra` is always present. It becomes reachable the day
either is enabled, which is a scheduled event.

**Recommended fix:** apply the `/quiz/:quizId` `switch` shape to all three.
`/otp` and `/quiz/setup` with no `extra` should redirect to `/login` and `/learn`
respectively; `/quiz/:id/result` should reuse `_QuizUnavailableScreen`.

**Risk of fixing:** low — three isolated builder expressions.

**Validation required:** none beyond compilation.

---

### F-6-05 [MEDIUM] [BUG] The paywall pushes a user onto an un-localized English "not built yet" placeholder

**Evidence:**
- `lib/features/quiz/widgets/limit_sheet.dart:123` — `context.push('/subscription')`.
- `lib/core/router/app_router.dart:250` — `/subscription` → `const _Placeholder('Subscription')`.
- `lib/core/router/app_router.dart:347` — `body: Center(child: Text('$title — not built yet'))`,
  with `AppBar(title: Text(title))` at `:346` — both raw English string literals,
  in an app whose baseline locale is Arabic.

**Placeholder route reachability (complete):**

| Route | Renders | Reachable by a user today? |
|---|---|---|
| `/subscription` | `_Placeholder('Subscription')` | **YES** — `limit_sheet.dart:123`, shown on 403 `weekly_question_limit_reached` / `subscription_required` at quiz setup and mid-quiz (`quiz_screen.dart:223`) |
| `/subscription/return` | `_Placeholder('Paymob return')` | No — no deep-link registration exists (F-6-08) |
| `/track-select` | `_Placeholder('Track select')` | No — zero `go`/`push` call sites; superseded by `/register/track` |

**Why it matters:** the limit sheet is the monetisation moment. An Arabic-speaking
student who hits the weekly cap is shown *"Subscription — not built yet"* in
English. This is the only placeholder a user can actually reach.

**Recommended fix:** either disable the CTA in `LimitSheet` until the
subscription screen exists, or give `_Placeholder` an l10n'd "coming soon" body —
`TabPlaceholder` (`features/shell/screens/tab_placeholder.dart`) is the existing,
correct, localized version of exactly this widget and should simply be reused.
Delete `/track-select`: it is dead.

**Risk of fixing:** none. This is a `PRODUCT DECISION` on which of the two.

---

### F-6-06 [MEDIUM] [ARCHITECTURE ISSUE] Four screens are never mounted by navigation — the BUG-001 blind spot is still open there

BUG-001's lesson is that the assert only fires when a screen mounts into an
*existing* tree. A test that pumps a screen directly, **or that boots a router
whose `initialLocation` already is that screen**, mounts it during the initial
build and cannot see the defect.

**Screens reached only by initial build / direct pump:**

| Screen | Evidence | Why it is a blind spot |
|---|---|---|
| `SchoolDetailScreen` | `test/features/registration/school_detail_screen_test.dart:63-64` — hand-rolled `GoRouter(initialLocation: '/register/school')`; `registration_screens_test.dart:25` same shape | The most stateful screen in the app (geography cascade, `_seedDefaultCountry`, `_handleSubmitOutcome`). `registration_router_flow_test.dart` stops at `/register/track`. |
| `UniversityDetailScreen` | `university_detail_screen_test.dart:57-58` — same hand-rolled router | Same. |
| `RegistrationExpiredView` | Only ever a build-time branch of the two above | Same. |
| `HomeScreen` | `test/features/home/home_screen_test.dart:50` — `MaterialApp(home: HomeScreen())`. In every router harness (`main_shell_test.dart:53`, `catalog_harness.dart:71`, `profile_harness.dart:115`, `quiz_harness.dart:98`) `markAuthenticated()` runs **before** `pumpWidget`, so `/` → `/home` resolves during the first route resolution; and `StatefulShellRoute.indexedStack` keeps branch 0 alive, so returning to the Home tab never remounts it | The landing screen of the whole signed-in app. |

**Never tested at all, in any mode:** `_QuizUnavailableScreen`
(`app_router.dart:309`), the three `_Placeholder` routes, and the unknown-route
error page.

**Everything else is genuinely router-driven** and deserves the credit:
`LoginScreen`, `OtpScreen`, `SignupIdentityScreen`, `SignupTrackScreen`
(`registration_router_flow_test.dart`), the whole Learn stack + `QuizSetupScreen`
(`catalog_navigation_test.dart`), `QuizScreen`/`QuizResultScreen`
(`quiz_harness.dart`), `ProfileScreen`/`EditProfileScreen`
(`profile_harness.dart:185-186`), `SettingsScreen` and the four account shells
(`settings_harness.dart:79`), both tab placeholders (`main_shell_test.dart:105`).

**Recommended fix:** extend `registration_router_flow_test.dart` two screens
further — pick a track and land on `/register/school` and `/register/university`
through the real `routerProvider`, asserting no `ErrorWidget`. Add one
`main_shell_test` case that force-logs-out and signs back in, which mounts
`HomeScreen` into an existing tree (and would also catch F-6-01).

**Risk of fixing:** test-only. `KNOWN_BUGS.md:80-86` warns that `pumpAndSettle`
is unusable past the OTP screen — reuse the existing bounded `pumpFrames` helper.

---

### F-6-07 [LOW] [BUG] `otp_screen`'s listen-then-navigate is unguarded against re-firing

**Evidence:** `lib/features/auth/screens/otp_screen.dart:62-79` — the listener
checks only `next.outcome is RegistrationRequiredOutcome`; it does not compare
`prev`. `outcome` is **sticky**: `OtpUiState.copyWith` (`otp_notifier.dart:64`)
is `outcome: outcome ?? this.outcome`, so it can never be cleared. And
`OtpNotifier` runs a `Timer.periodic` (`otp_notifier.dart:150-161`) that emits a
new state every second for the resend countdown.

**Why it matters:** any state emission after the fork re-runs `start(args)` +
`context.go('/register', extra: args)`. In practice the screen unmounts within
the same frame so the 1 s tick never lands, and `start()` is idempotent per token
(`registration_controller.dart:23-28`) — so this is latent, not live. It becomes
live the moment anything else emits synchronously after the outcome.

By contrast, `quiz_setup_screen.dart:178-194` and both registration detail
screens **do** guard (`if (!mounted) return;`), so this one site is the outlier.

**Recommended fix:** `if (prev?.outcome == next.outcome) return;` plus
`if (!mounted) return;`, matching the other four listen sites.

**Risk of fixing:** none. **Validation required:** none.

---

### F-6-08 [LOW] [PRODUCT DECISION] The Paymob return deep link has no handling of any kind — and no client-side plumbing either

**Evidence:**
- `lib/core/router/app_router.dart:83-84` — the single `TODO(deep-link)` in `lib/`:
  *"register the Paymob return route scheme once Seif provides it"*.
- `android/app/src/main/AndroidManifest.xml:31-34` — the only `<intent-filter>` is
  `MAIN`/`LAUNCHER`. No `VIEW` + `BROWSABLE`, no `android:scheme`, no
  `flutter_deeplinking_enabled` meta-data.
- `ios/Runner/Info.plist` — no `CFBundleURLTypes`, no associated domains.
- `/subscription/return` exists as a route (`app_router.dart:251`) but resolves to
  `_Placeholder('Paymob return')` and cannot be entered from outside the app.
- The vault spec is explicit: `Navigation_and_Deep_Links.md:7` — *"deep-link
  support is mandatory (Paymob return)"* — and `:36-39` specifies the required
  behaviour (re-fetch subscription state, never trust the redirect).

**Assessment:** correctly blocked on the backend partner for the *scheme*, and
the spec itself records it as open (`Navigation_and_Deep_Links.md:43`). Not a
defect. Recording it because the gap is total: nothing on the client side is
pre-staged, so this is a multi-file change (manifest, plist, route, a real
`/subscription/return` screen, `EntitlementsNotifier` already refetches on resume
at `me_notifier.dart:57`) rather than the one-line route registration the TODO
implies. Worth sizing honestly in the plan.

---

### F-6-09 [LOW] [BUG] An empty `questions` array walks the quiz into a `RangeError`

**Evidence:** `lib/features/quiz/bloc/quiz_state.dart:53` —
`QuizQuestion get question => quiz.questions[index];` with `index: 0` from
`QuizSession.start` (`:45`). No `isEmpty` guard exists anywhere in
`lib/features/quiz/`. `lib/features/quiz/models/quiz.dart:40-42` explicitly warns
*"Nothing may assume `questions.length == length`"*.

**Why it matters:** a `201` carrying `questions: []` (rather than the `422
not_enough_questions` the contract promises) makes `QuizBloc` emit
`QuizInProgress`, and `_QuizView`'s builder (`quiz_screen.dart:105`) dereferences
`session.question` during build → red screen. Server-dependent and therefore
speculative, but the model's own doc comment says the client must not trust the
count.

**Recommended fix:** guard in `_onStarted` (`quiz_bloc.dart:75-80`) — emit a
terminal error state when `event.quiz.questions.isEmpty`, rendered like
`_QuizUnavailableScreen`.

**Validation required:** confirm with the backend partner whether an empty-pool
`201` is possible, or read `contract/openapi.yaml` for a `minItems` on `questions`.

---

### F-6-10 [LOW] [QUALITY IMPROVEMENT] `bloc/SKILL.md` and `State_Management.md` describe a quiz timer that deliberately does not exist

**Evidence:** `.claude/skills/bloc/SKILL.md:18` (`QuizTimeExpired`), `:31`
(`QuizTimedOut`), `:40` (*"a tap racing the timer must lose deterministically"*),
`:47-48` (*"Timer discipline … cancel the subscription in `close()`"*), and
`01_Flutter_Specs/State_Management.md:34` (*"countdown timer … rejects invalid
transitions (e.g., tap after timeout)"*).

The implementation answers this head-on at `lib/features/quiz/bloc/quiz_state.dart:93-96`:
*"**There is no timer and no timeout state.** The `bloc` skill describes a
countdown, but the contract defines no time limit on a quiz anywhere — see
docs/seif_fight.md S7. Adding a client-side countdown would invent a rule the
server does not enforce."* That reasoning is correct and is a documented decision.

**The finding is the divergence, not the code.** Both the skill and the vault
spec — which `_AGENT_CONTEXT.md` names as the authoritative rules — still assert
a timer. An agent following the skill would add one back.

**On the audit's timer questions, for the record:** there is no countdown
`Timer` in the bloc, so "cancelled in `close()`" and "timer fires into a closed
bloc" are both vacuous. The analogous hazard — the explanation poll — **is**
handled correctly: `_poll` (`quiz_bloc.dart:238-267`) re-checks
`isClosed || _pollingFor != questionId` before every `add`, with no async gap
between check and `add`; `_stopPolling()` runs in `close()` (`:303`), on
`NextQuestionRequested` (`:152`), `PreviousQuestionRequested` (`:161`) and
`QuizFinishRequested` (`:290`).

**Recommended fix:** amend both `bloc/SKILL.md` and `State_Management.md` to
record the no-timer decision and cite `seif_fight.md S7`. Note that the skill
exists byte-identically in two trees (`_AGENT_CONTEXT.md:82-86`) — fix both.

---

## The quiz state machine — verdict

Read in full. **It genuinely rejects illegal transitions**, and the coverage in
`test/features/quiz/quiz_bloc_test.dart` (29 `blocTest` cases) matches the
skill's "minimum suite" and then some. Against each thing the audit asked:

| Illegal transition | Guarded? | Where |
|---|---|---|
| Answer after timeout | N/A — no timeout state exists (F-6-10) | — |
| Double-submit | **Yes** — `_onAnswerSubmitted` matches `QuizInProgress` only, so `AnswerConfirming` drops it | `quiz_bloc.dart:99-102`; test `:151` |
| Re-answer a graded question | **Yes** — `when … !session.isGraded` | `:100`; test `:168` |
| Next before answering | **Yes** — `when session.isGraded && !session.isLast` | `:150-151`; tests `:265`, `:273` |
| Events after finish | **Yes** — `QuizCompleted` is not a `QuizActive`, so every handler's pattern fails to match; `_onFinish` resolves `session == null` and returns | `:282-288`; test `:525` |
| Second `QuizStarted` | **Yes** — `if (state is! QuizInitial) return` | `:78`; test `:64` |
| Explanation re-request | **Yes** — `ExplanationIdle` check | `:181`; test `:372` |
| Late explanation for a question left behind | **Yes** — `_pollingFor` token | `:240`, `:243`; `:203-204` |
| Timer firing into a closed bloc | N/A / poll equivalent handled (`isClosed`) | `:240,243,253,260` |

The only structural gaps are F-6-09 (empty question list) and the absence of an
explicit test that closes the bloc mid-poll — the guards read correct, but the
scenario the skill calls *"the classic crash here"* has no assertion of its own.

---

## Riverpod lifecycle — `autoDispose` audit

**Server data held WITHOUT `autoDispose`** (memory + staleness; see F-6-01):

| Provider | Holds | Verdict |
|---|---|---|
| `meProvider` (`me_notifier.dart:39`) | `/me` | Deliberate and correct (tab switches must not refetch, `:11-13`) — but must be invalidated on logout |
| `entitlementsProvider` (`:73`) | `/me/entitlements` | Same |
| `subjectsProvider` (`subjects_notifier.dart:31`) | subject list | Same |
| `subjectTreeProvider` (`subject_tree_notifier.dart:47`) | **whole tree per subject, family-keyed, unbounded** | Documented decision (`:13-15`); the family grows with every subject opened and is never evicted. Acceptable at this catalog size; revisit if subject counts grow |
| `registrationSubmitProvider` (`registration_submit_notifier.dart:107`) | `RegistrationSubmitted` | Stays `AsyncData(RegistrationSubmitted())` for the process lifetime after a successful registration. Benign today (nothing renders off `.value`), but it is stale state with no owner |
| `countriesProvider`, `governoratesProvider`, `citiesProvider`, `educationSystemsProvider`, `universitiesProvider`, `avatarsProvider` (`reference_providers.dart:32-77`) | public reference data | Correct — immutable public data, cheap to keep. `schoolsProvider:53` is **dead code**: nothing in `lib/` reads it (`schoolSearchProvider` superseded it) |

**`autoDispose` where the flow spans routes:** checked, and correct. The
registration wizard's spine, `registrationControllerProvider`
(`registration_controller.dart:193`), is a plain `NotifierProvider` — it survives
`/register` → `/register/track` → `/register/school`, which
`registration_router_flow_test.dart:186-188` proves. `otpProvider`,
`quizSetupProvider`, `editProfileProvider` and `schoolSearchProvider` are all
`autoDispose` and all genuinely single-screen. **No provider is auto-disposed
that should not be.**

---

## GoRouter redirect — truth table

`authRedirect` (`app_router.dart:66-75`) is pure and unit-tested
(`test/core/router/app_router_test.dart:16-74`). Traced as a state machine:

| `matchedLocation` | `AuthUnknown` | `AuthUnauthenticated` | `AuthAuthenticated` |
|---|---|---|---|
| `/` | stay | stay (onboarding) | **→ `/home`** |
| `/login` | stay | stay | **→ `/home`** |
| `/otp` | stay | stay | stay ⚠ |
| `/register`, `/register/track`, `/register/school`, `/register/university` | stay | stay | stay ⚠ |
| `/home`, `/leaderboard`, `/learn/**`, `/message`, `/account` | **stay** ⚠ | → `/login` | stay |
| `/quiz/setup`, `/quiz/:id`, `/quiz/:id/result` | **stay** ⚠ | → `/login` | stay |
| `/profile`, `/profile/edit`, `/settings`, `/refer`, `/support`, `/friends`, `/legal/*` | **stay** ⚠ | → `/login` | stay |
| `/track-select`, `/subscription`, `/subscription/return` | **stay** ⚠ | → `/login` | stay |
| unmatched path (e.g. `/nope`) | stay | → `/login` | stay → go_router's default English error page |

**Can an unauthenticated user reach a protected route?** Only through the
`AuthUnknown` window (row-4 onward, ⚠). `AuthUnknown` returns `null` for *every*
location by design (`app_router.dart:69`, so `/` does not flash then bounce).
This is safe today because `initialLocation: '/'` (`:94`) and there is no deep
linking or route restoration — the app always starts at `/`, where onboarding is
the correct render for `unknown`. It stops being safe the moment a cold start can
begin at an arbitrary location: `/home` would mount, fire `GET /me` with no token,
take a 401, and `auth_interceptor.dart:129` would `forceLogout(sessionExpired)` —
showing *"Your session expired"* to a student who simply had no session.
**Recommendation:** when deep links land, make `AuthUnknown` return `null` only
for `_atAuthRoute` locations and render a splash elsewhere.

**Can an authenticated user get stuck on login?** No. `/login` and `/`
unconditionally bounce to `/home`.

**Redirect loop?** No. Both redirect targets are terminal for their own status:
`/login` is in `_authRoutes` so `AuthUnauthenticated` stays; `/home` is not in
`_signedInLandingRedirects` so `AuthAuthenticated` stays. No path where the
target re-triggers.

**⚠ rows 3–4:** an authenticated student is not bounced off `/otp` or the
`/register` wizard. Deliberate and load-bearing — `app_router.dart:36-43` explains
that `/register/school` and `/register/university` end in `POST /auth/register`,
which returns tokens, so the student is **already authenticated while still on**
those screens; bouncing them would break registration mid-submit. Correct as
built; noted so a future "tighten the guard" change does not regress it.

**`refreshListenable` and forced logout:** `routerProvider` mirrors `AuthStatus`
into a `ValueNotifier` via `ref.listen` in the provider body
(`app_router.dart:87-91`), disposed with the provider. `routerProvider` watches
nothing, so it never rebuilds and the `GoRouter` instance is stable — correct.
`app_router_test.dart:76-121` proves forced logout from a protected route lands
on `/login`. **Not proven:** that an *imperatively pushed* stack unwinds — the
test's protected route is the declarative `/home`, whereas the deepest real stack
is `/learn/…` → `push('/quiz/setup')` → `push('/quiz/:id')`, and `QuizScreen`
holds `PopScope(canPop: false)` (`quiz_screen.dart:110`). go_router should
discard the imperative matches on redirect; **this needs a test, not an argument.**
Note the failure mode is contained either way: `QuizScreen.dispose` disables
`FLAG_SECURE` unconditionally (`quiz_screen.dart:67-73`).

**Route params:** all path params are read with `!`
(`app_router.dart:173,180-181,186-188`), which is safe — go_router cannot match
the route without them. Ids are opaque strings passed to
`subjectTreeProvider(subjectId)`; a wrong-but-present id resolves to a 404 →
`AsyncError` → the error view (`lectures_screen_test.dart:126` covers exactly
this). No parsing, so nothing to throw. The `extra` casts are the real hazard —
F-6-04.

**Shell / tab state:** `StatefulShellRoute.indexedStack` (`app_router.dart:133`)
with five `StatefulShellBranch`es; the Learn drill-down routes are nested *inside*
branch 2 so the nav bar persists and the stack survives a tab switch.
`MainShell._goBranch` (`main_shell.dart:33-40`) passes
`initialLocation: index == currentIndex`, giving re-tap-to-pop-to-root. This is
the correct construction and `catalog_navigation_test.dart` proves the branch
stack is preserved.

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

- **F-6-01 is the one that will bite a real user first.** It needs no unusual
  input — just a shared phone and the shipped Log out button.
- The `AuthUnknown`-permits-everything rule and the three `state.extra!` casts are
  both dormant *only* because deep links and route restoration are off. They arm
  themselves simultaneously, the day the Paymob scheme arrives.
- `subjectTreeProvider`'s family has no eviction. Fine at today's catalog size;
  it is a slow leak by construction, not by accident.
- Nothing verifies that a forced logout unwinds an imperatively pushed stack.

## Deferred Improvements

- Delete `/track-select` (`app_router.dart:128`) and `schoolsProvider`
  (`reference_providers.dart:53`) — both dead.
- Reset `registrationSubmitProvider` to idle after a successful registration, or
  make it `autoDispose` and keep only `registrationControllerProvider` long-lived.
- Add an `errorBuilder` to the `GoRouter` so an unmatched route renders a
  localized screen instead of go_router's English default.

## Recommendations (ranked)

1. **Invalidate user-scoped providers on `AuthAuthenticated → AuthUnauthenticated`.**
   (F-6-01) One listener; closes a cross-account data leak.
2. **Point Onboarding's "Get Started" at `/login`.** (F-6-02) One line; unbreaks
   the app's front door.
3. **Add `if (!ref.mounted) return;` after every post-`await` `state =` in an
   `autoDispose` notifier.** (F-6-03) Nine call sites, no behaviour change.
4. **Extend `registration_router_flow_test.dart` through `/register/school` and
   `/register/university`, and add a logout→re-login case to `main_shell_test`.**
   (F-6-06) Closes the four remaining BUG-001-class blind spots and would have
   caught F-6-01 for free.
5. **Give the three `state.extra!` routes the `/quiz/:quizId` treatment.** (F-6-04)
   Do it before deep links land, not after.
6. **Reuse `TabPlaceholder` for `_Placeholder`, or disable the `LimitSheet` CTA.**
   (F-6-05) The paywall is the wrong place for untranslated English.
7. **Correct `bloc/SKILL.md` and `State_Management.md` to record the no-timer
   decision** (F-6-10), in both copies of the skill.
