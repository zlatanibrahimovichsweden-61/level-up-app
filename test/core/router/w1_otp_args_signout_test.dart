import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');

/// `resendAfterSeconds: 0` leaves no countdown timer pending at teardown.
const _args = OtpArgs(
  phone: '+2010000000001',
  resendAfterSeconds: 0,
  expiresInSeconds: 300,
);

/// NR-29: the router keeps the args the OTP page was last opened with in its
/// provider closure (go_router drops a non-JSON `extra` on every auth refresh,
/// so the success view would otherwise rebuild with nothing). That closure is
/// out of `invalidateSessionScope`'s reach, so the args - which carry the phone
/// number the code was sent to - used to outlive the session that entered them.
///
/// What this pins, all through the REAL router and the REAL OTP screen:
///
/// 1. The args survive the flip a correct code causes (signed out -> signed
///    in): the success view is still on screen after it. This is the half that
///    must not be broken by the fix.
/// 2. A session ENDING (the move into signed out from a signed-in session)
///    drops them: the OTP route no longer has anything to show and sends the
///    student to `/login`, and a fresh visit to `/login/otp` with no args of
///    its own cannot bring the previous phone back.
/// 3. A REPEAT of signed out (not a session ending) drops nothing.
///
/// Nothing here prints, logs or asserts on the phone number itself.
void main() {
  late _MockAuthRepository repo;
  late _MockSecureStorage storage;

  setUp(() {
    repo = _MockAuthRepository();
    storage = _MockSecureStorage();
    // Signed out at launch.
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    when(() => storage.clearTokens()).thenAnswer((_) async {});
    when(() => repo.logout()).thenAnswer((_) async {});
  });

  Future<ProviderContainer> pumpSignedOut(WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(routerProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  /// Bounded frames: the OTP boxes blink a cursor forever, so `pumpAndSettle`
  /// never settles from the OTP screen onward.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// The one-time sign-out SnackBar auto-hides after 4s; drain it so no timer
  /// is pending at teardown.
  Future<void> drainSnackBar(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 4));
    await pumpFrames(tester);
  }

  String location(ProviderContainer c) =>
      c.read(routerProvider).state.uri.toString();

  /// Signed out, the OTP page opened exactly as Login opens it, then the
  /// correct code: the auth flip that leaves the success view on screen.
  Future<ProviderContainer> signedInOnTheOtpPage(WidgetTester tester) async {
    final container = await pumpSignedOut(tester);
    container.read(routerProvider).go('/login/otp', extra: _args);
    await pumpFrames(tester);
    expect(find.byType(OtpScreen), findsOneWidget);

    container.read(authControllerProvider.notifier).markAuthenticated();
    await pumpFrames(tester);
    return container;
  }

  group('the args survive the post-verify flip', () {
    testWidgets('the OTP page is still on screen after a correct code flips '
        'auth to signed in (BUG-005 stays fixed)', (tester) async {
      final container = await signedInOnTheOtpPage(tester);

      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
      expect(find.byType(OtpScreen), findsOneWidget);
      expect(location(container), '/login/otp');
      expect(tester.takeException(), isNull);
    });
  });

  group('the args end with the session', () {
    for (final signOut in <(String, Future<void> Function(ProviderContainer))>[
      (
        'a forced sign-out',
        (c) => c
            .read(authControllerProvider.notifier)
            .forceLogout(LogoutReason.sessionExpired),
      ),
      (
        'a user-initiated sign-out',
        (c) => c.read(authControllerProvider.notifier).logout(),
      ),
    ]) {
      testWidgets('${signOut.$1} drops them: the OTP route has nothing to '
          'show and goes to /login', (tester) async {
        final container = await signedInOnTheOtpPage(tester);

        await signOut.$2(container);
        await pumpFrames(tester);

        expect(
          container.read(authControllerProvider),
          isA<AuthUnauthenticated>(),
        );
        // The refresh that the sign-out causes re-parses /login/otp with no
        // extra; with the args gone the route redirects instead of showing the
        // previous student's code screen.
        expect(find.byType(OtpScreen), findsNothing);
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(location(container), '/login');

        await drainSnackBar(tester);
      });

      testWidgets('after ${signOut.$1}, /login/otp without args of its own '
          'cannot bring the previous page back', (tester) async {
        final container = await signedInOnTheOtpPage(tester);
        await signOut.$2(container);
        await pumpFrames(tester);
        await drainSnackBar(tester);

        // A stale re-entry: no `extra`, as after a refresh or a deep link.
        container.read(routerProvider).go('/login/otp');
        await pumpFrames(tester);

        expect(find.byType(OtpScreen), findsNothing);
        expect(location(container), '/login');
      });

      testWidgets('after ${signOut.$1}, a NEW visit with its own args works '
          'as ever', (tester) async {
        final container = await signedInOnTheOtpPage(tester);
        await signOut.$2(container);
        await pumpFrames(tester);
        await drainSnackBar(tester);

        container.read(routerProvider).go('/login/otp', extra: _args);
        await pumpFrames(tester);

        expect(find.byType(OtpScreen), findsOneWidget);
        expect(location(container), '/login/otp');
      });
    }
  });

  group('a repeat of signed out is not a session ending', () {
    testWidgets('signed out on the OTP page, another signed-out status '
        '(logout while already signed out) leaves the page up', (tester) async {
      final container = await pumpSignedOut(tester);
      expect(
        container.read(authControllerProvider),
        isA<AuthUnauthenticated>(),
      );

      container.read(routerProvider).go('/login/otp', extra: _args);
      await pumpFrames(tester);
      expect(find.byType(OtpScreen), findsOneWidget);

      // Signed out -> signed out, with a fresh status object: a status change
      // the router hears, but no session ended. The args are not dropped.
      await container.read(authControllerProvider.notifier).logout();
      await pumpFrames(tester);

      expect(find.byType(OtpScreen), findsOneWidget);
      expect(location(container), '/login/otp');
    });
  });
}
