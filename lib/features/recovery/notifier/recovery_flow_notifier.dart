import 'package:flutter/foundation.dart' show immutable, visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/notifier/auth_controller.dart';
import '../../auth/repository/device_info_provider.dart';
import '../recovery_errors.dart';
import '../repository/recovery_repository.dart';

/// Where the lost-phone recovery ladder is waiting. One stage per input the
/// student owes, in the order the contract fixes
/// (`contract/openapi.yaml:462-629`).
enum RecoveryStage {
  /// Waiting for the OLD registered phone (`startRecovery`).
  phone,

  /// The parent's phone was sent a code; waiting for it (`verifyParentOtp`).
  parentCode,

  /// Guardianship is proven; waiting for the NEW phone (`submitNewPhone`).
  newPhone,

  /// The new phone was sent a code; waiting for it (`confirmRecovery`).
  newPhoneCode,

  /// Recovered: the fresh session is stored and the router's auth state is
  /// flipped. Terminal.
  completed,

  /// `403 account_banned`. Terminal: do not retry, route to Support. Nothing
  /// further is ever sent.
  banned,
}

/// What the recovery screens read. **Deliberately small.** It holds the one
/// piece of the flow a screen must show - the masked parent phone - and what
/// it needs to drive the step: the stage, a busy flag, the last failure, and
/// the timing of the code the stage waits for. The recovery id and the rebind
/// token are NOT here: they are credentials for the next call, kept private in
/// the notifier and nowhere a screen, a log line or a dev tool can print them.
///
/// [toString] says nothing but the stage, because the masked number is a
/// guardian's phone.
@immutable
class RecoveryFlowState {
  const RecoveryFlowState({
    this.stage = RecoveryStage.phone,
    this.isBusy = false,
    this.error,
    this.parentPhoneMasked,
    this.codeResendAfterSeconds,
    this.codeExpiresInSeconds,
  });

  final RecoveryStage stage;

  /// A call is in flight; further input is ignored until it settles.
  final bool isBusy;

  /// The last failure, an [AppException], or `null`. The screen maps it to
  /// copy; [failure] says what it means.
  final Object? error;

  /// The parent's number as the server masked it, shown character for
  /// character. Held from `startRecovery` until the parent's code is verified.
  final String? parentPhoneMasked;

  /// Seconds until the code the current [stage] waits for may be requested
  /// again, as the server said. No timer runs here: a screen that wants a
  /// countdown owns it.
  final int? codeResendAfterSeconds;

  /// Seconds the code the current [stage] waits for stays valid.
  final int? codeExpiresInSeconds;

  /// What [error] means, or `null` when there is none.
  RecoveryFailure? get failure =>
      error == null ? null : classifyRecoveryFailure(error);

  RecoveryFlowState copyWith({
    RecoveryStage? stage,
    bool? isBusy,
    Object? error,
    bool clearError = false,
    String? parentPhoneMasked,
    bool clearParentPhone = false,
    int? codeResendAfterSeconds,
    int? codeExpiresInSeconds,
    bool clearCodeTiming = false,
  }) {
    return RecoveryFlowState(
      stage: stage ?? this.stage,
      isBusy: isBusy ?? this.isBusy,
      error: clearError ? null : (error ?? this.error),
      parentPhoneMasked: clearParentPhone
          ? null
          : (parentPhoneMasked ?? this.parentPhoneMasked),
      codeResendAfterSeconds: clearCodeTiming
          ? null
          : (codeResendAfterSeconds ?? this.codeResendAfterSeconds),
      codeExpiresInSeconds: clearCodeTiming
          ? null
          : (codeExpiresInSeconds ?? this.codeExpiresInSeconds),
    );
  }

  @override
  String toString() => 'RecoveryFlowState(stage: ${stage.name})';
}

