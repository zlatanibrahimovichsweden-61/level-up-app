/// The `POST /auth/register` request body, discriminated on `track`.
///
/// The contract models this as `oneOf: [SchoolRegistration, UniversityRegistration]`
/// with `discriminator.propertyName: track`. The two shapes are genuinely
/// different (university has NO `countryCode` — Egypt-only by shape, adr-010),
/// so they are two independent freezed classes rather than one union; this
/// interface is what lets the repository take either.
library;

import 'registration_draft.dart';

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

/// The mirror of [IncompleteRegistrationDraft]: a draft carries a field the
/// contract FORBIDS in this combination. Also a programming error — the
/// cascade-clearing setters and the validator are supposed to make it
/// unreachable — so it fails loudly here rather than becoming a server 400.
class ForbiddenRegistrationField extends StateError {
  ForbiddenRegistrationField(this.field, String because)
      : super('Registration draft carries forbidden field "$field": $because');

  /// The contract field name (matches `ProblemDetails.errors` keys).
  final String field;
}

/// Throws if [value] is present. [because] states the contract rule violated.
void forbidField(Object? value, String field, String because) {
  if (value == null) return;
  if (value is String && value.trim().isEmpty) return;
  throw ForbiddenRegistrationField(field, because);
}

/// The adr-028 §1 city union, resolved once for both track bodies.
///
/// The contract (`openapi.yaml:1272-1273`, `:1281-1283`, `:1300-1301`,
/// `:1306-1308`) takes `cityId` OR `cityName`, at least one, and answers
/// `validation_failed` if both arrive. Exactly one key is returned; the other is
/// null, and `includeIfNull: false` on both then OMITS it. **Omission and null
/// are not the same thing on this wire** — see the note at
/// `school_registration.dart:19-21`.
///
/// `both` is thrown rather than resolved by preferring one side: silently
/// dropping whichever the student did not mean would submit the wrong city, and
/// the UI already makes the pair mutually exclusive (each setter clears the
/// other), so reaching here with both is a cascade bug worth surfacing.
({String? cityId, String? cityName}) cityUnionFromDraft(
  RegistrationDraft draft,
) {
  final coded = draft.cityId?.trim();
  final free = draft.cityName?.trim();
  final hasCoded = coded != null && coded.isNotEmpty;
  final hasFree = free != null && free.isNotEmpty;

  if (hasCoded && hasFree) {
    throw ForbiddenRegistrationField(
      'cityName',
      'cityId is also set — the contract accepts exactly one (adr-028 §1)',
    );
  }
  if (!hasCoded && !hasFree) {
    // Neither: the same failure as any other missing contract-required value.
    // Reported against `cityId`, the field the pickers and the server's own
    // field map name first.
    throw IncompleteRegistrationDraft('cityId');
  }

  return (
    cityId: hasCoded ? coded : null,
    // maxLength 100 (openapi.yaml:1273). The field already caps input at 100,
    // so this only guards a draft that reached here another way; truncating
    // keeps a long value submittable rather than failing the whole
    // registration on a field that must never block one.
    cityName: hasFree ? (free.length > 100 ? free.substring(0, 100) : free) : null,
  );
}
