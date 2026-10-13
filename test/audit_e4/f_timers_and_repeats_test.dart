/// E4 (g) and (h): background work, and requests that repeat on their own.
///
/// * `T1`  census of every timer, subscription, lifecycle hook and scroll
///         controller in `lib/` against the reviewed list.
/// * `T2`  the OTP resend countdown: ticks, offers ONE resend, stops when the
///         screen is left.
/// * `T3`  the entitlements resume listener: fires on resume, and not after the
///         session ended - whether or not a screen was still listening when
///         it ended (`T3b`, E4-03).
/// * `T4`  the quiz explanation poll: bounded, and silent once the Bloc closes.
/// * `T5`  the leaderboard scroll trigger against a failing page.
/// * `T6`  a route sweep - every signed-in route that can be opened without
///         arguments, under four server conditions (healthy, account pending
///         deletion, sick server, dead network): initial requests are listed,
///         then two idle minutes and a rebuild storm (locale, theme, text
///         scale, window size, connectivity flap, app pause/resume) must add
///         NOT ONE request.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/locale_provider.dart';
import 'package:level_up_app/core/providers/theme_provider.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:level_up_app/features/profile/notifier/me_notifier.dart';
import 'package:level_up_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:level_up_app/features/quiz/models/explanation_result.dart';
import 'package:level_up_app/features/quiz/repository/quiz_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../features/quiz/quiz_fixtures.dart';
import 'support/dart_source.dart';
import 'support/e4_support.dart';

