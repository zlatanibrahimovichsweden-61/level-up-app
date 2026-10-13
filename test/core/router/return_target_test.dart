import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/router/return_target.dart';
import 'package:level_up_app/core/router/route_error_screen.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/features/account_shells/screens/customer_support_screen.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/catalog/repository/catalog_repository.dart';
import 'package:level_up_app/features/catalog/screens/chapters_screen.dart';
import 'package:level_up_app/features/catalog/screens/subject_tree_screen.dart';
import 'package:level_up_app/features/catalog/screens/subjects_screen.dart';
import 'package:level_up_app/features/home/screens/home_screen.dart';
import 'package:level_up_app/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/features/profile/repository/profile_repository.dart';
import 'package:level_up_app/features/shell/screens/tab_placeholder.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

import '../../features/catalog/catalog_fixtures.dart';
import '../../features/leaderboard/leaderboard_fixtures.dart';
import '../../features/profile/profile_fixtures.dart';

/// Return-to-target (CW02 slice C): a signed-out bounce from a location INSIDE
/// THE TAB SHELL remembers it; the OTP sign-in landing goes back there, once; a
/// user-initiated sign-out remembers nothing; every location outside the shell
/// is not remembered and lands on Home. Plus the router's `errorBuilder`. (The
/// two registration submits are not return-target landings: they clear the
/// target and go Home — `registration_return_target_test.dart`.)
///
/// O-10: the target is returned only to the STUDENT whose session ended
/// (matched by the server's student id, never the phone), so a signed-out cold
/// start — no session ended in this process — lands on Home too, and a
/// different student signing in after a forced sign-out lands on Home with the
/// target dropped.
///
/// The router-driven groups use the REAL [routerProvider], its real redirect
/// and the real OTP screen — the redirect-time behaviour (what go_router hands
/// the callback for a pushed, a stored or an unmatched location) cannot be
/// reached any other way. Keep them router-driven.

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

class _MockProfileRepository extends Mock implements ProfileRepository {}

class _MockCatalogRepository extends Mock implements CatalogRepository {}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _tokens = TokenPair(
  accessToken: 'access.jwt',
  accessExpiresInSeconds: 900,
  refreshToken: 'refresh.jwt',
  refreshExpiresInSeconds: 5184000,
);
const _phoneDigits = '010000000001';

/// Student A: the student whose session ends, and who signs in again unless a
/// test says otherwise. Taken from the shared profile fixture so the id
/// `meProvider` loads is the id the verify response carries.
final _studentAId = schoolProfile().id;

/// Student B: a different student — a different server UUID.
const _studentBId = '0197b2f3-9999-7cc3-9b4e-0000000000b2';

/// A [ReturnTarget] whose `remember` and `clear` both fail. The router's
/// redirect must still bounce a signed-out student to `/login` — remembering
/// where they were is a convenience. `sessionEnding` is NOT overridden:
/// `forceLogout` must still be able to run. The messages carry no location.
class _ThrowingReturnTarget extends ReturnTarget {
  @override
  void remember(String location) => throw StateError('remember failed');

  @override
  void clear() => throw StateError('clear failed');
}

const _supersededMessage =
    "You've been signed out — your account was used on another device.";

/// A nested location inside the Learn branch, and its parents.
const _chapters = '/learn/subject/sub-1/unit/unit-1';
const _unitsOfSubject = '/learn/subject/sub-1';

