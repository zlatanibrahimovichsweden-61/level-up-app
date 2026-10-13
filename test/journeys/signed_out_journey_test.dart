import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:pinput/pinput.dart';

import 'journey_harness.dart';

/// Journey 1: signed out, cold start to Home.
///
/// onboarding -> language switch -> Login -> a bad number is refused on the
/// device (no request leaves) -> a good number -> OTP -> the mock's success
/// code -> the success view -> Continue -> Home.
///
/// Run in EN and AR (the journey itself switches language once, so each run
/// exercises both), in the dark canvas, and at 2.0x text scale.
void main() {
  setUpAll(loadJourneyFonts);

  for (final start in journeyLocales) {
    journeyTest('signed-out journey, starting in $start', (tester) async {
      await walkSignedOut(tester, start: start);
    });
  }

  for (final start in journeyLocales) {
    journeyTest('signed-out journey in the dark canvas, starting in $start', (
      tester,
    ) async {
      await walkSignedOut(tester, start: start, theme: ThemeMode.dark);
    });
  }

  // 2.0x is the OS's largest text size. The journey must still be COMPLETABLE
  // (every control reachable and working); layout overflows are collected and
  // held to the ratchet below rather than failing on their first appearance.
  for (final start in journeyLocales) {
    journeyTest('signed-out journey at 2.0x text, starting in $start', (
      tester,
    ) async {
      await walkSignedOut(
        tester,
        start: start,
        textScale: 2.0,
        knownOverflows: knownOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. See the defect list in the journey report; a NEW origin fails.
const knownOverflowsAtTwoTimes = <String>{};

Future<void> walkSignedOut(
  WidgetTester tester, {
  required String start,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Size size = pixel8,
  Set<String> knownOverflows = const {},
}) async {
  final other = start == 'en' ? 'ar' : 'en';
  final from = l10nFor(start);
  final to = l10nFor(other);

  final j = await bootJourney(
    tester,
    locale: start,
    theme: theme,
    textScale: textScale,
    size: size,
  );

  // --- Onboarding --------------------------------------------------------
  expect(j.auth, isA<AuthUnauthenticated>());
  expect(find.byType(OnboardingScreen), findsOneWidget);
  expect(j.location, '/');
  expect(find.text(from.getStarted), findsOneWidget);
  expect(
    directionOf(tester),
    start == 'ar' ? TextDirection.rtl : TextDirection.ltr,
  );
  expect(
    brightnessOf(tester),
    theme == ThemeMode.dark ? Brightness.dark : Brightness.light,
  );
  expect(textScaleOf(tester), textScale);
  // Nothing was requested just to look at onboarding.
  expect(j.requests.entries, isEmpty);

  // --- The language pill shows the OTHER language and flips it -----------
  await tapOn(tester, find.text(from.switchLanguage));
  expect(j.container.read(localeProvider).languageCode, other);
  expect(find.text(to.getStarted), findsOneWidget);
  expect(find.text(from.getStarted), findsNothing);
  expect(
    directionOf(tester),
    other == 'ar' ? TextDirection.rtl : TextDirection.ltr,
  );
  expect(j.location, '/', reason: 'a language flip is not a navigation');

  // --- Log In ------------------------------------------------------------
  await tapOn(tester, find.text(to.logIn));
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(find.text(to.loginSubtitle), findsOneWidget);

  // --- A bad number: the error shows, nothing is sent --------------------
  final field = find.byType(TextField);
  await tester.enterText(field, '123');
  await tapOn(tester, find.text(to.sendOtp));
  expect(find.text(to.invalidPhone), findsOneWidget);
  expect(j.location, '/login');
  expect(
    j.requests.count('POST', '/auth/otp/request'),
    0,
    reason: 'an invalid number must be refused before any request',
  );

  // An EMPTY field is refused the same way.
  await tester.enterText(field, '');
  await tapOn(tester, find.text(to.sendOtp));
  expect(find.text(to.invalidPhone), findsOneWidget);
  expect(j.requests.count('POST', '/auth/otp/request'), 0);

  // The "Create New Account" button shares the first step and the guard.
  await tapOn(tester, find.text(to.createNewAccount));
  expect(find.text(to.invalidPhone), findsOneWidget);
  expect(j.requests.count('POST', '/auth/otp/request'), 0);

  // --- A good number goes to the OTP screen ------------------------------
  await tester.enterText(field, journeyPhone);
  await tapOn(tester, find.text(to.sendOtp));
  await pumpUntil(tester, find.byType(OtpScreen), journey: j);
  expect(j.location, '/login/otp');
  expect(j.requests.count('POST', '/auth/otp/request'), 1);
  expect(j.requests.count('POST', '/auth/otp/verify'), 0);
  expect(find.text(to.checkOtpTitle), findsOneWidget);

  // --- A wrong code: refused by the server, inline, entry stays live -----
  await tester.enterText(find.byType(Pinput), otpInvalid);
  await pumpUntil(tester, find.text(to.errorOtpInvalid), journey: j);
  expect(j.requests.count('POST', '/auth/otp/verify'), 1);
  expect(j.location, '/login/otp');
  expect(j.storage.hasSession, isFalse);
  expect(j.auth, isA<AuthUnauthenticated>());
  // Unlike a banned account, a wrong code locks nothing.
  expect(tester.widget<Pinput>(find.byType(Pinput)).enabled, isTrue);
  expect(find.text(to.errorAccountBanned), findsNothing);

  // --- Resend: locked while the countdown runs, live after it -------------
  final resend = find.widgetWithText(TextButton, to.resendOtp);
  expect(tester.widget<TextButton>(resend).onPressed, isNull);
  expect(j.requests.count('POST', '/auth/otp/request'), 1);
  await tester.pump(const Duration(seconds: 61));
  expect(tester.widget<TextButton>(resend).onPressed, isNotNull);
  await tapOn(tester, resend);
  expect(j.requests.count('POST', '/auth/otp/request'), 2);
  expect(
    tester.widget<TextButton>(resend).onPressed,
    isNull,
    reason: 'a resend starts a fresh countdown',
  );
  expect(
    find.text(to.errorOtpInvalid),
    findsNothing,
    reason: 'asking for a new code clears the old complaint',
  );

  // --- The mock's success code, replacing the wrong one --------------------
  await tester.enterText(find.byType(Pinput), '');
  await tester.enterText(find.byType(Pinput), otpSchool);
  await pumpUntil(tester, find.text(to.otpSuccessTitle), journey: j);
  expect(j.requests.count('POST', '/auth/otp/verify'), 2);
  expect(j.storage.hasSession, isTrue);
  expect(j.auth, isA<AuthAuthenticated>());
  expect(
    j.location,
    '/login/otp',
    reason: 'the success view is shown before the student continues',
  );

  // --- Continue lands on Home --------------------------------------------
  await tapOn(tester, find.text(to.continueLabel));
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home');
  // Home is powered by the server: /me was fetched, and nothing was computed
  // on the device.
  expect(j.requests.count('GET', '/me'), greaterThanOrEqualTo(1));

  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'signed-out $start/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
