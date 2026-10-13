import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/recovery/recovery_errors.dart';

import '../../guards/rules.dart' show stripComments;

/// What the recovery ladder's failures mean (CW06): the documented codes, each
/// mapped to one [RecoveryFailure], and nothing else guessed at.
void main() {
  const documented = <(Object, RecoveryFailure)>[
    (
      ApiException(status: 404, code: 'recovery_unavailable'),
      RecoveryFailure.unavailable,
    ),
    (
      ApiException(status: 400, code: 'otp_invalid'),
      RecoveryFailure.otpInvalid,
    ),
    (
      ApiException(status: 400, code: 'otp_expired'),
      RecoveryFailure.otpExpired,
    ),
    (
      ApiException(status: 429, code: 'otp_throttled'),
      RecoveryFailure.throttled,
    ),
    (
      UnauthorizedException(code: 'registration_token_invalid'),
      RecoveryFailure.restartRequired,
    ),
    (
      ApiException(status: 409, code: 'phone_already_registered'),
      RecoveryFailure.phoneAlreadyRegistered,
    ),
    (ApiException(status: 403, code: 'account_banned'), RecoveryFailure.banned),
    (
      ValidationException(
        errors: {
          'newPhone': ['bad'],
        },
      ),
      RecoveryFailure.validation,
    ),
    (OfflineException(), RecoveryFailure.offline),
    (NetworkException(), RecoveryFailure.offline),
  ];

  group('classifyRecoveryFailure', () {
    for (final (error, expected) in documented) {
      test('${(error as AppException).code} -> ${expected.name}', () {
        expect(classifyRecoveryFailure(error), expected);
      });
    }

    test('every RecoveryFailure except `other` is reached by something '
        'documented', () {
      final reached = documented.map((d) => d.$2).toSet();
      expect(RecoveryFailure.values.toSet().difference(reached), {
        RecoveryFailure.other,
      });
    });

    test('anything undocumented is `other`, never guessed', () {
      for (final error in <Object?>[
        null,
        const UnknownException(),
        const ApiException(status: 500, code: 'internal_error'),
        const ApiException(status: 404, code: 'not_found'),
        const ApiException(status: 403, code: 'insufficient_scope'),
        const ApiException(status: 403, code: 'account_pending_deletion'),
        const UnauthorizedException(code: 'authentication_required'),
        const UnauthorizedException(code: 'session_superseded'),
        const ApiException(status: 500, code: 'unknown'),
        StateError('otp_invalid'),
        'account_banned',
      ]) {
        expect(
          classifyRecoveryFailure(error),
          RecoveryFailure.other,
          reason: '$error',
        );
      }
    });

    test('rate_limited (the /reference lookup limit) is NOT otp_throttled', () {
      expect(
        classifyRecoveryFailure(const RateLimitedException()),
        RecoveryFailure.other,
      );
      expect(isOtpThrottled(const RateLimitedException()), isFalse);
    });

    test('a plain ApiException is recognised by code, whatever the status '
        'subclass', () {
      expect(
        classifyRecoveryFailure(
          const ApiException(status: 400, code: 'validation_failed'),
        ),
        RecoveryFailure.validation,
      );
      expect(
        classifyRecoveryFailure(
          const UnauthorizedException(code: 'account_banned'),
        ),
        RecoveryFailure.banned,
      );
    });

    test('offline wins over everything: a connectivity failure keeps its own '
        'state', () {
      expect(
        classifyRecoveryFailure(const NetworkException(detail: 'timeout')),
        RecoveryFailure.offline,
      );
    });
  });

  group('the predicates are exclusive', () {
    final predicates = <String, bool Function(Object?)>{
      'isRecoveryUnavailable': isRecoveryUnavailable,
      'isOtpExpired': isOtpExpired,
      'isOtpThrottled': isOtpThrottled,
      'isRegistrationTokenInvalid': isRegistrationTokenInvalid,
      'isPhoneAlreadyRegistered': isPhoneAlreadyRegistered,
    };
    const codeOf = <String, String>{
      'isRecoveryUnavailable': 'recovery_unavailable',
      'isOtpExpired': 'otp_expired',
      'isOtpThrottled': 'otp_throttled',
      'isRegistrationTokenInvalid': 'registration_token_invalid',
      'isPhoneAlreadyRegistered': 'phone_already_registered',
    };

    for (final MapEntry(key: name, value: predicate) in predicates.entries) {
      test('$name matches its own code only', () {
        for (final MapEntry(key: other, value: code) in codeOf.entries) {
          expect(
            predicate(ApiException(status: 400, code: code)),
            other == name,
            reason: '$name vs $code',
          );
        }
        expect(predicate(null), isFalse);
        expect(predicate(const NetworkException()), isFalse);
        expect(predicate('${codeOf[name]}'), isFalse);
      });
    }
  });

  test('no lock duration is encoded: the recovery layer builds no Duration '
      'and has no lock state', () {
    // The recovery lock is a later contract version's and has not been
    // acknowledged: nothing in this change may carry a length of time for it.
    // Only numbers the server supplies (resendAfterSeconds, expiresInSeconds)
    // are carried, as plain ints.
    final files = <File>[
      ...Directory('lib/features/recovery')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart')),
      File('lib/dev/mock_recovery.dart'),
    ];
    expect(files.length, greaterThan(4));
    for (final file in files) {
      final code = stripComments(file.readAsStringSync());
      expect(code.contains('Duration('), isFalse, reason: file.path);
      expect(
        RegExp(r'\block\w*', caseSensitive: false).hasMatch(code),
        isFalse,
        reason: file.path,
      );
    }
  });
}
