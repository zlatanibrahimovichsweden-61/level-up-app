# Part 16 — Reviewer experience & cross-platform submission (Wave 2-D, Opus) — 2026-09-22

**Scope.** What an Apple App Review reviewer and a Google Play reviewer (plus the Robo crawler)
actually see, tap and conclude, screen by screen, at HEAD `bf967d6`. Read-only: no repo file
outside this one was created or modified.

**Inputs read in full:** `parts/01_frontend.md`, `parts/10_frontend_gaps_edge_cases.md`,
`parts/05_api_backend.md`, `parts/12_policy_gap_analysis.md` (POL-03, POL-09, POL-10, POL-12),
`parts/03_android_src.md` §1–2, `parts/04_ios_src.md` §3, `parts/02_release_artefact_android.md`,
`../store_readiness_state.md`.

**Source re-verified this session (SOURCE).** `lib/core/router/app_router.dart` (whole file),
`lib/core/config/app_config.dart:45-55`, `lib/app.dart:25-60`,
`lib/core/providers/locale_provider.dart` (whole file), `lib/core/providers/theme_provider.dart:35-56`,
`lib/features/onboarding/screens/onboarding_screen.dart`,
`lib/features/auth/screens/login_screen.dart`, `lib/features/auth/screens/otp_screen.dart:1-140`,
`lib/features/auth/models/phone.dart`, `lib/features/auth/auth_error_copy.dart`,
`lib/core/network/interceptors/error_interceptor.dart:1-60`, `lib/core/network/exceptions.dart:85-134`,
`lib/features/registration/screens/*` + `models/registration_validation.dart` +
`models/registration_draft.dart` + `widgets/date_of_birth_field.dart`,
`lib/features/shell/main_shell.dart`, `lib/features/shell/screens/tab_placeholder.dart`,
`lib/features/home/screens/home_screen.dart`, `lib/features/home/widgets/coming_soon_section.dart`,
`lib/features/profile/screens/profile_screen.dart`,
`lib/features/profile/widgets/avatar_sheets.dart:120-150`,
`lib/features/settings/screens/settings_screen.dart`,
`lib/features/account_shells/screens/*`, `lib/features/catalog/widgets/catalog_states.dart:85-130`,
`lib/features/quiz/widgets/limit_sheet.dart:55-110`, and both ARB files (values extracted
programmatically, EN quoted verbatim below, AR presence confirmed key-by-key).

**Verification levels.** SOURCE = read at HEAD this session · PARTS = carried from a Wave-0/1 part ·
ARTEFACT = proven against the built APK/AAB in parts/02 · PROJECTION = a reasoned prediction of
runtime behaviour from SOURCE, never run. Every walkthrough step below is a PROJECTION unless it
carries a different tag; **no device was used in this pass and no build was made.**

**Severity legend.** A blocker · B high · C medium · D low · E external/console · F pass · G n/a.

---

## Headline

1. **S1 is not reviewable at all, and the failure mode is worse than "server down": it lies.**
   `https://TBD.example/api/v1` is a reserved TLD, so every request dies as
   `DioExceptionType.connectionError` → `NetworkException` → `isOffline()` **true**
   (`error_interceptor.dart:16-17`, `exceptions.dart:91-92`). Every screen therefore says
   **"You are offline"** to a reviewer on a perfect Wi-Fi connection, while the offline *banner*
   stays hidden because `connectivity_plus` correctly reports online. A reviewer concludes the app
   is broken *and* that its error handling is wrong. (REV-01)

2. **The app opens in Arabic, right-to-left, on an English-locale device — by construction, not by
   accident.** `MaterialApp.router` is handed `locale: ref.watch(localeProvider)`
   (`app.dart:25,58`) and `LocaleController.build()` returns the stored preference **or
   `const Locale('ar')`** (`locale_provider.dart:23-24`). The device locale is never consulted.
   On an English iPhone the first screen a reviewer sees is Arabic. Meanwhile the iOS bundle
   declares only `en` (IOS-07, no `CFBundleLocalizations`), so the App Store listing will say
   "English". That is an Apple 2.3 metadata-accuracy mismatch nobody has listed. (REV-02, REV-28)

3. **The one door to Settings, the privacy policy, the terms and Logout is behind `GET /me`.**
   `ProfileScreen` puts the whole ten-row menu inside `StateWidget.onLoaded`
   (`profile_screen.dart:63-92, 115-152`). When `/me` fails, the Account tab is a centred icon +
   "Something went wrong" + Retry. There is then **no way to sign out, no way to reach the privacy
   policy, and no way to change language**, because `/settings` has exactly one entry point and it
   is inside that menu. In S1 this is permanent. (REV-03)

4. **Nothing on the iOS side has ever existed as an artefact.** There is no Podfile, no Pods, no
   IPA (IOS-01). "S1 on an iPhone" is therefore a projection of Dart behaviour, not a description
   of a build anyone has produced; and the first upload attempt may be stopped by ITMS-91053
   (IOS-03 / POL-07) before a human reviewer ever launches it. (REV-22)

---

## 1. Scripted walkthroughs

### 1.0 Conventions

- **S1** = the app exactly as built at HEAD from `-t lib/main_prod.dart`. Android is
  ARTEFACT-grounded (parts/02 built it); iOS is a projection (REV-22).
- **S2** = the minimum external fixes only: a real production base URL is shipped, a production
  reviewer phone exists with a fixed OTP, and the account is past registration with an active
  `baseSubscription` and seeded content. **No code change.** Everything the reviewer still hits in
  S2 is a repo problem, not a backend one.
- Tab order is the `StatefulShellRoute` branch order, left→right as `MainShell` lays it out:
  **Home · Leaderboard · Learn (raised centre) · Message · Account**
  (`main_shell.dart:57-63`; branches at `app_router.dart:142-282`).
- EN copy is quoted verbatim from `lib/l10n/app_en.arb`. **Every key quoted below is present in
  `lib/l10n/app_ar.arb` too** (checked key-by-key this session; the ARB-parity guard at
  `test/guards/project_rules_test.dart:278` enforces it). The only exception noted anywhere in this
  chapter is the hardcoded English `'Track select'` app-bar title (`app_router.dart:133-136`).

---

### 1A. Apple App Review — iPhone, English device locale — **S1**

