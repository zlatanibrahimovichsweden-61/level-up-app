/// E4 (j) and the session-scope half of (c).
///
/// * `G1`  at a signed-out cold start only the eight infrastructure providers
///         exist, and no repository, notifier, push object or Dio is built.
/// * `G2`  the data-layer repositories and notifiers added this run (friends,
///         deletion, recovery, referral, quiz history, terms, track transfer,
///         quiz summary, push) are never instantiated - not at app start, not
///         by walking every reachable route signed in, not by a sign-out.
/// * `G3`  source census: the only consumers of those providers are the
///         reviewed ones (so the day a screen starts using one, this fails and
///         someone re-reads the privacy checklist).
/// * `G4`  after a signed-in session that touched every route, a forced
///         sign-out leaves NO provider holding a student's data alive.
// The audit enumerates the container's LIVE provider elements, which Riverpod
// only exposes on an internal extension (`getAllProviderElements`). Nothing
// else sees a provider that survives an invalidation (`didDisposeProvider`
// fires on invalidate too), and enumerating is the point: it catches the
// stray nobody listed. Test-only.
// ignore_for_file: invalid_use_of_internal_member, depend_on_referenced_packages
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart' show InternalProviderContainer;
import 'package:level_up_app/core/push/push_gateway.dart';
import 'package:level_up_app/core/push/push_lifecycle.dart';
import 'package:level_up_app/core/push/push_token_repository.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/notifier/login_notifier.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/deletion/repository/deletion_repository.dart';
import 'package:level_up_app/features/friends/repository/friends_repository.dart';
import 'package:level_up_app/features/legal/repository/terms_repository.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/profile/repository/quiz_summary_repository.dart';
import 'package:level_up_app/features/profile/repository/track_transfer_repository.dart';
import 'package:level_up_app/features/quiz/repository/quiz_history_repository.dart';
import 'package:level_up_app/features/recovery/notifier/recovery_flow_notifier.dart';
import 'package:level_up_app/features/recovery/repository/recovery_repository.dart';
import 'package:level_up_app/features/referral/repository/referral_repository.dart';

import 'support/dart_source.dart';
import 'support/e4_support.dart';

String _name(Object provider) =>
    provider.toString().replaceAll(RegExp(r'#[0-9a-f]+'), '');

const _routes = <String>[
  '/home',
  '/leaderboard',
  '/learn',
  '/learn/mistakes',
  '/learn/subject/sub-bio',
  '/learn/mistakes/subject/sub-bio',
  '/message',
  '/account',
  '/profile',
  '/profile/edit',
  '/settings',
  '/refer',
  '/support',
  '/support/new',
  '/friends',
  '/notifications',
  '/legal/privacy',
  '/legal/terms',
];

