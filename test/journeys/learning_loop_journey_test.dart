import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/features/catalog/screens/chapters_screen.dart';
import 'package:level_up_app/features/catalog/screens/lessons_screen.dart';
import 'package:level_up_app/features/catalog/screens/subject_tree_screen.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_review_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_screen.dart';

import 'journey_harness.dart';

/// Journey 2: the learning loop.
///
/// Home -> Learn -> subject -> unit -> chapter -> lesson -> quiz setup ->
/// start -> answer ten questions -> finish -> result -> review -> back to
/// Learn, and then Home shows what the SERVER awarded.
///
/// School track (the mock's `000000` session). The quiz is the Bloc-driven
/// engine, so this is also the one place the Riverpod shell, the router and
/// the Bloc session are exercised together.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('learning loop in $locale', (tester) async {
      await walkLearningLoop(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('learning loop in the dark canvas in $locale', (tester) async {
      await walkLearningLoop(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('learning loop at 2.0x text in $locale', (tester) async {
      await walkLearningLoop(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownLoopOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownLoopOverflowsAtTwoTimes = <String>{};

/// How many of the ten questions the journey answers CORRECTLY. The mock
/// rotates the correct option per question ([correctOptionNumber]); the
/// journey knows the rule only to be able to pick a right and a wrong answer,
/// and then asserts that the SERVER's tally is what the screens show.
const _correctAnswers = 6;
const _quizLength = 10;

/// The 1-based option number the mock grades correct for question [i]
/// (`lib/dev/mock_backend.dart`, `_MockQuiz.build`: correct index = i % 4).
int correctOptionNumber(int i) => i % 4 + 1;

/// A different option number than [correctOptionNumber].
int wrongOptionNumber(int i) => correctOptionNumber(i) % 4 + 1;

Future<void> walkLearningLoop(
  WidgetTester tester, {
  required String locale,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await bootJourney(
    tester,
    locale: locale,
    signedIn: true,
    theme: theme,
    textScale: textScale,
    size: size,
  );
  final label =
      'learning-loop $locale/${theme.name}/${textScale}x '
      '${size.width.toInt()}';

  // --- Home (a returning student lands here) -------------------------------
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home');
  expect(
    find.text(l.pointsValue(mockStartingPoints)),
    findsWidgets,
    reason: 'Home shows the total the server returned',
  );
  final profileFetchesBefore = j.requests.count('GET', '/me');
  expect(
    profileFetchesBefore,
    1,
    reason: '/me is fetched once, not per widget',
  );

  // --- Learn tab -> Subjects ----------------------------------------------
  await tapOn(tester, find.text(l.navLearn).last);
  expect(j.location, '/learn');
  await pumpUntil(tester, find.byType(SubjectsScreen), journey: j);
  await pumpUntil(tester, find.text('الأحياء'), journey: j);
  expect(
    find.byType(CircleBackButton),
    findsNothing,
    reason: 'a tab root has nothing to go back to, so it draws no back chip',
  );
  expect(j.requests.count('GET', '/catalog/subjects'), 1);

  // --- Subject -> Units (the ONE tree fetch) -------------------------------
  await tapOn(tester, find.text('الأحياء'));
  await pumpUntil(tester, find.byType(SubjectTreeScreen), journey: j);
  await pumpUntil(tester, find.text('الوحدة الأولى'), journey: j);
  expect(j.location, '/learn/subject/sub-bio');
  expect(j.requests.count('GET', '/catalog/subjects/sub-bio/tree'), 1);

  // --- Unit -> Chapters (a view over the cached tree: no new request) ------
  await tapOn(tester, find.text('الوحدة الأولى'));
  await pumpUntil(tester, find.byType(ChaptersScreen), journey: j);
  expect(j.location, '/learn/subject/sub-bio/unit/bio-u1');
  expect(j.requests.count('GET', '/catalog/subjects/sub-bio/tree'), 1);

  // --- Chapter -> Lessons --------------------------------------------------
  await tapOn(tester, find.text('الفصل الأول'));
  await pumpUntil(tester, find.byType(LessonsScreen), journey: j);
  expect(j.location, '/learn/subject/sub-bio/unit/bio-u1/chapter/bio-u1-c1');
  expect(j.requests.count('GET', '/catalog/subjects/sub-bio/tree'), 1);

  // --- Lesson -> Quiz setup ------------------------------------------------
  await tapOn(tester, find.text('الدرس الثاني'));
  await pumpUntil(tester, find.byType(QuizSetupScreen), journey: j);
  expect(j.location, '/quiz/setup');
  // The scope header names the lesson, with the subject over it.
  expect(find.text('الدرس الثاني'), findsOneWidget);
  expect(find.text('الأحياء'), findsOneWidget);
  expect(j.requests.countPrefix('/quizzes'), 0, reason: 'nothing created yet');

  // --- Pick 10 questions and start -----------------------------------------
  await tapOn(tester, find.text(l.quizSizeOption(_quizLength)));
  await tapOn(tester, find.text(l.startLearning));
  await pumpUntil(tester, find.byType(QuizScreen), journey: j);
  expect(j.location, '/quiz/quiz-1');
  expect(j.requests.count('POST', '/quizzes'), 1);
  expect(
    j.protection.enableCalls,
    1,
    reason: 'screenshot protection goes on with the quiz',
  );
  expect(j.protection.disableCalls, 0);

  // --- Answer all ten ------------------------------------------------------
  for (var i = 1; i <= _quizLength; i++) {
    await pumpUntil(tester, find.text(l.questionLabel(i)), journey: j);
    expect(find.text(l.quizProgress(i, _quizLength)), findsOneWidget);

    final number = i <= _correctAnswers
        ? correctOptionNumber(i)
        : wrongOptionNumber(i);
    await tapOn(tester, find.text('الخيار رقم $number للسؤال $i'));
    // Choosing an option sends NOTHING: only Confirm submits.
    expect(j.requests.count('POST', '/quizzes/quiz-1/answers'), i - 1);

    await tapOn(tester, find.text(l.confirm));
    await pumpUntil(
      tester,
      find.text(i == _quizLength ? l.finishQuiz : l.next),
      journey: j,
    );
    expect(j.requests.count('POST', '/quizzes/quiz-1/answers'), i);

    if (i < _quizLength) {
      await tapOn(tester, find.text(l.next));
    }
  }
  expect(j.requests.count('POST', '/quizzes/quiz-1/finish'), 0);

  // --- Finish -> Result ----------------------------------------------------
  await tapOn(tester, find.text(l.finishQuiz));
  await pumpUntil(tester, find.byType(QuizResultScreen), journey: j);
  expect(j.location, '/quiz/quiz-1/result');
  expect(j.requests.count('POST', '/quizzes/quiz-1/finish'), 1);
  expect(
    find.byType(QuizScreen),
    findsNothing,
    reason: 'the finished quiz is REPLACED by its result, not left beneath it',
  );
  expect(j.protection.disableCalls, greaterThanOrEqualTo(1));
  // The server's tally: six right, four wrong, six points.
  expect(find.text(l.quizCompleteTitle), findsOneWidget);
  expect(find.text('$_correctAnswers'), findsWidgets);
  expect(find.text('${_quizLength - _correctAnswers}'), findsWidgets);
  expect(find.text(l.pointsAwardedValue(_correctAnswers)), findsOneWidget);
  // Finishing invalidated /me: Home refetched it, and the points are the
  // server's new total - the device added nothing.
  await settle(tester);
  expect(j.requests.count('GET', '/me'), profileFetchesBefore + 1);

  // --- Review --------------------------------------------------------------
  await tapOn(tester, find.text(l.reviewQuestions));
  await pumpUntil(tester, find.byType(QuizReviewScreen), journey: j);
  expect(j.location, '/quiz/quiz-1/result/review');
  expect(find.text(l.quizReviewFilterAll(_quizLength)), findsOneWidget);
  // Reviewing the quiz just finished needs no endpoint.
  expect(j.requests.count('GET', '/quizzes/quiz-1'), 0);
  expect(j.protection.enableCalls, 2);

  // Back from the review pops to the result ...
  await tapBackChip(tester, key: const Key('quiz_review_back'));
  expect(j.location, '/quiz/quiz-1/result');
  expect(find.byType(QuizResultScreen), findsOneWidget);

  // ... and back from the result goes to Learn, over the setup and the quiz.
  await tapBackChip(tester, key: const Key('quiz_result_back'));
  await pumpUntil(tester, find.byType(SubjectsScreen), journey: j);
  expect(j.location, '/learn');
  expect(find.byType(QuizSetupScreen), findsNothing);
  expect(find.byType(QuizResultScreen), findsNothing);
  expect(j.exits, isEmpty);

  // --- Home shows what the server awarded ------------------------------------
  await tapOn(tester, find.text(l.navHome).last);
  expect(j.location, '/home');
  expect(
    find.text(l.pointsValue(mockStartingPoints + _correctAnswers)),
    findsWidgets,
  );
  expect(find.text(l.pointsValue(mockStartingPoints)), findsNothing);

  expectCleanJourney(j, knownOverflows: knownOverflows, label: label);
  await endJourney(tester);
}
