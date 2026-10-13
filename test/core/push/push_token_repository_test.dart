import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/push/push_token_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

/// `PUT /me/fcm-token` (`registerFcmToken`): the request the app builds, and the
/// typed errors it hands back.
///
/// The contract's one required body property is `token`; nothing else may ride
/// along. The answer is `204` with no body.
void main() {
  late _MockDio dio;
  late PushTokenRepository repo;

  const token = 'fake-token-for-tests';

  setUp(() {
    dio = _MockDio();
    repo = PushTokenRepository(dio);
  });

  Response<void> noContent() => Response<void>(
    requestOptions: RequestOptions(path: '/me/fcm-token'),
    statusCode: 204,
  );

  DioException failure(AppException mapped) => DioException(
    requestOptions: RequestOptions(path: '/me/fcm-token'),
    error: mapped,
  );

  void stubPut() {
    when(
      () => dio.put<void>('/me/fcm-token', data: any(named: 'data')),
    ).thenAnswer((_) async => noContent());
  }

  void stubPutThrows(Object error) {
    when(
      () => dio.put<void>('/me/fcm-token', data: any(named: 'data')),
    ).thenThrow(error);
  }

  test('PUTs exactly {token} to /me/fcm-token', () async {
    stubPut();

    await repo.registerFcmToken(token);

    final body =
        verify(
              () => dio.put<void>(
                '/me/fcm-token',
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body, {'token': token});
    expect(body.keys, ['token']);
  });

  test('the token is sent as given: not trimmed, not truncated', () async {
    stubPut();
    final long = 'x' * 4096;

    await repo.registerFcmToken(' $long ');

    final body =
        verify(
              () => dio.put<void>(
                '/me/fcm-token',
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body['token'], ' $long ');
  });

  group('failures arrive as the typed exception the interceptor mapped', () {
    final cases = <String, AppException>{
      '400 validation_failed': const ValidationException(
        errors: {
          'token': ['Required.'],
        },
      ),
      '401 session_superseded': const UnauthorizedException(
        code: 'session_superseded',
      ),
      '403 account_pending_deletion': const ApiException(
        status: 403,
        code: 'account_pending_deletion',
      ),
      'offline': const OfflineException(),
      'timeout': const NetworkException(detail: 'timeout'),
    };

    for (final entry in cases.entries) {
      test(entry.key, () async {
        stubPutThrows(failure(entry.value));

        await expectLater(
          repo.registerFcmToken(token),
          throwsA(same(entry.value)),
        );
      });
    }

    test('account_pending_deletion is recognised, untouched', () async {
      stubPutThrows(
        failure(
          const ApiException(status: 403, code: 'account_pending_deletion'),
        ),
      );

      try {
        await repo.registerFcmToken(token);
        fail('should have thrown');
      } on Object catch (e) {
        expect(isAccountPendingDeletion(e), isTrue);
      }
    });

    test(
      'a DioException that bypassed the interceptor becomes UnknownException, '
      'and its text never reaches the detail',
      () async {
        stubPutThrows(
          DioException(
            requestOptions: RequestOptions(
              path: '/me/fcm-token',
              data: {'token': token},
            ),
          ),
        );

        try {
          await repo.registerFcmToken(token);
          fail('should have thrown');
        } on UnknownException catch (e) {
          expect(e.detail, isNull);
          expect(e.toString(), isNot(contains(token)));
        }
      },
    );
  });
}
