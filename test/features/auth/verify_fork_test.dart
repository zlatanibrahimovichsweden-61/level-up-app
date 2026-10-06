import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/auth_outcome.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_args.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/notifier/otp_notifier.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:level_up_app/features/auth/repository/device_info_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorage extends Mock implements SecureStorage {}

// resendAfterSeconds: 0 → no countdown timer starts (keeps the unit test clean).
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

ProviderContainer _container(
  MockAuthRepository repo,
  MockSecureStorage storage,
) {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      secureStorageProvider.overrideWithValue(storage),
      deviceInfoProvider.overrideWith((ref) async => _device),
    ],
  );
  // Keep the autoDispose family notifier alive for the duration of the test.
  container.listen(otpProvider(_args), (_, _) {});
  addTearDown(container.dispose);
  return container;
}

void main() {
  setUpAll(() => registerFallbackValue(_device));

  late MockAuthRepository repo;
  late MockSecureStorage storage;

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

  test('authenticated → tokens stored, then AuthenticatedOutcome', () async {
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenAnswer(
      (_) async => const AuthResult.authenticated(tokens: _tokens, profile: {}),
    );

    final container = _container(repo, storage);
    await container.read(otpProvider(_args).notifier).verify('482913');

    final state = container.read(otpProvider(_args));
    expect(state.outcome, isA<AuthenticatedOutcome>());
    expect(state.isVerifying, isFalse);
    verify(
      () => storage.writeTokens(access: 'access.jwt', refresh: 'refresh.jwt'),
    ).called(1);
  });

  test('popped mid-verify → the tokens are still written and auth still '
      'flips (R-2 / W3-1)', () async {
    // The student presses Back while `verifyOtp` is in flight. `otpProvider`
    // is autoDispose, so the notifier dies with its screen and a `ref.read`
    // after that point throws `UnmountedRefException`. The server has already
    // consumed the code, so the tokens and the auth flip must land regardless;
    // only the UI state may be dropped.
    final inFlight = Completer<AuthResult>();
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenAnswer((_) => inFlight.future);

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        secureStorageProvider.overrideWithValue(storage),
        deviceInfoProvider.overrideWith((ref) async => _device),
      ],
    );
    addTearDown(container.dispose);
    // The router watches the auth controller for the session's lifetime.
    container.listen(authControllerProvider, (_, _) {});
    final screen = container.listen(otpProvider(_args), (_, _) {});

    final verifying = container
        .read(otpProvider(_args).notifier)
        .verify('482913');
    // Past the device-info await and into the request.
    await Future<void>.delayed(Duration.zero);
    expect(inFlight.isCompleted, isFalse);
    screen.close(); // Back
    await container.pump(); // autoDispose takes the notifier
    inFlight.complete(
      const AuthResult.authenticated(tokens: _tokens, profile: {}),
    );
    await verifying;

    verify(
      () => storage.writeTokens(access: 'access.jwt', refresh: 'refresh.jwt'),
    ).called(1);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  test('registrationRequired → carries token, does NOT store tokens', () async {
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

    final container = _container(repo, storage);
    await container.read(otpProvider(_args).notifier).verify('482913');

    final state = container.read(otpProvider(_args));
    expect(state.outcome, isA<RegistrationRequiredOutcome>());
    expect(
      (state.outcome as RegistrationRequiredOutcome).registrationToken,
      'reg.token',
    );
    verifyNever(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    );
  });

  test('otp_invalid → inline error + red-box flag, no outcome', () async {
    when(
      () => repo.verifyOtp(
        phone: any(named: 'phone'),
        code: any(named: 'code'),
        device: any(named: 'device'),
      ),
    ).thenThrow(const ApiException(status: 400, code: 'otp_invalid'));

    final container = _container(repo, storage);
    await container.read(otpProvider(_args).notifier).verify('000000');

    final state = container.read(otpProvider(_args));
    expect(state.outcome, isNull);
    expect(state.isInvalidCode, isTrue);
    expect(state.error, isA<ApiException>());
  });

  test(
    'offline (NetworkException) surfaces as an offline-classified error',
    () async {
      when(
        () => repo.verifyOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
          device: any(named: 'device'),
        ),
      ).thenThrow(const NetworkException());

      final container = _container(repo, storage);
      await container.read(otpProvider(_args).notifier).verify('482913');

      final state = container.read(otpProvider(_args));
      expect(state.outcome, isNull);
      expect(state.error, isA<NetworkException>());
    },
  );
}
