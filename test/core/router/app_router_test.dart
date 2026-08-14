import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements SecureStorage {}

void main() {
  group('authRedirect (pure guard)', () {
    test('unauthenticated on a protected route → /login', () {
      expect(authRedirect(const AuthUnauthenticated(), '/home'), '/login');
    });

    test('unauthenticated already on an auth route → stay', () {
      expect(authRedirect(const AuthUnauthenticated(), '/login'), isNull);
      expect(authRedirect(const AuthUnauthenticated(), '/otp'), isNull);
      expect(authRedirect(const AuthUnauthenticated(), '/register'), isNull);
    });

    test('the whole /register wizard stays reachable while signed out', () {
      // Registration happens BEFORE any account exists, so every track-detail
      // sub-route must survive the guard.
      for (final route in [
        '/register',
        '/register/track',
        '/register/school',
        '/register/university',
      ]) {
        expect(
          authRedirect(const AuthUnauthenticated(), route),
          isNull,
          reason: '$route must be reachable pre-auth',
        );
      }
    });

    test('authenticated sitting on /login → /home', () {
      expect(authRedirect(const AuthAuthenticated(), '/login'), '/home');
    });

    test('unauthenticated at / STAYS on / — onboarding must be reachable', () {
      // The bug this guards: `/` not being in _authRoutes sends a signed-out
      // student straight to /login, and onboarding is never seen at all.
      expect(authRedirect(const AuthUnauthenticated(), '/'), isNull);
    });

    test('authenticated at / → /home, never the onboarding pitch', () {
      // The other half: without this, a returning student cold-starting the app
      // lands on "Get Started / Log In" despite having a live session. This is
      // also what makes an "onboarding seen" flag unnecessary — auth state
      // already answers it, so nothing is persisted.
      expect(authRedirect(const AuthAuthenticated(), '/'), '/home');
    });

    test('unknown at / → wait; do not flash onboarding then bounce', () {
      expect(authRedirect(const AuthUnknown(), '/'), isNull);
    });

    test('authenticated on a protected route → stay', () {
      expect(authRedirect(const AuthAuthenticated(), '/home'), isNull);
    });

    test('unknown (first frame) → wait, never redirect', () {
      expect(authRedirect(const AuthUnknown(), '/home'), isNull);
      expect(authRedirect(const AuthUnknown(), '/login'), isNull);
    });
  });

  testWidgets('forceLogout flips the app from a protected route to /login', (
    tester,
  ) async {
    final storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.clearTokens()).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    // Authenticated baseline so the guard sends us onto a protected route.
    // (Synchronous — a bare `await Future.delayed` never fires under testWidgets.)
    container.read(authControllerProvider.notifier).markAuthenticated();

    final router = container.read(routerProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Authenticated at /login → redirected onto /home (a protected route).
    expect(find.byType(LoginScreen), findsNothing);

    // Server evicts the session.
    await container
        .read(authControllerProvider.notifier)
        .forceLogout(LogoutReason.supersededOtherDevice);
    await tester.pumpAndSettle();

    // The listenable fired → guard re-ran → user is on /login.
    expect(find.byType(LoginScreen), findsOneWidget);

    // Drain the forced-logout SnackBar's auto-hide timer so no timer is pending.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
