# Device verification — 2026-09-20, Pixel 8

The `edit4.md` §11.5 walk: the quiz flow and the leaderboard, on hardware, for the first time.
Companion to `docs/DESIGN_ISSUES.md` #81–#88 and the edit4 appendix there.

| | |
| --- | --- |
| Device | Pixel 8 (`shiba`), serial `45131FDJH0009G`, Android 17 |
| Screen | 1080 x 2400 at 420 dpi — **411 x 914 dp** |
| Build | `flutter build apk --debug -t lib/main_mock.dart`, installed with `adb install -r` |
| Why the mock flavour | `edit4.md` §11.5 asks for it; `000000` at the OTP screen signs in as a school student and `111111` as a university one |
| Tree | branch `merged`, `HEAD 4215e1c` + the session's uncommitted edit4 work |
| Suite at the time | `validate.ps1` OVERALL: PASS, 1244 passed / 0 failed / 1 skipped; `verify_guards.ps1` 8/8 |

**Method.** Every tap coordinate came from a `uiautomator dump`, never from eyeballing a
screenshot. Every colour claim below is **measured off the screencap pixels** — the fill is the
most common colour in a box, the label is the pixel furthest from it in luminance, and the ratio
is WCAG 2.1 with sRGB linearisation. Nothing here is judged by eye. Screenshots and crops live in
the session scratchpad, not the repo, matching `DEVICE_VERIFICATION_2026-09-19.md`.

---

## The three local-only changes, and their removal

A device claim is worth nothing if what was on the phone is not stated. Three things stood between
a Pixel 8 and the edit4 surfaces. All three were reverted; `git diff` against `HEAD` for each file
is empty, and the reinstalled build was re-checked on the phone.

| Change | Why it was needed | State now |
| --- | --- | --- |
| `/leaderboard` → the real `LeaderboardScreen` | D-008 still serves the placeholder | reverted — the reinstalled build shows "Coming soon" again, confirmed on the device |
| a `GET /leaderboard` fixture in `lib/dev/mock_backend.dart` | ungating alone renders the 404 state, not rows | reverted |
| `screenProtectionProvider` overridden to a no-op, **in `lib/main_mock.dart` only** | the quiz screen sets `FLAG_SECURE`, so `screencap` returns a black frame | reverted |

**The third deserves a second look, and is recorded here rather than buried.** It is a security
control and it was switched off — through the seam the feature was built with, in the throwaway
preview entrypoint, against fabricated mock questions, on the owner's own device, for one session.
The shipping path (`bootstrap()` → `main_prod.dart`) was never touched. Without it, four edit4
surfaces — the question card, the option-tile hairlines and badge ring, the previous-question
button and the AI explanation panel — could not have been photographed at all: a `screencap` of
that screen comes back ~16 KB of black instead of ~130 KB.

The owner authorised a local-only ungating for this walk on 2026-09-20 and forbade committing one.

---

## What the walk covered

**Setup → Quiz → AI panel → Result → Review → Leaderboard**, plus Settings and Profile, across
light and dark, English and Arabic, at text scale 1.0 and 1.3, ending with logout → re-login.

The app does not follow the system canvas — both themes were reached through **Settings → Mode**
and both languages through **Settings → Languages**, as `DEVICE_VERIFICATION_2026-09-19.md`
records.

| edit4 item | Light | Dark | RTL | 1.3 | Result |
| --- | --- | --- | --- | --- | --- |
| #11 setup length chips | ✅ | ✅ | ✅ | — | chips mirror to the leading edge in Arabic on their own |
| #14 AI explanation panel | ✅ | ✅ | — | — | the G18 Glass and its lavender back-light are unmistakable in dark; light is the flat hairline card |
| #15 result buckets | ✅ | ✅ | ✅ | ✅ | |
| #16 rewards card + star disc | ✅ | ✅ | ✅ | ✅ | the 33 dp disc; **no overflow at 1.3 in Arabic** — see #85 |
| #17 review filter pills | ✅ | ✅ | — | — | measured, below |
| #19 scope toggle | ✅ | ✅ | ✅ | ✅ | measured, below |
| #20 leaderboard rows | ✅ | ✅ | — | — | the unglassed `isMe` row sits visibly apart from its glassed neighbours; measured, below |
| #46 previous-question button | ✅ | ✅ | ✅ | — | **207 x 152 px = 79 x 58 dp**, Figma's numbers exactly |
| #47 question card + idle hairlines | ✅ | ✅ | — | — | |
| #48 dark review answer rows | ✅ | ✅ | — | — | measured, below |
| #82 shared header | ✅ | ✅ | ✅ | ✅ | both back paths behave — see below |
| #83 dark badge ring | — | ✅ | — | — | lavender, matching the tile hairline beside it; light unchanged |
| #84 idle segment transparent | ✅ | ✅ | ✅ | ✅ | on **both** consumers |
| §7.10 "Leave this quiz?" dialog | ✅ | — | — | — | with its scrim |

**Navigation.** Review's back chip returns to Result, and Result's "Back to Learn" steps over the
finished quiz **and** its setup screen rather than walking back through them — which is the whole
reason that screen passes `_leave` instead of the default `maybePop`.

**RTL chevrons mirror.** The previous-question button's chevron points right in Arabic and left in
English, and `CircleBackButton`'s does the same. The 2026-09-20 tablet walk recorded chevrons that
never mirrored; these do.

**logout → re-login.** Signing out and back in on the other track swapped the Learn tab from the
school subjects to the university ones and moved the points balance. The profile is refetched, not
served stale.

---

## Measurements

All figures are contrast ratios of the rendered label against its own rendered fill.

### The scope toggle — `#19`, and the evidence for `#77`

