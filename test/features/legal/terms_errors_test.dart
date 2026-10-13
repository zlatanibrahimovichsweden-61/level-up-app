import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/legal/terms_errors.dart';

/// The Terms-acceptance code predicates (CW04b), in `terms_errors.dart` and
/// deliberately NOT in `core/network/exceptions.dart`.
void main() {
  const required = ApiException(status: 403, code: 'terms_acceptance_required');

  group('isTermsAcceptanceRequired (403 terms_acceptance_required)', () {
    test('recognises the code', () {
      expect(isTermsAcceptanceRequired(required), isTrue);
    });

    test('is not the other 403s the same routes answer', () {
      for (final code in [
        'account_pending_deletion',
        'insufficient_scope',
        'subscription_required',
        'account_banned',
        'redemption_scope_only',
      ]) {
        expect(
          isTermsAcceptanceRequired(ApiException(status: 403, code: code)),
          isFalse,
          reason: code,
        );
      }
    });

    test('and the pending-deletion predicate does not claim it either', () {
      expect(isAccountPendingDeletion(required), isFalse);
      expect(isAccountBanned(required), isFalse);
    });

    test('ignores transport failures, non-API errors and null', () {
      for (final error in <Object?>[
        null,
        const OfflineException(),
        const NetworkException(),
        const UnknownException(),
        const RateLimitedException(),
        StateError('terms_acceptance_required'),
        'terms_acceptance_required',
      ]) {
        expect(isTermsAcceptanceRequired(error), isFalse, reason: '$error');
      }
    });

    test('matches on the code, so a subclass of ApiException is recognised '
        'too', () {
      expect(
        isTermsAcceptanceRequired(
          const UnauthorizedException(code: 'terms_acceptance_required'),
        ),
        isTrue,
      );
    });
  });

  group('isTermsVersionRejected (400 validation_failed on termsVersion)', () {
    test('a field error on termsVersion', () {
      expect(
        isTermsVersionRejected(
          const ValidationException(
            errors: {
              'termsVersion': ['x'],
            },
          ),
        ),
        isTrue,
      );
    });

    test('a field error on anything else is not it', () {
      expect(
        isTermsVersionRejected(
          const ValidationException(
            errors: {
              'name': ['x'],
            },
          ),
        ),
        isFalse,
      );
      expect(
        isTermsVersionRejected(const ValidationException(errors: {})),
        isFalse,
      );
    });

    test('only a ValidationException counts', () {
      expect(isTermsVersionRejected(required), isFalse);
      expect(isTermsVersionRejected(null), isFalse);
      expect(isTermsVersionRejected(const NetworkException()), isFalse);
    });
  });

  test('the pinned registry still lists the code as a 403', () {
    final row = File('contract/error-codes.md').readAsLinesSync().singleWhere(
      (l) => l.startsWith('| `terms_acceptance_required` |'),
    );
    expect(row, contains('| 403 |'));
  });

  test('the pinned registry still lists the 400 the accept answers', () {
    final contract = File('contract/openapi.yaml').readAsStringSync();
    expect(contract, contains('operationId: acceptTerms'));
    expect(
      contract,
      contains('`validation_failed` with a field error on `termsVersion`'),
    );
  });
}
