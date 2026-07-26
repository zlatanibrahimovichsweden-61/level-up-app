/// The `POST /auth/register` request body, discriminated on `track`.
///
/// The contract models this as `oneOf: [SchoolRegistration, UniversityRegistration]`
/// with `discriminator.propertyName: track`. The two shapes are genuinely
/// different (university has NO `countryCode` — Egypt-only by shape, adr-010),
/// so they are two independent freezed classes rather than one union; this
/// interface is what lets the repository take either.
library;

/// The discriminator values from the contract's `discriminator.mapping`.
const String kTrackSchool = 'school';
const String kTrackUniversity = 'university';

/// Implemented by both register bodies. Only `toJson` is needed — the
/// repository posts the map and never inspects the body.
abstract interface class RegistrationBody {
  /// The `track` discriminator value this body carries.
  String get track;

  Map<String, dynamic> toJson();
}

/// Thrown by the `fromDraft` factories when a contract-required field is absent
/// from the draft. This is a PROGRAMMING error, not a user-facing one: the
/// screens gate the submit button on `validateSchoolDraft` /
/// `validateUniversityDraft`, so reaching a build with a missing required field
/// means the validator and the body disagree. Failing loudly here surfaces that
/// instead of shipping a request the server will 400.
class IncompleteRegistrationDraft extends StateError {
  IncompleteRegistrationDraft(this.field)
      : super('Registration draft is missing required field "$field"');

  /// The contract field name (matches `ProblemDetails.errors` keys).
  final String field;
}

/// Unwraps a contract-required draft value, or throws [IncompleteRegistrationDraft].
T requireField<T>(T? value, String field) {
  if (value == null) throw IncompleteRegistrationDraft(field);
  return value;
}
