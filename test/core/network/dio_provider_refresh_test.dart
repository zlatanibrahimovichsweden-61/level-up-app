import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/config/app_config.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:level_up_app/features/auth/repository/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements SecureStorage {}

/// E4-01. The token refresh through the REAL `dioProvider`.
///
/// `dio_client_test.dart` and `auth_interceptor_test.dart` build the client by
/// hand and inject a fake refresher, so nothing in this suite ever drove the
/// refresh closure that `dioProvider` itself builds. That closure used to read
/// `authRepositoryProvider`, which watches `dioProvider` (a provider cycle):
/// release builds never noticed, but a DEBUG build (where every `flutter test`
/// runs) throws `CircularDependencyError` from `Ref.read`, `AuthInterceptor`
/// swallows it, and an expired access token could never be refreshed.
///
/// Everything below goes through the unmodified providers; only the storage and
/// the network are faked. No token, phone or body is printed or asserted on by
/// value other than the fabricated sentinels below.
const _staleAccess = 'STALE.ACCESS.TEST';
const _storedRefresh = 'STORED.REFRESH.TEST';
const _mintedAccess = 'MINTED.ACCESS.TEST';
const _mintedRefresh = 'MINTED.REFRESH.TEST';

ResponseBody _json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

ResponseBody _problem(int status, String code) => _json(status, {
  'type': 'about:blank',
  'title': 'dev-facing title',
  'status': status,
  'code': code,
});

/// A server in a few lines: `/auth/refresh` answers per [refreshAnswer],
/// everything else wants the minted access token and says 401
/// `authentication_required` to anything else.
class _Server implements HttpClientAdapter {
  final List<RequestOptions> calls = [];

  /// `null` = mint a new pair; otherwise the status + code to refuse with.
  ({int status, String code})? refreshRefusal;
  bool refreshOffline = false;

  int count(String path) => calls.where((o) => o.path == path).length;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options);
    if (options.path == '/auth/refresh') {
      if (refreshOffline) {
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'offline',
        );
      }
      final refusal = refreshRefusal;
      if (refusal != null) return _problem(refusal.status, refusal.code);
      return _json(200, <String, Object?>{
        'accessToken': _mintedAccess,
        'accessExpiresInSeconds': 900,
        'refreshToken': _mintedRefresh,
        'refreshExpiresInSeconds': 5184000,
      });
    }
    return options.headers['Authorization'] == 'Bearer $_mintedAccess'
        ? _json(200, <String, Object?>{'ok': true})
        : _problem(401, 'authentication_required');
  }

  @override
  void close({bool force = false}) {}
}

/// Gives every Dio the production providers build the fake server, the moment
/// it is built, and remembers which providers were created at all.
final class _Observer extends ProviderObserver {
  _Observer(this._server);
  final HttpClientAdapter _server;
  final List<Object> created = [];

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    created.add(context.provider);
    if (value is Dio) value.httpClientAdapter = _server;
  }

  bool wasCreated(Object provider) => created.contains(provider);
}

void main() {
  late _MockStorage storage;
  late _Server server;
  late _Observer observer;
  late ProviderContainer container;
  late String access;
  late String refresh;

  setUpAll(() => AppConfig.init(Flavor.staging));

  setUp(() async {
    access = _staleAccess;
    refresh = _storedRefresh;
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => access);
    when(() => storage.readRefreshToken()).thenAnswer((_) async => refresh);
    when(
      () => storage.readOrCreateDeviceId(),
    ).thenAnswer((_) async => 'device-id-test');
    when(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    ).thenAnswer((inv) async {
      access = inv.namedArguments[#access] as String;
      refresh = inv.namedArguments[#refresh] as String;
    });
    when(() => storage.clearTokens()).thenAnswer((_) async {
      access = '';
      refresh = '';
    });

    server = _Server();
    observer = _Observer(server);
    container = ProviderContainer(
      observers: [observer],
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    container.read(authControllerProvider); // build starts the token read
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  test('a debug build is what runs the suite (the cycle only bit there)', () {
    expect(kDebugMode, isTrue);
  });

  test('an expired access token is refreshed ONCE through the real '
      'dioProvider and the request replayed with the minted token', () async {
    final dio = container.read(dioProvider);

    final res = await dio.get<dynamic>('/me');

    expect(res.statusCode, 200);
    expect(server.count('/auth/refresh'), 1);
    expect(server.count('/me'), 2, reason: 'one attempt, one replay');
    final refreshCall = server.calls.singleWhere(
      (o) => o.path == '/auth/refresh',
    );
    expect(
      refreshCall.headers['Authorization'],
      isNull,
      reason:
          'the refresh went through the AuthInterceptor, not the bare client',
    );
    expect(refreshCall.data, {
      'refreshToken': _storedRefresh,
      'deviceId': 'device-id-test',
    });
    final replay = server.calls.where((o) => o.path == '/me').last;
    expect(replay.extra['__retried'], isTrue);
    expect(replay.headers['Authorization'], 'Bearer $_mintedAccess');
    expect(access, _mintedAccess);
    expect(refresh, _mintedRefresh);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  test('...and dioProvider never builds the auth repository to do it: the '
      'repository watches dioProvider, so reading it from there is the '
      'provider cycle', () async {
    final dio = container.read(dioProvider);

    await dio.get<dynamic>('/me');

    expect(observer.wasCreated(authRepositoryProvider), isFalse);
    expect(observer.wasCreated(refreshDioProvider), isTrue);
  });

  test('the same with the repository ALIVE as a child of dioProvider (an OTP '
      'request or a sign-out built it first)', () async {
    container.read(authRepositoryProvider);
    final dio = container.read(dioProvider);

    final res = await dio.get<dynamic>('/me');

    expect(res.statusCode, 200);
    expect(server.count('/auth/refresh'), 1);
  });

  test('three concurrent 401s share ONE refresh (single-flight)', () async {
    final dio = container.read(dioProvider);

    final results = await Future.wait([
      dio.get<dynamic>('/me'),
      dio.get<dynamic>('/me/entitlements'),
      dio.get<dynamic>('/catalog/subjects'),
    ]);

    expect(results.map((r) => r.statusCode), everyElement(200));
    expect(server.count('/auth/refresh'), 1);
  });

  test('a refresh the server REFUSES ends the session: one refresh, the '
      'request is not replayed, the tokens are cleared', () async {
    server.refreshRefusal = (status: 401, code: 'refresh_token_invalid');
    final dio = container.read(dioProvider);

    await expectLater(
      dio.get<dynamic>('/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.error,
          'error',
          isA<UnauthorizedException>(),
        ),
      ),
    );

    expect(server.count('/auth/refresh'), 1);
    expect(server.count('/me'), 1, reason: 'no replay after a dead refresh');
    final status = container.read(authControllerProvider);
    expect(status, isA<AuthUnauthenticated>());
    expect((status as AuthUnauthenticated).reason, LogoutReason.sessionExpired);
    verify(() => storage.clearTokens()).called(1);
  });

  test('a refresh that fails because the phone is OFFLINE is transient: no '
      'sign-out, the tokens stay', () async {
    server.refreshOffline = true;
    final dio = container.read(dioProvider);

    await expectLater(
      dio.get<dynamic>('/me'),
      throwsA(
        isA<DioException>().having(
          (e) => e.error,
          'error',
          isA<NetworkException>(),
        ),
      ),
    );

    expect(server.count('/auth/refresh'), 1);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
    verifyNever(() => storage.clearTokens());
    expect(refresh, _storedRefresh);
  });
}
