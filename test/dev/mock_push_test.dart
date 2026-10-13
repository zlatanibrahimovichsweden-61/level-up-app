import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/core/push/push_gateway.dart';
import 'package:level_up_app/core/push/push_lifecycle.dart';
import 'package:level_up_app/core/push/push_token_repository.dart';
import 'package:level_up_app/dev/mock_push.dart';

import '../core/push/fake_push_gateway.dart';

/// `PUT /me/fcm-token`, served by the on-device mock.
///
/// The desk is driven through the REAL [PushTokenRepository] and the REAL
/// `ErrorInterceptor`, by a Dio whose only other piece is a tiny interceptor
/// that does exactly what `mock_backend.dart`'s dispatch block does (map a
/// [MockPushReply] onto a response). So these prove both that the mock enforces
/// the contract's rules and that the request the app builds is the one the mock
/// understands.
void main() {
  const tokenA = 'fake-token-a';
  const tokenB = 'fake-token-b';

  late MockPushDesk desk;
  late PushTokenRepository repo;

  setUp(() {
    desk = MockPushDesk();
    repo = PushTokenRepository(_dioFor(desk));
  });

  group('a valid token', () {
    test('is stored and answered 204', () async {
      await repo.registerFcmToken(tokenA);

      expect(desk.registrations, 1);
      expect(desk.hasToken, isTrue);
      expect(desk.holds(tokenA), isTrue);
    });

    test('a repeat is 204 too: the call is idempotent', () async {
      await repo.registerFcmToken(tokenA);
      await repo.registerFcmToken(tokenA);

      expect(desk.registrations, 2);
      expect(desk.holds(tokenA), isTrue);
    });

    test('one token per session, the latest wins', () async {
      await repo.registerFcmToken(tokenA);
      await repo.registerFcmToken(tokenB);

      expect(desk.holds(tokenB), isTrue);
      expect(desk.holds(tokenA), isFalse);
    });

    test('4096 characters is the longest accepted', () async {
      await repo.registerFcmToken('x' * 4096);

      expect(desk.registrations, 1);
    });

    test('the reply is 204 with no body', () {
      final reply = desk.handle('PUT', '/me/fcm-token', {'token': tokenA});

      expect(reply, isA<MockPushOk>());
      final ok = reply! as MockPushOk;
      expect(ok.status, 204);
      expect(ok.data, isNull);
    });
  });

  group('400 validation_failed on field token', () {
    Future<void> expectRefused(Future<void> call) async {
      try {
        await call;
        fail('should have been refused');
      } on ValidationException catch (e) {
        expect(e.fields, ['token']);
      }
    }

    test('an empty token', () async {
      await expectRefused(repo.registerFcmToken(''));
    });

    test('a whitespace-only token', () async {
      await expectRefused(repo.registerFcmToken('   \t '));
    });

    test('a token longer than 4096 characters', () async {
      await expectRefused(repo.registerFcmToken('x' * 4097));
    });

    test('an absent token', () {
      final reply = desk.handle('PUT', '/me/fcm-token', <String, dynamic>{});

      expect(reply, isA<MockPushValidation>());
      expect((reply! as MockPushValidation).errors.keys, ['token']);
    });

    test('a token that is not a string', () {
      for (final bad in <Object?>[
        123,
        true,
        null,
        <String>['a'],
      ]) {
        final reply = desk.handle('PUT', '/me/fcm-token', {'token': bad});

        expect(reply, isA<MockPushValidation>(), reason: 'token: $bad');
      }
    });

    test('a refusal stores nothing and keeps the previous token', () async {
      await repo.registerFcmToken(tokenA);

      await expectRefused(repo.registerFcmToken(''));

      expect(desk.registrations, 1);
      expect(desk.holds(tokenA), isTrue);
    });
  });

  group('only that one route is served', () {
    test('other methods on the path fall through', () {
      for (final method in ['GET', 'POST', 'DELETE', 'PATCH']) {
        expect(
          desk.handle(method, '/me/fcm-token', {'token': tokenA}),
          isNull,
          reason: method,
        );
      }
    });

    test('other paths fall through', () {
      expect(desk.handle('PUT', '/me/fcm-tokens', {'token': tokenA}), isNull);
      expect(desk.handle('PUT', '/me', {'token': tokenA}), isNull);
    });

    test('an unserved route is a 404 through the harness', () async {
      final dio = _dioFor(desk);

      try {
        await dio.get<Object?>('/me/fcm-token');
        fail('should have been rejected');
      } on DioException catch (e) {
        expect((e.error! as ApiException).status, 404);
        expect(desk.registrations, 0);
      }
    });
  });

  group('the lifecycle against the mock', () {
    test('a gateway with a token registers it once per sign-in', () async {
      final gateway = FakePushGateway(token: tokenA);
      final lifecycle = PushRegistrationLifecycle(
        gateway: gateway,
        repository: repo,
      );
      addTearDown(() async {
        await lifecycle.dispose();
        await gateway.close();
      });

      expect(await lifecycle.onSignedIn(), PushRegistrationOutcome.registered);
      expect(await lifecycle.onSignedIn(), PushRegistrationOutcome.notNeeded);

      expect(desk.registrations, 1);
      expect(desk.holds(tokenA), isTrue);
    });

    test('a rotation replaces the token on the mock', () async {
      final gateway = FakePushGateway(token: tokenA);
      final lifecycle = PushRegistrationLifecycle(
        gateway: gateway,
        repository: repo,
      );
      addTearDown(() async {
        await lifecycle.dispose();
        await gateway.close();
      });
      await lifecycle.onSignedIn();

      gateway.rotate(tokenB);
      await pumpEventQueue();

      expect(desk.registrations, 2);
      expect(desk.holds(tokenB), isTrue);
    });

    test('the Noop gateway never reaches the mock', () async {
      final lifecycle = PushRegistrationLifecycle(
        gateway: const NoopPushGateway(),
        repository: repo,
      );

      expect(await lifecycle.onSignedIn(), PushRegistrationOutcome.noToken);

      expect(desk.registrations, 0);
      expect(desk.hasToken, isFalse);
      await lifecycle.dispose();
    });
  });
}

/// A Dio whose only behaviour is the mock: the same mapping
/// `mock_backend.dart` performs, then the real ErrorInterceptor.
Dio _dioFor(MockPushDesk desk) {
  final dio = Dio(BaseOptions(baseUrl: 'http://mock.local/api/v1'));
  dio.interceptors.addAll([_DeskInterceptor(desk), ErrorInterceptor()]);
  return dio;
}

class _DeskInterceptor extends Interceptor {
  _DeskInterceptor(this.desk);

  final MockPushDesk desk;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final body = options.data is Map
        ? Map<String, dynamic>.from(options.data as Map)
        : const <String, dynamic>{};
    final reply = desk.handle(options.method.toUpperCase(), options.path, body);
    switch (reply) {
      case MockPushOk(:final status, :final data):
        handler.resolve(
          Response<dynamic>(
            requestOptions: options,
            statusCode: status,
            data: data,
          ),
        );
      case MockPushValidation(:final errors):
        _reject(handler, options, 400, <String, dynamic>{
          'status': 400,
          'code': 'validation_failed',
          'errors': errors,
        });
      case null:
        _reject(handler, options, 404, <String, dynamic>{
          'status': 404,
          'code': 'not_found',
        });
    }
  }

  void _reject(
    RequestInterceptorHandler handler,
    RequestOptions options,
    int status,
    Map<String, dynamic> problem,
  ) {
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: status,
          data: problem,
        ),
      ),
      true,
    );
  }
}
