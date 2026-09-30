# Device walk results — API→UI waves

Verification level for every row marked DEVICE: **DEVICE VERIFIED** on the build named in the
wave header. Rows marked SOURCE/BUILD say so.

---

## Wave 01 — Login (`/login`) — WALK 2026-09-24

| | |
| --- | --- |
| Device | **Pixel 8** (physical, serial `45131FDJH0009G`), Android 17, 1080×2400 @ 420 dpi = **411×914 dp**, font scale 1.0 |
| Build | `flutter build apk --debug -t lib/main_mock.dart` from the Wave 01 working tree (`merged` @ `e4d1401` + uncommitted Wave 01 changes) |
| Backend | `lib/dev/mock_backend.dart` (300 ms latency) |
| Figma | light `82:819`, dark `337:15652` (renders + `get_design_context` values pulled this walk) |
| Driving | `uiautomator` dumps for every tap; `screencap` PNGs in the session scratchpad `walk01/` |
| Locales / themes | EN + AR · dark (a persisted preference on arrival) and light (after `pm clear` of the debug app) |

### Criteria (defined in `implementation_waves.md`, Wave 01)

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | `requestOtp` sent with `{phone}` | **PASS** | valid `01021871999` → OTP screen with the resend countdown running from the response's `resendAfterSeconds` (`06_otp_after_submit`). Body shape itself is BUILD-verified by the unit suite |
| F2 | Loading state | **PASS** | screencap fired in the same shell call as the Enter key caught the CTA dimmed with its spinner (`05_loading`) |
| F3 | Inline error | **PASS** | empty and `0102` both show "Please enter a valid phone number" under the field (`02_invalid_phone`) |
| F4 | Offline banner + disabled CTA | **PASS** | airplane mode **and** Wi-Fi off → "You are offline" banner; Send OTP and Create New Account `enabled=false`; banner clears on reconnect (`03c_offline`) |
| F5 | Navigates to `/otp` | **PASS** | OTP screen reached (AR) |
| V1 | Light layout vs `82:819` | **FAIL** | structure, colours, CTA, links, hairlines match; **but** (a) logo drawn 88 dp tall, frame is **152.9 × 132.85**; (b) subtitle is `bodyLarge` 16/400 **centred**, frame is Inter **Bold 20 / 1.3, start-aligned** (= `AppType.h2`, which exists); (c) vertical rhythm — frame places subtitle / label / field / CTA / OR / Create / legal at y 367 / 418 / 450 / 535 / 620 / 662 / 742 with 25 dp gaps; the app packs the block ~125 dp higher and leaves ~270 dp empty at the bottom (`08_login_en_light` vs `figma_82_819`) |
| V2 | Dark vs `337:15652` | **FAIL** | **the bird logo is black on the dark canvas.** Figma's dark export fills the three paths `#FCFBF9`; the app ships one asset (`assets/images/bird_logo.svg`, fills `#040404`) with no dark variant or colour filter (`login_screen.dart:155-159`). Nearly invisible on `#232428` (`01_login_en_light` — named before the theme was known; it is the dark capture). Plus V1's (a)–(c) |
| V3 | `+20` correct in Arabic | **PASS** | chip paints `+20` under AR on device (`04_login_ar_dark`, `07_login_ar_light`) — **the Wave 01 fix, DEVICE VERIFIED** |
| I1 | Keyboard submit | **PASS** | Enter with `0102` → validation error; Enter with a valid number → loading → OTP |
| I2 | Language toggle switches AR/EN | **FAIL** | every string flips **except an error already on screen**: after toggling to Arabic the field error stays "Please enter a valid phone number" in English (`04_login_ar_dark`). Root cause: `_phoneErrorKey` stores the **resolved string** `l10n.invalidPhone` at submit time (`login_screen.dart:96`), not a key, so it is frozen in the old locale |

**Score:** Functional **5/5** · Visual **1/3** · Interaction **1/2** → **7/10 = 70%**. No criterion was N/A.

### Findings (new unless marked)

| # | Finding | Kind | Where |
| --- | --- | --- | --- |
| W01-1 | Dark logo black on dark canvas — frame fills `#FCFBF9` | **build defect** (visual, dark) | `login_screen.dart:155-159`, `assets/images/bird_logo.svg` |
| W01-2 | Validation error frozen in the previous language after a toggle | **build defect** (i18n) | `login_screen.dart:39`, `:96` |
| W01-3 | Subtitle style: `bodyLarge` centred vs frame Bold 20 start-aligned (`h2`) | **build defect** (visual) | `login_screen.dart:166-171` |
| W01-4 | Logo 88 dp vs frame 132.85 dp | **build defect** (visual) — no comment explains the reduction | `login_screen.dart:157` |
| W01-5 | Vertical rhythm compressed vs the frame's 25 dp auto-layout gaps and positions | **build defect** (visual) | `login_screen.dart:151-251` `SizedBox` heights |
| W01-6 | "Welcome back" 24 (`h1`) vs frame 36 | **known class** — the frame's 36 is outside the designer's handoff scale (28 → 10, "do not create random font sizes"); which step it maps to is a designer question | `app_typography.dart` header |
| W01-7 | Legal line wording | **known** — DESIGN_ISSUES #9 addendum | — |
| W01-8 | Language pill 36.2 dp tall on device (95 px) | **known** — DESIGN_ISSUES #89 (owner decision) | — |

### Proven good on this device

`+20` in Arabic (the Wave 01 fix) · client validation · loading · offline banner + disabled CTAs +
recovery · keyboard submit · AR mirroring of the whole screen (pill at start, field row mirrored,
labels end-aligned) · logo semantics label present ("Level Up" / "ليفل أب").

### Device state left behind

Airplane mode **off**, Wi-Fi **on** (both restored and re-checked). The debug app's data was
cleared with `pm clear com.levelup.level_up_app` to reach the light default — its previously
saved **dark** preference is gone (it only affects this debug build; set it again in Settings).
After `pm clear` the app starts in **Arabic**.

---

## Wave 01 — Login — RE-WALK after fixes (2026-09-24, same Pixel 8)

**Fixes applied (W01-1…W01-5, plus the same W01-2 defect on Sign-up identity):**

| # | Fix | Where |
| --- | --- | --- |
| W01-1 | New token `brandLogo` (light `#040404` = the shipped SVG's fill, `82:849`; dark `#FCFBF9` = the dark frame's export fill, `337:15678`); the bird is tinted with it (`ColorFilter.mode(…, srcIn)`) | `app_colors.dart` (6 wiring sites), `login_screen.dart` |
| W01-2 | Error stored as a flag, copy resolved in `build` — on Login **and** on Sign-up identity (name + parent phone), which had the identical pattern | `login_screen.dart`, `signup_identity_screen.dart` |
| W01-3 | Subtitle → `AppType.h2` (20/26 w700 = frame Bold 20/1.3), `TextAlign.start` | `login_screen.dart` |
| W01-4 | Bird at the frame's 152.901 × 132.854 (height 132.854) | `login_screen.dart` |
| W01-5 | Gaps from the frame: 18 · 3 · 68 · 25 · 10 · 25 · 25 · 25 · 20 (were 16 · 16 · 8 · 28 · 8 · 20 · 16 · 16 · 24) | `login_screen.dart` |

**Tests added (7):** `brandLogo` values + copyWith/lerp (`app_colors_test.dart` ×2); Login — error
follows a locale change, bird tint per canvas, bird height, subtitle style (`login_validation_test.dart`
×4); Sign-up — both errors follow a locale change (`registration_screens_test.dart` ×1).
Not proven to fail on the old code by running it (the old `app_colors.dart` has no `brandLogo`, so the
file would not compile) — each assertion is the inverse of a value the first walk measured.
**Validation:** `tool/validate.ps1` → format PASS · analyze 0 · **1438 / 0 / 0** · OVERALL PASS.

**Measured on device (EN light, dump bounds ÷ 2.625):** pill 58.3 · bird 112.4 (133.0 tall) · title
248.4 · subtitle 346.3 · label 397.3 · Send OTP 510.1 · OR 595.4 · Create 640.4 · legal 720.4 dp.
Frame: 64.9 · 119.2 (132.9) · 255 · 367 · 418 · 535 · 620 · 662 · 742. Every element sits 21–25 dp
above its frame position; the offset is fully accounted for by the status-bar/safe-area origin (~6.6)
plus the type scale's smaller boxes (title 30 vs 44 — W01-6, label 18 vs 22). Gaps between
elements match the frame.

| # | Criterion | Result | Evidence (`walk01b/`) |
| --- | --- | --- | --- |
| F1 | requestOtp sent | **PASS** | OTP screen with the 56 s countdown after submit |
| F2 | Loading | **PASS** | `13_loading` — CTA dimmed with spinner |
| F3 | Inline error | **PASS** | empty submit → error |
| F4 | Offline | **PASS** | `12_offline_ar` — banner "أنت غير متصل بالإنترنت", both CTAs `enabled=false`; restored |
| F5 | → `/otp` | **PASS** | |
| V1 | Light vs `82:819` | **PASS** | `10_login_en_light` — bird size, subtitle Bold 20 start-aligned, frame rhythm (numbers above). Known, not scored: W01-6 title size (type-scale rule), label 14/600 vs 18/500 (18/w500 not in the scale, same class) |
| V2 | Dark vs `337:15652` | **PASS** | `14_login_en_dark` — bird cream on `#232428`, lavender Send OTP glow. Known, not scored: **#21** "Create New Account" is dark/outlined in the build, cream-filled in the frame (see addendum below) |
| V3 | `+20` in AR | **PASS** | `11_error_toggled_ar_light` |
| I1 | Keyboard submit | **PASS** | Enter → loading → OTP |
| I2 | Language toggle | **PASS** | `11_error_toggled_ar_light` — the on-screen error switched to Arabic |

**Score: Functional 5/5 · Visual 3/3 · Interaction 2/2 → 10/10 = 100%.**

