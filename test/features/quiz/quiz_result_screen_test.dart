import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/quiz/models/quiz_review_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_summary.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_review_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';

import 'quiz_fixtures.dart';
import 'quiz_harness.dart';

void main() {
  Future<QuizHarness> openResult(
    WidgetTester tester, {
    required QuizSummary summary,
    String scopeName = 'Cell Structure',
    String locale = 'en',
    ThemeData? theme,
    QuizReviewArgs? review,
  }) async {
    final harness = await pumpQuizApp(tester, locale: locale, theme: theme);
    harness.router.push(
      '/quiz/quiz-1/result',
      extra: QuizResultArgs(
        summary: summary,
        scopeName: scopeName,
        review: review ?? quizReviewArgs(),
      ),
    );
    await tester.pumpAndSettle();
    return harness;
  }

  // MANDATED TEST 2 — a partially-answered quiz.
  group('a PARTIALLY answered quiz', () {
    testWidgets('wrong is answeredCount - score, and Skipped is rendered', (
      tester,
    ) async {
      // 10 questions, 8 answered, 5 correct.
      // Correct 5 · Wrong 3 (8 - 5) · Skipped 2 (10 - 8).
      await openResult(tester, summary: quizSummary());

      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Wrong'), findsOneWidget);
      expect(find.text('Skipped'), findsOneWidget);

      expect(find.text('3'), findsOneWidget); // 8 answered - 5 correct
      expect(find.text('2'), findsOneWidget); // 10 total - 8 answered

      // Exactly ONE "5" on screen — the score. `totalQuestions - score` is
      // also 5, so the bug would put a second one in the Wrong card and this
      // assertion would fail. Rendering 5 wrong would call two questions the
      // student never reached mistakes.
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('the three buckets account for every question', (tester) async {
      final summary = quizSummary();
      await openResult(tester, summary: summary);

      expect(summary.score + summary.wrong + summary.skipped, 10);
      expect(summary.wrong, 3);
      expect(summary.skipped, 2);
    });

    testWidgets('a fully answered quiz renders NO Skipped card', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 7, totalQuestions: 10, answeredCount: 10),
      );

      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Wrong'), findsOneWidget);
      // The frame has two buckets; a third that always reads 0 is noise.
      expect(find.text('Skipped'), findsNothing);
    });

    testWidgets('a quiz abandoned after one question is still truthful', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(
          score: 1,
          totalQuestions: 10,
          answeredCount: 1,
          pointsAwarded: 1,
        ),
      );

      expect(find.text('Skipped'), findsOneWidget);
      expect(find.text('9'), findsOneWidget); // skipped
      expect(find.text('0'), findsOneWidget); // wrong — not 9
    });
  });

  group('what the frame draws but the contract cannot back', () {
    // CONFLICT 2 / S13.
    testWidgets('renders the percentage ring but NO Pass/Fail verdict', (
      tester,
    ) async {
      await openResult(tester, summary: quizSummary());

      expect(find.text('50%'), findsOneWidget);
      expect(find.text('Pass'), findsNothing);
      expect(find.text('Fail'), findsNothing);
      expect(find.textContaining('Pass'), findsNothing);
    });

    // CONFLICT 3 / S14 is now NARROWED, not open: review-from-result shipped on
    // Day 8-9 with no endpoint at all. The live CTA is asserted in the
    // 'Review Questions' group below. What stays blocked on the draft
    // `GET /quizzes/{quizId}` is review from HISTORY, which has no entry point
    // on this screen to assert.

    // CONFLICT 1 / S12.
    testWidgets('points come from the server verbatim, never computed', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, pointsAwarded: 5),
      );

      expect(find.text('+5 Points'), findsOneWidget);
      // The design's figure for a 10-question quiz. The contract awards at most
      // one point per question, so it can never appear.
      expect(find.text('+200 Points'), findsNothing);
      expect(find.text('+30 Points'), findsNothing);
    });

    // 3.0.0-m1 (adr-102) / D-006: the summary no longer carries the student's
    // standing, and the frame draws no level number or points total.
    testWidgets('no level number or points total is rendered', (tester) async {
      await openResult(tester, summary: quizSummary(pointsAwarded: 5));

      expect(find.text('+5 Points'), findsOneWidget);
      expect(find.text('Level Progress'), findsNothing);
      expect(find.textContaining('Level'), findsNothing);
      expect(find.textContaining(RegExp(r'\d+ points')), findsNothing);
    });

    testWidgets('the subject line is absent — QuizSummary carries no scope', (
      tester,
    ) async {
      await openResult(tester, summary: quizSummary());

      // Only the scopeName carried forward from the Quiz.
      expect(find.text('Cell Structure'), findsOneWidget);
      expect(find.text('Biology — Cell Structure'), findsNothing);
    });
  });

  group('Review Questions', () {
    testWidgets('is LIVE and opens the review screen', (tester) async {
      // It shipped disabled behind a Tooltip until Day 8-9, on the reading that
      // review needed the draft `GET /quizzes/{quizId}`. It does not: the quiz
      // just finished is still in hand.
      final harness = await openResult(tester, summary: quizSummary());

      final cta = find.widgetWithText(FilledButton, 'Review Questions');
      expect(cta, findsOneWidget);
      expect(tester.widget<FilledButton>(cta).onPressed, isNotNull);
      expect(find.byType(Tooltip), findsNothing);
      expect(find.textContaining('coming soon'), findsNothing);

      await tester.tap(cta);
      await tester.pumpAndSettle();

      expect(find.byType(QuizReviewScreen), findsOneWidget);
      expect(harness.router.state.uri.path, '/quiz/quiz-1/result/review');
    });

    testWidgets('review is pushed, so Back returns to the result', (
      tester,
    ) async {
      await openResult(tester, summary: quizSummary());

      await tester.tap(find.widgetWithText(FilledButton, 'Review Questions'));
      await tester.pumpAndSettle();
      expect(find.byType(QuizReviewScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Back out of review lands on the result, NOT on Learn — the result's own
      // PopScope only governs the result screen's own Back.
      expect(find.byType(QuizReviewScreen), findsNothing);
      expect(find.byType(QuizResultScreen), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('Back leaves for Learn, never into the finished quiz', (
      tester,
    ) async {
      final harness = await openResult(tester, summary: quizSummary());

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(QuizResultScreen), findsNothing);
      expect(find.byType(QuizScreen), findsNothing);
      expect(
        harness.router.routerDelegate.currentConfiguration.uri.path,
        '/learn',
      );
    });
  });

  group('states matrix', () {
    testWidgets('Arabic (RTL)', (tester) async {
      await openResult(tester, summary: quizSummary(), locale: 'ar');

      expect(find.text('أنهيت الاختبار!'), findsOneWidget);
      expect(find.text('صحيحة'), findsOneWidget);
      expect(find.text('خاطئة'), findsOneWidget);
      expect(find.text('متروكة'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('صحيحة'))),
        TextDirection.rtl,
      );
    });

    testWidgets('dark theme', (tester) async {
      await openResult(tester, summary: quizSummary(), theme: AppTheme.dark);

      expect(find.text('Quiz Complete!'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('a zero-question quiz draws an empty ring, not a crash', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(
          score: 0,
          totalQuestions: 0,
          answeredCount: 0,
          pointsAwarded: 0,
        ),
      );

      expect(find.text('0%'), findsOneWidget);
      expect(find.text('Skipped'), findsNothing);
    });

    testWidgets('leveledUp and newBadge parse but celebrate nothing', (
      tester,
    ) async {
      // The contract goes to the trouble of telling us; the frame has no state
      // to render for either. Flagged in DESIGN_ISSUES rather than invented.
      await openResult(
        tester,
        summary: quizSummary(leveledUp: true, newBadge: true),
      );

      expect(find.textContaining('Level up'), findsNothing);
      expect(find.textContaining('Badge'), findsNothing);
      expect(find.text('Quiz Complete!'), findsOneWidget);
    });
  });
}
