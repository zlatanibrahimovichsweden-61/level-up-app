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
  ) => onFetch(options);

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

  test(
    'authentication_required → refresh once → original retried → success',
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
      verify(
        () => storage.writeTokens(access: 'new.access', refresh: 'new.refresh'),
      ).called(1);
      // Successful refresh must NOT log out.
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
    },
  );

  test(
    'session_superseded → forceLogout(superseded), cleared, no refresh',
    () async {
      var refreshCalls = 0;
      final dio = buildDio(
        refresh: ({required refreshToken, required deviceId}) async {
          refreshCalls++;
          return _newTokens;
        },
        adapter: (options) async => _unauthorized('session_superseded'),
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );

      expect(refreshCalls, 0);
      verify(() => storage.clearTokens()).called(1);
      verifyNever(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      );
      final status = container.read(authControllerProvider);
      expect(status, isA<AuthUnauthenticated>());
      expect(
        (status as AuthUnauthenticated).reason,
        LogoutReason.supersededOtherDevice,
      );
    },
  );

  test(
    'refresh → refresh_token_invalid → forceLogout(sessionExpired)',
    () async {
      final dio = buildDio(
        refresh: ({required refreshToken, required deviceId}) async =>
            throw const UnauthorizedException(code: 'refresh_token_invalid'),
        adapter: (options) async => _unauthorized('authentication_required'),
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );

      verify(() => storage.clearTokens()).called(1);
      final status =
          container.read(authControllerProvider) as AuthUnauthenticated;
      expect(status.reason, LogoutReason.sessionExpired);
    },
  );

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

  test(
    'already-retried request 401s again → not refreshed/retried a 2nd time',
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

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );

      expect(refreshCalls, 1);
    },
  );

  test(
    'offline during refresh → NO logout, surfaces the network error',
    () async {
      final dio = buildDio(
        refresh: ({required refreshToken, required deviceId}) async =>
            throw const NetworkException(),
        adapter: (options) async => _unauthorized('authentication_required'),
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(
          predicate((e) => e is DioException && e.error is NetworkException),
        ),
      );

      verifyNever(() => storage.clearTokens());
      // Transient failure must NOT log out.
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
    },
  );

  /// E4-01 follow-up. The refresh path used to end in `catch (_)`, which also
  /// swallowed Dart `Error`s (a programmer bug such as Riverpod's
  /// `CircularDependencyError`, which is what hid E4-01 in debug) and passed the
  /// plain 401 on as if nothing had gone wrong. A bug must stay visible; only a
  /// runtime `Exception` (a secure-storage fault) is the original 401's business.
  group('a failure inside the refresh that is not an AppException', () {
    test(
      'a programmer Error is NOT swallowed into the original 401: the '
      'caller gets the unknown outcome and the session is untouched',
      () async {
        var refreshCalls = 0;
        final dio = buildDio(
          refresh: ({required refreshToken, required deviceId}) async {
            refreshCalls++;
            throw StateError('a bug in the refresh wiring');
          },
          adapter: (options) async => _unauthorized('authentication_required'),
        );

        await expectLater(
          dio.get<dynamic>('/protected'),
          throwsA(
            predicate(
              (e) =>
                  e is DioException &&
                  e.error is! UnauthorizedException &&
                  e.error is AppException,
            ),
          ),
        );

        expect(refreshCalls, 1);
        // A bug is not proof the session is dead.
        verifyNever(() => storage.clearTokens());
        expect(
          container.read(authControllerProvider),
          isA<AuthAuthenticated>(),
        );
      },
    );

    test('a runtime Exception (a storage fault) still passes the original 401 '
        'on, typed, with no logout', () async {
      var refreshCalls = 0;
      final dio = buildDio(
        refresh: ({required refreshToken, required deviceId}) async {
          refreshCalls++;
          throw const FormatException('storage fault');
        },
        adapter: (options) async => _unauthorized('authentication_required'),
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(
          predicate(
            (e) =>
                e is DioException &&
                e.error is UnauthorizedException &&
                (e.error! as UnauthorizedException).code ==
                    'authentication_required',
          ),
        ),
      );

      expect(refreshCalls, 1);
      verifyNever(() => storage.clearTokens());
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
    });
  });

  /// CW02 slice A. Contract: a non-2xx without a parsable body and `code` is an
  /// UNKNOWN outcome — treat it like `internal_error`. For the refresh call that
  /// means it is NOT proof the session is dead: only `refresh_token_invalid` /
  /// `session_superseded` sign the student out.
  test('refresh answered by a body-less 503 (unknown outcome) → NO logout, '
      'tokens untouched, the typed error surfaces', () async {
    var refreshCalls = 0;
    // The real refresh path: a BARE Dio carrying only ErrorInterceptor
    // (`DioClient.createBare`) answering 503 with no body, as a proxy/edge
    // does, unwrapped the way `AuthRepository.refresh` unwraps it. So the
    // `unknown` here is what ErrorInterceptor really produces.
    final bareRefreshDio = Dio(BaseOptions(baseUrl: 'https://test.local'))
      ..interceptors.add(ErrorInterceptor())
      ..httpClientAdapter = _FakeAdapter(
        (_) async => ResponseBody.fromString('', 503),
      );
    final dio = buildDio(
      refresh: ({required refreshToken, required deviceId}) async {
        refreshCalls++;
        try {
          await bareRefreshDio.post<dynamic>('/auth/refresh');
        } on DioException catch (e) {
          throw e.error! as AppException;
        }
        throw StateError('the bare refresh Dio was expected to fail');
      },
      adapter: (options) async => _unauthorized('authentication_required'),
    );

    await expectLater(
      dio.get<dynamic>('/protected'),
      throwsA(
        predicate(
          (e) =>
              e is DioException &&
              e.error is ApiException &&
              e.error is! UnauthorizedException &&
              (e.error! as ApiException).status == 503 &&
              (e.error! as ApiException).code == 'unknown',
        ),
      ),
    );

    expect(refreshCalls, 1);
    // Auth state unchanged and the stored session neither cleared nor rewritten.
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
    verifyNever(() => storage.clearTokens());
    verifyNever(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    );
  });

  // The same unknown-outcome rule for the 4xx a refresh can answer without a
  // body. What the code does TODAY (`_performRefresh`): it signs out only on the
  // two NAMED codes, `refresh_token_invalid` and `session_superseded`; a refresh
  // 401/400 that names nothing is `code: 'unknown'`, so it is rethrown typed and
  // the student stays signed in with the same stored tokens. Pinned as it is —
  // the contract's rule for a body-less non-2xx is "treat it like
  // internal_error", and which refresh 4xx codes the server really sends is a
  // Seif question, not something to guess here.
  for (final status in [401, 400]) {
    test('refresh answered by a body-less $status (unknown outcome) → NO '
        'logout, tokens untouched, the typed error surfaces', () async {
      var refreshCalls = 0;
      final bareRefreshDio = Dio(BaseOptions(baseUrl: 'https://test.local'))
        ..interceptors.add(ErrorInterceptor())
        ..httpClientAdapter = _FakeAdapter(
          (_) async => ResponseBody.fromString('', status),
        );
      final dio = buildDio(
        refresh: ({required refreshToken, required deviceId}) async {
          refreshCalls++;
          try {
            await bareRefreshDio.post<dynamic>('/auth/refresh');
          } on DioException catch (e) {
            throw e.error! as AppException;
          }
          throw StateError('the bare refresh Dio was expected to fail');
        },
        adapter: (options) async => _unauthorized('authentication_required'),
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(
          predicate(
            (e) =>
                e is DioException &&
                e.error is ApiException &&
                // 401 keeps its dedicated type; 400 without a body is NOT a
                // validation error (no `validation_failed` code).
                (e.error is UnauthorizedException) == (status == 401) &&
                e.error is! ValidationException &&
                (e.error! as ApiException).status == status &&
                (e.error! as ApiException).code == 'unknown',
          ),
        ),
      );

      expect(refreshCalls, 1);
      expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
      verifyNever(() => storage.clearTokens());
      verifyNever(
        () => storage.writeTokens(
          access: any(named: 'access'),
          refresh: any(named: 'refresh'),
        ),
      );
    });
  }

  test('a 401 with NO body (or none carrying a code) → no refresh, no logout, '
      'surfaced as UnauthorizedException(unknown)', () async {
    var refreshCalls = 0;
    // Only `authentication_required` starts a refresh and only
    // `session_superseded` (or a dead refresh) signs out; a 401 that names
    // nothing does neither.
    final unnamed = <String, ResponseBody Function()>{
      'an empty body': () => ResponseBody.fromString('', 401),
      'a proxy HTML page': () => ResponseBody.fromString(
        '<html><body>401</body></html>',
        401,
        headers: {
          Headers.contentTypeHeader: ['text/html'],
        },
      ),
      'a ProblemDetails-like map without a code': () =>
          _json(401, {'title': 'Unauthorized', 'status': 401}),
    };

    for (final entry in unnamed.entries) {
      final dio = buildDio(
        refresh: ({required refreshToken, required deviceId}) async {
          refreshCalls++;
          return _newTokens;
        },
        adapter: (options) async => entry.value(),
      );

      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(
          predicate(
            (e) =>
                e is DioException &&
                e.error is UnauthorizedException &&
                (e.error! as UnauthorizedException).code == 'unknown',
          ),
        ),
        reason: entry.key,
      );
    }

    expect(refreshCalls, 0);
    expect(container.read(authControllerProvider), isA<AuthAuthenticated>());
    verifyNever(() => storage.clearTokens());
    verifyNever(
      () => storage.writeTokens(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'),
      ),
    );
  });
}
