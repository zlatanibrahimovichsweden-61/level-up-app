/// E4 (c) and (d): 401 -> single-flight refresh -> replay once; a failed
/// refresh ends the session cleanly; `session_superseded`.
///
/// Everything runs through the REAL router, the REAL `AuthController`, the REAL
/// interceptor chain (`DioClient.create`), the REAL `AuthRepository.refresh` on
/// the bare client and the REAL `SecureStorage` wrapper. Only the server is
/// faked (see `support/e4_support.dart`).
///
/// E4-01 is pinned first (C0/C0b). It was the defect that in a DEBUG build the
/// production `dioProvider` could never refresh, because its refresh closure
/// read a provider that watches it. The fix removed the cycle, and these two
/// tests drive the UNMODIFIED provider through a 401. Every other test in this
/// file now runs through that same real provider; the rig used to swap in a
/// release-semantics copy to audit anything past the first 401.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/notifier/login_notifier.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/catalog/notifier/subjects_notifier.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:pinput/pinput.dart';

import 'support/e4_support.dart';

void main() {
  // -------------------------------------------------------------------------
  // E4-01 (fixed): the production dioProvider refreshes in a DEBUG build
  // -------------------------------------------------------------------------
  group('E4-01 (debug builds): the production dioProvider refreshes an '
      'expired access token', () {
    test('C0b the refresh runs on the bare client and NEVER reaches '
        'authRepositoryProvider: the debug-only CircularDependencyError '
        'cannot arise', () async {
      final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
      await rig.bootHeadless();
      final dio = rig.container.read(dioProvider);
      await Future<void>.delayed(Duration.zero);
      expect(kDebugMode, isTrue, reason: 'this pins the debug-mode semantics');

      final res = await dio.get<dynamic>('/me');

      expect(res.statusCode, 200);
      expect(rig.server.count('POST /auth/refresh'), 1);
      // Structural: the repository is a child of dioProvider (it watches it),
      // so a dioProvider that READ it was a provider cycle. Nothing built it.
      expect(
        rig.observer.wasCreated(authRepositoryProvider),
        isFalse,
        reason:
            'dioProvider reached the auth repository: that is the E4-01 '
            'cycle, and it throws CircularDependencyError in debug',
      );
      expect(rig.observer.wasCreated(refreshDioProvider), isTrue);
      expect(rig.observer.failures, isEmpty);
    });

    test('C0b2 ...and with the repository ALIVE as a child of dioProvider (as '
        'after an OTP request or a sign-out) the refresh is the same single '
        'bare call', () async {
      final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
      await rig.bootHeadless();
      rig.container.read(authRepositoryProvider);
      final dio = rig.container.read(dioProvider);
      await Future<void>.delayed(Duration.zero);

      final res = await dio.get<dynamic>('/me');

      expect(res.statusCode, 200);
      expect(rig.server.count('POST /auth/refresh'), 1);
      expect(
        rig.server.calls.singleWhere((c) => c.path == '/auth/refresh').bearer,
        'none',
        reason:
            'the refresh went through the AuthInterceptor, not the bare '
            'client',
      );
      expect(rig.server.count('GET /me'), 2, reason: 'one attempt, one replay');
      expect(await rig.storage.readAccessToken(), rig.server.validAccess);
      expect(await rig.storage.readRefreshToken(), rig.server.validRefresh);
      expect(rig.observer.failures, isEmpty);
    });

    e4Widgets('C0 through the unmodified production dioProvider a 401 '
        'authentication_required is refreshed ONCE and the screen gets its '
        'answer: one /auth/refresh, /me replayed with the minted token, still '
        'signed in', (tester) async {
      final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
      await rig.boot(tester);
      await pumpFrames(tester, frames: 40);

      expect(rig.server.count('POST /auth/refresh'), 1);
      expect(rig.server.count('GET /me'), 2, reason: 'one attempt, one replay');
      final me = rig.server.calls.where((c) => c.key == 'GET /me').toList();
      expect(me.first.bearer, 'stale');
      expect(me.last.bearer, 'valid');
      expect(me.last.retried, isTrue);
      // The student is NOT stranded on the error screen.
      expect(
        rig.observer.failures,
        isNot(contains(startsWith('AsyncNotifierProvider<MeNotifier'))),
      );
      expect(rig.auth, isA<AuthAuthenticated>());
      expect(await rig.storage.readAccessToken(), rig.server.validAccess);
      expect(await rig.storage.readRefreshToken(), rig.server.validRefresh);
      await tearDownTree(tester, rig);
    });
  });

  // -------------------------------------------------------------------------
  // (c) single-flight
  // -------------------------------------------------------------------------
  test(
    'C1 six concurrent 401s share ONE refresh; each original request is '
    'replayed exactly once with the minted token; the pair is persisted',
    () async {
      final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
      await rig.bootHeadless();
      final dio = rig.container.read(dioProvider);
      // Let the controller resolve from the stored token.
      await Future<void>.delayed(Duration.zero);
      expect(rig.auth, isA<AuthAuthenticated>());

      // Hold the refresh open until every request has been refused, so the six
      // 401s genuinely overlap.
      rig.server.refreshGate = Completer<void>();
      final paths = [
        '/me',
        '/me/entitlements',
        '/catalog/subjects',
        '/me/mistakes',
        '/leaderboard',
        '/me/entitlements',
      ];
      final results = [for (final p in paths) dio.get<dynamic>(p)];
      while (rig.server.calls.where((c) => c.bearer == 'stale').length < 6 ||
          rig.server.count('POST /auth/refresh') < 1) {
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }
      // Give the other five 401 handlers real time to reach the shared future.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(
        rig.server.count('POST /auth/refresh'),
        1,
        reason: 'the refresh must already be in flight, once',
      );
      rig.server.refreshGate!.complete();
      // The repo's canned backend may answer a bare GET (no query) with its
      // own 400; what matters here is that none is a 401 any more.
      final statuses = await Future.wait([
        for (final f in results)
          f.then<int?>(
            (r) => r.statusCode,
            onError: (Object e) => (e as DioException).response?.statusCode,
          ),
      ]);

      expect(statuses, everyElement(isNot(401)));
      expect(rig.server.refreshCount, 1, reason: 'refresh storm');
      final replays = rig.server.calls.where((c) => c.retried).toList();
      expect(replays.length, 6);
      expect(replays.every((c) => c.bearer == 'valid'), isTrue);
      // No request was replayed twice.
      expect(
        rig.server.calls.where((c) => c.path != '/auth/refresh').length,
        12,
        reason: '6 stale attempts + 6 replays',
      );
      expect(await rig.storage.readAccessToken(), rig.server.validAccess);
      expect(await rig.storage.readRefreshToken(), rig.server.validRefresh);
      // The refresh itself carried no Authorization header (bare client).
      expect(
        rig.server.calls.singleWhere((c) => c.path == '/auth/refresh').bearer,
        'none',
      );
    },
  );

  test('C1b a replay that is refused AGAIN (401 on the retried request) is '
      'not refreshed a second time and does not loop', () async {
    final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
    await rig.bootHeadless();
    final dio = rig.container.read(dioProvider);
    await Future<void>.delayed(Duration.zero);
    // The server keeps answering authentication_required even for the minted
    // token (e.g. clock skew / a broken edge cache).
    rig.server.scripted['GET /me'] = (o) =>
        problem(401, 'authentication_required');

    await expectLater(
      dio.get<dynamic>('/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.error,
          'error',
          isA<UnauthorizedException>(),
        ),
      ),
    );
    expect(rig.server.count('POST /auth/refresh'), 1);
    expect(rig.server.count('GET /me'), 2, reason: 'one attempt, one replay');
    // Not logged out by this: the refresh itself succeeded.
    expect(rig.auth, isA<AuthAuthenticated>());
  });

  // -------------------------------------------------------------------------
  // (c) refresh failure ends the session
  // -------------------------------------------------------------------------
  Future<AppRig> bootHomeWithDeadRefresh(
    WidgetTester tester, {
    void Function(AppRig)? tweak,
  }) async {
    final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
    tweak?.call(rig);
    await rig.boot(tester);
    return rig;
  }

  e4Widgets('C2 refresh refused (refresh_token_invalid): ONE refresh, the '
      'request is not replayed, tokens gone, device_id kept, session-scoped '
      'providers dropped, /login with the expiry message once, nothing '
      'fires afterwards', (tester) async {
    final rig = await bootHomeWithDeadRefresh(
      tester,
      tweak: (r) => r.server.refreshDead = true,
    );
    final deviceIdBefore = await rig.storage.readOrCreateDeviceId();
    await pumpFrames(tester, frames: 40);

    expect(rig.server.count('POST /auth/refresh'), 1);
    // The refused request is NOT replayed (a replay would carry retried=true
    // and a minted token; nothing was minted).
    expect(
      rig.server.calls.where((c) => c.retried),
      isEmpty,
      reason: 'a request was replayed after the refresh was refused',
    );
    // OBSERVATION E4-O1 (documented by design in auth_controller.dart:
    // `forceLogout` doc, "Idempotent once signed out"): `invalidateSessionScope`
    // rebuilds `meProvider` while Home still listens, so ONE tokenless
    // `GET /me` leaves after the sign-out. It is not a replay, carries no
    // Authorization header and no PII, and the idempotent guard stops it there.
    final me = rig.server.calls.where((c) => c.path == '/me').toList();
    expect(me.length, lessThanOrEqualTo(2), reason: me.join(' | '));
    expect(me.first.bearer, 'stale');
    if (me.length == 2) {
      expect(me.last.bearer, 'none');
      expect(me.last.snapshot, startsWith('auth=AuthUnauthenticated'));
    }
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(
      (rig.auth as AuthUnauthenticated).reason == LogoutReason.sessionExpired ||
          (rig.auth as AuthUnauthenticated).reason == null,
      isTrue,
      reason: 'sessionExpired, or already consumed by the Login screen',
    );
    expect(rig.location, '/login');
    expect(find.byType(LoginScreen), findsOneWidget);

    // Tokens cleared through clearTokens(), never clear(): the device id lives.
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    expect(rig.fss.deleteAlls, 0);
    expect(await rig.storage.readOrCreateDeviceId(), deviceIdBefore);

    // Session scope dropped.
    expect(rig.container.exists(meProvider), isFalse);
    expect(rig.container.exists(entitlementsProvider), isFalse);
    expect(rig.container.exists(subjectsProvider), isFalse);
    expect(rig.container.exists(registrationControllerProvider), isFalse);

    // The expiry message is shown once and then consumed.
    expect(
      find.text('Your session expired. Please sign in again.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect((rig.auth as AuthUnauthenticated).reason, isNull);

    // After the sign-out: no storm of fetches from rebuilt session providers.
    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 3));
    expect(
      rig.server.calls.length,
      settled,
      reason:
          'requests after sign-out: '
          '${rig.server.calls.skip(settled).toList()}',
    );
    await tearDownTree(tester, rig);
  });

  e4Widgets('C3 refresh answered session_superseded: same clean end, with '
      'the other-device message', (tester) async {
    final rig = await bootHomeWithDeadRefresh(
      tester,
      tweak: (r) => r.server.refreshSuperseded = true,
    );
    final deviceIdBefore = await rig.storage.readOrCreateDeviceId();
    await pumpFrames(tester, frames: 40);

    expect(rig.server.count('POST /auth/refresh'), 1);
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    expect(
      find.text(
        "You've been signed out — your account was used on another device.",
      ),
      findsOneWidget,
    );
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    // The SAME device id survives (a wiped-and-regenerated one would make the
    // next login look like a new device and mis-fire session_superseded).
    expect(rig.fss.data['device_id'], deviceIdBefore);
    await tester.pump(const Duration(minutes: 1));
    await tearDownTree(tester, rig);
  });

  e4Widgets('C4 refresh fails because the phone is offline: NO sign-out, '
      'tokens kept, and nothing retries on its own', (tester) async {
    final rig = await bootHomeWithDeadRefresh(
      tester,
      tweak: (r) => r.server.refreshOffline = true,
    );
    await pumpFrames(tester, frames: 40);

    expect(rig.server.count('POST /auth/refresh'), 1);
    expect(rig.auth, isA<AuthAuthenticated>());
    expect(rig.location, '/home');
    expect(await rig.storage.readRefreshToken(), isNotNull);
    expect(await rig.storage.readAccessToken(), 'OLD.ACCESS.TOKEN.0000');

    // Three silent minutes on a dead network: not one more request.
    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 3));
    expect(
      rig.server.calls.length,
      settled,
      reason: 'silent retry: ${rig.server.calls.skip(settled).toList()}',
    );

    // The student's own Retry is the only way to ask again.
    await tester.tap(find.text('Retry').first);
    await pumpFrames(tester, frames: 10);
    expect(rig.server.count('POST /auth/refresh'), 2);
    await tearDownTree(tester, rig);
  });

  // -------------------------------------------------------------------------
  // (d) session_superseded on an ordinary 401
  // -------------------------------------------------------------------------
  e4Widgets('D1 session_superseded on any endpoint: forced sign-out WITHOUT '
      'a refresh attempt, even with several requests in flight', (
    tester,
  ) async {
    final rig = AppRig(signedIn: true);
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(rig.auth, isA<AuthAuthenticated>());
    final before = rig.server.calls.length;

    // Another device signs in: the server now evicts this session.
    rig.server.supersedeAll = true;
    final dio = rig.container.read(dioProvider);
    final inFlight = [
      for (final p in ['/me', '/leaderboard', '/catalog/subjects'])
        dio
            .get<dynamic>(p)
            .then<Object?>((_) => null, onError: (Object e) => e),
    ];
    await pumpFrames(tester, frames: 10);
    final errors = await Future.wait(inFlight);

    expect(errors.every((e) => e is DioException), isTrue);
    expect(
      rig.server.count('POST /auth/refresh'),
      0,
      reason: 'a superseded session must not spend its refresh token',
    );
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    expect(
      find.text(
        "You've been signed out — your account was used on another device.",
      ),
      findsOneWidget,
    );
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    expect(rig.container.exists(meProvider), isFalse);

    // No retry storm after the eviction.
    final settled = rig.server.calls.length;
    expect(settled - before, lessThanOrEqualTo(8));
    await tester.pump(const Duration(minutes: 3));
    expect(rig.server.calls.length, settled);
    await tearDownTree(tester, rig);
  });

  // -------------------------------------------------------------------------
  // (c) the retained OTP args (NR-29) and the return target end with the
  //     session, driven by a real 401 chain rather than a direct call
  // -------------------------------------------------------------------------
  Future<void> signInThroughTheUi(
    WidgetTester tester,
    AppRig rig, {
    String code = '000000',
  }) async {
    // From a cold start the entry is the onboarding "Log In" button; after a
    // sign-out the student is already on /login.
    if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
      await tester.tap(find.text('Log In'));
      await pumpFrames(tester, frames: 5);
    }
    await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
    await pumpFrames(tester, frames: 3);
    await tester.tap(find.text('Send OTP'));
    await pumpFrames(tester, frames: 8);
    expect(find.byType(OtpScreen), findsOneWidget);
    // '000000' is the repo mock's "existing school student" code, '111111' its
    // university student.
    await tester.enterText(find.byType(Pinput), code);
    await pumpFrames(tester, frames: 10);
  }

  /// Kills the session for good while the app is on [location]: the access
  /// token is rotated server-side and the refresh token refused.
  Future<void> killSessionOn(
    WidgetTester tester,
    AppRig rig,
    String location,
  ) async {
    rig.container.read(routerProvider).go(location);
    await pumpFrames(tester, frames: 15);
    expect(rig.location, location);
    rig.server.expireAccess();
    rig.server.refreshDead = true;
    rig.container.invalidate(subjectsProvider);
    await pumpFrames(tester, frames: 30);
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
  }

  e4Widgets('C5 sign-in through the UI, then the session dies on a dead '
      'refresh: the retained OTP args (NR-29) are gone, so the OTP route '
      'cannot bring the previous phone back; a user-initiated sign-out '
      'likewise', (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);
    await signInThroughTheUi(tester, rig);

    expect(rig.auth, isA<AuthAuthenticated>());
    expect(rig.location, '/login/otp', reason: 'success view stays up');
    // The real verify wrote the pair through the real wrapper.
    expect(await rig.storage.readAccessToken(), isNotNull);
    expect(rig.server.count('POST /auth/otp/verify'), 1);

    // Continue to Home; then the server kills the session for good.
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 20);
    expect(rig.location, '/home');
    rig.server.expireAccess();
    rig.server.refreshDead = true;
    final dio = rig.container.read(dioProvider);
    // Not awaited: under the test's fake clock the canned backend's
    // `Future.delayed` only fires when frames are pumped.
    unawaited(
      dio
          .get<dynamic>('/me/entitlements')
          .then<void>((_) {}, onError: (Object _) {}),
    );
    await pumpFrames(tester, frames: 30);
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');

    // The Login notifier's per-phone request result is dropped with the session.
    expect(rig.container.read(loginProvider).value, isNull);

    // A stale re-entry with no args of its own: the router's closure-held
    // `lastOtpArgs` (the phone number) must be gone.
    rig.container.read(routerProvider).go('/login/otp');
    await pumpFrames(tester, frames: 10);
    expect(find.byType(OtpScreen), findsNothing);
    expect(rig.location, '/login');

    // Second session, ended by the student themselves.
    await signInThroughTheUi(tester, rig);
    expect(rig.auth, isA<AuthAuthenticated>());
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 20);
    expect(rig.location, '/home');
    unawaited(rig.container.read(authControllerProvider.notifier).logout());
    await pumpFrames(tester, frames: 20);
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    expect(rig.server.count('POST /auth/logout'), 1);
    expect(rig.fss.data.containsKey('access_token'), isFalse);
    expect(rig.fss.data.containsKey('refresh_token'), isFalse);
    expect(rig.fss.data.containsKey('device_id'), isTrue);

    rig.container.read(routerProvider).go('/login/otp');
    await pumpFrames(tester, frames: 10);
    expect(find.byType(OtpScreen), findsNothing);
    expect(rig.location, '/login');
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });

  e4Widgets('C6a return target: a FORCED end on /learn is returned to the '
      'SAME student at their next sign-in (captured id, no /me read needed)', (
    tester,
  ) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);
    await signInThroughTheUi(tester, rig);
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 20);
    expect(rig.location, '/home');

    await killSessionOn(tester, rig, '/learn');

    await signInThroughTheUi(tester, rig); // same student
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 25);
    expect(rig.location, '/learn', reason: 'same student should be returned');
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });

  e4Widgets('C6b return target: a DIFFERENT student signing in next lands '
      "on Home, never on the previous student's location", (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);
    await signInThroughTheUi(tester, rig);
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 20);

    await killSessionOn(tester, rig, '/learn');

    // The canned backend gives every magic-code student the same id, so the
    // next sign-in is stamped with a different one (a different student).
    rig.server.signInStudentId = '0197b2f3-aaaa-7cc3-9b4e-00000000000b';
    await signInThroughTheUi(tester, rig);
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 25);
    expect(rig.location, '/home');
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });

  e4Widgets('C6c return target: a USER-INITIATED sign-out remembers '
      'nothing', (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);
    await signInThroughTheUi(tester, rig);
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 20);

    rig.container.read(routerProvider).go('/learn');
    await pumpFrames(tester, frames: 15);
    expect(rig.location, '/learn');
    unawaited(rig.container.read(authControllerProvider.notifier).logout());
    await pumpFrames(tester, frames: 25);
    expect(rig.location, '/login');

    await signInThroughTheUi(tester, rig); // same student again
    await tester.tap(find.text('Continue'));
    await pumpFrames(tester, frames: 25);
    expect(rig.location, '/home');
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });

  e4Widgets('C6d return target after a cold start from stored tokens: the '
      'student id is unknown (no sign-in in this process) so a forced end '
      'fails CLOSED to Home', (tester) async {
    final rig = AppRig(signedIn: true);
    await rig.boot(tester);
    await pumpFrames(tester, frames: 30);
    await killSessionOn(tester, rig, '/learn');
    final target = rig.container.read(returnTargetProvider);
    expect(target.consume(studentId: 'someone-else'), '/home');
    expect(target.consume(studentId: null), '/home');
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });
}
