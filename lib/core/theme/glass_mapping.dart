/// The ONE place Figma's effect numbers become Flutter's.
///
/// Figma and Flutter disagree about what "blur" means, and the disagreement is
/// silent: both accept a number, both render something, and the Flutter one is
/// up to 2x too soft on the small shadows this file's design uses everywhere.
/// Every conversion therefore lives here, is named, and carries the reason —
/// so a later reader can tell a *definition* (which must not be tuned) from a
/// *model constant* (which is calibrated once, against the design, and then
/// recorded).
///
/// Source: `edit1.md` R3 + §7.5, written from the 2026-09-17 Figma reading of
/// file `P6044i0giD9TmdQ7C2AmLq`.
library;

import 'package:flutter/painting.dart';

/// Figma's drop/inner-shadow **Blur** is the CSS blur radius `B`, and CSS
/// defines that as a Gaussian with **sigma = B / 2**.
///
/// **This is a definition, not a tunable.** Do not "calibrate" it.
///
/// It exists as a named constant because the obvious alternative is wrong in a
/// way that looks right: `BoxShadow(blurRadius: B)` converts internally with
/// `Shadow.convertRadiusToSigma`, i.e. `sigma = 0.57735 * B + 0.5`
/// (verified in the pinned SDK 3.44.7). At the file's commonest blur, 1.3px,
/// that is sigma 1.25 against the correct 0.65 — nearly twice as soft, on the
/// shadow that appears on every back chip and every profile chip. Which is why
/// nothing in `lib/core/widgets/elevation/` constructs a `BoxShadow`: it paints
/// `MaskFilter.blur` with the sigma computed here.
const kFigmaBlurToSigma = 0.5;

/// Figma's Glass **frost** (`radius` in the Plugin API) to Gaussian sigma.
///
/// Figma exports a background blur of radius `R` as CSS `blur(R / 2)`, and the
/// Glass effect reuses that same field name, so the same halving is the
/// starting assumption.
///
/// **CALIBRATION CHECK** — `edit1.md` §12 C1/C2. Change it only with a recorded
/// side-by-side against the Figma render, and record the result in
/// `docs/DESIGN_ISSUES.md` #72. Never tune a per-component Glass value to
/// compensate for this one: those are measured, this is the model.
const kGlassFrostToSigma = 0.5;

/// Width of the Glass rim highlight, in logical pixels.
///
/// The stroke is centred on the outline and its outer half is clipped away, so
/// the visible band is half of this.
///
/// **CALIBRATED 2026-09-19** against Figma's own 3x renders: on C3 the rim is
/// 2px wide at half maximum at device pixel ratio 3, i.e. 0.67 dp visible. A
/// centred stroke of 1.33 puts 0.67 dp inside the edge. The earlier 1.0 —
/// recorded as "confirmed" on 2026-09-18 from a three-value profile — renders
/// 1px at 3x, half of Figma's. DESIGN_ISSUES #72.
const kGlassRimStrokeWidth = 1.33;

/// Alpha of the rim highlight where the surface faces the light head-on, before
/// the node's own `lightIntensity` scales it.
///
/// **This is the one dial that is a design ruling rather than a measurement,
/// and it is deliberately below what Figma measures.**
///
/// *Measured:* **0.79**. Walked all the way round the outlines of C1
/// (`337:5336`), C3 (`337:7479`) and C4 (`340:19734`) in Figma's own 3x frame
/// exports, twice, by two independent scripts; where a corner arc turns square
/// to the light the three nodes read 0.765, 0.790 and 0.794 per unit
/// `lightIntensity`.
///
/// *Shipped:* **0.55**, 70% of it — an **owner ruling of 2026-09-19**
/// (`docs/DECISIONS.md` D-011). Figma's rim is that bright inside a surface
/// that `depth`/`refraction` darken with a gradient, which is what makes Glass
/// read *recessed* there. The tier-1 model renders no such gradient (D-009), so
/// reproducing the rim's absolute alpha on a flat interior reads **stronger
/// than the design intends**. The target is the design's *look*, not its alpha
/// number.
///
/// **70% is not an error bar and not a fudge of the geometry.** Everything the
/// calibration measured — direction, the two lobes, [kGlassRimBackLobe],
/// [kGlassRimThreshold], [kGlassRimExponent], [kGlassRimStrokeWidth] — is
/// untouched and stays pinned to Figma. Only this scalar moves, and it was
/// picked so that the two most prominent Glass surfaces (the level card at
/// `splay` 1.00 and the form field at 0.97) keep the brightness the app has
/// already shipped and been reviewed at: their straight edge rendered
/// 0.354 per unit intensity under the old model and renders 0.350 under this
/// one. The small chrome, which the old model drew at 0.06 where Figma draws
/// 0.50, comes up to 0.35 rather than all the way.
///
/// To change the rim's strength, change **this number only**. DESIGN_ISSUES #72.
const kGlassRimMaxAlpha = 0.55;

