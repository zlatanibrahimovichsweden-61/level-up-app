# Known bugs

Runtime defects found in built code. Distinct from `DESIGN_ISSUES.md`, which tracks
design ↔ contract gaps — everything here is our own code being wrong.

Format: what breaks · how to reproduce · root cause (`file:line`) · why tests missed it ·
the fix. Entries keep their history after being fixed — the "why tests missed it" note is
the point.

---

## BUG-001 ✅ The whole registration wizard red-screens on device

**Status:** FIXED 2026-07-27 (found 2026-07-26; the fix was deferred one day, then taken).

**What breaks:** verifying an OTP for a phone with no account (the `registrationRequired`
fork) navigates to `/register` and immediately paints Flutter's red ErrorWidget. Sign Up_1,
the track picker, and both Day-3 track-detail screens are therefore **unreachable on a real
device**. The `authenticated` fork (existing account → `/home`) is unaffected.

**Reproduce:** run the mock harness (`flutter run -t lib/main_mock.dart`), enter any valid
phone, then enter any 6-digit code OTHER than `000000`.

**Root cause (pre-fix code, kept for the record):**
`lib/features/registration/screens/signup_identity_screen.dart:52`

```dart
void initState() {
  super.initState();
  final args = widget.args;
  if (args != null) {
    ref.read(registrationControllerProvider.notifier).start(args); // ← illegal here
  }
```

`start()` assigns `state`, i.e. it MUTATES a provider. `initState` runs inside element
mount, which is part of the build phase, and Riverpod asserts on that:

```
Tried to modify a provider while the widget tree was building.
#10  RegistrationController.start          registration_controller.dart:29
#11  _SignupIdentityScreenState.initState  signup_identity_screen.dart:52
#13  ComponentElement.mount
...  (go_router Builder rebuild)
```

**Why 216 green tests missed it:** the assert only fires when the screen is mounted during a
*rebuild* of an existing tree — which is exactly what `context.go()` from the OTP screen
does. Every widget test pumps `SignupIdentityScreen` into a fresh `ProviderScope`, so it
mounts during the INITIAL build, where Riverpod's guard flag is not set. The bug is
invisible to direct-pump tests by construction; only router-driven navigation reaches it.

**Scope check (done):** this is the only offending line. `school_detail_screen.dart:54`,
`signup_track_screen.dart:33` and `login_screen.dart:52` all merely READ a provider in
`initState`, which is legal. `signup_track_screen.dart:39` writes, but from a tap callback.

**The fix (as proposed — the preferred option):** the seeding moved out of the widget
lifecycle entirely.

- `otp_screen.dart` — the `ref.listen` `registrationRequired` branch now builds the
  `RegistrationArgs` once, calls `start(args)`, *then* `context.go('/register', extra: args)`.
  A `ref.listen` callback runs outside the build phase, so mutating a provider there is legal.
- `signup_identity_screen.dart` — the `start(args)` call is gone from `initState`, which now
  only READS the draft for its pre-fill. `widget.args` is retained as the route payload (the
  router still passes `extra`) but is no longer what seeds the wizard; the doc comment says so.

**Rejected alternative:** deferring `start()` to `addPostFrameCallback`. One file instead of
two, but the first frame then has `draft == null`, so the expiry guard renders and
`RegistrationExpiredView` flashes before the form appears — a visible glitch traded for a
crash.

**Regression test:** `test/features/registration/registration_router_flow_test.dart` — two
cases driving login → OTP → `/register` → `/register/track` through the REAL `routerProvider`
and real `context.go`, asserting no `ErrorWidget`, that `SignupIdentityScreen` renders, that
the draft carries the token seeded at the OTP step, and that Continue reaches Choose Your
Track. Verified to actually bite: with both edits reverted it fails with the original
`Tried to modify a provider while the widget tree was building` at
`_SignupIdentityScreenState.initState`. Suite: 216 → 218 green, `flutter analyze` clean.

Two things this cost more than expected, worth knowing next time:

- `pumpAndSettle` is unusable from the OTP screen onward — the auto-focused Pinput blinks a
  cursor forever, so it times out. The test pumps a bounded 1s of frames instead.
- Reverting only the `initState` half does NOT reproduce the crash: `start()` is idempotent
  per token, so with the OTP seeding still in place the second call returns without assigning
  state. Both halves must be reverted to see the bug.

**Harness scaffolding removed with the fix:** the `START=school|university` deep-link block
and its `_MockRoot` wrapper in `lib/main_mock.dart` existed only to bypass this crash. The
wizard's front door works now, so they are gone; `lib/main_mock.dart` is back to the plain
`dioProvider` override plus `kResetSessionOnLaunch`.

---

## Note on how this was found

Found by walking the app on a Pixel 8 against the additive mock backend
(`lib/main_mock.dart` + `lib/dev/mock_backend.dart`). It had never surfaced because no
backend existed to return `registrationRequired` — the harness is what made the fork
reachable for the first time.

---

## BUG-002 ⚠️ The Mistakes cards overflow at text scale 1.3 — in Arabic only

