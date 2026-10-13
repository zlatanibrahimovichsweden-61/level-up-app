import 'package:freezed_annotation/freezed_annotation.dart';

import 'token_pair.dart';

part 'auth_result.freezed.dart';
part 'auth_result.g.dart';

/// The `200` body of `POST /auth/otp/verify` — a discriminated union on the
/// contract's `result` field:
///   result == "authenticated"        -> AuthenticatedResult (tokens + profile)
///   result == "registrationRequired" -> RegistrationRequiredResult (reg token)
///
/// `unionKey: 'result'` + `FreezedUnionCase.none` makes json_serializable read
/// the `result` value verbatim, so the union values are exactly `authenticated`
/// / `registrationRequired`, matching the contract's discriminator mapping.
///
/// SCOPE NOTE: `AuthenticatedResult.profile` is carried as opaque JSON on
/// purpose. These two screens only store tokens and land the student on the
/// remembered location (the same student only) or `/home`; the one
/// thing read from the profile is `profile['id']` (the contract's required
/// `StudentProfile.id`), to match the router's return target to the student who
/// signed in — nothing else in it is read here. The full freezed
/// `StudentProfile` model (avatar, geography, points, entitlements, …) is a
/// large contract type that lives in the profile feature, read from `GET /me` —
/// modeling it here would be out of this two-screen scope. Keeping it as
/// `Map<String,dynamic>` invents nothing and parses faithfully.
@Freezed(unionKey: 'result', unionValueCase: FreezedUnionCase.none)
sealed class AuthResult with _$AuthResult {
  const factory AuthResult.authenticated({
    required TokenPair tokens,
    required Map<String, dynamic> profile,
  }) = AuthenticatedResult;

  const factory AuthResult.registrationRequired({
    required String registrationToken,
    required int expiresInSeconds,
  }) = RegistrationRequiredResult;

  factory AuthResult.fromJson(Map<String, dynamic> json) =>
      _$AuthResultFromJson(json);
}