| # | Screen / route | What the reviewer sees | Evidence |
|---|---|---|---|
| 0 | Home screen of the phone | Icon is the **stock Flutter logo** (all 15 iOS PNGs md5-identical to `flutter_template_images-5.0.0`); name under it is **"Level Up App"** (`CFBundleDisplayName`), while the app's own title string is "Level Up" and `CFBundleName` is `level_up_app` — three different brand strings | IOS-02, IOS-11, parts/02 |
| 1 | Launch | Template launch storyboard: **white** background with an invisible 1×1 image. On a dark-canvas start this is a white flash | IOS-12 |
| 2 | `/` Onboarding | **In Arabic, RTL.** Illustration, frosted sheet, title "ليفل أب", tagline "رحلتك" + "التعليمية", subtitle, primary CTA **"ابدأ الآن"** (`getStarted`), secondary **"تسجيل الدخول"** (`logIn`). Top-**left** (RTL end) a pill reading **"English"** (`switchLanguage`, AR value) | `onboarding_screen.dart:44-125`, `locale_provider.dart:23-24` |
| 3 | Taps the "English" pill | Whole app flips to EN/LTR instantly and the choice is persisted to `shared_preferences`. **This works in S1** — it is a pure client preference, no network | `locale_provider.dart:37-45`, `preferences_store.dart` |
| 4 | Taps **"Get Started"** | Goes to `/login`. **Both** buttons go to `/login` — there is no separate sign-up route, by design | `onboarding_screen.dart:70-96` |
| 5 | `/login` | Bird logo, "Welcome back", "Enter your phone number to continue", a phone field showing `🇪🇬 +20 ▾` with hint **`01021871999`** (a real-looking Egyptian mobile that also ships in the binary — ARTEFACT), primary **"Send OTP"**, "OR", secondary **"Create New Account"**, and the legal line: **"By continuing, you agree to our User Agreement, Privacy Policy and Cookie Policy"** | `login_screen.dart:160-256, 352-391`; FE-18; parts/02 string scan |
| 6 | Taps **"Privacy Policy"** | `launchUrl('https://levelup.example/legal/privacy', LaunchMode.externalApplication)` — a **reserved TLD**. Safari opens and fails to resolve. There is **no `canLaunchUrl`, no try/catch, and no in-app fallback**; if the launch itself throws, the future is unawaited | `login_screen.dart:43-46, 117-118`; FE-02; FE-14 |
| 7 | Types a number, taps **"Send OTP"** | Button is *enabled* (connectivity says online). `POST /auth/otp/request` → DNS failure → inline red row with a **wifi_off icon** and the text **"You are offline"** (`offline`). The pinned `OfflineBanner` is **not** shown, because `isOnlineProvider` is true | `error_interceptor.dart:16-17`; `exceptions.dart:91-92`; `auth_error_copy.dart:10`; `login_screen.dart:126-131, 186-198` |
| 8 | Retries / taps "Create New Account" | Identical: the secondary button calls the **same** `_submit()` | `login_screen.dart:226-248` |
| 9 | Tries to go deeper | There is nowhere to go. `/otp` requires an `OtpArgs` from a successful request; `/register*` requires a `registrationToken`; every other route redirects to `/login` (`_authRoutes = {'/', '/login', '/otp'}`, `authRedirect` at `:71-79`) | `app_router.dart:49-79, 104-110` |
| 10 | Hand-types a bad path while poking | go_router's **built-in error page**: hardcoded English, no `AppLocalizations`, no app chrome, no retry. `GoRouter(...)` is constructed with **no `errorBuilder`** | `app_router.dart:98-102`; FE-25 |

**Apple verdict on S1: rejection under 2.1 (App Completeness / "turn on your back-end service") on
the first screen after Onboarding.** Secondary grounds already visible without signing in: 5.1.1(i)
(no reachable privacy policy), 2.3.8 / 4.0 (placeholder icon), 2.3 (listing says English, app opens
Arabic). Nothing else in the app is reachable, so nothing else can be assessed.

---

### 1B. Apple App Review — iPhone, English locale — **S2** (prod URL + reviewer phone + fixed OTP exist)

Steps 0–5 are unchanged (icon, name, Arabic-first launch, `.example` legal links on Login all
survive S2 — they are repo facts, not backend facts).

| # | Screen / route | What happens | Evidence |
|---|---|---|---|
| 6 | `/login` → Send OTP | `202` → `context.push('/otp', extra: OtpArgs(...))` | `login_screen.dart:105-113` |
| 7 | `/otp` | Six `Pinput` boxes, a circular back chip, resend countdown. **No SMS autofill** is wired (no `androidSmsAutofillMethod`, no `AutofillHints.oneTimeCode`) — the reviewer types the fixed code by hand, which is what we want. The countdown is a plain in-memory `Timer.periodic`, **not wall-clock anchored**, so backgrounding to check Messages leaves it wrong on return | `otp_screen.dart:257-268`; FE-26; parts/10 §2 |
| 8 | Verify → **pre-registered** number | `AuthenticatedOutcome` → a success view with a Continue button → `context.go('/home')` | `otp_screen.dart:86-124` |
| 8′ | Verify → **NEW** number | `RegistrationRequiredOutcome` → seeds the draft and `context.go('/register')`. See §1E | `otp_screen.dart:66-83` |
| 9 | **Tab 1 · Home** (`/home`) | Real: avatar + name header, Level card (`level`, `points.total`, both server-authoritative). Then **three sections whose entire body is a card reading "Coming soon"** — *Daily Tasks*, *Continue Learning*, *Top Student* (plus *Learning Tools* on the University track). Each section header carries **"See All"**, which is a bare `Text` widget with **no `GestureDetector`, no ripple, no handler** — tapping it produces literally nothing, not even a pressed state | `home_screen.dart:88-131`; `coming_soon_section.dart:65-100` |
| 9a | Home with an unseeded cohort | `/me` still returns a profile, so Home renders normally — the coming-soon cards are indistinguishable from the seeded case. Home has **no empty state** by design | `home_screen.dart:33` |
| 10 | **Tab 2 · Leaderboard** (`/leaderboard`) | `LeaderboardPlaceholderScreen` → app bar "Leaderboard", clock icon, **"Coming soon"**. The real, fully built `LeaderboardScreen` is not routed (0 call sites) | `app_router.dart:169-171`; `tab_placeholder.dart:22-40, 63-70`; FE-10 |
| 11 | **Tab 3 · Learn** (`/learn`, raised centre tab) | Real. "Subjects", a search field ("Search Subjects"), a **Mistakes** row, and subject cards. Empty cohort → **"No subjects yet"** (`noSubjects`) as the whole tab. Search with no hit → "No subjects match your search" | `subjects_screen.dart:54, 70-78, 166, 227, 264` |
| 11a | Learn drill-down | subject → (school) unit → chapter → lesson → `/quiz/setup`; (university) subject → lecture → `/quiz/setup`. Empty levels render **"Nothing here yet"** (`nothingHere`) | `subject_tree_screen.dart`, `chapters_screen.dart:55`, `lessons_screen.dart:56, 111-113`, `lectures_screen.dart:87-89` |
| 11b | Starts a quiz | With an active `baseSubscription` the quiz runs. **`QuizScreen` and `QuizReviewScreen` set screen protection in `initState` and clear it in `dispose`** — on iOS via ScreenProtectorKit's secure-layer trick. A reviewer recording the session gets blank frames on exactly those two screens | `quiz_screen.dart:63-79`; `quiz_review_screen.dart:64-70`; parts/10 §3; IOS-15 |
| 11c | Without a subscription (free reviewer account) | A bottom sheet: **"Subscription Required"** / **"This lesson needs an active subscription."** and a single **"Not now"** dismiss. **No price, no plan, no link, no CTA of any kind** | `limit_sheet.dart:64-99`; `app_en.arb:483-484` |
| 12 | **Tab 4 · Message** (`/message`) | `MessagePlaceholderScreen` → app bar **"Message"**, clock icon, **"Coming soon"** | `app_router.dart:268-271`; `tab_placeholder.dart:76-83` |
| 13 | **Tab 5 · Account** (`/account`) | Profile hub: header card + Edit Profile, a **Points** stat card, then ten rows (below) | `profile_screen.dart:115-152` |
| 13.1 | Row 1 **Settings** | → `/settings`. Works | `profile_screen.dart:188-193` |
| 13.2 | Row 2 **Favorite questions** | **Disabled**, subtitle **"Not available yet"**. Tapping does nothing | `profile_screen.dart:198-204` |
| 13.3 | Row 3 **Your progress** | **Disabled**, **"Not available yet"** | `profile_screen.dart:210-216` |
| 13.4 | Row 4 **Refer a Friend** | → `/refer`: a screen whose entire content is **"Inviting friends isn't available yet."** plus a **disabled "Share invite"** button | `refer_a_friend_screen.dart:30-39` |
| 13.5 | Row 5 **Customer Support** | → `/support`: **"Support isn't available yet."** plus a **disabled "Create Ticket"** button. *This is the row a reviewer checking support contact will open.* | `customer_support_screen.dart:27-36` |
| 13.6 | Row 6 **Privacy & policy** | → `/legal/privacy`: **"This document hasn't been published yet."** | `legal_document_screen.dart:43-53`; `app_en.arb:611` |
| 13.7 | Row 7 **Terms & Conditions** | → `/legal/terms`: the **same** screen, same sentence, different title | `legal_document_screen.dart:38-41` |
| 13.8 | Row 8 **Go to University** | Opens a modal: title **"Go to Uni"**, body **"Are you sure you want to convert to the University track?"**, note **"You can't go back again."**, a **disabled "Confirm"** with reason **"Switching tracks isn't available yet."** | `profile_screen.dart:290-310` |
| 13.9 | Row 9 **Logout** | Modal: "Logout" / "Are you sure you want to log out?" / "Logout". Works — best-effort `POST /auth/logout`, tokens cleared, `device_id` kept, router redirects to `/login` | `profile_screen.dart:322-342`; `auth_controller.dart:76-85` |
| 13.10 | *(absent)* **Subscription** | Deliberately absent, not disabled (adr-049 §3 / D-007) | `profile_screen.dart:241-242` |
| 13.11 | *(absent)* **Delete account** | **There is no such row anywhere in the app.** No route, no repository method, no `SecureStorage.clear()` caller | FE-03; API-01 |
| 14 | Edit Profile (`/profile/edit`) | Real `PATCH /me`. Avatar sheet offers **"Upload photo"** as a **disabled** row with **"Uploading your own photo isn't available yet."** beside a working catalogue picker | `avatar_sheets.dart:134-139`; `app_en.arb` `uploadPhotoUnavailable` |
| 15 | `/settings`, top→bottom | **Languages** (segmented English/العربية — works, client-only) · **Mode** (Light/Dark — works, client-only; **`ThemeMode.system` is deliberately not offered**, so a reviewer toggling the phone into dark mode sees no change at all) · **Rank** (two real `PATCH /me` switches: "Show me on the leaderboard", "Hide my points") · **Notification Preferences**: four switches — *Announcements, Promotions, Support, System* — **all rendered ON and all disabled**, with the caption **"Notification settings aren't available yet."** The app ships **no** push capability at all (no Firebase, no `UIBackgroundModes`, no entitlements — ARTEFACT) | `settings_screen.dart:41-74, 107-…, 317-395`; parts/02 |
| 16 | Logout → back to `/` | **Onboarding is shown again**, because there is no "seen" flag: auth state is the only gate | `app_router.dart:56-64`; parts/10 §5 |

