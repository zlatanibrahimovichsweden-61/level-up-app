import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';
import 'package:level_up_app/dev/mock_recovery.dart';
import 'package:level_up_app/features/auth/models/device_info.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/recovery/models/recovery_models.dart';
import 'package:level_up_app/features/recovery/recovery_errors.dart';
import 'package:level_up_app/features/recovery/repository/recovery_repository.dart';

/// The mock's lost-phone recovery ladder (CW06): `mock_recovery.dart`, the
/// module that `mock_backend.dart` dispatches to. Its state and the contract's
/// rules are tested here directly; the end-to-end group at the bottom drives the
/// same module THROUGH `buildMockDio` and the real repository, so it fails if
/// the dispatch hook is ever dropped from `mock_backend.dart`.
void main() {
  const phone = '+2010000000001';
  const newPhone = '+2010000000002';
  const device = {'deviceId': 'dev-id', 'platform': 'android'};

  late MockRecoveryLadder mock;

  setUp(() => mock = MockRecoveryLadder());

  MockRecoveryReply? start(String? p) =>
      mock.handle('POST', '/auth/recovery/start', {'phone': ?p});

  MockRecoveryReply? verifyParent(Object? id, Object? code) => mock.handle(
    'POST',
    '/auth/recovery/verify-parent',
    {'recoveryId': ?id, 'code': ?code},
  );

  MockRecoveryReply? submitNewPhone(Object? token, Object? p) => mock.handle(
    'POST',
    '/auth/recovery/new-phone',
    {'rebindToken': ?token, 'newPhone': ?p},
  );

  MockRecoveryReply? confirm(
    Object? token,
    Object? code, [
    Object? dev = device,
  ]) => mock.handle('POST', '/auth/recovery/confirm', {
    'rebindToken': ?token,
    'code': ?code,
    'device': ?dev,
  });

  MockRecoveryOk ok(MockRecoveryReply? reply, int status) {
    expect(reply, isA<MockRecoveryOk>(), reason: '$reply');
    final r = reply! as MockRecoveryOk;
    expect(r.status, status);
    return r;
  }

  MockRecoveryProblem problem(
    MockRecoveryReply? reply,
    int status,
    String code,
  ) {
    expect(reply, isA<MockRecoveryProblem>(), reason: '$reply');
    final r = reply! as MockRecoveryProblem;
    expect(r.status, status);
    expect(r.code, code);
    return r;
  }

  /// Steps 1 and 2 done: the rebind token.
  String rebind() {
    final s = RecoveryStartResult.fromJson(ok(start(phone), 200).data);
    return ParentVerifiedResult.fromJson(
      ok(verifyParent(s.recoveryId, '482913'), 200).data,
    ).rebindToken;
  }

  group('step 1 - startRecovery', () {
    test('200, and the body parses into the REAL model', () {
      final r = RecoveryStartResult.fromJson(ok(start(phone), 200).data);
      expect(r.recoveryId, matches(RegExp(r'^[0-9a-f-]{36}$')));
      expect(r.parentPhoneMasked, kMockParentPhoneMasked);
      expect(r.resendAfterSeconds, 60);
      expect(r.expiresInSeconds, 300);
    });

    test('the masked number is masked: it ends in four digits and shows no '
        'full number', () {
      expect(kMockParentPhoneMasked, startsWith('•'));
      expect(kMockParentPhoneMasked, isNot(contains(phone)));
      expect(kMockParentPhoneMasked.replaceAll(RegExp(r'[• ]'), '').length, 4);
    });

    test('every start issues a new recovery id', () {
      final a = RecoveryStartResult.fromJson(ok(start(phone), 200).data);
      final b = RecoveryStartResult.fromJson(ok(start(phone), 200).data);
      expect(a.recoveryId, isNot(b.recoveryId));
    });

    test('the unknown phone is 404 recovery_unavailable', () {
      problem(start(kMockRecoveryUnknownPhone), 404, 'recovery_unavailable');
    });

    test('the throttled phone is 429 otp_throttled', () {
      problem(start(kMockRecoveryThrottledPhone), 429, 'otp_throttled');
    });

    test('a phone that is not E.164 (or is absent) is 400 validation_failed '
        'on phone', () {
      // Mock-only: startRecovery documents no 400, so this is the registry's
      // generic code, kept so a malformed request is not read as "unknown".
      for (final bad in ['01000000000', '+0123', 'abc', '', null, 12]) {
        final reply = mock.handle('POST', '/auth/recovery/start', {
          'phone': ?bad,
        });
        expect(reply, isA<MockRecoveryValidation>(), reason: '$bad');
        expect((reply! as MockRecoveryValidation).errors.keys, ['phone']);
      }
    });
  });

  group('step 2 - verifyParentOtp', () {
    late String recoveryId;

    setUp(() {
      recoveryId = RecoveryStartResult.fromJson(
        ok(start(phone), 200).data,
      ).recoveryId;
    });

    test('a correct code is 200 with a rebind token, parsed by the REAL '
        'model', () {
      final r = ParentVerifiedResult.fromJson(
        ok(verifyParent(recoveryId, '482913'), 200).data,
      );
      expect(r.rebindToken, isNotEmpty);
      expect(r.expiresInSeconds, 600);
    });

    test('the magic codes are the documented errors', () {
      problem(
        verifyParent(recoveryId, kMockRecoveryInvalidCode),
        400,
        'otp_invalid',
      );
      problem(
        verifyParent(recoveryId, kMockRecoveryExpiredCode),
        400,
        'otp_expired',
      );
      problem(
        verifyParent(recoveryId, kMockRecoveryThrottledCode),
        429,
        'otp_throttled',
      );
      problem(
        verifyParent(recoveryId, kMockRecoveryBannedCode),
        403,
        'account_banned',
      );
    });

    test('a wrong code does not spend the recovery id: the right one still '
        'works afterwards', () {
      problem(
        verifyParent(recoveryId, kMockRecoveryInvalidCode),
        400,
        'otp_invalid',
      );
      ok(verifyParent(recoveryId, '482913'), 200);
    });

    test('the recovery id is spent by a correct code', () {
      ok(verifyParent(recoveryId, '482913'), 200);
      problem(
        verifyParent(recoveryId, '482913'),
        401,
        'registration_token_invalid',
      );
    });

    test('an id this mock did not issue is 401 registration_token_invalid', () {
      problem(
        verifyParent('7ec0e000-0000-4000-8000-0000000fffff', '482913'),
        401,
        'registration_token_invalid',
      );
      problem(verifyParent(null, '482913'), 401, 'registration_token_invalid');
    });

    test(
      'a code that is not 6 characters is 400 validation_failed on code',
      () {
        // Mock-only: verifyParentOtp documents otp_invalid / otp_expired as its
        // 400s, so this is the registry's generic code for the schema's rule.
        for (final bad in ['12345', '1234567', '', null, 482913]) {
          final reply = verifyParent(recoveryId, bad);
          expect(reply, isA<MockRecoveryValidation>(), reason: '$bad');
          expect((reply! as MockRecoveryValidation).errors.keys, ['code']);
        }
      },
    );
  });

  group('step 3 - submitNewPhone', () {
    late String token;

    setUp(() => token = rebind());

    test(
      '202 with the code timing, parsed by the existing OtpRequestResult',
      () {
        final r = OtpRequestResult.fromJson(
          ok(submitNewPhone(token, newPhone), 202).data,
        );
        expect(r.resendAfterSeconds, 60);
        expect(r.expiresInSeconds, 300);
      },
    );

    test('a number that belongs to another account is 409 '
        'phone_already_registered, and the token survives it', () {
      problem(
        submitNewPhone(token, kMockRecoveryTakenPhone),
        409,
        'phone_already_registered',
      );
      ok(submitNewPhone(token, newPhone), 202);
    });

    test('the throttled phone is 429 otp_throttled here too (step 3 documents '
        'the 429), and the token survives it', () {
      problem(
        submitNewPhone(token, kMockRecoveryThrottledPhone),
        429,
        'otp_throttled',
      );
      ok(submitNewPhone(token, newPhone), 202);
    });

    test('a malformed number is 400 validation_failed on newPhone', () {
      for (final bad in ['0100', 'nope', '', null]) {
        final reply = submitNewPhone(token, bad);
        expect(reply, isA<MockRecoveryValidation>(), reason: '$bad');
        expect((reply! as MockRecoveryValidation).errors.keys, ['newPhone']);
      }
    });

    test('a rebind token this mock did not issue is 401 '
        'registration_token_invalid', () {
      problem(
        submitNewPhone('mock.rebind.token.999', newPhone),
        401,
        'registration_token_invalid',
      );
      problem(
        submitNewPhone(null, newPhone),
        401,
        'registration_token_invalid',
      );
    });

    test('a recovery id is not a rebind token', () {
      final id = RecoveryStartResult.fromJson(
        ok(start(phone), 200).data,
      ).recoveryId;
      problem(submitNewPhone(id, newPhone), 401, 'registration_token_invalid');
    });
  });

  group('step 4 - confirmRecovery', () {
    late String token;

    setUp(() {
      token = rebind();
      ok(submitNewPhone(token, newPhone), 202);
    });

    test('a correct code authenticates the student on the NEW phone', () {
      final reply = confirm(token, '482913');
      expect(reply, isA<MockRecoveryAuthenticated>());
      expect((reply! as MockRecoveryAuthenticated).phone, newPhone);
    });

    test('the rebind token is spent: a replay is 401 '
        'registration_token_invalid', () {
      expect(confirm(token, '482913'), isA<MockRecoveryAuthenticated>());
      problem(confirm(token, '482913'), 401, 'registration_token_invalid');
      problem(
        submitNewPhone(token, newPhone),
        401,
        'registration_token_invalid',
      );
    });

    test('the magic codes are the documented errors, and none spends the '
        'token', () {
      problem(confirm(token, kMockRecoveryInvalidCode), 400, 'otp_invalid');
      problem(confirm(token, kMockRecoveryExpiredCode), 400, 'otp_expired');
      problem(confirm(token, kMockRecoveryThrottledCode), 429, 'otp_throttled');
      problem(confirm(token, kMockRecoveryBannedCode), 403, 'account_banned');
      expect(confirm(token, '482913'), isA<MockRecoveryAuthenticated>());
    });

    test('a missing or malformed device, or a short code, is 400 '
        'validation_failed', () {
      for (final (dev, code, field) in <(Object?, Object?, String)>[
        (null, '482913', 'device'),
        ({'deviceId': 'x'}, '482913', 'device'),
        ({'platform': 'ios'}, '482913', 'device'),
        ('dev-id', '482913', 'device'),
        (device, '12', 'code'),
        (device, null, 'code'),
      ]) {
        final reply = confirm(token, code, dev);
        expect(reply, isA<MockRecoveryValidation>(), reason: '$dev/$code');
        expect((reply! as MockRecoveryValidation).errors.keys, contains(field));
      }
    });

    test(
      'a token this mock did not issue is 401 registration_token_invalid',
      () {
        problem(
          confirm('mock.rebind.token.999', '482913'),
          401,
          'registration_token_invalid',
        );
      },
    );
  });

  group('routing', () {
    test('only POST, only the four recovery paths', () {
      expect(mock.handle('GET', '/auth/recovery/start', const {}), isNull);
      expect(mock.handle('POST', '/auth/otp/request', const {}), isNull);
      expect(mock.handle('POST', '/auth/recovery', const {}), isNull);
      expect(mock.handle('POST', '/auth/recovery/start/x', const {}), isNull);
      expect(mock.handle('PUT', '/auth/recovery/confirm', const {}), isNull);
    });
  });

  test('the mock encodes no lock: the same wrong code can be sent over and '
      'over and is answered the same way every time', () {
    final id = RecoveryStartResult.fromJson(
      ok(start(phone), 200).data,
    ).recoveryId;
    for (var i = 0; i < 12; i++) {
      problem(verifyParent(id, kMockRecoveryInvalidCode), 400, 'otp_invalid');
    }
    ok(verifyParent(id, '482913'), 200);
  });

  group('through buildMockDio and the real repository', () {
    RecoveryRepository repo() =>
        RecoveryRepository(buildMockDio(latency: Duration.zero));

    const dev = DeviceInfo(deviceId: 'dev-id', platform: 'android');

    test('the whole ladder, ending in an authenticated session', () async {
      final r = repo();

      final started = await r.startRecovery(phone);
      final verified = await r.verifyParentOtp(
        recoveryId: started.recoveryId,
        code: '482913',
      );
      final sent = await r.submitNewPhone(
        rebindToken: verified.rebindToken,
        newPhone: newPhone,
      );
      expect(sent.resendAfterSeconds, 60);

      final result = await r.confirmRecovery(
        rebindToken: verified.rebindToken,
        code: '482913',
        device: dev,
      );
      expect(result.tokens.accessToken, isNotEmpty);
      expect(result.profile['phone'], newPhone);
      expect(result.profile['id'], isNotNull);
    });

    test('each documented failure arrives typed, through the real '
        'ErrorInterceptor', () async {
      final r = repo();

      Future<Object?> failure(Future<Object?> Function() run) async {
        try {
          await run();
          return null;
        } on Object catch (e) {
          return e;
        }
      }

      expect(
        classifyRecoveryFailure(
          await failure(() => r.startRecovery(kMockRecoveryUnknownPhone)),
        ),
        RecoveryFailure.unavailable,
      );
      expect(
        classifyRecoveryFailure(
          await failure(() => r.startRecovery(kMockRecoveryThrottledPhone)),
        ),
        RecoveryFailure.throttled,
      );
      final started = await r.startRecovery(phone);
      expect(
        classifyRecoveryFailure(
          await failure(
            () => r.verifyParentOtp(
              recoveryId: started.recoveryId,
              code: kMockRecoveryBannedCode,
            ),
          ),
        ),
        RecoveryFailure.banned,
      );
      expect(
        classifyRecoveryFailure(
          await failure(
            () => r.verifyParentOtp(recoveryId: 'unknown', code: '482913'),
          ),
        ),
        RecoveryFailure.restartRequired,
      );
      final bad = await failure(
        () => r.submitNewPhone(rebindToken: 'x', newPhone: 'bad'),
      );
      expect(bad, isA<ValidationException>());
      expect(bad, isA<ApiException>());
      expect(bad, isNot(isA<DioException>()));
    });
  });
}
