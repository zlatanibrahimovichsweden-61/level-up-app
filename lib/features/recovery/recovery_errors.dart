import '../../core/network/exceptions.dart';
import '../auth/auth_error_copy.dart' show isInvalidOtp;

/// What the lost-phone recovery ladder's failures MEAN, as data. No copy lives
/// here: the words the student reads (and the guardian wording for minors, and
/// the support path `recovery_unavailable` leads to) are a screen's and an
/// owner's, none of which exists yet.
///
/// The codes are the ones the four operations document
/// (`contract/openapi.yaml:462-629`, `contract/error-codes.md`); a code the
/// ladder does not document is [RecoveryFailure.other], never guessed at.

/// The documented failures of the four recovery operations, by what the
/// caller must do about them.
enum RecoveryFailure {
  /// `404 recovery_unavailable` (`startRecovery`): no recoverable account or
  /// parent number for this phone. ONE code for both causes, on purpose
  /// (anti-enumeration), so the app cannot say which. The contract's rule: the
  /// app routes to the support path.
  unavailable,

  /// `400 otp_invalid` (`verifyParentOtp`, `confirmRecovery`): a wrong code.
  otpInvalid,

  /// `400 otp_expired` (`verifyParentOtp`, `confirmRecovery`): the code's window
  /// has elapsed.
  otpExpired,

  /// `429 otp_throttled` (all four): too many attempts. **The ladder documents
  /// no lock duration**, so none is carried or implied; the screen's wording
  /// must not name one either.
  throttled,

  /// `401 registration_token_invalid` (`verifyParentOtp`, `submitNewPhone`,
  /// `confirmRecovery`): the recovery id or rebind token expired, was consumed
  /// or is wrong. The flow restarts from the top.
  restartRequired,

  /// `409 phone_already_registered` (`submitNewPhone`): the NEW number belongs
  /// to another account. The student may try another number.
  phoneAlreadyRegistered,

  /// `403 account_banned` (`verifyParentOtp`, `confirmRecovery`): the code was
  /// verified, but Support banned the account; no tokens or session were
  /// issued. Do not retry; route to Support. **Nothing is assumed about the
  /// code being consumed** - the contract states that for `verifyOtp` only.
  banned,

  /// `400 validation_failed`. The contract documents it for `submitNewPhone`
  /// (`newPhone` missing or not E.164) and `confirmRecovery` (a malformed
  /// `device`) ONLY; `startRecovery` and `verifyParentOtp` document no such
  /// answer. A screen may rely on this state at steps 3 and 4, not at steps 1
  /// and 2, where it would be the registry's generic code
  /// (`contract/error-codes.md`) and is classified the same way if it arrives.
  validation,

  /// No connectivity (the Offline state), not a server answer.
  offline,

  /// Anything else: an undocumented code, `internal_error`, a body that would
  /// not parse. The generic error state.
  other,
}

/// `400 otp_expired`: the one-time code's window has elapsed. (`otp_invalid` is
/// `isInvalidOtp`, `otp_throttled` is [isOtpThrottled].)
bool isOtpExpired(Object? error) =>
    error is ApiException && error.code == 'otp_expired';

/// `429 otp_throttled`: the one-time-code rate limit was hit
/// (`contract/error-codes.md`, adr-019 flood protection).
///
/// **Carries no duration.** The pinned contract states none for the recovery
/// ladder, and nothing here assumes one - not from the sign-in ladder, not from
/// anywhere else. Distinct from `rate_limited` ([RateLimitedException]), which
/// is the `/reference/*` lookup limit.
bool isOtpThrottled(Object? error) =>
    error is ApiException && error.code == 'otp_throttled';

/// `404 recovery_unavailable`: see [RecoveryFailure.unavailable].
bool isRecoveryUnavailable(Object? error) =>
    error is ApiException && error.code == 'recovery_unavailable';

/// `401 registration_token_invalid`: see [RecoveryFailure.restartRequired].
/// The same code the registration wizard restarts on.
bool isRegistrationTokenInvalid(Object? error) =>
    error is ApiException && error.code == 'registration_token_invalid';

/// `409 phone_already_registered`: see [RecoveryFailure.phoneAlreadyRegistered].
/// The same code registration answers.
bool isPhoneAlreadyRegistered(Object? error) =>
    error is ApiException && error.code == 'phone_already_registered';

/// Which documented [RecoveryFailure] [error] is.
///
/// Connectivity is checked first and keeps its own Offline state. Everything
/// else is matched on the stable `code` (like `isAccountBanned`), so a plain
/// `ApiException` - what `ErrorInterceptor` builds - is recognised. (A
/// `ValidationException` carries the code `validation_failed` by
/// construction.)
RecoveryFailure classifyRecoveryFailure(Object? error) {
  if (isOffline(error)) return RecoveryFailure.offline;
  if (isRecoveryUnavailable(error)) return RecoveryFailure.unavailable;
  if (isInvalidOtp(error)) return RecoveryFailure.otpInvalid;
  if (isOtpExpired(error)) return RecoveryFailure.otpExpired;
  if (isOtpThrottled(error)) return RecoveryFailure.throttled;
  if (isRegistrationTokenInvalid(error)) return RecoveryFailure.restartRequired;
  if (isPhoneAlreadyRegistered(error)) {
    return RecoveryFailure.phoneAlreadyRegistered;
  }
  if (isAccountBanned(error)) return RecoveryFailure.banned;
  if (error is ApiException && error.code == 'validation_failed') {
    return RecoveryFailure.validation;
  }
  return RecoveryFailure.other;
}
