import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/router/route_error_screen.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/dev/mock_support.dart' as mock;
import 'package:level_up_app/features/account_shells/screens/customer_support_screen.dart';
import 'package:level_up_app/features/account_shells/screens/legal_document_screen.dart';
import 'package:level_up_app/features/account_shells/screens/refer_a_friend_screen.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/catalog/screens/chapters_screen.dart';
import 'package:level_up_app/features/catalog/screens/lessons_screen.dart';
import 'package:level_up_app/features/catalog/screens/subject_tree_screen.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:level_up_app/features/mistakes/screens/mistakes_overview_screen.dart';
import 'package:level_up_app/features/notifications/screens/notifications_screen.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/features/profile/screens/edit_profile_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';
import 'package:level_up_app/features/profile/widgets/profile_confirm_dialog.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_review_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_screen.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/screens/school_detail_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_identity_screen.dart';
import 'package:level_up_app/features/registration/screens/signup_track_screen.dart';
import 'package:level_up_app/features/registration/screens/university_detail_screen.dart';
import 'package:level_up_app/features/settings/screens/settings_screen.dart';
import 'package:level_up_app/features/support/screens/create_support_ticket_screen.dart';
import 'package:level_up_app/features/support/screens/support_ticket_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'journey_harness.dart';

/// Journey 9: back behaviour, step by step.
///
/// Every screen the app pushes over another is left each way a student (or the
/// platform) can leave it - the on-screen back chip, the OS Back, and a router
/// `pop` - and each must land on the screen it came from. A chip that does not
/// move anything is a dead control and fails (see [leave]). The roots - a tab
/// root, onboarding, Login - are asked for Back too: they may close the app but
/// must never strand a student on a blank or dead screen.
///
/// Sign Up_1 (`/register`) is walked both ways too: its chip and the OS Back
/// both go to Login (the OTP screen REPLACES itself with it, so nothing sits
/// beneath; the OS Back used to close the app). And the OTP success view's OS
/// Back is Continue, not a pop to a Login form with a live session behind it
/// ([walkOtpSuccessBack]).
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('back from the Account hub\'s screens in $locale', (
      tester,
    ) async {
      await walkAccountDoors(tester, locale: locale);
    });
    journeyTest('back from the Account hub\'s screens, dark, in $locale', (
      tester,
    ) async {
      await walkAccountDoors(tester, locale: locale, theme: ThemeMode.dark);
    });
    journeyTest('back from the Account hub\'s screens at 2.0x in $locale', (
      tester,
    ) async {
      await walkAccountDoors(tester, locale: locale, textScale: 2.0);
    });

    journeyTest('back through Support\'s three levels in $locale', (
      tester,
    ) async {
      await walkSupportLevels(tester, locale: locale);
    });

    journeyTest('back through the Learn drill-down in $locale', (tester) async {
      await walkLearnDrillDown(tester, locale: locale);
    });
    journeyTest('back through the Learn drill-down, dark, in $locale', (
      tester,
    ) async {
      await walkLearnDrillDown(tester, locale: locale, theme: ThemeMode.dark);
    });
    journeyTest('back through the Learn drill-down at 2.0x in $locale', (
      tester,
    ) async {
      await walkLearnDrillDown(tester, locale: locale, textScale: 2.0);
    });

    journeyTest('tabs keep their place and re-tapping returns to the root, '
        'in $locale', (tester) async {
      await walkTabState(tester, locale: locale);
    });

    journeyTest('leaving a quiz in progress in $locale', (tester) async {
      await walkQuizExit(tester, locale: locale);
    });

    journeyTest('OS Back from the result and the review in $locale', (
      tester,
    ) async {
      await walkResultReviewBack(tester, locale: locale);
    });

    journeyTest('Home bell, Leaderboard chip and Mistakes in $locale', (
      tester,
    ) async {
      await walkHomeLeaderboardMistakes(tester, locale: locale);
    });
    journeyTest('Home bell, Leaderboard chip and Mistakes, dark, in $locale', (
      tester,
    ) async {
      await walkHomeLeaderboardMistakes(
        tester,
        locale: locale,
        theme: ThemeMode.dark,
      );
    });

    journeyTest('roots, cold links and unknown routes in $locale', (
      tester,
    ) async {
      await walkRootsAndDeadEnds(tester, locale: locale);
    });

    journeyTest('signed-out back chain in $locale', (tester) async {
      await walkSignedOutBackChain(tester, locale: locale);
    });
    journeyTest('signed-out back chain, dark, in $locale', (tester) async {
      await walkSignedOutBackChain(
        tester,
        locale: locale,
        theme: ThemeMode.dark,
      );
    });
    journeyTest('signed-out back chain at 2.0x in $locale', (tester) async {
      await walkSignedOutBackChain(tester, locale: locale, textScale: 2.0);
    });

    journeyTest('OS Back on the OTP success view in $locale', (tester) async {
      await walkOtpSuccessBack(tester, locale: locale);
    });
    journeyTest('OS Back on the OTP success view, dark, in $locale', (
      tester,
    ) async {
      await walkOtpSuccessBack(tester, locale: locale, theme: ThemeMode.dark);
    });
  }
}

