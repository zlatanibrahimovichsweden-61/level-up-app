/// The tier-1 Glass model: what Figma's **Glass** effect is rendered as here,
/// and why it is not a `BackdropFilter` on every surface.
///
/// Figma Glass is tint + frost + rim light + refraction + dispersion. Over a
/// **uniform** backdrop — the flat page, or an opaque parent row, which is
/// every glass surface in this app but one — frost, refraction and dispersion
/// have nothing to distort, so what remains visible is the tint, the rim light,
/// and the frosted lavender back-light behind the surface. That is what this
/// file draws, cheaply, on both Skia and Impeller (edit1.md R5, decision
/// D-009).
///
/// The one surface with real content behind it, the onboarding sheet over its
/// illustration, asks for [GlassBackdrop.content] and gets an actual
/// `BackdropFilter`.
///
/// The functions here are **internal to `lib/core/widgets/elevation/`**. They
/// are public only because Dart has no folder privacy; nothing outside this
/// folder may call them, and the elevation guard in
/// `test/guards/project_rules_test.dart` is what keeps that true.
library;

import 'dart:math' as math;
import 'dart:ui';

import '../../theme/app_elevation.dart';
import '../../theme/glass_mapping.dart';

/// What is behind a glass surface, which decides whether frost is worth paying
/// for.
enum GlassBackdrop {
  /// The page, or an opaque parent. Blurring it would cost a backdrop pass per
  /// surface — including one per list row — and change nothing on screen,
  /// because a blurred uniform colour is that colour. **The default.**
  uniform,

  /// Real content: artwork, a photo, text. Here the frost is the effect, so the
  /// surface gets a real `BackdropFilter`. Today only the onboarding sheet.
  /// When a screen needs more than one, wrap it in a `BackdropGroup` and use
  /// `BackdropFilter.grouped`.
  content,
}

/// Paints the lavender back-lights that sit behind a glass surface.
///
/// In Figma these are hard-edged solid ellipses with no blur of their own; the
/// soft glow on canvas is that ellipse seen through the covering surface's
/// frost, so it is blurred here with **that surface's** frost sigma (R6).
///
/// [size] is the covering surface's size, and is what RTL mirrors around: the
/// glow stays behind the leading content rather than jumping to the far side.
/// Offsets inside the surface are otherwise as measured in the LTR dark frame.
///
/// The caller must have clipped the canvas to the surface's shape.
void paintBacklights(
  Canvas canvas,
  Size size,
  List<Backlight> backlights,
  GlassStyle glass,
  TextDirection direction,
) {
  if (backlights.isEmpty) return;
  final sigma = glass.frostSigma;

  for (final light in backlights) {
    final paint = Paint()..color = light.color;
    if (sigma > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, sigma);
    }
    final dx = direction == TextDirection.rtl
        ? size.width - light.offset.dx - light.size.width
        : light.offset.dx;
    canvas.drawOval(
      Rect.fromLTWH(dx, light.offset.dy, light.size.width, light.size.height),
      paint,
    );
  }
}

/// Paints the Glass rim highlight along [shape]'s outline.
///
/// The model, calibrated 2026-09-19 against Figma's own 3x renders of three
/// Glass nodes (DESIGN_ISSUES #72):
///
/// * `lightAngle` names the direction the light **travels**, measured y-up, so
///   in screen coordinates that is `(cos t, -sin t)` and a face is lit when its
///   outward normal *opposes* it — hence the negation in `facing`;
/// * the outline is walked in ~2px steps and each step's outward normal `n` is
///   taken from its tangent;
/// * the rim is **two-sided but not symmetric**: the side facing the light and
///   the side facing away both carry one, the far side at
///   [kGlassRimBackLobe] of the near side's alpha;
/// * it does not reach the whole way round. Below `|facing|` of
///   [kGlassRimThreshold] — the corners perpendicular to the light — Figma
///   draws nothing, and neither does this;
/// * over what is left, alpha is `kGlassRimMaxAlpha * lightIntensity * lobe *
///   pow(smoothstep(spread), kGlassRimExponent)`. The smoothstep is what makes
///   the profile S-shaped, matching a measurement that is near-flat from the
///   apex to the straight edges and then drops sharply;
/// * each step is stroked just inside the edge.
///
/// **What this replaced, and why it matters.** Until 2026-09-19 `facing` was
/// `(n.L).abs()` against an un-negated vector. At the file's default
/// `lightAngle` of -45 that makes all four edges of a rectangle identical —
/// the surface had no lit side at all — and it was 8x too dim, because the
/// exponent (6.0 at splay 0) was fitted to nothing. Figma lights the **top and
/// left** at -45 and leaves the bottom and right at 0.65 of it. The earlier
/// reading came from sampling only the four edge midpoints, which at -45 all
/// sit at `|facing|` 0.7071 and so cannot tell the two models apart; walking
/// the corner arcs is what separated them.
///
/// The constants are model constants, not design values — see
/// `lib/core/theme/glass_mapping.dart`. The per-node numbers (`lightAngle`,
/// `lightIntensity`, `splay`) are measured and are never tuned to compensate.
/// `splay` is deliberately absent from the maths: the calibration could not
/// detect any dependence on it (see [kGlassRimExponent]).
///
/// **One of them is a ruling, not a measurement.** [kGlassRimMaxAlpha] ships at
/// 70% of what Figma measures, because Figma's rim sits inside a surface that
/// `depth`/`refraction` darken and this model draws a flat one (D-011). The
/// geometry above is untouched by that; the strength is one scalar.
///
/// The caller must have clipped the canvas to [shape]; the stroke is centred on
/// the outline and its outer half is meant to be clipped away.
void paintGlassRim(Canvas canvas, Path shape, GlassStyle glass) {
  if (glass.lightIntensity <= 0 || kGlassRimMaxAlpha <= 0) return;

  final radians = glass.lightAngle * math.pi / 180.0;
  final travel = Offset(math.cos(radians), -math.sin(radians));

  final paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = kGlassRimStrokeWidth;

  const step = 2.0;
  for (final metric in shape.computeMetrics()) {
    final length = metric.length;
    if (length <= 0) continue;
    for (var start = 0.0; start < length; start += step) {
      final end = math.min(start + step, length);
      final tangent = metric.getTangentForOffset((start + end) / 2);
      if (tangent == null) continue;

      // Outward normal of a clockwise outline in screen coordinates, which is
      // how `addRRect`/`addOval` wind.
      final vector = tangent.vector;
      final normal = Offset(vector.dy, -vector.dx);
      // +1 where the face is square to the light source, -1 where it is square
      // to the light's back.
      final facing = -(normal.dx * travel.dx + normal.dy * travel.dy);
      final reach =
          ((facing.abs() - kGlassRimThreshold) / (1 - kGlassRimThreshold))
              .clamp(0.0, 1.0);
      if (reach <= 0) continue;
      final spread = reach * reach * (3 - 2 * reach);

      final alpha =
          kGlassRimMaxAlpha *
          glass.lightIntensity *
          (facing >= 0 ? 1.0 : kGlassRimBackLobe) *
          math.pow(spread, kGlassRimExponent).toDouble();
      // Below this the stroke is indistinguishable from nothing and is not
      // worth a draw call on a list row.
      if (alpha < 0.004) continue;

      paint.color = kGlassRimColor.withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawPath(metric.extractPath(start, end), paint);
    }
  }
}
