import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../auth_error_copy.dart';
import '../models/auth_outcome.dart';
import '../models/auth_result.dart';
import '../models/otp_args.dart';
import '../repository/auth_repository.dart';
import '../repository/device_info_provider.dart';
import 'auth_controller.dart';

/// Immutable UI state for the OTP screen. Multiple independent concerns —
/// the resend countdown (periodic), verify, resend, inline error styling and the
/// success fork — so this is a hand-rolled state on a [Notifier], which the
/// `river` skill prescribes for sync/mixed state (AsyncNotifier is for
/// fetch-on-build). Still Riverpod, not Bloc (Bloc is the quiz engine only).
@immutable
class OtpUiState {
  const OtpUiState({
    required this.secondsRemaining,
    this.isVerifying = false,
    this.isResending = false,
    this.error,
    this.isInvalidCode = false,
    this.isBanned = false,
    this.outcome,
  });

  /// Resend countdown; resend is enabled only at 0.
  final int secondsRemaining;
  final bool isVerifying;
  final bool isResending;

  /// The failure to surface inline. An [AppException] the screen maps to
  /// localized copy via [authErrorMessage] — copy never lives in the notifier.
  final Object? error;

  /// `otp_invalid` — drives the red/pink OTP-box error styling.
  final bool isInvalidCode;

  /// `403 account_banned` — the code was correct, the server consumed it, and no
  /// tokens or session exist (`contract/error-codes.md:51`). Terminal for this
  /// screen: the code cannot be retried and resend is locked, so the only way
  /// forward is back to login. Deliberately separate from [isInvalidCode] (no
  /// red-box styling) and from [outcome] (nothing succeeded).
  final bool isBanned;

  /// Set once verify succeeds; the screen navigates on it.
  final AuthOutcome? outcome;

  bool get canResend => !isBanned && secondsRemaining <= 0;

  OtpUiState copyWith({
    int? secondsRemaining,
    bool? isVerifying,
    bool? isResending,
    Object? error,
    bool clearError = false,
    bool? isInvalidCode,
    bool? isBanned,
    AuthOutcome? outcome,
  }) {
    return OtpUiState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      error: clearError ? null : (error ?? this.error),
      isInvalidCode: isInvalidCode ?? this.isInvalidCode,
      isBanned: isBanned ?? this.isBanned,
      outcome: outcome ?? this.outcome,
    );
  }
}

class OtpNotifier extends Notifier<OtpUiState> {
  OtpNotifier(this.args);

  final OtpArgs args;
  Timer? _timer;

  /// True once this notifier has been disposed.
  ///
  /// `otpProvider` is `autoDispose`, so popping the OTP screen while a verify
  /// or resend is in flight drops the last listener and disposes this notifier
  /// mid-`await`. The continuation then assigns to `state` on a dead notifier,
  /// which throws. Nothing catches it — it surfaces as an unhandled async error
  /// rather than a crash, which is why the suite never saw it.
  ///
  /// Tracked with a flag set from [Ref.onDispose] (already used here for the
  /// timer) rather than a `mounted` getter, so the guard depends only on API
  /// this file already proves it has.
  bool _disposed = false;

  @override
  OtpUiState build() {
    ref.onDispose(() {
      _disposed = true;
      _timer?.cancel();
    });
    if (args.resendAfterSeconds > 0) _scheduleTicks();
    return OtpUiState(secondsRemaining: args.resendAfterSeconds);
  }