| | fill as rendered | label | ratio |
| --- | --- | --- | --- |
| selected "System", light | `rgb(219,176,255)` = `#DBB0FF` | `#FCFBF9` | **1.74:1** |
| selected "System", dark | `rgb(196,168,227)` = `#C4A8E3` | `#FCFBF9` | **2.02:1** |
| idle "Governorate", light | `rgb(236,236,236)` = `#ECECEC` | `rgb(56,79,71)` = `#384F47` | 7.48:1 |
| idle "Governorate", dark | `rgb(35,36,41)` | `#FCFBF9` | 14.98:1 |

Both selected figures reproduce the computed ones **exactly**, so #77's arithmetic is confirmed on
hardware rather than merely recomputed. Two side effects worth keeping:

- the light fill measuring `#DBB0FF` confirms the 2026-09-20 re-read of `scopeSelectedFill`
  landed — the old value was `#D8B0FF`;
- the light idle label measuring `#384F47` confirms `scopeIdleLabel` is the READ dark green and
  not the `textSecondary` grey `edit4.md` §7.8 assumed.

On the phone the washed-out selected label is obvious beside its idle neighbour.

### The leaderboard rows — `#20`, and the evidence for `#86`

| | fill as rendered | label | ratio |
| --- | --- | --- | --- |
| the caller's own row, light | `rgb(216,176,255)` = `#D8B0FF` | `#FCFBF9` | **1.75:1** |
| the caller's own row, dark | `rgb(216,176,255)` = `#D8B0FF` | `#FCFBF9` | **1.75:1** |
| an ordinary row, dark | `rgb(35,36,40)` — the 20% wash | `#FCFBF9` | 14.99:1 |

### The quiz page's graded tiles — the evidence for `#87`

| tile | canvas | fill as rendered | label | ratio |
| --- | --- | --- | --- | --- |
| correct | dark | `rgb(191,255,195)` — opaque | `#FCFBF9` | **1.11:1** |
| wrong | dark | `rgb(101,83,86)` — the 30% wash | `#FCFBF9` | 6.94:1 |
| idle | dark | `rgb(39,40,44)` | `#FCFBF9` | 14.24:1 |
| correct | light | `rgb(191,255,195)` | `rgb(14,14,14)` | 16.83:1 |
| wrong | light | `rgb(253,233,232)` | `rgb(14,14,14)` | 16.54:1 |

### The review screen — `#48`, `#17`, and `#53`'s comparison

| | fill as rendered | label | ratio |
| --- | --- | --- | --- |
| answer row, correct, dark | `rgb(66,80,71)` = `#425047` — the 20% wash | `#FCFBF9` | **8.22:1** |
| answer row, wrong, dark | `rgb(79,67,70)` — the 20% wash | `#FCFBF9` | **9.13:1** |
| selected filter pill, dark | `rgb(174,135,231)` = `#AE87E7` | `rgb(35,36,40)` | **5.48:1** |

The measured 8.22:1 against #54's computed 8.24:1 is a useful check on that arithmetic: the phone
and the spreadsheet agree to within rounding.

The filter pill is the same lavender family as the scope toggle and the `isMe` row, drawn the
other way round — a dark label on the accent. It is recorded as an **existing product precedent**
for designer context, **not** as a proposed fix for #86 or #77.

---

## What the walk settled

### `#81` — a device false positive

| | segments | groove | scrolls? |
| --- | --- | --- | --- |
| EN, text scale 1.3, 411 dp | 487 px = **186 dp** each | spans `x 53..1028`, the full width | **no** |
| AR, text scale 1.3, 411 dp | 488 px = **186 dp** each | full width | **no** |

`System | Governorate` fits. The build-level measurement of a 101 px overflow at 375 dp came from
the test binding's font, which is ~1.5x wider than Inter — exactly the caveat #81's own body
records, and exactly the case D-012 already saw once. **No copy change is needed and nothing is
owed by the copy owner.**

### `#84` — the fix, on both consumers

The groove's rim and inner shadow run continuously across the idle half of the control, on the
leaderboard scope toggle **and** on the Lectures quiz-type tabs. The latter is edit3's screen,
where the defect originated.

`test/goldens/quiz_type_tabs_dark.png` moved by **1699 pixels of 27336**, `x 32..369`, `y 12..55`
— the full groove width, in exactly the two inset-shadow bands — at a **max channel delta of
9/255**, against the scope toggle's 19/255. So it was the same defect and a milder one, because
the pill track's inset shadows are the weaker pair. That is worth saying plainly: at 9/255 nobody
would have caught that screen by looking. It was caught because the primitive was made incapable
of it. No other golden moved; the repo's 38 are still 38.

### `#53` — the comparison D-010 asked for now exists

D-010 deferred whether the quiz page's graded tiles should follow the review rows onto a 20% wash,
and asked for the two to be seen **side by side** before anyone ruled. They have now been, one tap
apart, on the same phone, in the same session, and both are measured above: **8.22:1 / 9.13:1** on
the review rows against **1.11:1** on the quiz page's correct tile.

The ruling is still the owner's. Neither treatment was changed.

---

## Not covered

- the **university Lectures quiz-type tabs in Arabic** — the tabs were walked in English only;
- the **offline and error states** of any edit4 screen;
- the **limit sheet** — still needs 50 questions consumed in one session;
- **iOS** — no device here at all;
- text scales **above 1.3**, which the build tests cover to 3.0 but nobody has seen.

## One observation outside the wave

Question bodies render `<u>…</u>` as literal text — see `docs/DESIGN_ISSUES.md` **#88**. The tags
come from the mock fixture, so this may be nothing at all; it is a contract question, not a
renderer fix, and it was not chased.
