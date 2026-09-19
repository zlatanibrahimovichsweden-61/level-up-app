# Device verification — 2026-09-19, Pixel 8

The `edit2.md` §11.5 walk, plus the first on-hardware look at the recalibrated Glass rim
(`docs/DECISIONS.md` D-011, `docs/DESIGN_ISSUES.md` #72).

| | |
| --- | --- |
| Device | Pixel 8 (`shiba`), serial `45131FDJH0009G`, Android 17 (API 37) |
| Build | `flutter build apk --debug -t lib/main_mock.dart`, installed with `adb install -r -d` |
| Why the mock flavour | `edit2.md` §11.5 asks for it — no server is needed, and `000000` at the OTP screen signs in as a school student |
| Tree | branch `merged`, `HEAD 9f415dd` + the session's uncommitted elevation work |
| Suite at the time | `validate.ps1` OVERALL: PASS, 1130 passed / 0 failed / 1 skipped; `verify_guards.ps1` 8/8 |

**Method.** Every tap coordinate came from a `uiautomator dump`, never from eyeballing a
screenshot. Colour claims below are measured off the screenshot pixels, not judged by eye.
Screenshots and crops live in the session scratchpad, not the repo.

One environment note worth keeping: `adb` reported the device `unauthorized`, then `offline`,
and only `adb kill-server && adb start-server` cleared it — twice. The device also drops off
the bus if the cable is nudged.

---

## What the walk covered

The app does **not** follow the system canvas — `cmd uimode night no` changes nothing. The
canvas is the app's own stored preference, so both themes were reached through
**Settings → Mode**, and both languages through **Settings → Languages**.

| edit2 item | Light | Dark | RTL | Result |
| --- | --- | --- | --- | --- |
| #2 nav bar shadow | golden only | ✅ | — | dark nav renders on `#212226` with the purple-tinted shadow; the light shadow is GOLDEN VERIFIED, not device |
| #8 back chip, standard | ✅ | ✅ | ✅ | see below — the clearest rim evidence of the walk |
| #8 back chip, registration | — | ✅ | ✅ | visibly a *different* chip from the standard one, which is the point of the variant |
| #12 primary CTA | ✅ | ✅ | ✅ | the dark lavender glow is unmistakable |
| #12 destructive CTA | ✅ | ✅ | ✅ | red, drop shadow, **no glow** — as Figma's Logout dialog draws it |
| #13 outline CTA | ✅ | ✅ | — | shadow present; colours unchanged per #21/#22 |
| #18 limit-sheet scrim | ❌ not walked | n/a (blocked) | — | needs 50 questions consumed in one session; its code path is proven by the sheet blur below |
| #26 form field | ✅ | ✅ | ✅ | measured, see below |
| #27 dialog scrim | ✅ | ✅ | ✅ | light sharp, dark blurred |
| #27 sheet scrim | ✅ | ✅ | ✅ | light sharp, dark blurred |
| #27 opaque panels | ✅ | ✅ | ✅ | no see-through dialog or sheet in either canvas |
| #29 onboarding sheet | — | ✅ | — | the frosted top band is visible |
| #33 language pill | ✅ | ✅ | ✅ | correct on a dark page; see the observation below for the onboarding screen |

---

## The Glass rim, on hardware

**The back chip is the best evidence in the walk.** On the OTP screen in dark, the 35×35 chip
draws its rim **bright along the top-left arc**, **absent** at the top-right and bottom-left,
and **present but dimmer** along the bottom-right arc. That is the calibrated model exactly:
two lobes on the light axis, a dead zone across the two corners square to it, the far lobe at
0.65 of the near one. Under the `.abs()` model this chip drew one flat, even ring.

**The form field measures right for its own angle.** The Login phone field (G4,
`lightAngle` 28) reads, off the screenshot pixels:

| edge | peak luma | expected |
| --- | --- | --- |
| left | 79.2 | lit — `\|facing\|` 0.883 |
| right | 70.0 | far lobe |
| top | page | `\|facing\|` 0.469, **below the 0.48 threshold — no rim** |
| bottom | page | same |

A field lit on its left and right but not its top and bottom is a directly visible consequence
of the threshold; the old model drew all four edges as a function of `\|cos\|` alone.

**The registration chip (G2, angle 22, intensity 0.25)** draws a near-complete ring with two
short gaps rather than two clear arcs — also as predicted: at intensity 0.25 the whole rim is
faint, and each lobe spans ~123° of the circle.

**Strength reads right at D-011's 70%.** Nothing in the walk looked over-bright; the chrome rim
is legible where it used to be invisible, and the level card and fields are where they were.

---

## The scrims, on hardware — the part only a device proves

- **Light dialog / light sheet:** the page behind stays **sharp** under `rgba(49,49,49,0.3)`.
- **Dark Logout dialog:** the page behind is **blurred** (σ 9.95) under a 60% scrim, and the
  panel is opaque `#232428`. 
- **Dark avatar sheet:** blurred at σ 14.7, panel opaque, and correct in RTL — the ✕ moves to
  the leading edge and the rows mirror.

That covers both halves of `app_modal.dart`: `showAppDialog` with a blur and `showAppModalSheet`
with a blur. The limit sheet's light blur is the same `showAppModalSheet` path with a different
σ, so the mechanism is verified even though that sheet was not reached.

---

## Observations — none of them edit2's, none of them fixed here

Recorded because the walk surfaced them, not because this pass owns them.

1. **The dark language pill sits on a light illustration on the onboarding screen.** Its dark
   token is a 20% `#232428` fill with a white Glass rim — over the pale illustration that reads
   as a muddy grey-green wash, and the white rim is invisible because the backdrop is already
   bright. All seven dark pill instances `edit2.md` #33 lists sit on dark pages; the onboarding
   dark screen is not among them. **A designer question, not a build defect.**
2. **The Login brand mark renders near-black on the dark canvas** and is barely visible. This
   is the missing-brand-SVG gap already recorded for Day 1, not an elevation issue.
3. **`_PhoneField` never passes `hasError` to `FieldShell`.** An invalid phone shows red helper
   text while the field keeps its neutral border, where every other `FieldShell` turns its
   border 1.5 `cs.error`. Pre-existing: edit2 #26 migrated the decoration faithfully and was
   not asked to change behaviour.

## What this pass does NOT claim

- The limit sheet (#18) was **not** reached.
- The light nav-bar shadow is **GOLDEN VERIFIED**, not DEVICE VERIFIED.
- `edit2.md` §12's node-by-node visual QA against Figma is a separate exercise; this walk
  checked behaviour and treatment, not pixel-for-pixel agreement with each frame.