**Also device-verified (the wave's documented dependency, Sign-up identity `/register`, dark AR):**
both field errors switch language with the toggle, and the Parent's Number chip paints `+20`
(`15_identity_errors_ar_dark`).

**Observations, not scored (outside Wave 01's criteria):** in Arabic, an EMPTY LTR phone field
right-aligns its hint (`01021871999`) while typed digits start at the left — Login and Sign-up alike;
cosmetic, pre-existing, no AR frame exists to settle it.

**Device state left behind:** airplane off, Wi-Fi on (re-checked). Debug app: theme **dark**, locale
**Arabic**, sitting on Sign-up identity (a mock registration session; nothing persisted server-side).

---

## Wave 02 — OTP (`/otp`) — WALK 2026-09-24

| | |
| --- | --- |
| Device | **Pixel 8** (`45131FDJH0009G`), Android 17, 411×914 dp, font scale 1.0 |
| Build | `flutter build apk --debug -t lib/main_mock.dart`, Wave 02 tree + the owner-requested mock trigger |
| Mock change | `lib/dev/mock_backend.dart`: code **`999999` → `400 otp_invalid`** (contract verifyOtp 400); doc line in `lib/main_mock.dart` |
| Figma | `82:1171` input · `82:1170`/`82:1439` light wrong · `337:19271`/`337:19284` dark wrong · `155:786` success |
| Evidence | session scratchpad `walk02/` (screencaps + uiautomator dumps) |
| Covered | dark AR, dark EN, light EN (theme switched via Settings, not `pm clear`) |

A picture-in-picture video from another app (`com.watchit.vod`, FLAG_SECURE → black in screencap) sat over
the top-start corner for the first captures; it was not touched and later went away. Taps avoided it.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | verify request shape | **PASS** | the mock branched on the posted `code` three ways (`999999` / `123456` / `000000`); body shape BUILD-verified (`verify_fork_test.dart`) |
| F2 | invalid-code state | **PASS** | `999999` → all six cells red-stroked + line "الرمز غير صحيح، حاول مرة أخرى" / "This is an incorrect code, try again" (`02`, `03`, `08`) |
| F3 | resend countdown | **PASS** | pill counted 60 → 0 with Resend inert; at 0 Resend enabled; tap → countdown restarted at 56 s and the error cleared |
| F4 | success view | **FAIL** | `000000` landed **straight on Home** — the success view never shows. Root cause below (W02-5) |
| F5 | fork to `/register` | **PASS** | `123456` → Create Account with the proven `+201021871999` read-only |
| F6 | offline disables verify/resend | **PASS** | airplane + Wi-Fi off: banner "You are offline"; Verify `enabled=false` with 6 digits entered; at countdown 0, Resend enabled → disabled offline → enabled after reconnect (`04`) |
| V1 | vs `82:1171` | **FAIL** | structure/colour PASS (pill top-end with green outline, back chip start, card with Verify inside, green timer glyph + digits, green Resend). **Vertical rhythm off** (W02-6, table below) |
| V2 | error vs `82:1170` | **PASS** | light: `#EB001B`@50% strokes over the resting `#FDFDFD`, `#FF465C` line start-aligned, no icon (`08`); dark: thin red strokes over the 20% cell (`02`, `03`). Gaps on device: digits → line **12.95–13.3**, line → Verify **19.8–20.2** dp (frame 13 / 20) |
| I1 | auto-advance + auto-submit | **PASS** | after `123` the 4th cell carries the focus stroke and Verify is disabled (`07`); the 6th digit submits with no tap (three times) |

**Score: Functional 5/6 · Visual 1/2 · Interaction 1/1 → 7/9 = 78%.** No criterion N/A.

**Also device-verified (Wave 02 changes):** the language pill on the input view toggles AR ⇄ EN and the
on-screen error follows (`02` → `03`); timer glyph + digits cream in dark, green in light; card gaps
card → pill **26.1**, pill → Resend **20.2**, digits → Verify **20.2** dp. **Not reachable on device:**
the success view (W02-4's 75 gap is widget-test-verified only) — blocked by W02-5.

### W02-5 — the success view is skipped (build defect, pre-existing)

`login_screen.dart:108` opens OTP with `context.push('/otp')`, so the router's location stays `/login`.
When verify flips `AuthController` to authenticated, `authRedirect` (`app_router.dart`, the
`_signedInLandingRedirects = {'/', '/login'}` rule, since `5e620e4` 2026-07-30) sends a signed-in
student on `/login` to `/home`, which replaces the stack — the pushed OTP screen and its success view
with it. **Why tests missed it:** every success test pumps `OtpScreen` directly, without the router.
Not fixed in this walk.

### W02-6 — input-view vertical rhythm (build defect)

Measured from screencap pixel rows (`06_otp_en_light`), relative to the language pill's top so the
status-bar difference cancels (on Login the same reference matched to 0.2 dp). Frame values use the
frame's cap/baseline text trim.

| Span | Device | `82:1171` | Δ |
| --- | --- | --- | --- |
| pill top → title cap-top | 58.3 | 81.3 | **−23.0** |
| title baseline → subtitle cap-top | 24.0 | 15.0 | **+9.0** |
| subtitle last baseline → card top | 41.2 | 35.0 | **+6.2** |
| card top overall | 177.0 | 187.7 | −10.7 |

The type-scale differences (title 24 vs 25, subtitle 16 vs 18) are included and explain ~1–2 dp only.

### Device state left behind

Airplane off, Wi-Fi on (re-checked). Debug app: theme **dark**, locale **Arabic**, signed in to the mock
session on Settings (restored via Settings; no `pm clear`).

---

## Wave 02 — OTP — RE-WALK after fixes (2026-09-24, same Pixel 8)

**Fixes (owner: "fix them in Wave 02 and re-walk"):**

| # | Fix | Where |
| --- | --- | --- |
| W02-5 | OTP nested at **`/login/otp`**; Login `go`es there (was `push('/otp')`), so the redirect no longer sees `/login` when verify flips auth. The route **keeps its last `OtpArgs`**: go_router re-parses the stored location on the auth refresh and drops a non-JSON `extra` — without this the success view was a null-check red screen (caught by the new router test, not by hand). No args at all → `/login` | `app_router.dart`, `login_screen.dart` |
| W02-6 | Box-to-box gaps from the device measurement: header → title 8 → **31**, title → subtitle 12 → **3**, subtitle → card 35 → **28.8** | `otp_screen.dart` |

**Tests +4:** `authRedirect` stays on `/login/otp` when signed in; router-driven login → OTP → `000000` shows
the success view (FAILED on the old push navigation, passes now) and the back chip still pops to `/login`;
input-view rhythm 39 / 3 / 28.8. `otp_dark.png` golden regenerated (spacing only, reviewed).
**Validation:** `validate.ps1` → format PASS · analyze 0 · **1449 / 0 / 0** · OVERALL PASS.

| # | Criterion | Result | Evidence (`walk02b/`) |
| --- | --- | --- | --- |
| F1 | verify request shape | **PASS** | three branches from the posted code (`999999` / `123456` / `000000`) |
| F2 | invalid-code state | **PASS** | `01_error_ar_dark`, `06_error_en_light` |
| F3 | resend countdown | **PASS** | counted to 0 → Resend enabled → tapped → "Resend in 55s", error cleared |
| F4 | success view | **PASS** | **`000000` → success view** (`03_success_en_dark`, `07_success_en_light`), no crash; Continue → Home. **BUG-005 fixed, DEVICE VERIFIED.** Subtitle → Continue **75.05** dp (frame 75) |
| F5 | fork to `/register` | **PASS** | `123456` → Create Account; its back chip → Login |
| F6 | offline | **PASS** | Verify disabled with 6 digits; Resend enabled → disabled offline → enabled on reconnect |
| V1 | vs `82:1171` | **PASS** | `04_otp_en_light`, pixel rows from the pill top: title caps **81.1** (frame 81.3), title → subtitle **15.2** (15), subtitle → card **35.0** (35); card top −2.7 dp overall = the type-scale sizes (24 vs 25, 16 vs 18) |
| V2 | error vs `82:1170` | **PASS** | light + dark; digits → line **12.95**, line → Verify **19.8** dp (13 / 20) |
| I1 | auto-advance + auto-submit | **PASS** | `05_partial_123_light`: 4th cell focused, Verify disabled; 6th digit submits |

**Score: Functional 6/6 · Visual 2/2 · Interaction 1/1 → 9/9 = 100%.**

### Observations, not scored (outside Wave 02's criteria)

- **W02-7 — landscape: the success view overflows and Continue is unreachable.** The phone auto-rotated
  mid-walk: "BOTTOM OVERFLOWED BY 95 PIXELS", and Continue sat outside the hit-testable area. The view is
  a plain `Column` (never scrollable); 60 → 75 adds 15 dp of the 95 px. Landscape support is an open
  product decision (`docs/STORE_READINESS.md` §6 "Portrait-lock vs landscape support") — not fixed.
- **W02-8 — system Back on the success view lands a SIGNED-IN student on Login.** Exposed by the W02-5
  fix (before it, the success view never appeared): the stack is Login → OTP, a pop does not re-run the
  redirect, so Back shows Login with the old number still typed. Suggested one-line fix: `PopScope` on the
  success view whose Back does what Continue does (`go('/home')`) — the code already records "once tokens
  are stored, back is meaningless". Owner's call.

### Device state left behind

Airplane off, Wi-Fi on (re-checked). Portrait. Debug app: theme **dark** (`#232428` read off the
screencap), locale **Arabic**, signed in to the mock session on Settings.

## Wave 04 — University registration (`/register/university`) — WALK 2026-09-24

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart`
with the Wave 03 + 04 changes. Path: Log In → `1098765432` → OTP `123456` → Create Account → University
Student → this screen. Walked dark + EN, then light + EN, then light + AR. Screens in the session
scratchpad `walk04/`. Taps from `uiautomator` dumps; measurements from dump bounds and screencap pixels.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | universities load | **PASS** | Cairo University, Ain Shams University (`02_uni_list`) |
| F2 | faculty cascade | **PASS** | Faculty gated "Choose a university first"; Cairo → Human Medicine → Year 2, then switching to Ain Shams reset Faculty to "Select" and re-gated Academic Year |
| F3 | `soon` years not selectable | **PASS** | Human Medicine lists Years 1–5; Years 4–5 are not clickable, and tapping Year 4 leaves the menu open with nothing selected (light and dark) |
| F4 | city escape (adr-028) | **PASS** | "My city isn't listed" swaps in a "City name" field in place; typed "Maadi"; "Choose from the list" returns to the picker |
| F5 | submit → `/home` (university catalog) | **PASS** | EN and AR both land on Home; Learn shows the university subjects (Anatomy, Physiology, Biochemistry, Histology). Incidental: an early tap on Start learning showed the pre-flight check (inline "This field is required" on Date of Birth and City + banner, no request) |
| V1 | light vs `125:2336` | **PASS** | W04-1: header → title **24.8**, subtitle → first block **25.1**, block → block **24.8–25.1**, last block → Start learning **25.1** dp (frame 25; bounds are whole pixels). W04-2: subtitle **`#858585`** (`bodyMuted`, #24). Title `#0E0E0E`, labels `#2C2C2C`, canvas `#FCFBF9`. Not scored: #90's recorded owner/designer items (label → box 8 vs 10, green title/labels in this frame, type sizes) |
| V2 | dark vs `337:10373` | **FAIL** | The page matches: same geometry, canvas `#232428`, title `#FCFBF9`, subtitle `#ECECEC` (frame `#DEDEDE`, #24). **But every open dropdown is see-through (W04-3)** |
| I1 | disabled-option treatment | **FAIL** | Light: `soon` rows **`#696969`** vs active `#0E0E0E`, clearly distinct. **Dark: `soon` rows `#FCFBF9`, identical to active rows (W04-4)** |
| I2 | AR layout | **PASS** | `12_light_ar`: back chip at the right (arrow mirrored), pill at the left, labels and values right-aligned, chevrons and calendar at the left, the selections carried over into Arabic, same 25 rhythm (65 px) |

**Score: Functional 5/5 · Visual 1/2 · Interaction 1/2 → 7/9 = 78%.**

### W04-3 — dark: the dropdown menu is see-through (build defect, pre-existing, shared)

`reference_dropdown.dart` `_Dropdown`: `dropdownColor: ext.fieldFill`. In dark `fieldFill` is
`0x33232428` (20% alpha, the field's Glass fill), so the open menu composites over the form: the labels
"Governorate" and "City", the "Select" hint, "Choose a governorate first" and "My city isn't listed" all
show through the menu items (`03_year_list`, `04_gov_list`; menu reads `#18191B` over a `#232428` page).
Light is opaque `#FDFDFD` (`11_light_year_list`). The same widget draws every picker on **School
registration** too. The frames never draw an open menu, so the opaque dark value needs a decision:
an existing opaque surface token, or a designer value.

### W04-4 — dark: `soon` study years look selectable (build defect, shared)

Disabled rows use `ext.hint`. Light `hint` = `#696969`, but dark `hint` = `#FCFBF9` = dark
`textPrimary`, so in dark the "visible but refused" rows the contract asks for (`openapi.yaml:751`)
are indistinguishable from selectable ones (`03_year_list`: Years 2–5 all `#FCFBF9`). The
cascade-gated hints ("Choose a university first") avoid this only because `FieldShell` also dims
them to 0.6 opacity; menu rows get no opacity. Found with the first real consumer of per-option
`enabled`.

### Observations, not scored

- **All-`soon` faculty:** Ain Shams → Faculty of Pharmacy has no `active` year, so its list offers only
  refused rows and gives no reason. In dark (W04-4) they even look selectable. `mock_backend.dart`'s
  comment still calls it "the Empty year list", which is stale since `soon` rows are shown.
- The mock profile name is Arabic (`طالب جامعي تجريبي`) under the English UI, and the subject names on
  Learn are Arabic. Mock fixtures, not this screen.

### Device state left behind

Airplane mode off, Wi-Fi on (re-checked). Debug app: theme **dark** (`#232428` read off
`14_restored`), locale **English**, signed in to the mock session on Settings. That matches how the app
was found at launch (dark, English). **Auto-rotate reads ON (`accelerometer_rotation 1`); it read 0
when this walk began.** The walk never touched that setting, so it was left as found now, not reset.

## Wave 04 — University registration — RE-WALK after fixes (2026-09-24, same Pixel 8)

Owner: "fix them in Wave 04 and re-walk". Fixes in the shared `ReferenceDropdown` (+ one constant in
`form_fields.dart`): menu fill `Color.alphaBlend(ext.fieldFill, ext.background)` (W04-3); refused rows
at `disabledControlOpacity` 0.6 instead of `ext.hint` (W04-4). `validate.ps1` **1457 / 0 / 0**. Fresh
mock build; walked dark + EN, light + EN, light + AR; screens in `walk04b/`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | universities load | **PASS** | both universities listed (`01_dark_uni_menu`) |
| F2 | faculty cascade | **PASS** | Cairo → Human Medicine → Year 2, then Ain Shams reset Faculty and re-gated Academic Year |
| F3 | `soon` years not selectable | **PASS** | tapping Year 4 leaves the menu open, nothing selected; Ain Shams → Pharmacy (all `soon`) refuses its only row |
| F4 | city escape | **PASS** | swap to "City name" and back |
| F5 | submit → `/home` (university catalog) | **PASS** | EN (dark) and AR (light) both land on Home |
| V1 | light vs `125:2336` | **PASS** | geometry identical to the first walk (25 rhythm); menu still `#FDFDFD` (`06_light_year_list`) |
| V2 | dark vs `337:10373` | **PASS** | **W04-3 fixed:** menu fill `#232428`, **0** bright pixels in the empty menu area (was the form showing through), year and governorate menus both checked (`02_dark_year_list`, `04_dark_gov_menu`) |
| I1 | disabled-option treatment | **PASS** | **W04-4 fixed:** dark `soon` rows **`#A5A5A6`** vs active `#FCFBF9` (were identical); light `#6E6E6E` vs `#0E0E0E`; AR the same (`07_light_ar_year_list`) |
| I2 | AR layout | **PASS** | mirrored chrome, right-aligned rows in the menu, dimmed Years 4–5 |

**Score: Functional 5/5 · Visual 2/2 · Interaction 2/2 → 9/9 = 100%.**

### Device state left behind

Airplane mode off, Wi-Fi on. Debug app: **dark** (`#232428` off `08_restored`), **English**, signed in
to the mock session on Settings. Auto-rotate still reads ON, as the first walk found it; not touched.

## Wave 05 — Home (`/home`) — WALK 2026-09-25

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart`
with the Wave 05 changes (validate 1475/0/0). School via OTP `000000`, university via `111111`. Walked
dark + EN, light + EN, light + AR (school), offline, then university light + EN. Frames pulled over the
Figma MCP: `59:1439`, `125:2373`, `337:5456`, and `get_design_context` on `59:2086`. Screens and frame
renders in the session scratchpad `walk05/`. Taps from `uiautomator` dumps; colours and gaps read off
the screencap PNGs.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | `/me` level + points | **PASS** | LEVEL 3, 1,250, bar 1,250 / 1,500 (`01_school_dark_en`) |
| F2 | Top Student renders board rows | **PASS** | school: 🥇 2,140 · 🥈 2,020 · 🥉 1,890 (`02`); university (fresh process): the same fixture rows (`12`); See All opens the tab on **System** (school) / **Global** (university) with the SAME top three (`03_see_all_board`) |
| F3 | block empty state | **N/A on device** | the mock has no empty board; covered only by `top_student_section_test.dart` |
| F4 | block error / retry | **PASS** | reached by accident through W05-3: "Something went wrong" + Retry inside the card, the rest of Home still renders (`10_uni_stale_board_error`); Retry sends the request again |
| F5 | offline | **PASS** | airplane + Wi-Fi off: the pinned "أنت غير متصل بالإنترنت" banner, the level card and the three rows stay; the banner clears on reconnect. The block's own offline view is NOT reachable on device (the mock answers in-process), so it rests on the widget test |
| F6 | points refresh after a quiz | **PASS** | 10-question quiz, "+2 Points" → Home level card **1,252** and 1,252 / 1,500; the Leaderboard tab's "You" row reads **1,252 pts** without a pull (it read 1,250 before the quiz), so the invalidate reached the shared board |
| V1 | school vs `59:1439` | **FAIL** | W05-1: every "See All" is `#B3B3B3`; the frame draws `#000000` |
| V2 | university vs `125:2373` | **FAIL** | W05-1, same |
| V3 | Top Student vs frame | **FAIL** | W05-1 and W05-2. Matching: rows 64.8 dp + 1.14 dp dividers (frame 64.7 + 1.208); light name **`#384F47`**, points **`#E67E22`**, fill `#FFFFFF`; divider `#F2EBFD` (frame `#F6F2FE` at 1x) |
| V4 | dark | **FAIL** | W05-1: "See All" `#B3B3B3` vs frame `#FCFBF9`. Everything else matches `337:5456`: name **`#FCFBF9`**, points **`#AE87E7`**, fill `#242529` (frame `#242529`), rim on all four sides (frame too), divider `#2D273D` |
| I1 | tap behaviour | **PASS** | See All → Leaderboard tab (D-014); rows inert (the frame draws no action) |

**Score: Functional 5/5 (F3 N/A) · Visual 0/4 · Interaction 1/1 → 6/10 = 60%.** One colour fix (W05-1)
flips V1, V2 and V4. V3 also needs W05-2.

### W05-1 — "See All" is grey; every frame draws it in the title's colour (build defect, pre-existing, shared)

`coming_soon_section.dart` has styled the header link `AppType.bodyMedium` in `ext.mutedText` since Day 4,
and Wave 05's `top_student_section.dart` copied it. On device it reads **`#B3B3B3`** in both themes. The
frames: light **`#000000`** on all three headers in `59:1439` and `125:2373` (`59:2089`: Inter Medium 14,
`text-black`, the same as the title), dark **`#FCFBF9`** (`337:5456`). The theme audit's F-4-03 took
`mutedText` on "See all" to be Figma-verbatim. The frames say otherwise, and on the light canvas it is
also 2.03:1 contrast. Likely fix: `ext.textPrimary` (light `#0E0E0E`, dark `#FCFBF9`) in both headers.
Also measured on the same header, not scored: title baseline → card **16.8 dp**; the frame's `gap-[15px]`
is from trimmed text, so 15.

### W05-2 — light: the Top Student outline is drawn on the top edge only (build defect, pre-existing)

`TopStudentSurface` draws `topSide` only (`topStudentTopBorder`, 1.208). Frame `59:2090` strokes **all four
sides**: `get_design_context` gives `border-[1.208px] border-[rgba(124,58,237,0.1)] border-solid`, and the
frame render shows `#F1EBFC` on the left and bottom edges. On device the left and bottom edges go straight
from `#FFFFFF` to the canvas. The "top only" reading comes from `edit3.md` (table #3, row Top Student
Light) and the token doc. Dark is fine: the Glass rim runs round all four sides, as in `337:5456`.

### W05-3 — after log-out → log-in on the other track, the board fails (known bug, new symptom)

School session → Log out → university `111111` without restarting the app: Home keeps the school name
and 1,252 (the stale profile from the 2026-09-20 tablet walk, Wave 19's item), while Learn shows the
university subjects. **New in Wave 05:** Top Student derives its scope from that stale profile, asks for
`scope=system` on a university session, gets `400 validation_failed`, and shows "Something went wrong".
Retry repeats the same request and cannot recover. A fresh process gives the right name, `Global`, and
rows. The root cause is the session invalidation (Wave 19), and Wave 05 makes it more visible. Not scored
against Wave 05.

### Observations, not scored

- The light title is `#0E0E0E` (`textPrimary`) against the frame's `#000000`. It is the app-wide token.
- Wave 06's concern: on the Leaderboard podium (dark) the white rank badges under places 2 and 3 carry
  almost invisible numerals (`03_see_all_board`).
- The mock serves the same peers to both tracks, so the university board looks like the school one.
- The university Home shows a "Learning Tools" placeholder that the school Home does not. Frame
  `125:2373` has it (recorded, #43).

### Device state left behind

Airplane mode off, Wi-Fi on (re-checked). Debug app: **dark** (`#232428` off `13_restored`), **English**,
signed in to the mock as the **university** student on Settings. The app opened on Welcome, signed out,
because the reinstall did not keep the mock session. **Auto-rotate:** read **0** before the walk and **1**
after it. The walk never set it directly. [INFERRED] `adb shell monkey` (used twice to launch the app) thaws
rotation when it exits; Wave 04's walk showed the same 0 → 1 flip. Not reset.

## Wave 05 — Home — RE-WALK after fixes (2026-09-25, same Pixel 8)

Owner: "fix W05-1 and W05-2 in Wave 05 and re-walk". `validate.ps1` → **1479 / 0 / 0**, OVERALL PASS
(one golden, `home_section_daily_tasks_dark.png`, was regenerated; its diff is the "See All" glyphs only).
Fresh mock build, launched with `am start` (no `monkey`). Walked school dark + EN, light + EN, dark + AR,
then university light + EN in a fresh process. Screens in `walk05b/`. Details in `docs/KNOWN_BUGS.md`
BUG-007.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1–F6 | functional | **carried** | the data path is unchanged; the first walk's results stand (F3 still N/A on the mock). Rows, rank order and points re-read on every screen of this walk |
| V1 | school vs `59:1439` | **PASS** | **W05-1 fixed:** all three "See All" `#0E0E0E`, the same as the titles (`03`) |
| V2 | university vs `125:2373` | **PASS** | "See All" `#0E0E0E` on Learning Tools, Continue Learning and Top Student (`06`) |
| V3 | Top Student vs frame | **PASS** | **W05-2 fixed:** outline `#F2EBFD` on all four sides (frame `#F1EBFC`); rows inset 6 px = 2.3 dp (frame 2.416); divider ends stop short of the outline (was a doubled `#E6D9FB` dot); name `#384F47`, points `#E67E22` |
| V4 | dark | **PASS** | "See All" `#FCFBF9` × 3 (`01`, `04`); rim violet on every side (left `#645E73`, bottom `#514B60`; frame `#59546A` / `#4C475D`); AR mirrored, "عرض الكل" in the title colour (`05`) |
| I1 | tap behaviour | **PASS** | re-tapped on this build: See All → Leaderboard tab on `Global` (university) |

**Score: Functional 5/5 (F3 N/A, carried) · Visual 4/4 · Interaction 1/1 → 10/10 = 100%.**

Still open, not part of this fix: **W05-3** (log out → log in on the other track leaves the stale profile,
and the board then 400s; the root is in Wave 19). Still recorded, not changed: the header's title
baseline → card is 16.8 dp against the frame's 15.

### Device state left behind

Airplane mode off, Wi-Fi on. Debug app: **dark** (`#232428` off `07_restored`), **English**, signed in to
the mock as the university student on Settings. Auto-rotate read **1** before and after this re-walk,
which used no `monkey`. That fits the first walk's inference that `monkey` thawed it.

## Wave 06 — Leaderboard (`/leaderboard`) — WALK 2026-09-25

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart`
with the Wave 06 changes (validate 1482/0/0), launched with `am start`. School via OTP `000000`,
university via `111111` after a force-stop (fresh process, so W05-3 is not in play). Walked school dark +
EN (both scopes, both pages, offline), school light + EN, school light + AR, university light + EN (both
scopes) and university dark + EN. Frames read over the Figma MCP: `get_metadata` on `133:3117`, and
`get_design_context` on the rows `134:3537`, `134:3553` (light) and `337:5629`, `337:5637` (dark). The rows
had never been read before. Screens, two `screenrecord` clips and their frames are in the session
scratchpad `walk06/`. Taps come from `uiautomator` dumps; colours and gaps are read off the screencap PNGs.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | scope switch refetches | **PASS** | `screenrecord` of System → Governorate: the board drops to the centred spinner for ~0.4 s (frames 21–28 of `07_switch_gov.mp4`, `08_switch_loading_frame`), then repaints from rank 1. University: Global → Cohort switches (`16`). The chosen scope survives leaving the tab and coming back. |
| F2 | pagination on `hasMore` | **PASS** | page 1 = ranks 1–20; scrolling on appends 21–23, then "That's the end of the board." (`04_board_end`); the 22-peer fixture plus the caller = 23 rows, nothing duplicated or skipped |
| F3 | load-more error keeps rows | **N/A on device** | the mock answers in-process, so airplane mode cannot fail an append; covered only by the widget tests |
| F4 | "You" row marked | **PASS** | rank 10 "You" 1,250 pts on the lilac fill (`03_board_scroll1`), on both scopes and both tracks. #86 contrast known, not scored |
| F5 | offline | **PASS** | airplane + Wi-Fi off: the red "You are offline" banner pins under the header, and the toggle and board stay usable (`11_offline`); the banner clears on reconnect. The board's own offline error view is not reachable (in-process mock) |
| V1 | podium vs `133:3117` | **PASS** | **W06-1 verified on device.** Badges light: 1 `#FFCA28` + `#0E0E0E`, 2 `#F4F4F4` + `#DC4A22`, 3 `#FCFBF9` + `#DEDEDE`, 3 px (1 dp) strokes, 30 dp discs. Rings `#FF8228` / `#FFCA28` / `#DEDEDE`. 2 · 1 · 3 layout (`12`, `13_pair_light`). Recorded, not scored: crown (trophy stand-in), no "level …Pts" line, name type size |
| V2 | rows vs frame | **FAIL** | W06-2, W06-3, W06-4. Matching: fill `#FFFFFF` (`134:3538`), 48 dp high, radius 12, start padding 12 / end 16 |
| V3 | dark | **FAIL** | W06-2 (points `#DCDCDC` vs `#FCFBF9`) and W06-3. Matching: badge fills and strokes exactly the frame's on both tracks (1 `#FFCA28` + `#FCFBF9`, 2 `#F4F4F4` + `#DC4A22`, 3 `#FCFBF9` + `#DEDEDE`); row fill composites to `#232428`; rank + name `#FCFBF9`; toggle selected `#C4A8E3`. The numerals are `#FCFBF9` as the frame draws them, so the "3" is invisible (all 841 sampled px one colour): **#93**, designer's call, not scored |
| I1 | scroll-triggered paging | **PASS** | `screenrecord` of a scroll (`09_scroll_gov.mp4`, `10_scroll_sheet`): the list stops at rank 20 with the append spinner under it, and 21–23 arrive only once the scroll reaches the end |
| I2 | AR mirroring | **PASS** | `14_board_ar_light`: the toggle order flips (نظامي on the right), back chevron → right and pointing right, share → left, podium 3 · 1 · 2, rank on the right and "1,720 نقطة" on the left of each row |

**Score: Functional 4/4 (F3 N/A) · Visual 1/3 · Interaction 2/2 → 7/9 = 78%.** W06-2 + W06-3 + W06-4
flip V2; W06-2 + W06-3 flip V3.

### W06-2 — row text colours were never read; the frame has one colour per canvas (build defect, pre-existing)

| | Frame light (`134:3541` / `134:3544` / `134:3539`) | Device light | Frame dark (`337:5633` / `337:5636` / `337:5631`) | Device dark |
| --- | --- | --- | --- | --- |
| rank | `#4F4F4F` | `#0E0E0E` | `#FCFBF9` | `#FCFBF9` |
| name | `#4F4F4F` | `#0E0E0E` | `#FCFBF9` | `#FCFBF9` |
| points | `#4F4F4F` | `#2C2C2C` | `#FCFBF9` | **`#DCDCDC`** |

`leaderboard_row.dart:45` justifies `textSecondary` on the points with "a shade quieter than the name in the
frame". The frame says the opposite on both canvases: the points are the same colour as the name. The
`#4F4F4F` is the file's "Gray 2" style, and no palette token carries it yet. On `#FFFFFF` it measures
8.19:1, so it's AA. **Fix needed:** one row-text token (`#4F4F4F` light / `#FCFBF9` dark) for
rank, name and points. The caller's own row keeps `podiumOnAccent`.

### W06-3 — the caller's row is `#DBB0FF`, not `#D8B0FF` (build defect; closes the question `edit4.md` §19 left open)

`134:3554` (light) and `337:5638` (dark) both read **`#DBB0FF`**. `AppColors.podiumAccent` is `#D8B0FF`,
and the phone shows `#D8B0FF` on both canvases. `app_colors.dart:976` and `DESIGN_ISSUES.md:2715` left the
token alone because "`134:3554` was not re-read". This walk read it. The row is the token's only consumer
(`leaderboard_row.dart:60`). It's three units of red, which the eye can't see, but the frame is explicit on
both canvases. **Fix needed:** `podiumAccent` → `#DBB0FF`, with the notes and `app_colors_test.dart:507`
updated.

### W06-4 — row geometry differs from the frame (build defect, pre-existing)

| | Frame (`134:3536` auto layout, `134:3542` Person) | Build / device |
| --- | --- | --- |
| gap between rows | **8** (rows at y 0 / 56 / 112) | 10 (`leaderboard_screen.dart:293`); 10.3 dp edge to edge on device |
| avatar | **32** | 36 (`_avatarDiameter`); 36.2 dp on device |
| avatar start | **40.1** from the row edge (`left-[11.08%]`) | 48 (12 pad + 28 rank + 8); 47.6 dp on device |

The row itself is exact (48 high, radius 12, 12 / 16 padding), and the avatar → name gap is 12 in both.
**Fix needed:** gap 8, avatar 32, and a rank column that puts the avatar at 40.

### Observations, not scored

- **The `leaderboardProvider` doc is stale.** `leaderboard_notifier.dart:195` says one notifier per scope
  "keeps each board warm instead of refetching". The provider is `autoDispose`, and the device shows a
  spinner and a full refetch on every switch, back and forth. Its behaviour is what F1 asks for; its doc
  comment is wrong.
- **Type-scale deltas, recorded:** the frame sets the rank in Plus Jakarta Sans Bold 14.4 with a soft text
  shadow, the name in Cairo Bold 14.4 and the points in Cairo Medium 14. The build uses `bodyMediumStrong`
  / `bodyMedium`. That's the same class as every other type-scale entry, so nothing was changed.
- Home Top Student (Wave 05) and the podium show the same top three, 2,140 · 2,020 · 1,890.
- The empty board isn't reachable on the mock (the fixture always has 23 rows).

### Device state left behind

Airplane mode off, Wi-Fi on, auto-rotate **1** (unchanged; no `monkey`). Debug app: **dark**, **English**,
signed in to the mock as the university student, on the Leaderboard tab (Cohort).

## Wave 06 — Leaderboard — RE-WALK after fixes (2026-09-25, same Pixel 8)

Owner: "fix W06-2, W06-3 and W06-4 in Wave 06 and re-walk". `validate.ps1` → **1489 / 0 / 0**, OVERALL
PASS (7 new tests; no golden touched). Fresh mock build, launched with `am start`. Walked school dark + EN,
light + EN, light + AR, then university dark + EN in a fresh process. Screens in `walk06b/`. Details in
`docs/KNOWN_BUGS.md` BUG-008.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1–F5 | functional | **carried** | the data path is unchanged; the first walk's results stand (F3 still N/A on the mock). Re-read on this build: 23 rows, the append after rank 20, "That's the end of the board." (`07_uni_end`), "You" at rank 10 on both tracks |
| V1 | podium vs `133:3117` | **PASS** | carried; the badges re-measured the same on the university dark board (`05`) |
| V2 | rows vs frame | **PASS** | **W06-2:** light rank, name and points all **`#4F4F4F`** (`03`). **W06-3:** "You" **`#DBB0FF`**. **W06-4:** pitch **56.0 dp** = 48 + **8.0** gap; avatar **32.4 dp** starting **39.6 dp** in (frame 32 at 40.1); digit centre ~21.8 dp (frame 22.2) |
| V3 | dark | **PASS** | rank, name and points all **`#FCFBF9`** (`01`, `05`); "You" **`#DBB0FF`** on both tracks (`02`, `06`); same geometry. #93 unchanged (as drawn) |
| I1 | scroll-triggered paging | **carried** | the append still lands at the end of page 1 (`07`) |
| I2 | AR mirroring | **PASS** | re-checked on the new geometry: the avatar ends **40.0 dp** from the right edge, rank on the right, `#4F4F4F` text (`04_school_light_ar`) |

**Score: Functional 4/4 (F3 N/A, carried) · Visual 3/3 · Interaction 2/2 → 9/9 = 100%.**

Still recorded, not changed: #93 (dark badge numerals), #86 ("You" row label contrast), the crown and the
"level …Pts" line, type-scale deltas, and the stale `leaderboardProvider` doc ("keeps each board warm").

### Device state left behind

Airplane mode off, Wi-Fi on, auto-rotate **1** (unchanged; no `monkey`). Debug app: **dark**, **English**,
signed in to the mock as the university student, on the Leaderboard tab (Global, scrolled to the end).

## Wave 07 — Subjects (`/learn`) — WALK 2026-09-25

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart`
with the Wave 07 changes (validate 1503/0/0), launched with `am start`. School via OTP `000000`, university
via `111111` in a fresh process. Walked school dark + EN, light + EN and light + AR (grid, a tree row, the
Mistakes overview, search, offline), then university light + EN. Frame renders pulled over the Figma MCP:
`337:5702` (dark) and `134:3837` (light). Screens are in the session scratchpad `walk07/`. Chevron direction
was read off the PNG: the chevron's apex at mid-height sits on its right or left edge.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | subjects load | **PASS** | school: 6 cards with the mock's counters (`01`); university: 4 (`10`) |
| F2 | empty `[]` message | **N/A on device** | the mock always returns a non-empty list; covered by `subjects_screen_test.dart` |
| F3 | search filters client-side | **PASS** | "zz" → "لا توجد مواد مطابقة لبحثك" and no cards (`08_search_nomatch`); clearing it brings all 6 back. A positive partial match needs Arabic input, which `adb input` can't type, so that half rests on the widget tests |
| F4 | error / retry | **N/A on device** | `/catalog/subjects` has no failure path in the mock |
| F5 | offline | **PASS** | airplane + Wi-Fi off: "أنت غير متصل بالإنترنت" banner pinned under the header, and the search field and grid stay (`09_offline`); it clears on reconnect |
| V1 | grid vs `134:3837` (+ dark `337:5702`) | **PASS** | light card (`03`, `04_pair_light`): fill `#FFFFFF`, title **`#384F47`**, chevron **`#517066`**, bar **`#AE87E7`** on **`#ECECEC`**, the frame's values exactly. Dark (`01`, `02_pair_dark`): `#27282C`, `#FCFBF9` title and chevron, `#AE87E7` on `#ECECEC`. 2-column grid, search, Mistakes pill as drawn |
| V2 | university vs `308:4521` | **PASS** | the same card values (`10`): title `#384F47`, chevron `#517066`, `#AE87E7` on `#ECECEC`, fill `#FFFFFF` |
| I1 | chevron points forward, AR and EN | **PASS** | **W07-1 verified on device.** EN: apex on the right (school dark + light, university). AR: apex on the LEFT on the grid card (`05b`), on a Units row (`06b`) and on a Mistakes overview card (`07b`), all three sites of the shared helper. This was device-proven wrong on 2026-09-20 |
| I2 | card tap → tree | **PASS** | school الأحياء → "وحدات الأحياء" Units (`06`); university التشريح → "التشريح Lectures" with the quiz-type tabs (`11`) |

**Score: Functional 3/3 (F2, F4 N/A) · Visual 2/2 · Interaction 2/2 → 7/7 = 100%.**

### W07-6 — the dead back chip on the Subjects root now has a deterministic repro (observation; the plan gives it to Wave 08)

Account tab → Settings → Back → Learn tab, and the Subjects root shows a back chip that does nothing when
tapped. That was reproduced on BOTH tracks this walk: school (after the theme change) and university (after
restoring dark). A fresh entry straight after login shows no chip. The 2026-09-20 tablet pass saw it on
university only and "could not isolate" it; the trigger is visiting a route pushed above the shell
(Settings). `CatalogHeader` draws it `if (GoRouter.canPop())`. The frame draws a back chip on this root too,
so it isn't scored under V1. It's Wave 08's I2.

### Observations, not scored

- `BACK` (keyevent 4) with the search field focused only closes the keyboard; the app stays up. The memory
  that "BACK kills the app" holds for an unfocused screen.
- The chevron glyph is Material's `chevron_right` at 16; the frame's `weui:arrow-filled` is a filled
  chevron in an 8.6 × 17 box. The shape was recorded at implementation and not changed.

### Device state left behind

Airplane mode off, Wi-Fi on, auto-rotate **1** (unchanged; no `monkey`). Debug app: **dark**, **English**,
signed in to the mock as the university student, on the Subjects tab (with the W07-6 chip showing).

## Wave 08 — Subject tree root (`/learn/subject/:subjectId`) — WALK 2026-09-25

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart`
with the Wave 08 changes (validate 1517/0/0). School via OTP `000000`; university via `111111` in a fresh
process. Walked school dark → light → dark and university dark → light → dark, all in English. Frame renders
pulled over the Figma MCP (`349:15962`, `337:5894`, `180:5354`, `180:5208`, `337:11059`). Screens are in the session
scratchpad `walk08/`. Row values come from `treem.py` (fill, hairline, trailing ink + apex, bar runs,
caption ink).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | tree loads, both tracks | **PASS** | school الأحياء → "الأحياء Units", 2 units, drill to Chapters and back (`03`); university التشريح → "التشريح Lectures", 4 tabs, 4 lectures (`10`) |
| F2 | track-specific empty copy | **PASS** | school اللغة العربية → "Nothing here yet" (`04`); university الأنسجة → "No lectures yet" (`12`) |
| F3 | 403 scope copy | **N/A on device** | the mock 403s only for an id outside its lists, and the Android app has no deep links, so no screen can ask for one. Covered by `lectures_screen_test.dart` "403 insufficient_scope gets its own copy and NO retry" |
| F4 | offline | **PASS** | airplane + Wi-Fi off, then open an unfetched subject (الرياضيات): the "You are offline" banner pins under the header and the tree shows (`05`); it clears on reconnect. The mock is in-process, so a FAILED fetch offline can't happen here; the offline error view rests on the widget test |
| V1 | Units vs `135:815` | **PASS** | light (`03`): fill `#FCFBF9`, hairline `#4B675E`, **chevron `#4B675E`** (W08-3 verified), name `#0E0E0E` (#57 ruling), **rows 16.0 dp apart** (W08-5). No bar on units (#16), so rows are 73.9 dp against the frame's 78 |
| V2 | dark vs `337:5894` | **PASS** | dark Units (`07`): `#27282C`, cream hairline, chevron and name `#FCFBF9`, 16.0 dp apart. Also dark Lectures vs `349:15962` (`13`, pair `14`): `#27282C`, chevron `#FCFBF9`, bar `#AE87E7` on `#2E2D32`; only the known search (#17) and Flashcard (#18) gaps |
| V3 | Lectures vs `180:5354` | **PASS** | light (`10`): fill `#FCFBF9`, disc `#F4E6FF`, **bar `#AE87E7` on `#ECECEC` and caption `#AE87E7`** (W08-4 verified), chevron `#4B675E`, rows 16.0 dp apart, **25.1 dp from the tabs to the first row** (W08-5) |
| I1 | rows announce as buttons | **FAIL** | the accessibility tree exposes the Units rows as one `Button` each (`1\nالوحدة الأولى`), but every Lectures row as a **`ProgressBar`** (`37, 1\nالمحاضرة الأولى: مقدمة\n44 / 120 questions`), in light and dark. TalkBack derives the spoken role from this class. **New W08-6**, below. TalkBack itself was not switched on (it is a device accessibility setting) |
| I2 | no dead back chip on the root | **PASS** | **W08-2 / BUG-010 verified.** Account → Settings → theme → Back → Learn, four times: school → light (`02`, cropped), school → dark (`06`), university → light (`09`), university → dark. The root never drew a chip. A fresh root had none either (`01`, `08`), and the chip one level down still went back |
| I3 | tab switch does not refetch | **PASS** | `screenrecord` at 20 fps over Final → Normal → Midterm: the pill animates while row 1's disc and bar stay the same in all 46 frames, so the list never reloads. That no request is sent is the widget test's claim ("selecting a tab does NOT re-fetch the tree") |

**Score: Functional 3/3 (F3 N/A) · Visual 3/3 · Interaction 2/3 → 8/9 = 89%.**

### W08-6 — the Lectures rows are exposed as a progress bar, not a button (fails I1)

`LinearProgressIndicator` wraps itself in `Semantics(role: SemanticsRole.progressBar, minValue: '0',
maxValue: '100', value: …)` (Flutter 3.44.7, `progress_indicator.dart:153-160`). W08-1's `MergeSemantics` folds
that role and range into the row's node alongside the button flag, and on Android the node comes out as
`android.widget.ProgressBar`. The value leads the label ("37, 1, …"). Rows without a bar, the Units and Chapters
rows, are `Button`. The school Lessons rows carry the bar too (Wave 10). **Why the widget test missed it:** it
asserted the `isButton` FLAG, which is set; the Android class comes from the role. **Candidate fix (not applied,
owner's call):** exclude the bar's own semantics inside the row, since the caption already says "44 / 120
questions" in words, and assert that the merged node carries no progress-bar role. Not changed during the walk.

### Observations, not scored

- The Subjects grid cards (Wave 07) are also exposed as `ProgressBar` (`45, الأحياء\n216 / 480 questions`),
  the same mechanism. Recorded only; Wave 07 is closed.
- A Lectures row with a one-line name is 81.9 dp tall against the frame's 78 (the frame uses English names;
  these are Arabic server names). Not investigated.
- The "dark clipped crescents under the uni tabs" noted in COMPARE §11 did not reproduce (`13`, tabs crop).
- On Midterm the rows keep their chevrons, as built for DESIGN_ISSUES #94 (`11`).

### Device state left behind

Airplane mode off, Wi-Fi on, auto-rotate unchanged. Debug app: **dark**, **English**, signed in to the mock as
the university student, on "التشريح Lectures".

## Wave 08 — Subject tree root — RE-WALK after the W08-6 fix, 2026-09-25

Owner: "fix W08-6 in Wave 08 and re-walk". **The fix:** inside `TreeListRow` the bar is wrapped in
`ExcludeSemantics(excluding: caption != null)`. The caption beside it already says the progress in words, so
the merged row node keeps the button flag and loses the bar's `progressBar` role and 0–100 range. A row with a
bar and no caption keeps the bar's semantics, because there it is the only readout; no caller does that today.
Test first: "a row with a bar is still a button, not a progress bar" (`tree_list_row_test.dart`) checks role,
value, min/max, the button flag and the caption in the label. It failed on the walked build
(`role: progressBar`). Validate {VALIDATE}.

Fresh mock build (`walk08r/`), university in dark then light, school in light.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| I1 | rows announce as buttons | **PASS** | **W08-6 verified.** The accessibility tree now exposes every Lectures row as a **`Button`**, in dark (`01`) and light (`02`): `1\nالمحاضرة الأولى: مقدمة\n44 / 120 questions`, with no leading "37". School Units, Chapters and **Lessons** rows (the other rows with a bar) are all `Button` (`03`) |
| V3 | Lectures vs `180:5354` (paint unchanged) | **PASS** | the fix is semantics-only; re-measured: light bar `#AE87E7` on `#ECECEC`, chevron `#4B675E`, disc `#F4E6FF`; dark bar `#AE87E7` on `#2E2D32`, chevron `#FCFBF9` |
| I2 | no dead back chip on the root | **PASS** | re-run once more on university (Settings → Light → Back → Learn): no chip |
| F1 | tree loads, both tracks | **PASS** | both trees loaded on the new build |

F2, F4, V1, V2 and I3 carry over from the first walk: the only change is inside the row's semantics, and none of
them reads it.

**Score: Functional 3/3 (F3 N/A) · Visual 3/3 · Interaction 3/3 → 9/9 = 100%.**

**Not changed, recorded:** the Subjects grid cards (Wave 07) are still exposed as `ProgressBar`, by the same
mechanism.

### Device state left behind

Airplane mode off, Wi-Fi on. Debug app: **light**, **English**, signed in to the mock as the school student, on
"الفصل الأول Lessons".

## Wave 09 — Chapters (`/learn/subject/:subjectId/unit/:unitId`) — WALK 2026-09-25

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart` with the
Wave 09 change (validate 1521/0/0). School student via OTP `000000`, subject الأحياء → unit الوحدة الأولى. Walked
light EN → dark EN → dark AR, then back to light EN. Row values come from `treem.py`, and the screens are in the
session scratchpad `walk09/`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | rows from the cached tree, no refetch | **PASS** | `screenrecord` at 20 fps over Subjects → Units → Chapters. Units shows its skeleton for 4 frames (~200 ms, the mock's 300 ms tree call; `03`). Chapters has **no** skeleton frame: the rows are already there while the page fades in (`02`). That no request is sent is the widget test's claim ("Subjects → Units → Chapters → Lessons costs ONE tree fetch") |
| F2 | unknown unit → empty | **N/A on device** | the Android app has no deep links, and every mock unit has two chapters, so no screen can reach an unknown or empty unit. Covered by `chapters_screen_test.dart` (unknown id; university tree) |
| F3 | row → Lessons | **PASS** | الفصل الأول → "الفصل الأول Lessons" with its 3 lessons; the back chip returns to Chapters |
| V1 | vs `135:1270` | **PASS** | light (`01`): fill `#FCFBF9`, hairline `#4B675E`, chevron `#4B675E`, disc `#F4E6FF` with digit `#0E0E0E`, name `#0E0E0E` (#57). **Rows 16.0 dp apart** (W09-1 verified: 523 → 565 px). Rows 73.9 dp, no bar (#16), as on Units |
| V2 | dark vs `337:6047` | **PASS** | dark (`04`): fill `#27282C`, hairline, chevron, name and digit `#FCFBF9`; disc `#27282C` (the frame's 20% `#27282C` over the same row) with the Glass rim lighter at the edge (`#57585B` / `#67686B`); 16.0 dp apart |
| I1 | AR chevron | **PASS** | Arabic, dark (`05`): the chevron sits at the left end with its apex pointing LEFT on both rows; the back chip is on the right; title "فصول الوحدة الأولى" |
| I2 | row semantics | **PASS** | the accessibility tree exposes each row as one **`Button`** (`1\nالفصل الأول`) in EN and AR. TalkBack itself was not switched on (a device accessibility setting) |

**Score: Functional 2/2 (F2 N/A) · Visual 2/2 · Interaction 2/2 → 6/6 = 100%.**

### Observations, not scored

- Title: the build's "الوحدة الأولى Chapters" vs the frame's singular "… Chapter" (#14, logged).
- Search is not built below Subjects (#17), so the first row sits under the header, not 25 dp below a search field.
- A WhatsApp heads-up covered the first light screenshot. It was deleted and re-shot, and its content is not
  recorded. The raw recording was deleted after its frames were checked; only the two frame sheets are kept.

### Device state left behind

Airplane mode off, Wi-Fi on (untouched). Debug app: **light**, **English**, signed in to the mock as the school
student, on "الوحدة الأولى Chapters".

## Wave 10 — Lessons (`…/unit/:unitId/chapter/:chapterId`) — WALK 2026-09-26

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart` with the
Wave 10 change (validate 1523/0/0; HEAD `634cc34`, a peer's launcher-icon commit, unrelated). School student via OTP
`000000`, الأحياء → الوحدة الأولى → الفصل الأول (lessons 12/40, 40/40, 0/25), plus الوحدة الثانية → الفصل الأول (3/20,
0/0). Walked light EN → dark EN → dark AR, then back to light EN. Row values come from `treem.py` plus a direct
caption crop, and the screens are in the session scratchpad `walk10/`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | counters from the server | **PASS** | every caption is the mock's own pair (`12 / 40`, `40 / 40`, `0 / 25`, `3 / 20`, `0 / 0 questions`), and every bar matches its fraction: 12/40 fills 47.2 of 157.7 dp (0.30), 40/40 is full, 0/25 and 0/0 are track only (`01`, `02`) |
| F2 | always tappable | **PASS** | the finished 40/40 lesson and the 0/0 lesson both open Quiz Setup; every row keeps its chevron |
| F3 | hand-off to setup | **PASS** | Quiz Setup is titled with the tapped lesson's name (الدرس الثاني) under "Select Quiz Size". The lesson id is not visible on screen; "a lesson opens /quiz/setup with its id and name" covers it |
| V1 | vs `135:1485` | **PASS** | light (`01`): fill `#FCFBF9`, hairline `#4B675E`, chevron `#4B675E`, disc `#F4E6FF`, name `#0E0E0E` (#57), **bar `#AE87E7` on `#ECECEC`, caption `#AE87E7`**, **rows 16.0 dp apart** (W10-1 verified: 544 → 586, 801 → 843 px) |
| V2 | dark vs `337:6143` | **PASS** | dark (`03`): fill `#27282C`, hairline, chevron, name and digit `#FCFBF9`, bar `#AE87E7` on `#2E2D32`, caption `#AE87E7`, disc `#27282C` with the Glass rim (`#57585B` / `#67686B`); 16.0 dp apart |
| I1 | AR chevron | **PASS** | Arabic, dark (`04`): the chevrons sit at the left end and point LEFT on all three rows; the bars fill from the right (12/40: 53.3 of 178.3 dp, 0.30); the captions read "12 / 40 سؤال"; the back chip is on the right; title "دروس الفصل الأول" |
| I2 | row semantics | **PASS** | the accessibility tree exposes every lesson row as one **`Button`** (`1\nالدرس الأول\n12 / 40 questions`), with no leading percentage, in EN and AR. TalkBack itself was not switched on |

**Score: Functional 3/3 · Visual 2/2 · Interaction 2/2 → 7/7 = 100%.**

### Observations, not scored

- A lesson row is 81.9 dp tall in EN and 83.8 dp in AR, against the frame's 78. This is the same gap noted for the
  Lectures rows in Wave 08. Not investigated.
- The caption keeps "{a} / {t} questions" where the frame shows "80%" (#16, confirm-only).
- On one pass, a Learn tap right after Settings → Back did not register and needed a second tap. It was a walk
  timing artefact and did not recur.

### Device state left behind

Airplane mode off, Wi-Fi on (untouched). Debug app: **light**, **English**, signed in to the mock as the school
student, on "الفصل الأول Lessons".

## Wave 11 — Quiz setup (`/quiz/setup`) + limit card — WALK 2026-09-26

Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t lib/main_mock.dart` with the
Wave 11 change (validate 1534/0/0; HEAD `634cc34`). School student via OTP `000000`: الأحياء → الوحدة الأولى →
الفصل الأول → الدرس الأول, plus a `0 / 0` lesson and الكيمياء (the mock's paid scope). University student via
`111111` for the caption on a lecture. Walked light EN → dark EN → dark AR, then restored. Values from
`setupm.py` / `cardm2.py` / `px.py` on the screencaps in the session scratchpad `walk11/`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | createQuiz body (lesson + length) | **PASS** | 30 preselected; 10 selected → Start → the quiz opens at "1/10" with 10 questions. The body's `lessonId` is not visible on device; the widget test "school sends the lessonId and the chosen length" covers it |
| F2 | 422 inline | **PASS** | the `0 / 0` lesson at 10 → inline "This lesson doesn't have enough questions for that quiz size. Try a shorter quiz." in `#921119`, no card, no retry (`05`) |
| F3 | 403 → card | **FAIL** | both codes open the card with the right copy: `weekly_question_limit_reached` "Free Usage Reached" (`03`) and `subscription_required` "Subscription Required" (`06`). **But a second 403 from the error state opens TWO cards (W11-6):** the scrim reads `#636363` (two 50% `#313131` layers) against `#969695` for one card (`04` vs `03`), and "Not now" / ✕ must be tapped twice. Reproduced twice; a first 403 on a fresh visit always opens one card |
| F4 | `insufficient_scope` inline | **N/A on device** | the mock returns `insufficient_scope` only on the catalog routes, never on `POST /quizzes`. No setup widget test covers it either (it rides the same inline path as the tested 422) |
| F5 | offline disables Start | **PASS** | airplane + Wi-Fi off: "You are offline" banner, Start `enabled=false`; restored → banner gone, Start enabled (`07`) |
| V1 | vs `135:1622` | **PASS** | light (`01`): subject "الأحياء" `#4B675E` above the scope `#384F47` (**W11-1 verified**); rule `#CCD5D2` ~3 px (1.18 dp); chips idle `#FCFBF9` / `#0E0E0E`, selected `#384F47` / `#FCFBF9`; page `#FCFBF9` |
| V2 | card vs `199:2335` | **FAIL** | shape, size and paint match: centred card 354.3 dp on 411.4 (inset 28.5), radius 22, fill `#FCFBF9`, title `#EF4444` centred, ✕ `#3F3F3F` before it, scrim `#969695` = 50% `#313131` (**W11-4 verified**). **The ✕ does not (W11-5):** its glyph starts 35.4 dp from the card edge against the frame's 27.8, and spans 13.3 dp against 15.3 |
| V3 | dark vs `337:6239` | **PASS** | dark (`08`): subject and scope `#FCFBF9` (**W11-2 verified**, was lavender); rule ~1.3 px (0.5 dp) of 20% `#CCD5D2` over `#232428` (**W11-3 verified**); chips idle `#27282C`, selected `#AE87E7`, labels `#FCFBF9`. Card (`09`): fill `#232428`, title `#EF4444`, ✕ `#FCFBF9`, framework barrier `#101112`, no blur (#74 fallback, as built) |
| I1 | chip selected state + semantics | **PASS** | every chip is a `Button`; `selected=true` on 30 at first, and it moves to 10 on tap (the others `false`); paint follows |
| I2 | ✕ dismisses | **PASS** | ✕ (labelled "Close" / "إغلاق") and "Not now" each dismiss the card back to setup; the AR ✕ sits on the right, before the centred title (`11`) |

**Score: Functional 3/4 (F4 N/A) · Visual 2/3 · Interaction 2/2 → 7/9 = 78%.**

### Defects found

- **W11-5, the ✕ is 7.6 dp inboard and 2 dp small.** Semantics bounds are 48 dp wide, not 35: `IconButton`'s default
  padded tap target (48 dp) overrides the 35 dp constraint, so the 23 dp icon is centred 6.5 dp further in than the
  frame's 35 dp box. `Icons.close` also draws its cross over 14/24 of the icon box (13.4 dp at 23), where the frame's
  `akar-icons:cross` spans 15.3 of 23. The Profile dialog's ✕ has the same 48 dp bounds (seen on the Logout
  confirm), so it likely shares this. Not fixed: the walk changes nothing.
- **W11-6, a repeat 403 stacks two cards.** DEVICE-proven (scrim + double dismiss). Cause, from the source
  (inferred, not run): `QuizSetupNotifier.create` sets `state = const AsyncLoading()`, which Riverpod fills with the
  previous error, and `_onCreationChanged` opens the card whenever `next.error` is a sheet code, loading or not. So
  one card opens on the loading transition and another on the new error. Pre-existing: the listener and notifier are
  unchanged by Wave 11, and the old bottom sheet would have stacked the same way. The tests only ever trip once.

### Observations, not scored

- The second chip is 176 wide in the frames; the build keeps 171 (recorded at implementation).
- Caption on the university track verified too: "التشريح" over "المحاضرة الأولى: مقدمة" (`12`).
- The quiz screen's ✕ close has an empty accessibility label (Wave 12, item 1 already planned).

### Device state left behind

Airplane mode off, Wi-Fi on (toggled for F5 and restored). Debug app: **light**, **English**, signed in to the mock as
the school student, on Home. The mock's weekly counter is at 10 of 50 (in-process; resets on app restart).

### Wave 11 — re-walk after the W11-5 / W11-6 fixes — 2026-09-26

Same Pixel 8, fresh mock build with the fixes (validate 1537/0/0), school student via `000000`. The app came up dark
after the reinstall; walked dark EN → light EN → light AR, restored to light EN. Screens in `walk11b/`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F3 | 403 → card | **PASS** (was FAIL) | **W11-6 verified.** 10 used, then 50 → one card; ✕; Start again from the error state → ONE card. Dark: the two screencaps are byte-identical (`01`, `02`). Light: scrim `#969695` on both trips, not `#636363` (`03`, `04`). One tap on ✕ or "Not now" clears it |
| V2 | card vs `199:2335` | **PASS** (was FAIL) | **W11-5 verified.** The ✕ is the frame's round-capped cross: ink 17.5 dp across (frame 15.33 + a 2.08 stroke = 17.4) starting 26.7 dp from the card edge (frame 24 + 3.83 − 1.04 = 26.8), centre 37.3 dp below the card top; `#3F3F3F` light, `#FCFBF9` dark. Its target is 48 × 48 dp (126 px). AR mirrors it: 26.7 dp from the right edge (`05`). Card, title and scrim unchanged |

The other eight results stand from the first walk (F1, F2, F5, V1, V3, I1, I2 PASS; F4 N/A).

**Score: Functional 4/4 (F4 N/A) · Visual 3/3 · Interaction 2/2 → 9/9 = 100%.**

### New, found on the re-walk (not covered by a criterion)

- **W11-7, the ✕ is now an `ImageView` to TalkBack, not a `Button`.** Regression from the W11-5 fix. On the first walk
  (an `Icon`) the node was `android.widget.Button`; now it is `android.widget.ImageView`, clickable, labelled "Close" /
  "إغلاق". Cause (SOURCE, `vector_graphics` under `SvgPicture`): the glyph wraps itself in `Semantics(image: true)`
  unless `excludeFromSemantics` is set, and the flag merges into the button's node; Android picks ImageView. Same
  mechanism as BUG-011. The app's other SVG buttons (the back chip, the nav tabs) already read as ImageView.

### Device state left behind

Airplane mode off, Wi-Fi on (untouched on the re-walk). Debug app: **light**, **English**, signed in to the mock as
the school student, on Home.

### Wave 11 — W11-7 fix, re-walk of the ✕ — 2026-09-26

Same Pixel 8, fresh mock build with the fix (validate 1538/0/0), school student via `000000`. The card was tripped
with the الكيمياء lesson (`subscription_required`, same card). Light EN, then dark AR, restored to light EN on Home.
Screens and raw uiautomator dumps in `walk11c/` (status bar masked).

| Check | Result | Evidence |
| --- | --- | --- |
| ✕ role (W11-7) | **PASS** | `class="android.widget.Button"`, clickable, focusable, `content-desc="Close"` (EN, `ui_card_en.xml`) and `"إغلاق"` (AR, `ui_card_ar_dark.xml`). Was `ImageView` on the previous re-walk |
| ✕ position and size (W11-5 holds) | **PASS** | Target 126 px = 48 dp both locales. Glyph ink 17.5 × 17.5 dp, 26.7 dp from the card's start edge (left in EN, right in AR). `#3F3F3F` light, `#FCFBF9` dark (`01`, `02`) |
| One card, one tap (W11-6 holds) | **PASS** | ✕ closed the card in one tap, twice in a row in EN and once in AR; light scrim `#969695` |
| Card | unchanged | Fill `#FCFBF9` / `#232428`, 354 dp wide, title `#EF4444` centred |

Wave 11 score stays **100%** (F 4/4, F4 N/A · V 3/3 · I 2/2). W11-7 closed.

### Device state left behind

Airplane mode off, Wi-Fi on (untouched). Debug app: **light**, **English**, signed in to the mock as the school
student, on Home.

## Wave 12 — Quiz question (`/quiz/:quizId`) — WALK 2026-09-26

Owner "WALK 12 & 13". Pixel 8 (`45131FDJH0009G`, 1080×2400, 2.625 px/dp), `flutter build apk --debug -t
lib/main_mock.dart` with the Wave 12 change (validate 1558/0/0; HEAD `634cc34`), plus the walk-only FLAG_SECURE
override in `lib/main_mock.dart` (applied for the build, then restored byte-identical before install; never
committed). School student via OTP `000000`: الأحياء → الوحدة الأولى → الفصل الأول → الدرس الأول → 10 questions.
Run 1 light EN; run 2 dark AR (a second 10-question quiz). Values from `w12m.py` / `px.py` on the screencaps in the
session scratchpad `walk12/` (status bar masked).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | answer submit + grade | **PASS** | Q1 option A → "Your answer, incorrect" on A, "Correct answer" on B, red / green tiles (`02`); all 10 graded on both runs |
| F2 | idempotent retry | **N/A on device** | the mock answers in-process, so a submit cannot fail (airplane mode never reaches it). Covered by the bloc tests |
| F3 | 409 no retry | **N/A on device** | no mock trigger for `quiz_already_finished`. Covered by the bloc and predicate tests |
| F4 | explanation poll → text | **PASS** | "Generating your explanation…" (`03`), then the text (`04`); same in AR dark (`08`) |
| F5 | explanation 403 per ruling | **N/A on device** | no mock trigger for an explanation `subscription_required`. Covered by the screen tests |
| F6 | finish → result | **PASS** | Finish on 10/10 → the result screen, both runs |
| V1 | vs `159:845` | **PASS** | ✕ `#384F47`, 17.1 dp of ink centred in its 48 dp target at (30.9, 81.1) dp (**W12-1**); bar `#AE87E7` on `#ECECEC` (**W12-8**); counter `#7070A0` (**W12-9**); rule 3 px `#EFE8F8` = rgba(124,58,237,0.1) on `#FCFBF9` (**W12-7**); header 89.3 dp; rule → card 24.8 dp, card → options 22.1 dp (**W12-11**); question text `#384F47` (**W12-10**); card hairline `#4B675E` (`01`) |
| V2 | AI panel vs `159:1695` | **PASS** | glyph `ai_education` and title `#384F47`, body `#7070A0`, one section (S17) (**W12-3**, `04`). Dark: glyph and title `#FCFBF9` (**W12-4**, `08`) |
| V3 | photo vs `216:2973` | **PASS** | Q4: the image sits above the card, 24.8 dp under the rule and 21.7 dp over the card, with the hairline edge; whole image, 208.8 dp tall for this picture (#96) (**W12-6**, `05`) |
| V4 | dark tiles (#87 excluded) | **PASS** | dark AR (`07`): tiles `#27282C` with a lavender hairline (`#6A5789` = rgba(174,135,231,0.5) on `#27282C`); ✕ `#FCFBF9` on the right; question text `#FCFBF9`; bar `#AE87E7` on `#2E2D32`; rule `#2C263C` = the same rgba on `#232428` |
| I1 | ✕ announced | **PASS** | `Button` "Close" / "إغلاق", 126 px = 48 dp, left edge in EN, right edge in AR |
| I2 | exit guard | **PASS** | ✕ on Q4 → "Leave this quiz?" (`06`); "Keep going" returns to Q4 with its state |

**Score: Functional 3/3 (F2, F3, F5 N/A) · Visual 4/4 · Interaction 2/2 → 9/9 = 100%.**

### Observations, not scored

- Q3 (every third mock question) draws no AI panel; "Previous page" appears from Q2.
- The walk changed nothing.

## Wave 13 — Quiz result (`/quiz/:quizId/result`) — BASELINE WALK 2026-09-26

Same build and runs as Wave 12 above (Wave 13 not built yet: this scores the screen as it stands). Frames
`159:1964` and dark `337:6628`. Screens in `walk13/` (status bar masked).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | buckets from `QuizSummary` | **PASS** | 2 Correct / 8 Wrong / 20% after 10 answered; Review lists the same 10 rows, Q4 and Q8 correct; no Skipped card (all answered) (`01`, `02`) |
| F2 | back → `/learn` | **PASS** | the back chip → Subjects (the Learn root); Review's back returns to the result first |
| F3 | Review opens with session args | **PASS** | "Review Questions" → Quiz Review "All (10)" with this session's rows and grades (`02`) |
| V1 | ring vs frame | **FAIL** | light ring `#384F47` on `#ECECEC`, filling clockwise; the frame draws a lavender arc. Outer 192 dp and stroke 11.8 dp. "20%" `#0E0E0E` (frame `#3D3D3D`) |
| V2 | rewards runs | **FAIL** | one run "+2 Points" in `#384F47`; the frame has "+200" bold `#AE87E7` and "Points" regular `#010101`. "REWARDS EARNED" `#7070A0` (frame `#AE87E7`) |
| V3 | CTA icon | **FAIL** | "Review Questions" is text-only; the frame leads with the `ai-education` icon |
| V4 | dark vs `337:6628` | **FAIL** | the dark ring `#AE87E7` on `#2E2D32`, cream title and figure, lavender CTA all match, but the light gaps repeat: no subtitle subject, no header rule, "النقاط المكتسبة" `#7070A0`, one run, no CTA icon (`03`) |
| I1 | `+N` correct in AR | **FAIL** | "+2 نقطة": the "2" paints at x 813–840 and the "+" at x 847–873, so it reads "2+" (BUG-003) (`03`) |
| I2 | back labelled | **PASS** | "Back" / "رجوع", clickable. Its class is `ImageView`, not `Button` (below) |

**Score (baseline): Functional 3/3 · Visual 0/4 · Interaction 1/2 → 4/9 = 44%.**

### Also seen, feeding the build

- Header: title `#0E0E0E` (frame `#384F47`); scope only, centred in `#2C2C2C` below the bar (frame: "Subject — Scope"
  in `#4B675E` inside the header); no rule (frame rgba(124,58,237,0.1) at 1.18).
- A "Back to Learn" text button under the CTA; the frames have none.
- The back chip is an `ImageView` to TalkBack on every screen that uses it (Result, Review, Settings, Setup, the
  catalog). Same mechanism as W11-7: the chevron `SvgPicture` merges `image: true` into the labelled button.

### Device state left behind

Airplane mode off, Wi-Fi on (untouched). Debug app: **light**, **English** (switched to dark AR in the app's own
Settings for run 2 and switched back), signed in to the mock as the school student, on Home. The installed APK still
carries the walk-only screenshot override; the source is restored and the next build replaces it.

### Wave 13 — re-walk after the build — 2026-09-26

Owner "WALK 13". Same Pixel 8, fresh `flutter build apk --debug -t lib/main_mock.dart` with Wave 13 (validate
1576/0/0; HEAD `634cc34`), plus the walk-only FLAG_SECURE override (applied for the build, restored byte-identical
before install, blob `f189786`; never committed). School student via OTP `000000`: الأحياء → الوحدة الأولى → الفصل
الأول → الدرس الأول → 10 questions. Run 1 light EN (option A throughout); run 2 dark AR (option B). Values from
`w13m.py` / `w13ring.py` on the screencaps and raw uiautomator dumps in the session scratchpad `walk13b/` (status
bar masked).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | buckets from `QuizSummary` | **PASS** | EN: 2 Correct / 8 Wrong / 20%; AR: 3 / 7 / 30%. No Skipped card (all answered). The profile's total went 1,250 → 1,252 after "+2" (the server's figure, displayed) |
| F2 | back → `/learn` | **PASS** | the chip → Subjects (the Learn root) in both languages; Review's back returns to the result first |
| F3 | Review opens with session args | **PASS** | "Review Questions" → Quiz Review "All (10)", this session's grades (Q4 and Q8 correct) (`02`) |
| V1 | ring vs `159:1964` | **PASS** (was FAIL) | **W13-4:** outer 192.0 dp, stroke 9.90 dp (frame 9.846), track `#ECECEC`; the arc runs **anticlockwise** from 12 o'clock to 72° (20%), `#A884E1` at the start to `#8E7BC3` at the end (the export's gradient); clockwise side is track. Figure `#3D3D3D`. **W13-2:** title `#384F47`, subtitle "الأحياء — الدرس الأول" `#4B675E`, rule `#EFE8F8` (rgba(124,58,237,0.1) on `#FCFBF9`), header 92.2 dp, chip 20.95 dp in, centred 46.1 dp down. **W13-3:** rule → ring 17.9, ring → buckets 24.8, buckets → rewards 24.8, rewards → CTA 24.8 dp. **W13-5:** labels `#384F47` (`01`) |
| V2 | rewards runs | **PASS** (was FAIL) | **W13-6:** "REWARDS EARNED" `#AE87E7`; star `#7070A0` in its disc; "+2" `#AE87E7` and "Points" `#010101`, two runs; TalkBack reads one node, "+2 Points" (`01`) |
| V3 | CTA icon | **PASS** (was FAIL) | **W13-7:** the `ai-education` glyph leads "Review Questions", ink `#FCFBF9` on `#384F47`; on the label's right in AR. **W13-8:** no "Back to Learn" in either run |
| V4 | dark vs `337:6628` | **PASS** (was FAIL) | dark AR (`03`): title `#FCFBF9`, subtitle `#EEEEEE`, rule `#2C263C`; the ring the same gradient on `#2E2D32`, anticlockwise to 108° (30%) in Arabic too (D-016); figure and labels `#FCFBF9`; "النقاط المكتسبة" `#AE87E7`; "+3" `#AE87E7`, "نقطة" `#FCFBF9`; star `#7070A0`; CTA glyph `#FCFBF9` on `#AE87E7`. Gaps 18.3 / 24.8 / 24.4 / 24.8 dp. Header 93.0 dp (the Arabic title line is 0.8 dp taller; the frames are English) |
| I1 | `+N` correct in AR | **PASS** (was FAIL) | **BUG-003 device-verified.** "+3 نقطة": the "+" (26 px tall, a full cross) paints at x 818–842 and the "3" (39 px) at x 850–877, so it reads "+3". Baseline: "2" at 813–840, "+" at 847–873 |
| I2 | back labelled | **PASS** | **BUG-013 device-verified.** `android.widget.Button`, clickable, "Back" (`ui_result_en.xml`) / "رجوع" (`ui_result_ar_dark.xml`); start edge in each language, chevron mirrored. Baseline: `ImageView` |

**Score: Functional 3/3 · Visual 4/4 · Interaction 2/2 → 9/9 = 100%** (baseline 44%).

### Observations, not scored

- The shared chip is a `Button` on every screen the walk passed through: OTP, Review, Settings, Quiz Setup, the
  catalog screens (BUG-013's reach).
- **Text scale 1.3 not run on the phone:** it needs the system font-size setting changed, which the walk rules
  exclude. The screen test "the rewards row survives a large text scale" pumps the whole result, three buckets
  (8 of 10 answered), at 1.0 / 1.3 / 2.0 / 3.0 on 375 × 812 and fails on any overflow; it passes.
- A Skipped bucket did not come up on device (every question was answered); the tests cover it.
- **Wave 14 lead (Review, not this screen):** each row's TalkBack label carries the stem's raw markup
  ("…يصف <u>التركيب</u> بشكل صحيح؟"), and the Arabic stem truncates at its start with the ellipsis on the left in
  English (`02`). Not investigated.

### Device state left behind

Airplane mode off, Wi-Fi on (untouched). Debug app: **light**, **English** (switched to dark AR in the app's own
Settings for run 2 and switched back), signed in to the mock as the school student, on Home. The installed APK
carries the walk-only screenshot override; the source is restored and the next build replaces it.

## Wave 14 — Quiz review (`/quiz/:quizId/result/review`) — WALK 2026-09-27

Owner "WALK 14". Pixel 8 (`45131FDJH0009G`, 2.625 px/dp). Build 1: `flutter build apk --debug -t lib/main_mock.dart`
with Wave 14 (validate 1609/0/0; HEAD `634cc34`) plus the walk-only FLAG_SECURE override (applied for the build,
restored byte-identical before install, blob `f189786`; never committed). Build 2, for F3: the same source with NO
override. School student via OTP `000000`: الأحياء → الوحدة الأولى → الفصل الأول → الدرس الأول → 10 questions. Run 1
light EN (option A), run 2 dark AR (option B), run 3 dark AR on build 2. Values from `w14m.py` / `w14row.py` on the
screencaps and raw uiautomator dumps in the session scratchpad `walk14/` (status bar masked). Frames `162:2377`,
dark `337:6705`, RTL `549:20324`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | All / Correct / Wrong filters | **PASS** | Correct → Q4, Q8 only; Wrong → Q1–3, 5–7, 9, 10; All → back, `selected` moves with the tap (uiautomator). The selected pill turns `#4B675E` with a cream label (`03`) |
| F2 | skipped rows neutral | **N/A on device** | the quiz UI cannot skip: Confirm is required before Next, and Finish appears only after the last question is graded (`quiz_screen.dart` `_ActionBar`). Covered by the review tests (q5 of the compact fixture) |
| F3 | FLAG_SECURE on / off | **PASS** | build 2, dark AR: the result screencap is normal (145 KB), Review's is 100% `#000000` (30 KB), and the result after Back is normal again (`f3_1`–`f3_3`) |
| V1 | vs `162:2377` | **PASS** | **W14-2:** header 62.9 dp to the rule's bottom, rule `#EFE8F8`, chip 20.95 dp in, title `#000000` (was `#0E0E0E`). **W14-3:** pills 25.1 under the rule, **32.0 tall** (were 48), 8.0 apart (21 px), first row 14.1 below. **W14-4:** discs 16.0 × 16.0 (`#22C55E` / `#EF4444`, light glyph), idle labels `#384F47`. **W14-5:** rows 19 apart (18.7 between antialiased edges), 73.1 tall, badge 8.8 in with no dark ring, label 4.2 after it (3.5 + side bearing). **W14-6:** label `#4B675E`, question `#384F47` on wrong and correct rows. **W14-7:** glyph ink 24.4 × 23.2 at 11.4 down, 12.2 in (frame render 24.8 × 22.8 at 12.1, 11.3), `#384F47` (`02`) |
| V2 | dark vs `337:6705` | **PASS** | dark AR (`05`): rule `#2C263C`, title `#FCFBF9`; selected "الكل (10)" `#AE87E7` with the `#232428` label (#54); idle chips glassed, discs, cream labels; rows glassed, label and question cream (owner ruling, not lavender); glyph cream |
| V3 | RTL vs `549:20324` | **PASS** (as ruled, #58) | mirrored: chips run right → left, back chip on the right, badge 9.1 in from the RIGHT edge, label ending 4.6 before it, glyph 10.7 in from the LEFT edge; the frame's unmirrored rows are the known #58 gap |
| I1 | filter chips 48 dp | **PASS** | each chip's tap target 126 px = 48 dp (`All (10)` 342–468), the pill 32 inside it; `android.widget.Button`, `selected` true on the active one |
| I2 | back labelled | **PASS** | `Button` "Back" / "رجوع", start edge in each language |

**Score: Functional 2/2 (F2 N/A) · Visual 3/3 · Interaction 2/2 → 7/7 = 100%.**

### Also verified

- **BUG-014 (device).** An Arabic stem in the English app now ellipsizes at its own end: "السؤال 1: أي من الخيارات
  التالية يصف ال…" reads from the right with the ellipsis on the left (`02`); the quiz page lays the same stem out
  RTL with "؟" at its end (`01`). No row label and no stem carries `<u>` or `</u>` (both dumps); the English app's
  labels wrap the Arabic stem in U+202B / U+202C, Flutter's embedding marks, which TalkBack does not speak.

### New, found on the walk (not covered by a criterion)

- **W14-10, the underline is invisible on Arabic stems.** The tags are gone and the span carries the underline, but
  nothing shows under "التركيب" (`01_zoom_word`). Cause: the Arabic falls back to Tajawal, whose Medium and Bold
  files declare `underlinePosition` −4 and `underlineThickness` 3 per 1000 em (Regular: −75 / 50; Inter: −294 / 175
  per 2048). At the stem's 18 × 2.625 px that is a 0.14 px line on the baseline, under the joined letters. A
  real-font render of the same widget (`w14/probe_h3_w600.png`) shows the same hairline. English stems (Inter) and
  Tajawal Regular underline normally.
- **Arabic lines are taller than the scale's.** A line mixing Inter (digits, colon, ellipsis) and Tajawal takes
  Inter's scaled ascent and Tajawal's scaled descent: the 24 question line lays out about 27.8. Light EN rows stay
  73.1 with the text block 1.9 dp above the frame's lines; dark AR rows grow to 76.2 (the Arabic label line grows
  too). App-wide (Inter primary, Tajawal fallback), not this screen's.

### Device state left behind

Airplane mode off, Wi-Fi on (untouched). Debug app: **light**, **English** (switched to dark AR in the app's own
Settings for runs 2–3 and switched back), signed in to the mock as the school student, on Home. The installed APK
is build 2 (no walk override).

## Wave 15 — Mistakes overview (`/learn/mistakes`) — WALK 2026-09-27

Owner "WALK15". Pixel 8 (`45131FDJH0009G`, 2.625 px/dp, 411.4 dp wide). `flutter build apk --debug -t
lib/main_mock.dart` with Wave 15 (validate 1620/0/0; HEAD `634cc34`), no walk override (the Mistakes screens set
no FLAG_SECURE; `main_mock.dart` blob `f189786`, untouched). School student via OTP `000000`, Learn → Mistakes. Run
1 light EN, offline in light EN, run 2 dark EN, run 3 dark AR. Values from `w15m.py` and pixel reads on the
screencaps and raw uiautomator dumps in the session scratchpad `walk15/` (status bar masked). Frames `404:6292`,
dark `404:7428`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | cards in server order | **PASS** | الكيمياء 1 · الفيزياء 2 · الأحياء 7 · الرياضيات 34 · الجغرافيا 100 · اللغة العربية 5, the mock's order, left → right in English and right → left in Arabic; Arabic plurals خطأ واحد / خطآن / 7 أخطاء / 34 خطأً / 100 خطأ. Tapping الأحياء opens "الأحياء Units" (its tree), Back returns (`01`, `04`) |
| F2 | empty = happy-path copy | **N/A on device** | the mock always answers 6 school / 4 university subjects; there is no empty overview to reach. Covered by the widget tests |
| F3 | error / retry | **N/A on device** | the mock answers in-process and has no error trigger for `GET /me/mistakes`. Covered by the widget tests |
| F4 | offline | **PASS** | airplane + Wi-Fi off: "You are offline" pins under the header and the cards stay (`02`); it clears on reconnect |
| V1 | vs `404:6292` | **PASS** | **W15-2:** first row 25.14 under the header. Cards 177.1–177.5 wide (the width scales with the phone), **89.14 tall**, rows 17.9 apart, columns 16.76 (pixel-rounded 16.5), margins 20.2 / 19.8; fill `#EAD5D5`. **W15-3:** chevron ink 7.6–8.0 × 14.1 at 36.95 from the card's top, 13.71 from its end (frame 7.98 × 14.32 at 37.56, 13.68), `#517066`. **W15-4:** count ink top 56.00 (frame 56.56), text 9.5 in; title `#384F47`, count `#EF4444`. The header title is #99 (logged). The row with a two-word name is 92.95: W15-6 below (`01`) |
| V2 | dark vs `404:7428` | **PASS** | page `#232428` (frame same), card `#242529` (frame `#252529`) with the glass rim (top edge `#616265`, frame `#4F5054`: the known rim-brightness item), title `#FCFBF9`, count `#EF4444`, chevron cream at the light geometry (`03`) |
| I1 | card announced as a button | **PASS** | every card is one `android.widget.Button`, clickable, label "name\nN mistakes" (EN) / "name\nعدد" (AR); no separate text nodes |
| I2 | no overflow AR 1.3× | **N/A on device** | 1.3× needs the system font scale, which is the owner's to change. At 1.0 in Arabic nothing overflows (no stripes; `logcat -s flutter` has no overflow or exception). 1.3 and 2.0 are covered by the four BUG-002 tests |
| I3 | AR chevron | **PASS** | points left, ink 13.71 from the card's LEFT edge (the English end inset mirrored), cream; the title starts 10.7–11.1 from the right (`04`) |

**Score: Functional 2/2 (F2, F3 N/A) · Visual 2/2 · Interaction 2/2 (I2 N/A) → 6/6 = 100%.**

### New, found on the walk (not covered by a criterion)

- **W15-6, a two-word Arabic name makes its row taller.** In English, rows with one-word Arabic names are 89.14
  (the frame's 89), but the row with "اللغة العربية" is **92.95**, and that card's title and count sit 3.8 and 4.2
  lower than in its neighbour (`01`). In Arabic the rows are 92.19 / 91.81 (the counts "خطأ واحد" and "7 أخطاء"
  mix scripts too) and **96.00** for that row (`04`). DECISIONS D-018 estimated 90–91 in Arabic from a render; the
  device says 92–96. Likely cause, inferred and not probed: the space is drawn in Inter (the primary font), so the
  line takes Inter's ascent and Tajawal's descent, the app-wide effect the Wave 14 walk measured. Nothing overflows;
  the card grows as D-018 allows. The frame draws only English names ("Biology", "Chemistry"), so no frame shows
  this. Owner's call: accept, pin this card's lines to the scale's line height, or fix mixed-font lines app-wide.

### Device state left behind

Airplane mode off, Wi-Fi on (checked before and after the offline step). Debug app: **light**, **English** (switched
to dark, then Arabic, in the app's own Settings and switched back), signed in to the mock as the school student, on
Home. `/sdcard/ui.xml` removed.

## Wave 15 — Mistakes overview — SECOND WALK 2026-09-27 (same build, same Pixel 8)

Owner `WALK` again. Nothing had changed since the first walk: the same APK, `main_mock.dart` blob `f189786`, the
phone's font scale still 1.0 (read, not changed). So this walk covered the combinations the first did not: the
university student (OTP `111111`), light EN and light AR. Screencaps and dumps in the scratchpad `walk15b/` (status
bar masked).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | cards in server order | **PASS** | التشريح 3 · الفسيولوجي 1 · الكيمياء الحيوية 12 · الأنسجة 2, the mock's university order; right → left in Arabic with its plurals (3 أخطاء / خطأ واحد / 12 خطأً / خطآن). Tapping الأنسجة opens "محاضرات الأنسجة" (`01`, `02`) |
| V1 | vs `404:6292` (and the university `404:7110`, the same drawing) | **PASS** | 25.14 under the header, rows 89.14 for one-word names, 17.9 apart, columns 16.76, fill `#EAD5D5`, count ink top 56.00, chevron 7.6–8.0 × 14.1 at 36.95, 13.71 from the end, `#517066` (`01`) |
| I1 | card announced as a button | **PASS** | four `android.widget.Button`s, each with the merged label, EN and AR |
| I3 | AR chevron (light) | **PASS** | `#517066`, points left, 13.71 from the card's LEFT edge (`02`) |

F4, V2 and the N/A items (F2, F3, I2) stand from the first walk. `logcat -s flutter`: no overflow, no exception.
**Score unchanged: 100%.**

- **W15-6 reproduced** with a second two-word name: "الكيمياء الحيوية" makes its row 92.95 in English (title and count
  3.8 and 4.2 lower than in its neighbour) and 96.00 in Arabic, the same +3.8 as "اللغة العربية" on the school list.
- **The empty tree behind الأنسجة is intended:** the mock leaves `uni-histology` out of its trees on purpose ("same
  purpose as sub-arabic"), so the Mistakes subject screen's empty state is reachable. That screen is Wave 16's.

### Device state left behind

Airplane mode off, Wi-Fi on, font scale 1.0 (all read only). Debug app: **light**, **English** (Arabic set and
reset in the app's own Settings), signed in to the mock as the **university** student, on Home. `/sdcard/ui.xml`
removed.

## Wave 16 — Mistakes subject (`/learn/mistakes/subject/:subjectId`) — WALK 2026-09-27

Owner `WALK`. Pixel 8 (`45131FDJH0009G`, 2.625 px/dp, 411.4 dp wide). `flutter build apk --debug -t
lib/main_mock.dart` with Wave 16 (validate 1631/0/0; HEAD `634cc34`), no walk override (`main_mock.dart` blob
`f189786`, untouched); font scale 1.0 (read, not changed). School student (OTP `000000`): Learn → Mistakes → الأحياء
in light EN, dark EN, dark AR and light AR, and اللغة العربية for the empty tree. University student (OTP `111111`):
الكيمياء الحيوية in light EN and dark EN, الأنسجة for the empty tree, التشريح offline. Values from `w16m.py`, run on
the screencaps and raw uiautomator dumps and on the frames' 1× renders alike, and from a 20 fps `screenrecord`, all in
the session scratchpad `walk16/` (status bar masked). Frames `404:6539`, `404:7181`, dark `404:8686`, rows `404:6642`
and `404:7765`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | tree by track | **PASS** | school: "الأحياء Units", two unit rows, each drilling to its Chapters; university: "الكيمياء الحيوية Lectures", three flat lecture rows and no quiz-type tabs (`01`, `06`). While the tree loads, the header shows the bare subject name, then the track's title (recording) |
| F2 | unknown id → empty | **PASS** | the mock leaves `sub-arabic` and `uni-histology` out of its trees: both answer an empty tree, "No mistakes yet", no error and no retry (`02`, `08`) |
| F3 | decay: one fetch per visit | **PASS** | `screenrecord` at 20 fps (`decay/`, contact sheets `sheet_*.png`): entering الأحياء shows the skeleton for 5 frames (~250 ms, the mock's 300 ms call), then the rows; Units → Chapters and back to Units show the rows at once, with no skeleton; Back to the overview and in again shows the skeleton again (4 frames), so the `autoDispose` tree was dropped and fetched anew. That exactly one request is sent per visit is the widget tests' claim |
| V1 | vs `404:6539` | **PASS** | **W16-1:** first row 25.14 under the header, rows 16.00 apart, margins 20.2 / 19.8. **W16-3:** the chevron's ink ends 21.71 from the row's end (frame 22.0). **W16-4:** chevron `#4B675E` (frame `#4B675E`). **W16-5:** disc `#F4E6FF`, 40 × 40, 17.1 from the start (frame the same). Fill `#EAD5D5`, name `#384F47`, count `#EF4444`, both starting 69.7–70.1 from the start (frame 70.0). **W16-2:** the insets hold, but the row is **81.90–82.29**, not 78, because every mock name is two Arabic words (W16-6 below): the count's ink top is 44.95 (frame 42.0), the badge and chevron centred at 38.9 (frame 37.0) (`01`) |
| V2 | university vs `404:7181` | **PASS** | the lecture rows carry V1's values: 25.14 under the header, 16.00 apart, disc `#F4E6FF` at 17.1, name `#384F47`, count `#EF4444`; no chevron (the frame draws one; the leaf is inert by the owner's 2026-09-12 ruling); rows 81.90–82.29 (W16-6) (`06`) |
| V3 | dark vs `404:8686` | **PASS** | page `#232428` and row `#27282C` (the frame's own), name, numeral and chevron `#FCFBF9`, count `#EF4444`, the disc's Glass rim; the light geometry (25.14, 16.00, chevron end 21.71) on Units (`03`) and on Lectures (`07`). The dark frames' first row sets its text lower (#68); the build follows the majority |
| I1 | Units rows are buttons | **PASS** | each row is one `android.widget.Button`, clickable, labelled "1\nالوحدة الأولى\n4 mistakes" (EN) or "…\n4 أخطاء" (AR), with no separate text nodes (`ui_units_*.xml`) |
| I2 | lecture leaf inert | **PASS** | each lecture row is one `android.view.View`, `clickable=false`, with the merged label; no chevron is drawn; tapping a row leaves the screen as it was (`ui_lectures_en_light.xml`) |

**Score: Functional 3/3 · Visual 3/3 · Interaction 2/2 → 8/8 = 100%.**

Also checked, outside the criteria:
- **Arabic** (dark `04`, light `05`): mirrored. The badge sits 17.1 from the RIGHT, the chevron's ink 20.95 from the
  LEFT, pointing left; the name starts 70.5 from the right; the count stays under the name (ink top 43.43, name ink
  bottom 38.48). Header "وحدات الأحياء", back chip on the right.
- **Offline** (`09`, university dark): airplane mode on → "You are offline" pins under the header and the rows stay;
  it clears on reconnect.
- `logcat -s flutter`: no overflow, no exception.

### New, found on the walk (not covered by a criterion)

- **W16-6, the rows are 82 dp, not 78, because the mock's names are two Arabic words.** Every unit and lecture name
  in the mock ("الوحدة الأولى", "المحاضرة الأولى", …) is two words. The rows measure 81.90–82.29 in English and 84.95 in
  Arabic, where the count "4 أخطاء" mixes scripts too. A real-font render (a throwaway probe, deleted;
  `walk16/probe_names.txt`) isolates the trigger. "Cell Biology" and the one-word "الأحياء" give 78.00, with the
  lines on 28.0 / 46.5, while "الوحدة الأولى" makes the name line taller (25 against 24 in the test engine; on the
  device +3.9, like W15-6's +3.8), and in Arabic the count line grows too. This is W15-6's mechanism (the Inter space
  in a Tajawal line) on the tree rows; the frames draw only English names. Effect: the count's ink sits 2.95 lower
  than the frame's, the badge and chevron 1.9 lower; nothing overflows. The catalog rows hide it (their text block is
  shorter than the 40-dp badge; rows 73.9). It folds into the owner's W15-6 decision. Nothing was changed.
- **The row chevron's glyph** is Material's filled `chevron_right` (ink 8.38 × 13.71); the frame's is a 1.33 stroke
  (8 × 15.3). It ends where the frame's does and has its colour, and is 1.6 dp shorter. The catalog rows (walked
  100%) draw the same glyph. Recorded, not logged as a defect.

### Device state left behind

Airplane mode off, Wi-Fi on (read before and after the offline step), font scale 1.0 (read only). Debug app:
**light**, **English** (dark and Arabic set and reset in the app's own Settings), signed in to the mock as the
**university** student, on Home. `/sdcard/ui.xml` and the recording removed.

## Wave 17 — Mistakes chapters (`/learn/mistakes/subject/:subjectId/unit/:unitId`) — WALK 2026-09-27

Owner `WALK`. Pixel 8 (`45131FDJH0009G`, 2.625 px/dp, 411.4 dp wide). `flutter build apk --debug -t
lib/main_mock.dart` with Wave 17 (validate 1639/0/0; HEAD `634cc34`), no walk override (`main_mock.dart` blob
`f189786`, untouched); font scale 1.0 (read, not changed). School student (OTP `000000`): Learn → Mistakes → الأحياء →
الوحدة الأولى in light EN, dark EN, dark AR and light AR, and offline in light AR. Values from `w16m.py`, run on the
screencaps and raw uiautomator dumps and on the frames' 1× renders alike, and from a 20 fps `screenrecord`, all in
the session scratchpad `walk17/` (status bar masked). Frames `404:6677`, dark `404:7894`.

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | cached view | **PASS** | `screenrecord` at 20 fps (`rec/`, contact sheets `sheet_*.png`): entering الأحياء shows the skeleton (5 frames, the tree's one fetch); Units → الوحدة الأولى Chapters, back, and → الوحدة الثانية Chapters each show the rows through the whole transition, with no skeleton. The header title is the unit's ("الوحدة الأولى Chapters") from the first frame |
| F2 | unknown unit → empty | **N/A on device** | the Android app has no deep links, and every mock unit is in its tree, so no screen can ask for an unknown unit. Covered by the Wave 17 test "a unit the tree does not have is EMPTY, not an error, and costs no second fetch" in `mistakes_screens_test.dart` |
| V1 | vs `404:6677` | **PASS** | **W17-1:** first row 25.14 under the header (frame 25), rows 16.00 apart (frame 16), margins 20.2 / 19.8. The rows carry Wave 16's values: disc `#F4E6FF`, 40 × 40, 17.1 from the start (frame 17.0); chevron `#4B675E`, ink ending 21.71 from the end (frame 22.0); fill `#EAD5D5`; name `#384F47` (frame `#000000`, the #68 ruling) and count `#EF4444`, both from 69.7–70.1 (frame 70). Rows **81.90–82.29**, not 78: W16-6 (`01`) |
| V2 | dark vs `404:7894` | **PASS** | page `#232428` and row `#27282C` (the frame's own); name, numeral and chevron `#FCFBF9`, count `#EF4444`, the disc's Glass rim; the light geometry (25.14, 16.00, chevron end 21.71). The frame's first row sets its text lower and its second the count (#68 update); the build follows the light rows (`02`) |
| I1 | AR chevron | **PASS** | dark `03` and light `04`: mirrored. The badge 17.1 from the RIGHT, the chevron's ink 20.95 from the LEFT, pointing left; the name from 70.5 on the right; header "فصول الوحدة الأولى", back chip on the right. Rows 84.95 (W16-6, as on Units) |
| I2 | row semantics | **PASS** | each row is one `android.widget.Button`, clickable, labelled "1\nالفصل الأول\n3 mistakes" / "2\nالفصل الثاني\n1 mistake" (AR "3 أخطاء" / "خطأ واحد"), with no separate text nodes (`ui_chapters_*.xml`). Tapping a row opens that chapter's Lessons ("الفصل الأول Lessons", "الفصل الثاني Lessons") |

**Score: Functional 1/1 (F2 N/A) · Visual 2/2 · Interaction 2/2 → 5/5 = 100%.**

Also checked, outside the criteria:
- **Offline** (`05`, light AR): airplane mode on → "أنت غير متصل بالإنترنت" pins under the header and the rows stay;
  it clears on reconnect.
- **Title and count copy** match the build's strings: the frame's singular "Cell Biology Chapter" is the open copy
  question (#14), its "3 questions" the logged count copy (#59, #66), its 22-SemiBold title #99.
- `logcat -s flutter`: no overflow, no exception.
- Side by side with both frames: `pair_device_vs_frames.png`.

### Recorded (not logged as a defect)

- **One lost tap.** The first tap on the second row (540, 707) left the screen unchanged. Four later taps on the same
  point, two of them after an identical screencap + uiautomator dump + 5 s wait, each opened "الفصل الثاني Lessons";
  logcat has nothing. Not reproduced.

### Device state left behind

Airplane mode off, Wi-Fi on (read before and after the offline step), font scale 1.0 (read only). Debug app:
**light**, **English** (dark and Arabic set and reset in the app's own Settings), signed in to the mock as the
**school** student, on Home. `/sdcard/ui.xml` and the recording removed.

## Fix batch — #100 · W14-10 · #98 (owner rulings 2026-09-27) — WALK 2026-09-27

Owner `WALK` after `fix`. Pixel 8 (`45131FDJH0009G`, 2.625 px/dp). `flutter build apk --debug -t lib/main_mock.dart`
with the batch (validate 1654/0/0) and the local-only FLAG_SECURE override (`walk_override.py`, so the quiz page and
review can be captured; `main_mock.dart` restored byte-identical, blob `f189786`, before the install); a normal build
reinstalled at the end. School student (OTP `000000`): Learn → الأحياء → Units → Chapters → Lessons, dark EN (the
reinstall reset the app to the system's dark theme), light EN, light AR; a 10-question quiz from الدرس الأول →
the quiz page, the AI panel, the result, review. University student (OTP `111111`): التشريح Lectures, light EN.
Values from `wfixm.py` (w16m.py, catalog rows), `wfix_ul.py`, `wfix_glyph.py` and `wfix_cta.py` in the scratchpad
`walkfix/`, and re-measured independently by two read-only Sonnet verifiers against 1× frame renders
(`frames/lessons_row_308_4769.png`, `panel_header_159_1812.png`, `cta_159_2345.png`).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| V1 | #100: catalog chevron ends 12 in | **PASS** | the chevron's ink ends **21.71** from the row's end on all 16 rows measured (Units, Chapters, Lessons dark `01`–`03`; Lessons, Units light `04`, `05`; Lectures `11`), `#4B675E` light / `#FCFBF9` dark; frame render 22.0; before the fix 26.7 (the box 17 in). Disc 16.8–17.1 from the start; rows 16.00 apart |
| V2 | #100: the text column | **PASS** | the Lessons and Lectures rows' text ink runs from ~69 to 52.6–52.95 from the end (the column 242); the two long lecture names wrap inside it (rows 105.9). The frame's caption ink ends 54.0: see below |
| I1 | #100 in Arabic | **PASS** | `10` (light AR, Lessons): mirrored, the chevron's ink 20.6–21.0 from the LEFT, pointing left; the disc 17.1–17.9 from the right; the caption 52.6 from the left |
| V3 | W14-10: the quiz page | **PASS** | `06`: «التركيب» in the Arabic stem is underlined across its whole ink width (153 px, 58.3 dp) by a solid line 2 px thick (rows 680–681), a clear pixel row below the letters' baseline stroke (672–677). Designed: 0.05 em of `h3` (18) = 0.9, centred 0.075 em under the baseline |
| V4 | W14-10: review | **PASS** | `09`: the one-line stem truncates to «…يصف ال…»; the underline (rows 627–628, 55 px) runs under the visible «ال» and the ellipsis and nowhere else in the row, as the engine draws a truncated underlined run |
| V5 | #98: the AI panel | **PASS** | `07`: the glyph's ink 25.90 × 24.0–24.8 dp; the 1× render's 25–27 × 23–25 (its 1-dp quantisation); the old 1.062× would draw ~27.5 × 25.8. The title's ink starts **8.76** after the glyph's (render 8–9; old ~10.9) |
| V6 | #98: the result CTA | **PASS** | `08`: the glyph's ink 25.90 × 24.38 (render 25 × 24); the label's ink starts 11.43 after it (render 12); the group centred in the `#384F47` button (0.19 dp off) |

**Score: 7/7 = 100%.** One verifier marked V5's gap "refuted" against the 0.6-dp tolerance I set it (8.76 against
8.0 / 8.089, over by 0.07–0.16); the render itself resolves only whole dp, and the old build's gap was 2.1 larger.

Also checked:
- Review's own AI glyph (unchanged, the open owner question) draws intact.
- `logcat -s flutter`: no overflow, no exception.

### Observed, not logged

- **The caption ends ~1 dp further out than the frame's.** Its ink ends 52.6–52.95 from the row's end; the frame's
  ends 54.0 (`308:4769`: the caption box ends 52.66, and the bar-and-caption group sits 0.66 inside the text column
  on both sides, which the build does not draw; the frame's caption is "80%", the build's "12 / 40 questions",
  #16). The walk's first note compared the build's ink with the frame's box; a verifier corrected it.
- **The one lost tap of the Wave 17 walk** did not recur (every row tap in this walk landed).

### Device state left behind

The normal build (FLAG_SECURE on) reinstalled; the reinstall signs the mock out, so the app is on its landing
screen and follows the system's dark theme. Airplane mode off, Wi-Fi on, font scale 1.0 (read only). The phone is
in landscape at the end: it rotated; the rotation setting was not touched. `/sdcard/ui.xml` removed.

## Wave 18 — Mistakes lessons — WALK 2026-09-27

Owner `WALK`. Pixel 8 (`45131FDJH0009G`, 2.625 px/dp). `flutter build apk --debug -t lib/main_mock.dart` with Wave 18
(validate 1668/0/0), a plain build (`main_mock.dart` blob `f189786`, untouched). The phone had been left in landscape
with auto-rotate on; the owner stood it upright on request, and no setting was changed. School student (OTP
`000000`): Learn → Mistakes → الأحياء → الوحدة الأولى → الفصل الأول → Lessons (two lessons: "الدرس الأول" 2 mistakes,
"الدرس الثاني" 1 mistake). Dark EN (the app followed the system's dark theme), dark AR, light AR, light EN, offline
(light EN). Values from `wfixm.py` (rows, disc, text, chevron zone) on the captures, and re-measured independently by
two read-only Sonnet verifiers against the 1× frame render `../w18/lessons_404_6762.png`. Evidence: scratchpad
`walk18/` (`02`–`06`, the four dumps, `w18rec.mp4` + `rec/`, `w18tap.mp4`, `f1_sheet.png`, `claims.md`).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | cached view | **PASS** | `w18rec.mp4` (Chapters → Lessons): the Lessons rows are legible from the first transition frame (`p000102`), fading in with the page, and settle by `p000122`; no frame shows a skeleton block. One fetch per stack is pinned by the widget tests |
| F2 | leaf rows inert | **PASS** | in all four dumps each lesson row is `android.view.View`, clickable=false (the Chapters rows above them are `Button`); no chevron ink in any row (the right 90 dp in EN, the left 90 dp in AR, clear of the border and corners); two taps and a 600-ms press left the dump on the same Lessons screen, and `w18tap.mp4`, recorded over them, holds one encoded frame (nothing on screen changed: no ripple, no highlight) |
| F3 | ICU plural | **PASS** | "2 mistakes" / "**1 mistake**" (EN); "خطآن" / "**خطأ واحد**" (AR, the `two` and `one` forms) |
| V1 | vs `404:6762` (light EN, `05`) | **PASS** | first row **25.14** under the back chip, rows **16.00** apart, margins 20.19 / 19.81; fill `#EAD5D5`, disc `#F4E6FF` 17.0 from the start, name ink from 70.1–70.5 and count ink from 69.7 (frame 70 / 71), count `#EF4444`. The frame's chevron is not drawn (the leaf, owner ruling 2026-09-12). Rows 81.90 / 82.29 (frame 78): W16-6 |
| V2 | dark (`02`) | **PASS** | the same geometry (the dump's bounds are identical to light's); row `#27282C`, cream `#FCFBF9` name and numeral, `#EF4444` count; the dark family's row paint (`404:7990`'s rows; no dark frame draws Lessons, DESIGN_ISSUES #64) |
| I1 | Arabic layout (`03`, `04`) | **PASS** | mirrored: disc 17.1–17.4 from the RIGHT, name and count ink from ~70–71 from the right, no chevron; title "دروس الفصل الأول"; 25.14 / 16.00; row 2 is 84.95 (W16-6). The RTL frame `549:19390` does not mirror its row; the app does (#58, #64) |

**Score: 6/6 = 100%** (F 3/3 · V 2/2 · I 1/1).

Also checked:
- Offline (`06`): "You are offline" pinned above the rows, both rows kept (16.0 apart); cleared on reconnect.
- Logcat: after the airplane toggle rolled the ring buffer over, a clean-log repeat (Chapters → Lessons, Arabic and
  back) logged no Flutter line; the crash buffer is empty. Earlier, the only Flutter line was flutter_svg's info note
  on the `<filter>` element of `success_badge.svg` (the OTP success screen), not this screen.

### Observed, not logged

- **The tap recording has no duration in its file**, so on its own it cannot show it spanned the taps (a verifier
  marked that sub-claim unverifiable); the dumps taken after the taps, and every capture after them, show the same
  inert Lessons rows.
- **The row is 371.4 dp wide on the 411.4-dp phone** (the frame's 363 on 402): the margins are the frame's, the row
  absorbs the extra width, as on every list walked.
- **In dark the disc shows only its rim**: its fill is `#27282C` at 20% on a `#27282C` row (#70), so the numeral sits
  on the row colour inside a faint ring, as in the Wave 16 / 17 walks.

### Device state left behind

Light EN on Home, signed in as the school student (the Learn tab keeps its stack on Lessons). Airplane mode off,
Wi-Fi on, font scale 1.0 (read only); auto-rotate as found (on), portrait. `/sdcard/ui.xml` removed; this walk's two
recordings pulled and removed from the phone.

## Wave 19 — Profile — WALK 2026-09-28

Owner `WALK`. Pixel 8 (`45131FDJH0009G`, 2.625 px/dp, status bar 132 px = 50.29 dp). `flutter build apk --debug -t
lib/main_mock.dart` with Wave 19 (validate 1693/0/0), a plain build (`main_mock.dart` blob `f189786`, untouched).
Students: school "طالب تجريبي" (OTP `000000`) and university "طالب جامعي تجريبي" (OTP `111111`), both level 3 and
1,250 points. Path: school light EN (Profile, Go to Uni, Logout → No), dark EN (the app's own Settings → Mode), dark
AR and light AR (Settings → Languages), light EN Logout → Yes (recorded), a cold restart, the university login
(recorded from the OTP success screen), the university Home, Profile and Logout, back to the school student, offline
on Profile. Values from `w19dlg.py`, `w19col.py` and the dumps (`w19dump.py`), re-measured independently by two
read-only Sonnet verifiers against the 1× frame renders in `../w19/`. Evidence: scratchpad `walk19/` (`01`–`16`, their
dumps, `w19yes.mp4` + `yes_seq/`, `w19uni.mp4` + `uni_seq/`, the contact sheets, `claims.md`).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | profile from `/me` | **PASS** | Home and Profile show the payload the mock's `GET /me` returns for each student: the name, "Level 3", Points 1,250 (`01`, `02`, `12`, `13`) |
| F2 | logout revokes, then clears | **PASS** | after Yes the login screen (`11`); a force-stop and relaunch opens Welcome (`ui_cold.xml`), so no session is stored. The revoke call is test-level: `profile_screen_test.dart` "Yes revokes, then signs out"; `AuthController.logout` awaits the repository's logout before `clearTokens` |
| F3 | re-login shows the new student on Home | **PASS** | after the school student logs out, the university login lands on Home with "طالب جامعي تجريبي" (`12`); `uni_seq` (81 frames, 0–3.88 s): the OTP success screen, the Home skeleton (2.152–2.422 s), then the university name in every frame from 2.583 s; no frame holds the school name. Top Student lists three students, no error (W05-3's wrong-scope 400 is gone). The reverse switch shows the school student again (`15`) |
| F4 | … and on Profile | **PASS** | the university Profile shows "طالب جامعي تجريبي", Points 1,250 (`13`); its Logout dialog as the school one, Yes `#384F47` (the frame `309:9472`: both tracks) (`14`) |
| F5 | Go to Uni disabled with its reason | **PASS** | `Confirm` enabled=false, clickable=false; the dialog reads "Switching tracks isn't available yet."; the button `#A4AEA9` (`#384F47` at 45%), 293 wide, 30.5 in from each side of the 354.3 card; the ✕ closes it (`03`, `ui_after_x.xml`) |
| V1 | vs `166:4416` (light EN, `02`) | **PASS** | no app bar; the title centred (205.75 / 83.85 dp; the bar's centre 83.79), ink `#0E0E0E` (#57, #99); the header card 126.48–230.10, **25.2 under the 35 dp bar** (the frame 25); the Points card 20 under it, the menu 20 under that, rows 64 tall and 16 apart; one stat card (Points, #101) |
| V2 | Logout vs `180:4704` (`04`) | **PASS** | card `#FCFBF9`, 354.3 wide at 28.57 in (the frame's 345 on 402); title and body `#384F47`; the ✕ `#3F3F3F`, a 48 dp target, its ink 26.7 from the card's start; **No `#EF4444` / Yes `#384F47`**, 59.8 tall, 15.24 in, 5.33 apart, labels `#FCFBF9`, the card ending 15.24 under them (the frame 15 / 5 / 15); scrim `#BFBEBD` (`#313131` 30%). Buttons 159.2 wide (the frame 155; the card absorbs the wider phone) |
| V3 | dark (`05`, `06`) | **PASS** | page `#232428`, title `#FCFBF9`, the Points card `#27282C`, the geometry of light (identical dump bounds); dialog card `#232428`, the ✕, title and body `#FCFBF9`, No `#EF4444`, Yes `#AE87E7`, labels `#FCFBF9`, scrim `#2B2C2D` (`#313131` 60% on the blurred page), the geometry of light |
| I1 | No dismisses, Yes logs out | **PASS** | No (and the ✕) leave Profile as it was (`ui_after_no.xml`); Yes lands on login (`11`); `w19yes.mp4`: the dialog fades out (1.67–1.79 s), Profile unchanged ~0.3 s, a cross-fade to login (2.17–2.50 s); no frame shows an error view or a skeleton |
| I2 | edit chip 48 dp | **PASS** | `Edit Profile` 48.0 × 48.0 in every Profile dump (on the left in Arabic); the dialog ✕ 48.0 × 48.0 in every dialog dump |

**Score: 10/10 = 100%** (F 5/5 · V 3/3 · I 2/2).

Also checked:
- Arabic (`07`–`10`, the owner's ruling on #102): the title "الملف الشخصي" centred, the header card mirrored, the menu at
  the English position; the pair mirrored, لا (`#EF4444`) on the right and نعم on the left (`#AE87E7` dark, `#384F47`
  light), 15.24 in, the card ending 15.2 under it; the ✕ at the right, its ink 26.7 from the card's right.
- Offline (`16`): "You are offline" under the title bar, the profile kept below it; gone on reconnect.
- Logcat: no `flutter` line from the pre-launch clear to the end (the main buffer's oldest entry, 17:44:32, predates
  the launch, read live; the verifiers could not re-derive this from files); the crash buffer is empty.

### Incident: an incoming phone call

A call reached the phone during the walk. The tap meant for the Account tab (972, 2190 px) probably answered it: the
call screen's timer read 00:07 about seven seconds after the tap. One swipe then went to the call screen. Input stopped
at once and the owner handled the call. The capture and the two dumps that recorded the call screen were deleted from
the scratchpad and the phone's own dump removed; the walk resumed on the owner's `CONTINUE` after the call state read
idle (`mCallState=0`).

### Observed, not logged

- **The Points card is ~90 dp tall** (250.3–340.2; the frame's cards 82): the scale's line heights for the label and
  the value. The card predates this wave; its 20 dp gaps are the frame's.
- **The Logout card is 212 dp tall** (the frame 239): the text follows the type scale (#102, "not changed"), and the
  body fits one line on the wider card.
- **The RTL frames put the ✕ 18 from the card's right**; the build mirrors the LTR 24 (the half-mirrored RTL family,
  #58, #64).
- **The Arabic pair sits 1.9 dp lower** than the English one (the Arabic body line is taller; W16-6, D-019).
- **The university student also gets Go to University**: the University frame draws the same hub; the confirm is
  disabled on both tracks (S31).
- **`14` is byte-identical to `04`**: behind the scrim only the menu shows, and the frames give both tracks the same
  colours; the track is established by `13`, captured 29 s earlier with the university name.
- The dumps' button bounds run one pixel wider than the painted fill at the rounded outer edges.

### Device state left behind

Light EN on Home, signed in as the school student. Airplane mode off, Wi-Fi on, font scale 1.0 (read only), portrait.
Auto-rotate read 0 at the start and 1 at the end (the Wave 18 walk had left it on); nothing in this walk touches it,
so it was left as it is. `/sdcard/ui.xml` and this walk's recordings removed from the phone.

## Wave 20 — Edit Profile — WALK 2026-09-28

Owner `WALK`. Pixel 8 (`45131FDJH0009G`, 2.625 px/dp, status bar 132 px = 50.29 dp). `flutter build apk --debug -t
lib/main_mock.dart` with Wave 20 (validate 1723/0/0), a plain build (`main_mock.dart` blob `f189786`, untouched).
Students: school "طالب تجريبي" (OTP `000000`) and university "طالب جامعي تجريبي" (OTP `111111`). Path: school light EN
(Edit Profile top and bottom, the action sheet, Upload photo tapped, the picker, its ✕; the avatar picked and saved;
a new name, with the unsaved guard by the back chip and by system Back; an e-mail set, then cleared; a malformed
e-mail), dark EN (the app's own Settings → Mode: the form, the sheet, the picker), dark AR and light AR (Settings →
Languages: the form, the sheet, the picker), the university student (log out, `111111`: the form top and bottom),
offline over the form. Values from the dumps (`w19dump.py`) and the pixel tool `w20px.py`, re-measured independently by
two read-only Sonnet verifiers against the 1x frame renders in `../w20/`. Every tap went through a guard that refuses
input unless the call state is idle and the app is in front. Evidence: scratchpad `walk20/` (`01`–`21`, their dumps,
`f5_compare.png`, `claims.md`, `verify.json`).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | diff-only PATCH body | **N/A** | bodies are never logged, so the device cannot show one. Test-level: `profile_update_test.dart` (only changed fields reach the wire) and the screen tests |
| F2 | explicit null clears email | **PASS** | "sara@example.com" saved and there on reopening (`09`); the field cleared and saved (Save popped to Profile), reopened empty (`10`). The mock keeps the address when the key is absent, so the empty field is the explicit null arriving |
| F3 | 400 field error inline | **PASS** | "a@b" → Save → "Please check this field" under E-Mail and "Please check your input and try again." above Save, both `#BA1A1A`, the field's border `#BA1A1A`; the form stays (`11`) |
| F4 | `/me` refresh after save | **PASS** | "Sara Ali" → Save → Profile shows "Sara Ali" (`08`), and so does Home ("Welcome back, Sara Ali", `ui_home_after_name.xml`) |
| F5 | avatar round-trip | **PASS** | Use Avatar → the third avatar → it shows on the form (`05`) → Save → Profile's header shows it (`06`, `f5_compare.png`) |
| V1 | vs `176:1201` (light EN, `01`) | **PASS** | the avatar block 126.5–291.4, **25.1 under the 35 dp bar**, 151 + **14** tall; "Full Name" 0.8 under it; the pencil exact `#384F47`, 16.8 × 16.8, centred on the 34 dp cream badge; locked rows Phone / City / School, 25 apart; dark: the pencil `#FCFBF9`, the geometry identical (`12`); Arabic mirrored, the same y (`15`, `18`); university: Phone / Faculty / Academic Year / City / University name (`19`, `20`) |
| V2 | action sheet vs `216:3341` (`03`) | **PASS** | handle `#000000` 93.7 × 3.8, 15 under the card's top, centred; rows full width, 43.8 and 44.2 tall, the first 39 under the top, 12.9 between; the hairline `#92A29C` (= `#4B675E` 60% on the card) on row 1's bottom only; labels 20 in; no title, ✕ or icon; dark: handle `#FCFBF9`, hairline `#3B4C48` (`13`) |
| V3 | picker vs `180:4153` (`04`) | **PASS** | the ✕ ink exact `#3F3F3F` centred 38.5 from the card's start (the frame's 27 + 11.5), on a 48 × 48 target centred 47.6 under the top; the title centred; cells 69, the first 21 in and 89 down, 16 apart, the fifth cut at the edge; dark: the ✕ `#FCFBF9` (`14`); Arabic: the ✕ 38.6 from the right, the strip from the right (`17`) |
| I1 | unsaved guard | **PASS** | a dirty form: the back chip → "Discard changes?" (`07`) → Keep editing stays; system Back → the dialog (the second press; the first went to the keyboard's connection, see below); Discard → Profile |
| I2 | read-only rows announced | **PASS** | every locked row is ONE node in every Edit Profile dump, reading "value, label, hint" (e.g. "Nasr City, City, Set when you registered — this can't be changed."), with no separate label or value node |
| I3 | Upload Photo disabled with hint | **PASS** | `enabled=false`, `clickable=false`, labelled "Upload photo, Uploading your own photo isn't available yet."; its ink dimmed (`#91908F`); the caption under the rows; a tap leaves the sheet as it was (`ui_after_upload_tap.xml`) |

**Score: 10/10 = 100%** (F 4/4, F1 N/A · V 3/3 · I 3/3).

Also checked:
- Offline (`21`): "You are offline" over the loaded form, the form kept below it; gone on reconnect.
- The mock's edits stay with their track: after the school student became "Sara Ali", the university student's form shows
  "طالب جامعي تجريبي" (`19`).
- Logcat: no `flutter` line from the pre-launch clear to the end (the main buffer's oldest entry, 20:55:04, predates the
  launch); the crash buffer is empty.

### Two walk-method notes (no app defect)

- **A swipe typed into the name field.** After "Keep editing", the name field took focus back and the keyboard opened;
  the next scroll swipe ran across the keyboard and its glide typing appended "لف " to the name. Seen in the next dump,
  retyped, and from then on the keyboard was closed with Back and checked hidden (`mInputShown=false`) before any
  swipe. Only the text field was affected.
- **The first system Back after typing** changed nothing: the keyboard had been hidden with ESC, which leaves its
  connection open, and that press closed it. The second press showed the discard dialog.

### Observed, not logged

- **Save sits 28 under the last locked row** (`02`; the frame's 25): the build's gap before the button, unchanged by
  this wave.
- **In Arabic the sheet's rows are 48 tall** (the frame's 44): the Arabic label line is taller (W16-6, D-019); the 13
  between them holds.
- **The gradient disc does not show on the mock**: its avatars are opaque photos and the loading placeholder covers
  the disc, so the gradient is test-level only (`edit_profile_screen_test.dart` derives it from the frame's transform).
- **No Parent's Number row**: `GET /me` has no source for it (S34, #105), as built. **No bottom nav bar**: Edit Profile
  is a pushed route outside the shell, while the frame draws the bar; unchanged by this wave.
- **The offline banner sits above the title bar** here; on Profile it sits under it (Wave 19).

### Device state left behind

Light EN on Home, signed in as the school student (a relaunch reset the mock's edits). Airplane mode off, Wi-Fi on,
font scale 1.0 (read only), portrait, no call. Auto-rotate read 0 at the start and 1 at the end; no command in this
walk sets it (as in the Wave 19 walk, it turned on across the walk; the launches used `monkey`, the one common step),
so it was left as it is. `/sdcard/ui.xml` and the capture file removed from the phone.

## Wave 22 — Flashcards (Lectures tab → Flash Card Setup → study) — WALK 2026-09-29

Owner `WALK`. Pixel 8 (`45131FDJH0009G`, 2.625 px/dp, status bar 132 px = 50.29 dp). `flutter build apk --debug -t
lib/main_mock.dart` with Wave 22 (validate 2017/0/0), a plain build (`main_mock.dart` blob `f189786`, untouched),
launched with `am start`. University student "طالب جامعي تجريبي" (OTP `111111`). Path: light EN (Anatomy → the
Flashcard tab → Setup for each of its four lectures; three full rounds of lecture 1 and the wrap; flip, "Got it",
restart and "<" screen-recorded; ✕ mid-round; Physiology and Biochemistry; the weekly allowance spent to the 403;
offline over the study screen and Setup), dark EN (Settings → Mode), dark AR and light AR (Settings → Languages: the
study screen, Setup, the Lectures tab, the Arabic 403 line). Values from the dumps (`w19dump.py`), the pixel tools
`w20px.py` / `w22px.py` and the recordings' frames, against the 1x renders of `225:5582`, `1234:8797`, `337:14475`,
`549:28041`, `180:5208` read over the MCP. Every tap went through the guard (idle call state, the app in front, and —
from mid-walk — no notification over the screen). Evidence: scratchpad `walk22/` (captures `01`–`35`, their dumps,
`i1frames/`, `i2frames/`, `f3frames/`, `frames/`, `claims.md`, `verify.json`).

| # | Criterion | Result | Evidence |
| --- | --- | --- | --- |
| F1 | the entry: the Lectures Flashcard tab | **PASS** | Anatomy: Normal, **Flashcard**, Midterm, Final, Practice (`01`); the tab lists the four lectures with cards, their numbers, no progress bar or "questions" caption (`02`); Physiology lists 2 of its 3 (`20`); Biochemistry has one tab, Normal (`21`). Setup counts 24 / 10 / 4 / **1 Flash Card** (`03`, `18`) |
| F2 | 10-card rounds, the next round, the wrap | **PASS** | 1/10 … 10/10, then Setup (`08`); Start → the deck's 11th card at 1/10 (`09`); the third round 1/4; the next Start is card 1 again (`16`) |
| F3 | Got it / restart grade and advance; "<" does not | **PASS** | recordings: at the tap on "Got it" (or the restart disc) both grade controls dim and the counter holds, then after the mock's ~0.33 s the next card shows; "<" moves back at once with no busy frame (`i2frames/`, `f3frames/`, `f3_sequence.png`). Either face grades (from the back in `05` → 2/10). The body is test-level: bodies are never logged |
| F4 | grades echo on reopen | **N/A** | the UI never shows `selfGrade`; test-level (`mock_backend_flashcards_test.dart`, latest-wins) |
| F5 | the preview used up | **PASS** | the allowance spent to 50 (lectures opened: 24 + 1 + 10 + 4 + 10 + 1); a 3-card lecture delivered a truncated **1/1** round (`22`); the next Start: "You've used this week's free flashcards." with an icon and **no button, price or link**, ✕ live (`23`); Arabic "لقد استخدمت البطاقات المجانية لهذا الأسبوع." (`34`); cards already charged still open at zero (`ui_free_redeliver.xml`) |
| F6 | offline | **PASS** | "You are offline"; "Got it" and the restart disc disabled; flip and "<" still work (`24`, `ui_off_flip.xml`, `ui_off_prev.xml`); Setup's Start disabled (`25`); both back on reconnect |
| V1 | study screen vs `225:5582` (`04`, `06`) | **PASS** | the rule → disc **16.0**, disc **38** `#4B675E` with its edge 20 from the screen's, → card **13.7**, card **454.1**, → buttons **33.9**, "Got it" **59.8** `#384F47` (the frame's 16 / 38 / 14 / 454 / 34 / 60); fill `#5A7F73` at 1/10; counter `#7070A0`; the title centred (ruling), no bookmark / share / AI icon; the card `#FCFBF9` with its inset edge; "<" 78.9 × 57.9 `#86948E`, its arrow **16.4 × 27.8** at 29.3 / 17.1 (the frame's 16.57 × 28.64 at 29.49 / 16.69 — **BUG-019 fixed on device**). Recorded deltas: the title `#0E0E0E` for `#000000` (#99, #115), centred where the frame is off-centre (#117), no pale "<" on card 1 (#119) |
| V2 | the back face | **PASS** | a wrapped, centred block, unmirrored (`05`); several answers keep their line breaks, English and Arabic (`13`, `14`) |
| V3 | dark and Arabic | **FAIL** | dark matches `337:14475`'s values (canvas `#232428`, track `#2E2D32`, fill `#AE87E7`, the rule `#2C263C` = `#7C3AED` 10%, "Got it" `#AE87E7`, the card light) with the #113 stand-in disc (`27`); Arabic mirrors the English build exactly (✕ right, the disc 20 from the left, "<" at the right with its arrow at the exact mirror, the bar filling from the right) (`28`, `33`); the Arabic frame is the older, unmirrored layout (#113). **But a card's text takes the app's direction, not its own:** in Arabic the English card reads "**?into right and left parts**" (`28`, `en_front_in_ar.png`); in English the Arabic back's full stop lands at the right end (`12`, `ar_back_lastline.png`) — **BUG-020** |
| V4 | Setup vs `1234:8797` (`03`) | **PASS** | the pill 45 tall `#FFFFFF` / `#384F47` 0.5, 20 under the hairline `#CCD5D2`; its label `#384F47` centred; the helper `#6E7F7A` 4 under it; Start `#384F47` 60 under the helper; the title centred. Start sits 2.0 higher than the frame's (the helper's line is 16, the frame's 18 — #115). Dark: the #114 stand-ins (`26`); Arabic: "إعداد الفلاش كارد", "24 فلاش كارد", "ابدأ التعلّم" (`29`, `32`) |
| I1 | the flip | **PASS** | recording: ~0.30 s each way, fast then slow, the faces swapping at the midpoint; the back unmirrored (`i1frames/`) |
| I2 | grade controls and the busy state | **PASS** | both controls disabled for the round trip, a spinner in "Got it" (a 24 dp box), nothing moves before the answer (`i2frames/`, `f3frames/`) |
| I3 | entry and exit | **PASS** | after the last card (either control) → Setup (`08`, `ui_one2.xml`); ✕ mid-round → Setup, and the round replays from its first card; Setup's back → Lectures with the Flashcard tab still selected (`17`) |

**Score: 11/12 = 92%** (F 5/5, F4 N/A · V 3/4 · I 3/3). V3 fails on BUG-020.

Also checked:
- Logcat from the pre-launch clear: the `flutter`-filtered read returned no line and the crash buffer none, while the
  same buffer held lines from before the launch (`logcat_flutter.txt`, `logcat_crash.txt`; the phone's USB link dropped
  after the walk, so the read could not be repeated).
- Not walked (test-level): the loading skeleton, a load failure with Retry, a failed grade's line under the card, the
  empty state (unreachable: lectures without cards are not listed) and `insufficient_scope`.
- The Arabic card faces render in Tajawal Bold on both faces (the front 24, the back 28).
- Independent verification: two read-only Sonnet verifiers re-measured the captures, dumps, recording frames and 1x frames: every behaviour and every measurement confirmed, and BUG-020 with its code lines. Their PARTIALs were the record's wording, corrected here: the disc's EDGE, not its centre, is 20 from the screen edge; "exact mirror" compares the Arabic build with the English one (the Arabic frame is the older, unmirrored layout, #113); Arabic Setup's Start is 6.8 lower, not 6.4; the spinner's 24 dp is its box (the arc inks 25.9); the busy button's label is source-level (no dump was taken mid-grade); the flip card's is not the only Arabic test (none mixes directions). The walked mock is `mock_backend.dart` blob `6047624` (unchanged since 15:19; the APK built 17:43).

### Observed, not logged

- **Five tabs overflow the Lectures row.** Arabic by ~54 dp: at rest "عملي" shows as a ~31 dp sliver with no scroll
  cue, so Practice is effectively hidden until the row is swiped (`30`, `31`); English by ~5 dp (Practice 70.5 wide,
  `02`). The row scrolls by the owner's ruling (D-012, #81); the Flashcard tab is what makes five.
- **Arabic Setup is taller:** the pill's line 28.2 and the helper's 19.0, so Start sits 6.8 lower than in English
  (`32` vs `03`).
- **Offline, the card shrinks to 419.8** to make room for the banner (`24`), so the button row moves 3.8 when the
  connection flips; the banner sits above the study header and under the Setup title.
- **A truncated preview round is unexplained:** Setup says "3 Flash Cards" and the round is "1/1" (`22`).
- **The round position lives only while Setup is open:** leaving Setup forgets it, so a lecture reopens at its
  first round (as built, W22-3).

### Walk-method notes (no app defect)

- **An incoming SMS notification** covered the top of the screen twice: once around capture `15` (deleted unviewed;
  its dump holds only the app) and once over Settings, where it took two taps aimed at the back chip (the app stayed in
  front; nothing opened). The capture that showed it was deleted. From then on the guard also refused input while a
  notification covered the screen. The recordings' status bars were masked and the raw videos deleted.
- A tap at (540, 1800) px landed on the empty area under the Arabic lecture list; nothing happened.

### Device state after the walk

Light EN on Home, signed in as the university student. Airplane mode off, Wi-Fi on, font scale 1.0 (read only),
auto-rotate 0 at the start and the end, no call. `/sdcard/ui.xml`, the captures and the recordings removed from the
phone. The phone's USB link dropped after these were read (adb lost it during a log re-read).

## Wave 22 — BUG-020 fix — targeted re-WALK 2026-09-30

On the owner's request: fix BUG-020, then re-walk it on the device. This does not re-score the whole wave; the 92% walk
above stands as recorded. Pixel 8 `45131FDJH0009G`, a debug mock build with the fix (`flutter build apk --debug -t
lib/main_mock.dart`, `main_mock.dart` blob `f189786` untouched), `adb install -r`, launched with `am start`, the
university student, light theme, font scale 1.0 (read only). Deck `anatomy-l1`, reached by grading: card 2 (the walk's
English card, "Which plane divides the body into right and left parts?"), card 13 (its Arabic card, the answer ending
"إلى الأمام.") and card 14 (the three-line Arabic list). Evidence: scratchpad `walk20b/` (captures `02`–`13` and their
dumps, `flipframes/`, the before/after crops `ba_*.png`, `claims.md`, `verify.json`); the pre-fix captures are the
2026-09-29 walk's (`walk22/`). Every capture passed the notification check; none was deleted.

| # | Combination | Result | Evidence |
| --- | --- | --- | --- |
| 1 | Arabic app + English card | **PASS** | card 2 reads "Which plane divides the body / into right and left parts?", the "?" at the right end (`09`); before the fix the same card in the Arabic app read "?into right and left parts" (walk22 `33`; `ba_ar_app_en_card2.png`). Its back: five lines, the full stops and "(midsagittal)" in place (`10`). Both faces are pixel-identical to the English app's (`09` / `10` vs `03` / `04`: 0 of 1,059,561 px differ) |
| 2 | English app + Arabic card | **PASS** | card 13's back ends "إلى الأمام." with the full stop the LEFTMOST ink on its line (x 146.3–150.9 dp, 5.0 × 4.6); before the fix it was the RIGHTMOST (x 261.0–265.9 dp) (`06` vs walk22 `12`; `ba_en_app_ar_card13.png`). Its front ends on "؟" at the left (`05`). Card 14's list: three answers, the third wrapping, the parentheses in place (`07`; it drew the same before the fix, walk22 `13`, 0 px) |
| 3 | Arabic app + Arabic card | **PASS** | cards 13 and 14 are pixel-identical to the English app's (`11`, `12`, `13` vs `05`, `06`, `07`: 0 px each) |
| 4 | English app + English card | **PASS** | card 2: the "?" at the end of line 2 (`03`), its back five lines (`04`); `03` is pixel-identical to the pre-fix walk's capture of the same card in the same app (walk22 `06`, 0 px): no regression |

**Result: 4/4 PASS — BUG-020 fixed on the device.** The pre/post differences are exactly the two lines the walk
caught (line 2 of card 2 in the Arabic app, line 4 of card 13's back in the English app); every other line measured the
same before and after. With V3's one failure gone, **Wave 22's acceptance after the re-walk is 100%** (F 5/5, F4 N/A ·
V 4/4 · I 3/3). The other criteria are carried from the 92% walk: the fix changes only text direction (the two card
faces, the card's screen-reader label, Setup's subject and lecture lines).

Also checked:
- The flip: front → back in every combination; back → front for the English card in the English app (`ui_flipback.xml`)
  and, in a 60 fps recording (card area only, the video deleted), for the Arabic card in the Arabic app, and back again.
  Each turn changes over about 18 frames (f069–f087, ~0.30 s), decelerating in angle (ease-out), the faces swapping
  edge-on (f074, f170), unmirrored: the Wave 22 walk's ~0.30 s. (f079 is a dropped recording frame.)
- The screen-reader label: in every study dump the card is one clickable, enabled `Button`, labelled with the full text of
  the face that is up, in both apps. The label's direction is a Flutter semantics attribute that uiautomator does not
  expose, so it is test-level (`flashcard_flip_card_test.dart`, "a screen reader gets the face's own direction with its
  label"). TalkBack was not run.
- Setup (its two lines changed): the Arabic subject and lecture start 22.1 dp from the left in English (`02`) and end
  22.1 from the right in Arabic (`08`), where the Wave 22 walk had them. A no-regression check only: the walked names end
  in no neutral mark, and an English name in the Arabic app was not walked on Setup (test-level).
- The card text stays centred on every capture (each line's ink centre within 0.6 dp of the card's).
- Logcat since the launch-time clear: no `flutter` line; the crash buffer empty (no positive control).
- Independent verification: two read-only Sonnet verifiers (combinations, measurements) re-ran every diff, mark and
  timing measurement: all four combinations confirmed, no claim refuted. Their PARTIALs were wording, corrected here:
  the turn is ~0.30 s by frame hash (a 0.5 dp threshold had read 0.25–0.27 s), ease-out holds in angle rather than in
  raw ink width, back → front was not captured for every combination, card 14 is a combination-2 control (not
  English-in-English evidence), and the Setup check is no-regression only.
- Not re-walked (the fix does not touch them): dark, offline, grading, rounds, the weekly limit, the Lectures tabs.
- Still open, outside this fix: the Lectures rows and the other catalog names take the app's direction by the same
  mechanism (`KNOWN_BUGS.md` BUG-020).

### Device state after the re-walk

Light EN on Home, signed in as the university student. Airplane mode off, Wi-Fi on, font scale 1.0 (read only),
auto-rotate 0, no call. `/sdcard/ui.xml`, the captures and the recording removed from the phone; older files from
earlier waves were left as found.
