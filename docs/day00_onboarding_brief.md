# Day 00 Brief — Onboarding (light + dark) + OTP-success reconcile

> Paste into Claude Code, repo `level_up_app`, branch `dev`. Self-contained.
> Figma file key: `P6044i0giD9TmdQ7C2AmLq`.
> **Retro-fit round.** "Day 0" in `PROGRESS.md` was the *infrastructure* pass; the onboarding
> *screen* was deferred behind the router guard and never built. This brief closes that gap and
> reconciles the one screen that WAS built from a partial frame (OTP success).
> Prereq: `dev` clean, Days 1–6 committed.

## What Day 00 builds

1. **Onboarding screen** — Figma dark `337:15146` ("on boarding screen_1"), light sheet variant
   `459:43873`. Full-bleed illustration + translucent bottom sheet + **Get Started** / **Log In**.
   Replaces `_Placeholder('Onboarding')` at route `/`.
2. **OTP-success reconcile** — Figma `155:786` (full light screen) / `82:1596` (content block).
   `_SuccessView` already exists but was built from a screenshot before the badge could be
   exported. Swap the placeholder icon for the real asset and correct type sizes, spacing, and the
   truncated subtitle.
3. **Asset landing** — the three brand assets that have been placeholders since Day 1 are now
   **exportable** (see §Assets). Land all three, wire `flutter_svg`.

## Explicitly OUT of Day 00 (do NOT build)

- Multi-page onboarding / carousel / page-dots — the design has **one** onboarding frame, no pager.
- "Skip" affordance — not in the frame.
- Persisting "onboarding seen" to storage — **not** in scope; see §Router for why `/` stays
  reachable without a seen-flag.
- Any endpoint. Day 00 is **100% presentational** — no repository, no notifier, no `AsyncNotifier`.
  Do not create `lib/features/onboarding/{models,repository,notifier}/`.
- Re-theming the Login screen's secondary button (see CONFLICT 3 — flag, don't refactor).

## Skills (invoke from `.claude/skills/`, in this order)

1. `level-up-domain` — glossary + operating rules (read first, as every day)
2. `build-screen` — the gather → plan → build loop
3. `figma-frame` — **the load-bearing skill this round.** Every colour, size and offset below came
   from `get_design_context`; re-pull the frames yourself and never eyeball a token.
4. `screen-states` — final DoD pass. Note the *reduced* matrix in §Acceptance: no network call
   means no loading/error/offline states, so this collapses to **light × dark × AR × EN**.
5. `flutter-build-responsive-layout` — the sheet is positioned at a **fraction** of screen height,
   not a fixed 529px. Read this before writing the Stack.
6. `flutter-add-widget-test` — golden-ish widget tests for both screens.
7. `dart-run-static-analysis` — `flutter analyze` clean before you stop.

**NOT invoked this round:** `seif-api-contract` (no endpoint), `river` (no async state — a
`StatelessWidget` is correct; do not reach for a notifier out of habit), `bloc` (quiz only).

---

## ⚠️ CONFLICTS — resolve before coding

### 1. 🟢 RESOLVED — asset export is no longer blocked
`DESIGN_ISSUES.md` #1 (and the matching entry in `PROGRESS.md` → "Open conflicts") says export is
disabled on a View-only seat. **That is stale.** `download_assets` now returns both PNG and SVG for
all three blocked assets. Verified this round:

| Asset | Node | SVG | PNG | Current placeholder |
|---|---|---|---|---|
| Onboarding illustration | `337:15166` (`image 79 [Vectorized]`) | 189,450 B | 84,325 B | — (never built) |
| OTP success badge (`Sticker`) | `82:1598` = `332:3402` | 4,017 B | 7,046 B | `Icons.check_circle` |
| Bird logo | `82:849` | 3,875 B | 4,497 B | `Icons.flutter_dash` |

**Do:** land all three as SVG, then **close DESIGN_ISSUES #1** and strike the `TODO(design-asset)`
markers at `login_screen.dart:144` (bird logo) and `otp_screen.dart:359` (success badge).

### 2. 🔴 The success badge green is NOT a design token — read it out of the SVG
The badge is a **vector group flattened to an image** by `get_design_context`. The only bound
variable on the whole success frame is `White: #FFFFFF` (the checkmark). There is **no green hex
anywhere in the design tokens** — which is exactly why the Day-1 build fell back to `cs.primary`
and the badge renders forest-green `#384f47` in light and **purple `#ae87e7` in dark**. Neither is
the emerald in the frame.

