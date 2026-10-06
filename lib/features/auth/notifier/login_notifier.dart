import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/otp_request_result.dart';
import '../repository/auth_repository.dart';

/// Drives the Login submit. State is the request outcome (or null = idle):
///   loading  -> Send OTP button spinner
///   error    -> inline message (offline vs mapped code) under the field
///   data!=null -> caller navigates to /otp carrying the timing params
///
/// The phone is validated in the screen's form BEFORE this is called, so a
/// malformed phone never reaches the network. Retry is user-tapped (tapping
/// Send again) — never a silent auto-retry.
class LoginNotifier extends AsyncNotifier<OtpRequestResult?> {
  @override
  Future<OtpRequestResult?> build() async => null;

  /// [phoneE164] must already be normalized/validated E.164. Returns the result
  /// on success (so the screen can navigate), or null on failure (state holds
  /// the error).
  Future<OtpRequestResult?> sendOtp(String phoneE164) async {
    state = const AsyncLoading<OtpRequestResult?>();
    final guarded = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).requestOtp(phoneE164),
    );
    state = guarded;
    // guard() only yields data or error (never loading); asData is null on error.
    return guarded.asData?.value;
  }
}

final loginProvider = AsyncNotifierProvider<LoginNotifier, OtpRequestResult?>(
  LoginNotifier.new,
  // Its build never fetches; the rule is uniform (project_rules_test).
  retry: (_, _) => null,
);
