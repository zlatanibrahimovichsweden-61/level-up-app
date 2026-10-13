import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/dev/mock_support.dart' as mock;
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/notifications/screens/notifications_screen.dart';
import 'package:level_up_app/features/profile/screens/profile_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_setup_screen.dart';
import 'package:level_up_app/features/support/screens/support_ticket_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

import 'journey_harness.dart';

/// Journey 10: the connection drops, and comes back, at every kind of step.
///
/// The app's offline contract has three parts, and a student meets each on the
/// way through the app:
///
///  1. a screen that asks for something draws the shared offline BANNER and
///     DISABLES its primary action (Login, OTP, quiz Start), so nothing is sent;
///  2. a screen that loads data shows its offline state with an explicit Retry
///     (notifications, Learn, a subject) - never a silent auto-retry, so
///     coming back online changes nothing until the student asks;
///  3. a write the screen could not know would fail (Save, a privacy switch,
///     a ticket, a reply, a quiz answer) is attempted, fails with the offline
///     copy, and loses nothing the student typed or chose.
///
/// The connection is a [NetworkSwitch]: it drives `isOnlineProvider` AND makes
/// every request that reaches the network layer fail with a connection error,
/// which the app's own `ErrorInterceptor` maps as it would a dead radio. The
/// [RequestLog] counts ATTEMPTS, so "never tried" is told from "tried and
/// failed".
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('offline at every kind of step in $locale', (tester) async {
      await walkOffline(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('offline at every kind of step, dark, in $locale', (
      tester,
    ) async {
      await walkOffline(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('offline at every kind of step at 2.0x text in $locale', (
      tester,
    ) async {
      await walkOffline(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownOfflineOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownOfflineOverflowsAtTwoTimes = <String>{};

Finder _field(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

String _typed(WidgetTester tester, String key) =>
    tester.widget<EditableText>(_field(key)).controller.text;

/// Whether the filled button labelled [label] is enabled.
bool _enabled(WidgetTester tester, String label) {
  final button = find.widgetWithText(FilledButton, label);
  expect(button, findsWidgets, reason: 'no "$label" button');
  return tester.widget<FilledButton>(button.first).onPressed != null;
}

/// Goes offline/online and lets every listener react.
Future<void> _connection(
  WidgetTester tester,
  Journey j, {
  required bool online,
}) async {
  j.network.setOnline(online);
  await settle(tester);
}

Future<void> walkOffline(
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

  await _signInOfflineAndBack(tester, j, l: l, locale: locale);
  await _notificationsOffline(tester, j, l: l);
  await _learnAndQuizOffline(tester, j, l: l, locale: locale);
  await _accountWritesOffline(tester, j, l: l);

  expect(j.exits, isEmpty);
  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'offline $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}

// ---------------------------------------------------------------------------
// 1. A screen that asks for something: banner + disabled action
// ---------------------------------------------------------------------------

Future<void> _signInOfflineAndBack(
  WidgetTester tester,
  Journey j, {
  required AppLocalizations l,
  required String locale,
}) async {
  await tapOn(tester, find.text(l.logIn));
  expect(j.location, '/login');
  expect(find.text(l.offline), findsNothing, reason: 'online: no banner');

  // --- Login offline ---------------------------------------------------------------
  await _connection(tester, j, online: false);
  expect(find.text(l.offline), findsOneWidget, reason: 'the banner');
  await tester.enterText(find.byType(TextField), journeyPhone);
  await settle(tester, const Duration(milliseconds: 200));
  expect(_enabled(tester, l.sendOtp), isFalse, reason: 'Send OTP is disabled');
  await tapOn(tester, find.text(l.sendOtp));
  expect(j.location, '/login');
  expect(j.requests.count('POST', '/auth/otp/request'), 0);

  // Coming back online lifts the banner and the lock by itself.
  await _connection(tester, j, online: true);
  expect(find.text(l.offline), findsNothing);
  expect(_enabled(tester, l.sendOtp), isTrue);
  await tapOn(tester, find.text(l.sendOtp));
  await pumpUntil(tester, find.byType(OtpScreen), journey: j);
  expect(j.requests.count('POST', '/auth/otp/request'), 1);

  // --- OTP offline -----------------------------------------------------------------
  await _connection(tester, j, online: false);
  expect(find.text(l.offline), findsOneWidget);
  await enterOtp(tester, otpSchool);
  // The sixth digit would normally auto-submit: offline it does not, and the
  // button says so.
  expect(j.requests.count('POST', '/auth/otp/verify'), 0);
  expect(_enabled(tester, l.verify), isFalse);
  expect(j.location, '/login/otp');
  expect(j.storage.hasSession, isFalse);

  await _connection(tester, j, online: true);
  expect(find.text(l.offline), findsNothing);
  expect(_enabled(tester, l.verify), isTrue, reason: 'the code is still there');
  await tapOn(tester, find.text(l.verify));
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  expect(j.requests.count('POST', '/auth/otp/verify'), 1);
  await tapOn(tester, find.text(l.continueLabel));
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home');
}

// ---------------------------------------------------------------------------
// 2. A screen that loads data: offline state + explicit Retry
// ---------------------------------------------------------------------------

Future<void> _notificationsOffline(
  WidgetTester tester,
  Journey j, {
  required AppLocalizations l,
}) async {
  await _connection(tester, j, online: false);
  await tapOn(tester, find.byKey(const Key('home_bell')));
  await pumpUntil(tester, find.byType(NotificationsScreen), journey: j);
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/notifications');
  expect(find.text(l.retry), findsOneWidget, reason: 'the offline state');
  expect(find.text(l.offline), findsWidgets);
  expect(j.requests.count('GET', '/me/notifications'), 1);

  // Retry while still offline fails again, visibly.
  await tapOn(tester, find.text(l.retry));
  await settle(tester, const Duration(seconds: 1));
  expect(j.requests.count('GET', '/me/notifications'), 2);
  expect(find.text(l.retry), findsOneWidget);

  // Back online nothing happens by itself: the student asks.
  await _connection(tester, j, online: true);
  expect(
    j.requests.count('GET', '/me/notifications'),
    2,
    reason: 'no silent retry',
  );
  await tapOn(tester, find.text(l.retry));
  await pumpUntil(
    tester,
    find.byKey(const Key('notification_chip_all')),
    journey: j,
  );
  await settle(tester, const Duration(seconds: 1));
  expect(j.requests.count('GET', '/me/notifications'), 3);
  expect(find.text(l.retry), findsNothing);
  expect(find.text(l.offline), findsNothing);

  await tapBackChip(tester, key: const Key('notifications_back'));
  expect(j.location, '/home');
}

Future<void> _learnAndQuizOffline(
  WidgetTester tester,
  Journey j, {
  required AppLocalizations l,
  required String locale,
}) async {
  // --- Learn, offline from the first tap -----------------------------------------------
  await _connection(tester, j, online: false);
  await tapOn(tester, find.text(l.navLearn).last);
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/learn');
  expect(find.text('الأحياء'), findsNothing);
  expect(find.text(l.retry), findsOneWidget);
  await expectTappable(
    tester,
    find.text(l.retry),
    reason: 'the Learn offline Retry must be reachable',
  );
  expect(j.requests.count('GET', '/catalog/subjects'), 1);

  await _connection(tester, j, online: true);
  expect(
    j.requests.count('GET', '/catalog/subjects'),
    1,
    reason: 'no silent retry on reconnect',
  );
  await tapOn(tester, find.text(l.retry));
  await pumpUntil(tester, find.text('الأحياء'), journey: j);
  expect(j.requests.count('GET', '/catalog/subjects'), 2);

  // --- A subject, offline ------------------------------------------------------------------
  await _connection(tester, j, online: false);
  await tapOn(tester, find.text('الأحياء'));
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/learn/subject/sub-bio');
  expect(find.text(l.retry), findsOneWidget);
  await expectTappable(
    tester,
    find.text(l.retry),
    reason: 'the subject offline Retry must be reachable',
  );
  // The back chip needs no network.
  await tapBackChip(tester);
  expect(j.location, '/learn');
  await tapOn(tester, find.text('الأحياء'));
  await settle(tester, const Duration(seconds: 1));
  await _connection(tester, j, online: true);
  await tapOn(tester, find.text(l.retry));
  await pumpUntil(tester, find.text('الوحدة الأولى'), journey: j);

  // --- Down to a quiz setup (the tree is cached: no more requests) ---------------------------
  await tapOn(tester, find.text('الوحدة الأولى'));
  await tapOn(tester, find.text('الفصل الأول'));
  await tapOn(tester, find.text('الدرس الثاني'));
  await pumpUntil(tester, find.byType(QuizSetupScreen), journey: j);
  await tapOn(tester, find.text(l.quizSizeOption(10)));

  // Start is disabled offline and sends nothing.
  await _connection(tester, j, online: false);
  expect(find.text(l.offline), findsOneWidget);
  expect(_enabled(tester, l.startLearning), isFalse);
  await tapOn(tester, find.text(l.startLearning));
  expect(j.requests.count('POST', '/quizzes'), 0);
  expect(j.location, '/quiz/setup');
  await _connection(tester, j, online: true);
  expect(_enabled(tester, l.startLearning), isTrue);
  await tapOn(tester, find.text(l.startLearning));
  await pumpUntil(tester, find.byType(QuizScreen), journey: j);
  expect(j.requests.count('POST', '/quizzes'), 1);

  // --- An answer that cannot be sent: kept, flagged, retried by the student -------------------
  await pumpUntil(tester, find.text(l.questionLabel(1)), journey: j);
  final option = 'الخيار رقم ${mockCorrectOption(1)} للسؤال 1';
  await tapOn(tester, find.text(option));
  await _connection(tester, j, online: false);
  await tapOn(tester, find.text(l.confirm));
  expect(j.requests.count('POST', '/quizzes/quiz-1/answers'), 1);
  expect(find.text(l.offline), findsOneWidget, reason: 'the inline error');
  expect(find.text(l.retry), findsOneWidget);
  expect(find.text(l.next), findsNothing, reason: 'it was not accepted');
  expect(find.text(option), findsOneWidget, reason: 'the question is kept');
  expect(j.location, '/quiz/quiz-1');

  // Retry while offline fails again; the question is still there.
  await tapOn(tester, find.text(l.retry));
  await settle(tester, const Duration(seconds: 1));
  expect(j.requests.count('POST', '/quizzes/quiz-1/answers'), 2);
  expect(find.text(l.retry), findsOneWidget);
  expect(find.text(l.next), findsNothing);

  // Back online, Retry sends it and the quiz moves on.
  await _connection(tester, j, online: true);
  await tapOn(tester, find.text(l.retry));
  await pumpUntil(tester, find.text(l.next), journey: j);
  expect(j.requests.count('POST', '/quizzes/quiz-1/answers'), 3);
  expect(find.text(l.retry), findsNothing);
  expect(find.text(l.offline), findsNothing);
  expect(find.text(l.quizProgress(1, 10)), findsOneWidget);

  // Leaving the quiz needs no network either.
  await _connection(tester, j, online: false);
  await tapOn(tester, find.byKey(const Key('quiz_close')));
  await tapOn(tester, find.text(l.exitQuizLeave));
  expect(j.location, '/quiz/setup');
  await tapBackChip(tester, key: const Key('quiz_setup_back'));
  await _connection(tester, j, online: true);
}

// ---------------------------------------------------------------------------
// 3. A write: attempted, fails with the offline copy, loses nothing
// ---------------------------------------------------------------------------

Future<void> _accountWritesOffline(
  WidgetTester tester,
  Journey j, {
  required AppLocalizations l,
}) async {
  await tapOn(tester, find.text(l.navAccount).last);
  expect(find.byType(ProfileScreen), findsOneWidget);

  // --- Edit Profile: Save offline -------------------------------------------------------------
  await tapOn(tester, find.byKey(const Key('profile_edit_button')));
  await tester.enterText(_field('edit_name_field'), 'Offline Student');
  await settle(tester, const Duration(milliseconds: 200));
  await _connection(tester, j, online: false);
  await tapOn(tester, find.text(l.saveChanges));
  expect(j.requests.count('PATCH', '/me'), 1, reason: 'attempted');
  expect(j.location, '/profile/edit', reason: 'a failed Save stays put');
  expect(find.text(l.offline), findsWidgets);
  expect(_typed(tester, 'edit_name_field'), 'Offline Student');
  await _connection(tester, j, online: true);
  await tapOn(tester, find.text(l.saveChanges));
  await pumpUntil(tester, find.byType(ProfileScreen), journey: j);
  expect(j.location, '/account');
  expect(j.requests.count('PATCH', '/me'), 2);
  expect(find.text('Offline Student'), findsWidgets);

  // --- Settings: a privacy switch offline ----------------------------------------------------------
  await tapOn(tester, find.byKey(const Key('profile_row_settings')));
  final leaderboard = find.byKey(const Key('settings_leaderboard_visible'));
  bool shown() => (tester.widget(leaderboard) as dynamic).value as bool;
  final before = shown();
  await _connection(tester, j, online: false);
  await tapOn(tester, leaderboard);
  expect(j.requests.count('PATCH', '/me'), 3, reason: 'attempted');
  expect(shown(), before, reason: 'the switch shows the SERVER\'s value');
  expect(find.byKey(const Key('settings_rank_error')), findsOneWidget);
  await _connection(tester, j, online: true);
  await tapOn(tester, leaderboard);
  expect(shown(), !before);
  expect(find.byKey(const Key('settings_rank_error')), findsNothing);
  await tapBackChip(tester, key: const Key('settings_back'));

  // --- Support: the list, a new ticket and a reply, all offline first -----------------------------
  await _connection(tester, j, online: false);
  await tapOn(tester, find.byKey(const Key('profile_row_support')));
  await settle(tester, const Duration(seconds: 1));
  expect(j.location, '/support');
  expect(find.text(l.retry), findsOneWidget);
  await tapOn(tester, find.byKey(const Key('support_create_card')));
  await tester.enterText(_field('support_subject_field'), 'Offline ticket');
  await tester.enterText(_field('support_details_field'), 'Written offline.');
  await tapOn(tester, find.byKey(const Key('support_submit')));
  expect(j.requests.count('POST', '/support/tickets'), 1, reason: 'attempted');
  expect(j.location, '/support/new');
  expect(find.text(l.offline), findsWidgets);
  expect(_typed(tester, 'support_subject_field'), 'Offline ticket');
  expect(_typed(tester, 'support_details_field'), 'Written offline.');
  await _connection(tester, j, online: true);
  await tapOn(tester, find.byKey(const Key('support_submit')));
  await pumpUntil(tester, find.byType(SupportTicketScreen), journey: j);
  final ticket = mock.mockSupportTicketId(mock.kMockSupportTicketCount + 1);
  expect(j.location, '/support/tickets/$ticket');
  expect(j.requests.count('POST', '/support/tickets'), 2);

  await pumpUntil(
    tester,
    find.byKey(const Key('support_composer_field')),
    journey: j,
  );
  await tester.enterText(_field('support_composer_field'), 'A reply offline');
  await settle(tester, const Duration(milliseconds: 200));
  await _connection(tester, j, online: false);
  await tapOn(tester, find.byKey(const Key('support_send')));
  expect(j.requests.count('POST', '/support/tickets/$ticket/messages'), 1);
  expect(find.byKey(const Key('support_send_error')), findsOneWidget);
  expect(_typed(tester, 'support_composer_field'), 'A reply offline');
  await _connection(tester, j, online: true);
  await tapOn(tester, find.byKey(const Key('support_send')));
  await pumpUntil(tester, find.text('A reply offline'), journey: j);
  expect(j.requests.count('POST', '/support/tickets/$ticket/messages'), 2);
  expect(find.byKey(const Key('support_send_error')), findsNothing);
  expect(_typed(tester, 'support_composer_field'), isEmpty);

  // Out, with the connection back: thread -> list -> hub.
  await tapBackChip(tester, key: const Key('support_thread_back'));
  expect(j.location, '/support');
  await tapBackChip(tester, key: const Key('support_back'));
  expect(j.location, '/account');
}
