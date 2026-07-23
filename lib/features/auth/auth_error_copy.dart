import '../../core/network/exceptions.dart';
import '../../l10n/app_localizations.dart';

/// The ONE place that maps an auth [AppException] to localized user copy.
/// Server `title`/`detail` are developer-facing English and never shown — we map
/// the stable `code` (error-codes.md) to an AR/EN string instead.
///
/// Connectivity failures are handled by the caller as the Offline state, so this
/// only needs the API + unknown codes; it still falls back safely for them.
String authErrorMessage(AppLocalizations l10n, Object? error) {
  if (isOffline(error)) return l10n.offline;
  if (error is ApiException) {
    switch (error.code) {
      case 'otp_invalid':
        return l10n.errorOtpInvalid;
      case 'otp_expired':
        return l10n.errorOtpExpired;
      case 'otp_throttled':
        return l10n.errorOtpThrottled;
      case 'validation_failed':
        return l10n.errorValidationFailed;
    }
  }
  return l10n.genericError;
}

/// Connectivity failure → drives the Offline view, not a generic error. The
/// ErrorInterceptor maps timeouts/connection errors to [NetworkException];
/// [OfflineException] is the explicit no-connectivity signal.
bool isOffline(Object? error) =>
    error is OfflineException || error is NetworkException;

/// `otp_invalid` specifically drives the red/pink OTP-box error styling
/// (Figma error components 82:1170 / 337:19271).
bool isInvalidOtp(Object? error) =>
    error is ApiException && error.code == 'otp_invalid';
