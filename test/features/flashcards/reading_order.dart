import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// BUG-020's check: [text], as [paragraph] laid it out, reads in [direction].
///
/// Every word and every punctuation mark must sit after the one before it in
/// that direction, on the same line, or start a line below it: the lines run
/// top to bottom in reading order. A card laid out in the app's direction
/// instead of its own fails here at the mark that moved, e.g. the English
/// "?" that the Arabic app drew at the START of "?into right and left parts".
///
/// The units are runs of letters and single punctuation marks; a
/// character-level walk would trip over combining marks (the tanween in
/// "منتصبًا"). The test font is wide enough to break a long word across two
/// lines, so a unit is measured as the boxes on its first line (what the unit
/// before it is compared with) and on its last (what the next one is compared
/// with). Every unit must have ink, so a font that drew a script at zero width
/// could not make the ordering pass vacuously.
///
/// Returns the number of lines, for the caller to assert that a claim about
/// line splitting had more than one line to hold.
int expectReadingOrder(
  RenderParagraph paragraph,
  String text,
  TextDirection direction,
) {
  final units = RegExp('[.?!,;:()،؟]|[^\\s.?!,;:()،؟]+').allMatches(text);

  var lines = 0;
  Rect? previous;
  String? previousUnit;
  for (final unit in units) {
    final label = unit[0]!;
    final boxes = paragraph
        .getBoxesForSelection(
          TextSelection(baseOffset: unit.start, extentOffset: unit.end),
        )
        .map((box) => box.toRect())
        .toList();
    expect(boxes, isNotEmpty, reason: '"$label" is not laid out');
    final head = _lineOf(boxes, first: true);
    final tail = _lineOf(boxes, first: false);
    expect(head.width, greaterThan(0), reason: '"$label" has no ink');

    if (previous == null || !_sameLine(head, previous)) {
      if (previous != null) {
        expect(
          head.top,
          greaterThanOrEqualTo(previous.bottom - 0.01),
          reason: '"$label" starts a line below "$previousUnit"',
        );
      }
      lines++;
    } else if (direction == TextDirection.ltr) {
      expect(
        head.left,
        greaterThanOrEqualTo(previous.right - 0.01),
        reason: '"$label" follows "$previousUnit" to its right',
      );
    } else {
      expect(
        head.right,
        lessThanOrEqualTo(previous.left + 0.01),
        reason: '"$label" follows "$previousUnit" to its left',
      );
    }
    if (!_sameLine(head, tail)) lines++;
    previous = tail;
    previousUnit = label;
  }
  // Last, so that a failure names the mark that moved rather than the flag.
  expect(
    paragraph.textDirection,
    direction,
    reason: 'the paragraph takes the text\'s own direction',
  );
  return lines;
}

/// The rect [paragraph] draws the characters [start]..[end] in: the union of
/// the boxes it reports for them.
Rect inkOf(RenderParagraph paragraph, int start, int end) => paragraph
    .getBoxesForSelection(TextSelection(baseOffset: start, extentOffset: end))
    .map((box) => box.toRect())
    .reduce((a, b) => a.expandToInclude(b));

/// Boxes on one line overlap vertically; lines stack without overlapping.
bool _sameLine(Rect a, Rect b) =>
    a.top < b.bottom - 0.01 && a.bottom > b.top + 0.01;

/// The union of [boxes] on the first (or the last) line they reach.
Rect _lineOf(List<Rect> boxes, {required bool first}) {
  final edge = boxes.reduce(
    (a, b) => (first ? b.top < a.top : b.top > a.top) ? b : a,
  );
  return boxes
      .where((box) => _sameLine(box, edge))
      .reduce((a, b) => a.expandToInclude(b));
}
