import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
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

  /// The result screen is taller than the 800x600 test viewport, so the
  /// bottom CTA has to be scrolled to before it can be tapped - exactly as a
  /// student would. Same helper, same reason, as `quiz_screen_test.dart`.
  ///
  /// It became necessary on 2026-09-20: the 33 dp star disc and the
  /// `TitledChrome` header together pushed "Review Questions" from y 559-619
  /// to y 570-630, so its CENTRE landed exactly on the viewport edge. On a
  /// 375 x 812 phone the whole screen still fits without scrolling.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
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

      await tapVisible(tester, cta);

      expect(find.byType(QuizReviewScreen), findsOneWidget);
      expect(harness.router.state.uri.path, '/quiz/quiz-1/result/review');
    });

    testWidgets('review is pushed, so Back returns to the result', (
      tester,
    ) async {
      await openResult(tester, summary: quizSummary());

      await tapVisible(
        tester,
        find.widgetWithText(FilledButton, 'Review Questions'),
      );
      expect(find.byType(QuizReviewScreen), findsOneWidget);

      // The back chip, not a Material arrow: all three screens in this flow
      // moved onto the shared `TitledChrome` header on 2026-09-20
      // (owner ruling, DESIGN_ISSUES #82).
      await tester.tap(find.byType(CircleBackButton));
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

      await tester.tap(find.byType(CircleBackButton));
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

  // ------------------------------------------------------------ #15 / #16 ---
  group('the result cards are raised, not outlined', () {
    List<ElevatedSurface> surfaces(WidgetTester tester) => tester
        .widgetList<ElevatedSurface>(find.byType(ElevatedSurface))
        .toList();

    ElevatedSurface bucket(WidgetTester tester, String label) =>
        tester.widget<ElevatedSurface>(
          find
              .ancestor(
                of: find.text(label),
                matching: find.byType(ElevatedSurface),
              )
              .first,
        );

    testWidgets('light: every bucket has a shadow and no hairline', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      final e = AppTheme.light.extension<AppElevation>()!;
      for (final label in ['Correct', 'Wrong']) {
        final b = bucket(tester, label);
        expect(b.side, isNull, reason: label);
        expect(b.shadows, e.resultBucketShadows, reason: label);
        expect(b.shadows, isNotEmpty, reason: label);
        expect(b.glass, isNull, reason: label);
      }
    });

    testWidgets('dark: every bucket has Glass and NO shadow', (tester) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
        theme: AppTheme.dark,
      );

      final e = AppTheme.dark.extension<AppElevation>()!;
      for (final label in ['Correct', 'Wrong']) {
        final b = bucket(tester, label);
        // `337:6667` carries no shadow at all. The empty list is a reading.
        expect(b.shadows, isEmpty, reason: label);
        expect(b.glass, e.resultBucketGlass, reason: label);
        expect(b.glass, isNotNull, reason: label);
      }
    });

    testWidgets('the Skipped bucket takes the same treatment, and only '
        'appears when the quiz ended early', (tester) async {
      // 10 questions, 8 answered, 5 correct.
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 8, totalQuestions: 10),
      );
      final skipped = bucket(tester, 'Skipped');
      expect(
        skipped.shadows,
        AppTheme.light.extension<AppElevation>()!.resultBucketShadows,
      );
      expect(skipped.side, isNull);

      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );
      expect(find.text('Skipped'), findsNothing);
    });

    testWidgets('the rewards card is radius 15 and carries the star disc', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      final card = tester.widget<ElevatedSurface>(
        find
            .ancestor(
              of: find.text('REWARDS EARNED'),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );
      final radius = (card.shape as RoundedRectangleBorder).borderRadius
          .resolve(TextDirection.ltr);
      // 15, not the 16 every other card on this screen uses. It is read.
      expect(radius.topLeft.x, 15);
      expect(card.side, isNull);

      final disc = tester.widget<ElevatedSurface>(
        find
            .ancestor(
              of: find.byIcon(Icons.star),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );
      expect(disc.shape, isA<CircleBorder>());
      expect(disc.width, 33);
      expect(disc.height, 33);
      expect(
        disc.color,
        AppTheme.light.extension<AppColors>()!.resultStarDiscFill,
      );
    });

    testWidgets('dark: the rewards card takes G14 and the lavender '
        'back-light', (tester) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
        theme: AppTheme.dark,
      );

      final e = AppTheme.dark.extension<AppElevation>()!;
      final card = tester.widget<ElevatedSurface>(
        find
            .ancestor(
              of: find.text('REWARDS EARNED'),
              matching: find.byType(ElevatedSurface),
            )
            .first,
      );

      expect(card.glass, e.rewardsCardGlass);
      expect(card.backlights, [e.rewardsCardBacklight]);
      expect(card.shadows, isEmpty);
      // Every back-light in the file needs a frost to be seen through (R6).
      for (final s in surfaces(tester)) {
        if (s.backlights.isNotEmpty) expect(s.glass, isNotNull);
      }
    });

    testWidgets('the rewards row survives a large text scale without a hard '
        'overflow', (tester) async {
      // The 33 dp star disc replaced a 22 dp glyph, which cost the points
      // label 11 dp on a row that was ALREADY overflowing by 11 px at text
      // scale 1.3 - Android's largest standard font setting. Measured at
      // 375 x 812: 11 px before this wave, 22 px after it, 0 px once the label
      // became `Flexible`.
      //
      // Scales past 1.3 are here because RESPONSIVE.md tests at 1.3 and the
      // failure mode is a cliff, not a slope: it either wraps or it clips.
      await tester.binding.setSurfaceSize(const Size(375, 812));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      for (final scale in [1.0, 1.3, 2.0, 3.0]) {
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) =>
            errors.add(details.exceptionAsString());

        await openResult(tester, summary: quizSummary(pointsAwarded: 200));
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        await tester.pumpAndSettle();

        FlutterError.onError = previous;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        expect(
          errors.where((e) => e.contains('overflow')),
          isEmpty,
          reason: 'text scale $scale overflowed',
        );
      }
    });

    testWidgets('D-006 still holds — no level, no points total, no meter', (
      tester,
    ) async {
      // The frame draws a Level Progress meter inside the very card this wave
      // rebuilt. Restyling a card is not a licence to put it back.
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      expect(find.textContaining('Level'), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });

  // -------------------------------------------------------------- 7.10a -----
  group('the Review Questions CTA wears the primary treatment', () {
    testWidgets('it is wrapped, and nothing else on the screen is', (
      tester,
    ) async {
      await openResult(
        tester,
        summary: quizSummary(score: 5, answeredCount: 10, totalQuestions: 10),
      );

      final cta = tester.widget<PrimaryCta>(
        find.ancestor(
          of: find.widgetWithText(FilledButton, 'Review Questions'),
          matching: find.byType(PrimaryCta),
        ),
      );
      expect(cta.tone, CtaTone.primary);
      // The secondary "Back to Learn" is a TextButton with no frame, so it
      // stays bare — one treatment per screen.
      expect(find.byType(PrimaryCta), findsOneWidget);
    });
  });
}
