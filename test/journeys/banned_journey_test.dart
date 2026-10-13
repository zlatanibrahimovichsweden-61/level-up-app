import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/core/widgets/elevation/primary_cta.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import 'journey_harness.dart';

/// Journey 8: the banned account (`403 account_banned`).
///
/// The mock answers its banned code (`222222`) the way the contract describes
/// `verifyOtp`: the code was correct, it is consumed, NO tokens and NO session
/// are issued, and the client must not retry. The journey walks the screen a
/// banned student actually meets and asserts, through the real app, that:
///
///  - the one inline error line carries the contract copy (a live region, and
///    NOT the red-box `otp_invalid` styling);
///  - code entry is locked (the cells, and pinput's programmatic
///    `onCompleted` path) and Resend is gone - a banned student can send the
///    server exactly one `verify`, whatever they tap;
///  - nothing signs the student in (no tokens written, no `/me`, auth stays
///    signed out);
///  - every way out (the "Back to login" CTA, the back chip, the OS Back) lands
///    on Login; and the lock belongs to that OTP screen, not to the app: the
///    next code request is a fresh, working screen that a non-banned code can
///    sign in through.
///
/// Run in EN and AR, in the dark canvas, at 2.0x text, and with the Resend
/// control already live (the 60 s countdown elapsed) when the ban lands.
void main() {
  setUpAll(loadJourneyFonts);

  for (final locale in journeyLocales) {
    journeyTest('banned account in $locale', (tester) async {
      await walkBanned(tester, locale: locale);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('banned account with Resend already live, in $locale', (
      tester,
    ) async {
      await walkBanned(tester, locale: locale, resendLive: true);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('banned account in the dark canvas in $locale', (tester) async {
      await walkBanned(tester, locale: locale, theme: ThemeMode.dark);
    });
  }

  for (final locale in journeyLocales) {
    journeyTest('banned account at 2.0x text in $locale', (tester) async {
      await walkBanned(
        tester,
        locale: locale,
        textScale: 2.0,
        knownOverflows: knownBannedOverflowsAtTwoTimes,
      );
    });
  }
}

/// Overflow origins already recorded as defects for this journey at 2.0x text
/// scale. A NEW origin fails.
const knownBannedOverflowsAtTwoTimes = <String>{};

/// From onboarding or Login to an OTP screen that has just been asked for a
/// code. Returns the request count so far.
Future<void> _toOtp(
  WidgetTester tester,
  Journey j, {
  required String locale,
}) async {
  if (j.location == '/') {
    await tapOn(tester, find.text(l10nFor(locale).logIn));
  }
  await requestOtpViaUi(tester, j, locale: locale);
  expect(j.location, '/login/otp');
}

/// Enters the mock's banned code and waits for the banned line.
Future<void> _getBanned(
  WidgetTester tester,
  Journey j, {
  required AppLocalizations l,
}) async {
  await enterOtp(tester, otpBanned);
  await pumpUntil(tester, find.text(l.errorAccountBanned), journey: j);
}

/// Every claim about the banned state, in one place so each exit re-checks it.
void _expectBannedState(
  WidgetTester tester,
  Journey j, {
  required AppLocalizations l,
  required int verifyCount,
  required int otpRequestCount,
}) {
  // The contract copy, once, in the one error line - not the wrong-code copy.
  expect(find.text(l.errorAccountBanned), findsOneWidget);
  expect(find.text(l.errorOtpInvalid), findsNothing);
  // ... announced to a screen reader, since nothing else says the cells locked.
  expect(
    tester
        .getSemantics(find.text(l.errorAccountBanned))
        .flagsCollection
        .isLiveRegion,
    isTrue,
    reason: 'the banned line must be a live region',
  );

  // Code entry is locked.
  final pinput = tester.widget<Pinput>(find.byType(Pinput));
  expect(pinput.enabled, isFalse);
  expect(pinput.focusNode!.hasFocus, isFalse);
  expect(
    tester
        .widget<EditableText>(
          find.descendant(
            of: find.byType(Pinput),
            matching: find.byType(EditableText),
          ),
        )
        .readOnly,
    isTrue,
  );

  // Resend is gone, Verify is replaced by the existing "Back to login" CTA.
  expect(find.text(l.resendOtp), findsNothing);
  expect(find.byType(TextButton), findsNothing);
  expect(find.text(l.verify), findsNothing);
  final backToLogin = find.descendant(
    of: find.byType(PrimaryCta),
    matching: find.widgetWithText(FilledButton, l.backToLogin),
  );
  expect(backToLogin, findsOneWidget);
  expect(tester.widget<FilledButton>(backToLogin).onPressed, isNotNull);

  // No success view, no session, nothing fetched on a student's behalf.
  expect(find.text(l.otpSuccessTitle), findsNothing);
  expect(find.text(l.continueLabel), findsNothing);
  expect(j.auth, isA<AuthUnauthenticated>());
  expect(j.storage.hasSession, isFalse);
  expect(j.storage.writeTokensCalls, 0);
  expect(j.requests.count('GET', '/me'), 0);
  expect(j.location, '/login/otp');

  // The server was asked exactly once to verify and never to resend.
  expect(j.requests.count('POST', '/auth/otp/verify'), verifyCount);
  expect(j.requests.count('POST', '/auth/otp/request'), otpRequestCount);
}

Future<void> walkBanned(
  WidgetTester tester, {
  required String locale,
  ThemeMode theme = ThemeMode.light,
  double textScale = 1.0,
  Size size = pixel8,
  bool resendLive = false,
  Set<String> knownOverflows = const {},
}) async {
  final semantics = tester.ensureSemantics();
  final other = locale == 'en' ? 'ar' : 'en';
  final l = l10nFor(locale);
  final lOther = l10nFor(other);

  final j = await bootJourney(
    tester,
    locale: locale,
    theme: theme,
    textScale: textScale,
    size: size,
  );

  // === Pass 1: ban, flip the language, leave by the back chip ================
  await _toOtp(tester, j, locale: locale);
  expect(j.requests.count('POST', '/auth/otp/request'), 1);

  // Before the ban the OTP screen is the ordinary one: entry live, Verify and
  // Resend there, the countdown still running unless this run waits it out.
  expect(tester.widget<Pinput>(find.byType(Pinput)).enabled, isTrue);
  expect(find.text(l.verify), findsOneWidget);
  final resendButton = find.widgetWithText(TextButton, l.resendOtp);
  expect(resendButton, findsOneWidget);
  if (resendLive) {
    // The mock's countdown is 60 s; let it run out, so Resend is a LIVE
    // control at the moment the ban lands (the case that makes "no resend
    // afterwards" mean something).
    await tester.pump(const Duration(seconds: 61));
    expect(
      tester.widget<TextButton>(resendButton).onPressed,
      isNotNull,
      reason: 'Resend is live once the countdown elapsed',
    );
  } else {
    expect(
      tester.widget<TextButton>(resendButton).onPressed,
      isNull,
      reason: 'Resend is not live during the countdown',
    );
  }
  expect(find.text(l.errorAccountBanned), findsNothing);
  expect(
    find.descendant(
      of: find.byType(PrimaryCta),
      matching: find.text(l.backToLogin),
    ),
    findsNothing,
  );

  await _getBanned(tester, j, l: l);
  _expectBannedState(tester, j, l: l, verifyCount: 1, otpRequestCount: 1);

  // A fresh 6-digit value fires pinput's onCompleted even while it is disabled
  // (a programmatic change), and tapping the dead cells does nothing: neither
  // reaches the server.
  tester.widget<Pinput>(find.byType(Pinput)).controller!.text = '654321';
  await settle(tester);
  await tester.tap(find.byType(Pinput), warnIfMissed: false);
  await settle(tester);
  _expectBannedState(tester, j, l: l, verifyCount: 1, otpRequestCount: 1);

  // Time passing changes nothing: no countdown restarts, Resend does not return.
  await tester.pump(const Duration(seconds: 90));
  _expectBannedState(tester, j, l: l, verifyCount: 1, otpRequestCount: 1);

  // The language pill re-localises the banned state and it stays locked.
  await tapOn(tester, find.text(l.switchLanguage));
  expect(find.text(lOther.errorAccountBanned), findsOneWidget);
  expect(find.text(l.errorAccountBanned), findsNothing);
  _expectBannedState(tester, j, l: lOther, verifyCount: 1, otpRequestCount: 1);
  // ... and back again, so the rest of the run is in the language it started.
  await tapOn(tester, find.text(lOther.switchLanguage));
  _expectBannedState(tester, j, l: l, verifyCount: 1, otpRequestCount: 1);

  // The back chip leaves a banned screen: back to Login, nothing signed in.
  await tapBackChip(tester);
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(find.byType(OtpScreen), findsNothing);
  expect(j.auth, isA<AuthUnauthenticated>());
  expect(j.storage.hasSession, isFalse);

  // === Pass 2: the lock belongs to the screen; the OS Back leaves it ==========
  await requestOtpViaUi(tester, j, locale: locale);
  expect(j.requests.count('POST', '/auth/otp/request'), 2);
  expect(
    tester.widget<Pinput>(find.byType(Pinput)).enabled,
    isTrue,
    reason: 'a new OTP screen is not banned until the server says so',
  );
  expect(find.text(l.errorAccountBanned), findsNothing);
  expect(find.text(l.verify), findsOneWidget);
  await _getBanned(tester, j, l: l);
  _expectBannedState(tester, j, l: l, verifyCount: 2, otpRequestCount: 2);
  expect(await systemBack(tester, j), isFalse, reason: 'the app handled it');
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(j.exits, isEmpty);

  // === Pass 3: the "Back to login" CTA =========================================
  await requestOtpViaUi(tester, j, locale: locale);
  await _getBanned(tester, j, l: l);
  _expectBannedState(tester, j, l: l, verifyCount: 3, otpRequestCount: 3);
  await tapOn(
    tester,
    find.descendant(
      of: find.byType(PrimaryCta),
      matching: find.widgetWithText(FilledButton, l.backToLogin),
    ),
  );
  expect(j.location, '/login');
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(find.byType(OtpScreen), findsNothing);
  expect(find.text(l.otpSuccessTitle), findsNothing);
  expect(j.auth, isA<AuthUnauthenticated>());
  expect(j.storage.hasSession, isFalse);
  expect(j.storage.writeTokensCalls, 0);

  // === Pass 4: the app is not stuck: a good code still signs in ================
  await requestOtpViaUi(tester, j, locale: locale);
  expect(j.requests.count('POST', '/auth/otp/request'), 4);
  expect(find.text(l.errorAccountBanned), findsNothing);
  await enterOtp(tester, otpSchool);
  await pumpUntil(tester, find.text(l.otpSuccessTitle), journey: j);
  expect(j.storage.hasSession, isTrue);
  expect(j.storage.writeTokensCalls, 1, reason: 'only the good code wrote');
  expect(j.auth, isA<AuthAuthenticated>());
  // The success view drops the back chip (there is nothing to go back to).
  expect(find.byType(CircleBackButton), findsNothing);
  await tapOn(tester, find.text(l.continueLabel));
  await pumpUntil(tester, find.byType(HomeScreen), journey: j);
  expect(j.location, '/home');
  expect(j.requests.count('POST', '/auth/otp/verify'), 4);

  semantics.dispose();
  expectCleanJourney(
    j,
    knownOverflows: knownOverflows,
    label: 'banned $locale/${theme.name}/${textScale}x',
  );
  await endJourney(tester);
}
