import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/core/widgets/language_pill.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/otp_notifier.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:level_up_app/features/auth/screens/otp_screen.dart';
import 'package:level_up_app/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinput/pinput.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

const _args = OtpArgs(
  phone: '+201021871999',
  resendAfterSeconds: 0,
  expiresInSeconds: 300,
);
const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
const _tokens = TokenPair(
  accessToken: 'access.jwt',
  accessExpiresInSeconds: 900,
  refreshToken: 'refresh.jwt',
  refreshExpiresInSeconds: 5184000,
);

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      locale: const Locale('en'),
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const OtpScreen(args: _args),
    ),
  );
}

void main() {
  setUpAll(() => registerFallbackValue(_device));

  late MockAuthRepository repo;
  late MockSecureStorage storage;

  ProviderContainer makeContainer({bool offline = false}) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
        if (offline)
          isOnlineProvider.overrideWith((ref) => Stream.value(false)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    repo = MockAuthRepository();
    storage = MockSecureStorage();
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
    // The authenticated path now flips AuthController, whose build() reads this.
    when(() => storage.readAccessToken()).thenAnswer((_) async => null);
  });

  testWidgets('renders 6 OTP boxes and, at 0 countdown, the Resend action', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(makeContainer()));

    // pinput renders a single Pinput; its length is the contract-mandated 6.
    final pinput = tester.widget<Pinput>(find.byType(Pinput));
    expect(pinput.length, 6);
    expect(find.widgetWithText(TextButton, 'Resend OTP'), findsOneWidget);
  });

  testWidgets('offline → distinct banner shown, Verify + Resend disabled', (
    tester,
  ) async {
    final container = makeContainer(offline: true);
    await tester.pumpWidget(_harness(container));
    await tester.pump(); // let the connectivity stream emit `false`

    expect(find.text('You are offline'), findsOneWidget);
    // Resend is enabled at 0 countdown when online — offline disables it.
    final resend = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Resend OTP'),
    );
    expect(resend.onPressed, isNull);
    final verify = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Verify'),
    );
    expect(verify.onPressed, isNull);
  });

  testWidgets('authenticated verify → success screen with Continue', (
    tester,
  ) async {
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenAnswer(
      (_) async => const AuthResult.authenticated(tokens: _tokens, profile: {}),
    );

    final container = makeContainer();
    await tester.pumpWidget(_harness(container));

    await container.read(otpProvider(_args).notifier).verify('482913');
    await tester.pump();

    expect(find.text('Successful'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Continue'), findsOneWidget);

    // Figma 82:1578 — the FULL sentence. The shipped copy was truncated to
    // "You have been authenticated" when this screen was built from a
    // screenshot, before the frame could be pulled.
    expect(
      find.text('Congratulations! You have been successfully authenticated'),
      findsOneWidget,
    );

    // The real badge (82:1598), not the Icons.check_circle placeholder that
    // used to be tinted with colorScheme.primary — i.e. purple in dark.
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);

    // No AppBar in the success branch: "back" to the OTP input is meaningless
    // once tokens are stored, and the frame (155:786) draws none.
    expect(find.byType(AppBar), findsNothing);
    // …but the frame's language pill (155:809) is present.
    expect(find.byType(LanguagePill), findsOneWidget);
  });
}