/// Every way out of a pushed screen that does not guard anything.
const _allWays = [BackWay.chip, BackWay.os, BackWay.routerPop];

Finder _field(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

/// Boots signed in, waits for Home.
Future<Journey> _bootHome(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
}) async {
  final j = await bootJourney(
    tester,
    locale: locale,
    size: size,
    signedIn: true,
    theme: theme,
    textScale: textScale,
  );
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  return j;
}

// ---------------------------------------------------------------------------
// Account hub
// ---------------------------------------------------------------------------

class _Door {
  const _Door(this.row, this.route, this.screen, this.back);

  /// The key of the Account hub control that opens it.
  final String row;

  /// Where it lands.
  final String route;

  /// The screen widget type found there.
  final Type screen;

  /// The key of its back chip.
  final String back;
}

const _accountDoors = [
  _Door(
    'profile_edit_button',
    '/profile/edit',
    EditProfileScreen,
    'edit_profile_back',
  ),
  _Door('profile_row_settings', '/settings', SettingsScreen, 'settings_back'),
  _Door('profile_row_refer', '/refer', ReferAFriendScreen, 'refer_back'),
  _Door(
    'profile_row_support',
    '/support',
    CustomerSupportScreen,
    'support_back',
  ),
  _Door(
    'profile_row_privacy',
    '/legal/privacy',
    LegalDocumentScreen,
    'legal_back',
  ),
  _Door('profile_row_terms', '/legal/terms', LegalDocumentScreen, 'legal_back'),
];

