import 'package:flutter/foundation.dart';

/// The `POST /me/track-transfer` request body (`transferToUniversity`,
/// `x-stability: stable`, `openapi.yaml:1338`): move the caller's own account
/// from the School track to the University track, once.
///
/// The four keys are all `required` in the contract:
/// `universityId · facultyId · studyYearId · acknowledgeIrreversible`. The three
/// ids are picked inside the transfer flow from the same `/reference/universities`
/// lists and under the same rules as University registration (the faculty must
/// belong to the university, the study year must be an `active` year of that
/// faculty). Whether they are is the SERVER's call - an id that fails is a
/// `400 validation_failed` naming the field - so nothing here validates them.
///
/// ## Why this body is hand-written, not freezed
///
/// Because of `acknowledgeIrreversible`. The contract declares it
/// `{ type: boolean, const: true }`: it is the client's confirmation, on the
/// wire, that the student understood the transfer is permanent, and `false` or
/// absent is `validation_failed`. A generated `bool acknowledgeIrreversible`
/// would let any caller construct the body with `false`, or with a default the
/// student never agreed to. Here the key is not a constructor parameter at all:
/// [toJson] always writes `true`, and the only way to build the request is to
/// have reached the point where the second confirm was pressed. (Same call
/// `ProfileUpdate` makes for `email`, for the same class of reason: a generated
/// serializer cannot express the shape.)
///
/// The request is not a `components.schemas` entry - it is inline in the
/// operation - so `test/guards/contract_models_test.dart` cannot bind it;
/// `track_transfer_request_test.dart` reads the operation's own `required` list
/// instead.
///
/// Reference ids are catalogue data, not personal data, but [toString] is still
/// kept to the type name: nothing in the transfer flow is logged.
@immutable
class TrackTransferRequest {
  const TrackTransferRequest({
    required this.universityId,
    required this.facultyId,
    required this.studyYearId,
  });

  final String universityId;
  final String facultyId;
  final String studyYearId;

  /// Always `true`. A getter, not a field: there is no instance of this
  /// request that says otherwise.
  bool get acknowledgeIrreversible => true;

  /// Exactly the four contract keys, nothing else.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'universityId': universityId,
    'facultyId': facultyId,
    'studyYearId': studyYearId,
    'acknowledgeIrreversible': acknowledgeIrreversible,
  };

  @override
  bool operator ==(Object other) =>
      other is TrackTransferRequest &&
      other.universityId == universityId &&
      other.facultyId == facultyId &&
      other.studyYearId == studyYearId;

  @override
  int get hashCode => Object.hash(universityId, facultyId, studyYearId);

  @override
  String toString() => 'TrackTransferRequest';
}