**Do:** download the SVG for `82:1598`, read the actual fill out of the file, and add it as a
**semantic** token (§Tokens, `successBadge`) — constant across both themes, because a success badge
must not follow the accent flip. **Do not guess a hex, and do not tint the SVG with `cs.primary`.**

### 3. 🟠 Dark "Log In" button contradicts the dark Login screen — build the Login pattern
Onboarding dark `337:15650` draws the secondary button as **cream `#fcfbf9` fill + `#0e0e0e`
label + `#ae87e7` border**. The shipped dark Login secondary button (`login_screen.dart:226`) is
`ext.fieldFill` (translucent dark) + `ext.textPrimary` (cream) + `ext.secondaryButtonBorder`
(green). These are inversions of each other.

Evidence this is a designer copy-paste from the light frame, not an intent: the same dark frame
also leaves the status-bar clock `337:15149` as **black text on the `#232428` background**, which
is unreadable and certainly unintended.

**Do:** build the **established Login pattern** (`ext.fieldFill` + `ext.textPrimary` +
`ext.secondaryButtonBorder`) so the two pre-auth screens match, and log this to
`DESIGN_ISSUES.md` as a new numbered item. It is a one-line change if the designer confirms cream
was deliberate. Do **not** refactor Login to match Onboarding.

### 4. 🟡 Dark border colour: purple in this frame, green in the token
`337:15650`'s border is `#ae87e7` (purple); `ext.secondaryButtonBorder` is `Brand.greenPrimary` in
**both** themes, sourced from dark Login `337:15652`. Same copy-paste family as CONFLICT 3.
**Do:** use the existing token (green). Flag it. Do not add a second border token.

### 5. 🟡 Grey sprawl — five near-identical greys across two frames
The frames introduce `#111`, `#7c7c7c`, `#858585`, `#ececec` and `#000000` alongside the already-
approved `#0e0e0e` / `#2c2c2c` / `#696969` / `#dcdcdc` / `#b3b3b3`.
- `#000000` ("Level Up", light) → **use `ext.textPrimary` (`#0e0e0e`)**. 6/255 apart, invisible.
- `#111` ("Successful", light) → **use `ext.textPrimary`**. 3/255 apart.
- `#7c7c7c` (success subtitle) / `#858585` (onboarding tagline) / `#ececec` (tagline, dark) → these
  are genuinely outside the palette. Add **one** shared token (§Tokens, `bodyMuted`) rather than
  three; `#7c7c7c` and `#858585` are 9/255 apart and both are "muted body copy on the cream
  canvas". Use `#858585` as the light value.

Log the consolidation to `DESIGN_ISSUES.md` so the designer can confirm one muted grey.

### 6. 🟡 No dark success frame exists
`155:786` and `82:1596` are both light. There is no dark variant in the file, same situation as the
Home and Learn frames (see the comments in `app_colors.dart`). The screen already renders in dark
via the theme; keep it that way, do not invent dark-only values, and add it to the standing
"missing dark frames" note for the designer.

### 7. 🟡 Copy typo in BOTH frames: "Achive"
The tagline reads **"Study. Compete. Achive."** — "Achieve" is misspelled, in both the light and
dark frame. **Do:** ship the correct spelling **"Achieve"** in `app_en.arb`, and flag the typo.
Never propagate a design typo into user-facing copy.

---

## SCREEN 1 — Onboarding

**Figma:** dark full frame `337:15146` · light sheet `459:43873`
`figma.com/design/P6044i0giD9TmdQ7C2AmLq?node-id=337-15146`
Re-pull both with the Figma MCP before coding.

> **Only the SHEET exists in light.** `459:43873` is a 402×360 detached frame — the sheet alone,
> no canvas, no illustration. The full 402×878 composition only exists in dark. The illustration is
> a single flat artwork with no light/dark variant, so light = same illustration + the light sheet.
> This is the same dark-first pattern already documented for Home and Learn.

### Structure — a 3-layer `Stack`, bottom sheet anchored by fraction

```
Stack(fit: StackFit.expand)
 ├─ 1. Illustration          — node 337:15166, full-bleed, aligned TOP, BoxFit.cover
 ├─ 2. Opaque backdrop strip — node 337:19256, ext.background, from sheet top → bottom
 └─ 3. Sheet                 — node 337:15643 / 459:43873, aligned BOTTOM
```