Future<void> walkAccountDoors(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(
    tester,
    locale: locale,
    size: size,
    theme: theme,
    textScale: textScale,
  );

  await tapOn(tester, find.text(l.navAccount).last);
  expect(j.location, '/account');
  expect(find.byType(ProfileScreen), findsOneWidget);

  for (final door in _accountDoors) {
    for (final way in _allWays) {
      final label = '${door.route} / $way';
      await tapOn(tester, find.byKey(Key(door.row)));
      expect(j.location, door.route, reason: 'door $label');
      expect(find.byType(door.screen), findsOneWidget, reason: label);

      await leave(tester, j, way, chipKey: Key(door.back));
      expect(j.location, '/account', reason: 'back from $label');
      expect(find.byType(ProfileScreen), findsOneWidget, reason: label);
      expect(find.byType(door.screen), findsNothing, reason: label);
      expect(j.exits, isEmpty, reason: label);
    }
  }
  // Nothing in all that wrote anything.
  expect(j.requests.count('PATCH', '/me'), 0);

  // A dialog is not a route: the OS Back closes "Go to Uni" and leaves the hub
  // exactly as it was, with nothing sent. (Whether its Confirm is live is
  // deliberately not asserted: it is a product decision still in motion.)
  await tapOn(tester, find.byKey(const Key('profile_row_go_to_uni')));
  // (By type: in Arabic the dialog's title and the row's label are one string.)
  expect(find.byType(ProfileConfirmDialog), findsOneWidget);
  expect(j.location, '/account', reason: 'a dialog adds no route');
  expect(await systemBack(tester, j), isFalse, reason: 'the app handled it');
  expect(find.byType(ProfileConfirmDialog), findsNothing);
  expect(j.location, '/account');
  expect(find.byType(ProfileScreen), findsOneWidget);
  expect(j.requests.countPrefix('/me/track-transfer'), 0);
  expect(j.exits, isEmpty);

  // A dirty Edit Profile is the one guarded exit: the chip and the OS Back
  // both ask first, and a router pop (which cannot consult a PopScope) is not
  // part of the contract there. Discarding returns to the hub.
  await tapOn(tester, find.byKey(const Key('profile_edit_button')));
  await tester.enterText(_field('edit_name_field'), 'Changed Name');
  await settle(tester, const Duration(milliseconds: 200));
  for (final way in [BackWay.chip, BackWay.os]) {
    if (way == BackWay.chip) {
      await tapBackChip(tester, key: const Key('edit_profile_back'));
    } else {
      expect(await systemBack(tester, j), isFalse);
    }
    expect(find.text(l.discardChangesTitle), findsOneWidget, reason: '$way');
    expect(j.location, '/profile/edit');
    await tapOn(tester, find.byKey(const Key('discard_keep_editing')));
    expect(find.text(l.discardChangesTitle), findsNothing);
    expect(j.location, '/profile/edit');
  }
  await tapBackChip(tester, key: const Key('edit_profile_back'));
  await tapOn(tester, find.byKey(const Key('discard_confirm')));
  expect(j.location, '/account');
  expect(j.requests.count('PATCH', '/me'), 0);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'back-account $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// Support
// ---------------------------------------------------------------------------

Future<void> walkSupportLevels(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(tester, locale: locale, size: size);
  await tapOn(tester, find.text(l.navAccount).last);
  await tapOn(tester, find.byKey(const Key('profile_row_support')));
  expect(j.location, '/support');
  final ticket1 = mock.mockSupportTicketId(1);
  await pumpUntil(
    tester,
    find.byKey(Key('support_ticket_row_$ticket1')),
    journey: j,
  );

  for (final way in _allWays) {
    // List -> the new-ticket form -> back to the list, nothing sent. (The
    // list keeps its scroll place on return, and tapping the last row scrolled
    // it; a student scrolls back up to the create card.)
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, 800),
    );
    await settle(tester);
    await pumpUntil(
      tester,
      find.byKey(const Key('support_create_card')),
      journey: j,
    );
    await tapOn(tester, find.byKey(const Key('support_create_card')));
    expect(j.location, '/support/new', reason: '$way');
    expect(find.byType(CreateSupportTicketScreen), findsOneWidget);
    await leave(tester, j, way, chipKey: const Key('support_new_back'));
    expect(j.location, '/support', reason: 'form -> list by $way');
    expect(find.byType(CustomerSupportScreen), findsOneWidget);
    expect(find.byType(CreateSupportTicketScreen), findsNothing);
    expect(j.requests.count('POST', '/support/tickets'), 0);

    // List -> a ticket's thread -> back to the list.
    await pumpUntil(
      tester,
      find.byKey(Key('support_ticket_row_$ticket1')),
      journey: j,
    );
    await tapOn(tester, find.byKey(Key('support_ticket_row_$ticket1')));
    await pumpUntil(tester, find.byType(SupportTicketScreen), journey: j);
    expect(j.location, '/support/tickets/$ticket1', reason: '$way');
    await leave(tester, j, way, chipKey: const Key('support_thread_back'));
    expect(j.location, '/support', reason: 'thread -> list by $way');
    expect(find.byType(SupportTicketScreen), findsNothing);
  }

  // List -> the hub, each way.
  for (final way in _allWays) {
    await leave(tester, j, way, chipKey: const Key('support_back'));
    expect(j.location, '/account', reason: 'list -> hub by $way');
    expect(find.byType(ProfileScreen), findsOneWidget);
    if (way != _allWays.last) {
      await tapOn(tester, find.byKey(const Key('profile_row_support')));
      expect(j.location, '/support');
    }
  }
  expect(j.exits, isEmpty);
  expectCleanJourney(j, label: 'back-support $locale');
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// Learn
// ---------------------------------------------------------------------------

class _Level {
  const _Level(this.location, this.screen, this.tapToEnter);

  final String location;
  final Type screen;

  /// The text tapped on the PREVIOUS level to arrive here (null for the root).
  final String? tapToEnter;
}

