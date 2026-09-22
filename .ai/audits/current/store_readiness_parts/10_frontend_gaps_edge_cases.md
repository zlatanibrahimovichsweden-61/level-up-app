# Part 10 — Frontend gaps & edge cases (Wave 1-A, subagent report, persisted verbatim)

HEAD `bf967d6`, session date 2026-09-22. Verification level for everything below: **SOURCE**
(read at HEAD in this repo). Nothing was built, run on a device, or checked in CI. No repo file
was edited except this one. Builds on `.ai/audits/current/store_readiness_parts/01_frontend.md`
(FE-01..23) — this register covers gaps only and does not repeat FE-01..23's content except
where a prior finding is resolved, sharpened, or contradicted.

---

## 1. adr-171 vocabulary scan

**Method.** Grepped `lib/l10n/app_en.arb`, `lib/l10n/app_ar.arb`, and every `lib/**/*.dart`
string/comment (`.freezed.dart`/`.g.dart` excluded as generated) for the banned-vocabulary list
verbatim plus the supplied Arabic variants.

| # | Hit | File:line | Value / context | Classification |
|---|---|---|---|---|
| 1 | `subscriptionRequiredTitle` | `app_en.arb:483` | "Subscription Required" | AMBIGUOUS — noun state name, matches the warning's own "account/subscription area" phrasing |
| 2 | `subscriptionRequiredBody` | `app_en.arb:484` | "This lesson needs an active subscription." | AMBIGUOUS — same reasoning; no verb, no price, no destination |
| 3 | `errorSubscriptionRequired` | `app_en.arb:495` | "This content needs an active subscription." | AMBIGUOUS |
| 4 | `subscriptionRequiredTitle` (AR) | `app_ar.arb:201` | "الاشتراك مطلوب" | AMBIGUOUS |
| 5 | `subscriptionRequiredBody` (AR) | `app_ar.arb:202` | "هذا الدرس يحتاج إلى اشتراك فعّال." | AMBIGUOUS |
| 6 | `errorSubscriptionRequired` (AR) | `app_ar.arb:207` | "هذا المحتوى يحتاج إلى اشتراك فعّال." | AMBIGUOUS |
| 7 | `leaderboardScopeCohort` (AR) | `app_ar.arb:287` | "الدفعة" (cohort/batch) | NOT a hit — false positive on "دفع" substring; unrelated word, no payment sense |
| 8 | `@subscriptionRequiredBody.description` | `app_en.arb:486` | dev-only ARB description: "...with no price, link or destination... 'plan', 'premium' and 'pro' are glossary-forbidden..." | Not user-facing (ARB `@`-description, never compiled into the app) |
| 9 | 8 doc-comment hits of buy/purchase/checkout | `app_router.dart:435`, `segmented_track.dart:152`, `entitlement_state.dart:13`, `me_notifier.dart:49,52`, `profile_repository.dart:76`, `profile_screen.dart:242`, `limit_sheet.dart:17,19`, `question_renderer.dart:21`, `app_localizations.dart:1169,1181` | e.g. "Purchase-silent (adr-049 §3)", "a student can buy on the website", "an 'Upgrade To Premium'... shows a paywall, a price, an upgrade link or where to buy" (negated) | NOT user-facing — Dart `///`/`//` doc comments explaining the *absence* of these things, stripped at compile time |

**No BANNED hits found anywhere** — zero occurrences of an imperative verb form (buy/اشترِ/اشترك
as a command), a price, an amount, a currency (EGP/ج.م/جنيه), a payment-provider name
(Paymob/Fawry/Vodafone/InstaPay), "checkout", or a plan-comparison table, in any ARB value or any
Dart string literal rendered to a user.

**PASS with new evidence:** `grep -rniE "\b(price|buy|purchase|payment|subscribe|paymob|fawry|
vodafone|instapay|checkout)\b" lib --include="*.dart"` (excluding generated files) returns 12
lines, all inside `///`/`//` comments, none in a `Text(...)`, ARB value, or other user-visible
string. `lib/features/subscription/{models,notifier,repository,screens}/` contain only
`.gitkeep` — the "subscription area" adr-171 requires a link inside does not exist yet, confirming
`store_readiness_state.md`'s "❌ NOT BUILT" line independently.