**Status:** Mistakes overview **FIXED 2026-09-27 (API→UI Wave 15)**, SOURCE + test; device verification is owed
to the Wave 15 walk (the system font scale is the owner's to change). The card now grows with its text (the frame's 89
is its floor) and a row takes its taller card (DECISIONS D-018). Tests pump English and Arabic at 1.3 and 2.0 with
an Arabic subject name and see no overflow; a real-font render measures 101–103 at 1.3 and 131–132 at 2.0. **Still
OPEN for the Subjects grid** (`subject_card.dart:49`): the same render overflows it by 2.1 (English) and 3.1
(Arabic) at 1.3 and by 29–30 at 2.0. That is its own screen, not changed in Wave 15.
**Mistakes tree rows (API→UI Wave 16): measured, NOT affected.** `TreeListRow` has no fixed height: on a real-font
render at 1.3 and 2.0, in English and Arabic with a long Arabic unit name, the rows grow (Arabic 124 at 1.3, 171 at
2.0) and nothing overflows, before and after Wave 16's layout change. Four tests now pin it.
Found 2026-09-12, DEVICE VERIFIED then on a Pixel 8 (Android 17, API 37).

**What breaks.** On the Mistakes overview, the subject card's count caption is clipped by
a `RenderFlex` overflow once the system font scale passes ~1.2. Android draws its
yellow-and-black overflow stripe over the caption, so the one number the screen exists to
show becomes unreadable.

**Measured, not estimated.** `adb shell settings put system font_scale <s>`, Pixel 8,
mock-backed build, six subjects:

| Locale | 1.0 | 1.15 | 1.2 | 1.3 | 2.0 |
| --- | --- | --- | --- | --- | --- |
| Arabic | clean | clean | clean | **1 card: BOTTOM OVERFLOWED BY 2.7 PIXELS** | **all 6 cards: 14-27 px** |
| English | clean | — | — | clean | — |

At 1.3 only `اللغة العربية` overflows — the longest subject name in the fixture, which wraps
its title to a second line and leaves the caption no room. At 2.0 every card overflows and
the bottom-nav labels collide with each other as well, so this is not confined to Mistakes.

**Why it is Arabic-first.** `docs/RESPONSIVE.md` already records that Arabic copy runs
20-30% longer than English; this is that effect crossing the threshold. English at 1.3 is
clean, so an English-only check would have reported the screen as fine.

**Root cause.** Not Mistakes-specific. `docs/RESPONSIVE.md` Rule 4 — clamp `textScaler` at
1.3 — is **proposed and unapplied** (`app.dart:51`, queue 0/11 applied), so the app inherits
the system scale unbounded. The same audit measured `subject_card` breaking at 1.2 and the
quiz progress bar at 1.25; the Mistakes card sits in the same family and breaks between 1.2
and 1.3. Clamping alone would NOT fix it — the clamp's own bound is 1.3, which is exactly
where this appears — so the card needs to give the caption room as well.

**Why tests missed it.** The widget tests render at the default `textScaler` of 1.0 and
assert on text presence, not on layout overflow. `RenderFlex` overflow is a paint-time
error: it does not throw, it does not fail an expectation, and in a test it is invisible
unless something explicitly pumps at a raised scale and listens for the exception. Nothing
in the suite does. `docs/RESPONSIVE.md` proposes a 3-sizes x 3-scales x 2-locales matrix
test for exactly this reason and it has never been written.

**Fix.** Not attempted here — it is a design decision about what gives way (the title
truncating, the card growing, or the caption moving), and the same call applies to
`subject_card` and the quiz progress bar. Raise with the designer alongside
`DESIGN_ISSUES.md` #71, which concerns the same caption.

---

## Note on how BUG-002 was found

The Mistakes flow has no reachable populated data: the only staging test account has an
empty catalog (`seif_fight.md` S44), so both operations answer empty there regardless of
deployment. `lib/dev/mock_backend.dart` was taught the two endpoints specifically so the
flow could be walked on a device at all — and the fixture deliberately includes a
long-named subject and counts spanning every Arabic plural category. The overflow appeared
on the longest name, in the language that runs longest. A fixture of short names would have
reported a clean screen.

---

## BUG-003 ✅ A leading `+` paints after its number in Arabic (`+20` → `20+`)

**Status:** FIXED, DEVICE VERIFIED. Login and Sign-up dial chips: **fixed 2026-09-24 (API→UI Wave 01),
DEVICE VERIFIED** (Pixel 8, Arabic, light and dark, same day). Quiz result `+{points} نقطة` → `3+ نقطة`:
**fixed 2026-09-26 (API→UI Wave 13), DEVICE VERIFIED on the Wave 13 re-walk** (Pixel 8, Arabic, dark: "+3 نقطة"
paints the "+" at x 818–842 and the "3" at x 850–877; the baseline walk had the "2" at x 813–840 and the "+" at
x 847–873).
Found on the 2026-09-20 tablet walk (Huawei MatePad, AR + EN).

**What breaks.** Under an Arabic `Directionality`, the Egypt dial chip on Login and on Sign-up's
Parent's Number field reads `20+`, and the quiz result's points line reads `3+ نقطة`.

**Root cause.** Unicode bidi: `+` is class **ES**, which joins a number only when it sits
BETWEEN two numbers. At the start of a run it resolves to the paragraph direction, so in an RTL
paragraph the sign is laid out to the right of the digits. The phone `TextField` beside each chip
already set `textDirection: TextDirection.ltr`; the chip `Text` did not
(`login_screen.dart` and `signup_identity_screen.dart`, the `Phone.egyptDialCode` text).
`1,250 / 1,500` is **not** affected — whole number runs reorder correctly.

