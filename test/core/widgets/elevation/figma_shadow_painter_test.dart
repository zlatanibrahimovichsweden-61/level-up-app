import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/glass_mapping.dart';
import 'package:level_up_app/core/widgets/elevation/figma_shadow_painter.dart';

/// The two rules the painter exists to implement, checked on real pixels.
///
/// Reading the source would confirm that the right function is called with the
/// right argument; it would not confirm that the shadow is actually absent from
/// under the surface, which is the defect (edit1.md R4). So these render.
///
/// Every rendering case runs inside `tester.runAsync`: `Picture.toImage` is
/// completed by the engine, and `testWidgets` runs in a fake-async zone that
/// never gets there — the test hangs rather than failing, which is a worse
/// outcome than either.
void main() {
  const canvasSize = 120;
  const opaqueBlack = Color.fromRGBO(0, 0, 0, 1);

  /// A centred 60x60 square, with room around it for a shadow.
  Path square() => Path()..addRect(const Rect.fromLTWH(30, 30, 60, 60));

  /// Renders [shadows] onto a [canvasSize] square canvas and returns the alpha
  /// of every pixel, row-major.
  Future<List<int>> alphaMap(List<FigmaShadow> shadows) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, canvasSize.toDouble(), canvasSize.toDouble()),
    );
    paintFigmaShadows(canvas, square(), shadows);
    final image = await recorder.endRecording().toImage(canvasSize, canvasSize);
    // Straight RGBA is toByteData's default.
    final data = (await image.toByteData())!;
    image.dispose();
    return [
      for (var i = 0; i < canvasSize * canvasSize; i++)
        data.getUint8(i * 4 + 3),
    ];
  }

  int at(List<int> alpha, int x, int y) => alpha[y * canvasSize + x];

  group('the sigma conversion', () {
    test('sigma is blur / 2, not the blurRadius conversion', () {
      const shadow = FigmaShadow(
        color: opaqueBlack,
        offset: Offset.zero,
        blur: 4,
      );
      expect(shadow.sigma, 4 * kFigmaBlurToSigma);
      expect(shadow.sigma, 2);

      // What the bug looked like: a BoxShadow would have rendered this at
      // sigma 2.81 — 40% softer than the design.
      expect(ui.Shadow.convertRadiusToSigma(4), closeTo(2.809, 0.001));
      expect(shadow.sigma, lessThan(ui.Shadow.convertRadiusToSigma(4)));
    });

    testWidgets('a larger blur really does spread further', (tester) async {
      await tester.runAsync(() async {
        Future<int> spreadAt(double blur) async {
          final alpha = await alphaMap([
            FigmaShadow(color: opaqueBlack, offset: Offset.zero, blur: blur),
          ]);
          return at(alpha, 24, 60); // 6px outside the left edge
        }

        expect(await spreadAt(16), greaterThan(await spreadAt(2)));
      });
    });
  });

  group('knockout — edit1.md R4', () {
    testWidgets('an outer shadow paints NOTHING inside the shape', (
      tester,
    ) async {
      await tester.runAsync(() async {
        // The actual defect: on a 20%-alpha dark surface an unclipped shadow
        // shows through the fill and the card reads muddy. Every drop shadow
        // in the design file carries showShadowBehindNode: false.
        final alpha = await alphaMap([
          const FigmaShadow(
            color: opaqueBlack,
            // Large offset AND blur, so an unclipped shadow would certainly
            // cover the centre.
            offset: Offset(4, 4),
            blur: 20,
          ),
        ]);

        expect(
          at(alpha, 60, 60),
          0,
          reason: 'the centre of the surface must be untouched',
        );
        expect(
          at(alpha, 40, 40),
          0,
          reason: 'well inside the top-left corner must be untouched too',
        );
        expect(
          at(alpha, 96, 96),
          greaterThan(0),
          reason: 'and the shadow must still exist OUTSIDE the shape',
        );
      });
    });

    testWidgets('an offset with no blur lands on the offset side only', (
      tester,
    ) async {
      await tester.runAsync(() async {
        final alpha = await alphaMap([
          const FigmaShadow(color: opaqueBlack, offset: Offset(8, 0), blur: 0),
        ]);

        expect(at(alpha, 94, 60), 255); // 4px past the right edge
        expect(at(alpha, 26, 60), 0); // nothing on the left
      });
    });
  });

  group('inset shadows are real insets — edit1.md R7', () {
    testWidgets('an inset paints INSIDE the shape and never outside', (
      tester,
    ) async {
      await tester.runAsync(() async {
        final alpha = await alphaMap([
          const FigmaShadow(
            color: opaqueBlack,
            offset: Offset(0, 6),
            blur: 0,
            inset: true,
          ),
        ]);

        // The hole is the square shifted down 6px, so the top 6px band inside
        // the square is filled and everything outside it is clear.
        expect(at(alpha, 60, 33), 255);
        expect(at(alpha, 60, 60), 0);
        expect(at(alpha, 60, 24), 0, reason: 'above the shape');
        expect(at(alpha, 24, 60), 0, reason: 'beside the shape');
      });
    });
  });

  group('spread', () {
    test('a positive spread grows the path, a negative one shrinks it', () {
      final grown = spreadPath(square(), 5).getBounds();
      expect(grown.left, closeTo(25, 0.001));
      expect(grown.width, closeTo(70, 0.001));

      final shrunk = spreadPath(square(), -5).getBounds();
      expect(shrunk.left, closeTo(35, 0.001));
      expect(shrunk.width, closeTo(50, 0.001));
    });

    test('zero spread returns the path untouched', () {
      final path = square();
      expect(identical(spreadPath(path, 0), path), isTrue);
    });

    test('a spread that would consume the shape yields an empty path', () {
      expect(spreadPath(square(), -40).getBounds(), Rect.zero);
    });

    testWidgets('a negative spread pulls the shadow in', (tester) async {
      await tester.runAsync(() async {
        Future<int> edge(double spread) async {
          final alpha = await alphaMap([
            FigmaShadow(
              color: opaqueBlack,
              offset: const Offset(10, 0),
              blur: 0,
              spread: spread,
            ),
          ]);
          return at(alpha, 99, 60); // 9px past the right edge
        }

        expect(await edge(0), 255);
        expect(await edge(-4), 0, reason: 'the shadow shrank away from here');
      });
    });
  });

  test('an empty list is a no-op, not a crash', () {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    expect(
      () => paintFigmaShadows(canvas, square(), const []),
      returnsNormally,
    );
  });
}
