/// E4 (g)/(h), the traffic that does NOT go through Dio: image loads.
///
/// `CachedNetworkImage` (flutter_cache_manager) and `Image.network` open their
/// own `dart:io` HttpClient, so neither the Authorization header nor the
/// interceptor chain applies to them - the Tripwire in `support/e4_support.dart`
/// is the only thing that sees them. This file has ONE test on purpose: the
/// cache manager is a process-wide singleton that keeps the HttpClient it first
/// created, so a second test in the same file would have its image traffic
/// attributed to the first test's tripwire.
///
/// The Tripwire refuses every connection, which is the worst case for a loader
/// (every attempt fails and nothing is ever cached). The mock's avatar URLs are
/// on `picsum.photos`; a real student's come from the server's CDN.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/core/router/app_router.dart';

import 'support/e4_support.dart';

void main() {
  e4Widgets('I1 image loaders: they request only what is on screen, never '
      'repeat while idle, and never touch the API host', (tester) async {
    final rig = AppRig(signedIn: true);
    await rig.boot(tester, size: const Size(390, 780));
    await pumpFrames(tester, frames: 40);

    int images() => rig.tripwire.requests.length;
    final rows = <String>[];
    final grewIdle = <String>[];

    final atHome = images();
    rows.add('/home (cold, signed in): $atHome image requests');
    await tester.pump(const Duration(minutes: 5));
    if (images() != atHome) grewIdle.add('/home idle +${images() - atHome}');

    final router = rig.container.read(routerProvider);
    for (final route in [
      '/leaderboard',
      '/profile',
      '/profile/edit',
      '/support',
      '/home',
    ]) {
      final before = images();
      router.go(route);
      await pumpFrames(tester, frames: 20);
      final opened = images();
      rows.add('$route: +${opened - before} on open');
      await tester.pump(const Duration(minutes: 3));
      if (images() != opened) {
        grewIdle.add('$route idle +${images() - opened}');
      }
    }

    // A rebuild storm: how many attempts does a failed image re-make? This is
    // MEASURED and reported, not asserted - Flutter does not cache a failed
    // load, so a new widget instance asks again.
    final beforeStorm = images();
    rig.container.read(localeProvider.notifier).select(const Locale('ar'));
    await pumpFrames(tester, frames: 5);
    rig.container.read(themeModeProvider.notifier).select(ThemeMode.dark);
    await pumpFrames(tester, frames: 5);
    rig.container.read(localeProvider.notifier).select(const Locale('en'));
    rig.container.read(themeModeProvider.notifier).select(ThemeMode.light);
    await pumpFrames(tester, frames: 5);
    rows.add('rebuild storm (locale+theme x2): +${images() - beforeStorm}');

    final hosts = rig.tripwire.requests.map((h) => h.host).toSet();
    // ignore: avoid_print
    print(
      'I1 image traffic (all refused by the tripwire):\n  ${rows.join('\n  ')}'
      '\n  hosts: $hosts',
    );

    expect(grewIdle, isEmpty, reason: 'image requests repeated while idle');
    expect(
      hosts.difference({'picsum.photos'}),
      isEmpty,
      reason: 'a non-avatar host was contacted outside Dio: $hosts',
    );
    expect(hosts.any((h) => h.contains('example')), isFalse);
    // The API itself was only ever reached through the fake Dio adapter.
    expect(rig.server.calls.every((c) => c.bearer != 'stale'), isTrue);
    await tearDownTree(tester, rig);
  });
}
