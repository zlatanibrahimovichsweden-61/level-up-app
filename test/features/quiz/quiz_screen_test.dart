import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_colors.dart';
import 'package:level_up_app/core/theme/app_elevation.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/elevation/elevated_surface.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/quiz/models/explanation_result.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';
import 'package:level_up_app/features/quiz/widgets/limit_sheet.dart';
import 'package:level_up_app/features/quiz/widgets/question_option_tile.dart';
import 'package:mocktail/mocktail.dart';

import 'quiz_fixtures.dart';
import 'quiz_harness.dart';

void main() {
  /// Opens the taking screen on a 3-question quiz whose first question's
  /// correct option is `q1-opt0`.
  Future<QuizHarness> openQuiz(
    WidgetTester tester, {
    MockQuizRepository? quiz,
    String locale = 'en',
    ThemeData? theme,
    int questionCount = 3,
  }) async {
    final harness = await pumpQuizApp(
      tester,
      quiz: quiz,
      locale: locale,
      theme: theme,
    );
    harness.router.push(
      '/quiz/quiz-1',
      extra: quizFor(questionCount: questionCount),
    );
    await tester.pumpAndSettle();
    return harness;
  }

  void stubGrade(
    MockQuizRepository quiz, {
    bool correct = true,
    bool explanationAvailable = false,
  }) {
    when(
      () => quiz.submitAnswer(
        quizId: any(named: 'quizId'),
        questionId: any(named: 'questionId'),
        optionId: any(named: 'optionId'),
      ),
    ).thenAnswer(
      (_) async => answerResult(
        correct: correct,
        explanationAvailable: explanationAvailable,
      ),
    );
  }

  /// The taking screen is taller than the 800x600 test viewport once the AI
  /// panel or a retry row is on it, so anything below the fold has to be
  /// scrolled to before it can be tapped — exactly as a student would.
  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
  }

  OptionTileState stateOf(WidgetTester tester, String optionText) => tester
      .widget<QuestionOptionTile>(
        find.ancestor(
          of: find.text(optionText),
          matching: find.byType(QuestionOptionTile),
        ),
      )
      .state;

  group('rendering', () {
    testWidgets('shows the question, its options and the n/total counter', (
      tester,
    ) async {
      await openQuiz(tester);

      expect(find.text('Quiz'), findsOneWidget);
      expect(find.text('QUESTION 1'), findsOneWidget);
      expect(find.text('Question q1?'), findsOneWidget);
      expect(find.byType(QuestionOptionTile), findsNWidgets(4));
      expect(find.text('1/3'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders A/B/C/D badges, derived positionally', (tester) async {
      await openQuiz(tester);

      for (final letter in ['A', 'B', 'C', 'D']) {
        expect(find.text(letter), findsOneWidget);
      }
    });

    // CONFLICT 4 / S11: the field is parsed, the control is not drawn.
    testWidgets('renders NO favourite or share control', (tester) async {
      await openQuiz(tester);

      expect(find.byIcon(Icons.bookmark), findsNothing);
      expect(find.byIcon(Icons.bookmark_border), findsNothing);
      expect(find.byIcon(Icons.share), findsNothing);
    });

    // NON-NEGOTIABLE: no client-side points arithmetic, and nothing that looks
    // like a running score.
    testWidgets('shows no points figure anywhere during the quiz', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz);
      await openQuiz(tester, quiz: quiz);

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Point'), findsNothing);
      expect(find.textContaining('+1'), findsNothing);
    });
  });

  group('the per-question submit model', () {
    testWidgets('Confirm is disabled until an option is chosen', (
      tester,
    ) async {
      await openQuiz(tester);

      final before = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(before.onPressed, isNull);
    });

    testWidgets('selecting an option sends NOTHING and enables Confirm', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      await openQuiz(tester, quiz: quiz);

      await tester.tap(find.text('Option 2'));
      await tester.pump();

      // The whole reason this screen is per-question submit rather than a
      // client-graded form.
      verifyNever(
        () => quiz.submitAnswer(
          quizId: any(named: 'quizId'),
          questionId: any(named: 'questionId'),
          optionId: any(named: 'optionId'),
        ),
      );
      expect(stateOf(tester, 'Option 2'), OptionTileState.selected);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('correctOptionId is revealed ONLY after Confirm', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz, correct: false);
      await openQuiz(tester, quiz: quiz);

      await tester.tap(find.text('Option 2'));
      await tester.pump();

      // Nothing is marked correct yet — the app does not know which one is.
      expect(stateOf(tester, 'Option 0'), OptionTileState.idle);

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Now the server has said so: the student's choice is wrong, and the
      // correct one is revealed alongside it.
      expect(stateOf(tester, 'Option 2'), OptionTileState.incorrect);
      expect(stateOf(tester, 'Option 0'), OptionTileState.correct);
      expect(stateOf(tester, 'Option 1'), OptionTileState.idle);
    });

    testWidgets('an answered question cannot be re-answered', (tester) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz);
      await openQuiz(tester, quiz: quiz);

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Grading is committed server-side; tapping another option changes
      // nothing and sends nothing.
      await tester.tap(find.text('Option 3'));
      await tester.pumpAndSettle();

      expect(stateOf(tester, 'Option 3'), OptionTileState.idle);
      verify(
        () => quiz.submitAnswer(
          quizId: any(named: 'quizId'),
          questionId: any(named: 'questionId'),
          optionId: any(named: 'optionId'),
        ),
      ).called(1);
    });

    testWidgets('the primary action becomes Next once graded', (tester) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz);
      await openQuiz(tester, quiz: quiz);

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Next'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('QUESTION 2'), findsOneWidget);
      expect(find.text('2/3'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
    });
  });

  // MANDATED TEST 1 — a submit retry.
  group('submit retry (idempotency)', () {
    testWidgets(
      'retry re-sends the identical body, returns the ORIGINAL grade, '
      'and awards nothing twice',
      (tester) async {
        final quiz = MockQuizRepository();
        var calls = 0;
        when(
          () => quiz.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            optionId: any(named: 'optionId'),
          ),
        ).thenAnswer((_) async {
          calls++;
          if (calls == 1) throw const OfflineException();
          // The server replays the ORIGINAL grade. `pointsDelta` is 0 because
          // nothing new was awarded — the contract's own wording for a replay.
          return answerResult(correct: true, pointsDelta: 0);
        });

        await openQuiz(tester, quiz: quiz);
        await tester.tap(find.text('Option 0'));
        await tester.pump();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        // The failure keeps the session and the chosen option.
        expect(find.text('You are offline'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
        expect(find.text('Question q1?'), findsOneWidget);

        await tapVisible(tester, find.text('Retry'));
        await tester.pumpAndSettle();

        // The retry was NOT suppressed client-side: both calls reached the
        // repository with the identical (questionId, optionId).
        final captured = verify(
          () => quiz.submitAnswer(
            quizId: 'quiz-1',
            questionId: 'q1',
            optionId: captureAny(named: 'optionId'),
          ),
        ).captured;
        expect(captured, ['q1-opt0', 'q1-opt0']);

        // The original grade is what renders.
        expect(stateOf(tester, 'Option 0'), OptionTileState.correct);
        // And no points figure was accumulated or shown anywhere.
        expect(find.textContaining('Point'), findsNothing);
      },
    );

    testWidgets('a mid-quiz 403 limit opens the same paywall sheet', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.submitAnswer(
          quizId: any(named: 'quizId'),
          questionId: any(named: 'questionId'),
          optionId: any(named: 'optionId'),
        ),
      ).thenThrow(
        const ApiException(status: 403, code: 'weekly_question_limit_reached'),
      );

      await openQuiz(tester, quiz: quiz);
      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.byType(LimitSheet), findsOneWidget);
    });

    // adr-114. `suppressesRetry` is unit-tested in
    // `test/core/network/account_pending_deletion_test.dart`; this is the
    // WIRING, which that test cannot see — the retry row must render its
    // message without its button. Unwire `suppressesRetry` in
    // `quiz_screen.dart` and this goes red; the pure-function test does not.
    testWidgets(
      'a mid-quiz account_pending_deletion shows the copy and NO Retry',
      (tester) async {
        final quiz = MockQuizRepository();
        when(
          () => quiz.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            optionId: any(named: 'optionId'),
          ),
        ).thenThrow(
          const ApiException(status: 403, code: 'account_pending_deletion'),
        );

        await openQuiz(tester, quiz: quiz);
        await tester.tap(find.text('Option 0'));
        await tester.pump();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        // Withheld affordance, not withheld explanation: the student still has
        // to be told why the answer did not go through.
        expect(
          find.text(
            'Your account is scheduled for deletion. Cancel the request to '
            'use Level Up again.',
          ),
          findsOneWidget,
        );
        expect(find.text('Retry'), findsNothing);

        // Not mistaken for the two 403s that open the paywall instead.
        expect(find.byType(LimitSheet), findsNothing);

        // The session survives — nothing logged the student out or unwound the
        // quiz.
        expect(find.text('Question q1?'), findsOneWidget);
      },
    );
  });

  group('AI explanation', () {
    testWidgets('is not offered when the server says there is none', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz, explanationAvailable: false);
      await openQuiz(tester, quiz: quiz);

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('AI EXPLANATION'), findsNothing);
      verifyNever(() => quiz.getExplanation(any()));
    });

    testWidgets('202 → poll → 200 renders the text, in ONE section', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz, explanationAvailable: true);
      var calls = 0;
      when(() => quiz.getExplanation(any())).thenAnswer((_) async {
        calls++;
        return calls == 1
            ? const ExplanationGenerating()
            : const ExplanationReady('Mitochondria make ATP.');
      });

      await openQuiz(tester, quiz: quiz);
      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('AI EXPLANATION'), findsOneWidget);
      await tapVisible(tester, find.text('Show explanation'));
      await tester.pump();

      expect(find.text('Generating your explanation…'), findsOneWidget);

      // The contract's suggested 2s backoff, elapsed.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Mitochondria make ATP.'), findsOneWidget);
      // One section: the contract returns a single `text`, so the frame's two
      // sub-headings are not drawn.
      expect(find.text('WHY IS THIS WRONG?'), findsNothing);
      expect(find.text('WHY IS THE CORRECT ANSWER RIGHT?'), findsNothing);
    });

    testWidgets('a 403 reads as "not available", never as a broken quiz', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz, explanationAvailable: true);
      when(
        () => quiz.getExplanation(any()),
      ).thenThrow(const ApiException(status: 403, code: 'insufficient_scope'));

      await openQuiz(tester, quiz: quiz);
      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.text('Show explanation'));
      await tester.pumpAndSettle();

      expect(
        find.text('No explanation is available for this question.'),
        findsOneWidget,
      );
      // The quiz itself is untouched — Next is still there.
      expect(find.text('Next'), findsOneWidget);
    });
  });

  group('finishing', () {
    testWidgets('the last question offers Finish and lands on the result', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz);
      when(() => quiz.finishQuiz(any())).thenAnswer(
        (_) async => quizSummary(
          score: 1,
          totalQuestions: 1,
          answeredCount: 1,
          pointsAwarded: 1,
        ),
      );

      await openQuiz(tester, quiz: quiz, questionCount: 1);
      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Finish'), findsOneWidget);
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizResultScreen), findsOneWidget);
      verify(() => quiz.finishQuiz('quiz-1')).called(1);
    });

    testWidgets('finishing invalidates /me so Home shows the new points', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz);
      when(() => quiz.finishQuiz(any())).thenAnswer(
        (_) async => quizSummary(
          score: 1,
          totalQuestions: 1,
          answeredCount: 1,
          pointsAwarded: 1,
        ),
      );

      final harness = await openQuiz(tester, quiz: quiz, questionCount: 1);
      // Warm the profile so there is something to invalidate. `verify` also
      // CLEARS the recorded calls, so everything counted below is new.
      await harness.container.read(meProvider.future);
      verify(() => harness.profile.getMe()).called(1);

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Re-reading the provider now hits the repository again: the student's
      // points and level changed server-side, so the app refetches rather than
      // patching a local value.
      await harness.container.read(meProvider.future);
      verify(() => harness.profile.getMe()).called(1);
    });
  });

  // NON-NEGOTIABLE 9 — verified, not assumed.
  group('screenshot protection', () {
    testWidgets('is ON when the quiz screen mounts', (tester) async {
      final harness = await openQuiz(tester);

      expect(harness.protection.enableCalls, 1);
      expect(harness.protection.disableCalls, 0);
    });

    testWidgets('is OFF again when the quiz screen is disposed', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      stubGrade(quiz);
      when(() => quiz.finishQuiz(any())).thenAnswer(
        (_) async => quizSummary(
          score: 1,
          totalQuestions: 1,
          answeredCount: 1,
          pointsAwarded: 1,
        ),
      );

      final harness = await openQuiz(tester, quiz: quiz, questionCount: 1);
      expect(harness.protection.enableCalls, 1);

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Leaving for the result screen tears the quiz screen down, so the rest
      // of the app does not inherit FLAG_SECURE.
      expect(harness.protection.disableCalls, 1);
    });
  });

  group('exit guard', () {
    testWidgets('closing asks first — progress cannot be lost silently', (
      tester,
    ) async {
      await openQuiz(tester);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Leave this quiz?'), findsOneWidget);
      expect(find.text('Keep going'), findsOneWidget);

      await tester.tap(find.text('Keep going'));
      await tester.pumpAndSettle();

      // Still in the quiz.
      expect(find.byType(QuizScreen), findsOneWidget);
    });
  });

  group('states matrix', () {
    testWidgets('Arabic (RTL)', (tester) async {
      await openQuiz(tester, locale: 'ar');

      expect(find.text('الاختبار'), findsOneWidget);
      expect(find.text('تأكيد'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('تأكيد'))),
        TextDirection.rtl,
      );
    });

    testWidgets('dark theme', (tester) async {
      await openQuiz(tester, theme: AppTheme.dark);

      expect(find.byType(QuestionOptionTile), findsNWidgets(4));
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets(
      'an offline submit shows offline copy and a user-tapped retry',
      (tester) async {
        final quiz = MockQuizRepository();
        when(
          () => quiz.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            optionId: any(named: 'optionId'),
          ),
        ).thenThrow(const OfflineException());

        await openQuiz(tester, quiz: quiz, locale: 'ar');
        await tester.tap(find.text('Option 0'));
        await tester.pump();
        await tester.tap(find.text('تأكيد'));
        await tester.pumpAndSettle();

        expect(find.text('أنت غير متصل بالإنترنت'), findsOneWidget);
        expect(find.text('إعادة المحاولة'), findsOneWidget);
      },
    );
  });

  // ---------------------------------------------------------------- #46 -----
  group('the previous-question pill', () {
    /// Grades question 1 and advances, which is the only way the pill mounts.
    Future<QuizHarness> openOnQuestionTwo(
      WidgetTester tester, {
      MockQuizRepository? quiz,
      String locale = 'en',
      ThemeData? theme,
    }) async {
      final repo = quiz ?? MockQuizRepository();
      stubGrade(repo);
      final harness = await openQuiz(
        tester,
        quiz: repo,
        locale: locale,
        theme: theme,
      );

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      return harness;
    }

    ElevatedSurface pill(WidgetTester tester) => tester.widget<ElevatedSurface>(
      find.ancestor(
        of: find.byType(SvgPicture),
        matching: find.byType(ElevatedSurface),
      ),
    );

    testWidgets('does not exist on question 1', (tester) async {
      await openQuiz(tester);

      expect(find.byType(ElevatedSurface), findsNothing);
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('is a 79 x 58 pill once past question 1', (tester) async {
      await openOnQuestionTwo(tester);

      expect(find.text('QUESTION 2'), findsOneWidget);
      // The M3 tonal icon button it replaced was roughly 40 dp round.
      expect(pill(tester).width, 79);
      expect(pill(tester).height, 58);
    });

    testWidgets('takes its radius from the canvas — 9 light, 10 dark', (
      tester,
    ) async {
      // The NUMBERS, not "whatever the token says". Comparing the widget
      // to the token it just read cannot fail; these are the two values
      // read off `159:1920` and `337:6464`, and the point of the token is
      // that they differ.
      double radiusOf(WidgetTester t) =>
          ((pill(t).shape as RoundedRectangleBorder).borderRadius.resolve(
            TextDirection.ltr,
          )).topLeft.x;

      await openOnQuestionTwo(tester);
      expect(radiusOf(tester), 9);

      await openOnQuestionTwo(tester, theme: AppTheme.dark);
      expect(radiusOf(tester), 10);
    });

    testWidgets('light carries the small black shadow and no Glass', (
      tester,
    ) async {
      await openOnQuestionTwo(tester);

      final e = AppTheme.light.extension<AppElevation>()!;
      expect(pill(tester).shadows, e.quizPrevButtonShadows);
      expect(pill(tester).shadows, isNotEmpty);
      expect(pill(tester).glass, isNull);
      expect(
        pill(tester).color,
        AppTheme.light.extension<AppColors>()!.quizPrevButtonFill,
      );
    });

    testWidgets(
      'dark carries G13 and NO shadow — the empty list is a reading',
      (tester) async {
        await openOnQuestionTwo(tester, theme: AppTheme.dark);

        final e = AppTheme.dark.extension<AppElevation>()!;
        expect(pill(tester).glass, e.quizPrevButtonGlass);
        expect(pill(tester).glass, isNotNull);
        expect(pill(tester).shadows, isEmpty);
      },
    );

    testWidgets('tapping it dispatches PreviousQuestionRequested', (
      tester,
    ) async {
      await openOnQuestionTwo(tester);

      await tester.tap(find.byType(SvgPicture));
      await tester.pumpAndSettle();

      // The Bloc is untouched by this wave; this proves the wiring survived
      // the control being rebuilt.
      expect(find.text('QUESTION 1'), findsOneWidget);
    });

    testWidgets('it announces itself as PREVIOUS, not as back', (tester) async {
      final handle = tester.ensureSemantics();
      await openOnQuestionTwo(tester);

      // This screen already has a control that means "back": the ✕ that
      // LEAVES the quiz. Two buttons announced "Back", one of which
      // discards the attempt, is the regression this pins.
      expect(find.bySemanticsLabel('Previous page'), findsOneWidget);
      expect(find.bySemanticsLabel('Back'), findsNothing);
      handle.dispose();
    });

    testWidgets('the chevron is mirrored in LTR and left alone in RTL', (
      tester,
    ) async {
      await openOnQuestionTwo(tester);
      final ltr = tester.widget<Transform>(
        find
            .ancestor(
              of: find.byType(SvgPicture),
              matching: find.byType(Transform),
            )
            .first,
      );

      await openOnQuestionTwo(tester, locale: 'ar');
      final rtl = tester.widget<Transform>(
        find
            .ancestor(
              of: find.byType(SvgPicture),
              matching: find.byType(Transform),
            )
            .first,
      );

      // The shared asset points RIGHT, so "back" is its flip in LTR and
      // its UNflipped self in RTL - the same rule CircleBackButton
      // follows. Asserting only that the two differ would pass on an
      // inverted mirror, which is the bug worth catching, so both are
      // pinned by value: x-scale -1 in LTR, +1 in RTL.
      expect(ltr.transform.storage[0], -1.0);
      expect(rtl.transform.storage[0], 1.0);
    });

    testWidgets('it sits 15 dp from the primary CTA', (tester) async {
      await openOnQuestionTwo(tester);

      final pillRect = tester.getRect(
        find.ancestor(
          of: find.byType(SvgPicture),
          matching: find.byType(ElevatedSurface),
        ),
      );
      final ctaRect = tester.getRect(find.byType(FilledButton));
      // Figma: the pill ends at x 99 and the CTA starts at 114.
      expect(ctaRect.left - pillRect.right, closeTo(15, 0.01));
    });
  });

  // -------------------------------------------------------------- 7.10a -----
  group('the quiz CTAs wear the primary treatment', () {
    testWidgets('Confirm is wrapped, and its enabled state follows the Bloc', (
      tester,
    ) async {
      await openQuiz(tester);

      PrimaryCta cta() => tester.widget<PrimaryCta>(
        find.ancestor(
          of: find.byType(FilledButton),
          matching: find.byType(PrimaryCta),
        ),
      );

      expect(cta().tone, CtaTone.primary);
      // Nothing selected yet, so the Bloc says no.
      expect(cta().enabled, isFalse);

      await tester.tap(find.text('Option 0'));
      await tester.pump();
      expect(cta().enabled, isTrue);
    });

    testWidgets('the error-state Retry stays unwrapped (DESIGN_ISSUES #76)', (
      tester,
    ) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.submitAnswer(
          quizId: any(named: 'quizId'),
          questionId: any(named: 'questionId'),
          optionId: any(named: 'optionId'),
        ),
      ).thenThrow(const OfflineException());

      await openQuiz(tester, quiz: quiz);
      await tester.tap(find.text('Option 0'));
      await tester.pump();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      // Exactly one CTA on the screen: the primary. The retry affordance has
      // no Figma frame and deliberately carries no treatment.
      expect(find.byType(PrimaryCta), findsOneWidget);
    });
  });

  // --------------------------------------------------------------- 7.10 -----
  group('the exit dialog', () {
    testWidgets('it wears the app dialog scrim rather than Material\'s '
        'barrier', (tester) async {
      await openQuiz(tester);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Leave this quiz?'), findsOneWidget);

      final scrim = AppTheme.light.extension<AppElevation>()!.logoutDialogScrim;
      expect(scrim, isNotNull);
      final route = ModalRoute.of(
        tester.element(find.text('Leave this quiz?')),
      )!;
      expect(route.barrierColor, scrim!.color);
    });
  });
}
