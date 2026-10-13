import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/auth/models/auth_result.dart';
import 'package:level_up_app/features/auth/models/otp_request_result.dart';
import 'package:level_up_app/features/auth/models/token_pair.dart';

void main() {
  group('AuthResult.fromJson — discriminated on contract `result`', () {
    test(
      'authenticated → AuthenticatedResult with parsed tokens + opaque profile',
      () {
        // Shape copied from contract/openapi.yaml AuthenticatedResult + TokenPair.
        final json = {
          'result': 'authenticated',
          'tokens': {
            'accessToken': 'access.jwt',
            'accessExpiresInSeconds': 900,
            'refreshToken': 'refresh.jwt',
            'refreshExpiresInSeconds': 5184000,
          },
          'profile': {'id': 'uuid', 'track': 'school', 'name': 'Student'},
        };

        final result = AuthResult.fromJson(json);

        expect(result, isA<AuthenticatedResult>());
        final authed = result as AuthenticatedResult;
        expect(authed.tokens.accessToken, 'access.jwt');
        expect(authed.tokens.refreshExpiresInSeconds, 5184000);
        expect(authed.profile['track'], 'school');
      },
    );

    // `AuthenticatedResult.inviteCodeApplied` (spec-047): present only on the
    // completeRegistration 201 and only when the request carried an inviteCode.
    Map<String, dynamic> authenticatedJson({Object? inviteCodeApplied}) => {
      'result': 'authenticated',
      'tokens': {
        'accessToken': 'access.jwt',
        'accessExpiresInSeconds': 900,
        'refreshToken': 'refresh.jwt',
        'refreshExpiresInSeconds': 5184000,
      },
      'profile': {'id': 'uuid'},
      'inviteCodeApplied': ?inviteCodeApplied,
    };

    test('inviteCodeApplied true / false are parsed as sent', () {
      for (final applied in [true, false]) {
        final result = AuthResult.fromJson(
          authenticatedJson(inviteCodeApplied: applied),
        );
        expect((result as AuthenticatedResult).inviteCodeApplied, applied);
      }
    });

    test('inviteCodeApplied absent is null - "not asked", not "refused"', () {
      final result = AuthResult.fromJson(authenticatedJson());
      expect((result as AuthenticatedResult).inviteCodeApplied, isNull);
      // ...and a null stays out of the JSON rather than becoming a key.
      expect(result.toJson(), isNot(contains('inviteCodeApplied')));
    });

    test('inviteCodeApplied is the contract\'s name, camelCase, on the '
        'authenticated arm only', () {
      final json = AuthResult.fromJson(
        authenticatedJson(inviteCodeApplied: true),
      ).toJson();
      expect(json['inviteCodeApplied'], isTrue);
      expect(json['result'], 'authenticated');
    });

    test(
      'registrationRequired → RegistrationRequiredResult with token + ttl',
      () {
        final json = {
          'result': 'registrationRequired',
          'registrationToken': 'reg.token',
          'expiresInSeconds': 600,
        };

        final result = AuthResult.fromJson(json);

        expect(result, isA<RegistrationRequiredResult>());
        final reg = result as RegistrationRequiredResult;
        expect(reg.registrationToken, 'reg.token');
        expect(reg.expiresInSeconds, 600);
      },
    );
  });

  group('Contract fidelity — required fields have no defensive defaults', () {
    test('TokenPair throws when a required field is missing', () {
      expect(
        () => TokenPair.fromJson({
          'accessToken': 'a',
          'accessExpiresInSeconds': 900,
          // refreshToken omitted
          'refreshExpiresInSeconds': 5184000,
        }),
        throwsA(anything),
      );
    });
  });

  // E4-02: both arms hold credentials (the tokens, the profile, the
  // registration token). Freezed's generated toString printed every field.
  group('toString never prints a credential or the profile', () {
    test('authenticated: neither token, nor anything in the profile', () {
      final result = AuthResult.fromJson({
        'result': 'authenticated',
        'tokens': {
          'accessToken': 'SENTINEL-ACCESS',
          'accessExpiresInSeconds': 900,
          'refreshToken': 'SENTINEL-REFRESH',
          'refreshExpiresInSeconds': 5184000,
        },
        'profile': {'id': 'SENTINEL-ID', 'name': 'SENTINEL NAME'},
      });

      final text = '$result';
      expect(text, startsWith('AuthResult.authenticated('));
      for (final secret in const [
        'SENTINEL-ACCESS',
        'SENTINEL-REFRESH',
        'SENTINEL-ID',
        'SENTINEL NAME',
      ]) {
        expect(text, isNot(contains(secret)));
      }
      // The value is still all there.
      expect(
        (result as AuthenticatedResult).tokens.accessToken,
        'SENTINEL-ACCESS',
      );
    });

    test('registrationRequired: not the registration token', () {
      final result = AuthResult.fromJson({
        'result': 'registrationRequired',
        'registrationToken': 'SENTINEL-REGISTRATION',
        'expiresInSeconds': 600,
      });

      expect(result.toString(), startsWith('AuthResult.registrationRequired('));
      expect(result.toString(), isNot(contains('SENTINEL-REGISTRATION')));
      expect(
        (result as RegistrationRequiredResult).registrationToken,
        'SENTINEL-REGISTRATION',
      );
    });

    test('TokenPair: neither token', () {
      const pair = TokenPair(
        accessToken: 'SENTINEL-ACCESS',
        accessExpiresInSeconds: 900,
        refreshToken: 'SENTINEL-REFRESH',
        refreshExpiresInSeconds: 5184000,
      );

      expect(pair.toString(), startsWith('TokenPair('));
      expect(pair.toString(), isNot(contains('SENTINEL-ACCESS')));
      expect(pair.toString(), isNot(contains('SENTINEL-REFRESH')));
      expect(pair.accessToken, 'SENTINEL-ACCESS');
    });
  });

  test('OtpRequestResult.fromJson maps the 202 body', () {
    final r = OtpRequestResult.fromJson({
      'resendAfterSeconds': 60,
      'expiresInSeconds': 300,
    });
    expect(r.resendAfterSeconds, 60);
    expect(r.expiresInSeconds, 300);
  });
}
