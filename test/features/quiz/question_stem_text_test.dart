/// `QuizQuestion.text` — "Plain text; only <u>…</u> markup allowed."
/// (`openapi.yaml:2703`, and the format note at `:105`). API→UI Wave 14,
/// owner ruling 2026-09-27: one widget draws the underline on the quiz page and
/// on review, and never shows the tags.
library;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/quiz/widgets/question_stem_text.dart';

import '../../goldens/golden_harness.dart';

void main() {
  group('parseQuestionMarkup', () {
    List<(String, bool)> runs(String source) => [
      for (final run in parseQuestionMarkup(source)) (run.text, run.underlined),
    ];

    test('plain text is one plain run', () {
      expect(runs('What is the powerhouse of the cell?'), [
        ('What is the powerhouse of the cell?', false),
      ]);
    });

    test('<u>…</u> becomes an underlined run and the tags are gone', () {
      expect(runs('Which <u>organelle</u> makes ATP?'), [
        ('Which ', false),
        ('organelle', true),
        (' makes ATP?', false),
      ]);
    });

    test('the mock bank\'s Arabic stem', () {
      expect(runs('أي من الخيارات التالية يصف <u>التركيب</u> بشكل صحيح؟'), [
        ('أي من الخيارات التالية يصف ', false),
        ('التركيب', true),
        (' بشكل صحيح؟', false),
      ]);
    });

    test('several underlined runs, including one at each end', () {
      expect(runs('<u>a</u> b <u>c</u>'), [
        ('a', true),
        (' b ', false),
        ('c', true),
      ]);
    });

    test('an unclosed <u> underlines to the end, as a browser would', () {
      expect(runs('x <u>y z'), [('x ', false), ('y z', true)]);
    });

    test('a stray </u> is dropped, not drawn', () {
      expect(runs('x </u>y'), [('x y', false)]);
    });

    test('a repeated <u> does not nest', () {
      expect(runs('<u>a <u>b</u> c'), [('a b', true), (' c', false)]);
    });

    test('any other tag is text: the contract allows <u> and nothing else', () {
      expect(runs('<b>x</b> & <U>y</U>'), [('<b>x</b> & <U>y</U>', false)]);
    });

    test('an empty stem is no runs', () {
      expect(runs(''), isEmpty);
    });
  });

  group('QuestionStemText', () {
    Future<void> pumpStem(
      WidgetTester tester,
      String text, {
      TextDirection ui = TextDirection.ltr,
      int? maxLines,
    }) => tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: ui,
          child: Scaffold(
            body: SizedBox(
              width: 200,
              child: QuestionStemText(
                text,
                style: const TextStyle(fontSize: 18),
                maxLines: maxLines,
                overflow: maxLines == null ? null : TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );

    RenderParagraph paragraph(WidgetTester tester) =>
        tester.renderObject<RenderParagraph>(
          find.descendant(
            of: find.byType(QuestionStemText),
            matching: find.byType(RichText),
          ),
        );

    testWidgets('draws the underline and never the tags', (tester) async {
      await pumpStem(tester, 'Which <u>organelle</u> makes ATP?');

      expect(find.text('Which organelle makes ATP?'), findsOneWidget);
      expect(find.textContaining('<u>'), findsNothing);

      final spans = <TextSpan>[];
      paragraph(tester).text.visitChildren((span) {
        if (span is TextSpan && span.text != null) spans.add(span);
        return true;
      });
      final underlined = spans.where(
        (s) => s.style?.decoration == TextDecoration.underline,
      );
      expect(underlined.map((s) => s.text), ['organelle']);
    });

    testWidgets('TalkBack reads the words, not the markup', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpStem(tester, 'Which <u>organelle</u> makes ATP?');

      expect(find.bySemanticsLabel('Which organelle makes ATP?'), findsOne);
      expect(find.bySemanticsLabel(RegExp('<u>|</u>')), findsNothing);
      handle.dispose();
    });

    testWidgets('an Arabic stem in the English app is its own RTL paragraph, '
        'still set from the left', (tester) async {
      // Device-found on the Wave 13 re-walk: laid out LTR, a truncated Arabic
      // stem put the ellipsis before "السؤال" and cut its end mid-word.
      await pumpStem(
        tester,
        'السؤال 1: أي من الخيارات التالية يصف <u>التركيب</u> بشكل صحيح؟',
        maxLines: 1,
      );

      final p = paragraph(tester);
      expect(p.textDirection, TextDirection.rtl);
      // Alignment follows the UI, so an untruncated stem sits where it did.
      expect(p.textAlign, TextAlign.left);
    });

    testWidgets('an English stem in the Arabic app is LTR, set from the '
        'right', (tester) async {
      await pumpStem(
        tester,
        'What is the powerhouse of the cell?',
        ui: TextDirection.rtl,
      );

      final p = paragraph(tester);
      expect(p.textDirection, TextDirection.ltr);
      expect(p.textAlign, TextAlign.right);
    });

    testWidgets('the direction is the stem\'s first strong character, the '
        'markup ignored', (tester) async {
      // An Arabic stem that opens with an underlined word, and one that opens
      // with a number: neither the tag nor the digit decides.
      await pumpStem(tester, '<u>التركيب</u> ما هو؟');
      expect(paragraph(tester).textDirection, TextDirection.rtl);

      await pumpStem(tester, '2 + 2 = ? What', ui: TextDirection.rtl);
      expect(paragraph(tester).textDirection, TextDirection.ltr);
    });

    testWidgets('a stem with no letters at all follows the app', (
      tester,
    ) async {
      await pumpStem(tester, '2 + 2 = ?', ui: TextDirection.rtl);
      expect(paragraph(tester).textDirection, TextDirection.rtl);

      await pumpStem(tester, '2 + 2 = ?');
      expect(paragraph(tester).textDirection, TextDirection.ltr);
    });
  });

  // W14-10, owner ruling 2026-09-27: Tajawal Medium and Bold declare a
  // 0.003-em underline on the baseline, so an underlined Arabic word showed no
  // line on the device (Wave 14 walk). An Arabic run's line is now drawn by
  // hand where Tajawal Regular declares its own; a run without Arabic keeps
  // the engine's.
  group('W14-10: the Arabic underline is drawn by hand', () {
    const stem = 'أي من الخيارات يصف <u>التركيب</u> بشكل صحيح؟';
    final plain = stem.replaceAll(RegExp('</?u>'), '');
    const word = 'التركيب';
    final range = TextRange(
      start: plain.indexOf(word),
      end: plain.indexOf(word) + word.length,
    );

    Future<RenderParagraph> pump(
      WidgetTester tester,
      String text, {
      double width = 1200,
      int? maxLines,
      TextScaler scaler = TextScaler.noScaling,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: scaler),
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: width,
                    child: QuestionStemText(
                      text,
                      style: const TextStyle(fontSize: 18),
                      maxLines: maxLines,
                      overflow: maxLines == null ? null : TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      return tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byType(QuestionStemText),
          matching: find.byType(RichText),
        ),
      );
    }

    // The line's own baseline, where the engine draws its glyphs and its
    // decorations. `computeDistanceToActualBaseline` is the unrounded ascent,
    // which sits 0.26 above it in the test font (26-dp line, 25.74 of metrics).
    double lineBaseline(RenderParagraph p) {
      final painter = TextPainter(
        text: p.text,
        textDirection: p.textDirection,
        textScaler: p.textScaler,
      )..layout(maxWidth: p.size.width);
      final baseline = painter.computeLineMetrics().first.baseline;
      painter.dispose();
      return baseline;
    }

    List<TextBox> boxes(RenderParagraph p, TextRange r) => p
        .getBoxesForSelection(
          TextSelection(baseOffset: r.start, extentOffset: r.end),
        )
        .where((box) => box.right > box.left)
        .toList();

    testWidgets('an Arabic run carries no TextDecoration; a Latin run keeps '
        'the engine\'s', (tester) async {
      final p = await pump(tester, 'Which <u>organelle</u> يصف <u>$word</u>?');

      final underlined = <String>[];
      p.text.visitChildren((span) {
        if (span is TextSpan &&
            span.text != null &&
            span.style?.decoration == TextDecoration.underline) {
          underlined.add(span.text!);
        }
        return true;
      });
      expect(underlined, ['organelle']);
    });

    testWidgets('one line under the word, 0.075 em below the baseline and '
        '0.05 em thick', (tester) async {
      final p = await pump(tester, stem);
      final baseline = lineBaseline(p);

      final lines = stemUnderlineRects(p, [range]);
      final box = boxes(p, range).single;
      expect(lines, hasLength(1));
      expect(lines.single.left, box.left);
      expect(lines.single.right, box.right);
      expect(lines.single.center.dy, closeTo(baseline + 0.075 * 18, 0.01));
      expect(lines.single.height, closeTo(0.05 * 18, 0.01));
    });

    testWidgets('scaled text scales the line with it', (tester) async {
      final p = await pump(tester, stem, scaler: const TextScaler.linear(1.5));
      final baseline = lineBaseline(p);

      final line = stemUnderlineRects(p, [range]).single;
      expect(line.center.dy, closeTo(baseline + 0.075 * 27, 0.01));
      expect(line.height, closeTo(0.05 * 27, 0.01));
    });

    testWidgets('a run that wraps gets a line under each of its lines', (
      tester,
    ) async {
      const long = 'سؤال <u>التركيب الخلوي للخلية الحية</u> صحيح';
      final text = long.replaceAll(RegExp('</?u>'), '');
      const run = 'التركيب الخلوي للخلية الحية';
      final r = TextRange(
        start: text.indexOf(run),
        end: text.indexOf(run) + run.length,
      );
      final p = await pump(tester, long, width: 150);

      final lines = stemUnderlineRects(p, [r]);
      final bs = boxes(p, r);
      expect(lines, hasLength(bs.length));
      expect(lines.map((l) => l.center.dy).toSet().length, greaterThan(1));
      for (var i = 0; i < bs.length; i++) {
        expect(lines[i].left, bs[i].left);
        expect(lines[i].right, bs[i].right);
        // Every line sits the same distance under its own box.
        expect(
          lines[i].center.dy - bs[i].top,
          closeTo(lines.first.center.dy - bs.first.top, 0.01),
        );
      }
    });

    testWidgets('a truncated stem draws nothing past its edge', (tester) async {
      final p = await pump(tester, stem, width: 200, maxLines: 1);

      for (final line in stemUnderlineRects(p, [range])) {
        expect(line.left, greaterThanOrEqualTo(-0.01));
        expect(line.right, lessThanOrEqualTo(p.size.width + 0.01));
      }
    });
  });

  // The same claim on the bundled fonts, read off the pixels: the red proof.
  group('W14-10 on real fonts', () {
    setUpAll(loadAppFonts);

    /// The rows, between [from] and [to] ems under the baseline, in which
    /// every pixel across the underlined word is ink.
    Future<List<int>> solidRows(
      WidgetTester tester,
      String text,
      TextRange r, {
      required double from,
      required double to,
    }) async {
      const size = 48.0;
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: key,
                child: ColoredBox(
                  color: Colors.white,
                  child: QuestionStemText(
                    text,
                    // The stems' weight (`h3`): Tajawal Bold for Arabic.
                    style: const TextStyle(
                      fontSize: size,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final p = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byType(QuestionStemText),
          matching: find.byType(RichText),
        ),
      );
      final baseline = p.computeDistanceToActualBaseline(
        TextBaseline.alphabetic,
      );
      final box = p
          .getBoxesForSelection(
            TextSelection(baseOffset: r.start, extentOffset: r.end),
          )
          .single;
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      return (await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        final rows = <int>[];
        for (
          var y = (baseline + from * size).floor();
          y <= (baseline + to * size).ceil();
          y++
        ) {
          var solid = true;
          for (var x = box.left.ceil() + 1; x < box.right.floor() - 1; x++) {
            if (bytes.getUint8((y * image.width + x) * 4) > 128) {
              solid = false;
              break;
            }
          }
          if (solid) rows.add(y);
        }
        return rows;
      }))!;
    }

    testWidgets('an Arabic word in the stems\' weight is underlined across '
        'its whole width', (tester) async {
      // Tajawal Bold's own line (0.003 em, on the baseline) leaves no solid
      // row under the word; the drawn one is 0.05-0.10 em under it.
      final rows = await solidRows(
        tester,
        '<u>التركيب</u>',
        const TextRange(start: 0, end: 7),
        from: 0.03,
        to: 0.12,
      );
      expect(rows, isNotEmpty);
    });

    testWidgets('an English word keeps Inter\'s own underline', (tester) async {
      // Inter SemiBold declares its line 0.144 em under the baseline, 0.085
      // thick.
      final rows = await solidRows(
        tester,
        '<u>organelle</u>',
        const TextRange(start: 0, end: 9),
        from: 0.1,
        to: 0.19,
      );
      expect(rows, isNotEmpty);
    });
  });
}
