import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';

/// Drives [ErrorInterceptor.onError] directly and captures what it rejected
/// with — the mapped [AppException] the repositories unwrap.
AppException _map(DioException err) {
  final interceptor = ErrorInterceptor();
  late Object? captured;
  final handler = _CaptureHandler((e) => captured = e.error);
  interceptor.onError(err, handler);
  return captured! as AppException;
}

class _CaptureHandler extends ErrorInterceptorHandler {
  _CaptureHandler(this.onReject);
  final void Function(DioException) onReject;

  @override
  void reject(DioException error, [bool callFollowingErrorInterceptor = false]) =>
      onReject(error);
}

DioException _response(int status, Object? body, {Headers? headers}) =>
    DioException(
      requestOptions: RequestOptions(path: '/auth/register'),
      response: Response<Object?>(
        requestOptions: RequestOptions(path: '/auth/register'),
        statusCode: status,
        data: body,
        headers: headers,
      ),
      type: DioExceptionType.badResponse,
    );

/// A `429 rate_limited` off `/reference/cities` with the given `Retry-After`
/// header value verbatim (null = the header is absent).
RateLimitedException _rateLimited(String? retryAfter) => _map(
      _response(
        429,
        {'code': 'rate_limited', 'title': 'Too Many Requests', 'status': 429},
        headers: Headers.fromMap(<String, List<String>>{
          if (retryAfter != null) 'retry-after': [retryAfter],
        }),
      ),
    ) as RateLimitedException;

void main() {
  group('400 validation_failed → ValidationException', () {
    test('carries the ProblemDetails field map', () {
      // Payload shape copied from the contract (ProblemDetails.errors:
      // additionalProperties -> array of string), with the geography
      // conditionality violation adr-010 produces.
      final mapped = _map(
        _response(400, {
          'title': 'Validation failed',
          'status': 400,
          'code': 'validation_failed',
          'errors': {
            'governorateId': ['governorateId is required when countryCode is EG'],
            // adr-028 §1's own violation, replacing the schoolName sample:
            // that field no longer exists on the contract, so the server can
            // never name it again.
            'cityName': ['cityName is not allowed together with cityId'],
          },
        }),
      );

      expect(mapped, isA<ValidationException>());
      final validation = mapped as ValidationException;
      expect(validation.status, 400);
      expect(validation.code, 'validation_failed');
      expect(validation.fields, containsAll(['governorateId', 'cityName']));
      expect(validation.errors['governorateId'], hasLength(1));
    });

    test('is still an ApiException (existing handlers keep working)', () {
      final mapped = _map(
        _response(400, {'code': 'validation_failed', 'errors': <String, dynamic>{}}),
      );
      expect(mapped, isA<ApiException>());
      expect((mapped as ApiException).status, 400);
    });

    test('a missing/malformed errors map yields empty fields, not a crash', () {
      expect(
        (_map(_response(400, {'code': 'validation_failed'})) as ValidationException)
            .fields,
        isEmpty,
      );
      expect(
        (_map(_response(400, {'code': 'validation_failed', 'errors': 'nope'}))
                as ValidationException)
            .fields,
        isEmpty,
      );
    });

    test('a non-list value is tolerated as a single message', () {
      final mapped = _map(
        _response(400, {
          'code': 'validation_failed',
          'errors': {'cityId': 'required'},
        }),
      ) as ValidationException;
      expect(mapped.errors['cityId'], ['required']);
    });
  });

  group('other statuses keep their existing mapping', () {
    test('400 with a different code stays a plain ApiException', () {
      final mapped = _map(_response(400, {'code': 'otp_expired'}));
      expect(mapped, isA<ApiException>());
      expect(mapped, isNot(isA<ValidationException>()));
      expect(mapped.code, 'otp_expired');
    });

    test('401 → UnauthorizedException carrying the code', () {
      final mapped = _map(_response(401, {'code': 'registration_token_invalid'}));
      expect(mapped, isA<UnauthorizedException>());
      expect(mapped.code, 'registration_token_invalid');
    });

    test('409 → ApiException carrying status + code', () {
      final mapped = _map(_response(409, {'code': 'phone_already_registered'}));
      expect(mapped, isA<ApiException>());
      expect((mapped as ApiException).status, 409);
      expect(mapped.code, 'phone_already_registered');
    });

    test('connection error → NetworkException (drives Offline)', () {
      final mapped = _map(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          type: DioExceptionType.connectionError,
        ),
      );
      expect(mapped, isA<NetworkException>());
    });
  });

  /// adr-028 §3 + the `rate_limited` row of error-codes.md. Neither code
  /// existed anywhere in lib/ before Day 7c; both fell through to the default
  /// arm and surfaced as a generic error.
  group('429 rate_limited → RateLimitedException', () {
    test('is typed, and is NOT otp_throttled', () {
      final mapped = _rateLimited('30');

      expect(mapped, isA<RateLimitedException>());
      expect(mapped.status, 429);
      // Reusing otp_throttled here would make a geography lookup show an OTP
      // message; Seif split the two codes for exactly that reason.
      expect(mapped.code, 'rate_limited');
      expect(mapped.code, isNot('otp_throttled'));
    });

    test('a delta-seconds Retry-After parses', () {
      expect(_rateLimited('30').retryAfter, const Duration(seconds: 30));
      expect(_rateLimited(' 5 ').retryAfter, const Duration(seconds: 5));
      expect(_rateLimited('0').retryAfter, Duration.zero);
    });

    test('an ABSENT header yields null — and does not throw', () {
      // The contract only mentions Retry-After in prose; there is no `headers:`
      // block on the 429, so it is not guaranteed to arrive at all.
      expect(_rateLimited(null).retryAfter, isNull);
    });

    test('a GARBAGE header yields null — and does not throw', () {
      for (final value in ['soon', '', '  ', '-1', '3.5', '1,2']) {
        expect(
          _rateLimited(value).retryAfter,
          isNull,
          reason: 'Retry-After: "$value" must degrade, not crash',
        );
      }
    });

    test('an HTTP-date Retry-After yields null rather than a guess', () {
      // Converting a date means trusting the device clock against the
      // server's. A wrong countdown is worse than no countdown.
      expect(
        _rateLimited('Wed, 05 Aug 2026 07:28:00 GMT').retryAfter,
        isNull,
      );
    });

    test('a 429 with a DIFFERENT code stays a plain ApiException', () {
      // `otp_throttled` is still 429 and must keep its own handling.
      final mapped = _map(_response(429, {'code': 'otp_throttled'}));
      expect(mapped, isNot(isA<RateLimitedException>()));
      expect(mapped.code, 'otp_throttled');
    });
  });

  group('404 country_not_found', () {
    test('maps to an ApiException carrying that code, not `unknown`', () {
      // No subclass and no new UI by design — Seif's notice §3 says the
      // geography pickers' generic error state stays as-is. The point is only
      // that the code survives as itself.
      final mapped = _map(_response(404, {'code': 'country_not_found'}));

      expect(mapped, isA<ApiException>());
      expect((mapped as ApiException).status, 404);
      expect(mapped.code, 'country_not_found');
      expect(mapped.code, isNot('unknown'));
    });

    test('a malformed countryCode is the 400, not the 404', () {
      // Worth pinning because the split is easy to get backwards: `EGY`/`1`/``
      // are validation_failed; a well-formed but unrecognised `XX` is the 404.
      final mapped = _map(_response(400, {'code': 'validation_failed'}));
      expect(mapped, isA<ValidationException>());
    });
  });
}
