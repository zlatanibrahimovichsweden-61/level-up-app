import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/dev/mock_support.dart' as mock;
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_result_screen.dart';
import 'package:level_up_app/features/quiz/screens/quiz_screen.dart';

import 'journey_harness.dart';

/// A student on a slow connection taps twice. Every action below puts a request
/// on the wire; a second tap while the first is still in flight (the mock
/// answers after [journeyLatency] of fake time) must not send a second one.
///
/// The second tap lands one frame (16 ms) after the first: as fast as a finger
/// can double-tap, with the first request still in flight (the mock answers 30 ms
/// later), so the screen has had exactly one chance to rebuild.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('a double tap sends one request, in $locale', (tester) async {
      await walkDoubleTaps(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('two taps in the same frame send one OTP request, in $locale', (
      tester,
    ) async {
      await walkSameFrameSendOtp(tester, locale: locale);
    });
  }
}

Finder _field(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

/// Taps [finder] twice, one frame apart, then lets the app react.
Future<void> doubleTap(WidgetTester tester, Finder finder) async {
  await settle(tester, const Duration(milliseconds: 300));
  await tester.ensureVisible(finder.first);
  await settle(tester, const Duration(milliseconds: 300));
  // The same SPOT twice, like a finger: the control may have turned into a
  // spinner by the second tap, so it cannot be looked up again.
  final spot = tester.getCenter(finder.first);
  await tester.tapAt(spot);
  await tester.pump(const Duration(milliseconds: 16));
  await tester.tapAt(spot);
  await settle(tester, const Duration(seconds: 1));
}

/// Two taps delivered in the SAME frame - no frame between them, so the button
/// has not yet been rebuilt as a spinner and only the notifier can refuse the
/// second (input queued behind a janky frame, assistive tap automation). A
/// stricter case than [doubleTap], whose second tap lands a frame later.
Future<void> sameFrameTaps(WidgetTester tester, Finder finder) async {
  await settle(tester, const Duration(milliseconds: 300));
  await tester.ensureVisible(finder.first);
  await settle(tester, const Duration(milliseconds: 300));
  final spot = tester.getCenter(finder.first);
  await tester.tapAt(spot);
  await tester.tapAt(spot);
  await settle(tester, const Duration(seconds: 1));
}

/// Send OTP requests ONE code when it is tapped twice in the same frame.
Future<void> walkSameFrameSendOtp(
  WidgetTester tester, {
  required String locale,
  double textScale = 1.0,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await bootJourney(
    tester,
    locale: locale,
    textScale: textScale,
    size: size,
  );

  await tapOn(tester, find.text(l.logIn));
  await tester.enterText(find.byType(TextField), journeyPhone);
  await sameFrameTaps(tester, find.text(l.sendOtp));
  expect(j.location, '/login/otp');
  expect(
    j.requests.count('POST', '/auth/otp/request'),
    1,
    reason: 'two taps in one frame on Send OTP must request ONE code',
  );

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'same-frame-send-otp $locale/${textScale}x',
  );
  await tapBackChip(tester);
  await endJourney(tester);
}

Future<void> walkDoubleTaps(
  WidgetTester tester, {
  required String locale,
  double textScale = 1.0,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final l = l10nFor(locale);
  final j = await bootJourney(
    tester,
    locale: locale,
    textScale: textScale,
    size: size,
  );

  // --- Send OTP -------------------------------------------------------------------
  await tapOn(tester, find.text(l.logIn));
  await tester.enterText(find.byType(TextField), journeyPhone);
  await doubleTap(tester, find.text(l.sendOtp));
  expect(j.location, '/login/otp');
  expect(
    j.requests.count('POST', '/auth/otp/request'),
    1,
    reason: 'a double tap on Send OTP must request ONE code',
  );

  // --- Verify: the sixth digit auto-submits; the button is a second path ------------
  await enterOtp(tester, otpSchool);
  expect(j.requests.count('POST', '/auth/otp/verify'), 1);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  await doubleTap(tester, find.text(l.continueLabel));
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home');

  // --- Save profile -------------------------------------------------------------------
  await tapOn(tester, find.text(l.navAccount).last);
  await tapOn(tester, find.byKey(const Key('profile_edit_button')));
  await tester.enterText(_field('edit_name_field'), 'Double Tap Student');
  await doubleTap(tester, find.text(l.saveChanges));
  expect(
    j.requests.count('PATCH', '/me'),
    1,
    reason: 'a double tap on Save must send ONE write',
  );
  await settle(tester);
  expect(j.location, '/account', reason: 'one Save, one pop');

  // --- Create a support ticket, then reply -----------------------------------------------
  await tapOn(tester, find.byKey(const Key('profile_row_support')));
  await pumpUntil(
    tester,
    find.byKey(const Key('support_create_card')),
    journey: j,
  );
  await tapOn(tester, find.byKey(const Key('support_create_card')));
  await tester.enterText(_field('support_subject_field'), 'Double tap');
  await tester.enterText(_field('support_details_field'), 'Tapped twice.');
  await doubleTap(tester, find.byKey(const Key('support_submit')));
  expect(
    j.requests.count('POST', '/support/tickets'),
    1,
    reason: 'a double tap on Submit must open ONE ticket',
  );
  final newTicket = mock.mockSupportTicketId(mock.kMockSupportTicketCount + 1);
  await settle(tester);
  expect(j.location, '/support/tickets/$newTicket');

  await tester.enterText(_field('support_composer_field'), 'One reply.');
  await settle(tester, const Duration(milliseconds: 200));
  await doubleTap(tester, find.byKey(const Key('support_send')));
  expect(
    j.requests.count('POST', '/support/tickets/$newTicket/messages'),
    1,
    reason: 'a double tap on Send must post ONE reply',
  );
  await tapBackChip(tester, key: const Key('support_thread_back'));
  await tapBackChip(tester, key: const Key('support_back'));

  // --- A quiz: start, confirm an answer, finish -----------------------------------------
  await tapOn(tester, find.text(l.navLearn).last);
  await pumpUntil(tester, find.text('الأحياء'), journey: j);
  await tapOn(tester, find.text('الأحياء'));
  await pumpUntil(tester, find.text('الوحدة الأولى'), journey: j);
  await tapOn(tester, find.text('الوحدة الأولى'));
  await tapOn(tester, find.text('الفصل الأول'));
  await tapOn(tester, find.text('الدرس الثاني'));
  await tapOn(tester, find.text(l.quizSizeOption(10)));
  await doubleTap(tester, find.text(l.startLearning));
  await pumpUntil(tester, find.byType(QuizScreen), journey: j);
  expect(
    j.requests.count('POST', '/quizzes'),
    1,
    reason: 'a double tap on Start must create ONE quiz',
  );
  expect(j.location, '/quiz/quiz-1', reason: 'one Start, one quiz screen');

  await pumpUntil(tester, find.text(l.questionLabel(1)), journey: j);
  await tapOn(tester, find.text('الخيار رقم ${mockCorrectOption(1)} للسؤال 1'));
  await doubleTap(tester, find.text(l.confirm));
  expect(
    j.requests.count('POST', '/quizzes/quiz-1/answers'),
    1,
    reason: 'a double tap on Confirm must submit ONE answer',
  );

  // Play on to the last question, then double-tap Finish.
  await tapOn(tester, find.text(l.next));
  for (var i = 2; i <= 10; i++) {
    await pumpUntil(tester, find.text(l.questionLabel(i)), journey: j);
    await tapOn(
      tester,
      find.text('الخيار رقم ${mockCorrectOption(i)} للسؤال $i'),
    );
    await tapOn(tester, find.text(l.confirm));
    await pumpUntil(
      tester,
      find.text(i == 10 ? l.finishQuiz : l.next),
      journey: j,
    );
    if (i < 10) await tapOn(tester, find.text(l.next));
  }
  await doubleTap(tester, find.text(l.finishQuiz));
  await pumpUntil(tester, find.byType(QuizResultScreen), journey: j);
  expect(
    j.requests.count('POST', '/quizzes/quiz-1/finish'),
    1,
    reason: 'a double tap on Finish must finish the quiz ONCE',
  );
  expect(j.location, '/quiz/quiz-1/result');

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'double-tap $locale/${textScale}x',
  );
  await endJourney(tester);
}