const _lessonPath = '/learn/subject/sub-bio/unit/bio-u1/chapter/bio-u1-c1';

/// School track, Biology -> Unit 1 -> Chapter 1 -> Lesson 2 -> quiz setup.
const _learnLevels = [
  _Level('/learn', SubjectsScreen, null),
  _Level('/learn/subject/sub-bio', SubjectTreeScreen, 'الأحياء'),
  _Level('/learn/subject/sub-bio/unit/bio-u1', ChaptersScreen, 'الوحدة الأولى'),
  _Level(_lessonPath, LessonsScreen, 'الفصل الأول'),
  _Level('/quiz/setup', QuizSetupScreen, 'الدرس الثاني'),
];

/// From the Learn root to the quiz setup, tapping each level's row.
Future<void> _walkDown(
  WidgetTester tester,
  Journey j, {
  int to = 4,
  required AppLocalizations l,
}) async {
  if (j.location != '/learn') {
    await tapOn(tester, find.text(l.navLearn).last);
  }
  expect(j.location, '/learn');
  await pumpUntil(tester, find.text('الأحياء'), journey: j);
  for (var i = 1; i <= to; i++) {
    final level = _learnLevels[i];
    await pumpUntil(tester, find.text(level.tapToEnter!), journey: j);
    await tapOn(tester, find.text(level.tapToEnter!));
    await pumpUntil(tester, find.byType(level.screen), journey: j);
    expect(j.location, level.location);
  }
}

