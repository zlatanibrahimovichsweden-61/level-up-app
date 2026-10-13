import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/catalog/screens/subject_tree_screen.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/flashcards/screens/flashcard_setup_screen.dart';
import 'package:level_up_app/features/flashcards/screens/flashcard_study_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_screen.dart';

import 'journey_harness.dart';

/// Journey 2b: the learning loop on the UNIVERSITY track.
///
/// Signs in with the mock's university code (which flips the mock to a
/// university student: a flat subject tree whose leaf is the lecture), then:
///
///  Learn -> subject -> lectures -> a lecture's quiz setup -> back -> the
///  Flashcard tab -> a lecture -> flashcard setup -> a study round (ten cards,
///  each flipped and graded) -> the round ends on the setup -> back -> back,
///  and finally a whole quiz on a lecture, its result, and Home showing the
///  server's new total.
///
/// What this guards that the school loop cannot: the tree is FLAT (no unit or
/// chapter level, so the back chain is one level shorter), the Flashcard tab is
/// a second kind of leaf, and every flashcard write is a `PUT` of one card's
/// grade that the screen only believes once the server said so.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('university learning loop in $locale', (tester) async {
      await walkUniversity(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('university learning loop in the dark canvas in $locale', (
      tester,
    ) async {
      await walkUniversity(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('university learning loop at 2.0x text in $locale', (
      tester,
    ) async {
      await walkUniversity(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownUniversityOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownUniversityOverflowsAtTwoTimes = <String>{};

const _subject = 'التشريح';
const _subjectPath = '/learn/subject/uni-anatomy';
const _lecture = 'المحاضرة الأولى: مقدمة';
const _lectureId = 'anatomy-l1';
const _flashcardsPath = '$_subjectPath/lecture/$_lectureId/flashcards';
const _quizLength = 10;

/// How many cards one flashcard round holds (the mock pages by ten).
const _roundSize = 10;

Future<void> walkUniversity(
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
    theme: theme,
    textScale: textScale,
    size: size,
  );

  // --- Sign in as the university student ---------------------------------------
  await signInViaUi(tester, j, locale: locale, code: otpUniversity);
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(find.text(mockUniversityStudentName), findsWidgets);

  // --- Learn -> the university subject list --------------------------------------
  await tapOn(tester, find.text(l.navLearn).last);
  await pumpUntil(tester, find.byType(SubjectsScreen), journey: j);
  await pumpUntil(tester, find.text(_subject), journey: j);
  expect(j.location, '/learn');
  expect(
    find.text('الأحياء'),
    findsNothing,
    reason: 'a university student has no school subjects',
  );

  // --- Subject -> the FLAT lecture list -------------------------------------------
  await tapOn(tester, find.text(_subject));
  await pumpUntil(tester, find.byType(SubjectTreeScreen), journey: j);
  await pumpUntil(tester, find.text(_lecture), journey: j);
  expect(j.location, _subjectPath);
  expect(
    j.requests.count('GET', '/catalog/subjects/uni-anatomy/tree'),
    1,
    reason: 'one tree fetch, as on the school track',
  );
  // The Flashcard tab is offered because lectures here have cards.
  expect(find.text(l.flashcardsTab), findsOneWidget);

  // --- A lecture's quiz setup, and back ---------------------------------------------
  await tapOn(tester, find.text(_lecture));
  await pumpUntil(tester, find.byType(QuizSetupScreen), journey: j);
  expect(j.location, '/quiz/setup');
  expect(find.text(_lecture), findsOneWidget, reason: 'the scope header');
  await tapBackChip(tester, key: const Key('quiz_setup_back'));
  expect(j.location, _subjectPath);
  expect(find.byType(SubjectTreeScreen), findsOneWidget);
  expect(j.requests.countPrefix('/quizzes'), 0, reason: 'nothing created');

  // --- The Flashcard tab -> a lecture -> flashcard setup ------------------------------
  await tapOn(tester, find.text(l.flashcardsTab));
  await tapOn(tester, find.text(_lecture));
  await pumpUntil(tester, find.byType(FlashcardSetupScreen), journey: j);
  expect(j.location, _flashcardsPath);
  await pumpUntil(tester, find.text(l.flashcardSetupCount(24)), journey: j);
  expect(
    j.requests.countPrefix('/flashcards'),
    0,
    reason: 'setup reads no cards',
  );

  // The back chip, the OS Back and a router pop all return to the lectures.
  for (final way in [BackWay.chip, BackWay.os, BackWay.routerPop]) {
    await leave(tester, j, way, chipKey: const Key('flashcard_setup_back'));
    expect(j.location, _subjectPath, reason: 'setup -> lectures by $way');
    expect(find.byType(SubjectTreeScreen), findsOneWidget);
    await tapOn(tester, find.text(l.flashcardsTab));
    await tapOn(tester, find.text(_lecture));
    await pumpUntil(tester, find.byType(FlashcardSetupScreen), journey: j);
  }

  // --- A study round: ten cards, each flipped, then graded ------------------------------
  await tapOn(tester, find.byKey(const Key('flashcard_setup_start')));
  await pumpUntil(tester, find.byType(FlashcardStudyScreen), journey: j);
  expect(j.location, '$_flashcardsPath/study');
  expect(j.requests.count('GET', '/flashcards/lectures/$_lectureId/cards'), 1);
  for (var i = 1; i <= _roundSize; i++) {
    await pumpUntil(
      tester,
      find.byKey(const Key('flashcard_card')),
      journey: j,
    );
    await tapOn(tester, find.byKey(const Key('flashcard_card')));
    // "Again" for the odd cards, "Got it" for the even: both are one PUT.
    await tapOn(
      tester,
      find.byKey(Key(i.isOdd ? 'flashcard_again' : 'flashcard_got_it')),
    );
    await pumpUntil(
      tester,
      i < _roundSize
          ? find.byKey(const Key('flashcard_card'))
          : find.byType(FlashcardSetupScreen),
      journey: j,
    );
    expect(
      j.requests.countPrefix('/flashcards/cards/'),
      i,
      reason: 'one grade per card, sent when the student chose it',
    );
  }
  // The round ended on its own and returned to the setup it came from.
  expect(j.location, _flashcardsPath);
  expect(find.byType(FlashcardStudyScreen), findsNothing);
  expect(
    j.requests.entries.where((e) => e.startsWith('PUT /flashcards/cards/')),
    hasLength(_roundSize),
    reason: 'every grade is a PUT',
  );

  // --- The study screen's own exits ---------------------------------------------------
  await tapOn(tester, find.byKey(const Key('flashcard_setup_start')));
  await pumpUntil(tester, find.byType(FlashcardStudyScreen), journey: j);
  await tapOn(tester, find.byKey(const Key('flashcard_close')));
  expect(j.location, _flashcardsPath, reason: 'the close returns to setup');
  expect(find.byType(FlashcardSetupScreen), findsOneWidget);
  await tapOn(tester, find.byKey(const Key('flashcard_setup_start')));
  await pumpUntil(tester, find.byType(FlashcardStudyScreen), journey: j);
  expect(await systemBack(tester, j), isFalse);
  expect(j.location, _flashcardsPath, reason: 'OS Back returns to setup');

  // --- Back out: setup -> lectures -> subjects ------------------------------------------
  await tapBackChip(tester, key: const Key('flashcard_setup_back'));
  expect(j.location, _subjectPath);
  await tapBackChip(tester);
  expect(j.location, '/learn');
  expect(find.byType(SubjectsScreen), findsOneWidget);

  // --- A whole quiz on a lecture -------------------------------------------------------------
  final profileFetches = j.requests.count('GET', '/me');
  await tapOn(tester, find.text(_subject));
  await pumpUntil(tester, find.text(_lecture), journey: j);
  await tapOn(tester, find.text(_lecture));
  await pumpUntil(tester, find.byType(QuizSetupScreen), journey: j);
  await tapOn(tester, find.text(l.quizSizeOption(_quizLength)));
  await tapOn(tester, find.text(l.startLearning));
  await pumpUntil(tester, find.byType(QuizScreen), journey: j);
  expect(j.requests.count('POST', '/quizzes'), 1);
  await answerQuizToFinish(tester, j, locale: locale, length: _quizLength);
  await tapOn(tester, find.text(l.finishQuiz));
  await pumpUntil(tester, find.byType(QuizResultScreen), journey: j);
  expect(find.text(l.quizCompleteTitle), findsOneWidget);
  // All ten were the mock's correct options: the SERVER's tally, ten points.
  expect(find.text(l.pointsAwardedValue(_quizLength)), findsOneWidget);
  await settle(tester);
  expect(j.requests.count('GET', '/me'), profileFetches + 1);

  // The result's chip returns to Learn, and Home shows the server's total.
  await tapBackChip(tester, key: const Key('quiz_result_back'));
  await pumpUntil(tester, find.byType(SubjectsScreen), journey: j);
  expect(j.location, '/learn');
  await tapOn(tester, find.text(l.navHome).last);
  expect(j.location, '/home');
  expect(
    find.text(l.pointsValue(mockStartingPoints + _quizLength)),
    findsWidgets,
    reason: 'the server awarded ten points; the device added nothing',
  );
  expect(j.exits, isEmpty);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'university $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
