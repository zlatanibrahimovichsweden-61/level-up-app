# Device verification — 2026-09-20, Pixel 8 · edit5

The `edit5.md` §11.5 walk: Profile, Edit Profile, Settings, OTP and the sign-up track picker, on
hardware.

**A note on the numbers.** `#21`, `#54`, `#12` and the rest below are **`edit5.md` scope-table item
numbers** — the elevation guides' own numbering, which runs across edit1–edit5 — and they are NOT
`docs/DESIGN_ISSUES.md` entry numbers. The two registers collide: edit5 item #21 is the profile
header card, while DESIGN_ISSUES #21 is the dark Log In button. Where this file cites a
DESIGN_ISSUES entry it says so in full. The entries this walk feeds are **#40** (the sign-up track
screen, which gains the selected-card finding below), the edit5 appendix under **#72**, and the two
that stay blocked — **#45** (edit5 item 51, Mode swatches) and **#28** (edit5 item 53, the success
badge).

**A second file for the same date on purpose.** `DEVICE_VERIFICATION_2026-09-20.md` is the edit4
walk (quiz and leaderboard), run earlier the same day. The two cover different surfaces and
different waves, and merging them would bury which claim belongs to which.

| | |
| --- | --- |
| Device | Pixel 8 (`shiba`), serial `45131FDJH0009G`, Android 17 |
| Screen | 1080 x 2400 at 420 dpi — **411 x 914 dp**, 2.625 px/dp |
| Build | `flutter build apk --debug -t lib/main_mock.dart`, installed with `adb install -r` |
| Why the mock flavour | `edit5.md` §11.5 asks for it; `000000` at the OTP screen signs in as a school student, any other 6-digit code forks to registration |
| Tree | branch `merged`, `HEAD 4215e1c` + the session's uncommitted edit1–edit5 work |
| Suite at the time | `validate.ps1` OVERALL: PASS, 1317 passed / 0 failed / 1 skipped; `verify_guards.ps1` 8/8 |

**Method.** Every tap coordinate came from a `uiautomator dump`, never from eyeballing a
screenshot. Every colour claim below is **measured off the screencap pixels**, decoded by hand
(zlib inflate + PNG filters). Where a hairline is thinner than a pixel the colour is recovered
from its coverage: a 0.5 dp `#7070A0` line on cream reads (147, 147, 182), and dividing the
per-channel drop by the full-strength drop gives 0.750 / 0.748 / 0.753 — three channels agreeing
to three decimals is what identifies the colour, not the raw pixel. Screenshots live in the
session scratchpad, not the repo, matching the 09-19 and 09-20-edit4 passes.

---

## No local-only changes were needed, and none were made

The edit4 walk required three local unblocks (a route ungating, a fixture, and `FLAG_SECURE`
switched off) and a paragraph explaining each. **This walk needed none.** Every edit5 surface is
reachable in the stock `main_mock.dart` build by a student who signs in, and none of them sets
`FLAG_SECURE`, so `screencap` returns real pixels throughout. `git status` is unchanged by the
walk apart from the test and docs edits listed in the session report.

The only device-level change was `settings put system font_scale 1.3` for the text-scale checks,
**set back to 1.0** afterwards.

---

## Coverage

| edit5 item | Light | Dark | RTL | 1.3 | Result |
| --- | --- | --- | --- | --- | --- |
| #21 header card | ✅ | ✅ | ✅ | ✅ | knockout holds; the back-light mirrors — measured, below |
| #22 edit chip | ✅ | ✅ | ✅ | ✅ | **40 dp disc in a 48 dp target**, both to the pixel |
| #23 stat card | ✅ | ✅ | ✅ | ✅ | dark is **opaque `#27282C`** with no rim |
| #24 menu rows | ✅ | ✅ | ✅ | ✅ | all three tones exact; disabled is 0.45 |
| #25 avatar badge | ✅ | ✅ | — | — | **33.9 dp**, 1.5 dp shadow reach |
| #28 sections | ✅ | ✅ | ✅ | ✅ | lavender hairline light, borderless + rim dark |
| #50 languages | ✅ | ✅ | ✅ | ✅ | idle segment transparent; EN leads on the right in AR |
| #30 OTP timer | ✅ | ✅ | ✅ | ✅ | **42.3 dp**, inset only, no outer shadow |
| #31 OTP card | ✅ | ✅ | ✅ | ✅ | light neutral drop, dark lavender glow |
| #52 OTP digits | ✅ | ✅ | ✅ | ✅ | 48 dp cells, 1.50 dp focused stroke |
| #32 track cards | ✅ | ✅ | ✅ | — | the G20/G5 rim difference is visible |
| #54 art shadow | ✅ | ✅ | ✅ | — | School only, neutral, both directions |
| #12 CTAs | ✅ | ✅ | ✅ | — | dimmed = 0.45; dark glow unmistakable |

