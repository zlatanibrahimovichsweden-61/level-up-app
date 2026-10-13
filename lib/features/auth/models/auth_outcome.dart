/// The navigation-relevant result of a successful OTP verify, decoupled from the
/// wire model so the screen doesn't reach into tokens/profile. Tokens are stored
/// in SecureStorage by the notifier BEFORE emitting [AuthenticatedOutcome];
/// [RegistrationRequiredOutcome] carries the registrationToken (no tokens exist
/// yet) to `/register`.
library;

sealed class AuthOutcome {
  const AuthOutcome();
}

/// Verified into an existing account. Tokens are already in SecureStorage.
class AuthenticatedOutcome extends AuthOutcome {
  const AuthenticatedOutcome({this.studentId});

  /// The server id of the student who just signed in — used only to match the
  /// router's return target to the student whose session ended, never shown or
  /// stored. Null when the response carried none (the target then fails closed).
  final String? studentId;
}

/// New phone — no account yet. Carry the short-lived registrationToken (+ its
/// TTL) to `/register`; do NOT store tokens (there are none).
class RegistrationRequiredOutcome extends AuthOutcome {
  const RegistrationRequiredOutcome({
    required this.registrationToken,
    required this.expiresInSeconds,
  });

  final String registrationToken;
  final int expiresInSeconds;
}