**Conclusion:** the app-wide vocabulary ban is **currently satisfied everywhere it can be
checked by grep**; every "subscription" occurrence is the state-noun the warning itself permits.
Nothing here needs a code change today — the risk is entirely in *future* work (the redemption
link + subscription screen that adr-171 asks for), not in what exists at HEAD.

---

## 2. Pinput / SMS autofill

`pubspec.yaml:59` pins `pinput: ^6.0.2`. `lib/features/auth/screens/otp_screen.dart:257-268`:

```dart
child: Pinput.builder(
  length: 6,
  controller: pinController,
  focusNode: focusNode,
  autofocus: true,
  keyboardType: TextInputType.number,
  forceErrorState: state.isInvalidCode,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  onChanged: onChanged,
  onCompleted: onCompleted,
  builder: (context, pin) => _DigitBox(state: pin),
),
```

No `androidSmsAutofillMethod`, `smsCodeMatcher`, `SmsRetriever`, `AutofillHints.oneTimeCode`, or
`sms_autofill` package anywhere in `lib/` (grep clean) or `pubspec.yaml` (grep clean). Pinput's
own SMS Retriever integration (which would pull in Google Play services and an implicit
`com.google.android.gms.auth.api.phone` dependency) is not wired up — the app relies on manual
paste/typing only.

**PASS.** No SMS autofill dependency, no Play services policy surface from this package.

---

## 3. FLAG_SECURE route coverage

`app_router.dart` quiz-family routes and what each screen shows:

| Route | Screen | Shows per-question Q&A / correct answers? | Screen protection call |
|---|---|---|---|
| `/quiz/:quizId` | `QuizScreen` | Yes — live question + answer choices during the attempt | `enable()`/`disable()` in `initState`/`dispose` — `quiz_screen.dart:69-70,78` |
| `/quiz/:quizId/result` | `QuizResultScreen` | **No** — aggregate only: score ring %, correct/wrong/skipped counts (`quiz_result_screen.dart:39-80`); "Review Questions" is explicitly disabled because per-question review needs `GET /quizzes/{quizId}`, which is `x-stability: draft` (doc comment `quiz_result_screen.dart:28-30`) | none |
| `/quiz/:quizId/result/review` | `QuizReviewScreen` | Yes — per-question correct/incorrect review, Figma `162:2377`/`337:6705` | `enable()`/`disable()` in `initState`/`dispose` — `quiz_review_screen.dart:64-65,69-70` |
| `/learn/mistakes` | `MistakesOverviewScreen` | **No** — subject names + integer `mistakeCount` only | none |
| `/learn/mistakes/subject/:id` | `MistakesSubjectScreen` | **No** — unit/lecture names + counts | none |
| `/learn/mistakes/.../unit/:id` | `MistakesChaptersScreen` | **No** — chapter names + counts (`mistakes_tree_screens.dart:104-127`) | none |
| `/learn/mistakes/.../chapter/:id` | `MistakesLessonsScreen` | **No** — lesson names + counts; every row is `onTap: null`, explicitly inert (doc comment `mistakes_tree_screens.dart:131-136`: "the replay quiz... is out of scope for Day 10") | none |

**Conclusion — this resolves `store_readiness_state.md`'s open item "FLAG_SECURE scope
Review/Mistakes unconfirmed (AND-13/SEC-07)":** the two screens that actually render a specific
question's correct answer (`QuizScreen`, `QuizReviewScreen`) are both protected. The two families
that are *not* protected (`QuizResultScreen`, the four Mistakes screens) do not, by current
design, render any question text or answer content — only aggregate numbers and catalogue
names/counts. There is no unprotected answer-bearing screen at HEAD. This is a **PASS**, not an
open question — AND-13/SEC-07 can be closed with this evidence rather than carried as
"unconfirmed."

---

## 4. Functional review-time edge cases (SOURCE-level trace)