Future<void> walkLearnDrillDown(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(
    tester,
    locale: locale,
    size: size,
    theme: theme,
    textScale: textScale,
  );

  for (final way in _allWays) {
    await _walkDown(tester, j, l: l);

    // Back up one level at a time, each landing exactly one level higher.
    for (var i = _learnLevels.length - 1; i > 0; i--) {
      await leave(
        tester,
        j,
        way,
        chipKey: i == _learnLevels.length - 1
            ? const Key('quiz_setup_back')
            : null,
      );
      final above = _learnLevels[i - 1];
      expect(j.location, above.location, reason: '$way from level $i');
      expect(find.byType(above.screen), findsOneWidget, reason: '$way, $i');
      expect(find.byType(_learnLevels[i].screen), findsNothing, reason: '$way');
    }
    // The Learn root is a tab root: it draws no chip, because it has nothing
    // to go back to.
    expect(find.byType(CircleBackButton), findsNothing);
    expect(j.exits, isEmpty, reason: '$way');
  }

  // Nothing here started a quiz.
  expect(j.requests.countPrefix('/quizzes'), 0);
  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'back-learn $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}

Future<void> walkTabState(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(tester, locale: locale, size: size);

  await _walkDown(tester, j, l: l, to: 3);
  expect(j.location, _lessonPath);

  // Leaving the tab does not pop its stack: Learn is exactly where it was.
  await tapOn(tester, find.text(l.navHome).last);
  expect(j.location, '/home');
  expect(find.byType(HomeScreen), findsOneWidget);
  await tapOn(tester, find.text(l.navAccount).last);
  expect(j.location, '/account');
  await tapOn(tester, find.text(l.navLearn).last);
  expect(j.location, _lessonPath);
  expect(find.byType(LessonsScreen), findsOneWidget);
  expect(
    j.requests.count('GET', '/catalog/subjects/sub-bio/tree'),
    1,
    reason: 'the cached tree survives the tab switch',
  );

  // Back still unwinds one level at a time after the round trip.
  await tapBackChip(tester);
  expect(j.location, '/learn/subject/sub-bio/unit/bio-u1');

  // Re-tapping the ACTIVE tab pops that tab to its root.
  await tapOn(tester, find.text(l.navLearn).last);
  expect(j.location, '/learn');
  expect(find.byType(SubjectsScreen), findsOneWidget);
  expect(find.byType(ChaptersScreen), findsNothing);
  expect(j.exits, isEmpty);

  expectCleanJourney(j, label: 'back-tabs $locale');
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// Quiz
// ---------------------------------------------------------------------------

Future<void> _startQuiz(
  WidgetTester tester,
  Journey j, {
  required AppLocalizations l,
}) async {
  await tapOn(tester, find.text(l.quizSizeOption(10)));
  await tapOn(tester, find.text(l.startLearning));
  await pumpUntil(tester, find.byType(QuizScreen), journey: j);
  expect(j.location, startsWith('/quiz/quiz-'));
}

Future<void> walkQuizExit(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(tester, locale: locale, size: size);
  await _walkDown(tester, j, l: l);

  // --- Setup: every way out returns to the lessons -----------------------------
  for (final way in _allWays) {
    await leave(tester, j, way, chipKey: const Key('quiz_setup_back'));
    expect(j.location, _lessonPath, reason: 'setup -> lessons by $way');
    await tapOn(tester, find.text('الدرس الثاني'));
    await pumpUntil(tester, find.byType(QuizSetupScreen), journey: j);
  }

  // --- In the quiz: leaving is a decision, never an accident -------------------
  await _startQuiz(tester, j, l: l);
  final quizLocation = j.location;
  expect(j.protection.enableCalls, 1);
  expect(j.protection.disableCalls, 0);

  // The OS Back asks; "keep going" stays exactly where it was.
  expect(await systemBack(tester, j), isFalse, reason: 'the app handled it');
  expect(find.text(l.exitQuizTitle), findsOneWidget);
  expect(j.location, quizLocation);
  await tapOn(tester, find.text(l.exitQuizStay));
  expect(find.text(l.exitQuizTitle), findsNothing);
  expect(j.location, quizLocation);
  expect(find.byType(QuizScreen), findsOneWidget);
  expect(j.protection.disableCalls, 0, reason: 'still protected');

  // The close button asks the same question.
  await tapOn(tester, find.byKey(const Key('quiz_close')));
  expect(find.text(l.exitQuizTitle), findsOneWidget);
  await tapOn(tester, find.text(l.exitQuizStay));
  expect(j.location, quizLocation);

  // Leaving by the close button returns to the setup it was started from.
  await tapOn(tester, find.byKey(const Key('quiz_close')));
  await tapOn(tester, find.text(l.exitQuizLeave));
  expect(j.location, '/quiz/setup');
  expect(find.byType(QuizSetupScreen), findsOneWidget);
  expect(find.byType(QuizScreen), findsNothing);
  expect(j.protection.disableCalls, greaterThanOrEqualTo(1));
  expect(j.requests.countPrefix('/quizzes/quiz-1/finish'), 0);

  // Again, leaving by the OS Back.
  await _startQuiz(tester, j, l: l);
  expect(await systemBack(tester, j), isFalse);
  await tapOn(tester, find.text(l.exitQuizLeave));
  expect(j.location, '/quiz/setup');
  expect(find.byType(QuizSetupScreen), findsOneWidget);

  // ... and the setup still goes back to the lessons.
  await tapBackChip(tester, key: const Key('quiz_setup_back'));
  expect(j.location, _lessonPath);
  expect(j.exits, isEmpty);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'back-quiz-exit $locale',
  );
  await endJourney(tester);
}

Future<void> walkResultReviewBack(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(tester, locale: locale, size: size);
  await _walkDown(tester, j, l: l);
  await _startQuiz(tester, j, l: l);
  await answerQuizToFinish(tester, j, locale: locale);
  await tapOn(tester, find.text(l.finishQuiz));
  await pumpUntil(tester, find.byType(QuizResultScreen), journey: j);
  final resultLocation = j.location;
  expect(resultLocation, endsWith('/result'));

  // Review -> OS Back -> the result (not the finished quiz).
  await tapOn(tester, find.text(l.reviewQuestions));
  await pumpUntil(tester, find.byType(QuizReviewScreen), journey: j);
  expect(j.location, '$resultLocation/review');
  expect(await systemBack(tester, j), isFalse);
  expect(j.location, resultLocation);
  expect(find.byType(QuizResultScreen), findsOneWidget);
  expect(find.byType(QuizReviewScreen), findsNothing);

  // Review -> router pop -> the result, too.
  await tapOn(tester, find.text(l.reviewQuestions));
  await pumpUntil(tester, find.byType(QuizReviewScreen), journey: j);
  await routerPop(tester, j);
  expect(j.location, resultLocation);

  // The result's OS Back goes to Learn, over neither the quiz nor its setup.
  expect(await systemBack(tester, j), isFalse, reason: 'the app handled it');
  await pumpUntil(tester, find.byType(SubjectsScreen), journey: j);
  expect(j.location, '/learn');
  expect(find.byType(QuizResultScreen), findsNothing);
  expect(find.byType(QuizScreen), findsNothing);
  expect(find.byType(QuizSetupScreen), findsNothing);
  expect(j.exits, isEmpty);

  // And from Learn the OS Back is a root Back: the app may close, nothing else.
  final exited = await systemBack(tester, j);
  expect(exited, isTrue, reason: 'nothing is left to go back to');
  expect(j.location, '/learn');
  expect(find.byType(SubjectsScreen), findsOneWidget);

  expectCleanJourney(j, label: 'back-result $locale');
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// Home bell, Leaderboard, Mistakes
// ---------------------------------------------------------------------------

Future<void> walkHomeLeaderboardMistakes(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  ThemeMode theme = ThemeMode.light,
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(tester, locale: locale, theme: theme, size: size);

  // --- The bell ---------------------------------------------------------------
  for (final way in _allWays) {
    await tapOn(tester, find.byKey(const Key('home_bell')));
    await pumpUntil(tester, find.byType(NotificationsScreen), journey: j);
    expect(j.location, '/notifications', reason: '$way');
    await leave(tester, j, way, chipKey: const Key('notifications_back'));
    expect(j.location, '/home', reason: 'inbox -> Home by $way');
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(NotificationsScreen), findsNothing);
  }

  // --- Leaderboard: a tab root whose chip means "go to Home" ------------------
  await tapOn(tester, find.text(l.navLeaderboard).last);
  await pumpUntil(tester, find.byType(LeaderboardScreen), journey: j);
  expect(j.location, '/leaderboard');
  expect(find.byType(CircleBackButton), findsOneWidget);
  await tapBackChip(tester);
  expect(j.location, '/home');
  expect(find.byType(HomeScreen), findsOneWidget);
  expect(j.exits, isEmpty);

  // --- Mistakes: pushed inside the Learn tab, bar and branch kept -------------
  await tapOn(tester, find.text(l.navLearn).last);
  await pumpUntil(tester, find.byType(SubjectsScreen), journey: j);
  for (final way in _allWays) {
    await tapOn(tester, find.text(l.mistakes));
    await pumpUntil(tester, find.byType(MistakesOverviewScreen), journey: j);
    expect(j.location, '/learn/mistakes', reason: '$way');
    await leave(tester, j, way);
    expect(j.location, '/learn', reason: 'Mistakes -> Learn by $way');
    expect(find.byType(SubjectsScreen), findsOneWidget);
    expect(find.byType(MistakesOverviewScreen), findsNothing);
  }

  // One level into Mistakes and back out, each way.
  await tapOn(tester, find.text(l.mistakes));
  await pumpUntil(tester, find.byType(MistakesOverviewScreen), journey: j);
  await pumpUntil(tester, find.text('الأحياء'), journey: j);
  for (final way in _allWays) {
    await tapOn(tester, find.text('الأحياء'));
    await pumpUntil(tester, find.text('الوحدة الأولى'), journey: j);
    expect(j.location, '/learn/mistakes/subject/sub-bio', reason: '$way');
    await leave(tester, j, way);
    expect(
      j.location,
      '/learn/mistakes',
      reason: 'subject -> overview by $way',
    );
    expect(find.byType(MistakesOverviewScreen), findsOneWidget);
  }
  await tapBackChip(tester);
  expect(j.location, '/learn');
  expect(j.exits, isEmpty);

  expectCleanJourney(j, label: 'back-home-lb-mistakes $locale/${theme.name}');
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// Roots and dead ends
// ---------------------------------------------------------------------------

Future<void> walkRootsAndDeadEnds(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await _bootHome(tester, locale: locale, size: size);

  // --- Every tab root: Back never strands a student on a dead screen -------------
  // The tab roots ask the OS to close the app (the Android default for the
  // root of the app); what must hold is that the screen is still alive and
  // still the one the student was on.
  final tabs = <(String, String, Type)>[
    (l.navHome, '/home', HomeScreen),
    (l.navLeaderboard, '/leaderboard', LeaderboardScreen),
    (l.navLearn, '/learn', SubjectsScreen),
    (l.navAccount, '/account', ProfileScreen),
  ];
  for (final (label, route, screen) in tabs) {
    await tapOn(tester, find.text(label).last);
    expect(j.location, route);
    final before = j.exits.length;
    await systemBack(tester, j);
    expect(
      j.exits.length,
      before + 1,
      reason: 'OS Back at the root $route closes the app and does nothing else',
    );
    expect(j.location, route, reason: 'a root Back changes no screen');
    expect(find.byType(screen), findsOneWidget, reason: route);
    expect(find.byType(Scaffold), findsWidgets);
    // The app is still interactive after a (mocked) close request.
    await settle(tester, const Duration(milliseconds: 300));
  }

  // --- Cold links to the quiz routes have nothing to rebuild from ----------------
  // (quiz state is in memory only): each says so and offers the way back.
  for (final route in const [
    '/quiz/setup',
    '/quiz/quiz-1',
    '/quiz/quiz-1/result',
    '/quiz/quiz-1/result/review',
  ]) {
    j.router.go(route);
    await settle(tester, const Duration(milliseconds: 800));
    expect(j.location, route);
    expect(find.text(l.genericError), findsOneWidget, reason: route);
    final back = find.widgetWithText(FilledButton, l.backToLearn);
    expect(back, findsOneWidget, reason: '$route offers a way out');
    await tapOn(tester, back);
    expect(j.location, '/learn', reason: '$route -> Learn');
    expect(find.byType(SubjectsScreen), findsOneWidget);
  }

  // --- A location nothing matches: the error page, whose chip goes Home -----------
  j.router.go('/no/such/place');
  await settle(tester, const Duration(milliseconds: 800));
  expect(find.byType(RouteErrorScreen), findsOneWidget);
  expect(find.text(l.genericError), findsOneWidget);
  await tapBackChip(tester);
  expect(j.location, '/home');
  expect(find.byType(HomeScreen), findsOneWidget);
  expect(find.byType(RouteErrorScreen), findsNothing);

  // ... and an unknown location PUSHED over a screen pops back to it.
  await tapOn(tester, find.text(l.navLearn).last);
  unawaited(j.router.push('/no/such/place'));
  await settle(tester, const Duration(milliseconds: 800));
  expect(find.byType(RouteErrorScreen), findsOneWidget);
  await tapBackChip(tester);
  expect(find.byType(RouteErrorScreen), findsNothing);
  expect(find.byType(SubjectsScreen), findsOneWidget);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'back-roots $locale',
  );
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// Signed out
// ---------------------------------------------------------------------------

/// The mock forks any 6-digit code that is not one of its magic ones to the
/// registration wizard.
const _otpRegistration = '333333';

Future<void> walkSignedOutBackChain(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
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

  // --- Onboarding is the root: Back closes the app, nothing else ---------------
  expect(find.byType(OnboardingScreen), findsOneWidget);
  expect(await systemBack(tester, j), isTrue);
  expect(j.location, '/');
  expect(find.byType(OnboardingScreen), findsOneWidget);
  j.exits.clear();

  // --- Login is reached by `go`: no chip (nothing to go back to) ---------------
  await tapOn(tester, find.text(l.logIn));
  expect(j.location, '/login');
  expect(find.byType(CircleBackButton), findsNothing);

  // --- OTP -> Login, every way --------------------------------------------------
  for (final way in _allWays) {
    await requestOtpViaUi(tester, j, locale: locale);
    await leave(tester, j, way);
    expect(j.location, '/login', reason: 'OTP -> Login by $way');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(OtpScreen), findsNothing);
    expect(j.auth, isA<AuthUnauthenticated>());
  }
  expect(j.requests.count('POST', '/auth/otp/verify'), 0);

  // --- OTP -> registration: Sign Up_1 -------------------------------------------
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, _otpRegistration);
  await pumpUntil(tester, find.byType(SignupIdentityScreen), journey: j);
  expect(j.location, '/register');
  expect(find.byType(OtpScreen), findsNothing, reason: 'replaced, not stacked');

  // Its chip and the OS Back both abandon registration, back to Login - the
  // OTP screen replaced itself with this one, so there is nothing beneath it,
  // and an OS Back left alone used to close the app. Neither resets the draft.
  const signUpExits = [BackWay.chip, BackWay.os];
  for (var i = 0; i < signUpExits.length; i++) {
    final way = signUpExits[i];
    if (i > 0) {
      // Back to Sign Up_1 with a fresh OTP for the next way out.
      await requestOtpViaUi(tester, j, locale: locale);
      await enterOtp(tester, _otpRegistration);
      await pumpUntil(tester, find.byType(SignupIdentityScreen), journey: j);
      expect(j.location, '/register');
    }
    await leave(tester, j, way);
    expect(j.location, '/login', reason: 'Sign Up_1 -> Login by $way');
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(SignupIdentityScreen), findsNothing);
    expect(j.exits, isEmpty, reason: 'the app handled the Back itself');
    expect(
      j.container.read(registrationControllerProvider),
      isNotNull,
      reason: 'neither way resets the registration draft',
    );
  }

  // A new OTP, and this time the wizard goes forward: identity -> track ->
  // each track's details, with every step undone by every way.
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, _otpRegistration);
  await pumpUntil(tester, find.byType(SignupIdentityScreen), journey: j);
  await tester.enterText(find.byType(TextField).at(0), 'Journey Student');
  await tester.enterText(find.byType(TextField).at(1), '010000000002');
  for (final way in _allWays) {
    await tapOn(tester, find.widgetWithText(FilledButton, l.continueLabel));
    expect(j.location, '/register/track', reason: '$way');
    expect(find.byType(SignupTrackScreen), findsOneWidget);

    for (final (track, route, screen) in <(String, String, Type)>[
      (l.trackSchool, '/register/school', SchoolDetailScreen),
      (l.trackUniversity, '/register/university', UniversityDetailScreen),
    ]) {
      await tapOn(tester, find.text(track));
      await tapOn(tester, find.widgetWithText(FilledButton, l.continueLabel));
      expect(j.location, route, reason: '$way');
      expect(find.byType(screen), findsOneWidget);
      await leave(tester, j, way);
      expect(j.location, '/register/track', reason: '$route -> track by $way');
      expect(find.byType(SignupTrackScreen), findsOneWidget);
      expect(find.byType(screen), findsNothing);
    }

    await leave(tester, j, way);
    expect(j.location, '/register', reason: 'track -> identity by $way');
    expect(find.byType(SignupIdentityScreen), findsOneWidget);
  }
  // The name typed before going forward survived all those round trips.
  expect(
    tester
        .widget<EditableText>(find.byType(EditableText).first)
        .controller
        .text,
    'Journey Student',
    reason: 'the wizard keeps what was typed',
  );
  // Nothing in the wizard's back chain created an account.
  expect(j.requests.count('POST', '/auth/register'), 0);
  expect(j.storage.hasSession, isFalse);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'back-signed-out $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// The OTP success view
