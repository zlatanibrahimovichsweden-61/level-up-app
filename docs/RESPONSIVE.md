# Responsive & Text-Scaling Rules

**Status:** proposed, 2026-08-11. Derived from the ten-agent audit
(`.ai/audits/current/responsive.md`). Nothing here has been applied to code yet.

This file exists because this rule previously had **no home** — not in the
vault's `01_Flutter_Specs/`, not in `.claude/skills/`, not in `docs/`. Every
other engineering rule in this project lives somewhere; responsive behaviour was
the gap.

---

## The shape of the problem

Level Up is a **single-form-factor phone app for one market**. It does not need
breakpoints, a sizing-utility package, or a `ResponsiveBuilder`. Reaching for
those would be the "blindly add responsive abstractions everywhere" failure.

The audit measured 361 numeric `width:`/`height:` literals in `lib/`. **339 of
them are correct**: gaps, border strokes, line-height ratios, icon boxes,
skeleton blocks. Fixed dimensions are not the problem.

**The problem is 22 sites where a fixed box wraps scalable text.** That is the
entire responsive defect surface, and it is small enough to fix by hand.

---

## Rule 1 — No breakpoints. One `LayoutBuilder`.

Every screen is a single column that already stretches. Target the **320–430dp**
band. Treat tablets as *must not crash*, not *must be designed for* — which is
already what `onboarding_screen.dart:44-50` documents.

> **`LayoutBuilder` is allowed only where a child's width must be derived from
> the parent's. It is not a general layout tool.**

Exactly one site currently qualifies: `quiz_setup_screen.dart:224`, where fixed
`width: 171` chips can never render two-up on any phone under 412dp. The fix is
`LayoutBuilder` computing `(maxWidth - 15) / 2` — not `if (width > 600)`.

## Rule 2 — `minHeight`, never `height`, around anything containing text

Fixed `height:` stays legal for icons, spinners, images, ornaments and gaps —
where it is ~90% of current uses and entirely correct.

The moment a box contains a `Text`, it must be free to grow:

```dart
// NO — clips the moment the user raises their font size
SizedBox(height: 35, child: Text(title))

// YES
ConstrainedBox(constraints: const BoxConstraints(minHeight: 35), child: Text(title))
```

## Rule 3 — Prefer an explicit line-height ratio over a fixed container

The **best-built widget in the app** for text scaling is the bottom nav bar, and
the reason is one line: `fontSize: 11, height: 14/11` (`main_shell.dart:238-242`).
Because the ratio is explicit, the line box is exactly `14 × scale`, the
arithmetic is predictable, and the bar survives **2.5×**.

Copy that pattern. It is cheaper than any layout abstraction.

## Rule 4 — Text scale is clamped at 1.3

> **⚠ PRODUCT DECISION — not yet taken.** Clamping caps a real accessibility
> feature on a product used by students who may need large text. It must be
> logged in `docs/DECISIONS.md` before it ships, whichever way it goes.

The proposal: three lines in the `builder:` that already exists at `app.dart:51`.
This neutralises 20 of the 22 defects outright.

1.3 rather than 1.5 because `subject_card` (breaks at 1.2) and the quiz progress
bar (breaks at 1.25) must be fixed regardless — 1.3 is the bound at which the
*rest* of the app is provably safe.

**A clamp is not a substitute for fixing the two sites below it.**

## Rule 5 — Unflexed `Text` in a `Row` is a bug

5 of 87 `Row`s contain an unflexed `Text`. Wrap in `Flexible`/`Expanded`.

**Note on a premise that turned out to be wrong:** it is widely assumed Arabic
runs 20–30% longer than English and therefore overflows tight `Row`s. The audit
checked the actual ARB pairs and **refuted this for this codebase** — Arabic here
is mostly equal or shorter (`See All` → `عرض الكل`), and the two longer strings
already sit in ellipsised `Expanded` slots. Do not justify layout changes with
this claim without re-checking the ARB.

## Rule 6 — The real RTL risk is vertical, not horizontal

Bundled font line-heights, read from the font tables:

| Font | Line height |
| --- | --- |
| Inter | 1.210em |
| Tajawal | 1.200em |
| **Cairo** | **1.874em** |

Arabic resolves to Tajawal today, so it is safe. **Any fallback into Cairo makes
every fixed-height box 55% undersized.** There is no `strutStyle` anywhere in the
app to protect against this.

Related, and currently broken: **Tajawal ships no w600, and 45 call sites request
it** — so Arabic semibold renders wrong and `Cairo-SemiBold.ttf` can never load.

