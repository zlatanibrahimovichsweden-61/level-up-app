/// Throwaway on-device preview data for the lost-phone recovery ladder - NOT
/// production code.
///
/// Answers the four anonymous operations `POST /auth/recovery/start`,
/// `/verify-parent`, `/new-phone` and `/confirm` (`startRecovery`,
/// `verifyParentOtp`, `submitNewPhone`, `confirmRecovery`;
/// `contract/openapi.yaml:462-629`, all `x-stability: stable`) for
/// `lib/dev/mock_backend.dart`, which owns the request plumbing. This file
/// holds the state and the contract's rules; the interceptor turns a
/// [MockRecoveryReply] into a Dio response. The success of the last step is
/// the one answer it cannot build itself - the profile belongs to the
/// interceptor - so it returns [MockRecoveryAuthenticated] and the interceptor
/// makes the `AuthenticatedResult` exactly as it does for a sign-in.
///
/// **Everything here is fabricated.** The recovery ids, rebind tokens and the
/// masked number are not a real student's; the phone numbers below are the
/// reserved fake range.
///
/// ### Magic values (so each branch of the contract can be walked)
///
/// Phones, at step 1 and 3:
/// - [kMockRecoveryUnknownPhone] at step 1 -> `404 recovery_unavailable`;
/// - [kMockRecoveryThrottledPhone] at step 1 AND step 3 -> `429 otp_throttled`
///   (both operations document the 429);
/// - [kMockRecoveryTakenPhone] at step 3 -> `409 phone_already_registered`;
/// - a `newPhone` that is not an E.164 number -> `400 validation_failed` on
///   `newPhone` (documented for `submitNewPhone`);
/// - a `phone` that is not an E.164 number -> `400 validation_failed` on
///   `phone`. **Not documented for `startRecovery`** (it documents 200, 404 and
///   429 only); the mock answers the registry's generic `validation_failed`
///   (`contract/error-codes.md`) so a malformed request is not mistaken for an
///   unknown account. A screen must not depend on it at step 1;
/// - every other well-formed number succeeds.
///
/// Codes, at step 2 and 4 (any other 6-character code is a correct one):
/// - `999999` -> `400 otp_invalid` (the same wrong-code value the sign-in
///   mock uses);
/// - `888888` -> `400 otp_expired`;
/// - `777777` -> `429 otp_throttled`;
/// - `222222` -> `403 account_banned` (the same banned value the sign-in mock
///   uses);
/// - not exactly 6 characters -> `400 validation_failed` on `code`. **Not
///   documented** for `verifyParentOtp` (its 400 is `otp_invalid` /
///   `otp_expired` only) nor for `confirmRecovery`'s `code` (its
///   `validation_failed` is for a malformed `device`); the mock answers the
///   registry's generic code for the schema's 6-character rule. A screen must
///   not depend on it.
///
/// ### Strict where the server is strict
/// - a recovery id or rebind token this mock did not issue - or one already
///   used up - is `401 registration_token_invalid`;
/// - the rebind token is spent by a successful `confirm`, so it cannot be
///   replayed;
/// - `confirm` requires a `device` with `deviceId` and `platform`, else `400
///   validation_failed` on `device` (documented for `confirmRecovery`).
///
/// The mock does not model a lock after repeated wrong codes: the pinned
/// contract states no duration for the recovery ladder, so `throttled` is
/// reachable only through the magic values above, and never carries one.
///
/// State is per [MockRecoveryLadder] instance: one mock session (one
/// `buildMockDio`) keeps its issued ids, a fresh session starts clean.
library;

/// What the mock answers, mapped by the interceptor onto its own `_ok`,
/// `_validationFailed` and `_problem` helpers.
sealed class MockRecoveryReply {
  const MockRecoveryReply();
}

/// A success: [status] (`200` or `202`) and the JSON body.
final class MockRecoveryOk extends MockRecoveryReply {
  const MockRecoveryOk(this.status, this.data);

  final int status;
  final Map<String, Object?> data;
}