**Why tests missed it.** `find.text('+20')` matches the string whichever order it paints in. No
test asserted paint order, and English — the default test locale — is LTR, where the bug cannot
occur.

**Fix.** `textDirection: TextDirection.ltr` on both chip `Text`s. Pinned by
`test/core/visual_order.dart` → `glyphLeft()`, which compares the painted left edges of two
glyphs (order is font-independent, so the test font is fine); the two new Arabic tests failed on
the old code (`+` at x=32, `2` at x=0) and pass on the new. Reuse `glyphLeft()` for the quiz
result in Wave 13.

**Fix, quiz result (Wave 13).** The rewards line became the frame's two runs, and the "+N" run
(`pointsAwardedValue`) is its own `Text` with `textDirection: TextDirection.ltr`; the word follows it in reading
order. `quiz_result_screen_test.dart` "Arabic: "+3" keeps its sign on the left" asserts the paint order with
`glyphLeft()`; with the LTR line removed it fails (`+` at x 19.8, `3` at x 0).

---

## BUG-004 ✅ An on-screen validation error stays in the old language after a toggle

**Status:** FIXED 2026-09-24 (API→UI Wave 01), **DEVICE VERIFIED** on a Pixel 8 (Login and Sign-up
identity, AR ⇄ EN).

**What broke.** Submit Login with an empty/invalid phone in English, then tap the language pill: every
string on the screen turns Arabic except "Please enter a valid phone number". Sign-up identity did the
same with its name and parent-phone errors.

**Root cause.** The screens stored the RESOLVED message — `_phoneErrorKey = l10n.invalidPhone`
(`login_screen.dart`), `_nameErrorKey` / `_parentPhoneErrorKey` (`signup_identity_screen.dart`) —
at submit time, so the string was frozen in whatever locale was active then. The field names said
"Key"; the values were copy.

**Why tests missed it.** Every error test pumped one locale and asserted one string. Nothing changed
the locale while an error was on screen, and both screens carry a language pill that does exactly
that.

**Fix.** Store a flag (`_showPhoneError`, `_showNameError`, `_showParentPhoneError`) and look the copy
up in `build`. Pinned by one test per screen that re-pumps the SAME tree (same router instance) with
a new locale and asserts the Arabic copy replaced the English.

---

## BUG-005 ✅ The OTP success screen never shows — sign-in jumps straight to Home

**Status:** FIXED 2026-09-24 (API→UI Wave 02), **DEVICE VERIFIED** on a Pixel 8 (re-walk, light and
dark). Found the same day on the Wave 02 walk.

**What breaks.** Verifying a correct code on `/otp` should show the success view (`155:786`: badge,
"Successful", Continue). On device the app lands on Home immediately; the success view is never seen and
its Continue is unreachable.

**Root cause.** Login opens OTP with `context.push('/otp', …)` (`login_screen.dart:108`), so the router's
location is still `/login` underneath the pushed page. Verify flips `AuthController` to authenticated;
`refreshListenable` re-runs `authRedirect` (`app_router.dart`), whose `_signedInLandingRedirects =
{'/', '/login'}` rule (since `5e620e4`, 2026-07-30) sends a signed-in student on `/login` to `/home`.
`/home` replaces the whole stack, the pushed OTP page included.

**Why tests missed it.** Every success-view test pumps `OtpScreen` directly, with no router, so no
redirect ever runs. The one router-driven auth test (`registration_router_flow_test.dart`) covers only
the `registrationRequired` fork, which navigates away itself.

**Fix.** OTP is nested at `/login/otp` and Login `go`es there, so the redirect sees `/login/otp` (not a
landing route) and leaves the success view alone until Continue. A second defect surfaced on the way:
go_router re-parses the STORED location on the auth refresh and drops an `extra` it cannot JSON-encode,
so the page rebuilt with null `OtpArgs` — a red screen. The route now keeps the args it was last opened
with (`app_router.dart`); none at all → `/login`. Pinned by `test/features/auth/otp_success_router_test.dart`
(router-driven; it failed on the old push navigation) and an `authRedirect` unit case.

**Left open (owner's call):** system Back on the success view pops to Login while signed in (a pop does
not re-run the redirect) — `device_walk_results.md` W02-8.

## BUG-006 ✅ Dark mode: dropdown menus are see-through, and refused rows look selectable

**Status:** FIXED 2026-09-24 (API→UI Wave 04), **DEVICE VERIFIED** on a Pixel 8 (re-walk: dark, light,
Arabic). Found the same day on the Wave 04 walk (W04-3, W04-4).

**What breaks.** Two defects, both in the shared `ReferenceDropdown`, so every registration picker
(School and University):
1. In dark mode, an open menu is 20% opaque, so the form behind it (labels, "Select", the city link) is
   drawn through the list items.
2. In dark mode, a `soon` study year, which the contract says must be shown but refused
   (`openapi.yaml:751`), is drawn in the same cream as a selectable year. Tapping it correctly does
   nothing, but the student cannot see why.

**Root cause.** (1) `dropdownColor: ext.fieldFill`, and dark `fieldFill` is the Glass field's
`0x33232428`. (2) Refused rows were coloured `ext.hint`, and dark `hint` is `#FCFBF9`, the same as dark
`textPrimary`.