### What was NOT covered, and why

* **The OTP error state.** `edit5.md` §11.5 asks for "enter wrong code". **The mock backend cannot
  produce it**: `/auth/otp/verify` returns `authenticated` for `000000`/`111111` and
  `registrationRequired` for *every other* 6-digit code — there is no `otp_invalid` branch
  (`lib/dev/mock_backend.dart:137`). Making one would mean editing the mock, which is a code change
  to work around a device limitation, so it was not done. The state is covered by
  `otp_elevation_test.dart`'s "an otp_invalid verify turns EVERY cell red".
* **#51 Mode swatches** and **#53 success badge** — both blocked on the designer, recorded only.
* **The avatar badge in RTL**, **iOS**, and **text scales above 1.3**.

---

## Measurements

### #21 the header card

| | Light | Dark |
| --- | --- | --- |
| Shadow below the card | 14 px of gradient, deepest **(219, 218, 216)** = −33 | −5, and **outside the edge only** |
| Rim | none | **(76, 77, 80)** against a (36, 37, 41) fill = **+40** |

The dark card's fill is the page colour and its first row *inside* the bottom edge is clean, so the
knockout (edit1.md R4) holds on hardware: the shadow is painted outside the shape and nowhere else.

**The back-light mirrors in Arabic — this is the measurement `edit5.md` §13 called an assumption.**
Blue-minus-green across the header, row by row, English against Arabic:

| row | EN peak x | AR peak x | EN excess | AR excess |
| --- | --- | --- | --- | --- |
| 300 | 170 | 861 | 6540 | 6562 |
| 330 | 181 | 873 | 8021 | 8045 |
| 360 | 253 | 826 | 5985 | 6008 |
| 420 | 94 | 786 | 1434 | 1453 |
| 510 | 202 | 901 | 1402 | 1397 |

The same quantity of lavender, row for row, within 1% — and the peak has crossed from x ≈ 170–250
to x ≈ 790–870. It is behind the avatar on both canvases because the avatar crosses with it.

### #24 the menu rows

Light hairlines, recovered from coverage (page (252, 251, 249)):

| Tone | Pixel | Target | Per-channel coverage |
| --- | --- | --- | --- |
| neutral | (147, 147, 182) | `#7070A0` | 0.750 / 0.748 / 0.753 |
| emphasis | (75, 75, 74) | `#101010` | 0.750 / 0.749 / 0.751 |
| destructive | (242, 114, 113) | `#EF4444` | 0.769 / 0.749 / 0.751 |

Dark: the neutral and emphasis rows carry **only a neutral Glass rim** — (66, 67, 71) / (97, 98,
101), blue-minus-green 4, the page's own figure — while Logout still reads (204, 76, 76). The
emphasis row loses its outline in dark and Logout keeps its red on both canvases, which is what
the frames draw.

**R10's 0.45 shows up twice more, on two different mechanisms.** The disabled row's light hairline
is **0.448** of the live row's, and its dark Glass rim is **0.452** of the live rim's
(28 against 62 above the page). Neither is a colour comparison — they are the same colour at 45%.

### #50 the language track

| | Light | Dark |
| --- | --- | --- |
| Selected segment | **(174, 135, 231)** = `#AE87E7`, flat top to bottom | recessed: **(130, 101, 173)** at the top edge ramping to `#AE87E7` over 18 px |
| Idle segment | **(236, 236, 236)** | **(35, 36, 41)** |
| Bare track beside it | **(236, 236, 236)** | **(34, 35, 40)** |

**The idle segment and the bare track are the same pixels**, on both canvases. The rule that an
idle segment is transparent is now verified on hardware, not only in the widget API.

In Arabic the track mirrors as a whole: English, the frame's first segment, moves to
x 540–1028 — the **right**, which is the start in RTL — and Arabic takes the left.

### #30 / #31 / #52 the OTP surfaces