/// `400 validation_failed` carrying the contract's `field -> [messages]` map.
final class MockRecoveryValidation extends MockRecoveryReply {
  const MockRecoveryValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// Any other ProblemDetails: `404 recovery_unavailable`, `400 otp_invalid` /
/// `otp_expired`, `401 registration_token_invalid`, `403 account_banned`,
/// `409 phone_already_registered`, `429 otp_throttled`.
final class MockRecoveryProblem extends MockRecoveryReply {
  const MockRecoveryProblem(this.status, this.code, this.detail);

  final int status;
  final String code;
  final String detail;
}

/// `confirmRecovery` succeeded: the interceptor answers `200` with an
/// `AuthenticatedResult` for a student whose phone is now [phone].
final class MockRecoveryAuthenticated extends MockRecoveryReply {
  const MockRecoveryAuthenticated(this.phone);

  final String phone;
}

/// Step 1 with this phone -> `404 recovery_unavailable`.
const kMockRecoveryUnknownPhone = '+2010000000404';

/// Step 1 or step 3 with this phone -> `429 otp_throttled`.
const kMockRecoveryThrottledPhone = '+2010000000429';

/// Step 3 with this phone -> `409 phone_already_registered`.
const kMockRecoveryTakenPhone = '+2010000000409';

/// The masked parent number the mock serves. The contract's own example
/// (`openapi.yaml:497`), bullet characters included.
const kMockParentPhoneMasked = '•••• ••• 1234';

/// The wrong-code value (`400 otp_invalid`), shared with the sign-in mock.
const kMockRecoveryInvalidCode = '999999';

/// `400 otp_expired`.
const kMockRecoveryExpiredCode = '888888';

/// `429 otp_throttled`.
const kMockRecoveryThrottledCode = '777777';

/// `403 account_banned`, shared with the sign-in mock.
const kMockRecoveryBannedCode = '222222';

/// One mock session's recovery attempts. See the file header.
class MockRecoveryLadder {
  /// Recovery ids issued by step 1 and not yet verified, by id -> the OLD phone.
  final _recoveries = <String, String>{};

  /// Rebind tokens issued by step 2 and not yet spent, by token.
  final _rebinds = <String, _Rebind>{};

  var _issued = 0;

  static final _e164 = RegExp(r'^\+[1-9][0-9]{7,14}$');

  static const _start = '/auth/recovery/start';
  static const _verifyParent = '/auth/recovery/verify-parent';
  static const _newPhone = '/auth/recovery/new-phone';
  static const _confirm = '/auth/recovery/confirm';

  /// The reply for a recovery route, or `null` when [method] + [path] is not
  /// one (so the interceptor keeps looking). [body] is the decoded JSON request
  /// body (empty when there is none).
  MockRecoveryReply? handle(
    String method,
    String path,
    Map<String, dynamic> body,
  ) {
    if (method != 'POST') return null;
    return switch (path) {
      _start => _startRecovery(body),
      _verifyParent => _verifyParentOtp(body),
      _newPhone => _submitNewPhone(body),
      _confirm => _confirmRecovery(body),
      _ => null,
    };
  }

  MockRecoveryReply _startRecovery(Map<String, dynamic> body) {
    final phone = body['phone'];
    if (phone is! String || !_e164.hasMatch(phone)) {
      // Generic registry code: `startRecovery` documents no 400 (see the header).
      return const MockRecoveryValidation({
        'phone': ['Must be an E.164 phone number.'],
      });
    }
    if (phone == kMockRecoveryUnknownPhone) {
      return const MockRecoveryProblem(
        404,
        'recovery_unavailable',
        'No recoverable account for this phone.',
      );
    }
    if (phone == kMockRecoveryThrottledPhone) return _throttled();

    final recoveryId = _nextId('7ec0e000');
    _recoveries[recoveryId] = phone;
    return MockRecoveryOk(200, <String, Object?>{
      'recoveryId': recoveryId,
      'parentPhoneMasked': kMockParentPhoneMasked,
      'resendAfterSeconds': 60,
      'expiresInSeconds': 300,
    });
  }

