import 'package:flutter_test/flutter_test.dart';
import 'package:level_up_app/core/network/exceptions.dart';
import 'package:level_up_app/features/profile/track_transfer_errors.dart';

/// The two refusals particular to `transferToUniversity`, told apart from each
/// other and from the operation's other `403` purely by `code`
/// (`contract/error-codes.md:59-60`).
void main() {
  const notEligible = ApiException(
    status: 403,
    code: 'track_transfer_not_eligible',
  );
  const notAllowed = ApiException(
    status: 409,
    code: 'track_transfer_not_allowed',
  );
  const pendingDeletion = ApiException(
    status: 403,
    code: 'account_pending_deletion',
  );

  group('isTrackTransferNotEligible (403)', () {
    test('matches its own code', () {
      expect(isTrackTransferNotEligible(notEligible), isTrue);
    });

    test('is not the other transfer refusal', () {
      expect(isTrackTransferNotEligible(notAllowed), isFalse);
    });

    test('is not the operation\'s OTHER 403 - read the code', () {
      expect(isTrackTransferNotEligible(pendingDeletion), isFalse);
      expect(isAccountPendingDeletion(pendingDeletion), isTrue);
      expect(isAccountPendingDeletion(notEligible), isFalse);
    });

    test(
      'is not a validation failure, an unauthorised or an offline error',
      () {
        expect(
          isTrackTransferNotEligible(
            const ValidationException(errors: {'universityId': []}),
          ),
          isFalse,
        );
        expect(
          isTrackTransferNotEligible(
            const UnauthorizedException(code: 'session_superseded'),
          ),
          isFalse,
        );
        expect(isTrackTransferNotEligible(const OfflineException()), isFalse);
      },
    );

    test('is false for null and for things that are not AppExceptions', () {
      expect(isTrackTransferNotEligible(null), isFalse);
      expect(
        isTrackTransferNotEligible('track_transfer_not_eligible'),
        isFalse,
      );
      expect(isTrackTransferNotEligible(StateError('x')), isFalse);
    });

    test('recognises a future subclass as well as a plain ApiException', () {
      expect(isTrackTransferNotEligible(const _SubclassedApiError()), isTrue);
    });
  });

  group('isTrackTransferNotAllowed (409)', () {
    test('matches its own code', () {
      expect(isTrackTransferNotAllowed(notAllowed), isTrue);
    });

    test('is not the other transfer refusal', () {
      expect(isTrackTransferNotAllowed(notEligible), isFalse);
    });

    test('is not account_pending_deletion', () {
      expect(isTrackTransferNotAllowed(pendingDeletion), isFalse);
    });

    test('is not a validation failure, an unauthorised or a network error', () {
      expect(
        isTrackTransferNotAllowed(const ValidationException(errors: {})),
        isFalse,
      );
      expect(
        isTrackTransferNotAllowed(
          const UnauthorizedException(code: 'authentication_required'),
        ),
        isFalse,
      );
      expect(
        isTrackTransferNotAllowed(const NetworkException(detail: 'timeout')),
        isFalse,
      );
    });

    test('is false for null and for things that are not AppExceptions', () {
      expect(isTrackTransferNotAllowed(null), isFalse);
      expect(isTrackTransferNotAllowed('track_transfer_not_allowed'), isFalse);
    });
  });

  test('the code constants are the contract strings', () {
    expect(kTrackTransferNotEligibleCode, 'track_transfer_not_eligible');
    expect(kTrackTransferNotAllowedCode, 'track_transfer_not_allowed');
  });
}

class _SubclassedApiError extends ApiException {
  const _SubclassedApiError()
    : super(status: 403, code: 'track_transfer_not_eligible');
}
