import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';

import 'journey_harness.dart';

/// Positive controls for the journey harness itself.
///
/// A journey that reports "no overflow" or "no request was sent" is only worth
/// something if the harness CAN report the opposite. These tests make it do so,
/// on purpose, so a harness that silently stopped seeing overflows or stopped
/// counting requests fails here instead of letting every journey go green.
void main() {
  setUpAll(loadJourneyFonts);

  journeyTest('overflow capture sees an overflow (positive control)', (
    tester,
  ) async {
    // A surface far below any phone, at the OS's largest text: something on the
    // signed-in home screen cannot fit. This is not a product claim; it proves
    // the capture below would have noticed one.
    final j = await bootJourney(
      tester,
      signedIn: true,
      textScale: 2.0,
      size: const Size(200, 360),
    );
    await pumpUntil(tester, find.byType(HomeScreen), journey: j);
    expect(
      j.overflows,
      isNotEmpty,
      reason: 'the harness must be able to see an overflow',
    );
    expect(overflowOrigins(j), isNotEmpty);
    expect(
      overflowOrigin(j.overflows.first),
      isNot('unknown'),
      reason: 'an overflow is attributed to a source line',
    );
    // ... and expectCleanJourney refuses it, unless the origin is ratcheted.
    expect(() => expectCleanJourney(j), throwsA(isA<TestFailure>()));
    expectCleanJourney(j, knownOverflows: overflowOrigins(j));
    await endJourney(tester);
  });

  journeyTest('request log counts what the app sends (positive control)', (
    tester,
  ) async {
    final j = await bootJourney(tester, signedIn: true);
    await pumpUntil(tester, find.byType(HomeScreen), journey: j);
    expect(j.auth, isA<AuthAuthenticated>());
    expect(j.requests.count('GET', '/me'), 1);
    expect(j.requests.count('GET', '/no/such/path'), 0);
    expect(j.requests.snapshot(), isNotEmpty);
    await endJourney(tester);
  });

  journeyTest('a signed-out boot sends nothing and holds no session', (
    tester,
  ) async {
    final j = await bootJourney(tester);
    expect(j.auth, isA<AuthUnauthenticated>());
    expect(j.storage.hasSession, isFalse);
    expect(j.requests.entries, isEmpty);
    expect(j.location, '/');
    await endJourney(tester);
  });
}