void main() {
  final inert = <String, Object>{
    'friendsRepositoryProvider': friendsRepositoryProvider,
    'deletionRepositoryProvider': deletionRepositoryProvider,
    'recoveryRepositoryProvider': recoveryRepositoryProvider,
    'recoveryFlowProvider': recoveryFlowProvider,
    'referralRepositoryProvider': referralRepositoryProvider,
    'quizHistoryRepositoryProvider': quizHistoryRepositoryProvider,
    'termsRepositoryProvider': termsRepositoryProvider,
    'trackTransferRepositoryProvider': trackTransferRepositoryProvider,
    'quizSummaryRepositoryProvider': quizSummaryRepositoryProvider,
    'pushGatewayProvider': pushGatewayProvider,
    'pushTokenRepositoryProvider': pushTokenRepositoryProvider,
    'pushRegistrationLifecycleProvider': pushRegistrationLifecycleProvider,
    'entitlementsProvider': entitlementsProvider,
  };

  e4Widgets(
    'G1 a signed-out cold start creates exactly the eight infrastructure '
    'providers - no Dio, no repository, no data notifier',
    (tester) async {
      final rig = AppRig();
      await rig.boot(tester);
      await pumpFrames(tester);
      await tester.tap(find.text('Log In'));
      await pumpFrames(tester, frames: 5);
      expect(find.byType(LoginScreen), findsOneWidget);

      final created = rig.observer.added.map(_name).toList()..sort();
      expect(created, [
        'AsyncNotifierProvider<LoginNotifier, OtpRequestResult?>',
        'NotifierProvider<AuthController, AuthStatus>',
        'NotifierProvider<LocaleController, Locale>',
        'NotifierProvider<ThemeModeController, ThemeMode>',
        'Provider<GoRouter>',
        'Provider<PreferencesStore?>',
        'Provider<SecureStorage>',
        'StreamProvider<bool>',
      ]);
      await tearDownTree(tester, rig);
    },
  );

  e4Widgets(
    'G2 signed in and walking every reachable route: none of the data-layer '
    'repositories / push objects added this run is ever instantiated',
    (tester) async {
      final rig = AppRig(signedIn: true);
      await rig.boot(tester, size: const Size(390, 780));
      await pumpFrames(tester, frames: 40);

      void expectInert(String when) {
        final built = [
          for (final e in inert.entries)
            if (rig.observer.wasCreated(e.value as dynamic)) e.key,
        ];
        expect(built, isEmpty, reason: '$when: instantiated $built');
      }

      expectInert('at the settled /home');
      for (final route in _routes) {
        rig.container.read(routerProvider).go(route);
        await pumpFrames(tester, frames: 15);
      }
      expectInert('after visiting every route');
      // End inside the tab shell: that is where Home (and /me) is mounted.
      rig.container.read(routerProvider).go('/home');
      await pumpFrames(tester, frames: 15);

      // A sign-out does not wake them either.
      rig.server.expireAccess();
      rig.server.refreshDead = true;
      rig.container.invalidate(meProvider);
      await pumpFrames(tester, frames: 30);
      expect(rig.auth, isA<AuthUnauthenticated>());
      expectInert('after the forced sign-out');

      // What WAS built, for the record.
      final names = rig.observer.added.map(_name).toSet().toList()..sort();
      // ignore: avoid_print
      print(
        'G2 providers created across the whole session:\n  ${names.join('\n  ')}',
      );
      // (Image loads leave through dart:io, not Dio: see i_image_traffic_test.)
      await tearDownTree(tester, rig);
    },
  );

  test('G3 the only consumers of the new data-layer providers are the '
      'reviewed ones (everything else is dormant by construction)', () {
    // provider -> files (other than its declaring file) that mention it.
    const consumers = <String, Set<String>>{
      'friendsRepositoryProvider': {},
      'deletionRepositoryProvider': {},
      'referralRepositoryProvider': {},
      'quizHistoryRepositoryProvider': {},
      'termsRepositoryProvider': {},
      'trackTransferRepositoryProvider': {},
      'quizSummaryRepositoryProvider': {},
      'pushGatewayProvider': {'lib/core/push/push_lifecycle.dart'},
      'pushTokenRepositoryProvider': {'lib/core/push/push_lifecycle.dart'},
      'pushRegistrationLifecycleProvider': {},
      // The flow notifier is the repository's only reader, and no screen or
      // route reads the notifier yet.
      'recoveryRepositoryProvider': {
        'lib/features/recovery/notifier/recovery_flow_notifier.dart',
      },
      'recoveryFlowProvider': {},
      // Invalidated by the sign-out inventory; read by no screen.
      'entitlementsProvider': {'lib/core/session/session_scope.dart'},
    };
    final files = libCode(includeDev: false);
    for (final entry in consumers.entries) {
      final users = <String>{
        for (final f in files.entries)
          if (RegExp('\\b${entry.key}\\b').hasMatch(f.value) &&
              !RegExp(
                'final\\s+(?:Provider<\\w+>\\s+)?${entry.key}\\s*=',
              ).hasMatch(f.value))
            f.key,
      };
      expect(
        users,
        entry.value,
        reason:
            '${entry.key} has a new consumer: re-run the privacy '
            'checklist (logging, tokens, session scope) for it',
      );
    }
  });

  test('G3b every repository under lib/features and lib/core/push reaches the '
      'network ONLY through the injected Dio (no own client)', () {
    final files = libCode(includeDev: false);
    final repos = [
      for (final e in files.entries)
        if (e.key.contains('/repository/') ||
            e.key.startsWith('lib/core/push/'))
          e,
    ];
    expect(repos, isNotEmpty);
    for (final e in repos) {
      final code = blankStrings(e.value);
      expect(
        RegExp(r'HttpClient|package:http/|Dio\s*\(|new Dio').hasMatch(code),
        isFalse,
        reason: '${e.key} builds its own HTTP client',
      );
    }
    // And none of them spells a token or a phone into a path: ids only.
    for (final e in repos) {
      final paths = RegExp(
        r"_dio\s*\.\s*\w+\s*(?:<[^>]*>)?\(\s*'([^']*)'",
      ).allMatches(e.value).map((m) => m.group(1)!);
      for (final p in paths) {
        expect(
          p,
          isNot(
            matches(RegExp(r'token=|phone=|otp=|code=', caseSensitive: false)),
          ),
          reason: '${e.key}: $p',
        );
      }
    }
  });

  test('G3c every Dio call in lib/ passes a RELATIVE path, so the Bearer that '
      'AuthInterceptor attaches to every request can only ever go to the API '
      'host (never to a server-supplied absolute URL)', () {
    final call = RegExp(
      r'\b(?:_dio|dio|_refreshDio|_retryDio)\s*\.\s*'
      r'(get|post|put|patch|delete|fetch|request|getUri|postUri|putUri|'
      r'patchUri|deleteUri|download|head)\w*(?:<[^(;]*>)?\(\s*([^,)]*)',
    );
    final odd = <String>[];
    var total = 0;
    for (final e in libCode(includeDev: false).entries) {
      for (final m in call.allMatches(e.value)) {
        total++;
        final first = m.group(2)!.trim();
        if (first.startsWith("'/") || first.startsWith('"/')) continue;
        odd.add('${e.key}: ${m.group(1)}($first)');
      }
    }
    // ignore: avoid_print
    print('G3c Dio call sites scanned: $total; not a literal "/path": $odd');
    expect(total, greaterThan(40), reason: 'the scan found the call sites');
    // A path built by a private helper in the same file is the only other
    // form; each is read below.
    expect(odd, [
      // The replay of the ORIGINAL request, whose path was already relative.
      'lib/core/network/interceptors/auth_interceptor.dart: fetch(options)',
      'lib/features/quiz/repository/quiz_history_repository.dart: '
          'put(_favoritePath(questionId)',
      'lib/features/quiz/repository/quiz_history_repository.dart: '
          'delete(_favoritePath(questionId)',
      'lib/features/quiz/repository/quiz_history_repository.dart: get(path)',
    ]);
    final history = File(
      'lib/features/quiz/repository/quiz_history_repository.dart',
    ).readAsStringSync();
    // `_page(path, ...)` is only ever called with a literal '/...' path.
    final pageCalls = RegExp(r'_page\(\s*([^,)\n]*)').allMatches(history);
    final pageArgs = [
      for (final m in pageCalls)
        if (!m.group(1)!.startsWith('String')) m.group(1)!.trim(),
    ];
    expect(pageArgs, isNotEmpty);
    expect(
      pageArgs.every((a) => a.startsWith("'/")),
      isTrue,
      reason: '$pageArgs',
    );
    expect(
      RegExp(
        r"String _favoritePath\(String questionId\) =>\s*'/",
      ).hasMatch(history),
      isTrue,
      reason: '_favoritePath must start with a slash',
    );
    // And the Dio itself is only ever built against the configured base URL.
    final client = File('lib/core/network/dio_client.dart').readAsStringSync();
    expect(client, contains('baseUrl: AppConfig.instance.baseUrl'));
  });

  e4Widgets(
    'G4 after a signed-in session over every route, a forced sign-out leaves '
    'no provider holding a student alive (E4-04/05 fixed: the catalogue, '
    'subject-tree and Mistakes-overview providers are autoDispose) - every '
    'provider added this run is dropped',
    (tester) async {
      final rig = AppRig(signedIn: true);
      await rig.boot(tester, size: const Size(390, 780));
      await pumpFrames(tester, frames: 40);
      for (final route in _routes) {
        rig.container.read(routerProvider).go(route);
        await pumpFrames(tester, frames: 15);
      }
      rig.container.read(routerProvider).go('/home');
      await pumpFrames(tester, frames: 15);
      final aliveBefore = rig.container
          .getAllProviderElements()
          .map((e) => _name(e.origin))
          .toSet();
      expect(
        aliveBefore.any((n) => n.contains('MeNotifier')),
        isTrue,
        reason: 'the session really held the profile',
      );

      final callsBefore = rig.server.calls.length;
      rig.server.expireAccess();
      rig.server.refreshDead = true;
      rig.container.invalidate(meProvider);
      await pumpFrames(tester, frames: 40);
      await tester.pump(const Duration(seconds: 10));
      expect(rig.auth, isA<AuthUnauthenticated>());
      expect(find.byType(LoginScreen), findsOneWidget);

      // OBSERVATION E4-O1 (network, minor): every live session provider is
      // invalidated while its screen still listens, so it rebuilds and asks ONCE
      // with no token. Each is a 401 that forceLogout absorbs; none carries a
      // token or personal data, and none repeats.
      final tokenless = [
        for (final c in rig.server.calls.skip(callsBefore))
          if (c.bearer == 'none' &&
              c.snapshot.startsWith('auth=AuthUnauthenticated'))
            c.key,
      ];
      // ignore: avoid_print
      print('G4 tokenless requests at sign-out: $tokenless');
      expect(tokenless.toSet().length, tokenless.length, reason: 'a repeat');
      // Here only `/me` (Home is mounted). The catalogue / Mistakes providers
      // are autoDispose and no screen of theirs is mounted any more, so they
      // were already dropped when the walk left them (before E4-04/05 they sat
      // dirty holding the previous student's data until the next student's
      // first read). When their screens ARE mounted at sign-out they ask once,
      // tokenless, and the unmount drops them (h_cross_student_state_test).
      expect(tokenless, ['GET /me']);
      final settled = rig.server.calls.length;
      await tester.pump(const Duration(minutes: 3));
      expect(rig.server.calls.length, settled);

      final alive =
          rig.container
              .getAllProviderElements()
              .map((e) => _name(e.origin))
              .toSet()
              .toList()
            ..sort();
      // ignore: avoid_print
      print('G4 providers alive after sign-out:\n  ${alive.join('\n  ')}');

      final allowed = <RegExp>[
        // Device preferences, persisted on purpose.
        RegExp(r'^Provider<PreferencesStore\?>$'),
        RegExp(r'^NotifierProvider<LocaleController, Locale>$'),
        RegExp(r'^NotifierProvider<ThemeModeController, ThemeMode>$'),
        // Device identity and infrastructure.
        RegExp(r'^Provider<SecureStorage>$'),
        RegExp(r'^FutureProvider<DeviceInfo>$'),
        RegExp(r'^NotifierProvider<AuthController, AuthStatus>$'),
        RegExp(r'^Provider<GoRouter>$'),
        RegExp(r'^Provider<ReturnTarget>$'),
        RegExp(r'^StreamProvider<bool>$'),
        RegExp(r'^Provider<Dio>$'),
        // Stateless repositories (G3b: no cache, no field but the Dio).
        RegExp(r'^Provider<\w+Repository>$'),
        // The Login screen that is on screen right now, freshly rebuilt.
        RegExp(r'^AsyncNotifierProvider<LoginNotifier, OtpRequestResult\?>$'),
      ];
      final stray = [
        for (final n in alive)
          if (!allowed.any((r) => r.hasMatch(n))) n,
      ];
      // E4-04/05 (h_cross_student_state_test.dart): the three providers that
      // used to survive here, holding the previous student's data, are
      // autoDispose now. Anything in this list is a NEW stray.
      expect(stray, isEmpty, reason: 'still alive after sign-out: $stray');

      // The one stateful survivor is empty.
      expect(
        rig.container.read(loginProvider).value,
        isNull,
        reason: 'the Login notifier kept a request result',
      );
      await tearDownTree(tester, rig);
    },
  );
}
