import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/auth_interceptor.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements SecureStorage {}

/// Drives the interceptor end-to-end via a real Dio whose adapter is faked —
/// no network, no new deps. The adapter decides the response per request.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.onFetch);
  final Future<ResponseBody> Function(RequestOptions options) onFetch;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) =>
      onFetch(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Map<String, dynamic> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

ResponseBody _unauthorized(String code) =>
    _json(401, {'code': code, 'title': 'dev-facing', 'status': 401});

const _newTokens = TokenPair(
  accessToken: 'new.access',
  accessExpiresInSeconds: 900,
  refreshToken: 'new.refresh',
  refreshExpiresInSeconds: 5184000,
);

void main() {
  late _MockStorage storage;
  late ProviderContainer container;
  late AuthController controller;

  setUp(() async {
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => 'access');
    when(() => storage.readRefreshToken()).thenAnswer((_) async => 'refresh');
    when(() => storage.readOrCreateDeviceId()).thenAnswer((_) async => 'dev-id');
    when(() => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        )).thenAnswer((_) async {});
    when(() => storage.clearTokens()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    controller = container.read(authControllerProvider.notifier);
    // Let build()'s async _resolveInitial settle to Authenticated (token present)
    // so a later forceLogout is a clean, observable transition.
    await Future<void>.delayed(Duration.zero);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  Dio buildDio({
    required TokenRefresher refresh,
    required Future<ResponseBody> Function(RequestOptions) adapter,
  }) {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.local'));
    dio.interceptors.addAll([
      AuthInterceptor(
        storage: storage,
        authController: controller,
        refresh: refresh,
        retryDio: dio,
      ),
      ErrorInterceptor(),
    ]);
    dio.httpClientAdapter = _FakeAdapter(adapter);
    return dio;
  }

  test('authentication_required → refresh once → original retried → success',
      () async {
    var refreshCalls = 0;
    final dio = buildDio(
      refresh: ({required refreshToken, required deviceId}) async {
        refreshCalls++;
        return _newTokens;
      },
      adapter: (options) async => options.extra['__retried'] == true
          ? _json(200, {'ok': true})
          : _unauthorized('authentication_required'),
    );

    final res = await dio.get<dynamic>('/protected');

    expect(res.statusCode, 200);
    expect(refreshCalls, 1);
    verify(() => storage.writeTokens(
          access: 'new.access',
          refresh: 'new.refresh',
        )).called(1);
    // Successful refresh must NOT log out.
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });

  test('session_superseded → forceLogout(superseded), cleared, no refresh', () async {
    var refreshCalls = 0;
    final dio = buildDio(
      refresh: ({required refreshToken, required deviceId}) async {
        refreshCalls++;
        return _newTokens;
      },
      adapter: (options) async => _unauthorized('session_superseded'),
    );

    await expectLater(dio.get<dynamic>('/protected'), throwsA(isA<DioException>()));

    expect(refreshCalls, 0);
    verify(() => storage.clearTokens()).called(1);
    verifyNever(() => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ));
    final status = container.read(authControllerProvider);
    expect(status, isA<AuthUnauthenticated>());
    expect((status as AuthUnauthenticated).reason,
        LogoutReason.supersededOtherDevice);
  });

  test('refresh → refresh_token_invalid → forceLogout(sessionExpired)', () async {
    final dio = buildDio(
      refresh: ({required refreshToken, required deviceId}) async =>
          throw const UnauthorizedException(code: 'refresh_token_invalid'),
      adapter: (options) async => _unauthorized('authentication_required'),
    );

    await expectLater(dio.get<dynamic>('/protected'), throwsA(isA<DioException>()));

    verify(() => storage.clearTokens()).called(1);
    final status = container.read(authControllerProvider) as AuthUnauthenticated;
    expect(status.reason, LogoutReason.sessionExpired);
  });

  test('concurrent 401s → refresh called exactly once, all retried', () async {
    var refreshCalls = 0;
    final dio = buildDio(
      refresh: ({required refreshToken, required deviceId}) async {
        refreshCalls++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return _newTokens;
      },
      adapter: (options) async => options.extra['__retried'] == true
          ? _json(200, {'ok': true})
          : _unauthorized('authentication_required'),
    );

    final results = await Future.wait([
      dio.get<dynamic>('/a'),
      dio.get<dynamic>('/b'),
      dio.get<dynamic>('/c'),
    ]);

    expect(results.map((r) => r.statusCode), everyElement(200));
    expect(refreshCalls, 1);
  });

  test('already-retried request 401s again → not refreshed/retried a 2nd time',
      () async {
    var refreshCalls = 0;
    final dio = buildDio(
      refresh: ({required refreshToken, required deviceId}) async {
        refreshCalls++;
        return _newTokens;
      },
      // Always 401 — even the retried request.
      adapter: (options) async => _unauthorized('authentication_required'),
    );

    await expectLater(dio.get<dynamic>('/protected'), throwsA(isA<DioException>()));

    expect(refreshCalls, 1);
  });

  test('offline during refresh → NO logout, surfaces the network error', () async {
    final dio = buildDio(
      refresh: ({required refreshToken, required deviceId}) async =>
          throw const NetworkException(),
      adapter: (options) async => _unauthorized('authentication_required'),
    );

    await expectLater(
      dio.get<dynamic>('/protected'),
      throwsA(predicate((e) => e is DioException && e.error is NetworkException)),
    );

    verifyNever(() => storage.clearTokens());
    // Transient failure must NOT log out.
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
  });
}