**Why tests missed it.** Every `ReferenceDropdown` test pumped `AppTheme.light` only, where
`fieldFill` is opaque `#FDFDFD` and `hint` (`#696969`) differs from `textPrimary`.

**Fix.** The menu fill is `Color.alphaBlend(ext.fieldFill, ext.background)`: opaque `#232428` in dark,
unchanged `#FDFDFD` in light, no new token. Refused rows keep the normal text colour and are dimmed to
`disabledControlOpacity` (0.6, now a shared constant in `form_fields.dart`), the same dimming a gated
field already had. Measured on the phone: dark rows `#A5A5A6` vs `#FCFBF9`; light `#6E6E6E` (was
`#696969`). Pinned by three dark/light cases in `reference_dropdown_test.dart`; the two dark ones failed
on the old code.

## BUG-007 ✅ Home: "See All" is grey, and the light Top Student card has no side or bottom outline

**Status:** FIXED 2026-09-25 (API→UI Wave 05), **DEVICE VERIFIED** on a Pixel 8 (re-walk: school light,
dark and Arabic; university light). Found on the Wave 05 walk the same day (W05-1, W05-2).

**What breaks.** (1) Every Home section header drew "See All" in `mutedText` `#B3B3B3`. All three frames
draw it in the title's colour: black in `59:1439` / `125:2373` (`59:2089`), `#FCFBF9` in `337:5456`. On the
light canvas the grey was also 2.03:1 contrast. (2) The Top Student card drew its 10% violet hairline on the
top edge only, so in light the card's sides and bottom ran straight into the canvas.

**Root cause.** (1) The Day 4 placeholder header chose `mutedText`. The theme audit's F-4-03 recorded it as
Figma-verbatim, and Wave 05's Top Student header copied it. (2) `edit3.md` #3 recorded `59:2090` as "top
only", and the surface used `ElevatedSurface.topSide`. Both frames actually say `border-[1.208px]` all round,
with `p-[1.208px]` inside it, and the frame renders show the stroke on the left and bottom edges.

**Why tests missed it.** The tests pinned what had been built, not what the frames draw. One even asserted
`side` is null because "the frame draws no full border". No test read the header link's colour.

**Fix.** "See All" uses `ext.textPrimary` in both headers (`coming_soon_section.dart`,
`top_student_section.dart`). `TopStudentSurface` draws a uniform `side` and the frame's 1.208 padding. The
padding keeps the row dividers off the outline; without it their ends double the 10% violet (seen on the
phone as `#E6D9FB` dots). The tokens were renamed `topStudentBorder` / `topStudentBorderWidth`, because they
no longer name a top-only line. `edit3.md` carries a dated correction.

Measured on the phone: "See All" `#0E0E0E` light and `#FCFBF9` dark on every header. The light outline is
`#F2EBFD` on all four sides (frame `#F1EBFC`). The dark rim now takes the violet on every side (left `#645E73`,
bottom `#514B60`; frame `#59546A` / `#4C475D`), where the bottom was neutral `#4C4D50`. Six new or changed
widget tests pin both fixes; all six failed with the old colour and the top-only line put back.
`home_section_daily_tasks_dark.png` was regenerated, and its diff is confined to the "See All" glyphs
(x 325–369, y 18–30).

## BUG-008 ✅ Leaderboard rows: wrong text colours, the caller's fill off by three, a larger avatar and a wider gap

**Status:** FIXED 2026-09-25 (API→UI Wave 06), **DEVICE VERIFIED** on a Pixel 8 (re-walk: school dark,
light and Arabic; university dark). Found on the Wave 06 walk the same day (W06-2, W06-3, W06-4).

**What breaks.** (1) Row text. The frame draws rank, name and points in ONE colour per canvas: `#4F4F4F` in
light (`134:3541` / `134:3544` / `134:3539`), `#FCFBF9` in dark (`337:5633` / `337:5636` / `337:5631`). The
build drew rank and name in `textPrimary` (`#0E0E0E` in light) and the points in `textSecondary` (`#2C2C2C`
light, `#DCDCDC` dark). (2) The caller's own row was filled `#D8B0FF`; `134:3554` and `337:5638` are
`#DBB0FF`. (3) Geometry. The frame stacks the rows 8 apart (`134:3536`) with a 32 avatar starting 40.1 in
(`134:3542`). The build had 10 between rows and a 36 avatar at 48.