/// Drives the four-step lost-phone recovery (adr-019's primary path) over
/// [RecoveryRepository]. State and decisions only: **no screen, no route, no
/// copy, no timer.**
///
/// ### What it holds, and for how long
/// The recovery id and the rebind token live in private fields; the masked
/// parent phone lives in [RecoveryFlowState]. All three are a minor's or a
/// guardian's data or a credential, so the provider is `autoDispose`: leaving
/// the flow drops the last listener, the notifier is disposed, and nothing of
/// it survives to the next visit - or to the next student on a shared device.
/// It is never persisted and never logged.
///
/// ### The contract's rules, as they land here
/// - `401 registration_token_invalid` (steps 2-4): the recovery id or rebind
///   token is dead. Everything that named the attempt is dropped and the flow
///   is back at [RecoveryStage.phone], with the failure kept so the screen can
///   say why. No refresh, no sign-out: that code is not `authentication_required`.
/// - `403 account_banned` (steps 2 and 4): [RecoveryStage.banned], terminal.
///   Nothing is retried and no tokens exist to store. The contract says only
///   that no session was issued on these two arms, so nothing here assumes the
///   code was or was not consumed.
/// - `404 recovery_unavailable` (step 1): the stage stays; the failure is
///   [RecoveryFailure.unavailable] for the support path, which is not built.
/// - `429 otp_throttled` and every other failure: the stage stays and the
///   failure is kept. **No lock duration is read or assumed.**
/// - A second call while one is in flight, or from the wrong stage, is
///   ignored: the ladder is strictly ordered and nothing here sends a step the
///   flow is not at.
///
/// ### Signing in
/// `confirm` is a sign-in, so it does what `OtpNotifier.verify` does and in the
/// same order: store the tokens, then `markAuthenticated(studentId:)` so the
/// router's return target follows the live session (O-10), then update state.
/// The first two survive the screen being popped mid-call; only the state
/// assignment is skipped once the notifier is gone.
class RecoveryFlowNotifier extends Notifier<RecoveryFlowState> {
  /// True once this notifier has been disposed. The provider is `autoDispose`,
  /// so leaving the flow while a call is in flight disposes the notifier
  /// mid-`await`, and the continuation would assign to `state` on a dead
  /// notifier. Same mechanism, and same reason, as `OtpNotifier`.
  bool _disposed = false;

  /// Names the attempt in `verifyParentOtp`. Set by step 1, dropped at step 2.
  String? _recoveryId;

  /// Authorises steps 3 and 4. Set by step 2, dropped when the flow ends.
  String? _rebindToken;

  @override
  RecoveryFlowState build() {
    ref.onDispose(() {
      _disposed = true;
      _forgetCredentials();
    });
    return const RecoveryFlowState();
  }

