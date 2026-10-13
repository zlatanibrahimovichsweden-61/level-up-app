import '../../core/network/exceptions.dart';

/// The Terms-acceptance error codes, as predicates. No copy lives here: the
/// words the student reads are a screen's, through `AppLocalizations`, and the
/// gate shape (block or nudge) is an owner decision that has not been made.

/// `403 terms_acceptance_required` — the caller has not accepted the current
/// Terms, and the operation needs it (`contract/error-codes.md:67`).
///
/// **Which operations answer it** is not a property of the Terms feature, so
/// this is a predicate and not a per-screen branch: the support photo
/// operations (`createSupportAttachmentUpload`, and `createSupportTicket` /
/// `postMySupportTicketMessage` when they carry `attachmentIds`) and the
/// avatar upload. **Text tickets and replies are never gated.** It is inert
/// while no Terms version is published, so a student cannot be refused for
/// something that cannot be accepted.
///
/// It is not an authorization failure and not an account state: read the
/// `code` — it is distinct from `insufficient_scope` and from
/// `account_pending_deletion` (`isAccountPendingDeletion`), the other 403s the
/// same routes answer. The contract's client rule is to offer the Terms screen,
/// or to send without photos.
///
/// Matches on `code`, like [isAccountPendingDeletion], so a plain
/// `ApiException` (what `ErrorInterceptor` builds) is recognised.
bool isTermsAcceptanceRequired(Object? error) =>
    error is ApiException && error.code == 'terms_acceptance_required';

/// `400 validation_failed` carrying a field error on `termsVersion` — the
/// answer to `acceptTerms` when the version sent is absent, empty, not a
/// string, or not the currently required one (including when none is
/// configured).
///
/// The response never states the required version, so the only recovery is to
/// re-read `getTermsAcceptance`: if `currentVersion` is now `null` there is
/// nothing to accept, and otherwise the student is asked about the version
/// just served.
bool isTermsVersionRejected(Object? error) =>
    error is ValidationException && error.fields.contains('termsVersion');