class _MockQuizRepository extends Mock implements QuizRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // T1 - census
  // ---------------------------------------------------------------------------
  test('T1 every timer, stream subscription, lifecycle hook, poll and scroll '
      'trigger in lib/ is on the reviewed list', () {
    final constructs = <String, RegExp>{
      'Timer(': RegExp(r'(^|[^\w.])Timer\s*\('),
      'Timer.periodic': RegExp(r'Timer\s*\.\s*periodic'),
      'Stream.periodic': RegExp(r'Stream\s*\.\s*periodic'),
      'Future.delayed': RegExp(r'Future(<\w+>)?\s*\.\s*delayed'),
      'AppLifecycleListener': RegExp(r'AppLifecycleListener'),
      'WidgetsBindingObserver': RegExp(
        r'WidgetsBindingObserver|didChangeAppLifecycleState|addObserver',
      ),
      'StreamSubscription': RegExp(r'StreamSubscription'),
      'stream .listen(': RegExp(r'(?<!ref)(?<!ref\.)\.listen\s*\('),
      'onConnectivityChanged': RegExp(r'onConnectivityChanged'),
      'ScrollController': RegExp(r'ScrollController\s*\('),
      'AnimationController': RegExp(r'AnimationController\s*\('),
      'isolate/compute': RegExp(r'Isolate\.|(^|[^\w.])compute\s*\('),
      '.timeout(': RegExp(r'\.timeout\s*\('),
    };
    const expected = <String, Set<String>>{
      'Timer(': {
        'lib/features/registration/widgets/school_picker_field.dart', // debounce
      },
      'Timer.periodic': {'lib/features/auth/notifier/otp_notifier.dart'},
      'Stream.periodic': {},
      'Future.delayed': {'lib/features/quiz/bloc/quiz_bloc.dart'}, // poll gap
      'AppLifecycleListener': {
        'lib/features/profile/notifier/me_notifier.dart',
      },
      'WidgetsBindingObserver': {},
      'StreamSubscription': {'lib/core/push/push_lifecycle.dart'},
      'stream .listen(': {'lib/core/push/push_lifecycle.dart'},
      'onConnectivityChanged': {'lib/core/providers/core_providers.dart'},
      'ScrollController': {
        'lib/features/leaderboard/screens/leaderboard_screen.dart',
        'lib/features/registration/widgets/school_picker_field.dart',
        'lib/features/support/screens/support_ticket_screen.dart',
      },
      'AnimationController': {
        'lib/features/flashcards/widgets/flashcard_flip_card.dart',
      },
      'isolate/compute': {},
      '.timeout(': {},
    };
    final found = <String, Set<String>>{for (final k in constructs.keys) k: {}};
    for (final e in libCode(includeDev: false).entries) {
      final code = blankStrings(e.value);
      for (final c in constructs.entries) {
        if (c.value.hasMatch(code)) found[c.key]!.add(e.key);
      }
    }
    for (final k in constructs.keys) {
      expect(
        found[k],
        expected[k],
        reason: '$k: a new background construct needs reviewing',
      );
    }
  });

  test('T1b scroll triggers: ONLY the leaderboard list and the school picker '
      'sheet start a request from a scroll position, and both stop at an '
      'append error', () {
    final files = libCode(includeDev: false);
    final triggers = <String>{
      for (final e in files.entries)
        if (RegExp(
          r'maxScrollExtent|extentAfter|extentBefore',
        ).hasMatch(blankStrings(e.value)))
          e.key,
    };
    // The support thread reads maxScrollExtent only to jump to the newest
    // message; it registers no scroll listener and starts no request.
    const positionOnly =
        'lib/features/support/screens/support_ticket_screen.dart';
    expect(triggers.remove(positionOnly), isTrue);
    expect(files[positionOnly]!.contains('_scroll.addListener'), isFalse);
    expect(triggers, {
      'lib/features/leaderboard/screens/leaderboard_screen.dart',
      'lib/features/registration/widgets/school_picker_field.dart',
    });
    for (final path in triggers) {
      final code = files[path]!;
      expect(
        code,
        contains('appendError'),
        reason: '$path must stop scroll-driven loading at an append error',
      );
    }
    // Every fetch-on-build provider opts out of Riverpod 3's silent retry:
    // a `retry:` NAMED ARGUMENT inside the provider's own call (a helper that
    // merely has "retry" in its name does not count).
    final missing = <String>[];
    final head = RegExp(
      r'^final\s+(?:Provider<[^>]*>\s+)?(\w+Provider)\s*=',
      multiLine: true,
    );
    for (final e in files.entries) {
      final code = blankStrings(e.value);
      for (final m in head.allMatches(code)) {
        // From the first '(' after '=' to its matching ')'.
        final open = code.indexOf('(', m.end);
        if (open < 0) continue;
        var depth = 0;
        var close = open;
        for (; close < code.length; close++) {
          final ch = code[close];
          if (ch == '(') depth++;
          if (ch == ')') {
            depth--;
            if (depth == 0) break;
          }
        }
        final call = code.substring(m.start, close + 1);
        final async = RegExp(
          r'AsyncNotifierProvider|FutureProvider|StreamProvider',
        ).hasMatch(call);
        if (async && !RegExp(r'\bretry\s*:').hasMatch(call)) {
          missing.add('${e.key}: ${m.group(1)}');
        }
      }
    }
    // isOnlineProvider is a connectivity StreamProvider: it makes no request.
    expect(missing, [
      'lib/core/providers/core_providers.dart: isOnlineProvider',
    ]);
  });

  // ---------------------------------------------------------------------------
  // T2 - OTP countdown
  // ---------------------------------------------------------------------------
  Future<void> reachOtp(WidgetTester tester) async {
    await tester.tap(find.text('Log In'));
    await pumpFrames(tester, frames: 5);
    await tester.enterText(find.byType(TextField), kSentinelPhoneLocal);
    await pumpFrames(tester, frames: 3);
    await tester.tap(find.text('Send OTP'));
    await pumpFrames(tester, frames: 8);
    expect(find.byType(OtpScreen), findsOneWidget);
  }

  e4Widgets('T2 OTP resend: the countdown is the only timer, it offers ONE '
      'resend, a failing resend is not retried, and leaving the screen ends '
      'it', (tester) async {
    final rig = AppRig();
    await rig.boot(tester);
    await pumpFrames(tester);
    await reachOtp(tester);
    expect(rig.server.keys, ['POST /auth/otp/request']);

    // Mid-countdown the Resend control is disabled: tapping does nothing.
    await tester.pump(const Duration(seconds: 20));
    await tester.tap(find.text('Resend OTP'), warnIfMissed: false);
    await pumpFrames(tester, frames: 3);
    expect(rig.server.count('POST /auth/otp/request'), 1);

    // After the window it is live; one tap is one request.
    await tester.pump(const Duration(seconds: 45));
    // The second request fails at the transport.
    var calls = 0;
    rig.server.scripted['POST /auth/otp/request'] = (o) {
      calls++;
      throw DioException.connectionError(requestOptions: o, reason: 'offline');
    };
    await tester.tap(find.text('Resend OTP'));
    await pumpFrames(tester, frames: 8);
    expect(calls, 1);

    // The failure is shown; nothing retries on its own.
    final settled = rig.server.calls.length;
    await tester.pump(const Duration(minutes: 5));
    expect(rig.server.calls.length, settled);

    // Leaving the screen: the periodic timer goes with it (the binding fails
    // any test that ends with a live timer).
    rig.container.read(routerProvider).go('/login');
    await pumpFrames(tester, frames: 10);
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.pump(const Duration(minutes: 5));
    expect(rig.server.calls.length, settled);
    await tearDownTree(tester, rig);
  });

  // ---------------------------------------------------------------------------
  // T3 - entitlements resume listener
  // ---------------------------------------------------------------------------
  void resume() {
    final b = TestWidgetsFlutterBinding.instance;
    // resumed -> inactive -> hidden -> paused -> hidden -> inactive -> resumed
    for (final state in [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      b.handleAppLifecycleStateChanged(state);
    }
  }

  /// Runs [body] in a zone that records any UNHANDLED async error instead of
  /// letting it fail (or hang) the test, and still propagates [body]'s own
  /// failures (including failed expectations).
  Future<T> guarded<T>(Future<T> Function() body, List<Object> uncaught) {
    final done = Completer<T>();
    runZonedGuarded(() async {
      try {
        done.complete(await body());
      } catch (e, s) {
        if (!done.isCompleted) done.completeError(e, s);
      }
    }, (error, stack) => uncaught.add(error));
    return done.future;
  }

  /// Gives the app event-loop turns until [condition] holds.
  ///
  /// T3 used to sleep on the WALL CLOCK (`Future.delayed(20 ms)`) and then count
  /// requests. A request is not one step: it takes a handful of event-loop hops
  /// (about five here), and each hop arms a zero-length timer after the
  /// previous one ran. A machine that stalls for longer than the sleep between
  /// two hops (a loaded runner, a GC pause, a cold JIT) lets the sleeping test
  /// wake first and count a request that is simply not recorded yet: "expected
  /// 3, actual 2", once, in the full suite. A wait that is bounded by TURNS
  /// instead of time cannot be overtaken: every turn this loop takes also lets
  /// the app's own pending hops run, in order, and the loop ends the moment the
  /// thing it waits for has happened - at any speed. The bound exists only to
  /// turn "never" into a failure.
  Future<void> until(bool Function() condition, String what) async {
    for (var turn = 0; turn < 5000; turn++) {
      if (condition()) return;
      await Future<void>.delayed(Duration.zero);
    }
    fail('gave up waiting for $what');
  }

  /// Lets everything the app already has in flight run to its end (a few hops
  /// at most) and then some: 200 event-loop turns, not a stretch of the clock.
  /// For the assertions that something did NOT happen (no second request, no
  /// request after the session ended); a slow machine can only make these
  /// wait longer, never fail them.
  Future<void> quiesce() async {
    for (var turn = 0; turn < 200; turn++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  /// The turn-based waits above have no clock in them, but the runner's own
  /// 30 s ceiling per test does: a machine starved for that long (an
  /// oversubscribed CI box) would report the test as failed for being slow,
  /// which is not what it checks. These two take a fraction of a second when
  /// the machine is not starved, so the ceiling is raised to a figure only a
  /// hang can reach.
  const slowMachine = Timeout(Duration(minutes: 2));

  test('T3 entitlements: the resume listener refetches once per resume while '
      'signed in; a forced sign-out with no screen listening ends it, and a '
      'resume whose answer lands AFTER the sign-out raises no unhandled '
      'error', () async {
    final rig = AppRig(signedIn: true);
    await rig.bootHeadless();
    rig.container.read(authControllerProvider); // build starts the token read
    await until(() => rig.auth is AuthAuthenticated, 'the stored session');
    expect(rig.auth, isA<AuthAuthenticated>());

    final uncaught = <Object>[];
    final after = await guarded(() async {
      // Nothing in the app reads this provider today (see T6); a future
      // screen will. Read it the way that screen would.
      final sub = rig.container.listen(entitlementsProvider, (_, _) {});
      await rig.container.read(entitlementsProvider.future);
      expect(rig.server.count('GET /me/entitlements'), 1);

      resume();
      await until(
        () => rig.server.count('GET /me/entitlements') >= 2,
        'the refetch after the first resume',
      );
      await quiesce(); // ...and nothing more: ONE refetch per resume
      expect(rig.server.count('GET /me/entitlements'), 2, reason: 'one resume');

      // A resume whose answer is still in flight when the session ends.
      final gate = Completer<void>();
      rig.server.scripted['GET /me/entitlements'] = (o) async {
        await gate.future;
        return null;
      };
      resume();
      await until(
        () => rig.server.count('GET /me/entitlements') >= 3,
        'the refetch after the second resume',
      );
      await quiesce();
      expect(rig.server.count('GET /me/entitlements'), 3);

      // The screen goes first, then the session ends.
      sub.close();
      await rig.container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      gate.complete();
      await quiesce(); // the late answer lands on a dead notifier
      rig.server.scripted.remove('GET /me/entitlements');

      final before = rig.server.calls.length;
      resume();
      await quiesce();
      resume();
      await quiesce();
      return rig.server.calls.skip(before).toList();
    }, uncaught);

    expect(after, isEmpty, reason: 'the listener outlived the session: $after');
    // This is what pins the `_disposed` guard in EntitlementsNotifier.refresh:
    // without it the late answer writes to a dead ref and Riverpod raises an
    // UnmountedRefException into the zone, which lands in [uncaught] here
    // (checked by mutation).
    expect(uncaught, isEmpty, reason: 'unhandled async errors: $uncaught');
  }, timeout: slowMachine);

  test('T3b E4-03 (fixed): when a screen is STILL LISTENING at a forced '
      'sign-out (the realistic order), entitlementsProvider goes with the '
      'screen - it is autoDispose - so no later app resume sends a tokenless '
      'GET /me/entitlements', () async {
    final rig = AppRig(signedIn: true);
    await rig.bootHeadless();
    rig.container.read(authControllerProvider);
    await until(() => rig.auth is AuthAuthenticated, 'the stored session');

    final uncaught = <Object>[];
    final after = await guarded(() async {
      final sub = rig.container.listen(entitlementsProvider, (_, _) {});
      await rig.container.read(entitlementsProvider.future);
      expect(rig.server.count('GET /me/entitlements'), 1);

      await rig.container
          .read(authControllerProvider.notifier)
          .forceLogout(LogoutReason.sessionExpired);
      await quiesce();
      // The shell unmounts a frame later and drops the screen's listener.
      sub.close();
      await quiesce();

      final before = rig.server.calls.length;
      resume();
      await quiesce();
      resume();
      await quiesce();
      return rig.server.calls.skip(before).toList();
    }, uncaught);

    // The element died with its last listener, and with it the resume hook.
    expect(rig.container.exists(entitlementsProvider), isFalse);
    expect(
      after.map((c) => '${c.key} bearer=${c.bearer}').toList(),
      isEmpty,
      reason: 'the resume listener outlived the session',
    );
    expect(rig.auth, isA<AuthUnauthenticated>());
    expect(uncaught, isEmpty, reason: 'unhandled async errors: $uncaught');
  }, timeout: slowMachine);

  // ---------------------------------------------------------------------------
  // T4 - quiz explanation poll
  // ---------------------------------------------------------------------------
  group('T4 quiz explanation poll', () {
    late _MockQuizRepository repo;
    setUp(() => repo = _MockQuizRepository());

    /// A Bloc sitting on a graded question 1 (explanation available), reached
    /// the way the screen reaches it: start, select, confirm.
    Future<QuizBloc> gradedBloc(Duration pollInterval) async {
      when(
        () => repo.submitAnswer(
          quizId: any(named: 'quizId'),
          questionId: any(named: 'questionId'),
          optionId: any(named: 'optionId'),
        ),
      ).thenAnswer(
        (_) async => answerResult(correct: true, explanationAvailable: true),
      );
      final bloc = QuizBloc(
        repository: repo,
        explanationPollInterval: pollInterval,
      );
      bloc
        ..add(QuizStarted(quiz()))
        ..add(const OptionSelected('q1-opt0'))
        ..add(const AnswerSubmitted());
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(bloc.state, isA<QuizInProgress>());
      return bloc;
    }

    test('is capped at ten asks and then gives up', () async {
      var asks = 0;
      when(() => repo.getExplanation(any())).thenAnswer((_) async {
        asks++;
        return const ExplanationGenerating();
      });
      final bloc = await gradedBloc(Duration.zero);
      bloc.add(const ExplanationRequested());
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(asks, 10);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(asks, 10, reason: 'kept polling after the cap');
      await bloc.close();
    });

    test('goes silent the moment the Bloc closes (quiz screen left, or the '
        'session ended)', () async {
      var asks = 0;
      when(() => repo.getExplanation(any())).thenAnswer((_) async {
        asks++;
        return const ExplanationGenerating();
      });
      final bloc = await gradedBloc(const Duration(milliseconds: 40));
      bloc.add(const ExplanationRequested());
      await Future<void>.delayed(const Duration(milliseconds: 130));
      expect(asks, greaterThanOrEqualTo(2));
      await bloc.close();
      final atClose = asks;
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(asks, atClose, reason: 'a poll fired after close');
    });

    test(
      "moving to the next question abandons the old question's poll",
      () async {
        final asked = <String>[];
        when(() => repo.getExplanation(any())).thenAnswer((inv) async {
          asked.add(inv.positionalArguments.first as String);
          return const ExplanationGenerating();
        });
        final bloc = await gradedBloc(const Duration(milliseconds: 40));
        bloc.add(const ExplanationRequested());
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(asked.toSet(), {'q1'});
        bloc.add(const NextQuestionRequested());
        await Future<void>.delayed(const Duration(milliseconds: 80));
        final afterNext = asked.length;
        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(asked.length, afterNext, reason: 'old question still polled');
        await bloc.close();
      },
    );
  });

  // ---------------------------------------------------------------------------
  // T5 - leaderboard scroll trigger against a failing page
  // ---------------------------------------------------------------------------
  e4Widgets('T5 leaderboard: a failed "load more" is asked ONCE, however many '
      'scroll ticks follow; only the student\'s Retry asks again', (
    tester,
  ) async {
    final rig = AppRig(signedIn: true);
    var appendAsks = 0;
    rig.server.scripted['GET /leaderboard'] = (o) {
      if (o.queryParameters['cursor'] != null) {
        appendAsks++;
        return problem(500, 'internal_error');
      }
      return null;
    };
    await rig.boot(tester, size: const Size(390, 700));
    await pumpFrames(tester, frames: 30);
    rig.container.read(routerProvider).go('/leaderboard');
    await pumpFrames(tester, frames: 20);
    expect(find.byType(LeaderboardScreen), findsOneWidget);

    final list = find.byType(ListView).last;
    for (var i = 0; i < 12; i++) {
      await tester.drag(list, const Offset(0, -2500));
      await pumpFrames(tester, frames: 3);
    }
    expect(appendAsks, 1, reason: 'scroll ticks re-sent the failed page');

    // The student's own Retry is one more, and only one more.
    await tester.tap(find.text('Retry').last);
    await pumpFrames(tester, frames: 8);
    expect(appendAsks, 2);
    for (var i = 0; i < 6; i++) {
      await tester.drag(list, const Offset(0, -2500));
      await pumpFrames(tester, frames: 3);
    }
    await tester.pump(const Duration(minutes: 3));
    expect(appendAsks, 2);
    await tearDownTree(tester, rig);
  });

  // ---------------------------------------------------------------------------
  // T6 - route sweep
  // ---------------------------------------------------------------------------
  const routes = <String>[
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

  Future<void> sweep(
    WidgetTester tester, {
    required String mode,
    required void Function(FakeServer) configure,
  }) async {
    final online = StreamController<bool>.broadcast();
    addTearDown(online.close);
    final rig = AppRig(signedIn: true, onlineStream: online.stream);
    configure(rig.server);
    await rig.boot(tester, size: const Size(390, 780));
    online.add(true);
    await pumpFrames(tester, frames: 40);

    final summary = <String>[];
    final grew = <String>[];
    for (final route in routes) {
      // ignore: avoid_print
      print('T6[$mode] -> $route');
      final before = rig.server.calls.length;
      rig.container.read(routerProvider).go(route);
      await pumpFrames(tester, frames: 25);
      final initial = rig.server.calls.skip(before).toList();
      summary.add(
        '$route -> ${initial.isEmpty ? '(none)' : initial.map((c) => c.key).join(', ')}',
      );
      final c1 = rig.server.calls.length;

      // Two idle minutes in one-second steps: no poll, no silent retry. A
      // runaway loop is cut off after 60 extra requests so it is reported
      // instead of hanging the run.
      for (var t = 0; t < 120; t++) {
        await tester.pump(const Duration(seconds: 1));
        if (rig.server.calls.length - c1 > 60) break;
      }
      final c2 = rig.server.calls.length;
      if (c2 != c1) {
        grew.add(
          '$route idle +${c2 - c1}: ${rig.server.calls.skip(c1).join(' | ')}',
        );
      }

      // The rebuild storm.
      rig.container.read(localeProvider.notifier).select(const Locale('ar'));
      await pumpFrames(tester, frames: 3);
      rig.container.read(themeModeProvider.notifier).select(ThemeMode.dark);
      await pumpFrames(tester, frames: 3);
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      await tester.binding.setSurfaceSize(const Size(900, 700));
      await pumpFrames(tester, frames: 3);
      online.add(false);
      await pumpFrames(tester, frames: 3);
      online.add(true);
      await pumpFrames(tester, frames: 3);
      resume();
      await pumpFrames(tester, frames: 5);
      rig.container.read(localeProvider.notifier).select(const Locale('en'));
      rig.container.read(themeModeProvider.notifier).select(ThemeMode.light);
      tester.platformDispatcher.clearAllTestValues();
      await tester.binding.setSurfaceSize(const Size(390, 780));
      await pumpFrames(tester, frames: 8);
      // The legal viewer's provider is keyed by (document, language), by
      // design (legal_document_provider.dart): flipping the locale there is a
      // different key and asks for the other language. Two flips, so at most
      // two fetches; anything else, or anywhere else, is a repeat.
      final stormCalls = rig.server.calls.skip(c2).toList();
      final byLanguage = stormCalls
          .where((c) => c.path.startsWith('/reference/legal-documents/'))
          .toList();
      final others = stormCalls.where((c) => !byLanguage.contains(c)).toList();
      if (byLanguage.length > 2) {
        grew.add(
          '$route storm: ${byLanguage.length} legal fetches for 2 language flips',
        );
      }
      if (others.isNotEmpty) {
        grew.add('$route storm +${others.length}: ${others.join(' | ')}');
      }
    }
    // ignore: avoid_print
    print('T6[$mode] initial requests per route:\n  ${summary.join('\n  ')}');

    final refreshes = rig.server.count('POST /auth/refresh');
    final stillIn = rig.auth is AuthAuthenticated;
    final refreshToken = await rig.storage.readRefreshToken();
    final stray = rig.tripwire.requests.toList();
    await tearDownTree(tester, rig);

    expect(
      grew,
      isEmpty,
      reason: '[$mode] requests repeated by themselves:\n${grew.join('\n')}',
    );
    expect(refreshes, 0);
    expect(stillIn, isTrue, reason: '[$mode] ended the session');
    expect(refreshToken, isNotNull);
    expect(stray, isEmpty);
  }

  e4Widgets('T6a sweep, healthy server', (tester) async {
    await sweep(tester, mode: 'healthy', configure: (_) {});
  });

  e4Widgets('T6b sweep, account pending deletion (every protected read is a '
      '403 except /me): no retry, no sign-out', (tester) async {
    await sweep(
      tester,
      mode: 'pending-deletion',
      configure: (s) => s.pendingDeletion = true,
    );
  });

  e4Widgets('T6c sweep, sick server (every protected call is a 500)', (
    tester,
  ) async {
    await sweep(
      tester,
      mode: 'server-500',
      configure: (s) => s.protectedStatus = 500,
    );
  });

  e4Widgets('T6d sweep, dead network (every protected call fails at the '
      'transport)', (tester) async {
    await sweep(
      tester,
      mode: 'dead-network',
      configure: (s) => s.protectedOffline = true,
    );
  });
}
