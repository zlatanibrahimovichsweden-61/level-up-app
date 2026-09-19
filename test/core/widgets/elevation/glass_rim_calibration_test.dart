import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/glass_mapping.dart';
import 'package:level_up_app/core/widgets/elevation/glass_surface.dart';

/// The Glass rim, measured the way Figma was measured.
///
/// `docs/DESIGN_ISSUES.md` #72 calibrates [paintGlassRim] against Figma's own
/// 3x renders of three Glass nodes. Those renders are not in the repo — they
/// were exported from a signed-in Figma seat — so what is pinned here is the
/// **numbers that came off them**, measured out of this painter by the same
/// method: peak luminance of the rim at a point on the outline, converted to an
/// alpha against the surface's own fill.
///
/// This exists because the rule it defends has already been broken once by
/// prose alone. From 2026-09-17 to 2026-09-19 the painter took `.abs()` of the
/// facing dot product, which at the file's default `lightAngle` of −45 paints
/// all four edges of a rectangle identically — the surface had no lit side —
/// and every test in the suite passed. A golden would have frozen the wrong
/// picture just as happily. Only a measurement against the design catches this
/// class of fault, so the measurement is the test.
///
/// If one of these fails, the model moved. Do not retune a constant to make it
/// pass: re-run the calibration in #72 and record what changed.
void main() {
  // The dark page every calibration node sits on, and the value both Figma and
  // this painter composite the rim over.
  const page = Color(0xFF232428);

  // C3 `337:7479`, the cleanest node in the set: a flat page behind it, no
  // back-light, and the file's default Glass — which is also the Glass on 363
  // other nodes.
  const c3 = GlassStyle(
    frost: 4,
    refraction: 0.80,
    depth: 20,
    lightAngle: -45,
    lightIntensity: 0.80,
    dispersion: 0.50,
    splay: 0,
  );

  // C4 `340:19734`, the same Glass at `lightIntensity` 0.25 — the node that
  // proves the intensity term is linear.
  const c4 = GlassStyle(
    frost: 4,
    refraction: 0.80,
    depth: 20,
    lightAngle: -45,
    lightIntensity: 0.25,
    dispersion: 0.50,
    splay: 0,
  );

  const size = Size(160, 60);
  const radius = 13.0;

  // Figma's references were exported at 3x and measured there, and the
  // comparison only holds at the same density: the visible rim is ~0.67 dp
  // wide, so at 1x it is a sub-pixel band whose anti-aliased *peak* is
  // attenuated by its own coverage (~0.35 where the model paints 0.50). At 3x
  // it covers two pixels and the peak is the alpha the model asked for.
  const ratio = 3;
  final pixels = Size(size.width * ratio, size.height * ratio);

  double luma(int r, int g, int b) => 0.299 * r + 0.587 * g + 0.114 * b;

  /// Renders the rim over [page] at [ratio] and returns every pixel's Rec.601
  /// luma.
  Future<List<double>> render(GlassStyle glass) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Offset.zero & pixels);
    canvas.scale(ratio.toDouble());
    final shape = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(radius),
        ),
      );
    canvas.drawPaint(Paint()..color = page);
    canvas.save();
    canvas.clipPath(shape);
    paintGlassRim(canvas, shape, glass);
    canvas.restore();

    final image = await recorder.endRecording().toImage(
      pixels.width.toInt(),
      pixels.height.toInt(),
    );
    final data = (await image.toByteData())!;
    image.dispose();
    return [
      for (var i = 0; i < pixels.width.toInt() * pixels.height.toInt(); i++)
        luma(
          data.getUint8(i * 4),
          data.getUint8(i * 4 + 1),
          data.getUint8(i * 4 + 2),
        ),
    ];
  }

  double at(List<double> px, int x, int y) => px[y * pixels.width.toInt() + x];

  /// Peak luma within a few pixels of ([x], [y]) along ([nx], [ny]).
  double peak(List<double> px, int x, int y, int nx, int ny) {
    var best = 0.0;
    for (var d = -4; d <= 4; d++) {
      final sx = x - nx * d;
      final sy = y - ny * d;
      if (sx < 0 || sy < 0 || sx >= pixels.width || sy >= pixels.height) {
        continue;
      }
      best = math.max(best, at(px, sx, sy));
    }
    return best;
  }

  final pageLuma = luma(0x23, 0x24, 0x28);
  double alphaOf(double peak) => (peak - pageLuma) / (255 - pageLuma);

  double topEdge(List<double> px) => peak(px, pixels.width ~/ 2, 0, 0, -1);
  double leftEdge(List<double> px) => peak(px, 0, pixels.height ~/ 2, -1, 0);
  double bottomEdge(List<double> px) =>
      peak(px, pixels.width ~/ 2, pixels.height.toInt() - 1, 0, 1);
  double rightEdge(List<double> px) =>
      peak(px, pixels.width.toInt() - 1, pixels.height ~/ 2, 1, 0);

  group('the rim has a lit side (DESIGN_ISSUES #72)', () {
    testWidgets('at lightAngle −45 the top and left are the bright ones', (
      tester,
    ) async {
      await tester.runAsync(() async {
        final px = await render(c3);
        final top = topEdge(px);
        final left = leftEdge(px);
        final bottom = bottomEdge(px);
        final right = rightEdge(px);

        // Figma: top = left = 123.2, bottom = right = 98.2 over a page of 36.2.
        expect(
          top,
          closeTo(left, 2),
          reason: 'the two lit edges are symmetric about the light axis',
        );
        expect(bottom, closeTo(right, 2), reason: 'so are the two dim ones');
        expect(
          top,
          greaterThan(bottom + 15),
          reason:
              'Figma lights top/left and leaves bottom/right at 0.65 — '
              'a rim with no lit side is the `.abs()` fault #72 records',
        );
      });
    });

    testWidgets('the dim side is the measured 0.65 of the lit one', (
      tester,
    ) async {
      await tester.runAsync(() async {
        final px = await render(c3);
        expect(
          alphaOf(bottomEdge(px)) / alphaOf(topEdge(px)),
          closeTo(kGlassRimBackLobe, 0.04),
        );
      });
    });
  });

  // Figma's own numbers at a straight edge, per unit lightIntensity: 0.489-0.525
  // lit and 0.327 dim, on all three calibration nodes.
  const figmaStraightEdgeLit = 0.50;
  const figmaStraightEdgeDim = 0.327;

  // The rim ships at a fraction of Figma's strength by owner ruling D-011 — the
  // tier-1 model draws a flat interior where Figma's is darkened by depth and
  // refraction. The SHAPE below is still checked against Figma; only the scale
  // follows the dial, so moving that one constant does not invalidate the
  // calibration, and reverting the geometry still fails.
  const shipped = kGlassRimMaxAlpha / kGlassRimMeasuredMaxAlpha;

  group('the rim matches the Figma measurement, scaled by D-011', () {
    testWidgets('a straight edge at −45 keeps Figma\'s 0.50 / 0.33 profile', (
      tester,
    ) async {
      await tester.runAsync(() async {
        final px = await render(c3);
        // |facing| = 0.7071 on every straight edge of an axis-aligned rect
        // at −45.
        expect(
          alphaOf(topEdge(px)) / c3.lightIntensity,
          closeTo(figmaStraightEdgeLit * shipped, 0.05),
        );
        expect(
          alphaOf(bottomEdge(px)) / c3.lightIntensity,
          closeTo(figmaStraightEdgeDim * shipped, 0.04),
        );
      });
    });

    testWidgets('the shipped strength is the ruled fraction of the measured', (
      tester,
    ) async {
      // D-011 is a number, so it gets an assertion. If someone "restores
      // fidelity" by raising kGlassRimMaxAlpha to the measured 0.79, or
      // silently dims the rim by bending the geometry instead, this is what
      // notices.
      expect(shipped, closeTo(0.70, 0.005));
      expect(
        kGlassRimMeasuredMaxAlpha,
        0.79,
        reason: 'the Figma measurement itself does not move without a re-run',
      );
    });

    testWidgets('lightIntensity scales it linearly', (tester) async {
      await tester.runAsync(() async {
        final a = alphaOf(topEdge(await render(c3)));
        final b = alphaOf(topEdge(await render(c4)));
        // Figma's two intensities give 0.31 on the same edge; the ratio of the
        // intensities is 0.3125.
        expect(b / a, closeTo(c4.lightIntensity / c3.lightIntensity, 0.04));
      });
    });

    testWidgets('the corners perpendicular to the light stay bare', (
      tester,
    ) async {
      await tester.runAsync(() async {
        final px = await render(c3);
        // The top-right corner arc's apex: its normal is square to the light
        // axis, where Figma measured alpha 0.000 across tens of samples.
        const inset = (radius - radius * math.sqrt1_2) * ratio;
        final x = (pixels.width - inset).round() - 1;
        final y = inset.round();
        expect(
          alphaOf(peak(px, x, y, 1, -1)),
          lessThan(0.02),
          reason: 'Figma draws no rim below |facing| $kGlassRimThreshold',
        );
      });
    });
  });
}
