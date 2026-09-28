import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/router/app_router.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/circle_back_button.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/login_screen.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

/// BUG-005 regression. Drives onboarding → login → OTP → a correct code
/// through the REAL [routerProvider] and its redirect guard, because that is
/// the only place the defect lives: Login used to `push('/otp')`, the router's
/// location stayed `/login`, and the moment verify flipped auth the signed-in
/// redirect off `/login` sent the student to `/home` — the success view was
/// never seen on a device. Every other success test pumps `OtpScreen` directly,
/// with no router, so no redirect ever ran.
///
/// Keep this test router-driven, for the same reason BUG-001's is.

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _tokens = TokenPair(
  accessToken: 'access.jwt',
  accessExpiresInSeconds: 900,
  refreshToken: 'refresh.jwt',
  refreshExpiresInSeconds: 5184000,
);

void main() {
  setUpAll(() => registerFallbackValue(_device));

  late _MockAuthRepository repo;
  late _MockSecureStorage storage;

  setUp(() {
    repo = _MockAuthRepository();
    storage = _MockSecureStorage();
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
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenAnswer(
      (_) async => const AuthResult.authenticated(tokens: _tokens, profile: {}),
    );
  });

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
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

  /// Bounded frames instead of `pumpAndSettle` from the OTP screen onward.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> reachOtp(WidgetTester tester) async {
    await tester.tap(find.text('Log In'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '01021871999');
    await tester.tap(find.widgetWithText(FilledButton, 'Send OTP'));
    await pumpFrames(tester);
    expect(find.byType(OtpScreen), findsOneWidget);
  }

  String location(ProviderContainer c) =>
      c.read(routerProvider).state.uri.toString();

  testWidgets('a correct code shows the success view — no jump to /home', (
    tester,
  ) async {
    final container = await pumpApp(tester);
    await reachOtp(tester);

    await tester.enterText(find.byType(Pinput), '000000');
    await pumpFrames(tester);

    // The bug: the student was already on Home here.
    expect(find.text('Successful'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);
    expect(location(container), '/login/otp');
  });

  testWidgets('the back chip still pops OTP back to Login', (tester) async {
    final container = await pumpApp(tester);
    await reachOtp(tester);

    await tester.tap(find.byType(CircleBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(OtpScreen), findsNothing);
    expect(location(container), '/login');
  });
}