void main() {
  // `GoRouter` initialises the widgets binding, and the pure group builds one.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => registerFallbackValue(_device));

  group('ReturnTarget', () {
    // O-10: the target belongs to the student whose session ended. Every test
    // that expects a location back binds an owner first (`sessionEnding`) and
    // consumes with that same id; every test that expects the fallback gets it
    // because of the OWNER rule, never merely because the caller passed no id —
    // `consume(studentId: null, …)` always answers the fallback, so it is not
    // used to assert "empty".
    const studentA = 'student-a';
    const studentB = 'student-b';

    test(
      'nothing remembered → consume gives the fallback, Home by default',
      () {
        final target = ReturnTarget()..sessionEnding(studentA);

        expect(target.consume(studentId: studentA), '/home');
        expect(
          target.consume(studentId: studentA, fallback: '/learn'),
          '/learn',
        );
      },
    );

    test('remember → the same student gets it back, exactly once', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn/subject/42?tab=2');

      expect(target.consume(studentId: studentA), '/learn/subject/42?tab=2');
      // Consumed: the second landing goes to the fallback.
      expect(target.consume(studentId: studentA), '/home');
    });

    test('the latest location wins', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn')
        ..remember('/leaderboard');

      expect(target.consume(studentId: studentA), '/leaderboard');
    });

    test('a DIFFERENT student gets the fallback — and the target is dropped, '
        'so the right student arriving later does not get it either', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn/subject/42');

      expect(target.consume(studentId: studentB), '/home');
      expect(target.consume(studentId: studentA), '/home');
    });

    test('an unknown owner fails closed: no session ending, or one whose '
        'student id could not be read, returns nothing to anybody', () {
      final unbound = ReturnTarget()..remember('/learn');
      expect(unbound.consume(studentId: studentA), '/home');

      final unreadable = ReturnTarget()
        ..sessionEnding(null)
        ..remember('/learn');
      expect(unreadable.consume(studentId: studentA), '/home');

      // Not even "unknown matches unknown".
      final bothUnknown = ReturnTarget()
        ..sessionEnding(null)
        ..remember('/learn');
      expect(bothUnknown.consume(studentId: null), '/home');
    });

    test('a sign-in that carried no student id fails closed — and still '
        'drops the target', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn');

      expect(target.consume(studentId: null), '/home');
      expect(target.consume(studentId: studentA), '/home');
    });

    test('sessionEnding forgets a location remembered earlier — a new session '
        'end starts a new binding', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn');

      // Student B's session ends next: A's location is never re-bound to B…
      target.sessionEnding(studentB);
      expect(target.consume(studentId: studentB), '/home');

      // …and not even the same student gets a location from an earlier end.
      final again = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn')
        ..sessionEnding(studentA);
      expect(again.consume(studentId: studentA), '/home');
    });

    test('a location remembered after sessionEnding belongs to that '
        'student', () {
      final target = ReturnTarget()
        ..sessionEnding(studentB)
        ..sessionEnding(studentA)
        ..remember('/message');

      expect(target.consume(studentId: studentA), '/message');
    });

    // O10-1: `sessionStarted` is how the target follows the LIVE session — every
    // completed sign-in reports here (`AuthController.markAuthenticated`), so a
    // target bound to someone else is gone before any landing can read it.
    group('sessionStarted — the target follows the live session', () {
      test('the owner signing in keeps the location, and the landing still '
          'gets it back, once', () {
        final target = ReturnTarget()
          ..sessionEnding(studentA)
          ..remember('/learn/subject/42?tab=2')
          ..sessionStarted(studentA);

        expect(
          target.consume(studentId: studentA, fallback: 'none'),
          '/learn/subject/42?tab=2',
        );
        expect(target.consume(studentId: studentA, fallback: 'none'), 'none');
      });

      test('a DIFFERENT student signing in drops the target — even when the '
          'owner is the one the landing later names', () {
        final target = ReturnTarget()
          ..sessionEnding(studentA)
          ..remember('/learn')
          ..sessionStarted(studentB);

        expect(target.consume(studentId: studentB, fallback: 'none'), 'none');
        expect(target.consume(studentId: studentA, fallback: 'none'), 'none');
      });

      test('the late-answer order: B signs in, then the landing names A → '
          'fallback', () {
        final target = ReturnTarget()
          ..sessionEnding(studentA)
          ..remember('/learn')
          ..sessionStarted(studentB);

        // The success view on screen belongs to A's verify, whose outcome
        // still says A; B is the live session.
        expect(target.consume(studentId: studentA, fallback: 'none'), 'none');
      });

      test('a sign-in that carried no id (null) drops the target — fail '
          'closed', () {
        final target = ReturnTarget()
          ..sessionEnding(studentA)
          ..remember('/learn')
          ..sessionStarted(null);

        expect(target.consume(studentId: studentA, fallback: 'none'), 'none');
      });

      test('no owner (remembered without sessionEnding, as a signed-out cold '
          'start does) → any sign-in drops the target', () {
        final unbound = ReturnTarget()
          ..remember('/learn')
          ..sessionStarted(studentA);
        expect(unbound.consume(studentId: studentA, fallback: 'none'), 'none');

        final unreadable = ReturnTarget()
          ..sessionEnding(null)
          ..remember('/learn')
          ..sessionStarted(null);
        expect(
          unreadable.consume(studentId: studentA, fallback: 'none'),
          'none',
        );
      });

      test('a drop also forgets the owner: what is remembered afterwards, '
          'with no new sessionEnding, belongs to nobody', () {
        final target = ReturnTarget()
          ..sessionEnding(studentA)
          ..remember('/learn')
          ..sessionStarted(studentB)
          ..remember('/message');

        expect(target.consume(studentId: studentA, fallback: 'none'), 'none');
      });
    });

    test('clear forgets the location', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn')
        ..clear();

      expect(target.consume(studentId: studentA), '/home');
    });

    test('clear forgets the owner too: what is remembered after it belongs '
        'to nobody', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn')
        ..clear()
        ..remember('/message');

      expect(target.consume(studentId: studentA), '/home');
    });

    test(
      'consume forgets the owner too: a location remembered afterwards, with '
      'no new sessionEnding, belongs to nobody',
      () {
        final target = ReturnTarget()
          ..sessionEnding(studentA)
          ..remember('/a');

        expect(target.consume(studentId: studentA), '/a');

        target.remember('/b');
        expect(target.consume(studentId: studentA, fallback: 'none'), 'none');
      },
    );

    test('anything that is not an app-relative location is ignored', () {
      final target = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('/learn');

      for (final bad in [
        '',
        'home',
        '//evil.example/x',
        'https://evil.example/',
      ]) {
        target.remember(bad);
      }

      // Neither stored nor allowed to displace what was already remembered.
      expect(target.consume(studentId: studentA), '/learn');

      final empty = ReturnTarget()
        ..sessionEnding(studentA)
        ..remember('https://evil.example/');
      expect(empty.consume(studentId: studentA, fallback: 'none'), 'none');
    });

    test('the provider is one instance per container, empty at the start', () {
      final a = ProviderContainer();
      final b = ProviderContainer();
      addTearDown(a.dispose);
      addTearDown(b.dispose);

      expect(
        identical(a.read(returnTargetProvider), a.read(returnTargetProvider)),
        isTrue,
      );
      a.read(returnTargetProvider)
        ..sessionEnding(studentA)
        ..remember('/learn');

      // No static state: another container starts empty, even when its owner
      // is the same student.
      b.read(returnTargetProvider).sessionEnding(studentA);
      expect(
        b
            .read(returnTargetProvider)
            .consume(studentId: studentA, fallback: 'none'),
        'none',
      );
      // …and the first one was not touched by it.
      expect(
        a.read(returnTargetProvider).consume(studentId: studentA),
        '/learn',
      );
    });
  });

  group('rememberableLocation (asks the router itself)', () {
    late RouteConfiguration configuration;

    setUp(() {
      final storage = _MockSecureStorage();
      when(() => storage.readAccessToken()).thenAnswer((_) async => null);
      final container = ProviderContainer(
        overrides: [secureStorageProvider.overrideWithValue(storage)],
      );
      addTearDown(container.dispose);
      configuration = container.read(routerProvider).configuration;
    });

    String? remembered(String location) =>
        rememberableLocation(configuration, Uri.parse(location));

    test('a location inside the shell is kept whole — path and query', () {
      expect(remembered('/home'), '/home');
      expect(remembered('/message?from=push'), '/message?from=push');
      expect(remembered(_chapters), _chapters);
      expect(
        remembered('/learn/subject/sub-1/unit/unit-1/chapter/chap-1?x=1'),
        '/learn/subject/sub-1/unit/unit-1/chapter/chap-1?x=1',
      );
    });

    test('a location outside the shell is not remembered', () {
      for (final location in [
        // auth routes
        '/',
        '/login',
        '/login/otp',
        '/register',
        '/register/track',
        '/register/school',
        '/register/university',
        // top-level routes outside the shell
        '/profile',
        '/profile/edit',
        '/settings',
        '/refer',
        '/support',
        '/friends',
        '/legal/privacy',
        '/legal/terms',
        // /quiz* — subsumed: top-level, and their pages need an in-memory extra
        '/quiz/setup',
        '/quiz/abc',
        '/quiz/abc/result',
        '/quiz/abc/result/review',
      ]) {
        expect(remembered(location), isNull, reason: location);
      }
    });

    test(
      'an unmatched location is not remembered, even under a shell path',
      () {
        expect(remembered('/nope'), isNull);
        expect(remembered('/learn/nothing-here'), isNull);
        expect(rememberableLocation(configuration, Uri()), isNull);
      },
    );

    test('derived from the route tree, not a list: EVERY route of the '
        'configuration is classified by whether it sits under the shell', () {
      final inShell = <String, bool>{};

      void walk(List<RouteBase> routes, String prefix, bool shell) {
        for (final route in routes) {
          switch (route) {
            case StatefulShellRoute(:final branches):
              for (final branch in branches) {
                walk(branch.routes, prefix, true);
              }
            case GoRoute(:final path, routes: final children):
              final full = path.startsWith('/') ? path : '$prefix/$path';
              inShell[full.replaceAll(RegExp(r':\w+'), 'x')] = shell;
              walk(children, full, shell);
            default:
              break;
          }
        }
      }

      walk(configuration.routes, '', false);

      // The walk really found the app (a future route is picked up by itself).
      expect(inShell.length, greaterThan(25));
      expect(inShell['/home'], isTrue);
      expect(
        inShell[_chapters.replaceAll(RegExp(r'sub-1|unit-1'), 'x')],
        isTrue,
      );
      expect(inShell['/support'], isFalse);
      expect(inShell['/quiz/x'], isFalse);

      for (final entry in inShell.entries) {
        expect(
          remembered(entry.key),
          entry.value ? entry.key : isNull,
          reason: entry.key,
        );
      }
    });

    test('every remembered shell location comes back WITH its parents: a '
        'shell route is either a tab root or nested under one, never flat', () {
      // Returned to with `go`, a shell location's stack is its matched
      // GoRoutes. A multi-segment shell route defined FLAT (its own top-level
      // branch route) would have only itself: nothing to pop to, so a back chip
      // calling `context.pop()` would throw. This derives the answer from the
      // route tree, so a flat route added later fails here.
      final tabRoots = <String>{};

      void walk(List<RouteBase> routes, String prefix, int level) {
        for (final route in routes) {
          if (route is! GoRoute) continue;
          final full = route.path.startsWith('/')
              ? route.path
              : '$prefix/${route.path}';
          final key = full.replaceAll(RegExp(r':\w+'), 'x');
          if (level == 0) {
            tabRoots.add(key);
          } else {
            // Nested: itself plus every ancestor is a matched page.
            final matched = configuration
                .findMatch(Uri.parse(key))
                .routes
                .whereType<GoRoute>()
                .length;
            expect(matched, level + 1, reason: '$key lost its parents');
          }
          walk(route.routes, full, level + 1);
        }
      }

      final shell = configuration.routes.whereType<StatefulShellRoute>().single;
      for (final branch in shell.branches) {
        walk(branch.routes, '', 0);
      }

      // A tab root is a single-segment route, and there are exactly five.
      expect(tabRoots, {
        '/home',
        '/leaderboard',
        '/learn',
        '/message',
        '/account',
      });
    });
  });

  group('through the real router', () {
    late _MockAuthRepository repo;
    late _MockSecureStorage storage;
    late _MockProfileRepository profile;
    late _MockCatalogRepository catalog;
    String? storedToken;

    setUp(() {
      storedToken = null;
      repo = _MockAuthRepository();
      storage = _MockSecureStorage();
      profile = _MockProfileRepository();
      catalog = _MockCatalogRepository();

      when(
        () => storage.readAccessToken(),
      ).thenAnswer((_) async => storedToken);
      when(() => storage.clearTokens()).thenAnswer((_) async {});
      when(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      ).thenAnswer((_) async {});

      // resendAfterSeconds: 0 → no countdown timer is left pending at teardown.
      when(() => repo.requestOtp(any())).thenAnswer(
        (_) async => const OtpRequestResult(
          resendAfterSeconds: 0,
          expiresInSeconds: 300,
        ),
      );
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).thenAnswer(
        (_) async => AuthResult.authenticated(
          tokens: _tokens,
          profile: {'id': _studentAId},
        ),
      );
      when(() => repo.logout()).thenAnswer((_) async {});

      // Home is the fallback landing, so it has to be able to render.
      when(profile.getMe).thenAnswer((_) async => schoolProfile());
      when(profile.getEntitlements).thenAnswer((_) async => [baseEntitlement]);

      // The Learn branch — a nested shell location must be able to render.
      when(catalog.getSubjects).thenAnswer((_) async => subjects());
      when(
        () => catalog.getSubjectTree(any()),
      ).thenAnswer((_) async => schoolTree());
    });

    /// [initialLocation] is a COLD START at that location (the platform's
    /// default route, which go_router honours over its own `initialLocation`).
    /// [signedIn] stores a live session first, exactly as the real controller
    /// resolves it. [resolveAuthFirst] lets the controller reach its answer
    /// BEFORE the router exists, so the very first parse already runs the
    /// redirect against `Unauthenticated`.
    Future<ProviderContainer> pumpApp(
      WidgetTester tester, {
      bool signedIn = false,
      String? initialLocation,
      Locale locale = const Locale('en'),
      bool resolveAuthFirst = false,
      ThemeData? theme,
      List<Override> overrides = const [],
    }) async {
      storedToken = signedIn ? 'access' : null;
      if (initialLocation != null) {
        tester.platformDispatcher.defaultRouteNameTestValue = initialLocation;
        addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
      }

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(repo),
          secureStorageProvider.overrideWithValue(storage),
          profileRepositoryProvider.overrideWithValue(profile),
          catalogRepositoryProvider.overrideWithValue(catalog),
          leaderboardRepositoryProvider.overrideWithValue(
            QuietLeaderboardRepository(),
          ),
          deviceInfoProvider.overrideWith((ref) async => _device),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
          ...overrides,
        ],
      );
      addTearDown(container.dispose);
      holdBoards(container);
      holdProfile(container);

      if (resolveAuthFirst) {
        container.read(authControllerProvider);
        await tester.pump();
        expect(
          container.read(authControllerProvider),
          isA<AuthUnauthenticated>(),
          reason: 'the controller must be signed out before the router exists',
        );
      }

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: locale,
            theme: theme ?? AppTheme.light,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: container.read(routerProvider),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    /// What the next correct code verifies into: `verifyOtp` answers
    /// `authenticated` with this `profile` payload (the default is student A).
    void stubVerifyProfile(Map<String, dynamic> profileJson) {
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).thenAnswer(
        (_) async =>
            AuthResult.authenticated(tokens: _tokens, profile: profileJson),
      );
    }

    /// Bounded frames: the OTP boxes blink a cursor forever, so `pumpAndSettle`
    /// would never settle from the OTP screen onward.
    Future<void> pumpFrames(WidgetTester tester) async {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    String location(ProviderContainer c) =>
        c.read(routerProvider).state.uri.toString();

    void go(ProviderContainer c, String target) =>
        c.read(routerProvider).go(target);

    // A `push` future completes only on pop, so it is deliberately not awaited.
    void push(ProviderContainer c, String target) =>
        unawaited(c.read(routerProvider).push<void>(target));

    /// The one-time sign-out SnackBar auto-hides after 4s; drain it so no timer
    /// is pending and nothing covers the form.
    Future<void> drainSnackBar(WidgetTester tester) async {
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    }

    /// /login → OTP → a correct code → the success view's Continue — the real
    /// sign-in landing.
    Future<void> signInThroughOtp(WidgetTester tester) async {
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.enterText(find.byType(TextField), _phoneDigits);
      await tester.tap(find.widgetWithText(FilledButton, 'Send OTP'));
      await pumpFrames(tester);
      expect(find.byType(OtpScreen), findsOneWidget);

      await tester.enterText(find.byType(Pinput), '000000');
      await pumpFrames(tester);
      expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
      await pumpFrames(tester);
    }

    /// Signed in on [from], the session is force-ended, the student signs in
    /// again. Returns with the sign-in landed.
    Future<void> forcedSignOutThenSignIn(
      WidgetTester tester,
      ProviderContainer container,
      LogoutReason reason,
    ) async {
      await container.read(authControllerProvider.notifier).forceLogout(reason);
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      await drainSnackBar(tester);
      await signInThroughOtp(tester);
      await tester.pumpAndSettle();
    }

    group('return-to-target — inside the tab shell', () {
      testWidgets('a signed-out cold start at a shell location bounces to '
          '/login and signs in to /home — no session ended in this process, '
          'so there is no owner to match (O-10)', (tester) async {
        final container = await pumpApp(
          tester,
          initialLocation: '/message?from=push',
        );

        // The bounce: signed out on a protected, real location.
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(location(container), '/login');

        await signInThroughOtp(tester);

        // No session ended here, so there is no owner: nothing is returned to
        // anybody (the location used to come back, path AND query).
        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(MessagePlaceholderScreen), findsNothing);

        // The next landing is Home too. (A user-initiated sign-out, so
        // the only thing that can send the second sign-in anywhere else is a
        // target that was not consumed.)
        await container.read(authControllerProvider.notifier).logout();
        await tester.pumpAndSettle();
        expect(find.byType(LoginScreen), findsOneWidget);

        await signInThroughOtp(tester);
        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('...also when the controller is already signed out at the '
          'very first parse (the redirect meets an empty configuration): the '
          'bounce still happens and sign-in lands on /home', (tester) async {
        final container = await pumpApp(
          tester,
          initialLocation: '/message?x=1',
          resolveAuthFirst: true,
        );

        // No exception, no error page: the first redirect ran against
        // `Unauthenticated` with nothing on screen yet, and still bounced.
        expect(find.byType(RouteErrorScreen), findsNothing);
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(location(container), '/login');

        await signInThroughOtp(tester);
        // No session ended here, so no owner: Home, not `/message?x=1`.
        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      for (final reason in [
        LogoutReason.sessionExpired,
        LogoutReason.supersededOtherDevice,
      ]) {
        testWidgets('a forced sign-out ($reason) on a tab root returns '
            'there after sign-in', (tester) async {
          final container = await pumpApp(tester, signedIn: true);
          expect(location(container), '/home');

          go(container, '/message');
          await tester.pumpAndSettle();
          expect(find.byType(MessagePlaceholderScreen), findsOneWidget);

          await forcedSignOutThenSignIn(tester, container, reason);

          expect(location(container), '/message');
          expect(find.byType(MessagePlaceholderScreen), findsOneWidget);
        });

        testWidgets('a forced sign-out ($reason) on a NESTED shell route '
            'returns there — with a stack beneath it and a back chip that '
            'works', (tester) async {
          final container = await pumpApp(tester, signedIn: true);

          go(container, _chapters);
          await tester.pumpAndSettle();
          expect(find.byType(ChaptersScreen), findsOneWidget);

          await forcedSignOutThenSignIn(tester, container, reason);

          // Back where the student was…
          expect(location(container), _chapters);
          expect(find.byType(ChaptersScreen), findsOneWidget);

          // …reached with `go`, yet the parents were built beneath it.
          expect(container.read(routerProvider).canPop(), isTrue);
          final back = find.descendant(
            of: find.byType(ChaptersScreen),
            matching: find.byType(CircleBackButton),
          );
          expect(back, findsOneWidget, reason: 'the header draws its chip');

          await tester.tap(back);
          await tester.pumpAndSettle();
          expect(location(container), _unitsOfSubject);
          expect(find.byType(SubjectTreeScreen), findsOneWidget);

          // And once more, to the tab root, where the chip is gone.
          await tester.tap(
            find.descendant(
              of: find.byType(SubjectTreeScreen),
              matching: find.byType(CircleBackButton),
            ),
          );
          await tester.pumpAndSettle();
          expect(location(container), '/learn');
          expect(find.byType(SubjectsScreen), findsOneWidget);
          expect(find.byType(CircleBackButton), findsNothing);
        });
      }

      testWidgets('a forced sign-out over a shell screen PUSHED inside the '
          'shell remembers the pushed one (the stored location is only its '
          'base)', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        go(container, '/learn');
        await tester.pumpAndSettle();
        push(container, _chapters);
        await tester.pumpAndSettle();
        expect(location(container), _chapters);

        await forcedSignOutThenSignIn(
          tester,
          container,
          LogoutReason.sessionExpired,
        );

        expect(location(container), _chapters);
        expect(find.byType(ChaptersScreen), findsOneWidget);
      });

      testWidgets('a user-initiated sign-out goes Home next time — and '
          'clears a target remembered earlier', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        go(container, '/message');
        await tester.pumpAndSettle();

        // A target left over from an earlier forced sign-out that was never
        // consumed — bound to student A, who signs in again below, so only
        // the user-initiated sign-out's clear can keep it from coming back.
        container.read(returnTargetProvider)
          ..sessionEnding(_studentAId)
          ..remember('/learn');

        await container.read(authControllerProvider.notifier).logout();
        await tester.pumpAndSettle();
        expect(find.byType(LoginScreen), findsOneWidget);

        await signInThroughOtp(tester);

        // Not /message (where the student was) and not /learn (the leftover).
        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('the one-time sign-out message still shows exactly once '
          'with a return target pending', (tester) async {
        final container = await pumpApp(tester, signedIn: true);
        go(container, '/message');
        await tester.pumpAndSettle();

        await container
            .read(authControllerProvider.notifier)
            .forceLogout(LogoutReason.supersededOtherDevice);
        await tester.pumpAndSettle();

        // Bounced AND remembered — and the message is shown, once.
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.text(_supersededMessage), findsOneWidget);
        expect(
          (container.read(authControllerProvider) as AuthUnauthenticated)
              .reason,
          isNull,
          reason: 'the reason is consumed when the message is shown',
        );

        await drainSnackBar(tester);
        expect(find.text(_supersededMessage), findsNothing);

        // Signing in still returns to the remembered location.
        await signInThroughOtp(tester);
        expect(location(container), '/message');
      });
    });

    group('not remembered — lands on Home', () {
      testWidgets('a signed-out cold start at a location OUTSIDE the shell '
          '(/support) bounces to /login and signs in to /home', (tester) async {
        final container = await pumpApp(
          tester,
          initialLocation: '/support?from=push',
        );

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(location(container), '/login');

        await signInThroughOtp(tester);

        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(CustomerSupportScreen), findsNothing);
      });

      testWidgets('a forced sign-out over a PUSHED /support (outside the '
          'shell) goes Home', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        push(container, '/support');
        await tester.pumpAndSettle();
        expect(location(container), '/support');

        await forcedSignOutThenSignIn(
          tester,
          container,
          LogoutReason.sessionExpired,
        );

        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('...and over a shell page, what comes back is the shell '
          'page beneath it — never the non-shell page', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        go(container, '/message');
        await tester.pumpAndSettle();
        push(container, '/support');
        await tester.pumpAndSettle();

        await forcedSignOutThenSignIn(
          tester,
          container,
          LogoutReason.sessionExpired,
        );

        expect(location(container), '/message');
        expect(find.byType(CustomerSupportScreen), findsNothing);
      });

      testWidgets('a forced sign-out ON a top-level route outside the shell '
          '(go, not push) goes Home', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        go(container, '/settings');
        await tester.pumpAndSettle();

        await forcedSignOutThenSignIn(
          tester,
          container,
          LogoutReason.supersededOtherDevice,
        );

        expect(location(container), '/home');
      });

      testWidgets('a forced sign-out with nothing rememberable CLEARS an older '
          'target instead of keeping it', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        // A target left over from an earlier bounce that was never consumed.
        // It has to be there AFTER `forceLogout` has bound the sign-out to
        // student A (which forgets anything remembered before) and before the
        // router's bounce, so it is planted while the tokens are being cleared.
        // A signs in again below: only the router's clear can keep it from
        // coming back.
        when(() => storage.clearTokens()).thenAnswer((_) async {
          container.read(returnTargetProvider).remember('/message');
        });

        // The newest bounce is from a non-shell location: nothing to remember.
        go(container, '/settings');
        await tester.pumpAndSettle();

        await forcedSignOutThenSignIn(
          tester,
          container,
          LogoutReason.sessionExpired,
        );

        // Not /message (the stale target) and not /settings (never remembered).
        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
      });

      testWidgets('an unmatched location is never remembered — signed out it '
          'bounces to /login and sign-in lands on Home', (tester) async {
        final container = await pumpApp(tester);
        expect(find.byType(OnboardingScreen), findsOneWidget);

        go(container, '/nope');
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(location(container), '/login');

        await signInThroughOtp(tester);
        expect(location(container), '/home');
      });

      testWidgets('a /quiz location is never remembered (its page needs an '
          'in-memory extra)', (tester) async {
        final container = await pumpApp(tester);

        go(container, '/quiz/setup');
        await tester.pumpAndSettle();
        expect(location(container), '/login');

        await signInThroughOtp(tester);
        expect(location(container), '/home');
      });

      testWidgets('signed-out auth routes stay put and remember nothing', (
        tester,
      ) async {
        final container = await pumpApp(tester);
        expect(location(container), '/');

        go(container, '/login');
        await tester.pumpAndSettle();
        expect(location(container), '/login');

        // Nothing was remembered by sitting on the auth routes: sign-in → Home.
        await signInThroughOtp(tester);
        expect(location(container), '/home');
      });
    });

    // Owner decision O-10. The handset is shared: student A's session ends on a
    // shell location, and the next sign-in may be student B's. The target is
    // bound to the student whose session ended (the server's id, read from
    // `/me` at the moment of the forced sign-out and compared with the id the
    // verify response carries) and fails closed whenever either side is
    // unknown.
    group('O-10 — the return target belongs to the student whose session '
        'ended', () {
      for (final reason in [
        LogoutReason.sessionExpired,
        LogoutReason.supersededOtherDevice,
      ]) {
        testWidgets('the owner scenario ($reason): student A is forced out on '
            'a nested shell location, student B signs in → Home, and the '
            'target is gone', (tester) async {
          final container = await pumpApp(tester, signedIn: true);

          go(container, _chapters);
          await tester.pumpAndSettle();
          expect(find.byType(ChaptersScreen), findsOneWidget);

          // The next correct code belongs to a different student.
          stubVerifyProfile({'id': _studentBId});

          await forcedSignOutThenSignIn(tester, container, reason);

          // Not A's location: Home.
          expect(location(container), '/home');
          expect(find.byType(HomeScreen), findsOneWidget);
          expect(find.byType(ChaptersScreen), findsNothing);

          // Dropped, not merely skipped: A arriving afterwards (the target
          // would still be waiting for A if B's landing had left it) gets
          // nothing either.
          expect(
            container
                .read(returnTargetProvider)
                .consume(studentId: _studentAId, fallback: 'none'),
            'none',
          );
        });

        testWidgets('the same student re-authenticating ($reason) is '
            'returned to the nested location, with its parent stack', (
          tester,
        ) async {
          final container = await pumpApp(tester, signedIn: true);

          go(container, _chapters);
          await tester.pumpAndSettle();
          expect(find.byType(ChaptersScreen), findsOneWidget);

          // The default verify answer: student A again.
          await forcedSignOutThenSignIn(tester, container, reason);

          expect(location(container), _chapters);
          expect(find.byType(ChaptersScreen), findsOneWidget);
          expect(container.read(routerProvider).canPop(), isTrue);

          // Handed back once: the landing consumed the holder.
          expect(
            container
                .read(returnTargetProvider)
                .consume(studentId: _studentAId, fallback: 'none'),
            'none',
          );
        });
      }

      for (final payload in <Map<String, dynamic>>[
        <String, dynamic>{},
        <String, dynamic>{'id': ''},
        <String, dynamic>{'id': 7},
      ]) {
        testWidgets('a verify response that carries no usable student id '
            '($payload) fails closed → Home', (tester) async {
          final container = await pumpApp(tester, signedIn: true);

          go(container, _chapters);
          await tester.pumpAndSettle();
          stubVerifyProfile(payload);

          await forcedSignOutThenSignIn(
            tester,
            container,
            LogoutReason.sessionExpired,
          );

          expect(location(container), '/home');
          expect(find.byType(HomeScreen), findsOneWidget);
          expect(find.byType(ChaptersScreen), findsNothing);
        });
      }

      testWidgets('an ending session whose student was never read (/me has no '
          'value) fails closed → Home, even for the same student signing '
          'in', (tester) async {
        // `/me` never produces a value for this session, so there is nobody to
        // bind the target to.
        when(profile.getMe).thenAnswer((_) async => throw Exception('no /me'));
        final container = await pumpApp(tester, signedIn: true);

        go(container, _chapters);
        await tester.pumpAndSettle();
        expect(find.byType(ChaptersScreen), findsOneWidget);

        await forcedSignOutThenSignIn(
          tester,
          container,
          LogoutReason.sessionExpired,
        );

        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(ChaptersScreen), findsNothing);
      });

      // O10-1. A verify started on an OTP screen the student then left still
      // completes in the background: it writes the tokens and calls
      // `markAuthenticated` even though its screen is gone (deliberate — the
      // student must not end up authenticated-but-not-routed). So it can land
      // AFTER another sign-in, and the LIVE session is then the late student's
      // while the success view still on screen belongs to the earlier verify.
      // The view's Continue names the id of its OWN outcome, so the target has
      // to follow the live session itself: `markAuthenticated` reports every
      // completed sign-in to `ReturnTarget.sessionStarted`.
      group('a verify the student walked away from completes late', () {
        /// Student A is forced out on a nested shell location. Someone enters a
        /// code and that verify (the returned completer) hangs; the student
        /// backs out of the OTP screen, and student A signs in again, so A's
        /// success view is showing. Returns with that success view on screen.
        Future<({ProviderContainer container, Completer<AuthResult> hung})>
        hungVerifyThenASignsIn(WidgetTester tester) async {
          final container = await pumpApp(tester, signedIn: true);
          go(container, _chapters);
          await tester.pumpAndSettle();
          expect(find.byType(ChaptersScreen), findsOneWidget);

          await container
              .read(authControllerProvider.notifier)
              .forceLogout(LogoutReason.sessionExpired);
          await tester.pumpAndSettle();
          expect(find.byType(LoginScreen), findsOneWidget);
          await drainSnackBar(tester);

          // 1. The first verify hangs.
          final hung = Completer<AuthResult>();
          when(
            () => repo.verifyOtp(
              phone: any(named: 'phone'),
              code: any(named: 'code'),
              device: any(named: 'device'),
            ),
          ).thenAnswer((_) => hung.future);
          await tester.enterText(find.byType(TextField), _phoneDigits);
          await tester.tap(find.widgetWithText(FilledButton, 'Send OTP'));
          await pumpFrames(tester);
          expect(find.byType(OtpScreen), findsOneWidget);
          await tester.enterText(find.byType(Pinput), '000000');
          await pumpFrames(tester);

          // 2. Back while that verify is in flight.
          await tester.tap(find.byType(CircleBackButton));
          await pumpFrames(tester);
          expect(find.byType(LoginScreen), findsOneWidget);

          // 3. Student A signs in again; A's success view shows.
          stubVerifyProfile({'id': _studentAId});
          await tester.enterText(find.byType(TextField), _phoneDigits);
          await tester.tap(find.widgetWithText(FilledButton, 'Send OTP'));
          await pumpFrames(tester);
          await tester.enterText(find.byType(Pinput), '000000');
          await pumpFrames(tester);
          expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);

          return (container: container, hung: hung);
        }

        testWidgets('the late answer is student B\'s: B is the live session, '
            'so A\'s Continue lands on Home — not on A\'s location — and the '
            'target is gone', (tester) async {
          final (:container, :hung) = await hungVerifyThenASignsIn(tester);

          // 4. The hung verify finally answers — for student B.
          hung.complete(
            AuthResult.authenticated(
              tokens: _tokens,
              profile: {'id': _studentBId},
            ),
          );
          await pumpFrames(tester);

          // 5. Continue on A's success view.
          await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
          await pumpFrames(tester);
          await tester.pumpAndSettle();

          expect(location(container), '/home');
          expect(find.byType(HomeScreen), findsOneWidget);
          expect(find.byType(ChaptersScreen), findsNothing);
          expect(
            container
                .read(returnTargetProvider)
                .consume(studentId: _studentAId, fallback: 'none'),
            'none',
          );
        });

        testWidgets('control: the late answer is student A\'s own → A is still '
            'returned to the nested location, so the target is dropped only '
            'when the student changes', (tester) async {
          final (:container, :hung) = await hungVerifyThenASignsIn(tester);

          hung.complete(
            AuthResult.authenticated(
              tokens: _tokens,
              profile: {'id': _studentAId},
            ),
          );
          await pumpFrames(tester);

          await tester.tap(find.widgetWithText(FilledButton, 'Continue'));
          await pumpFrames(tester);
          await tester.pumpAndSettle();

          expect(location(container), _chapters);
          expect(find.byType(ChaptersScreen), findsOneWidget);
          expect(container.read(routerProvider).canPop(), isTrue);
        });
      });

      // o10-carryover-01. After a return-to-target landing straight into a
      // non-Home branch the rebuilt shell builds only that (lazy) branch, so
      // Home never mounts and `/me` is never loaded. Here `/me` NEVER settles
      // — it throws before the app is pumped, so neither the container-level
      // hold nor Home can supply an id — and the app starts signed OUT: the
      // only place student A's id can come from is the sign-in response, which
      // `markAuthenticated` captures.
      group('a session that signed in here binds by the id it signed in with, '
          'with no /me', () {
        Future<ProviderContainer> signedInAsAWithoutMe(
          WidgetTester tester,
        ) async {
          when(
            profile.getMe,
          ).thenAnswer((_) async => throw Exception('no /me'));
          final container = await pumpApp(tester);
          go(container, '/login');
          await tester.pumpAndSettle();
          await signInThroughOtp(tester);
          await tester.pumpAndSettle();
          expect(location(container), '/home');

          go(container, _chapters);
          await tester.pumpAndSettle();
          expect(find.byType(ChaptersScreen), findsOneWidget);
          return container;
        }

        testWidgets('student A is returned to the nested location after a '
            'forced sign-out — and again after a SECOND one from there', (
          tester,
        ) async {
          final container = await signedInAsAWithoutMe(tester);

          await forcedSignOutThenSignIn(
            tester,
            container,
            LogoutReason.sessionExpired,
          );
          expect(location(container), _chapters);
          expect(find.byType(ChaptersScreen), findsOneWidget);
          // Home was never built on the way back: nothing could have loaded
          // `/me` for the second sign-out.
          expect(find.byType(HomeScreen, skipOffstage: false), findsNothing);

          await forcedSignOutThenSignIn(
            tester,
            container,
            LogoutReason.supersededOtherDevice,
          );
          expect(location(container), _chapters);
          expect(find.byType(ChaptersScreen), findsOneWidget);
          expect(container.read(routerProvider).canPop(), isTrue);
        });

        testWidgets('student B signing in after student A was forced out '
            'lands on Home', (tester) async {
          final container = await signedInAsAWithoutMe(tester);

          stubVerifyProfile({'id': _studentBId});
          await forcedSignOutThenSignIn(
            tester,
            container,
            LogoutReason.sessionExpired,
          );

          expect(location(container), '/home');
          expect(find.byType(HomeScreen), findsOneWidget);
          expect(find.byType(ChaptersScreen), findsNothing);
        });
      });
    });

    group('a failing return target cannot stop the bounce', () {
      // The redirect wraps its bookkeeping in try/catch for exactly this: if
      // remembering where the student was fails for any reason, they must
      // still reach /login (not the router's error page, not an unhandled
      // exception). `/message` takes the `remember` path, `/settings` — outside
      // the shell, nothing to remember — takes the `clear` path.
      for (final from in ['/message', '/settings']) {
        testWidgets('a forced sign-out from $from still lands on /login when '
            'remember and clear throw', (tester) async {
          final container = await pumpApp(
            tester,
            signedIn: true,
            overrides: [
              returnTargetProvider.overrideWithValue(_ThrowingReturnTarget()),
            ],
          );

          go(container, from);
          await tester.pumpAndSettle();
          expect(location(container), from);

          await container
              .read(authControllerProvider.notifier)
              .forceLogout(LogoutReason.sessionExpired);
          await tester.pumpAndSettle();

          expect(location(container), '/login');
          expect(find.byType(LoginScreen), findsOneWidget);
          expect(find.byType(RouteErrorScreen), findsNothing);
          expect(tester.takeException(), isNull);

          await drainSnackBar(tester);
        });
      }
    });

    group('errorBuilder', () {
      testWidgets('a signed-in unknown location shows the shared error '
          'state with genericError and no Retry (EN, LTR)', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        go(container, '/nope');
        await tester.pumpAndSettle();

        expect(find.byType(RouteErrorScreen), findsOneWidget);
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.byType(CircleBackButton), findsOneWidget);
        // No Retry: re-running an unknown location cannot succeed.
        expect(find.text('Retry'), findsNothing);
        expect(find.byType(FilledButton), findsNothing);
        expect(
          Directionality.of(tester.element(find.byType(RouteErrorScreen))),
          TextDirection.ltr,
        );
        // Nothing about the location leaks onto the screen.
        expect(find.textContaining('nope'), findsNothing);
      });

      testWidgets('the same screen in Arabic (RTL), still without Retry', (
        tester,
      ) async {
        final container = await pumpApp(
          tester,
          signedIn: true,
          locale: const Locale('ar'),
        );

        go(container, '/nope');
        await tester.pumpAndSettle();

        expect(find.byType(RouteErrorScreen), findsOneWidget);
        expect(find.text('حدث خطأ ما'), findsOneWidget);
        expect(find.text('إعادة المحاولة'), findsNothing);
        expect(find.byType(FilledButton), findsNothing);
        expect(
          Directionality.of(tester.element(find.byType(RouteErrorScreen))),
          TextDirection.rtl,
        );
      });

      testWidgets('the DARK theme renders the same error state without '
          'exceptions (EN)', (tester) async {
        final container = await pumpApp(
          tester,
          signedIn: true,
          theme: AppTheme.dark,
        );

        go(container, '/nope');
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.byType(RouteErrorScreen), findsOneWidget);
        expect(
          Theme.of(tester.element(find.byType(RouteErrorScreen))).brightness,
          Brightness.dark,
        );
        // The same copy and controls as the light theme.
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.byType(CircleBackButton), findsOneWidget);
        expect(find.text('Retry'), findsNothing);
        expect(find.byType(FilledButton), findsNothing);
      });

      testWidgets('back with nothing to pop goes Home', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        // `go` replaces the stack: the error page is all there is.
        go(container, '/nope');
        await tester.pumpAndSettle();
        expect(find.byType(RouteErrorScreen), findsOneWidget);

        await tester.tap(find.byType(CircleBackButton));
        await tester.pumpAndSettle();

        expect(location(container), '/home');
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(RouteErrorScreen), findsNothing);
      });

      testWidgets('back pops when the unknown location was pushed over a '
          'screen', (tester) async {
        final container = await pumpApp(tester, signedIn: true);

        go(container, '/support');
        await tester.pumpAndSettle();
        push(container, '/nope');
        await tester.pumpAndSettle();
        expect(find.byType(RouteErrorScreen), findsOneWidget);

        await tester.tap(find.byType(CircleBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(RouteErrorScreen), findsNothing);
        expect(find.byType(CustomerSupportScreen), findsOneWidget);
        expect(location(container), '/support');
      });

      testWidgets('a signed-out cold start at an unknown location goes to '
          '/login, not the error screen', (tester) async {
        final container = await pumpApp(tester, initialLocation: '/nope');

        expect(find.byType(RouteErrorScreen), findsNothing);
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(location(container), '/login');
      });
    });
  });
}