  /// Verifies [code] and forks the flow. On `authenticated` the tokens are
  /// written to SecureStorage BEFORE the outcome is emitted; on
  /// `registrationRequired` no tokens exist, so only the reg token is carried.
  Future<void> verify(String code) async {
    if (state.isVerifying) return;
    // A banned account's code is already consumed and the contract says "do not
    // retry" (`contract/error-codes.md:51`), so a second call is never sent.
    if (state.isBanned) return;
    // Captured BEFORE the first await (R-2 / W3-1). `otpProvider` is
    // autoDispose: popping the OTP screen mid-verify disposes this notifier,
    // and `Ref.read` on a disposed ref throws `UnmountedRefException`
    // (riverpod 3.3.2, `ref.dart:232-240`). Read through `ref` after the
    // await, a slow network plus a Back press left the code consumed on the
    // server and no tokens written — the student signed out by their own
    // impatience. These three outlive the screen; `deviceInfoProvider.future`
    // is read synchronously below, before the await, and needs no capture.
    final repository = ref.read(authRepositoryProvider);
    final storage = ref.read(secureStorageProvider);
    final auth = ref.read(authControllerProvider.notifier);
    state = state.copyWith(
      isVerifying: true,
      clearError: true,
      isInvalidCode: false,
    );
    try {
      final device = await ref.read(deviceInfoProvider.future);
      final result = await repository.verifyOtp(
        phone: args.phone,
        code: code,
        device: device,
      );
      switch (result) {
        case AuthenticatedResult(:final tokens, :final profile):
          await storage.writeTokens(
            access: tokens.accessToken,
            refresh: tokens.refreshToken,
          );
          // The id of the student who just signed in: handed to the auth
          // controller (so a later forced sign-out can bind the return target
          // to THIS session's student without a `/me` read) and to the outcome
          // (so the landing can match the target). Null when the response
          // carried none.
          final studentId = _studentIdOf(profile);
          // Flip the single source of auth truth so the router guard authorizes
          // /home (the screen still shows the success view + Continue first).
          auth.markAuthenticated(studentId: studentId);
          // The guard goes HERE, not around the await block. The tokens are
          // already written and auth is already flipped — those side effects
          // must survive the screen being popped, or the student ends up
          // authenticated-but-not-routed. Only the UI state assignment is
          // unsafe once this notifier is gone.
          if (_disposed) return;
          state = state.copyWith(
            isVerifying: false,
            outcome: AuthenticatedOutcome(studentId: studentId),
          );
        case RegistrationRequiredResult(
          :final registrationToken,
          :final expiresInSeconds,
        ):
          if (_disposed) return;
          state = state.copyWith(
            isVerifying: false,
            outcome: RegistrationRequiredOutcome(
              registrationToken: registrationToken,
              expiresInSeconds: expiresInSeconds,
            ),
          );
      }
    } on AppException catch (e) {
      if (_disposed) return;
      if (isAccountBanned(e)) {
        // The code was correct but the account is banned: no tokens exist, so
        // nothing is written to storage and `markAuthenticated` is NOT called
        // (both live in the success arm above and are unreachable from here —
        // keep it that way). The countdown is moot, so stop it too.
        _timer?.cancel();
        state = state.copyWith(
          isVerifying: false,
          error: e,
          isBanned: true,
          isInvalidCode: false,
        );
        return;
      }
      state = state.copyWith(
        isVerifying: false,
        error: e,
        isInvalidCode: isInvalidOtp(e),
      );
    } catch (_) {
      if (_disposed) return;
      state = state.copyWith(
        isVerifying: false,
        error: const UnknownException(),
      );
    }
  }

  /// Re-requests an OTP (enabled only when the countdown hits 0) and restarts
  /// the countdown from the fresh `resendAfterSeconds`.
  Future<void> resend() async {
    // `canResend` is already false when banned; the explicit check keeps the
    // "no repository call once banned" rule readable at the call site.
    if (state.isBanned || !state.canResend || state.isResending) return;
    state = state.copyWith(
      isResending: true,
      clearError: true,
      isInvalidCode: false,
    );
    try {
      final res = await ref.read(authRepositoryProvider).requestOtp(args.phone);
      // Returning early also skips _scheduleTicks(), which is correct: a timer
      // started on a disposed notifier would tick into a dead state setter.
      if (_disposed || _settleResendIfBanned()) return;
      state = state.copyWith(
        isResending: false,
        secondsRemaining: res.resendAfterSeconds,
      );
      if (res.resendAfterSeconds > 0) _scheduleTicks();
    } on AppException catch (e) {
      if (_disposed || _settleResendIfBanned()) return;
      state = state.copyWith(isResending: false, error: e);
    } catch (_) {
      if (_disposed || _settleResendIfBanned()) return;
      state = state.copyWith(
        isResending: false,
        error: const UnknownException(),
      );
    }
  }

  /// A `verify` can answer `account_banned` while a resend is still in flight
  /// (the spinner does not disable Verify). The banned state is terminal, so
  /// the late resend answer must not restart the countdown or replace the
  /// banned error — it only clears its own spinner. Returns true when it did.
  bool _settleResendIfBanned() {
    if (!state.isBanned) return false;
    state = state.copyWith(isResending: false);
    return true;
  }

  void _scheduleTicks() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final next = state.secondsRemaining - 1;
      if (next <= 0) {
        t.cancel();
        state = state.copyWith(secondsRemaining: 0);
      } else {
        state = state.copyWith(secondsRemaining: next);
      }
    });
  }
}

/// The server id of the student who just signed in, from the opaque `profile`
/// of an `authenticated` verify response — the contract's required
/// `StudentProfile.id` — or null when it is absent or not a non-empty string.
/// It exists only so the router's return target can be matched to the student
/// whose session ended — the sign-in landing compares it, and the auth
/// controller keeps it for the session so a later forced sign-out can bind the
/// target; nothing else in the profile is read here, and the id is never logged.
String? _studentIdOf(Map<String, dynamic> profile) {
  final id = profile['id'];
  return id is String && id.isNotEmpty ? id : null;
}

final otpProvider = NotifierProvider.autoDispose
    .family<OtpNotifier, OtpUiState, OtpArgs>(OtpNotifier.new);
