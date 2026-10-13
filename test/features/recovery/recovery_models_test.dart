import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/features/recovery/models/recovery_models.dart';

import '../../dev/contract_inline.dart';

/// The recovery ladder's response models (CW06 data layer): the `200` bodies of
/// `startRecovery` and `verifyParentOtp`. The other two steps reuse
/// `OtpRequestResult` and `AuthenticatedResult` (see the repository test).
void main() {
  // Fabricated values: a UUID-shaped id, a made-up token, and the contract's
  // own example of a masked number.
  const startBody = <String, dynamic>{
    'recoveryId': '7ec0e000-0000-4000-8000-000000000001',
    'parentPhoneMasked': '•••• ••• 1234',
    'resendAfterSeconds': 60,
    'expiresInSeconds': 300,
  };
  const verifiedBody = <String, dynamic>{
    'rebindToken': 'fabricated.rebind.token',
    'expiresInSeconds': 600,
  };

  group('RecoveryStartResult', () {
    test('decodes the four required fields', () {
      final r = RecoveryStartResult.fromJson(startBody);
      expect(r.recoveryId, startBody['recoveryId']);
      expect(r.parentPhoneMasked, startBody['parentPhoneMasked']);
      expect(r.resendAfterSeconds, 60);
      expect(r.expiresInSeconds, 300);
    });

    test('the masked number is kept exactly as served - not completed, not '
        'reformatted, not trimmed', () {
      for (final masked in ['•• 12', ' ** *** 99 ', '']) {
        final r = RecoveryStartResult.fromJson({
          ...startBody,
          'parentPhoneMasked': masked,
        });
        expect(r.parentPhoneMasked, masked);
      }
    });

    for (final key in startBody.keys) {
      test('a body without `$key` is a typed failure', () {
        expect(
          () => RecoveryStartResult.fromJson({...startBody}..remove(key)),
          throwsA(isA<TypeError>()),
        );
      });
    }

    test('a mistyped field is a failure, not a default', () {
      expect(
        () => RecoveryStartResult.fromJson({
          ...startBody,
          'resendAfterSeconds': '60',
        }),
        throwsA(isA<TypeError>()),
      );
      expect(
        () => RecoveryStartResult.fromJson({...startBody, 'recoveryId': 5}),
        throwsA(isA<TypeError>()),
      );
    });

    test('equal when every field is', () {
      expect(
        RecoveryStartResult.fromJson(startBody),
        RecoveryStartResult.fromJson(startBody),
      );
      expect(
        RecoveryStartResult.fromJson(startBody).hashCode,
        RecoveryStartResult.fromJson(startBody).hashCode,
      );
      expect(
        RecoveryStartResult.fromJson(startBody),
        isNot(
          RecoveryStartResult.fromJson({...startBody, 'expiresInSeconds': 1}),
        ),
      );
    });

    test('toString carries no id, no number and no timing', () {
      final text = RecoveryStartResult.fromJson(startBody).toString();
      expect(text, 'RecoveryStartResult()');
      expect(text, isNot(contains('7ec0e000')));
      expect(text, isNot(contains('1234')));
    });
  });

  group('ParentVerifiedResult', () {
    test('decodes the two required fields', () {
      final r = ParentVerifiedResult.fromJson(verifiedBody);
      expect(r.rebindToken, 'fabricated.rebind.token');
      expect(r.expiresInSeconds, 600);
    });

    for (final key in verifiedBody.keys) {
      test('a body without `$key` is a typed failure', () {
        expect(
          () => ParentVerifiedResult.fromJson({...verifiedBody}..remove(key)),
          throwsA(isA<TypeError>()),
        );
      });
    }

    test('equal when both fields are', () {
      expect(
        ParentVerifiedResult.fromJson(verifiedBody),
        ParentVerifiedResult.fromJson(verifiedBody),
      );
      expect(
        ParentVerifiedResult.fromJson(verifiedBody),
        isNot(
          ParentVerifiedResult.fromJson({
            ...verifiedBody,
            'rebindToken': 'other',
          }),
        ),
      );
    });

    test('toString does not print the token', () {
      final text = ParentVerifiedResult.fromJson(verifiedBody).toString();
      expect(text, 'ParentVerifiedResult()');
      expect(text, isNot(contains('fabricated')));
    });
  });

  group('the pinned contract', () {
    late String yaml;
    late String dart;

    setUpAll(() {
      yaml = File('contract/openapi.yaml').readAsStringSync();
      dart = File(
        'lib/features/recovery/models/recovery_models.dart',
      ).readAsStringSync();
    });

    ContractOperation op(String path) =>
        ContractOperation.find(yaml, path: path, method: 'post');

    test('startRecovery: stable, anonymous, exactly these four required '
        'fields, all modelled', () {
      final start = op('/auth/recovery/start');
      expect(start.operationId, 'startRecovery');
      expect(start.isStable, isTrue);
      expect(start.isAnonymous, isTrue);
      expect(start.responseRequired('200'), startBody.keys.toList());
      expect(start.responseProperties('200'), startBody.keys.toList());
      expect(
        missingModelFields(
          dart,
          'RecoveryStartResult',
          start.responseRequired('200'),
        ),
        isEmpty,
      );
    });

    test('verifyParentOtp: stable, anonymous, exactly these two required '
        'fields, all modelled', () {
      final verify = op('/auth/recovery/verify-parent');
      expect(verify.operationId, 'verifyParentOtp');
      expect(verify.isStable, isTrue);
      expect(verify.isAnonymous, isTrue);
      expect(verify.responseRequired('200'), verifiedBody.keys.toList());
      expect(verify.responseProperties('200'), verifiedBody.keys.toList());
      expect(
        missingModelFields(
          dart,
          'ParentVerifiedResult',
          verify.responseRequired('200'),
        ),
        isEmpty,
      );
    });

    test('the other two steps answer with types that already exist', () {
      // submitNewPhone's 202 is {resendAfterSeconds, expiresInSeconds}: the
      // shape OtpRequestResult already models. confirmRecovery's 200 is
      // AuthenticatedResult itself.
      final newPhone = op('/auth/recovery/new-phone');
      expect(newPhone.responseRequired('202'), [
        'resendAfterSeconds',
        'expiresInSeconds',
      ]);
      final otpRequest = op('/auth/otp/request');
      expect(
        otpRequest.responseRequired('202').toSet(),
        newPhone.responseRequired('202').toSet(),
      );
      expect(
        op('/auth/recovery/confirm').text,
        contains(
          "schema: { \$ref: '#/components/schemas/AuthenticatedResult' }",
        ),
      );
    });
  });
}
