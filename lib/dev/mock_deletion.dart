/// Throwaway on-device preview data for account deletion - NOT production code.
///
/// Answers `POST /me/deletion-request` (`requestAccountDeletion`) and
/// `DELETE /me/deletion-request` (`cancelAccountDeletion`) -
/// `contract/openapi.yaml:1263`, both `x-stability: stable` - for
/// `lib/dev/mock_backend.dart`, which owns the request plumbing. This file
/// holds the state and the contract's rules; the interceptor turns a
/// [MockDeletionReply] into a Dio response.
///
/// **Strict where the server is strict**, per `mock_backend.dart`'s own rule:
/// - the request answers `202` with `{requestedAt, effectiveAt}`, `effectiveAt`
///   being `requestedAt` + 30 days, both UTC;
/// - a second request while one is pending is `409 deletion_already_requested`
///   and moves nothing - the window is the first one's;
/// - cancelling answers `204`; with nothing pending it is `404
///   no_pending_deletion`;
/// - `GET /me` carries `pendingDeletion: {effectiveAt}` while a request is
///   pending and **omits the key otherwise - never `null`**
///   (`openapi.yaml:4308`);
/// - **default-deny** (adr-114, `openapi.yaml:63-83`): while a request is
///   pending, every authenticated call outside the four-endpoint allowlist
///   answers `403 account_pending_deletion`.
///
/// **Nothing here changes the mock until a deletion is requested.** Before the
/// first `POST /me/deletion-request` the mock holds no request, [handle]
/// answers `null` for everything but the two operations, and
/// [decorateProfile] returns the profile untouched - so wiring this in alters
/// no existing walk. The pending state is per instance: one mock session (one
/// `buildMockDio`) keeps it, a fresh session starts without one.
///
/// What the real server also does at request time - revoke the session - is
/// NOT mimicked: the mock keeps answering with the same token, which is the
/// lenient side. It is the app's job to purge the token pair and sign the
/// student out on the `202`.
library;

/// What the mock answers, mapped by the interceptor onto its own `_ok` and
/// `_problem` helpers.
sealed class MockDeletionReply {
  const MockDeletionReply();
}

/// A success: [status] (`202` or `204`) and the JSON body, or `null` for `204`.
final class MockDeletionOk extends MockDeletionReply {
  const MockDeletionOk(this.status, this.data);

  final int status;
  final Map<String, Object?>? data;
}

/// A ProblemDetails: `409 deletion_already_requested`, `404
/// no_pending_deletion` or `403 account_pending_deletion`.
final class MockDeletionProblem extends MockDeletionReply {
  const MockDeletionProblem(this.status, this.code, this.detail);

  final int status;
  final String code;
  final String detail;
}

/// The grace window the contract defines: `effectiveAt` is `requestedAt` + 30
/// days.
const kMockDeletionGraceDays = 30;

/// One caller's deletion request. See the file header.
class MockAccountDeletion {
  /// [clock] is the time source, for a deterministic window.
  MockAccountDeletion({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  /// When the pending request was recorded (UTC), or `null` when none is.
  DateTime? _requestedAt;

  static const _path = '/me/deletion-request';

  /// The four authenticated endpoints a pending-deletion account may still
  /// reach (`openapi.yaml:66-70`), as `METHOD path`. Default-deny: an endpoint
  /// not on this list is blocked during grace.
  static const allowlist = <String>{
    'GET /me',
    'POST /me/deletion-request',
    'DELETE /me/deletion-request',
    'POST /auth/logout',
  };

  /// Path prefixes of the **anonymous** operations (`security: []`), which the
  /// rule cannot touch because they carry no principal (`openapi.yaml:74-80`):
  /// the whole sign-in / registration / refresh / recovery ladder, and the
  /// public `/reference/*` reads. A new authenticated operation under either
  /// prefix would have to be added to [allowlist] or it would be wrongly let
  /// through here.
  static const anonymousPrefixes = <String>['/auth/', '/reference/'];

  /// Whether a deletion request is pending.
  bool get isPending => _requestedAt != null;

  /// `{effectiveAt}` while a request is pending, else `null` - the value of
  /// `GET /me`'s `pendingDeletion`, whose key is ABSENT when this is `null`.
  Map<String, Object?>? get pendingDeletion {
    final requestedAt = _requestedAt;
    if (requestedAt == null) return null;
    return <String, Object?>{
      'effectiveAt': _effectiveAt(requestedAt).toIso8601String(),
    };
  }

  /// [profile] as `GET /me` should return it: with `pendingDeletion` added
  /// while a request is pending, and **the same map, untouched,** otherwise
  /// (the key is absent, never `null`).
  Map<String, dynamic> decorateProfile(Map<String, dynamic> profile) {
    final pending = pendingDeletion;
    if (pending == null) return profile;
    return <String, dynamic>{...profile, 'pendingDeletion': pending};
  }

  /// The reply for [method] + [path], or `null` to let the interceptor carry
  /// on. It is a reply when the route is one of the two deletion operations,
  /// and - **only while a request is pending** - when it is an authenticated
  /// call outside the allowlist (`403 account_pending_deletion`).
  MockDeletionReply? handle(String method, String path) {
    if (path == _path) {
      return switch (method) {
        'POST' => _request(),
        'DELETE' => _cancel(),
        _ => null,
      };
    }
    return _denied(method, path);
  }

  MockDeletionReply _request() {
    if (isPending) {
      return const MockDeletionProblem(
        409,
        'deletion_already_requested',
        'A deletion request is already pending.',
      );
    }
    final requestedAt = _clock().toUtc();
    _requestedAt = requestedAt;
    return MockDeletionOk(202, <String, Object?>{
      'requestedAt': requestedAt.toIso8601String(),
      'effectiveAt': _effectiveAt(requestedAt).toIso8601String(),
    });
  }

  MockDeletionReply _cancel() {
    if (!isPending) {
      return const MockDeletionProblem(
        404,
        'no_pending_deletion',
        'No deletion request is pending.',
      );
    }
    _requestedAt = null;
    return const MockDeletionOk(204, null);
  }

  MockDeletionReply? _denied(String method, String path) {
    // The whole rule, and the reason nothing changes before a request: with no
    // pending deletion this is `null` for every route.
    if (!isPending) return null;
    if (allowlist.contains('$method $path')) return null;
    if (anonymousPrefixes.any(path.startsWith)) return null;
    return const MockDeletionProblem(
      403,
      'account_pending_deletion',
      'The account has a pending deletion request.',
    );
  }

  static DateTime _effectiveAt(DateTime requestedAt) =>
      requestedAt.add(const Duration(days: kMockDeletionGraceDays));
}
