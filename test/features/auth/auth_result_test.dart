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

  test('OtpRequestResult.fromJson maps the 202 body', () {
    final r = OtpRequestResult.fromJson({
      'resendAfterSeconds': 60,
      'expiresInSeconds': 300,
    });
    expect(r.resendAfterSeconds, 60);
    expect(r.expiresInSeconds, 300);
  });
}