/// The rim alpha Figma itself renders at the apex, per unit `lightIntensity`.
///
/// Recorded next to the shipped [kGlassRimMaxAlpha] so the measurement survives
/// the ruling that scaled it down, and so a test can check the *shape* against
/// Figma while the *strength* follows the dial. Not used by the painter.
const kGlassRimMeasuredMaxAlpha = 0.79;

/// How far the rim reaches around the outline: below this `|facing|` Figma
/// draws no rim at all.
///
/// **MEASURED 2026-09-19.** Figma's rim is not a falloff that thins away — it
/// stops. On all three calibration nodes the two corner arcs whose normals are
/// perpendicular to the light axis are *bare*: the pixel inside the boundary is
/// the surface's own fill to within one level, across roughly half of each of
/// those arcs. The rim is two arcs, not a closed loop.
///
/// This is why the four edge midpoints could not settle the model on
/// 2026-09-18 — at −45 all four sit at `|facing|` 0.7071, on the same side of
/// this threshold, so nothing there distinguishes a two-lobe rim with a dead
/// zone from a one-sided rim with a floor.
const kGlassRimThreshold = 0.48;

/// The rim is **two-sided**: the edges facing away from the light carry one
/// too, at this fraction of the lit side's alpha.
///
/// **MEASURED 2026-09-19**, and it is the most stable number in the whole
/// calibration. Matched-`|facing|` medians swept around the outline give 0.650
/// (C3), 0.638 (C4) and 0.657 (C1); the straight edges give 0.64, the corner
/// apexes 0.65, at `lightIntensity` 0.80 and at 0.25 alike. An independent
/// anti-aliasing-invariant integral of the rim's excess luminance returns the
/// same 0.62–0.64.
///
/// The 2026-09-18 pass read this as a *floor* of ~0.73 beneath an otherwise
/// one-sided rim. It is not a floor: between the two lobes the rim is gone
/// entirely (see [kGlassRimThreshold]), and measured against the local backdrop
/// rather than the page the ratio is 0.65. DESIGN_ISSUES #72.
const kGlassRimBackLobe = 0.65;

/// Falloff exponent applied to the smoothstepped reach that
/// [kGlassRimThreshold] leaves.
///
/// The measured profile is S-shaped — near-flat from the apex down to the
/// straight edges, then a steep knee into the dead zone — so the reach is
/// smoothstepped before this exponent, not raised directly. A bare power would
/// have to choose between the edges and the knee, and would leave an infinite
/// slope at the threshold, i.e. a visible terminator part-way round a pill or a
/// circle.
///
/// **CALIBRATED 2026-09-19**, and it does **not** depend on the node's `splay`.
/// With the threshold pinned, the two splay-0.00 nodes fit 0.50 and the
/// splay-1.00 node fits 0.51; where the rim is visible their predictions differ
/// by under 2%. So this single constant replaces the former
/// `kGlassRimExponentNarrow` (6.0) / `kGlassRimExponentWide` (1.0) pair, whose
/// splay-driven lerp was a tier-1 *assumption* in `edit1.md` §7.4 b that no
/// measurement had ever tested.
///
/// `GlassStyle.splay` keeps carrying the reading — it is a measured Figma value
/// — it simply has no effect on the rim that can be shown. To separate it, a
/// future calibration needs two nodes that differ in `splay` and agree in
/// everything else; C1 differs from C3/C4 in frost, depth and back-light too.
const kGlassRimExponent = 0.50;

/// The rim highlight's colour, before [kGlassRimMaxAlpha] and the node's
/// `lightIntensity` are applied.
///
/// White: Figma's Glass light is an achromatic specular highlight, and every
/// Glass node in the file carries the same one. It lives in this file — not in
/// `AppColors` — because it is part of the *model*, not a palette choice a
/// designer can re-issue; and it lives in `lib/core/theme/` because that is
/// where the palette guard requires every colour literal to be.
const kGlassRimColor = Color(0xFFFFFFFF);
