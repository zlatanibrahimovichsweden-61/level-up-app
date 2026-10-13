import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/deletion/deletion_errors.dart';

/// The codes `/me/deletion-request` answers for itself (CW05), as predicates.
/// `account_pending_deletion` is NOT among them: it stays defined once, in
/// `core/network/exceptions.dart`.
void main() {
  const already = ApiException(status: 409, code: 'deletion_already_requested');
  const nothing = ApiException(status: 404, code: 'no_pending_deletion');
  const pending = ApiException(status: 403, code: 'account_pending_deletion');

  test('each predicate recognises its own code and no other', () {
    expect(isDeletionAlreadyRequested(already), isTrue);
    expect(isDeletionAlreadyRequested(nothing), isFalse);
    expect(isDeletionAlreadyRequested(pending), isFalse);

    expect(isNoPendingDeletion(nothing), isTrue);
    expect(isNoPendingDeletion(already), isFalse);
    expect(isNoPendingDeletion(pending), isFalse);
  });

  test('and the existing account_pending_deletion predicate is a third, '
      'separate thing', () {
    expect(isAccountPendingDeletion(pending), isTrue);
    expect(isAccountPendingDeletion(already), isFalse);
    expect(isAccountPendingDeletion(nothing), isFalse);
  });

  test('no_pending_deletion is not the generic not_found, and vice versa', () {
    expect(
      isNoPendingDeletion(const ApiException(status: 404, code: 'not_found')),
      isFalse,
    );
    expect(isNoPendingDeletion(nothing), isTrue);
  });

  test('transport failures, non-API errors and null are neither', () {
    for (final error in <Object?>[
      null,
      const OfflineException(),
      const NetworkException(),
      const UnknownException(),
      const RateLimitedException(),
      const UnauthorizedException(code: 'session_superseded'),
      StateError('deletion_already_requested'),
      'no_pending_deletion',
    ]) {
      expect(isDeletionAlreadyRequested(error), isFalse, reason: '$error');
      expect(isNoPendingDeletion(error), isFalse, reason: '$error');
    }
  });

  test('matches on the code, so a subclass of ApiException is recognised', () {
    expect(
      isDeletionAlreadyRequested(
        const UnauthorizedException(code: 'deletion_already_requested'),
      ),
      isTrue,
    );
  });

  test('the pinned registry still lists both codes with the statuses the '
      'predicates assume', () {
    final rows = File('contract/error-codes.md').readAsLinesSync();
    final already = rows.singleWhere(
      (l) => l.startsWith('| `deletion_already_requested` |'),
    );
    final nothing = rows.singleWhere(
      (l) => l.startsWith('| `no_pending_deletion` |'),
    );
    expect(already, contains('| 409 |'));
    expect(nothing, contains('| 404 |'));
  });
}