## Rule 7 — Touch targets are 48×48 minimum

Material's minimum. The 35dp back chip and four similar controls paint at 35 and
must carry a 48dp hit box. Paint size and tap size are independent — do not
resize the artwork to fix the target.

## Rule 8 — Every interactive control has an accessible name

`IconButton` → `tooltip:`. `GestureDetector`/`InkWell` → wrap in
`Semantics(button: true, label: …)` or `Semantics(link: true, …)`. Eight controls
currently have none.

---

## Guard test

The pattern already exists in this repo at `onboarding_screen_test.dart:209-231`.
Generalise it:

- **3 sizes** × **3 text scales** (1.0 / 1.3 / 2.0) × **2 locales** (en / ar)
- assert `tester.takeException() == null` after pump

**Caveat, stated up front:** this catches `RenderFlex` overflows. It does **not**
catch silent `Stack` clipping — the `subject_card` defect produces no exception,
it just cuts the text off. That needs explicit size assertions on the specific
widgets. A green guard test is necessary, not sufficient.

---

## The fix queue

Ranked, with `file:line`. Full detail in `.ai/audits/current/responsive.md`.

| # | Where | Change |
| --- | --- | --- |
| 1 | `catalog/widgets/subject_card.dart:21`, `screens/subjects_screen.dart:175,201` | Drop `childAspectRatio`; use `mainAxisExtent`. **Overflows at 1.2×** |
| 2 | `quiz/screens/quiz_screen.dart:259,268` | `preferredSize` 30 → 36, bottom padding 12 → 8. **Clips at 1.25×, every question** |
| 3 | `core/widgets/titled_chrome.dart:49` + 4 duplicates | `SizedBox(height: 35)` → `minHeight: 35`; collapse the 5 copies. **Partly applied 2026-10-10 (O-15, DESIGN_ISSUES #132):** `TitledChrome` is a 48 floor and its title wraps; `EditProfileChrome` is now `TitledChrome`; `CatalogHeader` is a 48 floor (its title stays one line). The quiz bars already had floors |
| 4 | `app.dart:51` | Clamp `textScaler` to 1.3 — **needs the product decision first** |
| 5 | `quiz/screens/quiz_setup_screen.dart:224` | `LayoutBuilder`; drop `width: 171` |
| 6 | `profile/screens/edit_profile_screen.dart:605`, `account_shells/widgets/shell_body.dart:94` | `height: 60` → theme `minimumSize` |
| 7 | `home/widgets/home_banner.dart:26`, `quiz/screens/quiz_result_screen.dart:164`, `core/widgets/language_pill.dart:34` | `height` → `minHeight` (+ `FittedBox` on the ring label) |
| 8 | `auth/screens/otp_screen.dart:254` | `FittedBox(fit: BoxFit.scaleDown)` around `Pinput` |
| 9 | `core/widgets/circle_back_button.dart:40` + 4 more | 48dp hit box around the 35dp paint. **Applied 2026-10-10 (O-15, DESIGN_ISSUES #132)** to the back chip at every call site but four (OTP, unknown route, support thread, School/University detail); the other controls are not done |
| 10 | 8 sites | `tooltip:` / `label:` / `Semantics` |
| 11 | `quiz/screens/quiz_result_screen.dart:284` | Wrap in `Flexible` |
| 12 | `catalog/widgets/tree_list_row.dart` (the `progress != null` row) | Wrap the caption in `Flexible`. **Narrow widths only**: fine at 375 and 411 dp up to 2.0× in `en` and `ar`; overflows at 320 dp 2.0× (`en`, 17 px) and at 250 dp from 1.3× |

Item 12 was added on 2026-09-25 (API→UI Wave 08), measured with the app's own fonts (`loadAppFonts`) on
the Lectures list. An earlier note put it at **7 and 20 px at 1.3×** on a 375 dp phone. Those numbers reproduce
exactly with the TEST font, which draws every glyph a full em wide, and vanish with the real fonts. They were a
test-font artefact.

---

## Already correct — do not "fix" these

- **Keyboard handling.** All 8 text-field screens are inside scrollables.
  `windowSoftInputMode="adjustResize"` is set. `school_picker_field.dart:192`
  uses `viewInsets` correctly. **Zero keyboard-overflow screens.**
- **Safe areas.** 25 sites, consistent. Tab roots pass `bottom: false`; the shell
  adds the inset itself at `main_shell.dart:49`.
- **The bottom nav bar.** Survives 2.5×. It is the model, not a target.
