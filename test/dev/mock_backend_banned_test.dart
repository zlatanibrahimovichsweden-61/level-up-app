import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/dev/mock_backend.dart';

/// CW02 slice B: the mock's banned magic code. The harness is the only place
/// the banned OTP state can be walked on a device (no staging account is
/// seeded), so it must answer the way the contract does — `403 account_banned`
/// through the REAL ErrorInterceptor — and must leave the older magic codes
/// exactly as they were.

const _phone = '+2010000000001';

Future<Response<Map<String, dynamic>>> _verify(Dio dio, String code) =>
    dio.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      data: <String, dynamic>{'phone': _phone, 'code': code},
    );

/// The mapped `AppException` behind a rejected mock call.
Future<AppException> _failure(Future<void> Function() call) async {
  try {
    await call();
    fail('expected the mock to reject this request');
  } on DioException catch (e) {
    return e.error! as AppException;
  }
}

void main() {
  test(
    '222222 → 403 account_banned, typed by the real ErrorInterceptor',
    () async {
      final dio = buildMockDio(latency: Duration.zero);

      final e = await _failure(() => _verify(dio, '222222'));

      expect(e, isA<ApiException>());
      expect((e as ApiException).status, 403);
      expect(e.code, 'account_banned');
      expect(isAccountBanned(e), isTrue);
    },
  );

  test('999999 is still 400 otp_invalid', () async {
    final dio = buildMockDio(latency: Duration.zero);

    final e = await _failure(() => _verify(dio, '999999'));

    expect(e, isA<ApiException>());
    expect((e as ApiException).status, 400);
    expect(e.code, 'otp_invalid');
    expect(isAccountBanned(e), isFalse);
  });

  test('000000 and 111111 still sign in; any other code still forks to '
      'registration', () async {
    final dio = buildMockDio(latency: Duration.zero);

    final school = await _verify(dio, '000000');
    expect(school.statusCode, 200);
    expect(school.data!['result'], 'authenticated');
    expect(school.data!['tokens'], isNotNull);

    final university = await _verify(dio, '111111');
    expect(university.data!['result'], 'authenticated');

    final fork = await _verify(dio, '123456');
    expect(fork.data!['result'], 'registrationRequired');
    expect(fork.data!.containsKey('tokens'), isFalse);
  });
}