  MockRecoveryReply _verifyParentOtp(Map<String, dynamic> body) {
    final recoveryId = body['recoveryId'];
    final code = body['code'];
    if (code is! String || code.length != 6) return _badCode();
    if (recoveryId is! String || !_recoveries.containsKey(recoveryId)) {
      return _tokenInvalid();
    }
    final refused = _refusedCode(code);
    if (refused != null) return refused;

    final oldPhone = _recoveries.remove(recoveryId)!;
    final rebindToken = 'mock.rebind.token.${++_issued}';
    _rebinds[rebindToken] = _Rebind(oldPhone);
    return MockRecoveryOk(200, <String, Object?>{
      'rebindToken': rebindToken,
      'expiresInSeconds': 600,
    });
  }

  MockRecoveryReply _submitNewPhone(Map<String, dynamic> body) {
    final rebindToken = body['rebindToken'];
    final newPhone = body['newPhone'];
    if (newPhone is! String || !_e164.hasMatch(newPhone)) {
      return const MockRecoveryValidation({
        'newPhone': ['Must be an E.164 phone number.'],
      });
    }
    if (rebindToken is! String || !_rebinds.containsKey(rebindToken)) {
      return _tokenInvalid();
    }
    if (newPhone == kMockRecoveryTakenPhone) {
      return const MockRecoveryProblem(
        409,
        'phone_already_registered',
        'The phone belongs to another account.',
      );
    }
    if (newPhone == kMockRecoveryThrottledPhone) return _throttled();

    _rebinds[rebindToken]!.newPhone = newPhone;
    return const MockRecoveryOk(202, <String, Object?>{
      'resendAfterSeconds': 60,
      'expiresInSeconds': 300,
    });
  }

  MockRecoveryReply _confirmRecovery(Map<String, dynamic> body) {
    final rebindToken = body['rebindToken'];
    final code = body['code'];
    final device = body['device'];
    final deviceOk =
        device is Map &&
        device['deviceId'] is String &&
        device['platform'] is String;
    final errors = <String, List<String>>{
      if (code is! String || code.length != 6)
        'code': ['Must be exactly 6 characters.'],
      if (!deviceOk) 'device': ['Needs a deviceId and a platform.'],
    };
    if (errors.isNotEmpty) return MockRecoveryValidation(errors);
    if (rebindToken is! String || !_rebinds.containsKey(rebindToken)) {
      return _tokenInvalid();
    }
    final refused = _refusedCode(code as String);
    if (refused != null) return refused;

    final rebind = _rebinds.remove(rebindToken)!;
    // The account's phone is replaced by the new one; had step 3 been skipped
    // the mock (lenient here) keeps the old number.
    return MockRecoveryAuthenticated(rebind.newPhone ?? rebind.oldPhone);
  }

  /// The error a magic code asks for, or `null` for a correct code.
  MockRecoveryReply? _refusedCode(String code) => switch (code) {
    kMockRecoveryInvalidCode => const MockRecoveryProblem(
      400,
      'otp_invalid',
      'The code is incorrect.',
    ),
    kMockRecoveryExpiredCode => const MockRecoveryProblem(
      400,
      'otp_expired',
      'The code has expired.',
    ),
    kMockRecoveryThrottledCode => _throttled(),
    kMockRecoveryBannedCode => const MockRecoveryProblem(
      403,
      'account_banned',
      'The account has been banned.',
    ),
    _ => null,
  };

  /// The generic `validation_failed` for the schema's 6-character rule, which
  /// neither `verifyParentOtp` nor `confirmRecovery` documents (see the header).
  MockRecoveryReply _badCode() => const MockRecoveryValidation({
    'code': ['Must be exactly 6 characters.'],
  });

  MockRecoveryReply _tokenInvalid() => const MockRecoveryProblem(
    401,
    'registration_token_invalid',
    'The token expired, was used, or is wrong. Start again.',
  );

  MockRecoveryProblem _throttled() =>
      const MockRecoveryProblem(429, 'otp_throttled', 'Too many attempts.');

  /// A UUID-shaped id with a recognisable prefix and a counter, so tests and a
  /// device walk can tell mock ids from real ones.
  String _nextId(String prefix) =>
      '$prefix-0000-4000-8000-${(++_issued).toRadixString(16).padLeft(12, '0')}';
}

/// A spent-once rebind token's memory: the number the recovery started from and,
/// once step 3 has run, the number it moves to.
class _Rebind {
  _Rebind(this.oldPhone);

  final String oldPhone;
  String? newPhone;
}
