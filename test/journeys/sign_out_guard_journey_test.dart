import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/account_shells/screens/legal_document_screen.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/mistakes/screens/mistakes_overview_screen.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';

import 'journey_harness.dart';

/// Journey 7: sign out, and everything the sign-out guards.
///
/// Sign in through the real screens, then:
///  - the logout dialog's No does nothing; Yes revokes, clears the tokens and
///    lands on Login with no "you were signed out" message (the student chose
///    it);
///  - every protected route bounces to Login while signed out, the public ones
///    (onboarding, Login, the legal documents) do not;
///  - the OTP route with no arguments goes back to Login, even in the process
///    that held the previous session's arguments (W1 NR-29);
///  - the next student sees their own data, not the last one's: their profile,
///    and - with the server's answer HELD, so that anything on screen can only
///    have come from the last student - the Learn list, the Mistakes overview
///    and the very subject tree the first student had open (R2a: the providers
///    that fetch per session are `autoDispose`, and the sign-out unmounting the
///    shell is what ends them).
/// And a second journey: the session ending UNDER the student (what a 401 does)
/// shows the one-time message and, for the same student only, returns them to
/// where they were.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('sign out and the guards in $locale', (tester) async {
      await walkSignOut(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('sign out and the guards in the dark canvas in $locale', (
      tester,
    ) async {
      await walkSignOut(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('sign out and the guards at 2.0x text in $locale', (
      tester,
    ) async {
      await walkSignOut(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownSignOutOverflowsAtTwoTimes,
      );
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('a session ending under the student, in $locale', (
      tester,
    ) async {
      await walkSessionEnded(tester, locale: locale);
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownSignOutOverflowsAtTwoTimes = <String>{};

/// The routes that need a session. Every one must bounce to Login signed out.
const protectedRoutes = <String>[
  '/home',
  '/leaderboard',
  '/learn',
  '/learn/subject/sub-bio',
  '/learn/mistakes',
  '/message',
  '/account',
  '/profile',
  '/profile/edit',
  '/settings',
  '/refer',
  '/support',
  '/support/new',
  '/support/tickets/5c000000-0000-4000-8000-000000000001',
  '/friends',
  '/notifications',
  '/quiz/setup',
  '/quiz/quiz-1',
  '/quiz/quiz-1/result',
  '/quiz/quiz-1/result/review',
];

/// The routes a signed-out visitor may see.
const publicRoutes = <String>['/', '/login', '/legal/privacy', '/legal/terms'];

Future<void> _goTo(WidgetTester tester, Journey j, String route) async {
  j.router.go(route);
  await settle(tester, const Duration(milliseconds: 600));
}

/// The first student's (school) subjects. The second student's (university) are
/// a different set, so none of these may be on screen for the second student.
const _firstStudentsSubjects = <String>[
  'الأحياء',
  'الكيمياء',
  'الفيزياء',
  'الرياضيات',
  'الجغرافيا',
  'اللغة العربية',
];

/// The units of the first student's `sub-bio` tree.
const _firstStudentsUnits = <String>['الوحدة الأولى', 'الوحدة الثانية'];

/// Which of [texts] are on screen right now, whole-string.
List<String> _onScreen(List<String> texts) => [
  for (final text in texts)
    if (find.text(text).evaluate().isNotEmpty) text,
];

Future<void> walkSignOut(
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

  // --- Cold, signed out: the OTP route with no arguments goes to Login -------
  expect(find.byType(OnboardingScreen), findsOneWidget);
  await _goTo(tester, j, '/login/otp');
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(find.byType(OtpScreen), findsNothing);

  // --- Sign in through the real screens ---------------------------------------
  await signInViaUi(tester, j, locale: locale);
  expect(find.byType(HomeScreen), findsOneWidget);
  expect(j.auth, isA<AuthAuthenticated>());
  expect(j.storage.hasSession, isTrue);

  // --- The first student works through Learn, a subject and Mistakes, so each
  // provider holds THEIR data when the session ends. The subject is left (its
  // screen closes); the Learn list and then Mistakes stay mounted in the Learn
  // branch when the student goes to Account to sign out - the dangerous order,
  // because a screen that is still mounted keeps listening to its provider. ---
  await tapOn(tester, find.text(l.navLearn).last);
  await pumpUntil(tester, find.byType(SubjectsScreen), journey: j);
  await pumpUntil(tester, find.text('الأحياء'), journey: j);
  await tapOn(tester, find.text('الأحياء'));
  await pumpUntil(tester, find.text(_firstStudentsUnits.first), journey: j);
  expect(j.location, '/learn/subject/sub-bio');
  await tapBackChip(tester);
  expect(j.location, '/learn');
  await tapOn(tester, find.text(l.mistakes));
  await pumpUntil(tester, find.byType(MistakesOverviewScreen), journey: j);
  await pumpUntil(tester, find.text('الكيمياء'), journey: j);
  expect(j.location, '/learn/mistakes');

  await tapOn(tester, find.text(l.navAccount).last);
  expect(find.byType(ProfileScreen), findsOneWidget);
  expect(find.text(mockStudentName), findsWidgets);
  final logoutsBefore = j.requests.count('POST', '/auth/logout');

  // --- No does nothing ----------------------------------------------------------
  await tapOn(tester, find.byKey(const Key('profile_row_logout')));
  expect(find.text(l.logoutBody), findsOneWidget);
  await tapOn(tester, find.byKey(const Key('logout_no')));
  expect(find.text(l.logoutBody), findsNothing);
  expect(j.auth, isA<AuthAuthenticated>());
  expect(j.location, '/account');
  expect(j.requests.count('POST', '/auth/logout'), logoutsBefore);
  expect(j.storage.clearTokensCalls, 0);

  // --- Yes signs out: revoke, clear, Login, no message ----------------------------
  await tapOn(tester, find.byKey(const Key('profile_row_logout')));
  await tapOn(tester, find.byKey(const Key('logout_confirm')));
  await pumpUntil(tester, find.byType(LoginScreen), journey: j);
  expect(j.location, '/login');
  expect(j.requests.count('POST', '/auth/logout'), logoutsBefore + 1);
  expect(j.storage.clearTokensCalls, 1);
  expect(j.storage.hasSession, isFalse);
  expect(j.auth, isA<AuthUnauthenticated>());
  expect(
    (j.auth as AuthUnauthenticated).reason,
    isNull,
    reason: 'a deliberate sign-out leaves no message for Login to show',
  );
  expect(find.text(l.sessionExpired), findsNothing);
  expect(find.text(l.sessionEndedSuperseded), findsNothing);
  expect(find.byType(ProfileScreen), findsNothing);

  // --- Every protected route bounces to Login --------------------------------------
  final requestsAfterSignOut = j.requests.snapshot();
  for (final route in protectedRoutes) {
    await _goTo(tester, j, route);
    expect(j.location, '/login', reason: '$route must bounce to Login');
    expect(find.byType(LoginScreen), findsOneWidget, reason: route);
  }
  expect(
    j.requests.snapshot(),
    requestsAfterSignOut,
    reason: 'a bounced route must not have fetched anything first',
  );

  // --- The public routes do not --------------------------------------------------------
  for (final route in publicRoutes) {
    await _goTo(tester, j, route);
    expect(j.location, route, reason: '$route is public');
  }
  expect(find.byType(LegalDocumentScreen), findsOneWidget);

  // --- OTP with no arguments: back to Login, though this process held the
  // previous session's arguments until the session ended (NR-29) ----------------------
  await _goTo(tester, j, '/login/otp');
  expect(j.location, '/login');
  expect(find.byType(OtpScreen), findsNothing);

  // --- The next student sees their own data -----------------------------------------------
  final profileFetches = j.requests.count('GET', '/me');
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, otpUniversity);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  await tapOn(tester, find.text(l.continueLabel));
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home');
  expect(j.requests.count('GET', '/me'), profileFetches + 1);
  await tapOn(tester, find.text(l.navAccount).last);
  expect(find.text(mockUniversityStudentName), findsWidgets);
  expect(find.text(mockStudentName), findsNothing);

  // Learn: the second student's request is asked and NOT yet answered. Nothing
  // on screen can be theirs, so nothing may be the first student's either - a
  // loading state, not their list, and not the old session's error.
  final subjectsAsked = j.requests.count('GET', '/catalog/subjects');
  j.gate.hold('GET', '/catalog/subjects');
  await tapOn(tester, find.text(l.navLearn).last);
  await settle(tester, const Duration(seconds: 1));
  expect(
    j.requests.count('GET', '/catalog/subjects'),
    subjectsAsked + 1,
    reason: "Learn asks for the second student's own list on open",
  );
  expect(
    _onScreen(_firstStudentsSubjects),
    isEmpty,
    reason: "the first student's subjects are on screen while held",
  );
  expect(find.text('التشريح'), findsNothing, reason: 'not answered yet');
  expect(find.text(l.genericError), findsNothing);
  j.gate.release('GET', '/catalog/subjects');
  await pumpUntil(tester, find.text('التشريح'), journey: j);
  expect(
    _onScreen(_firstStudentsSubjects),
    isEmpty,
    reason: 'no school subjects',
  );

  // Mistakes: the same, for the overview (rows AND counts).
  final mistakesAsked = j.requests.count('GET', '/me/mistakes');
  j.gate.hold('GET', '/me/mistakes');
  await tapOn(tester, find.text(l.mistakes));
  await pumpUntil(tester, find.byType(MistakesOverviewScreen), journey: j);
  await settle(tester, const Duration(seconds: 1));
  expect(
    j.requests.count('GET', '/me/mistakes'),
    mistakesAsked + 1,
    reason: "Mistakes asks for the second student's own overview on open",
  );
  expect(
    _onScreen(_firstStudentsSubjects),
    isEmpty,
    reason: "the first student's Mistakes rows are on screen while held",
  );
  for (final count in const [100, 34, 7, 5]) {
    expect(find.textContaining(l.mistakeCount(count)), findsNothing);
  }
  expect(find.text(l.genericError), findsNothing);
  j.gate.release('GET', '/me/mistakes');
  await pumpUntil(tester, find.text('التشريح'), journey: j);
  expect(_onScreen(_firstStudentsSubjects), isEmpty);
  await tapBackChip(tester);
  expect(j.location, '/learn');

  // A subject tree: the very one the first student had open. The server's real
  // answer to a university student is "not part of your course" (the same
  // refusal the first student's list would give them), so the tree can never be
  // theirs; while it is held nothing but a loading state may show.
  final treeAsked = j.requests.count('GET', '/catalog/subjects/sub-bio/tree');
  j.gate.hold('GET', '/catalog/subjects/sub-bio/tree');
  await _goTo(tester, j, '/learn/subject/sub-bio');
  await settle(tester, const Duration(seconds: 1));
  expect(
    j.requests.count('GET', '/catalog/subjects/sub-bio/tree'),
    treeAsked + 1,
    reason: "the subject asks for the second student's own tree on open",
  );
  expect(
    _onScreen(_firstStudentsUnits),
    isEmpty,
    reason: "the first student's units are on screen while held",
  );
  expect(find.text(l.subjectUnavailable), findsNothing, reason: 'not answered');
  j.gate.release('GET', '/catalog/subjects/sub-bio/tree');
  await pumpUntil(tester, find.text(l.subjectUnavailable), journey: j);
  expect(_onScreen(_firstStudentsUnits), isEmpty);

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'sign-out $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}

/// The session ending under the student - what a `session_superseded` or a dead
/// refresh does through `AuthController.forceLogout`.
Future<void> walkSessionEnded(
  WidgetTester tester, {
  required String locale,
}) async {
  final l = l10nFor(locale);
  final j = await bootJourney(tester, locale: locale);

  await signInViaUi(tester, j, locale: locale);
  await tapOn(tester, find.text(l.navLearn).last);
  await pumpUntil(tester, find.text('الأحياء'), journey: j);
  await tapOn(tester, find.text('الأحياء'));
  await pumpUntil(tester, find.text('الوحدة الأولى'), journey: j);
  expect(j.location, '/learn/subject/sub-bio');

  // The session ends while the student is reading a subject.
  await j.container
      .read(authControllerProvider.notifier)
      .forceLogout(LogoutReason.sessionExpired);
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(j.storage.hasSession, isFalse);
  // The reason is told once, then consumed.
  expect(find.text(l.sessionExpired), findsOneWidget);
  expect(
    (j.container.read(authControllerProvider) as AuthUnauthenticated).reason,
    isNull,
  );

  // The SAME student signing in again is returned to where they were.
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, otpSchool);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  await tapOn(tester, find.text(l.continueLabel));
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/learn/subject/sub-bio');

  // The success view's OS Back is Continue: a SECOND session end, a second
  // sign-in by the same student, and this time the student leaves the success
  // view with the OS Back. They land on the remembered place - not on a Login
  // form with a live session behind it - and the target is spent, exactly as
  // with Continue.
  await j.container
      .read(authControllerProvider.notifier)
      .forceLogout(LogoutReason.sessionExpired);
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, otpSchool);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  expect(await systemBack(tester, j), isFalse, reason: 'the app handled it');
  await settle(tester, const Duration(seconds: 1));
  expect(
    j.location,
    '/learn/subject/sub-bio',
    reason: 'the OS Back on the success view is Continue',
  );
  expect(find.byType(LoginScreen), findsNothing);
  expect(j.auth, isA<AuthAuthenticated>());

  // A DELIBERATE sign-out remembers nothing: the next sign-in lands on Home.
  //
  // (The mock gives both of its students the same server id, so "a different
  // student is never handed this place" cannot be walked through it; that rule
  // is held by test/core/router/return_target_test.dart.)
  await tapOn(tester, find.text(l.navAccount).last);
  await tapOn(tester, find.byKey(const Key('profile_row_logout')));
  await tapOn(tester, find.byKey(const Key('logout_confirm')));
  await pumpUntil(tester, find.byType(LoginScreen), journey: j);
  expect(j.location, '/login');
  expect(find.text(l.sessionExpired), findsNothing);
  await requestOtpViaUi(tester, j, locale: locale);
  await enterOtp(tester, otpSchool);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  await tapOn(tester, find.text(l.continueLabel));
  await settle(tester, const Duration(seconds: 1));
  expect(
    j.location,
    '/home',
    reason: 'a deliberate sign-out forgets where the student was',
  );

  expectCleanJourney(j, label: 'session-ended $locale');
  await endJourney(tester);
}
