/// E4 (d) and (e): the account states that end, or must NOT end, a session.
///
/// * `account_banned` on `verifyOtp` (a correct code, no tokens, no retry).
/// * `403 account_pending_deletion` on any protected call: not a sign-out, not a
///   refresh, not a retry - and, because the global redirect to the cancel
///   screen does not exist yet (CW02 seam), nothing may loop in its place.
/// * `session_superseded` on the REPLAY of a request that was just refreshed.
/// * Signing out when the session is already dead, and when the phone is
///   offline.
///
/// Real router, real `AuthController`, real interceptor chain, real
/// `SecureStorage` wrapper; only the server is faked (`support/e4_support.dart`).
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:pinput/pinput.dart';

import 'support/e4_support.dart';

const _bannedEn = 'Account banned — contact Support';
const _supersededEn =
    "You've been signed out — your account was used on another device.";

void main() {
  Future<void> reachOtp(WidgetTester tester) async {
    await tester.tap(find.text('Log In'));
    await pumpFrames(tester, frames: 5);
    await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
    await pumpFrames(tester, frames: 3);
    await tester.tap(find.text('Send OTP'));
    await pumpFrames(tester, frames: 8);
    expect(find.byType(OtpScreen), findsOneWidget);
  }

  e4Widgets('E1 account_banned on verify: ONE verify, no tokens written, '
      'signed out, no second attempt reaches the server, nothing else '
      'fires', (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);
    await reachOtp(tester);

    // The repo mock's banned account.
    await tester.enterText(find.byType(Pinput), '222222');
    await pumpFrames(tester, frames: 10);

    expect(find.text(_bannedEn), findsOneWidget);
    expect(rig.server.keys, [
      'POST /auth/otp/request',
      'POST /auth/otp/verify',
    ]);
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    expect(await rig.storage.readAccessToken(), isNull);
    expect(rig.server.count('POST /auth/refresh'), 0);
    expect(rig.location, '/login/otp');

    // "Do not retry": a second code entered into the locked field never leaves.
    await tester.enterText(find.byType(Pinput), '000000');
    await pumpFrames(tester, frames: 10);
    expect(rig.server.count('POST /auth/otp/verify'), 1);
    expect(rig.auth, isA<AuthUnauthenticated>());

    // Two quiet minutes: the resend countdown is moot and no timer calls out.
    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 2));
    expect(rig.server.calls.length, settled);
    expect(rig.tripwire.hits, isEmpty);
    await tearDownTree(tester, rig);
  });

  e4Widgets('E2 403 account_pending_deletion on protected reads: no sign-out, '
      'no refresh, no replay, and NOTHING retries by itself in its place', (
    tester,
  ) async {
    final rig = AppRig(signedIn: true);
    rig.server.pendingDeletion = true;
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);

    // `GET /me` is on the contract's allowlist so Home still loads; the board
    // strip is refused.
    expect(rig.auth, isA<AuthAuthenticated>());
    expect(rig.location, '/home');
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(rig.server.count('GET /me'), 1);
    expect(rig.server.count('GET /leaderboard'), 1);
    expect(rig.server.count('POST /auth/refresh'), 0);
    expect(rig.server.calls.where((c) => c.retried), isEmpty);
    expect(
      rig.observer.failures,
      isNotEmpty,
      reason: 'the 403 reached a screen',
    );

    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 5));
    expect(
      rig.server.calls.length,
      settled,
      reason:
          'silent retry after 403: ${rig.server.calls.skip(settled).toList()}',
    );
    // Tokens untouched: the 403 is not a session event.
    expect(await rig.storage.readAccessToken(), isNotNull);
    expect(await rig.storage.readRefreshToken(), isNotNull);
    expect(rig.auth, isA<AuthAuthenticated>());
    await tearDownTree(tester, rig);
  });

  e4Widgets('E3 session_superseded on the REPLAY of a refreshed request: '
      'forced sign-out, no second refresh, no third attempt', (tester) async {
    final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
    // The first refresh succeeds ...
    rig.server.scripted['GET /me'] = (o) {
      // ... but the server evicts this device the moment the NEW token is used.
      if (o.extra['__retried'] == true) {
        return problem(401, 'session_superseded');
      }
      return null;
    };
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);

    expect(rig.server.count('POST /auth/refresh'), 1);
    expect(rig.server.count('GET /me'), lessThanOrEqualTo(3));
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    expect(find.text(_supersededEn), findsOneWidget);
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 3));
    expect(rig.server.calls.length, settled);
    await tearDownTree(tester, rig);
  });

  e4Widgets('E4 the student signs out after the server already killed the '
      'session: still signed out, tokens gone, at most one refresh, no '
      'loop', (tester) async {
    final rig = AppRig(signedIn: true);
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);
    expect(find.byType(HomeScreen), findsOneWidget);

    rig.server.expireAccess();
    rig.server.refreshDead = true;
    unawaited(rig.container.read(authControllerProvider.notifier).logout());
    await pumpFrames(tester, frames: 30);

    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    expect(rig.fss.data.containsKey('device_id'), isTrue);
    expect(rig.server.count('POST /auth/refresh'), lessThanOrEqualTo(1));
    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 3));
    expect(rig.server.calls.length, settled);
    await tearDownTree(tester, rig);
  });

  e4Widgets('E5 the student signs out while the phone is offline: the local '
      'session still ends, tokens are cleared, nothing retries later', (
    tester,
  ) async {
    final rig = AppRig(signedIn: true);
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);

    // The revoke cannot reach the server.
    rig.server.scripted['POST /auth/logout'] = (o) =>
        throw DioException.connectionError(
          requestOptions: o,
          reason: 'offline',
        );
    unawaited(rig.container.read(authControllerProvider.notifier).logout());
    await pumpFrames(tester, frames: 30);

    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    expect(rig.server.count('POST /auth/logout'), 1, reason: 'no retry');
    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 3));
    expect(rig.server.calls.length, settled);
    await tearDownTree(tester, rig);
  });
}
