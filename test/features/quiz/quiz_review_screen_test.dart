/// `/quiz/:quizId/result/review` — Figma `162:2377` / `337:6705` / `549:20324`.
///
/// The screen consumes NO endpoint, so there is deliberately no repository stub
/// here and no loading/error/offline case to drive: the payload arrives with
/// the route. What is worth asserting instead is that it never reaches for one,
/// and that the one screen listing correct answers is screenshot-protected.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/features/quiz/models/quiz_question.dart';
import 'package:level_up_app/features/quiz/models/quiz_review_args.dart';
import 'package:level_up_app/features/quiz/screens/quiz_review_screen.dart';
import 'package:level_up_app/features/quiz/widgets/question_stem_text.dart';
import 'package:mocktail/mocktail.dart';

import 'quiz_fixtures.dart';
import 'quiz_harness.dart';

void main() {
  Future<QuizHarness> openReview(
    WidgetTester tester, {
    QuizReviewArgs? args,
    String locale = 'en',
    ThemeData? theme,
    Object? extra,
  }) async {
    final harness = await pumpQuizApp(tester, locale: locale, theme: theme);
    harness.router.push(
      '/quiz/quiz-1/result/review',
      extra: extra ?? args ?? quizReviewArgs(),
    );
    await tester.pumpAndSettle();
    return harness;
  }

  // The list is lazy and the test viewport is 800x600, so only about five rows
  // are ever mounted. Any assertion that COUNTS rows uses this compact fixture,
  // which fits whole: 5 questions, q1-q4 committed, q1-q2 correct — 2 correct,
  // 2 wrong (q3, q4), 1 skipped (q5).
  QuizReviewArgs compact() =>
      quizReviewArgs(totalQuestions: 5, answeredCount: 4, score: 2);

  group('the four render states', () {
    testWidgets('correct, wrong and skipped rows all render together', (
      tester,
    ) async {
      await openReview(tester, args: compact());

      expect(find.byType(QuizReviewScreen), findsOneWidget);
      expect(find.text('Quiz Review'), findsOneWidget);

      // Every question is a row under "All", numbered by its position in the
      // whole quiz.
      expect(find.text('QUESTION 1'), findsOneWidget);
      expect(find.text('QUESTION 5'), findsOneWidget);
      expect(find.text('Question q1?'), findsOneWidget);

      // 2 correct ticks, 2 wrong crosses, and the skipped row carries neither.
      // Plus one of each inside the "Correct" and "Wrong" filter chips' discs
      // (`162:2788`, `162:2792`).
      expect(find.byIcon(Icons.check), findsNWidgets(3));
      expect(find.byIcon(Icons.close), findsNWidgets(3));
    });

    testWidgets('a long quiz scrolls to its last row', (tester) async {
      // The default fixture is 10 questions — more than one viewport.
      await openReview(tester);

      expect(find.text('QUESTION 1'), findsOneWidget);
      expect(find.text('QUESTION 10'), findsNothing);

      await tester.scrollUntilVisible(
        find.text('QUESTION 10'),
        200,
        // Two scrollables are on screen — the horizontal filter row and the
        // list. Name the list, or the finder is ambiguous.
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('QUESTION 10'), findsOneWidget);
    });

    testWidgets('EMPTY — a filter that selects no rows', (tester) async {
      // A quiz answered entirely wrong: "Correct" selects nothing.
      await openReview(
        tester,
        args: quizReviewArgs(totalQuestions: 3, answeredCount: 3, score: 0),
      );

      await tester.tap(find.text('Correct'));
      await tester.pumpAndSettle();

      expect(find.text('No questions to show here.'), findsOneWidget);
      expect(find.textContaining('QUESTION'), findsNothing);
    });

    testWidgets('a quiz finished with ZERO answers is all skipped', (
      tester,
    ) async {
      await openReview(
        tester,
        args: quizReviewArgs(totalQuestions: 3, answeredCount: 0, score: 0),
      );

      expect(find.text('QUESTION 1'), findsOneWidget);
      expect(find.text('QUESTION 3'), findsOneWidget);
      // No grade anywhere, so no ✓ and no ✕ except the filter chips' own.
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('a malformed extra renders the unavailable view, not a crash', (
      tester,
    ) async {
      // The review payload is in-memory only. A cold deep link or a process
      // restart lands here with nothing to rebuild from — unlike its two
      // ancestors, this route must not force-unwrap.
      await openReview(tester, extra: 'not a QuizReviewArgs');

      expect(find.byType(QuizReviewScreen), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('filtering', () {
    testWidgets('Correct and Wrong partition, and never renumber a row', (
      tester,
    ) async {
      await openReview(tester);

      await tester.tap(find.text('Correct'));
      await tester.pumpAndSettle();
      expect(find.text('QUESTION 1'), findsOneWidget);
      expect(find.text('QUESTION 5'), findsOneWidget);
      expect(find.text('QUESTION 6'), findsNothing);

      await tester.tap(find.text('Wrong'));
      await tester.pumpAndSettle();
      // q6–q8 are wrong. The label keeps the question's position in the QUIZ,
      // so the first wrong row is still "QUESTION 6", not "QUESTION 1".
      expect(find.text('QUESTION 6'), findsOneWidget);
      expect(find.text('QUESTION 8'), findsOneWidget);
      expect(find.text('QUESTION 1'), findsNothing);
      // Skipped is not wrong — q9 and q10 must not appear here.
      expect(find.text('QUESTION 9'), findsNothing);
    });

    testWidgets('only the All chip carries a count', (tester) async {
      await openReview(tester);

      expect(find.text('All (10)'), findsOneWidget);
      // Bare labels, per the frame — no invented counts.
      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Wrong'), findsOneWidget);
      expect(find.text('Correct (5)'), findsNothing);
      expect(find.text('Wrong (3)'), findsNothing);
    });
  });

  group('the AI glyph', () {
    testWidgets('is absent when the server has no explanation', (tester) async {
      // `explanationAvailable` is the contract's own gate on AnswerResult.
      // Drawing the glyph on every wrong row would promise something the
      // backend may not have.
      await openReview(
        tester,
        args: quizReviewArgs(
          totalQuestions: 5,
          answeredCount: 4,
          score: 2,
          explanationAvailable: false,
        ),
      );

      expect(find.text('QUESTION 3'), findsOneWidget); // the wrong rows render
      expect(find.bySemanticsLabel('AI explanation available'), findsNothing);
    });

    testWidgets('is present on wrong rows when it is available', (
      tester,
    ) async {
      await openReview(tester, args: compact());

      // Wrong rows only — q3 and q4 of the compact fixture.
      expect(
        find.bySemanticsLabel(RegExp('AI explanation available')),
        findsNWidgets(2),
      );
    });
  });

  group('legibility', () {
    // ------------------------------------------------------------------
    // REWRITTEN 2026-09-20, edit4 item #48, under docs/DECISIONS.md D-010.
    //
    // The assertion that stood here said the opposite, and it was right at
    // the time: the correct row's fill was opaque mint on BOTH canvases, so
    // its foreground could not follow the theme - cream on mint measured
    // 1.11:1 in dark, invisible rather than dim - and the test pinned that
    // with `isNot(ext.textPrimary)`.
    //
    // The designer reversed the ruling underneath it. The dark rows now take
    // the frame's own treatment: the semantic fill at 20%, a 0.5 semantic
    // stroke and G5 Glass. `reviewRowCorrectFill` composites to a DARK
    // `#425047`, on which the old dark-green foreground measures 1.04:1 -
    // the same failure arriving from the other direction.
    //
    // So the rule the group enforces is inverted, not dropped: every row's
    // foreground follows its fill, and every fill now follows the canvas.
    // The token that carries it is unchanged, which is the point of it
    // being a token.
    // ------------------------------------------------------------------
    testWidgets('the correct row follows the canvas now, because its fill '
        'does', (tester) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      final ext = Theme.of(
        tester.element(find.byType(QuizReviewScreen)),
      ).extension<AppColors>()!;

      final label = tester.widget<Text>(find.text('QUESTION 1'));
      final body = tester.widget<Text>(find.text('Question q1?'));

      // Still its own token - the row does not borrow textPrimary.
      expect(body.style?.color, ext.quizReviewRowContent);
      // The label has its own token since Wave 14 (`162:2492`); in dark it is
      // the same cream by owner ruling, not the frame's lavender.
      expect(label.style?.color, ext.reviewRowLabel);

      // What changed, stated as the design fact rather than as "it now
      // equals textPrimary" - the two being equal in dark is a
      // coincidence the token's own field doc calls a coincidence, so
      // pinning it would pin the wrong thing. `337:6715` says cream, and
      // cream is what has to survive on the composited fill.
      expect(body.style?.color, const Color(0xFFFCFBF9));
      // It is NOT the light value any more, which is the actual break
      // from the superseded ruling.
      expect(
        body.style?.color,
        isNot(AppTheme.light.extension<AppColors>()!.quizReviewRowContent),
      );
    });

    testWidgets('the correct row keeps its own token, which is GREEN in '
        'light', (tester) async {
      await openReview(tester, args: compact());

      final ext = Theme.of(
        tester.element(find.byType(QuizReviewScreen)),
      ).extension<AppColors>()!;

      final body = tester.widget<Text>(find.text('Question q1?'));

      expect(body.style?.color, ext.quizReviewRowContent);
      // The half of the old rule that survives: the light row is unchanged,
      // its fill is still the opaque mint, and its foreground is the green
      // 162:2510 specifies - NOT the near-black textPrimary.
      expect(body.style?.color, isNot(ext.textPrimary));
    });

    testWidgets('a wrong row DOES follow the theme, because its fill does', (
      tester,
    ) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      final ext = Theme.of(
        tester.element(find.byType(QuizReviewScreen)),
      ).extension<AppColors>()!;

      // q3 is wrong in the compact fixture; reviewRowWrongFill is 20% alpha
      // in dark, so it composites with the canvas and its foreground must
      // too. Measured 9.11:1 on the composite. Since Wave 14 it is the
      // correct row's token: `162:2572` draws the wrong row's question in the
      // same `#384F47` as `162:2510`, and dark is cream on both.
      final body = tester.widget<Text>(find.text('Question q3?'));
      expect(body.style?.color, ext.quizReviewRowContent);
      expect(body.style?.color, const Color(0xFFFCFBF9));
    });

    testWidgets('every dark row is translucent and glassed - none is left '
        'opaque beside a glassed neighbour', (tester) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      final element = tester.element(find.byType(QuizReviewScreen));
      final ext = Theme.of(element).extension<AppColors>()!;
      final elevation = Theme.of(element).extension<AppElevation>()!;

      // D-010's own emphasis: EQUAL in treatment. A row state that stayed
      // opaque here would be the specific defect the ruling named.
      for (final fill in [
        ext.reviewRowCorrectFill,
        ext.reviewRowWrongFill,
        ext.reviewRowSkippedFill,
      ]) {
        expect(fill.a, closeTo(0.2, 0.01), reason: 'the frame reads 20%');
      }
      expect(elevation.reviewRowGlass, isNotNull);

      // And ALL THREE rows really do paint them. Checking only the
      // correct row would let the other two be reverted to opaque with
      // the suite still green - which is the exact defect the ruling
      // named, so the assertion has to walk every state.
      //
      // The compact fixture is 5 questions, 4 answered, 2 correct:
      // q1-q2 correct, q3-q4 wrong, q5 never committed.
      ElevatedSurface rowFor(String question) => tester
          .widgetList<ElevatedSurface>(
            find.ancestor(
              of: find.text(question),
              matching: find.byType(ElevatedSurface),
            ),
          )
          .first;

      for (final (question, fill, stroke, state) in [
        (
          'Question q1?',
          ext.reviewRowCorrectFill,
          ext.quizCorrectBorder,
          'correct',
        ),
        ('Question q3?', ext.reviewRowWrongFill, ext.quizWrongBorder, 'wrong'),
        (
          'Question q5?',
          ext.reviewRowSkippedFill,
          ext.quizOptionBorder,
          'skipped',
        ),
      ]) {
        final row = rowFor(question);
        expect(row.color, fill, reason: state);
        expect(row.glass, elevation.reviewRowGlass, reason: state);
        expect(row.glass, isNotNull, reason: state);
        expect(row.side?.width, 0.5, reason: state);
        expect(row.side?.color, stroke, reason: state);
        // The thing the ruling actually forbids: one row opaque beside a
        // glassed neighbour.
        expect(row.color!.a, closeTo(0.2, 0.01), reason: state);
      }
    });

    testWidgets('the light rows keep their opaque fills and take no Glass', (
      tester,
    ) async {
      await openReview(tester, args: compact());

      final element = tester.element(find.byType(QuizReviewScreen));
      final ext = Theme.of(element).extension<AppColors>()!;

      // D-010 is a DARK ruling. The light frame was never in question.
      expect(ext.reviewRowCorrectFill, ext.quizCorrectFill);
      expect(ext.reviewRowWrongFill, ext.quizWrongFill);
      expect(ext.reviewRowSkippedFill, ext.quizOptionFill);

      final surface = tester
          .widgetList<ElevatedSurface>(
            find.ancestor(
              of: find.text('Question q1?'),
              matching: find.byType(ElevatedSurface),
            ),
          )
          .first;
      expect(surface.glass, isNull);
    });

    testWidgets('rows and chips survive a large text scale without overflow', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await openReview(tester, args: compact());

      // Fixed heights used to overflow from scale 1.35 — below Android's
      // largest standard setting.
      expect(tester.takeException(), isNull);
    });

    testWidgets('filter chips meet the 48dp minimum tap target', (
      tester,
    ) async {
      await openReview(tester, args: compact());

      for (final label in ['All (5)', 'Correct', 'Wrong']) {
        final size = tester.getSize(
          find
              .ancestor(of: find.text(label), matching: find.byType(SizedBox))
              .first,
        );
        expect(
          size.height,
          greaterThanOrEqualTo(48.0),
          reason: '$label is a $size tap target',
        );
      }
    });
  });

  group('screenshot protection', () {
    // This is the one screen that lists which answers were right. QuizScreen
    // turns protection off in its own dispose and the result screen between
    // the two is stateless, so review must wire it itself.
    testWidgets('is ON while the review screen is mounted', (tester) async {
      final harness = await openReview(tester);

      expect(harness.protection.enableCalls, 1);
      expect(harness.protection.disableCalls, 0);
    });

    testWidgets('is OFF again once it is popped', (tester) async {
      final harness = await openReview(tester);

      harness.router.pop();
      await tester.pumpAndSettle();

      expect(harness.protection.disableCalls, 1);
    });
  });

  group('the review path consumes nothing and persists nothing', () {
    testWidgets('calls no endpoint', (tester) async {
      final harness = await openReview(tester);

      // The screen holds its payload from `extra`. If it ever grows a fetch,
      // this fails — which is the point: `GET /quizzes/{quizId}` is draft, and
      // the whole reason this screen is buildable is that it needs none.
      verifyZeroInteractions(harness.quiz);

      // Filtering is client-side partitioning of data already in hand.
      await tester.tap(find.text('Correct'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wrong'));
      await tester.pumpAndSettle();

      verifyZeroInteractions(harness.quiz);
    });

    testWidgets('writes nothing to storage', (tester) async {
      // "Correct answers never ship with questions — content protection: the
      // bank is the product." The quiz feature caches nothing (there is no
      // Hive anywhere under lib/features/quiz/), and the one screen that lists
      // which answers were right must not become the exception.
      final harness = await openReview(tester);

      verifyNever(
        () => harness.storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      );
      verifyNever(harness.storage.clearTokens);
    });
  });

  group('states matrix', () {
    testWidgets('Arabic (RTL)', (tester) async {
      await openReview(tester, locale: 'ar');

      expect(find.text('مراجعة الاختبار'), findsOneWidget);
      expect(find.text('الكل (10)'), findsOneWidget);
      // Reused from the result screen rather than translated twice.
      expect(find.text('صحيحة'), findsOneWidget);
      expect(find.text('خاطئة'), findsOneWidget);
      expect(find.text('السؤال 1'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('الكل (10)'))),
        TextDirection.rtl,
      );
    });

    testWidgets('dark theme', (tester) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      expect(find.text('Quiz Review'), findsOneWidget);
      expect(find.text('All (5)'), findsOneWidget);
      // The correctness signal does NOT flip with the canvas — same rows, same
      // marks, in both themes. app_colors.dart:236. (2 rows + the chip's.)
      expect(find.byIcon(Icons.check), findsNWidgets(3));
    });

    testWidgets('Arabic + dark together', (tester) async {
      await openReview(
        tester,
        args: compact(),
        locale: 'ar',
        theme: AppTheme.dark,
      );

      expect(find.text('مراجعة الاختبار'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNWidgets(3));
    });
  });

  // ------------------------------------------------------------ Wave 14 -----
  group('Wave 14: the frames (162:2377 · 337:6705)', () {
    Finder rowOf(String question) => find
        .ancestor(
          of: find.text(question),
          matching: find.byType(ElevatedSurface),
        )
        .first;
    Finder pillOf(String label) => find
        .ancestor(of: find.text(label), matching: find.byType(ElevatedSurface))
        .first;
    Finder inRow(Finder row, Finder matching) =>
        find.descendant(of: row, matching: matching);
    AppColors colors(WidgetTester tester) => Theme.of(
      tester.element(find.byType(QuizReviewScreen)),
    ).extension<AppColors>()!;
    const header = Key('quiz_review_header');
    const rowBadge = Key('review_row_badge');
    const rowText = Key('review_row_text');
    const chipBadge = Key('review_filter_badge');

    testWidgets('header: 63 tall over the frame\'s rule, chip 21 in and '
        'centred, title #000000', (tester) async {
      await openReview(tester, args: compact());

      final bar = tester.getRect(find.byKey(header));
      expect(bar.height, closeTo(63, 0.01));
      final box = tester.widget<Container>(find.byKey(header)).decoration!;
      final rule = ((box as BoxDecoration).border! as Border).bottom;
      expect(rule.color, colors(tester).quizHeaderRule);
      expect(rule.width, 1.18);

      final chip = tester.getRect(find.byKey(const Key('quiz_review_back')));
      expect(chip.left - bar.left, closeTo(21, 0.01));
      expect(chip.center.dy - bar.top, closeTo(32.09, 0.01));

      final title = tester.widget<Text>(find.text('Quiz Review'));
      expect(title.style?.color, colors(tester).quizReviewTitle);
      expect(title.style?.color, const Color(0xFF000000));
      expect(
        tester.getCenter(find.text('Quiz Review')).dx,
        closeTo(bar.center.dx, 0.01),
      );
    });

    testWidgets('dark header: cream title over the same rule', (tester) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      final title = tester.widget<Text>(find.text('Quiz Review'));
      expect(title.style?.color, const Color(0xFFFCFBF9));
      final box = tester.widget<Container>(find.byKey(header)).decoration!;
      expect(
        ((box as BoxDecoration).border! as Border).bottom.color,
        const Color.fromRGBO(124, 58, 237, 0.1),
      );
    });

    testWidgets('chips: 25 under the rule, 8 apart, 14.18 over the first '
        'row', (tester) async {
      await openReview(tester, args: compact());

      final bar = tester.getRect(find.byKey(header));
      final all = tester.getRect(pillOf('All (5)'));
      final correct = tester.getRect(pillOf('Correct'));
      final wrong = tester.getRect(pillOf('Wrong'));
      expect(all.top - bar.bottom, closeTo(25, 0.01));
      expect(all.height, closeTo(32, 0.01));
      expect(all.left, closeTo(20, 0.01));
      expect(correct.left - all.right, closeTo(8, 0.01));
      expect(wrong.left - correct.right, closeTo(8, 0.01));

      final first = tester.getRect(rowOf('Question q1?'));
      expect(first.top - all.bottom, closeTo(14.18, 0.01));
    });

    testWidgets('chips: "Correct" and "Wrong" lead with the frame\'s 16 '
        'discs, 10 before the label', (tester) async {
      await openReview(tester, args: compact());
      final ext = colors(tester);

      for (final (label, color, icon, size) in [
        ('Correct', ext.successBadge, Icons.check, 8.0),
        ('Wrong', ext.quizWrongBadge, Icons.close, 14.0),
      ]) {
        final disc = inRow(pillOf(label), find.byKey(chipBadge));
        expect(tester.getSize(disc), const Size(16, 16), reason: label);
        final deco =
            tester.widget<Container>(disc).decoration! as BoxDecoration;
        expect(deco.color, color, reason: label);
        expect(deco.shape, BoxShape.circle, reason: label);

        final glyph = tester.widget<Icon>(
          find.descendant(of: disc, matching: find.byType(Icon)),
        );
        expect(glyph.icon, icon, reason: label);
        expect(glyph.size, size, reason: label);
        expect(glyph.color, const Color(0xFFFCFBF9), reason: label);

        expect(
          tester.getRect(find.text(label)).left - tester.getRect(disc).right,
          closeTo(10, 0.01),
          reason: label,
        );
      }
      expect(inRow(pillOf('All (5)'), find.byKey(chipBadge)), findsNothing);
    });

    testWidgets('chips: an idle label is #384F47 in light, cream in dark', (
      tester,
    ) async {
      await openReview(tester, args: compact());
      var ext = colors(tester);

      Color? colorOf(String label) =>
          tester.widget<Text>(find.text(label)).style?.color;
      expect(colorOf('Correct'), ext.reviewFilterIdleLabel);
      expect(colorOf('Correct'), const Color(0xFF384F47));
      expect(colorOf('All (5)'), ext.quizReviewFilterLabel);

      await tester.tap(find.text('Correct'));
      await tester.pumpAndSettle();
      expect(colorOf('Correct'), ext.quizReviewFilterLabel);
      expect(colorOf('All (5)'), const Color(0xFF384F47));

      await openReview(tester, args: compact(), theme: AppTheme.dark);
      ext = colors(tester);
      expect(colorOf('Wrong'), ext.reviewFilterIdleLabel);
      expect(colorOf('Wrong'), const Color(0xFFFCFBF9));
    });

    testWidgets('rows: 19 apart', (tester) async {
      await openReview(tester, args: compact());

      final one = tester.getRect(rowOf('Question q1?'));
      final two = tester.getRect(rowOf('Question q2?'));
      final three = tester.getRect(rowOf('Question q3?'));
      expect(two.top - one.bottom, closeTo(19, 0.01));
      expect(three.top - two.bottom, closeTo(19, 0.01));
    });

    testWidgets('rows: badge 9 in, text 3.5 after it and on to 5.82 from the '
        'end; the badge ring is its own fill', (tester) async {
      await openReview(tester, args: compact());

      for (final n in [1, 3, 5]) {
        final row = rowOf('Question q$n?');
        final r = tester.getRect(row);
        final badge = tester.getRect(inRow(row, find.byKey(rowBadge)));
        final text = tester.getRect(inRow(row, find.byKey(rowText)));
        expect(badge.left - r.left, closeTo(9, 0.01), reason: 'q$n');
        expect(badge.size, const Size(28, 28), reason: 'q$n');
        expect(badge.center.dy - r.top, closeTo(36.5, 0.01), reason: 'q$n');
        expect(text.left - badge.right, closeTo(3.5, 0.01), reason: 'q$n');
        expect(r.right - text.right, closeTo(5.82, 0.01), reason: 'q$n');
      }

      // Graded rows: `bg-[#22c55e] border-[#22c55e]` — no dark ring.
      for (final n in [1, 3]) {
        final deco =
            tester
                    .widget<Container>(
                      inRow(rowOf('Question q$n?'), find.byKey(rowBadge)),
                    )
                    .decoration!
                as BoxDecoration;
        expect((deco.border! as Border).top.color, deco.color, reason: 'q$n');
        expect((deco.border! as Border).top.width, 1.18, reason: 'q$n');
      }
    });

    testWidgets('rows: the label and question sit on the frame\'s lines', (
      tester,
    ) async {
      // `162:2500`: an 18 label box (its line 4.36 down), 7, a 25.6 line,
      // centred in 73. On the scale's 16 and 24 lines the same centres are
      // 16.56 and 37.0 from the row's top.
      await openReview(tester, args: compact());

      final r = tester.getRect(rowOf('Question q1?'));
      final label = tester.getRect(find.text('QUESTION 1'));
      final question = tester.getRect(find.text('Question q1?'));
      expect(r.height, closeTo(73, 0.01));
      expect(label.top - r.top, closeTo(16.56, 0.01));
      expect(question.top - label.bottom, closeTo(4.44, 0.01));
      expect(question.top - r.top, closeTo(37.0, 0.01));
    });

    testWidgets('light: "QUESTION n" #4B675E and the question #384F47 on '
        'every row', (tester) async {
      await openReview(tester, args: compact());
      final ext = colors(tester);

      // q1 correct, q3 wrong, q5 skipped: `162:2492` / `162:2587` and
      // `162:2494` / `162:2588` do not change colour with the grade.
      for (final n in [1, 3, 5]) {
        final label = tester.widget<Text>(find.text('QUESTION $n'));
        final body = tester.widget<Text>(find.text('Question q$n?'));
        expect(label.style?.color, ext.reviewRowLabel, reason: 'q$n');
        expect(label.style?.color, const Color(0xFF4B675E), reason: 'q$n');
        expect(body.style?.color, ext.quizReviewRowContent, reason: 'q$n');
        expect(body.style?.color, const Color(0xFF384F47), reason: 'q$n');
      }
    });

    testWidgets('dark: label and question cream on every row; the label is '
        'NOT the frame\'s lavender (owner ruling)', (tester) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      for (final n in [1, 3, 5]) {
        final label = tester.widget<Text>(find.text('QUESTION $n'));
        final body = tester.widget<Text>(find.text('Question q$n?'));
        expect(label.style?.color, const Color(0xFFFCFBF9), reason: 'q$n');
        expect(label.style?.color, isNot(const Color(0xFFAE87E7)));
        expect(body.style?.color, const Color(0xFFFCFBF9), reason: 'q$n');
      }
    });

    testWidgets('the AI glyph sits in the top-end corner, over the text '
        'column, in the question\'s colour', (tester) async {
      await openReview(tester, args: compact());

      final row = rowOf('Question q3?');
      final r = tester.getRect(row);
      final glyph = inRow(row, find.byType(SvgPicture));
      final g = tester.getRect(glyph);
      // The drawing inside `162:2589`'s 26.55 box is 26.18 x 24.41, 0.18 in.
      // Sized by height (the asset's 27 x 25 gives 26.36 wide); it used to
      // draw 28.67 x 26.55.
      expect(g.height, closeTo(24.41, 0.01));
      expect(g.width, closeTo(24.41 * 27 / 25, 0.01));
      expect(g.top - r.top, closeTo(10.83, 0.01));
      expect(r.right - g.right, closeTo(10.64, 0.01));
      // It takes no width from the text: the column still runs to 5.82.
      final text = tester.getRect(inRow(row, find.byKey(rowText)));
      expect(r.right - text.right, closeTo(5.82, 0.01));

      expect(
        tester.widget<SvgPicture>(glyph).colorFilter,
        ColorFilter.mode(colors(tester).quizReviewRowContent, BlendMode.srcIn),
      );
    });

    testWidgets('Arabic: badge, text and glyph mirror', (tester) async {
      await openReview(tester, args: compact(), locale: 'ar');

      final row = rowOf('Question q3?');
      final r = tester.getRect(row);
      final badge = tester.getRect(inRow(row, find.byKey(rowBadge)));
      final text = tester.getRect(inRow(row, find.byKey(rowText)));
      final g = tester.getRect(inRow(row, find.byType(SvgPicture)));
      expect(r.right - badge.right, closeTo(9, 0.01));
      expect(badge.left - text.right, closeTo(3.5, 0.01));
      expect(text.left - r.left, closeTo(5.82, 0.01));
      expect(g.left - r.left, closeTo(10.64, 0.01));
    });

    for (final scale in [1.30, 1.35]) {
      testWidgets('text scale $scale: the row grows around its lines, it '
          'never clips them', (tester) async {
        // Android's largest standard font setting is 1.30; the 73 row used to
        // have 13 px of slack, which 1.35 exhausted. The row is a minimum now:
        // 10 + 4.56 + the label line + 4.44 + the question line + 10.
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await openReview(tester, args: compact());

        expect(tester.takeException(), isNull);
        for (final n in [1, 3, 5]) {
          final r = tester.getRect(rowOf('Question q$n?'));
          expect(r.height, closeTo(29 + 40 * scale, 0.01), reason: 'q$n');
          expect(
            tester.getRect(find.text('QUESTION $n')).top,
            greaterThanOrEqualTo(r.top),
          );
          expect(
            tester.getRect(find.text('Question q$n?')).bottom,
            lessThanOrEqualTo(r.bottom),
          );
        }
      });
    }

    testWidgets('a stem\'s <u>…</u> is an underline here too, and TalkBack '
        'hears the words', (tester) async {
      final handle = tester.ensureSemantics();
      final question = QuizQuestion.fromJson({
        ...questionJson('q1'),
        'text': 'Which <u>organelle</u> makes ATP?',
      });
      await openReview(
        tester,
        args: QuizReviewArgs(
          questions: [question],
          grades: {'q1': answerResult(correct: false)},
        ),
      );

      expect(find.text('Which organelle makes ATP?'), findsOneWidget);
      expect(find.textContaining('<u>'), findsNothing);
      expect(find.bySemanticsLabel(RegExp('<u>|</u>')), findsNothing);
      expect(find.byType(QuestionStemText), findsOneWidget);
      handle.dispose();
    });

    testWidgets('an Arabic stem truncates at its own end in the English app', (
      tester,
    ) async {
      // Device-found on the Wave 13 re-walk (`walk13b/02`): the ellipsis sat
      // before "السؤال" and the stem was cut mid-word at its end.
      final question = QuizQuestion.fromJson({
        ...questionJson('q1'),
        'text':
            'السؤال 1: أي من الخيارات التالية يصف <u>التركيب</u> بشكل صحيح؟ '
            'أي من الخيارات التالية يصف التركيب بشكل صحيح؟',
      });
      await openReview(
        tester,
        args: QuizReviewArgs(
          questions: [question],
          grades: {'q1': answerResult(correct: false)},
        ),
      );

      final p = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.byType(QuestionStemText),
          matching: find.byType(RichText),
        ),
      );
      expect(p.textDirection, TextDirection.rtl);
      expect(p.textAlign, TextAlign.left);
      expect(p.maxLines, 1);
      expect(p.overflow, TextOverflow.ellipsis);
    });
  });
}
