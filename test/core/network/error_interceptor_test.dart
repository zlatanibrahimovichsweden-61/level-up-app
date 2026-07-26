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

DioException _response(int status, Object? body) => DioException(
      requestOptions: RequestOptions(path: '/auth/register'),
      response: Response<Object?>(
        requestOptions: RequestOptions(path: '/auth/register'),
        statusCode: status,
        data: body,
      ),
      type: DioExceptionType.badResponse,
    );

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
            'schoolName': ['schoolName is not allowed when countryCode is EG'],
          },
        }),
      );

      expect(mapped, isA<ValidationException>());
      final validation = mapped as ValidationException;
      expect(validation.status, 400);
      expect(validation.code, 'validation_failed');
      expect(validation.fields, containsAll(['governorateId', 'schoolName']));
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
}