Layer 2 is not decoration: the sheet fill is only **20% opaque**, so without an opaque strip behind
it the illustration bleeds through the sheet. In Figma this is a `#232428` rect `622×138` at
`(-140, 540)` — deliberately oversized to guarantee cover. In Flutter, just paint
`ext.background` behind the sheet instead of replicating those numbers.

### Geometry (design values → what to build)

| Thing | Figma (dark `337:15146`, 402×878) | Build as |
|---|---|---|
| Illustration | `419×682` at `(-19, -19)` — bleeds 19px past top & start | `BoxFit.cover`, `alignment: Alignment.topCenter`. **Do not** hard-code 419×682. |
| Sheet top | `y = 529` of `878` | `529 / 878 = 0.602` → anchor the sheet at **60.2% of height**, or let it size to content. **Never a fixed 529.** |
| Sheet height | `413`, of which **64 is clipped** by the frame bottom | Visible height is `878 − 529 = 349`. Size to content; do not reserve 413. |
| Sheet radius | top-start 25, top-end 25 | `BorderRadius.vertical(top: Radius.circular(25))` |
| Sheet shadow | `0 −1.5px 9.2px rgba(0,0,0,0.15)` | `BoxShadow(offset: Offset(0,-1.5), blurRadius: 9.2, color: Color(0x26000000))` |
| Sheet fill | dark `rgba(35,38,40,.2)` · light `rgba(252,251,249,.2)` | new token `sheetFill` (§Tokens) |
| Text block | `w 331`, centred; top `17.03` dark / `25.03` light; column `gap 10` | one padding value — pick **20**; the 8px light/dark delta is not a design intent |
| Button block | `w 362`, centred; top `180` dark / `187` light; column `gap 20` | `gap 20` exactly; `362/402 = 0.90` → horizontal padding **20** |

`w 331` and `w 362` inside a `402` frame are `EdgeInsetsDirectional.symmetric(horizontal: 20)` and
`35.5`. Use **20** for the buttons (matches every other screen in the app) and let the text block
wrap inside the same 20.

### Content (top → bottom, inside the sheet)

1. **"Level Up"** — node `459:43885`/`459:43875`. Inter **Bold 36**.
   Dark `#fcfbf9` · light `#000000` → **`ext.textPrimary`** (see CONFLICT 5).
2. **"Your Learning Journey"** — node `459:43886`/`459:43876`. Inter **Medium 24**, `height: 1.3`.
   **A two-colour rich text run** — build with `Text.rich` / `TextSpan`:
   - `"Your"` → dark `#ae87e7` · light `#a0b384` → new token **`accentSoft`** (§Tokens)
   - `" "` → `#384f47` (a space; colour is irrelevant — drop the span)
   - `"Learning Journey"` → `ext.textPrimary`
   **⚠️ RTL:** in Arabic the accented word is not necessarily first. Do **not** hard-code
   `[accent, plain]` order — key the two spans off separate `.arb` entries so the translator
   controls which word is accented (§l10n).
3. **Tagline** — node `459:43887`/`459:43877`. Inter **Medium 16**, `height: 1.3`, centred,
   **two lines with an explicit break**: `"Study. Compete. Achieve.\nAll in one place."`
   Dark `#ececec` · light `#858585` → new token **`bodyMuted`** (§Tokens).
   Note the corrected spelling (CONFLICT 7). Keep the `\n` in the `.arb` value.
4. **gap 20**
5. **"Get Started"** — node `337:15648`/`459:43879`. This is the existing **`FilledButton`**: the
   theme already gives `primary` fill, `#fcfbf9` label, `h 60`, `r 20`. Label Inter **SemiBold 22**.
   Routes → **`/register`**.
   > The dark frame stacks a second copy of this button with `blur: 4px` at `mb: -60px`
   > (node `337:19258`) — that is a **glow layer**, a Figma-only effect. Do **not** render two
   > buttons. Ignore it, or approximate with the existing `drop-shadow` the theme already applies.
6. **gap 20**
7. **"Log In"** — node `337:15650`/`459:43881`. `OutlinedButton`, **copy the exact style block from
   `login_screen.dart:226–247`** (`ext.fieldFill` fill, `ext.secondaryButtonBorder` 0.5px side,
   `r 20`, `h 60`, `ext.textPrimary` 22 `w600`). See CONFLICT 3. Routes → **`/login`**.

### Files

