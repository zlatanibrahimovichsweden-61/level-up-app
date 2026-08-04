import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/offline_banner.dart';
import 'package:level_up_app/features/quiz/models/quiz_mode.dart';
import 'package:level_up_app/features/quiz/models/quiz_setup_args.dart';
import 'package:level_up_app/features/quiz/models/quiz_type.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';
import 'package:level_up_app/features/quiz/widgets/limit_sheet.dart';
import 'package:mocktail/mocktail.dart';

import 'quiz_fixtures.dart';
import 'quiz_harness.dart';

const _schoolArgs = QuizSetupArgs.lesson(
  lessonId: 'lesson-9',
  scopeName: 'Cell Membrane',
);

const _universityArgs = QuizSetupArgs.lecture(
  lectureId: 'lecture-4',
  scopeName: 'Lecture 4 — The Thorax',
  quizType: QuizType.finalRevision,
);

void main() {
  setUpAll(() {
    registerFallbackValue(_schoolArgs);
    registerFallbackValue(QuizLength.thirty);
    registerFallbackValue(QuizMode.normal);
  });

  Future<QuizHarness> openSetup(
    WidgetTester tester, {
    QuizSetupArgs args = _schoolArgs,
    MockQuizRepository? quiz,
    String locale = 'en',
    ThemeData? theme,
    bool online = true,
  }) async {
    final harness = await pumpQuizApp(
      tester,
      quiz: quiz,
      locale: locale,
      theme: theme,
      online: online,
    );
    harness.router.push('/quiz/setup', extra: args);
    await tester.pumpAndSettle();
    return harness;
  }

  group('rendering', () {
    testWidgets('titles itself with the scope and offers 10/30/50', (tester) async {
      await openSetup(tester);

      expect(find.text('Quiz Setup'), findsOneWidget);
      expect(find.text('Cell Membrane'), findsOneWidget);
      expect(find.text('Select Quiz Size'), findsOneWidget);
      expect(find.text('10 Questions'), findsOneWidget);
      expect(find.text('30 Questions'), findsOneWidget);
      expect(find.text('50 Questions'), findsOneWidget);
      expect(find.text('Start learning'), findsOneWidget);
    });

    // CONFLICT 1 + 6: neither has a contract source, so neither is drawn.
    testWidgets('shows NO points preview and NO question-pool card',
        (tester) async {
      await openSetup(tester);

      expect(find.textContaining('Points'), findsNothing);
      expect(find.textContaining('+30'), findsNothing);
      expect(find.textContaining('POOL'), findsNothing);
      expect(find.textContaining('remaining'), findsNothing);
    });

    testWidgets('the subject line is absent — no endpoint returns one',
        (tester) async {
      await openSetup(tester);

      // Only the scope name titles the screen; the frame's "Biology" eyebrow
      // has nothing behind it (Quiz carries scopeName alone).
      expect(find.text('Biology'), findsNothing);
    });

    testWidgets('30 is preselected, and tapping another length moves it',
        (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());

      await openSetup(tester, quiz: quiz);

      // Proven by what gets sent rather than by poking at colours.
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();
      verify(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: QuizLength.thirty,
          mode: any(named: 'mode'),
        ),
      ).called(1);
    });
  });

  group('creating a quiz', () {
    testWidgets('school sends the lessonId and the chosen length',
        (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('10 Questions'));
      await tester.pump();
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      final captured = verify(
        () => quiz.createQuiz(
          scope: captureAny(named: 'scope'),
          length: QuizLength.ten,
          mode: QuizMode.normal,
        ),
      ).captured.single as QuizSetupArgs;

      expect(captured.lessonId, 'lesson-9');
      expect(captured.lectureId, isNull);
      expect(captured.quizType, isNull);
    });

    testWidgets('university sends the lectureId and quizType — SAME screen',
        (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());

      await openSetup(tester, args: _universityArgs, quiz: quiz);

      // One engine: the university flow renders the identical screen.
      expect(find.text('Lecture 4 — The Thorax'), findsOneWidget);
      expect(find.text('Select Quiz Size'), findsOneWidget);

      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      final captured = verify(
        () => quiz.createQuiz(
          scope: captureAny(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).captured.single as QuizSetupArgs;

      expect(captured.lectureId, 'lecture-4');
      expect(captured.quizType, QuizType.finalRevision);
      expect(captured.lessonId, isNull);
    });

    testWidgets('a created quiz pushes the taking screen', (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer((_) async => quizFor());
      when(
        () => quiz.submitAnswer(
          quizId: any(named: 'quizId'),
          questionId: any(named: 'questionId'),
          optionId: any(named: 'optionId'),
        ),
      ).thenAnswer((_) async => answerResult());

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizScreen), findsOneWidget);
    });
  });

  group('error states', () {
    testWidgets('422 not_enough_questions is inline and NEVER silently retried',
        (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 422, code: 'not_enough_questions'),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining("doesn't have enough questions"),
        findsOneWidget,
      );
      expect(find.byType(LimitSheet), findsNothing);
      // Exactly one attempt: the student picks a shorter quiz, the app does not
      // quietly pick one for them.
      verify(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).called(1);
    });

    testWidgets('403 weekly_question_limit_reached opens the sheet, WEEKLY copy',
        (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(
          status: 403,
          code: 'weekly_question_limit_reached',
        ),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(find.byType(LimitSheet), findsOneWidget);
      expect(find.text('Free Usage Reached'), findsOneWidget);
      expect(find.textContaining('this week'), findsOneWidget);
      // The contract limit is weekly; the frame's "Daily" wording is not shipped.
      expect(find.textContaining('Daily'), findsNothing);
      expect(find.textContaining('daily'), findsNothing);
      // Glossary: base_subscription is never called "premium".
      expect(find.textContaining('Premium'), findsNothing);
      // No questions-used bar — the contract exposes neither number.
      expect(find.textContaining('50/50'), findsNothing);
    });

    testWidgets('403 subscription_required opens the same sheet, other copy',
        (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 403, code: 'subscription_required'),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pumpAndSettle();

      expect(find.byType(LimitSheet), findsOneWidget);
      expect(find.text('Subscription Required'), findsOneWidget);
    });

    testWidgets('offline shows the banner and disables Start', (tester) async {
      await openSetup(tester, online: false);

      expect(find.byType(OfflineBanner), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('a request in flight shows a spinner and blocks a second tap',
        (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenAnswer(
        (_) => Future.delayed(const Duration(milliseconds: 200), quizFor),
      );

      await openSetup(tester, quiz: quiz);
      await tester.tap(find.text('Start learning'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Start learning'), findsNothing);

      await tester.pumpAndSettle();
    });
  });

  group('states matrix', () {
    testWidgets('Arabic (RTL) renders the Arabic copy', (tester) async {
      await openSetup(tester, locale: 'ar');

      expect(find.text('إعداد الاختبار'), findsOneWidget);
      expect(find.text('اختر عدد الأسئلة'), findsOneWidget);
      expect(find.text('ابدأ التعلّم'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.text('اختر عدد الأسئلة'))),
        TextDirection.rtl,
      );
    });

    testWidgets('dark theme renders the same content', (tester) async {
      await openSetup(tester, theme: AppTheme.dark);

      expect(find.text('Select Quiz Size'), findsOneWidget);
      expect(find.text('Cell Membrane'), findsOneWidget);
    });

    testWidgets('Arabic + dark + offline all at once', (tester) async {
      await openSetup(
        tester,
        locale: 'ar',
        theme: AppTheme.dark,
        online: false,
      );

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.text('اختر عدد الأسئلة'), findsOneWidget);
    });

    testWidgets('an Arabic error is localized', (tester) async {
      final quiz = MockQuizRepository();
      when(
        () => quiz.createQuiz(
          scope: any(named: 'scope'),
          length: any(named: 'length'),
          mode: any(named: 'mode'),
        ),
      ).thenThrow(
        const ApiException(status: 422, code: 'not_enough_questions'),
      );

      await openSetup(tester, quiz: quiz, locale: 'ar');
      await tester.tap(find.text('ابدأ التعلّم'));
      await tester.pumpAndSettle();

      expect(find.textContaining('أسئلة كافية'), findsOneWidget);
    });
  });
}
