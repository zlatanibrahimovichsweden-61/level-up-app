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

  /// Set once verify succeeds; the screen navigates on it.
  final AuthOutcome? outcome;

  bool get canResend => secondsRemaining <= 0;

  OtpUiState copyWith({
    int? secondsRemaining,
    bool? isVerifying,
    bool? isResending,
    Object? error,
    bool clearError = false,
    bool? isInvalidCode,
    AuthOutcome? outcome,
  }) {
    return OtpUiState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isVerifying: isVerifying ?? this.isVerifying,
      isResending: isResending ?? this.isResending,
      error: clearError ? null : (error ?? this.error),
      isInvalidCode: isInvalidCode ?? this.isInvalidCode,
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
    state = state.copyWith(
      isVerifying: true,
      clearError: true,
      isInvalidCode: false,
    );
    try {
      final device = await ref.read(deviceInfoProvider.future);
      final result = await ref
          .read(authRepositoryProvider)
          .verifyOtp(phone: args.phone, code: code, device: device);
      switch (result) {
        case AuthenticatedResult(:final tokens):
          await ref
              .read(secureStorageProvider)
              .writeTokens(
                access: tokens.accessToken,
                refresh: tokens.refreshToken,
              );
          // Flip the single source of auth truth so the router guard authorizes
          // /home (the screen still shows the success view + Continue first).
          ref.read(authControllerProvider.notifier).markAuthenticated();
          // The guard goes HERE, not around the await block. The tokens are
          // already written and auth is already flipped — those side effects
          // must survive the screen being popped, or the student ends up
          // authenticated-but-not-routed. Only the UI state assignment is
          // unsafe once this notifier is gone.
          if (_disposed) return;
          state = state.copyWith(
            isVerifying: false,
            outcome: const AuthenticatedOutcome(),
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
    if (!state.canResend || state.isResending) return;
    state = state.copyWith(
      isResending: true,
      clearError: true,
      isInvalidCode: false,
    );
    try {
      final res = await ref.read(authRepositoryProvider).requestOtp(args.phone);
      // Returning early also skips _scheduleTicks(), which is correct: a timer
      // started on a disposed notifier would tick into a dead state setter.
      if (_disposed) return;
      state = state.copyWith(
        isResending: false,
        secondsRemaining: res.resendAfterSeconds,
      );
      if (res.resendAfterSeconds > 0) _scheduleTicks();
    } on AppException catch (e) {
      if (_disposed) return;
      state = state.copyWith(isResending: false, error: e);
    } catch (_) {
      if (_disposed) return;
      state = state.copyWith(
        isResending: false,
        error: const UnknownException(),
      );
    }
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

final otpProvider = NotifierProvider.autoDispose
    .family<OtpNotifier, OtpUiState, OtpArgs>(OtpNotifier.new);
