/// Throwaway on-device preview data for the Track transfer - NOT production
/// code.
///
/// Answers the one operation the transfer data layer calls - `POST
/// /me/track-transfer` (`transferToUniversity`, `contract/openapi.yaml:1338`,
/// `x-stability: stable`) - for `lib/dev/mock_backend.dart`, which owns the
/// request plumbing AND the session's track, profile and reference lists. This
/// file holds the contract's rules; the interceptor turns a
/// [MockTrackTransferReply] into a Dio response and, on [MockTrackTransferDone],
/// flips its own track. It follows `mock_support.dart`'s shape on purpose.
///
/// The desk owns no student state. The caller passes in what the server would
/// already know - the session's `track`, its school `stage`, and the reference
/// `universities` - so the rules below are decided against the SAME data
/// `GET /me` and `/reference/universities` serve, never a private copy.
///
/// Strict where the server is strict, in the contract's own order of refusals
/// (`openapi.yaml:1370`): `403 account_pending_deletion` first (a state this
/// harness does not model), then
/// 1. `409 track_transfer_not_allowed` - the session is already University;
/// 2. `403 track_transfer_not_eligible` - a School student whose stage is not
///    `secondary3` (and one whose stage is unknown, which cannot be proven
///    eligible);
/// 3. `400 validation_failed`, naming the field: an id that is missing or not a
///    UUID, an unknown university, a faculty outside that university, a study
///    year that is not an `active` year of that faculty (`soon` is refused), or
///    `acknowledgeIrreversible` missing or not `true`.
///
/// A refused call changes nothing - the desk keeps no state, so that holds by
/// construction. A success answers [MockTrackTransferDone] carrying the
/// University block (`university`, `faculty`, `yearNumber`) the student just
/// chose, for the interceptor to put into the profile it returns.
///
/// No student, phone number or e-mail address appears anywhere in this file.
library;

/// What the mock answers, in terms the interceptor maps onto its own `_ok`,
/// `_validationFailed` and `_problem` helpers.
sealed class MockTrackTransferReply {
  const MockTrackTransferReply();
}

/// The transfer is accepted. [university] is the profile's `university` block
/// for the chosen university, faculty and study year; the interceptor flips its
/// track to University and answers `200` with the University profile.
final class MockTrackTransferDone extends MockTrackTransferReply {
  const MockTrackTransferDone(this.university);

  final Map<String, dynamic> university;
}

/// `400 validation_failed` carrying the contract's `field -> [messages]` map.
final class MockTrackTransferValidation extends MockTrackTransferReply {
  const MockTrackTransferValidation(this.errors);

  final Map<String, List<String>> errors;
}

/// Any other ProblemDetails: `409 track_transfer_not_allowed`,
/// `403 track_transfer_not_eligible`.
final class MockTrackTransferProblem extends MockTrackTransferReply {
  const MockTrackTransferProblem(this.status, this.code, this.detail);

  final int status;
  final String code;
  final String detail;
}

/// The only stage the contract lets transfer (`openapi.yaml:1353`).
const kMockTransferEligibleStage = 'secondary3';

/// The transfer rules of a mock session. See the file header.
class MockTrackTransferDesk {
  static final _uuid = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
    r'[0-9a-fA-F]{12}$',
  );

  /// The reply for `POST /me/track-transfer`, or `null` when [method] + [path]
  /// is not that route (so the interceptor keeps looking).
  ///
  /// [track] is the session's current track (`school` or `university`), [stage]
  /// the school stage `GET /me` reports (`null` on University or when
  /// unknown), and [universities] the `/reference/universities` rows
  /// (`university -> faculties -> years`) the mock serves.
  MockTrackTransferReply? handle(
    String method,
    String path,
    Map<String, dynamic> body, {
    required String track,
    required String? stage,
    required List<dynamic> universities,
  }) {
    if (method != 'POST' || path != '/me/track-transfer') return null;

    if (track == 'university') {
      return const MockTrackTransferProblem(
        409,
        'track_transfer_not_allowed',
        'The account is already on the University track',
      );
    }
    if (stage != kMockTransferEligibleStage) {
      return const MockTrackTransferProblem(
        403,
        'track_transfer_not_eligible',
        'Only a student in the final school year can transfer',
      );
    }

    final errors = <String, List<String>>{};
    final universityId = _uuidOrNull(body['universityId']);
    final facultyId = _uuidOrNull(body['facultyId']);
    final studyYearId = _uuidOrNull(body['studyYearId']);
    if (universityId == null) errors['universityId'] = ['Must be a UUID.'];
    if (facultyId == null) errors['facultyId'] = ['Must be a UUID.'];
    if (studyYearId == null) errors['studyYearId'] = ['Must be a UUID.'];
    if (body['acknowledgeIrreversible'] != true) {
      errors['acknowledgeIrreversible'] = ['Must be true.'];
    }

    Map<String, dynamic>? university;
    Map<String, dynamic>? faculty;
    Map<String, dynamic>? year;
    if (universityId != null) {
      university = _byId(universities, universityId);
      if (university == null) {
        errors['universityId'] = ['No such university.'];
      } else if (facultyId != null) {
        faculty = _byId(
          university['faculties'] as List<dynamic>? ?? const [],
          facultyId,
        );
        if (faculty == null) {
          errors['facultyId'] = ['Not a faculty of this university.'];
        } else if (studyYearId != null) {
          year = _byId(
            faculty['years'] as List<dynamic>? ?? const [],
            studyYearId,
          );
          if (year == null || year['status'] != 'active') {
            errors['studyYearId'] = [
              'Not an active study year of this faculty.',
            ];
          }
        }
      }
    }
    if (errors.isNotEmpty) return MockTrackTransferValidation(errors);

    // No errors means all three resolved.
    return MockTrackTransferDone(<String, dynamic>{
      'university': _namedRef(university!),
      'faculty': _namedRef(faculty!),
      'yearNumber': year!['yearNumber'],
    });
  }

  static String? _uuidOrNull(Object? value) =>
      value is String && _uuid.hasMatch(value) ? value : null;

  static Map<String, dynamic>? _byId(List<dynamic> rows, String id) {
    for (final row in rows) {
      if (row is Map<String, dynamic> && row['id'] == id) return row;
    }
    return null;
  }

  /// A `NamedRef` (`id`, `nameAr`, `nameEn`) from a reference row.
  static Map<String, dynamic> _namedRef(Map<String, dynamic> row) =>
      <String, dynamic>{
        'id': row['id'],
        'nameAr': row['nameAr'],
        'nameEn': row['nameEn'],
      };
}
