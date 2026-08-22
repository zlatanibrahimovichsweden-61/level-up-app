import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/exceptions.dart';
import '../../../core/providers/core_providers.dart';
import '../../auth/models/device_info.dart';
import '../../auth/notifier/auth_controller.dart';
import '../../auth/repository/device_info_provider.dart';
import '../models/registration_body.dart';
import '../models/registration_draft.dart';
import '../models/registration_validation.dart';
import '../models/school_registration.dart';
import '../models/university_registration.dart';
import '../repository/registration_repository.dart';
import 'registration_controller.dart';

/// Emitted once `POST /auth/register` returns 201 AND the session has been
/// established (tokens written, `AuthController` flipped). The screen navigates
/// on it — navigation stays in the widget layer, never in the notifier.
@immutable
class RegistrationSubmitted {
  const RegistrationSubmitted();
}

/// The final step of the registration wizard.
///
/// `AsyncValue` carries the whole story, so there are no parallel booleans:
/// - `AsyncData(null)`                    → idle, nothing submitted yet
/// - `AsyncLoading`                       → in flight (button shows a spinner)
/// - `AsyncData(RegistrationSubmitted())` → 201, session live → go /home
/// - `AsyncError(...)`                    → the screen maps the exception:
///     · [DraftValidationFailure]  → inline per-field errors, request NOT sent
///     · [ValidationException]     → 400, inline per-field errors from the
///                                   server's field map (this is also how a
///                                   geography-conditionality violation lands)
///     · [UnauthorizedException] `registration_token_invalid` → restart /login
///     · [ApiException] 409 `phone_already_registered`        → restart /login
///     · [NetworkException]/[OfflineException]                → offline view
///
/// This is an [AsyncNotifier] rather than fetch-on-build because it is a
/// command: `build` seeds idle and does no work.
class RegistrationSubmitNotifier extends AsyncNotifier<RegistrationSubmitted?> {
  @override
  FutureOr<RegistrationSubmitted?> build() => null;

  /// Builds the discriminated body from the draft and posts it.
  ///
  /// Success side-effects mirror the OTP `authenticated` fork exactly: tokens to
  /// secure storage FIRST, then `markAuthenticated()` so the router's guard
  /// authorizes `/home` before the screen navigates.
  Future<void> submit() async {
    if (state.isLoading) return; // no double-submit

    final draft = ref.read(registrationControllerProvider);

    // No draft, or the 10-minute window elapsed while the form was being filled:
    // the token is already dead, so this is the same restart the server would
    // force with `registration_token_invalid`. Don't spend a round-trip on it.
    if (draft == null || draft.isExpired) {
      state = AsyncError(
        const UnauthorizedException(code: 'registration_token_invalid'),
        StackTrace.current,
      );
      return;
    }

    // Client pre-flight (adr-010 conditionality included). The server remains
    // authoritative — this only avoids a doomed request.
    final issues = validateDraft(draft);
    if (issues.isNotEmpty) {
      state = AsyncError(DraftValidationFailure(issues), StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Contract 2.0.0-m1 made `device` required on both register bodies. It is
      // the SAME DeviceInfo that `/auth/otp/verify` sent — same provider, same
      // SecureStorage `deviceId` — because the `registrationToken` is bound to
      // that device and a mismatch answers `registration_token_invalid`.
      //
      // Resolved inside the guard so a failure to read it surfaces through the
      // existing AsyncError path rather than as an unhandled exception.
      final device = await ref.read(deviceInfoProvider.future);

      final result = await ref
          .read(registrationRepositoryProvider)
          .register(_body(draft, device));

      await ref
          .read(secureStorageProvider)
          .writeTokens(
            access: result.tokens.accessToken,
            refresh: result.tokens.refreshToken,
          );
      // Flip the single source of auth truth; the router reacts, the screen
      // navigates.
      ref.read(authControllerProvider.notifier).markAuthenticated();

      return const RegistrationSubmitted();
    });
  }

  /// Back to idle — used when the student edits a field after a failure, so the
  /// stale error stops rendering.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }

  /// The `track` discriminator picks the body shape.
  RegistrationBody _body(RegistrationDraft draft, DeviceInfo device) =>
      switch (draft.track) {
        RegTrack.school => SchoolRegistration.fromDraft(draft, device: device),
        RegTrack.university => UniversityRegistration.fromDraft(
          draft,
          device: device,
        ),
        // Unreachable: validateDraft above rejects a null track.
        null => throw IncompleteRegistrationDraft('track'),
      };
}

final registrationSubmitProvider =
    AsyncNotifierProvider<RegistrationSubmitNotifier, RegistrationSubmitted?>(
      RegistrationSubmitNotifier.new,
    );
