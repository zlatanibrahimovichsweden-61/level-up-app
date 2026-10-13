import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:level_up_app/features/registration/notifier/registration_controller.dart';
import 'package:level_up_app/features/registration/screens/signup_identity_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

/// BUG-001 regression. Drives login → OTP → `/register` through the REAL
/// [routerProvider] and real `context.go`, because that is the only way the
/// defect is reachable: seeding the draft from `SignupIdentityScreen.initState`
/// mutated a provider during element mount, and Riverpod only asserts on that
/// when the screen mounts into an EXISTING tree (a go_router rebuild). Every
/// other wizard test pumps the screen into a fresh `ProviderScope`, where it
/// mounts during the initial build and the guard flag is not set — so a
/// direct-pump test cannot catch this, by construction.
///
/// Keep this test router-driven. If it is ever "simplified" into a direct pump,
/// it stops testing anything.

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _phoneDigits = '010000000001';
const _phoneE164 = '+2010000000001'; // what Phone.tryParse normalizes it to

void main() {
  setUpAll(() => registerFallbackValue(_device));

  late _MockAuthRepository repo;
  late _MockSecureStorage storage;

  setUp(() {
    repo = _MockAuthRepository();
    storage = _MockSecureStorage();

    // Signed out → the guard leaves us on /login and the whole /register
    // wizard stays reachable.
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});

    // resendAfterSeconds: 0 → no countdown timer is left pending at teardown.
    when(() => repo.requestOtp(any())).thenAnswer(
      (_) async =>
          const OtpRequestResult(resendAfterSeconds: 0, expiresInSeconds: 300),
    );
    // The fork under test: no account yet → registrationRequired.
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenAnswer(
      (_) async => const AuthResult.registrationRequired(
        registrationToken: 'reg.token',
        expiresInSeconds: 600,
      ),
    );
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
        // Deterministic connectivity — no platform channel in a widget test.
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// The real app shell: real router, real redirect guard, real screens.
  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    final container = makeContainer();
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

  /// A bounded stand-in for `pumpAndSettle`, used from the OTP screen onward:
  /// the auto-focused OTP boxes (and later the identity fields) blink a cursor
  /// forever, so `pumpAndSettle` would never settle. 1s of frames comfortably
  /// covers a route transition.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// onboarding → login → OTP → (registrationRequired) → `/register`, all via
  /// real navigation.
  Future<void> reachRegister(WidgetTester tester) async {
    // A signed-out cold start now lands on onboarding (`/`), not `/login` —
    // so the walk starts one screen earlier, exactly as a student's does.
    expect(find.byType(OnboardingScreen), findsOneWidget);
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField), _phoneDigits);
    await tester.tap(find.widgetWithText(FilledButton, 'Send OTP'));
    await pumpFrames(tester);

    expect(find.byType(OtpScreen), findsOneWidget);
    // Completing the 6 boxes auto-submits, exactly as on device.
    await tester.enterText(find.byType(Pinput), '482913');
    await pumpFrames(tester);
  }

  Future<void> tapContinue(WidgetTester tester) async {
    final finder = find.widgetWithText(FilledButton, 'Continue');
    await tester.ensureVisible(finder); // the form can exceed the viewport
    await pumpFrames(tester);
    await tester.tap(finder);
    await pumpFrames(tester);
  }

  testWidgets(
    'router-driven OTP → /register renders Sign Up_1 without red-screening',
    (tester) async {
      final container = await pumpApp(tester);

      await reachRegister(tester);

      // The bug: this navigation painted Flutter's red ErrorWidget instead.
      expect(find.byType(ErrorWidget), findsNothing);
      expect(find.byType(SignupIdentityScreen), findsOneWidget);
      // Seeded at the OTP step — not by the screen it landed on.
      final draft = container.read(registrationControllerProvider);
      expect(draft, isNotNull);
      expect(draft!.registrationToken, 'reg.token');
      expect(draft.phone, _phoneE164);
      // The proven phone is rendered read-only, so the form is really up.
      expect(find.byType(TextField), findsNWidgets(3));
    },
  );

  testWidgets('Continue from Sign Up_1 reaches the Choose Your Track screen', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await reachRegister(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Mostafa');
    await tester.enterText(find.byType(TextField).at(1), '01000000000');
    await tapContinue(tester);

    expect(find.byType(ErrorWidget), findsNothing);
    expect(find.text('Choose Your Track'), findsOneWidget);
    // The identity the wizard accumulated survived the real navigation.
    final draft = container.read(registrationControllerProvider)!;
    expect(draft.name, 'Mostafa');
    expect(draft.parentPhone, '+201000000000');
  });
}
