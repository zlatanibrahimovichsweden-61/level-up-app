import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Where the character at [index] of the text [finder] matches was actually
/// painted — its left edge, in the paragraph's own coordinates.
///
/// This exists to test bidi ORDER, which a `find.text` can never see: the
/// string `'+20'` is found whether it paints as `+20` or `20+`. The Unicode
/// bidi algorithm gives a leading `+` (class ES) the paragraph direction
/// unless it sits BETWEEN two numbers, so under an Arabic `Directionality`
/// the sign drifts to the right of the digits. Comparing two glyphs' boxes
/// is the one assertion that fails on the broken render and passes on the
/// fixed one (device finding 2026-09-20, `+20` → `20+` on the login chip).
///
/// Widths under the test font are not the device's, but the left-to-right
/// ORDER of two glyphs is font-independent — that is all this compares.
double glyphLeft(WidgetTester tester, Finder finder, int index) {
  final paragraph = tester.renderObject<RenderParagraph>(finder);
  final boxes = paragraph.getBoxesForSelection(
    TextSelection(baseOffset: index, extentOffset: index + 1),
  );
  expect(boxes, isNotEmpty, reason: 'no glyph painted at offset $index');
  return boxes.first.left;
}
