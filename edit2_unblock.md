# Task — unblock the three Figma-gated items left open by edit2

Work in `F:\level\level_up\level_up_app`, branch `merged`.

edit2.md is **done and verified** (1124 passed / 0 failed / 1 skipped, 8/8 guards, ratchet 9).
Three items were left blocked, and **all three are blocked on the same thing: nobody could reach a
signed-in Figma seat.** Your job is to get into Figma properly, read the values, and finish them.

---

## 0. Read first

1. `edit2.md` §7.8 (onboarding sheet) and §13 (known risks).
2. `edit1.md` §4 (design rules R1–R10) and §12 (the calibration protocol).
3. `docs/DESIGN_ISSUES.md` **#72** (Glass, the C1–C7 table), **#74** (limit sheet), **#75**
   (onboarding strip) — those three entries are the spec for this task.
4. `lib/core/theme/glass_mapping.dart` — read every doc comment before touching a constant.
5. `CLAUDE.md` (repo root) and `docs/AGENT_WORKFLOW.md` § "Theme discipline".

Figma file: **`P6044i0giD9TmdQ7C2AmLq`**, page **`design`**.

---

## 1. Getting into Figma — try every route, in this order

**Route A — the Chrome extension, across ALL connected browsers.**

1. Call `list_connected_browsers` **first** and enumerate every browser it returns. There may be
   more than one, on more than one machine, and only one of them may be signed in.
2. For **each** browser: select/switch to it, open
   `https://www.figma.com/design/P6044i0giD9TmdQ7C2AmLq/?node-id=337-19256`, and check the
   **sign-in state before reading anything**:
   - signed in → a real user avatar top-right, and a right-hand **Design / Properties** panel;
   - anonymous → a generic silhouette avatar and a *"Sign up to comment, inspect and more"* banner,
     **no right-hand panel**. An anonymous seat renders frames but exposes **no values** — this is
     exactly the dead end the last session hit.
3. Stop at the first signed-in browser and work there.

**Route B — the Figma desktop app on this Windows machine.** It is installed
(`C:\Users\musta\AppData\Local\Figma`) and normally already running. Use computer-use:
`request_access(["Figma"])`. **This was declined on 2026-09-18** — if it is declined again, say so
and move on; do not retry it repeatedly.

**Route C — the `figma` MCP connector.** It needs OAuth, which a non-interactive session cannot run;
tell the user to authorize it in their claude.ai connector settings. Note it historically
authenticates as **Seif's view-only account**, where `get_*` / `download_assets` fail, so treat it
as a last resort rather than the plan.

**Glass values specifically** are hidden even on a signed-in *view* seat — every surface Figma
offers (Design panel, Dev Mode inspect, CSS/SwiftUI export, Copy properties, Copy as SVG). They were
read once with a **local read-only Dev Mode development plugin** that reports
`effects[].type === "GLASS"`. If you need Glass numbers again, that is the route; click into the
Figma canvas first.

### The one rule that must not bend

**A colour sampled off a screenshot is not a read value.** A read value comes from the Properties /
Design panel, Dev Mode inspect, the CSS export, or the plugin. This project has already shipped a
whole token block that was eyeballed off a render and was wrong in every value. If you cannot read
it, say you could not read it — do not approximate it, and do not "confirm" it from pixels.

---

## 2. The three jobs

### J1 — DESIGN_ISSUES #75: the onboarding sheet's frost *(do this one first — highest value)*

**Read:** node **`337:19256`** — a 622×138 rect at (−140, 540) inside `on boarding screen_1` dark
`337:15146`. All you need is **its fill**. Check whether the light frame (`81:92` / sheet
`459:43873`) has an equivalent rect, and read that too.

Then, per `edit2.md` §7.8.1:

| What you read | What to build |
|---|---|
| The fill **is** the page background (`#232428` dark / `#FCFBF9` light) | Replace the full-height opaque backing in `_Sheet` with a strip from the sheet's top edge **+11** to **+149** dp, full width, and switch the sheet to `GlassBackdrop.content`. The top ~11 dp then shows the illustration frosted through G1, which is the design. |
| The fill is **something else** | Add a new `AppColors` token with **both** canvas values and the node citation, then build as above. |
| Still unreadable | Leave the code exactly as it is and update #75 with what you tried. |

Touch: `lib/features/onboarding/screens/onboarding_screen.dart`, possibly
`lib/core/theme/app_colors.dart`, and `docs/DESIGN_ISSUES.md` #75.

Watch out:
- `GlassBackdrop.content` is the **only** real `BackdropFilter` in the app. Do not use it anywhere
  else (`edit2.md` §13, performance).
- Never write `BackdropFilter` / `ImageFilter.blur` in a feature file — the ratchet guard fails.
  Everything goes through `ElevatedSurface`.
- G1 is frost 80 → σ 40 at the current mapping. Look at the result; if the top edge turns to mush,
  that is a **calibration** finding for J2, not a licence to change the sheet's own frost value.

### J2 — DESIGN_ISSUES #72: Glass calibration C1–C7

Run the seven comparisons in #72's table. Method per `edit1.md` §12: Figma **Copy as PNG** at the
node's own size, against the Flutter render from the golden harness at device pixel ratio 3, side by
side.

