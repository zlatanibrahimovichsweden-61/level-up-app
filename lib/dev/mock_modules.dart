/// Throwaway on-device preview data for the subject picker's module overlay -
/// NOT production code.
///
/// Answers `GET /catalog/modules` (`listModules`, `contract/openapi.yaml:1685`,
/// `x-stability: stable`) for `lib/dev/mock_backend.dart`, which owns the
/// request plumbing and knows which track the mock session is. This file holds
/// the data and the contract's rules; the interceptor turns a
/// [MockModulesReply] into a Dio response. Nothing in the app consumes the
/// operation yet, so nothing needs this wired in today: it exists so the
/// repository has a contract-shaped server to be driven against, and so a
/// module picker built later can be walked.
///
/// **Everything below is MOCK SAMPLE DATA, not product copy.** The module names
/// are short invented English samples (the app writes no Arabic it was not
/// given); the real ones are admin-written and arrive from the server.
///
/// Faithful to the contract where it states a rule:
/// - **school students get `[]`**, a normal answer, not an error;
/// - the university answer is a bare array ordered by `displayOrder`, then
///   `name`. The fixtures are declared out of that order and two share a
///   `displayOrder`, so the sort - not the declaration order - is what is
///   served;
/// - `termId` and `termNumber` are nullable, and one module has neither (a
///   cohort with no schedule row); `subjectIds` may be empty, and one module's
///   is;
/// - a module is an overlay, never a scope: the same four subjects
///   `GET /catalog/subjects` serves to a university student are filed in at most
///   one module each, and one is filed in none of them here - the "All
///   subjects" view is the catalog itself, never an entry in this list.
///
/// **Coupling to `mock_backend.dart`:** the `subjectIds` below are the ids of
/// that file's four university subjects (`uni-anatomy`, `uni-physio`,
/// `uni-biochem`, `uni-histology`) and the term ids are the ones its mistakes
/// fixtures use. A test pins the subject ids against the live mock catalog.
library;

/// What the mock answers, in terms the interceptor maps onto its own `_ok`.
sealed class MockModulesReply {
  const MockModulesReply();
}

/// A `200` with the bare array.
final class MockModulesOk extends MockModulesReply {
  const MockModulesOk(this.data);

  final List<Map<String, dynamic>> data;
}

/// The id of module fixture number [n] (1-based, in DECLARATION order - not the
/// served order). Exposed so a test can name a module without hard-coding a
/// UUID.
String mockModuleId(int n) =>
    '6d000000-0000-4000-8000-${n.toRadixString(16).padLeft(12, '0')}';

/// The subject the fixtures file in no module, so the "All subjects" view is
/// the only place it appears.
const kMockUnfiledModuleSubject = 'uni-physio';

/// The mock's modules. Stateless: every request gets the same answer.
class MockModules {
  const MockModules();

  /// The reply for the modules route, or `null` when [method] + [path] is not
  /// it (so the interceptor keeps looking). [university] is the mock session's
  /// track: a school session gets `[]`.
  MockModulesReply? handle(
    String method,
    String path, {
    required bool university,
  }) {
    if (method != 'GET' || path != '/catalog/modules') return null;
    if (!university) return const MockModulesOk([]);

    final sorted = [..._fixtures]
      ..sort((a, b) {
        final byOrder = (a['displayOrder']! as int).compareTo(
          b['displayOrder']! as int,
        );
        return byOrder != 0
            ? byOrder
            : (a['name']! as String).compareTo(b['name']! as String);
      });
    return MockModulesOk(sorted);
  }
}

Map<String, dynamic> _module(
  int n,
  String name,
  int displayOrder, {
  String? termId,
  int? termNumber,
  List<String> subjectIds = const [],
}) => <String, dynamic>{
  'id': mockModuleId(n),
  'name': name,
  'displayOrder': displayOrder,
  // Sent explicitly as null rather than omitted: the client models them as
  // optional-AND-nullable, and the tolerant reading should be exercised.
  'termId': termId,
  'termNumber': termNumber,
  'subjectIds': subjectIds,
};

/// Declared out of served order on purpose: #3 and #2 share `displayOrder` 2 and
/// sort by name ("Microscopic Studies" before "Molecular Biology"), #4 has no
/// term and no subjects, and `uni-physio` is filed in none of them.
final List<Map<String, dynamic>> _fixtures = [
  _module(
    1,
    'Basic Sciences',
    1,
    termId: 'term-01HZY0',
    termNumber: 1,
    subjectIds: const ['uni-anatomy'],
  ),
  _module(
    2,
    'Molecular Biology',
    2,
    termId: 'term-01HZY1',
    termNumber: 2,
    subjectIds: const ['uni-biochem'],
  ),
  _module(
    3,
    'Microscopic Studies',
    2,
    termId: 'term-01HZY1',
    termNumber: 2,
    subjectIds: const ['uni-histology'],
  ),
  _module(4, 'Electives', 3),
];