  /// Step 1 - sends the parent's phone a code for the account registered under
  /// [phoneE164] (the OLD number). Callable again from
  /// [RecoveryStage.parentCode] to ask for a fresh code: the recovery id is
  /// then replaced.
  Future<void> start(String phoneE164) async {
    if (state.isBusy) return;
    if (state.stage != RecoveryStage.phone &&
        state.stage != RecoveryStage.parentCode) {
      return;
    }
    final repository = ref.read(recoveryRepositoryProvider);
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final result = await repository.startRecovery(phoneE164);
      if (_disposed) return;
      _recoveryId = result.recoveryId;
      state = state.copyWith(
        stage: RecoveryStage.parentCode,
        isBusy: false,
        parentPhoneMasked: result.parentPhoneMasked,
        codeResendAfterSeconds: result.resendAfterSeconds,
        codeExpiresInSeconds: result.expiresInSeconds,
      );
    } on AppException catch (e) {
      _fail(e);
    } catch (_) {
      _fail(const UnknownException());
    }
  }

  /// Step 2 - verifies the code the parent was sent. On success the rebind
  /// token is kept for steps 3 and 4 and the flow asks for the new phone.
  Future<void> verifyParent(String code) async {
    if (state.isBusy || state.stage != RecoveryStage.parentCode) return;
    final recoveryId = _recoveryId;
    if (recoveryId == null) return;
    final repository = ref.read(recoveryRepositoryProvider);
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final result = await repository.verifyParentOtp(
        recoveryId: recoveryId,
        code: code,
      );
      if (_disposed) return;
      _recoveryId = null;
      _rebindToken = result.rebindToken;
      state = state.copyWith(
        stage: RecoveryStage.newPhone,
        isBusy: false,
        clearParentPhone: true,
        clearCodeTiming: true,
      );
    } on AppException catch (e) {
      _fail(e);
    } catch (_) {
      _fail(const UnknownException());
    }
  }

  /// Step 3 - sends the NEW phone ([newPhoneE164]) a code. Callable again from
  /// [RecoveryStage.newPhoneCode] to ask for a fresh code, or to correct a
  /// mistyped number.
  Future<void> submitNewPhone(String newPhoneE164) async {
    if (state.isBusy) return;
    if (state.stage != RecoveryStage.newPhone &&
        state.stage != RecoveryStage.newPhoneCode) {
      return;
    }
    final rebindToken = _rebindToken;
    if (rebindToken == null) return;
    final repository = ref.read(recoveryRepositoryProvider);
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final result = await repository.submitNewPhone(
        rebindToken: rebindToken,
        newPhone: newPhoneE164,
      );
      if (_disposed) return;
      state = state.copyWith(
        stage: RecoveryStage.newPhoneCode,
        isBusy: false,
        codeResendAfterSeconds: result.resendAfterSeconds,
        codeExpiresInSeconds: result.expiresInSeconds,
      );
    } on AppException catch (e) {
      _fail(e);
    } catch (_) {
      _fail(const UnknownException());
    }
  }

  /// Step 4 - verifies the code the new phone was sent. On success the account
  /// is rebound to the new phone and THIS device, any previous session is
  /// revoked server-side, and the fresh session is stored: the student is
  /// signed in.
  Future<void> confirm(String code) async {
    if (state.isBusy || state.stage != RecoveryStage.newPhoneCode) return;
    final rebindToken = _rebindToken;
    if (rebindToken == null) return;
    // Captured BEFORE the first await, like `OtpNotifier.verify`: the provider
    // is autoDispose, `Ref.read` on a disposed ref throws, and a slow network
    // plus leaving the screen must not leave a rebound account with no tokens
    // written. The device future is read synchronously for the same reason.
    final repository = ref.read(recoveryRepositoryProvider);
    final storage = ref.read(secureStorageProvider);
    final auth = ref.read(authControllerProvider.notifier);
    final deviceFuture = ref.read(deviceInfoProvider.future);
    state = state.copyWith(isBusy: true, clearError: true);
    try {
      final device = await deviceFuture;
      final result = await repository.confirmRecovery(
        rebindToken: rebindToken,
        code: code,
        device: device,
      );
      await storage.writeTokens(
        access: result.tokens.accessToken,
        refresh: result.tokens.refreshToken,
      );
      // Flips the single source of auth truth. Placed after the tokens exist
      // and BEFORE the disposal check: both must survive the screen going
      // away, or the student ends up rebound but not signed in.
      auth.markAuthenticated(studentId: _studentIdOf(result.profile));
      if (_disposed) return;
      _forgetCredentials();
      state = const RecoveryFlowState(stage: RecoveryStage.completed);
    } on AppException catch (e) {
      _fail(e);
    } catch (_) {
      _fail(const UnknownException());
    }
  }

  /// Back to the start: forgets the recovery id, the rebind token and the
  /// masked phone. For a student who backs out of the ladder and begins again.
  /// A banned flow stays banned, and a call in flight is left to settle.
  void reset() {
    if (state.isBusy || state.stage == RecoveryStage.banned) return;
    _forgetCredentials();
    state = const RecoveryFlowState();
  }

  /// Whether the recovery id or the rebind token is held right now. Exists so
  /// a test can prove the rule "forgotten the moment the attempt ends" - the
  /// stage guards would otherwise hide a credential that was kept by mistake.
  /// Nothing else reads it.
  @visibleForTesting
  bool get holdsCredentials => _recoveryId != null || _rebindToken != null;

  void _forgetCredentials() {
    _recoveryId = null;
    _rebindToken = null;
  }

  /// Settles a failed call. [RecoveryFailure.banned] and
  /// [RecoveryFailure.restartRequired] end the attempt; everything else leaves
  /// the stage where it was so the student can try again.
  void _fail(Object error) {
    if (_disposed) return;
    switch (classifyRecoveryFailure(error)) {
      case RecoveryFailure.banned:
        _forgetCredentials();
        state = RecoveryFlowState(stage: RecoveryStage.banned, error: error);
      case RecoveryFailure.restartRequired:
        _forgetCredentials();
        state = RecoveryFlowState(error: error);
      case RecoveryFailure.unavailable ||
          RecoveryFailure.otpInvalid ||
          RecoveryFailure.otpExpired ||
          RecoveryFailure.throttled ||
          RecoveryFailure.phoneAlreadyRegistered ||
          RecoveryFailure.validation ||
          RecoveryFailure.offline ||
          RecoveryFailure.other:
        state = state.copyWith(isBusy: false, error: error);
    }
  }
}

/// The server id of the student who just signed in, from the opaque `profile`
/// of an `authenticated` response - the contract's required `StudentProfile.id`
/// - or `null` when it is absent or not a non-empty string. It exists only so
/// the router's return target can be matched to the student whose session
/// ended; nothing else in the profile is read, and the id is never logged.
///
/// Mirrors the private helper in `OtpNotifier`, which cannot be shared without
/// editing it.
String? _studentIdOf(Map<String, dynamic> profile) {
  final id = profile['id'];
  return id is String && id.isNotEmpty ? id : null;
}

/// The lost-phone recovery flow's state. **`autoDispose` is required, not
/// tidy:** the flow holds a recovery id, a rebind token and a guardian's
/// masked phone, and none of it may outlive the screens that use it.
final recoveryFlowProvider =
    NotifierProvider.autoDispose<RecoveryFlowNotifier, RecoveryFlowState>(
      RecoveryFlowNotifier.new,
    );
