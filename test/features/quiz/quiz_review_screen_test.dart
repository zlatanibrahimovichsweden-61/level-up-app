/// `/quiz/:quizId/result/review` — Figma `162:2377` / `337:6705` / `549:20324`.
///
/// The screen consumes NO endpoint, so there is deliberately no repository stub
/// here and no loading/error/offline case to drive: the payload arrives with
/// the route. What is worth asserting instead is that it never reaches for one,
/// and that the one screen listing correct answers is screenshot-protected.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/quiz/models/quiz_review_args.dart';
import 'package:level_up_app/features/quiz/screens/quiz_review_screen.dart';
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
      expect(find.byIcon(Icons.check), findsNWidgets(2));
      // One ✕ per wrong row, plus the one inside the "Wrong" filter chip.
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
      // No grade anywhere, so no ✓ and no ✕ except the filter chip's own.
      expect(find.byIcon(Icons.check), findsNothing);
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
    // The correct row's fill is opaque #BFFFC3 in BOTH canvases, so its
    // foreground must not follow the theme. It used to: cream on mint measured
    // 1.11:1 in dark, which is invisible rather than merely dim.
    testWidgets('the correct row keeps its dark foreground in dark mode', (
      tester,
    ) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      final ext = Theme.of(
        tester.element(find.byType(QuizReviewScreen)),
      ).extension<AppColors>()!;

      final label = tester.widget<Text>(find.text('QUESTION 1'));
      final body = tester.widget<Text>(find.text('Question q1?'));

      expect(body.style?.color, ext.quizReviewRowContent);
      expect(label.style?.color, ext.quizReviewRowContent);
      // The whole point: it does NOT flip to the cream dark foreground.
      expect(body.style?.color, isNot(ext.textPrimary));
    });

    testWidgets('a wrong row DOES follow the theme, because its fill does', (
      tester,
    ) async {
      await openReview(tester, args: compact(), theme: AppTheme.dark);

      final ext = Theme.of(
        tester.element(find.byType(QuizReviewScreen)),
      ).extension<AppColors>()!;

      // q3 is wrong in the compact fixture; quizWrongFill is 30% alpha, so it
      // composites with the canvas and its foreground must too.
      final body = tester.widget<Text>(find.text('Question q3?'));
      expect(body.style?.color, ext.textPrimary);
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
      // marks, in both themes. app_colors.dart:236.
      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });

    testWidgets('Arabic + dark together', (tester) async {
      await openReview(
        tester,
        args: compact(),
        locale: 'ar',
        theme: AppTheme.dark,
      );

      expect(find.text('مراجعة الاختبار'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });
  });
}
