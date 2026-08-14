import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/quiz/models/quiz_summary.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
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
  }) async {
    final harness = await pumpQuizApp(tester, locale: locale, theme: theme);
    harness.router.push(
      '/quiz/quiz-1/result',
      extra: QuizResultArgs(summary: summary, scopeName: scopeName),
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

    // CONFLICT 3 / S14.
    testWidgets('Review Questions renders, disabled, with a coming-soon note', (
      tester,
    ) async {
      await openResult(tester, summary: quizSummary());

      final review = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Review Questions'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(review.onPressed, isNull);
      expect(find.text('Reviewing your answers is coming soon.'), findsWidgets);
    });

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

    // S3 — the threshold between levels is not in the contract.
    testWidgets('level progress is numbers, not a proportion', (tester) async {
      await openResult(
        tester,
        summary: quizSummary(level: 3, totalPoints: 1255),
      );

      expect(find.text('Level 3 · 1255 points'), findsOneWidget);
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
