import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/config/app_config.dart';
import 'package:level_up_app/core/network/dio_client.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/core/providers/core_providers.dart';
import 'package:level_up_app/core/storage/secure_storage.dart';
import 'package:level_up_app/features/auth/notifier/auth_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements SecureStorage {}

/// Records every [RequestOptions] a client sends, and answers `200 {}` JSON.
/// No socket is opened: the headers asserted below are the ones a real
/// adapter would put on the wire.
class _RecordingAdapter implements HttpClientAdapter {
  final List<RequestOptions> seen = [];

  RequestOptions get last => seen.last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// The refresh closure the main client is built with. These tests never hit a
/// 401, so reaching it means a request went somewhere it should not have.
Future<Never> _refreshMustNotRun({
  required String refreshToken,
  required String deviceId,
}) async => throw StateError('refresh must not run in a header test');

const _accessToken = 'test.access.token';

void main() {
  late _MockStorage storage;
  late ProviderContainer container;
  late AuthController controller;

  setUpAll(() => AppConfig.init(Flavor.staging));

  setUp(() async {
    storage = _MockStorage();
    when(() => storage.readAccessToken()).thenAnswer((_) async => _accessToken);
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
    // Let build()'s async _resolveInitial settle (token present).
    await Future<void>.delayed(Duration.zero);
  });

  /// The main client, built exactly the way the app builds it, with the
  /// network replaced by a recorder.
  (Dio, _RecordingAdapter) mainClient() {
    final adapter = _RecordingAdapter();
    final dio = DioClient.create(
      storage: storage,
      authController: controller,
      refresh: _refreshMustNotRun,
      error: ErrorInterceptor(),
    )..httpClientAdapter = adapter;
    return (dio, adapter);
  }

  (Dio, _RecordingAdapter) bareClient() {
    final adapter = _RecordingAdapter();
    final dio = DioClient.createBare(error: ErrorInterceptor())
      ..httpClientAdapter = adapter;
    return (dio, adapter);
  }

  /// Contract 3.32.0-m1: a request whose `Accept` excludes JSON can be
  /// answered with no ProblemDetails body at all, so the client must ask for
  /// JSON on every call. Without it a default Dio request sends no `Accept`.
  group('Accept: application/json on every request (contract 3.32.0-m1)', () {
    test('the main client sends it on GET, POST, PATCH and DELETE', () async {
      final (dio, adapter) = mainClient();

      await dio.get<dynamic>('/me');
      await dio.post<dynamic>('/auth/logout', data: <String, dynamic>{});
      await dio.patch<dynamic>('/me', data: <String, dynamic>{});
      await dio.delete<dynamic>('/me/deletion-request');

      expect(adapter.seen.map((o) => o.method), [
        'GET',
        'POST',
        'PATCH',
        'DELETE',
      ]);
      for (final o in adapter.seen) {
        expect(
          o.headers['accept'],
          'application/json',
          reason: '${o.method} ${o.path} must ask for JSON',
        );
      }
    });

    test('the Bearer token and the content type travel beside it', () async {
      final (dio, adapter) = mainClient();

      await dio.post<dynamic>('/me/something', data: <String, dynamic>{});

      final sent = adapter.last;
      expect(sent.headers['accept'], 'application/json');
      expect(sent.headers['authorization'], 'Bearer $_accessToken');
      expect(sent.headers['content-type'], 'application/json');
    });

    test('the bare refresh client sends it too, and never a token', () async {
      final (dio, adapter) = bareClient();

      await dio.post<dynamic>('/auth/refresh', data: <String, dynamic>{});

      final sent = adapter.last;
      expect(sent.headers['accept'], 'application/json');
      expect(sent.headers['content-type'], 'application/json');
      expect(sent.headers['authorization'], isNull);
    });

    test('it is a default, not a lock: a per-request Accept wins', () async {
      // The support-photo GET asks for bytes and still accepts the problem
      // body (`image/*, application/problem+json`).
      const photoAccept = 'image/*, application/problem+json';
      final options = Options(headers: {'Accept': photoAccept});

      final (main, mainAdapter) = mainClient();
      await main.get<dynamic>('/support/photo', options: options);
      expect(mainAdapter.last.headers['accept'], photoAccept);
      // The override replaces the default; it does not join it.
      expect(
        mainAdapter.last.headers['accept'],
        isNot(contains('application/json')),
      );
      // ...and the rest of the defaults are untouched.
      expect(mainAdapter.last.headers['authorization'], 'Bearer $_accessToken');

      final (bare, bareAdapter) = bareClient();
      await bare.get<dynamic>('/support/photo', options: options);
      expect(bareAdapter.last.headers['accept'], photoAccept);
    });
  });
}