// ---------------------------------------------------------------------------

/// Signed in, on the success view: the OS Back is Continue.
///
/// The view has one way forward. The OS Back used to pop it to the Login form -
/// shown while the student was signed in, tokens stored - and Send OTP there
/// started another OTP flow on top of a live session. Now it goes where Continue
/// goes (Home here), asks the OS for nothing, and leaves no Login behind.
Future<void> walkOtpSuccessBack(
  WidgetTester tester, {
  required String locale,
  Size size = pixel8,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
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

  await tapOn(tester, find.text(l.logIn));
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, otpSchool);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  expect(j.auth, isA<AuthAuthenticated>());
  expect(j.storage.hasSession, isTrue);
  expect(j.location, '/login/otp');
  final otpRequests = j.requests.count('POST', '/auth/otp/request');

  final exited = await systemBack(tester, j);
  expect(exited, isFalse, reason: 'the app handled the Back itself');
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home', reason: 'the OS Back is Continue');
  expect(find.byType(LoginScreen), findsNothing);
  expect(find.byType(OtpScreen), findsNothing);
  expect(j.auth, isA<AuthAuthenticated>());
  expect(j.storage.hasSession, isTrue);
  expect(
    j.requests.count('POST', '/auth/otp/request'),
    otpRequests,
    reason: 'no second OTP flow was started over a live session',
  );

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'otp-success-back $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
