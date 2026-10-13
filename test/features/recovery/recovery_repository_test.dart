import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/recovery/models/recovery_models.dart';
import 'package:level_up_app/features/recovery/recovery_errors.dart';
import 'package:level_up_app/features/recovery/repository/recovery_repository.dart';

import '../../dev/fake_api.dart';

/// The lost-phone recovery data layer (CW06): the four stable, anonymous
/// operations, driven through a real [Dio] with the REAL `ErrorInterceptor`, so
/// what is asserted is what goes out on the wire and what the app's typed
/// boundary makes of every documented answer.
///
/// Every value below is fabricated.
void main() {
  const phone = '+2010000000001';
  const newPhone = '+2010000000002';
  const recoveryId = '7ec0e000-0000-4000-8000-000000000001';
  const rebindToken = 'fabricated.rebind.token';
  const code = '482913';
  const device = DeviceInfo(
    deviceId: 'dev-id',
    platform: 'android',
    model: 'Pixel',
  );

  const startBody = <String, Object?>{
    'recoveryId': recoveryId,
    'parentPhoneMasked': '•••• ••• 1234',
    'resendAfterSeconds': 60,
    'expiresInSeconds': 300,
  };
  const authenticatedBody = <String, Object?>{
    'result': 'authenticated',
    'tokens': {
      'accessToken': 'access.jwt',
      'accessExpiresInSeconds': 900,
      'refreshToken': 'refresh.jwt',
      'refreshExpiresInSeconds': 5184000,
    },
    'profile': {'id': 'student-1', 'name': 'Fabricated Name'},
  };

  RecoveryRepository repoFor(FakeApiAdapter adapter) =>
      RecoveryRepository(buildFakeApiDio(adapter));

  group('the four requests, on the wire', () {
    test(
      'startRecovery: POST /auth/recovery/start with exactly {phone}',
      () async {
        final adapter = FakeApiAdapter((_) => jsonBody(200, startBody));

        final result = await repoFor(adapter).startRecovery(phone);

        expect(adapter.only.method, 'POST');
        expect(adapter.only.uri.path, '/api/v1/auth/recovery/start');
        expect(adapter.only.uri.hasQuery, isFalse);
        expect(adapter.only.data, <String, dynamic>{'phone': phone});
        expect(result, isA<RecoveryStartResult>());
        expect(result.recoveryId, recoveryId);
        expect(result.resendAfterSeconds, 60);
      },
    );

    test('verifyParentOtp: POST /auth/recovery/verify-parent with exactly '
        '{recoveryId, code}', () async {
      final adapter = FakeApiAdapter(
        (_) => jsonBody(200, {
          'rebindToken': rebindToken,
          'expiresInSeconds': 600,
        }),
      );

      final result = await repoFor(
        adapter,
      ).verifyParentOtp(recoveryId: recoveryId, code: code);

      expect(adapter.only.method, 'POST');
      expect(adapter.only.uri.path, '/api/v1/auth/recovery/verify-parent');
      expect(adapter.only.data, <String, dynamic>{
        'recoveryId': recoveryId,
        'code': code,
      });
      expect(result, isA<ParentVerifiedResult>());
      expect(result.rebindToken, rebindToken);
      expect(result.expiresInSeconds, 600);
    });

    test('submitNewPhone: POST /auth/recovery/new-phone with exactly '
        '{rebindToken, newPhone}, and the answer is the existing '
        'OtpRequestResult', () async {
      final adapter = FakeApiAdapter(
        (_) =>
            jsonBody(202, {'resendAfterSeconds': 45, 'expiresInSeconds': 300}),
      );

      final result = await repoFor(
        adapter,
      ).submitNewPhone(rebindToken: rebindToken, newPhone: newPhone);

      expect(adapter.only.method, 'POST');
      expect(adapter.only.uri.path, '/api/v1/auth/recovery/new-phone');
      expect(adapter.only.data, <String, dynamic>{
        'rebindToken': rebindToken,
        'newPhone': newPhone,
      });
      expect(result, isA<OtpRequestResult>());
      expect(result.resendAfterSeconds, 45);
      expect(result.expiresInSeconds, 300);
    });

    test(
      'confirmRecovery: POST /auth/recovery/confirm with {rebindToken, '
      'code, device}, and the answer is the existing AuthenticatedResult',
      () async {
        final adapter = FakeApiAdapter((_) => jsonBody(200, authenticatedBody));

        final result = await repoFor(
          adapter,
        ).confirmRecovery(rebindToken: rebindToken, code: code, device: device);

        expect(adapter.only.method, 'POST');
        expect(adapter.only.uri.path, '/api/v1/auth/recovery/confirm');
        expect(adapter.only.data, <String, dynamic>{
          'rebindToken': rebindToken,
          'code': code,
          'device': {
            'deviceId': 'dev-id',
            'platform': 'android',
            'model': 'Pixel',
          },
        });
        expect(result, isA<AuthenticatedResult>());
        expect(result.tokens.accessToken, 'access.jwt');
        expect(result.tokens.refreshToken, 'refresh.jwt');
        expect(result.profile['id'], 'student-1');
      },
    );

    test('a device with no model label is sent without a `model` key, not '
        'with null (the contract types model as a string)', () async {
      final adapter = FakeApiAdapter((_) => jsonBody(200, authenticatedBody));

      await repoFor(adapter).confirmRecovery(
        rebindToken: rebindToken,
        code: code,
        device: const DeviceInfo(deviceId: 'dev-id', platform: 'ios'),
      );

      expect((adapter.only.data as Map)['device'], <String, dynamic>{
        'deviceId': 'dev-id',
        'platform': 'ios',
      });
    });

    test('the whole ladder, in order, on one wire', () async {
      final adapter = FakeApiAdapter((options) {
        return switch (options.uri.path) {
          '/api/v1/auth/recovery/start' => jsonBody(200, startBody),
          '/api/v1/auth/recovery/verify-parent' => jsonBody(200, {
            'rebindToken': rebindToken,
            'expiresInSeconds': 600,
          }),
          '/api/v1/auth/recovery/new-phone' => jsonBody(202, {
            'resendAfterSeconds': 60,
            'expiresInSeconds': 300,
          }),
          '/api/v1/auth/recovery/confirm' => jsonBody(200, authenticatedBody),
          _ => problemBody(404, 'not_found'),
        };
      });
      final repo = repoFor(adapter);

      final started = await repo.startRecovery(phone);
      final verified = await repo.verifyParentOtp(
        recoveryId: started.recoveryId,
        code: code,
      );
      await repo.submitNewPhone(
        rebindToken: verified.rebindToken,
        newPhone: newPhone,
      );
      await repo.confirmRecovery(
        rebindToken: verified.rebindToken,
        code: code,
        device: device,
      );

      expect(adapter.requests.map((r) => r.uri.path), [
        '/api/v1/auth/recovery/start',
        '/api/v1/auth/recovery/verify-parent',
        '/api/v1/auth/recovery/new-phone',
        '/api/v1/auth/recovery/confirm',
      ]);
    });
  });

  group('every documented failure is passed on as the interceptor typed it, '
      'and means what the contract says', () {
    // operation -> [(answer, failure)] as documented in openapi.yaml:462-629.
    final steps = <String, Future<Object?> Function(RecoveryRepository)>{
      'startRecovery': (r) => r.startRecovery(phone),
      'verifyParentOtp': (r) =>
          r.verifyParentOtp(recoveryId: recoveryId, code: code),
      'submitNewPhone': (r) =>
          r.submitNewPhone(rebindToken: rebindToken, newPhone: newPhone),
      'confirmRecovery': (r) => r.confirmRecovery(
        rebindToken: rebindToken,
        code: code,
        device: device,
      ),
    };

    // (operation, status, code, expected failure)
    const documented = <(String, int, String, RecoveryFailure)>[
      (
        'startRecovery',
        404,
        'recovery_unavailable',
        RecoveryFailure.unavailable,
      ),
      ('startRecovery', 429, 'otp_throttled', RecoveryFailure.throttled),
      ('verifyParentOtp', 400, 'otp_invalid', RecoveryFailure.otpInvalid),
      ('verifyParentOtp', 400, 'otp_expired', RecoveryFailure.otpExpired),
      (
        'verifyParentOtp',
        401,
        'registration_token_invalid',
        RecoveryFailure.restartRequired,
      ),
      ('verifyParentOtp', 403, 'account_banned', RecoveryFailure.banned),
      ('verifyParentOtp', 429, 'otp_throttled', RecoveryFailure.throttled),
      ('submitNewPhone', 400, 'validation_failed', RecoveryFailure.validation),
      (
        'submitNewPhone',
        401,
        'registration_token_invalid',
        RecoveryFailure.restartRequired,
      ),
      (
        'submitNewPhone',
        409,
        'phone_already_registered',
        RecoveryFailure.phoneAlreadyRegistered,
      ),
      ('submitNewPhone', 429, 'otp_throttled', RecoveryFailure.throttled),
      ('confirmRecovery', 400, 'otp_invalid', RecoveryFailure.otpInvalid),
      ('confirmRecovery', 400, 'otp_expired', RecoveryFailure.otpExpired),
      ('confirmRecovery', 400, 'validation_failed', RecoveryFailure.validation),
      (
        'confirmRecovery',
        401,
        'registration_token_invalid',
        RecoveryFailure.restartRequired,
      ),
      ('confirmRecovery', 403, 'account_banned', RecoveryFailure.banned),
      ('confirmRecovery', 429, 'otp_throttled', RecoveryFailure.throttled),
    ];

    for (final (operation, status, errorCode, expected) in documented) {
      test('$operation: $status $errorCode -> ${expected.name}', () async {
        final adapter = FakeApiAdapter(
          (_) => problemBody(
            status,
            errorCode,
            errors: errorCode == 'validation_failed'
                ? {
                    'newPhone': ['bad'],
                  }
                : null,
          ),
        );

        Object? thrown;
        try {
          await steps[operation]!(repoFor(adapter));
        } on Object catch (e) {
          thrown = e;
        }

        expect(thrown, isA<ApiException>(), reason: 'typed, not raw Dio');
        expect((thrown! as ApiException).status, status);
        expect((thrown as ApiException).code, errorCode);
        expect(classifyRecoveryFailure(thrown), expected);
        expect(adapter.requests, hasLength(1), reason: 'no retry');
      });
    }

    test(
      'otp_throttled carries no duration even when the response sends '
      'Retry-After: it is an ApiException, not a RateLimitedException',
      () async {
        final adapter = FakeApiAdapter(
          (_) => problemBody(
            429,
            'otp_throttled',
            headers: {
              'retry-after': ['1800'],
            },
          ),
        );
        Object? thrown;
        try {
          await repoFor(adapter).startRecovery(phone);
        } on Object catch (e) {
          thrown = e;
        }
        expect(thrown, isA<ApiException>());
        expect(thrown, isNot(isA<RateLimitedException>()));
        expect(isOtpThrottled(thrown), isTrue);
      },
    );

    test('offline is a NetworkException on every step', () async {
      for (final run in steps.values) {
        final dio = buildFakeApiDio(
          FakeApiAdapter(
            (options) => throw DioException.connectionError(
              requestOptions: options,
              reason: 'offline',
            ),
          ),
        );
        await expectLater(
          run(RecoveryRepository(dio)),
          throwsA(isA<NetworkException>()),
        );
      }
    });

    test(
      'a failure the interceptor did not type is UnknownException',
      () async {
        for (final run in steps.values) {
          final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
            ..httpClientAdapter = FakeApiAdapter(
              (options) => throw DioException(requestOptions: options),
            );
          await expectLater(
            run(RecoveryRepository(dio)),
            throwsA(isA<UnknownException>()),
          );
        }
      },
    );
  });

  group('a body that breaks the contract is UnknownException with the runtime '
      'type only', () {
    test('startRecovery / verifyParentOtp / submitNewPhone', () async {
      Future<void> expectParseFailure(
        Object? body,
        Future<Object?> Function(RecoveryRepository) run, {
        int status = 200,
      }) => expectLater(
        run(repoFor(FakeApiAdapter((_) => jsonBody(status, body)))),
        throwsA(
          isA<UnknownException>().having(
            (e) => e.detail,
            'detail',
            allOf(
              startsWith('parse: '),
              isNot(contains(recoveryId)),
              isNot(contains(rebindToken)),
              isNot(contains('1234')),
            ),
          ),
        ),
      );

      await expectParseFailure(
        {...startBody}..remove('parentPhoneMasked'),
        (r) => r.startRecovery(phone),
      );
      await expectParseFailure({
        ...startBody,
        'resendAfterSeconds': 'soon',
      }, (r) => r.startRecovery(phone));
      await expectParseFailure({
        'rebindToken': rebindToken,
      }, (r) => r.verifyParentOtp(recoveryId: recoveryId, code: code));
      await expectParseFailure(
        {'resendAfterSeconds': 60, 'rebindToken': rebindToken},
        (r) => r.submitNewPhone(rebindToken: rebindToken, newPhone: newPhone),
        status: 202,
      );
    });

    test('confirmRecovery: a registrationRequired result is contract drift, '
        'not an authenticated one', () async {
      final adapter = FakeApiAdapter(
        (_) => jsonBody(200, {
          'result': 'registrationRequired',
          'registrationToken': 'fabricated.registration.token',
          'expiresInSeconds': 600,
        }),
      );
      await expectLater(
        repoFor(
          adapter,
        ).confirmRecovery(rebindToken: rebindToken, code: code, device: device),
        throwsA(
          isA<UnknownException>().having(
            (e) => e.detail,
            'detail',
            isNot(contains('fabricated')),
          ),
        ),
      );
    });

    test('confirmRecovery: tokens missing from the result', () async {
      final adapter = FakeApiAdapter(
        (_) => jsonBody(200, {'result': 'authenticated', 'profile': {}}),
      );
      await expectLater(
        repoFor(
          adapter,
        ).confirmRecovery(rebindToken: rebindToken, code: code, device: device),
        throwsA(isA<UnknownException>()),
      );
    });

    test('a 200 with no body at all', () async {
      final adapter = FakeApiAdapter((_) => emptyBody(200));
      await expectLater(
        repoFor(adapter).startRecovery(phone),
        throwsA(isA<UnknownException>()),
      );
    });
  });

  test('recoveryRepositoryProvider builds the repository over dioProvider', () {
    final adapter = FakeApiAdapter((_) => jsonBody(200, startBody));
    final container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(buildFakeApiDio(adapter))],
    );
    addTearDown(container.dispose);

    final repo = container.read(recoveryRepositoryProvider);

    expect(repo, isA<RecoveryRepository>());
    expect(repo.startRecovery(phone), completion(isA<RecoveryStartResult>()));
  });
}
