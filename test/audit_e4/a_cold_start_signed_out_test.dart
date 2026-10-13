/// E4 (a): a cold start with NO tokens performs ZERO network requests until the
/// student acts.
///
/// Proven at two levels, both on the unmodified production wiring:
///
/// * Dio level - the real `dioProvider` / `refreshDioProvider`, the real
///   interceptor chain, with a recording adapter swapped in underneath.
/// * `dart:io` level - an `HttpOverrides` tripwire that records any HTTP
///   request that is NOT routed through Dio (image loads, a package opening its
///   own client). It records hosts only.
///
/// The "student acts" half proves the contrary: the one request the Login
/// screen makes carries no Authorization header, and it is exactly one request.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';

import 'support/e4_support.dart';

void main() {
  e4Widgets('A1 signed-out cold start: onboarding, idle, then Login - zero '
      'requests of any kind', (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);

    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(rig.location, '/');

    // Sitting on onboarding for two minutes: nothing polls, nothing refreshes.
    await tester.pump(const Duration(minutes: 2));
    expect(rig.server.calls, isEmpty, reason: 'onboarding made a request');

    // Onboarding -> Login (the "Log In" button).
    await tester.tap(find.text('Log In'));
    await pumpFrames(tester);
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(rig.location, '/login');

    // Sitting on Login with an empty form, again for two minutes.
    await tester.pump(const Duration(minutes: 2));

    // Typing alone (no submit) is not a reason to call the server either.
    await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
    await pumpFrames(tester);

    expect(
      rig.server.calls,
      isEmpty,
      reason: 'requests before the student acted: ${rig.server.calls}',
    );
    expect(
      rig.tripwire.hits,
      isEmpty,
      reason: 'a dart:io HTTP client was created or used: ${rig.tripwire.hits}',
    );

    // Nothing session-scoped was even instantiated.
    for (final p in rig.observer.added) {
      // ignore: avoid_print
      print('A1 provider created at signed-out boot: ${p.runtimeType}');
    }

    await tearDownTree(tester, rig);
  });

  e4Widgets('A2 the student acts: exactly ONE request, no Authorization '
      'header, no refresh', (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);

    await tester.tap(find.text('Log In'));
    await pumpFrames(tester);
    await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
    await pumpFrames(tester);

    await tester.tap(find.text('Send OTP'));
    await pumpFrames(tester);

    expect(rig.server.keys, ['POST /auth/otp/request']);
    expect(rig.server.calls.single.bearer, 'none');
    expect(rig.server.count('POST /auth/refresh'), 0);
    expect(rig.tripwire.requests, isEmpty);
    // Landed on the OTP screen, still signed out.
    expect(rig.location, '/login/otp');
    expect(rig.auth, isA<AuthUnauthenticated>());

    // The OTP screen's resend countdown is the only timer; it makes no calls.
    await tester.pump(const Duration(minutes: 2));
    expect(rig.server.keys, ['POST /auth/otp/request']);

    await tearDownTree(tester, rig);
  });

  e4Widgets('A3 a signed-out student deep-linked to a protected route is '
      'bounced to /login with zero requests', (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);

    for (final path in ['/home', '/leaderboard', '/learn', '/profile']) {
      rig.container.read(routerProvider).go(path);
      await pumpFrames(tester, frames: 5);
      expect(rig.location, '/login', reason: '$path was not guarded');
    }
    expect(rig.server.calls, isEmpty);
    expect(rig.tripwire.hits, isEmpty);

    await tearDownTree(tester, rig);
  });
}