```
lib/features/onboarding/
  screens/onboarding_screen.dart     ← the whole screen. StatelessWidget (ConsumerWidget only if
                                       you wire the LanguagePill — see below).
```
That is the **entire** feature. No `models/`, no `repository/`, no `notifier/` — there is no data.

**Reuse, do not rebuild — and mind the existing duplicate.** The shared widget is
`lib/core/widgets/language_pill.dart`, used by `registration_chrome.dart:27`. **Login does not use
it** — it carries a private `_LanguagePill` copy at `login_screen.dart:305`. So there are already
two implementations. Use the **shared** `LanguagePill`; do not create a third. (Collapsing
Login's private copy onto the shared widget is a good cleanup but is **out of scope** — note it in
the PR instead.)

The onboarding frame does **not** draw a language pill — but the very next screen in the flow
(Login `82:819`) and the success screen (`155:786`) both do, so a student who lands on Onboarding
in the wrong language has no way out. **Add the pill**, top-end, over the illustration, inside
`SafeArea`, label `l10n.switchLanguage` (the key already exists in both `.arb` files and holds the
*other* language's endonym). Wire it to `localeProvider.notifier.toggle()` from
`lib/core/providers/locale_provider.dart`, exactly as `login_screen.dart:138` does. Log the missing
pill to `DESIGN_ISSUES.md` as a design gap.

---

## SCREEN 2 — OTP success (reconcile the existing `_SuccessView`)

**Figma:** full light screen `155:786` · content block `82:1596` (= `332:3400`, identical children)
**Code:** `lib/features/auth/screens/otp_screen.dart:343` — `_SuccessView`

Everything below is a **correction to existing code**, not a new screen. The behaviour
(`AuthenticatedOutcome` → success view → `Continue` → `/home`) is already right and already tested.
Do not touch the fork, the notifier, or the routing.

### Delta table — design vs shipped

| Element | Node | Design | Currently in code | Action |
|---|---|---|---|---|
| Badge | `82:1598` | Scalloped emerald + white check, **144×140** | `Icon(Icons.check_circle, size: 96, color: cs.primary)` | Land the SVG at **144×140**; tint with new `successBadge` token, **not** `cs.primary` |
| Title | `82:1577` | "Successful", Inter **Bold 22**, `#111` | **28**, bold, `ext.textPrimary` | → **22** |
| Subtitle | `82:1578` | "**Congratulations!** You have been successfully authenticated", Inter Regular **20**, `#7c7c7c`, `height 1.3` | "You have been authenticated", **16**, `ext.textSecondary` | Restore the full sentence; **20**; `bodyMuted`; `height: 1.3` |
| Badge → title gap | `82:1594` at `y 157.999` of a 140-tall badge | **18** | 24 | → **18** |
| Title → subtitle gap | `82:1578` at `y 41.5`, title 27 tall | **14.5** → build **14** | 12 | → **14** |
| Text → button gap | block ends `267`, button top `327` | **60** | 40 | → **60** |
| Horizontal padding | block `x 17.5`, `w 363` of 402 | **17.5** → build **20** | 24 | → **20** (matches app-wide) |
| Vertical position | block top `y 245` of 878 (28%) | top-anchored, not centred | `MainAxisAlignment.center` | Keep `center` — 28% reads as optically centred once the AppBar is gone (below) |
| Continue button | `82:1591` | `#384f47`, `h 60`, `r 20`, label `#fcfbf9` SemiBold 22 | `FilledButton` via theme | ✅ **already exact — change nothing** |
| Language pill | `155:809` | Present, top-end, `78×36` | Absent (plain `AppBar()`) | See below |
| App bar / back | — | **None.** No back button on the frame. | `appBar: AppBar()` in the shared scaffold | Hide the AppBar in the success branch — going "back" from success is meaningless once tokens are stored |

The AppBar and language-pill changes touch `_OtpScreenState.build` (`otp_screen.dart:77`), not
`_SuccessView`: switch `appBar:` on `state.outcome is AuthenticatedOutcome`, and render the
`LanguagePill` in the success branch the way `login_screen.dart` does.

---

## Tokens

### Already wired — read them, never inline a hex

`ext.background` · `ext.fieldFill` · `ext.textPrimary` · `ext.textSecondary` ·
`ext.secondaryButtonBorder` · `colorScheme.primary` · `colorScheme.onPrimary`.
Read via `Theme.of(context).colorScheme` and `Theme.of(context).extension<AppColors>()!`.
Fonts are **bundled** (Inter / Tajawal / Cairo) — no `google_fonts`.

### NEW — add to `lib/core/theme/app_colors.dart`

Follow the file's existing conventions exactly: add the field, a doc comment citing the Figma node,
the value in **both** `AppColors.light` and `AppColors.dark`, and an entry in **both** `copyWith`
and `lerp`. Missing a `lerp` entry is a silent theme-animation bug.

| Token | Light | Dark | Source | Notes |
|---|---|---|---|---|
| `sheetFill` | `0x33FCFBF9` | `0x33232628` | `459:43873` / `337:15643` | 20% wash over `background`. Dark is `rgba(35,38,40,.2)` — note **38**, not the 36 in `#232428`. A 2/255 designer slip; use the frame value and flag it. |
| `accentSoft` | `0xFFA0B384` | `0xFFAE87E7` | `459:43876` / `459:43886` | The accented word in "**Your** Learning Journey". Light is a **sage green — NOT `Brand.greenPrimary`**. Dark equals `Brand.purplePrimary`. |
| `bodyMuted` | `0xFF858585` | `0xFFECECEC` | `459:43887` / `459:43877` | Muted body copy. Also replaces `ext.textSecondary` on the success subtitle (CONFLICT 5). |
| `successBadge` | **read from the SVG** | **same value** | `82:1598` | Semantic success green. **Constant across themes** — it must not follow the green→purple accent flip. Do not guess; parse the downloaded SVG's fill. |

`successBadge` being identical in both palettes is intentional and worth a comment in the file, so
nobody "fixes" it into the accent later.

---

## Assets

```bash
# via the Figma MCP — download_assets, then save into the repo
337:15166  → assets/images/onboarding_illustration.svg   # 189 KB
82:1598    → assets/images/success_badge.svg             #   4 KB
82:849     → assets/images/bird_logo.svg                 #   4 KB
```

- `assets/images/` is **already declared** in `pubspec.yaml:95`; `flutter_svg: ^2.3.0` is **already
  a dependency** (`pubspec.yaml:55`). **No `pubspec` change and no new package this round.**
- The directory currently holds only `.gitkeep` — these are its first real files.
- Render with `SvgPicture.asset(...)`. Preserve the designed geometry: the badge is
  **144×140** (not square — do not force a single dimension); the illustration is full-bleed
  `BoxFit.cover` from `topCenter`.
- If the 189 KB illustration SVG is slow to raster, fall back to the **PNG at scale 3** and say so
  in the PR — but try SVG first.
- After landing all three, **delete** the `TODO(design-asset)` comments at `login_screen.dart:144`
  and `otp_screen.dart:359`, swap the `Icons.flutter_dash` / `Icons.check_circle` placeholders, and
  close `DESIGN_ISSUES.md` #1.

---

## Router wiring — `lib/core/router/app_router.dart`

Two edits, both narrow:

1. **Line 71** — replace the placeholder:
   ```dart
   GoRoute(path: '/', builder: (_, _) => const OnboardingScreen()),
   ```
2. **Line 66** — `initialLocation: '/login'` → **`'/'`**, and delete the now-stale comment on
   line 65: *"The guard decides; onboarding ('/') stays deferred behind the guard."*

**`authRedirect` needs one change** and it is easy to get wrong. Today:

```dart
const _authRoutes = {'/login', '/otp'};
```

`/` is **not** in that set, so a signed-out student landing on `/` is redirected straight to
`/login` and **never sees onboarding**. Add `'/'` to `_authRoutes`.

Then check the signed-**in** case: `authRedirect` only bounces `matchedLocation == '/login'` → `/home`.
A returning, authenticated student launching the app at `/` would sit on the onboarding screen.
**Add `'/'` to that condition too** — an authenticated student must never see Get Started / Log In.

```dart
if (status is AuthAuthenticated && (matchedLocation == '/login' || matchedLocation == '/')) {
  return '/home';
}
```

This is why **no "onboarding seen" flag is needed**: auth state already decides. First launch →
unauthenticated → `/` renders. Returning student → authenticated → redirected to `/home` before
paint. Do not add Hive/secure-storage persistence for this.

`authRedirect` is a pure function with direct unit tests — extend them (§Acceptance).

---

## l10n — add to **both** `app_en.arb` and `app_ar.arb`

```
onboardingTitle              "Level Up"
onboardingTaglineAccent      "Your"                        # the ACCENTED span
onboardingTaglineRest        "Learning Journey"            # the plain span
onboardingSubtitle           "Study. Compete. Achieve.\nAll in one place."
getStarted                   "Get Started"
logIn                        "Log In"
```

- Two separate keys for the accent + rest so **Arabic controls which word is accented** and in what
  order. Do not concatenate at the call site in a fixed order.
- `onboardingSubtitle` keeps the literal `\n` — the design breaks the line deliberately.
- **"Achieve"**, not the design's "Achive" (CONFLICT 7).
- No key collision: `app_en.arb` currently has `loginSubtitle`, `sendOtp` and `createNewAccount`,
  but **no** `logIn` / `getStarted`. Both new keys are safe to add.
- Existing keys to **reuse, not re-add:** `otpSuccessTitle`, `continueLabel`, `switchLanguage`.
- **Change** `otpSuccessSubtitle` in both files to the full sentence:
  EN `"Congratulations! You have been successfully authenticated"` · AR — update the existing
  `"تم تسجيل دخولك بنجاح"` to carry the congratulation, matching the EN register.

---

## Acceptance checks (Definition of Done)

**Reduced state matrix.** No network call on either screen → **no loading / error / offline
states**. `screen-states` collapses to the 4 theme × direction combinations:

- [ ] Onboarding renders in **light + dark** × **AR (RTL) + EN (LTR)** — 4 combinations
- [ ] Success renders in **light + dark** × **AR + EN** — 4 combinations
- [ ] `EdgeInsetsDirectional` throughout; **no** hardcoded `left:` / `right:`; layout mirrors in AR
- [ ] The two-colour "Your Learning Journey" run reads correctly in AR — accent lands on the word
      the translator chose, not on a fixed span index
- [ ] Sheet is anchored by **fraction/content**, not a hardcoded `529`; verify at 3 heights
      (small phone ≈ 640dp, 878dp reference, tablet) — sheet must not overflow or float
- [ ] Illustration is full-bleed, `topCenter`, no letterbox and no distortion at any aspect ratio
- [ ] All 4 new tokens present in `light`, `dark`, `copyWith` **and** `lerp`
- [ ] `successBadge` value came **out of the SVG**, not from an estimate; identical in both palettes
- [ ] No inline hex anywhere in the two screens (`grep -nE '0xFF|Color\(0x'` over the new files → empty)
- [ ] All three SVGs render; `TODO(design-asset)` markers deleted; `DESIGN_ISSUES.md` #1 closed
- [ ] All copy via `AppLocalizations`; **both** `.arb` files carry every new key
- [ ] Get Started → `/register` · Log In → `/login` · Continue → `/home`
- [ ] **Router:** unauthenticated at `/` **stays** on `/` (does not bounce to `/login`);
      authenticated at `/` redirects to `/home` — both added to the existing `authRedirect` unit tests
- [ ] `initialLocation` is `'/'`; cold start signed-out lands on onboarding, signed-in on `/home`
- [ ] Success screen: no AppBar/back button in the success branch; language pill present
- [ ] Widget test: onboarding renders both buttons + both navigate; success shows the real badge,
      full subtitle, and Continue → `/home`
- [ ] Existing `test/features/auth/otp_screen_test.dart` still green. Its only success assertion is
      `find.text('Successful')` at **line 131** — the title, which is unchanged — so the subtitle
      rewrite is safe. Add an assertion for the new full subtitle while you are in there.
- [ ] `test/core/router/app_router_test.dart` extended with the two new `authRedirect` cases
- [ ] `flutter analyze` clean · full suite green

## Docs to update when done

- `DESIGN_ISSUES.md` — **close #1** (export unblocked). Add new items: dark secondary-button
  inversion (CONFLICT 3), purple-vs-green border (4), grey consolidation (5), missing dark success
  frame (6), "Achive" typo (7), onboarding has no language pill.
- `PROGRESS.md` — move onboarding out of "deferred"; correct the "Open conflicts" entry that still
  claims export is blocked; add `docs/day00_onboarding_brief.md` to the brief index.

## Scope / do NOT

- No endpoint, no repository, no notifier, no `freezed`, no `build_runner` run needed.
- No new package, no `pubspec.yaml` edit.
- No refactor of Login or of the OTP input view. Touch `_SuccessView` and the two lines of
  `_OtpScreenState.build` named above — nothing else in that file.
- Do **not** commit — leave for review.
