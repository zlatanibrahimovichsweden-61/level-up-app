import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/auth_interceptor.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/recovery/recovery_errors.dart';
import 'package:level_up_app/features/recovery/repository/recovery_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../dev/fake_api.dart';

class _MockStorage extends Mock implements SecureStorage {}

/// The recovery arms through the REAL `AuthInterceptor` + `ErrorInterceptor`
/// chain (CW06): their `401` is `registration_token_invalid` - a recovery id or
/// rebind token that expired - and it must reach the caller untouched.
///
/// The interceptor refreshes on `authentication_required` and signs out on
/// `session_superseded`; any other `401` is passed on. If recovery's `401`
/// triggered either, a student restarting recovery would be refreshed or
/// signed out by a token problem that has nothing to do with a session. This
/// pins that, with a session token present (the case that could go wrong).
void main() {
  late _MockStorage storage;
  late ProviderContainer container;
  late AuthController controller;
  var refreshCalls = 0;

  setUp(() async {
    refreshCalls = 0;
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.readRefreshToken()).thenAnswer((_) async => 'refresh');
    when(
      () => storage.readOrCreateDeviceId(),
    ).thenAnswer((_) async => 'dev-id');
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((_) async {});
    when(() => storage.clearTokens()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    controller = container.read(authControllerProvider.notifier);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  RecoveryRepository repoFor(FakeApiAdapter adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.local/api/v1'));
    dio.interceptors.addAll([
      AuthInterceptor(
        storage: storage,
        authController: controller,
        refresh: ({required refreshToken, required deviceId}) async {
          refreshCalls++;
          return const TokenPair(
            accessToken: 'new.access',
            accessExpiresInSeconds: 900,
            refreshToken: 'new.refresh',
            refreshExpiresInSeconds: 5184000,
          );
        },
        retryDio: dio,
      ),
      ErrorInterceptor(),
    ]);
    dio.httpClientAdapter = adapter;
    return RecoveryRepository(dio);
  }

  test('401 registration_token_invalid reaches the caller typed: no refresh, '
      'no retry, no sign-out', () async {
    final adapter = FakeApiAdapter(
      (_) => problemBody(401, 'registration_token_invalid'),
    );

    Object? thrown;
    try {
      await repoFor(adapter).verifyParentOtp(
        recoveryId: '7ec0e000-0000-4000-8000-000000000001',
        code: '482913',
      );
    } on Object catch (e) {
      thrown = e;
    }

    expect(thrown, isA<UnauthorizedException>());
    expect(isRegistrationTokenInvalid(thrown), isTrue);
    expect(classifyRecoveryFailure(thrown), RecoveryFailure.restartRequired);
    expect(refreshCalls, 0);
    expect(
      adapter.requests,
      hasLength(1),
      reason: 'the request is not retried',
    );
    verifyNever(() => storage.clearTokens());
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  test('the same on the other two arms that can answer it', () async {
    for (final run in <Future<Object?> Function(RecoveryRepository)>[
      (r) => r.submitNewPhone(rebindToken: 'x', newPhone: '+2010000000002'),
      (r) =>
          r.confirmRecovery(rebindToken: 'x', code: '482913', device: _device),
    ]) {
      final adapter = FakeApiAdapter(
        (_) => problemBody(401, 'registration_token_invalid'),
      );
      await expectLater(
        run(repoFor(adapter)),
        throwsA(predicate<Object?>(isRegistrationTokenInvalid)),
      );
      expect(adapter.requests, hasLength(1));
    }
    expect(refreshCalls, 0);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  test('429 otp_throttled and 403 account_banned pass through too (they are '
      'not 401s)', () async {
    for (final (status, code) in const [
      (429, 'otp_throttled'),
      (403, 'account_banned'),
    ]) {
      final adapter = FakeApiAdapter((_) => problemBody(status, code));
      await expectLater(
        repoFor(adapter).startRecovery('+2010000000001'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.status, 'status', status)
              .having((e) => e.code, 'code', code),
        ),
      );
    }
    expect(refreshCalls, 0);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });
}

const _device = DeviceInfo(deviceId: 'dev-id', platform: 'android');