* **Pill: 111 px = 42.3 dp.** Inset bevel −15 along the top and **−42 along the bottom**; **no
  outer shadow on any edge** (the rows immediately outside are the page colour exactly). The deeper
  band is at the BOTTOM, which is where a Figma inner shadow with y = −1 puts it — see the note in
  `docs/DESIGN_ISSUES.md` #72 part 5 about `edit5.md` §12's wording.
* **Dark pill:** the pale bevel reads **+30 top, +28 right**, +3 on the other two — in an **RTL**
  render. Inset offsets are physical; they do not mirror.
* **Card:** light, a neutral drop — blue-minus-green **−2 through the whole gradient**, deepest
  (221, 220, 218) below against (226, 225, 223) above. Dark, a glow: blue-minus-green climbs from
  the page's +4 to **+16**, over about 8 dp, and the pixels get **lighter**.
* **Cells: 127 px = 48.4 dp.** Resting border **(209, 209, 209) = `#D1D1D1`** at ~1.23 dp of
  coverage; the focused cell reads **(56, 79, 71) = `#384F47`** at **1.50** dp in light and
  `#AE87E7` in dark.
* **Verify is dimmed until six digits are entered:** the empty-state button fills with
  **(164, 174, 169)**, which is 0.45 × `#384F47` over cream to the byte.

### #32 / #54 the track cards

Light: a **1 dp gradient outline** — (122, 168, 153) at the top edge and (127, 176, 160) at the
bottom, both between `#384F47` and `#95CDBB` — over a shadow that reaches 11 px above and 14 px
below, deepest (218, 217, 216). Deeper below than above, which is the (0.5, 0.5) offset.

Dark: **no outline and no shadow** — the rows above and below the card are the page colour
unchanged. What makes the card read is the rim, and **the two cards rim differently**:

| | left edge | right edge | top edge | bottom edge |
| --- | --- | --- | --- | --- |
| card 1 (School, G20) | **128** | 95 | flat 35 | flat 35 |
| card 2 (University, G5) | 97 | 75 | **97** | **75** |

Card 1 rims on its vertical edges only; card 2 rims on all four. That is the whole visible
consequence of the two Glass tokens differing by light angle alone (25 against −45), and it is why
`AppElevation` keeps them apart instead of sharing one.

**The illustration's shadow (#54) is on the phone, and only on the School card.** Measured inside
matched art windows, with the coloured art excluded:

| | School | University |
| --- | --- | --- |
| light AR — neutral-grey halo px | **5535** (darkest (215, 214, 212)) | 230 |
| light EN — neutral-grey halo px | **5588** (darkest (225, 224, 222)) | 819 |
| dark AR — px darker than the page | **6882** | **0** |

Three things at once: it is **neutral**, not a teal haze (the first implementation's failure mode —
see #40); it is **the same in both directions**, so the offset is physical; and in dark it makes
pixels **darker and never lighter**, which is what a black shadow must do. The University card has
none in any of the three.

The downward bias is visible too: grey outside the art silhouette runs 2775 px below against 1124
above, a ratio of 2.47, for an offset of (1, 2).

### #12 the CTAs

| | Light (Save) | Dark (Save) |
| --- | --- | --- |
| Fill | `#384F47` | `#AE87E7` |
| Shadow | deepest (217, 216, 214) below, (231, 230, 228) above | — |
| Blue-minus-green through the halo | **−2 throughout** — neutral | **+8 → +47** |

### Text scale 1.3

`settings put system font_scale 1.3`, then the Profile hub, Settings and the OTP screen walked in
dark Arabic. **Zero `RenderFlex` overflow lines in `logcat`** on any of them. The Settings title
grew from 214 × 68 px to 254 × 82 px, so the scale really applied; the language track kept its
115 px (44 dp) height and the labels grew inside it.

This is the device counterpart of the four widget tests added the same day. The #81 caveat runs the
other way here: the widget binding's font is ~1.5× wider than Inter, so the tests are the stricter
of the two.

---

## What the walk found

One defect, and it is **not** an edit5 regression: the invented selected state on the track card
renders as a **solid** primary card rather than the 8% wash its code reads as, taking the label
down to **2.19:1**. It is identical at `HEAD`, `edit5.md` §7.10.1 says to keep that state exactly
as it was, and it is recorded in `docs/DESIGN_ISSUES.md` #40 for the designer. Nothing was changed.
