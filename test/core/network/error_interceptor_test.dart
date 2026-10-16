import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show AsyncValue;
import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/core/network/interceptors/error_interceptor.dart';
import 'package:level_up_app/core/theme/app_theme.dart';
import 'package:level_up_app/features/auth/auth_error_copy.dart';
import 'package:level_up_app/features/catalog/widgets/catalog_states.dart';
import 'package:level_up_app/features/flashcards/widgets/flashcards_error_copy.dart';
import 'package:level_up_app/features/leaderboard/board_failure.dart';
import 'package:level_up_app/features/profile/profile_error_copy.dart';
import 'package:level_up_app/features/quiz/widgets/quiz_error_copy.dart';
import 'package:level_up_app/features/registration/registration_error_copy.dart';
import 'package:level_up_app/l10n/app_localizations.dart';

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
  void reject(
    DioException error, [
    bool callFollowingErrorInterceptor = false,
  ]) => onReject(error);
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
RateLimitedException _rateLimited(String? retryAfter) =>
    _map(
          _response(
            429,
            {
              'code': 'rate_limited',
              'title': 'Too Many Requests',
              'status': 429,
            },
            headers: Headers.fromMap(<String, List<String>>{
              if (retryAfter != null) 'retry-after': [retryAfter],
            }),
          ),
        )
        as RateLimitedException;

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
            'governorateId': [
              'governorateId is required when countryCode is EG',
            ],
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
        _response(400, {
          'code': 'validation_failed',
          'errors': <String, dynamic>{},
        }),
      );
      expect(mapped, isA<ApiException>());
      expect((mapped as ApiException).status, 400);
    });

    test('a missing/malformed errors map yields empty fields, not a crash', () {
      expect(
        (_map(_response(400, {'code': 'validation_failed'}))
                as ValidationException)
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
      final mapped =
          _map(
                _response(400, {
                  'code': 'validation_failed',
                  'errors': {'cityId': 'required'},
                }),
              )
              as ValidationException;
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
      final mapped = _map(
        _response(401, {'code': 'registration_token_invalid'}),
      );
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
      expect(_rateLimited('Wed, 05 Aug 2026 07:28:00 GMT').retryAfter, isNull);
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

  /// Contract 3.32.0-m1: not every non-2xx carries a ProblemDetails body (a
  /// failure while writing the response, a host shutdown, a proxy/edge 502/503/
  /// 504, a non-API endpoint). These are characterisation tests of what the
  /// interceptor already does with such a response: it is an UNKNOWN outcome,
  /// never a crash and never mistaken for a typed failure.
  group(
    'a non-2xx without a parsable ProblemDetails is an unknown outcome',
    () {
      final unparsableBodies = <String, Object?>{
        'a null body': null,
        'an empty string': '',
        'a proxy HTML page': '<html><body>502 Bad Gateway</body></html>',
        'a JSON list': <Object?>['not', 'a', 'problem'],
        'a map without a code': <String, Object?>{
          'title': 'Bad Gateway',
          'status': 502,
        },
        'a map with a non-string code': <String, Object?>{'code': 502},
      };

      for (final entry in unparsableBodies.entries) {
        test('502 with ${entry.key} → ApiException(502, unknown)', () {
          final mapped = _map(_response(502, entry.value));

          expect(mapped, isA<ApiException>());
          expect((mapped as ApiException).status, 502);
          expect(mapped.code, 'unknown');
        });
      }

      test('a bodyless 401 stays UnauthorizedException, code unknown', () {
        final mapped = _map(_response(401, null));

        expect(mapped, isA<UnauthorizedException>());
        expect(mapped.code, 'unknown');
      });

      test('a bodyless 400 is NOT a ValidationException, code unknown', () {
        final mapped = _map(_response(400, null));

        expect(mapped, isA<ApiException>());
        expect(mapped, isNot(isA<ValidationException>()));
        expect((mapped as ApiException).status, 400);
        expect(mapped.code, 'unknown');
      });
    },
  );

  /// CW02 slice A. The contract's rule (`openapi.yaml`, `ProblemDetails`): "A
  /// non-2xx without a parsable body and `code` is an unknown outcome; treat it
  /// like `internal_error`." The group above pins it at 502 and for a bodyless
  /// 401/400; this one adds the statuses and body shapes it leaves out. The
  /// 502 HTML page, the 502 null body and the bodyless 401 are NOT repeated.
  group('unknown outcome — other statuses and body shapes', () {
    test('503 with a null or an empty body → ApiException(503, unknown)', () {
      for (final body in <Object?>[null, '']) {
        final mapped = _map(_response(503, body));

        expect(
          mapped,
          isA<ApiException>(),
          reason: 'body: ${body.runtimeType}',
        );
        expect((mapped as ApiException).status, 503);
        expect(mapped.code, 'unknown');
      }
    });

    test('500 with a ProblemDetails-like map lacking code → '
        'ApiException(500, unknown)', () {
      final mapped = _map(_response(500, {'title': 'x', 'status': 500}));

      expect(mapped, isA<ApiException>());
      expect((mapped as ApiException).status, 500);
      expect(mapped.code, 'unknown');
    });

    test(
      '403 with {} → ApiException(403, unknown), not a pending deletion',
      () {
        final mapped = _map(_response(403, <String, Object?>{}));

        expect(mapped, isA<ApiException>());
        expect(mapped, isNot(isA<UnauthorizedException>()));
        expect((mapped as ApiException).status, 403);
        expect(mapped.code, 'unknown');
        // The retry/redirect rules for account_pending_deletion must never be
        // triggered by a body that merely says nothing.
        expect(isAccountPendingDeletion(mapped), isFalse);
      },
    );

    test('a `code` that is not a string → unknown, whatever its JSON type', () {
      // The 502 table above already covers the integer 502; these are the other
      // JSON types, at a different status.
      final nonStrings = <String, Object?>{
        'an integer': 7,
        'a double': 7.5,
        'a bool': true,
        'null': null,
        'a list': <Object?>['internal_error'],
        'a map': <String, Object?>{'value': 'internal_error'},
      };
      for (final entry in nonStrings.entries) {
        final mapped = _map(_response(500, {'code': entry.value}));

        expect(
          mapped,
          isA<ApiException>(),
          reason: 'code is ${entry.key} — must not crash or be typed',
        );
        expect((mapped as ApiException).status, 500);
        expect(mapped.code, 'unknown', reason: 'code is ${entry.key}');
      }
    });

    test('an unknown outcome is never mistaken for a typed failure', () {
      // A 429 with no body is not `rate_limited` (it would need the code), and
      // no body-less answer is Offline: the contract treats it like
      // internal_error, which has copy and a Retry of its own.
      final bodyless429 = _map(_response(429, null));
      expect(bodyless429, isA<ApiException>());
      expect(bodyless429, isNot(isA<RateLimitedException>()));
      expect((bodyless429 as ApiException).status, 429);
      expect(bodyless429.code, 'unknown');

      for (final status in [500, 502, 503, 504]) {
        final mapped = _map(_response(status, null));
        expect(isOffline(mapped), isFalse, reason: 'status $status');
        expect(mapped, isNot(isA<NetworkException>()), reason: '$status');
        expect(mapped, isNot(isA<ValidationException>()), reason: '$status');
        expect(mapped, isNot(isA<RateLimitedException>()), reason: '$status');
      }
    });

    test('the three timeouts stay NetworkException (Offline), not unknown', () {
      // The rule covers a non-2xx RESPONSE. A timeout has no response at all.
      // (connectionError is pinned in "other statuses keep their existing
      // mapping" above.)
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final mapped = _map(
          DioException(
            requestOptions: RequestOptions(path: '/auth/register'),
            type: type,
          ),
        );

        expect(mapped, isA<NetworkException>(), reason: '$type');
        expect(isOffline(mapped), isTrue, reason: '$type');
        expect(mapped.code, isNot('unknown'), reason: '$type');
      }
    });

    test('a cancel, a bad certificate and an unclassified failure with no '
        'response are UnknownException — never Offline', () {
      // The other half of the test above, pinned AS BUILT: these three have no
      // response either, and `ErrorInterceptor` does not count them as
      // connectivity failures — a cancelled request, a rejected TLS certificate
      // and Dio's own "unknown" bucket (e.g. a reset mid-response) take the
      // default arm, UnknownException, not Offline. The contract's
      // unknown-outcome rule covers non-2xx responses, not these; moving any of
      // them to Offline (or the timeouts out of it) must be a deliberate change
      // that updates this test.
      for (final type in [
        DioExceptionType.cancel,
        DioExceptionType.badCertificate,
        DioExceptionType.unknown,
      ]) {
        final mapped = _map(
          DioException(
            requestOptions: RequestOptions(path: '/auth/register'),
            type: type,
          ),
        );

        expect(mapped, isA<UnknownException>(), reason: '$type');
        expect(isOffline(mapped), isFalse, reason: '$type');
        expect(mapped, isNot(isA<NetworkException>()), reason: '$type');
        expect(mapped.code, 'unknown', reason: '$type');
      }
    });
  });

  /// CW02 slice A — "treat it like `internal_error`", proven against every
  /// error-copy funnel in lib/. `internal_error` has no branch of its own
  /// anywhere in the app, so the guarantee is that `unknown` takes the same
  /// default arm: this group fails the day someone gives `unknown` (or
  /// `internal_error`) its own copy, its own Retry rule or its own redirect
  /// without doing the same for the other.
  group('unknown is shown exactly like internal_error', () {
    late AppLocalizations en;
    late AppLocalizations ar;

    setUpAll(() async {
      en = await AppLocalizations.delegate.load(const Locale('en'));
      ar = await AppLocalizations.delegate.load(const Locale('ar'));
    });

    const internalError = ApiException(status: 500, code: 'internal_error');

    /// The same situation reaching a screen four ways: hand-built, and as the
    /// real [ErrorInterceptor] maps a body-less proxy answer and a body-less 500.
    Map<String, Object> unknownVariants() => {
      'ApiException(500, unknown)': const ApiException(
        status: 500,
        code: 'unknown',
      ),
      'a bodyless 503 through ErrorInterceptor': _map(_response(503, null)),
      'a bodyless 500 through ErrorInterceptor': _map(_response(500, null)),
      'a 500 whose map lacks code through ErrorInterceptor': _map(
        _response(500, {'title': 'x', 'status': 500}),
      ),
    };

    /// Real `internal_error` answers, as the interceptor maps them.
    Map<String, Object> internalErrorVariants() => {
      'ApiException(500, internal_error)': internalError,
      'a 500 internal_error through ErrorInterceptor': _map(
        _response(500, {
          'code': 'internal_error',
          'title': 'Internal Server Error',
          'status': 500,
        }),
      ),
    };

    // Every function in lib/ that takes (AppLocalizations, error) and returns
    // the copy a student reads. `FlashcardsErrorCopy` has value equality, so its
    // Retry decision is compared with its message.
    final copyFunnels = <String, Object? Function(AppLocalizations, Object)>{
      'authErrorMessage': authErrorMessage,
      'registrationErrorMessage': registrationErrorMessage,
      'referenceErrorMessage': referenceErrorMessage,
      'profileSaveErrorMessage': profileSaveErrorMessage,
      'quizErrorMessage': quizErrorMessage,
      'flashcardsErrorCopy (message + canRetry)': flashcardsErrorCopy,
      'boardFailureText': boardFailureText,
    };

    // Every error-only predicate that decides what a failure does: offers a
    // Retry, opens a sheet, restarts registration, styles an OTP box, or is the
    // pending-deletion branch.
    final decisions = <String, bool Function(Object)>{
      'suppressesRetry': suppressesRetry,
      'opensLimitSheet': opensLimitSheet,
      'boardRetryAllowed': boardRetryAllowed,
      'isOffline': isOffline,
      'isInvalidOtp': isInvalidOtp,
      'restartsRegistration': restartsRegistration,
      'isAccountPendingDeletion': isAccountPendingDeletion,
    };

    test('both locales loaded, so the EN/AR comparison below is real', () {
      expect(en.genericError, isNotEmpty);
      expect(ar.genericError, isNotEmpty);
      expect(en.genericError, isNot(ar.genericError));
    });

    for (final funnel in copyFunnels.entries) {
      test('${funnel.key} — identical output, EN and AR', () {
        for (final l10n in [en, ar]) {
          final lang = identical(l10n, en) ? 'EN' : 'AR';
          final reference = funnel.value(l10n, internalError);

          for (final variant in {
            ...unknownVariants(),
            ...internalErrorVariants(),
          }.entries) {
            expect(
              funnel.value(l10n, variant.value),
              reference,
              reason: '$lang: ${variant.key} must read like internal_error',
            );
          }
        }
      });
    }

    test('that shared answer is the generic message, with Retry on offer', () {
      for (final l10n in [en, ar]) {
        final lang = identical(l10n, en) ? 'EN' : 'AR';
        for (final funnel in copyFunnels.entries) {
          final out = funnel.value(l10n, internalError);
          final shown = out is FlashcardsErrorCopy ? out.message : out;
          expect(shown, l10n.genericError, reason: '$lang ${funnel.key}');
        }
        expect(
          flashcardsErrorCopy(l10n, internalError).canRetry,
          isTrue,
          reason: lang,
        );
      }
    });

    for (final decision in decisions.entries) {
      test('${decision.key} — identical decision', () {
        final reference = decision.value(internalError);
        for (final variant in unknownVariants().entries) {
          expect(
            decision.value(variant.value),
            reference,
            reason: '${variant.key} must decide like internal_error',
          );
        }
      });
    }

    test(
      'the shared decision is: no suppression, Retry allowed, no redirect',
      () {
        // Pinned so both sides cannot drift the same way together.
        expect(suppressesRetry(internalError), isFalse);
        expect(boardRetryAllowed(internalError), isTrue);
        expect(opensLimitSheet(internalError), isFalse);
        expect(isOffline(internalError), isFalse);
        expect(isAccountPendingDeletion(internalError), isFalse);
      },
    );

    test('field-level mappers ignore both alike', () {
      for (final error in [
        ...unknownVariants().values,
        ...internalErrorVariants().values,
      ]) {
        expect(rejectedFields(error), isEmpty);
        expect(fieldIssuesFrom(error), isEmpty);
      }
    });

    for (final locale in const [Locale('en'), Locale('ar')]) {
      testWidgets(
        'CatalogAsyncView — identical error state (${locale.languageCode})',
        (tester) async {
          final l10n = locale.languageCode == 'en' ? en : ar;

          // Everything the error state shows: its text lines and whether a
          // Retry button is on offer.
          Future<(List<String>, bool)> render(Object error) async {
            await tester.pumpWidget(
              MaterialApp(
                locale: locale,
                theme: AppTheme.light,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Scaffold(
                  body: CatalogAsyncView<int>(
                    value: AsyncValue<int>.error(error, StackTrace.empty),
                    isEmpty: (_) => false,
                    emptyMessage: 'empty',
                    onRetry: () {},
                    onLoaded: (_) => const SizedBox.shrink(),
                    skeleton: const SizedBox.shrink(),
                  ),
                ),
              ),
            );
            await tester.pump();
            final texts = tester
                .widgetList<Text>(find.byType(Text))
                .map((t) => t.data ?? '')
                .toList();
            return (texts, find.byType(FilledButton).evaluate().isNotEmpty);
          }

          final reference = await render(internalError);
          expect(reference.$1, contains(l10n.genericError));
          expect(reference.$2, isTrue, reason: 'Retry is offered');

          for (final variant in unknownVariants().entries) {
            final shown = await render(variant.value);
            expect(shown.$1, reference.$1, reason: variant.key);
            expect(shown.$2, reference.$2, reason: variant.key);
          }
        },
      );
    }
  });
}