**Apple verdict on S2:** the *functional* blockers are gone but the *completeness* ones are not.
Two of five primary navigation tabs say "Coming soon" (POL-09 calls a top-level tab that says this
"the most reviewer-visible completeness failure there is"), the privacy policy and terms are
unpublished stubs while the pre-login links point at a reserved TLD (5.1.1(i)), there is no account
deletion path (5.1.1(v)), the icon is the SDK template (2.3.8 / 4.0), and the "Subscription
Required" sheet invites the 3.1.1 conversation with no answer in the app (POL-01).

---

### 1C. Google Play reviewer + Robo crawler — Pixel — **S1**

The Android S1 artefact exists and was inspected (parts/02), so this leg is firmer.

| # | Step | What happens | Evidence |
|---|---|---|---|
| 0 | Install | Launcher icon is the **stock Flutter icon at all five densities** (md5-identical to the SDK template), **no adaptive icon** (`mipmap-anydpi-v26` absent) and **no monochrome layer**, so Android 13 themed icons fall back. Label is **`level_up_app`** — identical in all 80+ locale rows of the APK, including `ar` | AND-03, AND-04, parts/02 |
| 1 | Launch | Arabic RTL, light theme, regardless of device language or dark-mode setting (REV-02, REV-27) | `locale_provider.dart:23-24`; `theme_provider.dart:37-38` |
| 2 | Onboarding → Login | Same as §1A steps 2–8 | — |
| 3 | Any request | **"You are offline"** on a live network | REV-01 |
| 4 | **Robo crawler** | Robo is a blind DFS over clickable views. It will: tap the language pill (flipping the whole app's language mid-crawl, possibly repeatedly), tap "Get Started"/"Log In" into `/login`, type junk into the phone field, tap **"Send OTP"** and **"Create New Account"** repeatedly against `TBD.example`, and follow the three legal links **out of the app into Chrome**, from which it cannot return. It can reach nothing else, because everything else is behind `authRedirect` | `app_router.dart:71-79`; `login_screen.dart:117-118` |
| 5 | Pre-launch report | Screenshots of Onboarding and Login only; no crash (the failures are handled); the report will look like a 2-screen app | PROJECTION |
| 6 | Upload | **Blocked before any of this**: the artefact is **unsigned** (`apksigner verify` → `DOES NOT VERIFY / Missing META-INF/MANIFEST.MF`), and there is no upload keystore | AND-02, parts/02 ARTEFACT |

**Play verdict on S1:** cannot be uploaded (no signing). If signed, App access instructions could
not be honoured — "provide reusable login credentials" is impossible against a placeholder host —
so rejection under App access (15748846), plus the listing cannot even be published without a
512×512 icon and a 1024×500 feature graphic (POL-10 — a hard gate, not a judgement call).

---

### 1D. Google Play reviewer + Robo crawler — Pixel — **S2**

Human path: identical to §1B steps 6–16. The Play-specific deltas:

| # | Item | What happens | Evidence |
|---|---|---|---|
| 1 | **Robo crawler vs device binding** | Robo runs on a **device farm, concurrently with human review**. The contract binds one session per account: a verify on a second device evicts the first with `session_superseded`, and the app force-logs-out and shows **"You've been signed out — your account was used on another device."** With one credential, the human reviewer and the crawler will knock each other out repeatedly | `openapi.yaml:56-60, 180-181, 401-403`; `auth_interceptor.dart:131, 148-150`; `login_screen.dart:66`; POL-03 §3, POL-12(10b) |
| 2 | **Robo vs per-IP OTP throttle** | A farm behind one egress IP hammering "Send OTP" hits the per-identifier/device/**IP** limit and the 5-failed-verify 15-minute lock. Magnitudes are unknown (part 05 Q13) | `openapi.yaml:86-88, 169` |
| 3 | **Robo vs `/reference/*` throttle** | The registration wizard fires **seven** reference endpoints (countries, governorates, cities, schools, education systems, universities/faculties/years). `/reference/*` carries its own **per-IP** limit. A crawler looping the wizard will trip it and see the rate-limit copy **"Too many requests. Please try again shortly."** | `openapi.yaml:443`; `registration_error_copy.dart:44-49` |
| 4 | **Robo vs FLAG_SECURE** | If the crawler reaches `/quiz/:quizId` or the review screen, `FLAG_SECURE` is set and the pre-launch report's screenshots for those screens come out **black**. This looks like a rendering crash unless the App-access note says otherwise (paste-able text: parts/12 POL-03 "Paste-able Play instructions", "KNOWN BEHAVIOUR, NOT A CRASH" paragraph) | `ScreenProtectorPlugin.kt:27-30`; AND-13; parts/10 §3 |
| 5 | **Robo vs the logout dialog** | Robo will find Account → **Logout** → **Logout** and sign itself out, then loop back through Onboarding/Login. Expect a shallow, repetitive crawl graph | `profile_screen.dart:322-342` |
| 6 | **Robo vs the external legal links** | Three `LaunchMode.externalApplication` links leave the app for Chrome with no return path — a known Robo dead end | `login_screen.dart:117-118` |
| 7 | **Predictive back (Android 16)** | `android:enableOnBackInvokedCallback` is **not declared**, target is SDK 36, and the app uses `PopScope` in 3 places. Back behaviour differs between API 33–35 and 36 and has never been device-verified through go_router | AND-09 |
| 8 | **Edge-to-edge (Android 15+)** | Enforced at targetSdk ≥ 35; the app neither opts out nor sets `SystemUiMode`. Inset handling exists but is DEVICE-unverified | AND-10 |
| 9 | **Per-app language / RTL** | `android:supportsRtl` is **absent** (defaults false) and there is no `localeConfig`. Flutter draws RTL itself, so the app looks right, but Android's per-app-language picker never appears and system surfaces stay LTR | AND-11 |
| 10 | **Large-screen / tablet** | No `screenOrientation`, no `resizeableActivity`, no Dart orientation lock. Every frame is a portrait phone design; Android 16 large-screen behaviour is unverified and there is no tablet width cap | AND §2 "Orientation / large screens", FE-17 |

---

### 1E. Registration — NEW number vs pre-registered number

**Pre-registered** (the reviewer account, as POL-03 requirement #2 demands): `verifyOtp` returns
`authenticated`, the reviewer never sees the wizard. **This is the configuration to insist on** —
it is the difference between a 30-second sign-in and the gauntlet below.

**NEW number** — the reviewer is put through a four-screen wizard on a **10-minute clock**:

| Step | Route | Mandatory fields | Can a reviewer plausibly complete it? |
|---|---|---|---|
| 1 | `/register` Sign-up identity | **Full Name** ("Your full name"), **Parent's Number** (behind its own `+20` chip), *Referral Code (Optional)* — collected and **never sent**; the proven phone is shown read-only | Name yes. **Parent's Number is mandatory with no explanation anywhere in the wizard** — a reviewer has no parent to supply and will type their own number or garbage. No consent text, no purpose string. (FE-15, API-09, POL-05) |
| 2 | `/register/track` | **Track**: "School Student" / "University Student" | Yes — two cards, Continue |
| 3a | `/register/school` | **Date of Birth**, **Country**, **Governorate** (required only when the country row says `requiresGovernorate`, i.e. Egypt), **City** (`cityId` *or* free-text `cityName`), **Education System**, **Grade**; **School Name is never required** (adr-028 §2) | Only if the reference lists load. DOB picker opens on the **year grid**, default 15 years back, range today → 100 years back, **no age floor of any kind** |
| 3b | `/register/university` | **Date of Birth**, **University Name**, **Faculty**, **Academic Year**, **Governorate**, **City** — all unconditionally required, cascading university → faculty → year | Same dependency on reference lists; the cascade means four sequential picker loads |
| 4 | Submit | `POST /auth/register` → tokens → `/home` | — |

**Do the reference lists load?** Each picker is its own provider with its own network call
(`countriesProvider`, `governoratesProvider(country)`, `citiesProvider((gov, …))`,
`educationSystemsProvider`, `universitiesProvider`, faculties, study years). In **S1 every one of
them fails** and each picker renders its own error row with a Retry that re-invalidates the
provider (`school_detail_screen.dart:137-253`, `university_detail_screen.dart:128-256`) — the form
is completable in *shape* and submittable in *never*. In **S2 they load**, but they are the
throttle surface in §1D item 3.

**The 10-minute trap (REV-11).** The `registrationToken` TTL is 10 minutes and the draft carries its
own deadline: `RegistrationDraft.isExpired => DateTime.now().isAfter(tokenExpiresAt)`
(`registration_draft.dart:65-67`). A reviewer who reads carefully, opens the DOB year grid, hunts a
governorate and then a city, and pauses to think about why a parent's phone is demanded, can
plausibly exceed it — and then gets `RegistrationExpiredView`: a timer icon, **"Your registration
session expired. Please start again."**, and one button **"Back to login"**, with the draft reset
(`registration_expired_view.dart:36-49`). Everything typed is gone. The draft is also **pure
in-memory Riverpod state with no persistence and no `restorationId` anywhere in `lib/`**, so a
process kill mid-wizard — or backgrounding to read the legal link — loses it the same way
(parts/10 §4).

---

## 2. Dead ends, placeholders and stubs a reviewer reaches

Ordered as a reviewer would meet them: bottom tabs left→right, then Profile rows top→bottom, then
Settings. "Copy" is the exact EN ARB value; the AR value exists for every key listed.

| # | Dead end / placeholder | Route | EN key → text | What a reviewer concludes | Guideline risk | Fix type | Effort |
|---|---|---|---|---|---|---|---|
| REV-05a | **Leaderboard tab** — whole tab is a placeholder | `/leaderboard` | `navLeaderboard` "Leaderboard" + `comingSoon` **"Coming soon"** | "Two of five tabs are unbuilt — this app isn't finished" | Apple 2.1 / 4.2; Play "designed to do nothing" (POL-09) | **hide** (drop to 3–4 tabs) or **finish** (ship the built `LeaderboardScreen` after D-008's audit, then POL-06 report/block) | S to hide · **L** to finish (audit + moderation + IARC re-run) |
| REV-05b/06 | **Message tab** — placeholder, and the *name* implies chat | `/message` | `navMessage` **"Message"** + `comingSoon` **"Coming soon"** | "There's a messaging feature — where's the moderation? Does Child Safety Standards apply?" | POL-09 + **POL-12(10a)**; Play Child Safety Standards question on a 13–17 product | **hide** (remove the branch) | **S** — one branch deleted; POL-12 calls it "the cheapest high-value change in this report after the icon set" |
| REV-07a | **Home "Coming soon" cards ×3** (Daily Tasks, Continue Learning, Top Student; +Learning Tools on University) | `/home` | `comingSoon` **"Coming soon"** ×3–4 | "The first screen after login is mostly roadmap" | Apple 2.1; Play 2.3 accuracy (POL-09) | **hide** — keep at most one for release 1 | **S** — delete the section calls |
| REV-07b | **"See All" is inert and gives no feedback** — a bare `Text`, not a button | `/home` | `seeAll` **"See All"** | "The control is broken" (worse than disabled: no ripple, no hint) | POL-09 "an inert control is worse than no control" | **hide** — remove the label | **S** |
| REV-08a | **Favorite questions** row disabled | `/account` | `profileFavoriteQuestions` "Favorite questions" + `profileRowUnavailable` **"Not available yet"** | Acceptable — honest, secondary, states it before the tap | POL-09 "may ship with honest copy" | **copy** (keep) | S |
| REV-08b | **Your progress** row disabled | `/account` | `profileYourProgress` "Your progress" + **"Not available yet"** | Acceptable | POL-09 | **copy** (keep) | S |
| REV-08c | **Refer a Friend** → a screen whose only content is a sentence + a disabled button | `/refer` | `referUnavailable` **"Inviting friends isn't available yet."** + `shareInvite` "Share invite" (disabled) | "They shipped an empty screen" | POL-09: a screen whose only content is unavailability should be a disabled *row* instead | **hide** the route, **copy** the row to a disabled subtitle | **S** |
| REV-08d | **Customer Support** → empty screen + disabled "Create Ticket" | `/support` | `supportUnavailable` **"Support isn't available yet."** + `createTicket` "Create Ticket" (disabled) | "There is no way to contact this developer" — and both stores *require* a working support contact | POL-09 ("**Support is the exception: make it real**"); Apple ASC Support URL (address+email+phone); Play listing contact | **finish** — point the row at `mailto:[SUPPORT_EMAIL]` or the hosted support page | **S** (one `launchUrl`), gated on product supplying the address |
| REV-04a | **Privacy & policy** → unpublished stub | `/legal/privacy` | `legalNotPublished` **"This document hasn't been published yet."** | "There is no privacy policy" | **Apple 5.1.1(i)**, Play User Data (POL-04, POL-12(10c)) | **finish** (hosted URL + in-app render) **and** un-auth-gate the route | **L** — copy is legal work, not engineering |
| REV-04b | **Terms & Conditions** → the identical stub | `/legal/terms` | same sentence, title `profileTermsConditions` "Terms & Conditions" | "Two rows, one empty page" | Apple 2.3 accuracy | **finish** | **L** (same copy dependency) |
| REV-04c | **Pre-login legal links point at a reserved TLD** | `/login` | `legalPrefix` **"By continuing, you agree to our"** + "User Agreement", "Privacy Policy", "Cookie Policy" | "The policy link is dead" — and this is the *only* pre-login policy affordance | Apple 5.1.1(i); Play User Data | **finish** (real URLs) — three constants at `login_screen.dart:43-46` | **S** once URLs exist |
| REV-21 | **Go to University** dialog with a disabled Confirm | `/account` (modal) | `goToUniTitle` "Go to Uni" / `goToUniBody` **"Are you sure you want to convert to the University track?"** / `goToUniWarning` **"You can't go back again."** / `goToUniUnavailable` **"Switching tracks isn't available yet."** | "A destructive, irreversible confirmation that can't be confirmed" — the warning copy makes it read worse than a disabled row would | POL-09 | **hide** the row for release 1 | **S** |
| REV-09 | **Four notification toggles, rendered ON, all disabled** | `/settings` | `notifAnnouncements`/`notifPromotions`/`notifSupport`/`notifSystem` + `settingsNotificationsUnavailable` **"Notification settings aren't available yet."** | "Switches shown ON that control nothing, promising push the binary cannot deliver" | Apple 2.3 metadata accuracy; POL-09 "hide the section until push lands"; POL-12(5) | **hide** the whole section | **S** |
| REV-10 | **Upload photo** row disabled in the avatar sheet | `/profile/edit` | `uploadPhoto` + `uploadPhotoUnavailable` **"Uploading your own photo isn't available yet."** | Minor; the catalogue picker beside it works | POL-09 "remove the entry" | **hide** | **S** |
| REV-13 | **Referral Code (Optional)** — a visible input that is never transmitted | `/register` | `referralCodeOptional` **"Referral Code (Optional)"**, hint `referralCodeHint` "Enter code" | "A field that does nothing" | Play Deceptive Behavior "do not accurately describe their functionality"; Apple 2.1 (POL-09, POL-12(7)) | **hide** — remove the field, keep the draft plumbing | **S** |
| REV-23 | **No account-deletion path anywhere** | — | *(no copy — the feature is absent)* | "There's no way to delete my account" | **Apple 5.1.1(v)**; **Play account deletion 13327111** (POL-04) | **finish** — entry row, confirm screen carrying the contract's mandated 7 points, cancel screen, global 403 redirect, `SecureStorage.clear()` | **M–L** (contract copy uses "paid"/"refund", which collides with adr-171's banned vocabulary — POL-12 disagreement #4, needs Seif + owner sign-off) |
| REV-24 | **`403 account_pending_deletion` tells the user to cancel, with nothing to tap** | any catalog/mistakes/leaderboard route | `accountPendingDeletion` **"Your account is scheduled for deletion. Cancel the request to use Level Up again."**, Retry deliberately withheld | "The app knows about a screen it doesn't have" | POL-04 | **finish** (same work as REV-23) | folded into REV-23 |
| REV-25 | **Subscription-required sheet with no route to entitlement** | quiz setup | `subscriptionRequiredTitle` **"Subscription Required"** / `subscriptionRequiredBody` **"This lesson needs an active subscription."** / "Not now" | "How does a user subscribe? Is this an IAP that should be Apple's?" | **Apple 3.1.1 / 3.1.3** (POL-01 — C at HEAD); Play consumption-only (POL-02) | **copy** (App Review Notes §3, already drafted in parts/12 POL-03) — *not* a code change; the owner decides the adr-171 link separately | **S** in the app · **owner decision** is the real cost |
| REV-26 | **`/track-select` placeholder with a hardcoded English app-bar title** | `/track-select` | literal `'Track select'` (not localized) + `comingSoon` | Only reachable by a hand-typed path, but it is a live route with a developer label | POL-09 "delete or `kDebugMode`-gate — zero cost" | **hide** | **S** |
| REV-26b | **`/friends` orphan route** | `/friends` | `friendsUnavailable` **"Friends aren't available yet."** | Same | POL-09 | **hide** | **S** |
| REV-18 | **No `errorBuilder`** → go_router's built-in, un-localized error page | any unmatched path | *(hardcoded English, outside `AppLocalizations`)* | "The error screen isn't even in the app's language" | Apple 2.1; breaks the project's own loading/empty/error/offline × AR/EN rule | **finish** — one `errorBuilder:` + a small localized screen | **S** |
| REV-20 | **Onboarding replays on every signed-out cold start, including right after logout** | `/` | onboarding copy | Mild: "the app forgot I'd seen this" | None — documented design choice | **copy**/none for release 1 | S |
| REV-19 | **Unseeded cohort → the Learn tab is one line** | `/learn` | `noSubjects` **"No subjects yet"** | "The app has no content" — the single worst S2 outcome if seeding is skipped | Apple 2.1 | **finish** (backend seeding, POL-03 requirement #4) | **E** (backend) |
| REV-17 | **Stock Flutter icon + `level_up_app` label** | — | label `level_up_app` (unlocalized, all 80+ locale rows) | "Placeholder submission" | Apple 2.3.8 / 4.0; **Play listing assets are a hard publish gate** (POL-10) | **finish** — brand icon sets both platforms, `strings.xml` + `values-ar`, one brand string across `CFBundleDisplayName`/`CFBundleName`/label/ARB | **M** (design-dependent) |
| REV-02 | **Arabic-first regardless of device locale**; iOS bundle declares `en` only | all | — | "The app is in a language the listing doesn't mention" | Apple 2.3 metadata accuracy (new — see §6) | **copy** (declare AR in the listing + `CFBundleLocalizations`) *or* **finish** (respect `Platform.localeName` on first launch) | **S** either way |
| REV-27 | **`ThemeMode.system` not offered** — dark mode only via Settings | `/settings` | `settingsMode` "Mode" | "The app ignores my system dark mode" | None (documented owner choice) | **copy**/none | S |
| REV-03 | **When `GET /me` fails, Settings, both legal screens and Logout are all unreachable** | `/account` | `genericError` **"Something went wrong"** + `retry` "Retry" (or `offline` **"You are offline"**) | "I can't sign out and I can't find the privacy policy" — a 5.1.1(i) failure *created by an error state* | Apple 5.1.1(i)/(v); POL-04 | **finish** — render the static menu rows (Settings/legal/Logout) outside the `/me` state machine, as Settings already does for its own client-only sections | **S–M** |
| REV-01 | **`https://TBD.example/api/v1` ships; every screen says "You are offline" on a live network** | all | `offline` **"You are offline"** | "The app is dead, and its error copy is wrong" | Apple 2.1 ("turn on your back-end service"); Play App access | **finish** — real URL + a guard that fails the release build while `.example` remains | **E→S** (backend publishes the host; the app change is one line + one guard) |

---

## 3. Cross-platform differences a submission team must handle separately

| Dimension | iOS | Android | Consequence for submission |
|---|---|---|---|
| **App identity** | Bundle id `com.levelup.levelUpApp`; App ID **not yet registered** and **irreversible after first upload** | `applicationId`/namespace `com.levelup.level_up_app` | Two identities to track forever (IOS-17). Neither string may appear in user-facing copy (POL-12(6)). Register the Apple App ID **before** anything else iOS |
| **Display name** | `CFBundleDisplayName` "Level Up App", `CFBundleName` `level_up_app` | `android:label="level_up_app"` hardcoded, **unlocalized**, ships identically in all 80+ locale rows | Three brand strings against ARB "Level Up"/"ليفل أب". Android needs `res/values/strings.xml` + `values-ar/strings.xml`; iOS needs `ar.lproj/InfoPlist.strings` if an Arabic name is wanted (AND-04, IOS-07, IOS-11) |
| **Icons** | 15 PNGs md5-identical to `flutter_template_images-5.0.0`; LaunchImage is the 1×1 transparent stub; iOS 18 dark/tinted variants absent | 5 densities md5-identical to the SDK template; **no** `mipmap-anydpi-v26` → no adaptive icon, no monochrome layer | Two separate icon pipelines. Play additionally needs a **512×512 listing icon + 1024×500 feature graphic to publish at all** (POL-10) |
| **Locales declared** | `knownRegions` = `en`/`Base`, single `Base.lproj`, **no `CFBundleLocalizations`** → App Store lists "English" only; iOS per-app language switcher never appears | `android:supportsRtl` **absent**, no `localeConfig` → no per-app language picker; system surfaces stay LTR | The app is **Arabic by default** on both (REV-02). Both declarations are wrong today and in opposite ways |
| **Orientation** | `Info.plist:31-43` — iPhone P/LL/LR, **iPad all four**; `UIRequiresFullScreen` absent → Split View expected to work | No `screenOrientation`, no `resizeableActivity`, `configChanges` includes orientation → fully resizable | **iPad review runs landscape** and every frame is a portrait phone design with hand-rolled headers; Android 16 large-screen behaviour is likewise unverified. No Dart `setPreferredOrientations` anywhere (FE-17). Decide: lock portrait on phones, or actually test both |
| **Screenshot protection** | ScreenProtectorKit secure-layer technique; the native side **always returns `true`**; Apple DTS has objected to the isSecureTextEntry approach (parts/08 2.5.1) and POL-08 recommends **dropping the iOS leg**; ScreenProtectorKit ships **no** PrivacyInfo and has an open iOS 26 launch-crash report (IOS-19) | `FLAG_SECURE`, real and reliable (`ScreenProtectorPlugin.kt:27-30`) | Different semantics, different risk. On Android it makes pre-launch screenshots **black** (say so in App access). On iOS it may be a 2.5.1 objection *and* a crash risk — POL-08 says drop it |
| **Credential persistence** | Keychain `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`, `synchronizable:false` — **survives app deletion**. Uninstall→reinstall on the same iPhone resumes the previous student's session and `device_id` | flutter_secure_storage 10.x encrypted prefs + `allowBackup=false`, `fullBackupContent=false`, `dataExtractionRules` excluding everything — wiped on uninstall | A reviewer who deletes and reinstalls on iOS lands **already signed in as the previous tester** (IOS-06). It also makes the contract's "deviceId regenerated on reinstall" a **false statement on iOS**, which matters for declaration accuracy (POL-12) |
| **Privacy declaration** | Privacy **manifest** in the binary (`PrivacyInfo.xcprivacy`) + ASC nutrition labels. `device_info_plus` 13.2.0 reads `NSFileSystemFreeSize`/`Size` with an **empty** `NSPrivacyAccessedAPITypes` → **ITMS-91053** at upload; no app-level manifest exists either | Play **Data safety** form, filled in the console, no binary artefact. The **web deletion URL is submitted inside that form** — it is a publish gate | The iOS problem is caught by a machine at upload; the Play problem is caught by a human at review. POL-07 rates it B, part 04 rates it "A likely" — plan for blocking |
| **Signing** | No `DEVELOPMENT_TEAM`, no `ExportOptions.plist`, `docs/RELEASE_SIGNING.md` is **Android-only** | No `key.properties`, no keystore; release output is **unsigned** and fail-closed (ARTEFACT) | Two independent signing workstreams. Play also needs App Signing enrolment (upload key only) |
| **Build machine** | **macOS + Xcode 26 required, and has never been run.** First build will `pod install`, may go SwiftPM-hybrid (IOS-20), and will **rewrite two tracked files** via UIScene auto-migration (IOS-05) | Builds on the current Windows box; APK+AAB already produced from HEAD | The iOS leg is not "a build away" — it is a build that will *change the repo* and whose output has never been validated by Apple tooling |
| **CI** | Nothing | Builds an **APK only**, uploads no artefact, injects no signing; Play needs an AAB | Add an `appbundle` job with secret-injected signing (AND-07) |
| **Export compliance** | `ITSAppUsesNonExemptEncryption` **absent** → every upload prompts | n/a | One `<false/>` line; do it (IOS-04, POL-12(2)) |
| **Store-listing hygiene** | **2.3.10**: iOS screenshots must be captured on iOS; no Android chrome, no Play badge, no "Android" in description/keywords | n/a | A process rule for whoever produces the listing assets (POL-12(6)) |

---

## 4. Concurrency and environment hazards during the review window

| # | Hazard | Mechanism | Mitigation |
|---|---|---|---|
| REV-15 | **Device binding evicts concurrent reviewers** | One session per account by contract: a verify on a second device revokes the first, and the next call anywhere returns `session_superseded` → `forceLogout` → `/login` with **"You've been signed out — your account was used on another device."** (`auth_interceptor.dart:131,148-150`; `openapi.yaml:56-60,180-181,401-403`) | Ask Seif for **≥3** production-whitelisted numbers sharing one fixed OTP, or a relaxed binding rule for the whitelisted cohort (parts/12 POL-03 §3). Assign one number to the Robo/pre-launch device, one to manual review, one spare |
| REV-15b | **Play's Robo crawler runs on a device farm *concurrently* with human review** | Same mechanism, but automated and relentless | The Play instructions in parts/12 POL-03 already carry a "pre-launch / Robo" line with its own number — use it |
| REV-12b | **Per-IP OTP throttle behind one NAT** | `429 otp_throttled` is per-identifier/device/**IP**; 5 failed verifies → 15-minute lock (`openapi.yaml:86-88,169`). Magnitudes unknown (part 05 Q13) | Exempt the whitelisted cohort from the per-IP limit, or raise it materially. Note `otp_throttled` declares **no `Retry-After`** — timing comes only from the `202` body, so the app cannot show a countdown |
| REV-12c | **Per-IP `/reference/*` throttle** | Seven reference calls per registration attempt, per-IP limited (`openapi.yaml:443`). A crawler looping the wizard trips it; the pickers then show **"Too many requests. Please try again shortly."** | Same exemption request; and a **pre-registered** reviewer account avoids the wizard entirely |
| REV-29 | **Backend availability across the whole review window** | Apple's window can be days and can re-open on appeal; Play re-reviews on every update. Apple's own field reference states **"Account must not expire"** | Treat the production backend and the reviewer cohort as a **standing** commitment, not a one-off. Diarise a re-check at every submission; ≥12-month validity if an expiry is unavoidable (parts/12 POL-03 requirement #5) |
| REV-30 | **TestFlight vs App Review are different builds with different friction** | Every TestFlight upload prompts for export compliance while `ITSAppUsesNonExemptEncryption` is absent (IOS-04); both go through the same ITMS validation, so **ITMS-91053 will bite on the first TestFlight upload too**, not just at submission | Add the plist key and fix the privacy manifest **before** the first upload of any kind |
| REV-31 | **Play internal testing + the 12×14 rule** | Personal developer accounts created after Nov 2023 must run a closed test with **≥12 testers for 14 continuous days** before production access (14151465). Developer verification deadline is 30 Sep 2026 (part 09) | An **account-type and calendar** dependency that can add two weeks to the critical path on its own. Confirm the account type **now** |
| REV-16 | **Pre-launch report shows black quiz screenshots** | `FLAG_SECURE` on `QuizScreen` and `QuizReviewScreen` | Covered verbatim by the "KNOWN BEHAVIOUR, NOT A CRASH" paragraph of the paste-able Play text in **parts/12 POL-03**. Do not duplicate it — paste it |
| REV-32 | **Reviewer notes, per store** | Apple wants App Review Notes ≤4000 bytes; Play wants "Any other instructions" **in English** under App access | Both texts are already drafted with placeholders in **parts/12 POL-03** ("Paste-able App Review Notes" and "Paste-able Play *Any other instructions*"). Fill the brackets; have the owner sign off §3 of the Apple text (it is a business statement). **Do not put the redemption URL in Apple's notes** — 3.1.1(a) covers metadata |
| REV-33 | **The reviewer's own device state** | On iOS, Keychain survives uninstall (IOS-06): a reviewer who reinstalls resumes the previous tester's session; combined with device binding, that stale session may also have been superseded, producing an immediate forced logout on launch | Another reason for multiple numbers, and a reason to fix IOS-06 (first-run `SecureStorage.clear()` keyed off a `shared_preferences` flag, which *is* wiped on uninstall) |

---

## 5. Submission critical path (dependency-ordered)

Owners: **BE** = backend (Seif) · **FE** = frontend · **PR** = product/legal/design · **CO** = console/owner.
`∥` marks work that can run in parallel with its neighbours.

```
                 ┌─ 3  Legal URLs (PR) ──┐
 1 Prod URL (BE) ┼─ 4  Reviewer cohort ──┼─ 8 Declarations (CO) ─ 11 Submit iOS
      │          └─ 5  Icons/label (PR) ─┘        │
      │                                            └─ 12 Submit Play
      └─ 2 Ship URL + guard (FE) ─ 6 Deletion (FE) ─ 7 Stub cull (FE)
                                   9 iOS build (CO/FE) ─ 10 Listing assets (PR/CO)
```

| # | Step | Owner | Blocked by | Blocks | Parallel? |
|---|---|---|---|---|---|
| 1 | **Publish the production base URL + TLS/HSTS** | **BE** | — | everything testable | — |
| 2 | Replace `app_config.dart:54`; add a guard that fails a release build while `.example` remains | **FE** | 1 | any reviewable build | — |
| 3 | **Hosted privacy policy, terms, support and web-deletion URLs**; replace `login_screen.dart:43-46`; **take `/legal/*` out of the auth gate** (`app_router.dart:49`) and render the real copy | **PR** → **FE** | — (copy work can start today) | 6, 8, both submissions | **∥ with 1, 4, 5** — start immediately, it is the longest-lead item after the backend |
| 4 | **≥3 production reviewer numbers + fixed OTP, already past registration, per-IP exempt, active `baseSubscription`, seeded cohort, no expiry** | **BE** → **CO** | 1 | both reviews | **∥ with 3, 5** |
| 5 | **Brand identity**: icon sets (5 Android densities + adaptive/monochrome + 512 + 1024×500 feature graphic; 15 iOS sizes), launch-screen assets, `strings.xml`+`values-ar`, one brand string across all four places | **PR/design** → **FE** | — | 9, 10, Play publish | **∥ with 1, 3, 4** |
| 6 | **Account deletion**: entry row, confirm screen carrying the contract's mandated points, cancel screen, global `403 account_pending_deletion` redirect, wire `SecureStorage.clear()`; resolve the "paid"/"refund" vocabulary conflict with adr-171 | **FE** + **PR** + **BE** sign-off | 3 (the web-deletion URL is part of the same answer) | 8 (Play Data safety form carries the web URL), both submissions | partly ∥ with 7 |
| 7 | **Stub cull**: remove the Message tab and the Leaderboard placeholder tab, the referral field, the four notification toggles, "See All", Upload photo, `/track-select`, `/friends`, the Go-to-Uni row; make Support real; add `errorBuilder` | **PR** decides, **FE** implements | 3 (Support needs the support address) | both reviews | **∥ with 6** |
| 8 | **Fill the declarations**: Play Data safety (incl. the web-deletion URL), target audience/Families, content rating/IARC, App access (paste parts/12 POL-03), Financial/Health/Gov/News/Ads = none, trader status, territories (recommend excluding the US); Apple nutrition labels, age rating, export compliance, Support URL | **CO** + **BE** (answers to part 05 Q4–Q7) | 3, 4, 6, 7 | both submissions | ∥ across the two stores |
| 9 | **First iOS release build on macOS/Xcode 26**: `pod install`, review the UIScene auto-migration diff, commit `Podfile`/`Podfile.lock`/xcconfigs; add `ITSAppUsesNonExemptEncryption=false` and `CFBundleLocalizations`; **fix ITMS-91053** (drop `device_info_plus` on iOS or add a truthful app-level `PrivacyInfo.xcprivacy`); decide POL-08 (drop the iOS screen-protection leg); register the App ID; set the team; write iOS signing docs | **CO** (Mac) + **FE** | 2, 5 | 11 | **∥ with 10** |
| 10 | **Listing assets**: screenshots captured **on the matching platform** (2.3.10), descriptions, feature graphic | **PR/CO** | 5 | 11, 12 | **∥ with 9** |
| 11 | **Apple submission** — and the owner decision this waits on: whether the adr-171 redemption link ships on iOS at all (POL-01 says it is an Egypt-storefront blocker) | **CO** + **owner** | 2,3,4,6,7,8,9,10 | — | — |
| 12 | **Play submission** — plus upload keystore + Play App Signing, CI `appbundle` job, developer verification, and the 12×14 closed-test clock if the account type requires it | **CO** + DevOps | 2,3,4,6,7,8,10 | — | ∥ with 11 |

**The three things to start today, in parallel:** (1) the Seif ask — prod URL + reviewer cohort,
extended with the multi-number / IP-exemption / seeding detail from parts/12 POL-03; (2) the legal
copy, because it is a writing job with no engineering dependency and it gates four other steps;
(3) the icon set, because Play cannot publish a listing without it and design lead time is real.

---

## 6. What a reviewer would hit that no part lists yet

**REV-02 · B · both · The app ignores the device locale and opens in Arabic, RTL.**
`app.dart:58` passes `locale: ref.watch(localeProvider)` and `LocaleController.build()` returns
`ref.watch(preferencesStoreProvider)?.readLocale() ?? const Locale('ar')`
(`locale_provider.dart:23-24`). `Platform.localeName` / `WidgetsBinding.platformDispatcher.locale`
appear nowhere in `lib/`. On a fresh install on an English-locale review device, **every screen is
Arabic and right-to-left** until the reviewer finds the language pill. This is defensible as a
product choice for an Egyptian audience — but it is **not declared anywhere**, and on iOS the bundle
advertises `en` only (IOS-07), so the listing and the app disagree. Either respect the system locale
on first launch when it is not `ar`, or declare Arabic as the primary language in both listings and
add `CFBundleLocalizations = [ar, en]`. Owner: product + frontend.

**REV-27 · D · both · `ThemeMode.system` is deliberately not offered.** `themeModeProvider` defaults
to `ThemeMode.light` and `app.dart:36` passes the student's explicit choice
(`theme_provider.dart:23, 37-38`). A reviewer who switches the phone to dark mode to test contrast
sees **no change**. Documented owner decision, not a defect — but worth one line in the review notes
so it is not filed as a bug. Owner: none (informational).

**REV-03 · B · both · The error state removes the privacy policy, the terms, Settings and Logout.**
The Profile hub's ten rows live inside `StateWidget.onLoaded` (`profile_screen.dart:75-91`,
`115-152`), and `/settings` has exactly one entry point — row 1 of that menu. When `GET /me` fails,
a signed-in student (or reviewer) has **no in-app route to the privacy policy and no way to sign
out**. Apple 5.1.1(i) does not carve out an exception for "while your API is down". Settings itself
already shows the right pattern — it keeps Languages and Mode live and degrades only the Rank block
(`settings_screen.dart:31-40`) — so the fix is to render the static rows outside the `/me` state
machine. Owner: frontend. **Not listed in parts 01, 10 or 12.**

**REV-14 · C · both · The phone field's country chip is not a picker, and the app does *not*
actually restrict non-Egyptian numbers — which corrects POL-03 §3.** The field draws
`🇪🇬 + "+20" + Icon(Icons.arrow_drop_down)` with **no tap handler on the chevron**
(`login_screen.dart:294-303`; the same inert chevron is on the parent-phone field at
`signup_identity_screen.dart:271`). A reviewer will tap it expecting a country list and get nothing.
Separately, `FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ]'))` permits `+`, and
`Phone.tryParse` treats any input starting with `+` as **complete E.164** and validates it against
the contract pattern (`phone.dart:34-42`). So `+14155550123` **is accepted and sent**, while the UI
still shows "+20" beside it. POL-03 §3 states "the app *does* restrict by location in effect" — at
SOURCE level that is **not true**; the restriction is a default and a visual implication, not a
gate. That makes the Apple 3.2.2(v) exposure *lower* than POL-03 assumed, but creates two new
problems: a misleading inert affordance, and a display that contradicts the value in the field.
Owner: frontend (make the chevron real or remove it) + the POL-03 notes text.

**REV-11 · C · both · The 10-minute registration token is a reviewer trap.** See §1E. Nothing warns
the student that a clock is running; there is no countdown on any wizard screen; the only feedback
is the terminal `RegistrationExpiredView`. A reviewer reading a mandatory parent-phone field
carefully is exactly the user most likely to time out. Owner: product (surface the deadline) +
backend (is 10 minutes the right TTL for a 4-screen wizard with 7 reference loads?).

**REV-07b · C · both · "See All" is a `Text`, not a disabled button.** `coming_soon_section.dart:76-79`
renders the label with no `GestureDetector`, no `InkWell`, no `Semantics(button:)` and no disabled
hint. FE-11 called it "inert"; the sharper point is that it gives **zero feedback of any kind** —
which reads as a broken control rather than an unavailable one. POL-09's own rule ("an inert control
is worse than no control") applies; remove the label. Owner: frontend.

**REV-19 · C · both · With no cohort content seeded, the Learn tab's entire body is "No subjects
yet".** `subjects_screen.dart:70-71` → `emptyMessage: l10n.noSubjects` → `noSubjects` = **"No
subjects yet"** (AR present), rendered as a centred `Icons.inbox_outlined` + one line
(`catalog_states.dart:102`). The deeper levels say **"Nothing here yet"** (`nothingHere`) and
Mistakes says **"No mistakes yet"** (`noMistakes`) — which is the *happy path* there, by design. The
risk is S2 with a half-seeded cohort: the reviewer signs in successfully and still concludes the app
has no content. Seeding is POL-03 requirement #4 and is the difference between "works" and "works
and can be seen to work". Owner: backend.

**REV-06 · B · both · The "Message" tab name, specifically.** POL-12(10a) already says rename or
remove it; this pass adds the exact strings a reviewer reads: EN `navMessage` = **"Message"**, AR =
**"الرسائل"** (plural "the messages"), and the screen behind it is titled with the same string. The
Arabic reads even more like an inbox than the English does. Nothing in the app moderates, reports or
blocks anything (grep: zero report/block UI), and the product is declared for 13–17. **Remove the
branch** — it is one `StatefulShellBranch` at `app_router.dart:264-273` plus one placeholder class.
Owner: product + frontend.

**REV-34 · D · both · The Go-to-Uni dialog is the most alarming disabled control in the app.**
It states an irreversible consequence — **"You can't go back again."** — above a **disabled**
Confirm. A reviewer reads a destructive confirmation the app cannot honour. POL-09 files it under
"may ship with honest copy" as a secondary Profile row; the *dialog* is a step worse than the row.
Hide the row for release 1. Owner: product.

**REV-35 · D · both · The login phone hint is a real-looking Egyptian mobile that also ships in the
binary.** `phoneHint` = `01021871999` in both ARBs, present once in `libapp.so` (ARTEFACT,
parts/02), and identical to the mock backend's test number (`mock_backend.dart:196`). FE-18 raised
it; the reviewer angle is that a hint number is the first thing a reviewer types. If it belongs to a
person, the app publishes it. Replace with an obviously-fake number. Owner: product.

**REV-36 · D · both · Both "Privacy & policy" and "Terms & Conditions" open the *same widget* with
the same sentence.** `LegalDocumentScreen` switches only the title (`legal_document_screen.dart:38-41`).
A reviewer who opens both sees identical pages and will conclude the rows are decorative. Worth
knowing when the copy lands: two rows must produce two documents.

**REV-37 · F · both · Things that will look like defects and are not — put them in the notes.**
(a) The quiz and quiz-review screens go black under capture (FLAG_SECURE / iOS secure layer).
(b) The app is Arabic-first and RTL.
(c) `ThemeMode.system` is not offered.
(d) Onboarding reappears after every logout.
All four are already covered or coverable by the paste-able texts in **parts/12 POL-03** — extend
that Apple §7 / Play "KNOWN BEHAVIOUR" block with (b), (c) and (d) rather than writing new text.

---

## 7. Where this part disagrees with, or sharpens, an earlier one

| # | Earlier claim | This part |
|---|---|---|
| 1 | **POL-03 §3.3**: "the app *does* restrict by location in effect" (Apple 3.2.2(v)) | **Corrected.** `Phone.tryParse` accepts any E.164 typed with a leading `+`, and the formatter permits `+`. The `+20` chip is a default and a visual implication, not a gate (REV-14). The 3.2.2(v) exposure is lower; the inert-chevron and misleading-display problems are new |
| 2 | **FE-11**: "'See All' is inert" | **Sharpened.** It is not a disabled button — it is a bare `Text` with no handler, no ripple and no semantics, i.e. zero feedback (REV-07b) |
| 3 | **FE-10 / POL-09** treat the two placeholder tabs as equivalent | **Sharpened.** Hiding Leaderboard is cheap; *finishing* it is L-effort and drags in POL-06 moderation and a **content-rating re-run** (POL-12(9)). Hiding Message is S-effort and removes a Child Safety Standards question outright. They are not the same decision |
| 4 | Parts 01/10/12 treat the legal-policy problem as "URLs + copy + un-auth-gate" | **Extended.** Even with all three fixed, an error state on `GET /me` still removes the in-app privacy policy, the terms, Settings and Logout for a signed-in user (REV-03) |
| 5 | No part states the app's launch language | **New.** Arabic, always, regardless of device locale — while the iOS bundle declares English only (REV-02, REV-28) |

---

## 8. Could not determine (SOURCE-only, Windows host, no device)

- Every runtime claim in §1 is a **PROJECTION**. Nothing here was run on a device or simulator.
- Whether `.example` fails as NXDOMAIN or is intercepted by a captive portal / ISP wildcard on the
  reviewer's network — which would change "You are offline" into something else. DEVICE.
- Whether `launchUrl` to a reserved TLD throws (unawaited, `login_screen.dart:118`) or opens a
  browser error page. DEVICE, per platform.
- Whether Robo actually reaches the quiz screens in S2 (it must get past OTP, which it cannot type
  unless the fixed code is in the App-access instructions — which it will be). DEVICE/CONSOLE.
- iPad landscape and Android tablet rendering of any screen. DEVICE.
- Android 15/16 edge-to-edge and predictive back through go_router. DEVICE.
- Whether an Arabic-Indic numeral keyboard reaches the OTP `Pinput` on a real Egyptian-locale device
  (parts/10 §3′). DEVICE.
- Play account type and the 12×14 applicability; ASC team, App ID availability. CONSOLE.
- Everything iOS: no Podfile, no Pods, no IPA, no archive Privacy Report (IOS-01, part 04 §6).
