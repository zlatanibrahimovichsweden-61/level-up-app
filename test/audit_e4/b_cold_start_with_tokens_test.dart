/// E4 (b): a cold start WITH stored tokens.
///
/// Claim under test: no request leaves before the router has settled on /home
/// with the auth status resolved; then only the screens' own reads fire, each
/// once; and an expired access token is one refresh, not a storm.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';

import 'support/e4_support.dart';

void main() {
  e4Widgets('B0 signed in, valid tokens: every call is made after the '
      'status resolved, at /home, with a valid Bearer, once', (tester) async {
    final rig = AppRig(signedIn: true);
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);

    expect(rig.auth, isA<AuthAuthenticated>());
    expect(rig.location, '/home');
    expect(find.byType(HomeScreen), findsOneWidget);

    // ignore: avoid_print
    print('B0 calls:\n${rig.server.calls.join('\n')}');

    expect(rig.server.calls, isNotEmpty, reason: 'Home read nothing at all');
    for (final c in rig.server.calls) {
      expect(c.snapshot, startsWith('auth=AuthAuthenticated'), reason: '$c');
      expect(c.bearer, 'valid', reason: '$c');
      expect(c.retried, isFalse, reason: '$c');
    }
    // None before the router settled on /home.
    expect(
      rig.server.calls.where((c) => !c.snapshot.endsWith('at=/home')),
      isEmpty,
      reason: 'a request fired before the router settled on /home',
    );
    // Each endpoint once: no duplicate read per rebuild.
    final keys = rig.server.keys;
    expect(keys.toSet().length, keys.length, reason: 'duplicates: $keys');
    expect(rig.server.count('POST /auth/refresh'), 0);
    expect(
      rig.tripwire.requests.where((h) => h.host.contains('levelup')),
      isEmpty,
    );

    await tearDownTree(tester, rig);
  });

  e4Widgets('B1 idle on Home for ten minutes: nothing polls', (tester) async {
    final rig = AppRig(signedIn: true);
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);
    final settled = rig.server.calls.length;

    await tester.pump(const Duration(minutes: 10));
    expect(
      rig.server.calls.length,
      settled,
      reason:
          'background requests while idle: '
          '${rig.server.calls.skip(settled).toList()}',
    );
    await tearDownTree(tester, rig);
  });

  e4Widgets('B2 expired access token + valid refresh: ONE refresh, every '
      'original request replayed exactly once, no logout', (tester) async {
    // The server rotated the access token while the app was closed: the
    // keystore still holds the old one.
    final rig = AppRig(signedIn: true, storedAccess: 'OLD.ACCESS.TOKEN.0000');
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);

    expect(rig.auth, isA<AuthAuthenticated>());
    expect(rig.location, '/home');
    expect(rig.server.count('POST /auth/refresh'), 1, reason: 'refresh storm');
    expect(rig.server.refreshCount, 1);

    // The one request in flight at the 401 (/me) is replayed exactly once,
    // with the minted token; the board, which waits for /me, is asked once.
    expect(rig.server.count('GET /me'), 2);
    expect(rig.server.count('GET /leaderboard'), 1);
    final me = rig.server.calls.where((c) => c.path == '/me').toList();
    expect(me.first.bearer, 'stale');
    expect(me.first.retried, isFalse);
    expect(me.last.bearer, 'valid');
    expect(me.last.retried, isTrue);
    expect(
      rig.server.calls.where((c) => c.path == '/leaderboard').single.bearer,
      'valid',
    );
    expect(rig.observer.failures, isEmpty);
    // The rotated pair was persisted through the wrapper.
    expect(await rig.storage.readAccessToken(), rig.server.validAccess);
    expect(await rig.storage.readRefreshToken(), rig.server.validRefresh);
    await tearDownTree(tester, rig);
  });

  e4Widgets('B3 stored access token but NO refresh token, and the access '
      'token is stale: signed out with ZERO refresh requests', (tester) async {
    // Corrupt/partial keystore: the refresh token is gone.
    final rig = AppRig(
      signedIn: true,
      storedAccess: 'OLD.ACCESS.TOKEN.0000',
      withRefreshToken: false,
    );
    await rig.boot(tester);
    await pumpFrames(tester, frames: 40);

    expect(rig.server.count('POST /auth/refresh'), 0);
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(rig.location, '/login');
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tearDownTree(tester, rig);
  });
}