**Root cause.** None of these values had been read off the frame. The row doc claimed the points were "a
shade quieter than the name in the frame", and the frame says otherwise on both canvases. `podiumAccent` kept
a 2026-09-08 reading, and its re-read was left open on purpose (`edit4.md` §19; DESIGN_ISSUES #72). The
geometry was never measured against the auto layout.

**Why tests missed it.** No test read a row's text colour, its avatar size or the gap between rows. The
palette test pinned `podiumAccent` at `#D8B0FF` and asserted it differed from the scope fill.

**Fix.** A new token `leaderboardRowText` (`#4F4F4F` / `#FCFBF9`) colours rank, name and points; the
caller's row keeps `podiumOnAccent`. `podiumAccent` is `#DBB0FF` on both canvases (its only consumer is the
caller's row). The row's avatar is 32. The rank column stays 28 wide so it still holds "200", the display
bound; the leading pad (12 → 8) and the rank → avatar gap (8 → 4) put the digit's centre at 22 and the
avatar at 40, as the frame does. The list separator is 8 (it was 10). Seven new tests pin these values, six in
`leaderboard_row_test.dart` and one in `leaderboard_screen_test.dart`. The six that pin a changed value all
failed on the old code; the seventh guards the three-digit column. It loads the app's real fonts, because the
placeholder test face draws each digit a full em wide and would wrap "200" in any 28 column.

Measured on the phone: light rank, name and points `#4F4F4F`, dark `#FCFBF9`; the caller's row `#DBB0FF` on
both canvases and both tracks; rows step 56.0 dp (8.0 gap); avatar 32.4 dp starting 39.6 dp in (Arabic: ending
40.0 dp from the right). The rank digit is centred about 21.8 dp in, against the frame's 22.2.

## BUG-009 ✅ Drill-in chevrons point right in Arabic

**Status:** FIXED 2026-09-25 (API→UI Wave 07), **DEVICE VERIFIED** on a Pixel 8 the same day: in Arabic the
grid card, a Units row and a Mistakes overview card all draw the chevron pointing left; in English, right.
Device-proven broken on a tablet on 2026-09-20.

**What breaks.** Every "drill into this row" chevron — the Subjects grid (`SubjectCard`), the Units /
Chapters / Lessons rows (`TreeListRow`) and the Mistakes overview (`MistakesSubjectCard`) — points RIGHT in
Arabic, where forward is LEFT.

**Root cause.** `forwardChevron()` returned `Icons.chevron_left` for RTL. Every Material chevron and arrow
carries `matchTextDirection: true`, so `Icon` mirrors it in RTL by itself: the two flips cancelled.
`backChevron()` had the same shape (no caller today).

**Why tests missed it.** The one RTL test (`mistakes_screens_test.dart`, "chevrons mirror in RTL") asserted
the `chevron_left` GLYPH was present. That is the bug, stated as the expectation. No test looked at what
`Icon` actually draws.

**Fix.** Both helpers are now the LTR glyph as a constant (`Icons.chevron_right`, `Icons.arrow_back_ios_new`),
and `Icon` does the mirroring. Three layers keep it fixed:
- `drill_in_chevron_test.dart` checks the DRAWN direction (glyph, reversed if `Icon` wrapped it in its x-scale
  −1 `Transform`) for all three widgets in `en` and `ar`. The three Arabic cases failed on the old helper.
- The Mistakes RTL test now asserts the same thing, and fails with the old glyph put back.
- A new source guard, `no glyph is swapped for its mirror image` (`test/guards/rules.dart`
  `mirroredGlyphSwaps`), flags any conditional between a glyph and its mirror image, whatever the condition.
  It has fixtures in `rules_test.dart` and a probe in `tool/verify_guards.ps1`, and it fired on the unfixed
  tree.

## BUG-010 ✅ A dead back chip on the Subjects root

**Status:** FIXED 2026-09-25 (API→UI Wave 08). Device-proven on a tablet on 2026-09-20 (university track), and
reproduced on every attempt on a Pixel 8 on 2026-09-25 on both tracks (Wave 07 walk, W07-6). **DEVICE VERIFIED**
on the Pixel 8 the same day (Wave 08 walk): the repro run four times, school and university, to light and to dark,
and the root never drew a chip.

**What breaks.** The Subjects root is a tab root with nothing below it, yet it sometimes draws the header's back
chip. Tapping the chip does nothing.

**Repro.** Open Learn once. Then Account → Settings → change the theme → Back → Learn.

**Root cause.** `CatalogHeader` drew the chip `if (GoRouter.of(context).canPop())`. That call answers for the
whole app, root navigator first. It is also read once, in build: `InheritedGoRouter.updateShouldNotify` returns
`false` (go_router 17.3.0), so no navigation change rebuilds the header. A theme change rebuilds every widget that
reads the theme, including the Learn branch the shell keeps offstage in its `IndexedStack`, and at that moment
Settings is still on the root navigator. So `canPop()` is true, the chip is built in, and nothing removes it after
Settings closes. Its `context.pop()` then has nothing to pop; go_router throws `There is nothing to pop` inside
the tap handler (`delegate.dart:104`), and the student sees a button that does nothing.

**Why tests missed it.** Every harness test reached the Subjects root fresh. No test rebuilt the root while a
route sat on the root navigator, and no test looked for the chip after such a round trip.

**Fix.** The header asks its own route: `ModalRoute.canPopOf(context)`. That is true only when this route has a
route below it in its own branch navigator. It is also an inherited dependency, so the header rebuilds when it
changes. It gives the same answer as before on every drill-down level (Units, Chapters, Lessons and the Mistakes
screens), and it is never true on the tab root. `catalog_header_test.dart` replays the device repro on both
tracks; both cases failed on the old header. It also checks that the chip one level down still goes back to the
root.

## BUG-011 ✅ The Lectures and Lessons rows were a progress bar to TalkBack, not a button

**Status:** FIXED and **DEVICE VERIFIED** on a Pixel 8, 2026-09-25 (API→UI Wave 08, W08-6). Found on the Wave 08
walk.

**What breaks.** On Android the accessibility tree exposed every tree row that carries a progress bar (university
Lectures, school Lessons) as `android.widget.ProgressBar`, with the bar's percentage first in the label ("37, 1,
lecture name, 44 / 120 questions"). TalkBack takes its spoken role from that class, so these rows were not
announced as buttons. Rows without a bar (Units, Chapters) were fine.

**Root cause.** `LinearProgressIndicator` wraps itself in `Semantics(role: SemanticsRole.progressBar, minValue:
'0', maxValue: '100', value: …)` (Flutter 3.44.7). The row merges its children into one node, as W08-1 intended,
and the merged node carried that role and range next to the button flag. Android chose ProgressBar.

**Why tests missed it.** W08-1's widget test asserted the `isButton` FLAG, which was set. The Android class comes
from the role, and no test looked at the role.

**Fix.** The bar is wrapped in `ExcludeSemantics(excluding: caption != null)`: the caption beside it says the
progress in words. `tree_list_row_test.dart` "a row with a bar is still a button, not a progress bar" asserts no
progress-bar role, no value, no range, the button flag, and the caption in the label. It failed on the walked
build. **Still open, same mechanism:** the Subjects grid cards (Wave 07) are exposed as ProgressBar too.

## BUG-012 ✅ A second paywall 403 on Quiz Setup stacked two limit cards

**Status:** FIXED and **DEVICE VERIFIED** on a Pixel 8, 2026-09-26 (API→UI Wave 11, W11-6). Found on the Wave 11
walk; on the re-walk a second 403 opens one card in dark and light (scrim `#969695`, not `#636363`).

**What breaks.** On Quiz Setup, a 403 `weekly_question_limit_reached` or `subscription_required` opens the limit
card. Close it and press Start again: the second 403 opened **two** cards, one on top of the other. The scrim read
`#636363` (two 50% `#313131` layers) against `#969695` for one card, and "Not now" or ✕ had to be tapped twice. A
first 403 on a fresh visit always opened one. The old bottom sheet stacked the same way.

**Root cause.** `QuizSetupNotifier.create` sets `state = const AsyncLoading()`, and Riverpod carries the previous
state's error forward onto the loading value. `_onCreationChanged` opened the card whenever `next.error` was a
sheet code, so it fired twice: once on loading-with-the-old-403, once on the new 403.

**Why tests missed it.** Every paywall test tripped the 403 once, from idle. The loading state only carries an
error when the attempt before it failed.

**Fix.** The listener returns on `next.isLoading`: only a settled result opens the card or navigates.
`quiz_setup_screen_test.dart` "a second 403 opens ONE card, not two" trips it twice and needs one tap to clear; it
failed first with 2 `LimitSheet`s. The mid-quiz 403 is a different path (the quiz Bloc) and was not affected.

## BUG-013 ✅ The back chip was an image to TalkBack on every screen that has it

**Status:** FIXED 2026-09-26 (API→UI Wave 13, owner ruling "fix it now"), **DEVICE VERIFIED** on the Wave 13
re-walk (Pixel 8: `android.widget.Button` "Back" / "رجوع" on the result, and on OTP, Review, Settings, Setup and the
catalog). Found on the Wave 13 baseline walk (Pixel 8): the result screen's back chip dumped as
`android.widget.ImageView`, clickable, labelled "Back" / "رجوع". The same widget on Review, Setup, Settings and the
catalog read the same way.

**What breaks.** TalkBack announces the shared back chip (`CircleBackButton`) as an image rather than a button. Its
label and tap work; its role is wrong.

**Root cause.** The chevron is an `SvgPicture`, which wraps itself in `Semantics(image: true)` unless
`excludeFromSemantics` is set. That flag merged into the chip's labelled button node, and Android picks ImageView
when a node carries the image flag. The W11-7 mechanism, in a shared widget.

**Why tests missed it.** `shared_chrome_test.dart` asserted the chip with the non-exhaustive `isSemantics` matcher,
deliberately, with a comment that the SVG "merges its own `isImage` into this node". The defect was documented as
noise.

**Fix.** `excludeFromSemantics: true` on the chevron. The test now asserts `isImage: false` and a tap action; it
failed first with `unexpected flags: isImage`.

## BUG-014 ✅ An Arabic question truncated at the wrong end in the English app, and TalkBack read `<u>` tags aloud

**Status:** FIXED 2026-09-27 (API→UI Wave 14, owner ruling "both screens"), **DEVICE VERIFIED** on the Wave 14 walk
(Pixel 8: the Arabic stem ellipsizes at its own end in English; no row label or stem carries a tag). Found on the
Wave 13 re-walk (Pixel 8, light English): the review list. **One part does not show on the device:** the underline
itself on Arabic stems, because Tajawal Medium / Bold declare a 0.003-em underline at the baseline (W14-10);
English stems underline normally. **Owner ruling 2026-09-27: the app draws the underline itself** (option b).
**Fixed 2026-09-27 (owner `fix`), DEVICE VERIFIED the same day** (Pixel 8: the quiz page and review; see
`device_walk_results.md`, "Fix batch"). An underlined run holding Arabic letters takes no
`TextDecoration`; the line Tajawal Regular declares (its `post` table: -75 / 50 per 1000, which the engine centres
0.075 em under the baseline, 0.05 em thick, as a real-font render confirmed) is painted under it, on each box's own
line. A run without Arabic keeps Inter's own underline. Both screens that use `QuestionStemText` (the quiz page and
review) get it. Pinned by `question_stem_text_test.dart` ("W14-10"), including a real-font pixel test that fails
on the old code.

