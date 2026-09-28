import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' show Bidi;

/// A question's text exactly as the contract types it: `QuizQuestion.text` is
/// "Plain text; only <u>…</u> markup allowed." (`openapi.yaml:2703`, and the
/// format note at `:105`: "No other HTML/Markdown is ever sent").
///
/// Used by the quiz page and by review (API→UI Wave 14, owner ruling
/// 2026-09-27). Both drew the tags as text before, and TalkBack read them out
/// (DESIGN_ISSUES #88).
///
/// **Direction is the stem's own.** The server sends content in the content
/// language (adr-018), which need not be the UI's: an Arabic stem in the
/// English app was laid out as an LTR paragraph, which truncated it at the
/// wrong end (the Wave 13 re-walk: the ellipsis before "السؤال", the end cut
/// mid-word) and can strand trailing punctuation. The paragraph takes the
/// direction of the stem's first strong character; a stem with none (digits
/// and symbols only) follows the app. **Alignment stays the UI's** start, so a
/// stem that fits sits exactly where the plain `Text` put it.
///
/// **An Arabic underline is drawn by hand** (W14-10, owner ruling 2026-09-27).
/// Arabic letters come from the Tajawal fallback, and Tajawal Medium and Bold
/// declare a 0.003-em underline on the baseline, which the letters' own
/// baseline stroke hides; both screens set their stems in `h3`, one of those
/// weights. So an underlined run holding Arabic letters gets no
/// `TextDecoration` (its spaces would take Inter's line, somewhere else), and
/// the line Tajawal Regular declares is painted under the whole run instead
/// (see [stemUnderlineRects]). A run without Arabic keeps the engine's
/// underline, in Inter's own metrics, exactly as before.
class QuestionStemText extends StatelessWidget {
  const QuestionStemText(
    this.text, {
    super.key,
    required this.style,
    this.maxLines,
    this.overflow,
  });

  /// As received, markup included.
  final String text;
  final TextStyle style;
  final int? maxLines;
  final TextOverflow? overflow;

  static const _underline = TextStyle(decoration: TextDecoration.underline);

  /// The Arabic blocks: letters, presentation forms and Arabic-Indic digits,
  /// none of which Inter has, so all of them are drawn by the Tajawal fallback.
  static final _arabic = RegExp(
    '[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  @override
  Widget build(BuildContext context) {
    final runs = parseQuestionMarkup(text);
    final plain = runs.map((run) => run.text).join();
    final ui = Directionality.of(context);

    final spans = <TextSpan>[];
    final byHand = <TextRange>[];
    var at = 0;
    for (final run in runs) {
      final arabic = run.underlined && _arabic.hasMatch(run.text);
      spans.add(
        TextSpan(
          text: run.text,
          style: run.underlined && !arabic ? _underline : null,
        ),
      );
      if (arabic) byHand.add(TextRange(start: at, end: at + run.text.length));
      at += run.text.length;
    }

    final paragraph = Text.rich(
      TextSpan(children: spans),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: Bidi.startsWithRtl(plain)
          ? TextDirection.rtl
          : Bidi.startsWithLtr(plain)
          ? TextDirection.ltr
          : ui,
      textAlign: ui == TextDirection.ltr ? TextAlign.left : TextAlign.right,
    );
    return byHand.isEmpty
        ? paragraph
        : _StemUnderline(ranges: byHand, child: paragraph);
  }
}

/// Where Tajawal Regular puts its underline, in ems of the scaled font size:
/// its `post` table declares position -75 and thickness 50 per 1000, and the
/// engine centres the line on that position (a real-font render at 100 px:
/// Tajawal Regular's own line inks 5–10 under the baseline; Inter Regular's,
/// declared -155 / 68, 12–19). Tajawal Medium and Bold declare -4 / 3.
const stemUnderlinePosition = 0.075;
const stemUnderlineThickness = 0.05;

/// The hand-drawn underline under each of [ranges] of a laid-out stem
/// [paragraph], in the paragraph's own coordinates: one line per box the
/// paragraph reports for the range (a run that wraps or crosses a direction
/// change has several), centred [stemUnderlinePosition] under that box's
/// line's baseline and [stemUnderlineThickness] thick.
///
/// The boxes are the paragraph's own. `RenderParagraph` does not expose its
/// line metrics, so a `TextPainter` built from the paragraph's resolved inputs
/// and laid out as it lays itself out supplies the baselines.
@visibleForTesting
List<Rect> stemUnderlineRects(
  RenderParagraph paragraph,
  List<TextRange> ranges,
) {
  final boxes = [
    for (final range in ranges)
      ...paragraph.getBoxesForSelection(
        TextSelection(baseOffset: range.start, extentOffset: range.end),
      ),
  ].where((box) => box.right > box.left).toList();
  if (boxes.isEmpty) return const [];

  final painter = TextPainter(
    text: paragraph.text,
    textAlign: paragraph.textAlign,
    textDirection: paragraph.textDirection,
    textScaler: paragraph.textScaler,
    maxLines: paragraph.maxLines,
    ellipsis: paragraph.overflow == TextOverflow.ellipsis ? '\u2026' : null,
    locale: paragraph.locale,
    strutStyle: paragraph.strutStyle,
    textWidthBasis: paragraph.textWidthBasis,
    textHeightBehavior: paragraph.textHeightBehavior,
  );
  try {
    final widthMatters =
        paragraph.softWrap || paragraph.overflow == TextOverflow.ellipsis;
    painter.layout(
      minWidth: paragraph.constraints.minWidth,
      maxWidth: widthMatters ? paragraph.constraints.maxWidth : double.infinity,
    );
    final lines = painter.computeLineMetrics();
    if (lines.isEmpty) return const [];
    final em = paragraph.textScaler.scale(
      paragraph.text.style?.fontSize ?? kDefaultFontSize,
    );
    final half = em * stemUnderlineThickness / 2;

    return [
      for (final box in boxes)
        () {
          // The box's line: the last one whose top is above the box's middle.
          final middle = (box.top + box.bottom) / 2;
          var line = lines.first;
          for (final candidate in lines) {
            if (candidate.baseline - candidate.ascent <= middle) {
              line = candidate;
            }
          }
          final y = line.baseline + em * stemUnderlinePosition;
          return Rect.fromLTRB(box.left, y - half, box.right, y + half);
        }(),
    ];
  } finally {
    painter.dispose();
  }
}

/// Paints [stemUnderlineRects] over its child, a stem's `Text`, in the colour
/// the engine's own underline would take: the resolved `decorationColor`, else
/// the text's colour.
class _StemUnderline extends SingleChildRenderObjectWidget {
  const _StemUnderline({required this.ranges, required super.child});

