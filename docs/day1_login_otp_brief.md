# Day 1 Brief — Login (phone entry) → OTP verify

> Paste this into Claude Code, in the `level_up_app` repo, on branch `dev`.
> It is self-contained: Figma frames, exact contract sections, tokens, files, and
> acceptance checks. Build **only** what's here; do not invent shapes.

## Skills to invoke (in this order)

1. `level-up-domain` — glossary + operating rules (server-authoritative, minors' data, glossary verbatim)
2. `build-screen` — the gather → plan → build loop
3. `seif-api-contract` — models/repo/Dio against `contract/openapi.yaml` (vendored, pinned commit 23f0535)
4. `figma-frame` — tokens from Figma, never eyeballed
5. `river` — Riverpod `AsyncNotifier` for both screens (NOT Bloc — this isn't the quiz)
6. `screen-states` — final DoD pass (loading/empty/error/offline × AR/EN)

## Feature location

`lib/features/auth/` → `models/`, `repository/`, `notifier/`, `screens/`
(Core infra already exists: `ScreenState`, `StateWidget`, `DioClient`, `SecureStorage`,
`AppException`, `app_router.dart`, `AppTheme`, `core_providers.dart`.)

---

## ⚠️ CONFLICTS — contract wins, resolve before coding

1. **OTP length: build 6 digits, NOT 4.** The Figma OTP frames draw **4** input boxes and say
   "Enter the 4-digit verification code." The contract mandates **6**
   (`otp/verify.code: minLength 6, maxLength 6`). Server is authoritative → build **6 boxes**.
   Log a design-change note to the designer; do not build 4.
2. **OTP copy: neutral "verification code".** Frame `82:1171` says "reactivation code" — that's the
   recovery variant's wording. For login OTP use a neutral, localized "verification code" string.
3. **Phone country code: use `+20` (Egypt), not `+02`.** The Figma shows "+02" — a design typo.
   Phone is submitted as **E.164** (`^\+[1-9][0-9]{7,14}$`, e.g. `+201001234567`).
4. **Dark mode is a different palette, not inverted light** (confirmed from dark Login `337:15652`).
   The primary accent FLIPS: green `#384f47` (light) → **purple `#ae87e7`** (dark). Legal links flip
   orange `#e67e22` → purple. Both palettes are already wired in `core/theme/app_colors.dart`
   (`AppColors.light` / `AppColors.dark`) + `app_theme.dart`. Use them — do not re-derive.

---

## SCREEN 1 — Login (phone entry)

**Figma:** node `82:819` ("Log in") — `figma.com/design/P6044i0giD9TmdQ7C2AmLq?node-id=82-819`
Pull it yourself with the Figma MCP for pixel detail.

**Layout (top → bottom):**
- Status bar (system — ignore)
- Language toggle pill, top-right: globe icon + "EN". Border `#4b675e`, bg `#fcfbf9`, pill radius. Toggles AR/EN.
- Bird logo (vector) + "Welcome back" — Inter Bold 36, black, centered
- "Enter your phone number to continue" — Inter Bold 20, `#0e0e0e`
- "Phone Number" label — Inter Medium 18, `#2c2c2c`
- Phone field: bg `#fdfdfd`, border `#d1d1d1` 1.17px, radius 20, height 60. EG flag + `+20` (Tajawal Bold, `#2a2a2a`) + dropdown caret + placeholder `01021871999` (`#696969`, 18)
- **Send OTP** button: bg `#384f47`, radius 20, height 60, text `#fcfbf9` Inter SemiBold 22, subtle drop shadow
- "OR" — 14, centered
- **Create New Account** button: bg `#fcfbf9`, border `#384f47` 0.5px, radius 20, height 60, text `#0e0e0e` 22 → routes to `/register`
- Legal line: `#384f47` 14, with `#e67e22` links (User Agreement / Privacy Policy / Cookie Policy) → open externally via `url_launcher`

**Endpoint — `POST /auth/otp/request`** (stable, no auth):
```
Request:  { "phone": "+20..." }              # E.164
200/202:  { "resendAfterSeconds": 60, "expiresInSeconds": 300 }
400:      ProblemDetails code=validation_failed   (malformed phone)
429:      ProblemDetails code=otp_throttled        (cooldown / rate limit)
```

**Behavior:**
- **Always navigate to the OTP screen on 202** — response is 202 whether or not an account exists
  (anti-enumeration). Do NOT branch on existence here; the fork happens at verify.
- Pass `phone`, `resendAfterSeconds`, `expiresInSeconds` to the OTP screen.
- Validate E.164 client-side before calling; map `validation_failed`/`otp_throttled` to localized copy.

**Files:**
- `models/phone.dart` — value type + E.164 validation (freezed optional; a small class is fine)
- `repository/auth_repository.dart` — `requestOtp(String phone)` via `dioProvider`; throws typed `AppException`
- `notifier/login_notifier.dart` — `AsyncNotifier`; `sendOtp()` → returns/holds the OTP params
- `screens/login_screen.dart` — renders via `StateWidget`; button shows loading; error inline

---

## SCREEN 2 — OTP verify

**Figma:** entry `82:1171`, success `155:786`, **error components** `82:1170` (light) / `337:19271` (dark).
Error state = red/pink box borders + "This is incorrect Code, try again" (localized).

**Layout:**
- "Check OTP code" heading + subtitle "We have sent a verification code to your phone. Enter the 6-digit code."
- **6** OTP input boxes (use `pinput` package, or build custom) — rounded, `#384f47` focus
- **Verify** button: bg `#384f47`, radius 20, height 60
- Resend row: timer chip (counts `resendAfterSeconds` down) + "Resend OTP" (enabled only at 0)
- Success state (`155:786`): green scalloped check + "Successful / …authenticated" + Continue → `/home`

**Endpoint — `POST /auth/otp/verify`** (stable, no auth):
```
Request:  { "phone": "+20...", "code": "482913", "device": DeviceInfo }
DeviceInfo: { "deviceId": "<stable, ≤64, survives restart, regenerated on reinstall>",
              "platform": "android"|"ios", "model": "Redmi Note 12" (optional) }

200 → discriminated on `result`:
  AuthenticatedResult      { result:"authenticated", tokens: TokenPair, profile: StudentProfile }
  RegistrationRequiredResult { result:"registrationRequired", registrationToken, expiresInSeconds }

TokenPair: { accessToken, accessExpiresInSeconds(~900), refreshToken, refreshExpiresInSeconds(~5184000) }

400: ProblemDetails code = otp_invalid | otp_expired | validation_failed
429: ProblemDetails code = otp_throttled   (5 failed attempts → 15-min lock)
```

**Behavior (the fork):**
- `result == "authenticated"` → `SecureStorage.writeTokens(access, refresh)`, then go `/home`
  (show the success screen `155:786` first if the design intends it).
- `result == "registrationRequired"` → carry `registrationToken` (+ its TTL) to `/register`;
  do NOT store tokens (there are none yet).
- `otp_invalid` → render the **error component** state (red boxes + message), let the user retry.
- `otp_expired` / lockout (`otp_throttled`) → localized message; offer resend when the timer allows.
- OTP is 6 digits; auto-submit on the 6th is fine, but keep an explicit Verify button.

**DeviceInfo:** add `device_info_plus`. Generate a stable `deviceId` once and persist it in
`SecureStorage` (regenerate only if missing → survives restart, resets on reinstall). `platform`
from `Platform.isAndroid/isIOS`. This is the device-binding key (adr-019); getting a NEW device is
what later evicts the old session (`session_superseded`).

**Files:**
- `models/auth_result.dart` — freezed sealed: `AuthenticatedResult` | `RegistrationRequiredResult` (discriminator `result`)
- `models/token_pair.dart`, `models/device_info.dart` — freezed + json_serializable (camelCase — no `@JsonKey` needed)
- `repository/auth_repository.dart` — add `verifyOtp({phone, code, device})`
- `notifier/otp_notifier.dart` — `AsyncNotifier`; holds resend countdown; `verify()`, `resend()`
- `screens/otp_screen.dart` — 6-box input, timer, error/success states via `StateWidget`

---

## Design tokens — ALREADY WIRED (both themes)

`core/theme/app_colors.dart` + `app_theme.dart` now carry both palettes. Read them via
`Theme.of(context).colorScheme.primary` (standard slots) and
`Theme.of(context).extension<AppColors>()!` (custom tokens). **Never inline a hex.**

| Token | Light | Dark | Read as |
|---|---|---|---|
| primary (button) | `#384f47` green | `#ae87e7` purple | `colorScheme.primary` |
| onPrimary (button text) | `#fcfbf9` | `#fcfbf9` | `colorScheme.onPrimary` |
| background | `#fcfbf9` | `#232428` | `ext.background` |
| field fill | `#fdfdfd` | `rgba(35,36,40,.2)` | `ext.fieldFill` |
| field border | `#d1d1d1` | `#fcfbf9` | `ext.fieldBorder` |
| text primary | `#0e0e0e` | `#fcfbf9` | `ext.textPrimary` |
| text secondary | `#2c2c2c` | `#dcdcdc` | `ext.textSecondary` |
| hint | `#696969` | `#fcfbf9` | `ext.hint` |
| link | `#e67e22` orange | `#ae87e7` purple | `ext.link` |
| secondary btn border | `#384f47` | `#384f47` | `ext.secondaryButtonBorder` |

Fonts: **bundled** (NOT google_fonts). Inter (UI) + Tajawal (Arabic) + Cairo (toggle) are declared
in `pubspec.yaml`; `app_theme.dart` sets `fontFamily: 'Inter'` with Arabic falling back to Tajawal.
Prerequisite: the 10 `.ttf` files must be in `assets/fonts/` — see `assets/fonts/README.md`.

### How the two themes live in code (pattern already in the repo)

```dart
// app.dart (already wired)
MaterialApp.router(
  theme:     AppTheme.light,   // ColorScheme.light + AppColors.light
  darkTheme: AppTheme.dark,    // ColorScheme.dark  + AppColors.dark
  themeMode: ThemeMode.system, // one widget renders both
  ...
)

// in any widget — the SAME code renders light or dark:
final cs  = Theme.of(context).colorScheme;
final ext = Theme.of(context).extension<AppColors>()!;
FilledButton(...);                                  // picks up primary per theme
Container(color: ext.background);                   // cream / #232428 automatically
Text('…', style: TextStyle(color: ext.link));       // orange / purple automatically
```
No `if (isDark)` branches in widgets — the theme carries the values.

## Dependencies to add

```
flutter pub add pinput device_info_plus flutter_svg
```
(Fonts are bundled, not a package — Inter/Tajawal/Cairo declared in pubspec; drop the .ttf into `assets/fonts/`.)

## Acceptance checks (Definition of Done)

- [ ] Both screens render **loading / error / offline** (+ success on OTP), each in **AR (RTL) + EN (LTR)**
- [ ] `EdgeInsetsDirectional` throughout; no hardcoded Left/Right; layout mirrors in AR
- [ ] All copy via `AppLocalizations`; both `.arb` files have every key
- [ ] OTP is **6** boxes; phone submitted as **E.164 `+20…`**
- [ ] `otp/request` always advances to OTP (anti-enumeration); no "account exists?" leak
- [ ] verify fork correct: authenticated → store tokens → `/home`; registrationRequired → carry token → `/register`
- [ ] Error codes mapped to localized copy: `validation_failed`, `otp_throttled`, `otp_invalid`, `otp_expired`
- [ ] No token/PII in any log
- [ ] `flutter analyze` clean; `dart run build_runner build --delete-conflicting-outputs` succeeds
- [ ] Widget test: phone validation + the verify fork (mock repository with `mocktail`)

## Route wiring

`app_router.dart` already has `/login`, `/register`, `/home`. Add an `/otp` route (carry phone +
timing params via `extra` or path). Set `initialLocation` to `/login` once onboarding is deferred.
The auth `redirect` guard comes with the forced-logout screen (next brief) — leave a TODO.