**What breaks.** (1) A review row shows its question on one line with an ellipsis. With an Arabic stem in the English
app, the ellipsis sat before "السؤال" (the stem's START) and the end was cut mid-word ("…يص"). (2) Each row's
TalkBack label, and the quiz page's stem, carried the raw markup: "…يصف <u>التركيب</u> بشكل صحيح؟".

**Root cause.** (1) The stem was a plain `Text` under the app's `Directionality`, so an Arabic stem was an LTR
paragraph; Flutter truncates at the paragraph's logical end on its line-end side. (2) `QuizQuestion.text` allows
`<u>…</u>` (`openapi.yaml:2703`) and both renderers drew it verbatim (DESIGN_ISSUES #88).

**Why tests missed it.** Every fixture stem is English and unmarked (`'Question q1?'`); only the mock backend's
bank is Arabic with markup, and it is seen only on a device.

**Fix.** `QuestionStemText` (quiz page and review): the stem's own direction from its first strong character,
alignment from the app, and `<u>…</u>` as an underline. Tests assert the paragraph is RTL in the English app and
that neither the text nor the semantics carry a tag; with the direction logic disabled, four fail.

## BUG-015 ✅ A second student signing in on the same phone saw the first student's profile, or an error

**Status:** FIXED 2026-09-27 (API→UI Wave 19, owner ruling, D-020). **Not yet device-verified**: the Wave 19 walk runs
on the owner's `WALK`. Device-proven twice before the fix: the 2026-09-20 tablet walk, and the Wave 05 walk (W05-3).

**What breaks.** Log out from the Account tab and sign a different student in without restarting the app. On the
mock, Home and Profile kept the first student's name and points, and Home's Top Student asked `/leaderboard` with the
first student's track scope (400 `validation_failed`). On staging the same path lands the second student on "Something
went wrong" until Retry: a token-less `GET /me` is 401 `authentication_required` there (curl-checked 2026-09-27). A
fresh process was right.

**Root cause.** `invalidateSessionScope` runs inside `logout()` while Home and Profile still watch `meProvider`; the
shell unmounts a frame later. Riverpod rebuilds a watched provider on the next frame, so `GET /me` went out with no
token and its answer (the first student on the token-blind mock, a 401 on staging) was cached into the next session.
Nothing refetched at the next sign-in. Riverpod 3.3.2 also keeps a provider's previous value through every rebuild
(`copyWithPrevious`; an invalidation never disposes a non-autoDispose element), so the first student stayed readable
(`.value`) even in the error state. A throwaway probe showed that re-invalidating at the next sign-in would still
paint the first student's name while the second's `/me` loaded.

**Why tests missed it.** `session_isolation_test.dart` proves the invalidation with no widget listening, so the
provider was never rebuilt without a token, and it stubs the repository, so the mock's token-blind `/me` never came
into play. Only a router-driven test with Home and Profile mounted reproduces it.

**Fix.** `meProvider` is autoDispose. Home keeps it alive inside the shell, so tab switches still cost no request;
the sign-out unmounts the shell and drops it. `MeNotifier` re-arms its disposal flag on every build: Riverpod 3 keeps
the notifier across rebuilds and runs the dispose callbacks on each, and this provider is rebuilt in use (a finished
quiz, a saved edit). Pinned by `profile_relogin_test.dart` (router-driven: the second student on Home and Profile in
the mock and the staging shapes; the profile gone from the container at sign-out; nothing of the first student while
the second's `/me` is in flight), all four red on the old provider; and by `me_notifier_test.dart` ("a Retry still
lands after the profile was rebuilt in use"), red without the re-arm. The test harnesses hold the provider the way
they hold the boards (`holdProfile`).

**Not changed.** The invalidation at sign-out still rebuilds `meProvider` for that one frame, with no token (one 401
on staging, absorbed by `forceLogout`'s guard). The other non-autoDispose session providers (subjects, the subject
tree, the Mistakes overview) are invalidated the same way and were not changed; whether they carry the same stale
value across a sign-out is unproven. A related latent issue in other autoDispose notifiers (a disposal flag that stays
set after a rebuild, so e.g. Top Student's Retry after a quiz sticks on its skeleton) was probe-proven and filed as a
separate task.

## BUG-016 ✅ Every locked row on Edit Profile was announced twice

**Status:** FIXED 2026-09-28 (API→UI Wave 20). Found by a read-only review lens, confirmed by a throwaway semantics
probe. Not yet device-verified: the Wave 20 walk runs on the owner's `WALK`.

**What breaks.** TalkBack reads each locked row (phone, city, school…) with its label and its value twice: the row's
one node carried the label "City\nCity\nCairo" and the value "Cairo".

**Root cause.** `ReadOnlyField` wraps its column in `Semantics(label:, value:, hint:)`, and the `FieldLabel` and value
`Text` under it merged their own labels into the same node.

**Why tests missed it.** No test read a locked row's semantics. The widget tests asserted structure (no `TextField`,
no `InkWell`), which the row always passed.

**Fix.** `excludeSemantics: true` on that `Semantics`, so the node says the label, the value and the locked hint once.
Pinned by "I2: a locked row is announced once" in `edit_profile_screen_test.dart`, which fails on the old widget.

## BUG-019 ✅ The quiz's "<" button drew its arrow at about half the frame's size

**Status:** FIXED 2026-09-29 (API→UI Wave 22). Found by a read-only review lens on the flashcards study screen, which
shares the button; confirmed by rendering the button in a throwaway test and reading its pixels. Not yet
device-verified.

**What breaks.** The "<" (previous) pill on quiz questions 2 and later drew an arrow about 8.8 x 15.2 dp inside its
79 x 58 pill. The frames (`159:845` quiz, `225:5582` flashcards) draw it 16.57 x 28.64, about half the pill's height.

**Root cause.** The button took the glyph VECTOR's size (16.57 x 28.64, `225:5624`) as the box for
`assets/icons/chevron.svg`, but that asset is a 15 x 30 viewBox whose glyph is only 9.2 x 15.91. The frame's arrow BOX
is `225:5623`, 27 x 54: the same asset at 1.8x, its top 4 dp below the pill's. Since `e71e9a1` (2026-09-21, edit4).

**Why tests missed it.** The tests pinned the pill (79 x 58), the flip and the semantics, never the drawn glyph. The
Wave 12 walk measured the pill, not the arrow.

**Fix.** `StudyPreviousButton` (`lib/core/widgets/study_session_chrome.dart`, shared by the quiz and the flashcards
study screen) draws the asset in the frame's 27 x 54 box, centred, 4 dp from the pill's top. Pinned by the glyph-rect
tests in `study_session_chrome_test.dart` (EN and AR). The quiz's "<" changes with it, to its own frame's size.

## BUG-020 ✅ A flashcard's text takes the app's direction, not its own

**Status:** FIXED 2026-09-30, on the owner's request; device-verified the same day (a targeted re-walk on the Pixel 8,
all four language / content combinations PASS). Found 2026-09-29 by the API→UI Wave 22 walk on the Pixel 8.

**What breaks.** In Arabic, an English card lays out right-to-left, so its closing "?" jumps to the start of the last
line: "Which plane divides the body / ?into right and left parts". In English, an Arabic card lays out left-to-right,
so its closing full stop lands at the right end of the sentence. Card text is the lecture's content, not UI copy, so
either language can appear in either UI.

**Root cause.** `FlashcardFlipCard` builds both faces as plain `Text` with no `textDirection`
(`lib/features/flashcards/widgets/flashcard_flip_card.dart:201`, `:257`), so each face inherits the app's
`Directionality`. The quiz's question text already sets the direction from its content (`Bidi.startsWithRtl` /
`startsWithLtr`, `lib/features/quiz/widgets/question_stem_text.dart:81`); the flashcard did not reuse that.

**Why tests missed it.** The Arabic card tests (`flashcard_flip_card_test.dart:477`,
`flashcard_study_screen_test.dart:1623`) pump Arabic cards in the Arabic locale, where the content and the UI agree,
and check centring and mirroring; the Arabic-locale tests with English decks check layout. No test reads the laid-out
direction. The mock deck has Arabic cards; the walk read them in the English UI.

**Scope.** Only neutral punctuation at a line's end moves (`?`, `.`). The Arabic "؟" is a strong right-to-left
character and stays put; the Arabic comma "،" is not strong (a separator, like "."), but between Arabic words it
resolves right-to-left, so it stays put too; a bracket pair resolves as a pair. (Corrected 2026-09-30: this entry first
called "،" strong.) Setup's subject and lecture lines and the Lectures rows also take the UI's direction; the walked
names end in no neutral punctuation, so nothing showed there.

**Fix (2026-09-30).** `contentTextDirection` (`lib/core/widgets/content_text_direction.dart`) is the quiz stem's rule as
a function: the direction of the text's first strong character, the app's when it has none. Both faces of
`FlashcardFlipCard` and the card's screen-reader label take it; the faces stay centred. Setup's subject and lecture lines
take it too, aligned at the app's start as the quiz stem is. The quiz is unchanged and keeps its inline copy of the rule;
`test/core/widgets/content_text_direction_test.dart` ties the two together.

**Tests.** +19. A new group in `flashcard_flip_card_test.dart` (the four combinations on both faces with the mock deck's
own cards; the app's language does not move a card's text; text with no letters follows the app; the label's
direction; the image path), two in `flashcard_study_screen_test.dart`, four in `flashcard_setup_screen_test.dart` (both
directions, and a wrapped name keeps the app's start), two for the helper. The check
(`test/features/flashcards/reading_order.dart`) walks every word and mark in reading order, so a failure names the mark
that moved. Red first: with the fix reversed, 12 failed (209 / 12), naming "?" after "parts" and "." after "الأمام";
with it, 221 / 0. Two of the card tests pin only the direction ("؟" and a bracket pair draw the same either way); the
alignment tests fail without the Setup alignment (0 / 2). validate: format PASS · analyze 0 · 2036 / 0 / 0.

**Device (2026-09-30).** The Arabic app now ends "into right and left parts?" with the "?" on the right, and the English
app ends "إلى الأمام." with the full stop on the left; each card's interior is pixel-identical in the two apps, and the
English card in the English app is pixel-identical to the pre-fix walk (`device_walk_results.md`).

**Still open, outside this fix.** The Lectures rows and the other catalog names (subjects, units, chapters, lessons,
Mistakes) render content-language names in the app's direction by the same mechanism; they are shared screens the fix
did not touch. And the first-strong rule reads an Arabic sentence that opens on a Latin term ("ATP هو …") as left to
right, so its closing "." lands at the right: the quiz's rule, reused as the owner asked.