  final List<TextRange> ranges;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderStemUnderline(ranges);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderStemUnderline renderObject,
  ) => renderObject.ranges = ranges;
}

class _RenderStemUnderline extends RenderProxyBox {
  _RenderStemUnderline(this._ranges);

  List<TextRange> _ranges;
  set ranges(List<TextRange> value) {
    if (listEquals(value, _ranges)) return;
    _ranges = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final paragraph = _paragraphIn(child);
    if (paragraph == null || !paragraph.hasSize) return;
    final style = paragraph.text.style;
    final color = style?.decorationColor ?? style?.color;
    if (color == null) return;

    final origin =
        offset +
        MatrixUtils.transformPoint(paragraph.getTransformTo(this), Offset.zero);
    final ink = Paint()..color = color;
    for (final line in stemUnderlineRects(paragraph, _ranges)) {
      context.canvas.drawRect(line.shift(origin), ink);
    }
  }

  /// `Text` builds a `RichText`, alone or under a selection container.
  static RenderParagraph? _paragraphIn(RenderObject? node) {
    if (node == null) return null;
    if (node is RenderParagraph) return node;
    RenderParagraph? found;
    node.visitChildren((child) => found ??= _paragraphIn(child));
    return found;
  }
}

/// Splits a stem into plain and underlined runs; the tags themselves are
/// never returned.
///
/// Only the contract's two tags, exactly `<u>` and `</u>`, are markup. Anything
/// else that looks like a tag is text, because the contract says nothing else
/// is ever sent and guessing at more would be inventing a format. Malformed
/// input degrades the way a browser would: an unclosed `<u>` underlines to the
/// end, a stray `</u>` is dropped, a repeated `<u>` does not nest.
@visibleForTesting
List<({String text, bool underlined})> parseQuestionMarkup(String source) {
  final runs = <({String text, bool underlined})>[];
  var underlined = false;
  var start = 0;

  void add(String text) {
    if (text.isEmpty) return;
    if (runs.isNotEmpty && runs.last.underlined == underlined) {
      final last = runs.removeLast();
      runs.add((text: last.text + text, underlined: underlined));
    } else {
      runs.add((text: text, underlined: underlined));
    }
  }

  for (final tag in RegExp('</?u>').allMatches(source)) {
    add(source.substring(start, tag.start));
    underlined = tag.group(0) == '<u>';
    start = tag.end;
  }
  add(source.substring(start));
  return runs;
}
