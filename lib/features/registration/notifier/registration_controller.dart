import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/registration_args.dart';
import '../models/registration_draft.dart';

/// The registration spine. Holds the [RegistrationDraft] accumulated across the
/// wizard (identity → track → Day-3 field screens) plus the token deadline.
///
/// State is nullable: `null` = no registration in progress. It is seeded from
/// the OTP `registrationRequired` fork via [start] and mutated step by step;
/// Day 3 adds the geography/academic setters and the final `POST /auth/register`.
///
/// This is sync, mixed state (not fetch-on-build), so a plain [Notifier] — not
/// an AsyncNotifier — is the right tool.
class RegistrationController extends Notifier<RegistrationDraft?> {
  @override
  RegistrationDraft? build() => null;

  /// Seed a fresh draft from the OTP step. Idempotent on re-entry: if a draft
  /// for the SAME token already exists (e.g. navigating back to the identity
  /// screen), the accumulated fields are preserved rather than reset. A new
  /// token (a fresh OTP verify) starts a clean draft.
  void start(RegistrationArgs args) {
    final current = state;
    if (current != null &&
        current.registrationToken == args.registrationToken) {
      return;
    }
    state = RegistrationDraft(
      registrationToken: args.registrationToken,
      tokenExpiresAt:
          DateTime.now().add(Duration(seconds: args.expiresInSeconds)),
      phone: args.phone,
    );
  }

  /// Sign Up_1 → store identity. `referralCode` is collected but never submitted
  /// (conflict #1). No-op if there is no active draft.
  void setIdentity({
    required String name,
    required String parentPhone,
    String? referralCode,
  }) {
    final draft = state;
    if (draft == null) return;
    state = draft.copyWith(
      name: name,
      parentPhone: parentPhone,
      referralCode: referralCode,
    );
  }

  /// Sign Up_2 → set the track discriminator. No-op if there is no active draft.
  void setTrack(RegTrack track) {
    final draft = state;
    if (draft == null) return;
    state = draft.copyWith(track: track);
  }

  /// Abandon the registration (e.g. token expired, or user backs out to login).
  void reset() => state = null;
}

final registrationControllerProvider =
    NotifierProvider<RegistrationController, RegistrationDraft?>(
  RegistrationController.new,
);