| Ref | Node | Calibrates |
|---|---|---|
| C1 | level card `337:5336` + B1 | `kGlassFrostToSigma`, rim at splay 1 / depth 78 |
| C2 | Notification Preferences `337:8195` + B8 | frost 63, back-light flush with the start edge |
| C3 | profile menu row `337:7479` | default Glass on a flat page: rim only |
| C4 | language pill `340:19734` | intensity 0.25, same angle as C3's 0.80 |
| C5 | field `348:8659` | frost 0, angle 28, splay 0.97 (the wide exponent) |
| C6 | quiz previous button `337:6464` | angle 51 — **confirms or corrects the y-up angle convention** |
| C7 | onboarding sheet `337:15643` over its illustration | the one `content` backdrop, frost 80 |

**Only these five constants may move**, all in `lib/core/theme/glass_mapping.dart`:
`kGlassFrostToSigma`, `kGlassRimStrokeWidth`, `kGlassRimMaxAlpha`, `kGlassRimExponentNarrow`,
`kGlassRimExponentWide`.

- **`kFigmaBlurToSigma` (0.5) is a CSS DEFINITION. Never tune it.**
- **Never** tune a per-component Glass value (frost/angle/intensity/splay on a node) to compensate
  for the model — those are measured.
- Record every comparison in #72 and flip that section from **PENDING** to done. A constant you did
  not compare stays at its documented starting value; say so.
- **C6 is the one that can cascade.** If 51° shows the rim on the wrong side, the angle convention
  `(cos θ, −sin θ)` in `paintGlassRim` (`lib/core/widgets/elevation/glass_surface.dart`) is wrong
  and **every Glass surface in the app changes**. That is a stop-and-ask, not a quiet fix.
- If any constant moves: regenerate the affected goldens and **look at every PNG**.

### J3 — DESIGN_ISSUES #74: the dark limit sheet *(read this before you start)*

**Figma access does not unblock this one.** #74 is not an unread value — it is a frame that does not
exist. Your job here is narrow:

1. **Verify** it really is absent: search the file for the Limitation notification's dark twin
   (search "Limitation", check the light frame's siblings and any dark page/variant).
2. **If it genuinely does not exist** → it stays ❌ blocked. Update #74 to say the search was run
   and what was searched. It becomes a designer request, nothing more.
3. **If you find one** → measure `Rectangle 6427`'s dark twin: the fill colour and the
   `backdrop-filter: blur(Npx)` from the CSS export (that value is **already a sigma** — do not
   halve it). Fill in `AppElevation.dark.limitSheetScrim`, and tell me first: that is real work, not
   a doc update.

**Never invent this scrim** by carrying the light values across or copying another sheet's.
`test/core/widgets/elevation/app_modal_test.dart` pins the null on purpose — if you fill the token,
that test is the one to update.

---

## 3. Rules that still apply

- **Colours live only in `lib/core/theme/`.** The guard scans every line under `lib/` outside that
  folder — **including comments** — for `0xFF`, `Color(0x`, `Colors.black`, `Colors.white`. A new
  colour means a new `AppColors` token with **both** values and a Figma node citation.
- **No shadow / blur / backdrop primitive** outside `lib/core/theme/` and
  `lib/core/widgets/elevation/`. The elevation ratchet is now **9** — do not raise it.
- No new inline `fontSize:` / `fontWeight:` (ratchet 0). All copy through `AppLocalizations`, both
  ARB files. Never log personal data or tokens. The app is purchase-silent. Do not edit
  `contract/**`.
- **The tree is intentionally dirty with other people's uncommitted work**, including edit1 and
  parts of edits 3–5. Never discard, stash or reformat a foreign hunk. Format only the files you
  touched.
- **Do not commit unless I explicitly ask.**

## 4. Baseline you must not regress

```
validate.ps1      -> OVERALL: PASS, 1124 passed / 0 failed / 1 skipped
verify_guards.ps1 -> 8/8 guards proved
elevation ratchet -> 9
```

## 5. Traps this repo has already paid for

- `flutter test --tags golden --update-goldens` **with no file argument rewrites every golden in the
  repo**, including other edits'. Pass the specific file.
- `Picture.toImage()` hangs inside a `testWidgets` fake-async zone — wrap pixel readback in
  `await tester.runAsync(() async { ... })`.
- `paints..path(...)` matches canvas calls **in order**; for a negative assertion use
  `paints..something((symbol, args) => ...)`.
- `matchesSemantics` / `containsSemantics` are wrong here — use `isSemantics(...)`. An SVG child
  merges `isImage` into the node and an exhaustive matcher fails on it.
- Bash heredocs eat one level of backslash and mangle Dart escapes. Write multi-line patches to the
  scratchpad and apply them with a Python exact-match script (assert each anchor matches once), or
  use the Edit tool. Source files are CRLF — preserve it.
- Goldens are **Windows-only** baselines.

## 6. Report back

Label every claim, and never round one up:

- **FIGMA READ** — a value read from the Properties panel / Dev Mode / CSS export / plugin.
- **FIGMA CALIBRATED** — an actual side-by-side against the Figma render.
- **BUILD VERIFIED** — compiles, suite green.
- **GOLDEN VERIFIED** — regenerated **and** visually inspected by you.
- **DEVICE VERIFIED** — actually installed and driven on hardware.

Then give me: which browser/route got you in; the values you read, with node IDs; what changed in
code; which of C1–C7 actually ran and which did not; the verbatim validate + guard numbers; and
which of the three items are now ✅ and which are still ❌ and why.

## 7. Ask me before deciding

- The strip's fill is a colour that is not already a token.
- C6 says the angle convention is wrong (it changes every Glass surface).
- A dark Limitation frame turns out to exist.
- No route gets you a signed-in Figma seat — then stop, tell me, and change nothing.
