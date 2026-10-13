import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';

/// A real [Dio] whose network is a function, for repository tests that should
/// see what the app sees: the real request shape (method, path, body, headers)
/// going out and the REAL `ErrorInterceptor` typing what comes back.
///
/// No socket is opened and no dependency is added - the same technique
/// `auth_interceptor_test.dart` uses, kept in one place so the data-layer tests
/// of CW04b / CW05 / CW06 do not each re-derive it.
class FakeApiAdapter implements HttpClientAdapter {
  FakeApiAdapter(this.answer);

  /// Decides the response for each request.
  final ResponseBody Function(RequestOptions options) answer;

  /// Every request that went out, oldest first.
  final List<RequestOptions> requests = [];

  RequestOptions get only => requests.single;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return answer(options);
  }

  @override
  void close({bool force = false}) {}
}

/// A [Dio] over [adapter], with the real [ErrorInterceptor] and no
/// `AuthInterceptor` (the token handling is not what these tests are about).
Dio buildFakeApiDio(FakeApiAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.local/api/v1'));
  dio.interceptors.add(ErrorInterceptor());
  dio.httpClientAdapter = adapter;
  return dio;
}

/// A JSON response.
ResponseBody jsonBody(int status, Object? body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

/// A response with no body (`204`, or a proxy failure).
ResponseBody emptyBody(int status) => ResponseBody.fromString('', status);

/// An RFC 9457 ProblemDetails response carrying a stable `code`.
ResponseBody problemBody(
  int status,
  String code, {
  Map<String, List<String>>? errors,
  Map<String, List<String>>? headers,
}) => ResponseBody.fromString(
  jsonEncode(<String, Object?>{
    'title': 'dev-facing',
    'status': status,
    'code': code,
    'detail': 'dev-facing',
    'errors': ?errors,
  }),
  status,
  headers: <String, List<String>>{
    Headers.contentTypeHeader: ['application/problem+json'],
    ...?headers,
  },
);