| Scenario | Trace | Evidence |
|---|---|---|
| **No internet, cold start, already logged in** | `AuthController._resolveInitial()` decides auth from a **local** secure-storage read only (no network call) → `AuthAuthenticated` → router sends the student straight to `/home`, not a blocking splash. The first network call (`meProvider.build()` → `GET /me`) then fails with `NetworkException`; Home renders its own per-screen Offline state. | `auth_controller.dart:43-48`; `core_providers.dart:55-58` (`isOnlineProvider`, connectivity_plus) |
| **No internet, cold start, never logged in** | `AuthUnauthenticated` → Onboarding/Login render (both static, no network needed) until "Send OTP" is tapped, which then fails visibly. | `auth_controller.dart:47`; `app_router.dart:49,71-80` |
| **Slow network / timeout** | `dio_client.dart:17-18` — `connectTimeout: 15s`, `receiveTimeout: 20s`. Both a timeout AND a plain connection error map to the **same** `NetworkException` that a real "no connectivity" state maps to (`isOffline()` returns true for both `OfflineException` and `NetworkException`). A reachable-but-slow/hanging server therefore shows the identical "you're offline" UI as an airplane-mode device — there is no distinct "request timed out, try again" state. | `error_interceptor.dart:16-21`; `exceptions.dart:19-26,92-93` |
| **Server 5xx / 503 "maintenance"** | Falls through the interceptor's `switch` to the generic `_ => ApiException(status: status, code: code)` branch — no maintenance-specific handling, no distinct copy from any other 5xx. Screens never render the raw `title`/`detail`; they fall through to each screen's existing generic-error slot (per 01_frontend.md's own PASS section, e.g. `quiz_error_copy.dart:10-34` → `genericError`). | `error_interceptor.dart:29-41` |
| **Expired access token mid-request** | `AuthInterceptor` catches the 401, attempts a single-flight refresh; success retries the original request transparently (already documented in 01_frontend.md §2 PASS). | `auth_interceptor.dart:75-156` (re-verified, unchanged) |
| **Refresh failure → forced logout copy** | `refresh_token_invalid` or `session_superseded` both call `forceLogout(LogoutReason.sessionExpired \| supersededOtherDevice)`, which clears tokens (device_id preserved) and flips state to `AuthUnauthenticated(reason)`; the router's `refreshListenable` redirects to `/login`, which reads the reason and shows `l10n.sessionExpired` = "Your session expired. Please sign in again." / "انتهت صلاحية جلستك. من فضلك سجّل الدخول مرة أخرى." | `auth_interceptor.dart:131,148-150`; `login_screen.dart:66`; `app_en.arb:97`; `app_ar.arb:43` |
| **App resumed after >60 days (refresh TTL)** | Contract: access JWT ~15 min, refresh token TTL **60 days**, rotating (`openapi.yaml:56`, `:2252-2253`). Client never checks this locally. `meProvider` has **no** auto-refresh on resume (manual pull-to-refresh only, `me_notifier.dart:17-30`). `entitlementsProvider` *does* register an `AppLifecycleListener(onResume: refresh)` (`me_notifier.dart:58`), but — independently re-confirmed here — it is never `ref.watch`ed by any screen at HEAD (grep of `lib/features/**` for `entitlementsProvider` outside its own file: zero), so `build()` never runs and the listener never registers; this corroborates parts/05's API-05 finding from the frontend side. Net effect on a >60-day-dormant cold start: the stale token passes the local presence check, the app opens straight to `/home`, the first `GET /me` 401s, the refresh attempt 401s (`refresh_token_invalid`), and the student is bounced to `/login` with the `sessionExpired` copy above. No crash, one extra failed round trip. | `me_notifier.dart:17-78`; `auth_controller.dart:43-48` |
| **App killed while the system browser is open** | No `restorationId`/`RestorationScope` anywhere in `lib/` (grep clean). If Android reclaims the process while the (currently `.example`) legal link's system browser is foregrounded, the app cold-starts back at `initialLocation: '/'` on return with **no** state restoration. Combined with the finding below, any in-progress registration wizard is lost. | grep of `lib/` for `restorationId`/`RestorationScope`: no matches; `app_router.dart:99` |
| **Registration wizard survives process death?** | No. `RegistrationController extends Notifier<RegistrationDraft?>` (`registration_controller.dart:15-17`) is pure in-memory Riverpod state; nothing persists a `RegistrationDraft` to disk (no Hive/shared_preferences/secure_storage write for it — only `session_scope.dart:91-93` *invalidates* it in memory on logout). A process kill mid-wizard (plausible on a low-RAM device, or specifically triggered by backgrounding to view a legal link mid-registration) silently discards name/DOB/parentPhone/school/governorate and forces a restart from OTP. | `registration_controller.dart:15-36`; `session_scope.dart:84-93` |
| **Switching accounts, same device** | `invalidateSessionScope` drops 12 user-scoped providers (profile, entitlements, catalogue, mistakes, login/OTP UI state, registration draft, quiz setup) — already documented in 01_frontend.md FE-06 as leaving the `CachedNetworkImage` cache uncleared. Independently re-checked here: `device_id`, theme, locale, and the 7 shared reference-data providers (countries/governorates/cities/schools/education systems/universities/avatars) are *deliberately* preserved (non-PII, or load-bearing for session continuity) — no additional PII leak beyond the already-known image cache. | `session_scope.dart:36-100` (full file read) |
| **Timezone / `expiresAt` / weekly-reset handling** | `EntitlementState.expiresAt`/`graceEndsAt` are parsed via `DateTime.parse` from server ISO-8601 but never locally compared against `DateTime.now()` anywhere in `lib/` (grep clean for that combination) — `active`/`inGrace` booleans are taken from the server as-is, consistent with "server authoritative." `TokenPair` carries *relative* `accessExpiresInSeconds`/`refreshExpiresInSeconds`, not absolute timestamps, so token-expiry logic never depends on device-clock accuracy either. The only local `DateTime.now()` uses are the DOB picker's max-date bound and the registration draft's own client-side `tokenExpiresAt` countdown (`registration_draft.dart:68`, `registration_controller.dart:31`) — a client-computed deadline for a client-only concept (how long before the OTP-issued registration token is treated as stale), not a server date recomputed locally. `error_interceptor.dart:56-63` explicitly refuses to parse the HTTP-date form of `Retry-After` "because converting it means trusting the device clock against the server's." | grep of `lib/` for `DateTime.now()`/`toLocal()`/`DateFormat` (5 hits total, listed above); `entitlement_state.dart`, `token_pair.dart` (via `.g.dart`/`.freezed.dart`) |
| **Keyboard/IME: Arabic-Indic digits on the phone field** | `login_screen.dart:312`: `inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))]` allows only ASCII `0-9`, `+`, space. `Phone._foldDigits()` (`phone.dart:49-62`) exists specifically to fold Arabic-Indic (٠-٩) and Extended Arabic-Indic (۰-۹) digits to ASCII — but the field's own input formatter silently strips those code points *before* they ever reach `Phone.tryParse`, making the folding logic dead in the one place it would matter. A student whose device numeral system is set to Arabic-Indic (a real, common setting under an Arabic system locale on Egyptian Android phones) cannot type a phone number on Login at all — keystrokes vanish, no error shown. SOURCE-confirmed for the block; DEVICE-level would be needed to confirm exactly which glyphs an Arabic-Indic keypad emits. | `login_screen.dart:305-323`; `phone.dart:1-62` |
| **Keyboard/IME: Arabic-Indic digits on the OTP field** | The mirror-image gap: `Pinput.builder` (`otp_screen.dart:257-268`) sets **no** `inputFormatters`, so Arabic-Indic digits *could* be typed if the numeric keypad emits them, but `otp_notifier.dart:112` passes the raw `code` straight to `verifyOtp()` with no folding step equivalent to `Phone._foldDigits`. If it happens, the server almost certainly rejects a non-ASCII 6-digit code with a generic "wrong code" error rather than anything actionable. DEVICE-level confirmation needed on whether Flutter's `TextInputType.number` actually surfaces Arabic-Indic glyphs on a real Egyptian-locale device; SOURCE-level fact is that nothing in the code guards against it either way. | `otp_screen.dart:257-268`; `otp_notifier.dart:112` |
| **Dark mode + large text** | Already tracked as BUG-002, OPEN, device-verified on a Pixel 8: Mistakes subject-card count caption overflows at system font scale ≳1.2, worse in Arabic. Cited here per the task's instruction, not re-verified. | `docs/KNOWN_BUGS.md:103-113` |
| **Rate-limit 429 handling / `Retry-After`** | Well-built: `RateLimitedException` carries a defensively-parsed `retryAfter` (`error_interceptor.dart:56-70` — delta-seconds only, explicitly refuses the HTTP-date form to avoid trusting the device clock; `exceptions.dart:68-80`). Copy exists both with and without a usable `Retry-After` (`rateLimited` / `rateLimitedIn(seconds)`, `app_en.arb:10-16`, `app_ar.arb:7-8`) and is wired into the geography pickers, the leaderboard (`leaderboard_screen.dart:223,241`), and registration (`registration_error_copy.dart:44-49`). No countdown UI yet (documented as future work in the exception's own doc comment) but nothing broken. | as cited |
| **First install vs upgrade / versioned local storage** | `PreferencesStore` holds exactly two keys (`pref.theme_mode`, `pref.locale`), both read defensively (`_read` swallows a type-cast exception from a value written by a different app version and returns "nothing stored" rather than crashing) and written as human-readable enum names rather than an index, specifically to avoid tying the file format to enum ordering. No schema-version key exists, but with only two self-healing string values there is no real migration surface to have one. **Not a gap** given the current scope — flagged only because the task asked to check. | `preferences_store.dart:1-116` (full file read) |
| **Unauthenticated deep link / cold start on a non-existent route** | `GoRouter(...)` at `app_router.dart:98-102` passes no `errorBuilder`. Grep of the whole file for "error" (case-insensitive) returns two unrelated hits (a code comment, a generic-error `Text`) — there is no custom 404/unknown-route screen. A hand-typed bad path, a stale/malformed deep link, or a future App/Universal Link that doesn't match any `GoRoute` falls through to go_router's own built-in error page: hardcoded English, not routed through `AppLocalizations`, no offline/retry affordance, no app chrome. This is a **new gap**, not listed in `01_frontend.md`, and directly breaks the project's own "every screen handles loading/empty/error/offline, in AR+EN" rule for this one implicit screen. | `app_router.dart:98-102` (full `GoRouter(...)` constructor read); grep of file for `errorBuilder`/`error` |
| **OTP resend countdown across backgrounding** | `otp_notifier.dart:196-202`: `Timer.periodic(const Duration(seconds: 1), ...)` decrements an in-memory `int` each tick; it is **not** anchored to a stored wall-clock deadline (no `DateTime.now().add(resendAfterSeconds)` comparison anywhere in the file). Dart/Flutter timers stop ticking while the app is backgrounded and do not fire missed ticks on resume. The single most likely reason to background this exact screen — switching to the Messages/SMS app to read/copy the arriving code — means the visible "resend in Ns" will not reflect real elapsed time on return, understating how long the student has actually waited (delaying when Resend becomes tappable, or in principle showing an inconsistent count if the timer is torn down/recreated by the OS). No `WidgetsBindingObserver`/`AppLifecycleListener` is wired into `OtpNotifier` to reconcile this. **New gap**, not in `01_frontend.md`. | `otp_notifier.dart:73,163-179,196-202` |

---

## 5. First-run behaviour

- **No "onboarding seen" flag exists, by design**, documented in the router's own comment: "auth
  state already answers the question. First launch → unauthenticated → `/` renders. Returning →
  authenticated → `/home` before paint." (`app_router.dart:56-64`). Consequence: Onboarding is
  shown on **every** signed-out cold start, not only the very first install — including after a
  logout. This is a deliberate, documented choice, not an oversight.
- **Splash / no-flash gate while tokens are read:** `bootstrap()` awaits `PreferencesStore.load()`
  (theme + locale only) *before* `runApp`, specifically to avoid a flash of the wrong canvas while
  the native splash screen is still up (`bootstrap.dart:14-23`). The **auth** token read is
  separate and is *not* awaited before `runApp` — `AuthController.build()` returns `AuthUnknown`
  immediately and resolves asynchronously (`auth_controller.dart:36-41`); the router's
  `authRedirect` treats `AuthUnknown` as "wait, don't redirect" (`app_router.dart:71-73`), so no
  incorrect flash to `/login` occurs. The trade-off: because `initialLocation` is `/`,
  `OnboardingScreen` itself does build for that first frame/microtask, under any auth state,
  before the async check resolves and (for a returning student) redirects to `/home` — a
  sub-frame flash of Onboarding rather than of Login. This matches the code's own stated intent
  and is not flagged as a defect.

---

## 6. UGC surfaces inventory

| Surface | Shows peer name/avatar? | Reachable at HEAD? |
|---|---|---|
| Leaderboard row | Yes — `BoardAvatar(url: entry.avatarUrl...)` + `entry.name` (or "You") | `leaderboard_row.dart:83,89` |
| Leaderboard podium | Yes — avatar + `entry.name` for top 3 | `podium.dart:141,154` |
| Friends screen (`/friends`) | **No** — its own doc comment states "Nothing here is invented — no friend rows, no counts, no avatars"; renders only a static "not available" message | `friends_screen.dart:20,26-38` |
| Message tab | No — `MessagePlaceholderScreen`, "Coming soon" only | `app_router.dart` (placeholder route) |
| Mistakes screens | No — subject/unit/chapter/lesson **names**, never a peer's | see §3 table |

**Reachability, re-verified independently of `01_frontend.md`:** `grep -rn "LeaderboardScreen("
lib` returns exactly one hit — the class's own constructor declaration
(`leaderboard_screen.dart:33`) — and `grep` for any `context.go\('/leaderboard'\)` /
`context.push('/leaderboard')` call site returns zero. The router's `/leaderboard` `GoRoute`
builds `LeaderboardPlaceholderScreen`, not `LeaderboardScreen` (`app_router.dart:169-170`). So
**the only two widgets in the entire app that render a peer's name or avatar are currently
unreachable by any user action.** This matches FE-10's finding and closes the "reachable?"
question definitively: no UGC is exposed today. It becomes an Apple 1.2 (report/block for
user-generated content) consideration the moment FE-10 ships the real `LeaderboardScreen` —
`grep` confirms zero report/block UI exists anywhere in `lib/` today.

---

## 7. Additional findings not in `01_frontend.md`

**FE-24 · C · both · Redemption-link precedent uses the wrong launch mode.** The only
`launchUrl`/`LaunchMode` call site in the codebase — the legal-link opener on Login —
uses `LaunchMode.externalApplication` with no confirmation dialog
(`login_screen.dart:117-118`: `await launchUrl(Uri.parse(url), mode:
LaunchMode.externalApplication);`). adr-171 requires the future redemption link to open via
**SFSafariViewController / Chrome Custom Tabs** (an in-app browser tab), behind a "you are about
to leave the app" confirmation. The one existing pattern in the repo that a future implementer
would naturally copy does neither. Not a defect today (legal links are informational, not a
policy-governed redemption flow), but a concrete trap for whoever builds the adr-171 link next —
worth a one-line note in `docs/DESIGN_ISSUES.md` or `seif_fight.md` so it isn't copy-pasted
forward. Owner: frontend (when the subscription-area work starts).

**FE-25 · C · both · No `GoRouter` `errorBuilder`.** See §4 table row "Unauthenticated deep link /
cold start on a non-existent route." A malformed or stale deep link renders go_router's built-in,
un-localized error page — the one implicit "screen" in the app that does not follow the project's
own loading/empty/error/offline × AR/EN rule. Cheap to fix (one `errorBuilder:` param + a small
localized screen); flagged here because it is a real reviewer-tappable path (any bad URL,
including one a reviewer might hand-type while poking at the app) and was not enumerated in
`01_frontend.md`. Owner: frontend.

**FE-26 · C · both · OTP resend countdown does not survive backgrounding accurately.** See §4
table row "OTP resend countdown across backgrounding." Owner: frontend.

**FE-27 · D · both · Arabic-Indic digit input is asymmetric between Login and OTP.** Login
actively blocks it (over-strict input formatter defeats existing fold logic); OTP has no
guard at all (under-strict, no fold logic exists there). Neither half is device-verified in this
session — flagged as a paired SOURCE-level inconsistency worth a single QA pass on a real
Egyptian-locale device before relying on either behavior. Owner: frontend.

**Confirmed-fine, not gaps (checked because the task asked, included for completeness):**
- Phone field forces `TextDirection.ltr` regardless of UI locale (`login_screen.dart:310`) —
  correct, not a bug.
- `PreferencesStore`'s lack of a schema-version key is a non-issue given its 2-key, self-healing
  scope (§4 table).
- 5xx/503 handling is generic-but-safe, matching the project's "never render raw server error"
  rule (§4 table) — no maintenance-mode-specific UX exists, but nothing is broken either.

---

## 3′. Could not determine (SOURCE-only session, listed separately from Part 01's own list)

- Whether an Arabic-Indic numeral keyboard actually reaches the OTP `Pinput` field on a real
  Egyptian-locale Android/iOS device, and in what form — DEVICE.
- Whether go_router's default error-page behavior changed across the pinned `go_router` version
  in a way that shows more or less of the underlying exception — not checked against
  `pubspec.lock`'s pinned version's source.
- Whether the OTP countdown discrepancy after backgrounding is perceptible in practice (exact
  Android/iOS timer-suspension behavior can vary by OS version and battery-optimization state) —
  DEVICE.
